Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1KAHHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:07:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:40987 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1KAHH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,436,1315206000"; 
   d="scan'208";a="69151724"
Date: Tue, 1 Nov 2011 15:07:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111101070720.GA22936@localhost>
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101003434.GR6160@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 08:34:34AM +0800, Paul E. McKenney wrote:
> On Mon, Oct 31, 2011 at 11:44:42AM -0400, Steven Rostedt wrote:
> > On Mon, 2011-10-31 at 05:19 -0700, Paul E. McKenney wrote:
> > > On Mon, Oct 31, 2011 at 07:41:42PM +0800, Wu Fengguang wrote:
> > > > On Mon, Oct 31, 2011 at 06:43:25PM +0800, Wu Fengguang wrote:
> > > > > On Mon, Oct 31, 2011 at 05:51:52PM +0800, Paul E. McKenney wrote:
> > > > > > On Mon, Oct 31, 2011 at 04:26:34PM +0800, Wu Fengguang wrote:
> > > > > > > Hi Paul,
> > > > > > >
> > > > > > > I got two warnings in rcutree.c. The last working kernels are
> > > > > > > linux-next 20111014 and linux v3.1.
> > > > > > 
> > > > > > Interesting.  Could you please enable RCU event tracing at boot?
> > > > > 
> > > > > Sorry I cannot...possibly due to another ftrace bug.
> > > > > 
> > > > > > The RCU event tracing is at tracing/events/rcu/enable relative to
> > > > > > the debugfs mount point at runtime, if that helps.
> > > > > 
> > > > > It's exactly that linux next 20111025 (comparing to 20111014) no
> > > > > longer produces all the trace events that made me looking into the
> > > > > dmesg and find the warning from RCU (rather than the expected warning
> > > > > from ftrace).
> > > > > 
> > > > > The trace output is now:
> > > > > 
> > > > >         # tracer: nop
> > > > >         #
> > > > >         # WARNING: FUNCTION TRACING IS CORRUPTED
> > > > >         #          MAY BE MISSING FUNCTION EVENTS
> > > > >         #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > > >         #              | |       |          |         |
> > > > > (nothing more)
> > > > 
> > > > I checked the other test box and got the same warnings. Below is the
> > > > full dmesg.
> > > > 
> > > > No single trace output again..
> > > 
> > > Hmmm...  I wonder if it is too early during boot for tracing to work
> > > correctly.
> > > 
> > > Gah!  I have rcu/next set ahead to commits that are not supposed to go
> > > upstream yet.  I reset it back to match the stuff that is targeted for
> > > the current merge window.  Still need to find the bug, of course.
> > > 
> > > Anyone have any idea why the kworker thread might be trying to enter
> > > the idle loop?  The idle_cpu(smp_processor_id()) call believes that
> > > this is not the idle task.  Or does x86 allow non-idle tasks to enter
> > > the idle loop?  Or to be migrated off-CPU?
> > 
> > 
> > It's not. Carsten Emde noticed what looked like a bug in ftrace last
> > week at LinuxCon, and looking deeper at it, I found that the swapper
> > task for all but CPU0 is named kworker.  That's because kworker creates
> > the idle task for all other CPUs besides CPU 0 and the idle task takes
> > on kworker name.
> > 
> > Carsten posted a patch last week too:
> > 
> > https://lkml.org/lkml/2011/10/26/313
> > 
> > I'm glad that this bug shows up outside of just ftrace :)
> 
> That makes one of us.  ;-)
> 
> Fengguang, does Carsten's patch help?

Nope unfortunately. Here is the new dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-ioless-full-bg-all-next-20111025+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #886 SMP Tue Nov 1 14:36:22 CST 2011
[    0.000000] Command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-bg-all-next-20111025+
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bcde3000 (usable)
[    0.000000]  BIOS-e820: 00000000bcde3000 - 00000000bcffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bcffb000 - 00000000bf6bd000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6bd000 - 00000000bf6bf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf6bf000 - 00000000bf714000 (usable)
[    0.000000]  BIOS-e820: 00000000bf714000 - 00000000bf7bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7bf000 - 00000000bf7e7000 (usable)
[    0.000000]  BIOS-e820: 00000000bf7e7000 - 00000000bf7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI:                  /DX58SO, BIOS SOX5810J.86A.2127.2008.0914.1638 09/14/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff4c0] ff4c0
[    0.000000]   mpc: ff4d0-ff6a8
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 4k
[    0.000000] kernel direct mapping tables up to bf800000 @ 1fa02000-20000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 258211(98%)
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000bf7fe120 0006C (v01 INTEL  DX58SO   0000084F      01000013)
[    0.000000] ACPI: FACP 00000000bf7fd000 000F4 (v03 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000450/0x0 (20110623/tbfadt-560)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20110623/tbfadt-610)
[    0.000000] ACPI: DSDT 00000000bf7f8000 043CE (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: FACS 00000000bf726000 00040
[    0.000000] ACPI: APIC 00000000bf7f7000 00138 (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: WDDT 00000000bf7f6000 00040 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: MCFG 00000000bf7f5000 0003C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: ASF! 00000000bf7f4000 000AC (v32 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: SSDT 00000000bf7ea000 070AC (v01 INTEL  SSDT  PM 0000084F MSFT 0100000D)
[    0.000000] ACPI: DMAR 00000000bf7e7000 00140 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: WDTT 00000000bf7f2000 0020C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: ASPT 00000000bf7f3000 00034 (v04 INTEL  PerfTune 0000084F MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000bf800000
[    0.000000] Initmem setup node 0 0000000000000000-00000000bf800000
[    0.000000]   NODE_DATA [00000000bf7e2000 - 00000000bf7e6fff]
[    0.000000]  [ffffea0000000000-ffffea0002ffffff] PMD -> [ffff8800b9c00000-ffff8800bcbfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bcde3
[    0.000000]     0: 0x000bcffb -> 0x000bf6bd
[    0.000000]     0: 0x000bf6bf -> 0x000bf714
[    0.000000]     0: 0x000bf7bf -> 0x000bf7e7
[    0.000000]     0: 0x000bf7ff -> 0x000bf800
[    0.000000] On node 0 totalpages: 783535
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12192 pages used for memmap
[    0.000000]   DMA32 zone: 767363 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bcde3000 - 00000000bcffb000
[    0.000000] PM: Registered nosave memory: 00000000bf6bd000 - 00000000bf6bf000
[    0.000000] PM: Registered nosave memory: 00000000bf714000 - 00000000bf7bf000
[    0.000000] PM: Registered nosave memory: 00000000bf7e7000 - 00000000bf7ff000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff8800b7c00000 s1917184 r8192 d24320 u2097152
[    0.000000] pcpu-alloc: s1917184 r8192 d24320 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 771274
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.52:192.168.1.11:192.168.1.1:255.255.255.0:fat:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-bg-all-next-20111025+
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3012392k/3137536k available (9805k kernel code, 3396k absent, 121748k reserved, 5807k data, 2772k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU torture testing starts during boot.
[    0.000000] NR_IRQS:4352 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 25165824 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 3199.870 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.74 BogoMIPS (lpj=3199870)
[    0.000709] pid_max: default: 32768 minimum: 301
[    0.001898] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003965] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004966] Mount-cache hash table entries: 256
[    0.005674] Initializing cgroup subsys debug
[    0.005984] Initializing cgroup subsys cpuacct
[    0.006305] Initializing cgroup subsys memory
[    0.006654] Initializing cgroup subsys devices
[    0.006969] Initializing cgroup subsys freezer
[    0.007285] Initializing cgroup subsys blkio
[    0.007659] CPU: Physical Processor ID: 0
[    0.007958] CPU: Processor Core ID: 0
[    0.008247] mce: CPU supports 9 MCE banks
[    0.008562] CPU0: Thermal monitoring enabled (TM1)
[    0.008900] using mwait in idle threads.
[    0.010063] ACPI: Core revision 20110623
[    0.021784] ftrace: allocating 38119 entries in 150 pages
[    0.030763] Getting VERSION: 60015
[    0.031040] Getting VERSION: 60015
[    0.031316] Getting ID: 0
[    0.031573] Getting ID: 0
[    0.031820] Switched APIC routing to physical flat.
[    0.032152] enabled ExtINT on CPU#0
[    0.032663] ENABLING IO-APIC IRQs
[    0.032936] init IO_APIC IRQs
[    0.033196]  apic 8 pin 0 not connected
[    0.033502] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.034068] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.034643] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.035208] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.035776] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.036341] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.036907] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.037475] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.038041] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.038609] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.039181] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.039756] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.040326] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.040899] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.041472] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.042040]  apic 8 pin 16 not connected
[    0.042335]  apic 8 pin 17 not connected
[    0.042632]  apic 8 pin 18 not connected
[    0.042927]  apic 8 pin 19 not connected
[    0.043223]  apic 8 pin 20 not connected
[    0.043521]  apic 8 pin 21 not connected
[    0.043815]  apic 8 pin 22 not connected
[    0.044110]  apic 8 pin 23 not connected
[    0.044542] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054915] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
[    0.055398] Using local APIC timer interrupts.
[    0.055399] calibrating APIC timer ...
[    0.157378] ... lapic delta = 833233
[    0.157659] ... PM-Timer delta = 357898
[    0.157951] ... PM-Timer result ok
[    0.158226] ..... delta 833233
[    0.158489] ..... mult: 35792525
[    0.158758] ..... calibration result: 133317
[    0.159067] ..... CPU clock speed is 3199.0607 MHz.
[    0.159398] ..... host bus clock speed is 133.0317 MHz.
[    0.159755] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.160519] ... version:                3
[    0.160821] ... bit width:              48
[    0.161123] ... generic registers:      4
[    0.161422] ... value mask:             0000ffffffffffff
[    0.161771] ... max period:             000000007fffffff
[    0.162118] ... fixed-purpose events:   3
[    0.162416] ... event mask:             000000070000000f
[    0.162965] Testing tracer nop: PASSED
[    0.163380] lockdep: fixing up alternatives.
[    0.163745] Booting Node   0, Processors  #1
[    0.163968] smpboot cpu 1: start_ip = 97000
[    0.175539] masked ExtINT on CPU#1
[    0.195770] ------------[ cut here ]------------
[    0.195885] lockdep: fixing up alternatives.
[    0.195908]  #2
[    0.195909] smpboot cpu 2: start_ip = 97000
[    0.196924] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
[    0.197518] Hardware name:
[    0.197796] Modules linked in:
[    0.198093] Pid: 0, comm: swapper/1 Not tainted 3.1.0-ioless-full-bg-all-next-20111025+ #886
[    0.201644] Call Trace:
[    0.201885]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.202316]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.202682]  [<ffffffff810d77d1>] rcu_idle_exit_common+0xd2/0x117
[    0.203058]  [<ffffffff810d7cd3>] rcu_irq_enter+0x75/0xa2
[    0.203409]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
[    0.203748]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
[    0.204098]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.204484]  [<ffffffff8198eab3>] reschedule_interrupt+0x73/0x80
[    0.204857]  <EOI>  [<ffffffff8198955f>] ? notifier_call_chain+0x63/0x63
[    0.205292]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.205642]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.205994]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.206337]  [<ffffffff8197bad5>] start_secondary+0x1de/0x1e2
[    0.206725] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.207016] masked ExtINT on CPU#2
[    0.207322] Dumping ftrace buffer:
[    0.207600]    (ftrace buffer empty)
[    0.207885] ------------[ cut here ]------------
[    0.208209] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:359 rcu_idle_enter_common+0xb3/0x130()
[    0.208803] Hardware name:
[    0.209082] Modules linked in:
[    0.209379] Pid: 0, comm: swapper/1 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    0.209989] Call Trace:
[    0.210229]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    0.210660]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[    0.211027]  [<ffffffff810d78c9>] rcu_idle_enter_common+0xb3/0x130
[    0.211406]  [<ffffffff810d7b8c>] rcu_irq_exit+0x6b/0x95
[    0.211753]  [<ffffffff8107ad88>] irq_exit+0xb0/0xb2
[    0.212087]  [<ffffffff8106f310>] scheduler_ipi+0xd0/0xd5
[    0.212438]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
[    0.212825]  [<ffffffff8198eab3>] reschedule_interrupt+0x73/0x80
[    0.213196]  <EOI>  [<ffffffff8198955f>] ? notifier_call_chain+0x63/0x63
[    0.213631]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
[    0.213982]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
[    0.214333]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
[    0.214668]  [<ffffffff8197bad5>] start_secondary+0x1de/0x1e2
[    0.215030] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.227239] lockdep: fixing up alternatives.
[    0.227572]  #3
[    0.227664] smpboot cpu 3: start_ip = 97000
[    0.239247] masked ExtINT on CPU#3
[    0.259571] lockdep: fixing up alternatives.
[    0.259910]  #4
[    0.260002] smpboot cpu 4: start_ip = 97000
[    0.271570] masked ExtINT on CPU#4
[    0.291904] lockdep: fixing up alternatives.
[    0.292238]  #5
[    0.292330] smpboot cpu 5: start_ip = 97000
[    0.303903] masked ExtINT on CPU#5
[    0.324228] lockdep: fixing up alternatives.
[    0.324566]  #6
[    0.324659] smpboot cpu 6: start_ip = 97000
[    0.336231] masked ExtINT on CPU#6
[    0.356554] lockdep: fixing up alternatives.
[    0.356896]  #7
[    0.356988] smpboot cpu 7: start_ip = 97000
[    0.368556] masked ExtINT on CPU#7
[    0.388778] Brought up 8 CPUs
[    0.389042] Total of 8 processors activated (51197.92 BogoMIPS).
[    0.392797] CPU0 attaching sched-domain:
[    0.393097]  domain 0: span 0,4 level SIBLING
[    0.393442]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    0.393977]   domain 1: span 0-7 level MC
[    0.394311]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.395271] CPU1 attaching sched-domain:
[    0.395567]  domain 0: span 1,5 level SIBLING
[    0.395915]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    0.396446]   domain 1: span 0-7 level MC
[    0.396782]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.397737] CPU2 attaching sched-domain:
[    0.398033]  domain 0: span 2,6 level SIBLING
[    0.398378]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
[    0.398913]   domain 1: span 0-7 level MC
[    0.399245]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.400201] CPU3 attaching sched-domain:
[    0.400496]  domain 0: span 3,7 level SIBLING
[    0.400844]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
[    0.401376]   domain 1: span 0-7 level MC
[    0.401709]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.402664] CPU4 attaching sched-domain:
[    0.402962]  domain 0: span 0,4 level SIBLING
[    0.403307]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
[    0.403842]   domain 1: span 0-7 level MC
[    0.404174]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.405131] CPU5 attaching sched-domain:
[    0.405426]  domain 0: span 1,5 level SIBLING
[    0.405773]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
[    0.406304]   domain 1: span 0-7 level MC
[    0.406636]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
[    0.407592] CPU6 attaching sched-domain:
[    0.407890]  domain 0: span 2,6 level SIBLING
[    0.408235]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
[    0.408768]   domain 1: span 0-7 level MC
[    0.409101]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
[    0.410057] CPU7 attaching sched-domain:
[    0.410351]  domain 0: span 3,7 level SIBLING
[    0.410698]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
[    0.411228]   domain 1: span 0-7 level MC
[    0.411560]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
[    0.412961] devtmpfs: initialized
[    0.414226] PM: Registering ACPI NVS region at bcde3000 (2195456 bytes)
[    0.414681] PM: Registering ACPI NVS region at bf714000 (700416 bytes)
[    0.415762] xor: automatically using best checksumming function: generic_sse
[    0.420684]    generic_sse: 11932.000 MB/sec
[    0.420993] xor: using function: generic_sse (11932.000 MB/sec)
[    0.421480] kworker/u:0 used greatest stack depth: 5608 bytes left
[    0.421508] RTC time: 14:52:59, date: 11/01/11
[    0.421593] NET: Registered protocol family 16
[    0.422495] kworker/u:0 used greatest stack depth: 5192 bytes left
[    0.423389] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.423947] ACPI: bus type pci registered
[    0.424444] dca service started, version 1.12.1
[    0.424846] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.425459] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.437636] PCI: Using configuration type 1 for base access
[    0.463107] bio: create slab <bio-0> at 0
[    0.479677] raid6: int64x1   3171 MB/s
[    0.496679] raid6: int64x2   3425 MB/s
[    0.513674] raid6: int64x4   2742 MB/s
[    0.530662] raid6: int64x8   2089 MB/s
[    0.547655] raid6: sse2x1    7910 MB/s
[    0.564645] raid6: sse2x2    9300 MB/s
[    0.581641] raid6: sse2x4   10675 MB/s
[    0.581931] raid6: using algorithm sse2x4 (10675 MB/s)
[    0.582356] ACPI: Added _OSI(Module Device)
[    0.582668] ACPI: Added _OSI(Processor Device)
[    0.582984] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.583308] ACPI: Added _OSI(Processor Aggregator Device)
[    0.587677] ACPI: EC: Look up EC in DSDT
[    0.608662] ACPI: Interpreter enabled
[    0.608951] ACPI: (supports S0 S1 S3 S4 S5)
[    0.609459] ACPI: Using IOAPIC for interrupt routing
[    0.622348] ACPI: No dock devices found.
[    0.622651] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.623858] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.625457] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.625859] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.626254] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.626794] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    0.627331] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    0.627872] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xf7ffffff]
[    0.628432] pci 0000:00:00.0: [8086:3405] type 0 class 0x000600
[    0.628879] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    0.629306] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.629695] pci 0000:00:01.0: PME# disabled
[    0.630026] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    0.630452] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.630834] pci 0000:00:03.0: PME# disabled
[    0.631172] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    0.631598] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.631981] pci 0000:00:07.0: PME# disabled
[    0.632317] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    0.632770] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    0.633215] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    0.633663] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    0.634108] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    0.634549] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    0.635001] pci 0000:00:19.0: [8086:10cc] type 0 class 0x000200
[    0.635389] pci 0000:00:19.0: reg 10: [mem 0xe0300000-0xe031ffff]
[    0.635777] pci 0000:00:19.0: reg 14: [mem 0xe0323000-0xe0323fff]
[    0.636162] pci 0000:00:19.0: reg 18: [io  0x2100-0x211f]
[    0.636571] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.636957] pci 0000:00:19.0: PME# disabled
[    0.637282] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    0.637709] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    0.638114] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    0.638536] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    0.641919] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    0.642341] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    0.642756] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    0.643146] pci 0000:00:1a.7: reg 10: [mem 0xe0322000-0xe03223ff]
[    0.643606] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.643989] pci 0000:00:1a.7: PME# disabled
[    0.644319] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
[    0.644711] pci 0000:00:1b.0: reg 10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    0.645176] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.645554] pci 0000:00:1b.0: PME# disabled
[    0.645884] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    0.646323] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.646704] pci 0000:00:1c.0: PME# disabled
[    0.647033] pci 0000:00:1c.1: [8086:3a42] type 1 class 0x000604
[    0.647471] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.647854] pci 0000:00:1c.1: PME# disabled
[    0.648185] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    0.648630] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.649009] pci 0000:00:1c.4: PME# disabled
[    0.649341] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    0.649766] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    0.650172] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    0.650594] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    0.651002] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    0.651423] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    0.651839] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    0.652230] pci 0000:00:1d.7: reg 10: [mem 0xe0321000-0xe03213ff]
[    0.652693] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.653072] pci 0000:00:1d.7: PME# disabled
[    0.653396] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.653838] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    0.654305] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.654690] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.655239] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.655834] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    0.656224] pci 0000:00:1f.2: reg 10: [io  0x2128-0x212f]
[    0.656581] pci 0000:00:1f.2: reg 14: [io  0x2134-0x2137]
[    0.656942] pci 0000:00:1f.2: reg 18: [io  0x2120-0x2127]
[    0.657300] pci 0000:00:1f.2: reg 1c: [io  0x2130-0x2133]
[    0.657660] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    0.658020] pci 0000:00:1f.2: reg 24: [mem 0xe0320000-0xe03207ff]
[    0.658433] pci 0000:00:1f.2: PME# supported from D3hot
[    0.658783] pci 0000:00:1f.2: PME# disabled
[    0.659104] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    0.659490] pci 0000:00:1f.3: reg 10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    0.659914] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    0.660339] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.660748] pci 0000:02:00.0: [5333:9043] type 0 class 0x000300
[    0.661128] pci 0000:02:00.0: reg 10: [mem 0xe0200000-0xe027ffff]
[    0.661511] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff pref]
[    0.661944] pci 0000:02:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.662359] pci 0000:02:00.0: supports D1 D2
[    0.662694] pci 0000:02:00.1: [5333:903f] type 0 class 0x000403
[    0.663075] pci 0000:02:00.1: reg 10: [mem 0xe0280000-0xe0283fff]
[    0.663518] pci 0000:02:00.1: supports D1 D2
[    0.663847] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.664196] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.664601] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.665203] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.665604] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.666011] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.666440] pci 0000:06:00.0: [11ab:6121] type 0 class 0x000101
[    0.666835] pci 0000:06:00.0: reg 10: [io  0x1018-0x101f]
[    0.667201] pci 0000:06:00.0: reg 14: [io  0x1024-0x1027]
[    0.667566] pci 0000:06:00.0: reg 18: [io  0x1010-0x1017]
[    0.667935] pci 0000:06:00.0: reg 1c: [io  0x1020-0x1023]
[    0.668300] pci 0000:06:00.0: reg 20: [io  0x1000-0x100f]
[    0.668667] pci 0000:06:00.0: reg 24: [mem 0xe0100000-0xe01003ff]
[    0.669107] pci 0000:06:00.0: supports D1
[    0.669405] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.669775] pci 0000:06:00.0: PME# disabled
[    0.670101] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.670448] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.670830] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.671279] pci 0000:07:03.0: [104c:8023] type 0 class 0x000c00
[    0.671670] pci 0000:07:03.0: reg 10: [mem 0xe0004000-0xe00047ff]
[    0.672057] pci 0000:07:03.0: reg 14: [mem 0xe0000000-0xe0003fff]
[    0.672505] pci 0000:07:03.0: supports D1 D2
[    0.672816] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.673192] pci 0000:07:03.0: PME# disabled
[    0.673549] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.673968] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.674374] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.674937] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.675497] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.676085] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    0.676673] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.677259] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    0.677883] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.679157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.679784] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    0.680255] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    0.680728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
[    0.681194] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.681664] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.682144] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.682713]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.705999] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.707086] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.708170] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.709257] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.710343] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.711428] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.712510] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.713592] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.714915] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.715489] vgaarb: loaded
[    0.715745] vgaarb: bridge control possible 0000:02:00.0
[    0.716304] SCSI subsystem initialized
[    0.716773] libata version 3.00 loaded.
[    0.717327] usbcore: registered new interface driver usbfs
[    0.717747] usbcore: registered new interface driver hub
[    0.718171] usbcore: registered new device driver usb
[    0.718958] wmi: Mapper loaded
[    0.719287] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.719677] PCI: Using ACPI for IRQ routing
[    0.721561] PCI: Discovered peer bus 3f
[    0.721940] pci 0000:3f:00.0: [8086:2c41] type 0 class 0x000600
[    0.722339] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    0.722749] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    0.723147] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    0.723548] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    0.723949] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    0.724347] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    0.724750] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    0.725147] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    0.725544] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    0.725945] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    0.726346] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    0.726748] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    0.727145] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    0.727541] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    0.727946] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    0.728346] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    0.728746] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    0.729143] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    0.730969] PCI: pci_cache_line_size set to 64 bytes
[    0.731535] reserve RAM buffer: 000000000009cc00 - 000000000009ffff
[    0.731803] reserve RAM buffer: 00000000bcde3000 - 00000000bfffffff
[    0.732224] reserve RAM buffer: 00000000bf6bd000 - 00000000bfffffff
[    0.732645] reserve RAM buffer: 00000000bf714000 - 00000000bfffffff
[    0.733066] reserve RAM buffer: 00000000bf7e7000 - 00000000bfffffff
[    0.733487] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
[    0.762972] pnp: PnP ACPI init
[    0.763414] ACPI: bus type pnp registered
[    0.764324] pnp 00:00: [bus 00-3d]
[    0.764607] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.764913] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.765238] pnp 00:00: [io  0x0d00-0xffff window]
[    0.765563] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.765920] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    0.766271] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    0.766629] pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
[    0.766980] pnp 00:00: [mem 0x00000000 window]
[    0.767434] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.768114] pnp 00:01: [io  0x0000-0x000f]
[    0.768417] pnp 00:01: [io  0x0081-0x0083]
[    0.768723] pnp 00:01: [io  0x0087]
[    0.769002] pnp 00:01: [io  0x0089-0x008b]
[    0.769302] pnp 00:01: [io  0x008f]
[    0.769581] pnp 00:01: [io  0x00c0-0x00df]
[    0.772863] pnp 00:01: [dma 4]
[    0.773221] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.773635] pnp 00:02: [io  0x0070-0x0071]
[    0.773938] pnp 00:02: [io  0x0074-0x0077]
[    0.774244] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.774814] pnp 00:02: [irq 8]
[    0.775174] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.775591] pnp 00:03: [io  0x00f0]
[    0.775874] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.776444] pnp 00:03: [irq 13]
[    0.776808] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.777220] pnp 00:04: [io  0x0061]
[    0.777598] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.778008] pnp 00:05: [io  0x0500-0x053f]
[    0.778310] pnp 00:05: [io  0x0400-0x047f]
[    0.778616] pnp 00:05: [io  0x0092]
[    0.778897] pnp 00:05: [io  0x0680-0x06ff]
[    0.779198] pnp 00:05: [io  0x0010-0x001f]
[    0.779499] pnp 00:05: [io  0x0072-0x0073]
[    0.779804] pnp 00:05: [io  0x0080]
[    0.780084] pnp 00:05: [io  0x0084-0x0086]
[    0.780386] pnp 00:05: [io  0x0088]
[    0.780669] pnp 00:05: [io  0x008c-0x008e]
[    0.780970] pnp 00:05: [io  0x0090-0x009f]
[    0.781449] system 00:05: [io  0x0500-0x053f] has been reserved
[    0.781828] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.782198] system 00:05: [io  0x0680-0x06ff] has been reserved
[    0.782568] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.783053] pnp 00:06: [io  0x0060]
[    0.783333] pnp 00:06: [io  0x0064]
[    0.783786] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.784743] pnp 00:07: [mem 0xfec00000-0xfec000ff]
[    0.785178] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.785713] pnp: PnP ACPI: found 8 devices
[    0.786016] ACPI: ACPI bus type pnp unregistered
[    0.797132] Switching to clocksource acpi_pm
[    0.797593] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.798213] PCI: max bus depth: 1 pci_try_num: 2
[    0.798618] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.798972] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    0.799507] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.799861] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.800264] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.800831] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    0.801184] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.801546] pci 0000:00:1c.1: PCI bridge to [bus 05-05]
[    0.801900] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.802246] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.802639] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.803047] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.803395] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.803825] IOAPIC[0]: Set routing entry (8-16 -> 0x29 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    0.804397] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.804811] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.805215] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.805636] IOAPIC[0]: Set routing entry (8-17 -> 0x41 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    0.806206] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.806627] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.807033] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.807437] pci 0000:00:1e.0: setting latency timer to 64
[    0.807799] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.808157] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.808514] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.808904] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.809287] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.809680] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.810062] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    0.810445] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.810990] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.811346] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    0.811738] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.812119] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.812475] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.812839] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.813221] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.813613] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.813995] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.814377] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    0.814745] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xfffffffff]
[    0.815190] NET: Registered protocol family 2
[    0.815813] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.818241] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.821995] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.825607] TCP: Hash tables configured (established 524288 bind 65536)
[    0.826020] TCP reno registered
[    0.826353] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.827006] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.827765] NET: Registered protocol family 1
[    0.828287] RPC: Registered named UNIX socket transport module.
[    0.828673] RPC: Registered udp transport module.
[    0.828997] RPC: Registered tcp transport module.
[    0.829321] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.829760] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.830152] pci 0000:00:1a.0: Performing full reset
[    0.830500] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.830898] pci 0000:00:1a.1: Performing full reset
[    0.831246] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.831646] pci 0000:00:1a.2: Performing full reset
[    0.832147] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.832560] pci 0000:00:1d.0: Performing full reset
[    0.832912] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.833304] pci 0000:00:1d.1: Performing full reset
[    0.833663] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.834056] pci 0000:00:1d.2: Performing full reset
[    0.834555] pci 0000:02:00.0: Boot video device
[    0.834932] PCI: CLS 64 bytes, default 64
[    0.839134] Machine check injector initialized
[    0.841328] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[    0.841717] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[    0.842088] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[    0.842465] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[    0.842837] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[    0.843214] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[    0.843589] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[    0.843960] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[    0.844422] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.845480] audit: initializing netlink socket (disabled)
[    0.845862] type=2000 audit(1320159178.593:1): initialized
[    0.871004] rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
[    0.889571] Testing tracer function: .. no entries found ..FAILED!
[    1.025574] Testing tracer irqsoff:
[    1.057576] failed to start irqsoff tracer
[    1.058156] .. no entries found ..FAILED!
[    1.073573] Testing tracer wakeup:
[    1.107590] failed to start wakeup tracer
[    1.411875] .. no entries found ..FAILED!
[    1.430604] Testing tracer function_graph:
[    1.445671] Failed to init function_graph tracer, init returned -19
[    1.446211] FAILED!
[    1.454631] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.467609] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.468986] fuse init (API version 7.17)
[    1.469950] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.474358] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.477021] NILFS version 2 loaded
[    1.478335] Btrfs loaded
[    1.478608] msgmni has been set to 5883
[    1.480080] async_tx: api initialized (async)
[    1.480611] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.481207] io scheduler noop registered
[    1.481505] io scheduler deadline registered
[    1.481997] io scheduler cfq registered (default)
[    1.482836] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.483361] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.483906] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    1.484629] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.485440] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.486038] ACPI: Sleep Button [SLPB]
[    1.486467] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.487022] ACPI: Power Button [PWRF]
[    1.488077] ACPI: acpi_idle registered with cpuidle
[    1.488859] Monitor-Mwait will be used to enter C-1 state
[    1.489260] Monitor-Mwait will be used to enter C-3 state
[    1.497130] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.500072] kworker/u:1 used greatest stack depth: 5184 bytes left
[    1.544705] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.560675] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.589887] Initializing Nozomi driver 2.1d
[    1.590743] Non-volatile memory driver v1.3
[    1.591523] Linux agpgart interface v0.103
[    1.591934] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.595536] Hangcheck: Using getrawmonotonic().
[    1.595939] [drm] Initialized drm 1.1.0 20060810
[    1.596261] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.837631] Refined TSC clocksource calibration: 3200.113 MHz.
[    1.838001] Switching to clocksource tsc
[    4.611722] floppy0: no floppy controllers found
[    4.612605] ------------[ cut here ]------------
[    4.612938] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.613538] Hardware name:
[    4.613822] VFS: do_fd_request called on non-open device
[    4.614176] Modules linked in:
[    4.614480] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.615118] Call Trace:
[    4.615370]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.615766]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.616154]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.616533]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.616928]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.617287]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.617658]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.618037]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.618416]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.618789]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.619132]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.619504]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.619861]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.620239]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.620630]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.620998]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.621363] ---[ end trace 4eaa2a86a8e2da24 ]---
[    4.621829] ------------[ cut here ]------------
[    4.622158] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.622776] Hardware name:
[    4.623065] VFS: do_fd_request called on non-open device
[    4.623417] Modules linked in:
[    4.623722] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.624344] Call Trace:
[    4.624602]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.624995]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.625374]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.625762]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.626150]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.626515]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.626894]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.627267]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.627661]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.628033]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.628376]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.628751]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.629121]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.629507]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.629901]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.630283]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.630634] ---[ end trace 4eaa2a86a8e2da25 ]---
[    4.631035] ------------[ cut here ]------------
[    4.631366] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.631992] Hardware name:
[    4.632278] VFS: do_fd_request called on non-open device
[    4.632631] Modules linked in:
[    4.632936] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.633559] Call Trace:
[    4.633811]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.634207]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.634594]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.634974]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.635369]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.635728]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.636107]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.636486]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.636872]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.637238]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.637595]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.637974]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.638336]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.638716]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.639101]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.639476]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.639832] ---[ end trace 4eaa2a86a8e2da26 ]---
[    4.640247] ------------[ cut here ]------------
[    4.640575] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.641185] Hardware name:
[    4.641473] VFS: do_fd_request called on non-open device
[    4.641840] Modules linked in:
[    4.642157] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.642796] Call Trace:
[    4.643055]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.643438]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.643822]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.644215]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.644619]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.644991]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.645356]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.645722]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.646115]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.646482]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.646831]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.647199]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.647554]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.647940]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.648325]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.648694]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.649056] ---[ end trace 4eaa2a86a8e2da27 ]---
[    4.649464] ------------[ cut here ]------------
[    4.649794] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.650399] Hardware name:
[    4.650683] VFS: do_fd_request called on non-open device
[    4.651038] Modules linked in:
[    4.651347] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.651982] Call Trace:
[    4.652230]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.652612]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.652996]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.653380]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.653775]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.654134]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.654507]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.654880]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.655273]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.655637]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.655992]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.656364]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.656719]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.657101]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.657494]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.657868]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.658218] ---[ end trace 4eaa2a86a8e2da28 ]---
[    4.658616] ------------[ cut here ]------------
[    4.658951] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.659554] Hardware name:
[    4.659844] VFS: do_fd_request called on non-open device
[    4.660202] Modules linked in:
[    4.660505] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.661142] Call Trace:
[    4.661399]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.661788]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.662167]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.662553]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.662942]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.663301]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.663665]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.664044]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.664430]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.664794]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.665141]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.665508]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.665871]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.666265]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.666657]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.667035]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.667386] ---[ end trace 4eaa2a86a8e2da29 ]---
[    4.667791] ------------[ cut here ]------------
[    4.668120] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.668737] Hardware name:
[    4.669034] VFS: do_fd_request called on non-open device
[    4.669388] Modules linked in:
[    4.669704] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.670347] Call Trace:
[    4.670596]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.670985]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.671371]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.671751]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.672140]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.672504]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.672870]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.673234]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.676597]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.676971]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.677327]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.677695]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.678064]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.678443]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.678828]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.679196]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.679552] ---[ end trace 4eaa2a86a8e2da2a ]---
[    4.679966] ------------[ cut here ]------------
[    4.680296] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
[    4.680913] Hardware name:
[    4.681197] VFS: do_fd_request called on non-open device
[    4.681558] Modules linked in:
[    4.681865] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[    4.682507] Call Trace:
[    4.682756]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[    4.683137]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
[    4.683508]  [<ffffffff813ed09a>] ? blk_throtl_drain+0xf6/0x105
[    4.683893]  [<ffffffff81985fde>] ? _raw_spin_unlock_irq+0x30/0x3c
[    4.684296]  [<ffffffff8151cacd>] do_fd_request+0x37/0xaa
[    4.684661]  [<ffffffff813da7a6>] __blk_run_queue+0x1e/0x20
[    4.685025]  [<ffffffff813dfcae>] blk_drain_queue+0x41/0x7a
[    4.685404]  [<ffffffff813dfe0c>] blk_cleanup_queue+0x125/0x184
[    4.685783]  [<ffffffff82146d50>] floppy_init+0xd9c/0xdc2
[    4.686143]  [<ffffffff82145fb4>] ? daring+0x65/0x65
[    4.686485]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[    4.686853]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[    4.687215]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[    4.687600]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[    4.688000]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[    4.688369]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[    4.688724] ---[ end trace 4eaa2a86a8e2da2b ]---
[    4.704473] brd: module loaded
[    4.762829] loop: module loaded
[    4.768010] Loading iSCSI transport class v2.0-870.
[    4.774254] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.774619] Detecting Adaptec I2O RAID controllers...
[    4.775970] Adaptec aacraid driver 1.1-7[28000]-ms
[    4.777589] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.779141] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
[    4.780672] iscsi: registered transport (qla4xxx)
[    4.781486] QLogic iSCSI HBA Driver
[    4.782258] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.783279] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.784169] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
[    4.785139] mpt2sas version 09.100.00.01 loaded
[    4.787776] ahci 0000:00:1f.2: version 3.0
[    4.788131] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    4.788735] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.789200] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    4.789632] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.790231] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
[    4.790811] ahci 0000:00:1f.2: setting latency timer to 64
[    4.810827] scsi0 : ahci
[    4.812397] scsi1 : ahci
[    4.813946] scsi2 : ahci
[    4.815471] scsi3 : ahci
[    4.817024] scsi4 : ahci
[    4.818574] scsi5 : ahci
[    4.820997] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    4.821559] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    4.822134] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    4.822691] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    4.823258] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    4.823820] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    4.824475] ahci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.824930] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    4.825613] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    4.826047] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    4.826464] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    4.826861] ahci: SSS flag set, parallel bus scan disabled
[    4.827262] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    4.827858] ahci 0000:06:00.0: flags: 64bit stag led slum part
[    4.833177] scsi6 : ahci
[    4.834713] scsi7 : ahci
[    4.836257] scsi8 : ahci
[    4.837417] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    4.838025] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    4.838575] ata9: DUMMY
[    4.860934] tun: Universal TUN/TAP device driver, 1.6
[    4.861278] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.863086] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.863444] Copyright (c) 2007 Atheros Corporation.
[    4.865669] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
[    4.867124] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.867515] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.868371] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.868849] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.869703] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    4.870084] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.870502] IOAPIC[0]: Set routing entry (8-20 -> 0x71 -> IRQ 20 Mode:1 Active:1 Dest:0)
[    4.871105] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.871528] e1000e 0000:00:19.0: setting latency timer to 64
[    4.872058] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.074688] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    5.075281] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.075726] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    5.076620] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    5.077039] Copyright (c) 2007-2011 Intel Corporation.
[    5.077685] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    5.078251] Copyright (c) 2009 - 2011 Intel Corporation.
[    5.079104] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
[    5.079675] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
[    5.080539] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    5.080986] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    5.082455] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    5.083461] sky2: driver version 1.29
[    5.086557] usbcore: registered new interface driver catc
[    5.086922] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    5.087540] usbcore: registered new interface driver kaweth
[    5.087942] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    5.088939] usbcore: registered new interface driver pegasus
[    5.089306] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    5.090165] usbcore: registered new interface driver rtl8150
[    5.090960] usbcore: registered new interface driver asix
[    5.091565] usbcore: registered new interface driver cdc_ether
[    5.092903] usbcore: registered new interface driver cdc_eem
[    5.093721] usbcore: registered new interface driver dm9601
[    5.094517] usbcore: registered new interface driver smsc75xx
[    5.095345] usbcore: registered new interface driver smsc95xx
[    5.096157] usbcore: registered new interface driver gl620a
[    5.096944] usbcore: registered new interface driver net1080
[    5.097744] usbcore: registered new interface driver plusb
[    5.098533] usbcore: registered new interface driver rndis_host
[    5.099366] usbcore: registered new interface driver cdc_subset
[    5.100194] usbcore: registered new interface driver zaurus
[    5.100996] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.101998] usbcore: registered new interface driver int51x1
[    5.102365] cdc_ncm: 04-Aug-2011
[    5.103070] usbcore: registered new interface driver cdc_ncm
[    5.103453] Fusion MPT base driver 3.04.20
[    5.103769] Copyright (c) 1999-2008 LSI Corporation
[    5.104118] Fusion MPT SPI Host driver 3.04.20
[    5.104924] Fusion MPT FC Host driver 3.04.20
[    5.105747] Fusion MPT SAS Host driver 3.04.20
[    5.106544] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.107403] mptctl: Registered with Fusion MPT base driver
[    5.107793] mptctl: /dev/mptctl @ (major,minor=10,220)
[    5.108639] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.109050] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    5.109483] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    5.110098] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.110541] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.110923] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.111369] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file 'devices'
[    5.111971] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.112405] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.112969] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    5.113583] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    5.114286] ehci_hcd 0000:00:1a.7: debug port 1
[    5.117601] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.122119] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    5.122528] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    5.123027] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0322000
[    5.123395] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.127913] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    5.128721] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.129722] ata3: SATA link down (SStatus 0 SControl 300)
[    5.130138] ata5: SATA link down (SStatus 0 SControl 300)
[    5.130524] ata4: SATA link down (SStatus 0 SControl 300)
[    5.130917] ata6: SATA link down (SStatus 0 SControl 300)
[    5.133710] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.134181] usb usb1: default language 0x0409
[    5.134513] usb usb1: udev 1, busnum 1, minor = 0
[    5.134863] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.135289] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.135842] usb usb1: Product: EHCI Host Controller
[    5.136179] usb usb1: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ ehci_hcd
[    5.136792] usb usb1: SerialNumber: 0000:00:1a.7
[    5.137714] usb usb1: usb_probe_device
[    5.138010] usb usb1: configuration #1 chosen from 1 choice
[    5.138421] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.139826] hub 1-0:1.0: usb_probe_interface
[    5.140142] hub 1-0:1.0: usb_probe_interface - got id
[    5.140491] hub 1-0:1.0: USB hub found
[    5.140799] hub 1-0:1.0: 6 ports detected
[    5.141103] hub 1-0:1.0: standalone hub
[    5.141405] hub 1-0:1.0: no power switching (usb 1.0)
[    5.141754] hub 1-0:1.0: individual port over-current protection
[    5.142140] hub 1-0:1.0: power on to power good time: 20ms
[    5.142540] hub 1-0:1.0: local power source is good
[    5.142883] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.143362] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.143741] ata7: SATA link down (SStatus 0 SControl 300)
[    5.144350] IOAPIC[0]: Set routing entry (8-23 -> 0x89 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    5.144946] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.145391] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.145777] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.146151] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    5.146574] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.147136] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    5.147752] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    5.148427] ehci_hcd 0000:00:1d.7: debug port 1
[    5.148766] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.153278] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    5.153700] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    5.154212] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0321000
[    5.154586] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    5.159103] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    5.165710] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.166158] usb usb2: default language 0x0409
[    5.166490] usb usb2: udev 1, busnum 2, minor = 128
[    5.166834] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.167253] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.167818] usb usb2: Product: EHCI Host Controller
[    5.168156] usb usb2: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ ehci_hcd
[    5.168744] usb usb2: SerialNumber: 0000:00:1d.7
[    5.169620] usb usb2: usb_probe_device
[    5.169751] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    5.169754] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.170722] usb usb2: configuration #1 chosen from 1 choice
[    5.171095] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.171866] hub 2-0:1.0: usb_probe_interface
[    5.172182] hub 2-0:1.0: usb_probe_interface - got id
[    5.172527] hub 2-0:1.0: USB hub found
[    5.172836] hub 2-0:1.0: 6 ports detected
[    5.173153] hub 2-0:1.0: standalone hub
[    5.173456] hub 2-0:1.0: no power switching (usb 1.0)
[    5.173805] hub 2-0:1.0: individual port over-current protection
[    5.174187] hub 2-0:1.0: power on to power good time: 20ms
[    5.174556] hub 2-0:1.0: local power source is good
[    5.174899] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.175396] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.176407] uhci_hcd: USB Universal Host Controller Interface driver
[    5.176863] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.177292] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.177675] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.178037] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '003'
[    5.178457] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.179019] uhci_hcd 0000:00:1a.0: detected 2 ports
[    5.179359] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.179769] uhci_hcd 0000:00:1a.0: Performing full reset
[    5.180139] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    5.180516] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    5.180972] usb usb3: default language 0x0409
[    5.181304] usb usb3: udev 1, busnum 3, minor = 256
[    5.181642] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.182059] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.182620] usb usb3: Product: UHCI Host Controller
[    5.182975] usb usb3: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ uhci_hcd
[    5.183576] usb usb3: SerialNumber: 0000:00:1a.0
[    5.184461] usb usb3: usb_probe_device
[    5.184772] usb usb3: configuration #1 chosen from 1 choice
[    5.185146] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    5.185965] hub 3-0:1.0: usb_probe_interface
[    5.186287] hub 3-0:1.0: usb_probe_interface - got id
[    5.186637] hub 3-0:1.0: USB hub found
[    5.186947] hub 3-0:1.0: 2 ports detected
[    5.187252] hub 3-0:1.0: standalone hub
[    5.187564] hub 3-0:1.0: no power switching (usb 1.0)
[    5.187927] hub 3-0:1.0: individual port over-current protection
[    5.188323] hub 3-0:1.0: power on to power good time: 2ms
[    5.188693] hub 3-0:1.0: local power source is good
[    5.189035] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    5.189478] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.189983] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    5.190455] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:0)
[    5.191068] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.191505] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.191894] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.192267] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    5.192689] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.193249] uhci_hcd 0000:00:1a.1: detected 2 ports
[    5.193590] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.194009] uhci_hcd 0000:00:1a.1: Performing full reset
[    5.194383] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    5.194788] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    5.195210] usb usb4: default language 0x0409
[    5.195541] usb usb4: udev 1, busnum 4, minor = 384
[    5.195899] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.196325] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.196899] usb usb4: Product: UHCI Host Controller
[    5.197237] usb usb4: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ uhci_hcd
[    5.197833] usb usb4: SerialNumber: 0000:00:1a.1
[    5.198718] usb usb4: usb_probe_device
[    5.199026] usb usb4: configuration #1 chosen from 1 choice
[    5.199413] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    5.200242] hub 4-0:1.0: usb_probe_interface
[    5.200571] hub 4-0:1.0: usb_probe_interface - got id
[    5.200931] hub 4-0:1.0: USB hub found
[    5.201245] hub 4-0:1.0: 2 ports detected
[    5.201549] hub 4-0:1.0: standalone hub
[    5.201854] hub 4-0:1.0: no power switching (usb 1.0)
[    5.202213] hub 4-0:1.0: individual port over-current protection
[    5.202601] hub 4-0:1.0: power on to power good time: 2ms
[    5.202975] hub 4-0:1.0: local power source is good
[    5.203314] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    5.203787] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.204290] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    5.204762] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.205191] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.205571] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.205973] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '005'
[    5.206412] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.206975] uhci_hcd 0000:00:1a.2: detected 2 ports
[    5.207314] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.207727] uhci_hcd 0000:00:1a.2: Performing full reset
[    5.208108] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    5.208506] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    5.208960] usb usb5: default language 0x0409
[    5.209292] usb usb5: udev 1, busnum 5, minor = 512
[    5.209633] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.210049] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.210610] usb usb5: Product: UHCI Host Controller
[    5.210959] usb usb5: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ uhci_hcd
[    5.211550] usb usb5: SerialNumber: 0000:00:1a.2
[    5.215461] usb usb5: usb_probe_device
[    5.215771] usb usb5: configuration #1 chosen from 1 choice
[    5.216159] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    5.216973] hub 5-0:1.0: usb_probe_interface
[    5.217301] hub 5-0:1.0: usb_probe_interface - got id
[    5.217644] hub 5-0:1.0: USB hub found
[    5.217951] hub 5-0:1.0: 2 ports detected
[    5.218260] hub 5-0:1.0: standalone hub
[    5.218562] hub 5-0:1.0: no power switching (usb 1.0)
[    5.218925] hub 5-0:1.0: individual port over-current protection
[    5.219313] hub 5-0:1.0: power on to power good time: 2ms
[    5.219691] hub 5-0:1.0: local power source is good
[    5.220034] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    5.220486] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.220996] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    5.221464] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.221905] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.222280] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.222646] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '006'
[    5.223098] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.223678] uhci_hcd 0000:00:1d.0: detected 2 ports
[    5.224030] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    5.224436] uhci_hcd 0000:00:1d.0: Performing full reset
[    5.224810] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    5.225194] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    5.225618] usb usb6: default language 0x0409
[    5.225955] usb usb6: udev 1, busnum 6, minor = 640
[    5.226300] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.226733] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.227276] usb usb6: Product: UHCI Host Controller
[    5.227616] usb usb6: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ uhci_hcd
[    5.228057] ata1.00: configured for UDMA/133
[    5.228538] usb usb6: SerialNumber: 0000:00:1d.0
[    5.229074] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    5.230573] usb usb6: usb_probe_device
[    5.230885] usb usb6: configuration #1 chosen from 1 choice
[    5.231275] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    5.232186] hub 6-0:1.0: usb_probe_interface
[    5.232516] hub 6-0:1.0: usb_probe_interface - got id
[    5.232881] hub 6-0:1.0: USB hub found
[    5.233193] hub 6-0:1.0: 2 ports detected
[    5.233499] hub 6-0:1.0: standalone hub
[    5.233801] hub 6-0:1.0: no power switching (usb 1.0)
[    5.234145] hub 6-0:1.0: individual port over-current protection
[    5.234533] hub 6-0:1.0: power on to power good time: 2ms
[    5.234904] hub 6-0:1.0: local power source is good
[    5.235255] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    5.235724] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.236238] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    5.236697] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.237148] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.237525] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.237949] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '007'
[    5.237994] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.238126] sd 0:0:0:0: [sda] Write Protect is off
[    5.238129] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.238184] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.240324] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.240921] uhci_hcd 0000:00:1d.1: detected 2 ports
[    5.241265] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    5.241689] uhci_hcd 0000:00:1d.1: Performing full reset
[    5.242074] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    5.242504] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    5.242925] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.243534] hub 1-0:1.0: port 1: status 0501 change 0001
[    5.243904] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001403 0  ACK POWER sig=k CSC CONNECT
[    5.244510] hub 1-0:1.0: port 2: status 0501 change 0001
[    5.244901] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.245526] hub 1-0:1.0: port 4: status 0501 change 0001
[    5.245963] usb usb7: default language 0x0409
[    5.246293] usb usb7: udev 1, busnum 7, minor = 768
[    5.246632] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.247062] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.247614] usb usb7: Product: UHCI Host Controller
[    5.247955] usb usb7: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ uhci_hcd
[    5.248556] usb usb7: SerialNumber: 0000:00:1d.1
[    5.249336] usb usb7: usb_probe_device
[    5.249644] usb usb7: configuration #1 chosen from 1 choice
[    5.250027] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    5.250736] hub 7-0:1.0: usb_probe_interface
[    5.251051] hub 7-0:1.0: usb_probe_interface - got id
[    5.251395] hub 7-0:1.0: USB hub found
[    5.251709] hub 7-0:1.0: 2 ports detected
[    5.252014] hub 7-0:1.0: standalone hub
[    5.252316] hub 7-0:1.0: no power switching (usb 1.0)
[    5.252659] hub 7-0:1.0: individual port over-current protection
[    5.253050] hub 7-0:1.0: power on to power good time: 2ms
[    5.253416] hub 7-0:1.0: local power source is good
[    5.253757] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    5.254227] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.254747] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    5.255213] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.255659] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.256060] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.256425] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '008'
[    5.256869] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.257435] uhci_hcd 0000:00:1d.2: detected 2 ports
[    5.257780] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    5.258188] uhci_hcd 0000:00:1d.2: Performing full reset
[    5.258553] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    5.258936] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    5.259355] usb usb8: default language 0x0409
[    5.259689] usb usb8: udev 1, busnum 8, minor = 896
[    5.260050] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.260477] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.261028] usb usb8: Product: UHCI Host Controller
[    5.261373] usb usb8: Manufacturer: Linux 3.1.0-ioless-full-bg-all-next-20111025+ uhci_hcd
[    5.261966] usb usb8: SerialNumber: 0000:00:1d.2
[    5.262746] usb usb8: usb_probe_device
[    5.263052] usb usb8: configuration #1 chosen from 1 choice
[    5.263424] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    5.264248] hub 8-0:1.0: usb_probe_interface
[    5.264565] hub 8-0:1.0: usb_probe_interface - got id
[    5.264931] hub 8-0:1.0: USB hub found
[    5.265240] hub 8-0:1.0: 2 ports detected
[    5.265545] hub 8-0:1.0: standalone hub
[    5.265860] hub 8-0:1.0: no power switching (usb 1.0)
[    5.266210] hub 8-0:1.0: individual port over-current protection
[    5.266598] hub 8-0:1.0: power on to power good time: 2ms
[    5.266977] hub 8-0:1.0: local power source is good
[    5.267315] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    5.267778] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '001'
[    5.268287] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    5.269066] Initializing USB Mass Storage driver...
[    5.269873] usbcore: registered new interface driver usb-storage
[    5.270251] USB Mass Storage support registered.
[    5.271053] usbcore: registered new interface driver libusual
[    5.271866] usbcore: registered new interface driver ums-alauda
[    5.272684] usbcore: registered new interface driver ums-cypress
[    5.273522] usbcore: registered new interface driver ums-datafab
[    5.274345] usbcore: registered new interface driver ums-freecom
[    5.274825] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    5.275225] usbcore: registered new interface driver ums-isd200
[    5.276035] usbcore: registered new interface driver ums-jumpshot
[    5.276849] usbcore: registered new interface driver ums-karma
[    5.277657] usbcore: registered new interface driver ums-onetouch
[    5.278488] usbcore: registered new interface driver ums-sddr09
[    5.279297] usbcore: registered new interface driver ums-sddr55
[    5.280040] usbcore: registered new interface driver ums-usbat
[    5.281283] usbcore: registered new interface driver usbserial
[    5.282096] USB Serial support registered for generic
[    5.282894] usbcore: registered new interface driver usbserial_generic
[    5.283302] usbserial: USB Serial Driver core
[    5.284053] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    5.285093] usbcore: registered new interface driver belkin
[    5.285456] belkin_sa: v1.3:USB Belkin Serial converter driver
[    5.286255] USB Serial support registered for MCT U232
[    5.287041] usbcore: registered new interface driver mct_u232
[    5.287412] mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
[    5.288719] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    5.289096] uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
[    5.290314] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.294257] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.294617] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.296572] mousedev: PS/2 mouse device common for all mice
[    5.300392] rtc_cmos 00:02: RTC can wake from S4
[    5.301325] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.301745] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    5.302539] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    5.303726] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    5.304186] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    5.305104] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.305488] iTCO_vendor_support: vendor-support=0
[    5.308802] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    5.309201] md: linear personality registered for level -1
[    5.309560] md: raid0 personality registered for level 0
[    5.309919] md: raid1 personality registered for level 1
[    5.310273] md: raid10 personality registered for level 10
[    5.310633] md: raid6 personality registered for level 6
[    5.310991] md: raid5 personality registered for level 5
[    5.311344] md: raid4 personality registered for level 4
[    5.311698] md: multipath personality registered for level -4
[    5.312072] md: faulty personality registered for level -5
[    5.313899] device-mapper: uevent: version 1.0.3
[    5.315225] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    5.316465] device-mapper: multipath: version 1.3.0 loaded
[    5.316842] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.317242] device-mapper: multipath queue-length: version 0.1.0 loaded
[    5.317645] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.318508] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    5.319738] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.320090]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    5.327426] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.331537] cpuidle: using governor ladder
[    5.334739] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.345724] hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
[    5.346103] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.347669] cpuidle: using governor menu
[    5.348795] usbcore: registered new interface driver usbhid
[    5.349158] usbhid: USB HID core driver
[    5.350719] dell_wmi: No known WMI GUID found
[    5.351036] acer_wmi: Acer Laptop ACPI-WMI Extras
[    5.351370] acer_wmi: No or unsupported WMI interface, unable to load
[    5.352578] IOAPIC[0]: Set routing entry (8-22 -> 0x99 -> IRQ 22 Mode:1 Active:1 Dest:0)
[    5.353171] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.353797] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    5.354204] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
[    5.354617] ALSA hda_intel.c:1163 Clearing TCSEL
[    5.362720] ALSA hda_intel.c:1009 codec_mask = 0x4
[    5.363524] ALSA hda_intel.c:1472 codec #2 probed OK
[    5.368907] ALSA hda_codec.c:3994 hda_codec: model 'intel-x58' is selected for config 8086:22 (DX58SO)
[    5.369529] hda_codec: ALC889: SKU not ready 0x411111f0
[    5.370250] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input2
[    5.374051] ALSA hda_codec.c:2378 Cannot find slave Side Playback Volume, skipped
[    5.374607] ALSA hda_codec.c:2378 Cannot find slave Headphone Playback Volume, skipped
[    5.375184] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Volume, skipped
[    5.375745] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Volume, skipped
[    5.376312] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Volume, skipped
[    5.376876] ALSA hda_codec.c:2378 Cannot find slave Side Playback Switch, skipped
[    5.377431] ALSA hda_codec.c:2378 Cannot find slave Mono Playback Switch, skipped
[    5.377989] ALSA hda_codec.c:2378 Cannot find slave Line-Out Playback Switch, skipped
[    5.378555] ALSA hda_codec.c:2378 Cannot find slave PCM Playback Switch, skipped
[    5.381026] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
[    5.382906] ALSA device list:
[    5.383172]   #0: HDA Intel at 0xf7f00000 irq 45
[    5.383501] oprofile: using NMI interrupt.
[    5.383861] netem: version 1.3
[    5.384131] Netfilter messages via NETLINK v0.30.
[    5.384502] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.386333] ctnetlink v0.93: registering with nfnetlink.
[    5.386744] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    5.387161] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    5.388453] xt_time: kernel timezone is -0000
[    5.391007] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.391447] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    5.391888] arp_tables: (C) 2002 David S. Miller
[    5.392254] TCP bic registered
[    5.392522] TCP cubic registered
[    5.392802] TCP westwood registered
[    5.393087] TCP highspeed registered
[    5.393374] TCP hybla registered
[    5.393648] TCP htcp registered
[    5.393924] TCP vegas registered
[    5.394198] TCP veno registered
[    5.394469] TCP scalable registered
[    5.394757] TCP lp registered
[    5.395022] TCP yeah registered
[    5.395293] TCP illinois registered
[    5.395576] Initializing XFRM netlink socket
[    5.396948] ehci_hcd 0000:00:1a.7: port 1 high speed
[    5.397120] NET: Registered protocol family 10
[    5.397621] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.401798] IPv6 over IPv4 tunneling driver
[    5.404909] NET: Registered protocol family 17
[    5.405243] NET: Registered protocol family 15
[    5.405762] Bridge firewalling registered
[    5.406095] Ebtables v2.0 registered
[    5.406535] Registering the dns_resolver key type
[    5.406958]
[    5.406959] printing PIC contents
[    5.407451] ... PIC  IMR: ffff
[    5.407723] ... PIC  IRR: 0c21
[    5.408003] ... PIC  ISR: 0000
[    5.408278] ... PIC ELCR: 0c20
[    5.408562] printing local APIC contents on CPU#0/0:
[    5.408905] ... APIC ID:      00000000 (0)
[    5.409212] ... APIC VERSION: 00060015
[    5.409506] ... APIC TASKPRI: 00000000 (00)
[    5.409817] ... APIC PROCPRI: 00000000
[    5.410112] ... APIC LDR: 01000000
[    5.410393] ... APIC DFR: ffffffff
[    5.410675] ... APIC SPIV: 000001ff
[    5.410959] ... APIC ISR field:
[    5.411231] 0000000000000000000000000000000000000000000000000000000000000000
[    5.411926] ... APIC TMR field:
[    5.412198] 0000000000000000000000000000000000000002000000000000000000000000
[    5.412894] ... APIC IRR field:
[    5.413164] 0000000000000000000000000000000000000000000000000000000000008000
[    5.413862] ... APIC ESR: 00000000
[    5.414143] ... APIC ICR: 000000fd
[    5.414424] ... APIC ICR2: 06000000
[    5.414709] ... APIC LVTT: 000000ef
[    5.414993] ... APIC LVTPC: 00000400
[    5.415280] ... APIC LVT0: 00010700
[    5.415565] ... APIC LVT1: 00000400
[    5.415849] ... APIC LVTERR: 000000fe
[    5.416139] ... APIC TMICT: 00002073
[    5.416425] ... APIC TMCCT: 00000000
[    5.416712] ... APIC TDCR: 00000003
[    5.416995]
[    5.417204] number of MP IRQ sources: 15.
[    5.417514] number of IO-APIC #8 registers: 24.
[    5.417842] testing the IO APIC.......................
[    5.418193]
[    5.418404] IO APIC #8......
[    5.418677] .... register #00: 08000000
[    5.418983] .......    : physical APIC id: 08
[    5.419301] .......    : Delivery Type: 0
[    5.419605] .......    : LTS          : 0
[    5.419920] .... register #01: 00170020
[    5.420217] .......     : max redirection entries: 17
[    5.420559] .......     : PRQ implemented: 0
[    5.420881] .......     : IO APIC version: 20
[    5.421197] .... IRQ redirection table:
[    5.421507]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.421888]  00 00  1    0    0   0   0    0    0    00
[    5.422292]  01 00  0    0    0   0   0    0    0    31
[    5.422685]  02 00  0    0    0   0   0    0    0    30
[    5.423078]  03 00  0    0    0   0   0    0    0    33
[    5.423474]  04 00  0    0    0   0   0    0    0    34
[    5.423874]  05 00  0    0    0   0   0    0    0    35
[    5.424266]  06 00  1    0    0   0   0    0    0    36
[    5.424663]  07 00  0    0    0   0   0    0    0    37
[    5.425059]  08 00  0    0    0   0   0    0    0    38
[    5.425457]  09 00  0    1    0   0   0    0    0    39
[    5.425860]  0a 00  0    0    0   0   0    0    0    3A
[    5.426253]  0b 00  0    0    0   0   0    0    0    3B
[    5.426642]  0c 00  0    0    0   0   0    0    0    3C
[    5.427042]  0d 00  0    0    0   0   0    0    0    3D
[    5.427446]  0e 00  0    0    0   0   0    0    0    3E
[    5.427840]  0f 00  0    0    0   0   0    0    0    3F
[    5.428240]  10 00  0    1    0   1   0    0    0    29
[    5.428641]  11 00  1    1    0   1   0    0    0    41
[    5.429038]  12 00  0    1    0   1   0    0    0    81
[    5.429427]  13 00  0    1    0   1   0    0    0    61
[    5.429820]  14 00  1    1    0   1   0    0    0    71
[    5.430224]  15 00  0    1    0   1   0    0    0    91
[    5.430614]  16 00  1    1    0   1   0    0    0    99
[    5.431011]  17 00  0    1    0   1   0    0    0    89
[    5.431399] IRQ to pin mappings:
[    5.431685] IRQ0 -> 0:2
[    5.432005] IRQ1 -> 0:1
[    5.432323] IRQ3 -> 0:3
[    5.432647] IRQ4 -> 0:4
[    5.432968] IRQ5 -> 0:5
[    5.433295] IRQ6 -> 0:6
[    5.433609] IRQ7 -> 0:7
[    5.436918] IRQ8 -> 0:8
[    5.437232] IRQ9 -> 0:9
[    5.437545] IRQ10 -> 0:10
[    5.437869] IRQ11 -> 0:11
[    5.438190] IRQ12 -> 0:12
[    5.438510] IRQ13 -> 0:13
[    5.438839] IRQ14 -> 0:14
[    5.439159] IRQ15 -> 0:15
[    5.439490] IRQ16 -> 0:16
[    5.439829] IRQ17 -> 0:17
[    5.440149] IRQ18 -> 0:18
[    5.440481] IRQ19 -> 0:19
[    5.440809] IRQ20 -> 0:20
[    5.441130] IRQ21 -> 0:21
[    5.441452] IRQ22 -> 0:22
[    5.441780] IRQ23 -> 0:23
[    5.442112] .................................... done.
[    5.443272] PM: Hibernation image not present or could not be loaded.
[    5.443722] registered taskstats version 1
[    5.444044] Running tests on trace events:
[    5.444356] Testing event kfree_skb:
[    5.448728] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.460972] OK
[    5.461197] Testing event consume_skb: OK
[    5.478131] Testing event skb_copy_datagram_iovec:
[    5.485729] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.495203] OK
[    5.495418] Testing event net_dev_xmit:
[    5.501952] ehci_hcd 0000:00:1a.7: port 1 high speed
[    5.502462] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    5.512130] OK
[    5.512357] Testing event net_dev_queue: OK
[    5.529274] Testing event netif_receive_skb: OK
[    5.546141] Testing event netif_rx:
[    5.551186] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    5.551766] ata2.00: applying bridge limits
[    5.562972] OK
[    5.563189] Testing event napi_poll:
[    5.572466] usb 1-1: default language 0x0409
[    5.579341] usb 1-1: udev 2, busnum 1, minor = 1
[    5.579667] usb 1-1: New USB device found, idVendor=0b95, idProduct=1780
[    5.579953] OK
[    5.579955] Testing event sock_rcvqueue_full:
[    5.580496] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.581082] usb 1-1: Product: AX88178
[    5.581383] usb 1-1: Manufacturer: ASIX Elec. Corp.
[    5.581735] usb 1-1: SerialNumber: 000013
[    5.582412] usb 1-1: usb_probe_device
[    5.582422] ata2.00: configured for UDMA/33
[    5.583044] usb 1-1: configuration #1 chosen from 1 choice
[    5.583427] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    5.583969] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.585035] asix 1-1:1.0: usb_probe_interface
[    5.585354] asix 1-1:1.0: usb_probe_interface - got id
[    5.595967] OK
[    5.596183] Testing event sock_exceed_buf_limit: OK
[    5.613119] Testing event udp_fail_queue_rcv_skb: OK
[    5.630796] Testing event hda_send_cmd: OK
[    5.647140] Testing event hda_get_response: OK
[    5.664135] Testing event hda_bus_reset: OK
[    5.681141] Testing event hda_power_down: OK
[    5.698734] Testing event hda_power_up: OK
[    5.715139] Testing event hda_unsol_event: OK
[    5.732140] Testing event scsi_dispatch_cmd_start: OK
[    5.749140] Testing event scsi_dispatch_cmd_error: OK
[    5.767097] Testing event scsi_dispatch_cmd_done: OK
[    5.784142] Testing event scsi_dispatch_cmd_timeout: OK
[    5.801245] Testing event scsi_eh_wakeup: OK
[    5.818273] Testing event i915_gem_object_create: OK
[    5.858405] Testing event i915_gem_object_bind: OK
[    5.892396] Testing event i915_gem_object_unbind:
[    5.895888] ata8: SATA link down (SStatus 0 SControl 300)
[    5.910140] OK
[    5.910355] Testing event i915_gem_object_change_domain: OK
[    5.930316] Testing event i915_gem_object_pwrite: OK
[    5.949306] Testing event i915_gem_object_pread: OK
[    5.966290] Testing event i915_gem_object_fault: OK
[    5.983430] Testing event i915_gem_object_clflush: OK
[    6.000253] Testing event i915_gem_object_destroy: OK
[    6.016322] Testing event i915_gem_evict: OK
[    6.032254] Testing event i915_gem_evict_everything: OK
[    6.048293] Testing event i915_gem_ring_dispatch: OK
[    6.065431] Testing event i915_gem_ring_flush: OK
[    6.085301] Testing event i915_gem_request_add: OK
[    6.102268] Testing event i915_gem_request_complete: OK
[    6.120349] Testing event i915_gem_request_retire: OK
[    6.138246] Testing event i915_gem_request_wait_begin: OK
[    6.154325] Testing event i915_gem_request_wait_end: OK
[    6.171306] Testing event i915_ring_wait_begin: OK
[    6.189323] Testing event i915_ring_wait_end: OK
[    6.207263] Testing event i915_flip_request: OK
[    6.224374] Testing event i915_flip_complete: OK
[    6.242252] Testing event i915_reg_rw: OK
[    6.258348] Testing event drm_vblank_event: OK
[    6.276326] Testing event drm_vblank_event_queued: OK
[    6.293349] Testing event drm_vblank_event_delivered:
[    6.301129] asix 1-1:1.0: eth1: register 'asix' at usb-0000:00:1a.7-1, ASIX AX88178 USB 2.0 Ethernet, 00:23:54:5c:02:83
[    6.302066] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    6.302512] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    6.303009] ehci_hcd 0000:00:1a.7: port 2 low speed --> companion
[    6.310201] OK
[    6.310414] Testing event block_rq_abort: OK
[    6.328295] Testing event block_rq_requeue: OK
[    6.345382] Testing event block_rq_complete:
[    6.353970] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    6.354776] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    6.364116] OK
[    6.364330] Testing event block_rq_insert: OK
[    6.383401] Testing event block_rq_issue: OK
[    6.403424] Testing event block_bio_bounce:
[    6.406233] ehci_hcd 0000:00:1a.7: port 4 high speed
[    6.406729] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.421135] OK
[    6.421349] Testing event block_bio_complete: OK
[    6.438384] Testing event block_bio_backmerge: OK
[    6.455455] Testing event block_bio_frontmerge:
[    6.455871] usb usb5: suspend_rh (auto-stop)
[    6.456366] usb usb6: suspend_rh (auto-stop)
[    6.456693] usb usb7: suspend_rh (auto-stop)
[    6.457032] usb usb8: suspend_rh (auto-stop)
[    6.457370] usb usb4: suspend_rh (auto-stop)
[    6.457960] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[    6.473182] OK
[    6.473395] Testing event block_bio_queue: OK
[    6.491322] Testing event block_getrq: OK
[    6.507243] Testing event block_sleeprq:
[    6.509111] ehci_hcd 0000:00:1a.7: port 4 high speed
[    6.509604] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    6.524175] OK
[    6.524389] Testing event block_plug: OK
[    6.541356] Testing event block_unplug: OK
[    6.558496] Testing event block_split: OK
[    6.575189] Testing event block_bio_remap: OK
[    6.591320] Testing event block_rq_remap: OK
[    6.608362] Testing event btrfs_transaction_commit: OK
[    6.625327] Testing event btrfs_inode_new: OK
[    6.642288] Testing event btrfs_inode_request: OK
[    6.659476] Testing event btrfs_inode_evict: OK
[    6.676307] Testing event btrfs_get_extent: OK
[    6.694310] Testing event btrfs_ordered_extent_add: OK
[    6.712333] Testing event btrfs_ordered_extent_remove: OK
[    6.729336] Testing event btrfs_ordered_extent_start: OK
[    6.746384] Testing event btrfs_ordered_extent_put: OK
[    6.764434] Testing event btrfs_finish_ordered_io: OK
[    6.781347] Testing event __extent_writepage: OK
[    6.799306] Testing event btrfs_writepage_end_io_hook: OK
[    6.815284] Testing event btrfs_sync_file: OK
[    6.831472] Testing event btrfs_sync_fs: OK
[    6.848414] Testing event btrfs_delayed_tree_ref: OK
[    6.865323] Testing event btrfs_delayed_data_ref: OK
[    6.882417] Testing event btrfs_delayed_ref_head: OK
[    6.901346] Testing event btrfs_chunk_alloc: OK
[    6.919485] Testing event btrfs_chunk_free: OK
[    6.936351] Testing event btrfs_cow_block: OK
[    6.954307] Testing event btrfs_reserved_extent_alloc: OK
[    6.971481] Testing event btrfs_reserved_extent_free: OK
[    6.988309] Testing event xfs_attr_list_sf: OK
[    7.005388] Testing event xfs_attr_list_sf_all: OK
[    7.022316] Testing event xfs_attr_list_leaf: OK
[    7.039293] Testing event xfs_attr_list_leaf_end: OK
[    7.056303] Testing event xfs_attr_list_full: OK
[    7.073449] Testing event xfs_attr_list_add: OK
[    7.090455] Testing event xfs_attr_list_wrong_blk: OK
[    7.107322] Testing event xfs_attr_list_notfound: OK
[    7.124478] Testing event xfs_perag_get: OK
[    7.142388] Testing event xfs_perag_get_tag: OK
[    7.160353] Testing event xfs_perag_put: OK
[    7.178320] Testing event xfs_perag_set_reclaim: OK
[    7.196320] Testing event xfs_perag_clear_reclaim: OK
[    7.213338] Testing event xfs_attr_list_node_descend: OK
[    7.230330] Testing event xfs_iext_insert: OK
[    7.247371] Testing event xfs_iext_remove: OK
[    7.265334] Testing event xfs_bmap_pre_update: OK
[    7.281444] Testing event xfs_bmap_post_update: OK
[    7.302237] Testing event xfs_extlist: OK
[    7.318347] Testing event xfs_buf_init: OK
[    7.334342] Testing event xfs_buf_free: OK
[    7.350304] Testing event xfs_buf_hold: OK
[    7.367435] Testing event xfs_buf_rele: OK
[    7.386331] Testing event xfs_buf_iodone: OK
[    7.404348] Testing event xfs_buf_iorequest: OK
[    7.422314] Testing event xfs_buf_bawrite: OK
[    7.438339] Testing event xfs_buf_lock: OK
[    7.454409] Testing event xfs_buf_lock_done: OK
[    7.472448] Testing event xfs_buf_trylock: OK
[    7.489313] Testing event xfs_buf_unlock: OK
[    7.506507] Testing event xfs_buf_iowait:
[    7.511358] usb 1-4: default language 0x0409
[    7.513488] usb 1-4: udev 4, busnum 1, minor = 3
[    7.513962] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[    7.514363] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.514775] usb 1-4: Product: USB Mass Storage Device
[    7.515257] usb 1-4: Manufacturer: Teclast Technology
[    7.515596] usb 1-4: SerialNumber: 0000000000020D
[    7.516385] usb 1-4: usb_probe_device
[    7.516670] usb 1-4: configuration #1 chosen from 1 choice
[    7.517296] usb 1-4: adding 1-4:1.0 (config #1, interface 0)
[    7.517897] usb-storage 1-4:1.0: usb_probe_interface
[    7.518231] usb-storage 1-4:1.0: usb_probe_interface - got id
[    7.518815] scsi9 : usb-storage 1-4:1.0
[    7.519587] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '004'
[    7.520091] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.520444] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.520831] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    7.521192] uhci_hcd 0000:00:1a.0: port 2 portsc 01a3,00
[    7.521546] hub 3-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    7.523156] OK
[    7.523369] Testing event xfs_buf_iowait_done: OK
[    7.540386] Testing event xfs_buf_delwri_queue: OK
[    7.557368] Testing event xfs_buf_delwri_dequeue: OK
[    7.574362] Testing event xfs_buf_delwri_split: OK
[    7.591517] Testing event xfs_buf_get_uncached: OK
[    7.608554] Testing event xfs_bdstrat_shut: OK
[    7.625364] Testing event xfs_buf_item_relse:
[    7.625982] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    7.642169] OK
[    7.642383] Testing event xfs_buf_item_iodone: OK
[    7.660379] Testing event xfs_buf_item_iodone_async:
[    7.677049] hub 3-0:1.0: port 2 not reset yet, waiting 50ms
[    7.677222] OK
[    7.677224] Testing event xfs_buf_error_relse: OK
[    7.694411] Testing event xfs_trans_read_buf_io: OK
[    7.712356] Testing event xfs_trans_read_buf_shut: OK
[    7.729388] Testing event xfs_btree_corrupt: OK
[    7.746368] Testing event xfs_da_btree_corrupt: OK
[    7.763452] Testing event xfs_reset_dqcounts:
[    7.780037] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    7.780216] OK
[    7.780218] Testing event xfs_inode_item_push: OK
[    7.797396] Testing event xfs_buf_find: OK
[    7.813387] Testing event xfs_buf_get: OK
[    7.830382] Testing event xfs_buf_read: OK
[    7.848367] Testing event xfs_buf_ioerror: OK
[    7.864360] Testing event xfs_buf_item_size:
[    7.868059] hub 3-0:1.0: port 2 not reset yet, waiting 50ms
[    7.882190] OK
[    7.882405] Testing event xfs_buf_item_size_stale: OK
[    7.902402] Testing event xfs_buf_item_format: OK
[    7.919364] Testing event xfs_buf_item_format_stale: OK
[    7.936459] Testing event xfs_buf_item_pin: OK
[    7.955548] Testing event xfs_buf_item_unpin: OK
[    7.973369] Testing event xfs_buf_item_unpin_stale: OK
[    7.990424] Testing event xfs_buf_item_trylock: OK
[    8.007362] Testing event xfs_buf_item_unlock: OK
[    8.023374] Testing event xfs_buf_item_unlock_stale:
[    8.036082] usb 3-2: skipped 1 descriptor after interface
[    8.036592] usb 3-2: skipped 1 descriptor after interface
[    8.040240] OK
[    8.040454] Testing event xfs_buf_item_committed:
[    8.043141] usb 3-2: default language 0x0409
[    8.057188] OK
[    8.057402] Testing event xfs_buf_item_push:
[    8.074082] usb 3-2: udev 2, busnum 3, minor = 257
[    8.074211] OK
[    8.074213] Testing event xfs_buf_item_pushbuf:
[    8.075007] usb 3-2: New USB device found, idVendor=0557, idProduct=2220
[    8.075563] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.076127] usb 3-2: Product: ATEN  CS-1758/54
[    8.076445] usb 3-2: Manufacturer: ATEN
[    8.077128] usb 3-2: usb_probe_device
[    8.077415] usb 3-2: configuration #1 chosen from 1 choice
[    8.080157] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    8.091227] OK
[    8.091441] Testing event xfs_trans_get_buf: OK
[    8.108378] Testing event xfs_trans_get_buf_recur:
[    8.118505] usbserial_generic 3-2:1.0: usb_probe_interface
[    8.119163] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    8.119578] usbhid 3-2:1.0: usb_probe_interface
[    8.120052] usbhid 3-2:1.0: usb_probe_interface - got id
[    8.125102] OK
[    8.125316] Testing event xfs_trans_getsb: OK
[    8.142470] Testing event xfs_trans_getsb_recur:
[    8.151715] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input4
[    8.152547] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    8.153440] generic-usb 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input0
[    8.154279] usb 3-2: adding 3-2:1.1 (config #1, interface 1)
[    8.161348] OK
[    8.161562] Testing event xfs_trans_read_buf:
[    8.164336] usbserial_generic 3-2:1.1: usb_probe_interface
[    8.164952] usbserial_generic 3-2:1.1: usb_probe_interface - got id
[    8.165353] usbhid 3-2:1.1: usb_probe_interface
[    8.165672] usbhid 3-2:1.1: usb_probe_interface - got id
[    8.178256] OK
[    8.178470] Testing event xfs_trans_read_buf_recur:
[    8.196581] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input5
[    8.197727] OK
[    8.197739] generic-usb 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-2/input1
[    8.197762] /c/wfg/linux-next/drivers/usb/core/inode.c: creating file '002'
[    8.197787] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.197789] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    8.199758] Testing event xfs_trans_log_buf: OK
[    8.216396] Testing event xfs_trans_brelse: OK
[    8.233433] Testing event xfs_trans_bjoin: OK
[    8.251385] Testing event xfs_trans_bhold: OK
[    8.268249] Testing event xfs_trans_bhold_release: OK
[    8.285389] Testing event xfs_trans_binval: OK
[    8.303380] Testing event xfs_ilock: OK
[    8.320391] Testing event xfs_ilock_nowait: OK
[    8.338381] Testing event xfs_ilock_demote: OK
[    8.354395] Testing event xfs_iunlock: OK
[    8.371431] Testing event xfs_iget_skip: OK
[    8.388432] Testing event xfs_iget_reclaim: OK
[    8.407407] Testing event xfs_iget_reclaim_fail: OK
[    8.424451] Testing event xfs_iget_hit: OK
[    8.441418] Testing event xfs_iget_miss: OK
[    8.458432] Testing event xfs_getattr: OK
[    8.475399] Testing event xfs_setattr: OK
[    8.492410] Testing event xfs_readlink: OK
[    8.509457] Testing event xfs_alloc_file_space:
[    8.520228] scsi 9:0:0:0: Direct-Access     Teclast  CoolFlash        0.00 PQ: 0 ANSI: 2
[    8.521048] scsi: killing requests for dead queue
[    8.521511] scsi: killing requests for dead queue
[    8.521995] scsi: killing requests for dead queue
[    8.522447] scsi: killing requests for dead queue
[    8.522991] scsi: killing requests for dead queue
[    8.523439] scsi: killing requests for dead queue
[    8.523988] scsi: killing requests for dead queue
[    8.525153] scsi_scan_9 used greatest stack depth: 5104 bytes left
[    8.526032] OK
[    8.526244] Testing event xfs_free_file_space:
[    8.526263] sd 9:0:0:0: [sdb] 63084544 512-byte logical blocks: (32.2 GB/30.0 GiB)
[    8.526900] sd 9:0:0:0: [sdb] Write Protect is off
[    8.526902] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    8.527461] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.527463] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.531588] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.531975] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.545143] OK
[    8.545353] Testing event xfs_readdir: OK
[    8.561237] Testing event xfs_get_acl: OK
[    8.577312] Testing event xfs_vm_bmap: OK
[    8.593314] Testing event xfs_file_ioctl: OK
[    8.609327] Testing event xfs_file_compat_ioctl: OK
[    8.625316] Testing event xfs_ioctl_setattr: OK
[    8.641248] Testing event xfs_dir_fsync: OK
[    8.657299] Testing event xfs_file_fsync:
[    8.666221]  sdb: sdb1 sdb2 sdb3
[    8.670223] sd 9:0:0:0: [sdb] Asking for cache data failed
[    8.670575] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[    8.670961] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[    8.673098] OK
[    8.673308] Testing event xfs_destroy_inode: OK
[    8.689434] Testing event xfs_write_inode: OK
[    8.706422] Testing event xfs_evict_inode: OK
[    8.722469] Testing event xfs_dquot_dqalloc: OK
[    8.739413] Testing event xfs_dquot_dqdetach: OK
[    8.759498] Testing event xfs_ihold: OK
[    8.777438] Testing event xfs_irele: OK
[    8.794406] Testing event xfs_inode_pin: OK
[    8.810438] Testing event xfs_inode_unpin: OK
[    8.827523] Testing event xfs_inode_unpin_nowait: OK
[    8.845439] Testing event xfs_remove: OK
[    8.862428] Testing event xfs_link: OK
[    8.879485] Testing event xfs_lookup: OK
[    8.897431] Testing event xfs_create: OK
[    8.914421] Testing event xfs_symlink: OK
[    8.931487] Testing event xfs_rename: OK
[    8.948377] Testing event xfs_dqadjust: OK
[    8.965407] Testing event xfs_dqreclaim_want: OK
[    8.983415] Testing event xfs_dqreclaim_dirty: OK
[    9.000427] Testing event xfs_dqreclaim_unlink: OK
[    9.017519] Testing event xfs_dqattach_found: OK
[    9.034430] Testing event xfs_dqattach_get: OK
[    9.052391] Testing event xfs_dqinit: OK
[    9.068411] Testing event xfs_dqreuse: OK
[    9.086413] Testing event xfs_dqalloc: OK
[    9.104419] Testing event xfs_dqtobp_read: OK
[    9.121416] Testing event xfs_dqread: OK
[    9.138416] Testing event xfs_dqread_fail: OK
[    9.155420] Testing event xfs_dqlookup_found: OK
[    9.172517] Testing event xfs_dqlookup_want: OK
[    9.189473] Testing event xfs_dqlookup_freelist: OK
[    9.206460] Testing event xfs_dqlookup_done: OK
[    9.223410] Testing event xfs_dqget_hit: OK
[    9.239444] Testing event xfs_dqget_miss: OK
[    9.256427] Testing event xfs_dqput: OK
[    9.272424] Testing event xfs_dqput_wait: OK
[    9.289414] Testing event xfs_dqput_free: OK
[    9.305441] Testing event xfs_dqrele: OK
[    9.322453] Testing event xfs_dqflush: OK
[    9.339423] Testing event xfs_dqflush_force: OK
[    9.356424] Testing event xfs_dqflush_done: OK
[    9.373451] Testing event xfs_log_done_nonperm: OK
[    9.392483] Testing event xfs_log_done_perm: OK
[    9.409482] Testing event xfs_log_reserve: OK
[    9.426503] Testing event xfs_log_umount_write: OK
[    9.443430] Testing event xfs_log_grant_enter: OK
[    9.460445] Testing event xfs_log_grant_exit: OK
[    9.477379] Testing event xfs_log_grant_error: OK
[    9.494426] Testing event xfs_log_grant_sleep1: OK
[    9.512478] Testing event xfs_log_grant_wake1: OK
[    9.530434] Testing event xfs_log_grant_sleep2: OK
[    9.548494] Testing event xfs_log_grant_wake2: OK
[    9.566446] Testing event xfs_log_grant_wake_up: OK
[    9.583305] Testing event xfs_log_regrant_write_enter: OK
[    9.600441] Testing event xfs_log_regrant_write_exit: OK
[    9.617573] Testing event xfs_log_regrant_write_error: OK
[    9.635445] Testing event xfs_log_regrant_write_sleep1: OK
[    9.653507] Testing event xfs_log_regrant_write_wake1: OK
[    9.671522] Testing event xfs_log_regrant_write_sleep2: OK
[    9.688521] Testing event xfs_log_regrant_write_wake2: OK
[    9.705443] Testing event xfs_log_regrant_write_wake_up: OK
[    9.722456] Testing event xfs_log_regrant_reserve_enter: OK
[    9.739457] Testing event xfs_log_regrant_reserve_exit: OK
[    9.756434] Testing event xfs_log_regrant_reserve_sub: OK
[    9.775583] Testing event xfs_log_ungrant_enter: OK
[    9.794425] Testing event xfs_log_ungrant_exit: OK
[    9.811533] Testing event xfs_log_ungrant_sub: OK
[    9.828522] Testing event xfs_ail_push: OK
[    9.847515] Testing event xfs_ail_pushbuf: OK
[    9.866480] Testing event xfs_ail_pushbuf_pinned: OK
[    9.884483] Testing event xfs_ail_pinned: OK
[    9.901465] Testing event xfs_ail_locked: OK
[    9.918438] Testing event xfs_file_read: OK
[    9.936470] Testing event xfs_file_buffered_write: OK
[    9.955485] Testing event xfs_file_direct_write: OK
[    9.973447] Testing event xfs_file_splice_read: OK
[    9.990450] Testing event xfs_file_splice_write: OK
[   10.008390] Testing event xfs_writepage: OK
[   10.024452] Testing event xfs_releasepage: OK
[   10.042455] Testing event xfs_invalidatepage: OK
[   10.060538] Testing event xfs_map_blocks_found: OK
[   10.078412] Testing event xfs_map_blocks_alloc: OK
[   10.095548] Testing event xfs_get_blocks_found: OK
[   10.112420] Testing event xfs_get_blocks_alloc: OK
[   10.129404] Testing event xfs_delalloc_enospc: OK
[   10.145457] Testing event xfs_unwritten_convert: OK
[   10.163458] Testing event xfs_get_blocks_notfound: OK
[   10.181450] Testing event xfs_setfilesize: OK
[   10.197463] Testing event xfs_itruncate_data_start: OK
[   10.214516] Testing event xfs_itruncate_data_end: OK
[   10.232456] Testing event xfs_pagecache_inval: OK
[   10.249495] Testing event xfs_bunmap: OK
[   10.266458] Testing event xfs_alloc_busy: OK
[   10.283515] Testing event xfs_alloc_busy_enomem: OK
[   10.300476] Testing event xfs_alloc_busy_force: OK
[   10.317621] Testing event xfs_alloc_busy_reuse: OK
[   10.334487] Testing event xfs_alloc_busy_clear: OK
[   10.351489] Testing event xfs_alloc_busy_trim: OK
[   10.368461] Testing event xfs_trans_commit_lsn: OK
[   10.386497] Testing event xfs_agf: OK
[   10.404479] Testing event xfs_free_extent: OK
[   10.421463] Testing event xfs_alloc_exact_done: OK
[   10.438451] Testing event xfs_alloc_exact_notfound: OK
[   10.456492] Testing event xfs_alloc_exact_error: OK
[   10.474503] Testing event xfs_alloc_near_nominleft: OK
[   10.491513] Testing event xfs_alloc_near_first: OK
[   10.508543] Testing event xfs_alloc_near_greater: OK
[   10.526510] Testing event xfs_alloc_near_lesser: OK
[   10.544549] Testing event xfs_alloc_near_error: OK
[   10.561531] Testing event xfs_alloc_near_noentry: OK
[   10.578532] Testing event xfs_alloc_near_busy: OK
[   10.596486] Testing event xfs_alloc_size_neither: OK
[   10.614482] Testing event xfs_alloc_size_noentry: OK
[   10.631490] Testing event xfs_alloc_size_nominleft: OK
[   10.648494] Testing event xfs_alloc_size_done: OK
[   10.665520] Testing event xfs_alloc_size_error: OK
[   10.683470] Testing event xfs_alloc_size_busy: OK
[   10.700466] Testing event xfs_alloc_small_freelist: OK
[   10.717484] Testing event xfs_alloc_small_notenough: OK
[   10.735578] Testing event xfs_alloc_small_done: OK
[   10.753461] Testing event xfs_alloc_small_error: OK
[   10.770520] Testing event xfs_alloc_vextent_badargs: OK
[   10.787469] Testing event xfs_alloc_vextent_nofix: OK
[   10.804503] Testing event xfs_alloc_vextent_noagbp: OK
[   10.822538] Testing event xfs_alloc_vextent_loopfailed: OK
[   10.839533] Testing event xfs_alloc_vextent_allfailed: OK
[   10.856520] Testing event xfs_dir2_sf_addname: OK
[   10.873577] Testing event xfs_dir2_sf_create: OK
[   10.890326] Testing event xfs_dir2_sf_lookup: OK
[   10.907328] Testing event xfs_dir2_sf_replace: OK
[   10.924519] Testing event xfs_dir2_sf_removename: OK
[   10.941317] Testing event xfs_dir2_sf_toino4: OK
[   10.958328] Testing event xfs_dir2_sf_toino8: OK
[   10.975454] Testing event xfs_dir2_sf_to_block: OK
[   10.992524] Testing event xfs_dir2_block_addname: OK
[   11.010030] Testing event xfs_dir2_block_lookup: OK
[   11.026341] Testing event xfs_dir2_block_replace: OK
[   11.043402] Testing event xfs_dir2_block_removename: OK
[   11.060331] Testing event xfs_dir2_block_to_sf: OK
[   11.077327] Testing event xfs_dir2_block_to_leaf: OK
[   11.095093] Testing event xfs_dir2_leaf_addname: OK
[   11.111331] Testing event xfs_dir2_leaf_lookup: OK
[   11.128335] Testing event xfs_dir2_leaf_replace: OK
[   11.145586] Testing event xfs_dir2_leaf_removename: OK
[   11.163225] Testing event xfs_dir2_leaf_to_block: OK
[   11.180317] Testing event xfs_dir2_leaf_to_node: OK
[   11.198283] Testing event xfs_dir2_node_addname: OK
[   11.215381] Testing event xfs_dir2_node_lookup: OK
[   11.232724] Testing event xfs_dir2_node_replace: OK
[   11.249337] Testing event xfs_dir2_node_removename: OK
[   11.266844] Testing event xfs_dir2_node_to_leaf: OK
[   11.283334] Testing event xfs_dir2_leafn_add: OK
[   11.300398] Testing event xfs_dir2_leafn_remove: OK
[   11.359328] Testing event xfs_dir2_grow_inode: OK
[   11.376324] Testing event xfs_dir2_shrink_inode: OK
[   11.393976] Testing event xfs_dir2_leafn_moveents: OK
[   11.410321] Testing event xfs_swap_extent_before: OK
[   11.427451] Testing event xfs_swap_extent_after: OK
[   11.444327] Testing event xfs_log_recover_item_add: OK
[   11.461354] Testing event xfs_log_recover_item_add_cont: OK
[   11.478345] Testing event xfs_log_recover_item_reorder_head: OK
[   11.495736] Testing event xfs_log_recover_item_reorder_tail: OK
[   11.512361] Testing event xfs_log_recover_item_recover: OK
[   11.561347] Testing event xfs_log_recover_buf_not_cancel: OK
[   11.578374] Testing event xfs_log_recover_buf_cancel: OK
[   11.595349] Testing event xfs_log_recover_buf_cancel_add: OK
[   11.612354] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   11.629452] Testing event xfs_log_recover_buf_recover: OK
[   11.646344] Testing event xfs_log_recover_buf_inode_buf: OK
[   11.663334] Testing event xfs_log_recover_buf_reg_buf: OK
[   11.680335] Testing event xfs_log_recover_buf_dquot_buf: OK
[   11.697370] Testing event xfs_log_recover_inode_recover: OK
[   11.714814] Testing event xfs_log_recover_inode_cancel: OK
[   11.731353] Testing event xfs_log_recover_inode_skip: OK
[   11.748353] Testing event xfs_discard_extent: OK
[   11.765356] Testing event xfs_discard_toosmall: OK
[   11.782355] Testing event xfs_discard_exclude: OK
[   11.799546] Testing event xfs_discard_busy: OK
[   11.816426] Testing event jbd2_checkpoint: OK
[   11.833361] Testing event jbd2_start_commit: OK
[   11.850517] Testing event jbd2_commit_locking: OK
[   11.867366] Testing event jbd2_commit_flushing: OK
[   11.884358] Testing event jbd2_commit_logging: OK
[   11.901361] Testing event jbd2_end_commit: OK
[   11.918360] Testing event jbd2_submit_inode_data: OK
[   11.938360] Testing event jbd2_run_stats: OK
[   11.955360] Testing event jbd2_checkpoint_stats: OK
[   11.972341] Testing event jbd2_cleanup_journal_tail: OK
[   11.989363] Testing event jbd_checkpoint: OK
[   12.006370] Testing event jbd_start_commit: OK
[   12.023411] Testing event jbd_commit_locking: OK
[   12.040467] Testing event jbd_commit_flushing: OK
[   12.057373] Testing event jbd_commit_logging: OK
[   12.074650] Testing event jbd_drop_transaction: OK
[   12.091359] Testing event jbd_end_commit: OK
[   12.108360] Testing event jbd_do_submit_data: OK
[   12.174574] Testing event jbd_cleanup_journal_tail: OK
[   12.239491] Testing event jbd_update_superblock_end: OK
[   12.256378] Testing event ext4_free_inode: OK
[   12.322375] Testing event ext4_request_inode: OK
[   12.365500] Testing event ext4_allocate_inode: OK
[   12.382801] Testing event ext4_evict_inode: OK
[   12.399378] Testing event ext4_drop_inode: OK
[   12.417273] Testing event ext4_mark_inode_dirty: OK
[   12.433869] Testing event ext4_begin_ordered_truncate: OK
[   12.450377] Testing event ext4_write_begin: OK
[   12.468205] Testing event ext4_da_write_begin: OK
[   12.484381] Testing event ext4_ordered_write_end: OK
[   12.501391] Testing event ext4_writeback_write_end: OK
[   12.558647] Testing event ext4_journalled_write_end: OK
[   12.575451] Testing event ext4_da_write_end: OK
[   12.592389] Testing event ext4_da_writepages: OK
[   12.609581] Testing event ext4_da_write_pages: OK
[   12.626398] Testing event ext4_da_writepages_result: OK
[   12.643383] Testing event ext4_writepage: OK
[   12.660692] Testing event ext4_readpage: OK
[   12.677388] Testing event ext4_releasepage: OK
[   12.694395] Testing event ext4_invalidatepage: OK
[   12.712386] Testing event ext4_discard_blocks: OK
[   12.729390] Testing event ext4_mb_new_inode_pa: OK
[   12.746388] Testing event ext4_mb_new_group_pa: OK
[   12.763395] Testing event ext4_mb_release_inode_pa: OK
[   12.781880] Testing event ext4_mb_release_group_pa: OK
[   12.798388] Testing event ext4_discard_preallocations: OK
[   12.815398] Testing event ext4_mb_discard_preallocations: OK
[   12.866392] Testing event ext4_request_blocks: OK
[   12.883393] Testing event ext4_allocate_blocks: OK
[   12.900398] Testing event ext4_free_blocks: OK
[   12.917399] Testing event ext4_sync_file_enter: OK
[   12.934397] Testing event ext4_sync_file_exit: OK
[   12.952931] Testing event ext4_sync_fs: OK
[   12.969401] Testing event ext4_alloc_da_blocks: OK
[   12.986394] Testing event ext4_mballoc_alloc: OK
[   13.003397] Testing event ext4_mballoc_prealloc: OK
[   13.020397] Testing event ext4_mballoc_discard: OK
[   13.037399] Testing event ext4_mballoc_free: OK
[   13.054403] Testing event ext4_forget: OK
[   13.071400] Testing event ext4_da_update_reserve_space: OK
[   13.088398] Testing event ext4_da_reserve_space: OK
[   13.105407] Testing event ext4_da_release_space: OK
[   13.123402] Testing event ext4_mb_bitmap_load: OK
[   13.140643] Testing event ext4_mb_buddy_bitmap_load: OK
[   13.157422] Testing event ext4_read_block_bitmap_load: OK
[   13.206420] Testing event ext4_load_inode_bitmap: OK
[   13.223407] Testing event ext4_direct_IO_enter: OK
[   13.240403] Testing event ext4_direct_IO_exit: OK
[   13.298407] Testing event ext4_fallocate_enter: OK
[   13.315414] Testing event ext4_fallocate_exit: OK
[   13.332411] Testing event ext4_unlink_enter: OK
[   13.349563] Testing event ext4_unlink_exit: OK
[   13.366422] Testing event ext4_truncate_enter: OK
[   13.383614] Testing event ext4_truncate_exit: OK
[   13.400410] Testing event ext4_ext_map_blocks_enter: OK
[   13.417416] Testing event ext4_ind_map_blocks_enter: OK
[   13.434413] Testing event ext4_ext_map_blocks_exit: OK
[   13.451412] Testing event ext4_ind_map_blocks_exit: OK
[   13.468417] Testing event ext4_ext_load_extent: OK
[   13.485420] Testing event ext4_load_inode: OK
[   13.502415] Testing event ext4_journal_start: OK
[   13.519696] Testing event ext4_trim_extent: OK
[   13.536417] Testing event ext4_trim_all_free: OK
[   13.553445] Testing event ext4_ext_handle_uninitialized_extents: OK
[   13.570903] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   13.587423] Testing event ext4_ext_put_in_cache: OK
[   13.604419] Testing event ext4_ext_in_cache: OK
[   13.621420] Testing event ext4_find_delalloc_range: OK
[   13.638418] Testing event ext4_get_reserved_cluster_alloc: OK
[   13.704420] Testing event ext4_ext_show_extent: OK
[   13.721432] Testing event ext4_remove_blocks: OK
[   13.738422] Testing event ext4_ext_rm_leaf: OK
[   13.755411] Testing event ext4_ext_rm_idx: OK
[   13.772423] Testing event ext4_ext_remove_space: OK
[   13.789440] Testing event ext4_ext_remove_space_done: OK
[   13.806426] Testing event ext3_free_inode: OK
[   13.823428] Testing event ext3_request_inode: OK
[   13.840506] Testing event ext3_allocate_inode: OK
[   13.857734] Testing event ext3_evict_inode: OK
[   13.874436] Testing event ext3_drop_inode: OK
[   13.891431] Testing event ext3_mark_inode_dirty: OK
[   13.908431] Testing event ext3_write_begin: OK
[   13.926429] Testing event ext3_ordered_write_end: OK
[   13.944219] Testing event ext3_writeback_write_end: OK
[   13.961432] Testing event ext3_journalled_write_end: OK
[   13.978436] Testing event ext3_ordered_writepage: OK
[   13.995704] Testing event ext3_writeback_writepage: OK
[   14.012635] Testing event ext3_journalled_writepage: OK
[   14.029434] Testing event ext3_readpage: OK
[   14.046443] Testing event ext3_releasepage: OK
[   14.063442] Testing event ext3_invalidatepage: OK
[   14.080434] Testing event ext3_discard_blocks: OK
[   14.097448] Testing event ext3_request_blocks: OK
[   14.114437] Testing event ext3_allocate_blocks: OK
[   14.131443] Testing event ext3_free_blocks: OK
[   14.148451] Testing event ext3_sync_file_enter: OK
[   14.166135] Testing event ext3_sync_file_exit: OK
[   14.182451] Testing event ext3_sync_fs: OK
[   14.232443] Testing event ext3_rsv_window_add: OK
[   14.249445] Testing event ext3_discard_reservation: OK
[   14.266448] Testing event ext3_alloc_new_reservation: OK
[   14.283441] Testing event ext3_reserved: OK
[   14.300442] Testing event ext3_forget: OK
[   14.317442] Testing event ext3_read_block_bitmap: OK
[   14.334451] Testing event ext3_direct_IO_enter: OK
[   14.351450] Testing event ext3_direct_IO_exit: OK
[   14.368443] Testing event ext3_unlink_enter: OK
[   14.385453] Testing event ext3_unlink_exit: OK
[   14.402444] Testing event ext3_truncate_enter: OK
[   14.419446] Testing event ext3_truncate_exit: OK
[   14.436456] Testing event ext3_get_blocks_enter: OK
[   14.454464] Testing event ext3_get_blocks_exit: OK
[   14.473152] Testing event ext3_load_inode: OK
[   14.489453] Testing event writeback_nothread: OK
[   14.507452] Testing event writeback_queue: OK
[   14.524462] Testing event writeback_exec: OK
[   14.541459] Testing event writeback_start: OK
[   14.558450] Testing event writeback_written: OK
[   14.575449] Testing event writeback_wait: OK
[   14.592451] Testing event writeback_pages_written: OK
[   14.609451] Testing event writeback_nowork: OK
[   14.626566] Testing event writeback_wake_background: OK
[   14.643457] Testing event writeback_wake_thread: OK
[   14.660457] Testing event writeback_wake_forker_thread: OK
[   14.677441] Testing event writeback_bdi_register: OK
[   14.694574] Testing event writeback_bdi_unregister: OK
[   14.711469] Testing event writeback_thread_start: OK
[   14.728466] Testing event writeback_thread_stop: OK
[   14.745455] Testing event wbc_writepage: OK
[   14.763112] Testing event writeback_queue_io: OK
[   14.779458] Testing event task_io: OK
[   14.844463] Testing event global_dirty_state: OK
[   14.861476] Testing event bdi_dirty_state: OK
[   14.928596] Testing event blkcg_dirty_ratelimit: OK
[   14.945466] Testing event bdi_dirty_ratelimit: OK
[   14.962465] Testing event balance_dirty_pages: OK
[   14.979470] Testing event writeback_congestion_wait: OK
[   14.996473] Testing event writeback_wait_iff_congested: OK
[   15.058469] Testing event writeback_single_inode_requeue: OK
[   15.076301] Testing event writeback_single_inode: OK
[   15.093491] Testing event kmalloc: OK
[   15.110481] Testing event kmem_cache_alloc: OK
[   15.127471] Testing event kmalloc_node: OK
[   15.144469] Testing event kmem_cache_alloc_node: OK
[   15.162474] Testing event kfree: OK
[   15.180093] Testing event kmem_cache_free: OK
[   15.196474] Testing event mm_page_free_direct: OK
[   15.213474] Testing event mm_pagevec_free: OK
[   15.230475] Testing event mm_page_alloc: OK
[   15.247483] Testing event mm_page_alloc_zone_locked: OK
[   15.264628] Testing event mm_page_pcpu_drain: OK
[   15.281479] Testing event mm_page_alloc_extfrag: OK
[   15.298470] Testing event mm_vmscan_kswapd_sleep: OK
[   15.315482] Testing event mm_vmscan_kswapd_wake: OK
[   15.332486] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.349481] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.366487] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.383473] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.400484] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.417484] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.435487] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.453073] Testing event mm_shrink_slab_start: OK
[   15.469492] Testing event mm_shrink_slab_end: OK
[   15.486484] Testing event mm_vmscan_lru_isolate: OK
[   15.503502] Testing event mm_vmscan_memcg_isolate: OK
[   15.521493] Testing event mm_vmscan_writepage: OK
[   15.538485] Testing event mm_vmscan_lru_shrink_inactive: OK
[   15.558484] Testing event replace_swap_token: OK
[   15.575495] Testing event put_swap_token: OK
[   15.592491] Testing event disable_swap_token: OK
[   15.609527] Testing event update_swap_token_priority: OK
[   15.626872] Testing event cpu_idle: OK
[   15.643489] Testing event cpu_frequency: OK
[   15.661490] Testing event machine_suspend: OK
[   15.678499] Testing event power_start: OK
[   15.695493] Testing event power_frequency: OK
[   15.712494] Testing event power_end: OK
[   15.729783] Testing event clock_enable: OK
[   15.746493] Testing event clock_disable: OK
[   15.763492] Testing event clock_set_rate: OK
[   15.780498] Testing event power_domain_target: OK
[   15.798568] Testing event ftrace_test_filter: OK
[   15.815497] Testing event module_load: OK
[   15.832499] Testing event module_free: OK
[   15.849499] Testing event module_get: OK
[   15.866495] Testing event module_put: OK
[   15.884663] Testing event module_request: OK
[   15.901743] Testing event lock_acquire: OK
[   15.918694] Testing event lock_release: OK
[   15.935679] Testing event lock_contended: OK
[   15.952648] Testing event lock_acquired: OK
[   15.969673] Testing event rcu_utilization: OK
[   15.986675] Testing event rcu_grace_period: OK
[   16.003657] Testing event rcu_grace_period_init: OK
[   16.020657] Testing event rcu_preempt_task: OK
[   16.037614] Testing event rcu_unlock_preempted_task: OK
[   16.054681] Testing event rcu_quiescent_state_report: OK
[   16.071700] Testing event rcu_fqs: OK
[   16.088655] Testing event rcu_dyntick: OK
[   16.104663] Testing event rcu_callback: OK
[   16.122678] Testing event rcu_kfree_callback: OK
[   16.139740] Testing event rcu_batch_start: OK
[   16.156744] Testing event rcu_invoke_callback: OK
[   16.174656] Testing event rcu_invoke_kfree_callback: OK
[   16.191684] Testing event rcu_batch_end: OK
[   16.208703] Testing event rcu_torture_read: OK
[   16.225779] Testing event workqueue_queue_work: OK
[   16.243787] Testing event workqueue_activate_work: OK
[   16.260674] Testing event workqueue_execute_start: OK
[   16.278749] Testing event workqueue_execute_end: OK
[   16.295797] Testing event signal_generate: OK
[   16.313650] Testing event signal_deliver: OK
[   16.330673] Testing event signal_overflow_fail: OK
[   16.348681] Testing event signal_lose_info: OK
[   16.366684] Testing event timer_init: OK
[   16.382644] Testing event timer_start: OK
[   16.399674] Testing event timer_expire_entry: OK
[   16.417682] Testing event timer_expire_exit: OK
[   16.434687] Testing event timer_cancel: OK
[   16.451839] Testing event hrtimer_init: OK
[   16.469879] Testing event hrtimer_start: OK
[   16.487773] Testing event hrtimer_expire_entry: OK
[   16.505707] Testing event hrtimer_expire_exit: OK
[   16.523700] Testing event hrtimer_cancel: OK
[   16.540703] Testing event itimer_state: OK
[   16.557703] Testing event itimer_expire: OK
[   16.574675] Testing event irq_handler_entry: OK
[   16.591699] Testing event irq_handler_exit: OK
[   16.608714] Testing event softirq_entry: OK
[   16.625747] Testing event softirq_exit: OK
[   16.643717] Testing event softirq_raise: OK
[   16.660809] Testing event sched_kthread_stop: OK
[   16.678678] Testing event sched_kthread_stop_ret: OK
[   16.695700] Testing event sched_wakeup: OK
[   16.713770] Testing event sched_wakeup_new: OK
[   16.730729] Testing event sched_switch: OK
[   16.747691] Testing event sched_migrate_task: OK
[   16.765763] Testing event sched_process_free: OK
[   16.782719] Testing event sched_process_exit: OK
[   16.799698] Testing event sched_wait_task: OK
[   16.817688] Testing event sched_process_wait: OK
[   16.834703] Testing event sched_process_fork: OK
[   16.852668] Testing event sched_stat_wait: OK
[   16.869691] Testing event sched_stat_sleep: OK
[   16.886710] Testing event sched_stat_iowait: OK
[   16.903808] Testing event sched_stat_runtime: OK
[   16.920742] Testing event sched_pi_setprio: OK
[   16.937807] Testing event mce_record: OK
[   16.954661] Testing event sys_enter: OK
[   16.971751] Testing event sys_exit: OK
[   16.988762] Testing event emulate_vsyscall: OK
[   17.007747] Testing event kvm_mmu_pagetable_walk: OK
[   17.025794] Testing event kvm_mmu_paging_element: OK
[   17.043704] Testing event kvm_mmu_set_accessed_bit: OK
[   17.060690] Testing event kvm_mmu_set_dirty_bit: OK
[   17.077698] Testing event kvm_mmu_walker_error: OK
[   17.094696] Testing event kvm_mmu_get_page: OK
[   17.112744] Testing event kvm_mmu_sync_page: OK
[   17.130728] Testing event kvm_mmu_unsync_page: OK
[   17.148764] Testing event kvm_mmu_prepare_zap_page: OK
[   17.166784] Testing event kvm_mmu_delay_free_pages: OK
[   17.183709] Testing event mark_mmio_spte: OK
[   17.200704] Testing event handle_mmio_page_fault: OK
[   17.218721] Testing event kvm_mmu_audit: OK
[   17.235774] Testing event kvm_entry: OK
[   17.253708] Testing event kvm_hypercall: OK
[   17.269776] Testing event kvm_hv_hypercall: OK
[   17.286672] Testing event kvm_pio: OK
[   17.304772] Testing event kvm_cpuid: OK
[   17.321708] Testing event kvm_apic: OK
[   17.339737] Testing event kvm_exit: OK
[   17.357706] Testing event kvm_inj_virq: OK
[   17.373791] Testing event kvm_inj_exception: OK
[   17.390684] Testing event kvm_page_fault: OK
[   17.406741] Testing event kvm_msr: OK
[   17.423712] Testing event kvm_cr: OK
[   17.440712] Testing event kvm_pic_set_irq: OK
[   17.457706] Testing event kvm_apic_ipi: OK
[   17.473727] Testing event kvm_apic_accept_irq: OK
[   17.490726] Testing event kvm_nested_vmrun: OK
[   17.507733] Testing event kvm_nested_intercepts: OK
[   17.525728] Testing event kvm_nested_vmexit: OK
[   17.542718] Testing event kvm_nested_vmexit_inject: OK
[   17.561752] Testing event kvm_nested_intr_vmexit: OK
[   17.579759] Testing event kvm_invlpga: OK
[   17.597749] Testing event kvm_skinit: OK
[   17.616721] Testing event kvm_emulate_insn: OK
[   17.633809] Testing event vcpu_match_mmio: OK
[   17.651720] Testing event kvm_userspace_exit: OK
[   17.670728] Testing event kvm_set_irq: OK
[   17.687724] Testing event kvm_ioapic_set_irq: OK
[   17.704769] Testing event kvm_msi_set_irq: OK
[   17.721815] Testing event kvm_ack_irq: OK
[   17.738722] Testing event kvm_mmio: OK
[   17.756716] Testing event kvm_fpu: OK
[   17.774744] Testing event kvm_age_page: OK
[   17.791838] Testing event kvm_try_async_get_page: OK
[   17.808722] Testing event kvm_async_pf_doublefault: OK
[   17.825739] Testing event kvm_async_pf_not_present: OK
[   17.842767] Testing event kvm_async_pf_ready: OK
[   17.859751] Testing event kvm_async_pf_completed: OK
[   17.876759] Running tests on trace event systems:
[   17.877084] Testing event system skb: OK
[   17.894909] Testing event system net: OK
[   17.912000] Testing event system napi: OK
[   17.929745] Testing event system sock: OK
[   17.946788] Testing event system udp: OK
[   17.964790] Testing event system hda: OK
[   17.982957] Testing event system scsi: OK
[   18.000899] Testing event system i915: OK
[   18.020708] Testing event system drm: OK
[   18.037839] Testing event system block: OK
[   18.056391] Testing event system btrfs: OK
[   18.074638] Testing event system xfs: OK
[   18.126255] Testing event system jbd2: OK
[   18.144231] Testing event system jbd: OK
[   18.161205] Testing event system ext4: OK
[   18.187354] Testing event system ext3: OK
[   18.208666] Testing event system writeback: OK
[   18.228008] Testing event system kmem: OK
[   18.247135] Testing event system vmscan: OK
[   18.266609] Testing event system power: OK
[   18.285109] Testing event system test: OK
[   18.302799] Testing event system module: OK
[   18.319899] Testing event system lock: OK
[   18.337960] Testing event system rcu: OK
[   18.355375] Testing event system workqueue: OK
[   18.372024] Testing event system signal: OK
[   18.388845] Testing event system timer: OK
[   18.406266] Testing event system irq: OK
[   18.422933] Testing event system sched: OK
[   18.440392] Testing event system mce: OK
[   18.456781] Testing event system raw_syscalls: OK
[   18.473928] Testing event system vsyscall: OK
[   18.490799] Testing event system syscalls: OK
[   18.509252] Testing event system kvmmmu: OK
[   18.528239] Testing event system kvm: OK
[   18.548148] Running tests on all trace events:
[   18.548475] Testing all events: OK
[   18.681149] ------------[ cut here ]------------
[   18.681485] WARNING: at /c/wfg/linux-next/kernel/trace/trace_events.c:1721 event_trace_self_tests_init+0x33/0x66()
[   18.682137] Hardware name:
[   18.682427] Modules linked in:
[   18.682726] Pid: 1, comm: swapper/0 Tainted: G        W   3.1.0-ioless-full-bg-all-next-20111025+ #886
[   18.683382] Call Trace:
[   18.686595]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
[   18.686969]  [<ffffffff821320ff>] ? test_work+0x64/0x64
[   18.687356]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
[   18.687727]  [<ffffffff82132132>] event_trace_self_tests_init+0x33/0x66
[   18.688124]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
[   18.688501]  [<ffffffff82116c16>] kernel_init+0xcb/0x14f
[   18.688850]  [<ffffffff8198ee44>] kernel_thread_helper+0x4/0x10
[   18.689257]  [<ffffffff81986274>] ? retint_restore_args+0x13/0x13
[   18.689633]  [<ffffffff82116b4b>] ? start_kernel+0x390/0x390
[   18.689993]  [<ffffffff8198ee40>] ? gs_change+0x13/0x13
[   18.690381] ---[ end trace 4eaa2a86a8e2da2d ]---
[   18.690704] Failed to enable function tracer for event tests
[   18.691063] Testing ftrace filter: OK
[   18.691872] Testing kprobe tracing: OK
[   18.712455]   Magic number: 3:927:888
[   18.712810] tty ptyuf: hash matches
[   18.713136] netconsole: local port 6665
[   18.713446] netconsole: local IP 10.0.0.0
[   18.713746] netconsole: interface 'eth0'
[   18.714041] netconsole: remote port 6666
[   18.714381] netconsole: remote IP 192.168.1.1
[   18.714692] netconsole: remote ethernet address 00:30:48:fe:19:95
[   18.715068] netconsole: device eth0 not up yet, forcing it
[   18.810886] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   18.861488] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   18.862188] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.863333] netconsole: timeout waiting for carrier
[   22.869615] console [netcon0] enabled
[   22.869921] netconsole: network logging started
[   22.870276] rtc_cmos 00:02: setting system clock to 2011-11-01 14:53:21 UTC (1320159201)
[   22.948459] e1000e 0000:00:19.0: eth0: Reset adapter
[   24.960517] e1000e 0000:00:19.0: eth0: Reset adapter
[   26.960824] e1000e 0000:00:19.0: eth0: Reset adapter
[   28.960860] e1000e 0000:00:19.0: eth0: Reset adapter
[   30.960731] e1000e 0000:00:19.0: eth0: Reset adapter
[   32.960801] e1000e 0000:00:19.0: eth0: Reset adapter
[   34.960871] e1000e 0000:00:19.0: eth0: Reset adapter
[   36.961136] e1000e 0000:00:19.0: eth0: Reset adapter
[   38.961220] e1000e 0000:00:19.0: eth0: Reset adapter
[   40.961084] e1000e 0000:00:19.0: eth0: Reset adapter
[   42.961155] e1000e 0000:00:19.0: eth0: Reset adapter
[   45.608008] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   45.610495] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   45.621196] IP-Config: Complete:
[   45.621474]      device=eth0, addr=192.168.1.52, mask=255.255.255.0, gw=192.168.1.1,
[   45.622023]      host=fat, domain=, nis-domain=(none),
[   45.622418]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
[   45.623333] md: Waiting for all devices to be available before autodetect
[   45.623744] md: If you don't use raid, use raid=noautodetect
[   45.625021] md: Autodetecting RAID arrays.
[   45.625352] md: Scanned 0 and added 0 devices.
[   45.625681] md: autorun ...
[   45.625945] md: ... autorun DONE.
[   46.646630] VFS: Mounted root (nfs filesystem) on device 0:16.
[   46.647063] debug: unmapping init memory ffffffff81f41000..ffffffff821f6000
[   47.494923] stty used greatest stack depth: 4192 bytes left
[   47.550026] startpar used greatest stack depth: 3752 bytes left
[   47.604446] uname used greatest stack depth: 3672 bytes left
[   47.688812] S02hostname.sh used greatest stack depth: 3640 bytes left
[   47.736132] mountpoint used greatest stack depth: 3544 bytes left
[   48.836450] sync used greatest stack depth: 3464 bytes left
[   50.104532] mkdir used greatest stack depth: 3368 bytes left
[   50.937265] EXT4-fs (sda5): recovery complete
[   50.937672] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   53.201358] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   53.201943] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   53.204420] ALSA hda_intel.c:1843 azx_pcm_prepare: bufsize=0x10000, format=0x11
[   53.204974] ALSA hda_codec.c:1413 hda_codec_setup_stream: NID=0x7, stream=0x4, channel=0, format=0x11
[   54.020307] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   54.021850] NFSD: starting 90-second grace period
[   54.825492] udevadm used greatest stack depth: 3304 bytes left
[   56.124141] which used greatest stack depth: 3080 bytes left
[   56.265194] mount.nfs used greatest stack depth: 2632 bytes left
[   56.480602] eth0: no IPv6 routers present
w
