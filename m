Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab2FGW3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:29:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:61540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab2FGW32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="154456550"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, eranian@google.com, mingo@elte.hu,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, x86: Enable PDIR precise instruction profiling on IvyBridge
Date: Thu,  7 Jun 2012 15:29:17 -0700
Message-Id: <1339108157-30021-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339108157-30021-1-git-send-email-andi@firstfloor.org>
References: <1339108157-30021-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Even with precise profiling Intel CPUs have a "skid". The sample
triggers a few cycles later than the instruction, so in some
cases there can be systematic errors where expensive instructions never
show up in the profile log.

Sandy Bridge added a new PDIR instruction retired event that randomizes
the sampling slightly. This corrects for systematic errors, so that
you should in most cases see the correct instruction getting profile hits.

Unfortunately the SandyBridge version could only work with a otherwise
quiescent CPU and was difficult to use. But now on IvyBridge this
restriction is gone and can be more widely used.

This only works for retired instructions.

I enabled it -- somewhat arbitarily -- for two 'p's or more.

To use it

perf record -e instructions:pp ...

This provides a more precise alternative to the usual cycles:pp,
however it will not account for expensive instructions.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1249c56..b4eb9d9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1357,6 +1357,28 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+static int pdir_hw_config(struct perf_event *event)
+{
+	int err = intel_pmu_hw_config(event);
+
+	if (err)
+		return err;
+
+	/* 
+	 * Use the PDIR instruction retired counter for two 'p's.
+	 * This will randomize samples slightly and avoid some systematic 
+	 * measurement errors.
+	 * Only works for retired cycles.
+	 */
+	if (event->attr.precise_ip >= 2 &&
+	    (event->hw.config & X86_RAW_EVENT_MASK) == 0xc0) {
+		u64 pdir_event = X86_CONFIG(.event=0xc0, .umask=1);
+		event->hw.config = pdir_event | (event->hw.config & ~X86_RAW_EVENT_MASK);
+	}
+
+	return 0;
+}
+
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	if (x86_pmu.guest_get_msrs)
@@ -1842,6 +1864,7 @@ __init int intel_pmu_init(void)
 
 	case 58: /* IvyBridge */
 		name = "Ivy";
+		x86_pmu.hw_config = pdir_hw_config;
 		goto snb_ivb_common;
 
 	case 42: /* SandyBridge */
-- 
1.7.7.6

