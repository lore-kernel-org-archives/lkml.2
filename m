Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2KJBbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:31:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:1588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab2KJB2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="239778372"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/32] perf, x86: Support CPU specific sysfs events
Date: Fri,  9 Nov 2012 17:27:43 -0800
Message-Id: <1352510868-7911-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a way for the CPU initialization code to register additional events,
and merge them into the events attribute directory. Used in the next
patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index af38635..e247423 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1344,6 +1344,30 @@ static void __init filter_events(struct attribute **attrs)
 	}
 }
 
+/* Merge two pointer arrays */
+static __init struct attribute **merge_attr(struct attribute **a,
+					    struct attribute **b)
+{
+	struct attribute **new;
+	int j, i;
+
+	for (j = 0; a[j]; j++)
+		;
+	for (i = 0; b[i]; i++)
+		j++;
+	j++;
+	new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
+	if (!new)
+		return a;
+	j = 0;
+	for (i = 0; a[i]; i++)
+		new[j++] = a[i];
+	for (i = 0; b[i]; i++)
+		new[j++] = b[i];
+	new[j] = NULL;
+	return new;
+}
+
 ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
@@ -1481,6 +1505,11 @@ static int __init init_hw_perf_events(void)
 	else
 		filter_events(x86_pmu_events_group.attrs);
 
+	if (x86_pmu.cpu_events)
+		x86_pmu_events_group.attrs =
+			merge_attr(x86_pmu_events_group.attrs,
+				   x86_pmu.cpu_events);
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 12ae625..22f8003 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -360,6 +360,7 @@ struct x86_pmu {
 	struct attribute **format_attrs;
 
 	ssize_t		(*events_sysfs_show)(char *page, u64 config);
+	struct attribute **cpu_events;
 
 	/*
 	 * CPU Hotplug hooks
-- 
1.7.7.6

