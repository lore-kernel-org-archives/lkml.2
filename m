Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1GDH4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:56:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:47700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab1GDH4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:56:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="23490032"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] perf: Add memory load/store events generic code
Date: Mon,  4 Jul 2011 08:02:02 +0000
Message-Id: <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic memory load/store events: PERF_COUNT_HW_MEM_{LOAD, STORE}
Add generic memory load/store operation encoding.
Add code to handle memory operation data.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/perf_event.h |   44 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/events/core.c       |   12 ++++++++++++
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e76a410..c410ae4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -54,6 +54,8 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
 	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
 	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
+	PERF_COUNT_HW_MEM_LOAD			= 9,
+	PERF_COUNT_HW_MEM_STORE			= 10,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
@@ -127,8 +129,10 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_LATENCY			= 1U << 11,
+	PERF_SAMPLE_EXTRA			= 1U << 12,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
 };
 
 /*
@@ -432,6 +436,8 @@ enum perf_event_type {
 	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
+	 *	{ u64			latency;  } && PERF_SAMPLE_LATENCY
+	 *	{ u64			extra;    } && PERF_SAMPLE_EXTRA
 	 *
 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
 	 *
@@ -474,6 +480,40 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+/*
+ * Memory load operation info encoding
+ */
+
+/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached, reserved} */
+#define MEM_LOAD_L1			0x00
+#define MEM_LOAD_L2			0x01
+#define MEM_LOAD_L3			0x02
+#define MEM_LOAD_RAM			0x03
+#define MEM_LOAD_UNKNOWN		0x00
+#define MEM_LOAD_IO			0x01
+#define MEM_LOAD_UNCACHED		0x02
+#define MEM_LOAD_RESERVED		0x03
+
+/* Bits(2-3) {toggle, snoop, local, remote} */
+#define MEM_LOAD_TOGGLE			(0x00 << 2)
+#define MEM_LOAD_SNOOP			(0x01 << 2)
+#define MEM_LOAD_LOCAL			(0x02 << 2)
+#define MEM_LOAD_REMOTE			(0x03 << 2)
+
+/* Bits(4-5) {modified, exclusive, shared, invalid} */
+#define MEM_LOAD_MODIFIED		(0x00 << 4)
+#define MEM_LOAD_EXCLUSIVE		(0x01 << 4)
+#define MEM_LOAD_SHARED			(0x02 << 4)
+#define MEM_LOAD_INVALID		(0x03 << 4)
+
+/*
+ * Memory store operation info encoding
+ */
+
+#define MEM_STORE_DCU_HIT		(1ULL << 0)
+#define MEM_STORE_STLB_HIT		(1ULL << 1)
+#define MEM_STORE_LOCKED_ACCESS		(1ULL << 2)
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -974,6 +1014,8 @@ struct perf_sample_data {
 		u32	reserved;
 	}				cpu_entry;
 	u64				period;
+	u64				latency;
+	u64				extra;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5e70f62..b835ef5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -887,6 +887,12 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		size += sizeof(data->period);
 
+	if (sample_type & PERF_SAMPLE_LATENCY)
+		size += sizeof(data->latency);
+
+	if (sample_type & PERF_SAMPLE_EXTRA)
+		size += sizeof(data->extra);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -3871,6 +3877,12 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		perf_output_put(handle, data->period);
 
+	if (sample_type & PERF_SAMPLE_LATENCY)
+		perf_output_put(handle, data->latency);
+
+	if (sample_type & PERF_SAMPLE_EXTRA)
+		perf_output_put(handle, data->extra);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
-- 
1.7.5.1

