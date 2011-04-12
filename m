Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1DLQsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860Ab1DLQst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:48:49 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302625621.2604.24.camel@mulgrave.site>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
	 <1302621261.2604.18.camel@mulgrave.site>  <1302624266.2661.21.camel@dolmen>
	 <1302625621.2604.24.camel@mulgrave.site>
Content-Type: multipart/mixed; boundary="=-Tg/BnHkxU+HfShKfLFOh"
Organization: Red Hat UK Ltd
Date: Tue, 12 Apr 2011 17:51:37 +0100
Message-ID: <1302627097.2661.25.camel@dolmen>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Tg/BnHkxU+HfShKfLFOh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

On Tue, 2011-04-12 at 11:27 -0500, James Bottomley wrote:
> On Tue, 2011-04-12 at 17:04 +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Tue, 2011-04-12 at 10:14 -0500, James Bottomley wrote:
> > > On Tue, 2011-04-12 at 15:06 +0100, Steven Whitehouse wrote:
> > > > Messages attached - getting closer I think, but still not quite there.
> > > > It is very odd that so far (at least I've seen no other reports) that I
> > > > seem to be the only one who hits this. I wonder what is different about
> > > > my kernel/hardware...
> > > 
> > > 
> > > > csi: killing requests for dead queue
> > > > scsi: killing requests for dead queue
> > > > BUG: unable to handle kernel scsi: killing requests for dead queue
> > > > NULL pointer dereference at 0000000000000028
> > > > IP: [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
> > > 
> > > Hmm, I don't see where this is ... it's a null pointer deref offset by
> > > 0x28 bytes ... but I can't see where ... can you resolve this to a line?
> > > 
> > > James
> > > 
> > > 
> > 
> > So assuming I've calculated this correctly, it should be just about....
> > 
> > /home/steve/linux-2.6/include/linux/rcupdate.h:677
> >     6de8:       a8 08                   test   $0x8,%al
> >     6dea:       0f 84 65 ff ff ff       je     6d55 <blk_peek_request+0xf5>
> >     6df0:       e8 00 00 00 00          callq  6df5 <blk_peek_request+0x195>
> >                         6df1: R_X86_64_PC32     preempt_schedule-0x4
> >     6df5:       e9 5b ff ff ff          jmpq   6d55 <blk_peek_request+0xf5>
> >     6dfa:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
> > __elv_next_request():
> > /home/steve/linux-2.6/block/blk.h:65
> >                 if (!list_empty(&q->queue_head)) {
> >                         rq = list_entry_rq(q->queue_head.next);
> >                         return rq;
> >                 }
> > 
> >                 if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
> >     6e00:       49 8b 44 24 18          mov    0x18(%r12),%rax
> >     6e05:       31 f6                   xor    %esi,%esi
> >     6e07:       48 8b 00                mov    (%rax),%rax
> >     6e0a:       4c 89 e7                mov    %r12,%rdi                              <---- here!
> >     6e0d:       ff 50 28                callq  *0x28(%rax)
> >     6e10:       85 c0                   test   %eax,%eax
> >     6e12:       0f 85 f4 fe ff ff       jne    6d0c <blk_peek_request+0xac>
> >     6e18:       45 31 ed                xor    %r13d,%r13d
> >     6e1b:       e9 70 ff ff ff          jmpq   6d90 <blk_peek_request+0x130>
> > blk_peek_request():
> > /home/steve/linux-2.6/block/blk-core.c:1912
> >                                  * so that we don't add it again
> >                                  */
> > 
> > The offset I got was 6e0d, but I guess thats the start of the following instruction
> > by the time the fault is logged. Also I've attached my current .config just in case
> > that might be a help is reproducing it,
> 
> Good work!  it's simpler if you compile with -g ... then the gdb line
> command will just tell you all of this.  However, it seems clear that
> elevator->ops is NULL (elevator_dispatch_fn is 0x28 offset into that in
> a 64 bit system).
> 
> That's because blk_cleanup_queue called elevator_exit, so we need an out
> in the peek case.
> 
> So unwrapping the onion, this is the next level
> 
> James
> 
> ---
> 
> Index: linux-2.6/block/blk.h
> ===================================================================
> --- linux-2.6.orig/block/blk.h
> +++ linux-2.6/block/blk.h
> @@ -62,7 +62,7 @@ static inline struct request *__elv_next
>  			return rq;
>  		}
>  
> -		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
> +		if (!q->elevator->ops || !q->elevator->ops->elevator_dispatch_fn(q, 0))
>  			return NULL;
>  	}
>  }
> 
> 

Still not quite there, but looking more hopeful now,

Steve.


--=-Tg/BnHkxU+HfShKfLFOh
Content-Disposition: attachment; filename="james4.txt"
Content-Type: text/plain; name="james4.txt"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.39-rc2+ (root@chywoon) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #193 SMP PREEMPT Tue Apr 12 17:12:25 BST 2011
Command line: ro root=/dev/mapper/VolGroup-lv_root rhgb console=ttyS0,115200n8 console=tty0 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us mem=4G
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000cf669000 (usable)
 BIOS-e820: 00000000cf669000 - 00000000cf67f000 (reserved)
 BIOS-e820: 00000000cf67f000 - 00000000cf6be000 (ACPI data)
 BIOS-e820: 00000000cf6be000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000330000000 (usable)
NX (Execute Disable) protection: active
user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 0000000000100000 - 00000000cf669000 (usable)
 user: 00000000cf669000 - 00000000cf67f000 (reserved)
 user: 00000000cf67f000 - 00000000cf6be000 (ACPI data)
 user: 00000000cf6be000 - 00000000d0000000 (reserved)
 user: 00000000e0000000 - 00000000f0000000 (reserved)
 user: 00000000fe000000 - 0000000100000000 (reserved)
DMI 2.6 present.
No AGP bridge found
last_pfn = 0xcf669 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [ffff8800000fe710] fe710
init_memory_mapping: 0000000000000000-00000000cf669000
RAMDISK: 3768b000 - 37ff0000
ACPI: RSDP 00000000000f0a90 00024 (v02 DELL  )
ACPI: XSDT 00000000000f0b94 0009C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: FACP 00000000cf6a3f9c 000F4 (v03 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DSDT 00000000cf67f000 03D5A (v01 DELL   PE_SC3   00000001 INTL 20050624)
ACPI: FACS 00000000cf6a6000 00040
ACPI: APIC 00000000cf6a3478 0015E (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SPCR 00000000cf6a35d8 00050 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HPET 00000000cf6a362c 00038 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DMAR 00000000cf6a3668 001B0 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: MCFG 00000000cf6a38c4 0003C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: WD__ 00000000cf6a3904 00134 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SLIC 00000000cf6a3a3c 00024 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: ERST 00000000cf682edc 00270 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HEST 00000000cf68314c 003A8 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: BERT 00000000cf682d5c 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: EINJ 00000000cf682d8c 00150 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SRAT 00000000cf6a3bc0 00370 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: TCPA 00000000cf6a3f34 00064 (v02 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SSDT 00000000cf6a7000 01DEC (v01  INTEL PPM RCM  80000001 INTL 20061109)
SRAT: PXM 1 -> APIC 0x10 -> Node 0
SRAT: PXM 2 -> APIC 0x00 -> Node 1
SRAT: PXM 1 -> APIC 0x12 -> Node 0
SRAT: PXM 2 -> APIC 0x02 -> Node 1
SRAT: PXM 1 -> APIC 0x14 -> Node 0
SRAT: PXM 2 -> APIC 0x04 -> Node 1
SRAT: PXM 1 -> APIC 0x16 -> Node 0
SRAT: PXM 2 -> APIC 0x06 -> Node 1
SRAT: Node 1 PXM 2 0-d0000000
SRAT: Node 1 PXM 2 100000000-1b0000000
SRAT: Node 0 PXM 1 1b0000000-330000000
NUMA: Node 1 [0,cf669000) + [100000000,1b0000000) -> [0,cf669000)
NUMA: nodes only cover 0MB of your 3317MB e820 RAM. Not used.
No NUMA configuration found
Faking a node at 0000000000000000-00000000cf669000
Initmem setup node 0 0000000000000000-00000000cf669000
  NODE_DATA [00000000cf65e000 - 00000000cf662fff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x000cf669
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x28] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x29] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x2a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x2b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x2f] disabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x30] disabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x31] disabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x32] disabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x33] disabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x34] disabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x35] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x36] disabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x37] disabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x38] disabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x39] disabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x3a] disabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x3b] disabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x3c] disabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x3d] disabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x3e] disabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0x3f] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x01] address[0xfec80000] gsi_base[32])
IOAPIC[1]: apic_id 1, version 32, address 0xfec80000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 475 pages/cpu @ffff8800cb000000 s1913872 r8192 d23536 u2097152
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 837782
Policy zone: DMA32
Kernel command line: ro root=/dev/mapper/VolGroup-lv_root rhgb console=ttyS0,115200n8 console=tty0 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us mem=4G
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 3300120k/3398052k available (6695k kernel code, 448k absent, 97484k reserved, 6535k data, 2572k init)
Preemptable hierarchical RCU implementation.
	RCU debugfs-based tracing is enabled.
NR_IRQS:512
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
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
allocated 27262976 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 1994.649 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.29 BogoMIPS (lpj=1994649)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Freeing SMP alternatives: 24k freed
ACPI: Core revision 20110316
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz stepping 05
Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1
lockdep: fixing up alternatives.
 #2
lockdep: fixing up alternatives.
 #3
lockdep: fixing up alternatives.
 #4
lockdep: fixing up alternatives.
 #5
lockdep: fixing up alternatives.
 #6
lockdep: fixing up alternatives.
 #7 Ok.
Brought up 8 CPUs
Total of 8 processors activated (31914.94 BogoMIPS).
kworker/u:0 used greatest stack depth: 4808 bytes left
print_constraints: dummy: 
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
dca service started, version 1.12.1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfdffffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 00e0 (mask 000f)
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:04.0: PCI bridge to [bus 03-03]
pci 0000:00:05.0: PCI bridge to [bus 04-04]
pci 0000:00:06.0: PCI bridge to [bus 05-05]
pci 0000:00:07.0: PCI bridge to [bus 06-06]
pci 0000:00:09.0: PCI bridge to [bus 07-07]
pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 11 14 *15)
ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 *14 15)
ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 *6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 *14 15)
vgaarb: device added: PCI:0000:08:03.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Switching to clocksource hpet
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #4
Switched to NOHz mode on CPU #6
Switched to NOHz mode on CPU #5
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #7
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:07: [io  0x0800-0x087f] has been reserved
system 00:07: [io  0x0880-0x08ff] has been reserved
system 00:07: [io  0x0900-0x091f] has been reserved
system 00:07: [io  0x0920-0x0923] has been reserved
system 00:07: [io  0x0924] has been reserved
system 00:07: [io  0x0c00-0x0c7f] has been reserved
system 00:07: [io  0x0ca0-0x0ca7] has been reserved
system 00:07: [io  0x0ca9-0x0cab] has been reserved
system 00:07: [io  0x0cad-0x0caf] has been reserved
system 00:08: [io  0x0ca8] has been reserved
system 00:08: [io  0x0cac] has been reserved
system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: [mem 0xfed90000-0xfed91fff] has been reserved
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xd6000000-0xd9ffffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem 0xda000000-0xddffffff]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: PCI bridge to [bus 03-03]
pci 0000:00:04.0:   bridge window [io  0xf000-0xffff]
pci 0000:00:04.0:   bridge window [mem 0xdf100000-0xdf1fffff]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 04-04]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem disabled]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 05-05]
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem disabled]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 06-06]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 07-07]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem disabled]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:08:03.0: BAR 6: assigned [mem 0xde000000-0xde00ffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 08-08]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xde000000-0xdeffffff]
pci 0000:00:1e.0:   bridge window [mem 0xd5800000-0xd5ffffff 64bit pref]
pci 0000:00:01.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:03.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:04.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:05.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:06.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:07.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
pci 0000:00:09.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 6, 393216 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 9620k freed
Intel AES-NI instructions are not detected.
audit: initializing netlink socket (disabled)
type=2000 audit(1302625000.516:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
OCFS2 1.5.0
ocfs2: Registered cluster interface o2cb
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
OCFS2 Node Manager 1.5.0
OCFS2 DLM 1.5.0
msgmni has been set to 6464
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
brd: module loaded
megasas: 00.00.05.34-rc1 Thu. Feb. 24 17:00:00 PDT 2011
megasas: 0x1000:0x0060:0x1028:0x1f0c: bus 3:slot 0:func 0
megaraid_sas 0000:03:00.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
megasas: FW now in Ready state
megasas_init_mfi: fw_support_ieee=0
megasas: INIT adapter done
scsi0 : LSI SAS based MegaRAID driver
scsi 0:0:0:0: Direct-Access     SEAGATE  ST3146356SS      HS0A PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     SEAGATE  ST3146356SS      HS0A PQ: 0 ANSI: 5
scsi 0:0:2:0: Direct-Access     SEAGATE  ST3300656SS      HS0A PQ: 0 ANSI: 5
scsi 0:0:3:0: Direct-Access     SEAGATE  ST3300656SS      HS0A PQ: 0 ANSI: 5
Refined TSC clocksource calibration: 1994.999 MHz.
Switching to clocksource tsc
scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.07 PQ: 0 ANSI: 5
scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
scsi: killing requests for dead queue
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 386, comm: kworker/6:1 Not tainted 2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c984d>] kref_get+0x2d/0x30
 [<ffffffff813c824a>] kobject_get+0x1a/0x30
 [<ffffffff81460874>] get_device+0x14/0x20
 [<ffffffff81478bd7>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd138b ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c564d810->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 386, comm: kworker/6:1 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7783>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7801>] list_del+0x11/0x40
 [<ffffffff8147d2ed>] scsi_device_dev_release_usercontext+0x4d/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d2a0>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d277>] scsi_device_dev_release+0x17/0x20
 [<ffffffff81460a72>] device_release+0x22/0x90
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c81e5>] kobject_release+0x45/0x90
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff813c97e7>] kref_put+0x37/0x70
 [<ffffffff813c80a7>] kobject_put+0x27/0x60
 [<ffffffff814608a2>] put_device+0x12/0x20
 [<ffffffff81478c59>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd138c ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c564d820->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 386, comm: kworker/6:1 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7783>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7801>] list_del+0x11/0x40
 [<ffffffff8147d2f7>] scsi_device_dev_release_usercontext+0x57/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d2a0>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d277>] scsi_device_dev_release+0x17/0x20
 [<ffffffff81460a72>] device_release+0x22/0x90
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c81e5>] kobject_release+0x45/0x90
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff813c97e7>] kref_put+0x37/0x70
 [<ffffffff813c80a7>] kobject_put+0x27/0x60
 [<ffffffff814608a2>] put_device+0x12/0x20
 [<ffffffff81478c59>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd138d ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c564d890->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 386, comm: kworker/6:1 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7783>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7801>] list_del+0x11/0x40
 [<ffffffff8147d304>] scsi_device_dev_release_usercontext+0x64/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d2a0>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d277>] scsi_device_dev_release+0x17/0x20
 [<ffffffff81460a72>] device_release+0x22/0x90
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c81e5>] kobject_release+0x45/0x90
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff813c97e7>] kref_put+0x37/0x70
 [<ffffffff813c80a7>] kobject_put+0x27/0x60
 [<ffffffff814608a2>] put_device+0x12/0x20
 [<ffffffff81478c59>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd138e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 698, comm: kworker/4:2 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c984d>] kref_get+0x2d/0x30
 [<ffffffff813c824a>] kobject_get+0x1a/0x30
 [<ffffffff81460874>] get_device+0x14/0x20
 [<ffffffff81478bd7>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd138f ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c564d810->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 698, comm: kworker/4:2 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7783>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7801>] list_del+0x11/0x40
 [<ffffffff8147d2ed>] scsi_device_dev_release_usercontext+0x4d/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d2a0>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d277>] scsi_device_dev_release+0x17/0x20
 [<ffffffff81460a72>] device_release+0x22/0x90
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c81e5>] kobject_release+0x45/0x90
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff813c97e7>] kref_put+0x37/0x70
 [<ffffffff813c80a7>] kobject_put+0x27/0x60
 [<ffffffff814608a2>] put_device+0x12/0x20
 [<ffffffff81478c59>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd1390 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c564d820->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 698, comm: kworker/4:2 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7783>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7801>] list_del+0x11/0x40
 [<ffffffff8147d2f7>] scsi_device_dev_release_usercontext+0x57/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d2a0>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d277>] scsi_device_dev_release+0x17/0x20
 [<ffffffff81460a72>] device_release+0x22/0x90
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c81e5>] kobject_release+0x45/0x90
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff813c97e7>] kref_put+0x37/0x70
 [<ffffffff813c80a7>] kobject_put+0x27/0x60
 [<ffffffff814608a2>] put_device+0x12/0x20
 [<ffffffff81478c59>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd1391 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c564d890->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 698, comm: kworker/4:2 Tainted: G        W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7783>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7801>] list_del+0x11/0x40
 [<ffffffff8147d304>] scsi_device_dev_release_usercontext+0x64/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d2a0>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d277>] scsi_device_dev_release+0x17/0x20
 [<ffffffff81460a72>] device_release+0x22/0x90
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c81e5>] kobject_release+0x45/0x90
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff813c97e7>] kref_put+0x37/0x70
 [<ffffffff813c80a7>] kobject_put+0x27/0x60
 [<ffffffff814608a2>] put_device+0x12/0x20
 [<ffffffff81478c59>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810ad0fe>] worker_thread+0x26e/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace d1e6d87b12dd1392 ]---
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
BUG: unable to handle kernel NULL pointer dereference at 00000000000002bc
IP: [<ffffffff8147ddb3>] scsi_sysfs_device_initialize+0xd3/0x150
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: 
CPU 4 
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W   2.6.39-rc2+ #193 Dell Inc. PowerEdge R710/0N047H
RIP: 0010:[<ffffffff8147ddb3>]  [<ffffffff8147ddb3>] scsi_sysfs_device_initialize+0xd3/0x150
RSP: 0018:ffff8800c90a18c0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800c564d800 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 000000000000002f RDI: 0000000000000001
RBP: ffff8800c90a18f0 R08: 000000000000fffc R09: 000000000000fffe
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800379a6c10
R13: 0000000000000000 R14: ffff8800c564d9b0 R15: ffff8800c564dc20
FS:  0000000000000000(0000) GS:ffff8800cb800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002bc CR3: 0000000001c33000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8800c90a0000, task ffff8800c909e040)
Stack:
 ffff8800c566f000 ffff8800c564d800 ffff8800c566f000 ffff8800c5640000
 0000000000000000 ffff8800c566f028 ffff8800c90a1930 ffffffff8147a49e
 ffff8800c90a1930 0000000000000000 ffff8800c566f000 0000000000000000
Call Trace:
 [<ffffffff8147a49e>] scsi_alloc_sdev+0x1ee/0x290
 [<ffffffff8147aba8>] scsi_probe_and_add_lun+0x3a8/0xc30
 [<ffffffff810cbdad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81467830>] ? anon_transport_dummy_function+0x10/0x10
 [<ffffffff8167d029>] ? mutex_unlock+0x9/0x10
 [<ffffffff8146758c>] ? attribute_container_add_device+0x6c/0x140
 [<ffffffff813c824a>] ? kobject_get+0x1a/0x30
 [<ffffffff8147a281>] ? scsi_alloc_target+0x2a1/0x2d0
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff8147b6e2>] __scsi_scan_target+0x102/0x770
 [<ffffffff81682739>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8147bdd6>] scsi_scan_channel+0x86/0xb0
 [<ffffffff8147c0f8>] scsi_scan_host_selected+0xf8/0x1a0
 [<ffffffff8147c229>] do_scsi_scan_host+0x89/0x90
 [<ffffffff8147c508>] scsi_scan_host+0x198/0x1f0
 [<ffffffff81673c8d>] megasas_probe_one+0x127b/0x1535
 [<ffffffff813e8382>] pci_device_probe+0xf2/0x110
 [<ffffffff8146407a>] ? driver_sysfs_add+0x7a/0xb0
 [<ffffffff81464349>] driver_probe_device+0x89/0x1a0
 [<ffffffff81464503>] __driver_attach+0xa3/0xb0
 [<ffffffff81464460>] ? driver_probe_device+0x1a0/0x1a0
 [<ffffffff8146336e>] bus_for_each_dev+0x5e/0x90
 [<ffffffff81463ff9>] driver_attach+0x19/0x20
 [<ffffffff81463b8a>] bus_add_driver+0xba/0x270
 [<ffffffff81ef1c36>] ? megaraid_init+0xbc/0xbc
 [<ffffffff8146488f>] driver_register+0x6f/0x130
 [<ffffffff81ef1c36>] ? megaraid_init+0xbc/0xbc
 [<ffffffff813e85f1>] __pci_register_driver+0x61/0xe0
 [<ffffffff81ef1c36>] ? megaraid_init+0xbc/0xbc
 [<ffffffff81ef1cd2>] megasas_init+0x9c/0x1e6
 [<ffffffff810002bf>] do_one_initcall+0x3f/0x1a0
 [<ffffffff81ec1e28>] kernel_init+0xde/0x163
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff81ec1d4a>] ? start_kernel+0x4ca/0x4ca
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
Code: 89 83 20 04 00 00 48 c7 c6 0d a5 a1 81 48 8b 03 48 c7 83 78 06 00 00 60 38 cb 81 4c 89 ff 8b 90 24 02 00 00 31 c0 e8 0d 2c fe ff 
 0f b6 85 bc 02 00 00 4c 89 f7 88 83 e9 00 00 00 e8 07 9c fe 
RIP  [<ffffffff8147ddb3>] scsi_sysfs_device_initialize+0xd3/0x150
 RSP <ffff8800c90a18c0>
CR2: 00000000000002bc
---[ end trace d1e6d87b12dd1393 ]---
swapper used greatest stack depth: 3576 bytes left
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D W   2.6.39-rc2+ #193
Call Trace:
 [<ffffffff8167a336>] panic+0x96/0x1ab
 [<ffffffff81093cbd>] ? do_exit+0x7bd/0x900
 [<ffffffff8167e60d>] ? _raw_write_lock_irq+0x7d/0x90
 [<ffffffff81093d3b>] do_exit+0x83b/0x900
 [<ffffffff816800b7>] oops_end+0x97/0xd0
 [<ffffffff81064b70>] no_context+0xf0/0x260
 [<ffffffff810cbbdb>] ? mark_held_locks+0x6b/0xa0
 [<ffffffff81064e05>] __bad_area_nosemaphore+0x125/0x1f0
 [<ffffffff8104376e>] ? native_sched_clock+0x2e/0x80
 [<ffffffff816823ed>] ? do_page_fault+0x2bd/0x560
 [<ffffffff81064ede>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8168255e>] do_page_fault+0x42e/0x560
 [<ffffffff813d0401>] ? vsnprintf+0x471/0x610
 [<ffffffff813d1dcd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8167f255>] page_fault+0x25/0x30
 [<ffffffff8147ddb3>] ? scsi_sysfs_device_initialize+0xd3/0x150
 [<ffffffff8147a49e>] scsi_alloc_sdev+0x1ee/0x290
 [<ffffffff8147aba8>] scsi_probe_and_add_lun+0x3a8/0xc30
 [<ffffffff810cbdad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81467830>] ? anon_transport_dummy_function+0x10/0x10
 [<ffffffff8167d029>] ? mutex_unlock+0x9/0x10
 [<ffffffff8146758c>] ? attribute_container_add_device+0x6c/0x140
 [<ffffffff813c824a>] ? kobject_get+0x1a/0x30
 [<ffffffff8147a281>] ? scsi_alloc_target+0x2a1/0x2d0
 [<ffffffff813c81a0>] ? kobject_del+0x40/0x40
 [<ffffffff8147b6e2>] __scsi_scan_target+0x102/0x770
 [<ffffffff81682739>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8147bdd6>] scsi_scan_channel+0x86/0xb0
 [<ffffffff8147c0f8>] scsi_scan_host_selected+0xf8/0x1a0
 [<ffffffff8147c229>] do_scsi_scan_host+0x89/0x90
 [<ffffffff8147c508>] scsi_scan_host+0x198/0x1f0
 [<ffffffff81673c8d>] megasas_probe_one+0x127b/0x1535
 [<ffffffff813e8382>] pci_device_probe+0xf2/0x110
 [<ffffffff8146407a>] ? driver_sysfs_add+0x7a/0xb0
 [<ffffffff81464349>] driver_probe_device+0x89/0x1a0
 [<ffffffff81464503>] __driver_attach+0xa3/0xb0
 [<ffffffff81464460>] ? driver_probe_device+0x1a0/0x1a0
 [<ffffffff8146336e>] bus_for_each_dev+0x5e/0x90
 [<ffffffff81463ff9>] driver_attach+0x19/0x20
 [<ffffffff81463b8a>] bus_add_driver+0xba/0x270
 [<ffffffff81ef1c36>] ? megaraid_init+0xbc/0xbc
 [<ffffffff8146488f>] driver_register+0x6f/0x130
 [<ffffffff81ef1c36>] ? megaraid_init+0xbc/0xbc
 [<ffffffff813e85f1>] __pci_register_driver+0x61/0xe0
 [<ffffffff81ef1c36>] ? megaraid_init+0xbc/0xbc
 [<ffffffff81ef1cd2>] megasas_init+0x9c/0x1e6
 [<ffffffff810002bf>] do_one_initcall+0x3f/0x1a0
 [<ffffffff81ec1e28>] kernel_init+0xde/0x163
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff81ec1d4a>] ? start_kernel+0x4ca/0x4ca
 [<ffffffff816870e0>] ? gs_change+0x13/0x13

--=-Tg/BnHkxU+HfShKfLFOh--

