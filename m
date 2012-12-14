Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2LNJL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:11:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42103 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2LNJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:11:40 -0500
MIME-Version: 1.0
In-Reply-To: <50CA4A7A.10104@zytor.com>
References: <20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C76F9E.4080001@zytor.com>
	<CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
	<50C7C859.60405@zytor.com>
	<CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
	<50C82ABF.3020907@zytor.com>
	<20121212133853.GC8760@liondog.tnic>
	<50C963B1.3040609@zytor.com>
	<50C96717.3020407@zytor.com>
	<20121213191317.GE31485@liondog.tnic>
	<50CA4A7A.10104@zytor.com>
Date: Fri, 14 Dec 2012 01:11:37 -0800
X-Google-Sender-Auth: vnbXY8B1ZrA_xTPHFSFxhjQiBJI
Message-ID: <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: multipart/mixed; boundary=00151747bd543af82904d0cc6bb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151747bd543af82904d0cc6bb3
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 13, 2012 at 1:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> : tazenda 111 ; qemu-kvm -smp 2 -m 2048 -hda ~/qemu/fc10/qemu-fc10-64.img
> -serial stdio -kernel o.x86_64/arch/x86/boot/bzImage -append 'ro
> root=/dev/sda1 console=ttyS0 earlyprintk=serial,ttyS0 debug'
> early console in setup code
> early console in decompress_kernel
>
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x7fffdfff]
> [    0.000000]  [mem 0x00000000-0x7fdfffff] page 2M
> [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
> [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel
> page tables
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0+ #16
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff817f0d2e>] panic+0xb6/0x1b5
> [    0.000000]  [<ffffffff817e3801>] init_memory_mapping+0x471/0x5a0
> [    0.000000]  [<ffffffff81ecd37f>] setup_arch+0x65c/0xb71
> [    0.000000]  [<ffffffff81ec998e>] start_kernel+0x8a/0x348
> [    0.000000]  [<ffffffff81ec9452>] x86_64_start_reservations+0x132/0x136
> [    0.000000]  [<ffffffff81ec94fe>] x86_64_start_kernel+0xa8/0xad

attached works on kvm local, but SMP does not work yet.

ON TOP of linus tree + tip:x86/mm2

I added mapping to kernel to init_level2_mapping with BRK before #PF
handler still works. (before early_trap_init)
copy entries into init_level2_page from early_level4_pgt....
split setup_real_mode to reserve and copy... copy need to after
init_mem_mapping for system with more than 512G ram.

my plan is using this one replace

      [PATCH v6 06/27] x86, 64bit: Set extra ident mapping for whole
kernel range

early console in setup code
Probing EDD (edd=off to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] BRK [0x03a9f000, 0x03a9ffff] PGTABLE
[    0.000000] BRK [0x03aa0000, 0x03aa0fff] PGTABLE
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-yh-07359-ge48ae89-dirty
(yhlu@linux-siqj.site) (gcc version 4.7.1 20120723 [gcc-4_7-branch
revision 189773] (SUSE Linux) ) #912 SMP Fri Dec 14 00:56:36 PST 2012
[    0.000000] Command line: BOOT_IMAGE=linux debug ignore_loglevel
initcall_debug pci=routeirq ramdisk_size=262144 root=/dev/ram0 rw
ip=dhcp console=uart8250,io,0x3f8,115200 initrd=initrd.img
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000019fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1a0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820: last_pfn = 0xdfffe max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fda40-0x000fda4f]
mapped at [ffff8800000fda40]
[    0.000000] initial memory mapped: [mem 0x00000000-0xffffffffffffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03aa1000, 0x03aa1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x19fe00000-0x19fffffff]
[    0.000000]  [mem 0x19fe00000-0x19fffffff] page 2M
[    0.000000] BRK [0x03aa2000, 0x03aa2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x19c000000-0x19fdfffff]
[    0.000000]  [mem 0x19c000000-0x19fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x180000000-0x19bffffff]
[    0.000000]  [mem 0x180000000-0x19bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] BRK [0x03aa3000, 0x03aa3fff] PGTABLE
[    0.000000] BRK [0x03aa4000, 0x03aa4fff] PGTABLE
[    0.000000] BRK [0x03aa5000, 0x03aa5fff] PGTABLE
[    0.000000] BRK [0x03aa6000, 0x03aa6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
[    0.000000] BRK [0x03aa7000, 0x03aa7fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7d9dc000-0x7fffefff]
[    0.000000] ACPI: RSDP 00000000000fd8c0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe430 00038 (v01 BOCHS  BXPCRSDT
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 00074 (v01 BOCHS  BXPCFACP
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe470 0124A (v01   BXPC   BXDSDT
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 00040
[    0.000000] ACPI: SSDT 00000000dffffe90 000AF (v01 BOCHS  BXPCSSDT
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffffd70 00078 (v01 BOCHS  BXPCAPIC
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffffd30 00038 (v01 BOCHS  BXPCHPET
00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 00000000dffff6c0 0066E (v01   BXPC BXSSDTPC
00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000019fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x19fffffff]
[    0.000000]   NODE_DATA [mem 0x19ffd8000-0x19fffefff]
[    0.000000]  [ffffea0000000000-ffffea00067fffff] PMD ->
[ffff880199600000-ffff88019f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x19fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x19fffffff]
[    0.000000] On node 0 totalpages: 1572749
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 899134 pages, LIFO batch:31
[    0.000000]   Normal zone: 10240 pages used for memmap
[    0.000000]   Normal zone: 645120 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfffe000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000feffc000
[    0.000000] PM: Registered nosave memory: 00000000feffc000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 00000000fffc0000
[    0.000000] PM: Registered nosave memory: 00000000fffc0000 - 0000000100000000
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:1
nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88019fc00000
s1918224 r8192 d23280 u2097152
[    0.000000] pcpu-alloc: s1918224 r8192 d23280 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 1548167
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=linux debug
ignore_loglevel initcall_debug pci=routeirq ramdisk_size=262144
root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200
initrd=initrd.img
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 6040796k/6815744k available (17505k kernel
code, 524748k absent, 250200k reserved, 10054k data, 3444k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:262400 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] WARNING: lockdep init error!
lock-init_mm.page_table_lock was acquiredbefore lockdep_init
[    0.000000] Call stack leading to lockdep invocation was:
[    0.000000]  [<ffffffff81059f8f>] save_stack_trace+0x2f/0x50
[    0.000000]  [<ffffffff810e966d>] __lock_acquire+0xed/0xc40
[    0.000000]  [<ffffffff810ea7ad>] lock_acquire+0x9d/0x120
[    0.000000]  [<ffffffff8210bbc6>] _raw_spin_lock+0x36/0x70
[    0.000000]  [<ffffffff820ee9df>] phys_pmd_init+0x188/0x264
[    0.000000]  [<ffffffff820eeca4>] phys_pud_init+0x1e9/0x298
[    0.000000]  [<ffffffff820eee91>] kernel_physical_mapping_init+0x13e/0x1eb
[    0.000000]  [<ffffffff82cc14d5>] x86_64_start_kernel+0xc4/0x106
[    0.000000]  [<ffffffffffffffff>] 0xffffffffffffffff
[    0.000000] allocated 25165824 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2491.962 MHz processor
[    0.004002] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4983.92 BogoMIPS (lpj=9967848)
[    0.006588] pid_max: default: 32768 minimum: 301
[    0.008909] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.013872] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.016147] Mount-cache hash table entries: 256
[    0.017971] Initializing cgroup subsys cpuacct
[    0.019083] Initializing cgroup subsys memory
[    0.020068] Initializing cgroup subsys devices
[    0.021162] Initializing cgroup subsys freezer
[    0.022259] Initializing cgroup subsys blkio
[    0.023423] mce: CPU supports 10 MCE banks
[    0.024051] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.024051] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.024051] tlb_flushall_shift: 6
[    0.047824] Freeing SMP alternatives: 48k freed
[    0.048018] ACPI: Core revision 20121018
[    0.052355] ftrace: allocating 53391 entries in 209 pages
[    0.072647] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.113775] smpboot: CPU0: Intel QEMU Virtual CPU version 1.2.50
(fam: 06, model: 02, stepping: 03)
[    0.116000] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.116000] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0
after 0 usecs
[    0.116000] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.116009] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0
after 0 usecs
[    0.117828] calling  init_hw_perf_events+0x0/0x40d @ 1
[    0.119077] Performance Events: unsupported p6 CPU model 2 no PMU
driver, software events only.
[    0.121392] initcall init_hw_perf_events+0x0/0x40d returned 0 after
3906 usecs
[    0.123124] calling  register_trigger_all_cpu_backtrace+0x0/0x16 @ 1
[    0.124020] initcall register_trigger_all_cpu_backtrace+0x0/0x16
returned 0 after 0 usecs
[    0.126062] calling  spawn_ksoftirqd+0x0/0x26 @ 1
[    0.128104] initcall spawn_ksoftirqd+0x0/0x26 returned 0 after 0 usecs
[    0.129682] calling  init_workqueues+0x0/0x3c5 @ 1
[    0.131021] initcall init_workqueues+0x0/0x3c5 returned 0 after 0 usecs
[    0.132006] calling  migration_init+0x0/0x6c @ 1
[    0.133061] initcall migration_init+0x0/0x6c returned 0 after 0 usecs
[    0.134661] calling  cpu_stop_init+0x0/0xcd @ 1
[    0.136042] initcall cpu_stop_init+0x0/0xcd returned 0 after 0 usecs
[    0.137560] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.139006] initcall rcu_scheduler_really_started+0x0/0x12 returned
0 after 0 usecs
[    0.140012] calling  rcu_spawn_gp_kthread+0x0/0x87 @ 1
[    0.141353] initcall rcu_spawn_gp_kthread+0x0/0x87 returned 0 after 0 usecs
[    0.144009] calling  relay_init+0x0/0x14 @ 1
[    0.145068] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.146537] calling  tracer_alloc_buffers+0x0/0x2b2 @ 1
[    0.148056] initcall tracer_alloc_buffers+0x0/0x2b2 returned 0 after 0 usecs
[    0.149762] calling  init_events+0x0/0x60 @ 1
[    0.150831] initcall init_events+0x0/0x60 returned 0 after 0 usecs
[    0.152005] calling  init_trace_printk+0x0/0x12 @ 1
[    0.153189] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.154806] calling  init_ftrace_syscalls+0x0/0x6f @ 1
[    0.156494] initcall init_ftrace_syscalls+0x0/0x6f returned 0 after 0 usecs
[    0.158225] Brought up 1 CPUs
[    0.158956] smpboot: Total of 1 processors activated (4983.92 BogoMIPS)
[    0.160258] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.165964] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.166727] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.168011] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.169191] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.170895] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.172020] initcall init_cpufreq_transition_notifier_list+0x0/0x1b
returned 0 after 0 usecs
[    0.174052] calling  net_ns_init+0x0/0xe7 @ 1
[    0.176054] initcall net_ns_init+0x0/0xe7 returned 0 after 3906 usecs
[    0.177732] calling  e820_mark_nvs_memory+0x0/0x3d @ 1
[    0.178981] initcall e820_mark_nvs_memory+0x0/0x3d returned 0 after 0 usecs
[    0.180007] calling  cpufreq_tsc+0x0/0x33 @ 1
[    0.181066] initcall cpufreq_tsc+0x0/0x33 returned 0 after 0 usecs
[    0.182572] calling  reboot_init+0x0/0x20 @ 1
[    0.184029] initcall reboot_init+0x0/0x20 returned 0 after 0 usecs
[    0.185529] calling  init_lapic_sysfs+0x0/0x23 @ 1
[    0.186704] initcall init_lapic_sysfs+0x0/0x23 returned 0 after 0 usecs
[    0.188006] calling  cpu_hotplug_pm_sync_init+0x0/0x14 @ 1
[    0.189318] initcall cpu_hotplug_pm_sync_init+0x0/0x14 returned 0
after 0 usecs
[    0.191077] calling  alloc_frozen_cpus+0x0/0x1e @ 1
[    0.192010] initcall alloc_frozen_cpus+0x0/0x1e returned 0 after 0 usecs
[    0.193633] calling  ksysfs_init+0x0/0x97 @ 1
[    0.194719] initcall ksysfs_init+0x0/0x97 returned 0 after 0 usecs
[    0.196005] calling  pm_init+0x0/0x7f @ 1
[    0.196997] initcall pm_init+0x0/0x7f returned 0 after 0 usecs
[    0.198390] calling  pm_disk_init+0x0/0x19 @ 1
[    0.200024] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.201603] calling  swsusp_header_init+0x0/0x40 @ 1
[    0.202846] initcall swsusp_header_init+0x0/0x40 returned 0 after 0 usecs
[    0.204009] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.205354] initcall init_jiffies_clocksource+0x0/0x12 returned 0
after 0 usecs
[    0.208007] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
[    0.209248] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 0 usecs
[    0.210901] calling  init_function_trace+0x0/0x3e @ 1
[    0.212008] initcall init_function_trace+0x0/0x3e returned 0 after 0 usecs
[    0.213663] calling  init_irqsoff_tracer+0x0/0x14 @ 1
[    0.214887] initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 0 usecs
[    0.216005] calling  init_wakeup_tracer+0x0/0x22 @ 1
[    0.217214] initcall init_wakeup_tracer+0x0/0x22 returned 0 after 0 usecs
[    0.218853] calling  init_graph_trace+0x0/0x67 @ 1
[    0.220008] initcall init_graph_trace+0x0/0x67 returned 0 after 0 usecs
[    0.221588] calling  event_trace_enable+0x0/0x9e @ 1
[    0.224930] initcall event_trace_enable+0x0/0x9e returned 0 after 3906 usecs
[    0.226635] calling  init_zero_pfn+0x0/0x39 @ 1
[    0.227730] initcall init_zero_pfn+0x0/0x39 returned 0 after 0 usecs
[    0.228009] calling  memory_failure_init+0x0/0xe3 @ 1
[    0.229242] initcall memory_failure_init+0x0/0xe3 returned 0 after 0 usecs
[    0.232010] calling  fsnotify_init+0x0/0x34 @ 1
[    0.233180] initcall fsnotify_init+0x0/0x34 returned 0 after 0 usecs
[    0.234719] calling  filelock_init+0x0/0x2a @ 1
[    0.236015] initcall filelock_init+0x0/0x2a returned 0 after 0 usecs
[    0.237558] calling  init_script_binfmt+0x0/0x16 @ 1
[    0.238771] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.240006] calling  init_elf_binfmt+0x0/0x16 @ 1
[    0.241143] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.242714] calling  debugfs_init+0x0/0x5b @ 1
[    0.244015] initcall debugfs_init+0x0/0x5b returned 0 after 0 usecs
[    0.245391] calling  securityfs_init+0x0/0x52 @ 1
[    0.246061] initcall securityfs_init+0x0/0x52 returned 0 after 0 usecs
[    0.246756] calling  calibrate_xor_blocks+0x0/0x95 @ 1
[    0.247369] xor: automatically using best checksumming function:
[    0.288005]    generic_sse: 13428.000 MB/sec
[    0.288495] initcall calibrate_xor_blocks+0x0/0x95 returned 0 after
42968 usecs
[    0.289482] calling  random32_init+0x0/0xd4 @ 1
[    0.290078] initcall random32_init+0x0/0xd4 returned 0 after 0 usecs
[    0.290839] calling  test_atomic64+0x0/0x43e @ 1
[    0.291433] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.292008] initcall test_atomic64+0x0/0x43e returned 0 after 3906 usecs
[    0.292749] calling  virtio_init+0x0/0x40 @ 1
[    0.293646] initcall virtio_init+0x0/0x40 returned 0 after 0 usecs
[    0.294364] calling  cpufreq_core_init+0x0/0xc1 @ 1
[    0.294827] initcall cpufreq_core_init+0x0/0xc1 returned 0 after 0 usecs
[    0.295530] calling  cpuidle_init+0x0/0x3f @ 1
[    0.296017] initcall cpuidle_init+0x0/0x3f returned 0 after 0 usecs
[    0.296668] calling  bsp_pm_check_init+0x0/0x14 @ 1
[    0.297141] initcall bsp_pm_check_init+0x0/0x14 returned 0 after 0 usecs
[    0.297798] calling  sock_init+0x0/0x7f @ 1
[    0.298425] initcall sock_init+0x0/0x7f returned 0 after 0 usecs
[    0.299058] calling  net_inuse_init+0x0/0x26 @ 1
[    0.299584] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.300005] calling  netlink_proto_init+0x0/0x1dd @ 1
[    0.300603] NET: Registered protocol family 16
[    0.301145] initcall netlink_proto_init+0x0/0x1dd returned 0 after 0 usecs
[    0.302086] calling  bdi_class_init+0x0/0x49 @ 1
[    0.302758] initcall bdi_class_init+0x0/0x49 returned 0 after 0 usecs
[    0.303380] calling  kobject_uevent_init+0x0/0x12 @ 1
[    0.304020] initcall kobject_uevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.304819] calling  gpiolib_sysfs_init+0x0/0x93 @ 1
[    0.305440] initcall gpiolib_sysfs_init+0x0/0x93 returned 0 after 0 usecs
[    0.306225] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.306822] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.308019] calling  pci_driver_init+0x0/0x19 @ 1
[    0.308616] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
[    0.309309] calling  rio_bus_init+0x0/0x37 @ 1
[    0.309925] initcall rio_bus_init+0x0/0x37 returned 0 after 0 usecs
[    0.310589] calling  lcd_class_init+0x0/0x4d @ 1
[    0.311188] initcall lcd_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.311810] calling  backlight_class_init+0x0/0x5d @ 1
[    0.312076] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.312799] calling  video_output_class_init+0x0/0x19 @ 1
[    0.313384] initcall video_output_class_init+0x0/0x19 returned 0
after 0 usecs
[    0.314127] calling  tty_class_init+0x0/0x34 @ 1
[    0.314646] initcall tty_class_init+0x0/0x34 returned 0 after 0 usecs
[    0.315369] calling  vtconsole_class_init+0x0/0xe9 @ 1
[    0.316203] initcall vtconsole_class_init+0x0/0xe9 returned 0 after 0 usecs
[    0.316978] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.317605] initcall wakeup_sources_debugfs_init+0x0/0x2b returned
0 after 0 usecs
[    0.318350] calling  register_node_type+0x0/0x31 @ 1
[    0.319101] initcall register_node_type+0x0/0x31 returned 0 after 0 usecs
[    0.320022] calling  regmap_initcall+0x0/0xd @ 1
[    0.320665] initcall regmap_initcall+0x0/0xd returned 0 after 0 usecs
[    0.321362] calling  i2c_init+0x0/0x76 @ 1
[    0.321975] initcall i2c_init+0x0/0x76 returned 0 after 0 usecs
[    0.322769] calling  amd_postcore_init+0x0/0x14a @ 1
[    0.323412] initcall amd_postcore_init+0x0/0x14a returned 0 after 0 usecs
[    0.324151] calling  set_real_mode_permissions+0x0/0x9b @ 1
[    0.325526] initcall set_real_mode_permissions+0x0/0x9b returned 0
after 0 usecs
[    0.327275] calling  arch_kdebugfs_init+0x0/0x224 @ 1
[    0.328059] initcall arch_kdebugfs_init+0x0/0x224 returned 0 after 0 usecs
[    0.329717] calling  mtrr_if_init+0x0/0x65 @ 1
[    0.330798] initcall mtrr_if_init+0x0/0x65 returned 0 after 0 usecs
[    0.332008] calling  ffh_cstate_init+0x0/0x2d @ 1
[    0.333148] initcall ffh_cstate_init+0x0/0x2d returned 0 after 0 usecs
[    0.336006] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.336812] ACPI: bus type pci registered
[    0.337790] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.339321] calling  dma_bus_init+0x0/0x19 @ 1
[    0.340115] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
[    0.341634] calling  dma_channel_table_init+0x0/0x115 @ 1
[    0.342954] initcall dma_channel_table_init+0x0/0x115 returned 0
after 0 usecs
[    0.344023] calling  dmi_id_init+0x0/0x31f @ 1
[    0.345291] initcall dmi_id_init+0x0/0x31f returned 0 after 0 usecs
[    0.348005] calling  dca_init+0x0/0x20 @ 1
[    0.348980] dca service started, version 1.12.1
[    0.350190] initcall dca_init+0x0/0x20 returned 0 after 0 usecs
[    0.351634] calling  pci_arch_init+0x0/0x6a @ 1
[    0.352076] PCI: Using configuration type 1 for base access
[    0.353424] initcall pci_arch_init+0x0/0x6a returned 0 after 0 usecs
[    0.356057] calling  topology_init+0x0/0x97 @ 1
[    0.357610] initcall topology_init+0x0/0x97 returned 0 after 0 usecs
[    0.359150] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    0.360026] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    0.361679] calling  init_vdso+0x0/0x158 @ 1
[    0.362713] initcall init_vdso+0x0/0x158 returned 0 after 0 usecs
[    0.364005] calling  param_sysfs_init+0x0/0x1ae @ 1
[    0.426553] initcall param_sysfs_init+0x0/0x1ae returned 0 after 58593 usecs
[    0.428033] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.429022] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.430554] calling  default_bdi_init+0x0/0x37 @ 1
[    0.432346] initcall default_bdi_init+0x0/0x37 returned 0 after 3906 usecs
[    0.434030] calling  init_bio+0x0/0x10f @ 1
[    0.435131] bio: create slab <bio-0> at 0
[    0.436040] initcall init_bio+0x0/0x10f returned 0 after 3906 usecs
[    0.437529] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.438908] initcall fsnotify_notification_init+0x0/0x8b returned 0
after 0 usecs
[    0.440045] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.441160] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.442717] calling  blk_settings_init+0x0/0x2a @ 1
[    0.444062] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.445685] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.446765] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.448057] calling  blk_softirq_init+0x0/0x6f @ 1
[    0.449210] initcall blk_softirq_init+0x0/0x6f returned 0 after 0 usecs
[    0.450803] calling  blk_iopoll_setup+0x0/0x6f @ 1
[    0.452027] initcall blk_iopoll_setup+0x0/0x6f returned 0 after 0 usecs
[    0.453652] calling  genhd_device_init+0x0/0x7a @ 1
[    0.456120] initcall genhd_device_init+0x0/0x7a returned 0 after 3906 usecs
[    0.457785] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    0.459091] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    0.460010] calling  raid6_select_algo+0x0/0x238 @ 1
[    0.528004] raid6: sse2x1    8293 MB/s
[    0.596005] raid6: sse2x2   10229 MB/s
[    0.664007] raid6: sse2x4   11204 MB/s
[    0.664649] raid6: using algorithm sse2x4 (11204 MB/s)
[    0.665919] raid6: using intx1 recovery algorithm
[    0.667044] initcall raid6_select_algo+0x0/0x238 returned 0 after
199218 usecs
[    0.668006] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    0.669261] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.670935] calling  pci_slot_init+0x0/0x60 @ 1
[    0.672013] initcall pci_slot_init+0x0/0x60 returned 0 after 0 usecs
[    0.673533] calling  fbmem_init+0x0/0x98 @ 1
[    0.674708] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.676044] calling  acpi_init+0x0/0x28b @ 1
[    0.677098] ACPI: Added _OSI(Module Device)
[    0.678110] ACPI: Added _OSI(Processor Device)
[    0.680028] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.681174] ACPI: Added _OSI(Processor Aggregator Device)
[    0.684554] ACPI: EC: Look up EC in DSDT
[    0.690020] ACPI: Interpreter enabled
[    0.690882] ACPI: (supports S0 S3 S4 S5)
[    0.692007] ACPI: Using IOAPIC for interrupt routing
[    0.703051] initcall acpi_init+0x0/0x28b returned 0 after 23437 usecs
[    0.704061] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    0.705283] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.707669] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.708056] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.710149] pci_root PNP0A03:00: ACPI _OSC support notification
failed, disabling PCIe ASPM
[    0.712006] pci_root PNP0A03:00: Unable to request _OSC control
(_OSC support mask: 0x08)
[    0.714303] pci_root PNP0A03:00: fail to add MMCONFIG information,
can't access extended PCI configuration space under this bridge.
[    0.716242] PCI host bridge to bus 0000:00
[    0.720016] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.721327] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.722835] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.724009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.725660] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.727331] pci_bus 0000:00: scanning bus
[    0.728076] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.729520] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    0.731032] calling  quirk_mmio_always_on+0x0/0x10 @ 1 for 0000:00:00.0
[    0.732006] pci fixup quirk_mmio_always_on+0x0/0x10 returned after
0 usecs for 0000:00:00.0
[    0.734307] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.736411] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.740526] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.742608] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.744017] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x50
[    0.745589] calling  acpi_pm_check_blacklist+0x0/0x50 @ 1 for 0000:00:01.3
[    0.747247] pci fixup acpi_pm_check_blacklist+0x0/0x50 returned
after 0 usecs for 0000:00:01.3
[    0.748332] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x170
[    0.749756] calling  quirk_piix4_acpi+0x0/0x170 @ 1 for 0000:00:01.3
[    0.752023] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by
PIIX4 ACPI
[    0.753753] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.756049] pci fixup quirk_piix4_acpi+0x0/0x170 returned after
3906 usecs for 0000:00:01.3
[    0.758059] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x20
[    0.759574] calling  pci_fixup_piix4_acpi+0x0/0x20 @ 1 for 0000:00:01.3
[    0.760007] pci fixup pci_fixup_piix4_acpi+0x0/0x20 returned after
0 usecs for 0000:00:01.3
[    0.762140] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.765231] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.768837] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.777158] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.778808] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.780674] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.782767] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.787380] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.788274] pci_bus 0000:00: fixups for bus
[    0.788977] pci_bus 0000:00: bus scan returning with max=00
[    0.790384] ACPI: Invalid Power Resource to register!
[    0.792021] ACPI: Invalid Power Resource to register!
[    0.793254] ACPI: Invalid Power Resource to register!
[    0.794486] ACPI: Invalid Power Resource to register!
[    0.796019] ACPI: Invalid Power Resource to register!
[    0.797255] ACPI: Invalid Power Resource to register!
[    0.798688] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.807000] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 97656 usecs
[    0.808006] calling  acpi_pci_link_init+0x0/0x3e @ 1
[    0.809363] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.810946] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.812528] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.814073] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.816502] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.818040] initcall acpi_pci_link_init+0x0/0x3e returned 0 after 7812 usecs
[    0.819765] calling  pnp_init+0x0/0x19 @ 1
[    0.820121] initcall pnp_init+0x0/0x19 returned 0 after 0 usecs
[    0.821557] calling  misc_init+0x0/0xb6 @ 1
[    0.822650] initcall misc_init+0x0/0xb6 returned 0 after 0 usecs
[    0.824005] calling  vga_arb_device_init+0x0/0xd4 @ 1
[    0.825463] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.828005] vgaarb: loaded
[    0.828667] vgaarb: bridge control possible 0000:00:02.0
[    0.829944] initcall vga_arb_device_init+0x0/0xd4 returned 0 after 3906 usecs
[    0.832006] calling  cn_init+0x0/0xd0 @ 1
[    0.832995] initcall cn_init+0x0/0xd0 returned 0 after 0 usecs
[    0.834412] calling  tifm_init+0x0/0x91 @ 1
[    0.835608] initcall tifm_init+0x0/0x91 returned 0 after 0 usecs
[    0.836006] calling  init_scsi+0x0/0x8e @ 1
[    0.837369] SCSI subsystem initialized
[    0.838289] initcall init_scsi+0x0/0x8e returned 0 after 0 usecs
[    0.840006] calling  ata_init+0x0/0x5f @ 1
[    0.840980] ACPI: bus type scsi registered
[    0.842259] libata version 3.00 loaded.
[    0.844012] initcall ata_init+0x0/0x5f returned 0 after 3906 usecs
[    0.845561] calling  phy_init+0x0/0x2e @ 1
[    0.846820] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.848010] calling  init_pcmcia_cs+0x0/0x3d @ 1
[    0.849234] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
[    0.850752] calling  usb_init+0x0/0x171 @ 1
[    0.852037] ACPI: bus type usb registered
[    0.853175] usbcore: registered new interface driver usbfs
[    0.854591] usbcore: registered new interface driver hub
[    0.856150] usbcore: registered new device driver usb
[    0.857377] initcall usb_init+0x0/0x171 returned 0 after 3906 usecs
[    0.858881] calling  serio_init+0x0/0x35 @ 1
[    0.860097] initcall serio_init+0x0/0x35 returned 0 after 0 usecs
[    0.861578] calling  input_init+0x0/0x108 @ 1
[    0.862707] initcall input_init+0x0/0x108 returned 0 after 0 usecs
[    0.864044] calling  rtc_init+0x0/0x6a @ 1
[    0.865184] initcall rtc_init+0x0/0x6a returned 0 after 0 usecs
[    0.866552] calling  pps_init+0x0/0xb4 @ 1
[    0.867615] pps_core: LinuxPPS API ver. 1 registered
[    0.868015] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.870211] initcall pps_init+0x0/0xb4 returned 0 after 3906 usecs
[    0.872011] calling  ptp_init+0x0/0xa1 @ 1
[    0.873148] PTP clock support registered
[    0.874138] initcall ptp_init+0x0/0xa1 returned 0 after 0 usecs
[    0.876029] calling  power_supply_class_init+0x0/0x40 @ 1
[    0.877466] initcall power_supply_class_init+0x0/0x40 returned 0
after 0 usecs
[    0.879226] calling  hwmon_init+0x0/0xee @ 1
[    0.880126] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    0.881600] calling  md_init+0x0/0x150 @ 1
[    0.882648] initcall md_init+0x0/0x150 returned 0 after 0 usecs
[    0.884017] calling  mmc_init+0x0/0x78 @ 1
[    0.885228] initcall mmc_init+0x0/0x78 returned 0 after 0 usecs
[    0.886667] calling  leds_init+0x0/0x44 @ 1
[    0.888086] initcall leds_init+0x0/0x44 returned 0 after 0 usecs
[    0.889536] calling  acpi_wmi_init+0x0/0x71 @ 1
[    0.890772] wmi: Mapper loaded
[    0.892016] initcall acpi_wmi_init+0x0/0x71 returned 0 after 3906 usecs
[    0.893607] calling  iommu_init+0x0/0x56 @ 1
[    0.894643] initcall iommu_init+0x0/0x56 returned 0 after 0 usecs
[    0.896005] calling  init_soundcore+0x0/0x34 @ 1
[    0.897203] initcall init_soundcore+0x0/0x34 returned 0 after 0 usecs
[    0.898749] calling  alsa_sound_init+0x0/0x90 @ 1
[    0.900060] Advanced Linux Sound Architecture Driver Initialized.
[    0.901522] initcall alsa_sound_init+0x0/0x90 returned 0 after 0 usecs
[    0.903068] calling  ac97_bus_init+0x0/0x19 @ 1
[    0.904154] initcall ac97_bus_init+0x0/0x19 returned 0 after 0 usecs
[    0.905733] calling  pci_subsys_init+0x0/0x4a @ 1
[    0.906862] PCI: Using ACPI for IRQ routing
[    0.908031] PCI: Routing PCI interrupts for all devices because
"pci=routeirq" specified
[    0.910008] ACPI Exception: AE_NOT_FOUND, Evaluating _SRS
(20121018/pci_link-367)
[    0.911831] ACPI: Unable to set IRQ for PCI Interrupt Link [LNKS].
Try pci=noacpi or acpi=off
[    0.912007] pci 0000:00:01.3: PCI INT A: no GSI - using ISA IRQ 9
[    0.913633] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.916035] PCI: pci_cache_line_size set to 64 bytes
[    0.916729] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7
flags 0x110] (d=0, p=0)
[    0.917875] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags
0x110] (d=0, p=0)
[    0.918723] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177
flags 0x110] (d=0, p=0)
[    0.920005] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags
0x110] (d=0, p=0)
[    0.920876] pci 0000:00:01.1: BAR 4: reserving [io  0xc040-0xc04f
flags 0x40101] (d=0, p=0)
[    0.921851] pci 0000:00:02.0: BAR 0: reserving [mem
0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.922708] pci 0000:00:02.0: BAR 1: reserving [mem
0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    0.923628] pci 0000:00:03.0: BAR 0: reserving [mem
0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    0.924005] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f
flags 0x40101] (d=0, p=0)
[    0.924916] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.925488] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.926215] initcall pci_subsys_init+0x0/0x4a returned 0 after 19531 usecs
[    0.927012] calling  proto_init+0x0/0x12 @ 1
[    0.928014] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.928669] calling  net_dev_init+0x0/0x265 @ 1
[    0.929677] initcall net_dev_init+0x0/0x265 returned 0 after 0 usecs
[    0.930310] calling  neigh_init+0x0/0x80 @ 1
[    0.930836] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.931647] calling  genl_init+0x0/0x80 @ 1
[    0.932059] initcall genl_init+0x0/0x80 returned 0 after 0 usecs
[    0.932979] calling  bt_init+0x0/0x9d @ 1
[    0.933472] Bluetooth: Core ver 2.16
[    0.933958] NET: Registered protocol family 31
[    0.934642] Bluetooth: HCI device and connection manager initialized
[    0.936041] Bluetooth: HCI socket layer initialized
[    0.937103] Bluetooth: L2CAP socket layer initialized
[    0.937993] Bluetooth: SCO socket layer initialized
[    0.938506] initcall bt_init+0x0/0x9d returned 0 after 3906 usecs
[    0.939238] calling  cfg80211_init+0x0/0xca @ 1
[    0.940447] cfg80211: Calling CRDA to update world regulatory domain
[    0.941172] initcall cfg80211_init+0x0/0xca returned 0 after 0 usecs
[    0.941838] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    0.942461] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.943145] calling  ieee80211_init+0x0/0x3b @ 1
[    0.943845] initcall ieee80211_init+0x0/0x3b returned 0 after 0 usecs
[    0.944134] calling  hpet_late_init+0x0/0xec @ 1
[    0.944722] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.945599] initcall hpet_late_init+0x0/0xec returned 0 after 0 usecs
[    0.946347] calling  init_amd_nbs+0x0/0xaf @ 1
[    0.946793] initcall init_amd_nbs+0x0/0xaf returned 0 after 0 usecs
[    0.948025] calling  clocksource_done_booting+0x0/0x5e @ 1
[    0.948623] Switching to clocksource hpet
[    0.949085] initcall clocksource_done_booting+0x0/0x5e returned 0
after 37 usecs
[    0.949856] calling  ftrace_init_debugfs+0x0/0x20c @ 1
[    0.950451] initcall ftrace_init_debugfs+0x0/0x20c returned 0 after 75 usecs
[    0.951462] calling  tracer_init_debugfs+0x0/0x414 @ 1
[    0.951988] initcall tracer_init_debugfs+0x0/0x414 returned 0 after 264 usecs
[    0.951997] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.952642] initcall init_trace_printk_function_export+0x0/0x2f
returned 0 after 10 usecs
[    0.953521] calling  event_trace_init+0x0/0x273 @ 1
[    0.990576] initcall event_trace_init+0x0/0x273 returned 0 after 35572 usecs
[    0.991403] calling  init_kprobe_trace+0x0/0x8e @ 1
[    0.992163] initcall init_kprobe_trace+0x0/0x8e returned 0 after 27 usecs
[    0.993028] calling  init_pipe_fs+0x0/0x4a @ 1
[    0.993615] initcall init_pipe_fs+0x0/0x4a returned 0 after 92 usecs
[    0.994383] calling  eventpoll_init+0x0/0x10a @ 1
[    0.994899] initcall eventpoll_init+0x0/0x10a returned 0 after 22 usecs
[    0.995542] calling  anon_inode_init+0x0/0x59 @ 1
[    0.996169] initcall anon_inode_init+0x0/0x59 returned 0 after 72 usecs
[    0.996965] calling  fscache_init+0x0/0x22c @ 1
[    0.997558] FS-Cache: Loaded
[    0.997863] initcall fscache_init+0x0/0x22c returned 0 after 328 usecs
[    0.998616] calling  cachefiles_init+0x0/0xa1 @ 1
[    0.999305] CacheFiles: Loaded
[    0.999656] initcall cachefiles_init+0x0/0xa1 returned 0 after 508 usecs
[    1.000493] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    1.001096] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 4 usecs
[    1.001829] calling  acpi_event_init+0x0/0x55 @ 1
[    1.002337] initcall acpi_event_init+0x0/0x55 returned 0 after 17 usecs
[    1.002979] calling  pnp_system_init+0x0/0x12 @ 1
[    1.003568] initcall pnp_system_init+0x0/0x12 returned 0 after 86 usecs
[    1.004366] calling  pnpacpi_init+0x0/0x8c @ 1
[    1.004836] pnp: PnP ACPI init
[    1.005180] ACPI: bus type pnp registered
[    1.005830] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.006652] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.007442] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.008241] pnp 00:03: [dma 2]
[    1.008723] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.009685] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.010595] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.011730] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.012789] pnp: PnP ACPI: found 7 devices
[    1.013236] ACPI: ACPI bus type pnp unregistered
[    1.013700] initcall pnpacpi_init+0x0/0x8c returned 0 after 8655 usecs
[    1.014404] calling  intel_mid_dma_init+0x0/0x30 @ 1
[    1.014992] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    1.015672] initcall intel_mid_dma_init+0x0/0x30 returned 0 after 664 usecs
[    1.016449] calling  chr_dev_init+0x0/0xc1 @ 1
[    1.024170] initcall chr_dev_init+0x0/0xc1 returned 0 after 7072 usecs
[    1.025023] calling  firmware_class_init+0x0/0x120 @ 1
[    1.025594] initcall firmware_class_init+0x0/0x120 returned 0 after 113 usecs
[    1.026218] calling  thermal_init+0x0/0x8a @ 1
[    1.027527] initcall thermal_init+0x0/0x8a returned 0 after 146 usecs
[    1.029161] calling  thermal_gov_step_wise_init+0x0/0x12 @ 1
[    1.030587] initcall thermal_gov_step_wise_init+0x0/0x12 returned 0
after 35 usecs
[    1.032496] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    1.033925] initcall cpufreq_gov_performance_init+0x0/0x12 returned
0 after 17 usecs
[    1.035792] calling  init_acpi_pm_clocksource+0x0/0xdf @ 1
[    1.041756] initcall init_acpi_pm_clocksource+0x0/0xdf returned 0
after 4435 usecs
[    1.043572] calling  ssb_modinit+0x0/0x50 @ 1
[    1.044824] initcall ssb_modinit+0x0/0x50 returned 0 after 135 usecs
[    1.046359] calling  bcma_modinit+0x0/0x3c @ 1
[    1.047616] initcall bcma_modinit+0x0/0x3c returned 0 after 174 usecs
[    1.049281] calling  pcibios_assign_resources+0x0/0xd7 @ 1
[    1.050628] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.051945] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.053413] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.054921] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    1.056558] initcall pcibios_assign_resources+0x0/0xd7 returned 0
after 5800 usecs
[    1.058391] calling  sysctl_core_init+0x0/0x2c @ 1
[    1.059580] initcall sysctl_core_init+0x0/0x2c returned 0 after 26 usecs
[    1.061242] calling  inet_init+0x0/0x292 @ 1
[    1.062313] NET: Registered protocol family 2
[    1.063646] TCP established hash table entries: 65536 (order: 8,
1048576 bytes)
[    1.066128] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    1.071186] TCP: Hash tables configured (established 65536 bind 65536)
[    1.072562] TCP: reno registered
[    1.073407] UDP hash table entries: 4096 (order: 7, 786432 bytes)
[    1.075389] UDP-Lite hash table entries: 4096 (order: 7, 786432 bytes)
[    1.077861] initcall inet_init+0x0/0x292 returned 0 after 15211 usecs
[    1.079189] calling  ipv4_offload_init+0x0/0x68 @ 1
[    1.080445] initcall ipv4_offload_init+0x0/0x68 returned 0 after 14 usecs
[    1.082051] calling  af_unix_init+0x0/0x52 @ 1
[    1.083188] NET: Registered protocol family 1
[    1.084351] initcall af_unix_init+0x0/0x52 returned 0 after 1139 usecs
[    1.085912] calling  init_sunrpc+0x0/0x6b @ 1
[    1.087204] RPC: Registered named UNIX socket transport module.
[    1.088723] RPC: Registered udp transport module.
[    1.089862] RPC: Registered tcp transport module.
[    1.090997] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.092587] initcall init_sunrpc+0x0/0x6b returned 0 after 5468 usecs
[    1.094138] calling  pci_apply_final_quirks+0x0/0x108 @ 1
[    1.095459] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
[    1.096849] calling  quirk_natoma+0x0/0x40 @ 1 for 0000:00:00.0
[    1.098279] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.099701] pci fixup quirk_natoma+0x0/0x40 returned after 1389
usecs for 0000:00:00.0
[    1.101647] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    1.103178] calling  quirk_passive_release+0x0/0x90 @ 1 for 0000:00:00.0
[    1.104856] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.106259] pci fixup quirk_passive_release+0x0/0x90 returned after
1384 usecs for 0000:00:00.0
[    1.108396] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
[    1.109877] calling  quirk_isa_dma_hangs+0x0/0x40 @ 1 for 0000:00:01.0
[    1.111430] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.112934] pci fixup quirk_isa_dma_hangs+0x0/0x40 returned after
1458 usecs for 0000:00:01.0
[    1.115018] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xe0
[    1.116494] calling  pci_fixup_video+0x0/0xe0 @ 1 for 0000:00:02.0
[    1.117997] pci 0000:00:02.0: Boot video device
[    1.119059] pci fixup pci_fixup_video+0x0/0xe0 returned after 1048
usecs for 0000:00:02.0
[    1.121035] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1c0
[    1.122514] calling  quirk_e100_interrupt+0x0/0x1c0 @ 1 for 0000:00:03.0
[    1.124168] pci fixup quirk_e100_interrupt+0x0/0x1c0 returned after
4 usecs for 0000:00:03.0
[    1.126182] PCI: CLS 0 bytes, default 64
[    1.127137] initcall pci_apply_final_quirks+0x0/0x108 returned 0
after 30941 usecs
[    1.129003] calling  populate_rootfs+0x0/0xd0 @ 1
[    1.130300] Trying to unpack rootfs image as initramfs...
[    1.135789] rootfs image is not initramfs (no cpio magic); looks
like an initrd
[    1.161303] Freeing initrd memory: 39052k freed
[    1.168423] initcall populate_rootfs+0x0/0xd0 returned 0 after 37378 usecs
[    1.169929] calling  pci_iommu_init+0x0/0x3e @ 1
[    1.171049] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.172645] software IO TLB [mem 0xdbffe000-0xdfffdfff] (64MB)
mapped at [ffff8800dbffe000-ffff8800dfffdfff]
[    1.175021] initcall pci_iommu_init+0x0/0x3e returned 0 after 3874 usecs
[    1.176686] calling  ir_dev_scope_init+0x0/0x16 @ 1
[    1.177873] initcall ir_dev_scope_init+0x0/0x16 returned 0 after 4 usecs
[    1.179585] calling  irqfd_module_init+0x0/0x38 @ 1
[    1.180910] initcall irqfd_module_init+0x0/0x38 returned 0 after 87 usecs
[    1.182543] calling  vmx_init+0x0/0x2ce @ 1
[    1.183559] kvm: no hardware support
[    1.184495] initcall vmx_init+0x0/0x2ce returned -95 after 913 usecs
[    1.186016] initcall vmx_init+0x0/0x2ce returned with error code -95
[    1.187551] calling  svm_init+0x0/0x1e @ 1
[    1.188591] has_svm: not amd
[    1.189287] kvm: no hardware support
[    1.190154] initcall svm_init+0x0/0x1e returned -95 after 1528 usecs
[    1.191676] initcall svm_init+0x0/0x1e returned with error code -95
[    1.193248] calling  i8259A_init_ops+0x0/0x24 @ 1
[    1.194405] initcall i8259A_init_ops+0x0/0x24 returned 0 after 6 usecs
[    1.195965] calling  vsyscall_init+0x0/0x27 @ 1
[    1.197118] initcall vsyscall_init+0x0/0x27 returned 0 after 7 usecs
[    1.198643] calling  sbf_init+0x0/0xf2 @ 1
[    1.199641] initcall sbf_init+0x0/0xf2 returned 0 after 4 usecs
[    1.201105] calling  init_tsc_clocksource+0x0/0x85 @ 1
[    1.202335] initcall init_tsc_clocksource+0x0/0x85 returned 0 after 11 usecs
[    1.203994] calling  add_rtc_cmos+0x0/0x96 @ 1
[    1.205113] initcall add_rtc_cmos+0x0/0x96 returned 0 after 4 usecs
[    1.206390] calling  i8237A_init_ops+0x0/0x14 @ 1
[    1.207538] initcall i8237A_init_ops+0x0/0x14 returned 0 after 8 usecs
[    1.209163] calling  cache_sysfs_init+0x0/0x5f @ 1
[    1.210383] initcall cache_sysfs_init+0x0/0x5f returned 0 after 57 usecs
[    1.211988] calling  intel_uncore_init+0x0/0x3c8 @ 1
[    1.213245] initcall intel_uncore_init+0x0/0x3c8 returned -19 after 4 usecs
[    1.214922] calling  inject_init+0x0/0x60 @ 1
[    1.215976] Machine check injector initialized
[    1.217102] initcall inject_init+0x0/0x60 returned 0 after 1092 usecs
[    1.218649] calling  thermal_throttle_init_device+0x0/0x97 @ 1
[    1.220096] initcall thermal_throttle_init_device+0x0/0x97 returned
0 after 3 usecs
[    1.221927] calling  amd_ibs_init+0x0/0x37f @ 1
[    1.223029] initcall amd_ibs_init+0x0/0x37f returned -19 after 4 usecs
[    1.224327] calling  msr_init+0x0/0x12f @ 1
[    1.225619] initcall msr_init+0x0/0x12f returned 0 after 265 usecs
[    1.227110] calling  cpuid_init+0x0/0x12f @ 1
[    1.228415] initcall cpuid_init+0x0/0x12f returned 0 after 190 usecs
[    1.229948] calling  ioapic_init_ops+0x0/0x14 @ 1
[    1.231091] initcall ioapic_init_ops+0x0/0x14 returned 0 after 6 usecs
[    1.232698] calling  add_pcspkr+0x0/0x40 @ 1
[    1.233918] initcall add_pcspkr+0x0/0x40 returned 0 after 165 usecs
[    1.235444] calling  microcode_init+0x0/0x1b4 @ 1
[    1.236838] microcode: CPU0 sig=0x623, pf=0x0, revision=0x1
[    1.238387] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.240567] initcall microcode_init+0x0/0x1b4 returned 0 after 3824 usecs
[    1.242193] calling  pt_dump_init+0x0/0x30 @ 1
[    1.243293] initcall pt_dump_init+0x0/0x30 returned 0 after 17 usecs
[    1.244876] calling  proc_execdomains_init+0x0/0x22 @ 1
[    1.246156] initcall proc_execdomains_init+0x0/0x22 returned 0 after 12 usecs
[    1.247861] calling  ioresources_init+0x0/0x3c @ 1
[    1.249080] initcall ioresources_init+0x0/0x3c returned 0 after 10 usecs
[    1.250691] calling  uid_cache_init+0x0/0x8c @ 1
[    1.251836] initcall uid_cache_init+0x0/0x8c returned 0 after 21 usecs
[    1.253459] calling  init_posix_timers+0x0/0x203 @ 1
[    1.254686] initcall init_posix_timers+0x0/0x203 returned 0 after 17 usecs
[    1.256385] calling  init_posix_cpu_timers+0x0/0xc5 @ 1
[    1.257653] initcall init_posix_cpu_timers+0x0/0xc5 returned 0 after 4 usecs
[    1.259340] calling  proc_schedstat_init+0x0/0x22 @ 1
[    1.260616] initcall proc_schedstat_init+0x0/0x22 returned 0 after 8 usecs
[    1.262229] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    1.263560] initcall init_sched_debug_procfs+0x0/0x2c returned 0
after 14 usecs
[    1.265385] calling  snapshot_device_init+0x0/0x12 @ 1
[    1.266824] initcall snapshot_device_init+0x0/0x12 returned 0 after 193 usecs
[    1.268623] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    1.269884] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 7 usecs
[    1.271552] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    1.273133] initcall init_clocksource_sysfs+0x0/0x52 returned 0
after 237 usecs
[    1.274904] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    1.276270] initcall init_timer_list_procfs+0x0/0x2c returned 0
after 12 usecs
[    1.277991] calling  alarmtimer_init+0x0/0x1ad @ 1
[    1.279393] initcall alarmtimer_init+0x0/0x1ad returned 0 after 236 usecs
[    1.281096] calling  init_tstats_procfs+0x0/0x2c @ 1
[    1.282303] initcall init_tstats_procfs+0x0/0x2c returned 0 after 9 usecs
[    1.283929] calling  lockdep_proc_init+0x0/0x7c @ 1
[    1.285179] initcall lockdep_proc_init+0x0/0x7c returned 0 after 14 usecs
[    1.286807] calling  futex_init+0x0/0x6f @ 1
[    1.287863] initcall futex_init+0x0/0x6f returned 0 after 21 usecs
[    1.289402] calling  proc_dma_init+0x0/0x22 @ 1
[    1.290506] initcall proc_dma_init+0x0/0x22 returned 0 after 9 usecs
[    1.292051] calling  proc_modules_init+0x0/0x22 @ 1
[    1.293247] initcall proc_modules_init+0x0/0x22 returned 0 after 13 usecs
[    1.294800] calling  kallsyms_init+0x0/0x25 @ 1
[    1.295904] initcall kallsyms_init+0x0/0x25 returned 0 after 11 usecs
[    1.297511] calling  crash_save_vmcoreinfo_init+0x0/0x472 @ 1
[    1.298929] initcall crash_save_vmcoreinfo_init+0x0/0x472 returned
0 after 22 usecs
[    1.300819] calling  crash_notes_memory_init+0x0/0x37 @ 1
[    1.302129] initcall crash_notes_memory_init+0x0/0x37 returned 0
after 10 usecs
[    1.303884] calling  pid_namespaces_init+0x0/0x2d @ 1
[    1.305192] initcall pid_namespaces_init+0x0/0x2d returned 0 after 17 usecs
[    1.306866] calling  ikconfig_init+0x0/0x39 @ 1
[    1.307977] initcall ikconfig_init+0x0/0x39 returned 0 after 11 usecs
[    1.309577] calling  init_kprobes+0x0/0x198 @ 1
[    1.352853] initcall init_kprobes+0x0/0x198 returned 0 after 41187 usecs
[    1.354500] calling  hung_task_init+0x0/0x53 @ 1
[    1.355692] initcall hung_task_init+0x0/0x53 returned 0 after 68 usecs
[    1.357337] calling  irq_debugfs_init+0x0/0x2b @ 1
[    1.358523] initcall irq_debugfs_init+0x0/0x2b returned 0 after 19 usecs
[    1.360170] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    1.361322] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 6 usecs
[    1.362723] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    1.363944] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 14 usecs
[    1.365698] calling  init_tracepoints+0x0/0x20 @ 1
[    1.366874] initcall init_tracepoints+0x0/0x20 returned 0 after 4 usecs
[    1.368505] calling  init_lstats_procfs+0x0/0x25 @ 1
[    1.369723] initcall init_lstats_procfs+0x0/0x25 returned 0 after 13 usecs
[    1.371371] calling  stack_trace_init+0x0/0xa6 @ 1
[    1.372608] initcall stack_trace_init+0x0/0xa6 returned 0 after 27 usecs
[    1.374206] calling  init_mmio_trace+0x0/0x12 @ 1
[    1.375363] initcall init_mmio_trace+0x0/0x12 returned 0 after 7 usecs
[    1.376976] calling  init_blk_tracer+0x0/0x5c @ 1
[    1.378120] initcall init_blk_tracer+0x0/0x5c returned 0 after 8 usecs
[    1.379666] calling  perf_event_sysfs_init+0x0/0x9c @ 1
[    1.381582] initcall perf_event_sysfs_init+0x0/0x9c returned 0
after 540 usecs
[    1.383319] calling  init_per_zone_wmark_min+0x0/0x88 @ 1
[    1.384973] initcall init_per_zone_wmark_min+0x0/0x88 returned 0
after 264 usecs
[    1.386756] calling  kswapd_init+0x0/0x77 @ 1
[    1.387882] initcall kswapd_init+0x0/0x77 returned 0 after 70 usecs
[    1.389455] calling  extfrag_debug_init+0x0/0x7c @ 1
[    1.390697] initcall extfrag_debug_init+0x0/0x7c returned 0 after 36 usecs
[    1.392390] calling  setup_vmstat+0x0/0xbd @ 1
[    1.393493] initcall setup_vmstat+0x0/0xbd returned 0 after 22 usecs
[    1.395025] calling  mm_sysfs_init+0x0/0x29 @ 1
[    1.396182] initcall mm_sysfs_init+0x0/0x29 returned 0 after 10 usecs
[    1.397735] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    1.398922] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 9 usecs
[    1.400587] calling  procswaps_init+0x0/0x22 @ 1
[    1.401695] initcall procswaps_init+0x0/0x22 returned 0 after 9 usecs
[    1.403235] calling  hugetlb_init+0x0/0x4e7 @ 1
[    1.404386] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.405940] initcall hugetlb_init+0x0/0x4e7 returned 0 after 1521 usecs
[    1.407437] calling  mmu_notifier_init+0x0/0x20 @ 1
[    1.408677] initcall mmu_notifier_init+0x0/0x20 returned 0 after 8 usecs
[    1.410260] calling  slab_proc_init+0x0/0x25 @ 1
[    1.411402] initcall slab_proc_init+0x0/0x25 returned 0 after 15 usecs
[    1.413012] calling  slab_sysfs_init+0x0/0xfc @ 1
[    1.422815] initcall slab_sysfs_init+0x0/0xfc returned 0 after 8468 usecs
[    1.424494] calling  hugepage_init+0x0/0x177 @ 1
[    1.425996] initcall hugepage_init+0x0/0x177 returned 0 after 366 usecs
[    1.427599] calling  pfn_inject_init+0x0/0x160 @ 1
[    1.428916] initcall pfn_inject_init+0x0/0x160 returned 0 after 54 usecs
[    1.430533] calling  fcntl_init+0x0/0x2a @ 1
[    1.431583] initcall fcntl_init+0x0/0x2a returned 0 after 11 usecs
[    1.433138] calling  proc_filesystems_init+0x0/0x22 @ 1
[    1.434420] initcall proc_filesystems_init+0x0/0x22 returned 0 after 12 usecs
[    1.436170] calling  dio_init+0x0/0x2d @ 1
[    1.437360] initcall dio_init+0x0/0x2d returned 0 after 187 usecs
[    1.438834] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    1.440120] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 40 usecs
[    1.441812] calling  dnotify_init+0x0/0x7b @ 1
[    1.442844] initcall dnotify_init+0x0/0x7b returned 0 after 229 usecs
[    1.444509] calling  inotify_user_setup+0x0/0x70 @ 1
[    1.445746] initcall inotify_user_setup+0x0/0x70 returned 0 after 24 usecs
[    1.447405] calling  aio_setup+0x0/0x7f @ 1
[    1.448508] initcall aio_setup+0x0/0x7f returned 0 after 24 usecs
[    1.449970] calling  proc_locks_init+0x0/0x22 @ 1
[    1.451120] initcall proc_locks_init+0x0/0x22 returned 0 after 13 usecs
[    1.452763] calling  init_mbcache+0x0/0x14 @ 1
[    1.453851] initcall init_mbcache+0x0/0x14 returned 0 after 6 usecs
[    1.455348] calling  dquot_init+0x0/0x11d @ 1
[    1.456446] VFS: Disk quotas dquot_6.5.2
[    1.457606] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.459171] initcall dquot_init+0x0/0x11d returned 0 after 2663 usecs
[    1.460798] calling  proc_cmdline_init+0x0/0x22 @ 1
[    1.461990] initcall proc_cmdline_init+0x0/0x22 returned 0 after 9 usecs
[    1.463599] calling  proc_consoles_init+0x0/0x22 @ 1
[    1.464865] initcall proc_consoles_init+0x0/0x22 returned 0 after 8 usecs
[    1.466498] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    1.467684] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 9 usecs
[    1.469341] calling  proc_devices_init+0x0/0x22 @ 1
[    1.470522] initcall proc_devices_init+0x0/0x22 returned 0 after 12 usecs
[    1.472221] calling  proc_interrupts_init+0x0/0x22 @ 1
[    1.473461] initcall proc_interrupts_init+0x0/0x22 returned 0 after 12 usecs
[    1.475151] calling  proc_loadavg_init+0x0/0x22 @ 1
[    1.476415] initcall proc_loadavg_init+0x0/0x22 returned 0 after 11 usecs
[    1.478045] calling  proc_meminfo_init+0x0/0x22 @ 1
[    1.479250] initcall proc_meminfo_init+0x0/0x22 returned 0 after 15 usecs
[    1.480939] calling  proc_stat_init+0x0/0x22 @ 1
[    1.482068] initcall proc_stat_init+0x0/0x22 returned 0 after 9 usecs
[    1.483620] calling  proc_uptime_init+0x0/0x22 @ 1
[    1.484841] initcall proc_uptime_init+0x0/0x22 returned 0 after 8 usecs
[    1.486430] calling  proc_version_init+0x0/0x22 @ 1
[    1.487612] initcall proc_version_init+0x0/0x22 returned 0 after 9 usecs
[    1.489274] calling  proc_softirqs_init+0x0/0x22 @ 1
[    1.490484] initcall proc_softirqs_init+0x0/0x22 returned 0 after 9 usecs
[    1.492161] calling  proc_kcore_init+0x0/0xb5 @ 1
[    1.493330] initcall proc_kcore_init+0x0/0xb5 returned 0 after 22 usecs
[    1.494923] calling  vmcore_init+0x0/0x192 @ 1
[    1.496051] initcall vmcore_init+0x0/0x192 returned 0 after 3 usecs
[    1.497570] calling  proc_kmsg_init+0x0/0x25 @ 1
[    1.498698] initcall proc_kmsg_init+0x0/0x25 returned 0 after 9 usecs
[    1.500277] calling  proc_page_init+0x0/0x42 @ 1
[    1.501429] initcall proc_page_init+0x0/0x42 returned 0 after 17 usecs
[    1.502982] calling  configfs_init+0x0/0xa7 @ 1
[    1.504173] initcall configfs_init+0x0/0xa7 returned 0 after 44 usecs
[    1.505725] calling  init_devpts_fs+0x0/0x62 @ 1
[    1.506959] initcall init_devpts_fs+0x0/0x62 returned 0 after 108 usecs
[    1.508611] calling  init_dlm+0x0/0x77 @ 1
[    1.510215] DLM installed
[    1.510873] initcall init_dlm+0x0/0x77 returned 0 after 1238 usecs
[    1.512432] calling  init_reiserfs_fs+0x0/0x6f @ 1
[    1.513733] initcall init_reiserfs_fs+0x0/0x6f returned 0 after 138 usecs
[    1.515385] calling  init_ext3_fs+0x0/0x7b @ 1
[    1.516760] initcall init_ext3_fs+0x0/0x7b returned 0 after 238 usecs
[    1.518322] calling  init_ext2_fs+0x0/0x7b @ 1
[    1.519537] initcall init_ext2_fs+0x0/0x7b returned 0 after 128 usecs
[    1.521140] calling  ext4_init_fs+0x0/0x214 @ 1
[    1.522930] initcall ext4_init_fs+0x0/0x214 returned 0 after 674 usecs
[    1.524564] calling  journal_init+0x0/0xb4 @ 1
[    1.525990] initcall journal_init+0x0/0xb4 returned 0 after 336 usecs
[    1.527546] calling  journal_init+0x0/0x11e @ 1
[    1.528839] initcall journal_init+0x0/0x11e returned 0 after 143 usecs
[    1.530381] calling  init_cramfs_fs+0x0/0x2e @ 1
[    1.531533] initcall init_cramfs_fs+0x0/0x2e returned 0 after 22 usecs
[    1.533150] calling  init_squashfs_fs+0x0/0x75 @ 1
[    1.534521] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.535953] initcall init_squashfs_fs+0x0/0x75 returned 0 after 1593 usecs
[    1.537700] calling  init_ramfs_fs+0x0/0x12 @ 1
[    1.538810] initcall init_ramfs_fs+0x0/0x12 returned 0 after 8 usecs
[    1.540372] calling  init_hugetlbfs_fs+0x0/0x17b @ 1
[    1.541866] initcall init_hugetlbfs_fs+0x0/0x17b returned 0 after 283 usecs
[    1.543551] calling  init_minix_fs+0x0/0x67 @ 1
[    1.544869] initcall init_minix_fs+0x0/0x67 returned 0 after 125 usecs
[    1.546449] calling  init_fat_fs+0x0/0x4c @ 1
[    1.547633] initcall init_fat_fs+0x0/0x4c returned 0 after 220 usecs
[    1.549274] calling  init_vfat_fs+0x0/0x12 @ 1
[    1.550369] initcall init_vfat_fs+0x0/0x12 returned 0 after 6 usecs
[    1.551873] calling  init_msdos_fs+0x0/0x12 @ 1
[    1.553021] initcall init_msdos_fs+0x0/0x12 returned 0 after 5 usecs
[    1.554563] calling  init_iso9660_fs+0x0/0x7d @ 1
[    1.555843] initcall init_iso9660_fs+0x0/0x7d returned 0 after 141 usecs
[    1.557523] calling  vxfs_init+0x0/0x5a @ 1
[    1.558681] initcall vxfs_init+0x0/0x5a returned 0 after 143 usecs
[    1.560214] calling  init_nfs_fs+0x0/0x195 @ 1
[    1.561343] FS-Cache: Netfs 'nfs' registered for caching
[    1.563134] initcall init_nfs_fs+0x0/0x195 returned 0 after 1790 usecs
[    1.564816] calling  init_nfs_v2+0x0/0x14 @ 1
[    1.565913] initcall init_nfs_v2+0x0/0x14 returned 0 after 28 usecs
[    1.567427] calling  init_nfs_v3+0x0/0x14 @ 1
[    1.568542] initcall init_nfs_v3+0x0/0x14 returned 0 after 4 usecs
[    1.570007] calling  init_nfs_v4+0x0/0x3b @ 1
[    1.571062] NFS: Registering the id_resolver key type
[    1.572385] Key type id_resolver registered
[    1.573394] Key type id_legacy registered
[    1.574390] initcall init_nfs_v4+0x0/0x3b returned 0 after 3248 usecs
[    1.575930] calling  init_nlm+0x0/0x47 @ 1
[    1.576994] initcall init_nlm+0x0/0x47 returned 0 after 17 usecs
[    1.578446] calling  init_nls_cp437+0x0/0x12 @ 1
[    1.579581] initcall init_nls_cp437+0x0/0x12 returned 0 after 16 usecs
[    1.581191] calling  init_nls_ascii+0x0/0x12 @ 1
[    1.582319] initcall init_nls_ascii+0x0/0x12 returned 0 after 5 usecs
[    1.583860] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    1.585116] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 4 usecs
[    1.586749] calling  init_nls_utf8+0x0/0x25 @ 1
[    1.587846] initcall init_nls_utf8+0x0/0x25 returned 0 after 5 usecs
[    1.589413] calling  init_cifs+0x0/0x3d0 @ 1
[    1.590847] initcall init_cifs+0x0/0x3d0 returned 0 after 407 usecs
[    1.592441] calling  init_ntfs_fs+0x0/0x1ce @ 1
[    1.593479] NTFS driver 2.1.30 [Flags: R/O].
[    1.594836] initcall init_ntfs_fs+0x0/0x1ce returned 0 after 1324 usecs
[    1.596495] calling  init_romfs_fs+0x0/0x84 @ 1
[    1.597601] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.598775] initcall init_romfs_fs+0x0/0x84 returned 0 after 1146 usecs
[    1.600435] calling  init_autofs4_fs+0x0/0x2a @ 1
[    1.601700] initcall init_autofs4_fs+0x0/0x2a returned 0 after 122 usecs
[    1.603317] calling  init_udf_fs+0x0/0x67 @ 1
[    1.604560] initcall init_udf_fs+0x0/0x67 returned 0 after 120 usecs
[    1.606087] calling  init_omfs_fs+0x0/0x12 @ 1
[    1.607174] initcall init_omfs_fs+0x0/0x12 returned 0 after 6 usecs
[    1.608729] calling  init_btrfs_fs+0x0/0xc3 @ 1
[    1.610835] Btrfs loaded
[    1.611467] initcall init_btrfs_fs+0x0/0xc3 returned 0 after 1600 usecs
[    1.613126] calling  init_gfs2_fs+0x0/0x343 @ 1
[    1.615057] GFS2 installed
[    1.615731] initcall init_gfs2_fs+0x0/0x343 returned 0 after 1479 usecs
[    1.617389] calling  init_pstore_fs+0x0/0x12 @ 1
[    1.618522] initcall init_pstore_fs+0x0/0x12 returned 0 after 7 usecs
[    1.620089] calling  ipc_init+0x0/0x2f @ 1
[    1.621102] msgmni has been set to 11874
[    1.622068] initcall ipc_init+0x0/0x2f returned 0 after 958 usecs
[    1.623523] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    1.624743] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 14 usecs
[    1.626342] calling  init_mqueue_fs+0x0/0xb3 @ 1
[    1.627785] initcall init_mqueue_fs+0x0/0xb3 returned 0 after 312 usecs
[    1.629412] calling  key_proc_init+0x0/0x33 @ 1
[    1.630526] initcall key_proc_init+0x0/0x33 returned 0 after 14 usecs
[    1.632111] calling  crypto_wq_init+0x0/0x38 @ 1
[    1.633283] initcall crypto_wq_init+0x0/0x38 returned 0 after 53 usecs
[    1.634856] calling  crypto_algapi_init+0x0/0xd @ 1
[    1.636091] initcall crypto_algapi_init+0x0/0xd returned 0 after 8 usecs
[    1.637699] calling  skcipher_module_init+0x0/0x36 @ 1
[    1.638944] initcall skcipher_module_init+0x0/0x36 returned 0 after 4 usecs
[    1.640663] calling  chainiv_module_init+0x0/0x12 @ 1
[    1.641917] initcall chainiv_module_init+0x0/0x12 returned 0 after 30 usecs
[    1.643583] calling  eseqiv_module_init+0x0/0x12 @ 1
[    1.644842] initcall eseqiv_module_init+0x0/0x12 returned 0 after 5 usecs
[    1.646479] calling  hmac_module_init+0x0/0x12 @ 1
[    1.647644] initcall hmac_module_init+0x0/0x12 returned 0 after 6 usecs
[    1.649277] calling  md4_mod_init+0x0/0x12 @ 1
[    1.650486] initcall md4_mod_init+0x0/0x12 returned 0 after 152 usecs
[    1.651935] calling  md5_mod_init+0x0/0x12 @ 1
[    1.653191] initcall md5_mod_init+0x0/0x12 returned 0 after 84 usecs
[    1.654727] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    1.656164] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 86 usecs
[    1.657887] calling  sha256_generic_mod_init+0x0/0x17 @ 1
[    1.659008] initcall sha256_generic_mod_init+0x0/0x17 returned 0
after 121 usecs
[    1.660858] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    1.662151] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 6 usecs
[    1.663859] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    1.665205] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 5 usecs
[    1.666914] calling  des_generic_mod_init+0x0/0x17 @ 1
[    1.668328] initcall des_generic_mod_init+0x0/0x17 returned 0 after 122 usecs
[    1.670041] calling  aes_init+0x0/0x12 @ 1
[    1.671097] initcall aes_init+0x0/0x12 returned 0 after 58 usecs
[    1.672604] calling  arc4_init+0x0/0x17 @ 1
[    1.673732] initcall arc4_init+0x0/0x17 returned 0 after 111 usecs
[    1.675234] calling  michael_mic_init+0x0/0x12 @ 1
[    1.676521] initcall michael_mic_init+0x0/0x12 returned 0 after 62 usecs
[    1.678129] calling  crc32c_mod_init+0x0/0x12 @ 1
[    1.679329] initcall crc32c_mod_init+0x0/0x12 returned 0 after 58 usecs
[    1.680974] calling  krng_mod_init+0x0/0x12 @ 1
[    1.682180] initcall krng_mod_init+0x0/0x12 returned 0 after 94 usecs
[    1.683711] calling  async_tx_init+0x0/0x1b @ 1
[    1.684913] async_tx: api initialized (async)
[    1.685980] initcall async_tx_init+0x0/0x1b returned 0 after 1064 usecs
[    1.687649] calling  async_pq_init+0x0/0x3b @ 1
[    1.688796] initcall async_pq_init+0x0/0x3b returned 0 after 6 usecs
[    1.690328] calling  proc_genhd_init+0x0/0x3c @ 1
[    1.691486] initcall proc_genhd_init+0x0/0x3c returned 0 after 17 usecs
[    1.693134] calling  bsg_init+0x0/0x16f @ 1
[    1.694411] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 251)
[    1.696265] initcall bsg_init+0x0/0x16f returned 0 after 2063 usecs
[    1.697765] calling  throtl_init+0x0/0x49 @ 1
[    1.698909] initcall throtl_init+0x0/0x49 returned 0 after 88 usecs
[    1.700483] calling  noop_init+0x0/0x12 @ 1
[    1.701516] io scheduler noop registered
[    1.702477] initcall noop_init+0x0/0x12 returned 0 after 950 usecs
[    1.703955] calling  deadline_init+0x0/0x12 @ 1
[    1.705111] io scheduler deadline registered
[    1.706149] initcall deadline_init+0x0/0x12 returned 0 after 1014 usecs
[    1.707736] calling  cfq_init+0x0/0xb5 @ 1
[    1.709045] io scheduler cfq registered (default)
[    1.710168] initcall cfq_init+0x0/0xb5 returned 0 after 1360 usecs
[    1.711640] calling  plist_test+0x0/0x145 @ 1
[    1.713840] initcall plist_test+0x0/0x145 returned 0 after 1044 usecs
[    1.715299] calling  libcrc32c_mod_init+0x0/0x2a @ 1
[    1.716549] initcall libcrc32c_mod_init+0x0/0x2a returned 0 after 15 usecs
[    1.718200] calling  percpu_counter_startup+0x0/0x19 @ 1
[    1.719496] initcall percpu_counter_startup+0x0/0x19 returned 0 after 9 usecs
[    1.721467] calling  bgpio_driver_init+0x0/0x12 @ 1
[    1.722810] initcall bgpio_driver_init+0x0/0x12 returned 0 after 147 usecs
[    1.724534] calling  amd_gpio_init+0x0/0x170 @ 1
[    1.725664] initcall amd_gpio_init+0x0/0x170 returned -19 after 11 usecs
[    1.727274] calling  ichx_gpio_driver_init+0x0/0x12 @ 1
[    1.728682] initcall ichx_gpio_driver_init+0x0/0x12 returned 0 after 93 usecs
[    1.730416] calling  it8761e_gpio_init+0x0/0x19e @ 1
[    1.731695] initcall it8761e_gpio_init+0x0/0x19e returned -19 after 72 usecs
[    1.733087] calling  pci_proc_init+0x0/0x69 @ 1
[    1.734227] initcall pci_proc_init+0x0/0x69 returned 0 after 35 usecs
[    1.735784] calling  pcie_portdrv_init+0x0/0x77 @ 1
[    1.737203] initcall pcie_portdrv_init+0x0/0x77 returned 0 after 184 usecs
[    1.738873] calling  aer_service_init+0x0/0x22 @ 1
[    1.740182] initcall aer_service_init+0x0/0x22 returned 0 after 101 usecs
[    1.741821] calling  aer_inject_init+0x0/0x12 @ 1
[    1.743110] initcall aer_inject_init+0x0/0x12 returned 0 after 151 usecs
[    1.744820] calling  pcie_pme_service_init+0x0/0x12 @ 1
[    1.746231] initcall pcie_pme_service_init+0x0/0x12 returned 0
after 136 usecs
[    1.747979] calling  ioapic_init+0x0/0x1b @ 1
[    1.748987] initcall ioapic_init+0x0/0x1b returned 0 after 119 usecs
[    1.750518] calling  pci_hotplug_init+0x0/0x4c @ 1
[    1.751681] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.753099] initcall pci_hotplug_init+0x0/0x4c returned 0 after 1377 usecs
[    1.754759] calling  pcied_init+0x0/0xaf @ 1
[    1.756170] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.757775] initcall pcied_init+0x0/0xaf returned 0 after 1926 usecs
[    1.759292] calling  zt5550_init+0x0/0x80 @ 1
[    1.760403] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    1.762141] initcall zt5550_init+0x0/0x80 returned 0 after 1699 usecs
[    1.763695] calling  cpcihp_generic_init+0x0/0x449 @ 1
[    1.765006] cpcihp_generic: Generic port I/O CompactPCI Hot Plug
Driver version: 0.1
[    1.766866] cpcihp_generic: not configured, disabling.
[    1.767943] initcall cpcihp_generic_init+0x0/0x449 returned -22
after 2871 usecs
[    1.769765] initcall cpcihp_generic_init+0x0/0x449 returned with
error code -22
[    1.771529] calling  shpcd_init+0x0/0xf5 @ 1
[    1.772772] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.774394] initcall shpcd_init+0x0/0xf5 returned 0 after 1732 usecs
[    1.775927] calling  acpiphp_init+0x0/0x50 @ 1
[    1.777097] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.778939] pci_bus 0000:00: dev 03, created physical slot 3
[    1.780548] acpiphp: Slot [3] registered
[    1.781548] pci_bus 0000:00: dev 04, created physical slot 4
[    1.782994] acpiphp: Slot [4] registered
[    1.783987] pci_bus 0000:00: dev 05, created physical slot 5
[    1.785518] acpiphp: Slot [5] registered
[    1.786504] pci_bus 0000:00: dev 06, created physical slot 6
[    1.787950] acpiphp: Slot [6] registered
[    1.788997] pci_bus 0000:00: dev 07, created physical slot 7
[    1.790456] acpiphp: Slot [7] registered
[    1.791444] pci_bus 0000:00: dev 08, created physical slot 8
[    1.792958] acpiphp: Slot [8] registered
[    1.793946] pci_bus 0000:00: dev 09, created physical slot 9
[    1.795411] acpiphp: Slot [9] registered
[    1.796460] pci_bus 0000:00: dev 0a, created physical slot 10
[    1.797932] acpiphp: Slot [10] registered
[    1.798946] pci_bus 0000:00: dev 0b, created physical slot 11
[    1.800490] acpiphp: Slot [11] registered
[    1.801509] pci_bus 0000:00: dev 0c, created physical slot 12
[    1.803003] acpiphp: Slot [12] registered
[    1.804097] pci_bus 0000:00: dev 0d, created physical slot 13
[    1.805638] acpiphp: Slot [13] registered
[    1.806669] pci_bus 0000:00: dev 0e, created physical slot 14
[    1.808234] acpiphp: Slot [14] registered
[    1.809261] pci_bus 0000:00: dev 0f, created physical slot 15
[    1.810729] acpiphp: Slot [15] registered
[    1.811740] pci_bus 0000:00: dev 10, created physical slot 16
[    1.813290] acpiphp: Slot [16] registered
[    1.814305] pci_bus 0000:00: dev 11, created physical slot 17
[    1.815762] acpiphp: Slot [17] registered
[    1.816833] pci_bus 0000:00: dev 12, created physical slot 18
[    1.818313] acpiphp: Slot [18] registered
[    1.819313] pci_bus 0000:00: dev 13, created physical slot 19
[    1.820852] acpiphp: Slot [19] registered
[    1.821866] pci_bus 0000:00: dev 14, created physical slot 20
[    1.823328] acpiphp: Slot [20] registered
[    1.824404] pci_bus 0000:00: dev 15, created physical slot 21
[    1.825879] acpiphp: Slot [21] registered
[    1.826889] pci_bus 0000:00: dev 16, created physical slot 22
[    1.828416] acpiphp: Slot [22] registered
[    1.829432] pci_bus 0000:00: dev 17, created physical slot 23
[    1.830938] acpiphp: Slot [23] registered
[    1.831977] pci_bus 0000:00: dev 18, created physical slot 24
[    1.833512] acpiphp: Slot [24] registered
[    1.834543] pci_bus 0000:00: dev 19, created physical slot 25
[    1.836131] acpiphp: Slot [25] registered
[    1.837169] pci_bus 0000:00: dev 1a, created physical slot 26
[    1.838666] acpiphp: Slot [26] registered
[    1.839685] pci_bus 0000:00: dev 1b, created physical slot 27
[    1.840974] acpiphp: Slot [27] registered
[    1.841989] pci_bus 0000:00: dev 1c, created physical slot 28
[    1.843467] acpiphp: Slot [28] registered
[    1.844557] pci_bus 0000:00: dev 1d, created physical slot 29
[    1.846026] acpiphp: Slot [29] registered
[    1.847058] pci_bus 0000:00: dev 1e, created physical slot 30
[    1.848571] acpiphp: Slot [30] registered
[    1.849545] pci_bus 0000:00: dev 1f, created physical slot 31
[    1.850982] acpiphp: Slot [31] registered
[    1.852506] initcall acpiphp_init+0x0/0x50 returned 0 after 73636 usecs
[    1.854024] calling  ibm_acpiphp_init+0x0/0x188 @ 1
[    1.856983] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    1.858491] initcall ibm_acpiphp_init+0x0/0x188 returned -19 after 3250 usecs
[    1.860128] calling  pci_stub_init+0x0/0x140 @ 1
[    1.861238] initcall pci_stub_init+0x0/0x140 returned 0 after 152 usecs
[    1.862752] calling  tsi721_init+0x0/0x1b @ 1
[    1.863993] initcall tsi721_init+0x0/0x1b returned 0 after 138 usecs
[    1.865652] calling  fb_console_init+0x0/0x112 @ 1
[    1.867103] initcall fb_console_init+0x0/0x112 returned 0 after 268 usecs
[    1.868839] calling  genericbl_driver_init+0x0/0x12 @ 1
[    1.870293] initcall genericbl_driver_init+0x0/0x12 returned 0
after 127 usecs
[    1.872087] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    1.873388] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 8 usecs
[    1.875113] calling  irqrouter_init_ops+0x0/0x29 @ 1
[    1.876373] initcall irqrouter_init_ops+0x0/0x29 returned 0 after 5 usecs
[    1.878013] calling  acpi_ac_init+0x0/0x30 @ 1
[    1.879227] initcall acpi_ac_init+0x0/0x30 returned 0 after 120 usecs
[    1.880840] calling  acpi_button_driver_init+0x0/0x12 @ 1
[    1.882360] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.884230] ACPI: Power Button [PWRF]
[    1.885277] initcall acpi_button_driver_init+0x0/0x12 returned 0
after 3053 usecs
[    1.887079] calling  acpi_fan_driver_init+0x0/0x12 @ 1
[    1.888492] initcall acpi_fan_driver_init+0x0/0x12 returned 0 after 102 usecs
[    1.890182] calling  acpi_video_init+0x0/0x91 @ 1
[    1.891499] initcall acpi_video_init+0x0/0x91 returned 0 after 163 usecs
[    1.893222] calling  acpi_processor_init+0x0/0x6d @ 1
[    1.897447] initcall acpi_processor_init+0x0/0x6d returned 0 after 2906 usecs
[    1.898199] calling  acpi_container_init+0x0/0x4a @ 1
[    1.900662] initcall acpi_container_init+0x0/0x4a returned 0 after 1891 usecs
[    1.901380] calling  acpi_thermal_init+0x0/0x42 @ 1
[    1.901987] initcall acpi_thermal_init+0x0/0x42 returned 0 after 111 usecs
[    1.902925] calling  acpi_memory_device_init+0x0/0x71 @ 1
[    1.906021] initcall acpi_memory_device_init+0x0/0x71 returned 0
after 1994 usecs
[    1.907733] calling  acpi_battery_init+0x0/0x16 @ 1
[    1.908957] initcall acpi_battery_init+0x0/0x16 returned 0 after 24 usecs
[    1.910509] calling  acpi_hed_driver_init+0x0/0x12 @ 1
[    1.911770] calling  1_acpi_battery_init_async+0x0/0x1b @ 6
[    1.913364] initcall acpi_hed_driver_init+0x0/0x12 returned 0 after
1626 usecs
[    1.915011] calling  bgrt_init+0x0/0xbb @ 1
[    1.915991] initcall bgrt_init+0x0/0xbb returned -19 after 6 usecs
[    1.917462] calling  acpi_pad_init+0x0/0xca @ 1
[    1.918570] initcall acpi_pad_init+0x0/0xca returned -22 after 6 usecs
[    1.920141] initcall acpi_pad_init+0x0/0xca returned with error code -22
[    1.921628] calling  ioat_init_module+0x0/0x7f @ 1
[    1.922759] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.924456] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0
after 11067 usecs
[    1.926494] initcall ioat_init_module+0x0/0x7f returned 0 after 3642 usecs
[    1.928198] calling  td_driver_init+0x0/0x12 @ 1
[    1.929470] initcall td_driver_init+0x0/0x12 returned 0 after 124 usecs
[    1.931057] calling  pch_dma_init+0x0/0x1b @ 1
[    1.932060] initcall pch_dma_init+0x0/0x1b returned 0 after 159 usecs
[    1.933606] calling  virtio_pci_init+0x0/0x1b @ 1
[    1.934858] initcall virtio_pci_init+0x0/0x1b returned 0 after 103 usecs
[    1.936541] calling  init+0x0/0x12 @ 1
[    1.937484] initcall init+0x0/0x12 returned 0 after 97 usecs
[    1.938844] calling  pty_init+0x0/0x3a3 @ 1
[    1.985004] initcall pty_init+0x0/0x3a3 returned 0 after 44090 usecs
[    1.986514] calling  sysrq_init+0x0/0x78 @ 1
[    1.987570] initcall sysrq_init+0x0/0x78 returned 0 after 16 usecs
[    1.989139] calling  serial8250_init+0x0/0x178 @ 1
[    1.990306] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.013382] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.016119] initcall serial8250_init+0x0/0x178 returned 0 after 25201 usecs
[    2.017644] calling  serial_pci_driver_init+0x0/0x1b @ 1
[    2.019093] initcall serial_pci_driver_init+0x0/0x1b returned 0
after 136 usecs
[    2.020921] calling  jsm_init_module+0x0/0x45 @ 1
[    2.022208] initcall jsm_init_module+0x0/0x45 returned 0 after 135 usecs
[    2.023825] calling  rand_initialize+0x0/0x40 @ 1
[    2.025073] initcall rand_initialize+0x0/0x40 returned 0 after 43 usecs
[    2.026671] calling  raw_init+0x0/0x141 @ 1
[    2.027915] initcall raw_init+0x0/0x141 returned 0 after 214 usecs
[    2.029503] calling  nvram_init+0x0/0x7f @ 1
[    2.030731] Non-volatile memory driver v1.3
[    2.031762] initcall nvram_init+0x0/0x7f returned 0 after 1193 usecs
[    2.033389] calling  mod_init+0x0/0x218 @ 1
[    2.034488] initcall mod_init+0x0/0x218 returned -19 after 66 usecs
[    2.036091] calling  mod_init+0x0/0x12f @ 1
[    2.037129] initcall mod_init+0x0/0x12f returned -19 after 10 usecs
[    2.038640] calling  mod_init+0x0/0x51 @ 1
[    2.039643] initcall mod_init+0x0/0x51 returned -19 after 4 usecs
[    2.041161] calling  init+0x0/0x12 @ 1
[    2.042182] initcall init+0x0/0x12 returned 0 after 100 usecs
[    2.043547] calling  rng_init+0x0/0x12 @ 1
[    2.044903] initcall rng_init+0x0/0x12 returned 0 after 251 usecs
[    2.046449] calling  agp_init+0x0/0x29 @ 1
[    2.047488] Linux agpgart interface v0.103
[    2.048559] initcall agp_init+0x0/0x29 returned 0 after 1038 usecs
[    2.049979] calling  agp_amd64_mod_init+0x0/0x21 @ 1
[    2.051481] initcall agp_amd64_mod_init+0x0/0x21 returned -19 after 285 usecs
[    2.053283] calling  agp_intel_init+0x0/0x2c @ 1
[    2.054758] initcall agp_intel_init+0x0/0x2c returned 0 after 334 usecs
[    2.056436] calling  init_tis+0x0/0x9c @ 1
[    2.057540] initcall init_tis+0x0/0x9c returned 0 after 96 usecs
[    2.058985] calling  init_nsc+0x0/0x1cd @ 1
[    2.059787] initcall init_nsc+0x0/0x1cd returned -19 after 30 usecs
[    2.061365] calling  init_atmel+0x0/0x187 @ 1
[    2.062606] initcall init_atmel+0x0/0x187 returned -19 after 178 usecs
[    2.064238] calling  drm_core_init+0x0/0x136 @ 1
[    2.065481] [drm] Initialized drm 1.1.0 20060810
[    2.066679] initcall drm_core_init+0x0/0x136 returned 0 after 1272 usecs
[    2.068354] calling  ttm_init+0x0/0x62 @ 1
[    2.069490] initcall ttm_init+0x0/0x62 returned 0 after 130 usecs
[    2.070961] calling  mga_init+0x0/0x25 @ 1
[    2.071969] initcall mga_init+0x0/0x25 returned 0 after 14 usecs
[    2.073466] calling  i915_init+0x0/0x68 @ 1
[    2.074674] initcall i915_init+0x0/0x68 returned 0 after 167 usecs
[    2.076299] calling  mgag200_init+0x0/0x3b @ 1
[    2.077565] initcall mgag200_init+0x0/0x3b returned 0 after 151 usecs
[    2.079122] calling  nouveau_drm_init+0x0/0x4f @ 1
[    2.080509] initcall nouveau_drm_init+0x0/0x4f returned 0 after 144 usecs
[    2.082157] calling  udl_init+0x0/0x19 @ 1
[    2.083255] usbcore: registered new interface driver udl
[    2.084624] initcall udl_init+0x0/0x19 returned 0 after 1427 usecs
[    2.086113] calling  sil164_init+0x0/0x14 @ 1
[    2.087281] initcall sil164_init+0x0/0x14 returned 0 after 106 usecs
[    2.088878] calling  cn_proc_init+0x0/0x3a @ 1
[    2.089989] initcall cn_proc_init+0x0/0x3a returned 0 after 26 usecs
[    2.091547] calling  topology_sysfs_init+0x0/0x5b @ 1
[    2.092833] initcall topology_sysfs_init+0x0/0x5b returned 0 after 17 usecs
[    2.094564] calling  brd_init+0x0/0x1a6 @ 1
[    2.099878] brd: module loaded
[    2.100502] initcall brd_init+0x0/0x1a6 returned 0 after 4795 usecs
[    2.102022] calling  loop_init+0x0/0x135 @ 1
[    2.105920] loop: module loaded
[    2.106733] initcall loop_init+0x0/0x135 returned 0 after 3597 usecs
[    2.108418] calling  nvme_init+0x0/0xa8 @ 1
[    2.109748] initcall nvme_init+0x0/0xa8 returned 0 after 291 usecs
[    2.111212] calling  init+0x0/0x8b @ 1
[    2.112362] initcall init+0x0/0x8b returned 0 after 130 usecs
[    2.113750] calling  mtip_init+0x0/0xd0 @ 1
[    2.114780] mtip32xx Version 1.2.6os3
[    2.115782] initcall mtip_init+0x0/0xd0 returned 0 after 978 usecs
[    2.117349] calling  tifm_7xx1_driver_init+0x0/0x1b @ 1
[    2.118733] initcall tifm_7xx1_driver_init+0x0/0x1b returned 0
after 113 usecs
[    2.120548] calling  enclosure_init+0x0/0x19 @ 1
[    2.121763] initcall enclosure_init+0x0/0x19 returned 0 after 91 usecs
[    2.123332] calling  at24_init+0x0/0x46 @ 1
[    2.124514] initcall at24_init+0x0/0x46 returned 0 after 91 usecs
[    2.125982] calling  cb710_init_module+0x0/0x1b @ 1
[    2.127275] initcall cb710_init_module+0x0/0x1b returned 0 after 105 usecs
[    2.129028] calling  lpc_sch_driver_init+0x0/0x1b @ 1
[    2.130397] initcall lpc_sch_driver_init+0x0/0x1b returned 0 after 96 usecs
[    2.132127] calling  lpc_ich_init+0x0/0x1b @ 1
[    2.133322] initcall lpc_ich_init+0x0/0x1b returned 0 after 135 usecs
[    2.134900] calling  scsi_tgt_init+0x0/0x8f @ 1
[    2.136345] initcall scsi_tgt_init+0x0/0x8f returned 0 after 223 usecs
[    2.137968] calling  raid_init+0x0/0x12 @ 1
[    2.139144] initcall raid_init+0x0/0x12 returned 0 after 120 usecs
[    2.140723] calling  spi_transport_init+0x0/0x7a @ 1
[    2.142118] initcall spi_transport_init+0x0/0x7a returned 0 after 173 usecs
[    2.143618] calling  fc_transport_init+0x0/0x8a @ 1
[    2.145174] initcall fc_transport_init+0x0/0x8a returned 0 after 278 usecs
[    2.146839] calling  iscsi_transport_init+0x0/0x18c @ 1
[    2.148162] Loading iSCSI transport class v2.0-870.
[    2.149802] initcall iscsi_transport_init+0x0/0x18c returned 0
after 1602 usecs
[    2.151569] calling  sas_transport_init+0x0/0xcc @ 1
[    2.153283] initcall sas_transport_init+0x0/0xcc returned 0 after 423 usecs
[    2.154964] calling  sas_class_init+0x0/0x34 @ 1
[    2.156165] initcall sas_class_init+0x0/0x34 returned 0 after 16 usecs
[    2.157735] calling  srp_transport_init+0x0/0x3c @ 1
[    2.159091] initcall srp_transport_init+0x0/0x3c returned 0 after 153 usecs
[    2.160844] calling  scsi_dh_init+0x0/0x3c @ 1
[    2.161929] initcall scsi_dh_init+0x0/0x3c returned 0 after 6 usecs
[    2.163409] calling  rdac_init+0x0/0x7b @ 1
[    2.164531] rdac: device handler registered
[    2.165662] initcall rdac_init+0x0/0x7b returned 0 after 1133 usecs
[    2.167228] calling  libfc_init+0x0/0x3b @ 1
[    2.168359] initcall libfc_init+0x0/0x3b returned 0 after 126 usecs
[    2.169881] calling  fcoe_init+0x0/0x1d5 @ 1
[    2.171070] initcall fcoe_init+0x0/0x1d5 returned 0 after 158 usecs
[    2.172657] calling  libfcoe_init+0x0/0x2a @ 1
[    2.173873] initcall libfcoe_init+0x0/0x2a returned 0 after 127 usecs
[    2.175438] calling  iscsi_sw_tcp_init+0x0/0x42 @ 1
[    2.176855] iscsi: registered transport (tcp)
[    2.177928] initcall iscsi_sw_tcp_init+0x0/0x42 returned 0 after 1188 usecs
[    2.179602] calling  ahc_linux_init+0x0/0x63 @ 1
[    2.180900] initcall ahc_linux_init+0x0/0x63 returned 0 after 113 usecs
[    2.182500] calling  ahd_linux_init+0x0/0x7e @ 1
[    2.183719] initcall ahd_linux_init+0x0/0x7e returned 0 after 97 usecs
[    2.185362] calling  aac_init+0x0/0x79 @ 1
[    2.186389] Adaptec aacraid driver 1.2-0[29800]-ms
[    2.187661] initcall aac_init+0x0/0x79 returned 0 after 1243 usecs
[    2.189211] calling  aic94xx_init+0x0/0x150 @ 1
[    2.190312] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    2.192127] initcall aic94xx_init+0x0/0x150 returned 0 after 1767 usecs
[    2.193700] calling  isci_init+0x0/0x70 @ 1
[    2.194741] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.196584] initcall isci_init+0x0/0x70 returned 0 after 1793 usecs
[    2.198112] calling  qla1280_init+0x0/0x1b @ 1
[    2.199358] initcall qla1280_init+0x0/0x1b returned 0 after 156 usecs
[    2.200997] calling  qla2x00_module_init+0x0/0x215 @ 1
[    2.202275] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
Driver: 8.04.00.07-k.
[    2.204409] initcall qla2x00_module_init+0x0/0x215 returned 0 after
2112 usecs
[    2.206148] calling  qla4xxx_module_init+0x0/0xe8 @ 1
[    2.207497] iscsi: registered transport (qla4xxx)
[    2.208794] QLogic iSCSI HBA Driver
[    2.209661] initcall qla4xxx_module_init+0x0/0xe8 returned 0 after 2221 usecs
[    2.211381] calling  lpfc_init+0x0/0xfb @ 1
[    2.212460] Emulex LightPulse Fibre Channel SCSI driver 8.3.35
[    2.213865] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[    2.215534] initcall lpfc_init+0x0/0xfb returned 0 after 3006 usecs
[    2.217116] calling  bfad_init+0x0/0xa7 @ 1
[    2.218135] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
[    2.219554] initcall bfad_init+0x0/0xa7 returned 0 after 1386 usecs
[    2.221125] calling  sym2_init+0x0/0xff @ 1
[    2.222256] initcall sym2_init+0x0/0xff returned 0 after 103 usecs
[    2.223721] calling  megaraid_init+0x0/0xb9 @ 1
[    2.225109] initcall megaraid_init+0x0/0xb9 returned 0 after 170 usecs
[    2.226716] calling  mraid_mm_init+0x0/0x8e @ 1
[    2.227829] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16
00:01:03 EST 2006)
[    2.229832] initcall mraid_mm_init+0x0/0x8e returned 0 after 1947 usecs
[    2.231438] calling  megaraid_init+0x0/0x95 @ 1
[    2.232606] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.234418] initcall megaraid_init+0x0/0x95 returned 0 after 1771 usecs
[    2.236126] calling  megasas_init+0x0/0x1c8 @ 1
[    2.237226] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
[    2.238785] tsc: Refined TSC clocksource calibration: 2491.905 MHz
[    2.240336] Switching to clocksource tsc
[    2.241398] initcall megasas_init+0x0/0x1c8 returned 0 after 4072 usecs
[    2.242993] calling  _scsih_init+0x0/0x188 @ 1
[    2.244100] mpt2sas version 14.100.00.00 loaded
[    2.245402] initcall _scsih_init+0x0/0x188 returned 0 after 1272 usecs
[    2.246980] calling  ufshcd_pci_driver_init+0x0/0x1b @ 1
[    2.248388] initcall ufshcd_pci_driver_init+0x0/0x1b returned 0
after 83 usecs
[    2.250132] calling  mvs_init+0x0/0xa1 @ 1
[    2.251215] initcall mvs_init+0x0/0xa1 returned 0 after 96 usecs
[    2.252708] calling  init_st+0x0/0x18f @ 1
[    2.253684] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.255461] initcall init_st+0x0/0x18f returned 0 after 1737 usecs
[    2.257052] calling  init_sd+0x0/0x133 @ 1
[    2.258238] initcall init_sd+0x0/0x133 returned 0 after 193 usecs
[    2.259729] calling  init_sr+0x0/0x46 @ 1
[    2.260859] initcall init_sr+0x0/0x46 returned 0 after 98 usecs
[    2.262295] calling  init_sg+0x0/0x12c @ 1
[    2.263407] initcall init_sg+0x0/0x12c returned 0 after 118 usecs
[    2.264931] calling  init_ch_module+0x0/0xb5 @ 1
[    2.266049] SCSI Media Changer driver v0.25
[    2.267216] initcall init_ch_module+0x0/0xb5 returned 0 after 1140 usecs
[    2.268877] calling  ses_init+0x0/0x3c @ 1
[    2.269957] initcall ses_init+0x0/0x3c returned 0 after 77 usecs
[    2.271416] calling  osd_uld_init+0x0/0xc3 @ 1
[    2.272653] osd: LOADED open-osd 0.2.1
[    2.273565] initcall osd_uld_init+0x0/0xc3 returned 0 after 1017 usecs
[    2.275220] calling  ahci_pci_driver_init+0x0/0x1b @ 1
[    2.276597] initcall ahci_pci_driver_init+0x0/0x1b returned 0 after 95 usecs
[    2.278296] calling  arasan_cf_driver_init+0x0/0x12 @ 1
[    2.279629] initcall arasan_cf_driver_init+0x0/0x12 returned 0 after 72 usecs
[    2.281390] calling  piix_init+0x0/0x29 @ 1
[    2.282418] ata_piix 0000:00:01.1: version 2.13
[    2.283596] ata_piix 0000:00:01.1: enabling bus mastering
[    2.285019] ata_piix 0000:00:01.1: setting latency timer to 64
[    2.287908] scsi0 : ata_piix
[    2.288884] scsi1 : ata_piix
[    2.289821] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
[    2.291484] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
[    2.293229] calling  2_async_port_probe+0x0/0x60 @ 15
[    2.294775] calling  3_async_port_probe+0x0/0x60 @ 6
[    2.296338] initcall piix_init+0x0/0x29 returned 0 after 13608 usecs
[    2.297885] calling  mv_init+0x0/0x45 @ 1
[    2.299009] initcall mv_init+0x0/0x45 returned 0 after 149 usecs
[    2.300512] calling  nv_pci_driver_init+0x0/0x1b @ 1
[    2.301797] initcall nv_pci_driver_init+0x0/0x1b returned 0 after 86 usecs
[    2.303457] calling  sil_pci_driver_init+0x0/0x1b @ 1
[    2.304807] initcall sil_pci_driver_init+0x0/0x1b returned 0 after 91 usecs
[    2.306491] calling  k2_sata_pci_driver_init+0x0/0x1b @ 1
[    2.307876] initcall k2_sata_pci_driver_init+0x0/0x1b returned 0
after 82 usecs
[    2.309688] calling  svia_pci_driver_init+0x0/0x1b @ 1
[    2.311018] initcall svia_pci_driver_init+0x0/0x1b returned 0 after 87 usecs
[    2.312747] calling  amd_pci_driver_init+0x0/0x1b @ 1
[    2.314098] initcall amd_pci_driver_init+0x0/0x1b returned 0 after 139 usecs
[    2.315856] calling  atiixp_pci_driver_init+0x0/0x1b @ 1
[    2.317357] initcall atiixp_pci_driver_init+0x0/0x1b returned 0
after 120 usecs
[    2.319125] calling  oldpiix_pci_driver_init+0x0/0x1b @ 1
[    2.320624] initcall oldpiix_pci_driver_init+0x0/0x1b returned 0
after 121 usecs
[    2.322421] calling  serverworks_pci_driver_init+0x0/0x1b @ 1
[    2.323891] initcall serverworks_pci_driver_init+0x0/0x1b returned
0 after 89 usecs
[    2.325795] calling  via_pci_driver_init+0x0/0x1b @ 1
[    2.327109] initcall via_pci_driver_init+0x0/0x1b returned 0 after 88 usecs
[    2.328831] calling  mpiix_pci_driver_init+0x0/0x1b @ 1
[    2.330185] initcall mpiix_pci_driver_init+0x0/0x1b returned 0 after 87 usecs
[    2.331903] calling  legacy_init+0x0/0xa0e @ 1
[    2.333025] initcall legacy_init+0x0/0xa0e returned -19 after 6 usecs
[    2.334583] calling  macvlan_init_module+0x0/0x3a @ 1
[    2.335807] initcall macvlan_init_module+0x0/0x3a returned 0 after 4 usecs
[    2.337499] calling  macvtap_init+0x0/0x100 @ 1
[    2.338683] initcall macvtap_init+0x0/0x100 returned 0 after 83 usecs
[    2.340271] calling  net_olddevs_init+0x0/0x85 @ 1
[    2.341429] initcall net_olddevs_init+0x0/0x85 returned 0 after 2 usecs
[    2.342996] calling  marvell_init+0x0/0x17 @ 1
[    2.344787] initcall marvell_init+0x0/0x17 returned 0 after 673 usecs
[    2.346416] calling  davicom_init+0x0/0x17 @ 1
[    2.347761] initcall davicom_init+0x0/0x17 returned 0 after 235 usecs
[    2.349402] calling  cicada_init+0x0/0x17 @ 1
[    2.350635] initcall cicada_init+0x0/0x17 returned 0 after 171 usecs
[    2.352205] calling  lxt_init+0x0/0x17 @ 1
[    2.353471] initcall lxt_init+0x0/0x17 returned 0 after 255 usecs
[    2.354953] calling  qs6612_init+0x0/0x12 @ 1
[    2.356146] initcall qs6612_init+0x0/0x12 returned 0 after 73 usecs
[    2.357672] calling  smsc_init+0x0/0x17 @ 1
[    2.358985] initcall smsc_init+0x0/0x17 returned 0 after 295 usecs
[    2.360522] calling  vsc82xx_init+0x0/0x17 @ 1
[    2.361682] initcall vsc82xx_init+0x0/0x17 returned 0 after 133 usecs
[    2.363236] calling  broadcom_init+0x0/0x17 @ 1
[    2.365023] initcall broadcom_init+0x0/0x17 returned 0 after 632 usecs
[    2.366604] calling  icplus_init+0x0/0x17 @ 1
[    2.367846] initcall icplus_init+0x0/0x17 returned 0 after 185 usecs
[    2.369438] calling  realtek_init+0x0/0x12 @ 1
[    2.370600] initcall realtek_init+0x0/0x12 returned 0 after 76 usecs
[    2.372170] calling  et1011c_init+0x0/0x12 @ 1
[    2.373388] initcall et1011c_init+0x0/0x12 returned 0 after 101 usecs
[    2.374968] calling  fixed_mdio_bus_init+0x0/0xf3 @ 1
[    2.376653] libphy: Fixed MDIO Bus: probed
[    2.377683] initcall fixed_mdio_bus_init+0x0/0xf3 returned 0 after 1316 usecs
[    2.379399] calling  ns_init+0x0/0x12 @ 1
[    2.380543] initcall ns_init+0x0/0x12 returned 0 after 111 usecs
[    2.382016] calling  ste10Xp_init+0x0/0x17 @ 1
[    2.383239] initcall ste10Xp_init+0x0/0x17 returned 0 after 148 usecs
[    2.384852] calling  team_module_init+0x0/0x8b @ 1
[    2.386025] initcall team_module_init+0x0/0x8b returned 0 after 20 usecs
[    2.387640] calling  rr_init_module+0x0/0x12 @ 1
[    2.388804] initcall rr_init_module+0x0/0x12 returned 0 after 21 usecs
[    2.390378] calling  ab_init_module+0x0/0x12 @ 1
[    2.391495] initcall ab_init_module+0x0/0x12 returned 0 after 1 usecs
[    2.393076] calling  tun_init+0x0/0x90 @ 1
[    2.394071] tun: Universal TUN/TAP device driver, 1.6
[    2.395296] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.396924] initcall tun_init+0x0/0x90 returned 0 after 2783 usecs
[    2.398415] calling  veth_init+0x0/0x12 @ 1
[    2.399431] initcall veth_init+0x0/0x12 returned 0 after 2 usecs
[    2.400920] calling  init+0x0/0x12 @ 1
[    2.401898] initcall init+0x0/0x12 returned 0 after 72 usecs
[    2.403251] calling  can_dev_init+0x0/0x2c @ 1
[    2.404367] CAN device driver interface
[    2.405325] initcall can_dev_init+0x0/0x2c returned 0 after 938 usecs
[    2.406921] calling  peak_usb_init+0x0/0x3e @ 1
[    2.408196] usbcore: registered new interface driver peak_usb
[    2.409601] initcall peak_usb_init+0x0/0x3e returned 0 after 1515 usecs
[    2.411202] calling  bnx2_init+0x0/0x1b @ 1
[    2.412399] initcall bnx2_init+0x0/0x1b returned 0 after 123 usecs
[    2.413897] calling  cnic_init+0x0/0x7e @ 1
[    2.414913] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16
(Dec 05, 2012)
[    2.416773] initcall cnic_init+0x0/0x7e returned 0 after 1809 usecs
[    2.418284] calling  bnx2x_init+0x0/0x97 @ 1
[    2.419313] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit
Ethernet Driver bnx2x 1.78.00-0 (2012/09/27)
[    2.421894] initcall bnx2x_init+0x0/0x97 returned 0 after 2513 usecs
[    2.423440] calling  tg3_init+0x0/0x1b @ 1
[    2.424556] initcall tg3_init+0x0/0x1b returned 0 after 87 usecs
[    2.426002] calling  bnad_module_init+0x0/0x62 @ 1
[    2.427153] Brocade 10G Ethernet driver - version: 3.1.2.1
[    2.428597] initcall bnad_module_init+0x0/0x62 returned 0 after 1403 usecs
[    2.430254] calling  xgmac_driver_init+0x0/0x12 @ 1
[    2.431501] initcall xgmac_driver_init+0x0/0x12 returned 0 after 73 usecs
[    2.433162] calling  cxgb3_init_module+0x0/0x20 @ 1
[    2.434500] initcall cxgb3_init_module+0x0/0x20 returned 0 after 142 usecs
[    2.436241] calling  cxgb4_init_module+0x0/0x90 @ 1
[    2.437643] initcall cxgb4_init_module+0x0/0x90 returned 0 after 187 usecs
[    2.439322] calling  cxgb4vf_module_init+0x0/0xa4 @ 1
[    2.440721] initcall cxgb4vf_module_init+0x0/0xa4 returned 0 after 128 usecs
[    2.442453] calling  be_init_module+0x0/0x4b @ 1
[    2.443651] initcall be_init_module+0x0/0x4b returned 0 after 100 usecs
[    2.445239] calling  e1000_init_module+0x0/0x84 @ 1
[    2.446381] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.448035] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.449417] e1000 0000:00:03.0: enabling bus mastering
[    2.450622] e1000 0000:00:03.0: setting latency timer to 64
[    2.452908] ata2.01: NODEV after polling detection
[    2.454280] ata1.01: NODEV after polling detection
[    2.455622] ata2.00: ATAPI: QEMU DVD-ROM, 1.2.50, max UDMA/100
[    2.457191] ata1.00: ATA-7: QEMU HARDDISK, 1.2.50, max UDMA/100
[    2.458545] ata1.00: 65536 sectors, multi 16: LBA48
[    2.460109] ata2.00: configured for MWDMA2
[    2.461281] async_waiting @ 6
[    2.462188] ata1.00: configured for MWDMA2
[    2.463100] async_waiting @ 15
[    2.463765] async_continuing @ 15 after 1 usec
[    2.465410] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK
  1.2. PQ: 0 ANSI: 5
[    2.468123] calling  4_sd_probe_async+0x0/0x1f0 @ 1350
[    2.469154] sd 0:0:0:0: [sda] 65536 512-byte logical blocks: (33.5
MB/32.0 MiB)
[    2.470966] sd 0:0:0:0: [sda] Write Protect is off
[    2.472127] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.473350] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.476794]  sda: unknown partition table
[    2.477838] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.479720] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.480847] initcall 4_sd_probe_async+0x0/0x1f0 returned 0 after 11562 usecs
[    2.739313] initcall 2_async_port_probe+0x0/0x60 returned 0 after
434424 usecs
[    2.741171] async_continuing @ 6 after 272656 usec
[    2.742610] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM
  1.2. PQ: 0 ANSI: 5
[    2.745217] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    2.746496] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.748150] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.749860] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.751344] initcall 3_async_port_probe+0x0/0x60 returned 0 after
444694 usecs
[    2.776475] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 00:1c:25:1c:13:e9
[    2.777667] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.779424] initcall e1000_init_module+0x0/0x84 returned 0 after 325239 usecs
[    2.781196] calling  e1000_init_module+0x0/0x3e @ 1
[    2.782379] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    2.783784] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    2.785352] initcall e1000_init_module+0x0/0x3e returned 0 after 2898 usecs
[    2.787034] calling  igb_init_module+0x0/0x58 @ 1
[    2.788198] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.1.2-k
[    2.789863] igb: Copyright (c) 2007-2012 Intel Corporation.
[    2.791378] initcall igb_init_module+0x0/0x58 returned 0 after 3111 usecs
[    2.793062] calling  igbvf_init_module+0x0/0x4c @ 1
[    2.794236] igbvf: Intel(R) Gigabit Virtual Function Network Driver
- version 2.0.2-k
[    2.796150] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    2.797726] initcall igbvf_init_module+0x0/0x4c returned 0 after 3405 usecs
[    2.799386] calling  ixgbe_init_module+0x0/0x5d @ 1
[    2.800710] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver -
version 3.11.33-k
[    2.802612] ixgbe: Copyright (c) 1999-2012 Intel Corporation.
[    2.804132] initcall ixgbe_init_module+0x0/0x5d returned 0 after 3339 usecs
[    2.805839] calling  ixgbevf_init_module+0x0/0x4c @ 1
[    2.807045] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual
Function Network Driver - version 2.7.12-k
[    2.809337] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    2.810899] initcall ixgbevf_init_module+0x0/0x4c returned 0 after 3759 usecs
[    2.812646] calling  ixgb_init_module+0x0/0x4c @ 1
[    2.813800] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    2.815525] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    2.817091] initcall ixgb_init_module+0x0/0x4c returned 0 after 3209 usecs
[    2.818756] calling  mlx4_init+0x0/0xed @ 1
[    2.819892] initcall mlx4_init+0x0/0xed returned 0 after 120 usecs
[    2.821440] calling  mlx4_en_init+0x0/0x12 @ 1
[    2.822530] initcall mlx4_en_init+0x0/0x12 returned 0 after 15 usecs
[    2.824078] calling  myri10ge_init_module+0x0/0x72 @ 1
[    2.825336] myri10ge: Version 1.5.3-1.534
[    2.826409] initcall myri10ge_init_module+0x0/0x72 returned 0 after
1049 usecs
[    2.828195] calling  init_nic+0x0/0x1b @ 1
[    2.829377] initcall init_nic+0x0/0x1b returned 0 after 151 usecs
[    2.830882] calling  ql3xxx_driver_init+0x0/0x1b @ 1
[    2.832289] initcall ql3xxx_driver_init+0x0/0x1b returned 0 after 146 usecs
[    2.833969] calling  qlcnic_init_module+0x0/0xb9 @ 1
[    2.835179] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.29
[    2.837007] initcall qlcnic_init_module+0x0/0xb9 returned 0 after 1777 usecs
[    2.838688] calling  qlge_init_module+0x0/0x1b @ 1
[    2.839935] initcall qlge_init_module+0x0/0x1b returned 0 after 88 usecs
[    2.841596] calling  niu_init+0x0/0x3d @ 1
[    2.842683] initcall niu_init+0x0/0x3d returned 0 after 90 usecs
[    2.844166] calling  skfd_init+0x0/0x1b @ 1
[    2.845283] initcall skfd_init+0x0/0x1b returned 0 after 95 usecs
[    2.846755] calling  cdc_driver_init+0x0/0x1b @ 1
[    2.847967] usbcore: registered new interface driver cdc_ether
[    2.849429] initcall cdc_driver_init+0x0/0x1b returned 0 after 1493 usecs
[    2.851059] calling  eem_driver_init+0x0/0x1b @ 1
[    2.852306] usbcore: registered new interface driver cdc_eem
[    2.853675] initcall eem_driver_init+0x0/0x1b returned 0 after 1427 usecs
[    2.855322] calling  rndis_driver_init+0x0/0x1b @ 1
[    2.856614] usbcore: registered new interface driver rndis_host
[    2.858035] initcall rndis_driver_init+0x0/0x1b returned 0 after 1474 usecs
[    2.859735] calling  usbnet_init+0x0/0x2b @ 1
[    2.860884] initcall usbnet_init+0x0/0x2b returned 0 after 5 usecs
[    2.862385] calling  cdc_ncm_driver_init+0x0/0x1b @ 1
[    2.863749] usbcore: registered new interface driver cdc_ncm
[    2.865191] initcall cdc_ncm_driver_init+0x0/0x1b returned 0 after 1537 usecs
[    2.866894] calling  fusion_init+0x0/0xf8 @ 1
[    2.867944] Fusion MPT base driver 3.04.20
[    2.868958] Copyright (c) 1999-2008 LSI Corporation
[    2.870149] initcall fusion_init+0x0/0xf8 returned 0 after 2149 usecs
[    2.871709] calling  mptspi_init+0x0/0xf4 @ 1
[    2.872788] Fusion MPT SPI Host driver 3.04.20
[    2.873989] initcall mptspi_init+0x0/0xf4 returned 0 after 1174 usecs
[    2.875560] calling  mptfc_init+0x0/0x107 @ 1
[    2.876648] Fusion MPT FC Host driver 3.04.20
[    2.877801] initcall mptfc_init+0x0/0x107 returned 0 after 1127 usecs
[    2.879362] calling  mptsas_init+0x0/0x13b @ 1
[    2.880469] Fusion MPT SAS Host driver 3.04.20
[    2.881646] initcall mptsas_init+0x0/0x13b returned 0 after 1150 usecs
[    2.883211] calling  mptctl_init+0x0/0x15c @ 1
[    2.884338] Fusion MPT misc device (ioctl) driver 3.04.20
[    2.885741] mptctl: Registered with Fusion MPT base driver
[    2.887044] mptctl: /dev/mptctl @ (major,minor=10,220)
[    2.888347] initcall mptctl_init+0x0/0x15c returned 0 after 3911 usecs
[    2.889988] calling  mpt_lan_init+0x0/0x92 @ 1
[    2.891108] Fusion MPT LAN driver 3.04.20
[    2.892125] initcall mpt_lan_init+0x0/0x92 returned 0 after 985 usecs
[    2.893678] calling  uio_init+0x0/0xe8 @ 1
[    2.894828] initcall uio_init+0x0/0xe8 returned 0 after 131 usecs
[    2.896348] calling  uio_pdrv_init+0x0/0x12 @ 1
[    2.897546] initcall uio_pdrv_init+0x0/0x12 returned 0 after 102 usecs
[    2.899151] calling  uio_pdrv_genirq_init+0x0/0x12 @ 1
[    2.900408] initcall uio_pdrv_genirq_init+0x0/0x12 returned 0 after 75 usecs
[    2.902115] calling  vfio_init+0x0/0x1ea @ 1
[    2.903356] VFIO - User Level meta-driver version: 0.3
[    2.904717] initcall vfio_init+0x0/0x1ea returned 0 after 1523 usecs
[    2.906262] calling  vfio_iommu_type1_init+0x0/0x29 @ 1
[    2.907524] initcall vfio_iommu_type1_init+0x0/0x29 returned -19
after 0 usecs
[    2.909294] calling  vfio_pci_init+0x0/0x4d @ 1
[    2.910526] initcall vfio_pci_init+0x0/0x4d returned 0 after 129 usecs
[    2.912137] calling  cdrom_init+0x0/0xd @ 1
[    2.913152] initcall cdrom_init+0x0/0xd returned 0 after 0 usecs
[    2.914617] calling  yenta_socket_init+0x0/0x1b @ 1
[    2.915886] initcall yenta_socket_init+0x0/0x1b returned 0 after 91 usecs
[    2.917548] calling  aoe_init+0x0/0xb9 @ 1
[    2.919350] aoe: AoE v50 initialised.
[    2.920381] initcall aoe_init+0x0/0xb9 returned 0 after 1788 usecs
[    2.921900] calling  ehci_hcd_init+0x0/0x59 @ 1
[    2.922995] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.924635] initcall ehci_hcd_init+0x0/0x59 returned 0 after 1593 usecs
[    2.926223] calling  ehci_pci_init+0x0/0x69 @ 1
[    2.927322] ehci-pci: EHCI PCI platform driver
[    2.928599] initcall ehci_pci_init+0x0/0x69 returned 0 after 1240 usecs
[    2.930197] calling  oxu_driver_init+0x0/0x12 @ 1
[    2.931415] initcall oxu_driver_init+0x0/0x12 returned 0 after 76 usecs
[    2.933058] calling  isp116x_driver_init+0x0/0x12 @ 1
[    2.934368] initcall isp116x_driver_init+0x0/0x12 returned 0 after 78 usecs
[    2.936091] calling  isp1362_driver_init+0x0/0x12 @ 1
[    2.937399] initcall isp1362_driver_init+0x0/0x12 returned 0 after 78 usecs
[    2.939089] calling  ohci_hcd_mod_init+0x0/0x54 @ 1
[    2.940303] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.941876] initcall ohci_hcd_mod_init+0x0/0x54 returned 0 after 1538 usecs
[    2.943559] calling  uhci_hcd_init+0x0/0xc3 @ 1
[    2.944697] uhci_hcd: USB Universal Host Controller Interface driver
[    2.946334] initcall uhci_hcd_init+0x0/0xc3 returned 0 after 1600 usecs
[    2.947913] calling  xhci_hcd_init+0x0/0x29 @ 1
[    2.949265] initcall xhci_hcd_init+0x0/0x29 returned 0 after 158 usecs
[    2.950894] calling  sl811h_driver_init+0x0/0x12 @ 1
[    2.952278] initcall sl811h_driver_init+0x0/0x12 returned 0 after 139 usecs
[    2.953969] calling  r8a66597_driver_init+0x0/0x12 @ 1
[    2.955329] initcall r8a66597_driver_init+0x0/0x12 returned 0 after 103 usecs
[    2.957099] calling  isp1760_init+0x0/0x4d @ 1
[    2.959035] initcall isp1760_init+0x0/0x4d returned 0 after 836 usecs
[    2.960742] calling  c67x00_driver_init+0x0/0x12 @ 1
[    2.962041] initcall c67x00_driver_init+0x0/0x12 returned 0 after 100 usecs
[    2.963727] calling  usblp_driver_init+0x0/0x1b @ 1
[    2.965039] usbcore: registered new interface driver usblp
[    2.966378] initcall usblp_driver_init+0x0/0x1b returned 0 after 1396 usecs
[    2.968094] calling  wdm_driver_init+0x0/0x1b @ 1
[    2.969324] usbcore: registered new interface driver cdc_wdm
[    2.970694] initcall wdm_driver_init+0x0/0x1b returned 0 after 1428 usecs
[    2.972377] calling  usbtmc_driver_init+0x0/0x1b @ 1
[    2.973676] usbcore: registered new interface driver usbtmc
[    2.975036] initcall usbtmc_driver_init+0x0/0x1b returned 0 after 1432 usecs
[    2.976753] calling  usb_stor_init+0x0/0x43 @ 1
[    2.977854] Initializing USB Mass Storage driver...
[    2.979174] usbcore: registered new interface driver usb-storage
[    2.980885] USB Mass Storage support registered.
[    2.982021] initcall usb_stor_init+0x0/0x43 returned 0 after 4064 usecs
[    2.983621] calling  alauda_driver_init+0x0/0x1b @ 1
[    2.985032] usbcore: registered new interface driver ums-alauda
[    2.986465] initcall alauda_driver_init+0x0/0x1b returned 0 after 1540 usecs
[    2.988291] calling  datafab_driver_init+0x0/0x1b @ 1
[    2.989602] usbcore: registered new interface driver ums-datafab
[    2.991049] initcall datafab_driver_init+0x0/0x1b returned 0 after 1506 usecs
[    2.992802] calling  ene_ub6250_driver_init+0x0/0x1b @ 1
[    2.994169] usbcore: registered new interface driver ums_eneub6250
[    2.995668] initcall ene_ub6250_driver_init+0x0/0x1b returned 0
after 1548 usecs
[    2.997514] calling  freecom_driver_init+0x0/0x1b @ 1
[    2.998818] usbcore: registered new interface driver ums-freecom
[    2.999819] initcall freecom_driver_init+0x0/0x1b returned 0 after 1056 usecs
[    3.001299] calling  isd200_driver_init+0x0/0x1b @ 1
[    3.002600] usbcore: registered new interface driver ums-isd200
[    3.003948] initcall isd200_driver_init+0x0/0x1b returned 0 after 1437 usecs
[    3.005704] calling  jumpshot_driver_init+0x0/0x1b @ 1
[    3.007116] usbcore: registered new interface driver ums-jumpshot
[    3.008512] initcall jumpshot_driver_init+0x0/0x1b returned 0 after
1476 usecs
[    3.010315] calling  karma_driver_init+0x0/0x1b @ 1
[    3.011673] usbcore: registered new interface driver ums-karma
[    3.013168] initcall karma_driver_init+0x0/0x1b returned 0 after 1601 usecs
[    3.014859] calling  onetouch_driver_init+0x0/0x1b @ 1
[    3.016302] usbcore: registered new interface driver ums-onetouch
[    3.017783] initcall onetouch_driver_init+0x0/0x1b returned 0 after
1583 usecs
[    3.019529] calling  sddr09_driver_init+0x0/0x1b @ 1
[    3.020849] usbcore: registered new interface driver ums-sddr09
[    3.022298] initcall sddr09_driver_init+0x0/0x1b returned 0 after 1492 usecs
[    3.023999] calling  sddr55_driver_init+0x0/0x1b @ 1
[    3.025375] usbcore: registered new interface driver ums-sddr55
[    3.026684] initcall sddr55_driver_init+0x0/0x1b returned 0 after 1407 usecs
[    3.028210] calling  usbat_driver_init+0x0/0x1b @ 1
[    3.029377] usbcore: registered new interface driver ums-usbat
[    3.030773] initcall usbat_driver_init+0x0/0x1b returned 0 after 1524 usecs
[    3.032499] calling  usb_mdc800_init+0x0/0x2e2 @ 1
[    3.033773] usbcore: registered new interface driver mdc800
[    3.035126] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek
MDC800 Digital Camera
[    3.036975] initcall usb_mdc800_init+0x0/0x2e2 returned 0 after 3240 usecs
[    3.038655] calling  mts_usb_driver_init+0x0/0x1b @ 1
[    3.040116] usbcore: registered new interface driver microtekX6
[    3.041589] initcall mts_usb_driver_init+0x0/0x1b returned 0 after 1641 usecs
[    3.043294] calling  usb_serial_init+0x0/0x1bd @ 1
[    3.044820] usbcore: registered new interface driver usbserial
[    3.046370] usbcore: registered new interface driver usbserial_generic
[    3.048235] usbserial: USB Serial support registered for generic
[    3.049699] initcall usb_serial_init+0x0/0x1bd returned 0 after 5021 usecs
[    3.051331] calling  usb_serial_module_init+0x0/0x20 @ 1
[    3.052752] usbcore: registered new interface driver usb_debug
[    3.054237] usbserial: USB Serial support registered for debug
[    3.055667] initcall usb_serial_module_init+0x0/0x20 returned 0
after 2959 usecs
[    3.057492] calling  ftdi_init+0x0/0x78 @ 1
[    3.058613] usbcore: registered new interface driver ftdi_sio
[    3.060123] usbserial: USB Serial support registered for FTDI USB
Serial Device
[    3.061881] initcall ftdi_init+0x0/0x78 returned 0 after 3306 usecs
[    3.063370] calling  usb_serial_module_init+0x0/0x20 @ 1
[    3.064800] usbcore: registered new interface driver pl2303
[    3.066214] usbserial: USB Serial support registered for pl2303
[    3.067629] initcall usb_serial_module_init+0x0/0x20 returned 0
after 2872 usecs
[    3.069516] calling  adu_driver_init+0x0/0x1b @ 1
[    3.070835] usbcore: registered new interface driver adutux
[    3.072246] initcall adu_driver_init+0x0/0x1b returned 0 after 1533 usecs
[    3.073879] calling  appledisplay_init+0x0/0x5c @ 1
[    3.075216] usbcore: registered new interface driver appledisplay
[    3.076541] initcall appledisplay_init+0x0/0x5c returned 0 after 1493 usecs
[    3.078158] calling  cypress_driver_init+0x0/0x1b @ 1
[    3.079457] usbcore: registered new interface driver cypress_cy7c63
[    3.080968] initcall cypress_driver_init+0x0/0x1b returned 0 after 1597 usecs
[    3.082646] calling  cytherm_driver_init+0x0/0x1b @ 1
[    3.083949] usbcore: registered new interface driver cytherm
[    3.085371] initcall cytherm_driver_init+0x0/0x1b returned 0 after 1464 usecs
[    3.087083] calling  emi26_driver_init+0x0/0x1b @ 1
[    3.088384] usbcore: registered new interface driver emi26 - firmware loader
[    3.090084] initcall emi26_driver_init+0x0/0x1b returned 0 after 1747 usecs
[    3.091746] calling  emi62_driver_init+0x0/0x1b @ 1
[    3.093042] usbcore: registered new interface driver emi62 - firmware loader
[    3.094748] initcall emi62_driver_init+0x0/0x1b returned 0 after 1749 usecs
[    3.096449] calling  ftdi_elan_init+0x0/0x166 @ 1
[    3.097551] driver ftdi-elan
[    3.098586] usbcore: registered new interface driver ftdi-elan
[    3.100091] initcall ftdi_elan_init+0x0/0x166 returned 0 after 2473 usecs
[    3.101783] calling  idmouse_driver_init+0x0/0x1b @ 1
[    3.103130] usbcore: registered new interface driver idmouse
[    3.104589] initcall idmouse_driver_init+0x0/0x1b returned 0 after 1545 usecs
[    3.106349] calling  iowarrior_driver_init+0x0/0x1b @ 1
[    3.107753] usbcore: registered new interface driver iowarrior
[    3.109203] initcall iowarrior_driver_init+0x0/0x1b returned 0
after 1525 usecs
[    3.110960] calling  isight_firmware_driver_init+0x0/0x1b @ 1
[    3.112454] usbcore: registered new interface driver isight_firmware
[    3.113988] initcall isight_firmware_driver_init+0x0/0x1b returned
0 after 1584 usecs
[    3.115864] calling  lcd_driver_init+0x0/0x1b @ 1
[    3.117120] usbcore: registered new interface driver usblcd
[    3.118472] initcall lcd_driver_init+0x0/0x1b returned 0 after 1400 usecs
[    3.120131] calling  ld_usb_driver_init+0x0/0x1b @ 1
[    3.121424] usbcore: registered new interface driver ldusb
[    3.122748] initcall ld_usb_driver_init+0x0/0x1b returned 0 after 1390 usecs
[    3.124487] calling  led_driver_init+0x0/0x1b @ 1
[    3.125707] usbcore: registered new interface driver usbled
[    3.127038] initcall led_driver_init+0x0/0x1b returned 0 after 1385 usecs
[    3.128723] calling  tower_driver_init+0x0/0x1b @ 1
[    3.130082] usbcore: registered new interface driver legousbtower
[    3.131602] initcall tower_driver_init+0x0/0x1b returned 0 after 1629 usecs
[    3.133339] calling  rio_driver_init+0x0/0x1b @ 1
[    3.134619] usbcore: registered new interface driver rio500
[    3.135974] initcall rio_driver_init+0x0/0x1b returned 0 after 1452 usecs
[    3.137655] calling  sevseg_driver_init+0x0/0x1b @ 1
[    3.138963] usbcore: registered new interface driver usbsevseg
[    3.140406] initcall sevseg_driver_init+0x0/0x1b returned 0 after 1502 usecs
[    3.142087] calling  usb_sisusb_init+0x0/0x1b @ 1
[    3.143311] usbcore: registered new interface driver sisusb
[    3.144707] initcall usb_sisusb_init+0x0/0x1b returned 0 after 1441 usecs
[    3.146339] calling  i8042_init+0x0/0x3e9 @ 1
[    3.147564] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU]
at 0x60,0x64 irq 1,12
[    3.150345] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.151602] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.153091] initcall i8042_init+0x0/0x3e9 returned 0 after 5561 usecs
[    3.154665] calling  serport_init+0x0/0x31 @ 1
[    3.155750] initcall serport_init+0x0/0x31 returned 0 after 1 usecs
[    3.157285] calling  pcips2_driver_init+0x0/0x1b @ 1
[    3.158595] initcall pcips2_driver_init+0x0/0x1b returned 0 after 341 usecs
[    3.160389] calling  serio_raw_drv_init+0x0/0x1b @ 1
[    3.161809] initcall serio_raw_drv_init+0x0/0x1b returned 0 after 149 usecs
[    3.163502] calling  mousedev_init+0x0/0x89 @ 1
[    3.164949] mousedev: PS/2 mouse device common for all mice
[    3.166317] initcall mousedev_init+0x0/0x89 returned 0 after 1608 usecs
[    3.167912] calling  atkbd_init+0x0/0x27 @ 1
[    3.169134] initcall atkbd_init+0x0/0x27 returned 0 after 129 usecs
[    3.170658] calling  psmouse_init+0x0/0x80 @ 1
[    3.172339] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
[    3.174701] initcall psmouse_init+0x0/0x80 returned 0 after 2986 usecs
[    3.176331] calling  sermouse_drv_init+0x0/0x1b @ 1
[    3.179686] initcall sermouse_drv_init+0x0/0x1b returned 0 after 2122 usecs
[    3.181422] calling  pcspkr_platform_driver_init+0x0/0x12 @ 1
[    3.182948] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.184657] initcall pcspkr_platform_driver_init+0x0/0x12 returned
0 after 1801 usecs
[    3.186547] calling  cmos_init+0x0/0x6a @ 1
[    3.187599] rtc_cmos 00:00: RTC can wake from S4
[    3.189168] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.190853] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    3.192592] initcall cmos_init+0x0/0x6a returned 0 after 4926 usecs
[    3.194121] calling  i2c_dev_init+0x0/0xc7 @ 1
[    3.195213] i2c /dev entries driver
[    3.196285] initcall i2c_dev_init+0x0/0xc7 returned 0 after 1039 usecs
[    3.197871] calling  amd756_driver_init+0x0/0x1b @ 1
[    3.199162] initcall amd756_driver_init+0x0/0x1b returned 0 after 90 usecs
[    3.200863] calling  amd8111_driver_init+0x0/0x1b @ 1
[    3.202177] initcall amd8111_driver_init+0x0/0x1b returned 0 after 85 usecs
[    3.203857] calling  i2c_i801_init+0x0/0xc9 @ 1
[    3.204847] initcall i2c_i801_init+0x0/0xc9 returned 0 after 89 usecs
[    3.206435] calling  smbus_sch_driver_init+0x0/0x12 @ 1
[    3.207851] initcall smbus_sch_driver_init+0x0/0x12 returned 0 after 83 usecs
[    3.209633] calling  nforce2_driver_init+0x0/0x1b @ 1
[    3.210949] initcall nforce2_driver_init+0x0/0x1b returned 0 after 86 usecs
[    3.212666] calling  piix4_driver_init+0x0/0x1b @ 1
[    3.213897] piix4_smbus 0000:00:01.3: SMBus Host Controller at
0xb100, revision 0
[    3.216270] initcall piix4_driver_init+0x0/0x1b returned 0 after 2367 usecs
[    3.217920] calling  w1_init+0x0/0xa8 @ 1
[    3.218912] Driver for 1-wire Dallas network protocol.
[    3.220544] initcall w1_init+0x0/0xa8 returned 0 after 1587 usecs
[    3.222039] calling  matrox_w1_init+0x0/0x1b @ 1
[    3.223349] initcall matrox_w1_init+0x0/0x1b returned 0 after 143 usecs
[    3.225011] calling  ds_driver_init+0x0/0x1b @ 1
[    3.226241] usbcore: registered new interface driver DS9490R
[    3.227631] initcall ds_driver_init+0x0/0x1b returned 0 after 1466 usecs
[    3.229301] calling  ds2482_driver_init+0x0/0x14 @ 1
[    3.230589] initcall ds2482_driver_init+0x0/0x14 returned 0 after 83 usecs
[    3.232295] calling  w1_therm_init+0x0/0x2f @ 1
[    3.233431] initcall w1_therm_init+0x0/0x2f returned 0 after 37 usecs
[    3.234997] calling  w1_smem_init+0x0/0x3c @ 1
[    3.236097] initcall w1_smem_init+0x0/0x3c returned 0 after 2 usecs
[    3.237612] calling  w1_f23_init+0x0/0x12 @ 1
[    3.238677] initcall w1_f23_init+0x0/0x12 returned 0 after 2 usecs
[    3.240207] calling  w1_ds2760_init+0x0/0x2c @ 1
[    3.241335] 1-Wire driver for the DS2760 battery monitor  chip  -
(c) 2004-2005, Szabolcs Gyurko
[    3.243447] initcall w1_ds2760_init+0x0/0x2c returned 0 after 2066 usecs
[    3.245097] calling  sensors_w83627hf_init+0x0/0x170 @ 1
[    3.246412] initcall sensors_w83627hf_init+0x0/0x170 returned -19
after 25 usecs
[    3.248193] calling  adm1026_driver_init+0x0/0x14 @ 1
[    3.320333] initcall adm1026_driver_init+0x0/0x14 returned 0 after
69213 usecs
[    3.324832] calling  coretemp_init+0x0/0x81 @ 1
[    3.325936] initcall coretemp_init+0x0/0x81 returned -19 after 0 usecs
[    3.327511] calling  dme1737_init+0x0/0x19e @ 1
[    3.377359] input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input3
[    3.400426] initcall dme1737_init+0x0/0x19e returned 0 after 70097 usecs
[    3.403840] calling  fam15h_power_driver_init+0x0/0x1b @ 1
[    3.405938] initcall fam15h_power_driver_init+0x0/0x1b returned 0
after 143 usecs
[    3.407743] calling  sm_it87_init+0x0/0x584 @ 1
[    3.408900] initcall sm_it87_init+0x0/0x584 returned -19 after 49 usecs
[    3.410495] calling  k8temp_driver_init+0x0/0x1b @ 1
[    3.411790] initcall k8temp_driver_init+0x0/0x1b returned 0 after 91 usecs
[    3.413490] calling  k10temp_driver_init+0x0/0x1b @ 1
[    3.414916] initcall k10temp_driver_init+0x0/0x1b returned 0 after 164 usecs
[    3.416671] calling  lm83_driver_init+0x0/0x14 @ 1
[    3.560354] initcall lm83_driver_init+0x0/0x14 returned 0 after 139040 usecs
[    3.565139] calling  pc87427_init+0x0/0x68 @ 1
[    3.566477] initcall pc87427_init+0x0/0x68 returned -19 after 58 usecs
[    3.568316] calling  smsc47b397_init+0x0/0x19d @ 1
[    3.569680] initcall smsc47b397_init+0x0/0x19d returned -19 after 11 usecs
[    3.571349] calling  sp5100_tco_init_module+0x0/0x79 @ 1
[    3.572635] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    3.574588] initcall sp5100_tco_init_module+0x0/0x79 returned 0
after 1912 usecs
[    3.576321] calling  linear_init+0x0/0x12 @ 1
[    3.577371] md: linear personality registered for level -1
[    3.578647] initcall linear_init+0x0/0x12 returned 0 after 1270 usecs
[    3.580249] calling  raid0_init+0x0/0x12 @ 1
[    3.581245] md: raid0 personality registered for level 0
[    3.582542] initcall raid0_init+0x0/0x12 returned 0 after 1269 usecs
[    3.584106] calling  raid_init+0x0/0x12 @ 1
[    3.585103] md: raid1 personality registered for level 1
[    3.586380] initcall raid_init+0x0/0x12 returned 0 after 1248 usecs
[    3.587901] calling  raid_init+0x0/0x12 @ 1
[    3.588899] md: raid10 personality registered for level 10
[    3.589921] initcall raid_init+0x0/0x12 returned 0 after 998 usecs
[    3.591126] calling  raid5_init+0x0/0x2c @ 1
[    3.592214] md: raid6 personality registered for level 6
[    3.593471] md: raid5 personality registered for level 5
[    3.594760] md: raid4 personality registered for level 4
[    3.596064] initcall raid5_init+0x0/0x2c returned 0 after 3758 usecs
[    3.597578] calling  multipath_init+0x0/0x12 @ 1
[    3.598684] md: multipath personality registered for level -4
[    3.600097] initcall multipath_init+0x0/0x12 returned 0 after 1373 usecs
[    3.601721] calling  raid_init+0x0/0x12 @ 1
[    3.602634] md: faulty personality registered for level -5
[    3.603959] initcall raid_init+0x0/0x12 returned 0 after 1296 usecs
[    3.605502] calling  dm_init+0x0/0x46 @ 1
[    3.606963] device-mapper: uevent: version 1.0.3
[    3.608368] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25)
initialised: dm-devel@redhat.com
[    3.610409] initcall dm_init+0x0/0x46 returned 0 after 3846 usecs
[    3.611895] calling  dm_crypt_init+0x0/0x68 @ 1
[    3.613032] initcall dm_crypt_init+0x0/0x68 returned 0 after 8 usecs
[    3.614598] calling  dm_delay_init+0x0/0xc2 @ 1
[    3.615743] initcall dm_delay_init+0x0/0xc2 returned 0 after 52 usecs
[    3.617269] calling  dm_multipath_init+0x0/0x134 @ 1
[    3.618442] device-mapper: multipath: version 1.5.0 loaded
[    3.619684] initcall dm_multipath_init+0x0/0x134 returned 0 after 1318 usecs
[    3.621403] calling  dm_rr_init+0x0/0x3c @ 1
[    3.622458] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.623029] initcall dm_rr_init+0x0/0x3c returned 0 after 590 usecs
[    3.623997] calling  dm_snapshot_init+0x0/0x21b @ 1
[    3.625233] initcall dm_snapshot_init+0x0/0x21b returned 0 after 53 usecs
[    3.626833] calling  dm_mirror_init+0x0/0x76 @ 1
[    3.628106] initcall dm_mirror_init+0x0/0x76 returned 0 after 201 usecs
[    3.629629] calling  dm_dirty_log_init+0x0/0x56 @ 1
[    3.630766] initcall dm_dirty_log_init+0x0/0x56 returned 0 after 21 usecs
[    3.632358] calling  dm_zero_init+0x0/0x2e @ 1
[    3.633383] initcall dm_zero_init+0x0/0x2e returned 0 after 1 usecs
[    3.634829] calling  hci_uart_init+0x0/0xd7 @ 1
[    3.635871] Bluetooth: HCI UART driver ver 2.2
[    3.636924] Bluetooth: HCI H4 protocol initialized
[    3.638022] Bluetooth: HCI BCSP protocol initialized
[    3.639167] Bluetooth: HCILL protocol initialized
[    3.640375] Bluetooth: HCIATH3K protocol initialized
[    3.641562] initcall hci_uart_init+0x0/0xd7 returned 0 after 5550 usecs
[    3.643134] calling  bcm203x_driver_init+0x0/0x1b @ 1
[    3.644494] usbcore: registered new interface driver bcm203x
[    3.645867] initcall bcm203x_driver_init+0x0/0x1b returned 0 after 1443 usecs
[    3.647572] calling  btusb_driver_init+0x0/0x1b @ 1
[    3.648948] usbcore: registered new interface driver btusb
[    3.650223] initcall btusb_driver_init+0x0/0x1b returned 0 after 1381 usecs
[    3.651894] calling  btsdio_init+0x0/0x27 @ 1
[    3.652996] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    3.654516] initcall btsdio_init+0x0/0x27 returned 0 after 1486 usecs
[    3.656123] calling  ath3k_driver_init+0x0/0x1b @ 1
[    3.657429] usbcore: registered new interface driver ath3k
[    3.658768] initcall ath3k_driver_init+0x0/0x1b returned 0 after 1422 usecs
[    3.660484] calling  btmrvl_sdio_init_module+0x0/0x34 @ 1
[    3.661872] initcall btmrvl_sdio_init_module+0x0/0x34 returned 0
after 78 usecs
[    3.663635] calling  cpufreq_stats_init+0x0/0xac @ 1
[    3.664904] initcall cpufreq_stats_init+0x0/0xac returned 0 after 23 usecs
[    3.666559] calling  init_ladder+0x0/0x12 @ 1
[    3.667621] cpuidle: using governor ladder
[    3.668638] initcall init_ladder+0x0/0x12 returned 0 after 999 usecs
[    3.670164] calling  init_menu+0x0/0x12 @ 1
[    3.671172] cpuidle: using governor menu
[    3.672149] initcall init_menu+0x0/0x12 returned 0 after 948 usecs
[    3.673638] calling  mmc_blk_init+0x0/0x71 @ 1
[    3.674808] initcall mmc_blk_init+0x0/0x71 returned 0 after 81 usecs
[    3.676386] calling  sdio_uart_init+0x0/0xe1 @ 1
[    3.677589] initcall sdio_uart_init+0x0/0xe1 returned 0 after 88 usecs
[    3.679161] calling  sdhci_drv_init+0x0/0x24 @ 1
[    3.680319] sdhci: Secure Digital Host Controller Interface driver
[    3.681796] sdhci: Copyright(c) Pierre Ossman
[    3.682854] initcall sdhci_drv_init+0x0/0x24 returned 0 after 2476 usecs
[    3.684518] calling  sdhci_driver_init+0x0/0x1b @ 1
[    3.685714] initcall sdhci_driver_init+0x0/0x1b returned 0 after 152 usecs
[    3.687377] calling  wbsd_drv_init+0x0/0xb8 @ 1
[    3.688510] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.689935] wbsd: Copyright(c) Pierre Ossman
[    3.691057] initcall wbsd_drv_init+0x0/0xb8 returned 0 after 2490 usecs
[    3.692690] calling  tifm_sd_init+0x0/0x12 @ 1
[    3.693845] initcall tifm_sd_init+0x0/0x12 returned 0 after 76 usecs
[    3.695391] calling  cb710_mmc_driver_init+0x0/0x12 @ 1
[    3.696766] initcall cb710_mmc_driver_init+0x0/0x12 returned 0 after 79 usecs
[    3.698485] calling  via_sd_driver_init+0x0/0x1b @ 1
[    3.699762] initcall via_sd_driver_init+0x0/0x1b returned 0 after 82 usecs
[    3.701457] calling  vub300_init+0x0/0x13f @ 1
[    3.702529] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.704229] usbcore: registered new interface driver vub300
[    3.705655] initcall vub300_init+0x0/0x13f returned 0 after 3052 usecs
[    3.707214] calling  ushc_driver_init+0x0/0x1b @ 1
[    3.708524] usbcore: registered new interface driver ushc
[    3.709846] initcall ushc_driver_init+0x0/0x1b returned 0 after 1416 usecs
[    3.711497] calling  sdhci_pltfm_drv_init+0x0/0x16 @ 1
[    3.712793] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.714169] initcall sdhci_pltfm_drv_init+0x0/0x16 returned 0 after
1342 usecs
[    3.715925] calling  memstick_init+0x0/0x8b @ 1
[    3.717282] initcall memstick_init+0x0/0x8b returned 0 after 214 usecs
[    3.718861] calling  mspro_block_init+0x0/0x6f @ 1
[    3.720129] initcall mspro_block_init+0x0/0x6f returned 0 after 75 usecs
[    3.721756] calling  tifm_ms_init+0x0/0x12 @ 1
[    3.722909] initcall tifm_ms_init+0x0/0x12 returned 0 after 72 usecs
[    3.723946] calling  jmb38x_ms_init+0x0/0x1b @ 1
[    3.725227] initcall jmb38x_ms_init+0x0/0x1b returned 0 after 102 usecs
[    3.726825] calling  timer_trig_init+0x0/0x12 @ 1
[    3.727994] initcall timer_trig_init+0x0/0x12 returned 0 after 34 usecs
[    3.729632] calling  heartbeat_trig_init+0x0/0x3d @ 1
[    3.730857] initcall heartbeat_trig_init+0x0/0x3d returned 0 after 3 usecs
[    3.732528] calling  ib_core_init+0x0/0xa0 @ 1
[    3.733708] initcall ib_core_init+0x0/0xa0 returned 0 after 102 usecs
[    3.735284] calling  ib_mad_init_module+0x0/0xcf @ 1
[    3.736536] initcall ib_mad_init_module+0x0/0xcf returned 0 after 11 usecs
[    3.738152] calling  ib_sa_init+0x0/0x64 @ 1
[    3.739269] initcall ib_sa_init+0x0/0x64 returned 0 after 77 usecs
[    3.740790] calling  ib_cm_init+0x0/0x16d @ 1
[    3.742024] initcall ib_cm_init+0x0/0x16d returned 0 after 178 usecs
[    3.743576] calling  iw_cm_init+0x0/0x38 @ 1
[    3.744733] initcall iw_cm_init+0x0/0x38 returned 0 after 52 usecs
[    3.746229] calling  addr_init+0x0/0x49 @ 1
[    3.747306] initcall addr_init+0x0/0x49 returned 0 after 62 usecs
[    3.748815] calling  cma_init+0x0/0xd5 @ 1
[    3.749867] initcall cma_init+0x0/0xd5 returned 0 after 55 usecs
[    3.751322] calling  ib_umad_init+0x0/0xd9 @ 1
[    3.752535] initcall ib_umad_init+0x0/0xd9 returned 0 after 102 usecs
[    3.754089] calling  ib_uverbs_init+0x0/0xd9 @ 1
[    3.755296] initcall ib_uverbs_init+0x0/0xd9 returned 0 after 78 usecs
[    3.756892] calling  ib_ucm_init+0x0/0xa3 @ 1
[    3.757952] initcall ib_ucm_init+0x0/0xa3 returned 0 after 4 usecs
[    3.759437] calling  ucma_init+0x0/0x9d @ 1
[    3.760597] initcall ucma_init+0x0/0x9d returned 0 after 121 usecs
[    3.762091] calling  mthca_init+0x0/0x182 @ 1
[    3.763281] initcall mthca_init+0x0/0x182 returned 0 after 131 usecs
[    3.764858] calling  infinipath_init+0x0/0xc2 @ 1
[    3.766102] initcall infinipath_init+0x0/0xc2 returned 0 after 105 usecs
[    3.767705] calling  qlogic_ib_init+0x0/0xed @ 1
[    3.769138] ib_qib: Unable to register ipathfs
[    3.770226] initcall qlogic_ib_init+0x0/0xed returned 0 after 1323 usecs
[    3.771849] calling  mlx4_ib_init+0x0/0x75 @ 1
[    3.773052] initcall mlx4_ib_init+0x0/0x75 returned 0 after 71 usecs
[    3.774623] calling  ipoib_init_module+0x0/0x141 @ 1
[    3.775884] initcall ipoib_init_module+0x0/0x141 returned 0 after 59 usecs
[    3.777594] calling  srp_init_module+0x0/0x14d @ 1
[    3.778869] initcall srp_init_module+0x0/0x14d returned 0 after 103 usecs
[    3.780544] calling  iser_init+0x0/0x12c @ 1
[    3.781695] iscsi: registered transport (iser)
[    3.782775] initcall iser_init+0x0/0x12c returned 0 after 1171 usecs
[    3.784343] calling  dmi_sysfs_init+0x0/0x96 @ 1
[    3.785593] initcall dmi_sysfs_init+0x0/0x96 returned 0 after 135 usecs
[    3.787183] calling  efivars_init+0x0/0x106 @ 1
[    3.788302] EFI Variables Facility v0.08 2004-May-17
[    3.789499] initcall efivars_init+0x0/0x106 returned 0 after 1170 usecs
[    3.791081] calling  ibft_init+0x0/0x3bd @ 1
[    3.792134] No iBFT detected.
[    3.792857] initcall ibft_init+0x0/0x3bd returned 0 after 706 usecs
[    3.794371] calling  hid_init+0x0/0x53 @ 1
[    3.795456] initcall hid_init+0x0/0x53 returned 0 after 96 usecs
[    3.796944] calling  hid_init+0x0/0x1b @ 1
[    3.798011] initcall hid_init+0x0/0x1b returned 0 after 95 usecs
[    3.799125] calling  a4_init+0x0/0x1b @ 1
[    3.800244] initcall a4_init+0x0/0x1b returned 0 after 105 usecs
[    3.801694] calling  apple_init+0x0/0x35 @ 1
[    3.802868] initcall apple_init+0x0/0x35 returned 0 after 133 usecs
[    3.804472] calling  belkin_init+0x0/0x1b @ 1
[    3.805634] initcall belkin_init+0x0/0x1b returned 0 after 103 usecs
[    3.807164] calling  ch_init+0x0/0x1b @ 1
[    3.808263] initcall ch_init+0x0/0x1b returned 0 after 86 usecs
[    3.809687] calling  ch_init+0x0/0x1b @ 1
[    3.810735] initcall ch_init+0x0/0x1b returned 0 after 75 usecs
[    3.812206] calling  cp_init+0x0/0x1b @ 1
[    3.813261] initcall cp_init+0x0/0x1b returned 0 after 84 usecs
[    3.814691] calling  dr_init+0x0/0x1b @ 1
[    3.815739] initcall dr_init+0x0/0x1b returned 0 after 74 usecs
[    3.817216] calling  ez_init+0x0/0x1b @ 1
[    3.818285] initcall ez_init+0x0/0x1b returned 0 after 91 usecs
[    3.819707] calling  gyration_init+0x0/0x1b @ 1
[    3.820916] initcall gyration_init+0x0/0x1b returned 0 after 75 usecs
[    3.822481] calling  ks_init+0x0/0x1b @ 1
[    3.823530] initcall ks_init+0x0/0x1b returned 0 after 72 usecs
[    3.825004] calling  kye_init+0x0/0x1b @ 1
[    3.826077] initcall kye_init+0x0/0x1b returned 0 after 77 usecs
[    3.827510] calling  lg_init+0x0/0x1b @ 1
[    3.828637] initcall lg_init+0x0/0x1b returned 0 after 121 usecs
[    3.830090] calling  logi_dj_init+0x0/0x73 @ 1
[    3.831281] initcall logi_dj_init+0x0/0x73 returned 0 after 173 usecs
[    3.832889] calling  ms_init+0x0/0x1b @ 1
[    3.833990] initcall ms_init+0x0/0x1b returned 0 after 118 usecs
[    3.835459] calling  mr_init+0x0/0x1b @ 1
[    3.836571] initcall mr_init+0x0/0x1b returned 0 after 95 usecs
[    3.838005] calling  ntrig_init+0x0/0x1b @ 1
[    3.839128] initcall ntrig_init+0x0/0x1b returned 0 after 84 usecs
[    3.840668] calling  ortek_init+0x0/0x1b @ 1
[    3.841782] initcall ortek_init+0x0/0x1b returned 0 after 81 usecs
[    3.843274] calling  pl_init+0x0/0x1b @ 1
[    3.844359] initcall pl_init+0x0/0x1b returned 0 after 75 usecs
[    3.845797] calling  pl_init+0x0/0x1b @ 1
[    3.846845] initcall pl_init+0x0/0x1b returned 0 after 73 usecs
[    3.848309] calling  samsung_init+0x0/0x1b @ 1
[    3.849461] initcall samsung_init+0x0/0x1b returned 0 after 79 usecs
[    3.850988] calling  sjoy_init+0x0/0x1b @ 1
[    3.852111] initcall sjoy_init+0x0/0x1b returned 0 after 74 usecs
[    3.853581] calling  sony_init+0x0/0x1b @ 1
[    3.854673] initcall sony_init+0x0/0x1b returned 0 after 73 usecs
[    3.856173] calling  sp_init+0x0/0x1b @ 1
[    3.857216] initcall sp_init+0x0/0x1b returned 0 after 78 usecs
[    3.858625] calling  ga_init+0x0/0x1b @ 1
[    3.859707] initcall ga_init+0x0/0x1b returned 0 after 107 usecs
[    3.861209] calling  tm_init+0x0/0x1b @ 1
[    3.862310] initcall tm_init+0x0/0x1b returned 0 after 127 usecs
[    3.863765] calling  ts_init+0x0/0x1b @ 1
[    3.864910] initcall ts_init+0x0/0x1b returned 0 after 105 usecs
[    3.866352] calling  twinhan_init+0x0/0x1b @ 1
[    3.867516] initcall twinhan_init+0x0/0x1b returned 0 after 89 usecs
[    3.869087] calling  zp_init+0x0/0x1b @ 1
[    3.870148] initcall zp_init+0x0/0x1b returned 0 after 80 usecs
[    3.871583] calling  hid_init+0x0/0x4e @ 1
[    3.872699] usbcore: registered new interface driver usbhid
[    3.874041] usbhid: USB HID core driver
[    3.874972] initcall hid_init+0x0/0x4e returned 0 after 2316 usecs
[    3.876496] calling  mxm_wmi_init+0x0/0x8 @ 1
[    3.877547] initcall mxm_wmi_init+0x0/0x8 returned 0 after 0 usecs
[    3.879028] calling  alsa_hwdep_init+0x0/0x55 @ 1
[    3.880220] initcall alsa_hwdep_init+0x0/0x55 returned 0 after 33 usecs
[    3.881810] calling  alsa_timer_init+0x0/0x15e @ 1
[    3.883232] initcall alsa_timer_init+0x0/0x15e returned 0 after 269 usecs
[    3.884920] calling  alsa_pcm_init+0x0/0x5d @ 1
[    3.886020] initcall alsa_pcm_init+0x0/0x5d returned 0 after 6 usecs
[    3.887528] calling  snd_mem_init+0x0/0x2c @ 1
[    3.888634] initcall snd_mem_init+0x0/0x2c returned 0 after 10 usecs
[    3.890170] calling  alsa_rawmidi_init+0x0/0x14 @ 1
[    3.891345] initcall alsa_rawmidi_init+0x0/0x14 returned 0 after 2 usecs
[    3.892979] calling  snd_compress_init+0x0/0x8 @ 1
[    3.894142] initcall snd_compress_init+0x0/0x8 returned 0 after 0 usecs
[    3.895737] calling  alsa_card_serial_init+0x0/0xa5 @ 1
[    3.897329] no UART detected at 0x1
[    3.898513] initcall alsa_card_serial_init+0x0/0xa5 returned -19
after 1460 usecs
[    3.900357] calling  alsa_mpu401_uart_init+0x0/0x8 @ 1
[    3.901597] initcall alsa_mpu401_uart_init+0x0/0x8 returned 0 after 0 usecs
[    3.903267] calling  alsa_card_mpu401_init+0x0/0xcc @ 1
[    3.904825] initcall alsa_card_mpu401_init+0x0/0xcc returned -19
after 264 usecs
[    3.906615] calling  intel8x0_driver_init+0x0/0x1b @ 1
[    3.907938] initcall intel8x0_driver_init+0x0/0x1b returned 0 after 97 usecs
[    3.909684] calling  intel8x0m_driver_init+0x0/0x1b @ 1
[    3.911036] initcall intel8x0m_driver_init+0x0/0x1b returned 0 after 91 usecs
[    3.912794] calling  alsa_ac97_init+0x0/0x8 @ 1
[    3.913887] initcall alsa_ac97_init+0x0/0x8 returned 0 after 0 usecs
[    3.915421] calling  patch_realtek_init+0x0/0x12 @ 1
[    3.916655] initcall patch_realtek_init+0x0/0x12 returned 0 after 18 usecs
[    3.918276] calling  patch_cmedia_init+0x0/0x12 @ 1
[    3.919461] initcall patch_cmedia_init+0x0/0x12 returned 0 after 3 usecs
[    3.920974] calling  patch_analog_init+0x0/0x12 @ 1
[    3.922148] initcall patch_analog_init+0x0/0x12 returned 0 after 2 usecs
[    3.923763] calling  patch_sigmatel_init+0x0/0x12 @ 1
[    3.925029] initcall patch_sigmatel_init+0x0/0x12 returned 0 after 1 usecs
[    3.926688] calling  patch_si3054_init+0x0/0x12 @ 1
[    3.927863] initcall patch_si3054_init+0x0/0x12 returned 0 after 2 usecs
[    3.929505] calling  patch_cirrus_init+0x0/0x12 @ 1
[    3.930684] initcall patch_cirrus_init+0x0/0x12 returned 0 after 1 usecs
[    3.932312] calling  patch_ca0110_init+0x0/0x12 @ 1
[    3.933493] initcall patch_ca0110_init+0x0/0x12 returned 0 after 2 usecs
[    3.934616] calling  patch_ca0132_init+0x0/0x12 @ 1
[    3.935034] initcall patch_ca0132_init+0x0/0x12 returned 0 after 1 usecs
[    3.936224] calling  patch_conexant_init+0x0/0x12 @ 1
[    3.937454] initcall patch_conexant_init+0x0/0x12 returned 0 after 1 usecs
[    3.939108] calling  patch_via_init+0x0/0x12 @ 1
[    3.940270] initcall patch_via_init+0x0/0x12 returned 0 after 1 usecs
[    3.941823] calling  patch_hdmi_init+0x0/0x12 @ 1
[    3.942964] initcall patch_hdmi_init+0x0/0x12 returned 0 after 1 usecs
[    3.944589] calling  azx_driver_init+0x0/0x1b @ 1
[    3.945843] initcall azx_driver_init+0x0/0x1b returned 0 after 159 usecs
[    3.947361] calling  snd_usb_audio_init+0x0/0x3d @ 1
[    3.948631] usbcore: registered new interface driver snd-usb-audio
[    3.950169] initcall snd_usb_audio_init+0x0/0x3d returned 0 after 1638 usecs
[    3.951986] calling  snd_usb_driver_init+0x0/0x1b @ 1
[    3.953393] usbcore: registered new interface driver snd-usb-caiaq
[    3.954912] initcall snd_usb_driver_init+0x0/0x1b returned 0 after 1622 usecs
[    3.956658] calling  snd_soc_init+0x0/0xe8 @ 1
[    3.957878] initcall snd_soc_init+0x0/0xe8 returned 0 after 364 usecs
[    3.959430] calling  sock_diag_init+0x0/0x12 @ 1
[    3.960577] initcall sock_diag_init+0x0/0x12 returned 0 after 10 usecs
[    3.962133] calling  sysctl_ipv4_init+0x0/0x8d @ 1
[    3.963327] initcall sysctl_ipv4_init+0x0/0x8d returned 0 after 35 usecs
[    3.964971] calling  inet_diag_init+0x0/0x97 @ 1
[    3.966106] initcall inet_diag_init+0x0/0x97 returned 0 after 21 usecs
[    3.967679] calling  tcp_diag_init+0x0/0x12 @ 1
[    3.968812] initcall tcp_diag_init+0x0/0x12 returned 0 after 12 usecs
[    3.970358] calling  cubictcp_register+0x0/0x6a @ 1
[    3.971531] TCP: cubic registered
[    3.972353] initcall cubictcp_register+0x0/0x6a returned 0 after 797 usecs
[    3.974007] calling  hstcp_register+0x0/0x12 @ 1
[    3.975118] TCP: highspeed registered
[    3.976023] initcall hstcp_register+0x0/0x12 returned 0 after 877 usecs
[    3.977600] calling  tcp_scalable_register+0x0/0x12 @ 1
[    3.978851] TCP: scalable registered
[    3.979658] initcall tcp_scalable_register+0x0/0x12 returned 0
after 790 usecs
[    3.981419] calling  unix_diag_init+0x0/0x12 @ 1
[    3.982554] initcall unix_diag_init+0x0/0x12 returned 0 after 3 usecs
[    3.984145] calling  packet_init+0x0/0x44 @ 1
[    3.985154] NET: Registered protocol family 17
[    3.986231] initcall packet_init+0x0/0x44 returned 0 after 1057 usecs
[    3.987779] calling  can_init+0x0/0xf5 @ 1
[    3.988803] can: controller area network core (rev 20120528 abi 9)
[    3.990338] NET: Registered protocol family 29
[    3.991418] initcall can_init+0x0/0xf5 returned 0 after 2557 usecs
[    3.992931] calling  rfcomm_init+0x0/0xe4 @ 1
[    3.994080] Bluetooth: RFCOMM TTY layer initialized
[    3.995276] Bluetooth: RFCOMM socket layer initialized
[    3.996555] Bluetooth: RFCOMM ver 1.11
[    3.997473] initcall rfcomm_init+0x0/0xe4 returned 0 after 3407 usecs
[    3.999019] calling  bnep_init+0x0/0x72 @ 1
[    4.000055] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.001340] Bluetooth: BNEP socket layer initialized
[    4.002536] initcall bnep_init+0x0/0x72 returned 0 after 2427 usecs
[    4.004065] calling  hidp_init+0x0/0x20 @ 1
[    4.005090] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.006504] Bluetooth: HIDP socket layer initialized
[    4.007716] initcall hidp_init+0x0/0x20 returned 0 after 2568 usecs
[    4.009026] calling  init_rpcsec_gss+0x0/0x61 @ 1
[    4.010097] initcall init_rpcsec_gss+0x0/0x61 returned 0 after 257 usecs
[    4.012060] calling  xprt_rdma_init+0x0/0xb9 @ 1
[    4.013184] RPC: Registered rdma transport module.
[    4.014372] initcall xprt_rdma_init+0x0/0xb9 returned 0 after 1161 usecs
[    4.015991] calling  svc_rdma_init+0x0/0x1b0 @ 1
[    4.017537] initcall svc_rdma_init+0x0/0x1b0 returned 0 after 402 usecs
[    4.019140] calling  dccp_init+0x0/0x39b @ 1
[    4.025107] DCCP: Activated CCID 2 (TCP-like)
[    4.025876] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    4.027301] initcall dccp_init+0x0/0x39b returned 0 after 6848 usecs
[    4.028914] calling  dccp_v4_init+0x0/0x81 @ 1
[    4.030227] initcall dccp_v4_init+0x0/0x81 returned 0 after 237 usecs
[    4.031781] calling  dccp_diag_init+0x0/0x12 @ 1
[    4.032938] initcall dccp_diag_init+0x0/0x12 returned 0 after 1 usecs
[    4.034495] calling  sctp_init+0x0/0x4d9 @ 1
[    4.043062] sctp: Hash tables configured (established 52428 bind 52428)
[    4.045024] initcall sctp_init+0x0/0x4d9 returned 0 after 9268 usecs
[    4.046538] calling  rds_init+0x0/0xf0 @ 1
[    4.047626] NET: Registered protocol family 21
[    4.048756] initcall rds_init+0x0/0xf0 returned 0 after 1189 usecs
[    4.050238] calling  rds_tcp_init+0x0/0xb0 @ 1
[    4.051332] Registered RDS/tcp transport
[    4.052428] initcall rds_tcp_init+0x0/0xb0 returned 0 after 1087 usecs
[    4.053997] calling  tipc_init+0x0/0xcf @ 1
[    4.055012] tipc: Activated (version 2.0.0)
[    4.056473] NET: Registered protocol family 30
[    4.057403] tipc: Started in single node mode
[    4.058454] initcall tipc_init+0x0/0xcf returned 0 after 3357 usecs
[    4.059722] calling  wimax_subsys_init+0x0/0x3a8 @ 1
[    4.060976] initcall wimax_subsys_init+0x0/0x3a8 returned 0 after 11 usecs
[    4.062633] calling  init_dns_resolver+0x0/0x105 @ 1
[    4.063840] Key type dns_resolver registered
[    4.064908] initcall init_dns_resolver+0x0/0x105 returned 0 after 1048 usecs
[    4.066598] calling  mcheck_init_device+0x0/0x12b @ 1
[    4.068213] initcall mcheck_init_device+0x0/0x12b returned 0 after 388 usecs
[    4.069961] calling  rio_init_mports+0x0/0x210 @ 1
[    4.071163] initcall rio_init_mports+0x0/0x210 returned -19 after 0 usecs
[    4.072998] calling  mcheck_debugfs_init+0x0/0x3b @ 1
[    4.074292] initcall mcheck_debugfs_init+0x0/0x3b returned 0 after 57 usecs
[    4.075973] calling  severities_debugfs_init+0x0/0x3d @ 1
[    4.077332] initcall severities_debugfs_init+0x0/0x3d returned 0
after 19 usecs
[    4.079069] calling  threshold_init_device+0x0/0x4b @ 1
[    4.080355] initcall threshold_init_device+0x0/0x4b returned 0 after 0 usecs
[    4.082041] calling  hpet_insert_resource+0x0/0x26 @ 1
[    4.083281] initcall hpet_insert_resource+0x0/0x26 returned 0 after 3 usecs
[    4.084987] calling  update_mp_table+0x0/0x471 @ 1
[    4.086144] initcall update_mp_table+0x0/0x471 returned 0 after 0 usecs
[    4.087729] calling  lapic_insert_resource+0x0/0x41 @ 1
[    4.089013] initcall lapic_insert_resource+0x0/0x41 returned 0 after 0 usecs
[    4.090713] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    4.091945] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    4.093640] calling  print_ICs+0x0/0x5ab @ 1
[    4.094675] initcall print_ICs+0x0/0x5ab returned 0 after 0 usecs
[    4.096153] calling  check_early_ioremap_leak+0x0/0x50 @ 1
[    4.097475] initcall check_early_ioremap_leak+0x0/0x50 returned 0
after 0 usecs
[    4.099190] calling  pat_memtype_list_init+0x0/0x35 @ 1
[    4.100519] initcall pat_memtype_list_init+0x0/0x35 returned 0 after 0 usecs
[    4.102257] calling  init_oops_id+0x0/0x40 @ 1
[    4.103344] initcall init_oops_id+0x0/0x40 returned 0 after 9 usecs
[    4.104897] calling  printk_late_init+0x0/0x58 @ 1
[    4.106069] initcall printk_late_init+0x0/0x58 returned 0 after 4 usecs
[    4.107662] calling  sched_init_debug+0x0/0x24 @ 1
[    4.108857] initcall sched_init_debug+0x0/0x24 returned 0 after 14 usecs
[    4.110461] calling  pm_qos_power_init+0x0/0x65 @ 1
[    4.111959] initcall pm_qos_power_init+0x0/0x65 returned 0 after 321 usecs
[    4.113669] calling  pm_debugfs_init+0x0/0x24 @ 1
[    4.114819] initcall pm_debugfs_init+0x0/0x24 returned 0 after 8 usecs
[    4.116418] calling  software_resume+0x0/0x2b0 @ 1
[    4.117587] PM: Hibernation image not present or could not be loaded.
[    4.119187] initcall software_resume+0x0/0x2b0 returned -2 after 1580 usecs
[    4.120889] initcall software_resume+0x0/0x2b0 returned with error code -2
[    4.122568] calling  debugfs_kprobe_init+0x0/0xa0 @ 1
[    4.123805] initcall debugfs_kprobe_init+0x0/0xa0 returned 0 after 20 usecs
[    4.125514] calling  taskstats_init+0x0/0x95 @ 1
[    4.126641] registered taskstats version 1
[    4.127652] initcall taskstats_init+0x0/0x95 returned 0 after 999 usecs
[    4.129238] calling  clear_boot_tracer+0x0/0x30 @ 1
[    4.130439] initcall clear_boot_tracer+0x0/0x30 returned 0 after 0 usecs
[    4.132102] calling  fail_page_alloc_debugfs+0x0/0x9c @ 1
[    4.133490] initcall fail_page_alloc_debugfs+0x0/0x9c returned 0
after 71 usecs
[    4.135279] calling  max_swapfiles_check+0x0/0x8 @ 1
[    4.136513] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    4.138138] calling  failslab_debugfs_init+0x0/0x7c @ 1
[    4.139449] initcall failslab_debugfs_init+0x0/0x7c returned 0 after 60 usecs
[    4.141200] calling  set_recommended_min_free_kbytes+0x0/0xb0 @ 1
[    4.142835] initcall set_recommended_min_free_kbytes+0x0/0xb0
returned 0 after 166 usecs
[    4.144801] calling  fail_make_request_debugfs+0x0/0x28 @ 1
[    4.146175] initcall fail_make_request_debugfs+0x0/0x28 returned 0
after 37 usecs
[    4.147965] calling  random32_reseed+0x0/0xa1 @ 1
[    4.149132] initcall random32_reseed+0x0/0xa1 returned 0 after 7 usecs
[    4.150701] calling  pci_resource_alignment_sysfs_init+0x0/0x22 @ 1
[    4.152232] initcall pci_resource_alignment_sysfs_init+0x0/0x22
returned 0 after 5 usecs
[    4.154167] calling  pci_sysfs_init+0x0/0x51 @ 1
[    4.155406] initcall pci_sysfs_init+0x0/0x51 returned 0 after 121 usecs
[    4.157018] calling  random_int_secret_init+0x0/0x19 @ 1
[    4.158301] initcall random_int_secret_init+0x0/0x19 returned 0
after 11 usecs
[    4.160068] calling  deferred_probe_initcall+0x0/0x60 @ 1
[    4.161462] initcall deferred_probe_initcall+0x0/0x60 returned 0
after 66 usecs
[    4.163237] calling  rionet_init+0x0/0x12 @ 1
[    4.164526] initcall rionet_init+0x0/0x12 returned 0 after 176 usecs
[    4.166076] calling  rtc_hctosys+0x0/0x111 @ 1
[    4.167214] rtc_cmos 00:00: setting system clock to 2012-12-14
09:00:17 UTC (1355475617)
[    4.169177] initcall rtc_hctosys+0x0/0x111 returned 0 after 1980 usecs
[    4.170746] calling  powernowk8_init+0x0/0xfc @ 1
[    4.171881] initcall powernowk8_init+0x0/0xfc returned -19 after 0 usecs
[    4.173521] calling  acpi_cpufreq_init+0x0/0x223 @ 1
[    4.174830] initcall acpi_cpufreq_init+0x0/0x223 returned -19 after 101 usecs
[    4.176569] calling  pcc_cpufreq_init+0x0/0x2d7 @ 1
[    4.177757] initcall pcc_cpufreq_init+0x0/0x2d7 returned -19 after 6 usecs
[    4.179406] calling  edd_init+0x0/0x2da @ 1
[    4.180439] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    4.182003] initcall edd_init+0x0/0x2da returned 0 after 1530 usecs
[    4.183517] calling  firmware_memmap_init+0x0/0x35 @ 1
[    4.184824] initcall firmware_memmap_init+0x0/0x35 returned 0 after 40 usecs
[    4.186522] calling  pci_mmcfg_late_insert_resources+0x0/0x4d @ 1
[    4.187969] initcall pci_mmcfg_late_insert_resources+0x0/0x4d
returned 0 after 0 usecs
[    4.189889] calling  net_secret_init+0x0/0x19 @ 1
[    4.191071] initcall net_secret_init+0x0/0x19 returned 0 after 13 usecs
[    4.192705] calling  tcp_congestion_default+0x0/0x12 @ 1
[    4.193993] initcall tcp_congestion_default+0x0/0x12 returned 0 after 2 usecs
[    4.195720] calling  tcp_fastopen_init+0x0/0x4b @ 1
[    4.196980] initcall tcp_fastopen_init+0x0/0x4b returned 0 after 43 usecs
[    4.198615] calling  ip_auto_config+0x0/0xea1 @ 1
[    6.209094] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX
[    6.228172] Sending DHCP requests ., OK
[    6.230578] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[    6.234558] IP-Config: Complete:
[    6.235279]      device=eth0, hwaddr=00:1c:25:1c:13:e9,
ipaddr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[    6.237476]      host=10.0.2.15, domain=, nis-domain=(none)
[    6.238804]      bootserver=10.0.2.2, rootserver=10.0.2.2, rootpath=
[    6.240234]      nameserver0=10.0.2.3[    6.240912] initcall
ip_auto_config+0x0/0xea1 returned 0 after 1993324 usecs
[    6.242646] calling  alsa_sound_last_init+0x0/0x61 @ 1
[    6.243133] ALSA device list:
[    6.243439]   No soundcards found.
[    6.243802] initcall alsa_sound_last_init+0x0/0x61 returned 0 after 651 usecs
[    6.244601] calling  initialize_hashrnd+0x0/0x19 @ 1
[    6.245143] initcall initialize_hashrnd+0x0/0x19 returned 0 after 7 usecs
[    6.247764] md: Waiting for all devices to be available before autodetect
[    6.248492] md: If you don't use raid, use raid=noautodetect
[    6.249835] md: Autodetecting RAID arrays.
[    6.250285] md: Scanned 0 and added 0 devices.
[    6.250755] md: autorun ...
[    6.251087] md: ... autorun DONE.
[    6.251470] RAMDISK: xz image found at block 0
[   10.684824] kjournald starting.  Commit interval 5 seconds
[   10.685573] EXT3-fs (ram0): warning: maximal mount count reached,
running e2fsck is recommended
[   10.686413] EXT3-fs (ram0): using internal journal
[   10.686874] EXT3-fs (ram0): mounted filesystem with writeback data mode
[   10.687697] VFS: Mounted root (ext3 filesystem) on device 1:0.
[   10.689034] Freeing unused kernel memory: 3444k freed
INIT: version 2.86 booting
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc                                             done
Mounting sysfs at /sys                                               done
Mounting debugfs at /sys/kernel/debug                                done
Mounting tmpfs at /dev                                               done
Initializing /dev                                                    done
Mounting devpts at /dev/pts                                          done
Boot logging started on /dev/ttyS0(/dev/console) at Fri Dec 14 09:00:24 2012
FATAL: Could not load
/lib/modules/3.7.0-yh-07359-ge48ae89-dirty/modules.dep: No such file
or directory
Setting up the hardware clockmodprobe: FATAL: Could not load
/lib/modules/3.7.0-yh-07359-ge48ae89-dirty/modules.dep: No such file
or directory

hwclock: With --noadjfile, you must specify either --utc or --localtime
                                                                     failed
Disabling IP forwarding                                              done
                                                                     done
Starting udevd:                                                      done
Loading drivers, configuring devices: [   10.812280] udevd (2457):
/proc/2457/oom_adj is deprecated, please use /proc/2457/oom_score_adj
instead.
[   10.814451] udevd version 128 started
                                                                     done
Loading required kernel modules                                      done
Activating device mapper...
FATAL: Could not load
/lib/modules/3.7.0-yh-07359-ge48ae89-dirty/modules.dep: No such file
or directory
                                                                     failed
Starting MD Raid                                                     unused
Waiting for udev to settle...
Scanning for LVM volume groups...
File descriptor 3 left open
  Reading all physical volumes.  This may take a while...
Activating LVM volume groups...
File descriptor 3 left open
                                                                     done
Waiting for /firmware
microcode . no more events
Checking file systems...
fsck 1.41.1 (01-Sep-2008)
Checking all file systems.                                           done
                                                                     done
Mounting local file systems...
/proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
/firmware on /lib/firmware type tmpfs (rw)
microcode on /usr/lib/microcode type tmpfs (rw)                      done
Creating /var/log/boot.msg                                           done
Activating remaining swap-devices in /etc/fstab...                   done
Setting up linker cache (/etc/ld.so.cache) using ldconfig            done
Using boot-specified hostname '10.0.2.15'
Setting up hostname '10'                                             done
Setting up loopback interface     lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8
                                                                     done
System Boot Control: The system has been                             set up
Skipped features:                                                boot.md
System Boot Control: Running /etc/init.d/boot.local                  done
INIT: Entering runlevel: 3
Boot logging started on /dev/ttyS0(/dev/console) at Fri Dec 14 09:00:28 2012
Master Resource Control: previous runlevel: N, switching to runlevel:3
Initializing random number generator                                 done
Starting D-Bus daemon                                                done
Starting syslog services                                             done
Loading CPUFreq modules (CPUFreq not supported)
Starting HAL daemon                                                  done
Setting up (localfs) network interfaces:
    lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8                                done
    eth0      device: Intel Corporation 82540EM Gigabit Ethernet
Controller (rev 03)
              No configuration found for eth0                        unused
Setting up service (localfs) network  .  .  .  .  .  .  .  .  .  .   done
Starting RPC portmap daemon                                          done
Setting up (remotefs) network interfaces:
Setting up service (remotefs) network  .  .  .  .  .  .  .  .  .  .  done
Master Resource Control: runlevel 3 has been                         reached
Shutting down SSH daemon                                             done
                        Generating /etc/ssh/ssh_host_key.
                                                         Generating
public/private rsa1 key pair.
                 Your identification has been saved in /etc/ssh/ssh_host_key.

      Your public key has been saved in /etc/ssh/ssh_host_key.pub.
                                                         The key fingerprint is:
20:80:f6:2f:53:5c:3d:91:91:2a:80:dd:da:fb:67:57 root@10
                                                       The key's
randomart image is:
    +--[RSA1 1024]----+
                       | .+ .   .o=      |
                                          |.o + . . =       |
                                                             |. . * o . .      |
|   o * o         |
                   |    o o S        |
                                      |   o o       E   |
                                                         |    o .     .    |

     |       . o .     |
               |        o .      |
                                  +-----------------+
                                                     Generating
/etc/ssh/ssh_host_dsa_key.
          Generating public/private dsa key pair.
                                                 Your identification
has been saved in /etc/ssh/ssh_host_dsa_key.
                                 Your public key has been saved in
/etc/ssh/ssh_host_dsa_key.pub.
                 The key fingerprint is:

8a:49:46:4b:de:6d:45:22:b3:23:f8:9b:33:e2:39:0d root@10
               The key's randomart image is:
                                            +--[ DSA 1024]----+
                                                               |
o . .      |
  |   .   + o       |
                     |  . + o   .      |
                                        |   = + o .       |
                                                           |    * . S        |

       |  Eo = o         |
                 |  .oB .          |
                                    | ..o.o           |
                                                       |  o.             |

   +-----------------+
             Generating /etc/ssh/ssh_host_rsa_key.
                                                  Generating
public/private rsa key pair.
         Your identification has been saved in /etc/ssh/ssh_host_rsa_key.

  Your public key has been saved in /etc/ssh/ssh_host_rsa_key.pub.
                                                         The key fingerprint is:
0f:d1:a8:4c:88:75:1d:a5:26:27:2b:40:4c:61:bf:68 root@10
                                                       The key's
randomart image is:
    +--[ RSA 1024]----+
                       | o=.. ...o.      |
                                          | o.+ o  .+       |
                                                             |  o o + * .      |
|   o + B .       |
                   |  E o + S        |
                                      | .   .   o       |
                                                         |          .      |

     |                 |
               |                 |
                                  +-----------------+
                                                     Starting SSH daedone

10 login: Connection closed by foreign host.

--00151747bd543af82904d0cc6bb3
Content-Type: application/octet-stream; name="hpa_pf_set_page_table_2.patch"
Content-Disposition: attachment; filename="hpa_pf_set_page_table_2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hap3aald0

LS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlXzY0X3R5cGVzLmggfCAgICA0IAogYXJj
aC94ODYva2VybmVsL2hlYWQ2NC5jICAgICAgICAgICAgICAgIHwgICA5NCArKysrKysrKysrKysr
Ky0tCiBhcmNoL3g4Ni9rZXJuZWwvaGVhZF82NC5TICAgICAgICAgICAgICAgfCAgMTg4ICsrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyAgICAg
ICAgICAgICAgICAgfCAgIDEwICsKIGFyY2gveDg2L21tL2luaXQuYyAgICAgICAgICAgICAgICAg
ICAgICB8ICAgIDQgCiBhcmNoL3g4Ni9yZWFsbW9kZS9pbml0LmMgICAgICAgICAgICAgICAgfCAg
IDQzICsrKystLS0KIDYgZmlsZXMgY2hhbmdlZCwgMjI1IGluc2VydGlvbnMoKyksIDExOCBkZWxl
dGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZV82
NF90eXBlcy5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3BndGFibGVfNjRfdHlwZXMuaAorKysgbGludXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNt
L3BndGFibGVfNjRfdHlwZXMuaApAQCAtMSw2ICsxLDggQEAKICNpZm5kZWYgX0FTTV9YODZfUEdU
QUJMRV82NF9ERUZTX0gKICNkZWZpbmUgX0FTTV9YODZfUEdUQUJMRV82NF9ERUZTX0gKIAorI2lu
Y2x1ZGUgPGFzbS9zcGFyc2VtZW0uaD4KKwogI2lmbmRlZiBfX0FTU0VNQkxZX18KICNpbmNsdWRl
IDxsaW51eC90eXBlcy5oPgogCkBAIC02MCw0ICs2Miw2IEBAIHR5cGVkZWYgc3RydWN0IHsgcHRl
dmFsX3QgcHRlOyB9IHB0ZV90OwogI2RlZmluZSBNT0RVTEVTX0VORCAgICAgIF9BQygweGZmZmZm
ZmZmZmYwMDAwMDAsIFVMKQogI2RlZmluZSBNT0RVTEVTX0xFTiAgIChNT0RVTEVTX0VORCAtIE1P
RFVMRVNfVkFERFIpCiAKKyNkZWZpbmUgRUFSTFlfRFlOQU1JQ19QQUdFX1RBQkxFUwk2NAorCiAj
ZW5kaWYgLyogX0FTTV9YODZfUEdUQUJMRV82NF9ERUZTX0ggKi8KSW5kZXg6IGxpbnV4LTIuNi9h
cmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJj
aC94ODYva2VybmVsL2hlYWQ2NC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2hlYWQ2
NC5jCkBAIC0yNiwxMSArMjYsNzMgQEAKICNpbmNsdWRlIDxhc20vZTgyMC5oPgogI2luY2x1ZGUg
PGFzbS9iaW9zX2ViZGEuaD4KIAotc3RhdGljIHZvaWQgX19pbml0IHphcF9pZGVudGl0eV9tYXBw
aW5ncyh2b2lkKQorLyoKKyAqIE1hbmFnZSBwYWdlIHRhYmxlcyB2ZXJ5IGVhcmx5IG9uLgorICov
CitleHRlcm4gcGdkX3QgZWFybHlfbGV2ZWw0X3BndFtQVFJTX1BFUl9QR0RdOworZXh0ZXJuIHBt
ZF90IGVhcmx5X2R5bmFtaWNfcGd0c1tFQVJMWV9EWU5BTUlDX1BBR0VfVEFCTEVTXVtQVFJTX1BF
Ul9QTURdOworc3RhdGljIHVuc2lnbmVkIGludCBfX2luaXRkYXRhIG5leHRfZWFybHlfcGd0ID0g
MiwgZWFybHlfcGd0X3Jlc2V0cyA9IDA7CisKKy8qIFdpcGUgYWxsIGVhcmx5IHBhZ2UgdGFibGVz
IGV4Y2VwdCBmb3IgdGhlIGtlcm5lbCBzeW1ib2wgbWFwICovCitzdGF0aWMgdm9pZCBfX2luaXQg
cmVzZXRfZWFybHlfcGFnZV90YWJsZXModm9pZCkKIHsKLQlwZ2RfdCAqcGdkID0gcGdkX29mZnNl
dF9rKDBVTCk7Ci0JcGdkX2NsZWFyKHBnZCk7Ci0JX19mbHVzaF90bGJfYWxsKCk7CisJdW5zaWdu
ZWQgbG9uZyBpOworCisJZm9yIChpID0gMDsgaSA8IFBUUlNfUEVSX1BHRC0xOyBpKyspCisJCWVh
cmx5X2xldmVsNF9wZ3RbaV0ucGdkID0gMDsKKworCW5leHRfZWFybHlfcGd0ID0gMDsKKwllYXJs
eV9wZ3RfcmVzZXRzKys7CisKKwlfX25hdGl2ZV9mbHVzaF90bGIoKTsKK30KKworLyogQ3JlYXRl
IGEgbmV3IFBNRCBlbnRyeSAqLworaW50IF9faW5pdCBlYXJseV9tYWtlX3BndGFibGUodW5zaWdu
ZWQgbG9uZyBhZGRyZXNzKQoreworCXVuc2lnbmVkIGxvbmcgcGh5c2FkZHIgPSBhZGRyZXNzIC0g
X19QQUdFX09GRlNFVDsKKwl1bnNpZ25lZCBsb25nIGk7CisJcGdkdmFsX3QgcGdkLCAqcGdkX3A7
CisJcHVkdmFsX3QgKnB1ZF9wOworCXBtZHZhbF90IHBtZCwgKnBtZF9wOworCisJaWYgKHBoeXNh
ZGRyID49IE1BWE1FTSkKKwkJcmV0dXJuIC0xOwkvKiBJbnZhbGlkIGFkZHJlc3MgLSBwdWtlICov
CisKKwlpID0gKGFkZHJlc3MgPj4gUEdESVJfU0hJRlQpICYgKFBUUlNfUEVSX1BHRCAtIDEpOwor
CXBnZF9wID0gJmVhcmx5X2xldmVsNF9wZ3RbaV0ucGdkOworCXBnZCA9ICpwZ2RfcDsKKworCS8q
CisJICogVGhlIHVzZSBvZiBfX1NUQVJUX0tFUk5FTF9tYXAgcmF0aGVyIHRoYW4gX19QQUdFX09G
RlNFVCBoZXJlIGlzCisJICogY3JpdGljYWwgLS0gX19QQUdFX09GRlNFVCB3b3VsZCBwb2ludCB1
cyBiYWNrIGludG8gdGhlIGR5bmFtaWMKKwkgKiByYW5nZSBhbmQgd2UgbWlnaHQgZW5kIHVwIGxv
b3BpbmcgZm9yZXZlci4uLgorCSAqLworCWlmIChwZ2QgJiYgbmV4dF9lYXJseV9wZ3QgPCBFQVJM
WV9EWU5BTUlDX1BBR0VfVEFCTEVTKSB7CisJCXB1ZF9wID0gKHB1ZHZhbF90ICopKChwZ2QgJiBQ
VEVfUEZOX01BU0spICsgX19TVEFSVF9LRVJORUxfbWFwKTsKKwl9IGVsc2UgeworCQlpZiAobmV4
dF9lYXJseV9wZ3QgPj0gRUFSTFlfRFlOQU1JQ19QQUdFX1RBQkxFUy0xKQorCQkJcmVzZXRfZWFy
bHlfcGFnZV90YWJsZXMoKTsKKworCQlwdWRfcCA9IChwdWR2YWxfdCAqKWVhcmx5X2R5bmFtaWNf
cGd0c1tuZXh0X2Vhcmx5X3BndCsrXTsKKwkJZm9yIChpID0gMDsgaSA8IFBUUlNfUEVSX1BVRDsg
aSsrKQorCQkJcHVkX3BbaV0gPSAwOworCisJCSpwZ2RfcCA9IChwZ2R2YWxfdClwdWRfcCAtIF9f
U1RBUlRfS0VSTkVMX21hcCArIF9LRVJOUEdfVEFCTEU7CisJfQorCWkgPSAoYWRkcmVzcyA+PiBQ
VURfU0hJRlQpICYgKFBUUlNfUEVSX1BVRCAtIDEpOworCXB1ZF9wICs9IGk7CisKKwlwbWRfcCA9
IChwbWR2YWxfdCAqKWVhcmx5X2R5bmFtaWNfcGd0c1tuZXh0X2Vhcmx5X3BndCsrXTsKKwlwbWQg
PSAocGh5c2FkZHIgJiBQVURfTUFTSykgKyAoX19QQUdFX0tFUk5FTF9MQVJHRSAmIH5fUEFHRV9H
TE9CQUwpOworCWZvciAoaSA9IDA7IGkgPCBQVFJTX1BFUl9QTUQ7IGkrKykgeworCQlwbWRfcFtp
XSA9IHBtZDsKKwkJcG1kICs9IFBNRF9TSVpFOworCX0KKworCSpwdWRfcCA9IChwdWR2YWxfdClw
bWRfcCAtIF9fU1RBUlRfS0VSTkVMX21hcCArIF9LRVJOUEdfVEFCTEU7CisKKwlyZXR1cm4gMDsK
IH0KIAogLyogRG9uJ3QgYWRkIGEgcHJpbnRrIGluIHRoZXJlLiBwcmludGsgcmVsaWVzIG9uIHRo
ZSBQREEgd2hpY2ggaXMgbm90IGluaXRpYWxpemVkIApAQCAtNjEsNiArMTIzLDIxIEBAIHN0YXRp
YyB2b2lkIF9faW5pdCBjb3B5X2Jvb3RkYXRhKGNoYXIgKnIKIAl9CiB9CiAKK3Vuc2lnbmVkIGxv
bmcgX19tZW1pbml0CitrZXJuZWxfcGh5c2ljYWxfbWFwcGluZ19pbml0KHVuc2lnbmVkIGxvbmcg
c3RhcnQsCisJCQkgICAgIHVuc2lnbmVkIGxvbmcgZW5kLAorCQkJICAgICB1bnNpZ25lZCBsb25n
IHBhZ2Vfc2l6ZV9tYXNrKTsKKworc3RhdGljIHZvaWQgaW5pdF9tYXBwaW5nX2tlcm5lbCh2b2lk
KQoreworCWluaXRfbGV2ZWw0X3BndFs1MTFdID0gZWFybHlfbGV2ZWw0X3BndFs1MTFdOworCWVh
cmx5X2FsbG9jX3BndF9idWYoKTsKKwlrZXJuZWxfcGh5c2ljYWxfbWFwcGluZ19pbml0KDAsIElT
QV9FTkRfQUREUkVTUywgMTw8UEdfTEVWRUxfMk0pOworCWtlcm5lbF9waHlzaWNhbF9tYXBwaW5n
X2luaXQocm91bmRfZG93bihfX3BhX3N5bWJvbChfdGV4dCksIFBNRF9TSVpFKSwKKwkJCQkgICAg
IHJvdW5kX3VwKF9fcGFfc3ltYm9sKF9lbmQpIC0gMSwgUE1EX1NJWkUpLAorCQkJCQkgMTw8UEdf
TEVWRUxfMk0pOworfQorCiB2b2lkIF9faW5pdCB4ODZfNjRfc3RhcnRfa2VybmVsKGNoYXIgKiBy
ZWFsX21vZGVfZGF0YSkKIHsKIAlpbnQgaTsKQEAgLTc5LDEyICsxNTYsMTMgQEAgdm9pZCBfX2lu
aXQgeDg2XzY0X3N0YXJ0X2tlcm5lbChjaGFyICogcgogCQkJCShfX1NUQVJUX0tFUk5FTCAmIFBH
RElSX01BU0spKSk7CiAJQlVJTERfQlVHX09OKF9fZml4X3RvX3ZpcnQoX19lbmRfb2ZfZml4ZWRf
YWRkcmVzc2VzKSA8PSBNT0RVTEVTX0VORCk7CiAKKwkvKiBLaWxsIG9mZiB0aGUgaWRlbnRpdHkt
bWFwIHRyYW1wb2xpbmUgKi8KKwlyZXNldF9lYXJseV9wYWdlX3RhYmxlcygpOworCiAJLyogY2xl
YXIgYnNzIGJlZm9yZSBzZXRfaW50cl9nYXRlIHdpdGggZWFybHlfaWR0X2hhbmRsZXIgKi8KIAlj
bGVhcl9ic3MoKTsKIAotCS8qIE1ha2UgTlVMTCBwb2ludGVycyBzZWdmYXVsdCAqLwotCXphcF9p
ZGVudGl0eV9tYXBwaW5ncygpOwotCisJLyogWFhYIC0gdGhpcyBpcyB3cm9uZy4uLiB3ZSBuZWVk
IHRvIGJ1aWxkIHBhZ2UgdGFibGVzIGZyb20gc2NyYXRjaCAqLwogCW1heF9wZm5fbWFwcGVkID0g
S0VSTkVMX0lNQUdFX1NJWkUgPj4gUEFHRV9TSElGVDsKIAogCWZvciAoaSA9IDA7IGkgPCBOVU1f
RVhDRVBUSU9OX1ZFQ1RPUlM7IGkrKykgewpAQCAtOTksNiArMTc3LDggQEAgdm9pZCBfX2luaXQg
eDg2XzY0X3N0YXJ0X2tlcm5lbChjaGFyICogcgogCWlmIChjb25zb2xlX2xvZ2xldmVsID09IDEw
KQogCQllYXJseV9wcmludGsoIktlcm5lbCBhbGl2ZVxuIik7CiAKKwlpbml0X21hcHBpbmdfa2Vy
bmVsKCk7CisKIAl4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKHJlYWxfbW9kZV9kYXRhKTsKIH0K
IApJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2hlYWRfNjQuUworKysgbGludXgtMi42
L2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMKQEAgLTQ3LDE0ICs0NywxMyBAQCBMM19TVEFSVF9L
RVJORUwgPSBwdWRfaW5kZXgoX19TVEFSVF9LRVJOCiAJLmNvZGU2NAogCS5nbG9ibCBzdGFydHVw
XzY0CiBzdGFydHVwXzY0OgotCiAJLyoKIAkgKiBBdCB0aGlzIHBvaW50IHRoZSBDUFUgcnVucyBp
biA2NGJpdCBtb2RlIENTLkwgPSAxIENTLkQgPSAxLAogCSAqIGFuZCBzb21lb25lIGhhcyBsb2Fk
ZWQgYW4gaWRlbnRpdHkgbWFwcGVkIHBhZ2UgdGFibGUKIAkgKiBmb3IgdXMuICBUaGVzZSBpZGVu
dGl0eSBtYXBwZWQgcGFnZSB0YWJsZXMgbWFwIGFsbCBvZiB0aGUKIAkgKiBrZXJuZWwgcGFnZXMg
YW5kIHBvc3NpYmx5IGFsbCBvZiBtZW1vcnkuCiAJICoKLQkgKiAlZXNpIGhvbGRzIGEgcGh5c2lj
YWwgcG9pbnRlciB0byByZWFsX21vZGVfZGF0YS4KKwkgKiAlcnNpIGhvbGRzIGEgcGh5c2ljYWwg
cG9pbnRlciB0byByZWFsX21vZGVfZGF0YS4KIAkgKgogCSAqIFdlIGNvbWUgaGVyZSBlaXRoZXIg
ZGlyZWN0bHkgZnJvbSBhIDY0Yml0IGJvb3Rsb2FkZXIsIG9yIGZyb20KIAkgKiBhcmNoL3g4Nl82
NC9ib290L2NvbXByZXNzZWQvaGVhZC5TLgpAQCAtNjYsNyArNjUsOCBAQCBzdGFydHVwXzY0Ogog
CSAqIHRhYmxlcyBhbmQgdGhlbiByZWxvYWQgdGhlbS4KIAkgKi8KIAotCS8qIENvbXB1dGUgdGhl
IGRlbHRhIGJldHdlZW4gdGhlIGFkZHJlc3MgSSBhbSBjb21waWxlZCB0byBydW4gYXQgYW5kIHRo
ZQorCS8qCisJICogQ29tcHV0ZSB0aGUgZGVsdGEgYmV0d2VlbiB0aGUgYWRkcmVzcyBJIGFtIGNv
bXBpbGVkIHRvIHJ1biBhdCBhbmQgdGhlCiAJICogYWRkcmVzcyBJIGFtIGFjdHVhbGx5IHJ1bm5p
bmcgYXQuCiAJICovCiAJbGVhcQlfdGV4dCglcmlwKSwgJXJicApAQCAtNzgsNTMgKzc4LDY2IEBA
IHN0YXJ0dXBfNjQ6CiAJdGVzdGwJJWVheCwgJWVheAogCWpuegliYWRfYWRkcmVzcwogCi0JLyog
SXMgdGhlIGFkZHJlc3MgdG9vIGxhcmdlPyAqLwotCWxlYXEJX3RleHQoJXJpcCksICVyZHgKLQlt
b3ZxCSRQR0RJUl9TSVpFLCAlcmF4Ci0JY21wcQklcmF4LCAlcmR4Ci0JamFlCWJhZF9hZGRyZXNz
Ci0KLQkvKiBGaXh1cCB0aGUgcGh5c2ljYWwgYWRkcmVzc2VzIGluIHRoZSBwYWdlIHRhYmxlCi0J
ICovCi0JYWRkcQklcmJwLCBpbml0X2xldmVsNF9wZ3QgKyAwKCVyaXApCi0JYWRkcQklcmJwLCBp
bml0X2xldmVsNF9wZ3QgKyAoTDRfUEFHRV9PRkZTRVQqOCkoJXJpcCkKLQlhZGRxCSVyYnAsIGlu
aXRfbGV2ZWw0X3BndCArIChMNF9TVEFSVF9LRVJORUwqOCkoJXJpcCkKKwkvKgorCSAqIElzIHRo
ZSBhZGRyZXNzIHRvbyBsYXJnZT8KKwkgKi8KKwlsZWFxCV90ZXh0KCVyaXApLCAlcmF4CisJc2hy
cQkkTUFYX1BIWVNNRU1fQklUUywgJXJheAorCWpuegliYWRfYWRkcmVzcwogCi0JYWRkcQklcmJw
LCBsZXZlbDNfaWRlbnRfcGd0ICsgMCglcmlwKQorCS8qCisJICogRml4dXAgdGhlIHBoeXNpY2Fs
IGFkZHJlc3NlcyBpbiB0aGUgcGFnZSB0YWJsZQorCSAqLworCWFkZHEJJXJicCwgZWFybHlfbGV2
ZWw0X3BndCArIChMNF9TVEFSVF9LRVJORUwqOCkoJXJpcCkKIAogCWFkZHEJJXJicCwgbGV2ZWwz
X2tlcm5lbF9wZ3QgKyAoNTEwKjgpKCVyaXApCiAJYWRkcQklcmJwLCBsZXZlbDNfa2VybmVsX3Bn
dCArICg1MTEqOCkoJXJpcCkKIAogCWFkZHEJJXJicCwgbGV2ZWwyX2ZpeG1hcF9wZ3QgKyAoNTA2
KjgpKCVyaXApCiAKLQkvKiBBZGQgYW4gSWRlbnRpdHkgbWFwcGluZyBpZiBJIGFtIGFib3ZlIDFH
ICovCisJLyoKKwkgKiBTZXQgdXAgdGhlIGlkZW50aXR5IG1hcHBpbmcgZm9yIHRoZSBzd2l0Y2hv
dmVyLiAgVGhlc2UKKwkgKiBlbnRyaWVzIHNob3VsZCAqTk9UKiBoYXZlIHRoZSBnbG9iYWwgYml0
IHNldCEgIFRoaXMgYWxzbworCSAqIGNyZWF0ZXMgYSBidW5jaCBvZiBub25zZW5zZSBlbnRyaWVz
IGJ1dCB0aGF0IGlzIGZpbmUgLS0KKwkgKiBpdCBhdm9pZHMgcHJvYmxlbXMgYXJvdW5kIHdyYXBh
cm91bmQuCisJICovCiAJbGVhcQlfdGV4dCglcmlwKSwgJXJkaQotCWFuZHEJJFBNRF9QQUdFX01B
U0ssICVyZGkKKwlsZWFxCWVhcmx5X2xldmVsNF9wZ3QoJXJpcCksICVyYngKIAogCW1vdnEJJXJk
aSwgJXJheAotCXNocnEJJFBVRF9TSElGVCwgJXJheAotCWFuZHEJJChQVFJTX1BFUl9QVUQgLSAx
KSwgJXJheAotCWp6CWlkZW50X2NvbXBsZXRlCisJc2hycQkkUEdESVJfU0hJRlQsICVyYXgKIAot
CWxlYXEJKGxldmVsMl9zcGFyZV9wZ3QgLSBfX1NUQVJUX0tFUk5FTF9tYXAgKyBfS0VSTlBHX1RB
QkxFKSglcmJwKSwgJXJkeAotCWxlYXEJbGV2ZWwzX2lkZW50X3BndCglcmlwKSwgJXJieAotCW1v
dnEJJXJkeCwgMCglcmJ4LCAlcmF4LCA4KQorCWxlYXEJKDQwOTYgKyBfS0VSTlBHX1RBQkxFKSgl
cmJ4KSwgJXJkeAorCW1vdnEJJXJkeCwgMCglcmJ4LCVyYXgsOCkKKwltb3ZxCSVyZHgsIDgoJXJi
eCwlcmF4LDgpCiAKKwlhZGRxCSQ0MDk2LCAlcmR4CiAJbW92cQklcmRpLCAlcmF4Ci0Jc2hycQkk
UE1EX1NISUZULCAlcmF4Ci0JYW5kcQkkKFBUUlNfUEVSX1BNRCAtIDEpLCAlcmF4Ci0JbGVhcQlf
X1BBR0VfS0VSTkVMX0lERU5UX0xBUkdFX0VYRUMoJXJkaSksICVyZHgKLQlsZWFxCWxldmVsMl9z
cGFyZV9wZ3QoJXJpcCksICVyYngKLQltb3ZxCSVyZHgsIDAoJXJieCwgJXJheCwgOCkKLWlkZW50
X2NvbXBsZXRlOgorCXNocnEJJFBVRF9TSElGVCwgJXJheAorCWFuZGwJJChQVFJTX1BFUl9QVUQt
MSksICVlYXgKKwltb3ZxCSVyZHgsICg0MDk2KzApKCVyYngsJXJheCw4KQorCW1vdnEJJXJkeCwg
KDQwOTYrOCkoJXJieCwlcmF4LDgpCiAKKwlhZGRxCSQ4MTkyLCAlcmJ4CisJbW92cQklcmRpLCAl
cmF4CisJc2hycQkkUE1EX1NISUZULCAlcmRpCisJYWRkcQkkKF9fUEFHRV9LRVJORUxfTEFSR0Vf
RVhFQyAmIH5fUEFHRV9HTE9CQUwpLCAlcmF4CisJbW92bAkkUFRSU19QRVJfUE1ELCAlZWN4CisK
KzE6CisJYW5kcQkkKFBUUlNfUEVSX1BNRCAtIDEpLCAlcmRpCisJbW92cQklcmF4LCAoJXJieCwl
cmRpLDgpCisJaW5jcQklcmRpCisJYWRkcQkkUE1EX1NJWkUsICVyYXgKKwlkZWNsCSVlY3gKKwlq
bnoJMWIKKwkKIAkvKgogCSAqIEZpeHVwIHRoZSBrZXJuZWwgdGV4dCtkYXRhIHZpcnR1YWwgYWRk
cmVzc2VzLiBOb3RlIHRoYXQKIAkgKiB3ZSBtaWdodCB3cml0ZSBpbnZhbGlkIHBtZHMsIHdoZW4g
dGhlIGtlcm5lbCBpcyByZWxvY2F0ZWQKIAkgKiBjbGVhbnVwX2hpZ2htYXAoKSBmaXhlcyB0aGlz
IHVwIGFsb25nIHdpdGggdGhlIG1hcHBpbmdzCiAJICogYmV5b25kIF9lbmQuCiAJICovCi0KIAls
ZWFxCWxldmVsMl9rZXJuZWxfcGd0KCVyaXApLCAlcmRpCiAJbGVhcQk0MDk2KCVyZGkpLCAlcjgK
IAkvKiBTZWUgaWYgaXQgaXMgYSB2YWxpZCBwYWdlIHRhYmxlIGVudHJ5ICovCkBAIC0xMzksMTcg
KzE1MiwxNCBAQCBpZGVudF9jb21wbGV0ZToKIAkvKiBGaXh1cCBwaHlzX2Jhc2UgKi8KIAlhZGRx
CSVyYnAsIHBoeXNfYmFzZSglcmlwKQogCi0JLyogRHVlIHRvIEVOVFJZKCksIHNvbWV0aW1lcyB0
aGUgZW1wdHkgc3BhY2UgZ2V0cyBmaWxsZWQgd2l0aAotCSAqIHplcm9zLiBCZXR0ZXIgdGFrZSBh
IGptcCB0aGFuIHJlbHlpbmcgb24gZW1wdHkgc3BhY2UgYmVpbmcKLQkgKiBmaWxsZWQgd2l0aCAw
eDkwIChub3ApCi0JICovCi0Jam1wIHNlY29uZGFyeV9zdGFydHVwXzY0CisJbW92cQkkKGVhcmx5
X2xldmVsNF9wZ3QgLSBfX1NUQVJUX0tFUk5FTF9tYXApLCAlcmF4CisJam1wIDFmCiBFTlRSWShz
ZWNvbmRhcnlfc3RhcnR1cF82NCkKIAkvKgogCSAqIEF0IHRoaXMgcG9pbnQgdGhlIENQVSBydW5z
IGluIDY0Yml0IG1vZGUgQ1MuTCA9IDEgQ1MuRCA9IDEsCiAJICogYW5kIHNvbWVvbmUgaGFzIGxv
YWRlZCBhIG1hcHBlZCBwYWdlIHRhYmxlLgogCSAqCi0JICogJWVzaSBob2xkcyBhIHBoeXNpY2Fs
IHBvaW50ZXIgdG8gcmVhbF9tb2RlX2RhdGEuCisJICogJXJzaSBob2xkcyBhIHBoeXNpY2FsIHBv
aW50ZXIgdG8gcmVhbF9tb2RlX2RhdGEuCiAJICoKIAkgKiBXZSBjb21lIGhlcmUgZWl0aGVyIGZy
b20gc3RhcnR1cF82NCAodXNpbmcgcGh5c2ljYWwgYWRkcmVzc2VzKQogCSAqIG9yIGZyb20gdHJh
bXBvbGluZS5TICh1c2luZyB2aXJ0dWFsIGFkZHJlc3NlcykuCkBAIC0xNTksMTIgKzE2OSwxNCBA
QCBFTlRSWShzZWNvbmRhcnlfc3RhcnR1cF82NCkKIAkgKiBhZnRlciB0aGUgYm9vdCBwcm9jZXNz
b3IgZXhlY3V0ZXMgdGhpcyBjb2RlLgogCSAqLwogCisJbW92cQkkKGluaXRfbGV2ZWw0X3BndCAt
IF9fU1RBUlRfS0VSTkVMX21hcCksICVyYXgKKzE6CisKIAkvKiBFbmFibGUgUEFFIG1vZGUgYW5k
IFBHRSAqLwotCW1vdmwJJChYODZfQ1I0X1BBRSB8IFg4Nl9DUjRfUEdFKSwgJWVheAotCW1vdnEJ
JXJheCwgJWNyNAorCW1vdmwJJChYODZfQ1I0X1BBRSB8IFg4Nl9DUjRfUEdFKSwgJWVjeAorCW1v
dnEJJXJjeCwgJWNyNAogCiAJLyogU2V0dXAgZWFybHkgYm9vdCBzdGFnZSA0IGxldmVsIHBhZ2V0
YWJsZXMuICovCi0JbW92cQkkKGluaXRfbGV2ZWw0X3BndCAtIF9fU1RBUlRfS0VSTkVMX21hcCks
ICVyYXgKIAlhZGRxCXBoeXNfYmFzZSglcmlwKSwgJXJheAogCW1vdnEJJXJheCwgJWNyMwogCkBA
IC0xOTYsNyArMjA4LDcgQEAgRU5UUlkoc2Vjb25kYXJ5X3N0YXJ0dXBfNjQpCiAJbW92cQklcmF4
LCAlY3IwCiAKIAkvKiBTZXR1cCBhIGJvb3QgdGltZSBzdGFjayAqLwotCW1vdnEgc3RhY2tfc3Rh
cnQoJXJpcCksJXJzcAorCW1vdnEgc3RhY2tfc3RhcnQoJXJpcCksICVyc3AKIAogCS8qIHplcm8g
RUZMQUdTIGFmdGVyIHNldHRpbmcgcnNwICovCiAJcHVzaHEgJDAKQEAgLTIzNiwyMSArMjQ4LDE5
IEBAIEVOVFJZKHNlY29uZGFyeV9zdGFydHVwXzY0KQogCW1vdmwJaW5pdGlhbF9ncys0KCVyaXAp
LCVlZHgKIAl3cm1zcgkKIAotCS8qIGVzaSBpcyBwb2ludGVyIHRvIHJlYWwgbW9kZSBzdHJ1Y3R1
cmUgd2l0aCBpbnRlcmVzdGluZyBpbmZvLgorCS8qIHJzaSBpcyBwb2ludGVyIHRvIHJlYWwgbW9k
ZSBzdHJ1Y3R1cmUgd2l0aCBpbnRlcmVzdGluZyBpbmZvLgogCSAgIHBhc3MgaXQgdG8gQyAqLwot
CW1vdmwJJWVzaSwgJWVkaQorCW1vdnEJJXJzaSwgJXJkaQogCQogCS8qIEZpbmFsbHkganVtcCB0
byBydW4gQyBjb2RlIGFuZCB0byBiZSBvbiByZWFsIGtlcm5lbCBhZGRyZXNzCiAJICogU2luY2Ug
d2UgYXJlIHJ1bm5pbmcgb24gaWRlbnRpdHktbWFwcGVkIHNwYWNlIHdlIGhhdmUgdG8ganVtcAog
CSAqIHRvIHRoZSBmdWxsIDY0Yml0IGFkZHJlc3MsIHRoaXMgaXMgb25seSBwb3NzaWJsZSBhcyBp
bmRpcmVjdAogCSAqIGp1bXAuICBJbiBhZGRpdGlvbiB3ZSBuZWVkIHRvIGVuc3VyZSAlY3MgaXMg
c2V0IHNvIHdlIG1ha2UgdGhpcwotCSAqIGEgZmFyIHJldHVybi4KKwkgKiBhIGZhciBqdW1wLgog
CSAqLwotCW1vdnEJaW5pdGlhbF9jb2RlKCVyaXApLCVyYXgKIAlwdXNocQkkMAkJIyBmYWtlIHJl
dHVybiBhZGRyZXNzIHRvIHN0b3AgdW53aW5kZXIKLQlwdXNocQkkX19LRVJORUxfQ1MJIyBzZXQg
Y29ycmVjdCBjcwotCXB1c2hxCSVyYXgJCSMgdGFyZ2V0IGFkZHJlc3MgaW4gbmVnYXRpdmUgc3Bh
Y2UKLQlscmV0cQorCS8qIGdhcyAyLjIyIGlzIGJ1Z2d5IGFuZCBtaXMtYXNzZW1ibGVzIGxqbXBx
ICovCisJcmV4NjQgbGptcCAqaW5pdGlhbF9jb2RlKCVyaXApCiAKICNpZmRlZiBDT05GSUdfSE9U
UExVR19DUFUKIC8qCkBAIC0yNzAsMTMgKzI4MCwxNSBAQCBFTkRQUk9DKHN0YXJ0X2NwdTApCiAK
IAkvKiBTTVAgYm9vdHVwIGNoYW5nZXMgdGhlc2UgdHdvICovCiAJX19SRUZEQVRBCi0JLmFsaWdu
CTgKLQlFTlRSWShpbml0aWFsX2NvZGUpCisJLmJhbGlnbgk4CisJR0xPQkFMKGluaXRpYWxfY29k
ZSkKIAkucXVhZAl4ODZfNjRfc3RhcnRfa2VybmVsCi0JRU5UUlkoaW5pdGlhbF9ncykKKwkud29y
ZAlfX0tFUk5FTF9DUworCS5iYWxpZ24JOAorCUdMT0JBTChpbml0aWFsX2dzKQogCS5xdWFkCUlO
SVRfUEVSX0NQVV9WQVIoaXJxX3N0YWNrX3VuaW9uKQogCi0JRU5UUlkoc3RhY2tfc3RhcnQpCisJ
R0xPQkFMKHN0YWNrX3N0YXJ0KQogCS5xdWFkICBpbml0X3RocmVhZF91bmlvbitUSFJFQURfU0la
RS04CiAJLndvcmQgIDAKIAlfX0ZJTklUREFUQQpAQCAtMjg0LDcgKzI5Niw3IEBAIEVORFBST0Mo
c3RhcnRfY3B1MCkKIGJhZF9hZGRyZXNzOgogCWptcCBiYWRfYWRkcmVzcwogCi0JLnNlY3Rpb24g
Ii5pbml0LnRleHQiLCJheCIKKwlfX0lOSVQKIAkuZ2xvYmwgZWFybHlfaWR0X2hhbmRsZXJzCiBl
YXJseV9pZHRfaGFuZGxlcnM6CiAJIyAxMDQoJXJzcCkgJXJmbGFncwpAQCAtMzIxLDE0ICszMzMs
MjIgQEAgRU5UUlkoZWFybHlfaWR0X2hhbmRsZXIpCiAJcHVzaHEgJXIxMQkJIyAgMCglcnNwKQog
CiAJY21wbCAkX19LRVJORUxfQ1MsOTYoJXJzcCkKLQlqbmUgMTBmCisJam5lIDExZgogCisJY21w
bCAkMTQsNzIoJXJzcCkJIyBQYWdlIGZhdWx0PworCWpueiAxMGYKKwlHRVRfQ1IyX0lOVE8oJXJk
aSkJIyBjYW4gY2xvYmJlciBhbnkgdm9sYXRpbGUgcmVnaXN0ZXIgaWYgcHYKKwljYWxsIGVhcmx5
X21ha2VfcGd0YWJsZQorCWFuZGwgJWVheCwlZWF4CisJanogMjBmCQkJIyBBbGwgZ29vZAorCisx
MDoKIAlsZWFxIDg4KCVyc3ApLCVyZGkJIyBQb2ludGVyIHRvICVyaXAKIAljYWxsIGVhcmx5X2Zp
eHVwX2V4Y2VwdGlvbgogCWFuZGwgJWVheCwlZWF4CiAJam56IDIwZgkJCSMgRm91bmQgYW4gZXhj
ZXB0aW9uIGVudHJ5CiAKLTEwOgorMTE6CiAjaWZkZWYgQ09ORklHX0VBUkxZX1BSSU5USwogCUdF
VF9DUjJfSU5UTyglcjkpCSMgY2FuIGNsb2JiZXIgYW55IHZvbGF0aWxlIHJlZ2lzdGVyIGlmIHB2
CiAJbW92bCA4MCglcnNwKSwlcjhkCSMgZXJyb3IgY29kZQpAQCAtMzUwLDcgKzM3MCw3IEBAIEVO
VFJZKGVhcmx5X2lkdF9oYW5kbGVyKQogMToJaGx0CiAJam1wIDFiCiAKLTIwOgkjIEV4Y2VwdGlv
biB0YWJsZSBlbnRyeSBmb3VuZAorMjA6CSMgRXhjZXB0aW9uIHRhYmxlIGVudHJ5IGZvdW5kIG9y
IHBhZ2UgdGFibGUgZ2VuZXJhdGVkCiAJcG9wcSAlcjExCiAJcG9wcSAlcjEwCiAJcG9wcSAlcjkK
QEAgLTM2NCw2ICszODQsOCBAQCBFTlRSWShlYXJseV9pZHRfaGFuZGxlcikKIAlkZWNsIGVhcmx5
X3JlY3Vyc2lvbl9mbGFnKCVyaXApCiAJSU5URVJSVVBUX1JFVFVSTgogCisJX19JTklUREFUQQor
CQogCS5iYWxpZ24gNAogZWFybHlfcmVjdXJzaW9uX2ZsYWc6CiAJLmxvbmcgMApAQCAtMzc0LDEx
ICszOTYsMTAgQEAgZWFybHlfaWR0X21zZzoKIGVhcmx5X2lkdF9yaXBtc2c6CiAJLmFzY2l6ICJS
SVAgJXNcbiIKICNlbmRpZiAvKiBDT05GSUdfRUFSTFlfUFJJTlRLICovCi0JLnByZXZpb3VzCiAK
ICNkZWZpbmUgTkVYVF9QQUdFKG5hbWUpIFwKIAkuYmFsaWduCVBBR0VfU0laRTsgXAotRU5UUlko
bmFtZSkKK0dMT0JBTChuYW1lKQogCiAvKiBBdXRvbWF0ZSB0aGUgY3JlYXRpb24gb2YgMSB0byAx
IG1hcHBpbmcgcG1kIGVudHJpZXMgKi8KICNkZWZpbmUgUE1EUyhTVEFSVCwgUEVSTSwgQ09VTlQp
CQkJXApAQCAtMzg4LDQ2ICs0MDksMjEgQEAgRU5UUlkobmFtZSkKIAlpID0gaSArIDEgOwkJCQkJ
XAogCS5lbmRyCiAKLQkuZGF0YQotCS8qCi0JICogVGhpcyBkZWZhdWx0IHNldHRpbmcgZ2VuZXJh
dGVzIGFuIGlkZW50IG1hcHBpbmcgYXQgYWRkcmVzcyAweDEwMDAwMAotCSAqIGFuZCBhIG1hcHBp
bmcgZm9yIHRoZSBrZXJuZWwgdGhhdCBwcmVjaXNlbHkgbWFwcyB2aXJ0dWFsIGFkZHJlc3MKLQkg
KiAweGZmZmZmZmZmODAwMDAwMDAgdG8gcGh5c2ljYWwgYWRkcmVzcyAweDAwMDAwMC4gKGFsd2F5
cyB1c2luZwotCSAqIDJNYnl0ZSBsYXJnZSBwYWdlcyBwcm92aWRlZCBieSBQQUUgbW9kZSkKLQkg
Ki8KLU5FWFRfUEFHRShpbml0X2xldmVsNF9wZ3QpCi0JLnF1YWQJbGV2ZWwzX2lkZW50X3BndCAt
IF9fU1RBUlRfS0VSTkVMX21hcCArIF9LRVJOUEdfVEFCTEUKLQkub3JnCWluaXRfbGV2ZWw0X3Bn
dCArIEw0X1BBR0VfT0ZGU0VUKjgsIDAKLQkucXVhZAlsZXZlbDNfaWRlbnRfcGd0IC0gX19TVEFS
VF9LRVJORUxfbWFwICsgX0tFUk5QR19UQUJMRQotCS5vcmcJaW5pdF9sZXZlbDRfcGd0ICsgTDRf
U1RBUlRfS0VSTkVMKjgsIDAKLQkvKiAoMl40OC0oMioxMDI0KjEwMjQqMTAyNCkpLygyXjM5KSA9
IDUxMSAqLworCV9fSU5JVERBVEEKK05FWFRfUEFHRShlYXJseV9sZXZlbDRfcGd0KQorCS5maWxs
CTUxMSw4LDAKIAkucXVhZAlsZXZlbDNfa2VybmVsX3BndCAtIF9fU1RBUlRfS0VSTkVMX21hcCAr
IF9QQUdFX1RBQkxFCiAKLU5FWFRfUEFHRShsZXZlbDNfaWRlbnRfcGd0KQotCS5xdWFkCWxldmVs
Ml9pZGVudF9wZ3QgLSBfX1NUQVJUX0tFUk5FTF9tYXAgKyBfS0VSTlBHX1RBQkxFCi0JLmZpbGwJ
NTExLDgsMAorTkVYVF9QQUdFKGVhcmx5X2R5bmFtaWNfcGd0cykKKwkuZmlsbAk1MTIqRUFSTFlf
RFlOQU1JQ19QQUdFX1RBQkxFUyw4LDAKIAorCS5kYXRhCiBORVhUX1BBR0UobGV2ZWwzX2tlcm5l
bF9wZ3QpCiAJLmZpbGwJTDNfU1RBUlRfS0VSTkVMLDgsMAogCS8qICgyXjQ4LSgyKjEwMjQqMTAy
NCoxMDI0KS0oKDJeMzkpKjUxMSkpLygyXjMwKSA9IDUxMCAqLwogCS5xdWFkCWxldmVsMl9rZXJu
ZWxfcGd0IC0gX19TVEFSVF9LRVJORUxfbWFwICsgX0tFUk5QR19UQUJMRQogCS5xdWFkCWxldmVs
Ml9maXhtYXBfcGd0IC0gX19TVEFSVF9LRVJORUxfbWFwICsgX1BBR0VfVEFCTEUKIAotTkVYVF9Q
QUdFKGxldmVsMl9maXhtYXBfcGd0KQotCS5maWxsCTUwNiw4LDAKLQkucXVhZAlsZXZlbDFfZml4
bWFwX3BndCAtIF9fU1RBUlRfS0VSTkVMX21hcCArIF9QQUdFX1RBQkxFCi0JLyogOE1CIHJlc2Vy
dmVkIGZvciB2c3lzY2FsbHMgKyBhIDJNQiBob2xlID0gNCArIDEgZW50cmllcyAqLwotCS5maWxs
CTUsOCwwCi0KLU5FWFRfUEFHRShsZXZlbDFfZml4bWFwX3BndCkKLQkuZmlsbAk1MTIsOCwwCi0K
LU5FWFRfUEFHRShsZXZlbDJfaWRlbnRfcGd0KQotCS8qIFNpbmNlIEkgZWFzaWx5IGNhbiwgbWFw
IHRoZSBmaXJzdCAxRy4KLQkgKiBEb24ndCBzZXQgTlggYmVjYXVzZSBjb2RlIHJ1bnMgZnJvbSB0
aGVzZSBwYWdlcy4KLQkgKi8KLQlQTURTKDAsIF9fUEFHRV9LRVJORUxfSURFTlRfTEFSR0VfRVhF
QywgUFRSU19QRVJfUE1EKQotCiBORVhUX1BBR0UobGV2ZWwyX2tlcm5lbF9wZ3QpCiAJLyoKIAkg
KiA1MTIgTUIga2VybmVsIG1hcHBpbmcuIFdlIHNwZW5kIGEgZnVsbCBwYWdlIG9uIHRoaXMgcGFn
ZXRhYmxlCkBAIC00NDIsMTEgKzQzOCwxNiBAQCBORVhUX1BBR0UobGV2ZWwyX2tlcm5lbF9wZ3Qp
CiAJUE1EUygwLCBfX1BBR0VfS0VSTkVMX0xBUkdFX0VYRUMsCiAJCUtFUk5FTF9JTUFHRV9TSVpF
L1BNRF9TSVpFKQogCi1ORVhUX1BBR0UobGV2ZWwyX3NwYXJlX3BndCkKLQkuZmlsbCAgIDUxMiwg
OCwgMAorTkVYVF9QQUdFKGxldmVsMl9maXhtYXBfcGd0KQorCS5maWxsCTUwNiw4LDAKKwkucXVh
ZAlsZXZlbDFfZml4bWFwX3BndCAtIF9fU1RBUlRfS0VSTkVMX21hcCArIF9QQUdFX1RBQkxFCisJ
LyogOE1CIHJlc2VydmVkIGZvciB2c3lzY2FsbHMgKyBhIDJNQiBob2xlID0gNCArIDEgZW50cmll
cyAqLworCS5maWxsCTUsOCwwCisKK05FWFRfUEFHRShsZXZlbDFfZml4bWFwX3BndCkKKwkuZmls
bAk1MTIsOCwwCiAKICN1bmRlZiBQTURTCi0jdW5kZWYgTkVYVF9QQUdFCiAKIAkuZGF0YQogCS5h
bGlnbiAxNgpAQCAtNDcyLDYgKzQ3Myw3IEBAIEVOVFJZKG5taV9pZHRfdGFibGUpCiAJLnNraXAg
SURUX0VOVFJJRVMgKiAxNgogCiAJX19QQUdFX0FMSUdORURfQlNTCi0JLmFsaWduIFBBR0VfU0la
RQotRU5UUlkoZW1wdHlfemVyb19wYWdlKQorTkVYVF9QQUdFKGVtcHR5X3plcm9fcGFnZSkKKwku
c2tpcCBQQUdFX1NJWkUKK05FWFRfUEFHRShpbml0X2xldmVsNF9wZ3QpCiAJLnNraXAgUEFHRV9T
SVpFCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvcmVhbG1vZGUvaW5pdC5jCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L3JlYWxtb2RlL2luaXQuYworKysgbGludXgtMi42
L2FyY2gveDg2L3JlYWxtb2RlL2luaXQuYwpAQCAtOCwyMiArOCwxMSBAQAogc3RydWN0IHJlYWxf
bW9kZV9oZWFkZXIgKnJlYWxfbW9kZV9oZWFkZXI7CiB1MzIgKnRyYW1wb2xpbmVfY3I0X2ZlYXR1
cmVzOwogCi12b2lkIF9faW5pdCBzZXR1cF9yZWFsX21vZGUodm9pZCkKK3ZvaWQgX19pbml0IHNl
dHVwX3JlYWxfbW9kZV9yZXNlcnZlKHZvaWQpCiB7CiAJcGh5c19hZGRyX3QgbWVtOwotCXUxNiBy
ZWFsX21vZGVfc2VnOwotCXUzMiAqcmVsOwotCXUzMiBjb3VudDsKLQl1MzIgKnB0cjsKLQl1MTYg
KnNlZzsKLQlpbnQgaTsKIAl1bnNpZ25lZCBjaGFyICpiYXNlOwotCXN0cnVjdCB0cmFtcG9saW5l
X2hlYWRlciAqdHJhbXBvbGluZV9oZWFkZXI7CiAJc2l6ZV90IHNpemUgPSBQQUdFX0FMSUdOKHJl
YWxfbW9kZV9ibG9iX2VuZCAtIHJlYWxfbW9kZV9ibG9iKTsKLSNpZmRlZiBDT05GSUdfWDg2XzY0
Ci0JdTY0ICp0cmFtcG9saW5lX3BnZDsKLQl1NjQgZWZlcjsKLSNlbmRpZgogCiAJLyogSGFzIHRv
IGJlIGluIHZlcnkgbG93IG1lbW9yeSBzbyB3ZSBjYW4gZXhlY3V0ZSByZWFsLW1vZGUgQVAgY29k
ZS4gKi8KIAltZW0gPSBtZW1ibG9ja19maW5kX2luX3JhbmdlKDAsIDE8PDIwLCBzaXplLCBQQUdF
X1NJWkUpOwpAQCAtMzUsNiArMjQsMjUgQEAgdm9pZCBfX2luaXQgc2V0dXBfcmVhbF9tb2RlKHZv
aWQpCiAJcmVhbF9tb2RlX2hlYWRlciA9IChzdHJ1Y3QgcmVhbF9tb2RlX2hlYWRlciAqKSBiYXNl
OwogCXByaW50ayhLRVJOX0RFQlVHICJCYXNlIG1lbW9yeSB0cmFtcG9saW5lIGF0IFslcF0gJWxs
eCBzaXplICV6dVxuIiwKIAkgICAgICAgYmFzZSwgKHVuc2lnbmVkIGxvbmcgbG9uZyltZW0sIHNp
emUpOworfQorCit2b2lkIF9faW5pdCBzZXR1cF9yZWFsX21vZGUodm9pZCkKK3sKKwl1MTYgcmVh
bF9tb2RlX3NlZzsKKwl1MzIgKnJlbDsKKwl1MzIgY291bnQ7CisJdTMyICpwdHI7CisJdTE2ICpz
ZWc7CisJaW50IGk7CisJdW5zaWduZWQgY2hhciAqYmFzZTsKKwlzdHJ1Y3QgdHJhbXBvbGluZV9o
ZWFkZXIgKnRyYW1wb2xpbmVfaGVhZGVyOworCXNpemVfdCBzaXplID0gUEFHRV9BTElHTihyZWFs
X21vZGVfYmxvYl9lbmQgLSByZWFsX21vZGVfYmxvYik7CisjaWZkZWYgQ09ORklHX1g4Nl82NAor
CXBnZF90ICp0cmFtcG9saW5lX3BnZDsKKwl1NjQgZWZlcjsKKyNlbmRpZgorCisJYmFzZSA9ICh1
bnNpZ25lZCBjaGFyICopcmVhbF9tb2RlX2hlYWRlcjsKIAogCW1lbWNweShiYXNlLCByZWFsX21v
ZGVfYmxvYiwgc2l6ZSk7CiAKQEAgLTc3LDkgKzg1LDE0IEBAIHZvaWQgX19pbml0IHNldHVwX3Jl
YWxfbW9kZSh2b2lkKQogCXRyYW1wb2xpbmVfY3I0X2ZlYXR1cmVzID0gJnRyYW1wb2xpbmVfaGVh
ZGVyLT5jcjQ7CiAJKnRyYW1wb2xpbmVfY3I0X2ZlYXR1cmVzID0gcmVhZF9jcjQoKTsKIAotCXRy
YW1wb2xpbmVfcGdkID0gKHU2NCAqKSBfX3ZhKHJlYWxfbW9kZV9oZWFkZXItPnRyYW1wb2xpbmVf
cGdkKTsKLQl0cmFtcG9saW5lX3BnZFswXSA9IF9fcGFfc3ltYm9sKGxldmVsM19pZGVudF9wZ3Qp
ICsgX0tFUk5QR19UQUJMRTsKLQl0cmFtcG9saW5lX3BnZFs1MTFdID0gX19wYV9zeW1ib2wobGV2
ZWwzX2tlcm5lbF9wZ3QpICsgX0tFUk5QR19UQUJMRTsKKwl0cmFtcG9saW5lX3BnZCA9IChwZ2Rf
dCAqKSBfX3ZhKHJlYWxfbW9kZV9oZWFkZXItPnRyYW1wb2xpbmVfcGdkKTsKKworCS8qIFNldCB1
cCB0aGUgaWRlbnRpdHkgbWFwICovCisJZm9yIChpID0gMDsgaSA8IHBnZF9pbmRleChtYXhfcGZu
PDxQQUdFX1NISUZUKTsgaSsrKQorCQl0cmFtcG9saW5lX3BnZFtpXSA9IGluaXRfbGV2ZWw0X3Bn
dFtpICsgcGdkX2luZGV4KF9fUEFHRV9PRkZTRVQpXTsKKworCS8qIFNldCB1cCB0aGUga2VybmVs
IG1hcCAqLworCXRyYW1wb2xpbmVfcGdkWzUxMV0gPSBpbml0X2xldmVsNF9wZ3RbNTExXTsKICNl
bmRpZgogfQogCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL3NldHVwLmMKKysrIGxpbnV4
LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwpAQCAtNjg0LDYgKzY4NCw4IEBAIGVhcmx5X3Bh
cmFtKCJyZXNlcnZlbG93IiwgcGFyc2VfcmVzZXJ2ZWwKICAqIE5vdGU6IE9uIHg4Nl82NCwgZml4
bWFwcyBhcmUgcmVhZHkgZm9yIHVzZSBldmVuIGJlZm9yZSB0aGlzIGlzIGNhbGxlZC4KICAqLwog
Cit2b2lkIF9faW5pdCBzZXR1cF9yZWFsX21vZGVfcmVzZXJ2ZSh2b2lkKTsKKwogdm9pZCBfX2lu
aXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogewogCWVhcmx5X3Jlc2VydmVfaW5pdHJk
KCk7CkBAIC05MDksNyArOTExLDkgQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoqY21k
bGluZV9wKQogCiAJcmVzZXJ2ZV9pYmZ0X3JlZ2lvbigpOwogCisjaWZuZGVmIENPTkZJR19YODZf
NjQKIAllYXJseV9hbGxvY19wZ3RfYnVmKCk7CisjZW5kaWYKIAogCS8qCiAJICogTmVlZCB0byBj
b25jbHVkZSBicmssIGJlZm9yZSBtZW1ibG9ja194ODZfZmlsbCgpCkBAIC05NDAsOSArOTQ0LDEz
IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAlwcmludGsoS0VS
Tl9ERUJVRyAiaW5pdGlhbCBtZW1vcnkgbWFwcGVkOiBbbWVtIDB4MDAwMDAwMDAtJSMwMTBseF1c
biIsCiAJCQkobWF4X3Bmbl9tYXBwZWQ8PFBBR0VfU0hJRlQpIC0gMSk7CiAKLQlzZXR1cF9yZWFs
X21vZGUoKTsKKwlzZXR1cF9yZWFsX21vZGVfcmVzZXJ2ZSgpOwogCisjaWZkZWYgQ09ORklHX1g4
Nl82NAorCXdyaXRlX2NyMyhfX3BhKGluaXRfbGV2ZWw0X3BndCkpOworI2VuZGlmCiAJaW5pdF9t
ZW1fbWFwcGluZygpOworCXNldHVwX3JlYWxfbW9kZSgpOwogCiAJbWVtYmxvY2suY3VycmVudF9s
aW1pdCA9IGdldF9tYXhfbWFwcGVkKCk7CiAJZG1hX2NvbnRpZ3VvdXNfcmVzZXJ2ZSgwKTsKSW5k
ZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0LmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
Lm9yaWcvYXJjaC94ODYvbW0vaW5pdC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdC5j
CkBAIC03NSw4ICs3NSw4IEBAIF9fcmVmIHZvaWQgKmFsbG9jX2xvd19wYWdlcyh1bnNpZ25lZCBp
bnQKIAlyZXR1cm4gX192YShwZm4gPDwgUEFHRV9TSElGVCk7CiB9CiAKLS8qIG5lZWQgNCA0ayBm
b3IgaW5pdGlhbCBQTURfU0laRSwgNGsgZm9yIDAtSVNBX0VORF9BRERSRVNTICovCi0jZGVmaW5l
IElOSVRfUEdUX0JVRl9TSVpFCSg1ICogUEFHRV9TSVpFKQorLyogbmVlZCA0IDRrIGZvciBpbml0
aWFsIFBNRF9TSVpFLCA0ayBmb3IgMC1JU0FfRU5EX0FERFJFU1MsIDQgNGsgZm9yIGtlcm5lbCAq
LworI2RlZmluZSBJTklUX1BHVF9CVUZfU0laRQkoOSAqIFBBR0VfU0laRSkKIFJFU0VSVkVfQlJL
KGVhcmx5X3BndF9hbGxvYywgSU5JVF9QR1RfQlVGX1NJWkUpOwogdm9pZCAgX19pbml0IGVhcmx5
X2FsbG9jX3BndF9idWYodm9pZCkKIHsK
--00151747bd543af82904d0cc6bb3--
