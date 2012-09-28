Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2I1EeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:34:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:39591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab2I1Eb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093239"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 22/31] perf, core: Define generic hardware transaction events
Date: Thu, 27 Sep 2012 21:31:27 -0700
Message-Id: <1348806696-31170-23-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For tuning and debugging hardware transactional memory it is very
important to have hardware counter support.

This patch adds a simple and hopefully generic set of hardware events
for transactional memory and lock elision.

It is based on the TSX PMU support because I don't have any
information on other CPU's HTM support.

There are start, commit and abort events for transactions and
for lock elision.

The abort events are qualified by a generic abort reason that should
be roughly applicable to a wide range of memory transaction systems:

capacity for the buffering capacity
conflict for a dynamic conflict between CPUs
all      for all aborts. On TSX this can be precisely sampled.

We need to split the events into general transaction events and lock
elision events. Architecturs with HTM but no lock elision would only
use the first set.

Implementation for Haswell in a followon patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h |    4 ++++
 include/linux/perf_event.h       |   25 +++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 87c2ab0..cee8f80 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -53,6 +53,13 @@ u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
 /*
+ * Generalized transactional memory event table.
+ */
+u64 __read_mostly hw_transaction_event_ids
+				[PERF_COUNT_HW_TRANSACTION_MAX]
+				[PERF_COUNT_HW_ABORT_MAX];
+
+/*
  * Propagate event elapsed time into the generic event.
  * Can only be executed on the CPU where the event is active.
  * Returns the delta events processed.
@@ -285,6 +292,31 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event *event)
 	return x86_pmu_extra_regs(val, event);
 }
 
+static int
+set_hw_transaction_attr(struct hw_perf_event *hwc, struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	u64 config, val;
+	unsigned int op, reason;
+
+	config = attr->config;
+	op = config & 0xff;
+	if (op >= PERF_COUNT_HW_TRANSACTION_MAX)
+		return -EINVAL;
+	reason = (config >> 8) & 0xff;
+	if (reason >= PERF_COUNT_HW_ABORT_MAX)
+		return -EINVAL;
+	if (config >> 16)
+		return -EINVAL;
+	val = hw_transaction_event_ids[config][reason];
+	if (val == 0)
+		return -ENOENT;
+	if (val == -1)
+		return -EINVAL;
+	hwc->config |= val;
+	return 0;
+}
+
 int x86_setup_perfctr(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
@@ -312,6 +344,9 @@ int x86_setup_perfctr(struct perf_event *event)
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
 
+	if (attr->type == PERF_TYPE_HW_TRANSACTION)
+		return set_hw_transaction_attr(hwc, event);
+
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
 
@@ -1547,6 +1582,7 @@ static int x86_pmu_event_init(struct perf_event *event)
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_HW_TRANSACTION:
 		break;
 
 	default:
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 724a141..6a8730e 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -452,6 +452,10 @@ extern u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+extern u64 __read_mostly hw_transaction_event_ids
+				[PERF_COUNT_HW_TRANSACTION_MAX]
+				[PERF_COUNT_HW_ABORT_MAX];
+
 u64 x86_perf_event_update(struct perf_event *event);
 
 static inline int x86_pmu_addr_offset(int index)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c488ae2..1867bed 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -32,6 +32,7 @@ enum perf_type_id {
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
 	PERF_TYPE_BREAKPOINT			= 5,
+	PERF_TYPE_HW_TRANSACTION		= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -94,6 +95,30 @@ enum perf_hw_cache_op_result_id {
 };
 
 /*
+ * Transactional memory related events:
+ * { op, reason } (8 bits each)
+ * Only aborts have a reason.
+ */
+enum perf_hw_transaction_op_id {
+	PERF_COUNT_HW_TRANSACTION_START		= 0,
+	PERF_COUNT_HW_TRANSACTION_COMMIT	= 1,
+	PERF_COUNT_HW_TRANSACTION_ABORT         = 2, /* qualified by reason */
+	PERF_COUNT_HW_ELISION_START		= 3,
+	PERF_COUNT_HW_ELISION_COMMIT		= 4,
+	PERF_COUNT_HW_ELISION_ABORT		= 5, /* qualified by reason */
+
+	PERF_COUNT_HW_TRANSACTION_MAX,		/* non-ABI */
+};
+
+enum perf_transaction_abort_reason_id {
+	PERF_COUNT_HW_ABORT_ALL			= 0, /* all aborts */
+	PERF_COUNT_HW_ABORT_CONFLICT		= 1, /* conflict with other CPU */
+	PERF_COUNT_HW_ABORT_CAPACITY		= 2, /* abort due to capacity */
+
+	PERF_COUNT_HW_ABORT_MAX,		/* non-ABI */
+};
+
+/*
  * Special "software" events provided by the kernel, even if the hardware
  * does not support performance events. These events measure various
  * physical and sw events of the kernel (and allow the profiling of them as
-- 
1.7.7.6

