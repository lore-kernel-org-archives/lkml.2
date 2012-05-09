Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab2EII1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:27:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2EII1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:27:15 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: [PATCH 4/5] Cancel secondary CPU bringup if boot cpu abandoned this effort
Date: Wed,  9 May 2012 12:25:01 +0200
Message-Id: <1336559102-28103-5-git-send-email-imammedo@redhat.com>
In-Reply-To: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead go to idle without setting cpu online, which results in calling play_dead()

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/tsc.h |    2 +-
 arch/x86/kernel/smpboot.c  |   12 +++++++++++-
 arch/x86/kernel/tsc_sync.c |   10 ++++++----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index c91e8b9..b2491fc 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -58,7 +58,7 @@ extern int tsc_clocksource_reliable;
  * all CPUs/cores:
  */
 extern void check_tsc_sync_source(int cpu);
-extern void check_tsc_sync_target(void);
+extern bool check_tsc_sync_target(void);
 
 extern int notsc_setup(char *);
 extern void tsc_save_sched_clock_state(void);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ae19d90..af63cab 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -264,7 +264,16 @@ notrace static void __cpuinit start_secondary(void *unused)
 	/*
 	 * Check TSC synchronization with the BP:
 	 */
-	check_tsc_sync_target();
+	if (!check_tsc_sync_target()) {
+		clear_local_APIC();
+
+		/* was set by cpu_init() */
+		cpumask_clear_cpu(smp_processor_id(), cpu_initialized_mask);
+		/* was set by smp_callin() */
+		cpumask_clear_cpu(smp_processor_id(), cpu_callin_mask);
+
+		goto do_idle;
+	}
 
 	notify_cpu_starting(smp_processor_id());
 
@@ -296,6 +305,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 
 	x86_cpuinit.setup_percpu_clockev();
 
+do_idle:
 	wmb();
 	cpu_idle();
 }
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 1741385..45a593e 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -180,22 +180,22 @@ void __cpuinit check_tsc_sync_source(int cpu)
 /*
  * Freshly booted CPUs call into this:
  */
-void __cpuinit check_tsc_sync_target(void)
+bool __cpuinit check_tsc_sync_target(void)
 {
 	if (unsynchronized_tsc() || tsc_clocksource_reliable)
-		return;
+		return true;
 
 	/*
 	 * Wait for the source CPU to start the measurement
 	 */
 	while (!atomic_read(&start_tsc_sync)) {
 		if (!cpumask_test_cpu(smp_processor_id(), cpu_callout_mask))
-			return;
+			return false;
 		cpu_relax();
 	}
 
 	if (!cpumask_test_cpu(smp_processor_id(), cpu_callout_mask))
-		return;
+		return false;
 
 	atomic_set(&start_tsc_sync, 0);
 
@@ -211,4 +211,6 @@ void __cpuinit check_tsc_sync_target(void)
 	 */
 	while (atomic_read(&stop_tsc_sync))
 		cpu_relax();
+
+	return true;
 }
-- 
1.7.1

