Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1CASbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:31:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:12761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1CASbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:31:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,248,1297065600"; 
   d="txt'?scan'208";a="607868866"
Date: Tue, 1 Mar 2011 10:31:16 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110301183057.GA2359@xanatos>
References: <20110228014218.GA11083@xanatos>
 <201102282129.56835.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <201102282129.56835.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 28, 2011 at 09:29:56PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 28, 2011, Sarah Sharp wrote:
> > I'm having an issue with an xHCI (USB 3.0 host controller) Express Card.
> > This card works fine on 2.6.37, but on 2.6.38-rc5, when I plug in the
> > card, I get this output in dmesg:
> > 
> > Feb 22 16:32:28 xanatos kernel: [  119.345996] irq 23: nobody cared (try booting with the "irqpoll" option)
> > Feb 22 16:32:28 xanatos kernel: [  119.346002] Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc5+ #745
> > Feb 22 16:32:28 xanatos kernel: [  119.346005] Call Trace:
> > Feb 22 16:32:28 xanatos kernel: [  119.346007]  <IRQ>  [<ffffffff8109a1f6>] ? __report_bad_irq+0x26/0xa0
> > Feb 22 16:32:28 xanatos kernel: [  119.346019]  [<ffffffff8109a3fc>] ? note_interrupt+0x18c/0x1d0
> > Feb 22 16:32:28 xanatos kernel: [  119.346024]  [<ffffffff8109ad7d>] ? handle_fasteoi_irq+0xcd/0x100
> > Feb 22 16:32:28 xanatos kernel: [  119.346029]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
> > Feb 22 16:32:28 xanatos kernel: [  119.346032]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
> > Feb 22 16:32:28 xanatos kernel: [  119.346037]  [<ffffffff8149f5d3>] ? ret_from_intr+0x0/0xe
> > Feb 22 16:32:28 xanatos kernel: [  119.346040]  <EOI>  [<ffffffff8126f2d0>] ? acpi_idle_enter_c1+0x7e/0x99
> > Feb 22 16:32:28 xanatos kernel: [  119.346048]  [<ffffffff8126f2b2>] ? acpi_idle_enter_c1+0x60/0x99
> > Feb 22 16:32:28 xanatos kernel: [  119.346054]  [<ffffffff8138ac92>] ? cpuidle_idle_call+0x82/0xf0
> > Feb 22 16:32:28 xanatos kernel: [  119.346059]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
> > Feb 22 16:32:28 xanatos kernel: [  119.346064]  [<ffffffff8149861b>] ? start_secondary+0x1c1/0x1c8
> > Feb 22 16:32:28 xanatos kernel: [  119.346068]  [<ffffffff81263386>] ? acpi_ns_parse_table+0x2e/0x34
> > Feb 22 16:32:28 xanatos kernel: [  119.346073]  [<ffffffff81267a8c>] ? acpi_load_tables+0x9c/0x15d
> > Feb 22 16:32:28 xanatos kernel: [  119.346076] handlers:
> > Feb 22 16:32:28 xanatos kernel: [  119.346078] [<ffffffffa0123500>] (usb_hcd_irq+0x0/0x70 [usbcore])
> > Feb 22 16:32:28 xanatos kernel: [  119.346100] Disabling IRQ #23
> > 
> > This happens before the xHCI driver has a chance to start PCI
> > initialization.
> > 
> > I've been trying to bisect this on a slow laptop, so I haven't had a
> > chance to test with the latest tree from Linus to see if this is already
> > fixed.  I'll do that later this evening.
> > 
> > I've bisected the issue down to this commit:
> > 
> > 415e12b2379239973feab91850b0dce985c6058a is first bad commit
> > commit 415e12b2379239973feab91850b0dce985c6058a
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Fri Jan 7 00:55:09 2011 +0100
> > 
> >     PCI/ACPI: Request _OSC control once for each root bridge (v3)
> >     
> >     Move the evaluation of acpi_pci_osc_control_set() (to request control of
> >     PCI Express native features) into acpi_pci_root_add() to avoid calling
> >     it many times for the same root complex with the same arguments.
> >     Additionally, check if all of the requisite _OSC support bits are set
> >     before calling acpi_pci_osc_control_set() for a given root complex.
> >     
> >     References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
> >     Reported-by: Ozan Caglayan <ozan@pardus.org.tr>
> >     Tested-by: Ozan Caglayan <ozan@pardus.org.tr>
> >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > :040000 040000 531c48ec0c23b72f0ca1b5f33828ea63808e4033 7ffa298e34dd842e1f84f0b1fea6dc5af1f70514 M	drivers
> > :040000 040000 4e484ec0cab0ebc7c82a029c4860802617b7aaf2 01b429bcaeb7b50af04667664cf25453058e803f M	include
> > 
> > lspci from a kernel where the Express Card works is attached.
> 
> Most likely your card requires PCIe hotplug to work which doesn't with the
> above commit applied due to some dependencies that aren't met.
> 
> May I see full dmesg output with and without the above commit?
> 
> It may be more convenient to add a Bugzilla entry for it.

The kernel.org bugzilla seems to be broken for me right now:

https://picasaweb.google.com/lh/photo/zjqHkSPY1RiCv0KjA4pYvA?feat=directlink

Attached is the dmesg on the latest tree (broken-dmesg.txt), and the
dmesg from a kernel built starting from the commit below 415e12b23
(good-dmesg.txt).  I tried to revert that commit, but I didn't resolve
the conflicts correctly and the kernel didn't compile.

Sarah Sharp

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="broken-dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc6+ (sarah@xanatos) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #763 SMP PREEMPT Tue Mar 1 07:14:52 PST 2011
[    0.000000] Command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 74663HU/74663HU, BIOS 6DET44WW (2.08 ) 04/22/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdc00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdc00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000] kernel direct mapping tables up to bdc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bd8c1000-bd8c7000
[    0.000000] RAMDISK: 35dce000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bdb7bdd4 00094 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bdb7bf00 000F4 (v03 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bdb7c2f4 0D881 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bdb8e000 00040
[    0.000000] ACPI: SSDT 00000000bdb7c0b4 00240 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bdb89b75 00052 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bdb89bc7 00078 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bdb89c3f 0003C (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bdb89c7b 00038 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bdb89dc2 00176 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bdb89f38 00028 (v01 LENOVO TP-6D    00002080  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bdb89f60 000A0 (v16 LENOVO TP-6D    00002080 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bdb8d203 0055F (v01 LENOVO TP-6D    00002080 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd907000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000bd8d4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d3000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d2000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff8800b0000000-ffff8800b37fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd6a1
[    0.000000]     0: 0x000bd6a7 -> 0x000bd7b7
[    0.000000]     0: 0x000bd80f -> 0x000bd8c7
[    0.000000]     0: 0x000bdbff -> 0x000bdc00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021944
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757922 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd6a1000 - 00000000bd6a7000
[    0.000000] PM: Registered nosave memory: 00000000bd7b7000 - 00000000bd80f000
[    0.000000] PM: Registered nosave memory: 00000000bd8c7000 - 00000000bd8d2000
[    0.000000] PM: Registered nosave memory: 00000000bd8d2000 - 00000000bd8d5000
[    0.000000] PM: Registered nosave memory: 00000000bd8d5000 - 00000000bd8d9000
[    0.000000] PM: Registered nosave memory: 00000000bd8d9000 - 00000000bd8dd000
[    0.000000] PM: Registered nosave memory: 00000000bd8dd000 - 00000000bd8e0000
[    0.000000] PM: Registered nosave memory: 00000000bd8e0000 - 00000000bd907000
[    0.000000] PM: Registered nosave memory: 00000000bd907000 - 00000000bd908000
[    0.000000] PM: Registered nosave memory: 00000000bd908000 - 00000000bdb0f000
[    0.000000] PM: Registered nosave memory: 00000000bdb0f000 - 00000000bdb9f000
[    0.000000] PM: Registered nosave memory: 00000000bdb9f000 - 00000000bdbff000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bd400000 s75840 r8192 d22464 u1048576
[    0.000000] pcpu-alloc: s75840 r8192 d22464 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1004242
[    0.000000] Kernel command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3905952k/5177344k available (4763k kernel code, 1089568k absent, 181824k reserved, 3941k data, 524k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
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
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1861.862 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.72 BogoMIPS (lpj=7447448)
[    0.004143] pid_max: default: 32768 minimum: 301
[    0.008653] Mount-cache hash table entries: 256
[    0.011578] Initializing cgroup subsys ns
[    0.011647] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.011748] Initializing cgroup subsys cpuacct
[    0.011845] Initializing cgroup subsys memory
[    0.012170] Initializing cgroup subsys freezer
[    0.012624] CPU: Physical Processor ID: 0
[    0.012689] CPU: Processor Core ID: 0
[    0.012751] using mwait in idle threads.
[    0.012926] ACPI: Core revision 20110112
[    0.360621] Setting APIC routing to flat
[    0.364482] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.404263] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.408024] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.408024] ... version:                2
[    0.408024] ... bit width:              40
[    0.408024] ... generic registers:      2
[    0.408024] ... value mask:             000000ffffffffff
[    0.408024] ... max period:             000000007fffffff
[    0.408024] ... fixed-purpose events:   3
[    0.408024] ... event mask:             0000000700000003
[    0.416380] NMI watchdog enabled, takes one hw-pmu counter.
[    0.428064] lockdep: fixing up alternatives.
[    0.432247] Booting Node   0, Processors  #1 Ok.
[    0.528187] NMI watchdog enabled, takes one hw-pmu counter.
[    0.532058] Brought up 2 CPUs
[    0.532125] Total of 2 processors activated (7447.70 BogoMIPS).
[    0.543139] NET: Registered protocol family 16
[    0.548529] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.548634] ACPI: bus type pci registered
[    0.550207] PCI: Using configuration type 1 for base access
[    0.581849] bio: create slab <bio-0> at 0
[    0.603247] ACPI: EC: EC description table is found, configuring boot EC
[    0.947154] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.036584] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    1.043648] ACPI: Dynamic OEM Table Load:
[    1.043803] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    1.053093] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    1.065258] ACPI: Dynamic OEM Table Load:
[    1.065413] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    1.114036] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    1.123383] ACPI: Dynamic OEM Table Load:
[    1.123537] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    1.144465] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    1.150586] ACPI: Dynamic OEM Table Load:
[    1.150739] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    1.179656] ACPI: Interpreter enabled
[    1.179726] ACPI: (supports S0 S3 S4 S5)
[    1.180881] ACPI: Using IOAPIC for interrupt routing
[    1.348930] ACPI: Power Resource [PUBS] (on)
[    1.492995] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    1.553379] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    1.553457] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.569716] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.571628] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.571706] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.571781] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.571869] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.571955] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.572043] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    1.572417] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    1.572625] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    1.572674] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    1.572704] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.572725] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    1.572878] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    1.572919] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    1.573122] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    1.573173] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    1.573305] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.573316] pci 0000:00:03.0: PME# disabled
[    1.573410] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    1.573453] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    1.573475] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    1.573498] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    1.573520] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    1.573542] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    1.573708] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    1.573749] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    1.573772] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    1.574082] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    1.574139] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    1.574165] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    1.574192] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    1.574347] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.574360] pci 0000:00:19.0: PME# disabled
[    1.574454] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    1.574579] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    1.574748] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    1.574873] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    1.575041] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    1.575165] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    1.575361] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    1.575417] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    1.575613] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.575626] pci 0000:00:1a.7: PME# disabled
[    1.575732] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    1.575779] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    1.575970] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.575983] pci 0000:00:1b.0: PME# disabled
[    1.576142] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    1.576340] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.576353] pci 0000:00:1c.0: PME# disabled
[    1.576455] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    1.576651] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.576664] pci 0000:00:1c.1: PME# disabled
[    1.576768] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    1.576965] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.576978] pci 0000:00:1c.3: PME# disabled
[    1.577093] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    1.577218] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    1.577389] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    1.577514] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    1.577683] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    1.577807] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    1.578004] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    1.578061] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    1.578257] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.578270] pci 0000:00:1d.7: PME# disabled
[    1.578365] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.578584] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    1.578923] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    1.578985] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    1.579012] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    1.579038] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    1.579065] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    1.579091] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    1.579118] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    1.579230] pci 0000:00:1f.2: PME# supported from D3hot
[    1.579243] pci 0000:00:1f.2: PME# disabled
[    1.579336] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    1.579384] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    1.579451] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    1.579698] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.579778] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.579791] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.579811] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.580324] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    1.580463] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    1.581030] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.581071] pci 0000:03:00.0: PME# disabled
[    1.581282] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.581360] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.581374] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.581393] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.581562] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.581640] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.581653] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.581672] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.581905] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    1.581988] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.582002] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.582021] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.582050] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.582078] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.582106] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.582135] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.582163] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.582191] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    1.582250] pci_bus 0000:00: on NUMA node 0
[    1.582304] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.597743] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    1.601094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    1.604764] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    2.099212] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    2.104225] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    2.109216] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    2.114096] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    2.119113] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    2.123980] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    2.129036] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    2.134062] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    2.136646] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.137174] vgaarb: loaded
[    2.140647] SCSI subsystem initialized
[    2.140777] libata version 3.00 loaded.
[    2.141803] PCI: Using ACPI for IRQ routing
[    2.141803] PCI: pci_cache_line_size set to 64 bytes
[    2.144270] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    2.144296] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    2.144650] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    2.144943] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    2.145186] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    2.147913] Bluetooth: Core ver 2.15
[    2.148329] NET: Registered protocol family 31
[    2.148398] Bluetooth: HCI device and connection manager initialized
[    2.148501] Bluetooth: HCI socket layer initialized
[    2.149363] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    2.156639] Switching to clocksource hpet
[    2.156904] pnp: PnP ACPI init
[    2.157329] ACPI: bus type pnp registered
[    2.159297] Switched to NOHz mode on CPU #0
[    2.159460] Switched to NOHz mode on CPU #1
[    2.209561] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    2.209586] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    2.209609] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    2.209630] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    2.209653] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    2.209675] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    2.209697] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    2.209720] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    2.209743] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    2.209764] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    2.209786] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    2.209809] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    2.209832] pnp 00:00: [mem 0x000ec000-0x000effff]
[    2.209854] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    2.209876] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    2.209898] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    2.209920] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    2.211587] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.211710] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    2.211832] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    2.211951] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    2.212098] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    2.212217] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    2.212347] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    2.212477] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    2.212607] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    2.212737] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    2.212866] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    2.212996] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.213126] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    2.213261] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    2.213391] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    2.213475] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.213959] pnp 00:01: [bus 00-ff]
[    2.213982] pnp 00:01: [io  0x0cf8-0x0cff]
[    2.214005] pnp 00:01: [io  0x0000-0x0cf7 window]
[    2.214028] pnp 00:01: [io  0x0d00-0xffff window]
[    2.214050] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    2.214074] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    2.214096] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    2.214122] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    2.214145] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    2.214167] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    2.214190] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    2.214212] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    2.214235] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    2.214257] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    2.214281] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    2.214303] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    2.214325] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    2.214348] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    2.214370] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    2.215247] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.240979] pnp 00:02: [io  0x0010-0x001f]
[    2.241003] pnp 00:02: [io  0x0090-0x009f]
[    2.241025] pnp 00:02: [io  0x0024-0x0025]
[    2.241046] pnp 00:02: [io  0x0028-0x0029]
[    2.241067] pnp 00:02: [io  0x002c-0x002d]
[    2.241089] pnp 00:02: [io  0x0030-0x0031]
[    2.241110] pnp 00:02: [io  0x0034-0x0035]
[    2.241132] pnp 00:02: [io  0x0038-0x0039]
[    2.241154] pnp 00:02: [io  0x003c-0x003d]
[    2.241175] pnp 00:02: [io  0x00a4-0x00a5]
[    2.241197] pnp 00:02: [io  0x00a8-0x00a9]
[    2.241218] pnp 00:02: [io  0x00ac-0x00ad]
[    2.241239] pnp 00:02: [io  0x00b0-0x00b5]
[    2.241260] pnp 00:02: [io  0x00b8-0x00b9]
[    2.241282] pnp 00:02: [io  0x00bc-0x00bd]
[    2.241304] pnp 00:02: [io  0x0050-0x0053]
[    2.241325] pnp 00:02: [io  0x0072-0x0077]
[    2.241346] pnp 00:02: [io  0x002e-0x002f]
[    2.241367] pnp 00:02: [io  0x1000-0x107f]
[    2.241389] pnp 00:02: [io  0x1180-0x11ff]
[    2.241410] pnp 00:02: [io  0x0800-0x080f]
[    2.241432] pnp 00:02: [io  0x15e0-0x15ef]
[    2.241454] pnp 00:02: [io  0x1600-0x167f]
[    2.241476] pnp 00:02: [io  0x1680-0x169f]
[    2.241499] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    2.241521] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    2.241543] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    2.241565] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    2.241588] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    2.241609] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    2.243344] system 00:02: [io  0x1000-0x107f] has been reserved
[    2.243466] system 00:02: [io  0x1180-0x11ff] has been reserved
[    2.243585] system 00:02: [io  0x0800-0x080f] has been reserved
[    2.243702] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    2.243820] system 00:02: [io  0x1600-0x167f] has been reserved
[    2.243936] system 00:02: [io  0x1680-0x169f] has been reserved
[    2.244083] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    2.244203] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.244322] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    2.244440] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.244558] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.244677] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    2.244760] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.246232] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.247084] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.247398] pnp 00:04: [io  0x0000-0x000f]
[    2.247421] pnp 00:04: [io  0x0080-0x008f]
[    2.247443] pnp 00:04: [io  0x00c0-0x00df]
[    2.247465] pnp 00:04: [dma 4]
[    2.248344] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.248652] pnp 00:05: [io  0x0061]
[    2.249509] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.249821] pnp 00:06: [io  0x00f0]
[    2.249861] pnp 00:06: [irq 13]
[    2.250714] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.251025] pnp 00:07: [io  0x0070-0x0071]
[    2.251059] pnp 00:07: [irq 8]
[    2.251914] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.252388] pnp 00:08: [io  0x0060]
[    2.252410] pnp 00:08: [io  0x0064]
[    2.252443] pnp 00:08: [irq 1]
[    2.253309] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.253629] pnp 00:09: [irq 12]
[    2.254504] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    2.279523] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    2.280415] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    2.289680] pnp: PnP ACPI: found 11 devices
[    2.289751] ACPI: ACPI bus type pnp unregistered
[    2.349213] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    2.349305] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.349407] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.349506] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    2.349590] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    2.349669] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.349743] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    2.349824] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    2.349904] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.350004] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.350077] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    2.350158] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    2.350238] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.350337] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    2.350409] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    2.350490] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    2.350570] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    2.350669] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    2.350739] pci 0000:00:1e.0:   bridge window [io  disabled]
[    2.350819] pci 0000:00:1e.0:   bridge window [mem disabled]
[    2.350896] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.351025] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.351107] pci 0000:00:1c.0: setting latency timer to 64
[    2.351153] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.351234] pci 0000:00:1c.1: setting latency timer to 64
[    2.351278] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.351359] pci 0000:00:1c.3: setting latency timer to 64
[    2.351378] pci 0000:00:1e.0: setting latency timer to 64
[    2.351390] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.351397] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.351404] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.351412] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.351419] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.351426] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    2.351434] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    2.351440] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    2.351448] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.351455] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    2.351462] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    2.351469] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.351477] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    2.351484] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    2.351491] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    2.351499] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    2.351506] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    2.351512] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    2.351520] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.351527] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.351534] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    2.351855] NET: Registered protocol family 2
[    2.352533] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.356140] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.359302] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    2.367024] TCP: Hash tables configured (established 262144 bind 65536)
[    2.367162] TCP reno registered
[    2.367275] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    2.367910] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    2.369512] NET: Registered protocol family 1
[    2.369733] pci 0000:00:02.0: Boot video device
[    2.369894] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.369901] pci 0000:00:1a.0: Performing full reset
[    2.369956] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.369963] pci 0000:00:1a.1: Performing full reset
[    2.370017] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.370024] pci 0000:00:1a.2: Performing full reset
[    2.370341] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.370348] pci 0000:00:1d.0: Performing full reset
[    2.370402] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.370408] pci 0000:00:1d.1: Performing full reset
[    2.370462] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.370469] pci 0000:00:1d.2: Performing full reset
[    2.370765] PCI: CLS 64 bytes, default 64
[    2.371626] Trying to unpack rootfs image as initramfs...
[    4.628812] Freeing initrd memory: 34952k freed
[    4.994494] DMA-API: preallocated 32768 debug entries
[    4.994574] DMA-API: debugging enabled by kernel config
[    4.994657] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.994733] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    4.994821] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    4.995255] Simple Boot Flag at 0x35 set to 0x1
[    4.998625] Scanning for low memory corruption every 60 seconds
[    5.000614] audit: initializing netlink socket (disabled)
[    5.000856] type=2000 audit(1298999433.996:1): initialized
[    5.041520] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.101409] fuse init (API version 7.16)
[    5.103638] msgmni has been set to 7697
[    5.106580] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    5.106688] io scheduler noop registered
[    5.106755] io scheduler deadline registered
[    5.107574] io scheduler cfq registered (default)
[    5.111177] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.112182] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.113889] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.116520] ACPI: AC Adapter [AC] (off-line)
[    5.119752] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    5.148044] ACPI: Lid Switch [LID]
[    5.149660] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    5.200043] ACPI: Sleep Button [SLPB]
[    5.201705] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    5.201824] ACPI: Power Button [PWRF]
[    5.202322] ACPI: acpi_idle registered with cpuidle
[    5.479901] Monitor-Mwait will be used to enter C-1 state
[    5.480101] Monitor-Mwait will be used to enter C-2 state
[    5.480266] Monitor-Mwait will be used to enter C-3 state
[    5.480295] Marking TSC unstable due to TSC halts in idle
[    5.654039] thermal LNXTHERM:00: registered as thermal_zone0
[    5.654115] ACPI: Thermal Zone [THM0] (48 C)
[    5.675905] thermal LNXTHERM:01: registered as thermal_zone1
[    5.675980] ACPI: Thermal Zone [THM1] (50 C)
[    5.677312] Linux agpgart interface v0.103
[    5.715096] brd: module loaded
[    5.733869] loop: module loaded
[    5.737116] ahci 0000:00:1f.2: version 3.0
[    5.737233] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    5.737797] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    5.738032] ahci: SSS flag set, parallel bus scan disabled
[    5.738250] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    5.738403] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    5.738597] ahci 0000:00:1f.2: setting latency timer to 64
[    5.762241] scsi0 : ahci
[    5.765114] scsi1 : ahci
[    5.767894] scsi2 : ahci
[    5.770864] scsi3 : ahci
[    5.780167] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.780471] ACPI: Battery Slot [BAT0] (battery present)
[    5.792777] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 40
[    5.792869] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 40
[    5.792956] ata3: DUMMY
[    5.793017] ata4: DUMMY
[    5.794536] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.794917] ata_generic 0000:00:03.2: setting latency timer to 64
[    5.809432] scsi4 : ata_generic
[    5.811808] scsi5 : ata_generic
[    5.813945] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    5.814024] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    5.814739] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    5.814813] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.815060] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.815186] e1000e 0000:00:19.0: setting latency timer to 64
[    5.815759] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    6.112057] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.120456] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    6.120468] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    6.120561] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    6.137481] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    6.137575] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.137681] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    6.138124] PPP generic driver version 2.4.2
[    6.140095] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    6.151434] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.152451] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.154721] mousedev: PS/2 mouse device common for all mice
[    6.158116] rtc_cmos 00:07: RTC can wake from S4
[    6.162359] ata1.00: ATA-8: ST9250410AS, 0002SDM1, max UDMA/133
[    6.162435] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.164424] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    6.169482] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    6.169684] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.169908] Linux video capture interface: v2.00
[    6.171090] device-mapper: uevent: version 1.0.3
[    6.172308] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    6.172319] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    6.172413] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    6.172717] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    6.173244] device-mapper: multipath: version 1.2.0 loaded
[    6.173347] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.174762] ata1.00: configured for UDMA/133
[    6.176531] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      0002 PQ: 0 ANSI: 5
[    6.179668] cpuidle: using governor ladder
[    6.183356] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.183916] cpuidle: using governor menu
[    6.184957] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    6.186867] sd 0:0:0:0: [sda] Write Protect is off
[    6.186940] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.187388] TCP cubic registered
[    6.187562] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.190588] NET: Registered protocol family 10
[    6.196843] NET: Registered protocol family 17
[    6.197287] Bluetooth: L2CAP ver 2.15
[    6.197652] Bluetooth: L2CAP socket layer initialized
[    6.197761] Bluetooth: SCO (Voice Link) ver 0.6
[    6.197828] Bluetooth: SCO socket layer initialized
[    6.198240] Bluetooth: RFCOMM TTY layer initialized
[    6.198351] Bluetooth: RFCOMM socket layer initialized
[    6.198420] Bluetooth: RFCOMM ver 1.11
[    6.198485] Registering the dns_resolver key type
[    6.230102]  sda: sda1 sda2 < sda5 >
[    6.234717] registered taskstats version 1
[    6.235030] kmemleak: Kernel memory leak detector initialized
[    6.237644] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.237771] kmemleak: Automatic memory scanning thread started
[    6.238051] rtc_cmos 00:07: setting system clock to 2011-03-01 17:10:35 UTC (1298999435)
[    6.238160] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.238240] EDD information not available.
[    6.504086] ata2: SATA link down (SStatus 0 SControl 300)
[    6.674612] Freeing unused kernel memory: 524k freed
[    6.675088] Write protecting the kernel read-only data: 8192k
[    6.688716] Freeing unused kernel memory: 1360k freed
[    6.690038] Freeing unused kernel memory: 8k freed
[    6.695340] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    6.718874] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    7.005918] udevd (120): /proc/120/oom_adj is deprecated, please use /proc/120/oom_score_adj instead.
[    7.363838] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    7.364800] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    7.380548] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    7.383015] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    7.898893] usbcore: registered new interface driver usbfs
[    7.899956] usbcore: registered new interface driver hub
[    7.907629] [drm] Initialized drm 1.1.0 20060810
[    7.911598] usbcore: registered new device driver usb
[    7.954955] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.955042] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    7.955328] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    7.955445] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    7.955535] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    7.955778] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    7.955789] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    7.956077] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    7.965603] uhci_hcd: USB Universal Host Controller Interface driver
[    7.968486] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    7.968499] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    7.968931] ehci_hcd 0000:00:1a.7: debug port 1
[    7.969008] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.972924] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    7.972932] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    7.973299] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    7.973378] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.977514] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.990304] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    7.991535] usb usb1: default language 0x0409
[    7.991910] usb usb1: udev 1, busnum 1, minor = 0
[    7.991918] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.992142] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.992233] usb usb1: Product: EHCI Host Controller
[    7.992308] usb usb1: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    7.992384] usb usb1: SerialNumber: 0000:00:1a.7
[    7.994447] usb usb1: usb_probe_device
[    7.994457] usb usb1: configuration #1 chosen from 1 choice
[    7.994750] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.996146] hub 1-0:1.0: usb_probe_interface
[    7.996154] hub 1-0:1.0: usb_probe_interface - got id
[    7.996166] hub 1-0:1.0: USB hub found
[    7.996507] hub 1-0:1.0: 6 ports detected
[    7.996611] hub 1-0:1.0: standalone hub
[    7.996617] hub 1-0:1.0: no power switching (usb 1.0)
[    7.996623] hub 1-0:1.0: individual port over-current protection
[    7.996631] hub 1-0:1.0: power on to power good time: 20ms
[    7.996909] hub 1-0:1.0: local power source is good
[    7.996950] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    8.001808] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    8.001925] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    8.002014] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    8.002148] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.002158] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    8.002353] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[    8.012087] uhci_hcd 0000:00:1a.0: detected 2 ports
[    8.012170] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    8.012176] uhci_hcd 0000:00:1a.0: Performing full reset
[    8.012201] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    8.012586] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    8.013535] usb usb2: default language 0x0409
[    8.013914] usb usb2: udev 1, busnum 2, minor = 128
[    8.013922] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    8.013998] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.014085] usb usb2: Product: UHCI Host Controller
[    8.014154] usb usb2: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.014226] usb usb2: SerialNumber: 0000:00:1a.0
[    8.018769] usb usb2: usb_probe_device
[    8.018779] usb usb2: configuration #1 chosen from 1 choice
[    8.018962] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    8.020258] hub 2-0:1.0: usb_probe_interface
[    8.020265] hub 2-0:1.0: usb_probe_interface - got id
[    8.020276] hub 2-0:1.0: USB hub found
[    8.020564] hub 2-0:1.0: 2 ports detected
[    8.020671] hub 2-0:1.0: standalone hub
[    8.020677] hub 2-0:1.0: no power switching (usb 1.0)
[    8.020683] hub 2-0:1.0: individual port over-current protection
[    8.020690] hub 2-0:1.0: power on to power good time: 2ms
[    8.020912] hub 2-0:1.0: local power source is good
[    8.020955] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    8.024747] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    8.025267] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    8.025399] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    8.025409] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    8.025596] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    8.040342] uhci_hcd 0000:00:1a.1: detected 2 ports
[    8.040422] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    8.040429] uhci_hcd 0000:00:1a.1: Performing full reset
[    8.040813] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    8.041628] usb usb3: default language 0x0409
[    8.042005] usb usb3: udev 1, busnum 3, minor = 256
[    8.042013] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    8.042089] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.042176] usb usb3: Product: UHCI Host Controller
[    8.042245] usb usb3: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.042317] usb usb3: SerialNumber: 0000:00:1a.1
[    8.046692] usb usb3: usb_probe_device
[    8.046701] usb usb3: configuration #1 chosen from 1 choice
[    8.046882] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    8.048181] hub 3-0:1.0: usb_probe_interface
[    8.048189] hub 3-0:1.0: usb_probe_interface - got id
[    8.048199] hub 3-0:1.0: USB hub found
[    8.048498] hub 3-0:1.0: 2 ports detected
[    8.048607] hub 3-0:1.0: standalone hub
[    8.048613] hub 3-0:1.0: no power switching (usb 1.0)
[    8.048619] hub 3-0:1.0: individual port over-current protection
[    8.048627] hub 3-0:1.0: power on to power good time: 2ms
[    8.048868] hub 3-0:1.0: local power source is good
[    8.048913] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    8.052785] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    8.053367] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    8.053485] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    8.053608] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    8.053859] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    8.053870] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    8.054697] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    8.068340] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    8.068354] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    8.068743] ehci_hcd 0000:00:1d.7: debug port 1
[    8.068820] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    8.072716] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    8.072723] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    8.073092] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    8.073172] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    8.077071] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    8.088124] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    8.089094] usb usb4: default language 0x0409
[    8.089488] usb usb4: udev 1, busnum 4, minor = 384
[    8.089496] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    8.089573] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.089661] usb usb4: Product: EHCI Host Controller
[    8.089730] usb usb4: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    8.089801] usb usb4: SerialNumber: 0000:00:1d.7
[    8.094128] usb usb4: usb_probe_device
[    8.094138] usb usb4: configuration #1 chosen from 1 choice
[    8.094328] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    8.095638] hub 4-0:1.0: usb_probe_interface
[    8.095646] hub 4-0:1.0: usb_probe_interface - got id
[    8.095657] hub 4-0:1.0: USB hub found
[    8.096188] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    8.096216] hub 1-0:1.0: port 1: status 0501 change 0001
[    8.096385] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    8.096411] hub 1-0:1.0: port 3: status 0501 change 0001
[    8.096657] hub 4-0:1.0: 6 ports detected
[    8.096765] hub 4-0:1.0: standalone hub
[    8.096770] hub 4-0:1.0: no power switching (usb 1.0)
[    8.096776] hub 4-0:1.0: individual port over-current protection
[    8.096784] hub 4-0:1.0: power on to power good time: 20ms
[    8.097021] hub 4-0:1.0: local power source is good
[    8.097062] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    8.102471] i915 0000:00:02.0: power state changed by ACPI to D0
[    8.102594] i915 0000:00:02.0: power state changed by ACPI to D0
[    8.102678] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.102758] i915 0000:00:02.0: setting latency timer to 64
[    8.120117] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    8.132062] Monitor-Mwait will be used to enter C-3 state
[    8.148169] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    8.196106] hub 1-0:1.0: state 7 ports 6 chg 000a evt 0000
[    8.196186] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    8.196215] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[    8.196245] hub 4-0:1.0: port 2: status 0501 change 0001
[    8.196330] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    8.252096] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    8.252373] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    8.308289] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    8.308303] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    8.308331] hub 1-0:1.0: port 3 not reset yet, waiting 50ms
[    8.364121] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    8.364345] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    8.364425] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    8.364479] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    8.364555] hub 2-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    8.492142] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    8.518681] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    8.518875] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.518955] [drm] Driver supports precise vblank timestamp query.
[    8.604144] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    8.717577] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    8.762165] usb 2-1: skipped 1 descriptor after interface
[    8.762196] usb 2-1: skipped 1 descriptor after interface
[    8.767129] usb 2-1: default language 0x0409
[    8.782151] usb 2-1: udev 2, busnum 2, minor = 129
[    8.782159] usb 2-1: New USB device found, idVendor=046d, idProduct=c521
[    8.782236] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.782311] usb 2-1: Product: USB Receiver
[    8.782378] usb 2-1: Manufacturer: Logitech
[    8.784034] usb 2-1: usb_probe_device
[    8.784055] usb 2-1: configuration #1 chosen from 1 choice
[    8.795158] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    8.797054] usb 2-1: adding 2-1:1.1 (config #1, interface 1)
[    8.800879] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    8.800935] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    8.801016] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    8.835323] usbhid 2-1:1.0: usb_probe_interface
[    8.835333] usbhid 2-1:1.0: usb_probe_interface - got id
[    8.853993] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb2/2-1/2-1:1.0/input/input5
[    8.859541] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[    8.859746] usbhid 2-1:1.1: usb_probe_interface
[    8.859753] usbhid 2-1:1.1: usb_probe_interface - got id
[    8.895174] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb2/2-1/2-1:1.1/input/input6
[    8.895402] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    8.897027] usbhid 2-1:1.1: looking for a minor, starting at 96
[    8.899794] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[    8.900225] usbcore: registered new interface driver usbhid
[    8.900297] usbhid: USB HID core driver
[    8.932144] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    9.044136] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    9.088428] fb0: inteldrmfb frame buffer device
[    9.088502] drm: registered panic notifier
[    9.104182] hub 3-0:1.0: port 1 not reset yet, waiting 50ms
[    9.236082] usb 3-1: ep0 maxpacket = 8
[    9.267228] usb 3-1: default language 0x0409
[    9.276267] usb 3-1: udev 2, busnum 3, minor = 257
[    9.276276] usb 3-1: New USB device found, idVendor=08ff, idProduct=2810
[    9.276352] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    9.276428] usb 3-1: Product: Fingerprint Sensor
[    9.280528] usb 3-1: usb_probe_device
[    9.280539] usb 3-1: configuration #1 chosen from 1 choice
[    9.283247] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    9.288813] hub 4-0:1.0: state 7 ports 6 chg 0004 evt 0000
[    9.288890] hub 4-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    9.338349] acpi device:02: registered as cooling_device2
[    9.344349] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[    9.344971] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    9.345002] hub 4-0:1.0: port 2 not reset yet, waiting 50ms
[    9.347607] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    9.349322] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.351329] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    9.351567] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    9.351681] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    9.351804] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    9.351937] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    9.351947] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    9.352214] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    9.364140] uhci_hcd 0000:00:1a.2: detected 2 ports
[    9.364221] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    9.364228] uhci_hcd 0000:00:1a.2: Performing full reset
[    9.364252] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    9.364644] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    9.365532] usb usb5: default language 0x0409
[    9.365963] usb usb5: udev 1, busnum 5, minor = 512
[    9.365971] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    9.366048] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.366135] usb usb5: Product: UHCI Host Controller
[    9.366205] usb usb5: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    9.366277] usb usb5: SerialNumber: 0000:00:1a.2
[    9.373485] usb usb5: usb_probe_device
[    9.373496] usb usb5: configuration #1 chosen from 1 choice
[    9.373694] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    9.376715] hub 5-0:1.0: usb_probe_interface
[    9.376723] hub 5-0:1.0: usb_probe_interface - got id
[    9.376735] hub 5-0:1.0: USB hub found
[    9.377044] hub 5-0:1.0: 2 ports detected
[    9.377155] hub 5-0:1.0: standalone hub
[    9.377161] hub 5-0:1.0: no power switching (usb 1.0)
[    9.377167] hub 5-0:1.0: individual port over-current protection
[    9.377175] hub 5-0:1.0: power on to power good time: 2ms
[    9.377423] hub 5-0:1.0: local power source is good
[    9.377471] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    9.390314] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    9.390899] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    9.391015] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    9.391101] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.391235] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    9.391246] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    9.391444] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    9.397399] uhci_hcd 0000:00:1d.0: detected 2 ports
[    9.397412] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    9.397418] uhci_hcd 0000:00:1d.0: Performing full reset
[    9.397440] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    9.397841] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    9.398692] usb usb6: default language 0x0409
[    9.399134] usb usb6: udev 1, busnum 6, minor = 640
[    9.399140] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    9.399147] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.399153] usb usb6: Product: UHCI Host Controller
[    9.399157] usb usb6: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    9.399162] usb usb6: SerialNumber: 0000:00:1d.0
[    9.400215] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    9.400456] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    9.400535] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    9.403581] usb usb6: usb_probe_device
[    9.403590] usb usb6: configuration #1 chosen from 1 choice
[    9.403796] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    9.405295] hub 6-0:1.0: usb_probe_interface
[    9.405301] hub 6-0:1.0: usb_probe_interface - got id
[    9.405311] hub 6-0:1.0: USB hub found
[    9.405569] hub 6-0:1.0: 2 ports detected
[    9.405617] hub 6-0:1.0: standalone hub
[    9.405621] hub 6-0:1.0: no power switching (usb 1.0)
[    9.405626] hub 6-0:1.0: individual port over-current protection
[    9.405632] hub 6-0:1.0: power on to power good time: 2ms
[    9.405881] hub 6-0:1.0: local power source is good
[    9.405928] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    9.410346] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    9.410686] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.410746] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    9.410755] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    9.410887] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    9.413791] Console: switching to colour frame buffer device 180x56
[    9.420118] uhci_hcd 0000:00:1d.1: detected 2 ports
[    9.420131] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    9.420136] uhci_hcd 0000:00:1d.1: Performing full reset
[    9.420545] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    9.421392] usb usb7: default language 0x0409
[    9.421812] usb usb7: udev 1, busnum 7, minor = 768
[    9.421818] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    9.421825] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.421830] usb usb7: Product: UHCI Host Controller
[    9.421835] usb usb7: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    9.421840] usb usb7: SerialNumber: 0000:00:1d.1
[    9.424430] usb usb7: usb_probe_device
[    9.424439] usb usb7: configuration #1 chosen from 1 choice
[    9.424643] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    9.426062] hub 7-0:1.0: usb_probe_interface
[    9.426068] hub 7-0:1.0: usb_probe_interface - got id
[    9.426078] hub 7-0:1.0: USB hub found
[    9.426341] hub 7-0:1.0: 2 ports detected
[    9.426447] hub 7-0:1.0: standalone hub
[    9.426454] hub 7-0:1.0: no power switching (usb 1.0)
[    9.426459] hub 7-0:1.0: individual port over-current protection
[    9.426467] hub 7-0:1.0: power on to power good time: 2ms
[    9.426728] hub 7-0:1.0: local power source is good
[    9.426776] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    9.431472] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    9.431774] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    9.431929] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    9.431939] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    9.432555] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    9.452078] uhci_hcd 0000:00:1d.2: detected 2 ports
[    9.452156] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    9.452162] uhci_hcd 0000:00:1d.2: Performing full reset
[    9.452279] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    9.453185] usb usb8: default language 0x0409
[    9.453615] usb usb8: udev 1, busnum 8, minor = 896
[    9.453622] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    9.453715] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.453811] usb usb8: Product: UHCI Host Controller
[    9.453879] usb usb8: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    9.453958] usb usb8: SerialNumber: 0000:00:1d.2
[    9.459069] usb usb8: usb_probe_device
[    9.459077] usb usb8: configuration #1 chosen from 1 choice
[    9.459283] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    9.460822] hub 8-0:1.0: usb_probe_interface
[    9.460830] hub 8-0:1.0: usb_probe_interface - got id
[    9.460841] hub 8-0:1.0: USB hub found
[    9.464101] hub 8-0:1.0: 2 ports detected
[    9.467097] hub 8-0:1.0: standalone hub
[    9.467103] hub 8-0:1.0: no power switching (usb 1.0)
[    9.467109] hub 8-0:1.0: individual port over-current protection
[    9.467117] hub 8-0:1.0: power on to power good time: 2ms
[    9.467371] hub 8-0:1.0: local power source is good
[    9.467419] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    9.471965] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    9.476231] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.504195] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[    9.504221] hub 6-0:1.0: port 2: status 0101 change 0001
[    9.524244] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.564359] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.604244] hub 6-0:1.0: state 7 ports 2 chg 0004 evt 0000
[    9.604331] hub 6-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    9.720177] usb 6-2: new full speed USB device using uhci_hcd and address 2
[    9.780168] hub 6-0:1.0: port 2 not reset yet, waiting 50ms
[    9.912160] usb 6-2: ep0 maxpacket = 8
[    9.934223] usb 6-2: default language 0x0409
[    9.957261] usb 6-2: udev 2, busnum 6, minor = 641
[    9.957269] usb 6-2: New USB device found, idVendor=04b3, idProduct=301a
[    9.957276] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.957281] usb 6-2: Product: USB 1.1 2port downstream low power hub
[    9.957286] usb 6-2: Manufacturer: Lite-On Technology
[    9.959223] usb 6-2: usb_probe_device
[    9.959232] usb 6-2: configuration #1 chosen from 1 choice
[    9.973835] usb 6-2: adding 6-2:1.0 (config #1, interface 0)
[    9.977728] hub 6-2:1.0: usb_probe_interface
[    9.977734] hub 6-2:1.0: usb_probe_interface - got id
[    9.977744] hub 6-2:1.0: USB hub found
[    9.979230] hub 6-2:1.0: 3 ports detected
[    9.979271] hub 6-2:1.0: compound device; port removable status: FRR
[    9.979276] hub 6-2:1.0: individual port power switching
[    9.979280] hub 6-2:1.0: individual port over-current protection
[    9.979287] hub 6-2:1.0: power on to power good time: 44ms
[    9.980253] hub 6-2:1.0: hub controller current requirement: 100mA
[    9.980258] hub 6-2:1.0: 100mA bus power budget for each child
[    9.981748] hub 6-2:1.0: enabling power on all ports
[   10.086235] hub 6-2:1.0: port 1: status 0101 change 0001
[   10.188158] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   10.188213] hub 6-2:1.0: state 7 ports 3 chg 0002 evt 0000
[   10.190234] hub 6-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[   10.266225] usb 6-2.1: new full speed USB device using uhci_hcd and address 3
[   10.319434] PM: Starting manual resume from disk
[   10.368073] usb 6-2.1: ep0 maxpacket = 8
[   10.383799] EXT3-fs: barriers not enabled
[   10.390277] usb 6-2.1: skipped 1 descriptor after interface
[   10.390308] usb 6-2.1: skipped 1 descriptor after interface
[   10.393230] usb 6-2.1: default language 0x0409
[   10.410377] kjournald starting.  Commit interval 5 seconds
[   10.410815] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   10.425261] usb 6-2.1: udev 3, busnum 6, minor = 642
[   10.425269] usb 6-2.1: New USB device found, idVendor=04b3, idProduct=301b
[   10.428395] usb 6-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[   10.431497] usb 6-2.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[   10.434650] usb 6-2.1: Manufacturer: Lite-On Technology
[   10.439629] usb 6-2.1: usb_probe_device
[   10.439640] usb 6-2.1: configuration #1 chosen from 1 choice
[   10.445240] usb 6-2.1: adding 6-2.1:1.0 (config #1, interface 0)
[   10.448714] usbhid 6-2.1:1.0: usb_probe_interface
[   10.448723] usbhid 6-2.1:1.0: usb_probe_interface - got id
[   10.466980] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.0/input/input8
[   10.470509] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 17 us
[   10.474232] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input0
[   10.482228] usb 6-2.1: adding 6-2.1:1.1 (config #1, interface 1)
[   10.486714] usbhid 6-2.1:1.1: usb_probe_interface
[   10.486723] usbhid 6-2.1:1.1: usb_probe_interface - got id
[   10.497732] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.1/input/input9
[   10.501624] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 128, phase 0, 14 us
[   10.505251] generic-usb 0003:04B3:301B.0004: input,hidraw3: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input1
[   10.516148] hub 6-2:1.0: 356mA power budget left
[   10.516159] hub 6-2:1.0: state 7 ports 3 chg 0000 evt 0002
[   10.568070] usb usb5: suspend_rh (auto-stop)
[   10.568111] usb usb7: suspend_rh (auto-stop)
[   10.568146] usb usb8: suspend_rh (auto-stop)
[   10.824190] hub 1-0:1.0: hub_suspend
[   10.824298] usb usb1: bus auto-suspend
[   10.824306] ehci_hcd 0000:00:1a.7: suspend root hub
[   11.808148] hub 5-0:1.0: hub_suspend
[   11.808172] usb usb5: bus auto-suspend
[   11.808180] usb usb5: suspend_rh
[   11.824112] hub 4-0:1.0: hub_suspend
[   11.824131] usb usb4: bus auto-suspend
[   11.824138] ehci_hcd 0000:00:1d.7: suspend root hub
[   11.824186] hub 7-0:1.0: hub_suspend
[   11.824200] usb usb7: bus auto-suspend
[   11.824207] usb usb7: suspend_rh
[   11.824239] hub 8-0:1.0: hub_suspend
[   11.824253] usb usb8: bus auto-suspend
[   11.824260] usb usb8: suspend_rh
[   12.882029] Adding 5791396k swap on /dev/sda5.  Priority:-1 extents:1 across:5791396k 
[   13.429831] EXT3-fs (sda1): using internal journal
[   13.588845] udev: starting version 147
[   16.240668] cfg80211: Calling CRDA to update world regulatory domain
[   17.621605] cfg80211: World regulatory domain updated:
[   17.621614] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   17.621623] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.621632] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   17.621640] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   17.621647] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.621655] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.705974] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.818390] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   20.818399] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   20.819227] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   20.819245] iwlagn 0000:03:00.0: setting latency timer to 64
[   20.819433] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   20.841828] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   20.841836] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   20.842156] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   20.842799] iwlagn 0000:03:00.0: irq 43 for MSI/MSI-X
[   22.488193] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   22.582457] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   22.767132] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   22.767420] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   22.769121] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   23.993581] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   24.048229] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   24.049961] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   27.025054] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   27.026320] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.208395] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   36.116665] usb usb7: usb auto-resume
[   36.116676] usb usb7: wakeup_rh
[   36.156048] hub 7-0:1.0: hub_resume
[   36.156304] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.156820] usb usb8: usb auto-resume
[   36.156829] usb usb8: wakeup_rh
[   36.196107] hub 8-0:1.0: hub_resume
[   36.197682] usb usb5: usb auto-resume
[   36.197692] usb usb5: wakeup_rh
[   36.197738] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.236171] hub 5-0:1.0: hub_resume
[   36.236422] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.236947] usb usb1: usb auto-resume
[   36.236959] ehci_hcd 0000:00:1a.7: resume root hub
[   36.292171] hub 1-0:1.0: hub_resume
[   36.292782] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   36.293188] usb usb4: usb auto-resume
[   36.293200] ehci_hcd 0000:00:1d.7: resume root hub
[   36.344140] hub 4-0:1.0: hub_resume
[   36.344773] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   37.320058] eth0: no IPv6 routers present
[   37.352117] usb usb7: suspend_rh (auto-stop)
[   37.352157] usb usb5: suspend_rh (auto-stop)
[   37.356042] usb usb8: suspend_rh (auto-stop)
[   39.924055] hub 5-0:1.0: hub_suspend
[   39.924081] usb usb5: bus auto-suspend
[   39.924089] usb usb5: suspend_rh
[   39.924122] hub 1-0:1.0: hub_suspend
[   39.924136] usb usb1: bus auto-suspend
[   39.924143] ehci_hcd 0000:00:1a.7: suspend root hub
[   39.924190] hub 4-0:1.0: hub_suspend
[   39.924203] usb usb4: bus auto-suspend
[   39.924209] ehci_hcd 0000:00:1d.7: suspend root hub
[   39.924254] hub 7-0:1.0: hub_suspend
[   39.924267] usb usb7: bus auto-suspend
[   39.924273] usb usb7: suspend_rh
[   39.924303] hub 8-0:1.0: hub_suspend
[   39.924316] usb usb8: bus auto-suspend
[   39.924322] usb usb8: suspend_rh
[  114.778041] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[  186.437090] irq 23: nobody cared (try booting with the "irqpoll" option)
[  186.437103] Pid: 0, comm: swapper Not tainted 2.6.38-rc6+ #763
[  186.437109] Call Trace:
[  186.437115]  <IRQ>  [<ffffffff8109a256>] ? __report_bad_irq+0x26/0xa0
[  186.437139]  [<ffffffff8109a45c>] ? note_interrupt+0x18c/0x1d0
[  186.437150]  [<ffffffff8109addd>] ? handle_fasteoi_irq+0xcd/0x100
[  186.437161]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
[  186.437169]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
[  186.437180]  [<ffffffff8149f953>] ? ret_from_intr+0x0/0xe
[  186.437185]  <EOI>  [<ffffffff8100a5c7>] ? native_sched_clock+0x27/0x80
[  186.437206]  [<ffffffff8126f766>] ? acpi_idle_enter_simple+0xbe/0xf0
[  186.437216]  [<ffffffff8126f761>] ? acpi_idle_enter_simple+0xb9/0xf0
[  186.437226]  [<ffffffff8138af12>] ? cpuidle_idle_call+0x82/0xf0
[  186.437236]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
[  186.437247]  [<ffffffff8148a9cb>] ? rest_init+0xcb/0xe0
[  186.437256]  [<ffffffff8148a900>] ? rest_init+0x0/0xe0
[  186.437267]  [<ffffffff81895d6f>] ? start_kernel+0x38a/0x395
[  186.437277]  [<ffffffff81895321>] ? x86_64_start_reservations+0x131/0x135
[  186.437286]  [<ffffffff81895417>] ? x86_64_start_kernel+0xf2/0xf9
[  186.437292] handlers:
[  186.437296] [<ffffffffa01004c0>] (usb_hcd_irq+0x0/0x70 [usbcore])
[  186.437326] Disabling IRQ #23

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="good-dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc7+ (sarah@xanatos) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #764 SMP PREEMPT Tue Mar 1 09:54:54 PST 2011
[    0.000000] Command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: 74663HU/74663HU, BIOS 6DET44WW (2.08 ) 04/22/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdc00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdc00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000] kernel direct mapping tables up to bdc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bd8c1000-bd8c7000
[    0.000000] RAMDISK: 35e8e000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bdb7bdd4 00094 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bdb7bf00 000F4 (v03 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bdb7c2f4 0D881 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bdb8e000 00040
[    0.000000] ACPI: SSDT 00000000bdb7c0b4 00240 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bdb89b75 00052 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bdb89bc7 00078 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bdb89c3f 0003C (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bdb89c7b 00038 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bdb89dc2 00176 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bdb89f38 00028 (v01 LENOVO TP-6D    00002080  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bdb89f60 000A0 (v16 LENOVO TP-6D    00002080 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bdb8d203 0055F (v01 LENOVO TP-6D    00002080 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd907000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000bd8d4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d3000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d2000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff8800b0000000-ffff8800b37fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd6a1
[    0.000000]     0: 0x000bd6a7 -> 0x000bd7b7
[    0.000000]     0: 0x000bd80f -> 0x000bd8c7
[    0.000000]     0: 0x000bdbff -> 0x000bdc00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021944
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757922 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd6a1000 - 00000000bd6a7000
[    0.000000] PM: Registered nosave memory: 00000000bd7b7000 - 00000000bd80f000
[    0.000000] PM: Registered nosave memory: 00000000bd8c7000 - 00000000bd8d2000
[    0.000000] PM: Registered nosave memory: 00000000bd8d2000 - 00000000bd8d5000
[    0.000000] PM: Registered nosave memory: 00000000bd8d5000 - 00000000bd8d9000
[    0.000000] PM: Registered nosave memory: 00000000bd8d9000 - 00000000bd8dd000
[    0.000000] PM: Registered nosave memory: 00000000bd8dd000 - 00000000bd8e0000
[    0.000000] PM: Registered nosave memory: 00000000bd8e0000 - 00000000bd907000
[    0.000000] PM: Registered nosave memory: 00000000bd907000 - 00000000bd908000
[    0.000000] PM: Registered nosave memory: 00000000bd908000 - 00000000bdb0f000
[    0.000000] PM: Registered nosave memory: 00000000bdb0f000 - 00000000bdb9f000
[    0.000000] PM: Registered nosave memory: 00000000bdb9f000 - 00000000bdbff000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bd400000 s75840 r8192 d22464 u1048576
[    0.000000] pcpu-alloc: s75840 r8192 d22464 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1004242
[    0.000000] Kernel command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3906856k/5177344k available (4717k kernel code, 1089568k absent, 180920k reserved, 3987k data, 520k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
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
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1861.921 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.84 BogoMIPS (lpj=7447684)
[    0.008051] pid_max: default: 32768 minimum: 301
[    0.008408] Mount-cache hash table entries: 256
[    0.009655] Initializing cgroup subsys ns
[    0.009705] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.009773] Initializing cgroup subsys cpuacct
[    0.009828] Initializing cgroup subsys memory
[    0.009977] Initializing cgroup subsys freezer
[    0.010195] CPU: Physical Processor ID: 0
[    0.010242] CPU: Processor Core ID: 0
[    0.010287] using mwait in idle threads.
[    0.010333] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.010476] ... version:                2
[    0.010523] ... bit width:              40
[    0.010568] ... generic registers:      2
[    0.010614] ... value mask:             000000ffffffffff
[    0.011215] ... max period:             000000007fffffff
[    0.011263] ... fixed-purpose events:   3
[    0.011308] ... event mask:             0000000700000003
[    0.011415] ACPI: Core revision 20101013
[    0.172277] Setting APIC routing to flat
[    0.172792] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.213847] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.224151] NMI watchdog enabled, takes one hw-pmu counter.
[    0.236017] lockdep: fixing up alternatives.
[    0.240097] Booting Node   0, Processors  #1 Ok.
[    0.332074] NMI watchdog enabled, takes one hw-pmu counter.
[    0.336011] Brought up 2 CPUs
[    0.336059] Total of 2 processors activated (7447.74 BogoMIPS).
[    0.340916] NET: Registered protocol family 16
[    0.343254] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.343323] ACPI: bus type pci registered
[    0.344045] PCI: Using configuration type 1 for base access
[    0.357028] bio: create slab <bio-0> at 0
[    0.366145] ACPI: EC: EC description table is found, configuring boot EC
[    0.517744] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.562216] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.565280] ACPI: Dynamic OEM Table Load:
[    0.565393] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.569642] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.574753] ACPI: Dynamic OEM Table Load:
[    0.574866] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.613673] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.617721] ACPI: Dynamic OEM Table Load:
[    0.617834] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.631735] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.634588] ACPI: Dynamic OEM Table Load:
[    0.634701] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.654592] ACPI: Interpreter enabled
[    0.654642] ACPI: (supports S0 S3 S4 S5)
[    0.655213] ACPI: Using IOAPIC for interrupt routing
[    0.782246] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.784321] ACPI: Power Resource [PUBS] (on)
[    0.802556] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.802609] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.809880] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.810732] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.810785] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.810838] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.810901] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.810964] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.811028] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.811175] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.811268] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.811289] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.811302] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.811311] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.811378] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.811396] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.811493] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.811517] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.811581] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.811586] pci 0000:00:03.0: PME# disabled
[    0.811628] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.811649] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.811659] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.811670] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.811681] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.811691] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.811771] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.811791] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.811802] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.811962] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.812077] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.812093] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.812108] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.812201] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.812207] pci 0000:00:19.0: PME# disabled
[    0.812257] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.812332] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.812425] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.812500] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.812593] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.812668] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.812776] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.812810] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.812927] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.812934] pci 0000:00:1a.7: PME# disabled
[    0.812992] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.813019] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.813130] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.813136] pci 0000:00:1b.0: PME# disabled
[    0.813185] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.813299] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.813306] pci 0000:00:1c.0: PME# disabled
[    0.813358] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.813472] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.813478] pci 0000:00:1c.1: PME# disabled
[    0.813533] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.813647] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.813653] pci 0000:00:1c.3: PME# disabled
[    0.813714] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.813789] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.813882] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.813957] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.814050] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.814124] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.814233] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.814267] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.814384] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.814391] pci 0000:00:1d.7: PME# disabled
[    0.814443] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.814566] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.814774] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.814811] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.814826] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.814841] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.814856] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.814871] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.814886] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.814952] pci 0000:00:1f.2: PME# supported from D3hot
[    0.814958] pci 0000:00:1f.2: PME# disabled
[    0.815006] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.815034] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.815073] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.815212] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.815266] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.815273] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.815284] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.815493] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.815569] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.815814] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.815842] pci 0000:03:00.0: PME# disabled
[    0.815961] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.816008] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.816015] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.816025] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.816119] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.816173] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.816179] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.816190] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.816329] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.816386] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.816392] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.816403] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.816415] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.816427] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.816439] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.816450] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.816463] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.816474] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.816508] pci_bus 0000:00: on NUMA node 0
[    0.816532] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.823132] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.824570] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.826051] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    1.042766] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.045228] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.047537] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.049862] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.052293] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.054599] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.056921] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.059233] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.060648] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.060893] vgaarb: loaded
[    1.062357] SCSI subsystem initialized
[    1.062433] libata version 3.00 loaded.
[    1.062433] PCI: Using ACPI for IRQ routing
[    1.062433] PCI: pci_cache_line_size set to 64 bytes
[    1.064018] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.064031] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.064186] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.064320] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.064430] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.065581] Bluetooth: Core ver 2.15
[    1.065729] NET: Registered protocol family 31
[    1.065778] Bluetooth: HCI device and connection manager initialized
[    1.065843] Bluetooth: HCI socket layer initialized
[    1.066245] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.068221] Switching to clocksource tsc
[    1.068292] pnp: PnP ACPI init
[    1.068446] ACPI: bus type pnp registered
[    1.102248] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.102258] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.102268] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.102277] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.102286] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.102296] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.102305] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.102315] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.102324] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.102334] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.102343] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.102352] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.102362] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.102371] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.102380] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.102390] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.102399] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.103055] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.103263] pnp 00:01: [bus 00-ff]
[    1.103273] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.103282] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.103293] pnp 00:01: [io  0x0d00-0xffff window]
[    1.103303] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.103312] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.103324] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.103334] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.103344] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.103353] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.103363] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.103373] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.103382] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.103392] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.103401] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.103411] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.103420] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.103430] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.103440] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.103814] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.126196] pnp 00:02: [io  0x0010-0x001f]
[    1.126206] pnp 00:02: [io  0x0090-0x009f]
[    1.126215] pnp 00:02: [io  0x0024-0x0025]
[    1.126225] pnp 00:02: [io  0x0028-0x0029]
[    1.126234] pnp 00:02: [io  0x002c-0x002d]
[    1.126244] pnp 00:02: [io  0x0030-0x0031]
[    1.126253] pnp 00:02: [io  0x0034-0x0035]
[    1.126263] pnp 00:02: [io  0x0038-0x0039]
[    1.126272] pnp 00:02: [io  0x003c-0x003d]
[    1.126281] pnp 00:02: [io  0x00a4-0x00a5]
[    1.126290] pnp 00:02: [io  0x00a8-0x00a9]
[    1.126300] pnp 00:02: [io  0x00ac-0x00ad]
[    1.126309] pnp 00:02: [io  0x00b0-0x00b5]
[    1.126318] pnp 00:02: [io  0x00b8-0x00b9]
[    1.126327] pnp 00:02: [io  0x00bc-0x00bd]
[    1.126336] pnp 00:02: [io  0x0050-0x0053]
[    1.126346] pnp 00:02: [io  0x0072-0x0077]
[    1.126355] pnp 00:02: [io  0x002e-0x002f]
[    1.126365] pnp 00:02: [io  0x1000-0x107f]
[    1.126374] pnp 00:02: [io  0x1180-0x11ff]
[    1.126383] pnp 00:02: [io  0x0800-0x080f]
[    1.126392] pnp 00:02: [io  0x15e0-0x15ef]
[    1.126401] pnp 00:02: [io  0x1600-0x167f]
[    1.126411] pnp 00:02: [io  0x1680-0x169f]
[    1.126421] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.126430] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.126439] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.126449] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.126458] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.126470] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.127159] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.127805] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.128183] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.128318] pnp 00:04: [io  0x0000-0x000f]
[    1.128328] pnp 00:04: [io  0x0080-0x008f]
[    1.128339] pnp 00:04: [io  0x00c0-0x00df]
[    1.128349] pnp 00:04: [dma 4]
[    1.128717] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.128851] pnp 00:05: [io  0x0061]
[    1.129216] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.129350] pnp 00:06: [io  0x00f0]
[    1.129369] pnp 00:06: [irq 13]
[    1.129734] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.129869] pnp 00:07: [io  0x0070-0x0071]
[    1.129884] pnp 00:07: [irq 8]
[    1.130253] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.130388] pnp 00:08: [io  0x0060]
[    1.130398] pnp 00:08: [io  0x0064]
[    1.130412] pnp 00:08: [irq 1]
[    1.130777] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.130918] pnp 00:09: [irq 12]
[    1.131293] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.153281] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.153651] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.157790] pnp: PnP ACPI: found 11 devices
[    1.157840] ACPI: ACPI bus type pnp unregistered
[    1.157974] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.158041] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.158107] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.158174] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.158239] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.158306] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.158377] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.158448] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.158520] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.158592] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.158665] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.158737] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.158809] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.158880] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.158952] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.159054] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.159120] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.159186] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.159250] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.159317] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.159383] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.159448] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.159514] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.159580] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.159646] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.159712] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.159778] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.187884] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.187944] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.188027] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.188096] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.188152] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.188206] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.188258] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.188315] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.188371] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.188441] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.188493] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.188550] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.188606] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.188676] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.188728] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.188784] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.188840] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.188911] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.188961] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.189016] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.189070] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.189149] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.189206] pci 0000:00:1c.0: setting latency timer to 64
[    1.189227] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.189283] pci 0000:00:1c.1: setting latency timer to 64
[    1.189303] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.189359] pci 0000:00:1c.3: setting latency timer to 64
[    1.189369] pci 0000:00:1e.0: setting latency timer to 64
[    1.189375] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.189378] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.189381] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.189384] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.189387] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.189390] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.189393] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.189396] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.189400] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.189403] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.189406] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.189409] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.189412] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.189415] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.189418] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.189421] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.189424] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.189427] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.189430] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.189433] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.189436] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.189574] NET: Registered protocol family 2
[    1.189875] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.191431] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.193172] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.196409] TCP: Hash tables configured (established 262144 bind 65536)
[    1.196497] TCP reno registered
[    1.196566] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.196862] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.197560] NET: Registered protocol family 1
[    1.197678] pci 0000:00:02.0: Boot video device
[    1.197749] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.197751] pci 0000:00:1a.0: Performing full reset
[    1.197782] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.197784] pci 0000:00:1a.1: Performing full reset
[    1.197815] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.197818] pci 0000:00:1a.2: Performing full reset
[    1.197976] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.197979] pci 0000:00:1d.0: Performing full reset
[    1.198010] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.198013] pci 0000:00:1d.1: Performing full reset
[    1.198043] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.198046] pci 0000:00:1d.2: Performing full reset
[    1.198183] PCI: CLS 64 bytes, default 64
[    1.198544] Trying to unpack rootfs image as initramfs...
[    2.160016] Freeing initrd memory: 34184k freed
[    2.323644] DMA-API: preallocated 32768 debug entries
[    2.323700] DMA-API: debugging enabled by kernel config
[    2.323757] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.323809] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.323873] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.324123] Simple Boot Flag at 0x35 set to 0x1
[    2.325577] Scanning for low memory corruption every 60 seconds
[    2.326516] audit: initializing netlink socket (disabled)
[    2.326646] type=2000 audit(1299003974.324:1): initialized
[    2.343256] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.369237] fuse init (API version 7.15)
[    2.370231] msgmni has been set to 7697
[    2.371500] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.371571] io scheduler noop registered
[    2.371619] io scheduler deadline registered
[    2.371997] io scheduler cfq registered (default)
[    2.387161] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
[    2.387230] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.387310] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.388050] pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
[    2.388117] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.388192] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.388919] pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1d
[    2.388986] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.389060] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    2.390123] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.390181] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.390371] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    2.390425] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.391024] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    2.391213] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    2.391270] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    2.391448] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.392221] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    2.392521] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    2.392577] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    2.392865] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    2.392923] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    2.393209] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    2.393271] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.395223] ACPI: AC Adapter [AC] (on-line)
[    2.396823] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.397331] ACPI: Lid Switch [LID]
[    2.398051] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.398142] ACPI: Sleep Button [SLPB]
[    2.398873] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.398949] ACPI: Power Button [PWRF]
[    2.399186] ACPI: acpi_idle registered with cpuidle
[    2.521422] Monitor-Mwait will be used to enter C-1 state
[    2.521496] Monitor-Mwait will be used to enter C-2 state
[    2.521561] Monitor-Mwait will be used to enter C-3 state
[    2.521572] Marking TSC unstable due to TSC halts in idle
[    2.521717] Switching to clocksource hpet
[    2.620244] thermal LNXTHERM:00: registered as thermal_zone0
[    2.620296] ACPI: Thermal Zone [THM0] (54 C)
[    2.629700] thermal LNXTHERM:01: registered as thermal_zone1
[    2.629752] ACPI: Thermal Zone [THM1] (59 C)
[    2.630294] Linux agpgart interface v0.103
[    2.647358] brd: module loaded
[    2.655760] loop: module loaded
[    2.657453] ahci 0000:00:1f.2: version 3.0
[    2.657493] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.657711] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.657823] ahci: SSS flag set, parallel bus scan disabled
[    2.657901] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.658008] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.658147] ahci 0000:00:1f.2: setting latency timer to 64
[    2.668313] scsi0 : ahci
[    2.669589] scsi1 : ahci
[    2.670834] scsi2 : ahci
[    2.671962] scsi3 : ahci
[    2.698097] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 43
[    2.698209] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 43
[    2.698347] ata3: DUMMY
[    2.698424] ata4: DUMMY
[    2.698887] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.699080] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.706265] scsi4 : ata_generic
[    2.712123] scsi5 : ata_generic
[    2.713110] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.713171] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.713344] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    2.713395] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    2.713524] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.713600] e1000e 0000:00:19.0: setting latency timer to 64
[    2.713863] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    2.731633] ACPI: Battery Slot [BAT0] (battery present)
[    3.024044] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.027496] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.027561] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.027637] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    3.027850] PPP generic driver version 2.4.2
[    3.028750] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.029255] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.029260] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.029326] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.031270] ata1.00: ATA-8: ST9250410AS, 0002SDM1, max UDMA/133
[    3.031324] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.037892] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.037897] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.037973] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.039032] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.039104] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.039796] mice: PS/2 mouse device common for all mice
[    3.040062] ata1.00: configured for UDMA/133
[    3.041180] rtc_cmos 00:07: RTC can wake from S4
[    3.044254] ata1.00: configured for UDMA/133
[    3.044305] ata1: EH complete
[    3.045203] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      0002 PQ: 0 ANSI: 5
[    3.046268] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.047188] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    3.047923] sd 0:0:0:0: [sda] Write Protect is off
[    3.047975] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.048212] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.048762] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.048882] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.049001] Linux video capture interface: v2.00
[    3.049171] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.049837] device-mapper: uevent: version 1.0.3
[    3.050633] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    3.050891] device-mapper: multipath: version 1.1.1 loaded
[    3.050955] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.052746] cpuidle: using governor ladder
[    3.054335] cpuidle: using governor menu
[    3.055303] TCP cubic registered
[    3.056616] NET: Registered protocol family 10
[    3.057925] lo: Disabled Privacy Extensions
[    3.059224] NET: Registered protocol family 17
[    3.059406] Bluetooth: L2CAP ver 2.15
[    3.059454] Bluetooth: L2CAP socket layer initialized
[    3.059525] Bluetooth: SCO (Voice Link) ver 0.6
[    3.059574] Bluetooth: SCO socket layer initialized
[    3.059742] Bluetooth: RFCOMM TTY layer initialized
[    3.059809] Bluetooth: RFCOMM socket layer initialized
[    3.059860] Bluetooth: RFCOMM ver 1.11
[    3.059910] Registering the dns_resolver key type
[    3.104429]  sda: sda1 sda2 < sda5 >
[    3.106417] registered taskstats version 1
[    3.106646] kmemleak: Kernel memory leak detector initialized
[    3.106672] kmemleak: Automatic memory scanning thread started
[    3.108103] rtc_cmos 00:07: setting system clock to 2011-03-01 18:26:15 UTC (1299003975)
[    3.108169] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.108220] EDD information not available.
[    3.109047] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.368109] ata2: SATA link down (SStatus 0 SControl 300)
[    3.534667] Freeing unused kernel memory: 520k freed
[    3.534930] Write protecting the kernel read-only data: 8192k
[    3.535454] Freeing unused kernel memory: 1408k freed
[    3.536171] Freeing unused kernel memory: 28k freed
[    3.559355] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.577022] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    3.653766] udevd (121): /proc/121/oom_adj is deprecated, please use /proc/121/oom_score_adj instead.
[    3.806032] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    3.806459] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    3.828903] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    3.886278] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    3.986110] usbcore: registered new interface driver usbfs
[    3.986858] usbcore: registered new interface driver hub
[    3.998650] usbcore: registered new device driver usb
[    4.039034] uhci_hcd: USB Universal Host Controller Interface driver
[    4.039687] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.039924] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.039990] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.041204] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.043120] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.043180] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.043259] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.043265] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.043405] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.052873] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.052929] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.052932] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.052949] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.053125] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.053724] usb usb1: default language 0x0409
[    4.054024] usb usb1: udev 1, busnum 1, minor = 0
[    4.054027] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.054080] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.054145] usb usb1: Product: UHCI Host Controller
[    4.054195] usb usb1: Manufacturer: Linux 2.6.37-rc7+ uhci_hcd
[    4.054246] usb usb1: SerialNumber: 0000:00:1a.0
[    4.055632] usb usb1: usb_probe_device
[    4.055636] usb usb1: configuration #1 chosen from 1 choice
[    4.055754] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.057315] hub 1-0:1.0: usb_probe_interface
[    4.057319] hub 1-0:1.0: usb_probe_interface - got id
[    4.057324] hub 1-0:1.0: USB hub found
[    4.057489] hub 1-0:1.0: 2 ports detected
[    4.057552] hub 1-0:1.0: standalone hub
[    4.057555] hub 1-0:1.0: no power switching (usb 1.0)
[    4.057557] hub 1-0:1.0: individual port over-current protection
[    4.057561] hub 1-0:1.0: power on to power good time: 2ms
[    4.057682] hub 1-0:1.0: local power source is good
[    4.057699] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.059608] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.059782] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.059787] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.059890] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.061829] [drm] Initialized drm 1.1.0 20060810
[    4.064642] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.064699] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.064702] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.064890] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.065288] usb usb2: default language 0x0409
[    4.065457] usb usb2: udev 1, busnum 2, minor = 128
[    4.065460] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.065513] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.065576] usb usb2: Product: UHCI Host Controller
[    4.065626] usb usb2: Manufacturer: Linux 2.6.37-rc7+ uhci_hcd
[    4.065677] usb usb2: SerialNumber: 0000:00:1a.1
[    4.066539] usb usb2: usb_probe_device
[    4.066543] usb usb2: configuration #1 chosen from 1 choice
[    4.066626] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.067206] hub 2-0:1.0: usb_probe_interface
[    4.067209] hub 2-0:1.0: usb_probe_interface - got id
[    4.067214] hub 2-0:1.0: USB hub found
[    4.068460] hub 2-0:1.0: 2 ports detected
[    4.068528] hub 2-0:1.0: standalone hub
[    4.068531] hub 2-0:1.0: no power switching (usb 1.0)
[    4.068534] hub 2-0:1.0: individual port over-current protection
[    4.068537] hub 2-0:1.0: power on to power good time: 2ms
[    4.068643] hub 2-0:1.0: local power source is good
[    4.068661] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.071739] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.072744] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.072806] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.072942] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.072947] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.073051] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
[    4.088481] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.088488] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.088633] ehci_hcd 0000:00:1a.7: debug port 1
[    4.088688] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.092570] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.092574] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.092746] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.092800] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.096784] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.112053] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.112505] usb usb3: default language 0x0409
[    4.112651] usb usb3: udev 1, busnum 3, minor = 256
[    4.112655] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    4.112708] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.112770] usb usb3: Product: EHCI Host Controller
[    4.112819] usb usb3: Manufacturer: Linux 2.6.37-rc7+ ehci_hcd
[    4.112869] usb usb3: SerialNumber: 0000:00:1a.7
[    4.113649] usb usb3: usb_probe_device
[    4.113653] usb usb3: configuration #1 chosen from 1 choice
[    4.113737] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.114411] hub 3-0:1.0: usb_probe_interface
[    4.114414] hub 3-0:1.0: usb_probe_interface - got id
[    4.114419] hub 3-0:1.0: USB hub found
[    4.114571] hub 3-0:1.0: 6 ports detected
[    4.114640] hub 3-0:1.0: standalone hub
[    4.114643] hub 3-0:1.0: no power switching (usb 1.0)
[    4.114645] hub 3-0:1.0: individual port over-current protection
[    4.114649] hub 3-0:1.0: power on to power good time: 20ms
[    4.114751] hub 3-0:1.0: local power source is good
[    4.114770] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.116602] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.116618] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.117706] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.118858] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.118933] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.119012] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.119017] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.119120] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[    4.128191] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.128252] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.128255] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.128271] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.128424] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.128781] usb usb4: default language 0x0409
[    4.128929] usb usb4: udev 1, busnum 4, minor = 384
[    4.128932] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.128984] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.129046] usb usb4: Product: UHCI Host Controller
[    4.129094] usb usb4: Manufacturer: Linux 2.6.37-rc7+ uhci_hcd
[    4.129144] usb usb4: SerialNumber: 0000:00:1a.2
[    4.129911] usb usb4: usb_probe_device
[    4.129915] usb usb4: configuration #1 chosen from 1 choice
[    4.129995] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.130678] hub 4-0:1.0: usb_probe_interface
[    4.130681] hub 4-0:1.0: usb_probe_interface - got id
[    4.130685] hub 4-0:1.0: USB hub found
[    4.130853] hub 4-0:1.0: 2 ports detected
[    4.130917] hub 4-0:1.0: standalone hub
[    4.130920] hub 4-0:1.0: no power switching (usb 1.0)
[    4.130922] hub 4-0:1.0: individual port over-current protection
[    4.130925] hub 4-0:1.0: power on to power good time: 2ms
[    4.131134] hub 4-0:1.0: local power source is good
[    4.131153] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.132949] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.133364] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.133581] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.133637] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.133692] i915 0000:00:02.0: setting latency timer to 64
[    4.156090] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    4.168243] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.212074] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.212087] hub 3-0:1.0: port 1: status 0501 change 0001
[    4.212162] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.212172] hub 3-0:1.0: port 3: status 0501 change 0001
[    4.228116] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.256052] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.268057] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.287378] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    4.312074] hub 3-0:1.0: state 7 ports 6 chg 000a evt 0000
[    4.312114] hub 3-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.312174] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.368096] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.368227] hub 3-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.422353] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.428308] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.428313] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.428323] hub 3-0:1.0: port 3 not reset yet, waiting 50ms
[    4.484108] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.484210] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    4.484247] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.484276] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.484311] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    4.612099] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    4.724077] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    4.768744] fb0: inteldrmfb frame buffer device
[    4.768801] drm: registered panic notifier
[    4.866323] acpi device:02: registered as cooling_device2
[    4.870499] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    4.871228] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    4.871851] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.872716] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.873518] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.873596] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.873717] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.873722] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.873825] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    4.884065] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.884072] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.884216] ehci_hcd 0000:00:1d.7: debug port 1
[    4.884269] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.888146] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.888150] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.888327] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.888381] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.889484] usb 1-1: skipped 1 descriptor after interface
[    4.889496] usb 1-1: skipped 1 descriptor after interface
[    4.892260] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.894496] usb 1-1: default language 0x0409
[    4.903777] Console: switching to colour frame buffer device 180x56
[    4.904090] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.904525] usb usb5: default language 0x0409
[    4.904699] usb usb5: udev 1, busnum 5, minor = 512
[    4.904702] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    4.904706] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.904709] usb usb5: Product: EHCI Host Controller
[    4.904712] usb usb5: Manufacturer: Linux 2.6.37-rc7+ ehci_hcd
[    4.904715] usb usb5: SerialNumber: 0000:00:1d.7
[    4.905655] usb usb5: usb_probe_device
[    4.905659] usb usb5: configuration #1 chosen from 1 choice
[    4.905745] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.906361] hub 5-0:1.0: usb_probe_interface
[    4.906364] hub 5-0:1.0: usb_probe_interface - got id
[    4.906368] hub 5-0:1.0: USB hub found
[    4.906478] hub 5-0:1.0: 6 ports detected
[    4.906500] hub 5-0:1.0: standalone hub
[    4.906502] hub 5-0:1.0: no power switching (usb 1.0)
[    4.906504] hub 5-0:1.0: individual port over-current protection
[    4.906507] hub 5-0:1.0: power on to power good time: 20ms
[    4.906612] hub 5-0:1.0: local power source is good
[    4.906633] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.909500] usb 1-1: udev 2, busnum 1, minor = 1
[    4.909503] usb 1-1: New USB device found, idVendor=046d, idProduct=c521
[    4.909556] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.909596] usb 1-1: Product: USB Receiver
[    4.909622] usb 1-1: Manufacturer: Logitech
[    4.909709] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.910606] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.910652] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.910720] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.910725] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.910814] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.911093] usb 1-1: usb_probe_device
[    4.911097] usb 1-1: configuration #1 chosen from 1 choice
[    4.920169] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.920205] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.920208] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.920226] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.920404] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.920757] usb usb6: default language 0x0409
[    4.920912] usb usb6: udev 1, busnum 6, minor = 640
[    4.920915] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.920950] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.920987] usb usb6: Product: UHCI Host Controller
[    4.921013] usb usb6: Manufacturer: Linux 2.6.37-rc7+ uhci_hcd
[    4.921044] usb usb6: SerialNumber: 0000:00:1d.0
[    4.921506] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    4.922189] usb usb6: usb_probe_device
[    4.922193] usb usb6: configuration #1 chosen from 1 choice
[    4.922280] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.923253] hub 6-0:1.0: usb_probe_interface
[    4.923256] hub 6-0:1.0: usb_probe_interface - got id
[    4.923260] hub 6-0:1.0: USB hub found
[    4.923415] hub 6-0:1.0: 2 ports detected
[    4.923457] hub 6-0:1.0: standalone hub
[    4.923459] hub 6-0:1.0: no power switching (usb 1.0)
[    4.923461] hub 6-0:1.0: individual port over-current protection
[    4.923465] hub 6-0:1.0: power on to power good time: 2ms
[    4.923573] hub 6-0:1.0: local power source is good
[    4.923592] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.923600] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[    4.925461] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.925495] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    4.925498] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.925535] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    4.925642] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.925710] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.925715] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.925803] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.932141] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.932177] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.932180] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.932352] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.933943] usb usb7: default language 0x0409
[    4.934101] usb usb7: udev 1, busnum 7, minor = 768
[    4.934104] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.935355] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.936647] usb usb7: Product: UHCI Host Controller
[    4.937939] usb usb7: Manufacturer: Linux 2.6.37-rc7+ uhci_hcd
[    4.939232] usb usb7: SerialNumber: 0000:00:1d.1
[    4.941351] usb usb7: usb_probe_device
[    4.941355] usb usb7: configuration #1 chosen from 1 choice
[    4.941440] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.942139] hub 7-0:1.0: usb_probe_interface
[    4.942143] hub 7-0:1.0: usb_probe_interface - got id
[    4.942147] hub 7-0:1.0: USB hub found
[    4.943627] hub 7-0:1.0: 2 ports detected
[    4.944966] hub 7-0:1.0: standalone hub
[    4.944968] hub 7-0:1.0: no power switching (usb 1.0)
[    4.944970] hub 7-0:1.0: individual port over-current protection
[    4.944973] hub 7-0:1.0: power on to power good time: 2ms
[    4.945068] hub 7-0:1.0: local power source is good
[    4.945084] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.946839] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.946972] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.948386] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.948390] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.949682] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.960083] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.961351] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.961354] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.961406] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.962962] usb usb8: default language 0x0409
[    4.963119] usb usb8: udev 1, busnum 8, minor = 896
[    4.963121] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.964395] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.965611] usb usb8: Product: UHCI Host Controller
[    4.966828] usb usb8: Manufacturer: Linux 2.6.37-rc7+ uhci_hcd
[    4.968061] usb usb8: SerialNumber: 0000:00:1d.2
[    4.970075] usb usb8: usb_probe_device
[    4.970078] usb usb8: configuration #1 chosen from 1 choice
[    4.970165] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.970841] hub 8-0:1.0: usb_probe_interface
[    4.970844] hub 8-0:1.0: usb_probe_interface - got id
[    4.970849] hub 8-0:1.0: USB hub found
[    4.972449] hub 8-0:1.0: 2 ports detected
[    4.973724] hub 8-0:1.0: standalone hub
[    4.973726] hub 8-0:1.0: no power switching (usb 1.0)
[    4.973729] hub 8-0:1.0: individual port over-current protection
[    4.973731] hub 8-0:1.0: power on to power good time: 2ms
[    4.973825] hub 8-0:1.0: local power source is good
[    4.973841] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.975589] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.999486] usbhid 1-1:1.0: usb_probe_interface
[    4.999491] usbhid 1-1:1.0: usb_probe_interface - got id
[    5.004175] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[    5.004187] hub 5-0:1.0: port 2: status 0501 change 0001
[    5.015595] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input6
[    5.018879] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[    5.020339] uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
[    5.020519] usbhid 1-1:1.1: usb_probe_interface
[    5.020522] usbhid 1-1:1.1: usb_probe_interface - got id
[    5.051290] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.1/input/input7
[    5.052729] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    5.053379] usbhid 1-1:1.1: looking for a minor, starting at 96
[    5.054569] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[    5.056090] usbcore: registered new interface driver usbhid
[    5.057495] usbhid: USB HID core driver
[    5.060094] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.172098] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    5.308077] usb 2-1: ep0 maxpacket = 8
[    5.335118] usb 2-1: default language 0x0409
[    5.344132] usb 2-1: udev 2, busnum 2, minor = 129
[    5.344135] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.345470] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.346842] usb 2-1: Product: Fingerprint Sensor
[    5.348864] usb 2-1: usb_probe_device
[    5.348868] usb 2-1: configuration #1 chosen from 1 choice
[    5.351131] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.353156] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.353180] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.353196] hub 5-0:1.0: state 7 ports 6 chg 0004 evt 0000
[    5.353229] hub 5-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    5.360025] usb usb4: suspend_rh (auto-stop)
[    5.408408] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[    5.408808] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    5.408821] hub 5-0:1.0: port 2 not reset yet, waiting 50ms
[    5.464121] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.464233] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.464247] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0004
[    5.612147] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    5.612180] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[    5.612222] hub 6-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.735183] PM: Starting manual resume from disk
[    5.744112] hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.780356] EXT3-fs: barriers not enabled
[    5.806956] kjournald starting.  Commit interval 5 seconds
[    5.807113] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    5.856160] usb 6-2: new full speed USB device using uhci_hcd and address 2
[    5.992048] usb 6-2: ep0 maxpacket = 8
[    6.014607] usb 6-2: default language 0x0409
[    6.037617] usb 6-2: udev 2, busnum 6, minor = 641
[    6.037621] usb 6-2: New USB device found, idVendor=04b3, idProduct=301a
[    6.039119] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.040666] usb 6-2: Product: USB 1.1 2port downstream low power hub
[    6.042151] usb 6-2: Manufacturer: Lite-On Technology
[    6.044322] usb 6-2: usb_probe_device
[    6.044328] usb 6-2: configuration #1 chosen from 1 choice
[    6.049624] usb 6-2: adding 6-2:1.0 (config #1, interface 0)
[    6.051779] hub 6-2:1.0: usb_probe_interface
[    6.051783] hub 6-2:1.0: usb_probe_interface - got id
[    6.051788] hub 6-2:1.0: USB hub found
[    6.054617] hub 6-2:1.0: 3 ports detected
[    6.056065] hub 6-2:1.0: compound device; port removable status: FRR
[    6.056068] hub 6-2:1.0: individual port power switching
[    6.056071] hub 6-2:1.0: individual port over-current protection
[    6.056075] hub 6-2:1.0: power on to power good time: 44ms
[    6.056620] hub 6-2:1.0: hub controller current requirement: 100mA
[    6.056623] hub 6-2:1.0: 100mA bus power budget for each child
[    6.057633] hub 6-2:1.0: enabling power on all ports
[    6.104067] usb usb7: suspend_rh (auto-stop)
[    6.104100] usb usb8: suspend_rh (auto-stop)
[    6.161635] hub 6-2:1.0: port 1: status 0101 change 0001
[    6.264105] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    6.264138] hub 6-2:1.0: state 7 ports 3 chg 0002 evt 0000
[    6.265619] hub 6-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.341620] usb 6-2.1: new full speed USB device using uhci_hcd and address 3
[    6.440066] usb 6-2.1: ep0 maxpacket = 8
[    6.461632] usb 6-2.1: skipped 1 descriptor after interface
[    6.461646] usb 6-2.1: skipped 1 descriptor after interface
[    6.464602] usb 6-2.1: default language 0x0409
[    6.491614] usb 6-2.1: udev 3, busnum 6, minor = 642
[    6.491618] usb 6-2.1: New USB device found, idVendor=04b3, idProduct=301b
[    6.493068] usb 6-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    6.494457] usb 6-2.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[    6.495899] usb 6-2.1: Manufacturer: Lite-On Technology
[    6.498013] usb 6-2.1: usb_probe_device
[    6.498016] usb 6-2.1: configuration #1 chosen from 1 choice
[    6.503633] usb 6-2.1: adding 6-2.1:1.0 (config #1, interface 0)
[    6.505775] usbhid 6-2.1:1.0: usb_probe_interface
[    6.505778] usbhid 6-2.1:1.0: usb_probe_interface - got id
[    6.521125] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.0/input/input8
[    6.522645] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 17 us
[    6.524024] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input0
[    6.527497] usb 6-2.1: adding 6-2.1:1.1 (config #1, interface 1)
[    6.530776] usbhid 6-2.1:1.1: usb_probe_interface
[    6.530779] usbhid 6-2.1:1.1: usb_probe_interface - got id
[    6.535000] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.1/input/input9
[    6.536703] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 128, phase 0, 14 us
[    6.537969] generic-usb 0003:04B3:301B.0004: input,hidraw3: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-2.1/input1
[    6.542406] hub 6-2:1.0: 356mA power budget left
[    6.542411] hub 6-2:1.0: state 7 ports 3 chg 0000 evt 0002
[    6.824073] hub 4-0:1.0: hub_suspend
[    6.824118] usb usb4: bus auto-suspend
[    6.824122] usb usb4: suspend_rh
[    6.824144] hub 3-0:1.0: hub_suspend
[    6.824151] usb usb3: bus auto-suspend
[    6.824155] ehci_hcd 0000:00:1a.7: suspend root hub
[    7.824090] hub 7-0:1.0: hub_suspend
[    7.824103] usb usb7: bus auto-suspend
[    7.824107] usb usb7: suspend_rh
[    7.824129] hub 8-0:1.0: hub_suspend
[    7.824136] usb usb8: bus auto-suspend
[    7.824138] usb usb8: suspend_rh
[    7.824158] hub 5-0:1.0: hub_suspend
[    7.824164] usb usb5: bus auto-suspend
[    7.824167] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.025634] Adding 5791396k swap on /dev/sda5.  Priority:-1 extents:1 across:5791396k 
[    8.384577] EXT3-fs (sda1): using internal journal
[    8.455015] udev: starting version 147
[   10.418560] cfg80211: Calling CRDA to update world regulatory domain
[   12.013542] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.250698] cfg80211: World regulatory domain updated:
[   12.250702]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   12.250705]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.250708]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.250711]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.250714]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.250717]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.933602] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   14.933605] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   14.933963] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.933974] iwlagn 0000:03:00.0: setting latency timer to 64
[   14.934078] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   14.953434] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   14.953471] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   14.953582] iwlagn 0000:03:00.0: irq 46 for MSI/MSI-X
[   15.140845] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   15.140988] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   15.141172] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.002127] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   16.117784] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   19.436726] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   19.496143] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   19.496851] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.584897] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   22.585399] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.868171] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   29.816816] usb usb8: usb auto-resume
[   29.816821] usb usb8: wakeup_rh
[   29.856148] hub 8-0:1.0: hub_resume
[   29.856276] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   29.856502] usb usb7: usb auto-resume
[   29.856506] usb usb7: wakeup_rh
[   29.896041] hub 7-0:1.0: hub_resume
[   29.896748] usb usb5: usb auto-resume
[   29.896755] ehci_hcd 0000:00:1d.7: resume root hub
[   29.896764] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   29.948031] hub 5-0:1.0: hub_resume
[   29.948566] usb usb4: usb auto-resume
[   29.948571] usb usb4: wakeup_rh
[   29.948583] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   29.988119] hub 4-0:1.0: hub_resume
[   29.988424] usb usb3: usb auto-resume
[   29.988430] ehci_hcd 0000:00:1a.7: resume root hub
[   29.988460] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   30.040031] hub 3-0:1.0: hub_resume
[   30.040334] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   30.904113] usb usb7: suspend_rh (auto-stop)
[   30.908079] usb usb8: suspend_rh (auto-stop)
[   31.152094] usb usb4: suspend_rh (auto-stop)
[   32.816080] eth0: no IPv6 routers present
[   34.824083] hub 8-0:1.0: hub_suspend
[   34.824096] usb usb8: bus auto-suspend
[   34.824100] usb usb8: suspend_rh
[   34.824124] hub 7-0:1.0: hub_suspend
[   34.824131] usb usb7: bus auto-suspend
[   34.824134] usb usb7: suspend_rh
[   34.824154] hub 5-0:1.0: hub_suspend
[   34.824160] usb usb5: bus auto-suspend
[   34.824164] ehci_hcd 0000:00:1d.7: suspend root hub
[   34.824205] hub 4-0:1.0: hub_suspend
[   34.824211] usb usb4: bus auto-suspend
[   34.824214] usb usb4: suspend_rh
[   34.824233] hub 3-0:1.0: hub_suspend
[   34.824239] usb usb3: bus auto-suspend
[   34.824242] ehci_hcd 0000:00:1a.7: suspend root hub
[   80.685062] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[   93.863334] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[   93.980168] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[   93.980214] pci 0000:05:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[   93.980401] pci 0000:05:00.0: PME# supported from D0 D3hot
[   93.980410] pci 0000:05:00.0: PME# disabled
[   93.980500] pci 0000:05:00.0: BAR 0: assigned [mem 0xf0000000-0xf0001fff 64bit]
[   93.980514] pci 0000:05:00.0: BAR 0: set to [mem 0xf0000000-0xf0001fff 64bit] (PCI address [0xf0000000-0xf0001fff])
[   93.980521] pcieport 0000:00:1c.3: PCI bridge to [bus 05-0c]
[   93.980525] pcieport 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[   93.980533] pcieport 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[   93.980539] pcieport 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[   93.980560] pcieport 0000:00:1c.3: setting latency timer to 64
[   93.980656] pci 0000:05:00.0: no hotplug settings from platform
[   94.054949] xhci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
[   94.054961] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   94.055069] xhci_hcd 0000:05:00.0: setting latency timer to 64
[   94.055075] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   94.055138] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 9
[   94.060240] xhci_hcd 0000:05:00.0: xHCI capability registers at ffffc90000468000:
[   94.060246] xhci_hcd 0000:05:00.0: CAPLENGTH AND HCIVERSION 0x960020:
[   94.060248] xhci_hcd 0000:05:00.0: CAPLENGTH: 0x20
[   94.060251] xhci_hcd 0000:05:00.0: HCIVERSION: 0x96
[   94.060255] xhci_hcd 0000:05:00.0: HCSPARAMS 1: 0x4000820
[   94.060257] xhci_hcd 0000:05:00.0:   Max device slots: 32
[   94.060260] xhci_hcd 0000:05:00.0:   Max interrupters: 8
[   94.060262] xhci_hcd 0000:05:00.0:   Max ports: 4
[   94.060266] xhci_hcd 0000:05:00.0: HCSPARAMS 2: 0x11
[   94.060268] xhci_hcd 0000:05:00.0:   Isoc scheduling threshold: 1
[   94.060271] xhci_hcd 0000:05:00.0:   Maximum allowed segments in event ring: 1
[   94.060276] xhci_hcd 0000:05:00.0: HCSPARAMS 3 0x0:
[   94.060278] xhci_hcd 0000:05:00.0:   Worst case U1 device exit latency: 0
[   94.060280] xhci_hcd 0000:05:00.0:   Worst case U2 device exit latency: 0
[   94.060285] xhci_hcd 0000:05:00.0: HCC PARAMS 0x14042cb:
[   94.060288] xhci_hcd 0000:05:00.0:   HC generates 64 bit addresses
[   94.060290] xhci_hcd 0000:05:00.0:   FIXME: more HCCPARAMS debugging
[   94.060294] xhci_hcd 0000:05:00.0: RTSOFF 0x600:
[   94.060297] xhci_hcd 0000:05:00.0: xHCI operational registers at ffffc90000468020:
[   94.060301] xhci_hcd 0000:05:00.0: USBCMD 0x0:
[   94.060304] xhci_hcd 0000:05:00.0:   HC is being stopped
[   94.060306] xhci_hcd 0000:05:00.0:   HC has finished hard reset
[   94.060308] xhci_hcd 0000:05:00.0:   Event Interrupts disabled
[   94.060311] xhci_hcd 0000:05:00.0:   Host System Error Interrupts disabled
[   94.060313] xhci_hcd 0000:05:00.0:   HC has finished light reset
[   94.060318] xhci_hcd 0000:05:00.0: USBSTS 0x1:
[   94.060320] xhci_hcd 0000:05:00.0:   Event ring is empty
[   94.060322] xhci_hcd 0000:05:00.0:   No Host System Error
[   94.060325] xhci_hcd 0000:05:00.0:   HC is halted
[   94.060329] xhci_hcd 0000:05:00.0: ffffc90000468420 port status reg = 0x2a0
[   94.060334] xhci_hcd 0000:05:00.0: ffffc90000468424 port power reg = 0x0
[   94.060339] xhci_hcd 0000:05:00.0: ffffc90000468428 port link reg = 0x0
[   94.060344] xhci_hcd 0000:05:00.0: ffffc9000046842c port reserved reg = 0x0
[   94.060349] xhci_hcd 0000:05:00.0: ffffc90000468430 port status reg = 0x2a0
[   94.060354] xhci_hcd 0000:05:00.0: ffffc90000468434 port power reg = 0x0
[   94.060359] xhci_hcd 0000:05:00.0: ffffc90000468438 port link reg = 0x0
[   94.060364] xhci_hcd 0000:05:00.0: ffffc9000046843c port reserved reg = 0x0
[   94.060369] xhci_hcd 0000:05:00.0: ffffc90000468440 port status reg = 0x2a0
[   94.060373] xhci_hcd 0000:05:00.0: ffffc90000468444 port power reg = 0x0
[   94.060378] xhci_hcd 0000:05:00.0: ffffc90000468448 port link reg = 0x0
[   94.060383] xhci_hcd 0000:05:00.0: ffffc9000046844c port reserved reg = 0x0
[   94.060388] xhci_hcd 0000:05:00.0: ffffc90000468450 port status reg = 0x2a0
[   94.060392] xhci_hcd 0000:05:00.0: ffffc90000468454 port power reg = 0x0
[   94.060397] xhci_hcd 0000:05:00.0: ffffc90000468458 port link reg = 0x0
[   94.060402] xhci_hcd 0000:05:00.0: ffffc9000046845c port reserved reg = 0x0
[   94.060404] xhci_hcd 0000:05:00.0: // Halt the HC
[   94.060411] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468020, 32'h0, 4'hf);
[   94.060416] xhci_hcd 0000:05:00.0: Resetting HCD
[   94.060420] xhci_hcd 0000:05:00.0: // Reset the HC
[   94.060425] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468020, 32'h2, 4'hf);
[   94.060470] xhci_hcd 0000:05:00.0: Wait for controller to be ready for doorbell rings
[   94.060475] xhci_hcd 0000:05:00.0: Reset complete
[   94.060479] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[   94.060481] xhci_hcd 0000:05:00.0: Calling HCD init
[   94.060483] xhci_hcd 0000:05:00.0: xhci_init
[   94.060486] xhci_hcd 0000:05:00.0: xHCI doesn't need link TRB QUIRK
[   94.060490] xhci_hcd 0000:05:00.0: Supported page size register = 0x1
[   94.060493] xhci_hcd 0000:05:00.0: Supported page size of 4K
[   94.060495] xhci_hcd 0000:05:00.0: HCD page size set to 4K
[   94.060500] xhci_hcd 0000:05:00.0: // xHC can handle at most 32 device slots.
[   94.060505] xhci_hcd 0000:05:00.0: // Setting Max device slots reg = 0x20.
[   94.060508] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468058, 32'h20, 4'hf);
[   94.060522] xhci_hcd 0000:05:00.0: // Device context base array address = 0x37810000 (DMA), ffff880037810000 (virt)
[   94.060525] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000468050, 64'h37810000, 4'hf);
[   94.060576] xhci_hcd 0000:05:00.0: Allocating ring at ffff88012c8c8d80
[   94.060588] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff88013265a8e0
[   94.060611] xhci_hcd 0000:05:00.0: // Allocating segment at ffff880037811000 (virtual) 0x37811000 (DMA)
[   94.060617] xhci_hcd 0000:05:00.0: Linking segment 0x37811000 to segment 0x37811000 (DMA)
[   94.060620] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment ffff88013265a8e0 (virtual), 0x37811000 (DMA)
[   94.060623] xhci_hcd 0000:05:00.0: Allocated command ring at ffff88012c8c8d80
[   94.060625] xhci_hcd 0000:05:00.0: First segment DMA is 0x37811000
[   94.060631] xhci_hcd 0000:05:00.0: // Setting command ring address to 0x20
[   94.060634] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000468038, 64'h37811001, 4'hf);
[   94.060641] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   94.060644] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   94.060649] xhci_hcd 0000:05:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
[   94.060651] xhci_hcd 0000:05:00.0: // xHCI capability registers at ffffc90000468000:
[   94.060656] xhci_hcd 0000:05:00.0: // @ffffc90000468000 = 0x960020 (CAPLENGTH AND HCIVERSION)
[   94.060659] xhci_hcd 0000:05:00.0: //   CAPLENGTH: 0x20
[   94.060661] xhci_hcd 0000:05:00.0: // xHCI operational registers at ffffc90000468020:
[   94.060666] xhci_hcd 0000:05:00.0: // @ffffc90000468018 = 0x600 RTSOFF
[   94.060668] xhci_hcd 0000:05:00.0: // xHCI runtime registers at ffffc90000468600:
[   94.060673] xhci_hcd 0000:05:00.0: // @ffffc90000468014 = 0x800 DBOFF
[   94.060676] xhci_hcd 0000:05:00.0: // Doorbell array at ffffc90000468800:
[   94.060678] xhci_hcd 0000:05:00.0: xHCI runtime registers at ffffc90000468600:
[   94.060683] xhci_hcd 0000:05:00.0:   ffffc90000468600: Microframe index = 0x0
[   94.060697] xhci_hcd 0000:05:00.0: // Allocating event ring
[   94.060709] xhci_hcd 0000:05:00.0: Allocating ring at ffff88012c8c8ba0
[   94.060721] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff88013265a4e0
[   94.060724] xhci_hcd 0000:05:00.0: // Allocating segment at ffff880037811400 (virtual) 0x37811400 (DMA)
[   94.060728] xhci_hcd 0000:05:00.0: Linking segment 0x37811400 to segment 0x37811400 (DMA)
[   94.060731] xhci_hcd 0000:05:00.0: TRB math tests passed.
[   94.060742] xhci_hcd 0000:05:00.0: // Allocated event ring segment table at 0x37812000
[   94.060745] xhci_hcd 0000:05:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff880037812000, dma addr = 0x37812000
[   94.060751] xhci_hcd 0000:05:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[   94.060753] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468628, 32'h1, 4'hf);
[   94.060756] xhci_hcd 0000:05:00.0: // Set ERST entries to point to event ring.
[   94.060758] xhci_hcd 0000:05:00.0: // Set ERST base address for ir_set 0 = 0x37812000
[   94.060765] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000468630, 64'h37812000, 4'hf);
[   94.060772] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
[   94.060775] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000468638, 64'h37811400, 4'hf);
[   94.060777] xhci_hcd 0000:05:00.0: Wrote ERST address to ir_set 0.
[   94.060782] xhci_hcd 0000:05:00.0: Allocating 0 scratchpad buffers
[   94.060802] xhci_hcd 0000:05:00.0: Ext Cap ffffc90000468510, port offset = 1, count = 2, revision = 0x3
[   94.060809] xhci_hcd 0000:05:00.0: Ext Cap ffffc90000468520, port offset = 3, count = 2, revision = 0x2
[   94.060812] xhci_hcd 0000:05:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[   94.060823] xhci_hcd 0000:05:00.0: USB 2.0 port at index 2, addr = ffffc90000468440
[   94.060826] xhci_hcd 0000:05:00.0: USB 2.0 port at index 3, addr = ffffc90000468450
[   94.060837] xhci_hcd 0000:05:00.0: USB 3.0 port at index 0, addr = ffffc90000468420
[   94.060840] xhci_hcd 0000:05:00.0: USB 3.0 port at index 1, addr = ffffc90000468430
[   94.060842] xhci_hcd 0000:05:00.0: Finished xhci_init
[   94.060844] xhci_hcd 0000:05:00.0: Called HCD init
[   94.060849] xhci_hcd 0000:05:00.0: Got SBRN 48
[   94.060865] xhci_hcd 0000:05:00.0: MWI active
[   94.060867] xhci_hcd 0000:05:00.0: Finished xhci_pci_reinit
[   94.060870] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[   94.060912] xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0000000
[   94.060915] xhci_hcd 0000:05:00.0: xhci_run
[   94.061071] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[   94.061077] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[   94.061081] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[   94.061555] xhci_hcd 0000:05:00.0: Setting event ring polling timer
[   94.061558] xhci_hcd 0000:05:00.0: Command ring memory map follows:
[   94.061561] xhci_hcd 0000:05:00.0: @37811000 00000000 00000000 00000000 00000000
[   94.061564] xhci_hcd 0000:05:00.0: @37811010 00000000 00000000 00000000 00000000
[   94.061567] xhci_hcd 0000:05:00.0: @37811020 00000000 00000000 00000000 00000000
[   94.061569] xhci_hcd 0000:05:00.0: @37811030 00000000 00000000 00000000 00000000
[   94.061572] xhci_hcd 0000:05:00.0: @37811040 00000000 00000000 00000000 00000000
[   94.061575] xhci_hcd 0000:05:00.0: @37811050 00000000 00000000 00000000 00000000
[   94.061578] xhci_hcd 0000:05:00.0: @37811060 00000000 00000000 00000000 00000000
[   94.061581] xhci_hcd 0000:05:00.0: @37811070 00000000 00000000 00000000 00000000
[   94.061583] xhci_hcd 0000:05:00.0: @37811080 00000000 00000000 00000000 00000000
[   94.061586] xhci_hcd 0000:05:00.0: @37811090 00000000 00000000 00000000 00000000
[   94.061589] xhci_hcd 0000:05:00.0: @378110a0 00000000 00000000 00000000 00000000
[   94.061592] xhci_hcd 0000:05:00.0: @378110b0 00000000 00000000 00000000 00000000
[   94.061594] xhci_hcd 0000:05:00.0: @378110c0 00000000 00000000 00000000 00000000
[   94.061597] xhci_hcd 0000:05:00.0: @378110d0 00000000 00000000 00000000 00000000
[   94.061600] xhci_hcd 0000:05:00.0: @378110e0 00000000 00000000 00000000 00000000
[   94.061603] xhci_hcd 0000:05:00.0: @378110f0 00000000 00000000 00000000 00000000
[   94.061606] xhci_hcd 0000:05:00.0: @37811100 00000000 00000000 00000000 00000000
[   94.061608] xhci_hcd 0000:05:00.0: @37811110 00000000 00000000 00000000 00000000
[   94.061611] xhci_hcd 0000:05:00.0: @37811120 00000000 00000000 00000000 00000000
[   94.061614] xhci_hcd 0000:05:00.0: @37811130 00000000 00000000 00000000 00000000
[   94.061617] xhci_hcd 0000:05:00.0: @37811140 00000000 00000000 00000000 00000000
[   94.061619] xhci_hcd 0000:05:00.0: @37811150 00000000 00000000 00000000 00000000
[   94.061622] xhci_hcd 0000:05:00.0: @37811160 00000000 00000000 00000000 00000000
[   94.061625] xhci_hcd 0000:05:00.0: @37811170 00000000 00000000 00000000 00000000
[   94.061628] xhci_hcd 0000:05:00.0: @37811180 00000000 00000000 00000000 00000000
[   94.061631] xhci_hcd 0000:05:00.0: @37811190 00000000 00000000 00000000 00000000
[   94.061633] xhci_hcd 0000:05:00.0: @378111a0 00000000 00000000 00000000 00000000
[   94.061636] xhci_hcd 0000:05:00.0: @378111b0 00000000 00000000 00000000 00000000
[   94.061639] xhci_hcd 0000:05:00.0: @378111c0 00000000 00000000 00000000 00000000
[   94.061642] xhci_hcd 0000:05:00.0: @378111d0 00000000 00000000 00000000 00000000
[   94.061644] xhci_hcd 0000:05:00.0: @378111e0 00000000 00000000 00000000 00000000
[   94.061647] xhci_hcd 0000:05:00.0: @378111f0 00000000 00000000 00000000 00000000
[   94.061650] xhci_hcd 0000:05:00.0: @37811200 00000000 00000000 00000000 00000000
[   94.061653] xhci_hcd 0000:05:00.0: @37811210 00000000 00000000 00000000 00000000
[   94.061656] xhci_hcd 0000:05:00.0: @37811220 00000000 00000000 00000000 00000000
[   94.061658] xhci_hcd 0000:05:00.0: @37811230 00000000 00000000 00000000 00000000
[   94.061661] xhci_hcd 0000:05:00.0: @37811240 00000000 00000000 00000000 00000000
[   94.061664] xhci_hcd 0000:05:00.0: @37811250 00000000 00000000 00000000 00000000
[   94.061667] xhci_hcd 0000:05:00.0: @37811260 00000000 00000000 00000000 00000000
[   94.061670] xhci_hcd 0000:05:00.0: @37811270 00000000 00000000 00000000 00000000
[   94.061672] xhci_hcd 0000:05:00.0: @37811280 00000000 00000000 00000000 00000000
[   94.061675] xhci_hcd 0000:05:00.0: @37811290 00000000 00000000 00000000 00000000
[   94.061678] xhci_hcd 0000:05:00.0: @378112a0 00000000 00000000 00000000 00000000
[   94.061681] xhci_hcd 0000:05:00.0: @378112b0 00000000 00000000 00000000 00000000
[   94.061684] xhci_hcd 0000:05:00.0: @378112c0 00000000 00000000 00000000 00000000
[   94.061686] xhci_hcd 0000:05:00.0: @378112d0 00000000 00000000 00000000 00000000
[   94.061689] xhci_hcd 0000:05:00.0: @378112e0 00000000 00000000 00000000 00000000
[   94.061692] xhci_hcd 0000:05:00.0: @378112f0 00000000 00000000 00000000 00000000
[   94.061695] xhci_hcd 0000:05:00.0: @37811300 00000000 00000000 00000000 00000000
[   94.061697] xhci_hcd 0000:05:00.0: @37811310 00000000 00000000 00000000 00000000
[   94.061700] xhci_hcd 0000:05:00.0: @37811320 00000000 00000000 00000000 00000000
[   94.061703] xhci_hcd 0000:05:00.0: @37811330 00000000 00000000 00000000 00000000
[   94.061706] xhci_hcd 0000:05:00.0: @37811340 00000000 00000000 00000000 00000000
[   94.061709] xhci_hcd 0000:05:00.0: @37811350 00000000 00000000 00000000 00000000
[   94.061711] xhci_hcd 0000:05:00.0: @37811360 00000000 00000000 00000000 00000000
[   94.061714] xhci_hcd 0000:05:00.0: @37811370 00000000 00000000 00000000 00000000
[   94.061717] xhci_hcd 0000:05:00.0: @37811380 00000000 00000000 00000000 00000000
[   94.061720] xhci_hcd 0000:05:00.0: @37811390 00000000 00000000 00000000 00000000
[   94.061722] xhci_hcd 0000:05:00.0: @378113a0 00000000 00000000 00000000 00000000
[   94.061725] xhci_hcd 0000:05:00.0: @378113b0 00000000 00000000 00000000 00000000
[   94.061728] xhci_hcd 0000:05:00.0: @378113c0 00000000 00000000 00000000 00000000
[   94.061731] xhci_hcd 0000:05:00.0: @378113d0 00000000 00000000 00000000 00000000
[   94.061733] xhci_hcd 0000:05:00.0: @378113e0 00000000 00000000 00000000 00000000
[   94.061736] xhci_hcd 0000:05:00.0: @378113f0 37811000 00000000 00000000 00001802
[   94.061739] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   94.061742] xhci_hcd 0000:05:00.0: Ring deq = ffff880037811000 (virt), 0x37811000 (dma)
[   94.061744] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   94.061747] xhci_hcd 0000:05:00.0: Ring enq = ffff880037811000 (virt), 0x37811000 (dma)
[   94.061750] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   94.061756] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   94.061758] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   94.061761] xhci_hcd 0000:05:00.0: ERST memory map follows:
[   94.061764] xhci_hcd 0000:05:00.0: @37812000 37811400 00000000 00000040 00000000
[   94.061766] xhci_hcd 0000:05:00.0: Event ring:
[   94.061769] xhci_hcd 0000:05:00.0: @37811400 00000000 00000000 00000000 00000000
[   94.061771] xhci_hcd 0000:05:00.0: @37811410 00000000 00000000 00000000 00000000
[   94.061774] xhci_hcd 0000:05:00.0: @37811420 00000000 00000000 00000000 00000000
[   94.061777] xhci_hcd 0000:05:00.0: @37811430 00000000 00000000 00000000 00000000
[   94.061780] xhci_hcd 0000:05:00.0: @37811440 00000000 00000000 00000000 00000000
[   94.061783] xhci_hcd 0000:05:00.0: @37811450 00000000 00000000 00000000 00000000
[   94.061786] xhci_hcd 0000:05:00.0: @37811460 00000000 00000000 00000000 00000000
[   94.061788] xhci_hcd 0000:05:00.0: @37811470 00000000 00000000 00000000 00000000
[   94.061791] xhci_hcd 0000:05:00.0: @37811480 00000000 00000000 00000000 00000000
[   94.061794] xhci_hcd 0000:05:00.0: @37811490 00000000 00000000 00000000 00000000
[   94.061797] xhci_hcd 0000:05:00.0: @378114a0 00000000 00000000 00000000 00000000
[   94.061800] xhci_hcd 0000:05:00.0: @378114b0 00000000 00000000 00000000 00000000
[   94.061802] xhci_hcd 0000:05:00.0: @378114c0 00000000 00000000 00000000 00000000
[   94.061805] xhci_hcd 0000:05:00.0: @378114d0 00000000 00000000 00000000 00000000
[   94.061808] xhci_hcd 0000:05:00.0: @378114e0 00000000 00000000 00000000 00000000
[   94.061811] xhci_hcd 0000:05:00.0: @378114f0 00000000 00000000 00000000 00000000
[   94.061814] xhci_hcd 0000:05:00.0: @37811500 00000000 00000000 00000000 00000000
[   94.061816] xhci_hcd 0000:05:00.0: @37811510 00000000 00000000 00000000 00000000
[   94.061819] xhci_hcd 0000:05:00.0: @37811520 00000000 00000000 00000000 00000000
[   94.061822] xhci_hcd 0000:05:00.0: @37811530 00000000 00000000 00000000 00000000
[   94.061825] xhci_hcd 0000:05:00.0: @37811540 00000000 00000000 00000000 00000000
[   94.061828] xhci_hcd 0000:05:00.0: @37811550 00000000 00000000 00000000 00000000
[   94.061830] xhci_hcd 0000:05:00.0: @37811560 00000000 00000000 00000000 00000000
[   94.061833] xhci_hcd 0000:05:00.0: @37811570 00000000 00000000 00000000 00000000
[   94.061836] xhci_hcd 0000:05:00.0: @37811580 00000000 00000000 00000000 00000000
[   94.061839] xhci_hcd 0000:05:00.0: @37811590 00000000 00000000 00000000 00000000
[   94.061841] xhci_hcd 0000:05:00.0: @378115a0 00000000 00000000 00000000 00000000
[   94.061844] xhci_hcd 0000:05:00.0: @378115b0 00000000 00000000 00000000 00000000
[   94.061847] xhci_hcd 0000:05:00.0: @378115c0 00000000 00000000 00000000 00000000
[   94.061850] xhci_hcd 0000:05:00.0: @378115d0 00000000 00000000 00000000 00000000
[   94.061853] xhci_hcd 0000:05:00.0: @378115e0 00000000 00000000 00000000 00000000
[   94.061855] xhci_hcd 0000:05:00.0: @378115f0 00000000 00000000 00000000 00000000
[   94.061858] xhci_hcd 0000:05:00.0: @37811600 00000000 00000000 00000000 00000000
[   94.061861] xhci_hcd 0000:05:00.0: @37811610 00000000 00000000 00000000 00000000
[   94.061864] xhci_hcd 0000:05:00.0: @37811620 00000000 00000000 00000000 00000000
[   94.061867] xhci_hcd 0000:05:00.0: @37811630 00000000 00000000 00000000 00000000
[   94.061869] xhci_hcd 0000:05:00.0: @37811640 00000000 00000000 00000000 00000000
[   94.061872] xhci_hcd 0000:05:00.0: @37811650 00000000 00000000 00000000 00000000
[   94.061875] xhci_hcd 0000:05:00.0: @37811660 00000000 00000000 00000000 00000000
[   94.061878] xhci_hcd 0000:05:00.0: @37811670 00000000 00000000 00000000 00000000
[   94.061881] xhci_hcd 0000:05:00.0: @37811680 00000000 00000000 00000000 00000000
[   94.061883] xhci_hcd 0000:05:00.0: @37811690 00000000 00000000 00000000 00000000
[   94.061886] xhci_hcd 0000:05:00.0: @378116a0 00000000 00000000 00000000 00000000
[   94.061889] xhci_hcd 0000:05:00.0: @378116b0 00000000 00000000 00000000 00000000
[   94.061892] xhci_hcd 0000:05:00.0: @378116c0 00000000 00000000 00000000 00000000
[   94.061895] xhci_hcd 0000:05:00.0: @378116d0 00000000 00000000 00000000 00000000
[   94.061897] xhci_hcd 0000:05:00.0: @378116e0 00000000 00000000 00000000 00000000
[   94.061900] xhci_hcd 0000:05:00.0: @378116f0 00000000 00000000 00000000 00000000
[   94.061903] xhci_hcd 0000:05:00.0: @37811700 00000000 00000000 00000000 00000000
[   94.061906] xhci_hcd 0000:05:00.0: @37811710 00000000 00000000 00000000 00000000
[   94.061909] xhci_hcd 0000:05:00.0: @37811720 00000000 00000000 00000000 00000000
[   94.061911] xhci_hcd 0000:05:00.0: @37811730 00000000 00000000 00000000 00000000
[   94.061914] xhci_hcd 0000:05:00.0: @37811740 00000000 00000000 00000000 00000000
[   94.061917] xhci_hcd 0000:05:00.0: @37811750 00000000 00000000 00000000 00000000
[   94.061920] xhci_hcd 0000:05:00.0: @37811760 00000000 00000000 00000000 00000000
[   94.061923] xhci_hcd 0000:05:00.0: @37811770 00000000 00000000 00000000 00000000
[   94.061925] xhci_hcd 0000:05:00.0: @37811780 00000000 00000000 00000000 00000000
[   94.061928] xhci_hcd 0000:05:00.0: @37811790 00000000 00000000 00000000 00000000
[   94.061931] xhci_hcd 0000:05:00.0: @378117a0 00000000 00000000 00000000 00000000
[   94.061934] xhci_hcd 0000:05:00.0: @378117b0 00000000 00000000 00000000 00000000
[   94.061937] xhci_hcd 0000:05:00.0: @378117c0 00000000 00000000 00000000 00000000
[   94.061940] xhci_hcd 0000:05:00.0: @378117d0 00000000 00000000 00000000 00000000
[   94.061942] xhci_hcd 0000:05:00.0: @378117e0 00000000 00000000 00000000 00000000
[   94.061945] xhci_hcd 0000:05:00.0: @378117f0 00000000 00000000 00000000 00000000
[   94.061948] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   94.061950] xhci_hcd 0000:05:00.0: Ring deq = ffff880037811400 (virt), 0x37811400 (dma)
[   94.061953] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   94.061956] xhci_hcd 0000:05:00.0: Ring enq = ffff880037811400 (virt), 0x37811400 (dma)
[   94.061958] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   94.061965] xhci_hcd 0000:05:00.0: ERST deq = 64'h37811400
[   94.061967] xhci_hcd 0000:05:00.0: // Set the interrupt modulation register
[   94.061972] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468624, 32'ha0, 4'hf);
[   94.061977] xhci_hcd 0000:05:00.0: // Enable interrupts, cmd = 0x4.
[   94.061979] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468020, 32'h4, 4'hf);
[   94.061984] xhci_hcd 0000:05:00.0: // Enabling event ring interrupter ffffc90000468620 by writing 0x2 to irq_pending
[   94.061987] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468620, 32'h2, 4'hf);
[   94.061993] xhci_hcd 0000:05:00.0:   ffffc90000468620: ir_set[0]
[   94.061995] xhci_hcd 0000:05:00.0:   ffffc90000468620: ir_set.pending = 0x2
[   94.062000] xhci_hcd 0000:05:00.0:   ffffc90000468624: ir_set.control = 0xa0
[   94.062005] xhci_hcd 0000:05:00.0:   ffffc90000468628: ir_set.erst_size = 0x1
[   94.062013] xhci_hcd 0000:05:00.0:   ffffc90000468630: ir_set.erst_base = @37812000
[   94.062020] xhci_hcd 0000:05:00.0:   ffffc90000468638: ir_set.erst_dequeue = @37811400
[   94.062022] xhci_hcd 0000:05:00.0: Endpoint state = 0x1
[   94.062025] xhci_hcd 0000:05:00.0: Command ring enq = 0x37811010 (DMA)
[   94.062030] xhci_hcd 0000:05:00.0: // Turn on HC, cmd = 0x5.
[   94.062032] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468020, 32'h5, 4'hf);
[   94.063868] xhci_hcd 0000:05:00.0: // Ding dong!
[   94.063873] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468800, 32'h0, 4'hf);
[   94.063878] xhci_hcd 0000:05:00.0: Finished xhci_run
[   94.064026] xhci_hcd 0000:05:00.0: op reg status = 00000008
[   94.064029] xhci_hcd 0000:05:00.0: Event ring dequeue ptr:
[   94.064032] xhci_hcd 0000:05:00.0: @37811400 37811000 00000000 01003021 0000c001
[   94.064033] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468024, 32'h8, 4'hf);
[   94.064033] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   94.064033] xhci_hcd 0000:05:00.0: xhci_handle_event - OS owns TRB
[   94.064033] xhci_hcd 0000:05:00.0: Vendor specific event TRB type = 48
[   94.064033] xhci_hcd 0000:05:00.0: NEC firmware version 30.21
[   94.064033] xhci_hcd 0000:05:00.0: Command ring deq = 0x37811010 (DMA)
[   94.064033] xhci_hcd 0000:05:00.0: Event ring deq = 0x37811410 (DMA)
[   94.064033] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   94.064033] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90000468638, 64'h37811418, 4'hf);
[   94.064230] usb usb9: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[   94.064296] usb usb9: default language 0x0409
[   94.064502] usb usb9: udev 1, busnum 9, minor = 1024
[   94.064505] usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
[   94.064508] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   94.064512] usb usb9: Product: xHCI Host Controller
[   94.064515] usb usb9: Manufacturer: Linux 2.6.37-rc7+ xhci_hcd
[   94.064518] usb usb9: SerialNumber: 0000:05:00.0
[   94.065582] usb usb9: usb_probe_device
[   94.065586] usb usb9: configuration #1 chosen from 1 choice
[   94.065625] xHCI xhci_add_endpoint called for root hub
[   94.065627] xHCI xhci_check_bandwidth called for root hub
[   94.065696] usb usb9: adding 9-0:1.0 (config #1, interface 0)
[   94.066521] hub 9-0:1.0: usb_probe_interface
[   94.066524] hub 9-0:1.0: usb_probe_interface - got id
[   94.066530] hub 9-0:1.0: USB hub found
[   94.066698] hub 9-0:1.0: 4 ports detected
[   94.066723] hub 9-0:1.0: standalone hub
[   94.066726] hub 9-0:1.0: individual port power switching
[   94.066728] hub 9-0:1.0: individual port over-current protection
[   94.066734] hub 9-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   94.066736] hub 9-0:1.0: power on to power good time: 20ms
[   94.066881] hub 9-0:1.0: local power source is good
[   94.066906] hub 9-0:1.0: enabling power on all ports
[   94.066966] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468420, 32'h2a0, 4'hf);
[   94.066974] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[   94.067043] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468430, 32'h2a0, 4'hf);
[   94.067052] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[   94.067119] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468440, 32'h2a0, 4'hf);
[   94.067127] xhci_hcd 0000:05:00.0: set port power, actual port 2 status  = 0x2a0
[   94.067193] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468450, 32'h2a0, 4'hf);
[   94.067200] xhci_hcd 0000:05:00.0: set port power, actual port 3 status  = 0x2a0
[   94.083505] usb usb8: usb auto-resume
[   94.083510] usb usb8: wakeup_rh
[   94.120021] hub 8-0:1.0: hub_resume
[   94.120140] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   94.120324] usb usb7: usb auto-resume
[   94.120328] usb usb7: wakeup_rh
[   94.160019] hub 7-0:1.0: hub_resume
[   94.160147] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   94.160622] usb usb5: usb auto-resume
[   94.160627] ehci_hcd 0000:00:1d.7: resume root hub
[   94.164064] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   94.164068] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   94.164106] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   94.164109] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   94.164145] xhci_hcd 0000:05:00.0: get port status, actual port 2 status  = 0x2a0
[   94.164148] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   94.164184] xhci_hcd 0000:05:00.0: get port status, actual port 3 status  = 0x2a0
[   94.164187] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   94.164213] hub 9-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   94.212019] hub 5-0:1.0: hub_resume
[   94.212436] usb usb4: usb auto-resume
[   94.212440] usb usb4: wakeup_rh
[   94.212450] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   94.252063] hub 4-0:1.0: hub_resume
[   94.252191] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   94.252315] usb usb3: usb auto-resume
[   94.252320] ehci_hcd 0000:00:1a.7: resume root hub
[   94.304069] hub 3-0:1.0: hub_resume
[   94.304362] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   95.136140] usb usb8: suspend_rh (auto-stop)
[   95.384168] usb usb7: suspend_rh (auto-stop)
[   95.384195] usb usb4: suspend_rh (auto-stop)
[   96.808106] hub 9-0:1.0: hub_suspend
[   96.808118] usb usb9: bus auto-suspend
[   96.808122] xhci_hcd 0000:05:00.0: suspend root hub
[   96.808129] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468450, 32'ha0002a0, 4'hf);
[   96.808137] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468440, 32'ha0002a0, 4'hf);
[   96.808145] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468430, 32'ha0002a0, 4'hf);
[   96.808153] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90000468420, 32'ha0002a0, 4'hf);
[   96.808162] hub 8-0:1.0: hub_suspend
[   96.808168] usb usb8: bus auto-suspend
[   96.808171] usb usb8: suspend_rh
[   96.808192] hub 7-0:1.0: hub_suspend
[   96.808199] usb usb7: bus auto-suspend
[   96.808202] usb usb7: suspend_rh
[   96.808220] hub 5-0:1.0: hub_suspend
[   96.808227] usb usb5: bus auto-suspend
[   96.808230] ehci_hcd 0000:00:1d.7: suspend root hub
[   96.808259] hub 4-0:1.0: hub_suspend
[   96.808265] usb usb4: bus auto-suspend
[   96.808268] usb usb4: suspend_rh
[   96.808287] hub 3-0:1.0: hub_suspend
[   96.808293] usb usb3: bus auto-suspend
[   96.808295] ehci_hcd 0000:00:1a.7: suspend root hub

--61jdw2sOBCFtR2d/--
