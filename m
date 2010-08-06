Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965854Ab0HFWlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965784Ab0HFWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:46 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 21/38] union-mount: Support for union mounting file systems
Date: Fri,  6 Aug 2010 15:35:07 -0700
Message-Id: <1281134124-17041-22-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create and tear down union mount structures on mount.  Check
requirements for union mounts.  This version clones the read-only
mounts as one big tree and points to them from the superblock of the
topmost layer file system.

Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix and Miklos
Szeredi <miklos@szeredi.hu> for better mount error messages.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |  255 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/super.c            |    1 +
 include/linux/fs.h    |    7 ++
 include/linux/mount.h |    2 +
 4 files changed, 263 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f115cb6..aa6a132 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -33,6 +33,7 @@
 #include <asm/unistd.h>
 #include "pnode.h"
 #include "internal.h"
+#include "union.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -1050,6 +1051,7 @@ void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 		propagate_umount(kill);
 
 	list_for_each_entry(p, kill, mnt_hash) {
+		d_free_unions(p->mnt_root);
 		list_del_init(&p->mnt_expire);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
@@ -1333,6 +1335,217 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
 	return 0;
 }
 
+/**
+ * check_mnt_union - mount-time checks for union mount
+ *
+ * @mntpnt: path of the mountpoint the new mount will be on
+ * @topmost_mnt: vfsmount of the new file system to be mounted
+ * @mnt_flags: mount flags for the new file system
+ *
+ * Mount-time check of upper and lower layer file systems to see if we
+ * can union mount one on the other.
+ *
+ * The rules:
+ *
+ * Lower layer(s) and submounts read-only: We can't deal with
+ * namespace changes in the lower layers of a union, so the lower
+ * layer must be read-only.  Note that we could possibly convert a
+ * read-write unioned mount into a read-only mount here.
+ *
+ * Lower layer(s) and submounts not shared: The lower layer(s) of a
+ * union mount must not have any changes to its namespace.  Therefore,
+ * it must not be part of any mount event propagation group - i.e.,
+ * shared or slave.
+ *
+ * Union only at roots of file systems: Only permit unioning of file
+ * systems at their root directories.  This allows us to mark entire
+ * mounts as unioned.  Otherwise we must slowly and expensively work
+ * our way up a path looking for a unioned directory before we know if
+ * a path is from a unioned lower layer.
+ *
+ * Topmost layer must be writable to support our readdir()
+ * solution of copying up all lower level entries to the
+ * topmost layer.
+ *
+ * Topmost file system must support whiteouts and fallthrus.
+ *
+ * Topmost file system can't be mounted elsewhere. XXX implement some
+ * kind of marker in the superblock so subsequent mounts are not
+ * possible.
+ *
+ */
+
+static int
+check_mnt_union(struct path *mntpnt, struct vfsmount *topmost_mnt, int mnt_flags)
+{
+	struct vfsmount *p, *lower_mnt = mntpnt->mnt;
+
+	if (!(mnt_flags & MNT_UNION))
+		return 0;
+
+#ifndef CONFIG_UNION_MOUNT
+	printk(KERN_INFO "union mount: not supported by the kernel\n");
+	return -EINVAL;
+#endif
+	for (p = lower_mnt; p; p = next_mnt(p, lower_mnt)) {
+		if (!(p->mnt_sb->s_flags & MS_RDONLY))
+			return -EBUSY;
+		if (IS_MNT_SHARED(p) || IS_MNT_SLAVE(p))
+			return -EBUSY;
+	}
+
+	if (!IS_ROOT(mntpnt->dentry)) {
+		printk(KERN_INFO "union mount: mount point must be a root dir\n");
+		return -EINVAL;
+	}
+
+	if (mnt_flags & MNT_READONLY)
+		return -EROFS;
+
+	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT)) {
+		printk(KERN_INFO "union mount: whiteouts not supported by fs\n");
+		return -EINVAL;
+	}
+
+	if (!(topmost_mnt->mnt_sb->s_flags & MS_FALLTHRU)) {
+		printk(KERN_INFO "union mount: fallthrus not supported by fs\n");
+		return -EINVAL;
+	}
+
+	/* XXX top level mount should only be mounted once */
+
+	return 0;
+}
+
+void put_union_sb(struct super_block *sb)
+{
+	struct vfsmount *p, *mnt;
+	LIST_HEAD(umount_list);
+
+	if (!sb->s_ro_union_mnts)
+		return;
+	mnt = sb->s_ro_union_mnts;
+	for (p = mnt; p; p = next_mnt(p, mnt))
+		dec_hard_readonly_users(p);
+	spin_lock(&vfsmount_lock);
+	umount_tree(mnt, 0, &umount_list);
+	spin_unlock(&vfsmount_lock);
+	release_mounts(&umount_list);
+}
+
+static void cleanup_mnt_union(struct vfsmount *topmost_mnt)
+{
+	d_free_unions(topmost_mnt->mnt_root);
+	put_union_sb(topmost_mnt->mnt_sb);
+}
+
+/*
+ * find_union_root - Find the "lowest" (union low) mount to be unioned
+ */
+
+static struct vfsmount *find_union_root(struct vfsmount *topmost_mnt, struct path *mntpnt)
+{
+	struct path this_layer = *mntpnt;
+	struct vfsmount *lowest_mnt = NULL;
+
+	while(check_mnt_union(&this_layer, topmost_mnt, MNT_UNION) == 0) {
+		lowest_mnt = this_layer.mnt;
+		this_layer.dentry = this_layer.mnt->mnt_mountpoint;
+		this_layer.mnt = this_layer.mnt->mnt_parent;
+	}
+	return lowest_mnt;
+}
+
+/*
+ * Build the union stack for the root dir.  Note that topmost_mnt is
+ * not connected to the mount tree yet and that the cloned tree is not
+ * either.
+ */
+
+static int build_root_union(struct vfsmount *topmost_mnt, struct vfsmount *clone_root)
+{
+	struct union_dir **next_ud;
+	struct path upper, lower;
+	struct vfsmount *p, *mnt;
+	int err = 0;
+
+	/*
+	 * Find the topmost read-only mount, starting from the root
+	 * of the cloned tree of read-only mounts. __lookup_mnt() and
+	 * friends don't work because the cloned tree is not mounted
+	 * anywhere.
+	 */
+	mnt = clone_root;
+	for (p = clone_root; p; p = next_mnt(p, clone_root)) {
+		if ((p->mnt_parent == mnt) &&
+		    (p->mnt_mountpoint == mnt->mnt_root))
+			mnt = p;
+	}
+
+	/* Build the root union stack */
+	upper.mnt = topmost_mnt;
+	upper.dentry = topmost_mnt->mnt_root;
+	next_ud = &upper.dentry->d_union_dir;
+
+	while (upper.mnt != clone_root) {
+		lower.mnt = mntget(mnt);
+		lower.dentry = dget(mnt->mnt_root);
+		err = union_add_dir(&upper, &lower, next_ud);
+		if (err)
+			goto out;
+		next_ud = &(*next_ud)->u_lower;
+		upper = lower;
+		mnt = mnt->mnt_parent;
+	}
+out:
+	return err;
+}
+
+/**
+ * prepare_mnt_union - do setup necessary for a union mount
+ *
+ * @topmost_mnt: vfsmount of topmost layer
+ * @mntpnt: path of requested mountpoint
+ *
+ * We union every underlying file system that is mounted on the same
+ * mountpoint (well, pathname), read-only, and not shared.  We clone
+ * the entire underlying read-only mount tree and keep a pointer to it
+ * from the topmost file system's superblock.
+ *
+ * XXX - Maybe should take # of layers to go down as an argument. But
+ * how to pass this in through mount options? All solutions look ugly.
+ */
+
+static int prepare_mnt_union(struct vfsmount *topmost_mnt, struct path *mntpnt)
+{
+	struct super_block *sb = topmost_mnt->mnt_sb;
+	struct vfsmount *p, *clone_root;
+	int err;
+
+	clone_root = find_union_root(topmost_mnt, mntpnt);
+	if (!clone_root)
+		return 0; /* Nothing to union */
+
+	/* Clone the whole mount tree that we're going to union. */
+	err = -ENOMEM;
+	sb->s_ro_union_mnts = copy_tree(clone_root, clone_root->mnt_root,
+					CL_COPY_ALL | CL_PRIVATE);
+	if (!sb->s_ro_union_mnts)
+		goto out;
+
+	for (p = sb->s_ro_union_mnts; p; p = next_mnt(p, sb->s_ro_union_mnts))
+		inc_hard_readonly_users(p);
+
+	err = build_root_union(topmost_mnt, clone_root);
+	if (err)
+		goto out;
+
+	return 0;
+out:
+	cleanup_mnt_union(topmost_mnt);
+	return err;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
@@ -1410,9 +1623,16 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 		if (err)
 			goto out;
 	}
+
+	if (!parent_path && IS_MNT_UNION(source_mnt)) {
+		err = prepare_mnt_union(source_mnt, path);
+		if (err)
+			goto out_cleanup_ids;
+	}
+
 	err = propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list);
 	if (err)
-		goto out_cleanup_ids;
+		goto out_cleanup_union;
 
 	spin_lock(&vfsmount_lock);
 
@@ -1436,6 +1656,9 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 	spin_unlock(&vfsmount_lock);
 	return 0;
 
+ out_cleanup_union:
+	if (IS_MNT_UNION(source_mnt))
+		cleanup_mnt_union(source_mnt);
  out_cleanup_ids:
 	if (IS_MNT_SHARED(dest_mnt))
 		cleanup_group_ids(source_mnt, NULL);
@@ -1482,6 +1705,17 @@ static int do_change_type(struct path *path, int flag)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
+
+	/*
+	 * Mounts of file systems with read-only users can't deal with
+	 * mount/umount propagation events - it's the moral equivalent
+	 * of rm -rf dir/ or the like.
+	 */
+	if (sb_is_hard_readonly(mnt->mnt_sb)) {
+		err = -EROFS;
+		goto out_unlock;
+	}
+
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
@@ -1519,6 +1753,9 @@ static int do_loopback(struct path *path, char *old_name,
 	err = -EINVAL;
 	if (IS_MNT_UNBINDABLE(old_path.mnt))
 		goto out;
+	/* Mount part of a union mount elsewhere? The mind boggles. */
+	if (IS_MNT_UNION(old_path.mnt))
+		goto out;
 
 	if (!check_mnt(path->mnt) || !check_mnt(old_path.mnt))
 		goto out;
@@ -1540,7 +1777,6 @@ static int do_loopback(struct path *path, char *old_name,
 		spin_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
-
 out:
 	up_write(&namespace_sem);
 	path_put(&old_path);
@@ -1581,6 +1817,17 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (!check_mnt(path->mnt))
 		return -EINVAL;
 
+	if (mnt_flags & MNT_UNION)
+		return -EINVAL;
+
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    !(mnt_flags & MNT_UNION))
+		return -EINVAL;
+
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    (mnt_flags & MNT_READONLY))
+		return -EINVAL;
+
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
@@ -1743,6 +1990,10 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	err = check_mnt_union(path, newmnt, mnt_flags);
+	if (err)
+		goto unlock;
+
 	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
diff --git a/fs/super.c b/fs/super.c
index 86bdf1f..bdfe98f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -160,6 +160,7 @@ void deactivate_locked_super(struct super_block *s)
 	if (atomic_dec_and_test(&s->s_active)) {
 		fs->kill_sb(s);
 		put_filesystem(fs);
+		put_union_sb(s);
 		put_super(s);
 	} else {
 		up_write(&s->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 31cfa48..b88d088 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1397,6 +1397,13 @@ struct super_block {
 	 * read-only.
 	 */
 	int s_hard_readonly_users;
+
+	/*
+	 * If this is the topmost file system in a union mount, this
+	 * points to the root of the private cloned vfsmount tree of
+	 * the read-only mounts in this union.
+	 */
+	struct vfsmount *s_ro_union_mnts;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 0302703..17d3d27 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -136,4 +136,6 @@ extern void mark_mounts_for_expiry(struct list_head *mounts);
 
 extern dev_t name_to_dev_t(char *name);
 
+extern void put_union_sb(struct super_block *sb);
+
 #endif /* _LINUX_MOUNT_H */
-- 
1.6.3.3

