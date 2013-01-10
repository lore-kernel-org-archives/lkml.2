Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3AJAUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:20:33 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33394 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3AJAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:20:31 -0500
From: sukadev@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        <robert.richter@amd.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6][v3] perf: Make EVENT_ATTR global
Date: Wed,  9 Jan 2013 16:20:28 -0800
Message-Id: <1357777232-32037-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1357777232-32037-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1357777232-32037-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011000-7182-0000-0000-0000044F87B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename EVENT_ATTR() to PMU_EVENT_ATTR() and make it global so it is
available to all architectures.

Further to allow architectures flexibility, have PMU_EVENT_ATTR() pass
in the variable name as a parameter.

Changelog[v3]
	- [Jiri Olsa] No need to define PMU_EVENT_PTR()

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/perf_event.c |   13 +++----------
 include/linux/perf_event.h       |   11 +++++++++++
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..59a1238 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1316,11 +1316,6 @@ static struct attribute_group x86_pmu_format_group = {
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
@@ -1354,11 +1349,9 @@ static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *at
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
 
-#define EVENT_ATTR(_name, _id)					\
-static struct perf_pmu_events_attr EVENT_VAR(_id) = {		\
-	.attr = __ATTR(_name, 0444, events_sysfs_show, NULL),	\
-	.id   =  PERF_COUNT_HW_##_id,				\
-};
+#define EVENT_ATTR(_name, _id)						\
+	PMU_EVENT_ATTR(_name, EVENT_VAR(_id), PERF_COUNT_HW_##_id,	\
+			events_sysfs_show)
 
 EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
 EVENT_ATTR(instructions,		INSTRUCTIONS		);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6bfb2fa..42adf01 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -817,6 +817,17 @@ do {									\
 } while (0)
 
 
+struct perf_pmu_events_attr {
+	struct device_attribute attr;
+	u64 id;
+};
+
+#define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
+static struct perf_pmu_events_attr _var = {				\
+	.attr = __ATTR(_name, 0444, _show, NULL),			\
+	.id   =  _id,							\
+};
+
 #define PMU_FORMAT_ATTR(_name, _format)					\
 static ssize_t								\
 _name##_show(struct device *dev,					\
-- 
1.7.1

