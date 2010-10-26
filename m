Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab0JZORm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:17:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35256 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab0JZORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:17:40 -0400
Message-Id: <20101026141659.718444509@szeredi.hu>
References: <20101026141641.315420064@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 26 Oct 2010 16:16:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] vfs: protect remounting superblock read-only
Content-Disposition: inline; filename=vfs-protect-sb-remount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently remouting superblock read-only is racy in a major way.

With the per mount read-only infrastructure it is now possible to
prevent most races, which this patch attempts.

Before starting the remount read-only, iterate through all mounts
belonging to the superblock and if none of them have any pending
writes, set sb->s_readonly_remount.  This indicates that remount is in
progress and no further write requests are allowed.  If the remount
succeeds set MS_RDONLY and reset s_readonly_remount.

If the remounting is unsuccessful just reset s_readonly_remount.
This can result in transient EROFS errors, despite the fact the
remount failed.  Unfortunately hodling off writes is difficult as
remount itself may touch the filesystem (e.g. through load_nls())
which would deadlock.

Small races still remain because delayed writes due to nlink going to
zero but inode still having a reference are not dealt with by this
patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h      |    1 +
 fs/namespace.c     |   40 +++++++++++++++++++++++++++++++++++++++-
 fs/super.c         |   22 ++++++++++++++++++----
 include/linux/fs.h |    3 +++
 4 files changed, 61 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-26 14:26:57.000000000 +0200
+++ linux-2.6/fs/internal.h	2010-10-26 14:27:03.000000000 +0200
@@ -69,6 +69,7 @@ extern void mnt_set_mountpoint(struct vf
 extern void release_mounts(struct list_head *);
 extern void umount_tree(struct vfsmount *, int, struct list_head *);
 extern struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int);
+extern int sb_prepare_remount_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-26 14:27:02.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-26 14:27:03.000000000 +0200
@@ -251,6 +251,15 @@ static unsigned int count_mnt_writers(st
 #endif
 }
 
+static int mnt_is_readonly(struct vfsmount *mnt)
+{
+	if (mnt->mnt_sb->s_readonly_remount)
+		return 1;
+	/* Order wrt setting s_flags/s_readonly_remount in do_remount() */
+	smp_rmb();
+	return __mnt_is_readonly(mnt);
+}
+
 /*
  * Most r/o checks on a fs are for operations that take
  * discrete amounts of time, like a write() or unlink().
@@ -289,7 +298,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	 * MNT_WRITE_HOLD is cleared.
 	 */
 	smp_rmb();
-	if (__mnt_is_readonly(mnt)) {
+	if (mnt_is_readonly(mnt)) {
 		dec_mnt_writers(mnt);
 		ret = -EROFS;
 		goto out;
@@ -406,6 +415,35 @@ static void __mnt_unmake_readonly(struct
 	br_write_unlock(vfsmount_lock);
 }
 
+int sb_prepare_remount_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+	int err = 0;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (!(mnt->mnt_flags & MNT_READONLY)) {
+			mnt->mnt_flags |= MNT_WRITE_HOLD;
+			smp_mb();
+			if (count_mnt_writers(mnt) > 0) {
+				err = -EBUSY;
+				break;
+			}
+		}
+	}
+	if (!err) {
+		sb->s_readonly_remount = 1;
+		smp_wmb();
+	}
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WRITE_HOLD)
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+	}
+	br_write_unlock(vfsmount_lock);
+
+	return err;
+}
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-26 14:27:02.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-26 14:27:03.000000000 +0200
@@ -573,19 +573,29 @@ int do_remount_sb(struct super_block *sb
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if (remount_ro) {
-		if (force)
+		if (force) {
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+		} else {
+			retval = sb_prepare_remount_readonly(sb);
+			if (retval)
+				return retval;
+
+			retval = -EBUSY;
+			if (!fs_may_remount_ro(sb))
+				goto cancel_readonly;
+		}
 	}
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		/* If forced remount, go ahead despite any errors */
 		if (retval && !force)
-			return retval;
+			goto cancel_readonly;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
+	/* Needs to be ordered wrt mnt_is_readonly() */
+	smp_wmb();
+	sb->s_readonly_remount = 0;
 
 	/*
 	 * Some filesystems modify their metadata via some other path than the
@@ -598,6 +608,10 @@ int do_remount_sb(struct super_block *sb
 	if (remount_ro && sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
 	return 0;
+
+cancel_readonly:
+	sb->s_readonly_remount = 0;
+	return retval;
 }
 
 static void do_emergency_remount(struct work_struct *work)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-26 14:27:02.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-26 16:06:30.000000000 +0200
@@ -1388,6 +1388,9 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char __rcu *s_options;
+
+	/* Being remounted read-only */
+	int s_readonly_remount;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);

-- 
