Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2LCC7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:59:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2345 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2LCC7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:59:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 02 Dec 2012 18:58:41 -0800
From: Joseph Lo <josephl@nvidia.com>
To: Colin Cross <ccross@android.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Joseph Lo <josephl@nvidia.com>, Colin Cross <ccross@android.com>
Subject: [PATCH] cpuidle: coupled: fix the potensial race condition and deadlock
Date: Mon, 3 Dec 2012 10:59:01 +0800
Message-ID: <1354503541-13463-1-git-send-email-josephl@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Considering the chance that two CPU come into cpuidle_enter_state_coupled at
very close time. The 1st CPU increases the waiting count and the 2nd CPU do the
same thing right away. The 2nd CPU found the 1st CPU already in waiting then
prepare to poke it.

Before the 2nd CPU to poke 1st CPU, the 1st found the waiting count already same
with cpu_online count. So the 1st won't go into waiting loop and the 2nd CPU
didn't poke it yet. The 1st CPU will go into ready loop directly.

Then the 2nd CPU set up the couple_cpuidle_mask for 1st CPU and poke it. But the
1st CPU already lost the chance to handle the poke and clear the
couple_cpuidle_mask. Now whole MPcore are alredy to be coupled. The MPcore will
go into the power saving idle mode.

Because the poke was be implemented as a "smp_call_function_single", it's a
software intrrupt of "IPI_SINGLE_FUNC". If the power saving idle mode of the
platform can't retain the software interrupt of power saving idle mode, (e.g.
Tegra's powerd-down idle mode will shut off cpu power that include the power of
GIC) the software interrupt will got lost.

When the CPU resumed from the power saving idle mode and the system still keep
idle, it will go into idle mode again immediately. Because the
"smp_call_function_single" not allow the same function be called for the same
cpu twice, or it will got a lock. So the "couple_cpuidle_mask" can't be cleared
by 1st CPU, the 2nd CPU also can't poke it again. Then the deadlock happens
here.

The fix here used different wake up mechanism. Because there are already two
loops and a gloable variable "ready_waiting_counts" to sync the status of
MPcore to coupled state, the "coupled_cpuidle_mask" was not really necessary.
Just waking up the CPU from waiting and checking if the CPU need resched at
outside world to take the CPU out of idle are enough. And this fix didn't
modify the original behavior of coupled cpuidle framework. It should still
compitable with the origianal. The cpuidle driver that already applies
coupled cpuidle not need to change as well.

Cc: Colin Cross <ccross@android.com>
Signed-off-by: Joseph Lo <josephl@nvidia.com>
---
Please check the detail sequence about how race condition and deadlock
be happened below:
It could be reproduced on Tegra20 and Tegra30.
(Suppose the last two cpu came into coupled_cpuidle_state at very close time)
========================================================================
CPU_0				CPU_1
cpuidle_enter_state_coupled
				cpuidle_enter_state_coupled
1.increase waiting count
				1. increase waiting count
------------------------ same time frame -------------------------------
2.before went into waiting
  loop, check the waiting
  count first
  2.1 the waiting count
   was same with online
   count
  2.2 so it won't go into
   waiting loop
				2.in the procedure to prepare to send an
				 "smp_call_function_single" to wake up CPU_0
------------------------ next time frame -------------------------------
3.before go into ready loop
  3.1 it will enable_irq
  3.2 check if there is any
    IPI
  3.3 if yes, clear the coupled_mask
  3.4 then disable_irq
				3. trigger the IPI to CPU_0
				 3.1 set up the coupled_mask for CPU_0
				 3.2 sent IPI to CPU_0
4. the IPI_SINGLE_FUNC been triggered from CPU_1 to CPU_0 and the coupled_mask
  of CPU_0 been set up
  4.1 but the CPU_0 miss the IPI and the chance to clear coupled_mask
------------------------ next time frame -------------------------------
5. MPCores went into ready loop and been coupled
6. go into power saving idle mode
   (For Tegra, it's means the vdd_cpu rail be shut off. The GIC be powered off
    and the SW_INT(IPI) couldn't be retained.)
7. After the resume of power saving idle mode, the coupled_mask of CPU_0 not
   been cleared.
8. return to kernel
========================================================================
If the system still idle, it will come back to idle immediately.
========================================================================
CPU_0				CPU_1
cpuidle_enter_state_coupled
				cpuidle_enter_state_coupled
1. set itself to waiting
2. go into waiting loop
3. check the coupled_mask been
  set or not
  3.1 enable_irq
  3.2 waiting for the coupled_mask
    be cleared

				1. found CPU_0 in waiting
				2. prepare an IPI to poke CPU_0
				  2.1 check the coupled_mask of CPU_0
				  2.2 because it had been set
				  2.3 so it didn't trigger and
				    "smp_call_function_single" to CPU_0 again
				3. then go into ready loop

4. because there is no irq of
  "IPI_SINGLE_FUNC" be triggered
  for CPU_0
  4.1 CPU_0 busy loop here

				4. CPU_1 in ready loop and wait for CPU_0
				  come here to be coupled
				  4.1 but CPU_0 be stalled
				  4.2 CPU_1 be trapped here

5. deadlock
========================================================================

---
 drivers/cpuidle/coupled.c |   73 +++++++++++++++-----------------------------
 1 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 3265844..c01305a 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -118,16 +118,11 @@ struct cpuidle_coupled {
 
 #define CPUIDLE_COUPLED_NOT_IDLE	(-1)
 
-static DEFINE_MUTEX(cpuidle_coupled_lock);
-static DEFINE_PER_CPU(struct call_single_data, cpuidle_coupled_poke_cb);
-
-/*
- * The cpuidle_coupled_poked_mask mask is used to avoid calling
- * __smp_call_function_single with the per cpu call_single_data struct already
- * in use.  This prevents a deadlock where two cpus are waiting for each others
- * call_single_data struct to be available
- */
-static cpumask_t cpuidle_coupled_poked_mask;
+#ifdef CONFIG_ARM
+#define smp_wakeup(cpu)	arch_send_wakeup_ipi_mask(cpumask_of(cpu))
+#else
+#define smp_wakeup(cpu)	arch_send_call_function_single_ipi(cpu)
+#endif
 
 /**
  * cpuidle_coupled_parallel_barrier - synchronize all online coupled cpus
@@ -291,12 +286,6 @@ static inline int cpuidle_coupled_get_state(struct cpuidle_device *dev,
 	return state;
 }
 
-static void cpuidle_coupled_poked(void *info)
-{
-	int cpu = (unsigned long)info;
-	cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
-}
-
 /**
  * cpuidle_coupled_poke - wake up a cpu that may be waiting
  * @cpu: target cpu
@@ -309,12 +298,9 @@ static void cpuidle_coupled_poked(void *info)
  * either has or will soon have a pending IPI that will wake it out of idle,
  * or it is currently processing the IPI and is not in idle.
  */
-static void cpuidle_coupled_poke(int cpu)
+static inline void cpuidle_coupled_poke(int cpu)
 {
-	struct call_single_data *csd = &per_cpu(cpuidle_coupled_poke_cb, cpu);
-
-	if (!cpumask_test_and_set_cpu(cpu, &cpuidle_coupled_poked_mask))
-		__smp_call_function_single(cpu, csd, 0);
+	smp_wakeup(cpu);
 }
 
 /**
@@ -403,26 +389,27 @@ static void cpuidle_coupled_set_done(int cpu, struct cpuidle_coupled *coupled)
 }
 
 /**
- * cpuidle_coupled_clear_pokes - spin until the poke interrupt is processed
- * @cpu - this cpu
+ * cpuidle_coupled_need_resched - need_resched when CPU wakeup from waiting
  *
- * Turns on interrupts and spins until any outstanding poke interrupts have
- * been processed and the poke bit has been cleared.
+ * Before the last cpu in MPcore come into coupled_cpuidle_state. There is no
+ * idea to know other cpus already stay in waiting for how long. There maybe
+ * something need to be taken care outside the world.
  *
- * Other interrupts may also be processed while interrupts are enabled, so
- * need_resched() must be tested after turning interrupts off again to make sure
- * the interrupt didn't schedule work that should take the cpu out of idle.
+ * Turns on interrupts and checks need_resched() to make sure if the cpu
+ * still can stay in waiting for all MPcore to be coupled. If not, the
+ * cpu should be taken out of idle.
  *
- * Returns 0 if need_resched was false, -EINTR if need_resched was true.
+ * Returns false if need_resched was false, true if need_resched was true.
  */
-static int cpuidle_coupled_clear_pokes(int cpu)
+static bool cpuidle_coupled_need_resched(void)
 {
+	bool resched;
+
 	local_irq_enable();
-	while (cpumask_test_cpu(cpu, &cpuidle_coupled_poked_mask))
-		cpu_relax();
+	resched = need_resched();
 	local_irq_disable();
 
-	return need_resched() ? -EINTR : 0;
+	return resched;
 }
 
 /**
@@ -454,7 +441,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 		return -EINVAL;
 
 	while (coupled->prevent) {
-		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
+		if (cpuidle_coupled_need_resched()) {
 			local_irq_enable();
 			return entered_state;
 		}
@@ -473,11 +460,6 @@ retry:
 	 * allowed for a single cpu.
 	 */
 	while (!cpuidle_coupled_cpus_waiting(coupled)) {
-		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
-			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
-			goto out;
-		}
-
 		if (coupled->prevent) {
 			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
 			goto out;
@@ -485,11 +467,11 @@ retry:
 
 		entered_state = cpuidle_enter_state(dev, drv,
 			dev->safe_state_index);
-	}
 
-	if (cpuidle_coupled_clear_pokes(dev->cpu)) {
-		cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
-		goto out;
+		if (cpuidle_coupled_need_resched()) {
+			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
+			goto out;
+		}
 	}
 
 	/*
@@ -565,7 +547,6 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
 {
 	int cpu;
 	struct cpuidle_device *other_dev;
-	struct call_single_data *csd;
 	struct cpuidle_coupled *coupled;
 
 	if (cpumask_empty(&dev->coupled_cpus))
@@ -595,10 +576,6 @@ have_coupled:
 
 	coupled->refcnt++;
 
-	csd = &per_cpu(cpuidle_coupled_poke_cb, dev->cpu);
-	csd->func = cpuidle_coupled_poked;
-	csd->info = (void *)(unsigned long)dev->cpu;
-
 	return 0;
 }
 
-- 
1.7.0.4

