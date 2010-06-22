Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0FVQ40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:56:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:59473 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab0FVQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,461,1272870000"; 
   d="scan'208";a="632601830"
Subject: Re: [PATCH v3 2/2] tmpfs: Make tmpfs scalable with percpu_counter
 for used blocks
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>, yanmin.zhang@intel.com
In-Reply-To: <20100621131802.c2f45c82.akpm@linux-foundation.org>
References: <1276818993.9661.82.camel@schen9-DESK>
	 <20100621131802.c2f45c82.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 09:52:18 -0700
Message-ID: <1277225538.5150.39.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 13:18 -0700, Andrew Morton wrote:

> 
> It'd be good if the changelog were to mention the inaccuracy issues. 
> Describe their impact, if any.
> 
> Are you actually happy with this overall approach?
> 
...
> This could actually use percpu_counter_compare()?
> 
> >  		goto out;
> >  	if (config.max_inodes < inodes)
> >  		goto out;
> 

Andrew,

I've updated the change log of this patch and modified the code using
the percpu_counter_compare for the above comparison.

Tim

----

The current implementation of tmpfs is not scalable.
We found that stat_lock is contended by multiple threads
when we need to get a new page, leading to useless spinning
inside this spin lock.  

This patch makes use of the percpu_counter library to maintain local
count of used blocks to speed up getting and returning
of pages.  So the acquisition of stat_lock is unnecessary
for getting and returning blocks, improving the performance 
of tmpfs on system with large number of cpus.  On a 4 socket
32 core NHM-EX system, we saw improvement of 270%.

The implementation below has a slight chance of race between threads
causing a slight overshoot of the maximum configured blocks.  However,
any overshoot is small, and is bounded by the number of cpus. This
happens when the number of used blocks is slightly below the maximum
configured blocks when a thread checks the used block count, and another
thread allocates the last block before the current thread does.  This
should not be a problem for tmpfs, as the overshoot is most likely to be
a few blocks and bounded.  If a strict limit is really desired, then
configured the max blocks to be the limit less the number of cpus in
system.    

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
 include/linux/shmem_fs.h |    3 ++-
 mm/shmem.c               |   40 +++++++++++++++++-----------------------
 2 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e164291..399be5a 100644
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
+	struct percpu_counter used_blocks;  /* How many are allocated */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
diff --git a/mm/shmem.c b/mm/shmem.c
index eef4ebe..ba94c91 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/percpu_counter.h>
 #include <linux/swap.h>
 
 static struct vfsmount *shm_mnt;
@@ -233,10 +234,10 @@ static void shmem_free_blocks(struct inode *inode, long pages)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks += pages;
+		percpu_counter_add(&sbinfo->used_blocks, -pages);
+		spin_lock(&inode->i_lock);
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-		spin_unlock(&sbinfo->stat_lock);
+		spin_unlock(&inode->i_lock);
 	}
 }
 
@@ -416,19 +417,17 @@ static swp_entry_t *shmem_swp_alloc(struct shmem_inode_info *info, unsigned long
 		if (sgp == SGP_READ)
 			return shmem_swp_map(ZERO_PAGE(0));
 		/*
-		 * Test free_blocks against 1 not 0, since we have 1 data
+		 * Test used_blocks against 1 less max_blocks, since we have 1 data
 		 * page (and perhaps indirect index pages) yet to allocate:
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks <= 1) {
-				spin_unlock(&sbinfo->stat_lock);
+			if (percpu_counter_compare(&sbinfo->used_blocks, (sbinfo->max_blocks - 1)) > 0)
 				return ERR_PTR(-ENOSPC);
-			}
-			sbinfo->free_blocks--;
+			percpu_counter_inc(&sbinfo->used_blocks);
+			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		}
 
 		spin_unlock(&info->lock);
@@ -1385,17 +1384,16 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks == 0 ||
+			if ((percpu_counter_compare(&sbinfo->used_blocks, sbinfo->max_blocks) > 0) ||
 			    shmem_acct_block(info->flags)) {
-				spin_unlock(&sbinfo->stat_lock);
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
 				goto failed;
 			}
-			sbinfo->free_blocks--;
+			percpu_counter_inc(&sbinfo->used_blocks);
+			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		} else if (shmem_acct_block(info->flags)) {
 			spin_unlock(&info->lock);
 			error = -ENOSPC;
@@ -1791,17 +1789,16 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = TMPFS_MAGIC;
 	buf->f_bsize = PAGE_CACHE_SIZE;
 	buf->f_namelen = NAME_MAX;
-	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
+		buf->f_bavail = buf->f_bfree =
+				sbinfo->max_blocks - percpu_counter_sum(&sbinfo->used_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
 		buf->f_ffree = sbinfo->free_inodes;
 	}
 	/* else leave those fields 0 like simple_statfs */
-	spin_unlock(&sbinfo->stat_lock);
 	return 0;
 }
 
@@ -2250,7 +2247,6 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 	struct shmem_sb_info config = *sbinfo;
-	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
@@ -2258,9 +2254,8 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (config.max_blocks < blocks)
+	if (percpu_counter_compare(&sbinfo->used_blocks, config.max_blocks) > 0)
 		goto out;
 	if (config.max_inodes < inodes)
 		goto out;
@@ -2277,7 +2272,6 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 
 	error = 0;
 	sbinfo->max_blocks  = config.max_blocks;
-	sbinfo->free_blocks = config.max_blocks - blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
@@ -2352,7 +2346,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->free_blocks = sbinfo->max_blocks;
+	percpu_counter_init(&sbinfo->used_blocks, 0);
 	sbinfo->free_inodes = sbinfo->max_inodes;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;


