Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab0JEKb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:31:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56694 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0JEKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:31:51 -0400
Message-Id: <20101005103144.051231469@szeredi.hu>
References: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:15 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] vfs: protect remounting superblock read-only
Content-Disposition: inline; filename=vfs-protect-sb-remount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently remouting superblock read-only is racy in a major way.

With the per mount read-only infrastructure it is now possible to
prevent most races, which this patch attempts.

Before starting the remount read-only, set MNT_WRITE_HOLD on all
mounts so that writes are held off until the remount either succeeds
or fails.

After this proceed with the remount and if successful mark all mounts
MNT_READONLY and release MNT_WRITE_HOLD.  If unsuccessful, just
release MNT_WRITE_HOLD so that write operations can proceed normally.

Careful thought needs to be given to places where mnt_flags are set
such as do_add_mount() and clone_mnt() to ensure that a read-write
mount is not added to a read-only superblock.

Small races still remain because delayed writes due to nlink going to
zero but inode still having a reference are not dealt with by this
patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h  |    3 ++
 fs/namespace.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/super.c     |   25 +++++++++++++++++---
 3 files changed, 93 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-01 20:40:41.000000000 +0200
+++ linux-2.6/fs/internal.h	2010-10-04 13:02:24.000000000 +0200
@@ -69,6 +69,9 @@ extern void mnt_set_mountpoint(struct vf
 extern void release_mounts(struct list_head *);
 extern void umount_tree(struct vfsmount *, int, struct list_head *);
 extern struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int);
+extern int sb_prepare_remount_readonly(struct super_block *);
+extern void sb_cancel_remount_readonly(struct super_block *);
+extern void sb_finish_remount_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-04 12:38:35.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-04 13:02:24.000000000 +0200
@@ -422,6 +422,61 @@ void sb_force_remount_readonly(struct su
 }
 EXPORT_SYMBOL(sb_force_remount_readonly);
 
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
+	br_write_unlock(vfsmount_lock);
+
+	if (err)
+		sb_cancel_remount_readonly(sb);
+
+	return err;
+}
+
+void sb_cancel_remount_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WRITE_HOLD)
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+	}
+
+	br_write_unlock(vfsmount_lock);
+	wake_up_all(&sb->s_wait_remount_readonly);
+}
+
+void sb_finish_remount_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (!(mnt->mnt_flags & MNT_READONLY)) {
+			mnt->mnt_flags |= MNT_READONLY;
+			smp_wmb();
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+		}
+	}
+	sb->s_flags |= MS_RDONLY;
+	br_write_unlock(vfsmount_lock);
+	wake_up_all(&sb->s_wait_remount_readonly);
+}
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -611,7 +666,7 @@ static struct vfsmount *clone_mnt(struct
 				goto out_free;
 		}
 
-		mnt->mnt_flags = old->mnt_flags & ~MNT_WRITE_HOLD;
+		mnt->mnt_flags = old->mnt_flags & MNT_PROPAGATION_MASK;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
@@ -639,7 +694,13 @@ static struct vfsmount *clone_mnt(struct
 				list_add(&mnt->mnt_expire, &old->mnt_expire);
 		}
 
+		/*
+		 * Add new mount to s_mounts.  Do this after fiddling
+		 * with propagation flags to prevent races with
+		 * remount ro/rw.
+		 */
 		br_write_lock(vfsmount_lock);
+		mnt->mnt_flags |= old->mnt_flags & ~MNT_PROPAGATION_MASK;
 		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
 		br_write_unlock(vfsmount_lock);
 	}
@@ -1804,7 +1865,14 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/* Locking is necessary to prevent racing with remount r/o */
+	br_read_lock(vfsmount_lock);
+	if (newmnt->mnt_sb->s_flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
+
 	newmnt->mnt_flags = mnt_flags;
+	br_read_unlock(vfsmount_lock);
+
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
 
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-04 12:38:35.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-04 13:02:24.000000000 +0200
@@ -574,18 +574,31 @@ int do_remount_sb(struct super_block *sb
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
-		if (retval && !force)
+		if (retval && !force) {
+			if (remount_ro)
+				goto cancel_readonly;
 			return retval;
+		}
 	}
+	if (remount_ro && !force)
+		sb_finish_remount_readonly(sb);
+
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 
 	/*
@@ -599,6 +612,10 @@ int do_remount_sb(struct super_block *sb
 	if (remount_ro && sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
 	return 0;
+
+cancel_readonly:
+	sb_cancel_remount_readonly(sb);
+	return retval;
 }
 
 static void do_emergency_remount(struct work_struct *work)

-- 
