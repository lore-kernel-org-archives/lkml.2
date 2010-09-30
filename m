Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0I3Sub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:50:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:12244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0I3Sua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:50:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,260,1283756400"; 
   d="scan'208";a="559479444"
Subject: [patch] intel_idle: Voluntary leave_mm before entering deeper
 c-states
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 30 Sep 2010 11:50:13 -0700
Message-Id: <1285872613.2676.4.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid TLB flush IPIs for the cores in deeper c-states by voluntary leave_mm()
before entering into that state. CPUs tend to flush TLB in those c-states
anyways.

ACPI processor idle driver does this and was left out when intel idle
got introduced.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a10152b..dff4663 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -108,7 +108,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.name = "NHM-C3",
 		.desc = "MWAIT 0x10",
 		.driver_data = (void *) 0x10,
-		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 20,
 		.power_usage = 500,
 		.target_residency = 80,
@@ -117,7 +117,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.name = "NHM-C6",
 		.desc = "MWAIT 0x20",
 		.driver_data = (void *) 0x20,
-		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 200,
 		.power_usage = 350,
 		.target_residency = 800,
@@ -149,7 +149,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.name = "ATM-C4",
 		.desc = "MWAIT 0x30",
 		.driver_data = (void *) 0x30,
-		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 100,
 		.power_usage = 250,
 		.target_residency = 400,
@@ -159,7 +159,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.name = "ATM-C6",
 		.desc = "MWAIT 0x40",
 		.driver_data = (void *) 0x40,
-		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 200,
 		.power_usage = 150,
 		.target_residency = 800,
@@ -185,6 +185,16 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state)
 
 	local_irq_disable();
 
+	/*
+	 * If the state flag indicates that the TLB will be flushed or if this
+	 * is the deepest c-state supported, do a voluntary leave mm to avoid
+	 * costly and mostly unnecessary wakeups for flushing the user TLB's
+	 * associated with the active mm.
+	 */
+	if (state->flags & CPUIDLE_FLAG_TLB_FLUSHED ||
+	    (&dev->states[dev->state_count - 1] == state))
+		leave_mm(cpu);
+
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 36ca972..1be416b 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -53,6 +53,7 @@ struct cpuidle_state {
 #define CPUIDLE_FLAG_BALANCED	(0x40) /* medium latency, moderate savings */
 #define CPUIDLE_FLAG_DEEP	(0x80) /* high latency, large savings */
 #define CPUIDLE_FLAG_IGNORE	(0x100) /* ignore during this idle period */
+#define CPUIDLE_FLAG_TLB_FLUSHED (0x200) /* tlb will be flushed */
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 


