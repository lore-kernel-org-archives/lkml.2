Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2GRH7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:59:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:41589 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2GRH6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:58:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="194324827"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 4/5] x86: mce: Remove the frozen cases in the hotplug code
Date: Wed, 18 Jul 2012 15:59:33 -0400
Message-Id: <1342641574-32126-5-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
References: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having double cases if we can simply mask the FROZEN bit
out.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9bc425f..eff73e7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2260,34 +2260,32 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned int cpu = (unsigned long)hcpu;
 	struct timer_list *t = &per_cpu(mce_timer, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		mce_device_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
 		break;
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		mce_start_timer(cpu, t);
 		break;
-	case CPU_POST_DEAD:
+	}
+
+	if (action == CPU_POST_DEAD) {
 		/* intentionally ignoring frozen here */
 		cmci_rediscover(cpu);
-		break;
 	}
+
 	return NOTIFY_OK;
 }
 
-- 
1.7.10.4

