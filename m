Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2KJBcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:32:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:26777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab2KJB2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="246777199"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/32] perf, core: Add a concept of a weightened sample
Date: Fri,  9 Nov 2012 17:27:30 -0800
Message-Id: <1352510868-7911-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For some events it's useful to weight sample with a hardware
provided number. This expresses how expensive the action the
sample represent was.  This allows the profiler to scale
the samples to be more informative to the programmer.

There is already the period which is used similarly, but it means
something different, so I chose to not overload it. Instead
a new sample type for WEIGHT is added.

Can be used for multiple things. Initially it is used for TSX abort costs
and profiling by memory latencies (so to make expensive load appear higher
up in the histograms)  The concept is quite generic and can be extended
to many other kinds of events or architectures, as long as the hardware
provides suitable auxillary values. In principle it could be also
used for software tracpoints.

This adds the generic glue. A new optional sample format for a 64bit
weight value.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h      |    2 ++
 include/uapi/linux/perf_event.h |    8 ++++++--
 kernel/events/core.c            |    6 ++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 91052e1..c9686c8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -588,6 +588,7 @@ struct perf_sample_data {
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
+	u64				weight;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -601,6 +602,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
+	data->weight = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 8e38823..809a5fd 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -132,8 +132,10 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 	PERF_SAMPLE_REGS_USER			= 1U << 12,
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
+	PERF_SAMPLE_WEIGHT			= 1U << 14,
+
+	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
 
-	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
 };
 
 /*
@@ -201,8 +203,9 @@ enum perf_event_read_format {
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
 	PERF_FORMAT_GROUP			= 1U << 3,
+	PERF_FORMAT_WEIGHT			= 1U << 4,
 
-	PERF_FORMAT_MAX = 1U << 4,		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
@@ -562,6 +565,7 @@ enum perf_event_type {
 	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
 	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
+	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *
 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
 	 *
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dbccf83..d633581 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -952,6 +952,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		size += sizeof(data->period);
 
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		size += sizeof(data->weight);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -4080,6 +4083,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		perf_output_put(handle, data->period);
 
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		perf_output_put(handle, data->weight);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
-- 
1.7.7.6

