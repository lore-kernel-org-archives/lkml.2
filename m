Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2CEHIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:08:52 -0500
Received: from ozlabs.org ([203.10.76.45]:50247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2CEHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:08:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] brlocks/lglocks: API cleanups
In-Reply-To: <20120228112422.GC11324@alboin.amr.corp.intel.com>
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228112422.GC11324@alboin.amr.corp.intel.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 05 Mar 2012 17:34:36 +1030
Message-ID: <87linfzfy3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

lglocks and brlocks are currently generated with some complicated macros
in lglock.h.  But there's no reason to not just use common utility
functions and put all the data into a common data structure.

In preparation, this patch changes the API to look more like normal
function calls with pointers, not magic macros.

The patch is rather large because I move over all users in one go to keep
it bisectable.  This impacts the VFS somewhat in terms of lines changed.
But no actual behaviour change.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/dcache.c         |    4 -
 fs/file_table.c     |   16 ++---
 fs/namei.c          |   24 ++++----
 fs/namespace.c      |  140 ++++++++++++++++++++++++++--------------------------
 fs/pnode.c          |    4 -
 fs/proc_namespace.c |    4 -
 6 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2489,7 +2489,7 @@ static int prepend_path(const struct pat
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2520,7 +2520,7 @@ static int prepend_path(const struct pat
 		error = prepend(buffer, buflen, "/", 1);
 
 out:
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return error;
 
 global_root:
diff --git a/fs/file_table.c b/fs/file_table.c
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -422,9 +422,9 @@ static inline void __file_sb_list_add(st
  */
 void file_sb_list_add(struct file *file, struct super_block *sb)
 {
-	lg_local_lock(files_lglock);
+	lg_local_lock(&files_lglock);
 	__file_sb_list_add(file, sb);
-	lg_local_unlock(files_lglock);
+	lg_local_unlock(&files_lglock);
 }
 
 /**
@@ -437,9 +437,9 @@ void file_sb_list_add(struct file *file,
 void file_sb_list_del(struct file *file)
 {
 	if (!list_empty(&file->f_u.fu_list)) {
-		lg_local_lock_cpu(files_lglock, file_list_cpu(file));
+		lg_local_lock_cpu(&files_lglock, file_list_cpu(file));
 		list_del_init(&file->f_u.fu_list);
-		lg_local_unlock_cpu(files_lglock, file_list_cpu(file));
+		lg_local_unlock_cpu(&files_lglock, file_list_cpu(file));
 	}
 }
 
@@ -486,7 +486,7 @@ void mark_files_ro(struct super_block *s
 	struct file *f;
 
 retry:
-	lg_global_lock(files_lglock);
+	lg_global_lock(&files_lglock);
 	do_file_list_for_each_entry(sb, f) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
@@ -503,12 +503,12 @@ retry:
 		file_release_write(f);
 		mnt = mntget(f->f_path.mnt);
 		/* This can sleep, so we can't hold the spinlock. */
-		lg_global_unlock(files_lglock);
+		lg_global_unlock(&files_lglock);
 		mnt_drop_write(mnt);
 		mntput(mnt);
 		goto retry;
 	} while_file_list_for_each_entry;
-	lg_global_unlock(files_lglock);
+	lg_global_unlock(&files_lglock);
 }
 
 void __init files_init(unsigned long mempages)
@@ -526,6 +526,6 @@ void __init files_init(unsigned long mem
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
-	lg_lock_init(files_lglock);
+	lg_lock_init(&files_lglock, "files_lglock");
 	percpu_counter_init(&nr_files, 0);
 } 
diff --git a/fs/namei.c b/fs/namei.c
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -462,7 +462,7 @@ static int unlazy_walk(struct nameidata 
 	mntget(nd->path.mnt);
 
 	rcu_read_unlock();
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	nd->flags &= ~LOOKUP_RCU;
 	return 0;
 
@@ -520,14 +520,14 @@ static int complete_walk(struct nameidat
 		if (unlikely(!__d_rcu_to_refcount(dentry, nd->seq))) {
 			spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
-			br_read_unlock(vfsmount_lock);
+			br_read_unlock(&vfsmount_lock);
 			return -ECHILD;
 		}
 		BUG_ON(nd->inode != dentry->d_inode);
 		spin_unlock(&dentry->d_lock);
 		mntget(nd->path.mnt);
 		rcu_read_unlock();
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 
 	if (likely(!(nd->flags & LOOKUP_JUMPED)))
@@ -694,15 +694,15 @@ int follow_up(struct path *path)
 	struct mount *parent;
 	struct dentry *mountpoint;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	parent = mnt->mnt_parent;
 	if (&parent->mnt == path->mnt) {
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return 0;
 	}
 	mntget(&parent->mnt);
 	mountpoint = dget(mnt->mnt_mountpoint);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
@@ -960,7 +960,7 @@ failed:
 	if (!(nd->flags & LOOKUP_ROOT))
 		nd->root.mnt = NULL;
 	rcu_read_unlock();
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return -ECHILD;
 }
 
@@ -1256,7 +1256,7 @@ static void terminate_walk(struct nameid
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt = NULL;
 		rcu_read_unlock();
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 }
 
@@ -1515,7 +1515,7 @@ static int path_init(int dfd, const char
 		nd->path = nd->root;
 		nd->inode = inode;
 		if (flags & LOOKUP_RCU) {
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 		} else {
@@ -1528,7 +1528,7 @@ static int path_init(int dfd, const char
 
 	if (*name=='/') {
 		if (flags & LOOKUP_RCU) {
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 			set_root_rcu(nd);
 		} else {
@@ -1541,7 +1541,7 @@ static int path_init(int dfd, const char
 			struct fs_struct *fs = current->fs;
 			unsigned seq;
 
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 
 			do {
@@ -1577,7 +1577,7 @@ static int path_init(int dfd, const char
 			if (fput_needed)
 				*fp = file;
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 		} else {
 			path_get(&file->f_path);
diff --git a/fs/namespace.c b/fs/namespace.c
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -397,7 +397,7 @@ static int mnt_make_readonly(struct moun
 {
 	int ret = 0;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -431,15 +431,15 @@ static int mnt_make_readonly(struct moun
 	 */
 	smp_wmb();
 	mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct mount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt.mnt_flags &= ~MNT_READONLY;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 
 int sb_prepare_remount_readonly(struct super_block *sb)
@@ -451,7 +451,7 @@ int sb_prepare_remount_readonly(struct s
 	if (atomic_long_read(&sb->s_remove_count))
 		return -EBUSY;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
 		if (!(mnt->mnt.mnt_flags & MNT_READONLY)) {
 			mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
@@ -473,7 +473,7 @@ int sb_prepare_remount_readonly(struct s
 		if (mnt->mnt.mnt_flags & MNT_WRITE_HOLD)
 			mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	return err;
 }
@@ -522,14 +522,14 @@ struct vfsmount *lookup_mnt(struct path 
 {
 	struct mount *child_mnt;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	child_mnt = __lookup_mnt(path->mnt, path->dentry, 1);
 	if (child_mnt) {
 		mnt_add_count(child_mnt, 1);
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return &child_mnt->mnt;
 	} else {
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return NULL;
 	}
 }
@@ -714,9 +714,9 @@ vfs_kern_mount(struct file_system_type *
 	mnt->mnt.mnt_sb = root->d_sb;
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	mnt->mnt_parent = mnt;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_add_tail(&mnt->mnt_instance, &root->d_sb->s_mounts);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	return &mnt->mnt;
 }
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
@@ -745,9 +745,9 @@ static struct mount *clone_mnt(struct mo
 		mnt->mnt.mnt_root = dget(root);
 		mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 		mnt->mnt_parent = mnt;
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
@@ -803,35 +803,36 @@ static void mntput_no_expire(struct moun
 {
 put_again:
 #ifdef CONFIG_SMP
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (likely(atomic_read(&mnt->mnt_longterm))) {
 		mnt_add_count(mnt, -1);
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt_add_count(mnt, -1);
 	if (mnt_get_count(mnt)) {
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		return;
 	}
 #else
 	mnt_add_count(mnt, -1);
 	if (likely(mnt_get_count(mnt)))
 		return;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 #endif
 	if (unlikely(mnt->mnt_pinned)) {
 		mnt_add_count(mnt, mnt->mnt_pinned + 1);
 		mnt->mnt_pinned = 0;
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		acct_auto_close_mnt(&mnt->mnt);
 		goto put_again;
 	}
+
 	list_del(&mnt->mnt_instance);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	mntfree(mnt);
 }
 
@@ -857,21 +858,21 @@ EXPORT_SYMBOL(mntget);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	real_mount(mnt)->mnt_pinned++;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *m)
 {
 	struct mount *mnt = real_mount(m);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	if (mnt->mnt_pinned) {
 		mnt_add_count(mnt, 1);
 		mnt->mnt_pinned--;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 EXPORT_SYMBOL(mnt_unpin);
 
@@ -988,12 +989,12 @@ int may_umount_tree(struct vfsmount *m)
 	BUG_ON(!m);
 
 	/* write lock needed for mnt_get_count */
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
 		actual_refs += mnt_get_count(p);
 		minimum_refs += 2;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -1020,10 +1021,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 	down_read(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	if (propagate_mount_busy(real_mount(mnt), 2))
 		ret = 0;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_read(&namespace_sem);
 	return ret;
 }
@@ -1040,13 +1041,13 @@ void release_mounts(struct list_head *he
 			struct dentry *dentry;
 			struct mount *m;
 
-			br_write_lock(vfsmount_lock);
+			br_write_lock(&vfsmount_lock);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 			mnt->mnt_parent = mnt;
 			m->mnt_ghosts--;
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 			dput(dentry);
 			mntput(&m->mnt);
 		}
@@ -1112,12 +1113,12 @@ static int do_umount(struct mount *mnt, 
 		 * probably don't strictly need the lock here if we examined
 		 * all race cases, but it's a slowpath.
 		 */
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		if (mnt_get_count(mnt) != 2) {
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 			return -EBUSY;
 		}
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 
 		if (!xchg(&mnt->mnt_expiry_mark, 1))
 			return -EAGAIN;
@@ -1159,7 +1160,7 @@ static int do_umount(struct mount *mnt, 
 	}
 
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1171,7 +1172,7 @@ static int do_umount(struct mount *mnt, 
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	return retval;
@@ -1286,19 +1287,19 @@ struct mount *copy_tree(struct mount *mn
 			q = clone_mnt(p, p->mnt.mnt_root, flag);
 			if (!q)
 				goto Enomem;
-			br_write_lock(vfsmount_lock);
+			br_write_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 		}
 	}
 	return res;
 Enomem:
 	if (res) {
 		LIST_HEAD(umount_list);
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		umount_tree(res, 0, &umount_list);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
 	return NULL;
@@ -1318,9 +1319,9 @@ void drop_collected_mounts(struct vfsmou
 {
 	LIST_HEAD(umount_list);
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	umount_tree(real_mount(mnt), 0, &umount_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 }
@@ -1448,7 +1449,7 @@ static int attach_recursive_mnt(struct m
 	if (err)
 		goto out_cleanup_ids;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
@@ -1467,7 +1468,7 @@ static int attach_recursive_mnt(struct m
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	return 0;
 
@@ -1565,10 +1566,10 @@ static int do_change_type(struct path *p
 			goto out_unlock;
 	}
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
  out_unlock:
 	up_write(&namespace_sem);
@@ -1617,9 +1618,9 @@ static int do_loopback(struct path *path
 
 	err = graft_tree(mnt, path);
 	if (err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		umount_tree(mnt, 0, &umount_list);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 out2:
 	unlock_mount(path);
@@ -1677,16 +1678,16 @@ static int do_remount(struct path *path,
 	else
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 	up_write(&sb->s_umount);
 	if (!err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		touch_mnt_namespace(mnt->mnt_ns);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 	return err;
 }
@@ -1893,9 +1894,9 @@ fail:
 	/* remove m from any expiration list it may be on */
 	if (!list_empty(&mnt->mnt_expire)) {
 		down_write(&namespace_sem);
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		list_del_init(&mnt->mnt_expire);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		up_write(&namespace_sem);
 	}
 	mntput(m);
@@ -1911,11 +1912,11 @@ fail:
 void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list)
 {
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	list_add_tail(&real_mount(mnt)->mnt_expire, expiry_list);
 
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 }
 EXPORT_SYMBOL(mnt_set_expiry);
@@ -1935,7 +1936,7 @@ void mark_mounts_for_expiry(struct list_
 		return;
 
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -1954,7 +1955,7 @@ void mark_mounts_for_expiry(struct list_
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1, &umounts);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
@@ -2218,9 +2219,9 @@ void mnt_make_shortterm(struct vfsmount 
 	struct mount *mnt = real_mount(m);
 	if (atomic_add_unless(&mnt->mnt_longterm, -1, 1))
 		return;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	atomic_dec(&mnt->mnt_longterm);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 #endif
 }
 
@@ -2249,10 +2250,9 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
-	new_ns->root = new;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new->mnt_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2416,9 +2416,9 @@ bool is_path_reachable(struct mount *mnt
 int path_is_under(struct path *path1, struct path *path2)
 {
 	int res;
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	res = is_path_reachable(real_mount(path1->mnt), path1->dentry, path2);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return res;
 }
 EXPORT_SYMBOL(path_is_under);
@@ -2505,7 +2505,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* make sure we can reach put_old from new_root */
 	if (!is_path_reachable(real_mount(old.mnt), old.dentry, &new))
 		goto out4;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	detach_mnt(new_mnt, &parent_path);
 	detach_mnt(root_mnt, &root_parent);
 	/* mount old root on put_old */
@@ -2513,7 +2513,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* mount new_root on / */
 	attach_mnt(new_mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	chroot_fs_refs(&root, &new);
 	error = 0;
 out4:
@@ -2576,7 +2576,7 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
-	br_lock_init(vfsmount_lock);
+	br_lock_init(&vfsmount_lock);
 
 	err = sysfs_init();
 	if (err)
@@ -2596,9 +2596,9 @@ void put_mnt_ns(struct mnt_namespace *ns
 	if (!atomic_dec_and_test(&ns->count))
 		return;
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	umount_tree(ns->root, 0, &umount_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	kfree(ns);
diff --git a/fs/pnode.c b/fs/pnode.c
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -257,12 +257,12 @@ int propagate_mnt(struct mount *dest_mnt
 		prev_src_mnt  = child;
 	}
 out:
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct mount, mnt_hash);
 		umount_tree(child, 0, &umount_list);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	release_mounts(&umount_list);
 	return ret;
 }
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -23,12 +23,12 @@ static unsigned mounts_poll(struct file 
 
 	poll_wait(file, &p->ns->poll, wait);
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (p->m.poll_event != ns->event) {
 		p->m.poll_event = ns->event;
 		res |= POLLERR | POLLPRI;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	return res;
 }
-- 
  Please can you help my fiance Alex?  http://baldalex.org
