Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1CVMdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:33:49 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49939 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab1CVMdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:33:45 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Tue, 22 Mar 2011 18:03:40 +0530
Message-ID: <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/x86/kernel/apm_32.c |   75 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..22d40bf 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -882,8 +882,6 @@ static void apm_do_busy(void)
 #define IDLE_CALC_LIMIT	(HZ * 100)
 #define IDLE_LEAKY_MAX	16
 
-static void (*original_pm_idle)(void) __read_mostly;
-
 /**
  * apm_cpu_idle		-	cpu idling for APM capable Linux
  *
@@ -947,10 +945,7 @@ recalc:
 				break;
 			}
 		}
-		if (original_pm_idle)
-			original_pm_idle();
-		else
-			default_idle();
+		default_idle();
 		local_irq_disable();
 		jiffies_since_last_check = jiffies - last_jiffies;
 		if (jiffies_since_last_check > idle_period)
@@ -2256,6 +2251,63 @@ static struct dmi_system_id __initdata apm_dmi_table[] = {
 	{ }
 };
 
+int apm_idle_wrapper(struct cpuidle_device *dev,
+		struct cpuidle_state *state)
+{
+	apm_cpu_idle();
+	return 0;
+}
+
+struct cpuidle_state state_apm_idle = {
+		.name = "APM-IDLE",
+		.desc = "APM idle routine",
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &apm_idle_wrapper,
+};
+
+static struct cpuidle_driver apm_idle_driver = {
+	.name = "apm_idle",
+	.owner = THIS_MODULE,
+	.priority = 1,
+};
+
+static int apm_setup_cpuidle(int cpu)
+{
+	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
+					GFP_KERNEL);
+	int count = CPUIDLE_DRIVER_STATE_START;
+	dev->cpu = cpu;
+	dev->drv = &apm_idle_driver;
+
+	dev->states[count] = state_apm_idle;
+	count++;
+
+	dev->state_count = count;
+
+	if (cpuidle_register_device(dev))
+		return -EIO;
+	return 0;
+}
+
+static int apm_idle_init(void)
+{
+	int retval, i;
+	retval = cpuidle_register_driver(&apm_idle_driver);
+
+	for_each_online_cpu(i) {
+		apm_setup_cpuidle(i);
+	}
+
+	return 0;
+}
+
+static void apm_idle_exit(void)
+{
+	cpuidle_unregister_driver(&apm_idle_driver);
+	return;
+}
+
 /*
  * Just start the APM thread. We do NOT want to do APM BIOS
  * calls from anything but the APM thread, if for no other reason
@@ -2393,8 +2445,7 @@ static int __init apm_init(void)
 	if (HZ != 100)
 		idle_period = (idle_period * HZ) / 100;
 	if (idle_threshold < 100) {
-		original_pm_idle = pm_idle;
-		pm_idle  = apm_cpu_idle;
+		apm_idle_init();
 		set_pm_idle = 1;
 	}
 
@@ -2406,13 +2457,7 @@ static void __exit apm_exit(void)
 	int error;
 
 	if (set_pm_idle) {
-		pm_idle = original_pm_idle;
-		/*
-		 * We are about to unload the current idle thread pm callback
-		 * (pm_idle), Wait for all processors to update cached/local
-		 * copies of pm_idle before proceeding.
-		 */
-		cpu_idle_wait();
+		apm_idle_exit();
 	}
 	if (((apm_info.bios.flags & APM_BIOS_DISENGAGED) == 0)
 	    && (apm_info.connection_version > 0x0100)) {

