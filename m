Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1DLOEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:04:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab1DLOEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:04:04 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302615745.2604.6.camel@mulgrave.site>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>
Content-Type: multipart/mixed; boundary="=-h66OEZe8YEt0q6O3ZLtd"
Organization: Red Hat UK Ltd
Date: Tue, 12 Apr 2011 15:06:52 +0100
Message-ID: <1302617212.2661.14.camel@dolmen>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h66OEZe8YEt0q6O3ZLtd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

On Tue, 2011-04-12 at 08:42 -0500, James Bottomley wrote:
> On Tue, 2011-04-12 at 09:42 +0100, Steven Whitehouse wrote:
> > #2 On its own:
> 
> Right, that's how it's supposed to be applied
> 
> > scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.07 PQ: 0 ANSI: 5
> > scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
> > scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > IP: [<ffffffff810ab4d3>] __queue_work+0x403/0x460
> > PGD 0 
> > Oops: 0000 [#1] PREEMPT SMP 
> > last sysfs file: 
> > CPU 0 
> > Modules linked in:
> > 
> > Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-rc2+ #190 Dell Inc. PowerEdge R710/0N047H
> > RIP: 0010:[<ffffffff810ab4d3>]  [<ffffffff810ab4d3>] __queue_work+0x403/0x460
> > RSP: 0018:ffff8800c90abb20  EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: ffff8800c56a8c58 RCX: ffff8800c56a8c60
> > RDX: ffff8800c56a8c60 RSI: 0000000000000000 RDI: ffff8800cb00e388
> > RBP: ffff8800c90abb70 R08: 0000000000000900 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800cb00e340
> > R13: 0000000000000000 R14: ffff8800cb1d6700 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff8800cb000000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000008 CR3: 0000000001c33000 CR4: 00000000000006f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process ksoftirqd/0 (pid: 3, threadinfo ffff8800c90aa000, task ffff8800c90a80c0)
> > Stack:
> >  ffff8800c90abb90 0000000000000086 0000000000000000 0000000000000086
> >  ffff8800c90a80c0 ffff8800c92ebe00 ffff8800c56a8c58 ffff8800c88bac28
> >  ffff8800c90abc30 ffff8800c565c080 ffff8800c90abb80 ffffffff810ab59d
> > Call Trace:
> >  [<ffffffff810ab59d>] queue_work_on+0x1d/0x30
> >  [<ffffffff810ac749>] queue_work+0x29/0x60
> >  [<ffffffff810ac865>] queue_delayed_work+0x25/0x30
> >  [<ffffffff813aff75>] __blk_run_queue+0xb5/0x110
> 
> OK, this is because the patch is incomplete ... it needs an additional
> reference which I missed in run queue ... can you apply the update patch
> below on top?
> 
> Actually, there are probably more places I missed, sigh.
> 
> >  [<ffffffff813b04ed>] blk_run_queue+0x2d/0x50
> >  [<ffffffff8147715a>] scsi_run_queue+0xea/0x3f0
> >  [<ffffffff814710cf>] ? __scsi_put_command+0x5f/0xa0
> >  [<ffffffff814793cd>] scsi_next_command+0x3d/0x60
> >  [<ffffffff81479602>] scsi_io_completion+0x1b2/0x630
> >  [<ffffffff81470cd7>] scsi_finish_command+0xc7/0x130
> >  [<ffffffff8147936f>] scsi_softirq_done+0x13f/0x160
> >  [<ffffffff813b8252>] blk_done_softirq+0xa2/0xc0
> >  [<ffffffff810970ac>] __do_softirq+0xdc/0x290
> >  [<ffffffff81097395>] run_ksoftirqd+0x135/0x250
> >  [<ffffffff81097260>] ? __do_softirq+0x290/0x290
> >  [<ffffffff810b1f16>] kthread+0xa6/0xb0
> >  [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
> >  [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
> >  [<ffffffff8167ec56>] ? _raw_spin_unlock_irq+0x46/0x70
> >  [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
> >  [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
> >  [<ffffffff816870e0>] ? gs_change+0x13/0x13
> > Code: 8b 44 24 48 49 8d 7c 24 48 48 83 e8 08 31 f6 eb 27 0f 1f 80 00 00 00 00 48 8b 00 49 89 c0 41 80 e0 00 a8 04 48 89 f0 49 0f 45 c0 
> >  8b 40 08 f6 00 10 74 14 48 8d 41 f8 48 8b 48 08 48 8d 50 08 
> > RIP  [<ffffffff810ab4d3>] __queue_work+0x403/0x460
> >  RSP <ffff8800c90abb20>
> > CR2: 0000000000000008
> > ---[ end trace 52fce2e9afb9bf59 ]---
> > Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > These are both on the same base kernel as yesterday (i.e. Linus tree
> > from this time yesterday morning) plus a few GFS2 patches, but they
> > only affect the GFS2 module which is not loaded.
> > 
> > I don't do anything special to trigger the problem - it happens of its
> > own accord during normal boot. The initscripts are those from f14.
> 
> That's useful ... at least it's not hard to reproduce ... it's just I
> don't see anything like this in my boot sequence.
> 
> James
> 
> ---
> 
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c
> +++ linux-2.6/block/blk-core.c
> @@ -328,7 +328,7 @@ void __blk_run_queue(struct request_queu
>  	if (!force_kblockd && !queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
>  		q->request_fn(q);
>  		queue_flag_clear(QUEUE_FLAG_REENTER, q);
> -	} else
> +	} else if (!blk_get_queue(q))
>  		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>  }
>  EXPORT_SYMBOL(__blk_run_queue);
> 
> 

Messages attached - getting closer I think, but still not quite there.
It is very odd that so far (at least I've seen no other reports) that I
seem to be the only one who hits this. I wonder what is different about
my kernel/hardware...

Steve.



--=-h66OEZe8YEt0q6O3ZLtd
Content-Disposition: attachment; filename="james3.txt"
Content-Type: text/plain; name="james3.txt"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.39-rc2+ (root@chywoon) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #192 SMP PREEMPT Tue Apr 12 14:29:39 BST 2011
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
Detected 1994.697 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.39 BogoMIPS (lpj=1994697)
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
Total of 8 processors activated (31915.11 BogoMIPS).
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
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #5
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
type=2000 audit(1302615472.549:1): initialized
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
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
BUG: unable to handle kernel scsi: killing requests for dead queue
NULL pointer dereference at 0000000000000028
IP: [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: 
CPU 1 
Modules linked in:

Pid: 243, comm: kblockd Not tainted 2.6.39-rc2+ #192 Dell Inc. PowerEdge R710/0N047H
RIP: 0010:[<ffffffff813b34ed>]  [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
RSP: 0000:ffff8800c880dc70  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88003799cad0 RCX: 0000000000000000
RDX: ffff8800c9398540 RSI: 0000000000000000 RDI: ffff88003799cad0
RBP: ffff8800c880dcb0 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88003799cad0
R13: ffff8800cb3d6700 R14: ffff8800c880c000 R15: ffff8800c880dfd8
FS:  0000000000000000(0000) GS:ffff8800cb200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000001c33000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kblockd (pid: 243, threadinfo ffff8800c880c000, task ffff8800c9398540)
Stack:
 ffff8800c880dc80 ffff8800c9398540 ffff8800c880dc90 0000000000000000
 ffff88003799cad0 ffff8800cb3d6700 ffff8800cb20e340 ffff8800c880dd90
 ffff8800c880dd10 ffffffff81479025 000000013799cc18 0000000000000000
Call Trace:
 [<ffffffff81479025>] scsi_request_fn+0x475/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810aad7c>] process_scheduled_works+0x2c/0x40
 [<ffffffff810acba9>] rescuer_thread+0x189/0x230
 [<ffffffff810aca20>] ? worker_rebind_fn+0xd0/0xd0
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec76>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
Code: 4e 1c 49 8b 46 10 a8 08 0f 84 65 ff ff ff e8 7b 7f 2c 00 e9 5b ff ff ff 66 0f 1f 44 00 00 49 8b 44 24 18 31 f6 48 8b 00 4c 89 e7 <ff> 50 28 85 c0 0f 85 f4 fe ff ff 45 31 ed e9 70 ff ff ff 45 31 
RIP  [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
 RSP <ffff8800c880dc70>
CR2: 0000000000000028
general protection fault: 0000 [#2] 
---[ end trace a091be4488bf08a6 ]---
note: kblockd[243] exited with preempt_count 1
sd 0:2:0:0: [sda] 285474816 512-byte logical blocks: (146 GB/136 GiB)
kblockd used greatest stack depth: 4520 bytes left
sd 0:2:1:0: [sdb] 584843264 512-byte logical blocks: (299 GB/278 GiB)
PREEMPT SMP 
last sysfs file: 
CPU 3 
Modules linked in:

Pid: 705, comm: kworker/3:5 Tainted: G      D     2.6.39-rc2+ #192 Dell Inc. PowerEdge R710/0N047H
RIP: 0010:[<ffffffff813b34ed>]  [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
RSP: 0018:ffff8800379b1c90  EFLAGS: 00010046
RAX: 7375622f40646461 RBX: ffff8800379b2c10 RCX: 0000000000000000
RDX: 0000000000002b2a RSI: 0000000000000000 RDI: ffff8800379b2c10
RBP: ffff8800379b1cd0 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800379b2c10
R13: ffff8800cb7d6700 R14: ffff8800379b0000 R15: ffff8800379b1fd8
FS:  0000000000000000(0000) GS:ffff8800cb600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001c33000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/3:5 (pid: 705, threadinfo ffff8800379b0000, task ffff8800c5728040)
Stack:
 ffff8800379b1ca0 ffff8800379b3188 0000000000000086 0000000000000000
 ffff8800379b2c10 ffff8800cb7d6700 ffff8800cb60e340 ffff8800379b1db0
 ffff8800379b1d30 ffffffff81479025 00000000379b2d58 ffff8800379b3188
Call Trace:
 [<ffffffff81479025>] scsi_request_fn+0x475/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec76>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
Code: 4e 1c 49 8b 46 10 a8 08 0f 84 65 ff ff ff e8 7b 7f 2c 00 e9 5b ff ff ff 66 0f 1f 44 00 00 49 8b 44 24 18 31 f6 48 8b 00 4c 89 e7 <ff> 50 28 85 c0 0f 85 f4 fe ff ff 45 31 ed e9 70 ff ff ff 45 31 
RIP  [<ffffffff813b34ed>] blk_peek_request+0x1ad/0x220
 RSP <ffff8800379b1c90>
---[ end trace a091be4488bf08a7 ]---
note: kworker/3:5[705] exited with preempt_count 1
TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v4.0.0-rc7-ml on Linux/x86_64 on 2.6.39-rc2+
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff810b220b>] kthread_data+0xb/0x20
PGD 1c35067 PUD 1c36067 PMD 0 
Oops: 0000 [#3] PREEMPT SMP 
last sysfs file: 
CPU 3 
Modules linked in:

Pid: 705, comm: kworker/3:5 Tainted: G      D     2.6.39-rc2+ #192 Dell Inc. PowerEdge R710/0N047H
RIP: 0010:[<ffffffff810b220b>]  [<ffffffff810b220b>] kthread_data+0xb/0x20
RSP: 0018:ffff8800379b1948  EFLAGS: 00010092
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffff8800379b1fd8
RDX: ffff8800c5728040 RSI: 0000000000000003 RDI: ffff8800c5728040
RBP: ffff8800379b1948 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800c57282e8
R13: 0000000000000003 R14: 0000000000000003 R15: ffff8800379b1b20
FS:  0000000000000000(0000) GS:ffff8800cb600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: fffffffffffffff8 CR3: 0000000001c33000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/3:5 (pid: 705, threadinfo ffff8800379b0000, task ffff8800c5728040)
Stack:
 ffff8800379b1968 ffffffff810ada50 ffff8800cb7d2500 ffff8800cb7d2500
 ffff8800379b1ab8 ffffffff8167ade9 0000000000000000 ffff8800c5728040
 0000000000000000 ffff8800379b1fd8 ffff8800c5728040 ffff8800379b1fd8
Call Trace:
 [<ffffffff810ada50>] wq_worker_sleeping+0x10/0xa0
 [<ffffffff8167ade9>] schedule+0x609/0xa40
 [<ffffffff81091d14>] ? release_task+0x14/0x400
 [<ffffffff813d7206>] ? do_raw_spin_unlock+0x76/0xd0
 [<ffffffff81093b04>] do_exit+0x604/0x900
 [<ffffffff81091694>] ? kmsg_dump+0x104/0x140
 [<ffffffff816800b7>] oops_end+0x97/0xd0
 [<ffffffff81040766>] die+0x56/0x90
 [<ffffffff8167f962>] do_general_protection+0x162/0x190
 [<ffffffff8167f048>] ? restore_args+0x30/0x30
 [<ffffffff8167f225>] general_protection+0x25/0x30
 [<ffffffff813b34ed>] ? blk_peek_request+0x1ad/0x220
 [<ffffffff81479025>] scsi_request_fn+0x475/0x4a0
 [<ffffffff813b2baa>] __blk_run_queue+0x6a/0x120
 [<ffffffff813b3121>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b30f0>] ? blk_insert_request+0xa0/0xa0
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec76>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
Code: d8 fc ff 48 8b 85 28 ff ff ff 48 81 c4 e0 00 00 00 5b 41 5c c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 8b 87 50 02 00 00 48 89 e5 
 8b 40 f8 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 
RIP  [<ffffffff810b220b>] kthread_data+0xb/0x20
 RSP <ffff8800379b1948>
CR2: fffffffffffffff8
---[ end trace a091be4488bf08a8 ]---
Fixing recursive fault but reboot is needed!

--=-h66OEZe8YEt0q6O3ZLtd--

