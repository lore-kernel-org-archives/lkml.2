Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1C3IMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:12:47 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55221 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab1C3IMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:12:42 -0400
X-Nat-Received: from [202.181.97.72]:60576 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1301472739.2532
Message-Id: <201103300812.p2U8CJ9T071782@www262.sakura.ne.jp>
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: peterz@infradead.org
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Mar 2011 17:12:19 +0900
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp> <20110328171217.GA8529@home.goodmis.org> <201103290430.p2T4UhLA081016@www262.sakura.ne.jp> <1301405984.2250.402.camel@laptop> <1301421032.2250.432.camel@laptop>
In-Reply-To: <1301421032.2250.432.camel@laptop>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 30032011 #5166514, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2011-03-29 at 15:39 +0200, Peter Zijlstra wrote:
> > 
> > That said, there are some out-standing issues with rw_locks and lockdep,
> > Gautham and I worked on that for a while but we never persevered and
> > finished it..
> > 
> >   http://lkml.org/lkml/2009/5/11/203 
> 
> I just did a quick rebase onto tip/master (compile tested only):
> 
>   http://programming.kicks-ass.net/sekrit/patches-lockdep.tar.bz2
> 
> That series needs testing and a few patches to extend the
> lib/locking-selftest* bits to cover the new functionality.

Thanks, but I didn't apply above tarball to 2.6.38.2 because lockdep selftests
failed. Instead, I retested using 2.6.39-rc1 without applying above tarball.

> In order to hit your inversion you need to do something like:
> 
> cat /proc/locktest1 & cat /proc/locktest2
> 
> if you do them serialized you'll never hit that inversion.

Yes, I know. But I think that lockdep should report the possibility of hitting
that inversion even if I do them serialized.

My understanding is that lockdep can report the possibility of deadlock without
actually triggering deadlock as long as lockdep annotation is maintained
correctly and each annotation is called for at least one time.
Am I misunderstanding?

I'm exploring this code in order to let lockdep report the possibility of
hitting the inversion without actually hitting the inversion.

> On Sat, 2011-03-26 at 13:12 +0900, Tetsuo Handa wrote:
> > @@ -86,6 +86,11 @@ static inline int write_tryseqlock(seqlo
> >  static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> >  {
> >         unsigned ret;
> > +#ifdef CONFIG_PROVE_LOCKING
> > +       unsigned long flags;
> > +       spin_lock_irqsave(&((seqlock_t *) sl)->lock, flags);
> > +       spin_unlock_irqrestore(&((seqlock_t *) sl)->lock, flags);
> > +#endif
> >  
> >  repeat:
> >         ret = sl->sequence; 
> 
> That isn't the right way, something like the below would do, however
> there's a reason this isn't done, we use these primitives from the VDSO
> which means they're not permitted to write to any kernel memory at all.

So, this is not a bug but intended coding. Then, we want a comment here why
lockdep annotation is missing.

> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -94,6 +94,7 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
>  		cpu_relax();
>  		goto repeat;
>  	}
> +	rwlock_acquire_read(&sl->lock->dep_map, 0, 0, _RET_IP_);
>  
>  	return ret;
>  }
> @@ -107,6 +108,8 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
>  {
>  	smp_rmb();
>  
> +	rwlock_release(&sl->lock->dep_map, 1, _RET_IP_);
> +
>  	return unlikely(sl->sequence != start);
>  }

Excuse me, but the lock embedded into seqlock_t is spinlock rather than rwlock.
I assume you meant spin_acquire()/spin_release() rather than
rwlock_acquire_read()/rwlock_release(). Also, I assume you meant to call
spin_acquire() before entering the spin state (as with

  static inline void __raw_spin_lock(raw_spinlock_t *lock)
  {
  	preempt_disable();
  	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
  	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
  }

. Otherwise, lockdep cannot report it when hit this bug upon the first call to
this function).

In order to avoid writing kernel memory from VDSO code,
I copied the original function and added lockdep annotation.

---------- locktest.c (V2) start ----------
#include <linux/module.h>
#include <linux/seqlock.h>
#include <linux/lglock.h>
#include <linux/proc_fs.h>

static seqlock_t seqlock1;
static DEFINE_BRLOCK(brlock1);

static __always_inline unsigned read_seqbegin2(seqlock_t *sl)
{
	unsigned ret;

	spin_acquire(&sl->lock.dep_map, 0, 0, _RET_IP_);
repeat:
	ret = sl->sequence;
	smp_rmb();
	if (unlikely(ret & 1)) {
		cpu_relax();
		goto repeat;
	}
	return ret;
}

static __always_inline int read_seqretry2(seqlock_t *sl, unsigned start)
{
	smp_rmb();
	spin_release(&sl->lock.dep_map, 1, _RET_IP_);
	return unlikely(sl->sequence != start);
}

static int locktest_open1(struct inode *inode, struct file *file)
{
	write_seqlock(&seqlock1);
	msleep(1000); /* Open /proc/locktest2 while sleeping here. */
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
	static DEFINE_MUTEX(mutex1);
	mutex_lock(&mutex1);
	locktest_open1(inode, file);
	mutex_unlock(&mutex1);
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
	return 0;
}

static void __exit locktest_exit(void)
{
	remove_proc_entry("locktest1", NULL);
	remove_proc_entry("locktest2", NULL);
	remove_proc_entry("locktest3", NULL);
}

module_init(locktest_init);
module_exit(locktest_exit);
MODULE_LICENSE("GPL");
---------- locktest.c (V2) end ----------

(... well, I wonder calling spin_release() from read_seqretry2() makes sense
 because it is legal to call it like

  while (1) {
    seq = read_seqbegin();
    do_something();
    if (read_seqretry(seq))
       continue;
    do_something_else();
    if (!read_seqretry(seq))
       break;
  }

 whereas it is illegal for read_unlock()...)

But the result was same.
"cat /proc/locktest1 /proc/locktest2" showed nothing in dmesg whereas
"cat /proc/locktest2 /proc/locktest1" showed below message.

[  221.461750] 
[  221.461752] =======================================================
[  221.464593] [ INFO: possible circular locking dependency detected ]
[  221.465538] 2.6.39-rc1-ccs #1
[  221.465538] -------------------------------------------------------
[  221.465538] cat/3313 is trying to acquire lock:
[  221.465538]  (brlock1_lock_dep_map){++++..}, at: [<e08540b0>] brlock1_local_lock+0x0/0x90 [locktest]
[  221.465538] 
[  221.465538] but task is already holding lock:
[  221.465538]  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e08544dd>] locktest_open1+0xd/0x40 [locktest]
[  221.465538] 
[  221.465538] which lock already depends on the new lock.
[  221.465538] 
[  221.465538] 
[  221.465538] the existing dependency chain (in reverse order) is:
[  221.465538] 
[  221.465538] -> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
[  221.465538]        [<c106c58b>] check_prevs_add+0xab/0x100
[  221.465538]        [<c106c915>] validate_chain+0x305/0x5a0
[  221.465538]        [<c106ea14>] __lock_acquire+0x2a4/0x900
[  221.465538]        [<c107011a>] lock_acquire+0x7a/0xa0
[  221.465538]        [<e0854546>] locktest_open2+0x36/0x70 [locktest]
[  221.465538]        [<c1118585>] proc_reg_open+0x65/0xe0
[  221.465538]        [<c10ce90f>] __dentry_open+0x16f/0x2e0
[  221.465538]        [<c10ceb7e>] nameidata_to_filp+0x5e/0x70
[  221.465538]        [<c10dc358>] do_last+0xf8/0x6c0
[  221.465538]        [<c10dc9c6>] path_openat+0xa6/0x340
[  221.465538]        [<c10dccd4>] do_filp_open+0x74/0x80
[  221.465538]        [<c10cf121>] do_sys_open+0x101/0x1a0
[  221.465538]        [<c10cf1e9>] sys_open+0x29/0x40
[  221.465538]        [<c13b4951>] syscall_call+0x7/0xb
[  221.465538] 
[  221.465538] -> #0 (brlock1_lock_dep_map){++++..}:
[  221.465538]        [<c106c448>] check_prev_add+0x768/0x800
[  221.465538]        [<c106c58b>] check_prevs_add+0xab/0x100
[  221.465538]        [<c106c915>] validate_chain+0x305/0x5a0
[  221.465538]        [<c106ea14>] __lock_acquire+0x2a4/0x900
[  221.465538]        [<c107011a>] lock_acquire+0x7a/0xa0
[  221.465538]        [<e08540e3>] brlock1_local_lock+0x33/0x90 [locktest]
[  221.465538]        [<e08544f2>] locktest_open1+0x22/0x40 [locktest]
[  221.465538]        [<c1118585>] proc_reg_open+0x65/0xe0
[  221.465538]        [<c10ce90f>] __dentry_open+0x16f/0x2e0
[  221.465538]        [<c10ceb7e>] nameidata_to_filp+0x5e/0x70
[  221.465538]        [<c10dc358>] do_last+0xf8/0x6c0
[  221.465538]        [<c10dc9c6>] path_openat+0xa6/0x340
[  221.465538]        [<c10dccd4>] do_filp_open+0x74/0x80
[  221.465538]        [<c10cf121>] do_sys_open+0x101/0x1a0
[  221.465538]        [<c10cf1e9>] sys_open+0x29/0x40
[  221.465538]        [<c13b4951>] syscall_call+0x7/0xb
[  221.465538] 
[  221.465538] other info that might help us debug this:
[  221.465538] 
[  221.465538] 1 lock held by cat/3313:
[  221.465538]  #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e08544dd>] locktest_open1+0xd/0x40 [locktest]
[  221.465538] 
[  221.465538] stack backtrace:
[  221.465538] Pid: 3313, comm: cat Not tainted 2.6.39-rc1-ccs #1
[  221.465538] Call Trace:
[  221.465538]  [<c106af56>] print_circular_bug+0xc6/0xd0
[  221.465538]  [<c106c448>] check_prev_add+0x768/0x800
[  221.465538]  [<c107d44b>] ? __module_text_address+0xb/0x50
[  221.465538]  [<c1005d3b>] ? print_context_stack+0x3b/0xa0
[  221.465538]  [<c106c58b>] check_prevs_add+0xab/0x100
[  221.465538]  [<c106c915>] validate_chain+0x305/0x5a0
[  221.465538]  [<c106e06c>] ? mark_lock+0x21c/0x3c0
[  221.465538]  [<c106ea14>] __lock_acquire+0x2a4/0x900
[  221.465538]  [<c1049fed>] ? destroy_timer_on_stack+0xd/0x10
[  221.465538]  [<c13b22b6>] ? schedule_timeout+0xf6/0x1b0
[  221.465538]  [<c107011a>] lock_acquire+0x7a/0xa0
[  221.465538]  [<e08540b0>] ? brlock1_lock_init+0xb0/0xb0 [locktest]
[  221.465538]  [<e08544d0>] ? brlock1_global_unlock+0xa0/0xa0 [locktest]
[  221.465538]  [<e08540e3>] brlock1_local_lock+0x33/0x90 [locktest]
[  221.465538]  [<e08540b0>] ? brlock1_lock_init+0xb0/0xb0 [locktest]
[  221.465538]  [<c104ae45>] ? msleep+0x15/0x20
[  221.465538]  [<e08544f2>] locktest_open1+0x22/0x40 [locktest]
[  221.465538]  [<c1118585>] proc_reg_open+0x65/0xe0
[  221.465538]  [<c10ce90f>] __dentry_open+0x16f/0x2e0
[  221.465538]  [<c10ceb7e>] nameidata_to_filp+0x5e/0x70
[  221.465538]  [<c1118520>] ? proc_reg_mmap+0x80/0x80
[  221.465538]  [<c10dc358>] do_last+0xf8/0x6c0
[  221.465538]  [<c10dc9c6>] path_openat+0xa6/0x340
[  221.465538]  [<c106d8db>] ? trace_hardirqs_off+0xb/0x10
[  221.465538]  [<c10dccd4>] do_filp_open+0x74/0x80
[  221.465538]  [<c13b3fed>] ? _raw_spin_unlock+0x1d/0x20
[  221.465538]  [<c10ea091>] ? alloc_fd+0xe1/0x1a0
[  221.465538]  [<c10cf121>] do_sys_open+0x101/0x1a0
[  221.465538]  [<c10cfe2b>] ? vfs_write+0x10b/0x130
[  221.465538]  [<c10cf1e9>] sys_open+0x29/0x40
[  221.465538]  [<c13b4951>] syscall_call+0x7/0xb

If lockdep is doing a full analysis on every addition, why lockdep can't catch
"cat /proc/locktest1 /proc/locktest2" case? (I think the answer is either
"annotation I added to read_seqbegin2()/read_seqretry2() is wrong" or
"lockdep cannot do full analysis on some cases".)

Regards.
