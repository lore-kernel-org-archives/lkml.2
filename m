Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2FFQSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:18:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2FFQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:18:09 -0400
Date: Wed, 6 Jun 2012 09:17:56 -0700
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-70ab7003dec58afeae7f5d681dfa309b3a259f03@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1338944211-28275-2-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Don'
 t assume there can be only 4 PEBS events
Git-Commit-ID: 70ab7003dec58afeae7f5d681dfa309b3a259f03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:18:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70ab7003dec58afeae7f5d681dfa309b3a259f03
Gitweb:     http://git.kernel.org/tip/70ab7003dec58afeae7f5d681dfa309b3a259f03
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 5 Jun 2012 17:56:48 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:23:40 +0200

perf/x86: Don't assume there can be only 4 PEBS events

On Sandy Bridge in non HT mode there are 8 counters available.
Since every counter can write a PEBS record assuming there are
4 max is incorrect. Use the reported counter number -- with an
upper limit for a static array -- instead.

Also I made the warning messages a bit more informational.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338944211-28275-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h          |    3 ++-
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 23b5710..3df3de9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -69,7 +69,7 @@ struct amd_nb {
 };
 
 /* The maximal number of PEBS events: */
-#define MAX_PEBS_EVENTS		4
+#define MAX_PEBS_EVENTS		8
 
 /*
  * A debug store configuration.
@@ -378,6 +378,7 @@ struct x86_pmu {
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
 	void		(*pebs_aliases)(struct perf_event *event);
+	int 		max_pebs_events;
 
 	/*
 	 * Intel LBR
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 187c294..e23e71f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1800,6 +1800,8 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_maskl		= ebx.full;
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
+	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 35e2192..026373e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -620,7 +620,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
 	 */
-	WARN_ON_ONCE(n > 1);
+	WARN_ONCE(n > 1, "bad leftover pebs %d\n", n);
 	at += n - 1;
 
 	__intel_pmu_pebs_event(event, iregs, at);
@@ -651,10 +651,10 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
 	 */
-	WARN_ON_ONCE(n > MAX_PEBS_EVENTS);
+	WARN_ONCE(n > x86_pmu.max_pebs_events, "Unexpected number of pebs records %d\n", n);
 
 	for ( ; at < top; at++) {
-		for_each_set_bit(bit, (unsigned long *)&at->status, MAX_PEBS_EVENTS) {
+		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
@@ -670,7 +670,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 			break;
 		}
 
-		if (!event || bit >= MAX_PEBS_EVENTS)
+		if (!event || bit >= x86_pmu.max_pebs_events)
 			continue;
 
 		__intel_pmu_pebs_event(event, iregs, at);
