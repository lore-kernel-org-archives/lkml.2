Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2KUMzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:55:31 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35056 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2KUMvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:36 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 04/19] perf, core: Add a concept of a weightened sample
Date: Wed, 21 Nov 2012 13:49:30 +0100
Message-Id: <1353502185-26521-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
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
index 484cfbc..bb2429d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -584,6 +584,7 @@ struct perf_sample_data {
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
+	u64				weight;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -597,6 +598,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
+	data->weight = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 4f63c05..c52caab 100644
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
@@ -198,8 +200,9 @@ enum perf_event_read_format {
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
 	PERF_FORMAT_GROUP			= 1U << 3,
+	PERF_FORMAT_WEIGHT			= 1U << 4,
 
-	PERF_FORMAT_MAX = 1U << 4,		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
@@ -559,6 +562,7 @@ enum perf_event_type {
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
1.7.9.5

