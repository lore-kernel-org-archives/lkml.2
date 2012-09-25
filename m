Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2IYKRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:17:43 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34731 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2IYKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:17:41 -0400
Date: Tue, 25 Sep 2012 15:11:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: possible recursive locking in numasched code
Message-ID: <20120925094157.GD18334@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092510-7408-0000-0000-000008C6B105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

While running tests with patches for sched-numa rewrite posted at 
http://permalink.gmane.org/gmane.linux.kernel/1335968, I 
came across a possible recursive locking scenaio. 

Please see approaches and a possible patch to avoid the same.
 
 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.6.0-rc1-numasched_v2_100912+ #2 Not tainted
 -------------------------------------------------------
 gzip/54680 is trying to acquire lock:
 (&p->pi_lock){-.-.-.}, at: [<ffffffff81078b08>] task_work_add+0x38/0xb0
 
 but task is already holding lock:
 (&rq->lock){-.-.-.}, at: [<ffffffff8108e203>] scheduler_tick+0x53/0x150
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (&rq->lock){-.-.-.}:
       [<ffffffff810be782>] lock_acquire+0xa2/0x130
       [<ffffffff81551866>] _raw_spin_lock+0x36/0x70
       [<ffffffff810903c7>] wake_up_new_task+0xa7/0x1c0
       [<ffffffff8105259b>] do_fork+0xcb/0x380
       [<ffffffff8101cef6>] kernel_thread+0x76/0x80
       [<ffffffff81535036>] rest_init+0x26/0x160
       [<ffffffff81ca6d93>] start_kernel+0x3b6/0x3c3
       [<ffffffff81ca6356>] x86_64_start_reservations+0x131/0x136
       [<ffffffff81ca645e>] x86_64_start_kernel+0x103/0x112
 
 -> #0 (&p->pi_lock){-.-.-.}:
       [<ffffffff810be478>] __lock_acquire+0x1428/0x1690
       [<ffffffff810be782>] lock_acquire+0xa2/0x130
       [<ffffffff81551a15>] _raw_spin_lock_irqsave+0x55/0xa0
       [<ffffffff81078b08>] task_work_add+0x38/0xb0
       [<ffffffff8109920f>] task_tick_numa+0xcf/0xe0
       [<ffffffff81099fb9>] task_tick_fair+0x129/0x160
       [<ffffffff8108e28e>] scheduler_tick+0xde/0x150
       [<ffffffff81064dfe>] update_process_times+0x6e/0x90
       [<ffffffff810b68d6>] tick_sched_timer+0x76/0xe0
       [<ffffffff81084ec8>] __run_hrtimer+0x78/0x1b0
       [<ffffffff810852a6>] hrtimer_interrupt+0x106/0x280
       [<ffffffff8155cc39>] smp_apic_timer_interrupt+0x69/0x99
       [<ffffffff8155bb2f>] apic_timer_interrupt+0x6f/0x80
 
 other info that might help us debug this:
 
 Possible unsafe locking scenario:
 
       CPU0                    CPU1
       ----                    ----
  lock(&rq->lock);
                               lock(&p->pi_lock);
                               lock(&rq->lock);
  lock(&p->pi_lock);
 
 *** DEADLOCK ***
 
 1 lock held by gzip/54680:
 #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8108e203>] scheduler_tick+0x53/0x150
 
 stack backtrace:
 Pid: 54680, comm: gzip Not tainted 3.6.0-rc1-numasched_v2_100912+ #2
 Call Trace:
 <IRQ>  [<ffffffff810bbc6a>] print_circular_bug+0x21a/0x2f0
 [<ffffffff810be478>] __lock_acquire+0x1428/0x1690
 [<ffffffff81096ab8>] ? sched_clock_cpu+0xb8/0x110
 [<ffffffff810be782>] lock_acquire+0xa2/0x130
 [<ffffffff81078b08>] ? task_work_add+0x38/0xb0
 [<ffffffff81096b7f>] ? local_clock+0x6f/0x80
 [<ffffffff81551a15>] _raw_spin_lock_irqsave+0x55/0xa0
 [<ffffffff81078b08>] ? task_work_add+0x38/0xb0
 [<ffffffff81078b08>] task_work_add+0x38/0xb0
 [<ffffffff8109920f>] task_tick_numa+0xcf/0xe0
 [<ffffffff81099fb9>] task_tick_fair+0x129/0x160
 [<ffffffff8108e28e>] scheduler_tick+0xde/0x150
 [<ffffffff81064dfe>] update_process_times+0x6e/0x90
 [<ffffffff810b68d6>] tick_sched_timer+0x76/0xe0
 [<ffffffff81084ec8>] __run_hrtimer+0x78/0x1b0
 [<ffffffff810b6860>] ? tick_setup_sched_timer+0x100/0x100
 [<ffffffff810852a6>] hrtimer_interrupt+0x106/0x280
 [<ffffffff8155cc39>] smp_apic_timer_interrupt+0x69/0x99
 [<ffffffff8155bb2f>] apic_timer_interrupt+0x6f/0x80
 <EOI>  [<ffffffff81552595>] ? retint_swapgs+0x13/0x1b



So its clear that we are calling task_work_add from scheduler_tick.
scheduler_tick has already taken rq->lock  and task_work_add needs to take
the same rq->lock.

I figured out that this deadlock can be resolved in more than one way.
1. Add a new callback in sched_class. 
	May be the cleanest but not sure if its worth adding a callback just
for sched class.

2. Have a modified task_work_add that assumes rq->lock is already taken.
	We have to export such an interface and that seems risky if somebody
unknowingly uses such an interface instead of main interface.

3. Move the task_tick_numa to sleep/wakeup.
	Not sure about the overheads.

4. Move the call to task_tick_numa to outside the rq->lock.
	Not a clean approach as in we end up calling a sched/fair.c defined
function in sched/core.c explicitly.

The below patch tries to implement 4th approach. 

---
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 02:37:55 -0700
Subject: [PATCH] Dont call task_tick_numa while holding the rq->lock

task_tick_numa() calls task_work_add() which also needs rq->lock.
However task_tick_numa() gets called under rq->lock. This leads to 
recursive locking. Avoid recursive locking by calling task_tick_numa()
outside the rq->lock.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 87b4601..5d496be 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3236,6 +3236,9 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
+	if (sched_feat_numa(NUMA) && curr->sched_class == &fair_sched_class)
+		task_tick_numa(rq, curr);
+
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 85c8fb7..5f594a5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5417,8 +5417,6 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		entity_tick(cfs_rq, se, queued);
 	}
 
-	if (sched_feat_numa(NUMA))
-		task_tick_numa(rq, curr);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index deff28e..e4ea589 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -913,6 +913,7 @@ extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
 extern void update_idle_cpu_load(struct rq *this_rq);
+extern void task_tick_numa(struct rq *rq, struct task_struct *curr);
 
 #ifdef CONFIG_CGROUP_CPUACCT
 #include <linux/cgroup.h>

