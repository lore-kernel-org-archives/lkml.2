Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2KUMve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:51:34 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55983 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2KUMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:32 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 02/19] perf/x86: improve sysfs event mapping with event string
Date: Wed, 21 Nov 2012 13:49:28 +0100
Message-Id: <1353502185-26521-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends Jiri's changes to make generic
events mapping visible via sysfs. The patch extends
the mechanism to non-generic events by allowing
the mappings to be hardcoded in strings.

This mechanism will be used by the PEBS-LL patch
later on.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c |   27 ++++++++++++---------------
 arch/x86/kernel/cpu/perf_event.h |   23 +++++++++++++++++++++++
 2 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b116788..198d74f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1316,20 +1316,22 @@ static struct attribute_group x86_pmu_format_group = {
 	.attrs = NULL,
 };
 
-struct perf_pmu_events_attr {
-	struct device_attribute attr;
-	u64 id;
-};
-
 /*
  * Remove all undefined events (x86_pmu.event_map(id) == 0)
  * out of events_attr attributes.
  */
 static void __init filter_events(struct attribute **attrs)
 {
+	struct device_attribute *d;
+	struct perf_pmu_events_attr *pmu_attr;
 	int i, j;
 
 	for (i = 0; attrs[i]; i++) {
+		d = (struct device_attribute *)attrs[i];
+		pmu_attr = container_of(d, struct perf_pmu_events_attr, attr);
+		/* str trumps id */
+		if (pmu_attr->event_str)
+			continue;
 		if (x86_pmu.event_map(i))
 			continue;
 
@@ -1370,19 +1372,14 @@ static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *at
 {
 	struct perf_pmu_events_attr *pmu_attr = \
 		container_of(attr, struct perf_pmu_events_attr, attr);
-
 	u64 config = x86_pmu.event_map(pmu_attr->id);
-	return x86_pmu.events_sysfs_show(page, config);
-}
 
-#define EVENT_VAR(_id)  event_attr_##_id
-#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+	/* string trumps id */
+	if (pmu_attr->event_str)
+		return sprintf(page, "%s", pmu_attr->event_str);
 
-#define EVENT_ATTR(_name, _id)					\
-static struct perf_pmu_events_attr EVENT_VAR(_id) = {		\
-	.attr = __ATTR(_name, 0444, events_sysfs_show, NULL),	\
-	.id   =  PERF_COUNT_HW_##_id,				\
-};
+	return x86_pmu.events_sysfs_show(page, config);
+}
 
 EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
 EVENT_ATTR(instructions,		INSTRUCTIONS		);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4170043..3f4380c 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -420,6 +420,29 @@ do {									\
 #define ERF_NO_HT_SHARING	1
 #define ERF_HAS_RSP_1		2
 
+#define EVENT_VAR(_id)  event_attr_##_id
+#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+
+#define EVENT_ATTR(_name, _id)					\
+static struct perf_pmu_events_attr EVENT_VAR(_id) = {		\
+	.attr = __ATTR(_name, 0444, events_sysfs_show, NULL),	\
+	.id   =  PERF_COUNT_HW_##_id,				\
+	.event_str = NULL,					\
+};
+
+#define EVENT_ATTR_STR(_name, v, str)				  \
+static struct perf_pmu_events_attr event_attr_##v = {		  \
+	.attr      = __ATTR(_name, 0444, events_sysfs_show, NULL),\
+	.id        =  0,					  \
+	.event_str =  str,					  \
+};
+
+struct perf_pmu_events_attr {
+	struct device_attribute attr;
+	u64 id;
+	const char *event_str;
+};
+
 extern struct x86_pmu x86_pmu __read_mostly;
 
 DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
-- 
1.7.9.5

