Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0FXDQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab0FXDPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:45 -0400
Message-Id: <20100624030726.859546963@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:20 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 08/52] fs: scale mntget/mntput
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-mntget-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Nick Piggin <npiggin@suse.de>

[Note: this is not for merging. Un-attached operation (lazy umount) may not be
 uncommon and will be slowed down and actually have worse scalablilty after
 this patch. I need to think about how to do fast refcounting with unattached
 mounts.]

---
 drivers/mtd/mtdchar.c |    1 
 fs/internal.h         |    1 
 fs/libfs.c            |    1 
 fs/namespace.c        |  155 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/pnode.c            |    4 -
 include/linux/mount.h |   26 +-------
 6 files changed, 144 insertions(+), 44 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
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
@@ -166,7 +232,7 @@ struct vfsmount *alloc_vfsmnt(const char
 #ifdef CONFIG_SMP
 		mnt->mnt_writers = alloc_percpu(int);
 		if (!mnt->mnt_writers)
-			goto out_free_devname;
+			goto out_free_mntcount;
 #else
 		mnt->mnt_writers = 0;
 #endif
@@ -174,6 +240,8 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 
 #ifdef CONFIG_SMP
+out_free_mntcount:
+	free_percpu(mnt->mnt_count);
 out_free_devname:
 	kfree(mnt->mnt_devname);
 #endif
@@ -591,7 +659,7 @@ static struct vfsmount *clone_mnt(struct
 				goto out_free;
 		}
 
-		mnt->mnt_flags = old->mnt_flags;
+		WARN_ON(mnt->mnt_flags & MNT_WRITE_HOLD);
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
@@ -638,6 +706,11 @@ static inline void __mntput(struct vfsmo
 	/*
 	 * atomic_dec_and_lock() used to deal with ->mnt_count decrements
 	 * provides barriers, so count_mnt_writers() below is safe.  AV
+	 * XXX: We no longer have an atomic_dec_and_lock, so load of
+	 * mnt_writers may be moved up into the vfsmount lock critical section?
+	 * Do we need an smp_mb()? I don't see how it is possible because an
+	 * elevated write count should also have elevated ref count so we'd
+	 * never get here.
 	 */
 	WARN_ON(count_mnt_writers(mnt));
 	dput(mnt->mnt_root);
@@ -648,45 +721,76 @@ static inline void __mntput(struct vfsmo
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
@@ -982,12 +1086,13 @@ int may_umount_tree(struct vfsmount *mnt
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
@@ -1014,10 +1119,10 @@ int may_umount(struct vfsmount *mnt)
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
@@ -1099,8 +1204,16 @@ static int do_umount(struct vfsmount *mn
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
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h
+++ linux-2.6/include/linux/mount.h
@@ -31,6 +31,7 @@ struct mnt_namespace;
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
+#define MNT_PSEUDO	0x400
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
@@ -67,19 +68,15 @@ struct vfsmount {
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
 
@@ -92,13 +89,6 @@ static inline int *get_mnt_writers_ptr(s
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
@@ -106,18 +96,12 @@ extern int mnt_want_write_file(struct fi
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
--- linux-2.6.orig/fs/pnode.c
+++ linux-2.6/fs/pnode.c
@@ -288,7 +288,7 @@ out:
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
--- linux-2.6.orig/fs/internal.h
+++ linux-2.6/fs/internal.h
@@ -63,6 +63,7 @@ extern int copy_mount_string(const void
 
 extern void free_vfsmnt(struct vfsmount *);
 extern struct vfsmount *alloc_vfsmnt(const char *);
+extern unsigned int count_mnt_count(struct vfsmount *mnt);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				struct vfsmount *);
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -241,6 +241,7 @@ int get_sb_pseudo(struct file_system_typ
 	d_instantiate(dentry, root);
 	s->s_root = dentry;
 	s->s_flags |= MS_ACTIVE;
+	mnt->mnt_flags |= MNT_PSEUDO;
 	simple_set_mnt(mnt, s);
 	return 0;
 
Index: linux-2.6/drivers/mtd/mtdchar.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdchar.c
+++ linux-2.6/drivers/mtd/mtdchar.c
@@ -1048,6 +1048,7 @@ err_unregister_chdev:
 static void __exit cleanup_mtdchar(void)
 {
 	unregister_mtd_user(&mtdchar_notifier);
+	mtd_inode_mnt &= ~MNT_PSEUDO;
 	mntput(mtd_inode_mnt);
 	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");


