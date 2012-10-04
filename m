Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2JDEm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:42:28 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45099 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2JDEmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:42:24 -0400
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [PATCH v1 2/3] cpuidle: (POWER) Fix smt_snooze_delay functionality.
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
Date: Thu, 04 Oct 2012 10:12:18 +0530
Message-ID: <20121004044215.15921.60142.stgit@deepthi.in.ibm.com>
In-Reply-To: <20121004044154.15921.51256.stgit@deepthi.in.ibm.com>
References: <20121004044154.15921.51256.stgit@deepthi.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12100404-2000-0000-0000-00000957952A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smt_snooze_delay was designed to  delay idle loop's nap entry
in the native idle code before it got  ported over to use as part of
the cpuidle framework.

A -ve value  assigned to smt_snooze_delay should result in
busy looping, in other words disabling the entry to nap state.

	- https://lists.ozlabs.org/pipermail/linuxppc-dev/2010-May/082450.html

This particular functionality can be achieved currently by
echo 1 > /sys/devices/system/cpu/cpu*/state1/disable
but it is broken when one assigns -ve value to  the smt_snooze_delay
variable either via sysfs entry or ppc64_cpu util.

This patch aims to fix this, by disabling nap state when smt_snooze_delay
variable is set to -ve value.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/processor.h            |    4 ++--
 arch/powerpc/kernel/sysfs.c                     |    2 +-
 arch/powerpc/platforms/pseries/processor_idle.c |   24 ++++++++++++++++-------
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 54b73a2..d0a5fb8 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -389,9 +389,9 @@ extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern void power7_nap(void);
 
 #ifdef CONFIG_PSERIES_IDLE
-extern void update_smt_snooze_delay(int snooze);
+extern void update_smt_snooze_delay(int cpu, int residency);
 #else
-static inline void update_smt_snooze_delay(int snooze) {}
+static inline void update_smt_snooze_delay(int cpu, int residency) {}
 #endif
 
 extern void flush_instruction_cache(void);
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 8302af6..cf357a0 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -50,7 +50,7 @@ static ssize_t store_smt_snooze_delay(struct device *dev,
 		return -EINVAL;
 
 	per_cpu(smt_snooze_delay, cpu->dev.id) = snooze;
-	update_smt_snooze_delay(snooze);
+	update_smt_snooze_delay(cpu->dev.id, snooze);
 
 	return count;
 }
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 02e425a..a32d56d 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -33,13 +33,6 @@ static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
 static struct cpuidle_device __percpu *pseries_cpuidle_devices;
 static struct cpuidle_state *cpuidle_state_table;
 
-void update_smt_snooze_delay(int snooze)
-{
-	struct cpuidle_driver *drv = cpuidle_get_driver();
-	if (drv)
-		drv->states[0].target_residency = snooze;
-}
-
 static inline void idle_loop_prolog(unsigned long *in_purr, ktime_t *kt_before)
 {
 
@@ -190,6 +183,23 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
 		.enter = &shared_cede_loop },
 };
 
+void update_smt_snooze_delay(int cpu, int residency)
+{
+	struct cpuidle_driver *drv = cpuidle_get_driver();
+	struct cpuidle_device *dev = per_cpu(cpuidle_devices, cpu);
+
+	if (cpuidle_state_table != dedicated_states)
+		return;
+
+	if (residency < 0) {
+		/* Disable the Nap state on that cpu */
+		if (dev)
+			dev->states_usage[1].disable = 1;
+	} else
+		if (drv)
+			drv->states[0].target_residency = residency;
+}
+
 static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			unsigned long action, void *hcpu)
 {

