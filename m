Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab0EGSoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:44:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977Ab0EGSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:44:20 -0400
Date: Fri, 7 May 2010 18:43:57 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Consolidate some code repetition
Message-ID: <tip-2b0b5c6fe9b383f3cf35a0a6371c9d577bd523ff@git.kernel.org>
Git-Commit-ID: 2b0b5c6fe9b383f3cf35a0a6371c9d577bd523ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:43:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b0b5c6fe9b383f3cf35a0a6371c9d577bd523ff
Gitweb:     http://git.kernel.org/tip/2b0b5c6fe9b383f3cf35a0a6371c9d577bd523ff
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 8 Apr 2010 23:03:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:02 +0200

perf, x86: Consolidate some code repetition

Remove some duplicated logic.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   97 +++++++++++++----------------
 1 files changed, 44 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 080b9b0..35056f7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -452,14 +452,54 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 
 static int intel_pmu_save_and_restart(struct perf_event *event);
 
+static void __intel_pmu_pebs_event(struct perf_event *event,
+				   struct pt_regs *iregs, void *__pebs)
+{
+	/*
+	 * We cast to pebs_record_core since that is a subset of
+	 * both formats and we don't use the other fields in this
+	 * routine.
+	 */
+	struct pebs_record_core *pebs = __pebs;
+	struct perf_sample_data data;
+	struct pt_regs regs;
+
+	if (!intel_pmu_save_and_restart(event))
+		return;
+
+	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+
+	/*
+	 * We use the interrupt regs as a base because the PEBS record
+	 * does not contain a full regs set, specifically it seems to
+	 * lack segment descriptors, which get used by things like
+	 * user_mode().
+	 *
+	 * In the simple case fix up only the IP and BP,SP regs, for
+	 * PERF_SAMPLE_IP and PERF_SAMPLE_CALLCHAIN to function properly.
+	 * A possible PERF_SAMPLE_REGS will have to transfer all regs.
+	 */
+	regs = *iregs;
+	regs.ip = pebs->ip;
+	regs.bp = pebs->bp;
+	regs.sp = pebs->sp;
+
+	if (intel_pmu_pebs_fixup_ip(regs))
+		regs.flags |= PERF_EFLAGS_EXACT;
+	else
+		regs.flags &= ~PERF_EFLAGS_EXACT;
+
+	if (perf_event_overflow(event, 1, &data, &regs))
+		x86_pmu_stop(event);
+}
+
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
-	struct perf_sample_data data;
-	struct pt_regs regs;
 	int n;
 
 	if (!ds || !x86_pmu.pebs)
@@ -485,9 +525,6 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	if (n <= 0)
 		return;
 
-	if (!intel_pmu_save_and_restart(event))
-		return;
-
 	/*
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
@@ -495,31 +532,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	WARN_ON_ONCE(n > 1);
 	at += n - 1;
 
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
-
-	/*
-	 * We use the interrupt regs as a base because the PEBS record
-	 * does not contain a full regs set, specifically it seems to
-	 * lack segment descriptors, which get used by things like
-	 * user_mode().
-	 *
-	 * In the simple case fix up only the IP and BP,SP regs, for
-	 * PERF_SAMPLE_IP and PERF_SAMPLE_CALLCHAIN to function properly.
-	 * A possible PERF_SAMPLE_REGS will have to transfer all regs.
-	 */
-	regs = *iregs;
-	regs.ip = at->ip;
-	regs.bp = at->bp;
-	regs.sp = at->sp;
-
-	if (intel_pmu_pebs_fixup_ip(&regs))
-		regs.flags |= PERF_EFLAGS_EXACT;
-	else
-		regs.flags &= ~PERF_EFLAGS_EXACT;
-
-	if (perf_event_overflow(event, 1, &data, &regs))
-		x86_pmu_stop(event);
+	__intel_pmu_pebs_event(event, iregs, at);
 }
 
 static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
@@ -527,9 +540,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct pebs_record_nhm *at, *top;
-	struct perf_sample_data data;
 	struct perf_event *event = NULL;
-	struct pt_regs regs;
 	u64 status = 0;
 	int bit, n;
 
@@ -571,27 +582,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		if (!event || bit >= MAX_PEBS_EVENTS)
 			continue;
 
-		if (!intel_pmu_save_and_restart(event))
-			continue;
-
-		perf_sample_data_init(&data, 0);
-		data.period = event->hw.last_period;
-
-		/*
-		 * See the comment in intel_pmu_drain_pebs_core()
-		 */
-		regs = *iregs;
-		regs.ip = at->ip;
-		regs.bp = at->bp;
-		regs.sp = at->sp;
-
-		if (intel_pmu_pebs_fixup_ip(&regs))
-			regs.flags |= PERF_EFLAGS_EXACT;
-		else
-			regs.flags &= ~PERF_EFLAGS_EXACT;
-
-		if (perf_event_overflow(event, 1, &data, &regs))
-			x86_pmu_stop(event);
+		__intel_pmu_pebs_event(event, iregs, at);
 	}
 }
 
