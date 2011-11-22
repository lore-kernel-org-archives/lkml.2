Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1KVP0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:26:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:36328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab1KVP0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:26:20 -0500
Message-ID: <1321975567.14799.15.camel@twins>
Subject: Re: [PATCH v4 0/2] perf, x86: handle overlapping counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 16:26:07 +0100
In-Reply-To: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
References: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stuck the below patch on top, afaict there is no reason to store
sched->state.counter when we fail, since in that case we pop a state or
go bust entirely, right?



---
Subject: perf, x86: Prefer Fixed purpose counters when scheduling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Nov 10 15:15:42 CET 2011

This avoids a scheduling failure for cases like:

  cycles, cycles, instructions, instructions (on Core2)

Which would end up being programmed like:

  PMC0, PMC1, FP-instructions, fail

Because all events will have the same weight.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -574,16 +574,25 @@ static bool __perf_sched_find_counter(st
 
 	c = sched->constraints[sched->state.event];
 
+	/* Prefer fixed purpose counters */
+	if (x86_pmu.num_counters_fixed) {
+		idx = X86_PMC_IDX_FIXED;
+		for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
+			if (!__test_and_set_bit(idx, sched->state.used))
+				goto done;
+		}
+	}
 	/* Grab the first unused counter starting with idx */
 	idx = sched->state.counter;
-	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
+	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
 		if (!__test_and_set_bit(idx, sched->state.used))
-			break;
+			goto done;
 	}
-	sched->state.counter = idx;
 
-	if (idx >= X86_PMC_IDX_MAX)
-		return false;
+	return false;
+
+done:
+	sched->state.counter = idx;
 
 	if (c->overlap)
 		perf_sched_save_state(sched);

