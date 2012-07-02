Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2GBSn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:43:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:53665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab2GBSnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:43:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187620747"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling on IvyBridge
Date: Mon,  2 Jul 2012 11:43:15 -0700
Message-Id: <1341254598-1379-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
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
 arch/x86/kernel/cpu/perf_event_intel.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a741505..e09a4ad 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1425,6 +1425,29 @@ static int intel_pmu_hw_config(struct perf_event *event)
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
+	 * Only works for retired instructions.
+	 */
+	if (event->attr.precise_ip >= 2 &&
+	    (event->hw.config & X86_RAW_EVENT_MASK) == 0xc0) {
+		u64 pdir_event = X86_CONFIG(.event=0xc0, .umask=1);
+		event->hw.config = pdir_event |
+				(event->hw.config & ~X86_RAW_EVENT_MASK);
+	}
+
+	return 0;
+}
+
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	if (x86_pmu.guest_get_msrs)
@@ -1955,6 +1978,8 @@ __init int intel_pmu_init(void)
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 		/* no backend event */
 	      
+		x86_pmu.hw_config = pdir_hw_config;
+
 		pr_cont("IvyBridge events, ");
 		break;
 
-- 
1.7.7.6

