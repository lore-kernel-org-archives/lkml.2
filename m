Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab2GDGBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:01:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:32223 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880Ab2GDGA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:00:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163860395"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 3/5] perf/x86: Detect number of instances of uncore CBox
Date: Wed,  4 Jul 2012 14:00:14 +0800
Message-Id: <1341381616-12229-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The CBox manages the interface between the core and the LLC, so
the instances of uncore CBox is equal to number of cores.

Reported-by: Andrew Cooks <acooks@gmail.com>
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index dbbf5a6..a394add 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1605,8 +1605,9 @@ static void __init uncore_cpu_setup(void *dummy)
 
 static int __init uncore_cpu_init(void)
 {
-	int ret, cpu;
+	int ret, cpu, max_cores;
 
+	max_cores = boot_cpu_data.x86_max_cores;
 	switch (boot_cpu_data.x86_model) {
 	case 26: /* Nehalem */
 	case 30:
@@ -1615,9 +1616,13 @@ static int __init uncore_cpu_init(void)
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
+		if (snb_uncore_cbox.num_boxes > max_cores)
+			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
 		break;
 	case 45: /* Sandy Birdge-EP */
+		if (snbep_uncore_cbox.num_boxes > max_cores)
+			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
 		break;
 	default:
-- 
1.7.10.4

