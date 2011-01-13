Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1AMMwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:52:16 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35328 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab1AMMwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:52:05 -0500
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC V2 1/3] cpuidle: Remove pm_idle pointer for x86
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 18:22:00 +0530
Message-ID: <20110113125138.11174.88044.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com>
References: <20110113125113.11174.78525.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reomves pm_idle function pointer and directly calls
cpuidle_idle_call from the idle loop on x86. CPUIdle has to be
built into the kernel.

Archs that still use pm_idle can continue to set
pm_idle=cpuidle_idle_call() and co-exist.  This will need #ifdefs
in cpuidle.c and has not been implemented yet in this RFC.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/x86/kernel/process_32.c |    4 +++-
 arch/x86/kernel/process_64.c |    4 +++-
 drivers/cpuidle/Kconfig      |    2 +-
 drivers/cpuidle/cpuidle.c    |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

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
index 7dbc4a8..57ad7bd 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -1,7 +1,7 @@
 
 config CPU_IDLE
 	bool "CPU idle PM support"
-	default ACPI
+	default y
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

