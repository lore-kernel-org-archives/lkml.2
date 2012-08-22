Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab2HVEDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:03:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5652 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2HVEDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:03:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6811"; a="225707544"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] ARM: smp: Fix cpu_up() racing with sys_reboot
Date: Tue, 21 Aug 2012 21:03:49 -0700
Message-Id: <1345608229-5707-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing stops a process from hotplugging in a CPU concurrently
with a sys_reboot() call. In such a situation we could have
ipi_cpu_stop() mark a cpu as 'offline' and _cpu_up() ignore the
fact that the CPU is not really offline and call the
CPU_UP_PREPARE notifier. When this happens stop_machine code will
complain that the cpu thread already exists and BUG_ON().

CPU0                      CPU1

sys_reboot()
 kernel_restart()
  machine_restart()
   machine_shutdown()
    smp_send_stop()
    ...                   ipi_cpu_stop()
                           set_cpu_online(1, false)
                            local_irq_disable()
                             while(1)
    <PREEMPT>
cpu_up()
 _cpu_up()
   if (!cpu_online(1))
    __cpu_notify(CPU_UP_PREPARE...)

cpu_stop_cpu_callback()
  BUG_ON(stopper->thread)

This is easily reproducible by hotplugging in and out in a tight
loop while also rebooting.

Since the CPU is not really offline and hasn't gone through the
proper steps to be marked as such, let's mark the CPU as inactive.
This is just as easily testable as online and avoids any possibility
of _cpu_up() trying to bring the CPU back online when it never was
offline to begin with.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Perhaps we can take the hotplug lock in the sys_reboot() case but I
don't think that actually fixes everything. For example, in cases
where machine_shutdown() is called from emergency_restart() we would
have to take the hotplug lock which doesn't really seem feasible.

 arch/arm/kernel/smp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ebd8ad2..836b771 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -478,7 +478,7 @@ static void ipi_cpu_stop(unsigned int cpu)
 		raw_spin_unlock(&stop_lock);
 	}
 
-	set_cpu_online(cpu, false);
+	set_cpu_active(cpu, false);
 
 	local_fiq_disable();
 	local_irq_disable();
@@ -568,10 +568,10 @@ void smp_send_stop(void)
 
 	/* Wait up to one second for other CPUs to stop */
 	timeout = USEC_PER_SEC;
-	while (num_online_cpus() > 1 && timeout--)
+	while (num_active_cpus() > 1 && timeout--)
 		udelay(1);
 
-	if (num_online_cpus() > 1)
+	if (num_active_cpus() > 1)
 		pr_warning("SMP: failed to stop secondary CPUs\n");
 
 	smp_kill_cpus(&mask);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

