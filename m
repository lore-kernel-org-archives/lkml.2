Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2KGTSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:18:23 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45557 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2KGTSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:18:22 -0500
Date: Wed, 7 Nov 2012 11:19:28 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] perf/POWER7: Make event translations available in sysfs
Message-ID: <20121107191927.GC16211@us.ibm.com>
References: <20121107191818.GA16211@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107191818.GA16211@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110719-3620-0000-0000-0000004AEBF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From d05d1ce6d55bf339eee6230ded9f5dd1351f60e5 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 6 Nov 2012 14:07:36 -0800
Subject: [PATCH 3/4] perf/POWER7: Make event translations available in sysfs

Make the perf events supported by POWER7 available via sysfs.

	$ ls /sys/bus/event_source/devices/cpu/events
	branch-instructions
	branch-misses
	cache-misses
	cache-references
	cpu-cycles
	instructions
	stalled-cycles-backend
	stalled-cycles-frontend

	$ cat /sys/bus/event_source/devices/cpu/events/cache-misses
	event=0x03

This patch is based on commits that implement this functionality on x86.
Eg:
	commit a47473939db20e3961b200eb00acf5fcf084d755
	Author: Jiri Olsa <jolsa@redhat.com>
	Date:   Wed Oct 10 14:53:11 2012 +0200

	    perf/x86: Make hardware event translations available in sysfs

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |   21 +++++++++++++++++
 arch/powerpc/perf/core-book3s.c              |   12 +++++++++
 arch/powerpc/perf/power7-pmu.c               |   32 ++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 9710be3..ad84f73 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -11,6 +11,8 @@
 
 #include <linux/types.h>
 #include <asm/hw_irq.h>
+#include <linux/sysfs.h>
+#include <linux/device.h>
 
 #define MAX_HWEVENTS		8
 #define MAX_EVENT_ALTERNATIVES	8
@@ -35,6 +37,7 @@ struct power_pmu {
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
 	u32		flags;
+	const struct attribute_group	**attr_groups;
 	int		n_generic;
 	int		*generic_events;
 	int		(*cache_events)[PERF_COUNT_HW_CACHE_MAX]
@@ -109,3 +112,21 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
  * If an event_id is not subject to the constraint expressed by a particular
  * field, then it will have 0 in both the mask and value for that field.
  */
+
+
+struct perf_pmu_events_attr {
+	struct device_attribute attr;
+	u64 id;
+};
+
+extern ssize_t power_events_sysfs_show(struct device *dev,
+				struct device_attribute *attr, char *page);
+
+#define EVENT_VAR(_id)	event_attr_##_id
+#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+
+#define EVENT_ATTR(_name, _id)                                             \
+	static struct perf_pmu_events_attr EVENT_VAR(_id) = {              \
+		.attr = __ATTR(_name, 0444, power_events_sysfs_show, NULL),\
+		.id   = PM_##_id,                                               \
+	};
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index aa2465e..19b23bd 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1305,6 +1305,16 @@ static int power_pmu_event_idx(struct perf_event *event)
 	return event->hw.idx;
 }
 
+ssize_t power_events_sysfs_show(struct device *dev,
+				struct device_attribute *attr, char *page)
+{
+       struct perf_pmu_events_attr *pmu_attr;
+       
+       pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
+        
+       return sprintf(page, "event=0x%02llx\n", pmu_attr->id);
+}
+
 struct pmu power_pmu = {
 	.pmu_enable	= power_pmu_enable,
 	.pmu_disable	= power_pmu_disable,
@@ -1537,6 +1547,8 @@ int __cpuinit register_power_pmu(struct power_pmu *pmu)
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
+	power_pmu.attr_groups = ppmu->attr_groups;
+
 #ifdef MSR_HV
 	/*
 	 * Use FCHV to ignore kernel events if MSR.HV is set.
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 256db4f..31c61ab 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -360,6 +360,37 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	},
 };
 
+EVENT_ATTR(cpu-cycles,                 CYC);
+EVENT_ATTR(stalled-cycles-frontend,    GCT_NOSLOT_CYC);
+EVENT_ATTR(stalled-cycles-backend,     CMPLU_STALL);
+EVENT_ATTR(instructions,               INST_CMPL);
+EVENT_ATTR(cache-references,           LD_REF_L1);
+EVENT_ATTR(cache-misses,               LD_MISS_L1);
+EVENT_ATTR(branch-instructions,        BRU_FIN);
+EVENT_ATTR(branch-misses,              BRU_MPRED);
+
+static struct attribute *power7_events_attr[] = {
+	EVENT_PTR(CYC),
+	EVENT_PTR(GCT_NOSLOT_CYC),
+	EVENT_PTR(CMPLU_STALL),
+	EVENT_PTR(INST_CMPL),
+	EVENT_PTR(LD_REF_L1),
+	EVENT_PTR(LD_MISS_L1),
+	EVENT_PTR(BRU_FIN),
+	EVENT_PTR(BRU_MPRED),
+	NULL,
+};
+
+static struct attribute_group power7_pmu_events_group = {
+	.name = "events",
+	.attrs = power7_events_attr,           
+};
+
+static const struct attribute_group *power7_pmu_attr_groups[] = {
+	&power7_pmu_events_group,
+	NULL,
+};
+
 static struct power_pmu power7_pmu = {
 	.name			= "POWER7",
 	.n_counter		= 6,
@@ -371,6 +402,7 @@ static struct power_pmu power7_pmu = {
 	.get_alternatives	= power7_get_alternatives,
 	.disable_pmc		= power7_disable_pmc,
 	.flags			= PPMU_ALT_SIPR,
+	.attr_groups		= power7_pmu_attr_groups,
 	.n_generic		= ARRAY_SIZE(power7_generic_events),
 	.generic_events		= power7_generic_events,
 	.cache_events		= &power7_cache_events,
-- 
1.7.1

