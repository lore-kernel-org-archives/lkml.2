Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2BUR5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:57:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab2BUR5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:57:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/73] VFS: Make clone_mnt()/copy_tree()/collect_mounts()
 return errors [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Valerie Aurora <valerie.aurora@gmail.com>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Tue, 21 Feb 2012 17:57:36 +0000
Message-ID: <20120221175736.25235.30929.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_tree() can theoretically fail in a case other than ENOMEM, but always
returns NULL which is interpreted by callers as -ENOMEM.  Change it to return
an explicit error.

Also change clone_mnt() for consistency and because union mounts will add new
error cases.

Thanks to Andreas Gruenbacher <agruen@suse.de> for a bug fix.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Valerie Aurora <valerie.aurora@gmail.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
---

 fs/namespace.c      |  116 +++++++++++++++++++++++++++------------------------
 fs/pnode.c          |    5 +-
 kernel/audit_tree.c |   10 ++--
 3 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..baedd0b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -725,56 +725,60 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 					int flag)
 {
 	struct super_block *sb = old->mnt.mnt_sb;
-	struct mount *mnt = alloc_vfsmnt(old->mnt_devname);
+	struct mount *mnt;
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
 
-		mnt->mnt.mnt_flags = old->mnt.mnt_flags & ~MNT_WRITE_HOLD;
-		atomic_inc(&sb->s_active);
-		mnt->mnt.mnt_sb = sb;
-		mnt->mnt.mnt_root = dget(root);
-		mnt->mnt_mountpoint = mnt->mnt.mnt_root;
-		mnt->mnt_parent = mnt;
-		br_write_lock(vfsmount_lock);
-		list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
-		br_write_unlock(vfsmount_lock);
+	if (flag & (CL_SLAVE | CL_PRIVATE))
+		mnt->mnt_group_id = 0; /* not a peer of original */
+	else
+		mnt->mnt_group_id = old->mnt_group_id;
 
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
+	if ((flag & CL_MAKE_SHARED) && !mnt->mnt_group_id) {
+		err = mnt_alloc_group_id(mnt);
+		if (err)
+			goto out_free;
 	}
+
+	mnt->mnt.mnt_flags = old->mnt.mnt_flags & ~MNT_WRITE_HOLD;
+	atomic_inc(&sb->s_active);
+	mnt->mnt.mnt_sb = sb;
+	mnt->mnt.mnt_root = dget(root);
+	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
+	mnt->mnt_parent = mnt;
+	br_write_lock(vfsmount_lock);
+	list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
+	br_write_unlock(vfsmount_lock);
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
+	/* stick the duplicate mount on the same expiry list as the
+	 * original if that was on one */
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
 
 static inline void mntfree(struct mount *mnt)
@@ -1258,11 +1262,12 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
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
@@ -1284,8 +1289,8 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 			path.mnt = &q->mnt;
 			path.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt.mnt_root, flag);
-			if (!q)
-				goto Enomem;
+			if (IS_ERR(q))
+				goto out;
 			br_write_lock(vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
@@ -1293,7 +1298,7 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 		}
 	}
 	return res;
-Enomem:
+out:
 	if (res) {
 		LIST_HEAD(umount_list);
 		br_write_lock(vfsmount_lock);
@@ -1301,9 +1306,11 @@ Enomem:
 		br_write_unlock(vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-	return NULL;
+	return q;
 }
 
+/* Caller should check returned pointer for errors */
+
 struct vfsmount *collect_mounts(struct path *path)
 {
 	struct mount *tree;
@@ -1606,14 +1613,15 @@ static int do_loopback(struct path *path, char *old_name,
 	if (!check_mnt(real_mount(path->mnt)) || !check_mnt(old))
 		goto out2;
 
-	err = -ENOMEM;
 	if (recurse)
 		mnt = copy_tree(old, old_path.dentry, 0);
 	else
 		mnt = clone_mnt(old, old_path.dentry, 0);
 
-	if (!mnt)
-		goto out2;
+	if (IS_ERR(mnt)) {
+		err = PTR_ERR(mnt);
+		goto out;
+	}
 
 	err = graft_tree(mnt, path);
 	if (err) {
@@ -2244,10 +2252,10 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	down_write(&namespace_sem);
 	/* First pass: copy the tree topology */
 	new = copy_tree(old, old->mnt.mnt_root, CL_COPY_ALL | CL_EXPIRE);
-	if (!new) {
+	if (IS_ERR(new)) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
-		return ERR_PTR(-ENOMEM);
+		return ERR_CAST(new);
 	}
 	new_ns->root = new;
 	br_write_lock(vfsmount_lock);
diff --git a/fs/pnode.c b/fs/pnode.c
index ab5fa9e..b79d27c 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -237,8 +237,9 @@ int propagate_mnt(struct mount *dest_mnt, struct dentry *dest_dentry,
 
 		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
 
-		if (!(child = copy_tree(source, source->mnt.mnt_root, type))) {
-			ret = -ENOMEM;
+		child = copy_tree(source, source->mnt.mnt_root, type);
+		if (IS_ERR(child)) {
+			ret = PTR_ERR(child);
 			list_splice(tree_list, tmp_list.prev);
 			goto out;
 		}
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 5bf0790..3a5ca58 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -595,7 +595,7 @@ void audit_trim_trees(void)
 
 		root_mnt = collect_mounts(&path);
 		path_put(&path);
-		if (!root_mnt)
+		if (IS_ERR(root_mnt))
 			goto skip_it;
 
 		spin_lock(&hash_lock);
@@ -669,8 +669,8 @@ int audit_add_tree_rule(struct audit_krule *rule)
 		goto Err;
 	mnt = collect_mounts(&path);
 	path_put(&path);
-	if (!mnt) {
-		err = -ENOMEM;
+	if (IS_ERR(mnt)) {
+		err = PTR_ERR(mnt);
 		goto Err;
 	}
 
@@ -719,8 +719,8 @@ int audit_tag_tree(char *old, char *new)
 		return err;
 	tagged = collect_mounts(&path2);
 	path_put(&path2);
-	if (!tagged)
-		return -ENOMEM;
+	if (IS_ERR(tagged))
+		return PTR_ERR(tagged);
 
 	err = kern_path(old, 0, &path1);
 	if (err) {

