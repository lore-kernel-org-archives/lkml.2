Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1DLIqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1DLIqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:46:33 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20110412001427.GH9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org> <1302544330.2596.31.camel@dolmen>
	 <20110412001427.GH9673@mtj.dyndns.org>
Content-Type: multipart/mixed; boundary="=-KQq+XCiSUYEFGlyELMPj"
Organization: Red Hat UK Ltd
Date: Tue, 12 Apr 2011 09:49:12 +0100
Message-ID: <1302598152.2661.11.camel@dolmen>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KQq+XCiSUYEFGlyELMPj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

On Tue, 2011-04-12 at 09:14 +0900, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 11, 2011 at 06:52:10PM +0100, Steven Whitehouse wrote:
> > WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
> > Hardware name: PowerEdge R710
> > Modules linked in:
> > Pid: 12, comm: kworker/2:0 Not tainted 2.6.39-rc2+ #188
> > Call Trace:
> >  [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
> >  [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
> >  [<ffffffff813c97cd>] kref_get+0x2d/0x30
> >  [<ffffffff813c81ca>] kobject_get+0x1a/0x30
> >  [<ffffffff814607f4>] get_device+0x14/0x20
> >  [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
> >  [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
> >  [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
> >  [<ffffffff810aa9c7>] process_one_work+0x197/0x520
> >  [<ffffffff810acfec>] worker_thread+0x15c/0x330
> >  [<ffffffff810b1f16>] kthread+0xa6/0xb0
> >  [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
> > ---[ end trace 3681e9da2630a94b ]---
> 
> Hmm, it could be that the root cause of the problem is
> premature/double put of scsi_device.  Without the patch, it makes
> scsi_request_fn() call into device destruction path prematurely
> triggering deadlock while after the patch, the deadlock is gone but
> the ref count reaches zero prematurely triggering kref warning on the
> next request.
> 
> The problem doesn't seem widespread so something about the setup is
> peculiar.  Steven, can you please detail the setup (and steps needed
> to trigger the problem) and attach the full boot log?  James, any
> ideas?
> 
> Thanks.
> 
The hardware is as follows:

Dell R710 server with two 2GHz 4-core CPUs
Two 146G SAS disks with hardware mirroring as root/OS disk
Two 300G SAS disks with hardware mirroring as GFS2 test disk (note: not
mounted during boot process)
12G RAM (boots with mem=4G since I was originally running tests with
lower memory, but I don't think the memory size affects this at all)

I've attached the boot log from testing your patch, yesterday. If you
want the boot logs including James' patch or the original boot log, I
can send those too,

Steve.


--=-KQq+XCiSUYEFGlyELMPj
Content-Disposition: attachment; filename="tejun.txt"
Content-Type: text/plain; name="tejun.txt"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.39-rc2+ (root@chywoon) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #188 SMP PREEMPT Mon Apr 11 18:13:35 BST 2011
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
Detected 1994.782 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.56 BogoMIPS (lpj=1994782)
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
Total of 8 processors activated (31915.21 BogoMIPS).
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
Switched to NOHz mode on CPU #6
Switched to NOHz mode on CPU #4
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #7
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #5
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
type=2000 audit(1302542567.544:1): initialized
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
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 12, comm: kworker/2:0 Not tainted 2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a94b ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 700, comm: kworker/1:3 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a94c ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 701, comm: kworker/1:4 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a94d ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 702, comm: kworker/1:5 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a94e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a94f ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a950 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a951 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a952 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a953 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a954 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a955 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a956 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a957 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a958 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a959 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a95a ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a95b ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a95c ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a95d ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a95e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a95f ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a960 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a961 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a962 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a963 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a964 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a965 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a966 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a967 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a968 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a969 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a96a ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a96b ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a96c ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a96d ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a96e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a96f ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a970 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a971 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a972 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a973 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a974 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a975 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a976 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a977 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a978 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a979 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a97a ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a97b ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a97c ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a97d ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a97e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a97f ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a980 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a981 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 703, comm: kworker/1:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a982 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 702, comm: kworker/1:5 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
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
---[ end trace 3681e9da2630a983 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 699, comm: kworker/1:2 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
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
---[ end trace 3681e9da2630a984 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 701, comm: kworker/1:4 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a985 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 700, comm: kworker/1:3 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a986 ]---
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 387, comm: kworker/7:1 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
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
---[ end trace 3681e9da2630a987 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c88b3010->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 387, comm: kworker/7:1 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7703>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7781>] list_del+0x11/0x40
 [<ffffffff8147d36d>] scsi_device_dev_release_usercontext+0x4d/0x140
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff8147d320>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a988 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c88b3020->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 387, comm: kworker/7:1 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7703>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7781>] list_del+0x11/0x40
 [<ffffffff8147d377>] scsi_device_dev_release_usercontext+0x57/0x140
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff8147d320>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a989 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800c88b3090->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 387, comm: kworker/7:1 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7703>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7781>] list_del+0x11/0x40
 [<ffffffff8147d384>] scsi_device_dev_release_usercontext+0x64/0x140
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff8147d320>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a98a ]---
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 4, comm: kworker/0:0 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a98b ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 707, comm: kworker/0:2 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a98c ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 710, comm: kworker/0:5 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a98d ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a98e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a98f ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a990 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a991 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a992 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a993 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a994 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a995 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a996 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a997 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a998 ]---
sd 0:2:0:0: [sda] 285474816 512-byte logical blocks: (146 GB/136 GiB)
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a999 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a99a ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a99b ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a99c ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a99d ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a99e ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a99f ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a0 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a1 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a2 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a3 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a4 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a5 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a6 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a7 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a8 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9a9 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9aa ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9ab ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 711, comm: kworker/0:6 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9ac ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 710, comm: kworker/0:5 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9ad ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 708, comm: kworker/0:3 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
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
---[ end trace 3681e9da2630a9ae ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 709, comm: kworker/0:4 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9af ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 4, comm: kworker/0:0 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9b0 ]---
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 707, comm: kworker/0:2 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
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
---[ end trace 3681e9da2630a9b1 ]---
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 15, comm: kworker/3:0 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
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
---[ end trace 3681e9da2630a9b2 ]---
TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v4.0.0-rc7-ml on Linux/x86_64 on 2.6.39-rc2+
sd 0:2:1:0: [sdb] 584843264 512-byte logical blocks: (299 GB/278 GiB)
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800379e9010->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 15, comm: kworker/3:0 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7703>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7781>] list_del+0x11/0x40
 [<ffffffff8147d36d>] scsi_device_dev_release_usercontext+0x4d/0x140
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff8147d320>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9b3 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800379e9020->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 15, comm: kworker/3:0 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7703>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7781>] list_del+0x11/0x40
 [<ffffffff8147d377>] scsi_device_dev_release_usercontext+0x57/0x140
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff8147d320>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9b4 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
Hardware name: PowerEdge R710
list_del corruption, ffff8800379e9090->next is LIST_POISON1 (dead000000100100)
Modules linked in:
Pid: 15, comm: kworker/3:0 Tainted: G        W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fb71>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff813d7703>] __list_del_entry+0x63/0xd0
 [<ffffffff813d7781>] list_del+0x11/0x40
 [<ffffffff8147d384>] scsi_device_dev_release_usercontext+0x64/0x140
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff8147d320>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a9b5 ]---
sd 0:2:0:0: [sda] Write Protect is off
sd 0:2:1:0: [sdb] Write Protect is off
sd 0:2:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v4.0.0-rc7-ml on Linux/x86_64 on 2.6.39-rc2+
 sdb: unknown partition table
TCM: Registered subsystem plugin: rd_dr struct module:           (null)
TCM: Registered subsystem plugin: rd_mcp struct module:           (null)
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 0:2:1:0: [sdb] Attached SCSI disk
CORE_HBA[0] - TCM Ramdisk HBA Driver v4.0 on Generic Target Core Stack v4.0.0-rc7-ml
CORE_HBA[0] - Attached Ramdisk HBA: 0 to Generic Target Core TCQ Depth: 256 MaxSectors: 1024
sd 0:2:0:0: [sda] Attached SCSI disk
CORE_HBA[0] - Attached HBA to Generic Target Core
RAMDISK: Referencing Page Count: 8
CORE_RD[0] - Built Ramdisk Device ID: 0 space of 8 pages in 1 tables
rd_dr: Using SPC_PASSTHROUGH, no reservation emulation
rd_dr: Using SPC_ALUA_PASSTHROUGH, no ALUA emulation
  Vendor: LIO-ORG   Model: RAMDISK-DR        Revision: 4.0 
  Type:   Direct-Access                      ANSI SCSI revision: 05
CORE_RD[0] - Added TCM DIRECT Ramdisk Device ID: 0 of 8 pages in 1 tables, 32768 total bytes
TCM: Registered subsystem plugin: iblock struct module:           (null)
TCM: Registered subsystem plugin: fileio struct module:           (null)
TCM: Registered subsystem plugin: pscsi struct module:           (null)
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
device-mapper: uevent: version 1.0.3
------------[ cut here ]------------
kernel BUG at mm/slab.c:3058!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W   2.6.39-rc2+ #188 Dell Inc. PowerEdge R710/0N047H
RIP: 0010:[<ffffffff8116f9e4>]  [<ffffffff8116f9e4>] cache_alloc_refill+0x274/0x290
RSP: 0018:ffff8800c90a1b70  EFLAGS: 00010046
RAX: dead000000200200 RBX: ffff8800cf000200 RCX: 0000000000000070
RDX: ffff8800c56ea000 RSI: ffff8800cf002080 RDI: ffff8800c88b8000
RBP: ffff8800c90a1bd0 R08: ffff8800c56ea000 R09: 0000000000000000
R10: 0000000000000032 R11: 000000000000003c R12: ffff8800cf01b000
R13: ffff8800cf002080 R14: ffff8800c88b8000 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8800cb000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001c33000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8800c90a0000, task ffff8800c909e040)
Stack:
 0000000000000010 ffff8800cf0020c0 000412d0c90a1ba0 ffff8800cf0020a0
 ffff8800cf002090 0000000200000286 ffff8800c90a1bd0 ffff8800cf000200
 000000000000000a 0000000000000000 00000000000000d0 00000000000000d0
Call Trace:
 [<ffffffff81170579>] __kmalloc_track_caller+0x239/0x280
 [<ffffffff811f491c>] ? sysfs_new_dirent+0x10c/0x120
 [<ffffffff81140290>] kstrdup+0x40/0x70
 [<ffffffff811f491c>] sysfs_new_dirent+0x10c/0x120
 [<ffffffff81682739>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff811f5683>] sysfs_do_create_link+0x93/0x220
 [<ffffffff813d0560>] ? sprintf+0x40/0x50
 [<ffffffff811f581e>] sysfs_create_link+0xe/0x10
 [<ffffffff81461a07>] device_add+0x227/0x600
 [<ffffffff813d6f08>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffff81461df9>] device_register+0x19/0x20
 [<ffffffff81461eeb>] device_create_vargs+0xeb/0x110
 [<ffffffff81456c54>] ? misc_register+0x24/0x130
 [<ffffffff81ef3e42>] ? md_init+0x14d/0x14d
 [<ffffffff81461f3c>] device_create+0x2c/0x30
 [<ffffffff81ef3e42>] ? md_init+0x14d/0x14d
 [<ffffffff81456cba>] misc_register+0x8a/0x130
 [<ffffffff81ef4093>] dm_interface_init+0x65/0xb1
 [<ffffffff81ef3e5a>] dm_init+0x18/0x46
 [<ffffffff810002bf>] do_one_initcall+0x3f/0x1a0
 [<ffffffff81ec1e28>] kernel_init+0xde/0x163
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff81ec1d4a>] ? start_kernel+0x4ca/0x4ca
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
Code: 48 89 df e8 9f fa ff ff 41 89 c5 e8 d7 7b 26 00 45 85 ed 89 c0 4c 8b 24 c3 74 12 41 83 3c 24 00 0f 84 af fd ff ff e9 5b ff ff ff <0f> 0b 31 c0 41 83 3c 24 00 0f 85 4c ff ff ff e9 61 ff ff ff 0f 
RIP  [<ffffffff8116f9e4>] cache_alloc_refill+0x274/0x290
 RSP <ffff8800c90a1b70>
---[ end trace 3681e9da2630a9b6 ]---
note: swapper[1] exited with preempt_count 1
swapper used greatest stack depth: 3768 bytes left
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D W   2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8167a336>] panic+0x96/0x1ab
 [<ffffffff81093d3b>] do_exit+0x83b/0x900
 [<ffffffff816800b7>] oops_end+0x97/0xd0
 [<ffffffff81040766>] die+0x56/0x90
 [<ffffffff8167f754>] do_trap+0xc4/0x170
 [<ffffffff8103dc56>] do_invalid_op+0xa6/0xc0
 [<ffffffff8116f9e4>] ? cache_alloc_refill+0x274/0x290
 [<ffffffff813d1d4d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8167f048>] ? restore_args+0x30/0x30
 [<ffffffff81686f5b>] invalid_op+0x1b/0x20
 [<ffffffff8116f9e4>] ? cache_alloc_refill+0x274/0x290
 [<ffffffff81170579>] __kmalloc_track_caller+0x239/0x280
 [<ffffffff811f491c>] ? sysfs_new_dirent+0x10c/0x120
 [<ffffffff81140290>] kstrdup+0x40/0x70
 [<ffffffff811f491c>] sysfs_new_dirent+0x10c/0x120
 [<ffffffff81682739>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff811f5683>] sysfs_do_create_link+0x93/0x220
 [<ffffffff813d0560>] ? sprintf+0x40/0x50
 [<ffffffff811f581e>] sysfs_create_link+0xe/0x10
 [<ffffffff81461a07>] device_add+0x227/0x600
 [<ffffffff813d6f08>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffff81461df9>] device_register+0x19/0x20
 [<ffffffff81461eeb>] device_create_vargs+0xeb/0x110
 [<ffffffff81456c54>] ? misc_register+0x24/0x130
 [<ffffffff81ef3e42>] ? md_init+0x14d/0x14d
 [<ffffffff81461f3c>] device_create+0x2c/0x30
 [<ffffffff81ef3e42>] ? md_init+0x14d/0x14d
 [<ffffffff81456cba>] misc_register+0x8a/0x130
 [<ffffffff81ef4093>] dm_interface_init+0x65/0xb1
 [<ffffffff81ef3e5a>] dm_init+0x18/0x46
 [<ffffffff810002bf>] do_one_initcall+0x3f/0x1a0
 [<ffffffff81ec1e28>] kernel_init+0xde/0x163
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff81ec1d4a>] ? start_kernel+0x4ca/0x4ca
 [<ffffffff816870e0>] ? gs_change+0x13/0x13

--=-KQq+XCiSUYEFGlyELMPj--

