Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab2JXKC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:02:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab2JXKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:02:55 -0400
Date: Wed, 24 Oct 2012 03:01:36 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-58e9eaf06f5476cb2192ec1d012674ce5e79dd21@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1210191732000.14552@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210191732000.14552@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Remove P6 cpuc->enabled check
Git-Commit-ID: 58e9eaf06f5476cb2192ec1d012674ce5e79dd21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:01:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58e9eaf06f5476cb2192ec1d012674ce5e79dd21
Gitweb:     http://git.kernel.org/tip/58e9eaf06f5476cb2192ec1d012674ce5e79dd21
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 19 Oct 2012 17:33:38 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:32:00 +0200

perf/x86: Remove P6 cpuc->enabled check

Between 2.6.33 and 2.6.34 the PMU code was made modular.

The x86_pmu_enable() call was extended to disable cpuc->enabled
and iterate the counters, enabling one at a time, before calling
enable_all() at the end, followed by re-enabling cpuc->enabled.

Since cpuc->enabled was set to 0, that change effectively caused
the "val |= ARCH_PERFMON_EVENTSEL_ENABLE;" code in p6_pmu_enable_event()
and p6_pmu_disable_event() to be dead code that was never called.

This change removes this code (which was confusing) and adds some
extra commentary to make it more clear what is going on.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1210191732000.14552@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_p6.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 9582fcb..7d0270b 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -157,25 +157,25 @@ static void p6_pmu_enable_all(int added)
 static inline void
 p6_pmu_disable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val = P6_NOP_EVENT;
 
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
-
 	(void)wrmsrl_safe(hwc->config_base, val);
 }
 
 static void p6_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	/*
+	 * p6 only has a global event enable, set on PerfEvtSel0
+	 * We "disable" events by programming P6_NOP_EVENT
+	 * and we rely on p6_pmu_enable_all() being called
+	 * to actually enable the events.
+	 */
 
 	(void)wrmsrl_safe(hwc->config_base, val);
 }
