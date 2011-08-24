Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1HXNXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:23:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36674 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1HXNW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:22:27 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
        hch@infradead.org, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 2/4] vfs: keep list of mounts for each superblock
Date: Wed, 24 Aug 2011 15:22:01 +0200
Message-Id: <1314192123-29393-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1314191791-29218-1-git-send-email-miklos@szeredi.hu>
References: <1314191791-29218-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Keep track of vfsmounts belonging to a superblock.  List is protected
by vfsmount_lock.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |   10 ++++++++++
 fs/super.c            |    2 ++
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 22bfe82..c369c32 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -696,6 +696,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	mnt->mnt_sb = root->d_sb;
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
+
+	br_write_lock(vfsmount_lock);
+	list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+	br_write_unlock(vfsmount_lock);
+
 	return mnt;
 }
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
@@ -745,6 +750,10 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 			if (!list_empty(&old->mnt_expire))
 				list_add(&mnt->mnt_expire, &old->mnt_expire);
 		}
+
+		br_write_lock(vfsmount_lock);
+		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
+		br_write_unlock(vfsmount_lock);
 	}
 	return mnt;
 
@@ -805,6 +814,7 @@ put_again:
 		acct_auto_close_mnt(mnt);
 		goto put_again;
 	}
+	list_del(&mnt->mnt_instance);
 	br_write_unlock(vfsmount_lock);
 	mntfree(mnt);
 }
diff --git a/fs/super.c b/fs/super.c
index 363fde2..e8aad34 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -142,6 +142,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		INIT_LIST_HEAD(&s->s_inode_lru);
 		spin_lock_init(&s->s_inode_lru_lock);
+		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -200,6 +201,7 @@ static inline void destroy_super(struct super_block *s)
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
+	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
 	kfree(s->s_options);
 	kfree(s);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..e2a67e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1410,6 +1410,7 @@ struct super_block {
 #else
 	struct list_head	s_files;
 #endif
+	struct list_head	s_mounts;	/* list of mounts */
 	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 33fe53d..f88c726 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -67,6 +67,7 @@ struct vfsmount {
 #endif
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
+	struct list_head mnt_instance;	/* mount instance on sb->s_mounts */
 	int mnt_flags;
 	/* 4 bytes hole on 64bits arches without fsnotify */
 #ifdef CONFIG_FSNOTIFY
-- 
1.7.3.4

