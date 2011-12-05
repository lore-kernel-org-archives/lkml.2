Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1LESDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:03:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:03:43 -0500
Date: Mon, 5 Dec 2011 10:03:18 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-28a00184be261e3dc152ba0d664a067bbe235b6a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, suresh.b.siddha@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
References: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86, tsc: Skip TSC synchronization checks for tsc=reliable
Git-Commit-ID: 28a00184be261e3dc152ba0d664a067bbe235b6a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:03:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28a00184be261e3dc152ba0d664a067bbe235b6a
Gitweb:     http://git.kernel.org/tip/28a00184be261e3dc152ba0d664a067bbe235b6a
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 4 Nov 2011 15:42:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:00:31 +0100

x86, tsc: Skip TSC synchronization checks for tsc=reliable

tsc=reliable boot parameter is supposed to skip all the TSC
stablility checks during boot time.

On a 8-socket system where we want to run an experiment with the
"tsc=reliable" boot option, TSC synchronization checks are not
getting skipped and marking the TSC as not stable.

Check for tsc_clocksource_reliable (which is set via
tsc=reliable or for platforms supporting synthetic TSC_RELIABLE
feature bit etc) and when set, skip the TSC synchronization
tests during boot.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
