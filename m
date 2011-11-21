Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1KUO4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:56:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:45515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KUO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:56:06 -0500
Message-Id: <20111121145337.725854099@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 15:51:18 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/6] perf, x86: Provide means of disabling userspace RDPMC
References: <20111121145114.049265181@chello.nl>
Content-Disposition: inline; filename=perf-rdpmc-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace RDPMC is a data leak since people can poke at random
counters that are not their own, therefore provide a pmu specific
attribute to turn it off.

XXX: we probably want a perf_pmu_add_option() function but all this
sysfs stuff gives me a head-ache.

Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c |   55 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h |    8 +++++
 include/linux/perf_event.h       |    1 
 kernel/events/core.c             |    1 
 4 files changed, 64 insertions(+), 1 deletion(-)
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -614,6 +614,7 @@ struct pmu {
 	struct list_head		entry;
 
 	struct device			*dev;
+	const struct attribute_group	**attr_groups;
 	char				*name;
 	int				type;
 
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -5421,6 +5421,7 @@ static int pmu_dev_alloc(struct pmu *pmu
 	if (!pmu->dev)
 		goto out;
 
+	pmu->dev->groups = pmu->attr_groups;
 	device_initialize(pmu->dev);
 	ret = dev_set_name(pmu->dev, "%s", pmu->name);
 	if (ret)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/device.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -1211,7 +1212,8 @@ x86_pmu_notifier(struct notifier_block *
 		break;
 
 	case CPU_STARTING:
-		set_in_cr4(X86_CR4_PCE);
+		if (x86_pmu.attr_rdpmc)
+			set_in_cr4(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1314,6 +1316,8 @@ static int __init init_hw_perf_events(vo
 		}
 	}
 
+	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
@@ -1549,10 +1553,59 @@ static int x86_pmu_event_idx(struct perf
 	return idx + 1;
 }
 
+static ssize_t get_attr_rdpmc(struct device *cdev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	return snprintf(buf, 40, "%d\n", x86_pmu.attr_rdpmc);
+}
+
+static void change_rdpmc(void *info)
+{
+	bool enable = !!(unsigned long)info;
+
+	if (enable)
+		set_in_cr4(X86_CR4_PCE);
+	else
+		clear_in_cr4(X86_CR4_PCE);
+}
+
+static ssize_t set_attr_rdpmc(struct device *cdev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	unsigned long val = simple_strtoul(buf, NULL, 0);
+
+	if (!!val != !!x86_pmu.attr_rdpmc) {
+		x86_pmu.attr_rdpmc = !!val;
+		smp_call_function(change_rdpmc, (void *)val, 1);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+
+static struct attribute *x86_pmu_attrs[] = {
+	&dev_attr_rdpmc.attr,
+	NULL,
+};
+
+static struct attribute_group x86_pmu_attr_group = {
+	.attrs = x86_pmu_attrs,
+};
+
+static const struct attribute_group *x86_pmu_attr_groups[] = {
+	&x86_pmu_attr_group,
+	NULL,
+};
+
 static struct pmu pmu = {
 	.pmu_enable	= x86_pmu_enable,
 	.pmu_disable	= x86_pmu_disable,
 
+	.attr_groups	= x86_pmu_attr_groups,
+
 	.event_init	= x86_pmu_event_init,
 
 	.add		= x86_pmu_add,
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.h
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.h
@@ -302,6 +302,14 @@ struct x86_pmu {
 	void		(*quirks)(void);
 	int		perfctr_second_write;
 
+	/*
+	 * sysfs attrs
+	 */
+	int		attr_rdpmc;
+
+	/*
+	 * CPU Hotplug hooks
+	 */
 	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);


