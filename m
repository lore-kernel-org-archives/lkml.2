Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0ERXgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:36:16 -0400
Received: from mga06.intel.com ([134.134.136.21]:58244 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754109Ab0ERXgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="622816134"
Subject: [PATCH 2/2] tmpfs: Make tmpfs scalable with caches for free blocks
From: tim <tim.c.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 16:34:32 -0700
Message-ID: <1274225672.31973.8951.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of tmpfs is not scalable.
The stat_lock is contended whenever we need to get a 
new page, leading to lots of lock contentions.  This patch  
makes use of the qtoken library to maintain local
caches of free pages to speed up getting and returning
of pages without acquisition of stat_lock.  It
improved the performance of tmpfs by 270% for Aim7 fserver
workload.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
 include/linux/shmem_fs.h |    4 ++-
 mm/shmem.c               |   58 +++++++++++++++++++++++++--------------------
 2 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e164291..6ba014d 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -3,10 +3,12 @@
 
 #include <linux/swap.h>
 #include <linux/mempolicy.h>
+#include <linux/qtoken.h>
 
 /* inode in-kernel data */
 
 #define SHMEM_NR_DIRECT 16
+#define SHMEM_FREE_BLK_CACHE_SZ 512
 
 struct shmem_inode_info {
 	spinlock_t		lock;
@@ -23,7 +25,7 @@ struct shmem_inode_info {
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	unsigned long free_blocks;  /* How many are left for allocation */
+	struct qtoken token_jar;    /* Token jar of free blocks */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
diff --git a/mm/shmem.c b/mm/shmem.c
index eef4ebe..0ff3b73 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/qtoken.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -233,10 +234,10 @@ static void shmem_free_blocks(struct inode *inode, long pages)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks += pages;
+		spin_lock(&inode->i_lock);
+		qtoken_return(&sbinfo->token_jar, pages);
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-		spin_unlock(&sbinfo->stat_lock);
+		spin_unlock(&inode->i_lock);
 	}
 }
 
@@ -416,19 +417,18 @@ static swp_entry_t *shmem_swp_alloc(struct shmem_inode_info *info, unsigned long
 		if (sgp == SGP_READ)
 			return shmem_swp_map(ZERO_PAGE(0));
 		/*
-		 * Test free_blocks against 1 not 0, since we have 1 data
-		 * page (and perhaps indirect index pages) yet to allocate:
+		 * leave 1 pg in reserve in token jar, since we have
+		 * 1 data pg (and perhaps indirect index pages) yet to allocate:
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks <= 1) {
-				spin_unlock(&sbinfo->stat_lock);
+			spin_lock(&inode->i_lock);
+			if (qtoken_get(&sbinfo->token_jar, 1, 1) == 0) {
+				spin_unlock(&inode->i_lock);
 				return ERR_PTR(-ENOSPC);
 			}
-			sbinfo->free_blocks--;
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		}
 
 		spin_unlock(&info->lock);
@@ -1385,17 +1385,20 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks == 0 ||
-			    shmem_acct_block(info->flags)) {
-				spin_unlock(&sbinfo->stat_lock);
+			if (shmem_acct_block(info->flags)) {
+				spin_unlock(&info->lock);
+				error = -ENOSPC;
+				goto failed;
+			}
+			spin_lock(&inode->i_lock);
+			if (qtoken_get(&sbinfo->token_jar, 1, 0) == 0) {
+				spin_unlock(&inode->i_lock);
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
 				goto failed;
 			}
-			sbinfo->free_blocks--;
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		} else if (shmem_acct_block(info->flags)) {
 			spin_unlock(&info->lock);
 			error = -ENOSPC;
@@ -1794,7 +1797,7 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
+		buf->f_bavail = buf->f_bfree = qtoken_avail(&sbinfo->token_jar);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
@@ -2250,7 +2253,6 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 	struct shmem_sb_info config = *sbinfo;
-	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
@@ -2258,12 +2260,6 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
-	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (config.max_blocks < blocks)
-		goto out;
-	if (config.max_inodes < inodes)
-		goto out;
 	/*
 	 * Those tests also disallow limited->unlimited while any are in
 	 * use, so i_blocks will always be zero when max_blocks is zero;
@@ -2274,10 +2270,14 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 		goto out;
 	if (config.max_inodes && !sbinfo->max_inodes)
 		goto out;
+	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
+	if (config.max_inodes < inodes)
+		goto out;
+	if (!qtoken_resize(&sbinfo->token_jar, config.max_blocks))
+		goto out;
 
 	error = 0;
 	sbinfo->max_blocks  = config.max_blocks;
-	sbinfo->free_blocks = config.max_blocks - blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
@@ -2310,6 +2310,10 @@ static int shmem_show_options(struct seq_file *seq, struct vfsmount *vfs)
 
 static void shmem_put_super(struct super_block *sb)
 {
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	if (sbinfo)
+		qtoken_put(&sbinfo->token_jar);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -2352,8 +2356,10 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->free_blocks = sbinfo->max_blocks;
 	sbinfo->free_inodes = sbinfo->max_inodes;
+	if (!qtoken_init(&sbinfo->token_jar, sbinfo->max_blocks,
+				SHMEM_FREE_BLK_CACHE_SZ))
+		goto failed;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
 	sb->s_blocksize = PAGE_CACHE_SIZE;


