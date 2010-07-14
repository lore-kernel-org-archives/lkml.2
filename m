Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0GNVWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690Ab0GNVWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:22:11 -0400
Date: Wed, 14 Jul 2010 23:22:01 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100714232201.00433aa9@hammerfall>
In-Reply-To: <20100714160704.GA10473@kryptos.osrc.amd.com>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
	<20100713185957.2866.50995.stgit@localhost.localdomain>
	<20100714160704.GA10473@kryptos.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 18:07:05 +0200 Borislav Petkov wrote:
> I don't think that the workaround is wrong, assuming I'm not missing
> something. I'm seeing the following sequence on my machine here in
> which the cores are brought up and checked for c1e:
> 
> The BSP does
> 
> start_kernel()
> |->check_bugs()
>    |->identify_boot_cpu() 	# here we do select_idle_routine(),
> i.e. pm_idle = c1e_idle ...
> |->rest_init()
>    |->kernel_thread(kernel_init,... )
> 
> and kernel_init() does smp_init() where we init the rest of the cores.
> 
> Now, each core does
> 
> start_secondary()
> |->smp_callin()
>    |->smp_store_cpu_info	# here we copy boot_cpu_data for the
> starting AP |->identify_secondary_cpu
>         |->identify_cpu
> 	   |->select_idle_routine() # here we exit early since
> pm_idle is set already
> 
> 
> now all the cores except the BSP do cpu_idle but since bits 27,28 in
> the int pending MSR (see below) are not set yet, they spin a bit in
> cpu_idle doing default_idle. You can see this with my debugging patch
> below.

On my system I see bit 28 set right at the start. Is it a BIOS bug?
Your debugging patch produces a huge flood of messages, seemingly
neverending.

> Now here comes the key moment - the BSP enters cpu_idle _after_ all
> APs have been initialized and does set X86_FEATURE_AMDC1E. We haven't
> set the c1e_detected variable earlier since the hardware sets bit 28
> in MSR_K8_INT_PENDING_MSG, C1eOnCmpHalt only after all cores have
> entered halt. After this bit is set, we set c1e_detected and switch
> to broadcast mode on each core.
> 
> Now the question is, why does your system doesn't do that in that
> order? And I don't think your patch is the right fix - it doesn't
> change anything in the above sequence on my system except enabling
> the "amdc1e" feature string in /proc/cpuinfo which we don't need
> actually since dmesg already contains that info.

I would not bother using the patch if the only result would be showing
of the "amdc1e" misfeature string in /proc/cpuinfo :-)

> And the more puzzling question is, how does your patch fix your
> system...?

It makes sure that once "boot_cpu_has(X86_FEATURE_AMDC1E)" is true, it
won't ever become false.
To see what I mean see the dmesg I've got with a bit different debugging
patch:

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index aa2c39d..39b8348 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -123,6 +123,9 @@ extern void acpi_reserve_wakeup_memory(void);
  */
 static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 {
+
+	pr_err("%s: enter\n", __func__);
+
 	/*
 	 * Early models (<=5) of AMD Opterons are not supposed to go into
 	 * C2 state.
@@ -134,10 +137,14 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
-	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	else if (boot_cpu_has(X86_FEATURE_AMDC1E)) {
+		pr_err("%s: C1E\n", __func__);
 		return 1;
-	else
+	}
+	else {
+		pr_err("%s: max_cstate: %d\n", __func__, max_cstate);
 		return max_cstate;
+	}
 }
 
 static inline bool arch_has_acpi_pdc(void)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 68e4a6f..cdab554 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -741,6 +741,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
+	extern int c1e_detected;
 
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
@@ -829,6 +830,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		c->x86_capability[i] |= cpu_caps_set[i];
 	}
 
+	pr_err("%s: before ANDing, c1e_detected: %d, boot_cpu_has(C1E): %d\n",
+		__func__, c1e_detected, boot_cpu_has(X86_FEATURE_AMDC1E));
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -840,6 +843,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		for (i = 0; i < NCAPINTS; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
+	pr_err("%s:  after ANDing, c1e_detected: %d, boot_cpu_has(C1E): %d\n",
+		__func__, c1e_detected, boot_cpu_has(X86_FEATURE_AMDC1E));
 
 	/* Init Machine Check Exception if available. */
 	mcheck_cpu_init(c);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3521..4235703 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -562,7 +562,7 @@ no_c1e_idle:
 }
 
 static cpumask_var_t c1e_mask;
-static int c1e_detected;
+int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
@@ -584,6 +584,13 @@ static void c1e_idle(void)
 		u32 lo, hi;
 
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
+		pr_err("%s: cpu: %d, bits 0x%08x, "
+		       "c1e_detected: %d, boot_cpu_has(C1E): %d\n",
+			__func__, raw_smp_processor_id(),
+			lo & K8_INTP_C1E_ACTIVE_MASK, c1e_detected,
+			boot_cpu_has(X86_FEATURE_AMDC1E));
+
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
 			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))

Here's the dmesg:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.35-rc5+ (michich@hammerfall) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #28 SMP Wed Jul 14 22:45:41 CEST 2010
Command line: root=/dev/mapper/hammervg-F11root ro SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us sysrq_always_enabled fbcon=map:0 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009b000 (usable)
 BIOS-e820: 000000000009b000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000afd90000 (usable)
 BIOS-e820: 00000000afd90000 - 00000000afda8000 (ACPI data)
 BIOS-e820: 00000000afda8000 - 00000000afdd0000 (ACPI NVS)
 BIOS-e820: 00000000afdd0000 - 00000000afe00000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
NX (Execute Disable) protection: active
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x150000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFE0000000 write-back
  2 base 0000A0000000 mask FFFFF0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000150000000 aka 5376M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000b0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xafd90 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000ff780] ff780
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000afd90000
 0000000000 - 0080000000 page 1G
 0080000000 - 00afc00000 page 2M
 00afc00000 - 00afd90000 page 4k
kernel direct mapping tables up to afd90000 @ 16000-19000
init_memory_mapping: 0000000100000000-0000000150000000
 0100000000 - 0140000000 page 1G
 0140000000 - 0150000000 page 2M
kernel direct mapping tables up to 150000000 @ 18000-1a000
RAMDISK: 37254000 - 37ff0000
ACPI: RSDP 00000000000fbad0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000afd90100 00064 (v01 051710 XSDT1915 20100517 MSFT 00000097)
ACPI: FACP 00000000afd90290 000F4 (v03 051710 FACP1915 20100517 MSFT 00000097)
ACPI: DSDT 00000000afd90460 0F13B (v01  A1656 A1656000 00000000 INTL 20060113)
ACPI: FACS 00000000afda8000 00040
ACPI: APIC 00000000afd90390 00088 (v01 051710 APIC1915 20100517 MSFT 00000097)
ACPI: MCFG 00000000afd90420 0003C (v01 051710 OEMMCFG  20100517 MSFT 00000097)
ACPI: OEMB 00000000afda8040 00072 (v01 051710 OEMB1915 20100517 MSFT 00000097)
ACPI: SRAT 00000000afd9f8b0 00108 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
ACPI: HPET 00000000afd9f9c0 00038 (v01 051710 OEMHPET  20100517 MSFT 00000097)
ACPI: IVRS 00000000afd9fa00 000D8 (v01  AMD     RD890S 00202031 AMD  00000000)
ACPI: SSDT 00000000afd9fae0 00DA4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 0 -> APIC 0x02 -> Node 0
SRAT: PXM 0 -> APIC 0x03 -> Node 0
SRAT: PXM 0 -> APIC 0x04 -> Node 0
SRAT: PXM 0 -> APIC 0x05 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-b0000000
SRAT: Node 0 PXM 0 100000000-150000000
SRAT: Node 0 [0,a0000) + [100000,b0000000) -> [0,b0000000)
SRAT: Node 0 [0,b0000000) + [100000000,150000000) -> [0,150000000)
NUMA: Using 63 for the hash shift.
Initmem setup node 0 0000000000000000-0000000150000000
  NODE_DATA [0000000100000000 - 0000000100014fff]
  bootmap [0000000100015000 -  000000010003efff] pages 2a
(14/32 early reservations) ==> bootmem [0000000000 - 0150000000]
  #0 [0001000000 - 0002a33900]    TEXT DATA BSS ==> [0001000000 - 0002a33900]
  #1 [0037254000 - 0037ff0000]          RAMDISK ==> [0037254000 - 0037ff0000]
  #2 [0002a34000 - 0002a343bf]              BRK ==> [0002a34000 - 0002a343bf]
  #3 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
  #4 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
  #5 [000009b000 - 00000f06e0]    BIOS reserved ==> [000009b000 - 00000f06e0]
  #6 [00000f0914 - 00000ff780]    BIOS reserved ==> [00000f0914 - 00000ff780]
  #7 [00000f06e0 - 00000f0914]     MP-table mpc ==> [00000f06e0 - 00000f0914]
  #8 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
  #9 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
  #10 [0000016000 - 0000018000]          PGTABLE ==> [0000016000 - 0000018000]
  #11 [0000018000 - 0000019000]          PGTABLE ==> [0000018000 - 0000019000]
  #12 [0100000000 - 0100015000]        NODE_DATA ==> [0100000000 - 0100015000]
  #13 [0100015000 - 010003f000]          BOOTMAP ==> [0100015000 - 010003f000]
 [ffffea0000000000-ffffea00049fffff] PMD -> [ffff880100600000-ffff880103ffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00150000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009b
    0: 0x00000100 -> 0x000afd90
    0: 0x00100000 -> 0x00150000
On node 0 totalpages: 1047835
  DMA zone: 56 pages used for memmap
  DMA zone: 108 pages reserved
  DMA zone: 3815 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 701896 pages, LIFO batch:31
  Normal zone: 4480 pages used for memmap
  Normal zone: 323200 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
SMP: Allowing 6 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 72
PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
PM: Registered nosave memory: 00000000afd90000 - 00000000afda8000
PM: Registered nosave memory: 00000000afda8000 - 00000000afdd0000
PM: Registered nosave memory: 00000000afdd0000 - 00000000afe00000
PM: Registered nosave memory: 00000000afe00000 - 00000000ffe00000
PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
Allocating PCI resources starting at afe00000 (gap: afe00000:50000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:6 nr_node_ids:1
PERCPU: Embedded 478 pages/cpu @ffff880002c00000 s1927232 r8192 d22464 u2097152
pcpu-alloc: s1927232 r8192 d22464 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1028911
Policy zone: Normal
Kernel command line: root=/dev/mapper/hammervg-F11root ro SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us sysrq_always_enabled fbcon=map:0 3
sysrq: sysrq always enabled.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 3947060k/5505024k available (4584k kernel code, 1313684k absent, 244280k reserved, 7298k data, 2756k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU lockdep checking is enabled.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:33024 nr_irqs:1272
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 15 of 15 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3611.646 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6420.69 BogoMIPS (lpj=3210348)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
identify_cpu: before ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20100428
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20786 entries in 82 pages
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X6 1090T Processor stepping 00
lockdep: fixing up alternatives.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/sched.c:616 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
3 locks held by swapper/1:
 #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81051782>] cpu_maps_update_begin+0x17/0x19
 #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810517c7>] cpu_hotplug_begin+0x2c/0x53
 #2:  (&rq->lock){-.....}, at: [<ffffffff8146a2a5>] init_idle+0x30/0x136

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.35-rc5+ #28
Call Trace:
 [<ffffffff8107b382>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff8103efa5>] task_group+0x80/0x8f
 [<ffffffff8146a2a5>] ? init_idle+0x30/0x136
 [<ffffffff8103efcb>] set_task_rq+0x17/0x73
 [<ffffffff8146a364>] init_idle+0xef/0x136
 [<ffffffff8146a781>] fork_idle+0xbd/0xce
 [<ffffffff8107ba4b>] ? mark_held_locks+0x52/0x70
 [<ffffffff81468d66>] do_fork_idle+0x1c/0x2d
 [<ffffffff8146817f>] do_boot_cpu+0x145/0xa3b
 [<ffffffff8110ca08>] ? alloc_page_interleave+0x79/0x86
 [<ffffffff81468d4a>] ? do_fork_idle+0x0/0x2d
 [<ffffffff81468b70>] native_cpu_up+0xfb/0x1ce
 [<ffffffff8146a862>] _cpu_up+0xa0/0x115
 [<ffffffff8146a9ad>] cpu_up+0xd6/0xe8
 [<ffffffff81d73695>] kernel_init+0x105/0x231
 [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
 [<ffffffff81471ed0>] ? restore_args+0x0/0x30
 [<ffffffff81d73590>] ? kernel_init+0x0/0x231
 [<ffffffff8100aa60>] ? kernel_thread_helper+0x0/0x10
Booting Node   0, Processors  #1
identify_cpu: before ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
c1e_idle: cpu: 1, bits 0x10000000, c1e_detected: 0, boot_cpu_has(C1E): 0
lockdep: fixing up alternatives.
 #2
System has AMD C1E enabled
Switch to broadcast mode on CPU1
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 1
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Switch to broadcast mode on CPU2
lockdep: fixing up alternatives.
 #3
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Switch to broadcast mode on CPU3
lockdep: fixing up alternatives.
 #4
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Switch to broadcast mode on CPU4
lockdep: fixing up alternatives.
 #5 Ok.
identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
Brought up 6 CPUs
Switch to broadcast mode on CPU5
Total of 6 processors activated (38528.67 BogoMIPS).
Switch to broadcast mode on CPU0
devtmpfs: initialized
atomic64 test passed for x86-64 platform with CX8 and with SSE
Time: 20:54:48  Date: 07/14/10
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000b0000000 aka 2816M
Fam 10h mmconf [e0000000, efffffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, ffffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [b0000000, dfffffff]
TOM2: 0000000150000000 aka 5376M
bus: [00, 07] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0xf0000000-0xffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
bus: 00 index 3 [mem 0xb0000000-0xdfffffff]
bus: 00 index 4 [mem 0x150000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Error (dswload-0677): [PCI0] Namespace lookup failure, AE_NOT_FOUND
ACPI Exception: AE_NOT_FOUND, During name lookup/catalog (20100428/psloop-231)
ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff8298c190), AE_NOT_FOUND
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
ACPI: EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
ACPI Warning: Incorrect checksum in table [OEMB] - 0x18, should be 0x17 (20100428/tbutils-314)
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0xafe00000-0xdfffffff]
pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:11.0: reg 10: [io  0x9000-0x9007]
pci 0000:00:11.0: reg 14: [io  0x8000-0x8003]
pci 0000:00:11.0: reg 18: [io  0x7000-0x7007]
pci 0000:00:11.0: reg 1c: [io  0x6000-0x6003]
pci 0000:00:11.0: reg 20: [io  0x5000-0x500f]
pci 0000:00:11.0: reg 24: [mem 0xfe2fe000-0xfe2fe3ff]
pci 0000:00:12.0: reg 10: [mem 0xfe2f7000-0xfe2f7fff]
pci 0000:00:12.2: reg 10: [mem 0xfe2fe400-0xfe2fe4ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10: [mem 0xfe2fc000-0xfe2fcfff]
pci 0000:00:13.2: reg 10: [mem 0xfe2fe800-0xfe2fe8ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.2: reg 10: [mem 0xfe2f8000-0xfe2fbfff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:00:14.5: reg 10: [mem 0xfe2fd000-0xfe2fdfff]
pci 0000:00:16.0: reg 10: [mem 0xfe2ff000-0xfe2fffff]
pci 0000:00:16.2: reg 10: [mem 0xfe2fec00-0xfe2fecff]
pci 0000:00:16.2: supports D1 D2
pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:16.2: PME# disabled
pci 0000:07:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:07:00.0: reg 18: [mem 0xfe9f0000-0xfe9fffff 64bit]
pci 0000:07:00.0: reg 20: [io  0xe000-0xe0ff]
pci 0000:07:00.0: reg 30: [mem 0xfe9c0000-0xfe9dffff pref]
pci 0000:07:00.0: supports D1 D2
pci 0000:07:00.1: reg 10: [mem 0xfe9ec000-0xfe9effff 64bit]
pci 0000:07:00.1: supports D1 D2
pci 0000:00:02.0: PCI bridge to [bus 07-07]
pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:02.0:   bridge window [mem 0xfe900000-0xfe9fffff]
pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:06:00.0: reg 24: [mem 0xfe8fe000-0xfe8fffff]
pci 0000:06:00.0: PME# supported from D3hot
pci 0000:06:00.0: PME# disabled
pci 0000:06:00.1: reg 10: [io  0xdc00-0xdc07]
pci 0000:06:00.1: reg 14: [io  0xd880-0xd883]
pci 0000:06:00.1: reg 18: [io  0xd800-0xd807]
pci 0000:06:00.1: reg 1c: [io  0xd480-0xd483]
pci 0000:06:00.1: reg 20: [io  0xd400-0xd40f]
pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:04.0: PCI bridge to [bus 06-06]
pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:00.0: reg 10: [mem 0xfe7ff800-0xfe7fffff 64bit]
pci 0000:05:00.0: reg 18: [io  0xc800-0xc8ff]
pci 0000:05:00.0: supports D2
pci 0000:05:00.0: PME# supported from D2 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:00:05.0: PCI bridge to [bus 05-05]
pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:05.0:   bridge window [mem 0xfe700000-0xfe7fffff]
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: reg 10: [io  0xb800-0xb8ff]
pci 0000:04:00.0: reg 18: [mem 0xcffff000-0xcfffffff 64bit pref]
pci 0000:04:00.0: reg 20: [mem 0xcfff8000-0xcfffbfff 64bit pref]
pci 0000:04:00.0: reg 30: [mem 0xfe6e0000-0xfe6fffff pref]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:06.0: PCI bridge to [bus 04-04]
pci 0000:00:06.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:06.0:   bridge window [mem 0xfe600000-0xfe6fffff]
pci 0000:00:06.0:   bridge window [mem 0xcff00000-0xcfffffff 64bit pref]
pci 0000:03:00.0: reg 10: [mem 0xfe5fe000-0xfe5fffff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfe500000-0xfe5fffff]
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:00.0: reg 10: [mem 0xb0000000-0xbfffffff 64bit pref]
pci 0000:02:00.0: reg 18: [mem 0xfe4f0000-0xfe4fffff 64bit]
pci 0000:02:00.0: reg 20: [io  0xa000-0xa0ff]
pci 0000:02:00.0: reg 30: [mem 0xfe4c0000-0xfe4dffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.1: reg 10: [mem 0xfe4e0000-0xfe4effff 64bit]
pci 0000:02:00.1: supports D1 D2
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0b.0: PCI bridge to [bus 02-02]
pci 0000:00:0b.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:0b.0:   bridge window [mem 0xfe400000-0xfe4fffff]
pci 0000:00:0b.0:   bridge window [mem 0xb0000000-0xbfffffff 64bit pref]
pci 0000:01:06.0: reg 10: [mem 0xfe3fe000-0xfe3fffff]
pci 0000:01:06.0: supports D1 D2
pci 0000:01:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:06.0: PME# disabled
pci 0000:00:14.4: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:14.4:   bridge window [mem 0xfe300000-0xfe3fffff]
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xafe00000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC07._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC0B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0, disabled.
HEST: Table is not found!
vgaarb: device added: PCI:0000:07:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=none,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009b000 - 000000000009ffff 
reserve RAM buffer: 00000000afd90000 - 00000000afffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfec20000-0xfec200ff] could not be reserved
system 00:02: [mem 0xf6000000-0xf6003fff] has been reserved
system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0a: [io  0x04d0-0x04d1] has been reserved
system 00:0a: [io  0x040b] has been reserved
system 00:0a: [io  0x04d6] has been reserved
system 00:0a: [io  0x0c00-0x0c01] has been reserved
system 00:0a: [io  0x0c14] has been reserved
system 00:0a: [io  0x0c50-0x0c51] has been reserved
system 00:0a: [io  0x0c52] has been reserved
system 00:0a: [io  0x0c6c] has been reserved
system 00:0a: [io  0x0c6f] has been reserved
system 00:0a: [io  0x0cd0-0x0cd1] has been reserved
system 00:0a: [io  0x0cd2-0x0cd3] has been reserved
system 00:0a: [io  0x0cd4-0x0cd5] has been reserved
system 00:0a: [io  0x0cd6-0x0cd7] has been reserved
system 00:0a: [io  0x0cd8-0x0cdf] has been reserved
system 00:0a: [io  0x0800-0x089f] has been reserved
system 00:0a: [io  0x0b00-0x0b1f] has been reserved
system 00:0a: [io  0x0b20-0x0b3f] has been reserved
system 00:0a: [io  0x0900-0x090f] has been reserved
system 00:0a: [io  0x0910-0x091f] has been reserved
system 00:0a: [io  0xfe00-0xfefe] has been reserved
system 00:0a: [mem 0xafe00000-0xafefffff] has been reserved
system 00:0a: [mem 0xffb80000-0xffbfffff] has been reserved
system 00:0a: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:0a: [mem 0xfed80000-0xfed80fff] has been reserved
system 00:0d: [io  0x0230-0x023f] has been reserved
system 00:0d: [io  0x0290-0x029f] has been reserved
system 00:0d: [io  0x0f40-0x0f4f] has been reserved
system 00:0d: [io  0x0a30-0x0a3f] has been reserved
system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0f: [mem 0x000c0000-0x000cffff] has been reserved
system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0f: [mem 0x00100000-0xafdfffff] could not be reserved
system 00:0f: [mem 0xfec00000-0xffffffff] could not be reserved
pci 0000:00:02.0: PCI bridge to [bus 07-07]
pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:02.0:   bridge window [mem 0xfe900000-0xfe9fffff]
pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 06-06]
pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 05-05]
pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:05.0:   bridge window [mem 0xfe700000-0xfe7fffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 04-04]
pci 0000:00:06.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:06.0:   bridge window [mem 0xfe600000-0xfe6fffff]
pci 0000:00:06.0:   bridge window [mem 0xcff00000-0xcfffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem 0xfe500000-0xfe5fffff]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 02-02]
pci 0000:00:0b.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:0b.0:   bridge window [mem 0xfe400000-0xfe4fffff]
pci 0000:00:0b.0:   bridge window [mem 0xb0000000-0xbfffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 01-01]
pci 0000:00:14.4:   bridge window [io  disabled]
pci 0000:00:14.4:   bridge window [mem 0xfe300000-0xfe3fffff]
pci 0000:00:14.4:   bridge window [mem pref disabled]
  alloc irq_desc for 52 on node 0
  alloc kstat_irqs on node 0
pci 0000:00:02.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:04.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
pci 0000:00:05.0: setting latency timer to 64
  alloc irq_desc for 53 on node 0
  alloc kstat_irqs on node 0
pci 0000:00:06.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:07.0: setting latency timer to 64
  alloc irq_desc for 54 on node 0
  alloc kstat_irqs on node 0
pci 0000:00:0b.0: PCI INT A -> GSI 54 (level, low) -> IRQ 54
pci 0000:00:0b.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xafe00000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
pci_bus 0000:07: resource 1 [mem 0xfe900000-0xfe9fffff]
pci_bus 0000:07: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:06: resource 1 [mem 0xfe800000-0xfe8fffff]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xfe700000-0xfe7fffff]
pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:04: resource 1 [mem 0xfe600000-0xfe6fffff]
pci_bus 0000:04: resource 2 [mem 0xcff00000-0xcfffffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
pci_bus 0000:02: resource 1 [mem 0xfe400000-0xfe4fffff]
pci_bus 0000:02: resource 2 [mem 0xb0000000-0xbfffffff 64bit pref]
pci_bus 0000:01: resource 1 [mem 0xfe300000-0xfe3fffff]
pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:01: resource 8 [mem 0xafe00000-0xdfffffff]
pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 6, 327680 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
NET: Registered protocol family 1
pci 0000:07:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 13936k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
  alloc irq_desc for 55 on node 0
  alloc kstat_irqs on node 0
pci 0000:00:00.2: PCI INT A -> GSI 55 (level, low) -> IRQ 55
  alloc irq_desc for 72 on node 0
  alloc kstat_irqs on node 0
pci 0000:00:00.2: irq 72 for MSI/MSI-X
AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
AMD-Vi: Lazy IO/TLB flushing enabled
audit: initializing netlink socket (disabled)
type=2000 audit(1279140889.031:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7865
cryptomgr_test used greatest stack depth: 6088 bytes left
cryptomgr_test used greatest stack depth: 5936 bytes left
cryptomgr_test used greatest stack depth: 5736 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 73 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:02.0: irq 73 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
  alloc irq_desc for 74 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:04.0: irq 74 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
  alloc irq_desc for 75 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:05.0: irq 75 for MSI/MSI-X
pcieport 0000:00:06.0: setting latency timer to 64
  alloc irq_desc for 76 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:06.0: irq 76 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
  alloc irq_desc for 77 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:07.0: irq 77 for MSI/MSI-X
pcieport 0000:00:0b.0: setting latency timer to 64
  alloc irq_desc for 78 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0b.0: irq 78 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
acpi_processor_cstate_check: enter
acpi_processor_cstate_check: max_cstate: 8
ERST: Table is not found!
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
ahci 0000:00:11.0: version 3.0
  alloc irq_desc for 19 on node 0
  alloc kstat_irqs on node 0
ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
  alloc irq_desc for 79 on node 0
  alloc kstat_irqs on node 0
ahci 0000:00:11.0: irq 79 for MSI/MSI-X
ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfe2fe000 port 0xfe2fe100 irq 79
ata2: SATA max UDMA/133 abar m1024@0xfe2fe000 port 0xfe2fe180 irq 79
ata3: SATA max UDMA/133 abar m1024@0xfe2fe000 port 0xfe2fe200 irq 79
ata4: SATA max UDMA/133 abar m1024@0xfe2fe000 port 0xfe2fe280 irq 79
ata5: SATA max UDMA/133 abar m1024@0xfe2fe000 port 0xfe2fe300 irq 79
ata6: SATA max UDMA/133 abar m1024@0xfe2fe000 port 0xfe2fe380 irq 79
work_for_cpu used greatest stack depth: 5552 bytes left
  alloc irq_desc for 44 on node 0
  alloc kstat_irqs on node 0
ahci 0000:06:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
ahci 0000:06:00.0: JMB361 has only one port
ahci 0000:06:00.0: forcing port_map 0x3 -> 0x1
ahci 0000:06:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:06:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ahci 0000:06:00.0: setting latency timer to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe100 irq 44
ata8: DUMMY
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe2fe400
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-rc5+ ehci_hcd
usb usb1: SerialNumber: 0000:00:12.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
work_for_cpu used greatest stack depth: 4968 bytes left
ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 17, io mem 0xfe2fe800
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-rc5+ ehci_hcd
usb usb2: SerialNumber: 0000:00:13.2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 5 ports detected
ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:16.2: EHCI Host Controller
ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:16.2: debug port 1
ehci_hcd 0000:00:16.2: irq 17, io mem 0xfe2fec00
ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.35-rc5+ ehci_hcd
usb usb3: SerialNumber: 0000:00:16.2
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
  alloc irq_desc for 18 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.0: irq 18, io mem 0xfe2f7000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.35-rc5+ ohci_hcd
usb usb4: SerialNumber: 0000:00:12.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 5 ports detected
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe2fc000
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.35-rc5+ ohci_hcd
usb usb5: SerialNumber: 0000:00:13.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 5 ports detected
ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe2fd000
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.35-rc5+ ohci_hcd
usb usb6: SerialNumber: 0000:00:14.5
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
work_for_cpu used greatest stack depth: 4744 bytes left
ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:16.0: OHCI Host Controller
ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:16.0: irq 18, io mem 0xfe2ff000
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: OHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.35-rc5+ ohci_hcd
usb usb7: SerialNumber: 0000:00:16.0
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 4 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
  Magic number: 2:72:953
rtc_cmos 00:04: setting system clock to 2010-07-14 20:54:50 UTC (1279140890)
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
ata4: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST31000340AS, SD15, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST31000340AS     SD15 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
 sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
Freeing unused kernel memory: 2756k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1540k freed
Freeing unused kernel memory: 1832k freed
dracut: dracut-005-3.fc13
udev: starting version 151
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
  alloc irq_desc for 24 on node 0
  alloc kstat_irqs on node 0
radeon 0000:07:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
radeon 0000:07:00.0: setting latency timer to 64
[drm] initializing kernel modesetting (RV770 0x1002:0x9442).
[drm] register mmio base: 0xFE9F0000
[drm] register mmio size: 65536
ATOM BIOS: HD4850
[drm] Clocks initialized !
radeon 0000:07:00.0: VRAM: 1024M 0x00000000 - 0x3FFFFFFF (1024M used)
radeon 0000:07:00.0: GTT: 512M 0x40000000 - 0x5FFFFFFF
[drm] Detected VRAM RAM=1024M, BAR=256M
[drm] RAM width 256bits DDR
[TTM] Zone  kernel: Available graphics memory: 2016538 kiB.
[TTM] Initializing pool allocator.
[drm] radeon: 1024M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
  alloc irq_desc for 80 on node 0
  alloc kstat_irqs on node 0
radeon 0000:07:00.0: irq 80 for MSI/MSI-X
[drm] radeon: using MSI.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading RV770 Microcode
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Enabling audio support
[drm] Default TV standard: PAL
[drm] Default TV standard: PAL
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DVI-I
[drm]   HPD2
[drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[drm] Connector 1:
[drm]   HDMI-A
[drm]   HPD3
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY
[drm] Connector 2:
[drm]   VGA
[drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Internal thermal controller with fan control
[drm] radeon: power management initialized
[drm] fb mappable at 0xD0141000
[drm] vram apper at 0xD0000000
[drm] size 7258112
[drm] fb depth is 24
[drm]    pitch is 6912
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
Console: switching to colour frame buffer device 210x65
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] Initialized radeon 2.5.0 20080528 for 0000:07:00.0 on minor 0
work_for_cpu used greatest stack depth: 4040 bytes left
radeon 0000:02:00.0: enabling device (0000 -> 0003)
  alloc irq_desc for 32 on node 0
  alloc kstat_irqs on node 0
radeon 0000:02:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
radeon 0000:02:00.0: setting latency timer to 64
[drm] initializing kernel modesetting (RV380 0x1002:0x5B62).
[drm] register mmio base: 0xFE4F0000
[drm] register mmio size: 65536
[drm] GPU not posted. posting now...
[drm] Generation 2 PCI interface, using max accessible memory
radeon 0000:02:00.0: VRAM: 256M 0xB0000000 - 0xBFFFFFFF (256M used)
radeon 0000:02:00.0: GTT: 512M 0x90000000 - 0xAFFFFFFF
  alloc irq_desc for 81 on node 0
  alloc kstat_irqs on node 0
radeon 0000:02:00.0: irq 81 for MSI/MSI-X
[drm] radeon: using MSI.
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=256M, BAR=256M
[drm] RAM width 128bits DDR
[drm] radeon: 256M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[drm] PCIE GART of 512M enabled (table at 0xB0040000).
[drm] Loading R300 Microcode
[drm] radeon: ring at 0x0000000090000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] DFP table revision: 4
[drm] External TMDS Table revision: 2
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DVI-I
[drm]   HPD1
[drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm]     DFP1: INTERNAL_TMDS1
[drm] Connector 1:
[drm]   DVI-I
[drm]   HPD2
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm]     DFP2: INTERNAL_DVO1
[drm] fb mappable at 0xB00C0000
[drm] vram apper at 0xB0000000
[drm] size 3145728
[drm] fb depth is 24
[drm]    pitch is 4096
fb1: radeondrmfb frame buffer device
[drm] Initialized radeon 2.5.0 20080528 for 0000:02:00.0 on minor 1
dracut: Starting plymouth daemon
pata_jmicron 0000:06:00.1: enabling device (0000 -> 0001)
  alloc irq_desc for 45 on node 0
  alloc kstat_irqs on node 0
pata_jmicron 0000:06:00.1: PCI INT B -> GSI 45 (level, low) -> IRQ 45
pata_jmicron 0000:06:00.1: BMDMA: failed to set dma mask, falling back to PIO
pata_jmicron 0000:06:00.1: setting latency timer to 64
  alloc irq_desc for 46 on node 0
  alloc kstat_irqs on node 0
firewire_ohci 0000:05:00.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
firewire_ohci 0000:05:00.0: setting latency timer to 64
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max PIO4 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 45
ata10: PATA max PIO4 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 45
work_for_cpu used greatest stack depth: 3960 bytes left
firewire_ohci: Added fw-ohci device 0000:05:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x1
ata9.00: ATAPI: HL-DT-ST DVDRAM GSA-4160B, A302, max UDMA/66
ata9.00: configured for PIO4
scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4160B A302 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi CD-ROM sr0
sr 8:0:0:0: Attached scsi generic sg2 type 5
dracut: Scanning devices sda2 sda3  for LVM volume groups 
dracut: Reading all physical volumes. This may take a while...
dracut: Found volume group "hammervg" using metadata type lvm2
firewire_core: created device fw0: GUID 001e8c00002f03ae, S400
dracut: 12 logical volume(s) in volume group "hammervg" now active
EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/hammervg-F11root
dracut: Loading SELinux policy
type=1404 audit(1279140894.460:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 196917 rules.
SELinux: 2048 avtab hash slots, 196917 rules.
SELinux:  9 users, 13 roles, 3276 types, 160 bools, 1 sens, 1024 cats
SELinux:  77 classes, 196917 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev dm-8, type ext4), uses xattr
type=1403 audit(1279140895.138:3): policy loaded auid=4294967295 ses=4294967295
load_policy used greatest stack depth: 3712 bytes left
dracut: Switching root
readahead: starting
udev: starting version 151
ACPI: WMI: Mapper loaded
microcode: CPU0: patch_level=0x10000bf
ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SMRG [irq 2816-2863 64bit pref]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
input: PC Speaker as /devices/platform/pcspkr/input/input4
type=1400 audit(1279140905.936:4): avc:  denied  { mmap_zero } for  pid=620 comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
type=1400 audit(1279140905.936:5): avc:  denied  { mmap_zero } for  pid=644 comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
ATK0110 ATK0110:00: EC enabled
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
  alloc irq_desc for 51 on node 0
  alloc kstat_irqs on node 0
r8169 0000:04:00.0: PCI INT A -> GSI 51 (level, low) -> IRQ 51
r8169 0000:04:00.0: setting latency timer to 64
r8169 0000:04:00.0: (unregistered net_device): unknown MAC, using family default
  alloc irq_desc for 82 on node 0
  alloc kstat_irqs on node 0
r8169 0000:04:00.0: irq 82 for MSI/MSI-X
r8169 0000:04:00.0: eth0: RTL8168b/8111b at 0xffffc90013cf8000, 48:5b:39:a7:39:f1, XID 0c100000 IRQ 82
udev: renamed network interface eth0 to eth2
cfg80211: Calling CRDA to update world regulatory domain
microcode: CPU1: patch_level=0x10000bf
microcode: CPU2: patch_level=0x10000bf
microcode: CPU3: patch_level=0x10000bf
microcode: CPU4: patch_level=0x10000bf
microcode: CPU5: patch_level=0x10000bf
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported
  alloc irq_desc for 50 on node 0
  alloc kstat_irqs on node 0
xhci_hcd 0000:03:00.0: PCI INT A -> GSI 50 (level, low) -> IRQ 50
xhci_hcd 0000:03:00.0: setting latency timer to 64
xhci_hcd 0000:03:00.0: xHCI Host Controller
xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 8
xhci_hcd 0000:03:00.0: irq 50, io mem 0xfe5fe000
usb usb8: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: xHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.35-rc5+ xhci_hcd
usb usb8: SerialNumber: 0000:03:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 4 ports detected
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
  alloc irq_desc for 21 on node 0
  alloc kstat_irqs on node 0
p54pci 0000:01:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
CE: hpet increased min_delta_ns to 7500 nsec
CE: hpet increased min_delta_ns to 11250 nsec
CE: hpet increased min_delta_ns to 16875 nsec
md: bind<sda4>
md: raid1 personality registered for level 1
md/raid1:md0: active with 1 out of 2 mirrors
md0: detected capacity change from 0 to 120031412224
 md0: unknown partition table
phy0: hwaddr 00:60:b3:1c:2a:10, MAC:isl3890 RF:Frisbee
phy0: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy0::assoc
Registered led device: p54-phy0::tx
Registered led device: p54-phy0::rx
Registered led device: p54-phy0::radio
p54pci 0000:01:06.0: is registered as 'phy0'
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
    (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
    (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
EXT4-fs (dm-8): re-mounted. Opts: (null)
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with ordered data mode
SELinux: initialized (dev sda1, type ext3), uses xattr
Adding 1048572k swap on /dev/mapper/hammervg-swap.  Priority:-1 extents:1 across:1048572k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
powernow-k8: Found 1 AMD Phenom(tm) II X6 1090T Processor (6 cpu cores) (version 2.20.00)
powernow-k8: Core Performance Boosting: on.
powernow-k8:    0 : pstate 0 (3200 MHz)
powernow-k8:    1 : pstate 1 (2400 MHz)
powernow-k8:    2 : pstate 2 (1600 MHz)
powernow-k8:    3 : pstate 3 (800 MHz)
r8169 0000:04:00.0: eth2: link down
wlan0: direct probe to 00:25:9c:ca:c8:7e (try 1)
wlan0: direct probe responded
wlan0: authenticate with 00:25:9c:ca:c8:7e (try 1)
wlan0: authenticated
wlan0: associate with 00:25:9c:ca:c8:7e (try 1)
wlan0: RX AssocResp from 00:25:9c:ca:c8:7e (capab=0x411 status=0 aid=1)
wlan0: associated
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev sdb1, type ext4), uses xattr


> So, IMHO, what is more likely is that it has something to do with
> https://bugzilla.kernel.org/show_bug.cgi?id=15289, as John pointed out
> earlier (thanks John, Michal's situation looks quite similar).
> 
> So, please apply the debug patch below and send me your whole dmesg to
> see what happens. Also, I'd like to see whether the SMI bit (27) in
> that same MSR is set so please do when the machine is up
> 
> for i in $(seq 0 5); do lsmsr -c $i Int -V 3; done

IntPendingMessage    = 0x0000000014c10815
  IOMsgAddr=0x815
  IOMsgData=0xc1
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0x1
  SmiOnCmpHalt=0
IntPendingMessage    = 0x0000000014c10815
  IOMsgAddr=0x815
  IOMsgData=0xc1
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0x1
  SmiOnCmpHalt=0
IntPendingMessage    = 0x0000000014c10815
  IOMsgAddr=0x815
  IOMsgData=0xc1
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0x1
  SmiOnCmpHalt=0
IntPendingMessage    = 0x0000000014c10815
  IOMsgAddr=0x815
  IOMsgData=0xc1
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0x1
  SmiOnCmpHalt=0
IntPendingMessage    = 0x0000000014c10815
  IOMsgAddr=0x815
  IOMsgData=0xc1
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0x1
  SmiOnCmpHalt=0
IntPendingMessage    = 0x0000000014c10815
  IOMsgAddr=0x815
  IOMsgData=0xc1
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0x1
  SmiOnCmpHalt=0


Michal
