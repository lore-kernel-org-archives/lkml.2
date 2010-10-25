Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0JYMhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:37:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43754 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0JYMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:37:12 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20101023161948.GP19804@ZenIV.linux.org.uk> (message from Al Viro
	on Sat, 23 Oct 2010 17:19:48 +0100)
Subject: Re: [PATCH 7/9 updated] vfs: protect remounting superblock read-only
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu>
 <20101022064627.GA21607@ZenIV.linux.org.uk>
 <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu>
 <E1P9KCY-0005YO-4i@pomaz-ex.szeredi.hu>
 <E1P9KFl-0005ZK-0q@pomaz-ex.szeredi.hu> <20101023161948.GP19804@ZenIV.linux.org.uk>
Message-Id: <E1PAMIK-00026y-F0@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 25 Oct 2010 14:36:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Al Viro wrote:
> > +	/* Locking is necessary to prevent racing with remount r/o */
> > +	down_read(&newmnt->mnt_sb->s_umount);
> > +	if (newmnt->mnt_sb->s_flags & MS_RDONLY)
> > +		mnt_flags |= MNT_READONLY;
> > +
> > +	newmnt->mnt_flags = mnt_flags;
> > +	up_read(&newmnt->mnt_sb->s_umount);
> 
> FWIW, I really don't like the way you are doing that; what we really need
> there is a per-sb analog of mnt_want_write()/mnt_drop_write().  With
> mnt_want_write() bumping per-sb write count, which would solve all these
> problems quite nicely.

And add a nice bit of overhead to a hot path...  Making it per-cpu
would help, but then we'd end up with the same ifdef mess as
mnt_writers and still a non-zero overhead.

But what's the point anyway, the per-sb write count always equals
SUM(mnt->mnt_writers).

How about this variant?  It addresses the vfsmount vs. sb read only
status independence:


Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-25 12:45:22.000000000 +0200
+++ linux-2.6/fs/internal.h	2010-10-25 12:48:08.000000000 +0200
@@ -69,6 +69,7 @@ extern void mnt_set_mountpoint(struct vf
 extern void release_mounts(struct list_head *);
 extern void umount_tree(struct vfsmount *, int, struct list_head *);
 extern struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int);
+extern int sb_prepare_remount_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-25 12:45:22.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-25 14:14:35.000000000 +0200
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
--- linux-2.6.orig/fs/super.c	2010-10-25 12:45:22.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-25 14:08:58.000000000 +0200
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
--- linux-2.6.orig/include/linux/fs.h	2010-10-25 11:43:25.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-25 13:38:26.000000000 +0200
@@ -1386,6 +1386,9 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/* Being remounted read-only */
+	int s_readonly_remount;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
