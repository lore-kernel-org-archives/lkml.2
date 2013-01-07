Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3AGS21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:28:27 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47008 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3AGS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:28:24 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v5 04/18] perf, core: Add a concept of a weightened sample
Date: Mon,  7 Jan 2013 19:27:43 +0100
Message-Id: <1357583277-4553-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357583277-4553-1-git-send-email-eranian@google.com>
References: <1357583277-4553-1-git-send-email-eranian@google.com>
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
 include/uapi/linux/perf_event.h |    5 ++++-
 kernel/events/core.c            |    6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

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
index 4f63c05..7e24641 100644
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
@@ -587,6 +589,7 @@ enum perf_event_type {
 	 * 	{ u64			size;
 	 * 	  char			data[size];
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
+	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..bc2ce07 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -955,6 +955,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		size += sizeof(data->weight);
+
 	event->header_size = size;
 }
 
@@ -4169,6 +4172,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
 					  data->regs_user.regs);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		perf_output_put(handle, data->weight);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
-- 
1.7.9.5

