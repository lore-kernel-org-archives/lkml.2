Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1KDWj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:39:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:47911 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab1KDWj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71341613"
Subject: [patch] x86, tsc: skip TSC synchronization checks for tsc=reliable
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 04 Nov 2011 15:42:17 -0700
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tsc=reliable boot parameter is supposed to skip all the TSC stablility
checks during boot time.

On a 8-socket system where we want to run an experiment with the
"tsc=reliable" boot option, TSC synchronization checks are not
getting skipped and marking the TSC as not stable.

Check for tsc_clocksource_reliable (which is set via tsc=reliable or
for platforms supporting synthetic TSC_RELIABLE feature bit etc)
and when set, skip the TSC synchronization tests during boot.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/tsc.h |    2 ++
 arch/x86/kernel/tsc.c      |    2 +-
 arch/x86/kernel/tsc_sync.c |    4 ++--
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 83e2efd..15d9915 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -51,6 +51,8 @@ extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
 
+extern int tsc_clocksource_reliable;
+
 /*
  * Boot-time check whether the TSCs are synchronized across
  * all CPUs/cores:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..eee4651 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -35,7 +35,7 @@ static int __read_mostly tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int __read_mostly tsc_disabled = -1;
 
-static int tsc_clocksource_reliable;
+int tsc_clocksource_reliable;
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 0aa5fed8..9eba29b 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -113,7 +113,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	if (unsynchronized_tsc())
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
+	if (tsc_clocksource_reliable) {
 		if (cpu == (nr_cpu_ids-1) || system_state != SYSTEM_BOOTING)
 			pr_info(
 			"Skipped synchronization checks as TSC is reliable.\n");
@@ -172,7 +172,7 @@ void __cpuinit check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
-	if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+	if (unsynchronized_tsc() || tsc_clocksource_reliable)
 		return;
 
 	/*


