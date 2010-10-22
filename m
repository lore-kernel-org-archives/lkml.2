Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab0JVQOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:14:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55150 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab0JVQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:14:10 -0400
To: viro@ZenIV.linux.org.uk
CC: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <E1P9KCY-0005YO-4i@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 22 Oct 2010 18:10:42 +0200)
Subject: [PATCH 7/9 updated] vfs: protect remounting superblock read-only
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu> <20101022064627.GA21607@ZenIV.linux.org.uk> <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu> <E1P9KCY-0005YO-4i@pomaz-ex.szeredi.hu>
Message-Id: <E1P9KFl-0005ZK-0q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 22 Oct 2010 18:14:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently remouting superblock read-only is racy in a major way.

With the per mount read-only infrastructure it is now possible to
prevent most races, which this patch attempts.

Before starting the remount read-only, set MNT_READONLY on all mounts
so that writes are prevented during the remount.  Also set
MNT_WAS_WRITE on mounts that were not read-only.

If the remounting is unsuccessful, restore the mounts to read-write.
This can result in transient EROFS errors.  Unfortunately hodling off
writes is difficult as remount itself may touch the filesystem
(e.g. through load_nls()) which would then deadlock.

Careful thought needs to be given to places where mnt_flags are set
such as do_add_mount() and clone_mnt() to ensure that a read-write
mount is not added to a read-only superblock.

Small races still remain because delayed writes due to nlink going to
zero but inode still having a reference are not dealt with by this
patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h         |    3 ++
 fs/namespace.c        |   73 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/super.c            |   25 ++++++++++++++---
 include/linux/mount.h |    1 
 4 files changed, 96 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-21 19:38:36.000000000 +0200
+++ linux-2.6/fs/internal.h	2010-10-22 17:48:16.000000000 +0200
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
--- linux-2.6.orig/fs/namespace.c	2010-10-22 16:02:14.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-22 17:59:30.000000000 +0200
@@ -419,6 +419,62 @@ void sb_force_remount_readonly(struct su
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
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WRITE_HOLD) {
+			if (!err) {
+				mnt->mnt_flags |= MNT_READONLY | MNT_WAS_WRITE;
+				smp_wmb();
+			}
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+		}
+	}
+	br_write_unlock(vfsmount_lock);
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
+		if (mnt->mnt_flags & MNT_WAS_WRITE)
+			mnt->mnt_flags &= ~(MNT_WAS_WRITE | MNT_READONLY);
+	}
+
+	br_write_unlock(vfsmount_lock);
+}
+
+void sb_finish_remount_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WAS_WRITE)
+			mnt->mnt_flags &= ~MNT_WAS_WRITE;
+	}
+	sb->s_flags |= MS_RDONLY;
+	br_write_unlock(vfsmount_lock);
+}
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -608,7 +664,7 @@ static struct vfsmount *clone_mnt(struct
 				goto out_free;
 		}
 
-		mnt->mnt_flags = old->mnt_flags & ~MNT_WRITE_HOLD;
+		mnt->mnt_flags = old->mnt_flags & MNT_PROPAGATION_MASK;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
@@ -636,7 +692,13 @@ static struct vfsmount *clone_mnt(struct
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
@@ -1782,6 +1844,14 @@ int do_add_mount(struct vfsmount *newmnt
 
 	mnt_flags &= ~(MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL);
 
+	/* Locking is necessary to prevent racing with remount r/o */
+	down_read(&newmnt->mnt_sb->s_umount);
+	if (newmnt->mnt_sb->s_flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
+
+	newmnt->mnt_flags = mnt_flags;
+	up_read(&newmnt->mnt_sb->s_umount);
+
 	down_write(&namespace_sem);
 	/* Something was mounted here while we slept */
 	while (d_mountpoint(path->dentry) &&
@@ -1801,7 +1871,6 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
-	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
 
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-22 16:02:14.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-22 17:48:16.000000000 +0200
@@ -573,18 +573,31 @@ int do_remount_sb(struct super_block *sb
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
@@ -598,6 +611,10 @@ int do_remount_sb(struct super_block *sb
 	if (remount_ro && sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
 	return 0;
+
+cancel_readonly:
+	sb_cancel_remount_readonly(sb);
+	return retval;
 }
 
 static void do_emergency_remount(struct work_struct *work)
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2010-10-22 16:02:14.000000000 +0200
+++ linux-2.6/include/linux/mount.h	2010-10-22 17:59:30.000000000 +0200
@@ -30,6 +30,7 @@ struct mnt_namespace;
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
+#define MNT_WAS_WRITE	0x400   /* used by remount to remember write mounts */
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
