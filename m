Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2FSGII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:08:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:9434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2FSGIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:08:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113616961"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, borislav.petkov@amd.com, peterz@infradead.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH V3] tmp patch to fix hotplug issue in CMCI storm
Date: Tue, 19 Jun 2012 14:09:00 +0800
Message-Id: <1340086140-13652-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <alpine.LFD.2.02.1206181422420.3086@ionos>
References: <alpine.LFD.2.02.1206181422420.3086@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3->v1
Thanks very much for Thomas' suggestion to simply the whole logic.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    2 ++
 arch/x86/kernel/cpu/mcheck/mce.c          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   11 +++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

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
index 92d8b5c..693bc7d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -77,6 +77,14 @@ void mce_intel_cmci_poll(void)
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
 }
 
+void mce_intel_hcpu_update(unsigned long cpu)
+{
+	if (per_cpu(cmci_storm_state, cpu) == CMCI_STORM_ACTIVE)
+		atomic_dec(&cmci_storm_on_cpus);
+
+	per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
+}
+
 unsigned long mce_intel_adjust_timer(unsigned long interval)
 {
 	if (interval < CMCI_POLL_INTERVAL)
@@ -119,6 +127,9 @@ static bool cmci_storm_detect(void)
 	unsigned long ts = __this_cpu_read(cmci_time_stamp);
 	unsigned long now = jiffies;
 
+	if (__this_cpu_read(cmci_storm_state) != CMCI_STORM_NONE)
+		return true;
+
 	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
 		cnt++;
 	} else {
-- 
1.7.1

