Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab2EII06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690Ab2EII0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:26:44 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: [PATCH 2/5] Take in account that several cpus might call check_tsc_sync_* at the same time
Date: Wed,  9 May 2012 12:24:59 +0200
Message-Id: <1336559102-28103-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

conditions:
  multiliple cpus guest on over-commited host running aggressive
  cpu online/offline script.

real use-case:
  cpu hotplug in virt environment

Guest may hung with following trace:
---- cut ----
[   54.234569] CPU3: Stuck ??
./offV2.sh: line 11: echo: write error: Input/output error
[   54.250408] CPU 1 is now offline
[   54.260887] CPU 2 is now offline
[   54.261350] SMP alternatives: switching to UP code
./offV2.sh: line 8: echo: write error: Device or resource busy
[   54.286857] SMP alternatives: switching to SMP code
[   54.299540] Booting Node 0 Processor 1 APIC 0x1
[   54.250401] Disabled fast string operations
[   54.591023] ------------[ cut here ]------------
[   54.591023] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x98/0xc0()
[   54.591023] Hardware name: KVM
[   54.591023] Watchdog detected hard LOCKUP on cpu 0
[   54.591023] Modules linked in: sunrpc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc crc32c_intel ghash_clmulni_intel microcode serio_raw virtio_balloon e1000 i2c_piix4 i2c_core floppy [last unloaded: scsi_wait_scan]
[   54.591023] Pid: 1193, comm: offV2.sh Not tainted 3.4.0-rc4+ #203
[   54.591023] Call Trace:
[   54.591023]  <NMI>  [<ffffffff810566df>] warn_slowpath_common+0x7f/0xc0
[   54.591023]  [<ffffffff810567d6>] warn_slowpath_fmt+0x46/0x50
[   54.591023]  [<ffffffff810dddf8>] watchdog_overflow_callback+0x98/0xc0
[   54.591023]  [<ffffffff8111685c>] __perf_event_overflow+0x9c/0x220
[   54.591023]  [<ffffffff81023c18>] ? x86_perf_event_set_period+0xd8/0x160
[   54.591023]  [<ffffffff81116e14>] perf_event_overflow+0x14/0x20
[   54.591023]  [<ffffffff81029405>] intel_pmu_handle_irq+0x1a5/0x310
[   54.591023]  [<ffffffff815436e1>] perf_event_nmi_handler+0x21/0x30
[   54.591023]  [<ffffffff81542f52>] do_nmi+0x132/0x3d0
[   54.591023]  [<ffffffff815424bc>] end_repeat_nmi+0x1a/0x1e
[   54.591023]  [<ffffffff81053adf>] ? __cleanup_sighand+0x2f/0x40
[   54.591023]  [<ffffffff81539b27>] ? check_tsc_sync_source+0x5c/0x14a
[   54.591023]  [<ffffffff81539b27>] ? check_tsc_sync_source+0x5c/0x14a
[   54.591023]  [<ffffffff81539b27>] ? check_tsc_sync_source+0x5c/0x14a
[   54.591023]  <<EOE>>  [<ffffffff81539274>] native_cpu_up+0x156/0x181
[   54.591023]  [<ffffffff8153ad8c>] _cpu_up+0x9c/0x10e
[   54.591023]  [<ffffffff8153ae4a>] cpu_up+0x4c/0x5c
[   54.591023]  [<ffffffff8152cd1c>] store_online+0x9c/0xd0
[   54.591023]  [<ffffffff8136d210>] dev_attr_store+0x20/0x30
[   54.591023]  [<ffffffff811e819f>] sysfs_write_file+0xef/0x170
[   54.591023]  [<ffffffff81179618>] vfs_write+0xc8/0x190
[   54.591023]  [<ffffffff811797e1>] sys_write+0x51/0x90
[   54.591023]  [<ffffffff81549c29>] system_call_fastpath+0x16/0x1b
[   54.591023] ---[ end trace d5170b988db7c86f ]---
---- cut ----

this happens when boot cpu0 give-ups on waiting for cpu3 due to cpu3 not
setting cpu_callin_mask in specified timeout. And then cpu1 is being brought
online.

 1. In this case cpu3 already incremented start_count => 1 and waiting at:

      while (atomic_read(&start_count) != cpus) /// local const int cpus = 2

 2. then cpu1 arrives, increments start_count => 2 and cpu[1,3] continue
    to boot as if everything ok.

 3. then cpu0 arrives to check_tsc_sync_source and lock-ups on

      while (atomic_read(&start_count) != cpus-1) // start_count is 2

Fix race by making boot cpu lead rendezvous process and forcing failed
cpu to return early from check_tsc_sync_target not doing clock sync.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/tsc_sync.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index fc25e60..5f06138 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -25,8 +25,8 @@
  * Entry/exit counters that make sure that both CPUs
  * run the measurement code at once:
  */
-static __cpuinitdata atomic_t start_count;
-static __cpuinitdata atomic_t stop_count;
+static __cpuinitdata atomic_t start_tsc_sync;
+static __cpuinitdata atomic_t stop_tsc_sync;
 
 /*
  * We use a raw spinlock in this exceptional case, because
@@ -123,8 +123,6 @@ static inline unsigned int loop_timeout(int cpu)
  */
 void __cpuinit check_tsc_sync_source(int cpu)
 {
-	int cpus = 2;
-
 	/*
 	 * No need to check if we already know that the TSC is not
 	 * synchronized:
@@ -140,23 +138,19 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	}
 
 	/*
-	 * Reset it - in case this is a second bootup:
+	 * Sygnal AP[s] that source cpu is arrived
 	 */
-	atomic_set(&stop_count, 0);
+	atomic_set(&start_tsc_sync, 1);
 
 	/*
 	 * Wait for the target to arrive:
 	 */
-	while (atomic_read(&start_count) != cpus-1)
+	while (atomic_read(&start_tsc_sync))
 		cpu_relax();
-	/*
-	 * Trigger the target to continue into the measurement too:
-	 */
-	atomic_inc(&start_count);
 
 	check_tsc_warp(loop_timeout(cpu));
 
-	while (atomic_read(&stop_count) != cpus-1)
+	while (!atomic_read(&stop_tsc_sync))
 		cpu_relax();
 
 	if (nr_warps) {
@@ -173,7 +167,6 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	/*
 	 * Reset it - just in case we boot another CPU later:
 	 */
-	atomic_set(&start_count, 0);
 	nr_warps = 0;
 	max_warp = 0;
 	last_tsc = 0;
@@ -181,7 +174,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	/*
 	 * Let the target continue with the bootup:
 	 */
-	atomic_inc(&stop_count);
+	atomic_set(&stop_tsc_sync, 0);
 }
 
 /*
@@ -189,29 +182,30 @@ void __cpuinit check_tsc_sync_source(int cpu)
  */
 void __cpuinit check_tsc_sync_target(void)
 {
-	int cpus = 2;
-
 	if (unsynchronized_tsc() || tsc_clocksource_reliable)
 		return;
 
 	/*
-	 * Register this CPU's participation and wait for the
-	 * source CPU to start the measurement:
+	 * Wait for the source CPU to start the measurement
 	 */
-	atomic_inc(&start_count);
-	while (atomic_read(&start_count) != cpus)
+	while (!atomic_read(&start_tsc_sync))
 		cpu_relax();
 
+	if (!cpumask_test_cpu(smp_processor_id(), cpu_initialized_mask))
+		return;
+
+	atomic_set(&start_tsc_sync, 0);
+
 	check_tsc_warp(loop_timeout(smp_processor_id()));
 
 	/*
 	 * Ok, we are done:
 	 */
-	atomic_inc(&stop_count);
+	atomic_set(&stop_tsc_sync, 1);
 
 	/*
 	 * Wait for the source CPU to print stuff:
 	 */
-	while (atomic_read(&stop_count) != cpus)
+	while (atomic_read(&stop_tsc_sync))
 		cpu_relax();
 }
-- 
1.7.1

