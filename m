Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2LTBcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:32:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22527 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2LTBcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:32:01 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MsSuiC2gMRoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=qZZb6xCHB7AA:10 a=SLe34-JDDbhqyDUXE5YA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355967118.5896.52.camel@gandalf.local.home>
Subject: [RFC][PATCH RT] rtmutex: Use raw_spin_trylock() in
 rt_mutex_slowlock() to ease possible live locks
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <cbe@osadl.org>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Mike Galbraith <bitbucket@online.de>
Date: Wed, 19 Dec 2012 20:31:58 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running -rt on a 40 CPU core box, I would every so often hit a lockup in
the file system. Any new access to the file system would also lock up. I
finally triggered this again and did a sysrq-t and sysrq-w to
investigate. What more, the NMI watchdog went off too, and this actually
showed the real bug.

To explain this, lets look at some of the back traces:

ksoftirqd/11    R  running task        0    80      2 0x00000000
Call Trace:
 [<ffffffff8151e8d9>] schedule+0x29/0x70
 [<ffffffff8151f6cd>] rt_spin_lock_slowlock+0x10d/0x310
 [<ffffffff81156d86>] ? kmem_cache_free+0x116/0x2d0
 [<ffffffff8151fec6>] rt_spin_lock+0x26/0x30
 [<ffffffff81239052>] blk_run_queue+0x22/0x50
 [<ffffffff8135a4a3>] scsi_run_queue+0xd3/0x2c0

ksoftirqd/11 is in the running state, and being woken up. It has just
acquired the q->queue_lock in blk_run_queue(). But as it is only the
pending owner, it hasn't had its pi_blocked_on cleared yet.

NMI backtrace for cpu 11
CPU 11 
Pid: 2802, comm: irq/92-hpsa0 Not tainted 3.6.9-rt21+ #12 HP ProLiant DL580 G7
RIP: 0010:[<ffffffff815202b5>]  [<ffffffff815202b5>] _raw_spin_lock_irqsave+0x25/0x40
Process irq/92-hpsa0 (pid: 2802, threadinfo ffff880ffe078000, task ffff880ffe4ec580)
Call Trace:
 [<ffffffff810a170c>] rt_mutex_adjust_prio_chain+0xfc/0x480
 [<ffffffff810a1f65>] task_blocks_on_rt_mutex+0x175/0x280
 [<ffffffff8151f699>] rt_spin_lock_slowlock+0xd9/0x310
 [<ffffffff8151fec6>] rt_spin_lock+0x26/0x30
 [<ffffffff8104e0a2>] do_current_softirqs+0x102/0x350

The irq thread irq/92-hpsa0 running on CPU 11 is in the process of
trying to boost the owner of the softirq, as it just raised the block
softirq which ksoftirqd/11 is running. I let several NMI watchdogs
trigger and this task is in a different location within the
rt_mutex_adjust_prio_chain() code. But always within the retry loop of
taking the task->pi_lock and the trylock of lock->wait_lock.

Note that all tasks that are less than the priority of ksoftirqd/11 can
not steal the q->queue_lock. As ksoftirqd/11 runs at priority 1, that
includes all other ksoftirqds as well as my shell commands. Thus, the
q->queue_lock isn't technically fully held by anyone yet.

Then we have this lovely code:

block/blk-ioc.c: put_io_context_active()

retry:
        spin_lock_irqsave_nested(&ioc->lock, flags, 1);
        hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node) {
                if (icq->flags & ICQ_EXITED)
                        continue;
                if (spin_trylock(icq->q->queue_lock)) {
                        ioc_exit_icq(icq);
                        spin_unlock(icq->q->queue_lock);
                } else {
                        spin_unlock_irqrestore(&ioc->lock, flags);
                        cpu_relax();
                        goto retry;
                }
        }

Where it constantly tries to grab the icq->q->queue_lock, if it fails,
it releases the lock, drops the other icq->lock, and tries again.
There's lots of these in my dump:

Call Trace:
 [<ffffffff810a1571>] rt_mutex_slowtrylock+0x11/0xb0
 [<ffffffff8151f2e8>] rt_mutex_trylock+0x28/0x30
 [<ffffffff8151fdde>] rt_spin_trylock+0xe/0x10
 [<ffffffff812408d1>] put_io_context_active+0x71/0x100
 [<ffffffff812409be>] exit_io_context+0x5e/0x70
 [<ffffffff8104b17d>] do_exit+0x5bd/0x9d0
 [<ffffffff8104b5e8>] do_group_exit+0x58/0xd0

The one thing that caught my eye though, was that the majority of the
time, that rt_mutex_slowtrylock() was here:

rt_mutex_slowtrylock(struct rt_mutex *lock)
{
        int ret = 0;

        raw_spin_lock(&lock->wait_lock);  <<--
        init_lists(lock);


And there were several of these:

Call Trace:
 [<ffffffff8151e8d9>] schedule+0x29/0x70
 [<ffffffff8151f6cd>] rt_spin_lock_slowlock+0x10d/0x310
 [<ffffffff81156d86>] ? kmem_cache_free+0x116/0x2d0
 [<ffffffff8151fec6>] rt_spin_lock+0x26/0x30
 [<ffffffff81239052>] blk_run_queue+0x22/0x50
 [<ffffffff8135a4a3>] scsi_run_queue+0xd3/0x2c0

At various calls that grab the q->queue_lock, not just at
scsi_run_queue() or even blk_run_queue(). But all were blocked on the
q->queue_lock.

Where they were all ksoftirqd/X and stuck at:

                if (top_waiter != &waiter || adaptive_wait(lock, lock_owner))
                        schedule_rt_mutex(lock);

                raw_spin_lock(&lock->wait_lock); <<--

                pi_lock(&self->pi_lock);

Not sure why there were more than one, as the condition above the
schedule_rt_mutex() should only be false for one, if any.

Thus, my theory of the lock up is that each of the raw_spin_lock()s are
ticket locks, and the raw_spin_trylock() will fail if there's any
contention. Which means because of the put_io_context_active() loop
which does the rt_mutex_trylock() will always fail, but because it uses
a normal raw_spin_lock(), it is guaranteed to take the lock->wait_lock
because of the FIFO nature of the ticket spinlock. After it takes the
lock, it will find out that the q->queue_lock is contented, and it can't
steal it, and return. But the irq thread that's trying to boost, and
will not exit till it gets the lock->wait_lock but will be starved by
all the tasks doing the put_io_context_active() loop. The
put_io_context_active() tasks will be constantly fighting over the lock
and never let the irq thread get the lock to finish the boost.

As the irq thread is starved, it wont let the ksoftirqd/11 task run,
which is blocking all the rest. In essence, we have a live lock.

Now, there's two solutions that I can think of:

1) This patch. Which is to make the raw spin lock in the
rt_mutex_trylock into a raw_spin_trylock(). This will make it a bit more
fair among all the looping, but doesn't guarantee that we wont live lock
either. It just doesn't force a live lock as the current code now
stands.

2) A bit more complex. When failing the trylock in the
rt_mutex_adjust_prio_chain(), release the task->pi_lock, grab the
lock->wait_lock directly, followed by the task->pi_lock. Do all the
checks again (the ones between the retry and the trylock), if all is
well, continue on, otherwise drop both locks and retry again.

This is just an RFC patch to start discussion, not for inclusion. I may
send another patch that implements #2 above.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/rtmutex.c
===================================================================
--- linux-rt.git.orig/kernel/rtmutex.c
+++ linux-rt.git/kernel/rtmutex.c
@@ -1044,7 +1044,16 @@ rt_mutex_slowtrylock(struct rt_mutex *lo
 {
 	int ret = 0;
 
-	raw_spin_lock(&lock->wait_lock);
+	/*
+	 * As raw_spin_lock() is FIFO, if the caller is looping
+	 * with a trylock, then it could starve a task doing a priority
+	 * boost, as rt_mutex_adjust_prio_chain() uses trylock
+	 * which is not FIFO. Use a trylock here too. If we
+	 * fail to get the wait_lock, then fail to get the rt_mutex.
+	 */
+	if (!raw_spin_trylock(&lock->wait_lock))
+		return 0;
+
 	init_lists(lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {


