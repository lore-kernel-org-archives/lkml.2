Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0LMCmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 21:42:23 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52483 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab0LMCmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 21:42:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIsWBU15LdLl/2dsb2JhbACjf3nATYVKBA
Date: Mon, 13 Dec 2010 13:42:17 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and dcache
 scaling tree update and status)
Message-ID: <20101213024217.GC6522@amd>
References: <20101213023733.GB6522@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213023733.GB6522@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 01:37:33PM +1100, Nick Piggin wrote:
> Final note:
> You won't be able to reproduce the parallel path walk scalability
> numbers that I've posted, because the vfsmount refcounting scalability
> patch is not included. I have a new idea for that now, so I'll be asking
> for comments with that soon.

Here is the patch I've been using, which works but has the problem
described in the changelog. But it works nicely for testing.

As I said, I have a promising approach to solving the problem.

fs: scale mntget/mntput

Improve scalability of mntget/mntput by using per-cpu counters protected by the
reader side of the brlock vfsmount_lock. If the mnt_hash field of the vfsmount
structure is attached to a list, then it is mounted which contributes to its
refcount, so the per-cpu counters need not be summed.

MNT_PSEUDO keeps track of whether the vfsmount is actually a pseudo filesystem
that will never be attached (such as sockfs).

No extra atomics in the common case because atomic mnt refcount is now replaced
with per-CPU spinlock. Code will be bigger and more complex however. With the
previous per-cpu locking patch, mount lookups and common case refcounting are
now per-cpu and should be ideally scalable. path lookups (and hence
path_get/path_put) within the same vfsmount should now be more scalable,
however this will often be hidden by dcache_lock on final dput, and d_lock on
common path elements (eg. cwd or root dentry).

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

[Note: this is not for merging. Un-attached operation (lazy umount) may not be
 uncommon and will be slowed down and actually have worse scalablilty after
 this patch. I need to think about how to do fast refcounting with unattached
 mounts.]

---
 drivers/mtd/mtdchar.c |    1 
 fs/internal.h         |    1 
 fs/libfs.c            |    1 
 fs/namespace.c        |  167 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/pnode.c            |    4 -
 include/linux/mount.h |   26 +------
 6 files changed, 154 insertions(+), 46 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-12-12 03:48:57.000000000 +1100
+++ linux-2.6/fs/namespace.c	2010-12-12 03:51:52.000000000 +1100
@@ -138,6 +138,64 @@ void mnt_release_group_id(struct vfsmoun
 	mnt->mnt_group_id = 0;
 }
 
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void add_mnt_count(struct vfsmount *mnt, int n)
+{
+#ifdef CONFIG_SMP
+	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) += n;
+#else
+	mnt->mnt_count += n;
+#endif
+}
+
+static inline void set_mnt_count(struct vfsmount *mnt, int n)
+{
+#ifdef CONFIG_SMP
+	preempt_disable();
+	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) = n;
+	preempt_enable();
+#else
+	mnt->mnt_count = n;
+#endif
+}
+
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void inc_mnt_count(struct vfsmount *mnt)
+{
+	add_mnt_count(mnt, 1);
+}
+
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void dec_mnt_count(struct vfsmount *mnt)
+{
+	add_mnt_count(mnt, -1);
+}
+
+/*
+ * vfsmount lock must be held for write
+ */
+unsigned int count_mnt_count(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	unsigned int count = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		count += *per_cpu_ptr(mnt->mnt_count, cpu);
+	}
+
+	return count;
+#else
+	return mnt->mnt_count;
+#endif
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
@@ -154,7 +212,15 @@ struct vfsmount *alloc_vfsmnt(const char
 				goto out_free_id;
 		}
 
-		atomic_set(&mnt->mnt_count, 1);
+#ifdef CONFIG_SMP
+		mnt->mnt_count = alloc_percpu(int);
+		if (!mnt->mnt_count)
+			goto out_free_devname;
+#else
+		mnt->mnt_count = 0;
+#endif
+		set_mnt_count(mnt, 1);
+
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
 		INIT_LIST_HEAD(&mnt->mnt_mounts);
@@ -169,7 +235,7 @@ struct vfsmount *alloc_vfsmnt(const char
 #ifdef CONFIG_SMP
 		mnt->mnt_writers = alloc_percpu(int);
 		if (!mnt->mnt_writers)
-			goto out_free_devname;
+			goto out_free_mntcount;
 #else
 		mnt->mnt_writers = 0;
 #endif
@@ -177,6 +243,8 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 
 #ifdef CONFIG_SMP
+out_free_mntcount:
+	free_percpu(mnt->mnt_count);
 out_free_devname:
 	kfree(mnt->mnt_devname);
 #endif
@@ -662,8 +730,8 @@ static inline void __mntput(struct vfsmo
 	 * to make r/w->r/o transitions.
 	 */
 	/*
-	 * atomic_dec_and_lock() used to deal with ->mnt_count decrements
-	 * provides barriers, so count_mnt_writers() below is safe.  AV
+	 * The locking used to deal with mnt_count decrement provides barriers,
+	 * so count_mnt_writers() below is safe.
 	 */
 	WARN_ON(count_mnt_writers(mnt));
 	fsnotify_vfsmount_delete(mnt);
@@ -675,45 +743,76 @@ static inline void __mntput(struct vfsmo
 void mntput_no_expire(struct vfsmount *mnt)
 {
 repeat:
-	if (atomic_add_unless(&mnt->mnt_count, -1, 1))
+	if (likely(!list_empty(&mnt->mnt_hash) ||
+				mnt->mnt_flags & MNT_PSEUDO)) {
+		br_read_lock(vfsmount_lock);
+		if (unlikely(list_empty(&mnt->mnt_hash) &&
+				(!(mnt->mnt_flags & MNT_PSEUDO)))) {
+			br_read_unlock(vfsmount_lock);
+			goto repeat;
+		}
+		dec_mnt_count(mnt);
+		br_read_unlock(vfsmount_lock);
 		return;
+	}
+
 	br_write_lock(vfsmount_lock);
-	if (!atomic_dec_and_test(&mnt->mnt_count)) {
+	dec_mnt_count(mnt);
+	if (count_mnt_count(mnt)) {
 		br_write_unlock(vfsmount_lock);
 		return;
 	}
-	if (likely(!mnt->mnt_pinned)) {
+	if (unlikely(mnt->mnt_pinned)) {
+		add_mnt_count(mnt, mnt->mnt_pinned + 1);
+		mnt->mnt_pinned = 0;
 		br_write_unlock(vfsmount_lock);
-		__mntput(mnt);
-		return;
+		acct_auto_close_mnt(mnt);
+		goto repeat;
 	}
-	atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
-	mnt->mnt_pinned = 0;
 	br_write_unlock(vfsmount_lock);
-	acct_auto_close_mnt(mnt);
-	goto repeat;
+	__mntput(mnt);
 }
 EXPORT_SYMBOL(mntput_no_expire);
 
+void mntput(struct vfsmount *mnt)
+{
+	if (mnt) {
+		/* avoid cacheline pingpong, hope gcc doesn't get "smart" */
+		if (unlikely(mnt->mnt_expiry_mark))
+			mnt->mnt_expiry_mark = 0;
+		mntput_no_expire(mnt);
+	}
+}
+EXPORT_SYMBOL(mntput);
+
+struct vfsmount *mntget(struct vfsmount *mnt)
+{
+	if (mnt) {
+		preempt_disable();
+		inc_mnt_count(mnt);
+		preempt_enable();
+	}
+	return mnt;
+}
+EXPORT_SYMBOL(mntget);
+
 void mnt_pin(struct vfsmount *mnt)
 {
 	br_write_lock(vfsmount_lock);
 	mnt->mnt_pinned++;
 	br_write_unlock(vfsmount_lock);
 }
-
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *mnt)
 {
 	br_write_lock(vfsmount_lock);
 	if (mnt->mnt_pinned) {
-		atomic_inc(&mnt->mnt_count);
+		inc_mnt_count(mnt);
 		mnt->mnt_pinned--;
 	}
 	br_write_unlock(vfsmount_lock);
 }
-
 EXPORT_SYMBOL(mnt_unpin);
 
 static inline void mangle(struct seq_file *m, const char *s)
@@ -1008,12 +1107,13 @@ int may_umount_tree(struct vfsmount *mnt
 	int minimum_refs = 0;
 	struct vfsmount *p;
 
-	br_read_lock(vfsmount_lock);
+	/* write lock needed for count_mnt_count */
+	br_write_lock(vfsmount_lock);
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
-		actual_refs += atomic_read(&p->mnt_count);
+		actual_refs += count_mnt_count(p);
 		minimum_refs += 2;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -1040,10 +1140,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 	down_read(&namespace_sem);
-	br_read_lock(vfsmount_lock);
+	br_write_lock(vfsmount_lock);
 	if (propagate_mount_busy(mnt, 2))
 		ret = 0;
-	br_read_unlock(vfsmount_lock);
+	br_write_unlock(vfsmount_lock);
 	up_read(&namespace_sem);
 	return ret;
 }
@@ -1125,8 +1225,16 @@ static int do_umount(struct vfsmount *mn
 		    flags & (MNT_FORCE | MNT_DETACH))
 			return -EINVAL;
 
-		if (atomic_read(&mnt->mnt_count) != 2)
+		/*
+		 * probably don't strictly need the lock here if we examined
+		 * all race cases, but it's a slowpath.
+		 */
+		br_write_lock(vfsmount_lock);
+		if (count_mnt_count(mnt) != 2) {
+			br_write_lock(vfsmount_lock);
 			return -EBUSY;
+		}
+		br_write_unlock(vfsmount_lock);
 
 		if (!xchg(&mnt->mnt_expiry_mark, 1))
 			return -EAGAIN;
@@ -2350,6 +2458,12 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
 	br_write_unlock(vfsmount_lock);
 	chroot_fs_refs(&root, &new);
+
+	/* Drop MNT_PSEUDO from old, add it to new. See init_mount_tree */
+	BUG_ON(!(root.mnt->mnt_flags & MNT_PSEUDO));
+	root.mnt->mnt_flags &= ~MNT_PSEUDO;
+	new.mnt->mnt_flags |= MNT_PSEUDO;
+
 	error = 0;
 	path_put(&root_parent);
 	path_put(&parent_path);
@@ -2376,6 +2490,13 @@ static void __init init_mount_tree(void)
 	mnt = do_kern_mount("rootfs", 0, "rootfs", NULL);
 	if (IS_ERR(mnt))
 		panic("Can't create rootfs");
+	/*
+	 * MNT_PSEUDO tells mnt refcounting that we're pinned, so don't
+	 * bother checking for zero references. Give one of these to root
+	 * because it isn't "attached" to the tree. See mntput().
+	 */
+	mnt->mnt_flags |= MNT_PSEUDO;
+
 	ns = create_mnt_ns(mnt);
 	if (IS_ERR(ns))
 		panic("Can't allocate initial namespace");
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2010-12-12 03:27:08.000000000 +1100
+++ linux-2.6/include/linux/mount.h	2010-12-12 03:51:52.000000000 +1100
@@ -30,6 +30,7 @@ struct mnt_namespace;
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
+#define MNT_PSEUDO	0x400
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
@@ -70,19 +71,15 @@ struct vfsmount {
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
 	int mnt_group_id;		/* peer group identifier */
-	/*
-	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
-	 * to let these frequently modified fields in a separate cache line
-	 * (so that reads of mnt_flags wont ping-pong on SMP machines)
-	 */
-	atomic_t mnt_count;
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
 	int mnt_ghosts;
 #ifdef CONFIG_SMP
 	int __percpu *mnt_writers;
+	int __percpu *mnt_count;
 #else
 	int mnt_writers;
+	int mnt_count;
 #endif
 };
 
@@ -95,13 +92,6 @@ static inline int *get_mnt_writers_ptr(s
 #endif
 }
 
-static inline struct vfsmount *mntget(struct vfsmount *mnt)
-{
-	if (mnt)
-		atomic_inc(&mnt->mnt_count);
-	return mnt;
-}
-
 struct file; /* forward dec */
 
 extern int mnt_want_write(struct vfsmount *mnt);
@@ -109,18 +99,12 @@ extern int mnt_want_write_file(struct fi
 extern int mnt_clone_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
+extern void mntput(struct vfsmount *mnt);
+extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
-static inline void mntput(struct vfsmount *mnt)
-{
-	if (mnt) {
-		mnt->mnt_expiry_mark = 0;
-		mntput_no_expire(mnt);
-	}
-}
-
 extern struct vfsmount *do_kern_mount(const char *fstype, int flags,
 				      const char *name, void *data);
 
Index: linux-2.6/fs/pnode.c
===================================================================
--- linux-2.6.orig/fs/pnode.c	2010-12-12 03:27:08.000000000 +1100
+++ linux-2.6/fs/pnode.c	2010-12-12 03:51:52.000000000 +1100
@@ -288,7 +288,7 @@ int propagate_mnt(struct vfsmount *dest_
  */
 static inline int do_refcount_check(struct vfsmount *mnt, int count)
 {
-	int mycount = atomic_read(&mnt->mnt_count) - mnt->mnt_ghosts;
+	int mycount = count_mnt_count(mnt) - mnt->mnt_ghosts;
 	return (mycount > count);
 }
 
@@ -300,7 +300,7 @@ static inline int do_refcount_check(stru
  * Check if any of these mounts that **do not have submounts**
  * have more references than 'refcnt'. If so return busy.
  *
- * vfsmount lock must be held for read or write
+ * vfsmount lock must be held for write
  */
 int propagate_mount_busy(struct vfsmount *mnt, int refcnt)
 {
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-12-12 03:27:08.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-12-12 03:51:52.000000000 +1100
@@ -63,6 +63,7 @@ extern int copy_mount_string(const void
 
 extern void free_vfsmnt(struct vfsmount *);
 extern struct vfsmount *alloc_vfsmnt(const char *);
+extern unsigned int count_mnt_count(struct vfsmount *mnt);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				struct vfsmount *);
Index: linux-2.6/drivers/mtd/mtdchar.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdchar.c	2010-12-12 03:27:08.000000000 +1100
+++ linux-2.6/drivers/mtd/mtdchar.c	2010-12-12 03:51:52.000000000 +1100
@@ -1201,6 +1201,7 @@ static int __init init_mtdchar(void)
 static void __exit cleanup_mtdchar(void)
 {
 	unregister_mtd_user(&mtdchar_notifier);
+	mtd_inode_mnt->mnt_flags &= ~MNT_PSEUDO;
 	mntput(mtd_inode_mnt);
 	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c	2010-12-12 03:48:57.000000000 +1100
+++ linux-2.6/arch/ia64/kernel/perfmon.c	2010-12-12 03:51:52.000000000 +1100
@@ -1553,8 +1553,10 @@ init_pfm_fs(void)
 		err = PTR_ERR(pfmfs_mnt);
 		if (IS_ERR(pfmfs_mnt))
 			unregister_filesystem(&pfm_fs_type);
-		else
+		else {
 			err = 0;
+			pfmfs_mnt->mnt_flags |= MNT_PSEUDO;
+		}
 	}
 	return err;
 }
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c	2010-12-12 03:51:50.000000000 +1100
+++ linux-2.6/fs/anon_inodes.c	2010-12-12 03:51:52.000000000 +1100
@@ -223,6 +223,7 @@ static int __init anon_inode_init(void)
 		error = PTR_ERR(anon_inode_mnt);
 		goto err_unregister_filesystem;
 	}
+	anon_inode_mnt->mnt_flags |= MNT_PSEUDO;
 	anon_inode_inode = anon_inode_mkinode();
 	if (IS_ERR(anon_inode_inode)) {
 		error = PTR_ERR(anon_inode_inode);
@@ -232,6 +233,7 @@ static int __init anon_inode_init(void)
 	return 0;
 
 err_mntput:
+	anon_inode_mnt->mnt_flags &= ~MNT_PSEUDO;
 	mntput(anon_inode_mnt);
 err_unregister_filesystem:
 	unregister_filesystem(&anon_inode_fs_type);
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-12-12 03:27:08.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-12-12 03:51:52.000000000 +1100
@@ -499,6 +499,7 @@ void __init bdev_cache_init(void)
 	bd_mnt = kern_mount(&bd_type);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
+	bd_mnt->mnt_flags |= MNT_PSEUDO;
 	/*
 	 * This vfsmount structure is only used to obtain the
 	 * blockdev_superblock, so tell kmemleak not to report it.
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-12-12 03:51:50.000000000 +1100
+++ linux-2.6/fs/pipe.c	2010-12-12 03:51:52.000000000 +1100
@@ -1285,6 +1285,7 @@ static int __init init_pipe_fs(void)
 			err = PTR_ERR(pipe_mnt);
 			unregister_filesystem(&pipe_fs_type);
 		}
+		pipe_mnt->mnt_flags |= MNT_PSEUDO;
 	}
 	return err;
 }
@@ -1292,6 +1293,7 @@ static int __init init_pipe_fs(void)
 static void __exit exit_pipe_fs(void)
 {
 	unregister_filesystem(&pipe_fs_type);
+	pipe_mnt->mnt_flags &= ~MNT_PSEUDO;
 	mntput(pipe_mnt);
 }
 
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-12-12 03:51:50.000000000 +1100
+++ linux-2.6/net/socket.c	2010-12-12 03:51:52.000000000 +1100
@@ -2375,6 +2375,8 @@ EXPORT_SYMBOL(sock_unregister);
 
 static int __init sock_init(void)
 {
+	int err;
+
 	/*
 	 *      Initialize sock SLAB cache.
 	 */
@@ -2391,8 +2393,16 @@ static int __init sock_init(void)
 	 */
 
 	init_inodecache();
-	register_filesystem(&sock_fs_type);
+
+	err = register_filesystem(&sock_fs_type);
+	if (err)
+		goto out_fs;
 	sock_mnt = kern_mount(&sock_fs_type);
+	if (IS_ERR(sock_mnt)) {
+		err = PTR_ERR(sock_mnt);
+		goto out_mount;
+	}
+	sock_mnt->mnt_flags |= MNT_PSEUDO;
 
 	/* The real protocol initialization is performed in later initcalls.
 	 */
@@ -2405,7 +2415,13 @@ static int __init sock_init(void)
 	skb_timestamping_init();
 #endif
 
-	return 0;
+out:
+	return err;
+
+out_mount:
+	unregister_filesystem(&sock_fs_type);
+out_fs:
+	goto out;
 }
 
 core_initcall(sock_init);	/* early initcall */
