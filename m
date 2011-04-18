Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1DRDmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 23:42:25 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59490 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1DRDmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 23:42:19 -0400
X-Nat-Received: from [202.181.97.72]:62990 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303098109.24430
Message-Id: <201104180341.p3I3fnxc000638@www262.sakura.ne.jp>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Apr 2011 12:41:49 +0900
References: <20110417094505.865828233@chello.nl>
In-Reply-To: <20110417094505.865828233@chello.nl>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17042011 #5301042, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Continued from https://lkml.org/lkml/2011/3/31/240 "Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().")
Peter Zijlstra wrote:
> On Wed, 2011-03-30 at 21:17 +0900, Tetsuo Handa wrote:
> > Peter Zijlstra wrote:
> > > >  Also, I assume you meant to call
> > > > spin_acquire() before entering the spin state (as with
> > > > 
> > > >   static inline void __raw_spin_lock(raw_spinlock_t *lock)
> > > >   {
> > > >         preempt_disable();
> > > >         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> > > >         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> > > >   }
> > > > 
> > > > . Otherwise, lockdep cannot report it when hit this bug upon the first call to
> > > > this function). 
> > > 
> > > Huh no, of course not, a seqlock read side cannot contend in the classic
> > > sense.
> > 
> > I couldn't understand what 'contend' means. I think
> > 
> >   static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> >   {
> >   	unsigned ret;
> >   repeat:
> >   	ret = sl->sequence;
> >   	smp_rmb();
> >   	if (unlikely(ret & 1)) {
> >   		cpu_relax();
> >   		goto repeat;
> >   	}
> >   	return ret;
> >   }
> > 
> > is equivalent (except that above one will not write to any kernel memory) to
> > 
> >   static __always_inline unsigned read_seqbegin(seqlock_t *sl)
> >   {
> >   	unsigned ret;
> >   	unsigned long flags;
> >   	spin_lock_irqsave(&sl->lock, flags);
> >   	ret = sl->sequence;
> >   	spin_unlock_irqrestore(&sl->lock, flags);
> >   	return ret;
> >   }
> > 
> > because read_seqbegin() cannot return to the reader until the writer (if there
> > is one) calls write_sequnlock().
> 
> It more or less it, but conceptually the seqlock read-side is a
> non-blocking algorithm and thus doesn't block or contend. The above
> initial wait is merely an optimization to avoid having to retry, which
> could be more expensive than simply waiting there.

I agree that the loop in read_seqbegin() is an optimization. But I don't agree
with the location to insert lockdep annotation, for the location where I got a
freeze between "seqlock_t rename_lock" and "DEFINE_BRLOCK(vfsmount_lock)" was
the loop in read_seqbegin(). Conceptually the seqlock read-side is a
non-blocking algorithm and thus doesn't block or contend. But when locking
dependency is inappropriate, the seqlock read-side actually blocks forever in
read_seqbegin(). In order to catch inappropriate locking dependency, I still
think that lockdep annotation should be inserted in a way equivalent with

  static __always_inline unsigned read_seqbegin(seqlock_t *sl)
  {
  	unsigned ret;
  	unsigned long flags;
  	spin_lock_irqsave(&sl->lock, flags);
  	ret = sl->sequence;
  	spin_unlock_irqrestore(&sl->lock, flags);
  	return ret;
  }

.

> > Anyway, could you show me read_seqbegin2()/read_seqretry2() for testing with
> > locktest module?
> 
> Like I wrote before:
> 
> > @@ -94,6 +94,7 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> >                 cpu_relax();
> >                 goto repeat;
> >         }
> > +       rwlock_acquire_read(&sl->lock->dep_map, 0, 0, _RET_IP_);
> >  
> >         return ret;
> >  }
> > @@ -107,6 +108,8 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
> >  {
> >         smp_rmb();
> >  
> > +       rwlock_release(&sl->lock->dep_map, 1, _RET_IP_);
> > +
> >         return unlikely(sl->sequence != start);
> >  }
> 
> Should do, except that lockdep doesn't properly work for read-recursive
> locks, which needs to get fixed.

I assume this patchset is meant to fix this problem. I applied it on d733ed6c
"Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block" and ran the
locktest module.

---------- Start of locktest.c ----------
#include <linux/module.h>
#include <linux/seqlock.h>
#include <linux/lglock.h>
#include <linux/proc_fs.h>

static seqlock_t seqlock1;
static DEFINE_BRLOCK(brlock1);
static DEFINE_RWLOCK(rwlock1);

static __always_inline unsigned read_seqbegin2(seqlock_t *sl)
{
	unsigned ret;

repeat:
	ret = sl->sequence;
	smp_rmb();
	if (unlikely(ret & 1)) {
		cpu_relax();
		goto repeat;
	}
	//spin_acquire(&sl->lock.dep_map, 0, 0, _RET_IP_);
	rwlock_acquire_read(&sl->lock.dep_map, 0, 0, _RET_IP_);
	return ret;
}

static __always_inline int read_seqretry2(seqlock_t *sl, unsigned start)
{
	smp_rmb();
	//spin_release(&sl->lock.dep_map, 1, _RET_IP_);
	rwlock_release(&sl->lock.dep_map, 1, _RET_IP_);
	return unlikely(sl->sequence != start);
}

static int locktest_open1(struct inode *inode, struct file *file)
{
	write_seqlock(&seqlock1);
	br_read_lock(brlock1);
	br_read_unlock(brlock1);
	write_sequnlock(&seqlock1);
	return -EINVAL;
}

static int locktest_open2(struct inode *inode, struct file *file)
{
	unsigned int seq;
	br_write_lock(brlock1);
	seq = read_seqbegin2(&seqlock1);
	read_seqretry2(&seqlock1, seq);
	br_write_unlock(brlock1);
	return -EINVAL;
}

static int locktest_open3(struct inode *inode, struct file *file)
{
	write_seqlock(&seqlock1);
	read_lock(&rwlock1);
	read_unlock(&rwlock1);
	write_sequnlock(&seqlock1);
	return -EINVAL;
}

static int locktest_open4(struct inode *inode, struct file *file)
{
	unsigned int seq;
	write_lock(&rwlock1);
	seq = read_seqbegin2(&seqlock1);
	read_seqretry2(&seqlock1, seq);
	write_unlock(&rwlock1);
	return -EINVAL;
}

static const struct file_operations locktest_operations1 = {
	.open = locktest_open1
};

static const struct file_operations locktest_operations2 = {
	.open = locktest_open2
};

static const struct file_operations locktest_operations3 = {
	.open = locktest_open3
};

static const struct file_operations locktest_operations4 = {
	.open = locktest_open4
};

static int __init locktest_init(void)
{
	struct proc_dir_entry *entry;
	seqlock_init(&seqlock1);
	entry = create_proc_entry("locktest1", 0666, NULL);
	if (entry)
		entry->proc_fops = &locktest_operations1;
	entry = create_proc_entry("locktest2", 0666, NULL);
	if (entry)
		entry->proc_fops = &locktest_operations2;
	entry = create_proc_entry("locktest3", 0666, NULL);
	if (entry)
		entry->proc_fops = &locktest_operations3;
	entry = create_proc_entry("locktest4", 0666, NULL);
	if (entry)
		entry->proc_fops = &locktest_operations4;
	return 0;
}

static void __exit locktest_exit(void)
{
	remove_proc_entry("locktest1", NULL);
	remove_proc_entry("locktest2", NULL);
	remove_proc_entry("locktest3", NULL);
	remove_proc_entry("locktest4", NULL);
}

module_init(locktest_init);
module_exit(locktest_exit);
MODULE_LICENSE("GPL");
---------- End of locktest.c ----------

Test results for above program:

"cat /proc/locktest1 /proc/locktest2" => Detect fail
"cat /proc/locktest2 /proc/locktest1" => Detect fail
"cat /proc/locktest3 /proc/locktest4" => Detect fail
"cat /proc/locktest4 /proc/locktest3" => Detect fail

If I change from rwlock_acquire_read() to spin_acquire() in read_seqbegin2()
and from rwlock_release() to spin_release() in read_seqretry2():

"cat /proc/locktest1 /proc/locktest2" => Detect fail
"cat /proc/locktest2 /proc/locktest1" => Detect OK (shown below)
"cat /proc/locktest3 /proc/locktest4" => Detect fail
"cat /proc/locktest4 /proc/locktest3" => Detect OK (shown below)

Guessing from my testcases, read_seqbegin2() will fail to detect the problem
unless we use spin_acquire()/spin_release() rather than
rwlock_acquire_read()/rwlock_release().

Also, something is still wrong because lockdep fails to detect the problem
for "cat /proc/locktest1 /proc/locktest2" and
"cat /proc/locktest3 /proc/locktest4" cases.

[   83.551455] 
[   83.551457] =======================================================
[   83.555293] [ INFO: possible circular locking dependency detected ]
[   83.555293] 2.6.39-rc3-00228-gd733ed6-dirty #259
[   83.555293] -------------------------------------------------------
[   83.555293] cat/2768 is trying to acquire lock:
[   83.555293]  (brlock1_lock_dep_map){++++..}, at: [<e08150b0>] brlock1_local_lock+0x0/0x90 [locktest]
[   83.555293] 
[   83.555293] but task is already holding lock:
[   83.555293]  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e08154dd>] locktest_open1+0xd/0x40 [locktest]
[   83.555293] 
[   83.555293] which lock already depends on the new lock.
[   83.555293] 
[   83.555293] 
[   83.555293] the existing dependency chain (in reverse order) is:
[   83.555293] 
[   83.555293] -> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
[   83.635281]        [<c106c499>] check_prevs_add+0xb9/0x110
[   83.635281]        [<c106c840>] validate_chain+0x320/0x5a0
[   83.635281]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
[   83.635281]        [<c107001a>] lock_acquire+0x7a/0xa0
[   83.635281]        [<e0815555>] locktest_open2+0x45/0x70 [locktest]
[   83.635281]        [<c1118355>] proc_reg_open+0x65/0xe0
[   83.635281]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
[   83.635281]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
[   83.635281]        [<c10dc1d8>] do_last+0xf8/0x6c0
[   83.635281]        [<c10dc846>] path_openat+0xa6/0x340
[   83.635281]        [<c10dcb10>] do_filp_open+0x30/0x80
[   83.635281]        [<c10cefa1>] do_sys_open+0x101/0x1a0
[   83.635281]        [<c10cf069>] sys_open+0x29/0x40
[   83.635281]        [<c13b43c1>] syscall_call+0x7/0xb
[   83.635281] 
[   83.635281] -> #0 (brlock1_lock_dep_map){++++..}:
[   83.635281]        [<c106c34c>] check_prev_add+0x78c/0x820
[   83.635281]        [<c106c499>] check_prevs_add+0xb9/0x110
[   83.635281]        [<c106c840>] validate_chain+0x320/0x5a0
[   83.635281]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
[   83.635281]        [<c107001a>] lock_acquire+0x7a/0xa0
[   83.635281]        [<e08150e3>] brlock1_local_lock+0x33/0x90 [locktest]
[   83.635281]        [<e08154e8>] locktest_open1+0x18/0x40 [locktest]
[   83.635281]        [<c1118355>] proc_reg_open+0x65/0xe0
[   83.635281]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
[   83.635281]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
[   83.635281]        [<c10dc1d8>] do_last+0xf8/0x6c0
[   83.635281]        [<c10dc846>] path_openat+0xa6/0x340
[   83.635281]        [<c10dcb10>] do_filp_open+0x30/0x80
[   83.635281]        [<c10cefa1>] do_sys_open+0x101/0x1a0
[   83.635281]        [<c10cf069>] sys_open+0x29/0x40
[   83.635281]        [<c13b43c1>] syscall_call+0x7/0xb
[   83.635281] 
[   83.635281] other info that might help us debug this:
[   83.635281] 
[   83.635281] 1 lock held by cat/2768:
[   83.635281]  #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e08154dd>] locktest_open1+0xd/0x40 [locktest]
[   83.635281] 
[   83.635281] stack backtrace:
[   83.635281] Pid: 2768, comm: cat Not tainted 2.6.39-rc3-00228-gd733ed6-dirty #259
[   83.635281] Call Trace:
[   83.635281]  [<c106ade6>] print_circular_bug+0xc6/0xd0
[   83.635281]  [<c106c34c>] check_prev_add+0x78c/0x820
[   83.635281]  [<c1005d3b>] ? print_context_stack+0x3b/0xa0
[   83.635281]  [<c1004fa1>] ? dump_trace+0x81/0xe0
[   83.635281]  [<c106c499>] check_prevs_add+0xb9/0x110
[   83.635281]  [<c106c840>] validate_chain+0x320/0x5a0
[   83.635281]  [<c106df7c>] ? mark_lock+0x21c/0x3c0
[   83.635281]  [<c106e927>] __lock_acquire+0x2a7/0x8f0
[   83.635281]  [<c107001a>] lock_acquire+0x7a/0xa0
[   83.635281]  [<e08150b0>] ? brlock1_lock_init+0xb0/0xb0 [locktest]
[   83.635281]  [<e08154d0>] ? brlock1_global_unlock+0xa0/0xa0 [locktest]
[   83.635281]  [<e08150e3>] brlock1_local_lock+0x33/0x90 [locktest]
[   83.635281]  [<e08150b0>] ? brlock1_lock_init+0xb0/0xb0 [locktest]
[   83.635281]  [<e08154e8>] locktest_open1+0x18/0x40 [locktest]
[   83.635281]  [<c1118355>] proc_reg_open+0x65/0xe0
[   83.635281]  [<c10ce78f>] __dentry_open+0x16f/0x2e0
[   83.635281]  [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
[   83.635281]  [<c11182f0>] ? proc_reg_mmap+0x80/0x80
[   83.635281]  [<c10dc1d8>] do_last+0xf8/0x6c0
[   83.635281]  [<c10db00c>] ? path_init+0x2cc/0x3c0
[   83.635281]  [<c10dc846>] path_openat+0xa6/0x340
[   83.635281]  [<c106d80b>] ? trace_hardirqs_off+0xb/0x10
[   83.635281]  [<c10dcb10>] do_filp_open+0x30/0x80
[   83.635281]  [<c13b3a5d>] ? _raw_spin_unlock+0x1d/0x20
[   83.635281]  [<c10e9f11>] ? alloc_fd+0xe1/0x1a0
[   83.635281]  [<c10cefa1>] do_sys_open+0x101/0x1a0
[   83.635281]  [<c10cfc8b>] ? vfs_write+0x10b/0x130
[   83.635281]  [<c10cf069>] sys_open+0x29/0x40
[   83.635281]  [<c13b43c1>] syscall_call+0x7/0xb



[   82.758647] 
[   82.758649] =======================================================
[   82.762520] [ INFO: possible circular locking dependency detected ]
[   82.762520] 2.6.39-rc3-00228-gd733ed6-dirty #259
[   82.762520] -------------------------------------------------------
[   82.762520] cat/2768 is trying to acquire lock:
[   82.762520]  (rwlock1){++++..}, at: [<e081559d>] locktest_open3+0x1d/0x40 [locktest]
[   82.762520] 
[   82.762520] but task is already holding lock:
[   82.762520]  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e081558d>] locktest_open3+0xd/0x40 [locktest]
[   82.762520] 
[   82.762520] which lock already depends on the new lock.
[   82.762520] 
[   82.762520] 
[   82.762520] the existing dependency chain (in reverse order) is:
[   82.762520] 
[   82.762520] -> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
[   82.841627]        [<c106c499>] check_prevs_add+0xb9/0x110
[   82.841627]        [<c106c840>] validate_chain+0x320/0x5a0
[   82.841627]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
[   82.841627]        [<c107001a>] lock_acquire+0x7a/0xa0
[   82.841627]        [<e081560a>] locktest_open4+0x4a/0x90 [locktest]
[   82.841627]        [<c1118355>] proc_reg_open+0x65/0xe0
[   82.841627]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
[   82.841627]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
[   82.841627]        [<c10dc1d8>] do_last+0xf8/0x6c0
[   82.841627]        [<c10dc846>] path_openat+0xa6/0x340
[   82.841627]        [<c10dcb10>] do_filp_open+0x30/0x80
[   82.841627]        [<c10cefa1>] do_sys_open+0x101/0x1a0
[   82.841627]        [<c10cf069>] sys_open+0x29/0x40
[   82.841627]        [<c13b43c1>] syscall_call+0x7/0xb
[   82.841627] 
[   82.841627] -> #0 (rwlock1){++++..}:
[   82.841627]        [<c106c34c>] check_prev_add+0x78c/0x820
[   82.841627]        [<c106c499>] check_prevs_add+0xb9/0x110
[   82.841627]        [<c106c840>] validate_chain+0x320/0x5a0
[   82.841627]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
[   82.841627]        [<c107001a>] lock_acquire+0x7a/0xa0
[   82.841627]        [<c13b3ba9>] _raw_read_lock+0x39/0x70
[   82.841627]        [<e081559d>] locktest_open3+0x1d/0x40 [locktest]
[   82.841627]        [<c1118355>] proc_reg_open+0x65/0xe0
[   82.841627]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
[   82.841627]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
[   82.841627]        [<c10dc1d8>] do_last+0xf8/0x6c0
[   82.841627]        [<c10dc846>] path_openat+0xa6/0x340
[   82.841627]        [<c10dcb10>] do_filp_open+0x30/0x80
[   82.841627]        [<c10cefa1>] do_sys_open+0x101/0x1a0
[   82.841627]        [<c10cf069>] sys_open+0x29/0x40
[   82.841627]        [<c13b43c1>] syscall_call+0x7/0xb
[   82.841627] 
[   82.841627] other info that might help us debug this:
[   82.841627] 
[   82.841627] 1 lock held by cat/2768:
[   82.841627]  #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e081558d>] locktest_open3+0xd/0x40 [locktest]
[   82.841627] 
[   82.841627] stack backtrace:
[   82.841627] Pid: 2768, comm: cat Not tainted 2.6.39-rc3-00228-gd733ed6-dirty #259
[   82.841627] Call Trace:
[   82.841627]  [<c106ade6>] print_circular_bug+0xc6/0xd0
[   82.841627]  [<c106c34c>] check_prev_add+0x78c/0x820
[   82.841627]  [<c1005d3b>] ? print_context_stack+0x3b/0xa0
[   82.841627]  [<c1004fa1>] ? dump_trace+0x81/0xe0
[   82.841627]  [<c106c499>] check_prevs_add+0xb9/0x110
[   82.841627]  [<c106c840>] validate_chain+0x320/0x5a0
[   82.841627]  [<c106df7c>] ? mark_lock+0x21c/0x3c0
[   82.841627]  [<c106e927>] __lock_acquire+0x2a7/0x8f0
[   82.841627]  [<c107001a>] lock_acquire+0x7a/0xa0
[   82.841627]  [<e081559d>] ? locktest_open3+0x1d/0x40 [locktest]
[   82.841627]  [<e0815580>] ? locktest_open2+0x70/0x70 [locktest]
[   82.841627]  [<c13b3ba9>] _raw_read_lock+0x39/0x70
[   82.841627]  [<e081559d>] ? locktest_open3+0x1d/0x40 [locktest]
[   82.841627]  [<e081559d>] locktest_open3+0x1d/0x40 [locktest]
[   82.841627]  [<c1118355>] proc_reg_open+0x65/0xe0
[   82.841627]  [<c10ce78f>] __dentry_open+0x16f/0x2e0
[   82.841627]  [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
[   82.841627]  [<c11182f0>] ? proc_reg_mmap+0x80/0x80
[   82.841627]  [<c10dc1d8>] do_last+0xf8/0x6c0
[   82.841627]  [<c10db00c>] ? path_init+0x2cc/0x3c0
[   82.841627]  [<c10dc846>] path_openat+0xa6/0x340
[   82.841627]  [<c106d80b>] ? trace_hardirqs_off+0xb/0x10
[   82.841627]  [<c10dcb10>] do_filp_open+0x30/0x80
[   82.841627]  [<c13b3a5d>] ? _raw_spin_unlock+0x1d/0x20
[   82.841627]  [<c10e9f11>] ? alloc_fd+0xe1/0x1a0
[   82.841627]  [<c10cefa1>] do_sys_open+0x101/0x1a0
[   82.841627]  [<c10cfc8b>] ? vfs_write+0x10b/0x130
[   82.841627]  [<c10cf069>] sys_open+0x29/0x40
[   82.841627]  [<c13b43c1>] syscall_call+0x7/0xb
