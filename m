Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0ERGeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:34:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:44198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab0ERGen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:34:43 -0400
Date: Tue, 18 May 2010 06:33:40 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, gorcunov@openvz.org, a.p.zijlstra@chello.nl,
       gorcunov@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, gorcunov@openvz.org,
       a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <1274083984.6540.15.camel@minggr.sh.intel.com>
References: <1274083984.6540.15.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU -- handle unflagged events
Message-ID: <tip-0db1a7bc00216a981d0b7056627ad8682f4f0636@git.kernel.org>
Git-Commit-ID: 0db1a7bc00216a981d0b7056627ad8682f4f0636
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 06:33:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0db1a7bc00216a981d0b7056627ad8682f4f0636
Gitweb:     http://git.kernel.org/tip/0db1a7bc00216a981d0b7056627ad8682f4f0636
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 17 May 2010 16:13:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 08:25:34 +0200

perf, x86: P4 PMU -- handle unflagged events

It might happen that an event can overflow without
the proper overflow flag set. Check the sign bit in
the raw counter value to solve this problem.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: fweisbec@gmail.com
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1274083984.6540.15.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 424fc8d..02f0728 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -465,15 +465,21 @@ out:
 	return rc;
 }
 
-static inline void p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
+static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 {
-	unsigned long dummy;
+	int overflow = 0;
+	u32 low, high;
 
-	rdmsrl(hwc->config_base + hwc->idx, dummy);
-	if (dummy & P4_CCCR_OVF) {
+	rdmsr(hwc->config_base + hwc->idx, low, high);
+
+	/* we need to check high bit for unflagged overflows */
+	if ((low & P4_CCCR_OVF) || (high & (1 << 31))) {
+		overflow = 1;
 		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
-			((u64)dummy) & ~P4_CCCR_OVF);
+			((u64)low) & ~P4_CCCR_OVF);
 	}
+
+	return overflow;
 }
 
 static inline void p4_pmu_disable_event(struct perf_event *event)
@@ -584,21 +590,15 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 
 		WARN_ON_ONCE(hwc->idx != idx);
 
-		/*
-		 * FIXME: Redundant call, actually not needed
-		 * but just to check if we're screwed
-		 */
-		p4_pmu_clear_cccr_ovf(hwc);
+		/* it might be unflagged overflow */
+		handled = p4_pmu_clear_cccr_ovf(hwc);
 
 		val = x86_perf_event_update(event);
-		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
+		if (!handled && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
 			continue;
 
-		/*
-		 * event overflow
-		 */
-		handled		= 1;
-		data.period	= event->hw.last_period;
+		/* event overflow for sure */
+		data.period = event->hw.last_period;
 
 		if (!x86_perf_event_set_period(event))
 			continue;
