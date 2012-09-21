Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2IUOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:54:17 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:34129 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755780Ab2IUOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:54:13 -0400
Message-ID: <505C7F91.4040100@akamai.com>
Date: Fri, 21 Sep 2012 09:54:09 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <20120912154943.GB12103@aftab.osrc.amd.com> <5050B708.5020308@akamai.com> <20120912164843.GC12103@aftab.osrc.amd.com> <5050BF1F.1080503@akamai.com> <20120912170629.GD12103@aftab.osrc.amd.com> <20120912172351.GE12103@aftab.osrc.amd.com> <50532940.10201@akamai.com> <50534184.1050208@akamai.com> <20120921123645.GD26869@aftab.osrc.amd.com> <505C6558.1040405@akamai.com> <20120921140133.GA27890@aftab.osrc.amd.com>
In-Reply-To: <20120921140133.GA27890@aftab.osrc.amd.com>
Content-Type: multipart/mixed;
 boundary="------------000709090903080006070104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709090903080006070104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/21/2012 09:01 AM, Borislav Petkov wrote:
> Ah ok, my bad, I have 4 more patches ontop which should deal with the
> channel doubling, please repull the same branch which I've just updated.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git edac-queue
>
> and retest.
>
> And you're right about WIDTH_128 - it actually denotes the channel width
> and the code wrongly uses it to say that there are two channels on K8.
>
> However, this has been the case since the driver went upstream and I
> need to think a bit harder when correcting that so that I don't upset
> something else in it.
>
> Also, it would be very helpful if you send me full dmesg after you've
> applied the latest patches so that I can have another reference when
> changing the WIDTH_128 thing.
>
> Thanks for your help.

OK so progress, but still not there.

So this is correct now:
root@x.x.x.x:/sys/devices/system/edac/mc/mc0# grep . csrow*/size_mb
csrow0/size_mb:1024
csrow1/size_mb:1024
csrow2/size_mb:1024
csrow3/size_mb:1024

But this is not:
root@x.x.x.x:/sys/devices/system/edac/mc/mc0# grep . size_mb
8192

Attached patch seems to resolve reading size_mb from the mc in sysfs. 
I'm also attaching the new dmesg.

Josh



--------------000709090903080006070104
Content-Type: text/x-patch;
 name="0001-EDAC-Fix-mc-size-reported-in-sysfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-EDAC-Fix-mc-size-reported-in-sysfs.patch"

>From 2ae58bdca43cd52e0d24685b21baa5692cbd4ef9 Mon Sep 17 00:00:00 2001
From: Josh Hunt <johunt@akamai.com>
Date: Fri, 21 Sep 2012 07:45:49 -0700
Subject: [PATCH] EDAC: Fix mc size reported in sysfs

This is the complement to commit: EDAC: Fix csrow size reported in sysfs.
This fixes the memory controller size reporting on csrow-based memory
controllers. The csrow size is already combined for both channels. Without
this patch memory size is reported doubled.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/edac/edac_mc_sysfs.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index bd46610..a242dae 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -781,10 +781,14 @@ static ssize_t mci_size_mb_show(struct device *dev,
 	for (csrow_idx = 0; csrow_idx < mci->nr_csrows; csrow_idx++) {
 		struct csrow_info *csrow = mci->csrows[csrow_idx];
 
-		for (j = 0; j < csrow->nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j]->dimm;
-
-			total_pages += dimm->nr_pages;
+		if (csrow->mci->csbased) {
+			total_pages += csrow->nr_pages;
+		} else {
+			for (j = 0; j < csrow->nr_channels; j++) {
+				struct dimm_info *dimm = csrow->channels[j]->dimm;
+
+				total_pages += dimm->nr_pages;
+			}
 		}
 	}
 
-- 
1.7.0.4


--------------000709090903080006070104
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.log.new"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log.new"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc5+ (johunt@kernelsuite-780) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #2 SMP Fri Sep 21 07:07:35 PDT 2012
[    0.000000] Command line: root=UUID=dac98d66-8aaa-44c4-bcc8-4804e0bb31f1 ro oops=panic panic=30 INIT_VERBOSE=yes init=/sbin/init processor.max_cstate=1 reboot_type=1 nmi_watchdog=2,120 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000edfeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000edff0000-0x00000000edffdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000edffe000-0x00000000edffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec02fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000111ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro H8SSL-I2/H8SSL-I2, BIOS 080011  09/05/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x112000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF00000000 write-back
[    0.000000]   1 base 0100000000 mask FFF0000000 write-back
[    0.000000]   2 base 0110000000 mask FFFE000000 write-back
[    0.000000]   3 base 00EE000000 mask FFFE000000 uncachable
[    0.000000]   4 base 00F0000000 mask FFF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000112000000 aka 4384M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xee000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xedff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xedfeffff]
[    0.000000]  [mem 0x00000000-0xeddfffff] page 2M
[    0.000000]  [mem 0xede00000-0xedfeffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xedfeffff @ [mem 0x1f88b000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x111ffffff]
[    0.000000]  [mem 0x100000000-0x111ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x111ffffff @ [mem 0xedfea000-0xedfeffff]
[    0.000000] RAMDISK: [mem 0x37510000-0x37feffff]
[    0.000000] ACPI: RSDP 00000000000f9e40 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000edff0000 00030 (v01 A M I  OEMRSDT  09000705 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000edff0200 00084 (v02 A M I  OEMFACP  09000705 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000edff0410 030C5 (v01  1SSL2 1SSL2005 00000005 INTL 02002026)
[    0.000000] ACPI: FACS 00000000edffe000 00040
[    0.000000] ACPI: APIC 00000000edff0390 00076 (v01 A M I  OEMAPIC  09000705 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000edffe040 00056 (v01 A M I  AMI_OEM  09000705 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000111ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x111ffffff]
[    0.000000]   NODE_DATA [mem 0x111ffc000-0x111ffffff]
[    0.000000]  [ffffea0000000000-ffffea0003dfffff] PMD -> [ffff88010d400000-ffff880110ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x111ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xedfeffff]
[    0.000000]   node   0: [mem 0x100000000-0x111ffffff]
[    0.000000] On node 0 totalpages: 1048447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 8 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 956456 pages, LIFO batch:31
[    0.000000]   Normal zone: 1008 pages used for memmap
[    0.000000]   Normal zone: 72720 pages, LIFO batch:15
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] e820: [mem 0xee000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880111c00000 s78848 r8192 d23552 u1048576
[    0.000000] pcpu-alloc: s78848 r8192 d23552 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1033095
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=dac98d66-8aaa-44c4-bcc8-4804e0bb31f1 ro oops=panic panic=30 INIT_VERBOSE=yes init=/sbin/init processor.max_cstate=1 reboot_type=1 nmi_watchdog=2,120 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ e4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ e4000000
[    0.000000] Memory: 3979300k/4489216k available (5193k kernel code, 295428k absent, 214488k reserved, 3020k data, 896k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2393.842 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.002138] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.68 BogoMIPS (lpj=2393842)
[    0.002409] pid_max: default: 32768 minimum: 301
[    0.002573] Security Framework initialized
[    0.002713] AppArmor: AppArmor disabled by boot time parameter
[    0.003292] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005891] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.007056] Mount-cache hash table entries: 256
[    0.007407] Initializing cgroup subsys cpuacct
[    0.007542] Initializing cgroup subsys devices
[    0.007676] Initializing cgroup subsys freezer
[    0.007810] Initializing cgroup subsys net_cls
[    0.007943] Initializing cgroup subsys blkio
[    0.008002] Initializing cgroup subsys perf_event
[    0.008161] tseg: 0000000000
[    0.008175] CPU: Physical Processor ID: 0
[    0.008306] CPU: Processor Core ID: 0
[    0.008439] mce: CPU supports 5 MCE banks
[    0.008575] LVT offset 0 assigned for vector 0xf9
[    0.008715] process: using AMD E400 aware idle routine
[    0.008850] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.008850] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.008850] tlb_flushall_shift: 4
[    0.009093] Freeing SMP alternatives: 24k freed
[    0.010235] ACPI: Core revision 20120711
[    0.013578] ftrace: allocating 19853 entries in 78 pages
[    0.020909] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.031130] smpboot: CPU0: Dual-Core AMD Opteron(tm) Processor 1216 HE stepping 03
[    0.031995] Performance Events: AMD PMU driver.
[    0.031995] ... version:                0
[    0.031995] ... bit width:              48
[    0.031995] ... generic registers:      4
[    0.031995] ... value mask:             0000ffffffffffff
[    0.031995] ... max period:             00007fffffffffff
[    0.031995] ... fixed-purpose events:   0
[    0.031995] ... event mask:             000000000000000f
[    0.032445] MCE: In-kernel MCE decoding enabled.
[    0.032635] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.033093] smpboot: Booting Node   0, Processors  #1 OK
[    0.104101] Brought up 2 CPUs
[    0.104230] smpboot: Total of 2 processors activated (9574.71 BogoMIPS)
[    0.106169] NET: Registered protocol family 16
[    0.106735] node 0 link 0: io port [1000, ffffff]
[    0.106738] TOM: 00000000ee000000 aka 3808M
[    0.106872] node 0 link 0: mmio [a0000, bffff]
[    0.106875] node 0 link 0: mmio [ee000000, ffe0ffff]
[    0.106878] TOM2: 0000000112000000 aka 4384M
[    0.106988] bus: [bus 00-ff] on node 0 link 0
[    0.106990] bus: 00 [io  0x0000-0xffff]
[    0.106991] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.106993] bus: 00 [mem 0xee000000-0xffffffff]
[    0.106994] bus: 00 [mem 0x112000000-0xfcffffffff]
[    0.107043] ACPI: bus type pci registered
[    0.107342] dca service started, version 1.12.1
[    0.107511] PCI: Using configuration type 1 for base access
[    0.113897] bio: create slab <bio-0> at 0
[    0.114219] ACPI: Added _OSI(Module Device)
[    0.114357] ACPI: Added _OSI(Processor Device)
[    0.114491] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.114623] ACPI: Added _OSI(Processor Aggregator Device)
[    0.115687] ACPI: EC: Look up EC in DSDT
[    0.116841] ACPI: Executed 1 blocks of module-level executable AML code
[    0.118597] ACPI: Interpreter enabled
[    0.118728] ACPI: (supports S0 S5)
[    0.118962] ACPI: Using IOAPIC for interrupt routing
[    0.127540] ACPI: No dock devices found.
[    0.127680] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.127994] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.128282] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.128285] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.128287] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.128290] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.128292] pci_root PNP0A03:00: host bridge window [mem 0xee000000-0xffffffff] (ignored)
[    0.128294] PCI: root bus 00: hardware-probed resources
[    0.128300] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.128581] PCI host bridge to bus 0000:00
[    0.128710] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.128713] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.128849] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.129013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.129151] pci_bus 0000:00: root bus resource [mem 0xee000000-0xffffffff]
[    0.129288] pci_bus 0000:00: root bus resource [mem 0x112000000-0xfcffffffff]
[    0.129438] pci 0000:00:01.0: [1166:0036] type 01 class 0x060400
[    0.129460] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.129624] pci 0000:00:02.0: [1166:0205] type 00 class 0x060000
[    0.129664] pci 0000:00:02.1: [1166:0214] type 00 class 0x01018a
[    0.129674] pci 0000:00:02.1: reg 10: [io  0x01f0-0x01f7]
[    0.129682] pci 0000:00:02.1: reg 14: [io  0x03f4-0x03f7]
[    0.129690] pci 0000:00:02.1: reg 18: [io  0x0170-0x0177]
[    0.129699] pci 0000:00:02.1: reg 1c: [io  0x0374-0x0377]
[    0.129707] pci 0000:00:02.1: reg 20: [io  0xffa0-0xffaf]
[    0.129736] pci 0000:00:02.2: [1166:0234] type 00 class 0x060100
[    0.129804] pci 0000:00:03.0: [1166:0223] type 00 class 0x0c0310
[    0.129819] pci 0000:00:03.0: reg 10: [mem 0xff6ee000-0xff6eefff]
[    0.129827] pci 0000:00:03.0: reg 14: [io  0xe800-0xe8ff]
[    0.129895] pci 0000:00:03.1: [1166:0223] type 00 class 0x0c0310
[    0.129910] pci 0000:00:03.1: reg 10: [mem 0xff6ed000-0xff6edfff]
[    0.129918] pci 0000:00:03.1: reg 14: [io  0xd800-0xd8ff]
[    0.130021] pci 0000:00:03.2: [1166:0223] type 00 class 0x0c0320
[    0.130035] pci 0000:00:03.2: reg 10: [mem 0xff6ec000-0xff6ecfff]
[    0.130044] pci 0000:00:03.2: reg 14: [io  0xd400-0xd4ff]
[    0.130098] pci 0000:00:03.2: supports D1 D2
[    0.130100] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.130124] pci 0000:00:05.0: [1002:515e] type 00 class 0x030000
[    0.130138] pci 0000:00:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.130147] pci 0000:00:05.0: reg 14: [io  0xe000-0xe0ff]
[    0.130156] pci 0000:00:05.0: reg 18: [mem 0xff6f0000-0xff6fffff]
[    0.130184] pci 0000:00:05.0: reg 30: [mem 0xff6c0000-0xff6dffff pref]
[    0.130207] pci 0000:00:05.0: supports D1 D2
[    0.130233] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.130249] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.130261] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.130274] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.130308] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-ff]
[    0.130322] pci 0000:01:0d.0: [1166:0104] type 01 class 0x060400
[    0.130356] pci 0000:01:0e.0: [1166:024b] type 00 class 0x01018f
[    0.130365] pci 0000:01:0e.0: reg 10: [io  0xbc00-0xbc07]
[    0.130370] pci 0000:01:0e.0: reg 14: [io  0xb880-0xb883]
[    0.130375] pci 0000:01:0e.0: reg 18: [io  0xb800-0xb807]
[    0.130381] pci 0000:01:0e.0: reg 1c: [io  0xb480-0xb483]
[    0.130386] pci 0000:01:0e.0: reg 20: [io  0xb400-0xb40f]
[    0.130391] pci 0000:01:0e.0: reg 24: [mem 0xff5fe000-0xff5fffff]
[    0.130397] pci 0000:01:0e.0: reg 30: [mem 0xff5c0000-0xff5dffff pref]
[    0.130428] pci 0000:01:0e.1: [1166:024b] type 00 class 0x01018f
[    0.130437] pci 0000:01:0e.1: reg 10: [io  0xb080-0xb087]
[    0.130443] pci 0000:01:0e.1: reg 14: [io  0xb000-0xb003]
[    0.130448] pci 0000:01:0e.1: reg 18: [io  0xac00-0xac07]
[    0.130453] pci 0000:01:0e.1: reg 1c: [io  0xa880-0xa883]
[    0.130459] pci 0000:01:0e.1: reg 20: [io  0xa800-0xa80f]
[    0.130500] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.130637] pci 0000:00:01.0:   bridge window [io  0x7000-0xbfff]
[    0.130640] pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff5fffff]
[    0.130644] pci 0000:00:01.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.130654] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.130671] pci 0000:02:01.0: [1000:0054] type 00 class 0x010000
[    0.130687] pci 0000:02:01.0: reg 10: [io  0x9000-0x90ff]
[    0.130699] pci 0000:02:01.0: reg 14: [mem 0xff4fc000-0xff4fffff 64bit]
[    0.130711] pci 0000:02:01.0: reg 1c: [mem 0xff4e0000-0xff4effff 64bit]
[    0.130725] pci 0000:02:01.0: reg 30: [mem 0xff200000-0xff3fffff pref]
[    0.130761] pci 0000:02:01.0: supports D1 D2
[    0.130786] pci 0000:02:03.0: [14e4:1648] type 00 class 0x020000
[    0.130804] pci 0000:02:03.0: reg 10: [mem 0xff4d0000-0xff4dffff 64bit]
[    0.130875] pci 0000:02:03.0: PME# supported from D3hot D3cold
[    0.130900] pci 0000:02:03.1: [14e4:1648] type 00 class 0x020000
[    0.130918] pci 0000:02:03.1: reg 10: [mem 0xff4c0000-0xff4cffff 64bit]
[    0.131010] pci 0000:02:03.1: PME# supported from D3hot D3cold
[    0.131051] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.131185] pci 0000:01:0d.0:   bridge window [io  0x7000-0x9fff]
[    0.131189] pci 0000:01:0d.0:   bridge window [mem 0xff000000-0xff4fffff]
[    0.131193] pci 0000:01:0d.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.131202] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.131276] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.131306] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
[    0.131362]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.131575]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.133681] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.134642] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.135678] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.136721] ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 *10 11 12 14 15)
[    0.137678] ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 *9 10 11 12 14 15)
[    0.138726] ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.139772] ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.140825] ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.141870] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 *5 6 7 9 10 11 12 14 15)
[    0.142821] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 *7 9 10 11 12 14 15)
[    0.145034] ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.146433] ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.147524] ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.148572] ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.149624] ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.150671] ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.151719] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.152770] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.153822] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.154871] ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.155917] ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.157006] ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.158031] ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.159031] ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.160152] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.161201] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.162251] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.163300] ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.164300] ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.165299] ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.166469] ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.167546] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.167899] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
[    0.168366] vgaarb: device added: PCI:0000:00:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.168549] vgaarb: loaded
[    0.168678] vgaarb: bridge control possible 0000:00:05.0
[    0.169039] SCSI subsystem initialized
[    0.169180] ACPI: bus type usb registered
[    0.169398] usbcore: registered new interface driver usbfs
[    0.169578] usbcore: registered new interface driver hub
[    0.169802] usbcore: registered new device driver usb
[    0.170096] PCI: Using ACPI for IRQ routing
[    0.170234] PCI: pci_cache_line_size set to 64 bytes
[    0.170300] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.170302] e820: reserve RAM buffer [mem 0xedff0000-0xefffffff]
[    0.170304] e820: reserve RAM buffer [mem 0x112000000-0x113ffffff]
[    0.178839] pnp: PnP ACPI init
[    0.179022] ACPI: bus type pnp registered
[    0.179303] pnp 00:00: [bus 00-ff]
[    0.179306] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.179308] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.179311] pnp 00:00: [io  0x0d00-0xffff window]
[    0.179313] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.179315] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.179318] pnp 00:00: [mem 0xee000000-0xffffffff window]
[    0.179412] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.179443] pnp 00:01: [dma 4]
[    0.179447] pnp 00:01: [io  0x0000-0x000f]
[    0.179450] pnp 00:01: [io  0x0081-0x0083]
[    0.179452] pnp 00:01: [io  0x0087]
[    0.179454] pnp 00:01: [io  0x0089-0x008b]
[    0.179456] pnp 00:01: [io  0x008f]
[    0.179458] pnp 00:01: [io  0x00c0-0x00df]
[    0.179509] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.179524] pnp 00:02: [io  0x0070-0x0071]
[    0.179536] pnp 00:02: [irq 8]
[    0.179585] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.179623] pnp 00:03: [io  0x0060]
[    0.179625] pnp 00:03: [io  0x0064]
[    0.179630] pnp 00:03: [irq 1]
[    0.179683] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.179742] pnp 00:04: [irq 12]
[    0.179796] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.179807] pnp 00:05: [io  0x0061]
[    0.179856] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.179869] pnp 00:06: [io  0x00f0-0x00ff]
[    0.179874] pnp 00:06: [irq 13]
[    0.179923] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.180287] pnp 00:07: [io  0x03f0-0x03f5]
[    0.180290] pnp 00:07: [io  0x03f7]
[    0.180294] pnp 00:07: [irq 6]
[    0.180296] pnp 00:07: [dma 2]
[    0.180379] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.180643] pnp 00:08: [io  0x03f8-0x03ff]
[    0.180648] pnp 00:08: [irq 4]
[    0.180651] pnp 00:08: [dma 0 disabled]
[    0.180740] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.181013] pnp 00:09: [io  0x02f8-0x02ff]
[    0.181018] pnp 00:09: [irq 3]
[    0.181020] pnp 00:09: [dma 0 disabled]
[    0.181136] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.181605] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.181607] pnp 00:0a: [io  0x0600-0x061f]
[    0.181609] pnp 00:0a: [io  0x0520-0x053f]
[    0.181611] pnp 00:0a: [io  0x0540-0x054f]
[    0.181613] pnp 00:0a: [io  0x0544-0x0553]
[    0.181615] pnp 00:0a: [io  0x0550-0x055f]
[    0.181617] pnp 00:0a: [io  0x0640-0x065f]
[    0.181620] pnp 00:0a: [io  0x0800-0x080f]
[    0.181622] pnp 00:0a: [io  0x0aa0-0x0abf]
[    0.181624] pnp 00:0a: [io  0x0ac0-0x0adf]
[    0.181626] pnp 00:0a: [io  0x0ae0-0x0aff]
[    0.181711] system 00:0a: [io  0x0600-0x061f] has been reserved
[    0.181850] system 00:0a: [io  0x0520-0x053f] has been reserved
[    0.181996] system 00:0a: [io  0x0540-0x054f] has been reserved
[    0.182132] system 00:0a: [io  0x0544-0x0553] could not be reserved
[    0.182269] system 00:0a: [io  0x0550-0x055f] has been reserved
[    0.182405] system 00:0a: [io  0x0640-0x065f] has been reserved
[    0.182543] system 00:0a: [io  0x0800-0x080f] has been reserved
[    0.182679] system 00:0a: [io  0x0aa0-0x0abf] has been reserved
[    0.182816] system 00:0a: [io  0x0ac0-0x0adf] has been reserved
[    0.182952] system 00:0a: [io  0x0ae0-0x0aff] has been reserved
[    0.182975] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.183053] pnp 00:0b: [io  0x0010-0x001f]
[    0.183057] pnp 00:0b: [io  0x0022-0x003f]
[    0.183059] pnp 00:0b: [io  0x0044-0x005f]
[    0.183061] pnp 00:0b: [io  0x0062-0x0063]
[    0.183063] pnp 00:0b: [io  0x0065-0x006f]
[    0.183065] pnp 00:0b: [io  0x0072-0x007f]
[    0.183068] pnp 00:0b: [io  0x0080]
[    0.183070] pnp 00:0b: [io  0x0084-0x0086]
[    0.183072] pnp 00:0b: [io  0x0088]
[    0.183074] pnp 00:0b: [io  0x008c-0x008e]
[    0.183076] pnp 00:0b: [io  0x0090-0x009f]
[    0.183078] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.183080] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.183082] pnp 00:0b: [io  0x0092]
[    0.183084] pnp 00:0b: [io  0x040b]
[    0.183086] pnp 00:0b: [io  0x04d6]
[    0.183088] pnp 00:0b: [io  0x0c06-0x0c07]
[    0.183090] pnp 00:0b: [io  0x0c49]
[    0.183092] pnp 00:0b: [io  0x0c4a]
[    0.183094] pnp 00:0b: [io  0x0c6f]
[    0.183096] pnp 00:0b: [io  0x0c98]
[    0.183099] pnp 00:0b: [io  0x0f50-0x0f57]
[    0.183101] pnp 00:0b: [io  0x0c00-0x0c01]
[    0.183103] pnp 00:0b: [io  0x0c14]
[    0.183105] pnp 00:0b: [io  0x0c50-0x0c51]
[    0.183107] pnp 00:0b: [io  0x0c52]
[    0.183109] pnp 00:0b: [io  0x0c6c]
[    0.183111] pnp 00:0b: [io  0x0c6f]
[    0.183113] pnp 00:0b: [io  0x0cd6-0x0cd7]
[    0.183115] pnp 00:0b: [io  0x0cd4-0x0cd5]
[    0.183117] pnp 00:0b: [io  0x0cd8-0x0cdf]
[    0.183120] pnp 00:0b: [io  0x002e-0x002f]
[    0.183122] pnp 00:0b: [io  0x0530-0x0531]
[    0.183124] pnp 00:0b: [io  0x0440-0x045f]
[    0.183127] pnp 00:0b: [io  0x0480-0x049f]
[    0.183129] pnp 00:0b: [io  0x04c0-0x04df]
[    0.183131] pnp 00:0b: [io  0x0500-0x051f]
[    0.183133] pnp 00:0b: [io  0x0540-0x055f]
[    0.183135] pnp 00:0b: [io  0x0560-0x057f]
[    0.183137] pnp 00:0b: [io  0x0580-0x058f]
[    0.183139] pnp 00:0b: [io  0x0590-0x05ff]
[    0.183142] pnp 00:0b: [io  0x0660-0x06df]
[    0.183144] pnp 00:0b: [io  0x06e0-0x075f]
[    0.183146] pnp 00:0b: [io  0x0760-0x07ff]
[    0.183148] pnp 00:0b: [io  0x0ca8-0x0cab]
[    0.183151] pnp 00:0b: [io  0x0cac-0x0caf]
[    0.183153] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.183155] pnp 00:0b: [io  0x0500-0x057f]
[    0.183157] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.183159] pnp 00:0b: [mem 0xfebfe000-0xfebfefff]
[    0.183162] pnp 00:0b: [mem 0xff600000-0xffffffff]
[    0.183322] system 00:0b: [io  0x040b] has been reserved
[    0.183459] system 00:0b: [io  0x04d6] has been reserved
[    0.183594] system 00:0b: [io  0x0c06-0x0c07] has been reserved
[    0.183731] system 00:0b: [io  0x0c49] has been reserved
[    0.183986] system 00:0b: [io  0x0c4a] has been reserved
[    0.184121] system 00:0b: [io  0x0c6f] has been reserved
[    0.184256] system 00:0b: [io  0x0c98] has been reserved
[    0.184391] system 00:0b: [io  0x0f50-0x0f57] has been reserved
[    0.184528] system 00:0b: [io  0x0c00-0x0c01] has been reserved
[    0.184664] system 00:0b: [io  0x0c14] has been reserved
[    0.184800] system 00:0b: [io  0x0c50-0x0c51] has been reserved
[    0.184936] system 00:0b: [io  0x0c52] has been reserved
[    0.184974] system 00:0b: [io  0x0c6c] has been reserved
[    0.185108] system 00:0b: [io  0x0c6f] has been reserved
[    0.185242] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
[    0.185383] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
[    0.185519] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
[    0.185656] system 00:0b: [io  0x0530-0x0531] has been reserved
[    0.185792] system 00:0b: [io  0x0440-0x045f] has been reserved
[    0.185974] system 00:0b: [io  0x0480-0x049f] has been reserved
[    0.186110] system 00:0b: [io  0x04c0-0x04df] could not be reserved
[    0.186246] system 00:0b: [io  0x0500-0x051f] has been reserved
[    0.186382] system 00:0b: [io  0x0540-0x055f] could not be reserved
[    0.186519] system 00:0b: [io  0x0560-0x057f] has been reserved
[    0.186655] system 00:0b: [io  0x0580-0x058f] has been reserved
[    0.186794] system 00:0b: [io  0x0590-0x05ff] has been reserved
[    0.186974] system 00:0b: [io  0x0660-0x06df] has been reserved
[    0.187110] system 00:0b: [io  0x06e0-0x075f] has been reserved
[    0.187246] system 00:0b: [io  0x0760-0x07ff] has been reserved
[    0.187382] system 00:0b: [io  0x0ca8-0x0cab] has been reserved
[    0.187520] system 00:0b: [io  0x0cac-0x0caf] has been reserved
[    0.187655] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.187793] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    0.187976] system 00:0b: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.188113] system 00:0b: [mem 0xff600000-0xffffffff] could not be reserved
[    0.188251] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.188317] pnp 00:0c: [mem 0xfec00000-0xfec00fff]
[    0.188320] pnp 00:0c: [mem 0xfee00000-0xfee00fff]
[    0.188387] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.188526] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.188664] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.188775] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.188778] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.188780] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.188782] pnp 00:0d: [mem 0x00100000-0xedffffff]
[    0.188784] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.188855] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.188980] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.189119] system 00:0d: [mem 0x00100000-0xedffffff] could not be reserved
[    0.189258] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.189924] pnp: PnP ACPI: found 14 devices
[    0.189972] ACPI: ACPI bus type pnp unregistered
[    0.198174] Switching to clocksource acpi_pm
[    0.198359] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.198497] pci 0000:01:0d.0:   bridge window [io  0x7000-0x9fff]
[    0.198635] pci 0000:01:0d.0:   bridge window [mem 0xff000000-0xff4fffff]
[    0.198774] pci 0000:01:0d.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.198774] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.198833] pci 0000:00:01.0:   bridge window [io  0x7000-0xbfff]
[    0.198970] pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff5fffff]
[    0.199154] pci 0000:00:01.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.199377] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.199380] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.199382] pci_bus 0000:00: resource 6 [mem 0xee000000-0xffffffff]
[    0.199385] pci_bus 0000:00: resource 7 [mem 0x112000000-0xfcffffffff]
[    0.199388] pci_bus 0000:01: resource 0 [io  0x7000-0xbfff]
[    0.199391] pci_bus 0000:01: resource 1 [mem 0xff000000-0xff5fffff]
[    0.199393] pci_bus 0000:01: resource 2 [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.199396] pci_bus 0000:02: resource 0 [io  0x7000-0x9fff]
[    0.199398] pci_bus 0000:02: resource 1 [mem 0xff000000-0xff4fffff]
[    0.199401] pci_bus 0000:02: resource 2 [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.199442] NET: Registered protocol family 2
[    0.200314] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.204428] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.205165] TCP: Hash tables configured (established 524288 bind 65536)
[    0.205358] TCP: reno registered
[    0.205499] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.205671] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.205915] NET: Registered protocol family 1
[    0.206153] RPC: Registered named UNIX socket transport module.
[    0.206291] RPC: Registered udp transport module.
[    0.206423] RPC: Registered tcp transport module.
[    0.206555] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.206746] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    0.341042] pci 0000:00:05.0: Boot video device
[    0.341068] PCI: CLS 64 bytes, default 64
[    0.341113] Trying to unpack rootfs image as initramfs...
[    0.593203] Freeing initrd memory: 11136k freed
[    0.600243] PCI-DMA: Disabling AGP.
[    0.600474] PCI-DMA: aperture base @ e4000000 size 65536 KB
[    0.600608] PCI-DMA: using GART IOMMU.
[    0.600741] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.605350] audit: initializing netlink socket (disabled)
[    0.605501] type=2000 audit(1348238590.604:1): initialized
[    0.623796] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.624690] VFS: Disk quotas dquot_6.5.2
[    0.624844] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.625198] NFS: Registering the id_resolver key type
[    0.625348] Key type id_resolver registered
[    0.625480] Key type id_legacy registered
[    0.625613] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.626065] msgmni has been set to 7922
[    0.626429] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.626667] io scheduler noop registered
[    0.626800] io scheduler deadline registered
[    0.626942] io scheduler cfq registered (default)
[    0.627329] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.627545] ACPI: Power Button [PWRB]
[    0.627752] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.627966] ACPI: Sleep Button [SLPB]
[    0.628176] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.628388] ACPI: Power Button [PWRF]
[    0.628598] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input3
[    0.628810] ACPI: Sleep Button [SLPF]
[    0.629077] ACPI: processor limited to max C-state 1
[    0.629415] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.653078] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.673807] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.694534] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.715669] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.736475] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.736947] Real Time Clock Driver v1.12b
[    0.737254] Linux agpgart interface v0.103
[    0.739586] brd: module loaded
[    0.740893] loop: module loaded
[    0.741041] Uniform Multi-Platform E-IDE driver
[    0.741273] serverworks 0000:00:02.1: IDE controller (0x1166:0x0214 rev 0x00)
[    0.741433] serverworks 0000:00:02.1: not 100% native mode: will probe irqs later
[    0.743279]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.743420] Probing IDE interface ide0...
[    1.718013] hdb: CD-224E-R, ATAPI CD/DVD-ROM drive
[    1.718302] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.718971] hdb: UDMA/33 mode selected
[    1.730160] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.730704] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.730920] ide-gd driver 1.18
[    1.731107] ide-cd driver 5.00
[    1.742018] ide-cd: hdb: ATAPI 24X CD-ROM drive, 90kB Cache
[    1.742350] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.788631] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.788767] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.789107] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.789308] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    1.789513] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
[    1.810031] ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6ec000
[    1.816014] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    1.816300] hub 1-0:1.0: USB hub found
[    1.816435] hub 1-0:1.0: 4 ports detected
[    1.816656] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.816836] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    1.817042] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
[    1.817267] ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6ee000
[    1.872153] hub 2-0:1.0: USB hub found
[    1.872290] hub 2-0:1.0: 2 ports detected
[    1.872482] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    1.872670] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
[    1.872893] ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6ed000
[    1.928146] hub 3-0:1.0: USB hub found
[    1.928282] hub 3-0:1.0: 2 ports detected
[    1.928484] uhci_hcd: USB Universal Host Controller Interface driver
[    1.928721] usbcore: registered new interface driver usblp
[    1.928962] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.931670] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.931807] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.932074] mousedev: PS/2 mouse device common for all mice
[    1.932516] cpuidle: using governor ladder
[    1.933848] usbcore: registered new interface driver usbhid
[    1.933982] usbhid: USB HID core driver
[    1.934225] TCP: cubic registered
[    1.934356] NET: Registered protocol family 17
[    1.934515] Key type dns_resolver registered
[    1.935098] registered taskstats version 1
[    1.935714] console [netcon0] enabled
[    1.935846] netconsole: network logging started
[    1.935982] powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 1216 HE (2 cpu cores) (version 2.20.00)
[    1.936236] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    1.936236] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    1.938054] Freeing unused kernel memory: 896k freed
[    1.964357] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.974109] ACPI: bus type scsi registered
[    1.974414] libata version 3.00 loaded.
[    1.975293] sata_svw 0000:01:0e.0: version 2.3
[    1.976035] scsi0 : sata_svw
[    1.976294] scsi1 : sata_svw
[    1.976532] scsi2 : sata_svw
[    1.976768] scsi3 : sata_svw
[    1.976984] ata1: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe000 irq 11
[    1.977233] ata2: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe100 irq 11
[    1.977444] ata3: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe200 irq 11
[    1.977653] ata4: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe300 irq 11
[    2.292357] ata1: SATA link down (SStatus 4 SControl 300)
[    2.607354] ata2: SATA link down (SStatus 4 SControl 300)
[    2.922356] ata3: SATA link down (SStatus 4 SControl 300)
[    3.115235] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
[    3.237355] ata4: SATA link down (SStatus 4 SControl 300)
[    3.241295] Fusion MPT base driver 3.04.20
[    3.241431] Copyright (c) 1999-2008 LSI Corporation
[    3.247074] Fusion MPT SAS Host driver 3.04.20
[    3.247365] mptbase: ioc0: Initiating bringup
[    3.525010] ioc0: LSISAS1068 B0: Capabilities={Initiator}
[   25.212058] scsi4 : ioc0: LSISAS1068 B0, FwRev=011e0000h, Ports=1, MaxQ=277, IRQ=20
[   25.253381] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c500070dc515
[   25.254664] scsi 4:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.257147] sd 4:0:0:0: Attached scsi generic sg0 type 0
[   25.260219] sd 4:0:0:0: [sda] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.260843] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1, sas_addr 0x5000c500070dac45
[   25.262121] scsi 4:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.262633] sd 4:0:0:0: [sda] Write Protect is off
[   25.262770] sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
[   25.264542] sd 4:0:1:0: Attached scsi generic sg1 type 0
[   25.267097] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.267830] sd 4:0:1:0: [sdb] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.268459] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 2, phy 2, sas_addr 0x5000c500070dc391
[   25.271630] scsi 4:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.272244] sd 4:0:1:0: [sdb] Write Protect is off
[   25.272379] sd 4:0:1:0: [sdb] Mode Sense: b3 00 10 08
[   25.274076] sd 4:0:2:0: Attached scsi generic sg2 type 0
[   25.276625] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.277355] sd 4:0:2:0: [sdc] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.277981] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 3, phy 3, sas_addr 0x5000c500070daf29
[   25.278227]  sda: sda1 sda2 sda3
[   25.283271] scsi 4:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.283283] sd 4:0:2:0: [sdc] Write Protect is off
[   25.283285] sd 4:0:2:0: [sdc] Mode Sense: b3 00 10 08
[   25.284987] sd 4:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.285856] sd 4:0:3:0: Attached scsi generic sg3 type 0
[   25.290393] sd 4:0:0:0: [sda] Attached SCSI disk
[   25.290865] sd 4:0:3:0: [sdd] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.291496] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 4, phy 4, sas_addr 0x5000c500070dc0c1
[   25.291520]  sdb: sdb1 sdb2
[   25.294539] sd 4:0:3:0: [sdd] Write Protect is off
[   25.294675] sd 4:0:3:0: [sdd] Mode Sense: b3 00 10 08
[   25.294898] scsi 4:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.296478] sd 4:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.297332] sd 4:0:4:0: Attached scsi generic sg4 type 0
[   25.301864] sd 4:0:1:0: [sdb] Attached SCSI disk
[   25.302387] sd 4:0:4:0: [sde] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.302992] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 5, phy 5, sas_addr 0x5000c500070daa9d
[   25.304273] scsi 4:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.304791] sd 4:0:4:0: [sde] Write Protect is off
[   25.304927] sd 4:0:4:0: [sde] Mode Sense: b3 00 10 08
[   25.306661]  sdd: sdd1 sdd2
[   25.306913] sd 4:0:5:0: Attached scsi generic sg5 type 0
[   25.309243]  sdc: sdc1 sdc2 sdc3
[   25.309248] sd 4:0:4:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.309562] sd 4:0:5:0: [sdf] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.313114] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 7, phy 6, sas_addr 0x5000c500070dc1e5
[   25.317580] sd 4:0:5:0: [sdf] Write Protect is off
[   25.317715] sd 4:0:5:0: [sdf] Mode Sense: b3 00 10 08
[   25.317971] scsi 4:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.319558] sd 4:0:5:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.320457] sd 4:0:6:0: Attached scsi generic sg6 type 0
[   25.324926] sd 4:0:3:0: [sdd] Attached SCSI disk
[   25.324980] sd 4:0:2:0: [sdc] Attached SCSI disk
[   25.325018]  sde: sde1
[   25.325265] sd 4:0:6:0: [sdg] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.326789] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 8, phy 7, sas_addr 0x5000c5000128ff31
[   25.329606] scsi 4:0:7:0: Direct-Access     SEAGATE  ST373455SS       0004 PQ: 0 ANSI: 5
[   25.329880] sd 4:0:6:0: [sdg] Write Protect is off
[   25.330029] sd 4:0:6:0: [sdg] Mode Sense: b3 00 10 08
[   25.331159]  sdf: sdf1
[   25.332026] sd 4:0:7:0: Attached scsi generic sg7 type 0
[   25.332595] sd 4:0:6:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.336828] sd 4:0:4:0: [sde] Attached SCSI disk
[   25.337302] sd 4:0:7:0: [sdh] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.341463] sd 4:0:7:0: [sdh] Write Protect is off
[   25.341597] sd 4:0:7:0: [sdh] Mode Sense: b3 00 10 08
[   25.342822] sd 4:0:5:0: [sdf] Attached SCSI disk
[   25.343163] sd 4:0:7:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.346261]  sdg: sdg1
[   25.352130]  sdh: sdh1
[   25.354665] sd 4:0:6:0: [sdg] Attached SCSI disk
[   25.360622] sd 4:0:7:0: [sdh] Attached SCSI disk
[   25.384975] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   25.391146] fuse init (API version 7.20)
[   25.403426] md: linear personality registered for level -1
[   25.408636] md: raid0 personality registered for level 0
[   25.411923] md: raid1 personality registered for level 1
[   25.414618] async_tx: api initialized (async)
[   25.415432] xor: automatically using best checksumming function:
[   25.425011]    generic_sse:  7312.000 MB/sec
[   25.445037] raid6: sse2x1    3113 MB/s
[   25.462018] raid6: sse2x2    4035 MB/s
[   25.479031] raid6: sse2x4    4191 MB/s
[   25.479162] raid6: using algorithm sse2x4 (4191 MB/s)
[   25.479295] raid6: using intx1 recovery algorithm
[   25.482167] md: raid6 personality registered for level 6
[   25.482307] md: raid5 personality registered for level 5
[   25.482440] md: raid4 personality registered for level 4
[   25.509600] udevd (1600): /proc/1600/oom_adj is deprecated, please use /proc/1600/oom_score_adj instead.
[   25.776024] tg3.c:v3.124 (March 21, 2012)
[   25.782211] tg3 0000:02:03.0: eth0: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:30:48:63:8b:6e
[   25.782434] tg3 0000:02:03.0: eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   25.782652] tg3 0000:02:03.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[   25.782864] tg3 0000:02:03.0: eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
[   25.800580] tg3 0000:02:03.1: eth1: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:30:48:63:8b:6f
[   25.800807] tg3 0000:02:03.1: eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   25.801041] tg3 0000:02:03.1: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   25.801254] tg3 0000:02:03.1: eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
[   25.808856] EDAC MC: Ver: 3.0.0
[   25.809094] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   25.814032] piix4_smbus 0000:00:02.0: SMBus Host Controller at 0x580, revision 0
[   25.815990] AMD64 EDAC driver v3.4.0
[   25.819874] EDAC amd64: DRAM ECC enabled.
[   25.820061] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
[   25.820063] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x1f, NB MSR is enabled
[   25.820066] EDAC amd64: K8 revF or later detected (node 0).
[   25.820208] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   25.820209] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   25.820211] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   25.820212] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000ee000000
[   25.820214] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000112000000
[   25.820217] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x0000000111ffffff
[   25.820220] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   25.820225] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
[   25.820227] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000101 reg: F2x44
[   25.820228] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000201 reg: F2x48
[   25.820230] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000301 reg: F2x4c
[   25.820232] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   25.820234] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   25.820236] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
[   25.820238] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
[   25.820240] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00f83ce0 reg: F2x60
[   25.820242] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   25.820243] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   25.820245] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
[   25.820248] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x00001719
[   25.820250] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   25.820251] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   25.820253] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090810
[   25.820254] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
[   25.820256] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
[   25.820258] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   25.820259] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x0f000000
[   25.820261] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xee001201, base: 0xee000000, offset: 0x12000000
[   25.820262] EDAC DEBUG: dump_misc_regs:   DramHoleValid: yes
[   25.820264] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000022
[   25.820266] EDAC MC: DCT0 chip selects:
[   25.820268] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[   25.820400] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   25.820532] EDAC amd64: MC: 4:     0MB 5:     0MB
[   25.820664] EDAC amd64: MC: 6:     0MB 7:     0MB
[   25.820798] EDAC DEBUG: edac_mc_alloc: allocating 1160 bytes for mci data (16 ranks, 16 csrows/channels)
[   25.820824] EDAC DEBUG: init_csrows: node 0, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
[   25.820825] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
[   25.820827] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel: 0, DBAM idx: 2
[   25.820829] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.820830] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   25.820964] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
[   25.820965] EDAC DEBUG: init_csrows: MC node: 0, csrow: 1
[   25.820967] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 1, channel: 0, DBAM idx: 2
[   25.820968] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.820970] EDAC amd64: CS1: Unbuffered DDR2 RAM
[   25.821117] EDAC DEBUG: init_csrows: Total csrow1 pages: 262144
[   25.821118] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   25.821120] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 2
[   25.821121] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.821122] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   25.821255] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
[   25.821256] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
[   25.821258] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 2
[   25.821259] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.821261] EDAC amd64: CS3: Unbuffered DDR2 RAM
[   25.821392] EDAC DEBUG: init_csrows: Total csrow3 pages: 262144
[   25.821394] EDAC DEBUG: edac_mc_add_mc: 
[   25.821397] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   25.821426] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   25.821769] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm0, located at csrow 0 channel 0 
[   25.821784] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank0
[   25.821786] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm1, located at csrow 0 channel 1 
[   25.821799] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank1
[   25.821800] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm2, located at csrow 1 channel 0 
[   25.821814] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank2
[   25.821816] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm3, located at csrow 1 channel 1 
[   25.821833] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank3
[   25.821834] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm8, located at csrow 4 channel 0 
[   25.821848] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank8
[   25.821850] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm9, located at csrow 4 channel 1 
[   25.821863] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank9
[   25.821864] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm10, located at csrow 5 channel 0 
[   25.821878] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank10
[   25.821879] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm11, located at csrow 5 channel 1 
[   25.821891] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank11
[   25.821894] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow0
[   25.821908] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow1
[   25.821921] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   25.821933] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   25.821966] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
[   25.822292] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   25.822298] EDAC DEBUG: edac_pci_add_device: 
[   25.822299] EDAC DEBUG: add_edac_pci_to_global_list: 
[   25.822301] EDAC DEBUG: find_edac_pci_by_dev: 
[   25.822303] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   25.822304] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   25.822311] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   25.822312] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   25.822316] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   25.822318] EDAC DEBUG: edac_pci_workq_setup: 
[   25.822323] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   25.832484] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   29.140395] kvm: Nested Virtualization enabled
[   29.159727] microcode: AMD CPU family 0xf not supported
[   29.911046] w83793 0-002f: Registered watchdog chardev major 10, minor: 130
[   30.095563] NET: Registered protocol family 10
[   30.095991] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   30.096166] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.777264] Adding 4192960k swap on /dev/sdc3.  Priority:-1 extents:1 across:4192960k 
[   31.224085] microcode: AMD CPU family 0xf not supported
[   31.330160] microcode: AMD CPU family 0xf not supported
[   32.437598] tg3 0000:02:03.0: eth1: Link is up at 1000 Mbps, full duplex
[   32.437742] tg3 0000:02:03.0: eth1: Flow control is off for TX and off for RX
[   32.437894] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   32.494668] tg3 0000:02:03.1: eth0: Link is up at 1000 Mbps, full duplex
[   32.494806] tg3 0000:02:03.1: eth0: Flow control is off for TX and off for RX
[   32.494948] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   33.559623] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.285735] warning: `named' uses 32-bit capabilities (legacy support in use)
[   84.837220] EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xee000000 offset 0x12000000 size 0x12000000

--------------000709090903080006070104--
