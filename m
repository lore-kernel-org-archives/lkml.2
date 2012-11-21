Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2KUMva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:51:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49713 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2KUMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:29 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 01/19] perf, x86: Support CPU specific sysfs events
Date: Wed, 21 Nov 2012 13:49:27 +0100
Message-Id: <1353502185-26521-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
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
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..b116788 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1341,6 +1341,30 @@ static void __init filter_events(struct attribute **attrs)
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
 static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
@@ -1482,6 +1506,11 @@ static int __init init_hw_perf_events(void)
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
index 115c1ea..4170043 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -355,6 +355,7 @@ struct x86_pmu {
 	struct attribute **format_attrs;
 
 	ssize_t		(*events_sysfs_show)(char *page, u64 config);
+	struct attribute **cpu_events;
 
 	/*
 	 * CPU Hotplug hooks
-- 
1.7.9.5

