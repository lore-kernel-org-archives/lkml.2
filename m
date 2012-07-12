Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161033Ab2GLN0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:26:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:27661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab2GLN0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="170963794"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Evgeniy Dushistov <dushistov@mail.ru>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] fs/ufs: get rid of write_super
Date: Thu, 12 Jul 2012 16:28:08 +0300
Message-Id: <1342099688-14894-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch makes UFS stop using the VFS '->write_super()' method along with
the 's_dirt' superblock flag, because they are on their way out.

The way we implement this is that we schedule a delay job instead relying on
's_dirt' and '->write_super()'.

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
 fs/ufs/balloc.c |    8 ++++----
 fs/ufs/ialloc.c |    4 ++--
 fs/ufs/super.c  |   40 ++++++++++++++++++++++++++++++----------
 fs/ufs/ufs.h    |    5 +++++
 fs/ufs/ufs_fs.h |    1 +
 5 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 42694e1..1b3e410 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -116,7 +116,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 	
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -214,7 +214,7 @@ do_more:
 		goto do_more;
 	}
 
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 	return;
@@ -557,7 +557,7 @@ static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 
 	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
@@ -677,7 +677,7 @@ succed:
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 
 	result += cgno * uspi->s_fpg;
 	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 4ec5c10..e84cbe2 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -116,7 +116,7 @@ void ufs_free_inode (struct inode * inode)
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 }
@@ -288,7 +288,7 @@ cg_found:
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode_init_owner(inode, dir, mode);
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index ad56c6d..444927e 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -302,7 +302,7 @@ void ufs_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		ufs_mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
@@ -334,7 +334,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		ufs_mark_sb_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -715,7 +715,6 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 		ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
 
 	UFSD("EXIT\n");
 	unlock_super(sb);
@@ -724,12 +723,31 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	return 0;
 }
 
-static void ufs_write_super(struct super_block *sb)
+static void delayed_sync_fs(struct work_struct *work)
 {
-	if (!(sb->s_flags & MS_RDONLY))
-		ufs_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
+	struct ufs_sb_info *sbi;
+
+	sbi = container_of(work, struct ufs_sb_info, sync_work.work);
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->work_lock);
+
+	ufs_sync_fs(sbi->sb, 1);
+}
+
+void ufs_mark_sb_dirty(struct super_block *sb)
+{
+	struct ufs_sb_info *sbi = UFS_SB(sb);
+	unsigned long delay;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
+		sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->work_lock);
 }
 
 static void ufs_put_super(struct super_block *sb)
@@ -740,6 +758,7 @@ static void ufs_put_super(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_put_super_internal(sb);
+	cancel_delayed_work_sync(&sbi->sync_work);
 
 	ubh_brelse_uspi (sbi->s_uspi);
 	kfree (sbi->s_uspi);
@@ -774,6 +793,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		goto failed_nomem;
 	sb->s_fs_info = sbi;
+	sbi->sb = sb;
 
 	UFSD("flag %u\n", (int)(sb->s_flags & MS_RDONLY));
 	
@@ -785,6 +805,8 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 #endif
 	mutex_init(&sbi->mutex);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	/*
 	 * Set default mount options
 	 * Parse mount options
@@ -1304,7 +1326,6 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ubh_mark_buffer_dirty (USPI_UBH(uspi));
-		sb->s_dirt = 0;
 		sb->s_flags |= MS_RDONLY;
 	} else {
 	/*
@@ -1454,7 +1475,6 @@ static const struct super_operations ufs_super_ops = {
 	.write_inode	= ufs_write_inode,
 	.evict_inode	= ufs_evict_inode,
 	.put_super	= ufs_put_super,
-	.write_super	= ufs_write_super,
 	.sync_fs	= ufs_sync_fs,
 	.statfs		= ufs_statfs,
 	.remount_fs	= ufs_remount,
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 528750b..343e6fc 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -20,6 +20,10 @@ struct ufs_sb_info {
 	unsigned s_mount_opt;
 	struct mutex mutex;
 	struct task_struct *mutex_owner;
+	struct super_block *sb;
+	int work_queued; /* non-zero if the delayed work is queued */
+	struct delayed_work sync_work; /* FS sync delayed work */
+	spinlock_t work_lock; /* protects sync_work and work_queued */
 };
 
 struct ufs_inode_info {
@@ -123,6 +127,7 @@ extern __printf(3, 4)
 void ufs_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
 void ufs_panic(struct super_block *, const char *, const char *, ...);
+void ufs_mark_sb_dirty(struct super_block *sb);
 
 /* symlink.c */
 extern const struct inode_operations ufs_fast_symlink_inode_operations;
diff --git a/fs/ufs/ufs_fs.h b/fs/ufs/ufs_fs.h
index 8aba544..0cbd5d3 100644
--- a/fs/ufs/ufs_fs.h
+++ b/fs/ufs/ufs_fs.h
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/stat.h>
 #include <linux/fs.h>
+#include <linux/workqueue.h>
 
 #include <asm/div64.h>
 typedef __u64 __bitwise __fs64;
-- 
1.7.7.6

