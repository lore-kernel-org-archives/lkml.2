Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0EMGxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:53:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:56733 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab0EMGx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:53:28 -0400
Date: Thu, 13 May 2010 06:52:27 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eparis@redhat.com, peterz@infradead.org, randy.dunlap@oracle.com,
       gorcunov@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eparis@redhat.com, peterz@infradead.org, gorcunov@gmail.com,
       randy.dunlap@oracle.com, fweisbec@gmail.com, tglx@linutronix.de,
       dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1273266711-18706-4-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] lockup_detector: Remove old softlockup code
Message-ID: <tip-2508ce1845a3b256798532b2c6b7997c2dc6533b@git.kernel.org>
Git-Commit-ID: 2508ce1845a3b256798532b2c6b7997c2dc6533b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 06:52:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2508ce1845a3b256798532b2c6b7997c2dc6533b
Gitweb:     http://git.kernel.org/tip/2508ce1845a3b256798532b2c6b7997c2dc6533b
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 7 May 2010 17:11:46 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 12 May 2010 23:55:45 +0200

lockup_detector: Remove old softlockup code

Now that is no longer compiled or used, just remove it.

Also move some of the code wrapped with DETECT_SOFTLOCKUP to the
LOCKUP_DETECTOR wrappers because that is the code that uses it now.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <1273266711-18706-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/softlockup.c |  293 ---------------------------------------------------
 kernel/sysctl.c     |   22 ++--
 2 files changed, 10 insertions(+), 305 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
deleted file mode 100644
index 4b493f6..0000000
--- a/kernel/softlockup.c
+++ /dev/null
@@ -1,293 +0,0 @@
-/*
- * Detect Soft Lockups
- *
- * started by Ingo Molnar, Copyright (C) 2005, 2006 Red Hat, Inc.
- *
- * this code detects soft lockups: incidents in where on a CPU
- * the kernel does not reschedule for 10 seconds or more.
- */
-#include <linux/mm.h>
-#include <linux/cpu.h>
-#include <linux/nmi.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/lockdep.h>
-#include <linux/notifier.h>
-#include <linux/module.h>
-#include <linux/sysctl.h>
-
-#include <asm/irq_regs.h>
-
-static DEFINE_SPINLOCK(print_lock);
-
-static DEFINE_PER_CPU(unsigned long, softlockup_touch_ts); /* touch timestamp */
-static DEFINE_PER_CPU(unsigned long, softlockup_print_ts); /* print timestamp */
-static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
-static DEFINE_PER_CPU(bool, softlock_touch_sync);
-
-static int __read_mostly did_panic;
-int __read_mostly softlockup_thresh = 60;
-
-/*
- * Should we panic (and reboot, if panic_timeout= is set) when a
- * soft-lockup occurs:
- */
-unsigned int __read_mostly softlockup_panic =
-				CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
-
-static int __init softlockup_panic_setup(char *str)
-{
-	softlockup_panic = simple_strtoul(str, NULL, 0);
-
-	return 1;
-}
-__setup("softlockup_panic=", softlockup_panic_setup);
-
-static int
-softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
-{
-	did_panic = 1;
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block panic_block = {
-	.notifier_call = softlock_panic,
-};
-
-/*
- * Returns seconds, approximately.  We don't need nanosecond
- * resolution, and we don't need to waste time with a big divide when
- * 2^30ns == 1.074s.
- */
-static unsigned long get_timestamp(int this_cpu)
-{
-	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
-}
-
-static void __touch_softlockup_watchdog(void)
-{
-	int this_cpu = raw_smp_processor_id();
-
-	__raw_get_cpu_var(softlockup_touch_ts) = get_timestamp(this_cpu);
-}
-
-void touch_softlockup_watchdog(void)
-{
-	__raw_get_cpu_var(softlockup_touch_ts) = 0;
-}
-EXPORT_SYMBOL(touch_softlockup_watchdog);
-
-void touch_softlockup_watchdog_sync(void)
-{
-	__raw_get_cpu_var(softlock_touch_sync) = true;
-	__raw_get_cpu_var(softlockup_touch_ts) = 0;
-}
-
-void touch_all_softlockup_watchdogs(void)
-{
-	int cpu;
-
-	/* Cause each CPU to re-update its timestamp rather than complain */
-	for_each_online_cpu(cpu)
-		per_cpu(softlockup_touch_ts, cpu) = 0;
-}
-EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
-
-int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-			     void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	touch_all_softlockup_watchdogs();
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-}
-
-/*
- * This callback runs from the timer interrupt, and checks
- * whether the watchdog thread has hung or not:
- */
-void softlockup_tick(void)
-{
-	int this_cpu = smp_processor_id();
-	unsigned long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
-	unsigned long print_ts;
-	struct pt_regs *regs = get_irq_regs();
-	unsigned long now;
-
-	/* Is detection switched off? */
-	if (!per_cpu(softlockup_watchdog, this_cpu) || softlockup_thresh <= 0) {
-		/* Be sure we don't false trigger if switched back on */
-		if (touch_ts)
-			per_cpu(softlockup_touch_ts, this_cpu) = 0;
-		return;
-	}
-
-	if (touch_ts == 0) {
-		if (unlikely(per_cpu(softlock_touch_sync, this_cpu))) {
-			/*
-			 * If the time stamp was touched atomically
-			 * make sure the scheduler tick is up to date.
-			 */
-			per_cpu(softlock_touch_sync, this_cpu) = false;
-			sched_clock_tick();
-		}
-		__touch_softlockup_watchdog();
-		return;
-	}
-
-	print_ts = per_cpu(softlockup_print_ts, this_cpu);
-
-	/* report at most once a second */
-	if (print_ts == touch_ts || did_panic)
-		return;
-
-	/* do not print during early bootup: */
-	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		__touch_softlockup_watchdog();
-		return;
-	}
-
-	now = get_timestamp(this_cpu);
-
-	/*
-	 * Wake up the high-prio watchdog task twice per
-	 * threshold timespan.
-	 */
-	if (time_after(now - softlockup_thresh/2, touch_ts))
-		wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
-
-	/* Warn about unreasonable delays: */
-	if (time_before_eq(now - softlockup_thresh, touch_ts))
-		return;
-
-	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
-
-	spin_lock(&print_lock);
-	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
-			this_cpu, now - touch_ts,
-			current->comm, task_pid_nr(current));
-	print_modules();
-	print_irqtrace_events(current);
-	if (regs)
-		show_regs(regs);
-	else
-		dump_stack();
-	spin_unlock(&print_lock);
-
-	if (softlockup_panic)
-		panic("softlockup: hung tasks");
-}
-
-/*
- * The watchdog thread - runs every second and touches the timestamp.
- */
-static int watchdog(void *__bind_cpu)
-{
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
-	/* initialize timestamp */
-	__touch_softlockup_watchdog();
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	/*
-	 * Run briefly once per second to reset the softlockup timestamp.
-	 * If this gets delayed for more than 60 seconds then the
-	 * debug-printout triggers in softlockup_tick().
-	 */
-	while (!kthread_should_stop()) {
-		__touch_softlockup_watchdog();
-		schedule();
-
-		if (kthread_should_stop())
-			break;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-/*
- * Create/destroy watchdog threads as CPUs come and go:
- */
-static int __cpuinit
-cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int hotcpu = (unsigned long)hcpu;
-	struct task_struct *p;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		BUG_ON(per_cpu(softlockup_watchdog, hotcpu));
-		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
-		if (IS_ERR(p)) {
-			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
-			return NOTIFY_BAD;
-		}
-		per_cpu(softlockup_touch_ts, hotcpu) = 0;
-		per_cpu(softlockup_watchdog, hotcpu) = p;
-		kthread_bind(p, hotcpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		wake_up_process(per_cpu(softlockup_watchdog, hotcpu));
-		break;
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(softlockup_watchdog, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(softlockup_watchdog, hotcpu),
-			     cpumask_any(cpu_online_mask));
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		p = per_cpu(softlockup_watchdog, hotcpu);
-		per_cpu(softlockup_watchdog, hotcpu) = NULL;
-		kthread_stop(p);
-		break;
-#endif /* CONFIG_HOTPLUG_CPU */
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata cpu_nfb = {
-	.notifier_call = cpu_callback
-};
-
-static int __initdata nosoftlockup;
-
-static int __init nosoftlockup_setup(char *str)
-{
-	nosoftlockup = 1;
-	return 1;
-}
-__setup("nosoftlockup", nosoftlockup_setup);
-
-static int __init spawn_softlockup_task(void)
-{
-	void *cpu = (void *)(long)smp_processor_id();
-	int err;
-
-	if (nosoftlockup)
-		return 0;
-
-	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	if (err == NOTIFY_BAD) {
-		BUG();
-		return 1;
-	}
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
-	register_cpu_notifier(&cpu_nfb);
-
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
-
-	return 0;
-}
-early_initcall(spawn_softlockup_task);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 999bc3f..04bcd8a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -108,7 +108,7 @@ extern int blk_iopoll_enabled;
 #endif
 
 /* Constants used for minimum and  maximum */
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_LOCKUP_DETECTOR
 static int sixty = 60;
 static int neg_one = -1;
 #endif
@@ -703,6 +703,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
+	{
+		.procname	= "softlockup_panic",
+		.data		= &softlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
 	{
@@ -807,17 +816,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_DETECT_SOFTLOCKUP
-	{
-		.procname	= "softlockup_panic",
-		.data		= &softlockup_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
-	},
-#endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 	{
 		.procname	= "hung_task_panic",
