Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590Ab2J2UjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:39:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab2J2Uiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:55 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5U5zc0_H5bAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Sbqno787VVwA:10 a=pGLkceISAAAA:8 a=Y_cBV_yHcS7a025lPygA:9 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203851.331629432@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 32/32] nohz, not for merge: Add tickless tracing
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0032-nohz-not-for-merge-Add-tickless-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

add hoc tickless tracing

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/smp.c    |    2 ++
 kernel/cpuset.c          |    1 +
 kernel/time/tick-sched.c |    7 +++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 0bad72d..45f2176 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -264,6 +264,7 @@ finish:
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	trace_printk("IPI: Scheduler\n");
 	inc_irq_stat(irq_resched_count);
 	scheduler_ipi();
 	/*
@@ -276,6 +277,7 @@ void smp_cpuset_update_nohz_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_printk("IPI: Nohz update\n");
 	tick_nohz_check_adaptive();
 	inc_irq_stat(irq_call_count);
 	irq_exit();
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 218abc8..84f099c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1212,6 +1212,7 @@ static cpumask_t nohz_cpuset_mask;
 
 static void flush_cputime_interrupt(void *unused)
 {
+	trace_printk("IPI: flush cputime\n");
 	tick_nohz_flush_current_times(false);
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bdd40bb..db19c2d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -376,6 +376,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		if (!ts->tick_stopped) {
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
+			trace_printk("Stop tick\n");
 		}
 
 		/*
@@ -581,6 +582,7 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 
 		ts->saved_jiffies = jiffies;
 		set_thread_flag(TIF_NOHZ);
+		trace_printk("set TIF_NOHZ\n");
 	}
 }
 #else
@@ -659,6 +661,7 @@ static void __tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	ts->idle_exittime = now;
 
 	tick_nohz_restart(ts, now);
+	trace_printk("Restart sched tick\n");
 }
 
 /**
@@ -1012,6 +1015,7 @@ static void tick_nohz_restart_adaptive(void)
 	tick_nohz_flush_current_times(true);
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
+	trace_printk("clear TIF_NOHZ\n");
 	tick_nohz_cpu_exit_qs();
 }
 
@@ -1031,6 +1035,7 @@ void cpuset_exit_nohz_interrupt(void *unused)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
+	trace_printk("IPI: Nohz exit\n");
 	if (ts->tick_stopped && !is_idle_task(current))
 		tick_nohz_restart_adaptive();
 }
@@ -1052,6 +1057,7 @@ void tick_nohz_pre_schedule(void)
 	if (test_thread_flag(TIF_NOHZ)) {
 		tick_nohz_flush_current_times(true);
 		clear_thread_flag(TIF_NOHZ);
+		trace_printk("clear TIF_NOHZ\n");
 		/* FIXME: warn if we are in RCU idle mode */
 	}
 }
@@ -1147,6 +1153,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		}
 		update_process_times(user);
 		profile_tick(CPU_PROFILING);
+		trace_printk("tick\n");
 	}
 
 	hrtimer_forward(timer, now, tick_period);
-- 
1.7.10.4


