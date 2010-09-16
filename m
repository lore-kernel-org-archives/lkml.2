Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0IPWXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0IPWOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return error codes
Date: Thu, 16 Sep 2010 15:11:52 -0700
Message-Id: <1284675145-4391-2-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_tree() can theoretically fail in a case other than ENOMEM, but
always returns NULL which is interpreted by callers as -ENOMEM.
Convert to return an explicit error.  Convert clone_mnt() for
consistency and because union mounts will add new error cases.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |  111 ++++++++++++++++++++++++++++++--------------------------
 fs/pnode.c     |    5 ++-
 2 files changed, 63 insertions(+), 53 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e1ea335..5566524 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -559,53 +559,57 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 					int flag)
 {
 	struct super_block *sb = old->mnt_sb;
-	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
+	struct vfsmount *mnt;
+	int err;
 
-	if (mnt) {
-		if (flag & (CL_SLAVE | CL_PRIVATE))
-			mnt->mnt_group_id = 0; /* not a peer of original */
-		else
-			mnt->mnt_group_id = old->mnt_group_id;
-
-		if ((flag & CL_MAKE_SHARED) && !mnt->mnt_group_id) {
-			int err = mnt_alloc_group_id(mnt);
-			if (err)
-				goto out_free;
-		}
+	mnt = alloc_vfsmnt(old->mnt_devname);
+	if (!mnt)
+		return ERR_PTR(-ENOMEM);
 
-		mnt->mnt_flags = old->mnt_flags;
-		atomic_inc(&sb->s_active);
-		mnt->mnt_sb = sb;
-		mnt->mnt_root = dget(root);
-		mnt->mnt_mountpoint = mnt->mnt_root;
-		mnt->mnt_parent = mnt;
-
-		if (flag & CL_SLAVE) {
-			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
-			mnt->mnt_master = old;
-			CLEAR_MNT_SHARED(mnt);
-		} else if (!(flag & CL_PRIVATE)) {
-			if ((flag & CL_MAKE_SHARED) || IS_MNT_SHARED(old))
-				list_add(&mnt->mnt_share, &old->mnt_share);
-			if (IS_MNT_SLAVE(old))
-				list_add(&mnt->mnt_slave, &old->mnt_slave);
-			mnt->mnt_master = old->mnt_master;
-		}
-		if (flag & CL_MAKE_SHARED)
-			set_mnt_shared(mnt);
-
-		/* stick the duplicate mount on the same expiry list
-		 * as the original if that was on one */
-		if (flag & CL_EXPIRE) {
-			if (!list_empty(&old->mnt_expire))
-				list_add(&mnt->mnt_expire, &old->mnt_expire);
-		}
+	if (flag & (CL_SLAVE | CL_PRIVATE))
+		mnt->mnt_group_id = 0; /* not a peer of original */
+	else
+		mnt->mnt_group_id = old->mnt_group_id;
+
+	if ((flag & CL_MAKE_SHARED) && !mnt->mnt_group_id) {
+		err = mnt_alloc_group_id(mnt);
+		if (err)
+			goto out_free;
 	}
+
+	mnt->mnt_flags = old->mnt_flags;
+	atomic_inc(&sb->s_active);
+	mnt->mnt_sb = sb;
+	mnt->mnt_root = dget(root);
+	mnt->mnt_mountpoint = mnt->mnt_root;
+	mnt->mnt_parent = mnt;
+
+	if (flag & CL_SLAVE) {
+		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
+		mnt->mnt_master = old;
+		CLEAR_MNT_SHARED(mnt);
+	} else if (!(flag & CL_PRIVATE)) {
+		if ((flag & CL_MAKE_SHARED) || IS_MNT_SHARED(old))
+			list_add(&mnt->mnt_share, &old->mnt_share);
+		if (IS_MNT_SLAVE(old))
+			list_add(&mnt->mnt_slave, &old->mnt_slave);
+		mnt->mnt_master = old->mnt_master;
+	}
+	if (flag & CL_MAKE_SHARED)
+		set_mnt_shared(mnt);
+
+	/* stick the duplicate mount on the same expiry list
+	 * as the original if that was on one */
+	if (flag & CL_EXPIRE) {
+		if (!list_empty(&old->mnt_expire))
+			list_add(&mnt->mnt_expire, &old->mnt_expire);
+	}
+
 	return mnt;
 
  out_free:
 	free_vfsmnt(mnt);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static inline void __mntput(struct vfsmount *mnt)
@@ -1212,11 +1216,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 	struct path path;
 
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	res = q = clone_mnt(mnt, dentry, flag);
-	if (!q)
-		goto Enomem;
+	if (IS_ERR(q))
+		return q;
+
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
@@ -1237,8 +1242,8 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 			path.mnt = q;
 			path.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag);
-			if (!q)
-				goto Enomem;
+			if (IS_ERR(q))
+				goto out;
 			spin_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
@@ -1246,7 +1251,7 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 		}
 	}
 	return res;
-Enomem:
+out:
 	if (res) {
 		LIST_HEAD(umount_list);
 		spin_lock(&vfsmount_lock);
@@ -1254,9 +1259,11 @@ Enomem:
 		spin_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-	return NULL;
+	return q;
 }
 
+/* Caller should check returned pointer for errors */
+
 struct vfsmount *collect_mounts(struct path *path)
 {
 	struct vfsmount *tree;
@@ -1529,14 +1536,15 @@ static int do_loopback(struct path *path, char *old_name,
 	if (!check_mnt(path->mnt) || !check_mnt(old_path.mnt))
 		goto out;
 
-	err = -ENOMEM;
 	if (recurse)
 		mnt = copy_tree(old_path.mnt, old_path.dentry, 0);
 	else
 		mnt = clone_mnt(old_path.mnt, old_path.dentry, 0);
 
-	if (!mnt)
+	if (IS_ERR(mnt)) {
+		err = PTR_ERR(mnt);
 		goto out;
+	}
 
 	err = graft_tree(mnt, path);
 	if (err) {
@@ -2071,10 +2079,11 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
 					CL_COPY_ALL | CL_EXPIRE);
-	if (!new_ns->root) {
+	if (IS_ERR(new_ns->root)) {
+		int err = PTR_ERR(new_ns->root);
 		up_write(&namespace_sem);
 		kfree(new_ns);
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(err);
 	}
 	spin_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
diff --git a/fs/pnode.c b/fs/pnode.c
index 5cc564a..c4358d2 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -250,8 +250,9 @@ int propagate_mnt(struct vfsmount *dest_mnt, struct dentry *dest_dentry,
 
 		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
 
-		if (!(child = copy_tree(source, source->mnt_root, type))) {
-			ret = -ENOMEM;
+		child = copy_tree(source, source->mnt_root, type);
+		if (IS_ERR(child)) {
+			ret = PTR_ERR(child);
 			list_splice(tree_list, tmp_list.prev);
 			goto out;
 		}
-- 
1.6.3.3

