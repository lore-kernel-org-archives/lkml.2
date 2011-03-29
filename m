Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1C2EbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:31:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55375 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1C2EbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:31:05 -0400
X-Nat-Received: from [202.181.97.72]:62967 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1301373043.16619
Message-Id: <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: rostedt@goodmis.org
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Mar 2011 13:30:43 +0900
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp> <20110328171217.GA8529@home.goodmis.org>
In-Reply-To: <20110328171217.GA8529@home.goodmis.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 29032011 #5160140, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a small test module (which should work on 2.6.38.2).

---------- locktest.c start ----------
#include <linux/module.h>
#include <linux/seqlock.h>
#include <linux/lglock.h>
#include <linux/proc_fs.h>

static seqlock_t seqlock1;
static DEFINE_BRLOCK(brlock1);

static unsigned int read_seqbegin2(seqlock_t *sl)
{
	unsigned int ret;
#if 1
	unsigned long flags;
	spin_lock_irqsave(&sl->lock, flags);
	spin_unlock_irqrestore(&sl->lock, flags);
#endif
repeat:
	ret = sl->sequence;
	smp_rmb();
	if (unlikely(ret & 1)) {
		cpu_relax();
		goto repeat;
	}
	return ret;
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
	br_write_lock(brlock1);
	read_seqbegin2(&seqlock1);
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
---------- locktest.c end ----------
---------- Makefile start ----------
obj-m += locktest.o
---------- Makefile end ----------

Below are my testcases and results (gcc 3.3 / x86_32).
Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.38.2 .

---------- Testcase 1 ----------

# cat /proc/locktest1
# cat /proc/locktest2
# cat /proc/locktest1
# cat /proc/locktest2
# cat /proc/locktest1
# cat /proc/locktest2

showed nothing in dmesg.

---------- Testcase 2 ----------

# cat /proc/locktest1
# cat /proc/locktest2
# cat /proc/locktest3

showed below message.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.38.2 #1
-------------------------------------------------------
cat/2892 is trying to acquire lock:
 (brlock1_lock_dep_map){++++..}, at: [<e08440b0>] brlock1_local_lock+0x0/0x90 [locktest]

but task is already holding lock:
 (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e084451d>] locktest_open1+0xd/0x40 [locktest]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
       [<c106b62b>] check_prevs_add+0xab/0x100
       [<c106b9b5>] validate_chain+0x305/0x5a0
       [<c106dab4>] __lock_acquire+0x2a4/0x900
       [<c106f1ba>] lock_acquire+0x7a/0xa0
       [<c13a83e4>] _raw_spin_lock_irqsave+0x44/0x80
       [<e08444e9>] read_seqbegin2+0x19/0x40 [locktest]
       [<e0844562>] locktest_open2+0x12/0x20 [locktest]
       [<c1113f95>] proc_reg_open+0x65/0xe0
       [<c10caf2b>] __dentry_open+0xbb/0x2a0
       [<c10cb20e>] nameidata_to_filp+0x5e/0x70
       [<c10d8207>] finish_open+0x77/0xf0
       [<c10d86e9>] do_filp_open+0x1a9/0x5c0
       [<c10cb50c>] do_sys_open+0x5c/0xe0
       [<c10cb5b9>] sys_open+0x29/0x40
       [<c13a8f81>] syscall_call+0x7/0xb

-> #0 (brlock1_lock_dep_map){++++..}:
       [<c106b4e8>] check_prev_add+0x768/0x800
       [<c106b62b>] check_prevs_add+0xab/0x100
       [<c106b9b5>] validate_chain+0x305/0x5a0
       [<c106dab4>] __lock_acquire+0x2a4/0x900
       [<c106f1ba>] lock_acquire+0x7a/0xa0
       [<e08440e3>] brlock1_local_lock+0x33/0x90 [locktest]
       [<e0844532>] locktest_open1+0x22/0x40 [locktest]
       [<e0844596>] locktest_open3+0x26/0x50 [locktest]
       [<c1113f95>] proc_reg_open+0x65/0xe0
       [<c10caf2b>] __dentry_open+0xbb/0x2a0
       [<c10cb20e>] nameidata_to_filp+0x5e/0x70
       [<c10d8207>] finish_open+0x77/0xf0
       [<c10d86e9>] do_filp_open+0x1a9/0x5c0
       [<c10cb50c>] do_sys_open+0x5c/0xe0
       [<c10cb5b9>] sys_open+0x29/0x40
       [<c13a8f81>] syscall_call+0x7/0xb

other info that might help us debug this:

2 locks held by cat/2892:
 #0:  (mutex1){+.+...}, at: [<e084458d>] locktest_open3+0x1d/0x50 [locktest]
 #1:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e084451d>] locktest_open1+0xd/0x40 [locktest]

stack backtrace:
Pid: 2892, comm: cat Not tainted 2.6.38.2 #1
Call Trace:
 [<c1069ff6>] ? print_circular_bug+0xc6/0xd0
 [<c106b4e8>] ? check_prev_add+0x768/0x800
 [<c106b62b>] ? check_prevs_add+0xab/0x100
 [<c106b9b5>] ? validate_chain+0x305/0x5a0
 [<c106dab4>] ? __lock_acquire+0x2a4/0x900
 [<c104a0ed>] ? destroy_timer_on_stack+0xd/0x10
 [<c13a6776>] ? schedule_timeout+0xf6/0x1b0
 [<c106f1ba>] ? lock_acquire+0x7a/0xa0
 [<e08440b0>] ? brlock1_local_lock+0x0/0x90 [locktest]
 [<e0844570>] ? locktest_open3+0x0/0x50 [locktest]
 [<e08440e3>] ? brlock1_local_lock+0x33/0x90 [locktest]
 [<e08440b0>] ? brlock1_local_lock+0x0/0x90 [locktest]
 [<c104af75>] ? msleep+0x15/0x20
 [<e0844532>] ? locktest_open1+0x22/0x40 [locktest]
 [<e0844596>] ? locktest_open3+0x26/0x50 [locktest]
 [<c1113f95>] ? proc_reg_open+0x65/0xe0
 [<c10caf2b>] ? __dentry_open+0xbb/0x2a0
 [<c10cb20e>] ? nameidata_to_filp+0x5e/0x70
 [<c1113f30>] ? proc_reg_open+0x0/0xe0
 [<c10d8207>] ? finish_open+0x77/0xf0
 [<c10d86e9>] ? do_filp_open+0x1a9/0x5c0
 [<c106c97b>] ? trace_hardirqs_off+0xb/0x10
 [<c13a853d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e5d81>] ? alloc_fd+0xe1/0x1a0
 [<c10cb50c>] ? do_sys_open+0x5c/0xe0
 [<c10cb5b9>] ? sys_open+0x29/0x40
 [<c13a8f81>] ? syscall_call+0x7/0xb

---------- Testcase 3 ----------

# cat /proc/locktest2
# cat /proc/locktest1

showed below message.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.38.2 #1
-------------------------------------------------------
cat/2891 is trying to acquire lock:
 (brlock1_lock_dep_map){++++..}, at: [<e08440b0>] brlock1_local_lock+0x0/0x90 [locktest]

but task is already holding lock:
 (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e084451d>] locktest_open1+0xd/0x40 [locktest]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
       [<c106b62b>] check_prevs_add+0xab/0x100
       [<c106b9b5>] validate_chain+0x305/0x5a0
       [<c106dab4>] __lock_acquire+0x2a4/0x900
       [<c106f1ba>] lock_acquire+0x7a/0xa0
       [<c13a83e4>] _raw_spin_lock_irqsave+0x44/0x80
       [<e08444e9>] read_seqbegin2+0x19/0x40 [locktest]
       [<e0844562>] locktest_open2+0x12/0x20 [locktest]
       [<c1113f95>] proc_reg_open+0x65/0xe0
       [<c10caf2b>] __dentry_open+0xbb/0x2a0
       [<c10cb20e>] nameidata_to_filp+0x5e/0x70
       [<c10d8207>] finish_open+0x77/0xf0
       [<c10d86e9>] do_filp_open+0x1a9/0x5c0
       [<c10cb50c>] do_sys_open+0x5c/0xe0
       [<c10cb5b9>] sys_open+0x29/0x40
       [<c13a8f81>] syscall_call+0x7/0xb

-> #0 (brlock1_lock_dep_map){++++..}:
       [<c106b4e8>] check_prev_add+0x768/0x800
       [<c106b62b>] check_prevs_add+0xab/0x100
       [<c106b9b5>] validate_chain+0x305/0x5a0
       [<c106dab4>] __lock_acquire+0x2a4/0x900
       [<c106f1ba>] lock_acquire+0x7a/0xa0
       [<e08440e3>] brlock1_local_lock+0x33/0x90 [locktest]
       [<e0844532>] locktest_open1+0x22/0x40 [locktest]
       [<c1113f95>] proc_reg_open+0x65/0xe0
       [<c10caf2b>] __dentry_open+0xbb/0x2a0
       [<c10cb20e>] nameidata_to_filp+0x5e/0x70
       [<c10d8207>] finish_open+0x77/0xf0
       [<c10d86e9>] do_filp_open+0x1a9/0x5c0
       [<c10cb50c>] do_sys_open+0x5c/0xe0
       [<c10cb5b9>] sys_open+0x29/0x40
       [<c13a8f81>] syscall_call+0x7/0xb

other info that might help us debug this:

1 lock held by cat/2891:
 #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e084451d>] locktest_open1+0xd/0x40 [locktest]

stack backtrace:
Pid: 2891, comm: cat Not tainted 2.6.38.2 #1
Call Trace:
 [<c1069ff6>] ? print_circular_bug+0xc6/0xd0
 [<c106b4e8>] ? check_prev_add+0x768/0x800
 [<c100590e>] ? dump_trace+0x5e/0xd0
 [<c106b62b>] ? check_prevs_add+0xab/0x100
 [<c106b9b5>] ? validate_chain+0x305/0x5a0
 [<c106d10c>] ? mark_lock+0x21c/0x3c0
 [<c106dab4>] ? __lock_acquire+0x2a4/0x900
 [<c104a0ed>] ? destroy_timer_on_stack+0xd/0x10
 [<c13a6776>] ? schedule_timeout+0xf6/0x1b0
 [<c106f1ba>] ? lock_acquire+0x7a/0xa0
 [<e08440b0>] ? brlock1_local_lock+0x0/0x90 [locktest]
 [<e0844510>] ? locktest_open1+0x0/0x40 [locktest]
 [<e08440e3>] ? brlock1_local_lock+0x33/0x90 [locktest]
 [<e08440b0>] ? brlock1_local_lock+0x0/0x90 [locktest]
 [<c104af75>] ? msleep+0x15/0x20
 [<e0844532>] ? locktest_open1+0x22/0x40 [locktest]
 [<c1113f95>] ? proc_reg_open+0x65/0xe0
 [<c10caf2b>] ? __dentry_open+0xbb/0x2a0
 [<c10cb20e>] ? nameidata_to_filp+0x5e/0x70
 [<c1113f30>] ? proc_reg_open+0x0/0xe0
 [<c10d8207>] ? finish_open+0x77/0xf0
 [<c10d86e9>] ? do_filp_open+0x1a9/0x5c0
 [<c106c97b>] ? trace_hardirqs_off+0xb/0x10
 [<c13a853d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e5d81>] ? alloc_fd+0xe1/0x1a0
 [<c10cb50c>] ? do_sys_open+0x5c/0xe0
 [<c10cb5b9>] ? sys_open+0x29/0x40
 [<c13a8f81>] ? syscall_call+0x7/0xb

---------- Testcase 4 ----------

Starting

# cat /proc/locktest1

 from one terminal and starting

# cat /proc/locktest2

(before "cat /proc/locktest1" finishes) from another terminal
showed below message.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.38.2 #1
-------------------------------------------------------
cat/2893 is trying to acquire lock:
 (brlock1_lock_dep_map){++++..}, at: [<e08440b0>] brlock1_local_lock+0x0/0x90 [locktest]

but task is already holding lock:
 (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e084451d>] locktest_open1+0xd/0x40 [locktest]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
       [<c106b62b>] check_prevs_add+0xab/0x100
       [<c106b9b5>] validate_chain+0x305/0x5a0
       [<c106dab4>] __lock_acquire+0x2a4/0x900
       [<c106f1ba>] lock_acquire+0x7a/0xa0
       [<c13a83e4>] _raw_spin_lock_irqsave+0x44/0x80
       [<e08444e9>] read_seqbegin2+0x19/0x40 [locktest]
       [<e0844562>] locktest_open2+0x12/0x20 [locktest]
       [<c1113f95>] proc_reg_open+0x65/0xe0
       [<c10caf2b>] __dentry_open+0xbb/0x2a0
       [<c10cb20e>] nameidata_to_filp+0x5e/0x70
       [<c10d8207>] finish_open+0x77/0xf0
       [<c10d86e9>] do_filp_open+0x1a9/0x5c0
       [<c10cb50c>] do_sys_open+0x5c/0xe0
       [<c10cb5b9>] sys_open+0x29/0x40
       [<c13a8f81>] syscall_call+0x7/0xb

-> #0 (brlock1_lock_dep_map){++++..}:
       [<c106b4e8>] check_prev_add+0x768/0x800
       [<c106b62b>] check_prevs_add+0xab/0x100
       [<c106b9b5>] validate_chain+0x305/0x5a0
       [<c106dab4>] __lock_acquire+0x2a4/0x900
       [<c106f1ba>] lock_acquire+0x7a/0xa0
       [<e08440e3>] brlock1_local_lock+0x33/0x90 [locktest]
       [<e0844532>] locktest_open1+0x22/0x40 [locktest]
       [<c1113f95>] proc_reg_open+0x65/0xe0
       [<c10caf2b>] __dentry_open+0xbb/0x2a0
       [<c10cb20e>] nameidata_to_filp+0x5e/0x70
       [<c10d8207>] finish_open+0x77/0xf0
       [<c10d86e9>] do_filp_open+0x1a9/0x5c0
       [<c10cb50c>] do_sys_open+0x5c/0xe0
       [<c10cb5b9>] sys_open+0x29/0x40
       [<c13a8f81>] syscall_call+0x7/0xb

other info that might help us debug this:

1 lock held by cat/2893:
 #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e084451d>] locktest_open1+0xd/0x40 [locktest]

stack backtrace:
Pid: 2893, comm: cat Not tainted 2.6.38.2 #1
Call Trace:
 [<c1069ff6>] ? print_circular_bug+0xc6/0xd0
 [<c106b4e8>] ? check_prev_add+0x768/0x800
 [<c100590e>] ? dump_trace+0x5e/0xd0
 [<c106b62b>] ? check_prevs_add+0xab/0x100
 [<c106b9b5>] ? validate_chain+0x305/0x5a0
 [<c106d10c>] ? mark_lock+0x21c/0x3c0
 [<c106dab4>] ? __lock_acquire+0x2a4/0x900
 [<c104a0ed>] ? destroy_timer_on_stack+0xd/0x10
 [<c13a6776>] ? schedule_timeout+0xf6/0x1b0
 [<c106f1ba>] ? lock_acquire+0x7a/0xa0
 [<e08440b0>] ? brlock1_local_lock+0x0/0x90 [locktest]
 [<e0844510>] ? locktest_open1+0x0/0x40 [locktest]
 [<e08440e3>] ? brlock1_local_lock+0x33/0x90 [locktest]
 [<e08440b0>] ? brlock1_local_lock+0x0/0x90 [locktest]
 [<c104af75>] ? msleep+0x15/0x20
 [<e0844532>] ? locktest_open1+0x22/0x40 [locktest]
 [<c1113f95>] ? proc_reg_open+0x65/0xe0
 [<c10caf2b>] ? __dentry_open+0xbb/0x2a0
 [<c10cb20e>] ? nameidata_to_filp+0x5e/0x70
 [<c1113f30>] ? proc_reg_open+0x0/0xe0
 [<c10d8207>] ? finish_open+0x77/0xf0
 [<c10d86e9>] ? do_filp_open+0x1a9/0x5c0
 [<c106c97b>] ? trace_hardirqs_off+0xb/0x10
 [<c13a853d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e5d81>] ? alloc_fd+0xe1/0x1a0
 [<c10cb50c>] ? do_sys_open+0x5c/0xe0
 [<c10cb5b9>] ? sys_open+0x29/0x40
 [<c13a8f81>] ? syscall_call+0x7/0xb
BUG: spinlock lockup on CPU#1, cat/2894, e0844a44
Pid: 2894, comm: cat Not tainted 2.6.38.2 #1
Call Trace:
 [<c11e7d8a>] ? __spin_lock_debug+0xca/0xf0
 [<c11e7e19>] ? do_raw_spin_lock+0x69/0xa0
 [<c13a8419>] ? _raw_spin_lock_irqsave+0x79/0x80
 [<e08444e9>] ? read_seqbegin2+0x19/0x40 [locktest]
 [<e0844550>] ? locktest_open2+0x0/0x20 [locktest]
 [<e08444e9>] ? read_seqbegin2+0x19/0x40 [locktest]
 [<e0844562>] ? locktest_open2+0x12/0x20 [locktest]
 [<c1113f95>] ? proc_reg_open+0x65/0xe0
 [<c10caf2b>] ? __dentry_open+0xbb/0x2a0
 [<c10cb20e>] ? nameidata_to_filp+0x5e/0x70
 [<c1113f30>] ? proc_reg_open+0x0/0xe0
 [<c10d8207>] ? finish_open+0x77/0xf0
 [<c10d86e9>] ? do_filp_open+0x1a9/0x5c0
 [<c106c97b>] ? trace_hardirqs_off+0xb/0x10
 [<c13a853d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e5d81>] ? alloc_fd+0xe1/0x1a0
 [<c10cb50c>] ? do_sys_open+0x5c/0xe0
 [<c10cb5b9>] ? sys_open+0x29/0x40
 [<c13a8f81>] ? syscall_call+0x7/0xb
sending NMI to all CPUs:
(...snipped...)

---------- Testcase 5 ----------

Using testcase 4, but different result.

BUG: spinlock cpu recursion on CPU#0, cat/2894
 lock: e0844a44, .magic: dead4ead, .owner: cat/2893, .owner_cpu: 0
Pid: 2894, comm: cat Not tainted 2.6.38.2 #1
Call Trace:
 [<c11e7cad>] ? spin_bug+0xad/0xc0
 [<c11e7e27>] ? do_raw_spin_lock+0x77/0xa0
 [<c13a8419>] ? _raw_spin_lock_irqsave+0x79/0x80
 [<e08444e9>] ? read_seqbegin2+0x19/0x40 [locktest]
 [<e0844550>] ? locktest_open2+0x0/0x20 [locktest]
 [<e08444e9>] ? read_seqbegin2+0x19/0x40 [locktest]
 [<e0844562>] ? locktest_open2+0x12/0x20 [locktest]
 [<c1113f95>] ? proc_reg_open+0x65/0xe0
 [<c10caf2b>] ? __dentry_open+0xbb/0x2a0
 [<c10cb20e>] ? nameidata_to_filp+0x5e/0x70
 [<c1113f30>] ? proc_reg_open+0x0/0xe0
 [<c10d8207>] ? finish_open+0x77/0xf0
 [<c10d86e9>] ? do_filp_open+0x1a9/0x5c0
 [<c106c97b>] ? trace_hardirqs_off+0xb/0x10
 [<c13a853d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e5d81>] ? alloc_fd+0xe1/0x1a0
 [<c10cb50c>] ? do_sys_open+0x5c/0xe0
 [<c10cb5b9>] ? sys_open+0x29/0x40
 [<c13a8f81>] ? syscall_call+0x7/0xb

---------- Testcase 6 ----------

Same testcase with 4, but different result.

BUG: spinlock lockup on CPU#0, cat/2894, e0844a44
Pid: 2894, comm: cat Not tainted 2.6.38.2 #1
Call Trace:
 [<c11e7d8a>] ? __spin_lock_debug+0xca/0xf0
 [<c11e7e19>] ? do_raw_spin_lock+0x69/0xa0
 [<c13a8419>] ? _raw_spin_lock_irqsave+0x79/0x80
 [<e08444e9>] ? read_seqbegin2+0x19/0x40 [locktest]
 [<e0844550>] ? locktest_open2+0x0/0x20 [locktest]
 [<e08444e9>] ? read_seqbegin2+0x19/0x40 [locktest]
 [<e0844562>] ? locktest_open2+0x12/0x20 [locktest]
 [<c1113f95>] ? proc_reg_open+0x65/0xe0
 [<c10caf2b>] ? __dentry_open+0xbb/0x2a0
 [<c10cb20e>] ? nameidata_to_filp+0x5e/0x70
 [<c1113f30>] ? proc_reg_open+0x0/0xe0
 [<c10d8207>] ? finish_open+0x77/0xf0
 [<c10d86e9>] ? do_filp_open+0x1a9/0x5c0
 [<c106c97b>] ? trace_hardirqs_off+0xb/0x10
 [<c13a853d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e5d81>] ? alloc_fd+0xe1/0x1a0
 [<c10cb50c>] ? do_sys_open+0x5c/0xe0
 [<c10cb5b9>] ? sys_open+0x29/0x40
 [<c13a8f81>] ? syscall_call+0x7/0xb
sending NMI to all CPUs:
NMI backtrace for cpu 0
(...snipped...)

Well... did I misuse spinlock primitives in read_seqbegin2()?
Anyway, lockdep should catch testcase 1.



Regards.
