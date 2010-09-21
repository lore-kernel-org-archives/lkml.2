Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0IUOUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:20:30 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:44290 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab0IUOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:20:29 -0400
Date: Tue, 21 Sep 2010 16:20:17 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] timer: fix deadlock on cpu hotplug
Message-ID: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

I've seen the following deadlock on cpu hotplug stress test:

On cpu down the process that triggered offlining of a cpu waits for
stop_machine() to finish:

PID: 56033  TASK: e001540           CPU: 2   COMMAND: "cpu_all_off"
 #0 [37aa7990] schedule at 559194
 #1 [37aa7a40] schedule_timeout at 559de0
 #2 [37aa7b18] wait_for_common at 558bfa
 #3 [37aa7b90] __stop_cpus at 1a876e
 #4 [37aa7c68] stop_cpus at 1a8a3a
 #5 [37aa7c98] __stop_machine at 1a8adc
 #6 [37aa7cf8] _cpu_down at 55007a
 #7 [37aa7d78] cpu_down at 550280
 #8 [37aa7d98] store_online at 551d48
 #9 [37aa7dc0] sysfs_write_file at 2a3fa2
 #10 [37aa7e18] vfs_write at 229b3c
 #11 [37aa7e78] sys_write at 229d38
 #12 [37aa7eb8] sysc_noemu at 1146de

All cpus actually have been synchronized and cpu 0 got offlined. However,
the migration thread on cpu 5 got preempted just between preempt_enable()
and cpu_stop_signal_done() within cpu_stopper_thread():

PID: 55622  TASK: 31a00a40          CPU: 5   COMMAND: "migration/5"
 #0 [30f8bc80] schedule at 559194
 #1 [30f8bd30] preempt_schedule at 559b54
 #2 [30f8bd50] cpu_stopper_thread at 1a81dc
 #3 [30f8be28] kthread at 163224
 #4 [30f8beb8] kernel_thread_starter at 106c1a

For some reason the scheduler decided to throttle RT tasks on the runqueue
of cpu 5 (rt_throttled = 1). So as long as rt_throttled == 1 we won't see the
migration thread coming back to execution.
The only thing that would unthrottle the runqueue would be the rt_period_timer.
The timer is indeed scheduled, however in the dump I have it has been expired
for more than four hours.
The reason is simply that the timer is pending on the offlined cpu 0 and
therefore would never fire before it gets migrated to an online cpu. Before
the cpu hotplug mechanisms (cpu hotplug notifier with state CPU_DEAD) would
migrate the timer to an online cpu stop_machine() must complete ---> deadlock.

The fix _seems_ to be simple: just migrate timers after __cpu_disable() has
been called and use the CPU_DYING state. The subtle difference is of course
that the migration code now gets executed on the cpu that actually just is
going to disable itself instead of an arbitrary cpu that stays online.

This patch moves the migration of pending timers to an earlier time
(CPU_DYING), so that the deadlock described cannot happen anymore.

Up to now the hrtimer migration code called __hrtimer_peek_ahead_timers()
after migrating timers to the _current_ cpu. Now pending timers are moved
to a remote cpu and calling that function isn't possible anymore.
To solve that I introduced the function raise_remote_softirq() which gets
used to raise the HRTIMER_SOFTIRQ on the cpu where the timers have been
migrated to. Which will lead to execution of hrtimer_peek_ahead_timers()
as soon as softirq are executed on the remote cpu.

The proper place for such a generic function should be softirq.c, but this
is just an RFC and I would like to check if people are ok with the general
approach.
Or maybe it's possible to fix this in a better way?

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 kernel/hrtimer.c |   30 +++++++++++++++++++++---------
 kernel/timer.c   |   14 ++++++++------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1decafb..a912585 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1662,17 +1662,32 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	}
 }
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+static void raise_remote_softirq_handler(void *nr)
+{
+	raise_softirq_irqoff((unsigned int)(long)nr);
+}
+
+static void raise_remote_softirq(int cpu, unsigned int nr)
+{
+	smp_call_function_single(cpu, raise_remote_softirq_handler,
+				 (void *)(long) nr, 0);
+}
+#endif
+
 static void migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
+	int dcpu;
 	int i;
 
 	BUG_ON(cpu_online(scpu));
+	BUG_ON(!irqs_disabled());
 	tick_cancel_sched_timer(scpu);
 
-	local_irq_disable();
+	dcpu = any_online_cpu(cpu_online_map);
 	old_base = &per_cpu(hrtimer_bases, scpu);
-	new_base = &__get_cpu_var(hrtimer_bases);
+	new_base = &per_cpu(hrtimer_bases, dcpu);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
@@ -1687,10 +1702,9 @@ static void migrate_hrtimers(int scpu)
 
 	raw_spin_unlock(&old_base->lock);
 	raw_spin_unlock(&new_base->lock);
-
-	/* Check, if we got expired work to do */
-	__hrtimer_peek_ahead_timers();
-	local_irq_enable();
+#ifdef CONFIG_HIGH_RES_TIMERS
+	raise_remote_softirq(dcpu, HRTIMER_SOFTIRQ);
+#endif
 }
 
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -1711,14 +1725,12 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &scpu);
+		migrate_hrtimers(scpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-	{
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
-		migrate_hrtimers(scpu);
 		break;
-	}
 #endif
 
 	default:
diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..c9e8679 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1665,16 +1665,19 @@ static void __cpuinit migrate_timers(int cpu)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
+	int dcpu;
 	int i;
 
 	BUG_ON(cpu_online(cpu));
+	BUG_ON(!irqs_disabled());
+	dcpu = any_online_cpu(cpu_online_map);
 	old_base = per_cpu(tvec_bases, cpu);
-	new_base = get_cpu_var(tvec_bases);
+	new_base = per_cpu(tvec_bases, dcpu);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	spin_lock_irq(&new_base->lock);
+	spin_lock(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
@@ -1689,8 +1692,7 @@ static void __cpuinit migrate_timers(int cpu)
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock_irq(&new_base->lock);
-	put_cpu_var(tvec_bases);
+	spin_unlock(&new_base->lock);
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
@@ -1708,8 +1710,8 @@ static int __cpuinit timer_cpu_notify(struct notifier_block *self,
 			return notifier_from_errno(err);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
 		migrate_timers(cpu);
 		break;
 #endif
