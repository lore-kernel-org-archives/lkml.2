Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2AQNWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:30 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:61987 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2AQNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:24 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 44/50] intel_idle: disable auto_demotion for hotplugged CPUs
Date: Tue, 17 Jan 2012 07:21:36 -0500
Message-id: <e5f03b06dc99348df53118c6ef7b51a8611a7256.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

auto_demotion_disable is called only for online CPUs.  For hotplugged
CPUs, we should disable it too.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |   53 ++++++++++++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index af0b4a5..38da9f8 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -297,33 +297,42 @@ static void __setup_broadcast_timer(void *arg)
 	clockevents_notify(reason, &cpu);
 }
 
-static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
+static void auto_demotion_disable(void *dummy)
+{
+	unsigned long long msr_bits;
+
+	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+	msr_bits &= ~auto_demotion_disable_flags;
+	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+}
+
+static void __intel_idle_notify_handler(void *arg)
+{
+	if (auto_demotion_disable_flags)
+		auto_demotion_disable(NULL);
+
+	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
+		__setup_broadcast_timer((void *)true);
+}
+
+static int setup_intelidle_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		smp_call_function_single(hotcpu, __setup_broadcast_timer,
-			(void *)true, 1);
+		smp_call_function_single(hotcpu, __intel_idle_notify_handler,
+			NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
 }
 
-static struct notifier_block setup_broadcast_notifier = {
-	.notifier_call = setup_broadcast_cpuhp_notify,
+static struct notifier_block setup_intelidle_notifier = {
+	.notifier_call = setup_intelidle_cpuhp_notify,
 };
 
-static void auto_demotion_disable(void *dummy)
-{
-	unsigned long long msr_bits;
-
-	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-	msr_bits &= ~auto_demotion_disable_flags;
-	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-}
-
 /*
  * intel_idle_probe()
  */
@@ -393,10 +402,8 @@ static int intel_idle_probe(void)
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
-	else {
+	else
 		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
-		register_cpu_notifier(&setup_broadcast_notifier);
-	}
 
 	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
 		" model 0x%X\n", boot_cpu_data.x86_model);
@@ -559,6 +566,10 @@ static int __init intel_idle_init(void)
 		return retval;
 	}
 
+	if (auto_demotion_disable_flags || lapic_timer_reliable_states !=
+	    LAPIC_TIMER_ALWAYS_RELIABLE)
+		register_cpu_notifier(&setup_intelidle_notifier);
+
 	return 0;
 }
 
@@ -567,10 +578,12 @@ static void __exit intel_idle_exit(void)
 	intel_idle_cpuidle_devices_uninit();
 	cpuidle_unregister_driver(&intel_idle_driver);
 
-	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
+	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
 		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
-		unregister_cpu_notifier(&setup_broadcast_notifier);
-	}
+
+	if (auto_demotion_disable_flags || lapic_timer_reliable_states !=
+	    LAPIC_TIMER_ALWAYS_RELIABLE)
+		unregister_cpu_notifier(&setup_intelidle_notifier);
 
 	return;
 }
-- 
1.7.9.rc1

