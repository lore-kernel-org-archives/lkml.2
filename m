Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab0ERRtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:49:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:42546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578Ab0ERRtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:49:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="568317512"
Subject: [RFC][PATCH v2 09/11] perf: multiplex perf_event_attr::type field
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:49:12 +0000
Message-Id: <1274233752.3036.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf_event_attr::type consist of:
(bit 31) | (fd << 12) | type

 Bits 0-11: the original type, PERF_TYPE_HARDWARE etc...
Bits 12-30: the opened sys fd
    Bit 31: if set, means an opened sys fd is there

Changes log,
Use bit 31 of perf_event_attr::type to tell an opened sys fd. (Peter Zijlstra)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    6 +++---
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 include/linux/perf_event.h             |   13 ++++++++++++-
 kernel/hw_breakpoint.c                 |    2 +-
 kernel/perf_event.c                    |   16 ++++++++--------
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/util/parse-events.c         |    2 +-
 9 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 148eee6..24bb00d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -449,10 +449,10 @@ static int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	if (attr->type == PERF_TYPE_RAW)
+	if (PERF_EVENT_ATTR_TYPE(attr) == PERF_TYPE_RAW)
 		return 0;
 
-	if (attr->type == PERF_TYPE_HW_CACHE)
+	if (PERF_EVENT_ATTR_TYPE(attr) == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
 
 	if (attr->config >= x86_pmu.max_events)
@@ -519,7 +519,7 @@ static int x86_pmu_hw_config(struct perf_event *event)
 	if (!event->attr.exclude_kernel)
 		event->hw.config |= ARCH_PERFMON_EVENTSEL_OS;
 
-	if (event->attr.type == PERF_TYPE_RAW)
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
 	return x86_setup_perfctr(event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 611df11..da36860 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -118,7 +118,7 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (event->attr.type != PERF_TYPE_RAW)
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) != PERF_TYPE_RAW)
 		return 0;
 
 	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fdbc652..d997296 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -767,7 +767,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (event->attr.type != PERF_TYPE_RAW)
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) != PERF_TYPE_RAW)
 		return 0;
 
 	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 424fc8d..3b73db1 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -436,7 +436,7 @@ static int p4_hw_config(struct perf_event *event)
 	if (p4_ht_active() && p4_ht_thread(cpu))
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
-	if (event->attr.type == PERF_TYPE_RAW) {
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) == PERF_TYPE_RAW) {
 
 		/* user data may have out-of-bound event index */
 		evnt = p4_config_unpack_event(event->attr.config);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ef519d2..9e93649 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -161,6 +161,17 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
 
 /*
+ * perf_event_attr::type consist of:
+ * PERF_EVENT_FD | (fd << 12) | type
+ */
+#define PERF_EVENT_FD			(1 << 31)
+#define PERF_EVENT_ATTR_TYPE_MASK	0x00000fff
+#define PERF_EVENT_ATTR_FD_MASK		0x7ffff000
+#define PERF_EVENT_ATTR_TYPE(attr)	((attr)->type & PERF_EVENT_ATTR_TYPE_MASK)
+#define PERF_EVENT_ATTR_TYPE_BITS	12
+#define PERF_EVENT_ATTR_FD(attr)	(((attr)->type & PERF_EVENT_ATTR_FD_MASK) >> PERF_EVENT_ATTR_TYPE_BITS)
+
+/*
  * Hardware event_id to monitor via a performance monitoring event:
  */
 struct perf_event_attr {
@@ -903,7 +914,7 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
  */
 static inline int is_software_event(struct perf_event *event)
 {
-	switch (event->attr.type) {
+	switch (PERF_EVENT_ATTR_TYPE(&event->attr)) {
 	case PERF_TYPE_SOFTWARE:
 	case PERF_TYPE_TRACEPOINT:
 	/* for now the breakpoint stuff also works as software event */
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 7a56b22..93c5f27 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -123,7 +123,7 @@ static int task_bp_pinned(struct task_struct *tsk, enum bp_type_idx type)
 	 * at the open() callback time
 	 */
 	list_for_each_entry(bp, list, event_entry) {
-		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
+		if (PERF_EVENT_ATTR_TYPE(&bp->attr) == PERF_TYPE_BREAKPOINT)
 			if (find_slot_idx(bp) == type)
 				count += hw_breakpoint_weight(bp);
 	}
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f6df0f8..8640610 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4045,7 +4045,7 @@ static int perf_swevent_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
-	if (event->attr.type != type)
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) != type)
 		return 0;
 
 	if (event->attr.config != event_id)
@@ -4054,7 +4054,7 @@ static int perf_swevent_match(struct perf_event *event,
 	if (perf_exclude_event(event, regs))
 		return 0;
 
-	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) == PERF_TYPE_TRACEPOINT &&
 	    !perf_tp_event_match(event, data))
 		return 0;
 
@@ -4180,7 +4180,7 @@ static int perf_swevent_enable(struct perf_event *event)
 		perf_swevent_set_period(event);
 	}
 
-	head = find_swevent_head(cpuctx, event->attr.type, event->attr.config);
+	head = find_swevent_head(cpuctx, PERF_EVENT_ATTR_TYPE(&event->attr), event->attr.config);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
 
@@ -4534,7 +4534,7 @@ static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 	char *filter_str;
 	int ret;
 
-	if (event->attr.type != PERF_TYPE_TRACEPOINT)
+	if (PERF_EVENT_ATTR_TYPE(&event->attr) != PERF_TYPE_TRACEPOINT)
 		return -EINVAL;
 
 	filter_str = strndup_user(arg, PAGE_SIZE);
@@ -4683,9 +4683,9 @@ static struct pmu *sw_perf_event_init(struct perf_event *event)
 static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
-	int pmu_id = event->attr.type;
+	int pmu_id = PERF_EVENT_ATTR_TYPE(&event->attr);
 
-	switch (event->attr.type) {
+	switch (pmu_id) {
 		case PERF_TYPE_HARDWARE:
 		case PERF_TYPE_HW_CACHE:
 		case PERF_TYPE_RAW:
@@ -4784,7 +4784,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto done;
 
-	switch (attr->type) {
+	switch (PERF_EVENT_ATTR_TYPE(&event->attr)) {
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
@@ -4896,7 +4896,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	 * If the type exists, the corresponding creation will verify
 	 * the attr->config.
 	 */
-	if (attr->type >= PERF_TYPE_MAX)
+	if (PERF_EVENT_ATTR_TYPE(attr) >= PERF_TYPE_MAX)
 		return -EINVAL;
 
 	if (attr->__reserved_1)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 397290a..adc179d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1239,7 +1239,7 @@ try_again:
 			 * based cpu-clock-tick sw counter, which
 			 * is always available even if no PMU support:
 			 */
-			if (attr->type == PERF_TYPE_HARDWARE
+			if (PERF_EVENT_ATTR_TYPE(attr) == PERF_TYPE_HARDWARE
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9bf0f40..e962c55 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -269,7 +269,7 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
 const char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
-	int type = attrs[counter].type;
+	int type = PERF_EVENT_ATTR_TYPE(&attrs[counter]);
 
 	return __event_name(type, config);
 }




