Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2FRGof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:44:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:2444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab2FRGoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166838421"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH V2] tmp patch to fix hotplug issue in CMCI storm
Date: Mon, 18 Jun 2012 14:45:30 +0800
Message-Id: <1340001930-12519-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <alpine.LFD.2.02.1206151122140.3086@ionos>
References: <alpine.LFD.2.02.1206151122140.3086@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on previous 5 patches and tuned based on
Thomas' suggestion.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    2 ++
 arch/x86/kernel/cpu/mcheck/mce.c          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

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
index 92d8b5c..0493525 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -40,6 +40,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
 static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
 static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
+static DEFINE_PER_CPU(unsigned long, cmci_storm_hcpu_status);
 
 enum {
 	CMCI_STORM_NONE,
@@ -47,6 +48,11 @@ enum {
 	CMCI_STORM_SUBSIDED,
 };
 
+enum {
+	CMCI_STORM_HCPU_NONE,
+	CMCI_STORM_HCPU_ACTIVE,
+};
+
 static atomic_t cmci_storm_on_cpus;
 
 static int cmci_supported(int *banks)
@@ -77,6 +83,17 @@ void mce_intel_cmci_poll(void)
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
 }
 
+void mce_intel_hcpu_update(unsigned long cpu)
+{
+	unsigned long *status = &per_cpu(cmci_storm_hcpu_status, cpu);
+
+	if (*status == CMCI_STORM_HCPU_ACTIVE) {
+		per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
+		*status = CMCI_STORM_HCPU_NONE;
+		atomic_dec(&cmci_storm_on_cpus);
+	}
+}
+
 unsigned long mce_intel_adjust_timer(unsigned long interval)
 {
 	if (interval < CMCI_POLL_INTERVAL)
@@ -90,6 +107,7 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 		 * timer interval is back to our poll interval.
 		 */
 		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
+		__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_NONE);
 		atomic_dec(&cmci_storm_on_cpus);
 
 	case CMCI_STORM_SUBSIDED:
@@ -119,6 +137,9 @@ static bool cmci_storm_detect(void)
 	unsigned long ts = __this_cpu_read(cmci_time_stamp);
 	unsigned long now = jiffies;
 
+	if (__this_cpu_read(cmci_storm_state) != CMCI_STORM_NONE)
+		return true;
+
 	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
 		cnt++;
 	} else {
@@ -132,6 +153,7 @@ static bool cmci_storm_detect(void)
 
 	cmci_clear();
 	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
+	__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_ACTIVE);
 	atomic_inc(&cmci_storm_on_cpus);
 	mce_timer_kick(CMCI_POLL_INTERVAL);
 	return true;
-- 
1.7.1

