Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0LPMdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:33:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:36442 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab0LPMdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:33:39 -0500
Date: Thu, 16 Dec 2010 12:33:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kay.sievers@vrfy.org, a.p.zijlstra@chello.nl, gregkh@suse.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, a.p.zijlstra@chello.nl, gregkh@suse.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101117222056.316982569@chello.nl>
References: <20101117222056.316982569@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Sysfs enumeration
Message-ID: <tip-abe43400579d5de0078c2d3a760e6598e183f871@git.kernel.org>
Git-Commit-ID: abe43400579d5de0078c2d3a760e6598e183f871
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:33:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abe43400579d5de0078c2d3a760e6598e183f871
Gitweb:     http://git.kernel.org/tip/abe43400579d5de0078c2d3a760e6598e183f871
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 17 Nov 2010 23:17:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:36:43 +0100

perf: Sysfs enumeration

Simple sysfs emumeration of the PMUs.

Use a "event_source" bus, and add PMU devices using their name.

Each PMU device has a type attribute which contrains the value needed
for perf_event_attr::type to identify this PMU.

This is the minimal stub needed to start using this interface,
we'll consider extending the sysfs usage later.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101117222056.316982569@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   95 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 21206d2..dda5b0a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -588,6 +588,7 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	struct device			*dev;
 	char				*name;
 	int				type;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8f09bc8..11847bf 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -24,6 +24,7 @@
 #include <linux/ptrace.h>
 #include <linux/reboot.h>
 #include <linux/vmstat.h>
+#include <linux/device.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
@@ -5308,6 +5309,58 @@ out:
 }
 static struct idr pmu_idr;
 
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
+static int pmu_bus_running;
+static struct bus_type pmu_bus = {
+	.name		= "event_source",
+	.dev_attrs	= pmu_dev_attrs,
+};
+
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
@@ -5336,6 +5389,12 @@ int perf_pmu_register(struct pmu *pmu, char *name, int type)
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
@@ -5343,7 +5402,7 @@ skip_type:
 
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
-		goto free_ird;
+		goto free_dev;
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_context *cpuctx;
@@ -5387,6 +5446,10 @@ unlock:
 
 	return ret;
 
+free_dev:
+	device_del(pmu->dev);
+	put_device(pmu->dev);
+
 free_idr:
 	if (pmu->type >= PERF_TYPE_MAX)
 		idr_remove(&pmu_idr, pmu->type);
@@ -5412,6 +5475,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 	free_percpu(pmu->pmu_disable_count);
 	if (pmu->type >= PERF_TYPE_MAX)
 		idr_remove(&pmu_idr, pmu->type);
+	device_del(pmu->dev);
+	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
 
@@ -6603,3 +6668,31 @@ void __init perf_event_init(void)
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
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
+device_initcall(perf_event_sysfs_init);
