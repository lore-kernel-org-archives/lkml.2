Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2FSSNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:13:36 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16356 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892Ab2FSSLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIG-01-1O7-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/10] perf, amd: Rework northbridge event constraints handler
Date: Tue, 19 Jun 2012 20:10:39 +0200
Message-ID: <1340129448-8690-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation of family 15h northbridge event implementation.
Current code relies on continuous northbridge counter masks with no
holes. In family 15h northbridge counters are separate from other
counters and thus only a subset of all generic counters. This patch
changes the code so that it can later work with counter masks.

No functional changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   68 +++++++++++++---------------------
 1 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 11a4eb9..194ca0b 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -256,9 +256,8 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
-	struct perf_event *old = NULL;
-	int max = x86_pmu.num_counters;
-	int i, j, k = -1;
+	struct perf_event *old;
+	int idx, new = -1;
 
 	/*
 	 * if not NB event or no NB, then no constraints
@@ -276,48 +275,33 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	 * because of successive calls to x86_schedule_events() from
 	 * hw_perf_group_sched_in() without hw_perf_enable()
 	 */
-	for (i = 0; i < max; i++) {
-		/*
-		 * keep track of first free slot
-		 */
-		if (k == -1 && !nb->owners[i])
-			k = i;
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (new == -1 || hwc->idx == idx)
+			/* assign free slot, prefer hwc->idx */
+			old = cmpxchg(nb->owners + idx, NULL, event);
+		else if (nb->owners[idx] == event)
+			/* event already present */
+			old = event;
+		else
+			continue;
+
+		if (old && old != event)
+			continue;
+
+		/* reassign to this slot */
+		if (new != -1)
+			cmpxchg(nb->owners + new, event, NULL);
+		new = idx;
 
 		/* already present, reuse */
-		if (nb->owners[i] == event)
-			goto done;
-	}
-	/*
-	 * not present, so grab a new slot
-	 * starting either at:
-	 */
-	if (hwc->idx != -1) {
-		/* previous assignment */
-		i = hwc->idx;
-	} else if (k != -1) {
-		/* start from free slot found */
-		i = k;
-	} else {
-		/*
-		 * event not found, no slot found in
-		 * first pass, try again from the
-		 * beginning
-		 */
-		i = 0;
-	}
-	j = i;
-	do {
-		old = cmpxchg(nb->owners+i, NULL, event);
-		if (!old)
+		if (old == event)
 			break;
-		if (++i == max)
-			i = 0;
-	} while (i != j);
-done:
-	if (!old)
-		return &nb->event_constraints[i];
-
-	return &emptyconstraint;
+	}
+
+	if (new == -1)
+		return &emptyconstraint;
+
+	return &nb->event_constraints[new];
 }
 
 static struct amd_nb *amd_alloc_nb(int cpu)
-- 
1.7.8.4


