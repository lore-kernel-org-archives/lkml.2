Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2IUNCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:02:25 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:40526 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab2IUNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:02:20 -0400
Message-ID: <505C6558.1040405@akamai.com>
Date: Fri, 21 Sep 2012 08:02:16 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <20120912153016.GA12103@aftab.osrc.amd.com> <5050AC2E.3050408@akamai.com> <20120912154943.GB12103@aftab.osrc.amd.com> <5050B708.5020308@akamai.com> <20120912164843.GC12103@aftab.osrc.amd.com> <5050BF1F.1080503@akamai.com> <20120912170629.GD12103@aftab.osrc.amd.com> <20120912172351.GE12103@aftab.osrc.amd.com> <50532940.10201@akamai.com> <50534184.1050208@akamai.com> <20120921123645.GD26869@aftab.osrc.amd.com>
In-Reply-To: <20120921123645.GD26869@aftab.osrc.amd.com>
Content-Type: multipart/mixed;
 boundary="------------020301070402000402020107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020301070402000402020107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/21/2012 07:36 AM, Borislav Petkov wrote:
> Ok, I think this is still the old code you're looking at so it would be
> cool if you could test with my patchset I sent you last week.
>
> Because with it, it all looks fine on my K8 here:
>
> It has 2 2048MB single-ranked DIMMs on each node and edac output looks
> like this:
>
> [   52.920302] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000060
> [   52.920302] EDAC MC: DCT0 chip selects:
> [   52.920304] EDAC amd64: MC: 0:     0MB 1:     0MB
> [   52.920305] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [   52.920306] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   52.920308] EDAC amd64: MC: 6:     0MB 7:     0MB
>
> ...
>
> [   52.920344] EDAC DEBUG: init_csrows: node 1, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
> [   52.920345] EDAC DEBUG: init_csrows: MC node: 1, csrow: 2
> [   52.920346] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 6
> [   52.920347] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 524288
> [   52.920348] EDAC amd64: CS2: Registered DDR2 RAM
> [   52.920350] EDAC DEBUG: init_csrows: Total csrow2 pages: 524288
> [   52.920351] EDAC DEBUG: init_csrows: MC node: 1, csrow: 3
> [   52.920352] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 6
> [   52.920353] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 524288
> [   52.920354] EDAC amd64: CS3: Registered DDR2 RAM
> [   52.920355] EDAC DEBUG: init_csrows: Total csrow3 pages: 524288
>
> $ cat /sys/devices/system/edac/mc/mc0/csrow2/size_mb
> 2048
> $ cat /sys/devices/system/edac/mc/mc0/csrow3/size_mb
> 2048
>
> So what am I missing?
>
> Thanks.

I'm running with your edac-queue branch with the last commit being:
  9d67117feece8852570cc8ee25b68c41f8def323

You can verify this with my dmesg (also attached) showing the new dbg 
messages added:

<patch>
+       edac_dbg(0, "csrow: %d, channel: %d, DBAM idx: %d\n",
+                   csrow_nr, dct,  cs_mode);
+       edac_dbg(0, "nr_pages/channel: %u\n", nr_pages);
</patch>

<dmesg>
[   25.838822] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, 
DBAM idx: 2
[   25.838823] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
</dmesg>

Please let me know if this is the wrong version and I can rerun with the 
correct one.

Here's what I see in sysfs:
root@x.x.x.x:/sys/devices/system/edac/mc/mc0# grep . csrow*/size_mb
csrow0/size_mb:2048
csrow1/size_mb:2048
csrow2/size_mb:2048
csrow3/size_mb:2048

Here's what free reports:
root@x.x.x.x:/sys/devices/system/edac/mc/mc0# free
              total       used       free     shared    buffers     cached
Mem:       4057308     159300    3898008          0       3972      79048
-/+ buffers/cache:      76280    3981028
Swap:      4192960          0    4192960

IIRC the issue I was pointing out in my last mail is the code detected 2 
channels on my system. Which appeared to lead to double counting in the 
sysfs code. The channel detection code in
k8_early_channel_count() returns 2 when WIDTH_128 is set.

If you're seeing it behave correctly on your system I wonder if the 
WIDTH_128 bit is true for your machine?

Josh

--------------020301070402000402020107
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc5+ (johunt@kernelsuite-780) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #1 SMP Thu Sep 13 16:55:28 PDT 2012
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
[    0.000000] tsc: Detected 2394.071 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.001138] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.14 BogoMIPS (lpj=2394071)
[    0.001409] pid_max: default: 32768 minimum: 301
[    0.001573] Security Framework initialized
[    0.001714] AppArmor: AppArmor disabled by boot time parameter
[    0.002292] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004884] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.006049] Mount-cache hash table entries: 256
[    0.006403] Initializing cgroup subsys cpuacct
[    0.006538] Initializing cgroup subsys devices
[    0.006673] Initializing cgroup subsys freezer
[    0.006805] Initializing cgroup subsys net_cls
[    0.006938] Initializing cgroup subsys blkio
[    0.007002] Initializing cgroup subsys perf_event
[    0.007164] tseg: 0000000000
[    0.007177] CPU: Physical Processor ID: 0
[    0.007308] CPU: Processor Core ID: 0
[    0.007441] mce: CPU supports 5 MCE banks
[    0.007577] LVT offset 0 assigned for vector 0xf9
[    0.007714] process: using AMD E400 aware idle routine
[    0.007849] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.007849] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.007849] tlb_flushall_shift: 4
[    0.008093] Freeing SMP alternatives: 24k freed
[    0.009235] ACPI: Core revision 20120711
[    0.012577] ftrace: allocating 19853 entries in 78 pages
[    0.019905] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030123] smpboot: CPU0: Dual-Core AMD Opteron(tm) Processor 1216 HE stepping 03
[    0.030995] Performance Events: AMD PMU driver.
[    0.030995] ... version:                0
[    0.030995] ... bit width:              48
[    0.030995] ... generic registers:      4
[    0.030995] ... value mask:             0000ffffffffffff
[    0.030995] ... max period:             00007fffffffffff
[    0.030995] ... fixed-purpose events:   0
[    0.030995] ... event mask:             000000000000000f
[    0.031446] MCE: In-kernel MCE decoding enabled.
[    0.031636] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.032089] smpboot: Booting Node   0, Processors  #1 OK
[    0.103101] Brought up 2 CPUs
[    0.103233] smpboot: Total of 2 processors activated (9575.17 BogoMIPS)
[    0.105175] NET: Registered protocol family 16
[    0.105743] node 0 link 0: io port [1000, ffffff]
[    0.105746] TOM: 00000000ee000000 aka 3808M
[    0.105879] node 0 link 0: mmio [a0000, bffff]
[    0.105882] node 0 link 0: mmio [ee000000, ffe0ffff]
[    0.105885] TOM2: 0000000112000000 aka 4384M
[    0.105988] bus: [bus 00-ff] on node 0 link 0
[    0.105990] bus: 00 [io  0x0000-0xffff]
[    0.105991] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.105993] bus: 00 [mem 0xee000000-0xffffffff]
[    0.105994] bus: 00 [mem 0x112000000-0xfcffffffff]
[    0.106044] ACPI: bus type pci registered
[    0.106351] dca service started, version 1.12.1
[    0.106519] PCI: Using configuration type 1 for base access
[    0.112899] bio: create slab <bio-0> at 0
[    0.113174] ACPI: Added _OSI(Module Device)
[    0.113312] ACPI: Added _OSI(Processor Device)
[    0.113446] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.113579] ACPI: Added _OSI(Processor Aggregator Device)
[    0.114631] ACPI: EC: Look up EC in DSDT
[    0.115783] ACPI: Executed 1 blocks of module-level executable AML code
[    0.117530] ACPI: Interpreter enabled
[    0.117661] ACPI: (supports S0 S5)
[    0.117895] ACPI: Using IOAPIC for interrupt routing
[    0.126544] ACPI: No dock devices found.
[    0.126682] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.127024] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.127319] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.127321] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.127324] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.127326] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.127329] pci_root PNP0A03:00: host bridge window [mem 0xee000000-0xffffffff] (ignored)
[    0.127331] PCI: root bus 00: hardware-probed resources
[    0.127337] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.127617] PCI host bridge to bus 0000:00
[    0.127747] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.127750] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.127884] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.127983] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.128121] pci_bus 0000:00: root bus resource [mem 0xee000000-0xffffffff]
[    0.128259] pci_bus 0000:00: root bus resource [mem 0x112000000-0xfcffffffff]
[    0.128412] pci 0000:00:01.0: [1166:0036] type 01 class 0x060400
[    0.128435] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.128597] pci 0000:00:02.0: [1166:0205] type 00 class 0x060000
[    0.128638] pci 0000:00:02.1: [1166:0214] type 00 class 0x01018a
[    0.128649] pci 0000:00:02.1: reg 10: [io  0x01f0-0x01f7]
[    0.128657] pci 0000:00:02.1: reg 14: [io  0x03f4-0x03f7]
[    0.128666] pci 0000:00:02.1: reg 18: [io  0x0170-0x0177]
[    0.128674] pci 0000:00:02.1: reg 1c: [io  0x0374-0x0377]
[    0.128683] pci 0000:00:02.1: reg 20: [io  0xffa0-0xffaf]
[    0.128711] pci 0000:00:02.2: [1166:0234] type 00 class 0x060100
[    0.128778] pci 0000:00:03.0: [1166:0223] type 00 class 0x0c0310
[    0.128793] pci 0000:00:03.0: reg 10: [mem 0xff6ee000-0xff6eefff]
[    0.128802] pci 0000:00:03.0: reg 14: [io  0xe800-0xe8ff]
[    0.128869] pci 0000:00:03.1: [1166:0223] type 00 class 0x0c0310
[    0.128884] pci 0000:00:03.1: reg 10: [mem 0xff6ed000-0xff6edfff]
[    0.128893] pci 0000:00:03.1: reg 14: [io  0xd800-0xd8ff]
[    0.129034] pci 0000:00:03.2: [1166:0223] type 00 class 0x0c0320
[    0.129049] pci 0000:00:03.2: reg 10: [mem 0xff6ec000-0xff6ecfff]
[    0.129058] pci 0000:00:03.2: reg 14: [io  0xd400-0xd4ff]
[    0.129114] pci 0000:00:03.2: supports D1 D2
[    0.129116] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.129140] pci 0000:00:05.0: [1002:515e] type 00 class 0x030000
[    0.129154] pci 0000:00:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.129163] pci 0000:00:05.0: reg 14: [io  0xe000-0xe0ff]
[    0.129172] pci 0000:00:05.0: reg 18: [mem 0xff6f0000-0xff6fffff]
[    0.129200] pci 0000:00:05.0: reg 30: [mem 0xff6c0000-0xff6dffff pref]
[    0.129224] pci 0000:00:05.0: supports D1 D2
[    0.129250] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.129266] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.129280] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.129294] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.129328] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-ff]
[    0.129342] pci 0000:01:0d.0: [1166:0104] type 01 class 0x060400
[    0.129377] pci 0000:01:0e.0: [1166:024b] type 00 class 0x01018f
[    0.129386] pci 0000:01:0e.0: reg 10: [io  0xbc00-0xbc07]
[    0.129391] pci 0000:01:0e.0: reg 14: [io  0xb880-0xb883]
[    0.129397] pci 0000:01:0e.0: reg 18: [io  0xb800-0xb807]
[    0.129403] pci 0000:01:0e.0: reg 1c: [io  0xb480-0xb483]
[    0.129408] pci 0000:01:0e.0: reg 20: [io  0xb400-0xb40f]
[    0.129414] pci 0000:01:0e.0: reg 24: [mem 0xff5fe000-0xff5fffff]
[    0.129420] pci 0000:01:0e.0: reg 30: [mem 0xff5c0000-0xff5dffff pref]
[    0.129452] pci 0000:01:0e.1: [1166:024b] type 00 class 0x01018f
[    0.129461] pci 0000:01:0e.1: reg 10: [io  0xb080-0xb087]
[    0.129467] pci 0000:01:0e.1: reg 14: [io  0xb000-0xb003]
[    0.129473] pci 0000:01:0e.1: reg 18: [io  0xac00-0xac07]
[    0.129478] pci 0000:01:0e.1: reg 1c: [io  0xa880-0xa883]
[    0.129484] pci 0000:01:0e.1: reg 20: [io  0xa800-0xa80f]
[    0.129526] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.129662] pci 0000:00:01.0:   bridge window [io  0x7000-0xbfff]
[    0.129665] pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff5fffff]
[    0.129670] pci 0000:00:01.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.129680] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.129696] pci 0000:02:01.0: [1000:0054] type 00 class 0x010000
[    0.129713] pci 0000:02:01.0: reg 10: [io  0x9000-0x90ff]
[    0.129725] pci 0000:02:01.0: reg 14: [mem 0xff4fc000-0xff4fffff 64bit]
[    0.129737] pci 0000:02:01.0: reg 1c: [mem 0xff4e0000-0xff4effff 64bit]
[    0.129752] pci 0000:02:01.0: reg 30: [mem 0xff200000-0xff3fffff pref]
[    0.129788] pci 0000:02:01.0: supports D1 D2
[    0.129814] pci 0000:02:03.0: [14e4:1648] type 00 class 0x020000
[    0.129832] pci 0000:02:03.0: reg 10: [mem 0xff4d0000-0xff4dffff 64bit]
[    0.129904] pci 0000:02:03.0: PME# supported from D3hot D3cold
[    0.129928] pci 0000:02:03.1: [14e4:1648] type 00 class 0x020000
[    0.129946] pci 0000:02:03.1: reg 10: [mem 0xff4c0000-0xff4cffff 64bit]
[    0.130033] pci 0000:02:03.1: PME# supported from D3hot D3cold
[    0.130074] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.130210] pci 0000:01:0d.0:   bridge window [io  0x7000-0x9fff]
[    0.130214] pci 0000:01:0d.0:   bridge window [mem 0xff000000-0xff4fffff]
[    0.130218] pci 0000:01:0d.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.130228] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.130302] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.130332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
[    0.130388]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.130601]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.132735] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.133682] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.134724] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.135773] ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 *10 11 12 14 15)
[    0.136721] ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 *9 10 11 12 14 15)
[    0.137695] ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.138774] ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.139823] ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.140870] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 *5 6 7 9 10 11 12 14 15)
[    0.141821] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 *7 9 10 11 12 14 15)
[    0.143032] ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.144427] ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.145482] ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.146530] ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.147626] ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.148672] ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.149722] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.150773] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.151819] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.152873] ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.153919] ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.155011] ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.156032] ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.157032] ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.158153] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.159205] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.160253] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.161303] ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.162303] ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.163422] ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.164475] ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.165543] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.165893] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
[    0.166332] vgaarb: device added: PCI:0000:00:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.166551] vgaarb: loaded
[    0.166679] vgaarb: bridge control possible 0000:00:05.0
[    0.167059] SCSI subsystem initialized
[    0.167199] ACPI: bus type usb registered
[    0.167412] usbcore: registered new interface driver usbfs
[    0.167588] usbcore: registered new interface driver hub
[    0.167783] usbcore: registered new device driver usb
[    0.168071] PCI: Using ACPI for IRQ routing
[    0.168207] PCI: pci_cache_line_size set to 64 bytes
[    0.168265] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.168267] e820: reserve RAM buffer [mem 0xedff0000-0xefffffff]
[    0.168269] e820: reserve RAM buffer [mem 0x112000000-0x113ffffff]
[    0.176838] pnp: PnP ACPI init
[    0.177014] ACPI: bus type pnp registered
[    0.177295] pnp 00:00: [bus 00-ff]
[    0.177298] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.177301] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.177303] pnp 00:00: [io  0x0d00-0xffff window]
[    0.177305] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.177308] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.177310] pnp 00:00: [mem 0xee000000-0xffffffff window]
[    0.177408] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.177434] pnp 00:01: [dma 4]
[    0.177437] pnp 00:01: [io  0x0000-0x000f]
[    0.177439] pnp 00:01: [io  0x0081-0x0083]
[    0.177441] pnp 00:01: [io  0x0087]
[    0.177443] pnp 00:01: [io  0x0089-0x008b]
[    0.177445] pnp 00:01: [io  0x008f]
[    0.177447] pnp 00:01: [io  0x00c0-0x00df]
[    0.177503] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.177511] pnp 00:02: [io  0x0070-0x0071]
[    0.177522] pnp 00:02: [irq 8]
[    0.177578] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.177610] pnp 00:03: [io  0x0060]
[    0.177612] pnp 00:03: [io  0x0064]
[    0.177617] pnp 00:03: [irq 1]
[    0.177677] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.177732] pnp 00:04: [irq 12]
[    0.177789] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.177794] pnp 00:05: [io  0x0061]
[    0.177851] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.177857] pnp 00:06: [io  0x00f0-0x00ff]
[    0.177862] pnp 00:06: [irq 13]
[    0.177918] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.178293] pnp 00:07: [io  0x03f0-0x03f5]
[    0.178296] pnp 00:07: [io  0x03f7]
[    0.178300] pnp 00:07: [irq 6]
[    0.178302] pnp 00:07: [dma 2]
[    0.178388] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.178677] pnp 00:08: [io  0x03f8-0x03ff]
[    0.178682] pnp 00:08: [irq 4]
[    0.178685] pnp 00:08: [dma 0 disabled]
[    0.178783] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.179080] pnp 00:09: [io  0x02f8-0x02ff]
[    0.179085] pnp 00:09: [irq 3]
[    0.179087] pnp 00:09: [dma 0 disabled]
[    0.179208] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.179700] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.179703] pnp 00:0a: [io  0x0600-0x061f]
[    0.179705] pnp 00:0a: [io  0x0520-0x053f]
[    0.179707] pnp 00:0a: [io  0x0540-0x054f]
[    0.179709] pnp 00:0a: [io  0x0544-0x0553]
[    0.179711] pnp 00:0a: [io  0x0550-0x055f]
[    0.179713] pnp 00:0a: [io  0x0640-0x065f]
[    0.179715] pnp 00:0a: [io  0x0800-0x080f]
[    0.179717] pnp 00:0a: [io  0x0aa0-0x0abf]
[    0.179719] pnp 00:0a: [io  0x0ac0-0x0adf]
[    0.179722] pnp 00:0a: [io  0x0ae0-0x0aff]
[    0.179811] system 00:0a: [io  0x0600-0x061f] has been reserved
[    0.179948] system 00:0a: [io  0x0520-0x053f] has been reserved
[    0.179995] system 00:0a: [io  0x0540-0x054f] has been reserved
[    0.180132] system 00:0a: [io  0x0544-0x0553] could not be reserved
[    0.180269] system 00:0a: [io  0x0550-0x055f] has been reserved
[    0.180408] system 00:0a: [io  0x0640-0x065f] has been reserved
[    0.180544] system 00:0a: [io  0x0800-0x080f] has been reserved
[    0.180680] system 00:0a: [io  0x0aa0-0x0abf] has been reserved
[    0.180815] system 00:0a: [io  0x0ac0-0x0adf] has been reserved
[    0.180975] system 00:0a: [io  0x0ae0-0x0aff] has been reserved
[    0.181114] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.181192] pnp 00:0b: [io  0x0010-0x001f]
[    0.181194] pnp 00:0b: [io  0x0022-0x003f]
[    0.181196] pnp 00:0b: [io  0x0044-0x005f]
[    0.181198] pnp 00:0b: [io  0x0062-0x0063]
[    0.181200] pnp 00:0b: [io  0x0065-0x006f]
[    0.181202] pnp 00:0b: [io  0x0072-0x007f]
[    0.181204] pnp 00:0b: [io  0x0080]
[    0.181207] pnp 00:0b: [io  0x0084-0x0086]
[    0.181209] pnp 00:0b: [io  0x0088]
[    0.181211] pnp 00:0b: [io  0x008c-0x008e]
[    0.181213] pnp 00:0b: [io  0x0090-0x009f]
[    0.181215] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.181217] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.181220] pnp 00:0b: [io  0x0092]
[    0.181222] pnp 00:0b: [io  0x040b]
[    0.181224] pnp 00:0b: [io  0x04d6]
[    0.181226] pnp 00:0b: [io  0x0c06-0x0c07]
[    0.181228] pnp 00:0b: [io  0x0c49]
[    0.181230] pnp 00:0b: [io  0x0c4a]
[    0.181232] pnp 00:0b: [io  0x0c6f]
[    0.181234] pnp 00:0b: [io  0x0c98]
[    0.181237] pnp 00:0b: [io  0x0f50-0x0f57]
[    0.181239] pnp 00:0b: [io  0x0c00-0x0c01]
[    0.181241] pnp 00:0b: [io  0x0c14]
[    0.181243] pnp 00:0b: [io  0x0c50-0x0c51]
[    0.181245] pnp 00:0b: [io  0x0c52]
[    0.181247] pnp 00:0b: [io  0x0c6c]
[    0.181249] pnp 00:0b: [io  0x0c6f]
[    0.181251] pnp 00:0b: [io  0x0cd6-0x0cd7]
[    0.181253] pnp 00:0b: [io  0x0cd4-0x0cd5]
[    0.181255] pnp 00:0b: [io  0x0cd8-0x0cdf]
[    0.181257] pnp 00:0b: [io  0x002e-0x002f]
[    0.181259] pnp 00:0b: [io  0x0530-0x0531]
[    0.181261] pnp 00:0b: [io  0x0440-0x045f]
[    0.181263] pnp 00:0b: [io  0x0480-0x049f]
[    0.181266] pnp 00:0b: [io  0x04c0-0x04df]
[    0.181268] pnp 00:0b: [io  0x0500-0x051f]
[    0.181270] pnp 00:0b: [io  0x0540-0x055f]
[    0.181272] pnp 00:0b: [io  0x0560-0x057f]
[    0.181274] pnp 00:0b: [io  0x0580-0x058f]
[    0.181276] pnp 00:0b: [io  0x0590-0x05ff]
[    0.181278] pnp 00:0b: [io  0x0660-0x06df]
[    0.181281] pnp 00:0b: [io  0x06e0-0x075f]
[    0.181284] pnp 00:0b: [io  0x0760-0x07ff]
[    0.181286] pnp 00:0b: [io  0x0ca8-0x0cab]
[    0.181288] pnp 00:0b: [io  0x0cac-0x0caf]
[    0.181290] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.181292] pnp 00:0b: [io  0x0500-0x057f]
[    0.181294] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.181297] pnp 00:0b: [mem 0xfebfe000-0xfebfefff]
[    0.181299] pnp 00:0b: [mem 0xff600000-0xffffffff]
[    0.181550] system 00:0b: [io  0x040b] has been reserved
[    0.181591] system 00:0b: [io  0x04d6] has been reserved
[    0.181726] system 00:0b: [io  0x0c06-0x0c07] has been reserved
[    0.181862] system 00:0b: [io  0x0c49] has been reserved
[    0.181987] system 00:0b: [io  0x0c4a] has been reserved
[    0.182123] system 00:0b: [io  0x0c6f] has been reserved
[    0.182258] system 00:0b: [io  0x0c98] has been reserved
[    0.182394] system 00:0b: [io  0x0f50-0x0f57] has been reserved
[    0.182530] system 00:0b: [io  0x0c00-0x0c01] has been reserved
[    0.182665] system 00:0b: [io  0x0c14] has been reserved
[    0.182800] system 00:0b: [io  0x0c50-0x0c51] has been reserved
[    0.182974] system 00:0b: [io  0x0c52] has been reserved
[    0.183110] system 00:0b: [io  0x0c6c] has been reserved
[    0.183245] system 00:0b: [io  0x0c6f] has been reserved
[    0.183381] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
[    0.183517] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
[    0.183652] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
[    0.183790] system 00:0b: [io  0x0530-0x0531] has been reserved
[    0.183974] system 00:0b: [io  0x0440-0x045f] has been reserved
[    0.184114] system 00:0b: [io  0x0480-0x049f] has been reserved
[    0.184250] system 00:0b: [io  0x04c0-0x04df] could not be reserved
[    0.184387] system 00:0b: [io  0x0500-0x051f] has been reserved
[    0.184523] system 00:0b: [io  0x0540-0x055f] could not be reserved
[    0.184659] system 00:0b: [io  0x0560-0x057f] has been reserved
[    0.184794] system 00:0b: [io  0x0580-0x058f] has been reserved
[    0.184930] system 00:0b: [io  0x0590-0x05ff] has been reserved
[    0.184974] system 00:0b: [io  0x0660-0x06df] has been reserved
[    0.185111] system 00:0b: [io  0x06e0-0x075f] has been reserved
[    0.185247] system 00:0b: [io  0x0760-0x07ff] has been reserved
[    0.185384] system 00:0b: [io  0x0ca8-0x0cab] has been reserved
[    0.185520] system 00:0b: [io  0x0cac-0x0caf] has been reserved
[    0.185656] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.185792] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    0.185975] system 00:0b: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.186115] system 00:0b: [mem 0xff600000-0xffffffff] could not be reserved
[    0.186253] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.186319] pnp 00:0c: [mem 0xfec00000-0xfec00fff]
[    0.186322] pnp 00:0c: [mem 0xfee00000-0xfee00fff]
[    0.186481] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.186528] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.186666] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.186777] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.186779] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.186781] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.186784] pnp 00:0d: [mem 0x00100000-0xedffffff]
[    0.186786] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.186948] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.186981] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.187120] system 00:0d: [mem 0x00100000-0xedffffff] could not be reserved
[    0.187259] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.188031] pnp: PnP ACPI: found 14 devices
[    0.188165] ACPI: ACPI bus type pnp unregistered
[    0.196248] Switching to clocksource acpi_pm
[    0.196428] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.196563] pci 0000:01:0d.0:   bridge window [io  0x7000-0x9fff]
[    0.196700] pci 0000:01:0d.0:   bridge window [mem 0xff000000-0xff4fffff]
[    0.196838] pci 0000:01:0d.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.196838] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.196838] pci 0000:00:01.0:   bridge window [io  0x7000-0xbfff]
[    0.196956] pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff5fffff]
[    0.197143] pci 0000:00:01.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.197367] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.197370] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.197372] pci_bus 0000:00: resource 6 [mem 0xee000000-0xffffffff]
[    0.197375] pci_bus 0000:00: resource 7 [mem 0x112000000-0xfcffffffff]
[    0.197378] pci_bus 0000:01: resource 0 [io  0x7000-0xbfff]
[    0.197380] pci_bus 0000:01: resource 1 [mem 0xff000000-0xff5fffff]
[    0.197383] pci_bus 0000:01: resource 2 [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.197386] pci_bus 0000:02: resource 0 [io  0x7000-0x9fff]
[    0.197388] pci_bus 0000:02: resource 1 [mem 0xff000000-0xff4fffff]
[    0.197391] pci_bus 0000:02: resource 2 [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.197435] NET: Registered protocol family 2
[    0.198284] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.202390] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.203106] TCP: Hash tables configured (established 524288 bind 65536)
[    0.203297] TCP: reno registered
[    0.203436] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.203610] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.203848] NET: Registered protocol family 1
[    0.204085] RPC: Registered named UNIX socket transport module.
[    0.204223] RPC: Registered udp transport module.
[    0.204356] RPC: Registered tcp transport module.
[    0.204487] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.204680] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    0.339043] pci 0000:00:05.0: Boot video device
[    0.339069] PCI: CLS 64 bytes, default 64
[    0.339112] Trying to unpack rootfs image as initramfs...
[    0.591216] Freeing initrd memory: 11136k freed
[    0.598247] PCI-DMA: Disabling AGP.
[    0.598476] PCI-DMA: aperture base @ e4000000 size 65536 KB
[    0.598610] PCI-DMA: using GART IOMMU.
[    0.598742] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.603367] audit: initializing netlink socket (disabled)
[    0.603519] type=2000 audit(1347632887.602:1): initialized
[    0.621810] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.622703] VFS: Disk quotas dquot_6.5.2
[    0.622859] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.623212] NFS: Registering the id_resolver key type
[    0.623360] Key type id_resolver registered
[    0.623491] Key type id_legacy registered
[    0.623624] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.624070] msgmni has been set to 7922
[    0.624443] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.624681] io scheduler noop registered
[    0.624814] io scheduler deadline registered
[    0.624955] io scheduler cfq registered (default)
[    0.625383] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.625599] ACPI: Power Button [PWRB]
[    0.625804] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.626032] ACPI: Sleep Button [SLPB]
[    0.626230] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.626441] ACPI: Power Button [PWRF]
[    0.626653] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input3
[    0.626865] ACPI: Sleep Button [SLPF]
[    0.627126] ACPI: processor limited to max C-state 1
[    0.627462] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.650826] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.671591] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.692370] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.713489] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.734307] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.734784] Real Time Clock Driver v1.12b
[    0.735098] Linux agpgart interface v0.103
[    0.737409] brd: module loaded
[    0.738659] loop: module loaded
[    0.738790] Uniform Multi-Platform E-IDE driver
[    0.739033] serverworks 0000:00:02.1: IDE controller (0x1166:0x0214 rev 0x00)
[    0.739193] serverworks 0000:00:02.1: not 100% native mode: will probe irqs later
[    0.741071]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.741212] Probing IDE interface ide0...
[    1.716012] hdb: CD-224E-R, ATAPI CD/DVD-ROM drive
[    1.716297] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.716969] hdb: UDMA/33 mode selected
[    1.728165] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.728710] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.728927] ide-gd driver 1.18
[    1.729116] ide-cd driver 5.00
[    1.740021] ide-cd: hdb: ATAPI 24X CD-ROM drive, 90kB Cache
[    1.740356] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.786669] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.786805] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.787142] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.787340] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    1.787539] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
[    1.808026] ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6ec000
[    1.814014] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    1.814296] hub 1-0:1.0: USB hub found
[    1.814430] hub 1-0:1.0: 4 ports detected
[    1.814650] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.814828] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    1.815034] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
[    1.815258] ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6ee000
[    1.870156] hub 2-0:1.0: USB hub found
[    1.870292] hub 2-0:1.0: 2 ports detected
[    1.870485] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    1.870672] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
[    1.870895] ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6ed000
[    1.926147] hub 3-0:1.0: USB hub found
[    1.926284] hub 3-0:1.0: 2 ports detected
[    1.926485] uhci_hcd: USB Universal Host Controller Interface driver
[    1.926721] usbcore: registered new interface driver usblp
[    1.926960] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.929672] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.929809] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.930085] mousedev: PS/2 mouse device common for all mice
[    1.930523] cpuidle: using governor ladder
[    1.931868] usbcore: registered new interface driver usbhid
[    1.932015] usbhid: USB HID core driver
[    1.932236] TCP: cubic registered
[    1.932367] NET: Registered protocol family 17
[    1.932524] Key type dns_resolver registered
[    1.933071] registered taskstats version 1
[    1.933677] console [netcon0] enabled
[    1.933808] netconsole: network logging started
[    1.933944] powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 1216 HE (2 cpu cores) (version 2.20.00)
[    1.934190] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    1.934190] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    1.935986] Freeing unused kernel memory: 896k freed
[    1.960833] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.972470] ACPI: bus type scsi registered
[    1.972782] libata version 3.00 loaded.
[    1.973597] sata_svw 0000:01:0e.0: version 2.3
[    1.974368] scsi0 : sata_svw
[    1.974627] scsi1 : sata_svw
[    1.974866] scsi2 : sata_svw
[    1.975117] scsi3 : sata_svw
[    1.975745] ata1: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe000 irq 11
[    1.975956] ata2: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe100 irq 11
[    1.976198] ata3: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe200 irq 11
[    1.976408] ata4: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe300 irq 11
[    2.291358] ata1: SATA link down (SStatus 4 SControl 300)
[    2.606357] ata2: SATA link down (SStatus 4 SControl 300)
[    2.921355] ata3: SATA link down (SStatus 4 SControl 300)
[    3.108678] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
[    3.236355] ata4: SATA link down (SStatus 4 SControl 300)
[    3.240245] Fusion MPT base driver 3.04.20
[    3.240382] Copyright (c) 1999-2008 LSI Corporation
[    3.245950] Fusion MPT SAS Host driver 3.04.20
[    3.246259] mptbase: ioc0: Initiating bringup
[    3.524010] ioc0: LSISAS1068 B0: Capabilities={Initiator}
[   25.211059] scsi4 : ioc0: LSISAS1068 B0, FwRev=011e0000h, Ports=1, MaxQ=277, IRQ=20
[   25.252428] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c500070dc515
[   25.253712] scsi 4:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.256199] sd 4:0:0:0: Attached scsi generic sg0 type 0
[   25.259269] sd 4:0:0:0: [sda] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.259893] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1, sas_addr 0x5000c500070dac45
[   25.261171] scsi 4:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.261684] sd 4:0:0:0: [sda] Write Protect is off
[   25.261820] sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
[   25.263600] sd 4:0:1:0: Attached scsi generic sg1 type 0
[   25.266152] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.266884] sd 4:0:1:0: [sdb] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.267512] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 2, phy 2, sas_addr 0x5000c500070dc391
[   25.270691] scsi 4:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.271299] sd 4:0:1:0: [sdb] Write Protect is off
[   25.271435] sd 4:0:1:0: [sdb] Mode Sense: b3 00 10 08
[   25.273157] sd 4:0:2:0: Attached scsi generic sg2 type 0
[   25.275715] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.276443] sd 4:0:2:0: [sdc] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.277072] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 3, phy 3, sas_addr 0x5000c500070daf29
[   25.277305]  sda: sda1 sda2 sda3
[   25.282343] scsi 4:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.282354] sd 4:0:2:0: [sdc] Write Protect is off
[   25.282357] sd 4:0:2:0: [sdc] Mode Sense: b3 00 10 08
[   25.284059] sd 4:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.284933] sd 4:0:3:0: Attached scsi generic sg3 type 0
[   25.289465] sd 4:0:0:0: [sda] Attached SCSI disk
[   25.289938] sd 4:0:3:0: [sdd] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.290568] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 4, phy 4, sas_addr 0x5000c500070dc0c1
[   25.290592]  sdb: sdb1 sdb2
[   25.293618] sd 4:0:3:0: [sdd] Write Protect is off
[   25.293753] sd 4:0:3:0: [sdd] Mode Sense: b3 00 10 08
[   25.293976] scsi 4:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.295553] sd 4:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.296423] sd 4:0:4:0: Attached scsi generic sg4 type 0
[   25.300939] sd 4:0:1:0: [sdb] Attached SCSI disk
[   25.301464] sd 4:0:4:0: [sde] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.302071] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 5, phy 5, sas_addr 0x5000c500070daa9d
[   25.303233]  sdc: sdc1 sdc2 sdc3
[   25.303379] scsi 4:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.303881] sd 4:0:4:0: [sde] Write Protect is off
[   25.304031] sd 4:0:4:0: [sde] Mode Sense: b3 00 10 08
[   25.307716] sd 4:0:4:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.307780]  sdd: sdd1 sdd2
[   25.308235] sd 4:0:5:0: Attached scsi generic sg5 type 0
[   25.315488] sd 4:0:5:0: [sdf] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.316116] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 7, phy 6, sas_addr 0x5000c500070dc1e5
[   25.316975] sd 4:0:2:0: [sdc] Attached SCSI disk
[   25.317542] scsi 4:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.318012] sd 4:0:5:0: [sdf] Write Protect is off
[   25.318148] sd 4:0:5:0: [sdf] Mode Sense: b3 00 10 08
[   25.319969] sd 4:0:6:0: Attached scsi generic sg6 type 0
[   25.322519] sd 4:0:3:0: [sdd] Attached SCSI disk
[   25.322567] sd 4:0:5:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.322727]  sde: sde1
[   25.322862] sd 4:0:6:0: [sdg] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.326434] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 8, phy 7, sas_addr 0x5000c5000128ff31
[   25.329247] scsi 4:0:7:0: Direct-Access     SEAGATE  ST373455SS       0004 PQ: 0 ANSI: 5
[   25.329525] sd 4:0:6:0: [sdg] Write Protect is off
[   25.329667] sd 4:0:6:0: [sdg] Mode Sense: b3 00 10 08
[   25.331646] sd 4:0:7:0: Attached scsi generic sg7 type 0
[   25.332188] sd 4:0:6:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.334427] sd 4:0:4:0: [sde] Attached SCSI disk
[   25.334919] sd 4:0:7:0: [sdh] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.335853]  sdf: sdf1
[   25.340708] sd 4:0:7:0: [sdh] Write Protect is off
[   25.340844] sd 4:0:7:0: [sdh] Mode Sense: b3 00 10 08
[   25.342414] sd 4:0:7:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.345673]  sdg: sdg1
[   25.346265] sd 4:0:5:0: [sdf] Attached SCSI disk
[   25.350541]  sdh: sdh1
[   25.355375] sd 4:0:6:0: [sdg] Attached SCSI disk
[   25.359018] sd 4:0:7:0: [sdh] Attached SCSI disk
[   25.383698] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   25.390053] fuse init (API version 7.20)
[   25.402397] md: linear personality registered for level -1
[   25.407525] md: raid0 personality registered for level 0
[   25.410773] md: raid1 personality registered for level 1
[   25.413484] async_tx: api initialized (async)
[   25.414301] xor: automatically using best checksumming function:
[   25.424009]    generic_sse:  7324.000 MB/sec
[   25.444020] raid6: sse2x1    3402 MB/s
[   25.461013] raid6: sse2x2    4421 MB/s
[   25.478015] raid6: sse2x4    4558 MB/s
[   25.478146] raid6: using algorithm sse2x4 (4558 MB/s)
[   25.478278] raid6: using intx1 recovery algorithm
[   25.481052] md: raid6 personality registered for level 6
[   25.481192] md: raid5 personality registered for level 5
[   25.481325] md: raid4 personality registered for level 4
[   25.508104] udevd (1599): /proc/1599/oom_adj is deprecated, please use /proc/1599/oom_score_adj instead.
[   25.748905] tg3.c:v3.124 (March 21, 2012)
[   25.755497] tg3 0000:02:03.0: eth0: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:30:48:63:8b:6e
[   25.755723] tg3 0000:02:03.0: eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   25.755942] tg3 0000:02:03.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[   25.756170] tg3 0000:02:03.0: eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
[   25.764577] tg3 0000:02:03.1: eth1: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:30:48:63:8b:6f
[   25.764801] tg3 0000:02:03.1: eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   25.765031] tg3 0000:02:03.1: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   25.765244] tg3 0000:02:03.1: eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
[   25.804924] EDAC MC: Ver: 3.0.0
[   25.805151] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   25.811560] piix4_smbus 0000:00:02.0: SMBus Host Controller at 0x580, revision 0
[   25.821586] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   25.828768] AMD64 EDAC driver v3.4.0
[   25.836649] EDAC amd64: DRAM ECC enabled.
[   25.836788] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
[   25.836791] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x1f, NB MSR is enabled
[   25.836793] EDAC amd64: K8 revF or later detected (node 0).
[   25.836933] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   25.836935] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   25.836936] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   25.836938] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000ee000000
[   25.836939] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000112000000
[   25.836942] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x0000000111ffffff
[   25.836945] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   25.836949] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
[   25.836951] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000101 reg: F2x44
[   25.836953] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000201 reg: F2x48
[   25.836955] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000301 reg: F2x4c
[   25.836957] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   25.836959] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   25.836961] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
[   25.836963] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
[   25.836965] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00f83ce0 reg: F2x60
[   25.836967] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   25.836969] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   25.836971] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
[   25.836974] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x00001719
[   25.836975] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   25.836977] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   25.836978] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090810
[   25.836980] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
[   25.836981] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
[   25.836983] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   25.836985] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x0f000000
[   25.836986] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xee001201, base: 0xee000000, offset: 0x12000000
[   25.836988] EDAC DEBUG: dump_misc_regs:   DramHoleValid: yes
[   25.836990] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000022
[   25.836991] EDAC MC: DCT0 chip selects:
[   25.836993] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[   25.837166] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   25.837298] EDAC amd64: MC: 4:     0MB 5:     0MB
[   25.837429] EDAC amd64: MC: 6:     0MB 7:     0MB
[   25.837563] EDAC DEBUG: edac_mc_alloc: allocating 1160 bytes for mci data (16 ranks, 16 csrows/channels)
[   25.837586] EDAC DEBUG: init_csrows: node 0, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
[   25.837588] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
[   25.837589] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel: 0, DBAM idx: 2
[   25.837591] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.837592] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   25.837724] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
[   25.837725] DBG: init_csrows: channel_count:2
[   25.837856] DBG: init_csrows: channel_count:2
[   25.837988] EDAC DEBUG: init_csrows: MC node: 0, csrow: 1
[   25.837989] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 1, channel: 0, DBAM idx: 2
[   25.837991] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.837992] EDAC amd64: CS1: Unbuffered DDR2 RAM
[   25.838157] EDAC DEBUG: init_csrows: Total csrow1 pages: 262144
[   25.838158] DBG: init_csrows: channel_count:2
[   25.838289] DBG: init_csrows: channel_count:2
[   25.838421] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   25.838422] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, DBAM idx: 2
[   25.838424] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.838425] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   25.838556] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
[   25.838558] DBG: init_csrows: channel_count:2
[   25.838689] DBG: init_csrows: channel_count:2
[   25.838820] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
[   25.838822] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, DBAM idx: 2
[   25.838823] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.838824] EDAC amd64: CS3: Unbuffered DDR2 RAM
[   25.838957] EDAC DEBUG: init_csrows: Total csrow3 pages: 262144
[   25.838958] DBG: init_csrows: channel_count:2
[   25.839104] DBG: init_csrows: channel_count:2
[   25.839236] EDAC DEBUG: edac_mc_add_mc: 
[   25.839239] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   25.839267] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   25.839288] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm0, located at csrow 0 channel 0 
[   25.839304] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank0
[   25.839306] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm1, located at csrow 0 channel 1 
[   25.839317] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank1
[   25.839319] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm2, located at csrow 1 channel 0 
[   25.839332] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank2
[   25.839333] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm3, located at csrow 1 channel 1 
[   25.839345] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank3
[   25.839347] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm8, located at csrow 4 channel 0 
[   25.839360] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank8
[   25.839361] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm9, located at csrow 4 channel 1 
[   25.839373] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank9
[   25.839375] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm10, located at csrow 5 channel 0 
[   25.839388] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank10
[   25.839390] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm11, located at csrow 5 channel 1 
[   25.839402] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank11
[   25.839405] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow0
[   25.839419] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow1
[   25.839431] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   25.839445] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   25.839473] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
[   25.839730] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   25.839733] EDAC DEBUG: edac_pci_add_device: 
[   25.839734] EDAC DEBUG: add_edac_pci_to_global_list: 
[   25.839735] EDAC DEBUG: find_edac_pci_by_dev: 
[   25.839737] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   25.839738] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   25.839745] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   25.839746] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   25.839750] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   25.839752] EDAC DEBUG: edac_pci_workq_setup: 
[   25.839756] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   29.099082] kvm: Nested Virtualization enabled
[   29.127015] microcode: AMD CPU family 0xf not supported
[   29.890048] w83793 0-002f: Registered watchdog chardev major 10, minor: 130
[   30.078597] NET: Registered protocol family 10
[   30.079037] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   30.079198] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.805519] Adding 4192960k swap on /dev/sdc3.  Priority:-1 extents:1 across:4192960k 
[   31.194578] microcode: AMD CPU family 0xf not supported
[   31.297628] microcode: AMD CPU family 0xf not supported
[   31.975710] tg3 0000:02:03.0: eth1: Link is up at 1000 Mbps, full duplex
[   31.975853] tg3 0000:02:03.0: eth1: Flow control is off for TX and off for RX
[   31.976017] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   32.482878] tg3 0000:02:03.1: eth0: Link is up at 1000 Mbps, full duplex
[   32.483027] tg3 0000:02:03.1: eth0: Flow control is off for TX and off for RX
[   32.483170] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   33.714481] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.466788] warning: `named' uses 32-bit capabilities (legacy support in use)
[  123.974065] EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xee000000 offset 0x12000000 size 0x12000000
[  131.423949] DBG: csrow_size_show: i:0 nr_pages:262144 nr_channels:2
[  131.424112] DBG: csrow_size_show: i:1 nr_pages:524288 nr_channels:2

--------------020301070402000402020107--
