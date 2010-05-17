Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0EQIN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:13:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:64443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab0EQINz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:13:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="518494826"
Subject: [PATCH] x86,perf: P4 PMU -- handle unflagged events
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 May 2010 16:13:04 +0800
Message-Id: <1274083984.6540.15.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] x86,perf: P4 PMU -- handle unflagged events

It might happen that event if being overflowed without
proper bit set. Check the sign bit in counter.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
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


