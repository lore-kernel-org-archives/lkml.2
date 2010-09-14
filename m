Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0INUHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:07:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0INUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:07:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] Remove BKL from fs/locks.c
Date: Tue, 14 Sep 2010 22:06:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009142206.54130.arnd@arndb.de>
X-Provags-ID: V02:K0:ENmANhhNFSoZIba7pPj//c6MFrFPssJIhcmtlUq0ZWH
 LK1ocy8pzBzMG+TwWogntNqUNl2WDSi9mO+VlHYJKgsOhHt/fx
 b0XHXQ3lv4SrHTPgz+zbw8hstMq/SB4rEKcRDAE9Hr98MiU0ED
 8ZFqx9h3w7M3a6TM3R6ijMHJu9DB7DWqJ4iHvFiYVKPTrQvMt+
 EWxxL8W9DGbp4ync56hvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

For reference, this is the patch I use for testing the BKL
removal tree, which does not really remove the BKL at all
as long as it is still required by fs/locks.c.

Christoph already made it clear that it cannot go upstream
like this and Stephen said he consequently didn't want it
in -next either. It may still be material for -mm or -rt,
or just anyone who wants to test a kernel with CONFIG_BKL
disabled.

It is also available in the a branch of my git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git nasty

I've taken a patch originally written by Matthew Wilcox and
ported it to the current version. Unfortunately, the change
conflicts with the use of lockd, which still heavily uses
the big kernel lock.

As a workaround, I've made the behaviour configurable,
it either uses the BKL when it's enabled or a spinlock
when the BKL (and consequently nfs and lockd) are
disabled.

Original introduction from Willy:

   I've been promising to do this for about seven years now.

   It seems to work well enough, but I haven't run any serious stress
   tests on it.  This implementation uses one spinlock to protect both lock
   lists and all the i_flock chains.  It doesn't seem worth splitting up
   the locking any further.

   I had to move one memory allocation out from under the file_lock_lock.
   I hope I got that logic right.  I'm rather tempted to split out the
   find_conflict algorithm from that function into something that can be
   called separately for the FL_ACCESS case.

   I also have to drop and reacquire the file_lock_lock around the call
   to cond_resched().  This was done automatically for us before by the
   special BKL semantics.

   I had to change vfs_setlease() as it relied on the special BKL ability
   to recursively acquire the same lock.  The internal caller now calls
   __vfs_setlease and the exported interface acquires and releases the
   file_lock_lock around calling __vfs_setlease.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Nacked-by: Christoph Hellwig <hch@lst.de>
---
 fs/Kconfig |    4 ++
 fs/locks.c |  116 +++++++++++++++++++++++++++++++++++++-----------------------
 2 files changed, 76 insertions(+), 44 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 3d18530..a424bf7 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -55,6 +55,10 @@ config FILE_LOCKING
           for filesystems like NFS and for the flock() system
           call. Disabling this option saves about 11k.
 
+config FLOCKS_SPINLOCK
+	bool
+	default FILE_LOCKING && !LOCK_KERNEL
+
 source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..77c3f00 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -140,9 +140,29 @@ int lease_break_time = 45;
 #define for_each_lock(inode, lockp) \
 	for (lockp = &inode->i_flock; *lockp != NULL; lockp = &(*lockp)->fl_next)
 
+/*
+ * Protects the two list heads below, plus the inode->i_flock list
+ */
 static LIST_HEAD(file_lock_list);
 static LIST_HEAD(blocked_list);
 
+#ifdef CONFIG_FLOCKS_SPINLOCK
+static DEFINE_SPINLOCK(file_lock_lock);
+
+static inline void lock_flocks(void)
+{
+	spin_lock(&file_lock_lock);
+}
+
+static inline void unlock_flocks(void)
+{
+	spin_unlock(&file_lock_lock);
+}
+#else
+#define lock_flocks() lock_kernel()
+#define unlock_flocks() unlock_kernel()
+#endif
+
 static struct kmem_cache *filelock_cache __read_mostly;
 
 /* Allocate an empty lock structure. */
@@ -511,9 +531,9 @@ static void __locks_delete_block(struct file_lock *waiter)
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
@@ -644,7 +664,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
 
-	lock_kernel();
+	lock_flocks();
 	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
 		if (!IS_POSIX(cfl))
 			continue;
@@ -657,7 +677,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 			fl->fl_pid = pid_vnr(cfl->fl_nspid);
 	} else
 		fl->fl_type = F_UNLCK;
-	unlock_kernel();
+	unlock_flocks();
 	return;
 }
 EXPORT_SYMBOL(posix_test_lock);
@@ -730,18 +750,16 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
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
@@ -767,8 +785,11 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
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
@@ -794,7 +815,7 @@ find_conflict:
 	error = 0;
 
 out:
-	unlock_kernel();
+	unlock_flocks();
 	if (new_fl)
 		locks_free_lock(new_fl);
 	return error;
@@ -823,7 +844,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		new_fl2 = locks_alloc_lock();
 	}
 
-	lock_kernel();
+	lock_flocks();
 	if (request->fl_type != F_UNLCK) {
 		for_each_lock(inode, before) {
 			fl = *before;
@@ -991,7 +1012,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		locks_wake_up_blocks(left);
 	}
  out:
-	unlock_kernel();
+	unlock_flocks();
 	/*
 	 * Free any unused locks.
 	 */
@@ -1066,14 +1087,14 @@ int locks_mandatory_locked(struct inode *inode)
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
 
@@ -1186,7 +1207,7 @@ int __break_lease(struct inode *inode, unsigned int mode)
 
 	new_fl = lease_alloc(NULL, want_write ? F_WRLCK : F_RDLCK);
 
-	lock_kernel();
+	lock_flocks();
 
 	time_out_leases(inode);
 
@@ -1247,8 +1268,10 @@ restart:
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
@@ -1263,7 +1286,7 @@ restart:
 	}
 
 out:
-	unlock_kernel();
+	unlock_flocks();
 	if (!IS_ERR(new_fl))
 		locks_free_lock(new_fl);
 	return error;
@@ -1319,7 +1342,7 @@ int fcntl_getlease(struct file *filp)
 	struct file_lock *fl;
 	int type = F_UNLCK;
 
-	lock_kernel();
+	lock_flocks();
 	time_out_leases(filp->f_path.dentry->d_inode);
 	for (fl = filp->f_path.dentry->d_inode->i_flock; fl && IS_LEASE(fl);
 			fl = fl->fl_next) {
@@ -1328,7 +1351,7 @@ int fcntl_getlease(struct file *filp)
 			break;
 		}
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return type;
 }
 
@@ -1341,7 +1364,7 @@ int fcntl_getlease(struct file *filp)
  *	The (input) flp->fl_lmops->fl_break function is required
  *	by break_lease().
  *
- *	Called with kernel lock held.
+ *	Called with file_lock_lock held.
  */
 int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 {
@@ -1436,7 +1459,15 @@ out:
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
@@ -1467,12 +1498,9 @@ int vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
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
@@ -1499,9 +1527,9 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 	if (error)
 		return error;
 
-	lock_kernel();
+	lock_flocks();
 
-	error = vfs_setlease(filp, arg, &flp);
+	error = __vfs_setlease(filp, arg, &flp);
 	if (error || arg == F_UNLCK)
 		goto out_unlock;
 
@@ -1516,7 +1544,7 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
 out_unlock:
-	unlock_kernel();
+	unlock_flocks();
 	return error;
 }
 
@@ -2020,7 +2048,7 @@ void locks_remove_flock(struct file *filp)
 			fl.fl_ops->fl_release_private(&fl);
 	}
 
-	lock_kernel();
+	lock_flocks();
 	before = &inode->i_flock;
 
 	while ((fl = *before) != NULL) {
@@ -2038,7 +2066,7 @@ void locks_remove_flock(struct file *filp)
  		}
 		before = &fl->fl_next;
 	}
-	unlock_kernel();
+	unlock_flocks();
 }
 
 /**
@@ -2053,12 +2081,12 @@ posix_unblock_lock(struct file *filp, struct file_lock *waiter)
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
 
@@ -2172,7 +2200,7 @@ static int locks_show(struct seq_file *f, void *v)
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
-	lock_kernel();
+	lock_flocks();
 	f->private = (void *)1;
 	return seq_list_start(&file_lock_list, *pos);
 }
@@ -2184,7 +2212,7 @@ static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 
 static void locks_stop(struct seq_file *f, void *v)
 {
-	unlock_kernel();
+	unlock_flocks();
 }
 
 static const struct seq_operations locks_seq_operations = {
@@ -2231,7 +2259,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 {
 	struct file_lock *fl;
 	int result = 1;
-	lock_kernel();
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
 			if (fl->fl_type == F_RDLCK)
@@ -2248,7 +2276,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 		result = 0;
 		break;
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return result;
 }
 
@@ -2271,7 +2299,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 {
 	struct file_lock *fl;
 	int result = 1;
-	lock_kernel();
+	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
 			if ((fl->fl_end < start) || (fl->fl_start > (start + len)))
@@ -2286,7 +2314,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 		result = 0;
 		break;
 	}
-	unlock_kernel();
+	unlock_flocks();
 	return result;
 }
 
-- 
1.7.1

