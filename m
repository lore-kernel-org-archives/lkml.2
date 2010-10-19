Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0JSNza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:55:30 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43768 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0JSNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:23 -0400
Message-Id: <20101019134808.196793164@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:42:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] perf, x86: Extract PEBS/BTS buffer free routines
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we may grow additional call-sites..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -74,6 +74,28 @@ static void fini_debug_store_on_cpu(int 
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
+static void release_pebs_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds || !x86_pmu.pebs)
+		return;
+
+	kfree((void *)(unsigned long)ds->pebs_buffer_base);
+	ds->pebs_buffer_base = 0;
+}
+
+static void release_bts_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds || !x86_pmu.bts)
+		return;
+
+	kfree((void *)(unsigned long)ds->bts_buffer_base);
+	ds->bts_buffer_base = 0;
+}
+
 static void release_ds_buffers(void)
 {
 	int cpu;
@@ -82,7 +104,6 @@ static void release_ds_buffers(void)
 		return;
 
 	get_online_cpus();
-
 	for_each_online_cpu(cpu)
 		fini_debug_store_on_cpu(cpu);
 
@@ -92,13 +113,12 @@ static void release_ds_buffers(void)
 		if (!ds)
 			continue;
 
-		per_cpu(cpu_hw_events, cpu).ds = NULL;
+		release_pebs_buffer(cpu);
+		release_bts_buffer(cpu);
 
-		kfree((void *)(unsigned long)ds->pebs_buffer_base);
-		kfree((void *)(unsigned long)ds->bts_buffer_base);
+		per_cpu(cpu_hw_events, cpu).ds = NULL;
 		kfree(ds);
 	}
-
 	put_online_cpus();
 }
 


