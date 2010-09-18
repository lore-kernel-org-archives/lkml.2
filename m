Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0IRNKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 09:10:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab0IRNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 09:09:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <willy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs/locks.c: prepare for BKL removal
Date: Sat, 18 Sep 2010 15:09:31 +0200
Message-Id: <1284815371-5843-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:zFgGGqZ98Le3iX283kyiL3bcvkySC70DjJePvO3Qjna
 0nkHLMOi6MDcgCOQb8ayZgZH9iuVBNqB0C+DRkZBG689oeTJvc
 dO+Y6jnBd/Bk7lc07N8Q3+Va8A8ZmdcV4fmnl4oWhUe867559p
 f4m3Yz4jzKS5m5WouyZxG5oZ0h1PLcKw8MyvXjrHLYgsQitvIJ
 wMAaxPFaSULlvJcFuEL4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prepares the removal of the big kernel lock from the
file locking code. We still use the BKL as long as fs/lockd
uses it and ceph might sleep, but we can flip the definition
to a private spinlock as soon as that's done.
All users outside of fs/lockd get converted to use
lock_flocks() instead of lock_kernel() where appropriate.

Based on an earlier patch to use a spinlock from Matthew
Wilcox, who has attempted this a few times before. An even
earlier attempt to use a semaphore instead of the BKL
apparently was made by Andrew Morton about ten years ago,
but reverted for performance reasons.

Someone should do some serious performance testing when
this becomes a spinlock, since this has caused problems
before. Using a spinlock should be at least as good
as the BKL in theory, but who knows...

If nobody has any objections to this preparation patch,
I'd like to add it to my bkl/vfs tree and into -next.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/flock.c       |    5 +-
 fs/ceph/mds_client.c |    6 +-
 fs/cifs/cifsfs.c     |    4 +-
 fs/gfs2/file.c       |    2 +
 fs/locks.c           |  112 ++++++++++++++++++++++++++++++-------------------
 fs/nfs/delegation.c  |   10 ++--
 fs/nfs/nfs4state.c   |   10 ++--
 fs/nfsd/nfs4state.c  |    6 +-
 include/linux/fs.h   |   10 ++++
 9 files changed, 100 insertions(+), 65 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index 0931bc1..757d664 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -9,7 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/smp_lock.h>
 #include "internal.h"
 
 #define AFS_LOCK_GRANTED	0
@@ -274,7 +273,7 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 
 	type = (fl->fl_type == F_RDLCK) ? AFS_LOCK_READ : AFS_LOCK_WRITE;
 
-	lock_kernel();
+	lock_flocks();
 
 	/* make sure we've got a callback on this file and that our view of the
 	 * data version is up to date */
@@ -421,7 +420,7 @@ given_lock:
 	afs_vnode_fetch_status(vnode, NULL, key);
 
 error:
-	unlock_kernel();
+	unlock_flocks();
 	_leave(" = %d", ret);
 	return ret;
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f091b13..bda5211 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3,7 +3,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/fs.h>
 
 #include "mds_client.h"
 #include "mon_client.h"
@@ -2362,7 +2362,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	if (recon_state->flock) {
 		int num_fcntl_locks, num_flock_locks;
 
-		lock_kernel();
+		lock_flocks();
 		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
 		rec.v2.flock_len = (2*sizeof(u32) +
 				    (num_fcntl_locks+num_flock_locks) *
@@ -2373,7 +2373,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			err = ceph_encode_locks(inode, pagelist,
 						num_fcntl_locks,
 						num_flock_locks);
-		unlock_kernel();
+		unlock_flocks();
 	}
 
 out_free:
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b7431af..b987026 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -565,8 +565,8 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 
 static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 {
-	/* note that this is called by vfs setlease with the BKL held
-	   although I doubt that BKL is needed here in cifs */
+	/* note that this is called by vfs setlease with lock_flocks held
+	   to protect *lease from going away */
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	if (!(S_ISREG(inode->i_mode)))
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 4edd662..8fcfefb 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -620,6 +620,8 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
  * cluster; until we do, disable leases (by just returning -EINVAL),
  * unless the administrator has requested purely local locking.
  *
+ * Locking: called under lock_flocks
+ *
  * Returns: errno
  */
 
diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..8b2b6ad 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -143,6 +143,22 @@ int lease_break_time = 45;
 static LIST_HEAD(file_lock_list);
 static LIST_HEAD(blocked_list);
 
+/*
+ * Protects the two list heads above, plus the inode->i_flock list
+ * FIXME: should use a spinlock, once lockd and ceph are ready.
+ */
+void lock_flocks(void)
+{
+	lock_kernel();
+}
+EXPORT_SYMBOL_GPL(lock_flocks);
+
+void unlock_flocks(void)
+{
+	unlock_kernel();
+}
+EXPORT_SYMBOL_GPL(unlock_flocks);
+
 static struct kmem_cache *filelock_cache __read_mostly;
 
 /* Allocate an empty lock structure. */
@@ -511,9 +527,9 @@ static void __locks_delete_block(struct file_lock *waiter)
  */
 static void locks_delete_block(struct file_lock *waiter)
 {
-	lock_kernel();
+	lock_flocks();
 	__locks_delete_block(waiter);
-	unlock_kernel();
+	unlock_flocks();
 }
 
 /* Insert waiter into blocker's block list.
@@ -644,7 +660,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
 
-	lock_kernel();
+	lock_flocks();
 	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
 		if (!IS_POSIX(cfl))
 			continue;
@@ -657,7 +673,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 			fl->fl_pid = pid_vnr(cfl->fl_nspid);
 	} else
 		fl->fl_type = F_UNLCK;
-	unlock_kernel();
+	unlock_flocks();
 	return;
 }
 EXPORT_SYMBOL(posix_test_lock);
@@ -730,18 +746,16 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	int error = 0;
 	int found = 0;
 
-	lock_kernel();
-	if (request->fl_flags & FL_ACCESS)
-		goto find_conflict;
-
-	if (request->fl_type != F_UNLCK) {
-		error = -ENOMEM;
+	if (!(request->fl_flags & FL_ACCESS) && (request->fl_type != F_UNLCK)) {
 		new_fl = locks_alloc_lock();
-		if (new_fl == NULL)
-			goto out;
-		error = 0;
+		if (!new_fl)
+			return -ENOMEM;
 	}
 
+	lock_flocks();
+	if (request->fl_flags & FL_ACCESS)
+		goto find_conflict;
+
 	for_each_lock(inode, before) {
 		struct file_lock *fl = *before;
 		if (IS_POSIX(fl))
@@ -767,8 +781,11 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	 * If a higher-priority process was blocked on the old file lock,
 	 * give it the opportunity to lock the file.
 	 */
-	if (found)
+	if (found) {
+		unlock_flocks();
 		cond_resched();
+		lock_flocks();
+	}
 
 find_conflict:
 	for_each_lock(inode, before) {
@@ -794,7 +811,7 @@ find_conflict:
 	error = 0;
 
 out:
-	unlock_kernel();
+	unlock_flocks();
 	if (new_fl)
 		locks_free_lock(new_fl);
 	return error;
@@ -823,7 +840,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		new_fl2 = locks_alloc_lock();
 	}
 
-	lock_kernel();
+	lock_flocks();
 	if (request->fl_type != F_UNLCK) {
 		for_each_lock(inode, before) {
 			fl = *before;
@@ -991,7 +1008,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		locks_wake_up_blocks(left);
 	}
  out:
-	unlock_kernel();
+	unlock_flocks();
 	/*
 	 * Free any unused locks.
 	 */
@@ -1066,14 +1083,14 @@ int locks_mandatory_locked(struct inode *inode)
 	/*
 	 * Search the lock list for this inode for any POSIX locks.
 	 */
-	lock_kernel();
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!IS_POSIX(fl))
 			continue;
 		if (fl->fl_owner != owner)
 			break;
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return fl ? -EAGAIN : 0;
 }
 
@@ -1186,7 +1203,7 @@ int __break_lease(struct inode *inode, unsigned int mode)
 
 	new_fl = lease_alloc(NULL, want_write ? F_WRLCK : F_RDLCK);
 
-	lock_kernel();
+	lock_flocks();
 
 	time_out_leases(inode);
 
@@ -1247,8 +1264,10 @@ restart:
 			break_time++;
 	}
 	locks_insert_block(flock, new_fl);
+	unlock_flocks();
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,
 						!new_fl->fl_next, break_time);
+	lock_flocks();
 	__locks_delete_block(new_fl);
 	if (error >= 0) {
 		if (error == 0)
@@ -1263,7 +1282,7 @@ restart:
 	}
 
 out:
-	unlock_kernel();
+	unlock_flocks();
 	if (!IS_ERR(new_fl))
 		locks_free_lock(new_fl);
 	return error;
@@ -1319,7 +1338,7 @@ int fcntl_getlease(struct file *filp)
 	struct file_lock *fl;
 	int type = F_UNLCK;
 
-	lock_kernel();
+	lock_flocks();
 	time_out_leases(filp->f_path.dentry->d_inode);
 	for (fl = filp->f_path.dentry->d_inode->i_flock; fl && IS_LEASE(fl);
 			fl = fl->fl_next) {
@@ -1328,7 +1347,7 @@ int fcntl_getlease(struct file *filp)
 			break;
 		}
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return type;
 }
 
@@ -1341,7 +1360,7 @@ int fcntl_getlease(struct file *filp)
  *	The (input) flp->fl_lmops->fl_break function is required
  *	by break_lease().
  *
- *	Called with kernel lock held.
+ *	Called with file_lock_lock held.
  */
 int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 {
@@ -1436,7 +1455,15 @@ out:
 }
 EXPORT_SYMBOL(generic_setlease);
 
- /**
+static int __vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
+{
+	if (filp->f_op && filp->f_op->setlease)
+		return filp->f_op->setlease(filp, arg, lease);
+	else
+		return generic_setlease(filp, arg, lease);
+}
+
+/**
  *	vfs_setlease        -       sets a lease on an open file
  *	@filp: file pointer
  *	@arg: type of lease to obtain
@@ -1467,12 +1494,9 @@ int vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
 {
 	int error;
 
-	lock_kernel();
-	if (filp->f_op && filp->f_op->setlease)
-		error = filp->f_op->setlease(filp, arg, lease);
-	else
-		error = generic_setlease(filp, arg, lease);
-	unlock_kernel();
+	lock_flocks();
+	error = __vfs_setlease(filp, arg, lease);
+	unlock_flocks();
 
 	return error;
 }
@@ -1499,9 +1523,9 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 	if (error)
 		return error;
 
-	lock_kernel();
+	lock_flocks();
 
-	error = vfs_setlease(filp, arg, &flp);
+	error = __vfs_setlease(filp, arg, &flp);
 	if (error || arg == F_UNLCK)
 		goto out_unlock;
 
@@ -1516,7 +1540,7 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
 out_unlock:
-	unlock_kernel();
+	unlock_flocks();
 	return error;
 }
 
@@ -2020,7 +2044,7 @@ void locks_remove_flock(struct file *filp)
 			fl.fl_ops->fl_release_private(&fl);
 	}
 
-	lock_kernel();
+	lock_flocks();
 	before = &inode->i_flock;
 
 	while ((fl = *before) != NULL) {
@@ -2038,7 +2062,7 @@ void locks_remove_flock(struct file *filp)
  		}
 		before = &fl->fl_next;
 	}
-	unlock_kernel();
+	unlock_flocks();
 }
 
 /**
@@ -2053,12 +2077,12 @@ posix_unblock_lock(struct file *filp, struct file_lock *waiter)
 {
 	int status = 0;
 
-	lock_kernel();
+	lock_flocks();
 	if (waiter->fl_next)
 		__locks_delete_block(waiter);
 	else
 		status = -ENOENT;
-	unlock_kernel();
+	unlock_flocks();
 	return status;
 }
 
@@ -2172,7 +2196,7 @@ static int locks_show(struct seq_file *f, void *v)
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
-	lock_kernel();
+	lock_flocks();
 	f->private = (void *)1;
 	return seq_list_start(&file_lock_list, *pos);
 }
@@ -2184,7 +2208,7 @@ static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 
 static void locks_stop(struct seq_file *f, void *v)
 {
-	unlock_kernel();
+	unlock_flocks();
 }
 
 static const struct seq_operations locks_seq_operations = {
@@ -2231,7 +2255,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 {
 	struct file_lock *fl;
 	int result = 1;
-	lock_kernel();
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
 			if (fl->fl_type == F_RDLCK)
@@ -2248,7 +2272,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 		result = 0;
 		break;
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return result;
 }
 
@@ -2271,7 +2295,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 {
 	struct file_lock *fl;
 	int result = 1;
-	lock_kernel();
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
 			if ((fl->fl_end < start) || (fl->fl_start > (start + len)))
@@ -2286,7 +2310,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 		result = 0;
 		break;
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return result;
 }
 
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index b9c3c43..232a7ee 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -71,20 +71,20 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
 	if (inode->i_flock == NULL)
 		goto out;
 
-	/* Protect inode->i_flock using the BKL */
-	lock_kernel();
+	/* Protect inode->i_flock using the file locks lock */
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file) != ctx)
 			continue;
-		unlock_kernel();
+		unlock_flocks();
 		status = nfs4_lock_delegation_recall(state, fl);
 		if (status < 0)
 			goto out;
-		lock_kernel();
+		lock_flocks();
 	}
-	unlock_kernel();
+	unlock_flocks();
 out:
 	return status;
 }
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 3e2f19b..96524c5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -40,7 +40,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/fs.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_idmap.h>
 #include <linux/kthread.h>
@@ -970,13 +970,13 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
 	/* Guard against delegation returns and new lock/unlock calls */
 	down_write(&nfsi->rwsem);
 	/* Protect inode->i_flock using the BKL */
-	lock_kernel();
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file)->state != state)
 			continue;
-		unlock_kernel();
+		unlock_flocks();
 		status = ops->recover_lock(state, fl);
 		switch (status) {
 			case 0:
@@ -1003,9 +1003,9 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
 				/* kill_proc(fl->fl_pid, SIGLOST, 1); */
 				status = 0;
 		}
-		lock_kernel();
+		lock_flocks();
 	}
-	unlock_kernel();
+	unlock_flocks();
 out:
 	up_write(&nfsi->rwsem);
 	return status;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index cf0d2ff..a7292fc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -33,7 +33,7 @@
 */
 
 #include <linux/file.h>
-#include <linux/smp_lock.h>
+#include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/swap.h>
@@ -3895,7 +3895,7 @@ check_for_locks(struct nfs4_file *filp, struct nfs4_stateowner *lowner)
 	struct inode *inode = filp->fi_inode;
 	int status = 0;
 
-	lock_kernel();
+	lock_flocks();
 	for (flpp = &inode->i_flock; *flpp != NULL; flpp = &(*flpp)->fl_next) {
 		if ((*flpp)->fl_owner == (fl_owner_t)lowner) {
 			status = 1;
@@ -3903,7 +3903,7 @@ check_for_locks(struct nfs4_file *filp, struct nfs4_stateowner *lowner)
 		}
 	}
 out:
-	unlock_kernel();
+	unlock_flocks();
 	return status;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76041b6..8970123 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1131,6 +1131,8 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
+extern void lock_flocks(void);
+extern void unlock_flocks(void);
 #else /* !CONFIG_FILE_LOCKING */
 static inline int fcntl_getlk(struct file *file, struct flock __user *user)
 {
@@ -1273,6 +1275,14 @@ static inline int lock_may_write(struct inode *inode, loff_t start,
 	return 1;
 }
 
+static inline void lock_flocks()
+{
+}
+
+static inline void unlock_flocks()
+{
+}
+
 #endif /* !CONFIG_FILE_LOCKING */
 
 
-- 
1.7.1

