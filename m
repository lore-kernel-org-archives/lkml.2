Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2HQNuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:50:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:36488 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2HQNt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:49:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,785,1336374000"; 
   d="scan'208";a="203531627"
Date: Fri, 17 Aug 2012 21:49:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: BUG: scheduling while atomic, under native_smp_prepare_cpus()
Message-ID: <20120817134944.GA539@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Trace one (full config/dmesg attached):

[    0.042794] init IO_APIC IRQs
[    0.043305]  apic 2 pin 0 not connected
[    0.043953] BUG: scheduling while atomic: swapper/0/1/0x10000002
[    0.044017] no locks held by swapper/0/1.
[    0.044692] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1-00420-gb7aebb9 #34
[    0.045861] Call Trace:
[    0.048071]  [<c106361e>] __schedule_bug+0x5e/0x70
[    0.048890]  [<c1b28701>] __schedule+0x91/0xb10
[    0.049660]  [<c14472ea>] ? vsnprintf+0x33a/0x450
[    0.050444]  [<c1060006>] ? lg_local_lock+0x6/0x70
[    0.051256]  [<c14fb5b1>] ? wait_for_xmitr+0x31/0x90
[    0.052019]  [<c144fd55>] ? do_raw_spin_unlock+0xa5/0xf0
[    0.052903]  [<c1b2a532>] ? _raw_spin_unlock+0x22/0x30
[    0.053759]  [<c105cdbb>] ? up+0x1b/0x70
[    0.054421]  [<c1065d6b>] __cond_resched+0x1b/0x30
[    0.055228]  [<c1b292d5>] _cond_resched+0x45/0x50
[    0.056020]  [<c1b26c58>] mutex_lock_nested+0x28/0x370
[    0.056884]  [<c1034222>] ? console_unlock+0x3a2/0x4e0
[    0.057741]  [<c1ac8559>] __irq_alloc_descs+0x39/0x1c0
[    0.058589]  [<c10223bc>] io_apic_setup_irq_pin+0x2c/0x310
[    0.060042]  [<c20638df>] setup_IO_APIC+0x101/0x744
[    0.060878]  [<c1021d51>] ? clear_IO_APIC+0x31/0x50
[    0.061695]  [<c20600f4>] native_smp_prepare_cpus+0x538/0x680
[    0.062644]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
[    0.063517]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
[    0.064016]  [<c2056adc>] kernel_init+0x4b/0x17f
[    0.064790]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
[    0.065660]  [<c1b2bbd6>] kernel_thread_helper+0x6/0x10
[    0.066592] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.068045] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)

Trace two (triggered by another config):

[    0.288018] tlb_flushall_shift is 0xffffffff
[    0.316019] Freeing SMP alternatives: 20k freed
[    0.364022] BUG: scheduling while atomic: swapper/0/1/0x10000002
[    0.364022] no locks held by swapper/0/1.
[    0.368023] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1 #1
[    0.368023] Call Trace:
[    0.368023]  [<79812e23>] __schedule_bug+0x41/0x53
[    0.372023]  [<79820393>] __schedule+0x62/0x488
[    0.376023]  [<792d17ae>] ? radix_tree_lookup+0xa/0xc
[    0.376023]  [<79071f4e>] ? rcu_irq_exit+0x61/0x66
[    0.376023]  [<79026be7>] ? irq_exit+0x60/0x6c
[    0.376023]  [<790035df>] ? do_IRQ+0x6c/0x80
[    0.380023]  [<7903d794>] __cond_resched+0x16/0x26
[    0.380023]  [<79820888>] _cond_resched+0x13/0x1c
[    0.380023]  [<7909f30a>] slab_pre_alloc_hook.isra.44+0x2e/0x33
[    0.380023]  [<790a09c6>] kmem_cache_alloc+0x1b/0xbb
[    0.384024]  [<792ce416>] ? alloc_cpumask_var_node+0x1a/0x72
[    0.384024]  [<792ce416>] alloc_cpumask_var_node+0x1a/0x72
[    0.384024]  [<792ce486>] alloc_cpumask_var+0xb/0xd
[    0.388024]  [<792ce493>] zalloc_cpumask_var+0xb/0xd
[    0.388024]  [<79bfe1fd>] native_smp_prepare_cpus+0x93/0x380
[    0.388024]  [<79bf6a7e>] ? do_one_initcall+0x10c/0x10c
[    0.388024]  [<79bf6ac6>] kernel_init+0x48/0x16e
[    0.392024]  [<79bf6a7e>] ? do_one_initcall+0x10c/0x10c
[    0.392024]  [<7982241e>] kernel_thread_helper+0x6/0xd
[    0.400025] smpboot: SMP disabled
[    0.400025] Performance Events:

Thanks,
Fengguang

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-3065-2012-08-17-20-40-44-3.6.0-rc1-00420-gb7aebb9-34"

[    0.000000] Linux version 3.6.0-rc1-00420-gb7aebb9 (kbuild@kbuild) (gcc version 4.7.1 (Debian 4.7.1-6) ) #34 SMP Fri Aug 17 20:28:43 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x02bbd000-0x02bfffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128984(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:2234461, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1fff8e0, node_mem_map ce4bf280
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 60838 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @ce229000 s1342632 r0 d13144 u1355776
[    0.000000] pcpu-alloc: s1342632 r0 d13144 u1355776 alloc=331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:e370461, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e22b540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64769
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 branch=l2-mtd/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-17-20-29-11-l2-mtd:master:b7aebb9-b7aebb9-i386-randconfig-k739-5-bens BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-k739/b7aebb9/vmlinuz-3.6.0-rc1-00420-gb7aebb9
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 181656k/262136k available (11441k kernel code, 79980k reserved, 5283k data, 1916k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2056000 - 0xc2235000   (1916 kB)
[    0.000000]       .data : 0xc1b2c6e7 - 0xc20553e0   (5283 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1b2c6e7   (11441 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=cc40a000 soft=cc40c000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.696 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5333.39 BogoMIPS (lpj=10666784)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] Security Framework initialized
[    0.004119] Mount-cache hash table entries: 512
[    0.006249] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006249] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006249] tlb_flushall_shift is 0x6
[    0.016157] ACPI: Core revision 20120711
[    0.020333] ftrace: allocating 37197 entries in 73 pages
[    0.036045] Getting VERSION: 50014
[    0.036670] Getting VERSION: 50014
[    0.037255] Getting ID: 0
[    0.037717] Getting ID: f000000
[    0.038256] Getting LVT0: 8700
[    0.038791] Getting LVT1: 8400
[    0.039322] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.040207] enabled ExtINT on CPU#0
[    0.042215] ENABLING IO-APIC IRQs
[    0.042794] init IO_APIC IRQs
[    0.043305]  apic 2 pin 0 not connected
[    0.043953] BUG: scheduling while atomic: swapper/0/1/0x10000002
[    0.044017] no locks held by swapper/0/1.
[    0.044692] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1-00420-gb7aebb9 #34
[    0.045861] Call Trace:
[    0.048071]  [<c106361e>] __schedule_bug+0x5e/0x70
[    0.048890]  [<c1b28701>] __schedule+0x91/0xb10
[    0.049660]  [<c14472ea>] ? vsnprintf+0x33a/0x450
[    0.050444]  [<c1060006>] ? lg_local_lock+0x6/0x70
[    0.051256]  [<c14fb5b1>] ? wait_for_xmitr+0x31/0x90
[    0.052019]  [<c144fd55>] ? do_raw_spin_unlock+0xa5/0xf0
[    0.052903]  [<c1b2a532>] ? _raw_spin_unlock+0x22/0x30
[    0.053759]  [<c105cdbb>] ? up+0x1b/0x70
[    0.054421]  [<c1065d6b>] __cond_resched+0x1b/0x30
[    0.055228]  [<c1b292d5>] _cond_resched+0x45/0x50
[    0.056020]  [<c1b26c58>] mutex_lock_nested+0x28/0x370
[    0.056884]  [<c1034222>] ? console_unlock+0x3a2/0x4e0
[    0.057741]  [<c1ac8559>] __irq_alloc_descs+0x39/0x1c0
[    0.058589]  [<c10223bc>] io_apic_setup_irq_pin+0x2c/0x310
[    0.060042]  [<c20638df>] setup_IO_APIC+0x101/0x744
[    0.060878]  [<c1021d51>] ? clear_IO_APIC+0x31/0x50
[    0.061695]  [<c20600f4>] native_smp_prepare_cpus+0x538/0x680
[    0.062644]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
[    0.063517]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
[    0.064016]  [<c2056adc>] kernel_init+0x4b/0x17f
[    0.064790]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
[    0.065660]  [<c1b2bbd6>] kernel_thread_helper+0x6/0x10
[    0.066592] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.068045] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.069373] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.070710] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.072065] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.073397] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.074710] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.076035] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.077376] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.078714] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.080038] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.081396] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.082751] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.084037] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.085375] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.086715]  apic 2 pin 16 not connected
[    0.088010]  apic 2 pin 17 not connected
[    0.088657]  apic 2 pin 18 not connected
[    0.089319]  apic 2 pin 19 not connected
[    0.089974]  apic 2 pin 20 not connected
[    0.090632]  apic 2 pin 21 not connected
[    0.091296]  apic 2 pin 22 not connected
[    0.092014]  apic 2 pin 23 not connected
[    0.092834] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.094219] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.095873] Using local APIC timer interrupts.
[    0.095873] calibrating APIC timer ...
[    0.100006] ... lapic delta = 6248602
[    0.100006] ... PM-Timer delta = 357868
[    0.100006] ... PM-Timer result ok
[    0.100006] ..... delta 6248602
[    0.100006] ..... mult: 268358639
[    0.100006] ..... calibration result: 3999105
[    0.100006] ..... CPU clock speed is 2666.0073 MHz.
[    0.100006] ..... host bus clock speed is 999.3105 MHz.
[    0.100103] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.103575] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.105028] SMP alternatives: lockdep: fixing up alternatives
[    0.106578] CPU 1 irqstacks, hard=cc4cc000 soft=cc4ce000
[    0.108014] smpboot: Booting Node   0, Processors  #1 OK
[    0.004000] Initializing CPU#1
[    0.004000] kvm-clock: cpu 1, msr 0:e4bb461, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.132160] KVM setup async PF for cpu 1
[    0.132239] Brought up 2 CPUs
[    0.132241] smpboot: Total of 2 processors activated (10666.78 BogoMIPS)
[    0.132366] CPU0 attaching sched-domain:
[    0.132370]  domain 0: span 0-1 level CPU
[    0.132374]   groups: 0 (cpu_power = 1023) 1
[    0.132382] CPU1 attaching sched-domain:
[    0.132384]  domain 0: span 0-1 level CPU
[    0.132386]   groups: 1 0 (cpu_power = 1023)
[    0.133342] devtmpfs: initialized
[    0.133393] device: 'platform': device_add
[    0.133449] PM: Adding info for No Bus:platform
[    0.133497] bus: 'platform': registered
[    0.133517] bus: 'cpu': registered
[    0.133520] device: 'cpu': device_add
[    0.133546] PM: Adding info for No Bus:cpu
[    0.138190] bus: 'virtio': registered
[    0.138192] cma: cma_init_reserved_areas()
[    0.138194] cma: cma_create_area(base 0000d000, count 1000)
[    0.138471] cma: cma_create_area: returned cc400590
[    0.138718] NET: Registered protocol family 16
[    0.139423] device class 'bdi': registering
[    0.139548] device class 'pci_bus': registering
[    0.139580] bus: 'pci': registered
[    0.139582] device class 'backlight': registering
[    0.139591] device class 'video_output': registering
[    0.139600] device class 'tty': registering
[    0.139724] bus: 'i2c': registered
[    0.139727] bus: 'i2c': add driver dummy
[    0.136008] kvm-stealtime: cpu 1, msr e376540
[    0.154411] ACPI: bus type pci registered
[    0.155090] device class 'dma': registering
[    0.155828] dca service started, version 1.12.1
[    0.156016] device class 'dca': registering
[    0.156903] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.157928] PCI: Using configuration type 1 for base access
[    0.160067] device: 'cpu0': device_add
[    0.160895] bus: 'cpu': add device cpu0
[    0.161563] PM: Adding info for cpu:cpu0
[    0.162236] device: 'cpu1': device_add
[    0.162873] bus: 'cpu': add device cpu1
[    0.163599] PM: Adding info for cpu:cpu1
[    0.174442] device: 'default': device_add
[    0.175190] PM: Adding info for No Bus:default
[    0.176584] bio: create slab <bio-0> at 0
[    0.177102] device class 'block': registering
[    0.178117] bus: 'i2c': add driver max7300
[    0.178117] bus: 'i2c': add driver max732x
[    0.180039] bus: 'i2c': add driver mcp230xx
[    0.180759] bus: 'i2c': add driver pcf857x
[    0.181460] bus: 'i2c': add driver sx150x
[    0.182140] bus: 'platform': add driver twl4030_gpio
[    0.182966] bus: 'platform': add driver wm8350-gpio
[    0.184034] bus: 'platform': add driver wm8994-gpio
[    0.184886] device class 'graphics': registering
[    0.185757] ACPI: Added _OSI(Module Device)
[    0.186461] ACPI: Added _OSI(Processor Device)
[    0.187191] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.188020] ACPI: Added _OSI(Processor Aggregator Device)
[    0.192927] ACPI: EC: Look up EC in DSDT
[    0.201675] ACPI: Interpreter enabled
[    0.202312] ACPI: (supports S0 S3 S5)
[    0.203051] ACPI: Using IOAPIC for interrupt routing
[    0.203909] bus: 'acpi': registered
[    0.204023] bus: 'acpi': add driver power
[    0.204732] device: 'LNXSYSTM:00': device_add
[    0.205463] bus: 'acpi': add device LNXSYSTM:00
[    0.206219] PM: Adding info for acpi:LNXSYSTM:00
[    0.207178] device: 'device:00': device_add
[    0.208027] bus: 'acpi': add device device:00
[    0.208824] PM: Adding info for acpi:device:00
[    0.209674] device: 'PNP0A03:00': device_add
[    0.210562] bus: 'acpi': add device PNP0A03:00
[    0.211304] PM: Adding info for acpi:PNP0A03:00
[    0.213370] device: 'device:01': device_add
[    0.214068] bus: 'acpi': add device device:01
[    0.214787] PM: Adding info for acpi:device:01
[    0.216107] device: 'device:02': device_add
[    0.216812] bus: 'acpi': add device device:02
[    0.217546] PM: Adding info for acpi:device:02
[    0.218384] device: 'PNP0B00:00': device_add
[    0.219099] bus: 'acpi': add device PNP0B00:00
[    0.219842] PM: Adding info for acpi:PNP0B00:00
[    0.220168] device: 'PNP0303:00': device_add
[    0.220879] bus: 'acpi': add device PNP0303:00
[    0.221631] PM: Adding info for acpi:PNP0303:00
[    0.222527] device: 'PNP0F13:00': device_add
[    0.223256] bus: 'acpi': add device PNP0F13:00
[    0.224031] PM: Adding info for acpi:PNP0F13:00
[    0.224977] device: 'PNP0700:00': device_add
[    0.225765] bus: 'acpi': add device PNP0700:00
[    0.226507] PM: Adding info for acpi:PNP0700:00
[    0.228140] device: 'PNP0400:00': device_add
[    0.228849] bus: 'acpi': add device PNP0400:00
[    0.229581] PM: Adding info for acpi:PNP0400:00
[    0.230543] device: 'PNP0501:00': device_add
[    0.231258] bus: 'acpi': add device PNP0501:00
[    0.232032] PM: Adding info for acpi:PNP0501:00
[    0.232965] device: 'device:03': device_add
[    0.233665] bus: 'acpi': add device device:03
[    0.234411] PM: Adding info for acpi:device:03
[    0.235303] device: 'device:04': device_add
[    0.236029] bus: 'acpi': add device device:04
[    0.236765] PM: Adding info for acpi:device:04
[    0.237621] device: 'device:05': device_add
[    0.238325] bus: 'acpi': add device device:05
[    0.239060] PM: Adding info for acpi:device:05
[    0.239912] device: 'device:06': device_add
[    0.240028] bus: 'acpi': add device device:06
[    0.240825] PM: Adding info for acpi:device:06
[    0.241684] device: 'device:07': device_add
[    0.242377] bus: 'acpi': add device device:07
[    0.243099] PM: Adding info for acpi:device:07
[    0.244152] device: 'device:08': device_add
[    0.244840] bus: 'acpi': add device device:08
[    0.245574] PM: Adding info for acpi:device:08
[    0.246518] device: 'device:09': device_add
[    0.247282] bus: 'acpi': add device device:09
[    0.248033] PM: Adding info for acpi:device:09
[    0.248904] device: 'device:0a': device_add
[    0.249627] bus: 'acpi': add device device:0a
[    0.250367] PM: Adding info for acpi:device:0a
[    0.251310] device: 'device:0b': device_add
[    0.252034] bus: 'acpi': add device device:0b
[    0.252774] PM: Adding info for acpi:device:0b
[    0.253649] device: 'device:0c': device_add
[    0.254364] bus: 'acpi': add device device:0c
[    0.255098] PM: Adding info for acpi:device:0c
[    0.256151] device: 'device:0d': device_add
[    0.256935] bus: 'acpi': add device device:0d
[    0.257680] PM: Adding info for acpi:device:0d
[    0.258562] device: 'device:0e': device_add
[    0.259261] bus: 'acpi': add device device:0e
[    0.260044] PM: Adding info for acpi:device:0e
[    0.260902] device: 'device:0f': device_add
[    0.261613] bus: 'acpi': add device device:0f
[    0.262345] PM: Adding info for acpi:device:0f
[    0.263205] device: 'device:10': device_add
[    0.264031] bus: 'acpi': add device device:10
[    0.264761] PM: Adding info for acpi:device:10
[    0.265624] device: 'device:11': device_add
[    0.266326] bus: 'acpi': add device device:11
[    0.267057] PM: Adding info for acpi:device:11
[    0.268152] device: 'device:12': device_add
[    0.268858] bus: 'acpi': add device device:12
[    0.269583] PM: Adding info for acpi:device:12
[    0.270456] device: 'device:13': device_add
[    0.271160] bus: 'acpi': add device device:13
[    0.272034] PM: Adding info for acpi:device:13
[    0.272979] device: 'device:14': device_add
[    0.273685] bus: 'acpi': add device device:14
[    0.274410] PM: Adding info for acpi:device:14
[    0.275283] device: 'device:15': device_add
[    0.276031] bus: 'acpi': add device device:15
[    0.276760] PM: Adding info for acpi:device:15
[    0.277634] device: 'device:16': device_add
[    0.278335] bus: 'acpi': add device device:16
[    0.279067] PM: Adding info for acpi:device:16
[    0.279930] device: 'device:17': device_add
[    0.280032] bus: 'acpi': add device device:17
[    0.280757] PM: Adding info for acpi:device:17
[    0.281626] device: 'device:18': device_add
[    0.282329] bus: 'acpi': add device device:18
[    0.283057] PM: Adding info for acpi:device:18
[    0.284258] device: 'device:19': device_add
[    0.284953] bus: 'acpi': add device device:19
[    0.285676] PM: Adding info for acpi:device:19
[    0.286522] device: 'device:1a': device_add
[    0.287218] bus: 'acpi': add device device:1a
[    0.288103] PM: Adding info for acpi:device:1a
[    0.288978] device: 'device:1b': device_add
[    0.289678] bus: 'acpi': add device device:1b
[    0.290414] PM: Adding info for acpi:device:1b
[    0.291279] device: 'device:1c': device_add
[    0.292035] bus: 'acpi': add device device:1c
[    0.292771] PM: Adding info for acpi:device:1c
[    0.293632] device: 'device:1d': device_add
[    0.294328] bus: 'acpi': add device device:1d
[    0.295049] PM: Adding info for acpi:device:1d
[    0.296156] device: 'device:1e': device_add
[    0.296861] bus: 'acpi': add device device:1e
[    0.297582] PM: Adding info for acpi:device:1e
[    0.298455] device: 'device:1f': device_add
[    0.299143] bus: 'acpi': add device device:1f
[    0.299869] PM: Adding info for acpi:device:1f
[    0.300154] device: 'device:20': device_add
[    0.300862] bus: 'acpi': add device device:20
[    0.301583] PM: Adding info for acpi:device:20
[    0.302523] device: 'device:21': device_add
[    0.303233] bus: 'acpi': add device device:21
[    0.304037] PM: Adding info for acpi:device:21
[    0.304918] device: 'device:22': device_add
[    0.305609] bus: 'acpi': add device device:22
[    0.306336] PM: Adding info for acpi:device:22
[    0.308156] device: 'PNP0103:00': device_add
[    0.308879] bus: 'acpi': add device PNP0103:00
[    0.309623] PM: Adding info for acpi:PNP0103:00
[    0.310673] device: 'PNP0C0F:00': device_add
[    0.311433] bus: 'acpi': add device PNP0C0F:00
[    0.312037] PM: Adding info for acpi:PNP0C0F:00
[    0.313005] device: 'PNP0C0F:01': device_add
[    0.313711] bus: 'acpi': add device PNP0C0F:01
[    0.314448] PM: Adding info for acpi:PNP0C0F:01
[    0.315426] device: 'PNP0C0F:02': device_add
[    0.316032] bus: 'acpi': add device PNP0C0F:02
[    0.316767] PM: Adding info for acpi:PNP0C0F:02
[    0.317929] device: 'PNP0C0F:03': device_add
[    0.318646] bus: 'acpi': add device PNP0C0F:03
[    0.319394] PM: Adding info for acpi:PNP0C0F:03
[    0.320275] device: 'PNP0C0F:04': device_add
[    0.320986] bus: 'acpi': add device PNP0C0F:04
[    0.321731] PM: Adding info for acpi:PNP0C0F:04
[    0.322643] device: 'LNXCPU:00': device_add
[    0.323348] bus: 'acpi': add device LNXCPU:00
[    0.324048] PM: Adding info for acpi:LNXCPU:00
[    0.324917] device: 'LNXCPU:01': device_add
[    0.325626] bus: 'acpi': add device LNXCPU:01
[    0.326361] PM: Adding info for acpi:LNXCPU:01
[    0.327316] device: 'device:23': device_add
[    0.328046] bus: 'acpi': add device device:23
[    0.328770] PM: Adding info for acpi:device:23
[    0.329570] device: 'LNXPWRBN:00': device_add
[    0.330286] bus: 'acpi': add device LNXPWRBN:00
[    0.331024] PM: Adding info for acpi:LNXPWRBN:00
[    0.332450] bus: 'acpi': add driver ec
[    0.333236] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.334717] bus: 'acpi': add driver pci_root
[    0.335424] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.336028] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.337334] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.338401] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.340037] device: 'pci0000:00': device_add
[    0.340775] PM: Adding info for No Bus:pci0000:00
[    0.341555] device: '0000:00': device_add
[    0.342254] PM: Adding info for No Bus:0000:00
[    0.344058] PCI host bridge to bus 0000:00
[    0.344764] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.346054] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.346955] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.348028] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.349048] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.350176] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.351375] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.352538] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.354249] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.357651] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.359677] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.360675] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.361872] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.364286] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.368218] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.370595] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.377760] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.379662] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.380465] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.382157] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.387120] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.388570] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.390020] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.392083] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.397163] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.398623] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.400410] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.405552] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.406992] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.408725] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.413868] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.415306] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.416746] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.422224] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.423691] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.424734] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.430566] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.432060] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.433627] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.438848] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.440085] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.443945] pci_bus 0000:00: on NUMA node 0
[    0.444086] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.446577]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.448035]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.449276] device: '0000:00:00.0': device_add
[    0.451423] bus: 'pci': add device 0000:00:00.0
[    0.452195] PM: Adding info for pci:0000:00:00.0
[    0.453034] device: '0000:00:01.0': device_add
[    0.455082] bus: 'pci': add device 0000:00:01.0
[    0.456090] PM: Adding info for pci:0000:00:01.0
[    0.456876] device: '0000:00:01.1': device_add
[    0.458934] bus: 'pci': add device 0000:00:01.1
[    0.460152] PM: Adding info for pci:0000:00:01.1
[    0.460946] device: '0000:00:01.3': device_add
[    0.463014] bus: 'pci': add device 0000:00:01.3
[    0.464082] PM: Adding info for pci:0000:00:01.3
[    0.464871] device: '0000:00:02.0': device_add
[    0.466944] bus: 'pci': add device 0000:00:02.0
[    0.467830] PM: Adding info for pci:0000:00:02.0
[    0.468056] device: '0000:00:03.0': device_add
[    0.470132] bus: 'pci': add device 0000:00:03.0
[    0.470940] PM: Adding info for pci:0000:00:03.0
[    0.472052] device: '0000:00:04.0': device_add
[    0.474125] bus: 'pci': add device 0000:00:04.0
[    0.474989] PM: Adding info for pci:0000:00:04.0
[    0.476054] device: '0000:00:05.0': device_add
[    0.478109] bus: 'pci': add device 0000:00:05.0
[    0.478913] PM: Adding info for pci:0000:00:05.0
[    0.479689] device: '0000:00:06.0': device_add
[    0.481363] bus: 'pci': add device 0000:00:06.0
[    0.482219] PM: Adding info for pci:0000:00:06.0
[    0.483005] device: '0000:00:07.0': device_add
[    0.485375] bus: 'pci': add device 0000:00:07.0
[    0.486170] PM: Adding info for pci:0000:00:07.0
[    0.486944] device: '0000:00:08.0': device_add
[    0.489358] bus: 'pci': add device 0000:00:08.0
[    0.490245] PM: Adding info for pci:0000:00:08.0
[    0.491031] device: '0000:00:09.0': device_add
[    0.493124] bus: 'pci': add device 0000:00:09.0
[    0.493931] PM: Adding info for pci:0000:00:09.0
[    0.494713] device: '0000:00:0a.0': device_add
[    0.496802] bus: 'pci': add device 0000:00:0a.0
[    0.497657] PM: Adding info for pci:0000:00:0a.0
[    0.498449] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.499611] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.500141] bus: 'acpi': add driver pci_link
[    0.500899] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.502272] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.504173] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.505292] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.506420] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.507637] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.508038] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.509400] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.510503] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.512039] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.513250] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.514603] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.516146] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.517266] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.518392] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.520045] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.521417] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.522787] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.524278] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.525410] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.526625] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    0.528039] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    0.529420] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.530448] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    0.531624] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    0.532108] bus: 'pnp': registered
[    0.532704] device class 'misc': registering
[    0.533498] device: 'vga_arbiter': device_add
[    0.534560] PM: Adding info for No Bus:vga_arbiter
[    0.536119] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.537462] vgaarb: loaded
[    0.537916] vgaarb: bridge control possible 0000:00:02.0
[    0.538808] bus: 'i2c': add driver stmpe-i2c
[    0.539602] bus: 'i2c': add driver tc3589x
[    0.540061] bus: 'i2c': add driver WM8400
[    0.540747] bus: 'i2c': add driver wm831x
[    0.541431] bus: 'i2c': add driver wm8350
[    0.542106] tps65010: version 2 May 2005
[    0.542754] bus: 'i2c': add driver tps65010
[    0.543498] bus: 'i2c': remove driver tps65010
[    0.544050] driver: 'tps65010': driver_release
[    0.560109] bus: 'i2c': add driver tps65010
[    0.560938] bus: 'i2c': remove driver tps65010
[    0.561690] driver: 'tps65010': driver_release
[    0.576085] bus: 'i2c': add driver tps65010
[    0.576894] bus: 'i2c': remove driver tps65010
[    0.577632] driver: 'tps65010': driver_release
[    0.578367] tps65010: no chip?
[    0.578881] bus: 'i2c': add driver tps6507x
[    0.579599] bus: 'i2c': add driver tps65217
[    0.580065] bus: 'i2c': add driver tps65910
[    0.580791] bus: 'i2c': add driver twl
[    0.581439] bus: 'i2c': add driver mc13xxx
[    0.582146] bus: 'i2c': add driver max8925
[    0.582980] bus: 'i2c': add driver max8998
[    0.583682] bus: 'i2c': add driver tps65090
[    0.584064] bus: 'i2c': add driver aat2870
[    0.584763] bus: 'i2c': add driver palmas
[    0.586051] device class 'scsi_host': registering
[    0.586921] bus: 'scsi': registered
[    0.588044] device class 'scsi_device': registering
[    0.588942] SCSI subsystem initialized
[    0.589582] ACPI: bus type scsi registered
[    0.590254] device class 'ata_link': registering
[    0.591046] device class 'ata_port': registering
[    0.591824] device class 'ata_device': registering
[    0.592087] libata version 3.00 loaded.
[    0.592719] device class 'mdio_bus': registering
[    0.593577] bus: 'mdio_bus': registered
[    0.594228] bus: 'mdio_bus': add driver Generic PHY
[    0.595142] ACPI: bus type usb registered
[    0.596197] bus: 'usb': registered
[    0.596789] bus: 'usb': add driver usbfs
[    0.597470] usbcore: registered new interface driver usbfs
[    0.598393] bus: 'usb': add driver hub
[    0.599025] usbcore: registered new interface driver hub
[    0.600343] bus: 'usb': add driver usb
[    0.600731] usbcore: registered new device driver usb
[    0.601575] bus: 'platform': add driver nop_usb_xceiv
[    0.602435] device class 'udc': registering
[    0.603164] bus: 'serio': registered
[    0.604068] bus: 'gameport': registered
[    0.604709] device class 'input': registering
[    0.605473] bus: 'i2c': add driver tca6416-keypad
[    0.606269] device class 'pps': registering
[    0.606979] pps_core: LinuxPPS API ver. 1 registered
[    0.608045] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.609534] device class 'ptp': registering
[    0.610240] PTP clock support registered
[    0.610903] device class 'power_supply': registering
[    0.611770] device class 'hwmon': registering
[    0.612056] device class 'watchdog': registering
[    0.612964] bus: 'mmc': registered
[    0.613529] device class 'mmc_host': registering
[    0.614331] bus: 'sdio': registered
[    0.614915] device class 'leds': registering
[    0.616056] device class 'wmi': registering
[    0.616771] bus: 'acpi': add driver wmi
[    0.617491] wmi: Mapper loaded
[    0.618007] PCI: Using ACPI for IRQ routing
[    0.618716] PCI: pci_cache_line_size set to 64 bytes
[    0.620367] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.621369] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.622394] device class 'net': registering
[    0.623246] device: 'lo': device_add
[    0.624067] PM: Adding info for No Bus:lo
[    0.624957] irda_init()
[    0.625584] NET: Registered protocol family 23
[    0.626382] NetLabel: Initializing
[    0.626947] NetLabel:  domain hash size = 128
[    0.627657] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.628111] NetLabel:  unlabeled traffic allowed by default
[    0.629035] device class 'rfkill': registering
[    0.629798] device: 'rfkill': device_add
[    0.630550] PM: Adding info for No Bus:rfkill
[    0.632556] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.637284] Switching to clocksource kvm-clock
[    0.638061] Warning: could not register annotated branches stats
[    0.786323] bus: 'pnp': add driver system
[    0.787165] pnp: PnP ACPI init
[    0.787697] device: 'pnp0': device_add
[    0.788358] PM: Adding info for No Bus:pnp0
[    0.789048] ACPI: bus type pnp registered
[    0.789768] pnp 00:00: [bus 00-ff]
[    0.790331] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.791021] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.791805] pnp 00:00: [io  0x0d00-0xffff window]
[    0.792626] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.793512] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.794406] device: '00:00': device_add
[    0.795205] bus: 'pnp': add device 00:00
[    0.795888] PM: Adding info for pnp:00:00
[    0.796631] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.797758] pnp 00:01: [io  0x0070-0x0071]
[    0.798448] pnp 00:01: [irq 8]
[    0.798965] pnp 00:01: [io  0x0072-0x0077]
[    0.799650] device: '00:01': device_add
[    0.800354] bus: 'pnp': add device 00:01
[    0.801027] PM: Adding info for pnp:00:01
[    0.801714] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.802910] pnp 00:02: [io  0x0060]
[    0.803480] pnp 00:02: [io  0x0064]
[    0.804087] pnp 00:02: [irq 1]
[    0.804599] device: '00:02': device_add
[    0.805274] bus: 'pnp': add device 00:02
[    0.805954] PM: Adding info for pnp:00:02
[    0.806629] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.807868] pnp 00:03: [irq 12]
[    0.808434] device: '00:03': device_add
[    0.809152] bus: 'pnp': add device 00:03
[    0.809836] PM: Adding info for pnp:00:03
[    0.810510] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.811641] pnp 00:04: [io  0x03f2-0x03f5]
[    0.812350] pnp 00:04: [io  0x03f7]
[    0.812942] pnp 00:04: [irq 6]
[    0.813453] pnp 00:04: [dma 2]
[    0.813975] device: '00:04': device_add
[    0.814657] bus: 'pnp': add device 00:04
[    0.815404] PM: Adding info for pnp:00:04
[    0.816126] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.817327] pnp 00:05: [io  0x0378-0x037f]
[    0.818025] pnp 00:05: [irq 7]
[    0.818537] device: '00:05': device_add
[    0.819216] bus: 'pnp': add device 00:05
[    0.819882] PM: Adding info for pnp:00:05
[    0.820599] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.821779] pnp 00:06: [io  0x03f8-0x03ff]
[    0.822461] pnp 00:06: [irq 4]
[    0.822985] device: '00:06': device_add
[    0.823676] bus: 'pnp': add device 00:06
[    0.824374] PM: Adding info for pnp:00:06
[    0.825058] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.826633] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.827428] device: '00:07': device_add
[    0.828235] bus: 'pnp': add device 00:07
[    0.828913] PM: Adding info for pnp:00:07
[    0.829591] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.830990] pnp: PnP ACPI: found 8 devices
[    0.831674] ACPI: ACPI bus type pnp unregistered
[    0.832510] device class 'mem': registering
[    0.833230] device: 'mem': device_add
[    0.833955] PM: Adding info for No Bus:mem
[    0.834690] device: 'null': device_add
[    0.835477] PM: Adding info for No Bus:null
[    0.836227] device: 'port': device_add
[    0.836920] PM: Adding info for No Bus:port
[    0.837632] device: 'zero': device_add
[    0.838309] PM: Adding info for No Bus:zero
[    0.839166] device: 'full': device_add
[    0.839922] PM: Adding info for No Bus:full
[    0.840665] device: 'random': device_add
[    0.841362] PM: Adding info for No Bus:random
[    0.842101] device: 'urandom': device_add
[    0.842828] PM: Adding info for No Bus:urandom
[    0.843562] device: 'kmsg': device_add
[    0.844337] PM: Adding info for No Bus:kmsg
[    0.845043] device: 'oldmem': device_add
[    0.845778] PM: Adding info for No Bus:oldmem
[    0.846515] device: 'tty': device_add
[    0.847207] PM: Adding info for No Bus:tty
[    0.847927] device: 'console': device_add
[    0.848680] PM: Adding info for No Bus:console
[    0.849429] device class 'firmware': registering
[    0.850217] device class 'thermal': registering
[    0.885718] bus: 'bcma': registered
[    0.886322] bus: 'pci': add driver bcma-pci-bridge
[    0.887268] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.888224] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.889130] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.890140] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.891368] NET: Registered protocol family 2
[    0.892777] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.896432] TCP bind hash table entries: 8192 (order: 6, 360448 bytes)
[    0.898270] TCP: Hash tables configured (established 8192 bind 8192)
[    0.899469] TCP: reno registered
[    0.900263] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.901495] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.902940] NET: Registered protocol family 1
[    0.903692] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.904730] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.905729] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.906802] pci 0000:00:02.0: Boot video device
[    0.907714] PCI: CLS 0 bytes, default 64
[    0.908792] Unpacking initramfs...
[    3.770017] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    3.773717] device class 'msr': registering
[    3.774435] device: 'msr0': device_add
[    3.775328] PM: Adding info for No Bus:msr0
[    3.776048] device: 'msr1': device_add
[    3.776789] PM: Adding info for No Bus:msr1
[    3.777493] device class 'cpuid': registering
[    3.778221] device: 'cpu0': device_add
[    3.778902] PM: Adding info for No Bus:cpu0
[    3.779613] device: 'cpu1': device_add
[    3.780309] PM: Adding info for No Bus:cpu1
[    3.781021] Registering platform device 'pcspkr'. Parent at platform
[    3.782055] device: 'pcspkr': device_add
[    3.782710] bus: 'platform': add device pcspkr
[    3.783501] PM: Adding info for platform:pcspkr
[    3.784310] NatSemi SCx200 Driver
[    3.784867] bus: 'pci': add driver scx200
[    3.785672] bus: 'clocksource': registered
[    3.786345] device: 'clocksource': device_add
[    3.787116] PM: Adding info for No Bus:clocksource
[    3.787901] device: 'clocksource0': device_add
[    3.788659] bus: 'clocksource': add device clocksource0
[    3.789509] PM: Adding info for clocksource:clocksource0
[    3.790402] bus: 'platform': add driver alarmtimer
[    3.791208] Registering platform device 'alarmtimer'. Parent at platform
[    3.792320] device: 'alarmtimer': device_add
[    3.793030] bus: 'platform': add device alarmtimer
[    3.793823] PM: Adding info for platform:alarmtimer
[    3.794632] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    3.796068] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    3.797446] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    3.798598] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    3.799928] audit: initializing netlink socket (disabled)
[    3.800885] type=2000 audit(1345207241.800:1): initialized
[    3.802258] bus: 'event_source': registered
[    3.802960] device: 'breakpoint': device_add
[    3.803675] bus: 'event_source': add device breakpoint
[    3.804687] PM: Adding info for event_source:breakpoint
[    3.805559] device: 'tracepoint': device_add
[    3.806266] bus: 'event_source': add device tracepoint
[    3.807118] PM: Adding info for event_source:tracepoint
[    3.808111] device: 'software': device_add
[    3.808821] bus: 'event_source': add device software
[    3.809639] PM: Adding info for event_source:software
[    3.811356] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.827235] VFS: Disk quotas dquot_6.5.2
[    3.828266] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.830383] device: 'dlm-control': device_add
[    3.831235] PM: Adding info for No Bus:dlm-control
[    3.832036] device: 'dlm-monitor': device_add
[    3.832917] PM: Adding info for No Bus:dlm-monitor
[    3.833739] device: 'dlm_plock': device_add
[    3.834470] PM: Adding info for No Bus:dlm_plock
[    3.835236] DLM installed
[    3.838417] device: 'autofs': device_add
[    3.839123] PM: Adding info for No Bus:autofs
[    3.839852] fuse init (API version 7.19)
[    3.840990] device: 'fuse': device_add
[    3.841668] PM: Adding info for No Bus:fuse
[    3.842376] device class 'cuse': registering
[    3.843171] device: 'cuse': device_add
[    3.843844] PM: Adding info for No Bus:cuse
[    3.844576] SGI XFS with security attributes, no debug enabled
[    3.849077] NILFS version 2 loaded
[    3.849657] OCFS2 1.5.0
[    3.850717] ocfs2: Registered cluster interface o2cb
[    3.851523] OCFS2 DLMFS 1.5.0
[    3.852474] OCFS2 User DLM kernel interface loaded
[    3.853269] OCFS2 Node Manager 1.5.0
[    3.856036] OCFS2 DLM 1.5.0
[    3.858308] device: 'btrfs-control': device_add
[    3.859121] PM: Adding info for No Bus:btrfs-control
[    3.859968] Btrfs loaded
[    3.861672] alg: No test for cipher_null (cipher_null-generic)
[    3.862678] cryptomgr_test (31) used greatest stack depth: 7324 bytes left
[    3.862793] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    3.865011] alg: No test for digest_null (digest_null-generic)
[    3.866225] alg: No test for compress_null (compress_null-generic)
[    3.871905] cryptomgr_test (35) used greatest stack depth: 6420 bytes left
[    3.891515] cryptomgr_test (40) used greatest stack depth: 6380 bytes left
[    3.914096] alg: No test for fcrypt (fcrypt-generic)
[    3.946072] cryptomgr_test (55) used greatest stack depth: 6072 bytes left
[    3.948599] alg: No test for stdrng (krng)
[    3.961934] NET: Registered protocol family 38
[    3.962689] device class 'bsg': registering
[    3.963392] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    3.964627] io scheduler noop registered (default)
[    3.965638] bus: 'platform': add driver gpio_ich
[    3.966513] bus: 'platform': add driver rdc321x-gpio
[    3.967348] bus: 'platform': add driver sch_gpio
[    3.968129] bus: 'platform': add driver timb-gpio
[    3.968948] bus: 'platform': add driver vx855_gpio
[    3.969879] bus: 'pci': add driver pci-stub
[    3.970619] bus: 'pci': add driver CyberPro
[    3.971413] bus: 'pci': add driver pm2fb
[    3.972101] bus: 'pci': add driver pm3fb
[    3.972818] bus: 'pci': add driver i740fb
[    3.973512] bus: 'pci': add driver matroxfb
[    3.974253] bus: 'pci': add driver nvidiafb
[    3.974985] bus: 'pci': add driver kyrofb
[    3.975690] bus: 'pci': add driver savagefb
[    3.976513] bus: 'pci': add driver tdfxfb
[    3.977218] bus: 'pci': add driver imsttfb
[    3.977936] bus: 'pci': add driver vt8623fb
[    3.978662] bus: 'pci': add driver tridentfb
[    3.979395] vmlfb: initializing
[    3.979922] bus: 'pci': add driver vmlfb
[    3.980642] Could not find Carillo Ranch MCH device.
[    3.981444] bus: 'pci': add driver sstfb
[    3.982125] bus: 'platform': add driver auo_k1900fb
[    3.982941] bus: 'platform': add driver sm501-fb
[    3.983716] bus: 'usb': add driver smscufx
[    3.984502] usbcore: registered new interface driver smscufx
[    3.985430] bus: 'pci': add driver mb862xxfb
[    3.986176] Registering platform device 'vesafb.0'. Parent at platform
[    3.987232] device: 'vesafb.0': device_add
[    3.987912] bus: 'platform': add device vesafb.0
[    3.988708] PM: Adding info for platform:vesafb.0
[    3.989490] bus: 'platform': add driver vesafb
[    3.990297] bus: 'platform': driver_probe_device: matched device vesafb.0 with driver vesafb
[    3.991651] bus: 'platform': really_probe: probing driver vesafb with device vesafb.0
[    3.992953] vesafb: probe of vesafb.0 rejects match -19
[    3.993823] bus: 'platform': remove driver vesafb
[    3.994604] driver: 'vesafb': driver_release
[    3.995297] PM: Removing info for platform:vesafb.0
[    3.996137] bus: 'platform': remove device vesafb.0
[    3.996984] bus: 'acpi': add driver ac
[    3.997674] bus: 'acpi': add driver button
[    3.998392] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    3.999742] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    4.001031] device: 'input0': device_add
[    4.001744] PM: Adding info for No Bus:input0
[    4.002480] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.003683] ACPI: Power Button [PWRF]
[    4.004351] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    4.005443] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    4.006724] bus: 'acpi': add driver fan
[    4.007454] bus: 'acpi': add driver video
[    4.008174] bus: 'acpi': add driver processor
[    4.008959] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    4.010314] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    4.011904] device: 'cooling_device0': device_add
[    4.012726] PM: Adding info for No Bus:cooling_device0
[    4.013604] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    4.014715] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    4.015920] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    4.017310] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    4.018777] device: 'cooling_device1': device_add
[    4.019540] PM: Adding info for No Bus:cooling_device1
[    4.020430] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    4.021546] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    4.026484] bus: 'acpi': add driver container
[    4.029675] bus: 'acpi': add driver thermal
[    4.030520] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.031656] bus: 'pci': add driver ioatdma
[    4.032429] bus: 'acpi': add driver battery
[    4.033212] bus: 'platform': add driver timb-dma
[    4.033987] bus: 'pci': add driver pch-dma
[    4.034711] bus: 'virtio': add driver virtio_balloon
[    4.035551] HDLC line discipline maxframe=4096
[    4.036311] N_HDLC line discipline registered.
[    4.037047] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.037930] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.039061] Registering platform device 'serial8250'. Parent at platform
[    4.040149] device: 'serial8250': device_add
[    4.040885] bus: 'platform': add device serial8250
[    4.041682] PM: Adding info for platform:serial8250
[    4.064840] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.065831] device: 'ttyS0': device_add
[    4.066531] PM: Adding info for No Bus:ttyS0
[    4.067388] device: 'ttyS1': device_add
[    4.068085] PM: Adding info for No Bus:ttyS1
[    4.068892] device: 'ttyS2': device_add
[    4.069579] PM: Adding info for No Bus:ttyS2
[    4.070351] device: 'ttyS3': device_add
[    4.071120] PM: Adding info for No Bus:ttyS3
[    4.071855] bus: 'platform': add driver serial8250
[    4.072670] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    4.074104] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    4.075462] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    4.076635] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    4.077930] bus: 'pnp': add driver serial
[    4.078661] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[    4.079901] bus: 'pnp': really_probe: probing driver serial with device 00:06
[    4.081111] device: 'ttyS0': device_unregister
[    4.081838] PM: Removing info for No Bus:ttyS0
[    4.082775] device: 'ttyS0': device_create_release
[    4.105808] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.106723] device: 'ttyS0': device_add
[    4.107415] PM: Adding info for No Bus:ttyS0
[    4.108156] driver: '00:06': driver_bound: bound to device 'serial'
[    4.109202] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    4.110320] bus: 'pci': add driver serial
[    4.111142] bus: 'pci': add driver jsm
[    4.111876] Cyclades driver 2.6
[    4.127367] bus: 'pci': add driver cyclades
[    4.128179] MOXA Smartio/Industio family driver version 2.0.5
[    4.129143] bus: 'pci': add driver mxser
[    4.129827] Initializing Nozomi driver 2.1d
[    4.130515] bus: 'pci': add driver nozomi
[    4.131214] RocketPort device driver module, version 2.09, 12-June-2003
[    4.132328] No rocketport ports found; unloading driver
[    4.133226] device: 'ttyprintk': device_add
[    4.133969] PM: Adding info for No Bus:ttyprintk
[    4.134827] device class 'raw': registering
[    4.135522] device: 'rawctl': device_add
[    4.136531] PM: Adding info for No Bus:rawctl
[    4.137392] device: 'rtc': device_add
[    4.138136] PM: Adding info for No Bus:rtc
[    4.138918] Real Time Clock Driver v1.12b
[    4.139580] device: 'nvram': device_add
[    4.140371] PM: Adding info for No Bus:nvram
[    4.141093] Non-volatile memory driver v1.3
[    4.141786] toshiba: not a supported Toshiba laptop
[    4.142574] scx200_gpio: no SCx200 gpio present
[    4.143318] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[    4.144485] device: 'pc8736x_gpio.0': device_add
[    4.145251] bus: 'platform': add device pc8736x_gpio.0
[    4.146098] PM: Adding info for platform:pc8736x_gpio.0
[    4.146967] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    4.148134] platform pc8736x_gpio.0: no device found
[    4.148972] PM: Removing info for platform:pc8736x_gpio.0
[    4.149876] bus: 'platform': remove device pc8736x_gpio.0
[    4.150759] nsc_gpio initializing
[    4.151305] bus: 'platform': add driver ipmi
[    4.152024] ipmi message handler version 39.2
[    4.152834] IPMI Watchdog: driver initialized
[    4.153545] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.154979] Hangcheck: Using getrawmonotonic().
[    4.155802] bus: 'pnp': add driver tpm_tis
[    4.156540] device class 'drm': registering
[    4.157442] [drm] Initialized drm 1.1.0 20060810
[    4.158205] device: 'ttm': device_add
[    4.158833] PM: Adding info for No Bus:ttm
[    4.160047] [drm] radeon defaulting to userspace modesetting.
[    4.167938] bus: 'pci': add driver mgag200
[    4.168679] bus: 'pci': add driver cirrus
[    4.169348] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver cirrus
[    4.170702] bus: 'pci': really_probe: probing driver cirrus with device 0000:00:02.0
[    4.173069] device: 'controlD64': device_add
[    4.174080] PM: Adding info for No Bus:controlD64
[    4.175085] device: 'card0': device_add
[    4.175856] PM: Adding info for No Bus:card0
[    4.176874] [TTM] Zone  kernel: Available graphics memory: 99020 kiB
[    4.177906] [TTM] Initializing pool allocator
[    4.217128] [drm] fb mappable at 0x0
[    4.217726] [drm] vram aper at 0x0
[    4.218285] [drm] size 0
[    4.218727] [drm] fb depth is 24
[    4.219258] [drm]    pitch is 3840
[    4.219829] device: 'fb0': device_add
[    4.220705] PM: Adding info for No Bus:fb0
[    4.221500] fb0: cirrusdrmfb frame buffer device
[    4.222260] drm: registered panic notifier
[    4.222939] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
[    4.224115] driver: '0000:00:02.0': driver_bound: bound to device 'cirrus'
[    4.225257] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver cirrus
[    4.226908] bus: 'pci': add driver nouveau
[    4.227630] bus: 'i2c': add driver sil164
[    4.228331] bus: 'pci': add driver poulsbo
[    4.229095] bus: 'isa': registered
[    4.229660] device: 'isa': device_add
[    4.230270] PM: Adding info for No Bus:isa
[    4.230946] bus: 'pci': add driver ibmasm
[    4.231674] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.232776] bus: 'i2c': add driver ad_dpot
[    4.233462] bus: 'i2c': add driver bmp085
[    4.234167] lkdtm: No crash points registered, enable through debugfs
[    4.235214] bus: 'i2c': add driver bh1780
[    4.235894] bus: 'pci': add driver IOC4
[    4.236585] device class 'enclosure': registering
[    4.237370] device class 'iLO': registering
[    4.238072] bus: 'pci': add driver hpilo
[    4.238763] bus: 'i2c': add driver apds9802als
[    4.239505] i2c-core: driver [apds9802als] using legacy suspend method
[    4.240594] i2c-core: driver [apds9802als] using legacy resume method
[    4.241646] bus: 'i2c': add driver isl29003
[    4.242345] i2c-core: driver [isl29003] using legacy suspend method
[    4.243364] i2c-core: driver [isl29003] using legacy resume method
[    4.244396] bus: 'i2c': add driver tsl2550
[    4.245085] i2c-core: driver [tsl2550] using legacy suspend method
[    4.246087] i2c-core: driver [tsl2550] using legacy resume method
[    4.247079] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    4.248268] device class 'c2port': registering
[    4.249008] bus: 'i2c': add driver hmc6352
[    4.249727] bus: 'i2c': add driver at24
[    4.250380] bus: 'pci': add driver cb710
[    4.251071] bus: 'pci': add driver pch_phub
[    4.251800] bus: 'i2c': add driver fsa9480
[    4.252508] i2c-core: driver [fsa9480] using legacy suspend method
[    4.253512] i2c-core: driver [fsa9480] using legacy resume method
[    4.254503] bus: 'platform': add driver sm501
[    4.255259] bus: 'pci': add driver sm501
[    4.255949] bus: 'i2c': add driver wm8994
[    4.256657] bus: 'pci': add driver timberdale
[    4.257402] Driver for timberdale has been successfully registered.
[    4.258417] bus: 'pci': add driver lpc_sch
[    4.259156] bus: 'pci': add driver lpc_ich
[    4.259878] bus: 'pci': add driver RDC321x Southbridge
[    4.260784] bus: 'pci': add driver vx855
[    4.261470] Uniform Multi-Platform E-IDE driver
[    4.262234] bus: 'ide': registered
[    4.262799] device class 'ide_port': registering
[    4.263570] bus: 'pci': add driver cs5536
[    4.264348] bus: 'pci': add driver AEC62xx_IDE
[    4.265123] bus: 'pci': add driver ALI15x3_IDE
[    4.265898] bus: 'pci': add driver ATIIXP_IDE
[    4.266683] bus: 'pci': add driver CMD64x_IDE
[    4.267436] bus: 'pci': add driver Cyrix_IDE
[    4.268182] bus: 'pci': add driver CS5530 IDE
[    4.268966] bus: 'pci': add driver CS5535_IDE
[    4.269723] bus: 'pci': add driver Promise_IDE
[    4.270485] bus: 'pci': add driver RZ1000_IDE
[    4.271239] bus: 'pci': add driver Serverworks_IDE
[    4.272092] bus: 'pci': add driver SLC90e66_IDE
[    4.272900] bus: 'pci': add driver TRM290_IDE
[    4.273650] bus: 'pci': add driver VIA_IDE
[    4.274357] device class 'ide_tape': registering
[    4.275156] bus: 'ide': add driver ide-tape
[    4.275864] bus: 'platform': add driver pata_platform
[    4.276733] device class 'fc_host': registering
[    4.277478] device class 'fc_vports': registering
[    4.278259] device class 'fc_remote_ports': registering
[    4.279122] device class 'fc_transport': registering
[    4.279940] device class 'sas_host': registering
[    4.280732] device class 'sas_phy': registering
[    4.281478] device class 'sas_port': registering
[    4.282242] device class 'sas_device': registering
[    4.283039] device class 'sas_end_device': registering
[    4.283891] device class 'sas_expander': registering
[    4.284789] device class 'scsi_disk': registering
[    4.285568] bus: 'scsi': add driver sd
[    4.286224] device class 'scsi_generic': registering
[    4.287103] SCSI Media Changer driver v0.25 
[    4.287806] device class 'scsi_changer': registering
[    4.288673] bus: 'scsi': add driver ch
[    4.289311] bus: 'scsi': add driver ses
[    4.289965] device class 'scsi_osd': registering
[    4.290737] bus: 'scsi': add driver osd
[    4.291385] osd: LOADED open-osd 0.2.1
[    4.292008] bus: 'pci': add driver ahci
[    4.292713] bus: 'platform': add driver ahci
[    4.293429] bus: 'platform': remove driver ahci
[    4.294185] driver: 'ahci': driver_release
[    4.295830] Rounding down aligned max_sectors from 4294967295 to 8388600
[    4.297437] device: 'tcm_loop_0': device_add
[    4.298155] PM: Adding info for No Bus:tcm_loop_0
[    4.298953] bus: 'tcm_loop_bus': registered
[    4.299645] bus: 'tcm_loop_bus': add driver tcm_loop
[    4.300524] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.301991] device: 'eql': device_add
[    4.302732] PM: Adding info for No Bus:eql
[    4.303847] bus: 'mdio_bus': add driver Marvell 88E1101
[    4.304770] bus: 'mdio_bus': add driver Marvell 88E1112
[    4.305638] bus: 'mdio_bus': add driver Marvell 88E1111
[    4.306506] bus: 'mdio_bus': add driver Marvell 88E1118
[    4.307381] bus: 'mdio_bus': add driver Marvell 88E1121R
[    4.308294] bus: 'mdio_bus': add driver Marvell 88E1318S
[    4.309176] bus: 'mdio_bus': add driver Marvell 88E1145
[    4.310044] bus: 'mdio_bus': add driver Marvell 88E1149R
[    4.310922] bus: 'mdio_bus': add driver Marvell 88E1240
[    4.311788] bus: 'mdio_bus': add driver Cicada Cis8201
[    4.312667] bus: 'mdio_bus': add driver Cicada Cis8204
[    4.313515] bus: 'mdio_bus': add driver LXT970
[    4.314261] bus: 'mdio_bus': add driver LXT971
[    4.315030] bus: 'mdio_bus': add driver LXT973
[    4.315781] bus: 'mdio_bus': add driver QS6612
[    4.316552] bus: 'mdio_bus': add driver SMSC LAN83C185
[    4.317405] bus: 'mdio_bus': add driver SMSC LAN8187
[    4.318235] bus: 'mdio_bus': add driver SMSC LAN8700
[    4.319063] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    4.320071] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[    4.321045] bus: 'mdio_bus': add driver STe101p
[    4.321804] bus: 'mdio_bus': add driver STe100p
[    4.322556] bus: 'mdio_bus': add driver AM79C874
[    4.323325] bus: 'virtio': add driver virtio_net
[    4.324121] arcnet loaded.
[    4.324613] arcnet: COM90xx chipset support
[    4.623506] S3: No ARCnet cards found.
[    4.624190] arcnet: RIM I (entirely mem-mapped) support
[    4.625079] E-mail me if you actually test the RIM I driver, please!
[    4.626109] Given: node 00h, shmem 0h, irq 0
[    4.626809] No autoprobe for RIM I; you must specify the shmem and irq!
[    4.627887] arcnet: COM20020 ISA support (by David Woodhouse et al.)
[    4.628946]  arc%d: No autoprobe (yet) for IO mapped cards; you must specify the base address!
[    4.630331] arcnet: COM20020 PCI support
[    4.630986] bus: 'pci': add driver com20020
[    4.631722] vcan: Virtual CAN interface driver
[    4.632514] bus: 'usb': add driver stir4200
[    4.633224] usbcore: registered new interface driver stir4200
[    4.634156] bus: 'platform': add driver nsc-ircc
[    4.634975] bus: 'pnp': add driver nsc-ircc
[    4.635839] bus: 'platform': remove driver nsc-ircc
[    4.636678] driver: 'nsc-ircc': driver_release
[    4.637412] bus: 'pnp': remove driver nsc-ircc
[    4.638151] driver: 'nsc-ircc': driver_release
[    4.638878] w83977af_init()
[    4.639340] w83977af_open()
[    4.639807] w83977af_probe()
[    4.640427] w83977af_probe(), Wrong chip version
[    4.641155] w83977af_probe()
[    4.641805] w83977af_probe(), Wrong chip version
[    4.642534] bus: 'pci': add driver donauboe
[    4.643327] bus: 'pci': add driver vlsi_ir
[    4.644042] bus: 'usb': add driver mcs7780
[    4.644770] usbcore: registered new interface driver mcs7780
[    4.645912] bus: 'usb': add driver kingsun-sir
[    4.646666] usbcore: registered new interface driver kingsun-sir
[    4.647641] bus: 'usb': add driver ksdazzle-sir
[    4.648437] usbcore: registered new interface driver ksdazzle-sir
[    4.649425] bus: 'usb': add driver ks959-sir
[    4.650176] usbcore: registered new interface driver ks959-sir
[    4.651127] PPP generic driver version 2.4.2
[    4.651867] device class 'ppp': registering
[    4.652597] device: 'ppp': device_add
[    4.653353] PM: Adding info for No Bus:ppp
[    4.654067] PPP Deflate Compression module registered
[    4.654892] NET: Registered protocol family 24
[    4.655621] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[    4.657201] hdlc: HDLC support module revision 1.22
[    4.658011] bus: 'pci': add driver fst
[    4.658673] bus: 'pci': add driver lmc
[    4.659339] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    4.660368] SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org.
[    4.661395] device: 'sdla0': device_add
[    4.662168] PM: Adding info for No Bus:sdla0
[    4.662984] bus: 'pci': add driver wanXL
[    4.663674] bus: 'pci': add driver PC300
[    4.664409] bus: 'usb': add driver kaweth
[    4.665091] usbcore: registered new interface driver kaweth
[    4.665997] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    4.667205] bus: 'usb': add driver pegasus
[    4.667901] usbcore: registered new interface driver pegasus
[    4.668858] bus: 'usb': add driver rtl8150
[    4.669546] usbcore: registered new interface driver rtl8150
[    4.670713] bus: 'firewire': registered
[    4.671382] bus: 'pci': add driver firewire_ohci
[    4.672183] bus: 'pci': add driver nosy
[    4.672916] device class 'uwb_rc': registering
[    4.673678] bus: 'usb': add driver hwa-rc
[    4.674383] usbcore: registered new interface driver hwa-rc
[    4.675296] bus: 'platform': add driver oxu210hp-hcd
[    4.676135] bus: 'platform': add driver isp1362-hcd
[    4.676979] driver u132_hcd
[    4.677599] bus: 'platform': add driver u132_hcd
[    4.678377] bus: 'platform': add driver c67x00
[    4.679280] bus: 'usb': add driver wusb-cbaf
[    4.680001] usbcore: registered new interface driver wusb-cbaf
[    4.680984] bus: 'usb': add driver cdc_wdm
[    4.681674] usbcore: registered new interface driver cdc_wdm
[    4.682596] bus: 'usb': add driver usbtmc
[    4.683268] usbcore: registered new interface driver usbtmc
[    4.684177] bus: 'usb': add driver uas
[    4.684841] usbcore: registered new interface driver uas
[    4.685711] bus: 'usb': add driver mdc800
[    4.686417] usbcore: registered new interface driver mdc800
[    4.687328] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    4.688604] bus: 'usb': add driver microtekX6
[    4.689333] usbcore: registered new interface driver microtekX6
[    4.690357] bus: 'usb-serial': registered
[    4.691033] bus: 'usb': add driver usbserial
[    4.691781] usbcore: registered new interface driver usbserial
[    4.692763] bus: 'usb': add driver usbserial_generic
[    4.693593] usbcore: registered new interface driver usbserial_generic
[    4.694660] bus: 'usb-serial': add driver generic
[    4.695443] USB Serial support registered for generic
[    4.696289] usbserial: USB Serial Driver core
[    4.697037] bus: 'usb': add driver aircable
[    4.697738] usbcore: registered new interface driver aircable
[    4.698674] bus: 'usb-serial': add driver aircable
[    4.699471] USB Serial support registered for aircable
[    4.700335] bus: 'usb': add driver ch341
[    4.701000] usbcore: registered new interface driver ch341
[    4.701896] bus: 'usb-serial': add driver ch341-uart
[    4.702726] USB Serial support registered for ch341-uart
[    4.703596] bus: 'usb': add driver cp210x
[    4.704320] usbcore: registered new interface driver cp210x
[    4.705237] bus: 'usb-serial': add driver cp210x
[    4.706019] USB Serial support registered for cp210x
[    4.706841] bus: 'usb': add driver cyberjack
[    4.707556] usbcore: registered new interface driver cyberjack
[    4.708532] bus: 'usb-serial': add driver cyberjack
[    4.709347] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    4.710616] bus: 'usb': add driver io_edgeport
[    4.711360] usbcore: registered new interface driver io_edgeport
[    4.712366] bus: 'usb-serial': add driver edgeport_2
[    4.713198] USB Serial support registered for Edgeport 2 port adapter
[    4.714245] bus: 'usb-serial': add driver edgeport_4
[    4.715076] USB Serial support registered for Edgeport 4 port adapter
[    4.716124] bus: 'usb-serial': add driver edgeport_8
[    4.716979] USB Serial support registered for Edgeport 8 port adapter
[    4.718026] bus: 'usb-serial': add driver epic
[    4.718793] USB Serial support registered for EPiC device
[    4.719678] bus: 'usb': add driver empeg
[    4.720362] usbcore: registered new interface driver empeg
[    4.721258] bus: 'usb-serial': add driver empeg
[    4.722049] USB Serial support registered for empeg
[    4.722856] bus: 'usb': add driver ftdi_sio
[    4.723554] usbcore: registered new interface driver ftdi_sio
[    4.724513] bus: 'usb-serial': add driver ftdi_sio
[    4.725310] USB Serial support registered for FTDI USB Serial Device
[    4.726338] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[    4.727286] bus: 'usb': add driver funsoft
[    4.727973] usbcore: registered new interface driver funsoft
[    4.728918] bus: 'usb-serial': add driver funsoft
[    4.729700] USB Serial support registered for funsoft
[    4.730521] bus: 'usb': add driver garmin_gps
[    4.731252] usbcore: registered new interface driver garmin_gps
[    4.732215] bus: 'usb-serial': add driver garmin_gps
[    4.733070] USB Serial support registered for Garmin GPS usb/tty
[    4.734048] bus: 'usb': add driver ipw
[    4.734681] usbcore: registered new interface driver ipw
[    4.735541] bus: 'usb-serial': add driver ipw
[    4.736308] USB Serial support registered for IPWireless converter
[    4.737314] bus: 'usb': add driver ir_usb
[    4.737993] usbcore: registered new interface driver ir_usb
[    4.738901] bus: 'usb-serial': add driver ir-usb
[    4.739705] USB Serial support registered for IR Dongle
[    4.740590] ir_usb: v0.5:USB IR Dongle driver
[    4.741305] bus: 'usb': add driver metro_usb
[    4.742024] usbcore: registered new interface driver metro_usb
[    4.742975] bus: 'usb-serial': add driver metro-usb
[    4.743789] USB Serial support registered for Metrologic USB to Serial
[    4.744867] bus: 'usb': add driver mos7720
[    4.745546] usbcore: registered new interface driver mos7720
[    4.746463] bus: 'usb-serial': add driver moschip7720
[    4.747300] USB Serial support registered for Moschip 2 port adapter
[    4.748345] bus: 'usb': add driver mos7840
[    4.749062] usbcore: registered new interface driver mos7840
[    4.749985] bus: 'usb-serial': add driver mos7840
[    4.750782] USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    4.751989] bus: 'usb': add driver navman
[    4.752688] usbcore: registered new interface driver navman
[    4.753589] bus: 'usb-serial': add driver navman
[    4.754353] USB Serial support registered for navman
[    4.755162] bus: 'usb': add driver opticon
[    4.755848] usbcore: registered new interface driver opticon
[    4.756788] bus: 'usb-serial': add driver opticon
[    4.757602] USB Serial support registered for opticon
[    4.758426] bus: 'usb': add driver oti6858
[    4.759115] usbcore: registered new interface driver oti6858
[    4.760035] bus: 'usb-serial': add driver oti6858
[    4.760849] USB Serial support registered for oti6858
[    4.761681] bus: 'usb': add driver siemens_mpi
[    4.762421] usbcore: registered new interface driver siemens_mpi
[    4.763405] bus: 'usb-serial': add driver siemens_mpi
[    4.764256] USB Serial support registered for siemens_mpi
[    4.765207] bus: 'usb': add driver ssu100
[    4.765906] usbcore: registered new interface driver ssu100

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1-00420-gb7aebb9"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
# CONFIG_NEED_DMA_MAP_STATE is not set
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
# CONFIG_BLK_DEV_HT6560B is not set
CONFIG_BLK_DEV_QD65XX=y
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NET is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_MII=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
CONFIG_ARCNET_COM20020_PCI=y

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOE is not set
# CONFIG_PPTP is not set
CONFIG_PPPOL2TP=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=y
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
# CONFIG_N2 is not set
CONFIG_C101=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_PPP=y
# CONFIG_ISDN_PPP_VJ is not set
# CONFIG_ISDN_MPP is not set
CONFIG_IPPP_FILTER=y
CONFIG_ISDN_PPP_BSDCOMP=y
# CONFIG_ISDN_AUDIO is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
# CONFIG_ISDN_DRV_PCBIT is not set
# CONFIG_ISDN_DRV_SC is not set
# CONFIG_ISDN_DRV_ACT2000 is not set
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1ISA is not set
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
# CONFIG_MISDN_HFCUSB is not set
# CONFIG_MISDN_AVMFRITZ is not set
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
# CONFIG_IPMI_SI is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS65910 is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6030_PWM=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_KMS is not set
CONFIG_DRM_NOUVEAU=y
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_STUB_POULSBO=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_RENESAS_USBHS_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_TUSB6010=y
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_UAS=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
CONFIG_USB_MV_UDC=y
# CONFIG_USB_GADGET_MUSB_HDRC is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_GADGET_SUPERSPEED=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TWL6030_USB is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM3556 is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
# CONFIG_USBIP_CORE is not set
# CONFIG_ECHO is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_RTS_PSTOR is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
CONFIG_TRANZPORT=y
CONFIG_USB_SERIAL_QUATECH2=y
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_CXT1E1=y
# CONFIG_SBE_PMCC4_NCOMM is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_SBE_2T3E3=y
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_ACPI_WMI=y
CONFIG_MXM_WMI=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
CONFIG_VME_PIO2=y
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--tThc/1wpZn/ma/RB--
