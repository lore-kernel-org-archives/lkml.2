Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0LQNWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:22:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab0LQNWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:22:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Xu, Andiry" <Andiry.Xu@amd.com>
Subject: Re: Scary warnings from xhci_hcd on rmmod and during shutdown/suspend/resume
Date: Fri, 17 Dec 2010 14:21:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
References: <201012170039.16185.rjw@sisk.pl> <2DEEA3AB13739D45A22ADDB5086AEA0BC080D3@sshaexmb1.amd.com>
In-Reply-To: <2DEEA3AB13739D45A22ADDB5086AEA0BC080D3@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pP2CNhSnfd72tsi"
Message-Id: <201012171421.45367.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_pP2CNhSnfd72tsi
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Friday, December 17, 2010, Xu, Andiry wrote:
> > 
> > and during shutdown (I believe the warnings are the same or analogous
> to
> > the
> > above).
> > 
> > I tested with the attached patch from Andiry applied and I got the
> > following
> > BUG during resume:
> 
> Does this bug occurs without the synchronize irq patch?

Yes, it does.

> Seems the rmmod, shutdown and resume bugs are caused by xhci_cleanup_msix().
> 
> > 
> > [   91.703778] sd 0:0:0:0: [sda] Starting disk
> > [   91.704054] sd 2:0:0:0: [sdb] Starting disk
> > [   91.703680] xhci_hcd 0000:04:00.0: Host controller not halted,
> aborting
> > reset.
> > [   91.703680] BUG: sleeping function called from invalid context at
> > /home/rafael/src/linux-2.6/kernel/mutex.c:278
> > [   91.703680] in_atomic(): 1, irqs_disabled(): 1, pid: 1234, name:
> > kworker/u:6
> > [   91.703680] INFO: lockdep is turned off.
> > [   91.703680] irq event stamp: 24060
> > [   91.703680] hardirqs last  enabled at (24059): [<ffffffff810aa071>]
> > rcu_note_context_switch+0xa1/0x1c0
> > [   91.703680] hardirqs last disabled at (24060): [<ffffffff81494e92>]
> > _raw_spin_lock_irq+0x12/0x50
> > [   91.703680] softirqs last  enabled at (20026): [<ffffffff8105056e>]
> > __do_softirq+0x11e/0x160
> > [   91.703680] softirqs last disabled at (20011): [<ffffffff8100368c>]
> > call_softirq+0x1c/0x30
> > [   91.703680] Pid: 1234, comm: kworker/u:6 Tainted: G        W
> 2.6.37-
> > rc6+ #12
> > [   91.703680] Call Trace:
> > [   91.703680]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
> > [   91.703680]  [<ffffffff81036783>] __might_sleep+0x103/0x130
> > [   91.703680]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
> > [   91.703680]  [<ffffffff81495727>] ?
> > _raw_spin_unlock_irqrestore+0x67/0x70
> > [   91.703680]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
> > [   91.703680]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
> > [   91.703680]  [<ffffffff81022008>] destroy_irq+0x78/0x90
> > [   91.703680]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
> > [   91.703680]  [<ffffffff811ee0b0>]
> default_teardown_msi_irqs+0x70/0xa0
> > [   91.703680]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
> > [   91.703680]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
> > [   91.703680]  [<ffffffffa03f0609>] xhci_cleanup_msix+0x39/0x80
> [xhci_hcd]
> > [   91.703680]  [<ffffffffa03f111c>] xhci_resume+0x1ac/0x250
> [xhci_hcd]
> > [   91.703680]  [<ffffffffa03f65c4>] xhci_pci_resume+0x14/0x20
> [xhci_hcd]
> > [   91.703680]  [<ffffffff8138996b>] resume_common+0xbb/0x140
> > [   91.703680]  [<ffffffff81389a5e>] hcd_pci_restore+0xe/0x10
> > [   91.703680]  [<ffffffff811e36f3>] pci_pm_restore+0x63/0xb0
> > [   91.703680]  [<ffffffff813334bd>] pm_op+0x19d/0x1c0
> > [   91.703680]  [<ffffffff81333be4>] device_resume+0x94/0x220
> > [   91.703680]  [<ffffffff81333d8c>] async_resume+0x1c/0x50
> > [   91.703680]  [<ffffffff8106e6e6>] async_run_entry_fn+0x86/0x160
> > [   91.703680]  [<ffffffff81060672>] process_one_work+0x1a2/0x450
> > [   91.703680]  [<ffffffff81060614>] ? process_one_work+0x144/0x450
> > [   91.703680]  [<ffffffff811d2704>] ? do_raw_spin_lock+0x104/0x170
> > [   91.703680]  [<ffffffff8106e660>] ? async_run_entry_fn+0x0/0x160
> > [   91.703680]  [<ffffffff81061e32>] worker_thread+0x162/0x340
> > [   91.703680]  [<ffffffff81061cd0>] ? worker_thread+0x0/0x340
> > [   91.703680]  [<ffffffff81066836>] kthread+0x96/0xa0
> > [   91.703680]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
> > [   91.703680]  [<ffffffff81036fdb>] ? finish_task_switch+0x7b/0xe0
> > [   91.703680]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
> > [   91.703680]  [<ffffffff810667a0>] ? kthread+0x0/0xa0
> > [   91.703680]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
> > [   91.706248] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
> > [   91.706251] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
> > [   91.706253] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
> > [   91.706256] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
> > [   91.706258] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
> > [   91.706260] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
> > [   91.706262] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
> > 
> > The issues appear to be 100% reproducible.
> > 
> 
> I'm not able to reproduce the issue. Can you specify your kernel version
> and attach your .config?

The kernel is basically 2.6.37-rc6, but I was able to reproduce this with
previous 2.6.37-rc too.

Attached are the full dmesg containing the traces I sent before and .config.

Thanks,
Rafael

--Boundary-00=_pP2CNhSnfd72tsi
Content-Type: text/x-log;
  charset="UTF-8";
  name="2.6.37-rc6.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2.6.37-rc6.log"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc6+ (rafael@chimera) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #12 SMP PREEMPT Thu Dec 16 22:15:53 CET 2010
[    0.000000] Command line: root=/dev/md0 resume=/dev/sda2 3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b000 (usable)
[    0.000000]  BIOS-e820: 000000000009b000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e90000 (usable)
[    0.000000]  BIOS-e820: 00000000c7e90000 - 00000000c7e9e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7e9e000 - 00000000c7ee0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ee0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: 890FXA-GD70 (MS-7640)  /MS-7640, BIOS V1.6 05/18/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000138000000 aka 4992M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc7e90 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7e90000
[    0.000000]  0000000000 - 00c7e90000 page 4k
[    0.000000] kernel direct mapping tables up to c7e90000 @ 1f9bb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 4k
[    0.000000] kernel direct mapping tables up to 138000000 @ c74ca000-c7e90000
[    0.000000] RAMDISK: 370fc000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fb6a0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000c7e90000 00044 (v01 MSI    OEMSLIC  20100518 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7e90200 00084 (v01 7640MS A7640100 20100518 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000c7e905e0 09F32 (v01  A7640 A7640100 00000100 INTL 20051117)
[    0.000000] ACPI: FACS 00000000c7e9e000 00040
[    0.000000] ACPI: APIC 00000000c7e90390 00088 (v01 7640MS A7640100 20100518 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7e90420 0003C (v01 7640MS OEMMCFG  20100518 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000c7e90460 00176 (v01 MSI    OEMSLIC  20100518 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7e9e040 00072 (v01 7640MS A7640100 20100518 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000c7e9a5e0 00108 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000c7e9a6f0 00038 (v01 7640MS OEMHPET  20100518 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7e9a730 00DA4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000c7e90
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 1048091
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3917 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800456 pages, LIFO batch:31
[    0.000000]   Normal zone: 3136 pages used for memmap
[    0.000000]   Normal zone: 226240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7e90000 - 00000000c7e9e000
[    0.000000] PM: Registered nosave memory: 00000000c7e9e000 - 00000000c7ee0000
[    0.000000] PM: Registered nosave memory: 00000000c7ee0000 - 00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c7f00000 (gap: c7f00000:37f00000)
[    0.000000] setup_percpu: NR_CPUS:6 nr_cpumask_bits:6 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800c7c00000 s75200 r8192 d23104 u262144
[    0.000000] pcpu-alloc: s75200 r8192 d23104 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030613
[    0.000000] Kernel command line: root=/dev/md0 resume=/dev/sda2 3
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ bc000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ bc000000
[    0.000000] PM: Registered nosave memory: 00000000bc000000 - 00000000c0000000
[    0.000000] Memory: 3951492k/5111808k available (4707k kernel code, 919444k absent, 240872k reserved, 6114k data, 496k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:448
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3200.187 MHz processor.
[    0.003348] Calibrating delay loop (skipped), value calculated using timer frequency.. 6402.05 BogoMIPS (lpj=10667290)
[    0.003418] pid_max: default: 32768 minimum: 301
[    0.003492] Security Framework initialized
[    0.003532] SELinux:  Initializing.
[    0.003588] SELinux:  Starting in permissive mode
[    0.003590] AppArmor: AppArmor disabled by boot time parameter
[    0.003655] Mount-cache hash table entries: 256
[    0.004453] tseg: 0000000000
[    0.004457] CPU: Physical Processor ID: 0
[    0.004503] CPU: Processor Core ID: 0
[    0.004537] mce: CPU supports 6 MCE banks
[    0.004577] Performance Events: AMD PMU driver.
[    0.004642] ... version:                0
[    0.004675] ... bit width:              48
[    0.004709] ... generic registers:      4
[    0.004743] ... value mask:             0000ffffffffffff
[    0.004777] ... max period:             00007fffffffffff
[    0.004811] ... fixed-purpose events:   0
[    0.006669] ... event mask:             000000000000000f
[    0.006769] ACPI: Core revision 20101013
[    0.016824] Setting APIC routing to flat
[    0.017181] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.051788] CPU0: AMD Phenom(tm) II X6 1090T Processor stepping 00
[    0.066710] lockdep: fixing up alternatives.
[    0.070222] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.173496]  #2lockdep: fixing up alternatives.
[    0.276832]  #3lockdep: fixing up alternatives.
[    0.380194]  #4lockdep: fixing up alternatives.
[    0.483541]  #5 Ok.
[    0.580031] Brought up 6 CPUs
[    0.580077] Total of 6 processors activated (38418.37 BogoMIPS).
[    0.583428] devtmpfs: initialized
[    0.583586] kworker/u:0 used greatest stack depth: 4968 bytes left
[    0.583619] Time: 22:46:23  Date: 12/16/10
[    0.583619] NET: Registered protocol family 16
[    0.583705] node 0 link 0: io port [1000, ffffff]
[    0.583705] TOM: 00000000c8000000 aka 3200M
[    0.583705] Fam 10h mmconf [e0000000, efffffff]
[    0.583705] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.583705] node 0 link 0: mmio [f0000000, ffffffff]
[    0.583705] node 0 link 0: mmio [a0000, bffff]
[    0.583705] node 0 link 0: mmio [c8000000, dfffffff]
[    0.583705] TOM2: 0000000138000000 aka 4992M
[    0.583705] bus: [00, 07] on node 0 link 0
[    0.583705] bus: 00 index 0 [io  0x0000-0xffff]
[    0.583705] bus: 00 index 1 [mem 0xf0000000-0xffffffff]
[    0.583705] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.583705] bus: 00 index 3 [mem 0xc8000000-0xdfffffff]
[    0.583705] bus: 00 index 4 [mem 0x138000000-0xfcffffffff]
[    0.583705] ACPI: bus type pci registered
[    0.583705] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.583705] PCI: not using MMCONFIG
[    0.583705] PCI: Using configuration type 1 for base access
[    0.583705] PCI: Using configuration type 1 for extended access
[    0.590050] bio: create slab <bio-0> at 0
[    0.595956] ACPI: EC: Look up EC in DSDT
[    0.599205] ACPI: Executed 3 blocks of module-level executable AML code
[    0.620799] ACPI: Interpreter enabled
[    0.620836] ACPI: (supports S0 S3 S4 S5)
[    0.621024] ACPI: Using IOAPIC for interrupt routing
[    0.621096] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.622921] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.660357] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.660357] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.663672] ACPI: No dock devices found.
[    0.663672] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.664095] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.664281] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.664281] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.664281] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.664281] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.664281] pci_root PNP0A03:00: host bridge window [mem 0xc8000000-0xdfffffff]
[    0.664281] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.666678] pci_bus 0000:00: scanning bus
[    0.666711] pci 0000:00:00.0: [1002:5a11] type 0 class 0x000600
[    0.666716] pci 0000:00:00.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666719] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666741] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.666821] pci 0000:00:03.0: [1002:5a17] type 1 class 0x000604
[    0.666823] pci 0000:00:03.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666825] pci 0000:00:03.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666851] pci 0000:00:03.0: calling quirk_resource_alignment+0x0/0x166
[    0.666866] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.666869] pci 0000:00:03.0: PME# disabled
[    0.666885] pci 0000:00:04.0: [1002:5a18] type 1 class 0x000604
[    0.666888] pci 0000:00:04.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666890] pci 0000:00:04.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666923] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x166
[    0.666936] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.666939] pci 0000:00:04.0: PME# disabled
[    0.666953] pci 0000:00:05.0: [1002:5a19] type 1 class 0x000604
[    0.666955] pci 0000:00:05.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666957] pci 0000:00:05.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666980] pci 0000:00:05.0: calling quirk_resource_alignment+0x0/0x166
[    0.666993] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.666995] pci 0000:00:05.0: PME# disabled
[    0.667010] pci 0000:00:06.0: [1002:5a1a] type 1 class 0x000604
[    0.667012] pci 0000:00:06.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667014] pci 0000:00:06.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667036] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x166
[    0.667050] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.667052] pci 0000:00:06.0: PME# disabled
[    0.667082] pci 0000:00:09.0: [1002:5a1c] type 1 class 0x000604
[    0.667084] pci 0000:00:09.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667086] pci 0000:00:09.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667108] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x166
[    0.667122] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.667124] pci 0000:00:09.0: PME# disabled
[    0.667153] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.667162] pci 0000:00:11.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667164] pci 0000:00:11.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667175] pci 0000:00:11.0: reg 10: [io  0x8000-0x8007]
[    0.667183] pci 0000:00:11.0: reg 14: [io  0x7000-0x7003]
[    0.667192] pci 0000:00:11.0: reg 18: [io  0x6000-0x6007]
[    0.667200] pci 0000:00:11.0: reg 1c: [io  0x5000-0x5003]
[    0.667208] pci 0000:00:11.0: reg 20: [io  0x3000-0x300f]
[    0.667217] pci 0000:00:11.0: reg 24: [mem 0xfe3ff000-0xfe3ff3ff]
[    0.667230] pci 0000:00:11.0: calling quirk_resource_alignment+0x0/0x166
[    0.667270] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.667273] pci 0000:00:12.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667275] pci 0000:00:12.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667285] pci 0000:00:12.0: reg 10: [mem 0xfe3f7000-0xfe3f7fff]
[    0.667333] pci 0000:00:12.0: calling quirk_resource_alignment+0x0/0x166
[    0.667351] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.667359] pci 0000:00:12.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.667361] pci 0000:00:12.2: calling quirk_mmio_always_on+0x0/0x17
[    0.667371] pci 0000:00:12.2: reg 10: [mem 0xfe3ff400-0xfe3ff4ff]
[    0.667419] pci 0000:00:12.2: calling quirk_resource_alignment+0x0/0x166
[    0.667437] pci 0000:00:12.2: supports D1 D2
[    0.667439] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.667442] pci 0000:00:12.2: PME# disabled
[    0.667463] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.667466] pci 0000:00:13.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667468] pci 0000:00:13.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667478] pci 0000:00:13.0: reg 10: [mem 0xfe3fc000-0xfe3fcfff]
[    0.667526] pci 0000:00:13.0: calling quirk_resource_alignment+0x0/0x166
[    0.667544] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.667552] pci 0000:00:13.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.667554] pci 0000:00:13.2: calling quirk_mmio_always_on+0x0/0x17
[    0.667565] pci 0000:00:13.2: reg 10: [mem 0xfe3ff800-0xfe3ff8ff]
[    0.667613] pci 0000:00:13.2: calling quirk_resource_alignment+0x0/0x166
[    0.667631] pci 0000:00:13.2: supports D1 D2
[    0.667632] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.667635] pci 0000:00:13.2: PME# disabled
[    0.667654] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.667656] pci 0000:00:14.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667658] pci 0000:00:14.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667661] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x50
[    0.667717] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0x10
[    0.667719] pci 0000:00:14.0: calling quirk_resource_alignment+0x0/0x166
[    0.667735] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.667741] pci 0000:00:14.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.667743] pci 0000:00:14.2: calling quirk_mmio_always_on+0x0/0x17
[    0.667757] pci 0000:00:14.2: reg 10: [mem 0xfe3f8000-0xfe3fbfff 64bit]
[    0.667799] pci 0000:00:14.2: calling quirk_resource_alignment+0x0/0x166
[    0.667813] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.667816] pci 0000:00:14.2: PME# disabled
[    0.667827] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.667830] pci 0000:00:14.3: calling quirk_no_ata_d3+0x0/0x1b
[    0.667832] pci 0000:00:14.3: calling quirk_mmio_always_on+0x0/0x17
[    0.667889] pci 0000:00:14.3: calling quirk_resource_alignment+0x0/0x166
[    0.667901] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.667903] pci 0000:00:14.4: calling quirk_no_ata_d3+0x0/0x1b
[    0.667905] pci 0000:00:14.4: calling quirk_mmio_always_on+0x0/0x17
[    0.667931] pci 0000:00:14.4: calling quirk_resource_alignment+0x0/0x166
[    0.667943] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.667946] pci 0000:00:14.5: calling quirk_no_ata_d3+0x0/0x1b
[    0.667947] pci 0000:00:14.5: calling quirk_mmio_always_on+0x0/0x17
[    0.667958] pci 0000:00:14.5: reg 10: [mem 0xfe3fd000-0xfe3fdfff]
[    0.668008] pci 0000:00:14.5: calling quirk_resource_alignment+0x0/0x166
[    0.668026] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.668029] pci 0000:00:15.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.668030] pci 0000:00:15.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668065] pci 0000:00:15.0: calling quirk_resource_alignment+0x0/0x166
[    0.668085] pci 0000:00:15.0: supports D1 D2
[    0.668106] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.668108] pci 0000:00:15.1: calling quirk_no_ata_d3+0x0/0x1b
[    0.668110] pci 0000:00:15.1: calling quirk_mmio_always_on+0x0/0x17
[    0.668144] pci 0000:00:15.1: calling quirk_resource_alignment+0x0/0x166
[    0.668164] pci 0000:00:15.1: supports D1 D2
[    0.668188] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.668191] pci 0000:00:16.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.668192] pci 0000:00:16.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668203] pci 0000:00:16.0: reg 10: [mem 0xfe3fe000-0xfe3fefff]
[    0.668251] pci 0000:00:16.0: calling quirk_resource_alignment+0x0/0x166
[    0.668269] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.668277] pci 0000:00:16.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.668278] pci 0000:00:16.2: calling quirk_mmio_always_on+0x0/0x17
[    0.668289] pci 0000:00:16.2: reg 10: [mem 0xfe3ffc00-0xfe3ffcff]
[    0.668337] pci 0000:00:16.2: calling quirk_resource_alignment+0x0/0x166
[    0.668355] pci 0000:00:16.2: supports D1 D2
[    0.668356] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.668360] pci 0000:00:16.2: PME# disabled
[    0.668378] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.668380] pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668396] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x166
[    0.668417] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.668419] pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x17
[    0.668435] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x166
[    0.668442] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.668444] pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x17
[    0.668459] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x166
[    0.668468] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.668470] pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x17
[    0.668485] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x166
[    0.668496] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.668498] pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x17
[    0.668514] pci 0000:00:18.4: calling quirk_resource_alignment+0x0/0x166
[    0.668528] pci_bus 0000:00: fixups for bus
[    0.668530] pci 0000:00:03.0: scanning [bus 08-08] behind bridge, pass 0
[    0.668558] pci_bus 0000:08: scanning bus
[    0.668569] pci 0000:08:00.0: [1002:68da] type 0 class 0x000300
[    0.668572] pci 0000:08:00.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.668573] pci 0000:08:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668586] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.668597] pci 0000:08:00.0: reg 18: [mem 0xfe9c0000-0xfe9dffff 64bit]
[    0.668605] pci 0000:08:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.668618] pci 0000:08:00.0: reg 30: [mem 0xfe9a0000-0xfe9bffff pref]
[    0.668624] pci 0000:08:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.668641] pci 0000:08:00.0: supports D1 D2
[    0.668661] pci 0000:08:00.1: [1002:aa60] type 0 class 0x000403
[    0.668663] pci 0000:08:00.1: calling quirk_no_ata_d3+0x0/0x1b
[    0.668665] pci 0000:08:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.668678] pci 0000:08:00.1: reg 10: [mem 0xfe9fc000-0xfe9fffff 64bit]
[    0.668714] pci 0000:08:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.668730] pci 0000:08:00.1: supports D1 D2
[    0.673445] pci_bus 0000:08: fixups for bus
[    0.673456] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.673520] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.673531] pci 0000:00:03.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.673546] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.673553] pci_bus 0000:08: bus scan returning with max=08
[    0.673565] pci 0000:00:04.0: scanning [bus 07-07] behind bridge, pass 0
[    0.673623] pci_bus 0000:07: scanning bus
[    0.673641] pci 0000:07:00.0: [1106:3403] type 0 class 0x000c00
[    0.673645] pci 0000:07:00.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.673647] pci 0000:07:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.673665] pci 0000:07:00.0: reg 10: [mem 0xfe8ff800-0xfe8fffff 64bit]
[    0.673675] pci 0000:07:00.0: reg 18: [io  0xd800-0xd8ff]
[    0.673717] pci 0000:07:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.673743] pci 0000:07:00.0: supports D2
[    0.673744] pci 0000:07:00.0: PME# supported from D2 D3hot D3cold
[    0.673748] pci 0000:07:00.0: PME# disabled
[    0.680070] pci_bus 0000:07: fixups for bus
[    0.680079] pci 0000:00:04.0: PCI bridge to [bus 07-07]
[    0.680142] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.680152] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.680166] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.680173] pci_bus 0000:07: bus scan returning with max=07
[    0.680185] pci 0000:00:05.0: scanning [bus 06-06] behind bridge, pass 0
[    0.680277] pci_bus 0000:06: scanning bus
[    0.680297] pci 0000:06:00.0: [10ec:8168] type 0 class 0x000200
[    0.680301] pci 0000:06:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.680314] pci 0000:06:00.0: reg 10: [io  0xc800-0xc8ff]
[    0.680338] pci 0000:06:00.0: reg 18: [mem 0xcffff000-0xcfffffff 64bit pref]
[    0.680353] pci 0000:06:00.0: reg 20: [mem 0xcfff8000-0xcfffbfff 64bit pref]
[    0.680363] pci 0000:06:00.0: reg 30: [mem 0xfe7e0000-0xfe7fffff pref]
[    0.680371] pci 0000:06:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.680402] pci 0000:06:00.0: supports D1 D2
[    0.680403] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.680407] pci 0000:06:00.0: PME# disabled
[    0.686739] pci_bus 0000:06: fixups for bus
[    0.686749] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    0.686811] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.686820] pci 0000:00:05.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.686834] pci 0000:00:05.0:   bridge window [mem 0xcff00000-0xcfffffff 64bit pref]
[    0.686840] pci_bus 0000:06: bus scan returning with max=06
[    0.686852] pci 0000:00:06.0: scanning [bus 05-05] behind bridge, pass 0
[    0.686936] pci_bus 0000:05: scanning bus
[    0.686960] pci 0000:05:00.0: [10ec:8168] type 0 class 0x000200
[    0.686964] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.686977] pci 0000:05:00.0: reg 10: [io  0xb800-0xb8ff]
[    0.687000] pci 0000:05:00.0: reg 18: [mem 0xcfeff000-0xcfefffff 64bit pref]
[    0.687015] pci 0000:05:00.0: reg 20: [mem 0xcfef8000-0xcfefbfff 64bit pref]
[    0.687025] pci 0000:05:00.0: reg 30: [mem 0xfe6e0000-0xfe6fffff pref]
[    0.687032] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.687063] pci 0000:05:00.0: supports D1 D2
[    0.687065] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.687069] pci 0000:05:00.0: PME# disabled
[    0.693403] pci_bus 0000:05: fixups for bus
[    0.693412] pci 0000:00:06.0: PCI bridge to [bus 05-05]
[    0.693475] pci 0000:00:06.0:   bridge window [io  0xb000-0xbfff]
[    0.693485] pci 0000:00:06.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.693499] pci 0000:00:06.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.693505] pci_bus 0000:05: bus scan returning with max=05
[    0.693517] pci 0000:00:09.0: scanning [bus 04-04] behind bridge, pass 0
[    0.693602] pci_bus 0000:04: scanning bus
[    0.693627] pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
[    0.693631] pci 0000:04:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.693647] pci 0000:04:00.0: reg 10: [mem 0xfe5fe000-0xfe5fffff 64bit]
[    0.693693] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.693721] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.693725] pci 0000:04:00.0: PME# disabled
[    0.700068] pci_bus 0000:04: fixups for bus
[    0.700078] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    0.700140] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.700151] pci 0000:00:09.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.700164] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700171] pci_bus 0000:04: bus scan returning with max=04
[    0.700186] pci 0000:00:14.4: scanning [bus 03-03] behind bridge, pass 0
[    0.700214] pci_bus 0000:03: scanning bus
[    0.700290] pci_bus 0000:03: fixups for bus
[    0.700291] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.700330] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.700333] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.700337] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700340] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.700341] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.700344] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.700346] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.700348] pci 0000:00:14.4:   bridge window [mem 0xc8000000-0xdfffffff] (subtractive decode)
[    0.700350] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.700352] pci_bus 0000:03: bus scan returning with max=03
[    0.700355] pci 0000:00:15.0: scanning [bus 02-02] behind bridge, pass 0
[    0.700399] pci_bus 0000:02: scanning bus
[    0.700401] pci_bus 0000:02: fixups for bus
[    0.700403] pci 0000:00:15.0: PCI bridge to [bus 02-02]
[    0.700442] pci 0000:00:15.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.700445] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.700450] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700452] pci_bus 0000:02: bus scan returning with max=02
[    0.700456] pci 0000:00:15.1: scanning [bus 01-01] behind bridge, pass 0
[    0.700499] pci_bus 0000:01: scanning bus
[    0.700518] pci 0000:01:00.0: [197b:2363] type 0 class 0x000101
[    0.700523] pci 0000:01:00.0: calling quirk_jmicron_ata+0x0/0x140
[    0.700537] pci 0000:01:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.700619] pci 0000:01:00.0: reg 24: [mem 0xfe4fe000-0xfe4fffff]
[    0.700640] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.700668] pci 0000:01:00.0: PME# supported from D3hot
[    0.700673] pci 0000:01:00.0: PME# disabled
[    0.700704] pci 0000:01:00.1: [197b:2363] type 0 class 0x000101
[    0.700713] pci 0000:01:00.1: calling quirk_jmicron_ata+0x0/0x140
[    0.700715] pci 0000:01:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.700734] pci 0000:01:00.1: reg 10: [io  0xa800-0xa807]
[    0.700747] pci 0000:01:00.1: reg 14: [io  0xa400-0xa403]
[    0.700761] pci 0000:01:00.1: reg 18: [io  0xa000-0xa007]
[    0.700774] pci 0000:01:00.1: reg 1c: [io  0x9800-0x9803]
[    0.700788] pci 0000:01:00.1: reg 20: [io  0x9400-0x940f]
[    0.700821] pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.700863] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.700915] pci_bus 0000:01: fixups for bus
[    0.700916] pci 0000:00:15.1: PCI bridge to [bus 01-01]
[    0.700954] pci 0000:00:15.1:   bridge window [io  0x9000-0xafff]
[    0.700957] pci 0000:00:15.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.700962] pci 0000:00:15.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700963] pci_bus 0000:01: bus scan returning with max=01
[    0.700967] pci 0000:00:03.0: scanning [bus 08-08] behind bridge, pass 1
[    0.700970] pci 0000:00:04.0: scanning [bus 07-07] behind bridge, pass 1
[    0.700974] pci 0000:00:05.0: scanning [bus 06-06] behind bridge, pass 1
[    0.700977] pci 0000:00:06.0: scanning [bus 05-05] behind bridge, pass 1
[    0.700980] pci 0000:00:09.0: scanning [bus 04-04] behind bridge, pass 1
[    0.700985] pci 0000:00:14.4: scanning [bus 03-03] behind bridge, pass 1
[    0.700990] pci 0000:00:15.0: scanning [bus 02-02] behind bridge, pass 1
[    0.700994] pci 0000:00:15.1: scanning [bus 01-01] behind bridge, pass 1
[    0.700998] pci_bus 0000:00: bus scan returning with max=08
[    0.701000] pci_bus 0000:00: on NUMA node 0
[    0.701004] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.701304] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC03._PRT]
[    0.701361] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC04._PRT]
[    0.701417] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC05._PRT]
[    0.701475] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC06._PRT]
[    0.701535] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC09._PRT]
[    0.701626] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.701737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.701796] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.720287] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 14 15)
[    0.720477] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 14 15)
[    0.720844] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 14 15)
[    0.721210] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 14 15)
[    0.721557] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 14 15)
[    0.723600] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 14 15)
[    0.723943] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 14 15)
[    0.724270] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.724596] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.724596] vgaarb: loaded
[    0.724596] SCSI subsystem initialized
[    0.724596] libata version 3.00 loaded.
[    0.724596] usbcore: registered new interface driver usbfs
[    0.724596] usbcore: registered new interface driver hub
[    0.724596] usbcore: registered new device driver usb
[    0.724596] PCI: Using ACPI for IRQ routing
[    0.724596] PCI: pci_cache_line_size set to 64 bytes
[    0.724596] pci 0000:00:11.0: BAR 0: reserving [io  0x8000-0x8007 flags 0x40101] (d=0, p=0)
[    0.724596] pci 0000:00:11.0: BAR 1: reserving [io  0x7000-0x7003 flags 0x40101] (d=0, p=0)
[    0.724596] pci 0000:00:11.0: BAR 2: reserving [io  0x6000-0x6007 flags 0x40101] (d=0, p=0)
[    0.724596] pci 0000:00:11.0: BAR 3: reserving [io  0x5000-0x5003 flags 0x40101] (d=0, p=0)
[    0.724596] pci 0000:00:11.0: BAR 4: reserving [io  0x3000-0x300f flags 0x40101] (d=0, p=0)
[    0.724596] pci 0000:00:11.0: BAR 5: reserving [mem 0xfe3ff000-0xfe3ff3ff flags 0x40200] (d=0, p=0)
[    0.724596] pci 0000:00:12.0: BAR 0: reserving [mem 0xfe3f7000-0xfe3f7fff flags 0x40200] (d=0, p=0)
[    0.724596] pci 0000:00:12.2: BAR 0: reserving [mem 0xfe3ff400-0xfe3ff4ff flags 0x40200] (d=0, p=0)
[    0.724596] pci 0000:00:13.0: BAR 0: reserving [mem 0xfe3fc000-0xfe3fcfff flags 0x40200] (d=0, p=0)
[    0.724596] pci 0000:00:13.2: BAR 0: reserving [mem 0xfe3ff800-0xfe3ff8ff flags 0x40200] (d=0, p=0)
[    0.724596] pci 0000:00:14.2: BAR 0: reserving [mem 0xfe3f8000-0xfe3fbfff flags 0x140204] (d=0, p=0)
[    0.724596] pci 0000:00:14.5: BAR 0: reserving [mem 0xfe3fd000-0xfe3fdfff flags 0x40200] (d=0, p=0)
[    0.726676] pci 0000:00:16.0: BAR 0: reserving [mem 0xfe3fe000-0xfe3fefff flags 0x40200] (d=0, p=0)
[    0.726680] pci 0000:00:16.2: BAR 0: reserving [mem 0xfe3ffc00-0xfe3ffcff flags 0x40200] (d=0, p=0)
[    0.726691] pci 0000:08:00.0: BAR 0: reserving [mem 0xd0000000-0xdfffffff flags 0x14220c] (d=0, p=0)
[    0.726694] pci 0000:08:00.0: BAR 2: reserving [mem 0xfe9c0000-0xfe9dffff flags 0x140204] (d=0, p=0)
[    0.726696] pci 0000:08:00.0: BAR 4: reserving [io  0xe000-0xe0ff flags 0x40101] (d=0, p=0)
[    0.726700] pci 0000:08:00.1: BAR 0: reserving [mem 0xfe9fc000-0xfe9fffff flags 0x140204] (d=0, p=0)
[    0.726705] pci 0000:07:00.0: BAR 0: reserving [mem 0xfe8ff800-0xfe8fffff flags 0x140204] (d=0, p=0)
[    0.726707] pci 0000:07:00.0: BAR 2: reserving [io  0xd800-0xd8ff flags 0x40101] (d=0, p=0)
[    0.726716] pci 0000:06:00.0: BAR 0: reserving [io  0xc800-0xc8ff flags 0x40101] (d=0, p=0)
[    0.726721] pci 0000:06:00.0: BAR 2: reserving [mem 0xcffff000-0xcfffffff flags 0x14220c] (d=0, p=0)
[    0.726726] pci 0000:06:00.0: BAR 4: reserving [mem 0xcfff8000-0xcfffbfff flags 0x14220c] (d=0, p=0)
[    0.726743] pci 0000:05:00.0: BAR 0: reserving [io  0xb800-0xb8ff flags 0x40101] (d=0, p=0)
[    0.726745] pci 0000:05:00.0: BAR 2: reserving [mem 0xcfeff000-0xcfefffff flags 0x14220c] (d=0, p=0)
[    0.726748] pci 0000:05:00.0: BAR 4: reserving [mem 0xcfef8000-0xcfefbfff flags 0x14220c] (d=0, p=0)
[    0.726753] pci 0000:04:00.0: BAR 0: reserving [mem 0xfe5fe000-0xfe5fffff flags 0x140204] (d=0, p=0)
[    0.726758] pci 0000:01:00.0: BAR 5: reserving [mem 0xfe4fe000-0xfe4fffff flags 0x40200] (d=0, p=0)
[    0.726828] pci 0000:01:00.1: BAR 0: reserving [io  0xa800-0xa807 flags 0x40101] (d=1, p=1)
[    0.726830] pci 0000:01:00.1: BAR 1: reserving [io  0xa400-0xa403 flags 0x40101] (d=1, p=1)
[    0.726832] pci 0000:01:00.1: BAR 2: reserving [io  0xa000-0xa007 flags 0x40101] (d=1, p=1)
[    0.726835] pci 0000:01:00.1: BAR 3: reserving [io  0x9800-0x9803 flags 0x40101] (d=1, p=1)
[    0.726837] pci 0000:01:00.1: BAR 4: reserving [io  0x9400-0x940f flags 0x40101] (d=1, p=1)
[    0.726841] reserve RAM buffer: 000000000009b000 - 000000000009ffff 
[    0.726849] reserve RAM buffer: 00000000c7e90000 - 00000000c7ffffff 
[    0.726877] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.726883] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.728981] Switching to clocksource tsc
[    0.729330] pnp: PnP ACPI init
[    0.729330] ACPI: bus type pnp registered
[    0.729330] pnp 00:00: [bus 00-ff]
[    0.729330] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.729330] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.729330] pnp 00:00: [io  0x0d00-0xffff window]
[    0.729330] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.729330] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.729330] pnp 00:00: [mem 0xc8000000-0xdfffffff window]
[    0.729330] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.729330] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.729330] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.729330] pnp 00:01: [mem 0xfec20000-0xfec200ff]
[    0.729330] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.729330] pnp 00:02: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.729330] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.729330] pnp 00:03: [dma 4]
[    0.729330] pnp 00:03: [io  0x0000-0x000f]
[    0.729330] pnp 00:03: [io  0x0081-0x0083]
[    0.729330] pnp 00:03: [io  0x0087]
[    0.729330] pnp 00:03: [io  0x0089-0x008b]
[    0.729330] pnp 00:03: [io  0x008f]
[    0.729330] pnp 00:03: [io  0x00c0-0x00df]
[    0.729330] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.729330] pnp 00:04: [io  0x0070-0x0071]
[    0.729330] pnp 00:04: [irq 8]
[    0.729330] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.729330] pnp 00:05: [io  0x0061]
[    0.729330] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.729330] pnp 00:06: [io  0x00f0-0x00ff]
[    0.729330] pnp 00:06: [irq 13]
[    0.729330] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.729330] pnp 00:07: [io  0x03f8-0x03ff]
[    0.729330] pnp 00:07: [irq 4]
[    0.729330] pnp 00:07: [dma 0 disabled]
[    0.729330] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.729373] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.729375] pnp 00:08: [io  0x0600-0x06df]
[    0.729376] pnp 00:08: [io  0x0ae0-0x0aef]
[    0.729558] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.729594] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.729698] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.729832] pnp 00:0a: [io  0x0060]
[    0.729834] pnp 00:0a: [io  0x0064]
[    0.729835] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.729836] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    0.730021] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.730269] pnp 00:0b: [io  0x0010-0x001f]
[    0.730271] pnp 00:0b: [io  0x0022-0x003f]
[    0.730272] pnp 00:0b: [io  0x0062-0x0063]
[    0.730273] pnp 00:0b: [io  0x0065-0x006f]
[    0.730275] pnp 00:0b: [io  0x0072-0x007f]
[    0.730276] pnp 00:0b: [io  0x0080]
[    0.730277] pnp 00:0b: [io  0x0084-0x0086]
[    0.730279] pnp 00:0b: [io  0x0088]
[    0.730280] pnp 00:0b: [io  0x008c-0x008e]
[    0.730281] pnp 00:0b: [io  0x0090-0x009f]
[    0.730282] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.730284] pnp 00:0b: [io  0x00b1]
[    0.730285] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.730286] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.730288] pnp 00:0b: [io  0x040b]
[    0.730289] pnp 00:0b: [io  0x04d6]
[    0.730290] pnp 00:0b: [io  0x0c00-0x0c01]
[    0.730291] pnp 00:0b: [io  0x0c14]
[    0.730293] pnp 00:0b: [io  0x0c50-0x0c51]
[    0.730294] pnp 00:0b: [io  0x0c52]
[    0.730295] pnp 00:0b: [io  0x0c6c]
[    0.730296] pnp 00:0b: [io  0x0c6f]
[    0.730298] pnp 00:0b: [io  0x0cd0-0x0cd1]
[    0.730299] pnp 00:0b: [io  0x0cd2-0x0cd3]
[    0.730300] pnp 00:0b: [io  0x0cd4-0x0cd5]
[    0.730302] pnp 00:0b: [io  0x0cd6-0x0cd7]
[    0.730303] pnp 00:0b: [io  0x0cd8-0x0cdf]
[    0.730304] pnp 00:0b: [io  0x0800-0x089f]
[    0.730306] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.730307] pnp 00:0b: [io  0x0b00-0x0b1f]
[    0.730309] pnp 00:0b: [io  0x0b20-0x0b3f]
[    0.730319] pnp 00:0b: [io  0x0900-0x090f]
[    0.730327] pnp 00:0b: [io  0x0910-0x091f]
[    0.730329] pnp 00:0b: [io  0xfe00-0xfefe]
[    0.730330] pnp 00:0b: [io  0x0060]
[    0.730332] pnp 00:0b: [io  0x0064]
[    0.730333] pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.730335] pnp 00:0b: [mem 0xffb80000-0xffbfffff]
[    0.730337] pnp 00:0b: [mem 0xfec10000-0xfec1001f]
[    0.730339] pnp 00:0b: [mem 0xfed80000-0xfed80fff]
[    0.730340] pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.730573] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.730645] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[    0.730801] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.731000] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.731002] pnp 00:0d: [mem 0x000c0000-0x000cffff]
[    0.731003] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.731005] pnp 00:0d: [mem 0x00100000-0xc7ffffff]
[    0.731006] pnp 00:0d: [mem 0xfec00000-0xffffffff]
[    0.731195] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.731333] pnp: PnP ACPI: found 14 devices
[    0.731370] ACPI: ACPI bus type pnp unregistered
[    0.731420] system 00:01: [mem 0xfec20000-0xfec200ff] could not be reserved
[    0.731465] system 00:08: [io  0x0600-0x06df] has been reserved
[    0.731501] system 00:08: [io  0x0ae0-0x0aef] has been reserved
[    0.731541] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.731577] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.731617] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.731652] system 00:0b: [io  0x040b] has been reserved
[    0.731687] system 00:0b: [io  0x04d6] has been reserved
[    0.731723] system 00:0b: [io  0x0c00-0x0c01] has been reserved
[    0.731758] system 00:0b: [io  0x0c14] has been reserved
[    0.731793] system 00:0b: [io  0x0c50-0x0c51] has been reserved
[    0.731828] system 00:0b: [io  0x0c52] has been reserved
[    0.731863] system 00:0b: [io  0x0c6c] has been reserved
[    0.731898] system 00:0b: [io  0x0c6f] has been reserved
[    0.731933] system 00:0b: [io  0x0cd0-0x0cd1] has been reserved
[    0.731969] system 00:0b: [io  0x0cd2-0x0cd3] has been reserved
[    0.732004] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
[    0.732039] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
[    0.732075] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
[    0.732110] system 00:0b: [io  0x0800-0x089f] has been reserved
[    0.732145] system 00:0b: [io  0x0b00-0x0b1f] has been reserved
[    0.732181] system 00:0b: [io  0x0b20-0x0b3f] has been reserved
[    0.732216] system 00:0b: [io  0x0900-0x090f] has been reserved
[    0.732251] system 00:0b: [io  0x0910-0x091f] has been reserved
[    0.732287] system 00:0b: [io  0xfe00-0xfefe] has been reserved
[    0.732323] system 00:0b: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.732359] system 00:0b: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.732394] system 00:0b: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.732434] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.732474] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.732510] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.732546] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.732583] system 00:0d: [mem 0x00100000-0xc7ffffff] could not be reserved
[    0.732619] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.743716] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.743754] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.743791] pci 0000:00:03.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.743833] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.743874] pci 0000:00:04.0: PCI bridge to [bus 07-07]
[    0.743909] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.743946] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.743983] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.744021] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    0.744056] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.744094] pci 0000:00:05.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.744136] pci 0000:00:05.0:   bridge window [mem 0xcff00000-0xcfffffff 64bit pref]
[    0.744176] pci 0000:00:06.0: PCI bridge to [bus 05-05]
[    0.744211] pci 0000:00:06.0:   bridge window [io  0xb000-0xbfff]
[    0.744248] pci 0000:00:06.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.744284] pci 0000:00:06.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.744324] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    0.744359] pci 0000:00:09.0:   bridge window [io  disabled]
[    0.744395] pci 0000:00:09.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.744431] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    0.744468] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.744503] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.744540] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.744576] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.744615] pci 0000:00:15.0: PCI bridge to [bus 02-02]
[    0.744649] pci 0000:00:15.0:   bridge window [io  disabled]
[    0.744686] pci 0000:00:15.0:   bridge window [mem disabled]
[    0.744722] pci 0000:00:15.0:   bridge window [mem pref disabled]
[    0.744760] pci 0000:00:15.1: PCI bridge to [bus 01-01]
[    0.744796] pci 0000:00:15.1:   bridge window [io  0x9000-0xafff]
[    0.744833] pci 0000:00:15.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.744869] pci 0000:00:15.1:   bridge window [mem pref disabled]
[    0.744917] pci 0000:00:03.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    0.744954] pci 0000:00:03.0: setting latency timer to 64
[    0.744958] pci 0000:00:04.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    0.744995] pci 0000:00:04.0: setting latency timer to 64
[    0.744999] pci 0000:00:05.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    0.745035] pci 0000:00:05.0: setting latency timer to 64
[    0.745042] pci 0000:00:06.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    0.745078] pci 0000:00:06.0: setting latency timer to 64
[    0.745082] pci 0000:00:09.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    0.745119] pci 0000:00:09.0: setting latency timer to 64
[    0.745130] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.745167] pci 0000:00:15.0: setting latency timer to 64
[    0.745172] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.745209] pci 0000:00:15.1: setting latency timer to 64
[    0.745212] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.745214] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.745215] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.745217] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.745218] pci_bus 0000:00: resource 8 [mem 0xc8000000-0xdfffffff]
[    0.745219] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.745221] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    0.745222] pci_bus 0000:08: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.745224] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.745225] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.745227] pci_bus 0000:07: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.745228] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.745230] pci_bus 0000:06: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.745231] pci_bus 0000:06: resource 2 [mem 0xcff00000-0xcfffffff 64bit pref]
[    0.745233] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    0.745234] pci_bus 0000:05: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.745236] pci_bus 0000:05: resource 2 [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.745237] pci_bus 0000:04: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.745239] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.745240] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.745242] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.745243] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.745244] pci_bus 0000:03: resource 8 [mem 0xc8000000-0xdfffffff]
[    0.745246] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.745247] pci_bus 0000:01: resource 0 [io  0x9000-0xafff]
[    0.745249] pci_bus 0000:01: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.745289] NET: Registered protocol family 2
[    0.745459] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.746114] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.747194] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    0.749885] TCP: Hash tables configured (established 262144 bind 65536)
[    0.749948] TCP reno registered
[    0.750030] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.750345] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.750720] NET: Registered protocol family 1
[    0.750772] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750776] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750779] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xb0
[    0.750785] pci 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750787] pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750793] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xb0
[    0.750803] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750805] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750807] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xb0
[    0.750811] pci 0000:00:05.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750813] pci 0000:00:05.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750815] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xb0
[    0.750818] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750820] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750822] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xb0
[    0.750826] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750828] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750829] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xb0
[    0.750833] pci 0000:00:11.0: calling quirk_msi_intx_disable_ati_bug+0x0/0x41
[    0.750839] pci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750841] pci 0000:00:11.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750842] pci 0000:00:11.0: calling pci_fixup_video+0x0/0xb0
[    0.750846] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750848] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.510384] pci 0000:00:12.0: calling pci_fixup_video+0x0/0xb0
[    1.510411] pci 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.510421] pci 0000:00:12.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.510502] pci 0000:00:12.2: calling pci_fixup_video+0x0/0xb0
[    1.510519] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.510548] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.533714] pci 0000:00:13.0: calling pci_fixup_video+0x0/0xb0
[    1.533740] pci 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.533748] pci 0000:00:13.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.533824] pci 0000:00:13.2: calling pci_fixup_video+0x0/0xb0
[    1.533840] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.533848] pci 0000:00:14.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.533857] pci 0000:00:14.0: calling pci_fixup_video+0x0/0xb0
[    1.533884] pci 0000:00:14.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.533886] pci 0000:00:14.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.533888] pci 0000:00:14.2: calling pci_fixup_video+0x0/0xb0
[    1.533892] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.533894] pci 0000:00:14.3: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.533896] pci 0000:00:14.3: calling pci_fixup_video+0x0/0xb0
[    1.533901] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x30
[    1.533903] pci 0000:00:14.4: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.533905] pci 0000:00:14.4: calling pci_fixup_video+0x0/0xb0
[    1.533909] pci 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x30
[    1.533911] pci 0000:00:14.5: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.557044] pci 0000:00:14.5: calling pci_fixup_video+0x0/0xb0
[    1.557068] pci 0000:00:15.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.557077] pci 0000:00:15.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.557085] pci 0000:00:15.0: calling pci_fixup_video+0x0/0xb0
[    1.557100] pci 0000:00:15.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.557109] pci 0000:00:15.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.557117] pci 0000:00:15.1: calling pci_fixup_video+0x0/0xb0
[    1.557132] pci 0000:00:16.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.557140] pci 0000:00:16.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580377] pci 0000:00:16.0: calling pci_fixup_video+0x0/0xb0
[    1.580403] pci 0000:00:16.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.580412] pci 0000:00:16.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580489] pci 0000:00:16.2: calling pci_fixup_video+0x0/0xb0
[    1.580506] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580515] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580523] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xb0
[    1.580551] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.580553] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580555] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xb0
[    1.580559] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.580561] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580563] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xb0
[    1.580567] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.580569] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580571] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xb0
[    1.580575] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x30
[    1.580577] pci 0000:00:18.4: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580579] pci 0000:00:18.4: calling pci_fixup_video+0x0/0xb0
[    1.580583] pci 0000:08:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580585] pci 0000:08:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580587] pci 0000:08:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580590] pci 0000:08:00.0: Boot video device
[    1.580594] pci 0000:08:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.580597] pci 0000:08:00.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580599] pci 0000:08:00.1: calling pci_fixup_video+0x0/0xb0
[    1.580603] pci 0000:07:00.0: calling via_no_dac+0x0/0x3b
[    1.580605] pci 0000:07:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580607] pci 0000:07:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580609] pci 0000:07:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580614] pci 0000:06:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580616] pci 0000:06:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580618] pci 0000:06:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580622] pci 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580625] pci 0000:05:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580627] pci 0000:05:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580631] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580633] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580656] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580661] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580663] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580665] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580670] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.580672] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580674] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xb0
[    1.580678] PCI: CLS 64 bytes, default 64
[    1.580817] Trying to unpack rootfs image as initramfs...
[    1.785251] debug: unmapping init memory ffff8800370fc000..ffff880037ff0000
[    1.786325] PCI-DMA: Disabling AGP.
[    1.786644] PCI-DMA: aperture base @ bc000000 size 65536 KB
[    1.786687] PCI-DMA: using GART IOMMU.
[    1.786723] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.806542] audit: initializing netlink socket (disabled)
[    1.806610] type=2000 audit(1292539583.803:1): initialized
[    1.807106] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.812604] VFS: Disk quotas dquot_6.5.2
[    1.812832] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.813371] msgmni has been set to 7846
[    1.813679] SELinux:  Registering netfilter hooks
[    1.814262] io scheduler noop registered
[    1.814299] io scheduler deadline registered
[    1.814516] io scheduler cfq registered (default)
[    1.815245] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1d
[    1.815291] pcieport 0000:00:03.0: setting latency timer to 64
[    1.815340] pcieport 0000:00:03.0: irq 72 for MSI/MSI-X
[    1.815502] pcieport 0000:00:04.0: ACPI _OSC control granted for 0x1d
[    1.815543] pcieport 0000:00:04.0: setting latency timer to 64
[    1.815570] pcieport 0000:00:04.0: irq 73 for MSI/MSI-X
[    1.815715] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1d
[    1.815756] pcieport 0000:00:05.0: setting latency timer to 64
[    1.815782] pcieport 0000:00:05.0: irq 74 for MSI/MSI-X
[    1.815928] pcieport 0000:00:06.0: ACPI _OSC control granted for 0x1d
[    1.815969] pcieport 0000:00:06.0: setting latency timer to 64
[    1.815996] pcieport 0000:00:06.0: irq 75 for MSI/MSI-X
[    1.816142] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1d
[    1.816183] pcieport 0000:00:09.0: setting latency timer to 64
[    1.816209] pcieport 0000:00:09.0: irq 76 for MSI/MSI-X
[    1.816361] pcieport 0000:00:15.0: ACPI _OSC control granted for 0x1d
[    1.816404] pcieport 0000:00:15.0: setting latency timer to 64
[    1.816445] pcieport 0000:00:15.0: irq 77 for MSI/MSI-X
[    1.816619] pcieport 0000:00:15.1: ACPI _OSC control granted for 0x1d
[    1.816661] pcieport 0000:00:15.1: setting latency timer to 64
[    1.816731] pcieport 0000:00:15.1: irq 78 for MSI/MSI-X
[    1.817068] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    1.817108] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[    1.817144] pci 0000:08:00.1: Signaling PME through PCIe PME interrupt
[    1.817185] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    1.817209] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    1.817245] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    1.817282] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    1.817308] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    1.817345] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    1.817381] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    1.817402] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    1.817438] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    1.817475] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.817497] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    1.817533] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.817570] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    1.817594] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.817632] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.817656] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.817692] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.817728] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    1.817765] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.868500] Linux agpgart interface v0.103
[    1.868616] [drm] Initialized drm 1.1.0 20060810
[    1.868754] [drm] radeon defaulting to kernel modesetting.
[    1.868790] [drm] radeon kernel modesetting enabled.
[    1.868904] radeon 0000:08:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    1.868945] radeon 0000:08:00.0: setting latency timer to 64
[    1.871547] [drm] initializing kernel modesetting (REDWOOD 0x1002:0x68DA).
[    1.871779] [drm] register mmio base: 0xFE9C0000
[    1.871815] [drm] register mmio size: 131072
[    1.872489] ATOM BIOS: REDWOOD
[    1.872570] radeon 0000:08:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    1.872612] radeon 0000:08:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    1.876010] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.876050] [drm] RAM width 128bits DDR
[    1.876454] [TTM] Zone  kernel: Available graphics memory: 2008722 kiB.
[    1.876492] [TTM] Initializing pool allocator.
[    1.876801] [drm] radeon: 1024M of VRAM memory ready
[    1.876839] [drm] radeon: 512M of GTT memory ready.
[    1.876978] radeon 0000:08:00.0: irq 79 for MSI/MSI-X
[    1.876984] radeon 0000:08:00.0: radeon: using MSI.
[    1.877076] [drm] radeon: irq initialized.
[    1.877111] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.877820] [drm] Loading REDWOOD Microcode
[    1.881027] radeon 0000:08:00.0: WB enabled
[    1.897955] [drm] ring test succeeded in 1 usecs
[    1.898689] [drm] radeon: ib pool ready.
[    1.899013] [drm] ib test succeeded in 0 usecs
[    1.899060] failed to evaluate ATIF got AE_BAD_PARAMETER
[    1.900323] [drm] Radeon Display Connectors
[    1.900358] [drm] Connector 0:
[    1.900392] [drm]   HDMI-A
[    1.900425] [drm]   HPD2
[    1.900459] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    1.900497] [drm]   Encoders:
[    1.900535] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.900569] [drm] Connector 1:
[    1.900602] [drm]   DVI-I
[    1.900634] [drm]   HPD1
[    1.900667] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    1.900705] [drm]   Encoders:
[    1.900738] [drm]     DFP2: INTERNAL_UNIPHY1
[    1.900772] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.900806] [drm] Connector 2:
[    1.900839] [drm]   VGA
[    1.900872] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.900909] [drm]   Encoders:
[    1.900942] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    1.958681] [drm] Internal thermal controller without fan control
[    1.958992] [drm] radeon: power management initialized
[    2.031879] [drm] fb mappable at 0xD0141000
[    2.031948] [drm] vram apper at 0xD0000000
[    2.031982] [drm] size 5914624
[    2.032015] [drm] fb depth is 24
[    2.032048] [drm]    pitch is 5632
[    2.265341] Console: switching to colour frame buffer device 175x65
[    2.269194] fb0: radeondrmfb frame buffer device
[    2.269215] drm: registered panic notifier
[    2.269259] [drm] Initialized radeon 2.7.0 20080528 for 0000:08:00.0 on minor 0
[    2.269437] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.290127] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.514808] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.570189] brd: module loaded
[    2.571819] loop: module loaded
[    2.572065] ahci 0000:00:11.0: version 3.0
[    2.572080] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.572152] ahci 0000:00:11.0: irq 80 for MSI/MSI-X
[    2.572301] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    2.572339] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    2.574829] scsi0 : ahci
[    2.575172] scsi1 : ahci
[    2.575380] scsi2 : ahci
[    2.575600] scsi3 : ahci
[    2.575806] scsi4 : ahci
[    2.576012] scsi5 : ahci
[    2.576193] ata1: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff100 irq 80
[    2.576228] ata2: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff180 irq 80
[    2.576262] ata3: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff200 irq 80
[    2.576296] ata4: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff280 irq 80
[    2.576330] ata5: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff300 irq 80
[    2.576364] ata6: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff380 irq 80
[    2.576492] ahci 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.586814] ahci 0000:01:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.586869] ahci 0000:01:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.586907] ahci 0000:01:00.0: setting latency timer to 64
[    2.588118] scsi6 : ahci
[    2.588519] scsi7 : ahci
[    2.588810] ata7: SATA max UDMA/133 abar m8192@0xfe4fe000 port 0xfe4fe100 irq 17
[    2.588846] ata8: SATA max UDMA/133 abar m8192@0xfe4fe000 port 0xfe4fe180 irq 17
[    2.589785] usbcore: registered new interface driver libusual
[    2.590094] PNP: No PS/2 controller found. Probing ports directly.
[    2.590646] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.590706] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.591446] mice: PS/2 mouse device common for all mice
[    2.592810] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    2.594197] md: raid1 personality registered for level 1
[    2.595001] md: multipath personality registered for level -4
[    2.595825] cpuidle: using governor ladder
[    2.596637] cpuidle: using governor menu
[    2.598609] usbcore: registered new interface driver usbhid
[    2.599446] usbhid: USB HID core driver
[    2.600686] TCP bic registered
[    2.601834] NET: Registered protocol family 33
[    2.602682] Registering the dns_resolver key type
[    2.603954] PM: Checking hibernation image partition /dev/sda2
[    2.896838] ata4: SATA link down (SStatus 0 SControl 300)
[    2.897921] ata6: SATA link down (SStatus 0 SControl 300)
[    2.898835] ata2: SATA link down (SStatus 0 SControl 300)
[    2.899839] ata5: SATA link down (SStatus 0 SControl 300)
[    2.906811] ata8: SATA link down (SStatus 0 SControl 300)
[    2.907720] ata7: SATA link down (SStatus 0 SControl 300)
[    3.063469] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.064381] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.070199] ata1.00: ATA-8: SAMSUNG HD103SJ, 1AJ10001, max UDMA/133
[    3.071040] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.071996] ata3.00: ATA-8: SAMSUNG HD103SJ, 1AJ10001, max UDMA/133
[    3.072806] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.077714] ata1.00: configured for UDMA/133
[    3.079144] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103SJ  1AJ1 PQ: 0 ANSI: 5
[    3.079411] ata3.00: configured for UDMA/133
[    3.081517] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103SJ  1AJ1 PQ: 0 ANSI: 5
[    3.082936] PM: Hibernation image not present or could not be loaded.
[    3.083415]   Magic number: 6:809:805
[    3.084746] debug: unmapping init memory ffffffff81a93000..ffffffff81b0f000
[    3.085706] Write protecting the kernel read-only data: 10240k
[    3.086772] debug: unmapping init memory ffff88000149e000..ffff880001600000
[    3.087779] debug: unmapping init memory ffff880001851000..ffff880001a00000
[    3.122709] pata_jmicron 0000:01:00.1: enabling device (0000 -> 0001)
[    3.123800] pata_jmicron 0000:01:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    3.124741] pata_jmicron 0000:01:00.1: enabling bus mastering
[    3.124747] pata_jmicron 0000:01:00.1: setting latency timer to 64
[    3.125790] scsi8 : pata_jmicron
[    3.126956] scsi9 : pata_jmicron
[    3.128795] ata9: PATA max UDMA/100 cmd 0xa800 ctl 0xa400 bmdma 0x9400 irq 18
[    3.129667] ata10: PATA max UDMA/100 cmd 0xa000 ctl 0x9800 bmdma 0x9408 irq 18
[    3.287424] ata9.00: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB03, max UDMA/33
[    3.300669] ata9.00: configured for UDMA/33
[    3.303566] scsi 8:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M SB03 PQ: 0 ANSI: 5
[    3.468664] modprobe used greatest stack depth: 4120 bytes left
[    3.477170] ACPI: acpi_idle registered with cpuidle
[    3.489853] udev: starting version 157
[    3.490964] udevd (1391): /proc/1391/oom_adj is deprecated, please use /proc/1391/oom_score_adj instead.
[    3.565827] rtc_cmos 00:04: RTC can wake from S4
[    3.575498] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.576622] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.577435] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.577539] sd 0:0:0:0: [sda] Write Protect is off
[    3.577541] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.577583] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.582700] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.583969] sd 2:0:0:0: [sdb] Write Protect is off
[    3.584155] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.584189] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.587287] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.587293] ehci_hcd 0000:00:12.2: enabling bus mastering
[    3.587311] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    3.587344] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.590564] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    3.595905]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    3.600106] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.601413] ehci_hcd 0000:00:12.2: debug port 1
[    3.601875] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.603763] ehci_hcd 0000:00:12.2: enabling Mem-Wr-Inval
[    3.603779] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe3ff400
[    3.606025]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    3.611850] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.613370] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    3.615004] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.616189] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.617475] usb usb1: Product: EHCI Host Controller
[    3.618653] usb usb1: Manufacturer: Linux 2.6.37-rc6+ ehci_hcd
[    3.619846] usb usb1: SerialNumber: 0000:00:12.2
[    3.624437] hub 1-0:1.0: USB hub found
[    3.625744] hub 1-0:1.0: 5 ports detected
[    3.627808] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.629117] ehci_hcd 0000:00:13.2: enabling bus mastering
[    3.629122] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    3.631156] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    3.640099] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.641430] ehci_hcd 0000:00:13.2: debug port 1
[    3.642684] ehci_hcd 0000:00:13.2: enabling Mem-Wr-Inval
[    3.642700] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfe3ff800
[    3.653352] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    3.654630] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.655868] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.657163] usb usb2: Product: EHCI Host Controller
[    3.658381] usb usb2: Manufacturer: Linux 2.6.37-rc6+ ehci_hcd
[    3.659593] usb usb2: SerialNumber: 0000:00:13.2
[    3.661824] hub 2-0:1.0: USB hub found
[    3.663049] hub 2-0:1.0: 5 ports detected
[    3.665065] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.666308] ehci_hcd 0000:00:16.2: enabling bus mastering
[    3.666312] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    3.668078] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[    3.673414] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.674657] ehci_hcd 0000:00:16.2: debug port 1
[    3.675863] ehci_hcd 0000:00:16.2: enabling Mem-Wr-Inval
[    3.675876] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfe3ffc00
[    3.686750] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    3.687976] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.689167] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.690429] usb usb3: Product: EHCI Host Controller
[    3.691603] usb usb3: Manufacturer: Linux 2.6.37-rc6+ ehci_hcd
[    3.692803] usb usb3: SerialNumber: 0000:00:16.2
[    3.695651] hub 3-0:1.0: USB hub found
[    3.696901] hub 3-0:1.0: 4 ports detected
[    3.699841] modprobe used greatest stack depth: 3984 bytes left
[    3.708188] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.709402] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.710660] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    3.712438] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    3.720129] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfe3f7000
[    3.777494] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.778624] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.779735] usb usb4: Product: OHCI Host Controller
[    3.780920] usb usb4: Manufacturer: Linux 2.6.37-rc6+ ohci_hcd
[    3.782026] usb usb4: SerialNumber: 0000:00:12.0
[    3.784915] hub 4-0:1.0: USB hub found
[    3.786041] hub 4-0:1.0: 5 ports detected
[    3.788150] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.789298] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.791154] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    3.796747] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe3fc000
[    3.857531] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.858555] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.859571] usb usb5: Product: OHCI Host Controller
[    3.860622] usb usb5: Manufacturer: Linux 2.6.37-rc6+ ohci_hcd
[    3.861639] usb usb5: SerialNumber: 0000:00:13.0
[    3.863135] hub 5-0:1.0: USB hub found
[    3.864209] hub 5-0:1.0: 5 ports detected
[    3.865692] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.866772] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    3.868111] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    3.890119] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe3fd000
[    3.947545] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.948554] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.949563] usb usb6: Product: OHCI Host Controller
[    3.950592] usb usb6: Manufacturer: Linux 2.6.37-rc6+ ohci_hcd
[    3.951602] usb usb6: SerialNumber: 0000:00:14.5
[    3.953078] hub 6-0:1.0: USB hub found
[    3.954143] hub 6-0:1.0: 2 ports detected
[    3.955546] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.956569] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    3.957854] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    3.983547] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfe3fe000
[    4.040831] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.041842] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.042847] usb usb7: Product: OHCI Host Controller
[    4.043863] usb usb7: Manufacturer: Linux 2.6.37-rc6+ ohci_hcd
[    4.044867] usb usb7: SerialNumber: 0000:00:16.0
[    4.046342] hub 7-0:1.0: USB hub found
[    4.047408] hub 7-0:1.0: 4 ports detected
[    4.049177] modprobe used greatest stack depth: 3952 bytes left
[    4.116840] usb 4-2: new full speed USB device using ohci_hcd and address 2
[    4.283572] usb 4-2: New USB device found, idVendor=046d, idProduct=c526
[    4.284637] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.285642] usb 4-2: Product: USB Receiver
[    4.286643] usb 4-2: Manufacturer: Logitech
[    4.296104] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb4/4-2/4-2:1.0/input/input1
[    4.298404] generic-usb 0003:046D:C526.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-2/input0
[    4.306822] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb4/4-2/4-2:1.1/input/input2
[    4.308998] generic-usb 0003:046D:C526.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-2/input1
[    4.560170] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    4.720545] usb 4-3: New USB device found, idVendor=046d, idProduct=c517
[    4.721767] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.722912] usb 4-3: Product: USB Receiver
[    4.724063] usb 4-3: Manufacturer: Logitech
[    4.757000] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.0/input/input3
[    4.758517] logitech 0003:046D:C517.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-3/input0
[    4.767528] logitech 0003:046D:C517.0004: fixing up Logitech keyboard report descriptor
[    4.769433] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.1/input/input4
[    4.771257] logitech 0003:046D:C517.0004: input,hiddev0,hidraw3: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-3/input1
[    4.854323] md: raid0 personality registered for level 0
[    4.861244] md: raid10 personality registered for level 10
[    4.923344] raid6: int64x1   3046 MB/s
[    4.980003] raid6: int64x2   4316 MB/s
[    5.036696] raid6: int64x4   3194 MB/s
[    5.093337] raid6: int64x8   2861 MB/s
[    5.150009] raid6: sse2x1    5680 MB/s
[    5.206672] raid6: sse2x2    9326 MB/s
[    5.263397] raid6: sse2x4   10639 MB/s
[    5.264609] raid6: using algorithm sse2x4 (10639 MB/s)
[    5.268315] xor: automatically using best checksumming function: generic_sse
[    5.283337]    generic_sse: 12770.400 MB/sec
[    5.284575] xor: using function: generic_sse (12770.400 MB/sec)
[    5.291342] md: raid6 personality registered for level 6
[    5.292581] md: raid5 personality registered for level 5
[    5.293833] md: raid4 personality registered for level 4
[    5.326550] md: md0 stopped.
[    5.329572] md: bind<sdb3>
[    5.330985] md: bind<sda3>
[    5.333987] bio: create slab <bio-1> at 1
[    5.335379] md/raid1:md0: active with 2 out of 2 mirrors
[    5.336647] created bitmap (200 pages) for device md0
[    5.348809] md0: bitmap initialized from disk: read 13/13 pages, set 0 bits
[    5.367434] md0: detected capacity change from 0 to 107373060096
[    5.370458] md0: detected capacity change from 0 to 107373060096
[    5.371995]  md0: unknown partition table
[    5.477861] PM: Marking nosave pages: 000000000009b000 - 0000000000100000
[    5.477864] PM: Marking nosave pages: 00000000c7e90000 - 0000000100000000
[    5.478315] PM: Marking nosave pages: 00000000bc000000 - 00000000c0000000
[    5.478479] PM: Basic memory bitmaps created
[    5.498564] PM: Basic memory bitmaps freed
[    5.510503] PM: Starting manual resume from disk
[    5.511683] PM: Hibernation image partition 8:2 present
[    5.511684] PM: Looking for hibernation image.
[    5.512013] PM: Image not found (code -22)
[    5.512015] PM: Hibernation image not present or could not be loaded.
[    5.699656] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    5.770740] EXT4-fs (md0): re-mounted. Opts: acl,user_xattr
[    6.731588] cat used greatest stack depth: 3648 bytes left
[    8.769083] udev: starting version 157
[    8.949974] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[    8.951190] xhci_hcd 0000:04:00.0: setting latency timer to 64
[    8.951194] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    8.953028] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 8
[    8.960155] xhci_hcd 0000:04:00.0: enabling Mem-Wr-Inval
[    8.960187] xhci_hcd 0000:04:00.0: irq 48, io mem 0xfe5fe000
[    8.961392] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[    8.961397] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[    8.961401] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[    8.961405] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[    8.961408] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[    8.961412] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[    8.961416] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[    8.963519] usb usb8: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[    8.964716] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
[    8.965903] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.967138] usb usb8: Product: xHCI Host Controller
[    8.968336] usb usb8: Manufacturer: Linux 2.6.37-rc6+ xhci_hcd
[    8.969553] usb usb8: SerialNumber: 0000:04:00.0
[    8.973287] xHCI xhci_add_endpoint called for root hub
[    8.973290] xHCI xhci_check_bandwidth called for root hub
[    8.973612] hub 8-0:1.0: USB hub found
[    8.974864] hub 8-0:1.0: 4 ports detected
[    8.976960] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    8.978178] r8169 0000:06:00.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
[    8.979376] r8169 0000:06:00.0: enabling Mem-Wr-Inval
[    8.979420] r8169 0000:06:00.0: setting latency timer to 64
[    8.979464] r8169 0000:06:00.0: irq 88 for MSI/MSI-X
[    8.982350] r8169 0000:06:00.0: eth0: RTL8168d/8111d at 0xffffc90010548000, 6c:62:6d:0f:d3:0e, XID 081000c0 IRQ 88
[    8.989091] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.990920] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    8.992565] scsi 8:0:0:0: Attached scsi generic sg2 type 5
[    9.003164] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
[    9.004538] ACPI: Power Button [PWRB]
[    9.010341] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[    9.011671] ACPI: Power Button [PWRF]
[    9.043420] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    9.044762] r8169 0000:05:00.0: PCI INT A -> GSI 51 (level, low) -> IRQ 51
[    9.046066] r8169 0000:05:00.0: enabling Mem-Wr-Inval
[    9.046117] r8169 0000:05:00.0: setting latency timer to 64
[    9.046159] r8169 0000:05:00.0: irq 89 for MSI/MSI-X
[    9.047532] r8169 0000:05:00.0: eth1: RTL8168d/8111d at 0xffffc9001054c000, 6c:62:6d:0f:d3:0d, XID 081000c0 IRQ 89
[    9.150978] firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
[    9.152369] firewire_ohci 0000:07:00.0: calling quirk_via_vlink+0x0/0xc0
[    9.152375] firewire_ohci 0000:07:00.0: setting latency timer to 64
[    9.210250] firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[    9.210782] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    9.210792] cdrom: Uniform CD-ROM driver Revision: 3.20
[    9.211730] sr 8:0:0:0: Attached scsi CD-ROM sr0
[    9.503918] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.575473] hda_codec: ALC889: BIOS auto-probing.
[    9.583740] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    9.586506] HDA Intel 0000:08:00.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[    9.588083] HDA Intel 0000:08:00.1: irq 90 for MSI/MSI-X
[    9.588116] HDA Intel 0000:08:00.1: setting latency timer to 64
[    9.717706] firewire_core: created device fw0: GUID 0010dc0001b245eb, S400
[    9.791488] Adding 8385532k swap on /dev/sda2.  Priority:-1 extents:1 across:8385532k 
[    9.800747] Adding 8385532k swap on /dev/sdb2.  Priority:-2 extents:1 across:8385532k 
[   10.326352] device-mapper: uevent: version 1.0.3
[   10.328716] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[   10.527960] md: md1 stopped.
[   10.530490] md: bind<sdb5>
[   10.532019] md: bind<sda5>
[   10.551148] ip used greatest stack depth: 3632 bytes left
[   10.552795] md/raid1:md1: active with 2 out of 2 mirrors
[   10.565682] created bitmap (300 pages) for device md1
[   10.585562] md1: bitmap initialized from disk: read 19/19 pages, set 0 bits
[   10.627219] md1: detected capacity change from 0 to 644243906560
[   10.644002]  md1: unknown partition table
[   11.599111] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   11.829272] EXT3-fs: barriers not enabled
[   11.840308] kjournald starting.  Commit interval 5 seconds
[   11.840535] EXT3-fs (sdb1): using internal journal
[   11.840646] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[   12.010546] EXT3-fs: barriers not enabled
[   12.028355] kjournald starting.  Commit interval 5 seconds
[   12.028501] EXT3-fs (sda1): using internal journal
[   12.028506] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   14.055459] powernow-k8: Found 1 AMD Phenom(tm) II X6 1090T Processor (6 cpu cores) (version 2.20.00)
[   14.056536] powernow-k8: Core Performance Boosting: on.
[   14.057951] powernow-k8:    0 : pstate 0 (3200 MHz)
[   14.058951] powernow-k8:    1 : pstate 1 (2400 MHz)
[   14.059934] powernow-k8:    2 : pstate 2 (1600 MHz)
[   14.060970] powernow-k8:    3 : pstate 3 (800 MHz)
[   14.654293] r8169 0000:06:00.0: eth0: link up
[   14.655283] r8169 0000:06:00.0: eth0: link up
[   15.201870] NET: Registered protocol family 10
[   15.202725] lo: Disabled Privacy Extensions
[   15.560255] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[   16.106588] RPC: Registered udp transport module.
[   16.106591] RPC: Registered tcp transport module.
[   16.106593] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   16.334749] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   16.601532] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   16.610433] NFSD: starting 90-second grace period
[   16.611439] rpc.nfsd used greatest stack depth: 3600 bytes left
[   25.910092] eth0: no IPv6 routers present
[   33.189425] xhci_hcd 0000:04:00.0: remove, state 4
[   33.189528] usb usb8: USB disconnect, address 1
[   33.225678] xhci_hcd 0000:04:00.0: Host controller not halted, aborting reset.
[   33.225678] 
[   33.225678] ======================================================
[   33.225678] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[   33.225678] 2.6.37-rc6+ #12
[   33.225678] ------------------------------------------------------
[   33.225678] rmmod/6075 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[   33.225678]  (proc_subdir_lock){+.+...}, at: [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.225678] 
[   33.225678] and this task is already holding:
[   33.225678]  (&(&xhci->lock)->rlock){-.....}, at: [<ffffffffa0134c9d>] xhci_stop+0x1d/0x80 [xhci_hcd]
[   33.225678] which would create a new lock dependency:
[   33.225678]  (&(&xhci->lock)->rlock){-.....} -> (proc_subdir_lock){+.+...}
[   33.225678] 
[   33.225678] but this new dependency connects a HARDIRQ-irq-safe lock:
[   33.240111]  (&(&xhci->lock)->rlock){-.....}
[   33.240111] ... which became HARDIRQ-irq-safe at:
[   33.240111]   [<ffffffff8107a462>] __lock_acquire+0xc52/0x1ca0
[   33.240111]   [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]   [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]   [<ffffffffa013e3f4>] xhci_irq+0x34/0x1c0 [xhci_hcd]
[   33.240111]   [<ffffffffa013e594>] xhci_msi_irq+0x14/0x20 [xhci_hcd]
[   33.240111]   [<ffffffff810a3e2a>] handle_IRQ_event+0x3a/0xe0
[   33.240111]   [<ffffffff810a66ee>] handle_edge_irq+0xce/0x180
[   33.240111]   [<ffffffff810057e4>] handle_irq+0x44/0xa0
[   33.240111]   [<ffffffff8100541d>] do_IRQ+0x6d/0xf0
[   33.240111]   [<ffffffff81495c53>] ret_from_intr+0x0/0xf
[   33.240111] 
[   33.240111] to a HARDIRQ-irq-unsafe lock:
[   33.240111]  (proc_subdir_lock){+.+...}
[   33.240111] ... which became HARDIRQ-irq-unsafe at:
[   33.240111] ...  [<ffffffff81079f75>] __lock_acquire+0x765/0x1ca0
[   33.240111]   [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]   [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]   [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]   [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]   [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]   [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]   [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]   [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111] 
[   33.240111] other info that might help us debug this:
[   33.240111] 
[   33.240111] 3 locks held by rmmod/6075:
[   33.240111]  #0:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8132e56c>] driver_detach+0x4c/0xd0
[   33.240111]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8132e57a>] driver_detach+0x5a/0xd0
[   33.240111]  #2:  (&(&xhci->lock)->rlock){-.....}, at: [<ffffffffa0134c9d>] xhci_stop+0x1d/0x80 [xhci_hcd]
[   33.240111] 
[   33.240111] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[   33.240111] -> (&(&xhci->lock)->rlock){-.....} ops: 14 {
[   33.240111]    IN-HARDIRQ-W at:
[   33.240111]                                        [<ffffffff8107a462>] __lock_acquire+0xc52/0x1ca0
[   33.240111]                                        [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                        [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                        [<ffffffffa013e3f4>] xhci_irq+0x34/0x1c0 [xhci_hcd]
[   33.240111]                                        [<ffffffffa013e594>] xhci_msi_irq+0x14/0x20 [xhci_hcd]
[   33.240111]                                        [<ffffffff810a3e2a>] handle_IRQ_event+0x3a/0xe0
[   33.240111]                                        [<ffffffff810a66ee>] handle_edge_irq+0xce/0x180
[   33.240111]                                        [<ffffffff810057e4>] handle_irq+0x44/0xa0
[   33.240111]                                        [<ffffffff8100541d>] do_IRQ+0x6d/0xf0
[   33.240111]                                        [<ffffffff81495c53>] ret_from_intr+0x0/0xf
[   33.240111]    INITIAL USE at:
[   33.240111]                                       [<ffffffff81079bd9>] __lock_acquire+0x3c9/0x1ca0
[   33.240111]                                       [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                       [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                       [<ffffffffa013e3f4>] xhci_irq+0x34/0x1c0 [xhci_hcd]
[   33.240111]                                       [<ffffffffa013e594>] xhci_msi_irq+0x14/0x20 [xhci_hcd]
[   33.240111]                                       [<ffffffff810a3e2a>] handle_IRQ_event+0x3a/0xe0
[   33.240111]                                       [<ffffffff810a66ee>] handle_edge_irq+0xce/0x180
[   33.240111]                                       [<ffffffff810057e4>] handle_irq+0x44/0xa0
[   33.240111]                                       [<ffffffff8100541d>] do_IRQ+0x6d/0xf0
[   33.240111]                                       [<ffffffff81495c53>] ret_from_intr+0x0/0xf
[   33.240111]  }
[   33.240111]  ... key      at: [<ffffffffa0149314>] __key.26332+0x0/0xffffffffffff649c [xhci_hcd]
[   33.240111]  ... acquired at:
[   33.240111]    [<ffffffff81079100>] check_irq_usage+0x60/0xf0
[   33.240111]    [<ffffffff8107a840>] __lock_acquire+0x1030/0x1ca0
[   33.240111]    [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]    [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]    [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.240111]    [<ffffffff810a779c>] unregister_handler_proc+0x2c/0x40
[   33.240111]    [<ffffffff810a4500>] __free_irq+0x100/0x250
[   33.240111]    [<ffffffff810a4692>] free_irq+0x42/0x80
[   33.240111]    [<ffffffffa01345be>] xhci_free_irq+0x7e/0x90 [xhci_hcd]
[   33.240111]    [<ffffffffa01345f0>] xhci_cleanup_msix+0x20/0x80 [xhci_hcd]
[   33.240111]    [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]    [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]    [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]    [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]    [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]    [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]    [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]    [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]    [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]    [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]    [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]    [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]    [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] 
[   33.240111] 
[   33.240111] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[   33.240111] -> (proc_subdir_lock){+.+...} ops: 6970 {
[   33.240111]    HARDIRQ-ON-W at:
[   33.240111]                                        [<ffffffff81079f75>] __lock_acquire+0x765/0x1ca0
[   33.240111]                                        [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                        [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                        [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]                                        [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]                                        [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]                                        [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]                                        [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]                                        [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111]    SOFTIRQ-ON-W at:
[   33.240111]                                        [<ffffffff81079fb0>] __lock_acquire+0x7a0/0x1ca0
[   33.240111]                                        [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                        [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                        [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]                                        [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]                                        [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]                                        [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]                                        [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]                                        [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111]    INITIAL USE at:
[   33.240111]                                       [<ffffffff81079bd9>] __lock_acquire+0x3c9/0x1ca0
[   33.240111]                                       [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                       [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                       [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]                                       [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]                                       [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]                                       [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]                                       [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]                                       [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111]  }
[   33.240111]  ... key      at: [<ffffffff81a443f8>] proc_subdir_lock+0x18/0x40
[   33.240111]  ... acquired at:
[   33.240111]    [<ffffffff81079100>] check_irq_usage+0x60/0xf0
[   33.240111]    [<ffffffff8107a840>] __lock_acquire+0x1030/0x1ca0
[   33.240111]    [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]    [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]    [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.240111]    [<ffffffff810a779c>] unregister_handler_proc+0x2c/0x40
[   33.240111]    [<ffffffff810a4500>] __free_irq+0x100/0x250
[   33.240111]    [<ffffffff810a4692>] free_irq+0x42/0x80
[   33.240111]    [<ffffffffa01345be>] xhci_free_irq+0x7e/0x90 [xhci_hcd]
[   33.240111]    [<ffffffffa01345f0>] xhci_cleanup_msix+0x20/0x80 [xhci_hcd]
[   33.240111]    [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]    [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]    [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]    [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]    [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]    [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]    [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]    [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]    [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]    [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]    [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]    [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]    [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] 
[   33.240111] 
[   33.240111] stack backtrace:
[   33.240111] Pid: 6075, comm: rmmod Not tainted 2.6.37-rc6+ #12
[   33.240111] Call Trace:
[   33.240111]  [<ffffffff81079097>] check_usage+0x497/0x4a0
[   33.240111]  [<ffffffff81079100>] check_irq_usage+0x60/0xf0
[   33.240111]  [<ffffffff8107a840>] __lock_acquire+0x1030/0x1ca0
[   33.240111]  [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]  [<ffffffff81152aae>] ? remove_proc_entry+0x2e/0x2a0
[   33.240111]  [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]  [<ffffffff81152aae>] ? remove_proc_entry+0x2e/0x2a0
[   33.240111]  [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.240111]  [<ffffffff8104a939>] ? vprintk+0x2f9/0x4b0
[   33.240111]  [<ffffffff810a779c>] unregister_handler_proc+0x2c/0x40
[   33.240111]  [<ffffffff810a4500>] __free_irq+0x100/0x250
[   33.240111]  [<ffffffff810a4692>] free_irq+0x42/0x80
[   33.240111]  [<ffffffffa01345be>] xhci_free_irq+0x7e/0x90 [xhci_hcd]
[   33.240111]  [<ffffffffa01345f0>] xhci_cleanup_msix+0x20/0x80 [xhci_hcd]
[   33.240111]  [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]  [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]  [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]  [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]  [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]  [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]  [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]  [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]  [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]  [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]  [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]  [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]  [<ffffffff8100276c>] ? sysret_check+0x27/0x62
[   33.240111]  [<ffffffff8107c3bd>] ? trace_hardirqs_on_caller+0x12d/0x170
[   33.240111]  [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] BUG: sleeping function called from invalid context at /home/rafael/src/linux-2.6/kernel/mutex.c:278
[   33.240111] in_atomic(): 1, irqs_disabled(): 1, pid: 6075, name: rmmod
[   33.240111] INFO: lockdep is turned off.
[   33.240111] irq event stamp: 4560
[   33.240111] hardirqs last  enabled at (4559): [<ffffffff8149571d>] _raw_spin_unlock_irqrestore+0x5d/0x70
[   33.240111] hardirqs last disabled at (4560): [<ffffffff81494e92>] _raw_spin_lock_irq+0x12/0x50
[   33.240111] softirqs last  enabled at (4494): [<ffffffff81400845>] sk_filter+0xd5/0x100
[   33.240111] softirqs last disabled at (4492): [<ffffffff814007ad>] sk_filter+0x3d/0x100
[   33.240111] Pid: 6075, comm: rmmod Not tainted 2.6.37-rc6+ #12
[   33.240111] Call Trace:
[   33.240111]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
[   33.240111]  [<ffffffff81036783>] __might_sleep+0x103/0x130
[   33.240111]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
[   33.240111]  [<ffffffff814956fd>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
[   33.240111]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
[   33.240111]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
[   33.240111]  [<ffffffff81022008>] destroy_irq+0x78/0x90
[   33.240111]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
[   33.240111]  [<ffffffff811ee0b0>] default_teardown_msi_irqs+0x70/0xa0
[   33.240111]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
[   33.240111]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
[   33.240111]  [<ffffffffa0134609>] xhci_cleanup_msix+0x39/0x80 [xhci_hcd]
[   33.240111]  [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]  [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]  [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]  [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]  [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]  [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]  [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]  [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]  [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]  [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]  [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]  [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]  [<ffffffff8100276c>] ? sysret_check+0x27/0x62
[   33.240111]  [<ffffffff8107c3bd>] ? trace_hardirqs_on_caller+0x12d/0x170
[   33.240111]  [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] ------------[ cut here ]------------
[   33.240111] WARNING: at /home/rafael/src/linux-2.6/kernel/smp.c:432 smp_call_function_many+0xac/0x1f0()
[   33.240111] Hardware name: MS-7640
[   33.240111] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table mperf ext3 jbd dm_mod snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd sr_mod soundcore firewire_ohci evdev cdrom firewire_core serio_raw joydev snd_page_alloc button sg r8169 mii xhci_hcd(-) crc_itu_t ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid10 raid0 ohci_hcd ehci_hcd sd_mod crc_t10dif rtc_cmos rtc_core rtc_lib fan processor pata_jmicron thermal
[   33.240111] Pid: 6075, comm: rmmod Not tainted 2.6.37-rc6+ #12
[   33.240111] Call Trace:
[   33.240111]  [<ffffffff81049e5a>] warn_slowpath_common+0x7a/0xb0
[   33.240111]  [<ffffffff81030f60>] ? do_flush_tlb_all+0x0/0x50
[   33.240111]  [<ffffffff81049ea5>] warn_slowpath_null+0x15/0x20
[   33.240111]  [<ffffffff81082c5c>] smp_call_function_many+0xac/0x1f0
[   33.240111]  [<ffffffff81030f60>] ? do_flush_tlb_all+0x0/0x50
[   33.240111]  [<ffffffff81082de1>] smp_call_function+0x41/0x80
[   33.240111]  [<ffffffff81030f60>] ? do_flush_tlb_all+0x0/0x50
[   33.240111]  [<ffffffff8104fba5>] on_each_cpu+0x35/0x80
[   33.240111]  [<ffffffff810312c7>] flush_tlb_all+0x17/0x20
[   33.240111]  [<ffffffff810e0990>] remove_vm_area+0x90/0xc0
[   33.240111]  [<ffffffff8102c1a1>] iounmap+0x91/0xe0
[   33.240111]  [<ffffffff811edba9>] free_msi_irqs+0x109/0x110
[   33.240111]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
[   33.240111]  [<ffffffffa0134609>] xhci_cleanup_msix+0x39/0x80 [xhci_hcd]
[   33.240111]  [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]  [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]  [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]  [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]  [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]  [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]  [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]  [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]  [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]  [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]  [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]  [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]  [<ffffffff8100276c>] ? sysret_check+0x27/0x62
[   33.240111]  [<ffffffff8107c3bd>] ? trace_hardirqs_on_caller+0x12d/0x170
[   33.240111]  [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] ---[ end trace 78a8387880057ad9 ]---
[   33.269230] xhci_hcd 0000:04:00.0: USB bus 8 deregistered
[   33.486574] xhci_hcd 0000:04:00.0: PCI INT A disabled
[   69.159848] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[   69.161130] xhci_hcd 0000:04:00.0: enabling bus mastering
[   69.162281] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   69.163433] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   69.164848] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 8
[   69.193629] xhci_hcd 0000:04:00.0: enabling Mem-Wr-Inval
[   69.194848] xhci_hcd 0000:04:00.0: irq 48, io mem 0xfe5fe000
[   69.196022] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[   69.197175] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[   69.198292] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[   69.199403] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[   69.200527] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[   69.201620] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[   69.202703] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[   69.203883] usb usb8: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[   69.205038] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
[   69.206166] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   69.207320] usb usb8: Product: xHCI Host Controller
[   69.208453] usb usb8: Manufacturer: Linux 2.6.37-rc6+ xhci_hcd
[   69.208458] usb usb8: SerialNumber: 0000:04:00.0
[   69.208789] xHCI xhci_add_endpoint called for root hub
[   69.208791] xHCI xhci_check_bandwidth called for root hub
[   69.208919] hub 8-0:1.0: USB hub found
[   69.208929] hub 8-0:1.0: 4 ports detected
[   86.020333] PM: Marking nosave pages: 000000000009b000 - 0000000000100000
[   86.020336] PM: Marking nosave pages: 00000000c7e90000 - 0000000100000000
[   86.020800] PM: Marking nosave pages: 00000000bc000000 - 00000000c0000000
[   86.020964] PM: Basic memory bitmaps created
[   86.020965] PM: Syncing filesystems ... done.
[   86.318157] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   86.330195] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   86.343591] PM: Preallocating image memory... done (allocated 83697 pages)
[   86.479936] PM: Allocated 334788 kbytes in 0.13 seconds (2575.29 MB/s)
[   86.479966] Suspending console(s) (use no_console_suspend to debug)
[   86.481161] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[   86.481177] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   86.482085] serial 00:07: disabled
[   86.482515] ahci 0000:01:00.0: PCI INT A disabled
[   86.486738] ACPI handle has no context!
[   86.493443] pata_jmicron 0000:01:00.1: PCI INT B disabled
[   86.583399] HDA Intel 0000:08:00.1: PCI INT B disabled
[   86.583434] ACPI handle has no context!
[   86.583444] HDA Intel 0000:00:14.2: PCI INT A disabled
[   86.596743] PM: freeze of devices complete after 115.998 msecs
[   86.596744] hibernation debug: Waiting for 5 seconds.
[   91.699721] ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300503, writing 0x2300507)
[   91.699956] ohci_hcd 0000:00:16.0: HC died; cleaning up
[   91.700195] radeon 0000:08:00.0: setting latency timer to 64
[   91.700209] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   91.700214] usb usb8: root hub lost power or was reset
[   91.701003] serial 00:07: activated
[   91.703555] ahci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100107)
[   91.703614] pata_jmicron 0000:01:00.1: restoring config space at offset 0x1 (was 0x100001, writing 0x100005)
[   91.703658] ahci 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   91.703664] pata_jmicron 0000:01:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   91.703666] ahci 0000:01:00.0: setting latency timer to 64
[   91.703675] pata_jmicron 0000:01:00.1: setting latency timer to 64
[   91.703778] sd 0:0:0:0: [sda] Starting disk
[   91.704054] sd 2:0:0:0: [sdb] Starting disk
[   91.703680] xhci_hcd 0000:04:00.0: Host controller not halted, aborting reset.
[   91.703680] BUG: sleeping function called from invalid context at /home/rafael/src/linux-2.6/kernel/mutex.c:278
[   91.703680] in_atomic(): 1, irqs_disabled(): 1, pid: 1234, name: kworker/u:6
[   91.703680] INFO: lockdep is turned off.
[   91.703680] irq event stamp: 24060
[   91.703680] hardirqs last  enabled at (24059): [<ffffffff810aa071>] rcu_note_context_switch+0xa1/0x1c0
[   91.703680] hardirqs last disabled at (24060): [<ffffffff81494e92>] _raw_spin_lock_irq+0x12/0x50
[   91.703680] softirqs last  enabled at (20026): [<ffffffff8105056e>] __do_softirq+0x11e/0x160
[   91.703680] softirqs last disabled at (20011): [<ffffffff8100368c>] call_softirq+0x1c/0x30
[   91.703680] Pid: 1234, comm: kworker/u:6 Tainted: G        W   2.6.37-rc6+ #12
[   91.703680] Call Trace:
[   91.703680]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
[   91.703680]  [<ffffffff81036783>] __might_sleep+0x103/0x130
[   91.703680]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
[   91.703680]  [<ffffffff81495727>] ? _raw_spin_unlock_irqrestore+0x67/0x70
[   91.703680]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
[   91.703680]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
[   91.703680]  [<ffffffff81022008>] destroy_irq+0x78/0x90
[   91.703680]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
[   91.703680]  [<ffffffff811ee0b0>] default_teardown_msi_irqs+0x70/0xa0
[   91.703680]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
[   91.703680]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
[   91.703680]  [<ffffffffa03f0609>] xhci_cleanup_msix+0x39/0x80 [xhci_hcd]
[   91.703680]  [<ffffffffa03f111c>] xhci_resume+0x1ac/0x250 [xhci_hcd]
[   91.703680]  [<ffffffffa03f65c4>] xhci_pci_resume+0x14/0x20 [xhci_hcd]
[   91.703680]  [<ffffffff8138996b>] resume_common+0xbb/0x140
[   91.703680]  [<ffffffff81389a5e>] hcd_pci_restore+0xe/0x10
[   91.703680]  [<ffffffff811e36f3>] pci_pm_restore+0x63/0xb0
[   91.703680]  [<ffffffff813334bd>] pm_op+0x19d/0x1c0
[   91.703680]  [<ffffffff81333be4>] device_resume+0x94/0x220
[   91.703680]  [<ffffffff81333d8c>] async_resume+0x1c/0x50
[   91.703680]  [<ffffffff8106e6e6>] async_run_entry_fn+0x86/0x160
[   91.703680]  [<ffffffff81060672>] process_one_work+0x1a2/0x450
[   91.703680]  [<ffffffff81060614>] ? process_one_work+0x144/0x450
[   91.703680]  [<ffffffff811d2704>] ? do_raw_spin_lock+0x104/0x170
[   91.703680]  [<ffffffff8106e660>] ? async_run_entry_fn+0x0/0x160
[   91.703680]  [<ffffffff81061e32>] worker_thread+0x162/0x340
[   91.703680]  [<ffffffff81061cd0>] ? worker_thread+0x0/0x340
[   91.703680]  [<ffffffff81066836>] kthread+0x96/0xa0
[   91.703680]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[   91.703680]  [<ffffffff81036fdb>] ? finish_task_switch+0x7b/0xe0
[   91.703680]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
[   91.703680]  [<ffffffff810667a0>] ? kthread+0x0/0xa0
[   91.703680]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
[   91.706248] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[   91.706251] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[   91.706253] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[   91.706256] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[   91.706258] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[   91.706260] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[   91.706262] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[   91.710127] HDA Intel 0000:00:14.2: BAR 0: set to [mem 0xfe3f8000-0xfe3fbfff 64bit] (PCI address [0xfe3f8000-0xfe3fbfff])
[   91.710149] HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x0, writing 0xb)
[   91.710182] HDA Intel 0000:00:14.2: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[   91.710186] HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
[   91.710199] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   91.710202] HDA Intel 0000:00:14.2: enabling bus mastering
[   91.713453] firewire_ohci 0000:07:00.0: BAR 0: set to [mem 0xfe8ff800-0xfe8fffff 64bit] (PCI address [0xfe8ff800-0xfe8fffff])
[   91.713469] HDA Intel 0000:08:00.1: BAR 0: set to [mem 0xfe9fc000-0xfe9fffff 64bit] (PCI address [0xfe9fc000-0xfe9fffff])
[   91.713480] firewire_ohci 0000:07:00.0: BAR 2: set to [io  0xd800-0xd8ff] (PCI address [0xd800-0xd8ff])
[   91.713566] HDA Intel 0000:08:00.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[   91.713584] HDA Intel 0000:08:00.1: enabling bus mastering
[   91.713596] HDA Intel 0000:08:00.1: setting latency timer to 64
[   91.713628] HDA Intel 0000:08:00.1: irq 90 for MSI/MSI-X
[   91.716678] radeon 0000:08:00.0: WB enabled
[   91.732772] [drm] ring test succeeded in 1 usecs
[   91.732786] [drm] ib test succeeded in 0 usecs
[   91.749698] r8169 0000:06:00.0: eth0: link down
[   91.754098] usb usb5: root hub lost power or was reset
[   91.754259] usb usb2: root hub lost power or was reset
[   91.754793] usb usb4: root hub lost power or was reset
[   91.754947] usb usb1: root hub lost power or was reset
[   91.757436] usb usb7: root hub lost power or was reset
[   91.757509] usb usb3: root hub lost power or was reset
[   91.758182] usb usb6: root hub lost power or was reset
[   91.763471] r8169 0000:06:00.0: eth0: link down
[   91.766906] firewire_core: skipped bus generations, destroying all nodes
[   91.873980] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[   91.873982] ata9.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[   91.887408] ata9.00: configured for UDMA/33
[   92.016842] ata6: SATA link down (SStatus 0 SControl 300)
[   92.020132] ata4: SATA link down (SStatus 0 SControl 300)
[   92.023482] ata8: SATA link down (SStatus 0 SControl 300)
[   92.023492] ata5: SATA link down (SStatus 0 SControl 300)
[   92.023604] ata2: SATA link down (SStatus 0 SControl 300)
[   92.026816] ata7: SATA link down (SStatus 0 SControl 300)
[   92.183474] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   92.186795] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   92.195040] ata1.00: configured for UDMA/133
[   92.198322] ata3.00: configured for UDMA/133
[   92.266887] firewire_core: rediscovered device fw0
[   92.320136] usb 4-3: reset low speed USB device using ohci_hcd and address 3
[   92.746792] usb 4-2: reset full speed USB device using ohci_hcd and address 2
[   92.904485] PM: restore of devices complete after 1205.049 msecs
[   92.969240] PM: Image restored successfully.
[   92.970102] Restarting tasks ... done.
[   92.972820] PM: Basic memory bitmaps freed
[   94.855838] r8169 0000:06:00.0: eth0: link up

--Boundary-00=_pP2CNhSnfd72tsi
Content-Type: text/x-mpsub;
  charset="UTF-8";
  name="kernel-config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel-config"

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.37-rc6 Kernel Configuration
# Thu Dec 16 22:11:35 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=6
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_RPS=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/REDWOOD_me.bin radeon/REDWOOD_rlc.bin radeon/REDWOOD_pfp.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=128000
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
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
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_BCM63XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_WINBOND_CIR is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

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
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=4096
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_XILINX_PLTFM=m
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_BASIC_MMIO is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_PKGTEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=m
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWII_FF=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_UAS=m
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SAMBA=m
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
# CONFIG_UWB_HWA is not set
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_USE_NEW_IDMAPPER=y
CONFIG_NFSD=m
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
# CONFIG_CIFS_ACL is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_BKL=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_IOMMU_DEBUG=y
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=0
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--Boundary-00=_pP2CNhSnfd72tsi--
