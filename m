Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab0JDUof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:44:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46794 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab0JDUod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:44:33 -0400
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
Subject: [PATCH 5/7] oprofile: Abstract the perf-events backend
Date: Mon,  4 Oct 2010 21:44:23 +0100
Message-Id: <f1c48cb70de8129566db8a9196bcf3a3bc500aa8.1286222593.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286222593.git.matt@console-pimps.org>
References: <cover.1286222593.git.matt@console-pimps.org>
In-Reply-To: <cover.1286222593.git.matt@console-pimps.org>
References: <cover.1286222593.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the perf-events backend from arch/arm/oprofile into
drivers/oprofile so that the code can be shared between architectures.

This allows each architecture to maintain only a single copy of the PMU
accessor functions instead of one for both perf and OProfile. It also
becomes possible for other architectures to delete much of their
OProfile code in favour of the common code now available in
drivers/oprofile/oprofile_perf.c.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Tested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/Makefile       |    4 +
 arch/arm/oprofile/common.c       |  319 -------------------------------------
 drivers/oprofile/oprofile_perf.c |  326 ++++++++++++++++++++++++++++++++++++++
 include/linux/oprofile.h         |    6 +
 4 files changed, 336 insertions(+), 319 deletions(-)
 create mode 100644 drivers/oprofile/oprofile_perf.c

diff --git a/arch/arm/oprofile/Makefile b/arch/arm/oprofile/Makefile
index e666eaf..b2215c6 100644
--- a/arch/arm/oprofile/Makefile
+++ b/arch/arm/oprofile/Makefile
@@ -6,4 +6,8 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o \
 		timer_int.o )
 
+ifeq ($(CONFIG_HW_PERF_EVENTS),y)
+DRIVER_OBJS += $(addprefix ../../../drivers/oprofile/, oprofile_perf.o)
+endif
+
 oprofile-y				:= $(DRIVER_OBJS) common.o
diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index e4cd332..c6ffdc4 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -25,246 +25,6 @@
 #include <asm/ptrace.h>
 
 #ifdef CONFIG_HW_PERF_EVENTS
-/*
- * Per performance monitor configuration as set via oprofilefs.
- */
-struct op_counter_config {
-	unsigned long count;
-	unsigned long enabled;
-	unsigned long event;
-	unsigned long unit_mask;
-	unsigned long kernel;
-	unsigned long user;
-	struct perf_event_attr attr;
-};
-
-static int oprofile_perf_enabled;
-static DEFINE_MUTEX(oprofile_perf_mutex);
-
-static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[nr_cpumask_bits];
-static int perf_nr_counters;
-
-/*
- * Overflow callback for oprofile.
- */
-static void op_overflow_handler(struct perf_event *event, int unused,
-			struct perf_sample_data *data, struct pt_regs *regs)
-{
-	int id;
-	u32 cpu = smp_processor_id();
-
-	for (id = 0; id < perf_nr_counters; ++id)
-		if (perf_events[cpu][id] == event)
-			break;
-
-	if (id != perf_nr_counters)
-		oprofile_add_sample(regs, id);
-	else
-		pr_warning("oprofile: ignoring spurious overflow "
-				"on cpu %u\n", cpu);
-}
-
-/*
- * Called by oprofile_perf_setup to create perf attributes to mirror the oprofile
- * settings in counter_config. Attributes are created as `pinned' events and
- * so are permanently scheduled on the PMU.
- */
-static void op_perf_setup(void)
-{
-	int i;
-	u32 size = sizeof(struct perf_event_attr);
-	struct perf_event_attr *attr;
-
-	for (i = 0; i < perf_nr_counters; ++i) {
-		attr = &counter_config[i].attr;
-		memset(attr, 0, size);
-		attr->type		= PERF_TYPE_RAW;
-		attr->size		= size;
-		attr->config		= counter_config[i].event;
-		attr->sample_period	= counter_config[i].count;
-		attr->pinned		= 1;
-	}
-}
-
-static int op_create_counter(int cpu, int event)
-{
-	int ret = 0;
-	struct perf_event *pevent;
-
-	if (!counter_config[event].enabled || (perf_events[cpu][event] != NULL))
-		return ret;
-
-	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
-						  cpu, -1,
-						  op_overflow_handler);
-
-	if (IS_ERR(pevent)) {
-		ret = PTR_ERR(pevent);
-	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
-		pr_warning("oprofile: failed to enable event %d "
-				"on CPU %d\n", event, cpu);
-		ret = -EBUSY;
-	} else {
-		perf_events[cpu][event] = pevent;
-	}
-
-	return ret;
-}
-
-static void op_destroy_counter(int cpu, int event)
-{
-	struct perf_event *pevent = perf_events[cpu][event];
-
-	if (pevent) {
-		perf_event_release_kernel(pevent);
-		perf_events[cpu][event] = NULL;
-	}
-}
-
-/*
- * Called by oprofile_perf_start to create active perf events based on the
- * perviously configured attributes.
- */
-static int op_perf_start(void)
-{
-	int cpu, event, ret = 0;
-
-	for_each_online_cpu(cpu) {
-		for (event = 0; event < perf_nr_counters; ++event) {
-			ret = op_create_counter(cpu, event);
-			if (ret)
-				goto out;
-		}
-	}
-
-out:
-	return ret;
-}
-
-/*
- * Called by oprofile_perf_stop at the end of a profiling run.
- */
-static void op_perf_stop(void)
-{
-	int cpu, event;
-
-	for_each_online_cpu(cpu)
-		for (event = 0; event < perf_nr_counters; ++event)
-			op_destroy_counter(cpu, event);
-}
-
-
-static int oprofile_perf_create_files(struct super_block *sb, struct dentry *root)
-{
-	unsigned int i;
-
-	for (i = 0; i < perf_nr_counters; i++) {
-		struct dentry *dir;
-		char buf[4];
-
-		snprintf(buf, sizeof buf, "%d", i);
-		dir = oprofilefs_mkdir(sb, root, buf);
-		oprofilefs_create_ulong(sb, dir, "enabled", &counter_config[i].enabled);
-		oprofilefs_create_ulong(sb, dir, "event", &counter_config[i].event);
-		oprofilefs_create_ulong(sb, dir, "count", &counter_config[i].count);
-		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
-		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
-		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
-	}
-
-	return 0;
-}
-
-static int oprofile_perf_setup(void)
-{
-	spin_lock(&oprofilefs_lock);
-	op_perf_setup();
-	spin_unlock(&oprofilefs_lock);
-	return 0;
-}
-
-static int oprofile_perf_start(void)
-{
-	int ret = -EBUSY;
-
-	mutex_lock(&oprofile_perf_mutex);
-	if (!oprofile_perf_enabled) {
-		ret = 0;
-		op_perf_start();
-		oprofile_perf_enabled = 1;
-	}
-	mutex_unlock(&oprofile_perf_mutex);
-	return ret;
-}
-
-static void oprofile_perf_stop(void)
-{
-	mutex_lock(&oprofile_perf_mutex);
-	if (oprofile_perf_enabled)
-		op_perf_stop();
-	oprofile_perf_enabled = 0;
-	mutex_unlock(&oprofile_perf_mutex);
-}
-
-#ifdef CONFIG_PM
-static int oprofile_perf_suspend(struct platform_device *dev, pm_message_t state)
-{
-	mutex_lock(&oprofile_perf_mutex);
-	if (oprofile_perf_enabled)
-		op_perf_stop();
-	mutex_unlock(&oprofile_perf_mutex);
-	return 0;
-}
-
-static int oprofile_perf_resume(struct platform_device *dev)
-{
-	mutex_lock(&oprofile_perf_mutex);
-	if (oprofile_perf_enabled && op_perf_start())
-		oprofile_perf_enabled = 0;
-	mutex_unlock(&oprofile_perf_mutex);
-	return 0;
-}
-
-static struct platform_driver oprofile_driver = {
-	.driver		= {
-		.name		= "oprofile-perf",
-	},
-	.resume		= oprofile_perf_resume,
-	.suspend	= oprofile_perf_suspend,
-};
-
-static struct platform_device *oprofile_pdev;
-
-static int __init init_driverfs(void)
-{
-	int ret;
-
-	ret = platform_driver_register(&oprofile_driver);
-	if (ret)
-		goto out;
-
-	oprofile_pdev =	platform_device_register_simple(
-				oprofile_driver.driver.name, 0, NULL, 0);
-	if (IS_ERR(oprofile_pdev)) {
-		ret = PTR_ERR(oprofile_pdev);
-		platform_driver_unregister(&oprofile_driver);
-	}
-
-out:
-	return ret;
-}
-
-static void __exit exit_driverfs(void)
-{
-	platform_device_unregister(oprofile_pdev);
-	platform_driver_unregister(&oprofile_driver);
-}
-#else
-static int __init init_driverfs(void) { return 0; }
-#define exit_driverfs() do { } while (0)
-#endif /* CONFIG_PM */
-
 static int report_trace(struct stackframe *frame, void *d)
 {
 	unsigned int *depth = d;
@@ -327,66 +87,6 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 		tail = user_backtrace(tail);
 }
 
-int __init oprofile_perf_init(struct oprofile_operations *ops)
-{
-	int cpu, ret = 0;
-
-	memset(&perf_events, 0, sizeof(perf_events));
-
-	perf_nr_counters = perf_num_counters();
-	if (perf_nr_counters <= 0) {
-		pr_info("oprofile: no performance counters\n");
-		ret = -ENODEV;
-		goto out;
-	}
-
-	counter_config = kcalloc(perf_nr_counters,
-			sizeof(struct op_counter_config), GFP_KERNEL);
-
-	if (!counter_config) {
-		pr_info("oprofile: failed to allocate %d "
-				"counters\n", perf_nr_counters);
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = init_driverfs();
-	if (ret)
-		goto out;
-
-	for_each_possible_cpu(cpu) {
-		perf_events[cpu] = kcalloc(perf_nr_counters,
-				sizeof(struct perf_event *), GFP_KERNEL);
-		if (!perf_events[cpu]) {
-			pr_info("oprofile: failed to allocate %d perf events "
-					"for cpu %d\n", perf_nr_counters, cpu);
-			ret = -ENOMEM;
-			goto out;
-		}
-	}
-
-	ops->create_files	= oprofile_perf_create_files;
-	ops->setup		= oprofile_perf_setup;
-	ops->start		= oprofile_perf_start;
-	ops->stop		= oprofile_perf_stop;
-	ops->shutdown		= oprofile_perf_stop;
-	ops->cpu_type		= perf_pmu_name();
-
-	if (!ops->cpu_type)
-		ret = -ENODEV;
-	else
-		pr_info("oprofile: using %s\n", ops->cpu_type);
-
-out:
-	if (ret) {
-		for_each_possible_cpu(cpu)
-			kfree(perf_events[cpu]);
-		kfree(counter_config);
-	}
-
-	return ret;
-}
-
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	ops->backtrace		= arm_backtrace;
@@ -394,25 +94,6 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_perf_exit(void)
-{
-	int cpu, id;
-	struct perf_event *event;
-
-	for_each_possible_cpu(cpu) {
-		for (id = 0; id < perf_nr_counters; ++id) {
-			event = perf_events[cpu][id];
-			if (event)
-				perf_event_release_kernel(event);
-		}
-
-		kfree(perf_events[cpu]);
-	}
-
-	kfree(counter_config);
-	exit_driverfs();
-}
-
 void __exit oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
new file mode 100644
index 0000000..237d5f4
--- /dev/null
+++ b/drivers/oprofile/oprofile_perf.c
@@ -0,0 +1,326 @@
+/*
+ * Copyright 2010 ARM Ltd.
+ *
+ * Perf-events backend for OProfile.
+ */
+#include <linux/perf_event.h>
+#include <linux/oprofile.h>
+#include <linux/slab.h>
+
+/*
+ * Per performance monitor configuration as set via oprofilefs.
+ */
+struct op_counter_config {
+	unsigned long count;
+	unsigned long enabled;
+	unsigned long event;
+	unsigned long unit_mask;
+	unsigned long kernel;
+	unsigned long user;
+	struct perf_event_attr attr;
+};
+
+static int oprofile_perf_enabled;
+static DEFINE_MUTEX(oprofile_perf_mutex);
+
+static struct op_counter_config *counter_config;
+static struct perf_event **perf_events[nr_cpumask_bits];
+static int perf_nr_counters;
+
+/*
+ * Overflow callback for oprofile.
+ */
+static void op_overflow_handler(struct perf_event *event, int unused,
+			struct perf_sample_data *data, struct pt_regs *regs)
+{
+	int id;
+	u32 cpu = smp_processor_id();
+
+	for (id = 0; id < perf_nr_counters; ++id)
+		if (perf_events[cpu][id] == event)
+			break;
+
+	if (id != perf_nr_counters)
+		oprofile_add_sample(regs, id);
+	else
+		pr_warning("oprofile: ignoring spurious overflow "
+				"on cpu %u\n", cpu);
+}
+
+/*
+ * Called by oprofile_perf_setup to create perf attributes to mirror the oprofile
+ * settings in counter_config. Attributes are created as `pinned' events and
+ * so are permanently scheduled on the PMU.
+ */
+static void op_perf_setup(void)
+{
+	int i;
+	u32 size = sizeof(struct perf_event_attr);
+	struct perf_event_attr *attr;
+
+	for (i = 0; i < perf_nr_counters; ++i) {
+		attr = &counter_config[i].attr;
+		memset(attr, 0, size);
+		attr->type		= PERF_TYPE_RAW;
+		attr->size		= size;
+		attr->config		= counter_config[i].event;
+		attr->sample_period	= counter_config[i].count;
+		attr->pinned		= 1;
+	}
+}
+
+static int op_create_counter(int cpu, int event)
+{
+	int ret = 0;
+	struct perf_event *pevent;
+
+	if (!counter_config[event].enabled || (perf_events[cpu][event] != NULL))
+		return ret;
+
+	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
+						  cpu, -1,
+						  op_overflow_handler);
+
+	if (IS_ERR(pevent)) {
+		ret = PTR_ERR(pevent);
+	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
+		pr_warning("oprofile: failed to enable event %d "
+				"on CPU %d\n", event, cpu);
+		ret = -EBUSY;
+	} else {
+		perf_events[cpu][event] = pevent;
+	}
+
+	return ret;
+}
+
+static void op_destroy_counter(int cpu, int event)
+{
+	struct perf_event *pevent = perf_events[cpu][event];
+
+	if (pevent) {
+		perf_event_release_kernel(pevent);
+		perf_events[cpu][event] = NULL;
+	}
+}
+
+/*
+ * Called by oprofile_perf_start to create active perf events based on the
+ * perviously configured attributes.
+ */
+static int op_perf_start(void)
+{
+	int cpu, event, ret = 0;
+
+	for_each_online_cpu(cpu) {
+		for (event = 0; event < perf_nr_counters; ++event) {
+			ret = op_create_counter(cpu, event);
+			if (ret)
+				goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+/*
+ * Called by oprofile_perf_stop at the end of a profiling run.
+ */
+static void op_perf_stop(void)
+{
+	int cpu, event;
+
+	for_each_online_cpu(cpu)
+		for (event = 0; event < perf_nr_counters; ++event)
+			op_destroy_counter(cpu, event);
+}
+
+static int oprofile_perf_create_files(struct super_block *sb, struct dentry *root)
+{
+	unsigned int i;
+
+	for (i = 0; i < perf_nr_counters; i++) {
+		struct dentry *dir;
+		char buf[4];
+
+		snprintf(buf, sizeof buf, "%d", i);
+		dir = oprofilefs_mkdir(sb, root, buf);
+		oprofilefs_create_ulong(sb, dir, "enabled", &counter_config[i].enabled);
+		oprofilefs_create_ulong(sb, dir, "event", &counter_config[i].event);
+		oprofilefs_create_ulong(sb, dir, "count", &counter_config[i].count);
+		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
+		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
+		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
+	}
+
+	return 0;
+}
+
+static int oprofile_perf_setup(void)
+{
+	spin_lock(&oprofilefs_lock);
+	op_perf_setup();
+	spin_unlock(&oprofilefs_lock);
+	return 0;
+}
+
+static int oprofile_perf_start(void)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&oprofile_perf_mutex);
+	if (!oprofile_perf_enabled) {
+		ret = 0;
+		op_perf_start();
+		oprofile_perf_enabled = 1;
+	}
+	mutex_unlock(&oprofile_perf_mutex);
+	return ret;
+}
+
+static void oprofile_perf_stop(void)
+{
+	mutex_lock(&oprofile_perf_mutex);
+	if (oprofile_perf_enabled)
+		op_perf_stop();
+	oprofile_perf_enabled = 0;
+	mutex_unlock(&oprofile_perf_mutex);
+}
+
+#ifdef CONFIG_PM
+static int oprofile_perf_suspend(struct platform_device *dev, pm_message_t state)
+{
+	mutex_lock(&oprofile_perf_mutex);
+	if (oprofile_perf_enabled)
+		op_perf_stop();
+	mutex_unlock(&oprofile_perf_mutex);
+	return 0;
+}
+
+static int oprofile_perf_resume(struct platform_device *dev)
+{
+	mutex_lock(&oprofile_perf_mutex);
+	if (oprofile_perf_enabled && op_perf_start())
+		oprofile_perf_enabled = 0;
+	mutex_unlock(&oprofile_perf_mutex);
+	return 0;
+}
+
+static struct platform_driver oprofile_driver = {
+	.driver		= {
+		.name		= "oprofile-perf",
+	},
+	.resume		= oprofile_perf_resume,
+	.suspend	= oprofile_perf_suspend,
+};
+
+static struct platform_device *oprofile_pdev;
+
+static int __init init_driverfs(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&oprofile_driver);
+	if (ret)
+		goto out;
+
+	oprofile_pdev =	platform_device_register_simple(
+				oprofile_driver.driver.name, 0, NULL, 0);
+	if (IS_ERR(oprofile_pdev)) {
+		ret = PTR_ERR(oprofile_pdev);
+		platform_driver_unregister(&oprofile_driver);
+	}
+
+out:
+	return ret;
+}
+
+static void __exit exit_driverfs(void)
+{
+	platform_device_unregister(oprofile_pdev);
+	platform_driver_unregister(&oprofile_driver);
+}
+#else
+static int __init init_driverfs(void) { return 0; }
+#define exit_driverfs() do { } while (0)
+#endif /* CONFIG_PM */
+
+int __init oprofile_perf_init(struct oprofile_operations *ops)
+{
+	int cpu, ret = 0;
+
+	memset(&perf_events, 0, sizeof(perf_events));
+
+	perf_nr_counters = perf_num_counters();
+	if (perf_nr_counters <= 0) {
+		pr_info("oprofile: no performance counters\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	counter_config = kcalloc(perf_nr_counters,
+			sizeof(struct op_counter_config), GFP_KERNEL);
+
+	if (!counter_config) {
+		pr_info("oprofile: failed to allocate %d "
+				"counters\n", perf_nr_counters);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = init_driverfs();
+	if (ret)
+		goto out;
+
+	for_each_possible_cpu(cpu) {
+		perf_events[cpu] = kcalloc(perf_nr_counters,
+				sizeof(struct perf_event *), GFP_KERNEL);
+		if (!perf_events[cpu]) {
+			pr_info("oprofile: failed to allocate %d perf events "
+					"for cpu %d\n", perf_nr_counters, cpu);
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
+	ops->create_files	= oprofile_perf_create_files;
+	ops->setup		= oprofile_perf_setup;
+	ops->start		= oprofile_perf_start;
+	ops->stop		= oprofile_perf_stop;
+	ops->shutdown		= oprofile_perf_stop;
+	ops->cpu_type		= perf_pmu_name();
+
+	if (!ops->cpu_type)
+		ret = -ENODEV;
+	else
+		pr_info("oprofile: using %s\n", ops->cpu_type);
+
+out:
+	if (ret) {
+		for_each_possible_cpu(cpu)
+			kfree(perf_events[cpu]);
+		kfree(counter_config);
+	}
+
+	return ret;
+}
+
+void __exit oprofile_perf_exit(void)
+{
+	int cpu, id;
+	struct perf_event *event;
+
+	for_each_possible_cpu(cpu) {
+		for (id = 0; id < perf_nr_counters; ++id) {
+			event = perf_events[cpu][id];
+			if (event)
+				perf_event_release_kernel(event);
+		}
+
+		kfree(perf_events[cpu]);
+	}
+
+	kfree(counter_config);
+	exit_driverfs();
+}
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5171639..a53bfc0 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/init.h>
 #include <asm/atomic.h>
  
 /* Each escaped entry is prefixed by ESCAPE_CODE
@@ -185,4 +186,9 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val);
 int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
+#ifdef CONFIG_PERF_EVENTS
+int __init oprofile_perf_init(struct oprofile_operations *ops);
+void __exit oprofile_perf_exit(void);
+#endif /* CONFIG_PERF_EVENTS */
+
 #endif /* OPROFILE_H */
-- 
1.7.1

