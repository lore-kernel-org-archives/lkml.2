Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab0JSN4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:56:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:45089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0JSNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:16 -0400
Message-Id: <20101019134808.253453452@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:42:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] perf, x86: Extract PEBS/BTS allocation functions
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly a cleanup.. it reduces code indentation and makes the code flow
of reserve_ds_buffers() clearer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   90 ++++++++++++++++++------------
 1 file changed, 56 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -74,6 +74,32 @@ static void fini_debug_store_on_cpu(int 
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
+static int alloc_pebs_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int max, thresh = 1; /* always use a single PEBS record */
+	void *buffer;
+
+	if (!x86_pmu.pebs)
+		return 0;
+
+	buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
+	if (unlikely(!buffer))
+		return -ENOMEM;
+
+	max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
+
+	ds->pebs_buffer_base = (u64)(unsigned long)buffer;
+	ds->pebs_index = ds->pebs_buffer_base;
+	ds->pebs_absolute_maximum = ds->pebs_buffer_base +
+		max * x86_pmu.pebs_record_size;
+
+	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
+		thresh * x86_pmu.pebs_record_size;
+
+	return 0;
+}
+
 static void release_pebs_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -85,6 +111,32 @@ static void release_pebs_buffer(int cpu)
 	ds->pebs_buffer_base = 0;
 }
 
+static int alloc_bts_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int max, thresh;
+	void *buffer;
+
+	if (!x86_pmu.bts)
+		return 0;
+
+	buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+	if (unlikely(!buffer))
+		return -ENOMEM;
+
+	max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
+	thresh = max / 16;
+
+	ds->bts_buffer_base = (u64)(unsigned long)buffer;
+	ds->bts_index = ds->bts_buffer_base;
+	ds->bts_absolute_maximum = ds->bts_buffer_base +
+		max * BTS_RECORD_SIZE;
+	ds->bts_interrupt_threshold = ds->bts_absolute_maximum -
+		thresh * BTS_RECORD_SIZE;
+
+	return 0;
+}
+
 static void release_bts_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -133,8 +185,6 @@ static int reserve_ds_buffers(void)
 
 	for_each_possible_cpu(cpu) {
 		struct debug_store *ds;
-		void *buffer;
-		int max, thresh;
 
 		err = -ENOMEM;
 		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
@@ -142,39 +192,11 @@ static int reserve_ds_buffers(void)
 			break;
 		per_cpu(cpu_hw_events, cpu).ds = ds;
 
-		if (x86_pmu.bts) {
-			buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
-			if (unlikely(!buffer))
-				break;
-
-			max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
-			thresh = max / 16;
-
-			ds->bts_buffer_base = (u64)(unsigned long)buffer;
-			ds->bts_index = ds->bts_buffer_base;
-			ds->bts_absolute_maximum = ds->bts_buffer_base +
-				max * BTS_RECORD_SIZE;
-			ds->bts_interrupt_threshold = ds->bts_absolute_maximum -
-				thresh * BTS_RECORD_SIZE;
-		}
+		if (alloc_bts_buffer(cpu))
+			break;
 
-		if (x86_pmu.pebs) {
-			buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
-			if (unlikely(!buffer))
-				break;
-
-			max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
-
-			ds->pebs_buffer_base = (u64)(unsigned long)buffer;
-			ds->pebs_index = ds->pebs_buffer_base;
-			ds->pebs_absolute_maximum = ds->pebs_buffer_base +
-				max * x86_pmu.pebs_record_size;
-			/*
-			 * Always use single record PEBS
-			 */
-			ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
-				x86_pmu.pebs_record_size;
-		}
+		if (alloc_pebs_buffer(cpu))
+			break;
 
 		err = 0;
 	}


