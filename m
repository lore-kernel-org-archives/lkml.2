Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1BHKwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:52:05 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43862 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1BHKwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:52:03 -0500
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 1/3] cpuidle: Remove pm_idle pointer for x86
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 16:21:54 +0530
Message-ID: <20110208105154.9998.83693.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
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
index 96586c3..d487ff8 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -76,6 +76,8 @@ static inline void play_dead(void)
 }
 #endif
 
+extern void cpuidle_idle_call(void);
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
@@ -111,7 +113,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			cpuidle_idle_call();
 			start_critical_timings();
 
 			trace_power_end(smp_processor_id());
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..768cd23 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -101,6 +101,8 @@ static inline void play_dead(void)
 }
 #endif
 
+extern void cpuidle_idle_call(void);
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
@@ -138,7 +140,7 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			cpuidle_idle_call();
 			start_critical_timings();
 
 			trace_power_end(smp_processor_id());
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
index a507108..9bf4640 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -47,7 +47,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
  *
  * NOTE: no locks or semaphores should be used here
  */
-static void cpuidle_idle_call(void)
+void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __get_cpu_var(cpuidle_devices);
 	struct cpuidle_state *target_state;

