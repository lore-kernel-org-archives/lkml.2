Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1KUO4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:56:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44749 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1KUO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:56:08 -0500
Message-Id: <20111121145337.626579222@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 15:51:17 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/6] perf, x86: Implement userspace RDPMC
References: <20111121145114.049265181@chello.nl>
Content-Disposition: inline; filename=perf-rdpmc-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a correct pmu::event_idx for the x86 counter index rules and
set CR4.PCE on CPU_STARTING.

Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1211,6 +1211,7 @@ x86_pmu_notifier(struct notifier_block *
 		break;
 
 	case CPU_STARTING:
+		set_in_cr4(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1536,6 +1537,18 @@ static int x86_pmu_event_init(struct per
 	return err;
 }
 
+static int x86_pmu_event_idx(struct perf_event *event)
+{
+	int idx = event->hw.idx;
+
+	if (x86_pmu.num_counters_fixed && idx >= X86_PMC_IDX_FIXED) {
+		idx -= X86_PMC_IDX_FIXED;
+		idx |= 1 << 30;
+	}
+
+	return idx + 1;
+}
+
 static struct pmu pmu = {
 	.pmu_enable	= x86_pmu_enable,
 	.pmu_disable	= x86_pmu_disable,
@@ -1551,6 +1564,8 @@ static struct pmu pmu = {
 	.start_txn	= x86_pmu_start_txn,
 	.cancel_txn	= x86_pmu_cancel_txn,
 	.commit_txn	= x86_pmu_commit_txn,
+
+	.event_idx	= x86_pmu_event_idx,
 };
 
 /*


