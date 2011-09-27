Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1I0VRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:17:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1I0VRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:17:36 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=0tK9wBqmC7MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=ozXGK8X5VLjXXVAG-IEA:9 a=ggHSvTZ4iILDnblmJ1MA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: [PATCH] sched/kthread: Complain loudly when others violate our flags
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 27 Sep 2011 17:17:34 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317158254.26514.55.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For convenience and optimization, we are going to use the task's flag
PF_THREAD_BOUND as a way to know if a task is bound to a CPU or not. As
that is what the flag means.

In the RT kernel we depend greatly on this meaning as it is a way to
know if we should manually bound a task to a CPU or not. But I've spent
the last two days hunting down a bug where things were not working as
they should.

Finally, I added a simple patch to mainline (one I think should be
accepted permanently), the one at the bottom of this email. And it
triggered the following:


------------[ cut here ]------------
WARNING: at /home/rostedt/work/git/linux-trace.git/kernel/sched.c:2236 set_task_cpu+0x137/0x1ba()
Hardware name: Precision WorkStation 470    
Modules linked in:
Pid: 3, comm: ksoftirqd/0 Tainted: G        W   3.1.0-rc7-test+ #262
Call Trace:
 [<ffffffff81051728>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8105175a>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff8104af0f>] set_task_cpu+0x137/0x1ba
 [<ffffffff810824aa>] ? lock_acquire+0x118/0x151
 [<ffffffff8104b846>] ? try_to_wake_up+0x2e/0x1db
 [<ffffffff8104b91d>] try_to_wake_up+0x105/0x1db
 [<ffffffff8103d4ae>] ? complete+0x1e/0x4f
 [<ffffffff8104ba05>] default_wake_function+0x12/0x14
 [<ffffffff8103c1c6>] __wake_up_common+0x4d/0x83
 [<ffffffff8103d4ae>] ? complete+0x1e/0x4f
 [<ffffffff8103d4cc>] complete+0x3c/0x4f
 [<ffffffff81238789>] blk_end_sync_rq+0x31/0x35
 [<ffffffff81238758>] ? blk_rq_map_user+0x210/0x210
 [<ffffffff8123408b>] blk_finish_request+0x206/0x238
 [<ffffffff815022ec>] ? _raw_spin_lock_irqsave+0x51/0x5c
 [<ffffffff812345bf>] ? blk_end_bidi_request+0x32/0x5d
 [<ffffffff812345cd>] blk_end_bidi_request+0x40/0x5d
 [<ffffffff81234624>] blk_end_request+0x10/0x12
 [<ffffffff8131af7b>] scsi_io_completion+0x1dc/0x4d7
 [<ffffffff81312f0c>] scsi_finish_command+0xe4/0xed
 [<ffffffff8131ace2>] scsi_softirq_done+0x109/0x112
 [<ffffffff8123964d>] blk_done_softirq+0x7f/0x93
 [<ffffffff81057c4c>] __do_softirq+0x107/0x24a
 [<ffffffff81057e4a>] run_ksoftirqd+0xbb/0x1b4
 [<ffffffff81057d8f>] ? __do_softirq+0x24a/0x24a
 [<ffffffff8106ea8e>] kthread+0x9f/0xa7
 [<ffffffff81505977>] ? sub_preempt_count+0x95/0xa8
 [<ffffffff8150a084>] kernel_thread_helper+0x4/0x10
 [<ffffffff81502e78>] ? retint_restore_args+0x13/0x13
 [<ffffffff8106e9ef>] ? __init_kthread_worker+0x5a/0x5a
 [<ffffffff8150a080>] ? gs_change+0x13/0x13
---[ end trace 5a5d197966b56a53 ]---
migrating bounded task kworker/u:1:49



I looked at the task that it tried to migrate, and it happened to be the
kworker thread! Then I went into kernel/workqueue.c and found this
nonsense:

	if (bind && !on_unbound_cpu)
		kthread_bind(worker->task, gcwq->cpu);
	else {
		worker->task->flags |= PF_THREAD_BOUND;
		if (on_unbound_cpu)
			worker->flags |= WORKER_UNBOUND;
	}

Nothing but the scheduler and kthread_bind() has the right to set the
PF_THREAD_BOUND flag. Especially when the thread IS NOT BOUNDED!!!!!!

I don't go around and stick my hand down your pants to play with your
flags! Don't stick your hand in ours and play with our flags!

WTF is the workqueue code setting the PF_THREAD_BOUND flag manually?
Talk about fragile coupling! You just made this flag meaningless. Don't
do that.

Sorry but I just wasted two whole days because of this nonsense and I'm
not particularly happy about it.
 
-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..682a90c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2233,6 +2233,9 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	if (task_cpu(p) != new_cpu) {
 		p->se.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
+		if (WARN_ON(p->flags & PF_THREAD_BOUND))
+			printk(KERN_WARNING "migrating bounded task %s:%d\n",
+			       p->comm, p->pid);
 	}
 
 	__set_task_cpu(p, new_cpu);


