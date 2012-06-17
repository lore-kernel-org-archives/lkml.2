Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2FQGff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 02:35:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62368 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2FQGfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 02:35:34 -0400
Message-ID: <4FDD7AA8.6080601@gmail.com>
Date: Sun, 17 Jun 2012 00:35:20 -0600
From: Hakan Akkan <hakanakkan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in the
 presence of nohz cpusets
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An adaptive nohz (AHZ) CPU may not do do_timer() for a while
despite being non-idle. When all other CPUs are idle, AHZ
CPUs might be using stale jiffies values. To prevent this
always keep a CPU with ticks if there is one or more AHZ
CPUs.

The patch changes can_stop_{idle,adaptive}_tick functions
and prevents either the last CPU who did the do_timer() duty
or the AHZ CPU itself from stopping its sched timer if there
is one or more AHZ CPUs in the system. This means AHZ CPUs
might keep the ticks running for short periods until a
non-AHZ CPU takes the charge away in
tick_do_timer_check_handler() function. When a non-AHZ CPU
takes the charge, it never gives it away so that AHZ CPUs
can run tickless.

Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/cpuset.h   |    3 ++-
 kernel/cpuset.c          |    5 +++++
 kernel/time/tick-sched.c |   31 ++++++++++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index ccbc2fd..19aa448 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -266,11 +266,12 @@ static inline bool cpuset_adaptive_nohz(void)
 
 extern void cpuset_exit_nohz_interrupt(void *unused);
 extern void cpuset_nohz_flush_cputimes(void);
+extern bool nohz_cpu_exist(void);
 #else
 static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
 static inline bool cpuset_adaptive_nohz(void) { return false; }
 static inline void cpuset_nohz_flush_cputimes(void) { }
-
+static inline bool nohz_cpu_exist(void) { return false; }
 #endif /* CONFIG_CPUSETS_NO_HZ */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 858217b..ccbaac9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1231,6 +1231,11 @@ DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
 
 static cpumask_t nohz_cpuset_mask;
 
+inline bool nohz_cpu_exist(void)
+{
+	return !cpumask_empty(&nohz_cpuset_mask);
+}
+
 static void flush_cputime_interrupt(void *unused)
 {
 	trace_printk("IPI: flush cputime\n");
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bdc8aeb..e60d541 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -409,6 +409,25 @@ out:
 	return ret;
 }
 
+static inline bool must_take_timer_duty(int cpu)
+{
+	int handler = tick_do_timer_cpu;
+	bool ret = false;
+	bool tick_needed = nohz_cpu_exist();
+
+	/*
+	 * A CPU will have to take the timer duty if there is an adaptive
+	 * nohz CPU in the system. The last handler == cpu check ensures
+	 * that the last cpu that did the do_timer() sticks with the duty.
+	 * A normal (non nohz) cpu will take the charge from a nohz cpu in
+	 * tick_do_timer_check_handler anyway.
+	 */
+	if (tick_needed && (handler == TICK_DO_TIMER_NONE || handler == cpu))
+		ret = true;
+
+	return ret;
+}
+
 static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 {
 	/*
@@ -421,6 +440,9 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+	} else if (must_take_timer_duty(cpu)) {
+		tick_do_timer_cpu = cpu;
+		return false;
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
@@ -512,6 +534,13 @@ void tick_nohz_idle_enter(void)
 #ifdef CONFIG_CPUSETS_NO_HZ
 static bool can_stop_adaptive_tick(void)
 {
+	int cpu = smp_processor_id();
+
+	if (must_take_timer_duty(cpu)) {
+		tick_do_timer_cpu = cpu;
+		return false;
+	}
+
 	if (!sched_can_stop_tick())
 		return false;
 
@@ -519,7 +548,7 @@ static bool can_stop_adaptive_tick(void)
 		return false;
 
 	/* Is there a grace period to complete ? */
-	if (rcu_pending(smp_processor_id()))
+	if (rcu_pending(cpu))
 		return false;
 
 	return true;
