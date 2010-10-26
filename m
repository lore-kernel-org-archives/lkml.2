Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab0JZORu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:17:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35261 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627Ab0JZORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:17:48 -0400
Message-Id: <20101026141657.661882965@szeredi.hu>
References: <20101026141641.315420064@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 26 Oct 2010 16:16:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] vfs: keep list of mounts for each superblock
Content-Disposition: inline; filename=vfs-mount-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Keep track of vfsmounts belonging to a superblock.  List is protected
by vfsmount_lock.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |    5 +++++
 fs/super.c            |    7 +++++++
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 4 files changed, 14 insertions(+)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-26 14:26:57.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-26 14:27:02.000000000 +0200
@@ -1348,6 +1348,7 @@ struct super_block {
 #else
 	struct list_head	s_files;
 #endif
+	struct list_head	s_mounts;	/* list of mounts */
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2010-10-26 14:26:57.000000000 +0200
+++ linux-2.6/include/linux/mount.h	2010-10-26 14:27:02.000000000 +0200
@@ -54,6 +54,7 @@ struct vfsmount {
 	struct super_block *mnt_sb;	/* pointer to superblock */
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
+	struct list_head mnt_instance;	/* mount instance on sb->s_mounts */
 	int mnt_flags;
 	/* 4 bytes hole on 64bits arches without fsnotify */
 #ifdef CONFIG_FSNOTIFY
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-10-26 14:27:01.000000000 +0200
+++ linux-2.6/fs/namespace.c	2010-10-26 14:27:02.000000000 +0200
@@ -622,6 +622,10 @@ static struct vfsmount *clone_mnt(struct
 			if (!list_empty(&old->mnt_expire))
 				list_add(&mnt->mnt_expire, &old->mnt_expire);
 		}
+
+		br_write_lock(vfsmount_lock);
+		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+		br_write_unlock(vfsmount_lock);
 	}
 	return mnt;
 
@@ -661,6 +665,7 @@ void mntput_no_expire(struct vfsmount *m
 		return;
 	}
 	if (likely(!mnt->mnt_pinned)) {
+		list_del(&mnt->mnt_instance);
 		br_write_unlock(vfsmount_lock);
 		__mntput(mnt);
 		return;
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-26 14:27:01.000000000 +0200
+++ linux-2.6/fs/super.c	2010-10-26 14:27:02.000000000 +0200
@@ -74,6 +74,7 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
+		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -127,6 +128,7 @@ static inline void destroy_super(struct
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
+	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
 	kfree(s->s_options);
 	kfree(s);
@@ -968,6 +970,11 @@ vfs_kern_mount(struct file_system_type *
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
 	free_secdata(secdata);
+
+	br_write_lock(vfsmount_lock);
+	list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+	br_write_unlock(vfsmount_lock);
+
 	return mnt;
 out_sb:
 	dput(mnt->mnt_root);

-- 
