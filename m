Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0HZTJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:09:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35216 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711Ab0HZTJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:09:24 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org
Subject: [PATCH V2 3/4] oprofile: Abstract the perf-events backend
Date: Thu, 26 Aug 2010 20:09:18 +0100
Message-Id: <fe3e173aaa85f4cd73ea4b5abca50976fc40a01f.1282848651.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1282848651.git.matt@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org>
In-Reply-To: <cover.1282848651.git.matt@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the perf-events backend from arch/arm/oprofile into
drivers/oprofile so that the code can be shared between architectures.

This allows each architecture to maintain only a single copy of the
PMU accessor functions instead of one for both perf and OProfile. It
also becomes possible for other architectures to delete much of their
OProfile code in favour of the common code now available in
drivers/oprofile/oprofile_perf.c.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/arm/oprofile/Makefile       |    4 +
 arch/arm/oprofile/common.c       |  215 +++-----------------------------------
 drivers/oprofile/oprofile_perf.c |  209 ++++++++++++++++++++++++++++++++++++
 include/linux/oprofile.h         |   12 ++
 4 files changed, 242 insertions(+), 198 deletions(-)
 create mode 100644 drivers/oprofile/oprofile_perf.c

diff --git a/arch/arm/oprofile/Makefile b/arch/arm/oprofile/Makefile
index e666eaf..038d7af 100644
--- a/arch/arm/oprofile/Makefile
+++ b/arch/arm/oprofile/Makefile
@@ -6,4 +6,8 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o \
 		timer_int.o )
 
+ifeq ($(CONFIG_HW_PERF_EVENTS), y)
+DRIVER_OBJS += $(addprefix ../../../drivers/oprofile/, oprofile_perf.o)
+endif
+
 oprofile-y				:= $(DRIVER_OBJS) common.o
diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 482779c..f4ea5f8 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -25,136 +25,9 @@
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
 static int op_arm_enabled;
 static DEFINE_MUTEX(op_arm_mutex);
 
-static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[nr_cpumask_bits];
-static int perf_num_counters;
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
-	for (id = 0; id < perf_num_counters; ++id)
-		if (perf_events[cpu][id] == event)
-			break;
-
-	if (id != perf_num_counters)
-		oprofile_add_sample(regs, id);
-	else
-		pr_warning("oprofile: ignoring spurious overflow "
-				"on cpu %u\n", cpu);
-}
-
-/*
- * Called by op_arm_setup to create perf attributes to mirror the oprofile
- * settings in counter_config. Attributes are created as `pinned' events and
- * so are permanently scheduled on the PMU.
- */
-static void op_perf_setup(void)
-{
-	int i;
-	u32 size = sizeof(struct perf_event_attr);
-	struct perf_event_attr *attr;
-
-	for (i = 0; i < perf_num_counters; ++i) {
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
- * Called by op_arm_start to create active perf events based on the
- * perviously configured attributes.
- */
-static int op_perf_start(void)
-{
-	int cpu, event, ret = 0;
-
-	for_each_online_cpu(cpu) {
-		for (event = 0; event < perf_num_counters; ++event) {
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
- * Called by op_arm_stop at the end of a profiling run.
- */
-static void op_perf_stop(void)
-{
-	int cpu, event;
-
-	for_each_online_cpu(cpu)
-		for (event = 0; event < perf_num_counters; ++event)
-			op_destroy_counter(cpu, event);
-}
-
-
 static char *op_name_from_perf_id(enum arm_perf_pmu_ids id)
 {
 	switch (id) {
@@ -175,31 +48,10 @@ static char *op_name_from_perf_id(enum arm_perf_pmu_ids id)
 	}
 }
 
-static int op_arm_create_files(struct super_block *sb, struct dentry *root)
-{
-	unsigned int i;
-
-	for (i = 0; i < perf_num_counters; i++) {
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
 static int op_arm_setup(void)
 {
 	spin_lock(&oprofilefs_lock);
-	op_perf_setup();
+	oprofile_perf_setup();
 	spin_unlock(&oprofilefs_lock);
 	return 0;
 }
@@ -211,7 +63,7 @@ static int op_arm_start(void)
 	mutex_lock(&op_arm_mutex);
 	if (!op_arm_enabled) {
 		ret = 0;
-		op_perf_start();
+		oprofile_perf_start();
 		op_arm_enabled = 1;
 	}
 	mutex_unlock(&op_arm_mutex);
@@ -222,7 +74,7 @@ static void op_arm_stop(void)
 {
 	mutex_lock(&op_arm_mutex);
 	if (op_arm_enabled)
-		op_perf_stop();
+		oprofile_perf_stop();
 	op_arm_enabled = 0;
 	mutex_unlock(&op_arm_mutex);
 }
@@ -232,7 +84,7 @@ static int op_arm_suspend(struct platform_device *dev, pm_message_t state)
 {
 	mutex_lock(&op_arm_mutex);
 	if (op_arm_enabled)
-		op_perf_stop();
+		oprofile_perf_stop();
 	mutex_unlock(&op_arm_mutex);
 	return 0;
 }
@@ -240,7 +92,7 @@ static int op_arm_suspend(struct platform_device *dev, pm_message_t state)
 static int op_arm_resume(struct platform_device *dev)
 {
 	mutex_lock(&op_arm_mutex);
-	if (op_arm_enabled && op_perf_start())
+	if (op_arm_enabled && oprofile_perf_start())
 		op_arm_enabled = 0;
 	mutex_unlock(&op_arm_mutex);
 	return 0;
@@ -351,37 +203,16 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
-	int cpu, ret = 0;
-
-	perf_num_counters = armpmu_get_max_events();
-
-	counter_config = kcalloc(perf_num_counters,
-			sizeof(struct op_counter_config), GFP_KERNEL);
-
-	if (!counter_config) {
-		pr_info("oprofile: failed to allocate %d "
-				"counters\n", perf_num_counters);
-		return -ENOMEM;
-	}
+	int ret = 0;
 
 	ret = init_driverfs();
 	if (ret)
 		return ret;
 
-	for_each_possible_cpu(cpu) {
-		perf_events[cpu] = kcalloc(perf_num_counters,
-				sizeof(struct perf_event *), GFP_KERNEL);
-		if (!perf_events[cpu]) {
-			pr_info("oprofile: failed to allocate %d perf events "
-					"for cpu %d\n", perf_num_counters, cpu);
-			while (--cpu >= 0)
-				kfree(perf_events[cpu]);
-			return -ENOMEM;
-		}
-	}
+	oprofile_perf_set_num_counters(armpmu_get_max_events());
 
 	ops->backtrace		= arm_backtrace;
-	ops->create_files	= op_arm_create_files;
+	ops->create_files	= oprofile_perf_create_files;
 	ops->setup		= op_arm_setup;
 	ops->start		= op_arm_start;
 	ops->stop		= op_arm_stop;
@@ -389,33 +220,21 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ops->cpu_type		= op_name_from_perf_id(armpmu_get_pmu_id());
 
 	if (!ops->cpu_type)
-		ret = -ENODEV;
-	else
-		pr_info("oprofile: using %s\n", ops->cpu_type);
+		return -ENODEV;
 
-	return ret;
+	ret = oprofile_perf_init();
+	if (ret != 0)
+		return ret;
+
+	pr_info("oprofile: using %s\n", ops->cpu_type);
+
+	return 0;
 }
 
 void oprofile_arch_exit(void)
 {
-	int cpu, id;
-	struct perf_event *event;
-
+	oprofile_perf_exit();
 	exit_driverfs();
-
-	if (*perf_events) {
-		for_each_possible_cpu(cpu) {
-			for (id = 0; id < perf_num_counters; ++id) {
-				event = perf_events[cpu][id];
-				if (event != NULL)
-					perf_event_release_kernel(event);
-			}
-			kfree(perf_events[cpu]);
-		}
-	}
-
-	if (counter_config)
-		kfree(counter_config);
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
new file mode 100644
index 0000000..5f83cd7
--- /dev/null
+++ b/drivers/oprofile/oprofile_perf.c
@@ -0,0 +1,209 @@
+/*
+ * Copyright 2010 ARM Ltd.
+ *
+ * Perf-events backend for OProfile.
+ */
+#include <linux/slab.h>
+#include <linux/oprofile.h>
+#include <linux/perf_event.h>
+
+/* Per-counter configuration as set via oprofilefs.  */
+struct op_counter_config {
+	unsigned long enabled;
+	unsigned long event;
+
+	unsigned long count;
+
+	/* Dummy values for userspace tool compliance */
+	unsigned long kernel;
+	unsigned long user;
+	unsigned long unit_mask;
+
+	struct perf_event_attr attr;
+};
+
+static struct op_counter_config *counter_config;
+static struct perf_event **perf_events[nr_cpumask_bits];
+static int perf_num_counters;
+
+/*
+ * Overflow callback for oprofile.
+ */
+static void op_overflow_handler(struct perf_event *event, int unused,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	int id;
+	u32 cpu = smp_processor_id();
+
+	for (id = 0; id < perf_num_counters; ++id)
+		if (perf_events[cpu][id] == event)
+			break;
+
+	if (id != perf_num_counters)
+		oprofile_add_sample(regs, id);
+	else
+		pr_warning("oprofile: ignoring spurious overflow "
+				"on cpu %u\n", cpu);
+}
+
+/*
+ * Create perf attributes to mirror the oprofile settings in
+ * counter_config. Attributes are created as `pinned' events and so are
+ * permanently scheduled on the PMU.
+ */
+int oprofile_perf_setup(void)
+{
+	int i;
+	u32 attr_size = sizeof(struct perf_event_attr);
+	struct perf_event_attr *attr;
+
+	for (i = 0; i < perf_num_counters; ++i) {
+		attr = &counter_config[i].attr;
+		memset(attr, 0, attr_size);
+		attr->type		= PERF_TYPE_RAW;
+		attr->size		= attr_size;
+		attr->config		= counter_config[i].event;
+		attr->sample_period	= counter_config[i].count;
+		attr->pinned		= 1;
+	}
+
+	return 0;
+}
+
+int oprofile_create_counter(int cpu, int event)
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
+void oprofile_destroy_counter(int cpu, int event)
+{
+	struct perf_event *pevent = perf_events[cpu][event];
+
+	if (pevent) {
+		perf_event_release_kernel(pevent);
+		perf_events[cpu][event] = NULL;
+	}
+}
+
+int oprofile_perf_init(void)
+{
+	u32 counter_size = sizeof(struct op_counter_config);
+	int cpu;
+
+	counter_config = kcalloc(perf_num_counters, counter_size, GFP_KERNEL);
+
+	if (!counter_config) {
+		pr_info("oprofile: failed to allocate %d "
+				"counters\n", perf_num_counters);
+		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu) {
+		perf_events[cpu] = kcalloc(perf_num_counters,
+				sizeof(struct perf_event *), GFP_KERNEL);
+		if (!perf_events[cpu]) {
+			pr_info("oprofile: failed to allocate %d perf events "
+					"for cpu %d\n", perf_num_counters, cpu);
+			while (--cpu >= 0)
+				kfree(perf_events[cpu]);
+			kfree(counter_config);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+void oprofile_perf_exit(void)
+{
+	int id, cpu;
+
+	for_each_possible_cpu(cpu) {
+		for (id = 0; id < perf_num_counters; ++id)
+			oprofile_destroy_counter(cpu, id);
+
+		kfree(perf_events[cpu]);
+	}
+
+	kfree(counter_config);
+}
+
+/*
+ * Create active perf events based on the perviously configured
+ * attributes.
+ */
+int oprofile_perf_start(void)
+{
+	int cpu, event, ret = 0;
+
+	for_each_online_cpu(cpu) {
+		for (event = 0; event < perf_num_counters; ++event) {
+			ret = oprofile_create_counter(cpu, event);
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
+ * Called at the end of a profiling run.
+ */
+void oprofile_perf_stop(void)
+{
+	int cpu, event;
+
+	for_each_online_cpu(cpu)
+		for (event = 0; event < perf_num_counters; ++event)
+			oprofile_destroy_counter(cpu, event);
+}
+
+
+int oprofile_perf_create_files(struct super_block *sb, struct dentry *root)
+{
+	int i;
+
+	for (i = 0; i < perf_num_counters; i++) {
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
+void oprofile_perf_set_num_counters(int num_counters)
+{
+	perf_num_counters = num_counters;
+}
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5171639..99e0323 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -185,4 +185,16 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val);
 int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
+/* Oprofile perf wrapper functions. */
+
+#ifdef CONFIG_PERF_EVENTS
+int oprofile_perf_init(void);
+void oprofile_perf_exit(void);
+int oprofile_perf_setup(void);
+int oprofile_perf_start(void);
+void oprofile_perf_stop(void);
+int oprofile_perf_create_files(struct super_block *sb, struct dentry *root);
+void oprofile_perf_set_num_counters(int num_counters);
+#endif /* CONFIG_PERF_EVENTS */
+
 #endif /* OPROFILE_H */
-- 
1.7.1

