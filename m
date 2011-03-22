Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1CVMco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:32:44 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49728 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1CVMcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:32:42 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V4 1/5] cpuidle: Remove pm_idle pointer for x86
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Tue, 22 Mar 2011 18:02:27 +0530
Message-ID: <20110322123223.28725.21929.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes pm_idle function pointer and directly calls
cpuidle_idle_call from the idle loop on x86. Hence, CPUIdle has
to be built into the kernel for x86 and optional for other
archs.

Archs that still use pm_idle can continue to set
pm_idle=cpuidle_idle_call() and co-exist. The
cpuidle_(un)install_idle_handler() is defined per arch in
cpuidle.c and would set pm_idle pointer on non-x86 architectures
until they are incrementally converted to directly call
cpuidle_idle_call() and not use the pm_idle pointer.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/x86/kernel/process_32.c |    4 +++-
 arch/x86/kernel/process_64.c |    4 +++-
 drivers/cpuidle/Kconfig      |    3 ++-
 drivers/cpuidle/cpuidle.c    |    2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..17b7101 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -74,6 +74,8 @@ static inline void play_dead(void)
 }
 #endif
 
+extern void cpuidle_idle_call(void);
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
@@ -109,7 +111,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			cpuidle_idle_call();
 			start_critical_timings();
 		}
 		tick_nohz_restart_sched_tick();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bd387e8..c736bf3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -99,6 +99,8 @@ static inline void play_dead(void)
 }
 #endif
 
+extern void cpuidle_idle_call(void);
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
@@ -136,7 +138,7 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			cpuidle_idle_call();
 			start_critical_timings();
 
 			/* In many cases the interrupt that ended idle
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 7dbc4a8..e67c258 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -1,7 +1,8 @@
 
 config CPU_IDLE
 	bool "CPU idle PM support"
-	default ACPI
+	default y if X86
+	default y if ACPI
 	help
 	  CPU idle is a generic framework for supporting software-controlled
 	  idle processor power management.  It includes modular cross-platform
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index bf50924..8baaa04 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -47,7 +47,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
  *
  * NOTE: no locks or semaphores should be used here
  */
-static void cpuidle_idle_call(void)
+void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_state *target_state;

