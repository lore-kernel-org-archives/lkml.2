Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935543Ab0KQWXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:23:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:55819 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935459Ab0KQWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:23:07 -0500
Message-Id: <20101117222056.369896257@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 8/8] perf: Sysfs events
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=perf-sysfs-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple example of a static event enumeration,.. need to come up with
something more dynamic for things like trace-events which can come
and go during the life-time of a struct pmu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c |   51 ++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h       |    1 
 kernel/perf_event.c              |   55 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -578,6 +578,7 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	const struct attribute_group	**groups;
 	struct device			*dev;
 	char				*name;
 	int				type;
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4700,7 +4700,61 @@ static int perf_swevent_init(struct perf
 	return 0;
 }
 
+static struct attribute *swevent_attrs[PERF_COUNT_SW_MAX+1];
+
+static ssize_t swevent_attr_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	int i;
+
+	for (i = 0; swevent_attrs[i]; i++) {
+		if ((struct attribute *)attr == swevent_attrs[i])
+			break;
+	}
+
+	return snprintf(buf, PAGE_SIZE-1, "%d\n", i);
+}
+
+#define SWEVENT_ATTR(name)	\
+	static DEVICE_ATTR(name, S_IRUGO, swevent_attr_show, NULL)
+
+SWEVENT_ATTR(cpu_clock);
+SWEVENT_ATTR(task_clock);
+SWEVENT_ATTR(page_faults);
+SWEVENT_ATTR(context_switches);
+SWEVENT_ATTR(cpu_migrations);
+SWEVENT_ATTR(page_faults_min);
+SWEVENT_ATTR(page_faults_maj);
+SWEVENT_ATTR(alignment_faults);
+SWEVENT_ATTR(emulation_faults);
+
+static struct attribute *swevent_attrs[] = {
+	&dev_attr_cpu_clock.attr,
+	&dev_attr_task_clock.attr,
+	&dev_attr_page_faults.attr,
+	&dev_attr_context_switches.attr,
+	&dev_attr_cpu_migrations.attr,
+	&dev_attr_page_faults_min.attr,
+	&dev_attr_page_faults_maj.attr,
+	&dev_attr_alignment_faults.attr,
+	&dev_attr_emulation_faults.attr,
+	NULL,
+};
+
+static struct attribute_group swevent_group = {
+	.name	= "events",
+	.attrs	= swevent_attrs,
+};
+
+static const struct attribute_group *swevent_groups[] = {
+	&swevent_group,
+	NULL
+};
+
 static struct pmu perf_swevent = {
+	.groups		= swevent_groups,
+
 	.task_ctx_nr	= perf_sw_context,
 
 	.event_init	= perf_swevent_init,
@@ -5172,6 +5226,7 @@ static int pmu_dev_alloc(struct pmu *pmu
 	dev_set_drvdata(pmu->dev, pmu);
 	pmu->dev->bus = &pmu_bus;
 	pmu->dev->release = pmu_dev_release;
+	pmu->dev->groups = pmu->groups;
 	ret = device_add(pmu->dev);
 	if (ret)
 		goto free_dev;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -25,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/device.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -1607,7 +1608,57 @@ int x86_pmu_event_init(struct perf_event
 	return err;
 }
 
+static struct attribute *hwevent_attrs[PERF_COUNT_HW_MAX+1];
+
+static ssize_t hwevent_attr_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	int i;
+
+	for (i = 0; hwevent_attrs[i]; i++) {
+		if ((struct attribute *)attr == hwevent_attrs[i])
+			break;
+	}
+
+	return snprintf(buf, PAGE_SIZE-1, "0x%Lx\n", x86_pmu.event_map(i));
+}
+
+#define HWEVENT_ATTR(name)	\
+	static DEVICE_ATTR(name, S_IRUGO, hwevent_attr_show, NULL)
+
+HWEVENT_ATTR(cpu_cycles);
+HWEVENT_ATTR(instructions);
+HWEVENT_ATTR(cache_references);
+HWEVENT_ATTR(cache_misses);
+HWEVENT_ATTR(branch_instructions);
+HWEVENT_ATTR(branch_misses);
+HWEVENT_ATTR(bus_cycles);
+
+static struct attribute *hwevent_attrs[] = {
+	&dev_attr_cpu_cycles.attr,
+	&dev_attr_instructions.attr,
+	&dev_attr_cache_references.attr,
+	&dev_attr_cache_misses.attr,
+	&dev_attr_branch_instructions.attr,
+	&dev_attr_branch_misses.attr,
+	&dev_attr_bus_cycles.attr,
+	NULL,
+};
+
+static struct attribute_group hwevent_group = {
+	.name	= "events",
+	.attrs	= hwevent_attrs,
+};
+
+static const struct attribute_group *hwevent_groups[] = {
+	&hwevent_group,
+	NULL
+};
+
 static struct pmu pmu = {
+	.groups		= hwevent_groups,
+
 	.pmu_enable	= x86_pmu_enable,
 	.pmu_disable	= x86_pmu_disable,
 


