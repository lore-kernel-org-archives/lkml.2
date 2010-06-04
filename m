Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0FDH31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:29:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:44237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0FDH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:28:33 -0400
Message-Id: <20100604072618.789552798@suse.de>
User-Agent: quilt/0.48-4.4
Date: Fri, 04 Jun 2010 16:43:11 +1000
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [patch 4/4] fs: brlock vfsmount_lock
References: <20100604064307.737085373@suse.de>
Content-Disposition: inline; filename=fs-vfsmount_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a brlock for the vfsmount lock. It must be taken for write whenever
modifying the mount hash or associated fields, and may be taken for read when
performing mount hash lookups.

The number of atomics should remain the same for fastpath rlock cases, though
code will be slightly slower due to per-cpu access. Scalability will probably
not be much improved in common cases yet, due to other locks getting in the
way. However independent path lookups over mountpoints should be one case
where scalability is improved.

The slowpath will be made significantly slower due to use of brlock. On a 64
core, 64 socket, 32 node Altix system (so a decent amount of latency to remote
nodes), a simple umount microbenchmark (mount --bind mnt mnt2 ; umount mnt2
loop 1000 times), before this patch it took 6.8s, afterwards took 7.1s, for
about 5% increase in elapsed time.

Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Frank Mayhar <fmayhar@google.com>,
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c    |   11 +--
 fs/internal.h  |    5 +
 fs/namei.c     |    7 +-
 fs/namespace.c |  174 +++++++++++++++++++++++++++++++++++----------------------
 fs/pnode.c     |   11 ++-
 5 files changed, 131 insertions(+), 77 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1926,7 +1926,7 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
-	spin_lock(&vfsmount_lock);
+	br_read_lock(vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -1962,7 +1962,7 @@ char *__d_path(const struct path *path,
 	}
 
 out:
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 	return retval;
 
 global_root:
@@ -2193,11 +2193,12 @@ int path_is_under(struct path *path1, st
 	struct vfsmount *mnt = path1->mnt;
 	struct dentry *dentry = path1->dentry;
 	int res;
-	spin_lock(&vfsmount_lock);
+
+	br_read_lock(vfsmount_lock);
 	if (mnt != path2->mnt) {
 		for (;;) {
 			if (mnt->mnt_parent == mnt) {
-				spin_unlock(&vfsmount_lock);
+				br_read_unlock(vfsmount_lock);
 				return 0;
 			}
 			if (mnt->mnt_parent == path2->mnt)
@@ -2207,7 +2208,7 @@ int path_is_under(struct path *path1, st
 		dentry = mnt->mnt_mountpoint;
 	}
 	res = is_subdir(dentry, path2->dentry);
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 	return res;
 }
 EXPORT_SYMBOL(path_is_under);
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -601,15 +601,16 @@ int follow_up(struct path *path)
 {
 	struct vfsmount *parent;
 	struct dentry *mountpoint;
-	spin_lock(&vfsmount_lock);
+
+	br_read_lock(vfsmount_lock);
 	parent = path->mnt->mnt_parent;
 	if (parent == path->mnt) {
-		spin_unlock(&vfsmount_lock);
+		br_read_unlock(vfsmount_lock);
 		return 0;
 	}
 	mntget(parent);
 	mountpoint = dget(path->mnt->mnt_mountpoint);
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -11,6 +11,8 @@
 #include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/percpu.h>
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -37,12 +39,10 @@
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
 
-/* spinlock for vfsmount related operations, inplace of dcache_lock */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
-
 static int event;
 static DEFINE_IDA(mnt_id_ida);
 static DEFINE_IDA(mnt_group_ida);
+static DEFINE_SPINLOCK(mnt_id_lock);
 static int mnt_id_start = 0;
 static int mnt_group_start = 1;
 
@@ -54,6 +54,16 @@ static struct rw_semaphore namespace_sem
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
 
+/*
+ * vfsmount lock may be taken for read to prevent changes to the
+ * vfsmount hash, ie. during mountpoint lookups or walking back
+ * up the tree.
+ *
+ * It should be taken for write in all cases where the vfsmount
+ * tree or hash is modified or when a vfsmount structure is modified.
+ */
+DEFINE_BRLOCK(vfsmount_lock);
+
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
@@ -64,18 +74,21 @@ static inline unsigned long hash(struct
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
-/* allocation is serialized by namespace_sem */
+/*
+ * allocation is serialized by namespace_sem, but we need the spinlock to
+ * serialize with freeing.
+ */
 static int mnt_alloc_id(struct vfsmount *mnt)
 {
 	int res;
 
 retry:
 	ida_pre_get(&mnt_id_ida, GFP_KERNEL);
-	spin_lock(&vfsmount_lock);
+	spin_lock(&mnt_id_lock);
 	res = ida_get_new_above(&mnt_id_ida, mnt_id_start, &mnt->mnt_id);
 	if (!res)
 		mnt_id_start = mnt->mnt_id + 1;
-	spin_unlock(&vfsmount_lock);
+	spin_unlock(&mnt_id_lock);
 	if (res == -EAGAIN)
 		goto retry;
 
@@ -85,11 +98,11 @@ retry:
 static void mnt_free_id(struct vfsmount *mnt)
 {
 	int id = mnt->mnt_id;
-	spin_lock(&vfsmount_lock);
+	spin_lock(&mnt_id_lock);
 	ida_remove(&mnt_id_ida, id);
 	if (mnt_id_start > id)
 		mnt_id_start = id;
-	spin_unlock(&vfsmount_lock);
+	spin_unlock(&mnt_id_lock);
 }
 
 /*
@@ -344,7 +357,7 @@ static int mnt_make_readonly(struct vfsm
 {
 	int ret = 0;
 
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	mnt->mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -378,15 +391,15 @@ static int mnt_make_readonly(struct vfsm
 	 */
 	smp_wmb();
 	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	mnt->mnt_flags &= ~MNT_READONLY;
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
@@ -410,6 +423,7 @@ void free_vfsmnt(struct vfsmount *mnt)
 /*
  * find the first or last mount at @dentry on vfsmount @mnt depending on
  * @dir. If @dir is set return the first mount else return the last mount.
+ * vfsmount_lock must be held for read or write.
  */
 struct vfsmount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry,
 			      int dir)
@@ -439,10 +453,11 @@ struct vfsmount *__lookup_mnt(struct vfs
 struct vfsmount *lookup_mnt(struct path *path)
 {
 	struct vfsmount *child_mnt;
-	spin_lock(&vfsmount_lock);
+
+	br_read_lock(vfsmount_lock);
 	if ((child_mnt = __lookup_mnt(path->mnt, path->dentry, 1)))
 		mntget(child_mnt);
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 	return child_mnt;
 }
 
@@ -451,6 +466,9 @@ static inline int check_mnt(struct vfsmo
 	return mnt->mnt_ns == current->nsproxy->mnt_ns;
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void touch_mnt_namespace(struct mnt_namespace *ns)
 {
 	if (ns) {
@@ -459,6 +477,9 @@ static void touch_mnt_namespace(struct m
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void __touch_mnt_namespace(struct mnt_namespace *ns)
 {
 	if (ns && ns->event != event) {
@@ -467,6 +488,9 @@ static void __touch_mnt_namespace(struct
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 {
 	old_path->dentry = mnt->mnt_mountpoint;
@@ -478,6 +502,9 @@ static void detach_mnt(struct vfsmount *
 	old_path->dentry->d_mounted--;
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
 			struct vfsmount *child_mnt)
 {
@@ -486,6 +513,9 @@ void mnt_set_mountpoint(struct vfsmount
 	dentry->d_mounted++;
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void attach_mnt(struct vfsmount *mnt, struct path *path)
 {
 	mnt_set_mountpoint(path->mnt, path->dentry, mnt);
@@ -495,7 +525,7 @@ static void attach_mnt(struct vfsmount *
 }
 
 /*
- * the caller must hold vfsmount_lock
+ * vfsmount lock must be held for write
  */
 static void commit_tree(struct vfsmount *mnt)
 {
@@ -618,15 +648,15 @@ static inline void __mntput(struct vfsmo
 void mntput_no_expire(struct vfsmount *mnt)
 {
 repeat:
-	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
+	if (atomic_dec_and_br_write_lock(&mnt->mnt_count, vfsmount_lock)) {
 		if (likely(!mnt->mnt_pinned)) {
-			spin_unlock(&vfsmount_lock);
+			br_write_unlock(vfsmount_lock);
 			__mntput(mnt);
 			return;
 		}
 		atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
 		mnt->mnt_pinned = 0;
-		spin_unlock(&vfsmount_lock);
+		br_write_unlock(vfsmount_lock);
 		acct_auto_close_mnt(mnt);
 		goto repeat;
 	}
@@ -636,21 +666,21 @@ EXPORT_SYMBOL(mntput_no_expire);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	mnt->mnt_pinned++;
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 }
 
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	if (mnt->mnt_pinned) {
 		atomic_inc(&mnt->mnt_count);
 		mnt->mnt_pinned--;
 	}
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 }
 
 EXPORT_SYMBOL(mnt_unpin);
@@ -741,12 +771,12 @@ int mnt_had_events(struct proc_mounts *p
 	struct mnt_namespace *ns = p->ns;
 	int res = 0;
 
-	spin_lock(&vfsmount_lock);
+	br_read_lock(vfsmount_lock);
 	if (p->event != ns->event) {
 		p->event = ns->event;
 		res = 1;
 	}
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 
 	return res;
 }
@@ -948,12 +978,12 @@ int may_umount_tree(struct vfsmount *mnt
 	int minimum_refs = 0;
 	struct vfsmount *p;
 
-	spin_lock(&vfsmount_lock);
+	br_read_lock(vfsmount_lock);
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
 		actual_refs += atomic_read(&p->mnt_count);
 		minimum_refs += 2;
 	}
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -980,10 +1010,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 	down_read(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	br_read_lock(vfsmount_lock);
 	if (propagate_mount_busy(mnt, 2))
 		ret = 0;
-	spin_unlock(&vfsmount_lock);
+	br_read_unlock(vfsmount_lock);
 	up_read(&namespace_sem);
 	return ret;
 }
@@ -999,13 +1029,14 @@ void release_mounts(struct list_head *he
 		if (mnt->mnt_parent != mnt) {
 			struct dentry *dentry;
 			struct vfsmount *m;
-			spin_lock(&vfsmount_lock);
+
+			br_write_lock(vfsmount_lock);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
 			mnt->mnt_parent = mnt;
 			m->mnt_ghosts--;
-			spin_unlock(&vfsmount_lock);
+			br_write_unlock(vfsmount_lock);
 			dput(dentry);
 			mntput(m);
 		}
@@ -1013,6 +1044,10 @@ void release_mounts(struct list_head *he
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ * namespace_sem must be held for write
+ */
 void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 {
 	struct vfsmount *p;
@@ -1103,7 +1138,7 @@ static int do_umount(struct vfsmount *mn
 	}
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1115,7 +1150,7 @@ static int do_umount(struct vfsmount *mn
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
 	}
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	return retval;
@@ -1227,19 +1262,19 @@ struct vfsmount *copy_tree(struct vfsmou
 			q = clone_mnt(p, p->mnt_root, flag);
 			if (!q)
 				goto Enomem;
-			spin_lock(&vfsmount_lock);
+			br_write_lock(vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
-			spin_unlock(&vfsmount_lock);
+			br_write_unlock(vfsmount_lock);
 		}
 	}
 	return res;
 Enomem:
 	if (res) {
 		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
+		br_write_lock(vfsmount_lock);
 		umount_tree(res, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
+		br_write_unlock(vfsmount_lock);
 		release_mounts(&umount_list);
 	}
 	return NULL;
@@ -1258,9 +1293,9 @@ void drop_collected_mounts(struct vfsmou
 {
 	LIST_HEAD(umount_list);
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	umount_tree(mnt, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 }
@@ -1388,7 +1423,7 @@ static int attach_recursive_mnt(struct v
 	if (err)
 		goto out_cleanup_ids;
 
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
@@ -1407,7 +1442,8 @@ static int attach_recursive_mnt(struct v
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
+
 	return 0;
 
  out_cleanup_ids:
@@ -1462,10 +1498,10 @@ static int do_change_type(struct path *p
 			goto out_unlock;
 	}
 
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 
  out_unlock:
 	up_write(&namespace_sem);
@@ -1509,9 +1545,10 @@ static int do_loopback(struct path *path
 	err = graft_tree(mnt, path);
 	if (err) {
 		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
+
+		br_write_lock(vfsmount_lock);
 		umount_tree(mnt, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
+		br_write_unlock(vfsmount_lock);
 		release_mounts(&umount_list);
 	}
 
@@ -1564,16 +1601,16 @@ static int do_remount(struct path *path,
 	else
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
-		spin_lock(&vfsmount_lock);
+		br_write_lock(vfsmount_lock);
 		mnt_flags |= path->mnt->mnt_flags & MNT_PROPAGATION_MASK;
 		path->mnt->mnt_flags = mnt_flags;
-		spin_unlock(&vfsmount_lock);
+		br_write_unlock(vfsmount_lock);
 	}
 	up_write(&sb->s_umount);
 	if (!err) {
-		spin_lock(&vfsmount_lock);
+		br_write_lock(vfsmount_lock);
 		touch_mnt_namespace(path->mnt->mnt_ns);
-		spin_unlock(&vfsmount_lock);
+		br_write_unlock(vfsmount_lock);
 	}
 	return err;
 }
@@ -1750,7 +1787,7 @@ void mark_mounts_for_expiry(struct list_
 		return;
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -1769,7 +1806,7 @@ void mark_mounts_for_expiry(struct list_
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1, &umounts);
 	}
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
@@ -1826,6 +1863,8 @@ resume:
 /*
  * process a list of expirable mountpoints with the intent of discarding any
  * submounts of a specific parent mountpoint
+ *
+ * vfsmount_lock must be held for write
  */
 static void shrink_submounts(struct vfsmount *mnt, struct list_head *umounts)
 {
@@ -2044,9 +2083,9 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2243,7 +2282,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		goto out2; /* not attached */
 	/* make sure we can reach put_old from new_root */
 	tmp = old.mnt;
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	if (tmp != new.mnt) {
 		for (;;) {
 			if (tmp->mnt_parent == tmp)
@@ -2263,7 +2302,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* mount new_root on / */
 	attach_mnt(new.mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	chroot_fs_refs(&root, &new);
 	error = 0;
 	path_put(&root_parent);
@@ -2278,7 +2317,7 @@ out1:
 out0:
 	return error;
 out3:
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	goto out2;
 }
 
@@ -2325,6 +2364,8 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
+	br_lock_init(vfsmount_lock);
+
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
@@ -2343,9 +2384,9 @@ void put_mnt_ns(struct mnt_namespace *ns
 	if (!atomic_dec_and_test(&ns->count))
 		return;
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	umount_tree(ns->root, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	kfree(ns);
Index: linux-2.6/fs/pnode.c
===================================================================
--- linux-2.6.orig/fs/pnode.c
+++ linux-2.6/fs/pnode.c
@@ -126,6 +126,9 @@ static int do_make_slave(struct vfsmount
 	return 0;
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 void change_mnt_propagation(struct vfsmount *mnt, int type)
 {
 	if (type == MS_SHARED) {
@@ -270,12 +273,12 @@ int propagate_mnt(struct vfsmount *dest_
 		prev_src_mnt  = child;
 	}
 out:
-	spin_lock(&vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct vfsmount, mnt_hash);
 		umount_tree(child, 0, &umount_list);
 	}
-	spin_unlock(&vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	release_mounts(&umount_list);
 	return ret;
 }
@@ -296,6 +299,8 @@ static inline int do_refcount_check(stru
  * other mounts its parent propagates to.
  * Check if any of these mounts that **do not have submounts**
  * have more references than 'refcnt'. If so return busy.
+ *
+ * vfsmount lock must be held for read or write
  */
 int propagate_mount_busy(struct vfsmount *mnt, int refcnt)
 {
@@ -353,6 +358,8 @@ static void __propagate_umount(struct vf
  * collect all mounts that receive propagation from the mount in @list,
  * and return these additional mounts in the same list.
  * @list: the list of mounts to be unmounted.
+ *
+ * vfsmount lock must be held for write
  */
 int propagate_umount(struct list_head *list)
 {
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h
+++ linux-2.6/fs/internal.h
@@ -9,6 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/lglock.h>
+
 struct super_block;
 struct linux_binprm;
 struct path;
@@ -70,7 +72,8 @@ extern struct vfsmount *copy_tree(struct
 
 extern void __init mnt_init(void);
 
-extern spinlock_t vfsmount_lock;
+DECLARE_BRLOCK(vfsmount_lock);
+
 
 /*
  * fs_struct.c


