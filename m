Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2EII0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab2EII0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:26:42 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu bring up
Date: Wed,  9 May 2012 12:24:58 +0200
Message-Id: <1336559102-28103-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bringing up cpuX1, it could stall in start_secondary
before setting cpu_callin_mask for more than 5 sec. That forces
do_boot_cpu() to give up on waiting and go to error return path
printing messages:
  pr_err("CPU%d: Stuck ??\n", cpuX1);
or
  pr_err("CPU%d: Not responding.\n", cpuX1);
and native_cpu_up returns early with -EIO. However AP may continue
its boot process till it reaches check_tsc_sync_target(), where
it will wait for boot cpu to run cpu_up...=>check_tsc_sync_source.
That will never happen since cpu_up have returned with error before.

Now we need to note that cpuX1 is marked as active in smp_callin
before it stuck in check_tsc_sync_target. And when another cpuX2
is being onlined, start_secondary on it will call
  smp_callin
    -> smp_store_cpu_info
      -> identify_secondary_cpu
        -> mtrr_ap_init
          -> set_mtrr_from_inactive_cpu
            -> stop_machine_from_inactive_cpu
where it's going to schedule stop_machine work on all ACTIVE cpus
  smdata.num_threads = num_active_cpus() + 1;
and wait till they all complete it before continuing. As was noted
before cpuX1 was marked as active but can't execute any work since
it's not completed initialization and stuck in check_tsc_sync_target.
As result system soft lockups in stop_machine_cpu_stop.

backtrace from reproducer:

PID: 3324   TASK: ffff88007c00ae20  CPU: other cpus   COMMAND: "migration/1"
    [exception RIP: stop_machine_cpu_stop+131]
...
 #0 [ffff88007b4d7de8] cpu_stopper_thread at ffffffff810c66bd
 #1 [ffff88007b4d7ee8] kthread at ffffffff8107871e
 #2 [ffff88007b4d7f48] kernel_thread_helper at ffffffff8154af24

PID: 0      TASK: ffff88007c029710  CPU: 2   COMMAND: "swapper/2"
    [exception RIP: check_tsc_sync_target+33]
...
 #0 [ffff88007c025f30] start_secondary at ffffffff81539876

PID: 0      TASK: ffff88007c041710  CPU: 3   COMMAND: "swapper/3"
    [exception RIP: stop_machine_cpu_stop+131]
...
 #0 [ffff88007c04be50] stop_machine_from_inactive_cpu at ffffffff810c6b2f
 #1 [ffff88007c04bee0] mtrr_ap_init at ffffffff8102e963
 #2 [ffff88007c04bf10] identify_secondary_cpu at ffffffff81536799
 #3 [ffff88007c04bf20] smp_store_cpu_info at ffffffff815396d5
 #4 [ffff88007c04bf30] start_secondary at ffffffff81539800

Could be fixed by not marking being onlined cpu as active too early.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/smpboot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e1e406..ae19d90 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -232,8 +232,6 @@ static void __cpuinit smp_callin(void)
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
 
-	notify_cpu_starting(cpuid);
-
 	/*
 	 * Allow the master to continue.
 	 */
@@ -268,6 +266,8 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 */
 	check_tsc_sync_target();
 
+	notify_cpu_starting(smp_processor_id());
+
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
-- 
1.7.1

