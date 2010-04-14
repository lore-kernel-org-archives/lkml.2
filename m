Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0DNAKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:10:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14403 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0DNAKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:10:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=KP+Tsez64Pq2HNKGWUl3OSEo0NWjpXm8nUVrNrwbwzSMNpco5Cv7oKuPp88YbIEKk
	fNoMl8s1lGb3/Dkve1InQ==
Subject: [PATCH 1/3] [kidled]: introduce kidled.
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org
From: Salman <sqazi@google.com>
Cc: csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Date: Tue, 13 Apr 2010 17:08:33 -0700
Message-ID: <20100414000823.29004.98991.stgit@bumblebee1.mtv.corp.google.com>
In-Reply-To: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salman Qazi <sqazi@google.com>

kidled is a kernel thread that implements idle cycle injection for
the purposes of power capping.  It measures the naturally occuring
idle time as necessary to avoid injecting idle cycles when the
CPU is already sufficiently idle.  The actual idle cycle injection
takes places in a realtime kernel thread, where as the measurements
take place in hrtimer callback functions.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 Documentation/kidled.txt     |   40 +++
 arch/x86/Kconfig             |    1 
 arch/x86/include/asm/idle.h  |    1 
 arch/x86/kernel/process_64.c |    2 
 drivers/misc/Gconfig.ici     |    1 
 include/linux/kidled.h       |   45 +++
 kernel/Kconfig.ici           |    6 
 kernel/Makefile              |    1 
 kernel/kidled.c              |  547 ++++++++++++++++++++++++++++++++++++++++++
 kernel/softirq.c             |   15 +
 kernel/sysctl.c              |   11 +
 11 files changed, 664 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/kidled.txt
 create mode 100644 drivers/misc/Gconfig.ici
 create mode 100644 include/linux/kidled.h
 create mode 100644 kernel/Kconfig.ici
 create mode 100644 kernel/kidled.c

diff --git a/Documentation/kidled.txt b/Documentation/kidled.txt
new file mode 100644
index 0000000..1149e3f
--- /dev/null
+++ b/Documentation/kidled.txt
@@ -0,0 +1,40 @@
+Idle Cycle Injector:
+====================
+
+Overview:
+
+Provides a kernel interface for causing the CPUs to have some
+minimum percentage of the idle time.
+
+Interfaces:
+
+Under /proc/sys/kernel/kidled/, we can find the following files:
+
+cpu/*/interval
+cpu/*/min_idle_percent
+cpu/*/stats
+
+interval specifies the period of time over which we attempt to make the
+CPU min_idle_percent idle.  stats provides three fields.  The first is
+the naturally occuring idle time.  The second is the busy time, and the last
+is the injected idle time.  All three values are reported in the units of
+nanoseconds.
+
+** VERY IMPORTANT NOTE: ** In all kernel stats except for cpu/*/stats, the
+injected idle cycles are by convention reported as busy time, attributed to
+kidled.
+
+
+Operation:
+
+The injecting component of the idle cycle injector is the kernel thread
+kidled.  The measurements to determine when to inject idle cycles is done
+in hrtimer callbacks.  The idea is to avoid injecting idle cycles when
+the CPU is already sufficiently idle.  This is accomplished by always setting
+the next timer expiry to the minimum of when we expect to run out of CPU time
+(running at full tilt) or the end of the interval.  When the timer expires,
+we evaluate if we need to inject idle cycles right away to avoid blowing our
+quota.  If that's the case, then we inject idle cycles until the end of the
+interval.
+
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..cd384e1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -754,6 +754,7 @@ config SCHED_MC
 	  increased overhead in some places. If unsure say N here.
 
 source "kernel/Kconfig.preempt"
+source "kernel/Kconfig.ici"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index 38d8737..e36c5b4 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -10,6 +10,7 @@ void idle_notifier_unregister(struct notifier_block *n);
 
 #ifdef CONFIG_X86_64
 void enter_idle(void);
+void __exit_idle(void);
 void exit_idle(void);
 #else /* !CONFIG_X86_64 */
 static inline void enter_idle(void) { }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 126f0b4..a7c8932 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -77,7 +77,7 @@ void enter_idle(void)
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
-static void __exit_idle(void)
+void __exit_idle(void)
 {
 	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
 		return;
diff --git a/drivers/misc/Gconfig.ici b/drivers/misc/Gconfig.ici
new file mode 100644
index 0000000..ecad2be
--- /dev/null
+++ b/drivers/misc/Gconfig.ici
@@ -0,0 +1 @@
+CONFIG_IDLE_CYCLE_INJECTOR=y
diff --git a/include/linux/kidled.h b/include/linux/kidled.h
new file mode 100644
index 0000000..7940dfa
--- /dev/null
+++ b/include/linux/kidled.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright 2008 Google Inc.
+ *
+ * Author: sqazi@google.com
+ *
+ */
+
+#include <linux/tick.h>
+
+#ifndef _IDLED_H
+#define _IDLED_H
+
+DECLARE_PER_CPU(unsigned long, cpu_lazy_inject_count);
+
+static inline s64 current_cpu_lazy_inject_count(void)
+{
+	/* We'll update this value in the idle cycle injector */
+	return __get_cpu_var(cpu_lazy_inject_count);
+}
+
+static inline s64 current_cpu_inject_count(void)
+{
+	return current_cpu_lazy_inject_count();
+}
+
+
+static inline s64 current_cpu_idle_count(void)
+{
+	int cpu = smp_processor_id();
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
+	return ktime_to_ns(ts->idle_sleeptime) + current_cpu_inject_count();
+}
+
+static inline s64 current_cpu_busy_count(void)
+{
+	int cpu = smp_processor_id();
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
+	return ktime_to_ns(ktime_sub(ktime_get(), ts->idle_sleeptime)) -
+			   current_cpu_inject_count();
+}
+
+void kidled_interrupt_enter(void);
+void set_cpu_idle_ratio(int cpu, long idle_time, long busy_time);
+void get_cpu_idle_ratio(int cpu, long *idle_time, long *busy_time);
+#endif
diff --git a/kernel/Kconfig.ici b/kernel/Kconfig.ici
new file mode 100644
index 0000000..db5db95
--- /dev/null
+++ b/kernel/Kconfig.ici
@@ -0,0 +1,6 @@
+config IDLE_CYCLE_INJECTOR
+	bool "Idle Cycle Injector"
+	default n
+	help
+	  Reduces power consumption by making sure that each CPU is
+	  idle the given percentage of time.
diff --git a/kernel/Makefile b/kernel/Makefile
index 864ff75..fc82197 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -24,6 +24,7 @@ CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
+obj-$(CONFIG_IDLE_CYCLE_INJECTOR) += kidled.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
diff --git a/kernel/kidled.c b/kernel/kidled.c
new file mode 100644
index 0000000..f590178
--- /dev/null
+++ b/kernel/kidled.c
@@ -0,0 +1,547 @@
+/*
+ * Copyright 2008 Google Inc.
+ *
+ * Idle Cycle Injector, also affectionately known as "kidled".
+ *
+ * Allows us to force each processor to have a specific amount of idle
+ * cycles for the purposes of controlling the power consumed by the machine.
+ *
+ * Authors:
+ *
+ * Salman Qazi <sqazi@google.com>
+ * Ken Chen <kenchen@google.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/cpu.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <linux/kidled.h>
+#include <linux/poll.h>
+#include <linux/hrtimer.h>
+#include <linux/spinlock.h>
+#include <linux/sysctl.h>
+#include <linux/irqflags.h>
+#include <linux/timer.h>
+#include <asm/atomic.h>
+#include <asm/idle.h>
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+#define SLEEP_GRANULARITY	(20*NSEC_PER_USEC)
+#else
+#define SLEEP_GRANULARITY	(NSEC_PER_MSEC)
+#endif
+
+#define KIDLED_PRIO		 (MAX_RT_PRIO - 2)
+#define KIDLED_DEFAULT_INTERVAL  (100 * NSEC_PER_MSEC)
+
+struct kidled_inputs {
+	spinlock_t lock;
+	long idle_time;
+	long busy_time;
+};
+
+static int kidled_init_completed;
+static DEFINE_PER_CPU(struct task_struct *, kidled_thread);
+static DEFINE_PER_CPU(struct kidled_inputs, kidled_inputs);
+
+DEFINE_PER_CPU(unsigned long, cpu_lazy_inject_count);
+
+struct monitor_cpu_data {
+	int cpu;
+	long base_clock_count;
+	long base_cpu_count;
+	long max_clock_time;
+	long max_cpu_time;
+	long clock_time;
+	long cpu_time;
+};
+
+static DEFINE_PER_CPU(struct monitor_cpu_data, monitor_cpu_data);
+
+
+static DEFINE_PER_CPU(int, in_lazy_inject);
+static DEFINE_PER_CPU(unsigned long, inject_start);
+static void __enter_lazy_inject(void)
+{
+	if (!__get_cpu_var(in_lazy_inject)) {
+		__get_cpu_var(inject_start) = ktime_to_ns(ktime_get());
+		__get_cpu_var(in_lazy_inject) = 1;
+	}
+	enter_idle();
+}
+
+static void __exit_lazy_inject(void)
+{
+	if (__get_cpu_var(in_lazy_inject)) {
+		get_cpu_var(cpu_lazy_inject_count) +=
+			ktime_to_ns(ktime_get()) - __get_cpu_var(inject_start);
+		__get_cpu_var(in_lazy_inject) = 0;
+	}
+	__exit_idle();
+}
+
+static void enter_lazy_inject(void)
+{
+	local_irq_disable();
+	__enter_lazy_inject();
+	local_irq_enable();
+}
+
+static void exit_lazy_inject(void)
+{
+	local_irq_disable();
+	__exit_lazy_inject();
+	local_irq_enable();
+}
+
+/* Caller must have interrupts disabled */
+void kidled_interrupt_enter(void)
+{
+	if (!kidled_init_completed)
+		return;
+
+	__exit_lazy_inject();
+}
+
+static DEFINE_PER_CPU(int, still_lazy_injecting);
+static enum hrtimer_restart lazy_inject_timer_func(struct hrtimer *timer)
+{
+	__get_cpu_var(still_lazy_injecting) = 0;
+	return HRTIMER_NORESTART;
+}
+
+static void do_idle(void)
+{
+	void (*idle)(void) = NULL;
+
+	idle = pm_idle;
+	if (!idle)
+		idle = default_idle;
+
+	/* Put CPU to sleep until next interrupt */
+	idle();
+}
+
+/* Halts the CPU for the given number of nanoseconds.
+ *
+ * The cond_resched in there must be used responsibly, in the sense
+ * that we should have a minimal amount of work that the kernel
+ * wants done even when we are injecting idle cycles.  This work
+ * should be accounted for by higher level users.
+ */
+static void lazy_inject(long nsecs, long interval)
+{
+	struct hrtimer halt_timer;
+
+	if (nsecs <= 0)
+		return;
+
+	__get_cpu_var(still_lazy_injecting) = 1;
+	hrtimer_init(&halt_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_set_expires(&halt_timer, ktime_set(0, nsecs));
+	halt_timer.function = lazy_inject_timer_func;
+	hrtimer_start(&halt_timer, ktime_set(0, nsecs), HRTIMER_MODE_REL);
+
+	while (__get_cpu_var(still_lazy_injecting)) {
+
+		enter_lazy_inject();
+
+		/* Put CPU to sleep until next interrupt */
+		do_idle();
+		exit_lazy_inject();
+
+		/* The supervising userland thread needs to run with
+		 * minimal latency.  We yield to higher priority threads
+		 */
+		cond_resched();
+	}
+	__get_cpu_var(still_lazy_injecting) = 0;
+	hrtimer_cancel(&halt_timer);
+}
+
+static DEFINE_PER_CPU(int, still_monitoring);
+
+/*
+ * Tells us when we would need to wake up next.
+ */
+long get_next_timer(struct monitor_cpu_data *data)
+{
+	long lazy;
+
+	lazy = min(data->max_cpu_time - data->cpu_time,
+		   data->max_clock_time - data->clock_time);
+
+	lazy -= SLEEP_GRANULARITY - 1;
+
+	return lazy;
+}
+
+/*
+ * Figures out if the idle cycle injector needs to be woken up at the moment.
+ * If yes, then we go ahead and wake it up.  If no, then we figure out the
+ * next time when we should make the same decision.  The idea is to always
+ * make the decision before the applications use up the available CPU or
+ * clock time.
+ *
+ */
+static enum hrtimer_restart monitor_cpu_timer_func(struct hrtimer *timer)
+{
+	long next_timer;
+	struct monitor_cpu_data *data = &__get_cpu_var(monitor_cpu_data);
+
+	BUG_ON(data->cpu != smp_processor_id());
+	data->clock_time = ktime_to_ns(ktime_get()) - data->base_clock_count;
+	data->cpu_time = current_cpu_busy_count() - data->base_cpu_count;
+
+	if ((data->max_clock_time - data->clock_time < SLEEP_GRANULARITY) ||
+	    (data->max_cpu_time - data->cpu_time < SLEEP_GRANULARITY)) {
+		__get_cpu_var(still_monitoring) = 0;
+
+		wake_up_process(__get_cpu_var(kidled_thread));
+		return HRTIMER_NORESTART;
+	} else {
+		next_timer = get_next_timer(data);
+
+		hrtimer_forward_now(timer, ktime_set(0,  next_timer));
+		return HRTIMER_RESTART;
+	}
+}
+
+/*
+ * Allow other processes to use CPU for up to max_clock_time
+ * clock time, and max_cpu_time CPU time.
+ *
+ * Accurate only up to resolution of hrtimers.
+ *
+ * @return: Clock time left
+ */
+static unsigned long monitor_cpu(long max_clock_time, long max_cpu_time,
+			   long *left_cpu_time)
+{
+	long first_timer;
+	struct hrtimer sleep_timer;
+	struct monitor_cpu_data *data = &__get_cpu_var(monitor_cpu_data);
+	data->max_clock_time = max_clock_time;
+	data->max_cpu_time = max_cpu_time;
+	data->base_clock_count = ktime_to_ns(ktime_get());
+	data->base_cpu_count = current_cpu_busy_count();
+	data->clock_time = 0;
+	data->cpu_time = 0;
+	data->cpu = smp_processor_id();
+
+	first_timer =  get_next_timer(data);
+	if (first_timer <= 0) {
+		if (left_cpu_time)
+			*left_cpu_time = max_cpu_time;
+
+		return max_clock_time;
+	}
+
+	__get_cpu_var(still_monitoring) = 1;
+	hrtimer_init(&sleep_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_set_expires(&sleep_timer, ktime_set(0, first_timer));
+	sleep_timer.function = monitor_cpu_timer_func;
+	hrtimer_start(&sleep_timer, ktime_set(0, first_timer),
+		      HRTIMER_MODE_REL);
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!__get_cpu_var(still_monitoring))
+			break;
+		schedule();
+	}
+
+	__get_cpu_var(still_monitoring) = 0;
+	hrtimer_cancel(&sleep_timer);
+
+	if (left_cpu_time)
+		*left_cpu_time = max(data->max_cpu_time - data->cpu_time, 0L);
+
+	return max(data->max_clock_time - data->clock_time, 0L);
+}
+
+static int kidled(void *p)
+{
+	struct kidled_inputs *inputs = (struct kidled_inputs *)p;
+	long idle_time = 0;
+	long busy_time = 0;
+	long old_idle_time;
+	long old_busy_time;
+	long interval = 0;
+	unsigned long nsecs_left = 0;
+	__get_cpu_var(still_lazy_injecting) = 0;
+	allow_signal(SIGHUP);
+
+	while (1) {
+		old_idle_time = idle_time;
+		old_busy_time = busy_time;
+		spin_lock(&inputs->lock);
+		busy_time = inputs->busy_time;
+		idle_time = inputs->idle_time;
+
+		/* Just incase we get spurious SIGHUPs */
+		if ((old_idle_time != idle_time) ||
+			(old_busy_time != busy_time)) {
+			interval = idle_time + busy_time;
+		}
+		flush_signals(current);
+		spin_unlock(&inputs->lock);
+
+		/* Keep overhead low when dormant */
+		if (idle_time == 0) {
+			while (!signal_pending(current)) {
+				schedule_timeout_interruptible(
+						MAX_SCHEDULE_TIMEOUT);
+			}
+		}
+
+		while (!signal_pending(current)) {
+			nsecs_left = monitor_cpu(interval, busy_time, NULL);
+			lazy_inject(nsecs_left, interval);
+		}
+	}
+}
+
+void set_cpu_idle_ratio(int cpu, long idle_time, long busy_time)
+{
+	spin_lock(&per_cpu(kidled_inputs, cpu).lock);
+	per_cpu(kidled_inputs, cpu).idle_time = idle_time;
+	per_cpu(kidled_inputs, cpu).busy_time = busy_time;
+	send_sig(SIGHUP, per_cpu(kidled_thread, cpu), 1);
+	spin_unlock(&per_cpu(kidled_inputs, cpu).lock);
+}
+
+void get_cpu_idle_ratio(int cpu, long *idle_time, long *busy_time)
+{
+	spin_lock(&per_cpu(kidled_inputs, cpu).lock);
+	*idle_time = per_cpu(kidled_inputs, cpu).idle_time;
+	*busy_time = per_cpu(kidled_inputs, cpu).busy_time;
+	spin_unlock(&per_cpu(kidled_inputs, cpu).lock);
+}
+
+static long get_kidled_interval(int cpu)
+{
+	long idle_time;
+	long busy_time;
+	get_cpu_idle_ratio(cpu, &idle_time, &busy_time);
+	return idle_time + busy_time;
+}
+
+static void set_kidled_interval(int cpu, long interval)
+{
+	int old_interval;
+	spin_lock(&per_cpu(kidled_inputs, cpu).lock);
+	old_interval = per_cpu(kidled_inputs, cpu).busy_time +
+			per_cpu(kidled_inputs, cpu).idle_time;
+	per_cpu(kidled_inputs, cpu).idle_time =
+			(per_cpu(kidled_inputs, cpu).idle_time
+		* interval) / old_interval;
+	per_cpu(kidled_inputs, cpu).busy_time = interval -
+					per_cpu(kidled_inputs, cpu).idle_time;
+	send_sig(SIGHUP, per_cpu(kidled_thread, cpu), 1);
+	spin_unlock(&per_cpu(kidled_inputs, cpu).lock);
+}
+
+static int proc_min_idle_percent(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos)
+{
+	long idle_time;
+	long busy_time;
+	int ratio;
+	struct ctl_table fake = {};
+	int zero = 0;
+	int hundred = 100;
+	int ret;
+
+	int cpu = (int)((long)table->extra1);
+
+	fake.data = &ratio;
+	fake.maxlen = sizeof(int);
+	fake.extra1 = &zero;
+	fake.extra2 = &hundred;
+
+
+	if (!write) {
+		get_cpu_idle_ratio(cpu, &idle_time, &busy_time);
+		ratio = (int)((idle_time * 100) / (idle_time + busy_time));
+	}
+
+	ret = proc_dointvec_minmax(&fake, write, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		int idle_interval;
+
+		idle_interval = get_kidled_interval(cpu);
+		idle_time = ((long)ratio * idle_interval) / 100;
+
+		/* round down new_idle to timer resolution */
+		idle_time = (idle_time / SLEEP_GRANULARITY) *
+				SLEEP_GRANULARITY;
+
+		set_cpu_idle_ratio(cpu, idle_time,
+				   idle_interval - idle_time);
+	}
+
+	return ret;
+}
+
+static int proc_interval(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	long idle_time;
+	long busy_time;
+	int interval;
+	struct ctl_table fake = {};
+	int min = 1;
+	int max = 500;
+	int ret;
+
+	int cpu = (int)((long)table->extra1);
+
+	fake.data = &interval;
+	fake.maxlen = sizeof(int);
+	fake.extra1 = &min;
+	fake.extra2 = &max;
+
+
+	if (!write) {
+		get_cpu_idle_ratio(cpu, &idle_time, &busy_time);
+		interval = (int)((idle_time + busy_time) / NSEC_PER_MSEC);
+	}
+
+	ret = proc_dointvec_minmax(&fake, write, buffer, lenp, ppos);
+
+	if (!ret && write)
+		set_kidled_interval(cpu, (long)interval * NSEC_PER_MSEC);
+
+	return ret;
+}
+
+static void getstats(void *info)
+{
+	unsigned long *stats = (unsigned long *)info;
+	stats[0] = current_cpu_idle_count();
+	stats[1] = current_cpu_busy_count();
+	stats[2] = current_cpu_lazy_inject_count();
+}
+
+
+static int proc_stats(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+	unsigned long stats[3];
+	int cpu = (int)((long)table->extra1);
+	struct ctl_table fake = {};
+
+	if (write)
+		return -EINVAL;
+
+	fake.data = stats;
+	fake.maxlen = 3*sizeof(unsigned long);
+
+	ret = smp_call_function_single(cpu, getstats, &stats, 1);
+	if (ret)
+		return ret;
+
+	return proc_doulongvec_minmax(&fake, write, buffer, lenp, ppos);
+
+}
+
+#define NUM_CPU_CTLS    3
+#define CPU_NUM_SIZE    5
+
+static struct ctl_table kidled_cpu_dir_prot[NUM_CPU_CTLS + 1] = {
+	{
+		.procname	= "min_idle_percent",
+		.proc_handler	= proc_min_idle_percent,
+		.mode		= 0644,
+	},
+	{
+		.procname	= "interval",
+		.proc_handler	= proc_interval,
+		.mode		= 0644,
+	},
+	{
+		.procname	= "stats",
+		.proc_handler	= proc_stats,
+		.mode		= 0444,
+	},
+
+	{ }
+
+};
+static DEFINE_PER_CPU(char[CPU_NUM_SIZE], cpu_num);
+
+static DEFINE_PER_CPU(struct ctl_table[NUM_CPU_CTLS + 1],
+		      kidled_cpu_dir_table);
+
+/* This is the kidled/cpu/ directory */
+static struct ctl_table kidled_cpu_table[NR_CPUS + 1];
+
+static int zero;
+
+struct ctl_table kidled_table[] = {
+	{
+		.procname	= "cpu",
+		.mode		= 0555,
+		.child		= kidled_cpu_table,
+	},
+	{ }
+};
+
+static int __init kidled_init(void)
+{
+	int cpu;
+	int i;
+
+	/*
+	 * One priority level below maximum.  The next higher priority level
+	 * will be used by a userland thread supervising us.
+	 */
+	struct sched_param param = { .sched_priority = KIDLED_PRIO };
+
+	if (!proc_mkdir("driver/kidled", NULL))
+		return 1;
+
+	for_each_online_cpu(cpu) {
+		spin_lock_init(&per_cpu(kidled_inputs, cpu).lock);
+		per_cpu(kidled_inputs, cpu).idle_time = 0;
+		per_cpu(kidled_inputs, cpu).busy_time =
+						KIDLED_DEFAULT_INTERVAL;
+		per_cpu(kidled_thread, cpu) = kthread_create(kidled,
+			&per_cpu(kidled_inputs, cpu), "kidled/%d", cpu);
+		if (IS_ERR(per_cpu(kidled_thread, cpu))) {
+			printk(KERN_ERR "Failed to start kidled on CPU %d\n",
+			       cpu);
+			BUG();
+		}
+
+		kthread_bind(per_cpu(kidled_thread, cpu), cpu);
+		sched_setscheduler(per_cpu(kidled_thread, cpu),
+			SCHED_FIFO, &param);
+		wake_up_process(per_cpu(kidled_thread, cpu));
+
+		snprintf(per_cpu(cpu_num, cpu), CPU_NUM_SIZE, "%d", cpu);
+		kidled_cpu_table[cpu].procname = per_cpu(cpu_num, cpu);
+		kidled_cpu_table[cpu].mode = 0555;
+		kidled_cpu_table[cpu].child = per_cpu(kidled_cpu_dir_table,
+					      cpu);
+
+		memcpy(per_cpu(kidled_cpu_dir_table, cpu), kidled_cpu_dir_prot,
+		       sizeof(kidled_cpu_dir_prot));
+
+		for (i = 0; i < NUM_CPU_CTLS; i++) {
+			per_cpu(kidled_cpu_dir_table[i], cpu).extra1 =
+				(void *)((long)cpu);
+		}
+
+	}
+	kidled_init_completed = 1;
+	return 0;
+}
+module_init(kidled_init);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7c1a67e..97d6193 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,6 +24,7 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <linux/kidled.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -278,11 +279,15 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (idle_cpu(cpu) && !in_interrupt()) {
-		__irq_enter();
-		tick_check_idle(cpu);
-	} else
-		__irq_enter();
+	__irq_enter();
+	if (!in_interrupt()) {
+		if (idle_cpu(cpu))
+			tick_check_idle(cpu);
+
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		kidled_interrupt_enter();
+#endif
+	}
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..eaec177 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -190,6 +190,9 @@ static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
 extern struct ctl_table random_table[];
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+extern struct ctl_table kidled_table[];
+#endif
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
@@ -601,6 +604,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0555,
 		.child		= random_table,
 	},
+
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	{
+		.procname	= "kidled",
+		.mode		= 0555,
+		.child		= kidled_table,
+	},
+#endif
 	{
 		.procname	= "overflowuid",
 		.data		= &overflowuid,

