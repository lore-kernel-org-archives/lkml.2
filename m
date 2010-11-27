Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0K0K3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:29:32 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab0K0K0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIphhRQ
Message-Id: <2b3419d8509b63d2b13d113c67a1e87b8b0edd26.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:05 +1100
Subject: [PATCH 35/46] fs: dcache remove d_mounted
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than keep a d_mounted count in the dentry, set a dentry flag instead.
The flag can be cleared by checking the hash table to see if there are any
mounts left, which is not time critical because it is performed at detach time.

The mounted state of a dentry is only used to speculatively take a look in the
mount hash table if it is set -- before following the mount, vfsmount lock is
taken and mount re-checked without races.

This saves 4 bytes on 32-bit, nothing on 64-bit but it does provide a hole I
might use later (and some configs have larger than 32-bit spinlocks which might
make use of the hole).

Autofs4 conversion and changelog by Ian Kent <raven@themaw.net>:
In autofs4, when expring direct (or offset) mounts we need to ensure that we
block user path walks into the autofs mount, which is covered by another mount.
To do this we clear the mounted status so that follows stop before walking into
the mount and are essentially blocked until the expire is completed. The
automount daemon still finds the correct dentry for the umount due to the
follow mount logic in fs/autofs4/root.c:autofs4_follow_link(), which is set as
an inode operation for direct and offset mounts only and is called following
the lookup that stopped at the covered mount.

At the end of the expire the covering mount probably has gone away so the
mounted status need not be restored. But we need to check this and only restore
the mounted status if the expire failed.

XXX: autofs may not work right if we have other mounts go over the top of it?

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/autofs4/expire.c    |   13 +++++++++++--
 fs/dcache.c            |    1 -
 fs/namespace.c         |   29 ++++++++++++++++++++++++++---
 include/linux/dcache.h |   42 +++++++++++++++++++++---------------------
 4 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 7869b3a..d9f9a15 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -295,7 +295,9 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 		struct autofs_info *ino = autofs4_dentry_ino(root);
 		if (d_mountpoint(root)) {
 			ino->flags |= AUTOFS_INF_MOUNTPOINT;
-			root->d_mounted--;
+			spin_lock(&root->d_lock);
+			root->d_flags &= ~DCACHE_MOUNTED;
+			spin_unlock(&root->d_lock);
 		}
 		ino->flags |= AUTOFS_INF_EXPIRING;
 		init_completion(&ino->expire_complete);
@@ -503,7 +505,14 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 
 		spin_lock(&sbi->fs_lock);
 		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
-			sb->s_root->d_mounted++;
+			spin_lock(&sb->s_root->d_lock);
+			/*
+			 * If we haven't been expired away, then reset
+			 * mounted status.
+			 */
+			if (mnt->mnt_parent != mnt)
+				sb->s_root->d_flags |= DCACHE_MOUNTED;
+			spin_unlock(&sb->s_root->d_lock);
 			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
 		}
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
diff --git a/fs/dcache.c b/fs/dcache.c
index 5b59807..c25be71 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1198,7 +1198,6 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	dentry->d_sb = NULL;
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
-	dentry->d_mounted = 0;
 	INIT_HLIST_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
diff --git a/fs/namespace.c b/fs/namespace.c
index 3dbfc07..39a7d50 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -492,6 +492,27 @@ static void __touch_mnt_namespace(struct mnt_namespace *ns)
 }
 
 /*
+ * Clear dentry's mounted state if it has no remaining mounts.
+ * vfsmount_lock must be held for write.
+ */
+static void dentry_reset_mounted(struct vfsmount *mnt, struct dentry *dentry)
+{
+	unsigned u;
+
+	for (u = 0; u < HASH_SIZE; u++) {
+		struct vfsmount *p;
+
+		list_for_each_entry(p, &mount_hashtable[u], mnt_hash) {
+			if (p->mnt_mountpoint == dentry)
+				return;
+		}
+	}
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags &= ~DCACHE_MOUNTED;
+	spin_unlock(&dentry->d_lock);
+}
+
+/*
  * vfsmount lock must be held for write
  */
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
@@ -502,7 +523,7 @@ static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	list_del_init(&mnt->mnt_child);
 	list_del_init(&mnt->mnt_hash);
-	old_path->dentry->d_mounted--;
+	dentry_reset_mounted(old_path->mnt, old_path->dentry);
 }
 
 /*
@@ -513,7 +534,9 @@ void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
 {
 	child_mnt->mnt_parent = mntget(mnt);
 	child_mnt->mnt_mountpoint = dget(dentry);
-	dentry->d_mounted++;
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_MOUNTED;
+	spin_unlock(&dentry->d_lock);
 }
 
 /*
@@ -1073,7 +1096,7 @@ void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 		list_del_init(&p->mnt_child);
 		if (p->mnt_parent != p) {
 			p->mnt_parent->mnt_ghosts++;
-			p->mnt_mountpoint->d_mounted--;
+			dentry_reset_mounted(p->mnt_parent, p->mnt_mountpoint);
 		}
 		change_mnt_propagation(p, MS_PRIVATE);
 	}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 5dfb6f7..2fd0b45 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -92,7 +92,6 @@ struct dentry {
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
 	seqcount_t d_seq;		/* per dentry seqlock */
-	int d_mounted;
 	struct inode *d_inode;		/* Where the name belongs to - NULL is
 					 * negative */
 	/*
@@ -156,33 +155,34 @@ struct dentry_operations {
 
 /* d_flags entries */
 #define DCACHE_AUTOFS_PENDING 0x0001    /* autofs: "under construction" */
-#define DCACHE_NFSFS_RENAMED  0x0002    /* this dentry has been "silly
-					 * renamed" and has to be
-					 * deleted on the last dput()
-					 */
-#define	DCACHE_DISCONNECTED 0x0004
-     /* This dentry is possibly not currently connected to the dcache tree,
-      * in which case its parent will either be itself, or will have this
-      * flag as well.  nfsd will not use a dentry with this bit set, but will
-      * first endeavour to clear the bit either by discovering that it is
-      * connected, or by performing lookup operations.   Any filesystem which
-      * supports nfsd_operations MUST have a lookup function which, if it finds
-      * a directory inode with a DCACHE_DISCONNECTED dentry, will d_move
-      * that dentry into place and return that dentry rather than the passed one,
-      * typically using d_splice_alias.
-      */
+#define DCACHE_NFSFS_RENAMED  0x0002
+     /* this dentry has been "silly renamed" and has to be deleted on the last
+      * dput() */
+
+#define	DCACHE_DISCONNECTED	0x0004
+     /* This dentry is possibly not currently connected to the dcache tree, in
+      * which case its parent will either be itself, or will have this flag as
+      * well.  nfsd will not use a dentry with this bit set, but will first
+      * endeavour to clear the bit either by discovering that it is connected,
+      * or by performing lookup operations.   Any filesystem which supports
+      * nfsd_operations MUST have a lookup function which, if it finds a
+      * directory inode with a DCACHE_DISCONNECTED dentry, will d_move that
+      * dentry into place and return that dentry rather than the passed one,
+      * typically using d_splice_alias. */
 
 #define DCACHE_REFERENCED	0x0008  /* Recently used, don't discard. */
 #define DCACHE_UNHASHED		0x0010	
-
-#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
+#define DCACHE_INOTIFY_PARENT_WATCHED 0x0020
+     /* Parent inode is watched by inotify */
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
-
-#define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
+#define DCACHE_FSNOTIFY_PARENT_WATCHED 0x0080
+     /* Parent inode is watched by some fsnotify listener */
 
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
+#define DCACHE_MOUNTED		0x0400	/* is a mountpoint */
+
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
@@ -381,7 +381,7 @@ extern void dput(struct dentry *);
 
 static inline int d_mountpoint(struct dentry *dentry)
 {
-	return dentry->d_mounted;
+	return dentry->d_flags & DCACHE_MOUNTED;
 }
 
 extern struct vfsmount *lookup_mnt(struct path *);
-- 
1.7.1

