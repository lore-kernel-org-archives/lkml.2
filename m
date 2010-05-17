Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0EQWHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0EQWHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:07:00 -0400
From: Don Zickus <dzickus@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] [watchdog] re-introduce support for nmi_watchdog, nosoftlockup
Date: Mon, 17 May 2010 18:06:06 -0400
Message-Id: <1274133966-18415-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
References: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These options broke during this rewrite.  The previous patch cleaned
up the internals.  This patch actually uses those changes to allow
one to properly use nmi_watchdog=0 and nosoftlockup from the kernel
commandline and the bash shell.

The downside of these changes is I removed the global option of
'watchdog' that would have enabled/disabled both the hardlockup
and softlockup detector (as if they were one).

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    2 -
 include/linux/nmi.h        |    4 +-
 kernel/sysctl.c            |   15 +++++-
 kernel/watchdog.c          |  103 ++++++++++++++++++++++++++-----------------
 4 files changed, 76 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 932f0f8..93da9c3 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -17,9 +17,7 @@ int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
-#if !defined(CONFIG_LOCKUP_DETECTOR)
 extern int nmi_watchdog_enabled;
-#endif
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 06aab5e..d075b3a 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -54,9 +54,9 @@ static inline bool trigger_all_cpu_backtrace(void)
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(void);
-extern int watchdog_enabled;
+extern int softlockup_watchdog_enabled;
 struct ctl_table;
-extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
+extern int proc_softlockup_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 #endif
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 04bcd8a..e856655 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -688,11 +688,11 @@ static struct ctl_table kern_table[] = {
 	},
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
-		.procname       = "watchdog",
-		.data           = &watchdog_enabled,
+		.procname       = "softlockup_watchdog",
+		.data           = &softlockup_watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog_enabled,
+		.proc_handler   = proc_softlockup_enabled
 	},
 	{
 		.procname	= "watchdog_thresh",
@@ -712,6 +712,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	{
+		.procname       = "nmi_watchdog",
+		.data           = &nmi_watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_nmi_enabled,
+	},
+#endif
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
 	{
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 0a6bdb7..f3c63a8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -27,7 +27,6 @@
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
-int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
 typedef void (*callback_t)(void);
@@ -47,7 +46,14 @@ static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
 static int __read_mostly did_panic;
-static int __initdata no_watchdog;
+
+#define LOCKUP_DETECT_DISABLED	-1
+#define LOCKUP_DETECT_OFF	0
+#define LOCKUP_DETECT_ON	1
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+int nmi_watchdog_enabled = LOCKUP_DETECT_OFF;
+#endif
+int softlockup_watchdog_enabled = LOCKUP_DETECT_OFF;
 
 
 /* boot commands */
@@ -59,8 +65,19 @@ static int hardlockup_panic;
 
 static int __init hardlockup_panic_setup(char *str)
 {
-	if (!strncmp(str, "panic", 5))
+	unsigned int nmi;
+
+	if (!strncmp(str, "panic", 5)) {
 		hardlockup_panic = 1;
+		str = strchr(str, ',');
+		if (!str)
+			return 1;
+		++str;
+	}
+	get_option(&str, &nmi);
+	if (nmi == 0)
+		nmi_watchdog_enabled = LOCKUP_DETECT_DISABLED;
+
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -77,21 +94,12 @@ static int __init softlockup_panic_setup(char *str)
 }
 __setup("softlockup_panic=", softlockup_panic_setup);
 
-static int __init nowatchdog_setup(char *str)
-{
-	no_watchdog = 1;
-	return 1;
-}
-__setup("nowatchdog", nowatchdog_setup);
-
-/* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	no_watchdog = 1;
+	softlockup_watchdog_enabled = LOCKUP_DETECT_DISABLED;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
-/*  */
 
 
 /*
@@ -338,6 +346,7 @@ static int watchdog(void *unused)
 		      HRTIMER_MODE_REL_PINNED);
 
 	set_current_state(TASK_INTERRUPTIBLE);
+
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 60 seconds then the
@@ -364,6 +373,10 @@ static int watchdog_nmi_enable(int cpu)
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/* boot param says don't enable */
+	if (nmi_watchdog_enabled == LOCKUP_DETECT_DISABLED)
+		return 0;
+
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -390,6 +403,7 @@ out_save:
 out_enable:
 	perf_event_enable(per_cpu(watchdog_ev, cpu));
 out:
+	nmi_watchdog_enabled = LOCKUP_DETECT_ON;
 	return 0;
 }
 
@@ -414,8 +428,13 @@ static void watchdog_nmi_disable(int cpu) { return; }
 static int watchdog_softlockup_enable(int cpu)
 {
 	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	/* skip if DISABLED */
+	if (softlockup_watchdog_enabled == LOCKUP_DETECT_DISABLED)
+		return 0;
+
 	per_cpu(softlockup_callback, cpu) = watchdog_softlockup_callback;
 	wake_up_process(per_cpu(watchdog_thread, cpu));
+	softlockup_watchdog_enabled = LOCKUP_DETECT_ON;
 
 	return 0;
 }
@@ -491,46 +510,51 @@ static void watchdog_disable(int cpu)
 	}
 }
 
-static void watchdog_enable_all_cpus(void)
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
+/*
+ * proc handler for /proc/sys/kernel/nmi_watchdog
+ */
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+int proc_nmi_enabled(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int cpu;
-	int result;
+	int result=0;
+
+	proc_dointvec(table, write, buffer, length, ppos);
 
 	for_each_online_cpu(cpu)
-		result += watchdog_enable(cpu);
+		if (nmi_watchdog_enabled)
+			result += watchdog_nmi_enable(cpu);
+		else
+			watchdog_nmi_disable(cpu);
 
 	if (result)
-		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
+		printk(KERN_ERR "watchdog: hardlockup failed to be enabled on some cpus\n");
 
+	return 0;
 }
+#endif
 
-static void watchdog_disable_all_cpus(void)
+int proc_softlockup_enabled(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int cpu;
+	int result=0;
 
-	for_each_online_cpu(cpu)
-		watchdog_disable(cpu);
-
-	/* if all watchdogs are disabled, then they are disabled for the system */
-	watchdog_enabled = 0;
-}
-
+	proc_dointvec(table, write, buffer, length, ppos);
 
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
-/*
- * proc handler for /proc/sys/kernel/nmi_watchdog
- */
+	for_each_online_cpu(cpu)
+		if (softlockup_watchdog_enabled)
+			result += watchdog_softlockup_enable(cpu);
+		else
+			watchdog_softlockup_disable(cpu);
 
-int proc_dowatchdog_enabled(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *length, loff_t *ppos)
-{
-	proc_dointvec(table, write, buffer, length, ppos);
+	if (result)
+		printk(KERN_ERR "watchdog: softlockup failed to be enabled on some cpus\n");
 
-	if (watchdog_enabled)
-		watchdog_enable_all_cpus();
-	else
-		watchdog_disable_all_cpus();
 	return 0;
 }
 
@@ -585,9 +609,6 @@ static int __init spawn_watchdog_task(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	if (no_watchdog)
-		return 0;
-
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(err == NOTIFY_BAD);
 
-- 
1.7.0.1

