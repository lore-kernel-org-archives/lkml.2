Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0IJL3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:29:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab0IJL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:29:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=pfT69382ziERlc6dsnIVO6HfcDT1lxrmAr0is5UnoJ78hYwgyi0VWjyHzhmFG+lEV
	nK5akefQbGWnwTL4ghxkA==
Message-ID: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 10 Sep 2010 13:28:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, dzickus@redhat.com
Subject: [PATCH] perf_events: fix BTS interrupt handling to avoid being dazed by NMI (v2)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug introduced with commit de725de and the change in the meaning of the
return value of intel_pmu_handle_irq(). With the current code, when you are
using the BTS, you get 'dazed by NMI' each time the BTS buffer fills up.

BTS does interrupt on the PMU vector, thus NMI. You need to take this
into account in the return value of the function.

This version fixes initial patch which was missing changes to
perf_event_intel_ds.c.

Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ee05c90..b4d2e1c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -713,18 +713,18 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
 	u64 status;
-	int handled = 0;
+	int handled;
 
 	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	intel_pmu_disable_all();
-	intel_pmu_drain_bts_buffer();
+	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
 		intel_pmu_enable_all(0);
-		return 0;
+		return handled;
 	}
 
 	loops = 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 18018d1..44c8cfd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -214,7 +214,7 @@ static void intel_pmu_disable_bts(void)
 	update_debugctlmsr(debugctlmsr);
 }
 
-static void intel_pmu_drain_bts_buffer(void)
+static int intel_pmu_drain_bts_buffer(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
@@ -231,16 +231,16 @@ static void intel_pmu_drain_bts_buffer(void)
 	struct pt_regs regs;
 
 	if (!event)
-		return;
+		return 0;
 
 	if (!ds)
-		return;
+		return 0;
 
 	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
 	top = (struct bts_record *)(unsigned long)ds->bts_index;
 
 	if (top <= at)
-		return;
+		return 0;
 
 	ds->bts_index = ds->bts_buffer_base;
 
@@ -256,7 +256,7 @@ static void intel_pmu_drain_bts_buffer(void)
 	perf_prepare_sample(&header, &data, event, &regs);
 
 	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
-		return;
+		return 1;
 
 	for (; at < top; at++) {
 		data.ip		= at->from;
@@ -270,6 +270,7 @@ static void intel_pmu_drain_bts_buffer(void)
 	/* There's new data available. */
 	event->hw.interrupts++;
 	event->pending_kill = POLL_IN;
+	return 1;
 }
 
 /*
