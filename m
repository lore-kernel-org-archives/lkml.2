Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0FOB2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:28:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:24297 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0FOB2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,417,1272870000"; 
   d="scan'208";a="807977495"
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
In-Reply-To: <20100612082757.7238224f.akpm@linux-foundation.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	 <20100601145126.f46572d1.akpm@linux-foundation.org>
	 <87ocftyfnh.fsf@basil.nowhere.org>
	 <20100609153654.0061e9c8.akpm@linux-foundation.org>
	 <1276189574.2385.32.camel@mudge.jf.intel.com>
	 <20100611145219.017a87c0.akpm@linux-foundation.org>
	 <1276294003.2385.48.camel@mudge.jf.intel.com>
	 <20100611152620.97bc3e59.akpm@linux-foundation.org>
	 <1276298999.2385.71.camel@mudge.jf.intel.com>
	 <20100611165425.e21697c2.akpm@linux-foundation.org>
	 <20100612073639.GA15974@basil.fritz.box>
	 <20100612082757.7238224f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 18:24:54 -0700
Message-ID: <1276565094.2385.128.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I have tweaked your patch a bit and put in your suggestion of
implementing a percpu_counter_compare (see below), which
allowed for accurate but fast comparison.  This
is just meant for discussion so I have not broken
it into two patches (the percpu_counter part and shmem part).

One thing still bothers me with this approach:
When we are doing a remount of tmpfs, we cannot lock the
percpu_counter.  So we cannot guarantee that it won't get updated
after we read it.  So we could overshoot 
the new quota after a remount, or missed accounting for the
pages being returned while we remount.  Is this tolerable?

My previous qtoken implementation uses a special value (-1) 
to denote that the per cpu cache is disabled and synchronized access
by the lock on the whole counter.  So I didn't have to worry
that my count was inaccurate. This facility to lock access and freeze
counter update is not available in current percpu_counter
implementation.

Tim


diff --git a/include/linux/percpu_counter.h
b/include/linux/percpu_counter.h
index c88d67b..8a7d510 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -40,6 +40,7 @@ void percpu_counter_destroy(struct percpu_counter
*fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32
batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64
amount)
 {
@@ -98,6 +99,16 @@ static inline void percpu_counter_set(struct
percpu_counter *fbc, s64 amount)
 	fbc->count = amount;
 }
 
+static inline int percpu_counter_compare(struct percpu_counter *fbc,
s64 rhs)
+{
+	if (fbc->count > rhs)
+		return 1;
+	else if (fbc->count < rhs)
+		return -1;
+	else
+		return 0;
+}
+
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e164291..d01d69e 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -3,6 +3,7 @@
 
 #include <linux/swap.h>
 #include <linux/mempolicy.h>
+#include <linux/percpu_counter.h>
 
 /* inode in-kernel data */
 
@@ -23,7 +24,7 @@ struct shmem_inode_info {
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	unsigned long free_blocks;  /* How many are left for allocation */
+	struct percpu_counter free_blocks;  /* How many are left for
allocation */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index aeaa6d7..583841d 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -137,6 +137,33 @@ static int __cpuinit
percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+/* 
+ * Compare counter against given value. 
+ * Return 1 if greater, 0 if equal and -1 if less
+ */ 
+int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+{
+	s64	count;
+
+	count = percpu_counter_read(fbc);
+	/* Check to see if approx count will be sufficient for comparison */
+        if (abs(count - rhs) >
(percpu_counter_batch*num_online_cpus())){
+		if (count > rhs)
+			return 1;
+		else
+			return -1;
+	}
+	/* Need to use more precise count */
+	count = percpu_counter_sum(fbc);
+	if (count > rhs)
+		return 1;
+	else if (count < rhs)
+		return -1;
+	else
+		return 0;
+}
+EXPORT_SYMBOL(percpu_counter_compare);
+
 static int __init percpu_counter_startup(void)
 {
 	compute_batch_value();
diff --git a/mm/shmem.c b/mm/shmem.c
index eef4ebe..7cd4f24 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/percpu_counter.h>
 #include <linux/swap.h>
 
 static struct vfsmount *shm_mnt;
@@ -233,8 +234,8 @@ static void shmem_free_blocks(struct inode *inode,
long pages)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
+		percpu_counter_add(&sbinfo->free_blocks, pages);
 		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks += pages;
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
 		spin_unlock(&sbinfo->stat_lock);
 	}
@@ -422,11 +423,11 @@ static swp_entry_t *shmem_swp_alloc(struct
shmem_inode_info *info, unsigned long
 		 */
 		if (sbinfo->max_blocks) {
 			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks <= 1) {
+			if (percpu_counter_compare(&sbinfo->free_blocks, 1) <= 0) {
 				spin_unlock(&sbinfo->stat_lock);
 				return ERR_PTR(-ENOSPC);
 			}
-			sbinfo->free_blocks--;
+			percpu_counter_dec(&sbinfo->free_blocks);
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&sbinfo->stat_lock);
 		}
@@ -1386,14 +1387,14 @@ repeat:
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
 			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks == 0 ||
+			if ((percpu_counter_compare(&sbinfo->free_blocks, 0) <= 0) ||
 			    shmem_acct_block(info->flags)) {
 				spin_unlock(&sbinfo->stat_lock);
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
 				goto failed;
 			}
-			sbinfo->free_blocks--;
+			percpu_counter_dec(&sbinfo->free_blocks);
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&sbinfo->stat_lock);
 		} else if (shmem_acct_block(info->flags)) {
@@ -1794,7 +1795,8 @@ static int shmem_statfs(struct dentry *dentry,
struct kstatfs *buf)
 	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
+		buf->f_bavail = buf->f_bfree =
+				percpu_counter_sum(&sbinfo->free_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
@@ -2258,7 +2260,7 @@ static int shmem_remount_fs(struct super_block
*sb, int *flags, char *data)
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
+	blocks = sbinfo->max_blocks -
percpu_counter_sum(&sbinfo->free_blocks);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
 	if (config.max_blocks < blocks)
 		goto out;
@@ -2277,7 +2279,7 @@ static int shmem_remount_fs(struct super_block
*sb, int *flags, char *data)
 
 	error = 0;
 	sbinfo->max_blocks  = config.max_blocks;
-	sbinfo->free_blocks = config.max_blocks - blocks;
+	percpu_counter_init(&sbinfo->free_blocks, config.max_blocks - blocks);
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
@@ -2352,7 +2354,7 @@ int shmem_fill_super(struct super_block *sb, void
*data, int silent)
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->free_blocks = sbinfo->max_blocks;
+	percpu_counter_init(&sbinfo->free_blocks, sbinfo->max_blocks);
 	sbinfo->free_inodes = sbinfo->max_inodes;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;


