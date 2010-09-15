Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0IORBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:01:10 -0400
Received: from cobra.newdream.net ([66.33.216.30]:41604 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab0IORBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:01:08 -0400
Date: Wed, 15 Sep 2010 10:02:41 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Arnd Bergmann <arnd@arndb.de>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, gregf@hq.newdream.net
Subject: Re: [PATCH] Remove BKL from fs/locks.c
In-Reply-To: <201009151830.43470.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1009150948190.24081@cobra.newdream.net>
References: <201009142206.54130.arnd@arndb.de> <201009142324.16074.arnd@arndb.de>
 <1284501356.10782.139.camel@heimdal.trondhjem.org> <201009151830.43470.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, 15 Sep 2010, Arnd Bergmann wrote:

> On Tuesday 14 September 2010, Trond Myklebust wrote:
> > Would it be possible to at least merge a patch that defines
> > lock_flocks() (even if it just is an alias for lock_kernel()), so that
> > we can convert those bits of the lock recovery code that need to peek
> > into the inode->i_flock list ASAP?
> 
> Fine with me.

That's my preference.  See below:

> 
> Another alternative would be to keep a series of all these patches
> together, like
> 
> 1. fs/locks.c: prepare for BKL removal
> 2. fs/lockd: use lock/flocks
> 3. fs/locks.c: lock_flocks using spinlock (trivial)
>
> Feel free to take the patch below into a tree of yours when
> adding patches 2 and 3 on top, or send me that patch once
> it's done and I'll add both into my tree.
> 
> Linus, Christoph: Does the patch below look ok? I've removed
> the CONFIG_BKL stuff in it now and changed over everything
> besides lockd to use lock_flocks(). I'd like to put this into
> the -next queue (after some basic testing).
> ---
> Subject: [PATCH] fs/locks.c: prepare for BKL removal
> 
> This prepares the removal of the big kernel lock from the
> file locking code. We still use the BKL as long as fs/lockd
> uses it, but flip the definition to a private spinlock
> as soon as that's done.
> 
> All users outside of fs/lockd get converted to use
> lock_flocks() instead of lock_kernel() where appropriate.
> 
> Based on an earlier patch from Matthew Wilcox.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> ---
> 
>  fs/afs/flock.c       |    5 +-
>  fs/ceph/mds_client.c |    6 +-
>  fs/locks.c           |  118 ++++++++++++++++++++++++++++---------------------
>  fs/nfs/delegation.c  |   10 ++--
>  fs/nfs/nfs4state.c   |   10 ++--
>  fs/nfsd/nfs4state.c  |    6 +-
>  include/linux/fs.h   |   10 ++++
>  7 files changed, 95 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/afs/flock.c b/fs/afs/flock.c
> index 0931bc1..757d664 100644
> --- a/fs/afs/flock.c
> +++ b/fs/afs/flock.c
> @@ -9,7 +9,6 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  
> -#include <linux/smp_lock.h>
>  #include "internal.h"
>  
>  #define AFS_LOCK_GRANTED	0
> @@ -274,7 +273,7 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
>  
>  	type = (fl->fl_type == F_RDLCK) ? AFS_LOCK_READ : AFS_LOCK_WRITE;
>  
> -	lock_kernel();
> +	lock_flocks();
>  
>  	/* make sure we've got a callback on this file and that our view of the
>  	 * data version is up to date */
> @@ -421,7 +420,7 @@ given_lock:
>  	afs_vnode_fetch_status(vnode, NULL, key);
>  
>  error:
> -	unlock_kernel();
> +	unlock_flocks();
>  	_leave(" = %d", ret);
>  	return ret;
>  
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f091b13..bda5211 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3,7 +3,7 @@
>  #include <linux/wait.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> -#include <linux/smp_lock.h>
> +#include <linux/fs.h>
>  
>  #include "mds_client.h"
>  #include "mon_client.h"
> @@ -2362,7 +2362,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	if (recon_state->flock) {
>  		int num_fcntl_locks, num_flock_locks;
>  
> -		lock_kernel();
> +		lock_flocks();
>  		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
>  		rec.v2.flock_len = (2*sizeof(u32) +
>  				    (num_fcntl_locks+num_flock_locks) *
> @@ -2373,7 +2373,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			err = ceph_encode_locks(inode, pagelist,
>  						num_fcntl_locks,
>  						num_flock_locks);
> -		unlock_kernel();
> +		unlock_flocks();
>  	}

The Ceph code won't currently behave with lock_flocks() taking a spinlock.  
We're preparing a patch to fix that now.  As long as there is a window 
between lock_flocks() being defined and the spinlock conversion, I can 
send the fix upstream then and avoid any breakage.  Or send the patches 
your way to include in your tree, whatever you prefer!

>  
>  out_free:
> diff --git a/fs/locks.c b/fs/locks.c
> index ab24d49..8c6935f 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -143,6 +143,21 @@ int lease_break_time = 45;
>  static LIST_HEAD(file_lock_list);
>  static LIST_HEAD(blocked_list);
>  
> +/*
> + * Protects the two list heads above, plus the inode->i_flock list
> + * FIXME: should use a spinlock, once fs/lockd uses lock_flocks().
> + */
> +void lock_flocks(void)
> +{
> +	lock_kernel();
> +}
> +EXPORT_SYMBOL(lock_flocks);
> +
> +void unlock_flocks(void)
> +{
> +	unlock_kernel();
> +}

EXPORT_SYMBOL(unlock_flocks); ?

Thanks!
sage


> +
>  static struct kmem_cache *filelock_cache __read_mostly;
>  
>  /* Allocate an empty lock structure. */
> @@ -511,9 +526,9 @@ static void __locks_delete_block(struct file_lock *waiter)
>   */
>  static void locks_delete_block(struct file_lock *waiter)
>  {
> -	lock_kernel();
> +	lock_flocks();
>  	__locks_delete_block(waiter);
> -	unlock_kernel();
> +	unlock_flocks();
>  }
>  
>  /* Insert waiter into blocker's block list.
> @@ -644,7 +659,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
>  {
>  	struct file_lock *cfl;
>  
> -	lock_kernel();
> +	lock_flocks();
>  	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
>  		if (!IS_POSIX(cfl))
>  			continue;
> @@ -657,7 +672,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
>  			fl->fl_pid = pid_vnr(cfl->fl_nspid);
>  	} else
>  		fl->fl_type = F_UNLCK;
> -	unlock_kernel();
> +	unlock_flocks();
>  	return;
>  }
>  EXPORT_SYMBOL(posix_test_lock);
> @@ -730,18 +745,16 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
>  	int error = 0;
>  	int found = 0;
>  
> -	lock_kernel();
> -	if (request->fl_flags & FL_ACCESS)
> -		goto find_conflict;
> -
> -	if (request->fl_type != F_UNLCK) {
> -		error = -ENOMEM;
> +	if (!(request->fl_flags & FL_ACCESS) && (request->fl_type != F_UNLCK)) {
>  		new_fl = locks_alloc_lock();
> -		if (new_fl == NULL)
> -			goto out;
> -		error = 0;
> +		if (!new_fl)
> +			return -ENOMEM;
>  	}
>  
> +	lock_flocks();
> +	if (request->fl_flags & FL_ACCESS)
> +		goto find_conflict;
> +
>  	for_each_lock(inode, before) {
>  		struct file_lock *fl = *before;
>  		if (IS_POSIX(fl))
> @@ -767,8 +780,11 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
>  	 * If a higher-priority process was blocked on the old file lock,
>  	 * give it the opportunity to lock the file.
>  	 */
> -	if (found)
> +	if (found) {
> +		unlock_flocks();
>  		cond_resched();
> +		lock_flocks();
> +	}
>  
>  find_conflict:
>  	for_each_lock(inode, before) {
> @@ -794,7 +810,7 @@ find_conflict:
>  	error = 0;
>  
>  out:
> -	unlock_kernel();
> +	unlock_flocks();
>  	if (new_fl)
>  		locks_free_lock(new_fl);
>  	return error;
> @@ -823,7 +839,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
>  		new_fl2 = locks_alloc_lock();
>  	}
>  
> -	lock_kernel();
> +	lock_flocks();
>  	if (request->fl_type != F_UNLCK) {
>  		for_each_lock(inode, before) {
>  			fl = *before;
> @@ -991,7 +1007,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
>  		locks_wake_up_blocks(left);
>  	}
>   out:
> -	unlock_kernel();
> +	unlock_flocks();
>  	/*
>  	 * Free any unused locks.
>  	 */
> @@ -1066,14 +1082,14 @@ int locks_mandatory_locked(struct inode *inode)
>  	/*
>  	 * Search the lock list for this inode for any POSIX locks.
>  	 */
> -	lock_kernel();
> +	lock_flocks();
>  	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
>  		if (!IS_POSIX(fl))
>  			continue;
>  		if (fl->fl_owner != owner)
>  			break;
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  	return fl ? -EAGAIN : 0;
>  }
>  
> @@ -1186,7 +1202,7 @@ int __break_lease(struct inode *inode, unsigned int mode)
>  
>  	new_fl = lease_alloc(NULL, want_write ? F_WRLCK : F_RDLCK);
>  
> -	lock_kernel();
> +	lock_flocks();
>  
>  	time_out_leases(inode);
>  
> @@ -1247,8 +1263,10 @@ restart:
>  			break_time++;
>  	}
>  	locks_insert_block(flock, new_fl);
> +	unlock_flocks();
>  	error = wait_event_interruptible_timeout(new_fl->fl_wait,
>  						!new_fl->fl_next, break_time);
> +	lock_flocks();
>  	__locks_delete_block(new_fl);
>  	if (error >= 0) {
>  		if (error == 0)
> @@ -1263,7 +1281,7 @@ restart:
>  	}
>  
>  out:
> -	unlock_kernel();
> +	unlock_flocks();
>  	if (!IS_ERR(new_fl))
>  		locks_free_lock(new_fl);
>  	return error;
> @@ -1319,7 +1337,7 @@ int fcntl_getlease(struct file *filp)
>  	struct file_lock *fl;
>  	int type = F_UNLCK;
>  
> -	lock_kernel();
> +	lock_flocks();
>  	time_out_leases(filp->f_path.dentry->d_inode);
>  	for (fl = filp->f_path.dentry->d_inode->i_flock; fl && IS_LEASE(fl);
>  			fl = fl->fl_next) {
> @@ -1328,7 +1346,7 @@ int fcntl_getlease(struct file *filp)
>  			break;
>  		}
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  	return type;
>  }
>  
> @@ -1341,7 +1359,7 @@ int fcntl_getlease(struct file *filp)
>   *	The (input) flp->fl_lmops->fl_break function is required
>   *	by break_lease().
>   *
> - *	Called with kernel lock held.
> + *	Called with file_lock_lock held.
>   */
>  int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
>  {
> @@ -1359,6 +1377,13 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
>  	if (error)
>  		return error;
>  
> +	if (arg != F_UNLCK) {
> +		new_fl = locks_alloc_lock();
> +		if (new_fl == NULL)
> +			return -ENOMEM;
> +	}
> +
> +	lock_flocks();
>  	time_out_leases(inode);
>  
>  	BUG_ON(!(*flp)->fl_lmops->fl_break);
> @@ -1366,11 +1391,6 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
>  	lease = *flp;
>  
>  	if (arg != F_UNLCK) {
> -		error = -ENOMEM;
> -		new_fl = locks_alloc_lock();
> -		if (new_fl == NULL)
> -			goto out;
> -
>  		error = -EAGAIN;
>  		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
>  			goto out;
> @@ -1427,16 +1447,18 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
>  	locks_insert_lock(before, new_fl);
>  
>  	*flp = new_fl;
> +	unlock_flocks();
>  	return 0;
>  
>  out:
>  	if (new_fl != NULL)
>  		locks_free_lock(new_fl);
> +	unlock_flocks();
>  	return error;
>  }
>  EXPORT_SYMBOL(generic_setlease);
>  
> - /**
> +/**
>   *	vfs_setlease        -       sets a lease on an open file
>   *	@filp: file pointer
>   *	@arg: type of lease to obtain
> @@ -1465,16 +1487,10 @@ EXPORT_SYMBOL(generic_setlease);
>  
>  int vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
>  {
> -	int error;
> -
> -	lock_kernel();
>  	if (filp->f_op && filp->f_op->setlease)
> -		error = filp->f_op->setlease(filp, arg, lease);
> +		return filp->f_op->setlease(filp, arg, lease);
>  	else
> -		error = generic_setlease(filp, arg, lease);
> -	unlock_kernel();
> -
> -	return error;
> +		return generic_setlease(filp, arg, lease);
>  }
>  EXPORT_SYMBOL_GPL(vfs_setlease);
>  
> @@ -1499,12 +1515,12 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
>  	if (error)
>  		return error;
>  
> -	lock_kernel();
> -
>  	error = vfs_setlease(filp, arg, &flp);
>  	if (error || arg == F_UNLCK)
>  		goto out_unlock;
>  
> +	lock_flocks();
> +
>  	error = fasync_helper(fd, filp, 1, &flp->fl_fasync);
>  	if (error < 0) {
>  		/* remove lease just inserted by setlease */
> @@ -1516,7 +1532,7 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
>  
>  	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
>  out_unlock:
> -	unlock_kernel();
> +	unlock_flocks();
>  	return error;
>  }
>  
> @@ -2020,7 +2036,7 @@ void locks_remove_flock(struct file *filp)
>  			fl.fl_ops->fl_release_private(&fl);
>  	}
>  
> -	lock_kernel();
> +	lock_flocks();
>  	before = &inode->i_flock;
>  
>  	while ((fl = *before) != NULL) {
> @@ -2038,7 +2054,7 @@ void locks_remove_flock(struct file *filp)
>   		}
>  		before = &fl->fl_next;
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  }
>  
>  /**
> @@ -2053,12 +2069,12 @@ posix_unblock_lock(struct file *filp, struct file_lock *waiter)
>  {
>  	int status = 0;
>  
> -	lock_kernel();
> +	lock_flocks();
>  	if (waiter->fl_next)
>  		__locks_delete_block(waiter);
>  	else
>  		status = -ENOENT;
> -	unlock_kernel();
> +	unlock_flocks();
>  	return status;
>  }
>  
> @@ -2172,7 +2188,7 @@ static int locks_show(struct seq_file *f, void *v)
>  
>  static void *locks_start(struct seq_file *f, loff_t *pos)
>  {
> -	lock_kernel();
> +	lock_flocks();
>  	f->private = (void *)1;
>  	return seq_list_start(&file_lock_list, *pos);
>  }
> @@ -2184,7 +2200,7 @@ static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
>  
>  static void locks_stop(struct seq_file *f, void *v)
>  {
> -	unlock_kernel();
> +	unlock_flocks();
>  }
>  
>  static const struct seq_operations locks_seq_operations = {
> @@ -2231,7 +2247,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
>  {
>  	struct file_lock *fl;
>  	int result = 1;
> -	lock_kernel();
> +	lock_flocks();
>  	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
>  		if (IS_POSIX(fl)) {
>  			if (fl->fl_type == F_RDLCK)
> @@ -2248,7 +2264,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
>  		result = 0;
>  		break;
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  	return result;
>  }
>  
> @@ -2271,7 +2287,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
>  {
>  	struct file_lock *fl;
>  	int result = 1;
> -	lock_kernel();
> +	lock_flocks();
>  	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
>  		if (IS_POSIX(fl)) {
>  			if ((fl->fl_end < start) || (fl->fl_start > (start + len)))
> @@ -2286,7 +2302,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
>  		result = 0;
>  		break;
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  	return result;
>  }
>  
> diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> index b9c3c43..232a7ee 100644
> --- a/fs/nfs/delegation.c
> +++ b/fs/nfs/delegation.c
> @@ -71,20 +71,20 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
>  	if (inode->i_flock == NULL)
>  		goto out;
>  
> -	/* Protect inode->i_flock using the BKL */
> -	lock_kernel();
> +	/* Protect inode->i_flock using the file locks lock */
> +	lock_flocks();
>  	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
>  		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
>  			continue;
>  		if (nfs_file_open_context(fl->fl_file) != ctx)
>  			continue;
> -		unlock_kernel();
> +		unlock_flocks();
>  		status = nfs4_lock_delegation_recall(state, fl);
>  		if (status < 0)
>  			goto out;
> -		lock_kernel();
> +		lock_flocks();
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  out:
>  	return status;
>  }
> diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
> index 3e2f19b..96524c5 100644
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -40,7 +40,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> -#include <linux/smp_lock.h>
> +#include <linux/fs.h>
>  #include <linux/nfs_fs.h>
>  #include <linux/nfs_idmap.h>
>  #include <linux/kthread.h>
> @@ -970,13 +970,13 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
>  	/* Guard against delegation returns and new lock/unlock calls */
>  	down_write(&nfsi->rwsem);
>  	/* Protect inode->i_flock using the BKL */
> -	lock_kernel();
> +	lock_flocks();
>  	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
>  		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
>  			continue;
>  		if (nfs_file_open_context(fl->fl_file)->state != state)
>  			continue;
> -		unlock_kernel();
> +		unlock_flocks();
>  		status = ops->recover_lock(state, fl);
>  		switch (status) {
>  			case 0:
> @@ -1003,9 +1003,9 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
>  				/* kill_proc(fl->fl_pid, SIGLOST, 1); */
>  				status = 0;
>  		}
> -		lock_kernel();
> +		lock_flocks();
>  	}
> -	unlock_kernel();
> +	unlock_flocks();
>  out:
>  	up_write(&nfsi->rwsem);
>  	return status;
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index cf0d2ff..a7292fc 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -33,7 +33,7 @@
>  */
>  
>  #include <linux/file.h>
> -#include <linux/smp_lock.h>
> +#include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/namei.h>
>  #include <linux/swap.h>
> @@ -3895,7 +3895,7 @@ check_for_locks(struct nfs4_file *filp, struct nfs4_stateowner *lowner)
>  	struct inode *inode = filp->fi_inode;
>  	int status = 0;
>  
> -	lock_kernel();
> +	lock_flocks();
>  	for (flpp = &inode->i_flock; *flpp != NULL; flpp = &(*flpp)->fl_next) {
>  		if ((*flpp)->fl_owner == (fl_owner_t)lowner) {
>  			status = 1;
> @@ -3903,7 +3903,7 @@ check_for_locks(struct nfs4_file *filp, struct nfs4_stateowner *lowner)
>  		}
>  	}
>  out:
> -	unlock_kernel();
> +	unlock_flocks();
>  	return status;
>  }
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0ec4d60..fd85cd2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1127,6 +1127,8 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
>  extern int lease_modify(struct file_lock **, int);
>  extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
>  extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
> +extern void lock_flocks(void);
> +extern void unlock_flocks(void);
>  #else /* !CONFIG_FILE_LOCKING */
>  static inline int fcntl_getlk(struct file *file, struct flock __user *user)
>  {
> @@ -1269,6 +1271,14 @@ static inline int lock_may_write(struct inode *inode, loff_t start,
>  	return 1;
>  }
>  
> +static inline void lock_flocks()
> +{
> +}
> +
> +static inline void unlock_flocks()
> +{
> +}
> +
>  #endif /* !CONFIG_FILE_LOCKING */
>  
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
