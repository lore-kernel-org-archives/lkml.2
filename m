Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2FFP4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:56:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab2FFPzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755333"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/7] affs: get rid of affs_sync_super
Date: Wed,  6 Jun 2012 18:56:57 +0300
Message-Id: <1338998217-5010-8-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch makes affs stop using the VFS '->write_super()' method along with
the 's_dirt' superblock flag, because they are on their way out.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds and
writes out all dirty superblocks using the '->write_super()' call-back.  But the
problem with this thread is that it wastes power by waking up the system every
5 seconds, even if there are no diry superblocks, or there are no client
file-systems which would need this (e.g., btrfs does not use
'->write_super()'). So we want to kill it completely and thus, we need to make
file-systems to stop using the '->write_super()' VFS service, and then remove
it together with the kernel thread.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/affs.h   |    6 ++++++
 fs/affs/bitmap.c |    4 ++--
 fs/affs/super.c  |   48 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 5a726e9..3a130e2 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -3,6 +3,7 @@
 #include <linux/buffer_head.h>
 #include <linux/amigaffs.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 
 /* AmigaOS allows file names with up to 30 characters length.
  * Names longer than that will be silently truncated. If you
@@ -101,6 +102,9 @@ struct affs_sb_info {
 	char s_volume[32];		/* Volume prefix for absolute symlinks. */
 	spinlock_t symlink_lock;	/* protects the previous two */
 	struct super_block *sb;		/* the VFS superblock object */
+	int work_queued;		/* non-zero delayed work is queued */
+	struct delayed_work sb_work;	/* superblock flush delayed work */
+	spinlock_t work_lock;		/* protects sb_work and work_queued */
 };
 
 #define SF_INTL		0x0001		/* International filesystem. */
@@ -121,6 +125,8 @@ static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+void affs_mark_sb_dirty(struct super_block *sb);
+
 /* amigaffs.c */
 
 extern int	affs_insert_hash(struct inode *inode, struct buffer_head *bh);
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 3e26271..6e0be43 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -103,7 +103,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp - mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	affs_mark_sb_dirty(sb);
 	bm->bm_free++;
 
 	mutex_unlock(&sbi->s_bmlock);
@@ -248,7 +248,7 @@ find_bit:
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp + mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	affs_mark_sb_dirty(sb);
 
 	mutex_unlock(&sbi->s_bmlock);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0496cbb..c70f1e5 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -17,6 +17,7 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/writeback.h>
 #include "affs.h"
 
 extern struct timezone sys_tz;
@@ -47,6 +48,7 @@ affs_put_super(struct super_block *sb)
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	pr_debug("AFFS: put_super()\n");
 
+	cancel_delayed_work_sync(&sbi->sb_work);
 	kfree(sbi->s_prefix);
 	affs_free_bitmap(sb);
 	affs_brelse(sbi->s_root_bh);
@@ -54,23 +56,45 @@ affs_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 }
 
-static void
-affs_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		affs_commit_super(sb, 1);
-	sb->s_dirt = 0;
-	pr_debug("AFFS: write_super() at %lu, clean=2\n", get_seconds());
-}
-
 static int
 affs_sync_fs(struct super_block *sb, int wait)
 {
 	affs_commit_super(sb, wait);
-	sb->s_dirt = 0;
 	return 0;
 }
 
+static void flush_superblock(struct work_struct *work)
+{
+	struct affs_sb_info *sbi;
+	struct super_block *sb;
+
+	sbi = container_of(work, struct affs_sb_info, sb_work.work);
+	sb = sbi->sb;
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->work_lock);
+
+	affs_commit_super(sb, 1);
+}
+
+void affs_mark_sb_dirty(struct super_block *sb)
+{
+	struct affs_sb_info *sbi = AFFS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+	       return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+	       queue_delayed_work(system_long_wq, &sbi->sb_work, delay);
+	       sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->work_lock);
+}
+
 static struct kmem_cache * affs_inode_cachep;
 
 static struct inode *affs_alloc_inode(struct super_block *sb)
@@ -132,7 +156,6 @@ static const struct super_operations affs_sops = {
 	.write_inode	= affs_write_inode,
 	.evict_inode	= affs_evict_inode,
 	.put_super	= affs_put_super,
-	.write_super	= affs_write_super,
 	.sync_fs	= affs_sync_fs,
 	.statfs		= affs_statfs,
 	.remount_fs	= affs_remount,
@@ -302,6 +325,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->sb = sb;
 	mutex_init(&sbi->s_bmlock);
 	spin_lock_init(&sbi->symlink_lock);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sb_work, flush_superblock);
 
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,
@@ -526,6 +551,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return -EINVAL;
 	}
 
+	flush_delayed_work_sync(&sbi->sb_work);
 	replace_mount_options(sb, new_opts);
 
 	sbi->s_flags = mount_flags;
-- 
1.7.7.6

