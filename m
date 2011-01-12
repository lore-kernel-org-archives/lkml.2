Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1ALQGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:06:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49714 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1ALQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:06:39 -0500
Message-Id: <20110112160620.150516278@szeredi.hu>
References: <20110112160551.722413413@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 12 Jan 2011 17:05:53 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] vfs: keep list of mounts for each superblock
Content-Disposition: inline; filename=vfs-mount-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Keep track of vfsmounts belonging to a superblock.  List is protected
by vfsmount_lock.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |   10 ++++++++--
 fs/super.c            |    7 +++++++
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-01-12 15:47:09.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2011-01-12 15:47:12.000000000 +0100
@@ -1384,6 +1384,7 @@ struct super_block {
 #else
 	struct list_head	s_files;
 #endif
+	struct list_head	s_mounts;	/* list of mounts */
 	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2011-01-12 15:47:09.000000000 +0100
+++ linux-2.6/include/linux/mount.h	2011-01-12 15:47:12.000000000 +0100
@@ -67,6 +67,7 @@ struct vfsmount {
 #endif
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
+	struct list_head mnt_instance;	/* mount instance on sb->s_mounts */
 	int mnt_flags;
 	/* 4 bytes hole on 64bits arches without fsnotify */
 #ifdef CONFIG_FSNOTIFY
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2011-01-12 15:47:09.000000000 +0100
+++ linux-2.6/fs/namespace.c	2011-01-12 15:47:12.000000000 +0100
@@ -705,6 +705,10 @@ static struct vfsmount *clone_mnt(struct
 			if (!list_empty(&old->mnt_expire))
 				list_add(&mnt->mnt_expire, &old->mnt_expire);
 		}
+
+		br_write_lock(vfsmount_lock);
+		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+		br_write_unlock(vfsmount_lock);
 	}
 	return mnt;
 
@@ -714,9 +718,13 @@ static struct vfsmount *clone_mnt(struct
 }
 
 static inline void mntfree(struct vfsmount *mnt)
+__releases(vfsmount_lock)
 {
 	struct super_block *sb = mnt->mnt_sb;
 
+	list_del(&mnt->mnt_instance);
+	br_write_unlock(vfsmount_lock);
+
 	/*
 	 * This probably indicates that somebody messed
 	 * up a mnt_want/drop_write() pair.  If this
@@ -768,7 +776,6 @@ static inline void __mntput(struct vfsmo
 		acct_auto_close_mnt(mnt);
 		goto put_again;
 	}
-	br_write_unlock(vfsmount_lock);
 	mntfree(mnt);
 }
 #else
@@ -786,7 +793,6 @@ static inline void __mntput(struct vfsmo
 		acct_auto_close_mnt(mnt);
 		goto put_again;
 	}
-	br_write_unlock(vfsmount_lock);
 	mntfree(mnt);
 }
 #endif
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2011-01-12 15:47:10.000000000 +0100
+++ linux-2.6/fs/super.c	2011-01-12 15:47:12.000000000 +0100
@@ -75,6 +75,7 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
+		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -128,6 +129,7 @@ static inline void destroy_super(struct
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
+	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
 	kfree(s->s_options);
 	kfree(s);
@@ -1018,6 +1020,11 @@ vfs_kern_mount(struct file_system_type *
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
