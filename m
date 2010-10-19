Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0JSN4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:56:12 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43769 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0JSNz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:26 -0400
Message-Id: <20101019134808.304495776@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:42:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/7] perf, x86: Extract DS alloc/free functions
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, mostly a cleanup to unclutter the reserve_ds_buffer() code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   40 +++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -148,6 +148,30 @@ static void release_bts_buffer(int cpu)
 	ds->bts_buffer_base = 0;
 }
 
+static int alloc_ds_buffer(int cpu)
+{
+	struct debug_store *ds;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (unlikely(!ds))
+		return -ENOMEM;
+
+	per_cpu(cpu_hw_events, cpu).ds = ds;
+
+	return 0;
+}
+
+static void release_ds_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds)
+		return;
+
+	per_cpu(cpu_hw_events, cpu).ds = NULL;
+	kfree(ds);
+}
+
 static void release_ds_buffers(void)
 {
 	int cpu;
@@ -160,16 +184,9 @@ static void release_ds_buffers(void)
 		fini_debug_store_on_cpu(cpu);
 
 	for_each_possible_cpu(cpu) {
-		struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
-
-		if (!ds)
-			continue;
-
 		release_pebs_buffer(cpu);
 		release_bts_buffer(cpu);
-
-		per_cpu(cpu_hw_events, cpu).ds = NULL;
-		kfree(ds);
+		release_ds_buffer(cpu);
 	}
 	put_online_cpus();
 }
@@ -184,13 +201,8 @@ static int reserve_ds_buffers(void)
 	get_online_cpus();
 
 	for_each_possible_cpu(cpu) {
-		struct debug_store *ds;
-
-		err = -ENOMEM;
-		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
-		if (unlikely(!ds))
+		if (alloc_ds_buffer(cpu))
 			break;
-		per_cpu(cpu_hw_events, cpu).ds = ds;
 
 		if (alloc_bts_buffer(cpu))
 			break;


