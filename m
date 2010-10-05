Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0JEKcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:32:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56725 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab0JEKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:32:19 -0400
Message-Id: <20101005103138.973642844@szeredi.hu>
References: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:12 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] vfs: add sb_force_remount_readonly() helper
Content-Disposition: inline; filename=vfs-force_remount_readonly-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add helper for filesystems to call when forcefully remounting
read-only (such as on filesystem errors).

Functionally this doesn't change anything.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 drivers/staging/pohmelfs/net.c |    2 +-
 fs/affs/amigaffs.c             |    2 +-
 fs/ext2/super.c                |    2 +-
 fs/ext3/super.c                |    4 ++--
 fs/ext4/super.c                |    4 ++--
 fs/fat/misc.c                  |    2 +-
 fs/hpfs/super.c                |    2 +-
 fs/jfs/super.c                 |    2 +-
 fs/namespace.c                 |    6 ++++++
 fs/nilfs2/super.c              |    2 +-
 fs/ocfs2/super.c               |    2 +-
 fs/reiserfs/journal.c          |    2 +-
 fs/reiserfs/prints.c           |    4 ++--
 fs/ubifs/io.c                  |    2 +-
 fs/ufs/super.c                 |    4 ++--
 include/linux/fs.h             |    1 +
 16 files changed, 25 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-04 12:12:10.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-04 12:15:17.000000000 +0200
@@ -413,6 +413,12 @@ static int mnt_make_writable(struct vfsm
 	return err;
 }
 
+void sb_force_remount_readonly(struct super_block *sb)
+{
+	sb->s_flags |= MS_RDONLY;
+}
+EXPORT_SYMBOL(sb_force_remount_readonly);
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
Index: linux-2.6/drivers/staging/pohmelfs/net.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/net.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/drivers/staging/pohmelfs/net.c	2010-10-04 12:13:00.000000000 +0200
@@ -673,7 +673,7 @@ static int pohmelfs_root_cap_response(st
 	psb->state_flags = cap->flags;
 
 	if (psb->state_flags & POHMELFS_FLAGS_RO) {
-		psb->sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(psb->sb);
 		printk(KERN_INFO "Mounting POHMELFS (%d) read-only.\n", psb->idx);
 	}
 
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/affs/amigaffs.c	2010-10-04 12:13:00.000000000 +0200
@@ -458,7 +458,7 @@ affs_error(struct super_block *sb, const
 		function,ErrorBuffer);
 	if (!(sb->s_flags & MS_RDONLY))
 		printk(KERN_WARNING "AFFS: Remounting filesystem read-only\n");
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 }
 
 void
Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/ext2/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -69,7 +69,7 @@ void ext2_error (struct super_block * sb
 	if (test_opt(sb, ERRORS_RO)) {
 		ext2_msg(sb, KERN_CRIT,
 			     "error: remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 }
 
Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/ext3/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -188,7 +188,7 @@ static void ext3_handle_error(struct sup
 	if (test_opt (sb, ERRORS_RO)) {
 		ext3_msg(sb, KERN_CRIT,
 			"error: remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 	ext3_commit_super(sb, es, 1);
 	if (test_opt(sb, ERRORS_PANIC))
@@ -295,7 +295,7 @@ void ext3_abort (struct super_block * sb
 	ext3_msg(sb, KERN_CRIT,
 		"error: remounting filesystem read-only");
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	set_opt(EXT3_SB(sb)->s_mount_opt, ABORT);
 	if (EXT3_SB(sb)->s_journal)
 		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-04 11:57:35.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-04 12:13:00.000000000 +0200
@@ -2057,6 +2057,7 @@ extern const struct file_operations writ
 extern const struct file_operations rdwr_pipefifo_fops;
 
 extern int fs_may_remount_ro(struct super_block *);
+extern void sb_force_remount_readonly(struct super_block *);
 
 #ifdef CONFIG_BLOCK
 /*
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/ext4/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -371,7 +371,7 @@ static void ext4_handle_error(struct sup
 	}
 	if (test_opt(sb, ERRORS_RO)) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT4-fs (device %s): panic forced after error\n",
@@ -526,7 +526,7 @@ void __ext4_abort(struct super_block *sb
 
 	if ((sb->s_flags & MS_RDONLY) == 0) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
 		if (EXT4_SB(sb)->s_journal)
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
Index: linux-2.6/fs/fat/misc.c
===================================================================
--- linux-2.6.orig/fs/fat/misc.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/fat/misc.c	2010-10-04 12:13:00.000000000 +0200
@@ -38,7 +38,7 @@ void __fat_fs_error(struct super_block *
 	if (opts->errors == FAT_ERRORS_PANIC)
 		panic("FAT: fs panic from previous error\n");
 	else if (opts->errors == FAT_ERRORS_RO && !(s->s_flags & MS_RDONLY)) {
-		s->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(s);
 		printk(KERN_ERR "FAT: Filesystem has been set read-only\n");
 	}
 }
Index: linux-2.6/fs/hpfs/super.c
===================================================================
--- linux-2.6.orig/fs/hpfs/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/hpfs/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -71,7 +71,7 @@ void hpfs_error(struct super_block *s, c
 			else {
 				printk("; remounting read-only\n");
 				mark_dirty(s);
-				s->s_flags |= MS_RDONLY;
+				sb_force_remount_readonly(s);
 			}
 		} else if (s->s_flags & MS_RDONLY) printk("; going on - but anything won't be destroyed because it's read-only\n");
 		else printk("; corrupted filesystem mounted read/write - your computer will explode within 20 seconds ... but you wanted it so!\n");
Index: linux-2.6/fs/jfs/super.c
===================================================================
--- linux-2.6.orig/fs/jfs/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/jfs/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -86,7 +86,7 @@ static void jfs_handle_error(struct supe
 		jfs_err("ERROR: (device %s): remounting filesystem "
 			"as read-only\n",
 			sb->s_id);
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 
 	/* nothing is done for continue beyond marking the superblock dirty */
Index: linux-2.6/fs/nilfs2/super.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/nilfs2/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -124,7 +124,7 @@ void nilfs_error(struct super_block *sb,
 
 		if (nilfs_test_opt(sbi, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
-			sb->s_flags |= MS_RDONLY;
+			sb_force_remount_readonly(sb);
 		}
 	}
 
Index: linux-2.6/fs/ocfs2/super.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/ocfs2/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -2504,7 +2504,7 @@ static void ocfs2_handle_error(struct su
 	printk(KERN_CRIT "File system is now read-only due to the potential "
 	       "of on-disk corruption. Please run fsck.ocfs2 once the file "
 	       "system is unmounted.\n");
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	ocfs2_set_ro_flag(osb, 0);
 }
 
Index: linux-2.6/fs/reiserfs/journal.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/journal.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/reiserfs/journal.c	2010-10-04 12:13:00.000000000 +0200
@@ -4383,7 +4383,7 @@ void reiserfs_abort_journal(struct super
 	if (!journal->j_errno)
 		journal->j_errno = errno;
 
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	set_bit(J_ABORTED, &journal->j_state);
 
 #ifdef CONFIG_REISERFS_CHECK
Index: linux-2.6/fs/reiserfs/prints.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/prints.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/reiserfs/prints.c	2010-10-04 12:13:00.000000000 +0200
@@ -387,7 +387,7 @@ void __reiserfs_error(struct super_block
 		return;
 
 	reiserfs_info(sb, "Remounting filesystem read-only\n");
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	reiserfs_abort_journal(sb, -EIO);
 }
 
@@ -406,7 +406,7 @@ void reiserfs_abort(struct super_block *
 	printk(KERN_CRIT "REISERFS abort (device %s): %s\n", sb->s_id,
 	       error_buf);
 
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	reiserfs_abort_journal(sb, errno);
 }
 
Index: linux-2.6/fs/ubifs/io.c
===================================================================
--- linux-2.6.orig/fs/ubifs/io.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/ubifs/io.c	2010-10-04 12:13:00.000000000 +0200
@@ -64,7 +64,7 @@ void ubifs_ro_mode(struct ubifs_info *c,
 	if (!c->ro_media) {
 		c->ro_media = 1;
 		c->no_chk_data_crc = 0;
-		c->vfs_sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(c->vfs_sb);
 		ubifs_warn("switched to read-only mode, error %d", err);
 		dbg_dump_stack();
 	}
Index: linux-2.6/fs/ufs/super.c
===================================================================
--- linux-2.6.orig/fs/ufs/super.c	2010-10-04 09:38:21.000000000 +0200
+++ linux-2.6/fs/ufs/super.c	2010-10-04 12:13:00.000000000 +0200
@@ -288,7 +288,7 @@ void ufs_error (struct super_block * sb,
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
 		sb->s_dirt = 1;
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -325,7 +325,7 @@ void ufs_panic (struct super_block * sb,
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	printk (KERN_CRIT "UFS-fs panic (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }

-- 
