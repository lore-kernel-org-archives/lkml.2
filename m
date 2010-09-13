Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0IMIeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:34:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0IMIeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:34:24 -0400
Date: Mon, 13 Sep 2010 08:33:55 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
References: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix BTS interrupt handling to avoid being dazed by NMI (v2)
Message-ID: <tip-b0b2072df3b544f56b90173c2cde7a374c51546b@git.kernel.org>
Git-Commit-ID: b0b2072df3b544f56b90173c2cde7a374c51546b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 08:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0b2072df3b544f56b90173c2cde7a374c51546b
Gitweb:     http://git.kernel.org/tip/b0b2072df3b544f56b90173c2cde7a374c51546b
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 10 Sep 2010 13:28:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Sep 2010 08:43:40 +0200

perf_events: Fix BTS interrupt handling to avoid being dazed by NMI (v2)

Fix a bug introduced with commit de725de and the change in the
meaning of the return value of intel_pmu_handle_irq(). With the
current code, when you are using the BTS, you get 'dazed by NMI'
each time the BTS buffer fills up.

BTS does interrupt on the PMU vector, thus NMI. You need to take
this into account in the return value of the function.

This version fixes initial patch which was missing changes to
perf_event_intel_ds.c.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: perfmon2-devel@lists.sf.net
Cc: eranian@gmail.com
Cc: robert.richter@amd.com
LKML-Reference: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c    |    6 +++---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 82395f2..c8f5c08 100644
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
index 9893a2f..4977f9c 100644
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
