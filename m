Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2EVCz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:55:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:20583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab2EVCzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208,223";a="146715234"
Date: Tue, 22 May 2012 10:52:33 +0800
From: Feng Tang <feng.tang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH]x86, reboot: Fix a warning message triggered by
 stop_other_cpus()
Message-ID: <20120522105233.725be041@feng-i7>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 96214a16a0e0da523ae770c30a8641dc8bec89ce Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Tue, 22 May 2012 09:50:40 +0800
Subject: [PATCH] x86, reboot: Fix a warning message triggered by
 stop_other_cpus()

When rebooting our 24 CPU Westmere servers with 3.4-rc6, we can always see
such warning msg

Restarting system.
machine restart
------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:125 native_smp_send_reschedule+0x74/0xa7()
Hardware name: X8DTN
Modules linked in: igb [last unloaded: scsi_wait_scan]
Pid: 1, comm: systemd-shutdow Not tainted 3.4.0-rc6+ #22
Call Trace:
 <IRQ>  [<ffffffff8102a41f>] warn_slowpath_common+0x7e/0x96
 [<ffffffff8102a44c>] warn_slowpath_null+0x15/0x17
 [<ffffffff81018cf7>] native_smp_send_reschedule+0x74/0xa7
 [<ffffffff810561c1>] trigger_load_balance+0x279/0x2a6
 [<ffffffff81050112>] scheduler_tick+0xe0/0xe9
 [<ffffffff81036768>] update_process_times+0x60/0x70
 [<ffffffff81062f2f>] tick_sched_timer+0x68/0x92
 [<ffffffff81046e33>] __run_hrtimer+0xb3/0x13c
 [<ffffffff81062ec7>] ? tick_nohz_handler+0xd0/0xd0
 [<ffffffff810474f2>] hrtimer_interrupt+0xdb/0x198
 [<ffffffff81019a35>] smp_apic_timer_interrupt+0x81/0x94
 [<ffffffff81655187>] apic_timer_interrupt+0x67/0x70
 <EOI>  [<ffffffff8101a3c4>] ? default_send_IPI_mask_allbutself_phys+0xb4/0xc4
 [<ffffffff8101c680>] physflat_send_IPI_allbutself+0x12/0x14
 [<ffffffff81018db4>] native_nmi_stop_other_cpus+0x8a/0xd6
 [<ffffffff810188ba>] native_machine_shutdown+0x50/0x67
 [<ffffffff81018926>] machine_shutdown+0xa/0xc
 [<ffffffff8101897e>] native_machine_restart+0x20/0x32
 [<ffffffff810189b0>] machine_restart+0xa/0xc
 [<ffffffff8103b196>] kernel_restart+0x47/0x4c
 [<ffffffff8103b2e6>] sys_reboot+0x13e/0x17c
 [<ffffffff8164e436>] ? _raw_spin_unlock_bh+0x10/0x12
 [<ffffffff810fcac9>] ? bdi_queue_work+0xcf/0xd8
 [<ffffffff810fe82f>] ? __bdi_start_writeback+0xae/0xb7
 [<ffffffff810e0d64>] ? iterate_supers+0xa3/0xb7
 [<ffffffff816547a2>] system_call_fastpath+0x16/0x1b
---[ end trace 320af5cb1cb60c5b ]---

The root cause seems to be the default_send_IPI_mask_allbutself_phys()
takes quiet some time (I measured it could be several ms) to complete
sending NMIs to all the other 23 CPUs, and for HZ=250/1000 system, the
time is long enough for a timer interrupt to happen, which will in
turn trigger to kick load balance to a stopped CPU and cause this
warning in native_smp_send_reschedule().

So disabling the local irq before stop_other_cpu() can fix this
problem (tested 25 times reboot ok), and it is fine as there should
be nobody caring the timer interrupt in such reboot stage.

The patch is against v3.4-rc6

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/reboot.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..5aa8797 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -659,9 +659,12 @@ void native_machine_shutdown(void)
 	/* Make certain I only run on the appropriate processor */
 	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
 
-	/* O.K Now that I'm on the appropriate processor,
-	 * stop all of the others.
+	/*
+	 * O.K Now that I'm on the appropriate processor, stop all of the
+	 * others. Also disable the local irq to not receive the per-cpu
+	 * timer interrupt which may trigger scheduler's load balance.
 	 */
+	local_irq_disable();
 	stop_other_cpus();
 #endif
 
-- 
1.7.5.1
