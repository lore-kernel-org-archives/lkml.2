Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2BTGDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:03:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46093 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2BTGDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:03:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.130.150 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
MIME-Version: 1.0
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Venki Pallipadi <venki@google.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86 and ARM
Date: Mon, 20 Feb 2012 10:04:19 +0400
Message-Id: <1329717859-19378-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize CONFIG_IRQ_TIME_ACCOUNTING  between X86 and
ARM, move "noirqtime=" option to common debugging code.
For a bit of backward compatibility, X86-specific option
"tsc=noirqtime" is preserved, but issues a warning.

Suggested-by: Yong Zhang <yong.zhang0@gmail.com>
Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 Documentation/kernel-parameters.txt |    9 +++++----
 arch/arm/kernel/sched_clock.c       |    2 ++
 arch/x86/Kconfig                    |   11 -----------
 arch/x86/kernel/tsc.c               |   12 ++++++------
 include/linux/sched.h               |   17 ++++++++++-------
 kernel/sched/core.c                 |   21 ++++++++++++---------
 lib/Kconfig.debug                   |   12 ++++++++++++
 7 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..a5da255 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1790,6 +1790,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noirqdebug	[X86-32] Disables the code which attempts to detect and
 			disable unhandled interrupt sources.
 
+	noirqtime	[X86,ARM] Run time disables IRQ_TIME_ACCOUNTING and
+			eliminates the timestamping on irq/softirq entry/exit.
+
 	no_timer_check	[X86,APIC] Disables the code which tests for
 			broken timer IRQ sources.
 
@@ -2636,10 +2639,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			as the stability checks done at bootup.	Used to enable
 			high-resolution timer mode on older hardware, and in
 			virtualized environment.
-			[x86] noirqtime: Do not use TSC to do irq accounting.
-			Used to run time disable IRQ_TIME_ACCOUNTING on any
-			platforms where RDTSC is slow and this accounting
-			can add overhead.
+			[x86] noirqtime: obsoleted by "noirqtime" generic option,
+			see it's documentation for details.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 5416c7c..30b5f89 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -144,6 +144,8 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	 */
 	cd.epoch_ns = 0;
 
+	enable_sched_clock_irqtime();
+
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..4759676 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -805,17 +805,6 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
-config IRQ_TIME_ACCOUNTING
-	bool "Fine granularity task level IRQ time accounting"
-	default n
-	---help---
-	  Select this option to enable fine granularity task irq time
-	  accounting. This is done by reading a timestamp on each
-	  transitions between softirq and hardirq state, so there can be a
-	  small performance impact.
-
-	  If in doubt, say N here.
-
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..f1b2b63 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -103,14 +103,15 @@ int __init notsc_setup(char *str)
 
 __setup("notsc", notsc_setup);
 
-static int no_sched_irq_time;
-
 static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
-	if (!strncmp(str, "noirqtime", 9))
-		no_sched_irq_time = 1;
+	if (!strncmp(str, "noirqtime", 9)) {
+		printk(KERN_WARNING "tsc: tsc=noirqtime is "
+		       "obsolete, use noirqtime instead\n");
+		disable_sched_clock_irqtime();
+	}
 	return 1;
 }
 
@@ -978,8 +979,7 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
-	if (!no_sched_irq_time)
-		enable_sched_clock_irqtime();
+	enable_sched_clock_irqtime();
 
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..9b13f79 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1961,13 +1961,16 @@ extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-/*
- * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
- * The reason for this explicit opt-in is not to have perf penalty with
- * slow sched_clocks.
- */
-extern void enable_sched_clock_irqtime(void);
-extern void disable_sched_clock_irqtime(void);
+extern int sched_clock_irqtime;
+static inline void enable_sched_clock_irqtime(void)
+{
+	if (sched_clock_irqtime == -1)
+		sched_clock_irqtime = 1;
+}
+static inline void disable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 0;
+}
 #else
 static inline void enable_sched_clock_irqtime(void) {}
 static inline void disable_sched_clock_irqtime(void) {}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..4e7a197 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -757,18 +757,21 @@ static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
 
 static DEFINE_PER_CPU(u64, irq_start_time);
-static int sched_clock_irqtime;
 
-void enable_sched_clock_irqtime(void)
-{
-	sched_clock_irqtime = 1;
-}
+/*
+ * -1 if not initialized, 0 if disabled with "noirqtime" kernel option
+ * or after unstable clock was detected, 1 if enabled and active.
+ */
+__read_mostly int sched_clock_irqtime = -1;
 
-void disable_sched_clock_irqtime(void)
+static int __init irqtime_setup(char *str)
 {
 	sched_clock_irqtime = 0;
+	return 1;
 }
 
+__setup("noirqtime", irqtime_setup);
+
 #ifndef CONFIG_64BIT
 static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
 
@@ -822,7 +825,7 @@ void account_system_vtime(struct task_struct *curr)
 	s64 delta;
 	int cpu;
 
-	if (!sched_clock_irqtime)
+	if (sched_clock_irqtime < 1)
 		return;
 
 	local_irq_save(flags);
@@ -2853,7 +2856,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
-	if (sched_clock_irqtime) {
+	if (sched_clock_irqtime > 0) {
 		irqtime_account_process_tick(p, user_tick, rq);
 		return;
 	}
@@ -2887,7 +2890,7 @@ void account_steal_ticks(unsigned long ticks)
 void account_idle_ticks(unsigned long ticks)
 {
 
-	if (sched_clock_irqtime) {
+	if (sched_clock_irqtime > 0) {
 		irqtime_account_idle_ticks(ticks);
 		return;
 	}
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..236e814 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -299,6 +299,18 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	depends on X86 || ARM
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.7.7.6

