Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2KZWtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:49:03 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:53343
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab2KZWs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:48:57 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0ME4A1D-01-F9Q-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 1/5] perf, amd: Rework northbridge event constraints handler
Date: Mon, 26 Nov 2012 16:48:27 -0600
Message-ID: <1353970111-4508-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353970111-4508-1-git-send-email-jacob.shin@amd.com>
References: <1353970111-4508-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rric@kernel.org>

Code simplification. No functional changes.

Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   68 +++++++++++++---------------------
 1 file changed, 26 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4528ae7..d60c5c7 100644
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
1.7.9.5


