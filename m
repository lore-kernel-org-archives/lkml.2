Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2KJBaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:30:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:39679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2KJB2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="246777200"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/32] perf, core: Add generic transaction flags v2
Date: Fri,  9 Nov 2012 17:27:35 -0800
Message-Id: <1352510868-7911-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
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

v2: Add MEM/MISC
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h      |    2 ++
 include/uapi/linux/perf_event.h |   26 ++++++++++++++++++++++++--
 kernel/events/core.c            |    6 ++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c9686c8..c32fba3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -589,6 +589,7 @@ struct perf_sample_data {
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
 	u64				weight;
+	u64				transaction;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -603,6 +604,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
+	data->transaction = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 809a5fd..e7b1a48 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -133,9 +133,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_REGS_USER			= 1U << 12,
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
+	PERF_SAMPLE_TRANSACTION			= 1U << 15,
 
-	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
-
+	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
 };
 
 /*
@@ -179,6 +179,28 @@ enum perf_sample_regs_abi {
 };
 
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
+	PERF_SAMPLE_TXN_MEMORY      = (1 << 7), /* Memory related abort */
+	PERF_SAMPLE_TXN_MISC        = (1 << 8), /* Misc aborts */
+
+	PERF_SAMPLE_TXN_MAX	    = (1 << 9),  /* non-ABI */
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
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d633581..534810d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -955,6 +955,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		size += sizeof(data->weight);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		size += sizeof(data->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -4086,6 +4089,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		perf_output_put(handle, data->weight);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		perf_output_put(handle, data->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
-- 
1.7.7.6

