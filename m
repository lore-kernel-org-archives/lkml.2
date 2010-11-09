Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0KIVpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:45:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38195 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0KIVp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:45:29 -0500
Subject: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 22:45:19 +0100
Message-ID: <1289339119.2191.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below is a RFC patch adding dynamic type ids to perf.

We need to represent PMUs in sysfs because we want to allow multiple
(loadable) PMUs and need a way to identify them.

This patch creates a new device class "pmu" and adds a single attribute
"type" to it. This device attribute will expose the dynamic type id as
required by perf_event_attr::type.

The sysfs layout looks like:

[root@westmere ~]# cd /sys/class/pmu/
[root@westmere pmu]# ls -la
total 0
drwxr-xr-x  2 root root 0 2010-11-09 22:22 .
drwxr-xr-x 47 root root 0 2010-11-09 22:22 ..
lrwxrwxrwx  1 root root 0 2010-11-09 22:22 breakpoint -> ../../devices/virtual/pmu/breakpoint
lrwxrwxrwx  1 root root 0 2010-11-09 22:22 cpu -> ../../devices/virtual/pmu/cpu
lrwxrwxrwx  1 root root 0 2010-11-09 22:22 frob -> ../../devices/virtual/pmu/frob
lrwxrwxrwx  1 root root 0 2010-11-09 22:22 software -> ../../devices/virtual/pmu/software
lrwxrwxrwx  1 root root 0 2010-11-09 22:22 tracepoint -> ../../devices/virtual/pmu/tracepoint
[root@westmere pmu]# cd frob/
[root@westmere frob]# ls -la
total 0
drwxr-xr-x 3 root root    0 2010-11-09 22:22 .
drwxr-xr-x 7 root root    0 2010-11-09 22:22 ..
drwxr-xr-x 2 root root    0 2010-11-09 22:23 power
lrwxrwxrwx 1 root root    0 2010-11-09 22:23 subsystem -> ../../../../class/pmu
-r--r--r-- 1 root root 4096 2010-11-09 22:23 type
-rw-r--r-- 1 root root 4096 2010-11-09 22:22 uevent
[root@westmere frob]# cat type 
6

Not at all sure what all those power bits mean, Greg?

The idea is to populate the sysfs topology with symlinks to these
devices (have /sys/devices/system/cpu/pmu link to the "cpu" pmu device,
have /sys/devices/system/node/ link to a possible "node" pmu device --
intel uncore, etc..). I'll still have to look at how to create these
symlinks, if anybody got clue please holler ;-)

Furthermore, we can later add an event directory to these devices which
list available events and contain the value required by
perf_event_attr::config.

Comments?

---
 arch/x86/include/asm/perf_event.h |    2 -
 arch/x86/kernel/cpu/common.c      |    2 -
 arch/x86/kernel/cpu/perf_event.c  |   11 ++-
 include/linux/perf_event.h        |    7 ++-
 init/main.c                       |    2 +-
 kernel/hw_breakpoint.c            |    2 +-
 kernel/perf_event.c               |  121 ++++++++++++++++++++++++++++++++----
 7 files changed, 122 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 550e26b..d9d4dae 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -125,7 +125,6 @@ union cpuid10_edx {
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 
 #ifdef CONFIG_PERF_EVENTS
-extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
 
 #define PERF_EVENT_INDEX_OFFSET			0
@@ -156,7 +155,6 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 }
 
 #else
-static inline void init_hw_perf_events(void)		{ }
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b68bda..9eb2248 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -13,7 +13,6 @@
 #include <linux/io.h>
 
 #include <asm/stackprotector.h>
-#include <asm/perf_event.h>
 #include <asm/mmu_context.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
@@ -894,7 +893,6 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	init_hw_perf_events();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..04d0f3c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1348,7 +1348,7 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
-void __init init_hw_perf_events(void)
+static int __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
 	int err;
@@ -1363,11 +1363,11 @@ void __init init_hw_perf_events(void)
 		err = amd_pmu_init();
 		break;
 	default:
-		return;
+		return 0;
 	}
 	if (err != 0) {
 		pr_cont("no PMU driver, software events only.\n");
-		return;
+		return 0;
 	}
 
 	pmu_check_apic();
@@ -1418,9 +1418,12 @@ void __init init_hw_perf_events(void)
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	return 0;
 }
+early_initcall(init_hw_perf_events);
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..aa1117f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -578,6 +578,10 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	struct device			*dev;
+	char				*name;
+	int				type;
+
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
@@ -876,6 +880,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
+	int				disable_count;
 };
 
 struct perf_output_handle {
@@ -891,7 +896,7 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-extern int perf_pmu_register(struct pmu *pmu);
+extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
diff --git a/init/main.c b/init/main.c
index e59af24..41a0c2f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -588,6 +588,7 @@ asmlinkage void __init start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_init();
+	idr_init_cache();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
@@ -659,7 +660,6 @@ asmlinkage void __init start_kernel(void)
 	enable_debug_pagealloc();
 	kmemleak_init();
 	debug_objects_mem_init();
-	idr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 2c9120f..a14ca35 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -641,7 +641,7 @@ static int __init init_hw_breakpoint(void)
 
 	constraints_initialized = 1;
 
-	perf_pmu_register(&perf_breakpoint);
+	perf_pmu_register(&perf_breakpoint, "breakpoint", PERF_TYPE_BREAKPOINT);
 
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 517d827..7f0d3ac 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
+#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
@@ -22,6 +23,7 @@
 #include <linux/percpu.h>
 #include <linux/ptrace.h>
 #include <linux/vmstat.h>
+#include <linux/device.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
@@ -70,14 +72,16 @@ extern __weak const char *perf_pmu_name(void)
 
 void perf_pmu_disable(struct pmu *pmu)
 {
-	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+	int *count = &cpuctx->disable_count;
 	if (!(*count)++)
 		pmu->pmu_disable(pmu);
 }
 
 void perf_pmu_enable(struct pmu *pmu)
 {
-	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+	int *count = &cpuctx->disable_count;
 	if (!--(*count))
 		pmu->pmu_enable(pmu);
 }
@@ -4778,7 +4782,7 @@ static struct pmu perf_tracepoint = {
 
 static inline void perf_tp_register(void)
 {
-	perf_pmu_register(&perf_tracepoint);
+	perf_pmu_register(&perf_tracepoint, "tracepoint", PERF_TYPE_TRACEPOINT);
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
@@ -5087,6 +5091,9 @@ static void *find_pmu_context(int ctxn)
 	return NULL;
 }
 
+static struct class *pmu_class;
+static struct idr pmu_idr;
+
 static void free_pmu_context(void * __percpu cpu_context)
 {
 	struct pmu *pmu;
@@ -5102,26 +5109,59 @@ static void free_pmu_context(void * __percpu cpu_context)
 
 	free_percpu(cpu_context);
 out:
+	if (pmu->type >= 0)
+		idr_remove(&pmu_idr, pmu->type);
+
 	mutex_unlock(&pmus_lock);
+
+	if (pmu->dev)
+		device_unregister(pmu->dev);
 }
 
-int perf_pmu_register(struct pmu *pmu)
+int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
 	int cpu, ret;
 
 	mutex_lock(&pmus_lock);
 	ret = -ENOMEM;
-	pmu->pmu_disable_count = alloc_percpu(int);
-	if (!pmu->pmu_disable_count)
-		goto unlock;
 
+	pmu->type = -1;
+	if (!name)
+		goto nodev;
+
+	pmu->name = name;
+	if (type < 0) {
+		int err = idr_pre_get(&pmu_idr, GFP_KERNEL);
+		if (!err) {
+			printk(KERN_ERR "FOO! %d\n", err);
+			goto unlock;
+		}
+		err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);
+		if (err) {
+			printk(KERN_ERR "BAR! %d\n", err);
+			ret = err;
+			goto unlock;
+		}
+	}
+	pmu->type = type;
+
+	if (pmu_class) {
+		pmu->dev = device_create(pmu_class, NULL, MKDEV(0, 0), 
+				pmu, "%s", pmu->name);
+		if (IS_ERR(pmu->dev)) {
+			ret = PTR_ERR(pmu->dev);
+			goto free_idr;
+		}
+	}
+
+nodev:
 	pmu->pmu_cpu_context = find_pmu_context(pmu->task_ctx_nr);
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
-		goto free_pdc;
+		goto free_dev;
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_context *cpuctx;
@@ -5132,6 +5172,7 @@ int perf_pmu_register(struct pmu *pmu)
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
+		cpuctx->disable_count = 0;
 	}
 
 got_cpu_context:
@@ -5164,8 +5205,13 @@ unlock:
 
 	return ret;
 
-free_pdc:
-	free_percpu(pmu->pmu_disable_count);
+free_dev:
+	if (pmu->dev)
+		device_unregister(pmu->dev);
+
+free_idr:
+	if (pmu->type >= 0)
+		idr_remove(&pmu_idr, pmu->type);
 	goto unlock;
 }
 
@@ -5182,7 +5228,6 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_srcu(&pmus_srcu);
 	synchronize_rcu();
 
-	free_percpu(pmu->pmu_disable_count);
 	free_pmu_context(pmu->pmu_cpu_context);
 }
 
@@ -5192,6 +5237,13 @@ struct pmu *perf_init_event(struct perf_event *event)
 	int idx;
 
 	idx = srcu_read_lock(&pmus_srcu);
+
+	rcu_read_lock();
+	pmu = idr_find(&pmu_idr, event->attr.type);
+	rcu_read_unlock();
+	if (pmu)
+		goto unlock;
+	
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		int ret = pmu->event_init(event);
 		if (!ret)
@@ -6293,13 +6345,54 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
+static ssize_t type_show(struct device *dev,
+		struct device_attribute *attr, char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
+}
+
+static struct device_attribute pmu_dev_attrs[] = {
+	__ATTR_RO(type),
+	__ATTR_NULL,
+};
+
 void __init perf_event_init(void)
 {
+	idr_init(&pmu_idr);
+
 	perf_event_init_all_cpus();
 	init_srcu_struct(&pmus_srcu);
-	perf_pmu_register(&perf_swevent);
-	perf_pmu_register(&perf_cpu_clock);
-	perf_pmu_register(&perf_task_clock);
+	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
+	perf_pmu_register(&perf_cpu_clock, "frob", -1); /* test the dynamic code */
+	perf_pmu_register(&perf_task_clock, NULL, -1);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 }
+
+int __init perf_event_sysfs_init(void)
+{
+	struct pmu *pmu;
+
+	mutex_lock(&pmus_lock);
+
+	pmu_class = class_create(THIS_MODULE, "pmu");
+	BUG_ON(IS_ERR(pmu_class));
+	pmu_class->dev_attrs = pmu_dev_attrs;
+
+	list_for_each_entry(pmu, &pmus, entry) {
+		if (!pmu->name || pmu->type < 0)
+			continue;
+
+		pmu->dev = device_create(pmu_class, NULL, MKDEV(0, 0), 
+				pmu, "%s", pmu->name);
+		if (IS_ERR(pmu->dev))
+			pmu->dev = NULL; /* do we care about the failure? */
+	}
+
+	mutex_unlock(&pmus_lock);
+
+	return 0;
+}
+__initcall(perf_event_sysfs_init);

