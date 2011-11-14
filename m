Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1KNV2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:28:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:16397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab1KNV2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:28:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,511,1315206000"; 
   d="scan'208";a="85112127"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>, "Len Brown" <len.brown@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and package level thermal throttle event in mce log
Date: Mon, 14 Nov 2011 13:11:22 -0800
Message-Id: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Because of BIOS issues, some platforms report mce errors after power limit and
thermal throttle events. Customers are concerned about the mce errors. Although
BIOS need to fix the issues eventually, the events should not be viewed as mce
errors in the first place.

This patch doesn't log power limit and package level thermal throttle events
in mce log. When the events happen, only count them in respective counters in
sysfs.

For legacy reason, core level thermal throttle is still logged in mce log and
counted in counter in sysfs.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 787e06c..ce04b58 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -323,17 +323,6 @@ device_initcall(thermal_throttle_init_device);
 
 #endif /* CONFIG_SYSFS */
 
-/*
- * Set up the most two significant bit to notify mce log that this thermal
- * event type.
- * This is a temp solution. May be changed in the future with mce log
- * infrasture.
- */
-#define CORE_THROTTLED		(0)
-#define CORE_POWER_LIMIT	((__u64)1 << 62)
-#define PACKAGE_THROTTLED	((__u64)2 << 62)
-#define PACKAGE_POWER_LIMIT	((__u64)3 << 62)
-
 static void notify_thresholds(__u64 msr_val)
 {
 	/* check whether the interrupt handler is defined;
@@ -363,27 +352,23 @@ static void intel_thermal_interrupt(void)
 	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
 				THERMAL_THROTTLING_EVENT,
 				CORE_LEVEL) != 0)
-		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
+		mce_log_therm_throt_event(msr_val);
 
 	if (this_cpu_has(X86_FEATURE_PLN))
-		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
+		therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
-					CORE_LEVEL) != 0)
-			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
+					CORE_LEVEL);
 
 	if (this_cpu_has(X86_FEATURE_PTS)) {
 		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
-		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
+		therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
 					THERMAL_THROTTLING_EVENT,
-					PACKAGE_LEVEL) != 0)
-			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
+					PACKAGE_LEVEL);
 		if (this_cpu_has(X86_FEATURE_PLN))
-			if (therm_throt_process(msr_val &
+			therm_throt_process(msr_val &
 					PACKAGE_THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
-					PACKAGE_LEVEL) != 0)
-				mce_log_therm_throt_event(PACKAGE_POWER_LIMIT
-							  | msr_val);
+					PACKAGE_LEVEL);
 	}
 }
 
-- 
1.6.0.3

