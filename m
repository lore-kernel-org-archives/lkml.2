Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab1J1MRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:17:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1J1MNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:13:51 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 03/13] vfs: protect remounting superblock read-only
Date: Fri, 28 Oct 2011 14:13:22 +0200
Message-Id: <1319804012-16346-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
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
Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/internal.h      |    1 +
 fs/namespace.c     |   40 +++++++++++++++++++++++++++++++++++++++-
 fs/super.c         |   22 ++++++++++++++++++----
 include/linux/fs.h |    3 +++
 4 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index fe327c2..f925271 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -74,6 +74,7 @@ extern int finish_automount(struct vfsmount *, struct path *);
 
 extern void mnt_make_longterm(struct vfsmount *);
 extern void mnt_make_shortterm(struct vfsmount *);
+extern int sb_prepare_remount_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
diff --git a/fs/namespace.c b/fs/namespace.c
index ccbec4e..85838f5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -311,6 +311,15 @@ static unsigned int mnt_get_writers(struct vfsmount *mnt)
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
@@ -349,7 +358,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	 * MNT_WRITE_HOLD is cleared.
 	 */
 	smp_rmb();
-	if (__mnt_is_readonly(mnt)) {
+	if (mnt_is_readonly(mnt)) {
 		mnt_dec_writers(mnt);
 		ret = -EROFS;
 		goto out;
@@ -466,6 +475,35 @@ static void __mnt_unmake_readonly(struct vfsmount *mnt)
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
+			if (mnt_get_writers(mnt) > 0) {
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
 static void free_vfsmnt(struct vfsmount *mnt)
 {
 	kfree(mnt->mnt_devname);
diff --git a/fs/super.c b/fs/super.c
index a021ca2..b011cca 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -721,23 +721,33 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
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
 		if (retval) {
 			if (!force)
-				return retval;
+				goto cancel_readonly;
 			/* If forced remount, go ahead despite any errors */
 			WARN(1, "forced remount of a %s fs returned %i\n",
 			     sb->s_type->name, retval);
 		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
+	/* Needs to be ordered wrt mnt_is_readonly() */
+	smp_wmb();
+	sb->s_readonly_remount = 0;
 
 	/*
 	 * Some filesystems modify their metadata via some other path than the
@@ -750,6 +760,10 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	if (remount_ro && sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
 	return 0;
+
+cancel_readonly:
+	sb->s_readonly_remount = 0;
+	return retval;
 }
 
 static void do_emergency_remount(struct work_struct *work)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6eb9a30..0eb2b39 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1466,6 +1466,9 @@ struct super_block {
 	int cleancache_poolid;
 
 	struct shrinker s_shrink;	/* per-sb shrinker handle */
+
+	/* Being remounted read-only */
+	int s_readonly_remount;
 };
 
 /* superblock cache pruning functions */
-- 
1.7.3.4

