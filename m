Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2FNNs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:48:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:23889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab2FNNsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156349496"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] tmp patch to fix hotplug issue in CMCI storm
Date: Thu, 14 Jun 2012 21:49:46 +0800
Message-Id: <1339681786-8418-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <alpine.LFD.2.02.1206080940360.3086@ionos>
References: <alpine.LFD.2.02.1206080940360.3086@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is based on tip tree and previous 5 patches.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   49 ++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 2cd73ce..6a05c1d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -31,9 +31,11 @@ extern struct mce_bank *mce_banks;
 #ifdef CONFIG_X86_MCE_INTEL
 unsigned long mce_intel_adjust_timer(unsigned long interval);
 void mce_intel_cmci_poll(void);
+void mce_intel_hcpu_update(unsigned long cpu);
 #else
 # define mce_intel_adjust_timer mce_adjust_timer_default
 static inline void mce_intel_cmci_poll(void) { }
+static inline void mce_intel_hcpu_update(unsigned long cpu) { }
 #endif
 
 void mce_timer_kick(unsigned long interval);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e3f8b94..5e22d99 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2306,6 +2306,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
+		mce_intel_hcpu_update(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 92d8b5c..ef687df 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -40,6 +40,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
 static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
 static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
+static DEFINE_PER_CPU(unsigned long, cmci_storm_hcpu_status);
 
 enum {
 	CMCI_STORM_NONE,
@@ -47,6 +48,12 @@ enum {
 	CMCI_STORM_SUBSIDED,
 };
 
+enum {
+	CMCI_STORM_HCPU_NONE,
+	CMCI_STORM_HCPU_ACTIVE,
+	CMCI_STORM_HCPU_SUBSIDED,
+};
+
 static atomic_t cmci_storm_on_cpus;
 
 static int cmci_supported(int *banks)
@@ -77,6 +84,17 @@ void mce_intel_cmci_poll(void)
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
 }
 
+void mce_intel_hcpu_update(unsigned long cpu)
+{
+	unsigned long *status = &per_cpu(cmci_storm_hcpu_status, cpu);
+
+	if (*status == CMCI_STORM_HCPU_ACTIVE) {
+		per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
+		*status = CMCI_STORM_HCPU_SUBSIDED;
+		atomic_dec(&cmci_storm_on_cpus);
+	}
+}
+
 unsigned long mce_intel_adjust_timer(unsigned long interval)
 {
 	if (interval < CMCI_POLL_INTERVAL)
@@ -90,6 +108,7 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 		 * timer interval is back to our poll interval.
 		 */
 		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
+		__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_NONE);
 		atomic_dec(&cmci_storm_on_cpus);
 
 	case CMCI_STORM_SUBSIDED:
@@ -109,6 +128,21 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 		 * We have shiny wheather, let the poll do whatever it
 		 * thinks.
 		 */
+
+		/*
+		 * If one CPU is offlined and onlined during CMCI storm, it
+		 * has no chance to enable CMCI again. Here is the portal.
+		 */
+		if ((!atomic_read(&cmci_storm_on_cpus)) &&
+			(CMCI_STORM_HCPU_SUBSIDED ==
+			__this_cpu_read(cmci_storm_hcpu_status))) {
+			__this_cpu_write(cmci_storm_hcpu_status,
+					CMCI_STORM_HCPU_NONE);
+			cmci_reenable();
+			apic_write(APIC_LVTCMCI,
+				THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
+			cmci_recheck();
+		}
 		return interval;
 	}
 }
@@ -132,6 +166,7 @@ static bool cmci_storm_detect(void)
 
 	cmci_clear();
 	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
+	__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_ACTIVE);
 	atomic_inc(&cmci_storm_on_cpus);
 	mce_timer_kick(CMCI_POLL_INTERVAL);
 	return true;
@@ -259,7 +294,9 @@ void cmci_rediscover(int dying)
 	int cpu;
 	cpumask_var_t old;
 
-	if (!cmci_supported(&banks))
+	if (!cmci_supported(&banks) ||
+	/* if still in CMCI storm, don't enable it */
+	(0 != atomic_read(&cmci_storm_on_cpus)))
 		return;
 	if (!alloc_cpumask_var(&old, GFP_KERNEL))
 		return;
@@ -297,6 +334,16 @@ static void intel_init_cmci(void)
 		return;
 
 	mce_threshold_vector = intel_threshold_interrupt;
+	/* if still in CMCI storm, don't enable it */
+	if (0 != atomic_read(&cmci_storm_on_cpus))
+		return;
+	/*
+	 * If one CPU is offlined during CMCI storm and onlined after
+	 * CMCI storm, this *hCPU* status must be updated to avoid
+	 * to reenable CMCI twice.
+	 */
+	__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_NONE);
+
 	cmci_discover(banks, 1);
 	/*
 	 * For CPU #0 this runs with still disabled APIC, but that's
-- 
1.7.1

