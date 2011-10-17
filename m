Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1JQOgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:36:48 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:39213
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab1JQOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:35:29 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LT7SIY-01-BYY-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] oprofile, x86: Reimplement nmi timer mode using perf
Date: Mon, 17 Oct 2011 16:27:04 +0200
Message-ID: <1318861624-715-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318861624-715-1-git-send-email-robert.richter@amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy x86 nmi watchdog code was removed with the implementation
of the perf based nmi watchdog. This broke Oprofile's nmi timer
mode. To run nmi timer mode we relied on a continuous ticking nmi
source which the nmi watchdog provided. The nmi tick was no longer
available and current watchdog can not be used anymore since it runs
with very long periods in the range of seconds. This patch
reimplements the nmi timer mode using a perf counter nmi source.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig                      |    4 +
 arch/x86/oprofile/Makefile        |    3 +-
 arch/x86/oprofile/nmi_timer_int.c |   66 --------------
 drivers/oprofile/nmi_timer_int.c  |  172 +++++++++++++++++++++++++++++++++++++
 drivers/oprofile/oprof.c          |   14 ++-
 drivers/oprofile/oprof.h          |    9 ++
 kernel/events/core.c              |    2 +
 7 files changed, 198 insertions(+), 72 deletions(-)
 delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
 create mode 100644 drivers/oprofile/nmi_timer_int.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 4b0669c..f01f75c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -30,6 +30,10 @@ config OPROFILE_EVENT_MULTIPLEX
 config HAVE_OPROFILE
 	bool
 
+config OPROFILE_NMI_TIMER
+	def_bool y
+	def_bool PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+
 config KPROBES
 	bool "Kprobes"
 	depends on MODULES
diff --git a/arch/x86/oprofile/Makefile b/arch/x86/oprofile/Makefile
index 446902b..1599f56 100644
--- a/arch/x86/oprofile/Makefile
+++ b/arch/x86/oprofile/Makefile
@@ -4,9 +4,8 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprof.o cpu_buffer.o buffer_sync.o \
 		event_buffer.o oprofile_files.o \
 		oprofilefs.o oprofile_stats.o  \
-		timer_int.o )
+		timer_int.o nmi_timer_int.o )
 
 oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
 oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_amd.o \
 					   op_model_ppro.o op_model_p4.o
-oprofile-$(CONFIG_X86_IO_APIC)		+= nmi_timer_int.o
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
deleted file mode 100644
index 720bf5a..0000000
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ /dev/null
@@ -1,66 +0,0 @@
-/**
- * @file nmi_timer_int.c
- *
- * @remark Copyright 2003 OProfile authors
- * @remark Read the file COPYING
- *
- * @author Zwane Mwaikambo <zwane@linuxpower.ca>
- */
-
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/errno.h>
-#include <linux/oprofile.h>
-#include <linux/rcupdate.h>
-#include <linux/kdebug.h>
-
-#include <asm/nmi.h>
-#include <asm/apic.h>
-#include <asm/ptrace.h>
-
-static int profile_timer_exceptions_notify(struct notifier_block *self,
-					   unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	switch (val) {
-	case DIE_NMI:
-		oprofile_add_sample(args->regs, 0);
-		ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-static struct notifier_block profile_timer_exceptions_nb = {
-	.notifier_call = profile_timer_exceptions_notify,
-	.next = NULL,
-	.priority = NMI_LOW_PRIOR,
-};
-
-static int timer_start(void)
-{
-	if (register_die_notifier(&profile_timer_exceptions_nb))
-		return 1;
-	return 0;
-}
-
-
-static void timer_stop(void)
-{
-	unregister_die_notifier(&profile_timer_exceptions_nb);
-	synchronize_sched();  /* Allow already-started NMIs to complete. */
-}
-
-
-int __init op_nmi_timer_init(struct oprofile_operations *ops)
-{
-	ops->start = timer_start;
-	ops->stop = timer_stop;
-	ops->cpu_type = "timer";
-	printk(KERN_INFO "oprofile: using NMI timer interrupt.\n");
-	return 0;
-}
diff --git a/drivers/oprofile/nmi_timer_int.c b/drivers/oprofile/nmi_timer_int.c
new file mode 100644
index 0000000..b76c6d7
--- /dev/null
+++ b/drivers/oprofile/nmi_timer_int.c
@@ -0,0 +1,172 @@
+/**
+ * @file nmi_timer_int.c
+ *
+ * @remark Copyright 2011 Advanced Micro Devices, Inc.
+ *
+ * @author Robert Richter <robert.richter@amd.com>
+ */
+
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/oprofile.h>
+#include <linux/perf_event.h>
+
+#ifdef CONFIG_OPROFILE_NMI_TIMER
+
+static DEFINE_PER_CPU(struct perf_event *, nmi_timer_events);
+static int ctr_running;
+
+static struct perf_event_attr nmi_timer_attr = {
+	.type           = PERF_TYPE_HARDWARE,
+	.config         = PERF_COUNT_HW_CPU_CYCLES,
+	.size           = sizeof(struct perf_event_attr),
+	.pinned         = 1,
+	.disabled       = 1,
+};
+
+static void nmi_timer_callback(struct perf_event *event,
+			       struct perf_sample_data *data,
+			       struct pt_regs *regs)
+{
+	event->hw.interrupts = 0;       /* don't throttle interrupts */
+	oprofile_add_sample(regs, 0);
+}
+
+static int nmi_timer_start_cpu(int cpu)
+{
+	struct perf_event *event = per_cpu(nmi_timer_events, cpu);
+
+	if (!event) {
+		event = perf_event_create_kernel_counter(&nmi_timer_attr, cpu, NULL,
+							 nmi_timer_callback, NULL);
+		if (IS_ERR(event))
+			return PTR_ERR(event);
+		per_cpu(nmi_timer_events, cpu) = event;
+	}
+
+	if (event && ctr_running)
+		perf_event_enable(event);
+
+	return 0;
+}
+
+static void nmi_timer_stop_cpu(int cpu)
+{
+	struct perf_event *event = per_cpu(nmi_timer_events, cpu);
+
+	if (event && ctr_running)
+		perf_event_disable(event);
+}
+
+static int nmi_timer_cpu_notifier(struct notifier_block *b, unsigned long action,
+				  void *data)
+{
+	int cpu = (unsigned long)data;
+	switch (action) {
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		nmi_timer_start_cpu(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		nmi_timer_stop_cpu(cpu);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block __cpuinitdata nmi_timer_cpu_nb = {
+	.notifier_call = nmi_timer_cpu_notifier
+};
+
+static int nmi_timer_start(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	ctr_running = 1;
+	for_each_online_cpu(cpu)
+		nmi_timer_start_cpu(cpu);
+	put_online_cpus();
+
+	return 0;
+}
+
+static void nmi_timer_stop(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		nmi_timer_stop_cpu(cpu);
+	ctr_running = 0;
+	put_online_cpus();
+}
+
+static void nmi_timer_shutdown(void)
+{
+	struct perf_event *event;
+	int cpu;
+
+	get_online_cpus();
+	unregister_cpu_notifier(&nmi_timer_cpu_nb);
+	for_each_possible_cpu(cpu) {
+		event = per_cpu(nmi_timer_events, cpu);
+		if (!event)
+			continue;
+		perf_event_disable(event);
+		per_cpu(nmi_timer_events, cpu) = NULL;
+		perf_event_release_kernel(event);
+	}
+
+	put_online_cpus();
+}
+
+static int nmi_timer_setup(void)
+{
+	int cpu, err;
+
+	/* clock cycles per tick: */
+	nmi_timer_attr.sample_period = (u64)cpu_khz * TICK_NSEC / NSEC_PER_MSEC;
+	pr_info("sample_period: %lld, cpu_khz: %d, nsec/tick: %ld\n",
+		nmi_timer_attr.sample_period, cpu_khz, TICK_NSEC);
+
+	get_online_cpus();
+	err = register_cpu_notifier(&nmi_timer_cpu_nb);
+	if (err)
+		goto out;
+	/* can't attach events to offline cpus: */
+	for_each_online_cpu(cpu) {
+		err = nmi_timer_start_cpu(cpu);
+		if (err)
+			break;
+	}
+	if (err)
+		nmi_timer_shutdown();
+out:
+	put_online_cpus();
+	return err;
+}
+
+int __init op_nmi_timer_init(struct oprofile_operations *ops)
+{
+	int err = 0;
+
+	err = nmi_timer_setup();
+	if (err)
+		return err;
+	nmi_timer_shutdown();		/* only check, don't alloc */
+
+	ops->create_files	= NULL;
+	ops->setup		= nmi_timer_setup;
+	ops->shutdown		= nmi_timer_shutdown;
+	ops->start		= nmi_timer_start;
+	ops->stop		= nmi_timer_stop;
+	ops->cpu_type		= "timer";
+
+	printk(KERN_INFO "oprofile: using NMI timer interrupt.\n");
+
+	return 0;
+}
+
+#endif
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index f7cd069..af9cbea 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -248,15 +248,21 @@ static int __init oprofile_init(void)
 	/* always init architecture to setup backtrace support */
 	err = oprofile_arch_init(&oprofile_ops);
 
-	timer_mode = err || timer;	/* fall back to timer mode on errors */
+	timer_mode = err || timer;
 	if (timer_mode) {
 		if (!err)
 			oprofile_arch_exit();
-		err = oprofile_timer_init(&oprofile_ops);
-		if (err)
-			return err;
+		/* no nmi timer mode if oprofile.timer is set: */
+		if (!timer)
+			err = op_nmi_timer_init(&oprofile_ops);
+		/* fall back to timer mode on errors: */
+		if (err || timer)
+			err = oprofile_timer_init(&oprofile_ops);
 	}
 
+	if (err)
+		return err;
+
 	err = oprofilefs_register();
 	if (!err)
 		return 0;
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 177b73d..769fb0f 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -36,6 +36,15 @@ struct dentry;
 void oprofile_create_files(struct super_block *sb, struct dentry *root);
 int oprofile_timer_init(struct oprofile_operations *ops);
 void oprofile_timer_exit(void);
+#ifdef CONFIG_OPROFILE_NMI_TIMER
+int op_nmi_timer_init(struct oprofile_operations *ops);
+#else
+static inline int op_nmi_timer_init(struct oprofile_operations *ops)
+{
+	return -ENODEV;
+}
+#endif
+
 
 int oprofile_set_ulong(unsigned long *addr, unsigned long val);
 int oprofile_set_timeout(unsigned long time);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d1a1bee..d2e28bd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1322,6 +1322,7 @@ retry:
 	}
 	raw_spin_unlock_irq(&ctx->lock);
 }
+EXPORT_SYMBOL_GPL(perf_event_disable);
 
 static void perf_set_shadow_time(struct perf_event *event,
 				 struct perf_event_context *ctx,
@@ -1806,6 +1807,7 @@ retry:
 out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
+EXPORT_SYMBOL_GPL(perf_event_enable);
 
 int perf_event_refresh(struct perf_event *event, int refresh)
 {
-- 
1.7.7


