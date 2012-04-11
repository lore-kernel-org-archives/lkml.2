Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab2DKLok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:44:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:58363 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972Ab2DKLoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:44:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87782481"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v1 3/3] fat: self-manage own fsinfo block
Date: Wed, 11 Apr 2012 14:45:07 +0300
Message-Id: <1334144707-9729-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
References: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This is the final patch of the series which makes FAT independent of the
VFS '->write_super' method which was used for writing out the FSINFO block
(which contains various non-essential counters like the next free cluster).

Now we just submit a delayed work when the FSINFO block is marked as dirty.
A spinlock is used to make sure we submit only one work at a time. On unmount
or '->sync_fs()', we just flush the workqueue which should make sure the
FSINFO block is written out.

We use the generic 'system_long_wq' for these purposes because it seem to fit
the task well. Indeed, own workqueue would be an overkill and waste of
resources.

The FSINFO write-out delay is the same as before:
'/proc/sys/vm/dirty_expire_centisecs'.

Reminder: this exercises is being done in order to kill the global VFS
'sync_supers()' thread which wakes up the system every 5 seconds no matter
what.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/fat/fat.h    |    7 ++++++-
 fs/fat/fatent.c |   14 +++++++++++++-
 fs/fat/inode.c  |   47 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 66994f3..4f08ee0 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/ratelimit.h>
+#include <linux/workqueue.h>
 #include <linux/msdos_fs.h>
 
 /*
@@ -75,7 +76,7 @@ struct msdos_sb_info {
 	struct fat_mount_options options;
 	struct nls_table *nls_disk;  /* Codepage used on disk */
 	struct nls_table *nls_io;    /* Charset used for input and display */
-	const void *dir_ops;		     /* Opaque; default directory operations */
+	const void *dir_ops;         /* Opaque; default directory operations */
 	int dir_per_block;	     /* dir entries per block */
 	int dir_per_block_bits;	     /* log2(dir_per_block) */
 
@@ -87,6 +88,10 @@ struct msdos_sb_info {
 
 	spinlock_t inode_hash_lock;
 	struct hlist_head inode_hashtable[FAT_HASH_SIZE];
+
+	struct delayed_work fsinfo_work; /* FSINFO block write-out work */
+	int fsinfo_dirty; /* non-zero if the FSINFO block should be synced */
+	spinlock_t fsinfo_lock; /* protects fsinfo_* fields */
 };
 
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 8e778ef..8d31994 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -310,7 +310,19 @@ void fat_ent_access_init(struct super_block *sb)
 
 static void fat_mark_fsinfo_dirty(struct super_block *sb)
 {
-	sb->s_dirt = 1;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY || sbi->fat_bits != 32)
+		return;
+
+	spin_lock(&sbi->fsinfo_lock);
+	if (!sbi->fsinfo_dirty) {
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->fsinfo_work, delay);
+		sbi->fsinfo_dirty = 1;
+	}
+	spin_unlock(&sbi->fsinfo_lock);
 }
 
 static inline int fat_ent_update_ptr(struct super_block *sb,
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 21687e3..ca544b1 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -459,37 +459,49 @@ static void fat_evict_inode(struct inode *inode)
 	fat_detach(inode);
 }
 
-static void fat_write_super(struct super_block *sb)
+static struct msdos_sb_info *work_to_sb(struct work_struct *work)
 {
-	lock_super(sb);
-	sb->s_dirt = 0;
+	struct delayed_work *dwork;
+
+	dwork = container_of(work, struct delayed_work, work);
+	return container_of(dwork, struct msdos_sb_info, fsinfo_work);
+}
+
+static void write_super(struct work_struct *work)
+{
+	struct msdos_sb_info *sbi = work_to_sb(work);
+	struct super_block *sb = sbi->fat_inode->i_sb;
+
+	spin_lock(&sbi->fsinfo_lock);
+	if (!sbi->fsinfo_dirty) {
+		spin_unlock(&sbi->fsinfo_lock);
+		return;
+	}
+	sbi->fsinfo_dirty = 0;
+	spin_unlock(&sbi->fsinfo_lock);
 
-	if (!(sb->s_flags & MS_RDONLY))
-		fat_clusters_flush(sb);
+	lock_super(sb);
+	fat_clusters_flush(sb);
 	unlock_super(sb);
 }
 
 static int fat_sync_fs(struct super_block *sb, int wait)
 {
-	int err = 0;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb->s_dirt) {
-		lock_super(sb);
-		sb->s_dirt = 0;
-		err = fat_clusters_flush(sb);
-		unlock_super(sb);
-	}
+	if (wait)
+		flush_delayed_work_sync(&sbi->fsinfo_work);
+	else
+		flush_delayed_work(&sbi->fsinfo_work);
 
-	return err;
+	return 0;
 }
 
 static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb->s_dirt)
-		fat_write_super(sb);
-
+	flush_delayed_work_sync(&sbi->fsinfo_work);
 	iput(sbi->fat_inode);
 
 	unload_nls(sbi->nls_disk);
@@ -678,7 +690,6 @@ static const struct super_operations fat_sops = {
 	.write_inode	= fat_write_inode,
 	.evict_inode	= fat_evict_inode,
 	.put_super	= fat_put_super,
-	.write_super	= fat_write_super,
 	.sync_fs	= fat_sync_fs,
 	.statfs		= fat_statfs,
 	.remount_fs	= fat_remount,
@@ -1271,6 +1282,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sb->s_export_op = &fat_export_ops;
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
+	INIT_DELAYED_WORK_DEFERRABLE(&sbi->fsinfo_work, write_super);
+	spin_lock_init(&sbi->fsinfo_lock);
 
 	error = parse_options(sb, data, isvfat, silent, &debug, &sbi->options);
 	if (error)
-- 
1.7.7.6

