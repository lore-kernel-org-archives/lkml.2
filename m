Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2IZIPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:15:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:19862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2IZIPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:15:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="226635677"
Date: Wed, 26 Sep 2012 16:15:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected
 by 0, t=10002 jiffies)
Message-ID: <20120926081501.GA28485@localhost>
References: <20120925111938.GA4545@localhost>
 <20120925150701.GA2502@linux.vnet.ibm.com>
 <20120926042237.GA18287@localhost>
 <20120926043445.GB2524@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20120926043445.GB2524@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 25, 2012 at 09:34:45PM -0700, Paul E. McKenney wrote:
> On Wed, Sep 26, 2012 at 12:22:37PM +0800, Fengguang Wu wrote:
> > On Tue, Sep 25, 2012 at 08:07:01AM -0700, Paul E. McKenney wrote:
> > > On Tue, Sep 25, 2012 at 07:19:38PM +0800, Fengguang Wu wrote:
> > > > Hi Paul,
> > > > 
> > > > I've just bisected down one RCU stall problem:
> > > > 
> > > > [   12.035785] pktgen: Packet Generator for packet performance testing. Version: 2.74
> > > > [   12.435439] atkbd: probe of serio0 rejects match -19
> > > > [  111.700160] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10002 jiffies)
> > > > [  111.700171] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc5-00004-gda10491 #1
> > > > [  111.700178] Call Trace:
> > > > [  111.700475]  [<c10c3c84>] rcu_check_callbacks+0x544/0x570
> > > > [  111.700538]  [<c1075e86>] update_process_times+0x36/0x70
> > > > [  111.700547]  [<c10a6267>] tick_sched_timer+0x57/0xc0
> > > > [  111.700552]  [<c108758a>] __run_hrtimer.isra.31+0x4a/0xc0
> > > > [  111.700557]  [<c10a6210>] ? tick_nohz_handler+0xf0/0xf0
> > > > [  111.700559]  [<c1088155>] hrtimer_interrupt+0xf5/0x290
> > > > [  111.700562]  [<c1091cb8>] ? sched_clock_idle_wakeup_event+0x18/0x20
> > > > [  111.700565]  [<c10a6399>] ? tick_nohz_stop_idle+0x39/0x40
> > > > [  111.700572]  [<c104f56f>] smp_apic_timer_interrupt+0x4f/0x80
> > > > [  111.700587]  [<c1753636>] apic_timer_interrupt+0x2a/0x30
> > > > [  111.700593]  [<c10565b5>] ? native_safe_halt+0x5/0x10
> > > > [  111.700599]  [<c1039f89>] default_idle+0x29/0x50
> > > > [  111.700601]  [<c103a958>] cpu_idle+0x68/0xb0
> > > > [  111.700609]  [<c16f2ff7>] rest_init+0x67/0x70
> > > > [  111.700627]  [<c1af7929>] start_kernel+0x2ea/0x2f0
> > > > [  111.700629]  [<c1af7474>] ? repair_env_string+0x51/0x51
> > > > [  111.700631]  [<c1af72a2>] i386_start_kernel+0x78/0x7d
> > > > [  127.040302] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
> > > > [  127.041308] CPA self-test:
> > > > 
> > > > to this commit:
> > > > 
> > > > commit 06ae115a1d551cd952d80df06eaf8b5153351875
> > > > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > Date:   Sun Aug 14 15:56:54 2011 -0700
> > > > 
> > > >     rcu: Avoid having just-onlined CPU resched itself when RCU is idle
> > > 
> > > Interesting.  Of course the stack is from the CPU that detected the
> > > problem rather than the problematic CPU.  ;-)
> > > 
> > > Could you please try the following patch?
> > 
> > Paul, thanks for the quick fix! However it may still stall sometimes.
> > Attached are 3 dmesgs with the stalls.
> 
> Do you have c96ea7cf from -rcu applied?  Corresponding patch is below.

Nope. I did try linux-next first however the first patch cannot apply
at all. And I don't know which of the many -rcu branches to work on ;-)

> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Avoid spurious RCU CPU stall warnings

No luck.. I applied the two patches on linus/master and still get the
attached warning.

Thanks,
Fengguang

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm_bisect2-inn-8975-2012-09-26-16-09-37-3.6.0-rc7-bisect2-00039-g6f0f9b6-dirty-20"

[    0.000000] Linux version 3.6.0-rc7-bisect2-00039-g6f0f9b6-dirty (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #20 SMP PREEMPT Wed Sep 26 12:41:04 CST 2012
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
[    0.000000] early log buf free: 128464(98%)
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
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1980e00, node_mem_map cdd3f200
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
[    0.000000] PERCPU: Embedded 10 pages/cpu @cdd2b000 s25600 r0 d15360 u40960
[    0.000000] pcpu-alloc: s25600 r0 d15360 u40960 alloc=10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd2d700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 214896k/262136k available (6618k kernel code, 46740k reserved, 3222k data, 532k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff3fe000   ( 748 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc199d000 - 0xc1a22000   ( 532 kB)
[    0.000000]       .data : 0xc1676ac8 - 0xc199c600   (3222 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1676ac8   (6618 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU torture testing starts during boot.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=cd808000 soft=cd80a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2693.747 MHz processor
[    0.020001] Calibrating delay loop (skipped), value calculated using timer frequency.. 5387.49 BogoMIPS (lpj=26937470)
[    0.021649] pid_max: default: 32768 minimum: 301
[    0.030024] Security Framework initialized
[    0.030723] Mount-cache hash table entries: 512
[    0.031702] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031702] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.031702] tlb_flushall_shift is 0x6
[    0.036203] ACPI: Core revision 20120711
[    0.037562] Getting VERSION: 50014
[    0.038191] Getting VERSION: 50014
[    0.038815] Getting ID: 0
[    0.039349] Getting ID: f000000
[    0.040008] Getting LVT0: 8700
[    0.040591] Getting LVT1: 8400
[    0.041179] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.042060] enabled ExtINT on CPU#0
[    0.043330] ENABLING IO-APIC IRQs
[    0.043944] init IO_APIC IRQs
[    0.044514]  apic 2 pin 0 not connected
[    0.045178] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.046606] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.047905] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.049198] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.050021] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.052085] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.054143] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.056203] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.058274] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.060023] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.062111] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.064146] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.066279] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.070023] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.072117] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.074186]  apic 2 pin 16 not connected
[    0.075211]  apic 2 pin 17 not connected
[    0.076374]  apic 2 pin 18 not connected
[    0.077436]  apic 2 pin 19 not connected
[    0.078501]  apic 2 pin 20 not connected
[    0.079516]  apic 2 pin 21 not connected
[    0.080003]  apic 2 pin 22 not connected
[    0.081059]  apic 2 pin 23 not connected
[    0.082286] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.083888] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.085890] Using local APIC timer interrupts.
[    0.085890] calibrating APIC timer ...
[    0.090000] ... lapic delta = 6250034
[    0.090000] ... PM-Timer delta = 357963
[    0.090000] ... PM-Timer result ok
[    0.090000] ..... delta 6250034
[    0.090000] ..... mult: 268436916
[    0.090000] ..... calibration result: 10000054
[    0.090000] ..... CPU clock speed is 2693.6373 MHz.
[    0.090000] ..... host bus clock speed is 1000.0054 MHz.
[    0.090000] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.120963] doing dyndbg params: log_buf_len='8M'
[    0.122310] doing dyndbg params: ignore_loglevel='(null)'
[    0.123742] doing dyndbg params: debug='(null)'
[    0.125075] doing dyndbg params: sched_debug='(null)'
[    0.126516] doing dyndbg params: apic='debug'
[    0.127822] doing dyndbg params: dynamic_printk='(null)'
[    0.129252] doing dyndbg params: sysrq_always_enabled='(null)'
[    0.130004] doing dyndbg params: panic='10'
[    0.131203] doing dyndbg params: prompt_ramdisk='0'
[    0.132566] doing dyndbg params: console='ttyS0,115200'
[    0.134020] doing dyndbg params: console='tty0'
[    0.135315] doing dyndbg params: vga='normal'
[    0.136675] doing dyndbg params: root='/dev/ram0'
[    0.138016] doing dyndbg params: rw='(null)'
[    0.140004] doing dyndbg params: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.160006] smpboot: ++++++++++++++++++++=_---CPU UP  1
[    0.161529] CPU 1 irqstacks, hard=cd888000 soft=cd88a000
[    0.162978] smpboot: Booting Node   0, Processors  #1 OK
[    0.164543] smpboot: Setting warm reset code and vector.
[    0.166016] smpboot: 1.
[    0.166897] smpboot: 2.
[    0.167796] smpboot: 3.
[    0.168720] smpboot: Asserting INIT
[    0.169917] smpboot: Waiting for send to finish...
[    0.181390] smpboot: Deasserting INIT
[    0.182543] smpboot: Waiting for send to finish...
[    0.183931] smpboot: #startup loops: 2
[    0.185129] smpboot: Sending STARTUP #1
[    0.186336] smpboot: After apic_write
[    0.030000] Initializing CPU#1
[    0.187802] smpboot: Startup point 1
[    0.187803] smpboot: Waiting for send to finish...
[    0.188016] smpboot: Sending STARTUP #2
[    0.188023] smpboot: After apic_write
[    0.188330] smpboot: Startup point 1
[    0.188331] smpboot: Waiting for send to finish...
[    0.188541] smpboot: After Startup
[    0.188542] smpboot: Before Callout 1
[    0.188543] smpboot: After Callout 1
[    0.030000] smpboot: CPU#1 (phys ID: 1) waiting for CALLOUT
[    0.030000] smpboot: CALLIN, before setup_local_APIC()
[    0.030000] masked ExtINT on CPU#1
[    0.030000] smpboot: Stack at about cd86dfac
[    0.340611] smpboot: CPU1: has booted.
[    0.350000] TSC synchronization [CPU#0 -> CPU#1]: passed
[    0.360034] KVM setup async PF for cpu 1
[    0.360034] Brought up 2 CPUs
[    0.360034] smpboot: Boot done
[    0.360034] smpboot: Before bogomips
[    0.360034] smpboot: Total of 2 processors activated (10774.50 BogoMIPS)
[    0.360034] smpboot: Before bogocount - setting activated=1
[    0.366937] kvm-stealtime: cpu 1, msr dd37700
[    0.371379] CPU0 attaching sched-domain:
[    0.372410]  domain 0: span 0-1 level CPU
[    0.373553]   groups: 0 1
[    0.374691] CPU1 attaching sched-domain:
[    0.375759]  domain 0: span 0-1 level CPU
[    0.376898]   groups: 1 0
[    0.378065] kobject: 'devices' (cd82880c): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.380010] kobject: 'devices' (cd82880c): kobject_uevent_env
[    0.381338] kobject: 'devices' (cd82880c): kobject_uevent_env: attempted to send uevent without kset!
[    0.383556] kobject: 'dev' (cd828880): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.385575] kobject: 'block' (cd828900): kobject_add_internal: parent: 'dev', set: '<NULL>'
[    0.387646] kobject: 'char' (cd828980): kobject_add_internal: parent: 'dev', set: '<NULL>'
[    0.390007] kobject: 'bus' (cd828a0c): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.392115] kobject: 'bus' (cd828a0c): kobject_uevent_env
[    0.393385] kobject: 'bus' (cd828a0c): kobject_uevent_env: attempted to send uevent without kset!
[    0.395528] kobject: 'system' (cd828a8c): kobject_add_internal: parent: 'devices', set: '<NULL>'
[    0.397753] kobject: 'system' (cd828a8c): kobject_uevent_env
[    0.399118] kobject: 'system' (cd828a8c): kobject_uevent_env: attempted to send uevent without kset!
[    0.400007] kobject: 'class' (cd828b0c): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.402070] kobject: 'class' (cd828b0c): kobject_uevent_env
[    0.403377] kobject: 'class' (cd828b0c): kobject_uevent_env: attempted to send uevent without kset!
[    0.405534] kobject: 'firmware' (cd828b80): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.407681] device: 'platform': device_add
[    0.410005] kobject: 'platform' (c1951888): kobject_add_internal: parent: 'devices', set: 'devices'
[    0.412216] PM: Adding info for No Bus:platform
[    0.413318] kobject: 'platform' (c1951888): kobject_uevent_env
[    0.414658] kobject: 'platform' (c1951888): kobject_uevent_env: filter function caused the event to drop!
[    0.416896] kobject: 'platform' (cd82c80c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.418995] kobject: 'platform' (cd82c80c): kobject_uevent_env
[    0.420006] kobject: 'platform' (cd82c80c): fill_kobj_path: path = '/bus/platform'
[    0.422038] kobject: 'devices' (cd828e8c): kobject_add_internal: parent: 'platform', set: '<NULL>'
[    0.424210] kobject: 'devices' (cd828e8c): kobject_uevent_env
[    0.425538] kobject: 'devices' (cd828e8c): kobject_uevent_env: filter function caused the event to drop!
[    0.427741] kobject: 'drivers' (cd828f0c): kobject_add_internal: parent: 'platform', set: '<NULL>'
[    0.430005] kobject: 'drivers' (cd828f0c): kobject_uevent_env
[    0.431323] kobject: 'drivers' (cd828f0c): kobject_uevent_env: filter function caused the event to drop!
[    0.433605] bus: 'platform': registered
[    0.434605] kobject: 'cpu' (cd82c70c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.436321] kobject: 'cpu' (cd82c70c): kobject_uevent_env
[    0.437285] kobject: 'cpu' (cd82c70c): fill_kobj_path: path = '/bus/cpu'
[    0.438627] kobject: 'devices' (cd84408c): kobject_add_internal: parent: 'cpu', set: '<NULL>'
[    0.440005] kobject: 'devices' (cd84408c): kobject_uevent_env
[    0.441216] kobject: 'devices' (cd84408c): kobject_uevent_env: filter function caused the event to drop!
[    0.443210] kobject: 'drivers' (cd84410c): kobject_add_internal: parent: 'cpu', set: '<NULL>'
[    0.447177] kobject: 'drivers' (cd84410c): kobject_uevent_env
[    0.448377] kobject: 'drivers' (cd84410c): kobject_uevent_env: filter function caused the event to drop!
[    0.450006] bus: 'cpu': registered
[    0.450877] device: 'cpu': device_add
[    0.451781] kobject: 'cpu' (cd804008): kobject_add_internal: parent: 'system', set: 'devices'
[    0.453706] PM: Adding info for No Bus:cpu
[    0.454664] kobject: 'cpu' (cd804008): kobject_uevent_env
[    0.455785] kobject: 'cpu' (cd804008): kobject_uevent_env: filter function caused the event to drop!
[    0.457860] doing early, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.460049] doing early: hung_task_panic='1'
[    0.461064] doing early: bisect-reboot='(null)'
[    0.462124] doing early: i386-randconfig-b064='(null)'
[    0.463261] doing early: branch='mfd/for-next'
[    0.464293] doing early: dyndbg='+p'
[    0.470028] doing early: log_buf_len='8M'
[    0.470988] doing early: ignore_loglevel='(null)'
[    0.472056] doing early: debug='(null)'
[    0.473007] doing early: sched_debug='(null)'
[    0.474071] doing early: apic='debug'
[    0.474995] doing early: dynamic_printk='(null)'
[    0.476059] doing early: sysrq_always_enabled='(null)'
[    0.477189] doing early: prompt_ramdisk='0'
[    0.478176] doing early: console='ttyS0,115200'
[    0.480026] doing early: console='tty0'
[    0.480986] doing early: vga='normal'
[    0.481911] doing early: root='/dev/ram0'
[    0.482883] doing early: rw='(null)'
[    0.483793] doing early: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.485016] doing core, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.490033] doing core: hung_task_panic='1'
[    0.491034] doing core: bisect-reboot='(null)'
[    0.492080] doing core: i386-randconfig-b064='(null)'
[    0.493250] doing core: branch='mfd/for-next'
[    0.494262] doing core: dyndbg='+p'
[    0.495143] doing core: log_buf_len='8M'
[    0.496123] doing core: ignore_loglevel='(null)'
[    0.497181] doing core: debug='(null)'
[    0.498134] doing core: sched_debug='(null)'
[    0.500024] doing core: apic='debug'
[    0.500921] doing core: dynamic_printk='(null)'
[    0.501976] doing core: sysrq_always_enabled='(null)'
[    0.503117] doing core: prompt_ramdisk='0'
[    0.504154] doing core: console='ttyS0,115200'
[    0.505203] doing core: console='tty0'
[    0.506144] doing core: vga='normal'
[    0.507046] doing core: root='/dev/ram0'
[    0.507995] doing core: rw='(null)'
[    0.508901] doing core: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.510012] kobject: 'kernel' (cd844640): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.511959] kobject: 'power' (cd844900): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.513852] kobject: 'debug' (cd844a40): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    0.515814] kobject: 'security' (cd844ac0): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    0.517771] xor: automatically using best checksumming function:
[    0.610014]    pIII_sse  :   174.000 MB/sec
[    0.611012] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.612358] device class 'regulator': registering
[    0.613392] kobject: 'regulator' (cd82ce0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.615402] kobject: 'regulator' (cd82ce0c): kobject_uevent_env
[    0.616610] kobject: 'regulator' (cd82ce0c): fill_kobj_path: path = '/class/regulator'
[    0.618409] debugfs: creating file 'regulator'
[    0.619448] debugfs: creating file 'supply_map'
[    0.620009] Registering platform device 'reg-dummy'. Parent at platform
[    0.621343] device: 'reg-dummy': device_add
[    0.622301] kobject: 'reg-dummy' (cd804a10): kobject_add_internal: parent: 'platform', set: 'devices'
[    0.624325] bus: 'platform': add device reg-dummy
[    0.625396] PM: Adding info for platform:reg-dummy
[    0.626455] kobject: 'reg-dummy' (cd804a10): kobject_uevent_env
[    0.627698] kobject: 'reg-dummy' (cd804a10): fill_kobj_path: path = '/devices/platform/reg-dummy'
[    0.630009] bus: 'platform': add driver reg-dummy
[    0.631089] kobject: 'reg-dummy' (cd846cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    0.633035] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.635019] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.636873] device: 'regulator.0': device_add
[    0.637894] kobject: 'regulator' (cd844f00): kobject_add_internal: parent: 'reg-dummy', set: '(null)'
[    0.640006] kobject: 'regulator.0' (cd804c54): kobject_add_internal: parent: 'regulator', set: 'devices'
[    0.642001] PM: Adding info for No Bus:regulator.0
[    0.643032] kobject: 'regulator.0' (cd804c54): kobject_uevent_env
[    0.644284] kobject: 'regulator.0' (cd804c54): fill_kobj_path: path = '/devices/platform/reg-dummy/regulator/regulator.0'
[    0.646595] dummy: 
[    0.647285] debugfs: creating file 'dummy'
[    0.648252] debugfs: creating file 'use_count'
[    0.649263] debugfs: creating file 'open_count'
[    0.650007] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.651360] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.653174] kobject: 'reg-dummy' (cd846cc0): kobject_uevent_env
[    0.654432] kobject: 'reg-dummy' (cd846cc0): fill_kobj_path: path = '/bus/platform/drivers/reg-dummy'
[    0.656520] NET: Registered protocol family 16
[    0.657548] doing postcore, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.660048] doing postcore: hung_task_panic='1'
[    0.661176] doing postcore: bisect-reboot='(null)'
[    0.662289] doing postcore: i386-randconfig-b064='(null)'
[    0.663449] doing postcore: branch='mfd/for-next'
[    0.664508] doing postcore: dyndbg='+p'
[    0.665474] doing postcore: log_buf_len='8M'
[    0.670030] doing postcore: ignore_loglevel='(null)'
[    0.671136] doing postcore: debug='(null)'
[    0.672116] doing postcore: sched_debug='(null)'
[    0.673176] doing postcore: apic='debug'
[    0.674178] doing postcore: dynamic_printk='(null)'
[    0.675293] doing postcore: sysrq_always_enabled='(null)'
[    0.676478] doing postcore: prompt_ramdisk='0'
[    0.677521] doing postcore: console='ttyS0,115200'
[    0.678594] doing postcore: console='tty0'
[    0.680023] doing postcore: vga='normal'
[    0.680975] doing postcore: root='/dev/ram0'
[    0.681991] doing postcore: rw='(null)'
[    0.682947] doing postcore: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.684150] device class 'bdi': registering
[    0.685218] kobject: 'bdi' (cd84920c): kobject_add_internal: parent: 'class', set: 'class'
[    0.687080] kobject: 'bdi' (cd84920c): kobject_uevent_env
[    0.688217] kobject: 'bdi' (cd84920c): fill_kobj_path: path = '/class/bdi'
[    0.689576] debugfs: creating file 'bdi'
[    0.690011] device class 'pci_bus': registering
[    0.691030] kobject: 'pci_bus' (cd84930c): kobject_add_internal: parent: 'class', set: 'class'
[    0.692959] kobject: 'pci_bus' (cd84930c): kobject_uevent_env
[    0.694205] kobject: 'pci_bus' (cd84930c): fill_kobj_path: path = '/class/pci_bus'
[    0.695988] kobject: 'pci' (cd84940c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.697784] kobject: 'pci' (cd84940c): kobject_uevent_env
[    0.698938] kobject: 'pci' (cd84940c): fill_kobj_path: path = '/bus/pci'
[    0.700007] kobject: 'devices' (cd84878c): kobject_add_internal: parent: 'pci', set: '<NULL>'
[    0.702771] kobject: 'devices' (cd84878c): kobject_uevent_env
[    0.704101] kobject: 'devices' (cd84878c): kobject_uevent_env: filter function caused the event to drop!
[    0.706332] kobject: 'drivers' (cd84880c): kobject_add_internal: parent: 'pci', set: '<NULL>'
[    0.708454] kobject: 'drivers' (cd84880c): kobject_uevent_env
[    0.710004] kobject: 'drivers' (cd84880c): kobject_uevent_env: filter function caused the event to drop!
[    0.712192] bus: 'pci': registered
[    0.713188] device: 'rapidio': device_add
[    0.714221] kobject: 'rapidio' (c1942968): kobject_add_internal: parent: 'devices', set: 'devices'
[    0.716358] PM: Adding info for No Bus:rapidio
[    0.717509] kobject: 'rapidio' (c1942968): kobject_uevent_env
[    0.718816] kobject: 'rapidio' (c1942968): kobject_uevent_env: filter function caused the event to drop!
[    0.720005] kobject: 'rapidio' (cd84950c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.722157] kobject: 'rapidio' (cd84950c): kobject_uevent_env
[    0.723487] kobject: 'rapidio' (cd84950c): fill_kobj_path: path = '/bus/rapidio'
[    0.725353] kobject: 'devices' (cd848bcc): kobject_add_internal: parent: 'rapidio', set: '<NULL>'
[    0.730005] kobject: 'devices' (cd848bcc): kobject_uevent_env
[    0.731287] kobject: 'devices' (cd848bcc): kobject_uevent_env: filter function caused the event to drop!
[    0.733543] kobject: 'drivers' (cd848c4c): kobject_add_internal: parent: 'rapidio', set: '<NULL>'
[    0.735683] kobject: 'drivers' (cd848c4c): kobject_uevent_env
[    0.737037] kobject: 'drivers' (cd848c4c): kobject_uevent_env: filter function caused the event to drop!
[    0.740006] bus: 'rapidio': registered
[    0.740981] device class 'lcd': registering
[    0.742048] kobject: 'lcd' (cd84960c): kobject_add_internal: parent: 'class', set: 'class'
[    0.744114] kobject: 'lcd' (cd84960c): kobject_uevent_env
[    0.745366] kobject: 'lcd' (cd84960c): fill_kobj_path: path = '/class/lcd'
[    0.746846] device class 'backlight': registering
[    0.750006] kobject: 'backlight' (cd84970c): kobject_add_internal: parent: 'class', set: 'class'
[    0.752128] kobject: 'backlight' (cd84970c): kobject_uevent_env
[    0.753459] kobject: 'backlight' (cd84970c): fill_kobj_path: path = '/class/backlight'
[    0.755468] device class 'video_output': registering
[    0.756652] kobject: 'video_output' (cd84980c): kobject_add_internal: parent: 'class', set: 'class'
[    0.758827] kobject: 'video_output' (cd84980c): kobject_uevent_env
[    0.760005] kobject: 'video_output' (cd84980c): fill_kobj_path: path = '/class/video_output'
[    0.762053] device class 'tty': registering
[    0.763091] kobject: 'tty' (cd84990c): kobject_add_internal: parent: 'class', set: 'class'
[    0.765128] kobject: 'tty' (cd84990c): kobject_uevent_env
[    0.766435] kobject: 'tty' (cd84990c): fill_kobj_path: path = '/class/tty'
[    0.767900] device class 'vtconsole': registering
[    0.769133] kobject: 'vtconsole' (cd849a0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.770005] kobject: 'vtconsole' (cd849a0c): kobject_uevent_env
[    0.771335] kobject: 'vtconsole' (cd849a0c): fill_kobj_path: path = '/class/vtconsole'
[    0.773335] device: 'vtcon0': device_add
[    0.774422] kobject: 'virtual' (cd848f80): kobject_add_internal: parent: 'devices', set: '<NULL>'
[    0.776598] kobject: 'vtconsole' (cd89c000): kobject_add_internal: parent: 'virtual', set: '(null)'
[    0.780006] kobject: 'vtcon0' (cd805208): kobject_add_internal: parent: 'vtconsole', set: 'devices'
[    0.782171] PM: Adding info for No Bus:vtcon0
[    0.783256] kobject: 'vtcon0' (cd805208): kobject_uevent_env
[    0.784520] kobject: 'vtcon0' (cd805208): fill_kobj_path: path = '/devices/virtual/vtconsole/vtcon0'
[    0.786741] debugfs: creating file 'wakeup_sources'
[    0.787963] debugfs: creating file 'regmap'
[    0.789041] kobject: 'spi' (cd849b0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.790005] kobject: 'spi' (cd849b0c): kobject_uevent_env
[    0.791272] kobject: 'spi' (cd849b0c): fill_kobj_path: path = '/bus/spi'
[    0.792686] kobject: 'devices' (cd89c44c): kobject_add_internal: parent: 'spi', set: '<NULL>'
[    0.794813] kobject: 'devices' (cd89c44c): kobject_uevent_env
[    0.796157] kobject: 'devices' (cd89c44c): kobject_uevent_env: filter function caused the event to drop!
[    0.798359] kobject: 'drivers' (cd89c4cc): kobject_add_internal: parent: 'spi', set: '<NULL>'
[    0.800006] kobject: 'drivers' (cd89c4cc): kobject_uevent_env
[    0.801426] kobject: 'drivers' (cd89c4cc): kobject_uevent_env: filter function caused the event to drop!
[    0.803659] bus: 'spi': registered
[    0.804597] device class 'spi_master': registering
[    0.805796] kobject: 'spi_master' (cd849c0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.807969] kobject: 'spi_master' (cd849c0c): kobject_uevent_env
[    0.810005] kobject: 'spi_master' (cd849c0c): fill_kobj_path: path = '/class/spi_master'
[    0.812001] kobject: 'i2c' (cd849d0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.813993] kobject: 'i2c' (cd849d0c): kobject_uevent_env
[    0.815269] kobject: 'i2c' (cd849d0c): fill_kobj_path: path = '/bus/i2c'
[    0.816734] kobject: 'devices' (cd89c68c): kobject_add_internal: parent: 'i2c', set: '<NULL>'
[    0.820005] kobject: 'devices' (cd89c68c): kobject_uevent_env
[    0.821284] kobject: 'devices' (cd89c68c): kobject_uevent_env: filter function caused the event to drop!
[    0.823510] kobject: 'drivers' (cd89c70c): kobject_add_internal: parent: 'i2c', set: '<NULL>'
[    0.825608] kobject: 'drivers' (cd89c70c): kobject_uevent_env
[    0.826966] kobject: 'drivers' (cd89c70c): kobject_uevent_env: filter function caused the event to drop!
[    0.829220] bus: 'i2c': registered
[    0.830004] bus: 'i2c': add driver dummy
[    0.831025] kobject: 'dummy' (cd89d000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    0.833105] kobject: 'dummy' (cd89d000): kobject_uevent_env
[    0.834429] kobject: 'dummy' (cd89d000): fill_kobj_path: path = '/bus/i2c/drivers/dummy'
[    0.836423] i2c-core: driver [dummy] registered
[    0.837575] doing arch, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.840043] doing arch: hung_task_panic='1'
[    0.841112] doing arch: bisect-reboot='(null)'
[    0.842317] doing arch: i386-randconfig-b064='(null)'
[    0.843551] doing arch: branch='mfd/for-next'
[    0.844669] doing arch: dyndbg='+p'
[    0.850028] doing arch: log_buf_len='8M'
[    0.851093] doing arch: ignore_loglevel='(null)'
[    0.852237] doing arch: debug='(null)'
[    0.853271] doing arch: sched_debug='(null)'
[    0.854495] doing arch: apic='debug'
[    0.855556] doing arch: dynamic_printk='(null)'
[    0.856681] doing arch: sysrq_always_enabled='(null)'
[    0.858101] doing arch: prompt_ramdisk='0'
[    0.859174] doing arch: console='ttyS0,115200'
[    0.860028] doing arch: console='tty0'
[    0.861107] doing arch: vga='normal'
[    0.862121] doing arch: root='/dev/ram0'
[    0.863198] doing arch: rw='(null)'
[    0.864163] doing arch: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.865474] debugfs: creating file 'x86'
[    0.866508] ACPI: bus type pci registered
[    0.867507] device class 'dma': registering
[    0.868558] kobject: 'dma' (cd849e0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.870006] kobject: 'dma' (cd849e0c): kobject_uevent_env
[    0.871276] kobject: 'dma' (cd849e0c): fill_kobj_path: path = '/class/dma'
[    0.872814] device class 'dmi': registering
[    0.873858] kobject: 'dmi' (cd849f0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.875884] kobject: 'dmi' (cd849f0c): kobject_uevent_env
[    0.877241] kobject: 'dmi' (cd849f0c): fill_kobj_path: path = '/class/dmi'
[    0.880008] device: 'id': device_add
[    0.880983] kobject: 'dmi' (cd89c980): kobject_add_internal: parent: 'virtual', set: '(null)'
[    0.883117] kobject: 'id' (cd805408): kobject_add_internal: parent: 'dmi', set: 'devices'
[    0.884779] PM: Adding info for No Bus:id
[    0.885437] kobject: 'id' (cd805408): kobject_uevent_env
[    0.886219] kobject: 'id' (cd805408): fill_kobj_path: path = '/devices/virtual/dmi/id'
[    0.887556] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.888494] PCI: Using configuration type 1 for base access
[    0.889308] doing subsys, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.890028] doing subsys: hung_task_panic='1'
[    0.890753] doing subsys: bisect-reboot='(null)'
[    0.891492] doing subsys: i386-randconfig-b064='(null)'
[    0.892276] doing subsys: branch='mfd/for-next'
[    0.893016] doing subsys: dyndbg='+p'
[    0.893660] doing subsys: log_buf_len='8M'
[    0.894354] doing subsys: ignore_loglevel='(null)'
[    0.895116] doing subsys: debug='(null)'
[    0.895786] doing subsys: sched_debug='(null)'
[    0.900019] doing subsys: apic='debug'
[    0.900661] doing subsys: dynamic_printk='(null)'
[    0.901408] doing subsys: sysrq_always_enabled='(null)'
[    0.902204] doing subsys: prompt_ramdisk='0'
[    0.902898] doing subsys: console='ttyS0,115200'
[    0.903639] doing subsys: console='tty0'
[    0.904311] doing subsys: vga='normal'
[    0.904986] doing subsys: root='/dev/ram0'
[    0.905673] doing subsys: rw='(null)'
[    0.906330] doing subsys: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.907144] device: 'cpu0': device_add
[    0.907767] kobject: 'cpu0' (cdd2c610): kobject_add_internal: parent: 'cpu', set: 'devices'
[    0.909096] bus: 'cpu': add device cpu0
[    0.910007] PM: Adding info for cpu:cpu0
[    0.910668] kobject: 'cpu0' (cdd2c610): kobject_uevent_env
[    0.911491] kobject: 'cpu0' (cdd2c610): fill_kobj_path: path = '/devices/system/cpu/cpu0'
[    0.912784] device: 'cpu1': device_add
[    0.913416] kobject: 'cpu1' (cdd36610): kobject_add_internal: parent: 'cpu', set: 'devices'
[    0.914709] bus: 'cpu': add device cpu1
[    0.915374] PM: Adding info for cpu:cpu1
[    0.916046] kobject: 'cpu1' (cdd36610): kobject_uevent_env
[    0.916849] kobject: 'cpu1' (cdd36610): fill_kobj_path: path = '/devices/system/cpu/cpu1'
[    0.920014] kobject: 'module' (cd89e58c): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.921333] kobject: 'module' (cd89e58c): kobject_uevent_env
[    0.922155] kobject: 'module' (cd89e58c): kobject_uevent_env: attempted to send uevent without kset!
[    0.923524] kobject: 'configfs' (cd89e600): kobject_add_internal: parent: 'module', set: 'module'
[    0.924886] kobject: 'configfs' (cd89e600): kobject_uevent_env
[    0.925732] kobject: 'configfs' (cd89e600): fill_kobj_path: path = '/module/configfs'
[    0.926995] kobject: 'xz_dec' (cd89e6c0): kobject_add_internal: parent: 'module', set: 'module'
[    0.928325] kobject: 'xz_dec' (cd89e6c0): kobject_uevent_env
[    0.929142] kobject: 'xz_dec' (cd89e6c0): fill_kobj_path: path = '/module/xz_dec'
[    0.930005] kobject: 'vmlfb' (cd89e780): kobject_add_internal: parent: 'module', set: 'module'
[    0.931334] kobject: 'vmlfb' (cd89e780): kobject_uevent_env
[    0.932150] kobject: 'vmlfb' (cd89e780): fill_kobj_path: path = '/module/vmlfb'
[    0.933346] kobject: 'hangcheck_timer' (cd89e840): kobject_add_internal: parent: 'module', set: 'module'
[    0.934774] kobject: 'hangcheck_timer' (cd89e840): kobject_uevent_env
[    0.935678] kobject: 'hangcheck_timer' (cd89e840): fill_kobj_path: path = '/module/hangcheck_timer'
[    0.937039] kobject: 'hpilo' (cd89e900): kobject_add_internal: parent: 'module', set: 'module'
[    0.938387] kobject: 'hpilo' (cd89e900): kobject_uevent_env
[    0.939219] kobject: 'hpilo' (cd89e900): fill_kobj_path: path = '/module/hpilo'
[    0.940005] kobject: 'isl29003' (cd89e9c0): kobject_add_internal: parent: 'module', set: 'module'
[    0.941358] kobject: 'isl29003' (cd89e9c0): kobject_uevent_env
[    0.942189] kobject: 'isl29003' (cd89e9c0): fill_kobj_path: path = '/module/isl29003'
[    0.943437] kobject: 'scsi_transport_iscsi' (cd89ea80): kobject_add_internal: parent: 'module', set: 'module'
[    0.944862] kobject: 'scsi_transport_iscsi' (cd89ea80): kobject_uevent_env
[    0.945820] kobject: 'scsi_transport_iscsi' (cd89ea80): fill_kobj_path: path = '/module/scsi_transport_iscsi'
[    0.947275] kobject: 'libata' (cd89eb40): kobject_add_internal: parent: 'module', set: 'module'
[    0.948604] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    0.950003] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    0.951221] kobject: 'ahci' (cd89ec00): kobject_add_internal: parent: 'module', set: 'module'
[    0.952525] kobject: 'ahci' (cd89ec00): kobject_uevent_env
[    0.953356] kobject: 'ahci' (cd89ec00): fill_kobj_path: path = '/module/ahci'
[    0.954333] kobject: 'sata_inic162x' (cd89ecc0): kobject_add_internal: parent: 'module', set: 'module'
[    0.955724] kobject: 'sata_inic162x' (cd89ecc0): kobject_uevent_env
[    0.956619] kobject: 'sata_inic162x' (cd89ecc0): fill_kobj_path: path = '/module/sata_inic162x'
[    0.957979] kobject: 'atl1' (cd89ed80): kobject_add_internal: parent: 'module', set: 'module'
[    0.959295] kobject: 'atl1' (cd89ed80): kobject_uevent_env
[    0.960003] kobject: 'atl1' (cd89ed80): fill_kobj_path: path = '/module/atl1'
[    0.960975] kobject: 'bnx2' (cd89ee40): kobject_add_internal: parent: 'module', set: 'module'
[    0.962293] kobject: 'bnx2' (cd89ee40): kobject_uevent_env
[    0.963102] kobject: 'bnx2' (cd89ee40): fill_kobj_path: path = '/module/bnx2'
[    0.964072] kobject: 's2io' (cd89ef00): kobject_add_internal: parent: 'module', set: 'module'
[    0.965386] kobject: 's2io' (cd89ef00): kobject_uevent_env
[    0.966208] kobject: 's2io' (cd89ef00): fill_kobj_path: path = '/module/s2io'
[    0.967186] kobject: 'asix' (cd89efc0): kobject_add_internal: parent: 'module', set: 'module'
[    0.968512] kobject: 'asix' (cd89efc0): kobject_uevent_env
[    0.969349] kobject: 'asix' (cd89efc0): fill_kobj_path: path = '/module/asix'
[    0.970005] kobject: 'uio_pci_generic' (cd89f080): kobject_add_internal: parent: 'module', set: 'module'
[    0.971418] kobject: 'uio_pci_generic' (cd89f080): kobject_uevent_env
[    0.972343] kobject: 'uio_pci_generic' (cd89f080): fill_kobj_path: path = '/module/uio_pci_generic'
[    0.973707] kobject: 'ldusb' (cd89f140): kobject_add_internal: parent: 'module', set: 'module'
[    0.975041] kobject: 'ldusb' (cd89f140): kobject_uevent_env
[    0.975863] kobject: 'ldusb' (cd89f140): fill_kobj_path: path = '/module/ldusb'
[    0.977056] kobject: 'usbatm' (cd89f200): kobject_add_internal: parent: 'module', set: 'module'
[    0.978401] kobject: 'usbatm' (cd89f200): kobject_uevent_env
[    0.980003] kobject: 'usbatm' (cd89f200): fill_kobj_path: path = '/module/usbatm'
[    0.981230] kobject: 'input_polldev' (cd89f2c0): kobject_add_internal: parent: 'module', set: 'module'
[    0.982614] kobject: 'input_polldev' (cd89f2c0): kobject_uevent_env
[    0.983501] kobject: 'input_polldev' (cd89f2c0): fill_kobj_path: path = '/module/input_polldev'
[    0.984847] kobject: 'sparse_keymap' (cd89f380): kobject_add_internal: parent: 'module', set: 'module'
[    0.986273] kobject: 'sparse_keymap' (cd89f380): kobject_uevent_env
[    0.987152] kobject: 'sparse_keymap' (cd89f380): fill_kobj_path: path = '/module/sparse_keymap'
[    0.988473] kobject: 'apanel' (cd89f440): kobject_add_internal: parent: 'module', set: 'module'
[    0.989807] kobject: 'apanel' (cd89f440): kobject_uevent_env
[    0.990003] kobject: 'apanel' (cd89f440): fill_kobj_path: path = '/module/apanel'
[    0.991196] kobject: 'ati_remote2' (cd89f500): kobject_add_internal: parent: 'module', set: 'module'
[    0.992578] kobject: 'ati_remote2' (cd89f500): kobject_uevent_env
[    0.993440] kobject: 'ati_remote2' (cd89f500): fill_kobj_path: path = '/module/ati_remote2'
[    0.994726] kobject: 'uinput' (cd89f5c0): kobject_add_internal: parent: 'module', set: 'module'
[    0.996045] kobject: 'uinput' (cd89f5c0): kobject_uevent_env
[    0.996857] kobject: 'uinput' (cd89f5c0): fill_kobj_path: path = '/module/uinput'
[    0.998077] kobject: 'i2o_core' (cd89f680): kobject_add_internal: parent: 'module', set: 'module'
[    1.000003] kobject: 'i2o_core' (cd89f680): kobject_uevent_env
[    1.000836] kobject: 'i2o_core' (cd89f680): fill_kobj_path: path = '/module/i2o_core'
[    1.002100] kobject: 'i2o_config' (cd89f740): kobject_add_internal: parent: 'module', set: 'module'
[    1.003465] kobject: 'i2o_config' (cd89f740): kobject_uevent_env
[    1.004325] kobject: 'i2o_config' (cd89f740): fill_kobj_path: path = '/module/i2o_config'
[    1.005600] kobject: 'i2o_scsi' (cd89f800): kobject_add_internal: parent: 'module', set: 'module'
[    1.006930] kobject: 'i2o_scsi' (cd89f800): kobject_uevent_env
[    1.007793] kobject: 'i2o_scsi' (cd89f800): fill_kobj_path: path = '/module/i2o_scsi'
[    1.009039] kobject: 'i2o_proc' (cd89f8c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.010003] kobject: 'i2o_proc' (cd89f8c0): kobject_uevent_env
[    1.010841] kobject: 'i2o_proc' (cd89f8c0): fill_kobj_path: path = '/module/i2o_proc'
[    1.012070] kobject: 'i2c_intel_mid' (cd89f980): kobject_add_internal: parent: 'module', set: 'module'
[    1.013456] kobject: 'i2c_intel_mid' (cd89f980): kobject_uevent_env
[    1.014342] kobject: 'i2c_intel_mid' (cd89f980): fill_kobj_path: path = '/module/i2c_intel_mid'
[    1.015680] kobject: 'hpwdt' (cd89fa40): kobject_add_internal: parent: 'module', set: 'module'
[    1.016997] kobject: 'hpwdt' (cd89fa40): kobject_uevent_env
[    1.017821] kobject: 'hpwdt' (cd89fa40): fill_kobj_path: path = '/module/hpwdt'
[    1.019009] kobject: 'sbc8360' (cd89fb00): kobject_add_internal: parent: 'module', set: 'module'
[    1.020004] kobject: 'sbc8360' (cd89fb00): kobject_uevent_env
[    1.020840] kobject: 'sbc8360' (cd89fb00): fill_kobj_path: path = '/module/sbc8360'
[    1.022104] kobject: 'hci_uart' (cd89fbc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.023468] kobject: 'hci_uart' (cd89fbc0): kobject_uevent_env
[    1.024317] kobject: 'hci_uart' (cd89fbc0): fill_kobj_path: path = '/module/hci_uart'
[    1.025572] kobject: 'btusb' (cd89fc80): kobject_add_internal: parent: 'module', set: 'module'
[    1.027270] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.028579] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.030007] kobject: 'btsdio' (cd89fd40): kobject_add_internal: parent: 'module', set: 'module'
[    1.032127] kobject: 'btsdio' (cd89fd40): kobject_uevent_env
[    1.033415] kobject: 'btsdio' (cd89fd40): fill_kobj_path: path = '/module/btsdio'
[    1.035353] kobject: 'dell_rbu' (cd89fe00): kobject_add_internal: parent: 'module', set: 'module'
[    1.037682] kobject: 'dell_rbu' (cd89fe00): kobject_uevent_env
[    1.040005] kobject: 'dell_rbu' (cd89fe00): fill_kobj_path: path = '/module/dell_rbu'
[    1.041938] kobject: 'dcdbas' (cd89fec0): kobject_add_internal: parent: 'module', set: 'module'
[    1.044055] kobject: 'dcdbas' (cd89fec0): kobject_uevent_env
[    1.045338] kobject: 'dcdbas' (cd89fec0): fill_kobj_path: path = '/module/dcdbas'
[    1.047240] kobject: 'pktgen' (cd89ff80): kobject_add_internal: parent: 'module', set: 'module'
[    1.049395] kobject: 'pktgen' (cd89ff80): kobject_uevent_env
[    1.050005] kobject: 'pktgen' (cd89ff80): fill_kobj_path: path = '/module/pktgen'
[    1.051885] kobject: 'bridge' (cd8a1040): kobject_add_internal: parent: 'module', set: 'module'
[    1.054038] kobject: 'bridge' (cd8a1040): kobject_uevent_env
[    1.055402] kobject: 'bridge' (cd8a1040): fill_kobj_path: path = '/module/bridge'
[    1.060007] kobject: 'bluetooth' (cd8a1100): kobject_add_internal: parent: 'module', set: 'module'
[    1.062313] kobject: 'bluetooth' (cd8a1100): kobject_uevent_env
[    1.063640] kobject: 'bluetooth' (cd8a1100): fill_kobj_path: path = '/module/bluetooth'
[    1.065688] kobject: 'kernel' (cd8a11c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.067863] kobject: 'kernel' (cd8a11c0): kobject_uevent_env
[    1.070005] kobject: 'kernel' (cd8a11c0): fill_kobj_path: path = '/module/kernel'
[    1.071940] kobject: 'kvm' (cd8a1300): kobject_add_internal: parent: 'module', set: 'module'
[    1.073997] kobject: 'kvm' (cd8a1300): kobject_uevent_env
[    1.075243] kobject: 'kvm' (cd8a1300): fill_kobj_path: path = '/module/kvm'
[    1.076725] kobject: 'kvm' (cd8a1300): kobject_uevent_env
[    1.077782] kobject: 'kvm' (cd8a1300): fill_kobj_path: path = '/module/kvm'
[    1.078748] kobject: 'kvm' (cd8a1300): kobject_uevent_env
[    1.080006] kobject: 'kvm' (cd8a1300): fill_kobj_path: path = '/module/kvm'
[    1.080972] kobject: 'kvm_intel' (cd8a1480): kobject_add_internal: parent: 'module', set: 'module'
[    1.082337] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.083187] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.084451] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.085307] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.086566] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.087423] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.088685] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.090003] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.091297] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.092133] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.093433] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.094286] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.095565] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.096419] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.097697] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.098549] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.099814] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.100003] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.101275] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.102137] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.103404] kobject: 'kvm_intel' (cd8a1480): kobject_uevent_env
[    1.104261] kobject: 'kvm_intel' (cd8a1480): fill_kobj_path: path = '/module/kvm_intel'
[    1.105549] kobject: 'apm' (cd8a1840): kobject_add_internal: parent: 'module', set: 'module'
[    1.106843] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.107651] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.108623] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.110003] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.110972] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.111775] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.112740] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.113545] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.114776] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.116040] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.117585] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.118877] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.120014] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.121315] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.122889] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.124194] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.125703] kobject: 'apm' (cd8a1840): kobject_uevent_env
[    1.126967] kobject: 'apm' (cd8a1840): fill_kobj_path: path = '/module/apm'
[    1.128482] kobject: 'kernel' (cd8a11c0): kobject_uevent_env
[    1.130005] kobject: 'kernel' (cd8a11c0): fill_kobj_path: path = '/module/kernel'
[    1.131955] kobject: 'kernel' (cd8a11c0): kobject_uevent_env
[    1.133283] kobject: 'kernel' (cd8a11c0): fill_kobj_path: path = '/module/kernel'
[    1.135259] kobject: 'printk' (cd8a1bc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.137473] kobject: 'printk' (cd8a1bc0): kobject_uevent_env
[    1.138832] kobject: 'printk' (cd8a1bc0): fill_kobj_path: path = '/module/printk'
[    1.140012] kobject: 'printk' (cd8a1bc0): kobject_uevent_env
[    1.141413] kobject: 'printk' (cd8a1bc0): fill_kobj_path: path = '/module/printk'
[    1.143325] kobject: 'printk' (cd8a1bc0): kobject_uevent_env
[    1.144647] kobject: 'printk' (cd8a1bc0): fill_kobj_path: path = '/module/printk'
[    1.146613] kobject: 'printk' (cd8a1bc0): kobject_uevent_env
[    1.147976] kobject: 'printk' (cd8a1bc0): fill_kobj_path: path = '/module/printk'
[    1.150008] kobject: 'spurious' (cd8a1d80): kobject_add_internal: parent: 'module', set: 'module'
[    1.152227] kobject: 'spurious' (cd8a1d80): kobject_uevent_env
[    1.153543] kobject: 'spurious' (cd8a1d80): fill_kobj_path: path = '/module/spurious'
[    1.155582] kobject: 'spurious' (cd8a1d80): kobject_uevent_env
[    1.156965] kobject: 'spurious' (cd8a1d80): fill_kobj_path: path = '/module/spurious'
[    1.160007] kobject: 'rcutorture' (cd8a1ec0): kobject_add_internal: parent: 'module', set: 'module'
[    1.162240] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.163584] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.165709] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.167056] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.169143] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.170005] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.172056] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.173440] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.175497] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.176873] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.178985] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.180005] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.182068] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.183436] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.185475] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.186861] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.190016] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.191354] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.193426] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.194804] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.196917] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.198302] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.200020] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.201411] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.203518] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.204936] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.207005] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.208361] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.210022] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.211388] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.213327] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.214203] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.215501] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.216365] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.217651] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.218518] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.220015] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.220893] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.222187] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.223057] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.224352] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.225230] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.226507] kobject: 'rcutorture' (cd8a1ec0): kobject_uevent_env
[    1.227379] kobject: 'rcutorture' (cd8a1ec0): fill_kobj_path: path = '/module/rcutorture'
[    1.228663] kobject: 'rcutree' (cd8a35c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.230005] kobject: 'rcutree' (cd8a35c0): kobject_uevent_env
[    1.230835] kobject: 'rcutree' (cd8a35c0): fill_kobj_path: path = '/module/rcutree'
[    1.232093] kobject: 'rcutree' (cd8a35c0): kobject_uevent_env
[    1.232936] kobject: 'rcutree' (cd8a35c0): fill_kobj_path: path = '/module/rcutree'
[    1.234167] kobject: 'block' (cd8a3700): kobject_add_internal: parent: 'module', set: 'module'
[    1.235499] kobject: 'block' (cd8a3700): kobject_uevent_env
[    1.238274] kobject: 'block' (cd8a3700): fill_kobj_path: path = '/module/block'
[    1.240006] kobject: 'dynamic_debug' (cd8a3840): kobject_add_internal: parent: 'module', set: 'module'
[    1.241384] kobject: 'dynamic_debug' (cd8a3840): kobject_uevent_env
[    1.242277] kobject: 'dynamic_debug' (cd8a3840): fill_kobj_path: path = '/module/dynamic_debug'
[    1.243605] kobject: 'pci_hotplug' (cd8a3980): kobject_add_internal: parent: 'module', set: 'module'
[    1.245006] kobject: 'pci_hotplug' (cd8a3980): kobject_uevent_env
[    1.245864] kobject: 'pci_hotplug' (cd8a3980): fill_kobj_path: path = '/module/pci_hotplug'
[    1.247168] kobject: 'pci_hotplug' (cd8a3980): kobject_uevent_env
[    1.248032] kobject: 'pci_hotplug' (cd8a3980): fill_kobj_path: path = '/module/pci_hotplug'
[    1.249316] kobject: 'cpqphp' (cd8a3ac0): kobject_add_internal: parent: 'module', set: 'module'
[    1.250005] kobject: 'cpqphp' (cd8a3ac0): kobject_uevent_env
[    1.250833] kobject: 'cpqphp' (cd8a3ac0): fill_kobj_path: path = '/module/cpqphp'
[    1.252077] kobject: 'cpqphp' (cd8a3ac0): kobject_uevent_env
[    1.252889] kobject: 'cpqphp' (cd8a3ac0): fill_kobj_path: path = '/module/cpqphp'
[    1.254123] kobject: 'shpchp' (cd8a3c00): kobject_add_internal: parent: 'module', set: 'module'
[    1.255455] kobject: 'shpchp' (cd8a3c00): kobject_uevent_env
[    1.256295] kobject: 'shpchp' (cd8a3c00): fill_kobj_path: path = '/module/shpchp'
[    1.257516] kobject: 'shpchp' (cd8a3c00): kobject_uevent_env
[    1.258336] kobject: 'shpchp' (cd8a3c00): fill_kobj_path: path = '/module/shpchp'
[    1.260007] kobject: 'shpchp' (cd8a3c00): kobject_uevent_env
[    1.260841] kobject: 'shpchp' (cd8a3c00): fill_kobj_path: path = '/module/shpchp'
[    1.262052] kobject: 'vt8623fb' (cd8a3d80): kobject_add_internal: parent: 'module', set: 'module'
[    1.263397] kobject: 'vt8623fb' (cd8a3d80): kobject_uevent_env
[    1.264223] kobject: 'vt8623fb' (cd8a3d80): fill_kobj_path: path = '/module/vt8623fb'
[    1.265440] kobject: 'vt8623fb' (cd8a3d80): kobject_uevent_env
[    1.266274] kobject: 'vt8623fb' (cd8a3d80): fill_kobj_path: path = '/module/vt8623fb'
[    1.267518] kobject: 'acpi' (cd8a3ec0): kobject_add_internal: parent: 'module', set: 'module'
[    1.268843] kobject: 'acpi' (cd8a3ec0): kobject_uevent_env
[    1.270003] kobject: 'acpi' (cd8a3ec0): fill_kobj_path: path = '/module/acpi'
[    1.270980] kobject: 'acpi' (cd8a3ec0): kobject_uevent_env
[    1.271788] kobject: 'acpi' (cd8a3ec0): fill_kobj_path: path = '/module/acpi'
[    1.272767] kobject: 'acpi' (cd8a3ec0): kobject_uevent_env
[    1.273575] kobject: 'acpi' (cd8a3ec0): fill_kobj_path: path = '/module/acpi'
[    1.274560] kobject: 'video' (cd8a1f80): kobject_add_internal: parent: 'module', set: 'module'
[    1.275933] kobject: 'video' (cd8a1f80): kobject_uevent_env
[    1.276735] kobject: 'video' (cd8a1f80): fill_kobj_path: path = '/module/video'
[    1.277951] kobject: 'video' (cd8a1f80): kobject_uevent_env
[    1.278766] kobject: 'video' (cd8a1f80): fill_kobj_path: path = '/module/video'
[    1.280007] kobject: 'video' (cd8a1f80): kobject_uevent_env
[    1.280812] kobject: 'video' (cd8a1f80): fill_kobj_path: path = '/module/video'
[    1.282009] kobject: 'processor' (cd8a4100): kobject_add_internal: parent: 'module', set: 'module'
[    1.283377] kobject: 'processor' (cd8a4100): kobject_uevent_env
[    1.284247] kobject: 'processor' (cd8a4100): fill_kobj_path: path = '/module/processor'
[    1.285502] kobject: 'processor' (cd8a4100): kobject_uevent_env
[    1.286375] kobject: 'processor' (cd8a4100): fill_kobj_path: path = '/module/processor'
[    1.287646] kobject: 'thermal' (cd8a4240): kobject_add_internal: parent: 'module', set: 'module'
[    1.288997] kobject: 'thermal' (cd8a4240): kobject_uevent_env
[    1.290004] kobject: 'thermal' (cd8a4240): fill_kobj_path: path = '/module/thermal'
[    1.291252] kobject: 'thermal' (cd8a4240): kobject_uevent_env
[    1.292089] kobject: 'thermal' (cd8a4240): fill_kobj_path: path = '/module/thermal'
[    1.293312] kobject: 'thermal' (cd8a4240): kobject_uevent_env
[    1.294150] kobject: 'thermal' (cd8a4240): fill_kobj_path: path = '/module/thermal'
[    1.295378] kobject: 'thermal' (cd8a4240): kobject_uevent_env
[    1.296221] kobject: 'thermal' (cd8a4240): fill_kobj_path: path = '/module/thermal'
[    1.297457] kobject: 'battery' (cd8a4400): kobject_add_internal: parent: 'module', set: 'module'
[    1.298804] kobject: 'battery' (cd8a4400): kobject_uevent_env
[    1.299635] kobject: 'battery' (cd8a4400): fill_kobj_path: path = '/module/battery'
[    1.300005] kobject: 'pnp' (cd8a4540): kobject_add_internal: parent: 'module', set: 'module'
[    1.301337] kobject: 'pnp' (cd8a4540): kobject_uevent_env
[    1.302124] kobject: 'pnp' (cd8a4540): fill_kobj_path: path = '/module/pnp'
[    1.303086] kobject: 'pch_dma' (cd8a4680): kobject_add_internal: parent: 'module', set: 'module'
[    1.304422] kobject: 'pch_dma' (cd8a4680): kobject_uevent_env
[    1.305269] kobject: 'pch_dma' (cd8a4680): fill_kobj_path: path = '/module/pch_dma'
[    1.306491] kobject: 'keyboard' (cd8a47c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.307843] kobject: 'keyboard' (cd8a47c0): kobject_uevent_env
[    1.308679] kobject: 'keyboard' (cd8a47c0): fill_kobj_path: path = '/module/keyboard'
[    1.310007] kobject: 'keyboard' (cd8a47c0): kobject_uevent_env
[    1.310856] kobject: 'keyboard' (cd8a47c0): fill_kobj_path: path = '/module/keyboard'
[    1.312102] kobject: 'vt' (cd8a4900): kobject_add_internal: parent: 'module', set: 'module'
[    1.313405] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.314204] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.315126] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.315923] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.316859] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.317658] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.318595] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.320003] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.320935] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.321730] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.322668] kobject: 'kernel' (cd8a11c0): kobject_uevent_env
[    1.323484] kobject: 'kernel' (cd8a11c0): fill_kobj_path: path = '/module/kernel'
[    1.324703] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.325496] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.326449] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.327248] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.328189] kobject: 'vt' (cd8a4900): kobject_uevent_env
[    1.328981] kobject: 'vt' (cd8a4900): fill_kobj_path: path = '/module/vt'
[    1.330005] kobject: '8250' (cd8a4d40): kobject_add_internal: parent: 'module', set: 'module'
[    1.331303] kobject: '8250' (cd8a4d40): kobject_uevent_env
[    1.332160] kobject: '8250' (cd8a4d40): fill_kobj_path: path = '/module/8250'
[    1.333135] kobject: '8250' (cd8a4d40): kobject_uevent_env
[    1.333964] kobject: '8250' (cd8a4d40): fill_kobj_path: path = '/module/8250'
[    1.334938] kobject: '8250' (cd8a4d40): kobject_uevent_env
[    1.335739] kobject: '8250' (cd8a4d40): fill_kobj_path: path = '/module/8250'
[    1.336695] kobject: 'pch_uart' (cd8a4ec0): kobject_add_internal: parent: 'module', set: 'module'
[    1.338029] kobject: 'pch_uart' (cd8a4ec0): kobject_uevent_env
[    1.338912] kobject: 'pch_uart' (cd8a4ec0): fill_kobj_path: path = '/module/pch_uart'
[    1.340008] kobject: 'pch_uart' (cd8a4ec0): kobject_uevent_env
[    1.340853] kobject: 'pch_uart' (cd8a4ec0): fill_kobj_path: path = '/module/pch_uart'
[    1.342132] kobject: 'i8k' (cd8a1240): kobject_add_internal: parent: 'module', set: 'module'
[    1.343446] kobject: 'i8k' (cd8a1240): kobject_uevent_env
[    1.344265] kobject: 'i8k' (cd8a1240): fill_kobj_path: path = '/module/i8k'
[    1.345211] kobject: 'drm' (cd8a5040): kobject_add_internal: parent: 'module', set: 'module'
[    1.346512] kobject: 'drm' (cd8a5040): kobject_uevent_env
[    1.347324] kobject: 'drm' (cd8a5040): fill_kobj_path: path = '/module/drm'
[    1.348280] kobject: 'drm' (cd8a5040): kobject_uevent_env
[    1.349075] kobject: 'drm' (cd8a5040): fill_kobj_path: path = '/module/drm'
[    1.350007] kobject: 'drm' (cd8a5040): kobject_uevent_env
[    1.350828] kobject: 'drm' (cd8a5040): fill_kobj_path: path = '/module/drm'
[    1.351791] kobject: 'drm' (cd8a5040): kobject_uevent_env
[    1.352594] kobject: 'drm' (cd8a5040): fill_kobj_path: path = '/module/drm'
[    1.353544] kobject: 'devres' (cd8a5200): kobject_add_internal: parent: 'module', set: 'module'
[    1.354867] kobject: 'devres' (cd8a5200): kobject_uevent_env
[    1.355696] kobject: 'devres' (cd8a5200): fill_kobj_path: path = '/module/devres'
[    1.356908] kobject: 'lkdtm' (cd8a5340): kobject_add_internal: parent: 'module', set: 'module'
[    1.358222] kobject: 'lkdtm' (cd8a5340): kobject_uevent_env
[    1.359034] kobject: 'lkdtm' (cd8a5340): fill_kobj_path: path = '/module/lkdtm'
[    1.360006] kobject: 'lkdtm' (cd8a5340): kobject_uevent_env
[    1.360824] kobject: 'lkdtm' (cd8a5340): fill_kobj_path: path = '/module/lkdtm'
[    1.361998] kobject: 'lkdtm' (cd8a5340): kobject_uevent_env
[    1.362823] kobject: 'lkdtm' (cd8a5340): fill_kobj_path: path = '/module/lkdtm'
[    1.364009] kobject: 'lkdtm' (cd8a5340): kobject_uevent_env
[    1.364828] kobject: 'lkdtm' (cd8a5340): fill_kobj_path: path = '/module/lkdtm'
[    1.366044] kobject: 'cs5535_mfgpt' (cd8a5500): kobject_add_internal: parent: 'module', set: 'module'
[    1.367427] kobject: 'cs5535_mfgpt' (cd8a5500): kobject_uevent_env
[    1.368311] kobject: 'cs5535_mfgpt' (cd8a5500): fill_kobj_path: path = '/module/cs5535_mfgpt'
[    1.370005] kobject: 'hpilo' (cd89e900): kobject_uevent_env
[    1.370813] kobject: 'hpilo' (cd89e900): fill_kobj_path: path = '/module/hpilo'
[    1.372011] kobject: 'janz_cmodio' (cd8a5700): kobject_add_internal: parent: 'module', set: 'module'
[    1.373384] kobject: 'janz_cmodio' (cd8a5700): kobject_uevent_env
[    1.374241] kobject: 'janz_cmodio' (cd8a5700): fill_kobj_path: path = '/module/janz_cmodio'
[    1.375529] kobject: 'cs5536' (cd8a5840): kobject_add_internal: parent: 'module', set: 'module'
[    1.376867] kobject: 'cs5536' (cd8a5840): kobject_uevent_env
[    1.377694] kobject: 'cs5536' (cd8a5840): fill_kobj_path: path = '/module/cs5536'
[    1.380005] kobject: 'it821x' (cd8a5980): kobject_add_internal: parent: 'module', set: 'module'
[    1.381326] kobject: 'it821x' (cd8a5980): kobject_uevent_env
[    1.382143] kobject: 'it821x' (cd8a5980): fill_kobj_path: path = '/module/it821x'
[    1.383352] kobject: 'scsi_mod' (cd8a5ac0): kobject_add_internal: parent: 'module', set: 'module'
[    1.384684] kobject: 'scsi_mod' (cd8a5ac0): kobject_uevent_env
[    1.385566] kobject: 'scsi_mod' (cd8a5ac0): fill_kobj_path: path = '/module/scsi_mod'
[    1.386808] kobject: 'scsi_mod' (cd8a5ac0): kobject_uevent_env
[    1.387649] kobject: 'scsi_mod' (cd8a5ac0): fill_kobj_path: path = '/module/scsi_mod'
[    1.390007] kobject: 'scsi_mod' (cd8a5ac0): kobject_uevent_env
[    1.390867] kobject: 'scsi_mod' (cd8a5ac0): fill_kobj_path: path = '/module/scsi_mod'
[    1.392096] kobject: 'scsi_mod' (cd8a5ac0): kobject_uevent_env
[    1.392933] kobject: 'scsi_mod' (cd8a5ac0): fill_kobj_path: path = '/module/scsi_mod'
[    1.394167] kobject: 'scsi_mod' (cd8a5ac0): kobject_uevent_env
[    1.395012] kobject: 'scsi_mod' (cd8a5ac0): fill_kobj_path: path = '/module/scsi_mod'
[    1.396256] kobject: 'scsi_mod' (cd8a5ac0): kobject_uevent_env
[    1.397080] kobject: 'scsi_mod' (cd8a5ac0): fill_kobj_path: path = '/module/scsi_mod'
[    1.398335] kobject: 'scsi_transport_iscsi' (cd89ea80): kobject_uevent_env
[    1.399301] kobject: 'scsi_transport_iscsi' (cd89ea80): fill_kobj_path: path = '/module/scsi_transport_iscsi'
[    1.400006] kobject: 'scsi_transport_iscsi' (cd89ea80): kobject_uevent_env
[    1.400956] kobject: 'scsi_transport_iscsi' (cd89ea80): fill_kobj_path: path = '/module/scsi_transport_iscsi'
[    1.402408] kobject: 'ch' (cd8a5dc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.403705] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.404485] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.405428] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.406220] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.407157] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.407947] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.408887] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.410004] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.410940] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.411743] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.412672] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.413467] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.414412] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.415200] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.416132] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.416930] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.417860] kobject: 'ch' (cd8a5dc0): kobject_uevent_env
[    1.418635] kobject: 'ch' (cd8a5dc0): fill_kobj_path: path = '/module/ch'
[    1.420005] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.420841] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.422045] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.422896] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.424107] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.424932] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.426138] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.426968] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.428176] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.428980] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.430007] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.430816] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.432021] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.432841] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.434047] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.434866] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.436090] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.436905] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.438118] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.438977] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.440011] kobject: 'libata' (cd89eb40): kobject_uevent_env
[    1.440843] kobject: 'libata' (cd89eb40): fill_kobj_path: path = '/module/libata'
[    1.442047] kobject: 'ahci' (cd89ec00): kobject_uevent_env
[    1.442867] kobject: 'ahci' (cd89ec00): fill_kobj_path: path = '/module/ahci'
[    1.443838] kobject: 'libahci' (cd8a66c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.445187] kobject: 'libahci' (cd8a66c0): kobject_uevent_env
[    1.446016] kobject: 'libahci' (cd8a66c0): fill_kobj_path: path = '/module/libahci'
[    1.447285] kobject: 'libahci' (cd8a66c0): kobject_uevent_env
[    1.448126] kobject: 'libahci' (cd8a66c0): fill_kobj_path: path = '/module/libahci'
[    1.449363] kobject: 'libahci' (cd8a66c0): kobject_uevent_env
[    1.450003] kobject: 'libahci' (cd8a66c0): fill_kobj_path: path = '/module/libahci'
[    1.451240] kobject: 'spi_topcliff_pch' (cd8a6840): kobject_add_internal: parent: 'module', set: 'module'
[    1.452647] kobject: 'spi_topcliff_pch' (cd8a6840): kobject_uevent_env
[    1.453555] kobject: 'spi_topcliff_pch' (cd8a6840): fill_kobj_path: path = '/module/spi_topcliff_pch'
[    1.454941] kobject: 'smsc75xx' (cd8a6980): kobject_add_internal: parent: 'module', set: 'module'
[    1.456280] kobject: 'smsc75xx' (cd8a6980): kobject_uevent_env
[    1.457112] kobject: 'smsc75xx' (cd8a6980): fill_kobj_path: path = '/module/smsc75xx'
[    1.458348] kobject: 'smsc95xx' (cd8a6ac0): kobject_add_internal: parent: 'module', set: 'module'
[    1.460004] kobject: 'smsc95xx' (cd8a6ac0): kobject_uevent_env
[    1.460857] kobject: 'smsc95xx' (cd8a6ac0): fill_kobj_path: path = '/module/smsc95xx'
[    1.462090] kobject: 'pcmcia_core' (cd8a6c00): kobject_add_internal: parent: 'module', set: 'module'
[    1.463465] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.464326] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.465633] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.466497] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.467805] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.468671] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.470007] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.470885] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.472168] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.473045] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.474341] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.475200] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.476486] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.477344] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.478657] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.479533] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.480010] kobject: 'pcmcia_core' (cd8a6c00): kobject_uevent_env
[    1.480874] kobject: 'pcmcia_core' (cd8a6c00): fill_kobj_path: path = '/module/pcmcia_core'
[    1.482188] kobject: 'pcmcia' (cd8a6f40): kobject_add_internal: parent: 'module', set: 'module'
[    1.483510] kobject: 'pcmcia' (cd8a6f40): kobject_uevent_env
[    1.484332] kobject: 'pcmcia' (cd8a6f40): fill_kobj_path: path = '/module/pcmcia'
[    1.485539] kobject: 'pcmcia' (cd8a6f40): kobject_uevent_env
[    1.486368] kobject: 'pcmcia' (cd8a6f40): fill_kobj_path: path = '/module/pcmcia'
[    1.487565] kobject: 'pcmcia_rsrc' (cd8a5e80): kobject_add_internal: parent: 'module', set: 'module'
[    1.490004] kobject: 'pcmcia_rsrc' (cd8a5e80): kobject_uevent_env
[    1.490875] kobject: 'pcmcia_rsrc' (cd8a5e80): fill_kobj_path: path = '/module/pcmcia_rsrc'
[    1.492175] kobject: 'pd6729' (cd8a7000): kobject_add_internal: parent: 'module', set: 'module'
[    1.493509] kobject: 'pd6729' (cd8a7000): kobject_uevent_env
[    1.494384] kobject: 'pd6729' (cd8a7000): fill_kobj_path: path = '/module/pd6729'
[    1.495601] kobject: 'kernel' (cd8a11c0): kobject_uevent_env
[    1.496420] kobject: 'kernel' (cd8a11c0): fill_kobj_path: path = '/module/kernel'
[    1.497647] kobject: 'usbcore' (cd8a72c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.498986] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.499832] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.500008] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.500934] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.502276] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.503102] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.504344] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.505186] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.506403] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.510004] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.511237] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.512079] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.513517] kobject: 'usbcore' (cd8a72c0): kobject_uevent_env
[    1.514357] kobject: 'usbcore' (cd8a72c0): fill_kobj_path: path = '/module/usbcore'
[    1.515626] kobject: 'uhci_hcd' (cd8a7540): kobject_add_internal: parent: 'module', set: 'module'
[    1.516971] kobject: 'uhci_hcd' (cd8a7540): kobject_uevent_env
[    1.517792] kobject: 'uhci_hcd' (cd8a7540): fill_kobj_path: path = '/module/uhci_hcd'
[    1.519063] kobject: 'usblp' (cd8a7680): kobject_add_internal: parent: 'module', set: 'module'
[    1.520005] kobject: 'usblp' (cd8a7680): kobject_uevent_env
[    1.520841] kobject: 'usblp' (cd8a7680): fill_kobj_path: path = '/module/usblp'
[    1.522032] kobject: 'adutux' (cd8a77c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.523508] kobject: 'adutux' (cd8a77c0): kobject_uevent_env
[    1.524332] kobject: 'adutux' (cd8a77c0): fill_kobj_path: path = '/module/adutux'
[    1.525573] kobject: 'ldusb' (cd89f140): kobject_uevent_env
[    1.526392] kobject: 'ldusb' (cd89f140): fill_kobj_path: path = '/module/ldusb'
[    1.527618] kobject: 'usbtest' (cd8a79c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.528964] kobject: 'usbtest' (cd8a79c0): kobject_uevent_env
[    1.530004] kobject: 'usbtest' (cd8a79c0): fill_kobj_path: path = '/module/usbtest'
[    1.531242] kobject: 'usbatm' (cd89f200): kobject_uevent_env
[    1.532062] kobject: 'usbatm' (cd89f200): fill_kobj_path: path = '/module/usbatm'
[    1.533554] kobject: 'usbatm' (cd89f200): kobject_uevent_env
[    1.534396] kobject: 'usbatm' (cd89f200): fill_kobj_path: path = '/module/usbatm'
[    1.535604] kobject: 'usbatm' (cd89f200): kobject_uevent_env
[    1.536431] kobject: 'usbatm' (cd89f200): fill_kobj_path: path = '/module/usbatm'
[    1.537658] kobject: 'usbatm' (cd89f200): kobject_uevent_env
[    1.538525] kobject: 'usbatm' (cd89f200): fill_kobj_path: path = '/module/usbatm'
[    1.540007] kobject: 'net2280' (cd8a7c40): kobject_add_internal: parent: 'module', set: 'module'
[    1.541359] kobject: 'net2280' (cd8a7c40): kobject_uevent_env
[    1.542200] kobject: 'net2280' (cd8a7c40): fill_kobj_path: path = '/module/net2280'
[    1.543597] kobject: 'net2280' (cd8a7c40): kobject_uevent_env
[    1.544436] kobject: 'net2280' (cd8a7c40): fill_kobj_path: path = '/module/net2280'
[    1.545683] kobject: 'net2280' (cd8a7c40): kobject_uevent_env
[    1.546538] kobject: 'net2280' (cd8a7c40): fill_kobj_path: path = '/module/net2280'
[    1.547819] kobject: 'net2280' (cd8a7c40): kobject_uevent_env
[    1.548664] kobject: 'net2280' (cd8a7c40): fill_kobj_path: path = '/module/net2280'
[    1.550013] kobject: 'g_mass_storage' (cd8a7e00): kobject_add_internal: parent: 'module', set: 'module'
[    1.551429] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.552321] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.553966] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.554872] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.556228] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.557116] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.558451] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.559346] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.560009] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.560927] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.562271] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.563484] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.564843] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.565730] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.567084] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.567983] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.570011] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.570891] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.572263] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.573262] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.574672] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.575576] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.576940] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.577832] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.579208] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.580004] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.581360] kobject: 'g_mass_storage' (cd8a7e00): kobject_uevent_env
[    1.582261] kobject: 'g_mass_storage' (cd8a7e00): fill_kobj_path: path = '/module/g_mass_storage'
[    1.583754] kobject: 'i8042' (cd8a93c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.585051] kobject: 'i8042' (cd8a93c0): kobject_uevent_env
[    1.585844] kobject: 'i8042' (cd8a93c0): fill_kobj_path: path = '/module/i8042'
[    1.587032] kobject: 'mousedev' (cd8a9500): kobject_add_internal: parent: 'module', set: 'module'
[    1.588396] kobject: 'mousedev' (cd8a9500): kobject_uevent_env
[    1.589248] kobject: 'mousedev' (cd8a9500): fill_kobj_path: path = '/module/mousedev'
[    1.590008] kobject: 'mousedev' (cd8a9500): kobject_uevent_env
[    1.590861] kobject: 'mousedev' (cd8a9500): fill_kobj_path: path = '/module/mousedev'
[    1.592105] kobject: 'mousedev' (cd8a9500): kobject_uevent_env
[    1.593090] kobject: 'mousedev' (cd8a9500): fill_kobj_path: path = '/module/mousedev'
[    1.594336] kobject: 'appletouch' (cd8a9680): kobject_add_internal: parent: 'module', set: 'module'
[    1.595701] kobject: 'appletouch' (cd8a9680): kobject_uevent_env
[    1.596574] kobject: 'appletouch' (cd8a9680): fill_kobj_path: path = '/module/appletouch'
[    1.597853] kobject: 'appletouch' (cd8a9680): kobject_uevent_env
[    1.598724] kobject: 'appletouch' (cd8a9680): fill_kobj_path: path = '/module/appletouch'
[    1.600006] kobject: 'bcm5974' (cd8a97c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.601352] kobject: 'bcm5974' (cd8a97c0): kobject_uevent_env
[    1.602165] kobject: 'bcm5974' (cd8a97c0): fill_kobj_path: path = '/module/bcm5974'
[    1.603626] kobject: 'psmouse' (cd8a9900): kobject_add_internal: parent: 'module', set: 'module'
[    1.604964] kobject: 'psmouse' (cd8a9900): kobject_uevent_env
[    1.605795] kobject: 'psmouse' (cd8a9900): fill_kobj_path: path = '/module/psmouse'
[    1.607026] kobject: 'psmouse' (cd8a9900): kobject_uevent_env
[    1.607866] kobject: 'psmouse' (cd8a9900): fill_kobj_path: path = '/module/psmouse'
[    1.610004] kobject: 'psmouse' (cd8a9900): kobject_uevent_env
[    1.610842] kobject: 'psmouse' (cd8a9900): fill_kobj_path: path = '/module/psmouse'
[    1.612073] kobject: 'psmouse' (cd8a9900): kobject_uevent_env
[    1.612894] kobject: 'psmouse' (cd8a9900): fill_kobj_path: path = '/module/psmouse'
[    1.614354] kobject: 'psmouse' (cd8a9900): kobject_uevent_env
[    1.615185] kobject: 'psmouse' (cd8a9900): fill_kobj_path: path = '/module/psmouse'
[    1.616410] kobject: 'psmouse' (cd8a9900): kobject_uevent_env
[    1.617248] kobject: 'psmouse' (cd8a9900): fill_kobj_path: path = '/module/psmouse'
[    1.618500] kobject: 'usbtouchscreen' (cd8a9b40): kobject_add_internal: parent: 'module', set: 'module'
[    1.619887] kobject: 'usbtouchscreen' (cd8a9b40): kobject_uevent_env
[    1.620003] kobject: 'usbtouchscreen' (cd8a9b40): fill_kobj_path: path = '/module/usbtouchscreen'
[    1.621344] kobject: 'usbtouchscreen' (cd8a9b40): kobject_uevent_env
[    1.622235] kobject: 'usbtouchscreen' (cd8a9b40): fill_kobj_path: path = '/module/usbtouchscreen'
[    1.623760] kobject: 'ati_remote2' (cd89f500): kobject_uevent_env
[    1.624631] kobject: 'ati_remote2' (cd89f500): fill_kobj_path: path = '/module/ati_remote2'
[    1.625925] kobject: 'ati_remote2' (cd89f500): kobject_uevent_env
[    1.626782] kobject: 'ati_remote2' (cd89f500): fill_kobj_path: path = '/module/ati_remote2'
[    1.628083] kobject: 'i2c_algo_bit' (cd8a9d40): kobject_add_internal: parent: 'module', set: 'module'
[    1.630005] kobject: 'i2c_algo_bit' (cd8a9d40): kobject_uevent_env
[    1.630880] kobject: 'i2c_algo_bit' (cd8a9d40): fill_kobj_path: path = '/module/i2c_algo_bit'
[    1.632200] kobject: 'i2c_algo_pcf' (cd8a9e80): kobject_add_internal: parent: 'module', set: 'module'
[    1.635732] kobject: 'i2c_algo_pcf' (cd8a9e80): kobject_uevent_env
[    1.636599] kobject: 'i2c_algo_pcf' (cd8a9e80): fill_kobj_path: path = '/module/i2c_algo_pcf'
[    1.637888] kobject: 'i2c_eg20t' (cd8a9fc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.639302] kobject: 'i2c_eg20t' (cd8a9fc0): kobject_uevent_env
[    1.640003] kobject: 'i2c_eg20t' (cd8a9fc0): fill_kobj_path: path = '/module/i2c_eg20t'
[    1.641280] kobject: 'i2c_eg20t' (cd8a9fc0): kobject_uevent_env
[    1.642129] kobject: 'i2c_eg20t' (cd8a9fc0): fill_kobj_path: path = '/module/i2c_eg20t'
[    1.643531] kobject: 'i2c_intel_mid' (cd89f980): kobject_uevent_env
[    1.644414] kobject: 'i2c_intel_mid' (cd89f980): fill_kobj_path: path = '/module/i2c_intel_mid'
[    1.645771] kobject: 'k10temp' (cd8a7fc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.647111] kobject: 'k10temp' (cd8a7fc0): kobject_uevent_env
[    1.647956] kobject: 'k10temp' (cd8a7fc0): fill_kobj_path: path = '/module/k10temp'
[    1.649175] kobject: 'raid10' (cd8aa080): kobject_add_internal: parent: 'module', set: 'module'
[    1.650005] kobject: 'raid10' (cd8aa080): kobject_uevent_env
[    1.650826] kobject: 'raid10' (cd8aa080): fill_kobj_path: path = '/module/raid10'
[    1.652061] kobject: 'md_mod' (cd8aa1c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.653638] kobject: 'md_mod' (cd8aa1c0): kobject_uevent_env
[    1.654462] kobject: 'md_mod' (cd8aa1c0): fill_kobj_path: path = '/module/md_mod'
[    1.655664] kobject: 'md_mod' (cd8aa1c0): kobject_uevent_env
[    1.656484] kobject: 'md_mod' (cd8aa1c0): fill_kobj_path: path = '/module/md_mod'
[    1.657700] kobject: 'md_mod' (cd8aa1c0): kobject_uevent_env
[    1.658538] kobject: 'md_mod' (cd8aa1c0): fill_kobj_path: path = '/module/md_mod'
[    1.660005] kobject: 'hci_uart' (cd89fbc0): kobject_uevent_env
[    1.660857] kobject: 'hci_uart' (cd89fbc0): fill_kobj_path: path = '/module/hci_uart'
[    1.662083] kobject: 'hci_uart' (cd89fbc0): kobject_uevent_env
[    1.663071] kobject: 'hci_uart' (cd89fbc0): fill_kobj_path: path = '/module/hci_uart'
[    1.664324] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.665153] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.666350] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.667171] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.668357] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.669161] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.670007] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.670842] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.672023] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.673062] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.674257] kobject: 'btusb' (cd89fc80): kobject_uevent_env
[    1.675070] kobject: 'btusb' (cd89fc80): fill_kobj_path: path = '/module/btusb'
[    1.676265] kobject: 'cpuidle' (cd8aa5c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.677599] kobject: 'cpuidle' (cd8aa5c0): kobject_uevent_env
[    1.678421] kobject: 'cpuidle' (cd8aa5c0): fill_kobj_path: path = '/module/cpuidle'
[    1.680006] kobject: 'mmc_core' (cd8aa700): kobject_add_internal: parent: 'module', set: 'module'
[    1.681369] kobject: 'mmc_core' (cd8aa700): kobject_uevent_env
[    1.682206] kobject: 'mmc_core' (cd8aa700): fill_kobj_path: path = '/module/mmc_core'
[    1.683596] kobject: 'mmcblk' (cd8aa840): kobject_add_internal: parent: 'module', set: 'module'
[    1.684928] kobject: 'mmcblk' (cd8aa840): kobject_uevent_env
[    1.685747] kobject: 'mmcblk' (cd8aa840): fill_kobj_path: path = '/module/mmcblk'
[    1.686972] kobject: 'sdhci' (cd8aa980): kobject_add_internal: parent: 'module', set: 'module'
[    1.688290] kobject: 'sdhci' (cd8aa980): kobject_uevent_env
[    1.689098] kobject: 'sdhci' (cd8aa980): fill_kobj_path: path = '/module/sdhci'
[    1.690007] kobject: 'sdhci' (cd8aa980): kobject_uevent_env
[    1.690821] kobject: 'sdhci' (cd8aa980): fill_kobj_path: path = '/module/sdhci'
[    1.692082] kobject: 'vub300' (cd8aaac0): kobject_add_internal: parent: 'module', set: 'module'
[    1.693657] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.694482] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.695691] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.696519] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.697730] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.698564] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.700008] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.700826] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.702065] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.703059] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.704280] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.705101] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.706320] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.707140] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.708359] kobject: 'vub300' (cd8aaac0): kobject_uevent_env
[    1.709176] kobject: 'vub300' (cd8aaac0): fill_kobj_path: path = '/module/vub300'
[    1.710005] kobject: 'dell_rbu' (cd89fe00): kobject_uevent_env
[    1.710865] kobject: 'dell_rbu' (cd89fe00): fill_kobj_path: path = '/module/dell_rbu'
[    1.712102] kobject: 'hifn_795x' (cd8aae80): kobject_add_internal: parent: 'module', set: 'module'
[    1.713744] kobject: 'hifn_795x' (cd8aae80): kobject_uevent_env
[    1.714604] kobject: 'hifn_795x' (cd8aae80): fill_kobj_path: path = '/module/hifn_795x'
[    1.715854] kobject: 'hid' (cd8aafc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.717157] kobject: 'hid' (cd8aafc0): kobject_uevent_env
[    1.717949] kobject: 'hid' (cd8aafc0): fill_kobj_path: path = '/module/hid'
[    1.720008] kobject: 'hid' (cd8aafc0): kobject_uevent_env
[    1.720825] kobject: 'hid' (cd8aafc0): fill_kobj_path: path = '/module/hid'
[    1.721774] kobject: 'oprofile' (cd8ab100): kobject_add_internal: parent: 'module', set: 'module'
[    1.723120] kobject: 'oprofile' (cd8ab100): kobject_uevent_env
[    1.724113] kobject: 'oprofile' (cd8ab100): fill_kobj_path: path = '/module/oprofile'
[    1.725376] kobject: 'sch_htb' (cd8ab240): kobject_add_internal: parent: 'module', set: 'module'
[    1.726722] kobject: 'sch_htb' (cd8ab240): kobject_uevent_env
[    1.727558] kobject: 'sch_htb' (cd8ab240): fill_kobj_path: path = '/module/sch_htb'
[    1.728774] kobject: 'bluetooth' (cd8a1100): kobject_uevent_env
[    1.729619] kobject: 'bluetooth' (cd8a1100): fill_kobj_path: path = '/module/bluetooth'
[    1.730007] kobject: 'bluetooth' (cd8a1100): kobject_uevent_env
[    1.730851] kobject: 'bluetooth' (cd8a1100): fill_kobj_path: path = '/module/bluetooth'
[    1.732105] kobject: 'bluetooth' (cd8a1100): kobject_uevent_env
[    1.733114] kobject: 'bluetooth' (cd8a1100): fill_kobj_path: path = '/module/bluetooth'
[    1.734395] kobject: 'decnet' (cd8ab480): kobject_add_internal: parent: 'module', set: 'module'
[    1.735714] kobject: 'decnet' (cd8ab480): kobject_uevent_env
[    1.736531] kobject: 'decnet' (cd8ab480): fill_kobj_path: path = '/module/decnet'
[    1.737810] kobject: 'wimax' (cd8ab5c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.740005] kobject: 'wimax' (cd8ab5c0): kobject_uevent_env
[    1.740821] kobject: 'wimax' (cd8ab5c0): fill_kobj_path: path = '/module/wimax'
[    1.742055] device: 'default': device_add
[    1.742714] kobject: 'bdi' (cd8ab700): kobject_add_internal: parent: 'virtual', set: '(null)'
[    1.744242] kobject: 'default' (cd8ac608): kobject_add_internal: parent: 'bdi', set: 'devices'
[    1.745586] PM: Adding info for No Bus:default
[    1.746298] kobject: 'default' (cd8ac608): kobject_uevent_env
[    1.747135] kobject: 'default' (cd8ac608): fill_kobj_path: path = '/devices/virtual/bdi/default'
[    1.748521] debugfs: creating file 'default'
[    1.748521] debugfs: creating file 'stats'
[    1.750049] bio: create slab <bio-0> at 0
[    1.750791] fsnotify_create_event: event=cd8abcc0 to_tell=  (null) mask=4000 data=  (null) data_type=0
[    1.752188] device class 'block': registering
[    1.752879] kobject: 'block' (cd8a240c): kobject_add_internal: parent: 'class', set: 'class'
[    1.754475] kobject: 'block' (cd8a240c): kobject_uevent_env
[    1.755303] kobject: 'block' (cd8a240c): fill_kobj_path: path = '/class/block'
[    1.756506] kobject: 'block' (cd8abdc0): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    1.920009] raid6: mmxx1     4995 MB/s
[    2.090015] raid6: mmxx2     5329 MB/s
[    2.260028] raid6: sse1x1    2785 MB/s
[    2.430013] raid6: sse1x2    3325 MB/s
[    2.600016] raid6: sse2x1    5348 MB/s
[    2.770012] raid6: sse2x2    6791 MB/s
[    2.774355] raid6: using algorithm sse2x2 (6791 MB/s)
[    2.775601] raid6: using intx1 recovery algorithm
[    2.776779] debugfs: creating file 'gpio'
[    2.777873] bus: 'spi': add driver 74x164
[    2.778931] kobject: '74x164' (cd89d9c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    2.780011] kobject: '74x164' (cd89d9c0): kobject_uevent_env
[    2.781356] kobject: '74x164' (cd89d9c0): fill_kobj_path: path = '/bus/spi/drivers/74x164'
[    2.783489] bus: 'i2c': add driver max7300
[    2.784588] kobject: 'max7300' (cd89da20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    2.786812] kobject: 'max7300' (cd89da20): kobject_uevent_env
[    2.788169] kobject: 'max7300' (cd89da20): fill_kobj_path: path = '/bus/i2c/drivers/max7300'
[    2.790006] i2c-core: driver [max7300] registered
[    2.791223] bus: 'i2c': add driver pcf857x
[    2.792296] kobject: 'pcf857x' (cd89da80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    2.794512] kobject: 'pcf857x' (cd89da80): kobject_uevent_env
[    2.795878] kobject: 'pcf857x' (cd89da80): fill_kobj_path: path = '/bus/i2c/drivers/pcf857x'
[    2.798026] i2c-core: driver [pcf857x] registered
[    2.800005] bus: 'platform': add driver tc3589x-gpio
[    2.801250] kobject: 'tc3589x-gpio' (cd89dae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    2.803581] kobject: 'tc3589x-gpio' (cd89dae0): kobject_uevent_env
[    2.805061] kobject: 'tc3589x-gpio' (cd89dae0): fill_kobj_path: path = '/bus/platform/drivers/tc3589x-gpio'
[    2.807394] bus: 'platform': add driver tps65912-gpio
[    2.808636] kobject: 'tps65912-gpio' (cd89db40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    2.810010] kobject: 'tps65912-gpio' (cd89db40): kobject_uevent_env
[    2.811411] kobject: 'tps65912-gpio' (cd89db40): fill_kobj_path: path = '/bus/platform/drivers/tps65912-gpio'
[    2.813836] kobject: 'slots' (cd8ae34c): kobject_add_internal: parent: 'pci', set: '<NULL>'
[    2.815978] kobject: 'slots' (cd8ae34c): kobject_uevent_env
[    2.817247] kobject: 'slots' (cd8ae34c): kobject_uevent_env: filter function caused the event to drop!
[    2.820011] device class 'graphics': registering
[    2.821194] kobject: 'graphics' (cd8a250c): kobject_add_internal: parent: 'class', set: 'class'
[    2.823382] kobject: 'graphics' (cd8a250c): kobject_uevent_env
[    2.824728] kobject: 'graphics' (cd8a250c): fill_kobj_path: path = '/class/graphics'
[    2.826781] kobject: 'acpi' (cd8ae480): kobject_add_internal: parent: 'firmware', set: '<NULL>'
[    2.830016] ACPI: Added _OSI(Module Device)
[    2.831142] ACPI: Added _OSI(Processor Device)
[    2.832276] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.833440] ACPI: Added _OSI(Processor Aggregator Device)
[    2.835369] ACPI: EC: Look up EC in DSDT
[    2.838112] kobject: 'tables' (cd8aec40): kobject_add_internal: parent: 'acpi', set: '<NULL>'
[    2.840007] kobject: 'dynamic' (cd8aecc0): kobject_add_internal: parent: 'tables', set: '<NULL>'
[    2.842205] kobject: 'tables' (cd8aec40): kobject_uevent_env
[    2.843546] kobject: 'tables' (cd8aec40): kobject_uevent_env: attempted to send uevent without kset!
[    2.845808] kobject: 'dynamic' (cd8aecc0): kobject_uevent_env
[    2.847194] kobject: 'dynamic' (cd8aecc0): kobject_uevent_env: attempted to send uevent without kset!
[    2.850037] ACPI: Interpreter enabled
[    2.851091] ACPI: (supports S0 S3 S5)
[    2.852388] ACPI: Using IOAPIC for interrupt routing
[    2.853657] kobject: 'acpi' (cd8a270c): kobject_add_internal: parent: 'bus', set: 'bus'
[    2.855684] kobject: 'acpi' (cd8a270c): kobject_uevent_env
[    2.857012] kobject: 'acpi' (cd8a270c): fill_kobj_path: path = '/bus/acpi'
[    2.858485] kobject: 'devices' (cd8b118c): kobject_add_internal: parent: 'acpi', set: '<NULL>'
[    2.860005] kobject: 'devices' (cd8b118c): kobject_uevent_env
[    2.861334] kobject: 'devices' (cd8b118c): kobject_uevent_env: filter function caused the event to drop!
[    2.863638] kobject: 'drivers' (cd8b120c): kobject_add_internal: parent: 'acpi', set: '<NULL>'
[    2.865767] kobject: 'drivers' (cd8b120c): kobject_uevent_env
[    2.867075] kobject: 'drivers' (cd8b120c): kobject_uevent_env: filter function caused the event to drop!
[    2.870006] bus: 'acpi': registered
[    2.870993] bus: 'acpi': add driver power
[    2.872063] kobject: 'power' (cd89dd80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    2.874247] kobject: 'power' (cd89dd80): kobject_uevent_env
[    2.875583] kobject: 'power' (cd89dd80): fill_kobj_path: path = '/bus/acpi/drivers/power'
[    2.877766] device: 'LNXSYSTM:00': device_add
[    2.878931] kobject: 'LNXSYSTM:00' (cd898e24): kobject_add_internal: parent: 'devices', set: 'devices'
[    2.880008] bus: 'acpi': add device LNXSYSTM:00
[    2.881176] PM: Adding info for acpi:LNXSYSTM:00
[    2.882379] kobject: 'LNXSYSTM:00' (cd898e24): kobject_uevent_env
[    2.883814] kobject: 'LNXSYSTM:00' (cd898e24): fill_kobj_path: path = '/devices/LNXSYSTM:00'
[    2.885979] device: 'device:00': device_add
[    2.887092] kobject: 'device:00' (cd899624): kobject_add_internal: parent: 'LNXSYSTM:00', set: 'devices'
[    2.890007] bus: 'acpi': add device device:00
[    2.891155] PM: Adding info for acpi:device:00
[    2.892317] kobject: 'device:00' (cd899624): kobject_uevent_env
[    2.893707] kobject: 'device:00' (cd899624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00'
[    2.895996] device: 'PNP0A03:00': device_add
[    2.897103] kobject: 'PNP0A03:00' (cd899a24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    2.900007] bus: 'acpi': add device PNP0A03:00
[    2.901138] PM: Adding info for acpi:PNP0A03:00
[    2.902295] kobject: 'PNP0A03:00' (cd899a24): kobject_uevent_env
[    2.903656] kobject: 'PNP0A03:00' (cd899a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00'
[    2.906240] device: 'device:01': device_add
[    2.907378] kobject: 'device:01' (cd899e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    2.909648] bus: 'acpi': add device device:01
[    2.910010] PM: Adding info for acpi:device:01
[    2.911115] kobject: 'device:01' (cd899e24): kobject_uevent_env
[    2.912526] kobject: 'device:01' (cd899e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01'
[    2.915117] device: 'device:02': device_add
[    2.916224] kobject: 'device:02' (cd89a224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    2.918505] bus: 'acpi': add device device:02
[    2.920010] PM: Adding info for acpi:device:02
[    2.921153] kobject: 'device:02' (cd89a224): kobject_uevent_env
[    2.922524] kobject: 'device:02' (cd89a224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02'
[    2.925062] device: 'PNP0B00:00': device_add
[    2.926184] kobject: 'PNP0B00:00' (cd89a624): kobject_add_internal: parent: 'device:02', set: 'devices'
[    2.928488] bus: 'acpi': add device PNP0B00:00
[    2.930010] PM: Adding info for acpi:PNP0B00:00
[    2.931188] kobject: 'PNP0B00:00' (cd89a624): kobject_uevent_env
[    2.932551] kobject: 'PNP0B00:00' (cd89a624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0B00:00'
[    2.935288] device: 'PNP0303:00': device_add
[    2.936421] kobject: 'PNP0303:00' (cd89aa24): kobject_add_internal: parent: 'device:02', set: 'devices'
[    2.938698] bus: 'acpi': add device PNP0303:00
[    2.940019] PM: Adding info for acpi:PNP0303:00
[    2.941205] kobject: 'PNP0303:00' (cd89aa24): kobject_uevent_env
[    2.942614] kobject: 'PNP0303:00' (cd89aa24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0303:00'
[    2.945417] device: 'PNP0F13:00': device_add
[    2.946543] kobject: 'PNP0F13:00' (cd89ae24): kobject_add_internal: parent: 'device:02', set: 'devices'
[    2.948810] bus: 'acpi': add device PNP0F13:00
[    2.950010] PM: Adding info for acpi:PNP0F13:00
[    2.951185] kobject: 'PNP0F13:00' (cd89ae24): kobject_uevent_env
[    2.952561] kobject: 'PNP0F13:00' (cd89ae24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0F13:00'
[    2.955298] device: 'PNP0700:00': device_add
[    2.956448] kobject: 'PNP0700:00' (cd89b224): kobject_add_internal: parent: 'device:02', set: 'devices'
[    2.958711] bus: 'acpi': add device PNP0700:00
[    2.959858] PM: Adding info for acpi:PNP0700:00
[    2.960004] kobject: 'PNP0700:00' (cd89b224): kobject_uevent_env
[    2.961447] kobject: 'PNP0700:00' (cd89b224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0700:00'
[    2.964194] device: 'PNP0400:00': device_add
[    2.965239] kobject: 'PNP0400:00' (cd89b624): kobject_add_internal: parent: 'device:02', set: 'devices'
[    2.967537] bus: 'acpi': add device PNP0400:00
[    2.968662] PM: Adding info for acpi:PNP0400:00
[    2.970004] kobject: 'PNP0400:00' (cd89b624): kobject_uevent_env
[    2.971441] kobject: 'PNP0400:00' (cd89b624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0400:00'
[    2.974345] device: 'PNP0501:00': device_add
[    2.975482] kobject: 'PNP0501:00' (cd89ba24): kobject_add_internal: parent: 'device:02', set: 'devices'
[    2.977771] bus: 'acpi': add device PNP0501:00
[    2.978905] PM: Adding info for acpi:PNP0501:00
[    2.980005] kobject: 'PNP0501:00' (cd89ba24): kobject_uevent_env
[    2.981415] kobject: 'PNP0501:00' (cd89ba24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0501:00'
[    2.984248] device: 'device:03': device_add
[    2.985382] kobject: 'device:03' (cd89be24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    2.987670] bus: 'acpi': add device device:03
[    2.988813] PM: Adding info for acpi:device:03
[    2.990005] kobject: 'device:03' (cd89be24): kobject_uevent_env
[    2.991409] kobject: 'device:03' (cd89be24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:03'
[    2.993968] device: 'device:04': device_add
[    2.995049] kobject: 'device:04' (cd8e4224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.000007] bus: 'acpi': add device device:04
[    3.001159] PM: Adding info for acpi:device:04
[    3.002317] kobject: 'device:04' (cd8e4224): kobject_uevent_env
[    3.003774] kobject: 'device:04' (cd8e4224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:04'
[    3.006299] device: 'device:05': device_add
[    3.007420] kobject: 'device:05' (cd8e4624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.010008] bus: 'acpi': add device device:05
[    3.011176] PM: Adding info for acpi:device:05
[    3.012314] kobject: 'device:05' (cd8e4624): kobject_uevent_env
[    3.013703] kobject: 'device:05' (cd8e4624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:05'
[    3.016262] device: 'device:06': device_add
[    3.017390] kobject: 'device:06' (cd8e4a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.020006] bus: 'acpi': add device device:06
[    3.021161] PM: Adding info for acpi:device:06
[    3.022304] kobject: 'device:06' (cd8e4a24): kobject_uevent_env
[    3.023706] kobject: 'device:06' (cd8e4a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:06'
[    3.026248] device: 'device:07': device_add
[    3.027377] kobject: 'device:07' (cd8e4e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.030007] bus: 'acpi': add device device:07
[    3.031159] PM: Adding info for acpi:device:07
[    3.032281] kobject: 'device:07' (cd8e4e24): kobject_uevent_env
[    3.033667] kobject: 'device:07' (cd8e4e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:07'
[    3.036221] device: 'device:08': device_add
[    3.037372] kobject: 'device:08' (cd8e5224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.040007] bus: 'acpi': add device device:08
[    3.041121] PM: Adding info for acpi:device:08
[    3.042270] kobject: 'device:08' (cd8e5224): kobject_uevent_env
[    3.043640] kobject: 'device:08' (cd8e5224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:08'
[    3.046213] device: 'device:09': device_add
[    3.047329] kobject: 'device:09' (cd8e5624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.050007] bus: 'acpi': add device device:09
[    3.051150] PM: Adding info for acpi:device:09
[    3.052306] kobject: 'device:09' (cd8e5624): kobject_uevent_env
[    3.053691] kobject: 'device:09' (cd8e5624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:09'
[    3.056304] device: 'device:0a': device_add
[    3.057437] kobject: 'device:0a' (cd8e5a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.059766] bus: 'acpi': add device device:0a
[    3.060011] PM: Adding info for acpi:device:0a
[    3.061178] kobject: 'device:0a' (cd8e5a24): kobject_uevent_env
[    3.062591] kobject: 'device:0a' (cd8e5a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0a'
[    3.065184] device: 'device:0b': device_add
[    3.066274] kobject: 'device:0b' (cd8e5e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.068569] bus: 'acpi': add device device:0b
[    3.070011] PM: Adding info for acpi:device:0b
[    3.071187] kobject: 'device:0b' (cd8e5e24): kobject_uevent_env
[    3.072576] kobject: 'device:0b' (cd8e5e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0b'
[    3.075120] device: 'device:0c': device_add
[    3.076183] kobject: 'device:0c' (cd8e6224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.078477] bus: 'acpi': add device device:0c
[    3.080010] PM: Adding info for acpi:device:0c
[    3.081171] kobject: 'device:0c' (cd8e6224): kobject_uevent_env
[    3.082518] kobject: 'device:0c' (cd8e6224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0c'
[    3.085088] device: 'device:0d': device_add
[    3.086207] kobject: 'device:0d' (cd8e6624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.088553] bus: 'acpi': add device device:0d
[    3.090011] PM: Adding info for acpi:device:0d
[    3.091165] kobject: 'device:0d' (cd8e6624): kobject_uevent_env
[    3.092581] kobject: 'device:0d' (cd8e6624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0d'
[    3.095115] device: 'device:0e': device_add
[    3.096239] kobject: 'device:0e' (cd8e6a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.098572] bus: 'acpi': add device device:0e
[    3.099694] PM: Adding info for acpi:device:0e
[    3.100004] kobject: 'device:0e' (cd8e6a24): kobject_uevent_env
[    3.101390] kobject: 'device:0e' (cd8e6a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0e'
[    3.103991] device: 'device:0f': device_add
[    3.105107] kobject: 'device:0f' (cd8e6e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.107406] bus: 'acpi': add device device:0f
[    3.108554] PM: Adding info for acpi:device:0f
[    3.110004] kobject: 'device:0f' (cd8e6e24): kobject_uevent_env
[    3.111407] kobject: 'device:0f' (cd8e6e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0f'
[    3.113983] device: 'device:10': device_add
[    3.115081] kobject: 'device:10' (cd8e7224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.117417] bus: 'acpi': add device device:10
[    3.118560] PM: Adding info for acpi:device:10
[    3.120004] kobject: 'device:10' (cd8e7224): kobject_uevent_env
[    3.121381] kobject: 'device:10' (cd8e7224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:10'
[    3.123934] device: 'device:11': device_add
[    3.125057] kobject: 'device:11' (cd8e7624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.127368] bus: 'acpi': add device device:11
[    3.128549] PM: Adding info for acpi:device:11
[    3.130004] kobject: 'device:11' (cd8e7624): kobject_uevent_env
[    3.131379] kobject: 'device:11' (cd8e7624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:11'
[    3.133947] device: 'device:12': device_add
[    3.135039] kobject: 'device:12' (cd8e7a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.137331] bus: 'acpi': add device device:12
[    3.138451] PM: Adding info for acpi:device:12
[    3.139583] kobject: 'device:12' (cd8e7a24): kobject_uevent_env
[    3.140006] kobject: 'device:12' (cd8e7a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:12'
[    3.142584] device: 'device:13': device_add
[    3.143651] kobject: 'device:13' (cd8e7e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.145664] bus: 'acpi': add device device:13
[    3.146705] PM: Adding info for acpi:device:13
[    3.147784] kobject: 'device:13' (cd8e7e24): kobject_uevent_env
[    3.150006] kobject: 'device:13' (cd8e7e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:13'
[    3.152655] device: 'device:14': device_add
[    3.153780] kobject: 'device:14' (cd8e8224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.156047] bus: 'acpi': add device device:14
[    3.157183] PM: Adding info for acpi:device:14
[    3.158343] kobject: 'device:14' (cd8e8224): kobject_uevent_env
[    3.160005] kobject: 'device:14' (cd8e8224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14'
[    3.162606] device: 'device:15': device_add
[    3.163715] kobject: 'device:15' (cd8e8624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.166027] bus: 'acpi': add device device:15
[    3.167166] PM: Adding info for acpi:device:15
[    3.168287] kobject: 'device:15' (cd8e8624): kobject_uevent_env
[    3.169647] kobject: 'device:15' (cd8e8624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:15'
[    3.170038] device: 'device:16': device_add
[    3.171191] kobject: 'device:16' (cd8e8a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.173478] bus: 'acpi': add device device:16
[    3.174640] PM: Adding info for acpi:device:16
[    3.175795] kobject: 'device:16' (cd8e8a24): kobject_uevent_env
[    3.177151] kobject: 'device:16' (cd8e8a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:16'
[    3.180035] device: 'device:17': device_add
[    3.181156] kobject: 'device:17' (cd8e8e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.183480] bus: 'acpi': add device device:17
[    3.184656] PM: Adding info for acpi:device:17
[    3.185824] kobject: 'device:17' (cd8e8e24): kobject_uevent_env
[    3.187230] kobject: 'device:17' (cd8e8e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:17'
[    3.190035] device: 'device:18': device_add
[    3.191114] kobject: 'device:18' (cd8e9224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.193441] bus: 'acpi': add device device:18
[    3.194580] PM: Adding info for acpi:device:18
[    3.195708] kobject: 'device:18' (cd8e9224): kobject_uevent_env
[    3.197091] kobject: 'device:18' (cd8e9224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:18'
[    3.200039] device: 'device:19': device_add
[    3.201169] kobject: 'device:19' (cd8e9624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.203480] bus: 'acpi': add device device:19
[    3.204661] PM: Adding info for acpi:device:19
[    3.205800] kobject: 'device:19' (cd8e9624): kobject_uevent_env
[    3.207152] kobject: 'device:19' (cd8e9624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:19'
[    3.210045] device: 'device:1a': device_add
[    3.214532] kobject: 'device:1a' (cd8e9a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.216836] bus: 'acpi': add device device:1a
[    3.217995] PM: Adding info for acpi:device:1a
[    3.220004] kobject: 'device:1a' (cd8e9a24): kobject_uevent_env
[    3.221383] kobject: 'device:1a' (cd8e9a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1a'
[    3.223959] device: 'device:1b': device_add
[    3.225046] kobject: 'device:1b' (cd8e9e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.227342] bus: 'acpi': add device device:1b
[    3.228476] PM: Adding info for acpi:device:1b
[    3.229601] kobject: 'device:1b' (cd8e9e24): kobject_uevent_env
[    3.230020] kobject: 'device:1b' (cd8e9e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1b'
[    3.232560] device: 'device:1c': device_add
[    3.233376] kobject: 'device:1c' (cd8ea224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.234773] bus: 'acpi': add device device:1c
[    3.235463] PM: Adding info for acpi:device:1c
[    3.236153] kobject: 'device:1c' (cd8ea224): kobject_uevent_env
[    3.236989] kobject: 'device:1c' (cd8ea224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1c'
[    3.238615] device: 'device:1d': device_add
[    3.240003] kobject: 'device:1d' (cd8ea624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.241395] bus: 'acpi': add device device:1d
[    3.242085] PM: Adding info for acpi:device:1d
[    3.242808] kobject: 'device:1d' (cd8ea624): kobject_uevent_env
[    3.243669] kobject: 'device:1d' (cd8ea624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1d'
[    3.245234] device: 'device:1e': device_add
[    3.245911] kobject: 'device:1e' (cd8eaa24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.247308] bus: 'acpi': add device device:1e
[    3.248003] PM: Adding info for acpi:device:1e
[    3.248711] kobject: 'device:1e' (cd8eaa24): kobject_uevent_env
[    3.250004] kobject: 'device:1e' (cd8eaa24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1e'
[    3.251574] device: 'device:1f': device_add
[    3.252254] kobject: 'device:1f' (cd8eae24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.253661] bus: 'acpi': add device device:1f
[    3.254354] PM: Adding info for acpi:device:1f
[    3.255066] kobject: 'device:1f' (cd8eae24): kobject_uevent_env
[    3.255898] kobject: 'device:1f' (cd8eae24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1f'
[    3.257461] device: 'device:20': device_add
[    3.258132] kobject: 'device:20' (cd8eb224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.259508] bus: 'acpi': add device device:20
[    3.260006] PM: Adding info for acpi:device:20
[    3.260720] kobject: 'device:20' (cd8eb224): kobject_uevent_env
[    3.261569] kobject: 'device:20' (cd8eb224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:20'
[    3.263146] device: 'device:21': device_add
[    3.263818] kobject: 'device:21' (cd8eb624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.265204] bus: 'acpi': add device device:21
[    3.265904] PM: Adding info for acpi:device:21
[    3.266599] kobject: 'device:21' (cd8eb624): kobject_uevent_env
[    3.267438] kobject: 'device:21' (cd8eb624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21'
[    3.269000] device: 'device:22': device_add
[    3.270003] kobject: 'device:22' (cd8eba24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.271383] bus: 'acpi': add device device:22
[    3.272075] PM: Adding info for acpi:device:22
[    3.272763] kobject: 'device:22' (cd8eba24): kobject_uevent_env
[    3.273620] kobject: 'device:22' (cd8eba24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:22'
[    3.275292] device: 'PNP0103:00': device_add
[    3.275971] kobject: 'PNP0103:00' (cd8ebe24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.277409] bus: 'acpi': add device PNP0103:00
[    3.278120] PM: Adding info for acpi:PNP0103:00
[    3.278823] kobject: 'PNP0103:00' (cd8ebe24): kobject_uevent_env
[    3.279681] kobject: 'PNP0103:00' (cd8ebe24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0103:00'
[    3.280079] device: 'PNP0C0F:00': device_add
[    3.280755] kobject: 'PNP0C0F:00' (cd8ec224): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.282179] bus: 'acpi': add device PNP0C0F:00
[    3.282879] PM: Adding info for acpi:PNP0C0F:00
[    3.283600] kobject: 'PNP0C0F:00' (cd8ec224): kobject_uevent_env
[    3.284459] kobject: 'PNP0C0F:00' (cd8ec224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:00'
[    3.286003] device: 'PNP0C0F:01': device_add
[    3.286671] kobject: 'PNP0C0F:01' (cd8ec624): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.288082] bus: 'acpi': add device PNP0C0F:01
[    3.290007] PM: Adding info for acpi:PNP0C0F:01
[    3.290729] kobject: 'PNP0C0F:01' (cd8ec624): kobject_uevent_env
[    3.291590] kobject: 'PNP0C0F:01' (cd8ec624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:01'
[    3.293153] device: 'PNP0C0F:02': device_add
[    3.293819] kobject: 'PNP0C0F:02' (cd8eca24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.295190] bus: 'acpi': add device PNP0C0F:02
[    3.295877] PM: Adding info for acpi:PNP0C0F:02
[    3.296597] kobject: 'PNP0C0F:02' (cd8eca24): kobject_uevent_env
[    3.297466] kobject: 'PNP0C0F:02' (cd8eca24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:02'
[    3.298990] device: 'PNP0C0F:03': device_add
[    3.299691] kobject: 'PNP0C0F:03' (cd8ece24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.300005] bus: 'acpi': add device PNP0C0F:03
[    3.300718] PM: Adding info for acpi:PNP0C0F:03
[    3.301435] kobject: 'PNP0C0F:03' (cd8ece24): kobject_uevent_env
[    3.302304] kobject: 'PNP0C0F:03' (cd8ece24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:03'
[    3.303841] device: 'PNP0C0F:04': device_add
[    3.304540] kobject: 'PNP0C0F:04' (cd8ed224): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.305928] bus: 'acpi': add device PNP0C0F:04
[    3.306628] PM: Adding info for acpi:PNP0C0F:04
[    3.307337] kobject: 'PNP0C0F:04' (cd8ed224): kobject_uevent_env
[    3.308211] kobject: 'PNP0C0F:04' (cd8ed224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:04'
[    3.310037] device: 'LNXCPU:00': device_add
[    3.310724] kobject: 'LNXCPU:00' (cd8ed624): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.312371] bus: 'acpi': add device LNXCPU:00
[    3.313097] PM: Adding info for acpi:LNXCPU:00
[    3.313851] kobject: 'LNXCPU:00' (cd8ed624): kobject_uevent_env
[    3.314744] kobject: 'LNXCPU:00' (cd8ed624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/LNXCPU:00'
[    3.316268] device: 'LNXCPU:01': device_add
[    3.316992] kobject: 'LNXCPU:01' (cd8eda24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.318494] bus: 'acpi': add device LNXCPU:01
[    3.320007] PM: Adding info for acpi:LNXCPU:01
[    3.320911] kobject: 'LNXCPU:01' (cd8eda24): kobject_uevent_env
[    3.321863] kobject: 'LNXCPU:01' (cd8eda24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/LNXCPU:01'
[    3.323476] device: 'device:23': device_add
[    3.324150] kobject: 'device:23' (cd8ede24): kobject_add_internal: parent: 'LNXSYSTM:00', set: 'devices'
[    3.325640] bus: 'acpi': add device device:23
[    3.326383] PM: Adding info for acpi:device:23
[    3.327086] kobject: 'device:23' (cd8ede24): kobject_uevent_env
[    3.327981] kobject: 'device:23' (cd8ede24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:23'
[    3.329438] device: 'LNXPWRBN:00': device_add
[    3.330004] kobject: 'LNXPWRBN:00' (cd8ee224): kobject_add_internal: parent: 'LNXSYSTM:00', set: 'devices'
[    3.331788] bus: 'acpi': add device LNXPWRBN:00
[    3.332554] PM: Adding info for acpi:LNXPWRBN:00
[    3.333321] kobject: 'LNXPWRBN:00' (cd8ee224): kobject_uevent_env
[    3.334243] kobject: 'LNXPWRBN:00' (cd8ee224): fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXPWRBN:00'
[    3.335831] bus: 'acpi': add driver ec
[    3.336517] kobject: 'ec' (cd8de240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.337871] kobject: 'ec' (cd8de240): kobject_uevent_env
[    3.338743] kobject: 'ec' (cd8de240): fill_kobj_path: path = '/bus/acpi/drivers/ec'
[    3.340007] debugfs: creating file 'acpi'
[    3.340833] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    3.342363] bus: 'acpi': add driver pci_root
[    3.343106] kobject: 'pci_root' (cd8de360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.344502] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    3.345834] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    3.347192] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.348117] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    3.349363] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    3.350004] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    3.351375] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    3.352704] PCI: root bus 00: using default resources
[    3.353506] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    3.355179] device: 'pci0000:00': device_add
[    3.357880] kobject: 'pci0000:00' (cd8ad008): kobject_add_internal: parent: 'devices', set: 'devices'
[    3.360012] PM: Adding info for No Bus:pci0000:00
[    3.360862] kobject: 'pci0000:00' (cd8ad008): kobject_uevent_env
[    3.361746] kobject: 'pci0000:00' (cd8ad008): kobject_uevent_env: filter function caused the event to drop!
[    3.363280] device: '0000:00': device_add
[    3.363984] kobject: 'pci_bus' (cd8dfd00): kobject_add_internal: parent: 'pci0000:00', set: '(null)'
[    3.365424] kobject: '0000:00' (cd8aceac): kobject_add_internal: parent: 'pci_bus', set: 'devices'
[    3.366844] PM: Adding info for No Bus:0000:00
[    3.367593] kobject: '0000:00' (cd8aceac): kobject_uevent_env
[    3.368460] kobject: '0000:00' (cd8aceac): fill_kobj_path: path = '/devices/pci0000:00/pci_bus/0000:00'
[    3.370006] PCI host bridge to bus 0000:00
[    3.370851] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    3.372206] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.373067] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    3.373958] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    3.374951] pci_bus 0000:00: scanning bus
[    3.375666] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.376580] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x9
[    3.377695] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.378925] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.381714] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    3.383291] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.384209] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x35
[    3.385427] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x14a
[    3.386338] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    3.387588] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    3.388637] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0xf
[    3.389619] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.391482] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    3.393371] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    3.398124] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    3.399236] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    3.400645] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    3.402174] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    3.405990] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    3.407014] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    3.408587] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    3.410654] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    3.414792] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    3.416353] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    3.417804] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    3.422440] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    3.423992] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    3.425485] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    3.429575] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    3.430701] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    3.432140] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    3.436236] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.437797] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    3.439258] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    3.443186] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.444758] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    3.446218] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    3.451208] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    3.452431] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    3.455402] pci_bus 0000:00: fixups for bus
[    3.456108] pci_bus 0000:00: bus scan returning with max=00
[    3.456975] pci_bus 0000:00: on NUMA node 0
[    3.457721] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    3.459013]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    3.460013] device: '0000:00:00.0': device_add
[    3.460899] kobject: '0000:00:00.0' (cd8ee468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.462605] bus: 'pci': add device 0000:00:00.0
[    3.463391] PM: Adding info for pci:0000:00:00.0
[    3.464158] kobject: '0000:00:00.0' (cd8ee468): kobject_uevent_env
[    3.465073] kobject: '0000:00:00.0' (cd8ee468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.0'
[    3.466566] device: '0000:00:01.0': device_add
[    3.467310] kobject: '0000:00:01.0' (cd8ee868): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.469025] bus: 'pci': add device 0000:00:01.0
[    3.470024] PM: Adding info for pci:0000:00:01.0
[    3.470888] kobject: '0000:00:01.0' (cd8ee868): kobject_uevent_env
[    3.471809] kobject: '0000:00:01.0' (cd8ee868): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0'
[    3.473341] device: '0000:00:01.1': device_add
[    3.474060] kobject: '0000:00:01.1' (cd8eec68): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.475757] bus: 'pci': add device 0000:00:01.1
[    3.476512] PM: Adding info for pci:0000:00:01.1
[    3.477270] kobject: '0000:00:01.1' (cd8eec68): kobject_uevent_env
[    3.478200] kobject: '0000:00:01.1' (cd8eec68): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.1'
[    3.479646] device: '0000:00:01.3': device_add
[    3.480004] kobject: '0000:00:01.3' (cd8ef068): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.481838] bus: 'pci': add device 0000:00:01.3
[    3.482572] PM: Adding info for pci:0000:00:01.3
[    3.483331] kobject: '0000:00:01.3' (cd8ef068): kobject_uevent_env
[    3.484252] kobject: '0000:00:01.3' (cd8ef068): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.3'
[    3.485759] device: '0000:00:02.0': device_add
[    3.486457] kobject: '0000:00:02.0' (cd8ef468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.488159] bus: 'pci': add device 0000:00:02.0
[    3.488930] PM: Adding info for pci:0000:00:02.0
[    3.490004] kobject: '0000:00:02.0' (cd8ef468): kobject_uevent_env
[    3.491166] kobject: '0000:00:02.0' (cd8ef468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0'
[    3.492613] device: '0000:00:03.0': device_add
[    3.493370] kobject: '0000:00:03.0' (cd8ef868): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.495084] bus: 'pci': add device 0000:00:03.0
[    3.495837] PM: Adding info for pci:0000:00:03.0
[    3.496604] kobject: '0000:00:03.0' (cd8ef868): kobject_uevent_env
[    3.497511] kobject: '0000:00:03.0' (cd8ef868): fill_kobj_path: path = '/devices/pci0000:00/0000:00:03.0'
[    3.498975] device: '0000:00:04.0': device_add
[    3.500003] kobject: '0000:00:04.0' (cd8efc68): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.501900] bus: 'pci': add device 0000:00:04.0
[    3.502678] PM: Adding info for pci:0000:00:04.0
[    3.503460] kobject: '0000:00:04.0' (cd8efc68): kobject_uevent_env
[    3.504390] kobject: '0000:00:04.0' (cd8efc68): fill_kobj_path: path = '/devices/pci0000:00/0000:00:04.0'
[    3.505854] device: '0000:00:05.0': device_add
[    3.506599] kobject: '0000:00:05.0' (cd8f0068): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.508794] bus: 'pci': add device 0000:00:05.0
[    3.509954] PM: Adding info for pci:0000:00:05.0
[    3.510005] kobject: '0000:00:05.0' (cd8f0068): kobject_uevent_env
[    3.511442] kobject: '0000:00:05.0' (cd8f0068): fill_kobj_path: path = '/devices/pci0000:00/0000:00:05.0'
[    3.513765] device: '0000:00:06.0': device_add
[    3.514907] kobject: '0000:00:06.0' (cd8f0468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.517582] bus: 'pci': add device 0000:00:06.0
[    3.518788] PM: Adding info for pci:0000:00:06.0
[    3.520005] kobject: '0000:00:06.0' (cd8f0468): kobject_uevent_env
[    3.521425] kobject: '0000:00:06.0' (cd8f0468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:06.0'
[    3.523736] device: '0000:00:07.0': device_add
[    3.524923] kobject: '0000:00:07.0' (cd8f0868): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.527559] bus: 'pci': add device 0000:00:07.0
[    3.528754] PM: Adding info for pci:0000:00:07.0
[    3.530004] kobject: '0000:00:07.0' (cd8f0868): kobject_uevent_env
[    3.531428] kobject: '0000:00:07.0' (cd8f0868): fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
[    3.533741] device: '0000:00:08.0': device_add
[    3.534857] kobject: '0000:00:08.0' (cd8f0c68): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.537290] bus: 'pci': add device 0000:00:08.0
[    3.538402] PM: Adding info for pci:0000:00:08.0
[    3.540005] kobject: '0000:00:08.0' (cd8f0c68): kobject_uevent_env
[    3.541344] kobject: '0000:00:08.0' (cd8f0c68): fill_kobj_path: path = '/devices/pci0000:00/0000:00:08.0'
[    3.543591] device: '0000:00:09.0': device_add
[    3.544716] kobject: '0000:00:09.0' (cd8f1068): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.547359] bus: 'pci': add device 0000:00:09.0
[    3.548571] PM: Adding info for pci:0000:00:09.0
[    3.550004] kobject: '0000:00:09.0' (cd8f1068): kobject_uevent_env
[    3.551447] kobject: '0000:00:09.0' (cd8f1068): fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
[    3.553783] device: '0000:00:0a.0': device_add
[    3.554947] kobject: '0000:00:0a.0' (cd8f1468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    3.557591] bus: 'pci': add device 0000:00:0a.0
[    3.558765] PM: Adding info for pci:0000:00:0a.0
[    3.560004] kobject: '0000:00:0a.0' (cd8f1468): kobject_uevent_env
[    3.561452] kobject: '0000:00:0a.0' (cd8f1468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0a.0'
[    3.563756] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    3.565246] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    3.567114] kobject: 'pci_root' (cd8de360): kobject_uevent_env
[    3.568385] kobject: 'pci_root' (cd8de360): fill_kobj_path: path = '/bus/acpi/drivers/pci_root'
[    3.570020] bus: 'acpi': add driver pci_link
[    3.571051] kobject: 'pci_link' (cd8de9c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.576709] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    3.578849] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    3.580067] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    3.581935] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    3.583487] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    3.585488] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    3.587606] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    3.590058] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    3.591905] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    3.593366] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    3.595190] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    3.597148] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    3.600064] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    3.601829] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    3.603350] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    3.605358] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    3.607525] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    3.610064] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    3.611938] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    3.613510] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    3.615431] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    3.617588] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    3.619609] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    3.620921] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    3.622454] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    3.624409] kobject: 'pci_link' (cd8de9c0): kobject_uevent_env
[    3.625780] kobject: 'pci_link' (cd8de9c0): fill_kobj_path: path = '/bus/acpi/drivers/pci_link'
[    3.627957] kobject: 'pnp' (cd8a280c): kobject_add_internal: parent: 'bus', set: 'bus'
[    3.630009] kobject: 'pnp' (cd8a280c): kobject_uevent_env
[    3.631247] kobject: 'pnp' (cd8a280c): fill_kobj_path: path = '/bus/pnp'
[    3.632659] kobject: 'devices' (cd8f87cc): kobject_add_internal: parent: 'pnp', set: '<NULL>'
[    3.634756] kobject: 'devices' (cd8f87cc): kobject_uevent_env
[    3.636116] kobject: 'devices' (cd8f87cc): kobject_uevent_env: filter function caused the event to drop!
[    3.638403] kobject: 'drivers' (cd8f884c): kobject_add_internal: parent: 'pnp', set: '<NULL>'
[    3.640012] kobject: 'drivers' (cd8f884c): kobject_uevent_env
[    3.641357] kobject: 'drivers' (cd8f884c): kobject_uevent_env: filter function caused the event to drop!
[    3.643638] bus: 'pnp': registered
[    3.644623] bus: 'platform': add driver reg-fixed-voltage
[    3.645811] kobject: 'reg-fixed-voltage' (cd8dea20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.647995] kobject: 'reg-fixed-voltage' (cd8dea20): kobject_uevent_env
[    3.650006] kobject: 'reg-fixed-voltage' (cd8dea20): fill_kobj_path: path = '/bus/platform/drivers/reg-fixed-voltage'
[    3.652387] bus: 'i2c': add driver ad5398
[    3.653476] kobject: 'ad5398' (cd8dea80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.655641] kobject: 'ad5398' (cd8dea80): kobject_uevent_env
[    3.657009] kobject: 'ad5398' (cd8dea80): fill_kobj_path: path = '/bus/i2c/drivers/ad5398'
[    3.659095] i2c-core: driver [ad5398] registered
[    3.660005] bus: 'i2c': add driver max8649
[    3.661104] kobject: 'max8649' (cd8deae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.663332] kobject: 'max8649' (cd8deae0): kobject_uevent_env
[    3.664639] kobject: 'max8649' (cd8deae0): fill_kobj_path: path = '/bus/i2c/drivers/max8649'
[    3.666765] i2c-core: driver [max8649] registered
[    3.667940] bus: 'i2c': add driver max8660
[    3.669040] kobject: 'max8660' (cd8deb40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.670008] kobject: 'max8660' (cd8deb40): kobject_uevent_env
[    3.671388] kobject: 'max8660' (cd8deb40): fill_kobj_path: path = '/bus/i2c/drivers/max8660'
[    3.673532] i2c-core: driver [max8660] registered
[    3.674742] bus: 'i2c': add driver tps65023
[    3.675840] kobject: 'tps65023' (cd8deba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.677888] kobject: 'tps65023' (cd8deba0): kobject_uevent_env
[    3.680005] kobject: 'tps65023' (cd8deba0): fill_kobj_path: path = '/bus/i2c/drivers/tps65023'
[    3.682005] i2c-core: driver [tps65023] registered
[    3.683193] bus: 'platform': add driver tps6507x-pmic
[    3.684467] kobject: 'tps6507x-pmic' (cd8dec00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.686761] kobject: 'tps6507x-pmic' (cd8dec00): kobject_uevent_env
[    3.688200] kobject: 'tps6507x-pmic' (cd8dec00): fill_kobj_path: path = '/bus/platform/drivers/tps6507x-pmic'
[    3.690007] bus: 'platform': add driver tps65912-pmic
[    3.691292] kobject: 'tps65912-pmic' (cd8dec60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.693619] kobject: 'tps65912-pmic' (cd8dec60): kobject_uevent_env
[    3.695056] kobject: 'tps65912-pmic' (cd8dec60): fill_kobj_path: path = '/bus/platform/drivers/tps65912-pmic'
[    3.697436] bus: 'platform': add driver wm8994-ldo
[    3.700006] kobject: 'wm8994-ldo' (cd8decc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.702175] kobject: 'wm8994-ldo' (cd8decc0): kobject_uevent_env
[    3.703541] kobject: 'wm8994-ldo' (cd8decc0): fill_kobj_path: path = '/bus/platform/drivers/wm8994-ldo'
[    3.705860] device class 'misc': registering
[    3.707003] kobject: 'misc' (cd8a290c): kobject_add_internal: parent: 'class', set: 'class'
[    3.709118] kobject: 'misc' (cd8a290c): kobject_uevent_env
[    3.710005] kobject: 'misc' (cd8a290c): fill_kobj_path: path = '/class/misc'
[    3.711510] device: 'vga_arbiter': device_add
[    3.712627] kobject: 'misc' (cd8f9200): kobject_add_internal: parent: 'virtual', set: '(null)'
[    3.714770] kobject: 'vga_arbiter' (cd8ad208): kobject_add_internal: parent: 'misc', set: 'devices'
[    3.717024] PM: Adding info for No Bus:vga_arbiter
[    3.718206] kobject: 'vga_arbiter' (cd8ad208): kobject_uevent_env
[    3.720006] kobject: 'vga_arbiter' (cd8ad208): fill_kobj_path: path = '/devices/virtual/misc/vga_arbiter'
[    3.722407] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    3.724413] vgaarb: loaded
[    3.725215] vgaarb: bridge control possible 0000:00:02.0
[    3.726417] bus: 'i2c': add driver stmpe-i2c
[    3.727451] kobject: 'stmpe-i2c' (cd8dee40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.730009] kobject: 'stmpe-i2c' (cd8dee40): kobject_uevent_env
[    3.731430] kobject: 'stmpe-i2c' (cd8dee40): fill_kobj_path: path = '/bus/i2c/drivers/stmpe-i2c'
[    3.733613] i2c-core: driver [stmpe-i2c] registered
[    3.734832] bus: 'i2c': add driver tc3589x
[    3.735940] kobject: 'tc3589x' (cd8deea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.738151] kobject: 'tc3589x' (cd8deea0): kobject_uevent_env
[    3.739494] kobject: 'tc3589x' (cd8deea0): fill_kobj_path: path = '/bus/i2c/drivers/tc3589x'
[    3.740006] i2c-core: driver [tc3589x] registered
[    3.741196] bus: 'i2c': add driver WM8400
[    3.742244] kobject: 'WM8400' (cd8def00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.744393] kobject: 'WM8400' (cd8def00): kobject_uevent_env
[    3.745750] kobject: 'WM8400' (cd8def00): fill_kobj_path: path = '/bus/i2c/drivers/WM8400'
[    3.747883] i2c-core: driver [WM8400] registered
[    3.750015] bus: 'spi': add driver wm831x
[    3.751087] kobject: 'wm831x' (cd8def60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.753292] kobject: 'wm831x' (cd8def60): kobject_uevent_env
[    3.754638] kobject: 'wm831x' (cd8def60): fill_kobj_path: path = '/bus/spi/drivers/wm831x'
[    3.756776] bus: 'i2c': add driver tps6105x
[    3.757912] kobject: 'tps6105x' (cd8fa000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.760008] kobject: 'tps6105x' (cd8fa000): kobject_uevent_env
[    3.761401] kobject: 'tps6105x' (cd8fa000): fill_kobj_path: path = '/bus/i2c/drivers/tps6105x'
[    3.763601] i2c-core: driver [tps6105x] registered
[    3.764818] tps65010: version 2 May 2005
[    3.765902] bus: 'i2c': add driver tps65010
[    3.767016] kobject: 'tps65010' (cd8fa060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.770008] kobject: 'tps65010' (cd8fa060): kobject_uevent_env
[    3.771402] kobject: 'tps65010' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    3.773548] i2c-core: driver [tps65010] registered
[    3.774756] bus: 'i2c': remove driver tps65010
[    3.775891] kobject: 'tps65010' (cd8fa060): kobject_cleanup
[    3.777220] kobject: 'tps65010' (cd8fa060): auto cleanup 'remove' event
[    3.778705] kobject: 'tps65010' (cd8fa060): kobject_uevent_env
[    3.780005] kobject: 'tps65010' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    3.782162] kobject: 'tps65010' (cd8fa060): auto cleanup kobject_del
[    3.783639] sysfs tps65010: removing dir
[    3.784683] kobject: 'tps65010' (cd8fa060): calling ktype release
[    3.790004] driver: 'tps65010': driver_release
[    3.791199] kobject: 'tps65010': free name
[    3.792286] i2c-core: driver [tps65010] unregistered
[    3.793531] tps65010: re-probe ...
[    3.810014] bus: 'i2c': add driver tps65010
[    3.811455] kobject: 'tps65010' (cd8fa060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.813694] kobject: 'tps65010' (cd8fa060): kobject_uevent_env
[    3.815033] kobject: 'tps65010' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    3.817231] i2c-core: driver [tps65010] registered
[    3.818438] bus: 'i2c': remove driver tps65010
[    3.819455] kobject: 'tps65010' (cd8fa060): kobject_cleanup
[    3.820003] kobject: 'tps65010' (cd8fa060): auto cleanup 'remove' event
[    3.821041] kobject: 'tps65010' (cd8fa060): kobject_uevent_env
[    3.821895] kobject: 'tps65010' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    3.823202] kobject: 'tps65010' (cd8fa060): auto cleanup kobject_del
[    3.824082] sysfs tps65010: removing dir
[    3.824713] kobject: 'tps65010' (cd8fa060): calling ktype release
[    3.825568] driver: 'tps65010': driver_release
[    3.826286] kobject: 'tps65010': free name
[    3.826940] i2c-core: driver [tps65010] unregistered
[    3.827689] tps65010: re-probe ...
[    3.840017] bus: 'i2c': add driver tps65010
[    3.841160] kobject: 'tps65010' (cd8fa060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.843466] kobject: 'tps65010' (cd8fa060): kobject_uevent_env
[    3.844871] kobject: 'tps65010' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    3.847044] i2c-core: driver [tps65010] registered
[    3.848275] bus: 'i2c': remove driver tps65010
[    3.849428] kobject: 'tps65010' (cd8fa060): kobject_cleanup
[    3.850004] kobject: 'tps65010' (cd8fa060): auto cleanup 'remove' event
[    3.851550] kobject: 'tps65010' (cd8fa060): kobject_uevent_env
[    3.852950] kobject: 'tps65010' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    3.855155] kobject: 'tps65010' (cd8fa060): auto cleanup kobject_del
[    3.856592] sysfs tps65010: removing dir
[    3.857677] kobject: 'tps65010' (cd8fa060): calling ktype release
[    3.859095] driver: 'tps65010': driver_release
[    3.860004] kobject: 'tps65010': free name
[    3.861071] i2c-core: driver [tps65010] unregistered
[    3.862296] tps65010: no chip?
[    3.863193] bus: 'i2c': add driver tps6507x
[    3.864315] kobject: 'tps6507x' (cd8fa060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.866609] kobject: 'tps6507x' (cd8fa060): kobject_uevent_env
[    3.867957] kobject: 'tps6507x' (cd8fa060): fill_kobj_path: path = '/bus/i2c/drivers/tps6507x'
[    3.870006] i2c-core: driver [tps6507x] registered
[    3.871244] bus: 'spi': add driver tps65912
[    3.872348] kobject: 'tps65912' (cd8fa0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.874624] kobject: 'tps65912' (cd8fa0c0): kobject_uevent_env
[    3.876014] kobject: 'tps65912' (cd8fa0c0): fill_kobj_path: path = '/bus/spi/drivers/tps65912'
[    3.878207] bus: 'i2c': add driver max8925
[    3.880005] kobject: 'max8925' (cd8fa120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.882288] kobject: 'max8925' (cd8fa120): kobject_uevent_env
[    3.883625] kobject: 'max8925' (cd8fa120): fill_kobj_path: path = '/bus/i2c/drivers/max8925'
[    3.885774] i2c-core: driver [max8925] registered
[    3.887033] bus: 'i2c': add driver max8998
[    3.888165] kobject: 'max8998' (cd8fa180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.890009] kobject: 'max8998' (cd8fa180): kobject_uevent_env
[    3.891350] kobject: 'max8998' (cd8fa180): fill_kobj_path: path = '/bus/i2c/drivers/max8998'
[    3.893327] i2c-core: driver [max8998] registered
[    3.894430] bus: 'i2c': add driver pcf50633
[    3.895447] kobject: 'pcf50633' (cd8fa1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.897493] kobject: 'pcf50633' (cd8fa1e0): kobject_uevent_env
[    3.898748] kobject: 'pcf50633' (cd8fa1e0): fill_kobj_path: path = '/bus/i2c/drivers/pcf50633'
[    3.900005] i2c-core: driver [pcf50633] registered
[    3.901212] bus: 'i2c': add driver tps6586x
[    3.902342] kobject: 'tps6586x' (cd8fa240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.904554] kobject: 'tps6586x' (cd8fa240): kobject_uevent_env
[    3.905932] kobject: 'tps6586x' (cd8fa240): fill_kobj_path: path = '/bus/i2c/drivers/tps6586x'
[    3.908075] i2c-core: driver [tps6586x] registered
[    3.910005] bus: 'i2c': add driver aat2870
[    3.911030] kobject: 'aat2870' (cd8fa2a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.913258] kobject: 'aat2870' (cd8fa2a0): kobject_uevent_env
[    3.914645] kobject: 'aat2870' (cd8fa2a0): fill_kobj_path: path = '/bus/i2c/drivers/aat2870'
[    3.916742] i2c-core: driver [aat2870] registered
[    3.918102] device class 'scsi_host': registering
[    3.920006] kobject: 'scsi_host' (cd8a2c0c): kobject_add_internal: parent: 'class', set: 'class'
[    3.922169] kobject: 'scsi_host' (cd8a2c0c): kobject_uevent_env
[    3.923546] kobject: 'scsi_host' (cd8a2c0c): fill_kobj_path: path = '/class/scsi_host'
[    3.925597] kobject: 'scsi' (cd8a2d0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    3.927708] kobject: 'scsi' (cd8a2d0c): kobject_uevent_env
[    3.929025] kobject: 'scsi' (cd8a2d0c): fill_kobj_path: path = '/bus/scsi'
[    3.930008] kobject: 'devices' (cd8fdf4c): kobject_add_internal: parent: 'scsi', set: '<NULL>'
[    3.932194] kobject: 'devices' (cd8fdf4c): kobject_uevent_env
[    3.933501] kobject: 'devices' (cd8fdf4c): kobject_uevent_env: filter function caused the event to drop!
[    3.935624] kobject: 'drivers' (cd8fdfcc): kobject_add_internal: parent: 'scsi', set: '<NULL>'
[    3.937707] kobject: 'drivers' (cd8fdfcc): kobject_uevent_env
[    3.938966] kobject: 'drivers' (cd8fdfcc): kobject_uevent_env: filter function caused the event to drop!
[    3.940006] bus: 'scsi': registered
[    3.941034] device class 'scsi_device': registering
[    3.942230] kobject: 'scsi_device' (cd8a2e0c): kobject_add_internal: parent: 'class', set: 'class'
[    3.944432] kobject: 'scsi_device' (cd8a2e0c): kobject_uevent_env
[    3.945901] kobject: 'scsi_device' (cd8a2e0c): fill_kobj_path: path = '/class/scsi_device'
[    3.950009] SCSI subsystem initialized
[    3.951056] ACPI: bus type scsi registered
[    3.952145] device class 'ata_link': registering
[    3.953342] kobject: 'ata_link' (cd8a2f0c): kobject_add_internal: parent: 'class', set: 'class'
[    3.955515] kobject: 'ata_link' (cd8a2f0c): kobject_uevent_env
[    3.956862] kobject: 'ata_link' (cd8a2f0c): fill_kobj_path: path = '/class/ata_link'
[    3.958870] device class 'ata_port': registering
[    3.960013] kobject: 'ata_port' (cd8ff00c): kobject_add_internal: parent: 'class', set: 'class'
[    3.962184] kobject: 'ata_port' (cd8ff00c): kobject_uevent_env
[    3.963540] kobject: 'ata_port' (cd8ff00c): fill_kobj_path: path = '/class/ata_port'
[    3.965498] device class 'ata_device': registering
[    3.966714] kobject: 'ata_device' (cd8ff10c): kobject_add_internal: parent: 'class', set: 'class'
[    3.968841] kobject: 'ata_device' (cd8ff10c): kobject_uevent_env
[    3.970005] kobject: 'ata_device' (cd8ff10c): fill_kobj_path: path = '/class/ata_device'
[    3.971943] libata version 3.00 loaded.
[    3.973017] device class 'mdio_bus': registering
[    3.974190] kobject: 'mdio_bus' (cd8ff20c): kobject_add_internal: parent: 'class', set: 'class'
[    3.976392] kobject: 'mdio_bus' (cd8ff20c): kobject_uevent_env
[    3.977747] kobject: 'mdio_bus' (cd8ff20c): fill_kobj_path: path = '/class/mdio_bus'
[    3.980007] kobject: 'mdio_bus' (cd8ff30c): kobject_add_internal: parent: 'bus', set: 'bus'
[    3.982129] kobject: 'mdio_bus' (cd8ff30c): kobject_uevent_env
[    3.983528] kobject: 'mdio_bus' (cd8ff30c): fill_kobj_path: path = '/bus/mdio_bus'
[    3.985551] kobject: 'devices' (cd8fe2cc): kobject_add_internal: parent: 'mdio_bus', set: '<NULL>'
[    3.987796] kobject: 'devices' (cd8fe2cc): kobject_uevent_env
[    3.989068] kobject: 'devices' (cd8fe2cc): kobject_uevent_env: filter function caused the event to drop!
[    3.990005] kobject: 'drivers' (cd8fe34c): kobject_add_internal: parent: 'mdio_bus', set: '<NULL>'
[    3.992186] kobject: 'drivers' (cd8fe34c): kobject_uevent_env
[    3.993545] kobject: 'drivers' (cd8fe34c): kobject_uevent_env: filter function caused the event to drop!
[    3.995845] bus: 'mdio_bus': registered
[    3.996900] bus: 'mdio_bus': add driver Generic PHY
[    3.998124] kobject: 'Generic PHY' (cd8fa420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.000009] kobject: 'Generic PHY' (cd8fa420): kobject_uevent_env
[    4.001470] kobject: 'Generic PHY' (cd8fa420): fill_kobj_path: path = '/bus/mdio_bus/drivers/Generic PHY'
[    4.003822] libphy: Generic PHY: Registered new driver
[    4.005000] device class 'pcmcia_socket': registering
[    4.006160] kobject: 'pcmcia_socket' (cd8ff40c): kobject_add_internal: parent: 'class', set: 'class'
[    4.008232] kobject: 'pcmcia_socket' (cd8ff40c): kobject_uevent_env
[    4.010007] kobject: 'pcmcia_socket' (cd8ff40c): fill_kobj_path: path = '/class/pcmcia_socket'
[    4.012148] debugfs: creating file 'usb'
[    4.013287] debugfs: creating file 'devices'
[    4.014426] ACPI: bus type usb registered
[    4.015508] kobject: 'usb' (cd8ff50c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.020006] kobject: 'usb' (cd8ff50c): kobject_uevent_env
[    4.021344] kobject: 'usb' (cd8ff50c): fill_kobj_path: path = '/bus/usb'
[    4.022882] kobject: 'devices' (cd8fe60c): kobject_add_internal: parent: 'usb', set: '<NULL>'
[    4.025025] kobject: 'devices' (cd8fe60c): kobject_uevent_env
[    4.026372] kobject: 'devices' (cd8fe60c): kobject_uevent_env: filter function caused the event to drop!
[    4.030005] kobject: 'drivers' (cd8fe68c): kobject_add_internal: parent: 'usb', set: '<NULL>'
[    4.032162] kobject: 'drivers' (cd8fe68c): kobject_uevent_env
[    4.033423] kobject: 'drivers' (cd8fe68c): kobject_uevent_env: filter function caused the event to drop!
[    4.035557] bus: 'usb': registered
[    4.036483] bus: 'usb': add driver usbfs
[    4.037473] kobject: 'usbfs' (cd8fa4e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.040008] kobject: 'usbfs' (cd8fa4e0): kobject_uevent_env
[    4.041255] kobject: 'usbfs' (cd8fa4e0): fill_kobj_path: path = '/bus/usb/drivers/usbfs'
[    4.043374] usbcore: registered new interface driver usbfs
[    4.044722] bus: 'usb': add driver hub
[    4.045781] kobject: 'hub' (cd8fa5a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.047930] kobject: 'hub' (cd8fa5a0): kobject_uevent_env
[    4.049199] kobject: 'hub' (cd8fa5a0): fill_kobj_path: path = '/bus/usb/drivers/hub'
[    4.050006] usbcore: registered new interface driver hub
[    4.051420] bus: 'usb': add driver usb
[    4.051420] kobject: 'usb' (cd8fa600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.053277] kobject: 'usb' (cd8fa600): kobject_uevent_env
[    4.054567] kobject: 'usb' (cd8fa600): fill_kobj_path: path = '/bus/usb/drivers/usb'
[    4.056571] usbcore: registered new device driver usb
[    4.060008] device class 'udc': registering
[    4.061147] kobject: 'udc' (cd8ff60c): kobject_add_internal: parent: 'class', set: 'class'
[    4.063289] kobject: 'udc' (cd8ff60c): kobject_uevent_env
[    4.064613] kobject: 'udc' (cd8ff60c): fill_kobj_path: path = '/class/udc'
[    4.066172] kobject: 'serio' (cd8ff70c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.068224] kobject: 'serio' (cd8ff70c): kobject_uevent_env
[    4.070005] kobject: 'serio' (cd8ff70c): fill_kobj_path: path = '/bus/serio'
[    4.071524] kobject: 'devices' (cd8fed0c): kobject_add_internal: parent: 'serio', set: '<NULL>'
[    4.073592] kobject: 'devices' (cd8fed0c): kobject_uevent_env
[    4.074853] kobject: 'devices' (cd8fed0c): kobject_uevent_env: filter function caused the event to drop!
[    4.077039] kobject: 'drivers' (cd8fed8c): kobject_add_internal: parent: 'serio', set: '<NULL>'
[    4.079238] kobject: 'drivers' (cd8fed8c): kobject_uevent_env
[    4.080004] kobject: 'drivers' (cd8fed8c): kobject_uevent_env: filter function caused the event to drop!
[    4.082323] bus: 'serio': registered
[    4.083349] kobject: 'gameport' (cd8ff80c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.085456] kobject: 'gameport' (cd8ff80c): kobject_uevent_env
[    4.086784] kobject: 'gameport' (cd8ff80c): fill_kobj_path: path = '/bus/gameport'
[    4.090009] kobject: 'devices' (cd8fef0c): kobject_add_internal: parent: 'gameport', set: '<NULL>'
[    4.092269] kobject: 'devices' (cd8fef0c): kobject_uevent_env
[    4.093649] kobject: 'devices' (cd8fef0c): kobject_uevent_env: filter function caused the event to drop!
[    4.095970] kobject: 'drivers' (cd8fef8c): kobject_add_internal: parent: 'gameport', set: '<NULL>'
[    4.098218] kobject: 'drivers' (cd8fef8c): kobject_uevent_env
[    4.099600] kobject: 'drivers' (cd8fef8c): kobject_uevent_env: filter function caused the event to drop!
[    4.100017] bus: 'gameport': registered
[    4.101092] device class 'input': registering
[    4.102254] kobject: 'input' (cd8ff90c): kobject_add_internal: parent: 'class', set: 'class'
[    4.104437] kobject: 'input' (cd8ff90c): kobject_uevent_env
[    4.105831] kobject: 'input' (cd8ff90c): fill_kobj_path: path = '/class/input'
[    4.107791] bus: 'platform': add driver i2c-gpio
[    4.110008] kobject: 'i2c-gpio' (cd8fa7e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.112259] kobject: 'i2c-gpio' (cd8fa7e0): kobject_uevent_env
[    4.113570] kobject: 'i2c-gpio' (cd8fa7e0): fill_kobj_path: path = '/bus/platform/drivers/i2c-gpio'
[    4.115756] device class 'power_supply': registering
[    4.116952] kobject: 'power_supply' (cd8ffa0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.120013] kobject: 'power_supply' (cd8ffa0c): kobject_uevent_env
[    4.121370] kobject: 'power_supply' (cd8ffa0c): fill_kobj_path: path = '/class/power_supply'
[    4.123476] device class 'hwmon': registering
[    4.124565] kobject: 'hwmon' (cd8ffb0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.126633] kobject: 'hwmon' (cd8ffb0c): kobject_uevent_env
[    4.127918] kobject: 'hwmon' (cd8ffb0c): fill_kobj_path: path = '/class/hwmon'
[    4.130012] device class 'watchdog': registering
[    4.131159] kobject: 'watchdog' (cd8ffc0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.133263] kobject: 'watchdog' (cd8ffc0c): kobject_uevent_env
[    4.134593] kobject: 'watchdog' (cd8ffc0c): fill_kobj_path: path = '/class/watchdog'
[    4.137208] md: sizeof(mdp_super_t) = 4096
[    4.138259] kobject: 'mmc' (cd8ffd0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.140011] kobject: 'mmc' (cd8ffd0c): kobject_uevent_env
[    4.141159] kobject: 'mmc' (cd8ffd0c): fill_kobj_path: path = '/bus/mmc'
[    4.142465] kobject: 'devices' (cd91048c): kobject_add_internal: parent: 'mmc', set: '<NULL>'
[    4.144272] kobject: 'devices' (cd91048c): kobject_uevent_env
[    4.145394] kobject: 'devices' (cd91048c): kobject_uevent_env: filter function caused the event to drop!
[    4.147331] kobject: 'drivers' (cd91050c): kobject_add_internal: parent: 'mmc', set: '<NULL>'
[    4.150006] kobject: 'drivers' (cd91050c): kobject_uevent_env
[    4.151177] kobject: 'drivers' (cd91050c): kobject_uevent_env: filter function caused the event to drop!
[    4.153172] bus: 'mmc': registered
[    4.154047] device class 'mmc_host': registering
[    4.155066] kobject: 'mmc_host' (cd8ffe0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.156972] kobject: 'mmc_host' (cd8ffe0c): kobject_uevent_env
[    4.158167] kobject: 'mmc_host' (cd8ffe0c): fill_kobj_path: path = '/class/mmc_host'
[    4.160013] kobject: 'sdio' (cd8fff0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.161828] kobject: 'sdio' (cd8fff0c): kobject_uevent_env
[    4.162994] kobject: 'sdio' (cd8fff0c): fill_kobj_path: path = '/bus/sdio'
[    4.164352] kobject: 'devices' (cd9106cc): kobject_add_internal: parent: 'sdio', set: '<NULL>'
[    4.166355] kobject: 'devices' (cd9106cc): kobject_uevent_env
[    4.167617] kobject: 'devices' (cd9106cc): kobject_uevent_env: filter function caused the event to drop!
[    4.170008] kobject: 'drivers' (cd91074c): kobject_add_internal: parent: 'sdio', set: '<NULL>'
[    4.172014] kobject: 'drivers' (cd91074c): kobject_uevent_env
[    4.173277] kobject: 'drivers' (cd91074c): kobject_uevent_env: filter function caused the event to drop!
[    4.175398] bus: 'sdio': registered
[    4.176321] device class 'leds': registering
[    4.177368] kobject: 'leds' (cd91100c): kobject_add_internal: parent: 'class', set: 'class'
[    4.179328] kobject: 'leds' (cd91100c): kobject_uevent_env
[    4.180007] kobject: 'leds' (cd91100c): fill_kobj_path: path = '/class/leds'
[    4.181446] device class 'sound': registering
[    4.182444] kobject: 'sound' (cd91110c): kobject_add_internal: parent: 'class', set: 'class'
[    4.184364] kobject: 'sound' (cd91110c): kobject_uevent_env
[    4.185542] kobject: 'sound' (cd91110c): fill_kobj_path: path = '/class/sound'
[    4.187220] PCI: Using ACPI for IRQ routing
[    4.188195] PCI: pci_cache_line_size set to 64 bytes
[    4.190012] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    4.191842] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    4.193598] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    4.195496] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    4.197245] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    4.199106] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    4.200011] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    4.201996] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    4.203959] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    4.205829] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    4.207672] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1fff flags 0x40200] (d=0, p=0)
[    4.210023] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    4.211795] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2fff flags 0x40200] (d=0, p=0)
[    4.213666] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    4.215470] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    4.220020] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    4.221820] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    4.223748] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    4.225608] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    4.227618] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    4.230007] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    4.232081] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700f flags 0x40200] (d=0, p=0)
[    4.234265] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    4.235559] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    4.236880] device class 'net': registering
[    4.237911] kobject: 'net' (cd91120c): kobject_add_internal: parent: 'class', set: 'class'
[    4.240012] kobject: 'net' (cd91120c): kobject_uevent_env
[    4.241219] kobject: 'net' (cd91120c): fill_kobj_path: path = '/class/net'
[    4.242690] device: 'lo': device_add
[    4.243624] kobject: 'net' (cd910a00): kobject_add_internal: parent: 'virtual', set: '(null)'
[    4.245586] kobject: 'lo' (cd890a34): kobject_add_internal: parent: 'net', set: 'devices'
[    4.247473] PM: Adding info for No Bus:lo
[    4.248446] kobject: 'lo' (cd890a34): kobject_uevent_env
[    4.250008] kobject: 'lo' (cd890a34): fill_kobj_path: path = '/devices/virtual/net/lo'
[    4.251782] kobject: 'queues' (cd9127cc): kobject_add_internal: parent: 'lo', set: '<NULL>'
[    4.253641] kobject: 'queues' (cd9127cc): kobject_uevent_env
[    4.254808] kobject: 'queues' (cd9127cc): kobject_uevent_env: filter function caused the event to drop!
[    4.256799] kobject: 'rx-0' (cd9109c8): kobject_add_internal: parent: 'queues', set: 'queues'
[    4.258701] kobject: 'rx-0' (cd9109c8): kobject_uevent_env
[    4.259892] kobject: 'rx-0' (cd9109c8): fill_kobj_path: path = '/devices/virtual/net/lo/queues/rx-0'
[    4.260008] kobject: 'tx-0' (cd91130c): kobject_add_internal: parent: 'queues', set: 'queues'
[    4.261883] kobject: 'tx-0' (cd91130c): kobject_uevent_env
[    4.263024] kobject: 'tx-0' (cd91130c): fill_kobj_path: path = '/devices/virtual/net/lo/queues/tx-0'
[    4.265118] NET: Registered protocol family 23
[    4.266169] Bluetooth: Core ver 2.16
[    4.267060] debugfs: creating file 'bluetooth'
[    4.270019] device class 'bluetooth': registering
[    4.271059] kobject: 'bluetooth' (cd91160c): kobject_add_internal: parent: 'class', set: 'class'
[    4.272953] kobject: 'bluetooth' (cd91160c): kobject_uevent_env
[    4.274107] kobject: 'bluetooth' (cd91160c): fill_kobj_path: path = '/class/bluetooth'
[    4.275833] NET: Registered protocol family 31
[    4.276805] Bluetooth: HCI device and connection manager initialized
[    4.278015] Bluetooth: HCI socket layer initialized
[    4.279025] Bluetooth: L2CAP socket layer initialized
[    4.280004] debugfs: creating file 'l2cap'
[    4.280973] debugfs: creating file 'sco'
[    4.281908] Bluetooth: SCO socket layer initialized
[    4.282973] NET: Registered protocol family 8
[    4.283961] NET: Registered protocol family 20
[    4.284989] device class 'atm': registering
[    4.285945] kobject: 'atm' (cd91170c): kobject_add_internal: parent: 'class', set: 'class'
[    4.287735] kobject: 'atm' (cd91170c): kobject_uevent_env
[    4.288844] kobject: 'atm' (cd91170c): fill_kobj_path: path = '/class/atm'
[    4.290017] doing fs, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    4.296645] doing fs: hung_task_panic='1'
[    4.297676] doing fs: bisect-reboot='(null)'
[    4.298744] doing fs: i386-randconfig-b064='(null)'
[    4.300028] doing fs: branch='mfd/for-next'
[    4.301080] doing fs: dyndbg='+p'
[    4.302001] doing fs: log_buf_len='8M'
[    4.302988] doing fs: ignore_loglevel='(null)'
[    4.304068] doing fs: debug='(null)'
[    4.305025] doing fs: sched_debug='(null)'
[    4.306054] doing fs: apic='debug'
[    4.306996] doing fs: dynamic_printk='(null)'
[    4.308085] doing fs: sysrq_always_enabled='(null)'
[    4.309246] doing fs: prompt_ramdisk='0'
[    4.310029] doing fs: console='ttyS0,115200'
[    4.311046] doing fs: console='tty0'
[    4.311984] doing fs: vga='normal'
[    4.312877] doing fs: root='/dev/ram0'
[    4.313802] doing fs: rw='(null)'
[    4.314658] doing fs: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    4.315825] Switching to clocksource hpet
[    4.316947] debugfs: creating file 'dynamic_debug'
[    4.318013] debugfs: creating file 'control'
[    4.319020] bus: 'pnp': add driver system
[    4.319020] kobject: 'system' (cd913180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.319020] kobject: 'system' (cd913180): kobject_uevent_env
[    4.319020] kobject: 'system' (cd913180): fill_kobj_path: path = '/bus/pnp/drivers/system'
[    4.319020] pnp: PnP ACPI init
[    4.319244] device: 'pnp0': device_add
[    4.320197] kobject: 'pnp0' (c1947910): kobject_add_internal: parent: 'devices', set: 'devices'
[    4.322098] PM: Adding info for No Bus:pnp0
[    4.323079] kobject: 'pnp0' (c1947910): kobject_uevent_env
[    4.324233] kobject: 'pnp0' (c1947910): kobject_uevent_env: filter function caused the event to drop!
[    4.326209] ACPI: bus type pnp registered
[    4.327188] pnp 00:00: [bus 00-ff]
[    4.328057] pnp 00:00: [io  0x0cf8-0x0cff]
[    4.328999] pnp 00:00: [io  0x0000-0x0cf7 window]
[    4.330053] pnp 00:00: [io  0x0d00-0xffff window]
[    4.331052] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    4.332138] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    4.333232] pnp 00:00: ACPI device not found in pnpacpi_can_wakeup!
[    4.334435] device: '00:00': device_add
[    4.335317] kobject: '00:00' (cd8ad808): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.337180] bus: 'pnp': add device 00:00
[    4.338131] PM: Adding info for pnp:00:00
[    4.339072] kobject: '00:00' (cd8ad808): kobject_uevent_env
[    4.340267] kobject: '00:00' (cd8ad808): fill_kobj_path: path = '/devices/pnp0/00:00'
[    4.342060] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    4.343339] pnp 00:01: [io  0x0070-0x0071]
[    4.344290] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    4.346077] pnp 00:01: [irq 8]
[    4.346891] pnp 00:01: [io  0x0072-0x0077]
[    4.347852] pnp 00:01: ACPI device not found in pnpacpi_can_wakeup!
[    4.349129] device: '00:01': device_add
[    4.350154] kobject: '00:01' (cd8ada08): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.352156] bus: 'pnp': add device 00:01
[    4.353155] PM: Adding info for pnp:00:01
[    4.354154] kobject: '00:01' (cd8ada08): kobject_uevent_env
[    4.355384] kobject: '00:01' (cd8ada08): fill_kobj_path: path = '/devices/pnp0/00:01'
[    4.357275] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.358691] pnp 00:02: [io  0x0060]
[    4.359619] pnp 00:02: [io  0x0064]
[    4.360601] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    4.362512] pnp 00:02: [irq 1]
[    4.363371] pnp 00:02: ACPI device not found in pnpacpi_can_wakeup!
[    4.364696] device: '00:02': device_add
[    4.365673] kobject: '00:02' (cd8adc08): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.367613] bus: 'pnp': add device 00:02
[    4.368575] PM: Adding info for pnp:00:02
[    4.369550] kobject: '00:02' (cd8adc08): kobject_uevent_env
[    4.370781] kobject: '00:02' (cd8adc08): fill_kobj_path: path = '/devices/pnp0/00:02'
[    4.372558] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    4.373885] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    4.375717] pnp 00:03: [irq 12]
[    4.376539] pnp 00:03: ACPI device not found in pnpacpi_can_wakeup!
[    4.377777] device: '00:03': device_add
[    4.378731] kobject: '00:03' (cd8ade08): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.380722] bus: 'pnp': add device 00:03
[    4.381666] PM: Adding info for pnp:00:03
[    4.382611] kobject: '00:03' (cd8ade08): kobject_uevent_env
[    4.383764] kobject: '00:03' (cd8ade08): fill_kobj_path: path = '/devices/pnp0/00:03'
[    4.385537] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    4.386883] pnp 00:04: [io  0x03f2-0x03f5]
[    4.387862] pnp 00:04: [io  0x03f7]
[    4.388741] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    4.390604] pnp 00:04: [irq 6]
[    4.391417] pnp 00:04: [dma 2]
[    4.392231] pnp 00:04: ACPI device not found in pnpacpi_can_wakeup!
[    4.393465] device: '00:04': device_add
[    4.394364] kobject: '00:04' (cd922008): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.395868] bus: 'pnp': add device 00:04
[    4.398434] PM: Adding info for pnp:00:04
[    4.399092] kobject: '00:04' (cd922008): kobject_uevent_env
[    4.399900] kobject: '00:04' (cd922008): fill_kobj_path: path = '/devices/pnp0/00:04'
[    4.401178] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    4.402136] pnp 00:05: [io  0x0378-0x037f]
[    4.402803] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    4.404061] pnp 00:05: [irq 7]
[    4.404619] pnp 00:05: ACPI device not found in pnpacpi_can_wakeup!
[    4.405493] device: '00:05': device_add
[    4.406134] kobject: '00:05' (cd922208): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.407443] bus: 'pnp': add device 00:05
[    4.408098] PM: Adding info for pnp:00:05
[    4.408756] kobject: '00:05' (cd922208): kobject_uevent_env
[    4.409569] kobject: '00:05' (cd922208): fill_kobj_path: path = '/devices/pnp0/00:05'
[    4.410847] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    4.411794] pnp 00:06: [io  0x03f8-0x03ff]
[    4.412460] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    4.413714] pnp 00:06: [irq 4]
[    4.414277] pnp 00:06: ACPI device not found in pnpacpi_can_wakeup!
[    4.415158] device: '00:06': device_add
[    4.415794] kobject: '00:06' (cd922408): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.417108] bus: 'pnp': add device 00:06
[    4.417764] PM: Adding info for pnp:00:06
[    4.418420] kobject: '00:06' (cd922408): kobject_uevent_env
[    4.419230] kobject: '00:06' (cd922408): fill_kobj_path: path = '/devices/pnp0/00:06'
[    4.420499] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.421508] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    4.422251] pnp 00:07: ACPI device not found in pnpacpi_can_wakeup!
[    4.423126] device: '00:07': device_add
[    4.423761] kobject: '00:07' (cd922608): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    4.425079] bus: 'pnp': add device 00:07
[    4.425731] PM: Adding info for pnp:00:07
[    4.426385] kobject: '00:07' (cd922608): kobject_uevent_env
[    4.427194] kobject: '00:07' (cd922608): fill_kobj_path: path = '/devices/pnp0/00:07'
[    4.428431] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.429443] pnp: PnP ACPI: found 8 devices
[    4.430147] ACPI: ACPI bus type pnp unregistered
[    4.430879] device class 'mem': registering
[    4.431556] kobject: 'mem' (cd911a0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.432836] kobject: 'mem' (cd911a0c): kobject_uevent_env
[    4.433631] kobject: 'mem' (cd911a0c): fill_kobj_path: path = '/class/mem'
[    4.434573] device: 'mem': device_add
[    4.435202] kobject: 'mem' (cd916700): kobject_add_internal: parent: 'virtual', set: '(null)'
[    4.436505] kobject: 'mem' (cd922808): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.437794] PM: Adding info for No Bus:mem
[    4.438459] kobject: 'mem' (cd922808): kobject_uevent_env
[    4.439254] kobject: 'mem' (cd922808): fill_kobj_path: path = '/devices/virtual/mem/mem'
[    4.440557] device: 'null': device_add
[    4.441201] kobject: 'null' (cd922a08): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.442501] PM: Adding info for No Bus:null
[    4.443186] kobject: 'null' (cd922a08): kobject_uevent_env
[    4.444000] kobject: 'null' (cd922a08): fill_kobj_path: path = '/devices/virtual/mem/null'
[    4.445298] device: 'port': device_add
[    4.445931] kobject: 'port' (cd922c08): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.447251] PM: Adding info for No Bus:port
[    4.447919] kobject: 'port' (cd922c08): kobject_uevent_env
[    4.448735] kobject: 'port' (cd922c08): fill_kobj_path: path = '/devices/virtual/mem/port'
[    4.450080] device: 'zero': device_add
[    4.450709] kobject: 'zero' (cd922e08): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.452030] PM: Adding info for No Bus:zero
[    4.452703] kobject: 'zero' (cd922e08): kobject_uevent_env
[    4.453513] kobject: 'zero' (cd922e08): fill_kobj_path: path = '/devices/virtual/mem/zero'
[    4.454801] device: 'full': device_add
[    4.455452] kobject: 'full' (cd923008): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.456757] PM: Adding info for No Bus:full
[    4.457438] kobject: 'full' (cd923008): kobject_uevent_env
[    4.458246] kobject: 'full' (cd923008): fill_kobj_path: path = '/devices/virtual/mem/full'
[    4.459535] device: 'random': device_add
[    4.460228] kobject: 'random' (cd923208): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.461538] PM: Adding info for No Bus:random
[    4.462247] kobject: 'random' (cd923208): kobject_uevent_env
[    4.463090] kobject: 'random' (cd923208): fill_kobj_path: path = '/devices/virtual/mem/random'
[    4.464446] device: 'urandom': device_add
[    4.465119] kobject: 'urandom' (cd923408): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.466445] PM: Adding info for No Bus:urandom
[    4.467154] kobject: 'urandom' (cd923408): kobject_uevent_env
[    4.467990] kobject: 'urandom' (cd923408): fill_kobj_path: path = '/devices/virtual/mem/urandom'
[    4.469333] device: 'kmsg': device_add
[    4.469976] kobject: 'kmsg' (cd923608): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.471314] PM: Adding info for No Bus:kmsg
[    4.472037] kobject: 'kmsg' (cd923608): kobject_uevent_env
[    4.472830] kobject: 'kmsg' (cd923608): fill_kobj_path: path = '/devices/virtual/mem/kmsg'
[    4.474137] device: 'oldmem': device_add
[    4.474781] kobject: 'oldmem' (cd923808): kobject_add_internal: parent: 'mem', set: 'devices'
[    4.476112] PM: Adding info for No Bus:oldmem
[    4.476802] kobject: 'oldmem' (cd923808): kobject_uevent_env
[    4.477639] kobject: 'oldmem' (cd923808): fill_kobj_path: path = '/devices/virtual/mem/oldmem'
[    4.478971] device: 'tty': device_add
[    4.479591] kobject: 'tty' (cd918280): kobject_add_internal: parent: 'virtual', set: '(null)'
[    4.480950] kobject: 'tty' (cd923a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.482240] PM: Adding info for No Bus:tty
[    4.482898] kobject: 'tty' (cd923a08): kobject_uevent_env
[    4.483702] kobject: 'tty' (cd923a08): fill_kobj_path: path = '/devices/virtual/tty/tty'
[    4.484986] device: 'console': device_add
[    4.485640] kobject: 'console' (cd923c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.486974] PM: Adding info for No Bus:console
[    4.487674] kobject: 'console' (cd923c08): kobject_uevent_env
[    4.488509] kobject: 'console' (cd923c08): fill_kobj_path: path = '/devices/virtual/tty/console'
[    4.489847] device: 'tty0': device_add
[    4.490525] kobject: 'tty0' (cd923e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.491827] PM: Adding info for No Bus:tty0
[    4.492509] kobject: 'tty0' (cd923e08): kobject_uevent_env
[    4.493317] kobject: 'tty0' (cd923e08): fill_kobj_path: path = '/devices/virtual/tty/tty0'
[    4.494602] device class 'vc': registering
[    4.495276] kobject: 'vc' (cd911b0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.496549] kobject: 'vc' (cd911b0c): kobject_uevent_env
[    4.497346] kobject: 'vc' (cd911b0c): fill_kobj_path: path = '/class/vc'
[    4.498292] device: 'vcs': device_add
[    4.498914] kobject: 'vc' (cd918d40): kobject_add_internal: parent: 'virtual', set: '(null)'
[    4.500257] kobject: 'vcs' (cd924008): kobject_add_internal: parent: 'vc', set: 'devices'
[    4.501530] PM: Adding info for No Bus:vcs
[    4.502197] kobject: 'vcs' (cd924008): kobject_uevent_env
[    4.502990] kobject: 'vcs' (cd924008): fill_kobj_path: path = '/devices/virtual/vc/vcs'
[    4.504240] device: 'vcsa': device_add
[    4.504866] kobject: 'vcsa' (cd924208): kobject_add_internal: parent: 'vc', set: 'devices'
[    4.506150] PM: Adding info for No Bus:vcsa
[    4.506816] kobject: 'vcsa' (cd924208): kobject_uevent_env
[    4.507622] kobject: 'vcsa' (cd924208): fill_kobj_path: path = '/devices/virtual/vc/vcsa'
[    4.508893] device: 'vcs1': device_add
[    4.509528] kobject: 'vcs1' (cd924408): kobject_add_internal: parent: 'vc', set: 'devices'
[    4.510847] PM: Adding info for No Bus:vcs1
[    4.511527] kobject: 'vcs1' (cd924408): kobject_uevent_env
[    4.512329] kobject: 'vcs1' (cd924408): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
[    4.513598] device: 'vcsa1': device_add
[    4.514239] kobject: 'vcsa1' (cd924608): kobject_add_internal: parent: 'vc', set: 'devices'
[    4.515526] PM: Adding info for No Bus:vcsa1
[    4.516209] kobject: 'vcsa1' (cd924608): kobject_uevent_env
[    4.517020] kobject: 'vcsa1' (cd924608): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
[    4.518310] device: 'tty1': device_add
[    4.518945] kobject: 'tty1' (cd924a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.520270] PM: Adding info for No Bus:tty1
[    4.520944] kobject: 'tty1' (cd924a08): kobject_uevent_env
[    4.521740] kobject: 'tty1' (cd924a08): fill_kobj_path: path = '/devices/virtual/tty/tty1'
[    4.524922] device: 'tty2': device_add
[    4.525554] kobject: 'tty2' (cd924c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.526841] PM: Adding info for No Bus:tty2
[    4.527515] kobject: 'tty2' (cd924c08): kobject_uevent_env
[    4.528318] kobject: 'tty2' (cd924c08): fill_kobj_path: path = '/devices/virtual/tty/tty2'
[    4.529587] device: 'tty3': device_add
[    4.530254] kobject: 'tty3' (cd924e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.531548] PM: Adding info for No Bus:tty3
[    4.532222] kobject: 'tty3' (cd924e08): kobject_uevent_env
[    4.533023] kobject: 'tty3' (cd924e08): fill_kobj_path: path = '/devices/virtual/tty/tty3'
[    4.534305] device: 'tty4': device_add
[    4.534936] kobject: 'tty4' (cd925008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.536223] PM: Adding info for No Bus:tty4
[    4.536893] kobject: 'tty4' (cd925008): kobject_uevent_env
[    4.537695] kobject: 'tty4' (cd925008): fill_kobj_path: path = '/devices/virtual/tty/tty4'
[    4.538976] device: 'tty5': device_add
[    4.539600] kobject: 'tty5' (cd925208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.540927] PM: Adding info for No Bus:tty5
[    4.541601] kobject: 'tty5' (cd925208): kobject_uevent_env
[    4.542400] kobject: 'tty5' (cd925208): fill_kobj_path: path = '/devices/virtual/tty/tty5'
[    4.543682] device: 'tty6': device_add
[    4.544312] kobject: 'tty6' (cd925408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.545602] PM: Adding info for No Bus:tty6
[    4.546274] kobject: 'tty6' (cd925408): kobject_uevent_env
[    4.547077] kobject: 'tty6' (cd925408): fill_kobj_path: path = '/devices/virtual/tty/tty6'
[    4.548364] device: 'tty7': device_add
[    4.548999] kobject: 'tty7' (cd925608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.550326] PM: Adding info for No Bus:tty7
[    4.551003] kobject: 'tty7' (cd925608): kobject_uevent_env
[    4.551801] kobject: 'tty7' (cd925608): fill_kobj_path: path = '/devices/virtual/tty/tty7'
[    4.553086] device: 'tty8': device_add
[    4.553713] kobject: 'tty8' (cd925808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.555012] PM: Adding info for No Bus:tty8
[    4.555685] kobject: 'tty8' (cd925808): kobject_uevent_env
[    4.556486] kobject: 'tty8' (cd925808): fill_kobj_path: path = '/devices/virtual/tty/tty8'
[    4.557768] device: 'tty9': device_add
[    4.558398] kobject: 'tty9' (cd925a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.559690] PM: Adding info for No Bus:tty9
[    4.560407] kobject: 'tty9' (cd925a08): kobject_uevent_env
[    4.561210] kobject: 'tty9' (cd925a08): fill_kobj_path: path = '/devices/virtual/tty/tty9'
[    4.562493] device: 'tty10': device_add
[    4.563131] kobject: 'tty10' (cd925c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.564426] PM: Adding info for No Bus:tty10
[    4.565109] kobject: 'tty10' (cd925c08): kobject_uevent_env
[    4.565920] kobject: 'tty10' (cd925c08): fill_kobj_path: path = '/devices/virtual/tty/tty10'
[    4.567217] device: 'tty11': device_add
[    4.567853] kobject: 'tty11' (cd925e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.569149] PM: Adding info for No Bus:tty11
[    4.569829] kobject: 'tty11' (cd925e08): kobject_uevent_env
[    4.570684] kobject: 'tty11' (cd925e08): fill_kobj_path: path = '/devices/virtual/tty/tty11'
[    4.571996] device: 'tty12': device_add
[    4.572633] kobject: 'tty12' (cd926008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.573931] PM: Adding info for No Bus:tty12
[    4.574610] kobject: 'tty12' (cd926008): kobject_uevent_env
[    4.575418] kobject: 'tty12' (cd926008): fill_kobj_path: path = '/devices/virtual/tty/tty12'
[    4.576727] device: 'tty13': device_add
[    4.577371] kobject: 'tty13' (cd926208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.578676] PM: Adding info for No Bus:tty13
[    4.579364] kobject: 'tty13' (cd926208): kobject_uevent_env
[    4.580227] kobject: 'tty13' (cd926208): fill_kobj_path: path = '/devices/virtual/tty/tty13'
[    4.581540] device: 'tty14': device_add
[    4.582185] kobject: 'tty14' (cd926408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.583493] PM: Adding info for No Bus:tty14
[    4.584182] kobject: 'tty14' (cd926408): kobject_uevent_env
[    4.585010] kobject: 'tty14' (cd926408): fill_kobj_path: path = '/devices/virtual/tty/tty14'
[    4.586320] device: 'tty15': device_add
[    4.586973] kobject: 'tty15' (cd926608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.588276] PM: Adding info for No Bus:tty15
[    4.588975] kobject: 'tty15' (cd926608): kobject_uevent_env
[    4.589782] kobject: 'tty15' (cd926608): fill_kobj_path: path = '/devices/virtual/tty/tty15'
[    4.591139] device: 'tty16': device_add
[    4.591779] kobject: 'tty16' (cd926808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.593095] PM: Adding info for No Bus:tty16
[    4.593777] kobject: 'tty16' (cd926808): kobject_uevent_env
[    4.594597] kobject: 'tty16' (cd926808): fill_kobj_path: path = '/devices/virtual/tty/tty16'
[    4.595909] device: 'tty17': device_add
[    4.596561] kobject: 'tty17' (cd926a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.597871] PM: Adding info for No Bus:tty17
[    4.598561] kobject: 'tty17' (cd926a08): kobject_uevent_env
[    4.599383] kobject: 'tty17' (cd926a08): fill_kobj_path: path = '/devices/virtual/tty/tty17'
[    4.600723] device: 'tty18': device_add
[    4.601377] kobject: 'tty18' (cd926c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.602683] PM: Adding info for No Bus:tty18
[    4.603372] kobject: 'tty18' (cd926c08): kobject_uevent_env
[    4.604190] kobject: 'tty18' (cd926c08): fill_kobj_path: path = '/devices/virtual/tty/tty18'
[    4.605490] device: 'tty19': device_add
[    4.606150] kobject: 'tty19' (cd926e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.607463] PM: Adding info for No Bus:tty19
[    4.608157] kobject: 'tty19' (cd926e08): kobject_uevent_env
[    4.608981] kobject: 'tty19' (cd926e08): fill_kobj_path: path = '/devices/virtual/tty/tty19'
[    4.610345] device: 'tty20': device_add
[    4.610985] kobject: 'tty20' (cd927008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.612281] PM: Adding info for No Bus:tty20
[    4.612977] kobject: 'tty20' (cd927008): kobject_uevent_env
[    4.613789] kobject: 'tty20' (cd927008): fill_kobj_path: path = '/devices/virtual/tty/tty20'
[    4.615103] device: 'tty21': device_add
[    4.615737] kobject: 'tty21' (cd927208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.617063] PM: Adding info for No Bus:tty21
[    4.617747] kobject: 'tty21' (cd927208): kobject_uevent_env
[    4.618571] kobject: 'tty21' (cd927208): fill_kobj_path: path = '/devices/virtual/tty/tty21'
[    4.619878] device: 'tty22': device_add
[    4.620565] kobject: 'tty22' (cd927408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.621875] PM: Adding info for No Bus:tty22
[    4.622562] kobject: 'tty22' (cd927408): kobject_uevent_env
[    4.623388] kobject: 'tty22' (cd927408): fill_kobj_path: path = '/devices/virtual/tty/tty22'
[    4.624683] device: 'tty23': device_add
[    4.625324] kobject: 'tty23' (cd927608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.626622] PM: Adding info for No Bus:tty23
[    4.627308] kobject: 'tty23' (cd927608): kobject_uevent_env
[    4.628117] kobject: 'tty23' (cd927608): fill_kobj_path: path = '/devices/virtual/tty/tty23'
[    4.629419] device: 'tty24': device_add
[    4.630098] kobject: 'tty24' (cd927808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.631417] PM: Adding info for No Bus:tty24
[    4.632109] kobject: 'tty24' (cd927808): kobject_uevent_env
[    4.632918] kobject: 'tty24' (cd927808): fill_kobj_path: path = '/devices/virtual/tty/tty24'
[    4.634227] device: 'tty25': device_add
[    4.634865] kobject: 'tty25' (cd927a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.636180] PM: Adding info for No Bus:tty25
[    4.636859] kobject: 'tty25' (cd927a08): kobject_uevent_env
[    4.637676] kobject: 'tty25' (cd927a08): fill_kobj_path: path = '/devices/virtual/tty/tty25'
[    4.638990] device: 'tty26': device_add
[    4.639629] kobject: 'tty26' (cd927c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.640985] PM: Adding info for No Bus:tty26
[    4.641667] kobject: 'tty26' (cd927c08): kobject_uevent_env
[    4.642479] kobject: 'tty26' (cd927c08): fill_kobj_path: path = '/devices/virtual/tty/tty26'
[    4.643780] device: 'tty27': device_add
[    4.644420] kobject: 'tty27' (cd927e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.645721] PM: Adding info for No Bus:tty27
[    4.648342] kobject: 'tty27' (cd927e08): kobject_uevent_env
[    4.649159] kobject: 'tty27' (cd927e08): fill_kobj_path: path = '/devices/virtual/tty/tty27'
[    4.650506] device: 'tty28': device_add
[    4.651155] kobject: 'tty28' (cd936008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.652451] PM: Adding info for No Bus:tty28
[    4.653143] kobject: 'tty28' (cd936008): kobject_uevent_env
[    4.653955] kobject: 'tty28' (cd936008): fill_kobj_path: path = '/devices/virtual/tty/tty28'
[    4.655259] device: 'tty29': device_add
[    4.655895] kobject: 'tty29' (cd936208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.657213] PM: Adding info for No Bus:tty29
[    4.657896] kobject: 'tty29' (cd936208): kobject_uevent_env
[    4.658712] kobject: 'tty29' (cd936208): fill_kobj_path: path = '/devices/virtual/tty/tty29'
[    4.660062] device: 'tty30': device_add
[    4.660702] kobject: 'tty30' (cd936408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.662014] PM: Adding info for No Bus:tty30
[    4.662692] kobject: 'tty30' (cd936408): kobject_uevent_env
[    4.663522] kobject: 'tty30' (cd936408): fill_kobj_path: path = '/devices/virtual/tty/tty30'
[    4.664824] device: 'tty31': device_add
[    4.665478] kobject: 'tty31' (cd936608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.666785] PM: Adding info for No Bus:tty31
[    4.667479] kobject: 'tty31' (cd936608): kobject_uevent_env
[    4.668292] kobject: 'tty31' (cd936608): fill_kobj_path: path = '/devices/virtual/tty/tty31'
[    4.669598] device: 'tty32': device_add
[    4.670280] kobject: 'tty32' (cd936808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.671587] PM: Adding info for No Bus:tty32
[    4.672277] kobject: 'tty32' (cd936808): kobject_uevent_env
[    4.673099] kobject: 'tty32' (cd936808): fill_kobj_path: path = '/devices/virtual/tty/tty32'
[    4.674397] device: 'tty33': device_add
[    4.675044] kobject: 'tty33' (cd936a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.676345] PM: Adding info for No Bus:tty33
[    4.677034] kobject: 'tty33' (cd936a08): kobject_uevent_env
[    4.677841] kobject: 'tty33' (cd936a08): fill_kobj_path: path = '/devices/virtual/tty/tty33'
[    4.679151] device: 'tty34': device_add
[    4.679784] kobject: 'tty34' (cd936c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.681133] PM: Adding info for No Bus:tty34
[    4.681812] kobject: 'tty34' (cd936c08): kobject_uevent_env
[    4.682627] kobject: 'tty34' (cd936c08): fill_kobj_path: path = '/devices/virtual/tty/tty34'
[    4.683931] device: 'tty35': device_add
[    4.684569] kobject: 'tty35' (cd936e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.685868] PM: Adding info for No Bus:tty35
[    4.686550] kobject: 'tty35' (cd936e08): kobject_uevent_env
[    4.687363] kobject: 'tty35' (cd936e08): fill_kobj_path: path = '/devices/virtual/tty/tty35'
[    4.688662] device: 'tty36': device_add
[    4.689308] kobject: 'tty36' (cd937008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.690643] PM: Adding info for No Bus:tty36
[    4.691330] kobject: 'tty36' (cd937008): kobject_uevent_env
[    4.692142] kobject: 'tty36' (cd937008): fill_kobj_path: path = '/devices/virtual/tty/tty36'
[    4.693441] device: 'tty37': device_add
[    4.694080] kobject: 'tty37' (cd937208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.695415] PM: Adding info for No Bus:tty37
[    4.696104] kobject: 'tty37' (cd937208): kobject_uevent_env
[    4.696911] kobject: 'tty37' (cd937208): fill_kobj_path: path = '/devices/virtual/tty/tty37'
[    4.698211] device: 'tty38': device_add
[    4.698847] kobject: 'tty38' (cd937408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.700194] PM: Adding info for No Bus:tty38
[    4.700875] kobject: 'tty38' (cd937408): kobject_uevent_env
[    4.701689] kobject: 'tty38' (cd937408): fill_kobj_path: path = '/devices/virtual/tty/tty38'
[    4.702991] device: 'tty39': device_add
[    4.703626] kobject: 'tty39' (cd937608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.704937] PM: Adding info for No Bus:tty39
[    4.705614] kobject: 'tty39' (cd937608): kobject_uevent_env
[    4.706427] kobject: 'tty39' (cd937608): fill_kobj_path: path = '/devices/virtual/tty/tty39'
[    4.707727] device: 'tty40': device_add
[    4.708372] kobject: 'tty40' (cd937808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.709680] PM: Adding info for No Bus:tty40
[    4.710404] kobject: 'tty40' (cd937808): kobject_uevent_env
[    4.711218] kobject: 'tty40' (cd937808): fill_kobj_path: path = '/devices/virtual/tty/tty40'
[    4.712515] device: 'tty41': device_add
[    4.713158] kobject: 'tty41' (cd937a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.714459] PM: Adding info for No Bus:tty41
[    4.715145] kobject: 'tty41' (cd937a08): kobject_uevent_env
[    4.715957] kobject: 'tty41' (cd937a08): fill_kobj_path: path = '/devices/virtual/tty/tty41'
[    4.717255] device: 'tty42': device_add
[    4.717890] kobject: 'tty42' (cd937c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.719192] PM: Adding info for No Bus:tty42
[    4.719873] kobject: 'tty42' (cd937c08): kobject_uevent_env
[    4.720726] kobject: 'tty42' (cd937c08): fill_kobj_path: path = '/devices/virtual/tty/tty42'
[    4.722027] device: 'tty43': device_add
[    4.722662] kobject: 'tty43' (cd937e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.723963] PM: Adding info for No Bus:tty43
[    4.724646] kobject: 'tty43' (cd937e08): kobject_uevent_env
[    4.725455] kobject: 'tty43' (cd937e08): fill_kobj_path: path = '/devices/virtual/tty/tty43'
[    4.726763] device: 'tty44': device_add
[    4.727413] kobject: 'tty44' (cd938008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.728717] PM: Adding info for No Bus:tty44
[    4.729400] kobject: 'tty44' (cd938008): kobject_uevent_env
[    4.730249] kobject: 'tty44' (cd938008): fill_kobj_path: path = '/devices/virtual/tty/tty44'
[    4.731540] device: 'tty45': device_add
[    4.732179] kobject: 'tty45' (cd938208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.733482] PM: Adding info for No Bus:tty45
[    4.734164] kobject: 'tty45' (cd938208): kobject_uevent_env
[    4.734975] kobject: 'tty45' (cd938208): fill_kobj_path: path = '/devices/virtual/tty/tty45'
[    4.736274] device: 'tty46': device_add
[    4.736909] kobject: 'tty46' (cd938408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.738216] PM: Adding info for No Bus:tty46
[    4.738892] kobject: 'tty46' (cd938408): kobject_uevent_env
[    4.739702] kobject: 'tty46' (cd938408): fill_kobj_path: path = '/devices/virtual/tty/tty46'
[    4.741041] device: 'tty47': device_add
[    4.741678] kobject: 'tty47' (cd938608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.742980] PM: Adding info for No Bus:tty47
[    4.743663] kobject: 'tty47' (cd938608): kobject_uevent_env
[    4.744482] kobject: 'tty47' (cd938608): fill_kobj_path: path = '/devices/virtual/tty/tty47'
[    4.745773] device: 'tty48': device_add
[    4.746413] kobject: 'tty48' (cd938808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.747706] PM: Adding info for No Bus:tty48
[    4.748390] kobject: 'tty48' (cd938808): kobject_uevent_env
[    4.749202] kobject: 'tty48' (cd938808): fill_kobj_path: path = '/devices/virtual/tty/tty48'
[    4.750550] device: 'tty49': device_add
[    4.751195] kobject: 'tty49' (cd938a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.752487] PM: Adding info for No Bus:tty49
[    4.753173] kobject: 'tty49' (cd938a08): kobject_uevent_env
[    4.753984] kobject: 'tty49' (cd938a08): fill_kobj_path: path = '/devices/virtual/tty/tty49'
[    4.755280] device: 'tty50': device_add
[    4.755914] kobject: 'tty50' (cd938c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.757216] PM: Adding info for No Bus:tty50
[    4.757894] kobject: 'tty50' (cd938c08): kobject_uevent_env
[    4.758707] kobject: 'tty50' (cd938c08): fill_kobj_path: path = '/devices/virtual/tty/tty50'
[    4.760039] device: 'tty51': device_add
[    4.760680] kobject: 'tty51' (cd938e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.761991] PM: Adding info for No Bus:tty51
[    4.762674] kobject: 'tty51' (cd938e08): kobject_uevent_env
[    4.763486] kobject: 'tty51' (cd938e08): fill_kobj_path: path = '/devices/virtual/tty/tty51'
[    4.764785] device: 'tty52': device_add
[    4.765428] kobject: 'tty52' (cd939008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.766717] PM: Adding info for No Bus:tty52
[    4.767401] kobject: 'tty52' (cd939008): kobject_uevent_env
[    4.768217] kobject: 'tty52' (cd939008): fill_kobj_path: path = '/devices/virtual/tty/tty52'
[    4.769511] device: 'tty53': device_add
[    4.770190] kobject: 'tty53' (cd939208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.773418] PM: Adding info for No Bus:tty53
[    4.774101] kobject: 'tty53' (cd939208): kobject_uevent_env
[    4.774906] kobject: 'tty53' (cd939208): fill_kobj_path: path = '/devices/virtual/tty/tty53'
[    4.776212] device: 'tty54': device_add
[    4.776850] kobject: 'tty54' (cd939408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.778145] PM: Adding info for No Bus:tty54
[    4.778826] kobject: 'tty54' (cd939408): kobject_uevent_env
[    4.779641] kobject: 'tty54' (cd939408): fill_kobj_path: path = '/devices/virtual/tty/tty54'
[    4.780975] device: 'tty55': device_add
[    4.781614] kobject: 'tty55' (cd939608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.782914] PM: Adding info for No Bus:tty55
[    4.783595] kobject: 'tty55' (cd939608): kobject_uevent_env
[    4.784405] kobject: 'tty55' (cd939608): fill_kobj_path: path = '/devices/virtual/tty/tty55'
[    4.785702] device: 'tty56': device_add
[    4.786351] kobject: 'tty56' (cd939808): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.787665] PM: Adding info for No Bus:tty56
[    4.788353] kobject: 'tty56' (cd939808): kobject_uevent_env
[    4.789166] kobject: 'tty56' (cd939808): fill_kobj_path: path = '/devices/virtual/tty/tty56'
[    4.790504] device: 'tty57': device_add
[    4.791147] kobject: 'tty57' (cd939a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.792449] PM: Adding info for No Bus:tty57
[    4.793130] kobject: 'tty57' (cd939a08): kobject_uevent_env
[    4.793942] kobject: 'tty57' (cd939a08): fill_kobj_path: path = '/devices/virtual/tty/tty57'
[    4.795239] device: 'tty58': device_add
[    4.795875] kobject: 'tty58' (cd939c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.797179] PM: Adding info for No Bus:tty58
[    4.797856] kobject: 'tty58' (cd939c08): kobject_uevent_env
[    4.798665] kobject: 'tty58' (cd939c08): fill_kobj_path: path = '/devices/virtual/tty/tty58'
[    4.799969] device: 'tty59': device_add
[    4.800645] kobject: 'tty59' (cd939e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.801950] PM: Adding info for No Bus:tty59
[    4.802633] kobject: 'tty59' (cd939e08): kobject_uevent_env
[    4.803448] kobject: 'tty59' (cd939e08): fill_kobj_path: path = '/devices/virtual/tty/tty59'
[    4.804759] device: 'tty60': device_add
[    4.805397] kobject: 'tty60' (cd93a008): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.806692] PM: Adding info for No Bus:tty60
[    4.807374] kobject: 'tty60' (cd93a008): kobject_uevent_env
[    4.808188] kobject: 'tty60' (cd93a008): fill_kobj_path: path = '/devices/virtual/tty/tty60'
[    4.809485] device: 'tty61': device_add
[    4.810167] kobject: 'tty61' (cd93a208): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.811471] PM: Adding info for No Bus:tty61
[    4.812156] kobject: 'tty61' (cd93a208): kobject_uevent_env
[    4.812969] kobject: 'tty61' (cd93a208): fill_kobj_path: path = '/devices/virtual/tty/tty61'
[    4.814262] device: 'tty62': device_add
[    4.814897] kobject: 'tty62' (cd93a408): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.816207] PM: Adding info for No Bus:tty62
[    4.816884] kobject: 'tty62' (cd93a408): kobject_uevent_env
[    4.817698] kobject: 'tty62' (cd93a408): fill_kobj_path: path = '/devices/virtual/tty/tty62'
[    4.819002] device: 'tty63': device_add
[    4.819638] kobject: 'tty63' (cd93a608): kobject_add_internal: parent: 'tty', set: 'devices'
[    4.820979] PM: Adding info for No Bus:tty63
[    4.821664] kobject: 'tty63' (cd93a608): kobject_uevent_env
[    4.822470] kobject: 'tty63' (cd93a608): fill_kobj_path: path = '/devices/virtual/tty/tty63'
[    4.823810] device class 'firmware': registering
[    4.824537] kobject: 'firmware' (cd911c0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.825860] kobject: 'firmware' (cd911c0c): kobject_uevent_env
[    4.826697] kobject: 'firmware' (cd911c0c): fill_kobj_path: path = '/class/firmware'
[    4.827931] kobject: 'pcmcia' (cd911d0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.829200] kobject: 'pcmcia' (cd911d0c): kobject_uevent_env
[    4.830054] kobject: 'pcmcia' (cd911d0c): fill_kobj_path: path = '/bus/pcmcia'
[    4.831228] kobject: 'devices' (cd9307cc): kobject_add_internal: parent: 'pcmcia', set: '<NULL>'
[    4.832553] kobject: 'devices' (cd9307cc): kobject_uevent_env
[    4.833380] kobject: 'devices' (cd9307cc): kobject_uevent_env: filter function caused the event to drop!
[    4.834772] kobject: 'drivers' (cd93084c): kobject_add_internal: parent: 'pcmcia', set: '<NULL>'
[    4.836105] kobject: 'drivers' (cd93084c): kobject_uevent_env
[    4.836934] kobject: 'drivers' (cd93084c): kobject_uevent_env: filter function caused the event to drop!
[    4.838329] bus: 'pcmcia': registered
[    4.838959] device class 'thermal': registering
[    4.839665] kobject: 'thermal' (cd911e0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.841017] kobject: 'thermal' (cd911e0c): kobject_uevent_env
[    4.841846] kobject: 'thermal' (cd911e0c): fill_kobj_path: path = '/class/thermal'
[    4.877669] kobject: 'ssb' (cd911f0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.878934] kobject: 'ssb' (cd911f0c): kobject_uevent_env
[    4.879724] kobject: 'ssb' (cd911f0c): fill_kobj_path: path = '/bus/ssb'
[    4.880687] kobject: 'devices' (cd930a0c): kobject_add_internal: parent: 'ssb', set: '<NULL>'
[    4.881997] kobject: 'devices' (cd930a0c): kobject_uevent_env
[    4.882824] kobject: 'devices' (cd930a0c): kobject_uevent_env: filter function caused the event to drop!
[    4.884223] kobject: 'drivers' (cd930a8c): kobject_add_internal: parent: 'ssb', set: '<NULL>'
[    4.885531] kobject: 'drivers' (cd930a8c): kobject_uevent_env
[    4.886351] kobject: 'drivers' (cd930a8c): kobject_uevent_env: filter function caused the event to drop!
[    4.887751] bus: 'ssb': registered
[    4.888376] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    4.889186] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    4.890132] NET: Registered protocol family 1
[    4.890860] pci 0000:00:00.0: calling quirk_natoma+0x0/0x2b
[    4.891684] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    4.892538] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x80
[    4.893439] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    4.894281] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e
[    4.895150] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    4.896035] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x9d
[    4.896871] pci 0000:00:02.0: Boot video device
[    4.897587] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x172
[    4.898530] PCI: CLS 0 bytes, default 64
[    4.899271] Unpacking initramfs...
[    5.418141] Freeing initrd memory: 25284k freed
[    5.425239] doing device, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    5.429684] doing device: hung_task_panic='1'
[    5.430448] doing device: bisect-reboot='(null)'
[    5.431187] doing device: i386-randconfig-b064='(null)'
[    5.431979] doing device: branch='mfd/for-next'
[    5.432703] doing device: dyndbg='+p'
[    5.433341] doing device: log_buf_len='8M'
[    5.434027] doing device: ignore_loglevel='(null)'
[    5.434772] doing device: debug='(null)'
[    5.435438] doing device: sched_debug='(null)'
[    5.436153] doing device: apic='debug'
[    5.436796] doing device: dynamic_printk='(null)'
[    5.437543] doing device: sysrq_always_enabled='(null)'
[    5.438337] doing device: prompt_ramdisk='0'
[    5.439034] doing device: console='ttyS0,115200'
[    5.439762] doing device: console='tty0'
[    5.440465] doing device: vga='normal'
[    5.441115] doing device: root='/dev/ram0'
[    5.441791] doing device: rw='(null)'
[    5.442433] doing device: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    5.443488] kvm: no hardware support
[    5.444219] kobject: 'cache' (c90e2080): kobject_add_internal: parent: 'cpu0', set: '<NULL>'
[    5.445523] kobject: 'index0' (cd8a89c0): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    5.446842] kobject: 'index0' (cd8a89c0): kobject_uevent_env
[    5.447660] kobject: 'index0' (cd8a89c0): kobject_uevent_env: filter function caused the event to drop!
[    5.449046] kobject: 'index1' (cd8a89ec): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    5.450395] kobject: 'index1' (cd8a89ec): kobject_uevent_env
[    5.451216] kobject: 'index1' (cd8a89ec): kobject_uevent_env: filter function caused the event to drop!
[    5.452601] kobject: 'index2' (cd8a8a18): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    5.453910] kobject: 'index2' (cd8a8a18): kobject_uevent_env
[    5.454731] kobject: 'index2' (cd8a8a18): kobject_uevent_env: filter function caused the event to drop!
[    5.456119] kobject: 'cache' (c90e2080): kobject_uevent_env
[    5.456920] kobject: 'cache' (c90e2080): kobject_uevent_env: filter function caused the event to drop!
[    5.458352] kobject: 'cache' (c90e2880): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
[    5.461695] kobject: 'index0' (cd8a8a80): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    5.463027] kobject: 'index0' (cd8a8a80): kobject_uevent_env
[    5.463845] kobject: 'index0' (cd8a8a80): kobject_uevent_env: filter function caused the event to drop!
[    5.465242] kobject: 'index1' (cd8a8aac): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    5.466549] kobject: 'index1' (cd8a8aac): kobject_uevent_env
[    5.467366] kobject: 'index1' (cd8a8aac): kobject_uevent_env: filter function caused the event to drop!
[    5.468747] kobject: 'index2' (cd8a8ad8): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    5.470104] kobject: 'index2' (cd8a8ad8): kobject_uevent_env
[    5.470920] kobject: 'index2' (cd8a8ad8): kobject_uevent_env: filter function caused the event to drop!
[    5.472343] kobject: 'cache' (c90e2880): kobject_uevent_env
[    5.473161] kobject: 'cache' (c90e2880): kobject_uevent_env: filter function caused the event to drop!
[    5.474557] device class 'msr': registering
[    5.475234] kobject: 'msr' (c921400c): kobject_add_internal: parent: 'class', set: 'class'
[    5.476511] kobject: 'msr' (c921400c): kobject_uevent_env
[    5.477304] kobject: 'msr' (c921400c): fill_kobj_path: path = '/class/msr'
[    5.478257] device: 'msr0': device_add
[    5.478885] kobject: 'msr' (c9958140): kobject_add_internal: parent: 'virtual', set: '(null)'
[    5.480235] kobject: 'msr0' (cd93b008): kobject_add_internal: parent: 'msr', set: 'devices'
[    5.481534] PM: Adding info for No Bus:msr0
[    5.482211] kobject: 'msr0' (cd93b008): kobject_uevent_env
[    5.483016] kobject: 'msr0' (cd93b008): fill_kobj_path: path = '/devices/virtual/msr/msr0'
[    5.484301] device: 'msr1': device_add
[    5.484932] kobject: 'msr1' (cd93b208): kobject_add_internal: parent: 'msr', set: 'devices'
[    5.486221] PM: Adding info for No Bus:msr1
[    5.486897] kobject: 'msr1' (cd93b208): kobject_uevent_env
[    5.487704] kobject: 'msr1' (cd93b208): fill_kobj_path: path = '/devices/virtual/msr/msr1'
[    5.488993] device class 'cpuid': registering
[    5.489683] kobject: 'cpuid' (c921410c): kobject_add_internal: parent: 'class', set: 'class'
[    5.491022] kobject: 'cpuid' (c921410c): kobject_uevent_env
[    5.491833] kobject: 'cpuid' (c921410c): fill_kobj_path: path = '/class/cpuid'
[    5.493010] device: 'cpu0': device_add
[    5.493640] kobject: 'cpuid' (c9958880): kobject_add_internal: parent: 'virtual', set: '(null)'
[    5.494960] kobject: 'cpu0' (cd93b408): kobject_add_internal: parent: 'cpuid', set: 'devices'
[    5.496275] PM: Adding info for No Bus:cpu0
[    5.496947] kobject: 'cpu0' (cd93b408): kobject_uevent_env
[    5.497748] kobject: 'cpu0' (cd93b408): fill_kobj_path: path = '/devices/virtual/cpuid/cpu0'
[    5.499048] device: 'cpu1': device_add
[    5.499674] kobject: 'cpu1' (cd93b608): kobject_add_internal: parent: 'cpuid', set: 'devices'
[    5.501026] PM: Adding info for No Bus:cpu1
[    5.501699] kobject: 'cpu1' (cd93b608): kobject_uevent_env
[    5.502506] kobject: 'cpu1' (cd93b608): fill_kobj_path: path = '/devices/virtual/cpuid/cpu1'
[    5.503819] apm: BIOS not found.
[    5.504409] Registering platform device 'pcspkr'. Parent at platform
[    5.505297] device: 'pcspkr': device_add
[    5.505950] kobject: 'pcspkr' (cd93b810): kobject_add_internal: parent: 'platform', set: 'devices'
[    5.507301] bus: 'platform': add device pcspkr
[    5.508005] PM: Adding info for platform:pcspkr
[    5.508711] kobject: 'pcspkr' (cd93b810): kobject_uevent_env
[    5.509533] kobject: 'pcspkr' (cd93b810): fill_kobj_path: path = '/devices/platform/pcspkr'
[    5.510863] Registering platform device 'microcode'. Parent at platform
[    5.511781] device: 'microcode': device_add
[    5.512454] kobject: 'microcode' (cd93ba10): kobject_add_internal: parent: 'platform', set: 'devices'
[    5.513834] bus: 'platform': add device microcode
[    5.514562] PM: Adding info for platform:microcode
[    5.515295] kobject: 'microcode' (cd93ba10): kobject_uevent_env
[    5.516140] kobject: 'microcode' (cd93ba10): fill_kobj_path: path = '/devices/platform/microcode'
[    5.517479] microcode: CPU0 added
[    5.518075] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    5.518881] microcode: CPU1 added
[    5.519524] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    5.521091] device: 'microcode': device_add
[    5.521768] kobject: 'microcode' (cd93bc08): kobject_add_internal: parent: 'misc', set: 'devices'
[    5.523117] PM: Adding info for No Bus:microcode
[    5.523826] kobject: 'microcode' (cd93bc08): kobject_uevent_env
[    5.524673] kobject: 'microcode' (cd93bc08): fill_kobj_path: path = '/devices/virtual/misc/microcode'
[    5.526045] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.527588] debugfs: creating file 'kernel_page_tables'
[    5.528807] kobject: 'clocksource' (c921420c): kobject_add_internal: parent: 'bus', set: 'bus'
[    5.530230] kobject: 'clocksource' (c921420c): kobject_uevent_env
[    5.531097] kobject: 'clocksource' (c921420c): fill_kobj_path: path = '/bus/clocksource'
[    5.532358] kobject: 'devices' (cd34184c): kobject_add_internal: parent: 'clocksource', set: '<NULL>'
[    5.533725] kobject: 'devices' (cd34184c): kobject_uevent_env
[    5.534552] kobject: 'devices' (cd34184c): kobject_uevent_env: filter function caused the event to drop!
[    5.535958] kobject: 'drivers' (cd3418cc): kobject_add_internal: parent: 'clocksource', set: '<NULL>'
[    5.537328] kobject: 'drivers' (cd3418cc): kobject_uevent_env
[    5.538162] kobject: 'drivers' (cd3418cc): kobject_uevent_env: filter function caused the event to drop!
[    5.539556] bus: 'clocksource': registered
[    5.540354] device: 'clocksource': device_add
[    5.541047] kobject: 'clocksource' (cd93be08): kobject_add_internal: parent: 'system', set: 'devices'
[    5.542431] PM: Adding info for No Bus:clocksource
[    5.543164] kobject: 'clocksource' (cd93be08): kobject_uevent_env
[    5.544021] kobject: 'clocksource' (cd93be08): kobject_uevent_env: filter function caused the event to drop!
[    5.545450] device: 'clocksource0': device_add
[    5.546150] kobject: 'clocksource0' (c1930be8): kobject_add_internal: parent: 'clocksource', set: 'devices'
[    5.547572] bus: 'clocksource': add device clocksource0
[    5.548351] PM: Adding info for clocksource:clocksource0
[    5.549136] kobject: 'clocksource0' (c1930be8): kobject_uevent_env
[    5.550042] kobject: 'clocksource0' (c1930be8): fill_kobj_path: path = '/devices/system/clocksource/clocksource0'
[    5.551553] bus: 'platform': add driver alarmtimer
[    5.552287] kobject: 'alarmtimer' (cd92dd80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    5.553662] kobject: 'alarmtimer' (cd92dd80): kobject_uevent_env
[    5.554522] kobject: 'alarmtimer' (cd92dd80): fill_kobj_path: path = '/bus/platform/drivers/alarmtimer'
[    5.555921] Registering platform device 'alarmtimer'. Parent at platform
[    5.556835] device: 'alarmtimer': device_add
[    5.557517] kobject: 'alarmtimer' (cd940010): kobject_add_internal: parent: 'platform', set: 'devices'
[    5.558898] bus: 'platform': add device alarmtimer
[    5.559638] PM: Adding info for platform:alarmtimer
[    5.560475] kobject: 'alarmtimer' (cd940010): kobject_uevent_env
[    5.561334] kobject: 'alarmtimer' (cd940010): fill_kobj_path: path = '/devices/platform/alarmtimer'
[    5.562694] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    5.564041] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    5.565328] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    5.566283] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    5.567546] kobject: 'rttest' (c921430c): kobject_add_internal: parent: 'bus', set: 'bus'
[    5.568815] kobject: 'rttest' (c921430c): kobject_uevent_env
[    5.569628] kobject: 'rttest' (c921430c): fill_kobj_path: path = '/bus/rttest'
[    5.570892] kobject: 'devices' (c93b330c): kobject_add_internal: parent: 'rttest', set: '<NULL>'
[    5.572223] kobject: 'devices' (c93b330c): kobject_uevent_env
[    5.573056] kobject: 'devices' (c93b330c): kobject_uevent_env: filter function caused the event to drop!
[    5.574454] kobject: 'drivers' (c93b338c): kobject_add_internal: parent: 'rttest', set: '<NULL>'
[    5.575778] kobject: 'drivers' (c93b338c): kobject_uevent_env
[    5.576608] kobject: 'drivers' (c93b338c): kobject_uevent_env: filter function caused the event to drop!
[    5.578010] bus: 'rttest': registered
[    5.578628] device: 'rttest': device_add
[    5.579271] kobject: 'rttest' (cd940208): kobject_add_internal: parent: 'system', set: 'devices'
[    5.580700] PM: Adding info for No Bus:rttest
[    5.581394] kobject: 'rttest' (cd940208): kobject_uevent_env
[    5.582214] kobject: 'rttest' (cd940208): kobject_uevent_env: filter function caused the event to drop!
[    5.583797] device: 'rttest0': device_add
[    5.584473] kobject: 'rttest0' (c1a5adf4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.585812] bus: 'rttest': add device rttest0
[    5.586512] PM: Adding info for rttest:rttest0
[    5.587216] kobject: 'rttest0' (c1a5adf4): kobject_uevent_env
[    5.588044] kobject: 'rttest0' (c1a5adf4): fill_kobj_path: path = '/devices/system/rttest/rttest0'
[    5.589555] device: 'rttest1': device_add
[    5.590269] kobject: 'rttest1' (c1a5af6c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.593545] bus: 'rttest': add device rttest1
[    5.594243] PM: Adding info for rttest:rttest1
[    5.594939] kobject: 'rttest1' (c1a5af6c): kobject_uevent_env
[    5.595759] kobject: 'rttest1' (c1a5af6c): fill_kobj_path: path = '/devices/system/rttest/rttest1'
[    5.597303] device: 'rttest2': device_add
[    5.597996] kobject: 'rttest2' (c1a5b0e4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.599339] bus: 'rttest': add device rttest2
[    5.600073] PM: Adding info for rttest:rttest2
[    5.600767] kobject: 'rttest2' (c1a5b0e4): kobject_uevent_env
[    5.601599] kobject: 'rttest2' (c1a5b0e4): fill_kobj_path: path = '/devices/system/rttest/rttest2'
[    5.603131] device: 'rttest3': device_add
[    5.603812] kobject: 'rttest3' (c1a5b25c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.605157] bus: 'rttest': add device rttest3
[    5.605847] PM: Adding info for rttest:rttest3
[    5.606551] kobject: 'rttest3' (c1a5b25c): kobject_uevent_env
[    5.607377] kobject: 'rttest3' (c1a5b25c): fill_kobj_path: path = '/devices/system/rttest/rttest3'
[    5.608911] device: 'rttest4': device_add
[    5.609586] kobject: 'rttest4' (c1a5b3d4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.610966] bus: 'rttest': add device rttest4
[    5.611661] PM: Adding info for rttest:rttest4
[    5.612361] kobject: 'rttest4' (c1a5b3d4): kobject_uevent_env
[    5.613191] kobject: 'rttest4' (c1a5b3d4): fill_kobj_path: path = '/devices/system/rttest/rttest4'
[    5.614706] device: 'rttest5': device_add
[    5.615415] kobject: 'rttest5' (c1a5b54c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.616755] bus: 'rttest': add device rttest5
[    5.617452] PM: Adding info for rttest:rttest5
[    5.618162] kobject: 'rttest5' (c1a5b54c): kobject_uevent_env
[    5.618988] kobject: 'rttest5' (c1a5b54c): fill_kobj_path: path = '/devices/system/rttest/rttest5'
[    5.620536] device: 'rttest6': device_add
[    5.621238] kobject: 'rttest6' (c1a5b6c4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.622574] bus: 'rttest': add device rttest6
[    5.623266] PM: Adding info for rttest:rttest6
[    5.623969] kobject: 'rttest6' (c1a5b6c4): kobject_uevent_env
[    5.624791] kobject: 'rttest6' (c1a5b6c4): fill_kobj_path: path = '/devices/system/rttest/rttest6'
[    5.626800] device: 'rttest7': device_add
[    5.628386] kobject: 'rttest7' (c1a5b83c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    5.629732] bus: 'rttest': add device rttest7
[    5.630475] PM: Adding info for rttest:rttest7
[    5.631182] kobject: 'rttest7' (c1a5b83c): kobject_uevent_env
[    5.632017] kobject: 'rttest7' (c1a5b83c): fill_kobj_path: path = '/devices/system/rttest/rttest7'
[    5.633377] Initializing RT-Tester: OK
[    5.634058] audit: initializing netlink socket (disabled)
[    5.634870] type=2000 audit(1348646516.630:1): initialized
[    5.635832] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    5.641528] kobject: 'event_source' (c921440c): kobject_add_internal: parent: 'bus', set: 'bus'
[    5.642957] kobject: 'event_source' (c921440c): kobject_uevent_env
[    5.643838] kobject: 'event_source' (c921440c): fill_kobj_path: path = '/bus/event_source'
[    5.645141] kobject: 'devices' (c9ac640c): kobject_add_internal: parent: 'event_source', set: '<NULL>'
[    5.646543] kobject: 'devices' (c9ac640c): kobject_uevent_env
[    5.647376] kobject: 'devices' (c9ac640c): kobject_uevent_env: filter function caused the event to drop!
[    5.648782] kobject: 'drivers' (c9ac648c): kobject_add_internal: parent: 'event_source', set: '<NULL>'
[    5.650312] kobject: 'drivers' (c9ac648c): kobject_uevent_env
[    5.651169] kobject: 'drivers' (c9ac648c): kobject_uevent_env: filter function caused the event to drop!
[    5.652604] bus: 'event_source': registered
[    5.653345] device: 'breakpoint': device_add
[    5.654064] kobject: 'breakpoint' (cd940608): kobject_add_internal: parent: 'devices', set: 'devices'
[    5.655470] bus: 'event_source': add device breakpoint
[    5.656283] PM: Adding info for event_source:breakpoint
[    5.657089] kobject: 'breakpoint' (cd940608): kobject_uevent_env
[    5.658000] kobject: 'breakpoint' (cd940608): fill_kobj_path: path = '/devices/breakpoint'
[    5.659310] device: 'software': device_add
[    5.660088] kobject: 'software' (cd940808): kobject_add_internal: parent: 'devices', set: 'devices'
[    5.661468] bus: 'event_source': add device software
[    5.662259] PM: Adding info for event_source:software
[    5.663051] kobject: 'software' (cd940808): kobject_uevent_env
[    5.663911] kobject: 'software' (cd940808): fill_kobj_path: path = '/devices/software'
[    5.665566] kobject: 'mm' (c9ac6b40): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    5.666925] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    5.667838] kobject: 'hugepages' (c9ac6bc0): kobject_add_internal: parent: 'mm', set: '<NULL>'
[    5.669214] kobject: 'hugepages-4096kB' (c9ac6c40): kobject_add_internal: parent: 'hugepages', set: '<NULL>'
[    5.670834] kobject: 'slab' (c9ac6e0c): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    5.672181] kobject: 'slab' (c9ac6e0c): kobject_uevent_env
[    5.673009] kobject: 'slab' (c9ac6e0c): kobject_uevent_env: attempted to send uevent without kset!
[    5.674381] kobject: ':t-0000040' (cd8d43cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.675736] kobject: ':t-0000040' (cd8d43cc): kobject_uevent_env
[    5.676623] kobject: ':t-0000040' (cd8d43cc): fill_kobj_path: path = '/kernel/slab/:t-0000040'
[    5.677970] kobject: ':t-0001048' (cd847e4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.679357] kobject: ':t-0001048' (cd847e4c): kobject_uevent_env
[    5.680312] kobject: ':t-0001048' (cd847e4c): fill_kobj_path: path = '/kernel/slab/:t-0001048'
[    5.681702] kobject: ':t-0000216' (cd847dcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.683078] kobject: ':t-0000216' (cd847dcc): kobject_uevent_env
[    5.683970] kobject: ':t-0000216' (cd847dcc): fill_kobj_path: path = '/kernel/slab/:t-0000216'
[    5.685318] kobject: ':t-0003072' (cd847bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.686658] kobject: ':t-0003072' (cd847bcc): kobject_uevent_env
[    5.687517] kobject: ':t-0003072' (cd847bcc): fill_kobj_path: path = '/kernel/slab/:t-0003072'
[    5.688854] kobject: ':t-0001536' (cd847b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.690350] kobject: ':t-0001536' (cd847b4c): kobject_uevent_env
[    5.691317] kobject: ':t-0001536' (cd847b4c): fill_kobj_path: path = '/kernel/slab/:t-0001536'
[    5.692652] kobject: ':t-0000768' (cd847acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.694081] kobject: ':t-0000768' (cd847acc): kobject_uevent_env
[    5.694939] kobject: ':t-0000768' (cd847acc): fill_kobj_path: path = '/kernel/slab/:t-0000768'
[    5.696318] kobject: ':t-0003200' (cd847a4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.697695] kobject: ':t-0003200' (cd847a4c): kobject_uevent_env
[    5.698612] kobject: ':t-0003200' (cd847a4c): fill_kobj_path: path = '/kernel/slab/:t-0003200'
[    5.699953] kobject: ':t-0001664' (cd8479cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.701397] kobject: ':t-0001664' (cd8479cc): kobject_uevent_env
[    5.702257] kobject: ':t-0001664' (cd8479cc): fill_kobj_path: path = '/kernel/slab/:t-0001664'
[    5.703588] kobject: ':t-0000896' (cd84794c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.705002] kobject: ':t-0000896' (cd84794c): kobject_uevent_env
[    5.705860] kobject: ':t-0000896' (cd84794c): fill_kobj_path: path = '/kernel/slab/:t-0000896'
[    5.707221] kobject: 'sock_inode_cache' (cd8472cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.708636] kobject: 'sock_inode_cache' (cd8472cc): kobject_uevent_env
[    5.709561] kobject: 'sock_inode_cache' (cd8472cc): fill_kobj_path: path = '/kernel/slab/sock_inode_cache'
[    5.711186] kobject: ':t-0000384' (cd84724c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.712543] kobject: ':t-0000384' (cd84724c): kobject_uevent_env
[    5.713407] kobject: ':t-0000384' (cd84724c): fill_kobj_path: path = '/kernel/slab/:t-0000384'
[    5.714712] kobject: ':t-0000112' (cd84714c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.716056] kobject: ':t-0000112' (cd84714c): kobject_uevent_env
[    5.716900] kobject: ':t-0000112' (cd84714c): fill_kobj_path: path = '/kernel/slab/:t-0000112'
[    5.718235] kobject: 'shmem_inode_cache' (cd83f84c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.719711] kobject: 'shmem_inode_cache' (cd83f84c): kobject_uevent_env
[    5.720714] kobject: 'shmem_inode_cache' (cd83f84c): fill_kobj_path: path = '/kernel/slab/shmem_inode_cache'
[    5.722162] kobject: ':t-0000048' (cd806bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.723509] kobject: ':t-0000048' (cd806bcc): kobject_uevent_env
[    5.724380] kobject: ':t-0000048' (cd806bcc): fill_kobj_path: path = '/kernel/slab/:t-0000048'
[    5.725740] kobject: ':t-0000080' (cd806b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.727112] kobject: ':t-0000080' (cd806b4c): kobject_uevent_env
[    5.728008] kobject: ':t-0000080' (cd806b4c): fill_kobj_path: path = '/kernel/slab/:t-0000080'
[    5.731420] kobject: ':t-0000328' (cd806acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.732790] kobject: ':t-0000328' (cd806acc): kobject_uevent_env
[    5.733666] kobject: ':t-0000328' (cd806acc): fill_kobj_path: path = '/kernel/slab/:t-0000328'
[    5.735018] kobject: 'proc_inode_cache' (cd80694c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.736467] kobject: 'proc_inode_cache' (cd80694c): kobject_uevent_env
[    5.737414] kobject: 'proc_inode_cache' (cd80694c): fill_kobj_path: path = '/kernel/slab/proc_inode_cache'
[    5.738843] kobject: ':t-0000144' (cd8068cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.740303] kobject: ':t-0000144' (cd8068cc): kobject_uevent_env
[    5.741182] kobject: ':t-0000144' (cd8068cc): fill_kobj_path: path = '/kernel/slab/:t-0000144'
[    5.742496] kobject: 'bdev_cache' (cd80684c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.743863] kobject: 'bdev_cache' (cd80684c): kobject_uevent_env
[    5.744726] kobject: 'bdev_cache' (cd80684c): fill_kobj_path: path = '/kernel/slab/bdev_cache'
[    5.746072] kobject: 'inode_cache' (cd80654c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.747444] kobject: 'inode_cache' (cd80654c): kobject_uevent_env
[    5.748344] kobject: 'inode_cache' (cd80654c): fill_kobj_path: path = '/kernel/slab/inode_cache'
[    5.749734] kobject: ':at-0000128' (cd8064cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.751193] kobject: ':at-0000128' (cd8064cc): kobject_uevent_env
[    5.752065] kobject: ':at-0000128' (cd8064cc): fill_kobj_path: path = '/kernel/slab/:at-0000128'
[    5.753399] kobject: ':at-0000056' (cd80644c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.754763] kobject: ':at-0000056' (cd80644c): kobject_uevent_env
[    5.755678] kobject: ':at-0000056' (cd80644c): fill_kobj_path: path = '/kernel/slab/:at-0000056'
[    5.757092] kobject: ':t-0000088' (cd8063cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.758453] kobject: ':t-0000088' (cd8063cc): kobject_uevent_env
[    5.759323] kobject: ':t-0000088' (cd8063cc): fill_kobj_path: path = '/kernel/slab/:t-0000088'
[    5.760829] kobject: ':t-0000640' (cd80634c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.762337] kobject: ':t-0000640' (cd80634c): kobject_uevent_env
[    5.763198] kobject: ':t-0000640' (cd80634c): fill_kobj_path: path = '/kernel/slab/:t-0000640'
[    5.764562] kobject: 'sighand_cache' (cd8062cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.765973] kobject: 'sighand_cache' (cd8062cc): kobject_uevent_env
[    5.766873] kobject: 'sighand_cache' (cd8062cc): fill_kobj_path: path = '/kernel/slab/sighand_cache'
[    5.768272] kobject: ':t-0003136' (cd80624c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.769641] kobject: ':t-0003136' (cd80624c): kobject_uevent_env
[    5.770654] kobject: ':t-0003136' (cd80624c): fill_kobj_path: path = '/kernel/slab/:t-0003136'
[    5.772004] kobject: 'anon_vma' (cd8061cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.773343] kobject: 'anon_vma' (cd8061cc): kobject_uevent_env
[    5.774192] kobject: 'anon_vma' (cd8061cc): fill_kobj_path: path = '/kernel/slab/anon_vma'
[    5.775485] kobject: ':t-0000024' (cd80614c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.776831] kobject: ':t-0000024' (cd80614c): kobject_uevent_env
[    5.777693] kobject: ':t-0000024' (cd80614c): fill_kobj_path: path = '/kernel/slab/:t-0000024'
[    5.779017] kobject: 'radix_tree_node' (cd8060cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.780520] kobject: 'radix_tree_node' (cd8060cc): kobject_uevent_env
[    5.781458] kobject: 'radix_tree_node' (cd8060cc): fill_kobj_path: path = '/kernel/slab/radix_tree_node'
[    5.782941] kobject: ':t-0000152' (cd80604c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.784340] kobject: ':t-0000152' (cd80604c): kobject_uevent_env
[    5.785197] kobject: ':t-0000152' (cd80604c): fill_kobj_path: path = '/kernel/slab/:t-0000152'
[    5.786509] kobject: ':dt-0008192' (cd802dcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.787871] kobject: ':dt-0008192' (cd802dcc): kobject_uevent_env
[    5.788770] kobject: ':dt-0008192' (cd802dcc): fill_kobj_path: path = '/kernel/slab/:dt-0008192'
[    5.790193] kobject: ':dt-0004096' (cd802d4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.791668] kobject: ':dt-0004096' (cd802d4c): kobject_uevent_env
[    5.792575] kobject: ':dt-0004096' (cd802d4c): fill_kobj_path: path = '/kernel/slab/:dt-0004096'
[    5.793919] kobject: ':dt-0002048' (cd802ccc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.795310] kobject: ':dt-0002048' (cd802ccc): kobject_uevent_env
[    5.796197] kobject: ':dt-0002048' (cd802ccc): fill_kobj_path: path = '/kernel/slab/:dt-0002048'
[    5.797534] kobject: ':dt-0001024' (cd802c4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.798920] kobject: ':dt-0001024' (cd802c4c): kobject_uevent_env
[    5.799825] kobject: ':dt-0001024' (cd802c4c): fill_kobj_path: path = '/kernel/slab/:dt-0001024'
[    5.801283] kobject: ':dt-0000512' (cd802bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.802695] kobject: ':dt-0000512' (cd802bcc): kobject_uevent_env
[    5.803590] kobject: ':dt-0000512' (cd802bcc): fill_kobj_path: path = '/kernel/slab/:dt-0000512'
[    5.804951] kobject: ':dt-0000256' (cd802b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.806339] kobject: ':dt-0000256' (cd802b4c): kobject_uevent_env
[    5.807213] kobject: ':dt-0000256' (cd802b4c): fill_kobj_path: path = '/kernel/slab/:dt-0000256'
[    5.808597] kobject: ':dt-0000128' (cd802acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.809997] kobject: ':dt-0000128' (cd802acc): kobject_uevent_env
[    5.811017] kobject: ':dt-0000128' (cd802acc): fill_kobj_path: path = '/kernel/slab/:dt-0000128'
[    5.812414] kobject: ':dt-0000064' (cd802a4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.813786] kobject: ':dt-0000064' (cd802a4c): kobject_uevent_env
[    5.814675] kobject: ':dt-0000064' (cd802a4c): fill_kobj_path: path = '/kernel/slab/:dt-0000064'
[    5.816051] kobject: ':dt-0000032' (cd8029cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.817479] kobject: ':dt-0000032' (cd8029cc): kobject_uevent_env
[    5.818380] kobject: ':dt-0000032' (cd8029cc): fill_kobj_path: path = '/kernel/slab/:dt-0000032'
[    5.819761] kobject: ':dt-0000016' (cd80294c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.821515] kobject: ':dt-0000016' (cd80294c): kobject_uevent_env
[    5.823036] kobject: ':dt-0000016' (cd80294c): fill_kobj_path: path = '/kernel/slab/:dt-0000016'
[    5.825406] kobject: ':dt-0000008' (cd8028cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.827768] kobject: ':dt-0000008' (cd8028cc): kobject_uevent_env
[    5.829313] kobject: ':dt-0000008' (cd8028cc): fill_kobj_path: path = '/kernel/slab/:dt-0000008'
[    5.831815] kobject: ':dt-0000192' (cd80284c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.834218] kobject: ':dt-0000192' (cd80284c): kobject_uevent_env
[    5.835735] kobject: ':dt-0000192' (cd80284c): fill_kobj_path: path = '/kernel/slab/:dt-0000192'
[    5.838085] kobject: ':dt-0000096' (cd8027cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.840559] kobject: ':dt-0000096' (cd8027cc): kobject_uevent_env
[    5.842200] kobject: ':dt-0000096' (cd8027cc): fill_kobj_path: path = '/kernel/slab/:dt-0000096'
[    5.844518] kobject: ':t-0008192' (cd80274c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.846923] kobject: ':t-0008192' (cd80274c): kobject_uevent_env
[    5.848431] kobject: ':t-0008192' (cd80274c): fill_kobj_path: path = '/kernel/slab/:t-0008192'
[    5.850958] kobject: ':t-0004096' (cd8026cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.853490] kobject: ':t-0004096' (cd8026cc): kobject_uevent_env
[    5.855010] kobject: ':t-0004096' (cd8026cc): fill_kobj_path: path = '/kernel/slab/:t-0004096'
[    5.857458] kobject: ':t-0002048' (cd80264c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.859315] kobject: ':t-0002048' (cd80264c): kobject_uevent_env
[    5.860368] kobject: ':t-0002048' (cd80264c): fill_kobj_path: path = '/kernel/slab/:t-0002048'
[    5.862740] kobject: ':t-0001024' (cd8025cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.865179] kobject: ':t-0001024' (cd8025cc): kobject_uevent_env
[    5.866709] kobject: ':t-0001024' (cd8025cc): fill_kobj_path: path = '/kernel/slab/:t-0001024'
[    5.868843] kobject: ':t-0000512' (cd80254c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.870608] kobject: ':t-0000512' (cd80254c): kobject_uevent_env
[    5.871523] kobject: ':t-0000512' (cd80254c): fill_kobj_path: path = '/kernel/slab/:t-0000512'
[    5.872867] kobject: ':t-0000256' (cd8024cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.874223] kobject: ':t-0000256' (cd8024cc): kobject_uevent_env
[    5.875100] kobject: ':t-0000256' (cd8024cc): fill_kobj_path: path = '/kernel/slab/:t-0000256'
[    5.876467] kobject: ':t-0000128' (cd80244c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.877837] kobject: ':t-0000128' (cd80244c): kobject_uevent_env
[    5.878728] kobject: ':t-0000128' (cd80244c): fill_kobj_path: path = '/kernel/slab/:t-0000128'
[    5.880192] kobject: ':t-0000064' (cd8023cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.881544] kobject: ':t-0000064' (cd8023cc): kobject_uevent_env
[    5.883053] kobject: ':t-0000064' (cd8023cc): fill_kobj_path: path = '/kernel/slab/:t-0000064'
[    5.886839] kobject: ':t-0000032' (cd80234c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.888194] kobject: ':t-0000032' (cd80234c): kobject_uevent_env
[    5.889052] kobject: ':t-0000032' (cd80234c): fill_kobj_path: path = '/kernel/slab/:t-0000032'
[    5.890502] kobject: ':t-0000016' (cd8022cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.891910] kobject: ':t-0000016' (cd8022cc): kobject_uevent_env
[    5.892775] kobject: ':t-0000016' (cd8022cc): fill_kobj_path: path = '/kernel/slab/:t-0000016'
[    5.894126] kobject: ':t-0000008' (cd80224c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.895467] kobject: ':t-0000008' (cd80224c): kobject_uevent_env
[    5.896343] kobject: ':t-0000008' (cd80224c): fill_kobj_path: path = '/kernel/slab/:t-0000008'
[    5.897686] kobject: ':t-0000192' (cd8021cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.899068] kobject: ':t-0000192' (cd8021cc): kobject_uevent_env
[    5.899921] kobject: ':t-0000192' (cd8021cc): fill_kobj_path: path = '/kernel/slab/:t-0000192'
[    5.901410] kobject: ':t-0000096' (cd80214c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.902784] kobject: ':t-0000096' (cd80214c): kobject_uevent_env
[    5.903648] kobject: ':t-0000096' (cd80214c): fill_kobj_path: path = '/kernel/slab/:t-0000096'
[    5.904989] kobject: 'kmem_cache' (cd80204c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.906390] kobject: 'kmem_cache' (cd80204c): kobject_uevent_env
[    5.907253] kobject: 'kmem_cache' (cd80204c): fill_kobj_path: path = '/kernel/slab/kmem_cache'
[    5.908619] kobject: 'kmem_cache_node' (cd8020cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.910141] kobject: 'kmem_cache_node' (cd8020cc): kobject_uevent_env
[    5.911109] kobject: 'kmem_cache_node' (cd8020cc): fill_kobj_path: path = '/kernel/slab/kmem_cache_node'
[    5.912597] kobject: ':t-0000320' (cf84c1cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.914021] kobject: ':t-0000320' (cf84c1cc): kobject_uevent_env
[    5.914873] kobject: ':t-0000320' (cf84c1cc): fill_kobj_path: path = '/kernel/slab/:t-0000320'
[    5.916881] kobject: ':t-0000072' (cf84c2cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.918413] kobject: ':t-0000072' (cf84c2cc): kobject_uevent_env
[    5.919281] kobject: ':t-0000072' (cf84c2cc): fill_kobj_path: path = '/kernel/slab/:t-0000072'
[    5.920797] aio_setup: sizeof(struct page) = 32
[    5.921567] kobject: ':t-0000056' (cf84c34c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.922990] kobject: ':t-0000056' (cf84c34c): kobject_uevent_env
[    5.923877] kobject: ':t-0000056' (cf84c34c): fill_kobj_path: path = '/kernel/slab/:t-0000056'
[    5.925209] kobject: 'config' (cf86eb40): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    5.926615] kobject: 'reiser_inode_cache' (cf84c3cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.928076] kobject: 'reiser_inode_cache' (cf84c3cc): kobject_uevent_env
[    5.929020] kobject: 'reiser_inode_cache' (cf84c3cc): fill_kobj_path: path = '/kernel/slab/reiser_inode_cache'
[    5.930640] kobject: ':at-0000048' (cf84c44c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.932023] kobject: ':at-0000048' (cf84c44c): kobject_uevent_env
[    5.932898] kobject: ':at-0000048' (cf84c44c): fill_kobj_path: path = '/kernel/slab/:at-0000048'
[    5.934254] kobject: 'ext2_inode_cache' (cf84c4cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.935668] kobject: 'ext2_inode_cache' (cf84c4cc): kobject_uevent_env
[    5.936587] kobject: 'ext2_inode_cache' (cf84c4cc): fill_kobj_path: path = '/kernel/slab/ext2_inode_cache'
[    5.938671] kobject: ':at-0000008' (cf84c54c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.941219] kobject: ':at-0000008' (cf84c54c): kobject_uevent_env
[    5.942756] kobject: ':at-0000008' (cf84c54c): fill_kobj_path: path = '/kernel/slab/:at-0000008'
[    5.945040] kobject: ':at-0000576' (cf84c5cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.947397] kobject: ':at-0000576' (cf84c5cc): kobject_uevent_env
[    5.948872] kobject: ':at-0000576' (cf84c5cc): fill_kobj_path: path = '/kernel/slab/:at-0000576'
[    5.951478] kobject: 'ext4' (cf87348c): kobject_add_internal: parent: 'fs', set: '<NULL>'
[    5.953738] kobject: 'ext4' (cf87348c): kobject_uevent_env
[    5.955204] kobject: 'ext4' (cf87348c): kobject_uevent_env: attempted to send uevent without kset!
[    5.957608] kobject: 'features' (cf873500): kobject_add_internal: parent: 'ext4', set: 'ext4'
[    5.960100] kobject: ':at-0000072' (cf84c64c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.962471] kobject: ':at-0000072' (cf84c64c): kobject_uevent_env
[    5.963963] kobject: ':at-0000072' (cf84c64c): fill_kobj_path: path = '/kernel/slab/:at-0000072'
[    5.966304] kobject: ':at-0000112' (cf84c6cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.968693] kobject: ':at-0000112' (cf84c6cc): kobject_uevent_env
[    5.970296] kobject: ':at-0000112' (cf84c6cc): fill_kobj_path: path = '/kernel/slab/:at-0000112'
[    5.972658] kobject: ':at-0000040' (cf84c74c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.974972] kobject: ':at-0000040' (cf84c74c): kobject_uevent_env
[    5.976458] kobject: ':at-0000040' (cf84c74c): fill_kobj_path: path = '/kernel/slab/:at-0000040'
[    5.978815] debugfs: creating file 'ext4'
[    5.980181] debugfs: creating file 'mballoc-debug'
[    5.981514] kobject: 'ext4_inode_cache' (cf84c7cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.983855] kobject: 'ext4_inode_cache' (cf84c7cc): kobject_uevent_env
[    5.985349] kobject: 'ext4_inode_cache' (cf84c7cc): fill_kobj_path: path = '/kernel/slab/ext4_inode_cache'
[    5.987874] kobject: ':at-0000032' (cf84c84c): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.990365] kobject: ':at-0000032' (cf84c84c): kobject_uevent_env
[    5.991948] kobject: ':at-0000032' (cf84c84c): fill_kobj_path: path = '/kernel/slab/:at-0000032'
[    5.994287] kobject: ':at-0000016' (cf84c8cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    5.996673] kobject: ':at-0000016' (cf84c8cc): kobject_uevent_env
[    5.998165] kobject: ':at-0000016' (cf84c8cc): fill_kobj_path: path = '/kernel/slab/:at-0000016'
[    6.000620] kobject: ':at-0000064' (cf84c94c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.002993] kobject: ':at-0000064' (cf84c94c): kobject_uevent_env
[    6.004513] kobject: ':at-0000064' (cf84c94c): fill_kobj_path: path = '/kernel/slab/:at-0000064'
[    6.006855] kobject: ':at-0000256' (cf84c9cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.009312] kobject: ':at-0000256' (cf84c9cc): kobject_uevent_env
[    6.010935] kobject: ':at-0000256' (cf84c9cc): fill_kobj_path: path = '/kernel/slab/:at-0000256'
[    6.013330] debugfs: creating file 'jbd2'
[    6.014471] debugfs: creating file 'jbd2-debug'
[    6.015714] kobject: 'hugetlbfs_inode_cache' (cf84ca4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.018252] kobject: 'hugetlbfs_inode_cache' (cf84ca4c): kobject_uevent_env
[    6.019847] kobject: 'hugetlbfs_inode_cache' (cf84ca4c): fill_kobj_path: path = '/kernel/slab/hugetlbfs_inode_cache'
[    6.022581] kobject: 'isofs_inode_cache' (cf84cb4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.025085] kobject: 'isofs_inode_cache' (cf84cb4c): kobject_uevent_env
[    6.026722] kobject: 'isofs_inode_cache' (cf84cb4c): fill_kobj_path: path = '/kernel/slab/isofs_inode_cache'
[    6.029322] kobject: 'udf_inode_cache' (cf84cbcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.031952] kobject: 'udf_inode_cache' (cf84cbcc): kobject_uevent_env
[    6.033568] kobject: 'udf_inode_cache' (cf84cbcc): fill_kobj_path: path = '/kernel/slab/udf_inode_cache'
[    6.042188] alg: No test for fcrypt (fcrypt-generic)
[    6.044054] alg: No test for stdrng (krng)
[    6.047844] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.048830] async_tx: api initialized (async)
[    6.049639] kobject: ':t-0000288' (cf88db4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.051197] kobject: ':t-0000288' (cf88db4c): kobject_uevent_env
[    6.052097] kobject: ':t-0000288' (cf88db4c): fill_kobj_path: path = '/kernel/slab/:t-0000288'
[    6.053446] device class 'bsg': registering
[    6.054165] kobject: 'bsg' (c921470c): kobject_add_internal: parent: 'class', set: 'class'
[    6.055528] kobject: 'bsg' (c921470c): kobject_uevent_env
[    6.056353] kobject: 'bsg' (c921470c): fill_kobj_path: path = '/class/bsg'
[    6.057316] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    6.058660] io scheduler noop registered (default)
[    6.059495] start plist test
[    6.061692] end plist test
[    6.062286] debugfs: creating file 'debug_objects'
[    6.063052] debugfs: creating file 'stats'
[    6.063764] bus: 'platform': add driver basic-mmio-gpio
[    6.064559] kobject: 'basic-mmio-gpio' (c9aaff60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.066030] kobject: 'basic-mmio-gpio' (c9aaff60): kobject_uevent_env
[    6.066960] kobject: 'basic-mmio-gpio' (c9aaff60): fill_kobj_path: path = '/bus/platform/drivers/basic-mmio-gpio'
[    6.068537] bus: 'pci': add driver ml_ioh_gpio
[    6.069254] kobject: 'ml_ioh_gpio' (cf890000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.070920] kobject: 'ml_ioh_gpio' (cf890000): kobject_uevent_env
[    6.071913] kobject: 'ml_ioh_gpio' (cf890000): fill_kobj_path: path = '/bus/pci/drivers/ml_ioh_gpio'
[    6.073461] bus: 'pci': add driver pch_gpio
[    6.074222] kobject: 'pch_gpio' (cf890060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.078800] kobject: 'pch_gpio' (cf890060): kobject_uevent_env
[    6.080538] kobject: 'pch_gpio' (cf890060): fill_kobj_path: path = '/bus/pci/drivers/pch_gpio'
[    6.082830] bus: 'platform': add driver rdc321x-gpio
[    6.084147] kobject: 'rdc321x-gpio' (cf8900c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.086649] kobject: 'rdc321x-gpio' (cf8900c0): kobject_uevent_env
[    6.088266] kobject: 'rdc321x-gpio' (cf8900c0): fill_kobj_path: path = '/bus/platform/drivers/rdc321x-gpio'
[    6.090816] bus: 'platform': add driver sch_gpio
[    6.092109] kobject: 'sch_gpio' (cf890120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.094674] kobject: 'sch_gpio' (cf890120): kobject_uevent_env
[    6.096270] kobject: 'sch_gpio' (cf890120): fill_kobj_path: path = '/bus/platform/drivers/sch_gpio'
[    6.098833] bus: 'platform': add driver vx855_gpio
[    6.100324] kobject: 'vx855_gpio' (cf890180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.102905] kobject: 'vx855_gpio' (cf890180): kobject_uevent_env
[    6.104468] kobject: 'vx855_gpio' (cf890180): fill_kobj_path: path = '/bus/platform/drivers/vx855_gpio'
[    6.106917] bus: 'pci': add driver ioapic
[    6.107979] kobject: 'ioapic' (cf8907e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.110149] kobject: 'ioapic' (cf8907e0): kobject_uevent_env
[    6.111696] kobject: 'ioapic' (cf8907e0): fill_kobj_path: path = '/bus/pci/drivers/ioapic'
[    6.114145] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.115837] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    6.117662] debugfs: creating file 'cpqhp'
[    6.118934] bus: 'pci': add driver compaq_pci_hotplug
[    6.120499] kobject: 'compaq_pci_hotplug' (cf890840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.123321] kobject: 'compaq_pci_hotplug' (cf890840): kobject_uevent_env
[    6.125100] kobject: 'compaq_pci_hotplug' (cf890840): fill_kobj_path: path = '/bus/pci/drivers/compaq_pci_hotplug'
[    6.127916] bus: 'pci': add driver shpchp
[    6.129202] kobject: 'shpchp' (cf890900): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.131967] kobject: 'shpchp' (cf890900): kobject_uevent_env
[    6.133559] kobject: 'shpchp' (cf890900): fill_kobj_path: path = '/bus/pci/drivers/shpchp'
[    6.135982] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.137703] device: 'fbcon': device_add
[    6.137707] kobject: 'graphics' (cf891640): kobject_add_internal: parent: 'virtual', set: '(null)'
[    6.137712] kobject: 'fbcon' (cd940e08): kobject_add_internal: parent: 'graphics', set: 'devices'
[    6.137727] PM: Adding info for No Bus:fbcon
[    6.137730] kobject: 'fbcon' (cd940e08): kobject_uevent_env
[    6.137733] kobject: 'fbcon' (cd940e08): fill_kobj_path: path = '/devices/virtual/graphics/fbcon'
[    6.150535] bus: 'spi': add driver l4f00242t03
[    6.151871] kobject: 'l4f00242t03' (cf8909c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.154612] kobject: 'l4f00242t03' (cf8909c0): kobject_uevent_env
[    6.156224] kobject: 'l4f00242t03' (cf8909c0): fill_kobj_path: path = '/bus/spi/drivers/l4f00242t03'
[    6.158774] bus: 'spi': add driver VGG2432A4
[    6.159989] kobject: 'VGG2432A4' (cf890a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.162502] kobject: 'VGG2432A4' (cf890a20): kobject_uevent_env
[    6.163979] kobject: 'VGG2432A4' (cf890a20): fill_kobj_path: path = '/bus/spi/drivers/VGG2432A4'
[    6.166509] bus: 'spi': add driver tdo24m
[    6.167765] kobject: 'tdo24m' (cf890a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.170437] kobject: 'tdo24m' (cf890a80): kobject_uevent_env
[    6.171978] kobject: 'tdo24m' (cf890a80): fill_kobj_path: path = '/bus/spi/drivers/tdo24m'
[    6.174433] bus: 'spi': add driver s6e63m0
[    6.175692] kobject: 's6e63m0' (cf890ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.178236] kobject: 's6e63m0' (cf890ae0): kobject_uevent_env
[    6.179794] kobject: 's6e63m0' (cf890ae0): fill_kobj_path: path = '/bus/spi/drivers/s6e63m0'
[    6.182393] bus: 'platform': add driver generic-bl
[    6.183791] kobject: 'generic-bl' (cf890b40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.186412] kobject: 'generic-bl' (cf890b40): kobject_uevent_env
[    6.188183] kobject: 'generic-bl' (cf890b40): fill_kobj_path: path = '/bus/platform/drivers/generic-bl'
[    6.191116] bus: 'i2c': add driver adp8860_bl
[    6.192411] kobject: 'adp8860_bl' (cf890ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.195022] kobject: 'adp8860_bl' (cf890ba0): kobject_uevent_env
[    6.196651] kobject: 'adp8860_bl' (cf890ba0): fill_kobj_path: path = '/bus/i2c/drivers/adp8860_bl'
[    6.199218] i2c-core: driver [adp8860_bl] using legacy suspend method
[    6.201044] i2c-core: driver [adp8860_bl] using legacy resume method
[    6.202766] i2c-core: driver [adp8860_bl] registered
[    6.204325] bus: 'platform': add driver pcf50633-backlight
[    6.206009] kobject: 'pcf50633-backlight' (cf890c00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.215849] kobject: 'pcf50633-backlight' (cf890c00): kobject_uevent_env
[    6.218452] kobject: 'pcf50633-backlight' (cf890c00): fill_kobj_path: path = '/bus/platform/drivers/pcf50633-backlight'
[    6.221144] bus: 'pci': add driver CyberPro
[    6.222254] kobject: 'CyberPro' (cf890c60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.224731] kobject: 'CyberPro' (cf890c60): kobject_uevent_env
[    6.225641] kobject: 'CyberPro' (cf890c60): fill_kobj_path: path = '/bus/pci/drivers/CyberPro'
[    6.227287] rivafb_setup START
[    6.227848] bus: 'pci': add driver rivafb
[    6.228555] kobject: 'rivafb' (cf890cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.229961] kobject: 'rivafb' (cf890cc0): kobject_uevent_env
[    6.230869] kobject: 'rivafb' (cf890cc0): fill_kobj_path: path = '/bus/pci/drivers/rivafb'
[    6.232381] bus: 'pci': add driver nvidiafb
[    6.233113] kobject: 'nvidiafb' (cf890d20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.235173] kobject: 'nvidiafb' (cf890d20): kobject_uevent_env
[    6.236158] kobject: 'nvidiafb' (cf890d20): fill_kobj_path: path = '/bus/pci/drivers/nvidiafb'
[    6.237661] bus: 'pci': add driver radeonfb
[    6.238467] kobject: 'radeonfb' (cf890d80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.240145] kobject: 'radeonfb' (cf890d80): kobject_uevent_env
[    6.241092] kobject: 'radeonfb' (cf890d80): fill_kobj_path: path = '/bus/pci/drivers/radeonfb'
[    6.242431] bus: 'pci': add driver imsttfb
[    6.243200] kobject: 'imsttfb' (cf890de0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.245210] kobject: 'imsttfb' (cf890de0): kobject_uevent_env
[    6.246600] kobject: 'imsttfb' (cf890de0): fill_kobj_path: path = '/bus/pci/drivers/imsttfb'
[    6.248655] vt8623fb: initializing
[    6.249589] bus: 'pci': add driver vt8623fb
[    6.250788] kobject: 'vt8623fb' (cf890e40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.253043] kobject: 'vt8623fb' (cf890e40): kobject_uevent_env
[    6.254579] kobject: 'vt8623fb' (cf890e40): fill_kobj_path: path = '/bus/pci/drivers/vt8623fb'
[    6.256821] vmlfb: initializing
[    6.257735] bus: 'pci': add driver vmlfb
[    6.258803] kobject: 'vmlfb' (cf890ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.261255] kobject: 'vmlfb' (cf890ea0): kobject_uevent_env
[    6.262623] kobject: 'vmlfb' (cf890ea0): fill_kobj_path: path = '/bus/pci/drivers/vmlfb'
[    6.264889] Could not find Carillo Ranch MCH device.
[    6.266145] bus: 'platform': add driver hecubafb
[    6.267314] kobject: 'hecubafb' (cf890f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.269552] kobject: 'hecubafb' (cf890f00): kobject_uevent_env
[    6.271067] kobject: 'hecubafb' (cf890f00): fill_kobj_path: path = '/bus/platform/drivers/hecubafb'
[    6.273362] no IO addresses supplied
[    6.274485] bus: 'pci': add driver cirrusfb
[    6.275680] kobject: 'cirrusfb' (cf890f60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.277885] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver cirrusfb
[    6.280173] bus: 'pci': really_probe: probing driver cirrusfb with device 0000:00:02.0
[    6.282403] pci_notify
[    6.283266] cirrusfb 0000:00:02.0:  Found PCI device, base address 0 is 0xfc000000, btype set to 5
[    6.285725] cirrusfb 0000:00:02.0:  base address 1 is 0xfebf0000
[    6.287124] cirrusfb 0000:00:02.0: Attempt to get PCI info for Cirrus Graphics Card
[    6.289189] cirrusfb 0000:00:02.0: Board address: 0xfc000000, register address: 0xfebf0000
[    6.291568] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
[    6.293790] cirrusfb 0000:00:02.0: (RAM start set to: 0xd0880000)
[    6.295279] cirrusfb 0000:00:02.0: desired pixclock: 25175 kHz
[    6.296617] cirrusfb 0000:00:02.0: desired pixclock: 25175 kHz
[    6.297987] device: 'fb0': device_add
[    6.298961] kobject: 'graphics' (cf892e40): kobject_add_internal: parent: '0000:00:02.0', set: '(null)'
[    6.301470] kobject: 'fb0' (cd941608): kobject_add_internal: parent: 'graphics', set: 'devices'
[    6.303737] PM: Adding info for No Bus:fb0
[    6.304942] kobject: 'fb0' (cd941608): kobject_uevent_env
[    6.306377] kobject: 'fb0' (cd941608): fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/graphics/fb0'
[    6.308781] fbcon: CL Picasso4 (fb0) is primary device
[    6.313712] device: 'vtcon1': device_add
[    6.313715] kobject: 'vtcon1' (cd941a08): kobject_add_internal: parent: 'vtconsole', set: 'devices'
[    6.313726] PM: Adding info for No Bus:vtcon1
[    6.313728] kobject: 'vtcon1' (cd941a08): kobject_uevent_env
[    6.313731] kobject: 'vtcon1' (cd941a08): fill_kobj_path: path = '/devices/virtual/vtconsole/vtcon1'
[    6.324848] cirrusfb 0000:00:02.0: Requested mode: 640x480x8
[    6.426112] cirrusfb 0000:00:02.0: CRT0: 95
[    6.426117] cirrusfb 0000:00:02.0: CRT1: 79
[    6.426120] cirrusfb 0000:00:02.0: CRT2: 80
[    6.426124] cirrusfb 0000:00:02.0: CRT3: 128+4
[    6.426128] cirrusfb 0000:00:02.0: CRT4: 84
[    6.426131] cirrusfb 0000:00:02.0: CRT5: 128
[    6.426135] cirrusfb 0000:00:02.0: CRT6: 11
[    6.426138] cirrusfb 0000:00:02.0: CRT7: 62
[    6.426142] cirrusfb 0000:00:02.0: CRT9: 64
[    6.426146] cirrusfb 0000:00:02.0: CRT10: 234
[    6.426149] cirrusfb 0000:00:02.0: CRT11: 64+32+12
[    6.426153] cirrusfb 0000:00:02.0: CRT12: 223
[    6.426156] cirrusfb 0000:00:02.0: CRT15: 224
[    6.426160] cirrusfb 0000:00:02.0: CRT16: 11
[    6.426163] cirrusfb 0000:00:02.0: CRT18: 0xff
[    6.426166] cirrusfb 0000:00:02.0: CRT1a: 144
[    6.426172] cirrusfb 0000:00:02.0: VCLK freq: 25175 kHz  nom: 51  den: 29  div: 0
[    6.426180] cirrusfb 0000:00:02.0: Read MCLK of 80538 kHz
[    6.426201] cirrusfb 0000:00:02.0: preparing for 8 bit deep display
[    6.433341] cirrusfb 0000:00:02.0: CL_SEQR1: 1
[    6.433347] cirrusfb 0000:00:02.0: Requested mode: 640x480x8
[    6.440114] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[    6.440129] Switching to clocksource tsc
[    6.535186] cirrusfb 0000:00:02.0: CRT0: 95
[    6.535204] cirrusfb 0000:00:02.0: CRT1: 79
[    6.535211] cirrusfb 0000:00:02.0: CRT2: 80
[    6.535217] cirrusfb 0000:00:02.0: CRT3: 128+4
[    6.535224] cirrusfb 0000:00:02.0: CRT4: 84
[    6.535231] cirrusfb 0000:00:02.0: CRT5: 128
[    6.535237] cirrusfb 0000:00:02.0: CRT6: 11
[    6.535244] cirrusfb 0000:00:02.0: CRT7: 62
[    6.535257] cirrusfb 0000:00:02.0: CRT9: 64
[    6.535264] cirrusfb 0000:00:02.0: CRT10: 234
[    6.535271] cirrusfb 0000:00:02.0: CRT11: 64+32+12
[    6.535276] cirrusfb 0000:00:02.0: CRT12: 223
[    6.535282] cirrusfb 0000:00:02.0: CRT15: 224
[    6.535288] cirrusfb 0000:00:02.0: CRT16: 11
[    6.535294] cirrusfb 0000:00:02.0: CRT18: 0xff
[    6.535300] cirrusfb 0000:00:02.0: CRT1a: 144
[    6.535312] cirrusfb 0000:00:02.0: VCLK freq: 25175 kHz  nom: 51  den: 29  div: 0
[    6.535326] cirrusfb 0000:00:02.0: Read MCLK of 80538 kHz
[    6.535365] cirrusfb 0000:00:02.0: preparing for 8 bit deep display
[    6.536688] cirrusfb 0000:00:02.0: CL_SEQR1: 1
[    6.712996] Console: switching to colour frame buffer device 80x30
[   12.368704] driver: '0000:00:02.0': driver_bound: bound to device 'cirrusfb'
[   12.489604] pci_notify
[   12.609131] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver cirrusfb
[   12.859742] kobject: 'cirrusfb' (cf890f60): kobject_uevent_env
[   12.987477] kobject: 'cirrusfb' (cf890f60): fill_kobj_path: path = '/bus/pci/drivers/cirrusfb'
[   13.245208] bus: 'platform': add driver broadsheetfb
[   13.356716] kobject: 'broadsheetfb' (cf894120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   13.563329] kobject: 'broadsheetfb' (cf894120): kobject_uevent_env
[   13.685621] kobject: 'broadsheetfb' (cf894120): fill_kobj_path: path = '/bus/platform/drivers/broadsheetfb'
[   13.983599] bus: 'platform': add driver sm501-fb
[   14.136036] kobject: 'sm501-fb' (cf894180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   14.431920] kobject: 'sm501-fb' (cf894180): kobject_uevent_env
[   14.546903] kobject: 'sm501-fb' (cf894180): fill_kobj_path: path = '/bus/platform/drivers/sm501-fb'
[   14.783689] bus: 'acpi': add driver ac
[   14.904111] kobject: 'ac' (cf8941e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   15.151733] kobject: 'ac' (cf8941e0): kobject_uevent_env
[   15.279446] kobject: 'ac' (cf8941e0): fill_kobj_path: path = '/bus/acpi/drivers/ac'
[   15.526211] bus: 'acpi': add driver button
[   15.685323] kobject: 'button' (cf894240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   16.069480] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[   16.498975] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[   16.882850] device: 'input0': device_add
[   17.016811] kobject: 'input' (cf895e00): kobject_add_internal: parent: 'LNXPWRBN:00', set: '(null)'
[   17.304963] kobject: 'input0' (cf8c51a8): kobject_add_internal: parent: 'input', set: 'devices'
[   17.599123] PM: Adding info for No Bus:input0
[   17.793272] kobject: 'input0' (cf8c51a8): kobject_uevent_env
[   17.997840] kobject: 'input0' (cf8c51a8): fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0'
[   18.403301] kobject: 'input0' (cf8c51a8): fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0'
[   18.818529] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   19.219559] ACPI: Power Button [PWRF]
[   19.422160] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   19.618740] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[   20.006619] kobject: 'button' (cf894240): kobject_uevent_env
[   20.220928] kobject: 'button' (cf894240): fill_kobj_path: path = '/bus/acpi/drivers/button'
[   20.658155] bus: 'acpi': add driver fan
[   20.847712] kobject: 'fan' (cf894300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   21.195227] kobject: 'fan' (cf894300): kobject_uevent_env
[   21.371949] kobject: 'fan' (cf894300): fill_kobj_path: path = '/bus/acpi/drivers/fan'
[   21.721287] bus: 'acpi': add driver video
[   21.891261] kobject: 'video' (cf894360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   22.228424] kobject: 'video' (cf894360): kobject_uevent_env
[   22.397917] kobject: 'video' (cf894360): fill_kobj_path: path = '/bus/acpi/drivers/video'
[   22.723455] bus: 'acpi': add driver processor
[   22.883762] kobject: 'processor' (cf8943c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   23.207165] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[   23.544635] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[   23.870914] device: 'cooling_device0': device_add
[   24.003413] kobject: 'thermal' (cf896a40): kobject_add_internal: parent: 'virtual', set: '(null)'
[   24.270549] kobject: 'cooling_device0' (cd93aa20): kobject_add_internal: parent: 'thermal', set: 'devices'
[   24.645848] PM: Adding info for No Bus:cooling_device0
[   24.841657] kobject: 'cooling_device0' (cd93aa20): kobject_uevent_env
[   25.031007] kobject: 'cooling_device0' (cd93aa20): fill_kobj_path: path = '/devices/virtual/thermal/cooling_device0'
[   25.407592] processor LNXCPU:00: registered as cooling_device0
[   25.565125] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[   25.705443] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[   26.001148] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[   26.378742] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[   26.819768] device: 'cooling_device1': device_add
[   27.042252] kobject: 'cooling_device1' (cd93a820): kobject_add_internal: parent: 'thermal', set: 'devices'
[   27.428825] PM: Adding info for No Bus:cooling_device1
[   27.662136] kobject: 'cooling_device1' (cd93a820): kobject_uevent_env
[   27.909330] kobject: 'cooling_device1' (cd93a820): fill_kobj_path: path = '/devices/virtual/thermal/cooling_device1'
[   28.346864] processor LNXCPU:01: registered as cooling_device1
[   28.568213] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[   28.783735] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[   29.201246] kobject: 'processor' (cf8943c0): kobject_uevent_env
[   29.407566] kobject: 'processor' (cf8943c0): fill_kobj_path: path = '/bus/acpi/drivers/processor'
[   29.827478] bus: 'acpi': add driver thermal
[   30.017549] kobject: 'thermal' (cf8944e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   30.460694] kobject: 'thermal' (cf8944e0): kobject_uevent_env
[   30.666278] kobject: 'thermal' (cf8944e0): fill_kobj_path: path = '/bus/acpi/drivers/thermal'
[   31.054536] bus: 'pci': add driver pch-dma
[   31.256732] bus: 'acpi': add driver battery
[   31.270456] kobject: 'pch-dma' (c91b4000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.270531] kobject: 'pch-dma' (c91b4000): kobject_uevent_env
[   31.270560] kobject: 'pch-dma' (c91b4000): fill_kobj_path: path = '/bus/pci/drivers/pch-dma'
[   31.270630] bus: 'platform': add driver reg-virt-consumer
[   31.270632] kobject: 'reg-virt-consumer' (c91b4060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.270651] kobject: 'reg-virt-consumer' (c91b4060): kobject_uevent_env
[   31.270654] kobject: 'reg-virt-consumer' (c91b4060): fill_kobj_path: path = '/bus/platform/drivers/reg-virt-consumer'
[   31.271067] bus: 'spi': add driver tps6524x
[   31.271119] kobject: 'tps6524x' (c91b40c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.271168] kobject: 'tps6524x' (c91b40c0): kobject_uevent_env
[   31.271176] kobject: 'tps6524x' (c91b40c0): fill_kobj_path: path = '/bus/spi/drivers/tps6524x'
[   31.271319] device: 'ptmx': device_add
[   31.271335] kobject: 'ptmx' (cf8bc008): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.271396] PM: Adding info for No Bus:ptmx
[   31.271398] kobject: 'ptmx' (cf8bc008): kobject_uevent_env
[   31.271400] kobject: 'ptmx' (cf8bc008): fill_kobj_path: path = '/devices/virtual/tty/ptmx'
[   31.271455] r3964: Philips r3964 Driver $Revision: 1.10 $
[   31.271467] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   31.271491] Registering platform device 'serial8250'. Parent at platform
[   31.271492] device: 'serial8250': device_add
[   31.271494] kobject: 'serial8250' (cf8bc210): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.271504] bus: 'platform': add device serial8250
[   31.271516] PM: Adding info for platform:serial8250
[   31.271517] kobject: 'serial8250' (cf8bc210): kobject_uevent_env
[   31.271519] kobject: 'serial8250' (cf8bc210): fill_kobj_path: path = '/devices/platform/serial8250'
[   31.297394] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   31.297482] device: 'ttyS0': device_add
[   31.297506] kobject: 'tty' (c91a3980): kobject_add_internal: parent: 'serial8250', set: '(null)'
[   31.297537] kobject: 'ttyS0' (cf8bc408): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.297618] PM: Adding info for No Bus:ttyS0
[   31.297623] kobject: 'ttyS0' (cf8bc408): kobject_uevent_env
[   31.297630] kobject: 'ttyS0' (cf8bc408): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS0'
[   31.297805] device: 'ttyS1': device_add
[   31.297807] kobject: 'ttyS1' (cf8bc608): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.297823] PM: Adding info for No Bus:ttyS1
[   31.297824] kobject: 'ttyS1' (cf8bc608): kobject_uevent_env
[   31.297827] kobject: 'ttyS1' (cf8bc608): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS1'
[   31.298502] device: 'ttyS2': device_add
[   31.298524] kobject: 'ttyS2' (cf8bc808): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.298639] PM: Adding info for No Bus:ttyS2
[   31.298643] kobject: 'ttyS2' (cf8bc808): kobject_uevent_env
[   31.298653] kobject: 'ttyS2' (cf8bc808): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS2'
[   31.298832] device: 'ttyS3': device_add
[   31.298833] kobject: 'ttyS3' (cf8bca08): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.298846] PM: Adding info for No Bus:ttyS3
[   31.298847] kobject: 'ttyS3' (cf8bca08): kobject_uevent_env
[   31.298849] kobject: 'ttyS3' (cf8bca08): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS3'
[   31.298893] bus: 'platform': add driver serial8250
[   31.298895] kobject: 'serial8250' (c91b4540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.298917] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   31.298919] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   31.298929] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   31.298931] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   31.298937] kobject: 'serial8250' (c91b4540): kobject_uevent_env
[   31.298939] kobject: 'serial8250' (c91b4540): fill_kobj_path: path = '/bus/platform/drivers/serial8250'
[   31.299292] bus: 'pnp': add driver serial
[   31.299384] kobject: 'serial' (c91b45a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.299490] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[   31.299497] bus: 'pnp': really_probe: probing driver serial with device 00:06
[   31.299567] device: 'ttyS0': device_unregister
[   31.299571] PM: Removing info for No Bus:ttyS0
[   31.299643] kobject: 'ttyS0' (cf8bc408): kobject_uevent_env
[   31.299652] kobject: 'ttyS0' (cf8bc408): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS0'
[   31.299679] sysfs ttyS0: removing dir
[   31.299681] kobject: 'ttyS0' (cf8bc408): kobject_cleanup
[   31.299682] kobject: 'ttyS0' (cf8bc408): calling ktype release
[   31.299683] device: 'ttyS0': device_create_release
[   31.299684] kobject: 'ttyS0': free name
[   31.325111] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   31.325339] device: 'ttyS0': device_add
[   31.325359] kobject: 'tty' (c9b54cc0): kobject_add_internal: parent: '00:06', set: '(null)'
[   31.325389] kobject: 'ttyS0' (cf8bc408): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.325950] PM: Adding info for No Bus:ttyS0
[   31.325967] kobject: 'ttyS0' (cf8bc408): kobject_uevent_env
[   31.325988] kobject: 'ttyS0' (cf8bc408): fill_kobj_path: path = '/devices/pnp0/00:06/tty/ttyS0'
[   31.326533] driver: '00:06': driver_bound: bound to device 'serial'
[   31.326542] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[   31.326561] kobject: 'serial' (c91b45a0): kobject_uevent_env
[   31.326565] kobject: 'serial' (c91b45a0): fill_kobj_path: path = '/bus/pnp/drivers/serial'
[   31.326591] bus: 'pci': add driver serial
[   31.326595] kobject: 'serial' (c91b4600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.326623] kobject: 'serial' (c91b4600): kobject_uevent_env
[   31.326625] kobject: 'serial' (c91b4600): fill_kobj_path: path = '/bus/pci/drivers/serial'
[   31.326719] bus: 'pci': add driver jsm
[   31.326721] kobject: 'jsm' (c91b4720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.326730] kobject: 'jsm' (c91b4720): kobject_uevent_env
[   31.326732] kobject: 'jsm' (c91b4720): fill_kobj_path: path = '/bus/pci/drivers/jsm'
[   31.326756] bus: 'platform': add driver altera_uart
[   31.326758] kobject: 'altera_uart' (c91b4840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.326773] kobject: 'altera_uart' (c91b4840): kobject_uevent_env
[   31.326775] kobject: 'altera_uart' (c91b4840): fill_kobj_path: path = '/bus/platform/drivers/altera_uart'
[   31.326777] bus: 'platform': add driver timb-uart
[   31.326779] kobject: 'timb-uart' (c91b48a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.326782] kobject: 'timb-uart' (c91b48a0): kobject_uevent_env
[   31.326784] kobject: 'timb-uart' (c91b48a0): fill_kobj_path: path = '/bus/platform/drivers/timb-uart'
[   31.326789] bus: 'platform': add driver altera_jtaguart
[   31.326791] kobject: 'altera_jtaguart' (c91b4960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.326794] kobject: 'altera_jtaguart' (c91b4960): kobject_uevent_env
[   31.326796] kobject: 'altera_jtaguart' (c91b4960): fill_kobj_path: path = '/bus/platform/drivers/altera_jtaguart'
[   31.327357] bus: 'pci': add driver pch_uart
[   31.327371] kobject: 'pch_uart' (c91b4a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.327411] kobject: 'pch_uart' (c91b4a80): kobject_uevent_env
[   31.327417] kobject: 'pch_uart' (c91b4a80): fill_kobj_path: path = '/bus/pci/drivers/pch_uart'
[   31.327466] bus: 'platform': add driver xuartps
[   31.327468] kobject: 'xuartps' (c91b4ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.327487] kobject: 'xuartps' (c91b4ba0): kobject_uevent_env
[   31.327489] kobject: 'xuartps' (c91b4ba0): fill_kobj_path: path = '/bus/platform/drivers/xuartps'
[   31.327506] registering driver ipwireless
[   31.327514] bus: 'pcmcia': add driver ipwireless
[   31.327516] kobject: 'ipwireless' (c91b4c60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.327519] kobject: 'ipwireless' (c91b4c60): kobject_uevent_env
[   31.327521] kobject: 'ipwireless' (c91b4c60): fill_kobj_path: path = '/bus/pcmcia/drivers/ipwireless'
[   31.327606] device class 'raw': registering
[   31.327615] kobject: 'raw' (cad9110c): kobject_add_internal: parent: 'class', set: 'class'
[   31.327625] kobject: 'raw' (cad9110c): kobject_uevent_env
[   31.327627] kobject: 'raw' (cad9110c): fill_kobj_path: path = '/class/raw'
[   31.327659] device: 'rawctl': device_add
[   31.327663] kobject: 'raw' (cd942880): kobject_add_internal: parent: 'virtual', set: '(null)'
[   31.327669] kobject: 'rawctl' (cf8bce08): kobject_add_internal: parent: 'raw', set: 'devices'
[   31.327720] PM: Adding info for No Bus:rawctl
[   31.327725] kobject: 'rawctl' (cf8bce08): kobject_uevent_env
[   31.327728] kobject: 'rawctl' (cf8bce08): fill_kobj_path: path = '/devices/virtual/raw/rawctl'
[   31.327735] Generic RTC Driver v1.07
[   31.327744] device: 'rtc': device_add
[   31.327749] kobject: 'rtc' (cf8bd008): kobject_add_internal: parent: 'misc', set: 'devices'
[   31.327761] PM: Adding info for No Bus:rtc
[   31.327762] kobject: 'rtc' (cf8bd008): kobject_uevent_env
[   31.327764] kobject: 'rtc' (cf8bd008): fill_kobj_path: path = '/devices/virtual/misc/rtc'
[   31.327776] device: 'nvram': device_add
[   31.327777] kobject: 'nvram' (cf8bd208): kobject_add_internal: parent: 'misc', set: 'devices'
[   31.327797] PM: Adding info for No Bus:nvram
[   31.327798] kobject: 'nvram' (cf8bd208): kobject_uevent_env
[   31.327800] kobject: 'nvram' (cf8bd208): fill_kobj_path: path = '/devices/virtual/misc/nvram'
[   31.327806] Non-volatile memory driver v1.3
[   31.327817] toshiba: not a supported Toshiba laptop
[   31.327880] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[   31.327881] device: 'pc8736x_gpio.0': device_add
[   31.327882] kobject: 'pc8736x_gpio.0' (cf8bd410): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.327885] bus: 'platform': add device pc8736x_gpio.0
[   31.327894] PM: Adding info for platform:pc8736x_gpio.0
[   31.327895] kobject: 'pc8736x_gpio.0' (cf8bd410): kobject_uevent_env
[   31.327897] kobject: 'pc8736x_gpio.0' (cf8bd410): fill_kobj_path: path = '/devices/platform/pc8736x_gpio.0'
[   31.327938] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[   31.328564] platform pc8736x_gpio.0: no device found
[   31.328586] PM: Removing info for platform:pc8736x_gpio.0
[   31.328677] bus: 'platform': remove device pc8736x_gpio.0
[   31.328687] kobject: 'pc8736x_gpio.0' (cf8bd410): kobject_uevent_env
[   31.328698] kobject: 'pc8736x_gpio.0' (cf8bd410): fill_kobj_path: path = '/devices/platform/pc8736x_gpio.0'
[   31.328721] sysfs pc8736x_gpio.0: removing dir
[   31.328723] kobject: 'pc8736x_gpio.0' (cf8bd410): kobject_cleanup
[   31.328724] kobject: 'pc8736x_gpio.0' (cf8bd410): calling ktype release
[   31.328725] kobject: 'pc8736x_gpio.0': free name
[   31.328732] nsc_gpio initializing
[   31.329275] smapi::smapi_init, ERROR invalid usSmapiID
[   31.329276] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   31.329279] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   31.329279] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   31.329294] registering driver synclink_cs
[   31.329301] bus: 'pcmcia': add driver synclink_cs
[   31.329307] kobject: 'synclink_cs' (c91b4f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.329323] kobject: 'synclink_cs' (c91b4f00): kobject_uevent_env
[   31.329327] kobject: 'synclink_cs' (c91b4f00): fill_kobj_path: path = '/bus/pcmcia/drivers/synclink_cs'
[   31.329386] device: 'ttySLP0': device_add
[   31.329395] kobject: 'ttySLP0' (cf8bd408): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.329915] PM: Adding info for No Bus:ttySLP0
[   31.329923] kobject: 'ttySLP0' (cf8bd408): kobject_uevent_env
[   31.329942] kobject: 'ttySLP0' (cf8bd408): fill_kobj_path: path = '/devices/virtual/tty/ttySLP0'
[   31.330162] device: 'ttySLP1': device_add
[   31.330164] kobject: 'ttySLP1' (cf8bd608): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.330184] PM: Adding info for No Bus:ttySLP1
[   31.330185] kobject: 'ttySLP1' (cf8bd608): kobject_uevent_env
[   31.330187] kobject: 'ttySLP1' (cf8bd608): fill_kobj_path: path = '/devices/virtual/tty/ttySLP1'
[   31.330191] device: 'ttySLP2': device_add
[   31.330192] kobject: 'ttySLP2' (cf8bd808): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.330202] PM: Adding info for No Bus:ttySLP2
[   31.330210] kobject: 'ttySLP2' (cf8bd808): kobject_uevent_env
[   31.330213] kobject: 'ttySLP2' (cf8bd808): fill_kobj_path: path = '/devices/virtual/tty/ttySLP2'
[   31.330217] device: 'ttySLP3': device_add
[   31.330218] kobject: 'ttySLP3' (cf8bda08): kobject_add_internal: parent: 'tty', set: 'devices'
[   31.330226] PM: Adding info for No Bus:ttySLP3
[   31.330227] kobject: 'ttySLP3' (cf8bda08): kobject_uevent_env
[   31.330229] kobject: 'ttySLP3' (cf8bda08): fill_kobj_path: path = '/devices/virtual/tty/ttySLP3'
[   31.330255] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[   31.330268] device class 'cardman_4000': registering
[   31.330274] kobject: 'cardman_4000' (cad9120c): kobject_add_internal: parent: 'class', set: 'class'
[   31.330281] kobject: 'cardman_4000' (cad9120c): kobject_uevent_env
[   31.330283] kobject: 'cardman_4000' (cad9120c): fill_kobj_path: path = '/class/cardman_4000'
[   31.330313] registering driver cm4000_cs
[   31.330317] bus: 'pcmcia': add driver cm4000_cs
[   31.330322] kobject: 'cm4000_cs' (cd951240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.330351] kobject: 'cm4000_cs' (cd951240): kobject_uevent_env
[   31.330353] kobject: 'cm4000_cs' (cd951240): fill_kobj_path: path = '/bus/pcmcia/drivers/cm4000_cs'
[   31.330357] device class 'cardman_4040': registering
[   31.330359] kobject: 'cardman_4040' (cad9130c): kobject_add_internal: parent: 'class', set: 'class'
[   31.330361] kobject: 'cardman_4040' (cad9130c): kobject_uevent_env
[   31.330363] kobject: 'cardman_4040' (cad9130c): fill_kobj_path: path = '/class/cardman_4040'
[   31.330368] registering driver cm4040_cs
[   31.330369] bus: 'pcmcia': add driver cm4040_cs
[   31.330370] kobject: 'cm4040_cs' (cd951300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.330374] kobject: 'cm4040_cs' (cd951300): kobject_uevent_env
[   31.330375] kobject: 'cm4040_cs' (cd951300): fill_kobj_path: path = '/bus/pcmcia/drivers/cm4040_cs'
[   31.330379] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   31.330380] Hangcheck: Using getrawmonotonic().
[   31.330389] device class 'drm': registering
[   31.330391] kobject: 'drm' (cad9140c): kobject_add_internal: parent: 'class', set: 'class'
[   31.330396] kobject: 'drm' (cad9140c): kobject_uevent_env
[   31.330397] kobject: 'drm' (cad9140c): fill_kobj_path: path = '/class/drm'
[   31.330422] debugfs: creating file 'dri'
[   31.331050] [drm] Initialized drm 1.1.0 20060810
[   31.331184] bus: 'pci': add driver poulsbo
[   31.331197] kobject: 'poulsbo' (cd951420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331228] kobject: 'poulsbo' (cd951420): kobject_uevent_env
[   31.331234] kobject: 'poulsbo' (cd951420): fill_kobj_path: path = '/bus/pci/drivers/poulsbo'
[   31.331301] debugfs: creating file 'provoke-crash'
[   31.331315] debugfs: creating file 'DIRECT'
[   31.331322] lkdtm: No crash points registered, enable through debugfs
[   31.331325] bus: 'pci': add driver IOC4
[   31.331326] kobject: 'IOC4' (cd951480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331334] kobject: 'IOC4' (cd951480): kobject_uevent_env
[   31.331336] kobject: 'IOC4' (cd951480): fill_kobj_path: path = '/bus/pci/drivers/IOC4'
[   31.331343] device class 'enclosure': registering
[   31.331349] kobject: 'enclosure' (cad9150c): kobject_add_internal: parent: 'class', set: 'class'
[   31.331357] kobject: 'enclosure' (cad9150c): kobject_uevent_env
[   31.331358] kobject: 'enclosure' (cad9150c): fill_kobj_path: path = '/class/enclosure'
[   31.331377] bus: 'platform': add driver cs5535-mfgpt
[   31.331379] kobject: 'cs5535-mfgpt' (cd9514e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331398] kobject: 'cs5535-mfgpt' (cd9514e0): kobject_uevent_env
[   31.331400] kobject: 'cs5535-mfgpt' (cd9514e0): fill_kobj_path: path = '/bus/platform/drivers/cs5535-mfgpt'
[   31.331402] device class 'iLO': registering
[   31.331403] kobject: 'iLO' (cad9160c): kobject_add_internal: parent: 'class', set: 'class'
[   31.331409] kobject: 'iLO' (cad9160c): kobject_uevent_env
[   31.331411] kobject: 'iLO' (cad9160c): fill_kobj_path: path = '/class/iLO'
[   31.331416] bus: 'pci': add driver hpilo
[   31.331417] kobject: 'hpilo' (cd9515a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331422] kobject: 'hpilo' (cd9515a0): kobject_uevent_env
[   31.331423] kobject: 'hpilo' (cd9515a0): fill_kobj_path: path = '/bus/pci/drivers/hpilo'
[   31.331433] bus: 'i2c': add driver isl29003
[   31.331435] kobject: 'isl29003' (cd951600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331444] kobject: 'isl29003' (cd951600): kobject_uevent_env
[   31.331446] kobject: 'isl29003' (cd951600): fill_kobj_path: path = '/bus/i2c/drivers/isl29003'
[   31.331449] i2c-core: driver [isl29003] using legacy suspend method
[   31.331450] i2c-core: driver [isl29003] using legacy resume method
[   31.331453] i2c-core: driver [isl29003] registered
[   31.331454] bus: 'i2c': add driver at24
[   31.331456] kobject: 'at24' (cd951660): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331461] kobject: 'at24' (cd951660): kobject_uevent_env
[   31.331463] kobject: 'at24' (cd951660): fill_kobj_path: path = '/bus/i2c/drivers/at24'
[   31.331464] i2c-core: driver [at24] registered
[   31.331473] bus: 'spi': add driver at25
[   31.331475] kobject: 'at25' (cd9516c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331484] kobject: 'at25' (cd9516c0): kobject_uevent_env
[   31.331486] kobject: 'at25' (cd9516c0): fill_kobj_path: path = '/bus/spi/drivers/at25'
[   31.331487] bus: 'i2c': add driver eeprom
[   31.331489] kobject: 'eeprom' (cd951720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331492] kobject: 'eeprom' (cd951720): kobject_uevent_env
[   31.331494] kobject: 'eeprom' (cd951720): fill_kobj_path: path = '/bus/i2c/drivers/eeprom'
[   31.331496] i2c-core: driver [eeprom] registered
[   31.331497] bus: 'pci': add driver cb710
[   31.331498] kobject: 'cb710' (cd951780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331505] kobject: 'cb710' (cd951780): kobject_uevent_env
[   31.331507] kobject: 'cb710' (cd951780): fill_kobj_path: path = '/bus/pci/drivers/cb710'
[   31.331510] bus: 'platform': add driver kim
[   31.331512] kobject: 'kim' (cd9517e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331518] kobject: 'kim' (cd9517e0): kobject_uevent_env
[   31.331520] kobject: 'kim' (cd9517e0): fill_kobj_path: path = '/bus/platform/drivers/kim'
[   31.331522] bus: 'i2c': add driver fsa9480
[   31.331524] kobject: 'fsa9480' (cd951840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331527] kobject: 'fsa9480' (cd951840): kobject_uevent_env
[   31.331529] kobject: 'fsa9480' (cd951840): fill_kobj_path: path = '/bus/i2c/drivers/fsa9480'
[   31.331530] i2c-core: driver [fsa9480] using legacy suspend method
[   31.331530] i2c-core: driver [fsa9480] using legacy resume method
[   31.331531] i2c-core: driver [fsa9480] registered
[   31.331533] bus: 'platform': add driver sm501
[   31.331534] kobject: 'sm501' (cd9518a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331540] kobject: 'sm501' (cd9518a0): kobject_uevent_env
[   31.331542] kobject: 'sm501' (cd9518a0): fill_kobj_path: path = '/bus/platform/drivers/sm501'
[   31.331544] bus: 'pci': add driver sm501
[   31.331545] kobject: 'sm501' (cd951900): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331549] kobject: 'sm501' (cd951900): kobject_uevent_env
[   31.331551] kobject: 'sm501' (cd951900): fill_kobj_path: path = '/bus/pci/drivers/sm501'
[   31.331556] bus: 'platform': add driver pasic3
[   31.331558] kobject: 'pasic3' (cd951960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331562] kobject: 'pasic3' (cd951960): kobject_uevent_env
[   31.331564] kobject: 'pasic3' (cd951960): fill_kobj_path: path = '/bus/platform/drivers/pasic3'
[   31.331573] bus: 'platform': remove driver pasic3
[   31.331578] kobject: 'pasic3' (cd951960): kobject_cleanup
[   31.331579] kobject: 'pasic3' (cd951960): auto cleanup 'remove' event
[   31.331580] kobject: 'pasic3' (cd951960): kobject_uevent_env
[   31.331582] kobject: 'pasic3' (cd951960): fill_kobj_path: path = '/bus/platform/drivers/pasic3'
[   31.331583] kobject: 'pasic3' (cd951960): auto cleanup kobject_del
[   31.331586] sysfs pasic3: removing dir
[   31.331589] kobject: 'pasic3' (cd951960): calling ktype release
[   31.331592] driver: 'pasic3': driver_release
[   31.331593] kobject: 'pasic3': free name
[   31.331594] bus: 'i2c': add driver htcpld-chip
[   31.331596] kobject: 'htcpld-chip' (cd951960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331599] kobject: 'htcpld-chip' (cd951960): kobject_uevent_env
[   31.331601] kobject: 'htcpld-chip' (cd951960): fill_kobj_path: path = '/bus/i2c/drivers/htcpld-chip'
[   31.331602] i2c-core: driver [htcpld-chip] registered
[   31.331604] bus: 'platform': add driver i2c-htcpld
[   31.331605] kobject: 'i2c-htcpld' (cd9519c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331608] kobject: 'i2c-htcpld' (cd9519c0): kobject_uevent_env
[   31.331610] kobject: 'i2c-htcpld' (cd9519c0): fill_kobj_path: path = '/bus/platform/drivers/i2c-htcpld'
[   31.331612] bus: 'platform': remove driver i2c-htcpld
[   31.331613] kobject: 'i2c-htcpld' (cd9519c0): kobject_cleanup
[   31.331614] kobject: 'i2c-htcpld' (cd9519c0): auto cleanup 'remove' event
[   31.331615] kobject: 'i2c-htcpld' (cd9519c0): kobject_uevent_env
[   31.331616] kobject: 'i2c-htcpld' (cd9519c0): fill_kobj_path: path = '/bus/platform/drivers/i2c-htcpld'
[   31.331618] kobject: 'i2c-htcpld' (cd9519c0): auto cleanup kobject_del
[   31.331619] sysfs i2c-htcpld: removing dir
[   31.331620] kobject: 'i2c-htcpld' (cd9519c0): calling ktype release
[   31.331620] driver: 'i2c-htcpld': driver_release
[   31.331621] kobject: 'i2c-htcpld': free name
[   31.331625] bus: 'i2c': add driver wm8994
[   31.331627] kobject: 'wm8994' (cd9519c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.331630] kobject: 'wm8994' (cd9519c0): kobject_uevent_env
[   31.331631] kobject: 'wm8994' (cd9519c0): fill_kobj_path: path = '/bus/i2c/drivers/wm8994'
[   31.331633] i2c-core: driver [wm8994] registered
[   31.332108] bus: 'pci': add driver lpc_sch
[   31.332138] kobject: 'lpc_sch' (cd951a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332205] kobject: 'lpc_sch' (cd951a20): kobject_uevent_env
[   31.332212] kobject: 'lpc_sch' (cd951a20): fill_kobj_path: path = '/bus/pci/drivers/lpc_sch'
[   31.332257] bus: 'pci': add driver RDC321x Southbridge
[   31.332258] kobject: 'RDC321x Southbridge' (cd951a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332265] kobject: 'RDC321x Southbridge' (cd951a80): kobject_uevent_env
[   31.332267] kobject: 'RDC321x Southbridge' (cd951a80): fill_kobj_path: path = '/bus/pci/drivers/RDC321x Southbridge'
[   31.332270] bus: 'pci': add driver janz-cmodio
[   31.332272] kobject: 'janz-cmodio' (cd951ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332278] kobject: 'janz-cmodio' (cd951ae0): kobject_uevent_env
[   31.332280] kobject: 'janz-cmodio' (cd951ae0): fill_kobj_path: path = '/bus/pci/drivers/janz-cmodio'
[   31.332283] bus: 'pci': add driver vx855
[   31.332284] kobject: 'vx855' (cd951b40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332288] kobject: 'vx855' (cd951b40): kobject_uevent_env
[   31.332290] kobject: 'vx855' (cd951b40): fill_kobj_path: path = '/bus/pci/drivers/vx855'
[   31.332293] bus: 'pci': add driver cs5535-mfd
[   31.332294] kobject: 'cs5535-mfd' (cd951ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332328] kobject: 'cs5535-mfd' (cd951ba0): kobject_uevent_env
[   31.332329] kobject: 'cs5535-mfd' (cd951ba0): fill_kobj_path: path = '/bus/pci/drivers/cs5535-mfd'
[   31.332334] Uniform Multi-Platform E-IDE driver
[   31.332353] kobject: 'ide' (cad9170c): kobject_add_internal: parent: 'bus', set: 'bus'
[   31.332364] kobject: 'ide' (cad9170c): kobject_uevent_env
[   31.332368] kobject: 'ide' (cad9170c): fill_kobj_path: path = '/bus/ide'
[   31.332374] kobject: 'devices' (cd95720c): kobject_add_internal: parent: 'ide', set: '<NULL>'
[   31.332375] kobject: 'devices' (cd95720c): kobject_uevent_env
[   31.332376] kobject: 'devices' (cd95720c): kobject_uevent_env: filter function caused the event to drop!
[   31.332380] kobject: 'drivers' (cd95728c): kobject_add_internal: parent: 'ide', set: '<NULL>'
[   31.332382] kobject: 'drivers' (cd95728c): kobject_uevent_env
[   31.332383] kobject: 'drivers' (cd95728c): kobject_uevent_env: filter function caused the event to drop!
[   31.332387] bus: 'ide': registered
[   31.332392] device class 'ide_port': registering
[   31.332394] kobject: 'ide_port' (cad9180c): kobject_add_internal: parent: 'class', set: 'class'
[   31.332401] kobject: 'ide_port' (cad9180c): kobject_uevent_env
[   31.332403] kobject: 'ide_port' (cad9180c): fill_kobj_path: path = '/class/ide_port'
[   31.332450] bus: 'pci': add driver cs5536
[   31.332451] kobject: 'cs5536' (cd951cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332459] kobject: 'cs5536' (cd951cc0): kobject_uevent_env
[   31.332460] kobject: 'cs5536' (cd951cc0): fill_kobj_path: path = '/bus/pci/drivers/cs5536'
[   31.332466] bus: 'pci': add driver Delkin-ASKA-Workbit Cardbus IDE
[   31.332467] kobject: 'Delkin-ASKA-Workbit Cardbus IDE' (cd951d20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332473] kobject: 'Delkin-ASKA-Workbit Cardbus IDE' (cd951d20): kobject_uevent_env
[   31.332476] kobject: 'Delkin-ASKA-Workbit Cardbus IDE' (cd951d20): fill_kobj_path: path = '/bus/pci/drivers/Delkin-ASKA-Workbit Cardbus IDE'
[   31.332495] bus: 'pci': add driver AEC62xx_IDE
[   31.332497] kobject: 'AEC62xx_IDE' (cd951d80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332504] kobject: 'AEC62xx_IDE' (cd951d80): kobject_uevent_env
[   31.332506] kobject: 'AEC62xx_IDE' (cd951d80): fill_kobj_path: path = '/bus/pci/drivers/AEC62xx_IDE'
[   31.332509] bus: 'pci': add driver ALI15x3_IDE
[   31.332510] kobject: 'ALI15x3_IDE' (cd951de0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332515] kobject: 'ALI15x3_IDE' (cd951de0): kobject_uevent_env
[   31.332517] kobject: 'ALI15x3_IDE' (cd951de0): fill_kobj_path: path = '/bus/pci/drivers/ALI15x3_IDE'
[   31.332519] bus: 'pci': add driver CS5530 IDE
[   31.332521] kobject: 'CS5530 IDE' (cd951e40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332525] kobject: 'CS5530 IDE' (cd951e40): kobject_uevent_env
[   31.332527] kobject: 'CS5530 IDE' (cd951e40): fill_kobj_path: path = '/bus/pci/drivers/CS5530 IDE'
[   31.332530] bus: 'pci': add driver CS5535_IDE
[   31.332532] kobject: 'CS5535_IDE' (cd951ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332536] kobject: 'CS5535_IDE' (cd951ea0): kobject_uevent_env
[   31.332537] kobject: 'CS5535_IDE' (cd951ea0): fill_kobj_path: path = '/bus/pci/drivers/CS5535_IDE'
[   31.332540] bus: 'pci': add driver HPT366_IDE
[   31.332542] kobject: 'HPT366_IDE' (cd951f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332546] kobject: 'HPT366_IDE' (cd951f00): kobject_uevent_env
[   31.332547] kobject: 'HPT366_IDE' (cd951f00): fill_kobj_path: path = '/bus/pci/drivers/HPT366_IDE'
[   31.332550] bus: 'pci': add driver IT8172_IDE
[   31.332552] kobject: 'IT8172_IDE' (cd951f60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332556] kobject: 'IT8172_IDE' (cd951f60): kobject_uevent_env
[   31.332558] kobject: 'IT8172_IDE' (cd951f60): fill_kobj_path: path = '/bus/pci/drivers/IT8172_IDE'
[   31.332561] bus: 'pci': add driver ITE8213_IDE
[   31.332566] kobject: 'ITE8213_IDE' (cd958000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332579] kobject: 'ITE8213_IDE' (cd958000): kobject_uevent_env
[   31.332584] kobject: 'ITE8213_IDE' (cd958000): fill_kobj_path: path = '/bus/pci/drivers/ITE8213_IDE'
[   31.332588] bus: 'pci': add driver ITE821x IDE
[   31.332589] kobject: 'ITE821x IDE' (cd958060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332593] kobject: 'ITE821x IDE' (cd958060): kobject_uevent_env
[   31.332595] kobject: 'ITE821x IDE' (cd958060): fill_kobj_path: path = '/bus/pci/drivers/ITE821x IDE'
[   31.332598] bus: 'pci': add driver JMicron IDE
[   31.332599] kobject: 'JMicron IDE' (cd9580c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332603] kobject: 'JMicron IDE' (cd9580c0): kobject_uevent_env
[   31.332605] kobject: 'JMicron IDE' (cd9580c0): fill_kobj_path: path = '/bus/pci/drivers/JMicron IDE'
[   31.332608] bus: 'pci': add driver Promise_Old_IDE
[   31.332609] kobject: 'Promise_Old_IDE' (cd958120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332613] kobject: 'Promise_Old_IDE' (cd958120): kobject_uevent_env
[   31.332615] kobject: 'Promise_Old_IDE' (cd958120): fill_kobj_path: path = '/bus/pci/drivers/Promise_Old_IDE'
[   31.332618] bus: 'pci': add driver Serverworks_IDE
[   31.332619] kobject: 'Serverworks_IDE' (cd958180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332624] kobject: 'Serverworks_IDE' (cd958180): kobject_uevent_env
[   31.332625] kobject: 'Serverworks_IDE' (cd958180): fill_kobj_path: path = '/bus/pci/drivers/Serverworks_IDE'
[   31.332628] bus: 'pci': add driver SiI_IDE
[   31.332630] kobject: 'SiI_IDE' (cd9581e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332634] kobject: 'SiI_IDE' (cd9581e0): kobject_uevent_env
[   31.332636] kobject: 'SiI_IDE' (cd9581e0): fill_kobj_path: path = '/bus/pci/drivers/SiI_IDE'
[   31.332638] bus: 'pci': add driver SLC90e66_IDE
[   31.332640] kobject: 'SLC90e66_IDE' (cd958240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332644] kobject: 'SLC90e66_IDE' (cd958240): kobject_uevent_env
[   31.332646] kobject: 'SLC90e66_IDE' (cd958240): fill_kobj_path: path = '/bus/pci/drivers/SLC90e66_IDE'
[   31.332648] bus: 'pci': add driver TC86C001
[   31.332650] kobject: 'TC86C001' (cd9582a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332654] kobject: 'TC86C001' (cd9582a0): kobject_uevent_env
[   31.332656] kobject: 'TC86C001' (cd9582a0): fill_kobj_path: path = '/bus/pci/drivers/TC86C001'
[   31.332658] bus: 'pci': add driver TRIFLEX_IDE
[   31.332660] kobject: 'TRIFLEX_IDE' (cd958300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332664] kobject: 'TRIFLEX_IDE' (cd958300): kobject_uevent_env
[   31.332666] kobject: 'TRIFLEX_IDE' (cd958300): fill_kobj_path: path = '/bus/pci/drivers/TRIFLEX_IDE'
[   31.332668] bus: 'pci': add driver TRM290_IDE
[   31.332670] kobject: 'TRM290_IDE' (cd958360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.332674] kobject: 'TRM290_IDE' (cd958360): kobject_uevent_env
[   31.332675] kobject: 'TRM290_IDE' (cd958360): fill_kobj_path: path = '/bus/pci/drivers/TRM290_IDE'
[   31.334163] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   31.334475] device class 'raid_devices': registering
[   31.334530] kobject: 'raid_devices' (cad9190c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334572] kobject: 'raid_devices' (cad9190c): kobject_uevent_env
[   31.334578] kobject: 'raid_devices' (cad9190c): fill_kobj_path: path = '/class/raid_devices'
[   31.334631] Loading iSCSI transport class v2.0-870.
[   31.334638] device class 'iscsi_transport': registering
[   31.334640] kobject: 'iscsi_transport' (cad91a0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334685] kobject: 'iscsi_transport' (cad91a0c): kobject_uevent_env
[   31.334687] kobject: 'iscsi_transport' (cad91a0c): fill_kobj_path: path = '/class/iscsi_transport'
[   31.334689] device class 'iscsi_endpoint': registering
[   31.334695] kobject: 'iscsi_endpoint' (cad91b0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334697] kobject: 'iscsi_endpoint' (cad91b0c): kobject_uevent_env
[   31.334699] kobject: 'iscsi_endpoint' (cad91b0c): fill_kobj_path: path = '/class/iscsi_endpoint'
[   31.334700] device class 'iscsi_iface': registering
[   31.334702] kobject: 'iscsi_iface' (cad91c0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334704] kobject: 'iscsi_iface' (cad91c0c): kobject_uevent_env
[   31.334706] kobject: 'iscsi_iface' (cad91c0c): fill_kobj_path: path = '/class/iscsi_iface'
[   31.334707] device class 'iscsi_host': registering
[   31.334709] kobject: 'iscsi_host' (cad91d0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334715] kobject: 'iscsi_host' (cad91d0c): kobject_uevent_env
[   31.334716] kobject: 'iscsi_host' (cad91d0c): fill_kobj_path: path = '/class/iscsi_host'
[   31.334718] device class 'iscsi_connection': registering
[   31.334719] kobject: 'iscsi_connection' (cad91e0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334721] kobject: 'iscsi_connection' (cad91e0c): kobject_uevent_env
[   31.334723] kobject: 'iscsi_connection' (cad91e0c): fill_kobj_path: path = '/class/iscsi_connection'
[   31.334724] device class 'iscsi_session': registering
[   31.334726] kobject: 'iscsi_session' (cad91f0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.334728] kobject: 'iscsi_session' (cad91f0c): kobject_uevent_env
[   31.334729] kobject: 'iscsi_session' (cad91f0c): fill_kobj_path: path = '/class/iscsi_session'
[   31.335038] device class 'sas_host': registering
[   31.335048] kobject: 'sas_host' (cc35100c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335055] kobject: 'sas_host' (cc35100c): kobject_uevent_env
[   31.335056] kobject: 'sas_host' (cc35100c): fill_kobj_path: path = '/class/sas_host'
[   31.335058] device class 'sas_phy': registering
[   31.335064] kobject: 'sas_phy' (cc35110c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335065] kobject: 'sas_phy' (cc35110c): kobject_uevent_env
[   31.335067] kobject: 'sas_phy' (cc35110c): fill_kobj_path: path = '/class/sas_phy'
[   31.335068] device class 'sas_port': registering
[   31.335070] kobject: 'sas_port' (cc35120c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335071] kobject: 'sas_port' (cc35120c): kobject_uevent_env
[   31.335073] kobject: 'sas_port' (cc35120c): fill_kobj_path: path = '/class/sas_port'
[   31.335074] device class 'sas_device': registering
[   31.335076] kobject: 'sas_device' (cc35130c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335080] kobject: 'sas_device' (cc35130c): kobject_uevent_env
[   31.335081] kobject: 'sas_device' (cc35130c): fill_kobj_path: path = '/class/sas_device'
[   31.335083] device class 'sas_end_device': registering
[   31.335085] kobject: 'sas_end_device' (cc35140c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335087] kobject: 'sas_end_device' (cc35140c): kobject_uevent_env
[   31.335088] kobject: 'sas_end_device' (cc35140c): fill_kobj_path: path = '/class/sas_end_device'
[   31.335090] device class 'sas_expander': registering
[   31.335091] kobject: 'sas_expander' (cc35150c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335093] kobject: 'sas_expander' (cc35150c): kobject_uevent_env
[   31.335095] kobject: 'sas_expander' (cc35150c): fill_kobj_path: path = '/class/sas_expander'
[   31.335158] osst :I: Tape driver with OnStream support version 0.99.4
[   31.335158] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   31.335159] device class 'onstream_tape': registering
[   31.335161] kobject: 'onstream_tape' (cc35160c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335165] kobject: 'onstream_tape' (cc35160c): kobject_uevent_env
[   31.335167] kobject: 'onstream_tape' (cc35160c): fill_kobj_path: path = '/class/onstream_tape'
[   31.335187] bus: 'scsi': add driver osst
[   31.335190] kobject: 'osst' (cd958480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.335200] kobject: 'osst' (cd958480): kobject_uevent_env
[   31.335202] kobject: 'osst' (cd958480): fill_kobj_path: path = '/bus/scsi/drivers/osst'
[   31.335207] SCSI Media Changer driver v0.25 
[   31.335208] device class 'scsi_changer': registering
[   31.335210] kobject: 'scsi_changer' (cc35170c): kobject_add_internal: parent: 'class', set: 'class'
[   31.335214] kobject: 'scsi_changer' (cc35170c): kobject_uevent_env
[   31.335216] kobject: 'scsi_changer' (cc35170c): fill_kobj_path: path = '/class/scsi_changer'
[   31.335220] bus: 'scsi': add driver ch
[   31.335222] kobject: 'ch' (cd958540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.335225] kobject: 'ch' (cd958540): kobject_uevent_env
[   31.335226] kobject: 'ch' (cd958540): fill_kobj_path: path = '/bus/scsi/drivers/ch'
[   31.335242] bus: 'pci': add driver ahci
[   31.335243] kobject: 'ahci' (cd9585a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.335273] kobject: 'ahci' (cd9585a0): kobject_uevent_env
[   31.335274] kobject: 'ahci' (cd9585a0): fill_kobj_path: path = '/bus/pci/drivers/ahci'
[   31.335796] bus: 'pci': add driver sata_inic162x
[   31.335825] kobject: 'sata_inic162x' (cd958600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.335863] kobject: 'sata_inic162x' (cd958600): kobject_uevent_env
[   31.335869] kobject: 'sata_inic162x' (cd958600): fill_kobj_path: path = '/bus/pci/drivers/sata_inic162x'
[   31.335906] TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v4.1.0-rc2-ml on Linux/i686 on 3.6.0-rc7-bisect2-00039-g6f0f9b6-dirty
[   31.336290] kobject: ':t-0000648' (cf84cdcc): kobject_add_internal: parent: 'slab', set: 'slab'
[   31.336344] kobject: ':t-0000648' (cf84cdcc): kobject_uevent_env
[   31.336350] kobject: ':t-0000648' (cf84cdcc): fill_kobj_path: path = '/kernel/slab/:t-0000648'
[   31.336369] kobject: ':t-0000104' (cf84cd4c): kobject_add_internal: parent: 'slab', set: 'slab'
[   31.336408] kobject: ':t-0000104' (cf84cd4c): kobject_uevent_env
[   31.336410] kobject: ':t-0000104' (cf84cd4c): fill_kobj_path: path = '/kernel/slab/:t-0000104'
[   31.336434] kobject: ':t-0000168' (cf84cccc): kobject_add_internal: parent: 'slab', set: 'slab'
[   31.336469] kobject: ':t-0000168' (cf84cccc): kobject_uevent_env
[   31.336471] kobject: ':t-0000168' (cf84cccc): fill_kobj_path: path = '/kernel/slab/:t-0000168'
[   31.337360] TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v4.1.0-rc2-ml on Linux/i686 on 3.6.0-rc7-bisect2-00039-g6f0f9b6-dirty
[   31.337372] TCM: Registered subsystem plugin: rd_mcp struct module:   (null)
[   31.337388] CORE_HBA[0] - TCM Ramdisk HBA Driver v4.0 on Generic Target Core Stack v4.1.0-rc2-ml
[   31.337389] CORE_HBA[0] - Attached HBA to Generic Target Core
[   31.337411] RAMDISK: Referencing Page Count: 8
[   31.337428] CORE_RD[0] - Built Ramdisk Device ID: 0 space of 8 pages in 1 tables
[   31.337439] Rounding down aligned max_sectors from 4294967295 to 8388600
[   31.337444] rd_mcp: Using SAM_TASK_ATTR_EMULATED for SPC: 0x05 device
[   31.337449] rd_mcp: Using SPC_PASSTHROUGH, no reservation emulation
[   31.337454] rd_mcp: Using SPC_ALUA_PASSTHROUGH, no ALUA emulation
[   31.337638]   Vendor: LIO-ORG 
[   31.337639]   Model: RAMDISK-MCP     
[   31.337639]   Revision: 4.0 
[   31.337649]   Type:   Direct-Access     
[   31.337649]                  ANSI SCSI revision: 05
[   31.337651] CORE_RD[0] - Added TCM MEMCPY Ramdisk Device ID: 0 of 8 pages in 1 tables, 32768 total bytes
[   31.337717] kobject: ':t-0000440' (cf8ca1cc): kobject_add_internal: parent: 'slab', set: 'slab'
[   31.337787] kobject: ':t-0000440' (cf8ca1cc): kobject_uevent_env
[   31.337800] kobject: ':t-0000440' (cf8ca1cc): fill_kobj_path: path = '/kernel/slab/:t-0000440'
[   31.337852] device: 'tcm_loop_0': device_add
[   31.337856] kobject: 'tcm_loop_0' (cf8bde08): kobject_add_internal: parent: 'devices', set: 'devices'
[   31.337890] PM: Adding info for No Bus:tcm_loop_0
[   31.337891] kobject: 'tcm_loop_0' (cf8bde08): kobject_uevent_env
[   31.337896] kobject: 'tcm_loop_0' (cf8bde08): kobject_uevent_env: filter function caused the event to drop!
[   31.337906] kobject: 'tcm_loop_bus' (cc351a0c): kobject_add_internal: parent: 'bus', set: 'bus'
[   31.337917] kobject: 'tcm_loop_bus' (cc351a0c): kobject_uevent_env
[   31.337919] kobject: 'tcm_loop_bus' (cc351a0c): fill_kobj_path: path = '/bus/tcm_loop_bus'
[   31.337922] kobject: 'devices' (cf89d98c): kobject_add_internal: parent: 'tcm_loop_bus', set: '<NULL>'
[   31.337923] kobject: 'devices' (cf89d98c): kobject_uevent_env
[   31.337924] kobject: 'devices' (cf89d98c): kobject_uevent_env: filter function caused the event to drop!
[   31.337926] kobject: 'drivers' (cf89da0c): kobject_add_internal: parent: 'tcm_loop_bus', set: '<NULL>'
[   31.337927] kobject: 'drivers' (cf89da0c): kobject_uevent_env
[   31.337928] kobject: 'drivers' (cf89da0c): kobject_uevent_env: filter function caused the event to drop!
[   31.337935] bus: 'tcm_loop_bus': registered
[   31.337939] bus: 'tcm_loop_bus': add driver tcm_loop
[   31.337940] kobject: 'tcm_loop' (cd958780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.337946] kobject: 'tcm_loop' (cd958780): kobject_uevent_env
[   31.337948] kobject: 'tcm_loop' (cd958780): fill_kobj_path: path = '/bus/tcm_loop_bus/drivers/tcm_loop'
[   31.337955] Initialized TCM Loop Core Bus
[   31.337962] Setup generic discovery
[   31.337962] Setup generic wwn
[   31.337963] Setup generic wwn_fabric_stats
[   31.337964] Setup generic tpg
[   31.337964] Setup generic tpg_base
[   31.337965] Setup generic tpg_port
[   31.337965] Setup generic tpg_port_stat
[   31.337966] Setup generic tpg_lun
[   31.337967] Setup generic tpg_np
[   31.337967] Setup generic tpg_np_base
[   31.337968] Setup generic tpg_attrib
[   31.337969] Setup generic tpg_param
[   31.337969] Setup generic tpg_nacl
[   31.337970] Setup generic tpg_nacl_base
[   31.337970] Setup generic tpg_nacl_attrib
[   31.337971] Setup generic tpg_nacl_auth
[   31.337972] Setup generic tpg_nacl_param
[   31.337972] Setup generic tpg_nacl_stat
[   31.337973] Setup generic tpg_mappedlun
[   31.337973] Setup generic tpg_mappedlun_stat
[   31.337974] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[   31.337975] Initialized struct target_fabric_configfs: cd945800 for loopback
[   31.337977] <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[   31.337977] TCM_LOOP[0] - Set fabric -> tcm_loop_fabric_configfs
[   31.337991] bus: 'pci': add driver dw_spi_pci
[   31.337993] kobject: 'dw_spi_pci' (cd9587e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.338016] kobject: 'dw_spi_pci' (cd9587e0): kobject_uevent_env
[   31.338018] kobject: 'dw_spi_pci' (cd9587e0): fill_kobj_path: path = '/bus/pci/drivers/dw_spi_pci'
[   31.338040] bus: 'platform': add driver spi_oc_tiny
[   31.338042] kobject: 'spi_oc_tiny' (cd958840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.338062] kobject: 'spi_oc_tiny' (cd958840): kobject_uevent_env
[   31.338064] kobject: 'spi_oc_tiny' (cd958840): fill_kobj_path: path = '/bus/platform/drivers/spi_oc_tiny'
[   31.338070] bus: 'spi': add driver tle62x0
[   31.338072] kobject: 'tle62x0' (cd9588a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.338079] kobject: 'tle62x0' (cd9588a0): kobject_uevent_env
[   31.338081] kobject: 'tle62x0' (cd9588a0): fill_kobj_path: path = '/bus/spi/drivers/tle62x0'
[   31.338083] bus: 'platform': add driver pch-spi
[   31.338084] kobject: 'pch-spi' (cd958900): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.338096] kobject: 'pch-spi' (cd958900): kobject_uevent_env
[   31.338098] kobject: 'pch-spi' (cd958900): fill_kobj_path: path = '/bus/platform/drivers/pch-spi'
[   31.338102] bus: 'pci': add driver pch_spi
[   31.338103] kobject: 'pch_spi' (cd958960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.338108] kobject: 'pch_spi' (cd958960): kobject_uevent_env
[   31.338115] kobject: 'pch_spi' (cd958960): fill_kobj_path: path = '/bus/pci/drivers/pch_spi'
[   31.338415] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   31.338732] device: 'eql': device_add
[   31.338750] kobject: 'eql' (cf900a34): kobject_add_internal: parent: 'net', set: 'devices'
[   31.338841] PM: Adding info for No Bus:eql
[   31.338844] kobject: 'eql' (cf900a34): kobject_uevent_env
[   31.338852] kobject: 'eql' (cf900a34): fill_kobj_path: path = '/devices/virtual/net/eql'
[   31.338886] kobject: 'queues' (cf89ef8c): kobject_add_internal: parent: 'eql', set: '<NULL>'
[   31.338887] kobject: 'queues' (cf89ef8c): kobject_uevent_env
[   31.338889] kobject: 'queues' (cf89ef8c): kobject_uevent_env: filter function caused the event to drop!
[   31.338890] kobject: 'rx-0' (cf89e208): kobject_add_internal: parent: 'queues', set: 'queues'
[   31.338922] kobject: 'rx-0' (cf89e208): kobject_uevent_env
[   31.338924] kobject: 'rx-0' (cf89e208): fill_kobj_path: path = '/devices/virtual/net/eql/queues/rx-0'
[   31.338927] kobject: 'tx-0' (cc351b0c): kobject_add_internal: parent: 'queues', set: 'queues'
[   31.338946] kobject: 'tx-0' (cc351b0c): kobject_uevent_env
[   31.338948] kobject: 'tx-0' (cc351b0c): fill_kobj_path: path = '/devices/virtual/net/eql/queues/tx-0'
[   31.338954] eql: Dropping NETIF_F_GSO since no SG feature.
[   31.338956] eql: Features changed: 0x0000000000004800 -> 0x0000000000004000
[   31.339024] bus: 'mdio_bus': add driver Cicada Cis8201
[   31.339026] kobject: 'Cicada Cis8201' (cd958a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339032] kobject: 'Cicada Cis8201' (cd958a20): kobject_uevent_env
[   31.339034] kobject: 'Cicada Cis8201' (cd958a20): fill_kobj_path: path = '/bus/mdio_bus/drivers/Cicada Cis8201'
[   31.339040] libphy: Cicada Cis8201: Registered new driver
[   31.339041] bus: 'mdio_bus': add driver Cicada Cis8204
[   31.339043] kobject: 'Cicada Cis8204' (cd958a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339046] kobject: 'Cicada Cis8204' (cd958a80): kobject_uevent_env
[   31.339048] kobject: 'Cicada Cis8204' (cd958a80): fill_kobj_path: path = '/bus/mdio_bus/drivers/Cicada Cis8204'
[   31.339050] libphy: Cicada Cis8204: Registered new driver
[   31.339051] bus: 'mdio_bus': add driver LXT970
[   31.339052] kobject: 'LXT970' (cd958ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339055] kobject: 'LXT970' (cd958ae0): kobject_uevent_env
[   31.339057] kobject: 'LXT970' (cd958ae0): fill_kobj_path: path = '/bus/mdio_bus/drivers/LXT970'
[   31.339058] libphy: LXT970: Registered new driver
[   31.339059] bus: 'mdio_bus': add driver LXT971
[   31.339061] kobject: 'LXT971' (cd958b40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339064] kobject: 'LXT971' (cd958b40): kobject_uevent_env
[   31.339065] kobject: 'LXT971' (cd958b40): fill_kobj_path: path = '/bus/mdio_bus/drivers/LXT971'
[   31.339066] libphy: LXT971: Registered new driver
[   31.339067] bus: 'mdio_bus': add driver LXT973
[   31.339069] kobject: 'LXT973' (cd958ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339072] kobject: 'LXT973' (cd958ba0): kobject_uevent_env
[   31.339073] kobject: 'LXT973' (cd958ba0): fill_kobj_path: path = '/bus/mdio_bus/drivers/LXT973'
[   31.339075] libphy: LXT973: Registered new driver
[   31.339076] bus: 'mdio_bus': add driver QS6612
[   31.339077] kobject: 'QS6612' (cd958c00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339080] kobject: 'QS6612' (cd958c00): kobject_uevent_env
[   31.339082] kobject: 'QS6612' (cd958c00): fill_kobj_path: path = '/bus/mdio_bus/drivers/QS6612'
[   31.339083] libphy: QS6612: Registered new driver
[   31.339086] bus: 'mdio_bus': add driver ICPlus IP175C
[   31.339088] kobject: 'ICPlus IP175C' (cd958c60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339091] kobject: 'ICPlus IP175C' (cd958c60): kobject_uevent_env
[   31.339097] kobject: 'ICPlus IP175C' (cd958c60): fill_kobj_path: path = '/bus/mdio_bus/drivers/ICPlus IP175C'
[   31.339098] libphy: ICPlus IP175C: Registered new driver
[   31.339099] bus: 'mdio_bus': add driver ICPlus IP1001
[   31.339101] kobject: 'ICPlus IP1001' (cd958cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339104] kobject: 'ICPlus IP1001' (cd958cc0): kobject_uevent_env
[   31.339106] kobject: 'ICPlus IP1001' (cd958cc0): fill_kobj_path: path = '/bus/mdio_bus/drivers/ICPlus IP1001'
[   31.339107] libphy: ICPlus IP1001: Registered new driver
[   31.339108] bus: 'mdio_bus': add driver ICPlus IP101A/G
[   31.339110] kobject: 'ICPlus IP101A!G' (cd958d20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339113] kobject: 'ICPlus IP101A!G' (cd958d20): kobject_uevent_env
[   31.339115] kobject: 'ICPlus IP101A!G' (cd958d20): fill_kobj_path: path = '/bus/mdio_bus/drivers/ICPlus IP101A!G'
[   31.339116] libphy: ICPlus IP101A/G: Registered new driver
[   31.339117] bus: 'mdio_bus': add driver ET1011C
[   31.339119] kobject: 'ET1011C' (cd958d80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339121] kobject: 'ET1011C' (cd958d80): kobject_uevent_env
[   31.339123] kobject: 'ET1011C' (cd958d80): fill_kobj_path: path = '/bus/mdio_bus/drivers/ET1011C'
[   31.339124] libphy: ET1011C: Registered new driver
[   31.339145] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   31.339146] device: 'Fixed MDIO bus.0': device_add
[   31.339147] kobject: 'Fixed MDIO bus.0' (cf910010): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.339166] bus: 'platform': add device Fixed MDIO bus.0
[   31.339699] PM: Adding info for platform:Fixed MDIO bus.0
[   31.339714] kobject: 'Fixed MDIO bus.0' (cf910010): kobject_uevent_env
[   31.339724] kobject: 'Fixed MDIO bus.0' (cf910010): fill_kobj_path: path = '/devices/platform/Fixed MDIO bus.0'
[   31.339857] device: 'fixed-0': device_add
[   31.339861] kobject: 'mdio_bus' (cf89ffc0): kobject_add_internal: parent: 'Fixed MDIO bus.0', set: '(null)'
[   31.339887] kobject: 'fixed-0' (cd945c4c): kobject_add_internal: parent: 'mdio_bus', set: 'devices'
[   31.339910] PM: Adding info for No Bus:fixed-0
[   31.339911] kobject: 'fixed-0' (cd945c4c): kobject_uevent_env
[   31.339913] kobject: 'fixed-0' (cd945c4c): fill_kobj_path: path = '/devices/platform/Fixed MDIO bus.0/mdio_bus/fixed-0'
[   31.339918] libphy: Fixed MDIO Bus: probed
[   31.339933] bus: 'mdio_bus': add driver STe101p
[   31.339937] kobject: 'STe101p' (cd958ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339941] kobject: 'STe101p' (cd958ea0): kobject_uevent_env
[   31.339943] kobject: 'STe101p' (cd958ea0): fill_kobj_path: path = '/bus/mdio_bus/drivers/STe101p'
[   31.339950] libphy: STe101p: Registered new driver
[   31.339952] bus: 'mdio_bus': add driver STe100p
[   31.339953] kobject: 'STe100p' (cd958f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.339956] kobject: 'STe100p' (cd958f00): kobject_uevent_env
[   31.339958] kobject: 'STe100p' (cd958f00): fill_kobj_path: path = '/bus/mdio_bus/drivers/STe100p'
[   31.339959] libphy: STe100p: Registered new driver
[   31.339960] tun: Universal TUN/TAP device driver, 1.6
[   31.339961] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   31.339978] device: 'tun': device_add
[   31.339984] kobject: 'tun' (cf910208): kobject_add_internal: parent: 'misc', set: 'devices'
[   31.340188] PM: Adding info for No Bus:tun
[   31.340189] kobject: 'tun' (cf910208): kobject_uevent_env
[   31.340194] kobject: 'tun' (cf910208): fill_kobj_path: path = '/devices/virtual/misc/tun'
[   31.340202] arcnet loaded.
[   31.340203] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[   31.340203] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[   31.340204] arcnet: raw mode (`r') encapsulation support loaded.
[   31.340204] arcnet: cap mode (`c') encapsulation support loaded.
[   31.340243] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   31.340243] E-mail me if you actually test this driver, please!
[   31.340246]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   31.340258] arcnet: RIM I (entirely mem-mapped) support
[   31.340259] E-mail me if you actually test the RIM I driver, please!
[   31.340259] Given: node 00h, shmem 0h, irq 0
[   31.340260] No autoprobe for RIM I; you must specify the shmem and irq!
[   31.340274] bus: 'pci': add driver atl1
[   31.340280] kobject: 'atl1' (cf8fd000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.340787] kobject: 'atl1' (cf8fd000): kobject_uevent_env
[   31.340805] kobject: 'atl1' (cf8fd000): fill_kobj_path: path = '/bus/pci/drivers/atl1'
[   31.340882] bus: 'pci': add driver bnx2
[   31.340886] kobject: 'bnx2' (cf8fd060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.340908] kobject: 'bnx2' (cf8fd060): kobject_uevent_env
[   31.340910] kobject: 'bnx2' (cf8fd060): fill_kobj_path: path = '/bus/pci/drivers/bnx2'
[   31.340914] bus: 'pci': add driver S2IO
[   31.340915] kobject: 'S2IO' (cf8fd0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.340919] kobject: 'S2IO' (cf8fd0c0): kobject_uevent_env
[   31.340921] kobject: 'S2IO' (cf8fd0c0): fill_kobj_path: path = '/bus/pci/drivers/S2IO'
[   31.340925] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   31.340927] bus: 'pci': add driver ns83820
[   31.340928] kobject: 'ns83820' (cf8fd120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.340941] kobject: 'ns83820' (cf8fd120): kobject_uevent_env
[   31.340943] kobject: 'ns83820' (cf8fd120): fill_kobj_path: path = '/bus/pci/drivers/ns83820'
[   31.340948] bus: 'pci': add driver skfddi
[   31.340950] kobject: 'skfddi' (cf8fd180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.340954] kobject: 'skfddi' (cf8fd180): kobject_uevent_env
[   31.340955] kobject: 'skfddi' (cf8fd180): fill_kobj_path: path = '/bus/pci/drivers/skfddi'
[   31.340960] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   31.340991] bus: 'platform': add driver nsc-ircc
[   31.340993] kobject: 'nsc-ircc' (cf8fd1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.341042] kobject: 'nsc-ircc' (cf8fd1e0): kobject_uevent_env
[   31.341043] kobject: 'nsc-ircc' (cf8fd1e0): fill_kobj_path: path = '/bus/platform/drivers/nsc-ircc'
[   31.341056] bus: 'pnp': add driver nsc-ircc
[   31.341057] kobject: 'nsc-ircc' (cf8fd240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.341072] kobject: 'nsc-ircc' (cf8fd240): kobject_uevent_env
[   31.341074] kobject: 'nsc-ircc' (cf8fd240): fill_kobj_path: path = '/bus/pnp/drivers/nsc-ircc'
[   31.341463] bus: 'platform': remove driver nsc-ircc
[   31.341464] kobject: 'nsc-ircc' (cf8fd1e0): kobject_cleanup
[   31.341465] kobject: 'nsc-ircc' (cf8fd1e0): auto cleanup 'remove' event
[   31.341466] kobject: 'nsc-ircc' (cf8fd1e0): kobject_uevent_env
[   31.341468] kobject: 'nsc-ircc' (cf8fd1e0): fill_kobj_path: path = '/bus/platform/drivers/nsc-ircc'
[   31.341470] kobject: 'nsc-ircc' (cf8fd1e0): auto cleanup kobject_del
[   31.341474] sysfs nsc-ircc: removing dir
[   31.341475] kobject: 'nsc-ircc' (cf8fd1e0): calling ktype release
[   31.341478] driver: 'nsc-ircc': driver_release
[   31.341479] kobject: 'nsc-ircc': free name
[   31.341481] bus: 'pnp': remove driver nsc-ircc
[   31.341482] kobject: 'nsc-ircc' (cf8fd240): kobject_cleanup
[   31.341483] kobject: 'nsc-ircc' (cf8fd240): auto cleanup 'remove' event
[   31.341483] kobject: 'nsc-ircc' (cf8fd240): kobject_uevent_env
[   31.341485] kobject: 'nsc-ircc' (cf8fd240): fill_kobj_path: path = '/bus/pnp/drivers/nsc-ircc'
[   31.341487] kobject: 'nsc-ircc' (cf8fd240): auto cleanup kobject_del
[   31.341487] sysfs nsc-ircc: removing dir
[   31.341488] kobject: 'nsc-ircc' (cf8fd240): calling ktype release
[   31.341489] driver: 'nsc-ircc': driver_release
[   31.341490] kobject: 'nsc-ircc': free name
[   31.342436] bus: 'pci': add driver donauboe
[   31.342460] kobject: 'donauboe' (cf8fd240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342511] kobject: 'donauboe' (cf8fd240): kobject_uevent_env
[   31.342517] kobject: 'donauboe' (cf8fd240): fill_kobj_path: path = '/bus/pci/drivers/donauboe'
[   31.342542] bus: 'pci': add driver via-ircc
[   31.342543] kobject: 'via-ircc' (cf8fd1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342550] kobject: 'via-ircc' (cf8fd1e0): kobject_uevent_env
[   31.342552] kobject: 'via-ircc' (cf8fd1e0): fill_kobj_path: path = '/bus/pci/drivers/via-ircc'
[   31.342556] PPP generic driver version 2.4.2
[   31.342594] device class 'ppp': registering
[   31.342603] kobject: 'ppp' (cc351c0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.342617] kobject: 'ppp' (cc351c0c): kobject_uevent_env
[   31.342618] kobject: 'ppp' (cc351c0c): fill_kobj_path: path = '/class/ppp'
[   31.342651] device: 'ppp': device_add
[   31.342655] kobject: 'ppp' (cf8fe400): kobject_add_internal: parent: 'virtual', set: '(null)'
[   31.342661] kobject: 'ppp' (cf910408): kobject_add_internal: parent: 'ppp', set: 'devices'
[   31.342715] PM: Adding info for No Bus:ppp
[   31.342716] kobject: 'ppp' (cf910408): kobject_uevent_env
[   31.342718] kobject: 'ppp' (cf910408): fill_kobj_path: path = '/devices/virtual/ppp/ppp'
[   31.342733] PPP BSD Compression module registered
[   31.342734] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[   31.342749] bus: 'usb': add driver kaweth
[   31.342751] kobject: 'kaweth' (cf8fd360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342754] kobject: 'kaweth' (cf8fd360): kobject_uevent_env
[   31.342756] kobject: 'kaweth' (cf8fd360): fill_kobj_path: path = '/bus/usb/drivers/kaweth'
[   31.342762] usbcore: registered new interface driver kaweth
[   31.342763] bus: 'usb': add driver asix
[   31.342765] kobject: 'asix' (cf8fd3c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342767] kobject: 'asix' (cf8fd3c0): kobject_uevent_env
[   31.342769] kobject: 'asix' (cf8fd3c0): fill_kobj_path: path = '/bus/usb/drivers/asix'
[   31.342771] usbcore: registered new interface driver asix
[   31.342772] bus: 'usb': add driver cdc_ether
[   31.342774] kobject: 'cdc_ether' (cf8fd420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342777] kobject: 'cdc_ether' (cf8fd420): kobject_uevent_env
[   31.342779] kobject: 'cdc_ether' (cf8fd420): fill_kobj_path: path = '/bus/usb/drivers/cdc_ether'
[   31.342781] usbcore: registered new interface driver cdc_ether
[   31.342784] bus: 'usb': add driver dm9601
[   31.342786] kobject: 'dm9601' (cf8fd480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342788] kobject: 'dm9601' (cf8fd480): kobject_uevent_env
[   31.342790] kobject: 'dm9601' (cf8fd480): fill_kobj_path: path = '/bus/usb/drivers/dm9601'
[   31.342793] usbcore: registered new interface driver dm9601
[   31.342794] bus: 'usb': add driver smsc75xx
[   31.342795] kobject: 'smsc75xx' (cf8fd4e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342798] kobject: 'smsc75xx' (cf8fd4e0): kobject_uevent_env
[   31.342800] kobject: 'smsc75xx' (cf8fd4e0): fill_kobj_path: path = '/bus/usb/drivers/smsc75xx'
[   31.342802] usbcore: registered new interface driver smsc75xx
[   31.342803] bus: 'usb': add driver smsc95xx
[   31.342804] kobject: 'smsc95xx' (cf8fd540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342807] kobject: 'smsc95xx' (cf8fd540): kobject_uevent_env
[   31.342809] kobject: 'smsc95xx' (cf8fd540): fill_kobj_path: path = '/bus/usb/drivers/smsc95xx'
[   31.342837] usbcore: registered new interface driver smsc95xx
[   31.342838] bus: 'usb': add driver gl620a
[   31.342840] kobject: 'gl620a' (cf8fd5a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342842] kobject: 'gl620a' (cf8fd5a0): kobject_uevent_env
[   31.342849] kobject: 'gl620a' (cf8fd5a0): fill_kobj_path: path = '/bus/usb/drivers/gl620a'
[   31.342851] usbcore: registered new interface driver gl620a
[   31.342852] bus: 'usb': add driver net1080
[   31.342854] kobject: 'net1080' (cf8fd600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342856] kobject: 'net1080' (cf8fd600): kobject_uevent_env
[   31.342858] kobject: 'net1080' (cf8fd600): fill_kobj_path: path = '/bus/usb/drivers/net1080'
[   31.342860] usbcore: registered new interface driver net1080
[   31.342861] bus: 'usb': add driver cdc_subset
[   31.342863] kobject: 'cdc_subset' (cf8fd660): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342866] kobject: 'cdc_subset' (cf8fd660): kobject_uevent_env
[   31.342868] kobject: 'cdc_subset' (cf8fd660): fill_kobj_path: path = '/bus/usb/drivers/cdc_subset'
[   31.342870] usbcore: registered new interface driver cdc_subset
[   31.342871] bus: 'usb': add driver zaurus
[   31.342872] kobject: 'zaurus' (cf8fd6c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.342875] kobject: 'zaurus' (cf8fd6c0): kobject_uevent_env
[   31.342877] kobject: 'zaurus' (cf8fd6c0): fill_kobj_path: path = '/bus/usb/drivers/zaurus'
[   31.342879] usbcore: registered new interface driver zaurus
[   31.343288] bus: 'usb': add driver int51x1
[   31.343317] kobject: 'int51x1' (cf8fd720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343372] kobject: 'int51x1' (cf8fd720): kobject_uevent_env
[   31.343382] kobject: 'int51x1' (cf8fd720): fill_kobj_path: path = '/bus/usb/drivers/int51x1'
[   31.343409] usbcore: registered new interface driver int51x1
[   31.343410] bus: 'usb': add driver kalmia
[   31.343412] kobject: 'kalmia' (cf8fd780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343414] kobject: 'kalmia' (cf8fd780): kobject_uevent_env
[   31.343416] kobject: 'kalmia' (cf8fd780): fill_kobj_path: path = '/bus/usb/drivers/kalmia'
[   31.343418] usbcore: registered new interface driver kalmia
[   31.343420] bus: 'usb': add driver cdc_ncm
[   31.343421] kobject: 'cdc_ncm' (cf8fd7e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343424] kobject: 'cdc_ncm' (cf8fd7e0): kobject_uevent_env
[   31.343426] kobject: 'cdc_ncm' (cf8fd7e0): fill_kobj_path: path = '/bus/usb/drivers/cdc_ncm'
[   31.343428] usbcore: registered new interface driver cdc_ncm
[   31.343429] bus: 'usb': add driver lg-vl600
[   31.343430] kobject: 'lg-vl600' (cf8fd840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343433] kobject: 'lg-vl600' (cf8fd840): kobject_uevent_env
[   31.343435] kobject: 'lg-vl600' (cf8fd840): fill_kobj_path: path = '/bus/usb/drivers/lg-vl600'
[   31.343437] usbcore: registered new interface driver lg-vl600
[   31.343461] bus: 'pci': add driver nosy
[   31.343463] kobject: 'nosy' (cf8fd8a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343486] kobject: 'nosy' (cf8fd8a0): kobject_uevent_env
[   31.343488] kobject: 'nosy' (cf8fd8a0): fill_kobj_path: path = '/bus/pci/drivers/nosy'
[   31.343506] device class 'uio': registering
[   31.343523] kobject: 'uio' (cc351d0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.343530] kobject: 'uio' (cc351d0c): kobject_uevent_env
[   31.343532] kobject: 'uio' (cc351d0c): fill_kobj_path: path = '/class/uio'
[   31.343534] bus: 'pci': add driver hilscher
[   31.343536] kobject: 'hilscher' (cf8fd960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343544] kobject: 'hilscher' (cf8fd960): kobject_uevent_env
[   31.343546] kobject: 'hilscher' (cf8fd960): fill_kobj_path: path = '/bus/pci/drivers/hilscher'
[   31.343566] bus: 'platform': add driver uio_pdrv_genirq
[   31.343567] kobject: 'uio_pdrv_genirq' (cf8fd9c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343612] kobject: 'uio_pdrv_genirq' (cf8fd9c0): kobject_uevent_env
[   31.343614] kobject: 'uio_pdrv_genirq' (cf8fd9c0): fill_kobj_path: path = '/bus/platform/drivers/uio_pdrv_genirq'
[   31.343620] bus: 'pci': add driver aectc
[   31.343622] kobject: 'aectc' (cf8fda20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343628] kobject: 'aectc' (cf8fda20): kobject_uevent_env
[   31.343630] kobject: 'aectc' (cf8fda20): fill_kobj_path: path = '/bus/pci/drivers/aectc'
[   31.343633] bus: 'pci': add driver sercos3
[   31.343635] kobject: 'sercos3' (cf8fda80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343641] kobject: 'sercos3' (cf8fda80): kobject_uevent_env
[   31.343643] kobject: 'sercos3' (cf8fda80): fill_kobj_path: path = '/bus/pci/drivers/sercos3'
[   31.343647] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[   31.343648] bus: 'pci': add driver uio_pci_generic
[   31.343650] kobject: 'uio_pci_generic' (cf8fdae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343654] kobject: 'uio_pci_generic' (cf8fdae0): kobject_uevent_env
[   31.343656] kobject: 'uio_pci_generic' (cf8fdae0): fill_kobj_path: path = '/bus/pci/drivers/uio_pci_generic'
[   31.343659] bus: 'pci': add driver netx
[   31.343660] kobject: 'netx' (cf8fdb40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343664] kobject: 'netx' (cf8fdb40): kobject_uevent_env
[   31.343666] kobject: 'netx' (cf8fdb40): fill_kobj_path: path = '/bus/pci/drivers/netx'
[   31.343674] bus: 'pci': add driver pd6729
[   31.343676] kobject: 'pd6729' (cf8fdba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343682] kobject: 'pd6729' (cf8fdba0): kobject_uevent_env
[   31.343684] kobject: 'pd6729' (cf8fdba0): fill_kobj_path: path = '/bus/pci/drivers/pd6729'
[   31.343693] bus: 'platform': add driver gpio-vbus
[   31.343694] kobject: 'gpio-vbus' (cf8fdc00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343699] kobject: 'gpio-vbus' (cf8fdc00): kobject_uevent_env
[   31.343701] kobject: 'gpio-vbus' (cf8fdc00): fill_kobj_path: path = '/bus/platform/drivers/gpio-vbus'
[   31.343712] bus: 'platform': remove driver gpio-vbus
[   31.343713] kobject: 'gpio-vbus' (cf8fdc00): kobject_cleanup
[   31.343714] kobject: 'gpio-vbus' (cf8fdc00): auto cleanup 'remove' event
[   31.343715] kobject: 'gpio-vbus' (cf8fdc00): kobject_uevent_env
[   31.343717] kobject: 'gpio-vbus' (cf8fdc00): fill_kobj_path: path = '/bus/platform/drivers/gpio-vbus'
[   31.343718] kobject: 'gpio-vbus' (cf8fdc00): auto cleanup kobject_del
[   31.343722] sysfs gpio-vbus: removing dir
[   31.343724] kobject: 'gpio-vbus' (cf8fdc00): calling ktype release
[   31.343726] driver: 'gpio-vbus': driver_release
[   31.343727] kobject: 'gpio-vbus': free name
[   31.343734] debugfs: creating file 'usbmon'
[   31.343787] device class 'usbmon': registering
[   31.343789] kobject: 'usbmon' (cc351e0c): kobject_add_internal: parent: 'class', set: 'class'
[   31.343796] kobject: 'usbmon' (cc351e0c): kobject_uevent_env
[   31.343798] kobject: 'usbmon' (cc351e0c): fill_kobj_path: path = '/class/usbmon'
[   31.343803] debugfs: creating file '0u'
[   31.343808] debugfs: creating file '0s'
[   31.343841] device: 'usbmon0': device_add
[   31.343846] kobject: 'usbmon' (cf908900): kobject_add_internal: parent: 'virtual', set: '(null)'
[   31.343854] kobject: 'usbmon0' (cf910608): kobject_add_internal: parent: 'usbmon', set: 'devices'
[   31.343898] PM: Adding info for No Bus:usbmon0
[   31.343899] kobject: 'usbmon0' (cf910608): kobject_uevent_env
[   31.343901] kobject: 'usbmon0' (cf910608): fill_kobj_path: path = '/devices/virtual/usbmon/usbmon0'
[   31.343914] uhci_hcd: USB Universal Host Controller Interface driver
[   31.343966] bus: 'pci': add driver uhci_hcd
[   31.343968] kobject: 'uhci_hcd' (cf8fdcc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343972] kobject: 'uhci_hcd' (cf8fdcc0): kobject_uevent_env
[   31.343974] kobject: 'uhci_hcd' (cf8fdcc0): fill_kobj_path: path = '/bus/pci/drivers/uhci_hcd'
[   31.343978] bus: 'platform': add driver sl811-hcd
[   31.343979] kobject: 'sl811-hcd' (cf8fdd20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.343988] kobject: 'sl811-hcd' (cf8fdd20): kobject_uevent_env
[   31.343990] kobject: 'sl811-hcd' (cf8fdd20): fill_kobj_path: path = '/bus/platform/drivers/sl811-hcd'
[   31.344004] bus: 'usb': add driver cdc_acm
[   31.344005] kobject: 'cdc_acm' (cf8fdde0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344013] kobject: 'cdc_acm' (cf8fdde0): kobject_uevent_env
[   31.344015] kobject: 'cdc_acm' (cf8fdde0): fill_kobj_path: path = '/bus/usb/drivers/cdc_acm'
[   31.344017] usbcore: registered new interface driver cdc_acm
[   31.344018] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   31.344019] bus: 'usb': add driver usblp
[   31.344021] kobject: 'usblp' (cf8fde40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344023] kobject: 'usblp' (cf8fde40): kobject_uevent_env
[   31.344025] kobject: 'usblp' (cf8fde40): fill_kobj_path: path = '/bus/usb/drivers/usblp'
[   31.344027] usbcore: registered new interface driver usblp
[   31.344029] bus: 'usb': add driver usbtmc
[   31.344030] kobject: 'usbtmc' (cf8fdea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344033] kobject: 'usbtmc' (cf8fdea0): kobject_uevent_env
[   31.344035] kobject: 'usbtmc' (cf8fdea0): fill_kobj_path: path = '/bus/usb/drivers/usbtmc'
[   31.344037] usbcore: registered new interface driver usbtmc
[   31.344038] bus: 'usb': add driver adutux
[   31.344039] kobject: 'adutux' (cf8fdf00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344042] kobject: 'adutux' (cf8fdf00): kobject_uevent_env
[   31.344044] kobject: 'adutux' (cf8fdf00): fill_kobj_path: path = '/bus/usb/drivers/adutux'
[   31.344046] usbcore: registered new interface driver adutux
[   31.344047] bus: 'usb': add driver cytherm
[   31.344048] kobject: 'cytherm' (cf8fdf60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344051] kobject: 'cytherm' (cf8fdf60): kobject_uevent_env
[   31.344053] kobject: 'cytherm' (cf8fdf60): fill_kobj_path: path = '/bus/usb/drivers/cytherm'
[   31.344055] usbcore: registered new interface driver cytherm
[   31.344056] bus: 'usb': add driver emi26 - firmware loader
[   31.344060] kobject: 'emi26 - firmware loader' (cf90a000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344064] kobject: 'emi26 - firmware loader' (cf90a000): kobject_uevent_env
[   31.344066] kobject: 'emi26 - firmware loader' (cf90a000): fill_kobj_path: path = '/bus/usb/drivers/emi26 - firmware loader'
[   31.344068] usbcore: registered new interface driver emi26 - firmware loader
[   31.344069] bus: 'usb': add driver emi62 - firmware loader
[   31.344071] kobject: 'emi62 - firmware loader' (cf90a060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344074] kobject: 'emi62 - firmware loader' (cf90a060): kobject_uevent_env
[   31.344076] kobject: 'emi62 - firmware loader' (cf90a060): fill_kobj_path: path = '/bus/usb/drivers/emi62 - firmware loader'
[   31.344078] usbcore: registered new interface driver emi62 - firmware loader
[   31.344079] bus: 'usb': add driver isight_firmware
[   31.344080] kobject: 'isight_firmware' (cf90a0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344083] kobject: 'isight_firmware' (cf90a0c0): kobject_uevent_env
[   31.344085] kobject: 'isight_firmware' (cf90a0c0): fill_kobj_path: path = '/bus/usb/drivers/isight_firmware'
[   31.344087] usbcore: registered new interface driver isight_firmware
[   31.344088] bus: 'usb': add driver usblcd
[   31.344090] kobject: 'usblcd' (cf90a120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344093] kobject: 'usblcd' (cf90a120): kobject_uevent_env
[   31.344094] kobject: 'usblcd' (cf90a120): fill_kobj_path: path = '/bus/usb/drivers/usblcd'
[   31.344096] usbcore: registered new interface driver usblcd
[   31.344097] bus: 'usb': add driver ldusb
[   31.344099] kobject: 'ldusb' (cf90a180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344378] kobject: 'ldusb' (cf90a180): kobject_uevent_env
[   31.344575] kobject: 'ldusb' (cf90a180): fill_kobj_path: path = '/bus/usb/drivers/ldusb'
[   31.344643] usbcore: registered new interface driver ldusb
[   31.344675] bus: 'usb': add driver usbled
[   31.344682] kobject: 'usbled' (cf90a1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344696] kobject: 'usbled' (cf90a1e0): kobject_uevent_env
[   31.344698] kobject: 'usbled' (cf90a1e0): fill_kobj_path: path = '/bus/usb/drivers/usbled'
[   31.344700] usbcore: registered new interface driver usbled
[   31.344701] bus: 'usb': add driver rio500
[   31.344703] kobject: 'rio500' (cf90a240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344732] kobject: 'rio500' (cf90a240): kobject_uevent_env
[   31.344734] kobject: 'rio500' (cf90a240): fill_kobj_path: path = '/bus/usb/drivers/rio500'
[   31.344736] usbcore: registered new interface driver rio500
[   31.344740] bus: 'usb': add driver usbtest
[   31.344741] kobject: 'usbtest' (cf90a2a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344744] kobject: 'usbtest' (cf90a2a0): kobject_uevent_env
[   31.344746] kobject: 'usbtest' (cf90a2a0): fill_kobj_path: path = '/bus/usb/drivers/usbtest'
[   31.344748] usbcore: registered new interface driver usbtest
[   31.344749] bus: 'usb': add driver usbsevseg
[   31.344751] kobject: 'usbsevseg' (cf90a300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344753] kobject: 'usbsevseg' (cf90a300): kobject_uevent_env
[   31.344755] kobject: 'usbsevseg' (cf90a300): fill_kobj_path: path = '/bus/usb/drivers/usbsevseg'
[   31.344757] usbcore: registered new interface driver usbsevseg
[   31.344759] bus: 'usb': add driver yurex
[   31.344760] kobject: 'yurex' (cf90a360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344763] kobject: 'yurex' (cf90a360): kobject_uevent_env
[   31.344764] kobject: 'yurex' (cf90a360): fill_kobj_path: path = '/bus/usb/drivers/yurex'
[   31.344767] usbcore: registered new interface driver yurex
[   31.344793] bus: 'pci': add driver net2280
[   31.344795] kobject: 'net2280' (cf90a3c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344817] kobject: 'net2280' (cf90a3c0): kobject_uevent_env
[   31.344819] kobject: 'net2280' (cf90a3c0): fill_kobj_path: path = '/bus/pci/drivers/net2280'
[   31.344831] couldn't find an available UDC
[   31.344853] bus: 'pnp': add driver i8042 kbd
[   31.344855] kobject: 'i8042 kbd' (cf90a420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344869] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[   31.344877] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[   31.344891] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[   31.344892] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[   31.344905] kobject: 'i8042 kbd' (cf90a420): kobject_uevent_env
[   31.344907] kobject: 'i8042 kbd' (cf90a420): fill_kobj_path: path = '/bus/pnp/drivers/i8042 kbd'
[   31.344909] bus: 'pnp': add driver i8042 aux
[   31.344910] kobject: 'i8042 aux' (cf90a480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.344914] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[   31.344916] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[   31.344921] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[   31.344922] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[   31.344927] kobject: 'i8042 aux' (cf90a480): kobject_uevent_env
[   31.344929] kobject: 'i8042 aux' (cf90a480): fill_kobj_path: path = '/bus/pnp/drivers/i8042 aux'
[   31.344944] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   31.345014] Registering platform device 'i8042'. Parent at platform
[   31.345017] device: 'i8042': device_add
[   31.345018] kobject: 'i8042' (cf910810): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.345037] bus: 'platform': add device i8042
[   31.345059] PM: Adding info for platform:i8042
[   31.345061] kobject: 'i8042' (cf910810): kobject_uevent_env
[   31.345063] kobject: 'i8042' (cf910810): fill_kobj_path: path = '/devices/platform/i8042'
[   31.345124] bus: 'platform': add driver i8042
[   31.345126] kobject: 'i8042' (cf90a540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.345139] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   31.345140] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   31.350608] serio: i8042 KBD port at 0x60,0x64 irq 1
[   31.350680] device: 'serio0': device_add
[   31.350688] kobject: 'serio0' (cf910c98): kobject_add_internal: parent: 'i8042', set: 'devices'
[   31.350730] bus: 'serio': add device serio0
[   31.351256] PM: Adding info for serio:serio0
[   31.351266] kobject: 'serio0' (cf910c98): kobject_uevent_env
[   31.351283] kobject: 'serio0' (cf910c98): fill_kobj_path: path = '/devices/platform/i8042/serio0'
[   31.351377] serio: i8042 AUX port at 0x60,0x64 irq 12
[   31.351413] device: 'serio1': device_add
[   31.351414] kobject: 'serio1' (cf910a98): kobject_add_internal: parent: 'i8042', set: 'devices'
[   31.351435] bus: 'serio': add device serio1
[   31.351443] PM: Adding info for serio:serio1
[   31.351444] kobject: 'serio1' (cf910a98): kobject_uevent_env
[   31.351446] kobject: 'serio1' (cf910a98): fill_kobj_path: path = '/devices/platform/i8042/serio1'
[   31.351456] driver: 'i8042': driver_bound: bound to device 'i8042'
[   31.351460] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   31.351465] kobject: 'i8042' (cf90a540): kobject_uevent_env
[   31.351467] kobject: 'i8042' (cf90a540): fill_kobj_path: path = '/bus/platform/drivers/i8042'
[   31.351507] bus: 'pci': add driver pcips2
[   31.351509] kobject: 'pcips2' (cf90a720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.351532] kobject: 'pcips2' (cf90a720): kobject_uevent_env
[   31.351534] kobject: 'pcips2' (cf90a720): fill_kobj_path: path = '/bus/pci/drivers/pcips2'
[   31.351537] bus: 'serio': add driver ps2mult
[   31.351541] kobject: 'ps2mult' (cf90a780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.351545] kobject: 'ps2mult' (cf90a780): kobject_uevent_env
[   31.351547] kobject: 'ps2mult' (cf90a780): fill_kobj_path: path = '/bus/serio/drivers/ps2mult'
[   31.351552] bus: 'serio': add driver serio_raw
[   31.351554] kobject: 'serio_raw' (cf90a7e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.351558] kobject: 'serio_raw' (cf90a7e0): kobject_uevent_env
[   31.351560] kobject: 'serio_raw' (cf90a7e0): fill_kobj_path: path = '/bus/serio/drivers/serio_raw'
[   31.351562] bus: 'pci': add driver FM801_gameport
[   31.351564] kobject: 'FM801_gameport' (cf90a840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.351571] kobject: 'FM801_gameport' (cf90a840): kobject_uevent_env
[   31.351573] kobject: 'FM801_gameport' (cf90a840): fill_kobj_path: path = '/bus/pci/drivers/FM801_gameport'
[   31.351581] device: 'mice': device_add
[   31.351587] kobject: 'input' (cf90ce00): kobject_add_internal: parent: 'virtual', set: '(null)'
[   31.351597] kobject: 'mice' (cf910e60): kobject_add_internal: parent: 'input', set: 'devices'
[   31.351636] PM: Adding info for No Bus:mice
[   31.351637] kobject: 'mice' (cf910e60): kobject_uevent_env
[   31.351639] kobject: 'mice' (cf910e60): fill_kobj_path: path = '/devices/virtual/input/mice'
[   31.351668] device: 'psaux': device_add
[   31.351671] kobject: 'psaux' (cf911008): kobject_add_internal: parent: 'misc', set: 'devices'
[   31.351687] PM: Adding info for No Bus:psaux
[   31.351688] kobject: 'psaux' (cf911008): kobject_uevent_env
[   31.351690] kobject: 'psaux' (cf911008): fill_kobj_path: path = '/devices/virtual/misc/psaux'
[   31.351692] mousedev: PS/2 mouse device common for all mice
[   31.351699] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[   31.351715] bus: 'serio': add driver atkbd
[   31.351717] kobject: 'atkbd' (cf90a960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.351722] kobject: 'atkbd' (cf90a960): kobject_uevent_env
[   31.351723] kobject: 'atkbd' (cf90a960): fill_kobj_path: path = '/bus/serio/drivers/atkbd'
[   31.351728] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   31.351729] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   31.351844] atkbd serio0: Received fa flags 00
[   31.352460] atkbd serio0: Received ab flags 00
[   31.352559] atkbd serio0: Received 41 flags 00
[   31.352602] atkbd serio0: Received fa flags 00
[   31.352631] atkbd serio0: Received fa flags 00
[   31.352659] atkbd serio0: Received fa flags 00
[   31.352688] atkbd serio0: Received fa flags 00
[   31.352717] atkbd serio0: Received fa flags 00
[   31.352787] device: 'input1': device_add
[   31.352802] kobject: 'input' (cf90d880): kobject_add_internal: parent: 'serio0', set: '(null)'
[   31.352814] kobject: 'input1' (cd9465a8): kobject_add_internal: parent: 'input', set: 'devices'
[   31.352912] PM: Adding info for No Bus:input1
[   31.352915] kobject: 'input1' (cd9465a8): kobject_uevent_env
[   31.352922] kobject: 'input1' (cd9465a8): fill_kobj_path: path = '/devices/platform/i8042/serio0/input/input1'
[   31.352981] kobject: 'input1' (cd9465a8): fill_kobj_path: path = '/devices/platform/i8042/serio0/input/input1'
[   31.352982] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   31.353029] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[   31.353039] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   31.353040] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   31.353048] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   31.353052] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   31.353147] atkbd serio1: Received fa flags 00
[   31.353174] atkbd serio1: Received 00 flags 00
[   31.353817] kobject: '(null)' (cd9469a8): kobject_cleanup
[   31.353824] kobject: '(null)' (cd9469a8): calling ktype release
[   31.353898] atkbd: probe of serio1 rejects match -19
[   31.354060] bus: 'platform': add driver gpio-keys-polled
[   31.354073] kobject: 'gpio-keys-polled' (cf90aa20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354117] kobject: 'gpio-keys-polled' (cf90aa20): kobject_uevent_env
[   31.354122] kobject: 'gpio-keys-polled' (cf90aa20): fill_kobj_path: path = '/bus/platform/drivers/gpio-keys-polled'
[   31.354151] bus: 'serio': add driver lkkbd
[   31.354156] kobject: 'lkkbd' (cf90aa80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354166] kobject: 'lkkbd' (cf90aa80): kobject_uevent_env
[   31.354169] kobject: 'lkkbd' (cf90aa80): fill_kobj_path: path = '/bus/serio/drivers/lkkbd'
[   31.354207] bus: 'i2c': add driver mcs_touchkey
[   31.354210] kobject: 'mcs_touchkey' (cf90aae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354226] kobject: 'mcs_touchkey' (cf90aae0): kobject_uevent_env
[   31.354228] kobject: 'mcs_touchkey' (cf90aae0): fill_kobj_path: path = '/bus/i2c/drivers/mcs_touchkey'
[   31.354236] i2c-core: driver [mcs_touchkey] registered
[   31.354238] bus: 'i2c': add driver mpr121
[   31.354240] kobject: 'mpr121' (cf90ab40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354244] kobject: 'mpr121' (cf90ab40): kobject_uevent_env
[   31.354246] kobject: 'mpr121' (cf90ab40): fill_kobj_path: path = '/bus/i2c/drivers/mpr121'
[   31.354248] i2c-core: driver [mpr121] registered
[   31.354258] bus: 'serio': add driver newtonkbd
[   31.354260] kobject: 'newtonkbd' (cf90aba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354265] kobject: 'newtonkbd' (cf90aba0): kobject_uevent_env
[   31.354267] kobject: 'newtonkbd' (cf90aba0): fill_kobj_path: path = '/bus/serio/drivers/newtonkbd'
[   31.354275] bus: 'i2c': add driver qt1070
[   31.354277] kobject: 'qt1070' (cf90ac00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354281] kobject: 'qt1070' (cf90ac00): kobject_uevent_env
[   31.354283] kobject: 'qt1070' (cf90ac00): fill_kobj_path: path = '/bus/i2c/drivers/qt1070'
[   31.354285] i2c-core: driver [qt1070] registered
[   31.354286] bus: 'serio': add driver stowaway
[   31.354288] kobject: 'stowaway' (cf90ac60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354292] kobject: 'stowaway' (cf90ac60): kobject_uevent_env
[   31.354295] kobject: 'stowaway' (cf90ac60): fill_kobj_path: path = '/bus/serio/drivers/stowaway'
[   31.354301] bus: 'serio': add driver sunkbd
[   31.354302] kobject: 'sunkbd' (cf90acc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354307] kobject: 'sunkbd' (cf90acc0): kobject_uevent_env
[   31.354310] kobject: 'sunkbd' (cf90acc0): fill_kobj_path: path = '/bus/serio/drivers/sunkbd'
[   31.354332] bus: 'usb': add driver appletouch
[   31.354334] kobject: 'appletouch' (cf90ad20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354346] kobject: 'appletouch' (cf90ad20): kobject_uevent_env
[   31.354348] kobject: 'appletouch' (cf90ad20): fill_kobj_path: path = '/bus/usb/drivers/appletouch'
[   31.354358] usbcore: registered new interface driver appletouch
[   31.354360] bus: 'usb': add driver bcm5974
[   31.354362] kobject: 'bcm5974' (cf90ad80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354365] kobject: 'bcm5974' (cf90ad80): kobject_uevent_env
[   31.354368] kobject: 'bcm5974' (cf90ad80): fill_kobj_path: path = '/bus/usb/drivers/bcm5974'
[   31.354371] usbcore: registered new interface driver bcm5974
[   31.354373] bus: 'platform': add driver gpio_mouse
[   31.354375] kobject: 'gpio_mouse' (cf90ade0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.354387] kobject: 'gpio_mouse' (cf90ade0): kobject_uevent_env
[   31.354389] kobject: 'gpio_mouse' (cf90ade0): fill_kobj_path: path = '/bus/platform/drivers/gpio_mouse'
[   31.355102] bus: 'serio': add driver psmouse
[   31.355118] kobject: 'psmouse' (cf90aea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355169] kobject: 'psmouse' (cf90aea0): kobject_uevent_env
[   31.355178] kobject: 'psmouse' (cf90aea0): fill_kobj_path: path = '/bus/serio/drivers/psmouse'
[   31.355221] bus: 'serio': driver_probe_device: matched device serio1 with driver psmouse
[   31.355228] bus: 'serio': really_probe: probing driver psmouse with device serio1
[   31.355538] bus: 'i2c': add driver bu21013_tp
[   31.355540] kobject: 'bu21013_tp' (cf90af00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355555] kobject: 'bu21013_tp' (cf90af00): kobject_uevent_env
[   31.355557] kobject: 'bu21013_tp' (cf90af00): fill_kobj_path: path = '/bus/i2c/drivers/bu21013_tp'
[   31.355564] i2c-core: driver [bu21013_tp] registered
[   31.355565] bus: 'serio': add driver dynapro
[   31.355567] kobject: 'dynapro' (cf90af60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355572] kobject: 'dynapro' (cf90af60): kobject_uevent_env
[   31.355574] kobject: 'dynapro' (cf90af60): fill_kobj_path: path = '/bus/serio/drivers/dynapro'
[   31.355624] bus: 'serio': add driver gunze
[   31.355632] kobject: 'gunze' (cf915000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355638] kobject: 'gunze' (cf915000): kobject_uevent_env
[   31.355640] kobject: 'gunze' (cf915000): fill_kobj_path: path = '/bus/serio/drivers/gunze'
[   31.355646] bus: 'serio': add driver elo
[   31.355648] kobject: 'elo' (cf915060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355658] kobject: 'elo' (cf915060): kobject_uevent_env
[   31.355660] kobject: 'elo' (cf915060): fill_kobj_path: path = '/bus/serio/drivers/elo'
[   31.355663] bus: 'serio': add driver inexio
[   31.355665] kobject: 'inexio' (cf9150c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355674] kobject: 'inexio' (cf9150c0): kobject_uevent_env
[   31.355677] kobject: 'inexio' (cf9150c0): fill_kobj_path: path = '/bus/serio/drivers/inexio'
[   31.355681] bus: 'i2c': add driver max11801_ts
[   31.355683] kobject: 'max11801_ts' (cf915120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355695] kobject: 'max11801_ts' (cf915120): kobject_uevent_env
[   31.355697] kobject: 'max11801_ts' (cf915120): fill_kobj_path: path = '/bus/i2c/drivers/max11801_ts'
[   31.355699] i2c-core: driver [max11801_ts] registered
[   31.355701] bus: 'i2c': add driver mcs5000_ts
[   31.355703] kobject: 'mcs5000_ts' (cf915180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355707] kobject: 'mcs5000_ts' (cf915180): kobject_uevent_env
[   31.355709] kobject: 'mcs5000_ts' (cf915180): fill_kobj_path: path = '/bus/i2c/drivers/mcs5000_ts'
[   31.355711] i2c-core: driver [mcs5000_ts] registered
[   31.355840] mk712: device not present
[   31.355859] bus: 'usb': add driver usbtouchscreen
[   31.355862] kobject: 'usbtouchscreen' (cf9151e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355871] kobject: 'usbtouchscreen' (cf9151e0): kobject_uevent_env
[   31.355874] kobject: 'usbtouchscreen' (cf9151e0): fill_kobj_path: path = '/bus/usb/drivers/usbtouchscreen'
[   31.355884] usbcore: registered new interface driver usbtouchscreen
[   31.355886] bus: 'serio': add driver serio-penmount
[   31.355888] kobject: 'serio-penmount' (cf915240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355893] kobject: 'serio-penmount' (cf915240): kobject_uevent_env
[   31.355895] kobject: 'serio-penmount' (cf915240): fill_kobj_path: path = '/bus/serio/drivers/serio-penmount'
[   31.355899] bus: 'i2c': add driver st1232-ts
[   31.355901] kobject: 'st1232-ts' (cf9152a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355905] kobject: 'st1232-ts' (cf9152a0): kobject_uevent_env
[   31.355907] kobject: 'st1232-ts' (cf9152a0): fill_kobj_path: path = '/bus/i2c/drivers/st1232-ts'
[   31.355909] i2c-core: driver [st1232-ts] registered
[   31.355910] bus: 'serio': add driver touchit213
[   31.355912] kobject: 'touchit213' (cf915300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355922] kobject: 'touchit213' (cf915300): kobject_uevent_env
[   31.355925] kobject: 'touchit213' (cf915300): fill_kobj_path: path = '/bus/serio/drivers/touchit213'
[   31.355937] bus: 'serio': add driver touchright
[   31.355939] kobject: 'touchright' (cf915360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355944] kobject: 'touchright' (cf915360): kobject_uevent_env
[   31.355946] kobject: 'touchright' (cf915360): fill_kobj_path: path = '/bus/serio/drivers/touchright'
[   31.355948] bus: 'serio': add driver touchwin
[   31.355950] kobject: 'touchwin' (cf9153c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355954] kobject: 'touchwin' (cf9153c0): kobject_uevent_env
[   31.355956] kobject: 'touchwin' (cf9153c0): fill_kobj_path: path = '/bus/serio/drivers/touchwin'
[   31.355959] bus: 'serio': add driver w8001
[   31.355961] kobject: 'w8001' (cf915420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.355966] kobject: 'w8001' (cf915420): kobject_uevent_env
[   31.355967] kobject: 'w8001' (cf915420): fill_kobj_path: path = '/bus/serio/drivers/w8001'
[   31.355991] bus: 'platform': add driver wm831x-touch
[   31.355993] kobject: 'wm831x-touch' (cf915480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.356847] kobject: 'wm831x-touch' (cf915480): kobject_uevent_env
[   31.356875] kobject: 'wm831x-touch' (cf915480): fill_kobj_path: path = '/bus/platform/drivers/wm831x-touch'
[   31.356976] bus: 'platform': add driver tps6507x-ts
[   31.356982] kobject: 'tps6507x-ts' (cf9154e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357003] kobject: 'tps6507x-ts' (cf9154e0): kobject_uevent_env
[   31.357005] kobject: 'tps6507x-ts' (cf9154e0): fill_kobj_path: path = '/bus/platform/drivers/tps6507x-ts'
[   31.357429] bus: 'i2c': add driver adxl34x
[   31.357469] kobject: 'adxl34x' (cf915540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357536] kobject: 'adxl34x' (cf915540): kobject_uevent_env
[   31.357545] kobject: 'adxl34x' (cf915540): fill_kobj_path: path = '/bus/i2c/drivers/adxl34x'
[   31.357580] i2c-core: driver [adxl34x] registered
[   31.357651] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   31.357678] bus: 'usb': add driver ati_remote2
[   31.357681] kobject: 'ati_remote2' (cf9155a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357691] kobject: 'ati_remote2' (cf9155a0): kobject_uevent_env
[   31.357693] kobject: 'ati_remote2' (cf9155a0): fill_kobj_path: path = '/bus/usb/drivers/ati_remote2'
[   31.357702] usbcore: registered new interface driver ati_remote2
[   31.357713] bus: 'i2c': add driver kxtj9
[   31.357715] kobject: 'kxtj9' (cf915600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357729] kobject: 'kxtj9' (cf915600): kobject_uevent_env
[   31.357732] kobject: 'kxtj9' (cf915600): fill_kobj_path: path = '/bus/i2c/drivers/kxtj9'
[   31.357733] i2c-core: driver [kxtj9] registered
[   31.357763] bus: 'platform': add driver max8925-onkey
[   31.357769] kobject: 'max8925-onkey' (cf915660): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357794] kobject: 'max8925-onkey' (cf915660): kobject_uevent_env
[   31.357796] kobject: 'max8925-onkey' (cf915660): fill_kobj_path: path = '/bus/platform/drivers/max8925-onkey'
[   31.357801] bus: 'i2c': add driver mpu3050
[   31.357802] kobject: 'mpu3050' (cf9156c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357806] kobject: 'mpu3050' (cf9156c0): kobject_uevent_env
[   31.357807] kobject: 'mpu3050' (cf9156c0): fill_kobj_path: path = '/bus/i2c/drivers/mpu3050'
[   31.357809] i2c-core: driver [mpu3050] registered
[   31.357810] bus: 'platform': add driver pcf50633-input
[   31.357812] kobject: 'pcf50633-input' (cf915720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357818] kobject: 'pcf50633-input' (cf915720): kobject_uevent_env
[   31.357820] kobject: 'pcf50633-input' (cf915720): fill_kobj_path: path = '/bus/platform/drivers/pcf50633-input'
[   31.357824] bus: 'platform': add driver pcspkr
[   31.357826] kobject: 'pcspkr' (cf915780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.357833] bus: 'platform': driver_probe_device: matched device pcspkr with driver pcspkr
[   31.357840] bus: 'platform': really_probe: probing driver pcspkr with device pcspkr
[   31.357901] device: 'input2': device_add
[   31.357913] kobject: 'input' (cf916e80): kobject_add_internal: parent: 'pcspkr', set: '(null)'
[   31.357917] kobject: 'input2' (cd9471a8): kobject_add_internal: parent: 'input', set: 'devices'
[   31.358005] PM: Adding info for No Bus:input2
[   31.358006] kobject: 'input2' (cd9471a8): kobject_uevent_env
[   31.358008] kobject: 'input2' (cd9471a8): fill_kobj_path: path = '/devices/platform/pcspkr/input/input2'
[   31.358031] kobject: 'input2' (cd9471a8): fill_kobj_path: path = '/devices/platform/pcspkr/input/input2'
[   31.358031] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   31.358471] evbug: Connected device: input2 (PC Speaker at isa0061/input0)
[   31.358508] driver: 'pcspkr': driver_bound: bound to device 'pcspkr'
[   31.358527] bus: 'platform': really_probe: bound device pcspkr to driver pcspkr
[   31.358584] kobject: 'pcspkr' (cf915780): kobject_uevent_env
[   31.358602] kobject: 'pcspkr' (cf915780): fill_kobj_path: path = '/bus/platform/drivers/pcspkr'
[   31.358668] device: 'uinput': device_add
[   31.358680] kobject: 'uinput' (cf911408): kobject_add_internal: parent: 'misc', set: 'devices'
[   31.358752] PM: Adding info for No Bus:uinput
[   31.358753] kobject: 'uinput' (cf911408): kobject_uevent_env
[   31.358758] kobject: 'uinput' (cf911408): fill_kobj_path: path = '/devices/virtual/misc/uinput'
[   31.358790] bus: 'platform': add driver wm831x-on
[   31.358792] kobject: 'wm831x-on' (cf9158a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.358808] kobject: 'wm831x-on' (cf9158a0): kobject_uevent_env
[   31.358810] kobject: 'wm831x-on' (cf9158a0): fill_kobj_path: path = '/bus/platform/drivers/wm831x-on'
[   31.358812] I2O subsystem v1.325
[   31.358812] i2o: max drivers = 8
[   31.358830] kobject: 'i2o' (caf0e00c): kobject_add_internal: parent: 'bus', set: 'bus'
[   31.358836] kobject: 'i2o' (caf0e00c): kobject_uevent_env
[   31.358838] kobject: 'i2o' (caf0e00c): fill_kobj_path: path = '/bus/i2o'
[   31.358843] kobject: 'devices' (cf917c8c): kobject_add_internal: parent: 'i2o', set: '<NULL>'
[   31.358845] kobject: 'devices' (cf917c8c): kobject_uevent_env
[   31.358846] kobject: 'devices' (cf917c8c): kobject_uevent_env: filter function caused the event to drop!
[   31.358849] kobject: 'drivers' (cf917d0c): kobject_add_internal: parent: 'i2o', set: '<NULL>'
[   31.358851] kobject: 'drivers' (cf917d0c): kobject_uevent_env
[   31.358852] kobject: 'drivers' (cf917d0c): kobject_uevent_env: filter function caused the event to drop!
[   31.358854] bus: 'i2o': registered
[   31.359040] bus: 'i2o': add driver exec-osm
[   31.359042] kobject: 'exec-osm' (cf915960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359046] kobject: 'exec-osm' (cf915960): kobject_uevent_env
[   31.359048] kobject: 'exec-osm' (cf915960): fill_kobj_path: path = '/bus/i2o/drivers/exec-osm'
[   31.359056] bus: 'pci': add driver PCI_I2O
[   31.359058] kobject: 'PCI_I2O' (cf9159c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359095] kobject: 'PCI_I2O' (cf9159c0): kobject_uevent_env
[   31.359097] kobject: 'PCI_I2O' (cf9159c0): fill_kobj_path: path = '/bus/pci/drivers/PCI_I2O'
[   31.359104] I2O Configuration OSM v1.323
[   31.359107] bus: 'i2o': add driver config-osm
[   31.359108] kobject: 'config-osm' (cf915a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359111] kobject: 'config-osm' (cf915a20): kobject_uevent_env
[   31.359113] kobject: 'config-osm' (cf915a20): fill_kobj_path: path = '/bus/i2o/drivers/config-osm'
[   31.359114] I2O SCSI Peripheral OSM v1.316
[   31.359115] bus: 'i2o': add driver scsi-osm
[   31.359116] kobject: 'scsi-osm' (cf915a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359119] kobject: 'scsi-osm' (cf915a80): kobject_uevent_env
[   31.359121] kobject: 'scsi-osm' (cf915a80): fill_kobj_path: path = '/bus/i2o/drivers/scsi-osm'
[   31.359122] I2O ProcFS OSM v1.316
[   31.359123] bus: 'i2o': add driver proc-osm
[   31.359124] kobject: 'proc-osm' (cf915ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359127] kobject: 'proc-osm' (cf915ae0): kobject_uevent_env
[   31.359129] kobject: 'proc-osm' (cf915ae0): fill_kobj_path: path = '/bus/i2o/drivers/proc-osm'
[   31.359151] bus: 'i2c': add driver smbus_alert
[   31.359153] kobject: 'smbus_alert' (cf915ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359160] kobject: 'smbus_alert' (cf915ba0): kobject_uevent_env
[   31.359161] kobject: 'smbus_alert' (cf915ba0): fill_kobj_path: path = '/bus/i2c/drivers/smbus_alert'
[   31.359167] i2c-core: driver [smbus_alert] registered
[   31.359169] bus: 'pci': add driver ali1535_smbus
[   31.359175] kobject: 'ali1535_smbus' (cf915c00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359184] kobject: 'ali1535_smbus' (cf915c00): kobject_uevent_env
[   31.359185] kobject: 'ali1535_smbus' (cf915c00): fill_kobj_path: path = '/bus/pci/drivers/ali1535_smbus'
[   31.359189] bus: 'pci': add driver nForce2_smbus
[   31.359195] kobject: 'nForce2_smbus' (cf915c60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359201] kobject: 'nForce2_smbus' (cf915c60): kobject_uevent_env
[   31.359203] kobject: 'nForce2_smbus' (cf915c60): fill_kobj_path: path = '/bus/pci/drivers/nForce2_smbus'
[   31.359206] bus: 'pci': add driver sis5595_smbus
[   31.359208] kobject: 'sis5595_smbus' (cf915cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359212] kobject: 'sis5595_smbus' (cf915cc0): kobject_uevent_env
[   31.359214] kobject: 'sis5595_smbus' (cf915cc0): fill_kobj_path: path = '/bus/pci/drivers/sis5595_smbus'
[   31.359219] bus: 'pci': add driver sis630_smbus
[   31.359220] kobject: 'sis630_smbus' (cf915d20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359225] kobject: 'sis630_smbus' (cf915d20): kobject_uevent_env
[   31.359226] kobject: 'sis630_smbus' (cf915d20): fill_kobj_path: path = '/bus/pci/drivers/sis630_smbus'
[   31.359230] bus: 'pci': add driver sis96x_smbus
[   31.359231] kobject: 'sis96x_smbus' (cf915d80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359729] kobject: 'sis96x_smbus' (cf915d80): kobject_uevent_env
[   31.359748] kobject: 'sis96x_smbus' (cf915d80): fill_kobj_path: path = '/bus/pci/drivers/sis96x_smbus'
[   31.359831] bus: 'pci': add driver vt596_smbus
[   31.359835] kobject: 'vt596_smbus' (cf915de0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359849] kobject: 'vt596_smbus' (cf915de0): kobject_uevent_env
[   31.359851] kobject: 'vt596_smbus' (cf915de0): fill_kobj_path: path = '/bus/pci/drivers/vt596_smbus'
[   31.359854] bus: 'pci': add driver i2c_eg20t
[   31.359856] kobject: 'i2c_eg20t' (cf915e40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359865] kobject: 'i2c_eg20t' (cf915e40): kobject_uevent_env
[   31.359867] kobject: 'i2c_eg20t' (cf915e40): fill_kobj_path: path = '/bus/pci/drivers/i2c_eg20t'
[   31.359870] bus: 'pci': add driver i2c-intel-mid
[   31.359872] kobject: 'i2c-intel-mid' (cf915ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359905] kobject: 'i2c-intel-mid' (cf915ea0): kobject_uevent_env
[   31.359907] kobject: 'i2c-intel-mid' (cf915ea0): fill_kobj_path: path = '/bus/pci/drivers/i2c-intel-mid'
[   31.359935] bus: 'platform': add driver i2c-pca-platform
[   31.359937] kobject: 'i2c-pca-platform' (cf915f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359961] kobject: 'i2c-pca-platform' (cf915f00): kobject_uevent_env
[   31.359963] kobject: 'i2c-pca-platform' (cf915f00): fill_kobj_path: path = '/bus/platform/drivers/i2c-pca-platform'
[   31.359966] bus: 'platform': add driver simtec-i2c
[   31.359967] kobject: 'simtec-i2c' (cf915f60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.359976] kobject: 'simtec-i2c' (cf915f60): kobject_uevent_env
[   31.359978] kobject: 'simtec-i2c' (cf915f60): fill_kobj_path: path = '/bus/platform/drivers/simtec-i2c'
[   31.359994] bus: 'usb': add driver i2c-tiny-usb
[   31.360180] kobject: 'i2c-tiny-usb' (cf91b000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360189] kobject: 'i2c-tiny-usb' (cf91b000): kobject_uevent_env
[   31.360191] kobject: 'i2c-tiny-usb' (cf91b000): fill_kobj_path: path = '/bus/usb/drivers/i2c-tiny-usb'
[   31.360197] usbcore: registered new interface driver i2c-tiny-usb
[   31.360201] scx200_acb: NatSemi SCx200 ACCESS.bus Driver
[   31.360212] bus: 'platform': add driver cs5535-smb
[   31.360214] kobject: 'cs5535-smb' (cf91b060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360222] kobject: 'cs5535-smb' (cf91b060): kobject_uevent_env
[   31.360224] kobject: 'cs5535-smb' (cf91b060): fill_kobj_path: path = '/bus/platform/drivers/cs5535-smb'
[   31.360274] bus: 'i2c': add driver w83781d
[   31.360276] kobject: 'w83781d' (cf91b0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360285] kobject: 'w83781d' (cf91b0c0): kobject_uevent_env
[   31.360287] kobject: 'w83781d' (cf91b0c0): fill_kobj_path: path = '/bus/i2c/drivers/w83781d'
[   31.360296] i2c-core: driver [w83781d] registered
[   31.360299] bus: 'i2c': add driver w83791d
[   31.360301] kobject: 'w83791d' (cf91b120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360304] kobject: 'w83791d' (cf91b120): kobject_uevent_env
[   31.360305] kobject: 'w83791d' (cf91b120): fill_kobj_path: path = '/bus/i2c/drivers/w83791d'
[   31.360307] i2c-core: driver [w83791d] registered
[   31.360308] bus: 'i2c': add driver adm1021
[   31.360310] kobject: 'adm1021' (cf91b180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360315] kobject: 'adm1021' (cf91b180): kobject_uevent_env
[   31.360317] kobject: 'adm1021' (cf91b180): fill_kobj_path: path = '/bus/i2c/drivers/adm1021'
[   31.360318] i2c-core: driver [adm1021] registered
[   31.360319] bus: 'i2c': add driver adm1026
[   31.360321] kobject: 'adm1026' (cf91b1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360324] kobject: 'adm1026' (cf91b1e0): kobject_uevent_env
[   31.360325] kobject: 'adm1026' (cf91b1e0): fill_kobj_path: path = '/bus/i2c/drivers/adm1026'
[   31.360327] i2c-core: driver [adm1026] registered
[   31.360332] bus: 'i2c': add driver adm1031
[   31.360333] kobject: 'adm1031' (cf91b240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360336] kobject: 'adm1031' (cf91b240): kobject_uevent_env
[   31.360338] kobject: 'adm1031' (cf91b240): fill_kobj_path: path = '/bus/i2c/drivers/adm1031'
[   31.360339] i2c-core: driver [adm1031] registered
[   31.360343] bus: 'i2c': add driver adm9240
[   31.360344] kobject: 'adm9240' (cf91b2a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360347] kobject: 'adm9240' (cf91b2a0): kobject_uevent_env
[   31.360349] kobject: 'adm9240' (cf91b2a0): fill_kobj_path: path = '/bus/i2c/drivers/adm9240'
[   31.360351] i2c-core: driver [adm9240] registered
[   31.360352] bus: 'i2c': add driver ads1015
[   31.360354] kobject: 'ads1015' (cf91b300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360356] kobject: 'ads1015' (cf91b300): kobject_uevent_env
[   31.360358] kobject: 'ads1015' (cf91b300): fill_kobj_path: path = '/bus/i2c/drivers/ads1015'
[   31.360359] i2c-core: driver [ads1015] registered
[   31.360361] bus: 'i2c': add driver ds620
[   31.360362] kobject: 'ds620' (cf91b360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360365] kobject: 'ds620' (cf91b360): kobject_uevent_env
[   31.360367] kobject: 'ds620' (cf91b360): fill_kobj_path: path = '/bus/i2c/drivers/ds620'
[   31.360368] i2c-core: driver [ds620] registered
[   31.360369] bus: 'i2c': add driver ds1621
[   31.360371] kobject: 'ds1621' (cf91b3c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360373] kobject: 'ds1621' (cf91b3c0): kobject_uevent_env
[   31.360375] kobject: 'ds1621' (cf91b3c0): fill_kobj_path: path = '/bus/i2c/drivers/ds1621'
[   31.360376] i2c-core: driver [ds1621] registered
[   31.360378] bus: 'i2c': add driver emc2103
[   31.360379] kobject: 'emc2103' (cf91b420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.360382] kobject: 'emc2103' (cf91b420): kobject_uevent_env
[   31.360384] kobject: 'emc2103' (cf91b420): fill_kobj_path: path = '/bus/i2c/drivers/emc2103'
[   31.360385] i2c-core: driver [emc2103] registered
[   31.360941] f71882fg: Not a Fintek device
[   31.360980] f71882fg: Not a Fintek device
[   31.361039] bus: 'i2c': add driver f75375
[   31.361052] kobject: 'f75375' (cf91b480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361118] kobject: 'f75375' (cf91b480): kobject_uevent_env
[   31.361123] kobject: 'f75375' (cf91b480): fill_kobj_path: path = '/bus/i2c/drivers/f75375'
[   31.361146] i2c-core: driver [f75375] registered
[   31.361168] bus: 'pci': add driver fam15h_power
[   31.361169] kobject: 'fam15h_power' (cf91b4e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361193] kobject: 'fam15h_power' (cf91b4e0): kobject_uevent_env
[   31.361199] kobject: 'fam15h_power' (cf91b4e0): fill_kobj_path: path = '/bus/pci/drivers/fam15h_power'
[   31.361205] bus: 'i2c': add driver fschmd
[   31.361206] kobject: 'fschmd' (cf91b540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361209] kobject: 'fschmd' (cf91b540): kobject_uevent_env
[   31.361211] kobject: 'fschmd' (cf91b540): fill_kobj_path: path = '/bus/i2c/drivers/fschmd'
[   31.361212] i2c-core: driver [fschmd] registered
[   31.361214] bus: 'i2c': add driver gl518sm
[   31.361215] kobject: 'gl518sm' (cf91b5a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361218] kobject: 'gl518sm' (cf91b5a0): kobject_uevent_env
[   31.361220] kobject: 'gl518sm' (cf91b5a0): fill_kobj_path: path = '/bus/i2c/drivers/gl518sm'
[   31.361221] i2c-core: driver [gl518sm] registered
[   31.361226] bus: 'i2c': add driver gl520sm
[   31.361228] kobject: 'gl520sm' (cf91b600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361231] kobject: 'gl520sm' (cf91b600): kobject_uevent_env
[   31.361232] kobject: 'gl520sm' (cf91b600): fill_kobj_path: path = '/bus/i2c/drivers/gl520sm'
[   31.361233] i2c-core: driver [gl520sm] registered
[   31.361255] bus: 'platform': add driver gpio-fan
[   31.361257] kobject: 'gpio-fan' (cf91b660): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361278] kobject: 'gpio-fan' (cf91b660): kobject_uevent_env
[   31.361280] kobject: 'gpio-fan' (cf91b660): fill_kobj_path: path = '/bus/platform/drivers/gpio-fan'
[   31.361438] bus: 'pci': add driver k10temp
[   31.361440] kobject: 'k10temp' (cf91b6c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361445] kobject: 'k10temp' (cf91b6c0): kobject_uevent_env
[   31.361446] kobject: 'k10temp' (cf91b6c0): fill_kobj_path: path = '/bus/pci/drivers/k10temp'
[   31.361450] bus: 'i2c': add driver lm63
[   31.361451] kobject: 'lm63' (cf91b720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361458] kobject: 'lm63' (cf91b720): kobject_uevent_env
[   31.361460] kobject: 'lm63' (cf91b720): fill_kobj_path: path = '/bus/i2c/drivers/lm63'
[   31.361462] i2c-core: driver [lm63] registered
[   31.361469] bus: 'spi': add driver lm70
[   31.361471] kobject: 'lm70' (cf91b780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361474] kobject: 'lm70' (cf91b780): kobject_uevent_env
[   31.361476] kobject: 'lm70' (cf91b780): fill_kobj_path: path = '/bus/spi/drivers/lm70'
[   31.361478] bus: 'i2c': add driver lm80
[   31.361479] kobject: 'lm80' (cf91b7e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361482] kobject: 'lm80' (cf91b7e0): kobject_uevent_env
[   31.361484] kobject: 'lm80' (cf91b7e0): fill_kobj_path: path = '/bus/i2c/drivers/lm80'
[   31.361485] i2c-core: driver [lm80] registered
[   31.361488] bus: 'i2c': add driver lm85
[   31.361490] kobject: 'lm85' (cf91b840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361493] kobject: 'lm85' (cf91b840): kobject_uevent_env
[   31.361494] kobject: 'lm85' (cf91b840): fill_kobj_path: path = '/bus/i2c/drivers/lm85'
[   31.361496] i2c-core: driver [lm85] registered
[   31.361497] bus: 'i2c': add driver lm90
[   31.361499] kobject: 'lm90' (cf91b8a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361504] kobject: 'lm90' (cf91b8a0): kobject_uevent_env
[   31.361505] kobject: 'lm90' (cf91b8a0): fill_kobj_path: path = '/bus/i2c/drivers/lm90'
[   31.361507] i2c-core: driver [lm90] registered
[   31.361510] bus: 'i2c': add driver lm93
[   31.361512] kobject: 'lm93' (cf91b900): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361514] kobject: 'lm93' (cf91b900): kobject_uevent_env
[   31.361516] kobject: 'lm93' (cf91b900): fill_kobj_path: path = '/bus/i2c/drivers/lm93'
[   31.361517] i2c-core: driver [lm93] registered
[   31.361519] bus: 'i2c': add driver ltc4151
[   31.361521] kobject: 'ltc4151' (cf91b960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361526] kobject: 'ltc4151' (cf91b960): kobject_uevent_env
[   31.361532] kobject: 'ltc4151' (cf91b960): fill_kobj_path: path = '/bus/i2c/drivers/ltc4151'
[   31.361534] i2c-core: driver [ltc4151] registered
[   31.361539] bus: 'i2c': add driver max16065
[   31.361541] kobject: 'max16065' (cf91b9c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.361544] kobject: 'max16065' (cf91b9c0): kobject_uevent_env
[   31.361546] kobject: 'max16065' (cf91b9c0): fill_kobj_path: path = '/bus/i2c/drivers/max16065'
[   31.361547] i2c-core: driver [max16065] registered
[   31.361549] bus: 'i2c': add driver max1619
[   31.361550] kobject: 'max1619' (cf91ba20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362023] kobject: 'max1619' (cf91ba20): kobject_uevent_env
[   31.362043] kobject: 'max1619' (cf91ba20): fill_kobj_path: path = '/bus/i2c/drivers/max1619'
[   31.362085] i2c-core: driver [max1619] registered
[   31.362146] pc87360: PC8736x not detected, module not inserted
[   31.362434] sch56xx_common: Unsupported device id: 0xff
[   31.362451] sch56xx_common: Unsupported device id: 0xff
[   31.362508] bus: 'platform': add driver sch5627
[   31.362516] kobject: 'sch5627' (cf91ba80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362547] kobject: 'sch5627' (cf91ba80): kobject_uevent_env
[   31.362549] kobject: 'sch5627' (cf91ba80): fill_kobj_path: path = '/bus/platform/drivers/sch5627'
[   31.362554] bus: 'platform': add driver sht10
[   31.362555] kobject: 'sht10' (cf91bae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362562] kobject: 'sht10' (cf91bae0): kobject_uevent_env
[   31.362564] kobject: 'sht10' (cf91bae0): fill_kobj_path: path = '/bus/platform/drivers/sht10'
[   31.362566] bus: 'platform': add driver sht11
[   31.362568] kobject: 'sht11' (cf91bb40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362575] kobject: 'sht11' (cf91bb40): kobject_uevent_env
[   31.362577] kobject: 'sht11' (cf91bb40): fill_kobj_path: path = '/bus/platform/drivers/sht11'
[   31.362579] bus: 'platform': add driver sht15
[   31.362580] kobject: 'sht15' (cf91bba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362584] kobject: 'sht15' (cf91bba0): kobject_uevent_env
[   31.362586] kobject: 'sht15' (cf91bba0): fill_kobj_path: path = '/bus/platform/drivers/sht15'
[   31.362588] bus: 'platform': add driver sht71
[   31.362589] kobject: 'sht71' (cf91bc00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362593] kobject: 'sht71' (cf91bc00): kobject_uevent_env
[   31.362595] kobject: 'sht71' (cf91bc00): fill_kobj_path: path = '/bus/platform/drivers/sht71'
[   31.362596] bus: 'platform': add driver sht75
[   31.362598] kobject: 'sht75' (cf91bc60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.362601] kobject: 'sht75' (cf91bc60): kobject_uevent_env
[   31.362603] kobject: 'sht75' (cf91bc60): fill_kobj_path: path = '/bus/platform/drivers/sht75'
[   31.362976] bus: 'i2c': add driver sht21
[   31.363011] kobject: 'sht21' (cf91bcc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.363069] kobject: 'sht21' (cf91bcc0): kobject_uevent_env
[   31.363077] kobject: 'sht21' (cf91bcc0): fill_kobj_path: path = '/bus/i2c/drivers/sht21'
[   31.363106] i2c-core: driver [sht21] registered
[   31.363151] bus: 'pci': add driver vt8231
[   31.363153] kobject: 'vt8231' (cf91bd20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.363177] kobject: 'vt8231' (cf91bd20): kobject_uevent_env
[   31.363179] kobject: 'vt8231' (cf91bd20): fill_kobj_path: path = '/bus/pci/drivers/vt8231'
[   31.363507] bus: 'platform': add driver wm831x-hwmon
[   31.363509] kobject: 'wm831x-hwmon' (cf91bd80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.363536] kobject: 'wm831x-hwmon' (cf91bd80): kobject_uevent_env
[   31.363538] kobject: 'wm831x-hwmon' (cf91bd80): fill_kobj_path: path = '/bus/platform/drivers/wm831x-hwmon'
[   31.363544] acquirewdt: WDT driver for Acquire single board computer initialising
[   31.363550] bus: 'platform': add driver acquirewdt
[   31.363552] kobject: 'acquirewdt' (cf91bde0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.363557] kobject: 'acquirewdt' (cf91bde0): kobject_uevent_env
[   31.363559] kobject: 'acquirewdt' (cf91bde0): fill_kobj_path: path = '/bus/platform/drivers/acquirewdt'
[   31.363992] Registering platform device 'acquirewdt'. Parent at platform
[   31.364003] device: 'acquirewdt': device_add
[   31.364012] kobject: 'acquirewdt' (cf911610): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.364076] bus: 'platform': add device acquirewdt
[   31.364110] PM: Adding info for platform:acquirewdt
[   31.364113] kobject: 'acquirewdt' (cf911610): kobject_uevent_env
[   31.364119] kobject: 'acquirewdt' (cf911610): fill_kobj_path: path = '/devices/platform/acquirewdt'
[   31.364256] bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
[   31.364259] bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
[   31.364271] acquirewdt: I/O address 0x0043 already in use
[   31.364279] acquirewdt: probe of acquirewdt failed with error -5
[   31.364626] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   31.364627] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   31.364628] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[   31.364642] bus: 'platform': add driver SP5100 TCO timer
[   31.364644] kobject: 'SP5100 TCO timer' (cf91bea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.364672] kobject: 'SP5100 TCO timer' (cf91bea0): kobject_uevent_env
[   31.364674] kobject: 'SP5100 TCO timer' (cf91bea0): fill_kobj_path: path = '/bus/platform/drivers/SP5100 TCO timer'
[   31.364687] Registering platform device 'SP5100 TCO timer'. Parent at platform
[   31.364688] device: 'SP5100 TCO timer': device_add
[   31.364689] kobject: 'SP5100 TCO timer' (cf911810): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.364692] bus: 'platform': add device SP5100 TCO timer
[   31.364726] PM: Adding info for platform:SP5100 TCO timer
[   31.364727] kobject: 'SP5100 TCO timer' (cf911810): kobject_uevent_env
[   31.364729] kobject: 'SP5100 TCO timer' (cf911810): fill_kobj_path: path = '/devices/platform/SP5100 TCO timer'
[   31.364736] bus: 'platform': driver_probe_device: matched device SP5100 TCO timer with driver SP5100 TCO timer
[   31.364737] bus: 'platform': really_probe: probing driver SP5100 TCO timer with device SP5100 TCO timer
[   31.364749] SP5100 TCO timer: probe of SP5100 TCO timer rejects match -19
[   31.364752] bus: 'platform': add driver geodewdt
[   31.364753] kobject: 'geodewdt' (cf91bf60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.364763] kobject: 'geodewdt' (cf91bf60): kobject_uevent_env
[   31.364765] kobject: 'geodewdt' (cf91bf60): fill_kobj_path: path = '/bus/platform/drivers/geodewdt'
[   31.364768] Registering platform device 'geodewdt'. Parent at platform
[   31.364773] device: 'geodewdt': device_add
[   31.364774] kobject: 'geodewdt' (cf911a10): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.364777] bus: 'platform': add device geodewdt
[   31.364785] PM: Adding info for platform:geodewdt
[   31.364786] kobject: 'geodewdt' (cf911a10): kobject_uevent_env
[   31.364788] kobject: 'geodewdt' (cf911a10): fill_kobj_path: path = '/devices/platform/geodewdt'
[   31.364794] bus: 'platform': driver_probe_device: matched device geodewdt with driver geodewdt
[   31.364795] bus: 'platform': really_probe: probing driver geodewdt with device geodewdt
[   31.364799] geodewdt: No timers were available
[   31.364801] geodewdt: probe of geodewdt rejects match -19
[   31.364867] device: 'watchdog': device_add
[   31.364874] kobject: 'watchdog' (cf911c08): kobject_add_internal: parent: 'misc', set: 'devices'
[   31.364905] PM: Adding info for No Bus:watchdog
[   31.364906] kobject: 'watchdog' (cf911c08): kobject_uevent_env
[   31.364915] kobject: 'watchdog' (cf911c08): fill_kobj_path: path = '/devices/virtual/misc/watchdog'
[   31.364920] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   31.364920] ib700wdt: WDT driver for IB700 single board computer initialising
[   31.364922] bus: 'platform': add driver ib700wdt
[   31.364924] kobject: 'ib700wdt' (cf91f0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.364928] kobject: 'ib700wdt' (cf91f0c0): kobject_uevent_env
[   31.364937] kobject: 'ib700wdt' (cf91f0c0): fill_kobj_path: path = '/bus/platform/drivers/ib700wdt'
[   31.364941] Registering platform device 'ib700wdt'. Parent at platform
[   31.364942] device: 'ib700wdt': device_add
[   31.364943] kobject: 'ib700wdt' (cf911e10): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.364945] bus: 'platform': add device ib700wdt
[   31.364951] PM: Adding info for platform:ib700wdt
[   31.364952] kobject: 'ib700wdt' (cf911e10): kobject_uevent_env
[   31.364954] kobject: 'ib700wdt' (cf911e10): fill_kobj_path: path = '/devices/platform/ib700wdt'
[   31.364960] bus: 'platform': driver_probe_device: matched device ib700wdt with driver ib700wdt
[   31.364961] bus: 'platform': really_probe: probing driver ib700wdt with device ib700wdt
[   31.364964] ib700wdt: failed to register misc device
[   31.364966] ib700wdt: probe of ib700wdt failed with error -16
[   31.364975] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[   31.364977] wafer5823wdt: cannot register miscdev on minor=130 (err=-16)
[   31.365398] bus: 'pci': add driver i6300ESB timer
[   31.365430] kobject: 'i6300ESB timer' (cf91f180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.365499] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver i6300ESB timer
[   31.365508] bus: 'pci': really_probe: probing driver i6300ESB timer with device 0000:00:0a.0
[   31.365515] pci_notify
[   31.365536] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   31.367121] i6300esb: cannot register miscdev on minor=130 (err=-16)
[   31.367292] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[   31.367331] kobject: 'i6300ESB timer' (cf91f180): kobject_uevent_env
[   31.367341] kobject: 'i6300ESB timer' (cf91f180): fill_kobj_path: path = '/bus/pci/drivers/i6300ESB timer'
[   31.367397] bus: 'pci': add driver hpwdt
[   31.367401] kobject: 'hpwdt' (cf91f1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.367418] kobject: 'hpwdt' (cf91f1e0): kobject_uevent_env
[   31.367420] kobject: 'hpwdt' (cf91f1e0): fill_kobj_path: path = '/bus/pci/drivers/hpwdt'
[   31.367422] sc1200wdt: build 20020303
[   31.367436] bus: 'pnp': add driver scl200wdt
[   31.367438] kobject: 'scl200wdt' (cf91f240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.367479] kobject: 'scl200wdt' (cf91f240): kobject_uevent_env
[   31.367481] kobject: 'scl200wdt' (cf91f240): fill_kobj_path: path = '/bus/pnp/drivers/scl200wdt'
[   31.367483] sc1200wdt: io parameter must be specified
[   31.367492] bus: 'pnp': remove driver scl200wdt
[   31.367493] kobject: 'scl200wdt' (cf91f240): kobject_cleanup
[   31.367494] kobject: 'scl200wdt' (cf91f240): auto cleanup 'remove' event
[   31.367495] kobject: 'scl200wdt' (cf91f240): kobject_uevent_env
[   31.367497] kobject: 'scl200wdt' (cf91f240): fill_kobj_path: path = '/bus/pnp/drivers/scl200wdt'
[   31.367499] kobject: 'scl200wdt' (cf91f240): auto cleanup kobject_del
[   31.367504] sysfs scl200wdt: removing dir
[   31.367508] kobject: 'scl200wdt' (cf91f240): calling ktype release
[   31.367511] driver: 'scl200wdt': driver_release
[   31.367511] kobject: 'scl200wdt': free name
[   31.367512] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   31.367534] bus: 'platform': add driver NV_TCO
[   31.367536] kobject: 'NV_TCO' (cf91f240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.367560] kobject: 'NV_TCO' (cf91f240): kobject_uevent_env
[   31.367563] kobject: 'NV_TCO' (cf91f240): fill_kobj_path: path = '/bus/platform/drivers/NV_TCO'
[   31.367598] Registering platform device 'NV_TCO'. Parent at platform
[   31.367602] device: 'NV_TCO': device_add
[   31.367603] kobject: 'NV_TCO' (cf936010): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.367622] bus: 'platform': add device NV_TCO
[   31.367640] PM: Adding info for platform:NV_TCO
[   31.367642] kobject: 'NV_TCO' (cf936010): kobject_uevent_env
[   31.367644] kobject: 'NV_TCO' (cf936010): fill_kobj_path: path = '/devices/platform/NV_TCO'
[   31.367706] bus: 'platform': driver_probe_device: matched device NV_TCO with driver NV_TCO
[   31.367707] bus: 'platform': really_probe: probing driver NV_TCO with device NV_TCO
[   31.367720] NV_TCO: probe of NV_TCO rejects match -19
[   31.367731] sbc8360: failed to register misc device
[   31.367732] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[   31.369098] smsc37b787_wdt: Unable to register miscdev on minor 130
[   31.369125] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[   31.369404] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[   31.369443] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[   31.369444] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   31.369458] w83697hf_wdt: Looking for watchdog at address 0x2e
[   31.369481] w83697hf_wdt: watchdog not found at address 0x2e
[   31.369482] w83697hf_wdt: No W83697HF/HG could be found
[   31.369482] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[   31.370019] w83697ug_wdt: No W83697UG/UF could be found
[   31.370293] w83877f_wdt: cannot register miscdev on minor=130 (err=-16)
[   31.370294] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   31.370309] machzwd: no ZF-Logic found
[   31.370383] bus: 'platform': add driver wm831x-watchdog
[   31.370396] kobject: 'wm831x-watchdog' (cf91f300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.370874] kobject: 'wm831x-watchdog' (cf91f300): kobject_uevent_env
[   31.370899] kobject: 'wm831x-watchdog' (cf91f300): fill_kobj_path: path = '/bus/platform/drivers/wm831x-watchdog'
[   31.370975] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   31.370976] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   31.371025] device: 'watchdog1': device_add
[   31.371035] kobject: 'watchdog' (cf9264c0): kobject_add_internal: parent: 'virtual', set: '(null)'
[   31.371050] kobject: 'watchdog1' (cf936208): kobject_add_internal: parent: 'watchdog', set: 'devices'
[   31.371100] PM: Adding info for No Bus:watchdog1
[   31.371101] kobject: 'watchdog1' (cf936208): kobject_uevent_env
[   31.371104] kobject: 'watchdog1' (cf936208): fill_kobj_path: path = '/devices/virtual/watchdog/watchdog1'
[   31.371111] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   31.371117] md: linear personality registered for level -1
[   31.371120] md: raid10 personality registered for level 10
[   31.371121] md: raid6 personality registered for level 6
[   31.371122] md: raid5 personality registered for level 5
[   31.371122] md: raid4 personality registered for level 4
[   31.371125] md: multipath personality registered for level -4
[   31.371129] Bluetooth: HCI UART driver ver 2.2
[   31.371136] Bluetooth: HCI H4 protocol initialized
[   31.371138] Bluetooth: HCI BCSP protocol initialized
[   31.371150] registering driver bluecard_cs
[   31.371158] bus: 'pcmcia': add driver bluecard_cs
[   31.371162] kobject: 'bluecard_cs' (cf91f3c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371167] kobject: 'bluecard_cs' (cf91f3c0): kobject_uevent_env
[   31.371169] kobject: 'bluecard_cs' (cf91f3c0): fill_kobj_path: path = '/bus/pcmcia/drivers/bluecard_cs'
[   31.371190] bus: 'usb': add driver btusb
[   31.371192] kobject: 'btusb' (cf91f420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371204] kobject: 'btusb' (cf91f420): kobject_uevent_env
[   31.371206] kobject: 'btusb' (cf91f420): fill_kobj_path: path = '/bus/usb/drivers/btusb'
[   31.371210] usbcore: registered new interface driver btusb
[   31.371211] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   31.371216] bus: 'sdio': add driver btsdio
[   31.371218] kobject: 'btsdio' (cf91f480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371221] kobject: 'btsdio' (cf91f480): kobject_uevent_env
[   31.371222] kobject: 'btsdio' (cf91f480): fill_kobj_path: path = '/bus/sdio/drivers/btsdio'
[   31.371230] cpuidle: using governor ladder
[   31.371230] cpuidle: using governor menu
[   31.371240] bus: 'mmc': add driver mmcblk
[   31.371241] kobject: 'mmcblk' (cf91f4e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371244] kobject: 'mmcblk' (cf91f4e0): kobject_uevent_env
[   31.371246] kobject: 'mmcblk' (cf91f4e0): fill_kobj_path: path = '/bus/mmc/drivers/mmcblk'
[   31.371249] sdhci: Secure Digital Host Controller Interface driver
[   31.371250] sdhci: Copyright(c) Pierre Ossman
[   31.371262] bus: 'pci': add driver sdhci-pci
[   31.371264] kobject: 'sdhci-pci' (cf91f540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371286] kobject: 'sdhci-pci' (cf91f540): kobject_uevent_env
[   31.371288] kobject: 'sdhci-pci' (cf91f540): fill_kobj_path: path = '/bus/pci/drivers/sdhci-pci'
[   31.371303] bus: 'platform': add driver cb710-mmc
[   31.371305] kobject: 'cb710-mmc' (cf91f5a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371318] kobject: 'cb710-mmc' (cf91f5a0): kobject_uevent_env
[   31.371320] kobject: 'cb710-mmc' (cf91f5a0): fill_kobj_path: path = '/bus/platform/drivers/cb710-mmc'
[   31.371546] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[   31.371546] bus: 'usb': add driver vub300
[   31.371549] kobject: 'vub300' (cf91f720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371556] kobject: 'vub300' (cf91f720): kobject_uevent_env
[   31.371558] kobject: 'vub300' (cf91f720): fill_kobj_path: path = '/bus/usb/drivers/vub300'
[   31.371560] usbcore: registered new interface driver vub300
[   31.371562] bus: 'usb': add driver ushc
[   31.371564] kobject: 'ushc' (cf91f780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371566] kobject: 'ushc' (cf91f780): kobject_uevent_env
[   31.371568] kobject: 'ushc' (cf91f780): fill_kobj_path: path = '/bus/usb/drivers/ushc'
[   31.371570] usbcore: registered new interface driver ushc
[   31.371577] bus: 'i2c': add driver lm3530-led
[   31.371579] kobject: 'lm3530-led' (cf91f7e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371592] kobject: 'lm3530-led' (cf91f7e0): kobject_uevent_env
[   31.371594] kobject: 'lm3530-led' (cf91f7e0): fill_kobj_path: path = '/bus/i2c/drivers/lm3530-led'
[   31.371600] i2c-core: driver [lm3530-led] registered
[   31.371602] bus: 'platform': add driver leds-gpio
[   31.371603] kobject: 'leds-gpio' (cf91f840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371612] kobject: 'leds-gpio' (cf91f840): kobject_uevent_env
[   31.371613] kobject: 'leds-gpio' (cf91f840): fill_kobj_path: path = '/bus/platform/drivers/leds-gpio'
[   31.371616] bus: 'i2c': add driver lp5521
[   31.371617] kobject: 'lp5521' (cf91f8a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371624] kobject: 'lp5521' (cf91f8a0): kobject_uevent_env
[   31.371626] kobject: 'lp5521' (cf91f8a0): fill_kobj_path: path = '/bus/i2c/drivers/lp5521'
[   31.371627] i2c-core: driver [lp5521] registered
[   31.371639] bus: 'platform': add driver leds-regulator
[   31.371640] kobject: 'leds-regulator' (cf91f900): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371644] kobject: 'leds-regulator' (cf91f900): kobject_uevent_env
[   31.371646] kobject: 'leds-regulator' (cf91f900): fill_kobj_path: path = '/bus/platform/drivers/leds-regulator'
[   31.371649] bus: 'platform': add driver leds-lt3593
[   31.371655] kobject: 'leds-lt3593' (cf91f960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371663] kobject: 'leds-lt3593' (cf91f960): kobject_uevent_env
[   31.371665] kobject: 'leds-lt3593' (cf91f960): fill_kobj_path: path = '/bus/platform/drivers/leds-lt3593'
[   31.371672] bus: 'spi': add driver dac124s085
[   31.371674] kobject: 'dac124s085' (cf91f9c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371677] kobject: 'dac124s085' (cf91f9c0): kobject_uevent_env
[   31.371679] kobject: 'dac124s085' (cf91f9c0): fill_kobj_path: path = '/bus/spi/drivers/dac124s085'
[   31.371685] Registering platform device 'dell_rbu'. Parent at platform
[   31.371687] device: 'dell_rbu': device_add
[   31.371688] kobject: 'dell_rbu' (cf936410): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.371697] bus: 'platform': add device dell_rbu
[   31.371707] PM: Adding info for platform:dell_rbu
[   31.371708] kobject: 'dell_rbu' (cf936410): kobject_uevent_env
[   31.371710] kobject: 'dell_rbu' (cf936410): fill_kobj_path: path = '/devices/platform/dell_rbu'
[   31.371772] bus: 'platform': add driver dcdbas
[   31.371774] kobject: 'dcdbas' (cf91fa80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.371780] kobject: 'dcdbas' (cf91fa80): kobject_uevent_env
[   31.371782] kobject: 'dcdbas' (cf91fa80): fill_kobj_path: path = '/bus/platform/drivers/dcdbas'
[   31.371785] Registering platform device 'dcdbas'. Parent at platform
[   31.371786] device: 'dcdbas': device_add
[   31.371787] kobject: 'dcdbas' (cf936610): kobject_add_internal: parent: 'platform', set: 'devices'
[   31.371789] bus: 'platform': add device dcdbas
[   31.371799] PM: Adding info for platform:dcdbas
[   31.371800] kobject: 'dcdbas' (cf936610): kobject_uevent_env
[   31.371802] kobject: 'dcdbas' (cf936610): fill_kobj_path: path = '/devices/platform/dcdbas'
[   31.371808] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   31.371809] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   31.372353] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   31.372389] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   31.372404] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   31.372469] bus: 'pci': add driver Geode LX AES
[   31.372485] kobject: 'Geode LX AES' (cf91fb40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.372512] kobject: 'Geode LX AES' (cf91fb40): kobject_uevent_env
[   31.372518] kobject: 'Geode LX AES' (cf91fb40): fill_kobj_path: path = '/bus/pci/drivers/Geode LX AES'
[   31.372548] bus: 'pci': add driver hifn795x
[   31.372550] kobject: 'hifn795x' (cf91fba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.372564] kobject: 'hifn795x' (cf91fba0): kobject_uevent_env
[   31.372566] kobject: 'hifn795x' (cf91fba0): fill_kobj_path: path = '/bus/pci/drivers/hifn795x'
[   31.372568] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[   31.372578] kobject: 'hid' (caf0e10c): kobject_add_internal: parent: 'bus', set: 'bus'
[   31.372587] kobject: 'hid' (caf0e10c): kobject_uevent_env
[   31.372588] kobject: 'hid' (caf0e10c): fill_kobj_path: path = '/bus/hid'
[   31.372595] kobject: 'devices' (cf9296cc): kobject_add_internal: parent: 'hid', set: '<NULL>'
[   31.372596] kobject: 'devices' (cf9296cc): kobject_uevent_env
[   31.372598] kobject: 'devices' (cf9296cc): kobject_uevent_env: filter function caused the event to drop!
[   31.372599] kobject: 'drivers' (cf92974c): kobject_add_internal: parent: 'hid', set: '<NULL>'
[   31.372601] kobject: 'drivers' (cf92974c): kobject_uevent_env
[   31.372601] kobject: 'drivers' (cf92974c): kobject_uevent_env: filter function caused the event to drop!
[   31.372606] bus: 'hid': registered
[   31.372612] device class 'hidraw': registering
[   31.372623] kobject: 'hidraw' (caf0e20c): kobject_add_internal: parent: 'class', set: 'class'
[   31.372631] kobject: 'hidraw' (caf0e20c): kobject_uevent_env
[   31.372632] kobject: 'hidraw' (caf0e20c): fill_kobj_path: path = '/class/hidraw'
[   31.372652] debugfs: creating file 'hid'
[   31.372747] bus: 'hid': add driver hid-generic
[   31.372748] kobject: 'hid-generic' (cf91fc60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.372752] kobject: 'hid-generic' (cf91fc60): kobject_uevent_env
[   31.372754] kobject: 'hid-generic' (cf91fc60): fill_kobj_path: path = '/bus/hid/drivers/hid-generic'
[   31.372775] bus: 'platform': add driver olpc-ec
[   31.372776] kobject: 'olpc-ec' (cf91fcc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.372797] kobject: 'olpc-ec' (cf91fcc0): kobject_uevent_env
[   31.372799] kobject: 'olpc-ec' (cf91fcc0): fill_kobj_path: path = '/bus/platform/drivers/olpc-ec'
[   31.372805] oprofile: using NMI interrupt.
[   31.372862] pktgen: Packet Generator for packet performance testing. Version: 2.74
[   35.520323] CPA self-test:
[   35.520459]  4k 2046 large 62 gb 0 x 2108[c0000000-cfffd000] miss 0
[  131.080117] INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1, t=10002 jiffies)
[  131.080117] Pid: 21, comm: pageattr-test Not tainted 3.6.0-rc7-bisect2-00039-g6f0f9b6-dirty #20
[  131.080117] Call Trace:
[  131.080117]  [<c10be145>] rcu_check_callbacks+0x555/0x580
[  131.080117]  [<c10702b6>] update_process_times+0x36/0x70
[  131.080117]  [<c10a06f7>] tick_sched_timer+0x57/0xc0
[  131.080117]  [<c10819da>] __run_hrtimer.isra.31+0x4a/0xc0
[  131.080117]  [<c10a06a0>] ? tick_nohz_handler+0xf0/0xf0
[  131.080117]  [<c10825a5>] hrtimer_interrupt+0xf5/0x290
[  131.080117]  [<c104f65f>] smp_apic_timer_interrupt+0x4f/0x80
[  131.080117]  [<c16742b6>] apic_timer_interrupt+0x2a/0x30
[  131.080117]  [<c10a59aa>] ? generic_exec_single+0x5a/0x80
[  131.080117]  [<c105caf0>] ? leave_mm+0x40/0x40
[  131.080117]  [<c10a5ca1>] smp_call_function_single+0xb1/0x180
[  131.080117]  [<c105caf0>] ? leave_mm+0x40/0x40
[  131.080117]  [<c10a60c4>] smp_call_function_many+0x1a4/0x1f0
[  131.080117]  [<c105caf0>] ? leave_mm+0x40/0x40
[  131.080117]  [<c105caf0>] ? leave_mm+0x40/0x40
[  131.080117]  [<c10a6147>] smp_call_function+0x37/0x80
[  131.080117]  [<c105caf0>] ? leave_mm+0x40/0x40
[  131.080117]  [<c10a61ba>] on_each_cpu+0x2a/0x80
[  131.080117]  [<c105cf72>] flush_tlb_kernel_range+0x42/0x80
[  131.080117]  [<c10f0ccf>] __purge_vmap_area_lazy+0x12f/0x190
[  131.080117]  [<c10f1a37>] vm_unmap_aliases+0x137/0x140
[  131.080117]  [<c1059a6d>] change_page_attr_set_clr+0x9d/0x350
[  131.080117]  [<c105a17a>] ? print_split+0x19a/0x1a0
[  131.080117]  [<c105a4de>] do_pageattr_test+0x35e/0x4b0
[  131.080117]  [<c1085c0d>] ? __wake_up_common+0x3d/0x70
[  131.080117]  [<c1673a88>] ? _raw_spin_unlock_irqrestore+0x18/0x40
[  131.080117]  [<c10890f9>] ? complete+0x49/0x60
[  131.080117]  [<c105a180>] ? print_split+0x1a0/0x1a0
[  131.080117]  [<c107dd0d>] kthread+0x6d/0x80
[  131.080117]  [<c107dca0>] ? insert_kthread_work+0x40/0x40
[  131.080117]  [<c1674c36>] kernel_thread_helper+0x6/0xd
[  431.130195] INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1, t=40007 jiffies)
[  431.130195] Pid: 21, comm: pageattr-test Not tainted 3.6.0-rc7-bisect2-00039-g6f0f9b6-dirty #20
[  431.130195] Call Trace:
[  431.130195]  [<c10be145>] rcu_check_callbacks+0x555/0x580
[  431.130195]  [<c10702b6>] update_process_times+0x36/0x70
[  431.130195]  [<c10a06f7>] tick_sched_timer+0x57/0xc0
[  431.130195]  [<c10819da>] __run_hrtimer.isra.31+0x4a/0xc0
[  431.130195]  [<c10a06a0>] ? tick_nohz_handler+0xf0/0xf0
[  431.130195]  [<c10825a5>] hrtimer_interrupt+0xf5/0x290
[  431.130195]  [<c104f65f>] smp_apic_timer_interrupt+0x4f/0x80
[  431.130195]  [<c16742b6>] apic_timer_interrupt+0x2a/0x30
[  431.130195]  [<c10a59aa>] ? generic_exec_single+0x5a/0x80
[  431.130195]  [<c105caf0>] ? leave_mm+0x40/0x40
[  431.130195]  [<c10a5ca1>] smp_call_function_single+0xb1/0x180
[  431.130195]  [<c105caf0>] ? leave_mm+0x40/0x40
[  431.130195]  [<c10a60c4>] smp_call_function_many+0x1a4/0x1f0
[  431.130195]  [<c105caf0>] ? leave_mm+0x40/0x40
[  431.130195]  [<c105caf0>] ? leave_mm+0x40/0x40
[  431.130195]  [<c10a6147>] smp_call_function+0x37/0x80
[  431.130195]  [<c105caf0>] ? leave_mm+0x40/0x40
[  431.130195]  [<c10a61ba>] on_each_cpu+0x2a/0x80
[  431.130195]  [<c105cf72>] flush_tlb_kernel_range+0x42/0x80
[  431.130195]  [<c10f0ccf>] __purge_vmap_area_lazy+0x12f/0x190
[  431.130195]  [<c10f1a37>] vm_unmap_aliases+0x137/0x140
[  431.130195]  [<c1059a6d>] change_page_attr_set_clr+0x9d/0x350
[  431.130195]  [<c105a17a>] ? print_split+0x19a/0x1a0
[  431.130195]  [<c105a4de>] do_pageattr_test+0x35e/0x4b0
[  431.130195]  [<c1085c0d>] ? __wake_up_common+0x3d/0x70
[  431.130195]  [<c1673a88>] ? _raw_spin_unlock_irqrestore+0x18/0x40
[  431.130195]  [<c10890f9>] ? complete+0x49/0x60
[  431.130195]  [<c105a180>] ? print_split+0x1a0/0x1a0
[  431.130195]  [<c107dd0d>] kthread+0x6d/0x80
[  431.130195]  [<c107dca0>] ? insert_kthread_work+0x40/0x40
[  431.130195]  [<c1674c36>] kernel_thread_helper+0x6/0xd
[  457.465899] psmouse serio1: elantech: sending Elantech magic knock failed.
[  457.466921] pktgen: starting pktgen/0:  pid=85
[  457.466991] kobject: 'battery' (cf894540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[  457.467086] kobject: 'battery' (cf894540): kobject_uevent_env
[  457.467099] kobject: 'battery' (cf894540): fill_kobj_path: path = '/bus/acpi/drivers/battery'
[  458.354746] pktgen: starting pktgen/1:  pid=86
[  458.499910]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[  458.514249] NET: Registered protocol family 26
[  458.514289] Mirror/redirect action on
[  458.514296] netem: version 1.3
[  458.514309] NET: Registered protocol family 17
[  458.514598] device: 'nr0': device_add
[  458.514622] kobject: 'nr0' (cf901a34): kobject_add_internal: parent: 'net', set: 'devices'
[  458.514720] PM: Adding info for No Bus:nr0
[  458.514725] kobject: 'nr0' (cf901a34): kobject_uevent_env
[  458.514734] kobject: 'nr0' (cf901a34): fill_kobj_path: path = '/devices/virtual/net/nr0'
[  458.514763] kobject: 'queues' (cf92e94c): kobject_add_internal: parent: 'nr0', set: '<NULL>'
[  458.514765] kobject: 'queues' (cf92e94c): kobject_uevent_env
[  458.514767] kobject: 'queues' (cf92e94c): kobject_uevent_env: filter function caused the event to drop!
[  458.514769] kobject: 'rx-0' (cf929c88): kobject_add_internal: parent: 'queues', set: 'queues'
[  458.514777] kobject: 'rx-0' (cf929c88): kobject_uevent_env
[  458.514779] kobject: 'rx-0' (cf929c88): fill_kobj_path: path = '/devices/virtual/net/nr0/queues/rx-0'
[  458.514782] kobject: 'tx-0' (caf0e30c): kobject_add_internal: parent: 'queues', set: 'queues'
[  458.514795] kobject: 'tx-0' (caf0e30c): kobject_uevent_env
[  458.514797] kobject: 'tx-0' (caf0e30c): fill_kobj_path: path = '/devices/virtual/net/nr0/queues/tx-0'
[  458.514803] nr0: Dropping NETIF_F_GSO since no SG feature.

--fUYQa+Pmc3FrFX/N--
