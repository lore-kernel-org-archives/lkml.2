Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935571Ab0KQWX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:23:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:55837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935540Ab0KQWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:23:09 -0500
Message-Id: <20101117222056.316982569@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:37 +0100
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
Subject: [RFC][PATCH 7/8] perf: Sysfs enumeration
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=perf-sysfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple sysfs emumeration of the PMUs.

Use a "event_source" bus, and add PMU devices using their name.

Each PMU device has a type attribute which contrains the value needed
for perf_event_attr::type to identify this PMU.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    1 
 kernel/perf_event.c        |   94 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 94 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -578,6 +578,7 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	struct device			*dev;
 	char				*name;
 	int				type;
 
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -23,6 +23,7 @@
 #include <linux/percpu.h>
 #include <linux/ptrace.h>
 #include <linux/vmstat.h>
+#include <linux/device.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
@@ -5112,7 +5113,25 @@ static void *find_pmu_context(int ctxn)
 	return NULL;
 }
 
+static ssize_t
+type_show(struct device *dev, struct device_attribute *attr, char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
+}
+
+static struct device_attribute pmu_dev_attrs[] = {
+       __ATTR_RO(type),
+       __ATTR_NULL,
+};
+
 static struct idr pmu_idr;
+static int pmu_bus_running;
+static struct bus_type pmu_bus = {
+	.name		= "event_source",
+	.dev_attrs	= pmu_dev_attrs,
+};
 
 static void free_pmu_context(void * __percpu cpu_context)
 {
@@ -5132,6 +5151,39 @@ static void free_pmu_context(void * __pe
 	mutex_unlock(&pmus_lock);
 }
 
+static void pmu_dev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+static int pmu_dev_alloc(struct pmu *pmu)
+{
+	int ret = -ENOMEM;
+
+	pmu->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!pmu->dev)
+		goto out;
+
+	device_initialize(pmu->dev);
+	ret = dev_set_name(pmu->dev, "%s", pmu->name);
+	if (ret)
+		goto free_dev;
+
+	dev_set_drvdata(pmu->dev, pmu);
+	pmu->dev->bus = &pmu_bus;
+	pmu->dev->release = pmu_dev_release;
+	ret = device_add(pmu->dev);
+	if (ret)
+		goto free_dev;
+
+out:
+	return ret;
+
+free_dev:
+	put_device(pmu->dev);
+	goto out;
+}
+
 int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
 	int cpu, ret;
@@ -5160,6 +5212,12 @@ int perf_pmu_register(struct pmu *pmu, c
 	}
 	pmu->type = type;
 
+	if (pmu_bus_running) {
+		ret = pmu_dev_alloc(pmu);
+		if (ret)
+			goto free_idr;
+	}
+
 skip_type:
 	pmu->pmu_cpu_context = find_pmu_context(pmu->task_ctx_nr);
 	if (pmu->pmu_cpu_context)
@@ -5167,7 +5225,7 @@ int perf_pmu_register(struct pmu *pmu, c
 
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
-		goto free_ird;
+		goto free_dev;
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_context *cpuctx;
@@ -5210,6 +5268,10 @@ int perf_pmu_register(struct pmu *pmu, c
 
 	return ret;
 
+free_dev:
+	device_del(pmu->dev);
+	put_device(pmu->dev);
+
 free_idr:
 	if (pmu->type >= PERF_TYPE_MAX)
 		idr_remove(&pmu_idr, pmu->type);
@@ -5235,6 +5297,8 @@ void perf_pmu_unregister(struct pmu *pmu
 	free_percpu(pmu->pmu_disable_count);
 	if (pmu->type >= PERF_TYPE_MAX)
 		idr_remove(&pmu_idr, pmu->type);
+	device_del(pmu->dev);
+	put_device(pmu->dev);
 	free_pmu_context(pmu->pmu_cpu_context);
 }
 
@@ -6363,3 +6427,31 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_task_clock, NULL, -1);
 	perf_cpu_notifier(perf_cpu_notify);
 }
+
+static int __init perf_event_sysfs_init(void)
+{
+	struct pmu *pmu;
+	int ret;
+
+	mutex_lock(&pmus_lock);
+
+	ret = bus_register(&pmu_bus);
+	if (ret)
+		goto unlock;
+
+	list_for_each_entry(pmu, &pmus, entry) {
+		if (!pmu->name || pmu->type < 0)
+			continue;
+
+		ret = pmu_dev_alloc(pmu);
+		WARN(ret, "Failed to register pmu: %s, reason %d\n", pmu->name, ret);
+	}
+	pmu_bus_running = 1;
+	ret = 0;
+
+unlock:
+	mutex_unlock(&pmus_lock);
+
+	return ret;
+}
+__initcall(perf_event_sysfs_init);


