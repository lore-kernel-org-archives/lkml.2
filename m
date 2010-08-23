Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0HWKqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:46:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53500 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab0HWKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:46:22 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] oprofile: Abstract the perf-events backend
Date: Mon, 23 Aug 2010 11:46:20 +0100
Message-Id: <1282560381-7700-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.2.2.162.g5cba1
In-Reply-To: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
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
 arch/arm/oprofile/common.c       |  176 +-----------------------------------
 drivers/oprofile/oprofile_perf.c |  188 ++++++++++++++++++++++++++++++++++++++
 include/linux/oprofile.h         |   12 +++
 4 files changed, 207 insertions(+), 173 deletions(-)
 create mode 100644 drivers/oprofile/oprofile_perf.c

diff --git a/arch/arm/oprofile/Makefile b/arch/arm/oprofile/Makefile
index e666eaf..def77a1 100644
--- a/arch/arm/oprofile/Makefile
+++ b/arch/arm/oprofile/Makefile
@@ -6,4 +6,8 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o \
 		timer_int.o )
 
+ifeq ($(CONFIG_HW_PERF_EVENTS),y)
+DRIVERS_OBJS += $(addprefix ../../../drivers/oprofile/, oprofile_perf.o)
+endif
+
 oprofile-y				:= $(DRIVER_OBJS) common.o
diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..50e4980 100644
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
@@ -175,27 +48,6 @@ static char *op_name_from_perf_id(enum arm_perf_pmu_ids id)
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
@@ -349,39 +201,17 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 
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
 	if (ret) {
-		kfree(counter_config);
 		return ret;
 	}
 
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
+	op_perf_set_num_counters(armpmu_get_max_events());
 
 	ops->backtrace		= arm_backtrace;
-	ops->create_files	= op_arm_create_files;
+	ops->create_files	= op_perf_create_files;
 	ops->setup		= op_arm_setup;
 	ops->start		= op_arm_start;
 	ops->stop		= op_arm_stop;
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
new file mode 100644
index 0000000..9ab7b94
--- /dev/null
+++ b/drivers/oprofile/oprofile_perf.c
@@ -0,0 +1,188 @@
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
+int op_perf_setup(void)
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
+int op_create_counter(int cpu, int event)
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
+void op_destroy_counter(int cpu, int event)
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
+ * Create active perf events based on the perviously configured
+ * attributes.
+ */
+int op_perf_start(void)
+{
+	int cpu, event, ret = 0;
+
+	for_each_online_cpu(cpu) {
+		for (event = 0; event < perf_num_counters; ++event) {
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
+ * Called at the end of a profiling run.
+ */
+void op_perf_stop(void)
+{
+	int cpu, event;
+
+	for_each_online_cpu(cpu)
+		for (event = 0; event < perf_num_counters; ++event)
+			op_destroy_counter(cpu, event);
+}
+
+
+int op_perf_create_files(struct super_block *sb, struct dentry *root)
+{
+	u32 counter_size = sizeof(struct op_counter_config);
+	int i, cpu;
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
+void op_perf_set_num_counters(int num_counters)
+{
+	perf_num_counters = num_counters;
+}
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5171639..4b3f8af 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -185,4 +185,16 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val);
 int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
+/* Oprofile perf wrapper functions. */
+
+#ifdef CONFIG_PERF_EVENTS
+int op_perf_setup(void);
+int op_create_counter(int cpu, int event);
+void op_destroy_counter(int cpu, int event);
+int op_perf_start(void);
+void op_perf_stop(void);
+int op_perf_create_files(struct super_block *sb, struct dentry *root);
+void op_perf_set_num_counters(int num_counters);
+#endif /* CONFIG_PERF_EVENTS */
+
 #endif /* OPROFILE_H */
-- 
1.7.2.1

