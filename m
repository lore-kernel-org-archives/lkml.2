Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2IYLUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:20:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:22762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab2IYLTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="226170993"
Date: Tue, 25 Sep 2012 19:19:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>
Subject: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by
 0, t=10002 jiffies)
Message-ID: <20120925111938.GA4545@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

I've just bisected down one RCU stall problem:

[   12.035785] pktgen: Packet Generator for packet performance testing. Version: 2.74
[   12.435439] atkbd: probe of serio0 rejects match -19
[  111.700160] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10002 jiffies)
[  111.700171] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc5-00004-gda10491 #1
[  111.700178] Call Trace:
[  111.700475]  [<c10c3c84>] rcu_check_callbacks+0x544/0x570
[  111.700538]  [<c1075e86>] update_process_times+0x36/0x70
[  111.700547]  [<c10a6267>] tick_sched_timer+0x57/0xc0
[  111.700552]  [<c108758a>] __run_hrtimer.isra.31+0x4a/0xc0
[  111.700557]  [<c10a6210>] ? tick_nohz_handler+0xf0/0xf0
[  111.700559]  [<c1088155>] hrtimer_interrupt+0xf5/0x290
[  111.700562]  [<c1091cb8>] ? sched_clock_idle_wakeup_event+0x18/0x20
[  111.700565]  [<c10a6399>] ? tick_nohz_stop_idle+0x39/0x40
[  111.700572]  [<c104f56f>] smp_apic_timer_interrupt+0x4f/0x80
[  111.700587]  [<c1753636>] apic_timer_interrupt+0x2a/0x30
[  111.700593]  [<c10565b5>] ? native_safe_halt+0x5/0x10
[  111.700599]  [<c1039f89>] default_idle+0x29/0x50
[  111.700601]  [<c103a958>] cpu_idle+0x68/0xb0
[  111.700609]  [<c16f2ff7>] rest_init+0x67/0x70
[  111.700627]  [<c1af7929>] start_kernel+0x2ea/0x2f0
[  111.700629]  [<c1af7474>] ? repair_env_string+0x51/0x51
[  111.700631]  [<c1af72a2>] i386_start_kernel+0x78/0x7d
[  127.040302] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[  127.041308] CPA self-test:

to this commit:

commit 06ae115a1d551cd952d80df06eaf8b5153351875
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Sun Aug 14 15:56:54 2011 -0700

    rcu: Avoid having just-onlined CPU resched itself when RCU is idle

Thanks,
Fengguang

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-17262-2012-09-22-06-02-57-3.6.0-rc5-00004-gda10491-1"

[    0.000000] Linux version 3.6.0-rc5-00004-gda10491 (kbuild@bee) (gcc version 4.7.1 (Debian 4.7.1-6) ) #1 SMP PREEMPT Sat Sep 22 05:58:45 CST 2012
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
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x01ff9000-0x01ffffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128476(98%)
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
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1b7ec81, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1ad4000, node_mem_map cdd3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @cdd2b000 s25664 r0 d15296 u40960
[    0.000000] pcpu-alloc: s25664 r0 d15296 u40960 alloc=10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dd30c81, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd2d700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: trinity=5m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=pci/pci/yinghai-misc log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-09-22-05-59-20-pci:pci:yinghai-misc:da10491-da10491-i386-randconfig-b064-2-inn BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-b064/da10491/vmlinuz-3.6.0-rc5-00004-gda10491
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 213484k/262136k available (7511k kernel code, 48152k reserved, 3712k data, 548k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff3fe000   ( 748 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1af7000 - 0xc1b80000   ( 548 kB)
[    0.000000]       .data : 0xc1755e52 - 0xc1af60c0   (3712 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1755e52   (7511 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=cd808000 soft=cd80a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.550 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.10 BogoMIPS (lpj=26935500)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift is 0x6
[    0.022783] ACPI: Core revision 20120711
[    0.024728] Getting VERSION: 50014
[    0.025586] Getting VERSION: 50014
[    0.026447] Getting ID: 0
[    0.027197] Getting ID: f000000
[    0.028018] Getting LVT0: 8700
[    0.028822] Getting LVT1: 8400
[    0.029617] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.030078] enabled ExtINT on CPU#0
[    0.031896] ENABLING IO-APIC IRQs
[    0.032735] init IO_APIC IRQs
[    0.033527]  apic 2 pin 0 not connected
[    0.034551] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.036668] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.038774] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.040023] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.042109] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.044201] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.046289] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.050021] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.052097] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.054165] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.056285] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.058391] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.060022] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.062144] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.064250] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.066382]  apic 2 pin 16 not connected
[    0.067484]  apic 2 pin 17 not connected
[    0.068542]  apic 2 pin 18 not connected
[    0.070004]  apic 2 pin 19 not connected
[    0.071080]  apic 2 pin 20 not connected
[    0.072154]  apic 2 pin 21 not connected
[    0.073226]  apic 2 pin 22 not connected
[    0.074295]  apic 2 pin 23 not connected
[    0.075540] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.077369] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.080004] Using local APIC timer interrupts.
[    0.080004] calibrating APIC timer ...
[    0.090000] ... lapic delta = 6250038
[    0.090000] ... PM-Timer delta = 357954
[    0.090000] ... PM-Timer result ok
[    0.090000] ..... delta 6250038
[    0.090000] ..... mult: 268437088
[    0.090000] ..... calibration result: 10000060
[    0.090000] ..... CPU clock speed is 2693.4851 MHz.
[    0.090000] ..... host bus clock speed is 1000.0060 MHz.
[    0.090063] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.150038] CPU 1 irqstacks, hard=cd888000 soft=cd88a000
[    0.151656] smpboot: Booting Node   0, Processors  #1 OK
[    0.020000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:dd3ac81, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.190037] Brought up 2 CPUs
[    0.190903] smpboot: Total of 2 processors activated (10774.20 BogoMIPS)
[    0.192563] KVM setup async PF for cpu 1
[    0.192563] kvm-stealtime: cpu 1, msr dd37700
[    0.195138] CPU0 attaching sched-domain:
[    0.196072]  domain 0: span 0-1 level CPU
[    0.200004]   groups: 0 1
[    0.200981] CPU1 attaching sched-domain:
[    0.201887]  domain 0: span 0-1 level CPU
[    0.202962]   groups: 1 0
[    0.204013] device: 'platform': device_add
[    0.204013] PM: Adding info for No Bus:platform
[    0.204013] bus: 'platform': registered
[    0.204013] bus: 'cpu': registered
[    0.204014] device: 'cpu': device_add
[    0.205046] PM: Adding info for No Bus:cpu
[    0.211287] xor: automatically using best checksumming function:
[    0.310041]    pIII_sse  :   109.600 MB/sec
[    0.311193] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.312724] device class 'regulator': registering
[    0.314021] Registering platform device 'reg-dummy'. Parent at platform
[    0.315548] device: 'reg-dummy': device_add
[    0.316682] bus: 'platform': add device reg-dummy
[    0.317837] PM: Adding info for platform:reg-dummy
[    0.319020] bus: 'platform': add driver reg-dummy
[    0.320009] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.322038] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.323822] device: 'regulator.0': device_add
[    0.324778] PM: Adding info for No Bus:regulator.0
[    0.325812] dummy: 
[    0.326464] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.327752] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.329803] NET: Registered protocol family 16
[    0.330623] device class 'bdi': registering
[    0.331679] device class 'pci_bus': registering
[    0.332874] bus: 'pci': registered
[    0.333791] device: 'rapidio': device_add
[    0.334827] PM: Adding info for No Bus:rapidio
[    0.335925] bus: 'rapidio': registered
[    0.336901] device class 'lcd': registering
[    0.337939] device class 'backlight': registering
[    0.340010] device class 'video_output': registering
[    0.341157] device class 'tty': registering
[    0.342214] device class 'vtconsole': registering
[    0.343396] device: 'vtcon0': device_add
[    0.344480] PM: Adding info for No Bus:vtcon0
[    0.345627] bus: 'spi': registered
[    0.346622] device class 'spi_master': registering
[    0.347848] bus: 'hsi': registered
[    0.348884] bus: 'i2c': registered
[    0.350005] bus: 'i2c': add driver dummy
[    0.351714] ACPI: bus type pci registered
[    0.352769] device class 'dma': registering
[    0.353885] device class 'dmi': registering
[    0.354932] device: 'id': device_add
[    0.355938] PM: Adding info for No Bus:id
[    0.357201] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.358725] PCI: Using configuration type 1 for base access
[    0.360561] device: 'cpu0': device_add
[    0.361614] bus: 'cpu': add device cpu0
[    0.362679] PM: Adding info for cpu:cpu0
[    0.363825] device: 'cpu1': device_add
[    0.364880] bus: 'cpu': add device cpu1
[    0.365961] PM: Adding info for cpu:cpu1
[    0.369408] device: 'default': device_add
[    0.370016] PM: Adding info for No Bus:default
[    0.380147] bio: create slab <bio-0> at 0
[    0.381212] device class 'block': registering
[    0.550025] raid6: mmxx1     3057 MB/s
[    0.720023] raid6: mmxx2     3385 MB/s
[    0.890014] raid6: sse1x1    2585 MB/s
[    1.060021] raid6: sse1x2    3356 MB/s
[    1.230017] raid6: sse2x1    5371 MB/s
[    1.400010] raid6: sse2x2    6873 MB/s
[    1.401054] raid6: using algorithm sse2x2 (6873 MB/s)
[    1.402261] raid6: using intx1 recovery algorithm
[    1.403510] bus: 'spi': add driver 74x164
[    1.404584] bus: 'i2c': add driver max7300
[    1.405655] bus: 'i2c': add driver pcf857x
[    1.406735] bus: 'platform': add driver tc3589x-gpio
[    1.407939] bus: 'platform': add driver tps65912-gpio
[    1.409185] device class 'graphics': registering
[    1.410024] ACPI: Added _OSI(Module Device)
[    1.411110] ACPI: Added _OSI(Processor Device)
[    1.412231] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.413458] ACPI: Added _OSI(Processor Aggregator Device)
[    1.415330] ACPI: EC: Look up EC in DSDT
[    1.418232] ACPI: Interpreter enabled
[    1.419250] ACPI: (supports S0 S3 S5)
[    1.420755] ACPI: Using IOAPIC for interrupt routing
[    1.421966] bus: 'acpi': registered
[    1.423008] bus: 'acpi': add driver power
[    1.424085] device: 'LNXSYSTM:00': device_add
[    1.425191] bus: 'acpi': add device LNXSYSTM:00
[    1.426328] PM: Adding info for acpi:LNXSYSTM:00
[    1.427514] device: 'device:00': device_add
[    1.430007] bus: 'acpi': add device device:00
[    1.431186] PM: Adding info for acpi:device:00
[    1.432337] device: 'PNP0A03:00': device_add
[    1.433434] bus: 'acpi': add device PNP0A03:00
[    1.434558] PM: Adding info for acpi:PNP0A03:00
[    1.435876] device: 'device:01': device_add
[    1.436964] bus: 'acpi': add device device:01
[    1.440010] PM: Adding info for acpi:device:01
[    1.441164] device: 'device:02': device_add
[    1.442245] bus: 'acpi': add device device:02
[    1.443423] PM: Adding info for acpi:device:02
[    1.444573] device: 'PNP0B00:00': device_add
[    1.445671] bus: 'acpi': add device PNP0B00:00
[    1.446788] PM: Adding info for acpi:PNP0B00:00
[    1.447965] device: 'PNP0303:00': device_add
[    1.449065] bus: 'acpi': add device PNP0303:00
[    1.450010] PM: Adding info for acpi:PNP0303:00
[    1.451183] device: 'PNP0F13:00': device_add
[    1.452275] bus: 'acpi': add device PNP0F13:00
[    1.453471] PM: Adding info for acpi:PNP0F13:00
[    1.454649] device: 'PNP0700:00': device_add
[    1.455747] bus: 'acpi': add device PNP0700:00
[    1.456870] PM: Adding info for acpi:PNP0700:00
[    1.458119] device: 'PNP0400:00': device_add
[    1.459219] bus: 'acpi': add device PNP0400:00
[    1.460014] PM: Adding info for acpi:PNP0400:00
[    1.461250] device: 'PNP0501:00': device_add
[    1.462394] bus: 'acpi': add device PNP0501:00
[    1.463614] PM: Adding info for acpi:PNP0501:00
[    1.464815] device: 'device:03': device_add
[    1.465902] bus: 'acpi': add device device:03
[    1.467023] PM: Adding info for acpi:device:03
[    1.468197] device: 'device:04': device_add
[    1.469280] bus: 'acpi': add device device:04
[    1.470010] PM: Adding info for acpi:device:04
[    1.471161] device: 'device:05': device_add
[    1.472353] bus: 'acpi': add device device:05
[    1.473522] PM: Adding info for acpi:device:05
[    1.474680] device: 'device:06': device_add
[    1.475762] bus: 'acpi': add device device:06
[    1.476880] PM: Adding info for acpi:device:06
[    1.478032] device: 'device:07': device_add
[    1.480007] bus: 'acpi': add device device:07
[    1.481121] PM: Adding info for acpi:device:07
[    1.482270] device: 'device:08': device_add
[    1.483417] bus: 'acpi': add device device:08
[    1.484529] PM: Adding info for acpi:device:08
[    1.485678] device: 'device:09': device_add
[    1.486759] bus: 'acpi': add device device:09
[    1.487872] PM: Adding info for acpi:device:09
[    1.489026] device: 'device:0a': device_add
[    1.490007] bus: 'acpi': add device device:0a
[    1.491120] PM: Adding info for acpi:device:0a
[    1.492266] device: 'device:0b': device_add
[    1.493428] bus: 'acpi': add device device:0b
[    1.494531] PM: Adding info for acpi:device:0b
[    1.495679] device: 'device:0c': device_add
[    1.496769] bus: 'acpi': add device device:0c
[    1.497886] PM: Adding info for acpi:device:0c
[    1.499034] device: 'device:0d': device_add
[    1.500007] bus: 'acpi': add device device:0d
[    1.501121] PM: Adding info for acpi:device:0d
[    1.502276] device: 'device:0e': device_add
[    1.503426] bus: 'acpi': add device device:0e
[    1.504533] PM: Adding info for acpi:device:0e
[    1.505685] device: 'device:0f': device_add
[    1.506768] bus: 'acpi': add device device:0f
[    1.507881] PM: Adding info for acpi:device:0f
[    1.509032] device: 'device:10': device_add
[    1.510007] bus: 'acpi': add device device:10
[    1.511119] PM: Adding info for acpi:device:10
[    1.512265] device: 'device:11': device_add
[    1.513414] bus: 'acpi': add device device:11
[    1.514534] PM: Adding info for acpi:device:11
[    1.515682] device: 'device:12': device_add
[    1.516764] bus: 'acpi': add device device:12
[    1.517879] PM: Adding info for acpi:device:12
[    1.519030] device: 'device:13': device_add
[    1.520007] bus: 'acpi': add device device:13
[    1.521122] PM: Adding info for acpi:device:13
[    1.522289] device: 'device:14': device_add
[    1.523438] bus: 'acpi': add device device:14
[    1.524547] PM: Adding info for acpi:device:14
[    1.525697] device: 'device:15': device_add
[    1.526784] bus: 'acpi': add device device:15
[    1.527894] PM: Adding info for acpi:device:15
[    1.529047] device: 'device:16': device_add
[    1.530007] bus: 'acpi': add device device:16
[    1.531037] PM: Adding info for acpi:device:16
[    1.531737] device: 'device:17': device_add
[    1.532473] bus: 'acpi': add device device:17
[    1.533156] PM: Adding info for acpi:device:17
[    1.533862] device: 'device:18': device_add
[    1.534578] bus: 'acpi': add device device:18
[    1.535261] PM: Adding info for acpi:device:18
[    1.536233] device: 'device:19': device_add
[    1.537294] bus: 'acpi': add device device:19
[    1.538352] PM: Adding info for acpi:device:19
[    1.540039] device: 'device:1a': device_add
[    1.541088] bus: 'acpi': add device device:1a
[    1.542148] PM: Adding info for acpi:device:1a
[    1.543274] device: 'device:1b': device_add
[    1.544308] bus: 'acpi': add device device:1b
[    1.545416] PM: Adding info for acpi:device:1b
[    1.546543] device: 'device:1c': device_add
[    1.547595] bus: 'acpi': add device device:1c
[    1.548669] PM: Adding info for acpi:device:1c
[    1.549780] device: 'device:1d': device_add
[    1.550007] bus: 'acpi': add device device:1d
[    1.551084] PM: Adding info for acpi:device:1d
[    1.552206] device: 'device:1e': device_add
[    1.553255] bus: 'acpi': add device device:1e
[    1.554354] PM: Adding info for acpi:device:1e
[    1.555509] device: 'device:1f': device_add
[    1.556579] bus: 'acpi': add device device:1f
[    1.557659] PM: Adding info for acpi:device:1f
[    1.558762] device: 'device:20': device_add
[    1.560007] bus: 'acpi': add device device:20
[    1.561069] PM: Adding info for acpi:device:20
[    1.562174] device: 'device:21': device_add
[    1.563215] bus: 'acpi': add device device:21
[    1.564286] PM: Adding info for acpi:device:21
[    1.565386] device: 'device:22': device_add
[    1.566451] bus: 'acpi': add device device:22
[    1.567519] PM: Adding info for acpi:device:22
[    1.568782] device: 'PNP0103:00': device_add
[    1.570008] bus: 'acpi': add device PNP0103:00
[    1.571085] PM: Adding info for acpi:PNP0103:00
[    1.572274] device: 'PNP0C0F:00': device_add
[    1.573340] bus: 'acpi': add device PNP0C0F:00
[    1.574418] PM: Adding info for acpi:PNP0C0F:00
[    1.575589] device: 'PNP0C0F:01': device_add
[    1.576683] bus: 'acpi': add device PNP0C0F:01
[    1.577782] PM: Adding info for acpi:PNP0C0F:01
[    1.578969] device: 'PNP0C0F:02': device_add
[    1.580007] bus: 'acpi': add device PNP0C0F:02
[    1.581090] PM: Adding info for acpi:PNP0C0F:02
[    1.582259] device: 'PNP0C0F:03': device_add
[    1.583319] bus: 'acpi': add device PNP0C0F:03
[    1.584393] PM: Adding info for acpi:PNP0C0F:03
[    1.585599] device: 'PNP0C0F:04': device_add
[    1.586669] bus: 'acpi': add device PNP0C0F:04
[    1.587759] PM: Adding info for acpi:PNP0C0F:04
[    1.588912] device: 'LNXCPU:00': device_add
[    1.590009] bus: 'acpi': add device LNXCPU:00
[    1.591084] PM: Adding info for acpi:LNXCPU:00
[    1.592213] device: 'LNXCPU:01': device_add
[    1.593267] bus: 'acpi': add device LNXCPU:01
[    1.594341] PM: Adding info for acpi:LNXCPU:01
[    1.595480] device: 'device:23': device_add
[    1.596576] bus: 'acpi': add device device:23
[    1.597646] PM: Adding info for acpi:device:23
[    1.598727] device: 'LNXPWRBN:00': device_add
[    1.600008] bus: 'acpi': add device LNXPWRBN:00
[    1.601100] PM: Adding info for acpi:LNXPWRBN:00
[    1.602417] bus: 'acpi': add driver ec
[    1.603471] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.605614] bus: 'acpi': add driver pci_root
[    1.606684] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    1.608683] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    1.610025] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.611364] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.613219] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.615061] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.617049] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.618992] PCI: root bus 00: using default resources
[    1.620008] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.622517] device: 'pci0000:00': device_add
[    1.623572] PM: Adding info for No Bus:pci0000:00
[    1.624720] device: '0000:00': device_add
[    1.625766] PM: Adding info for No Bus:0000:00
[    1.626854] PCI host bridge to bus 0000:00
[    1.630007] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    1.631943] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.633164] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.634519] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    1.636031] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.637640] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.640450] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.643936] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.646145] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.647856] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.650016] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.651620] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.655025] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.657556] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    1.664416] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.666022] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.668200] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.670451] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.675448] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.676979] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.679162] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    1.680819] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    1.686494] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.688651] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    1.690807] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    1.696392] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.698551] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.700812] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    1.706355] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.708527] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    1.710812] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.716332] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.718511] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    1.720431] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.726014] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.728192] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    1.730425] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.735921] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.737684] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    1.741695] pci_bus 0000:00: on NUMA node 0
[    1.742765] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.744683]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.746554] device: '0000:00:00.0': device_add
[    1.748025] bus: 'pci': add device 0000:00:00.0
[    1.749156] PM: Adding info for pci:0000:00:00.0
[    1.750044] device: '0000:00:01.0': device_add
[    1.751461] bus: 'pci': add device 0000:00:01.0
[    1.752568] PM: Adding info for pci:0000:00:01.0
[    1.753673] device: '0000:00:01.1': device_add
[    1.755088] bus: 'pci': add device 0000:00:01.1
[    1.756211] PM: Adding info for pci:0000:00:01.1
[    1.757329] device: '0000:00:01.3': device_add
[    1.758734] bus: 'pci': add device 0000:00:01.3
[    1.760021] PM: Adding info for pci:0000:00:01.3
[    1.761122] device: '0000:00:02.0': device_add
[    1.762522] bus: 'pci': add device 0000:00:02.0
[    1.763642] PM: Adding info for pci:0000:00:02.0
[    1.764741] device: '0000:00:03.0': device_add
[    1.766144] bus: 'pci': add device 0000:00:03.0
[    1.767265] PM: Adding info for pci:0000:00:03.0
[    1.768358] device: '0000:00:04.0': device_add
[    1.769732] bus: 'pci': add device 0000:00:04.0
[    1.770030] PM: Adding info for pci:0000:00:04.0
[    1.771124] device: '0000:00:05.0': device_add
[    1.772518] bus: 'pci': add device 0000:00:05.0
[    1.773608] PM: Adding info for pci:0000:00:05.0
[    1.774709] device: '0000:00:06.0': device_add
[    1.776108] bus: 'pci': add device 0000:00:06.0
[    1.777213] PM: Adding info for pci:0000:00:06.0
[    1.778310] device: '0000:00:07.0': device_add
[    1.780342] bus: 'pci': add device 0000:00:07.0
[    1.781461] PM: Adding info for pci:0000:00:07.0
[    1.782565] device: '0000:00:08.0': device_add
[    1.783967] bus: 'pci': add device 0000:00:08.0
[    1.785100] PM: Adding info for pci:0000:00:08.0
[    1.786229] device: '0000:00:09.0': device_add
[    1.787608] bus: 'pci': add device 0000:00:09.0
[    1.788693] PM: Adding info for pci:0000:00:09.0
[    1.790011] device: '0000:00:0a.0': device_add
[    1.791391] bus: 'pci': add device 0000:00:0a.0
[    1.792486] PM: Adding info for pci:0000:00:0a.0
[    1.793586] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    1.795004] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    1.796891] bus: 'acpi': add driver pci_link
[    1.797941] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    1.800005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    1.801940] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.803665] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    1.805070] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    1.806898] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    1.808853] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    1.810057] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.811760] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    1.813181] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    1.815004] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    1.817007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    1.818948] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.820964] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    1.822392] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    1.824257] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    1.826257] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    1.828187] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.830471] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    1.831891] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    1.833723] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    1.835687] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    1.837619] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.839174] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    1.840009] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    1.841844] bus: 'pnp': registered
[    1.842765] bus: 'platform': add driver reg-fixed-voltage
[    1.843983] bus: 'i2c': add driver ad5398
[    1.844986] bus: 'platform': add driver da9052-regulator
[    1.846185] bus: 'i2c': add driver max8649
[    1.847211] bus: 'i2c': add driver max8660
[    1.848227] bus: 'i2c': add driver tps62360
[    1.849252] bus: 'i2c': add driver tps65023
[    1.850012] bus: 'platform': add driver tps6507x-pmic
[    1.851170] bus: 'platform': add driver tps65217-pmic
[    1.852336] bus: 'platform': add driver tps65912-pmic
[    1.853491] bus: 'platform': add driver wm8994-ldo
[    1.854643] device class 'misc': registering
[    1.855709] device: 'vga_arbiter': device_add
[    1.856793] PM: Adding info for No Bus:vga_arbiter
[    1.857929] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.860008] vgaarb: loaded
[    1.860824] vgaarb: bridge control possible 0000:00:02.0
[    1.862028] bus: 'i2c': add driver 88PM80X
[    1.863055] bus: 'i2c': add driver stmpe-i2c
[    1.864102] bus: 'i2c': add driver tc3589x
[    1.865156] bus: 'i2c': add driver WM8400
[    1.866194] bus: 'spi': add driver wm831x
[    1.867208] bus: 'i2c': add driver tps6105x
[    1.868228] tps65010: version 2 May 2005
[    1.869212] bus: 'i2c': add driver tps65010
[    1.870022] bus: 'i2c': remove driver tps65010
[    1.871089] driver: 'tps65010': driver_release
[    1.890015] bus: 'i2c': add driver tps65010
[    1.891061] bus: 'i2c': remove driver tps65010
[    1.892121] driver: 'tps65010': driver_release
[    1.910023] bus: 'i2c': add driver tps65010
[    1.911087] bus: 'i2c': remove driver tps65010
[    1.912142] driver: 'tps65010': driver_release
[    1.913171] tps65010: no chip?
[    1.914001] bus: 'i2c': add driver tps6507x
[    1.914995] bus: 'i2c': add driver tps65217
[    1.916018] bus: 'spi': add driver tps65912
[    1.917475] bus: 'spi': add driver mc13xxx
[    1.918638] bus: 'spi': add driver da9052
[    1.919778] bus: 'i2c': add driver da9052
[    1.920013] bus: 'i2c': add driver max77693
[    1.921013] bus: 'i2c': add driver max8925
[    1.922055] bus: 'i2c': add driver max8998
[    1.923059] bus: 'i2c': add driver pcf50633
[    1.924062] bus: 'i2c': add driver tps6586x
[    1.925060] bus: 'i2c': add driver aat2870
[    1.926466] bus: 'i2c': add driver palmas
[    1.927665] bus: 'i2c': add driver sec_pmic
[    1.928993] device class 'scsi_host': registering
[    1.930043] bus: 'scsi': registered
[    1.933961] device class 'scsi_device': registering
[    1.935051] SCSI subsystem initialized
[    1.936232] ACPI: bus type scsi registered
[    1.937517] device class 'ata_link': registering
[    1.937517] device class 'ata_port': registering
[    1.940010] device class 'ata_device': registering
[    1.941103] libata version 3.00 loaded.
[    1.942302] device class 'mdio_bus': registering
[    1.943603] bus: 'mdio_bus': registered
[    1.944561] bus: 'mdio_bus': add driver Generic PHY
[    1.945690] device class 'pcmcia_socket': registering
[    1.948368] ACPI: bus type usb registered
[    1.950018] bus: 'usb': registered
[    1.950929] bus: 'usb': add driver usbfs
[    1.952132] usbcore: registered new interface driver usbfs
[    1.953455] bus: 'usb': add driver hub
[    1.954564] usbcore: registered new interface driver hub
[    1.955791] bus: 'usb': add driver usb
[    1.955791] usbcore: registered new device driver usb
[    1.955791] device class 'udc': registering
[    1.960027] bus: 'serio': registered
[    1.960944] bus: 'gameport': registered
[    1.961921] device class 'input': registering
[    1.963033] bus: 'i2c': add driver tca8418_keypad
[    1.964148] bus: 'platform': add driver i2c-gpio
[    1.965217] Linux video capture interface: v2.00
[    1.966284] device class 'video4linux': registering
[    1.967527] device class 'dvb': registering
[    1.968705] device class 'power_supply': registering
[    1.970024] device class 'hwmon': registering
[    1.971056] device class 'watchdog': registering
[    1.980103] bus: 'mmc': registered
[    1.981031] device class 'mmc_host': registering
[    1.982111] bus: 'sdio': registered
[    1.983025] device class 'leds': registering
[    1.985178] device class 'sound': registering
[    1.986282] PCI: Using ACPI for IRQ routing
[    1.987292] PCI: pci_cache_line_size set to 64 bytes
[    1.988666] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.990009] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.991296] device class 'net': registering
[    1.992348] device: 'lo': device_add
[    1.993315] PM: Adding info for No Bus:lo
[    1.997854] NET: Registered protocol family 23
[    1.998941] Bluetooth: Core ver 2.16
[    2.000017] device class 'bluetooth': registering
[    2.001101] NET: Registered protocol family 31
[    2.002148] Bluetooth: HCI device and connection manager initialized
[    2.003463] Bluetooth: HCI socket layer initialized
[    2.004682] Bluetooth: L2CAP socket layer initialized
[    2.006261] Bluetooth: SCO socket layer initialized
[    2.007367] NET: Registered protocol family 8
[    2.008392] NET: Registered protocol family 20
[    2.010010] device class 'atm': registering
[    2.011710] Switching to clocksource kvm-clock
[    2.012917] bus: 'pnp': add driver system
[    2.013911] pnp: PnP ACPI init
[    2.014755] device: 'pnp0': device_add
[    2.015967] PM: Adding info for No Bus:pnp0
[    2.017014] ACPI: bus type pnp registered
[    2.018022] pnp 00:00: [bus 00-ff]
[    2.018920] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.018920] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.018920] pnp 00:00: [io  0x0d00-0xffff window]
[    2.019302] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.020498] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.021687] device: '00:00': device_add
[    2.024306] bus: 'pnp': add device 00:00
[    2.025461] PM: Adding info for pnp:00:00
[    2.026635] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.028143] pnp 00:01: [io  0x0070-0x0071]
[    2.029252] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.031175] pnp 00:01: [irq 8]
[    2.031940] pnp 00:01: [io  0x0072-0x0077]
[    2.032831] device: '00:01': device_add
[    2.034086] bus: 'pnp': add device 00:01
[    2.034970] PM: Adding info for pnp:00:01
[    2.035853] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.037101] pnp 00:02: [io  0x0060]
[    2.038516] pnp 00:02: [io  0x0064]
[    2.039326] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.041060] pnp 00:02: [irq 1]
[    2.041823] device: '00:02': device_add
[    2.042692] bus: 'pnp': add device 00:02
[    2.043678] PM: Adding info for pnp:00:02
[    2.044887] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.046494] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.050474] pnp 00:03: [irq 12]
[    2.051435] device: '00:03': device_add
[    2.052524] bus: 'pnp': add device 00:03
[    2.054132] PM: Adding info for pnp:00:03
[    2.055327] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.056860] pnp 00:04: [io  0x03f2-0x03f5]
[    2.057960] pnp 00:04: [io  0x03f7]
[    2.058980] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.061232] pnp 00:04: [irq 6]
[    2.062141] pnp 00:04: [dma 2]
[    2.063085] device: '00:04': device_add
[    2.064205] bus: 'pnp': add device 00:04
[    2.065282] PM: Adding info for pnp:00:04
[    2.066364] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.067959] pnp 00:05: [io  0x0378-0x037f]
[    2.069052] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.071155] pnp 00:05: [irq 7]
[    2.072103] device: '00:05': device_add
[    2.073155] bus: 'pnp': add device 00:05
[    2.074289] PM: Adding info for pnp:00:05
[    2.075384] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.076956] pnp 00:06: [io  0x03f8-0x03ff]
[    2.078042] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.080191] pnp 00:06: [irq 4]
[    2.081140] device: '00:06': device_add
[    2.082253] bus: 'pnp': add device 00:06
[    2.083391] PM: Adding info for pnp:00:06
[    2.084563] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.086215] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.087459] device: '00:07': device_add
[    2.088571] bus: 'pnp': add device 00:07
[    2.089641] PM: Adding info for pnp:00:07
[    2.090759] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.092437] pnp: PnP ACPI: found 8 devices
[    2.093616] ACPI: ACPI bus type pnp unregistered
[    2.094793] device class 'mem': registering
[    2.095943] device: 'mem': device_add
[    2.097010] PM: Adding info for No Bus:mem
[    2.098080] device: 'null': device_add
[    2.099111] PM: Adding info for No Bus:null
[    2.100244] device: 'port': device_add
[    2.101355] PM: Adding info for No Bus:port
[    2.102510] device: 'zero': device_add
[    2.103644] PM: Adding info for No Bus:zero
[    2.104784] device: 'full': device_add
[    2.105842] PM: Adding info for No Bus:full
[    2.106986] device: 'random': device_add
[    2.108062] PM: Adding info for No Bus:random
[    2.109234] device: 'urandom': device_add
[    2.110431] PM: Adding info for No Bus:urandom
[    2.111585] device: 'kmsg': device_add
[    2.112650] PM: Adding info for No Bus:kmsg
[    2.113832] device: 'oldmem': device_add
[    2.114920] PM: Adding info for No Bus:oldmem
[    2.116086] device: 'tty': device_add
[    2.117148] PM: Adding info for No Bus:tty
[    2.118264] device: 'console': device_add
[    2.119410] PM: Adding info for No Bus:console
[    2.120552] device: 'tty0': device_add
[    2.121624] PM: Adding info for No Bus:tty0
[    2.122699] device class 'vc': registering
[    2.123839] device: 'vcs': device_add
[    2.124891] PM: Adding info for No Bus:vcs
[    2.126065] device: 'vcsa': device_add
[    2.127169] PM: Adding info for No Bus:vcsa
[    2.128290] device: 'vcs1': device_add
[    2.129335] PM: Adding info for No Bus:vcs1
[    2.130481] device: 'vcsa1': device_add
[    2.131531] PM: Adding info for No Bus:vcsa1
[    2.132688] device: 'tty1': device_add
[    2.133800] PM: Adding info for No Bus:tty1
[    2.134944] device: 'tty2': device_add
[    2.136006] PM: Adding info for No Bus:tty2
[    2.137163] device: 'tty3': device_add
[    2.138304] PM: Adding info for No Bus:tty3
[    2.139446] device: 'tty4': device_add
[    2.140534] PM: Adding info for No Bus:tty4
[    2.141653] device: 'tty5': device_add
[    2.142724] PM: Adding info for No Bus:tty5
[    2.143877] device: 'tty6': device_add
[    2.144927] PM: Adding info for No Bus:tty6
[    2.146043] device: 'tty7': device_add
[    2.147107] PM: Adding info for No Bus:tty7
[    2.148207] device: 'tty8': device_add
[    2.149251] PM: Adding info for No Bus:tty8
[    2.150410] device: 'tty9': device_add
[    2.151474] PM: Adding info for No Bus:tty9
[    2.156098] device: 'tty10': device_add
[    2.157160] PM: Adding info for No Bus:tty10
[    2.158308] device: 'tty11': device_add
[    2.159396] PM: Adding info for No Bus:tty11
[    2.160559] device: 'tty12': device_add
[    2.161632] PM: Adding info for No Bus:tty12
[    2.162771] device: 'tty13': device_add
[    2.163958] PM: Adding info for No Bus:tty13
[    2.165144] device: 'tty14': device_add
[    2.166228] PM: Adding info for No Bus:tty14
[    2.167396] device: 'tty15': device_add
[    2.168482] PM: Adding info for No Bus:tty15
[    2.169651] device: 'tty16': device_add
[    2.170745] PM: Adding info for No Bus:tty16
[    2.171899] device: 'tty17': device_add
[    2.172858] PM: Adding info for No Bus:tty17
[    2.173563] device: 'tty18': device_add
[    2.174628] PM: Adding info for No Bus:tty18
[    2.175743] device: 'tty19': device_add
[    2.176809] PM: Adding info for No Bus:tty19
[    2.177950] device: 'tty20': device_add
[    2.179034] PM: Adding info for No Bus:tty20
[    2.180172] device: 'tty21': device_add
[    2.181219] PM: Adding info for No Bus:tty21
[    2.182323] device: 'tty22': device_add
[    2.183352] PM: Adding info for No Bus:tty22
[    2.184491] device: 'tty23': device_add
[    2.185525] PM: Adding info for No Bus:tty23
[    2.186648] device: 'tty24': device_add
[    2.187690] PM: Adding info for No Bus:tty24
[    2.188784] device: 'tty25': device_add
[    2.189835] PM: Adding info for No Bus:tty25
[    2.190959] device: 'tty26': device_add
[    2.192075] PM: Adding info for No Bus:tty26
[    2.193199] device: 'tty27': device_add
[    2.194227] PM: Adding info for No Bus:tty27
[    2.195359] device: 'tty28': device_add
[    2.196423] PM: Adding info for No Bus:tty28
[    2.197587] device: 'tty29': device_add
[    2.198619] PM: Adding info for No Bus:tty29
[    2.199279] device: 'tty30': device_add
[    2.200166] PM: Adding info for No Bus:tty30
[    2.201295] device: 'tty31': device_add
[    2.202368] PM: Adding info for No Bus:tty31
[    2.203516] device: 'tty32': device_add
[    2.204587] PM: Adding info for No Bus:tty32
[    2.205776] device: 'tty33': device_add
[    2.206825] PM: Adding info for No Bus:tty33
[    2.207888] device: 'tty34': device_add
[    2.208898] PM: Adding info for No Bus:tty34
[    2.210092] device: 'tty35': device_add
[    2.211260] PM: Adding info for No Bus:tty35
[    2.212386] device: 'tty36': device_add
[    2.213486] PM: Adding info for No Bus:tty36
[    2.214618] device: 'tty37': device_add
[    2.215697] PM: Adding info for No Bus:tty37
[    2.216835] device: 'tty38': device_add
[    2.217886] PM: Adding info for No Bus:tty38
[    2.219027] device: 'tty39': device_add
[    2.220133] PM: Adding info for No Bus:tty39
[    2.221288] device: 'tty40': device_add
[    2.222380] PM: Adding info for No Bus:tty40
[    2.223545] device: 'tty41': device_add
[    2.224668] PM: Adding info for No Bus:tty41
[    2.225900] device: 'tty42': device_add
[    2.226954] PM: Adding info for No Bus:tty42
[    2.228071] device: 'tty43': device_add
[    2.229034] PM: Adding info for No Bus:tty43
[    2.230208] device: 'tty44': device_add
[    2.231262] PM: Adding info for No Bus:tty44
[    2.232411] device: 'tty45': device_add
[    2.233500] PM: Adding info for No Bus:tty45
[    2.234640] device: 'tty46': device_add
[    2.235720] PM: Adding info for No Bus:tty46
[    2.236867] device: 'tty47': device_add
[    2.237958] PM: Adding info for No Bus:tty47
[    2.239164] device: 'tty48': device_add
[    2.240292] PM: Adding info for No Bus:tty48
[    2.241428] device: 'tty49': device_add
[    2.242403] PM: Adding info for No Bus:tty49
[    2.243445] device: 'tty50': device_add
[    2.244354] PM: Adding info for No Bus:tty50
[    2.245050] device: 'tty51': device_add
[    2.245909] PM: Adding info for No Bus:tty51
[    2.247039] device: 'tty52': device_add
[    2.248086] PM: Adding info for No Bus:tty52
[    2.248890] device: 'tty53': device_add
[    2.249958] PM: Adding info for No Bus:tty53
[    2.251139] device: 'tty54': device_add
[    2.252235] PM: Adding info for No Bus:tty54
[    2.253378] device: 'tty55': device_add
[    2.254461] PM: Adding info for No Bus:tty55
[    2.255584] device: 'tty56': device_add
[    2.256664] PM: Adding info for No Bus:tty56
[    2.257849] device: 'tty57': device_add
[    2.258890] PM: Adding info for No Bus:tty57
[    2.259943] device: 'tty58': device_add
[    2.260965] PM: Adding info for No Bus:tty58
[    2.262047] device: 'tty59': device_add
[    2.263038] PM: Adding info for No Bus:tty59
[    2.264111] device: 'tty60': device_add
[    2.265120] PM: Adding info for No Bus:tty60
[    2.266178] device: 'tty61': device_add
[    2.267165] PM: Adding info for No Bus:tty61
[    2.268229] device: 'tty62': device_add
[    2.269227] PM: Adding info for No Bus:tty62
[    2.270293] device: 'tty63': device_add
[    2.271276] PM: Adding info for No Bus:tty63
[    2.272383] device class 'firmware': registering
[    2.273557] bus: 'pcmcia': registered
[    2.274535] device class 'thermal': registering
[    2.310358] bus: 'ssb': registered
[    2.311346] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.312630] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    2.314046] NET: Registered protocol family 1
[    2.315222] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.316627] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.317978] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.319409] pci 0000:00:02.0: Boot video device
[    2.320681] PCI: CLS 0 bytes, default 64
[    2.321851] Unpacking initramfs...
[    3.046931] Freeing initrd memory: 25284k freed
[    3.057797] kvm: no hardware support
[    3.058915] device class 'msr': registering
[    3.060174] device: 'msr0': device_add
[    3.061661] PM: Adding info for No Bus:msr0
[    3.062666] device: 'msr1': device_add
[    3.065875] PM: Adding info for No Bus:msr1
[    3.066926] device class 'cpuid': registering
[    3.067998] device: 'cpu0': device_add
[    3.068974] PM: Adding info for No Bus:cpu0
[    3.070034] device: 'cpu1': device_add
[    3.071012] PM: Adding info for No Bus:cpu1
[    3.072086] apm: BIOS not found.
[    3.077212] Registering platform device 'pcspkr'. Parent at platform
[    3.078584] device: 'pcspkr': device_add
[    3.079592] bus: 'platform': add device pcspkr
[    3.085964] PM: Adding info for platform:pcspkr
[    3.087077] Registering platform device 'microcode'. Parent at platform
[    3.088517] device: 'microcode': device_add
[    3.098681] bus: 'platform': add device microcode
[    3.099847] PM: Adding info for platform:microcode
[    3.101054] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    3.102368] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    3.104042] device: 'microcode': device_add
[    3.105197] PM: Adding info for No Bus:microcode
[    3.106339] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.119073] bus: 'clocksource': registered
[    3.119917] device: 'clocksource': device_add
[    3.120946] PM: Adding info for No Bus:clocksource
[    3.121712] device: 'clocksource0': device_add
[    3.122923] bus: 'clocksource': add device clocksource0
[    3.127755] PM: Adding info for clocksource:clocksource0
[    3.129083] bus: 'platform': add driver alarmtimer
[    3.130299] Registering platform device 'alarmtimer'. Parent at platform
[    3.131853] device: 'alarmtimer': device_add
[    3.133032] bus: 'platform': add device alarmtimer
[    3.134275] PM: Adding info for platform:alarmtimer
[    3.135623] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    3.137944] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    3.140114] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    3.141687] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    3.143981] bus: 'rttest': registered
[    3.145131] device: 'rttest': device_add
[    3.146173] PM: Adding info for No Bus:rttest
[    3.147118] device: 'rttest0': device_add
[    3.148116] bus: 'rttest': add device rttest0
[    3.149160] PM: Adding info for rttest:rttest0
[    3.150324] device: 'rttest1': device_add
[    3.151325] bus: 'rttest': add device rttest1
[    3.152523] PM: Adding info for rttest:rttest1
[    3.153793] device: 'rttest2': device_add
[    3.155029] bus: 'rttest': add device rttest2
[    3.156183] PM: Adding info for rttest:rttest2
[    3.157473] device: 'rttest3': device_add
[    3.158569] bus: 'rttest': add device rttest3
[    3.163221] PM: Adding info for rttest:rttest3
[    3.166805] device: 'rttest4': device_add
[    3.167510] bus: 'rttest': add device rttest4
[    3.168595] PM: Adding info for rttest:rttest4
[    3.169889] device: 'rttest5': device_add
[    3.171131] bus: 'rttest': add device rttest5
[    3.172035] PM: Adding info for rttest:rttest5
[    3.176715] device: 'rttest6': device_add
[    3.177855] bus: 'rttest': add device rttest6
[    3.179042] PM: Adding info for rttest:rttest6
[    3.181742] device: 'rttest7': device_add
[    3.182864] bus: 'rttest': add device rttest7
[    3.184616] PM: Adding info for rttest:rttest7
[    3.185802] Initializing RT-Tester: OK
[    3.190039] audit: initializing netlink socket (disabled)
[    3.191758] type=2000 audit(1348264841.190:1): initialized
[    3.200477] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    3.208925] bus: 'event_source': registered
[    3.211225] device: 'breakpoint': device_add
[    3.212443] bus: 'event_source': add device breakpoint
[    3.213724] PM: Adding info for event_source:breakpoint
[    3.215027] device: 'software': device_add
[    3.216200] bus: 'event_source': add device software
[    3.217445] PM: Adding info for event_source:software
[    3.223021] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.232280] alg: No test for fcrypt (fcrypt-generic)
[    3.240933] alg: No test for stdrng (krng)
[    3.247162] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    3.248500] async_tx: api initialized (async)
[    3.249836] device class 'bsg': registering
[    3.251085] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.253118] io scheduler noop registered (default)
[    3.254203] start plist test
[    3.255870] end plist test
[    3.257433] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    3.258480] crc32: self tests passed, processed 225944 bytes in 259629 nsec
[    3.261326] crc32c: CRC_LE_BITS = 32
[    3.262199] crc32c: self tests passed, processed 225944 bytes in 1329306 nsec
[    3.263875] bus: 'platform': add driver basic-mmio-gpio
[    3.265176] bus: 'platform': add driver arizona-gpio
[    3.266534] bus: 'pci': add driver ml_ioh_gpio
[    3.267729] bus: 'pci': add driver pch_gpio
[    3.268889] bus: 'platform': add driver rdc321x-gpio
[    3.270282] bus: 'platform': add driver sch_gpio
[    3.271646] bus: 'pci': add driver sdv_gpio
[    3.272919] bus: 'platform': add driver vx855_gpio
[    3.274258] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.275625] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.276782] bus: 'pci': add driver compaq_pci_hotplug
[    3.278130] bus: 'pci': add driver shpchp
[    3.279348] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.280946] device: 'fbcon': device_add
[    3.280962] PM: Adding info for No Bus:fbcon
[    3.282992] bus: 'spi': add driver l4f00242t03
[    3.283959] bus: 'spi': add driver VGG2432A4
[    3.284894] bus: 'spi': add driver tdo24m
[    3.285794] bus: 'spi': add driver s6e63m0
[    3.286715] bus: 'platform': add driver generic-bl
[    3.287726] bus: 'platform': add driver pwm-backlight
[    3.288769] bus: 'platform': add driver da9052-wled
[    3.290238] bus: 'i2c': add driver adp8860_bl
[    3.291428] i2c-core: driver [adp8860_bl] using legacy suspend method
[    3.292920] i2c-core: driver [adp8860_bl] using legacy resume method
[    3.294416] bus: 'platform': add driver pcf50633-backlight
[    3.295760] bus: 'pci': add driver CyberPro
[    3.296918] rivafb_setup START
[    3.297867] bus: 'pci': add driver rivafb
[    3.299013] bus: 'pci': add driver nvidiafb
[    3.300252] bus: 'pci': add driver radeonfb
[    3.301427] bus: 'pci': add driver imsttfb
[    3.302480] bus: 'pci': add driver vt8623fb
[    3.303658] vmlfb: initializing
[    3.304703] bus: 'pci': add driver vmlfb
[    3.305886] Could not find Carillo Ranch MCH device.
[    3.307135] bus: 'platform': add driver hecubafb
[    3.308392] no IO addresses supplied
[    3.309464] bus: 'pci': add driver cirrusfb
[    3.310656] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver cirrusfb
[    3.312923] bus: 'pci': really_probe: probing driver cirrusfb with device 0000:00:02.0
[    3.315261] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
[    3.317581] device: 'fb0': device_add
[    3.318663] PM: Adding info for No Bus:fb0
[    3.319838] fbcon: CL Picasso4 (fb0) is primary device
[    3.321243] device: 'vtcon1': device_add
[    3.321255] PM: Adding info for No Bus:vtcon1
[    3.691785] Console: switching to colour frame buffer device 80x30
[    3.776411] driver: '0000:00:02.0': driver_bound: bound to device 'cirrusfb'
[    3.781572] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver cirrusfb
[    3.787942] bus: 'platform': add driver broadsheetfb
[    3.792628] bus: 'platform': add driver sm501-fb
[    3.929830] bus: 'usb': add driver smscufx
[    4.066211] usbcore: registered new interface driver smscufx
[    4.071486] tsc: Refined TSC clocksource calibration: 2693.504 MHz
[    4.341040] bus: 'acpi': add driver ac
[    4.502385] bus: 'acpi': add driver button
[    4.671240] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    5.007629] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    5.389481] device: 'input0': device_add
[    5.603307] PM: Adding info for No Bus:input0
[    5.795188] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.178586] ACPI: Power Button [PWRF]
[    6.349976] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    6.492478] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    6.856621] bus: 'acpi': add driver fan
[    7.071600] bus: 'acpi': add driver video
[    7.239227] bus: 'acpi': add driver processor
[    7.422956] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    7.815460] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    8.341766] device: 'cooling_device0': device_add
[    8.541205] PM: Adding info for No Bus:cooling_device0
[    8.726575] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    8.892414] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    9.231834] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    9.575210] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[   10.024670] device: 'cooling_device1': device_add
[   10.216540] PM: Adding info for No Bus:cooling_device1
[   10.451135] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[   10.688430] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[   11.288722] bus: 'acpi': add driver thermal
[   11.479911] bus: 'pci': add driver pch-dma
[   11.671724] bus: 'acpi': add driver battery
[   11.682628] bus: 'platform': add driver reg-virt-consumer
[   11.682654] bus: 'platform': add driver arizona-micsupp
[   11.682663] bus: 'platform': add driver arizona-ldo1
[   11.682688] bus: 'i2c': add driver lp872x
[   11.682712] bus: 'spi': add driver tps6524x
[   11.682767] device: 'ptmx': device_add
[   11.682816] PM: Adding info for No Bus:ptmx
[   11.682856] r3964: Philips r3964 Driver $Revision: 1.10 $
[   11.682865] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   11.682881] Registering platform device 'serial8250'. Parent at platform
[   11.682882] device: 'serial8250': device_add
[   11.682889] bus: 'platform': add device serial8250
[   11.682915] PM: Adding info for platform:serial8250
[   11.726382] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.726504] device: 'ttyS0': device_add
[   11.726619] PM: Adding info for No Bus:ttyS0
[   11.726723] device: 'ttyS1': device_add
[   11.726735] PM: Adding info for No Bus:ttyS1
[   11.726782] device: 'ttyS2': device_add
[   11.726793] PM: Adding info for No Bus:ttyS2
[   11.726848] device: 'ttyS3': device_add
[   11.726863] PM: Adding info for No Bus:ttyS3
[   11.728101] bus: 'platform': add driver serial8250
[   11.728121] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   11.728125] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   11.728131] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   11.728133] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   11.728157] bus: 'pnp': add driver serial
[   11.728220] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[   11.728222] bus: 'pnp': really_probe: probing driver serial with device 00:06
[   11.728262] device: 'ttyS0': device_unregister
[   11.728263] PM: Removing info for No Bus:ttyS0
[   11.728297] device: 'ttyS0': device_create_release
[   11.761387] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.761490] device: 'ttyS0': device_add
[   11.761597] PM: Adding info for No Bus:ttyS0
[   11.761659] driver: '00:06': driver_bound: bound to device 'serial'
[   11.761665] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[   11.761718] bus: 'pci': add driver serial
[   11.761796] bus: 'pci': add driver jsm
[   11.761830] bus: 'platform': add driver altera_uart
[   11.761849] bus: 'platform': add driver timb-uart
[   11.761862] bus: 'platform': add driver altera_jtaguart
[   11.761898] bus: 'pci': add driver pch_uart
[   11.761924] bus: 'platform': add driver xuartps
[   11.761943] bus: 'pcmcia': add driver ipwireless
[   11.762000] device class 'raw': registering
[   11.762017] device: 'rawctl': device_add
[   11.762040] PM: Adding info for No Bus:rawctl
[   11.762046] Generic RTC Driver v1.07
[   11.762053] device: 'rtc': device_add
[   11.762066] PM: Adding info for No Bus:rtc
[   11.762081] device: 'nvram': device_add
[   11.762101] PM: Adding info for No Bus:nvram
[   11.762108] Non-volatile memory driver v1.3
[   11.762118] toshiba: not a supported Toshiba laptop
[   11.762181] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[   11.762182] device: 'pc8736x_gpio.0': device_add
[   11.762187] bus: 'platform': add device pc8736x_gpio.0
[   11.762203] PM: Adding info for platform:pc8736x_gpio.0
[   11.762236] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[   11.762262] platform pc8736x_gpio.0: no device found
[   11.762266] PM: Removing info for platform:pc8736x_gpio.0
[   11.762282] bus: 'platform': remove device pc8736x_gpio.0
[   11.762292] nsc_gpio initializing
[   11.762319] smapi::smapi_init, ERROR invalid usSmapiID
[   11.762322] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   11.762325] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   11.762325] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   11.762329] bus: 'pcmcia': add driver synclink_cs
[   11.762340] device: 'ttySLP0': device_add
[   11.762354] PM: Adding info for No Bus:ttySLP0
[   11.762360] device: 'ttySLP1': device_add
[   11.762374] PM: Adding info for No Bus:ttySLP1
[   11.762379] device: 'ttySLP2': device_add
[   11.762388] PM: Adding info for No Bus:ttySLP2
[   11.762393] device: 'ttySLP3': device_add
[   11.762410] PM: Adding info for No Bus:ttySLP3
[   11.762415] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[   11.762419] device class 'cardman_4000': registering
[   11.762434] bus: 'pcmcia': add driver cm4000_cs
[   11.762440] device class 'cardman_4040': registering
[   11.762446] bus: 'pcmcia': add driver cm4040_cs
[   11.762455] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   11.762456] Hangcheck: Using getrawmonotonic().
[   11.762473] device class 'drm': registering
[   11.762554] [drm] Initialized drm 1.1.0 20060810
[   11.762605] bus: 'pci': add driver poulsbo
[   11.762646] bus: 'i2c': add driver bmp085
[   11.762676] lkdtm: No crash points registered, enable through debugfs
[   11.762678] bus: 'pci': add driver IOC4
[   11.762687] device class 'enclosure': registering
[   11.762693] bus: 'platform': add driver cs5535-mfgpt
[   11.762700] device class 'iLO': registering
[   11.762705] bus: 'pci': add driver hpilo
[   11.762713] bus: 'i2c': add driver isl29003
[   11.762722] i2c-core: driver [isl29003] using legacy suspend method
[   11.762723] i2c-core: driver [isl29003] using legacy resume method
[   11.762724] bus: 'i2c': add driver at24
[   11.762739] bus: 'spi': add driver at25
[   11.762747] bus: 'i2c': add driver eeprom
[   11.762753] bus: 'pci': add driver cb710
[   11.762769] bus: 'platform': add driver kim
[   11.762776] bus: 'i2c': add driver fsa9480
[   11.762782] i2c-core: driver [fsa9480] using legacy suspend method
[   11.762783] i2c-core: driver [fsa9480] using legacy resume method
[   11.762785] bus: 'platform': add driver sm501
[   11.762791] bus: 'pci': add driver sm501
[   11.762800] bus: 'platform': add driver pasic3
[   11.762809] bus: 'platform': remove driver pasic3
[   11.762813] driver: 'pasic3': driver_release
[   11.762815] bus: 'i2c': add driver htcpld-chip
[   11.762822] bus: 'platform': add driver i2c-htcpld
[   11.762828] bus: 'platform': remove driver i2c-htcpld
[   11.762831] driver: 'i2c-htcpld': driver_release
[   11.762835] bus: 'spi': add driver arizona
[   11.762844] bus: 'i2c': add driver wm8994
[   11.762855] bus: 'i2c': add driver twl6040
[   11.762864] bus: 'pci': add driver lpc_sch
[   11.762873] bus: 'pci': add driver lpc_ich
[   11.762892] bus: 'pci': add driver RDC321x Southbridge
[   11.762901] bus: 'pci': add driver janz-cmodio
[   11.762909] bus: 'pci': add driver vx855
[   11.762923] bus: 'pci': add driver cs5535-mfd
[   11.762933] Uniform Multi-Platform E-IDE driver
[   11.762948] bus: 'ide': registered
[   11.762949] device class 'ide_port': registering
[   11.762966] bus: 'pci': add driver cs5536
[   11.762980] bus: 'pci': add driver Delkin-ASKA-Workbit Cardbus IDE
[   11.763004] bus: 'pci': add driver AEC62xx_IDE
[   11.763013] bus: 'pci': add driver ALI15x3_IDE
[   11.763021] bus: 'pci': add driver CS5530 IDE
[   11.763029] bus: 'pci': add driver CS5535_IDE
[   11.763038] bus: 'pci': add driver HPT366_IDE
[   11.763049] bus: 'pci': add driver IT8172_IDE
[   11.763062] bus: 'pci': add driver ITE8213_IDE
[   11.763070] bus: 'pci': add driver ITE821x IDE
[   11.763079] bus: 'pci': add driver JMicron IDE
[   11.763087] bus: 'pci': add driver Promise_Old_IDE
[   11.763096] bus: 'pci': add driver Serverworks_IDE
[   11.763105] bus: 'pci': add driver SiI_IDE
[   11.763113] bus: 'pci': add driver SLC90e66_IDE
[   11.763128] bus: 'pci': add driver TC86C001
[   11.763137] bus: 'pci': add driver TRIFLEX_IDE
[   11.763146] bus: 'pci': add driver TRM290_IDE
[   11.763789] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   11.763794] device class 'raid_devices': registering
[   11.763807] Loading iSCSI transport class v2.0-870.
[   11.763808] device class 'iscsi_transport': registering
[   11.763813] device class 'iscsi_endpoint': registering
[   11.763818] device class 'iscsi_iface': registering
[   11.763822] device class 'iscsi_host': registering
[   11.763826] device class 'iscsi_connection': registering
[   11.763830] device class 'iscsi_session': registering
[   11.763964] device class 'sas_host': registering
[   11.763970] device class 'sas_phy': registering
[   11.763974] device class 'sas_port': registering
[   11.763979] device class 'sas_device': registering
[   11.763982] device class 'sas_end_device': registering
[   11.763987] device class 'sas_expander': registering
[   11.764034] osst :I: Tape driver with OnStream support version 0.99.4
[   11.764034] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   11.764035] device class 'onstream_tape': registering
[   11.764046] bus: 'scsi': add driver osst
[   11.764055] SCSI Media Changer driver v0.25 
[   11.764056] device class 'scsi_changer': registering
[   11.764066] bus: 'scsi': add driver ch
[   11.764075] bus: 'pci': add driver ahci
[   11.764096] bus: 'pci': add driver sata_inic162x
[   11.764105] bus: 'pci': add driver pata_ns87410
[   11.764115] bus: 'pci': add driver pata_rz1000
[   11.768164] Rounding down aligned max_sectors from 4294967295 to 8388600
[   11.768454] device: 'tcm_loop_0': device_add
[   11.768493] PM: Adding info for No Bus:tcm_loop_0
[   11.768527] bus: 'tcm_loop_bus': registered
[   11.768531] bus: 'tcm_loop_bus': add driver tcm_loop
[   11.768569] bus: 'pci': add driver dw_spi_pci
[   11.768613] bus: 'platform': add driver spi_oc_tiny
[   11.768636] bus: 'spi': add driver tle62x0
[   11.768649] bus: 'platform': add driver pch-spi
[   11.768658] bus: 'pci': add driver pch_spi
[   11.768674] bus: 'i2c': add driver spi-xcomm
[   11.768686] bus: 'hsi': add driver hsi_char
[   11.768692] HSI/SSI char device loaded
[   11.768695] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   11.768738] device: 'eql': device_add
[   11.768795] PM: Adding info for No Bus:eql
[   11.768869] bus: 'mdio_bus': add driver Cicada Cis8201
[   11.768879] bus: 'mdio_bus': add driver Cicada Cis8204
[   11.768886] bus: 'mdio_bus': add driver LXT970
[   11.768892] bus: 'mdio_bus': add driver LXT971
[   11.768898] bus: 'mdio_bus': add driver LXT973
[   11.768904] bus: 'mdio_bus': add driver QS6612
[   11.768910] bus: 'mdio_bus': add driver Broadcom BCM8706
[   11.768921] bus: 'mdio_bus': add driver Broadcom BCM8727
[   11.768927] bus: 'mdio_bus': add driver ICPlus IP175C
[   11.768933] bus: 'mdio_bus': add driver ICPlus IP1001
[   11.768939] bus: 'mdio_bus': add driver ICPlus IP101A/G
[   11.768945] bus: 'mdio_bus': add driver ET1011C
[   11.768955] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   11.768956] device: 'Fixed MDIO bus.0': device_add
[   11.768963] bus: 'platform': add device Fixed MDIO bus.0
[   11.768970] PM: Adding info for platform:Fixed MDIO bus.0
[   11.769010] device: 'fixed-0': device_add
[   11.769023] PM: Adding info for No Bus:fixed-0
[   11.769034] libphy: Fixed MDIO Bus: probed
[   11.769036] bus: 'mdio_bus': add driver STe101p
[   11.769042] bus: 'mdio_bus': add driver STe100p
[   11.769050] spi_ks8995: Micrel KS8995 Ethernet switch SPI driver version 0.1.1
[   11.769052] bus: 'spi': add driver spi-ks8995
[   11.769059] bus: 'platform': add driver mdio-mux-gpio
[   11.769070] tun: Universal TUN/TAP device driver, 1.6
[   11.769071] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.769080] device: 'tun': device_add
[   11.769111] PM: Adding info for No Bus:tun
[   11.769116] arcnet loaded.
[   11.769119] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[   11.769120] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[   11.769121] arcnet: raw mode (`r') encapsulation support loaded.
[   11.769122] arcnet: cap mode (`c') encapsulation support loaded.
[   11.769130] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   11.769131] E-mail me if you actually test this driver, please!
[   11.769132]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   11.769144] arcnet: RIM I (entirely mem-mapped) support
[   11.769144] E-mail me if you actually test the RIM I driver, please!
[   11.769146] Given: node 00h, shmem 0h, irq 0
[   11.769146] No autoprobe for RIM I; you must specify the shmem and irq!
[   11.769158] bus: 'pcmcia': add driver 3c589_cs
[   11.769167] bus: 'pci': add driver 3c59x
[   11.769178] bus: 'pcmcia': add driver nmclan_cs
[   11.769186] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   11.769189] bus: 'pci': add driver pcnet32
[   11.769198] bus: 'pci': add driver atl1
[   11.769210] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   11.769213] Copyright (c) 2007 Atheros Corporation.
[   11.769214] bus: 'pci': add driver atl2
[   11.769230] bus: 'pci': add driver b44
[   11.769241] bus: 'ssb': add driver b44
[   11.769247] bus: 'pci': add driver bnx2
[   11.769257] bus: 'platform': add driver dnet
[   11.769270] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   11.769274] bus: 'pci': add driver uli526x
[   11.769283] bus: 'pci': add driver S2IO
[   11.769292] bus: 'platform': add driver ks8842
[   11.769303] bus: 'pci': add driver ksz884xp
[   11.769313] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   11.769315] bus: 'pci': add driver ns83820
[   11.769326] bus: 'platform': add driver ethoc
[   11.769335] tlan: ThunderLAN driver v1.17
[   11.769337] bus: 'pci': add driver tlan
[   11.769346] tlan: 0 devices installed, PCI: 0  EISA: 0
[   11.769353] bus: 'pci': remove driver tlan
[   11.769358] driver: 'tlan': driver_release
[   11.769360] bus: 'platform': add driver w5300
[   11.769367] bus: 'pci': add driver skfddi
[   11.769375] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   11.769384] bus: 'platform': add driver nsc-ircc
[   11.769396] bus: 'pnp': add driver nsc-ircc
[   11.769504] bus: 'platform': remove driver nsc-ircc
[   11.769508] driver: 'nsc-ircc': driver_release
[   11.769511] bus: 'pnp': remove driver nsc-ircc
[   11.769514] driver: 'nsc-ircc': driver_release
[   11.769708] bus: 'pci': add driver donauboe
[   11.769719] bus: 'pci': add driver via-ircc
[   11.769733] PPP generic driver version 2.4.2
[   11.769747] device class 'ppp': registering
[   11.769754] device: 'ppp': device_add
[   11.769773] PM: Adding info for No Bus:ppp
[   11.769780] PPP BSD Compression module registered
[   11.769781] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[   11.769790] bus: 'usb': add driver kaweth
[   11.769802] usbcore: registered new interface driver kaweth
[   11.769805] bus: 'usb': add driver asix
[   11.769812] usbcore: registered new interface driver asix
[   11.769814] bus: 'usb': add driver cdc_ether
[   11.769820] usbcore: registered new interface driver cdc_ether
[   11.769822] bus: 'usb': add driver dm9601
[   11.769828] usbcore: registered new interface driver dm9601
[   11.769830] bus: 'usb': add driver smsc75xx
[   11.769836] usbcore: registered new interface driver smsc75xx
[   11.769838] bus: 'usb': add driver smsc95xx
[   11.769844] usbcore: registered new interface driver smsc95xx
[   11.769845] bus: 'usb': add driver gl620a
[   11.769852] usbcore: registered new interface driver gl620a
[   11.769853] bus: 'usb': add driver net1080
[   11.769872] usbcore: registered new interface driver net1080
[   11.769873] bus: 'usb': add driver cdc_subset
[   11.769883] usbcore: registered new interface driver cdc_subset
[   11.769884] bus: 'usb': add driver zaurus
[   11.769897] usbcore: registered new interface driver zaurus
[   11.769906] bus: 'usb': add driver int51x1
[   11.769913] usbcore: registered new interface driver int51x1
[   11.769914] bus: 'usb': add driver kalmia
[   11.769921] usbcore: registered new interface driver kalmia
[   11.769922] bus: 'usb': add driver cdc_ncm
[   11.769928] usbcore: registered new interface driver cdc_ncm
[   11.769930] bus: 'usb': add driver lg-vl600
[   11.769936] usbcore: registered new interface driver lg-vl600
[   11.769938] bus: 'pci': add driver nosy
[   11.769950] device class 'uio': registering
[   11.769955] bus: 'pci': add driver hilscher
[   11.769964] bus: 'platform': add driver uio_pdrv_genirq
[   11.769972] bus: 'pci': add driver aectc
[   11.769988] bus: 'pci': add driver sercos3
[   11.769997] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[   11.770000] bus: 'pci': add driver uio_pci_generic
[   11.770073] bus: 'pci': add driver netx
[   11.770087] bus: 'pci': add driver pd6729
[   11.770102] bus: 'platform': add driver gpio-vbus
[   11.770108] bus: 'platform': remove driver gpio-vbus
[   11.770112] driver: 'gpio-vbus': driver_release
[   11.770140] device class 'usbmon': registering
[   11.770156] device: 'usbmon0': device_add
[   11.770171] PM: Adding info for No Bus:usbmon0
[   11.770185] uhci_hcd: USB Universal Host Controller Interface driver
[   11.770202] bus: 'pci': add driver uhci_hcd
[   11.770212] bus: 'platform': add driver sl811-hcd
[   11.770224] bus: 'usb': add driver cdc_acm
[   11.770231] usbcore: registered new interface driver cdc_acm
[   11.770232] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   11.770236] bus: 'usb': add driver usblp
[   11.770242] usbcore: registered new interface driver usblp
[   11.770244] bus: 'usb': add driver usbtmc
[   11.770250] usbcore: registered new interface driver usbtmc
[   11.770252] bus: 'usb': add driver libusual
[   11.770258] usbcore: registered new interface driver libusual
[   11.770262] bus: 'usb': add driver adutux
[   11.770275] usbcore: registered new interface driver adutux
[   11.770277] bus: 'usb': add driver cytherm
[   11.770283] usbcore: registered new interface driver cytherm
[   11.770287] bus: 'usb': add driver emi26 - firmware loader
[   11.770294] usbcore: registered new interface driver emi26 - firmware loader
[   11.770295] bus: 'usb': add driver emi62 - firmware loader
[   11.770302] usbcore: registered new interface driver emi62 - firmware loader
[   11.770304] bus: 'usb': add driver isight_firmware
[   11.770310] usbcore: registered new interface driver isight_firmware
[   11.770312] bus: 'usb': add driver usblcd
[   11.770318] usbcore: registered new interface driver usblcd
[   11.770320] bus: 'usb': add driver ldusb
[   11.770326] usbcore: registered new interface driver ldusb
[   11.770327] bus: 'usb': add driver usbled
[   11.770333] usbcore: registered new interface driver usbled
[   11.770337] bus: 'usb': add driver rio500
[   11.770344] usbcore: registered new interface driver rio500
[   11.770345] bus: 'usb': add driver usbtest
[   11.770351] usbcore: registered new interface driver usbtest
[   11.770353] bus: 'usb': add driver usbsevseg
[   11.770364] usbcore: registered new interface driver usbsevseg
[   11.770366] bus: 'usb': add driver yurex
[   11.770372] usbcore: registered new interface driver yurex
[   11.770374] bus: 'i2c': add driver isp1301
[   11.770386] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[   11.770386] bus: 'platform': add driver musb-hdrc
[   11.770393] bus: 'platform': add driver musb-tusb
[   11.770409] bus: 'pci': add driver net2280
[   11.770419] bus: 'pci': add driver amd5536udc
[   11.770428] bus: 'platform': add driver m66592_udc
[   11.770434] bus: 'platform': remove driver m66592_udc
[   11.770438] driver: 'm66592_udc': driver_release
[   11.770442] bus: 'platform': add driver r8a66597_udc
[   11.770448] bus: 'platform': remove driver r8a66597_udc
[   11.770452] driver: 'r8a66597_udc': driver_release
[   11.770458] bus: 'platform': add driver mv-udc
[   11.770472] couldn't find an available UDC
[   11.770482] bus: 'pnp': add driver i8042 kbd
[   11.770487] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[   11.770489] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[   11.770502] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[   11.770503] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[   11.770514] bus: 'pnp': add driver i8042 aux
[   11.770520] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[   11.770521] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[   11.770527] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[   11.770528] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[   11.770539] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   11.770579] Registering platform device 'i8042'. Parent at platform
[   11.770580] device: 'i8042': device_add
[   11.770584] bus: 'platform': add device i8042
[   11.770590] PM: Adding info for platform:i8042
[   11.770600] bus: 'platform': add driver i8042
[   11.770604] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   11.770605] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   12.030508] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.030584] device: 'serio0': device_add
[   12.030670] bus: 'serio': add device serio0
[   12.030697] PM: Adding info for serio:serio0
[   12.030748] driver: 'i8042': driver_bound: bound to device 'i8042'
[   12.030752] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   12.030812] bus: 'pci': add driver pcips2
[   12.030844] bus: 'serio': add driver ps2mult
[   12.030861] bus: 'serio': add driver serio_raw
[   12.030869] bus: 'pci': add driver FM801_gameport
[   12.030910] device: 'mice': device_add
[   12.030962] PM: Adding info for No Bus:mice
[   12.030990] device: 'psaux': device_add
[   12.031019] PM: Adding info for No Bus:psaux
[   12.031026] mousedev: PS/2 mouse device common for all mice
[   12.031031] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[   12.031048] bus: 'serio': add driver atkbd
[   12.031060] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   12.031061] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   12.031135] bus: 'platform': add driver gpio-keys-polled
[   12.031159] bus: 'serio': add driver lkkbd
[   12.031286] bus: 'i2c': add driver mcs_touchkey
[   12.031305] bus: 'i2c': add driver mpr121
[   12.031314] bus: 'serio': add driver newtonkbd
[   12.031322] bus: 'platform': add driver omap4-keypad
[   12.031333] bus: 'i2c': add driver qt1070
[   12.031339] bus: 'serio': add driver stowaway
[   12.031346] bus: 'serio': add driver sunkbd
[   12.031363] bus: 'usb': add driver appletouch
[   12.031383] usbcore: registered new interface driver appletouch
[   12.031384] bus: 'usb': add driver bcm5974
[   12.031391] usbcore: registered new interface driver bcm5974
[   12.031393] bus: 'platform': add driver gpio_mouse
[   12.031445] bus: 'serio': add driver psmouse
[   12.031454] bus: 'usb': add driver synaptics_usb
[   12.031461] usbcore: registered new interface driver synaptics_usb
[   12.031466] bus: 'i2c': add driver auo_pixcir_ts
[   12.031475] bus: 'i2c': add driver bu21013_tp
[   12.031485] bus: 'platform': add driver da9052-tsi
[   12.031492] bus: 'serio': add driver dynapro
[   12.031499] bus: 'i2c': add driver edt_ft5x06
[   12.031505] bus: 'serio': add driver gunze
[   12.031512] bus: 'serio': add driver elo
[   12.031519] bus: 'i2c': add driver egalax_ts
[   12.031525] bus: 'serio': add driver inexio
[   12.031539] bus: 'i2c': add driver max11801_ts
[   12.031548] bus: 'platform': add driver mc13783-ts
[   12.031561] bus: 'platform': remove driver mc13783-ts
[   12.031568] driver: 'mc13783-ts': driver_release
[   12.031570] bus: 'i2c': add driver mcs5000_ts
[   12.031576] bus: 'i2c': add driver mms114
[   12.031599] mk712: device not present
[   12.031604] bus: 'usb': add driver usbtouchscreen
[   12.031612] usbcore: registered new interface driver usbtouchscreen
[   12.031613] bus: 'serio': add driver serio-penmount
[   12.031621] bus: 'i2c': add driver st1232-ts
[   12.031627] bus: 'serio': add driver touchit213
[   12.031634] bus: 'serio': add driver touchright
[   12.031645] bus: 'serio': add driver touchwin
[   12.031652] bus: 'serio': add driver tsc40
[   12.031659] bus: 'serio': add driver w8001
[   12.031667] bus: 'platform': add driver wm831x-touch
[   12.031681] bus: 'platform': add driver tps6507x-ts
[   12.031695] bus: 'platform': add driver 88pm80x-onkey
[   12.031702] bus: 'i2c': add driver adxl34x
[   12.031771] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   12.031773] bus: 'usb': add driver ati_remote2
[   12.031785] usbcore: registered new interface driver ati_remote2
[   12.031788] bus: 'i2c': add driver bma150
[   12.031795] bus: 'platform': add driver da9052-onkey
[   12.031802] bus: 'i2c': add driver gp2ap002a00f
[   12.031809] bus: 'platform': add driver gpio-tilt-polled
[   12.031819] bus: 'i2c': add driver kxtj9
[   12.031826] bus: 'platform': add driver max8925-onkey
[   12.031833] bus: 'platform': add driver mc13783-pwrbutton
[   12.031840] bus: 'i2c': add driver mpu3050
[   12.031847] bus: 'platform': add driver pcf50633-input
[   12.031854] bus: 'platform': add driver pcspkr
[   12.031860] bus: 'platform': driver_probe_device: matched device pcspkr with driver pcspkr
[   12.031861] bus: 'platform': really_probe: probing driver pcspkr with device pcspkr
[   12.031870] device: 'input1': device_add
[   12.031915] PM: Adding info for No Bus:input1
[   12.031933] input: PC Speaker as /devices/platform/pcspkr/input/input1
[   12.031945] evbug: Connected device: input1 (PC Speaker at isa0061/input0)
[   12.031946] driver: 'pcspkr': driver_bound: bound to device 'pcspkr'
[   12.031948] bus: 'platform': really_probe: bound device pcspkr to driver pcspkr
[   12.031955] device: 'uinput': device_add
[   12.031968] PM: Adding info for No Bus:uinput
[   12.031974] bus: 'platform': add driver wm831x-on
[   12.031980] I2O subsystem v1.325
[   12.031981] i2o: max drivers = 8
[   12.031998] bus: 'i2o': registered
[   12.032086] bus: 'i2o': add driver exec-osm
[   12.032102] bus: 'pci': add driver PCI_I2O
[   12.032115] I2O Configuration OSM v1.323
[   12.032117] bus: 'i2o': add driver config-osm
[   12.032122] I2O SCSI Peripheral OSM v1.316
[   12.032123] bus: 'i2o': add driver scsi-osm
[   12.032130] I2O ProcFS OSM v1.316
[   12.032132] bus: 'i2o': add driver proc-osm
[   12.032149] bus: 'i2c': add driver smbus_alert
[   12.032157] bus: 'pci': add driver ali1535_smbus
[   12.032170] bus: 'pci': add driver nForce2_smbus
[   12.032179] bus: 'pci': add driver sis5595_smbus
[   12.032188] bus: 'pci': add driver sis630_smbus
[   12.032197] bus: 'pci': add driver sis96x_smbus
[   12.032206] bus: 'pci': add driver vt596_smbus
[   12.032216] bus: 'pci': add driver i2c-designware-pci
[   12.032234] bus: 'pci': add driver i2c_eg20t
[   12.032244] bus: 'pci': add driver i2c-intel-mid
[   12.032254] bus: 'platform': add driver i2c-pca-platform
[   12.032262] bus: 'platform': add driver simtec-i2c
[   12.032269] bus: 'usb': add driver i2c-tiny-usb
[   12.032276] usbcore: registered new interface driver i2c-tiny-usb
[   12.032281] scx200_acb: NatSemi SCx200 ACCESS.bus Driver
[   12.032285] bus: 'platform': add driver cs5535-smb
[   12.032294] device class 'rc': registering
[   12.032305] device class 'lirc': registering
[   12.032316] lirc_dev: IR Remote Control driver registered, major 242 
[   12.032321] IR RC5(x) protocol handler initialized
[   12.032324] IR RC6 protocol handler initialized
[   12.032325] IR Sony protocol handler initialized
[   12.032325] IR RC5 (streamzap) protocol handler initialized
[   12.032326] IR SANYO protocol handler initialized
[   12.032328] bus: 'usb': add driver redrat3
[   12.032335] usbcore: registered new interface driver redrat3
[   12.032337] bus: 'usb': add driver streamzap
[   12.032343] usbcore: registered new interface driver streamzap
[   12.032351] Registered IR keymap rc-empty
[   12.032353] device: 'rc0': device_add
[   12.032363] PM: Adding info for No Bus:rc0
[   12.032369] device: 'input2': device_add
[   12.032394] PM: Adding info for No Bus:input2
[   12.032413] input: rc-core loopback device as /devices/virtual/rc/rc0/input2
[   12.032416] evbug: Connected device: input2 (rc-core loopback device at rc-core/virtual)
[   12.032418] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[   12.032459] Registering platform device 'm2m-testdev.0'. Parent at platform
[   12.032461] device: 'm2m-testdev.0': device_add
[   12.032465] bus: 'platform': add device m2m-testdev.0
[   12.032475] PM: Adding info for platform:m2m-testdev.0
[   12.032539] bus: 'platform': add driver m2m-testdev
[   12.032549] bus: 'platform': driver_probe_device: matched device m2m-testdev.0 with driver m2m-testdev
[   12.032550] bus: 'platform': really_probe: probing driver m2m-testdev with device m2m-testdev.0
[   12.032579] device: 'video0': device_add
[   12.032596] PM: Adding info for No Bus:video0
[   12.032608] m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as /dev/video0
[   12.032611] driver: 'm2m-testdev.0': driver_bound: bound to device 'm2m-testdev'
[   12.032613] bus: 'platform': really_probe: bound device m2m-testdev.0 to driver m2m-testdev
[   12.032625] saa7146: register extension 'budget_av'
[   12.032627] bus: 'pci': add driver budget_av
[   12.032647] bus: 'usb': add driver smsusb
[   12.032654] usbcore: registered new interface driver smsusb
[   12.032657] smssdio: Siano SMS1xxx SDIO driver
[   12.032658] smssdio: Copyright Pierre Ossman
[   12.032665] bus: 'sdio': add driver smssdio
[   12.032673] bus: 'pci': add driver dm1105
[   12.032684] bus: 'pci': add driver Mantis
[   12.032696] bus: 'pci': add driver Hopper
[   12.032749] bus: 'i2c': add driver w83781d
[   12.032760] bus: 'i2c': add driver w83791d
[   12.032769] bus: 'i2c': add driver adm1021
[   12.032776] bus: 'i2c': add driver adm1026
[   12.032785] bus: 'i2c': add driver adm1031
[   12.032792] bus: 'i2c': add driver adm9240
[   12.032799] bus: 'i2c': add driver ads1015
[   12.032813] bus: 'platform': add driver da9052-hwmon
[   12.032821] bus: 'i2c': add driver ds620
[   12.032830] bus: 'i2c': add driver ds1621
[   12.032836] bus: 'i2c': add driver emc2103
[   12.032899] bus: 'i2c': add driver f75375
[   12.032907] bus: 'pci': add driver fam15h_power
[   12.032917] bus: 'i2c': add driver fschmd
[   12.032926] bus: 'i2c': add driver gl518sm
[   12.032935] bus: 'i2c': add driver gl520sm
[   12.032943] bus: 'platform': add driver gpio-fan
[   12.032988] bus: 'pci': add driver k10temp
[   12.033000] bus: 'i2c': add driver lm63
[   12.033011] bus: 'spi': add driver lm70
[   12.033018] bus: 'i2c': add driver lm80
[   12.033025] bus: 'i2c': add driver lm85
[   12.033042] bus: 'i2c': add driver lm90
[   12.033049] bus: 'i2c': add driver lm93
[   12.033060] bus: 'i2c': add driver ltc4151
[   12.033067] bus: 'i2c': add driver max16065
[   12.033074] bus: 'i2c': add driver max1619
[   12.033081] bus: 'platform': add driver mc13783-adc
[   12.033091] bus: 'platform': remove driver mc13783-adc
[   12.033095] driver: 'mc13783-adc': driver_release
[   12.033129] pc87360: PC8736x not detected, module not inserted
[   12.033166] bus: 'platform': add driver sch5627
[   12.033177] bus: 'platform': add driver sht10
[   12.033184] bus: 'platform': add driver sht11
[   12.033192] bus: 'platform': add driver sht15
[   12.033199] bus: 'platform': add driver sht71
[   12.033208] bus: 'platform': add driver sht75
[   12.033218] bus: 'i2c': add driver sht21
[   12.033230] bus: 'pci': add driver vt8231
[   12.033316] bus: 'platform': add driver wm831x-hwmon
[   12.033326] acquirewdt: WDT driver for Acquire single board computer initialising
[   12.033331] bus: 'platform': add driver acquirewdt
[   12.033340] Registering platform device 'acquirewdt'. Parent at platform
[   12.033341] device: 'acquirewdt': device_add
[   12.033350] bus: 'platform': add device acquirewdt
[   12.033357] PM: Adding info for platform:acquirewdt
[   12.033367] bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
[   12.033369] bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
[   12.033374] acquirewdt: I/O address 0x0043 already in use
[   12.033380] acquirewdt: probe of acquirewdt failed with error -5
[   12.033386] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   12.033388] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   12.033389] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[   12.033393] bus: 'platform': add driver SP5100 TCO timer
[   12.033410] Registering platform device 'SP5100 TCO timer'. Parent at platform
[   12.033411] device: 'SP5100 TCO timer': device_add
[   12.033414] bus: 'platform': add device SP5100 TCO timer
[   12.033421] PM: Adding info for platform:SP5100 TCO timer
[   12.033431] bus: 'platform': driver_probe_device: matched device SP5100 TCO timer with driver SP5100 TCO timer
[   12.033432] bus: 'platform': really_probe: probing driver SP5100 TCO timer with device SP5100 TCO timer
[   12.033443] SP5100 TCO timer: probe of SP5100 TCO timer rejects match -19
[   12.033446] bus: 'platform': add driver geodewdt
[   12.033454] Registering platform device 'geodewdt'. Parent at platform
[   12.033455] device: 'geodewdt': device_add
[   12.033457] bus: 'platform': add device geodewdt
[   12.033463] PM: Adding info for platform:geodewdt
[   12.033473] bus: 'platform': driver_probe_device: matched device geodewdt with driver geodewdt
[   12.033474] bus: 'platform': really_probe: probing driver geodewdt with device geodewdt
[   12.033480] geodewdt: No timers were available
[   12.033482] geodewdt: probe of geodewdt rejects match -19
[   12.033504] device: 'watchdog': device_add
[   12.033515] PM: Adding info for No Bus:watchdog
[   12.033521] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   12.033522] ib700wdt: WDT driver for IB700 single board computer initialising
[   12.033524] bus: 'platform': add driver ib700wdt
[   12.033532] Registering platform device 'ib700wdt'. Parent at platform
[   12.033533] device: 'ib700wdt': device_add
[   12.033536] bus: 'platform': add device ib700wdt
[   12.033549] PM: Adding info for platform:ib700wdt
[   12.033559] bus: 'platform': driver_probe_device: matched device ib700wdt with driver ib700wdt
[   12.033560] bus: 'platform': really_probe: probing driver ib700wdt with device ib700wdt
[   12.033563] ib700wdt: failed to register misc device
[   12.033565] ib700wdt: probe of ib700wdt failed with error -16
[   12.033567] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[   12.033569] wafer5823wdt: cannot register miscdev on minor=130 (err=-16)
[   12.033572] bus: 'pci': add driver i6300ESB timer
[   12.033580] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver i6300ESB timer
[   12.033582] bus: 'pci': really_probe: probing driver i6300ESB timer with device 0000:00:0a.0
[   12.033590] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   12.033783] i6300esb: cannot register miscdev on minor=130 (err=-16)
[   12.033799] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[   12.033808] bus: 'pci': add driver hpwdt
[   12.033816] sc1200wdt: build 20020303
[   12.033824] bus: 'pnp': add driver scl200wdt
[   12.033836] sc1200wdt: io parameter must be specified
[   12.033839] bus: 'pnp': remove driver scl200wdt
[   12.033845] driver: 'scl200wdt': driver_release
[   12.033846] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   12.033848] bus: 'platform': add driver NV_TCO
[   12.033857] Registering platform device 'NV_TCO'. Parent at platform
[   12.033858] device: 'NV_TCO': device_add
[   12.033861] bus: 'platform': add device NV_TCO
[   12.033868] PM: Adding info for platform:NV_TCO
[   12.033878] bus: 'platform': driver_probe_device: matched device NV_TCO with driver NV_TCO
[   12.033879] bus: 'platform': really_probe: probing driver NV_TCO with device NV_TCO
[   12.033889] NV_TCO: probe of NV_TCO rejects match -19
[   12.033896] sbc8360: failed to register misc device
[   12.033898] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[   12.034968] smsc37b787_wdt: Unable to register miscdev on minor 130
[   12.034973] bus: 'pci': add driver via_wdt
[   12.034983] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[   12.035023] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[   12.035051] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[   12.035052] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   12.035074] w83697hf_wdt: watchdog not found at address 0x2e
[   12.035074] w83697hf_wdt: No W83697HF/HG could be found
[   12.035075] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[   12.035091] w83697ug_wdt: No W83697UG/UF could be found
[   12.035093] w83877f_wdt: cannot register miscdev on minor=130 (err=-16)
[   12.035094] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   12.035103] machzwd: no ZF-Logic found
[   12.035107] bus: 'platform': add driver da9052-watchdog
[   12.035116] bus: 'platform': add driver wm831x-watchdog
[   12.035131] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   12.035132] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   12.035137] device: 'watchdog1': device_add
[   12.035149] PM: Adding info for No Bus:watchdog1
[   12.035156] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   12.035165] md: linear personality registered for level -1
[   12.035167] md: raid10 personality registered for level 10
[   12.035167] md: raid6 personality registered for level 6
[   12.035168] md: raid5 personality registered for level 5
[   12.035169] md: raid4 personality registered for level 4
[   12.035170] md: multipath personality registered for level -4
[   12.035176] Bluetooth: HCI UART driver ver 2.2
[   12.035179] Bluetooth: HCI H4 protocol initialized
[   12.035182] Bluetooth: HCI BCSP protocol initialized
[   12.035195] bus: 'pcmcia': add driver bluecard_cs
[   12.035211] bus: 'usb': add driver btusb
[   12.035218] usbcore: registered new interface driver btusb
[   12.035222] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   12.035223] bus: 'sdio': add driver btsdio
[   12.035232] cpuidle: using governor ladder
[   12.035233] cpuidle: using governor menu
[   12.035242] bus: 'mmc': add driver mmcblk
[   12.035249] sdhci: Secure Digital Host Controller Interface driver
[   12.035250] sdhci: Copyright(c) Pierre Ossman
[   12.035253] bus: 'pci': add driver sdhci-pci
[   12.035266] bus: 'platform': add driver cb710-mmc
[   12.035366] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[   12.035366] bus: 'usb': add driver vub300
[   12.035374] usbcore: registered new interface driver vub300
[   12.035376] bus: 'usb': add driver ushc
[   12.035382] usbcore: registered new interface driver ushc
[   12.035385] bus: 'i2c': add driver lm3530-led
[   12.035393] bus: 'platform': add driver leds-gpio
[   12.035415] bus: 'i2c': add driver lp5521
[   12.035425] bus: 'platform': add driver leds-regulator
[   12.035433] bus: 'platform': add driver leds-lt3593
[   12.035448] bus: 'platform': add driver mc13783-led
[   12.035456] bus: 'i2c': add driver leds-lm3556
[   12.035465] bus: 'i2c': add driver blinkm
[   12.035472] bus: 'spi': add driver dac124s085
[   12.035480] Registering platform device 'dell_rbu'. Parent at platform
[   12.035481] device: 'dell_rbu': device_add
[   12.035484] bus: 'platform': add device dell_rbu
[   12.035491] PM: Adding info for platform:dell_rbu
[   12.035509] bus: 'platform': add driver dcdbas
[   12.035517] Registering platform device 'dcdbas'. Parent at platform
[   12.035518] device: 'dcdbas': device_add
[   12.035521] bus: 'platform': add device dcdbas
[   12.035527] PM: Adding info for platform:dcdbas
[   12.035537] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   12.035539] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   12.035557] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   12.035558] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   12.035560] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   12.035566] bus: 'pci': add driver Geode LX AES
[   12.035584] bus: 'pci': add driver hifn795x
[   12.035599] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[   12.035610] bus: 'hid': registered
[   12.035612] device class 'hidraw': registering
[   12.035684] bus: 'platform': add driver olpc-ec
[   12.035695] device class 'extcon': registering
[   12.035701] bus: 'platform': add driver extcon-gpio
[   12.035710] bus: 'platform': add driver max77693-muic
[   12.035718] bus: 'platform': add driver arizona-extcon
[   12.035731] oprofile: using NMI interrupt.
[   12.035785] pktgen: Packet Generator for packet performance testing. Version: 2.74
[   12.435439] atkbd: probe of serio0 rejects match -19
[  111.700160] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10002 jiffies)
[  111.700171] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc5-00004-gda10491 #1
[  111.700178] Call Trace:
[  111.700475]  [<c10c3c84>] rcu_check_callbacks+0x544/0x570
[  111.700538]  [<c1075e86>] update_process_times+0x36/0x70
[  111.700547]  [<c10a6267>] tick_sched_timer+0x57/0xc0
[  111.700552]  [<c108758a>] __run_hrtimer.isra.31+0x4a/0xc0
[  111.700557]  [<c10a6210>] ? tick_nohz_handler+0xf0/0xf0
[  111.700559]  [<c1088155>] hrtimer_interrupt+0xf5/0x290
[  111.700562]  [<c1091cb8>] ? sched_clock_idle_wakeup_event+0x18/0x20
[  111.700565]  [<c10a6399>] ? tick_nohz_stop_idle+0x39/0x40
[  111.700572]  [<c104f56f>] smp_apic_timer_interrupt+0x4f/0x80
[  111.700587]  [<c1753636>] apic_timer_interrupt+0x2a/0x30
[  111.700593]  [<c10565b5>] ? native_safe_halt+0x5/0x10
[  111.700599]  [<c1039f89>] default_idle+0x29/0x50
[  111.700601]  [<c103a958>] cpu_idle+0x68/0xb0
[  111.700609]  [<c16f2ff7>] rest_init+0x67/0x70
[  111.700627]  [<c1af7929>] start_kernel+0x2ea/0x2f0
[  111.700629]  [<c1af7474>] ? repair_env_string+0x51/0x51
[  111.700631]  [<c1af72a2>] i386_start_kernel+0x78/0x7d
[  127.040302] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[  127.041308] CPA self-test:
[  127.041794]  4k 2046 large 62 gb 0 x 2108[c0000000-cfffd000] miss 0
[  128.454861] NET: Registered protocol family 26
[  128.454941] bus: 'serio': really_probe: probing driver atkbd with device serio0
[  128.990471] device: 'input3': device_add
[  129.298063]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[  129.317098] PM: Adding info for No Bus:input3
[  129.317177] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[  129.317218] evbug: Connected device: input3 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[  129.317229] driver: 'serio0': driver_bound: bound to device 'atkbd'
[  129.317234] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[  131.092608] Mirror/redirect action on
[  131.278875] netem: version 1.3
[  131.476110] NET: Registered protocol family 17
[  131.704647] device: 'nr0': device_add
[  131.927893] PM: Adding info for No Bus:nr0
[  132.115074] device: 'nr1': device_add
[  132.302195] PM: Adding info for No Bus:nr1
[  132.483114] device: 'nr2': device_add
[  132.670718] PM: Adding info for No Bus:nr2
[  132.857736] device: 'nr3': device_add
[  133.038160] PM: Adding info for No Bus:nr3
[  133.238120] NET: Registered protocol family 6
[  133.433075] device: 'rose0': device_add
[  133.620294] PM: Adding info for No Bus:rose0
[  133.795187] device: 'rose1': device_add
[  133.958905] PM: Adding info for No Bus:rose1
[  133.959175] device: 'rose2': device_add
[  133.959268] PM: Adding info for No Bus:rose2
[  133.959311] device: 'rose3': device_add
[  133.959339] PM: Adding info for No Bus:rose3
[  133.959365] device: 'rose4': device_add
[  133.959392] PM: Adding info for No Bus:rose4
[  133.959429] device: 'rose5': device_add
[  133.959462] PM: Adding info for No Bus:rose5
[  133.959484] device: 'rose6': device_add
[  133.960145] PM: Adding info for No Bus:rose6
[  133.960373] device: 'rose7': device_add
[  133.960404] PM: Adding info for No Bus:rose7
[  133.960431] device: 'rose8': device_add
[  133.960948] PM: Adding info for No Bus:rose8
[  133.961189] device: 'rose9': device_add
[  133.961277] PM: Adding info for No Bus:rose9
[  133.961299] NET: Registered protocol family 11
[  133.961369] NET: Registered protocol family 3
[  133.961440] device: 'irnet': device_add
[  133.961480] PM: Adding info for No Bus:irnet
[  133.961690] Bluetooth: RFCOMM TTY layer initialized
[  133.961697] Bluetooth: RFCOMM socket layer initialized
[  133.961698] Bluetooth: RFCOMM ver 1.11
[  133.961699] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  133.961700] Bluetooth: BNEP filters: protocol 
[  133.961713] lec:lane_module_init: lec.c: initialized
[  133.961716] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[  133.961862] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes
[  133.961872] NET: Registered protocol family 12
[  133.962588] 
[  133.962588] printing PIC contents
[  133.962599] ... PIC  IMR: ffff
[  133.962604] ... PIC  IRR: 1013
[  133.962613] ... PIC  ISR: 0000
[  133.962618] ... PIC ELCR: 0c00
[  133.963265] printing local APIC contents on CPU#0/0:
[  133.963294] ... APIC ID:      00000000 (0)
[  133.963299] ... APIC VERSION: 00050014
[  133.963304] ... APIC TASKPRI: 00000000 (00)
[  133.963307] ... APIC PROCPRI: 00000000
[  133.963310] ... APIC LDR: 01000000
[  133.963313] ... APIC DFR: ffffffff
[  133.963316] ... APIC SPIV: 000001ff
[  133.963317] ... APIC ISR field:
[  133.963344] 0000000000000000000000000000000000000000000000000000000000000000
[  133.963345] ... APIC TMR field:

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc5-00004-gda10491"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc5 Kernel Configuration
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
# CONFIG_EXPERIMENTAL is not set
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
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
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
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
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
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
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
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
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
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
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
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO1_PM is not set
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
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
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_BT_WILINK is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_DELKIN=y
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_IFB is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=y
CONFIG_PCMCIA_NMCLAN=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_NET_VENDOR_FUJITSU is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
CONFIG_NS83820=y
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPPOATM=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
CONFIG_USB_VL600=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
# CONFIG_SBNI is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_OMAP4=y
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_MRST_MAX3110=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
# CONFIG_GEN_RTC_X is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_SODAVILLE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_DVB_CORE=y

#
# Media drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
# CONFIG_IR_MCE_KBD_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
CONFIG_IR_REDRAT3=y
CONFIG_IR_STREAMZAP=y
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=y
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=y
# CONFIG_DVB_AV7110 is not set
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
CONFIG_DVB_BUDGET_AV=y

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_SIANO_MDTV=y

#
# Siano module components
#
CONFIG_SMS_USB_DRV=y
CONFIG_SMS_SDIO_DRV=y

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=y

#
# Supported Earthsoft PT1 Adapters
#
# CONFIG_DVB_PT1 is not set

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=y
CONFIG_DVB_MANTIS=y
CONFIG_DVB_HOPPER=y

#
# Supported nGene Adapters
#
# CONFIG_DVB_NGENE is not set

#
# Supported ddbridge ('Octopus') Adapters
#
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_ZL10353=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_TDA665x=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_STUB_POULSBO=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
# CONFIG_FONT_PEARL_8x8 is not set
CONFIG_FONT_ACORN_8x8=y
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_TUSB6010=y
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=y
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
CONFIG_USB_R8A66597=y
CONFIG_USB_MV_UDC=y
# CONFIG_USB_GADGET_MUSB_HDRC is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_FILE_STORAGE is not set
CONFIG_USB_MASS_STORAGE=y
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

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
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM3556=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
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
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

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
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--/9DWx/yDrRhgMJTb--
