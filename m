Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0JSNz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:55:27 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43766 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0JSNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:23 -0400
Message-Id: <20101019134808.514465326@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:43:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/7] perf, x86: Use NUMA aware allocations for PEBS/BTS/DS allocations
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For performance reasons its best to use NODE local memory for per-cpu buffers.

This logic comes from a much larger patch proposed by Stephane.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -77,13 +77,14 @@ static void fini_debug_store_on_cpu(int 
 static int alloc_pebs_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int node = cpu_to_node(cpu);
 	int max, thresh = 1; /* always use a single PEBS record */
 	void *buffer;
 
 	if (!x86_pmu.pebs)
 		return 0;
 
-	buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
+	buffer = kmalloc_node(PEBS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -114,13 +115,14 @@ static void release_pebs_buffer(int cpu)
 static int alloc_bts_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int node = cpu_to_node(cpu);
 	int max, thresh;
 	void *buffer;
 
 	if (!x86_pmu.bts)
 		return 0;
 
-	buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+	buffer = kmalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -150,9 +152,10 @@ static void release_bts_buffer(int cpu)
 
 static int alloc_ds_buffer(int cpu)
 {
+	int node = cpu_to_node(cpu);
 	struct debug_store *ds;
 
-	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	ds = kmalloc_node(sizeof(*ds), GFP_KERNEL | __GFP_ZERO, node);
 	if (unlikely(!ds))
 		return -ENOMEM;
 


