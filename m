Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab0JIAqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:46:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44576 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760054Ab0JIAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:46:30 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 7/7] sh: oprofile: Use perf-events oprofile backend
Date: Sat,  9 Oct 2010 01:46:22 +0100
Message-Id: <a0c83396f5fb8a29baff3daf43d29b2e601511ff.1286584677.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got a generic perf-events based oprofile backend we might
as well make use of it seeing as SH doesn't do anything special with its
oprofile backend. Also introduce a new CONFIG_HW_PERF_EVENTS symbol so
that we can fallback to using the timer interrupt for oprofile if the
CPU doesn't support perf events.

Also, to avoid a section mismatch warning we need to annotate
oprofile_arch_exit() with an __exit marker.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig            |   13 +++++
 arch/sh/oprofile/Makefile  |    4 ++
 arch/sh/oprofile/common.c  |  115 +++++++++-----------------------------------
 arch/sh/oprofile/op_impl.h |   33 -------------
 4 files changed, 40 insertions(+), 125 deletions(-)
 delete mode 100644 arch/sh/oprofile/op_impl.h

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 33990fa..35b6c3f 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -249,6 +249,11 @@ config ARCH_SHMOBILE
 	select PM
 	select PM_RUNTIME
 
+config CPU_HAS_PMU
+       depends on CPU_SH4 || CPU_SH4A
+       default y
+       bool
+
 if SUPERH32
 
 choice
@@ -738,6 +743,14 @@ config GUSA_RB
 	  LLSC, this should be more efficient than the other alternative of
 	  disabling interrupts around the atomic sequence.
 
+config HW_PERF_EVENTS
+	bool "Enable hardware performance counter support for perf events"
+	depends on PERF_EVENTS && CPU_HAS_PMU
+	default y
+	help
+	  Enable hardware performance counter support for perf events. If
+	  disabled, perf events will use software events only.
+
 source "drivers/sh/Kconfig"
 
 endmenu
diff --git a/arch/sh/oprofile/Makefile b/arch/sh/oprofile/Makefile
index 4886c5c..e85aae7 100644
--- a/arch/sh/oprofile/Makefile
+++ b/arch/sh/oprofile/Makefile
@@ -6,4 +6,8 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o \
 		timer_int.o )
 
+ifeq ($(CONFIG_HW_PERF_EVENTS),y)
+DRIVER_OBJS += $(addprefix ../../../drivers/oprofile/, oprofile_perf.o)
+endif
+
 oprofile-y	:= $(DRIVER_OBJS) common.o backtrace.o
diff --git a/arch/sh/oprofile/common.c b/arch/sh/oprofile/common.c
index ac60493..e10d893 100644
--- a/arch/sh/oprofile/common.c
+++ b/arch/sh/oprofile/common.c
@@ -17,114 +17,45 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/smp.h>
+#include <linux/perf_event.h>
 #include <asm/processor.h>
-#include "op_impl.h"
-
-static struct op_sh_model *model;
-
-static struct op_counter_config ctr[20];
 
+#ifdef CONFIG_HW_PERF_EVENTS
 extern void sh_backtrace(struct pt_regs * const regs, unsigned int depth);
 
-static int op_sh_setup(void)
-{
-	/* Pre-compute the values to stuff in the hardware registers.  */
-	model->reg_setup(ctr);
-
-	/* Configure the registers on all cpus.  */
-	on_each_cpu(model->cpu_setup, NULL, 1);
-
-        return 0;
-}
-
-static int op_sh_create_files(struct super_block *sb, struct dentry *root)
+char *op_name_from_perf_id(void)
 {
-	int i, ret = 0;
+	const char *pmu;
+	char buf[20];
+	int size;
 
-	for (i = 0; i < model->num_counters; i++) {
-		struct dentry *dir;
-		char buf[4];
+	pmu = perf_pmu_name();
+	if (!pmu)
+		return NULL;
 
-		snprintf(buf, sizeof(buf), "%d", i);
-		dir = oprofilefs_mkdir(sb, root, buf);
+	size = snprintf(buf, sizeof(buf), "sh/%s", pmu);
+	if (size > -1 && size < sizeof(buf))
+		return buf;
 
-		ret |= oprofilefs_create_ulong(sb, dir, "enabled", &ctr[i].enabled);
-		ret |= oprofilefs_create_ulong(sb, dir, "event", &ctr[i].event);
-		ret |= oprofilefs_create_ulong(sb, dir, "kernel", &ctr[i].kernel);
-		ret |= oprofilefs_create_ulong(sb, dir, "user", &ctr[i].user);
-
-		if (model->create_files)
-			ret |= model->create_files(sb, dir);
-		else
-			ret |= oprofilefs_create_ulong(sb, dir, "count", &ctr[i].count);
-
-		/* Dummy entries */
-		ret |= oprofilefs_create_ulong(sb, dir, "unit_mask", &ctr[i].unit_mask);
-	}
-
-	return ret;
+	return NULL;
 }
 
-static int op_sh_start(void)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
-	/* Enable performance monitoring for all counters.  */
-	on_each_cpu(model->cpu_start, NULL, 1);
+	ops->backtrace = sh_backtrace;
 
-	return 0;
+	return oprofile_perf_init(ops);
 }
 
-static void op_sh_stop(void)
+void __exit oprofile_arch_exit(void)
 {
-	/* Disable performance monitoring for all counters.  */
-	on_each_cpu(model->cpu_stop, NULL, 1);
+	oprofile_perf_exit();
 }
-
+#else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
-	struct op_sh_model *lmodel = NULL;
-	int ret;
-
-	/*
-	 * Always assign the backtrace op. If the counter initialization
-	 * fails, we fall back to the timer which will still make use of
-	 * this.
-	 */
-	ops->backtrace = sh_backtrace;
-
-	/*
-	 * XXX
-	 *
-	 * All of the SH7750/SH-4A counters have been converted to perf,
-	 * this infrastructure hook is left for other users until they've
-	 * had a chance to convert over, at which point all of this
-	 * will be deleted.
-	 */
-
-	if (!lmodel)
-		return -ENODEV;
-	if (!(current_cpu_data.flags & CPU_HAS_PERF_COUNTER))
-		return -ENODEV;
-
-	ret = lmodel->init();
-	if (unlikely(ret != 0))
-		return ret;
-
-	model = lmodel;
-
-	ops->setup		= op_sh_setup;
-	ops->create_files	= op_sh_create_files;
-	ops->start		= op_sh_start;
-	ops->stop		= op_sh_stop;
-	ops->cpu_type		= lmodel->cpu_type;
-
-	printk(KERN_INFO "oprofile: using %s performance monitoring.\n",
-	       lmodel->cpu_type);
-
-	return 0;
-}
-
-void oprofile_arch_exit(void)
-{
-	if (model && model->exit)
-		model->exit();
+	pr_info("oprofile: hardware counters not available\n");
+	return -ENODEV;
 }
+void __exit oprofile_arch_exit(void) {}
+#endif /* CONFIG_HW_PERF_EVENTS */
diff --git a/arch/sh/oprofile/op_impl.h b/arch/sh/oprofile/op_impl.h
deleted file mode 100644
index 1244479..0000000
--- a/arch/sh/oprofile/op_impl.h
+++ /dev/null
@@ -1,33 +0,0 @@
-#ifndef __OP_IMPL_H
-#define __OP_IMPL_H
-
-/* Per-counter configuration as set via oprofilefs.  */
-struct op_counter_config {
-	unsigned long enabled;
-	unsigned long event;
-
-	unsigned long count;
-
-	/* Dummy values for userspace tool compliance */
-	unsigned long kernel;
-	unsigned long user;
-	unsigned long unit_mask;
-};
-
-/* Per-architecture configury and hooks.  */
-struct op_sh_model {
-	void (*reg_setup)(struct op_counter_config *);
-	int (*create_files)(struct super_block *sb, struct dentry *dir);
-	void (*cpu_setup)(void *dummy);
-	int (*init)(void);
-	void (*exit)(void);
-	void (*cpu_start)(void *args);
-	void (*cpu_stop)(void *args);
-	char *cpu_type;
-	unsigned char num_counters;
-};
-
-/* arch/sh/oprofile/common.c */
-extern void sh_backtrace(struct pt_regs * const regs, unsigned int depth);
-
-#endif /* __OP_IMPL_H */
-- 
1.7.1

