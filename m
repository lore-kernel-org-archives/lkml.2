Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2I1EgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:36:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:51577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2I1Eby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="199033677"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/31] perf, core: Add generic transaction flags
Date: Thu, 27 Sep 2012 21:31:32 -0700
Message-Id: <1348806696-31170-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a generic qualifier for transaction events, as a new sample
type that returns a flag word. This is particularly useful
for qualifying aborts: to distinguish aborts which happen
due to asynchronous events (like conflicts caused by another
CPU) versus instructions that lead to an abort.

The tuning strategies are very different for those cases,
so it's important to distinguish them easily and early.

Since it's inconvenient and inflexible to filter for this
in the kernel we report all the events out and allow
some post processing in user space.

The flags are based on the Intel TSX events, but should be fairly
generic and mostly applicable to other architectures too. In addition
to various flag words there's also reserved space to report an
program supplied abort code. For TSX this is used to distinguish specific
classes of aborts, like a lock busy abort when doing lock elision.

This adds the perf core glue needed for reporting the new flag word out.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h |   25 ++++++++++++++++++++++++-
 kernel/events/core.c       |    6 ++++++
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1867bed..beafd7f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -156,8 +156,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_RAW				= 1U << 10,
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 	PERF_SAMPLE_WEIGHT			= 1U << 12,
+	PERF_SAMPLE_TRANSACTION			= 1U << 13,
 
-	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
 };
 
 /*
@@ -192,6 +193,26 @@ enum perf_branch_sample_type {
 	 PERF_SAMPLE_BRANCH_HV)
 
 /*
+ * Values for the transaction event qualifier, mostly for abort events.
+ */
+enum {
+	PERF_SAMPLE_TXN_ELISION     = (1 << 0), /* From elision */
+	PERF_SAMPLE_TXN_TRANSACTION = (1 << 1), /* From transaction */
+	PERF_SAMPLE_TXN_SYNC        = (1 << 2), /* Instruction is related */
+	PERF_SAMPLE_TXN_ASYNC       = (1 << 3), /* Instruction not related */
+	PERF_SAMPLE_TXN_RETRY       = (1 << 4), /* Retry possible */
+	PERF_SAMPLE_TXN_CONFLICT    = (1 << 5), /* Conflict abort */
+	PERF_SAMPLE_TXN_CAPACITY    = (1 << 6), /* Capacity abort */
+
+	PERF_SAMPLE_TXN_MAX	    = (1 << 7),  /* non-ABI */
+
+	/* bits 24..31 are reserved for the abort code */
+
+	PERF_SAMPLE_TXN_ABORT_MASK  = 0xff000000,
+	PERF_SAMPLE_TXN_ABORT_SHIFT = 24,
+};
+
+/*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
  *
@@ -1173,6 +1194,7 @@ struct perf_sample_data {
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
 	u64				weight;
+	u64				transaction;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -1184,6 +1206,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->br_stack = NULL;
 	data->period	= period;
 	data->weight = 0;
+	data->transaction = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 74e4ff4..6af2e76 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -952,6 +952,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		size += sizeof(data->weight);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		size += sizeof(data->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -3963,6 +3966,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		perf_output_put(handle, data->weight);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		perf_output_put(handle, data->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
-- 
1.7.7.6

