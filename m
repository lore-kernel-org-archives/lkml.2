Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161192Ab2GLOZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:25:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:42574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161142Ab2GLOY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121595888"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 4/4] hfsplus: get rid of write_super
Date: Thu, 12 Jul 2012 17:26:31 +0300
Message-Id: <1342103191-17406-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
References: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch makes hfsplus stop using the VFS '->write_super()' method along with
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

Tested using fsstress from the LTP project.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfsplus/bitmap.c     |    4 ++--
 fs/hfsplus/dir.c        |    2 +-
 fs/hfsplus/hfsplus_fs.h |    6 +++++-
 fs/hfsplus/inode.c      |    6 +++---
 fs/hfsplus/super.c      |   41 ++++++++++++++++++++++++++++++++---------
 5 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/fs/hfsplus/bitmap.c b/fs/hfsplus/bitmap.c
index 1cad80c..4cfbe2e 100644
--- a/fs/hfsplus/bitmap.c
+++ b/fs/hfsplus/bitmap.c
@@ -153,7 +153,7 @@ done:
 	kunmap(page);
 	*max = offset + (curr - pptr) * 32 + i - start;
 	sbi->free_blocks -= *max;
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 	dprint(DBG_BITMAP, "-> %u,%u\n", start, *max);
 out:
 	mutex_unlock(&sbi->alloc_mutex);
@@ -228,7 +228,7 @@ out:
 	set_page_dirty(page);
 	kunmap(page);
 	sbi->free_blocks += len;
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 	mutex_unlock(&sbi->alloc_mutex);
 
 	return 0;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 26b53fb..8375504 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -316,7 +316,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	sbi->file_count++;
-	dst_dir->i_sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(dst_dir->i_sb);
 out:
 	mutex_unlock(&sbi->vh_mutex);
 	return res;
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 66a9365..558dbb4 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -153,8 +153,11 @@ struct hfsplus_sb_info {
 	gid_t gid;
 
 	int part, session;
-
 	unsigned long flags;
+
+	int work_queued;               /* non-zero delayed work is queued */
+	struct delayed_work sync_work; /* FS sync delayed work */
+	spinlock_t work_lock;          /* protects sync_work and work_queued */
 };
 
 #define HFSPLUS_SB_WRITEBACKUP	0
@@ -428,6 +431,7 @@ int hfsplus_show_options(struct seq_file *, struct dentry *);
 
 /* super.c */
 struct inode *hfsplus_iget(struct super_block *, unsigned long);
+void hfsplus_mark_mdb_dirty(struct super_block *sb);
 
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 82b69ee..ad1f16f 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -431,7 +431,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, umode_t mode)
 		sbi->file_count++;
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 
 	return inode;
 }
@@ -442,7 +442,7 @@ void hfsplus_delete_inode(struct inode *inode)
 
 	if (S_ISDIR(inode->i_mode)) {
 		HFSPLUS_SB(sb)->folder_count--;
-		sb->s_dirt = 1;
+		hfsplus_mark_mdb_dirty(sb);
 		return;
 	}
 	HFSPLUS_SB(sb)->file_count--;
@@ -455,7 +455,7 @@ void hfsplus_delete_inode(struct inode *inode)
 		inode->i_size = 0;
 		hfsplus_file_truncate(inode);
 	}
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 }
 
 void hfsplus_inode_read_fork(struct inode *inode, struct hfsplus_fork_raw *fork)
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index f4f3d54..4733320 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -124,7 +124,7 @@ static int hfsplus_system_write_inode(struct inode *inode)
 
 	if (fork->total_size != cpu_to_be64(inode->i_size)) {
 		set_bit(HFSPLUS_SB_WRITEBACKUP, &sbi->flags);
-		inode->i_sb->s_dirt = 1;
+		hfsplus_mark_mdb_dirty(inode->i_sb);
 	}
 	hfsplus_inode_write_fork(inode, fork);
 	if (tree)
@@ -173,8 +173,6 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 
 	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
-	sb->s_dirt = 0;
-
 	/*
 	 * Explicitly write out the special metadata inodes.
 	 *
@@ -226,12 +224,34 @@ out:
 	return error;
 }
 
-static void hfsplus_write_super(struct super_block *sb)
+static void delayed_sync_fs(struct work_struct *work)
 {
-	if (!(sb->s_flags & MS_RDONLY))
-		hfsplus_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
+	struct hfsplus_sb_info *sbi;
+
+	sbi = container_of(work, struct hfsplus_sb_info, sync_work.work);
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->work_lock);
+
+	hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
+}
+
+void hfsplus_mark_mdb_dirty(struct super_block *sb)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
+		sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->work_lock);
 }
 
 static void hfsplus_put_super(struct super_block *sb)
@@ -240,6 +260,8 @@ static void hfsplus_put_super(struct super_block *sb)
 
 	dprint(DBG_SUPER, "hfsplus_put_super\n");
 
+	cancel_delayed_work_sync(&sbi->sync_work);
+
 	if (!(sb->s_flags & MS_RDONLY) && sbi->s_vhdr) {
 		struct hfsplus_vh *vhdr = sbi->s_vhdr;
 
@@ -325,7 +347,6 @@ static const struct super_operations hfsplus_sops = {
 	.write_inode	= hfsplus_write_inode,
 	.evict_inode	= hfsplus_evict_inode,
 	.put_super	= hfsplus_put_super,
-	.write_super	= hfsplus_write_super,
 	.sync_fs	= hfsplus_sync_fs,
 	.statfs		= hfsplus_statfs,
 	.remount_fs	= hfsplus_remount,
@@ -352,6 +373,8 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = sbi;
 	mutex_init(&sbi->alloc_mutex);
 	mutex_init(&sbi->vh_mutex);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	hfsplus_fill_defaults(sbi);
 
 	err = -EINVAL;
-- 
1.7.7.6

