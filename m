Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0JEKdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:33:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56704 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab0JEKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:31:54 -0400
Message-Id: <20101005103148.272615582@szeredi.hu>
References: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:17 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] vfs: mark mounts read-only on forced remount
Content-Disposition: inline; filename=vfs-force-mounts-readonly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

When the superblock is forcefully remounted read-only, as in case of
an emergency remount or filesystem errors, make sure that the mounts
belonging to the superblock are also marked read-only.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h  |    1 +
 fs/namespace.c |   16 ++++++++++++++++
 fs/super.c     |   16 ++++++++++++----
 3 files changed, 29 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-04 13:02:24.000000000 +0200
+++ linux-2.6/fs/internal.h	2010-10-04 15:09:49.000000000 +0200
@@ -72,6 +72,7 @@ extern struct vfsmount *copy_tree(struct
 extern int sb_prepare_remount_readonly(struct super_block *);
 extern void sb_cancel_remount_readonly(struct super_block *);
 extern void sb_finish_remount_readonly(struct super_block *);
+extern void mark_mounts_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-04 13:02:24.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-04 15:09:49.000000000 +0200
@@ -418,7 +418,13 @@ static int mnt_make_writable(struct vfsm
 
 void sb_force_remount_readonly(struct super_block *sb)
 {
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance)
+		mnt->mnt_flags |= MNT_READONLY;
 	sb->s_flags |= MS_RDONLY;
+	br_write_unlock(vfsmount_lock);
 }
 EXPORT_SYMBOL(sb_force_remount_readonly);
 
@@ -477,6 +483,16 @@ void sb_finish_remount_readonly(struct s
 	wake_up_all(&sb->s_wait_remount_readonly);
 }
 
+void mark_mounts_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance)
+		mnt->mnt_flags |= MNT_READONLY;
+	br_write_unlock(vfsmount_lock);
+}
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-04 13:02:24.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-04 15:09:49.000000000 +0200
@@ -555,6 +555,7 @@ int do_remount_sb(struct super_block *sb
 {
 	int retval;
 	int remount_ro;
+	bool old_ro;
 
 	if (sb->s_frozen != SB_UNFROZEN)
 		return -EBUSY;
@@ -569,12 +570,14 @@ int do_remount_sb(struct super_block *sb
 	shrink_dcache_sb(sb);
 	sync_filesystem(sb);
 
-	remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
+	old_ro = (sb->s_flags & MS_RDONLY) != 0;
+	remount_ro = (flags & MS_RDONLY) && !old_ro;
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if (remount_ro) {
 		if (force) {
+			mark_mounts_readonly(sb);
 			mark_files_ro(sb);
 		} else {
 			retval = sb_prepare_remount_readonly(sb);
@@ -596,9 +599,14 @@ int do_remount_sb(struct super_block *sb
 			return retval;
 		}
 	}
-	if (remount_ro && !force)
-		sb_finish_remount_readonly(sb);
-
+	if (remount_ro) {
+		WARN_ON(!(flags & MS_RDONLY));
+		if (!force)
+			sb_finish_remount_readonly(sb);
+	} else if ((flags & MS_RDONLY) && !old_ro) {
+		/* filesystem remounted r/o without being asked to */
+		sb_force_remount_readonly(sb);
+	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 
 	/*

-- 
