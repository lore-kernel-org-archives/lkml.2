Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab2LSH2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:28:22 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44533 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab2LSH2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:28:17 -0500
Date: Tue, 18 Dec 2012 23:28:02 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] perf: Make EVENT_ATTR and EVENT_PTR global
Message-ID: <20121219072802.GA30790@us.ibm.com>
References: <20121219072646.GA30580@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219072646.GA30580@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121907-7182-0000-0000-000003E502B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rename EVENT_ATTR() and EVENT_PTR() PMU_EVENT_ATTR() and PMU_EVENT_PTR().
Make them global so they are available to all architectures.

Further to allow architectures flexibility, have PMU_EVENT_PTR() pass in the
variable name as a parameter.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/perf_event.c |   17 +++++------------
 include/linux/perf_event.h       |   13 +++++++++++++
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..24bc505 100644
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
@@ -1351,14 +1346,12 @@ static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *at
 	return x86_pmu.events_sysfs_show(page, config);
 }
 
-#define EVENT_VAR(_id)  event_attr_##_id
-#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+#define EVENT_VAR(_id)	event_attr_##_id
+#define EVENT_ID(_id)	PERF_COUNT_HW_##_id
+#define EVENT_PTR(_id)	PMU_EVENT_PTR(EVENT_VAR(_id))
 
-#define EVENT_ATTR(_name, _id)					\
-static struct perf_pmu_events_attr EVENT_VAR(_id) = {		\
-	.attr = __ATTR(_name, 0444, events_sysfs_show, NULL),	\
-	.id   =  PERF_COUNT_HW_##_id,				\
-};
+#define EVENT_ATTR(_name, _id)						\
+	PMU_EVENT_ATTR(_name, EVENT_VAR(_id), EVENT_ID(_id), events_sysfs_show)
 
 EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
 EVENT_ATTR(instructions,		INSTRUCTIONS		);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6bfb2fa..31692cb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -817,6 +817,19 @@ do {									\
 } while (0)
 
 
+struct perf_pmu_events_attr {
+	struct device_attribute attr;
+	u64 id;
+};
+
+#define PMU_EVENT_PTR(_var)	&_var.attr.attr
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

