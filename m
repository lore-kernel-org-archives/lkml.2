Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab0LNMlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:41:10 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:37304 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758337Ab0LNMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:41:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgEADP0Bk15LdLlgWdsb2JhbACkCRcBFiIpwV2FSgQ
Date: Tue, 14 Dec 2010 23:40:59 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and
  dcache scaling tree update and status)
Message-ID: <20101214124059.GA14493@amd>
References: <20101213023733.GB6522@amd>
 <20101213024217.GC6522@amd>
 <1292225113.18698.22.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292225113.18698.22.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this ones includes your suggestions, and implements the approach I
outlined earlier. I verified it works and is scalable on detached
mounts, so I'll add it to the git branch when it survives a bit more
testing. It's the last piece of the puzzle...

fs: scale mntget/mntput

The problem that this patch aims to fix is vfsmount refcounting scalability.
We need to take a reference on the vfsmount for every successful path lookup,
which often go to the same mount point.

The fundamental difficulty is that a "simple" reference count can never be made
scalable, because any time a reference is dropped, we must check whether that
was the last reference. To do that requires communication with all other CPUs
that may have taken a reference count.

We can make refcounts more scalable in a couple of ways, involving keeping
distributed counters, and checking for the global-zero condition less
frequently.

- check the global sum once every interval (this will delay zero detection
  for some interval, so it's probably a showstopper for vfsmounts).

- keep a local count and only taking the global sum when local reaches 0 (this
  is difficult for vfsmounts, because we can't hold preempt off for the life of
  a reference, so a counter would need to be per-thread or tied strongly to a
  particular CPU which requires more locking).

- keep a local difference of increments and decrements, which allows us to sum
  the total difference and hence find the refcount when summing all CPUs. Then,
  keep a single integer "long" refcount for slow and long lasting references,
  and only take the global sum of local counters when the long refcount is 0.

This last scheme is what I implemented here. Attached mounts and process root
and working directory references are "long" references, and everything else is
a short reference.

This allows scalable vfsmount references during path walking over mounted
subtrees and unattached (lazy umounted) mounts with processes still running
in them.

This results in one fewer atomic op in the fastpath: mntget is now just a
per-CPU inc, rather than an atomic inc; and mntput just requires a spinlock
and non-atomic decrement in the common case. However code is otherwise bigger
and heavier, so single threaded performance is basically a wash.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 arch/ia64/kernel/perfmon.c |    2 
 drivers/mtd/mtdchar.c      |    2 
 fs/anon_inodes.c           |    2 
 fs/fs_struct.c             |   26 +++-
 fs/internal.h              |    1 
 fs/namei.c                 |   24 ++++
 fs/namespace.c             |  240 +++++++++++++++++++++++++++++++++++++--------
 fs/pipe.c                  |    2 
 fs/pnode.c                 |    4 
 fs/super.c                 |    2 
 include/linux/mount.h      |   53 +++------
 include/linux/path.h       |    2 
 net/socket.c               |   19 +++
 13 files changed, 282 insertions(+), 97 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/fs/namespace.c	2010-12-14 23:33:00.000000000 +1100
@@ -138,6 +138,64 @@ void mnt_release_group_id(struct vfsmoun
 	mnt->mnt_group_id = 0;
 }
 
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void add_mnt_count(struct vfsmount *mnt, int n)
+{
+#ifdef CONFIG_SMP
+	this_cpu_add(mnt->mnt_pcp->mnt_count, n);
+#else
+	preempt_disable();
+	mnt->mnt_count += n;
+	preempt_enable();
+#endif
+}
+
+static inline void set_mnt_count(struct vfsmount *mnt, int n)
+{
+#ifdef CONFIG_SMP
+	this_cpu_add(mnt->mnt_pcp->mnt_count, n);
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
+	unsigned int count = atomic_read(&mnt->mnt_longrefs);
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		count += per_cpu_ptr(mnt->mnt_pcp, cpu)->mnt_count;
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
@@ -154,7 +212,17 @@ struct vfsmount *alloc_vfsmnt(const char
 				goto out_free_id;
 		}
 
-		atomic_set(&mnt->mnt_count, 1);
+#ifdef CONFIG_SMP
+		mnt->mnt_pcp = alloc_percpu(struct mnt_pcp);
+		if (!mnt->mnt_pcp)
+			goto out_free_devname;
+
+		atomic_set(&mnt->mnt_longrefs, 1);
+#else
+		mnt->mnt_count = 1;
+		mnt->mnt_writers = 0;
+#endif
+
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
 		INIT_LIST_HEAD(&mnt->mnt_mounts);
@@ -166,13 +234,6 @@ struct vfsmount *alloc_vfsmnt(const char
 #ifdef CONFIG_FSNOTIFY
 		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
 #endif
-#ifdef CONFIG_SMP
-		mnt->mnt_writers = alloc_percpu(int);
-		if (!mnt->mnt_writers)
-			goto out_free_devname;
-#else
-		mnt->mnt_writers = 0;
-#endif
 	}
 	return mnt;
 
@@ -219,7 +280,7 @@ EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 static inline void inc_mnt_writers(struct vfsmount *mnt)
 {
 #ifdef CONFIG_SMP
-	(*per_cpu_ptr(mnt->mnt_writers, smp_processor_id()))++;
+	this_cpu_inc(mnt->mnt_pcp->mnt_writers);
 #else
 	mnt->mnt_writers++;
 #endif
@@ -228,7 +289,7 @@ static inline void inc_mnt_writers(struc
 static inline void dec_mnt_writers(struct vfsmount *mnt)
 {
 #ifdef CONFIG_SMP
-	(*per_cpu_ptr(mnt->mnt_writers, smp_processor_id()))--;
+	this_cpu_dec(mnt->mnt_pcp->mnt_writers);
 #else
 	mnt->mnt_writers--;
 #endif
@@ -241,7 +302,7 @@ static unsigned int count_mnt_writers(st
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		count += *per_cpu_ptr(mnt->mnt_writers, cpu);
+		count += per_cpu_ptr(mnt->mnt_pcp, cpu)->mnt_writers;
 	}
 
 	return count;
@@ -418,7 +479,7 @@ void free_vfsmnt(struct vfsmount *mnt)
 	kfree(mnt->mnt_devname);
 	mnt_free_id(mnt);
 #ifdef CONFIG_SMP
-	free_percpu(mnt->mnt_writers);
+	free_percpu(mnt->mnt_pcp);
 #endif
 	kmem_cache_free(mnt_cache, mnt);
 }
@@ -652,9 +713,10 @@ static struct vfsmount *clone_mnt(struct
 	return NULL;
 }
 
-static inline void __mntput(struct vfsmount *mnt)
+static inline void mntfree(struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
+
 	/*
 	 * This probably indicates that somebody messed
 	 * up a mnt_want/drop_write() pair.  If this
@@ -662,8 +724,8 @@ static inline void __mntput(struct vfsmo
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
@@ -672,28 +734,113 @@ static inline void __mntput(struct vfsmo
 	deactivate_super(sb);
 }
 
-void mntput_no_expire(struct vfsmount *mnt)
+#ifdef CONFIG_SMP
+static inline void __mntput(struct vfsmount *mnt, int longrefs)
 {
-repeat:
-	if (atomic_add_unless(&mnt->mnt_count, -1, 1))
-		return;
+	if (!longrefs) {
+put_again:
+		br_read_lock(vfsmount_lock);
+		if (likely(atomic_read(&mnt->mnt_longrefs))) {
+			dec_mnt_count(mnt);
+			br_read_unlock(vfsmount_lock);
+			return;
+		}
+		br_read_unlock(vfsmount_lock);
+	} else {
+		BUG_ON(!atomic_read(&mnt->mnt_longrefs));
+		if (atomic_add_unless(&mnt->mnt_longrefs, -1, 1))
+			return;
+	}
+
 	br_write_lock(vfsmount_lock);
-	if (!atomic_dec_and_test(&mnt->mnt_count)) {
+	if (!longrefs)
+		dec_mnt_count(mnt);
+	else
+		atomic_dec(&mnt->mnt_longrefs);
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
+		acct_auto_close_mnt(mnt);
+		goto put_again;
+	}
+	br_write_unlock(vfsmount_lock);
+	mntfree(mnt);
+}
+#else
+static inline void __mntput(struct vfsmount *mnt, int longrefs)
+{
+put_again:
+	dec_mnt_count(mnt);
+	if (likely(count_mnt_count(mnt)))
 		return;
+	br_write_lock(vfsmount_lock);
+	if (unlikely(mnt->mnt_pinned)) {
+		add_mnt_count(mnt, mnt->mnt_pinned + 1);
+		mnt->mnt_pinned = 0;
+		br_write_unlock(vfsmount_lock);
+		acct_auto_close_mnt(mnt);
+		goto put_again;
 	}
-	atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
-	mnt->mnt_pinned = 0;
 	br_write_unlock(vfsmount_lock);
-	acct_auto_close_mnt(mnt);
-	goto repeat;
+	mntfree(mnt);
+}
+#endif
+
+static void mntput_no_expire(struct vfsmount *mnt)
+{
+	__mntput(mnt, 0);
 }
-EXPORT_SYMBOL(mntput_no_expire);
+
+void mntput(struct vfsmount *mnt)
+{
+	if (mnt) {
+		/* avoid cacheline pingpong, hope gcc doesn't get "smart" */
+		if (unlikely(mnt->mnt_expiry_mark))
+			mnt->mnt_expiry_mark = 0;
+		__mntput(mnt, 0);
+	}
+}
+EXPORT_SYMBOL(mntput);
+
+struct vfsmount *mntget(struct vfsmount *mnt)
+{
+	if (mnt)
+		inc_mnt_count(mnt);
+	return mnt;
+}
+EXPORT_SYMBOL(mntget);
+
+void mntput_long(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	if (mnt) {
+		/* avoid cacheline pingpong, hope gcc doesn't get "smart" */
+		if (unlikely(mnt->mnt_expiry_mark))
+			mnt->mnt_expiry_mark = 0;
+		__mntput(mnt, 1);
+	}
+#else
+	mntput(mnt);
+#endif
+}
+EXPORT_SYMBOL(mntput_long);
+
+struct vfsmount *mntget_long(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	if (mnt)
+		atomic_inc(&mnt->mnt_longrefs);
+	return mnt;
+#else
+	return mntget(mnt);
+#endif
+}
+EXPORT_SYMBOL(mntget_long);
 
 void mnt_pin(struct vfsmount *mnt)
 {
@@ -701,19 +848,17 @@ void mnt_pin(struct vfsmount *mnt)
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
@@ -1008,12 +1153,13 @@ int may_umount_tree(struct vfsmount *mnt
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
@@ -1040,10 +1186,10 @@ int may_umount(struct vfsmount *mnt)
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
@@ -1070,7 +1216,7 @@ void release_mounts(struct list_head *he
 			dput(dentry);
 			mntput(m);
 		}
-		mntput(mnt);
+		mntput_long(mnt);
 	}
 }
 
@@ -1125,8 +1271,16 @@ static int do_umount(struct vfsmount *mn
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
@@ -1815,7 +1969,7 @@ int do_add_mount(struct vfsmount *newmnt
 
 unlock:
 	up_write(&namespace_sem);
-	mntput(newmnt);
+	mntput_long(newmnt);
 	return err;
 }
 
@@ -2148,11 +2302,11 @@ static struct mnt_namespace *dup_mnt_ns(
 		if (fs) {
 			if (p == fs->root.mnt) {
 				rootmnt = p;
-				fs->root.mnt = mntget(q);
+				fs->root.mnt = mntget_long(q);
 			}
 			if (p == fs->pwd.mnt) {
 				pwdmnt = p;
-				fs->pwd.mnt = mntget(q);
+				fs->pwd.mnt = mntget_long(q);
 			}
 		}
 		p = next_mnt(p, mnt_ns->root);
@@ -2161,9 +2315,9 @@ static struct mnt_namespace *dup_mnt_ns(
 	up_write(&namespace_sem);
 
 	if (rootmnt)
-		mntput(rootmnt);
+		mntput_long(rootmnt);
 	if (pwdmnt)
-		mntput(pwdmnt);
+		mntput_long(pwdmnt);
 
 	return new_ns;
 }
@@ -2350,6 +2504,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
 	br_write_unlock(vfsmount_lock);
 	chroot_fs_refs(&root, &new);
+
 	error = 0;
 	path_put(&root_parent);
 	path_put(&parent_path);
@@ -2376,6 +2531,7 @@ static void __init init_mount_tree(void)
 	mnt = do_kern_mount("rootfs", 0, "rootfs", NULL);
 	if (IS_ERR(mnt))
 		panic("Can't create rootfs");
+
 	ns = create_mnt_ns(mnt);
 	if (IS_ERR(ns))
 		panic("Can't allocate initial namespace");
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/include/linux/mount.h	2010-12-14 21:07:29.000000000 +1100
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
+#include <linux/seqlock.h>
 #include <asm/atomic.h>
 
 struct super_block;
@@ -46,12 +47,24 @@ struct mnt_namespace;
 
 #define MNT_INTERNAL	0x4000
 
+struct mnt_pcp {
+	int mnt_count;
+	int mnt_writers;
+};
+
 struct vfsmount {
 	struct list_head mnt_hash;
 	struct vfsmount *mnt_parent;	/* fs we are mounted on */
 	struct dentry *mnt_mountpoint;	/* dentry of mountpoint */
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */
+#ifdef CONFIG_SMP
+	struct mnt_pcp __percpu *mnt_pcp;
+	atomic_t mnt_longrefs;
+#else
+	int mnt_count;
+	int mnt_writers;
+#endif
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
 	int mnt_flags;
@@ -70,57 +83,25 @@ struct vfsmount {
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
-#ifdef CONFIG_SMP
-	int __percpu *mnt_writers;
-#else
-	int mnt_writers;
-#endif
 };
 
-static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
-{
-#ifdef CONFIG_SMP
-	return mnt->mnt_writers;
-#else
-	return &mnt->mnt_writers;
-#endif
-}
-
-static inline struct vfsmount *mntget(struct vfsmount *mnt)
-{
-	if (mnt)
-		atomic_inc(&mnt->mnt_count);
-	return mnt;
-}
-
 struct file; /* forward dec */
 
 extern int mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
-extern void mntput_no_expire(struct vfsmount *mnt);
+extern void mntput(struct vfsmount *mnt);
+extern struct vfsmount *mntget(struct vfsmount *mnt);
+extern void mntput_long(struct vfsmount *mnt);
+extern struct vfsmount *mntget_long(struct vfsmount *mnt);
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
--- linux-2.6.orig/fs/pnode.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/fs/pnode.c	2010-12-14 21:07:29.000000000 +1100
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
--- linux-2.6.orig/fs/internal.h	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-12-14 21:07:29.000000000 +1100
@@ -63,6 +63,7 @@ extern int copy_mount_string(const void
 
 extern void free_vfsmnt(struct vfsmount *);
 extern struct vfsmount *alloc_vfsmnt(const char *);
+extern unsigned int count_mnt_count(struct vfsmount *mnt);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				struct vfsmount *);
Index: linux-2.6/drivers/mtd/mtdchar.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdchar.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/drivers/mtd/mtdchar.c	2010-12-14 21:07:29.000000000 +1100
@@ -1201,7 +1201,7 @@ static int __init init_mtdchar(void)
 static void __exit cleanup_mtdchar(void)
 {
 	unregister_mtd_user(&mtdchar_notifier);
-	mntput(mtd_inode_mnt);
+	mntput_long(mtd_inode_mnt);
 	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
 }
Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/arch/ia64/kernel/perfmon.c	2010-12-14 21:07:29.000000000 +1100
@@ -1542,7 +1542,7 @@ pfm_exit_smpl_buffer(pfm_buffer_fmt_t *f
  * any operations on the root directory. However, we need a non-trivial
  * d_name - pfm: will go nicely and kill the special-casing in procfs.
  */
-static struct vfsmount *pfmfs_mnt;
+static struct vfsmount *pfmfs_mnt __read_mostly;
 
 static int __init
 init_pfm_fs(void)
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/fs/anon_inodes.c	2010-12-14 21:07:29.000000000 +1100
@@ -232,7 +232,7 @@ static int __init anon_inode_init(void)
 	return 0;
 
 err_mntput:
-	mntput(anon_inode_mnt);
+	mntput_long(anon_inode_mnt);
 err_unregister_filesystem:
 	unregister_filesystem(&anon_inode_fs_type);
 err_exit:
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/fs/pipe.c	2010-12-14 21:07:29.000000000 +1100
@@ -1292,7 +1292,7 @@ static int __init init_pipe_fs(void)
 static void __exit exit_pipe_fs(void)
 {
 	unregister_filesystem(&pipe_fs_type);
-	mntput(pipe_mnt);
+	mntput_long(pipe_mnt);
 }
 
 fs_initcall(init_pipe_fs);
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/net/socket.c	2010-12-14 21:07:29.000000000 +1100
@@ -2375,6 +2375,8 @@ EXPORT_SYMBOL(sock_unregister);
 
 static int __init sock_init(void)
 {
+	int err;
+
 	/*
 	 *      Initialize sock SLAB cache.
 	 */
@@ -2391,8 +2393,15 @@ static int __init sock_init(void)
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
 
 	/* The real protocol initialization is performed in later initcalls.
 	 */
@@ -2405,7 +2414,13 @@ static int __init sock_init(void)
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
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-12-14 21:07:19.000000000 +1100
+++ linux-2.6/fs/super.c	2010-12-14 21:07:29.000000000 +1100
@@ -1140,7 +1140,7 @@ static struct vfsmount *fs_set_subtype(s
 	return mnt;
 
  err:
-	mntput(mnt);
+	mntput_long(mnt);
 	return ERR_PTR(err);
 }
 
Index: linux-2.6/fs/fs_struct.c
===================================================================
--- linux-2.6.orig/fs/fs_struct.c	2010-12-14 22:01:15.000000000 +1100
+++ linux-2.6/fs/fs_struct.c	2010-12-14 22:56:27.000000000 +1100
@@ -17,11 +17,11 @@ void set_fs_root(struct fs_struct *fs, s
 	write_seqcount_begin(&fs->seq);
 	old_root = fs->root;
 	fs->root = *path;
-	path_get(path);
+	path_get_long(path);
 	write_seqcount_end(&fs->seq);
 	spin_unlock(&fs->lock);
 	if (old_root.dentry)
-		path_put(&old_root);
+		path_put_long(&old_root);
 }
 
 /*
@@ -36,12 +36,12 @@ void set_fs_pwd(struct fs_struct *fs, st
 	write_seqcount_begin(&fs->seq);
 	old_pwd = fs->pwd;
 	fs->pwd = *path;
-	path_get(path);
+	path_get_long(path);
 	write_seqcount_end(&fs->seq);
 	spin_unlock(&fs->lock);
 
 	if (old_pwd.dentry)
-		path_put(&old_pwd);
+		path_put_long(&old_pwd);
 }
 
 void chroot_fs_refs(struct path *old_root, struct path *new_root)
@@ -59,13 +59,13 @@ void chroot_fs_refs(struct path *old_roo
 			write_seqcount_begin(&fs->seq);
 			if (fs->root.dentry == old_root->dentry
 			    && fs->root.mnt == old_root->mnt) {
-				path_get(new_root);
+				path_get_long(new_root);
 				fs->root = *new_root;
 				count++;
 			}
 			if (fs->pwd.dentry == old_root->dentry
 			    && fs->pwd.mnt == old_root->mnt) {
-				path_get(new_root);
+				path_get_long(new_root);
 				fs->pwd = *new_root;
 				count++;
 			}
@@ -76,13 +76,13 @@ void chroot_fs_refs(struct path *old_roo
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 	while (count--)
-		path_put(old_root);
+		path_put_long(old_root);
 }
 
 void free_fs_struct(struct fs_struct *fs)
 {
-	path_put(&fs->root);
-	path_put(&fs->pwd);
+	path_put_long(&fs->root);
+	path_put_long(&fs->pwd);
 	kmem_cache_free(fs_cachep, fs);
 }
 
@@ -115,7 +115,13 @@ struct fs_struct *copy_fs_struct(struct
 		spin_lock_init(&fs->lock);
 		seqcount_init(&fs->seq);
 		fs->umask = old->umask;
-		get_fs_root_and_pwd(old, &fs->root, &fs->pwd);
+
+		spin_lock(&old->lock);
+		fs->root = old->root;
+		path_get_long(&fs->root);
+		fs->pwd = old->pwd;
+		path_get_long(&fs->pwd);
+		spin_unlock(&old->lock);
 	}
 	return fs;
 }
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-12-14 22:06:54.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-12-14 22:07:51.000000000 +1100
@@ -448,6 +448,18 @@ void path_get(struct path *path)
 EXPORT_SYMBOL(path_get);
 
 /**
+ * path_get_long - get a long reference to a path
+ * @path: path to get the reference to
+ *
+ * Given a path increment the reference count to the dentry and the vfsmount.
+ */
+void path_get_long(struct path *path)
+{
+	mntget_long(path->mnt);
+	dget(path->dentry);
+}
+
+/**
  * path_put - put a reference to a path
  * @path: path to put the reference to
  *
@@ -461,6 +473,18 @@ void path_put(struct path *path)
 EXPORT_SYMBOL(path_put);
 
 /**
+ * path_put_long - put a long reference to a path
+ * @path: path to put the reference to
+ *
+ * Given a path decrement the reference count to the dentry and the vfsmount.
+ */
+void path_put_long(struct path *path)
+{
+	dput(path->dentry);
+	mntput_long(path->mnt);
+}
+
+/**
  * nameidata_drop_rcu - drop this nameidata out of rcu-walk
  * @nd: nameidata pathwalk data to drop
  * @Returns: 0 on success, -ECHLID on failure
Index: linux-2.6/include/linux/path.h
===================================================================
--- linux-2.6.orig/include/linux/path.h	2010-12-14 22:06:38.000000000 +1100
+++ linux-2.6/include/linux/path.h	2010-12-14 22:08:13.000000000 +1100
@@ -10,7 +10,9 @@ struct path {
 };
 
 extern void path_get(struct path *);
+extern void path_get_long(struct path *);
 extern void path_put(struct path *);
+extern void path_put_long(struct path *);
 
 static inline int path_equal(const struct path *path1, const struct path *path2)
 {
