Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab1LFJqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:46:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:46:12 -0500
Date: Tue, 6 Dec 2011 01:45:49 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-8tnwb92asqj7xajqqoty4gel@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Prefer fixed-purpose counters when scheduling
Git-Commit-ID: 4defea8559bc0f97a899d94c8d19d3b8bb802bc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:45:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4defea8559bc0f97a899d94c8d19d3b8bb802bc4
Gitweb:     http://git.kernel.org/tip/4defea8559bc0f97a899d94c8d19d3b8bb802bc4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Nov 2011 15:15:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:33:58 +0100

perf, x86: Prefer fixed-purpose counters when scheduling

This avoids a scheduling failure for cases like:

  cycles, cycles, instructions, instructions (on Core2)

Which would end up being programmed like:

  PMC0, PMC1, FP-instructions, fail

Because all events will have the same weight.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-8tnwb92asqj7xajqqoty4gel@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fa6fdec..66f8ba9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -574,16 +574,25 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 
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
