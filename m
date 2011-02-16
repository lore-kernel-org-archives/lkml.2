Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1BPNsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:48:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:39984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1BPNsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:48:00 -0500
Date: Wed, 16 Feb 2011 13:47:37 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1296664860-10886-2-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Use helper function in x86_pmu_enable_all()
Message-ID: <tip-d45dd923fcc620c948bd1eda16cc61426ac31646@git.kernel.org>
Git-Commit-ID: d45dd923fcc620c948bd1eda16cc61426ac31646
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:47:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d45dd923fcc620c948bd1eda16cc61426ac31646
Gitweb:     http://git.kernel.org/tip/d45dd923fcc620c948bd1eda16cc61426ac31646
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 2 Feb 2011 17:40:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:49 +0100

perf, x86: Use helper function in x86_pmu_enable_all()

Use helper function in x86_pmu_enable_all() to minimize access to
x86_pmu.eventsel in the fast path. The counter's msr address is now
calculated using struct hw_perf_event. Later we add code that
calculates the msr addresses with a table lookup which shouldn't be
done in the fast path.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1296664860-10886-2-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4d98789..70d6d8f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -642,21 +642,24 @@ static void x86_pmu_disable(struct pmu *pmu)
 	x86_pmu.disable_all();
 }
 
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
+					  u64 enable_mask)
+{
+	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
+}
+
 static void x86_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		struct perf_event *event = cpuc->events[idx];
-		u64 val;
+		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
-		val = event->hw.config;
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
-		wrmsrl(x86_pmu.eventsel + idx, val);
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 	}
 }
 
@@ -915,12 +918,6 @@ static void x86_pmu_enable(struct pmu *pmu)
 	x86_pmu.enable_all(added);
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
-					  u64 enable_mask)
-{
-	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
-}
-
 static inline void x86_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
