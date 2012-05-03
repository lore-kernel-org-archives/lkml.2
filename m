Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2ECBmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 21:42:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:42036 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2ECBl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 21:41:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="136397759"
Date: Wed, 2 May 2012 18:41:46 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.4-rc5: Oops in klist_del()
Message-ID: <20120503014146.GA23805@xanatos>
References: <4F9F02A0.9020207@fold.natur.cuni.cz>
 <4F9F0AF3.8060409@fold.natur.cuni.cz>
 <CAE9FiQXuR7QJnvZxS7amXW=Z2e49tgrY6-5dHmq2LR1a+yiVdA@mail.gmail.com>
 <4FA118BE.5040000@fold.natur.cuni.cz>
 <4FA16123.7070602@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA16123.7070602@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 06:30:27PM +0200, Martin Mokrejs wrote:
> Martin Mokrejs wrote:
> I had a bright idea to disable internal USB ports in BIOS (three chips are affected:
> one doing EHCI, another doing EHCI/eSATA, third doing xHCI). Now, ignoring the "echo" trick
> I can unplug the card and its removal gets always reported by pciehp, doesn't
> mateer the device was claimed by xhci_hcd which so far always caused bad reports of the card
> removal). Remember that i newer had the problems with FireWire or RS232 express card?

Ohh, that's very odd.  Maybe your BIOS can't handle additional xHCI host
controllers?

> There are two problems when the internal USB chips are disabled:
> 
> 1. xhci_hcd creates usb3 and usb4 with two ports on each hub/bus? The express card has just two
> sockets providing USB 3.0.

Yes, that's expected.  The two USB ports on the Express Card are
actually four physical ports.  Each blue port you see provides one USB
2.0 connection and one USB 3.0 connection.  The xHCI driver registers
two USB roothubs, one that handles the USB 2.0 ports, and the other that
handles USB 3.0 ports.  Those are your usb3 and usb4 buses.

> When the card is unplugged, xhci_hcd disables always the latter bus,
> usb4 and I see also 3-2 being disabled at about that time.
> [  674.441808] xhci_hcd 0000:11:00.0: HW died, freeing TD.

Yes, that's expected.

> To realize that usb3 is gone as well it takes it about 50-60 seconds.
> [  704.665786] xhci_hcd 0000:11:00.0: HW died, polling stopped.

I assume you have CONFIG_USB_XHCI_HCD_DEBUGGING turned on then?  That
message is just the polling loop realizing that the hardware is gone.
If you disable xHCI debugging, you won't see that message.

> 2. if I re-insert the card quickly before the xhci_hcd disabled the usb3 the message
> "cannot hot-add" from pciehp pops in. The system is doing fine and would I give xhci_hcd those 50-60s
> I could remove the card safely. But, if I remove the card before that I get the Oops
> because the device is to be remnoved from sysfs by pciehp directly. That is not logged
> only partially on my remote serial console, just a few lines of the stacktrace,
> but always speak about sysfs_remove_group() and '0000:11:00.0'. I see in pciehp
> output only '0000:11:00', without the trailing '.0'.
> 
> You know, I don't understand kernel stuff, these are just my user observations, trying to
> figure out why the problem is only with USB3.0 express card. The "Surprise removal"
> messages probably appear only because pciehp is thinking the additional usb bus/hub is still
> present?

I can't help you with that, since I'm not a PCI hot-add expert.
Hopefully Yinghai can help.

Sarah Sharp


> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.4.0-rc5-default (root@vostro) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.1, pie-0.4.7) ) #9 SMP Wed May 2 16:46:19 MEST 2012
> [    0.000000] Command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
> [    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
> [    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
> [    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
> [    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
> [    0.000000]  BIOS-e820: 0000000040200000 - 00000000da4e5000 (usable)
> [    0.000000]  BIOS-e820: 00000000da4e5000 - 00000000da528000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000da528000 - 00000000da793000 (usable)
> [    0.000000]  BIOS-e820: 00000000da793000 - 00000000da967000 (reserved)
> [    0.000000]  BIOS-e820: 00000000da967000 - 00000000dacbc000 (usable)
> [    0.000000]  BIOS-e820: 00000000dacbc000 - 00000000dad68000 (reserved)
> [    0.000000]  BIOS-e820: 00000000dad68000 - 00000000dafe8000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000dafe8000 - 00000000db000000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000db800000 - 00000000dfa00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000041fe00000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.6 present.
> [    0.000000] DMI: Dell Inc. Vostro 3550/0JGC48, BIOS A09 09/30/2011
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask C00000000 write-back
> [    0.000000]   1 base 400000000 mask FE0000000 write-back
> [    0.000000]   2 base 0DB800000 mask FFF800000 uncachable
> [    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
> [    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   5 base 41FE00000 mask FFFE00000 uncachable
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820 update range: 00000000db800000 - 0000000100000000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0xdacbc max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
> [    0.000000] init_memory_mapping: 0000000000000000-00000000dacbc000
> [    0.000000]  0000000000 - 00dac00000 page 2M
> [    0.000000]  00dac00000 - 00dacbc000 page 4k
> [    0.000000] kernel direct mapping tables up to dacbc000 @ 1fffa000-20000000
> [    0.000000] init_memory_mapping: 0000000100000000-000000041fe00000
> [    0.000000]  0100000000 - 041fe00000 page 2M
> [    0.000000] kernel direct mapping tables up to 41fe00000 @ dacaa000-dacbc000
> [    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02   DELL)
> [    0.000000] ACPI: XSDT 00000000dafe8078 00074 (v01 DELL    WN09    01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 00000000daff1d08 000F4 (v04   DELL     WN09 01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 00000000dafe8180 09B85 (v02   DELL     WN09 00000000 INTL 20051117)
> [    0.000000] ACPI: FACS 00000000dafe3f80 00040
> [    0.000000] ACPI: APIC 00000000daff1e00 00072 (v03   DELL     WN09 01072009 AMI  00010013)
> [    0.000000] ACPI: MCFG 00000000daff1e78 0003C (v01   DELL     WN09 01072009 MSFT 00000097)
> [    0.000000] ACPI: SSDT 00000000daff1eb8 004B0 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
> [    0.000000] ACPI: SLIC 00000000daff2368 00176 (v01 DELL    WN09    01072009 AMI  00010013)
> [    0.000000] ACPI: HPET 00000000daff24e0 00038 (v01   DELL     WN09 01072009 AMI. 00000004)
> [    0.000000] ACPI: SSDT 00000000daff2518 00846 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 00000000daff2d60 00996 (v01  PmRef    CpuPm 00003000 INTL 20051117)
> [    0.000000] ACPI: DMAR 00000000daff36f8 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
> [    0.000000] ACPI: OSFR 00000000daff37e0 00086 (v01 DELL    M08     07DB091E ASL  00000061)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-000000041fe00000
> [    0.000000] Initmem setup node 0 0000000000000000-000000041fe00000
> [    0.000000]   NODE_DATA [000000041fdfc000 - 000000041fdfffff]
> [    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff88040f400000-ffff88041d5fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x0041fe00
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] Early memory PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009d
> [    0.000000]     0: 0x00000100 -> 0x00020000
> [    0.000000]     0: 0x00020200 -> 0x00040000
> [    0.000000]     0: 0x00040200 -> 0x000da4e5
> [    0.000000]     0: 0x000da528 -> 0x000da793
> [    0.000000]     0: 0x000da967 -> 0x000dacbc
> [    0.000000]     0: 0x00100000 -> 0x0041fe00
> [    0.000000] On node 0 totalpages: 4170802
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 5 pages reserved
> [    0.000000]   DMA zone: 3920 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 876253 pages, LIFO batch:31
> [    0.000000]   Normal zone: 44793 pages used for memmap
> [    0.000000]   Normal zone: 3231495 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 00000000da4e5000 - 00000000da528000
> [    0.000000] PM: Registered nosave memory: 00000000da793000 - 00000000da967000
> [    0.000000] PM: Registered nosave memory: 00000000dacbc000 - 00000000dad68000
> [    0.000000] PM: Registered nosave memory: 00000000dad68000 - 00000000dafe8000
> [    0.000000] PM: Registered nosave memory: 00000000dafe8000 - 00000000db000000
> [    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000db800000
> [    0.000000] PM: Registered nosave memory: 00000000db800000 - 00000000dfa00000
> [    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
> [    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
> [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
> [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88041fa00000 s72448 r8192 d21760 u524288
> [    0.000000] pcpu-alloc: s72448 r8192 d21760 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4111668
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 16372092k/17299456k available (6042k kernel code, 616248k absent, 311116k reserved, 3748k data, 552k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:4352 nr_irqs:712 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.010000] Detected 2793.562 MHz processor.
> [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5587.12 BogoMIPS (lpj=27935620)
> [    0.000191] pid_max: default: 32768 minimum: 301
> [    0.001159] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.004169] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.005545] Mount-cache hash table entries: 256
> [    0.005808] CPU: Physical Processor ID: 0
> [    0.005901] CPU: Processor Core ID: 0
> [    0.005994] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.005995] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.006187] mce: CPU supports 7 MCE banks
> [    0.006288] CPU0: Thermal monitoring enabled (TM1)
> [    0.006386] using mwait in idle threads.
> [    0.006536] ACPI: Core revision 20120320
> [    0.016911] DMAR: Host address width 36
> [    0.017014] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.017113] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
> [    0.017258] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.017356] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
> [    0.017500] DMAR: RMRR base: 0x000000dad53000 end: 0x000000dad61fff
> [    0.017595] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
> [    0.017761] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [    0.017856] HPET id 0 under DRHD base 0xfed91000
> [    0.017950] HPET id 0 under DRHD base 0xfed91000
> [    0.018043] HPET id 0 under DRHD base 0xfed91000
> [    0.018136] HPET id 0 under DRHD base 0xfed91000
> [    0.018229] HPET id 0 under DRHD base 0xfed91000
> [    0.018321] HPET id 0 under DRHD base 0xfed91000
> [    0.018413] HPET id 0 under DRHD base 0xfed91000
> [    0.018507] HPET id 0 under DRHD base 0xfed91000
> [    0.018759] Enabled IRQ remapping in x2apic mode
> [    0.018854] Enabling x2apic
> [    0.018944] Enabled x2apic
> [    0.019036] Switched APIC routing to cluster x2apic.
> [    0.019553] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.119503] CPU0: Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz stepping 07
> [    0.236664] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
> [    0.236967] PEBS disabled due to CPU errata.
> [    0.237061] ... version:                3
> [    0.237152] ... bit width:              48
> [    0.237245] ... generic registers:      4
> [    0.237335] ... value mask:             0000ffffffffffff
> [    0.237429] ... max period:             000000007fffffff
> [    0.237524] ... fixed-purpose events:   3
> [    0.237616] ... event mask:             000000070000000f
> [    0.237797] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.237964] Booting Node   0, Processors  #1
> [    0.251164] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.251424]  #2
> [    0.264540] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.264717]  #3 Ok.
> [    0.277835] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.277956] Brought up 4 CPUs
> [    0.278047] Total of 4 processors activated (22348.49 BogoMIPS).
> [    0.281076] devtmpfs: initialized
> [    0.281378] PM: Registering ACPI NVS region [mem 0xda4e5000-0xda527fff] (274432 bytes)
> [    0.281535] PM: Registering ACPI NVS region [mem 0xdad68000-0xdafe7fff] (2621440 bytes)
> [    0.281802] xor: automatically using best checksumming function: generic_sse
> [    0.326528]    generic_sse: 12452.000 MB/sec
> [    0.326622] xor: using function: generic_sse (12452.000 MB/sec)
> [    0.326848] dummy: 
> [    0.327006] NET: Registered protocol family 16
> [    0.327447] ACPI: bus type pci registered
> [    0.327632] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.327781] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.335086] PCI: Using configuration type 1 for base access
> [    0.341506] bio: create slab <bio-0> at 0
> [    0.506265] raid6: int64x1   2921 MB/s
> [    0.676016] raid6: int64x2   3002 MB/s
> [    0.845763] raid6: int64x4   2722 MB/s
> [    1.015515] raid6: int64x8   1728 MB/s
> [    1.185233] raid6: sse2x1    7520 MB/s
> [    1.354978] raid6: sse2x2    9263 MB/s
> [    1.524720] raid6: sse2x4   10548 MB/s
> [    1.524721] raid6: using algorithm sse2x4 (10548 MB/s)
> [    1.524765] ACPI: Added _OSI(Module Device)
> [    1.524858] ACPI: Added _OSI(Processor Device)
> [    1.524952] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.525045] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.526326] ACPI: EC: Look up EC in DSDT
> [    1.527640] ACPI: Executed 1 blocks of module-level executable AML code
> [    1.531992] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    1.536405] ACPI: SSDT 00000000dad51698 0064F (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    1.536725] ACPI: Dynamic OEM Table Load:
> [    1.536727] ACPI: SSDT           (null) 0064F (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    1.537010] ACPI: SSDT 00000000dad52a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
> [    1.537367] ACPI: Dynamic OEM Table Load:
> [    1.537369] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
> [    1.552870] ACPI: SSDT 00000000dad50d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
> [    1.553180] ACPI: Dynamic OEM Table Load:
> [    1.553182] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
> [    1.553743] ACPI: Interpreter enabled
> [    1.553838] ACPI: (supports S0 S1 S3 S4 S5)
> [    1.554147] ACPI: Using IOAPIC for interrupt routing
> [    1.579098] ACPI: No dock devices found.
> [    1.579194] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.579663] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    1.580193] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> [    1.580291] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
> [    1.580386] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    1.580531] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
> [    1.580676] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
> [    1.582140] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
> [    1.582285] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
> [    1.582430] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
> [    1.582576] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
> [    1.582720] pci_root PNP0A08:00: host bridge window [mem 0xdfa00000-0xfeafffff]
> [    1.582865] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
> [    1.583055] PCI host bridge to bus 0000:00
> [    1.583149] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.583245] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    1.583342] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.583440] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    1.583537] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    1.583634] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    1.583731] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    1.583828] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
> [    1.583925] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
> [    1.584022] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
> [    1.584119] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    1.584223] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
> [    1.584256] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
> [    1.584266] pci 0000:00:02.0: reg 10: [mem 0xf6800000-0xf6bfffff 64bit]
> [    1.584271] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    1.584275] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
> [    1.584326] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
> [    1.584349] pci 0000:00:16.0: reg 10: [mem 0xf7e0a000-0xf7e0a00f 64bit]
> [    1.584423] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    1.584457] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
> [    1.584477] pci 0000:00:1a.0: reg 10: [mem 0xf7e08000-0xf7e083ff]
> [    1.584565] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    1.584591] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
> [    1.584606] pci 0000:00:1b.0: reg 10: [mem 0xf7e00000-0xf7e03fff 64bit]
> [    1.584677] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    1.584703] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
> [    1.584781] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    1.584807] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
> [    1.584884] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    1.584911] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
> [    1.584988] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    1.585016] pci 0000:00:1c.7: [8086:1c1e] type 01 class 0x060400
> [    1.585094] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
> [    1.585123] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
> [    1.585144] pci 0000:00:1d.0: reg 10: [mem 0xf7e07000-0xf7e073ff]
> [    1.585232] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    1.585258] pci 0000:00:1f.0: [8086:1c4b] type 00 class 0x060100
> [    1.585379] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
> [    1.585397] pci 0000:00:1f.2: reg 10: [io  0xf0b0-0xf0b7]
> [    1.585404] pci 0000:00:1f.2: reg 14: [io  0xf0a0-0xf0a3]
> [    1.585412] pci 0000:00:1f.2: reg 18: [io  0xf090-0xf097]
> [    1.585420] pci 0000:00:1f.2: reg 1c: [io  0xf080-0xf083]
> [    1.585428] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
> [    1.585436] pci 0000:00:1f.2: reg 24: [mem 0xf7e06000-0xf7e067ff]
> [    1.585480] pci 0000:00:1f.2: PME# supported from D3hot
> [    1.585497] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
> [    1.585513] pci 0000:00:1f.3: reg 10: [mem 0xf7e05000-0xf7e050ff 64bit]
> [    1.585533] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
> [    1.585602] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
> [    1.585767] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
> [    1.585787] pci 0000:05:00.0: reg 10: [io  0xe000-0xe0ff]
> [    1.585821] pci 0000:05:00.0: reg 18: [mem 0xf1104000-0xf1104fff 64bit pref]
> [    1.585843] pci 0000:05:00.0: reg 20: [mem 0xf1100000-0xf1103fff 64bit pref]
> [    1.585934] pci 0000:05:00.0: supports D1 D2
> [    1.585936] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.604636] pci 0000:00:1c.1: PCI bridge to [bus 05-06]
> [    1.604777] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
> [    1.604785] pci 0000:00:1c.1:   bridge window [mem 0xf1100000-0xf11fffff 64bit pref]
> [    1.604974] pci 0000:09:00.0: [8086:008a] type 00 class 0x028000
> [    1.605122] pci 0000:09:00.0: reg 10: [mem 0xf7d00000-0xf7d01fff 64bit]
> [    1.605816] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
> [    1.624698] pci 0000:00:1c.3: PCI bridge to [bus 09-0a]
> [    1.624808] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
> [    1.624856] pci 0000:00:1c.7: PCI bridge to [bus 11-16]
> [    1.624953] pci 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [    1.624957] pci 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [    1.624963] pci 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.624984] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    1.625156] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    1.625194] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> [    1.625233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
> [    1.625284] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
> [    1.625413]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    1.625715]  pci0000:00: ACPI _OSC control (0x19) granted
> [    1.629953] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    1.630518] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    1.631081] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
> [    1.631644] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    1.632204] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    1.632892] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    1.633577] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    1.634139] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    1.634779] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.634928] vgaarb: loaded
> [    1.635018] vgaarb: bridge control possible 0000:00:02.0
> [    1.635242] SCSI subsystem initialized
> [    1.635408] libata version 3.00 loaded.
> [    1.635517] usbcore: registered new interface driver usbfs
> [    1.635635] usbcore: registered new interface driver hub
> [    1.635756] usbcore: registered new device driver usb
> [    1.635909] Linux media interface: v0.10
> [    1.636021] Linux video capture interface: v2.00
> [    1.636479] wmi: Mapper loaded
> [    1.636615] Advanced Linux Sound Architecture Driver Version 1.0.25.
> [    1.636711] PCI: Using ACPI for IRQ routing
> [    1.638611] PCI: pci_cache_line_size set to 64 bytes
> [    1.638727] reserve RAM buffer: 000000000009d400 - 000000000009ffff 
> [    1.638729] reserve RAM buffer: 00000000da4e5000 - 00000000dbffffff 
> [    1.638733] reserve RAM buffer: 00000000da793000 - 00000000dbffffff 
> [    1.638735] reserve RAM buffer: 00000000dacbc000 - 00000000dbffffff 
> [    1.638738] reserve RAM buffer: 000000041fe00000 - 000000041fffffff 
> [    1.638870] Bluetooth: Core ver 2.16
> [    1.638982] NET: Registered protocol family 31
> [    1.639078] Bluetooth: HCI device and connection manager initialized
> [    1.639174] Bluetooth: HCI socket layer initialized
> [    1.639268] Bluetooth: L2CAP socket layer initialized
> [    1.639364] Bluetooth: SCO socket layer initialized
> [    1.639524] cfg80211: Calling CRDA to update world regulatory domain
> [    1.639755] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    1.640201] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    1.642303] Switching to clocksource hpet
> [    1.642501] pnp: PnP ACPI init
> [    1.642600] ACPI: bus type pnp registered
> [    1.642930] pnp 00:00: [bus 00-3e]
> [    1.642932] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    1.642934] pnp 00:00: [io  0x0cf8-0x0cff]
> [    1.642936] pnp 00:00: [io  0x0d00-0xffff window]
> [    1.642938] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    1.642939] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> [    1.642941] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> [    1.642943] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> [    1.642944] pnp 00:00: [mem 0x000cc000-0x000cffff window]
> [    1.642946] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> [    1.642948] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> [    1.642950] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> [    1.642952] pnp 00:00: [mem 0x000dc000-0x000dffff window]
> [    1.642953] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> [    1.642955] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> [    1.642957] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> [    1.642958] pnp 00:00: [mem 0x000ec000-0x000effff window]
> [    1.642960] pnp 00:00: [mem 0x000f0000-0x000fffff window]
> [    1.642962] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
> [    1.642963] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    1.643028] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    1.643040] pnp 00:01: [io  0x0000-0x001f]
> [    1.643041] pnp 00:01: [io  0x0081-0x0091]
> [    1.643043] pnp 00:01: [io  0x0093-0x009f]
> [    1.643044] pnp 00:01: [io  0x00c0-0x00df]
> [    1.643046] pnp 00:01: [dma 4]
> [    1.643085] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    1.643093] pnp 00:02: [mem 0xff000000-0xffffffff]
> [    1.643134] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    1.643204] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    1.643244] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    1.643256] pnp 00:04: [io  0x002e-0x002f]
> [    1.643257] pnp 00:04: [io  0x004e-0x004f]
> [    1.643259] pnp 00:04: [io  0x0061]
> [    1.643260] pnp 00:04: [io  0x0063]
> [    1.643261] pnp 00:04: [io  0x0065]
> [    1.643263] pnp 00:04: [io  0x0067]
> [    1.643264] pnp 00:04: [io  0x0070]
> [    1.643265] pnp 00:04: [io  0x0080]
> [    1.643266] pnp 00:04: [io  0x0092]
> [    1.643268] pnp 00:04: [io  0x00b2-0x00b3]
> [    1.643269] pnp 00:04: [io  0x0680-0x069f]
> [    1.643271] pnp 00:04: [io  0x1000-0x100f]
> [    1.643272] pnp 00:04: [io  0xffff]
> [    1.643274] pnp 00:04: [io  0xffff]
> [    1.643276] pnp 00:04: [io  0x0400-0x0453]
> [    1.643277] pnp 00:04: [io  0x0458-0x047f]
> [    1.643279] pnp 00:04: [io  0x0500-0x057f]
> [    1.643280] pnp 00:04: [io  0x164e-0x164f]
> [    1.643336] system 00:04: [io  0x0680-0x069f] has been reserved
> [    1.643432] system 00:04: [io  0x1000-0x100f] has been reserved
> [    1.643528] system 00:04: [io  0xffff] has been reserved
> [    1.643622] system 00:04: [io  0xffff] has been reserved
> [    1.643718] system 00:04: [io  0x0400-0x0453] has been reserved
> [    1.643813] system 00:04: [io  0x0458-0x047f] has been reserved
> [    1.643909] system 00:04: [io  0x0500-0x057f] has been reserved
> [    1.644004] system 00:04: [io  0x164e-0x164f] has been reserved
> [    1.644101] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.644110] pnp 00:05: [io  0x0070-0x0077]
> [    1.644120] pnp 00:05: [irq 8]
> [    1.644160] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.644186] pnp 00:06: [io  0x0454-0x0457]
> [    1.644238] system 00:06: [io  0x0454-0x0457] has been reserved
> [    1.644334] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    1.644342] pnp 00:07: [io  0x00f0-0x00ff]
> [    1.644349] pnp 00:07: [irq 13]
> [    1.644391] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    1.644407] pnp 00:08: [io  0x0010-0x001f]
> [    1.644409] pnp 00:08: [io  0x0022-0x003f]
> [    1.644410] pnp 00:08: [io  0x0044-0x005f]
> [    1.644412] pnp 00:08: [io  0x0068-0x006f]
> [    1.644413] pnp 00:08: [io  0x0072-0x007f]
> [    1.644415] pnp 00:08: [io  0x0080]
> [    1.644416] pnp 00:08: [io  0x0084-0x0086]
> [    1.644417] pnp 00:08: [io  0x0088]
> [    1.644418] pnp 00:08: [io  0x008c-0x008e]
> [    1.644420] pnp 00:08: [io  0x0090-0x009f]
> [    1.644421] pnp 00:08: [io  0x00a2-0x00bf]
> [    1.644423] pnp 00:08: [io  0x00e0-0x00ef]
> [    1.644424] pnp 00:08: [io  0x04d0-0x04d1]
> [    1.644426] pnp 00:08: [mem 0xfe800000-0xfe802fff]
> [    1.644479] system 00:08: [io  0x04d0-0x04d1] has been reserved
> [    1.644584] system 00:08: [mem 0xfe800000-0xfe802fff] has been reserved
> [    1.644682] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.644700] pnp 00:09: [irq 12]
> [    1.644745] pnp 00:09: Plug and Play ACPI device, IDs DLL04b3 SYN0600 SYN0002 PNP0f13 (active)
> [    1.644759] pnp 00:0a: [io  0x0060]
> [    1.644761] pnp 00:0a: [io  0x0064]
> [    1.644762] pnp 00:0a: [io  0x0062]
> [    1.644763] pnp 00:0a: [io  0x0066]
> [    1.644770] pnp 00:0a: [irq 1]
> [    1.644814] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.645002] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
> [    1.645003] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
> [    1.645005] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
> [    1.645007] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
> [    1.645008] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
> [    1.645009] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
> [    1.645011] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
> [    1.645012] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
> [    1.645014] pnp 00:0b: [mem 0xff000000-0xffffffff]
> [    1.645015] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
> [    1.645017] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
> [    1.645084] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    1.645182] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
> [    1.645279] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
> [    1.645377] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
> [    1.645474] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
> [    1.645572] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    1.645669] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
> [    1.645768] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    1.645865] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
> [    1.645962] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    1.646060] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
> [    1.646157] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.646215] pnp 00:0c: [irq 20]
> [    1.646272] pnp 00:0c: Plug and Play ACPI device, IDs SMO8800 (active)
> [    1.646380] pnp 00:0d: [mem 0x20000000-0x201fffff]
> [    1.646381] pnp 00:0d: [mem 0x40000000-0x401fffff]
> [    1.646450] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
> [    1.646549] system 00:0d: [mem 0x40000000-0x401fffff] has been reserved
> [    1.646646] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    1.646687] pnp: PnP ACPI: found 14 devices
> [    1.646780] ACPI: ACPI bus type pnp unregistered
> [    1.654714] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
> [    1.654819] pci 0000:00:1c.1: PCI bridge to [bus 05-06]
> [    1.654915] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
> [    1.655017] pci 0000:00:1c.1:   bridge window [mem 0xf1100000-0xf11fffff 64bit pref]
> [    1.655166] pci 0000:00:1c.3: PCI bridge to [bus 09-0a]
> [    1.655264] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
> [    1.655366] pci 0000:00:1c.7: PCI bridge to [bus 11-16]
> [    1.655462] pci 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [    1.655560] pci 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [    1.655659] pci 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.655842] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.655844] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    1.655846] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    1.655848] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> [    1.655849] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> [    1.655851] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> [    1.655853] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
> [    1.655854] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
> [    1.655856] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
> [    1.655858] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
> [    1.655860] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
> [    1.655861] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
> [    1.655863] pci_bus 0000:05: resource 2 [mem 0xf1100000-0xf11fffff 64bit pref]
> [    1.655865] pci_bus 0000:09: resource 1 [mem 0xf7d00000-0xf7dfffff]
> [    1.655867] pci_bus 0000:11: resource 0 [io  0xc000-0xdfff]
> [    1.655868] pci_bus 0000:11: resource 1 [mem 0xf6c00000-0xf7cfffff]
> [    1.655870] pci_bus 0000:11: resource 2 [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.655940] NET: Registered protocol family 2
> [    1.656295] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    1.657281] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    1.658499] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    1.658720] TCP: Hash tables configured (established 524288 bind 65536)
> [    1.658817] TCP: reno registered
> [    1.658925] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    1.659071] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    1.659274] NET: Registered protocol family 1
> [    1.659462] RPC: Registered named UNIX socket transport module.
> [    1.659558] RPC: Registered udp transport module.
> [    1.659651] RPC: Registered tcp transport module.
> [    1.659744] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    1.659846] pci 0000:00:02.0: Boot video device
> [    1.659877] pci 0000:00:1a.0: EHCI: BIOS handoff
> [    1.782367] pci 0000:00:1d.0: EHCI: BIOS handoff
> [    1.902115] PCI: CLS 64 bytes, default 64
> [    1.902209] DMAR: No ATSR found
> [    1.902322] IOMMU 0 0xfed90000: using Queued invalidation
> [    1.902416] IOMMU 1 0xfed91000: using Queued invalidation
> [    1.902512] IOMMU: Setting RMRR:
> [    1.902613] IOMMU: Setting identity map for device 0000:00:02.0 [0xdb800000 - 0xdf9fffff]
> [    1.903114] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdad53000 - 0xdad61fff]
> [    1.903278] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdad53000 - 0xdad61fff]
> [    1.903433] IOMMU: Prepare 0-16MiB unity mapping for LPC
> [    1.903534] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
> [    1.903963] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> [    1.906739] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.906839] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.906941] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.907042] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.907189] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    1.908290] sha1_ssse3: Using AVX optimized SHA-1 implementation
> [    1.909513] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.911397] DLM installed
> [    1.911474] NFS: Registering the id_resolver key type
> [    1.911707] msgmni has been set to 32105
> [    1.913032] NET: Registered protocol family 38
> [    1.913126] async_tx: api initialized (async)
> [    1.913259] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    1.913404] io scheduler noop registered
> [    1.913496] io scheduler deadline registered
> [    1.913606] io scheduler cfq registered (default)
> [    1.913941] pcieport 0000:00:1c.7: irq 42 for MSI/MSI-X
> [    1.914121] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    1.914298] pciehp 0000:00:1c.7:pcie04: Hotplug Controller:
> [    1.914393] pciehp 0000:00:1c.7:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.7 IRQ 42
> [    1.914538] pciehp 0000:00:1c.7:pcie04:   Vendor ID            : 0x8086
> [    1.914635] pciehp 0000:00:1c.7:pcie04:   Device ID            : 0x1c1e
> [    1.914732] pciehp 0000:00:1c.7:pcie04:   Subsystem ID         : 0x04b3
> [    1.914828] pciehp 0000:00:1c.7:pcie04:   Subsystem Vendor ID  : 0x1028
> [    1.914924] pciehp 0000:00:1c.7:pcie04:   PCIe Cap offset      : 0x40
> [    1.915022] pciehp 0000:00:1c.7:pcie04:   PCI resource [13]     : [io  0xc000-0xdfff]
> [    1.915167] pciehp 0000:00:1c.7:pcie04:   PCI resource [14]     : [mem 0xf6c00000-0xf7cfffff]
> [    1.915314] pciehp 0000:00:1c.7:pcie04:   PCI resource [15]     : [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.915463] pciehp 0000:00:1c.7:pcie04: Slot Capabilities      : 0x003cb260
> [    1.915560] pciehp 0000:00:1c.7:pcie04:   Physical Slot Number : 7
> [    1.915656] pciehp 0000:00:1c.7:pcie04:   Attention Button     :  no
> [    1.915752] pciehp 0000:00:1c.7:pcie04:   Power Controller     :  no
> [    1.915848] pciehp 0000:00:1c.7:pcie04:   MRL Sensor           :  no
> [    1.915944] pciehp 0000:00:1c.7:pcie04:   Attention Indicator  :  no
> [    1.916040] pciehp 0000:00:1c.7:pcie04:   Power Indicator      :  no
> [    1.916136] pciehp 0000:00:1c.7:pcie04:   Hot-Plug Surprise    : yes
> [    1.916232] pciehp 0000:00:1c.7:pcie04:   EMI Present          :  no
> [    1.916328] pciehp 0000:00:1c.7:pcie04:   Command Completed    :  no
> [    1.916426] pciehp 0000:00:1c.7:pcie04: Slot Status            : 0x0000
> [    1.916524] pciehp 0000:00:1c.7:pcie04: Slot Control           : 0x0000
> [    1.916621] pciehp 0000:00:1c.7:pcie04: Link Active Reporting supported
> [    1.916628] pciehp 0000:00:1c.7:pcie04: HPC vendor_id 8086 device_id 1c1e ss_vid 1028 ss_did 4b3
> [    1.916776] pciehp 0000:00:1c.7:pcie04: Registering domain:bus:dev=0000:11:00 sun=7
> [    1.916821] pciehp 0000:00:1c.7:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read 28
> [    1.916823] pciehp 0000:00:1c.7:pcie04: service driver pciehp loaded
> [    1.916847] pciehp: pcie_port_service_register = 0
> [    1.916848] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    1.916944] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    1.918835] intel_idle: MWAIT substates: 0x21120
> [    1.918837] intel_idle: v0.4 model 0x2A
> [    1.918838] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    1.918936] ACPI: AC Adapter [AC] (on-line)
> [    1.919140] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    1.921021] ACPI: Lid Switch [LID0]
> [    1.921171] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    1.921319] ACPI: Power Button [PWRB]
> [    1.921464] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    1.921611] ACPI: Sleep Button [SBTN]
> [    1.921756] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [    1.921902] ACPI: Power Button [PWRF]
> [    1.922291] ACPI: Requesting acpi_cpufreq
> [    1.932575] thermal LNXTHERM:00: registered as thermal_zone0
> [    1.932672] ACPI: Thermal Zone [THM] (69 C)
> [    1.932878] GHES: HEST is not enabled!
> [    1.954202] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    1.954949] Non-volatile memory driver v1.3
> [    1.955367] i8k: unable to get SMM BIOS version
> [    1.959162] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
> [    1.959362] Linux agpgart interface v0.103
> [    1.959497] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
> [    1.959673] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    1.960865] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
> [    1.961094] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> [    1.961257] ipmi message handler version 39.2
> [    1.961356] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    1.961357] Hangcheck: Using getrawmonotonic().
> [    1.961395] [drm] Initialized drm 1.1.0 20060810
> [    1.961721] i915 0000:00:02.0: setting latency timer to 64
> [    1.982449] ACPI: Battery Slot [BAT0] (battery present)
> [    1.998728] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> [    1.998875] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [    1.999289] i915 0000:00:02.0: irq 43 for MSI/MSI-X
> [    1.999298] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    1.999395] [drm] Driver supports precise vblank timestamp query.
> [    1.999515] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    2.423260] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [    2.900545] Refined TSC clocksource calibration: 2793.655 MHz.
> [    2.900674] Switching to clocksource tsc
> [    2.977606] fbcon: inteldrmfb (fb0) is primary device
> [    3.478204] Console: switching to colour frame buffer device 170x48
> [    3.480615] fb0: inteldrmfb frame buffer device
> [    3.480616] drm: registered panic notifier
> [    3.481840] acpi device:34: registered as cooling_device4
> [    3.482072] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
> [    3.482112] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    3.482172] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    3.483023] loop: module loaded
> [    3.483160] ahci 0000:00:1f.2: version 3.0
> [    3.483208] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
> [    3.483234] ahci: SSS flag set, parallel bus scan disabled
> [    3.499693] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x31 impl SATA mode
> [    3.499793] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
> [    3.499831] ahci 0000:00:1f.2: setting latency timer to 64
> [    3.540350] scsi0 : ahci
> [    3.540465] scsi1 : ahci
> [    3.540556] scsi2 : ahci
> [    3.540646] scsi3 : ahci
> [    3.540735] scsi4 : ahci
> [    3.540825] scsi5 : ahci
> [    3.541152] ata2: SATA max UDMA/133 abar m2048@0xf7e06000 port 0xf7e06100 irq 44
> [    3.541183] ata3: DUMMY
> [    3.542054] ata4: DUMMY
> [    3.542915] ata5: DUMMY
> [    3.543760] ata6: SATA max UDMA/133 abar m2048@0xf7e06000 port 0xf7e06300 irq 44
> [    3.544621] ata7: SATA max UDMA/133 abar m2048@0xf7e06000 port 0xf7e06380 irq 44
> [    3.545593] tun: Universal TUN/TAP device driver, 1.6
> [    3.546452] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    3.547364] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    3.548336] r8169 0000:05:00.0: irq 45 for MSI/MSI-X
> [    3.548490] r8169 0000:05:00.0: eth0: RTL8168e/8111e at 0xffffc900065c8000, 18:03:73:a0:6f:6a, XID 0c200000 IRQ 45
> [    3.549380] r8169 0000:05:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    3.550305] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
> [    3.551238] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.552100] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
> [    3.552125] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [    3.552128] ehci_hcd 0000:00:1a.0: EHCI Host Controller
> [    3.552988] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    3.553853] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
> [    3.553856] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
> [    3.553874] ehci_hcd 0000:00:1a.0: support lpm
> [    3.553884] ehci_hcd 0000:00:1a.0: debug port 2
> [    3.554733] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
> [    3.558601] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
> [    3.558603] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
> [    3.558615] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7e08000
> [    3.559459] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
> [    3.569555] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    3.570514] usb usb1: default language 0x0409
> [    3.570519] usb usb1: udev 1, busnum 1, minor = 0
> [    3.570521] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.571355] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.572189] usb usb1: Product: EHCI Host Controller
> [    3.573018] usb usb1: Manufacturer: Linux 3.4.0-rc5-default ehci_hcd
> [    3.573860] usb usb1: SerialNumber: 0000:00:1a.0
> [    3.574761] usb usb1: usb_probe_device
> [    3.574763] usb usb1: configuration #1 chosen from 1 choice
> [    3.574769] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [    3.574804] hub 1-0:1.0: usb_probe_interface
> [    3.574805] hub 1-0:1.0: usb_probe_interface - got id
> [    3.574807] hub 1-0:1.0: USB hub found
> [    3.575644] hub 1-0:1.0: 2 ports detected
> [    3.576492] hub 1-0:1.0: standalone hub
> [    3.576493] hub 1-0:1.0: no power switching (usb 1.0)
> [    3.576494] hub 1-0:1.0: individual port over-current protection
> [    3.576496] hub 1-0:1.0: power on to power good time: 20ms
> [    3.576499] hub 1-0:1.0: local power source is good
> [    3.576501] hub 1-0:1.0: trying to enable port power on non-switchable hub
> [    3.576558] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [    3.576561] ehci_hcd 0000:00:1d.0: EHCI Host Controller
> [    3.577407] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    3.578262] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
> [    3.578266] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
> [    3.578282] ehci_hcd 0000:00:1d.0: support lpm
> [    3.578291] ehci_hcd 0000:00:1d.0: debug port 2
> [    3.579144] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
> [    3.583010] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
> [    3.583011] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
> [    3.583023] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7e07000
> [    3.583869] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
> [    3.599510] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    3.600448] usb usb2: default language 0x0409
> [    3.600453] usb usb2: udev 1, busnum 2, minor = 128
> [    3.600454] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.601279] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.602103] usb usb2: Product: EHCI Host Controller
> [    3.602915] usb usb2: Manufacturer: Linux 3.4.0-rc5-default ehci_hcd
> [    3.603734] usb usb2: SerialNumber: 0000:00:1d.0
> [    3.604599] usb usb2: usb_probe_device
> [    3.604601] usb usb2: configuration #1 chosen from 1 choice
> [    3.604607] usb usb2: adding 2-0:1.0 (config #1, interface 0)
> [    3.604641] hub 2-0:1.0: usb_probe_interface
> [    3.604642] hub 2-0:1.0: usb_probe_interface - got id
> [    3.604644] hub 2-0:1.0: USB hub found
> [    3.605444] hub 2-0:1.0: 2 ports detected
> [    3.606222] hub 2-0:1.0: standalone hub
> [    3.606223] hub 2-0:1.0: no power switching (usb 1.0)
> [    3.606225] hub 2-0:1.0: individual port over-current protection
> [    3.606226] hub 2-0:1.0: power on to power good time: 20ms
> [    3.606229] hub 2-0:1.0: local power source is good
> [    3.606231] hub 2-0:1.0: trying to enable port power on non-switchable hub
> [    3.606294] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    3.607089] ohci_hcd: block sizes: ed 80 td 96
> [    3.607168] usbcore: registered new interface driver uas
> [    3.608027] usbcore: registered new interface driver usbserial
> [    3.608862] usbcore: registered new interface driver usbserial_generic
> [    3.609705] USB Serial support registered for generic
> [    3.610535] usbserial: USB Serial Driver core
> [    3.611375] usbcore: registered new interface driver pl2303
> [    3.612205] USB Serial support registered for pl2303
> [    3.613099] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2] at 0x60,0x64 irq 1,12
> [    3.616189] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.617032] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.617988] mousedev: PS/2 mouse device common for all mice
> [    3.619074] rtc_cmos 00:05: RTC can wake from S4
> [    3.620060] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    3.620916] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    3.621750] i2c /dev entries driver
> [    3.622920] gspca_main: v2.14.0 registered
> [    3.623740] usbcore: registered new interface driver uvcvideo
> [    3.624536] USB Video Class driver (1.1.1)
> [    3.625410] coretemp coretemp.0: TjMax is 100 degrees C
> [    3.625420] coretemp coretemp.0: TjMax is 100 degrees C
> [    3.625430] coretemp coretemp.0: TjMax is 100 degrees C
> [    3.625458] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
> [    3.626325] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
> [    3.627187] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    3.627991] iTCO_vendor_support: vendor-support=0
> [    3.628820] md: linear personality registered for level -1
> [    3.629639] md: raid0 personality registered for level 0
> [    3.630442] md: raid1 personality registered for level 1
> [    3.631234] md: raid10 personality registered for level 10
> [    3.632027] md: raid6 personality registered for level 6
> [    3.632814] md: raid5 personality registered for level 5
> [    3.633588] md: raid4 personality registered for level 4
> [    3.634395] device-mapper: uevent: version 1.0.3
> [    3.635228] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    3.636071] device-mapper: dm-log-userspace: version 1.1.0 loaded
> [    3.636884] usbcore: registered new interface driver btusb
> [    3.637753] cpuidle: using governor ladder
> [    3.638632] cpuidle: using governor menu
> [    3.639471] sdhci: Secure Digital Host Controller Interface driver
> [    3.640264] sdhci: Copyright(c) Pierre Ossman
> [    3.641618] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    3.642966] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
> [    3.643229] usbcore: registered new interface driver usbhid
> [    3.643230] usbhid: USB HID core driver
> [    3.643291] mei 0000:00:16.0: setting latency timer to 64
> [    3.643338] mei 0000:00:16.0: irq 46 for MSI/MSI-X
> [    3.667213] input: Dell WMI hotkeys as /devices/virtual/input/input6
> [    3.677256] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
> [    3.677260] hub 1-0:1.0: port 1: status 0501 change 0001
> [    3.677316] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
> [    3.677465] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [    3.699438] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
> [    3.699456] hub 2-0:1.0: port 1: status 0501 change 0001
> [    3.769361] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
> [    3.769394] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [    3.829458] ehci_hcd 0000:00:1a.0: port 1 high speed
> [    3.829464] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    3.889165] usb 1-1: new high-speed USB device number 2 using ehci_hcd
> [    3.889184] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.894146] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    3.895339] ata2.00: ATA-8: WDC WD7500BPKT-75PK4T0, 01.01A01, max UDMA/133
> [    3.896307] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    3.902210] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    3.903490] ata2.00: configured for UDMA/133
> [    3.919352] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-7 01.0 PQ: 0 ANSI: 5
> [    3.920701] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> [    3.920949] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.922578] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    3.923588] sd 0:0:0:0: [sda] Write Protect is off
> [    3.924498] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.924566] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.949280] ehci_hcd 0000:00:1a.0: port 1 high speed
> [    3.949285] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    4.019700]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> [    4.021806] sd 0:0:0:0: [sda] Attached SCSI disk
> [    4.039103] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
> [    4.039115] ehci_hcd 0000:00:1a.0: LPM: no device attached
> [    4.039428] usb 1-1: udev 2, busnum 1, minor = 1
> [    4.039437] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    4.040405] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.041509] usb 1-1: usb_probe_device
> [    4.041514] usb 1-1: configuration #1 chosen from 1 choice
> [    4.041731] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
> [    4.041891] hub 1-1:1.0: usb_probe_interface
> [    4.041894] hub 1-1:1.0: usb_probe_interface - got id
> [    4.041896] hub 1-1:1.0: USB hub found
> [    4.042956] hub 1-1:1.0: 6 ports detected
> [    4.043925] hub 1-1:1.0: standalone hub
> [    4.043926] hub 1-1:1.0: individual port power switching
> [    4.043928] hub 1-1:1.0: individual port over-current protection
> [    4.043929] hub 1-1:1.0: Single TT
> [    4.043931] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
> [    4.043932] hub 1-1:1.0: power on to power good time: 100ms
> [    4.044203] hub 1-1:1.0: local power source is good
> [    4.044213] hub 1-1:1.0: enabling power on all ports
> [    4.045025] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
> [    4.045046] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [    4.099056] ehci_hcd 0000:00:1d.0: port 1 high speed
> [    4.099061] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    4.139442] hub 1-1:1.0: port 5: status 0101 change 0001
> [    4.158763] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> [    4.218875] ehci_hcd 0000:00:1d.0: port 1 high speed
> [    4.218881] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    4.238697] usb 1-1: link qh256-0001/ffff88040db75f40 start 1 [1/0 us]
> [    4.268600] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    4.274940] ata6.00: ATAPI: PLDS DVD+/-RW DS-8A8SH, KD11, max UDMA/100
> [    4.281420] ata6.00: configured for UDMA/100
> [    4.289945] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
> [    4.294697] scsi 4:0:0:0: CD-ROM            PLDS     DVD+-RW DS-8A8SH KD11 PQ: 0 ANSI: 5
> [    4.304700] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    4.304711] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    4.306119] sr 4:0:0:0: Attached scsi CD-ROM sr0
> [    4.306367] sr 4:0:0:0: Attached scsi generic sg1 type 5
> [    4.308652] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
> [    4.308656] ehci_hcd 0000:00:1d.0: LPM: no device attached
> [    4.308890] usb 2-1: udev 2, busnum 2, minor = 129
> [    4.308892] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    4.309880] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.310952] usb 2-1: usb_probe_device
> [    4.310955] usb 2-1: configuration #1 chosen from 1 choice
> [    4.311017] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
> [    4.311063] hub 2-1:1.0: usb_probe_interface
> [    4.311065] hub 2-1:1.0: usb_probe_interface - got id
> [    4.311067] hub 2-1:1.0: USB hub found
> [    4.312132] hub 2-1:1.0: 8 ports detected
> [    4.313095] hub 2-1:1.0: standalone hub
> [    4.313097] hub 2-1:1.0: individual port power switching
> [    4.313098] hub 2-1:1.0: individual port over-current protection
> [    4.313099] hub 2-1:1.0: Single TT
> [    4.313101] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
> [    4.313102] hub 2-1:1.0: power on to power good time: 100ms
> [    4.313380] hub 2-1:1.0: local power source is good
> [    4.313382] hub 2-1:1.0: enabling power on all ports
> [    4.314386] hub 1-1:1.0: state 7 ports 6 chg 0020 evt 0000
> [    4.314486] hub 1-1:1.0: port 5, status 0101, change 0000, 12 Mb/s
> [    4.317417] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [    4.319001] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [    4.320571] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [    4.322800] TCP: cubic registered
> [    4.323802] NET: Registered protocol family 17
> [    4.324832] Bluetooth: RFCOMM TTY layer initialized
> [    4.325830] Bluetooth: RFCOMM socket layer initialized
> [    4.326812] Bluetooth: RFCOMM ver 1.11
> [    4.327778] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    4.328761] Bluetooth: BNEP filters: protocol multicast
> [    4.329722] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    4.330978] sctp: Hash tables configured (established 65536 bind 65536)
> [    4.332004] Registering the dns_resolver key type
> [    4.333151] PM: Checking hibernation image partition /dev/sda6
> [    4.333157] PM: Hibernation image partition 8:6 present
> [    4.333158] PM: Looking for hibernation image.
> [    4.342719] PM: Image not found (code -22)
> [    4.342724] PM: Hibernation image not present or could not be loaded.
> [    4.342743] registered taskstats version 1
> [    4.344852] rtc_cmos 00:05: setting system clock to 2012-05-02 17:26:21 UTC (1335979581)
> [    4.346660] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> [    4.347729] ALSA device list:
> [    4.348568]   #0: HDA Intel PCH at 0xf7e00000 irq 47
> [    4.388568] usb 1-1.5: new high-speed USB device number 3 using ehci_hcd
> [    4.409168] hub 2-1:1.0: port 3: status 0101 change 0001
> [    4.410153] hub 2-1:1.0: port 6: status 0101 change 0001
> [    4.504774] usb 1-1.5: skipped 1 descriptor after configuration
> [    4.504788] usb 1-1.5: skipped 6 descriptors after interface
> [    4.504798] usb 1-1.5: skipped 1 descriptor after endpoint
> [    4.504807] usb 1-1.5: skipped 19 descriptors after interface
> [    4.504826] usb 1-1.5: skipped 1 descriptor after endpoint
> [    4.505157] usb 1-1.5: default language 0x0409
> [    4.506552] usb 1-1.5: udev 3, busnum 1, minor = 2
> [    4.506561] usb 1-1.5: New USB device found, idVendor=05ca, idProduct=1820
> [    4.507457] usb 1-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    4.508158] usb 2-1: link qh256-0001/ffff88040dbb70c0 start 1 [1/0 us]
> [    4.508289] usb 1-1.5: Product: Laptop_Integrated_Webcam_FHD
> [    4.509082] usb 1-1.5: Manufacturer: CN01MWM9724871A4KB28A00
> [    4.510089] usb 1-1.5: usb_probe_device
> [    4.510092] usb 1-1.5: configuration #1 chosen from 1 choice
> [    4.510273] usb 1-1.5: adding 1-1.5:1.0 (config #1, interface 0)
> [    4.511007] usbserial_generic 1-1.5:1.0: usb_probe_interface
> [    4.511010] usbserial_generic 1-1.5:1.0: usb_probe_interface - got id
> [    4.511033] uvcvideo 1-1.5:1.0: usb_probe_interface
> [    4.511035] uvcvideo 1-1.5:1.0: usb_probe_interface - got id
> [    4.511048] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_FHD (05ca:1820)
> [    4.513743] input: Laptop_Integrated_Webcam_FHD as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0/input/input11
> [    4.514652] usb 1-1.5: adding 1-1.5:1.1 (config #1, interface 1)
> [    4.514705] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0020
> [    4.514833] hub 2-1:1.0: state 7 ports 8 chg 0048 evt 0000
> [    4.514961] hub 2-1:1.0: port 3, status 0101, change 0000, 12 Mb/s
> [    4.588288] usb 2-1.3: new full-speed USB device number 3 using ehci_hcd
> [    4.623305] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input12
> [    4.637568] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input13
> [    4.648032] ata7: SATA link down (SStatus 0 SControl 300)
> [    4.648994] md: Waiting for all devices to be available before autodetect
> [    4.649831] md: If you don't use raid, use raid=noautodetect
> [    4.651096] md: Autodetecting RAID arrays.
> [    4.651952] md: Scanned 0 and added 0 devices.
> [    4.652805] md: autorun ...
> [    4.653653] md: ... autorun DONE.
> [    4.697938] usb 2-1.3: ep0 maxpacket = 8
> [    4.699115] usb 2-1.3: default language 0x0409
> [    4.699373] usb 2-1.3: udev 3, busnum 2, minor = 130
> [    4.699383] usb 2-1.3: New USB device found, idVendor=138a, idProduct=0011
> [    4.700293] usb 2-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
> [    4.701091] usb 2-1.3: SerialNumber: 56ed5821afe2
> [    4.702146] usb 2-1.3: usb_probe_device
> [    4.702149] usb 2-1.3: configuration #1 chosen from 1 choice
> [    4.702908] usb 2-1.3: adding 2-1.3:1.0 (config #1, interface 0)
> [    4.703094] usbserial_generic 2-1.3:1.0: usb_probe_interface
> [    4.703096] usbserial_generic 2-1.3:1.0: usb_probe_interface - got id
> [    4.703299] hub 2-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
> [    4.747181] EXT3-fs (sda5): recovery required on readonly filesystem
> [    4.748000] EXT3-fs (sda5): write access will be enabled during recovery
> [    4.778016] usb 2-1.6: new high-speed USB device number 4 using ehci_hcd
> [    4.895291] usb 2-1.6: default language 0x0409
> [    4.900748] usb 2-1.6: udev 4, busnum 2, minor = 131
> [    4.900758] usb 2-1.6: New USB device found, idVendor=0bda, idProduct=0138
> [    4.901644] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    4.902445] usb 2-1.6: Product: USB2.0-CRW
> [    4.903235] usb 2-1.6: Manufacturer: Generic
> [    4.904015] usb 2-1.6: SerialNumber: 20090516388200000
> [    4.904989] usb 2-1.6: usb_probe_device
> [    4.904991] usb 2-1.6: configuration #1 chosen from 1 choice
> [    4.907117] usb 2-1.6: adding 2-1.6:1.0 (config #1, interface 0)
> [    4.910925] uas 2-1.6:1.0: usb_probe_interface
> [    4.910929] uas 2-1.6:1.0: usb_probe_interface - got id
> [    4.910936] usbserial_generic 2-1.6:1.0: usb_probe_interface
> [    4.910944] usbserial_generic 2-1.6:1.0: usb_probe_interface - got id
> [    4.910990] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0008
> [    5.521578] kjournald starting.  Commit interval 5 seconds
> [    5.522322] EXT3-fs (sda5): recovery complete
> [    5.522325] EXT3-fs (sda5): mounted filesystem with writeback data mode
> [    5.522340] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
> [    5.550411] devtmpfs: mounted
> [    5.551485] Freeing unused kernel memory: 552k freed
> [    7.124499] usb 1-1.5: usb auto-suspend, wakeup 0
> [    8.841892] udevd[1766]: starting version 171
> [    9.141341] hub 1-1:1.0: hub_suspend
> [    9.141362] usb 1-1: unlink qh256-0001/ffff88040db75f40 start 1 [1/0 us]
> [    9.141663] usb 1-1: usb auto-suspend, wakeup 1
> [    9.600675] usb 1-1: usb auto-resume
> [    9.640651] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    9.660541] usb 1-1: finish resume
> [    9.660762] hub 1-1:1.0: hub_resume
> [    9.661373] hub 1-1:1.0: port 5: status 0507 change 0000
> [    9.661501] ehci_hcd 0000:00:1a.0: reused qh ffff88040db75f40 schedule
> [    9.661510] usb 1-1: link qh256-0001/ffff88040db75f40 start 1 [1/0 us]
> [    9.661537] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0000
> [    9.661746] usb 1-1.5: usb auto-resume
> [    9.695342] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0020
> [    9.720675] usb 1-1.5: finish resume
> [    9.721431] usb 1-1.5: link qh16-0001/ffff88040c95c440 start 2 [1/0 us]
> [    9.721530] usb 1-1.5: unlink qh16-0001/ffff88040c95c440 start 2 [1/0 us]
> [   11.087355] ACPI Warning: 0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
> [   11.087361] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   11.264848] Initializing USB Mass Storage driver...
> [   11.264877] usb-storage 2-1.6:1.0: usb_probe_interface
> [   11.264880] usb-storage 2-1.6:1.0: usb_probe_interface - got id
> [   11.264937] scsi6 : usb-storage 2-1.6:1.0
> [   11.264993] usbcore: registered new interface driver usb-storage
> [   11.264994] USB Mass Storage support registered.
> [   11.458017] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
> [   11.458019] Copyright(c) 2003-2012 Intel Corporation
> [   11.458205] iwlwifi 0000:09:00.0: pci_resource_len = 0x00002000
> [   11.458207] iwlwifi 0000:09:00.0: pci_resource_base = ffffc900066e4000
> [   11.458209] iwlwifi 0000:09:00.0: HW Revision ID = 0x34
> [   11.458297] iwlwifi 0000:09:00.0: irq 48 for MSI/MSI-X
> [   11.705011] iwlwifi 0000:09:00.0: loaded firmware version 17.168.5.2 build 35905
> [   11.705133] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   11.705134] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [   11.705136] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [   11.705137] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
> [   11.705138] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_P2P disabled
> [   11.705140] iwlwifi 0000:09:00.0: Detected Intel(R) Centrino(R) Wireless-N 1030 BGN, REV=0xB0
> [   11.705186] iwlwifi 0000:09:00.0: L1 Disabled; Enabling L0S
> [   11.722342] iwlwifi 0000:09:00.0: device EEPROM VER=0x71a, CALIB=0x6
> [   11.722344] iwlwifi 0000:09:00.0: Device SKU: 0x150
> [   11.722346] iwlwifi 0000:09:00.0: Valid Tx ant: 0x1, Valid Rx ant: 0x3
> [   11.722358] iwlwifi 0000:09:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
> [   11.722478] Registered led device: phy0-led
> [   11.722539] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   12.136968] usb 1-1.5: usb auto-suspend, wakeup 0
> [   12.259808] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
> [   12.260028] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [   12.265641] sd 6:0:0:0: [sdb] Attached SCSI removable disk
> [   13.090419] EXT3-fs (sda5): using internal journal
> [   13.530474] Adding 4998972k swap on /dev/sda6.  Priority:-1 extents:1 across:4998972k 
> [   14.153873] hub 1-1:1.0: hub_suspend
> [   14.153903] usb 1-1: unlink qh256-0001/ffff88040db75f40 start 1 [1/0 us]
> [   14.154216] usb 1-1: usb auto-suspend, wakeup 1
> [   16.170874] hub 1-0:1.0: hub_suspend
> [   16.170895] usb usb1: bus auto-suspend, wakeup 1
> [   16.170902] ehci_hcd 0000:00:1a.0: suspend root hub
> [   19.060249] r8169 0000:05:00.0: eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-2)
> [   19.090260] r8169 0000:05:00.0: eth0: link down
> [   19.090292] r8169 0000:05:00.0: eth0: link down
> [   20.827442] r8169 0000:05:00.0: eth0: link up
> [   25.435698] microcode: CPU0 updated to revision 0x25, date = 2011-10-11
> [   25.436049] microcode: CPU1 updated to revision 0x25, date = 2011-10-11
> [   25.436379] microcode: CPU2 updated to revision 0x25, date = 2011-10-11
> [   25.436726] microcode: CPU3 updated to revision 0x25, date = 2011-10-11
> [   25.507776] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, -vsync)
> [   27.360500] r8169 0000:05:00.0: eth0: link down
> [   29.735621] r8169 0000:05:00.0: eth0: link up
> [   34.015084] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, -vsync)
> [   54.605698] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [   54.605708] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [   54.605712] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [   54.606334] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [   54.606560] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [   54.713481] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [   54.713591] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [   54.713642] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [   54.713888] pci 0000:11:00.0: PME# supported from D0 D3hot
> [   54.733514] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [   54.734200] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> [   54.734839] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [   54.735466] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [   54.736088] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [   54.736834] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [   54.737599] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [   54.738231] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 3
> [   54.738903] xhci_hcd 0000:11:00.0: xHCI capability registers at ffffc90006970000:
> [   54.738909] xhci_hcd 0000:11:00.0: CAPLENGTH AND HCIVERSION 0x960020:
> [   54.738910] xhci_hcd 0000:11:00.0: CAPLENGTH: 0x20
> [   54.738911] xhci_hcd 0000:11:00.0: HCIVERSION: 0x96
> [   54.738917] xhci_hcd 0000:11:00.0: HCSPARAMS 1: 0x4000820
> [   54.738918] xhci_hcd 0000:11:00.0:   Max device slots: 32
> [   54.738919] xhci_hcd 0000:11:00.0:   Max interrupters: 8
> [   54.738921] xhci_hcd 0000:11:00.0:   Max ports: 4
> [   54.738926] xhci_hcd 0000:11:00.0: HCSPARAMS 2: 0x11
> [   54.738927] xhci_hcd 0000:11:00.0:   Isoc scheduling threshold: 1
> [   54.738929] xhci_hcd 0000:11:00.0:   Maximum allowed segments in event ring: 1
> [   54.738934] xhci_hcd 0000:11:00.0: HCSPARAMS 3 0x0:
> [   54.738936] xhci_hcd 0000:11:00.0:   Worst case U1 device exit latency: 0
> [   54.738937] xhci_hcd 0000:11:00.0:   Worst case U2 device exit latency: 0
> [   54.738943] xhci_hcd 0000:11:00.0: HCC PARAMS 0x14042cb:
> [   54.738944] xhci_hcd 0000:11:00.0:   HC generates 64 bit addresses
> [   54.738945] xhci_hcd 0000:11:00.0:   FIXME: more HCCPARAMS debugging
> [   54.738951] xhci_hcd 0000:11:00.0: RTSOFF 0x600:
> [   54.738952] xhci_hcd 0000:11:00.0: xHCI operational registers at ffffc90006970020:
> [   54.738958] xhci_hcd 0000:11:00.0: USBCMD 0x0:
> [   54.738959] xhci_hcd 0000:11:00.0:   HC is being stopped
> [   54.738960] xhci_hcd 0000:11:00.0:   HC has finished hard reset
> [   54.738962] xhci_hcd 0000:11:00.0:   Event Interrupts disabled
> [   54.738963] xhci_hcd 0000:11:00.0:   Host System Error Interrupts disabled
> [   54.738964] xhci_hcd 0000:11:00.0:   HC has finished light reset
> [   54.738970] xhci_hcd 0000:11:00.0: USBSTS 0x11:
> [   54.738971] xhci_hcd 0000:11:00.0:   Event ring is empty
> [   54.738972] xhci_hcd 0000:11:00.0:   No Host System Error
> [   54.738973] xhci_hcd 0000:11:00.0:   HC is halted
> [   54.738979] xhci_hcd 0000:11:00.0: ffffc90006970420 port status reg = 0x2a0
> [   54.738986] xhci_hcd 0000:11:00.0: ffffc90006970424 port power reg = 0x0
> [   54.738992] xhci_hcd 0000:11:00.0: ffffc90006970428 port link reg = 0x0
> [   54.738998] xhci_hcd 0000:11:00.0: ffffc9000697042c port reserved reg = 0x0
> [   54.739004] xhci_hcd 0000:11:00.0: ffffc90006970430 port status reg = 0x2a0
> [   54.739010] xhci_hcd 0000:11:00.0: ffffc90006970434 port power reg = 0x0
> [   54.739017] xhci_hcd 0000:11:00.0: ffffc90006970438 port link reg = 0x0
> [   54.739023] xhci_hcd 0000:11:00.0: ffffc9000697043c port reserved reg = 0x0
> [   54.739029] xhci_hcd 0000:11:00.0: ffffc90006970440 port status reg = 0x2a0
> [   54.739035] xhci_hcd 0000:11:00.0: ffffc90006970444 port power reg = 0x0
> [   54.739041] xhci_hcd 0000:11:00.0: ffffc90006970448 port link reg = 0x0
> [   54.739047] xhci_hcd 0000:11:00.0: ffffc9000697044c port reserved reg = 0x0
> [   54.739053] xhci_hcd 0000:11:00.0: ffffc90006970450 port status reg = 0x202e1
> [   54.739059] xhci_hcd 0000:11:00.0: ffffc90006970454 port power reg = 0x0
> [   54.739065] xhci_hcd 0000:11:00.0: ffffc90006970458 port link reg = 0x0
> [   54.739070] xhci_hcd 0000:11:00.0: ffffc9000697045c port reserved reg = 0x0
> [   54.739072] xhci_hcd 0000:11:00.0: // Halt the HC
> [   54.739084] xhci_hcd 0000:11:00.0: Resetting HCD
> [   54.739090] xhci_hcd 0000:11:00.0: // Reset the HC
> [   54.739145] xhci_hcd 0000:11:00.0: Wait for controller to be ready for doorbell rings
> [   54.739151] xhci_hcd 0000:11:00.0: Reset complete
> [   54.739156] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [   54.739158] xhci_hcd 0000:11:00.0: Calling HCD init
> [   54.739159] xhci_hcd 0000:11:00.0: xhci_init
> [   54.739160] xhci_hcd 0000:11:00.0: xHCI doesn't need link TRB QUIRK
> [   54.739166] xhci_hcd 0000:11:00.0: Supported page size register = 0x1
> [   54.739167] xhci_hcd 0000:11:00.0: Supported page size of 4K
> [   54.739168] xhci_hcd 0000:11:00.0: HCD page size set to 4K
> [   54.739174] xhci_hcd 0000:11:00.0: // xHC can handle at most 32 device slots.
> [   54.739179] xhci_hcd 0000:11:00.0: // Setting Max device slots reg = 0x20.
> [   54.739201] xhci_hcd 0000:11:00.0: // Device context base array address = 0xfffff000 (DMA), ffff88040ed31000 (virt)
> [   54.739206] xhci_hcd 0000:11:00.0: Allocated command ring at ffff88040c89b1c0
> [   54.739207] xhci_hcd 0000:11:00.0: First segment DMA is 0xffffe000
> [   54.739216] xhci_hcd 0000:11:00.0: // Setting command ring address to 0x20
> [   54.739226] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [   54.739227] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [   54.739233] xhci_hcd 0000:11:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
> [   54.739235] xhci_hcd 0000:11:00.0: // xHCI capability registers at ffffc90006970000:
> [   54.739241] xhci_hcd 0000:11:00.0: // @ffffc90006970000 = 0x960020 (CAPLENGTH AND HCIVERSION)
> [   54.739242] xhci_hcd 0000:11:00.0: //   CAPLENGTH: 0x20
> [   54.739243] xhci_hcd 0000:11:00.0: // xHCI operational registers at ffffc90006970020:
> [   54.739250] xhci_hcd 0000:11:00.0: // @ffffc90006970018 = 0x600 RTSOFF
> [   54.739251] xhci_hcd 0000:11:00.0: // xHCI runtime registers at ffffc90006970600:
> [   54.739257] xhci_hcd 0000:11:00.0: // @ffffc90006970014 = 0x800 DBOFF
> [   54.739258] xhci_hcd 0000:11:00.0: // Doorbell array at ffffc90006970800:
> [   54.739259] xhci_hcd 0000:11:00.0: xHCI runtime registers at ffffc90006970600:
> [   54.739266] xhci_hcd 0000:11:00.0:   ffffc90006970600: Microframe index = 0x0
> [   54.739291] xhci_hcd 0000:11:00.0: // Allocating event ring
> [   54.739293] xhci_hcd 0000:11:00.0: TRB math tests passed.
> [   54.739295] xhci_hcd 0000:11:00.0: // Allocated event ring segment table at 0xffffd000
> [   54.739297] xhci_hcd 0000:11:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88040966b000, dma addr = 0xffffd000
> [   54.739303] xhci_hcd 0000:11:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [   54.739305] xhci_hcd 0000:11:00.0: // Set ERST entries to point to event ring.
> [   54.739306] xhci_hcd 0000:11:00.0: // Set ERST base address for ir_set 0 = 0xffffd000
> [   54.739322] xhci_hcd 0000:11:00.0: // Write event ring dequeue pointer, preserving EHB bit
> [   54.739324] xhci_hcd 0000:11:00.0: Wrote ERST address to ir_set 0.
> [   54.739329] xhci_hcd 0000:11:00.0: Allocating 0 scratchpad buffers
> [   54.739347] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006970510, port offset = 1, count = 2, revision = 0x3
> [   54.739357] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006970520, port offset = 3, count = 2, revision = 0x2
> [   54.739358] xhci_hcd 0000:11:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [   54.739360] xhci_hcd 0000:11:00.0: USB 2.0 port at index 2, addr = ffffc90006970440
> [   54.739361] xhci_hcd 0000:11:00.0: USB 2.0 port at index 3, addr = ffffc90006970450
> [   54.739363] xhci_hcd 0000:11:00.0: USB 3.0 port at index 0, addr = ffffc90006970420
> [   54.739365] xhci_hcd 0000:11:00.0: USB 3.0 port at index 1, addr = ffffc90006970430
> [   54.739371] xhci_hcd 0000:11:00.0: Finished xhci_init
> [   54.739372] xhci_hcd 0000:11:00.0: Called HCD init
> [   54.739378] xhci_hcd 0000:11:00.0: Got SBRN 48
> [   54.739396] xhci_hcd 0000:11:00.0: MWI active
> [   54.739397] xhci_hcd 0000:11:00.0: Finished xhci_pci_reinit
> [   54.739398] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [   54.739413] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [   54.740076] xhci_hcd 0000:11:00.0: xhci_run
> [   54.740182] xhci_hcd 0000:11:00.0: irq 49 for MSI/MSI-X
> [   54.740186] xhci_hcd 0000:11:00.0: irq 50 for MSI/MSI-X
> [   54.740190] xhci_hcd 0000:11:00.0: irq 51 for MSI/MSI-X
> [   54.740194] xhci_hcd 0000:11:00.0: irq 52 for MSI/MSI-X
> [   54.740198] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [   54.740285] xhci_hcd 0000:11:00.0: Setting event ring polling timer
> [   54.740287] xhci_hcd 0000:11:00.0: Command ring memory map follows:
> [   54.740289] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 00000000
> [   54.740291] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00000000
> [   54.740292] xhci_hcd 0000:11:00.0: @00000000ffffe020 00000000 00000000 00000000 00000000
> [   54.740294] xhci_hcd 0000:11:00.0: @00000000ffffe030 00000000 00000000 00000000 00000000
> [   54.740295] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [   54.740297] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [   54.740299] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [   54.740300] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [   54.740302] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [   54.740303] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [   54.740305] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [   54.740306] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [   54.740308] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [   54.740310] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [   54.740311] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [   54.740313] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [   54.740314] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [   54.740316] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [   54.740317] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [   54.740319] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [   54.740321] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [   54.740322] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [   54.740324] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [   54.740325] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [   54.740327] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [   54.740329] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [   54.740330] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [   54.740332] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [   54.740333] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [   54.740335] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [   54.740336] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [   54.740338] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [   54.740340] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [   54.740341] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [   54.740343] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [   54.740344] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [   54.740346] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [   54.740347] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [   54.740349] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [   54.740350] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [   54.740352] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [   54.740354] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [   54.740355] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [   54.740357] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [   54.740358] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [   54.740360] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [   54.740362] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [   54.740363] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [   54.740365] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [   54.740366] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [   54.740368] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [   54.740369] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [   54.740371] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [   54.740373] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [   54.740374] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [   54.740376] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [   54.740377] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [   54.740379] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [   54.740380] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [   54.740382] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [   54.740384] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [   54.740385] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [   54.740387] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [   54.740389] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [   54.740390] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [   54.740392] xhci_hcd 0000:11:00.0: Ring deq = ffff88040cb75000 (virt), 0xffffe000 (dma)
> [   54.740393] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [   54.740394] xhci_hcd 0000:11:00.0: Ring enq = ffff88040cb75000 (virt), 0xffffe000 (dma)
> [   54.740396] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [   54.740405] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [   54.740406] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [   54.740408] xhci_hcd 0000:11:00.0: ERST memory map follows:
> [   54.740409] xhci_hcd 0000:11:00.0: @00000000ffffd000 ffffe400 00000000 00000040 00000000
> [   54.740411] xhci_hcd 0000:11:00.0: Event ring:
> [   54.740412] xhci_hcd 0000:11:00.0: @00000000ffffe400 00000000 00000000 00000000 00000000
> [   54.740414] xhci_hcd 0000:11:00.0: @00000000ffffe410 00000000 00000000 00000000 00000000
> [   54.740415] xhci_hcd 0000:11:00.0: @00000000ffffe420 00000000 00000000 00000000 00000000
> [   54.740417] xhci_hcd 0000:11:00.0: @00000000ffffe430 00000000 00000000 00000000 00000000
> [   54.740418] xhci_hcd 0000:11:00.0: @00000000ffffe440 00000000 00000000 00000000 00000000
> [   54.740420] xhci_hcd 0000:11:00.0: @00000000ffffe450 00000000 00000000 00000000 00000000
> [   54.740421] xhci_hcd 0000:11:00.0: @00000000ffffe460 00000000 00000000 00000000 00000000
> [   54.740423] xhci_hcd 0000:11:00.0: @00000000ffffe470 00000000 00000000 00000000 00000000
> [   54.740425] xhci_hcd 0000:11:00.0: @00000000ffffe480 00000000 00000000 00000000 00000000
> [   54.740426] xhci_hcd 0000:11:00.0: @00000000ffffe490 00000000 00000000 00000000 00000000
> [   54.740428] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 00000000 00000000 00000000 00000000
> [   54.740429] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 00000000 00000000 00000000 00000000
> [   54.740431] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 00000000 00000000 00000000 00000000
> [   54.740432] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 00000000 00000000 00000000 00000000
> [   54.740434] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 00000000 00000000 00000000 00000000
> [   54.740435] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 00000000 00000000 00000000 00000000
> [   54.740437] xhci_hcd 0000:11:00.0: @00000000ffffe500 00000000 00000000 00000000 00000000
> [   54.740439] xhci_hcd 0000:11:00.0: @00000000ffffe510 00000000 00000000 00000000 00000000
> [   54.740440] xhci_hcd 0000:11:00.0: @00000000ffffe520 00000000 00000000 00000000 00000000
> [   54.740442] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [   54.740443] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [   54.740445] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [   54.740446] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [   54.740448] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [   54.740450] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [   54.740451] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [   54.740453] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [   54.740454] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [   54.740456] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [   54.740457] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [   54.740459] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [   54.740461] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [   54.740462] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [   54.740464] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [   54.740465] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [   54.740467] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [   54.740468] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [   54.740470] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [   54.740472] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [   54.740473] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [   54.740475] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [   54.740476] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [   54.740478] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [   54.740479] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [   54.740481] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [   54.740483] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [   54.740484] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [   54.740486] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [   54.740487] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [   54.740489] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [   54.740490] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [   54.740492] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [   54.740494] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [   54.740495] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [   54.740497] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [   54.740498] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [   54.740500] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [   54.740501] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [   54.740503] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [   54.740505] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [   54.740506] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [   54.740508] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [   54.740509] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [   54.740511] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [   54.740512] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [   54.740514] xhci_hcd 0000:11:00.0: Ring deq = ffff88040cb75400 (virt), 0xffffe400 (dma)
> [   54.740515] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [   54.740516] xhci_hcd 0000:11:00.0: Ring enq = ffff88040cb75400 (virt), 0xffffe400 (dma)
> [   54.740518] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [   54.740527] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe400
> [   54.740528] xhci_hcd 0000:11:00.0: // Set the interrupt modulation register
> [   54.740538] xhci_hcd 0000:11:00.0: // Enable interrupts, cmd = 0x4.
> [   54.740552] xhci_hcd 0000:11:00.0: // Enabling event ring interrupter ffffc90006970620 by writing 0x2 to irq_pending
> [   54.740558] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set[0]
> [   54.740560] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set.pending = 0x2
> [   54.740566] xhci_hcd 0000:11:00.0:   ffffc90006970624: ir_set.control = 0xa0
> [   54.740572] xhci_hcd 0000:11:00.0:   ffffc90006970628: ir_set.erst_size = 0x1
> [   54.740585] xhci_hcd 0000:11:00.0:   ffffc90006970630: ir_set.erst_base = @ffffd000
> [   54.740594] xhci_hcd 0000:11:00.0:   ffffc90006970638: ir_set.erst_dequeue = @ffffe400
> [   54.740595] xhci_hcd 0000:11:00.0: Finished xhci_run for USB2 roothub
> [   54.740605] usb usb3: default language 0x0409
> [   54.740609] usb usb3: udev 1, busnum 3, minor = 256
> [   54.740610] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [   54.741249] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   54.741894] usb usb3: Product: xHCI Host Controller
> [   54.742535] usb usb3: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [   54.743189] usb usb3: SerialNumber: 0000:11:00.0
> [   54.743979] usb usb3: usb_probe_device
> [   54.743981] usb usb3: configuration #1 chosen from 1 choice
> [   54.743985] xHCI xhci_add_endpoint called for root hub
> [   54.743987] xHCI xhci_check_bandwidth called for root hub
> [   54.743992] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [   54.744016] hub 3-0:1.0: usb_probe_interface
> [   54.744018] hub 3-0:1.0: usb_probe_interface - got id
> [   54.744021] hub 3-0:1.0: USB hub found
> [   54.744844] hub 3-0:1.0: 2 ports detected
> [   54.744846] hub 3-0:1.0: standalone hub
> [   54.744848] hub 3-0:1.0: individual port power switching
> [   54.744849] hub 3-0:1.0: individual port over-current protection
> [   54.744851] hub 3-0:1.0: Single TT
> [   54.744853] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [   54.744854] hub 3-0:1.0: power on to power good time: 20ms
> [   54.744858] hub 3-0:1.0: local power source is good
> [   54.744860] hub 3-0:1.0: enabling power on all ports
> [   54.744871] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [   54.744887] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [   54.744967] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [   54.744972] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 4
> [   54.744980] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [   54.744981] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [   54.744988] xhci_hcd 0000:11:00.0: // Turn on HC, cmd = 0x5.
> [   54.745006] xhci_hcd 0000:11:00.0: // Ding dong!
> [   54.745012] xhci_hcd 0000:11:00.0: Finished xhci_run for USB3 roothub
> [   54.745020] usb usb4: skipped 1 descriptor after endpoint
> [   54.745023] usb usb4: default language 0x0409
> [   54.745029] usb usb4: udev 1, busnum 4, minor = 384
> [   54.745030] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [   54.745032] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   54.745034] usb usb4: Product: xHCI Host Controller
> [   54.745036] usb usb4: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [   54.745037] usb usb4: SerialNumber: 0000:11:00.0
> [   54.745082] xhci_hcd 0000:11:00.0: Vendor specific event TRB type = 48
> [   54.745084] xhci_hcd 0000:11:00.0: NEC firmware version 30.28
> [   54.745121] usb usb4: usb_probe_device
> [   54.745123] usb usb4: configuration #1 chosen from 1 choice
> [   54.745125] xHCI xhci_add_endpoint called for root hub
> [   54.745127] xHCI xhci_check_bandwidth called for root hub
> [   54.745132] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [   54.745159] hub 4-0:1.0: usb_probe_interface
> [   54.745161] hub 4-0:1.0: usb_probe_interface - got id
> [   54.745162] hub 4-0:1.0: USB hub found
> [   54.745179] hub 4-0:1.0: 2 ports detected
> [   54.745181] hub 4-0:1.0: standalone hub
> [   54.745182] hub 4-0:1.0: individual port power switching
> [   54.745184] hub 4-0:1.0: individual port over-current protection
> [   54.745186] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [   54.745187] hub 4-0:1.0: power on to power good time: 20ms
> [   54.745191] hub 4-0:1.0: local power source is good
> [   54.745192] hub 4-0:1.0: enabling power on all ports
> [   54.745210] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [   54.745235] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [   54.796213] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [   54.843293] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [   54.843305] xhci_hcd 0000:11:00.0: Get port status returned 0x100
> [   54.843324] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x202e1
> [   54.843331] xhci_hcd 0000:11:00.0: Get port status returned 0x10101
> [   54.843342] hub 3-0:1.0: port 2: status 0101 change 0001
> [   54.843360] xhci_hcd 0000:11:00.0: clear port connect change, actual port 1 status  = 0x2e1
> [   54.843380] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [   54.843392] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [   54.843399] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2a0
> [   54.843401] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [   54.843432] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [   54.943260] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [   54.943273] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2e1
> [   54.943275] xhci_hcd 0000:11:00.0: Get port status returned 0x101
> [   54.943279] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [   54.943282] xhci_hcd 0000:11:00.0: // Ding dong!
> [   54.943363] xhci_hcd 0000:11:00.0: Slot 1 output ctx = 0xffffc000 (dma)
> [   54.943368] xhci_hcd 0000:11:00.0: Slot 1 input ctx = 0xffffb000 (dma)
> [   54.943374] xhci_hcd 0000:11:00.0: Set slot id 1 dcbaa entry ffff88040ed31008 to 0xffffc000
> [   54.943389] xhci_hcd 0000:11:00.0: set port reset, actual port 1 status  = 0x331
> [   54.993448] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [   55.003056] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x200a03
> [   55.003067] xhci_hcd 0000:11:00.0: Get port status returned 0x100303
> [   55.063091] xhci_hcd 0000:11:00.0: clear port reset change, actual port 1 status  = 0xa03
> [   55.063097] usb 3-2: new low-speed USB device number 2 using xhci_hcd
> [   55.063839] xhci_hcd 0000:11:00.0: Set root hub portnum to 4
> [   55.063840] xhci_hcd 0000:11:00.0: Set fake root hub portnum to 2
> [   55.063842] xhci_hcd 0000:11:00.0: udev->tt = ffff88040c8f5298
> [   55.063843] xhci_hcd 0000:11:00.0: udev->ttport = 0x2
> [   55.063844] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [   55.063846] xhci_hcd 0000:11:00.0: @ffff88040add5000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [   55.063848] xhci_hcd 0000:11:00.0: @ffff88040add5004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [   55.063850] xhci_hcd 0000:11:00.0: @ffff88040add5008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   55.063851] xhci_hcd 0000:11:00.0: @ffff88040add500c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   55.063853] xhci_hcd 0000:11:00.0: @ffff88040add5010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   55.063855] xhci_hcd 0000:11:00.0: @ffff88040add5014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   55.063856] xhci_hcd 0000:11:00.0: @ffff88040add5018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   55.063858] xhci_hcd 0000:11:00.0: @ffff88040add501c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   55.063859] xhci_hcd 0000:11:00.0: Slot Context:
> [   55.063861] xhci_hcd 0000:11:00.0: @ffff88040add5020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [   55.063862] xhci_hcd 0000:11:00.0: @ffff88040add5024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   55.063864] xhci_hcd 0000:11:00.0: @ffff88040add5028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   55.063865] xhci_hcd 0000:11:00.0: @ffff88040add502c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   55.063867] xhci_hcd 0000:11:00.0: @ffff88040add5030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   55.063869] xhci_hcd 0000:11:00.0: @ffff88040add5034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   55.063870] xhci_hcd 0000:11:00.0: @ffff88040add5038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   55.063872] xhci_hcd 0000:11:00.0: @ffff88040add503c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   55.063874] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   55.063875] xhci_hcd 0000:11:00.0: @ffff88040add5040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   55.063876] xhci_hcd 0000:11:00.0: @ffff88040add5044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   55.063878] xhci_hcd 0000:11:00.0: @ffff88040add5048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   55.063880] xhci_hcd 0000:11:00.0: @ffff88040add5050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   55.063881] xhci_hcd 0000:11:00.0: @ffff88040add5054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   55.063883] xhci_hcd 0000:11:00.0: @ffff88040add5058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   55.063885] xhci_hcd 0000:11:00.0: @ffff88040add505c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   55.063886] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   55.063887] xhci_hcd 0000:11:00.0: @ffff88040add5060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [   55.063889] xhci_hcd 0000:11:00.0: @ffff88040add5064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [   55.063891] xhci_hcd 0000:11:00.0: @ffff88040add5068 (virt) @ffffb068 (dma) 0x000000 - deq
> [   55.063892] xhci_hcd 0000:11:00.0: @ffff88040add5070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [   55.063894] xhci_hcd 0000:11:00.0: @ffff88040add5074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [   55.063895] xhci_hcd 0000:11:00.0: @ffff88040add5078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [   55.063897] xhci_hcd 0000:11:00.0: @ffff88040add507c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [   55.063898] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   55.063900] xhci_hcd 0000:11:00.0: @ffff88040add5080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [   55.063901] xhci_hcd 0000:11:00.0: @ffff88040add5084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [   55.063903] xhci_hcd 0000:11:00.0: @ffff88040add5088 (virt) @ffffb088 (dma) 0x000000 - deq
> [   55.063904] xhci_hcd 0000:11:00.0: @ffff88040add5090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [   55.063906] xhci_hcd 0000:11:00.0: @ffff88040add5094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [   55.063908] xhci_hcd 0000:11:00.0: @ffff88040add5098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [   55.063909] xhci_hcd 0000:11:00.0: @ffff88040add509c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [   55.063911] xhci_hcd 0000:11:00.0: // Ding dong!
> [   55.064693] xhci_hcd 0000:11:00.0: Successful Address Device command
> [   55.064713] xhci_hcd 0000:11:00.0: Op regs DCBAA ptr = 0x000000fffff000
> [   55.064722] xhci_hcd 0000:11:00.0: Slot ID 1 dcbaa entry @ffff88040ed31008 = 0x000000ffffc000
> [   55.064728] xhci_hcd 0000:11:00.0: Output Context DMA address = 0xffffc000
> [   55.064734] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [   55.064742] xhci_hcd 0000:11:00.0: @ffff88040add5000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [   55.064749] xhci_hcd 0000:11:00.0: @ffff88040add5004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [   55.064757] xhci_hcd 0000:11:00.0: @ffff88040add5008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   55.064764] xhci_hcd 0000:11:00.0: @ffff88040add500c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   55.064771] xhci_hcd 0000:11:00.0: @ffff88040add5010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   55.064779] xhci_hcd 0000:11:00.0: @ffff88040add5014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   55.064786] xhci_hcd 0000:11:00.0: @ffff88040add5018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   55.064793] xhci_hcd 0000:11:00.0: @ffff88040add501c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   55.064799] xhci_hcd 0000:11:00.0: Slot Context:
> [   55.064805] xhci_hcd 0000:11:00.0: @ffff88040add5020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [   55.064820] xhci_hcd 0000:11:00.0: @ffff88040add5024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   55.064822] xhci_hcd 0000:11:00.0: @ffff88040add5028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   55.064824] xhci_hcd 0000:11:00.0: @ffff88040add502c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   55.064825] xhci_hcd 0000:11:00.0: @ffff88040add5030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   55.064827] xhci_hcd 0000:11:00.0: @ffff88040add5034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   55.064828] xhci_hcd 0000:11:00.0: @ffff88040add5038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   55.064830] xhci_hcd 0000:11:00.0: @ffff88040add503c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   55.064832] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   55.064833] xhci_hcd 0000:11:00.0: @ffff88040add5040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   55.064834] xhci_hcd 0000:11:00.0: @ffff88040add5044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   55.064836] xhci_hcd 0000:11:00.0: @ffff88040add5048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   55.064838] xhci_hcd 0000:11:00.0: @ffff88040add5050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   55.064839] xhci_hcd 0000:11:00.0: @ffff88040add5054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   55.064841] xhci_hcd 0000:11:00.0: @ffff88040add5058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   55.064843] xhci_hcd 0000:11:00.0: @ffff88040add505c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   55.064844] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   55.064845] xhci_hcd 0000:11:00.0: @ffff88040add5060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [   55.064847] xhci_hcd 0000:11:00.0: @ffff88040add5064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [   55.064849] xhci_hcd 0000:11:00.0: @ffff88040add5068 (virt) @ffffb068 (dma) 0x000000 - deq
> [   55.064850] xhci_hcd 0000:11:00.0: @ffff88040add5070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [   55.064852] xhci_hcd 0000:11:00.0: @ffff88040add5074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [   55.064853] xhci_hcd 0000:11:00.0: @ffff88040add5078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [   55.064855] xhci_hcd 0000:11:00.0: @ffff88040add507c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [   55.064856] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   55.064858] xhci_hcd 0000:11:00.0: @ffff88040add5080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [   55.064859] xhci_hcd 0000:11:00.0: @ffff88040add5084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [   55.064861] xhci_hcd 0000:11:00.0: @ffff88040add5088 (virt) @ffffb088 (dma) 0x000000 - deq
> [   55.064862] xhci_hcd 0000:11:00.0: @ffff88040add5090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [   55.064864] xhci_hcd 0000:11:00.0: @ffff88040add5094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [   55.064866] xhci_hcd 0000:11:00.0: @ffff88040add5098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [   55.064867] xhci_hcd 0000:11:00.0: @ffff88040add509c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [   55.064869] xhci_hcd 0000:11:00.0: Slot ID 1 Output Context:
> [   55.064870] xhci_hcd 0000:11:00.0: Slot Context:
> [   55.064871] xhci_hcd 0000:11:00.0: @ffff88040c8f4000 (virt) @ffffc000 (dma) 0x8200000 - dev_info
> [   55.064873] xhci_hcd 0000:11:00.0: @ffff88040c8f4004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [   55.064874] xhci_hcd 0000:11:00.0: @ffff88040c8f4008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [   55.064876] xhci_hcd 0000:11:00.0: @ffff88040c8f400c (virt) @ffffc00c (dma) 0x10000001 - dev_state
> [   55.064878] xhci_hcd 0000:11:00.0: @ffff88040c8f4010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [   55.064879] xhci_hcd 0000:11:00.0: @ffff88040c8f4014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [   55.064881] xhci_hcd 0000:11:00.0: @ffff88040c8f4018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [   55.064882] xhci_hcd 0000:11:00.0: @ffff88040c8f401c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [   55.064884] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   55.064885] xhci_hcd 0000:11:00.0: @ffff88040c8f4020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [   55.064887] xhci_hcd 0000:11:00.0: @ffff88040c8f4024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [   55.064888] xhci_hcd 0000:11:00.0: @ffff88040c8f4028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [   55.064890] xhci_hcd 0000:11:00.0: @ffff88040c8f4030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [   55.064892] xhci_hcd 0000:11:00.0: @ffff88040c8f4034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [   55.064893] xhci_hcd 0000:11:00.0: @ffff88040c8f4038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [   55.064895] xhci_hcd 0000:11:00.0: @ffff88040c8f403c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [   55.064896] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   55.064897] xhci_hcd 0000:11:00.0: @ffff88040c8f4040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [   55.064899] xhci_hcd 0000:11:00.0: @ffff88040c8f4044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [   55.064901] xhci_hcd 0000:11:00.0: @ffff88040c8f4048 (virt) @ffffc048 (dma) 0x000000 - deq
> [   55.064902] xhci_hcd 0000:11:00.0: @ffff88040c8f4050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [   55.064904] xhci_hcd 0000:11:00.0: @ffff88040c8f4054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [   55.064905] xhci_hcd 0000:11:00.0: @ffff88040c8f4058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [   55.064907] xhci_hcd 0000:11:00.0: @ffff88040c8f405c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [   55.064908] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   55.064910] xhci_hcd 0000:11:00.0: @ffff88040c8f4060 (virt) @ffffc060 (dma) 0x000000 - ep_info
> [   55.064911] xhci_hcd 0000:11:00.0: @ffff88040c8f4064 (virt) @ffffc064 (dma) 0x000000 - ep_info2
> [   55.064913] xhci_hcd 0000:11:00.0: @ffff88040c8f4068 (virt) @ffffc068 (dma) 0x000000 - deq
> [   55.064914] xhci_hcd 0000:11:00.0: @ffff88040c8f4070 (virt) @ffffc070 (dma) 0x000000 - tx_info
> [   55.064916] xhci_hcd 0000:11:00.0: @ffff88040c8f4074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [   55.064917] xhci_hcd 0000:11:00.0: @ffff88040c8f4078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [   55.064919] xhci_hcd 0000:11:00.0: @ffff88040c8f407c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [   55.064921] xhci_hcd 0000:11:00.0: Internal device address = 2
> [   55.101713] usb 3-2: skipped 1 descriptor after interface
> [   55.103644] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [   55.104677] usb 3-2: default language 0x0409
> [   55.112619] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [   55.116618] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [   55.117661] usb 3-2: udev 2, busnum 3, minor = 257
> [   55.117671] usb 3-2: New USB device found, idVendor=0458, idProduct=0036
> [   55.118487] usb 3-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> [   55.119244] usb 3-2: Product: NetScroll + Mini Traveler
> [   55.120007] usb 3-2: Manufacturer: Genius
> [   55.120902] usb 3-2: usb_probe_device
> [   55.120905] usb 3-2: configuration #1 chosen from 1 choice
> [   55.120913] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
> [   55.121891] xhci_hcd 0000:11:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18200000
> [   55.121894] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040bd81800
> [   55.121896] xhci_hcd 0000:11:00.0: New Input Control Context:
> [   55.121899] xhci_hcd 0000:11:00.0: @ffff88040add5000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [   55.121901] xhci_hcd 0000:11:00.0: @ffff88040add5004 (virt) @ffffb004 (dma) 0x000009 - add flags
> [   55.121904] xhci_hcd 0000:11:00.0: @ffff88040add5008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   55.121906] xhci_hcd 0000:11:00.0: @ffff88040add500c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   55.121909] xhci_hcd 0000:11:00.0: @ffff88040add5010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   55.121911] xhci_hcd 0000:11:00.0: @ffff88040add5014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   55.121914] xhci_hcd 0000:11:00.0: @ffff88040add5018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   55.121916] xhci_hcd 0000:11:00.0: @ffff88040add501c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   55.121918] xhci_hcd 0000:11:00.0: Slot Context:
> [   55.121920] xhci_hcd 0000:11:00.0: @ffff88040add5020 (virt) @ffffb020 (dma) 0x18200000 - dev_info
> [   55.121923] xhci_hcd 0000:11:00.0: @ffff88040add5024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   55.121925] xhci_hcd 0000:11:00.0: @ffff88040add5028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   55.121928] xhci_hcd 0000:11:00.0: @ffff88040add502c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   55.121930] xhci_hcd 0000:11:00.0: @ffff88040add5030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   55.121933] xhci_hcd 0000:11:00.0: @ffff88040add5034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   55.121935] xhci_hcd 0000:11:00.0: @ffff88040add5038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   55.121937] xhci_hcd 0000:11:00.0: @ffff88040add503c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   55.121940] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   55.121942] xhci_hcd 0000:11:00.0: @ffff88040add5040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   55.121944] xhci_hcd 0000:11:00.0: @ffff88040add5044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   55.121946] xhci_hcd 0000:11:00.0: @ffff88040add5048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   55.121949] xhci_hcd 0000:11:00.0: @ffff88040add5050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   55.121951] xhci_hcd 0000:11:00.0: @ffff88040add5054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   55.121954] xhci_hcd 0000:11:00.0: @ffff88040add5058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   55.121956] xhci_hcd 0000:11:00.0: @ffff88040add505c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   55.121958] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   55.121960] xhci_hcd 0000:11:00.0: @ffff88040add5060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [   55.121963] xhci_hcd 0000:11:00.0: @ffff88040add5064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [   55.121965] xhci_hcd 0000:11:00.0: @ffff88040add5068 (virt) @ffffb068 (dma) 0x000000 - deq
> [   55.121967] xhci_hcd 0000:11:00.0: @ffff88040add5070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [   55.121970] xhci_hcd 0000:11:00.0: @ffff88040add5074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [   55.121972] xhci_hcd 0000:11:00.0: @ffff88040add5078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [   55.121975] xhci_hcd 0000:11:00.0: @ffff88040add507c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [   55.121977] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   55.121979] xhci_hcd 0000:11:00.0: @ffff88040add5080 (virt) @ffffb080 (dma) 0x060000 - ep_info
> [   55.121981] xhci_hcd 0000:11:00.0: @ffff88040add5084 (virt) @ffffb084 (dma) 0x04003e - ep_info2
> [   55.121984] xhci_hcd 0000:11:00.0: @ffff88040add5088 (virt) @ffffb088 (dma) 0xffffa401 - deq
> [   55.121986] xhci_hcd 0000:11:00.0: @ffff88040add5090 (virt) @ffffb090 (dma) 0x040004 - tx_info
> [   55.121988] xhci_hcd 0000:11:00.0: @ffff88040add5094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [   55.121991] xhci_hcd 0000:11:00.0: @ffff88040add5098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [   55.121993] xhci_hcd 0000:11:00.0: @ffff88040add509c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [   55.121996] xhci_hcd 0000:11:00.0: // Ding dong!
> [   55.122276] xhci_hcd 0000:11:00.0: Completed config ep cmd
> [   55.122309] usb 3-2: Successful Endpoint Configure command
> [   55.122315] xhci_hcd 0000:11:00.0: Output context after successful config ep cmd:
> [   55.122320] xhci_hcd 0000:11:00.0: Slot Context:
> [   55.122328] xhci_hcd 0000:11:00.0: @ffff88040c8f4000 (virt) @ffffc000 (dma) 0x18200000 - dev_info
> [   55.122337] xhci_hcd 0000:11:00.0: @ffff88040c8f4004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [   55.122344] xhci_hcd 0000:11:00.0: @ffff88040c8f4008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [   55.122352] xhci_hcd 0000:11:00.0: @ffff88040c8f400c (virt) @ffffc00c (dma) 0x18000001 - dev_state
> [   55.122360] xhci_hcd 0000:11:00.0: @ffff88040c8f4010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [   55.122367] xhci_hcd 0000:11:00.0: @ffff88040c8f4014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [   55.122374] xhci_hcd 0000:11:00.0: @ffff88040c8f4018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [   55.122382] xhci_hcd 0000:11:00.0: @ffff88040c8f401c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [   55.122389] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   55.122395] xhci_hcd 0000:11:00.0: @ffff88040c8f4020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [   55.122402] xhci_hcd 0000:11:00.0: @ffff88040c8f4024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [   55.122409] xhci_hcd 0000:11:00.0: @ffff88040c8f4028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [   55.122416] xhci_hcd 0000:11:00.0: @ffff88040c8f4030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [   55.122424] xhci_hcd 0000:11:00.0: @ffff88040c8f4034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [   55.122436] xhci_hcd 0000:11:00.0: @ffff88040c8f4038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [   55.122437] xhci_hcd 0000:11:00.0: @ffff88040c8f403c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [   55.122439] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   55.122440] xhci_hcd 0000:11:00.0: @ffff88040c8f4040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [   55.122442] xhci_hcd 0000:11:00.0: @ffff88040c8f4044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [   55.122443] xhci_hcd 0000:11:00.0: @ffff88040c8f4048 (virt) @ffffc048 (dma) 0x000000 - deq
> [   55.122445] xhci_hcd 0000:11:00.0: @ffff88040c8f4050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [   55.122447] xhci_hcd 0000:11:00.0: @ffff88040c8f4054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [   55.122448] xhci_hcd 0000:11:00.0: @ffff88040c8f4058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [   55.122450] xhci_hcd 0000:11:00.0: @ffff88040c8f405c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [   55.122451] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   55.122453] xhci_hcd 0000:11:00.0: @ffff88040c8f4060 (virt) @ffffc060 (dma) 0x060001 - ep_info
> [   55.122454] xhci_hcd 0000:11:00.0: @ffff88040c8f4064 (virt) @ffffc064 (dma) 0x04003e - ep_info2
> [   55.122456] xhci_hcd 0000:11:00.0: @ffff88040c8f4068 (virt) @ffffc068 (dma) 0xffffa401 - deq
> [   55.122457] xhci_hcd 0000:11:00.0: @ffff88040c8f4070 (virt) @ffffc070 (dma) 0x040004 - tx_info
> [   55.122459] xhci_hcd 0000:11:00.0: @ffff88040c8f4074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [   55.122461] xhci_hcd 0000:11:00.0: @ffff88040c8f4078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [   55.122462] xhci_hcd 0000:11:00.0: @ffff88040c8f407c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [   55.124547] xhci_hcd 0000:11:00.0: Endpoint 0x81 not halted, refusing to reset.
> [   55.124564] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> [   55.124639] usbserial_generic 3-2:1.0: usb_probe_interface
> [   55.124640] usbserial_generic 3-2:1.0: usb_probe_interface - got id
> [   55.124650] usbhid 3-2:1.0: usb_probe_interface
> [   55.124651] usbhid 3-2:1.0: usb_probe_interface - got id
> [   55.135837] input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1c.7/0000:11:00.0/usb3/3-2/3-2:1.0/input/input14
> [   55.136882] generic-usb 0003:0458:0036.0001: input,hidraw0: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:11:00.0-2/input0
> [   57.040047] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> [   57.040082] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> [   57.040096] hub 4-0:1.0: hub_suspend
> [   57.040109] usb usb4: bus auto-suspend, wakeup 1
> [   87.490793] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [   87.490803] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [   87.490820] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [   87.491613] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [   87.491776] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [   87.491778] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [   87.491835] xhci_hcd 0000:11:00.0: remove, state 4
> [   87.492593] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [   87.492596] usb usb4: USB disconnect, device number 1
> [   87.493344] usb usb4: unregistering device
> [   87.493346] usb usb4: unregistering interface 4-0:1.0
> [   87.493387] usb usb4: usb_disable_device nuking all URBs
> [   87.493396] xHCI xhci_drop_endpoint called for root hub
> [   87.493397] xHCI xhci_check_bandwidth called for root hub
> [   87.493507] xhci_hcd 0000:11:00.0: // Halt the HC
> [   87.493520] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [   87.494390] xhci_hcd 0000:11:00.0: USB bus 4 deregistered
> [   87.495216] xhci_hcd 0000:11:00.0: remove, state 1
> [   87.496068] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [   87.496071] usb usb3: USB disconnect, device number 1
> [   87.496073] usb 3-2: USB disconnect, device number 2
> [   87.496074] usb 3-2: unregistering device
> [   87.496076] usb 3-2: unregistering interface 3-2:1.0
> [   87.496108] xhci_hcd 0000:11:00.0: HW died, freeing TD.
> [   87.496111] xhci_hcd 0000:11:00.0: shutdown urb ffff88040af3c680 ep1in-intr
> [   87.514878] usb 3-2: usb_disable_device nuking all URBs
> [   87.514884] xhci_hcd 0000:11:00.0: xhci_drop_endpoint called for udev ffff88040bd81800
> [   87.514887] xhci_hcd 0000:11:00.0: drop ep 0x81, slot id 1, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8200000
> [   87.514890] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040bd81800
> [   87.514892] xhci_hcd 0000:11:00.0: New Input Control Context:
> [   87.514895] xhci_hcd 0000:11:00.0: @ffff88040add5000 (virt) @ffffb000 (dma) 0x000008 - drop flags
> [   87.514898] xhci_hcd 0000:11:00.0: @ffff88040add5004 (virt) @ffffb004 (dma) 0x000001 - add flags
> [   87.514901] xhci_hcd 0000:11:00.0: @ffff88040add5008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   87.514903] xhci_hcd 0000:11:00.0: @ffff88040add500c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   87.514906] xhci_hcd 0000:11:00.0: @ffff88040add5010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   87.514909] xhci_hcd 0000:11:00.0: @ffff88040add5014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   87.514911] xhci_hcd 0000:11:00.0: @ffff88040add5018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   87.514914] xhci_hcd 0000:11:00.0: @ffff88040add501c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   87.514916] xhci_hcd 0000:11:00.0: Slot Context:
> [   87.514918] xhci_hcd 0000:11:00.0: @ffff88040add5020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [   87.514920] xhci_hcd 0000:11:00.0: @ffff88040add5024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   87.514922] xhci_hcd 0000:11:00.0: @ffff88040add5028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   87.514924] xhci_hcd 0000:11:00.0: @ffff88040add502c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   87.514927] xhci_hcd 0000:11:00.0: @ffff88040add5030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   87.514929] xhci_hcd 0000:11:00.0: @ffff88040add5034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   87.514932] xhci_hcd 0000:11:00.0: @ffff88040add5038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   87.514934] xhci_hcd 0000:11:00.0: @ffff88040add503c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   87.514937] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   87.514939] xhci_hcd 0000:11:00.0: @ffff88040add5040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   87.514942] xhci_hcd 0000:11:00.0: @ffff88040add5044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   87.514944] xhci_hcd 0000:11:00.0: @ffff88040add5048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   87.514947] xhci_hcd 0000:11:00.0: @ffff88040add5050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   87.514949] xhci_hcd 0000:11:00.0: @ffff88040add5054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   87.514952] xhci_hcd 0000:11:00.0: @ffff88040add5058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   87.514955] xhci_hcd 0000:11:00.0: @ffff88040add505c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   87.514958] xhci_hcd 0000:11:00.0: // Ding dong!
> [  113.782107] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  113.782111] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  113.782121] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  113.782662] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  113.782828] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  113.885372] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [  113.885389] pciehp 0000:00:1c.7:pcie04: Device 0000:11:00.0 already exists at 0000:11:00, cannot hot-add
> [  113.885998] pciehp 0000:00:1c.7:pcie04: Cannot add device at 0000:11:00
> [  114.664188] xhci_hcd 0000:11:00.0: Poll event ring: 4294948768
> [  114.664203] xhci_hcd 0000:11:00.0: op reg status = 0xffffffff
> [  114.664209] xhci_hcd 0000:11:00.0: HW died, polling stopped.
> [  137.440321] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> [  137.441126] usb usb3: unregistering device
> [  137.441129] usb usb3: unregistering interface 3-0:1.0
> [  137.441156] xhci_hcd 0000:11:00.0: shutdown urb ffff88040bf773c0 ep1in-intr
> [  137.441171] usb usb3: usb_disable_device nuking all URBs
> [  137.441173] xHCI xhci_drop_endpoint called for root hub
> [  137.441175] xHCI xhci_check_bandwidth called for root hub
> [  137.441315] xhci_hcd 0000:11:00.0: // Halt the HC
> [  137.441328] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  137.441952] xhci_hcd 0000:11:00.0: // Reset the HC
> [  137.442045] xhci_hcd 0000:11:00.0: // Disabling event ring interrupts
> [  137.442057] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set[0]
> [  137.442058] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set.pending = 0xffffffff
> [  137.442064] xhci_hcd 0000:11:00.0:   ffffc90006970624: ir_set.control = 0xffffffff
> [  137.442070] xhci_hcd 0000:11:00.0:   ffffc90006970628: ir_set.erst_size = 0xffffffff
> [  137.442076] xhci_hcd 0000:11:00.0:   WARN: ffffc9000697062c: ir_set.rsvd = 0xffffffff
> [  137.442085] xhci_hcd 0000:11:00.0:   ffffc90006970630: ir_set.erst_base = @ffffffffffffffff
> [  137.442094] xhci_hcd 0000:11:00.0:   ffffc90006970638: ir_set.erst_dequeue = @ffffffffffffffff
> [  137.442096] xhci_hcd 0000:11:00.0: cleaning up memory
> [  137.442100] xhci_hcd 0000:11:00.0: Freed ERST
> [  137.442101] xhci_hcd 0000:11:00.0: Freed event ring
> [  137.442102] xhci_hcd 0000:11:00.0: Freed command ring
> [  137.442106] xhci_hcd 0000:11:00.0: Freed segment pool
> [  137.442108] xhci_hcd 0000:11:00.0: Freed device context pool
> [  137.442109] xhci_hcd 0000:11:00.0: Freed small stream array pool
> [  137.442110] xhci_hcd 0000:11:00.0: Freed medium stream array pool
> [  137.442117] xhci_hcd 0000:11:00.0: xhci_stop completed - status = ffffffff
> [  137.442119] xhci_hcd 0000:11:00.0: USB bus 3 deregistered
> [  196.391774] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  196.391785] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  196.391802] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  196.392433] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  196.392664] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  196.392667] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [  266.018366] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  266.018376] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  266.018378] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  266.019100] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  266.019268] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  266.128716] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [  266.128825] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [  266.128876] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [  266.129122] pci 0000:11:00.0: PME# supported from D0 D3hot
> [  266.148746] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [  266.149472] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> [  266.150136] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [  266.150805] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [  266.151469] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [  266.152265] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [  266.153050] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  266.153727] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 3
> [  266.154431] xhci_hcd 0000:11:00.0: xHCI capability registers at ffffc90006684000:
> [  266.154437] xhci_hcd 0000:11:00.0: CAPLENGTH AND HCIVERSION 0x960020:
> [  266.154438] xhci_hcd 0000:11:00.0: CAPLENGTH: 0x20
> [  266.154439] xhci_hcd 0000:11:00.0: HCIVERSION: 0x96
> [  266.154445] xhci_hcd 0000:11:00.0: HCSPARAMS 1: 0x4000820
> [  266.154446] xhci_hcd 0000:11:00.0:   Max device slots: 32
> [  266.154447] xhci_hcd 0000:11:00.0:   Max interrupters: 8
> [  266.154448] xhci_hcd 0000:11:00.0:   Max ports: 4
> [  266.154454] xhci_hcd 0000:11:00.0: HCSPARAMS 2: 0x11
> [  266.154455] xhci_hcd 0000:11:00.0:   Isoc scheduling threshold: 1
> [  266.154456] xhci_hcd 0000:11:00.0:   Maximum allowed segments in event ring: 1
> [  266.154462] xhci_hcd 0000:11:00.0: HCSPARAMS 3 0x0:
> [  266.154463] xhci_hcd 0000:11:00.0:   Worst case U1 device exit latency: 0
> [  266.154464] xhci_hcd 0000:11:00.0:   Worst case U2 device exit latency: 0
> [  266.154470] xhci_hcd 0000:11:00.0: HCC PARAMS 0x14042cb:
> [  266.154471] xhci_hcd 0000:11:00.0:   HC generates 64 bit addresses
> [  266.154473] xhci_hcd 0000:11:00.0:   FIXME: more HCCPARAMS debugging
> [  266.154478] xhci_hcd 0000:11:00.0: RTSOFF 0x600:
> [  266.154480] xhci_hcd 0000:11:00.0: xHCI operational registers at ffffc90006684020:
> [  266.154486] xhci_hcd 0000:11:00.0: USBCMD 0x0:
> [  266.154487] xhci_hcd 0000:11:00.0:   HC is being stopped
> [  266.154488] xhci_hcd 0000:11:00.0:   HC has finished hard reset
> [  266.154489] xhci_hcd 0000:11:00.0:   Event Interrupts disabled
> [  266.154490] xhci_hcd 0000:11:00.0:   Host System Error Interrupts disabled
> [  266.154491] xhci_hcd 0000:11:00.0:   HC has finished light reset
> [  266.154497] xhci_hcd 0000:11:00.0: USBSTS 0x11:
> [  266.154498] xhci_hcd 0000:11:00.0:   Event ring is empty
> [  266.154499] xhci_hcd 0000:11:00.0:   No Host System Error
> [  266.154501] xhci_hcd 0000:11:00.0:   HC is halted
> [  266.154507] xhci_hcd 0000:11:00.0: ffffc90006684420 port status reg = 0x2a0
> [  266.154513] xhci_hcd 0000:11:00.0: ffffc90006684424 port power reg = 0x0
> [  266.154519] xhci_hcd 0000:11:00.0: ffffc90006684428 port link reg = 0x0
> [  266.154525] xhci_hcd 0000:11:00.0: ffffc9000668442c port reserved reg = 0x0
> [  266.154531] xhci_hcd 0000:11:00.0: ffffc90006684430 port status reg = 0x2a0
> [  266.154537] xhci_hcd 0000:11:00.0: ffffc90006684434 port power reg = 0x0
> [  266.154543] xhci_hcd 0000:11:00.0: ffffc90006684438 port link reg = 0x0
> [  266.154550] xhci_hcd 0000:11:00.0: ffffc9000668443c port reserved reg = 0x0
> [  266.154555] xhci_hcd 0000:11:00.0: ffffc90006684440 port status reg = 0x2a0
> [  266.154561] xhci_hcd 0000:11:00.0: ffffc90006684444 port power reg = 0x0
> [  266.154567] xhci_hcd 0000:11:00.0: ffffc90006684448 port link reg = 0x0
> [  266.154573] xhci_hcd 0000:11:00.0: ffffc9000668444c port reserved reg = 0x0
> [  266.154579] xhci_hcd 0000:11:00.0: ffffc90006684450 port status reg = 0x202e1
> [  266.154585] xhci_hcd 0000:11:00.0: ffffc90006684454 port power reg = 0x0
> [  266.154591] xhci_hcd 0000:11:00.0: ffffc90006684458 port link reg = 0x0
> [  266.154597] xhci_hcd 0000:11:00.0: ffffc9000668445c port reserved reg = 0x0
> [  266.154599] xhci_hcd 0000:11:00.0: // Halt the HC
> [  266.154611] xhci_hcd 0000:11:00.0: Resetting HCD
> [  266.154617] xhci_hcd 0000:11:00.0: // Reset the HC
> [  266.154667] xhci_hcd 0000:11:00.0: Wait for controller to be ready for doorbell rings
> [  266.154673] xhci_hcd 0000:11:00.0: Reset complete
> [  266.154679] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  266.154680] xhci_hcd 0000:11:00.0: Calling HCD init
> [  266.154681] xhci_hcd 0000:11:00.0: xhci_init
> [  266.154682] xhci_hcd 0000:11:00.0: xHCI doesn't need link TRB QUIRK
> [  266.154688] xhci_hcd 0000:11:00.0: Supported page size register = 0x1
> [  266.154689] xhci_hcd 0000:11:00.0: Supported page size of 4K
> [  266.154690] xhci_hcd 0000:11:00.0: HCD page size set to 4K
> [  266.154696] xhci_hcd 0000:11:00.0: // xHC can handle at most 32 device slots.
> [  266.154702] xhci_hcd 0000:11:00.0: // Setting Max device slots reg = 0x20.
> [  266.154722] xhci_hcd 0000:11:00.0: // Device context base array address = 0xfffff000 (DMA), ffff88040cb0c000 (virt)
> [  266.154726] xhci_hcd 0000:11:00.0: Allocated command ring at ffff88040c97f240
> [  266.154727] xhci_hcd 0000:11:00.0: First segment DMA is 0xffffe000
> [  266.154736] xhci_hcd 0000:11:00.0: // Setting command ring address to 0x20
> [  266.154746] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  266.154747] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  266.154753] xhci_hcd 0000:11:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
> [  266.154755] xhci_hcd 0000:11:00.0: // xHCI capability registers at ffffc90006684000:
> [  266.154761] xhci_hcd 0000:11:00.0: // @ffffc90006684000 = 0x960020 (CAPLENGTH AND HCIVERSION)
> [  266.154762] xhci_hcd 0000:11:00.0: //   CAPLENGTH: 0x20
> [  266.154763] xhci_hcd 0000:11:00.0: // xHCI operational registers at ffffc90006684020:
> [  266.154770] xhci_hcd 0000:11:00.0: // @ffffc90006684018 = 0x600 RTSOFF
> [  266.154771] xhci_hcd 0000:11:00.0: // xHCI runtime registers at ffffc90006684600:
> [  266.154777] xhci_hcd 0000:11:00.0: // @ffffc90006684014 = 0x800 DBOFF
> [  266.154778] xhci_hcd 0000:11:00.0: // Doorbell array at ffffc90006684800:
> [  266.154779] xhci_hcd 0000:11:00.0: xHCI runtime registers at ffffc90006684600:
> [  266.154785] xhci_hcd 0000:11:00.0:   ffffc90006684600: Microframe index = 0x0
> [  266.154810] xhci_hcd 0000:11:00.0: // Allocating event ring
> [  266.154813] xhci_hcd 0000:11:00.0: TRB math tests passed.
> [  266.154815] xhci_hcd 0000:11:00.0: // Allocated event ring segment table at 0xffffd000
> [  266.154817] xhci_hcd 0000:11:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88040ae71000, dma addr = 0xffffd000
> [  266.154823] xhci_hcd 0000:11:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [  266.154825] xhci_hcd 0000:11:00.0: // Set ERST entries to point to event ring.
> [  266.154826] xhci_hcd 0000:11:00.0: // Set ERST base address for ir_set 0 = 0xffffd000
> [  266.154842] xhci_hcd 0000:11:00.0: // Write event ring dequeue pointer, preserving EHB bit
> [  266.154844] xhci_hcd 0000:11:00.0: Wrote ERST address to ir_set 0.
> [  266.154849] xhci_hcd 0000:11:00.0: Allocating 0 scratchpad buffers
> [  266.154867] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006684510, port offset = 1, count = 2, revision = 0x3
> [  266.154877] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006684520, port offset = 3, count = 2, revision = 0x2
> [  266.154879] xhci_hcd 0000:11:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [  266.154880] xhci_hcd 0000:11:00.0: USB 2.0 port at index 2, addr = ffffc90006684440
> [  266.154882] xhci_hcd 0000:11:00.0: USB 2.0 port at index 3, addr = ffffc90006684450
> [  266.154884] xhci_hcd 0000:11:00.0: USB 3.0 port at index 0, addr = ffffc90006684420
> [  266.154885] xhci_hcd 0000:11:00.0: USB 3.0 port at index 1, addr = ffffc90006684430
> [  266.154891] xhci_hcd 0000:11:00.0: Finished xhci_init
> [  266.154892] xhci_hcd 0000:11:00.0: Called HCD init
> [  266.154898] xhci_hcd 0000:11:00.0: Got SBRN 48
> [  266.154916] xhci_hcd 0000:11:00.0: MWI active
> [  266.154917] xhci_hcd 0000:11:00.0: Finished xhci_pci_reinit
> [  266.154918] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  266.154929] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [  266.155612] xhci_hcd 0000:11:00.0: xhci_run
> [  266.155715] xhci_hcd 0000:11:00.0: irq 49 for MSI/MSI-X
> [  266.155719] xhci_hcd 0000:11:00.0: irq 50 for MSI/MSI-X
> [  266.155724] xhci_hcd 0000:11:00.0: irq 51 for MSI/MSI-X
> [  266.155728] xhci_hcd 0000:11:00.0: irq 52 for MSI/MSI-X
> [  266.155733] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [  266.155823] xhci_hcd 0000:11:00.0: Setting event ring polling timer
> [  266.155825] xhci_hcd 0000:11:00.0: Command ring memory map follows:
> [  266.155827] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 00000000
> [  266.155829] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00000000
> [  266.155830] xhci_hcd 0000:11:00.0: @00000000ffffe020 00000000 00000000 00000000 00000000
> [  266.155832] xhci_hcd 0000:11:00.0: @00000000ffffe030 00000000 00000000 00000000 00000000
> [  266.155834] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [  266.155835] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [  266.155837] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [  266.155838] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [  266.155840] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [  266.155842] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [  266.155843] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [  266.155845] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [  266.155846] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [  266.155848] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [  266.155849] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [  266.155851] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [  266.155853] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [  266.155854] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [  266.155856] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [  266.155857] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [  266.155859] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [  266.155860] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [  266.155862] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [  266.155864] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [  266.155865] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [  266.155867] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [  266.155868] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [  266.155870] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [  266.155871] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [  266.155873] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [  266.155875] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [  266.155876] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [  266.155878] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [  266.155879] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [  266.155881] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [  266.155882] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [  266.155884] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [  266.155886] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [  266.155887] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [  266.155889] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [  266.155890] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [  266.155892] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [  266.155893] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [  266.155895] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [  266.155897] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [  266.155898] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [  266.155900] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [  266.155901] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [  266.155903] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [  266.155904] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [  266.155906] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [  266.155908] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [  266.155909] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [  266.155911] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [  266.155912] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [  266.155914] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [  266.155916] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [  266.155917] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [  266.155919] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [  266.155920] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [  266.155922] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [  266.155923] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [  266.155925] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [  266.155927] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [  266.155928] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  266.155930] xhci_hcd 0000:11:00.0: Ring deq = ffff88040ae5b000 (virt), 0xffffe000 (dma)
> [  266.155931] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  266.155933] xhci_hcd 0000:11:00.0: Ring enq = ffff88040ae5b000 (virt), 0xffffe000 (dma)
> [  266.155934] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  266.155943] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  266.155945] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  266.155946] xhci_hcd 0000:11:00.0: ERST memory map follows:
> [  266.155948] xhci_hcd 0000:11:00.0: @00000000ffffd000 ffffe400 00000000 00000040 00000000
> [  266.155949] xhci_hcd 0000:11:00.0: Event ring:
> [  266.155950] xhci_hcd 0000:11:00.0: @00000000ffffe400 00000000 00000000 00000000 00000000
> [  266.155952] xhci_hcd 0000:11:00.0: @00000000ffffe410 00000000 00000000 00000000 00000000
> [  266.155953] xhci_hcd 0000:11:00.0: @00000000ffffe420 00000000 00000000 00000000 00000000
> [  266.155955] xhci_hcd 0000:11:00.0: @00000000ffffe430 00000000 00000000 00000000 00000000
> [  266.155957] xhci_hcd 0000:11:00.0: @00000000ffffe440 00000000 00000000 00000000 00000000
> [  266.155958] xhci_hcd 0000:11:00.0: @00000000ffffe450 00000000 00000000 00000000 00000000
> [  266.155960] xhci_hcd 0000:11:00.0: @00000000ffffe460 00000000 00000000 00000000 00000000
> [  266.155961] xhci_hcd 0000:11:00.0: @00000000ffffe470 00000000 00000000 00000000 00000000
> [  266.155963] xhci_hcd 0000:11:00.0: @00000000ffffe480 00000000 00000000 00000000 00000000
> [  266.155965] xhci_hcd 0000:11:00.0: @00000000ffffe490 00000000 00000000 00000000 00000000
> [  266.155966] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 00000000 00000000 00000000 00000000
> [  266.155968] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 00000000 00000000 00000000 00000000
> [  266.155969] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 00000000 00000000 00000000 00000000
> [  266.155971] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 00000000 00000000 00000000 00000000
> [  266.155973] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 00000000 00000000 00000000 00000000
> [  266.155974] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 00000000 00000000 00000000 00000000
> [  266.155976] xhci_hcd 0000:11:00.0: @00000000ffffe500 00000000 00000000 00000000 00000000
> [  266.155977] xhci_hcd 0000:11:00.0: @00000000ffffe510 00000000 00000000 00000000 00000000
> [  266.155979] xhci_hcd 0000:11:00.0: @00000000ffffe520 00000000 00000000 00000000 00000000
> [  266.155980] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [  266.155982] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [  266.155984] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [  266.155985] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [  266.155987] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [  266.155988] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [  266.155990] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [  266.155991] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [  266.155993] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [  266.155995] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [  266.155996] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [  266.155998] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [  266.155999] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [  266.156001] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [  266.156003] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [  266.156004] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [  266.156006] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [  266.156007] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [  266.156009] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [  266.156010] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [  266.156012] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [  266.156014] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [  266.156015] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [  266.156017] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [  266.156018] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [  266.156020] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [  266.156021] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [  266.156023] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [  266.156025] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [  266.156026] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [  266.156028] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [  266.156029] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [  266.156031] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [  266.156033] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [  266.156034] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [  266.156036] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [  266.156037] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [  266.156039] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [  266.156041] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [  266.156042] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [  266.156044] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [  266.156045] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [  266.156047] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [  266.156048] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [  266.156050] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [  266.156051] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  266.156053] xhci_hcd 0000:11:00.0: Ring deq = ffff88040ae5b400 (virt), 0xffffe400 (dma)
> [  266.156054] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  266.156055] xhci_hcd 0000:11:00.0: Ring enq = ffff88040ae5b400 (virt), 0xffffe400 (dma)
> [  266.156057] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  266.156066] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe400
> [  266.156067] xhci_hcd 0000:11:00.0: // Set the interrupt modulation register
> [  266.156077] xhci_hcd 0000:11:00.0: // Enable interrupts, cmd = 0x4.
> [  266.156083] xhci_hcd 0000:11:00.0: // Enabling event ring interrupter ffffc90006684620 by writing 0x2 to irq_pending
> [  266.156090] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set[0]
> [  266.156092] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set.pending = 0x2
> [  266.156098] xhci_hcd 0000:11:00.0:   ffffc90006684624: ir_set.control = 0xa0
> [  266.156104] xhci_hcd 0000:11:00.0:   ffffc90006684628: ir_set.erst_size = 0x1
> [  266.156117] xhci_hcd 0000:11:00.0:   ffffc90006684630: ir_set.erst_base = @ffffd000
> [  266.156126] xhci_hcd 0000:11:00.0:   ffffc90006684638: ir_set.erst_dequeue = @ffffe400
> [  266.156128] xhci_hcd 0000:11:00.0: Finished xhci_run for USB2 roothub
> [  266.156138] usb usb3: default language 0x0409
> [  266.156142] usb usb3: udev 1, busnum 3, minor = 256
> [  266.156144] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [  266.156852] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  266.157546] usb usb3: Product: xHCI Host Controller
> [  266.158241] usb usb3: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  266.158969] usb usb3: SerialNumber: 0000:11:00.0
> [  266.160001] usb usb3: usb_probe_device
> [  266.160003] usb usb3: configuration #1 chosen from 1 choice
> [  266.160006] xHCI xhci_add_endpoint called for root hub
> [  266.160008] xHCI xhci_check_bandwidth called for root hub
> [  266.160014] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [  266.160038] hub 3-0:1.0: usb_probe_interface
> [  266.160040] hub 3-0:1.0: usb_probe_interface - got id
> [  266.160042] hub 3-0:1.0: USB hub found
> [  266.160055] hub 3-0:1.0: 2 ports detected
> [  266.160056] hub 3-0:1.0: standalone hub
> [  266.160058] hub 3-0:1.0: individual port power switching
> [  266.160059] hub 3-0:1.0: individual port over-current protection
> [  266.160060] hub 3-0:1.0: Single TT
> [  266.160061] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  266.160063] hub 3-0:1.0: power on to power good time: 20ms
> [  266.160065] hub 3-0:1.0: local power source is good
> [  266.160066] hub 3-0:1.0: enabling power on all ports
> [  266.160076] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  266.160088] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  266.160130] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  266.160133] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 4
> [  266.160140] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  266.160141] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  266.160146] xhci_hcd 0000:11:00.0: // Turn on HC, cmd = 0x5.
> [  266.160164] xhci_hcd 0000:11:00.0: // Ding dong!
> [  266.160170] xhci_hcd 0000:11:00.0: Finished xhci_run for USB3 roothub
> [  266.160175] usb usb4: skipped 1 descriptor after endpoint
> [  266.160177] usb usb4: default language 0x0409
> [  266.160180] usb usb4: udev 1, busnum 4, minor = 384
> [  266.160181] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [  266.160183] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  266.160184] usb usb4: Product: xHCI Host Controller
> [  266.160185] usb usb4: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  266.160186] usb usb4: SerialNumber: 0000:11:00.0
> [  266.160238] xhci_hcd 0000:11:00.0: Vendor specific event TRB type = 48
> [  266.160240] xhci_hcd 0000:11:00.0: NEC firmware version 30.28
> [  266.160251] usb usb4: usb_probe_device
> [  266.160253] usb usb4: configuration #1 chosen from 1 choice
> [  266.160256] xHCI xhci_add_endpoint called for root hub
> [  266.160257] xHCI xhci_check_bandwidth called for root hub
> [  266.160262] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [  266.160287] hub 4-0:1.0: usb_probe_interface
> [  266.160288] hub 4-0:1.0: usb_probe_interface - got id
> [  266.160290] hub 4-0:1.0: USB hub found
> [  266.160310] hub 4-0:1.0: 2 ports detected
> [  266.160311] hub 4-0:1.0: standalone hub
> [  266.160312] hub 4-0:1.0: individual port power switching
> [  266.160314] hub 4-0:1.0: individual port over-current protection
> [  266.160316] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  266.160317] hub 4-0:1.0: power on to power good time: 20ms
> [  266.160320] hub 4-0:1.0: local power source is good
> [  266.160322] hub 4-0:1.0: enabling power on all ports
> [  266.160339] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  266.160363] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  266.214246] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  266.258467] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  266.258470] xhci_hcd 0000:11:00.0: Get port status returned 0x100
> [  266.258481] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x202e1
> [  266.258483] xhci_hcd 0000:11:00.0: Get port status returned 0x10101
> [  266.258486] hub 3-0:1.0: port 2: status 0101 change 0001
> [  266.258499] xhci_hcd 0000:11:00.0: clear port connect change, actual port 1 status  = 0x2e1
> [  266.258509] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  266.258511] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  266.258518] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2a0
> [  266.258520] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  266.258527] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [  266.358299] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [  266.358310] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2e1
> [  266.358312] xhci_hcd 0000:11:00.0: Get port status returned 0x101
> [  266.358316] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [  266.358320] xhci_hcd 0000:11:00.0: // Ding dong!
> [  266.358380] xhci_hcd 0000:11:00.0: Slot 1 output ctx = 0xffffc000 (dma)
> [  266.358388] xhci_hcd 0000:11:00.0: Slot 1 input ctx = 0xffffb000 (dma)
> [  266.358395] xhci_hcd 0000:11:00.0: Set slot id 1 dcbaa entry ffff88040cb0c008 to 0xffffc000
> [  266.358412] xhci_hcd 0000:11:00.0: set port reset, actual port 1 status  = 0x331
> [  266.408344] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  266.418301] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x200a03
> [  266.418316] xhci_hcd 0000:11:00.0: Get port status returned 0x100303
> [  266.478208] xhci_hcd 0000:11:00.0: clear port reset change, actual port 1 status  = 0xa03
> [  266.478227] usb 3-2: new low-speed USB device number 2 using xhci_hcd
> [  266.479013] xhci_hcd 0000:11:00.0: Set root hub portnum to 4
> [  266.479014] xhci_hcd 0000:11:00.0: Set fake root hub portnum to 2
> [  266.479016] xhci_hcd 0000:11:00.0: udev->tt = ffff88040c8c8698
> [  266.479017] xhci_hcd 0000:11:00.0: udev->ttport = 0x2
> [  266.479018] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  266.479020] xhci_hcd 0000:11:00.0: @ffff88040d4f7000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  266.479022] xhci_hcd 0000:11:00.0: @ffff88040d4f7004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  266.479024] xhci_hcd 0000:11:00.0: @ffff88040d4f7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  266.479025] xhci_hcd 0000:11:00.0: @ffff88040d4f700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  266.479027] xhci_hcd 0000:11:00.0: @ffff88040d4f7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  266.479029] xhci_hcd 0000:11:00.0: @ffff88040d4f7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  266.479030] xhci_hcd 0000:11:00.0: @ffff88040d4f7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  266.479032] xhci_hcd 0000:11:00.0: @ffff88040d4f701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  266.479033] xhci_hcd 0000:11:00.0: Slot Context:
> [  266.479035] xhci_hcd 0000:11:00.0: @ffff88040d4f7020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  266.479036] xhci_hcd 0000:11:00.0: @ffff88040d4f7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  266.479038] xhci_hcd 0000:11:00.0: @ffff88040d4f7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  266.479040] xhci_hcd 0000:11:00.0: @ffff88040d4f702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  266.479041] xhci_hcd 0000:11:00.0: @ffff88040d4f7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  266.479043] xhci_hcd 0000:11:00.0: @ffff88040d4f7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  266.479044] xhci_hcd 0000:11:00.0: @ffff88040d4f7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  266.479046] xhci_hcd 0000:11:00.0: @ffff88040d4f703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  266.479048] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  266.479049] xhci_hcd 0000:11:00.0: @ffff88040d4f7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  266.479051] xhci_hcd 0000:11:00.0: @ffff88040d4f7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  266.479052] xhci_hcd 0000:11:00.0: @ffff88040d4f7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  266.479054] xhci_hcd 0000:11:00.0: @ffff88040d4f7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  266.479055] xhci_hcd 0000:11:00.0: @ffff88040d4f7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  266.479057] xhci_hcd 0000:11:00.0: @ffff88040d4f7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  266.479059] xhci_hcd 0000:11:00.0: @ffff88040d4f705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  266.479060] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  266.479061] xhci_hcd 0000:11:00.0: @ffff88040d4f7060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  266.479063] xhci_hcd 0000:11:00.0: @ffff88040d4f7064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  266.479065] xhci_hcd 0000:11:00.0: @ffff88040d4f7068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  266.479066] xhci_hcd 0000:11:00.0: @ffff88040d4f7070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  266.479068] xhci_hcd 0000:11:00.0: @ffff88040d4f7074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  266.479069] xhci_hcd 0000:11:00.0: @ffff88040d4f7078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  266.479071] xhci_hcd 0000:11:00.0: @ffff88040d4f707c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  266.479072] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  266.479074] xhci_hcd 0000:11:00.0: @ffff88040d4f7080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  266.479075] xhci_hcd 0000:11:00.0: @ffff88040d4f7084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  266.479077] xhci_hcd 0000:11:00.0: @ffff88040d4f7088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  266.479079] xhci_hcd 0000:11:00.0: @ffff88040d4f7090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  266.479080] xhci_hcd 0000:11:00.0: @ffff88040d4f7094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  266.479082] xhci_hcd 0000:11:00.0: @ffff88040d4f7098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  266.479083] xhci_hcd 0000:11:00.0: @ffff88040d4f709c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  266.479086] xhci_hcd 0000:11:00.0: // Ding dong!
> [  266.479853] xhci_hcd 0000:11:00.0: Successful Address Device command
> [  266.479873] xhci_hcd 0000:11:00.0: Op regs DCBAA ptr = 0x000000fffff000
> [  266.479882] xhci_hcd 0000:11:00.0: Slot ID 1 dcbaa entry @ffff88040cb0c008 = 0x000000ffffc000
> [  266.479889] xhci_hcd 0000:11:00.0: Output Context DMA address = 0xffffc000
> [  266.479895] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  266.479902] xhci_hcd 0000:11:00.0: @ffff88040d4f7000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  266.479910] xhci_hcd 0000:11:00.0: @ffff88040d4f7004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  266.479918] xhci_hcd 0000:11:00.0: @ffff88040d4f7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  266.479925] xhci_hcd 0000:11:00.0: @ffff88040d4f700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  266.479933] xhci_hcd 0000:11:00.0: @ffff88040d4f7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  266.479940] xhci_hcd 0000:11:00.0: @ffff88040d4f7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  266.479947] xhci_hcd 0000:11:00.0: @ffff88040d4f7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  266.479954] xhci_hcd 0000:11:00.0: @ffff88040d4f701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  266.479960] xhci_hcd 0000:11:00.0: Slot Context:
> [  266.479966] xhci_hcd 0000:11:00.0: @ffff88040d4f7020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  266.479981] xhci_hcd 0000:11:00.0: @ffff88040d4f7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  266.479983] xhci_hcd 0000:11:00.0: @ffff88040d4f7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  266.479984] xhci_hcd 0000:11:00.0: @ffff88040d4f702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  266.479986] xhci_hcd 0000:11:00.0: @ffff88040d4f7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  266.479987] xhci_hcd 0000:11:00.0: @ffff88040d4f7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  266.479989] xhci_hcd 0000:11:00.0: @ffff88040d4f7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  266.479991] xhci_hcd 0000:11:00.0: @ffff88040d4f703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  266.479992] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  266.479994] xhci_hcd 0000:11:00.0: @ffff88040d4f7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  266.479995] xhci_hcd 0000:11:00.0: @ffff88040d4f7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  266.479997] xhci_hcd 0000:11:00.0: @ffff88040d4f7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  266.479998] xhci_hcd 0000:11:00.0: @ffff88040d4f7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  266.480000] xhci_hcd 0000:11:00.0: @ffff88040d4f7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  266.480002] xhci_hcd 0000:11:00.0: @ffff88040d4f7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  266.480003] xhci_hcd 0000:11:00.0: @ffff88040d4f705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  266.480005] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  266.480006] xhci_hcd 0000:11:00.0: @ffff88040d4f7060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  266.480008] xhci_hcd 0000:11:00.0: @ffff88040d4f7064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  266.480009] xhci_hcd 0000:11:00.0: @ffff88040d4f7068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  266.480011] xhci_hcd 0000:11:00.0: @ffff88040d4f7070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  266.480012] xhci_hcd 0000:11:00.0: @ffff88040d4f7074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  266.480014] xhci_hcd 0000:11:00.0: @ffff88040d4f7078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  266.480016] xhci_hcd 0000:11:00.0: @ffff88040d4f707c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  266.480017] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  266.480018] xhci_hcd 0000:11:00.0: @ffff88040d4f7080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  266.480020] xhci_hcd 0000:11:00.0: @ffff88040d4f7084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  266.480022] xhci_hcd 0000:11:00.0: @ffff88040d4f7088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  266.480023] xhci_hcd 0000:11:00.0: @ffff88040d4f7090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  266.480025] xhci_hcd 0000:11:00.0: @ffff88040d4f7094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  266.480026] xhci_hcd 0000:11:00.0: @ffff88040d4f7098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  266.480028] xhci_hcd 0000:11:00.0: @ffff88040d4f709c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  266.480029] xhci_hcd 0000:11:00.0: Slot ID 1 Output Context:
> [  266.480031] xhci_hcd 0000:11:00.0: Slot Context:
> [  266.480032] xhci_hcd 0000:11:00.0: @ffff88040da46000 (virt) @ffffc000 (dma) 0x8200000 - dev_info
> [  266.480034] xhci_hcd 0000:11:00.0: @ffff88040da46004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  266.480035] xhci_hcd 0000:11:00.0: @ffff88040da46008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  266.480037] xhci_hcd 0000:11:00.0: @ffff88040da4600c (virt) @ffffc00c (dma) 0x10000001 - dev_state
> [  266.480039] xhci_hcd 0000:11:00.0: @ffff88040da46010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  266.480040] xhci_hcd 0000:11:00.0: @ffff88040da46014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  266.480042] xhci_hcd 0000:11:00.0: @ffff88040da46018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  266.480043] xhci_hcd 0000:11:00.0: @ffff88040da4601c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  266.480045] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  266.480046] xhci_hcd 0000:11:00.0: @ffff88040da46020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  266.480048] xhci_hcd 0000:11:00.0: @ffff88040da46024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  266.480049] xhci_hcd 0000:11:00.0: @ffff88040da46028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  266.480051] xhci_hcd 0000:11:00.0: @ffff88040da46030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  266.480053] xhci_hcd 0000:11:00.0: @ffff88040da46034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  266.480054] xhci_hcd 0000:11:00.0: @ffff88040da46038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  266.480056] xhci_hcd 0000:11:00.0: @ffff88040da4603c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  266.480057] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  266.480059] xhci_hcd 0000:11:00.0: @ffff88040da46040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  266.480060] xhci_hcd 0000:11:00.0: @ffff88040da46044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  266.480062] xhci_hcd 0000:11:00.0: @ffff88040da46048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  266.480063] xhci_hcd 0000:11:00.0: @ffff88040da46050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  266.480065] xhci_hcd 0000:11:00.0: @ffff88040da46054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  266.480067] xhci_hcd 0000:11:00.0: @ffff88040da46058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  266.480068] xhci_hcd 0000:11:00.0: @ffff88040da4605c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  266.480070] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  266.480071] xhci_hcd 0000:11:00.0: @ffff88040da46060 (virt) @ffffc060 (dma) 0x000000 - ep_info
> [  266.480073] xhci_hcd 0000:11:00.0: @ffff88040da46064 (virt) @ffffc064 (dma) 0x000000 - ep_info2
> [  266.480074] xhci_hcd 0000:11:00.0: @ffff88040da46068 (virt) @ffffc068 (dma) 0x000000 - deq
> [  266.480076] xhci_hcd 0000:11:00.0: @ffff88040da46070 (virt) @ffffc070 (dma) 0x000000 - tx_info
> [  266.480077] xhci_hcd 0000:11:00.0: @ffff88040da46074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  266.480079] xhci_hcd 0000:11:00.0: @ffff88040da46078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  266.480081] xhci_hcd 0000:11:00.0: @ffff88040da4607c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  266.480082] xhci_hcd 0000:11:00.0: Internal device address = 2
> [  266.516706] usb 3-2: skipped 1 descriptor after interface
> [  266.518711] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  266.519711] usb 3-2: default language 0x0409
> [  266.527694] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  266.531704] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  266.532697] usb 3-2: udev 2, busnum 3, minor = 257
> [  266.532699] usb 3-2: New USB device found, idVendor=0458, idProduct=0036
> [  266.532700] usb 3-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> [  266.532702] usb 3-2: Product: NetScroll + Mini Traveler
> [  266.532703] usb 3-2: Manufacturer: Genius
> [  266.532773] usb 3-2: usb_probe_device
> [  266.532775] usb 3-2: configuration #1 chosen from 1 choice
> [  266.532780] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
> [  266.532782] xhci_hcd 0000:11:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18200000
> [  266.532785] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040d5b5000
> [  266.532786] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  266.532788] xhci_hcd 0000:11:00.0: @ffff88040d4f7000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  266.532789] xhci_hcd 0000:11:00.0: @ffff88040d4f7004 (virt) @ffffb004 (dma) 0x000009 - add flags
> [  266.532791] xhci_hcd 0000:11:00.0: @ffff88040d4f7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  266.532793] xhci_hcd 0000:11:00.0: @ffff88040d4f700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  266.532795] xhci_hcd 0000:11:00.0: @ffff88040d4f7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  266.532796] xhci_hcd 0000:11:00.0: @ffff88040d4f7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  266.532798] xhci_hcd 0000:11:00.0: @ffff88040d4f7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  266.532799] xhci_hcd 0000:11:00.0: @ffff88040d4f701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  266.532801] xhci_hcd 0000:11:00.0: Slot Context:
> [  266.532802] xhci_hcd 0000:11:00.0: @ffff88040d4f7020 (virt) @ffffb020 (dma) 0x18200000 - dev_info
> [  266.532803] xhci_hcd 0000:11:00.0: @ffff88040d4f7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  266.532805] xhci_hcd 0000:11:00.0: @ffff88040d4f7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  266.532806] xhci_hcd 0000:11:00.0: @ffff88040d4f702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  266.532808] xhci_hcd 0000:11:00.0: @ffff88040d4f7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  266.532810] xhci_hcd 0000:11:00.0: @ffff88040d4f7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  266.532811] xhci_hcd 0000:11:00.0: @ffff88040d4f7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  266.532813] xhci_hcd 0000:11:00.0: @ffff88040d4f703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  266.532814] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  266.532815] xhci_hcd 0000:11:00.0: @ffff88040d4f7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  266.532817] xhci_hcd 0000:11:00.0: @ffff88040d4f7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  266.532818] xhci_hcd 0000:11:00.0: @ffff88040d4f7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  266.532820] xhci_hcd 0000:11:00.0: @ffff88040d4f7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  266.532821] xhci_hcd 0000:11:00.0: @ffff88040d4f7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  266.532823] xhci_hcd 0000:11:00.0: @ffff88040d4f7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  266.532824] xhci_hcd 0000:11:00.0: @ffff88040d4f705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  266.532826] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  266.532827] xhci_hcd 0000:11:00.0: @ffff88040d4f7060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  266.532828] xhci_hcd 0000:11:00.0: @ffff88040d4f7064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  266.532830] xhci_hcd 0000:11:00.0: @ffff88040d4f7068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  266.532831] xhci_hcd 0000:11:00.0: @ffff88040d4f7070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  266.532833] xhci_hcd 0000:11:00.0: @ffff88040d4f7074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  266.532834] xhci_hcd 0000:11:00.0: @ffff88040d4f7078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  266.532836] xhci_hcd 0000:11:00.0: @ffff88040d4f707c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  266.532837] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  266.532839] xhci_hcd 0000:11:00.0: @ffff88040d4f7080 (virt) @ffffb080 (dma) 0x060000 - ep_info
> [  266.532840] xhci_hcd 0000:11:00.0: @ffff88040d4f7084 (virt) @ffffb084 (dma) 0x04003e - ep_info2
> [  266.532842] xhci_hcd 0000:11:00.0: @ffff88040d4f7088 (virt) @ffffb088 (dma) 0xffffa401 - deq
> [  266.532843] xhci_hcd 0000:11:00.0: @ffff88040d4f7090 (virt) @ffffb090 (dma) 0x040004 - tx_info
> [  266.532845] xhci_hcd 0000:11:00.0: @ffff88040d4f7094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  266.532846] xhci_hcd 0000:11:00.0: @ffff88040d4f7098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  266.532848] xhci_hcd 0000:11:00.0: @ffff88040d4f709c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  266.532850] xhci_hcd 0000:11:00.0: // Ding dong!
> [  266.533085] xhci_hcd 0000:11:00.0: Completed config ep cmd
> [  266.533099] usb 3-2: Successful Endpoint Configure command
> [  266.533100] xhci_hcd 0000:11:00.0: Output context after successful config ep cmd:
> [  266.533101] xhci_hcd 0000:11:00.0: Slot Context:
> [  266.533103] xhci_hcd 0000:11:00.0: @ffff88040da46000 (virt) @ffffc000 (dma) 0x18200000 - dev_info
> [  266.533105] xhci_hcd 0000:11:00.0: @ffff88040da46004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  266.533107] xhci_hcd 0000:11:00.0: @ffff88040da46008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  266.533108] xhci_hcd 0000:11:00.0: @ffff88040da4600c (virt) @ffffc00c (dma) 0x18000001 - dev_state
> [  266.533110] xhci_hcd 0000:11:00.0: @ffff88040da46010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  266.533112] xhci_hcd 0000:11:00.0: @ffff88040da46014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  266.533113] xhci_hcd 0000:11:00.0: @ffff88040da46018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  266.533115] xhci_hcd 0000:11:00.0: @ffff88040da4601c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  266.533116] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  266.533117] xhci_hcd 0000:11:00.0: @ffff88040da46020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  266.533119] xhci_hcd 0000:11:00.0: @ffff88040da46024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  266.533120] xhci_hcd 0000:11:00.0: @ffff88040da46028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  266.533122] xhci_hcd 0000:11:00.0: @ffff88040da46030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  266.533123] xhci_hcd 0000:11:00.0: @ffff88040da46034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  266.533125] xhci_hcd 0000:11:00.0: @ffff88040da46038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  266.533127] xhci_hcd 0000:11:00.0: @ffff88040da4603c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  266.533128] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  266.533129] xhci_hcd 0000:11:00.0: @ffff88040da46040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  266.533131] xhci_hcd 0000:11:00.0: @ffff88040da46044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  266.533132] xhci_hcd 0000:11:00.0: @ffff88040da46048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  266.533134] xhci_hcd 0000:11:00.0: @ffff88040da46050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  266.533135] xhci_hcd 0000:11:00.0: @ffff88040da46054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  266.533137] xhci_hcd 0000:11:00.0: @ffff88040da46058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  266.533138] xhci_hcd 0000:11:00.0: @ffff88040da4605c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  266.533139] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  266.533141] xhci_hcd 0000:11:00.0: @ffff88040da46060 (virt) @ffffc060 (dma) 0x060001 - ep_info
> [  266.533142] xhci_hcd 0000:11:00.0: @ffff88040da46064 (virt) @ffffc064 (dma) 0x04003e - ep_info2
> [  266.533144] xhci_hcd 0000:11:00.0: @ffff88040da46068 (virt) @ffffc068 (dma) 0xffffa401 - deq
> [  266.533145] xhci_hcd 0000:11:00.0: @ffff88040da46070 (virt) @ffffc070 (dma) 0x040004 - tx_info
> [  266.533147] xhci_hcd 0000:11:00.0: @ffff88040da46074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  266.533149] xhci_hcd 0000:11:00.0: @ffff88040da46078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  266.533150] xhci_hcd 0000:11:00.0: @ffff88040da4607c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  266.534685] xhci_hcd 0000:11:00.0: Endpoint 0x81 not halted, refusing to reset.
> [  266.534689] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> [  266.534710] usbserial_generic 3-2:1.0: usb_probe_interface
> [  266.534712] usbserial_generic 3-2:1.0: usb_probe_interface - got id
> [  266.534720] usbhid 3-2:1.0: usb_probe_interface
> [  266.534721] usbhid 3-2:1.0: usb_probe_interface - got id
> [  266.545757] input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1c.7/0000:11:00.0/usb3/3-2/3-2:1.0/input/input15
> [  266.545834] generic-usb 0003:0458:0036.0002: input,hidraw0: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:11:00.0-2/input0
> [  268.694925] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> [  268.694962] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> [  268.694976] hub 4-0:1.0: hub_suspend
> [  268.694994] usb usb4: bus auto-suspend, wakeup 1
> [  283.026404] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  283.026415] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  283.026432] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  283.027185] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  283.027346] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  283.027348] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [  283.027402] xhci_hcd 0000:11:00.0: remove, state 4
> [  283.028119] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  283.028122] usb usb4: USB disconnect, device number 1
> [  283.028841] usb usb4: unregistering device
> [  283.028843] usb usb4: unregistering interface 4-0:1.0
> [  283.028884] usb usb4: usb_disable_device nuking all URBs
> [  283.028893] xHCI xhci_drop_endpoint called for root hub
> [  283.028895] xHCI xhci_check_bandwidth called for root hub
> [  283.028966] xhci_hcd 0000:11:00.0: // Halt the HC
> [  283.028971] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  283.029718] xhci_hcd 0000:11:00.0: USB bus 4 deregistered
> [  283.030455] xhci_hcd 0000:11:00.0: remove, state 1
> [  283.031191] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  283.031193] usb usb3: USB disconnect, device number 1
> [  283.031933] usb 3-2: USB disconnect, device number 2
> [  283.032666] usb 3-2: unregistering device
> [  283.032667] usb 3-2: unregistering interface 3-2:1.0
> [  283.032687] xhci_hcd 0000:11:00.0: HW died, freeing TD.
> [  283.032690] xhci_hcd 0000:11:00.0: shutdown urb ffff8804095c1ec0 ep1in-intr
> [  283.033719] usb 3-2: usb_disable_device nuking all URBs
> [  283.033722] xhci_hcd 0000:11:00.0: xhci_drop_endpoint called for udev ffff88040d5b5000
> [  283.033726] xhci_hcd 0000:11:00.0: drop ep 0x81, slot id 1, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8200000
> [  283.033729] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040d5b5000
> [  283.033731] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  283.033733] xhci_hcd 0000:11:00.0: @ffff88040d4f7000 (virt) @ffffb000 (dma) 0x000008 - drop flags
> [  283.033736] xhci_hcd 0000:11:00.0: @ffff88040d4f7004 (virt) @ffffb004 (dma) 0x000001 - add flags
> [  283.033738] xhci_hcd 0000:11:00.0: @ffff88040d4f7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  283.033740] xhci_hcd 0000:11:00.0: @ffff88040d4f700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  283.033743] xhci_hcd 0000:11:00.0: @ffff88040d4f7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  283.033746] xhci_hcd 0000:11:00.0: @ffff88040d4f7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  283.033749] xhci_hcd 0000:11:00.0: @ffff88040d4f7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  283.033751] xhci_hcd 0000:11:00.0: @ffff88040d4f701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  283.033754] xhci_hcd 0000:11:00.0: Slot Context:
> [  283.033756] xhci_hcd 0000:11:00.0: @ffff88040d4f7020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  283.033758] xhci_hcd 0000:11:00.0: @ffff88040d4f7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  283.033761] xhci_hcd 0000:11:00.0: @ffff88040d4f7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  283.033763] xhci_hcd 0000:11:00.0: @ffff88040d4f702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  283.033766] xhci_hcd 0000:11:00.0: @ffff88040d4f7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  283.033769] xhci_hcd 0000:11:00.0: @ffff88040d4f7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  283.033772] xhci_hcd 0000:11:00.0: @ffff88040d4f7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  283.033774] xhci_hcd 0000:11:00.0: @ffff88040d4f703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  283.033777] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  283.033779] xhci_hcd 0000:11:00.0: @ffff88040d4f7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  283.033782] xhci_hcd 0000:11:00.0: @ffff88040d4f7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  283.033785] xhci_hcd 0000:11:00.0: @ffff88040d4f7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  283.033787] xhci_hcd 0000:11:00.0: @ffff88040d4f7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  283.033790] xhci_hcd 0000:11:00.0: @ffff88040d4f7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  283.033793] xhci_hcd 0000:11:00.0: @ffff88040d4f7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  283.033795] xhci_hcd 0000:11:00.0: @ffff88040d4f705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  283.033798] xhci_hcd 0000:11:00.0: // Ding dong!
> [  326.189273] xhci_hcd 0000:11:00.0: Poll event ring: 4294969952
> [  326.189285] xhci_hcd 0000:11:00.0: op reg status = 0xffffffff
> [  326.189291] xhci_hcd 0000:11:00.0: HW died, polling stopped.
> [  332.959205] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> [  332.960145] usb usb3: unregistering device
> [  332.960148] usb usb3: unregistering interface 3-0:1.0
> [  332.960174] xhci_hcd 0000:11:00.0: shutdown urb ffff88040be18a80 ep1in-intr
> [  332.960188] usb usb3: usb_disable_device nuking all URBs
> [  332.960191] xHCI xhci_drop_endpoint called for root hub
> [  332.960192] xHCI xhci_check_bandwidth called for root hub
> [  332.960266] xhci_hcd 0000:11:00.0: // Halt the HC
> [  332.960271] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  332.961048] xhci_hcd 0000:11:00.0: // Reset the HC
> [  332.961098] xhci_hcd 0000:11:00.0: // Disabling event ring interrupts
> [  332.961102] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set[0]
> [  332.961104] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set.pending = 0xffffffff
> [  332.961107] xhci_hcd 0000:11:00.0:   ffffc90006684624: ir_set.control = 0xffffffff
> [  332.961109] xhci_hcd 0000:11:00.0:   ffffc90006684628: ir_set.erst_size = 0xffffffff
> [  332.961112] xhci_hcd 0000:11:00.0:   WARN: ffffc9000668462c: ir_set.rsvd = 0xffffffff
> [  332.961116] xhci_hcd 0000:11:00.0:   ffffc90006684630: ir_set.erst_base = @ffffffffffffffff
> [  332.961119] xhci_hcd 0000:11:00.0:   ffffc90006684638: ir_set.erst_dequeue = @ffffffffffffffff
> [  332.961121] xhci_hcd 0000:11:00.0: cleaning up memory
> [  332.961126] xhci_hcd 0000:11:00.0: Freed ERST
> [  332.961127] xhci_hcd 0000:11:00.0: Freed event ring
> [  332.961128] xhci_hcd 0000:11:00.0: Freed command ring
> [  332.961131] xhci_hcd 0000:11:00.0: Freed segment pool
> [  332.961134] xhci_hcd 0000:11:00.0: Freed device context pool
> [  332.961135] xhci_hcd 0000:11:00.0: Freed small stream array pool
> [  332.961136] xhci_hcd 0000:11:00.0: Freed medium stream array pool
> [  332.961140] xhci_hcd 0000:11:00.0: xhci_stop completed - status = ffffffff
> [  332.961142] xhci_hcd 0000:11:00.0: USB bus 3 deregistered
> [  441.671044] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  441.671047] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  441.671058] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  441.671174] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  441.671340] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  441.777198] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [  441.777310] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [  441.777361] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [  441.777607] pci 0000:11:00.0: PME# supported from D0 D3hot
> [  441.797231] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [  441.797527] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> [  441.797782] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [  441.798052] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [  441.798335] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [  441.798764] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [  441.799191] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  441.799523] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 3
> [  441.799891] xhci_hcd 0000:11:00.0: xHCI capability registers at ffffc900066f0000:
> [  441.799897] xhci_hcd 0000:11:00.0: CAPLENGTH AND HCIVERSION 0x960020:
> [  441.799899] xhci_hcd 0000:11:00.0: CAPLENGTH: 0x20
> [  441.799900] xhci_hcd 0000:11:00.0: HCIVERSION: 0x96
> [  441.799906] xhci_hcd 0000:11:00.0: HCSPARAMS 1: 0x4000820
> [  441.799907] xhci_hcd 0000:11:00.0:   Max device slots: 32
> [  441.799908] xhci_hcd 0000:11:00.0:   Max interrupters: 8
> [  441.799909] xhci_hcd 0000:11:00.0:   Max ports: 4
> [  441.799915] xhci_hcd 0000:11:00.0: HCSPARAMS 2: 0x11
> [  441.799916] xhci_hcd 0000:11:00.0:   Isoc scheduling threshold: 1
> [  441.799917] xhci_hcd 0000:11:00.0:   Maximum allowed segments in event ring: 1
> [  441.799923] xhci_hcd 0000:11:00.0: HCSPARAMS 3 0x0:
> [  441.799924] xhci_hcd 0000:11:00.0:   Worst case U1 device exit latency: 0
> [  441.799925] xhci_hcd 0000:11:00.0:   Worst case U2 device exit latency: 0
> [  441.799931] xhci_hcd 0000:11:00.0: HCC PARAMS 0x14042cb:
> [  441.799932] xhci_hcd 0000:11:00.0:   HC generates 64 bit addresses
> [  441.799934] xhci_hcd 0000:11:00.0:   FIXME: more HCCPARAMS debugging
> [  441.799939] xhci_hcd 0000:11:00.0: RTSOFF 0x600:
> [  441.799941] xhci_hcd 0000:11:00.0: xHCI operational registers at ffffc900066f0020:
> [  441.799947] xhci_hcd 0000:11:00.0: USBCMD 0x0:
> [  441.799948] xhci_hcd 0000:11:00.0:   HC is being stopped
> [  441.799949] xhci_hcd 0000:11:00.0:   HC has finished hard reset
> [  441.799950] xhci_hcd 0000:11:00.0:   Event Interrupts disabled
> [  441.799951] xhci_hcd 0000:11:00.0:   Host System Error Interrupts disabled
> [  441.799952] xhci_hcd 0000:11:00.0:   HC has finished light reset
> [  441.799958] xhci_hcd 0000:11:00.0: USBSTS 0x11:
> [  441.799959] xhci_hcd 0000:11:00.0:   Event ring is empty
> [  441.799960] xhci_hcd 0000:11:00.0:   No Host System Error
> [  441.799962] xhci_hcd 0000:11:00.0:   HC is halted
> [  441.799968] xhci_hcd 0000:11:00.0: ffffc900066f0420 port status reg = 0x2a0
> [  441.799974] xhci_hcd 0000:11:00.0: ffffc900066f0424 port power reg = 0x0
> [  441.799980] xhci_hcd 0000:11:00.0: ffffc900066f0428 port link reg = 0x0
> [  441.799987] xhci_hcd 0000:11:00.0: ffffc900066f042c port reserved reg = 0x0
> [  441.799993] xhci_hcd 0000:11:00.0: ffffc900066f0430 port status reg = 0x2a0
> [  441.799999] xhci_hcd 0000:11:00.0: ffffc900066f0434 port power reg = 0x0
> [  441.800005] xhci_hcd 0000:11:00.0: ffffc900066f0438 port link reg = 0x0
> [  441.800011] xhci_hcd 0000:11:00.0: ffffc900066f043c port reserved reg = 0x0
> [  441.800017] xhci_hcd 0000:11:00.0: ffffc900066f0440 port status reg = 0x2a0
> [  441.800023] xhci_hcd 0000:11:00.0: ffffc900066f0444 port power reg = 0x0
> [  441.800029] xhci_hcd 0000:11:00.0: ffffc900066f0448 port link reg = 0x0
> [  441.800035] xhci_hcd 0000:11:00.0: ffffc900066f044c port reserved reg = 0x0
> [  441.800041] xhci_hcd 0000:11:00.0: ffffc900066f0450 port status reg = 0x202e1
> [  441.800047] xhci_hcd 0000:11:00.0: ffffc900066f0454 port power reg = 0x0
> [  441.800053] xhci_hcd 0000:11:00.0: ffffc900066f0458 port link reg = 0x0
> [  441.800059] xhci_hcd 0000:11:00.0: ffffc900066f045c port reserved reg = 0x0
> [  441.800061] xhci_hcd 0000:11:00.0: // Halt the HC
> [  441.800073] xhci_hcd 0000:11:00.0: Resetting HCD
> [  441.800079] xhci_hcd 0000:11:00.0: // Reset the HC
> [  441.800129] xhci_hcd 0000:11:00.0: Wait for controller to be ready for doorbell rings
> [  441.800135] xhci_hcd 0000:11:00.0: Reset complete
> [  441.800141] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  441.800142] xhci_hcd 0000:11:00.0: Calling HCD init
> [  441.800143] xhci_hcd 0000:11:00.0: xhci_init
> [  441.800144] xhci_hcd 0000:11:00.0: xHCI doesn't need link TRB QUIRK
> [  441.800150] xhci_hcd 0000:11:00.0: Supported page size register = 0x1
> [  441.800152] xhci_hcd 0000:11:00.0: Supported page size of 4K
> [  441.800153] xhci_hcd 0000:11:00.0: HCD page size set to 4K
> [  441.800159] xhci_hcd 0000:11:00.0: // xHC can handle at most 32 device slots.
> [  441.800165] xhci_hcd 0000:11:00.0: // Setting Max device slots reg = 0x20.
> [  441.800184] xhci_hcd 0000:11:00.0: // Device context base array address = 0xfffff000 (DMA), ffff88040bc42000 (virt)
> [  441.800188] xhci_hcd 0000:11:00.0: Allocated command ring at ffff88040c97f6c0
> [  441.800190] xhci_hcd 0000:11:00.0: First segment DMA is 0xffffe000
> [  441.800199] xhci_hcd 0000:11:00.0: // Setting command ring address to 0x20
> [  441.800209] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  441.800210] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  441.800216] xhci_hcd 0000:11:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
> [  441.800218] xhci_hcd 0000:11:00.0: // xHCI capability registers at ffffc900066f0000:
> [  441.800224] xhci_hcd 0000:11:00.0: // @ffffc900066f0000 = 0x960020 (CAPLENGTH AND HCIVERSION)
> [  441.800225] xhci_hcd 0000:11:00.0: //   CAPLENGTH: 0x20
> [  441.800227] xhci_hcd 0000:11:00.0: // xHCI operational registers at ffffc900066f0020:
> [  441.800233] xhci_hcd 0000:11:00.0: // @ffffc900066f0018 = 0x600 RTSOFF
> [  441.800234] xhci_hcd 0000:11:00.0: // xHCI runtime registers at ffffc900066f0600:
> [  441.800240] xhci_hcd 0000:11:00.0: // @ffffc900066f0014 = 0x800 DBOFF
> [  441.800241] xhci_hcd 0000:11:00.0: // Doorbell array at ffffc900066f0800:
> [  441.800242] xhci_hcd 0000:11:00.0: xHCI runtime registers at ffffc900066f0600:
> [  441.800249] xhci_hcd 0000:11:00.0:   ffffc900066f0600: Microframe index = 0x0
> [  441.800274] xhci_hcd 0000:11:00.0: // Allocating event ring
> [  441.800276] xhci_hcd 0000:11:00.0: TRB math tests passed.
> [  441.800278] xhci_hcd 0000:11:00.0: // Allocated event ring segment table at 0xffffd000
> [  441.800280] xhci_hcd 0000:11:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88040c8c3000, dma addr = 0xffffd000
> [  441.800286] xhci_hcd 0000:11:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [  441.800288] xhci_hcd 0000:11:00.0: // Set ERST entries to point to event ring.
> [  441.800289] xhci_hcd 0000:11:00.0: // Set ERST base address for ir_set 0 = 0xffffd000
> [  441.800305] xhci_hcd 0000:11:00.0: // Write event ring dequeue pointer, preserving EHB bit
> [  441.800306] xhci_hcd 0000:11:00.0: Wrote ERST address to ir_set 0.
> [  441.800311] xhci_hcd 0000:11:00.0: Allocating 0 scratchpad buffers
> [  441.800330] xhci_hcd 0000:11:00.0: Ext Cap ffffc900066f0510, port offset = 1, count = 2, revision = 0x3
> [  441.800339] xhci_hcd 0000:11:00.0: Ext Cap ffffc900066f0520, port offset = 3, count = 2, revision = 0x2
> [  441.800341] xhci_hcd 0000:11:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [  441.800343] xhci_hcd 0000:11:00.0: USB 2.0 port at index 2, addr = ffffc900066f0440
> [  441.800344] xhci_hcd 0000:11:00.0: USB 2.0 port at index 3, addr = ffffc900066f0450
> [  441.800346] xhci_hcd 0000:11:00.0: USB 3.0 port at index 0, addr = ffffc900066f0420
> [  441.800347] xhci_hcd 0000:11:00.0: USB 3.0 port at index 1, addr = ffffc900066f0430
> [  441.800353] xhci_hcd 0000:11:00.0: Finished xhci_init
> [  441.800354] xhci_hcd 0000:11:00.0: Called HCD init
> [  441.800360] xhci_hcd 0000:11:00.0: Got SBRN 48
> [  441.800378] xhci_hcd 0000:11:00.0: MWI active
> [  441.800379] xhci_hcd 0000:11:00.0: Finished xhci_pci_reinit
> [  441.800380] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  441.800391] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [  441.800756] xhci_hcd 0000:11:00.0: xhci_run
> [  441.800860] xhci_hcd 0000:11:00.0: irq 49 for MSI/MSI-X
> [  441.800864] xhci_hcd 0000:11:00.0: irq 50 for MSI/MSI-X
> [  441.800868] xhci_hcd 0000:11:00.0: irq 51 for MSI/MSI-X
> [  441.800872] xhci_hcd 0000:11:00.0: irq 52 for MSI/MSI-X
> [  441.800876] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [  441.800965] xhci_hcd 0000:11:00.0: Setting event ring polling timer
> [  441.800967] xhci_hcd 0000:11:00.0: Command ring memory map follows:
> [  441.800969] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 00000000
> [  441.800971] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00000000
> [  441.800972] xhci_hcd 0000:11:00.0: @00000000ffffe020 00000000 00000000 00000000 00000000
> [  441.800974] xhci_hcd 0000:11:00.0: @00000000ffffe030 00000000 00000000 00000000 00000000
> [  441.800976] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [  441.800977] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [  441.800979] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [  441.800980] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [  441.800982] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [  441.800983] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [  441.800985] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [  441.800987] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [  441.800988] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [  441.800990] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [  441.800991] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [  441.800993] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [  441.800995] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [  441.800996] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [  441.800998] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [  441.800999] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [  441.801001] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [  441.801002] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [  441.801004] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [  441.801006] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [  441.801007] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [  441.801009] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [  441.801010] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [  441.801012] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [  441.801014] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [  441.801015] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [  441.801017] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [  441.801018] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [  441.801020] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [  441.801022] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [  441.801023] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [  441.801025] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [  441.801026] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [  441.801028] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [  441.801029] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [  441.801031] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [  441.801033] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [  441.801034] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [  441.801036] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [  441.801037] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [  441.801039] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [  441.801041] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [  441.801042] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [  441.801044] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [  441.801045] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [  441.801047] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [  441.801048] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [  441.801050] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [  441.801052] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [  441.801053] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [  441.801055] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [  441.801056] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [  441.801058] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [  441.801059] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [  441.801061] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [  441.801063] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [  441.801064] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [  441.801066] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [  441.801067] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [  441.801069] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [  441.801070] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  441.801072] xhci_hcd 0000:11:00.0: Ring deq = ffff88040be24000 (virt), 0xffffe000 (dma)
> [  441.801073] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  441.801075] xhci_hcd 0000:11:00.0: Ring enq = ffff88040be24000 (virt), 0xffffe000 (dma)
> [  441.801076] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  441.801085] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  441.801087] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  441.801088] xhci_hcd 0000:11:00.0: ERST memory map follows:
> [  441.801090] xhci_hcd 0000:11:00.0: @00000000ffffd000 ffffe400 00000000 00000040 00000000
> [  441.801091] xhci_hcd 0000:11:00.0: Event ring:
> [  441.801092] xhci_hcd 0000:11:00.0: @00000000ffffe400 00000000 00000000 00000000 00000000
> [  441.801094] xhci_hcd 0000:11:00.0: @00000000ffffe410 00000000 00000000 00000000 00000000
> [  441.801095] xhci_hcd 0000:11:00.0: @00000000ffffe420 00000000 00000000 00000000 00000000
> [  441.801097] xhci_hcd 0000:11:00.0: @00000000ffffe430 00000000 00000000 00000000 00000000
> [  441.801099] xhci_hcd 0000:11:00.0: @00000000ffffe440 00000000 00000000 00000000 00000000
> [  441.801100] xhci_hcd 0000:11:00.0: @00000000ffffe450 00000000 00000000 00000000 00000000
> [  441.801102] xhci_hcd 0000:11:00.0: @00000000ffffe460 00000000 00000000 00000000 00000000
> [  441.801103] xhci_hcd 0000:11:00.0: @00000000ffffe470 00000000 00000000 00000000 00000000
> [  441.801105] xhci_hcd 0000:11:00.0: @00000000ffffe480 00000000 00000000 00000000 00000000
> [  441.801107] xhci_hcd 0000:11:00.0: @00000000ffffe490 00000000 00000000 00000000 00000000
> [  441.801108] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 00000000 00000000 00000000 00000000
> [  441.801110] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 00000000 00000000 00000000 00000000
> [  441.801111] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 00000000 00000000 00000000 00000000
> [  441.801113] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 00000000 00000000 00000000 00000000
> [  441.801114] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 00000000 00000000 00000000 00000000
> [  441.801116] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 00000000 00000000 00000000 00000000
> [  441.801118] xhci_hcd 0000:11:00.0: @00000000ffffe500 00000000 00000000 00000000 00000000
> [  441.801119] xhci_hcd 0000:11:00.0: @00000000ffffe510 00000000 00000000 00000000 00000000
> [  441.801121] xhci_hcd 0000:11:00.0: @00000000ffffe520 00000000 00000000 00000000 00000000
> [  441.801122] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [  441.801124] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [  441.801126] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [  441.801127] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [  441.801129] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [  441.801130] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [  441.801132] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [  441.801133] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [  441.801135] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [  441.801137] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [  441.801138] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [  441.801140] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [  441.801141] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [  441.801143] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [  441.801145] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [  441.801146] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [  441.801148] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [  441.801149] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [  441.801151] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [  441.801152] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [  441.801154] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [  441.801156] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [  441.801157] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [  441.801159] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [  441.801160] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [  441.801162] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [  441.801163] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [  441.801165] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [  441.801167] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [  441.801168] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [  441.801170] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [  441.801171] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [  441.801173] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [  441.801175] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [  441.801176] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [  441.801178] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [  441.801179] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [  441.801181] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [  441.801182] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [  441.801184] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [  441.801186] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [  441.801187] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [  441.801189] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [  441.801190] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [  441.801192] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [  441.801193] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  441.801195] xhci_hcd 0000:11:00.0: Ring deq = ffff88040be24400 (virt), 0xffffe400 (dma)
> [  441.801196] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  441.801198] xhci_hcd 0000:11:00.0: Ring enq = ffff88040be24400 (virt), 0xffffe400 (dma)
> [  441.801199] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  441.801208] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe400
> [  441.801209] xhci_hcd 0000:11:00.0: // Set the interrupt modulation register
> [  441.801219] xhci_hcd 0000:11:00.0: // Enable interrupts, cmd = 0x4.
> [  441.801226] xhci_hcd 0000:11:00.0: // Enabling event ring interrupter ffffc900066f0620 by writing 0x2 to irq_pending
> [  441.801232] xhci_hcd 0000:11:00.0:   ffffc900066f0620: ir_set[0]
> [  441.801234] xhci_hcd 0000:11:00.0:   ffffc900066f0620: ir_set.pending = 0x2
> [  441.801240] xhci_hcd 0000:11:00.0:   ffffc900066f0624: ir_set.control = 0xa0
> [  441.801246] xhci_hcd 0000:11:00.0:   ffffc900066f0628: ir_set.erst_size = 0x1
> [  441.801258] xhci_hcd 0000:11:00.0:   ffffc900066f0630: ir_set.erst_base = @ffffd000
> [  441.801268] xhci_hcd 0000:11:00.0:   ffffc900066f0638: ir_set.erst_dequeue = @ffffe400
> [  441.801269] xhci_hcd 0000:11:00.0: Finished xhci_run for USB2 roothub
> [  441.801279] usb usb3: default language 0x0409
> [  441.801284] usb usb3: udev 1, busnum 3, minor = 256
> [  441.801285] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [  441.801677] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  441.802073] usb usb3: Product: xHCI Host Controller
> [  441.802471] usb usb3: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  441.802892] usb usb3: SerialNumber: 0000:11:00.0
> [  441.803420] usb usb3: usb_probe_device
> [  441.803424] usb usb3: configuration #1 chosen from 1 choice
> [  441.803427] xHCI xhci_add_endpoint called for root hub
> [  441.803429] xHCI xhci_check_bandwidth called for root hub
> [  441.803435] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [  441.803470] hub 3-0:1.0: usb_probe_interface
> [  441.803472] hub 3-0:1.0: usb_probe_interface - got id
> [  441.803474] hub 3-0:1.0: USB hub found
> [  441.803953] hub 3-0:1.0: 2 ports detected
> [  441.804422] hub 3-0:1.0: standalone hub
> [  441.804423] hub 3-0:1.0: individual port power switching
> [  441.804424] hub 3-0:1.0: individual port over-current protection
> [  441.804425] hub 3-0:1.0: Single TT
> [  441.804426] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  441.804428] hub 3-0:1.0: power on to power good time: 20ms
> [  441.804431] hub 3-0:1.0: local power source is good
> [  441.804432] hub 3-0:1.0: enabling power on all ports
> [  441.804442] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  441.804455] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  441.804499] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  441.805024] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 4
> [  441.805680] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  441.805682] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  441.805688] xhci_hcd 0000:11:00.0: // Turn on HC, cmd = 0x5.
> [  441.805706] xhci_hcd 0000:11:00.0: // Ding dong!
> [  441.805712] xhci_hcd 0000:11:00.0: Finished xhci_run for USB3 roothub
> [  441.805718] usb usb4: skipped 1 descriptor after endpoint
> [  441.805720] usb usb4: default language 0x0409
> [  441.805724] usb usb4: udev 1, busnum 4, minor = 384
> [  441.805726] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [  441.806368] xhci_hcd 0000:11:00.0: Vendor specific event TRB type = 48
> [  441.806370] xhci_hcd 0000:11:00.0: NEC firmware version 30.28
> [  441.806389] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  441.807078] usb usb4: Product: xHCI Host Controller
> [  441.807814] usb usb4: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  441.807816] usb usb4: SerialNumber: 0000:11:00.0
> [  441.807906] usb usb4: usb_probe_device
> [  441.807908] usb usb4: configuration #1 chosen from 1 choice
> [  441.807911] xHCI xhci_add_endpoint called for root hub
> [  441.807913] xHCI xhci_check_bandwidth called for root hub
> [  441.807920] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [  441.807951] hub 4-0:1.0: usb_probe_interface
> [  441.807952] hub 4-0:1.0: usb_probe_interface - got id
> [  441.807955] hub 4-0:1.0: USB hub found
> [  441.807973] hub 4-0:1.0: 2 ports detected
> [  441.807975] hub 4-0:1.0: standalone hub
> [  441.807976] hub 4-0:1.0: individual port power switching
> [  441.807977] hub 4-0:1.0: individual port over-current protection
> [  441.807979] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  441.807981] hub 4-0:1.0: power on to power good time: 20ms
> [  441.807985] hub 4-0:1.0: local power source is good
> [  441.807986] hub 4-0:1.0: enabling power on all ports
> [  441.808004] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  441.808028] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  441.859122] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  441.896943] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  441.896947] xhci_hcd 0000:11:00.0: Get port status returned 0x100
> [  441.896963] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x202e1
> [  441.896965] xhci_hcd 0000:11:00.0: Get port status returned 0x10101
> [  441.896968] hub 3-0:1.0: port 2: status 0101 change 0001
> [  441.896980] xhci_hcd 0000:11:00.0: clear port connect change, actual port 1 status  = 0x2e1
> [  441.906923] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  441.906926] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  441.906935] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2a0
> [  441.906937] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  441.906956] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [  441.996794] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [  441.996804] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2e1
> [  441.996806] xhci_hcd 0000:11:00.0: Get port status returned 0x101
> [  441.996810] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [  441.996814] xhci_hcd 0000:11:00.0: // Ding dong!
> [  441.996873] xhci_hcd 0000:11:00.0: Slot 1 output ctx = 0xffffc000 (dma)
> [  441.996877] xhci_hcd 0000:11:00.0: Slot 1 input ctx = 0xffffb000 (dma)
> [  441.996882] xhci_hcd 0000:11:00.0: Set slot id 1 dcbaa entry ffff88040bc42008 to 0xffffc000
> [  441.996896] xhci_hcd 0000:11:00.0: set port reset, actual port 1 status  = 0x331
> [  442.046845] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  442.056743] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x200a03
> [  442.056753] xhci_hcd 0000:11:00.0: Get port status returned 0x100303
> [  442.116719] xhci_hcd 0000:11:00.0: clear port reset change, actual port 1 status  = 0xa03
> [  442.116738] usb 3-2: new low-speed USB device number 2 using xhci_hcd
> [  442.117525] xhci_hcd 0000:11:00.0: Set root hub portnum to 4
> [  442.117527] xhci_hcd 0000:11:00.0: Set fake root hub portnum to 2
> [  442.117528] xhci_hcd 0000:11:00.0: udev->tt = ffff88040c8a0c98
> [  442.117529] xhci_hcd 0000:11:00.0: udev->ttport = 0x2
> [  442.117531] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  442.117533] xhci_hcd 0000:11:00.0: @ffff88040ee10000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  442.117534] xhci_hcd 0000:11:00.0: @ffff88040ee10004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  442.117536] xhci_hcd 0000:11:00.0: @ffff88040ee10008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  442.117538] xhci_hcd 0000:11:00.0: @ffff88040ee1000c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  442.117539] xhci_hcd 0000:11:00.0: @ffff88040ee10010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  442.117541] xhci_hcd 0000:11:00.0: @ffff88040ee10014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  442.117543] xhci_hcd 0000:11:00.0: @ffff88040ee10018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  442.117544] xhci_hcd 0000:11:00.0: @ffff88040ee1001c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  442.117546] xhci_hcd 0000:11:00.0: Slot Context:
> [  442.117547] xhci_hcd 0000:11:00.0: @ffff88040ee10020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  442.117549] xhci_hcd 0000:11:00.0: @ffff88040ee10024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  442.117550] xhci_hcd 0000:11:00.0: @ffff88040ee10028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  442.117552] xhci_hcd 0000:11:00.0: @ffff88040ee1002c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  442.117554] xhci_hcd 0000:11:00.0: @ffff88040ee10030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  442.117555] xhci_hcd 0000:11:00.0: @ffff88040ee10034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  442.117557] xhci_hcd 0000:11:00.0: @ffff88040ee10038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  442.117559] xhci_hcd 0000:11:00.0: @ffff88040ee1003c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  442.117560] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  442.117561] xhci_hcd 0000:11:00.0: @ffff88040ee10040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  442.117563] xhci_hcd 0000:11:00.0: @ffff88040ee10044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  442.117565] xhci_hcd 0000:11:00.0: @ffff88040ee10048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  442.117566] xhci_hcd 0000:11:00.0: @ffff88040ee10050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  442.117568] xhci_hcd 0000:11:00.0: @ffff88040ee10054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  442.117569] xhci_hcd 0000:11:00.0: @ffff88040ee10058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  442.117571] xhci_hcd 0000:11:00.0: @ffff88040ee1005c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  442.117573] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  442.117574] xhci_hcd 0000:11:00.0: @ffff88040ee10060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  442.117575] xhci_hcd 0000:11:00.0: @ffff88040ee10064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  442.117577] xhci_hcd 0000:11:00.0: @ffff88040ee10068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  442.117579] xhci_hcd 0000:11:00.0: @ffff88040ee10070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  442.117580] xhci_hcd 0000:11:00.0: @ffff88040ee10074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  442.117582] xhci_hcd 0000:11:00.0: @ffff88040ee10078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  442.117584] xhci_hcd 0000:11:00.0: @ffff88040ee1007c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  442.117585] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  442.117586] xhci_hcd 0000:11:00.0: @ffff88040ee10080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  442.117588] xhci_hcd 0000:11:00.0: @ffff88040ee10084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  442.117589] xhci_hcd 0000:11:00.0: @ffff88040ee10088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  442.117591] xhci_hcd 0000:11:00.0: @ffff88040ee10090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  442.117593] xhci_hcd 0000:11:00.0: @ffff88040ee10094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  442.117594] xhci_hcd 0000:11:00.0: @ffff88040ee10098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  442.117596] xhci_hcd 0000:11:00.0: @ffff88040ee1009c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  442.117598] xhci_hcd 0000:11:00.0: // Ding dong!
> [  442.118403] xhci_hcd 0000:11:00.0: Successful Address Device command
> [  442.118423] xhci_hcd 0000:11:00.0: Op regs DCBAA ptr = 0x000000fffff000
> [  442.118431] xhci_hcd 0000:11:00.0: Slot ID 1 dcbaa entry @ffff88040bc42008 = 0x000000ffffc000
> [  442.118439] xhci_hcd 0000:11:00.0: Output Context DMA address = 0xffffc000
> [  442.118444] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  442.118452] xhci_hcd 0000:11:00.0: @ffff88040ee10000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  442.118460] xhci_hcd 0000:11:00.0: @ffff88040ee10004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  442.118468] xhci_hcd 0000:11:00.0: @ffff88040ee10008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  442.118475] xhci_hcd 0000:11:00.0: @ffff88040ee1000c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  442.118482] xhci_hcd 0000:11:00.0: @ffff88040ee10010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  442.118489] xhci_hcd 0000:11:00.0: @ffff88040ee10014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  442.118497] xhci_hcd 0000:11:00.0: @ffff88040ee10018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  442.118504] xhci_hcd 0000:11:00.0: @ffff88040ee1001c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  442.118510] xhci_hcd 0000:11:00.0: Slot Context:
> [  442.118516] xhci_hcd 0000:11:00.0: @ffff88040ee10020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  442.118524] xhci_hcd 0000:11:00.0: @ffff88040ee10024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  442.118537] xhci_hcd 0000:11:00.0: @ffff88040ee10028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  442.118538] xhci_hcd 0000:11:00.0: @ffff88040ee1002c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  442.118540] xhci_hcd 0000:11:00.0: @ffff88040ee10030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  442.118541] xhci_hcd 0000:11:00.0: @ffff88040ee10034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  442.118543] xhci_hcd 0000:11:00.0: @ffff88040ee10038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  442.118545] xhci_hcd 0000:11:00.0: @ffff88040ee1003c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  442.118546] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  442.118548] xhci_hcd 0000:11:00.0: @ffff88040ee10040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  442.118549] xhci_hcd 0000:11:00.0: @ffff88040ee10044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  442.118551] xhci_hcd 0000:11:00.0: @ffff88040ee10048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  442.118552] xhci_hcd 0000:11:00.0: @ffff88040ee10050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  442.118554] xhci_hcd 0000:11:00.0: @ffff88040ee10054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  442.118556] xhci_hcd 0000:11:00.0: @ffff88040ee10058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  442.118557] xhci_hcd 0000:11:00.0: @ffff88040ee1005c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  442.118559] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  442.118560] xhci_hcd 0000:11:00.0: @ffff88040ee10060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  442.118562] xhci_hcd 0000:11:00.0: @ffff88040ee10064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  442.118563] xhci_hcd 0000:11:00.0: @ffff88040ee10068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  442.118565] xhci_hcd 0000:11:00.0: @ffff88040ee10070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  442.118567] xhci_hcd 0000:11:00.0: @ffff88040ee10074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  442.118568] xhci_hcd 0000:11:00.0: @ffff88040ee10078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  442.118570] xhci_hcd 0000:11:00.0: @ffff88040ee1007c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  442.118571] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  442.118573] xhci_hcd 0000:11:00.0: @ffff88040ee10080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  442.118574] xhci_hcd 0000:11:00.0: @ffff88040ee10084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  442.118576] xhci_hcd 0000:11:00.0: @ffff88040ee10088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  442.118577] xhci_hcd 0000:11:00.0: @ffff88040ee10090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  442.118579] xhci_hcd 0000:11:00.0: @ffff88040ee10094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  442.118581] xhci_hcd 0000:11:00.0: @ffff88040ee10098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  442.118582] xhci_hcd 0000:11:00.0: @ffff88040ee1009c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  442.118584] xhci_hcd 0000:11:00.0: Slot ID 1 Output Context:
> [  442.118585] xhci_hcd 0000:11:00.0: Slot Context:
> [  442.118586] xhci_hcd 0000:11:00.0: @ffff88040ae9d000 (virt) @ffffc000 (dma) 0x8200000 - dev_info
> [  442.118588] xhci_hcd 0000:11:00.0: @ffff88040ae9d004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  442.118590] xhci_hcd 0000:11:00.0: @ffff88040ae9d008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  442.118591] xhci_hcd 0000:11:00.0: @ffff88040ae9d00c (virt) @ffffc00c (dma) 0x10000001 - dev_state
> [  442.118593] xhci_hcd 0000:11:00.0: @ffff88040ae9d010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  442.118595] xhci_hcd 0000:11:00.0: @ffff88040ae9d014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  442.118596] xhci_hcd 0000:11:00.0: @ffff88040ae9d018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  442.118598] xhci_hcd 0000:11:00.0: @ffff88040ae9d01c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  442.118599] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  442.118601] xhci_hcd 0000:11:00.0: @ffff88040ae9d020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  442.118602] xhci_hcd 0000:11:00.0: @ffff88040ae9d024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  442.118604] xhci_hcd 0000:11:00.0: @ffff88040ae9d028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  442.118605] xhci_hcd 0000:11:00.0: @ffff88040ae9d030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  442.118607] xhci_hcd 0000:11:00.0: @ffff88040ae9d034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  442.118609] xhci_hcd 0000:11:00.0: @ffff88040ae9d038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  442.118610] xhci_hcd 0000:11:00.0: @ffff88040ae9d03c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  442.118612] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  442.118613] xhci_hcd 0000:11:00.0: @ffff88040ae9d040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  442.118615] xhci_hcd 0000:11:00.0: @ffff88040ae9d044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  442.118616] xhci_hcd 0000:11:00.0: @ffff88040ae9d048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  442.118618] xhci_hcd 0000:11:00.0: @ffff88040ae9d050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  442.118619] xhci_hcd 0000:11:00.0: @ffff88040ae9d054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  442.118621] xhci_hcd 0000:11:00.0: @ffff88040ae9d058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  442.118623] xhci_hcd 0000:11:00.0: @ffff88040ae9d05c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  442.118624] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  442.118626] xhci_hcd 0000:11:00.0: @ffff88040ae9d060 (virt) @ffffc060 (dma) 0x000000 - ep_info
> [  442.118627] xhci_hcd 0000:11:00.0: @ffff88040ae9d064 (virt) @ffffc064 (dma) 0x000000 - ep_info2
> [  442.118629] xhci_hcd 0000:11:00.0: @ffff88040ae9d068 (virt) @ffffc068 (dma) 0x000000 - deq
> [  442.118630] xhci_hcd 0000:11:00.0: @ffff88040ae9d070 (virt) @ffffc070 (dma) 0x000000 - tx_info
> [  442.118632] xhci_hcd 0000:11:00.0: @ffff88040ae9d074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  442.118633] xhci_hcd 0000:11:00.0: @ffff88040ae9d078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  442.118635] xhci_hcd 0000:11:00.0: @ffff88040ae9d07c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  442.118637] xhci_hcd 0000:11:00.0: Internal device address = 2
> [  442.155258] usb 3-2: skipped 1 descriptor after interface
> [  442.157262] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  442.158267] usb 3-2: default language 0x0409
> [  442.166246] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  442.170260] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  442.171253] usb 3-2: udev 2, busnum 3, minor = 257
> [  442.171255] usb 3-2: New USB device found, idVendor=0458, idProduct=0036
> [  442.171256] usb 3-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> [  442.171258] usb 3-2: Product: NetScroll + Mini Traveler
> [  442.171259] usb 3-2: Manufacturer: Genius
> [  442.171331] usb 3-2: usb_probe_device
> [  442.171334] usb 3-2: configuration #1 chosen from 1 choice
> [  442.171340] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
> [  442.171343] xhci_hcd 0000:11:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18200000
> [  442.171345] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040c8eb800
> [  442.171347] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  442.171350] xhci_hcd 0000:11:00.0: @ffff88040ee10000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  442.171352] xhci_hcd 0000:11:00.0: @ffff88040ee10004 (virt) @ffffb004 (dma) 0x000009 - add flags
> [  442.171354] xhci_hcd 0000:11:00.0: @ffff88040ee10008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  442.171356] xhci_hcd 0000:11:00.0: @ffff88040ee1000c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  442.171358] xhci_hcd 0000:11:00.0: @ffff88040ee10010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  442.171360] xhci_hcd 0000:11:00.0: @ffff88040ee10014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  442.171362] xhci_hcd 0000:11:00.0: @ffff88040ee10018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  442.171364] xhci_hcd 0000:11:00.0: @ffff88040ee1001c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  442.171366] xhci_hcd 0000:11:00.0: Slot Context:
> [  442.171367] xhci_hcd 0000:11:00.0: @ffff88040ee10020 (virt) @ffffb020 (dma) 0x18200000 - dev_info
> [  442.171369] xhci_hcd 0000:11:00.0: @ffff88040ee10024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  442.171372] xhci_hcd 0000:11:00.0: @ffff88040ee10028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  442.171373] xhci_hcd 0000:11:00.0: @ffff88040ee1002c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  442.171375] xhci_hcd 0000:11:00.0: @ffff88040ee10030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  442.171377] xhci_hcd 0000:11:00.0: @ffff88040ee10034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  442.171379] xhci_hcd 0000:11:00.0: @ffff88040ee10038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  442.171382] xhci_hcd 0000:11:00.0: @ffff88040ee1003c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  442.171383] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  442.171385] xhci_hcd 0000:11:00.0: @ffff88040ee10040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  442.171388] xhci_hcd 0000:11:00.0: @ffff88040ee10044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  442.171390] xhci_hcd 0000:11:00.0: @ffff88040ee10048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  442.171391] xhci_hcd 0000:11:00.0: @ffff88040ee10050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  442.171393] xhci_hcd 0000:11:00.0: @ffff88040ee10054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  442.171394] xhci_hcd 0000:11:00.0: @ffff88040ee10058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  442.171396] xhci_hcd 0000:11:00.0: @ffff88040ee1005c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  442.171397] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  442.171398] xhci_hcd 0000:11:00.0: @ffff88040ee10060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  442.171400] xhci_hcd 0000:11:00.0: @ffff88040ee10064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  442.171401] xhci_hcd 0000:11:00.0: @ffff88040ee10068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  442.171403] xhci_hcd 0000:11:00.0: @ffff88040ee10070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  442.171404] xhci_hcd 0000:11:00.0: @ffff88040ee10074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  442.171406] xhci_hcd 0000:11:00.0: @ffff88040ee10078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  442.171408] xhci_hcd 0000:11:00.0: @ffff88040ee1007c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  442.171409] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  442.171410] xhci_hcd 0000:11:00.0: @ffff88040ee10080 (virt) @ffffb080 (dma) 0x060000 - ep_info
> [  442.171412] xhci_hcd 0000:11:00.0: @ffff88040ee10084 (virt) @ffffb084 (dma) 0x04003e - ep_info2
> [  442.171413] xhci_hcd 0000:11:00.0: @ffff88040ee10088 (virt) @ffffb088 (dma) 0xffffa401 - deq
> [  442.171415] xhci_hcd 0000:11:00.0: @ffff88040ee10090 (virt) @ffffb090 (dma) 0x040004 - tx_info
> [  442.171416] xhci_hcd 0000:11:00.0: @ffff88040ee10094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  442.171418] xhci_hcd 0000:11:00.0: @ffff88040ee10098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  442.171419] xhci_hcd 0000:11:00.0: @ffff88040ee1009c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  442.171421] xhci_hcd 0000:11:00.0: // Ding dong!
> [  442.171655] xhci_hcd 0000:11:00.0: Completed config ep cmd
> [  442.171669] usb 3-2: Successful Endpoint Configure command
> [  442.171671] xhci_hcd 0000:11:00.0: Output context after successful config ep cmd:
> [  442.171672] xhci_hcd 0000:11:00.0: Slot Context:
> [  442.171674] xhci_hcd 0000:11:00.0: @ffff88040ae9d000 (virt) @ffffc000 (dma) 0x18200000 - dev_info
> [  442.171675] xhci_hcd 0000:11:00.0: @ffff88040ae9d004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  442.171677] xhci_hcd 0000:11:00.0: @ffff88040ae9d008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  442.171679] xhci_hcd 0000:11:00.0: @ffff88040ae9d00c (virt) @ffffc00c (dma) 0x18000001 - dev_state
> [  442.171680] xhci_hcd 0000:11:00.0: @ffff88040ae9d010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  442.171682] xhci_hcd 0000:11:00.0: @ffff88040ae9d014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  442.171684] xhci_hcd 0000:11:00.0: @ffff88040ae9d018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  442.171685] xhci_hcd 0000:11:00.0: @ffff88040ae9d01c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  442.171687] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  442.171688] xhci_hcd 0000:11:00.0: @ffff88040ae9d020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  442.171689] xhci_hcd 0000:11:00.0: @ffff88040ae9d024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  442.171691] xhci_hcd 0000:11:00.0: @ffff88040ae9d028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  442.171693] xhci_hcd 0000:11:00.0: @ffff88040ae9d030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  442.171694] xhci_hcd 0000:11:00.0: @ffff88040ae9d034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  442.171696] xhci_hcd 0000:11:00.0: @ffff88040ae9d038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  442.171697] xhci_hcd 0000:11:00.0: @ffff88040ae9d03c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  442.171699] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  442.171700] xhci_hcd 0000:11:00.0: @ffff88040ae9d040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  442.171701] xhci_hcd 0000:11:00.0: @ffff88040ae9d044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  442.171703] xhci_hcd 0000:11:00.0: @ffff88040ae9d048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  442.171704] xhci_hcd 0000:11:00.0: @ffff88040ae9d050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  442.171706] xhci_hcd 0000:11:00.0: @ffff88040ae9d054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  442.171707] xhci_hcd 0000:11:00.0: @ffff88040ae9d058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  442.171709] xhci_hcd 0000:11:00.0: @ffff88040ae9d05c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  442.171710] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  442.171711] xhci_hcd 0000:11:00.0: @ffff88040ae9d060 (virt) @ffffc060 (dma) 0x060001 - ep_info
> [  442.171713] xhci_hcd 0000:11:00.0: @ffff88040ae9d064 (virt) @ffffc064 (dma) 0x04003e - ep_info2
> [  442.171714] xhci_hcd 0000:11:00.0: @ffff88040ae9d068 (virt) @ffffc068 (dma) 0xffffa401 - deq
> [  442.171716] xhci_hcd 0000:11:00.0: @ffff88040ae9d070 (virt) @ffffc070 (dma) 0x040004 - tx_info
> [  442.171718] xhci_hcd 0000:11:00.0: @ffff88040ae9d074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  442.171719] xhci_hcd 0000:11:00.0: @ffff88040ae9d078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  442.171721] xhci_hcd 0000:11:00.0: @ffff88040ae9d07c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  442.173244] xhci_hcd 0000:11:00.0: Endpoint 0x81 not halted, refusing to reset.
> [  442.173248] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> [  442.173272] usbserial_generic 3-2:1.0: usb_probe_interface
> [  442.173274] usbserial_generic 3-2:1.0: usb_probe_interface - got id
> [  442.173285] usbhid 3-2:1.0: usb_probe_interface
> [  442.173287] usbhid 3-2:1.0: usb_probe_interface - got id
> [  442.184308] input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1c.7/0000:11:00.0/usb3/3-2/3-2:1.0/input/input16
> [  442.184384] generic-usb 0003:0458:0036.0003: input,hidraw0: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:11:00.0-2/input0
> [  444.473225] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> [  444.473261] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> [  444.473275] hub 4-0:1.0: hub_suspend
> [  444.473290] usb usb4: bus auto-suspend, wakeup 1
> [  478.391949] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  478.391960] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  478.391975] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  478.392739] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  478.392905] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  478.392907] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [  478.392958] xhci_hcd 0000:11:00.0: remove, state 4
> [  478.393679] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  478.393682] usb usb4: USB disconnect, device number 1
> [  478.394407] usb usb4: unregistering device
> [  478.394409] usb usb4: unregistering interface 4-0:1.0
> [  478.394449] usb usb4: usb_disable_device nuking all URBs
> [  478.394459] xHCI xhci_drop_endpoint called for root hub
> [  478.394460] xHCI xhci_check_bandwidth called for root hub
> [  478.394561] xhci_hcd 0000:11:00.0: // Halt the HC
> [  478.394567] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  478.395388] xhci_hcd 0000:11:00.0: USB bus 4 deregistered
> [  478.396129] xhci_hcd 0000:11:00.0: remove, state 1
> [  478.396863] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  478.396865] usb usb3: USB disconnect, device number 1
> [  478.397605] usb 3-2: USB disconnect, device number 2
> [  478.398349] usb 3-2: unregistering device
> [  478.398351] usb 3-2: unregistering interface 3-2:1.0
> [  478.398373] xhci_hcd 0000:11:00.0: HW died, freeing TD.
> [  478.398376] xhci_hcd 0000:11:00.0: shutdown urb ffff88040ac5fb40 ep1in-intr
> [  478.412700] usb 3-2: usb_disable_device nuking all URBs
> [  478.412704] xhci_hcd 0000:11:00.0: xhci_drop_endpoint called for udev ffff88040c8eb800
> [  478.412708] xhci_hcd 0000:11:00.0: drop ep 0x81, slot id 1, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8200000
> [  478.412711] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040c8eb800
> [  478.412712] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  478.412715] xhci_hcd 0000:11:00.0: @ffff88040ee10000 (virt) @ffffb000 (dma) 0x000008 - drop flags
> [  478.412717] xhci_hcd 0000:11:00.0: @ffff88040ee10004 (virt) @ffffb004 (dma) 0x000001 - add flags
> [  478.412719] xhci_hcd 0000:11:00.0: @ffff88040ee10008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  478.412722] xhci_hcd 0000:11:00.0: @ffff88040ee1000c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  478.412724] xhci_hcd 0000:11:00.0: @ffff88040ee10010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  478.412727] xhci_hcd 0000:11:00.0: @ffff88040ee10014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  478.412729] xhci_hcd 0000:11:00.0: @ffff88040ee10018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  478.412731] xhci_hcd 0000:11:00.0: @ffff88040ee1001c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  478.412733] xhci_hcd 0000:11:00.0: Slot Context:
> [  478.412735] xhci_hcd 0000:11:00.0: @ffff88040ee10020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  478.412737] xhci_hcd 0000:11:00.0: @ffff88040ee10024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  478.412739] xhci_hcd 0000:11:00.0: @ffff88040ee10028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  478.412741] xhci_hcd 0000:11:00.0: @ffff88040ee1002c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  478.412743] xhci_hcd 0000:11:00.0: @ffff88040ee10030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  478.412745] xhci_hcd 0000:11:00.0: @ffff88040ee10034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  478.412747] xhci_hcd 0000:11:00.0: @ffff88040ee10038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  478.412749] xhci_hcd 0000:11:00.0: @ffff88040ee1003c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  478.412751] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  478.412753] xhci_hcd 0000:11:00.0: @ffff88040ee10040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  478.412755] xhci_hcd 0000:11:00.0: @ffff88040ee10044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  478.412757] xhci_hcd 0000:11:00.0: @ffff88040ee10048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  478.412760] xhci_hcd 0000:11:00.0: @ffff88040ee10050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  478.412762] xhci_hcd 0000:11:00.0: @ffff88040ee10054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  478.412765] xhci_hcd 0000:11:00.0: @ffff88040ee10058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  478.412767] xhci_hcd 0000:11:00.0: @ffff88040ee1005c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  478.412770] xhci_hcd 0000:11:00.0: // Ding dong!
> [  501.927624] xhci_hcd 0000:11:00.0: Poll event ring: 4294987552
> [  501.927635] xhci_hcd 0000:11:00.0: op reg status = 0xffffffff
> [  501.927640] xhci_hcd 0000:11:00.0: HW died, polling stopped.
> [  528.338323] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> [  528.339286] usb usb3: unregistering device
> [  528.339289] usb usb3: unregistering interface 3-0:1.0
> [  528.339316] xhci_hcd 0000:11:00.0: shutdown urb ffff88040ad08240 ep1in-intr
> [  528.339331] usb usb3: usb_disable_device nuking all URBs
> [  528.339333] xHCI xhci_drop_endpoint called for root hub
> [  528.339335] xHCI xhci_check_bandwidth called for root hub
> [  528.339409] xhci_hcd 0000:11:00.0: // Halt the HC
> [  528.339414] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  528.340200] xhci_hcd 0000:11:00.0: // Reset the HC
> [  528.340250] xhci_hcd 0000:11:00.0: // Disabling event ring interrupts
> [  528.340254] xhci_hcd 0000:11:00.0:   ffffc900066f0620: ir_set[0]
> [  528.340256] xhci_hcd 0000:11:00.0:   ffffc900066f0620: ir_set.pending = 0xffffffff
> [  528.340259] xhci_hcd 0000:11:00.0:   ffffc900066f0624: ir_set.control = 0xffffffff
> [  528.340261] xhci_hcd 0000:11:00.0:   ffffc900066f0628: ir_set.erst_size = 0xffffffff
> [  528.340264] xhci_hcd 0000:11:00.0:   WARN: ffffc900066f062c: ir_set.rsvd = 0xffffffff
> [  528.340268] xhci_hcd 0000:11:00.0:   ffffc900066f0630: ir_set.erst_base = @ffffffffffffffff
> [  528.340272] xhci_hcd 0000:11:00.0:   ffffc900066f0638: ir_set.erst_dequeue = @ffffffffffffffff
> [  528.340273] xhci_hcd 0000:11:00.0: cleaning up memory
> [  528.340277] xhci_hcd 0000:11:00.0: Freed ERST
> [  528.340278] xhci_hcd 0000:11:00.0: Freed event ring
> [  528.340279] xhci_hcd 0000:11:00.0: Freed command ring
> [  528.340283] xhci_hcd 0000:11:00.0: Freed segment pool
> [  528.340285] xhci_hcd 0000:11:00.0: Freed device context pool
> [  528.340286] xhci_hcd 0000:11:00.0: Freed small stream array pool
> [  528.340287] xhci_hcd 0000:11:00.0: Freed medium stream array pool
> [  528.340291] xhci_hcd 0000:11:00.0: xhci_stop completed - status = ffffffff
> [  528.340293] xhci_hcd 0000:11:00.0: USB bus 3 deregistered
> [  644.488998] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  644.489001] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  644.489011] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  644.489408] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  644.489575] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  644.595227] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [  644.595337] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [  644.595386] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [  644.595629] pci 0000:11:00.0: PME# supported from D0 D3hot
> [  644.615261] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [  644.615716] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> [  644.616117] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [  644.616527] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [  644.616942] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [  644.617480] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [  644.618020] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  644.618450] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 3
> [  644.618903] xhci_hcd 0000:11:00.0: xHCI capability registers at ffffc90006684000:
> [  644.618910] xhci_hcd 0000:11:00.0: CAPLENGTH AND HCIVERSION 0x960020:
> [  644.618911] xhci_hcd 0000:11:00.0: CAPLENGTH: 0x20
> [  644.618912] xhci_hcd 0000:11:00.0: HCIVERSION: 0x96
> [  644.618918] xhci_hcd 0000:11:00.0: HCSPARAMS 1: 0x4000820
> [  644.618919] xhci_hcd 0000:11:00.0:   Max device slots: 32
> [  644.618920] xhci_hcd 0000:11:00.0:   Max interrupters: 8
> [  644.618921] xhci_hcd 0000:11:00.0:   Max ports: 4
> [  644.618927] xhci_hcd 0000:11:00.0: HCSPARAMS 2: 0x11
> [  644.618928] xhci_hcd 0000:11:00.0:   Isoc scheduling threshold: 1
> [  644.618929] xhci_hcd 0000:11:00.0:   Maximum allowed segments in event ring: 1
> [  644.618935] xhci_hcd 0000:11:00.0: HCSPARAMS 3 0x0:
> [  644.618936] xhci_hcd 0000:11:00.0:   Worst case U1 device exit latency: 0
> [  644.618937] xhci_hcd 0000:11:00.0:   Worst case U2 device exit latency: 0
> [  644.618943] xhci_hcd 0000:11:00.0: HCC PARAMS 0x14042cb:
> [  644.618944] xhci_hcd 0000:11:00.0:   HC generates 64 bit addresses
> [  644.618946] xhci_hcd 0000:11:00.0:   FIXME: more HCCPARAMS debugging
> [  644.618951] xhci_hcd 0000:11:00.0: RTSOFF 0x600:
> [  644.618953] xhci_hcd 0000:11:00.0: xHCI operational registers at ffffc90006684020:
> [  644.618959] xhci_hcd 0000:11:00.0: USBCMD 0x0:
> [  644.618960] xhci_hcd 0000:11:00.0:   HC is being stopped
> [  644.618961] xhci_hcd 0000:11:00.0:   HC has finished hard reset
> [  644.618962] xhci_hcd 0000:11:00.0:   Event Interrupts disabled
> [  644.618963] xhci_hcd 0000:11:00.0:   Host System Error Interrupts disabled
> [  644.618965] xhci_hcd 0000:11:00.0:   HC has finished light reset
> [  644.618970] xhci_hcd 0000:11:00.0: USBSTS 0x11:
> [  644.618971] xhci_hcd 0000:11:00.0:   Event ring is empty
> [  644.618973] xhci_hcd 0000:11:00.0:   No Host System Error
> [  644.618974] xhci_hcd 0000:11:00.0:   HC is halted
> [  644.618980] xhci_hcd 0000:11:00.0: ffffc90006684420 port status reg = 0x2a0
> [  644.618986] xhci_hcd 0000:11:00.0: ffffc90006684424 port power reg = 0x0
> [  644.618992] xhci_hcd 0000:11:00.0: ffffc90006684428 port link reg = 0x0
> [  644.618999] xhci_hcd 0000:11:00.0: ffffc9000668442c port reserved reg = 0x0
> [  644.619005] xhci_hcd 0000:11:00.0: ffffc90006684430 port status reg = 0x2a0
> [  644.619011] xhci_hcd 0000:11:00.0: ffffc90006684434 port power reg = 0x0
> [  644.619017] xhci_hcd 0000:11:00.0: ffffc90006684438 port link reg = 0x0
> [  644.619023] xhci_hcd 0000:11:00.0: ffffc9000668443c port reserved reg = 0x0
> [  644.619029] xhci_hcd 0000:11:00.0: ffffc90006684440 port status reg = 0x2a0
> [  644.619035] xhci_hcd 0000:11:00.0: ffffc90006684444 port power reg = 0x0
> [  644.619041] xhci_hcd 0000:11:00.0: ffffc90006684448 port link reg = 0x0
> [  644.619047] xhci_hcd 0000:11:00.0: ffffc9000668444c port reserved reg = 0x0
> [  644.619053] xhci_hcd 0000:11:00.0: ffffc90006684450 port status reg = 0x202e1
> [  644.619059] xhci_hcd 0000:11:00.0: ffffc90006684454 port power reg = 0x0
> [  644.619065] xhci_hcd 0000:11:00.0: ffffc90006684458 port link reg = 0x0
> [  644.619071] xhci_hcd 0000:11:00.0: ffffc9000668445c port reserved reg = 0x0
> [  644.619072] xhci_hcd 0000:11:00.0: // Halt the HC
> [  644.619085] xhci_hcd 0000:11:00.0: Resetting HCD
> [  644.619090] xhci_hcd 0000:11:00.0: // Reset the HC
> [  644.619140] xhci_hcd 0000:11:00.0: Wait for controller to be ready for doorbell rings
> [  644.619145] xhci_hcd 0000:11:00.0: Reset complete
> [  644.619151] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  644.619152] xhci_hcd 0000:11:00.0: Calling HCD init
> [  644.619153] xhci_hcd 0000:11:00.0: xhci_init
> [  644.619154] xhci_hcd 0000:11:00.0: xHCI doesn't need link TRB QUIRK
> [  644.619160] xhci_hcd 0000:11:00.0: Supported page size register = 0x1
> [  644.619162] xhci_hcd 0000:11:00.0: Supported page size of 4K
> [  644.619163] xhci_hcd 0000:11:00.0: HCD page size set to 4K
> [  644.619169] xhci_hcd 0000:11:00.0: // xHC can handle at most 32 device slots.
> [  644.619175] xhci_hcd 0000:11:00.0: // Setting Max device slots reg = 0x20.
> [  644.619195] xhci_hcd 0000:11:00.0: // Device context base array address = 0xfffff000 (DMA), ffff88040bde6000 (virt)
> [  644.619200] xhci_hcd 0000:11:00.0: Allocated command ring at ffff88040d8294c0
> [  644.619201] xhci_hcd 0000:11:00.0: First segment DMA is 0xffffe000
> [  644.619210] xhci_hcd 0000:11:00.0: // Setting command ring address to 0x20
> [  644.619220] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  644.619221] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  644.619227] xhci_hcd 0000:11:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
> [  644.619229] xhci_hcd 0000:11:00.0: // xHCI capability registers at ffffc90006684000:
> [  644.619235] xhci_hcd 0000:11:00.0: // @ffffc90006684000 = 0x960020 (CAPLENGTH AND HCIVERSION)
> [  644.619236] xhci_hcd 0000:11:00.0: //   CAPLENGTH: 0x20
> [  644.619238] xhci_hcd 0000:11:00.0: // xHCI operational registers at ffffc90006684020:
> [  644.619244] xhci_hcd 0000:11:00.0: // @ffffc90006684018 = 0x600 RTSOFF
> [  644.619245] xhci_hcd 0000:11:00.0: // xHCI runtime registers at ffffc90006684600:
> [  644.619251] xhci_hcd 0000:11:00.0: // @ffffc90006684014 = 0x800 DBOFF
> [  644.619252] xhci_hcd 0000:11:00.0: // Doorbell array at ffffc90006684800:
> [  644.619254] xhci_hcd 0000:11:00.0: xHCI runtime registers at ffffc90006684600:
> [  644.619260] xhci_hcd 0000:11:00.0:   ffffc90006684600: Microframe index = 0x0
> [  644.619285] xhci_hcd 0000:11:00.0: // Allocating event ring
> [  644.619287] xhci_hcd 0000:11:00.0: TRB math tests passed.
> [  644.619289] xhci_hcd 0000:11:00.0: // Allocated event ring segment table at 0xffffd000
> [  644.619291] xhci_hcd 0000:11:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff880409671000, dma addr = 0xffffd000
> [  644.619297] xhci_hcd 0000:11:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [  644.619299] xhci_hcd 0000:11:00.0: // Set ERST entries to point to event ring.
> [  644.619300] xhci_hcd 0000:11:00.0: // Set ERST base address for ir_set 0 = 0xffffd000
> [  644.619316] xhci_hcd 0000:11:00.0: // Write event ring dequeue pointer, preserving EHB bit
> [  644.619318] xhci_hcd 0000:11:00.0: Wrote ERST address to ir_set 0.
> [  644.619323] xhci_hcd 0000:11:00.0: Allocating 0 scratchpad buffers
> [  644.619342] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006684510, port offset = 1, count = 2, revision = 0x3
> [  644.619352] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006684520, port offset = 3, count = 2, revision = 0x2
> [  644.619353] xhci_hcd 0000:11:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [  644.619355] xhci_hcd 0000:11:00.0: USB 2.0 port at index 2, addr = ffffc90006684440
> [  644.619356] xhci_hcd 0000:11:00.0: USB 2.0 port at index 3, addr = ffffc90006684450
> [  644.619358] xhci_hcd 0000:11:00.0: USB 3.0 port at index 0, addr = ffffc90006684420
> [  644.619359] xhci_hcd 0000:11:00.0: USB 3.0 port at index 1, addr = ffffc90006684430
> [  644.619365] xhci_hcd 0000:11:00.0: Finished xhci_init
> [  644.619366] xhci_hcd 0000:11:00.0: Called HCD init
> [  644.619372] xhci_hcd 0000:11:00.0: Got SBRN 48
> [  644.619392] xhci_hcd 0000:11:00.0: MWI active
> [  644.619393] xhci_hcd 0000:11:00.0: Finished xhci_pci_reinit
> [  644.619394] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  644.619404] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [  644.619832] xhci_hcd 0000:11:00.0: xhci_run
> [  644.619937] xhci_hcd 0000:11:00.0: irq 49 for MSI/MSI-X
> [  644.619941] xhci_hcd 0000:11:00.0: irq 50 for MSI/MSI-X
> [  644.619945] xhci_hcd 0000:11:00.0: irq 51 for MSI/MSI-X
> [  644.619948] xhci_hcd 0000:11:00.0: irq 52 for MSI/MSI-X
> [  644.619952] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [  644.620051] xhci_hcd 0000:11:00.0: Setting event ring polling timer
> [  644.620053] xhci_hcd 0000:11:00.0: Command ring memory map follows:
> [  644.620055] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 00000000
> [  644.620057] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00000000
> [  644.620058] xhci_hcd 0000:11:00.0: @00000000ffffe020 00000000 00000000 00000000 00000000
> [  644.620060] xhci_hcd 0000:11:00.0: @00000000ffffe030 00000000 00000000 00000000 00000000
> [  644.620061] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [  644.620063] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [  644.620064] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [  644.620066] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [  644.620068] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [  644.620069] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [  644.620071] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [  644.620072] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [  644.620074] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [  644.620075] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [  644.620077] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [  644.620079] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [  644.620080] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [  644.620082] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [  644.620083] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [  644.620085] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [  644.620087] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [  644.620088] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [  644.620090] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [  644.620091] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [  644.620093] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [  644.620094] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [  644.620096] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [  644.620098] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [  644.620099] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [  644.620101] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [  644.620102] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [  644.620104] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [  644.620105] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [  644.620107] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [  644.620109] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [  644.620110] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [  644.620112] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [  644.620113] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [  644.620115] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [  644.620117] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [  644.620118] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [  644.620120] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [  644.620121] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [  644.620123] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [  644.620124] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [  644.620126] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [  644.620128] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [  644.620129] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [  644.620131] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [  644.620132] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [  644.620134] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [  644.620136] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [  644.620137] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [  644.620139] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [  644.620140] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [  644.620142] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [  644.620143] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [  644.620145] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [  644.620147] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [  644.620148] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [  644.620150] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [  644.620151] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [  644.620153] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [  644.620155] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [  644.620156] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  644.620158] xhci_hcd 0000:11:00.0: Ring deq = ffff88040ae8c000 (virt), 0xffffe000 (dma)
> [  644.620159] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  644.620160] xhci_hcd 0000:11:00.0: Ring enq = ffff88040ae8c000 (virt), 0xffffe000 (dma)
> [  644.620162] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  644.620171] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  644.620173] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  644.620174] xhci_hcd 0000:11:00.0: ERST memory map follows:
> [  644.620175] xhci_hcd 0000:11:00.0: @00000000ffffd000 ffffe400 00000000 00000040 00000000
> [  644.620177] xhci_hcd 0000:11:00.0: Event ring:
> [  644.620178] xhci_hcd 0000:11:00.0: @00000000ffffe400 00000000 00000000 00000000 00000000
> [  644.620180] xhci_hcd 0000:11:00.0: @00000000ffffe410 00000000 00000000 00000000 00000000
> [  644.620181] xhci_hcd 0000:11:00.0: @00000000ffffe420 00000000 00000000 00000000 00000000
> [  644.620183] xhci_hcd 0000:11:00.0: @00000000ffffe430 00000000 00000000 00000000 00000000
> [  644.620184] xhci_hcd 0000:11:00.0: @00000000ffffe440 00000000 00000000 00000000 00000000
> [  644.620186] xhci_hcd 0000:11:00.0: @00000000ffffe450 00000000 00000000 00000000 00000000
> [  644.620188] xhci_hcd 0000:11:00.0: @00000000ffffe460 00000000 00000000 00000000 00000000
> [  644.620189] xhci_hcd 0000:11:00.0: @00000000ffffe470 00000000 00000000 00000000 00000000
> [  644.620191] xhci_hcd 0000:11:00.0: @00000000ffffe480 00000000 00000000 00000000 00000000
> [  644.620192] xhci_hcd 0000:11:00.0: @00000000ffffe490 00000000 00000000 00000000 00000000
> [  644.620194] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 00000000 00000000 00000000 00000000
> [  644.620195] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 00000000 00000000 00000000 00000000
> [  644.620197] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 00000000 00000000 00000000 00000000
> [  644.620199] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 00000000 00000000 00000000 00000000
> [  644.620200] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 00000000 00000000 00000000 00000000
> [  644.620202] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 00000000 00000000 00000000 00000000
> [  644.620203] xhci_hcd 0000:11:00.0: @00000000ffffe500 00000000 00000000 00000000 00000000
> [  644.620205] xhci_hcd 0000:11:00.0: @00000000ffffe510 00000000 00000000 00000000 00000000
> [  644.620206] xhci_hcd 0000:11:00.0: @00000000ffffe520 00000000 00000000 00000000 00000000
> [  644.620208] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [  644.620210] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [  644.620211] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [  644.620213] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [  644.620214] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [  644.620216] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [  644.620218] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [  644.620219] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [  644.620221] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [  644.620222] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [  644.620224] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [  644.620225] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [  644.620227] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [  644.620229] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [  644.620230] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [  644.620232] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [  644.620233] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [  644.620235] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [  644.620237] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [  644.620238] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [  644.620240] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [  644.620241] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [  644.620243] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [  644.620244] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [  644.620246] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [  644.620248] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [  644.620249] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [  644.620251] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [  644.620252] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [  644.620254] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [  644.620255] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [  644.620257] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [  644.620259] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [  644.620260] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [  644.620262] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [  644.620263] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [  644.620265] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [  644.620267] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [  644.620268] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [  644.620270] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [  644.620271] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [  644.620273] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [  644.620274] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [  644.620276] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [  644.620278] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [  644.620279] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  644.620280] xhci_hcd 0000:11:00.0: Ring deq = ffff88040ae8c400 (virt), 0xffffe400 (dma)
> [  644.620282] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  644.620283] xhci_hcd 0000:11:00.0: Ring enq = ffff88040ae8c400 (virt), 0xffffe400 (dma)
> [  644.620285] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  644.620294] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe400
> [  644.620295] xhci_hcd 0000:11:00.0: // Set the interrupt modulation register
> [  644.620305] xhci_hcd 0000:11:00.0: // Enable interrupts, cmd = 0x4.
> [  644.620311] xhci_hcd 0000:11:00.0: // Enabling event ring interrupter ffffc90006684620 by writing 0x2 to irq_pending
> [  644.620318] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set[0]
> [  644.620320] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set.pending = 0x2
> [  644.620326] xhci_hcd 0000:11:00.0:   ffffc90006684624: ir_set.control = 0xa0
> [  644.620332] xhci_hcd 0000:11:00.0:   ffffc90006684628: ir_set.erst_size = 0x1
> [  644.620345] xhci_hcd 0000:11:00.0:   ffffc90006684630: ir_set.erst_base = @ffffd000
> [  644.620354] xhci_hcd 0000:11:00.0:   ffffc90006684638: ir_set.erst_dequeue = @ffffe400
> [  644.620356] xhci_hcd 0000:11:00.0: Finished xhci_run for USB2 roothub
> [  644.620365] usb usb3: default language 0x0409
> [  644.620370] usb usb3: udev 1, busnum 3, minor = 256
> [  644.620371] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [  644.620809] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  644.621246] usb usb3: Product: xHCI Host Controller
> [  644.621675] usb usb3: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  644.622117] usb usb3: SerialNumber: 0000:11:00.0
> [  644.622682] usb usb3: usb_probe_device
> [  644.622686] usb usb3: configuration #1 chosen from 1 choice
> [  644.622690] xHCI xhci_add_endpoint called for root hub
> [  644.622692] xHCI xhci_check_bandwidth called for root hub
> [  644.622698] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [  644.622731] hub 3-0:1.0: usb_probe_interface
> [  644.622733] hub 3-0:1.0: usb_probe_interface - got id
> [  644.622736] hub 3-0:1.0: USB hub found
> [  644.623211] hub 3-0:1.0: 2 ports detected
> [  644.623680] hub 3-0:1.0: standalone hub
> [  644.623681] hub 3-0:1.0: individual port power switching
> [  644.623682] hub 3-0:1.0: individual port over-current protection
> [  644.623684] hub 3-0:1.0: Single TT
> [  644.623685] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  644.623686] hub 3-0:1.0: power on to power good time: 20ms
> [  644.623689] hub 3-0:1.0: local power source is good
> [  644.623690] hub 3-0:1.0: enabling power on all ports
> [  644.623700] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  644.623713] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  644.623756] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  644.624284] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 4
> [  644.624923] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  644.624925] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  644.624930] xhci_hcd 0000:11:00.0: // Turn on HC, cmd = 0x5.
> [  644.624948] xhci_hcd 0000:11:00.0: // Ding dong!
> [  644.624954] xhci_hcd 0000:11:00.0: Finished xhci_run for USB3 roothub
> [  644.624960] usb usb4: skipped 1 descriptor after endpoint
> [  644.624962] usb usb4: default language 0x0409
> [  644.624966] usb usb4: udev 1, busnum 4, minor = 384
> [  644.624968] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [  644.625625] xhci_hcd 0000:11:00.0: Vendor specific event TRB type = 48
> [  644.625628] xhci_hcd 0000:11:00.0: NEC firmware version 30.28
> [  644.625641] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  644.626371] usb usb4: Product: xHCI Host Controller
> [  644.626373] usb usb4: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  644.626375] usb usb4: SerialNumber: 0000:11:00.0
> [  644.626451] usb usb4: usb_probe_device
> [  644.626453] usb usb4: configuration #1 chosen from 1 choice
> [  644.626456] xHCI xhci_add_endpoint called for root hub
> [  644.626457] xHCI xhci_check_bandwidth called for root hub
> [  644.626463] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [  644.626488] hub 4-0:1.0: usb_probe_interface
> [  644.626490] hub 4-0:1.0: usb_probe_interface - got id
> [  644.626492] hub 4-0:1.0: USB hub found
> [  644.626509] hub 4-0:1.0: 2 ports detected
> [  644.626511] hub 4-0:1.0: standalone hub
> [  644.626512] hub 4-0:1.0: individual port power switching
> [  644.626514] hub 4-0:1.0: individual port over-current protection
> [  644.626516] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  644.626517] hub 4-0:1.0: power on to power good time: 20ms
> [  644.626520] hub 4-0:1.0: local power source is good
> [  644.626522] hub 4-0:1.0: enabling power on all ports
> [  644.626539] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  644.626563] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  644.676551] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  644.714980] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  644.714983] xhci_hcd 0000:11:00.0: Get port status returned 0x100
> [  644.714992] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x202e1
> [  644.714994] xhci_hcd 0000:11:00.0: Get port status returned 0x10101
> [  644.714996] hub 3-0:1.0: port 2: status 0101 change 0001
> [  644.715008] xhci_hcd 0000:11:00.0: clear port connect change, actual port 1 status  = 0x2e1
> [  644.724965] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  644.724967] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  644.724974] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2a0
> [  644.724976] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  644.724982] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [  644.814908] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [  644.814919] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2e1
> [  644.814921] xhci_hcd 0000:11:00.0: Get port status returned 0x101
> [  644.814925] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [  644.814929] xhci_hcd 0000:11:00.0: // Ding dong!
> [  644.814984] xhci_hcd 0000:11:00.0: Slot 1 output ctx = 0xffffc000 (dma)
> [  644.814987] xhci_hcd 0000:11:00.0: Slot 1 input ctx = 0xffffb000 (dma)
> [  644.814992] xhci_hcd 0000:11:00.0: Set slot id 1 dcbaa entry ffff88040bde6008 to 0xffffc000
> [  644.815005] xhci_hcd 0000:11:00.0: set port reset, actual port 1 status  = 0x331
> [  644.864955] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  644.874790] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x200a03
> [  644.874800] xhci_hcd 0000:11:00.0: Get port status returned 0x100303
> [  644.934754] xhci_hcd 0000:11:00.0: clear port reset change, actual port 1 status  = 0xa03
> [  644.934772] usb 3-2: new low-speed USB device number 2 using xhci_hcd
> [  644.935548] xhci_hcd 0000:11:00.0: Set root hub portnum to 4
> [  644.935549] xhci_hcd 0000:11:00.0: Set fake root hub portnum to 2
> [  644.935551] xhci_hcd 0000:11:00.0: udev->tt = ffff88040d580898
> [  644.935552] xhci_hcd 0000:11:00.0: udev->ttport = 0x2
> [  644.935553] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  644.935555] xhci_hcd 0000:11:00.0: @ffff88040c89d000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  644.935557] xhci_hcd 0000:11:00.0: @ffff88040c89d004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  644.935559] xhci_hcd 0000:11:00.0: @ffff88040c89d008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  644.935560] xhci_hcd 0000:11:00.0: @ffff88040c89d00c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  644.935562] xhci_hcd 0000:11:00.0: @ffff88040c89d010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  644.935564] xhci_hcd 0000:11:00.0: @ffff88040c89d014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  644.935565] xhci_hcd 0000:11:00.0: @ffff88040c89d018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  644.935567] xhci_hcd 0000:11:00.0: @ffff88040c89d01c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  644.935568] xhci_hcd 0000:11:00.0: Slot Context:
> [  644.935570] xhci_hcd 0000:11:00.0: @ffff88040c89d020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  644.935571] xhci_hcd 0000:11:00.0: @ffff88040c89d024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  644.935573] xhci_hcd 0000:11:00.0: @ffff88040c89d028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  644.935574] xhci_hcd 0000:11:00.0: @ffff88040c89d02c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  644.935576] xhci_hcd 0000:11:00.0: @ffff88040c89d030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  644.935578] xhci_hcd 0000:11:00.0: @ffff88040c89d034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  644.935579] xhci_hcd 0000:11:00.0: @ffff88040c89d038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  644.935581] xhci_hcd 0000:11:00.0: @ffff88040c89d03c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  644.935583] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  644.935584] xhci_hcd 0000:11:00.0: @ffff88040c89d040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  644.935586] xhci_hcd 0000:11:00.0: @ffff88040c89d044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  644.935587] xhci_hcd 0000:11:00.0: @ffff88040c89d048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  644.935589] xhci_hcd 0000:11:00.0: @ffff88040c89d050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  644.935590] xhci_hcd 0000:11:00.0: @ffff88040c89d054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  644.935592] xhci_hcd 0000:11:00.0: @ffff88040c89d058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  644.935594] xhci_hcd 0000:11:00.0: @ffff88040c89d05c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  644.935595] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  644.935596] xhci_hcd 0000:11:00.0: @ffff88040c89d060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  644.935598] xhci_hcd 0000:11:00.0: @ffff88040c89d064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  644.935600] xhci_hcd 0000:11:00.0: @ffff88040c89d068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  644.935601] xhci_hcd 0000:11:00.0: @ffff88040c89d070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  644.935603] xhci_hcd 0000:11:00.0: @ffff88040c89d074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  644.935605] xhci_hcd 0000:11:00.0: @ffff88040c89d078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  644.935606] xhci_hcd 0000:11:00.0: @ffff88040c89d07c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  644.935608] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  644.935609] xhci_hcd 0000:11:00.0: @ffff88040c89d080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  644.935611] xhci_hcd 0000:11:00.0: @ffff88040c89d084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  644.935612] xhci_hcd 0000:11:00.0: @ffff88040c89d088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  644.935614] xhci_hcd 0000:11:00.0: @ffff88040c89d090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  644.935615] xhci_hcd 0000:11:00.0: @ffff88040c89d094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  644.935617] xhci_hcd 0000:11:00.0: @ffff88040c89d098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  644.935619] xhci_hcd 0000:11:00.0: @ffff88040c89d09c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  644.935621] xhci_hcd 0000:11:00.0: // Ding dong!
> [  644.936324] xhci_hcd 0000:11:00.0: Successful Address Device command
> [  644.936344] xhci_hcd 0000:11:00.0: Op regs DCBAA ptr = 0x000000fffff000
> [  644.936352] xhci_hcd 0000:11:00.0: Slot ID 1 dcbaa entry @ffff88040bde6008 = 0x000000ffffc000
> [  644.936359] xhci_hcd 0000:11:00.0: Output Context DMA address = 0xffffc000
> [  644.936365] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  644.936372] xhci_hcd 0000:11:00.0: @ffff88040c89d000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  644.936380] xhci_hcd 0000:11:00.0: @ffff88040c89d004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  644.936387] xhci_hcd 0000:11:00.0: @ffff88040c89d008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  644.936395] xhci_hcd 0000:11:00.0: @ffff88040c89d00c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  644.936402] xhci_hcd 0000:11:00.0: @ffff88040c89d010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  644.936409] xhci_hcd 0000:11:00.0: @ffff88040c89d014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  644.936417] xhci_hcd 0000:11:00.0: @ffff88040c89d018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  644.936424] xhci_hcd 0000:11:00.0: @ffff88040c89d01c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  644.936430] xhci_hcd 0000:11:00.0: Slot Context:
> [  644.936436] xhci_hcd 0000:11:00.0: @ffff88040c89d020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  644.936451] xhci_hcd 0000:11:00.0: @ffff88040c89d024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  644.936452] xhci_hcd 0000:11:00.0: @ffff88040c89d028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  644.936454] xhci_hcd 0000:11:00.0: @ffff88040c89d02c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  644.936456] xhci_hcd 0000:11:00.0: @ffff88040c89d030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  644.936457] xhci_hcd 0000:11:00.0: @ffff88040c89d034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  644.936459] xhci_hcd 0000:11:00.0: @ffff88040c89d038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  644.936461] xhci_hcd 0000:11:00.0: @ffff88040c89d03c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  644.936462] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  644.936463] xhci_hcd 0000:11:00.0: @ffff88040c89d040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  644.936465] xhci_hcd 0000:11:00.0: @ffff88040c89d044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  644.936467] xhci_hcd 0000:11:00.0: @ffff88040c89d048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  644.936468] xhci_hcd 0000:11:00.0: @ffff88040c89d050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  644.936470] xhci_hcd 0000:11:00.0: @ffff88040c89d054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  644.936471] xhci_hcd 0000:11:00.0: @ffff88040c89d058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  644.936473] xhci_hcd 0000:11:00.0: @ffff88040c89d05c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  644.936474] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  644.936476] xhci_hcd 0000:11:00.0: @ffff88040c89d060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  644.936477] xhci_hcd 0000:11:00.0: @ffff88040c89d064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  644.936479] xhci_hcd 0000:11:00.0: @ffff88040c89d068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  644.936481] xhci_hcd 0000:11:00.0: @ffff88040c89d070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  644.936482] xhci_hcd 0000:11:00.0: @ffff88040c89d074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  644.936484] xhci_hcd 0000:11:00.0: @ffff88040c89d078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  644.936486] xhci_hcd 0000:11:00.0: @ffff88040c89d07c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  644.936487] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  644.936488] xhci_hcd 0000:11:00.0: @ffff88040c89d080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  644.936490] xhci_hcd 0000:11:00.0: @ffff88040c89d084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  644.936491] xhci_hcd 0000:11:00.0: @ffff88040c89d088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  644.936493] xhci_hcd 0000:11:00.0: @ffff88040c89d090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  644.936495] xhci_hcd 0000:11:00.0: @ffff88040c89d094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  644.936496] xhci_hcd 0000:11:00.0: @ffff88040c89d098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  644.936498] xhci_hcd 0000:11:00.0: @ffff88040c89d09c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  644.936499] xhci_hcd 0000:11:00.0: Slot ID 1 Output Context:
> [  644.936500] xhci_hcd 0000:11:00.0: Slot Context:
> [  644.936502] xhci_hcd 0000:11:00.0: @ffff88040bf71000 (virt) @ffffc000 (dma) 0x8200000 - dev_info
> [  644.936503] xhci_hcd 0000:11:00.0: @ffff88040bf71004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  644.936505] xhci_hcd 0000:11:00.0: @ffff88040bf71008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  644.936507] xhci_hcd 0000:11:00.0: @ffff88040bf7100c (virt) @ffffc00c (dma) 0x10000001 - dev_state
> [  644.936508] xhci_hcd 0000:11:00.0: @ffff88040bf71010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  644.936510] xhci_hcd 0000:11:00.0: @ffff88040bf71014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  644.936512] xhci_hcd 0000:11:00.0: @ffff88040bf71018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  644.936513] xhci_hcd 0000:11:00.0: @ffff88040bf7101c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  644.936515] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  644.936516] xhci_hcd 0000:11:00.0: @ffff88040bf71020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  644.936518] xhci_hcd 0000:11:00.0: @ffff88040bf71024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  644.936519] xhci_hcd 0000:11:00.0: @ffff88040bf71028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  644.936521] xhci_hcd 0000:11:00.0: @ffff88040bf71030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  644.936522] xhci_hcd 0000:11:00.0: @ffff88040bf71034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  644.936524] xhci_hcd 0000:11:00.0: @ffff88040bf71038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  644.936526] xhci_hcd 0000:11:00.0: @ffff88040bf7103c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  644.936527] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  644.936528] xhci_hcd 0000:11:00.0: @ffff88040bf71040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  644.936530] xhci_hcd 0000:11:00.0: @ffff88040bf71044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  644.936532] xhci_hcd 0000:11:00.0: @ffff88040bf71048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  644.936533] xhci_hcd 0000:11:00.0: @ffff88040bf71050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  644.936535] xhci_hcd 0000:11:00.0: @ffff88040bf71054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  644.936536] xhci_hcd 0000:11:00.0: @ffff88040bf71058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  644.936538] xhci_hcd 0000:11:00.0: @ffff88040bf7105c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  644.936539] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  644.936541] xhci_hcd 0000:11:00.0: @ffff88040bf71060 (virt) @ffffc060 (dma) 0x000000 - ep_info
> [  644.936542] xhci_hcd 0000:11:00.0: @ffff88040bf71064 (virt) @ffffc064 (dma) 0x000000 - ep_info2
> [  644.936544] xhci_hcd 0000:11:00.0: @ffff88040bf71068 (virt) @ffffc068 (dma) 0x000000 - deq
> [  644.936545] xhci_hcd 0000:11:00.0: @ffff88040bf71070 (virt) @ffffc070 (dma) 0x000000 - tx_info
> [  644.936547] xhci_hcd 0000:11:00.0: @ffff88040bf71074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  644.936549] xhci_hcd 0000:11:00.0: @ffff88040bf71078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  644.936550] xhci_hcd 0000:11:00.0: @ffff88040bf7107c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  644.936552] xhci_hcd 0000:11:00.0: Internal device address = 2
> [  644.973510] usb 3-2: skipped 1 descriptor after interface
> [  644.975494] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  644.976507] usb 3-2: default language 0x0409
> [  644.984481] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  644.988481] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  644.989478] usb 3-2: udev 2, busnum 3, minor = 257
> [  644.989480] usb 3-2: New USB device found, idVendor=0458, idProduct=0036
> [  644.989482] usb 3-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> [  644.989487] usb 3-2: Product: NetScroll + Mini Traveler
> [  644.989488] usb 3-2: Manufacturer: Genius
> [  644.989622] usb 3-2: usb_probe_device
> [  644.989625] usb 3-2: configuration #1 chosen from 1 choice
> [  644.989632] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
> [  644.989637] xhci_hcd 0000:11:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18200000
> [  644.989640] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040d5b5000
> [  644.989642] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  644.989645] xhci_hcd 0000:11:00.0: @ffff88040c89d000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  644.989647] xhci_hcd 0000:11:00.0: @ffff88040c89d004 (virt) @ffffb004 (dma) 0x000009 - add flags
> [  644.989650] xhci_hcd 0000:11:00.0: @ffff88040c89d008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  644.989652] xhci_hcd 0000:11:00.0: @ffff88040c89d00c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  644.989655] xhci_hcd 0000:11:00.0: @ffff88040c89d010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  644.989657] xhci_hcd 0000:11:00.0: @ffff88040c89d014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  644.989660] xhci_hcd 0000:11:00.0: @ffff88040c89d018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  644.989662] xhci_hcd 0000:11:00.0: @ffff88040c89d01c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  644.989664] xhci_hcd 0000:11:00.0: Slot Context:
> [  644.989666] xhci_hcd 0000:11:00.0: @ffff88040c89d020 (virt) @ffffb020 (dma) 0x18200000 - dev_info
> [  644.989668] xhci_hcd 0000:11:00.0: @ffff88040c89d024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  644.989671] xhci_hcd 0000:11:00.0: @ffff88040c89d028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  644.989673] xhci_hcd 0000:11:00.0: @ffff88040c89d02c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  644.989675] xhci_hcd 0000:11:00.0: @ffff88040c89d030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  644.989678] xhci_hcd 0000:11:00.0: @ffff88040c89d034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  644.989680] xhci_hcd 0000:11:00.0: @ffff88040c89d038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  644.989682] xhci_hcd 0000:11:00.0: @ffff88040c89d03c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  644.989684] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  644.989686] xhci_hcd 0000:11:00.0: @ffff88040c89d040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  644.989688] xhci_hcd 0000:11:00.0: @ffff88040c89d044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  644.989689] xhci_hcd 0000:11:00.0: @ffff88040c89d048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  644.989691] xhci_hcd 0000:11:00.0: @ffff88040c89d050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  644.989693] xhci_hcd 0000:11:00.0: @ffff88040c89d054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  644.989695] xhci_hcd 0000:11:00.0: @ffff88040c89d058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  644.989697] xhci_hcd 0000:11:00.0: @ffff88040c89d05c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  644.989698] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  644.989700] xhci_hcd 0000:11:00.0: @ffff88040c89d060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  644.989702] xhci_hcd 0000:11:00.0: @ffff88040c89d064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  644.989705] xhci_hcd 0000:11:00.0: @ffff88040c89d068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  644.989707] xhci_hcd 0000:11:00.0: @ffff88040c89d070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  644.989709] xhci_hcd 0000:11:00.0: @ffff88040c89d074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  644.989712] xhci_hcd 0000:11:00.0: @ffff88040c89d078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  644.989714] xhci_hcd 0000:11:00.0: @ffff88040c89d07c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  644.989716] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  644.989718] xhci_hcd 0000:11:00.0: @ffff88040c89d080 (virt) @ffffb080 (dma) 0x060000 - ep_info
> [  644.989721] xhci_hcd 0000:11:00.0: @ffff88040c89d084 (virt) @ffffb084 (dma) 0x04003e - ep_info2
> [  644.989723] xhci_hcd 0000:11:00.0: @ffff88040c89d088 (virt) @ffffb088 (dma) 0xffffa401 - deq
> [  644.989726] xhci_hcd 0000:11:00.0: @ffff88040c89d090 (virt) @ffffb090 (dma) 0x040004 - tx_info
> [  644.989728] xhci_hcd 0000:11:00.0: @ffff88040c89d094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  644.989730] xhci_hcd 0000:11:00.0: @ffff88040c89d098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  644.989733] xhci_hcd 0000:11:00.0: @ffff88040c89d09c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  644.989737] xhci_hcd 0000:11:00.0: // Ding dong!
> [  644.989959] xhci_hcd 0000:11:00.0: Completed config ep cmd
> [  644.989970] usb 3-2: Successful Endpoint Configure command
> [  644.989975] xhci_hcd 0000:11:00.0: Output context after successful config ep cmd:
> [  644.989978] xhci_hcd 0000:11:00.0: Slot Context:
> [  644.989980] xhci_hcd 0000:11:00.0: @ffff88040bf71000 (virt) @ffffc000 (dma) 0x18200000 - dev_info
> [  644.989982] xhci_hcd 0000:11:00.0: @ffff88040bf71004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  644.989985] xhci_hcd 0000:11:00.0: @ffff88040bf71008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  644.989988] xhci_hcd 0000:11:00.0: @ffff88040bf7100c (virt) @ffffc00c (dma) 0x18000001 - dev_state
> [  644.989990] xhci_hcd 0000:11:00.0: @ffff88040bf71010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  644.989992] xhci_hcd 0000:11:00.0: @ffff88040bf71014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  644.989994] xhci_hcd 0000:11:00.0: @ffff88040bf71018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  644.989997] xhci_hcd 0000:11:00.0: @ffff88040bf7101c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  644.990000] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  644.990001] xhci_hcd 0000:11:00.0: @ffff88040bf71020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  644.990004] xhci_hcd 0000:11:00.0: @ffff88040bf71024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  644.990006] xhci_hcd 0000:11:00.0: @ffff88040bf71028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  644.990008] xhci_hcd 0000:11:00.0: @ffff88040bf71030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  644.990010] xhci_hcd 0000:11:00.0: @ffff88040bf71034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  644.990012] xhci_hcd 0000:11:00.0: @ffff88040bf71038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  644.990015] xhci_hcd 0000:11:00.0: @ffff88040bf7103c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  644.990017] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  644.990018] xhci_hcd 0000:11:00.0: @ffff88040bf71040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  644.990021] xhci_hcd 0000:11:00.0: @ffff88040bf71044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  644.990022] xhci_hcd 0000:11:00.0: @ffff88040bf71048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  644.990025] xhci_hcd 0000:11:00.0: @ffff88040bf71050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  644.990028] xhci_hcd 0000:11:00.0: @ffff88040bf71054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  644.990031] xhci_hcd 0000:11:00.0: @ffff88040bf71058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  644.990033] xhci_hcd 0000:11:00.0: @ffff88040bf7105c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  644.990035] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  644.990036] xhci_hcd 0000:11:00.0: @ffff88040bf71060 (virt) @ffffc060 (dma) 0x060001 - ep_info
> [  644.990039] xhci_hcd 0000:11:00.0: @ffff88040bf71064 (virt) @ffffc064 (dma) 0x04003e - ep_info2
> [  644.990041] xhci_hcd 0000:11:00.0: @ffff88040bf71068 (virt) @ffffc068 (dma) 0xffffa401 - deq
> [  644.990043] xhci_hcd 0000:11:00.0: @ffff88040bf71070 (virt) @ffffc070 (dma) 0x040004 - tx_info
> [  644.990046] xhci_hcd 0000:11:00.0: @ffff88040bf71074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  644.990048] xhci_hcd 0000:11:00.0: @ffff88040bf71078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  644.990051] xhci_hcd 0000:11:00.0: @ffff88040bf7107c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  644.991470] xhci_hcd 0000:11:00.0: Endpoint 0x81 not halted, refusing to reset.
> [  644.991475] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> [  644.991515] usbserial_generic 3-2:1.0: usb_probe_interface
> [  644.991519] usbserial_generic 3-2:1.0: usb_probe_interface - got id
> [  644.991540] usbhid 3-2:1.0: usb_probe_interface
> [  644.991542] usbhid 3-2:1.0: usb_probe_interface - got id
> [  645.002654] input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1c.7/0000:11:00.0/usb3/3-2/3-2:1.0/input/input17
> [  645.002763] generic-usb 0003:0458:0036.0004: input,hidraw0: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:11:00.0-2/input0
> [  647.131525] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> [  647.131567] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> [  647.131575] hub 4-0:1.0: hub_suspend
> [  647.131579] usb usb4: bus auto-suspend, wakeup 1
> [  674.436988] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  674.436998] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  674.437014] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  674.437560] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  674.437723] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  674.437725] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [  674.437779] xhci_hcd 0000:11:00.0: remove, state 4
> [  674.438298] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  674.438301] usb usb4: USB disconnect, device number 1
> [  674.438813] usb usb4: unregistering device
> [  674.438815] usb usb4: unregistering interface 4-0:1.0
> [  674.438857] usb usb4: usb_disable_device nuking all URBs
> [  674.438866] xHCI xhci_drop_endpoint called for root hub
> [  674.438867] xHCI xhci_check_bandwidth called for root hub
> [  674.438968] xhci_hcd 0000:11:00.0: // Halt the HC
> [  674.438974] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  674.439588] xhci_hcd 0000:11:00.0: USB bus 4 deregistered
> [  674.440110] xhci_hcd 0000:11:00.0: remove, state 1
> [  674.440625] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  674.440628] usb usb3: USB disconnect, device number 1
> [  674.441175] usb 3-2: USB disconnect, device number 2
> [  674.441776] usb 3-2: unregistering device
> [  674.441778] usb 3-2: unregistering interface 3-2:1.0
> [  674.441808] xhci_hcd 0000:11:00.0: HW died, freeing TD.
> [  674.441811] xhci_hcd 0000:11:00.0: shutdown urb ffff88040be18840 ep1in-intr
> [  674.470996] usb 3-2: usb_disable_device nuking all URBs
> [  674.471001] xhci_hcd 0000:11:00.0: xhci_drop_endpoint called for udev ffff88040d5b5000
> [  674.471005] xhci_hcd 0000:11:00.0: drop ep 0x81, slot id 1, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8200000
> [  674.471008] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040d5b5000
> [  674.471010] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  674.471013] xhci_hcd 0000:11:00.0: @ffff88040c89d000 (virt) @ffffb000 (dma) 0x000008 - drop flags
> [  674.471016] xhci_hcd 0000:11:00.0: @ffff88040c89d004 (virt) @ffffb004 (dma) 0x000001 - add flags
> [  674.471018] xhci_hcd 0000:11:00.0: @ffff88040c89d008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  674.471021] xhci_hcd 0000:11:00.0: @ffff88040c89d00c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  674.471024] xhci_hcd 0000:11:00.0: @ffff88040c89d010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  674.471027] xhci_hcd 0000:11:00.0: @ffff88040c89d014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  674.471029] xhci_hcd 0000:11:00.0: @ffff88040c89d018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  674.471031] xhci_hcd 0000:11:00.0: @ffff88040c89d01c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  674.471033] xhci_hcd 0000:11:00.0: Slot Context:
> [  674.471035] xhci_hcd 0000:11:00.0: @ffff88040c89d020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  674.471037] xhci_hcd 0000:11:00.0: @ffff88040c89d024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  674.471040] xhci_hcd 0000:11:00.0: @ffff88040c89d028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  674.471042] xhci_hcd 0000:11:00.0: @ffff88040c89d02c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  674.471044] xhci_hcd 0000:11:00.0: @ffff88040c89d030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  674.471047] xhci_hcd 0000:11:00.0: @ffff88040c89d034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  674.471049] xhci_hcd 0000:11:00.0: @ffff88040c89d038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  674.471052] xhci_hcd 0000:11:00.0: @ffff88040c89d03c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  674.471054] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  674.471056] xhci_hcd 0000:11:00.0: @ffff88040c89d040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  674.471059] xhci_hcd 0000:11:00.0: @ffff88040c89d044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  674.471062] xhci_hcd 0000:11:00.0: @ffff88040c89d048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  674.471064] xhci_hcd 0000:11:00.0: @ffff88040c89d050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  674.471067] xhci_hcd 0000:11:00.0: @ffff88040c89d054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  674.471069] xhci_hcd 0000:11:00.0: @ffff88040c89d058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  674.471072] xhci_hcd 0000:11:00.0: @ffff88040c89d05c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  674.471076] xhci_hcd 0000:11:00.0: // Ding dong!
> [  704.665769] xhci_hcd 0000:11:00.0: Poll event ring: 4295007856
> [  704.665780] xhci_hcd 0000:11:00.0: op reg status = 0xffffffff
> [  704.665786] xhci_hcd 0000:11:00.0: HW died, polling stopped.
> [  724.396415] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> [  724.398406] usb usb3: unregistering device
> [  724.398409] usb usb3: unregistering interface 3-0:1.0
> [  724.398435] xhci_hcd 0000:11:00.0: shutdown urb ffff88040af3c8c0 ep1in-intr
> [  724.398450] usb usb3: usb_disable_device nuking all URBs
> [  724.398452] xHCI xhci_drop_endpoint called for root hub
> [  724.398454] xHCI xhci_check_bandwidth called for root hub
> [  724.398593] xhci_hcd 0000:11:00.0: // Halt the HC
> [  724.398598] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  724.399346] xhci_hcd 0000:11:00.0: // Reset the HC
> [  724.399399] xhci_hcd 0000:11:00.0: // Disabling event ring interrupts
> [  724.399403] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set[0]
> [  724.399405] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set.pending = 0xffffffff
> [  724.399408] xhci_hcd 0000:11:00.0:   ffffc90006684624: ir_set.control = 0xffffffff
> [  724.399410] xhci_hcd 0000:11:00.0:   ffffc90006684628: ir_set.erst_size = 0xffffffff
> [  724.399413] xhci_hcd 0000:11:00.0:   WARN: ffffc9000668462c: ir_set.rsvd = 0xffffffff
> [  724.399417] xhci_hcd 0000:11:00.0:   ffffc90006684630: ir_set.erst_base = @ffffffffffffffff
> [  724.399420] xhci_hcd 0000:11:00.0:   ffffc90006684638: ir_set.erst_dequeue = @ffffffffffffffff
> [  724.399422] xhci_hcd 0000:11:00.0: cleaning up memory
> [  724.399426] xhci_hcd 0000:11:00.0: Freed ERST
> [  724.399427] xhci_hcd 0000:11:00.0: Freed event ring
> [  724.399428] xhci_hcd 0000:11:00.0: Freed command ring
> [  724.399432] xhci_hcd 0000:11:00.0: Freed segment pool
> [  724.399434] xhci_hcd 0000:11:00.0: Freed device context pool
> [  724.399435] xhci_hcd 0000:11:00.0: Freed small stream array pool
> [  724.399436] xhci_hcd 0000:11:00.0: Freed medium stream array pool
> [  724.399439] xhci_hcd 0000:11:00.0: xhci_stop completed - status = ffffffff
> [  724.399441] xhci_hcd 0000:11:00.0: USB bus 3 deregistered

> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.4.0-rc5-default (root@vostro) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.1, pie-0.4.7) ) #9 SMP Wed May 2 16:46:19 MEST 2012
> [    0.000000] Command line: root=/dev/sda5 pciehp.pciehp_debug=1
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
> [    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
> [    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
> [    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
> [    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
> [    0.000000]  BIOS-e820: 0000000040200000 - 00000000da4e5000 (usable)
> [    0.000000]  BIOS-e820: 00000000da4e5000 - 00000000da528000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000da528000 - 00000000da793000 (usable)
> [    0.000000]  BIOS-e820: 00000000da793000 - 00000000da967000 (reserved)
> [    0.000000]  BIOS-e820: 00000000da967000 - 00000000dacbc000 (usable)
> [    0.000000]  BIOS-e820: 00000000dacbc000 - 00000000dad68000 (reserved)
> [    0.000000]  BIOS-e820: 00000000dad68000 - 00000000dafe8000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000dafe8000 - 00000000db000000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000db800000 - 00000000dfa00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000041fe00000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.6 present.
> [    0.000000] DMI: Dell Inc. Vostro 3550/0JGC48, BIOS A09 09/30/2011
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask C00000000 write-back
> [    0.000000]   1 base 400000000 mask FE0000000 write-back
> [    0.000000]   2 base 0DB800000 mask FFF800000 uncachable
> [    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
> [    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   5 base 41FE00000 mask FFFE00000 uncachable
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820 update range: 00000000db800000 - 0000000100000000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0xdacbc max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
> [    0.000000] init_memory_mapping: 0000000000000000-00000000dacbc000
> [    0.000000]  0000000000 - 00dac00000 page 2M
> [    0.000000]  00dac00000 - 00dacbc000 page 4k
> [    0.000000] kernel direct mapping tables up to dacbc000 @ 1fffa000-20000000
> [    0.000000] init_memory_mapping: 0000000100000000-000000041fe00000
> [    0.000000]  0100000000 - 041fe00000 page 2M
> [    0.000000] kernel direct mapping tables up to 41fe00000 @ dacaa000-dacbc000
> [    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02   DELL)
> [    0.000000] ACPI: XSDT 00000000dafe8078 00074 (v01 DELL    WN09    01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 00000000daff1d08 000F4 (v04   DELL     WN09 01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 00000000dafe8180 09B85 (v02   DELL     WN09 00000000 INTL 20051117)
> [    0.000000] ACPI: FACS 00000000dafe3f80 00040
> [    0.000000] ACPI: APIC 00000000daff1e00 00072 (v03   DELL     WN09 01072009 AMI  00010013)
> [    0.000000] ACPI: MCFG 00000000daff1e78 0003C (v01   DELL     WN09 01072009 MSFT 00000097)
> [    0.000000] ACPI: SSDT 00000000daff1eb8 004B0 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
> [    0.000000] ACPI: SLIC 00000000daff2368 00176 (v01 DELL    WN09    01072009 AMI  00010013)
> [    0.000000] ACPI: HPET 00000000daff24e0 00038 (v01   DELL     WN09 01072009 AMI. 00000004)
> [    0.000000] ACPI: SSDT 00000000daff2518 00846 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 00000000daff2d60 00996 (v01  PmRef    CpuPm 00003000 INTL 20051117)
> [    0.000000] ACPI: DMAR 00000000daff36f8 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
> [    0.000000] ACPI: OSFR 00000000daff37e0 00086 (v01 DELL    M08     07DB091E ASL  00000061)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-000000041fe00000
> [    0.000000] Initmem setup node 0 0000000000000000-000000041fe00000
> [    0.000000]   NODE_DATA [000000041fdfc000 - 000000041fdfffff]
> [    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff88040f400000-ffff88041d5fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x0041fe00
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] Early memory PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009d
> [    0.000000]     0: 0x00000100 -> 0x00020000
> [    0.000000]     0: 0x00020200 -> 0x00040000
> [    0.000000]     0: 0x00040200 -> 0x000da4e5
> [    0.000000]     0: 0x000da528 -> 0x000da793
> [    0.000000]     0: 0x000da967 -> 0x000dacbc
> [    0.000000]     0: 0x00100000 -> 0x0041fe00
> [    0.000000] On node 0 totalpages: 4170802
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 5 pages reserved
> [    0.000000]   DMA zone: 3920 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 876253 pages, LIFO batch:31
> [    0.000000]   Normal zone: 44793 pages used for memmap
> [    0.000000]   Normal zone: 3231495 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 00000000da4e5000 - 00000000da528000
> [    0.000000] PM: Registered nosave memory: 00000000da793000 - 00000000da967000
> [    0.000000] PM: Registered nosave memory: 00000000dacbc000 - 00000000dad68000
> [    0.000000] PM: Registered nosave memory: 00000000dad68000 - 00000000dafe8000
> [    0.000000] PM: Registered nosave memory: 00000000dafe8000 - 00000000db000000
> [    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000db800000
> [    0.000000] PM: Registered nosave memory: 00000000db800000 - 00000000dfa00000
> [    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
> [    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
> [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
> [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88041fa00000 s72448 r8192 d21760 u524288
> [    0.000000] pcpu-alloc: s72448 r8192 d21760 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4111668
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=/dev/sda5 pciehp.pciehp_debug=1
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 16372092k/17299456k available (6042k kernel code, 616248k absent, 311116k reserved, 3748k data, 552k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:4352 nr_irqs:712 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.010000] Detected 2793.761 MHz processor.
> [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5587.52 BogoMIPS (lpj=27937610)
> [    0.000191] pid_max: default: 32768 minimum: 301
> [    0.001159] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.004162] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.005540] Mount-cache hash table entries: 256
> [    0.005802] CPU: Physical Processor ID: 0
> [    0.005894] CPU: Processor Core ID: 0
> [    0.005989] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.005989] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.006180] mce: CPU supports 7 MCE banks
> [    0.006281] CPU0: Thermal monitoring enabled (TM1)
> [    0.006378] using mwait in idle threads.
> [    0.006528] ACPI: Core revision 20120320
> [    0.016492] DMAR: Host address width 36
> [    0.016585] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.016685] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
> [    0.016832] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.016931] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
> [    0.017085] DMAR: RMRR base: 0x000000dad53000 end: 0x000000dad61fff
> [    0.017182] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
> [    0.017348] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [    0.017443] HPET id 0 under DRHD base 0xfed91000
> [    0.017536] HPET id 0 under DRHD base 0xfed91000
> [    0.017629] HPET id 0 under DRHD base 0xfed91000
> [    0.017721] HPET id 0 under DRHD base 0xfed91000
> [    0.017813] HPET id 0 under DRHD base 0xfed91000
> [    0.017906] HPET id 0 under DRHD base 0xfed91000
> [    0.018000] HPET id 0 under DRHD base 0xfed91000
> [    0.018093] HPET id 0 under DRHD base 0xfed91000
> [    0.018348] Enabled IRQ remapping in x2apic mode
> [    0.018442] Enabling x2apic
> [    0.018531] Enabled x2apic
> [    0.018625] Switched APIC routing to cluster x2apic.
> [    0.019140] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.119095] CPU0: Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz stepping 07
> [    0.236662] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
> [    0.236965] PEBS disabled due to CPU errata.
> [    0.237059] ... version:                3
> [    0.237150] ... bit width:              48
> [    0.237242] ... generic registers:      4
> [    0.237335] ... value mask:             0000ffffffffffff
> [    0.237429] ... max period:             000000007fffffff
> [    0.237523] ... fixed-purpose events:   3
> [    0.237615] ... event mask:             000000070000000f
> [    0.237797] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.237967] Booting Node   0, Processors  #1
> [    0.251169] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.251430]  #2
> [    0.264547] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.264725]  #3 Ok.
> [    0.277842] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.277962] Brought up 4 CPUs
> [    0.278053] Total of 4 processors activated (22350.08 BogoMIPS).
> [    0.281082] devtmpfs: initialized
> [    0.281341] PM: Registering ACPI NVS region [mem 0xda4e5000-0xda527fff] (274432 bytes)
> [    0.281498] PM: Registering ACPI NVS region [mem 0xdad68000-0xdafe7fff] (2621440 bytes)
> [    0.281765] xor: automatically using best checksumming function: generic_sse
> [    0.326526]    generic_sse: 12446.800 MB/sec
> [    0.326620] xor: using function: generic_sse (12446.800 MB/sec)
> [    0.326847] dummy: 
> [    0.327005] NET: Registered protocol family 16
> [    0.327401] ACPI: bus type pci registered
> [    0.327588] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.327737] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.335049] PCI: Using configuration type 1 for base access
> [    0.341547] bio: create slab <bio-0> at 0
> [    0.506261] raid6: int64x1   2921 MB/s
> [    0.676015] raid6: int64x2   3002 MB/s
> [    0.845742] raid6: int64x4   2722 MB/s
> [    1.015520] raid6: int64x8   1730 MB/s
> [    1.185229] raid6: sse2x1    7519 MB/s
> [    1.354973] raid6: sse2x2    9294 MB/s
> [    1.524719] raid6: sse2x4   10544 MB/s
> [    1.524720] raid6: using algorithm sse2x4 (10544 MB/s)
> [    1.524764] ACPI: Added _OSI(Module Device)
> [    1.524859] ACPI: Added _OSI(Processor Device)
> [    1.524954] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.525051] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.526336] ACPI: EC: Look up EC in DSDT
> [    1.527645] ACPI: Executed 1 blocks of module-level executable AML code
> [    1.532571] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    1.537019] ACPI: SSDT 00000000dad51698 0064F (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    1.537338] ACPI: Dynamic OEM Table Load:
> [    1.537341] ACPI: SSDT           (null) 0064F (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    1.537623] ACPI: SSDT 00000000dad52a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
> [    1.537981] ACPI: Dynamic OEM Table Load:
> [    1.537983] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
> [    1.552880] ACPI: SSDT 00000000dad50d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
> [    1.553190] ACPI: Dynamic OEM Table Load:
> [    1.553192] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
> [    1.553752] ACPI: Interpreter enabled
> [    1.553846] ACPI: (supports S0 S1 S3 S4 S5)
> [    1.554154] ACPI: Using IOAPIC for interrupt routing
> [    1.578681] ACPI: No dock devices found.
> [    1.578776] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.579246] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    1.579777] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> [    1.579875] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
> [    1.579973] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    1.580118] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
> [    1.580262] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
> [    1.580407] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
> [    1.580551] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
> [    1.582017] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
> [    1.582163] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
> [    1.582306] pci_root PNP0A08:00: host bridge window [mem 0xdfa00000-0xfeafffff]
> [    1.582451] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
> [    1.582642] PCI host bridge to bus 0000:00
> [    1.582737] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.582833] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    1.582930] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.583028] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    1.583126] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    1.583223] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    1.583320] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    1.583417] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
> [    1.583513] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
> [    1.583609] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
> [    1.583706] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    1.583809] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
> [    1.583842] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
> [    1.583852] pci 0000:00:02.0: reg 10: [mem 0xf6800000-0xf6bfffff 64bit]
> [    1.583857] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    1.583861] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
> [    1.583912] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
> [    1.583935] pci 0000:00:16.0: reg 10: [mem 0xf7e0a000-0xf7e0a00f 64bit]
> [    1.584010] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    1.584043] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
> [    1.584063] pci 0000:00:1a.0: reg 10: [mem 0xf7e08000-0xf7e083ff]
> [    1.584150] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    1.584177] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
> [    1.584191] pci 0000:00:1b.0: reg 10: [mem 0xf7e00000-0xf7e03fff 64bit]
> [    1.584258] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    1.584282] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
> [    1.584360] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    1.584387] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
> [    1.584463] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    1.584491] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
> [    1.584567] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    1.584596] pci 0000:00:1c.7: [8086:1c1e] type 01 class 0x060400
> [    1.584676] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
> [    1.584706] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
> [    1.584727] pci 0000:00:1d.0: reg 10: [mem 0xf7e07000-0xf7e073ff]
> [    1.584815] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    1.584842] pci 0000:00:1f.0: [8086:1c4b] type 00 class 0x060100
> [    1.584965] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
> [    1.584982] pci 0000:00:1f.2: reg 10: [io  0xf0b0-0xf0b7]
> [    1.584990] pci 0000:00:1f.2: reg 14: [io  0xf0a0-0xf0a3]
> [    1.584998] pci 0000:00:1f.2: reg 18: [io  0xf090-0xf097]
> [    1.585006] pci 0000:00:1f.2: reg 1c: [io  0xf080-0xf083]
> [    1.585014] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
> [    1.585022] pci 0000:00:1f.2: reg 24: [mem 0xf7e06000-0xf7e067ff]
> [    1.585065] pci 0000:00:1f.2: PME# supported from D3hot
> [    1.585084] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
> [    1.585100] pci 0000:00:1f.3: reg 10: [mem 0xf7e05000-0xf7e050ff 64bit]
> [    1.585120] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
> [    1.585189] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
> [    1.585355] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
> [    1.585375] pci 0000:05:00.0: reg 10: [io  0xe000-0xe0ff]
> [    1.585409] pci 0000:05:00.0: reg 18: [mem 0xf1104000-0xf1104fff 64bit pref]
> [    1.585431] pci 0000:05:00.0: reg 20: [mem 0xf1100000-0xf1103fff 64bit pref]
> [    1.585522] pci 0000:05:00.0: supports D1 D2
> [    1.585524] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.604633] pci 0000:00:1c.1: PCI bridge to [bus 05-06]
> [    1.604772] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
> [    1.604781] pci 0000:00:1c.1:   bridge window [mem 0xf1100000-0xf11fffff 64bit pref]
> [    1.604986] pci 0000:09:00.0: [8086:008a] type 00 class 0x028000
> [    1.605120] pci 0000:09:00.0: reg 10: [mem 0xf7d00000-0xf7d01fff 64bit]
> [    1.605806] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
> [    1.624716] pci 0000:00:1c.3: PCI bridge to [bus 09-0a]
> [    1.624815] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
> [    1.624863] pci 0000:00:1c.7: PCI bridge to [bus 11-16]
> [    1.624960] pci 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [    1.624964] pci 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [    1.624970] pci 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.624991] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    1.625163] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    1.625201] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> [    1.625240] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
> [    1.625291] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
> [    1.625420]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    1.625723]  pci0000:00: ACPI _OSC control (0x19) granted
> [    1.629954] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    1.630520] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    1.631083] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
> [    1.631644] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    1.632208] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    1.632897] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    1.633584] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    1.634144] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    1.634789] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.634940] vgaarb: loaded
> [    1.635031] vgaarb: bridge control possible 0000:00:02.0
> [    1.635257] SCSI subsystem initialized
> [    1.635423] libata version 3.00 loaded.
> [    1.635533] usbcore: registered new interface driver usbfs
> [    1.635651] usbcore: registered new interface driver hub
> [    1.635772] usbcore: registered new device driver usb
> [    1.635925] Linux media interface: v0.10
> [    1.636038] Linux video capture interface: v2.00
> [    1.636497] wmi: Mapper loaded
> [    1.636631] Advanced Linux Sound Architecture Driver Version 1.0.25.
> [    1.636726] PCI: Using ACPI for IRQ routing
> [    1.638621] PCI: pci_cache_line_size set to 64 bytes
> [    1.638736] reserve RAM buffer: 000000000009d400 - 000000000009ffff 
> [    1.638738] reserve RAM buffer: 00000000da4e5000 - 00000000dbffffff 
> [    1.638742] reserve RAM buffer: 00000000da793000 - 00000000dbffffff 
> [    1.638744] reserve RAM buffer: 00000000dacbc000 - 00000000dbffffff 
> [    1.638747] reserve RAM buffer: 000000041fe00000 - 000000041fffffff 
> [    1.638880] Bluetooth: Core ver 2.16
> [    1.638992] NET: Registered protocol family 31
> [    1.639089] Bluetooth: HCI device and connection manager initialized
> [    1.639185] Bluetooth: HCI socket layer initialized
> [    1.639279] Bluetooth: L2CAP socket layer initialized
> [    1.639376] Bluetooth: SCO socket layer initialized
> [    1.639534] cfg80211: Calling CRDA to update world regulatory domain
> [    1.639744] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    1.640188] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    1.642292] Switching to clocksource hpet
> [    1.642463] pnp: PnP ACPI init
> [    1.642562] ACPI: bus type pnp registered
> [    1.642891] pnp 00:00: [bus 00-3e]
> [    1.642893] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    1.642895] pnp 00:00: [io  0x0cf8-0x0cff]
> [    1.642897] pnp 00:00: [io  0x0d00-0xffff window]
> [    1.642899] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    1.642901] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> [    1.642902] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> [    1.642904] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> [    1.642905] pnp 00:00: [mem 0x000cc000-0x000cffff window]
> [    1.642907] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> [    1.642909] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> [    1.642911] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> [    1.642913] pnp 00:00: [mem 0x000dc000-0x000dffff window]
> [    1.642914] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> [    1.642916] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> [    1.642917] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> [    1.642919] pnp 00:00: [mem 0x000ec000-0x000effff window]
> [    1.642921] pnp 00:00: [mem 0x000f0000-0x000fffff window]
> [    1.642922] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
> [    1.642924] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    1.642989] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    1.643000] pnp 00:01: [io  0x0000-0x001f]
> [    1.643002] pnp 00:01: [io  0x0081-0x0091]
> [    1.643003] pnp 00:01: [io  0x0093-0x009f]
> [    1.643005] pnp 00:01: [io  0x00c0-0x00df]
> [    1.643007] pnp 00:01: [dma 4]
> [    1.643045] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    1.643053] pnp 00:02: [mem 0xff000000-0xffffffff]
> [    1.643093] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    1.643164] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    1.643204] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    1.643216] pnp 00:04: [io  0x002e-0x002f]
> [    1.643217] pnp 00:04: [io  0x004e-0x004f]
> [    1.643219] pnp 00:04: [io  0x0061]
> [    1.643220] pnp 00:04: [io  0x0063]
> [    1.643222] pnp 00:04: [io  0x0065]
> [    1.643223] pnp 00:04: [io  0x0067]
> [    1.643224] pnp 00:04: [io  0x0070]
> [    1.643226] pnp 00:04: [io  0x0080]
> [    1.643227] pnp 00:04: [io  0x0092]
> [    1.643228] pnp 00:04: [io  0x00b2-0x00b3]
> [    1.643230] pnp 00:04: [io  0x0680-0x069f]
> [    1.643231] pnp 00:04: [io  0x1000-0x100f]
> [    1.643232] pnp 00:04: [io  0xffff]
> [    1.643235] pnp 00:04: [io  0xffff]
> [    1.643236] pnp 00:04: [io  0x0400-0x0453]
> [    1.643237] pnp 00:04: [io  0x0458-0x047f]
> [    1.643239] pnp 00:04: [io  0x0500-0x057f]
> [    1.643240] pnp 00:04: [io  0x164e-0x164f]
> [    1.643296] system 00:04: [io  0x0680-0x069f] has been reserved
> [    1.643392] system 00:04: [io  0x1000-0x100f] has been reserved
> [    1.643489] system 00:04: [io  0xffff] has been reserved
> [    1.643584] system 00:04: [io  0xffff] has been reserved
> [    1.643679] system 00:04: [io  0x0400-0x0453] has been reserved
> [    1.643774] system 00:04: [io  0x0458-0x047f] has been reserved
> [    1.643871] system 00:04: [io  0x0500-0x057f] has been reserved
> [    1.643966] system 00:04: [io  0x164e-0x164f] has been reserved
> [    1.644062] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.644071] pnp 00:05: [io  0x0070-0x0077]
> [    1.644081] pnp 00:05: [irq 8]
> [    1.644123] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.644148] pnp 00:06: [io  0x0454-0x0457]
> [    1.644201] system 00:06: [io  0x0454-0x0457] has been reserved
> [    1.644297] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    1.644305] pnp 00:07: [io  0x00f0-0x00ff]
> [    1.644312] pnp 00:07: [irq 13]
> [    1.644354] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    1.644370] pnp 00:08: [io  0x0010-0x001f]
> [    1.644371] pnp 00:08: [io  0x0022-0x003f]
> [    1.644373] pnp 00:08: [io  0x0044-0x005f]
> [    1.644374] pnp 00:08: [io  0x0068-0x006f]
> [    1.644375] pnp 00:08: [io  0x0072-0x007f]
> [    1.644377] pnp 00:08: [io  0x0080]
> [    1.644378] pnp 00:08: [io  0x0084-0x0086]
> [    1.644379] pnp 00:08: [io  0x0088]
> [    1.644381] pnp 00:08: [io  0x008c-0x008e]
> [    1.644382] pnp 00:08: [io  0x0090-0x009f]
> [    1.644383] pnp 00:08: [io  0x00a2-0x00bf]
> [    1.644385] pnp 00:08: [io  0x00e0-0x00ef]
> [    1.644386] pnp 00:08: [io  0x04d0-0x04d1]
> [    1.644388] pnp 00:08: [mem 0xfe800000-0xfe802fff]
> [    1.644443] system 00:08: [io  0x04d0-0x04d1] has been reserved
> [    1.644540] system 00:08: [mem 0xfe800000-0xfe802fff] has been reserved
> [    1.644641] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.644659] pnp 00:09: [irq 12]
> [    1.644704] pnp 00:09: Plug and Play ACPI device, IDs DLL04b3 SYN0600 SYN0002 PNP0f13 (active)
> [    1.644717] pnp 00:0a: [io  0x0060]
> [    1.644719] pnp 00:0a: [io  0x0064]
> [    1.644720] pnp 00:0a: [io  0x0062]
> [    1.644721] pnp 00:0a: [io  0x0066]
> [    1.644728] pnp 00:0a: [irq 1]
> [    1.644770] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.644958] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
> [    1.644960] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
> [    1.644962] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
> [    1.644963] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
> [    1.644965] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
> [    1.644966] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
> [    1.644968] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
> [    1.644969] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
> [    1.644971] pnp 00:0b: [mem 0xff000000-0xffffffff]
> [    1.644972] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
> [    1.644974] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
> [    1.645039] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    1.645136] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
> [    1.645234] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
> [    1.645331] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
> [    1.645428] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
> [    1.645525] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    1.645623] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
> [    1.645718] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    1.645820] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
> [    1.645916] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    1.646014] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
> [    1.646110] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.646169] pnp 00:0c: [irq 20]
> [    1.646225] pnp 00:0c: Plug and Play ACPI device, IDs SMO8800 (active)
> [    1.646334] pnp 00:0d: [mem 0x20000000-0x201fffff]
> [    1.646335] pnp 00:0d: [mem 0x40000000-0x401fffff]
> [    1.646403] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
> [    1.646501] system 00:0d: [mem 0x40000000-0x401fffff] has been reserved
> [    1.646599] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    1.646640] pnp: PnP ACPI: found 14 devices
> [    1.646732] ACPI: ACPI bus type pnp unregistered
> [    1.654677] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
> [    1.654782] pci 0000:00:1c.1: PCI bridge to [bus 05-06]
> [    1.654877] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
> [    1.654978] pci 0000:00:1c.1:   bridge window [mem 0xf1100000-0xf11fffff 64bit pref]
> [    1.655128] pci 0000:00:1c.3: PCI bridge to [bus 09-0a]
> [    1.655226] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
> [    1.655328] pci 0000:00:1c.7: PCI bridge to [bus 11-16]
> [    1.655424] pci 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [    1.655522] pci 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [    1.655621] pci 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.655803] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.655805] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    1.655806] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    1.655808] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> [    1.655810] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> [    1.655811] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> [    1.655813] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
> [    1.655815] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
> [    1.655816] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
> [    1.655818] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
> [    1.655820] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
> [    1.655821] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
> [    1.655823] pci_bus 0000:05: resource 2 [mem 0xf1100000-0xf11fffff 64bit pref]
> [    1.655825] pci_bus 0000:09: resource 1 [mem 0xf7d00000-0xf7dfffff]
> [    1.655827] pci_bus 0000:11: resource 0 [io  0xc000-0xdfff]
> [    1.655828] pci_bus 0000:11: resource 1 [mem 0xf6c00000-0xf7cfffff]
> [    1.655830] pci_bus 0000:11: resource 2 [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.655900] NET: Registered protocol family 2
> [    1.656257] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    1.657246] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    1.658461] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    1.658685] TCP: Hash tables configured (established 524288 bind 65536)
> [    1.658782] TCP: reno registered
> [    1.658890] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    1.659038] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    1.659240] NET: Registered protocol family 1
> [    1.659426] RPC: Registered named UNIX socket transport module.
> [    1.659523] RPC: Registered udp transport module.
> [    1.659616] RPC: Registered tcp transport module.
> [    1.659708] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    1.659811] pci 0000:00:02.0: Boot video device
> [    1.659841] pci 0000:00:1a.0: EHCI: BIOS handoff
> [    1.782339] pci 0000:00:1d.0: EHCI: BIOS handoff
> [    1.902107] PCI: CLS 64 bytes, default 64
> [    1.902200] DMAR: No ATSR found
> [    1.902315] IOMMU 0 0xfed90000: using Queued invalidation
> [    1.902411] IOMMU 1 0xfed91000: using Queued invalidation
> [    1.902505] IOMMU: Setting RMRR:
> [    1.902606] IOMMU: Setting identity map for device 0000:00:02.0 [0xdb800000 - 0xdf9fffff]
> [    1.903106] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdad53000 - 0xdad61fff]
> [    1.903270] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdad53000 - 0xdad61fff]
> [    1.903424] IOMMU: Prepare 0-16MiB unity mapping for LPC
> [    1.903525] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
> [    1.903956] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> [    1.906708] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.906809] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.906911] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.907013] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1b
> [    1.907154] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    1.908188] sha1_ssse3: Using AVX optimized SHA-1 implementation
> [    1.909412] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.911292] DLM installed
> [    1.911368] NFS: Registering the id_resolver key type
> [    1.911609] msgmni has been set to 32105
> [    1.912924] NET: Registered protocol family 38
> [    1.913018] async_tx: api initialized (async)
> [    1.913153] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    1.913299] io scheduler noop registered
> [    1.913391] io scheduler deadline registered
> [    1.913500] io scheduler cfq registered (default)
> [    1.913831] pcieport 0000:00:1c.7: irq 42 for MSI/MSI-X
> [    1.914011] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    1.914189] pciehp 0000:00:1c.7:pcie04: Hotplug Controller:
> [    1.914285] pciehp 0000:00:1c.7:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.7 IRQ 42
> [    1.914430] pciehp 0000:00:1c.7:pcie04:   Vendor ID            : 0x8086
> [    1.914527] pciehp 0000:00:1c.7:pcie04:   Device ID            : 0x1c1e
> [    1.914624] pciehp 0000:00:1c.7:pcie04:   Subsystem ID         : 0x04b3
> [    1.914721] pciehp 0000:00:1c.7:pcie04:   Subsystem Vendor ID  : 0x1028
> [    1.914817] pciehp 0000:00:1c.7:pcie04:   PCIe Cap offset      : 0x40
> [    1.914915] pciehp 0000:00:1c.7:pcie04:   PCI resource [13]     : [io  0xc000-0xdfff]
> [    1.915061] pciehp 0000:00:1c.7:pcie04:   PCI resource [14]     : [mem 0xf6c00000-0xf7cfffff]
> [    1.915208] pciehp 0000:00:1c.7:pcie04:   PCI resource [15]     : [mem 0xf0000000-0xf10fffff 64bit pref]
> [    1.915356] pciehp 0000:00:1c.7:pcie04: Slot Capabilities      : 0x003cb260
> [    1.915454] pciehp 0000:00:1c.7:pcie04:   Physical Slot Number : 7
> [    1.915551] pciehp 0000:00:1c.7:pcie04:   Attention Button     :  no
> [    1.915647] pciehp 0000:00:1c.7:pcie04:   Power Controller     :  no
> [    1.915743] pciehp 0000:00:1c.7:pcie04:   MRL Sensor           :  no
> [    1.915840] pciehp 0000:00:1c.7:pcie04:   Attention Indicator  :  no
> [    1.915936] pciehp 0000:00:1c.7:pcie04:   Power Indicator      :  no
> [    1.916033] pciehp 0000:00:1c.7:pcie04:   Hot-Plug Surprise    : yes
> [    1.916128] pciehp 0000:00:1c.7:pcie04:   EMI Present          :  no
> [    1.916225] pciehp 0000:00:1c.7:pcie04:   Command Completed    :  no
> [    1.916322] pciehp 0000:00:1c.7:pcie04: Slot Status            : 0x0000
> [    1.916420] pciehp 0000:00:1c.7:pcie04: Slot Control           : 0x0000
> [    1.916517] pciehp 0000:00:1c.7:pcie04: Link Active Reporting supported
> [    1.916524] pciehp 0000:00:1c.7:pcie04: HPC vendor_id 8086 device_id 1c1e ss_vid 1028 ss_did 4b3
> [    1.916672] pciehp 0000:00:1c.7:pcie04: Registering domain:bus:dev=0000:11:00 sun=7
> [    1.916718] pciehp 0000:00:1c.7:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read 28
> [    1.916719] pciehp 0000:00:1c.7:pcie04: service driver pciehp loaded
> [    1.916745] pciehp: pcie_port_service_register = 0
> [    1.916746] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    1.916843] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    1.917412] intel_idle: MWAIT substates: 0x21120
> [    1.917413] intel_idle: v0.4 model 0x2A
> [    1.917415] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    1.917512] ACPI: AC Adapter [AC] (on-line)
> [    1.917714] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    1.920604] ACPI: Lid Switch [LID0]
> [    1.920755] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    1.920903] ACPI: Power Button [PWRB]
> [    1.921048] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    1.921195] ACPI: Sleep Button [SBTN]
> [    1.921340] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [    1.921485] ACPI: Power Button [PWRF]
> [    1.921828] ACPI: Requesting acpi_cpufreq
> [    1.932178] thermal LNXTHERM:00: registered as thermal_zone0
> [    1.932274] ACPI: Thermal Zone [THM] (70 C)
> [    1.932482] GHES: HEST is not enabled!
> [    1.955318] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    1.956123] Non-volatile memory driver v1.3
> [    1.956541] i8k: unable to get SMM BIOS version
> [    1.959784] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
> [    1.959988] Linux agpgart interface v0.103
> [    1.960125] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
> [    1.960301] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    1.961496] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
> [    1.961734] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> [    1.961903] ipmi message handler version 39.2
> [    1.962048] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    1.962050] Hangcheck: Using getrawmonotonic().
> [    1.962104] [drm] Initialized drm 1.1.0 20060810
> [    1.962479] i915 0000:00:02.0: setting latency timer to 64
> [    1.982290] ACPI: Battery Slot [BAT0] (battery present)
> [    1.999173] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> [    1.999319] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [    1.999731] i915 0000:00:02.0: irq 43 for MSI/MSI-X
> [    1.999739] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    1.999837] [drm] Driver supports precise vblank timestamp query.
> [    1.999960] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    2.423247] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [    2.900533] Refined TSC clocksource calibration: 2793.653 MHz.
> [    2.900662] Switching to clocksource tsc
> [    2.977569] fbcon: inteldrmfb (fb0) is primary device
> [    3.478211] Console: switching to colour frame buffer device 170x48
> [    3.480621] fb0: inteldrmfb frame buffer device
> [    3.480622] drm: registered panic notifier
> [    3.481852] acpi device:34: registered as cooling_device4
> [    3.482085] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
> [    3.482124] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    3.482184] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    3.482994] loop: module loaded
> [    3.483123] ahci 0000:00:1f.2: version 3.0
> [    3.483170] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
> [    3.483196] ahci: SSS flag set, parallel bus scan disabled
> [    3.499678] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x31 impl SATA mode
> [    3.499780] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
> [    3.499818] ahci 0000:00:1f.2: setting latency timer to 64
> [    3.540337] scsi0 : ahci
> [    3.540445] scsi1 : ahci
> [    3.540534] scsi2 : ahci
> [    3.540625] scsi3 : ahci
> [    3.540714] scsi4 : ahci
> [    3.540802] scsi5 : ahci
> [    3.541131] ata2: SATA max UDMA/133 abar m2048@0xf7e06000 port 0xf7e06100 irq 44
> [    3.541162] ata3: DUMMY
> [    3.542040] ata4: DUMMY
> [    3.542903] ata5: DUMMY
> [    3.543748] ata6: SATA max UDMA/133 abar m2048@0xf7e06000 port 0xf7e06300 irq 44
> [    3.544619] ata7: SATA max UDMA/133 abar m2048@0xf7e06000 port 0xf7e06380 irq 44
> [    3.545592] tun: Universal TUN/TAP device driver, 1.6
> [    3.546456] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    3.547373] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    3.548348] r8169 0000:05:00.0: irq 45 for MSI/MSI-X
> [    3.548499] r8169 0000:05:00.0: eth0: RTL8168e/8111e at 0xffffc900065c8000, 18:03:73:a0:6f:6a, XID 0c200000 IRQ 45
> [    3.549394] r8169 0000:05:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    3.550330] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
> [    3.551264] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.552138] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
> [    3.552164] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [    3.552167] ehci_hcd 0000:00:1a.0: EHCI Host Controller
> [    3.553033] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    3.553908] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
> [    3.553911] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
> [    3.553928] ehci_hcd 0000:00:1a.0: support lpm
> [    3.553937] ehci_hcd 0000:00:1a.0: debug port 2
> [    3.554799] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
> [    3.558693] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
> [    3.558694] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
> [    3.558707] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7e08000
> [    3.559575] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
> [    3.579528] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    3.580481] usb usb1: default language 0x0409
> [    3.580486] usb usb1: udev 1, busnum 1, minor = 0
> [    3.580488] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.581338] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.582184] usb usb1: Product: EHCI Host Controller
> [    3.583024] usb usb1: Manufacturer: Linux 3.4.0-rc5-default ehci_hcd
> [    3.583871] usb usb1: SerialNumber: 0000:00:1a.0
> [    3.584796] usb usb1: usb_probe_device
> [    3.584798] usb usb1: configuration #1 chosen from 1 choice
> [    3.584804] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [    3.584837] hub 1-0:1.0: usb_probe_interface
> [    3.584838] hub 1-0:1.0: usb_probe_interface - got id
> [    3.584840] hub 1-0:1.0: USB hub found
> [    3.585682] hub 1-0:1.0: 2 ports detected
> [    3.586533] hub 1-0:1.0: standalone hub
> [    3.586535] hub 1-0:1.0: no power switching (usb 1.0)
> [    3.586536] hub 1-0:1.0: individual port over-current protection
> [    3.586538] hub 1-0:1.0: power on to power good time: 20ms
> [    3.586541] hub 1-0:1.0: local power source is good
> [    3.586543] hub 1-0:1.0: trying to enable port power on non-switchable hub
> [    3.586603] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [    3.586606] ehci_hcd 0000:00:1d.0: EHCI Host Controller
> [    3.587460] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    3.588316] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
> [    3.588320] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
> [    3.588336] ehci_hcd 0000:00:1d.0: support lpm
> [    3.588345] ehci_hcd 0000:00:1d.0: debug port 2
> [    3.589198] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
> [    3.593066] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
> [    3.593067] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
> [    3.593079] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7e07000
> [    3.593934] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
> [    3.609482] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    3.610427] usb usb2: default language 0x0409
> [    3.610432] usb usb2: udev 1, busnum 2, minor = 128
> [    3.610434] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.611273] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.612106] usb usb2: Product: EHCI Host Controller
> [    3.612933] usb usb2: Manufacturer: Linux 3.4.0-rc5-default ehci_hcd
> [    3.613756] usb usb2: SerialNumber: 0000:00:1d.0
> [    3.614643] usb usb2: usb_probe_device
> [    3.614645] usb usb2: configuration #1 chosen from 1 choice
> [    3.614650] usb usb2: adding 2-0:1.0 (config #1, interface 0)
> [    3.614680] hub 2-0:1.0: usb_probe_interface
> [    3.614682] hub 2-0:1.0: usb_probe_interface - got id
> [    3.614684] hub 2-0:1.0: USB hub found
> [    3.615489] hub 2-0:1.0: 2 ports detected
> [    3.616283] hub 2-0:1.0: standalone hub
> [    3.616284] hub 2-0:1.0: no power switching (usb 1.0)
> [    3.616285] hub 2-0:1.0: individual port over-current protection
> [    3.616287] hub 2-0:1.0: power on to power good time: 20ms
> [    3.616290] hub 2-0:1.0: local power source is good
> [    3.616292] hub 2-0:1.0: trying to enable port power on non-switchable hub
> [    3.616354] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    3.617162] ohci_hcd: block sizes: ed 80 td 96
> [    3.617234] usbcore: registered new interface driver uas
> [    3.618101] usbcore: registered new interface driver usbserial
> [    3.618946] usbcore: registered new interface driver usbserial_generic
> [    3.619805] USB Serial support registered for generic
> [    3.620649] usbserial: USB Serial Driver core
> [    3.621494] usbcore: registered new interface driver pl2303
> [    3.622329] USB Serial support registered for pl2303
> [    3.623231] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2] at 0x60,0x64 irq 1,12
> [    3.626274] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.627130] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.628098] mousedev: PS/2 mouse device common for all mice
> [    3.629202] rtc_cmos 00:05: RTC can wake from S4
> [    3.630192] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    3.631067] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    3.631916] i2c /dev entries driver
> [    3.633094] gspca_main: v2.14.0 registered
> [    3.633923] usbcore: registered new interface driver uvcvideo
> [    3.634734] USB Video Class driver (1.1.1)
> [    3.635612] coretemp coretemp.0: TjMax is 100 degrees C
> [    3.635619] coretemp coretemp.0: TjMax is 100 degrees C
> [    3.635628] coretemp coretemp.0: TjMax is 100 degrees C
> [    3.635656] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
> [    3.636541] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
> [    3.637404] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    3.638221] iTCO_vendor_support: vendor-support=0
> [    3.639058] md: linear personality registered for level -1
> [    3.639886] md: raid0 personality registered for level 0
> [    3.640709] md: raid1 personality registered for level 1
> [    3.641516] md: raid10 personality registered for level 10
> [    3.642319] md: raid6 personality registered for level 6
> [    3.643131] md: raid5 personality registered for level 5
> [    3.643925] md: raid4 personality registered for level 4
> [    3.644748] device-mapper: uevent: version 1.0.3
> [    3.645601] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    3.646417] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
> [    3.647264] device-mapper: dm-log-userspace: version 1.1.0 loaded
> [    3.648116] usbcore: registered new interface driver btusb
> [    3.649019] cpuidle: using governor ladder
> [    3.649950] cpuidle: using governor menu
> [    3.650814] sdhci: Secure Digital Host Controller Interface driver
> [    3.651628] sdhci: Copyright(c) Pierre Ossman
> [    3.653027] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    3.654852] usbcore: registered new interface driver usbhid
> [    3.655679] usbhid: USB HID core driver
> [    3.656565] mei 0000:00:16.0: setting latency timer to 64
> [    3.656611] mei 0000:00:16.0: irq 46 for MSI/MSI-X
> [    3.680883] input: Dell WMI hotkeys as /devices/virtual/input/input6
> [    3.680887] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
> [    3.680891] hub 1-0:1.0: port 1: status 0501 change 0001
> [    3.692011] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
> [    3.692301] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [    3.709379] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
> [    3.709399] hub 2-0:1.0: port 1: status 0501 change 0001
> [    3.779406] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
> [    3.779417] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [    3.839433] ehci_hcd 0000:00:1a.0: port 1 high speed
> [    3.839439] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    3.889151] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.895136] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    3.896375] ata2.00: ATA-8: WDC WD7500BPKT-75PK4T0, 01.01A01, max UDMA/133
> [    3.897347] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    3.899117] usb 1-1: new high-speed USB device number 2 using ehci_hcd
> [    3.903267] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    3.904530] ata2.00: configured for UDMA/133
> [    3.919381] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-7 01.0 PQ: 0 ANSI: 5
> [    3.920825] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> [    3.920989] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.922702] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    3.923694] sd 0:0:0:0: [sda] Write Protect is off
> [    3.924605] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.924682] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.959256] ehci_hcd 0000:00:1a.0: port 1 high speed
> [    3.959261] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    4.022504]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> [    4.024391] sd 0:0:0:0: [sda] Attached SCSI disk
> [    4.049079] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
> [    4.049091] ehci_hcd 0000:00:1a.0: LPM: no device attached
> [    4.049443] usb 1-1: udev 2, busnum 1, minor = 1
> [    4.049453] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    4.050457] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.051638] usb 1-1: usb_probe_device
> [    4.051642] usb 1-1: configuration #1 chosen from 1 choice
> [    4.051831] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
> [    4.052036] hub 1-1:1.0: usb_probe_interface
> [    4.052039] hub 1-1:1.0: usb_probe_interface - got id
> [    4.052041] hub 1-1:1.0: USB hub found
> [    4.053191] hub 1-1:1.0: 6 ports detected
> [    4.054175] hub 1-1:1.0: standalone hub
> [    4.054176] hub 1-1:1.0: individual port power switching
> [    4.054178] hub 1-1:1.0: individual port over-current protection
> [    4.054179] hub 1-1:1.0: Single TT
> [    4.054181] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
> [    4.054182] hub 1-1:1.0: power on to power good time: 100ms
> [    4.054428] hub 1-1:1.0: local power source is good
> [    4.054439] hub 1-1:1.0: enabling power on all ports
> [    4.055250] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
> [    4.055274] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [    4.109031] ehci_hcd 0000:00:1d.0: port 1 high speed
> [    4.109036] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    4.149417] hub 1-1:1.0: port 5: status 0101 change 0001
> [    4.168750] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> [    4.228852] ehci_hcd 0000:00:1d.0: port 1 high speed
> [    4.228858] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    4.248629] usb 1-1: link qh256-0001/ffff88040d9a0940 start 1 [1/0 us]
> [    4.268586] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    4.272997] ata6.00: ATAPI: PLDS DVD+/-RW DS-8A8SH, KD11, max UDMA/100
> [    4.279386] ata6.00: configured for UDMA/100
> [    4.292995] scsi 4:0:0:0: CD-ROM            PLDS     DVD+-RW DS-8A8SH KD11 PQ: 0 ANSI: 5
> [    4.307888] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    4.307899] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    4.309159] sr 4:0:0:0: Attached scsi CD-ROM sr0
> [    4.309263] sr 4:0:0:0: Attached scsi generic sg1 type 5
> [    4.311140] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
> [    4.318665] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
> [    4.318676] ehci_hcd 0000:00:1d.0: LPM: no device attached
> [    4.319040] usb 2-1: udev 2, busnum 2, minor = 129
> [    4.319049] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    4.320110] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.321333] usb 2-1: usb_probe_device
> [    4.321337] usb 2-1: configuration #1 chosen from 1 choice
> [    4.321553] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
> [    4.321758] hub 2-1:1.0: usb_probe_interface
> [    4.321760] hub 2-1:1.0: usb_probe_interface - got id
> [    4.321763] hub 2-1:1.0: USB hub found
> [    4.322870] hub 2-1:1.0: 8 ports detected
> [    4.323845] hub 2-1:1.0: standalone hub
> [    4.323846] hub 2-1:1.0: individual port power switching
> [    4.323847] hub 2-1:1.0: individual port over-current protection
> [    4.323849] hub 2-1:1.0: Single TT
> [    4.323850] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
> [    4.323852] hub 2-1:1.0: power on to power good time: 100ms
> [    4.324113] hub 2-1:1.0: local power source is good
> [    4.324123] hub 2-1:1.0: enabling power on all ports
> [    4.325186] hub 1-1:1.0: state 7 ports 6 chg 0020 evt 0000
> [    4.325343] hub 1-1:1.0: port 5, status 0101, change 0000, 12 Mb/s
> [    4.337192] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [    4.338290] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [    4.339461] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [    4.341643] TCP: cubic registered
> [    4.342650] NET: Registered protocol family 17
> [    4.343673] Bluetooth: RFCOMM TTY layer initialized
> [    4.344679] Bluetooth: RFCOMM socket layer initialized
> [    4.345671] Bluetooth: RFCOMM ver 1.11
> [    4.346648] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    4.347627] Bluetooth: BNEP filters: protocol multicast
> [    4.348609] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    4.349914] sctp: Hash tables configured (established 65536 bind 65536)
> [    4.351017] Registering the dns_resolver key type
> [    4.352259] PM: Checking hibernation image partition /dev/sda6
> [    4.352264] PM: Hibernation image partition 8:6 present
> [    4.352265] PM: Looking for hibernation image.
> [    4.353799] PM: Image not found (code -22)
> [    4.353804] PM: Hibernation image not present or could not be loaded.
> [    4.353826] registered taskstats version 1
> [    4.355836] rtc_cmos 00:05: setting system clock to 2012-05-02 17:41:01 UTC (1335980461)
> [    4.357615] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> [    4.358654] ALSA device list:
> [    4.359500]   #0: HDA Intel PCH at 0xf7e00000 irq 47
> [    4.398524] usb 1-1.5: new high-speed USB device number 3 using ehci_hcd
> [    4.418724] hub 2-1:1.0: port 3: status 0101 change 0001
> [    4.419264] hub 2-1:1.0: port 6: status 0101 change 0001
> [    4.514698] usb 1-1.5: skipped 1 descriptor after configuration
> [    4.514709] usb 1-1.5: skipped 6 descriptors after interface
> [    4.514717] usb 1-1.5: skipped 1 descriptor after endpoint
> [    4.514723] usb 1-1.5: skipped 19 descriptors after interface
> [    4.514739] usb 1-1.5: skipped 1 descriptor after endpoint
> [    4.514957] usb 1-1.5: default language 0x0409
> [    4.516275] usb 1-1.5: udev 3, busnum 1, minor = 2
> [    4.516285] usb 1-1.5: New USB device found, idVendor=05ca, idProduct=1820
> [    4.517193] usb 1-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    4.518000] usb 1-1.5: Product: Laptop_Integrated_Webcam_FHD
> [    4.518826] usb 1-1.5: Manufacturer: CN01MWM9724871A4KB28A00
> [    4.519660] usb 2-1: link qh256-0001/ffff88040d88c540 start 1 [1/0 us]
> [    4.519851] usb 1-1.5: usb_probe_device
> [    4.519855] usb 1-1.5: configuration #1 chosen from 1 choice
> [    4.519998] usb 1-1.5: adding 1-1.5:1.0 (config #1, interface 0)
> [    4.520675] usbserial_generic 1-1.5:1.0: usb_probe_interface
> [    4.520677] usbserial_generic 1-1.5:1.0: usb_probe_interface - got id
> [    4.520701] uvcvideo 1-1.5:1.0: usb_probe_interface
> [    4.520703] uvcvideo 1-1.5:1.0: usb_probe_interface - got id
> [    4.520714] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_FHD (05ca:1820)
> [    4.523519] input: Laptop_Integrated_Webcam_FHD as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0/input/input11
> [    4.524455] usb 1-1.5: adding 1-1.5:1.1 (config #1, interface 1)
> [    4.524530] hub 2-1:1.0: state 7 ports 8 chg 0048 evt 0000
> [    4.524683] hub 2-1:1.0: port 3, status 0101, change 0000, 12 Mb/s
> [    4.598213] usb 2-1.3: new full-speed USB device number 3 using ehci_hcd
> [    4.633947] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input12
> [    4.648845] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input13
> [    4.658017] ata7: SATA link down (SStatus 0 SControl 300)
> [    4.658992] md: Waiting for all devices to be available before autodetect
> [    4.659841] md: If you don't use raid, use raid=noautodetect
> [    4.661067] md: Autodetecting RAID arrays.
> [    4.661937] md: Scanned 0 and added 0 devices.
> [    4.662806] md: autorun ...
> [    4.663668] md: ... autorun DONE.
> [    4.707903] usb 2-1.3: ep0 maxpacket = 8
> [    4.709082] usb 2-1.3: default language 0x0409
> [    4.709346] usb 2-1.3: udev 3, busnum 2, minor = 130
> [    4.709356] usb 2-1.3: New USB device found, idVendor=138a, idProduct=0011
> [    4.710270] usb 2-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
> [    4.711090] usb 2-1.3: SerialNumber: 56ed5821afe2
> [    4.712109] usb 2-1.3: usb_probe_device
> [    4.712113] usb 2-1.3: configuration #1 chosen from 1 choice
> [    4.712502] usb 2-1.3: adding 2-1.3:1.0 (config #1, interface 0)
> [    4.712692] usbserial_generic 2-1.3:1.0: usb_probe_interface
> [    4.712694] usbserial_generic 2-1.3:1.0: usb_probe_interface - got id
> [    4.712949] hub 2-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
> [    4.758230] EXT3-fs (sda5): recovery required on readonly filesystem
> [    4.759039] EXT3-fs (sda5): write access will be enabled during recovery
> [    4.788062] usb 2-1.6: new high-speed USB device number 4 using ehci_hcd
> [    4.905146] usb 2-1.6: default language 0x0409
> [    4.910470] usb 2-1.6: udev 4, busnum 2, minor = 131
> [    4.910481] usb 2-1.6: New USB device found, idVendor=0bda, idProduct=0138
> [    4.911379] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    4.912187] usb 2-1.6: Product: USB2.0-CRW
> [    4.912987] usb 2-1.6: Manufacturer: Generic
> [    4.913766] usb 2-1.6: SerialNumber: 20090516388200000
> [    4.914712] usb 2-1.6: usb_probe_device
> [    4.914714] usb 2-1.6: configuration #1 chosen from 1 choice
> [    4.916986] usb 2-1.6: adding 2-1.6:1.0 (config #1, interface 0)
> [    4.920646] uas 2-1.6:1.0: usb_probe_interface
> [    4.920647] uas 2-1.6:1.0: usb_probe_interface - got id
> [    4.920655] usbserial_generic 2-1.6:1.0: usb_probe_interface
> [    4.920656] usbserial_generic 2-1.6:1.0: usb_probe_interface - got id
> [    4.920700] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0008
> [    5.626213] kjournald starting.  Commit interval 5 seconds
> [    5.626931] EXT3-fs (sda5): recovery complete
> [    5.626934] EXT3-fs (sda5): mounted filesystem with writeback data mode
> [    5.626945] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
> [    5.653004] devtmpfs: mounted
> [    5.654027] Freeing unused kernel memory: 552k freed
> [    7.154409] usb 1-1.5: usb auto-suspend, wakeup 0
> [    9.171232] hub 1-1:1.0: hub_suspend
> [    9.171253] usb 1-1: unlink qh256-0001/ffff88040d9a0940 start 1 [1/0 us]
> [    9.171534] usb 1-1: usb auto-suspend, wakeup 1
> [    9.210684] udevd[1767]: starting version 171
> [   10.075482] usb 1-1: usb auto-resume
> [   10.109938] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [   10.129779] usb 1-1: finish resume
> [   10.130052] hub 1-1:1.0: hub_resume
> [   10.130661] hub 1-1:1.0: port 5: status 0507 change 0000
> [   10.130789] ehci_hcd 0000:00:1a.0: reused qh ffff88040d9a0940 schedule
> [   10.130798] usb 1-1: link qh256-0001/ffff88040d9a0940 start 1 [1/0 us]
> [   10.130960] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0000
> [   10.131034] usb 1-1.5: usb auto-resume
> [   10.190139] usb 1-1.5: finish resume
> [   10.190719] usb 1-1.5: link qh16-0001/ffff88040db961c0 start 2 [1/0 us]
> [   10.190834] usb 1-1.5: unlink qh16-0001/ffff88040db961c0 start 2 [1/0 us]
> [   11.564456] ACPI Warning: 0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
> [   11.564463] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   12.187035] usb 1-1.5: usb auto-suspend, wakeup 0
> [   12.249524] Initializing USB Mass Storage driver...
> [   12.249551] usb-storage 2-1.6:1.0: usb_probe_interface
> [   12.249554] usb-storage 2-1.6:1.0: usb_probe_interface - got id
> [   12.249608] scsi6 : usb-storage 2-1.6:1.0
> [   12.249689] usbcore: registered new interface driver usb-storage
> [   12.249690] USB Mass Storage support registered.
> [   12.654674] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
> [   12.654676] Copyright(c) 2003-2012 Intel Corporation
> [   12.654822] iwlwifi 0000:09:00.0: pci_resource_len = 0x00002000
> [   12.654823] iwlwifi 0000:09:00.0: pci_resource_base = ffffc900066e4000
> [   12.654825] iwlwifi 0000:09:00.0: HW Revision ID = 0x34
> [   12.654913] iwlwifi 0000:09:00.0: irq 48 for MSI/MSI-X
> [   12.839348] iwlwifi 0000:09:00.0: loaded firmware version 17.168.5.2 build 35905
> [   12.839455] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   12.839458] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [   12.839466] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [   12.839468] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
> [   12.839470] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_P2P disabled
> [   12.839472] iwlwifi 0000:09:00.0: Detected Intel(R) Centrino(R) Wireless-N 1030 BGN, REV=0xB0
> [   12.839528] iwlwifi 0000:09:00.0: L1 Disabled; Enabling L0S
> [   12.856655] iwlwifi 0000:09:00.0: device EEPROM VER=0x71a, CALIB=0x6
> [   12.856657] iwlwifi 0000:09:00.0: Device SKU: 0x150
> [   12.856659] iwlwifi 0000:09:00.0: Valid Tx ant: 0x1, Valid Rx ant: 0x3
> [   12.856670] iwlwifi 0000:09:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
> [   12.856826] Registered led device: phy0-led
> [   12.856879] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   13.248036] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
> [   13.248179] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [   13.253760] sd 6:0:0:0: [sdb] Attached SCSI removable disk
> [   13.579753] EXT3-fs (sda5): using internal journal
> [   13.758302] Adding 4998972k swap on /dev/sda6.  Priority:-1 extents:1 across:4998972k 
> [   14.203789] hub 1-1:1.0: hub_suspend
> [   14.203811] usb 1-1: unlink qh256-0001/ffff88040d9a0940 start 1 [1/0 us]
> [   14.204007] usb 1-1: usb auto-suspend, wakeup 1
> [   16.220795] hub 1-0:1.0: hub_suspend
> [   16.220816] usb usb1: bus auto-suspend, wakeup 1
> [   16.220823] ehci_hcd 0000:00:1a.0: suspend root hub
> [   17.065994] r8169 0000:05:00.0: eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-2)
> [   17.093205] r8169 0000:05:00.0: eth0: link down
> [   17.093227] r8169 0000:05:00.0: eth0: link down
> [   18.812089] r8169 0000:05:00.0: eth0: link up
> [   23.300083] microcode: CPU0 updated to revision 0x25, date = 2011-10-11
> [   23.300464] microcode: CPU1 updated to revision 0x25, date = 2011-10-11
> [   23.300856] microcode: CPU2 updated to revision 0x25, date = 2011-10-11
> [   23.301203] microcode: CPU3 updated to revision 0x25, date = 2011-10-11
> [   23.370997] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, -vsync)
> [   25.128898] r8169 0000:05:00.0: eth0: link down
> [   27.972053] r8169 0000:05:00.0: eth0: link up
> [   28.852739] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, -vsync)
> [   83.806939] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [   83.806942] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [   83.806946] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [   83.807493] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [   83.807721] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [   83.909944] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [   83.910050] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [   83.910102] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [   83.910355] pci 0000:11:00.0: PME# supported from D0 D3hot
> [   83.929977] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [   83.930559] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> [   83.931085] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [   83.931622] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [   83.932165] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [   83.932843] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [   83.933529] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [   83.934093] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 3
> [   83.934693] xhci_hcd 0000:11:00.0: xHCI capability registers at ffffc90006970000:
> [   83.934699] xhci_hcd 0000:11:00.0: CAPLENGTH AND HCIVERSION 0x960020:
> [   83.934701] xhci_hcd 0000:11:00.0: CAPLENGTH: 0x20
> [   83.934702] xhci_hcd 0000:11:00.0: HCIVERSION: 0x96
> [   83.934707] xhci_hcd 0000:11:00.0: HCSPARAMS 1: 0x4000820
> [   83.934709] xhci_hcd 0000:11:00.0:   Max device slots: 32
> [   83.934710] xhci_hcd 0000:11:00.0:   Max interrupters: 8
> [   83.934711] xhci_hcd 0000:11:00.0:   Max ports: 4
> [   83.934716] xhci_hcd 0000:11:00.0: HCSPARAMS 2: 0x11
> [   83.934717] xhci_hcd 0000:11:00.0:   Isoc scheduling threshold: 1
> [   83.934718] xhci_hcd 0000:11:00.0:   Maximum allowed segments in event ring: 1
> [   83.934724] xhci_hcd 0000:11:00.0: HCSPARAMS 3 0x0:
> [   83.934725] xhci_hcd 0000:11:00.0:   Worst case U1 device exit latency: 0
> [   83.934727] xhci_hcd 0000:11:00.0:   Worst case U2 device exit latency: 0
> [   83.934732] xhci_hcd 0000:11:00.0: HCC PARAMS 0x14042cb:
> [   83.934734] xhci_hcd 0000:11:00.0:   HC generates 64 bit addresses
> [   83.934735] xhci_hcd 0000:11:00.0:   FIXME: more HCCPARAMS debugging
> [   83.934741] xhci_hcd 0000:11:00.0: RTSOFF 0x600:
> [   83.934742] xhci_hcd 0000:11:00.0: xHCI operational registers at ffffc90006970020:
> [   83.934748] xhci_hcd 0000:11:00.0: USBCMD 0x0:
> [   83.934749] xhci_hcd 0000:11:00.0:   HC is being stopped
> [   83.934750] xhci_hcd 0000:11:00.0:   HC has finished hard reset
> [   83.934751] xhci_hcd 0000:11:00.0:   Event Interrupts disabled
> [   83.934752] xhci_hcd 0000:11:00.0:   Host System Error Interrupts disabled
> [   83.934754] xhci_hcd 0000:11:00.0:   HC has finished light reset
> [   83.934759] xhci_hcd 0000:11:00.0: USBSTS 0x11:
> [   83.934760] xhci_hcd 0000:11:00.0:   Event ring is empty
> [   83.934762] xhci_hcd 0000:11:00.0:   No Host System Error
> [   83.934763] xhci_hcd 0000:11:00.0:   HC is halted
> [   83.934769] xhci_hcd 0000:11:00.0: ffffc90006970420 port status reg = 0x2a0
> [   83.934775] xhci_hcd 0000:11:00.0: ffffc90006970424 port power reg = 0x0
> [   83.934781] xhci_hcd 0000:11:00.0: ffffc90006970428 port link reg = 0x0
> [   83.934788] xhci_hcd 0000:11:00.0: ffffc9000697042c port reserved reg = 0x0
> [   83.934794] xhci_hcd 0000:11:00.0: ffffc90006970430 port status reg = 0x2a0
> [   83.934800] xhci_hcd 0000:11:00.0: ffffc90006970434 port power reg = 0x0
> [   83.934806] xhci_hcd 0000:11:00.0: ffffc90006970438 port link reg = 0x0
> [   83.934812] xhci_hcd 0000:11:00.0: ffffc9000697043c port reserved reg = 0x0
> [   83.934818] xhci_hcd 0000:11:00.0: ffffc90006970440 port status reg = 0x2a0
> [   83.934824] xhci_hcd 0000:11:00.0: ffffc90006970444 port power reg = 0x0
> [   83.934830] xhci_hcd 0000:11:00.0: ffffc90006970448 port link reg = 0x0
> [   83.934836] xhci_hcd 0000:11:00.0: ffffc9000697044c port reserved reg = 0x0
> [   83.934842] xhci_hcd 0000:11:00.0: ffffc90006970450 port status reg = 0x202e1
> [   83.934848] xhci_hcd 0000:11:00.0: ffffc90006970454 port power reg = 0x0
> [   83.934854] xhci_hcd 0000:11:00.0: ffffc90006970458 port link reg = 0x0
> [   83.934860] xhci_hcd 0000:11:00.0: ffffc9000697045c port reserved reg = 0x0
> [   83.934862] xhci_hcd 0000:11:00.0: // Halt the HC
> [   83.934874] xhci_hcd 0000:11:00.0: Resetting HCD
> [   83.934880] xhci_hcd 0000:11:00.0: // Reset the HC
> [   83.934929] xhci_hcd 0000:11:00.0: Wait for controller to be ready for doorbell rings
> [   83.934934] xhci_hcd 0000:11:00.0: Reset complete
> [   83.934940] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [   83.934941] xhci_hcd 0000:11:00.0: Calling HCD init
> [   83.934942] xhci_hcd 0000:11:00.0: xhci_init
> [   83.934943] xhci_hcd 0000:11:00.0: xHCI doesn't need link TRB QUIRK
> [   83.934950] xhci_hcd 0000:11:00.0: Supported page size register = 0x1
> [   83.934951] xhci_hcd 0000:11:00.0: Supported page size of 4K
> [   83.934952] xhci_hcd 0000:11:00.0: HCD page size set to 4K
> [   83.934958] xhci_hcd 0000:11:00.0: // xHC can handle at most 32 device slots.
> [   83.934964] xhci_hcd 0000:11:00.0: // Setting Max device slots reg = 0x20.
> [   83.934986] xhci_hcd 0000:11:00.0: // Device context base array address = 0xfffff000 (DMA), ffff88040edf6000 (virt)
> [   83.934991] xhci_hcd 0000:11:00.0: Allocated command ring at ffff88040c4317c0
> [   83.934992] xhci_hcd 0000:11:00.0: First segment DMA is 0xffffe000
> [   83.935001] xhci_hcd 0000:11:00.0: // Setting command ring address to 0x20
> [   83.935011] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [   83.935012] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [   83.935018] xhci_hcd 0000:11:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
> [   83.935020] xhci_hcd 0000:11:00.0: // xHCI capability registers at ffffc90006970000:
> [   83.935026] xhci_hcd 0000:11:00.0: // @ffffc90006970000 = 0x960020 (CAPLENGTH AND HCIVERSION)
> [   83.935028] xhci_hcd 0000:11:00.0: //   CAPLENGTH: 0x20
> [   83.935029] xhci_hcd 0000:11:00.0: // xHCI operational registers at ffffc90006970020:
> [   83.935035] xhci_hcd 0000:11:00.0: // @ffffc90006970018 = 0x600 RTSOFF
> [   83.935036] xhci_hcd 0000:11:00.0: // xHCI runtime registers at ffffc90006970600:
> [   83.935042] xhci_hcd 0000:11:00.0: // @ffffc90006970014 = 0x800 DBOFF
> [   83.935044] xhci_hcd 0000:11:00.0: // Doorbell array at ffffc90006970800:
> [   83.935045] xhci_hcd 0000:11:00.0: xHCI runtime registers at ffffc90006970600:
> [   83.935051] xhci_hcd 0000:11:00.0:   ffffc90006970600: Microframe index = 0x0
> [   83.935076] xhci_hcd 0000:11:00.0: // Allocating event ring
> [   83.935078] xhci_hcd 0000:11:00.0: TRB math tests passed.
> [   83.935080] xhci_hcd 0000:11:00.0: // Allocated event ring segment table at 0xffffd000
> [   83.935082] xhci_hcd 0000:11:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88040c601000, dma addr = 0xffffd000
> [   83.935089] xhci_hcd 0000:11:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [   83.935090] xhci_hcd 0000:11:00.0: // Set ERST entries to point to event ring.
> [   83.935091] xhci_hcd 0000:11:00.0: // Set ERST base address for ir_set 0 = 0xffffd000
> [   83.935108] xhci_hcd 0000:11:00.0: // Write event ring dequeue pointer, preserving EHB bit
> [   83.935109] xhci_hcd 0000:11:00.0: Wrote ERST address to ir_set 0.
> [   83.935114] xhci_hcd 0000:11:00.0: Allocating 0 scratchpad buffers
> [   83.935133] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006970510, port offset = 1, count = 2, revision = 0x3
> [   83.935142] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006970520, port offset = 3, count = 2, revision = 0x2
> [   83.935144] xhci_hcd 0000:11:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [   83.935146] xhci_hcd 0000:11:00.0: USB 2.0 port at index 2, addr = ffffc90006970440
> [   83.935147] xhci_hcd 0000:11:00.0: USB 2.0 port at index 3, addr = ffffc90006970450
> [   83.935149] xhci_hcd 0000:11:00.0: USB 3.0 port at index 0, addr = ffffc90006970420
> [   83.935157] xhci_hcd 0000:11:00.0: USB 3.0 port at index 1, addr = ffffc90006970430
> [   83.935163] xhci_hcd 0000:11:00.0: Finished xhci_init
> [   83.935165] xhci_hcd 0000:11:00.0: Called HCD init
> [   83.935171] xhci_hcd 0000:11:00.0: Got SBRN 48
> [   83.935189] xhci_hcd 0000:11:00.0: MWI active
> [   83.935190] xhci_hcd 0000:11:00.0: Finished xhci_pci_reinit
> [   83.935191] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [   83.935206] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [   83.935802] xhci_hcd 0000:11:00.0: xhci_run
> [   83.935907] xhci_hcd 0000:11:00.0: irq 49 for MSI/MSI-X
> [   83.935911] xhci_hcd 0000:11:00.0: irq 50 for MSI/MSI-X
> [   83.935915] xhci_hcd 0000:11:00.0: irq 51 for MSI/MSI-X
> [   83.935919] xhci_hcd 0000:11:00.0: irq 52 for MSI/MSI-X
> [   83.935923] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [   83.936011] xhci_hcd 0000:11:00.0: Setting event ring polling timer
> [   83.936012] xhci_hcd 0000:11:00.0: Command ring memory map follows:
> [   83.936014] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 00000000
> [   83.936016] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00000000
> [   83.936017] xhci_hcd 0000:11:00.0: @00000000ffffe020 00000000 00000000 00000000 00000000
> [   83.936019] xhci_hcd 0000:11:00.0: @00000000ffffe030 00000000 00000000 00000000 00000000
> [   83.936021] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [   83.936022] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [   83.936024] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [   83.936025] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [   83.936027] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [   83.936029] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [   83.936030] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [   83.936032] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [   83.936033] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [   83.936035] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [   83.936036] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [   83.936038] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [   83.936040] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [   83.936041] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [   83.936043] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [   83.936044] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [   83.936046] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [   83.936048] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [   83.936049] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [   83.936051] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [   83.936052] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [   83.936054] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [   83.936055] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [   83.936057] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [   83.936059] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [   83.936060] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [   83.936062] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [   83.936063] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [   83.936065] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [   83.936066] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [   83.936068] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [   83.936070] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [   83.936071] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [   83.936073] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [   83.936074] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [   83.936076] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [   83.936078] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [   83.936079] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [   83.936081] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [   83.936082] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [   83.936084] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [   83.936085] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [   83.936087] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [   83.936088] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [   83.936090] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [   83.936092] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [   83.936093] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [   83.936095] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [   83.936096] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [   83.936098] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [   83.936100] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [   83.936101] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [   83.936103] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [   83.936104] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [   83.936106] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [   83.936108] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [   83.936109] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [   83.936111] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [   83.936112] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [   83.936114] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [   83.936115] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [   83.936117] xhci_hcd 0000:11:00.0: Ring deq = ffff88040cc90000 (virt), 0xffffe000 (dma)
> [   83.936118] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [   83.936120] xhci_hcd 0000:11:00.0: Ring enq = ffff88040cc90000 (virt), 0xffffe000 (dma)
> [   83.936121] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [   83.936130] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [   83.936132] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [   83.936133] xhci_hcd 0000:11:00.0: ERST memory map follows:
> [   83.936135] xhci_hcd 0000:11:00.0: @00000000ffffd000 ffffe400 00000000 00000040 00000000
> [   83.936136] xhci_hcd 0000:11:00.0: Event ring:
> [   83.936138] xhci_hcd 0000:11:00.0: @00000000ffffe400 00000000 00000000 00000000 00000000
> [   83.936139] xhci_hcd 0000:11:00.0: @00000000ffffe410 00000000 00000000 00000000 00000000
> [   83.936141] xhci_hcd 0000:11:00.0: @00000000ffffe420 00000000 00000000 00000000 00000000
> [   83.936142] xhci_hcd 0000:11:00.0: @00000000ffffe430 00000000 00000000 00000000 00000000
> [   83.936144] xhci_hcd 0000:11:00.0: @00000000ffffe440 00000000 00000000 00000000 00000000
> [   83.936145] xhci_hcd 0000:11:00.0: @00000000ffffe450 00000000 00000000 00000000 00000000
> [   83.936147] xhci_hcd 0000:11:00.0: @00000000ffffe460 00000000 00000000 00000000 00000000
> [   83.936149] xhci_hcd 0000:11:00.0: @00000000ffffe470 00000000 00000000 00000000 00000000
> [   83.936150] xhci_hcd 0000:11:00.0: @00000000ffffe480 00000000 00000000 00000000 00000000
> [   83.936152] xhci_hcd 0000:11:00.0: @00000000ffffe490 00000000 00000000 00000000 00000000
> [   83.936153] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 00000000 00000000 00000000 00000000
> [   83.936155] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 00000000 00000000 00000000 00000000
> [   83.936164] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 00000000 00000000 00000000 00000000
> [   83.936165] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 00000000 00000000 00000000 00000000
> [   83.936167] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 00000000 00000000 00000000 00000000
> [   83.936168] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 00000000 00000000 00000000 00000000
> [   83.936170] xhci_hcd 0000:11:00.0: @00000000ffffe500 00000000 00000000 00000000 00000000
> [   83.936171] xhci_hcd 0000:11:00.0: @00000000ffffe510 00000000 00000000 00000000 00000000
> [   83.936173] xhci_hcd 0000:11:00.0: @00000000ffffe520 00000000 00000000 00000000 00000000
> [   83.936174] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [   83.936176] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [   83.936177] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [   83.936179] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [   83.936180] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [   83.936182] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [   83.936183] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [   83.936185] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [   83.936186] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [   83.936188] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [   83.936189] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [   83.936191] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [   83.936192] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [   83.936193] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [   83.936195] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [   83.936196] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [   83.936198] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [   83.936199] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [   83.936201] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [   83.936202] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [   83.936204] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [   83.936205] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [   83.936207] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [   83.936208] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [   83.936210] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [   83.936211] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [   83.936213] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [   83.936214] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [   83.936216] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [   83.936217] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [   83.936219] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [   83.936220] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [   83.936222] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [   83.936223] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [   83.936225] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [   83.936226] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [   83.936228] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [   83.936229] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [   83.936231] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [   83.936232] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [   83.936234] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [   83.936235] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [   83.936237] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [   83.936238] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [   83.936240] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [   83.936241] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [   83.936242] xhci_hcd 0000:11:00.0: Ring deq = ffff88040cc90400 (virt), 0xffffe400 (dma)
> [   83.936243] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [   83.936245] xhci_hcd 0000:11:00.0: Ring enq = ffff88040cc90400 (virt), 0xffffe400 (dma)
> [   83.936246] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [   83.936255] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe400
> [   83.936256] xhci_hcd 0000:11:00.0: // Set the interrupt modulation register
> [   83.936266] xhci_hcd 0000:11:00.0: // Enable interrupts, cmd = 0x4.
> [   83.936272] xhci_hcd 0000:11:00.0: // Enabling event ring interrupter ffffc90006970620 by writing 0x2 to irq_pending
> [   83.936279] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set[0]
> [   83.936280] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set.pending = 0x2
> [   83.936286] xhci_hcd 0000:11:00.0:   ffffc90006970624: ir_set.control = 0xa0
> [   83.936292] xhci_hcd 0000:11:00.0:   ffffc90006970628: ir_set.erst_size = 0x1
> [   83.936305] xhci_hcd 0000:11:00.0:   ffffc90006970630: ir_set.erst_base = @ffffd000
> [   83.936314] xhci_hcd 0000:11:00.0:   ffffc90006970638: ir_set.erst_dequeue = @ffffe400
> [   83.936316] xhci_hcd 0000:11:00.0: Finished xhci_run for USB2 roothub
> [   83.936325] usb usb3: default language 0x0409
> [   83.936329] usb usb3: udev 1, busnum 3, minor = 256
> [   83.936331] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [   83.936921] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   83.937517] usb usb3: Product: xHCI Host Controller
> [   83.938115] usb usb3: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [   83.938727] usb usb3: SerialNumber: 0000:11:00.0
> [   83.939434] usb usb3: usb_probe_device
> [   83.939437] usb usb3: configuration #1 chosen from 1 choice
> [   83.939439] xHCI xhci_add_endpoint called for root hub
> [   83.939440] xHCI xhci_check_bandwidth called for root hub
> [   83.939445] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [   83.939464] hub 3-0:1.0: usb_probe_interface
> [   83.939466] hub 3-0:1.0: usb_probe_interface - got id
> [   83.939469] hub 3-0:1.0: USB hub found
> [   83.940309] hub 3-0:1.0: 2 ports detected
> [   83.941157] hub 3-0:1.0: standalone hub
> [   83.941159] hub 3-0:1.0: individual port power switching
> [   83.941160] hub 3-0:1.0: individual port over-current protection
> [   83.941162] hub 3-0:1.0: Single TT
> [   83.941163] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [   83.941165] hub 3-0:1.0: power on to power good time: 20ms
> [   83.941169] hub 3-0:1.0: local power source is good
> [   83.941171] hub 3-0:1.0: enabling power on all ports
> [   83.941181] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [   83.941197] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [   83.941256] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [   83.941260] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 4
> [   83.941269] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [   83.941271] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [   83.941277] xhci_hcd 0000:11:00.0: // Turn on HC, cmd = 0x5.
> [   83.941296] xhci_hcd 0000:11:00.0: // Ding dong!
> [   83.941302] xhci_hcd 0000:11:00.0: Finished xhci_run for USB3 roothub
> [   83.941310] usb usb4: skipped 1 descriptor after endpoint
> [   83.941313] usb usb4: default language 0x0409
> [   83.941319] usb usb4: udev 1, busnum 4, minor = 384
> [   83.941321] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [   83.941323] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   83.941325] usb usb4: Product: xHCI Host Controller
> [   83.941326] usb usb4: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [   83.941328] usb usb4: SerialNumber: 0000:11:00.0
> [   83.941369] xhci_hcd 0000:11:00.0: Vendor specific event TRB type = 48
> [   83.941371] xhci_hcd 0000:11:00.0: NEC firmware version 30.28
> [   83.941423] usb usb4: usb_probe_device
> [   83.941425] usb usb4: configuration #1 chosen from 1 choice
> [   83.941427] xHCI xhci_add_endpoint called for root hub
> [   83.941429] xHCI xhci_check_bandwidth called for root hub
> [   83.941434] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [   83.941459] hub 4-0:1.0: usb_probe_interface
> [   83.941461] hub 4-0:1.0: usb_probe_interface - got id
> [   83.941462] hub 4-0:1.0: USB hub found
> [   83.941479] hub 4-0:1.0: 2 ports detected
> [   83.941481] hub 4-0:1.0: standalone hub
> [   83.941482] hub 4-0:1.0: individual port power switching
> [   83.941484] hub 4-0:1.0: individual port over-current protection
> [   83.941485] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [   83.941487] hub 4-0:1.0: power on to power good time: 20ms
> [   83.941490] hub 4-0:1.0: local power source is good
> [   83.941492] hub 4-0:1.0: enabling power on all ports
> [   83.941509] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [   83.941534] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [   83.988615] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [   84.039766] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [   84.039776] xhci_hcd 0000:11:00.0: Get port status returned 0x100
> [   84.039795] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x202e1
> [   84.039801] xhci_hcd 0000:11:00.0: Get port status returned 0x10101
> [   84.039809] hub 3-0:1.0: port 2: status 0101 change 0001
> [   84.039827] xhci_hcd 0000:11:00.0: clear port connect change, actual port 1 status  = 0x2e1
> [   84.039845] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [   84.039856] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [   84.039863] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2a0
> [   84.039865] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [   84.039894] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [   84.139725] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [   84.139737] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2e1
> [   84.139739] xhci_hcd 0000:11:00.0: Get port status returned 0x101
> [   84.139743] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [   84.139746] xhci_hcd 0000:11:00.0: // Ding dong!
> [   84.139832] xhci_hcd 0000:11:00.0: Slot 1 output ctx = 0xffffc000 (dma)
> [   84.139836] xhci_hcd 0000:11:00.0: Slot 1 input ctx = 0xffffb000 (dma)
> [   84.139842] xhci_hcd 0000:11:00.0: Set slot id 1 dcbaa entry ffff88040edf6008 to 0xffffc000
> [   84.139857] xhci_hcd 0000:11:00.0: set port reset, actual port 1 status  = 0x331
> [   84.189915] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [   84.199520] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x200a03
> [   84.199532] xhci_hcd 0000:11:00.0: Get port status returned 0x100303
> [   84.259443] xhci_hcd 0000:11:00.0: clear port reset change, actual port 1 status  = 0xa03
> [   84.259462] usb 3-2: new low-speed USB device number 2 using xhci_hcd
> [   84.260190] xhci_hcd 0000:11:00.0: Set root hub portnum to 4
> [   84.260191] xhci_hcd 0000:11:00.0: Set fake root hub portnum to 2
> [   84.260192] xhci_hcd 0000:11:00.0: udev->tt = ffff88040c52ec98
> [   84.260194] xhci_hcd 0000:11:00.0: udev->ttport = 0x2
> [   84.260195] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [   84.260197] xhci_hcd 0000:11:00.0: @ffff88040ccd7000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [   84.260199] xhci_hcd 0000:11:00.0: @ffff88040ccd7004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [   84.260201] xhci_hcd 0000:11:00.0: @ffff88040ccd7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   84.260202] xhci_hcd 0000:11:00.0: @ffff88040ccd700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   84.260204] xhci_hcd 0000:11:00.0: @ffff88040ccd7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   84.260206] xhci_hcd 0000:11:00.0: @ffff88040ccd7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   84.260207] xhci_hcd 0000:11:00.0: @ffff88040ccd7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   84.260209] xhci_hcd 0000:11:00.0: @ffff88040ccd701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   84.260210] xhci_hcd 0000:11:00.0: Slot Context:
> [   84.260212] xhci_hcd 0000:11:00.0: @ffff88040ccd7020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [   84.260213] xhci_hcd 0000:11:00.0: @ffff88040ccd7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   84.260215] xhci_hcd 0000:11:00.0: @ffff88040ccd7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   84.260217] xhci_hcd 0000:11:00.0: @ffff88040ccd702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   84.260218] xhci_hcd 0000:11:00.0: @ffff88040ccd7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   84.260220] xhci_hcd 0000:11:00.0: @ffff88040ccd7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   84.260222] xhci_hcd 0000:11:00.0: @ffff88040ccd7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   84.260223] xhci_hcd 0000:11:00.0: @ffff88040ccd703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   84.260225] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   84.260226] xhci_hcd 0000:11:00.0: @ffff88040ccd7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   84.260228] xhci_hcd 0000:11:00.0: @ffff88040ccd7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   84.260229] xhci_hcd 0000:11:00.0: @ffff88040ccd7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   84.260231] xhci_hcd 0000:11:00.0: @ffff88040ccd7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   84.260232] xhci_hcd 0000:11:00.0: @ffff88040ccd7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   84.260234] xhci_hcd 0000:11:00.0: @ffff88040ccd7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   84.260236] xhci_hcd 0000:11:00.0: @ffff88040ccd705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   84.260237] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   84.260238] xhci_hcd 0000:11:00.0: @ffff88040ccd7060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [   84.260240] xhci_hcd 0000:11:00.0: @ffff88040ccd7064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [   84.260242] xhci_hcd 0000:11:00.0: @ffff88040ccd7068 (virt) @ffffb068 (dma) 0x000000 - deq
> [   84.260243] xhci_hcd 0000:11:00.0: @ffff88040ccd7070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [   84.260245] xhci_hcd 0000:11:00.0: @ffff88040ccd7074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [   84.260247] xhci_hcd 0000:11:00.0: @ffff88040ccd7078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [   84.260248] xhci_hcd 0000:11:00.0: @ffff88040ccd707c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [   84.260250] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   84.260251] xhci_hcd 0000:11:00.0: @ffff88040ccd7080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [   84.260252] xhci_hcd 0000:11:00.0: @ffff88040ccd7084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [   84.260254] xhci_hcd 0000:11:00.0: @ffff88040ccd7088 (virt) @ffffb088 (dma) 0x000000 - deq
> [   84.260256] xhci_hcd 0000:11:00.0: @ffff88040ccd7090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [   84.260257] xhci_hcd 0000:11:00.0: @ffff88040ccd7094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [   84.260259] xhci_hcd 0000:11:00.0: @ffff88040ccd7098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [   84.260260] xhci_hcd 0000:11:00.0: @ffff88040ccd709c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [   84.260263] xhci_hcd 0000:11:00.0: // Ding dong!
> [   84.260984] xhci_hcd 0000:11:00.0: Successful Address Device command
> [   84.261004] xhci_hcd 0000:11:00.0: Op regs DCBAA ptr = 0x000000fffff000
> [   84.261013] xhci_hcd 0000:11:00.0: Slot ID 1 dcbaa entry @ffff88040edf6008 = 0x000000ffffc000
> [   84.261020] xhci_hcd 0000:11:00.0: Output Context DMA address = 0xffffc000
> [   84.261026] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [   84.261033] xhci_hcd 0000:11:00.0: @ffff88040ccd7000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [   84.261041] xhci_hcd 0000:11:00.0: @ffff88040ccd7004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [   84.261048] xhci_hcd 0000:11:00.0: @ffff88040ccd7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   84.261056] xhci_hcd 0000:11:00.0: @ffff88040ccd700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   84.261063] xhci_hcd 0000:11:00.0: @ffff88040ccd7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   84.261070] xhci_hcd 0000:11:00.0: @ffff88040ccd7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   84.261078] xhci_hcd 0000:11:00.0: @ffff88040ccd7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   84.261085] xhci_hcd 0000:11:00.0: @ffff88040ccd701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   84.261091] xhci_hcd 0000:11:00.0: Slot Context:
> [   84.261097] xhci_hcd 0000:11:00.0: @ffff88040ccd7020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [   84.261110] xhci_hcd 0000:11:00.0: @ffff88040ccd7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   84.261112] xhci_hcd 0000:11:00.0: @ffff88040ccd7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   84.261113] xhci_hcd 0000:11:00.0: @ffff88040ccd702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   84.261115] xhci_hcd 0000:11:00.0: @ffff88040ccd7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   84.261117] xhci_hcd 0000:11:00.0: @ffff88040ccd7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   84.261118] xhci_hcd 0000:11:00.0: @ffff88040ccd7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   84.261120] xhci_hcd 0000:11:00.0: @ffff88040ccd703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   84.261121] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   84.261123] xhci_hcd 0000:11:00.0: @ffff88040ccd7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   84.261124] xhci_hcd 0000:11:00.0: @ffff88040ccd7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   84.261126] xhci_hcd 0000:11:00.0: @ffff88040ccd7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   84.261128] xhci_hcd 0000:11:00.0: @ffff88040ccd7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   84.261129] xhci_hcd 0000:11:00.0: @ffff88040ccd7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   84.261131] xhci_hcd 0000:11:00.0: @ffff88040ccd7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   84.261133] xhci_hcd 0000:11:00.0: @ffff88040ccd705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   84.261134] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   84.261135] xhci_hcd 0000:11:00.0: @ffff88040ccd7060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [   84.261137] xhci_hcd 0000:11:00.0: @ffff88040ccd7064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [   84.261139] xhci_hcd 0000:11:00.0: @ffff88040ccd7068 (virt) @ffffb068 (dma) 0x000000 - deq
> [   84.261140] xhci_hcd 0000:11:00.0: @ffff88040ccd7070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [   84.261142] xhci_hcd 0000:11:00.0: @ffff88040ccd7074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [   84.261143] xhci_hcd 0000:11:00.0: @ffff88040ccd7078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [   84.261145] xhci_hcd 0000:11:00.0: @ffff88040ccd707c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [   84.261146] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   84.261148] xhci_hcd 0000:11:00.0: @ffff88040ccd7080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [   84.261149] xhci_hcd 0000:11:00.0: @ffff88040ccd7084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [   84.261151] xhci_hcd 0000:11:00.0: @ffff88040ccd7088 (virt) @ffffb088 (dma) 0x000000 - deq
> [   84.261152] xhci_hcd 0000:11:00.0: @ffff88040ccd7090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [   84.261154] xhci_hcd 0000:11:00.0: @ffff88040ccd7094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [   84.261156] xhci_hcd 0000:11:00.0: @ffff88040ccd7098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [   84.261157] xhci_hcd 0000:11:00.0: @ffff88040ccd709c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [   84.261159] xhci_hcd 0000:11:00.0: Slot ID 1 Output Context:
> [   84.261160] xhci_hcd 0000:11:00.0: Slot Context:
> [   84.261161] xhci_hcd 0000:11:00.0: @ffff88040c57a000 (virt) @ffffc000 (dma) 0x8200000 - dev_info
> [   84.261163] xhci_hcd 0000:11:00.0: @ffff88040c57a004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [   84.261164] xhci_hcd 0000:11:00.0: @ffff88040c57a008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [   84.261166] xhci_hcd 0000:11:00.0: @ffff88040c57a00c (virt) @ffffc00c (dma) 0x10000001 - dev_state
> [   84.261168] xhci_hcd 0000:11:00.0: @ffff88040c57a010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [   84.261169] xhci_hcd 0000:11:00.0: @ffff88040c57a014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [   84.261171] xhci_hcd 0000:11:00.0: @ffff88040c57a018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [   84.261173] xhci_hcd 0000:11:00.0: @ffff88040c57a01c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [   84.261174] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   84.261175] xhci_hcd 0000:11:00.0: @ffff88040c57a020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [   84.261177] xhci_hcd 0000:11:00.0: @ffff88040c57a024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [   84.261179] xhci_hcd 0000:11:00.0: @ffff88040c57a028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [   84.261180] xhci_hcd 0000:11:00.0: @ffff88040c57a030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [   84.261182] xhci_hcd 0000:11:00.0: @ffff88040c57a034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [   84.261184] xhci_hcd 0000:11:00.0: @ffff88040c57a038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [   84.261185] xhci_hcd 0000:11:00.0: @ffff88040c57a03c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [   84.261187] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   84.261188] xhci_hcd 0000:11:00.0: @ffff88040c57a040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [   84.261189] xhci_hcd 0000:11:00.0: @ffff88040c57a044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [   84.261191] xhci_hcd 0000:11:00.0: @ffff88040c57a048 (virt) @ffffc048 (dma) 0x000000 - deq
> [   84.261193] xhci_hcd 0000:11:00.0: @ffff88040c57a050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [   84.261194] xhci_hcd 0000:11:00.0: @ffff88040c57a054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [   84.261196] xhci_hcd 0000:11:00.0: @ffff88040c57a058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [   84.261197] xhci_hcd 0000:11:00.0: @ffff88040c57a05c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [   84.261199] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   84.261200] xhci_hcd 0000:11:00.0: @ffff88040c57a060 (virt) @ffffc060 (dma) 0x000000 - ep_info
> [   84.261202] xhci_hcd 0000:11:00.0: @ffff88040c57a064 (virt) @ffffc064 (dma) 0x000000 - ep_info2
> [   84.261203] xhci_hcd 0000:11:00.0: @ffff88040c57a068 (virt) @ffffc068 (dma) 0x000000 - deq
> [   84.261205] xhci_hcd 0000:11:00.0: @ffff88040c57a070 (virt) @ffffc070 (dma) 0x000000 - tx_info
> [   84.261207] xhci_hcd 0000:11:00.0: @ffff88040c57a074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [   84.261208] xhci_hcd 0000:11:00.0: @ffff88040c57a078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [   84.261210] xhci_hcd 0000:11:00.0: @ffff88040c57a07c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [   84.261211] xhci_hcd 0000:11:00.0: Internal device address = 2
> [   84.297998] usb 3-2: skipped 1 descriptor after interface
> [   84.299883] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [   84.300965] usb 3-2: default language 0x0409
> [   84.308908] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [   84.312902] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [   84.313949] usb 3-2: udev 2, busnum 3, minor = 257
> [   84.313960] usb 3-2: New USB device found, idVendor=0458, idProduct=0036
> [   84.314709] usb 3-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> [   84.315378] usb 3-2: Product: NetScroll + Mini Traveler
> [   84.316058] usb 3-2: Manufacturer: Genius
> [   84.316868] usb 3-2: usb_probe_device
> [   84.316871] usb 3-2: configuration #1 chosen from 1 choice
> [   84.316878] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
> [   84.317624] xhci_hcd 0000:11:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18200000
> [   84.317626] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040c440800
> [   84.317628] xhci_hcd 0000:11:00.0: New Input Control Context:
> [   84.317630] xhci_hcd 0000:11:00.0: @ffff88040ccd7000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [   84.317632] xhci_hcd 0000:11:00.0: @ffff88040ccd7004 (virt) @ffffb004 (dma) 0x000009 - add flags
> [   84.317634] xhci_hcd 0000:11:00.0: @ffff88040ccd7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [   84.317636] xhci_hcd 0000:11:00.0: @ffff88040ccd700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [   84.317637] xhci_hcd 0000:11:00.0: @ffff88040ccd7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [   84.317639] xhci_hcd 0000:11:00.0: @ffff88040ccd7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [   84.317641] xhci_hcd 0000:11:00.0: @ffff88040ccd7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [   84.317643] xhci_hcd 0000:11:00.0: @ffff88040ccd701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [   84.317644] xhci_hcd 0000:11:00.0: Slot Context:
> [   84.317646] xhci_hcd 0000:11:00.0: @ffff88040ccd7020 (virt) @ffffb020 (dma) 0x18200000 - dev_info
> [   84.317647] xhci_hcd 0000:11:00.0: @ffff88040ccd7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [   84.317649] xhci_hcd 0000:11:00.0: @ffff88040ccd7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [   84.317651] xhci_hcd 0000:11:00.0: @ffff88040ccd702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [   84.317653] xhci_hcd 0000:11:00.0: @ffff88040ccd7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [   84.317654] xhci_hcd 0000:11:00.0: @ffff88040ccd7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [   84.317656] xhci_hcd 0000:11:00.0: @ffff88040ccd7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [   84.317658] xhci_hcd 0000:11:00.0: @ffff88040ccd703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [   84.317659] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   84.317661] xhci_hcd 0000:11:00.0: @ffff88040ccd7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [   84.317663] xhci_hcd 0000:11:00.0: @ffff88040ccd7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [   84.317664] xhci_hcd 0000:11:00.0: @ffff88040ccd7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [   84.317666] xhci_hcd 0000:11:00.0: @ffff88040ccd7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [   84.317668] xhci_hcd 0000:11:00.0: @ffff88040ccd7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [   84.317670] xhci_hcd 0000:11:00.0: @ffff88040ccd7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [   84.317671] xhci_hcd 0000:11:00.0: @ffff88040ccd705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [   84.317673] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   84.317674] xhci_hcd 0000:11:00.0: @ffff88040ccd7060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [   84.317676] xhci_hcd 0000:11:00.0: @ffff88040ccd7064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [   84.317678] xhci_hcd 0000:11:00.0: @ffff88040ccd7068 (virt) @ffffb068 (dma) 0x000000 - deq
> [   84.317679] xhci_hcd 0000:11:00.0: @ffff88040ccd7070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [   84.317681] xhci_hcd 0000:11:00.0: @ffff88040ccd7074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [   84.317683] xhci_hcd 0000:11:00.0: @ffff88040ccd7078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [   84.317684] xhci_hcd 0000:11:00.0: @ffff88040ccd707c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [   84.317686] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   84.317687] xhci_hcd 0000:11:00.0: @ffff88040ccd7080 (virt) @ffffb080 (dma) 0x060000 - ep_info
> [   84.317689] xhci_hcd 0000:11:00.0: @ffff88040ccd7084 (virt) @ffffb084 (dma) 0x04003e - ep_info2
> [   84.317691] xhci_hcd 0000:11:00.0: @ffff88040ccd7088 (virt) @ffffb088 (dma) 0xffffa401 - deq
> [   84.317693] xhci_hcd 0000:11:00.0: @ffff88040ccd7090 (virt) @ffffb090 (dma) 0x040004 - tx_info
> [   84.317694] xhci_hcd 0000:11:00.0: @ffff88040ccd7094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [   84.317696] xhci_hcd 0000:11:00.0: @ffff88040ccd7098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [   84.317698] xhci_hcd 0000:11:00.0: @ffff88040ccd709c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [   84.317700] xhci_hcd 0000:11:00.0: // Ding dong!
> [   84.317983] xhci_hcd 0000:11:00.0: Completed config ep cmd
> [   84.318015] usb 3-2: Successful Endpoint Configure command
> [   84.318021] xhci_hcd 0000:11:00.0: Output context after successful config ep cmd:
> [   84.318027] xhci_hcd 0000:11:00.0: Slot Context:
> [   84.318035] xhci_hcd 0000:11:00.0: @ffff88040c57a000 (virt) @ffffc000 (dma) 0x18200000 - dev_info
> [   84.318042] xhci_hcd 0000:11:00.0: @ffff88040c57a004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [   84.318050] xhci_hcd 0000:11:00.0: @ffff88040c57a008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [   84.318057] xhci_hcd 0000:11:00.0: @ffff88040c57a00c (virt) @ffffc00c (dma) 0x18000001 - dev_state
> [   84.318065] xhci_hcd 0000:11:00.0: @ffff88040c57a010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [   84.318073] xhci_hcd 0000:11:00.0: @ffff88040c57a014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [   84.318081] xhci_hcd 0000:11:00.0: @ffff88040c57a018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [   84.318088] xhci_hcd 0000:11:00.0: @ffff88040c57a01c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [   84.318094] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [   84.318100] xhci_hcd 0000:11:00.0: @ffff88040c57a020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [   84.318107] xhci_hcd 0000:11:00.0: @ffff88040c57a024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [   84.318115] xhci_hcd 0000:11:00.0: @ffff88040c57a028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [   84.318122] xhci_hcd 0000:11:00.0: @ffff88040c57a030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [   84.318129] xhci_hcd 0000:11:00.0: @ffff88040c57a034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [   84.318142] xhci_hcd 0000:11:00.0: @ffff88040c57a038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [   84.318143] xhci_hcd 0000:11:00.0: @ffff88040c57a03c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [   84.318145] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [   84.318146] xhci_hcd 0000:11:00.0: @ffff88040c57a040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [   84.318148] xhci_hcd 0000:11:00.0: @ffff88040c57a044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [   84.318149] xhci_hcd 0000:11:00.0: @ffff88040c57a048 (virt) @ffffc048 (dma) 0x000000 - deq
> [   84.318151] xhci_hcd 0000:11:00.0: @ffff88040c57a050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [   84.318152] xhci_hcd 0000:11:00.0: @ffff88040c57a054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [   84.318154] xhci_hcd 0000:11:00.0: @ffff88040c57a058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [   84.318156] xhci_hcd 0000:11:00.0: @ffff88040c57a05c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [   84.318157] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [   84.318158] xhci_hcd 0000:11:00.0: @ffff88040c57a060 (virt) @ffffc060 (dma) 0x060001 - ep_info
> [   84.318160] xhci_hcd 0000:11:00.0: @ffff88040c57a064 (virt) @ffffc064 (dma) 0x04003e - ep_info2
> [   84.318162] xhci_hcd 0000:11:00.0: @ffff88040c57a068 (virt) @ffffc068 (dma) 0xffffa401 - deq
> [   84.318163] xhci_hcd 0000:11:00.0: @ffff88040c57a070 (virt) @ffffc070 (dma) 0x040004 - tx_info
> [   84.318165] xhci_hcd 0000:11:00.0: @ffff88040c57a074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [   84.318166] xhci_hcd 0000:11:00.0: @ffff88040c57a078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [   84.318168] xhci_hcd 0000:11:00.0: @ffff88040c57a07c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [   84.319787] xhci_hcd 0000:11:00.0: Endpoint 0x81 not halted, refusing to reset.
> [   84.319793] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> [   84.319828] usbserial_generic 3-2:1.0: usb_probe_interface
> [   84.319830] usbserial_generic 3-2:1.0: usb_probe_interface - got id
> [   84.319842] usbhid 3-2:1.0: usb_probe_interface
> [   84.319844] usbhid 3-2:1.0: usb_probe_interface - got id
> [   84.331121] input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1c.7/0000:11:00.0/usb3/3-2/3-2:1.0/input/input14
> [   84.332062] generic-usb 0003:0458:0036.0001: input,hidraw0: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:11:00.0-2/input0
> [   86.036807] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> [   86.036843] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> [   86.036856] hub 4-0:1.0: hub_suspend
> [   86.036869] usb usb4: bus auto-suspend, wakeup 1
> [  144.060317] xhci_hcd 0000:11:00.0: Poll event ring: 4294951712
> [  144.060333] xhci_hcd 0000:11:00.0: op reg status = 0x0
> [  144.060343] xhci_hcd 0000:11:00.0: ir_set 0 pending = 0x2
> [  144.060348] xhci_hcd 0000:11:00.0: HC error bitmask = 0x4
> [  144.060353] xhci_hcd 0000:11:00.0: Event ring:
> [  144.060361] xhci_hcd 0000:11:00.0: @00000000ffffe400 ffffe000 00000000 01003028 0000c001
> [  144.060368] xhci_hcd 0000:11:00.0: @00000000ffffe410 04000000 00000000 01000000 00008801
> [  144.060376] xhci_hcd 0000:11:00.0: @00000000ffffe420 ffffe010 00000000 01000000 01008401
> [  144.060382] xhci_hcd 0000:11:00.0: @00000000ffffe430 04000000 00000000 01000000 00008801
> [  144.060389] xhci_hcd 0000:11:00.0: @00000000ffffe440 ffffe020 00000000 01000000 01008401
> [  144.060396] xhci_hcd 0000:11:00.0: @00000000ffffe450 ffffe820 00000000 01000000 01018001
> [  144.060402] xhci_hcd 0000:11:00.0: @00000000ffffe460 ffffe850 00000000 01000000 01018001
> [  144.060409] xhci_hcd 0000:11:00.0: @00000000ffffe470 ffffe880 00000000 01000000 01018001
> [  144.060415] xhci_hcd 0000:11:00.0: @00000000ffffe480 ffffe8b0 00000000 01000000 01018001
> [  144.060422] xhci_hcd 0000:11:00.0: @00000000ffffe490 ffffe8d0 00000000 0d0000fb 01018001
> [  144.060429] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 ffffe8e0 00000000 01000000 01018001
> [  144.060435] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 ffffe900 00000000 0d0000cb 01018001
> [  144.060442] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 ffffe910 00000000 01000000 01018001
> [  144.060454] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 ffffe930 00000000 0d0000f1 01018001
> [  144.060455] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 ffffe940 00000000 01000000 01018001
> [  144.060456] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 ffffe030 00000000 01000000 01008401
> [  144.060458] xhci_hcd 0000:11:00.0: @00000000ffffe500 ffffe960 00000000 01000000 01018001
> [  144.060460] xhci_hcd 0000:11:00.0: @00000000ffffe510 ffffe980 00000000 01000000 01018001
> [  144.060461] xhci_hcd 0000:11:00.0: @00000000ffffe520 ffffe9b0 00000000 01000000 01018001
> [  144.060463] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [  144.060464] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [  144.060466] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [  144.060467] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [  144.060469] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [  144.060470] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [  144.060472] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [  144.060473] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [  144.060475] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [  144.060476] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [  144.060478] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [  144.060479] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [  144.060481] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [  144.060482] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [  144.060484] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [  144.060485] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [  144.060486] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [  144.060488] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [  144.060489] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [  144.060491] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [  144.060492] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [  144.060494] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [  144.060495] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [  144.060497] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [  144.060498] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [  144.060500] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [  144.060501] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [  144.060503] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [  144.060504] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [  144.060506] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [  144.060507] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [  144.060509] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [  144.060510] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [  144.060512] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [  144.060513] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [  144.060515] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [  144.060516] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [  144.060518] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [  144.060519] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [  144.060520] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [  144.060522] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [  144.060523] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [  144.060525] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [  144.060526] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [  144.060528] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [  144.060530] xhci_hcd 0000:11:00.0: Ring deq = ffff88040cc90530 (virt), 0xffffe530 (dma)
> [  144.060531] xhci_hcd 0000:11:00.0: Ring deq updated 19 times
> [  144.060533] xhci_hcd 0000:11:00.0: Ring enq = ffff88040cc90400 (virt), 0xffffe400 (dma)
> [  144.060534] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  144.060545] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe530
> [  144.060546] xhci_hcd 0000:11:00.0: Command ring:
> [  144.060547] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 0000c401
> [  144.060549] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00002401
> [  144.060550] xhci_hcd 0000:11:00.0: @00000000ffffe020 ffffb000 00000000 00000000 01002c01
> [  144.060552] xhci_hcd 0000:11:00.0: @00000000ffffe030 ffffb000 00000000 00000000 01003001
> [  144.060553] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [  144.060554] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [  144.060556] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [  144.060557] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [  144.060559] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [  144.060560] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [  144.060562] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [  144.060563] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [  144.060565] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [  144.060566] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [  144.060568] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [  144.060569] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [  144.060571] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [  144.060572] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [  144.060573] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [  144.060575] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [  144.060577] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [  144.060578] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [  144.060579] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [  144.060581] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [  144.060582] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [  144.060584] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [  144.060585] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [  144.060587] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [  144.060588] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [  144.060590] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [  144.060591] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [  144.060593] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [  144.060594] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [  144.060596] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [  144.060597] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [  144.060599] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [  144.060600] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [  144.060602] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [  144.060603] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [  144.060605] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [  144.060606] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [  144.060607] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [  144.060609] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [  144.060610] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [  144.060612] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [  144.060613] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [  144.060615] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [  144.060616] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [  144.060618] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [  144.060619] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [  144.060621] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [  144.060622] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [  144.060624] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [  144.060625] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [  144.060627] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [  144.060628] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [  144.060629] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [  144.060631] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [  144.060632] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [  144.060634] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [  144.060635] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [  144.060637] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [  144.060638] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [  144.060640] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [  144.060641] xhci_hcd 0000:11:00.0: Ring deq = ffff88040cc90040 (virt), 0xffffe040 (dma)
> [  144.060643] xhci_hcd 0000:11:00.0: Ring deq updated 4 times
> [  144.060644] xhci_hcd 0000:11:00.0: Ring enq = ffff88040cc90040 (virt), 0xffffe040 (dma)
> [  144.060645] xhci_hcd 0000:11:00.0: Ring enq updated 4 times
> [  144.060657] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000008
> [  144.060658] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  144.060660] xhci_hcd 0000:11:00.0: Dev 1 endpoint ring 0:
> [  144.060661] xhci_hcd 0000:11:00.0: @00000000ffffe800 01000680 00080000 00000008 00000841
> [  144.060663] xhci_hcd 0000:11:00.0: @00000000ffffe810 ffff8d80 00000000 00000008 00010c05
> [  144.060664] xhci_hcd 0000:11:00.0: @00000000ffffe820 00000000 00000000 00000000 00001021
> [  144.060666] xhci_hcd 0000:11:00.0: @00000000ffffe830 01000680 00120000 00000008 00000841
> [  144.060668] xhci_hcd 0000:11:00.0: @00000000ffffe840 ffff6d80 00000000 00000012 00010c05
> [  144.060669] xhci_hcd 0000:11:00.0: @00000000ffffe850 00000000 00000000 00000000 00001021
> [  144.060671] xhci_hcd 0000:11:00.0: @00000000ffffe860 02000680 00090000 00000008 00000841
> [  144.060672] xhci_hcd 0000:11:00.0: @00000000ffffe870 ffff4dc0 00000000 00000009 00010c05
> [  144.060674] xhci_hcd 0000:11:00.0: @00000000ffffe880 00000000 00000000 00000000 00001021
> [  144.060675] xhci_hcd 0000:11:00.0: @00000000ffffe890 02000680 00220000 00000008 00000841
> [  144.060677] xhci_hcd 0000:11:00.0: @00000000ffffe8a0 ffff8a00 00000000 00000022 00010c05
> [  144.060678] xhci_hcd 0000:11:00.0: @00000000ffffe8b0 00000000 00000000 00000000 00001021
> [  144.060680] xhci_hcd 0000:11:00.0: @00000000ffffe8c0 03000680 00ff0000 00000008 00000841
> [  144.060681] xhci_hcd 0000:11:00.0: @00000000ffffe8d0 ffff63c0 00000000 000000ff 00010c05
> [  144.060683] xhci_hcd 0000:11:00.0: @00000000ffffe8e0 00000000 00000000 00000000 00001021
> [  144.060684] xhci_hcd 0000:11:00.0: @00000000ffffe8f0 03010680 00ff0409 00000008 00000841
> [  144.060686] xhci_hcd 0000:11:00.0: @00000000ffffe900 ffff83c0 00000000 000000ff 00010c05
> [  144.060687] xhci_hcd 0000:11:00.0: @00000000ffffe910 00000000 00000000 00000000 00001021
> [  144.060689] xhci_hcd 0000:11:00.0: @00000000ffffe920 03020680 00ff0409 00000008 00000841
> [  144.060690] xhci_hcd 0000:11:00.0: @00000000ffffe930 ffff63c0 00000000 000000ff 00010c05
> [  144.060692] xhci_hcd 0000:11:00.0: @00000000ffffe940 00000000 00000000 00000000 00001021
> [  144.060693] xhci_hcd 0000:11:00.0: @00000000ffffe950 00010900 00000000 00000008 00000841
> [  144.060695] xhci_hcd 0000:11:00.0: @00000000ffffe960 00000000 00000000 00000000 00011021
> [  144.060696] xhci_hcd 0000:11:00.0: @00000000ffffe970 00000a21 00000000 00000008 00000841
> [  144.060698] xhci_hcd 0000:11:00.0: @00000000ffffe980 00000000 00000000 00000000 00011021
> [  144.060699] xhci_hcd 0000:11:00.0: @00000000ffffe990 22000681 00340000 00000008 00000841
> [  144.060701] xhci_hcd 0000:11:00.0: @00000000ffffe9a0 ffff7d80 00000000 00000034 00010c05
> [  144.060702] xhci_hcd 0000:11:00.0: @00000000ffffe9b0 00000000 00000000 00000000 00001021
> [  144.060704] xhci_hcd 0000:11:00.0: @00000000ffffe9c0 00000000 00000000 00000000 00000000
> [  144.060705] xhci_hcd 0000:11:00.0: @00000000ffffe9d0 00000000 00000000 00000000 00000000
> [  144.060706] xhci_hcd 0000:11:00.0: @00000000ffffe9e0 00000000 00000000 00000000 00000000
> [  144.060708] xhci_hcd 0000:11:00.0: @00000000ffffe9f0 00000000 00000000 00000000 00000000
> [  144.060709] xhci_hcd 0000:11:00.0: @00000000ffffea00 00000000 00000000 00000000 00000000
> [  144.060711] xhci_hcd 0000:11:00.0: @00000000ffffea10 00000000 00000000 00000000 00000000
> [  144.060712] xhci_hcd 0000:11:00.0: @00000000ffffea20 00000000 00000000 00000000 00000000
> [  144.060714] xhci_hcd 0000:11:00.0: @00000000ffffea30 00000000 00000000 00000000 00000000
> [  144.060715] xhci_hcd 0000:11:00.0: @00000000ffffea40 00000000 00000000 00000000 00000000
> [  144.060717] xhci_hcd 0000:11:00.0: @00000000ffffea50 00000000 00000000 00000000 00000000
> [  144.060718] xhci_hcd 0000:11:00.0: @00000000ffffea60 00000000 00000000 00000000 00000000
> [  144.060720] xhci_hcd 0000:11:00.0: @00000000ffffea70 00000000 00000000 00000000 00000000
> [  144.060721] xhci_hcd 0000:11:00.0: @00000000ffffea80 00000000 00000000 00000000 00000000
> [  144.060723] xhci_hcd 0000:11:00.0: @00000000ffffea90 00000000 00000000 00000000 00000000
> [  144.060724] xhci_hcd 0000:11:00.0: @00000000ffffeaa0 00000000 00000000 00000000 00000000
> [  144.060726] xhci_hcd 0000:11:00.0: @00000000ffffeab0 00000000 00000000 00000000 00000000
> [  144.060727] xhci_hcd 0000:11:00.0: @00000000ffffeac0 00000000 00000000 00000000 00000000
> [  144.060728] xhci_hcd 0000:11:00.0: @00000000ffffead0 00000000 00000000 00000000 00000000
> [  144.060730] xhci_hcd 0000:11:00.0: @00000000ffffeae0 00000000 00000000 00000000 00000000
> [  144.060731] xhci_hcd 0000:11:00.0: @00000000ffffeaf0 00000000 00000000 00000000 00000000
> [  144.060733] xhci_hcd 0000:11:00.0: @00000000ffffeb00 00000000 00000000 00000000 00000000
> [  144.060734] xhci_hcd 0000:11:00.0: @00000000ffffeb10 00000000 00000000 00000000 00000000
> [  144.060736] xhci_hcd 0000:11:00.0: @00000000ffffeb20 00000000 00000000 00000000 00000000
> [  144.060737] xhci_hcd 0000:11:00.0: @00000000ffffeb30 00000000 00000000 00000000 00000000
> [  144.060739] xhci_hcd 0000:11:00.0: @00000000ffffeb40 00000000 00000000 00000000 00000000
> [  144.060740] xhci_hcd 0000:11:00.0: @00000000ffffeb50 00000000 00000000 00000000 00000000
> [  144.060742] xhci_hcd 0000:11:00.0: @00000000ffffeb60 00000000 00000000 00000000 00000000
> [  144.060743] xhci_hcd 0000:11:00.0: @00000000ffffeb70 00000000 00000000 00000000 00000000
> [  144.060745] xhci_hcd 0000:11:00.0: @00000000ffffeb80 00000000 00000000 00000000 00000000
> [  144.060746] xhci_hcd 0000:11:00.0: @00000000ffffeb90 00000000 00000000 00000000 00000000
> [  144.060748] xhci_hcd 0000:11:00.0: @00000000ffffeba0 00000000 00000000 00000000 00000000
> [  144.060749] xhci_hcd 0000:11:00.0: @00000000ffffebb0 00000000 00000000 00000000 00000000
> [  144.060750] xhci_hcd 0000:11:00.0: @00000000ffffebc0 00000000 00000000 00000000 00000000
> [  144.060752] xhci_hcd 0000:11:00.0: @00000000ffffebd0 00000000 00000000 00000000 00000000
> [  144.060753] xhci_hcd 0000:11:00.0: @00000000ffffebe0 00000000 00000000 00000000 00000000
> [  144.060755] xhci_hcd 0000:11:00.0: @00000000ffffebf0 ffffa000 00000000 00000000 00001800
> [  144.060756] xhci_hcd 0000:11:00.0: Dev 1 endpoint ring 2:
> [  144.060758] xhci_hcd 0000:11:00.0: @00000000ffffa400 ffff9000 00000000 00000004 00000425
> [  144.060760] xhci_hcd 0000:11:00.0: @00000000ffffa410 00000000 00000000 00000000 00000000
> [  144.060761] xhci_hcd 0000:11:00.0: @00000000ffffa420 00000000 00000000 00000000 00000000
> [  144.060762] xhci_hcd 0000:11:00.0: @00000000ffffa430 00000000 00000000 00000000 00000000
> [  144.060764] xhci_hcd 0000:11:00.0: @00000000ffffa440 00000000 00000000 00000000 00000000
> [  144.060765] xhci_hcd 0000:11:00.0: @00000000ffffa450 00000000 00000000 00000000 00000000
> [  144.060767] xhci_hcd 0000:11:00.0: @00000000ffffa460 00000000 00000000 00000000 00000000
> [  144.060768] xhci_hcd 0000:11:00.0: @00000000ffffa470 00000000 00000000 00000000 00000000
> [  144.060770] xhci_hcd 0000:11:00.0: @00000000ffffa480 00000000 00000000 00000000 00000000
> [  144.060771] xhci_hcd 0000:11:00.0: @00000000ffffa490 00000000 00000000 00000000 00000000
> [  144.060773] xhci_hcd 0000:11:00.0: @00000000ffffa4a0 00000000 00000000 00000000 00000000
> [  144.060774] xhci_hcd 0000:11:00.0: @00000000ffffa4b0 00000000 00000000 00000000 00000000
> [  144.060776] xhci_hcd 0000:11:00.0: @00000000ffffa4c0 00000000 00000000 00000000 00000000
> [  144.060777] xhci_hcd 0000:11:00.0: @00000000ffffa4d0 00000000 00000000 00000000 00000000
> [  144.060779] xhci_hcd 0000:11:00.0: @00000000ffffa4e0 00000000 00000000 00000000 00000000
> [  144.060780] xhci_hcd 0000:11:00.0: @00000000ffffa4f0 00000000 00000000 00000000 00000000
> [  144.060782] xhci_hcd 0000:11:00.0: @00000000ffffa500 00000000 00000000 00000000 00000000
> [  144.060783] xhci_hcd 0000:11:00.0: @00000000ffffa510 00000000 00000000 00000000 00000000
> [  144.060785] xhci_hcd 0000:11:00.0: @00000000ffffa520 00000000 00000000 00000000 00000000
> [  144.060786] xhci_hcd 0000:11:00.0: @00000000ffffa530 00000000 00000000 00000000 00000000
> [  144.060788] xhci_hcd 0000:11:00.0: @00000000ffffa540 00000000 00000000 00000000 00000000
> [  144.060789] xhci_hcd 0000:11:00.0: @00000000ffffa550 00000000 00000000 00000000 00000000
> [  144.060790] xhci_hcd 0000:11:00.0: @00000000ffffa560 00000000 00000000 00000000 00000000
> [  144.060792] xhci_hcd 0000:11:00.0: @00000000ffffa570 00000000 00000000 00000000 00000000
> [  144.060793] xhci_hcd 0000:11:00.0: @00000000ffffa580 00000000 00000000 00000000 00000000
> [  144.060795] xhci_hcd 0000:11:00.0: @00000000ffffa590 00000000 00000000 00000000 00000000
> [  144.060796] xhci_hcd 0000:11:00.0: @00000000ffffa5a0 00000000 00000000 00000000 00000000
> [  144.060798] xhci_hcd 0000:11:00.0: @00000000ffffa5b0 00000000 00000000 00000000 00000000
> [  144.060799] xhci_hcd 0000:11:00.0: @00000000ffffa5c0 00000000 00000000 00000000 00000000
> [  144.060801] xhci_hcd 0000:11:00.0: @00000000ffffa5d0 00000000 00000000 00000000 00000000
> [  144.060802] xhci_hcd 0000:11:00.0: @00000000ffffa5e0 00000000 00000000 00000000 00000000
> [  144.060804] xhci_hcd 0000:11:00.0: @00000000ffffa5f0 00000000 00000000 00000000 00000000
> [  144.060805] xhci_hcd 0000:11:00.0: @00000000ffffa600 00000000 00000000 00000000 00000000
> [  144.060807] xhci_hcd 0000:11:00.0: @00000000ffffa610 00000000 00000000 00000000 00000000
> [  144.060808] xhci_hcd 0000:11:00.0: @00000000ffffa620 00000000 00000000 00000000 00000000
> [  144.060810] xhci_hcd 0000:11:00.0: @00000000ffffa630 00000000 00000000 00000000 00000000
> [  144.060811] xhci_hcd 0000:11:00.0: @00000000ffffa640 00000000 00000000 00000000 00000000
> [  144.060813] xhci_hcd 0000:11:00.0: @00000000ffffa650 00000000 00000000 00000000 00000000
> [  144.060814] xhci_hcd 0000:11:00.0: @00000000ffffa660 00000000 00000000 00000000 00000000
> [  144.060816] xhci_hcd 0000:11:00.0: @00000000ffffa670 00000000 00000000 00000000 00000000
> [  144.060817] xhci_hcd 0000:11:00.0: @00000000ffffa680 00000000 00000000 00000000 00000000
> [  144.060818] xhci_hcd 0000:11:00.0: @00000000ffffa690 00000000 00000000 00000000 00000000
> [  144.060820] xhci_hcd 0000:11:00.0: @00000000ffffa6a0 00000000 00000000 00000000 00000000
> [  144.060821] xhci_hcd 0000:11:00.0: @00000000ffffa6b0 00000000 00000000 00000000 00000000
> [  144.060823] xhci_hcd 0000:11:00.0: @00000000ffffa6c0 00000000 00000000 00000000 00000000
> [  144.060824] xhci_hcd 0000:11:00.0: @00000000ffffa6d0 00000000 00000000 00000000 00000000
> [  144.060826] xhci_hcd 0000:11:00.0: @00000000ffffa6e0 00000000 00000000 00000000 00000000
> [  144.060827] xhci_hcd 0000:11:00.0: @00000000ffffa6f0 00000000 00000000 00000000 00000000
> [  144.060829] xhci_hcd 0000:11:00.0: @00000000ffffa700 00000000 00000000 00000000 00000000
> [  144.060830] xhci_hcd 0000:11:00.0: @00000000ffffa710 00000000 00000000 00000000 00000000
> [  144.060832] xhci_hcd 0000:11:00.0: @00000000ffffa720 00000000 00000000 00000000 00000000
> [  144.060833] xhci_hcd 0000:11:00.0: @00000000ffffa730 00000000 00000000 00000000 00000000
> [  144.060835] xhci_hcd 0000:11:00.0: @00000000ffffa740 00000000 00000000 00000000 00000000
> [  144.060836] xhci_hcd 0000:11:00.0: @00000000ffffa750 00000000 00000000 00000000 00000000
> [  144.060837] xhci_hcd 0000:11:00.0: @00000000ffffa760 00000000 00000000 00000000 00000000
> [  144.060839] xhci_hcd 0000:11:00.0: @00000000ffffa770 00000000 00000000 00000000 00000000
> [  144.060840] xhci_hcd 0000:11:00.0: @00000000ffffa780 00000000 00000000 00000000 00000000
> [  144.060842] xhci_hcd 0000:11:00.0: @00000000ffffa790 00000000 00000000 00000000 00000000
> [  144.060843] xhci_hcd 0000:11:00.0: @00000000ffffa7a0 00000000 00000000 00000000 00000000
> [  144.060845] xhci_hcd 0000:11:00.0: @00000000ffffa7b0 00000000 00000000 00000000 00000000
> [  144.060846] xhci_hcd 0000:11:00.0: @00000000ffffa7c0 00000000 00000000 00000000 00000000
> [  144.060848] xhci_hcd 0000:11:00.0: @00000000ffffa7d0 00000000 00000000 00000000 00000000
> [  144.060849] xhci_hcd 0000:11:00.0: @00000000ffffa7e0 00000000 00000000 00000000 00000000
> [  144.060851] xhci_hcd 0000:11:00.0: @00000000ffffa7f0 ffffa800 00000000 00000000 00001800
> [  181.553477] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  181.553487] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  181.553497] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  181.554309] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  181.554508] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  181.554511] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [  181.614637] xhci_hcd 0000:11:00.0: remove, state 4
> [  181.615441] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  181.615445] usb usb4: USB disconnect, device number 1
> [  181.616228] usb usb4: unregistering device
> [  181.616230] usb usb4: unregistering interface 4-0:1.0
> [  181.616275] usb usb4: usb_disable_device nuking all URBs
> [  181.616285] xHCI xhci_drop_endpoint called for root hub
> [  181.616287] xHCI xhci_check_bandwidth called for root hub
> [  181.616361] xhci_hcd 0000:11:00.0: // Halt the HC
> [  181.616366] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  181.617214] xhci_hcd 0000:11:00.0: USB bus 4 deregistered
> [  181.618006] xhci_hcd 0000:11:00.0: remove, state 1
> [  181.618791] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  181.618793] usb usb3: USB disconnect, device number 1
> [  181.619576] usb 3-2: USB disconnect, device number 2
> [  181.620373] usb 3-2: unregistering device
> [  181.620374] usb 3-2: unregistering interface 3-2:1.0
> [  181.620395] xhci_hcd 0000:11:00.0: HW died, freeing TD.
> [  181.620398] xhci_hcd 0000:11:00.0: shutdown urb ffff880409c98740 ep1in-intr
> [  181.624658] usb 3-2: usb_disable_device nuking all URBs
> [  181.624663] xhci_hcd 0000:11:00.0: xhci_drop_endpoint called for udev ffff88040c440800
> [  181.624666] xhci_hcd 0000:11:00.0: drop ep 0x81, slot id 1, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8200000
> [  181.624669] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff88040c440800
> [  181.624671] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  181.624673] xhci_hcd 0000:11:00.0: @ffff88040ccd7000 (virt) @ffffb000 (dma) 0x000008 - drop flags
> [  181.624676] xhci_hcd 0000:11:00.0: @ffff88040ccd7004 (virt) @ffffb004 (dma) 0x000001 - add flags
> [  181.624678] xhci_hcd 0000:11:00.0: @ffff88040ccd7008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  181.624680] xhci_hcd 0000:11:00.0: @ffff88040ccd700c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  181.624682] xhci_hcd 0000:11:00.0: @ffff88040ccd7010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  181.624684] xhci_hcd 0000:11:00.0: @ffff88040ccd7014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  181.624687] xhci_hcd 0000:11:00.0: @ffff88040ccd7018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  181.624689] xhci_hcd 0000:11:00.0: @ffff88040ccd701c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  181.624691] xhci_hcd 0000:11:00.0: Slot Context:
> [  181.624693] xhci_hcd 0000:11:00.0: @ffff88040ccd7020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  181.624695] xhci_hcd 0000:11:00.0: @ffff88040ccd7024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  181.624697] xhci_hcd 0000:11:00.0: @ffff88040ccd7028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  181.624699] xhci_hcd 0000:11:00.0: @ffff88040ccd702c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  181.624709] xhci_hcd 0000:11:00.0: @ffff88040ccd7030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  181.624712] xhci_hcd 0000:11:00.0: @ffff88040ccd7034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  181.624715] xhci_hcd 0000:11:00.0: @ffff88040ccd7038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  181.624717] xhci_hcd 0000:11:00.0: @ffff88040ccd703c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  181.624719] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  181.624721] xhci_hcd 0000:11:00.0: @ffff88040ccd7040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  181.624724] xhci_hcd 0000:11:00.0: @ffff88040ccd7044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  181.624727] xhci_hcd 0000:11:00.0: @ffff88040ccd7048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  181.624730] xhci_hcd 0000:11:00.0: @ffff88040ccd7050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  181.624732] xhci_hcd 0000:11:00.0: @ffff88040ccd7054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  181.624735] xhci_hcd 0000:11:00.0: @ffff88040ccd7058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  181.624737] xhci_hcd 0000:11:00.0: @ffff88040ccd705c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  181.624741] xhci_hcd 0000:11:00.0: // Ding dong!
> [  204.130843] xhci_hcd 0000:11:00.0: Poll event ring: 4294957728
> [  204.130856] xhci_hcd 0000:11:00.0: op reg status = 0xffffffff
> [  204.130861] xhci_hcd 0000:11:00.0: HW died, polling stopped.
> [  231.550033] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> [  231.551108] usb usb3: unregistering device
> [  231.551110] usb usb3: unregistering interface 3-0:1.0
> [  231.551133] xhci_hcd 0000:11:00.0: shutdown urb ffff88040b913180 ep1in-intr
> [  231.551145] usb usb3: usb_disable_device nuking all URBs
> [  231.551147] xHCI xhci_drop_endpoint called for root hub
> [  231.551148] xHCI xhci_check_bandwidth called for root hub
> [  231.551206] xhci_hcd 0000:11:00.0: // Halt the HC
> [  231.551211] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  231.552101] xhci_hcd 0000:11:00.0: // Reset the HC
> [  231.552152] xhci_hcd 0000:11:00.0: // Disabling event ring interrupts
> [  231.552157] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set[0]
> [  231.552158] xhci_hcd 0000:11:00.0:   ffffc90006970620: ir_set.pending = 0xffffffff
> [  231.552161] xhci_hcd 0000:11:00.0:   ffffc90006970624: ir_set.control = 0xffffffff
> [  231.552164] xhci_hcd 0000:11:00.0:   ffffc90006970628: ir_set.erst_size = 0xffffffff
> [  231.552167] xhci_hcd 0000:11:00.0:   WARN: ffffc9000697062c: ir_set.rsvd = 0xffffffff
> [  231.552170] xhci_hcd 0000:11:00.0:   ffffc90006970630: ir_set.erst_base = @ffffffffffffffff
> [  231.552174] xhci_hcd 0000:11:00.0:   ffffc90006970638: ir_set.erst_dequeue = @ffffffffffffffff
> [  231.552175] xhci_hcd 0000:11:00.0: cleaning up memory
> [  231.552179] xhci_hcd 0000:11:00.0: Freed ERST
> [  231.552181] xhci_hcd 0000:11:00.0: Freed event ring
> [  231.552182] xhci_hcd 0000:11:00.0: Freed command ring
> [  231.552185] xhci_hcd 0000:11:00.0: Freed segment pool
> [  231.552187] xhci_hcd 0000:11:00.0: Freed device context pool
> [  231.552188] xhci_hcd 0000:11:00.0: Freed small stream array pool
> [  231.552190] xhci_hcd 0000:11:00.0: Freed medium stream array pool
> [  231.552193] xhci_hcd 0000:11:00.0: xhci_stop completed - status = ffffffff
> [  231.552196] xhci_hcd 0000:11:00.0: USB bus 3 deregistered
> [  303.631588] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  303.631591] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  303.631594] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  303.631651] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  303.631905] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  303.732514] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [  303.732627] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [  303.732678] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [  303.732934] pci 0000:11:00.0: PME# supported from D0 D3hot
> [  303.752549] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [  303.752626] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> [  303.752649] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> [  303.752675] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> [  303.752704] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> [  303.752867] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [  303.752936] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  303.752966] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 3
> [  303.753021] xhci_hcd 0000:11:00.0: xHCI capability registers at ffffc90006684000:
> [  303.753027] xhci_hcd 0000:11:00.0: CAPLENGTH AND HCIVERSION 0x960020:
> [  303.753029] xhci_hcd 0000:11:00.0: CAPLENGTH: 0x20
> [  303.753030] xhci_hcd 0000:11:00.0: HCIVERSION: 0x96
> [  303.753035] xhci_hcd 0000:11:00.0: HCSPARAMS 1: 0x4000820
> [  303.753037] xhci_hcd 0000:11:00.0:   Max device slots: 32
> [  303.753038] xhci_hcd 0000:11:00.0:   Max interrupters: 8
> [  303.753039] xhci_hcd 0000:11:00.0:   Max ports: 4
> [  303.753045] xhci_hcd 0000:11:00.0: HCSPARAMS 2: 0x11
> [  303.753046] xhci_hcd 0000:11:00.0:   Isoc scheduling threshold: 1
> [  303.753047] xhci_hcd 0000:11:00.0:   Maximum allowed segments in event ring: 1
> [  303.753053] xhci_hcd 0000:11:00.0: HCSPARAMS 3 0x0:
> [  303.753054] xhci_hcd 0000:11:00.0:   Worst case U1 device exit latency: 0
> [  303.753056] xhci_hcd 0000:11:00.0:   Worst case U2 device exit latency: 0
> [  303.753062] xhci_hcd 0000:11:00.0: HCC PARAMS 0x14042cb:
> [  303.753063] xhci_hcd 0000:11:00.0:   HC generates 64 bit addresses
> [  303.753064] xhci_hcd 0000:11:00.0:   FIXME: more HCCPARAMS debugging
> [  303.753070] xhci_hcd 0000:11:00.0: RTSOFF 0x600:
> [  303.753072] xhci_hcd 0000:11:00.0: xHCI operational registers at ffffc90006684020:
> [  303.753078] xhci_hcd 0000:11:00.0: USBCMD 0x0:
> [  303.753079] xhci_hcd 0000:11:00.0:   HC is being stopped
> [  303.753080] xhci_hcd 0000:11:00.0:   HC has finished hard reset
> [  303.753081] xhci_hcd 0000:11:00.0:   Event Interrupts disabled
> [  303.753082] xhci_hcd 0000:11:00.0:   Host System Error Interrupts disabled
> [  303.753084] xhci_hcd 0000:11:00.0:   HC has finished light reset
> [  303.753090] xhci_hcd 0000:11:00.0: USBSTS 0x11:
> [  303.753091] xhci_hcd 0000:11:00.0:   Event ring is empty
> [  303.753092] xhci_hcd 0000:11:00.0:   No Host System Error
> [  303.753093] xhci_hcd 0000:11:00.0:   HC is halted
> [  303.753099] xhci_hcd 0000:11:00.0: ffffc90006684420 port status reg = 0x2a0
> [  303.753106] xhci_hcd 0000:11:00.0: ffffc90006684424 port power reg = 0x0
> [  303.753112] xhci_hcd 0000:11:00.0: ffffc90006684428 port link reg = 0x0
> [  303.753118] xhci_hcd 0000:11:00.0: ffffc9000668442c port reserved reg = 0x0
> [  303.753125] xhci_hcd 0000:11:00.0: ffffc90006684430 port status reg = 0x2a0
> [  303.753131] xhci_hcd 0000:11:00.0: ffffc90006684434 port power reg = 0x0
> [  303.753137] xhci_hcd 0000:11:00.0: ffffc90006684438 port link reg = 0x0
> [  303.753143] xhci_hcd 0000:11:00.0: ffffc9000668443c port reserved reg = 0x0
> [  303.753149] xhci_hcd 0000:11:00.0: ffffc90006684440 port status reg = 0x2a0
> [  303.753155] xhci_hcd 0000:11:00.0: ffffc90006684444 port power reg = 0x0
> [  303.753161] xhci_hcd 0000:11:00.0: ffffc90006684448 port link reg = 0x0
> [  303.753167] xhci_hcd 0000:11:00.0: ffffc9000668444c port reserved reg = 0x0
> [  303.753173] xhci_hcd 0000:11:00.0: ffffc90006684450 port status reg = 0x202e1
> [  303.753179] xhci_hcd 0000:11:00.0: ffffc90006684454 port power reg = 0x0
> [  303.753185] xhci_hcd 0000:11:00.0: ffffc90006684458 port link reg = 0x0
> [  303.753191] xhci_hcd 0000:11:00.0: ffffc9000668445c port reserved reg = 0x0
> [  303.753193] xhci_hcd 0000:11:00.0: // Halt the HC
> [  303.753205] xhci_hcd 0000:11:00.0: Resetting HCD
> [  303.753211] xhci_hcd 0000:11:00.0: // Reset the HC
> [  303.753260] xhci_hcd 0000:11:00.0: Wait for controller to be ready for doorbell rings
> [  303.753266] xhci_hcd 0000:11:00.0: Reset complete
> [  303.753272] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  303.753273] xhci_hcd 0000:11:00.0: Calling HCD init
> [  303.753274] xhci_hcd 0000:11:00.0: xhci_init
> [  303.753275] xhci_hcd 0000:11:00.0: xHCI doesn't need link TRB QUIRK
> [  303.753282] xhci_hcd 0000:11:00.0: Supported page size register = 0x1
> [  303.753283] xhci_hcd 0000:11:00.0: Supported page size of 4K
> [  303.753284] xhci_hcd 0000:11:00.0: HCD page size set to 4K
> [  303.753290] xhci_hcd 0000:11:00.0: // xHC can handle at most 32 device slots.
> [  303.753296] xhci_hcd 0000:11:00.0: // Setting Max device slots reg = 0x20.
> [  303.753316] xhci_hcd 0000:11:00.0: // Device context base array address = 0xfffff000 (DMA), ffff88040c427000 (virt)
> [  303.753320] xhci_hcd 0000:11:00.0: Allocated command ring at ffff88040df134c0
> [  303.753322] xhci_hcd 0000:11:00.0: First segment DMA is 0xffffe000
> [  303.753331] xhci_hcd 0000:11:00.0: // Setting command ring address to 0x20
> [  303.753340] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  303.753342] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  303.753348] xhci_hcd 0000:11:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
> [  303.753350] xhci_hcd 0000:11:00.0: // xHCI capability registers at ffffc90006684000:
> [  303.753356] xhci_hcd 0000:11:00.0: // @ffffc90006684000 = 0x960020 (CAPLENGTH AND HCIVERSION)
> [  303.753358] xhci_hcd 0000:11:00.0: //   CAPLENGTH: 0x20
> [  303.753359] xhci_hcd 0000:11:00.0: // xHCI operational registers at ffffc90006684020:
> [  303.753365] xhci_hcd 0000:11:00.0: // @ffffc90006684018 = 0x600 RTSOFF
> [  303.753366] xhci_hcd 0000:11:00.0: // xHCI runtime registers at ffffc90006684600:
> [  303.753372] xhci_hcd 0000:11:00.0: // @ffffc90006684014 = 0x800 DBOFF
> [  303.753374] xhci_hcd 0000:11:00.0: // Doorbell array at ffffc90006684800:
> [  303.753375] xhci_hcd 0000:11:00.0: xHCI runtime registers at ffffc90006684600:
> [  303.753381] xhci_hcd 0000:11:00.0:   ffffc90006684600: Microframe index = 0x0
> [  303.753406] xhci_hcd 0000:11:00.0: // Allocating event ring
> [  303.753409] xhci_hcd 0000:11:00.0: TRB math tests passed.
> [  303.753411] xhci_hcd 0000:11:00.0: // Allocated event ring segment table at 0xffffd000
> [  303.753413] xhci_hcd 0000:11:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88040ac46000, dma addr = 0xffffd000
> [  303.753419] xhci_hcd 0000:11:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [  303.753421] xhci_hcd 0000:11:00.0: // Set ERST entries to point to event ring.
> [  303.753422] xhci_hcd 0000:11:00.0: // Set ERST base address for ir_set 0 = 0xffffd000
> [  303.753439] xhci_hcd 0000:11:00.0: // Write event ring dequeue pointer, preserving EHB bit
> [  303.753440] xhci_hcd 0000:11:00.0: Wrote ERST address to ir_set 0.
> [  303.753445] xhci_hcd 0000:11:00.0: Allocating 0 scratchpad buffers
> [  303.753464] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006684510, port offset = 1, count = 2, revision = 0x3
> [  303.753473] xhci_hcd 0000:11:00.0: Ext Cap ffffc90006684520, port offset = 3, count = 2, revision = 0x2
> [  303.753475] xhci_hcd 0000:11:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [  303.753477] xhci_hcd 0000:11:00.0: USB 2.0 port at index 2, addr = ffffc90006684440
> [  303.753478] xhci_hcd 0000:11:00.0: USB 2.0 port at index 3, addr = ffffc90006684450
> [  303.753480] xhci_hcd 0000:11:00.0: USB 3.0 port at index 0, addr = ffffc90006684420
> [  303.753481] xhci_hcd 0000:11:00.0: USB 3.0 port at index 1, addr = ffffc90006684430
> [  303.753487] xhci_hcd 0000:11:00.0: Finished xhci_init
> [  303.753489] xhci_hcd 0000:11:00.0: Called HCD init
> [  303.753495] xhci_hcd 0000:11:00.0: Got SBRN 48
> [  303.753513] xhci_hcd 0000:11:00.0: MWI active
> [  303.753514] xhci_hcd 0000:11:00.0: Finished xhci_pci_reinit
> [  303.753515] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  303.753526] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [  303.753547] xhci_hcd 0000:11:00.0: xhci_run
> [  303.753652] xhci_hcd 0000:11:00.0: irq 49 for MSI/MSI-X
> [  303.753656] xhci_hcd 0000:11:00.0: irq 50 for MSI/MSI-X
> [  303.753660] xhci_hcd 0000:11:00.0: irq 51 for MSI/MSI-X
> [  303.753664] xhci_hcd 0000:11:00.0: irq 52 for MSI/MSI-X
> [  303.753668] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [  303.753759] xhci_hcd 0000:11:00.0: Setting event ring polling timer
> [  303.753761] xhci_hcd 0000:11:00.0: Command ring memory map follows:
> [  303.753763] xhci_hcd 0000:11:00.0: @00000000ffffe000 00000000 00000000 00000000 00000000
> [  303.753765] xhci_hcd 0000:11:00.0: @00000000ffffe010 00000000 00000000 00000000 00000000
> [  303.753766] xhci_hcd 0000:11:00.0: @00000000ffffe020 00000000 00000000 00000000 00000000
> [  303.753768] xhci_hcd 0000:11:00.0: @00000000ffffe030 00000000 00000000 00000000 00000000
> [  303.753769] xhci_hcd 0000:11:00.0: @00000000ffffe040 00000000 00000000 00000000 00000000
> [  303.753771] xhci_hcd 0000:11:00.0: @00000000ffffe050 00000000 00000000 00000000 00000000
> [  303.753773] xhci_hcd 0000:11:00.0: @00000000ffffe060 00000000 00000000 00000000 00000000
> [  303.753774] xhci_hcd 0000:11:00.0: @00000000ffffe070 00000000 00000000 00000000 00000000
> [  303.753776] xhci_hcd 0000:11:00.0: @00000000ffffe080 00000000 00000000 00000000 00000000
> [  303.753777] xhci_hcd 0000:11:00.0: @00000000ffffe090 00000000 00000000 00000000 00000000
> [  303.753779] xhci_hcd 0000:11:00.0: @00000000ffffe0a0 00000000 00000000 00000000 00000000
> [  303.753780] xhci_hcd 0000:11:00.0: @00000000ffffe0b0 00000000 00000000 00000000 00000000
> [  303.753782] xhci_hcd 0000:11:00.0: @00000000ffffe0c0 00000000 00000000 00000000 00000000
> [  303.753784] xhci_hcd 0000:11:00.0: @00000000ffffe0d0 00000000 00000000 00000000 00000000
> [  303.753785] xhci_hcd 0000:11:00.0: @00000000ffffe0e0 00000000 00000000 00000000 00000000
> [  303.753787] xhci_hcd 0000:11:00.0: @00000000ffffe0f0 00000000 00000000 00000000 00000000
> [  303.753788] xhci_hcd 0000:11:00.0: @00000000ffffe100 00000000 00000000 00000000 00000000
> [  303.753790] xhci_hcd 0000:11:00.0: @00000000ffffe110 00000000 00000000 00000000 00000000
> [  303.753792] xhci_hcd 0000:11:00.0: @00000000ffffe120 00000000 00000000 00000000 00000000
> [  303.753793] xhci_hcd 0000:11:00.0: @00000000ffffe130 00000000 00000000 00000000 00000000
> [  303.753795] xhci_hcd 0000:11:00.0: @00000000ffffe140 00000000 00000000 00000000 00000000
> [  303.753796] xhci_hcd 0000:11:00.0: @00000000ffffe150 00000000 00000000 00000000 00000000
> [  303.753798] xhci_hcd 0000:11:00.0: @00000000ffffe160 00000000 00000000 00000000 00000000
> [  303.753799] xhci_hcd 0000:11:00.0: @00000000ffffe170 00000000 00000000 00000000 00000000
> [  303.753801] xhci_hcd 0000:11:00.0: @00000000ffffe180 00000000 00000000 00000000 00000000
> [  303.753803] xhci_hcd 0000:11:00.0: @00000000ffffe190 00000000 00000000 00000000 00000000
> [  303.753804] xhci_hcd 0000:11:00.0: @00000000ffffe1a0 00000000 00000000 00000000 00000000
> [  303.753806] xhci_hcd 0000:11:00.0: @00000000ffffe1b0 00000000 00000000 00000000 00000000
> [  303.753807] xhci_hcd 0000:11:00.0: @00000000ffffe1c0 00000000 00000000 00000000 00000000
> [  303.753809] xhci_hcd 0000:11:00.0: @00000000ffffe1d0 00000000 00000000 00000000 00000000
> [  303.753810] xhci_hcd 0000:11:00.0: @00000000ffffe1e0 00000000 00000000 00000000 00000000
> [  303.753812] xhci_hcd 0000:11:00.0: @00000000ffffe1f0 00000000 00000000 00000000 00000000
> [  303.753814] xhci_hcd 0000:11:00.0: @00000000ffffe200 00000000 00000000 00000000 00000000
> [  303.753815] xhci_hcd 0000:11:00.0: @00000000ffffe210 00000000 00000000 00000000 00000000
> [  303.753824] xhci_hcd 0000:11:00.0: @00000000ffffe220 00000000 00000000 00000000 00000000
> [  303.753826] xhci_hcd 0000:11:00.0: @00000000ffffe230 00000000 00000000 00000000 00000000
> [  303.753827] xhci_hcd 0000:11:00.0: @00000000ffffe240 00000000 00000000 00000000 00000000
> [  303.753829] xhci_hcd 0000:11:00.0: @00000000ffffe250 00000000 00000000 00000000 00000000
> [  303.753830] xhci_hcd 0000:11:00.0: @00000000ffffe260 00000000 00000000 00000000 00000000
> [  303.753832] xhci_hcd 0000:11:00.0: @00000000ffffe270 00000000 00000000 00000000 00000000
> [  303.753833] xhci_hcd 0000:11:00.0: @00000000ffffe280 00000000 00000000 00000000 00000000
> [  303.753835] xhci_hcd 0000:11:00.0: @00000000ffffe290 00000000 00000000 00000000 00000000
> [  303.753836] xhci_hcd 0000:11:00.0: @00000000ffffe2a0 00000000 00000000 00000000 00000000
> [  303.753838] xhci_hcd 0000:11:00.0: @00000000ffffe2b0 00000000 00000000 00000000 00000000
> [  303.753839] xhci_hcd 0000:11:00.0: @00000000ffffe2c0 00000000 00000000 00000000 00000000
> [  303.753841] xhci_hcd 0000:11:00.0: @00000000ffffe2d0 00000000 00000000 00000000 00000000
> [  303.753842] xhci_hcd 0000:11:00.0: @00000000ffffe2e0 00000000 00000000 00000000 00000000
> [  303.753844] xhci_hcd 0000:11:00.0: @00000000ffffe2f0 00000000 00000000 00000000 00000000
> [  303.753845] xhci_hcd 0000:11:00.0: @00000000ffffe300 00000000 00000000 00000000 00000000
> [  303.753847] xhci_hcd 0000:11:00.0: @00000000ffffe310 00000000 00000000 00000000 00000000
> [  303.753848] xhci_hcd 0000:11:00.0: @00000000ffffe320 00000000 00000000 00000000 00000000
> [  303.753850] xhci_hcd 0000:11:00.0: @00000000ffffe330 00000000 00000000 00000000 00000000
> [  303.753851] xhci_hcd 0000:11:00.0: @00000000ffffe340 00000000 00000000 00000000 00000000
> [  303.753853] xhci_hcd 0000:11:00.0: @00000000ffffe350 00000000 00000000 00000000 00000000
> [  303.753854] xhci_hcd 0000:11:00.0: @00000000ffffe360 00000000 00000000 00000000 00000000
> [  303.753856] xhci_hcd 0000:11:00.0: @00000000ffffe370 00000000 00000000 00000000 00000000
> [  303.753857] xhci_hcd 0000:11:00.0: @00000000ffffe380 00000000 00000000 00000000 00000000
> [  303.753858] xhci_hcd 0000:11:00.0: @00000000ffffe390 00000000 00000000 00000000 00000000
> [  303.753860] xhci_hcd 0000:11:00.0: @00000000ffffe3a0 00000000 00000000 00000000 00000000
> [  303.753861] xhci_hcd 0000:11:00.0: @00000000ffffe3b0 00000000 00000000 00000000 00000000
> [  303.753863] xhci_hcd 0000:11:00.0: @00000000ffffe3c0 00000000 00000000 00000000 00000000
> [  303.753864] xhci_hcd 0000:11:00.0: @00000000ffffe3d0 00000000 00000000 00000000 00000000
> [  303.753866] xhci_hcd 0000:11:00.0: @00000000ffffe3e0 00000000 00000000 00000000 00000000
> [  303.753868] xhci_hcd 0000:11:00.0: @00000000ffffe3f0 ffffe000 00000000 00000000 00001802
> [  303.753869] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  303.753870] xhci_hcd 0000:11:00.0: Ring deq = ffff88040b8f6000 (virt), 0xffffe000 (dma)
> [  303.753872] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  303.753873] xhci_hcd 0000:11:00.0: Ring enq = ffff88040b8f6000 (virt), 0xffffe000 (dma)
> [  303.753874] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  303.753883] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr low bits + flags = @00000000
> [  303.753885] xhci_hcd 0000:11:00.0: // xHC command ring deq ptr high bits = @00000000
> [  303.753886] xhci_hcd 0000:11:00.0: ERST memory map follows:
> [  303.753887] xhci_hcd 0000:11:00.0: @00000000ffffd000 ffffe400 00000000 00000040 00000000
> [  303.753889] xhci_hcd 0000:11:00.0: Event ring:
> [  303.753890] xhci_hcd 0000:11:00.0: @00000000ffffe400 00000000 00000000 00000000 00000000
> [  303.753891] xhci_hcd 0000:11:00.0: @00000000ffffe410 00000000 00000000 00000000 00000000
> [  303.753893] xhci_hcd 0000:11:00.0: @00000000ffffe420 00000000 00000000 00000000 00000000
> [  303.753894] xhci_hcd 0000:11:00.0: @00000000ffffe430 00000000 00000000 00000000 00000000
> [  303.753896] xhci_hcd 0000:11:00.0: @00000000ffffe440 00000000 00000000 00000000 00000000
> [  303.753897] xhci_hcd 0000:11:00.0: @00000000ffffe450 00000000 00000000 00000000 00000000
> [  303.753899] xhci_hcd 0000:11:00.0: @00000000ffffe460 00000000 00000000 00000000 00000000
> [  303.753900] xhci_hcd 0000:11:00.0: @00000000ffffe470 00000000 00000000 00000000 00000000
> [  303.753902] xhci_hcd 0000:11:00.0: @00000000ffffe480 00000000 00000000 00000000 00000000
> [  303.753903] xhci_hcd 0000:11:00.0: @00000000ffffe490 00000000 00000000 00000000 00000000
> [  303.753905] xhci_hcd 0000:11:00.0: @00000000ffffe4a0 00000000 00000000 00000000 00000000
> [  303.753906] xhci_hcd 0000:11:00.0: @00000000ffffe4b0 00000000 00000000 00000000 00000000
> [  303.753908] xhci_hcd 0000:11:00.0: @00000000ffffe4c0 00000000 00000000 00000000 00000000
> [  303.753909] xhci_hcd 0000:11:00.0: @00000000ffffe4d0 00000000 00000000 00000000 00000000
> [  303.753911] xhci_hcd 0000:11:00.0: @00000000ffffe4e0 00000000 00000000 00000000 00000000
> [  303.753912] xhci_hcd 0000:11:00.0: @00000000ffffe4f0 00000000 00000000 00000000 00000000
> [  303.753914] xhci_hcd 0000:11:00.0: @00000000ffffe500 00000000 00000000 00000000 00000000
> [  303.753915] xhci_hcd 0000:11:00.0: @00000000ffffe510 00000000 00000000 00000000 00000000
> [  303.753916] xhci_hcd 0000:11:00.0: @00000000ffffe520 00000000 00000000 00000000 00000000
> [  303.753918] xhci_hcd 0000:11:00.0: @00000000ffffe530 00000000 00000000 00000000 00000000
> [  303.753919] xhci_hcd 0000:11:00.0: @00000000ffffe540 00000000 00000000 00000000 00000000
> [  303.753921] xhci_hcd 0000:11:00.0: @00000000ffffe550 00000000 00000000 00000000 00000000
> [  303.753922] xhci_hcd 0000:11:00.0: @00000000ffffe560 00000000 00000000 00000000 00000000
> [  303.753924] xhci_hcd 0000:11:00.0: @00000000ffffe570 00000000 00000000 00000000 00000000
> [  303.753925] xhci_hcd 0000:11:00.0: @00000000ffffe580 00000000 00000000 00000000 00000000
> [  303.753927] xhci_hcd 0000:11:00.0: @00000000ffffe590 00000000 00000000 00000000 00000000
> [  303.753928] xhci_hcd 0000:11:00.0: @00000000ffffe5a0 00000000 00000000 00000000 00000000
> [  303.753930] xhci_hcd 0000:11:00.0: @00000000ffffe5b0 00000000 00000000 00000000 00000000
> [  303.753931] xhci_hcd 0000:11:00.0: @00000000ffffe5c0 00000000 00000000 00000000 00000000
> [  303.753933] xhci_hcd 0000:11:00.0: @00000000ffffe5d0 00000000 00000000 00000000 00000000
> [  303.753934] xhci_hcd 0000:11:00.0: @00000000ffffe5e0 00000000 00000000 00000000 00000000
> [  303.753936] xhci_hcd 0000:11:00.0: @00000000ffffe5f0 00000000 00000000 00000000 00000000
> [  303.753937] xhci_hcd 0000:11:00.0: @00000000ffffe600 00000000 00000000 00000000 00000000
> [  303.753939] xhci_hcd 0000:11:00.0: @00000000ffffe610 00000000 00000000 00000000 00000000
> [  303.753940] xhci_hcd 0000:11:00.0: @00000000ffffe620 00000000 00000000 00000000 00000000
> [  303.753941] xhci_hcd 0000:11:00.0: @00000000ffffe630 00000000 00000000 00000000 00000000
> [  303.753943] xhci_hcd 0000:11:00.0: @00000000ffffe640 00000000 00000000 00000000 00000000
> [  303.753944] xhci_hcd 0000:11:00.0: @00000000ffffe650 00000000 00000000 00000000 00000000
> [  303.753946] xhci_hcd 0000:11:00.0: @00000000ffffe660 00000000 00000000 00000000 00000000
> [  303.753947] xhci_hcd 0000:11:00.0: @00000000ffffe670 00000000 00000000 00000000 00000000
> [  303.753949] xhci_hcd 0000:11:00.0: @00000000ffffe680 00000000 00000000 00000000 00000000
> [  303.753950] xhci_hcd 0000:11:00.0: @00000000ffffe690 00000000 00000000 00000000 00000000
> [  303.753952] xhci_hcd 0000:11:00.0: @00000000ffffe6a0 00000000 00000000 00000000 00000000
> [  303.753953] xhci_hcd 0000:11:00.0: @00000000ffffe6b0 00000000 00000000 00000000 00000000
> [  303.753955] xhci_hcd 0000:11:00.0: @00000000ffffe6c0 00000000 00000000 00000000 00000000
> [  303.753956] xhci_hcd 0000:11:00.0: @00000000ffffe6d0 00000000 00000000 00000000 00000000
> [  303.753958] xhci_hcd 0000:11:00.0: @00000000ffffe6e0 00000000 00000000 00000000 00000000
> [  303.753959] xhci_hcd 0000:11:00.0: @00000000ffffe6f0 00000000 00000000 00000000 00000000
> [  303.753961] xhci_hcd 0000:11:00.0: @00000000ffffe700 00000000 00000000 00000000 00000000
> [  303.753962] xhci_hcd 0000:11:00.0: @00000000ffffe710 00000000 00000000 00000000 00000000
> [  303.753964] xhci_hcd 0000:11:00.0: @00000000ffffe720 00000000 00000000 00000000 00000000
> [  303.753965] xhci_hcd 0000:11:00.0: @00000000ffffe730 00000000 00000000 00000000 00000000
> [  303.753967] xhci_hcd 0000:11:00.0: @00000000ffffe740 00000000 00000000 00000000 00000000
> [  303.753968] xhci_hcd 0000:11:00.0: @00000000ffffe750 00000000 00000000 00000000 00000000
> [  303.753970] xhci_hcd 0000:11:00.0: @00000000ffffe760 00000000 00000000 00000000 00000000
> [  303.753971] xhci_hcd 0000:11:00.0: @00000000ffffe770 00000000 00000000 00000000 00000000
> [  303.753972] xhci_hcd 0000:11:00.0: @00000000ffffe780 00000000 00000000 00000000 00000000
> [  303.753974] xhci_hcd 0000:11:00.0: @00000000ffffe790 00000000 00000000 00000000 00000000
> [  303.753975] xhci_hcd 0000:11:00.0: @00000000ffffe7a0 00000000 00000000 00000000 00000000
> [  303.753977] xhci_hcd 0000:11:00.0: @00000000ffffe7b0 00000000 00000000 00000000 00000000
> [  303.753978] xhci_hcd 0000:11:00.0: @00000000ffffe7c0 00000000 00000000 00000000 00000000
> [  303.753980] xhci_hcd 0000:11:00.0: @00000000ffffe7d0 00000000 00000000 00000000 00000000
> [  303.753981] xhci_hcd 0000:11:00.0: @00000000ffffe7e0 00000000 00000000 00000000 00000000
> [  303.753983] xhci_hcd 0000:11:00.0: @00000000ffffe7f0 00000000 00000000 00000000 00000000
> [  303.753984] xhci_hcd 0000:11:00.0:   Ring has not been updated
> [  303.753985] xhci_hcd 0000:11:00.0: Ring deq = ffff88040b8f6400 (virt), 0xffffe400 (dma)
> [  303.753987] xhci_hcd 0000:11:00.0: Ring deq updated 0 times
> [  303.753988] xhci_hcd 0000:11:00.0: Ring enq = ffff88040b8f6400 (virt), 0xffffe400 (dma)
> [  303.753989] xhci_hcd 0000:11:00.0: Ring enq updated 0 times
> [  303.753999] xhci_hcd 0000:11:00.0: ERST deq = 64'hffffe400
> [  303.754000] xhci_hcd 0000:11:00.0: // Set the interrupt modulation register
> [  303.754010] xhci_hcd 0000:11:00.0: // Enable interrupts, cmd = 0x4.
> [  303.754016] xhci_hcd 0000:11:00.0: // Enabling event ring interrupter ffffc90006684620 by writing 0x2 to irq_pending
> [  303.754023] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set[0]
> [  303.754024] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set.pending = 0x2
> [  303.754030] xhci_hcd 0000:11:00.0:   ffffc90006684624: ir_set.control = 0xa0
> [  303.754036] xhci_hcd 0000:11:00.0:   ffffc90006684628: ir_set.erst_size = 0x1
> [  303.754049] xhci_hcd 0000:11:00.0:   ffffc90006684630: ir_set.erst_base = @ffffd000
> [  303.754059] xhci_hcd 0000:11:00.0:   ffffc90006684638: ir_set.erst_dequeue = @ffffe400
> [  303.754060] xhci_hcd 0000:11:00.0: Finished xhci_run for USB2 roothub
> [  303.754069] usb usb3: default language 0x0409
> [  303.754073] usb usb3: udev 1, busnum 3, minor = 256
> [  303.754075] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [  303.754098] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  303.754123] usb usb3: Product: xHCI Host Controller
> [  303.754142] usb usb3: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  303.754165] usb usb3: SerialNumber: 0000:11:00.0
> [  303.754246] usb usb3: usb_probe_device
> [  303.754248] usb usb3: configuration #1 chosen from 1 choice
> [  303.754251] xHCI xhci_add_endpoint called for root hub
> [  303.754252] xHCI xhci_check_bandwidth called for root hub
> [  303.754256] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [  303.754273] hub 3-0:1.0: usb_probe_interface
> [  303.754274] hub 3-0:1.0: usb_probe_interface - got id
> [  303.754276] hub 3-0:1.0: USB hub found
> [  303.754300] hub 3-0:1.0: 2 ports detected
> [  303.754317] hub 3-0:1.0: standalone hub
> [  303.754318] hub 3-0:1.0: individual port power switching
> [  303.754319] hub 3-0:1.0: individual port over-current protection
> [  303.754321] hub 3-0:1.0: Single TT
> [  303.754322] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  303.754323] hub 3-0:1.0: power on to power good time: 20ms
> [  303.754326] hub 3-0:1.0: local power source is good
> [  303.754327] hub 3-0:1.0: enabling power on all ports
> [  303.754337] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  303.754350] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  303.754391] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [  303.754413] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 4
> [  303.754445] xhci_hcd 0000:11:00.0: Enabling 64-bit DMA addresses.
> [  303.754446] xhci_hcd 0000:11:00.0: supports USB remote wakeup
> [  303.754452] xhci_hcd 0000:11:00.0: // Turn on HC, cmd = 0x5.
> [  303.756661] xhci_hcd 0000:11:00.0: // Ding dong!
> [  303.756668] xhci_hcd 0000:11:00.0: Finished xhci_run for USB3 roothub
> [  303.756677] usb usb4: skipped 1 descriptor after endpoint
> [  303.756680] usb usb4: default language 0x0409
> [  303.756686] usb usb4: udev 1, busnum 4, minor = 384
> [  303.756688] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [  303.756725] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  303.756770] xhci_hcd 0000:11:00.0: Vendor specific event TRB type = 48
> [  303.756780] xhci_hcd 0000:11:00.0: NEC firmware version 30.28
> [  303.756791] usb usb4: Product: xHCI Host Controller
> [  303.756818] usb usb4: Manufacturer: Linux 3.4.0-rc5-default xhci_hcd
> [  303.756849] usb usb4: SerialNumber: 0000:11:00.0
> [  303.756969] usb usb4: usb_probe_device
> [  303.756971] usb usb4: configuration #1 chosen from 1 choice
> [  303.756974] xHCI xhci_add_endpoint called for root hub
> [  303.756975] xHCI xhci_check_bandwidth called for root hub
> [  303.756980] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [  303.757003] hub 4-0:1.0: usb_probe_interface
> [  303.757005] hub 4-0:1.0: usb_probe_interface - got id
> [  303.757007] hub 4-0:1.0: USB hub found
> [  303.757047] hub 4-0:1.0: 2 ports detected
> [  303.757071] hub 4-0:1.0: standalone hub
> [  303.757072] hub 4-0:1.0: individual port power switching
> [  303.757074] hub 4-0:1.0: individual port over-current protection
> [  303.757076] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
> [  303.757078] hub 4-0:1.0: power on to power good time: 20ms
> [  303.757082] hub 4-0:1.0: local power source is good
> [  303.757083] hub 4-0:1.0: enabling power on all ports
> [  303.757100] xhci_hcd 0000:11:00.0: set port power, actual port 0 status  = 0x2a0
> [  303.757125] xhci_hcd 0000:11:00.0: set port power, actual port 1 status  = 0x2a0
> [  303.827283] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  303.852348] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  303.852358] xhci_hcd 0000:11:00.0: Get port status returned 0x100
> [  303.852377] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x202e1
> [  303.852383] xhci_hcd 0000:11:00.0: Get port status returned 0x10101
> [  303.852391] hub 3-0:1.0: port 2: status 0101 change 0001
> [  303.852408] xhci_hcd 0000:11:00.0: clear port connect change, actual port 1 status  = 0x2e1
> [  303.852427] xhci_hcd 0000:11:00.0: get port status, actual port 0 status  = 0x2a0
> [  303.852440] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  303.852447] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2a0
> [  303.852448] xhci_hcd 0000:11:00.0: Get port status returned 0x2a0
> [  303.852485] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [  303.952312] hub 3-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [  303.952325] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x2e1
> [  303.952327] xhci_hcd 0000:11:00.0: Get port status returned 0x101
> [  303.952331] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [  303.952334] xhci_hcd 0000:11:00.0: // Ding dong!
> [  303.952415] xhci_hcd 0000:11:00.0: Slot 1 output ctx = 0xffffc000 (dma)
> [  303.952419] xhci_hcd 0000:11:00.0: Slot 1 input ctx = 0xffffb000 (dma)
> [  303.952424] xhci_hcd 0000:11:00.0: Set slot id 1 dcbaa entry ffff88040c427008 to 0xffffc000
> [  303.952439] xhci_hcd 0000:11:00.0: set port reset, actual port 1 status  = 0x331
> [  304.002468] xhci_hcd 0000:11:00.0: Port Status Change Event for port 4
> [  304.012231] xhci_hcd 0000:11:00.0: get port status, actual port 1 status  = 0x200a03
> [  304.012235] xhci_hcd 0000:11:00.0: Get port status returned 0x100303
> [  304.072020] xhci_hcd 0000:11:00.0: clear port reset change, actual port 1 status  = 0xa03
> [  304.072039] usb 3-2: new low-speed USB device number 2 using xhci_hcd
> [  304.072124] xhci_hcd 0000:11:00.0: Set root hub portnum to 4
> [  304.072125] xhci_hcd 0000:11:00.0: Set fake root hub portnum to 2
> [  304.072127] xhci_hcd 0000:11:00.0: udev->tt = ffff88040c48a898
> [  304.072128] xhci_hcd 0000:11:00.0: udev->ttport = 0x2
> [  304.072129] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  304.072131] xhci_hcd 0000:11:00.0: @ffff88040c421000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  304.072133] xhci_hcd 0000:11:00.0: @ffff88040c421004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  304.072135] xhci_hcd 0000:11:00.0: @ffff88040c421008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  304.072137] xhci_hcd 0000:11:00.0: @ffff88040c42100c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  304.072138] xhci_hcd 0000:11:00.0: @ffff88040c421010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  304.072140] xhci_hcd 0000:11:00.0: @ffff88040c421014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  304.072142] xhci_hcd 0000:11:00.0: @ffff88040c421018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  304.072143] xhci_hcd 0000:11:00.0: @ffff88040c42101c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  304.072144] xhci_hcd 0000:11:00.0: Slot Context:
> [  304.072146] xhci_hcd 0000:11:00.0: @ffff88040c421020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  304.072148] xhci_hcd 0000:11:00.0: @ffff88040c421024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  304.072149] xhci_hcd 0000:11:00.0: @ffff88040c421028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  304.072151] xhci_hcd 0000:11:00.0: @ffff88040c42102c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  304.072153] xhci_hcd 0000:11:00.0: @ffff88040c421030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  304.072154] xhci_hcd 0000:11:00.0: @ffff88040c421034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  304.072156] xhci_hcd 0000:11:00.0: @ffff88040c421038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  304.072157] xhci_hcd 0000:11:00.0: @ffff88040c42103c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  304.072159] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  304.072160] xhci_hcd 0000:11:00.0: @ffff88040c421040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  304.072162] xhci_hcd 0000:11:00.0: @ffff88040c421044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  304.072164] xhci_hcd 0000:11:00.0: @ffff88040c421048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  304.072165] xhci_hcd 0000:11:00.0: @ffff88040c421050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  304.072167] xhci_hcd 0000:11:00.0: @ffff88040c421054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  304.072168] xhci_hcd 0000:11:00.0: @ffff88040c421058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  304.072170] xhci_hcd 0000:11:00.0: @ffff88040c42105c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  304.072172] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  304.072173] xhci_hcd 0000:11:00.0: @ffff88040c421060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  304.072174] xhci_hcd 0000:11:00.0: @ffff88040c421064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  304.072176] xhci_hcd 0000:11:00.0: @ffff88040c421068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  304.072178] xhci_hcd 0000:11:00.0: @ffff88040c421070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  304.072179] xhci_hcd 0000:11:00.0: @ffff88040c421074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  304.072181] xhci_hcd 0000:11:00.0: @ffff88040c421078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  304.072182] xhci_hcd 0000:11:00.0: @ffff88040c42107c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  304.072184] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  304.072185] xhci_hcd 0000:11:00.0: @ffff88040c421080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  304.072187] xhci_hcd 0000:11:00.0: @ffff88040c421084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  304.072188] xhci_hcd 0000:11:00.0: @ffff88040c421088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  304.072190] xhci_hcd 0000:11:00.0: @ffff88040c421090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  304.072191] xhci_hcd 0000:11:00.0: @ffff88040c421094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  304.072193] xhci_hcd 0000:11:00.0: @ffff88040c421098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  304.072195] xhci_hcd 0000:11:00.0: @ffff88040c42109c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  304.072197] xhci_hcd 0000:11:00.0: // Ding dong!
> [  304.072895] xhci_hcd 0000:11:00.0: Successful Address Device command
> [  304.072916] xhci_hcd 0000:11:00.0: Op regs DCBAA ptr = 0x000000fffff000
> [  304.072924] xhci_hcd 0000:11:00.0: Slot ID 1 dcbaa entry @ffff88040c427008 = 0x000000ffffc000
> [  304.072931] xhci_hcd 0000:11:00.0: Output Context DMA address = 0xffffc000
> [  304.072937] xhci_hcd 0000:11:00.0: Slot ID 1 Input Context:
> [  304.072944] xhci_hcd 0000:11:00.0: @ffff88040c421000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  304.072952] xhci_hcd 0000:11:00.0: @ffff88040c421004 (virt) @ffffb004 (dma) 0x000003 - add flags
> [  304.072959] xhci_hcd 0000:11:00.0: @ffff88040c421008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  304.072967] xhci_hcd 0000:11:00.0: @ffff88040c42100c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  304.072974] xhci_hcd 0000:11:00.0: @ffff88040c421010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  304.072981] xhci_hcd 0000:11:00.0: @ffff88040c421014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  304.072988] xhci_hcd 0000:11:00.0: @ffff88040c421018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  304.072995] xhci_hcd 0000:11:00.0: @ffff88040c42101c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  304.073001] xhci_hcd 0000:11:00.0: Slot Context:
> [  304.073007] xhci_hcd 0000:11:00.0: @ffff88040c421020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  304.073022] xhci_hcd 0000:11:00.0: @ffff88040c421024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  304.073024] xhci_hcd 0000:11:00.0: @ffff88040c421028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  304.073025] xhci_hcd 0000:11:00.0: @ffff88040c42102c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  304.073027] xhci_hcd 0000:11:00.0: @ffff88040c421030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  304.073028] xhci_hcd 0000:11:00.0: @ffff88040c421034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  304.073030] xhci_hcd 0000:11:00.0: @ffff88040c421038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  304.073032] xhci_hcd 0000:11:00.0: @ffff88040c42103c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  304.073033] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  304.073035] xhci_hcd 0000:11:00.0: @ffff88040c421040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  304.073036] xhci_hcd 0000:11:00.0: @ffff88040c421044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  304.073038] xhci_hcd 0000:11:00.0: @ffff88040c421048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  304.073039] xhci_hcd 0000:11:00.0: @ffff88040c421050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  304.073041] xhci_hcd 0000:11:00.0: @ffff88040c421054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  304.073043] xhci_hcd 0000:11:00.0: @ffff88040c421058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  304.073044] xhci_hcd 0000:11:00.0: @ffff88040c42105c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  304.073046] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  304.073047] xhci_hcd 0000:11:00.0: @ffff88040c421060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  304.073048] xhci_hcd 0000:11:00.0: @ffff88040c421064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  304.073050] xhci_hcd 0000:11:00.0: @ffff88040c421068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  304.073052] xhci_hcd 0000:11:00.0: @ffff88040c421070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  304.073053] xhci_hcd 0000:11:00.0: @ffff88040c421074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  304.073055] xhci_hcd 0000:11:00.0: @ffff88040c421078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  304.073057] xhci_hcd 0000:11:00.0: @ffff88040c42107c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  304.073058] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  304.073059] xhci_hcd 0000:11:00.0: @ffff88040c421080 (virt) @ffffb080 (dma) 0x000000 - ep_info
> [  304.073061] xhci_hcd 0000:11:00.0: @ffff88040c421084 (virt) @ffffb084 (dma) 0x000000 - ep_info2
> [  304.073062] xhci_hcd 0000:11:00.0: @ffff88040c421088 (virt) @ffffb088 (dma) 0x000000 - deq
> [  304.073064] xhci_hcd 0000:11:00.0: @ffff88040c421090 (virt) @ffffb090 (dma) 0x000000 - tx_info
> [  304.073066] xhci_hcd 0000:11:00.0: @ffff88040c421094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  304.073067] xhci_hcd 0000:11:00.0: @ffff88040c421098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  304.073069] xhci_hcd 0000:11:00.0: @ffff88040c42109c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  304.073070] xhci_hcd 0000:11:00.0: Slot ID 1 Output Context:
> [  304.073071] xhci_hcd 0000:11:00.0: Slot Context:
> [  304.073073] xhci_hcd 0000:11:00.0: @ffff88040c72e000 (virt) @ffffc000 (dma) 0x8200000 - dev_info
> [  304.073074] xhci_hcd 0000:11:00.0: @ffff88040c72e004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  304.073076] xhci_hcd 0000:11:00.0: @ffff88040c72e008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  304.073078] xhci_hcd 0000:11:00.0: @ffff88040c72e00c (virt) @ffffc00c (dma) 0x10000001 - dev_state
> [  304.073079] xhci_hcd 0000:11:00.0: @ffff88040c72e010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  304.073081] xhci_hcd 0000:11:00.0: @ffff88040c72e014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  304.073083] xhci_hcd 0000:11:00.0: @ffff88040c72e018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  304.073084] xhci_hcd 0000:11:00.0: @ffff88040c72e01c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  304.073086] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  304.073087] xhci_hcd 0000:11:00.0: @ffff88040c72e020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  304.073088] xhci_hcd 0000:11:00.0: @ffff88040c72e024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  304.073090] xhci_hcd 0000:11:00.0: @ffff88040c72e028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  304.073092] xhci_hcd 0000:11:00.0: @ffff88040c72e030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  304.073093] xhci_hcd 0000:11:00.0: @ffff88040c72e034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  304.073095] xhci_hcd 0000:11:00.0: @ffff88040c72e038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  304.073096] xhci_hcd 0000:11:00.0: @ffff88040c72e03c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  304.073098] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  304.073099] xhci_hcd 0000:11:00.0: @ffff88040c72e040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  304.073101] xhci_hcd 0000:11:00.0: @ffff88040c72e044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  304.073102] xhci_hcd 0000:11:00.0: @ffff88040c72e048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  304.073104] xhci_hcd 0000:11:00.0: @ffff88040c72e050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  304.073105] xhci_hcd 0000:11:00.0: @ffff88040c72e054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  304.073107] xhci_hcd 0000:11:00.0: @ffff88040c72e058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  304.073109] xhci_hcd 0000:11:00.0: @ffff88040c72e05c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  304.073110] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  304.073111] xhci_hcd 0000:11:00.0: @ffff88040c72e060 (virt) @ffffc060 (dma) 0x000000 - ep_info
> [  304.073113] xhci_hcd 0000:11:00.0: @ffff88040c72e064 (virt) @ffffc064 (dma) 0x000000 - ep_info2
> [  304.073114] xhci_hcd 0000:11:00.0: @ffff88040c72e068 (virt) @ffffc068 (dma) 0x000000 - deq
> [  304.073116] xhci_hcd 0000:11:00.0: @ffff88040c72e070 (virt) @ffffc070 (dma) 0x000000 - tx_info
> [  304.073118] xhci_hcd 0000:11:00.0: @ffff88040c72e074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  304.073119] xhci_hcd 0000:11:00.0: @ffff88040c72e078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  304.073121] xhci_hcd 0000:11:00.0: @ffff88040c72e07c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  304.073122] xhci_hcd 0000:11:00.0: Internal device address = 2
> [  304.110376] usb 3-2: skipped 1 descriptor after interface
> [  304.112230] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  304.113311] usb 3-2: default language 0x0409
> [  304.121279] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  304.125284] xhci_hcd 0000:11:00.0: Waiting for status stage event
> [  304.126324] usb 3-2: udev 2, busnum 3, minor = 257
> [  304.126335] usb 3-2: New USB device found, idVendor=0458, idProduct=0036
> [  304.126416] usb 3-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> [  304.126442] usb 3-2: Product: NetScroll + Mini Traveler
> [  304.126463] usb 3-2: Manufacturer: Genius
> [  304.126604] usb 3-2: usb_probe_device
> [  304.126607] usb 3-2: configuration #1 chosen from 1 choice
> [  304.126613] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
> [  304.126645] xhci_hcd 0000:11:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18200000
> [  304.126648] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff880409d68000
> [  304.126649] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  304.126651] xhci_hcd 0000:11:00.0: @ffff88040c421000 (virt) @ffffb000 (dma) 0x000000 - drop flags
> [  304.126653] xhci_hcd 0000:11:00.0: @ffff88040c421004 (virt) @ffffb004 (dma) 0x000009 - add flags
> [  304.126655] xhci_hcd 0000:11:00.0: @ffff88040c421008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  304.126657] xhci_hcd 0000:11:00.0: @ffff88040c42100c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  304.126659] xhci_hcd 0000:11:00.0: @ffff88040c421010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  304.126660] xhci_hcd 0000:11:00.0: @ffff88040c421014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  304.126662] xhci_hcd 0000:11:00.0: @ffff88040c421018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  304.126664] xhci_hcd 0000:11:00.0: @ffff88040c42101c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  304.126665] xhci_hcd 0000:11:00.0: Slot Context:
> [  304.126667] xhci_hcd 0000:11:00.0: @ffff88040c421020 (virt) @ffffb020 (dma) 0x18200000 - dev_info
> [  304.126668] xhci_hcd 0000:11:00.0: @ffff88040c421024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  304.126670] xhci_hcd 0000:11:00.0: @ffff88040c421028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  304.126672] xhci_hcd 0000:11:00.0: @ffff88040c42102c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  304.126674] xhci_hcd 0000:11:00.0: @ffff88040c421030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  304.126675] xhci_hcd 0000:11:00.0: @ffff88040c421034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  304.126677] xhci_hcd 0000:11:00.0: @ffff88040c421038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  304.126679] xhci_hcd 0000:11:00.0: @ffff88040c42103c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  304.126680] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  304.126682] xhci_hcd 0000:11:00.0: @ffff88040c421040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  304.126684] xhci_hcd 0000:11:00.0: @ffff88040c421044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  304.126685] xhci_hcd 0000:11:00.0: @ffff88040c421048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  304.126687] xhci_hcd 0000:11:00.0: @ffff88040c421050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  304.126689] xhci_hcd 0000:11:00.0: @ffff88040c421054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  304.126690] xhci_hcd 0000:11:00.0: @ffff88040c421058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  304.126692] xhci_hcd 0000:11:00.0: @ffff88040c42105c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  304.126694] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  304.126695] xhci_hcd 0000:11:00.0: @ffff88040c421060 (virt) @ffffb060 (dma) 0x000000 - ep_info
> [  304.126697] xhci_hcd 0000:11:00.0: @ffff88040c421064 (virt) @ffffb064 (dma) 0x000000 - ep_info2
> [  304.126699] xhci_hcd 0000:11:00.0: @ffff88040c421068 (virt) @ffffb068 (dma) 0x000000 - deq
> [  304.126700] xhci_hcd 0000:11:00.0: @ffff88040c421070 (virt) @ffffb070 (dma) 0x000000 - tx_info
> [  304.126702] xhci_hcd 0000:11:00.0: @ffff88040c421074 (virt) @ffffb074 (dma) 0x000000 - rsvd[0]
> [  304.126704] xhci_hcd 0000:11:00.0: @ffff88040c421078 (virt) @ffffb078 (dma) 0x000000 - rsvd[1]
> [  304.126705] xhci_hcd 0000:11:00.0: @ffff88040c42107c (virt) @ffffb07c (dma) 0x000000 - rsvd[2]
> [  304.126707] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  304.126708] xhci_hcd 0000:11:00.0: @ffff88040c421080 (virt) @ffffb080 (dma) 0x060000 - ep_info
> [  304.126710] xhci_hcd 0000:11:00.0: @ffff88040c421084 (virt) @ffffb084 (dma) 0x04003e - ep_info2
> [  304.126712] xhci_hcd 0000:11:00.0: @ffff88040c421088 (virt) @ffffb088 (dma) 0xffffa401 - deq
> [  304.126713] xhci_hcd 0000:11:00.0: @ffff88040c421090 (virt) @ffffb090 (dma) 0x040004 - tx_info
> [  304.126715] xhci_hcd 0000:11:00.0: @ffff88040c421094 (virt) @ffffb094 (dma) 0x000000 - rsvd[0]
> [  304.126717] xhci_hcd 0000:11:00.0: @ffff88040c421098 (virt) @ffffb098 (dma) 0x000000 - rsvd[1]
> [  304.126719] xhci_hcd 0000:11:00.0: @ffff88040c42109c (virt) @ffffb09c (dma) 0x000000 - rsvd[2]
> [  304.126721] xhci_hcd 0000:11:00.0: // Ding dong!
> [  304.126978] xhci_hcd 0000:11:00.0: Completed config ep cmd
> [  304.127010] usb 3-2: Successful Endpoint Configure command
> [  304.127016] xhci_hcd 0000:11:00.0: Output context after successful config ep cmd:
> [  304.127022] xhci_hcd 0000:11:00.0: Slot Context:
> [  304.127030] xhci_hcd 0000:11:00.0: @ffff88040c72e000 (virt) @ffffc000 (dma) 0x18200000 - dev_info
> [  304.127038] xhci_hcd 0000:11:00.0: @ffff88040c72e004 (virt) @ffffc004 (dma) 0x040000 - dev_info2
> [  304.127045] xhci_hcd 0000:11:00.0: @ffff88040c72e008 (virt) @ffffc008 (dma) 0x000000 - tt_info
> [  304.127052] xhci_hcd 0000:11:00.0: @ffff88040c72e00c (virt) @ffffc00c (dma) 0x18000001 - dev_state
> [  304.127060] xhci_hcd 0000:11:00.0: @ffff88040c72e010 (virt) @ffffc010 (dma) 0x000000 - rsvd[0]
> [  304.127068] xhci_hcd 0000:11:00.0: @ffff88040c72e014 (virt) @ffffc014 (dma) 0x000000 - rsvd[1]
> [  304.127075] xhci_hcd 0000:11:00.0: @ffff88040c72e018 (virt) @ffffc018 (dma) 0x000000 - rsvd[2]
> [  304.127082] xhci_hcd 0000:11:00.0: @ffff88040c72e01c (virt) @ffffc01c (dma) 0x000000 - rsvd[3]
> [  304.127089] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  304.127095] xhci_hcd 0000:11:00.0: @ffff88040c72e020 (virt) @ffffc020 (dma) 0x000001 - ep_info
> [  304.127102] xhci_hcd 0000:11:00.0: @ffff88040c72e024 (virt) @ffffc024 (dma) 0x080026 - ep_info2
> [  304.127109] xhci_hcd 0000:11:00.0: @ffff88040c72e028 (virt) @ffffc028 (dma) 0xffffe801 - deq
> [  304.127116] xhci_hcd 0000:11:00.0: @ffff88040c72e030 (virt) @ffffc030 (dma) 0x000000 - tx_info
> [  304.127124] xhci_hcd 0000:11:00.0: @ffff88040c72e034 (virt) @ffffc034 (dma) 0x000000 - rsvd[0]
> [  304.127138] xhci_hcd 0000:11:00.0: @ffff88040c72e038 (virt) @ffffc038 (dma) 0x000000 - rsvd[1]
> [  304.127139] xhci_hcd 0000:11:00.0: @ffff88040c72e03c (virt) @ffffc03c (dma) 0x000000 - rsvd[2]
> [  304.127141] xhci_hcd 0000:11:00.0: Endpoint 01 Context:
> [  304.127142] xhci_hcd 0000:11:00.0: @ffff88040c72e040 (virt) @ffffc040 (dma) 0x000000 - ep_info
> [  304.127144] xhci_hcd 0000:11:00.0: @ffff88040c72e044 (virt) @ffffc044 (dma) 0x000000 - ep_info2
> [  304.127145] xhci_hcd 0000:11:00.0: @ffff88040c72e048 (virt) @ffffc048 (dma) 0x000000 - deq
> [  304.127147] xhci_hcd 0000:11:00.0: @ffff88040c72e050 (virt) @ffffc050 (dma) 0x000000 - tx_info
> [  304.127149] xhci_hcd 0000:11:00.0: @ffff88040c72e054 (virt) @ffffc054 (dma) 0x000000 - rsvd[0]
> [  304.127150] xhci_hcd 0000:11:00.0: @ffff88040c72e058 (virt) @ffffc058 (dma) 0x000000 - rsvd[1]
> [  304.127152] xhci_hcd 0000:11:00.0: @ffff88040c72e05c (virt) @ffffc05c (dma) 0x000000 - rsvd[2]
> [  304.127153] xhci_hcd 0000:11:00.0: Endpoint 02 Context:
> [  304.127155] xhci_hcd 0000:11:00.0: @ffff88040c72e060 (virt) @ffffc060 (dma) 0x060001 - ep_info
> [  304.127156] xhci_hcd 0000:11:00.0: @ffff88040c72e064 (virt) @ffffc064 (dma) 0x04003e - ep_info2
> [  304.127158] xhci_hcd 0000:11:00.0: @ffff88040c72e068 (virt) @ffffc068 (dma) 0xffffa401 - deq
> [  304.127159] xhci_hcd 0000:11:00.0: @ffff88040c72e070 (virt) @ffffc070 (dma) 0x040004 - tx_info
> [  304.127161] xhci_hcd 0000:11:00.0: @ffff88040c72e074 (virt) @ffffc074 (dma) 0x000000 - rsvd[0]
> [  304.127163] xhci_hcd 0000:11:00.0: @ffff88040c72e078 (virt) @ffffc078 (dma) 0x000000 - rsvd[1]
> [  304.127164] xhci_hcd 0000:11:00.0: @ffff88040c72e07c (virt) @ffffc07c (dma) 0x000000 - rsvd[2]
> [  304.129337] xhci_hcd 0000:11:00.0: Endpoint 0x81 not halted, refusing to reset.
> [  304.129357] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
> [  304.129437] usbserial_generic 3-2:1.0: usb_probe_interface
> [  304.129440] usbserial_generic 3-2:1.0: usb_probe_interface - got id
> [  304.129451] usbhid 3-2:1.0: usb_probe_interface
> [  304.129453] usbhid 3-2:1.0: usb_probe_interface - got id
> [  304.140511] input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1c.7/0000:11:00.0/usb3/3-2/3-2:1.0/input/input15
> [  304.140686] generic-usb 0003:0458:0036.0002: input,hidraw0: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:11:00.0-2/input0
> [  305.849394] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> [  305.849429] xhci_hcd 0000:11:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> [  305.849443] hub 4-0:1.0: hub_suspend
> [  305.849464] usb usb4: bus auto-suspend, wakeup 1
> [  318.789612] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  318.789621] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  318.789638] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> [  318.789693] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  318.789855] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
> [  318.789857] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> [  318.789908] xhci_hcd 0000:11:00.0: remove, state 4
> [  318.789929] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  318.789932] usb usb4: USB disconnect, device number 1
> [  318.789951] usb usb4: unregistering device
> [  318.789953] usb usb4: unregistering interface 4-0:1.0
> [  318.790008] usb usb4: usb_disable_device nuking all URBs
> [  318.790010] xHCI xhci_drop_endpoint called for root hub
> [  318.790011] xHCI xhci_check_bandwidth called for root hub
> [  318.790092] xhci_hcd 0000:11:00.0: // Halt the HC
> [  318.790098] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  318.790125] xhci_hcd 0000:11:00.0: USB bus 4 deregistered
> [  318.790148] xhci_hcd 0000:11:00.0: remove, state 1
> [  318.790170] xhci_hcd 0000:11:00.0: roothub graceful disconnect
> [  318.790172] usb usb3: USB disconnect, device number 1
> [  318.790192] usb 3-2: USB disconnect, device number 2
> [  318.790216] usb 3-2: unregistering device
> [  318.790218] usb 3-2: unregistering interface 3-2:1.0
> [  318.790240] xhci_hcd 0000:11:00.0: HW died, freeing TD.
> [  318.790243] xhci_hcd 0000:11:00.0: shutdown urb ffff88040b8cd540 ep1in-intr
> [  318.805939] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
> [  318.805942] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
> [  318.805946] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> [  318.805981] pciehp 0000:00:1c.7:pcie04: Surprise Removal
> [  318.805988] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
> [  318.810280] usb 3-2: usb_disable_device nuking all URBs
> [  318.810285] xhci_hcd 0000:11:00.0: xhci_drop_endpoint called for udev ffff880409d68000
> [  318.810288] xhci_hcd 0000:11:00.0: drop ep 0x81, slot id 1, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8200000
> [  318.810291] xhci_hcd 0000:11:00.0: xhci_check_bandwidth called for udev ffff880409d68000
> [  318.810293] xhci_hcd 0000:11:00.0: New Input Control Context:
> [  318.810296] xhci_hcd 0000:11:00.0: @ffff88040c421000 (virt) @ffffb000 (dma) 0x000008 - drop flags
> [  318.810304] xhci_hcd 0000:11:00.0: @ffff88040c421004 (virt) @ffffb004 (dma) 0x000001 - add flags
> [  318.810307] xhci_hcd 0000:11:00.0: @ffff88040c421008 (virt) @ffffb008 (dma) 0x000000 - rsvd2[0]
> [  318.810311] xhci_hcd 0000:11:00.0: @ffff88040c42100c (virt) @ffffb00c (dma) 0x000000 - rsvd2[1]
> [  318.810313] xhci_hcd 0000:11:00.0: @ffff88040c421010 (virt) @ffffb010 (dma) 0x000000 - rsvd2[2]
> [  318.810316] xhci_hcd 0000:11:00.0: @ffff88040c421014 (virt) @ffffb014 (dma) 0x000000 - rsvd2[3]
> [  318.810319] xhci_hcd 0000:11:00.0: @ffff88040c421018 (virt) @ffffb018 (dma) 0x000000 - rsvd2[4]
> [  318.810321] xhci_hcd 0000:11:00.0: @ffff88040c42101c (virt) @ffffb01c (dma) 0x000000 - rsvd2[5]
> [  318.810324] xhci_hcd 0000:11:00.0: Slot Context:
> [  318.810326] xhci_hcd 0000:11:00.0: @ffff88040c421020 (virt) @ffffb020 (dma) 0x8200000 - dev_info
> [  318.810328] xhci_hcd 0000:11:00.0: @ffff88040c421024 (virt) @ffffb024 (dma) 0x040000 - dev_info2
> [  318.810331] xhci_hcd 0000:11:00.0: @ffff88040c421028 (virt) @ffffb028 (dma) 0x000000 - tt_info
> [  318.810333] xhci_hcd 0000:11:00.0: @ffff88040c42102c (virt) @ffffb02c (dma) 0x000000 - dev_state
> [  318.810336] xhci_hcd 0000:11:00.0: @ffff88040c421030 (virt) @ffffb030 (dma) 0x000000 - rsvd[0]
> [  318.810338] xhci_hcd 0000:11:00.0: @ffff88040c421034 (virt) @ffffb034 (dma) 0x000000 - rsvd[1]
> [  318.810341] xhci_hcd 0000:11:00.0: @ffff88040c421038 (virt) @ffffb038 (dma) 0x000000 - rsvd[2]
> [  318.810344] xhci_hcd 0000:11:00.0: @ffff88040c42103c (virt) @ffffb03c (dma) 0x000000 - rsvd[3]
> [  318.810346] xhci_hcd 0000:11:00.0: Endpoint 00 Context:
> [  318.810348] xhci_hcd 0000:11:00.0: @ffff88040c421040 (virt) @ffffb040 (dma) 0x000000 - ep_info
> [  318.810350] xhci_hcd 0000:11:00.0: @ffff88040c421044 (virt) @ffffb044 (dma) 0x080026 - ep_info2
> [  318.810353] xhci_hcd 0000:11:00.0: @ffff88040c421048 (virt) @ffffb048 (dma) 0xffffe801 - deq
> [  318.810355] xhci_hcd 0000:11:00.0: @ffff88040c421050 (virt) @ffffb050 (dma) 0x000000 - tx_info
> [  318.810358] xhci_hcd 0000:11:00.0: @ffff88040c421054 (virt) @ffffb054 (dma) 0x000000 - rsvd[0]
> [  318.810361] xhci_hcd 0000:11:00.0: @ffff88040c421058 (virt) @ffffb058 (dma) 0x000000 - rsvd[1]
> [  318.810363] xhci_hcd 0000:11:00.0: @ffff88040c42105c (virt) @ffffb05c (dma) 0x000000 - rsvd[2]
> [  318.810367] xhci_hcd 0000:11:00.0: // Ding dong!
> [  318.909918] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> [  318.909936] pciehp 0000:00:1c.7:pcie04: Device 0000:11:00.0 already exists at 0000:11:00, cannot hot-add
> [  318.910030] pciehp 0000:00:1c.7:pcie04: Cannot add device at 0000:11:00
> [  363.892871] xhci_hcd 0000:11:00.0: Poll event ring: 4294973728
> [  363.892885] xhci_hcd 0000:11:00.0: op reg status = 0xffffffff
> [  363.892891] xhci_hcd 0000:11:00.0: HW died, polling stopped.
> [  368.735694] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> [  368.735967] usb usb3: unregistering device
> [  368.735969] usb usb3: unregistering interface 3-0:1.0
> [  368.735993] xhci_hcd 0000:11:00.0: shutdown urb ffff88040b84b9c0 ep1in-intr
> [  368.736004] usb usb3: usb_disable_device nuking all URBs
> [  368.736006] xHCI xhci_drop_endpoint called for root hub
> [  368.736007] xHCI xhci_check_bandwidth called for root hub
> [  368.736067] xhci_hcd 0000:11:00.0: // Halt the HC
> [  368.736080] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
> [  368.736120] xhci_hcd 0000:11:00.0: // Reset the HC
> [  368.736252] xhci_hcd 0000:11:00.0: // Disabling event ring interrupts
> [  368.736265] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set[0]
> [  368.736274] xhci_hcd 0000:11:00.0:   ffffc90006684620: ir_set.pending = 0xffffffff
> [  368.736281] xhci_hcd 0000:11:00.0:   ffffc90006684624: ir_set.control = 0xffffffff
> [  368.736288] xhci_hcd 0000:11:00.0:   ffffc90006684628: ir_set.erst_size = 0xffffffff
> [  368.736295] xhci_hcd 0000:11:00.0:   WARN: ffffc9000668462c: ir_set.rsvd = 0xffffffff
> [  368.736305] xhci_hcd 0000:11:00.0:   ffffc90006684630: ir_set.erst_base = @ffffffffffffffff
> [  368.736315] xhci_hcd 0000:11:00.0:   ffffc90006684638: ir_set.erst_dequeue = @ffffffffffffffff
> [  368.736317] xhci_hcd 0000:11:00.0: cleaning up memory
> [  368.736322] xhci_hcd 0000:11:00.0: Freed ERST
> [  368.736324] xhci_hcd 0000:11:00.0: Freed event ring
> [  368.736326] xhci_hcd 0000:11:00.0: Freed command ring
> [  368.736331] xhci_hcd 0000:11:00.0: Freed segment pool
> [  368.736334] xhci_hcd 0000:11:00.0: Freed device context pool
> [  368.736336] xhci_hcd 0000:11:00.0: Freed small stream array pool
> [  368.736338] xhci_hcd 0000:11:00.0: Freed medium stream array pool
> [  368.736345] xhci_hcd 0000:11:00.0: xhci_stop completed - status = ffffffff
> [  368.736348] xhci_hcd 0000:11:00.0: USB bus 3 deregistered

