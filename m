Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2GEXrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:47:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11765 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab2GEXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:46:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6763"; a="207822673"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] ARM: smp: Fix suspicious RCU originating from cpu_die()
Date: Thu,  5 Jul 2012 16:45:58 -0700
Message-Id: <1341531958-31721-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.11.1.107.g7260167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running hotplug tests I ran into this RCU splat

===============================
[ INFO: suspicious RCU usage. ]
3.4.0 #3275 Tainted: G        W
-------------------------------
include/linux/rcupdate.h:729 rcu_read_lock() used illegally while idle!

other info that might help us debug this:

RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
RCU used illegally from extended quiescent state!
4 locks held by swapper/2/0:
 #0:  ((cpu_died).wait.lock){......}, at: [<c00ab128>] complete+0x1c/0x5c
 #1:  (&p->pi_lock){-.-.-.}, at: [<c00b275c>] try_to_wake_up+0x2c/0x388
 #2:  (&rq->lock){-.-.-.}, at: [<c00b2860>] try_to_wake_up+0x130/0x388
 #3:  (rcu_read_lock){.+.+..}, at: [<c00abe5c>] cpuacct_charge+0x28/0x1f4

stack backtrace:
[<c001521c>] (unwind_backtrace+0x0/0x12c) from [<c00abec8>] (cpuacct_charge+0x94/0x1f4)
[<c00abec8>] (cpuacct_charge+0x94/0x1f4) from [<c00b395c>] (update_curr+0x24c/0x2c8)
[<c00b395c>] (update_curr+0x24c/0x2c8) from [<c00b59c4>] (enqueue_task_fair+0x50/0x194)
[<c00b59c4>] (enqueue_task_fair+0x50/0x194) from [<c00afea4>] (enqueue_task+0x30/0x34)
[<c00afea4>] (enqueue_task+0x30/0x34) from [<c00b0908>] (ttwu_activate+0x14/0x38)
[<c00b0908>] (ttwu_activate+0x14/0x38) from [<c00b28a8>] (try_to_wake_up+0x178/0x388)
[<c00b28a8>] (try_to_wake_up+0x178/0x388) from [<c00a82a0>] (__wake_up_common+0x34/0x78)
[<c00a82a0>] (__wake_up_common+0x34/0x78) from [<c00ab154>] (complete+0x48/0x5c)
[<c00ab154>] (complete+0x48/0x5c) from [<c07db7cc>] (cpu_die+0x2c/0x58)
[<c07db7cc>] (cpu_die+0x2c/0x58) from [<c000f954>] (cpu_idle+0x64/0xfc)
[<c000f954>] (cpu_idle+0x64/0xfc) from [<80208160>] (0x80208160)

When a cpu is marked offline during its idle thread it calls
cpu_die() during an RCU idle period. cpu_die() calls complete()
to notify the killing process that the cpu has died. complete()
calls into the scheduler code which sometimes grabs an RCU read
lock in cpuacct_charge().

To avoid this problem, copy what x86 is doing and have a per_cpu
variable to track the cpu state and have the killing process poll
that variable.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 2c7217d..5430ea4 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -59,6 +59,7 @@ enum ipi_msg_type {
 };
 
 static DECLARE_COMPLETION(cpu_running);
+static DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
@@ -143,22 +144,26 @@ int __cpu_disable(void)
 	return 0;
 }
 
-static DECLARE_COMPLETION(cpu_died);
-
 /*
  * called on the thread which is asking for a CPU to be shutdown -
  * waits until shutdown has completed, or it is timed out.
  */
 void __cpu_die(unsigned int cpu)
 {
-	if (!wait_for_completion_timeout(&cpu_died, msecs_to_jiffies(5000))) {
-		pr_err("CPU%u: cpu didn't die\n", cpu);
-		return;
+	unsigned int i;
+
+	for (i = 0; i < 50; i++) {
+		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
+			if (platform_cpu_kill(cpu)) {
+				pr_notice("CPU%u: shutdown\n", cpu);
+				return;
+			} else {
+				break;
+			}
+		}
+		msleep(100);
 	}
-	printk(KERN_NOTICE "CPU%u: shutdown\n", cpu);
-
-	if (!platform_cpu_kill(cpu))
-		printk("CPU%u: unable to kill\n", cpu);
+	pr_err("CPU%u: unable to kill\n", cpu);
 }
 
 /*
@@ -179,7 +184,7 @@ void __ref cpu_die(void)
 	mb();
 
 	/* Tell __cpu_die() that this CPU is now safe to dispose of */
-	complete(&cpu_died);
+	__this_cpu_write(cpu_state, CPU_DEAD);
 
 	/*
 	 * actual CPU shutdown procedure is at least platform (if not
@@ -258,6 +263,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	 * before we continue - which happens after __cpu_up returns.
 	 */
 	set_cpu_online(cpu, true);
+	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	complete(&cpu_running);
 
 	/*
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

