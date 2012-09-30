Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab2I3LYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:24:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:39723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2I3LYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:24:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,513,1344236400"; 
   d="scan'208";a="228265620"
Date: Sun, 30 Sep 2012 19:23:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, johnstul@us.ibm.com,
        tglx@linutronix.de
Subject: Re: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected
 by 0, t=10002 jiffies)
Message-ID: <20120930112308.GA18839@localhost>
References: <20120925150701.GA2502@linux.vnet.ibm.com>
 <20120926042237.GA18287@localhost>
 <20120926043445.GB2524@linux.vnet.ibm.com>
 <20120926081501.GA28485@localhost>
 <20120926164543.GD2467@linux.vnet.ibm.com>
 <20120927025400.GA11434@localhost>
 <20120927042849.GA6556@linux.vnet.ibm.com>
 <20120927044044.GA22753@localhost>
 <20120928033511.GB2480@linux.vnet.ibm.com>
 <506828BF.9050409@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <506828BF.9050409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 30, 2012 at 01:10:55PM +0200, Avi Kivity wrote:
> On 09/28/2012 05:35 AM, Paul E. McKenney wrote:
> > On Thu, Sep 27, 2012 at 12:40:44PM +0800, Fengguang Wu wrote:
> >> On Wed, Sep 26, 2012 at 09:28:50PM -0700, Paul E. McKenney wrote:
> >> > On Thu, Sep 27, 2012 at 10:54:00AM +0800, Fengguang Wu wrote:
> >> > > On Wed, Sep 26, 2012 at 09:45:43AM -0700, Paul E. McKenney wrote:
> >> > > > On Wed, Sep 26, 2012 at 04:15:01PM +0800, Fengguang Wu wrote:
> > 
> > [ . . . ]
> > 
> >> > > > But could you also please send your .config file and a description of
> >> > > 
> >> > > .config attached.
> >> > > 
> >> > > > the workload you are running?
> >> > > 
> >> > > It's basically the below commands. The exact initrd is not relevant in
> >> > > this case because it's a boot time warning before user space is
> >> > > started. The stalls roughly happen 1 time on every 10 boots.
> >> > 
> >> > Yow!!!
> >> > 
> >> > You have severe cross-CPU time-synchronization problems.  See for
> >> > example the first dmesg, with the relevant part extracted right here.
> >> > One CPU believes that it is about 37 seconds past boot, and the other
> >> > CPU beleives that it is about 137 seconds past boot.  Given that large
> >> > of a time difference, an RCU CPU stall warning is expected behavior.
> >> 
> >> Good spot! Yeah I noticed that huge timestamp gap, however didn't take
> >> it seriously enough..
> >> 
> >> > Get your two CPUs in agreement about what time it is, and I bet that
> >> > the CPU stall warnings will go away.
> >> 
> >> Possibly KVM related? Because the warnings show up in many test boxes
> >> running KVM and so is not likely some hardware specific issue.
> > 
> > I vaguely recall seeing something recently.  But let's ask the KVM and
> > timekeeping guys.
> 
> >From the logs it looks like hpet (why not kvmclock?) is used for the
> clock, it should not generate such drifts since it is a global clock.
> Can you verify current_clocksource on a boot that actually failed (in
> case the clocksource is switched during runtime)?

I've checked out the dmesg that's cited by Paul, attached. Yes it
contains lines

[    4.970051] Switching to clocksource hpet

and then

[    7.250353] Switching to clocksource tsc

And there is no kvm-clock lines. Oh well for this particular kernel:

# CONFIG_KVM_CLOCK is not set

I'm not sure how this happen, maybe some kconfig that CONFIG_KVM_CLOCK
depends on is randconfig'ed to off..

Thanks,
Fengguang

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm_bisect2-inn-42527-2012-09-27-10-38-38-3.6.0-rc7-bisect2-00078-g593d100-21"

[    0.000000] Linux version 3.6.0-rc7-bisect2-00078-g593d100 (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #21 SMP PREEMPT Thu Sep 27 10:17:49 CST 2012
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
[    0.000000] early log buf free: 128472(98%)
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
[    0.000000] free_area_init_node: node 0, pgdat c1980e40, node_mem_map cdd3f200
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
[    0.000000] Memory: 214896k/262136k available (6620k kernel code, 46740k reserved, 3221k data, 532k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff3fe000   ( 748 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc199d000 - 0xc1a22000   ( 532 kB)
[    0.000000]       .data : 0xc1677208 - 0xc199c640   (3221 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1677208   (6620 kB)
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
[    0.000000] tsc: Detected 2693.519 MHz processor
[    0.020001] Calibrating delay loop (skipped), value calculated using timer frequency.. 5387.03 BogoMIPS (lpj=26935190)
[    0.021665] pid_max: default: 32768 minimum: 301
[    0.022454] Security Framework initialized
[    0.030024] Mount-cache hash table entries: 512
[    0.030989] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030989] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030989] tlb_flushall_shift is 0x6
[    0.035261] ACPI: Core revision 20120711
[    0.036626] Getting VERSION: 50014
[    0.037264] Getting VERSION: 50014
[    0.037888] Getting ID: 0
[    0.038437] Getting ID: f000000
[    0.039064] Getting LVT0: 8700
[    0.039653] Getting LVT1: 8400
[    0.040005] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.040887] enabled ExtINT on CPU#0
[    0.042188] ENABLING IO-APIC IRQs
[    0.042808] init IO_APIC IRQs
[    0.043385]  apic 2 pin 0 not connected
[    0.044057] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.045373] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.046697] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.048009] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.049344] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.050013] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.051311] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.052604] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.053897] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.055195] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.056508] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.057838] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.060014] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.061331] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.062641] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.063961]  apic 2 pin 16 not connected
[    0.064628]  apic 2 pin 17 not connected
[    0.065293]  apic 2 pin 18 not connected
[    0.065963]  apic 2 pin 19 not connected
[    0.066625]  apic 2 pin 20 not connected
[    0.067295]  apic 2 pin 21 not connected
[    0.067964]  apic 2 pin 22 not connected
[    0.068649]  apic 2 pin 23 not connected
[    0.069467] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.070002] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.071616] Using local APIC timer interrupts.
[    0.071616] calibrating APIC timer ...
[    0.080000] ... lapic delta = 6250043
[    0.080000] ... PM-Timer delta = 357956
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6250043
[    0.080000] ..... mult: 268437302
[    0.080000] ..... calibration result: 10000068
[    0.080000] ..... CPU clock speed is 2693.5173 MHz.
[    0.080000] ..... host bus clock speed is 1000.0068 MHz.
[    0.080000] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.101044] doing dyndbg params: log_buf_len='8M'
[    0.102404] doing dyndbg params: ignore_loglevel='(null)'
[    0.104056] doing dyndbg params: debug='(null)'
[    0.105486] doing dyndbg params: sched_debug='(null)'
[    0.107054] doing dyndbg params: apic='debug'
[    0.108491] doing dyndbg params: dynamic_printk='(null)'
[    0.110009] doing dyndbg params: sysrq_always_enabled='(null)'
[    0.111700] doing dyndbg params: panic='10'
[    0.113041] doing dyndbg params: prompt_ramdisk='0'
[    0.114529] doing dyndbg params: console='ttyS0,115200'
[    0.116136] doing dyndbg params: console='tty0'
[    0.117565] doing dyndbg params: vga='normal'
[    0.118981] doing dyndbg params: root='/dev/ram0'
[    0.120004] doing dyndbg params: rw='(null)'
[    0.121382] doing dyndbg params: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.130082] smpboot: ++++++++++++++++++++=_---CPU UP  1
[    0.131747] CPU 1 irqstacks, hard=cd886000 soft=cd890000
[    0.133336] smpboot: Booting Node   0, Processors  #1 OK
[    0.135067] smpboot: Setting warm reset code and vector.
[    0.136638] smpboot: 1.
[    0.137615] smpboot: 2.
[    0.138607] smpboot: 3.
[    0.139628] smpboot: Asserting INIT
[    0.140018] smpboot: Waiting for send to finish...
[    0.152320] smpboot: Deasserting INIT
[    0.153730] smpboot: Waiting for send to finish...
[    0.155399] smpboot: #startup loops: 2
[    0.156874] smpboot: Sending STARTUP #1
[    0.158306] smpboot: After apic_write
[    0.030000] Initializing CPU#1
[    0.030000] smpboot: CPU#1 (phys ID: 1) waiting for CALLOUT
[    0.160304] smpboot: Startup point 1
[    0.161607] smpboot: Waiting for send to finish...
[    0.163383] smpboot: Sending STARTUP #2
[    0.164577] smpboot: After apic_write
[    0.166026] smpboot: Startup point 1
[    0.167125] smpboot: Waiting for send to finish...
[    0.168670] smpboot: After Startup
[    0.170003] smpboot: Before Callout 1
[    0.171119] smpboot: After Callout 1
[    0.030000] smpboot: CALLIN, before setup_local_APIC()
[    0.030000] masked ExtINT on CPU#1
[    0.030000] smpboot: Stack at about cd87bfac
[    0.320407] smpboot: CPU1: has booted.
[    0.330000] TSC synchronization [CPU#0 -> CPU#1]: passed
[    0.340040] Brought up 2 CPUs
[    0.340040] KVM setup async PF for cpu 1
[    0.340040] kvm-stealtime: cpu 1, msr dd37700
[    0.343346] smpboot: Boot done
[    0.344362] smpboot: Before bogomips
[    0.345444] smpboot: Total of 2 processors activated (10774.07 BogoMIPS)
[    0.350003] smpboot: Before bogocount - setting activated=1
[    0.351851] CPU0 attaching sched-domain:
[    0.352987]  domain 0: span 0-1 level CPU
[    0.354266]   groups: 0 1
[    0.355500] CPU1 attaching sched-domain:
[    0.356632]  domain 0: span 0-1 level CPU
[    0.357896]   groups: 1 0
[    0.359193] kobject: 'devices' (cd8288cc): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.360015] kobject: 'devices' (cd8288cc): kobject_uevent_env
[    0.361487] kobject: 'devices' (cd8288cc): kobject_uevent_env: attempted to send uevent without kset!
[    0.363924] kobject: 'dev' (cd828940): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.366205] kobject: 'block' (cd8289c0): kobject_add_internal: parent: 'dev', set: '<NULL>'
[    0.370007] kobject: 'char' (cd828a40): kobject_add_internal: parent: 'dev', set: '<NULL>'
[    0.372251] kobject: 'bus' (cd828acc): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.374598] kobject: 'bus' (cd828acc): kobject_uevent_env
[    0.376008] kobject: 'bus' (cd828acc): kobject_uevent_env: attempted to send uevent without kset!
[    0.378360] kobject: 'system' (cd828b4c): kobject_add_internal: parent: 'devices', set: '<NULL>'
[    0.380021] kobject: 'system' (cd828b4c): kobject_uevent_env
[    0.381475] kobject: 'system' (cd828b4c): kobject_uevent_env: attempted to send uevent without kset!
[    0.383889] kobject: 'class' (cd828bcc): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.386220] kobject: 'class' (cd828bcc): kobject_uevent_env
[    0.387661] kobject: 'class' (cd828bcc): kobject_uevent_env: attempted to send uevent without kset!
[    0.390006] kobject: 'firmware' (cd828c40): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.392376] device: 'platform': device_add
[    0.393574] kobject: 'platform' (c19518c8): kobject_add_internal: parent: 'devices', set: 'devices'
[    0.395946] PM: Adding info for No Bus:platform
[    0.397194] kobject: 'platform' (c19518c8): kobject_uevent_env
[    0.398608] kobject: 'platform' (c19518c8): kobject_uevent_env: filter function caused the event to drop!
[    0.400021] kobject: 'platform' (cd82ce0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.402285] kobject: 'platform' (cd82ce0c): kobject_uevent_env
[    0.403759] kobject: 'platform' (cd82ce0c): fill_kobj_path: path = '/bus/platform'
[    0.405899] kobject: 'devices' (cd828f4c): kobject_add_internal: parent: 'platform', set: '<NULL>'
[    0.410006] kobject: 'devices' (cd828f4c): kobject_uevent_env
[    0.411452] kobject: 'devices' (cd828f4c): kobject_uevent_env: filter function caused the event to drop!
[    0.413924] kobject: 'drivers' (cd828fcc): kobject_add_internal: parent: 'platform', set: '<NULL>'
[    0.416331] kobject: 'drivers' (cd828fcc): kobject_uevent_env
[    0.417761] kobject: 'drivers' (cd828fcc): kobject_uevent_env: filter function caused the event to drop!
[    0.420006] bus: 'platform': registered
[    0.421167] kobject: 'cpu' (cd82c80c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.423383] kobject: 'cpu' (cd82c80c): kobject_uevent_env
[    0.424796] kobject: 'cpu' (cd82c80c): fill_kobj_path: path = '/bus/cpu'
[    0.430008] kobject: 'devices' (cd84414c): kobject_add_internal: parent: 'cpu', set: '<NULL>'
[    0.432314] kobject: 'devices' (cd84414c): kobject_uevent_env
[    0.433800] kobject: 'devices' (cd84414c): kobject_uevent_env: filter function caused the event to drop!
[    0.436261] kobject: 'drivers' (cd8441cc): kobject_add_internal: parent: 'cpu', set: '<NULL>'
[    0.438576] kobject: 'drivers' (cd8441cc): kobject_uevent_env
[    0.440004] kobject: 'drivers' (cd8441cc): kobject_uevent_env: filter function caused the event to drop!
[    0.442438] bus: 'cpu': registered
[    0.443507] device: 'cpu': device_add
[    0.444631] kobject: 'cpu' (cd804008): kobject_add_internal: parent: 'system', set: 'devices'
[    0.446905] PM: Adding info for No Bus:cpu
[    0.448048] kobject: 'cpu' (cd804008): kobject_uevent_env
[    0.450004] kobject: 'cpu' (cd804008): kobject_uevent_env: filter function caused the event to drop!
[    0.452477] doing early, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.460049] doing early: hung_task_panic='1'
[    0.461174] doing early: bisect-reboot='(null)'
[    0.462369] doing early: i386-randconfig-b064='(null)'
[    0.463646] doing early: branch='mfd/for-next'
[    0.464860] doing early: dyndbg='+p'
[    0.465926] doing early: log_buf_len='8M'
[    0.467109] doing early: ignore_loglevel='(null)'
[    0.468401] doing early: debug='(null)'
[    0.469513] doing early: sched_debug='(null)'
[    0.470025] doing early: apic='debug'
[    0.471181] doing early: dynamic_printk='(null)'
[    0.472464] doing early: sysrq_always_enabled='(null)'
[    0.473825] doing early: prompt_ramdisk='0'
[    0.475006] doing early: console='ttyS0,115200'
[    0.476274] doing early: console='tty0'
[    0.477433] doing early: vga='normal'
[    0.478551] doing early: root='/dev/ram0'
[    0.480024] doing early: rw='(null)'
[    0.481170] doing early: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.482528] doing core, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.490035] doing core: hung_task_panic='1'
[    0.491262] doing core: bisect-reboot='(null)'
[    0.492522] doing core: i386-randconfig-b064='(null)'
[    0.493867] doing core: branch='mfd/for-next'
[    0.494995] doing core: dyndbg='+p'
[    0.496007] doing core: log_buf_len='8M'
[    0.497093] doing core: ignore_loglevel='(null)'
[    0.498282] doing core: debug='(null)'
[    0.500029] doing core: sched_debug='(null)'
[    0.501150] doing core: apic='debug'
[    0.502157] doing core: dynamic_printk='(null)'
[    0.503322] doing core: sysrq_always_enabled='(null)'
[    0.504645] doing core: prompt_ramdisk='0'
[    0.505826] doing core: console='ttyS0,115200'
[    0.507089] doing core: console='tty0'
[    0.508225] doing core: vga='normal'
[    0.509292] doing core: root='/dev/ram0'
[    0.510024] doing core: rw='(null)'
[    0.511109] doing core: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.512502] kobject: 'kernel' (cd844700): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.514821] kobject: 'power' (cd8449c0): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.517161] kobject: 'debug' (cd844b00): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    0.520008] kobject: 'security' (cd844b80): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    0.522319] xor: automatically using best checksumming function:
[    0.620028]    pIII_sse  :   111.600 MB/sec
[    0.621212] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.622833] device class 'regulator': registering
[    0.624094] kobject: 'regulator' (cd82c70c): kobject_add_internal: parent: 'class', set: 'class'
[    0.626281] kobject: 'regulator' (cd82c70c): kobject_uevent_env
[    0.627649] kobject: 'regulator' (cd82c70c): fill_kobj_path: path = '/class/regulator'
[    0.629666] debugfs: creating file 'regulator'
[    0.630023] debugfs: creating file 'supply_map'
[    0.631293] Registering platform device 'reg-dummy'. Parent at platform
[    0.632886] device: 'reg-dummy': device_add
[    0.634084] kobject: 'reg-dummy' (cd804a10): kobject_add_internal: parent: 'platform', set: 'devices'
[    0.636498] bus: 'platform': add device reg-dummy
[    0.637786] PM: Adding info for platform:reg-dummy
[    0.639032] kobject: 'reg-dummy' (cd804a10): kobject_uevent_env
[    0.640005] kobject: 'reg-dummy' (cd804a10): fill_kobj_path: path = '/devices/platform/reg-dummy'
[    0.642338] bus: 'platform': add driver reg-dummy
[    0.643655] kobject: 'reg-dummy' (cd846cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    0.645999] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.648325] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.650011] device: 'regulator.0': device_add
[    0.651235] kobject: 'regulator' (cd844fc0): kobject_add_internal: parent: 'reg-dummy', set: '(null)'
[    0.653724] kobject: 'regulator.0' (cd804c54): kobject_add_internal: parent: 'regulator', set: 'devices'
[    0.656180] PM: Adding info for No Bus:regulator.0
[    0.657480] kobject: 'regulator.0' (cd804c54): kobject_uevent_env
[    0.660006] kobject: 'regulator.0' (cd804c54): fill_kobj_path: path = '/devices/platform/reg-dummy/regulator/regulator.0'
[    0.662741] dummy: 
[    0.663574] debugfs: creating file 'dummy'
[    0.664797] debugfs: creating file 'use_count'
[    0.666020] debugfs: creating file 'open_count'
[    0.667295] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.668932] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.670007] kobject: 'reg-dummy' (cd846cc0): kobject_uevent_env
[    0.671484] kobject: 'reg-dummy' (cd846cc0): fill_kobj_path: path = '/bus/platform/drivers/reg-dummy'
[    0.674051] NET: Registered protocol family 16
[    0.675280] doing postcore, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.680043] doing postcore: hung_task_panic='1'
[    0.681344] doing postcore: bisect-reboot='(null)'
[    0.682646] doing postcore: i386-randconfig-b064='(null)'
[    0.684051] doing postcore: branch='mfd/for-next'
[    0.690027] doing postcore: dyndbg='+p'
[    0.691194] doing postcore: log_buf_len='8M'
[    0.692412] doing postcore: ignore_loglevel='(null)'
[    0.693773] doing postcore: debug='(null)'
[    0.694989] doing postcore: sched_debug='(null)'
[    0.696277] doing postcore: apic='debug'
[    0.697454] doing postcore: dynamic_printk='(null)'
[    0.698808] doing postcore: sysrq_always_enabled='(null)'
[    0.700034] doing postcore: prompt_ramdisk='0'
[    0.701287] doing postcore: console='ttyS0,115200'
[    0.702621] doing postcore: console='tty0'
[    0.703820] doing postcore: vga='normal'
[    0.705050] doing postcore: root='/dev/ram0'
[    0.706260] doing postcore: rw='(null)'
[    0.707404] doing postcore: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.708859] device class 'bdi': registering
[    0.710005] kobject: 'bdi' (cd84920c): kobject_add_internal: parent: 'class', set: 'class'
[    0.712228] kobject: 'bdi' (cd84920c): kobject_uevent_env
[    0.713626] kobject: 'bdi' (cd84920c): fill_kobj_path: path = '/class/bdi'
[    0.715291] debugfs: creating file 'bdi'
[    0.716426] device class 'pci_bus': registering
[    0.717679] kobject: 'pci_bus' (cd84930c): kobject_add_internal: parent: 'class', set: 'class'
[    0.720006] kobject: 'pci_bus' (cd84930c): kobject_uevent_env
[    0.721432] kobject: 'pci_bus' (cd84930c): fill_kobj_path: path = '/class/pci_bus'
[    0.723560] kobject: 'pci' (cd84940c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.725747] kobject: 'pci' (cd84940c): kobject_uevent_env
[    0.727121] kobject: 'pci' (cd84940c): fill_kobj_path: path = '/bus/pci'
[    0.728720] kobject: 'devices' (cd84884c): kobject_add_internal: parent: 'pci', set: '<NULL>'
[    0.730005] kobject: 'devices' (cd84884c): kobject_uevent_env
[    0.731452] kobject: 'devices' (cd84884c): kobject_uevent_env: filter function caused the event to drop!
[    0.733916] kobject: 'drivers' (cd8488cc): kobject_add_internal: parent: 'pci', set: '<NULL>'
[    0.736187] kobject: 'drivers' (cd8488cc): kobject_uevent_env
[    0.737655] kobject: 'drivers' (cd8488cc): kobject_uevent_env: filter function caused the event to drop!
[    0.740006] bus: 'pci': registered
[    0.741081] device: 'rapidio': device_add
[    0.742209] kobject: 'rapidio' (c19429a8): kobject_add_internal: parent: 'devices', set: 'devices'
[    0.750010] PM: Adding info for No Bus:rapidio
[    0.751225] kobject: 'rapidio' (c19429a8): kobject_uevent_env
[    0.752671] kobject: 'rapidio' (c19429a8): kobject_uevent_env: filter function caused the event to drop!
[    0.755089] kobject: 'rapidio' (cd84950c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.757220] kobject: 'rapidio' (cd84950c): kobject_uevent_env
[    0.758674] kobject: 'rapidio' (cd84950c): fill_kobj_path: path = '/bus/rapidio'
[    0.760008] kobject: 'devices' (cd848c8c): kobject_add_internal: parent: 'rapidio', set: '<NULL>'
[    0.762357] kobject: 'devices' (cd848c8c): kobject_uevent_env
[    0.763815] kobject: 'devices' (cd848c8c): kobject_uevent_env: filter function caused the event to drop!
[    0.766253] kobject: 'drivers' (cd848d0c): kobject_add_internal: parent: 'rapidio', set: '<NULL>'
[    0.768601] kobject: 'drivers' (cd848d0c): kobject_uevent_env
[    0.770004] kobject: 'drivers' (cd848d0c): kobject_uevent_env: filter function caused the event to drop!
[    0.772477] bus: 'rapidio': registered
[    0.773599] device class 'lcd': registering
[    0.774786] kobject: 'lcd' (cd84960c): kobject_add_internal: parent: 'class', set: 'class'
[    0.777027] kobject: 'lcd' (cd84960c): kobject_uevent_env
[    0.778429] kobject: 'lcd' (cd84960c): fill_kobj_path: path = '/class/lcd'
[    0.780006] device class 'backlight': registering
[    0.781284] kobject: 'backlight' (cd84970c): kobject_add_internal: parent: 'class', set: 'class'
[    0.783599] kobject: 'backlight' (cd84970c): kobject_uevent_env
[    0.785063] kobject: 'backlight' (cd84970c): fill_kobj_path: path = '/class/backlight'
[    0.787287] device class 'video_output': registering
[    0.788605] kobject: 'video_output' (cd84980c): kobject_add_internal: parent: 'class', set: 'class'
[    0.790005] kobject: 'video_output' (cd84980c): kobject_uevent_env
[    0.791533] kobject: 'video_output' (cd84980c): fill_kobj_path: path = '/class/video_output'
[    0.793849] device class 'tty': registering
[    0.795043] kobject: 'tty' (cd84990c): kobject_add_internal: parent: 'class', set: 'class'
[    0.797283] kobject: 'tty' (cd84990c): kobject_uevent_env
[    0.800004] kobject: 'tty' (cd84990c): fill_kobj_path: path = '/class/tty'
[    0.801705] device class 'vtconsole': registering
[    0.802970] kobject: 'vtconsole' (cd849a0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.805372] kobject: 'vtconsole' (cd849a0c): kobject_uevent_env
[    0.806874] kobject: 'vtconsole' (cd849a0c): fill_kobj_path: path = '/class/vtconsole'
[    0.809072] device: 'vtcon0': device_add
[    0.810005] kobject: 'virtual' (cd896040): kobject_add_internal: parent: 'devices', set: '<NULL>'
[    0.812318] kobject: 'vtconsole' (cd8960c0): kobject_add_internal: parent: 'virtual', set: '(null)'
[    0.814709] kobject: 'vtcon0' (cd805208): kobject_add_internal: parent: 'vtconsole', set: 'devices'
[    0.817099] PM: Adding info for No Bus:vtcon0
[    0.818331] kobject: 'vtcon0' (cd805208): kobject_uevent_env
[    0.820005] kobject: 'vtcon0' (cd805208): fill_kobj_path: path = '/devices/virtual/vtconsole/vtcon0'
[    0.822407] debugfs: creating file 'wakeup_sources'
[    0.823728] debugfs: creating file 'regmap'
[    0.824953] kobject: 'spi' (cd849b0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.827148] kobject: 'spi' (cd849b0c): kobject_uevent_env
[    0.828522] kobject: 'spi' (cd849b0c): fill_kobj_path: path = '/bus/spi'
[    0.830008] kobject: 'devices' (cd89650c): kobject_add_internal: parent: 'spi', set: '<NULL>'
[    0.832325] kobject: 'devices' (cd89650c): kobject_uevent_env
[    0.833787] kobject: 'devices' (cd89650c): kobject_uevent_env: filter function caused the event to drop!
[    0.836264] kobject: 'drivers' (cd89658c): kobject_add_internal: parent: 'spi', set: '<NULL>'
[    0.838590] kobject: 'drivers' (cd89658c): kobject_uevent_env
[    0.840004] kobject: 'drivers' (cd89658c): kobject_uevent_env: filter function caused the event to drop!
[    0.842481] bus: 'spi': registered
[    0.843533] device class 'spi_master': registering
[    0.844868] kobject: 'spi_master' (cd849c0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.847186] kobject: 'spi_master' (cd849c0c): kobject_uevent_env
[    0.848695] kobject: 'spi_master' (cd849c0c): fill_kobj_path: path = '/class/spi_master'
[    0.850007] kobject: 'i2c' (cd849d0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    0.852221] kobject: 'i2c' (cd849d0c): kobject_uevent_env
[    0.853641] kobject: 'i2c' (cd849d0c): fill_kobj_path: path = '/bus/i2c'
[    0.855243] kobject: 'devices' (cd89674c): kobject_add_internal: parent: 'i2c', set: '<NULL>'
[    0.857556] kobject: 'devices' (cd89674c): kobject_uevent_env
[    0.860004] kobject: 'devices' (cd89674c): kobject_uevent_env: filter function caused the event to drop!
[    0.862467] kobject: 'drivers' (cd8967cc): kobject_add_internal: parent: 'i2c', set: '<NULL>'
[    0.864801] kobject: 'drivers' (cd8967cc): kobject_uevent_env
[    0.866291] kobject: 'drivers' (cd8967cc): kobject_uevent_env: filter function caused the event to drop!
[    0.868771] bus: 'i2c': registered
[    0.870004] bus: 'i2c': add driver dummy
[    0.871185] kobject: 'dummy' (cd897000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    0.873489] kobject: 'dummy' (cd897000): kobject_uevent_env
[    0.874937] kobject: 'dummy' (cd897000): fill_kobj_path: path = '/bus/i2c/drivers/dummy'
[    0.877176] i2c-core: driver [dummy] registered
[    0.878463] doing arch, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.880044] doing arch: hung_task_panic='1'
[    0.881238] doing arch: bisect-reboot='(null)'
[    0.882528] doing arch: i386-randconfig-b064='(null)'
[    0.890026] doing arch: branch='mfd/for-next'
[    0.891251] doing arch: dyndbg='+p'
[    0.892357] doing arch: log_buf_len='8M'
[    0.893517] doing arch: ignore_loglevel='(null)'
[    0.894838] doing arch: debug='(null)'
[    0.895954] doing arch: sched_debug='(null)'
[    0.897190] doing arch: apic='debug'
[    0.898301] doing arch: dynamic_printk='(null)'
[    0.900034] doing arch: sysrq_always_enabled='(null)'
[    0.901402] doing arch: prompt_ramdisk='0'
[    0.902601] doing arch: console='ttyS0,115200'
[    0.903826] doing arch: console='tty0'
[    0.904996] doing arch: vga='normal'
[    0.906086] doing arch: root='/dev/ram0'
[    0.907262] doing arch: rw='(null)'
[    0.908308] doing arch: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.910036] debugfs: creating file 'x86'
[    0.911171] ACPI: bus type pci registered
[    0.912354] device class 'dma': registering
[    0.913524] kobject: 'dma' (cd849e0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.915791] kobject: 'dma' (cd849e0c): kobject_uevent_env
[    0.917150] kobject: 'dma' (cd849e0c): fill_kobj_path: path = '/class/dma'
[    0.918769] device class 'dmi': registering
[    0.919981] kobject: 'dmi' (cd849f0c): kobject_add_internal: parent: 'class', set: 'class'
[    0.920006] kobject: 'dmi' (cd849f0c): kobject_uevent_env
[    0.921417] kobject: 'dmi' (cd849f0c): fill_kobj_path: path = '/class/dmi'
[    0.923092] device: 'id': device_add
[    0.924169] kobject: 'dmi' (cd896a40): kobject_add_internal: parent: 'virtual', set: '(null)'
[    0.926518] kobject: 'id' (cd805408): kobject_add_internal: parent: 'dmi', set: 'devices'
[    0.930027] PM: Adding info for No Bus:id
[    0.931185] kobject: 'id' (cd805408): kobject_uevent_env
[    0.932575] kobject: 'id' (cd805408): fill_kobj_path: path = '/devices/virtual/dmi/id'
[    0.934983] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.936550] PCI: Using configuration type 1 for base access
[    0.937963] doing subsys, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    0.940035] doing subsys: hung_task_panic='1'
[    0.941293] doing subsys: bisect-reboot='(null)'
[    0.942589] doing subsys: i386-randconfig-b064='(null)'
[    0.950025] doing subsys: branch='mfd/for-next'
[    0.951311] doing subsys: dyndbg='+p'
[    0.952436] doing subsys: log_buf_len='8M'
[    0.953641] doing subsys: ignore_loglevel='(null)'
[    0.954992] doing subsys: debug='(null)'
[    0.956116] doing subsys: sched_debug='(null)'
[    0.957391] doing subsys: apic='debug'
[    0.958549] doing subsys: dynamic_printk='(null)'
[    0.960036] doing subsys: sysrq_always_enabled='(null)'
[    0.961416] doing subsys: prompt_ramdisk='0'
[    0.962664] doing subsys: console='ttyS0,115200'
[    0.963958] doing subsys: console='tty0'
[    0.965171] doing subsys: vga='normal'
[    0.966333] doing subsys: root='/dev/ram0'
[    0.967557] doing subsys: rw='(null)'
[    0.968645] doing subsys: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    0.970007] device: 'cpu0': device_add
[    0.971098] kobject: 'cpu0' (cdd2c610): kobject_add_internal: parent: 'cpu', set: 'devices'
[    0.973362] bus: 'cpu': add device cpu0
[    0.974513] PM: Adding info for cpu:cpu0
[    0.979326] kobject: 'cpu0' (cdd2c610): kobject_uevent_env
[    0.980005] kobject: 'cpu0' (cdd2c610): fill_kobj_path: path = '/devices/system/cpu/cpu0'
[    0.982295] device: 'cpu1': device_add
[    0.983374] kobject: 'cpu1' (cdd36610): kobject_add_internal: parent: 'cpu', set: 'devices'
[    0.985630] bus: 'cpu': add device cpu1
[    0.986778] PM: Adding info for cpu:cpu1
[    0.987898] kobject: 'cpu1' (cdd36610): kobject_uevent_env
[    0.990005] kobject: 'cpu1' (cdd36610): fill_kobj_path: path = '/devices/system/cpu/cpu1'
[    0.992276] kobject: 'module' (cd8a464c): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    0.994671] kobject: 'module' (cd8a464c): kobject_uevent_env
[    0.996088] kobject: 'module' (cd8a464c): kobject_uevent_env: attempted to send uevent without kset!
[    0.998523] kobject: 'configfs' (cd8a46c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.000005] kobject: 'configfs' (cd8a46c0): kobject_uevent_env
[    1.001482] kobject: 'configfs' (cd8a46c0): fill_kobj_path: path = '/module/configfs'
[    1.003708] kobject: 'xz_dec' (cd8a4780): kobject_add_internal: parent: 'module', set: 'module'
[    1.005983] kobject: 'xz_dec' (cd8a4780): kobject_uevent_env
[    1.007445] kobject: 'xz_dec' (cd8a4780): fill_kobj_path: path = '/module/xz_dec'
[    1.010007] kobject: 'vmlfb' (cd8a4840): kobject_add_internal: parent: 'module', set: 'module'
[    1.012332] kobject: 'vmlfb' (cd8a4840): kobject_uevent_env
[    1.013771] kobject: 'vmlfb' (cd8a4840): fill_kobj_path: path = '/module/vmlfb'
[    1.015864] kobject: 'hangcheck_timer' (cd8a4900): kobject_add_internal: parent: 'module', set: 'module'
[    1.018327] kobject: 'hangcheck_timer' (cd8a4900): kobject_uevent_env
[    1.020005] kobject: 'hangcheck_timer' (cd8a4900): fill_kobj_path: path = '/module/hangcheck_timer'
[    1.022368] kobject: 'hpilo' (cd8a49c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.024690] kobject: 'hpilo' (cd8a49c0): kobject_uevent_env
[    1.026096] kobject: 'hpilo' (cd8a49c0): fill_kobj_path: path = '/module/hpilo'
[    1.028179] kobject: 'isl29003' (cd8a4a80): kobject_add_internal: parent: 'module', set: 'module'
[    1.030006] kobject: 'isl29003' (cd8a4a80): kobject_uevent_env
[    1.031471] kobject: 'isl29003' (cd8a4a80): fill_kobj_path: path = '/module/isl29003'
[    1.033712] kobject: 'scsi_transport_iscsi' (cd8a4b40): kobject_add_internal: parent: 'module', set: 'module'
[    1.036234] kobject: 'scsi_transport_iscsi' (cd8a4b40): kobject_uevent_env
[    1.037865] kobject: 'scsi_transport_iscsi' (cd8a4b40): fill_kobj_path: path = '/module/scsi_transport_iscsi'
[    1.040007] kobject: 'libata' (cd8a4c00): kobject_add_internal: parent: 'module', set: 'module'
[    1.042370] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.043842] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.045930] kobject: 'ahci' (cd8a4cc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.050006] kobject: 'ahci' (cd8a4cc0): kobject_uevent_env
[    1.051365] kobject: 'ahci' (cd8a4cc0): fill_kobj_path: path = '/module/ahci'
[    1.053070] kobject: 'sata_inic162x' (cd8a4d80): kobject_add_internal: parent: 'module', set: 'module'
[    1.055502] kobject: 'sata_inic162x' (cd8a4d80): kobject_uevent_env
[    1.057033] kobject: 'sata_inic162x' (cd8a4d80): fill_kobj_path: path = '/module/sata_inic162x'
[    1.059354] kobject: 'atl1' (cd8a4e40): kobject_add_internal: parent: 'module', set: 'module'
[    1.060006] kobject: 'atl1' (cd8a4e40): kobject_uevent_env
[    1.061438] kobject: 'atl1' (cd8a4e40): fill_kobj_path: path = '/module/atl1'
[    1.063147] kobject: 'bnx2' (cd8a4f00): kobject_add_internal: parent: 'module', set: 'module'
[    1.065479] kobject: 'bnx2' (cd8a4f00): kobject_uevent_env
[    1.066865] kobject: 'bnx2' (cd8a4f00): fill_kobj_path: path = '/module/bnx2'
[    1.070009] kobject: 's2io' (cd8a4fc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.072317] kobject: 's2io' (cd8a4fc0): kobject_uevent_env
[    1.073740] kobject: 's2io' (cd8a4fc0): fill_kobj_path: path = '/module/s2io'
[    1.075470] kobject: 'asix' (cd8a5080): kobject_add_internal: parent: 'module', set: 'module'
[    1.077811] kobject: 'asix' (cd8a5080): kobject_uevent_env
[    1.079198] kobject: 'asix' (cd8a5080): fill_kobj_path: path = '/module/asix'
[    1.080007] kobject: 'uio_pci_generic' (cd8a5140): kobject_add_internal: parent: 'module', set: 'module'
[    1.082479] kobject: 'uio_pci_generic' (cd8a5140): kobject_uevent_env
[    1.084067] kobject: 'uio_pci_generic' (cd8a5140): fill_kobj_path: path = '/module/uio_pci_generic'
[    1.086439] kobject: 'ldusb' (cd8a5200): kobject_add_internal: parent: 'module', set: 'module'
[    1.090006] kobject: 'ldusb' (cd8a5200): kobject_uevent_env
[    1.091435] kobject: 'ldusb' (cd8a5200): fill_kobj_path: path = '/module/ldusb'
[    1.093541] kobject: 'usbatm' (cd8a52c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.095933] kobject: 'usbatm' (cd8a52c0): kobject_uevent_env
[    1.097362] kobject: 'usbatm' (cd8a52c0): fill_kobj_path: path = '/module/usbatm'
[    1.099487] kobject: 'input_polldev' (cd8a5380): kobject_add_internal: parent: 'module', set: 'module'
[    1.100006] kobject: 'input_polldev' (cd8a5380): kobject_uevent_env
[    1.101572] kobject: 'input_polldev' (cd8a5380): fill_kobj_path: path = '/module/input_polldev'
[    1.103950] kobject: 'sparse_keymap' (cd8a5440): kobject_add_internal: parent: 'module', set: 'module'
[    1.106385] kobject: 'sparse_keymap' (cd8a5440): kobject_uevent_env
[    1.110005] kobject: 'sparse_keymap' (cd8a5440): fill_kobj_path: path = '/module/sparse_keymap'
[    1.112353] kobject: 'apanel' (cd8a5500): kobject_add_internal: parent: 'module', set: 'module'
[    1.114704] kobject: 'apanel' (cd8a5500): kobject_uevent_env
[    1.116148] kobject: 'apanel' (cd8a5500): fill_kobj_path: path = '/module/apanel'
[    1.118246] kobject: 'ati_remote2' (cd8a55c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.120006] kobject: 'ati_remote2' (cd8a55c0): kobject_uevent_env
[    1.121506] kobject: 'ati_remote2' (cd8a55c0): fill_kobj_path: path = '/module/ati_remote2'
[    1.123761] kobject: 'uinput' (cd8a5680): kobject_add_internal: parent: 'module', set: 'module'
[    1.126139] kobject: 'uinput' (cd8a5680): kobject_uevent_env
[    1.127579] kobject: 'uinput' (cd8a5680): fill_kobj_path: path = '/module/uinput'
[    1.130007] kobject: 'i2o_core' (cd8a5740): kobject_add_internal: parent: 'module', set: 'module'
[    1.132390] kobject: 'i2o_core' (cd8a5740): kobject_uevent_env
[    1.133837] kobject: 'i2o_core' (cd8a5740): fill_kobj_path: path = '/module/i2o_core'
[    1.136104] kobject: 'i2o_config' (cd8a5800): kobject_add_internal: parent: 'module', set: 'module'
[    1.138501] kobject: 'i2o_config' (cd8a5800): kobject_uevent_env
[    1.140005] kobject: 'i2o_config' (cd8a5800): fill_kobj_path: path = '/module/i2o_config'
[    1.142245] kobject: 'i2o_scsi' (cd8a58c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.144612] kobject: 'i2o_scsi' (cd8a58c0): kobject_uevent_env
[    1.146113] kobject: 'i2o_scsi' (cd8a58c0): fill_kobj_path: path = '/module/i2o_scsi'
[    1.148309] kobject: 'i2o_proc' (cd8a5980): kobject_add_internal: parent: 'module', set: 'module'
[    1.150006] kobject: 'i2o_proc' (cd8a5980): kobject_uevent_env
[    1.151508] kobject: 'i2o_proc' (cd8a5980): fill_kobj_path: path = '/module/i2o_proc'
[    1.153714] kobject: 'i2c_intel_mid' (cd8a5a40): kobject_add_internal: parent: 'module', set: 'module'
[    1.156135] kobject: 'i2c_intel_mid' (cd8a5a40): kobject_uevent_env
[    1.157680] kobject: 'i2c_intel_mid' (cd8a5a40): fill_kobj_path: path = '/module/i2c_intel_mid'
[    1.160006] kobject: 'hpwdt' (cd8a5b00): kobject_add_internal: parent: 'module', set: 'module'
[    1.162337] kobject: 'hpwdt' (cd8a5b00): kobject_uevent_env
[    1.163768] kobject: 'hpwdt' (cd8a5b00): fill_kobj_path: path = '/module/hpwdt'
[    1.165883] kobject: 'sbc8360' (cd8a5bc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.168199] kobject: 'sbc8360' (cd8a5bc0): kobject_uevent_env
[    1.170005] kobject: 'sbc8360' (cd8a5bc0): fill_kobj_path: path = '/module/sbc8360'
[    1.172119] kobject: 'hci_uart' (cd8a5c80): kobject_add_internal: parent: 'module', set: 'module'
[    1.174340] kobject: 'hci_uart' (cd8a5c80): kobject_uevent_env
[    1.175826] kobject: 'hci_uart' (cd8a5c80): fill_kobj_path: path = '/module/hci_uart'
[    1.178005] kobject: 'btusb' (cd8a5d40): kobject_add_internal: parent: 'module', set: 'module'
[    1.180006] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    1.181354] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    1.183300] kobject: 'btsdio' (cd8a5e00): kobject_add_internal: parent: 'module', set: 'module'
[    1.185665] kobject: 'btsdio' (cd8a5e00): kobject_uevent_env
[    1.187117] kobject: 'btsdio' (cd8a5e00): fill_kobj_path: path = '/module/btsdio'
[    1.190007] kobject: 'dell_rbu' (cd8a5ec0): kobject_add_internal: parent: 'module', set: 'module'
[    1.192368] kobject: 'dell_rbu' (cd8a5ec0): kobject_uevent_env
[    1.193781] kobject: 'dell_rbu' (cd8a5ec0): fill_kobj_path: path = '/module/dell_rbu'
[    1.195861] kobject: 'dcdbas' (cd8a5f80): kobject_add_internal: parent: 'module', set: 'module'
[    1.198002] kobject: 'dcdbas' (cd8a5f80): kobject_uevent_env
[    1.199346] kobject: 'dcdbas' (cd8a5f80): fill_kobj_path: path = '/module/dcdbas'
[    1.200008] kobject: 'pktgen' (cd8a7040): kobject_add_internal: parent: 'module', set: 'module'
[    1.202371] kobject: 'pktgen' (cd8a7040): kobject_uevent_env
[    1.203825] kobject: 'pktgen' (cd8a7040): fill_kobj_path: path = '/module/pktgen'
[    1.210007] kobject: 'bridge' (cd8a7100): kobject_add_internal: parent: 'module', set: 'module'
[    1.212353] kobject: 'bridge' (cd8a7100): kobject_uevent_env
[    1.213809] kobject: 'bridge' (cd8a7100): fill_kobj_path: path = '/module/bridge'
[    1.215936] kobject: 'bluetooth' (cd8a71c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.218292] kobject: 'bluetooth' (cd8a71c0): kobject_uevent_env
[    1.220005] kobject: 'bluetooth' (cd8a71c0): fill_kobj_path: path = '/module/bluetooth'
[    1.222209] kobject: 'kernel' (cd8a7280): kobject_add_internal: parent: 'module', set: 'module'
[    1.224518] kobject: 'kernel' (cd8a7280): kobject_uevent_env
[    1.225938] kobject: 'kernel' (cd8a7280): fill_kobj_path: path = '/module/kernel'
[    1.228034] kobject: 'kvm' (cd8a73c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.230007] kobject: 'kvm' (cd8a73c0): kobject_uevent_env
[    1.231383] kobject: 'kvm' (cd8a73c0): fill_kobj_path: path = '/module/kvm'
[    1.233069] kobject: 'kvm' (cd8a73c0): kobject_uevent_env
[    1.234453] kobject: 'kvm' (cd8a73c0): fill_kobj_path: path = '/module/kvm'
[    1.236111] kobject: 'kvm' (cd8a73c0): kobject_uevent_env
[    1.237524] kobject: 'kvm' (cd8a73c0): fill_kobj_path: path = '/module/kvm'
[    1.240007] kobject: 'kvm_intel' (cd8a7540): kobject_add_internal: parent: 'module', set: 'module'
[    1.242192] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.243556] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.245739] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.247234] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.249451] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.250005] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.252238] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.253763] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.255944] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.257392] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.260022] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.261432] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.263486] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.264932] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.267156] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.268626] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.270015] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.271485] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.273690] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.275068] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.277094] kobject: 'kvm_intel' (cd8a7540): kobject_uevent_env
[    1.280005] kobject: 'kvm_intel' (cd8a7540): fill_kobj_path: path = '/module/kvm_intel'
[    1.282040] kobject: 'apm' (cd8a7900): kobject_add_internal: parent: 'module', set: 'module'
[    1.284122] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.285550] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.287227] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.288617] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.290011] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.291422] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.293078] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.294490] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.296206] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.297569] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.299235] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.300005] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.301657] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.303085] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.304749] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.306136] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.307817] kobject: 'apm' (cd8a7900): kobject_uevent_env
[    1.310005] kobject: 'apm' (cd8a7900): fill_kobj_path: path = '/module/apm'
[    1.311651] kobject: 'kernel' (cd8a7280): kobject_uevent_env
[    1.313045] kobject: 'kernel' (cd8a7280): fill_kobj_path: path = '/module/kernel'
[    1.315102] kobject: 'kernel' (cd8a7280): kobject_uevent_env
[    1.316514] kobject: 'kernel' (cd8a7280): fill_kobj_path: path = '/module/kernel'
[    1.318625] kobject: 'printk' (cd8a7c80): kobject_add_internal: parent: 'module', set: 'module'
[    1.320007] kobject: 'printk' (cd8a7c80): kobject_uevent_env
[    1.321331] kobject: 'printk' (cd8a7c80): fill_kobj_path: path = '/module/printk'
[    1.323328] kobject: 'printk' (cd8a7c80): kobject_uevent_env
[    1.324796] kobject: 'printk' (cd8a7c80): fill_kobj_path: path = '/module/printk'
[    1.326927] kobject: 'printk' (cd8a7c80): kobject_uevent_env
[    1.328355] kobject: 'printk' (cd8a7c80): fill_kobj_path: path = '/module/printk'
[    1.330011] kobject: 'printk' (cd8a7c80): kobject_uevent_env
[    1.331457] kobject: 'printk' (cd8a7c80): fill_kobj_path: path = '/module/printk'
[    1.333608] kobject: 'spurious' (cd8a7e40): kobject_add_internal: parent: 'module', set: 'module'
[    1.335994] kobject: 'spurious' (cd8a7e40): kobject_uevent_env
[    1.337425] kobject: 'spurious' (cd8a7e40): fill_kobj_path: path = '/module/spurious'
[    1.340010] kobject: 'spurious' (cd8a7e40): kobject_uevent_env
[    1.341375] kobject: 'spurious' (cd8a7e40): fill_kobj_path: path = '/module/spurious'
[    1.343389] kobject: 'rcutorture' (cd8a7f80): kobject_add_internal: parent: 'module', set: 'module'
[    1.345826] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.347315] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.350014] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.351556] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.353838] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.355333] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.357581] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.360006] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.362235] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.363781] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.366003] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.367459] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.370015] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.371534] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.373723] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.375252] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.377470] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.378992] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.380016] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.381555] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.383713] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.385155] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.387356] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.390005] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.392248] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.393714] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.396003] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.397479] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.400022] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.401464] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.403752] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.405224] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.407441] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.408925] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.410022] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.411588] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.413894] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.415359] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.417590] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.420006] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.422231] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.423683] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.425939] kobject: 'rcutorture' (cd8a7f80): kobject_uevent_env
[    1.427430] kobject: 'rcutorture' (cd8a7f80): fill_kobj_path: path = '/module/rcutorture'
[    1.430009] kobject: 'rcutree' (cd8a95c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.432349] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.433770] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.435870] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.440005] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.442116] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.443609] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.445755] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.447220] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.450012] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.451440] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.453607] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.455021] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.457213] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.458626] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.460015] kobject: 'rcutree' (cd8a95c0): kobject_uevent_env
[    1.461486] kobject: 'rcutree' (cd8a95c0): fill_kobj_path: path = '/module/rcutree'
[    1.463584] kobject: 'block' (cd8a98c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.465996] kobject: 'block' (cd8a98c0): kobject_uevent_env
[    1.467437] kobject: 'block' (cd8a98c0): fill_kobj_path: path = '/module/block'
[    1.470009] kobject: 'dynamic_debug' (cd8a9a00): kobject_add_internal: parent: 'module', set: 'module'
[    1.472405] kobject: 'dynamic_debug' (cd8a9a00): kobject_uevent_env
[    1.473952] kobject: 'dynamic_debug' (cd8a9a00): fill_kobj_path: path = '/module/dynamic_debug'
[    1.476222] kobject: 'pci_hotplug' (cd8a9b40): kobject_add_internal: parent: 'module', set: 'module'
[    1.478556] kobject: 'pci_hotplug' (cd8a9b40): kobject_uevent_env
[    1.480005] kobject: 'pci_hotplug' (cd8a9b40): fill_kobj_path: path = '/module/pci_hotplug'
[    1.482265] kobject: 'pci_hotplug' (cd8a9b40): kobject_uevent_env
[    1.483820] kobject: 'pci_hotplug' (cd8a9b40): fill_kobj_path: path = '/module/pci_hotplug'
[    1.486039] kobject: 'cpqphp' (cd8a9c80): kobject_add_internal: parent: 'module', set: 'module'
[    1.488357] kobject: 'cpqphp' (cd8a9c80): kobject_uevent_env
[    1.490005] kobject: 'cpqphp' (cd8a9c80): fill_kobj_path: path = '/module/cpqphp'
[    1.492126] kobject: 'cpqphp' (cd8a9c80): kobject_uevent_env
[    1.493533] kobject: 'cpqphp' (cd8a9c80): fill_kobj_path: path = '/module/cpqphp'
[    1.495609] kobject: 'shpchp' (cd8a9dc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.497933] kobject: 'shpchp' (cd8a9dc0): kobject_uevent_env
[    1.499401] kobject: 'shpchp' (cd8a9dc0): fill_kobj_path: path = '/module/shpchp'
[    1.500012] kobject: 'shpchp' (cd8a9dc0): kobject_uevent_env
[    1.501418] kobject: 'shpchp' (cd8a9dc0): fill_kobj_path: path = '/module/shpchp'
[    1.503563] kobject: 'shpchp' (cd8a9dc0): kobject_uevent_env
[    1.504981] kobject: 'shpchp' (cd8a9dc0): fill_kobj_path: path = '/module/shpchp'
[    1.507079] kobject: 'vt8623fb' (cd8a9f40): kobject_add_internal: parent: 'module', set: 'module'
[    1.510018] kobject: 'vt8623fb' (cd8a9f40): kobject_uevent_env
[    1.511435] kobject: 'vt8623fb' (cd8a9f40): fill_kobj_path: path = '/module/vt8623fb'
[    1.513647] kobject: 'vt8623fb' (cd8a9f40): kobject_uevent_env
[    1.515098] kobject: 'vt8623fb' (cd8a9f40): fill_kobj_path: path = '/module/vt8623fb'
[    1.517243] kobject: 'acpi' (cd8aa0c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.520008] kobject: 'acpi' (cd8aa0c0): kobject_uevent_env
[    1.521506] kobject: 'acpi' (cd8aa0c0): fill_kobj_path: path = '/module/acpi'
[    1.523239] kobject: 'acpi' (cd8aa0c0): kobject_uevent_env
[    1.524656] kobject: 'acpi' (cd8aa0c0): fill_kobj_path: path = '/module/acpi'
[    1.526331] kobject: 'acpi' (cd8aa0c0): kobject_uevent_env
[    1.527682] kobject: 'acpi' (cd8aa0c0): fill_kobj_path: path = '/module/acpi'
[    1.530008] kobject: 'video' (cd8aa240): kobject_add_internal: parent: 'module', set: 'module'
[    1.532202] kobject: 'video' (cd8aa240): kobject_uevent_env
[    1.533581] kobject: 'video' (cd8aa240): fill_kobj_path: path = '/module/video'
[    1.535584] kobject: 'video' (cd8aa240): kobject_uevent_env
[    1.537063] kobject: 'video' (cd8aa240): fill_kobj_path: path = '/module/video'
[    1.539176] kobject: 'video' (cd8aa240): kobject_uevent_env
[    1.540005] kobject: 'video' (cd8aa240): fill_kobj_path: path = '/module/video'
[    1.542116] kobject: 'processor' (cd8aa3c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.544420] kobject: 'processor' (cd8aa3c0): kobject_uevent_env
[    1.545931] kobject: 'processor' (cd8aa3c0): fill_kobj_path: path = '/module/processor'
[    1.548109] kobject: 'processor' (cd8aa3c0): kobject_uevent_env
[    1.550005] kobject: 'processor' (cd8aa3c0): fill_kobj_path: path = '/module/processor'
[    1.552182] kobject: 'thermal' (cd8aa500): kobject_add_internal: parent: 'module', set: 'module'
[    1.554539] kobject: 'thermal' (cd8aa500): kobject_uevent_env
[    1.555971] kobject: 'thermal' (cd8aa500): fill_kobj_path: path = '/module/thermal'
[    1.558145] kobject: 'thermal' (cd8aa500): kobject_uevent_env
[    1.559560] kobject: 'thermal' (cd8aa500): fill_kobj_path: path = '/module/thermal'
[    1.560012] kobject: 'thermal' (cd8aa500): kobject_uevent_env
[    1.561442] kobject: 'thermal' (cd8aa500): fill_kobj_path: path = '/module/thermal'
[    1.563622] kobject: 'thermal' (cd8aa500): kobject_uevent_env
[    1.565021] kobject: 'thermal' (cd8aa500): fill_kobj_path: path = '/module/thermal'
[    1.567102] kobject: 'battery' (cd8aa6c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.570007] kobject: 'battery' (cd8aa6c0): kobject_uevent_env
[    1.571477] kobject: 'battery' (cd8aa6c0): fill_kobj_path: path = '/module/battery'
[    1.573688] kobject: 'pnp' (cd8aa800): kobject_add_internal: parent: 'module', set: 'module'
[    1.575937] kobject: 'pnp' (cd8aa800): kobject_uevent_env
[    1.577323] kobject: 'pnp' (cd8aa800): fill_kobj_path: path = '/module/pnp'
[    1.580007] kobject: 'pch_dma' (cd8aa940): kobject_add_internal: parent: 'module', set: 'module'
[    1.582319] kobject: 'pch_dma' (cd8aa940): kobject_uevent_env
[    1.583796] kobject: 'pch_dma' (cd8aa940): fill_kobj_path: path = '/module/pch_dma'
[    1.585906] kobject: 'keyboard' (cd8aaa80): kobject_add_internal: parent: 'module', set: 'module'
[    1.588258] kobject: 'keyboard' (cd8aaa80): kobject_uevent_env
[    1.590006] kobject: 'keyboard' (cd8aaa80): fill_kobj_path: path = '/module/keyboard'
[    1.592112] kobject: 'keyboard' (cd8aaa80): kobject_uevent_env
[    1.593546] kobject: 'keyboard' (cd8aaa80): fill_kobj_path: path = '/module/keyboard'
[    1.595652] kobject: 'vt' (cd8aabc0): kobject_add_internal: parent: 'module', set: 'module'
[    1.598086] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.599434] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.600012] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.601409] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.603113] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.604413] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.606082] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.607342] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.610012] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.611370] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.613021] kobject: 'kernel' (cd8a7280): kobject_uevent_env
[    1.614452] kobject: 'kernel' (cd8a7280): fill_kobj_path: path = '/module/kernel'
[    1.616538] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.617900] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.619470] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.620005] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.621601] kobject: 'vt' (cd8aabc0): kobject_uevent_env
[    1.622941] kobject: 'vt' (cd8aabc0): fill_kobj_path: path = '/module/vt'
[    1.624536] kobject: '8250' (cd8a7300): kobject_add_internal: parent: 'module', set: 'module'
[    1.626753] kobject: '8250' (cd8a7300): kobject_uevent_env
[    1.628193] kobject: '8250' (cd8a7300): fill_kobj_path: path = '/module/8250'
[    1.630010] kobject: '8250' (cd8a7300): kobject_uevent_env
[    1.631394] kobject: '8250' (cd8a7300): fill_kobj_path: path = '/module/8250'
[    1.633103] kobject: '8250' (cd8a7300): kobject_uevent_env
[    1.634532] kobject: '8250' (cd8a7300): fill_kobj_path: path = '/module/8250'
[    1.636202] kobject: 'pch_uart' (cd8ab040): kobject_add_internal: parent: 'module', set: 'module'
[    1.638547] kobject: 'pch_uart' (cd8ab040): kobject_uevent_env
[    1.640006] kobject: 'pch_uart' (cd8ab040): fill_kobj_path: path = '/module/pch_uart'
[    1.642226] kobject: 'pch_uart' (cd8ab040): kobject_uevent_env
[    1.643664] kobject: 'pch_uart' (cd8ab040): fill_kobj_path: path = '/module/pch_uart'
[    1.645825] kobject: 'i8k' (cd8ab180): kobject_add_internal: parent: 'module', set: 'module'
[    1.648094] kobject: 'i8k' (cd8ab180): kobject_uevent_env
[    1.650006] kobject: 'i8k' (cd8ab180): fill_kobj_path: path = '/module/i8k'
[    1.651649] kobject: 'drm' (cd8ab2c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.653907] kobject: 'drm' (cd8ab2c0): kobject_uevent_env
[    1.655305] kobject: 'drm' (cd8ab2c0): fill_kobj_path: path = '/module/drm'
[    1.656894] kobject: 'drm' (cd8ab2c0): kobject_uevent_env
[    1.660005] kobject: 'drm' (cd8ab2c0): fill_kobj_path: path = '/module/drm'
[    1.661590] kobject: 'drm' (cd8ab2c0): kobject_uevent_env
[    1.662969] kobject: 'drm' (cd8ab2c0): fill_kobj_path: path = '/module/drm'
[    1.664554] kobject: 'drm' (cd8ab2c0): kobject_uevent_env
[    1.665963] kobject: 'drm' (cd8ab2c0): fill_kobj_path: path = '/module/drm'
[    1.667638] kobject: 'devres' (cd8ab480): kobject_add_internal: parent: 'module', set: 'module'
[    1.670008] kobject: 'devres' (cd8ab480): kobject_uevent_env
[    1.671469] kobject: 'devres' (cd8ab480): fill_kobj_path: path = '/module/devres'
[    1.673560] kobject: 'lkdtm' (cd8ab5c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.675862] kobject: 'lkdtm' (cd8ab5c0): kobject_uevent_env
[    1.677262] kobject: 'lkdtm' (cd8ab5c0): fill_kobj_path: path = '/module/lkdtm'
[    1.680012] kobject: 'lkdtm' (cd8ab5c0): kobject_uevent_env
[    1.681383] kobject: 'lkdtm' (cd8ab5c0): fill_kobj_path: path = '/module/lkdtm'
[    1.683521] kobject: 'lkdtm' (cd8ab5c0): kobject_uevent_env
[    1.684886] kobject: 'lkdtm' (cd8ab5c0): fill_kobj_path: path = '/module/lkdtm'
[    1.686960] kobject: 'lkdtm' (cd8ab5c0): kobject_uevent_env
[    1.688382] kobject: 'lkdtm' (cd8ab5c0): fill_kobj_path: path = '/module/lkdtm'
[    1.690008] kobject: 'cs5535_mfgpt' (cd8ab780): kobject_add_internal: parent: 'module', set: 'module'
[    1.692385] kobject: 'cs5535_mfgpt' (cd8ab780): kobject_uevent_env
[    1.693913] kobject: 'cs5535_mfgpt' (cd8ab780): fill_kobj_path: path = '/module/cs5535_mfgpt'
[    1.696138] kobject: 'hpilo' (cd8a49c0): kobject_uevent_env
[    1.697581] kobject: 'hpilo' (cd8a49c0): fill_kobj_path: path = '/module/hpilo'
[    1.700009] kobject: 'janz_cmodio' (cd8ab980): kobject_add_internal: parent: 'module', set: 'module'
[    1.702322] kobject: 'janz_cmodio' (cd8ab980): kobject_uevent_env
[    1.703896] kobject: 'janz_cmodio' (cd8ab980): fill_kobj_path: path = '/module/janz_cmodio'
[    1.706281] kobject: 'cs5536' (cd8abac0): kobject_add_internal: parent: 'module', set: 'module'
[    1.710009] kobject: 'cs5536' (cd8abac0): kobject_uevent_env
[    1.711481] kobject: 'cs5536' (cd8abac0): fill_kobj_path: path = '/module/cs5536'
[    1.713547] kobject: 'it821x' (cd8abc00): kobject_add_internal: parent: 'module', set: 'module'
[    1.715903] kobject: 'it821x' (cd8abc00): kobject_uevent_env
[    1.717388] kobject: 'it821x' (cd8abc00): fill_kobj_path: path = '/module/it821x'
[    1.719623] kobject: 'scsi_mod' (cd8abd40): kobject_add_internal: parent: 'module', set: 'module'
[    1.720008] kobject: 'scsi_mod' (cd8abd40): kobject_uevent_env
[    1.721426] kobject: 'scsi_mod' (cd8abd40): fill_kobj_path: path = '/module/scsi_mod'
[    1.723573] kobject: 'scsi_mod' (cd8abd40): kobject_uevent_env
[    1.725074] kobject: 'scsi_mod' (cd8abd40): fill_kobj_path: path = '/module/scsi_mod'
[    1.727224] kobject: 'scsi_mod' (cd8abd40): kobject_uevent_env
[    1.730006] kobject: 'scsi_mod' (cd8abd40): fill_kobj_path: path = '/module/scsi_mod'
[    1.732145] kobject: 'scsi_mod' (cd8abd40): kobject_uevent_env
[    1.733600] kobject: 'scsi_mod' (cd8abd40): fill_kobj_path: path = '/module/scsi_mod'
[    1.735802] kobject: 'scsi_mod' (cd8abd40): kobject_uevent_env
[    1.737269] kobject: 'scsi_mod' (cd8abd40): fill_kobj_path: path = '/module/scsi_mod'
[    1.740015] kobject: 'scsi_mod' (cd8abd40): kobject_uevent_env
[    1.741442] kobject: 'scsi_mod' (cd8abd40): fill_kobj_path: path = '/module/scsi_mod'
[    1.743670] kobject: 'scsi_transport_iscsi' (cd8a4b40): kobject_uevent_env
[    1.745310] kobject: 'scsi_transport_iscsi' (cd8a4b40): fill_kobj_path: path = '/module/scsi_transport_iscsi'
[    1.747870] kobject: 'scsi_transport_iscsi' (cd8a4b40): kobject_uevent_env
[    1.750005] kobject: 'scsi_transport_iscsi' (cd8a4b40): fill_kobj_path: path = '/module/scsi_transport_iscsi'
[    1.752550] kobject: 'ch' (cd8ac0c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.754790] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.756154] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.757703] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.759038] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.760012] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.761495] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.763096] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.764498] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.766106] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.767520] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.769125] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.770005] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.771656] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.772989] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.774608] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.776016] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.777654] kobject: 'ch' (cd8ac0c0): kobject_uevent_env
[    1.780005] kobject: 'ch' (cd8ac0c0): fill_kobj_path: path = '/module/ch'
[    1.781590] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.783005] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.785187] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.786679] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.788740] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.790005] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.792220] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.793590] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.795726] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.797137] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.799270] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.800007] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.802131] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.803546] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.805637] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.807049] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.810013] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.811388] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.813465] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.814885] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.817052] kobject: 'libata' (cd8a4c00): kobject_uevent_env
[    1.818462] kobject: 'libata' (cd8a4c00): fill_kobj_path: path = '/module/libata'
[    1.820010] kobject: 'ahci' (cd8a4cc0): kobject_uevent_env
[    1.821404] kobject: 'ahci' (cd8a4cc0): fill_kobj_path: path = '/module/ahci'
[    1.823095] kobject: 'libahci' (cd8ac800): kobject_add_internal: parent: 'module', set: 'module'
[    1.825426] kobject: 'libahci' (cd8ac800): kobject_uevent_env
[    1.826854] kobject: 'libahci' (cd8ac800): fill_kobj_path: path = '/module/libahci'
[    1.829031] kobject: 'libahci' (cd8ac800): kobject_uevent_env
[    1.830006] kobject: 'libahci' (cd8ac800): fill_kobj_path: path = '/module/libahci'
[    1.832126] kobject: 'libahci' (cd8ac800): kobject_uevent_env
[    1.833599] kobject: 'libahci' (cd8ac800): fill_kobj_path: path = '/module/libahci'
[    1.835710] kobject: 'spi_topcliff_pch' (cd8ac980): kobject_add_internal: parent: 'module', set: 'module'
[    1.838188] kobject: 'spi_topcliff_pch' (cd8ac980): kobject_uevent_env
[    1.840005] kobject: 'spi_topcliff_pch' (cd8ac980): fill_kobj_path: path = '/module/spi_topcliff_pch'
[    1.842400] kobject: 'smsc75xx' (cd8acac0): kobject_add_internal: parent: 'module', set: 'module'
[    1.844680] kobject: 'smsc75xx' (cd8acac0): kobject_uevent_env
[    1.846148] kobject: 'smsc75xx' (cd8acac0): fill_kobj_path: path = '/module/smsc75xx'
[    1.848245] kobject: 'smsc95xx' (cd8acc00): kobject_add_internal: parent: 'module', set: 'module'
[    1.850007] kobject: 'smsc95xx' (cd8acc00): kobject_uevent_env
[    1.851442] kobject: 'smsc95xx' (cd8acc00): fill_kobj_path: path = '/module/smsc95xx'
[    1.853576] kobject: 'pcmcia_core' (cd8acd40): kobject_add_internal: parent: 'module', set: 'module'
[    1.855972] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.857427] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.860011] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.861511] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.863779] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.865242] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.867507] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.870005] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.872248] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.873790] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.876013] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.877521] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.880014] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.881505] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.883746] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.885246] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.890017] kobject: 'pcmcia_core' (cd8acd40): kobject_uevent_env
[    1.891509] kobject: 'pcmcia_core' (cd8acd40): fill_kobj_path: path = '/module/pcmcia_core'
[    1.893915] kobject: 'pcmcia' (cd8ad000): kobject_add_internal: parent: 'module', set: 'module'
[    1.896217] kobject: 'pcmcia' (cd8ad000): kobject_uevent_env
[    1.897687] kobject: 'pcmcia' (cd8ad000): fill_kobj_path: path = '/module/pcmcia'
[    1.900012] kobject: 'pcmcia' (cd8ad000): kobject_uevent_env
[    1.901488] kobject: 'pcmcia' (cd8ad000): fill_kobj_path: path = '/module/pcmcia'
[    1.903639] kobject: 'pcmcia_rsrc' (cd8ad140): kobject_add_internal: parent: 'module', set: 'module'
[    1.906028] kobject: 'pcmcia_rsrc' (cd8ad140): kobject_uevent_env
[    1.907568] kobject: 'pcmcia_rsrc' (cd8ad140): fill_kobj_path: path = '/module/pcmcia_rsrc'
[    1.910009] kobject: 'pd6729' (cd8ad280): kobject_add_internal: parent: 'module', set: 'module'
[    1.912430] kobject: 'pd6729' (cd8ad280): kobject_uevent_env
[    1.913961] kobject: 'pd6729' (cd8ad280): fill_kobj_path: path = '/module/pd6729'
[    1.916056] kobject: 'kernel' (cd8a7280): kobject_uevent_env
[    1.917471] kobject: 'kernel' (cd8a7280): fill_kobj_path: path = '/module/kernel'
[    1.920008] kobject: 'usbcore' (cd8ad540): kobject_add_internal: parent: 'module', set: 'module'
[    1.922336] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.923761] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.925908] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.927335] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.929534] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.930005] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.932191] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.933622] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.935788] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.937234] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.940015] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.941436] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.943505] kobject: 'usbcore' (cd8ad540): kobject_uevent_env
[    1.944934] kobject: 'usbcore' (cd8ad540): fill_kobj_path: path = '/module/usbcore'
[    1.947130] kobject: 'uhci_hcd' (cd8ad7c0): kobject_add_internal: parent: 'module', set: 'module'
[    1.950008] kobject: 'uhci_hcd' (cd8ad7c0): kobject_uevent_env
[    1.951448] kobject: 'uhci_hcd' (cd8ad7c0): fill_kobj_path: path = '/module/uhci_hcd'
[    1.953622] kobject: 'usblp' (cd8ad900): kobject_add_internal: parent: 'module', set: 'module'
[    1.955944] kobject: 'usblp' (cd8ad900): kobject_uevent_env
[    1.957381] kobject: 'usblp' (cd8ad900): fill_kobj_path: path = '/module/usblp'
[    1.959417] kobject: 'adutux' (cd8ada40): kobject_add_internal: parent: 'module', set: 'module'
[    1.960015] kobject: 'adutux' (cd8ada40): kobject_uevent_env
[    1.961496] kobject: 'adutux' (cd8ada40): fill_kobj_path: path = '/module/adutux'
[    1.963567] kobject: 'ldusb' (cd8a5200): kobject_uevent_env
[    1.964938] kobject: 'ldusb' (cd8a5200): fill_kobj_path: path = '/module/ldusb'
[    1.966941] kobject: 'usbtest' (cd8adc40): kobject_add_internal: parent: 'module', set: 'module'
[    1.970008] kobject: 'usbtest' (cd8adc40): kobject_uevent_env
[    1.971595] kobject: 'usbtest' (cd8adc40): fill_kobj_path: path = '/module/usbtest'
[    1.973723] kobject: 'usbatm' (cd8a52c0): kobject_uevent_env
[    1.975143] kobject: 'usbatm' (cd8a52c0): fill_kobj_path: path = '/module/usbatm'
[    1.977286] kobject: 'usbatm' (cd8a52c0): kobject_uevent_env
[    1.978753] kobject: 'usbatm' (cd8a52c0): fill_kobj_path: path = '/module/usbatm'
[    1.980012] kobject: 'usbatm' (cd8a52c0): kobject_uevent_env
[    1.981409] kobject: 'usbatm' (cd8a52c0): fill_kobj_path: path = '/module/usbatm'
[    1.983548] kobject: 'usbatm' (cd8a52c0): kobject_uevent_env
[    1.984960] kobject: 'usbatm' (cd8a52c0): fill_kobj_path: path = '/module/usbatm'
[    1.987038] kobject: 'net2280' (cd8adec0): kobject_add_internal: parent: 'module', set: 'module'
[    1.990008] kobject: 'net2280' (cd8adec0): kobject_uevent_env
[    1.991414] kobject: 'net2280' (cd8adec0): fill_kobj_path: path = '/module/net2280'
[    1.993590] kobject: 'net2280' (cd8adec0): kobject_uevent_env
[    1.994998] kobject: 'net2280' (cd8adec0): fill_kobj_path: path = '/module/net2280'
[    1.997078] kobject: 'net2280' (cd8adec0): kobject_uevent_env
[    1.998518] kobject: 'net2280' (cd8adec0): fill_kobj_path: path = '/module/net2280'
[    2.000025] kobject: 'net2280' (cd8adec0): kobject_uevent_env
[    2.001510] kobject: 'net2280' (cd8adec0): fill_kobj_path: path = '/module/net2280'
[    2.003685] kobject: 'g_mass_storage' (cd8adf40): kobject_add_internal: parent: 'module', set: 'module'
[    2.006142] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.007688] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.010012] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.011531] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.013913] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.015466] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.017780] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.020006] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.022350] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.023871] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.026205] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.027756] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.030015] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.031557] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.033873] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.035374] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.037664] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.040006] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.042417] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.043943] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.046298] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.047832] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.050019] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.051560] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.053921] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.055433] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.057779] kobject: 'g_mass_storage' (cd8adf40): kobject_uevent_env
[    2.060006] kobject: 'g_mass_storage' (cd8adf40): fill_kobj_path: path = '/module/g_mass_storage'
[    2.062365] kobject: 'i8042' (cd8af400): kobject_add_internal: parent: 'module', set: 'module'
[    2.064683] kobject: 'i8042' (cd8af400): kobject_uevent_env
[    2.066085] kobject: 'i8042' (cd8af400): fill_kobj_path: path = '/module/i8042'
[    2.068140] kobject: 'mousedev' (cd8af540): kobject_add_internal: parent: 'module', set: 'module'
[    2.070007] kobject: 'mousedev' (cd8af540): kobject_uevent_env
[    2.071490] kobject: 'mousedev' (cd8af540): fill_kobj_path: path = '/module/mousedev'
[    2.073641] kobject: 'mousedev' (cd8af540): kobject_uevent_env
[    2.075115] kobject: 'mousedev' (cd8af540): fill_kobj_path: path = '/module/mousedev'
[    2.077223] kobject: 'mousedev' (cd8af540): kobject_uevent_env
[    2.078664] kobject: 'mousedev' (cd8af540): fill_kobj_path: path = '/module/mousedev'
[    2.080008] kobject: 'appletouch' (cd8af6c0): kobject_add_internal: parent: 'module', set: 'module'
[    2.082416] kobject: 'appletouch' (cd8af6c0): kobject_uevent_env
[    2.083913] kobject: 'appletouch' (cd8af6c0): fill_kobj_path: path = '/module/appletouch'
[    2.086180] kobject: 'appletouch' (cd8af6c0): kobject_uevent_env
[    2.087645] kobject: 'appletouch' (cd8af6c0): fill_kobj_path: path = '/module/appletouch'
[    2.090009] kobject: 'bcm5974' (cd8af800): kobject_add_internal: parent: 'module', set: 'module'
[    2.092320] kobject: 'bcm5974' (cd8af800): kobject_uevent_env
[    2.093765] kobject: 'bcm5974' (cd8af800): fill_kobj_path: path = '/module/bcm5974'
[    2.095918] kobject: 'psmouse' (cd8af940): kobject_add_internal: parent: 'module', set: 'module'
[    2.098230] kobject: 'psmouse' (cd8af940): kobject_uevent_env
[    2.100005] kobject: 'psmouse' (cd8af940): fill_kobj_path: path = '/module/psmouse'
[    2.102154] kobject: 'psmouse' (cd8af940): kobject_uevent_env
[    2.103560] kobject: 'psmouse' (cd8af940): fill_kobj_path: path = '/module/psmouse'
[    2.105757] kobject: 'psmouse' (cd8af940): kobject_uevent_env
[    2.107175] kobject: 'psmouse' (cd8af940): fill_kobj_path: path = '/module/psmouse'
[    2.110014] kobject: 'psmouse' (cd8af940): kobject_uevent_env
[    2.111473] kobject: 'psmouse' (cd8af940): fill_kobj_path: path = '/module/psmouse'
[    2.113594] kobject: 'psmouse' (cd8af940): kobject_uevent_env
[    2.115025] kobject: 'psmouse' (cd8af940): fill_kobj_path: path = '/module/psmouse'
[    2.120015] kobject: 'psmouse' (cd8af940): kobject_uevent_env
[    2.121413] kobject: 'psmouse' (cd8af940): fill_kobj_path: path = '/module/psmouse'
[    2.123530] kobject: 'usbtouchscreen' (cd8afb80): kobject_add_internal: parent: 'module', set: 'module'
[    2.126051] kobject: 'usbtouchscreen' (cd8afb80): kobject_uevent_env
[    2.127627] kobject: 'usbtouchscreen' (cd8afb80): fill_kobj_path: path = '/module/usbtouchscreen'
[    2.130010] kobject: 'usbtouchscreen' (cd8afb80): kobject_uevent_env
[    2.131582] kobject: 'usbtouchscreen' (cd8afb80): fill_kobj_path: path = '/module/usbtouchscreen'
[    2.133931] kobject: 'ati_remote2' (cd8a55c0): kobject_uevent_env
[    2.135427] kobject: 'ati_remote2' (cd8a55c0): fill_kobj_path: path = '/module/ati_remote2'
[    2.137644] kobject: 'ati_remote2' (cd8a55c0): kobject_uevent_env
[    2.140005] kobject: 'ati_remote2' (cd8a55c0): fill_kobj_path: path = '/module/ati_remote2'
[    2.142253] kobject: 'i2c_algo_bit' (cd8afd80): kobject_add_internal: parent: 'module', set: 'module'
[    2.144577] kobject: 'i2c_algo_bit' (cd8afd80): kobject_uevent_env
[    2.146090] kobject: 'i2c_algo_bit' (cd8afd80): fill_kobj_path: path = '/module/i2c_algo_bit'
[    2.148433] kobject: 'i2c_algo_pcf' (cd8afec0): kobject_add_internal: parent: 'module', set: 'module'
[    2.150007] kobject: 'i2c_algo_pcf' (cd8afec0): kobject_uevent_env
[    2.151511] kobject: 'i2c_algo_pcf' (cd8afec0): fill_kobj_path: path = '/module/i2c_algo_pcf'
[    2.153824] kobject: 'i2c_eg20t' (cd8adfc0): kobject_add_internal: parent: 'module', set: 'module'
[    2.156196] kobject: 'i2c_eg20t' (cd8adfc0): kobject_uevent_env
[    2.157690] kobject: 'i2c_eg20t' (cd8adfc0): fill_kobj_path: path = '/module/i2c_eg20t'
[    2.160011] kobject: 'i2c_eg20t' (cd8adfc0): kobject_uevent_env
[    2.161502] kobject: 'i2c_eg20t' (cd8adfc0): fill_kobj_path: path = '/module/i2c_eg20t'
[    2.163673] kobject: 'i2c_intel_mid' (cd8a5a40): kobject_uevent_env
[    2.165195] kobject: 'i2c_intel_mid' (cd8a5a40): fill_kobj_path: path = '/module/i2c_intel_mid'
[    2.167520] kobject: 'k10temp' (cd8b01c0): kobject_add_internal: parent: 'module', set: 'module'
[    2.170008] kobject: 'k10temp' (cd8b01c0): kobject_uevent_env
[    2.171415] kobject: 'k10temp' (cd8b01c0): fill_kobj_path: path = '/module/k10temp'
[    2.173506] kobject: 'raid10' (cd8b0300): kobject_add_internal: parent: 'module', set: 'module'
[    2.175793] kobject: 'raid10' (cd8b0300): kobject_uevent_env
[    2.177187] kobject: 'raid10' (cd8b0300): fill_kobj_path: path = '/module/raid10'
[    2.180009] kobject: 'md_mod' (cd8b0440): kobject_add_internal: parent: 'module', set: 'module'
[    2.182323] kobject: 'md_mod' (cd8b0440): kobject_uevent_env
[    2.183707] kobject: 'md_mod' (cd8b0440): fill_kobj_path: path = '/module/md_mod'
[    2.185870] kobject: 'md_mod' (cd8b0440): kobject_uevent_env
[    2.187287] kobject: 'md_mod' (cd8b0440): fill_kobj_path: path = '/module/md_mod'
[    2.189397] kobject: 'md_mod' (cd8b0440): kobject_uevent_env
[    2.190005] kobject: 'md_mod' (cd8b0440): fill_kobj_path: path = '/module/md_mod'
[    2.192150] kobject: 'hci_uart' (cd8a5c80): kobject_uevent_env
[    2.193618] kobject: 'hci_uart' (cd8a5c80): fill_kobj_path: path = '/module/hci_uart'
[    2.195749] kobject: 'hci_uart' (cd8a5c80): kobject_uevent_env
[    2.197241] kobject: 'hci_uart' (cd8a5c80): fill_kobj_path: path = '/module/hci_uart'
[    2.200010] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    2.201436] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    2.203484] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    2.204938] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    2.206975] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    2.208385] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    2.210011] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    2.211413] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    2.213445] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    2.214825] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    2.216854] kobject: 'btusb' (cd8a5d40): kobject_uevent_env
[    2.218320] kobject: 'btusb' (cd8a5d40): fill_kobj_path: path = '/module/btusb'
[    2.220009] kobject: 'cpuidle' (cd8b0840): kobject_add_internal: parent: 'module', set: 'module'
[    2.222276] kobject: 'cpuidle' (cd8b0840): kobject_uevent_env
[    2.223764] kobject: 'cpuidle' (cd8b0840): fill_kobj_path: path = '/module/cpuidle'
[    2.225861] kobject: 'mmc_core' (cd8b0980): kobject_add_internal: parent: 'module', set: 'module'
[    2.228225] kobject: 'mmc_core' (cd8b0980): kobject_uevent_env
[    2.230005] kobject: 'mmc_core' (cd8b0980): fill_kobj_path: path = '/module/mmc_core'
[    2.232204] kobject: 'mmcblk' (cd8b0ac0): kobject_add_internal: parent: 'module', set: 'module'
[    2.234489] kobject: 'mmcblk' (cd8b0ac0): kobject_uevent_env
[    2.235907] kobject: 'mmcblk' (cd8b0ac0): fill_kobj_path: path = '/module/mmcblk'
[    2.238037] kobject: 'sdhci' (cd8b0c00): kobject_add_internal: parent: 'module', set: 'module'
[    2.240009] kobject: 'sdhci' (cd8b0c00): kobject_uevent_env
[    2.241443] kobject: 'sdhci' (cd8b0c00): fill_kobj_path: path = '/module/sdhci'
[    2.243514] kobject: 'sdhci' (cd8b0c00): kobject_uevent_env
[    2.244967] kobject: 'sdhci' (cd8b0c00): fill_kobj_path: path = '/module/sdhci'
[    2.246974] kobject: 'vub300' (cd8b0d40): kobject_add_internal: parent: 'module', set: 'module'
[    2.250008] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.251397] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.253490] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.254907] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.256978] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.258559] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.260014] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.261484] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.263639] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.265097] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.267235] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.270005] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.272148] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.273541] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.275649] kobject: 'vub300' (cd8b0d40): kobject_uevent_env
[    2.277051] kobject: 'vub300' (cd8b0d40): fill_kobj_path: path = '/module/vub300'
[    2.279221] kobject: 'dell_rbu' (cd8a5ec0): kobject_uevent_env
[    2.280005] kobject: 'dell_rbu' (cd8a5ec0): fill_kobj_path: path = '/module/dell_rbu'
[    2.282156] kobject: 'hifn_795x' (cd8b1100): kobject_add_internal: parent: 'module', set: 'module'
[    2.284485] kobject: 'hifn_795x' (cd8b1100): kobject_uevent_env
[    2.286017] kobject: 'hifn_795x' (cd8b1100): fill_kobj_path: path = '/module/hifn_795x'
[    2.288311] kobject: 'hid' (cd8b1240): kobject_add_internal: parent: 'module', set: 'module'
[    2.290008] kobject: 'hid' (cd8b1240): kobject_uevent_env
[    2.291446] kobject: 'hid' (cd8b1240): fill_kobj_path: path = '/module/hid'
[    2.293104] kobject: 'hid' (cd8b1240): kobject_uevent_env
[    2.294505] kobject: 'hid' (cd8b1240): fill_kobj_path: path = '/module/hid'
[    2.296165] kobject: 'oprofile' (cd8b1380): kobject_add_internal: parent: 'module', set: 'module'
[    2.300008] kobject: 'oprofile' (cd8b1380): kobject_uevent_env
[    2.301461] kobject: 'oprofile' (cd8b1380): fill_kobj_path: path = '/module/oprofile'
[    2.303575] kobject: 'sch_htb' (cd8b14c0): kobject_add_internal: parent: 'module', set: 'module'
[    2.305853] kobject: 'sch_htb' (cd8b14c0): kobject_uevent_env
[    2.307278] kobject: 'sch_htb' (cd8b14c0): fill_kobj_path: path = '/module/sch_htb'
[    2.309486] kobject: 'bluetooth' (cd8a71c0): kobject_uevent_env
[    2.310006] kobject: 'bluetooth' (cd8a71c0): fill_kobj_path: path = '/module/bluetooth'
[    2.312230] kobject: 'bluetooth' (cd8a71c0): kobject_uevent_env
[    2.313750] kobject: 'bluetooth' (cd8a71c0): fill_kobj_path: path = '/module/bluetooth'
[    2.315943] kobject: 'bluetooth' (cd8a71c0): kobject_uevent_env
[    2.317431] kobject: 'bluetooth' (cd8a71c0): fill_kobj_path: path = '/module/bluetooth'
[    2.320008] kobject: 'decnet' (cd8b1700): kobject_add_internal: parent: 'module', set: 'module'
[    2.322353] kobject: 'decnet' (cd8b1700): kobject_uevent_env
[    2.323782] kobject: 'decnet' (cd8b1700): fill_kobj_path: path = '/module/decnet'
[    2.325918] kobject: 'wimax' (cd8b1840): kobject_add_internal: parent: 'module', set: 'module'
[    2.328415] kobject: 'wimax' (cd8b1840): kobject_uevent_env
[    2.330005] kobject: 'wimax' (cd8b1840): fill_kobj_path: path = '/module/wimax'
[    2.335579] device: 'default': device_add
[    2.336818] kobject: 'bdi' (cd8b1980): kobject_add_internal: parent: 'virtual', set: '(null)'
[    2.339049] kobject: 'default' (cd8b2808): kobject_add_internal: parent: 'bdi', set: 'devices'
[    2.340015] PM: Adding info for No Bus:default
[    2.341331] kobject: 'default' (cd8b2808): kobject_uevent_env
[    2.342735] kobject: 'default' (cd8b2808): fill_kobj_path: path = '/devices/virtual/bdi/default'
[    2.345239] debugfs: creating file 'default'
[    2.345239] debugfs: creating file 'stats'
[    2.345239] bio: create slab <bio-0> at 0
[    2.350076] fsnotify_create_event: event=cd8b1f40 to_tell=  (null) mask=4000 data=  (null) data_type=0
[    2.352464] device class 'block': registering
[    2.353677] kobject: 'block' (cd8a840c): kobject_add_internal: parent: 'class', set: 'class'
[    2.355890] kobject: 'block' (cd8a840c): kobject_uevent_env
[    2.357305] kobject: 'block' (cd8a840c): fill_kobj_path: path = '/class/block'
[    2.360053] kobject: 'block' (cd8b4040): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
[    2.530014] raid6: mmxx1     3024 MB/s
[    2.700017] raid6: mmxx2     3318 MB/s
[    2.870008] raid6: sse1x1    2540 MB/s
[    3.040012] raid6: sse1x2    3351 MB/s
[    3.210008] raid6: sse2x1    6162 MB/s
[    3.380011] raid6: sse2x2    9680 MB/s
[    3.380670] raid6: using algorithm sse2x2 (9680 MB/s)
[    3.381449] raid6: using intx1 recovery algorithm
[    3.382202] debugfs: creating file 'gpio'
[    3.382885] bus: 'spi': add driver 74x164
[    3.383564] kobject: '74x164' (cd897960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.384942] kobject: '74x164' (cd897960): kobject_uevent_env
[    3.385790] kobject: '74x164' (cd897960): fill_kobj_path: path = '/bus/spi/drivers/74x164'
[    3.387105] bus: 'i2c': add driver max7300
[    3.387785] kobject: 'max7300' (cd8979c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.389168] kobject: 'max7300' (cd8979c0): kobject_uevent_env
[    3.390004] kobject: 'max7300' (cd8979c0): fill_kobj_path: path = '/bus/i2c/drivers/max7300'
[    3.391330] i2c-core: driver [max7300] registered
[    3.392073] bus: 'i2c': add driver pcf857x
[    3.392749] kobject: 'pcf857x' (cd897a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.394126] kobject: 'pcf857x' (cd897a20): kobject_uevent_env
[    3.394970] kobject: 'pcf857x' (cd897a20): fill_kobj_path: path = '/bus/i2c/drivers/pcf857x'
[    3.396295] i2c-core: driver [pcf857x] registered
[    3.397039] bus: 'platform': add driver tc3589x-gpio
[    3.397801] kobject: 'tc3589x-gpio' (cd897a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.399223] kobject: 'tc3589x-gpio' (cd897a80): kobject_uevent_env
[    3.400007] kobject: 'tc3589x-gpio' (cd897a80): fill_kobj_path: path = '/bus/platform/drivers/tc3589x-gpio'
[    3.401461] bus: 'platform': add driver tps65912-gpio
[    3.402238] kobject: 'tps65912-gpio' (cd897ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.403660] kobject: 'tps65912-gpio' (cd897ae0): kobject_uevent_env
[    3.404560] kobject: 'tps65912-gpio' (cd897ae0): fill_kobj_path: path = '/bus/platform/drivers/tps65912-gpio'
[    3.406032] kobject: 'slots' (cd8b45cc): kobject_add_internal: parent: 'pci', set: '<NULL>'
[    3.407348] kobject: 'slots' (cd8b45cc): kobject_uevent_env
[    3.408177] kobject: 'slots' (cd8b45cc): kobject_uevent_env: filter function caused the event to drop!
[    3.409587] device class 'graphics': registering
[    3.410005] kobject: 'graphics' (cd8a850c): kobject_add_internal: parent: 'class', set: 'class'
[    3.411351] kobject: 'graphics' (cd8a850c): kobject_uevent_env
[    3.412204] kobject: 'graphics' (cd8a850c): fill_kobj_path: path = '/class/graphics'
[    3.413459] kobject: 'acpi' (cd8b4700): kobject_add_internal: parent: 'firmware', set: '<NULL>'
[    3.414834] ACPI: Added _OSI(Module Device)
[    3.415523] ACPI: Added _OSI(Processor Device)
[    3.416237] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.416980] ACPI: Added _OSI(Processor Aggregator Device)
[    3.418206] ACPI: EC: Look up EC in DSDT
[    3.420418] kobject: 'tables' (cd8b4ec0): kobject_add_internal: parent: 'acpi', set: '<NULL>'
[    3.421758] kobject: 'dynamic' (cd8b4f40): kobject_add_internal: parent: 'tables', set: '<NULL>'
[    3.423133] kobject: 'tables' (cd8b4ec0): kobject_uevent_env
[    3.423968] kobject: 'tables' (cd8b4ec0): kobject_uevent_env: attempted to send uevent without kset!
[    3.425368] kobject: 'dynamic' (cd8b4f40): kobject_uevent_env
[    3.426210] kobject: 'dynamic' (cd8b4f40): kobject_uevent_env: attempted to send uevent without kset!
[    3.427725] ACPI: Interpreter enabled
[    3.428368] ACPI: (supports S0 S3 S5)
[    3.429202] ACPI: Using IOAPIC for interrupt routing
[    3.429970] kobject: 'acpi' (cd8a870c): kobject_add_internal: parent: 'bus', set: 'bus'
[    3.430005] kobject: 'acpi' (cd8a870c): kobject_uevent_env
[    3.430829] kobject: 'acpi' (cd8a870c): fill_kobj_path: path = '/bus/acpi'
[    3.431792] kobject: 'devices' (cd8b840c): kobject_add_internal: parent: 'acpi', set: '<NULL>'
[    3.433131] kobject: 'devices' (cd8b840c): kobject_uevent_env
[    3.433981] kobject: 'devices' (cd8b840c): kobject_uevent_env: filter function caused the event to drop!
[    3.435410] kobject: 'drivers' (cd8b848c): kobject_add_internal: parent: 'acpi', set: '<NULL>'
[    3.436755] kobject: 'drivers' (cd8b848c): kobject_uevent_env
[    3.437601] kobject: 'drivers' (cd8b848c): kobject_uevent_env: filter function caused the event to drop!
[    3.440004] bus: 'acpi': registered
[    3.440620] bus: 'acpi': add driver power
[    3.441290] kobject: 'power' (cd897d20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.442649] kobject: 'power' (cd897d20): kobject_uevent_env
[    3.443480] kobject: 'power' (cd897d20): fill_kobj_path: path = '/bus/acpi/drivers/power'
[    3.444793] device: 'LNXSYSTM:00': device_add
[    3.445495] kobject: 'LNXSYSTM:00' (cd8a0e24): kobject_add_internal: parent: 'devices', set: 'devices'
[    3.446913] bus: 'acpi': add device LNXSYSTM:00
[    3.447640] PM: Adding info for acpi:LNXSYSTM:00
[    3.448373] kobject: 'LNXSYSTM:00' (cd8a0e24): kobject_uevent_env
[    3.449253] kobject: 'LNXSYSTM:00' (cd8a0e24): fill_kobj_path: path = '/devices/LNXSYSTM:00'
[    3.450030] device: 'device:00': device_add
[    3.450722] kobject: 'device:00' (cd8a1624): kobject_add_internal: parent: 'LNXSYSTM:00', set: 'devices'
[    3.452154] bus: 'acpi': add device device:00
[    3.452861] PM: Adding info for acpi:device:00
[    3.453575] kobject: 'device:00' (cd8a1624): kobject_uevent_env
[    3.454441] kobject: 'device:00' (cd8a1624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00'
[    3.455852] device: 'PNP0A03:00': device_add
[    3.456556] kobject: 'PNP0A03:00' (cd8a1a24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.457973] bus: 'acpi': add device PNP0A03:00
[    3.458691] PM: Adding info for acpi:PNP0A03:00
[    3.460003] kobject: 'PNP0A03:00' (cd8a1a24): kobject_uevent_env
[    3.460879] kobject: 'PNP0A03:00' (cd8a1a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00'
[    3.462510] device: 'device:01': device_add
[    3.463206] kobject: 'device:01' (cd8a1e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.464630] bus: 'acpi': add device device:01
[    3.465342] PM: Adding info for acpi:device:01
[    3.466059] kobject: 'device:01' (cd8a1e24): kobject_uevent_env
[    3.466939] kobject: 'device:01' (cd8a1e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01'
[    3.468535] device: 'device:02': device_add
[    3.469232] kobject: 'device:02' (cd8a2224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.470010] bus: 'acpi': add device device:02
[    3.470720] PM: Adding info for acpi:device:02
[    3.471444] kobject: 'device:02' (cd8a2224): kobject_uevent_env
[    3.472312] kobject: 'device:02' (cd8a2224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02'
[    3.473912] device: 'PNP0B00:00': device_add
[    3.474615] kobject: 'PNP0B00:00' (cd8a2624): kobject_add_internal: parent: 'device:02', set: 'devices'
[    3.476039] bus: 'acpi': add device PNP0B00:00
[    3.476763] PM: Adding info for acpi:PNP0B00:00
[    3.477488] kobject: 'PNP0B00:00' (cd8a2624): kobject_uevent_env
[    3.478364] kobject: 'PNP0B00:00' (cd8a2624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0B00:00'
[    3.480032] device: 'PNP0303:00': device_add
[    3.480731] kobject: 'PNP0303:00' (cd8a2a24): kobject_add_internal: parent: 'device:02', set: 'devices'
[    3.482163] bus: 'acpi': add device PNP0303:00
[    3.482881] PM: Adding info for acpi:PNP0303:00
[    3.483604] kobject: 'PNP0303:00' (cd8a2a24): kobject_uevent_env
[    3.484478] kobject: 'PNP0303:00' (cd8a2a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0303:00'
[    3.486189] device: 'PNP0F13:00': device_add
[    3.486886] kobject: 'PNP0F13:00' (cd8a2e24): kobject_add_internal: parent: 'device:02', set: 'devices'
[    3.488314] bus: 'acpi': add device PNP0F13:00
[    3.490006] PM: Adding info for acpi:PNP0F13:00
[    3.490730] kobject: 'PNP0F13:00' (cd8a2e24): kobject_uevent_env
[    3.491605] kobject: 'PNP0F13:00' (cd8a2e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0F13:00'
[    3.495327] device: 'PNP0700:00': device_add
[    3.496029] kobject: 'PNP0700:00' (cd8a3224): kobject_add_internal: parent: 'device:02', set: 'devices'
[    3.497449] bus: 'acpi': add device PNP0700:00
[    3.498174] PM: Adding info for acpi:PNP0700:00
[    3.498901] kobject: 'PNP0700:00' (cd8a3224): kobject_uevent_env
[    3.499775] kobject: 'PNP0700:00' (cd8a3224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0700:00'
[    3.500076] device: 'PNP0400:00': device_add
[    3.500779] kobject: 'PNP0400:00' (cd8a3624): kobject_add_internal: parent: 'device:02', set: 'devices'
[    3.502203] bus: 'acpi': add device PNP0400:00
[    3.502923] PM: Adding info for acpi:PNP0400:00
[    3.503652] kobject: 'PNP0400:00' (cd8a3624): kobject_uevent_env
[    3.504524] kobject: 'PNP0400:00' (cd8a3624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0400:00'
[    3.506264] device: 'PNP0501:00': device_add
[    3.506966] kobject: 'PNP0501:00' (cd8a3a24): kobject_add_internal: parent: 'device:02', set: 'devices'
[    3.508384] bus: 'acpi': add device PNP0501:00
[    3.510007] PM: Adding info for acpi:PNP0501:00
[    3.510733] kobject: 'PNP0501:00' (cd8a3a24): kobject_uevent_env
[    3.511606] kobject: 'PNP0501:00' (cd8a3a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/PNP0501:00'
[    3.513339] device: 'device:03': device_add
[    3.514028] kobject: 'device:03' (cd8a3e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.515458] bus: 'acpi': add device device:03
[    3.516165] PM: Adding info for acpi:device:03
[    3.516881] kobject: 'device:03' (cd8a3e24): kobject_uevent_env
[    3.517748] kobject: 'device:03' (cd8a3e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:03'
[    3.520038] device: 'device:04': device_add
[    3.520729] kobject: 'device:04' (cd8e8224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.522158] bus: 'acpi': add device device:04
[    3.522864] PM: Adding info for acpi:device:04
[    3.523581] kobject: 'device:04' (cd8e8224): kobject_uevent_env
[    3.524450] kobject: 'device:04' (cd8e8224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:04'
[    3.526048] device: 'device:05': device_add
[    3.526738] kobject: 'device:05' (cd8e8624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.528162] bus: 'acpi': add device device:05
[    3.528872] PM: Adding info for acpi:device:05
[    3.529588] kobject: 'device:05' (cd8e8624): kobject_uevent_env
[    3.530004] kobject: 'device:05' (cd8e8624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:05'
[    3.531600] device: 'device:06': device_add
[    3.532286] kobject: 'device:06' (cd8e8a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.533714] bus: 'acpi': add device device:06
[    3.534420] PM: Adding info for acpi:device:06
[    3.535135] kobject: 'device:06' (cd8e8a24): kobject_uevent_env
[    3.536000] kobject: 'device:06' (cd8e8a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:06'
[    3.537597] device: 'device:07': device_add
[    3.538287] kobject: 'device:07' (cd8e8e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.540005] bus: 'acpi': add device device:07
[    3.540714] PM: Adding info for acpi:device:07
[    3.541431] kobject: 'device:07' (cd8e8e24): kobject_uevent_env
[    3.542299] kobject: 'device:07' (cd8e8e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:07'
[    3.543900] device: 'device:08': device_add
[    3.544588] kobject: 'device:08' (cd8e9224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.546013] bus: 'acpi': add device device:08
[    3.546722] PM: Adding info for acpi:device:08
[    3.547440] kobject: 'device:08' (cd8e9224): kobject_uevent_env
[    3.548303] kobject: 'device:08' (cd8e9224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:08'
[    3.550023] device: 'device:09': device_add
[    3.550717] kobject: 'device:09' (cd8e9624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.552142] bus: 'acpi': add device device:09
[    3.552850] PM: Adding info for acpi:device:09
[    3.553574] kobject: 'device:09' (cd8e9624): kobject_uevent_env
[    3.554440] kobject: 'device:09' (cd8e9624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:09'
[    3.556039] device: 'device:0a': device_add
[    3.556725] kobject: 'device:0a' (cd8e9a24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.558147] bus: 'acpi': add device device:0a
[    3.558859] PM: Adding info for acpi:device:0a
[    3.559577] kobject: 'device:0a' (cd8e9a24): kobject_uevent_env
[    3.560004] kobject: 'device:0a' (cd8e9a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0a'
[    3.561608] device: 'device:0b': device_add
[    3.562296] kobject: 'device:0b' (cd8e9e24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.563723] bus: 'acpi': add device device:0b
[    3.564433] PM: Adding info for acpi:device:0b
[    3.565149] kobject: 'device:0b' (cd8e9e24): kobject_uevent_env
[    3.566015] kobject: 'device:0b' (cd8e9e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0b'
[    3.567625] device: 'device:0c': device_add
[    3.568315] kobject: 'device:0c' (cd8ea224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.570005] bus: 'acpi': add device device:0c
[    3.570720] PM: Adding info for acpi:device:0c
[    3.571431] kobject: 'device:0c' (cd8ea224): kobject_uevent_env
[    3.572293] kobject: 'device:0c' (cd8ea224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0c'
[    3.573897] device: 'device:0d': device_add
[    3.574581] kobject: 'device:0d' (cd8ea624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.576010] bus: 'acpi': add device device:0d
[    3.576722] PM: Adding info for acpi:device:0d
[    3.577431] kobject: 'device:0d' (cd8ea624): kobject_uevent_env
[    3.578298] kobject: 'device:0d' (cd8ea624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0d'
[    3.580023] device: 'device:0e': device_add
[    3.580709] kobject: 'device:0e' (cd8eaa24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.582132] bus: 'acpi': add device device:0e
[    3.582842] PM: Adding info for acpi:device:0e
[    3.583553] kobject: 'device:0e' (cd8eaa24): kobject_uevent_env
[    3.584425] kobject: 'device:0e' (cd8eaa24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0e'
[    3.586026] device: 'device:0f': device_add
[    3.586709] kobject: 'device:0f' (cd8eae24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.588135] bus: 'acpi': add device device:0f
[    3.588845] PM: Adding info for acpi:device:0f
[    3.589555] kobject: 'device:0f' (cd8eae24): kobject_uevent_env
[    3.590004] kobject: 'device:0f' (cd8eae24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0f'
[    3.591613] device: 'device:10': device_add
[    3.592300] kobject: 'device:10' (cd8eb224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.593732] bus: 'acpi': add device device:10
[    3.594452] PM: Adding info for acpi:device:10
[    3.595165] kobject: 'device:10' (cd8eb224): kobject_uevent_env
[    3.596032] kobject: 'device:10' (cd8eb224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:10'
[    3.597633] device: 'device:11': device_add
[    3.598319] kobject: 'device:11' (cd8eb624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.600007] bus: 'acpi': add device device:11
[    3.600721] PM: Adding info for acpi:device:11
[    3.601433] kobject: 'device:11' (cd8eb624): kobject_uevent_env
[    3.602305] kobject: 'device:11' (cd8eb624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:11'
[    3.603904] device: 'device:12': device_add
[    3.604595] kobject: 'device:12' (cd8eba24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.606019] bus: 'acpi': add device device:12
[    3.606729] PM: Adding info for acpi:device:12
[    3.607438] kobject: 'device:12' (cd8eba24): kobject_uevent_env
[    3.608306] kobject: 'device:12' (cd8eba24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:12'
[    3.610023] device: 'device:13': device_add
[    3.610711] kobject: 'device:13' (cd8ebe24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.612139] bus: 'acpi': add device device:13
[    3.612854] PM: Adding info for acpi:device:13
[    3.613566] kobject: 'device:13' (cd8ebe24): kobject_uevent_env
[    3.614439] kobject: 'device:13' (cd8ebe24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:13'
[    3.616053] device: 'device:14': device_add
[    3.616742] kobject: 'device:14' (cd8ec224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.618174] bus: 'acpi': add device device:14
[    3.618886] PM: Adding info for acpi:device:14
[    3.619601] kobject: 'device:14' (cd8ec224): kobject_uevent_env
[    3.620004] kobject: 'device:14' (cd8ec224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14'
[    3.621607] device: 'device:15': device_add
[    3.622305] kobject: 'device:15' (cd8ec624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.623729] bus: 'acpi': add device device:15
[    3.624447] PM: Adding info for acpi:device:15
[    3.625164] kobject: 'device:15' (cd8ec624): kobject_uevent_env
[    3.626026] kobject: 'device:15' (cd8ec624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:15'
[    3.627627] device: 'device:16': device_add
[    3.628324] kobject: 'device:16' (cd8eca24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.630005] bus: 'acpi': add device device:16
[    3.632735] PM: Adding info for acpi:device:16
[    3.633444] kobject: 'device:16' (cd8eca24): kobject_uevent_env
[    3.634311] kobject: 'device:16' (cd8eca24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:16'
[    3.635909] device: 'device:17': device_add
[    3.636603] kobject: 'device:17' (cd8ece24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.638027] bus: 'acpi': add device device:17
[    3.638743] PM: Adding info for acpi:device:17
[    3.639455] kobject: 'device:17' (cd8ece24): kobject_uevent_env
[    3.640004] kobject: 'device:17' (cd8ece24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:17'
[    3.641610] device: 'device:18': device_add
[    3.642305] kobject: 'device:18' (cd8ed224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.643734] bus: 'acpi': add device device:18
[    3.644447] PM: Adding info for acpi:device:18
[    3.645161] kobject: 'device:18' (cd8ed224): kobject_uevent_env
[    3.646031] kobject: 'device:18' (cd8ed224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:18'
[    3.647636] device: 'device:19': device_add
[    3.648329] kobject: 'device:19' (cd8ed624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.650005] bus: 'acpi': add device device:19
[    3.650719] PM: Adding info for acpi:device:19
[    3.651435] kobject: 'device:19' (cd8ed624): kobject_uevent_env
[    3.652301] kobject: 'device:19' (cd8ed624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:19'
[    3.653907] device: 'device:1a': device_add
[    3.654608] kobject: 'device:1a' (cd8eda24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.656034] bus: 'acpi': add device device:1a
[    3.656744] PM: Adding info for acpi:device:1a
[    3.657466] kobject: 'device:1a' (cd8eda24): kobject_uevent_env
[    3.658332] kobject: 'device:1a' (cd8eda24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1a'
[    3.660023] device: 'device:1b': device_add
[    3.660720] kobject: 'device:1b' (cd8ede24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.662144] bus: 'acpi': add device device:1b
[    3.662859] PM: Adding info for acpi:device:1b
[    3.663581] kobject: 'device:1b' (cd8ede24): kobject_uevent_env
[    3.664441] kobject: 'device:1b' (cd8ede24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1b'
[    3.666054] device: 'device:1c': device_add
[    3.666748] kobject: 'device:1c' (cd8ee224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.668164] bus: 'acpi': add device device:1c
[    3.668877] PM: Adding info for acpi:device:1c
[    3.670003] kobject: 'device:1c' (cd8ee224): kobject_uevent_env
[    3.670865] kobject: 'device:1c' (cd8ee224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1c'
[    3.672470] device: 'device:1d': device_add
[    3.673169] kobject: 'device:1d' (cd8ee624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.674594] bus: 'acpi': add device device:1d
[    3.675307] PM: Adding info for acpi:device:1d
[    3.676025] kobject: 'device:1d' (cd8ee624): kobject_uevent_env
[    3.676884] kobject: 'device:1d' (cd8ee624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1d'
[    3.678484] device: 'device:1e': device_add
[    3.679180] kobject: 'device:1e' (cd8eea24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.680005] bus: 'acpi': add device device:1e
[    3.680721] PM: Adding info for acpi:device:1e
[    3.681440] kobject: 'device:1e' (cd8eea24): kobject_uevent_env
[    3.682309] kobject: 'device:1e' (cd8eea24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1e'
[    3.683914] device: 'device:1f': device_add
[    3.684604] kobject: 'device:1f' (cd8eee24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.686021] bus: 'acpi': add device device:1f
[    3.686734] PM: Adding info for acpi:device:1f
[    3.687454] kobject: 'device:1f' (cd8eee24): kobject_uevent_env
[    3.688317] kobject: 'device:1f' (cd8eee24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:1f'
[    3.690023] device: 'device:20': device_add
[    3.690717] kobject: 'device:20' (cd8ef224): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.692133] bus: 'acpi': add device device:20
[    3.692855] PM: Adding info for acpi:device:20
[    3.693572] kobject: 'device:20' (cd8ef224): kobject_uevent_env
[    3.694437] kobject: 'device:20' (cd8ef224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:20'
[    3.696035] device: 'device:21': device_add
[    3.696727] kobject: 'device:21' (cd8ef624): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.698155] bus: 'acpi': add device device:21
[    3.698867] PM: Adding info for acpi:device:21
[    3.700003] kobject: 'device:21' (cd8ef624): kobject_uevent_env
[    3.700870] kobject: 'device:21' (cd8ef624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:21'
[    3.702471] device: 'device:22': device_add
[    3.703163] kobject: 'device:22' (cd8efa24): kobject_add_internal: parent: 'PNP0A03:00', set: 'devices'
[    3.704929] bus: 'acpi': add device device:22
[    3.706060] PM: Adding info for acpi:device:22
[    3.707300] kobject: 'device:22' (cd8efa24): kobject_uevent_env
[    3.708639] kobject: 'device:22' (cd8efa24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:22'
[    3.710185] device: 'PNP0103:00': device_add
[    3.711386] kobject: 'PNP0103:00' (cd8efe24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.713810] bus: 'acpi': add device PNP0103:00
[    3.714998] PM: Adding info for acpi:PNP0103:00
[    3.716187] kobject: 'PNP0103:00' (cd8efe24): kobject_uevent_env
[    3.717631] kobject: 'PNP0103:00' (cd8efe24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0103:00'
[    3.720120] device: 'PNP0C0F:00': device_add
[    3.721280] kobject: 'PNP0C0F:00' (cd8f0224): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.723686] bus: 'acpi': add device PNP0C0F:00
[    3.724838] PM: Adding info for acpi:PNP0C0F:00
[    3.726083] kobject: 'PNP0C0F:00' (cd8f0224): kobject_uevent_env
[    3.727569] kobject: 'PNP0C0F:00' (cd8f0224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:00'
[    3.730091] device: 'PNP0C0F:01': device_add
[    3.731311] kobject: 'PNP0C0F:01' (cd8f0624): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.733736] bus: 'acpi': add device PNP0C0F:01
[    3.734953] PM: Adding info for acpi:PNP0C0F:01
[    3.736202] kobject: 'PNP0C0F:01' (cd8f0624): kobject_uevent_env
[    3.737627] kobject: 'PNP0C0F:01' (cd8f0624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:01'
[    3.740102] device: 'PNP0C0F:02': device_add
[    3.741321] kobject: 'PNP0C0F:02' (cd8f0a24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.743736] bus: 'acpi': add device PNP0C0F:02
[    3.744930] PM: Adding info for acpi:PNP0C0F:02
[    3.746164] kobject: 'PNP0C0F:02' (cd8f0a24): kobject_uevent_env
[    3.747672] kobject: 'PNP0C0F:02' (cd8f0a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:02'
[    3.750101] device: 'PNP0C0F:03': device_add
[    3.751249] kobject: 'PNP0C0F:03' (cd8f0e24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.753690] bus: 'acpi': add device PNP0C0F:03
[    3.754897] PM: Adding info for acpi:PNP0C0F:03
[    3.756140] kobject: 'PNP0C0F:03' (cd8f0e24): kobject_uevent_env
[    3.757640] kobject: 'PNP0C0F:03' (cd8f0e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:03'
[    3.760107] device: 'PNP0C0F:04': device_add
[    3.761317] kobject: 'PNP0C0F:04' (cd8f1224): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.763769] bus: 'acpi': add device PNP0C0F:04
[    3.765029] PM: Adding info for acpi:PNP0C0F:04
[    3.766239] kobject: 'PNP0C0F:04' (cd8f1224): kobject_uevent_env
[    3.770006] kobject: 'PNP0C0F:04' (cd8f1224): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0C0F:04'
[    3.772606] device: 'LNXCPU:00': device_add
[    3.773804] kobject: 'LNXCPU:00' (cd8f1624): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.776266] bus: 'acpi': add device LNXCPU:00
[    3.777526] PM: Adding info for acpi:LNXCPU:00
[    3.778712] kobject: 'LNXCPU:00' (cd8f1624): kobject_uevent_env
[    3.780006] kobject: 'LNXCPU:00' (cd8f1624): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/LNXCPU:00'
[    3.782570] device: 'LNXCPU:01': device_add
[    3.783790] kobject: 'LNXCPU:01' (cd8f1a24): kobject_add_internal: parent: 'device:00', set: 'devices'
[    3.786157] bus: 'acpi': add device LNXCPU:01
[    3.787414] PM: Adding info for acpi:LNXCPU:01
[    3.788598] kobject: 'LNXCPU:01' (cd8f1a24): kobject_uevent_env
[    3.790006] kobject: 'LNXCPU:01' (cd8f1a24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/LNXCPU:01'
[    3.792586] device: 'device:23': device_add
[    3.793832] kobject: 'device:23' (cd8f1e24): kobject_add_internal: parent: 'LNXSYSTM:00', set: 'devices'
[    3.796265] bus: 'acpi': add device device:23
[    3.797491] PM: Adding info for acpi:device:23
[    3.798692] kobject: 'device:23' (cd8f1e24): kobject_uevent_env
[    3.800007] kobject: 'device:23' (cd8f1e24): fill_kobj_path: path = '/devices/LNXSYSTM:00/device:23'
[    3.802432] device: 'LNXPWRBN:00': device_add
[    3.803639] kobject: 'LNXPWRBN:00' (cd8f2224): kobject_add_internal: parent: 'LNXSYSTM:00', set: 'devices'
[    3.806099] bus: 'acpi': add device LNXPWRBN:00
[    3.807360] PM: Adding info for acpi:LNXPWRBN:00
[    3.808602] kobject: 'LNXPWRBN:00' (cd8f2224): kobject_uevent_env
[    3.810005] kobject: 'LNXPWRBN:00' (cd8f2224): fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXPWRBN:00'
[    3.816416] bus: 'acpi': add driver ec
[    3.817568] kobject: 'ec' (cd8e41e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.820015] kobject: 'ec' (cd8e41e0): kobject_uevent_env
[    3.821373] kobject: 'ec' (cd8e41e0): fill_kobj_path: path = '/bus/acpi/drivers/ec'
[    3.823530] debugfs: creating file 'acpi'
[    3.824763] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    3.827253] bus: 'acpi': add driver pci_root
[    3.828364] kobject: 'pci_root' (cd8e4300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    3.830008] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    3.832344] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    3.834506] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.836024] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    3.838125] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    3.840005] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    3.842251] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    3.844429] PCI: root bus 00: using default resources
[    3.845778] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    3.850009] device: 'pci0000:00': device_add
[    3.851204] kobject: 'pci0000:00' (cd8b3208): kobject_add_internal: parent: 'devices', set: 'devices'
[    3.853697] PM: Adding info for No Bus:pci0000:00
[    3.854965] kobject: 'pci0000:00' (cd8b3208): kobject_uevent_env
[    3.856487] kobject: 'pci0000:00' (cd8b3208): kobject_uevent_env: filter function caused the event to drop!
[    3.858914] device: '0000:00': device_add
[    3.860005] kobject: 'pci_bus' (cd8e5f80): kobject_add_internal: parent: 'pci0000:00', set: '(null)'
[    3.862402] kobject: '0000:00' (cd8b30ac): kobject_add_internal: parent: 'pci_bus', set: 'devices'
[    3.864814] PM: Adding info for No Bus:0000:00
[    3.866006] kobject: '0000:00' (cd8b30ac): kobject_uevent_env
[    3.867501] kobject: '0000:00' (cd8b30ac): fill_kobj_path: path = '/devices/pci0000:00/pci_bus/0000:00'
[    3.870006] PCI host bridge to bus 0000:00
[    3.871180] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    3.873395] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.874805] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    3.876312] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    3.878000] pci_bus 0000:00: scanning bus
[    3.879175] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.880013] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x9
[    3.881833] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.883857] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.887498] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    3.890551] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.892065] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x35
[    3.894107] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x14a
[    3.895585] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    3.897696] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    3.899415] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0xf
[    3.900124] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.903987] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    3.906707] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    3.914078] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    3.915940] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    3.918216] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    3.920828] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    3.926194] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    3.927940] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    3.930444] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    3.932661] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    3.938475] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    3.940860] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    3.943033] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    3.948869] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    3.950874] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    3.953117] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    3.958945] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    3.960879] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    3.963029] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    3.968860] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.970898] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    3.973163] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    3.980226] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.982555] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    3.984745] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    3.990221] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    3.992121] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    3.996420] pci_bus 0000:00: fixups for bus
[    3.997647] pci_bus 0000:00: bus scan returning with max=00
[    3.999042] pci_bus 0000:00: on NUMA node 0
[    4.000046] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    4.002113]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    4.004181] device: '0000:00:00.0': device_add
[    4.005392] kobject: '0000:00:00.0' (cd8f2468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.008178] bus: 'pci': add device 0000:00:00.0
[    4.009441] PM: Adding info for pci:0000:00:00.0
[    4.010005] kobject: '0000:00:00.0' (cd8f2468): kobject_uevent_env
[    4.011521] kobject: '0000:00:00.0' (cd8f2468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.0'
[    4.014127] device: '0000:00:01.0': device_add
[    4.015465] kobject: '0000:00:01.0' (cd8f2868): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.018303] bus: 'pci': add device 0000:00:01.0
[    4.020026] PM: Adding info for pci:0000:00:01.0
[    4.021243] kobject: '0000:00:01.0' (cd8f2868): kobject_uevent_env
[    4.022800] kobject: '0000:00:01.0' (cd8f2868): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0'
[    4.025197] device: '0000:00:01.1': device_add
[    4.026424] kobject: '0000:00:01.1' (cd8f2c68): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.030007] bus: 'pci': add device 0000:00:01.1
[    4.031369] PM: Adding info for pci:0000:00:01.1
[    4.032592] kobject: '0000:00:01.1' (cd8f2c68): kobject_uevent_env
[    4.034074] kobject: '0000:00:01.1' (cd8f2c68): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.1'
[    4.036648] device: '0000:00:01.3': device_add
[    4.037915] kobject: '0000:00:01.3' (cd8f3068): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.040295] bus: 'pci': add device 0000:00:01.3
[    4.041658] PM: Adding info for pci:0000:00:01.3
[    4.042928] kobject: '0000:00:01.3' (cd8f3068): kobject_uevent_env
[    4.044489] kobject: '0000:00:01.3' (cd8f3068): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.3'
[    4.046943] device: '0000:00:02.0': device_add
[    4.048135] kobject: '0000:00:02.0' (cd8f3468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.050304] bus: 'pci': add device 0000:00:02.0
[    4.051599] PM: Adding info for pci:0000:00:02.0
[    4.052850] kobject: '0000:00:02.0' (cd8f3468): kobject_uevent_env
[    4.054374] kobject: '0000:00:02.0' (cd8f3468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0'
[    4.056737] device: '0000:00:03.0': device_add
[    4.058019] kobject: '0000:00:03.0' (cd8f3868): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.060299] bus: 'pci': add device 0000:00:03.0
[    4.061562] PM: Adding info for pci:0000:00:03.0
[    4.062795] kobject: '0000:00:03.0' (cd8f3868): kobject_uevent_env
[    4.064296] kobject: '0000:00:03.0' (cd8f3868): fill_kobj_path: path = '/devices/pci0000:00/0000:00:03.0'
[    4.066863] device: '0000:00:04.0': device_add
[    4.068111] kobject: '0000:00:04.0' (cd8f3c68): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.070326] bus: 'pci': add device 0000:00:04.0
[    4.071579] PM: Adding info for pci:0000:00:04.0
[    4.072842] kobject: '0000:00:04.0' (cd8f3c68): kobject_uevent_env
[    4.074353] kobject: '0000:00:04.0' (cd8f3c68): fill_kobj_path: path = '/devices/pci0000:00/0000:00:04.0'
[    4.076874] device: '0000:00:05.0': device_add
[    4.080004] kobject: '0000:00:05.0' (cd8f4068): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.082783] bus: 'pci': add device 0000:00:05.0
[    4.084013] PM: Adding info for pci:0000:00:05.0
[    4.085274] kobject: '0000:00:05.0' (cd8f4068): kobject_uevent_env
[    4.086787] kobject: '0000:00:05.0' (cd8f4068): fill_kobj_path: path = '/devices/pci0000:00/0000:00:05.0'
[    4.089300] device: '0000:00:06.0': device_add
[    4.090005] kobject: '0000:00:06.0' (cd8f4468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.092747] bus: 'pci': add device 0000:00:06.0
[    4.093970] PM: Adding info for pci:0000:00:06.0
[    4.095174] kobject: '0000:00:06.0' (cd8f4468): kobject_uevent_env
[    4.096723] kobject: '0000:00:06.0' (cd8f4468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:06.0'
[    4.099087] device: '0000:00:07.0': device_add
[    4.100010] kobject: '0000:00:07.0' (cd8f4868): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.102716] bus: 'pci': add device 0000:00:07.0
[    4.103946] PM: Adding info for pci:0000:00:07.0
[    4.105161] kobject: '0000:00:07.0' (cd8f4868): kobject_uevent_env
[    4.106628] kobject: '0000:00:07.0' (cd8f4868): fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
[    4.110010] device: '0000:00:08.0': device_add
[    4.111177] kobject: '0000:00:08.0' (cd8f4c68): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.117379] bus: 'pci': add device 0000:00:08.0
[    4.118587] PM: Adding info for pci:0000:00:08.0
[    4.120004] kobject: '0000:00:08.0' (cd8f4c68): kobject_uevent_env
[    4.121556] kobject: '0000:00:08.0' (cd8f4c68): fill_kobj_path: path = '/devices/pci0000:00/0000:00:08.0'
[    4.123998] device: '0000:00:09.0': device_add
[    4.125227] kobject: '0000:00:09.0' (cd8f5068): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.128030] bus: 'pci': add device 0000:00:09.0
[    4.129271] PM: Adding info for pci:0000:00:09.0
[    4.130005] kobject: '0000:00:09.0' (cd8f5068): kobject_uevent_env
[    4.131514] kobject: '0000:00:09.0' (cd8f5068): fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
[    4.134064] device: '0000:00:0a.0': device_add
[    4.135299] kobject: '0000:00:0a.0' (cd8f5468): kobject_add_internal: parent: 'pci0000:00', set: 'devices'
[    4.138051] bus: 'pci': add device 0000:00:0a.0
[    4.139372] PM: Adding info for pci:0000:00:0a.0
[    4.140005] kobject: '0000:00:0a.0' (cd8f5468): kobject_uevent_env
[    4.141499] kobject: '0000:00:0a.0' (cd8f5468): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0a.0'
[    4.144060] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    4.145693] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    4.147843] kobject: 'pci_root' (cd8e4300): kobject_uevent_env
[    4.150008] kobject: 'pci_root' (cd8e4300): fill_kobj_path: path = '/bus/acpi/drivers/pci_root'
[    4.152298] bus: 'acpi': add driver pci_link
[    4.153454] kobject: 'pci_link' (cd8e4960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.155759] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    4.157989] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    4.160065] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    4.162019] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    4.163653] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    4.165729] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    4.168000] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    4.170057] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    4.172030] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    4.173678] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    4.175801] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    4.178087] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    4.180065] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    4.182044] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    4.183678] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    4.185665] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    4.187857] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    4.190055] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    4.191992] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    4.193645] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    4.195713] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    4.197962] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    4.200063] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    4.201977] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    4.203558] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    4.205627] kobject: 'pci_link' (cd8e4960): kobject_uevent_env
[    4.207226] kobject: 'pci_link' (cd8e4960): fill_kobj_path: path = '/bus/acpi/drivers/pci_link'
[    4.210017] kobject: 'pnp' (cd8a880c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.212229] kobject: 'pnp' (cd8a880c): kobject_uevent_env
[    4.213579] kobject: 'pnp' (cd8a880c): fill_kobj_path: path = '/bus/pnp'
[    4.215144] kobject: 'devices' (cd8fea4c): kobject_add_internal: parent: 'pnp', set: '<NULL>'
[    4.217447] kobject: 'devices' (cd8fea4c): kobject_uevent_env
[    4.218848] kobject: 'devices' (cd8fea4c): kobject_uevent_env: filter function caused the event to drop!
[    4.220006] kobject: 'drivers' (cd8feacc): kobject_add_internal: parent: 'pnp', set: '<NULL>'
[    4.222247] kobject: 'drivers' (cd8feacc): kobject_uevent_env
[    4.223702] kobject: 'drivers' (cd8feacc): kobject_uevent_env: filter function caused the event to drop!
[    4.226103] bus: 'pnp': registered
[    4.227220] bus: 'platform': add driver reg-fixed-voltage
[    4.230005] kobject: 'reg-fixed-voltage' (cd8e49c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.232458] kobject: 'reg-fixed-voltage' (cd8e49c0): kobject_uevent_env
[    4.234039] kobject: 'reg-fixed-voltage' (cd8e49c0): fill_kobj_path: path = '/bus/platform/drivers/reg-fixed-voltage'
[    4.236679] bus: 'i2c': add driver ad5398
[    4.237838] kobject: 'ad5398' (cd8e4a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.240009] kobject: 'ad5398' (cd8e4a20): kobject_uevent_env
[    4.241450] kobject: 'ad5398' (cd8e4a20): fill_kobj_path: path = '/bus/i2c/drivers/ad5398'
[    4.243582] i2c-core: driver [ad5398] registered
[    4.244910] bus: 'i2c': add driver max8649
[    4.246056] kobject: 'max8649' (cd8e4a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.248434] kobject: 'max8649' (cd8e4a80): kobject_uevent_env
[    4.250006] kobject: 'max8649' (cd8e4a80): fill_kobj_path: path = '/bus/i2c/drivers/max8649'
[    4.252323] i2c-core: driver [max8649] registered
[    4.253646] bus: 'i2c': add driver max8660
[    4.254792] kobject: 'max8660' (cd8e4ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.257130] kobject: 'max8660' (cd8e4ae0): kobject_uevent_env
[    4.258584] kobject: 'max8660' (cd8e4ae0): fill_kobj_path: path = '/bus/i2c/drivers/max8660'
[    4.260006] i2c-core: driver [max8660] registered
[    4.261255] bus: 'i2c': add driver tps65023
[    4.262437] kobject: 'tps65023' (cd8e4b40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.264787] kobject: 'tps65023' (cd8e4b40): kobject_uevent_env
[    4.266246] kobject: 'tps65023' (cd8e4b40): fill_kobj_path: path = '/bus/i2c/drivers/tps65023'
[    4.270006] i2c-core: driver [tps65023] registered
[    4.271314] bus: 'platform': add driver tps6507x-pmic
[    4.272609] kobject: 'tps6507x-pmic' (cd8e4ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.275071] kobject: 'tps6507x-pmic' (cd8e4ba0): kobject_uevent_env
[    4.276604] kobject: 'tps6507x-pmic' (cd8e4ba0): fill_kobj_path: path = '/bus/platform/drivers/tps6507x-pmic'
[    4.279146] bus: 'platform': add driver tps65912-pmic
[    4.280005] kobject: 'tps65912-pmic' (cd8e4c00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.282456] kobject: 'tps65912-pmic' (cd8e4c00): kobject_uevent_env
[    4.283939] kobject: 'tps65912-pmic' (cd8e4c00): fill_kobj_path: path = '/bus/platform/drivers/tps65912-pmic'
[    4.286416] bus: 'platform': add driver wm8994-ldo
[    4.287661] kobject: 'wm8994-ldo' (cd8e4c60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.290009] kobject: 'wm8994-ldo' (cd8e4c60): kobject_uevent_env
[    4.291447] kobject: 'wm8994-ldo' (cd8e4c60): fill_kobj_path: path = '/bus/platform/drivers/wm8994-ldo'
[    4.293965] device class 'misc': registering
[    4.295163] kobject: 'misc' (cd8a890c): kobject_add_internal: parent: 'class', set: 'class'
[    4.297369] kobject: 'misc' (cd8a890c): kobject_uevent_env
[    4.298742] kobject: 'misc' (cd8a890c): fill_kobj_path: path = '/class/misc'
[    4.300030] device: 'vga_arbiter': device_add
[    4.301236] kobject: 'misc' (cd8ff480): kobject_add_internal: parent: 'virtual', set: '(null)'
[    4.303464] kobject: 'vga_arbiter' (cd8b3408): kobject_add_internal: parent: 'misc', set: 'devices'
[    4.305836] PM: Adding info for No Bus:vga_arbiter
[    4.307214] kobject: 'vga_arbiter' (cd8b3408): kobject_uevent_env
[    4.308686] kobject: 'vga_arbiter' (cd8b3408): fill_kobj_path: path = '/devices/virtual/misc/vga_arbiter'
[    4.310035] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    4.312250] vgaarb: loaded
[    4.313206] vgaarb: bridge control possible 0000:00:02.0
[    4.314603] bus: 'i2c': add driver stmpe-i2c
[    4.315745] kobject: 'stmpe-i2c' (cd8e4de0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.320009] kobject: 'stmpe-i2c' (cd8e4de0): kobject_uevent_env
[    4.321499] kobject: 'stmpe-i2c' (cd8e4de0): fill_kobj_path: path = '/bus/i2c/drivers/stmpe-i2c'
[    4.323815] i2c-core: driver [stmpe-i2c] registered
[    4.325129] bus: 'i2c': add driver tc3589x
[    4.326278] kobject: 'tc3589x' (cd8e4e40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.328638] kobject: 'tc3589x' (cd8e4e40): kobject_uevent_env
[    4.330006] kobject: 'tc3589x' (cd8e4e40): fill_kobj_path: path = '/bus/i2c/drivers/tc3589x'
[    4.332236] i2c-core: driver [tc3589x] registered
[    4.333514] bus: 'i2c': add driver WM8400
[    4.334635] kobject: 'WM8400' (cd8e4ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.336975] kobject: 'WM8400' (cd8e4ea0): kobject_uevent_env
[    4.338393] kobject: 'WM8400' (cd8e4ea0): fill_kobj_path: path = '/bus/i2c/drivers/WM8400'
[    4.340006] i2c-core: driver [WM8400] registered
[    4.341249] bus: 'spi': add driver wm831x
[    4.346049] kobject: 'wm831x' (cd8e4f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.348356] kobject: 'wm831x' (cd8e4f00): kobject_uevent_env
[    4.350006] kobject: 'wm831x' (cd8e4f00): fill_kobj_path: path = '/bus/spi/drivers/wm831x'
[    4.352248] bus: 'i2c': add driver tps6105x
[    4.353492] kobject: 'tps6105x' (cd8e4f60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.355865] kobject: 'tps6105x' (cd8e4f60): kobject_uevent_env
[    4.357295] kobject: 'tps6105x' (cd8e4f60): fill_kobj_path: path = '/bus/i2c/drivers/tps6105x'
[    4.360005] i2c-core: driver [tps6105x] registered
[    4.361282] tps65010: version 2 May 2005
[    4.362476] bus: 'i2c': add driver tps65010
[    4.363595] kobject: 'tps65010' (cd900000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.365973] kobject: 'tps65010' (cd900000): kobject_uevent_env
[    4.367464] kobject: 'tps65010' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    4.370005] i2c-core: driver [tps65010] registered
[    4.371293] bus: 'i2c': remove driver tps65010
[    4.372510] kobject: 'tps65010' (cd900000): kobject_cleanup
[    4.373928] kobject: 'tps65010' (cd900000): auto cleanup 'remove' event
[    4.375485] kobject: 'tps65010' (cd900000): kobject_uevent_env
[    4.376945] kobject: 'tps65010' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    4.379246] kobject: 'tps65010' (cd900000): auto cleanup kobject_del
[    4.380008] sysfs tps65010: removing dir
[    4.381123] kobject: 'tps65010' (cd900000): calling ktype release
[    4.382592] driver: 'tps65010': driver_release
[    4.383734] kobject: 'tps65010': free name
[    4.384873] i2c-core: driver [tps65010] unregistered
[    4.386270] tps65010: re-probe ...
[    4.400016] bus: 'i2c': add driver tps65010
[    4.401163] kobject: 'tps65010' (cd900000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.403581] kobject: 'tps65010' (cd900000): kobject_uevent_env
[    4.405079] kobject: 'tps65010' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    4.407421] i2c-core: driver [tps65010] registered
[    4.408703] bus: 'i2c': remove driver tps65010
[    4.409865] kobject: 'tps65010' (cd900000): kobject_cleanup
[    4.410005] kobject: 'tps65010' (cd900000): auto cleanup 'remove' event
[    4.411589] kobject: 'tps65010' (cd900000): kobject_uevent_env
[    4.413077] kobject: 'tps65010' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    4.415361] kobject: 'tps65010' (cd900000): auto cleanup kobject_del
[    4.416853] sysfs tps65010: removing dir
[    4.418048] kobject: 'tps65010' (cd900000): calling ktype release
[    4.420004] driver: 'tps65010': driver_release
[    4.421236] kobject: 'tps65010': free name
[    4.422403] i2c-core: driver [tps65010] unregistered
[    4.423688] tps65010: re-probe ...
[    4.440008] bus: 'i2c': add driver tps65010
[    4.441199] kobject: 'tps65010' (cd900000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.443637] kobject: 'tps65010' (cd900000): kobject_uevent_env
[    4.445072] kobject: 'tps65010' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    4.447332] i2c-core: driver [tps65010] registered
[    4.448605] bus: 'i2c': remove driver tps65010
[    4.449815] kobject: 'tps65010' (cd900000): kobject_cleanup
[    4.450004] kobject: 'tps65010' (cd900000): auto cleanup 'remove' event
[    4.451607] kobject: 'tps65010' (cd900000): kobject_uevent_env
[    4.453015] kobject: 'tps65010' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps65010'
[    4.455214] kobject: 'tps65010' (cd900000): auto cleanup kobject_del
[    4.456738] sysfs tps65010: removing dir
[    4.457814] kobject: 'tps65010' (cd900000): calling ktype release
[    4.460003] driver: 'tps65010': driver_release
[    4.461173] kobject: 'tps65010': free name
[    4.462318] i2c-core: driver [tps65010] unregistered
[    4.463622] tps65010: no chip?
[    4.464599] bus: 'i2c': add driver tps6507x
[    4.465740] kobject: 'tps6507x' (cd900000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.468133] kobject: 'tps6507x' (cd900000): kobject_uevent_env
[    4.470006] kobject: 'tps6507x' (cd900000): fill_kobj_path: path = '/bus/i2c/drivers/tps6507x'
[    4.472220] i2c-core: driver [tps6507x] registered
[    4.473444] bus: 'spi': add driver tps65912
[    4.474656] kobject: 'tps65912' (cd900060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.477000] kobject: 'tps65912' (cd900060): kobject_uevent_env
[    4.478374] kobject: 'tps65912' (cd900060): fill_kobj_path: path = '/bus/spi/drivers/tps65912'
[    4.480007] bus: 'i2c': add driver max8925
[    4.481251] kobject: 'max8925' (cd9000c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.483569] kobject: 'max8925' (cd9000c0): kobject_uevent_env
[    4.485027] kobject: 'max8925' (cd9000c0): fill_kobj_path: path = '/bus/i2c/drivers/max8925'
[    4.487251] i2c-core: driver [max8925] registered
[    4.488504] bus: 'i2c': add driver max8998
[    4.490005] kobject: 'max8998' (cd900120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.492229] kobject: 'max8998' (cd900120): kobject_uevent_env
[    4.493703] kobject: 'max8998' (cd900120): fill_kobj_path: path = '/bus/i2c/drivers/max8998'
[    4.495983] i2c-core: driver [max8998] registered
[    4.497254] bus: 'i2c': add driver pcf50633
[    4.498374] kobject: 'pcf50633' (cd900180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.500008] kobject: 'pcf50633' (cd900180): kobject_uevent_env
[    4.501416] kobject: 'pcf50633' (cd900180): fill_kobj_path: path = '/bus/i2c/drivers/pcf50633'
[    4.503773] i2c-core: driver [pcf50633] registered
[    4.505081] bus: 'i2c': add driver tps6586x
[    4.506262] kobject: 'tps6586x' (cd9001e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.508573] kobject: 'tps6586x' (cd9001e0): kobject_uevent_env
[    4.510012] kobject: 'tps6586x' (cd9001e0): fill_kobj_path: path = '/bus/i2c/drivers/tps6586x'
[    4.512357] i2c-core: driver [tps6586x] registered
[    4.513602] bus: 'i2c': add driver aat2870
[    4.514751] kobject: 'aat2870' (cd900240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.517070] kobject: 'aat2870' (cd900240): kobject_uevent_env
[    4.518635] kobject: 'aat2870' (cd900240): fill_kobj_path: path = '/bus/i2c/drivers/aat2870'
[    4.520006] i2c-core: driver [aat2870] registered
[    4.521431] device class 'scsi_host': registering
[    4.522751] kobject: 'scsi_host' (cd8a8c0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.525066] kobject: 'scsi_host' (cd8a8c0c): kobject_uevent_env
[    4.526576] kobject: 'scsi_host' (cd8a8c0c): fill_kobj_path: path = '/class/scsi_host'
[    4.530035] kobject: 'scsi' (cd8a8d0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.532230] kobject: 'scsi' (cd8a8d0c): kobject_uevent_env
[    4.533645] kobject: 'scsi' (cd8a8d0c): fill_kobj_path: path = '/bus/scsi'
[    4.535288] kobject: 'devices' (cd9041cc): kobject_add_internal: parent: 'scsi', set: '<NULL>'
[    4.537590] kobject: 'devices' (cd9041cc): kobject_uevent_env
[    4.539003] kobject: 'devices' (cd9041cc): kobject_uevent_env: filter function caused the event to drop!
[    4.540005] kobject: 'drivers' (cd90424c): kobject_add_internal: parent: 'scsi', set: '<NULL>'
[    4.542335] kobject: 'drivers' (cd90424c): kobject_uevent_env
[    4.543762] kobject: 'drivers' (cd90424c): kobject_uevent_env: filter function caused the event to drop!
[    4.546225] bus: 'scsi': registered
[    4.547278] device class 'scsi_device': registering
[    4.550006] kobject: 'scsi_device' (cd8a8e0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.552371] kobject: 'scsi_device' (cd8a8e0c): kobject_uevent_env
[    4.553838] kobject: 'scsi_device' (cd8a8e0c): fill_kobj_path: path = '/class/scsi_device'
[    4.556059] SCSI subsystem initialized
[    4.557152] ACPI: bus type scsi registered
[    4.558286] device class 'ata_link': registering
[    4.560006] kobject: 'ata_link' (cd8a8f0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.562397] kobject: 'ata_link' (cd8a8f0c): kobject_uevent_env
[    4.563831] kobject: 'ata_link' (cd8a8f0c): fill_kobj_path: path = '/class/ata_link'
[    4.565970] device class 'ata_port': registering
[    4.567308] kobject: 'ata_port' (cd90500c): kobject_add_internal: parent: 'class', set: 'class'
[    4.570007] kobject: 'ata_port' (cd90500c): kobject_uevent_env
[    4.571464] kobject: 'ata_port' (cd90500c): fill_kobj_path: path = '/class/ata_port'
[    4.573587] device class 'ata_device': registering
[    4.574896] kobject: 'ata_device' (cd90510c): kobject_add_internal: parent: 'class', set: 'class'
[    4.577210] kobject: 'ata_device' (cd90510c): kobject_uevent_env
[    4.578778] kobject: 'ata_device' (cd90510c): fill_kobj_path: path = '/class/ata_device'
[    4.580020] libata version 3.00 loaded.
[    4.581187] device class 'mdio_bus': registering
[    4.582387] kobject: 'mdio_bus' (cd90520c): kobject_add_internal: parent: 'class', set: 'class'
[    4.584835] kobject: 'mdio_bus' (cd90520c): kobject_uevent_env
[    4.586422] kobject: 'mdio_bus' (cd90520c): fill_kobj_path: path = '/class/mdio_bus'
[    4.588621] kobject: 'mdio_bus' (cd90530c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.590007] kobject: 'mdio_bus' (cd90530c): kobject_uevent_env
[    4.591477] kobject: 'mdio_bus' (cd90530c): fill_kobj_path: path = '/bus/mdio_bus'
[    4.597036] kobject: 'devices' (cd90454c): kobject_add_internal: parent: 'mdio_bus', set: '<NULL>'
[    4.600008] kobject: 'devices' (cd90454c): kobject_uevent_env
[    4.601449] kobject: 'devices' (cd90454c): kobject_uevent_env: filter function caused the event to drop!
[    4.603878] kobject: 'drivers' (cd9045cc): kobject_add_internal: parent: 'mdio_bus', set: '<NULL>'
[    4.606115] kobject: 'drivers' (cd9045cc): kobject_uevent_env
[    4.607589] kobject: 'drivers' (cd9045cc): kobject_uevent_env: filter function caused the event to drop!
[    4.610007] bus: 'mdio_bus': registered
[    4.611102] bus: 'mdio_bus': add driver Generic PHY
[    4.612335] kobject: 'Generic PHY' (cd9003c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.614787] kobject: 'Generic PHY' (cd9003c0): kobject_uevent_env
[    4.616315] kobject: 'Generic PHY' (cd9003c0): fill_kobj_path: path = '/bus/mdio_bus/drivers/Generic PHY'
[    4.620013] libphy: Generic PHY: Registered new driver
[    4.621352] device class 'pcmcia_socket': registering
[    4.622674] kobject: 'pcmcia_socket' (cd90540c): kobject_add_internal: parent: 'class', set: 'class'
[    4.625028] kobject: 'pcmcia_socket' (cd90540c): kobject_uevent_env
[    4.626577] kobject: 'pcmcia_socket' (cd90540c): fill_kobj_path: path = '/class/pcmcia_socket'
[    4.628840] debugfs: creating file 'usb'
[    4.630074] debugfs: creating file 'devices'
[    4.631251] ACPI: bus type usb registered
[    4.632429] kobject: 'usb' (cd90550c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.634601] kobject: 'usb' (cd90550c): kobject_uevent_env
[    4.635940] kobject: 'usb' (cd90550c): fill_kobj_path: path = '/bus/usb'
[    4.637607] kobject: 'devices' (cd90488c): kobject_add_internal: parent: 'usb', set: '<NULL>'
[    4.640006] kobject: 'devices' (cd90488c): kobject_uevent_env
[    4.641479] kobject: 'devices' (cd90488c): kobject_uevent_env: filter function caused the event to drop!
[    4.643885] kobject: 'drivers' (cd90490c): kobject_add_internal: parent: 'usb', set: '<NULL>'
[    4.646203] kobject: 'drivers' (cd90490c): kobject_uevent_env
[    4.647596] kobject: 'drivers' (cd90490c): kobject_uevent_env: filter function caused the event to drop!
[    4.650006] bus: 'usb': registered
[    4.651045] bus: 'usb': add driver usbfs
[    4.652167] kobject: 'usbfs' (cd900480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.654439] kobject: 'usbfs' (cd900480): kobject_uevent_env
[    4.655798] kobject: 'usbfs' (cd900480): fill_kobj_path: path = '/bus/usb/drivers/usbfs'
[    4.658096] usbcore: registered new interface driver usbfs
[    4.659460] bus: 'usb': add driver hub
[    4.660006] kobject: 'hub' (cd900540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.662232] kobject: 'hub' (cd900540): kobject_uevent_env
[    4.663690] kobject: 'hub' (cd900540): fill_kobj_path: path = '/bus/usb/drivers/hub'
[    4.665795] usbcore: registered new interface driver hub
[    4.667252] bus: 'usb': add driver usb
[    4.667252] kobject: 'usb' (cd9005a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.670008] kobject: 'usb' (cd9005a0): kobject_uevent_env
[    4.671396] kobject: 'usb' (cd9005a0): fill_kobj_path: path = '/bus/usb/drivers/usb'
[    4.673532] usbcore: registered new device driver usb
[    4.674882] device class 'udc': registering
[    4.676070] kobject: 'udc' (cd90560c): kobject_add_internal: parent: 'class', set: 'class'
[    4.678376] kobject: 'udc' (cd90560c): kobject_uevent_env
[    4.680006] kobject: 'udc' (cd90560c): fill_kobj_path: path = '/class/udc'
[    4.681709] kobject: 'serio' (cd90570c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.683923] kobject: 'serio' (cd90570c): kobject_uevent_env
[    4.685373] kobject: 'serio' (cd90570c): fill_kobj_path: path = '/bus/serio'
[    4.687014] kobject: 'devices' (cd904f8c): kobject_add_internal: parent: 'serio', set: '<NULL>'
[    4.690006] kobject: 'devices' (cd904f8c): kobject_uevent_env
[    4.691447] kobject: 'devices' (cd904f8c): kobject_uevent_env: filter function caused the event to drop!
[    4.693957] kobject: 'drivers' (cd90e00c): kobject_add_internal: parent: 'serio', set: '<NULL>'
[    4.696307] kobject: 'drivers' (cd90e00c): kobject_uevent_env
[    4.697713] kobject: 'drivers' (cd90e00c): kobject_uevent_env: filter function caused the event to drop!
[    4.700007] bus: 'serio': registered
[    4.701070] kobject: 'gameport' (cd90580c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.703314] kobject: 'gameport' (cd90580c): kobject_uevent_env
[    4.704795] kobject: 'gameport' (cd90580c): fill_kobj_path: path = '/bus/gameport'
[    4.706970] kobject: 'devices' (cd90e18c): kobject_add_internal: parent: 'gameport', set: '<NULL>'
[    4.710006] kobject: 'devices' (cd90e18c): kobject_uevent_env
[    4.711405] kobject: 'devices' (cd90e18c): kobject_uevent_env: filter function caused the event to drop!
[    4.713855] kobject: 'drivers' (cd90e20c): kobject_add_internal: parent: 'gameport', set: '<NULL>'
[    4.716267] kobject: 'drivers' (cd90e20c): kobject_uevent_env
[    4.717748] kobject: 'drivers' (cd90e20c): kobject_uevent_env: filter function caused the event to drop!
[    4.720006] bus: 'gameport': registered
[    4.721161] device class 'input': registering
[    4.722351] kobject: 'input' (cd90590c): kobject_add_internal: parent: 'class', set: 'class'
[    4.724593] kobject: 'input' (cd90590c): kobject_uevent_env
[    4.726044] kobject: 'input' (cd90590c): fill_kobj_path: path = '/class/input'
[    4.728142] bus: 'platform': add driver i2c-gpio
[    4.729381] kobject: 'i2c-gpio' (cd900780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.730010] kobject: 'i2c-gpio' (cd900780): kobject_uevent_env
[    4.731451] kobject: 'i2c-gpio' (cd900780): fill_kobj_path: path = '/bus/platform/drivers/i2c-gpio'
[    4.733863] device class 'power_supply': registering
[    4.735194] kobject: 'power_supply' (cd905a0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.737507] kobject: 'power_supply' (cd905a0c): kobject_uevent_env
[    4.740006] kobject: 'power_supply' (cd905a0c): fill_kobj_path: path = '/class/power_supply'
[    4.742264] device class 'hwmon': registering
[    4.743447] kobject: 'hwmon' (cd905b0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.745671] kobject: 'hwmon' (cd905b0c): kobject_uevent_env
[    4.747045] kobject: 'hwmon' (cd905b0c): fill_kobj_path: path = '/class/hwmon'
[    4.750014] device class 'watchdog': registering
[    4.751248] kobject: 'watchdog' (cd905c0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.753532] kobject: 'watchdog' (cd905c0c): kobject_uevent_env
[    4.755064] kobject: 'watchdog' (cd905c0c): fill_kobj_path: path = '/class/watchdog'
[    4.757317] md: sizeof(mdp_super_t) = 4096
[    4.757317] kobject: 'mmc' (cd905d0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.760006] kobject: 'mmc' (cd905d0c): kobject_uevent_env
[    4.761403] kobject: 'mmc' (cd905d0c): fill_kobj_path: path = '/bus/mmc'
[    4.763064] kobject: 'devices' (cd90e70c): kobject_add_internal: parent: 'mmc', set: '<NULL>'
[    4.765349] kobject: 'devices' (cd90e70c): kobject_uevent_env
[    4.766797] kobject: 'devices' (cd90e70c): kobject_uevent_env: filter function caused the event to drop!
[    4.770005] kobject: 'drivers' (cd90e78c): kobject_add_internal: parent: 'mmc', set: '<NULL>'
[    4.772263] kobject: 'drivers' (cd90e78c): kobject_uevent_env
[    4.773745] kobject: 'drivers' (cd90e78c): kobject_uevent_env: filter function caused the event to drop!
[    4.776154] bus: 'mmc': registered
[    4.777207] device class 'mmc_host': registering
[    4.778459] kobject: 'mmc_host' (cd905e0c): kobject_add_internal: parent: 'class', set: 'class'
[    4.780006] kobject: 'mmc_host' (cd905e0c): kobject_uevent_env
[    4.781426] kobject: 'mmc_host' (cd905e0c): fill_kobj_path: path = '/class/mmc_host'
[    4.783624] kobject: 'sdio' (cd905f0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    4.785808] kobject: 'sdio' (cd905f0c): kobject_uevent_env
[    4.787234] kobject: 'sdio' (cd905f0c): fill_kobj_path: path = '/bus/sdio'
[    4.790008] kobject: 'devices' (cd90e94c): kobject_add_internal: parent: 'sdio', set: '<NULL>'
[    4.792243] kobject: 'devices' (cd90e94c): kobject_uevent_env
[    4.793716] kobject: 'devices' (cd90e94c): kobject_uevent_env: filter function caused the event to drop!
[    4.796138] kobject: 'drivers' (cd90e9cc): kobject_add_internal: parent: 'sdio', set: '<NULL>'
[    4.798421] kobject: 'drivers' (cd90e9cc): kobject_uevent_env
[    4.799898] kobject: 'drivers' (cd90e9cc): kobject_uevent_env: filter function caused the event to drop!
[    4.800008] bus: 'sdio': registered
[    4.801106] device class 'leds': registering
[    4.802318] kobject: 'leds' (cd90f00c): kobject_add_internal: parent: 'class', set: 'class'
[    4.804583] kobject: 'leds' (cd90f00c): kobject_uevent_env
[    4.806010] kobject: 'leds' (cd90f00c): fill_kobj_path: path = '/class/leds'
[    4.810014] device class 'sound': registering
[    4.811266] kobject: 'sound' (cd90f10c): kobject_add_internal: parent: 'class', set: 'class'
[    4.813513] kobject: 'sound' (cd90f10c): kobject_uevent_env
[    4.814949] kobject: 'sound' (cd90f10c): fill_kobj_path: path = '/class/sound'
[    4.817040] PCI: Using ACPI for IRQ routing
[    4.818188] PCI: pci_cache_line_size set to 64 bytes
[    4.819593] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    4.820011] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    4.822144] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    4.824339] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    4.830006] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    4.832191] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    4.834544] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    4.836894] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    4.840006] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    4.842406] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    4.844571] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1fff flags 0x40200] (d=0, p=0)
[    4.846911] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    4.850006] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2fff flags 0x40200] (d=0, p=0)
[    4.852291] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    4.854558] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    4.857010] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    4.859215] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    4.860019] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    4.862320] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    4.864666] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    4.866942] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    4.870022] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700f flags 0x40200] (d=0, p=0)
[    4.872532] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    4.874048] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    4.875536] device class 'net': registering
[    4.876812] kobject: 'net' (cd90f20c): kobject_add_internal: parent: 'class', set: 'class'
[    4.880007] kobject: 'net' (cd90f20c): kobject_uevent_env
[    4.881411] kobject: 'net' (cd90f20c): fill_kobj_path: path = '/class/net'
[    4.883108] device: 'lo': device_add
[    4.884219] kobject: 'net' (cd90ec80): kobject_add_internal: parent: 'virtual', set: '(null)'
[    4.886443] kobject: 'lo' (cd898a34): kobject_add_internal: parent: 'net', set: 'devices'
[    4.888740] PM: Adding info for No Bus:lo
[    4.890004] kobject: 'lo' (cd898a34): kobject_uevent_env
[    4.891328] kobject: 'lo' (cd898a34): fill_kobj_path: path = '/devices/virtual/net/lo'
[    4.893440] kobject: 'queues' (cd920a4c): kobject_add_internal: parent: 'lo', set: '<NULL>'
[    4.895832] kobject: 'queues' (cd920a4c): kobject_uevent_env
[    4.897266] kobject: 'queues' (cd920a4c): kobject_uevent_env: filter function caused the event to drop!
[    4.900005] kobject: 'rx-0' (cd90ec48): kobject_add_internal: parent: 'queues', set: 'queues'
[    4.902314] kobject: 'rx-0' (cd90ec48): kobject_uevent_env
[    4.903692] kobject: 'rx-0' (cd90ec48): fill_kobj_path: path = '/devices/virtual/net/lo/queues/rx-0'
[    4.906104] kobject: 'tx-0' (cd90f30c): kobject_add_internal: parent: 'queues', set: 'queues'
[    4.908332] kobject: 'tx-0' (cd90f30c): kobject_uevent_env
[    4.909743] kobject: 'tx-0' (cd90f30c): fill_kobj_path: path = '/devices/virtual/net/lo/queues/tx-0'
[    4.910153] NET: Registered protocol family 23
[    4.911397] Bluetooth: Core ver 2.16
[    4.912437] debugfs: creating file 'bluetooth'
[    4.913706] device class 'bluetooth': registering
[    4.914939] kobject: 'bluetooth' (cd90f60c): kobject_add_internal: parent: 'class', set: 'class'
[    4.917286] kobject: 'bluetooth' (cd90f60c): kobject_uevent_env
[    4.920005] kobject: 'bluetooth' (cd90f60c): fill_kobj_path: path = '/class/bluetooth'
[    4.922156] NET: Registered protocol family 31
[    4.923387] Bluetooth: HCI device and connection manager initialized
[    4.924890] Bluetooth: HCI socket layer initialized
[    4.926211] Bluetooth: L2CAP socket layer initialized
[    4.927545] debugfs: creating file 'l2cap'
[    4.928698] debugfs: creating file 'sco'
[    4.930006] Bluetooth: SCO socket layer initialized
[    4.931289] NET: Registered protocol family 8
[    4.932467] NET: Registered protocol family 20
[    4.933677] device class 'atm': registering
[    4.934863] kobject: 'atm' (cd90f70c): kobject_add_internal: parent: 'class', set: 'class'
[    4.937175] kobject: 'atm' (cd90f70c): kobject_uevent_env
[    4.938541] kobject: 'atm' (cd90f70c): fill_kobj_path: path = '/class/atm'
[    4.940015] doing fs, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    4.947843] doing fs: hung_task_panic='1'
[    4.949052] doing fs: bisect-reboot='(null)'
[    4.950037] doing fs: i386-randconfig-b064='(null)'
[    4.951371] doing fs: branch='mfd/for-next'
[    4.952562] doing fs: dyndbg='+p'
[    4.953591] doing fs: log_buf_len='8M'
[    4.954718] doing fs: ignore_loglevel='(null)'
[    4.955967] doing fs: debug='(null)'
[    4.957119] doing fs: sched_debug='(null)'
[    4.958283] doing fs: apic='debug'
[    4.960032] doing fs: dynamic_printk='(null)'
[    4.961257] doing fs: sysrq_always_enabled='(null)'
[    4.962535] doing fs: prompt_ramdisk='0'
[    4.963744] doing fs: console='ttyS0,115200'
[    4.964961] doing fs: console='tty0'
[    4.966053] doing fs: vga='normal'
[    4.967146] doing fs: root='/dev/ram0'
[    4.968240] doing fs: rw='(null)'
[    4.969276] doing fs: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    4.970051] Switching to clocksource hpet
[    4.971401] debugfs: creating file 'dynamic_debug'
[    4.972850] debugfs: creating file 'control'
[    4.974002] bus: 'pnp': add driver system
[    4.975280] kobject: 'system' (cd922120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    4.977684] kobject: 'system' (cd922120): kobject_uevent_env
[    4.977936] kobject: 'system' (cd922120): fill_kobj_path: path = '/bus/pnp/drivers/system'
[    4.980227] pnp: PnP ACPI init
[    4.981174] device: 'pnp0': device_add
[    4.982230] kobject: 'pnp0' (c1947950): kobject_add_internal: parent: 'devices', set: 'devices'
[    4.984556] PM: Adding info for No Bus:pnp0
[    4.985696] kobject: 'pnp0' (c1947950): kobject_uevent_env
[    4.987098] kobject: 'pnp0' (c1947950): kobject_uevent_env: filter function caused the event to drop!
[    4.989420] ACPI: bus type pnp registered
[    4.990646] pnp 00:00: [bus 00-ff]
[    4.991858] pnp 00:00: [io  0x0cf8-0x0cff]
[    4.993000] pnp 00:00: [io  0x0000-0x0cf7 window]
[    4.994268] pnp 00:00: [io  0x0d00-0xffff window]
[    4.995491] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    4.996903] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    4.998297] pnp 00:00: ACPI device not found in pnpacpi_can_wakeup!
[    4.999855] device: '00:00': device_add
[    5.001003] kobject: '00:00' (cd8b3a08): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.003314] bus: 'pnp': add device 00:00
[    5.004458] PM: Adding info for pnp:00:00
[    5.005600] kobject: '00:00' (cd8b3a08): kobject_uevent_env
[    5.007032] kobject: '00:00' (cd8b3a08): fill_kobj_path: path = '/devices/pnp0/00:00'
[    5.009180] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    5.010788] pnp 00:01: [io  0x0070-0x0071]
[    5.012007] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    5.014207] pnp 00:01: [irq 8]
[    5.015216] pnp 00:01: [io  0x0072-0x0077]
[    5.016355] pnp 00:01: ACPI device not found in pnpacpi_can_wakeup!
[    5.017836] device: '00:01': device_add
[    5.018920] kobject: '00:01' (cd8b3c08): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.021239] bus: 'pnp': add device 00:01
[    5.022346] PM: Adding info for pnp:00:01
[    5.023466] kobject: '00:01' (cd8b3c08): kobject_uevent_env
[    5.024865] kobject: '00:01' (cd8b3c08): fill_kobj_path: path = '/devices/pnp0/00:01'
[    5.026983] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.028543] pnp 00:02: [io  0x0060]
[    5.029578] pnp 00:02: [io  0x0064]
[    5.030832] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    5.032930] pnp 00:02: [irq 1]
[    5.033916] pnp 00:02: ACPI device not found in pnpacpi_can_wakeup!
[    5.035381] device: '00:02': device_add
[    5.036584] kobject: '00:02' (cd8b3e08): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.038789] bus: 'pnp': add device 00:02
[    5.043533] PM: Adding info for pnp:00:02
[    5.044649] kobject: '00:02' (cd8b3e08): kobject_uevent_env
[    5.046012] kobject: '00:02' (cd8b3e08): fill_kobj_path: path = '/devices/pnp0/00:02'
[    5.048217] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    5.049834] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    5.052099] pnp 00:03: [irq 12]
[    5.053091] pnp 00:03: ACPI device not found in pnpacpi_can_wakeup!
[    5.054675] device: '00:03': device_add
[    5.055789] kobject: '00:03' (cd930008): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.058054] bus: 'pnp': add device 00:03
[    5.059200] PM: Adding info for pnp:00:03
[    5.060410] kobject: '00:03' (cd930008): kobject_uevent_env
[    5.061777] kobject: '00:03' (cd930008): fill_kobj_path: path = '/devices/pnp0/00:03'
[    5.064000] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    5.065581] pnp 00:04: [io  0x03f2-0x03f5]
[    5.066785] pnp 00:04: [io  0x03f7]
[    5.067823] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    5.069925] pnp 00:04: [irq 6]
[    5.070992] pnp 00:04: [dma 2]
[    5.071971] pnp 00:04: ACPI device not found in pnpacpi_can_wakeup!
[    5.073442] device: '00:04': device_add
[    5.074532] kobject: '00:04' (cd930208): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.076712] bus: 'pnp': add device 00:04
[    5.078033] PM: Adding info for pnp:00:04
[    5.079150] kobject: '00:04' (cd930208): kobject_uevent_env
[    5.080601] kobject: '00:04' (cd930208): fill_kobj_path: path = '/devices/pnp0/00:04'
[    5.082765] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    5.084357] pnp 00:05: [io  0x0378-0x037f]
[    5.085539] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    5.087778] pnp 00:05: [irq 7]
[    5.088751] pnp 00:05: ACPI device not found in pnpacpi_can_wakeup!
[    5.090331] device: '00:05': device_add
[    5.091435] kobject: '00:05' (cd930408): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.093694] bus: 'pnp': add device 00:05
[    5.094832] PM: Adding info for pnp:00:05
[    5.095924] kobject: '00:05' (cd930408): kobject_uevent_env
[    5.097340] kobject: '00:05' (cd930408): fill_kobj_path: path = '/devices/pnp0/00:05'
[    5.099497] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    5.101176] pnp 00:06: [io  0x03f8-0x03ff]
[    5.102303] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    5.104482] pnp 00:06: [irq 4]
[    5.105444] pnp 00:06: ACPI device not found in pnpacpi_can_wakeup!
[    5.106933] device: '00:06': device_add
[    5.108070] kobject: '00:06' (cd930608): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.110348] bus: 'pnp': add device 00:06
[    5.111464] PM: Adding info for pnp:00:06
[    5.112604] kobject: '00:06' (cd930608): kobject_uevent_env
[    5.113971] kobject: '00:06' (cd930608): fill_kobj_path: path = '/devices/pnp0/00:06'
[    5.116070] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.117862] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    5.119108] pnp 00:07: ACPI device not found in pnpacpi_can_wakeup!
[    5.120681] device: '00:07': device_add
[    5.121895] kobject: '00:07' (cd930808): kobject_add_internal: parent: 'pnp0', set: 'devices'
[    5.124197] bus: 'pnp': add device 00:07
[    5.125361] PM: Adding info for pnp:00:07
[    5.126485] kobject: '00:07' (cd930808): kobject_uevent_env
[    5.127889] kobject: '00:07' (cd930808): fill_kobj_path: path = '/devices/pnp0/00:07'
[    5.130154] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    5.131882] pnp: PnP ACPI: found 8 devices
[    5.133021] ACPI: ACPI bus type pnp unregistered
[    5.134303] device class 'mem': registering
[    5.135495] kobject: 'mem' (cd90fa0c): kobject_add_internal: parent: 'class', set: 'class'
[    5.137742] kobject: 'mem' (cd90fa0c): kobject_uevent_env
[    5.139215] kobject: 'mem' (cd90fa0c): fill_kobj_path: path = '/class/mem'
[    5.140855] device: 'mem': device_add
[    5.141914] kobject: 'mem' (cd924980): kobject_add_internal: parent: 'virtual', set: '(null)'
[    5.144259] kobject: 'mem' (cd930a08): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.146466] PM: Adding info for No Bus:mem
[    5.147617] kobject: 'mem' (cd930a08): kobject_uevent_env
[    5.148937] kobject: 'mem' (cd930a08): fill_kobj_path: path = '/devices/virtual/mem/mem'
[    5.151184] device: 'null': device_add
[    5.152268] kobject: 'null' (cd930c08): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.154442] PM: Adding info for No Bus:null
[    5.155583] kobject: 'null' (cd930c08): kobject_uevent_env
[    5.157067] kobject: 'null' (cd930c08): fill_kobj_path: path = '/devices/virtual/mem/null'
[    5.159472] device: 'port': device_add
[    5.160693] kobject: 'port' (cd930e08): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.162942] PM: Adding info for No Bus:port
[    5.164082] kobject: 'port' (cd930e08): kobject_uevent_env
[    5.165474] kobject: 'port' (cd930e08): fill_kobj_path: path = '/devices/virtual/mem/port'
[    5.167734] device: 'zero': device_add
[    5.168830] kobject: 'zero' (cd931008): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.171263] PM: Adding info for No Bus:zero
[    5.172477] kobject: 'zero' (cd931008): kobject_uevent_env
[    5.173878] kobject: 'zero' (cd931008): fill_kobj_path: path = '/devices/virtual/mem/zero'
[    5.176109] device: 'full': device_add
[    5.177273] kobject: 'full' (cd931208): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.179511] PM: Adding info for No Bus:full
[    5.180751] kobject: 'full' (cd931208): kobject_uevent_env
[    5.182156] kobject: 'full' (cd931208): fill_kobj_path: path = '/devices/virtual/mem/full'
[    5.184451] device: 'random': device_add
[    5.185538] kobject: 'random' (cd931408): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.187840] PM: Adding info for No Bus:random
[    5.189032] kobject: 'random' (cd931408): kobject_uevent_env
[    5.190574] kobject: 'random' (cd931408): fill_kobj_path: path = '/devices/virtual/mem/random'
[    5.192888] device: 'urandom': device_add
[    5.194080] kobject: 'urandom' (cd931608): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.196304] PM: Adding info for No Bus:urandom
[    5.197517] kobject: 'urandom' (cd931608): kobject_uevent_env
[    5.199000] kobject: 'urandom' (cd931608): fill_kobj_path: path = '/devices/virtual/mem/urandom'
[    5.201354] device: 'kmsg': device_add
[    5.202419] kobject: 'kmsg' (cd931808): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.204696] PM: Adding info for No Bus:kmsg
[    5.205815] kobject: 'kmsg' (cd931808): kobject_uevent_env
[    5.207191] kobject: 'kmsg' (cd931808): fill_kobj_path: path = '/devices/virtual/mem/kmsg'
[    5.209370] device: 'oldmem': device_add
[    5.210645] kobject: 'oldmem' (cd931a08): kobject_add_internal: parent: 'mem', set: 'devices'
[    5.212935] PM: Adding info for No Bus:oldmem
[    5.214141] kobject: 'oldmem' (cd931a08): kobject_uevent_env
[    5.215524] kobject: 'oldmem' (cd931a08): fill_kobj_path: path = '/devices/virtual/mem/oldmem'
[    5.217892] device: 'tty': device_add
[    5.218934] kobject: 'tty' (cd926500): kobject_add_internal: parent: 'virtual', set: '(null)'
[    5.221170] kobject: 'tty' (cd931c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.223560] PM: Adding info for No Bus:tty
[    5.224709] kobject: 'tty' (cd931c08): kobject_uevent_env
[    5.226041] kobject: 'tty' (cd931c08): fill_kobj_path: path = '/devices/virtual/tty/tty'
[    5.228299] device: 'console': device_add
[    5.229447] kobject: 'console' (cd931e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.231824] PM: Adding info for No Bus:console
[    5.233004] kobject: 'console' (cd931e08): kobject_uevent_env
[    5.234478] kobject: 'console' (cd931e08): fill_kobj_path: path = '/devices/virtual/tty/console'
[    5.236820] device: 'tty0': device_add
[    5.237954] kobject: 'tty0' (cd932008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.240243] PM: Adding info for No Bus:tty0
[    5.241369] kobject: 'tty0' (cd932008): kobject_uevent_env
[    5.242717] kobject: 'tty0' (cd932008): fill_kobj_path: path = '/devices/virtual/tty/tty0'
[    5.245034] device class 'vc': registering
[    5.246198] kobject: 'vc' (cd90fb0c): kobject_add_internal: parent: 'class', set: 'class'
[    5.248415] kobject: 'vc' (cd90fb0c): kobject_uevent_env
[    5.249749] kobject: 'vc' (cd90fb0c): fill_kobj_path: path = '/class/vc'
[    5.251436] device: 'vcs': device_add
[    5.252503] kobject: 'vc' (cd926fc0): kobject_add_internal: parent: 'virtual', set: '(null)'
[    5.254728] kobject: 'vcs' (cd932208): kobject_add_internal: parent: 'vc', set: 'devices'
[    5.256873] PM: Adding info for No Bus:vcs
[    5.258209] kobject: 'vcs' (cd932208): kobject_uevent_env
[    5.263047] kobject: 'vcs' (cd932208): fill_kobj_path: path = '/devices/virtual/vc/vcs'
[    5.265202] device: 'vcsa': device_add
[    5.266336] kobject: 'vcsa' (cd932408): kobject_add_internal: parent: 'vc', set: 'devices'
[    5.268526] PM: Adding info for No Bus:vcsa
[    5.269671] kobject: 'vcsa' (cd932408): kobject_uevent_env
[    5.271144] kobject: 'vcsa' (cd932408): fill_kobj_path: path = '/devices/virtual/vc/vcsa'
[    5.273322] device: 'vcs1': device_add
[    5.274466] kobject: 'vcs1' (cd932608): kobject_add_internal: parent: 'vc', set: 'devices'
[    5.276695] PM: Adding info for No Bus:vcs1
[    5.277798] kobject: 'vcs1' (cd932608): kobject_uevent_env
[    5.279210] kobject: 'vcs1' (cd932608): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
[    5.281470] device: 'vcsa1': device_add
[    5.282583] kobject: 'vcsa1' (cd932808): kobject_add_internal: parent: 'vc', set: 'devices'
[    5.284800] PM: Adding info for No Bus:vcsa1
[    5.285931] kobject: 'vcsa1' (cd932808): kobject_uevent_env
[    5.287351] kobject: 'vcsa1' (cd932808): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
[    5.289577] device: 'tty1': device_add
[    5.290703] kobject: 'tty1' (cd932c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.292895] PM: Adding info for No Bus:tty1
[    5.294056] kobject: 'tty1' (cd932c08): kobject_uevent_env
[    5.295426] kobject: 'tty1' (cd932c08): fill_kobj_path: path = '/devices/virtual/tty/tty1'
[    5.297756] device: 'tty2': device_add
[    5.298852] kobject: 'tty2' (cd932e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.301185] PM: Adding info for No Bus:tty2
[    5.302432] kobject: 'tty2' (cd932e08): kobject_uevent_env
[    5.303822] kobject: 'tty2' (cd932e08): fill_kobj_path: path = '/devices/virtual/tty/tty2'
[    5.306059] device: 'tty3': device_add
[    5.307203] kobject: 'tty3' (cd933008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.309520] PM: Adding info for No Bus:tty3
[    5.310756] kobject: 'tty3' (cd933008): kobject_uevent_env
[    5.312135] kobject: 'tty3' (cd933008): fill_kobj_path: path = '/devices/virtual/tty/tty3'
[    5.314398] device: 'tty4': device_add
[    5.315500] kobject: 'tty4' (cd933208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.317730] PM: Adding info for No Bus:tty4
[    5.318939] kobject: 'tty4' (cd933208): kobject_uevent_env
[    5.320334] kobject: 'tty4' (cd933208): fill_kobj_path: path = '/devices/virtual/tty/tty4'
[    5.322580] device: 'tty5': device_add
[    5.323706] kobject: 'tty5' (cd933408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.326006] PM: Adding info for No Bus:tty5
[    5.327135] kobject: 'tty5' (cd933408): kobject_uevent_env
[    5.328490] kobject: 'tty5' (cd933408): fill_kobj_path: path = '/devices/virtual/tty/tty5'
[    5.329865] device: 'tty6': device_add
[    5.330546] kobject: 'tty6' (cd933608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.331905] PM: Adding info for No Bus:tty6
[    5.332606] kobject: 'tty6' (cd933608): kobject_uevent_env
[    5.333420] kobject: 'tty6' (cd933608): fill_kobj_path: path = '/devices/virtual/tty/tty6'
[    5.334747] device: 'tty7': device_add
[    5.335390] kobject: 'tty7' (cd933808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.336745] PM: Adding info for No Bus:tty7
[    5.337430] kobject: 'tty7' (cd933808): kobject_uevent_env
[    5.338265] kobject: 'tty7' (cd933808): fill_kobj_path: path = '/devices/virtual/tty/tty7'
[    5.339614] device: 'tty8': device_add
[    5.340296] kobject: 'tty8' (cd933a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.341641] PM: Adding info for No Bus:tty8
[    5.342328] kobject: 'tty8' (cd933a08): kobject_uevent_env
[    5.343161] kobject: 'tty8' (cd933a08): fill_kobj_path: path = '/devices/virtual/tty/tty8'
[    5.344492] device: 'tty9': device_add
[    5.345156] kobject: 'tty9' (cd933c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.346492] PM: Adding info for No Bus:tty9
[    5.347197] kobject: 'tty9' (cd933c08): kobject_uevent_env
[    5.348033] kobject: 'tty9' (cd933c08): fill_kobj_path: path = '/devices/virtual/tty/tty9'
[    5.349353] device: 'tty10': device_add
[    5.350057] kobject: 'tty10' (cd933e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.351398] PM: Adding info for No Bus:tty10
[    5.352116] kobject: 'tty10' (cd933e08): kobject_uevent_env
[    5.352960] kobject: 'tty10' (cd933e08): fill_kobj_path: path = '/devices/virtual/tty/tty10'
[    5.354308] device: 'tty11': device_add
[    5.354978] kobject: 'tty11' (cd934008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.356319] PM: Adding info for No Bus:tty11
[    5.357030] kobject: 'tty11' (cd934008): kobject_uevent_env
[    5.357869] kobject: 'tty11' (cd934008): fill_kobj_path: path = '/devices/virtual/tty/tty11'
[    5.359196] device: 'tty12': device_add
[    5.359870] kobject: 'tty12' (cd934208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.361254] PM: Adding info for No Bus:tty12
[    5.361967] kobject: 'tty12' (cd934208): kobject_uevent_env
[    5.362810] kobject: 'tty12' (cd934208): fill_kobj_path: path = '/devices/virtual/tty/tty12'
[    5.364155] device: 'tty13': device_add
[    5.364821] kobject: 'tty13' (cd934408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.366157] PM: Adding info for No Bus:tty13
[    5.366874] kobject: 'tty13' (cd934408): kobject_uevent_env
[    5.367724] kobject: 'tty13' (cd934408): fill_kobj_path: path = '/devices/virtual/tty/tty13'
[    5.369052] device: 'tty14': device_add
[    5.369718] kobject: 'tty14' (cd934608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.371096] PM: Adding info for No Bus:tty14
[    5.371815] kobject: 'tty14' (cd934608): kobject_uevent_env
[    5.372652] kobject: 'tty14' (cd934608): fill_kobj_path: path = '/devices/virtual/tty/tty14'
[    5.373988] device: 'tty15': device_add
[    5.374656] kobject: 'tty15' (cd934808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.376004] PM: Adding info for No Bus:tty15
[    5.376715] kobject: 'tty15' (cd934808): kobject_uevent_env
[    5.377543] kobject: 'tty15' (cd934808): fill_kobj_path: path = '/devices/virtual/tty/tty15'
[    5.378901] device: 'tty16': device_add
[    5.379552] kobject: 'tty16' (cd934a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.380949] PM: Adding info for No Bus:tty16
[    5.381665] kobject: 'tty16' (cd934a08): kobject_uevent_env
[    5.382487] kobject: 'tty16' (cd934a08): fill_kobj_path: path = '/devices/virtual/tty/tty16'
[    5.383843] device: 'tty17': device_add
[    5.384496] kobject: 'tty17' (cd934c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.385849] PM: Adding info for No Bus:tty17
[    5.386540] kobject: 'tty17' (cd934c08): kobject_uevent_env
[    5.387380] kobject: 'tty17' (cd934c08): fill_kobj_path: path = '/devices/virtual/tty/tty17'
[    5.388740] device: 'tty18': device_add
[    5.389394] kobject: 'tty18' (cd934e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.390798] PM: Adding info for No Bus:tty18
[    5.391492] kobject: 'tty18' (cd934e08): kobject_uevent_env
[    5.392340] kobject: 'tty18' (cd934e08): fill_kobj_path: path = '/devices/virtual/tty/tty18'
[    5.393692] device: 'tty19': device_add
[    5.394344] kobject: 'tty19' (cd935008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.395705] PM: Adding info for No Bus:tty19
[    5.396401] kobject: 'tty19' (cd935008): kobject_uevent_env
[    5.397243] kobject: 'tty19' (cd935008): fill_kobj_path: path = '/devices/virtual/tty/tty19'
[    5.398593] device: 'tty20': device_add
[    5.399248] kobject: 'tty20' (cd935208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.400654] PM: Adding info for No Bus:tty20
[    5.401352] kobject: 'tty20' (cd935208): kobject_uevent_env
[    5.402195] kobject: 'tty20' (cd935208): fill_kobj_path: path = '/devices/virtual/tty/tty20'
[    5.403529] device: 'tty21': device_add
[    5.404203] kobject: 'tty21' (cd935408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.405543] PM: Adding info for No Bus:tty21
[    5.406252] kobject: 'tty21' (cd935408): kobject_uevent_env
[    5.407096] kobject: 'tty21' (cd935408): fill_kobj_path: path = '/devices/virtual/tty/tty21'
[    5.408445] device: 'tty22': device_add
[    5.409117] kobject: 'tty22' (cd935608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.410500] PM: Adding info for No Bus:tty22
[    5.411213] kobject: 'tty22' (cd935608): kobject_uevent_env
[    5.412056] kobject: 'tty22' (cd935608): fill_kobj_path: path = '/devices/virtual/tty/tty22'
[    5.413384] device: 'tty23': device_add
[    5.414052] kobject: 'tty23' (cd935808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.417394] PM: Adding info for No Bus:tty23
[    5.418108] kobject: 'tty23' (cd935808): kobject_uevent_env
[    5.418953] kobject: 'tty23' (cd935808): fill_kobj_path: path = '/devices/virtual/tty/tty23'
[    5.420329] device: 'tty24': device_add
[    5.421000] kobject: 'tty24' (cd935a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.422338] PM: Adding info for No Bus:tty24
[    5.423049] kobject: 'tty24' (cd935a08): kobject_uevent_env
[    5.423889] kobject: 'tty24' (cd935a08): fill_kobj_path: path = '/devices/virtual/tty/tty24'
[    5.425227] device: 'tty25': device_add
[    5.425891] kobject: 'tty25' (cd935c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.427231] PM: Adding info for No Bus:tty25
[    5.427943] kobject: 'tty25' (cd935c08): kobject_uevent_env
[    5.428784] kobject: 'tty25' (cd935c08): fill_kobj_path: path = '/devices/virtual/tty/tty25'
[    5.430158] device: 'tty26': device_add
[    5.430829] kobject: 'tty26' (cd935e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.432173] PM: Adding info for No Bus:tty26
[    5.432880] kobject: 'tty26' (cd935e08): kobject_uevent_env
[    5.433728] kobject: 'tty26' (cd935e08): fill_kobj_path: path = '/devices/virtual/tty/tty26'
[    5.435074] device: 'tty27': device_add
[    5.435747] kobject: 'tty27' (cd944008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.437087] PM: Adding info for No Bus:tty27
[    5.437797] kobject: 'tty27' (cd944008): kobject_uevent_env
[    5.438640] kobject: 'tty27' (cd944008): fill_kobj_path: path = '/devices/virtual/tty/tty27'
[    5.439976] device: 'tty28': device_add
[    5.440684] kobject: 'tty28' (cd944208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.442036] PM: Adding info for No Bus:tty28
[    5.442747] kobject: 'tty28' (cd944208): kobject_uevent_env
[    5.443889] kobject: 'tty28' (cd944208): fill_kobj_path: path = '/devices/virtual/tty/tty28'
[    5.445235] device: 'tty29': device_add
[    5.445902] kobject: 'tty29' (cd944408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.447241] PM: Adding info for No Bus:tty29
[    5.447949] kobject: 'tty29' (cd944408): kobject_uevent_env
[    5.448805] kobject: 'tty29' (cd944408): fill_kobj_path: path = '/devices/virtual/tty/tty29'
[    5.450186] device: 'tty30': device_add
[    5.450854] kobject: 'tty30' (cd944608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.452195] PM: Adding info for No Bus:tty30
[    5.452910] kobject: 'tty30' (cd944608): kobject_uevent_env
[    5.453874] kobject: 'tty30' (cd944608): fill_kobj_path: path = '/devices/virtual/tty/tty30'
[    5.455309] device: 'tty31': device_add
[    5.455973] kobject: 'tty31' (cd944808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.457332] PM: Adding info for No Bus:tty31
[    5.458051] kobject: 'tty31' (cd944808): kobject_uevent_env
[    5.458903] kobject: 'tty31' (cd944808): fill_kobj_path: path = '/devices/virtual/tty/tty31'
[    5.460277] device: 'tty32': device_add
[    5.460957] kobject: 'tty32' (cd944a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.462295] PM: Adding info for No Bus:tty32
[    5.463012] kobject: 'tty32' (cd944a08): kobject_uevent_env
[    5.463967] kobject: 'tty32' (cd944a08): fill_kobj_path: path = '/devices/virtual/tty/tty32'
[    5.465309] device: 'tty33': device_add
[    5.465978] kobject: 'tty33' (cd944c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.467321] PM: Adding info for No Bus:tty33
[    5.468042] kobject: 'tty33' (cd944c08): kobject_uevent_env
[    5.468893] kobject: 'tty33' (cd944c08): fill_kobj_path: path = '/devices/virtual/tty/tty33'
[    5.470276] device: 'tty34': device_add
[    5.470950] kobject: 'tty34' (cd944e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.472298] PM: Adding info for No Bus:tty34
[    5.473021] kobject: 'tty34' (cd944e08): kobject_uevent_env
[    5.474062] kobject: 'tty34' (cd944e08): fill_kobj_path: path = '/devices/virtual/tty/tty34'
[    5.475397] device: 'tty35': device_add
[    5.476059] kobject: 'tty35' (cd945008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.477397] PM: Adding info for No Bus:tty35
[    5.478103] kobject: 'tty35' (cd945008): kobject_uevent_env
[    5.478938] kobject: 'tty35' (cd945008): fill_kobj_path: path = '/devices/virtual/tty/tty35'
[    5.480310] device: 'tty36': device_add
[    5.480973] kobject: 'tty36' (cd945208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.482311] PM: Adding info for No Bus:tty36
[    5.483013] kobject: 'tty36' (cd945208): kobject_uevent_env
[    5.483969] kobject: 'tty36' (cd945208): fill_kobj_path: path = '/devices/virtual/tty/tty36'
[    5.485304] device: 'tty37': device_add
[    5.485966] kobject: 'tty37' (cd945408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.487298] PM: Adding info for No Bus:tty37
[    5.488004] kobject: 'tty37' (cd945408): kobject_uevent_env
[    5.488839] kobject: 'tty37' (cd945408): fill_kobj_path: path = '/devices/virtual/tty/tty37'
[    5.490213] device: 'tty38': device_add
[    5.490889] kobject: 'tty38' (cd945608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.492217] PM: Adding info for No Bus:tty38
[    5.492936] kobject: 'tty38' (cd945608): kobject_uevent_env
[    5.493920] kobject: 'tty38' (cd945608): fill_kobj_path: path = '/devices/virtual/tty/tty38'
[    5.495339] device: 'tty39': device_add
[    5.496017] kobject: 'tty39' (cd945808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.497367] PM: Adding info for No Bus:tty39
[    5.498083] kobject: 'tty39' (cd945808): kobject_uevent_env
[    5.498924] kobject: 'tty39' (cd945808): fill_kobj_path: path = '/devices/virtual/tty/tty39'
[    5.500301] device: 'tty40': device_add
[    5.500979] kobject: 'tty40' (cd945a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.502321] PM: Adding info for No Bus:tty40
[    5.503033] kobject: 'tty40' (cd945a08): kobject_uevent_env
[    5.503996] kobject: 'tty40' (cd945a08): fill_kobj_path: path = '/devices/virtual/tty/tty40'
[    5.505347] device: 'tty41': device_add
[    5.506016] kobject: 'tty41' (cd945c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.507354] PM: Adding info for No Bus:tty41
[    5.508069] kobject: 'tty41' (cd945c08): kobject_uevent_env
[    5.508933] kobject: 'tty41' (cd945c08): fill_kobj_path: path = '/devices/virtual/tty/tty41'
[    5.510312] device: 'tty42': device_add
[    5.510982] kobject: 'tty42' (cd945e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.512322] PM: Adding info for No Bus:tty42
[    5.513040] kobject: 'tty42' (cd945e08): kobject_uevent_env
[    5.513984] kobject: 'tty42' (cd945e08): fill_kobj_path: path = '/devices/virtual/tty/tty42'
[    5.515338] device: 'tty43': device_add
[    5.516012] kobject: 'tty43' (cd946008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.517363] PM: Adding info for No Bus:tty43
[    5.518075] kobject: 'tty43' (cd946008): kobject_uevent_env
[    5.518922] kobject: 'tty43' (cd946008): fill_kobj_path: path = '/devices/virtual/tty/tty43'
[    5.520297] device: 'tty44': device_add
[    5.520978] kobject: 'tty44' (cd946208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.522315] PM: Adding info for No Bus:tty44
[    5.523031] kobject: 'tty44' (cd946208): kobject_uevent_env
[    5.523981] kobject: 'tty44' (cd946208): fill_kobj_path: path = '/devices/virtual/tty/tty44'
[    5.525328] device: 'tty45': device_add
[    5.525997] kobject: 'tty45' (cd946408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.527336] PM: Adding info for No Bus:tty45
[    5.528043] kobject: 'tty45' (cd946408): kobject_uevent_env
[    5.528895] kobject: 'tty45' (cd946408): fill_kobj_path: path = '/devices/virtual/tty/tty45'
[    5.530261] device: 'tty46': device_add
[    5.530928] kobject: 'tty46' (cd946608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.532266] PM: Adding info for No Bus:tty46
[    5.532983] kobject: 'tty46' (cd946608): kobject_uevent_env
[    5.534002] kobject: 'tty46' (cd946608): fill_kobj_path: path = '/devices/virtual/tty/tty46'
[    5.535395] device: 'tty47': device_add
[    5.536065] kobject: 'tty47' (cd946808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.537416] PM: Adding info for No Bus:tty47
[    5.538129] kobject: 'tty47' (cd946808): kobject_uevent_env
[    5.538978] kobject: 'tty47' (cd946808): fill_kobj_path: path = '/devices/virtual/tty/tty47'
[    5.540349] device: 'tty48': device_add
[    5.541027] kobject: 'tty48' (cd946a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.542368] PM: Adding info for No Bus:tty48
[    5.543082] kobject: 'tty48' (cd946a08): kobject_uevent_env
[    5.544031] kobject: 'tty48' (cd946a08): fill_kobj_path: path = '/devices/virtual/tty/tty48'
[    5.545386] device: 'tty49': device_add
[    5.548071] kobject: 'tty49' (cd946c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.549424] PM: Adding info for No Bus:tty49
[    5.550168] kobject: 'tty49' (cd946c08): kobject_uevent_env
[    5.551016] kobject: 'tty49' (cd946c08): fill_kobj_path: path = '/devices/virtual/tty/tty49'
[    5.552365] device: 'tty50': device_add
[    5.553039] kobject: 'tty50' (cd946e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.554544] PM: Adding info for No Bus:tty50
[    5.555259] kobject: 'tty50' (cd946e08): kobject_uevent_env
[    5.556158] kobject: 'tty50' (cd946e08): fill_kobj_path: path = '/devices/virtual/tty/tty50'
[    5.557506] device: 'tty51': device_add
[    5.558171] kobject: 'tty51' (cd947008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.559517] PM: Adding info for No Bus:tty51
[    5.560270] kobject: 'tty51' (cd947008): kobject_uevent_env
[    5.561133] kobject: 'tty51' (cd947008): fill_kobj_path: path = '/devices/virtual/tty/tty51'
[    5.562471] device: 'tty52': device_add
[    5.563138] kobject: 'tty52' (cd947208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.564676] PM: Adding info for No Bus:tty52
[    5.565373] kobject: 'tty52' (cd947208): kobject_uevent_env
[    5.566212] kobject: 'tty52' (cd947208): fill_kobj_path: path = '/devices/virtual/tty/tty52'
[    5.567556] device: 'tty53': device_add
[    5.568222] kobject: 'tty53' (cd947408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.569595] PM: Adding info for No Bus:tty53
[    5.570333] kobject: 'tty53' (cd947408): kobject_uevent_env
[    5.571183] kobject: 'tty53' (cd947408): fill_kobj_path: path = '/devices/virtual/tty/tty53'
[    5.572520] device: 'tty54': device_add
[    5.573193] kobject: 'tty54' (cd947608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.574793] PM: Adding info for No Bus:tty54
[    5.575490] kobject: 'tty54' (cd947608): kobject_uevent_env
[    5.576339] kobject: 'tty54' (cd947608): fill_kobj_path: path = '/devices/virtual/tty/tty54'
[    5.577697] device: 'tty55': device_add
[    5.578350] kobject: 'tty55' (cd947808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.579716] PM: Adding info for No Bus:tty55
[    5.580447] kobject: 'tty55' (cd947808): kobject_uevent_env
[    5.581297] kobject: 'tty55' (cd947808): fill_kobj_path: path = '/devices/virtual/tty/tty55'
[    5.582646] device: 'tty56': device_add
[    5.583296] kobject: 'tty56' (cd947a08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.584931] PM: Adding info for No Bus:tty56
[    5.585640] kobject: 'tty56' (cd947a08): kobject_uevent_env
[    5.586467] kobject: 'tty56' (cd947a08): fill_kobj_path: path = '/devices/virtual/tty/tty56'
[    5.587822] device: 'tty57': device_add
[    5.588472] kobject: 'tty57' (cd947c08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.589838] PM: Adding info for No Bus:tty57
[    5.590582] kobject: 'tty57' (cd947c08): kobject_uevent_env
[    5.591421] kobject: 'tty57' (cd947c08): fill_kobj_path: path = '/devices/virtual/tty/tty57'
[    5.592786] device: 'tty58': device_add
[    5.593439] kobject: 'tty58' (cd947e08): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.594922] PM: Adding info for No Bus:tty58
[    5.595634] kobject: 'tty58' (cd947e08): kobject_uevent_env
[    5.596461] kobject: 'tty58' (cd947e08): fill_kobj_path: path = '/devices/virtual/tty/tty58'
[    5.597839] device: 'tty59': device_add
[    5.598491] kobject: 'tty59' (cd948008): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.599852] PM: Adding info for No Bus:tty59
[    5.600608] kobject: 'tty59' (cd948008): kobject_uevent_env
[    5.601440] kobject: 'tty59' (cd948008): fill_kobj_path: path = '/devices/virtual/tty/tty59'
[    5.602790] device: 'tty60': device_add
[    5.603445] kobject: 'tty60' (cd948208): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.605024] PM: Adding info for No Bus:tty60
[    5.605732] kobject: 'tty60' (cd948208): kobject_uevent_env
[    5.606559] kobject: 'tty60' (cd948208): fill_kobj_path: path = '/devices/virtual/tty/tty60'
[    5.607909] device: 'tty61': device_add
[    5.608561] kobject: 'tty61' (cd948408): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.609932] PM: Adding info for No Bus:tty61
[    5.610688] kobject: 'tty61' (cd948408): kobject_uevent_env
[    5.611518] kobject: 'tty61' (cd948408): fill_kobj_path: path = '/devices/virtual/tty/tty61'
[    5.612877] device: 'tty62': device_add
[    5.613528] kobject: 'tty62' (cd948608): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.615138] PM: Adding info for No Bus:tty62
[    5.615851] kobject: 'tty62' (cd948608): kobject_uevent_env
[    5.616703] kobject: 'tty62' (cd948608): fill_kobj_path: path = '/devices/virtual/tty/tty62'
[    5.618040] device: 'tty63': device_add
[    5.618715] kobject: 'tty63' (cd948808): kobject_add_internal: parent: 'tty', set: 'devices'
[    5.620095] PM: Adding info for No Bus:tty63
[    5.620817] kobject: 'tty63' (cd948808): kobject_uevent_env
[    5.621649] kobject: 'tty63' (cd948808): fill_kobj_path: path = '/devices/virtual/tty/tty63'
[    5.623028] device class 'firmware': registering
[    5.623928] kobject: 'firmware' (cd90fc0c): kobject_add_internal: parent: 'class', set: 'class'
[    5.625360] kobject: 'firmware' (cd90fc0c): kobject_uevent_env
[    5.626224] kobject: 'firmware' (cd90fc0c): fill_kobj_path: path = '/class/firmware'
[    5.627489] kobject: 'pcmcia' (cd90fd0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    5.628821] kobject: 'pcmcia' (cd90fd0c): kobject_uevent_env
[    5.629673] kobject: 'pcmcia' (cd90fd0c): fill_kobj_path: path = '/bus/pcmcia'
[    5.630923] kobject: 'devices' (cd93ea4c): kobject_add_internal: parent: 'pcmcia', set: '<NULL>'
[    5.632291] kobject: 'devices' (cd93ea4c): kobject_uevent_env
[    5.633161] kobject: 'devices' (cd93ea4c): kobject_uevent_env: filter function caused the event to drop!
[    5.635042] kobject: 'drivers' (cd93eacc): kobject_add_internal: parent: 'pcmcia', set: '<NULL>'
[    5.636696] kobject: 'drivers' (cd93eacc): kobject_uevent_env
[    5.637755] kobject: 'drivers' (cd93eacc): kobject_uevent_env: filter function caused the event to drop!
[    5.639532] bus: 'pcmcia': registered
[    5.640726] device class 'thermal': registering
[    5.641447] kobject: 'thermal' (cd90fe0c): kobject_add_internal: parent: 'class', set: 'class'
[    5.642797] kobject: 'thermal' (cd90fe0c): kobject_uevent_env
[    5.643713] kobject: 'thermal' (cd90fe0c): fill_kobj_path: path = '/class/thermal'
[    5.679629] kobject: 'ssb' (cd90ff0c): kobject_add_internal: parent: 'bus', set: 'bus'
[    5.681932] kobject: 'ssb' (cd90ff0c): kobject_uevent_env
[    5.683307] kobject: 'ssb' (cd90ff0c): fill_kobj_path: path = '/bus/ssb'
[    5.684262] kobject: 'devices' (cd93ec8c): kobject_add_internal: parent: 'ssb', set: '<NULL>'
[    5.685601] kobject: 'devices' (cd93ec8c): kobject_uevent_env
[    5.686438] kobject: 'devices' (cd93ec8c): kobject_uevent_env: filter function caused the event to drop!
[    5.687875] kobject: 'drivers' (cd93ed0c): kobject_add_internal: parent: 'ssb', set: '<NULL>'
[    5.689205] kobject: 'drivers' (cd93ed0c): kobject_uevent_env
[    5.690086] kobject: 'drivers' (cd93ed0c): kobject_uevent_env: filter function caused the event to drop!
[    5.691509] bus: 'ssb': registered
[    5.692168] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    5.692998] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    5.693929] NET: Registered protocol family 1
[    5.694673] pci 0000:00:00.0: calling quirk_natoma+0x0/0x2b
[    5.695497] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    5.696374] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x80
[    5.697301] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    5.698169] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e
[    5.699060] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    5.699961] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x9d
[    5.700874] pci 0000:00:02.0: Boot video device
[    5.701634] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x172
[    5.702640] PCI: CLS 0 bytes, default 64
[    5.703388] Unpacking initramfs...
[    6.223184] Freeing initrd memory: 25284k freed
[    6.230213] doing device, parsing ARGS: 'rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-b064 branch=mfd/for-next dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2'
[    6.234769] doing device: hung_task_panic='1'
[    6.235490] doing device: bisect-reboot='(null)'
[    6.236253] doing device: i386-randconfig-b064='(null)'
[    6.237074] doing device: branch='mfd/for-next'
[    6.237825] doing device: dyndbg='+p'
[    6.238474] doing device: log_buf_len='8M'
[    6.239182] doing device: ignore_loglevel='(null)'
[    6.239952] doing device: debug='(null)'
[    6.240682] doing device: sched_debug='(null)'
[    6.241410] doing device: apic='debug'
[    6.242091] doing device: dynamic_printk='(null)'
[    6.242864] doing device: sysrq_always_enabled='(null)'
[    6.243769] doing device: prompt_ramdisk='0'
[    6.246524] doing device: console='ttyS0,115200'
[    6.247285] doing device: console='tty0'
[    6.247962] doing device: vga='normal'
[    6.248632] doing device: root='/dev/ram0'
[    6.249318] doing device: rw='(null)'
[    6.249984] doing device: BOOT_IMAGE='i386/vmlinuz-bisect2'
[    6.251022] kvm: no hardware support
[    6.251713] kobject: 'cache' (c968f080): kobject_add_internal: parent: 'cpu0', set: '<NULL>'
[    6.253061] kobject: 'index0' (cd8ae9c0): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    6.254651] kobject: 'index0' (cd8ae9c0): kobject_uevent_env
[    6.255487] kobject: 'index0' (cd8ae9c0): kobject_uevent_env: filter function caused the event to drop!
[    6.256918] kobject: 'index1' (cd8ae9ec): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    6.258255] kobject: 'index1' (cd8ae9ec): kobject_uevent_env
[    6.259111] kobject: 'index1' (cd8ae9ec): kobject_uevent_env: filter function caused the event to drop!
[    6.260683] kobject: 'index2' (cd8aea18): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    6.262028] kobject: 'index2' (cd8aea18): kobject_uevent_env
[    6.262879] kobject: 'index2' (cd8aea18): kobject_uevent_env: filter function caused the event to drop!
[    6.264505] kobject: 'cache' (c968f080): kobject_uevent_env
[    6.265350] kobject: 'cache' (c968f080): kobject_uevent_env: filter function caused the event to drop!
[    6.266826] kobject: 'cache' (c968f880): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
[    6.268149] kobject: 'index0' (cd8aea80): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    6.269501] kobject: 'index0' (cd8aea80): kobject_uevent_env
[    6.270377] kobject: 'index0' (cd8aea80): kobject_uevent_env: filter function caused the event to drop!
[    6.271814] kobject: 'index1' (cd8aeaac): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    6.273165] kobject: 'index1' (cd8aeaac): kobject_uevent_env
[    6.274116] kobject: 'index1' (cd8aeaac): kobject_uevent_env: filter function caused the event to drop!
[    6.275554] kobject: 'index2' (cd8aead8): kobject_add_internal: parent: 'cache', set: '<NULL>'
[    6.276910] kobject: 'index2' (cd8aead8): kobject_uevent_env
[    6.277746] kobject: 'index2' (cd8aead8): kobject_uevent_env: filter function caused the event to drop!
[    6.279172] kobject: 'cache' (c968f880): kobject_uevent_env
[    6.279995] kobject: 'cache' (c968f880): kobject_uevent_env: filter function caused the event to drop!
[    6.281477] device class 'msr': registering
[    6.282167] kobject: 'msr' (cc2a810c): kobject_add_internal: parent: 'class', set: 'class'
[    6.283488] kobject: 'msr' (cc2a810c): kobject_uevent_env
[    6.284595] kobject: 'msr' (cc2a810c): fill_kobj_path: path = '/class/msr'
[    6.285571] device: 'msr0': device_add
[    6.286215] kobject: 'msr' (c992d140): kobject_add_internal: parent: 'virtual', set: '(null)'
[    6.287571] kobject: 'msr0' (cd949208): kobject_add_internal: parent: 'msr', set: 'devices'
[    6.288911] PM: Adding info for No Bus:msr0
[    6.289600] kobject: 'msr0' (cd949208): kobject_uevent_env
[    6.290503] kobject: 'msr0' (cd949208): fill_kobj_path: path = '/devices/virtual/msr/msr0'
[    6.291830] device: 'msr1': device_add
[    6.292471] kobject: 'msr1' (cd949408): kobject_add_internal: parent: 'msr', set: 'devices'
[    6.293917] PM: Adding info for No Bus:msr1
[    6.294608] kobject: 'msr1' (cd949408): kobject_uevent_env
[    6.295423] kobject: 'msr1' (cd949408): fill_kobj_path: path = '/devices/virtual/msr/msr1'
[    6.296761] device class 'cpuid': registering
[    6.297462] kobject: 'cpuid' (cc2a820c): kobject_add_internal: parent: 'class', set: 'class'
[    6.298800] kobject: 'cpuid' (cc2a820c): kobject_uevent_env
[    6.299644] kobject: 'cpuid' (cc2a820c): fill_kobj_path: path = '/class/cpuid'
[    6.300891] device: 'cpu0': device_add
[    6.301535] kobject: 'cpuid' (c992d880): kobject_add_internal: parent: 'virtual', set: '(null)'
[    6.302892] kobject: 'cpu0' (cd949608): kobject_add_internal: parent: 'cpuid', set: 'devices'
[    6.304381] PM: Adding info for No Bus:cpu0
[    6.305073] kobject: 'cpu0' (cd949608): kobject_uevent_env
[    6.305917] kobject: 'cpu0' (cd949608): fill_kobj_path: path = '/devices/virtual/cpuid/cpu0'
[    6.307287] device: 'cpu1': device_add
[    6.307941] kobject: 'cpu1' (cd949808): kobject_add_internal: parent: 'cpuid', set: 'devices'
[    6.309278] PM: Adding info for No Bus:cpu1
[    6.309987] kobject: 'cpu1' (cd949808): kobject_uevent_env
[    6.310852] kobject: 'cpu1' (cd949808): fill_kobj_path: path = '/devices/virtual/cpuid/cpu1'
[    6.312203] apm: BIOS not found.
[    6.312801] Registering platform device 'pcspkr'. Parent at platform
[    6.313829] device: 'pcspkr': device_add
[    6.314487] kobject: 'pcspkr' (cd949a10): kobject_add_internal: parent: 'platform', set: 'devices'
[    6.315930] bus: 'platform': add device pcspkr
[    6.316663] PM: Adding info for platform:pcspkr
[    6.317380] kobject: 'pcspkr' (cd949a10): kobject_uevent_env
[    6.318226] kobject: 'pcspkr' (cd949a10): fill_kobj_path: path = '/devices/platform/pcspkr'
[    6.319574] Registering platform device 'microcode'. Parent at platform
[    6.320544] device: 'microcode': device_add
[    6.321241] kobject: 'microcode' (cd949c10): kobject_add_internal: parent: 'platform', set: 'devices'
[    6.322676] bus: 'platform': add device microcode
[    6.323415] PM: Adding info for platform:microcode
[    6.324300] kobject: 'microcode' (cd949c10): kobject_uevent_env
[    6.325179] kobject: 'microcode' (cd949c10): fill_kobj_path: path = '/devices/platform/microcode'
[    6.326552] microcode: CPU0 added
[    6.327180] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    6.328013] microcode: CPU1 added
[    6.328667] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    6.330162] device: 'microcode': device_add
[    6.330874] kobject: 'microcode' (cd949e08): kobject_add_internal: parent: 'misc', set: 'devices'
[    6.332250] PM: Adding info for No Bus:microcode
[    6.332992] kobject: 'microcode' (cd949e08): kobject_uevent_env
[    6.334036] kobject: 'microcode' (cd949e08): fill_kobj_path: path = '/devices/virtual/misc/microcode'
[    6.335462] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.337002] debugfs: creating file 'kernel_page_tables'
[    6.338157] kobject: 'clocksource' (cc2a830c): kobject_add_internal: parent: 'bus', set: 'bus'
[    6.339527] kobject: 'clocksource' (cc2a830c): kobject_uevent_env
[    6.340489] kobject: 'clocksource' (cc2a830c): fill_kobj_path: path = '/bus/clocksource'
[    6.341788] kobject: 'devices' (cd31cacc): kobject_add_internal: parent: 'clocksource', set: '<NULL>'
[    6.343207] kobject: 'devices' (cd31cacc): kobject_uevent_env
[    6.344175] kobject: 'devices' (cd31cacc): kobject_uevent_env: filter function caused the event to drop!
[    6.345612] kobject: 'drivers' (cd31cb4c): kobject_add_internal: parent: 'clocksource', set: '<NULL>'
[    6.347027] kobject: 'drivers' (cd31cb4c): kobject_uevent_env
[    6.347883] kobject: 'drivers' (cd31cb4c): kobject_uevent_env: filter function caused the event to drop!
[    6.349317] bus: 'clocksource': registered
[    6.350046] device: 'clocksource': device_add
[    6.350779] kobject: 'clocksource' (cd96e008): kobject_add_internal: parent: 'system', set: 'devices'
[    6.352186] PM: Adding info for No Bus:clocksource
[    6.352945] kobject: 'clocksource' (cd96e008): kobject_uevent_env
[    6.353951] kobject: 'clocksource' (cd96e008): kobject_uevent_env: filter function caused the event to drop!
[    6.355432] device: 'clocksource0': device_add
[    6.356153] kobject: 'clocksource0' (c1930c28): kobject_add_internal: parent: 'clocksource', set: 'devices'
[    6.357627] bus: 'clocksource': add device clocksource0
[    6.358422] PM: Adding info for clocksource:clocksource0
[    6.359253] kobject: 'clocksource0' (c1930c28): kobject_uevent_env
[    6.360246] kobject: 'clocksource0' (c1930c28): fill_kobj_path: path = '/devices/system/clocksource/clocksource0'
[    6.361774] bus: 'platform': add driver alarmtimer
[    6.362520] kobject: 'alarmtimer' (cd93bd20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.364058] kobject: 'alarmtimer' (cd93bd20): kobject_uevent_env
[    6.364943] kobject: 'alarmtimer' (cd93bd20): fill_kobj_path: path = '/bus/platform/drivers/alarmtimer'
[    6.366370] Registering platform device 'alarmtimer'. Parent at platform
[    6.367334] device: 'alarmtimer': device_add
[    6.368036] kobject: 'alarmtimer' (cd96e210): kobject_add_internal: parent: 'platform', set: 'devices'
[    6.369455] bus: 'platform': add device alarmtimer
[    6.370293] PM: Adding info for platform:alarmtimer
[    6.371093] kobject: 'alarmtimer' (cd96e210): kobject_uevent_env
[    6.371972] kobject: 'alarmtimer' (cd96e210): fill_kobj_path: path = '/devices/platform/alarmtimer'
[    6.373358] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    6.374873] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    6.376198] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    6.377190] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    6.378496] kobject: 'rttest' (cc2a840c): kobject_add_internal: parent: 'bus', set: 'bus'
[    6.379825] kobject: 'rttest' (cc2a840c): kobject_uevent_env
[    6.380719] kobject: 'rttest' (cc2a840c): fill_kobj_path: path = '/bus/rttest'
[    6.384057] kobject: 'devices' (c92165cc): kobject_add_internal: parent: 'rttest', set: '<NULL>'
[    6.385423] kobject: 'devices' (c92165cc): kobject_uevent_env
[    6.386270] kobject: 'devices' (c92165cc): kobject_uevent_env: filter function caused the event to drop!
[    6.387718] kobject: 'drivers' (c921664c): kobject_add_internal: parent: 'rttest', set: '<NULL>'
[    6.389076] kobject: 'drivers' (c921664c): kobject_uevent_env
[    6.389923] kobject: 'drivers' (c921664c): kobject_uevent_env: filter function caused the event to drop!
[    6.391409] bus: 'rttest': registered
[    6.392046] device: 'rttest': device_add
[    6.392717] kobject: 'rttest' (cd96e408): kobject_add_internal: parent: 'system', set: 'devices'
[    6.394218] PM: Adding info for No Bus:rttest
[    6.394943] kobject: 'rttest' (cd96e408): kobject_uevent_env
[    6.395777] kobject: 'rttest' (cd96e408): kobject_uevent_env: filter function caused the event to drop!
[    6.397325] device: 'rttest0': device_add
[    6.398004] kobject: 'rttest0' (c1a5adf4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.399387] bus: 'rttest': add device rttest0
[    6.400175] PM: Adding info for rttest:rttest0
[    6.400919] kobject: 'rttest0' (c1a5adf4): kobject_uevent_env
[    6.401768] kobject: 'rttest0' (c1a5adf4): fill_kobj_path: path = '/devices/system/rttest/rttest0'
[    6.403276] device: 'rttest1': device_add
[    6.404192] kobject: 'rttest1' (c1a5af6c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.405579] bus: 'rttest': add device rttest1
[    6.406283] PM: Adding info for rttest:rttest1
[    6.407018] kobject: 'rttest1' (c1a5af6c): kobject_uevent_env
[    6.407867] kobject: 'rttest1' (c1a5af6c): fill_kobj_path: path = '/devices/system/rttest/rttest1'
[    6.409365] device: 'rttest2': device_add
[    6.410101] kobject: 'rttest2' (c1a5b0e4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.411491] bus: 'rttest': add device rttest2
[    6.412203] PM: Adding info for rttest:rttest2
[    6.412927] kobject: 'rttest2' (c1a5b0e4): kobject_uevent_env
[    6.413920] kobject: 'rttest2' (c1a5b0e4): fill_kobj_path: path = '/devices/system/rttest/rttest2'
[    6.415491] device: 'rttest3': device_add
[    6.416185] kobject: 'rttest3' (c1a5b25c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.417570] bus: 'rttest': add device rttest3
[    6.418282] PM: Adding info for rttest:rttest3
[    6.419019] kobject: 'rttest3' (c1a5b25c): kobject_uevent_env
[    6.419861] kobject: 'rttest3' (c1a5b25c): fill_kobj_path: path = '/devices/system/rttest/rttest3'
[    6.421411] device: 'rttest4': device_add
[    6.422098] kobject: 'rttest4' (c1a5b3d4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.423479] bus: 'rttest': add device rttest4
[    6.424320] PM: Adding info for rttest:rttest4
[    6.425052] kobject: 'rttest4' (c1a5b3d4): kobject_uevent_env
[    6.425900] kobject: 'rttest4' (c1a5b3d4): fill_kobj_path: path = '/devices/system/rttest/rttest4'
[    6.427426] device: 'rttest5': device_add
[    6.428160] kobject: 'rttest5' (c1a5b54c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.429549] bus: 'rttest': add device rttest5
[    6.430377] PM: Adding info for rttest:rttest5
[    6.431111] kobject: 'rttest5' (c1a5b54c): kobject_uevent_env
[    6.431964] kobject: 'rttest5' (c1a5b54c): fill_kobj_path: path = '/devices/system/rttest/rttest5'
[    6.433634] device: 'rttest6': device_add
[    6.434402] kobject: 'rttest6' (c1a5b6c4): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.435796] bus: 'rttest': add device rttest6
[    6.436502] PM: Adding info for rttest:rttest6
[    6.437231] kobject: 'rttest6' (c1a5b6c4): kobject_uevent_env
[    6.438079] kobject: 'rttest6' (c1a5b6c4): fill_kobj_path: path = '/devices/system/rttest/rttest6'
[    6.439657] device: 'rttest7': device_add
[    6.440399] kobject: 'rttest7' (c1a5b83c): kobject_add_internal: parent: 'rttest', set: 'devices'
[    6.441788] bus: 'rttest': add device rttest7
[    6.442499] PM: Adding info for rttest:rttest7
[    6.443230] kobject: 'rttest7' (c1a5b83c): kobject_uevent_env
[    6.444192] kobject: 'rttest7' (c1a5b83c): fill_kobj_path: path = '/devices/system/rttest/rttest7'
[    6.445590] Initializing RT-Tester: OK
[    6.446261] audit: initializing netlink socket (disabled)
[    6.447109] type=2000 audit(1348713375.440:1): initialized
[    6.448110] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    6.452851] kobject: 'event_source' (cc2a850c): kobject_add_internal: parent: 'bus', set: 'bus'
[    6.454415] kobject: 'event_source' (cc2a850c): kobject_uevent_env
[    6.455324] kobject: 'event_source' (cc2a850c): fill_kobj_path: path = '/bus/event_source'
[    6.456644] kobject: 'devices' (ca21174c): kobject_add_internal: parent: 'event_source', set: '<NULL>'
[    6.458059] kobject: 'devices' (ca21174c): kobject_uevent_env
[    6.458916] kobject: 'devices' (ca21174c): kobject_uevent_env: filter function caused the event to drop!
[    6.460401] kobject: 'drivers' (ca2117cc): kobject_add_internal: parent: 'event_source', set: '<NULL>'
[    6.461837] kobject: 'drivers' (ca2117cc): kobject_uevent_env
[    6.462697] kobject: 'drivers' (ca2117cc): kobject_uevent_env: filter function caused the event to drop!
[    6.464241] bus: 'event_source': registered
[    6.464944] device: 'breakpoint': device_add
[    6.465640] kobject: 'breakpoint' (cd96e808): kobject_add_internal: parent: 'devices', set: 'devices'
[    6.467050] bus: 'event_source': add device breakpoint
[    6.467842] PM: Adding info for event_source:breakpoint
[    6.468643] kobject: 'breakpoint' (cd96e808): kobject_uevent_env
[    6.469510] kobject: 'breakpoint' (cd96e808): fill_kobj_path: path = '/devices/breakpoint'
[    6.470877] device: 'software': device_add
[    6.471550] kobject: 'software' (cd96ea08): kobject_add_internal: parent: 'devices', set: 'devices'
[    6.472945] bus: 'event_source': add device software
[    6.473834] PM: Adding info for event_source:software
[    6.474627] kobject: 'software' (cd96ea08): kobject_uevent_env
[    6.475481] kobject: 'software' (cd96ea08): fill_kobj_path: path = '/devices/software'
[    6.477009] kobject: 'mm' (ca211e80): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    6.478491] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    6.479403] kobject: 'hugepages' (ca211f00): kobject_add_internal: parent: 'mm', set: '<NULL>'
[    6.480859] kobject: 'hugepages-4096kB' (ca211f80): kobject_add_internal: parent: 'hugepages', set: '<NULL>'
[    6.482337] kobject: 'slab' (ca2c114c): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    6.483797] kobject: 'slab' (ca2c114c): kobject_uevent_env
[    6.484633] kobject: 'slab' (ca2c114c): kobject_uevent_env: attempted to send uevent without kset!
[    6.486010] kobject: ':t-0000040' (cd8b554c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.487381] kobject: ':t-0000040' (cd8b554c): kobject_uevent_env
[    6.488257] kobject: ':t-0000040' (cd8b554c): fill_kobj_path: path = '/kernel/slab/:t-0000040'
[    6.489608] kobject: ':t-0001048' (cd847fcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.491057] kobject: ':t-0001048' (cd847fcc): kobject_uevent_env
[    6.491940] kobject: ':t-0001048' (cd847fcc): fill_kobj_path: path = '/kernel/slab/:t-0001048'
[    6.493276] kobject: ':t-0000216' (cd847f4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.494779] kobject: ':t-0000216' (cd847f4c): kobject_uevent_env
[    6.495658] kobject: ':t-0000216' (cd847f4c): fill_kobj_path: path = '/kernel/slab/:t-0000216'
[    6.497000] kobject: ':t-0003072' (cd847d4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.498365] kobject: ':t-0003072' (cd847d4c): kobject_uevent_env
[    6.499243] kobject: ':t-0003072' (cd847d4c): fill_kobj_path: path = '/kernel/slab/:t-0003072'
[    6.500671] kobject: ':t-0001536' (cd847ccc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.502061] kobject: ':t-0001536' (cd847ccc): kobject_uevent_env
[    6.502937] kobject: ':t-0001536' (cd847ccc): fill_kobj_path: path = '/kernel/slab/:t-0001536'
[    6.504395] kobject: ':t-0000768' (cd847c4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.505777] kobject: ':t-0000768' (cd847c4c): kobject_uevent_env
[    6.506653] kobject: ':t-0000768' (cd847c4c): fill_kobj_path: path = '/kernel/slab/:t-0000768'
[    6.507994] kobject: ':t-0003200' (cd847bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.509362] kobject: ':t-0003200' (cd847bcc): kobject_uevent_env
[    6.510308] kobject: ':t-0003200' (cd847bcc): fill_kobj_path: path = '/kernel/slab/:t-0003200'
[    6.511666] kobject: ':t-0001664' (cd847b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.513034] kobject: ':t-0001664' (cd847b4c): kobject_uevent_env
[    6.513989] kobject: ':t-0001664' (cd847b4c): fill_kobj_path: path = '/kernel/slab/:t-0001664'
[    6.515331] kobject: ':t-0000896' (cd847acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.516710] kobject: ':t-0000896' (cd847acc): kobject_uevent_env
[    6.517590] kobject: ':t-0000896' (cd847acc): fill_kobj_path: path = '/kernel/slab/:t-0000896'
[    6.518929] kobject: 'sock_inode_cache' (cd84744c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.522433] kobject: 'sock_inode_cache' (cd84744c): kobject_uevent_env
[    6.523363] kobject: 'sock_inode_cache' (cd84744c): fill_kobj_path: path = '/kernel/slab/sock_inode_cache'
[    6.524837] kobject: ':t-0000384' (cd8473cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.526204] kobject: ':t-0000384' (cd8473cc): kobject_uevent_env
[    6.527083] kobject: ':t-0000384' (cd8473cc): fill_kobj_path: path = '/kernel/slab/:t-0000384'
[    6.528418] kobject: ':t-0000112' (cd8472cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.529800] kobject: ':t-0000112' (cd8472cc): kobject_uevent_env
[    6.530740] kobject: ':t-0000112' (cd8472cc): fill_kobj_path: path = '/kernel/slab/:t-0000112'
[    6.532097] kobject: 'shmem_inode_cache' (cd83f9cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.533538] kobject: 'shmem_inode_cache' (cd83f9cc): kobject_uevent_env
[    6.534615] kobject: 'shmem_inode_cache' (cd83f9cc): fill_kobj_path: path = '/kernel/slab/shmem_inode_cache'
[    6.536072] kobject: ':t-0000048' (cd806bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.537451] kobject: ':t-0000048' (cd806bcc): kobject_uevent_env
[    6.538324] kobject: ':t-0000048' (cd806bcc): fill_kobj_path: path = '/kernel/slab/:t-0000048'
[    6.539684] kobject: ':t-0000080' (cd806b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.541133] kobject: ':t-0000080' (cd806b4c): kobject_uevent_env
[    6.542026] kobject: ':t-0000080' (cd806b4c): fill_kobj_path: path = '/kernel/slab/:t-0000080'
[    6.543383] kobject: ':t-0000328' (cd806acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.545047] kobject: ':t-0000328' (cd806acc): kobject_uevent_env
[    6.545927] kobject: ':t-0000328' (cd806acc): fill_kobj_path: path = '/kernel/slab/:t-0000328'
[    6.547277] kobject: 'proc_inode_cache' (cd80694c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.548714] kobject: 'proc_inode_cache' (cd80694c): kobject_uevent_env
[    6.549641] kobject: 'proc_inode_cache' (cd80694c): fill_kobj_path: path = '/kernel/slab/proc_inode_cache'
[    6.551180] kobject: ':t-0000144' (cd8068cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.552563] kobject: ':t-0000144' (cd8068cc): kobject_uevent_env
[    6.553446] kobject: ':t-0000144' (cd8068cc): fill_kobj_path: path = '/kernel/slab/:t-0000144'
[    6.555084] kobject: 'bdev_cache' (cd80684c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.556465] kobject: 'bdev_cache' (cd80684c): kobject_uevent_env
[    6.557353] kobject: 'bdev_cache' (cd80684c): fill_kobj_path: path = '/kernel/slab/bdev_cache'
[    6.558719] kobject: 'inode_cache' (cd80654c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.560175] kobject: 'inode_cache' (cd80654c): kobject_uevent_env
[    6.561105] kobject: 'inode_cache' (cd80654c): fill_kobj_path: path = '/kernel/slab/inode_cache'
[    6.562469] kobject: ':at-0000128' (cd8064cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.563980] kobject: ':at-0000128' (cd8064cc): kobject_uevent_env
[    6.564876] kobject: ':at-0000128' (cd8064cc): fill_kobj_path: path = '/kernel/slab/:at-0000128'
[    6.566234] kobject: ':at-0000056' (cd80644c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.567637] kobject: ':at-0000056' (cd80644c): kobject_uevent_env
[    6.568515] kobject: ':at-0000056' (cd80644c): fill_kobj_path: path = '/kernel/slab/:at-0000056'
[    6.569893] kobject: ':t-0000088' (cd8063cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.571341] kobject: ':t-0000088' (cd8063cc): kobject_uevent_env
[    6.572223] kobject: ':t-0000088' (cd8063cc): fill_kobj_path: path = '/kernel/slab/:t-0000088'
[    6.573576] kobject: ':t-0000640' (cd80634c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.575076] kobject: ':t-0000640' (cd80634c): kobject_uevent_env
[    6.575947] kobject: ':t-0000640' (cd80634c): fill_kobj_path: path = '/kernel/slab/:t-0000640'
[    6.577291] kobject: 'sighand_cache' (cd8062cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.578699] kobject: 'sighand_cache' (cd8062cc): kobject_uevent_env
[    6.579597] kobject: 'sighand_cache' (cd8062cc): fill_kobj_path: path = '/kernel/slab/sighand_cache'
[    6.581082] kobject: ':t-0003136' (cd80624c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.582454] kobject: ':t-0003136' (cd80624c): kobject_uevent_env
[    6.583343] kobject: ':t-0003136' (cd80624c): fill_kobj_path: path = '/kernel/slab/:t-0003136'
[    6.584839] kobject: 'anon_vma' (cd8061cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.586183] kobject: 'anon_vma' (cd8061cc): kobject_uevent_env
[    6.587055] kobject: 'anon_vma' (cd8061cc): fill_kobj_path: path = '/kernel/slab/anon_vma'
[    6.588353] kobject: ':t-0000024' (cd80614c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.589736] kobject: ':t-0000024' (cd80614c): kobject_uevent_env
[    6.590715] kobject: ':t-0000024' (cd80614c): fill_kobj_path: path = '/kernel/slab/:t-0000024'
[    6.592069] kobject: 'radix_tree_node' (cd8060cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.593488] kobject: 'radix_tree_node' (cd8060cc): kobject_uevent_env
[    6.594573] kobject: 'radix_tree_node' (cd8060cc): fill_kobj_path: path = '/kernel/slab/radix_tree_node'
[    6.596010] kobject: ':t-0000152' (cd80604c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.597384] kobject: ':t-0000152' (cd80604c): kobject_uevent_env
[    6.598254] kobject: ':t-0000152' (cd80604c): fill_kobj_path: path = '/kernel/slab/:t-0000152'
[    6.599615] kobject: ':dt-0008192' (cd802dcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.601100] kobject: ':dt-0008192' (cd802dcc): kobject_uevent_env
[    6.601982] kobject: ':dt-0008192' (cd802dcc): fill_kobj_path: path = '/kernel/slab/:dt-0008192'
[    6.603352] kobject: ':dt-0004096' (cd802d4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.604984] kobject: ':dt-0004096' (cd802d4c): kobject_uevent_env
[    6.605865] kobject: ':dt-0004096' (cd802d4c): fill_kobj_path: path = '/kernel/slab/:dt-0004096'
[    6.607231] kobject: ':dt-0002048' (cd802ccc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.608616] kobject: ':dt-0002048' (cd802ccc): kobject_uevent_env
[    6.609493] kobject: ':dt-0002048' (cd802ccc): fill_kobj_path: path = '/kernel/slab/:dt-0002048'
[    6.610937] kobject: ':dt-0001024' (cd802c4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.612325] kobject: ':dt-0001024' (cd802c4c): kobject_uevent_env
[    6.613221] kobject: ':dt-0001024' (cd802c4c): fill_kobj_path: path = '/kernel/slab/:dt-0001024'
[    6.614733] kobject: ':dt-0000512' (cd802bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.616113] kobject: ':dt-0000512' (cd802bcc): kobject_uevent_env
[    6.617005] kobject: ':dt-0000512' (cd802bcc): fill_kobj_path: path = '/kernel/slab/:dt-0000512'
[    6.618357] kobject: ':dt-0000256' (cd802b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.619764] kobject: ':dt-0000256' (cd802b4c): kobject_uevent_env
[    6.620700] kobject: ':dt-0000256' (cd802b4c): fill_kobj_path: path = '/kernel/slab/:dt-0000256'
[    6.622062] kobject: ':dt-0000128' (cd802acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.623459] kobject: ':dt-0000128' (cd802acc): kobject_uevent_env
[    6.624467] kobject: ':dt-0000128' (cd802acc): fill_kobj_path: path = '/kernel/slab/:dt-0000128'
[    6.625844] kobject: ':dt-0000064' (cd802a4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.627240] kobject: ':dt-0000064' (cd802a4c): kobject_uevent_env
[    6.628121] kobject: ':dt-0000064' (cd802a4c): fill_kobj_path: path = '/kernel/slab/:dt-0000064'
[    6.629490] kobject: ':dt-0000032' (cd8029cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.630948] kobject: ':dt-0000032' (cd8029cc): kobject_uevent_env
[    6.631836] kobject: ':dt-0000032' (cd8029cc): fill_kobj_path: path = '/kernel/slab/:dt-0000032'
[    6.633197] kobject: ':dt-0000016' (cd80294c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.634731] kobject: ':dt-0000016' (cd80294c): kobject_uevent_env
[    6.635611] kobject: ':dt-0000016' (cd80294c): fill_kobj_path: path = '/kernel/slab/:dt-0000016'
[    6.636969] kobject: ':dt-0000008' (cd8028cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.638345] kobject: ':dt-0000008' (cd8028cc): kobject_uevent_env
[    6.639243] kobject: ':dt-0000008' (cd8028cc): fill_kobj_path: path = '/kernel/slab/:dt-0000008'
[    6.640686] kobject: ':dt-0000192' (cd80284c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.642067] kobject: ':dt-0000192' (cd80284c): kobject_uevent_env
[    6.642968] kobject: ':dt-0000192' (cd80284c): fill_kobj_path: path = '/kernel/slab/:dt-0000192'
[    6.644502] kobject: ':dt-0000096' (cd8027cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.645888] kobject: ':dt-0000096' (cd8027cc): kobject_uevent_env
[    6.646788] kobject: ':dt-0000096' (cd8027cc): fill_kobj_path: path = '/kernel/slab/:dt-0000096'
[    6.648196] kobject: ':t-0008192' (cd80274c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.649578] kobject: ':t-0008192' (cd80274c): kobject_uevent_env
[    6.650509] kobject: ':t-0008192' (cd80274c): fill_kobj_path: path = '/kernel/slab/:t-0008192'
[    6.651872] kobject: ':t-0004096' (cd8026cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.653252] kobject: ':t-0004096' (cd8026cc): kobject_uevent_env
[    6.654354] kobject: ':t-0004096' (cd8026cc): fill_kobj_path: path = '/kernel/slab/:t-0004096'
[    6.655719] kobject: ':t-0002048' (cd80264c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.659103] kobject: ':t-0002048' (cd80264c): kobject_uevent_env
[    6.659971] kobject: ':t-0002048' (cd80264c): fill_kobj_path: path = '/kernel/slab/:t-0002048'
[    6.661376] kobject: ':t-0001024' (cd8025cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.662787] kobject: ':t-0001024' (cd8025cc): kobject_uevent_env
[    6.663750] kobject: ':t-0001024' (cd8025cc): fill_kobj_path: path = '/kernel/slab/:t-0001024'
[    6.665133] kobject: ':t-0000512' (cd80254c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.666506] kobject: ':t-0000512' (cd80254c): kobject_uevent_env
[    6.667396] kobject: ':t-0000512' (cd80254c): fill_kobj_path: path = '/kernel/slab/:t-0000512'
[    6.668754] kobject: ':t-0000256' (cd8024cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.670203] kobject: ':t-0000256' (cd8024cc): kobject_uevent_env
[    6.671124] kobject: ':t-0000256' (cd8024cc): fill_kobj_path: path = '/kernel/slab/:t-0000256'
[    6.672463] kobject: ':t-0000128' (cd80244c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.674074] kobject: ':t-0000128' (cd80244c): kobject_uevent_env
[    6.674967] kobject: ':t-0000128' (cd80244c): fill_kobj_path: path = '/kernel/slab/:t-0000128'
[    6.676299] kobject: ':t-0000064' (cd8023cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.677680] kobject: ':t-0000064' (cd8023cc): kobject_uevent_env
[    6.678546] kobject: ':t-0000064' (cd8023cc): fill_kobj_path: path = '/kernel/slab/:t-0000064'
[    6.679900] kobject: ':t-0000032' (cd80234c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.681344] kobject: ':t-0000032' (cd80234c): kobject_uevent_env
[    6.682216] kobject: ':t-0000032' (cd80234c): fill_kobj_path: path = '/kernel/slab/:t-0000032'
[    6.683575] kobject: ':t-0000016' (cd8022cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.685074] kobject: ':t-0000016' (cd8022cc): kobject_uevent_env
[    6.685945] kobject: ':t-0000016' (cd8022cc): fill_kobj_path: path = '/kernel/slab/:t-0000016'
[    6.687297] kobject: ':t-0000008' (cd80224c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.688668] kobject: ':t-0000008' (cd80224c): kobject_uevent_env
[    6.689534] kobject: ':t-0000008' (cd80224c): fill_kobj_path: path = '/kernel/slab/:t-0000008'
[    6.690940] kobject: ':t-0000192' (cd8021cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.692322] kobject: ':t-0000192' (cd8021cc): kobject_uevent_env
[    6.693207] kobject: ':t-0000192' (cd8021cc): fill_kobj_path: path = '/kernel/slab/:t-0000192'
[    6.694750] kobject: ':t-0000096' (cd80214c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.696118] kobject: ':t-0000096' (cd80214c): kobject_uevent_env
[    6.697009] kobject: ':t-0000096' (cd80214c): fill_kobj_path: path = '/kernel/slab/:t-0000096'
[    6.698346] kobject: 'kmem_cache' (cd80204c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.699732] kobject: 'kmem_cache' (cd80204c): kobject_uevent_env
[    6.700654] kobject: 'kmem_cache' (cd80204c): fill_kobj_path: path = '/kernel/slab/kmem_cache'
[    6.702041] kobject: 'kmem_cache_node' (cd8020cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.703478] kobject: 'kmem_cache_node' (cd8020cc): kobject_uevent_env
[    6.704516] kobject: 'kmem_cache_node' (cd8020cc): fill_kobj_path: path = '/kernel/slab/kmem_cache_node'
[    6.706011] kobject: ':t-0000320' (ca26044c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.707395] kobject: ':t-0000320' (ca26044c): kobject_uevent_env
[    6.708268] kobject: ':t-0000320' (ca26044c): fill_kobj_path: path = '/kernel/slab/:t-0000320'
[    6.709777] kobject: ':t-0000072' (ca26054c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.711215] kobject: ':t-0000072' (ca26054c): kobject_uevent_env
[    6.712140] kobject: ':t-0000072' (ca26054c): fill_kobj_path: path = '/kernel/slab/:t-0000072'
[    6.713506] aio_setup: sizeof(struct page) = 32
[    6.714376] kobject: ':t-0000056' (ca2605cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.715772] kobject: ':t-0000056' (ca2605cc): kobject_uevent_env
[    6.716658] kobject: ':t-0000056' (ca2605cc): fill_kobj_path: path = '/kernel/slab/:t-0000056'
[    6.717996] kobject: 'config' (c7875e80): kobject_add_internal: parent: 'kernel', set: '<NULL>'
[    6.719393] kobject: 'reiser_inode_cache' (ca26064c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.720938] kobject: 'reiser_inode_cache' (ca26064c): kobject_uevent_env
[    6.721878] kobject: 'reiser_inode_cache' (ca26064c): fill_kobj_path: path = '/kernel/slab/reiser_inode_cache'
[    6.723378] kobject: ':at-0000048' (ca2606cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.724918] kobject: ':at-0000048' (ca2606cc): kobject_uevent_env
[    6.725798] kobject: ':at-0000048' (ca2606cc): fill_kobj_path: path = '/kernel/slab/:at-0000048'
[    6.727180] kobject: 'ext2_inode_cache' (ca26074c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.728609] kobject: 'ext2_inode_cache' (ca26074c): kobject_uevent_env
[    6.729529] kobject: 'ext2_inode_cache' (ca26074c): fill_kobj_path: path = '/kernel/slab/ext2_inode_cache'
[    6.731064] kobject: ':at-0000008' (ca2607cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.732462] kobject: ':at-0000008' (ca2607cc): kobject_uevent_env
[    6.733354] kobject: ':at-0000008' (ca2607cc): fill_kobj_path: path = '/kernel/slab/:at-0000008'
[    6.734945] kobject: ':at-0000576' (ca26084c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.736328] kobject: ':at-0000576' (ca26084c): kobject_uevent_env
[    6.737221] kobject: ':at-0000576' (ca26084c): fill_kobj_path: path = '/kernel/slab/:at-0000576'
[    6.738584] kobject: 'ext4' (c787c7cc): kobject_add_internal: parent: 'fs', set: '<NULL>'
[    6.739891] kobject: 'ext4' (c787c7cc): kobject_uevent_env
[    6.740817] kobject: 'ext4' (c787c7cc): kobject_uevent_env: attempted to send uevent without kset!
[    6.742188] kobject: 'features' (c787c840): kobject_add_internal: parent: 'ext4', set: 'ext4'
[    6.743542] kobject: ':at-0000072' (ca2608cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.745059] kobject: ':at-0000072' (ca2608cc): kobject_uevent_env
[    6.745944] kobject: ':at-0000072' (ca2608cc): fill_kobj_path: path = '/kernel/slab/:at-0000072'
[    6.747316] kobject: ':at-0000112' (ca26094c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.748709] kobject: ':at-0000112' (ca26094c): kobject_uevent_env
[    6.749588] kobject: ':at-0000112' (ca26094c): fill_kobj_path: path = '/kernel/slab/:at-0000112'
[    6.751081] kobject: ':at-0000040' (ca2609cc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.752473] kobject: ':at-0000040' (ca2609cc): kobject_uevent_env
[    6.753365] kobject: ':at-0000040' (ca2609cc): fill_kobj_path: path = '/kernel/slab/:at-0000040'
[    6.754872] debugfs: creating file 'ext4'
[    6.755543] debugfs: creating file 'mballoc-debug'
[    6.756299] kobject: 'ext4_inode_cache' (ca260a4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.757733] kobject: 'ext4_inode_cache' (ca260a4c): kobject_uevent_env
[    6.758674] kobject: 'ext4_inode_cache' (ca260a4c): fill_kobj_path: path = '/kernel/slab/ext4_inode_cache'
[    6.760204] kobject: ':at-0000032' (ca260acc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.761600] kobject: ':at-0000032' (ca260acc): kobject_uevent_env
[    6.762475] kobject: ':at-0000032' (ca260acc): fill_kobj_path: path = '/kernel/slab/:at-0000032'
[    6.763972] kobject: ':at-0000016' (ca260b4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.765353] kobject: ':at-0000016' (ca260b4c): kobject_uevent_env
[    6.766232] kobject: ':at-0000016' (ca260b4c): fill_kobj_path: path = '/kernel/slab/:at-0000016'
[    6.767612] kobject: ':at-0000064' (ca260bcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.769003] kobject: ':at-0000064' (ca260bcc): kobject_uevent_env
[    6.769883] kobject: ':at-0000064' (ca260bcc): fill_kobj_path: path = '/kernel/slab/:at-0000064'
[    6.771338] kobject: ':at-0000256' (ca260c4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.772740] kobject: ':at-0000256' (ca260c4c): kobject_uevent_env
[    6.773681] kobject: ':at-0000256' (ca260c4c): fill_kobj_path: path = '/kernel/slab/:at-0000256'
[    6.775103] debugfs: creating file 'jbd2'
[    6.775772] debugfs: creating file 'jbd2-debug'
[    6.776504] kobject: 'hugetlbfs_inode_cache' (ca260ccc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.777988] kobject: 'hugetlbfs_inode_cache' (ca260ccc): kobject_uevent_env
[    6.778970] kobject: 'hugetlbfs_inode_cache' (ca260ccc): fill_kobj_path: path = '/kernel/slab/hugetlbfs_inode_cache'
[    6.780597] kobject: 'isofs_inode_cache' (ca260dcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.782032] kobject: 'isofs_inode_cache' (ca260dcc): kobject_uevent_env
[    6.782980] kobject: 'isofs_inode_cache' (ca260dcc): fill_kobj_path: path = '/kernel/slab/isofs_inode_cache'
[    6.784591] kobject: 'udf_inode_cache' (ca260e4c): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.786009] kobject: 'udf_inode_cache' (ca260e4c): kobject_uevent_env
[    6.786944] kobject: 'udf_inode_cache' (ca260e4c): fill_kobj_path: path = '/kernel/slab/udf_inode_cache'
[    6.791367] alg: No test for fcrypt (fcrypt-generic)
[    6.796440] alg: No test for stdrng (krng)
[    6.800468] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.801427] async_tx: api initialized (async)
[    6.802157] kobject: ':t-0000288' (c789cdcc): kobject_add_internal: parent: 'slab', set: 'slab'
[    6.803548] kobject: ':t-0000288' (c789cdcc): kobject_uevent_env
[    6.806540] kobject: ':t-0000288' (c789cdcc): fill_kobj_path: path = '/kernel/slab/:t-0000288'
[    6.807906] device class 'bsg': registering
[    6.808608] kobject: 'bsg' (cc2a880c): kobject_add_internal: parent: 'class', set: 'class'
[    6.809921] kobject: 'bsg' (cc2a880c): kobject_uevent_env
[    6.811191] kobject: 'bsg' (cc2a880c): fill_kobj_path: path = '/class/bsg'
[    6.812309] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    6.813539] io scheduler noop registered (default)
[    6.814420] start plist test
[    6.816352] end plist test
[    6.816939] debugfs: creating file 'debug_objects'
[    6.817701] debugfs: creating file 'stats'
[    6.818396] bus: 'platform': add driver basic-mmio-gpio
[    6.819202] kobject: 'basic-mmio-gpio' (ca1bdf00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.821129] kobject: 'basic-mmio-gpio' (ca1bdf00): kobject_uevent_env
[    6.822078] kobject: 'basic-mmio-gpio' (ca1bdf00): fill_kobj_path: path = '/bus/platform/drivers/basic-mmio-gpio'
[    6.823706] bus: 'pci': add driver ml_ioh_gpio
[    6.824473] kobject: 'ml_ioh_gpio' (ca1bdf60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.825911] kobject: 'ml_ioh_gpio' (ca1bdf60): kobject_uevent_env
[    6.826801] kobject: 'ml_ioh_gpio' (ca1bdf60): fill_kobj_path: path = '/bus/pci/drivers/ml_ioh_gpio'
[    6.828187] bus: 'pci': add driver pch_gpio
[    6.828899] kobject: 'pch_gpio' (c7904000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.830544] kobject: 'pch_gpio' (c7904000): kobject_uevent_env
[    6.831647] kobject: 'pch_gpio' (c7904000): fill_kobj_path: path = '/bus/pci/drivers/pch_gpio'
[    6.833004] bus: 'platform': add driver rdc321x-gpio
[    6.833935] kobject: 'rdc321x-gpio' (c7904060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.835441] kobject: 'rdc321x-gpio' (c7904060): kobject_uevent_env
[    6.836339] kobject: 'rdc321x-gpio' (c7904060): fill_kobj_path: path = '/bus/platform/drivers/rdc321x-gpio'
[    6.837817] bus: 'platform': add driver sch_gpio
[    6.838545] kobject: 'sch_gpio' (c79040c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.839952] kobject: 'sch_gpio' (c79040c0): kobject_uevent_env
[    6.841276] kobject: 'sch_gpio' (c79040c0): fill_kobj_path: path = '/bus/platform/drivers/sch_gpio'
[    6.842737] bus: 'platform': add driver vx855_gpio
[    6.843484] kobject: 'vx855_gpio' (c7904120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.845160] kobject: 'vx855_gpio' (c7904120): kobject_uevent_env
[    6.846049] kobject: 'vx855_gpio' (c7904120): fill_kobj_path: path = '/bus/platform/drivers/vx855_gpio'
[    6.847497] bus: 'pci': add driver ioapic
[    6.848178] kobject: 'ioapic' (c7904780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.849549] kobject: 'ioapic' (c7904780): kobject_uevent_env
[    6.850716] kobject: 'ioapic' (c7904780): fill_kobj_path: path = '/bus/pci/drivers/ioapic'
[    6.852158] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.852989] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    6.854057] debugfs: creating file 'cpqhp'
[    6.854742] bus: 'pci': add driver compaq_pci_hotplug
[    6.855510] kobject: 'compaq_pci_hotplug' (c79047e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.857010] kobject: 'compaq_pci_hotplug' (c79047e0): kobject_uevent_env
[    6.857966] kobject: 'compaq_pci_hotplug' (c79047e0): fill_kobj_path: path = '/bus/pci/drivers/compaq_pci_hotplug'
[    6.859489] bus: 'pci': add driver shpchp
[    6.860382] kobject: 'shpchp' (c79048a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.861852] kobject: 'shpchp' (c79048a0): kobject_uevent_env
[    6.862688] kobject: 'shpchp' (c79048a0): fill_kobj_path: path = '/bus/pci/drivers/shpchp'
[    6.864141] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.865114] device: 'fbcon': device_add
[    6.865116] kobject: 'graphics' (c789fb40): kobject_add_internal: parent: 'virtual', set: '(null)'
[    6.865119] kobject: 'fbcon' (cd96f008): kobject_add_internal: parent: 'graphics', set: 'devices'
[    6.865128] PM: Adding info for No Bus:fbcon
[    6.865129] kobject: 'fbcon' (cd96f008): kobject_uevent_env
[    6.865131] kobject: 'fbcon' (cd96f008): fill_kobj_path: path = '/devices/virtual/graphics/fbcon'
[    6.871920] bus: 'spi': add driver l4f00242t03
[    6.872650] kobject: 'l4f00242t03' (c7904960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.874194] kobject: 'l4f00242t03' (c7904960): kobject_uevent_env
[    6.875087] kobject: 'l4f00242t03' (c7904960): fill_kobj_path: path = '/bus/spi/drivers/l4f00242t03'
[    6.876475] bus: 'spi': add driver VGG2432A4
[    6.877193] kobject: 'VGG2432A4' (c79049c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.878608] kobject: 'VGG2432A4' (c79049c0): kobject_uevent_env
[    6.879470] kobject: 'VGG2432A4' (c79049c0): fill_kobj_path: path = '/bus/spi/drivers/VGG2432A4'
[    6.881165] bus: 'spi': add driver tdo24m
[    6.881888] kobject: 'tdo24m' (c7904a20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.883260] kobject: 'tdo24m' (c7904a20): kobject_uevent_env
[    6.884171] kobject: 'tdo24m' (c7904a20): fill_kobj_path: path = '/bus/spi/drivers/tdo24m'
[    6.885481] bus: 'spi': add driver s6e63m0
[    6.886177] kobject: 's6e63m0' (c7904a80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.887558] kobject: 's6e63m0' (c7904a80): kobject_uevent_env
[    6.888406] kobject: 's6e63m0' (c7904a80): fill_kobj_path: path = '/bus/spi/drivers/s6e63m0'
[    6.889758] bus: 'platform': add driver generic-bl
[    6.890757] kobject: 'generic-bl' (c7904ae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.892157] kobject: 'generic-bl' (c7904ae0): kobject_uevent_env
[    6.893038] kobject: 'generic-bl' (c7904ae0): fill_kobj_path: path = '/bus/platform/drivers/generic-bl'
[    6.894476] bus: 'i2c': add driver adp8860_bl
[    6.895205] kobject: 'adp8860_bl' (c7904b40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.896624] kobject: 'adp8860_bl' (c7904b40): kobject_uevent_env
[    6.897490] kobject: 'adp8860_bl' (c7904b40): fill_kobj_path: path = '/bus/i2c/drivers/adp8860_bl'
[    6.898891] i2c-core: driver [adp8860_bl] using legacy suspend method
[    6.899806] i2c-core: driver [adp8860_bl] using legacy resume method
[    6.900938] i2c-core: driver [adp8860_bl] registered
[    6.901750] bus: 'platform': add driver pcf50633-backlight
[    6.902565] kobject: 'pcf50633-backlight' (c7904ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.904185] kobject: 'pcf50633-backlight' (c7904ba0): kobject_uevent_env
[    6.905134] kobject: 'pcf50633-backlight' (c7904ba0): fill_kobj_path: path = '/bus/platform/drivers/pcf50633-backlight'
[    6.906720] bus: 'pci': add driver CyberPro
[    6.907404] kobject: 'CyberPro' (c7904c00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.908789] kobject: 'CyberPro' (c7904c00): kobject_uevent_env
[    6.909644] kobject: 'CyberPro' (c7904c00): fill_kobj_path: path = '/bus/pci/drivers/CyberPro'
[    6.911270] rivafb_setup START
[    6.911854] bus: 'pci': add driver rivafb
[    6.912519] kobject: 'rivafb' (c7904c60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.914014] kobject: 'rivafb' (c7904c60): kobject_uevent_env
[    6.914871] kobject: 'rivafb' (c7904c60): fill_kobj_path: path = '/bus/pci/drivers/rivafb'
[    6.916180] bus: 'pci': add driver nvidiafb
[    6.916877] kobject: 'nvidiafb' (c7904cc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.918259] kobject: 'nvidiafb' (c7904cc0): kobject_uevent_env
[    6.919138] kobject: 'nvidiafb' (c7904cc0): fill_kobj_path: path = '/bus/pci/drivers/nvidiafb'
[    6.920748] bus: 'pci': add driver radeonfb
[    6.921460] kobject: 'radeonfb' (c7904d20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.922868] kobject: 'radeonfb' (c7904d20): kobject_uevent_env
[    6.923860] kobject: 'radeonfb' (c7904d20): fill_kobj_path: path = '/bus/pci/drivers/radeonfb'
[    6.925215] bus: 'pci': add driver imsttfb
[    6.925897] kobject: 'imsttfb' (c7904d80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.927295] kobject: 'imsttfb' (c7904d80): kobject_uevent_env
[    6.928144] kobject: 'imsttfb' (c7904d80): fill_kobj_path: path = '/bus/pci/drivers/imsttfb'
[    6.929472] vt8623fb: initializing
[    6.930237] bus: 'pci': add driver vt8623fb
[    6.931309] kobject: 'vt8623fb' (c7904de0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.932905] kobject: 'vt8623fb' (c7904de0): kobject_uevent_env
[    6.933870] kobject: 'vt8623fb' (c7904de0): fill_kobj_path: path = '/bus/pci/drivers/vt8623fb'
[    6.935215] vmlfb: initializing
[    6.935814] bus: 'pci': add driver vmlfb
[    6.936468] kobject: 'vmlfb' (c7904e40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.937835] kobject: 'vmlfb' (c7904e40): kobject_uevent_env
[    6.938674] kobject: 'vmlfb' (c7904e40): fill_kobj_path: path = '/bus/pci/drivers/vmlfb'
[    6.940076] Could not find Carillo Ranch MCH device.
[    6.941271] bus: 'platform': add driver hecubafb
[    6.942206] kobject: 'hecubafb' (c7904ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.943656] kobject: 'hecubafb' (c7904ea0): kobject_uevent_env
[    6.944747] kobject: 'hecubafb' (c7904ea0): fill_kobj_path: path = '/bus/platform/drivers/hecubafb'
[    6.946132] no IO addresses supplied
[    6.946768] bus: 'pci': add driver cirrusfb
[    6.949454] kobject: 'cirrusfb' (c7904f00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[    6.951338] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver cirrusfb
[    6.953571] bus: 'pci': really_probe: probing driver cirrusfb with device 0000:00:02.0
[    6.955686] pci_notify
[    6.956561] cirrusfb 0000:00:02.0:  Found PCI device, base address 0 is 0xfc000000, btype set to 5
[    6.958816] cirrusfb 0000:00:02.0:  base address 1 is 0xfebf0000
[    6.960373] cirrusfb 0000:00:02.0: Attempt to get PCI info for Cirrus Graphics Card
[    6.962503] cirrusfb 0000:00:02.0: Board address: 0xfc000000, register address: 0xfebf0000
[    6.964877] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
[    6.967172] cirrusfb 0000:00:02.0: (RAM start set to: 0xd0880000)
[    6.968634] cirrusfb 0000:00:02.0: desired pixclock: 25175 kHz
[    6.970171] cirrusfb 0000:00:02.0: desired pixclock: 25175 kHz
[    6.971576] device: 'fb0': device_add
[    6.972559] kobject: 'graphics' (c79062c0): kobject_add_internal: parent: '0000:00:02.0', set: '(null)'
[    6.974750] kobject: 'fb0' (cd96f808): kobject_add_internal: parent: 'graphics', set: 'devices'
[    6.976843] PM: Adding info for No Bus:fb0
[    6.977891] kobject: 'fb0' (cd96f808): kobject_uevent_env
[    6.979135] kobject: 'fb0' (cd96f808): fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/graphics/fb0'
[    6.981672] fbcon: CL Picasso4 (fb0) is primary device
[    6.982996] device: 'vtcon1': device_add
[    6.982999] kobject: 'vtcon1' (cd96fc08): kobject_add_internal: parent: 'vtconsole', set: 'devices'
[    6.983010] PM: Adding info for No Bus:vtcon1
[    6.983011] kobject: 'vtcon1' (cd96fc08): kobject_uevent_env
[    6.983014] kobject: 'vtcon1' (cd96fc08): fill_kobj_path: path = '/devices/virtual/vtconsole/vtcon1'
[    6.994479] cirrusfb 0000:00:02.0: Requested mode: 640x480x8
[    7.095686] cirrusfb 0000:00:02.0: CRT0: 95
[    7.095690] cirrusfb 0000:00:02.0: CRT1: 79
[    7.095693] cirrusfb 0000:00:02.0: CRT2: 80
[    7.095697] cirrusfb 0000:00:02.0: CRT3: 128+4
[    7.095700] cirrusfb 0000:00:02.0: CRT4: 84
[    7.095703] cirrusfb 0000:00:02.0: CRT5: 128
[    7.095706] cirrusfb 0000:00:02.0: CRT6: 11
[    7.095709] cirrusfb 0000:00:02.0: CRT7: 62
[    7.095712] cirrusfb 0000:00:02.0: CRT9: 64
[    7.095715] cirrusfb 0000:00:02.0: CRT10: 234
[    7.095718] cirrusfb 0000:00:02.0: CRT11: 64+32+12
[    7.095722] cirrusfb 0000:00:02.0: CRT12: 223
[    7.095725] cirrusfb 0000:00:02.0: CRT15: 224
[    7.095728] cirrusfb 0000:00:02.0: CRT16: 11
[    7.095731] cirrusfb 0000:00:02.0: CRT18: 0xff
[    7.095734] cirrusfb 0000:00:02.0: CRT1a: 144
[    7.095739] cirrusfb 0000:00:02.0: VCLK freq: 25175 kHz  nom: 51  den: 29  div: 0
[    7.095746] cirrusfb 0000:00:02.0: Read MCLK of 80538 kHz
[    7.095768] cirrusfb 0000:00:02.0: preparing for 8 bit deep display
[    7.102262] cirrusfb 0000:00:02.0: CL_SEQR1: 1
[    7.102274] cirrusfb 0000:00:02.0: Requested mode: 640x480x8
[    7.203834] cirrusfb 0000:00:02.0: CRT0: 95
[    7.203841] cirrusfb 0000:00:02.0: CRT1: 79
[    7.203845] cirrusfb 0000:00:02.0: CRT2: 80
[    7.203848] cirrusfb 0000:00:02.0: CRT3: 128+4
[    7.203851] cirrusfb 0000:00:02.0: CRT4: 84
[    7.203854] cirrusfb 0000:00:02.0: CRT5: 128
[    7.203858] cirrusfb 0000:00:02.0: CRT6: 11
[    7.203861] cirrusfb 0000:00:02.0: CRT7: 62
[    7.203864] cirrusfb 0000:00:02.0: CRT9: 64
[    7.203867] cirrusfb 0000:00:02.0: CRT10: 234
[    7.203870] cirrusfb 0000:00:02.0: CRT11: 64+32+12
[    7.203873] cirrusfb 0000:00:02.0: CRT12: 223
[    7.203876] cirrusfb 0000:00:02.0: CRT15: 224
[    7.203879] cirrusfb 0000:00:02.0: CRT16: 11
[    7.203882] cirrusfb 0000:00:02.0: CRT18: 0xff
[    7.203885] cirrusfb 0000:00:02.0: CRT1a: 144
[    7.203892] cirrusfb 0000:00:02.0: VCLK freq: 25175 kHz  nom: 51  den: 29  div: 0
[    7.203899] cirrusfb 0000:00:02.0: Read MCLK of 80538 kHz
[    7.203922] cirrusfb 0000:00:02.0: preparing for 8 bit deep display
[    7.205143] cirrusfb 0000:00:02.0: CL_SEQR1: 1
[    7.250331] tsc: Refined TSC clocksource calibration: 2693.507 MHz
[    7.250353] Switching to clocksource tsc
[    7.316552] Console: switching to colour frame buffer device 80x30
[   12.493501] driver: '0000:00:02.0': driver_bound: bound to device 'cirrusfb'
[   12.590416] pci_notify
[   12.681862] bus: 'pci': really_probe: bound device 0000:00:02.0 to driver cirrusfb
[   12.876696] kobject: 'cirrusfb' (c7904f00): kobject_uevent_env
[   12.978479] kobject: 'cirrusfb' (c7904f00): fill_kobj_path: path = '/bus/pci/drivers/cirrusfb'
[   13.179048] bus: 'platform': add driver broadsheetfb
[   13.287543] kobject: 'broadsheetfb' (c780a000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   13.501807] kobject: 'broadsheetfb' (c780a000): kobject_uevent_env
[   13.612354] kobject: 'broadsheetfb' (c780a000): fill_kobj_path: path = '/bus/platform/drivers/broadsheetfb'
[   13.838515] bus: 'platform': add driver sm501-fb
[   13.953467] kobject: 'sm501-fb' (c780a060): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   14.193230] kobject: 'sm501-fb' (c780a060): kobject_uevent_env
[   14.315173] kobject: 'sm501-fb' (c780a060): fill_kobj_path: path = '/bus/platform/drivers/sm501-fb'
[   14.564844] bus: 'acpi': add driver ac
[   14.691835] kobject: 'ac' (c780a0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   14.953253] kobject: 'ac' (c780a0c0): kobject_uevent_env
[   15.078632] kobject: 'ac' (c780a0c0): fill_kobj_path: path = '/bus/acpi/drivers/ac'
[   15.324672] bus: 'acpi': add driver button
[   15.452236] kobject: 'button' (c780a120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   15.703510] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[   15.950325] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[   16.204250] device: 'input0': device_add
[   16.332931] kobject: 'input' (cd96a580): kobject_add_internal: parent: 'LNXPWRBN:00', set: '(null)'
[   16.692138] kobject: 'input0' (c780c1a8): kobject_add_internal: parent: 'input', set: 'devices'
[   17.076264] PM: Adding info for No Bus:input0
[   17.275006] kobject: 'input0' (c780c1a8): kobject_uevent_env
[   17.473145] kobject: 'input0' (c780c1a8): fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0'
[   17.870251] kobject: 'input0' (c780c1a8): fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0'
[   18.271100] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   18.662710] ACPI: Power Button [PWRF]
[   18.863674] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   19.067492] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[   19.481522] kobject: 'button' (c780a120): kobject_uevent_env
[   19.694022] kobject: 'button' (c780a120): fill_kobj_path: path = '/bus/acpi/drivers/button'
[   20.102044] bus: 'acpi': add driver fan
[   20.309452] kobject: 'fan' (c780a1e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   20.711800] kobject: 'fan' (c780a1e0): kobject_uevent_env
[   20.875747] kobject: 'fan' (c780a1e0): fill_kobj_path: path = '/bus/acpi/drivers/fan'
[   21.154347] bus: 'acpi': add driver video
[   21.293232] kobject: 'video' (c780a240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   21.562299] kobject: 'video' (c780a240): kobject_uevent_env
[   21.696589] kobject: 'video' (c780a240): fill_kobj_path: path = '/bus/acpi/drivers/video'
[   21.941227] bus: 'acpi': add driver processor
[   22.064375] kobject: 'processor' (c780a2a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   22.307203] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[   22.555601] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[   22.816247] device: 'cooling_device0': device_add
[   22.946326] kobject: 'thermal' (c789ae00): kobject_add_internal: parent: 'virtual', set: '(null)'
[   23.232068] kobject: 'cooling_device0' (c78c2020): kobject_add_internal: parent: 'thermal', set: 'devices'
[   23.503550] PM: Adding info for No Bus:cooling_device0
[   23.635843] kobject: 'cooling_device0' (c78c2020): kobject_uevent_env
[   23.760793] kobject: 'cooling_device0' (c78c2020): fill_kobj_path: path = '/devices/virtual/thermal/cooling_device0'
[   24.010710] processor LNXCPU:00: registered as cooling_device0
[   24.137764] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[   24.262902] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[   24.510844] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[   24.767870] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[   25.031041] device: 'cooling_device1': device_add
[   25.166750] kobject: 'cooling_device1' (c78c2220): kobject_add_internal: parent: 'thermal', set: 'devices'
[   25.434618] PM: Adding info for No Bus:cooling_device1
[   25.569902] kobject: 'cooling_device1' (c78c2220): kobject_uevent_env
[   25.705496] kobject: 'cooling_device1' (c78c2220): fill_kobj_path: path = '/devices/virtual/thermal/cooling_device1'
[   25.968307] processor LNXCPU:01: registered as cooling_device1
[   26.097441] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[   26.229460] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[   26.566153] kobject: 'processor' (c780a2a0): kobject_uevent_env
[   26.754496] kobject: 'processor' (c780a2a0): fill_kobj_path: path = '/bus/acpi/drivers/processor'
[   27.153193] bus: 'acpi': add driver thermal
[   27.354509] kobject: 'thermal' (c780a3c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   27.753839] kobject: 'thermal' (c780a3c0): kobject_uevent_env
[   27.951962] kobject: 'thermal' (c780a3c0): fill_kobj_path: path = '/bus/acpi/drivers/thermal'
[   28.351836] bus: 'pci': add driver pch-dma
[   28.352572] bus: 'acpi': add driver battery
[   28.352596] kobject: 'battery' (c79080c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   28.352717] kobject: 'battery' (c79080c0): kobject_uevent_env
[   28.352730] kobject: 'battery' (c79080c0): fill_kobj_path: path = '/bus/acpi/drivers/battery'
[   29.690446] kobject: 'pch-dma' (c780a420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   30.045275] kobject: 'pch-dma' (c780a420): kobject_uevent_env
[   30.224309] kobject: 'pch-dma' (c780a420): fill_kobj_path: path = '/bus/pci/drivers/pch-dma'
[   30.577972] bus: 'platform': add driver reg-virt-consumer
[   30.756624] kobject: 'reg-virt-consumer' (c780a480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   31.112676] kobject: 'reg-virt-consumer' (c780a480): kobject_uevent_env
[   31.290135] kobject: 'reg-virt-consumer' (c780a480): fill_kobj_path: path = '/bus/platform/drivers/reg-virt-consumer'
[   31.632954] bus: 'spi': add driver tps6524x
[   31.804328] kobject: 'tps6524x' (c780a4e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   32.019980] kobject: 'tps6524x' (c780a4e0): kobject_uevent_env
[   32.126627] kobject: 'tps6524x' (c780a4e0): fill_kobj_path: path = '/bus/spi/drivers/tps6524x'
[   32.339772] device: 'ptmx': device_add
[   32.445324] kobject: 'ptmx' (c78c2408): kobject_add_internal: parent: 'tty', set: 'devices'
[   32.659801] PM: Adding info for No Bus:ptmx
[   32.772531] kobject: 'ptmx' (c78c2408): kobject_uevent_env
[   32.879013] kobject: 'ptmx' (c78c2408): fill_kobj_path: path = '/devices/virtual/tty/ptmx'
[   33.097510] r3964: Philips r3964 Driver $Revision: 1.10 $
[   33.209967] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   33.323254] Registering platform device 'serial8250'. Parent at platform
[   33.435805] device: 'serial8250': device_add
[   33.550471] kobject: 'serial8250' (c78c2610): kobject_add_internal: parent: 'platform', set: 'devices'
[   33.779041] bus: 'platform': add device serial8250
[   33.890803] PM: Adding info for platform:serial8250
[   34.004116] kobject: 'serial8250' (c78c2610): kobject_uevent_env
[   34.114168] kobject: 'serial8250' (c78c2610): fill_kobj_path: path = '/devices/platform/serial8250'
[   34.356088] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   34.472670] device: 'ttyS0': device_add
[   34.588580] kobject: 'tty' (cd961ec0): kobject_add_internal: parent: 'serial8250', set: '(null)'
[   34.827675] kobject: 'ttyS0' (c78c2808): kobject_add_internal: parent: 'tty', set: 'devices'
[   35.073266] PM: Adding info for No Bus:ttyS0
[   35.199500] kobject: 'ttyS0' (c78c2808): kobject_uevent_env
[   35.324402] kobject: 'ttyS0' (c78c2808): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS0'
[   35.572922] device: 'ttyS1': device_add
[   35.730246] kobject: 'ttyS1' (c78c2a08): kobject_add_internal: parent: 'tty', set: 'devices'
[   35.999992] PM: Adding info for No Bus:ttyS1
[   36.127020] kobject: 'ttyS1' (c78c2a08): kobject_uevent_env
[   36.247222] kobject: 'ttyS1' (c78c2a08): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS1'
[   36.493702] CPA self-test:
[   36.614995] device: 'ttyS2': device_add
[   36.730312]  4k 2046 large 62 gb 0 x 2108[c0000000-cfffd000] miss 0
[   36.850502] kobject: 'ttyS2' (c78c2c08): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.214609]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   37.402274] PM: Adding info for No Bus:ttyS2
[   37.618513]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   37.624993] kobject: 'ttyS2' (c78c2c08): kobject_uevent_env
[   37.625035] kobject: 'ttyS2' (c78c2c08): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS2'
[   37.625737] device: 'ttyS3': device_add
[   37.625772] kobject: 'ttyS3' (cd948a08): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.625912] PM: Adding info for No Bus:ttyS3
[   37.625914] kobject: 'ttyS3' (cd948a08): kobject_uevent_env
[   37.625927] kobject: 'ttyS3' (cd948a08): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS3'
[   37.626398] bus: 'platform': add driver serial8250
[   37.626420] kobject: 'serial8250' (c7908180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.626450] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   37.626458] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   37.626468] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   37.626470] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   37.626476] kobject: 'serial8250' (c7908180): kobject_uevent_env
[   37.626479] kobject: 'serial8250' (c7908180): fill_kobj_path: path = '/bus/platform/drivers/serial8250'
[   37.626511] bus: 'pnp': add driver serial
[   37.626513] kobject: 'serial' (c79081e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.626583] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[   37.626585] bus: 'pnp': really_probe: probing driver serial with device 00:06
[   37.626632] device: 'ttyS0': device_unregister
[   37.626635] PM: Removing info for No Bus:ttyS0
[   37.626693] kobject: 'ttyS0' (c78c2808): kobject_uevent_env
[   37.626696] kobject: 'ttyS0' (c78c2808): fill_kobj_path: path = '/devices/platform/serial8250/tty/ttyS0'
[   37.626703] sysfs ttyS0: removing dir
[   37.626705] kobject: 'ttyS0' (c78c2808): kobject_cleanup
[   37.626706] kobject: 'ttyS0' (c78c2808): calling ktype release
[   37.626707] device: 'ttyS0': device_create_release
[   37.626713] kobject: 'ttyS0': free name
[   37.661601] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   37.661728] device: 'ttyS0': device_add
[   37.661748] kobject: 'tty' (c7909c00): kobject_add_internal: parent: '00:06', set: '(null)'
[   37.661784] kobject: 'ttyS0' (c792e008): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.661854] PM: Adding info for No Bus:ttyS0
[   37.661855] kobject: 'ttyS0' (c792e008): kobject_uevent_env
[   37.661868] kobject: 'ttyS0' (c792e008): fill_kobj_path: path = '/devices/pnp0/00:06/tty/ttyS0'
[   37.661926] driver: '00:06': driver_bound: bound to device 'serial'
[   37.661932] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[   37.661952] kobject: 'serial' (c79081e0): kobject_uevent_env
[   37.661957] kobject: 'serial' (c79081e0): fill_kobj_path: path = '/bus/pnp/drivers/serial'
[   37.661986] bus: 'pci': add driver serial
[   37.661988] kobject: 'serial' (c79082a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662024] kobject: 'serial' (c79082a0): kobject_uevent_env
[   37.662026] kobject: 'serial' (c79082a0): fill_kobj_path: path = '/bus/pci/drivers/serial'
[   37.662082] bus: 'pci': add driver jsm
[   37.662084] kobject: 'jsm' (c79083c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662089] kobject: 'jsm' (c79083c0): kobject_uevent_env
[   37.662091] kobject: 'jsm' (c79083c0): fill_kobj_path: path = '/bus/pci/drivers/jsm'
[   37.662528] bus: 'platform': add driver altera_uart
[   37.662574] kobject: 'altera_uart' (c79084e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662661] kobject: 'altera_uart' (c79084e0): kobject_uevent_env
[   37.662668] kobject: 'altera_uart' (c79084e0): fill_kobj_path: path = '/bus/platform/drivers/altera_uart'
[   37.662717] bus: 'platform': add driver timb-uart
[   37.662722] kobject: 'timb-uart' (c7908540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662744] kobject: 'timb-uart' (c7908540): kobject_uevent_env
[   37.662746] kobject: 'timb-uart' (c7908540): fill_kobj_path: path = '/bus/platform/drivers/timb-uart'
[   37.662794] bus: 'platform': add driver altera_jtaguart
[   37.662797] kobject: 'altera_jtaguart' (c7908600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662801] kobject: 'altera_jtaguart' (c7908600): kobject_uevent_env
[   37.662803] kobject: 'altera_jtaguart' (c7908600): fill_kobj_path: path = '/bus/platform/drivers/altera_jtaguart'
[   37.662856] bus: 'pci': add driver pch_uart
[   37.662858] kobject: 'pch_uart' (c7908720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662883] kobject: 'pch_uart' (c7908720): kobject_uevent_env
[   37.662885] kobject: 'pch_uart' (c7908720): fill_kobj_path: path = '/bus/pci/drivers/pch_uart'
[   37.662895] bus: 'platform': add driver xuartps
[   37.662897] kobject: 'xuartps' (c7908840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662901] kobject: 'xuartps' (c7908840): kobject_uevent_env
[   37.662903] kobject: 'xuartps' (c7908840): fill_kobj_path: path = '/bus/platform/drivers/xuartps'
[   37.662921] registering driver ipwireless
[   37.662930] bus: 'pcmcia': add driver ipwireless
[   37.662932] kobject: 'ipwireless' (c7908900): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.662936] kobject: 'ipwireless' (c7908900): kobject_uevent_env
[   37.662938] kobject: 'ipwireless' (c7908900): fill_kobj_path: path = '/bus/pcmcia/drivers/ipwireless'
[   37.663729] device class 'raw': registering
[   37.663751] kobject: 'raw' (cc2a8f0c): kobject_add_internal: parent: 'class', set: 'class'
[   37.663787] kobject: 'raw' (cc2a8f0c): kobject_uevent_env
[   37.663796] kobject: 'raw' (cc2a8f0c): fill_kobj_path: path = '/class/raw'
[   37.663855] device: 'rawctl': device_add
[   37.663861] kobject: 'raw' (c790ac40): kobject_add_internal: parent: 'virtual', set: '(null)'
[   37.663870] kobject: 'rawctl' (c792e408): kobject_add_internal: parent: 'raw', set: 'devices'
[   37.663927] PM: Adding info for No Bus:rawctl
[   37.663929] kobject: 'rawctl' (c792e408): kobject_uevent_env
[   37.663931] kobject: 'rawctl' (c792e408): fill_kobj_path: path = '/devices/virtual/raw/rawctl'
[   37.663941] Generic RTC Driver v1.07
[   37.663945] device: 'rtc': device_add
[   37.663952] kobject: 'rtc' (c792e608): kobject_add_internal: parent: 'misc', set: 'devices'
[   37.663977] PM: Adding info for No Bus:rtc
[   37.663979] kobject: 'rtc' (c792e608): kobject_uevent_env
[   37.663981] kobject: 'rtc' (c792e608): fill_kobj_path: path = '/devices/virtual/misc/rtc'
[   37.664011] device: 'nvram': device_add
[   37.664012] kobject: 'nvram' (c792e808): kobject_add_internal: parent: 'misc', set: 'devices'
[   37.664021] PM: Adding info for No Bus:nvram
[   37.664021] kobject: 'nvram' (c792e808): kobject_uevent_env
[   37.664023] kobject: 'nvram' (c792e808): fill_kobj_path: path = '/devices/virtual/misc/nvram'
[   37.664029] Non-volatile memory driver v1.3
[   37.664048] toshiba: not a supported Toshiba laptop
[   37.664123] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[   37.664124] device: 'pc8736x_gpio.0': device_add
[   37.664125] kobject: 'pc8736x_gpio.0' (c792ea10): kobject_add_internal: parent: 'platform', set: 'devices'
[   37.664132] bus: 'platform': add device pc8736x_gpio.0
[   37.664144] PM: Adding info for platform:pc8736x_gpio.0
[   37.664145] kobject: 'pc8736x_gpio.0' (c792ea10): kobject_uevent_env
[   37.664147] kobject: 'pc8736x_gpio.0' (c792ea10): fill_kobj_path: path = '/devices/platform/pc8736x_gpio.0'
[   37.664193] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[   37.664717] platform pc8736x_gpio.0: no device found
[   37.664718] PM: Removing info for platform:pc8736x_gpio.0
[   37.664738] bus: 'platform': remove device pc8736x_gpio.0
[   37.664742] kobject: 'pc8736x_gpio.0' (c792ea10): kobject_uevent_env
[   37.664745] kobject: 'pc8736x_gpio.0' (c792ea10): fill_kobj_path: path = '/devices/platform/pc8736x_gpio.0'
[   37.664750] sysfs pc8736x_gpio.0: removing dir
[   37.664752] kobject: 'pc8736x_gpio.0' (c792ea10): kobject_cleanup
[   37.664753] kobject: 'pc8736x_gpio.0' (c792ea10): calling ktype release
[   37.664754] kobject: 'pc8736x_gpio.0': free name
[   37.664755] nsc_gpio initializing
[   37.664810] smapi::smapi_init, ERROR invalid usSmapiID
[   37.664811] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   37.664811] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   37.664817] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   37.664829] registering driver synclink_cs
[   37.664833] bus: 'pcmcia': add driver synclink_cs
[   37.664836] kobject: 'synclink_cs' (c7908ba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.664840] kobject: 'synclink_cs' (c7908ba0): kobject_uevent_env
[   37.664843] kobject: 'synclink_cs' (c7908ba0): fill_kobj_path: path = '/bus/pcmcia/drivers/synclink_cs'
[   37.664855] device: 'ttySLP0': device_add
[   37.664857] kobject: 'ttySLP0' (c792ea08): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.664877] PM: Adding info for No Bus:ttySLP0
[   37.664878] kobject: 'ttySLP0' (c792ea08): kobject_uevent_env
[   37.664880] kobject: 'ttySLP0' (c792ea08): fill_kobj_path: path = '/devices/virtual/tty/ttySLP0'
[   37.664886] device: 'ttySLP1': device_add
[   37.664887] kobject: 'ttySLP1' (c792ec08): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.664898] PM: Adding info for No Bus:ttySLP1
[   37.664899] kobject: 'ttySLP1' (c792ec08): kobject_uevent_env
[   37.664901] kobject: 'ttySLP1' (c792ec08): fill_kobj_path: path = '/devices/virtual/tty/ttySLP1'
[   37.664905] device: 'ttySLP2': device_add
[   37.664906] kobject: 'ttySLP2' (c792ee08): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.665342] PM: Adding info for No Bus:ttySLP2
[   37.665352] kobject: 'ttySLP2' (c792ee08): kobject_uevent_env
[   37.665376] kobject: 'ttySLP2' (c792ee08): fill_kobj_path: path = '/devices/virtual/tty/ttySLP2'
[   37.665474] device: 'ttySLP3': device_add
[   37.665475] kobject: 'ttySLP3' (c792f008): kobject_add_internal: parent: 'tty', set: 'devices'
[   37.665607] PM: Adding info for No Bus:ttySLP3
[   37.665608] kobject: 'ttySLP3' (c792f008): kobject_uevent_env
[   37.665611] kobject: 'ttySLP3' (c792f008): fill_kobj_path: path = '/devices/virtual/tty/ttySLP3'
[   37.665638] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[   37.665651] device class 'cardman_4000': registering
[   37.665659] kobject: 'cardman_4000' (cc2a800c): kobject_add_internal: parent: 'class', set: 'class'
[   37.665668] kobject: 'cardman_4000' (cc2a800c): kobject_uevent_env
[   37.665670] kobject: 'cardman_4000' (cc2a800c): fill_kobj_path: path = '/class/cardman_4000'
[   37.665694] registering driver cm4000_cs
[   37.665697] bus: 'pcmcia': add driver cm4000_cs
[   37.665699] kobject: 'cm4000_cs' (c7908ea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.665706] kobject: 'cm4000_cs' (c7908ea0): kobject_uevent_env
[   37.665707] kobject: 'cm4000_cs' (c7908ea0): fill_kobj_path: path = '/bus/pcmcia/drivers/cm4000_cs'
[   37.665710] device class 'cardman_4040': registering
[   37.665717] kobject: 'cardman_4040' (cc2c000c): kobject_add_internal: parent: 'class', set: 'class'
[   37.665719] kobject: 'cardman_4040' (cc2c000c): kobject_uevent_env
[   37.665721] kobject: 'cardman_4040' (cc2c000c): fill_kobj_path: path = '/class/cardman_4040'
[   37.665727] registering driver cm4040_cs
[   37.665727] bus: 'pcmcia': add driver cm4040_cs
[   37.665729] kobject: 'cm4040_cs' (c7908f60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.665732] kobject: 'cm4040_cs' (c7908f60): kobject_uevent_env
[   37.665734] kobject: 'cm4040_cs' (c7908f60): fill_kobj_path: path = '/bus/pcmcia/drivers/cm4040_cs'
[   37.665739] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   37.665739] Hangcheck: Using getrawmonotonic().
[   37.665768] device class 'drm': registering
[   37.665770] kobject: 'drm' (cc2c010c): kobject_add_internal: parent: 'class', set: 'class'
[   37.665772] kobject: 'drm' (cc2c010c): kobject_uevent_env
[   37.665774] kobject: 'drm' (cc2c010c): fill_kobj_path: path = '/class/drm'
[   37.665808] debugfs: creating file 'dri'
[   37.665878] [drm] Initialized drm 1.1.0 20060810
[   37.665955] bus: 'pci': add driver poulsbo
[   37.665957] kobject: 'poulsbo' (c790f0c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.666263] kobject: 'poulsbo' (c790f0c0): kobject_uevent_env
[   37.666387] kobject: 'poulsbo' (c790f0c0): fill_kobj_path: path = '/bus/pci/drivers/poulsbo'
[   37.666563] debugfs: creating file 'provoke-crash'
[   37.666640] debugfs: creating file 'DIRECT'
[   37.666650] lkdtm: No crash points registered, enable through debugfs
[   37.666674] bus: 'pci': add driver IOC4
[   37.666681] kobject: 'IOC4' (c790f120): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.666707] kobject: 'IOC4' (c790f120): kobject_uevent_env
[   37.666709] kobject: 'IOC4' (c790f120): fill_kobj_path: path = '/bus/pci/drivers/IOC4'
[   37.666713] device class 'enclosure': registering
[   37.666721] kobject: 'enclosure' (cc2c020c): kobject_add_internal: parent: 'class', set: 'class'
[   37.666739] kobject: 'enclosure' (cc2c020c): kobject_uevent_env
[   37.666741] kobject: 'enclosure' (cc2c020c): fill_kobj_path: path = '/class/enclosure'
[   37.666760] bus: 'platform': add driver cs5535-mfgpt
[   37.666762] kobject: 'cs5535-mfgpt' (c790f180): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.666776] kobject: 'cs5535-mfgpt' (c790f180): kobject_uevent_env
[   37.666779] kobject: 'cs5535-mfgpt' (c790f180): fill_kobj_path: path = '/bus/platform/drivers/cs5535-mfgpt'
[   37.666783] device class 'iLO': registering
[   37.666784] kobject: 'iLO' (cc2c030c): kobject_add_internal: parent: 'class', set: 'class'
[   37.667225] kobject: 'iLO' (cc2c030c): kobject_uevent_env
[   37.667248] kobject: 'iLO' (cc2c030c): fill_kobj_path: path = '/class/iLO'
[   37.667337] bus: 'pci': add driver hpilo
[   37.667344] kobject: 'hpilo' (c790f240): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667379] kobject: 'hpilo' (c790f240): kobject_uevent_env
[   37.667381] kobject: 'hpilo' (c790f240): fill_kobj_path: path = '/bus/pci/drivers/hpilo'
[   37.667415] bus: 'i2c': add driver isl29003
[   37.667417] kobject: 'isl29003' (c790f2a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667430] kobject: 'isl29003' (c790f2a0): kobject_uevent_env
[   37.667432] kobject: 'isl29003' (c790f2a0): fill_kobj_path: path = '/bus/i2c/drivers/isl29003'
[   37.667437] i2c-core: driver [isl29003] using legacy suspend method
[   37.667437] i2c-core: driver [isl29003] using legacy resume method
[   37.667441] i2c-core: driver [isl29003] registered
[   37.667443] bus: 'i2c': add driver at24
[   37.667444] kobject: 'at24' (c790f300): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667452] kobject: 'at24' (c790f300): kobject_uevent_env
[   37.667454] kobject: 'at24' (c790f300): fill_kobj_path: path = '/bus/i2c/drivers/at24'
[   37.667456] i2c-core: driver [at24] registered
[   37.667470] bus: 'spi': add driver at25
[   37.667472] kobject: 'at25' (c790f360): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667479] kobject: 'at25' (c790f360): kobject_uevent_env
[   37.667480] kobject: 'at25' (c790f360): fill_kobj_path: path = '/bus/spi/drivers/at25'
[   37.667483] bus: 'i2c': add driver eeprom
[   37.667488] kobject: 'eeprom' (c790f3c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667492] kobject: 'eeprom' (c790f3c0): kobject_uevent_env
[   37.667494] kobject: 'eeprom' (c790f3c0): fill_kobj_path: path = '/bus/i2c/drivers/eeprom'
[   37.667496] i2c-core: driver [eeprom] registered
[   37.667497] bus: 'pci': add driver cb710
[   37.667499] kobject: 'cb710' (c790f420): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667507] kobject: 'cb710' (c790f420): kobject_uevent_env
[   37.667509] kobject: 'cb710' (c790f420): fill_kobj_path: path = '/bus/pci/drivers/cb710'
[   37.667530] bus: 'platform': add driver kim
[   37.667532] kobject: 'kim' (c790f480): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667556] kobject: 'kim' (c790f480): kobject_uevent_env
[   37.667558] kobject: 'kim' (c790f480): fill_kobj_path: path = '/bus/platform/drivers/kim'
[   37.667564] bus: 'i2c': add driver fsa9480
[   37.667571] kobject: 'fsa9480' (c790f4e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667575] kobject: 'fsa9480' (c790f4e0): kobject_uevent_env
[   37.667577] kobject: 'fsa9480' (c790f4e0): fill_kobj_path: path = '/bus/i2c/drivers/fsa9480'
[   37.667578] i2c-core: driver [fsa9480] using legacy suspend method
[   37.667579] i2c-core: driver [fsa9480] using legacy resume method
[   37.667579] i2c-core: driver [fsa9480] registered
[   37.667581] bus: 'platform': add driver sm501
[   37.667583] kobject: 'sm501' (c790f540): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667586] kobject: 'sm501' (c790f540): kobject_uevent_env
[   37.667589] kobject: 'sm501' (c790f540): fill_kobj_path: path = '/bus/platform/drivers/sm501'
[   37.667591] bus: 'pci': add driver sm501
[   37.667592] kobject: 'sm501' (c790f5a0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667600] kobject: 'sm501' (c790f5a0): kobject_uevent_env
[   37.667601] kobject: 'sm501' (c790f5a0): fill_kobj_path: path = '/bus/pci/drivers/sm501'
[   37.667605] bus: 'platform': add driver pasic3
[   37.667607] kobject: 'pasic3' (c790f600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667614] kobject: 'pasic3' (c790f600): kobject_uevent_env
[   37.667616] kobject: 'pasic3' (c790f600): fill_kobj_path: path = '/bus/platform/drivers/pasic3'
[   37.667628] bus: 'platform': remove driver pasic3
[   37.667629] kobject: 'pasic3' (c790f600): kobject_cleanup
[   37.667630] kobject: 'pasic3' (c790f600): auto cleanup 'remove' event
[   37.667631] kobject: 'pasic3' (c790f600): kobject_uevent_env
[   37.667633] kobject: 'pasic3' (c790f600): fill_kobj_path: path = '/bus/platform/drivers/pasic3'
[   37.667635] kobject: 'pasic3' (c790f600): auto cleanup kobject_del
[   37.667639] sysfs pasic3: removing dir
[   37.667643] kobject: 'pasic3' (c790f600): calling ktype release
[   37.667646] driver: 'pasic3': driver_release
[   37.667647] kobject: 'pasic3': free name
[   37.667649] bus: 'i2c': add driver htcpld-chip
[   37.667651] kobject: 'htcpld-chip' (c790f600): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667654] kobject: 'htcpld-chip' (c790f600): kobject_uevent_env
[   37.667656] kobject: 'htcpld-chip' (c790f600): fill_kobj_path: path = '/bus/i2c/drivers/htcpld-chip'
[   37.667658] i2c-core: driver [htcpld-chip] registered
[   37.667659] bus: 'platform': add driver i2c-htcpld
[   37.667661] kobject: 'i2c-htcpld' (c790f660): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.667664] kobject: 'i2c-htcpld' (c790f660): kobject_uevent_env
[   37.667666] kobject: 'i2c-htcpld' (c790f660): fill_kobj_path: path = '/bus/platform/drivers/i2c-htcpld'
[   37.667669] bus: 'platform': remove driver i2c-htcpld
[   37.667670] kobject: 'i2c-htcpld' (c790f660): kobject_cleanup
[   37.667671] kobject: 'i2c-htcpld' (c790f660): auto cleanup 'remove' event
[   37.667672] kobject: 'i2c-htcpld' (c790f660): kobject_uevent_env
[   37.667673] kobject: 'i2c-htcpld' (c790f660): fill_kobj_path: path = '/bus/platform/drivers/i2c-htcpld'
[   37.667675] kobject: 'i2c-htcpld' (c790f660): auto cleanup kobject_del
[   37.667676] sysfs i2c-htcpld: removing dir
[   37.667677] kobject: 'i2c-htcpld' (c790f660): calling ktype release
[   37.667678] driver: 'i2c-htcpld': driver_release
[   37.667679] kobject: 'i2c-htcpld': free name
[   37.668011] bus: 'i2c': add driver wm8994
[   37.668053] kobject: 'wm8994' (c790f660): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668102] kobject: 'wm8994' (c790f660): kobject_uevent_env
[   37.668112] kobject: 'wm8994' (c790f660): fill_kobj_path: path = '/bus/i2c/drivers/wm8994'
[   37.668143] i2c-core: driver [wm8994] registered
[   37.668175] bus: 'pci': add driver lpc_sch
[   37.668177] kobject: 'lpc_sch' (c790f6c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668195] kobject: 'lpc_sch' (c790f6c0): kobject_uevent_env
[   37.668201] kobject: 'lpc_sch' (c790f6c0): fill_kobj_path: path = '/bus/pci/drivers/lpc_sch'
[   37.668207] bus: 'pci': add driver RDC321x Southbridge
[   37.668209] kobject: 'RDC321x Southbridge' (c790f720): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668243] kobject: 'RDC321x Southbridge' (c790f720): kobject_uevent_env
[   37.668246] kobject: 'RDC321x Southbridge' (c790f720): fill_kobj_path: path = '/bus/pci/drivers/RDC321x Southbridge'
[   37.668252] bus: 'pci': add driver janz-cmodio
[   37.668254] kobject: 'janz-cmodio' (c790f780): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668261] kobject: 'janz-cmodio' (c790f780): kobject_uevent_env
[   37.668263] kobject: 'janz-cmodio' (c790f780): fill_kobj_path: path = '/bus/pci/drivers/janz-cmodio'
[   37.668266] bus: 'pci': add driver vx855
[   37.668268] kobject: 'vx855' (c790f7e0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668272] kobject: 'vx855' (c790f7e0): kobject_uevent_env
[   37.668274] kobject: 'vx855' (c790f7e0): fill_kobj_path: path = '/bus/pci/drivers/vx855'
[   37.668278] bus: 'pci': add driver cs5535-mfd
[   37.668279] kobject: 'cs5535-mfd' (c790f840): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668287] kobject: 'cs5535-mfd' (c790f840): kobject_uevent_env
[   37.668289] kobject: 'cs5535-mfd' (c790f840): fill_kobj_path: path = '/bus/pci/drivers/cs5535-mfd'
[   37.668294] Uniform Multi-Platform E-IDE driver
[   37.668319] kobject: 'ide' (cc2c040c): kobject_add_internal: parent: 'bus', set: 'bus'
[   37.668326] kobject: 'ide' (cc2c040c): kobject_uevent_env
[   37.668330] kobject: 'ide' (cc2c040c): fill_kobj_path: path = '/bus/ide'
[   37.668338] kobject: 'devices' (c79115cc): kobject_add_internal: parent: 'ide', set: '<NULL>'
[   37.668340] kobject: 'devices' (c79115cc): kobject_uevent_env
[   37.668341] kobject: 'devices' (c79115cc): kobject_uevent_env: filter function caused the event to drop!
[   37.668345] kobject: 'drivers' (c791164c): kobject_add_internal: parent: 'ide', set: '<NULL>'
[   37.668348] kobject: 'drivers' (c791164c): kobject_uevent_env
[   37.668350] kobject: 'drivers' (c791164c): kobject_uevent_env: filter function caused the event to drop!
[   37.668354] bus: 'ide': registered
[   37.668357] device class 'ide_port': registering
[   37.668359] kobject: 'ide_port' (cc2c050c): kobject_add_internal: parent: 'class', set: 'class'
[   37.668365] kobject: 'ide_port' (cc2c050c): kobject_uevent_env
[   37.668367] kobject: 'ide_port' (cc2c050c): fill_kobj_path: path = '/class/ide_port'
[   37.668395] bus: 'pci': add driver cs5536
[   37.668396] kobject: 'cs5536' (c790f960): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668404] kobject: 'cs5536' (c790f960): kobject_uevent_env
[   37.668406] kobject: 'cs5536' (c790f960): fill_kobj_path: path = '/bus/pci/drivers/cs5536'
[   37.668412] bus: 'pci': add driver Delkin-ASKA-Workbit Cardbus IDE
[   37.668414] kobject: 'Delkin-ASKA-Workbit Cardbus IDE' (c790f9c0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668421] kobject: 'Delkin-ASKA-Workbit Cardbus IDE' (c790f9c0): kobject_uevent_env
[   37.668423] kobject: 'Delkin-ASKA-Workbit Cardbus IDE' (c790f9c0): fill_kobj_path: path = '/bus/pci/drivers/Delkin-ASKA-Workbit Cardbus IDE'
[   37.668445] bus: 'pci': add driver AEC62xx_IDE
[   37.668447] kobject: 'AEC62xx_IDE' (c790fa20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668453] kobject: 'AEC62xx_IDE' (c790fa20): kobject_uevent_env
[   37.668455] kobject: 'AEC62xx_IDE' (c790fa20): fill_kobj_path: path = '/bus/pci/drivers/AEC62xx_IDE'
[   37.668458] bus: 'pci': add driver ALI15x3_IDE
[   37.668459] kobject: 'ALI15x3_IDE' (c790fa80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.668784] kobject: 'ALI15x3_IDE' (c790fa80): kobject_uevent_env
[   37.668787] kobject: 'ALI15x3_IDE' (c790fa80): fill_kobj_path: path = '/bus/pci/drivers/ALI15x3_IDE'
[   37.668793] bus: 'pci': add driver CS5530 IDE
[   37.669059] kobject: 'CS5530 IDE' (c790fae0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669227] kobject: 'CS5530 IDE' (c790fae0): kobject_uevent_env
[   37.669240] kobject: 'CS5530 IDE' (c790fae0): fill_kobj_path: path = '/bus/pci/drivers/CS5530 IDE'
[   37.669295] bus: 'pci': add driver CS5535_IDE
[   37.669299] kobject: 'CS5535_IDE' (c790fb40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669334] kobject: 'CS5535_IDE' (c790fb40): kobject_uevent_env
[   37.669336] kobject: 'CS5535_IDE' (c790fb40): fill_kobj_path: path = '/bus/pci/drivers/CS5535_IDE'
[   37.669340] bus: 'pci': add driver HPT366_IDE
[   37.669342] kobject: 'HPT366_IDE' (c790fba0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669349] kobject: 'HPT366_IDE' (c790fba0): kobject_uevent_env
[   37.669351] kobject: 'HPT366_IDE' (c790fba0): fill_kobj_path: path = '/bus/pci/drivers/HPT366_IDE'
[   37.669355] bus: 'pci': add driver IT8172_IDE
[   37.669356] kobject: 'IT8172_IDE' (c790fc00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669361] kobject: 'IT8172_IDE' (c790fc00): kobject_uevent_env
[   37.669363] kobject: 'IT8172_IDE' (c790fc00): fill_kobj_path: path = '/bus/pci/drivers/IT8172_IDE'
[   37.669366] bus: 'pci': add driver ITE8213_IDE
[   37.669368] kobject: 'ITE8213_IDE' (c790fc60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669378] kobject: 'ITE8213_IDE' (c790fc60): kobject_uevent_env
[   37.669380] kobject: 'ITE8213_IDE' (c790fc60): fill_kobj_path: path = '/bus/pci/drivers/ITE8213_IDE'
[   37.669384] bus: 'pci': add driver ITE821x IDE
[   37.669385] kobject: 'ITE821x IDE' (c790fcc0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669390] kobject: 'ITE821x IDE' (c790fcc0): kobject_uevent_env
[   37.669392] kobject: 'ITE821x IDE' (c790fcc0): fill_kobj_path: path = '/bus/pci/drivers/ITE821x IDE'
[   37.669395] bus: 'pci': add driver JMicron IDE
[   37.669397] kobject: 'JMicron IDE' (c790fd20): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669402] kobject: 'JMicron IDE' (c790fd20): kobject_uevent_env
[   37.669407] kobject: 'JMicron IDE' (c790fd20): fill_kobj_path: path = '/bus/pci/drivers/JMicron IDE'
[   37.669412] bus: 'pci': add driver Promise_Old_IDE
[   37.669413] kobject: 'Promise_Old_IDE' (c790fd80): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669422] kobject: 'Promise_Old_IDE' (c790fd80): kobject_uevent_env
[   37.669424] kobject: 'Promise_Old_IDE' (c790fd80): fill_kobj_path: path = '/bus/pci/drivers/Promise_Old_IDE'
[   37.669427] bus: 'pci': add driver Serverworks_IDE
[   37.669429] kobject: 'Serverworks_IDE' (c790fde0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669434] kobject: 'Serverworks_IDE' (c790fde0): kobject_uevent_env
[   37.669436] kobject: 'Serverworks_IDE' (c790fde0): fill_kobj_path: path = '/bus/pci/drivers/Serverworks_IDE'
[   37.669439] bus: 'pci': add driver SiI_IDE
[   37.669441] kobject: 'SiI_IDE' (c790fe40): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669445] kobject: 'SiI_IDE' (c790fe40): kobject_uevent_env
[   37.669447] kobject: 'SiI_IDE' (c790fe40): fill_kobj_path: path = '/bus/pci/drivers/SiI_IDE'
[   37.669450] bus: 'pci': add driver SLC90e66_IDE
[   37.669452] kobject: 'SLC90e66_IDE' (c790fea0): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669457] kobject: 'SLC90e66_IDE' (c790fea0): kobject_uevent_env
[   37.669459] kobject: 'SLC90e66_IDE' (c790fea0): fill_kobj_path: path = '/bus/pci/drivers/SLC90e66_IDE'
[   37.669462] bus: 'pci': add driver TC86C001
[   37.669463] kobject: 'TC86C001' (c790ff00): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669468] kobject: 'TC86C001' (c790ff00): kobject_uevent_env
[   37.669470] kobject: 'TC86C001' (c790ff00): fill_kobj_path: path = '/bus/pci/drivers/TC86C001'
[   37.669473] bus: 'pci': add driver TRIFLEX_IDE
[   37.669475] kobject: 'TRIFLEX_IDE' (c790ff60): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669513] kobject: 'TRIFLEX_IDE' (c790ff60): kobject_uevent_env
[   37.669515] kobject: 'TRIFLEX_IDE' (c790ff60): fill_kobj_path: path = '/bus/pci/drivers/TRIFLEX_IDE'
[   37.669521] bus: 'pci': add driver TRM290_IDE
[   37.669529] kobject: 'TRM290_IDE' (c7930000): kobject_add_internal: parent: 'drivers', set: 'drivers'
[   37.669533] kobject: 'TRM290_IDE' (c7930000): kobject_uevent_env
[   37.669535] kobject: 'TRM290_IDE' (c7930000): fill_kobj_path: path = '/bus/pci/drivers/TRM290_IDE'
[   37.671950] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   37.671994] device class 'raid_devices': registering
[   37.672026] kobject: 'raid_devices' (cc2c060c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672075] kobject: 'raid_devices' (cc2c060c): kobject_uevent_env
[   37.672079] kobject: 'raid_devices' (cc2c060c): fill_kobj_path: path = '/class/raid_devices'
[   37.672103] Loading iSCSI transport class v2.0-870.
[   37.672105] device class 'iscsi_transport': registering
[   37.672107] kobject: 'iscsi_transport' (cc2c070c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672115] kobject: 'iscsi_transport' (cc2c070c): kobject_uevent_env
[   37.672117] kobject: 'iscsi_transport' (cc2c070c): fill_kobj_path: path = '/class/iscsi_transport'
[   37.672119] device class 'iscsi_endpoint': registering
[   37.672121] kobject: 'iscsi_endpoint' (cc2c080c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672122] kobject: 'iscsi_endpoint' (cc2c080c): kobject_uevent_env
[   37.672124] kobject: 'iscsi_endpoint' (cc2c080c): fill_kobj_path: path = '/class/iscsi_endpoint'
[   37.672126] device class 'iscsi_iface': registering
[   37.672128] kobject: 'iscsi_iface' (cc2c090c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672129] kobject: 'iscsi_iface' (cc2c090c): kobject_uevent_env
[   37.672131] kobject: 'iscsi_iface' (cc2c090c): fill_kobj_path: path = '/class/iscsi_iface'
[   37.672132] device class 'iscsi_host': registering
[   37.672134] kobject: 'iscsi_host' (cc2c0a0c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672139] kobject: 'iscsi_host' (cc2c0a0c): kobject_uevent_env
[   37.672141] kobject: 'iscsi_host' (cc2c0a0c): fill_kobj_path: path = '/class/iscsi_host'
[   37.672146] device class 'iscsi_connection': registering
[   37.672148] kobject: 'iscsi_connection' (cc2c0b0c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672150] kobject: 'iscsi_connection' (cc2c0b0c): kobject_uevent_env
[   37.672152] kobject: 'iscsi_connection' (cc2c0b0c): fill_kobj_path: path = '/class/iscsi_connection'
[   37.672154] device class 'iscsi_session': registering
[   37.672155] kobject: 'iscsi_session' (cc2c0c0c): kobject_add_internal: parent: 'class', set: 'class'
[   37.672157] kobject: 'iscsi_session' (cc2c0c0c): kobject_uevent_env
[   37.672159] kobject: 'iscsi_session' (cc2c0c0c): fill_kobj_path: path = '/class/iscsi_session'
[   37.672791] INFO: rcu_preempt self-detected stall on CPU { 1[  137.900041] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10028 jiffies)
[  137.900041] Pid: 41, comm: rcu_torture_rea Not tainted 3.6.0-rc7-bisect2-00078-g593d100 #21
[  137.900041] Call Trace:
[  137.900041]  [<c10be825>] rcu_check_callbacks+0x4e5/0x510
[  137.900041]  [<c1070156>] update_process_times+0x36/0x70
[  137.900041]  [<c10a0d57>] tick_sched_timer+0x57/0xc0
[  137.900041]  [<c1081aaa>] __run_hrtimer.isra.31+0x4a/0xc0
[  137.900041]  [<c10a0d00>] ? tick_nohz_handler+0xf0/0xf0
[  137.900041]  [<c1082675>] hrtimer_interrupt+0xf5/0x290
[  137.900041]  [<c104f65f>] smp_apic_timer_interrupt+0x4f/0x80
[  137.900041]  [<c108cab0>] ? __dequeue_entity+0x20/0x40
[  137.900041]  [<c16749e6>] apic_timer_interrupt+0x2a/0x30
[  137.900041]  [<c108007b>] ? cpu_timer_sample_group+0x5b/0xb0
[  137.900041]  [<c1672d3c>] ? __schedule+0x38c/0x760
[  137.900041]  [<c167007b>] ? add_new_disk+0x3e/0x444
[  137.900041]  [<c10ba477>] ? rcu_random+0x37/0x60
[  137.900041]  [<c167312e>] schedule+0x1e/0x50
[  137.900041]  [<c10bc444>] rcu_torture_reader+0xd4/0x260
[  137.900041]  [<c10bc5d0>] ? rcu_torture_reader+0x260/0x260
[  137.900041]  [<c10bc370>] ? rcutorture_trace_dump+0x30/0x30
[  137.900041]  [<c107dc2f>] kthread+0x8f/0xa0
[  137.900041]  [<c107dba0>] ? __kthread_parkme+0x60/0x60
[  137.900041]  [<c1675376>] kernel_thread_helper+0x6/0xd

[   37.672791] }  (t=10028 jiffies)
[   37.672791] Pid: 24, comm: pageattr-test Not tainted 3.6.0-rc7-bisect2-00078-g593d100 #21
[   37.672791] Call Trace:
[   37.672791]  [<c10be55b>] rcu_check_callbacks+0x21b/0x510
[   37.672791]  [<c1070156>] update_process_times+0x36/0x70
[   37.672791]  [<c10a0d57>] tick_sched_timer+0x57/0xc0
[   37.672791]  [<c1081aaa>] __run_hrtimer.isra.31+0x4a/0xc0
[   37.672791]  [<c10a0d00>] ? tick_nohz_handler+0xf0/0xf0
[   37.672791]  [<c1082675>] hrtimer_interrupt+0xf5/0x290
[   37.672791]  [<c104f65f>] smp_apic_timer_interrupt+0x4f/0x80
[   37.672791]  [<c16749e6>] apic_timer_interrupt+0x2a/0x30
[   37.672791]  [<c10800d8>] ? posix_cpu_timer_get+0x8/0x200
[   37.672791]  [<c16731f8>] ? preempt_schedule_irq+0x28/0x60
[   37.672791]  [<c16746d4>] need_resched+0x17/0x1b
[   37.672791]  [<c10655c6>] ? vprintk_emit+0x156/0x450
[   37.672791]  [<c16621e5>] ? printk+0x38/0x3a
[   37.672791]  [<c105a17a>] ? print_split+0x19a/0x1a0
[   37.672791]  [<c105a414>] ? do_pageattr_test+0x294/0x4b0
[   37.672791]  [<c105a180>] ? print_split+0x1a0/0x1a0
[   37.672791]  [<c107dc2f>] ? kthread+0x8f/0xa0
[   37.672791]  [<c107dba0>] ? __kthread_parkme+0x60/0x60
[   37.672791]  [<c1675376>] ? kernel_thread_helper+0x6/0xd
[  143.147101] rcu-torture: rtc: c1a5e730 ver: 203 tfle: 0 rta: 203 rtaf: 174 rtf: 184 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 977 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
[  143.147101] rcu-torture: Reader Pipe:  138716120 40 0 0 0 0 0 0 0 0 0
[  143.147101] rcu-torture: Reader Batch:  138716137 23 0 0 0 0 0 0 0 0 0
[  143.147101] rcu-torture: Free-Block Circulation:  202 199 198 198 198 198 198 196 190 184 0
[  143.147104] device class 'sas_host': registering
[  143.147140] kobject: 'sas_host' (cc2c0d0c): kobject_add_internal: parent: 'class', set: 'class'
[  143.147174] kobject: 'sas_host' (cc2c0d0c): kobject_uevent_env
[  143.147179] kobject: 'sas_host' (cc2c0d0c): fill_kobj_path: path = '/class/sas_host'
[  143.147508] device class 'sas_phy': registering
[  143.147541] kobject: 'sas_phy' (cc2c0e0c): kobject_add_internal: parent: 'class', set: 'class'
[  143.147576] kobject: 'sas_phy' (cc2c0e0c): kobject_uevent_env
[  143.147578] kobject: 'sas_phy' (cc2c0e0c): fill_kobj_path: path = '/class/sas_phy'
[  143.147589] device class 'sas_port': registering
[  143.147592] kobject: 'sas_port' (cc2c0f0c): kobject_add_internal: parent: 'class', set: 'class'
[  143.147596] kobject: 'sas_port' (cc2c0f0c): kobject_uevent_env
[  143.147598] kobject: 'sas_port' (cc2c0f0c): fill_kobj_path: path = '/class/sas_port'
[  143.147600] device class 'sas_device': registering
[  143.147618] kobject: 'sas_device' (cc73800c): kobject_add_internal: parent: 'class', set: 'class'
[  143.147625] kobject: 'sas_device' (cc73800c): kobject_uevent_env
[  143.147632] kobject: 'sas_device' (cc73800c): fill_kobj_path: path = '/class/sas_device'
[  143.147637] device class 'sas_end_device': registering
[  143.147639] kobject: 'sas_end_device' (cc73810c): kobject_add_internal: parent: 'class', set: 'class'
[  143.147645] kobject: 'sas_end_device' (cc73810c): kobject_uevent_env
[  143.147647] kobject: 'sas_end_device' (cc73810c): fill_kobj_path: path = '/class/sas_end_device'
[  143.147649] device class 'sas_expander': registering
[  143.147657] kobject: 'sas_expander' (cc73820c): kobject_add_internal: parent: 'class', set: 'class'
[  143.147659] kobject: 'sas_expander' (cc73820c): kobject_uevent_env
[  143.147661] kobject: 'sas_expander' (cc73820c): fill_kobj_path: path = '/class/sas_expander'
[  143.147755] osst :I: Tape driver with OnStream support version 0.99.4
[  143.147755] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[  143.147756] device class 'onstream_tape': registering

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc7 Kernel Configuration
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
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
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
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO1_PM is not set
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
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
# CONFIG_RAPIDIO_DMA_ENGINE is not set
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
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

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
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
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
# CONFIG_BMP085_I2C is not set
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
# CONFIG_ATA_SFF is not set
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
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
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
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
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
# CONFIG_INPUT_MATRIXKMAP is not set

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
# CONFIG_KEYBOARD_TCA8418 is not set
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
# CONFIG_KEYBOARD_OMAP4 is not set
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
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
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
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
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
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
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
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

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
# CONFIG_GPIO_SODAVILLE is not set
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
# CONFIG_IE6XX_WDT is not set
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
# CONFIG_VIA_WDT is not set
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
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
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
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set

#
# Media drivers
#

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
# CONFIG_FB_SMSCUFX is not set
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
CONFIG_HID_GENERIC=y

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
# CONFIG_USB_MUSB_HDRC is not set
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
# CONFIG_USB_LIBUSUAL is not set

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
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
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
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
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
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM3556 is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set
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
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

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
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
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
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
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
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
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
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
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
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
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
# CONFIG_DDR is not set

--TB36FDmn/VVEgNH/--
