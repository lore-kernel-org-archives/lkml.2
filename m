Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1CRUi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:38:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29627 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab1CRUis (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 18 Mar 2011 16:38:48 -0400
Date: Fri, 18 Mar 2011 16:38:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: tglx@linutronix.de, john.stultz@linaro.org, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: 2.6.39 crashes BUG: unable to handle kernel NULL pointer
 dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55 under Xen as PV
 guest.
Message-ID: <20110318203830.GA9262@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D83C2CA.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haven't done any bisection, but looking at the latest set of
patches John's name is on them. (John, congrats on a new job)

With the latest linus/master I get this when starting a Xen Linux PV
guest:

[    0.404760] initcall psmouse_init+0x0/0x79 returned 0 after 59 usecs
[    0.404767] calling  cmos_init+0x0/0x6a @ 1
[    0.464855] BUG: unable to handle kernel NULL pointer dereference at 0000000000000428
[    0.464867] IP: [<ffffffff8105d347>] queue_work_on+0x4/0x1d
[    0.464874] PGD 0 
[    0.464879] Oops: 0002 [#1] SMP 
[    0.464884] last sysfs file: 
[    0.464889] CPU 0 
[    0.464892] Modules linked in:
[    0.464897] 
[    0.464900] Pid: 1, comm: swapper Not tainted 2.6.38-05793-g5996613 #12  
[    0.464909] RIP: e030:[<ffffffff8105d347>]  [<ffffffff8105d347>] queue_work_on+0x4/0x1d
[    0.464917] RSP: e02b:ffff88003f9b79e0  EFLAGS: 00010006
[    0.464921] RAX: ffff88003f9a6e40 RBX: ffffffff81a29d90 RCX: 000000000000000a
[    0.464926] RDX: 0000000000000428 RSI: ffff88003f9a6e40 RDI: 0000000000000000
[    0.464931] RBP: ffff88003f9b79e0 R08: 00000000000000a5 R09: fffffff186b1c025
[    0.464937] R10: 0000000000001613 R11: 00000000000b803d R12: 00000000ffffffd0
[    0.464942] R13: ffffffff81a29dff R14: 0000000000000014 R15: ffff88003f9b7b47
[    0.464949] FS:  0000000000000000(0000) GS:ffff88003ffc4000(0000) knlGS:0000000000000000
[    0.464955] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.464960] CR2: 0000000000000428 CR3: 0000000001803000 CR4: 0000000000000660
[    0.464965] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.464971] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.464976] Process swapper (pid: 1, threadinfo ffff88003f9b6000, task ffff88003f9b8000)
[    0.464982] Stack:
[    0.464985]  ffff88003f9b79f0 ffffffff8105d38f ffff88003f9b7a00 ffffffff8105d3a4
[    0.464996]  ffff88003f9b7a10 ffffffff81331b2e ffff88003f9b7a40 ffffffff81333939
[    0.465006]  0000000000000224 00000000000000df ffffffff81a29d20 ffffffff81a29d90
[    0.465018] Call Trace:
[    0.465023]  [<ffffffff8105d38f>] queue_work+0x1a/0x1c
[    0.465029]  [<ffffffff8105d3a4>] schedule_work+0x13/0x15
[    0.465035]  [<ffffffff81331b2e>] rtc_update_irq+0x10/0x12
[    0.465041]  [<ffffffff81333939>] cmos_checkintr+0x4d/0x55
[    0.465047]  [<ffffffff81333987>] cmos_irq_disable+0x46/0x4e
[    0.465051]  [<ffffffff8133481d>] cmos_set_alarm+0xd9/0x16e
[    0.465051]  [<ffffffff813320a4>] __rtc_set_alarm+0x7d/0x88
[    0.465051]  [<ffffffff813321fa>] rtc_timer_enqueue+0x71/0xb8
[    0.465051]  [<ffffffff81331707>] ? rtc_tm_to_time+0x2f/0x38

... full log at the end.

>From a brief look it looks as if rtc_device_register was never
called, so

INIT_WORK(&rtc->irqwork, rtc_timer_do_work);

was never called.. and hence schedule_work tries to derefence an
unitialized rtc->irqwork.

Which actually sounds right - the rtc_device_register should not
be called since there are no RTC clocks exposed.

There are probably two ways of fixing this - making rtc_update_irq
check the rtc->irqwork (not attempted) or inhibit cmos_pnp_probe from
setting this up. Looking at the cmos_pnp_probe and its friend they all
call cmos_wake_setup, but never checks whether that function works properly.

The cmos_wake_setup checks for ACPI (which is disabled for PV guests)
and just returns.

This little patch seems to work, but not sure if that is the correct
way to do it?

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 911e75c..660fa47 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -944,11 +944,11 @@ static void rtc_wake_off(struct device *dev)
  */
 static struct cmos_rtc_board_info acpi_rtc_info;
 
-static void __devinit
+static int __devinit
 cmos_wake_setup(struct device *dev)
 {
 	if (acpi_disabled)
-		return;
+		return -ENODEV;
 
 	rtc_wake_setup();
 	acpi_rtc_info.wake_on = rtc_wake_on;
@@ -973,13 +973,16 @@ cmos_wake_setup(struct device *dev)
 
 	/* RTC always wakes from S1/S2/S3, and often S4/STD */
 	device_init_wakeup(dev, 1);
+
+	return 0;
 }
 
 #else
 
-static void __devinit
+static int __devinit
 cmos_wake_setup(struct device *dev)
 {
+	return -ENODEV;
 }
 
 #endif
@@ -991,7 +994,10 @@ cmos_wake_setup(struct device *dev)
 static int __devinit
 cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
-	cmos_wake_setup(&pnp->dev);
+	int rc = cmos_wake_setup(&pnp->dev);
+
+	if (rc)
+		return;
 
 	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
 		/* Some machines contain a PNP entry for the RTC, but
@@ -1108,8 +1114,12 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
+	int rc;
+
 	cmos_of_init(pdev);
-	cmos_wake_setup(&pdev->dev);
+	rc = cmos_wake_setup(&pdev->dev);
+	if (rc)
+		return rc;
 	return cmos_do_probe(&pdev->dev,
 			platform_get_resource(pdev, IORESOURCE_IO, 0),
 			platform_get_irq(pdev, 0));

And here is the full failing bootup log:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-05793-g5996613 (konrad@phenom) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #12 SMP Fri Mar 18 15:04:28 EDT 2011
[    0.000000] Command line: console=hvc0 debug initcall_debug loglevel=10
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] released 0 pages of unused memory
[    0.000000] Set 0 page(s) to 1-1 mapping.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000040800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x40800 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 0e354000
[    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-0000000040800000
[    0.000000]  0000000000 - 0040800000 page 4k
[    0.000000] kernel direct mapping tables up to 40800000 @ 3fdf9000-40000000
[    0.000000] RAMDISK: 01b6e000 - 0e354000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000040800000
[    0.000000] NUMA: Using 63 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000040800000
[    0.000000]   NODE_DATA [000000003fffb000 - 000000003fffffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x00040800
[    0.000000] On node 0 totalpages: 264080
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3923 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3556 pages used for memmap
[    0.000000]   DMA32 zone: 256540 pages, LIFO batch:31
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40800000 (gap: 40800000:bf800000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1.0-rc7-pre (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003ffc4000 s83840 r8192 d22656 u114688
[    0.000000] pcpu-alloc: s83840 r8192 d22656 u114688 alloc=28*4096
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 260463
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: console=hvc0 debug initcall_debug loglevel=10
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 812364k/1056768k available (4516k kernel code, 448k absent, 243956k reserved, 4177k data, 668k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 3000.250 MHz processor.
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.50 BogoMIPS (lpj=3000250)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000999] Mount-cache hash table entries: 256
[    0.000999] Initializing cgroup subsys ns
[    0.000999] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.000999] Initializing cgroup subsys cpuacct
[    0.000999] Initializing cgroup subsys freezer
[    0.000999] tseg: 0000000000
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 5
[    0.000999] SMP alternatives: switching to UP code
[    0.001021] Freeing SMP alternatives: 16k freed
[    0.001107] cpu 0 spinlock event irq 17
[    0.001128] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.001134] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.001140] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.001145] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.001151] calling  init_hw_perf_events+0x0/0xe72 @ 1
[    0.001156] Performance Events: 
[    0.001160] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.001165] no hardware sampling interrupt available.
[    0.001188] Broken PMU hardware detected, using software events only.
[    0.001195] initcall init_hw_perf_events+0x0/0xe72 returned 0 after 0 usecs
[    0.001200] calling  migration_init+0x0/0x71 @ 1
[    0.001207] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.001212] calling  spawn_ksoftirqd+0x0/0x57 @ 1
[    0.001238] initcall spawn_ksoftirqd+0x0/0x57 returned 0 after 0 usecs
[    0.001244] calling  init_workqueues+0x0/0x2b0 @ 1
[    0.001306] initcall init_workqueues+0x0/0x2b0 returned 0 after 0 usecs
[    0.001314] calling  init_call_single_data+0x0/0xa6 @ 1
[    0.001320] initcall init_call_single_data+0x0/0xa6 returned 0 after 0 usecs
[    0.001326] calling  cpu_stop_init+0x0/0xc9 @ 1
[    0.001350] initcall cpu_stop_init+0x0/0xc9 returned 0 after 0 usecs
[    0.001356] calling  relay_init+0x0/0x14 @ 1
[    0.001361] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.001367] calling  tracer_alloc_buffers+0x0/0x171 @ 1
[    0.001403] initcall tracer_alloc_buffers+0x0/0x171 returned 0 after 0 usecs
[    0.001410] calling  init_trace_printk+0x0/0x12 @ 1
[    0.001415] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.001421] calling  mce_amd_init+0x0/0x15d @ 1
[    0.001426] MCE: In-kernel MCE decoding enabled.
[    0.001432] initcall mce_amd_init+0x0/0x15d returned 0 after 0 usecs
[    0.001437] Brought up 1 CPUs
[    0.001583] kworker/u:0 used greatest stack depth: 6032 bytes left
[    0.001680] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.001687] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.001692] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.001699] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.001707] calling  net_ns_init+0x0/0xed @ 1
[    0.001736] initcall net_ns_init+0x0/0xed returned 0 after 0 usecs
[    0.001743] calling  e820_mark_nvs_memory+0x0/0x40 @ 1
[    0.001748] initcall e820_mark_nvs_memory+0x0/0x40 returned 0 after 0 usecs
[    0.001754] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.001760] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.001765] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.001771] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.001776] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.001781] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 0 usecs
[    0.001787] calling  init_smp_flush+0x0/0x4a @ 1
[    0.001793] initcall init_smp_flush+0x0/0x4a returned 0 after 0 usecs
[    0.001800] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.001804] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.001810] calling  sysctl_init+0x0/0x32 @ 1
[    0.001850] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.001856] calling  ksysfs_init+0x0/0x94 @ 1
[    0.001866] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.001871] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.001877] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.001883] calling  pm_init+0x0/0x39 @ 1
[    0.001891] initcall pm_init+0x0/0x39 returned 0 after 0 usecs
[    0.001897] calling  pm_disk_init+0x0/0x19 @ 1
[    0.001903] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.001909] calling  swsusp_header_init+0x0/0x2c @ 1
[    0.001915] initcall swsusp_header_init+0x0/0x2c returned 0 after 0 usecs
[    0.001921] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.001926] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.001931] calling  fsnotify_init+0x0/0x26 @ 1
[    0.001939] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.001944] calling  filelock_init+0x0/0x2e @ 1
[    0.001950] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.001956] calling  init_misc_binfmt+0x0/0x44 @ 1
[    0.001961] initcall init_misc_binfmt+0x0/0x44 returned 0 after 0 usecs
[    0.001967] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.001971] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.001977] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.001982] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.001988] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.001993] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.001998] calling  debugfs_init+0x0/0x5c @ 1
[    0.001999] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.001999] calling  random32_init+0x0/0xd8 @ 1
[    0.001999] initcall random32_init+0x0/0xd8 returned 0 after 0 usecs
[    0.001999] calling  virtio_init+0x0/0x26 @ 1
[    0.002017] initcall virtio_init+0x0/0x26 returned 0 after 976 usecs
[    0.002024] calling  __gnttab_init+0x0/0x21 @ 1
[    0.002040] Grant table initialized
[    0.002045] initcall __gnttab_init+0x0/0x21 returned 0 after 0 usecs
[    0.002051] calling  early_resume_init+0x0/0x19e @ 1
[    0.021066] Time: 165:165:165  Date: 165/165/65
[    0.021080] initcall early_resume_init+0x0/0x19e returned 0 after 18553 usecs
[    0.021085] calling  cpufreq_core_init+0x0/0x9b @ 1
[    0.021098] initcall cpufreq_core_init+0x0/0x9b returned 0 after 0 usecs
[    0.021104] calling  cpuidle_init+0x0/0x40 @ 1
[    0.021111] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.021116] calling  sock_init+0x0/0x83 @ 1
[    0.021145] initcall sock_init+0x0/0x83 returned 0 after 0 usecs
[    0.021151] calling  net_inuse_init+0x0/0x26 @ 1
[    0.021158] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.021164] calling  netpoll_init+0x0/0x41 @ 1
[    0.021168] initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
[    0.021174] calling  netlink_proto_init+0x0/0x1a0 @ 1
[    0.021185] NET: Registered protocol family 16
[    0.021198] initcall netlink_proto_init+0x0/0x1a0 returned 0 after 0 usecs
[    0.021204] calling  bdi_class_init+0x0/0x4d @ 1
[    0.021252] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.021260] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.021269] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.021274] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.021315] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.021322] calling  pci_driver_init+0x0/0x12 @ 1
[    0.021365] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.021372] calling  backlight_class_init+0x0/0x5d @ 1
[    0.021410] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.021416] calling  video_output_class_init+0x0/0x19 @ 1
[    0.021457] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.021465] calling  xenbus_init+0x0/0x269 @ 1
[    0.021519] initcall xenbus_init+0x0/0x269 returned 0 after 0 usecs
[    0.021525] calling  tty_class_init+0x0/0x38 @ 1
[    0.021563] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.021569] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.021652] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.021660] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.021667] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.021674] calling  register_node_type+0x0/0x12 @ 1
[    0.021716] initcall register_node_type+0x0/0x12 returned 0 after 0 usecs
[    0.021723] calling  i2c_init+0x0/0x6a @ 1
[    0.021756] kworker/u:0 used greatest stack depth: 5720 bytes left
[    0.021807] initcall i2c_init+0x0/0x6a returned 0 after 0 usecs
[    0.021814] calling  amd_postcore_init+0x0/0x150 @ 1
[    0.021850] Extended Config Space enabled on 0 nodes
[    0.021856] initcall amd_postcore_init+0x0/0x150 returned 0 after 0 usecs
[    0.021862] calling  arch_kdebugfs_init+0x0/0x227 @ 1
[    0.021877] initcall arch_kdebugfs_init+0x0/0x227 returned 0 after 0 usecs
[    0.021883] calling  configure_trampolines+0x0/0x26 @ 1
[    0.021891] initcall configure_trampolines+0x0/0x26 returned 0 after 0 usecs
[    0.021898] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.021903] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.021909] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.021914] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.021920] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.021925] calling  acpi_pci_init+0x0/0x61 @ 1
[    0.021930] initcall acpi_pci_init+0x0/0x61 returned 0 after 0 usecs
[    0.021936] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.022009] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 976 usecs
[    0.022017] calling  register_xen_pci_notifier+0x0/0x33 @ 1
[    0.022022] initcall register_xen_pci_notifier+0x0/0x33 returned 0 after 0 usecs
[    0.022028] calling  dmi_id_init+0x0/0x30d @ 1
[    0.022033] initcall dmi_id_init+0x0/0x30d returned -19 after 0 usecs
[    0.022039] calling  pci_arch_init+0x0/0x69 @ 1
[    0.022344] PCI: setting up Xen PCI frontend stub
[    0.022357] PCI: pci_cache_line_size set to 64 bytes
[    0.022362] initcall pci_arch_init+0x0/0x69 returned 0 after 0 usecs
[    0.022367] calling  topology_init+0x0/0x96 @ 1
[    0.022447] initcall topology_init+0x0/0x96 returned 0 after 0 usecs
[    0.022454] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.022460] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.022465] calling  init_vdso_vars+0x0/0x218 @ 1
[    0.022480] initcall init_vdso_vars+0x0/0x218 returned 0 after 0 usecs
[    0.022486] calling  sysenter_setup+0x0/0x2d8 @ 1
[    0.022492] initcall sysenter_setup+0x0/0x2d8 returned 0 after 0 usecs
[    0.022498] calling  param_sysfs_init+0x0/0x191 @ 1
[    0.028588] initcall param_sysfs_init+0x0/0x191 returned 0 after 5858 usecs
[    0.028606] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.028612] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.028617] calling  default_bdi_init+0x0/0xa8 @ 1
[    0.028708] initcall default_bdi_init+0x0/0xa8 returned 0 after 0 usecs
[    0.028715] calling  init_bio+0x0/0xda @ 1
[    0.028723] bio: create slab <bio-0> at 0
[    0.028730] initcall init_bio+0x0/0xda returned 0 after 0 usecs
[    0.028735] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.028742] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.028748] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.028753] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.028759] calling  blk_settings_init+0x0/0x2a @ 1
[    0.028764] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.028770] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.028777] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.028783] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.028789] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.028794] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.028800] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.028805] calling  genhd_device_init+0x0/0x85 @ 1
[    0.028868] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
[    0.028876] calling  pci_slot_init+0x0/0x46 @ 1
[    0.028883] initcall pci_slot_init+0x0/0x46 returned 0 after 0 usecs
[    0.028889] calling  fbmem_init+0x0/0x98 @ 1
[    0.028928] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.028934] calling  acpi_init+0x0/0xbc @ 1
[    0.028938] ACPI: Interpreter disabled.
[    0.028942] initcall acpi_init+0x0/0xbc returned -19 after 0 usecs
[    0.028948] calling  dock_init+0x0/0xa5 @ 1
[    0.028952] initcall dock_init+0x0/0xa5 returned 0 after 0 usecs
[    0.028957] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    0.028962] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 0 usecs
[    0.028968] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.028973] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 0 usecs
[    0.028978] calling  pnp_init+0x0/0x12 @ 1
[    0.028998] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.028998] calling  xen_setup_shutdown_event+0x0/0x22 @ 1
[    0.029016] initcall xen_setup_shutdown_event+0x0/0x22 returned 0 after 976 usecs
[    0.029019] calling  balloon_init+0x0/0x126 @ 1
[    0.029024] xen/balloon: Initialising balloon driver.
[    0.029029] last_pfn = 0x40800 max_arch_pfn = 0x400000000
[    0.029051] initcall balloon_init+0x0/0x126 returned 0 after 0 usecs
[    0.029057] calling  xenbus_probe_backend_init+0x0/0x2d @ 1
[    0.030082] initcall xenbus_probe_backend_init+0x0/0x2d returned 0 after 976 usecs
[    0.030082] calling  xenbus_probe_frontend_init+0x0/0x2d @ 1
[    0.030095] initcall xenbus_probe_frontend_init+0x0/0x2d returned 0 after 0 usecs
[    0.030095] calling  balloon_init+0x0/0x100 @ 1
[    0.030095] xen-balloon: Initialising balloon driver.
[    0.030103] initcall balloon_init+0x0/0x100 returned 0 after 0 usecs
[    0.030103] calling  misc_init+0x0/0xb7 @ 1
[    0.031045] initcall misc_init+0x0/0xb7 returned 0 after 976 usecs
[    0.031051] calling  vga_arb_device_init+0x0/0x80 @ 1
[    0.031127] vgaarb: loaded
[    0.031132] initcall vga_arb_device_init+0x0/0x80 returned 0 after 0 usecs
[    0.031138] calling  cn_init+0x0/0x9e @ 1
[    0.031151] initcall cn_init+0x0/0x9e returned 0 after 0 usecs
[    0.031157] calling  phy_init+0x0/0x2e @ 1
[    0.031272] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.031279] calling  init_pcmcia_cs+0x0/0x36 @ 1
[    0.031317] initcall init_pcmcia_cs+0x0/0x36 returned 0 after 0 usecs
[    0.031323] calling  usb_init+0x0/0x173 @ 1
[    0.031406] usbcore: registered new interface driver usbfs
[    0.031452] usbcore: registered new interface driver hub
[    0.031506] usbcore: registered new device driver usb
[    0.031513] initcall usb_init+0x0/0x173 returned 0 after 0 usecs
[    0.031519] calling  serio_init+0x0/0x31 @ 1
[    0.031559] initcall serio_init+0x0/0x31 returned 0 after 0 usecs
[    0.031566] calling  input_init+0x0/0x10d @ 1
[    0.031608] initcall input_init+0x0/0x10d returned 0 after 0 usecs
[    0.031615] calling  rtc_init+0x0/0x71 @ 1
[    0.031652] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.031658] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.031696] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.031704] calling  hwmon_init+0x0/0xee @ 1
[    0.031741] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    0.031747] calling  leds_init+0x0/0x48 @ 1
[    0.031786] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.031792] calling  pci_subsys_init+0x0/0x4d @ 1
[    0.031797] PCI: System does not support PCI
[    0.031801] PCI: System does not support PCI
[    0.031806] initcall pci_subsys_init+0x0/0x4d returned 0 after 0 usecs
[    0.031811] calling  proto_init+0x0/0x12 @ 1
[    0.031818] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.031823] calling  net_dev_init+0x0/0x222 @ 1
[    0.031997] initcall net_dev_init+0x0/0x222 returned 0 after 0 usecs
[    0.031997] calling  neigh_init+0x0/0x71 @ 1
[    0.031997] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.031997] calling  fib_rules_init+0x0/0xa6 @ 1
[    0.031997] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
[    0.031997] calling  pktsched_init+0x0/0xed @ 1
[    0.031997] initcall pktsched_init+0x0/0xed returned 0 after 0 usecs
[    0.031997] calling  tc_filter_init+0x0/0x4c @ 1
[    0.031997] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    0.031997] calling  tc_action_init+0x0/0x4c @ 1
[    0.031997] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    0.031997] calling  genl_init+0x0/0x84 @ 1
[    0.032040] initcall genl_init+0x0/0x84 returned 0 after 976 usecs
[    0.032048] calling  cipso_v4_init+0x0/0x88 @ 1
[    0.032055] initcall cipso_v4_init+0x0/0x88 returned 0 after 0 usecs
[    0.032061] calling  netlbl_init+0x0/0x81 @ 1
[    0.032065] NetLabel: Initializing
[    0.032069] NetLabel:  domain hash size = 128
[    0.032073] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.032086] NetLabel:  unlabeled traffic allowed by default
[    0.032092] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.032097] calling  rfkill_init+0x0/0x79 @ 1
[    0.032175] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    0.032182] calling  sysctl_init+0x0/0x48 @ 1
[    0.032188] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    0.032194] calling  xen_mc_debugfs+0x0/0x118 @ 1
[    0.032222] initcall xen_mc_debugfs+0x0/0x118 returned 0 after 0 usecs
[    0.032228] calling  xen_mmu_debugfs+0x0/0x2df @ 1
[    0.032270] initcall xen_mmu_debugfs+0x0/0x2df returned 0 after 0 usecs
[    0.032277] calling  xen_spinlock_debugfs+0x0/0x24e @ 1
[    0.032314] initcall xen_spinlock_debugfs+0x0/0x24e returned 0 after 0 usecs
[    0.032321] calling  print_ICs+0x0/0x51f @ 1
[    0.032327] initcall print_ICs+0x0/0x51f returned 0 after 0 usecs
[    0.032332] calling  hpet_late_init+0x0/0xf7 @ 1
[    0.032338] initcall hpet_late_init+0x0/0xf7 returned -19 after 0 usecs
[    0.032344] calling  init_amd_nbs+0x0/0xb6 @ 1
[    0.032349] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs
[    0.032355] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.032361] Switching to clocksource xen
[    0.032372] initcall clocksource_done_booting+0x0/0x5a returned 0 after 2 usecs
[    0.032378] calling  rb_init_debugfs+0x0/0x2f @ 1
[    0.032388] initcall rb_init_debugfs+0x0/0x2f returned 0 after 4 usecs
[    0.032394] calling  tracer_init_debugfs+0x0/0x338 @ 1
[    0.032472] initcall tracer_init_debugfs+0x0/0x338 returned 0 after 70 usecs
[    0.032479] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.032486] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 1 usecs
[    0.032492] calling  event_trace_init+0x0/0x283 @ 1
[    0.032691] Switched to NOHz mode on CPU #0
[    0.033959] initcall event_trace_init+0x0/0x283 returned 0 after 1787 usecs
[    0.033969] calling  init_kprobe_trace+0x0/0x79 @ 1
[    0.033981] initcall init_kprobe_trace+0x0/0x79 returned 0 after 4 usecs
[    0.033987] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.034004] initcall init_pipe_fs+0x0/0x4c returned 0 after 11 usecs
[    0.034011] calling  eventpoll_init+0x0/0x10a @ 1
[    0.034021] initcall eventpoll_init+0x0/0x10a returned 0 after 5 usecs
[    0.034028] calling  anon_inode_init+0x0/0x12e @ 1
[    0.034041] initcall anon_inode_init+0x0/0x12e returned 0 after 7 usecs
[    0.034048] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.034053] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.034053] calling  acpi_event_init+0x0/0x81 @ 1
[    0.034053] initcall acpi_event_init+0x0/0x81 returned 0 after 0 usecs
[    0.034053] calling  pnp_system_init+0x0/0x12 @ 1
[    0.034177] initcall pnp_system_init+0x0/0x12 returned 0 after 85 usecs
[    0.034185] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.034191] pnp: PnP ACPI: disabled
[    0.034196] initcall pnpacpi_init+0x0/0x8c returned 0 after 4 usecs
[    0.034202] calling  pcistub_init+0x0/0x1d7 @ 1
[    0.034259] initcall pcistub_init+0x0/0x1d7 returned 0 after 49 usecs
[    0.034267] calling  chr_dev_init+0x0/0xc5 @ 1
[    0.037651] initcall chr_dev_init+0x0/0xc5 returned 0 after 3297 usecs
[    0.037661] calling  firmware_class_init+0x0/0x19 @ 1
[    0.037706] initcall firmware_class_init+0x0/0x19 returned 0 after 35 usecs
[    0.037712] calling  init_pcmcia_bus+0x0/0x65 @ 1
[    0.037754] initcall init_pcmcia_bus+0x0/0x65 returned 0 after 35 usecs
[    0.037760] calling  thermal_init+0x0/0x75 @ 1
[    0.037802] initcall thermal_init+0x0/0x75 returned 0 after 36 usecs
[    0.037808] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.037814] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    0.037820] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
[    0.037825] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
[    0.037832] calling  init_acpi_pm_clocksource+0x0/0xf0 @ 1
[    0.037837] initcall init_acpi_pm_clocksource+0x0/0xf0 returned -19 after 0 usecs
[    0.037844] calling  pcibios_assign_resources+0x0/0x74 @ 1
[    0.037850] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 0 usecs
[    0.037856] calling  sysctl_core_init+0x0/0x38 @ 1
[    0.037870] initcall sysctl_core_init+0x0/0x38 returned 0 after 8 usecs
[    0.037875] calling  inet_init+0x0/0x24b @ 1
[    0.037892] NET: Registered protocol family 2
[    0.037992] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.038565] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.039264] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.039720] TCP: Hash tables configured (established 131072 bind 65536)
[    0.039726] TCP reno registered
[    0.039742] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.039765] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.039846] initcall inet_init+0x0/0x24b returned 0 after 1917 usecs
[    0.039853] calling  af_unix_init+0x0/0x55 @ 1
[    0.039858] NET: Registered protocol family 1
[    0.039867] initcall af_unix_init+0x0/0x55 returned 0 after 9 usecs
[    0.039873] calling  init_sunrpc+0x0/0x73 @ 1
[    0.039975] RPC: Registered udp transport module.
[    0.039980] RPC: Registered tcp transport module.
[    0.039985] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.039991] initcall init_sunrpc+0x0/0x73 returned 0 after 110 usecs
[    0.040057] calling  pci_apply_final_quirks+0x0/0xfb @ 1
[    0.040057] PCI: CLS 0 bytes, default 64
[    0.040057] initcall pci_apply_final_quirks+0x0/0xfb returned 0 after 5 usecs
[    0.040057] calling  populate_rootfs+0x0/0xd3 @ 1
[    0.043514] Trying to unpack rootfs image as initramfs...
[    0.292618] Freeing initrd memory: 204696k freed
[    0.342875] initcall populate_rootfs+0x0/0xd3 returned 0 after 292619 usecs
[    0.342897] calling  pci_iommu_init+0x0/0x57 @ 1
[    0.350746] DMA-API: preallocated 32768 debug entries
[    0.350765] DMA-API: debugging enabled by kernel config
[    0.350775] initcall pci_iommu_init+0x0/0x57 returned 0 after 7685 usecs
[    0.350782] calling  calgary_fixup_tce_spaces+0x0/0xf9 @ 1
[    0.350787] initcall calgary_fixup_tce_spaces+0x0/0xf9 returned -19 after 0 usecs
[    0.350794] calling  i8259A_init_sysfs+0x0/0x31 @ 1
[    0.350931] initcall i8259A_init_sysfs+0x0/0x31 returned 0 after 127 usecs
[    0.350938] calling  vsyscall_init+0x0/0x6c @ 1
[    0.350954] initcall vsyscall_init+0x0/0x6c returned 0 after 9 usecs
[    0.350959] calling  sbf_init+0x0/0xe9 @ 1
[    0.350964] initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
[    0.350970] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    0.351045] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 67 usecs
[    0.351053] calling  init_tsc_clocksource+0x0/0x5f @ 1
[    0.351053] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 2 usecs
[    0.351053] calling  add_rtc_cmos+0x0/0x97 @ 1
[    0.351123] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.351130] initcall add_rtc_cmos+0x0/0x97 returned 0 after 59 usecs
[    0.351136] calling  cache_sysfs_init+0x0/0x64 @ 1
[    0.351330] initcall cache_sysfs_init+0x0/0x64 returned 0 after 184 usecs
[    0.351338] calling  mcheck_init_device+0x0/0x106 @ 1
[    0.351344] initcall mcheck_init_device+0x0/0x106 returned -5 after 1 usecs
[    0.351350] initcall mcheck_init_device+0x0/0x106 returned with error code -5 
[    0.351355] calling  threshold_init_device+0x0/0x8c @ 1
[    0.351360] initcall threshold_init_device+0x0/0x8c returned 0 after 0 usecs
[    0.351367] calling  inject_init+0x0/0x2d @ 1
[    0.351371] Machine check injector initialized
[    0.351377] initcall inject_init+0x0/0x2d returned 0 after 5 usecs
[    0.351382] calling  thermal_throttle_init_device+0x0/0x9b @ 1
[    0.351388] initcall thermal_throttle_init_device+0x0/0x9b returned 0 after 0 usecs
[    0.351394] calling  msr_init+0x0/0x14a @ 1
[    0.351491] initcall msr_init+0x0/0x14a returned 0 after 89 usecs
[    0.351497] calling  cpuid_init+0x0/0x14a @ 1
[    0.351581] initcall cpuid_init+0x0/0x14a returned 0 after 75 usecs
[    0.351588] calling  ioapic_init_sysfs+0x0/0xae @ 1
[    0.351627] initcall ioapic_init_sysfs+0x0/0xae returned 0 after 33 usecs
[    0.351635] calling  add_pcspkr+0x0/0x3a @ 1
[    0.351679] initcall add_pcspkr+0x0/0x3a returned 0 after 38 usecs
[    0.351686] calling  microcode_init+0x0/0x132 @ 1
[    0.351734] microcode: CPU0: patch_level=0x010000bf
[    0.351782] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.351791] initcall microcode_init+0x0/0x132 returned 0 after 97 usecs
[    0.351798] calling  start_periodic_check_for_corruption+0x0/0x40 @ 1
[    0.351804] initcall start_periodic_check_for_corruption+0x0/0x40 returned 0 after 0 usecs
[    0.351811] calling  audit_classes_init+0x0/0xaf @ 1
[    0.351819] initcall audit_classes_init+0x0/0xaf returned 0 after 3 usecs
[    0.351825] calling  start_pageattr_test+0x0/0x42 @ 1
[    0.351852] initcall start_pageattr_test+0x0/0x42 returned 0 after 20 usecs
[    0.351858] calling  pt_dump_init+0x0/0x2b @ 1
[    0.351868] initcall pt_dump_init+0x0/0x2b returned 0 after 5 usecs
[    0.351874] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.351883] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 3 usecs
[    0.351888] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.351897] initcall proc_schedstat_init+0x0/0x22 returned 0 after 4 usecs
[    0.351903] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.351909] initcall proc_execdomains_init+0x0/0x22 returned 0 after 1 usecs
[    0.351915] calling  ioresources_init+0x0/0x3c @ 1
[    0.351922] initcall ioresources_init+0x0/0x3c returned 0 after 2 usecs
[    0.351928] calling  uid_cache_init+0x0/0x8c @ 1
[    0.351936] initcall uid_cache_init+0x0/0x8c returned 0 after 3 usecs
[    0.351942] calling  init_posix_timers+0x0/0x1cf @ 1
[    0.351948] initcall init_posix_timers+0x0/0x1cf returned 0 after 1 usecs
[    0.351954] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    0.351959] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    0.351965] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    0.351971] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
[    0.351977] calling  create_proc_profile+0x0/0x25f @ 1
[    0.351982] initcall create_proc_profile+0x0/0x25f returned 0 after 0 usecs
[    0.351988] calling  timekeeping_init_device+0x0/0x22 @ 1
[    0.352086] initcall timekeeping_init_device+0x0/0x22 returned 0 after 91 usecs
[    0.352094] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    0.352166] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 64 usecs
[    0.352174] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.352181] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 1 usecs
[    0.352186] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.352193] initcall init_tstats_procfs+0x0/0x2c returned 0 after 1 usecs
[    0.352199] calling  futex_init+0x0/0x7a @ 1
[    0.352209] initcall futex_init+0x0/0x7a returned 0 after 5 usecs
[    0.352214] calling  proc_dma_init+0x0/0x22 @ 1
[    0.352221] initcall proc_dma_init+0x0/0x22 returned 0 after 1 usecs
[    0.352226] calling  proc_modules_init+0x0/0x22 @ 1
[    0.352232] initcall proc_modules_init+0x0/0x22 returned 0 after 1 usecs
[    0.352238] calling  kallsyms_init+0x0/0x25 @ 1
[    0.352244] initcall kallsyms_init+0x0/0x25 returned 0 after 1 usecs
[    0.352250] calling  snapshot_device_init+0x0/0x12 @ 1
[    0.352297] initcall snapshot_device_init+0x0/0x12 returned 0 after 40 usecs
[    0.352304] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    0.352323] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 13 usecs
[    0.352330] calling  crash_notes_memory_init+0x0/0x37 @ 1
[    0.352338] initcall crash_notes_memory_init+0x0/0x37 returned 0 after 2 usecs
[    0.352344] calling  user_namespaces_init+0x0/0x2d @ 1
[    0.352354] initcall user_namespaces_init+0x0/0x2d returned 0 after 5 usecs
[    0.352360] calling  pid_namespaces_init+0x0/0x2d @ 1
[    0.352367] initcall pid_namespaces_init+0x0/0x2d returned 0 after 2 usecs
[    0.352373] calling  audit_init+0x0/0x153 @ 1
[    0.352378] audit: initializing netlink socket (disabled)
[    0.352393] type=2000 audit(1300478172.247:1): initialized
[    0.352399] initcall audit_init+0x0/0x153 returned 0 after 20 usecs
[    0.352405] calling  audit_watch_init+0x0/0x3a @ 1
[    0.352410] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    0.352416] calling  audit_tree_init+0x0/0x49 @ 1
[    0.352421] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    0.352427] calling  init_kprobes+0x0/0x17d @ 1
[    0.361200] initcall init_kprobes+0x0/0x17d returned 0 after 8561 usecs
[    0.361212] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    0.361229] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    0.361236] calling  init_tracepoints+0x0/0x12 @ 1
[    0.361241] initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
[    0.361247] calling  init_events+0x0/0x61 @ 1
[    0.361254] initcall init_events+0x0/0x61 returned 0 after 2 usecs
[    0.361259] calling  init_blk_tracer+0x0/0x55 @ 1
[    0.361265] initcall init_blk_tracer+0x0/0x55 returned 0 after 0 usecs
[    0.361271] calling  perf_event_sysfs_init+0x0/0x99 @ 1
[    0.361440] initcall perf_event_sysfs_init+0x0/0x99 returned 0 after 159 usecs
[    0.361448] calling  init_per_zone_wmark_min+0x0/0x67 @ 1
[    0.361517] initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 61 usecs
[    0.361525] calling  kswapd_init+0x0/0x75 @ 1
[    0.361556] initcall kswapd_init+0x0/0x75 returned 0 after 25 usecs
[    0.361562] calling  extfrag_debug_init+0x0/0x72 @ 1
[    0.361576] initcall extfrag_debug_init+0x0/0x72 returned 0 after 7 usecs
[    0.361581] calling  setup_vmstat+0x0/0xc5 @ 1
[    0.361595] initcall setup_vmstat+0x0/0xc5 returned 0 after 7 usecs
[    0.361600] calling  mm_sysfs_init+0x0/0x29 @ 1
[    0.361607] initcall mm_sysfs_init+0x0/0x29 returned 0 after 2 usecs
[    0.361613] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    0.361620] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 1 usecs
[    0.361626] calling  procswaps_init+0x0/0x22 @ 1
[    0.361632] initcall procswaps_init+0x0/0x22 returned 0 after 1 usecs
[    0.361637] calling  hugetlb_init+0x0/0x3f0 @ 1
[    0.361644] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.361659] initcall hugetlb_init+0x0/0x3f0 returned 0 after 15 usecs
[    0.361664] calling  slab_proc_init+0x0/0x25 @ 1
[    0.361671] initcall slab_proc_init+0x0/0x25 returned 0 after 1 usecs
[    0.361676] calling  slab_sysfs_init+0x0/0x102 @ 1
[    0.365344] initcall slab_sysfs_init+0x0/0x102 returned 0 after 3575 usecs
[    0.365352] calling  fcntl_init+0x0/0x2a @ 1
[    0.365361] initcall fcntl_init+0x0/0x2a returned 0 after 3 usecs
[    0.365367] calling  proc_filesystems_init+0x0/0x22 @ 1
[    0.365375] initcall proc_filesystems_init+0x0/0x22 returned 0 after 2 usecs
[    0.365380] calling  fsnotify_mark_init+0x0/0x3d @ 1
[    0.365404] initcall fsnotify_mark_init+0x0/0x3d returned 0 after 18 usecs
[    0.365410] calling  dnotify_init+0x0/0x7b @ 1
[    0.365470] initcall dnotify_init+0x0/0x7b returned 0 after 53 usecs
[    0.365481] calling  inotify_user_setup+0x0/0x70 @ 1
[    0.365492] initcall inotify_user_setup+0x0/0x70 returned 0 after 5 usecs
[    0.365498] calling  aio_setup+0x0/0xa8 @ 1
[    0.365511] initcall aio_setup+0x0/0xa8 returned 0 after 9 usecs
[    0.365517] calling  proc_locks_init+0x0/0x22 @ 1
[    0.365523] initcall proc_locks_init+0x0/0x22 returned 0 after 1 usecs
[    0.365529] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    0.365588] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 53 usecs
[    0.365594] calling  dquot_init+0x0/0x11b @ 1
[    0.365598] VFS: Disk quotas dquot_6.5.2
[    0.365678] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.365686] initcall dquot_init+0x0/0x11b returned 0 after 85 usecs
[    0.365692] calling  init_v2_quota_format+0x0/0x22 @ 1
[    0.365698] initcall init_v2_quota_format+0x0/0x22 returned 0 after 0 usecs
[    0.365703] calling  quota_init+0x0/0x26 @ 1
[    0.365712] initcall quota_init+0x0/0x26 returned 0 after 3 usecs
[    0.365717] calling  proc_cmdline_init+0x0/0x22 @ 1
[    0.365724] initcall proc_cmdline_init+0x0/0x22 returned 0 after 1 usecs
[    0.365729] calling  proc_consoles_init+0x0/0x22 @ 1
[    0.365736] initcall proc_consoles_init+0x0/0x22 returned 0 after 1 usecs
[    0.365741] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    0.365748] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 1 usecs
[    0.365754] calling  proc_devices_init+0x0/0x22 @ 1
[    0.365760] initcall proc_devices_init+0x0/0x22 returned 0 after 1 usecs
[    0.365765] calling  proc_interrupts_init+0x0/0x22 @ 1
[    0.365772] initcall proc_interrupts_init+0x0/0x22 returned 0 after 1 usecs
[    0.365778] calling  proc_loadavg_init+0x0/0x22 @ 1
[    0.365784] initcall proc_loadavg_init+0x0/0x22 returned 0 after 1 usecs
[    0.365789] calling  proc_meminfo_init+0x0/0x22 @ 1
[    0.365796] initcall proc_meminfo_init+0x0/0x22 returned 0 after 1 usecs
[    0.365801] calling  proc_stat_init+0x0/0x22 @ 1
[    0.365807] initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
[    0.365813] calling  proc_uptime_init+0x0/0x22 @ 1
[    0.365820] initcall proc_uptime_init+0x0/0x22 returned 0 after 1 usecs
[    0.365825] calling  proc_version_init+0x0/0x22 @ 1
[    0.365832] initcall proc_version_init+0x0/0x22 returned 0 after 1 usecs
[    0.365837] calling  proc_softirqs_init+0x0/0x22 @ 1
[    0.365844] initcall proc_softirqs_init+0x0/0x22 returned 0 after 1 usecs
[    0.365849] calling  proc_kcore_init+0x0/0xa9 @ 1
[    0.365858] initcall proc_kcore_init+0x0/0xa9 returned 0 after 3 usecs
[    0.365863] calling  vmcore_init+0x0/0x333 @ 1
[    0.365868] initcall vmcore_init+0x0/0x333 returned 0 after 0 usecs
[    0.365874] calling  proc_kmsg_init+0x0/0x25 @ 1
[    0.365880] initcall proc_kmsg_init+0x0/0x25 returned 0 after 1 usecs
[    0.365886] calling  proc_page_init+0x0/0x42 @ 1
[    0.365893] initcall proc_page_init+0x0/0x42 returned 0 after 2 usecs
[    0.365899] calling  init_devpts_fs+0x0/0x4c @ 1
[    0.365916] initcall init_devpts_fs+0x0/0x4c returned 0 after 12 usecs
[    0.365922] calling  init_ramfs_fs+0x0/0x12 @ 1
[    0.365927] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    0.365933] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    0.366000] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 60 usecs
[    0.366007] calling  init_fat_fs+0x0/0x4f @ 1
[    0.366130] initcall init_fat_fs+0x0/0x4f returned 0 after 115 usecs
[    0.366137] calling  init_vfat_fs+0x0/0x12 @ 1
[    0.366143] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    0.366149] calling  init_msdos_fs+0x0/0x12 @ 1
[    0.366154] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    0.366159] calling  init_iso9660_fs+0x0/0x71 @ 1
[    0.366228] initcall init_iso9660_fs+0x0/0x71 returned 0 after 61 usecs
[    0.366235] calling  init_nfs_fs+0x0/0x131 @ 1
[    0.366457] initcall init_nfs_fs+0x0/0x131 returned 0 after 211 usecs
[    0.366468] calling  init_nlm+0x0/0x22 @ 1
[    0.366485] initcall init_nlm+0x0/0x22 returned 0 after 11 usecs
[    0.366491] calling  init_nls_cp437+0x0/0x12 @ 1
[    0.366497] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    0.366502] calling  init_nls_ascii+0x0/0x12 @ 1
[    0.366507] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    0.366512] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    0.366517] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    0.366523] calling  init_nls_utf8+0x0/0x29 @ 1
[    0.366528] initcall init_nls_utf8+0x0/0x29 returned 0 after 0 usecs
[    0.366533] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    0.366537] NTFS driver 2.1.30 [Flags: R/W].
[    0.366657] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 115 usecs
[    0.366664] calling  init_autofs4_fs+0x0/0x26 @ 1
[    0.366714] initcall init_autofs4_fs+0x0/0x26 returned 0 after 43 usecs
[    0.366720] calling  ipc_init+0x0/0x23 @ 1
[    0.366729] msgmni has been set to 1986
[    0.366736] initcall ipc_init+0x0/0x23 returned 0 after 10 usecs
[    0.366742] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    0.366763] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 15 usecs
[    0.366769] calling  init_mqueue_fs+0x0/0xc8 @ 1
[    0.366850] initcall init_mqueue_fs+0x0/0xc8 returned 0 after 73 usecs
[    0.366857] calling  key_proc_init+0x0/0x59 @ 1
[    0.366865] initcall key_proc_init+0x0/0x59 returned 0 after 3 usecs
[    0.366870] calling  selinux_nf_ip_init+0x0/0x62 @ 1
[    0.366875] SELinux:  Registering netfilter hooks
[    0.366880] initcall selinux_nf_ip_init+0x0/0x62 returned 0 after 4 usecs
[    0.366886] calling  init_sel_fs+0x0/0x68 @ 1
[    0.366975] initcall init_sel_fs+0x0/0x68 returned 0 after 81 usecs
[    0.366995] calling  selnl_init+0x0/0x4d @ 1
[    0.367005] initcall selnl_init+0x0/0x4d returned 0 after 4 usecs
[    0.367011] calling  sel_netif_init+0x0/0x66 @ 1
[    0.367020] initcall sel_netif_init+0x0/0x66 returned 0 after 2 usecs
[    0.367026] calling  sel_netnode_init+0x0/0x74 @ 1
[    0.367034] initcall sel_netnode_init+0x0/0x74 returned 0 after 1 usecs
[    0.367040] calling  sel_netport_init+0x0/0x74 @ 1
[    0.367047] initcall sel_netport_init+0x0/0x74 returned 0 after 1 usecs
[    0.367053] calling  aurule_init+0x0/0x37 @ 1
[    0.367053] initcall aurule_init+0x0/0x37 returned 0 after 0 usecs
[    0.367053] calling  crypto_wq_init+0x0/0x31 @ 1
[    0.367141] initcall crypto_wq_init+0x0/0x31 returned 0 after 66 usecs
[    0.367152] calling  crypto_algapi_init+0x0/0xd @ 1
[    0.367161] initcall crypto_algapi_init+0x0/0xd returned 0 after 2 usecs
[    0.367167] calling  skcipher_module_init+0x0/0x39 @ 1
[    0.367173] initcall skcipher_module_init+0x0/0x39 returned 0 after 0 usecs
[    0.367180] calling  chainiv_module_init+0x0/0x12 @ 1
[    0.367186] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.367193] calling  eseqiv_module_init+0x0/0x12 @ 1
[    0.367199] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.367205] calling  hmac_module_init+0x0/0x12 @ 1
[    0.367211] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.367217] calling  md5_mod_init+0x0/0x12 @ 1
[    0.367250] initcall md5_mod_init+0x0/0x12 returned 0 after 25 usecs
[    0.367256] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    0.367289] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 26 usecs
[    0.367297] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    0.367304] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.367311] calling  des_generic_mod_init+0x0/0x3f @ 1
[    0.367369] initcall des_generic_mod_init+0x0/0x3f returned 0 after 50 usecs
[    0.367377] calling  zlib_mod_init+0x0/0x12 @ 1
[    0.367409] initcall zlib_mod_init+0x0/0x12 returned 0 after 26 usecs
[    0.367416] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    0.367423] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.367430] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    0.367437] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.367444] calling  krng_mod_init+0x0/0x12 @ 1
[    0.367484] initcall krng_mod_init+0x0/0x12 returned 0 after 33 usecs
[    0.367490] calling  proc_genhd_init+0x0/0x3c @ 1
[    0.367499] initcall proc_genhd_init+0x0/0x3c returned 0 after 3 usecs
[    0.367504] calling  bsg_init+0x0/0x12e @ 1
[    0.367624] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.367634] initcall bsg_init+0x0/0x12e returned 0 after 121 usecs
[    0.367641] calling  noop_init+0x0/0x14 @ 1
[    0.367646] io scheduler noop registered
[    0.367651] initcall noop_init+0x0/0x14 returned 0 after 5 usecs
[    0.367658] calling  deadline_init+0x0/0x14 @ 1
[    0.367663] io scheduler deadline registered
[    0.367669] initcall deadline_init+0x0/0x14 returned 0 after 5 usecs
[    0.367676] calling  cfq_init+0x0/0x9e @ 1
[    0.367750] io scheduler cfq registered (default)
[    0.367758] initcall cfq_init+0x0/0x9e returned 0 after 74 usecs
[    0.367765] calling  percpu_counter_startup+0x0/0x33 @ 1
[    0.367772] initcall percpu_counter_startup+0x0/0x33 returned 0 after 0 usecs
[    0.367779] calling  pci_proc_init+0x0/0x6a @ 1
[    0.367790] initcall pci_proc_init+0x0/0x6a returned 0 after 4 usecs
[    0.367797] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    0.367894] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 88 usecs
[    0.367905] calling  aer_service_init+0x0/0x22 @ 1
[    0.367951] initcall aer_service_init+0x0/0x22 returned 0 after 38 usecs
[    0.367959] calling  ioapic_init+0x0/0x1b @ 1
[    0.368008] initcall ioapic_init+0x0/0x1b returned 0 after 41 usecs
[    0.368016] calling  pci_hotplug_init+0x0/0x1d @ 1
[    0.368021] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.368028] initcall pci_hotplug_init+0x0/0x1d returned 0 after 5 usecs
[    0.368034] calling  pcifront_init+0x0/0x5e @ 1
[    0.368134] initcall pcifront_init+0x0/0x5e returned 0 after 91 usecs
[    0.368140] calling  genericbl_init+0x0/0x12 @ 1
[    0.368182] initcall genericbl_init+0x0/0x12 returned 0 after 34 usecs
[    0.368188] calling  cirrusfb_init+0x0/0xc6 @ 1
[    0.368230] initcall cirrusfb_init+0x0/0xc6 returned 0 after 35 usecs
[    0.368237] calling  efifb_init+0x0/0x1f5 @ 1
[    0.368243] initcall efifb_init+0x0/0x1f5 returned -19 after 1 usecs
[    0.368249] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.368254] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 usecs
[    0.368260] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.368265] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 0 usecs
[    0.368270] calling  acpi_ac_init+0x0/0x28 @ 1
[    0.368275] initcall acpi_ac_init+0x0/0x28 returned -19 after 0 usecs
[    0.368280] calling  acpi_button_init+0x0/0x56 @ 1
[    0.368289] initcall acpi_button_init+0x0/0x56 returned -19 after 3 usecs
[    0.368294] calling  acpi_fan_init+0x0/0x18 @ 1
[    0.368299] initcall acpi_fan_init+0x0/0x18 returned -19 after 0 usecs
[    0.368305] calling  acpi_processor_init+0x0/0xcd @ 1
[    0.368310] initcall acpi_processor_init+0x0/0xcd returned 0 after 0 usecs
[    0.368315] calling  acpi_container_init+0x0/0x4a @ 1
[    0.368320] initcall acpi_container_init+0x0/0x4a returned -19 after 0 usecs
[    0.368326] calling  acpi_thermal_init+0x0/0x42 @ 1
[    0.368331] initcall acpi_thermal_init+0x0/0x42 returned -19 after 0 usecs
[    0.368337] calling  acpi_battery_init+0x0/0x16 @ 1
[    0.368343] initcall acpi_battery_init+0x0/0x16 returned 0 after 1 usecs
[    0.368351] calling  init+0x0/0x12 @ 1
[    0.368367] calling  1_acpi_battery_init_async+0x0/0x1b @ 5
[    0.368372] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 0 usecs
[    0.368409] initcall init+0x0/0x12 returned 0 after 51 usecs
[    0.368415] calling  xenbus_probe_initcall+0x0/0x37 @ 1
[    0.368420] initcall xenbus_probe_initcall+0x0/0x37 returned 0 after 0 usecs
[    0.368426] calling  pciback_init+0x0/0x136 @ 1
[    0.368431] initcall pciback_init+0x0/0x136 returned -19 after 0 usecs
[    0.368436] calling  gntdev_init+0x0/0x4c @ 1
[    0.368484] initcall gntdev_init+0x0/0x4c returned 0 after 41 usecs
[    0.368491] calling  gntalloc_init+0x0/0x3d @ 1
[    0.368535] initcall gntalloc_init+0x0/0x3d returned 0 after 37 usecs
[    0.368541] calling  blkif_init+0x0/0x270 @ 1
[    0.368796] initcall blkif_init+0x0/0x270 returned 0 after 243 usecs
[    0.368805] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    0.368813] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    0.368819] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    0.368832] initcall hyper_sysfs_init+0x0/0xfb returned 0 after 8 usecs
[    0.368838] calling  pty_init+0x0/0x50d @ 1
[    0.397674] initcall pty_init+0x0/0x50d returned 0 after 28153 usecs
[    0.397691] calling  sysrq_init+0x0/0x54 @ 1
[    0.397701] initcall sysrq_init+0x0/0x54 returned 0 after 5 usecs
[    0.397706] calling  xen_hvc_init+0x0/0xc8 @ 1
[    0.398337] initcall xen_hvc_init+0x0/0xc8 returned 0 after 609 usecs
[    0.398350] calling  serial8250_init+0x0/0x183 @ 1
[    0.398355] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.398715] initcall serial8250_init+0x0/0x183 returned 0 after 350 usecs
[    0.398726] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    0.398769] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 35 usecs
[    0.398776] calling  serial8250_pci_init+0x0/0x1b @ 1
[    0.398819] initcall serial8250_pci_init+0x0/0x1b returned 0 after 36 usecs
[    0.398825] calling  init_kgdboc+0x0/0x16 @ 1
[    0.398830] initcall init_kgdboc+0x0/0x16 returned 0 after 0 usecs
[    0.398836] calling  rand_initialize+0x0/0x2c @ 1
[    0.398850] initcall rand_initialize+0x0/0x2c returned 0 after 8 usecs
[    0.398855] calling  hpet_init+0x0/0x6a @ 1
[    0.398966] initcall hpet_init+0x0/0x6a returned -19 after 103 usecs
[    0.398973] calling  nvram_init+0x0/0x82 @ 1
[    0.399028] Non-volatile memory driver v1.3
[    0.399034] initcall nvram_init+0x0/0x82 returned 0 after 54 usecs
[    0.399040] calling  mod_init+0x0/0x5a @ 1
[    0.399045] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    0.399053] calling  agp_init+0x0/0x26 @ 1
[    0.399055] Linux agpgart interface v0.103
[    0.399055] initcall agp_init+0x0/0x26 returned 0 after 4 usecs
[    0.399055] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    0.399284] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 206 usecs
[    0.399293] calling  agp_intel_init+0x0/0x29 @ 1
[    0.399340] initcall agp_intel_init+0x0/0x29 returned 0 after 40 usecs
[    0.399349] calling  agp_sis_init+0x0/0x29 @ 1
[    0.399397] initcall agp_sis_init+0x0/0x29 returned 0 after 41 usecs
[    0.399405] calling  agp_via_init+0x0/0x29 @ 1
[    0.399452] initcall agp_via_init+0x0/0x29 returned 0 after 39 usecs
[    0.399459] calling  drm_core_init+0x0/0x132 @ 1
[    0.399518] [drm] Initialized drm 1.1.0 20060810
[    0.399526] initcall drm_core_init+0x0/0x132 returned 0 after 58 usecs
[    0.399532] calling  cn_proc_init+0x0/0x3d @ 1
[    0.399539] initcall cn_proc_init+0x0/0x3d returned 0 after 0 usecs
[    0.399546] calling  topology_sysfs_init+0x0/0x50 @ 1
[    0.399557] initcall topology_sysfs_init+0x0/0x50 returned 0 after 4 usecs
[    0.399564] calling  brd_init+0x0/0x1a5 @ 1
[    0.401443] brd: module loaded
[    0.401459] initcall brd_init+0x0/0x1a5 returned 0 after 1844 usecs
[    0.401464] calling  loop_init+0x0/0x1b2 @ 1
[    0.402337] loop: module loaded
[    0.402345] initcall loop_init+0x0/0x1b2 returned 0 after 855 usecs
[    0.402354] calling  mac_hid_init+0x0/0x22 @ 1
[    0.402367] initcall mac_hid_init+0x0/0x22 returned 0 after 8 usecs
[    0.402373] calling  fixed_mdio_bus_init+0x0/0x105 @ 1
[    0.402477] Fixed MDIO Bus: probed
[    0.402485] initcall fixed_mdio_bus_init+0x0/0x105 returned 0 after 103 usecs
[    0.402492] calling  tg3_init+0x0/0x1b @ 1
[    0.402543] initcall tg3_init+0x0/0x1b returned 0 after 44 usecs
[    0.402551] calling  net_olddevs_init+0x0/0x9e @ 1
[    0.402561] initcall net_olddevs_init+0x0/0x9e returned 0 after 3 usecs
[    0.402567] calling  init_nic+0x0/0x1b @ 1
[    0.402617] initcall init_nic+0x0/0x1b returned 0 after 43 usecs
[    0.402624] calling  netback_init+0x0/0x251 @ 1
[    0.402714] initcall netback_init+0x0/0x251 returned 0 after 81 usecs
[    0.402722] calling  tun_init+0x0/0x93 @ 1
[    0.402727] tun: Universal TUN/TAP device driver, 1.6
[    0.402732] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.402811] initcall tun_init+0x0/0x93 returned 0 after 80 usecs
[    0.402819] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    0.402827] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 2 usecs
[    0.402840] calling  yenta_socket_init+0x0/0x1b @ 1
[    0.402886] initcall yenta_socket_init+0x0/0x1b returned 0 after 39 usecs
[    0.402893] calling  mon_init+0x0/0x114 @ 1
[    0.402990] initcall mon_init+0x0/0x114 returned 0 after 89 usecs
[    0.402997] calling  ehci_hcd_init+0x0/0xe9 @ 1
[    0.403001] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.403007] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    0.403213] initcall ehci_hcd_init+0x0/0xe9 returned 0 after 205 usecs
[    0.403222] calling  ohci_hcd_mod_init+0x0/0xba @ 1
[    0.403227] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.403233] ohci_hcd: block sizes: ed 80 td 96
[    0.403291] initcall ohci_hcd_mod_init+0x0/0xba returned 0 after 61 usecs
[    0.403300] calling  uhci_hcd_init+0x0/0x103 @ 1
[    0.403306] uhci_hcd: USB Universal Host Controller Interface driver
[    0.403371] initcall uhci_hcd_init+0x0/0x103 returned 0 after 62 usecs
[    0.403379] calling  usblp_init+0x0/0x1b @ 1
[    0.403430] usbcore: registered new interface driver usblp
[    0.403438] initcall usblp_init+0x0/0x1b returned 0 after 51 usecs
[    0.403445] calling  usb_usual_init+0x0/0x3d @ 1
[    0.403495] usbcore: registered new interface driver libusual
[    0.403503] initcall usb_usual_init+0x0/0x3d returned 0 after 50 usecs
[    0.403510] calling  kgdbdbgp_start_thread+0x0/0x4c @ 1
[    0.403516] initcall kgdbdbgp_start_thread+0x0/0x4c returned 0 after 0 usecs
[    0.403523] calling  i8042_init+0x0/0x39f @ 1
[    0.403684] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.404055] i8042: No controller found
[    0.404055] initcall i8042_init+0x0/0x39f returned -19 after 964 usecs
[    0.404055] calling  serport_init+0x0/0x34 @ 1
[    0.404055] initcall serport_init+0x0/0x34 returned 0 after 0 usecs
[    0.404055] calling  mousedev_init+0x0/0x62 @ 1
[    0.404616] mousedev: PS/2 mouse device common for all mice
[    0.404623] initcall mousedev_init+0x0/0x62 returned 0 after 81 usecs
[    0.404629] calling  evdev_init+0x0/0x12 @ 1
[    0.404634] initcall evdev_init+0x0/0x12 returned 0 after 0 usecs
[    0.404639] calling  atkbd_init+0x0/0x27 @ 1
[    0.404686] initcall atkbd_init+0x0/0x27 returned 0 after 40 usecs
[    0.404693] calling  psmouse_init+0x0/0x79 @ 1
[    0.404760] initcall psmouse_init+0x0/0x79 returned 0 after 59 usecs
[    0.404767] calling  cmos_init+0x0/0x6a @ 1
[    0.464855] BUG: unable to handle kernel NULL pointer dereference at 0000000000000428
[    0.464867] IP: [<ffffffff8105d347>] queue_work_on+0x4/0x1d
[    0.464874] PGD 0 
[    0.464879] Oops: 0002 [#1] SMP 
[    0.464884] last sysfs file: 
[    0.464889] CPU 0 
[    0.464892] Modules linked in:
[    0.464897] 
[    0.464900] Pid: 1, comm: swapper Not tainted 2.6.38-05793-g5996613 #12  
[    0.464909] RIP: e030:[<ffffffff8105d347>]  [<ffffffff8105d347>] queue_work_on+0x4/0x1d
[    0.464917] RSP: e02b:ffff88003f9b79e0  EFLAGS: 00010006
[    0.464921] RAX: ffff88003f9a6e40 RBX: ffffffff81a29d90 RCX: 000000000000000a
[    0.464926] RDX: 0000000000000428 RSI: ffff88003f9a6e40 RDI: 0000000000000000
[    0.464931] RBP: ffff88003f9b79e0 R08: 00000000000000a5 R09: fffffff186b1c025
[    0.464937] R10: 0000000000001613 R11: 00000000000b803d R12: 00000000ffffffd0
[    0.464942] R13: ffffffff81a29dff R14: 0000000000000014 R15: ffff88003f9b7b47
[    0.464949] FS:  0000000000000000(0000) GS:ffff88003ffc4000(0000) knlGS:0000000000000000
[    0.464955] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.464960] CR2: 0000000000000428 CR3: 0000000001803000 CR4: 0000000000000660
[    0.464965] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.464971] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.464976] Process swapper (pid: 1, threadinfo ffff88003f9b6000, task ffff88003f9b8000)
[    0.464982] Stack:
[    0.464985]  ffff88003f9b79f0 ffffffff8105d38f ffff88003f9b7a00 ffffffff8105d3a4
[    0.464996]  ffff88003f9b7a10 ffffffff81331b2e ffff88003f9b7a40 ffffffff81333939
[    0.465006]  0000000000000224 00000000000000df ffffffff81a29d20 ffffffff81a29d90
[    0.465018] Call Trace:
[    0.465023]  [<ffffffff8105d38f>] queue_work+0x1a/0x1c
[    0.465029]  [<ffffffff8105d3a4>] schedule_work+0x13/0x15
[    0.465035]  [<ffffffff81331b2e>] rtc_update_irq+0x10/0x12
[    0.465041]  [<ffffffff81333939>] cmos_checkintr+0x4d/0x55
[    0.465047]  [<ffffffff81333987>] cmos_irq_disable+0x46/0x4e
[    0.465051]  [<ffffffff8133481d>] cmos_set_alarm+0xd9/0x16e
[    0.465051]  [<ffffffff813320a4>] __rtc_set_alarm+0x7d/0x88
[    0.465051]  [<ffffffff813321fa>] rtc_timer_enqueue+0x71/0xb8
[    0.465051]  [<ffffffff81331707>] ? rtc_tm_to_time+0x2f/0x38
[    0.465051]  [<ffffffff81332479>] rtc_set_alarm+0x8e/0xa9
[    0.465051]  [<ffffffff81331a15>] rtc_device_register+0x220/0x303
[    0.465051]  [<ffffffff813343f8>] cmos_do_probe+0x116/0x355
[    0.465051]  [<ffffffff818c998c>] cmos_platform_probe+0x46/0x4f
[    0.465051]  [<ffffffff812c29b1>] platform_drv_probe+0x12/0x14
[    0.465051]  [<ffffffff812c188b>] driver_probe_device+0xa7/0x136
[    0.465051]  [<ffffffff812c1972>] __driver_attach+0x58/0x7c
[    0.465051]  [<ffffffff812c191a>] ? __driver_attach+0x0/0x7c
[    0.465051]  [<ffffffff812c0eba>] bus_for_each_dev+0x4e/0x83
[    0.465051]  [<ffffffff812c16d6>] driver_attach+0x19/0x1b
[    0.465051]  [<ffffffff812c133f>] bus_add_driver+0xb1/0x1fe
[    0.465051]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465051]  [<ffffffff812c1eed>] driver_register+0x99/0x10a
[    0.465051]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465051]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465051]  [<ffffffff812c2e8a>] platform_driver_register+0x41/0x43
[    0.465051]  [<ffffffff812c2ea8>] platform_driver_probe+0x1c/0x91
[    0.465051]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465051]  [<ffffffff818c9918>] cmos_init+0x3c/0x6a
[    0.465051]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465051]  [<ffffffff81002058>] do_one_initcall+0x52/0x134
[    0.465051]  [<ffffffff818946fb>] kernel_init+0x15d/0x1e2
[    0.465051]  [<ffffffff81466364>] kernel_thread_helper+0x4/0x10
[    0.465051]  [<ffffffff81465773>] ? int_ret_from_sys_call+0x7/0x1b
[    0.465051]  [<ffffffff8145f1e1>] ? retint_restore_args+0x5/0x6
[    0.465051]  [<ffffffff81466360>] ? kernel_thread_helper+0x0/0x10
[    0.465051] Code: 8b 0f 31 c0 48 89 fa 48 89 e5 f6 c1 04 74 05 48 89 c8 30 c0 48 8b 70 08 65 8b 3c 25 a0 db 00 00 e8 9f fc ff ff c9 c3 55 48 89 e5 <3e> 0f ba 2a 00 19 c9 31 c0 85 c9 75 0a e8 87 fc ff ff b8 01 00 
[    0.465051] RIP  [<ffffffff8105d347>] queue_work_on+0x4/0x1d
[    0.465051]  RSP <ffff88003f9b79e0>
[    0.465051] CR2: 0000000000000428
[    0.465051] ---[ end trace c9e84eed4649a430 ]---
[    0.465352] swapper used greatest stack depth: 4088 bytes left
[    0.465364] Kernel panic - not syncing: Attempted to kill init!
[    0.465370] Pid: 1, comm: swapper Tainted: G      D     2.6.38-05793-g5996613 #12
[    0.465375] Call Trace:
[    0.465380]  [<ffffffff8145d007>] ? panic+0x8c/0x195
[    0.465386]  [<ffffffff8104b525>] ? do_exit+0x76/0x7aa
[    0.465391]  [<ffffffff81048411>] ? kmsg_dump+0x44/0xea
[    0.465397]  [<ffffffff8145ff9f>] ? oops_end+0xbf/0xc7
[    0.465403]  [<ffffffff81030d47>] ? no_context+0x1f7/0x206
[    0.465412]  [<ffffffff810c0f0f>] ? get_page_from_freelist+0x443/0x726
[    0.465418]  [<ffffffff81006d02>] ? check_events+0x12/0x20
[    0.465424]  [<ffffffff81030ede>] ? __bad_area_nosemaphore+0x188/0x1ab
[    0.465430]  [<ffffffff810066b5>] ? xen_force_evtchn_callback+0xd/0xf
[    0.465436]  [<ffffffff81030f0f>] ? bad_area_nosemaphore+0xe/0x10
[    0.465442]  [<ffffffff81461eaf>] ? do_page_fault+0x1c6/0x386
[    0.465448]  [<ffffffff81006cef>] ? xen_restore_fl_direct_end+0x0/0x1
[    0.465454]  [<ffffffff810c0f0f>] ? get_page_from_freelist+0x443/0x726
[    0.465460]  [<ffffffff81006cef>] ? xen_restore_fl_direct_end+0x0/0x1
[    0.465466]  [<ffffffff810c0f0f>] ? get_page_from_freelist+0x443/0x726
[    0.465473]  [<ffffffff81006d02>] ? check_events+0x12/0x20
[    0.465478]  [<ffffffff8145f455>] ? page_fault+0x25/0x30
[    0.465484]  [<ffffffff8105d347>] ? queue_work_on+0x4/0x1d
[    0.465489]  [<ffffffff8105d38f>] ? queue_work+0x1a/0x1c
[    0.465494]  [<ffffffff8105d3a4>] ? schedule_work+0x13/0x15
[    0.465500]  [<ffffffff81331b2e>] ? rtc_update_irq+0x10/0x12
[    0.465506]  [<ffffffff81333939>] ? cmos_checkintr+0x4d/0x55
[    0.465512]  [<ffffffff81333987>] ? cmos_irq_disable+0x46/0x4e
[    0.465518]  [<ffffffff8133481d>] ? cmos_set_alarm+0xd9/0x16e
[    0.465524]  [<ffffffff813320a4>] ? __rtc_set_alarm+0x7d/0x88
[    0.465530]  [<ffffffff813321fa>] ? rtc_timer_enqueue+0x71/0xb8
[    0.465536]  [<ffffffff81331707>] ? rtc_tm_to_time+0x2f/0x38
[    0.465542]  [<ffffffff81332479>] ? rtc_set_alarm+0x8e/0xa9
[    0.465548]  [<ffffffff81331a15>] ? rtc_device_register+0x220/0x303
[    0.465554]  [<ffffffff813343f8>] ? cmos_do_probe+0x116/0x355
[    0.465560]  [<ffffffff818c998c>] ? cmos_platform_probe+0x46/0x4f
[    0.465566]  [<ffffffff812c29b1>] ? platform_drv_probe+0x12/0x14
[    0.465572]  [<ffffffff812c188b>] ? driver_probe_device+0xa7/0x136
[    0.465578]  [<ffffffff812c1972>] ? __driver_attach+0x58/0x7c
[    0.465584]  [<ffffffff812c191a>] ? __driver_attach+0x0/0x7c
[    0.465590]  [<ffffffff812c0eba>] ? bus_for_each_dev+0x4e/0x83
[    0.465596]  [<ffffffff812c16d6>] ? driver_attach+0x19/0x1b
[    0.465602]  [<ffffffff812c133f>] ? bus_add_driver+0xb1/0x1fe
[    0.465607]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465613]  [<ffffffff812c1eed>] ? driver_register+0x99/0x10a
[    0.465619]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465624]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465630]  [<ffffffff812c2e8a>] ? platform_driver_register+0x41/0x43
[    0.465636]  [<ffffffff812c2ea8>] ? platform_driver_probe+0x1c/0x91
[    0.465642]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465648]  [<ffffffff818c9918>] ? cmos_init+0x3c/0x6a
[    0.465654]  [<ffffffff818c98dc>] ? cmos_init+0x0/0x6a
[    0.465659]  [<ffffffff81002058>] ? do_one_initcall+0x52/0x134
[    0.465664]  [<ffffffff818946fb>] ? kernel_init+0x15d/0x1e2
[    0.465670]  [<ffffffff81466364>] ? kernel_thread_helper+0x4/0x10
[    0.465676]  [<ffffffff81465773>] ? int_ret_from_sys_call+0x7/0x1b
[    0.465682]  [<ffffffff8145f1e1>] ? retint_restore_args+0x5/0x6
[    0.465687]  [<ffffffff81466360>] ? kernel_thread_helper+0x0/0x10

