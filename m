Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2BUT61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:58:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab2BUTx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/73] tmpfs: Add fallthru support [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:59:39 +0000
Message-ID: <20120221175939.25235.65321.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Add support for fallthru directory entries to tmpfs.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c |    4 +++-
 fs/libfs.c  |   16 ++++++++++++---
 mm/shmem.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b1ce8d1..238684a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2896,7 +2896,9 @@ resume:
 		 * can evict it.
 		 */
 		if (d_unhashed(dentry) ||
-		    (!dentry->d_inode && !d_is_whiteout(dentry))) {
+		    (!dentry->d_inode &&
+		     !d_is_whiteout(dentry) &&
+		     !d_is_fallthru(dentry))) {
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
diff --git a/fs/libfs.c b/fs/libfs.c
index 38eb46d..43f1ac2 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -141,6 +141,7 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct dentry *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->d_u.d_child;
 	ino_t ino;
+	char d_type;
 	int i = filp->f_pos;
 
 	switch (i) {
@@ -167,17 +168,26 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
 				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
-				if (!simple_positive(next)) {
+				if (d_unhashed(next) ||
+				    (!next->d_inode && !d_is_fallthru(next))) {
 					spin_unlock(&next->d_lock);
 					continue;
 				}
 
 				spin_unlock(&next->d_lock);
 				spin_unlock(&dentry->d_lock);
+				if (d_is_fallthru(next)) {
+					/* XXX placeholder until generic_readdir_fallthru() arrives */
+					ino = 1;
+					d_type = DT_UNKNOWN;
+				} else {
+					ino = next->d_inode->i_ino;
+					d_type = dt_type(next->d_inode);
+				}
+
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
-					    dt_type(next->d_inode)) < 0)
+					    ino, d_type) < 0)
 					return 0;
 				spin_lock(&dentry->d_lock);
 				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
diff --git a/mm/shmem.c b/mm/shmem.c
index ca0bd30..bfd9ac8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1481,8 +1481,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry);
 static int shmem_unlink(struct inode *dir, struct dentry *dentry);
 
 /*
- * This is the whiteout support for tmpfs. It uses one singleton whiteout
- * inode per superblock thus it is very similar to shmem_link().
+ * Create a dentry to signify a whiteout.
  */
 static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 			  struct dentry *new_dentry)
@@ -1513,8 +1512,10 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 		spin_unlock(&sbinfo->stat_lock);
 	}
 
-	if (old_dentry->d_inode) {
-		if (S_ISDIR(old_dentry->d_inode->i_mode))
+	if (old_dentry->d_inode || d_is_fallthru(old_dentry)) {
+		/* A fallthru for a dir is treated like a regular link */
+		if (old_dentry->d_inode &&
+		    S_ISDIR(old_dentry->d_inode->i_mode))
 			shmem_rmdir(dir, old_dentry);
 		else
 			shmem_unlink(dir, old_dentry);
@@ -1531,6 +1532,48 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 }
 
 static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
+				struct inode *inode);
+
+/*
+ * Create a dentry to signify a fallthru.  A fallthru in tmpfs is the
+ * logical equivalent of an in-kernel readdir() cache.  It can't be
+ * deleted until the file system is unmounted.
+ */
+static int shmem_fallthru(struct inode *dir, struct dentry *dentry)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
+
+	/* FIXME: this is stupid */
+	if (!(dir->i_sb->s_flags & MS_WHITEOUT))
+		return -EPERM;
+
+	if (dentry->d_inode || d_is_fallthru(dentry) || d_is_whiteout(dentry))
+		return -EEXIST;
+
+	/*
+	 * Each new link needs a new dentry, pinning lowmem, and tmpfs
+	 * dentries cannot be pruned until they are unlinked.
+	 */
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		if (!sbinfo->free_inodes) {
+			spin_unlock(&sbinfo->stat_lock);
+			return -ENOSPC;
+		}
+		sbinfo->free_inodes--;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+
+	shmem_d_instantiate(dir, dentry, NULL);
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+	return 0;
+}
+
+static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
 				struct inode *inode)
 {
 	if (d_is_whiteout(dentry)) {
@@ -1538,14 +1581,15 @@ static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
 		shmem_free_inode(dir->i_sb);
 		if (S_ISDIR(inode->i_mode))
 			inode->i_mode |= S_OPAQUE;
+	} else if (d_is_fallthru(dentry)) {
+		shmem_free_inode(dir->i_sb);
 	} else {
 		/* New dentry */
 		dir->i_size += BOGO_DIRENT_SIZE;
 		dget(dentry); /* Extra count - pin the dentry in core */
 	}
-	/* Will clear DCACHE_WHITEOUT flag */
+	/* Will clear DCACHE_WHITEOUT and DCACHE_FALLTHRU flags */
 	d_instantiate(dentry, inode);
-
 }
 /*
  * File creation. Allocate an inode, and we're done..
@@ -1627,7 +1671,8 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (d_is_whiteout(dentry) || (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
+	if (d_is_whiteout(dentry) || d_is_fallthru(dentry) ||
+	    (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
 		shmem_free_inode(dir->i_sb);
 
 	if (inode) {
@@ -2347,8 +2392,10 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root = root;
 
 #ifdef CONFIG_TMPFS
-	if (!(sb->s_flags & MS_NOUSER))
+	if (!(sb->s_flags & MS_NOUSER)) {
 		sb->s_flags |= MS_WHITEOUT;
+		sb->s_flags |= MS_FALLTHRU;
+	}
 #endif
 
 	return 0;
@@ -2451,6 +2498,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
 	.whiteout       = shmem_whiteout,
+	.fallthru       = shmem_fallthru,
 #endif
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,

