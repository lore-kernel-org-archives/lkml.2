Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2JNOTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:19:13 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:22034 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2JNOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:19:11 -0400
X-Authority-Analysis: v=2.0 cv=Q6tQEvKa c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=g7R6esmICIkA:10 a=05ChyHeVI94A:10 a=ayC55rCoAAAA:8 a=HjRi3UqH30YA:10 a=vFjhSUxfD_l3DD1Us0UA:9 a=wPNLvfGTeEIA:10 a=pSDxxfrZAAAA:8 a=nLQlSKw-LsbOH_3rRZwA:9 a=QEXdDO2ut3YA:10 a=tHNnKI-LchGHF30i:21 a=sTacVl7qMc4wdSCq:21 a=wJA3Mb_CUL-XE5Se:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507AC9DC.4030701@cfl.rr.com>
Date: Sun, 14 Oct 2012 10:19:08 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: markh@compro.net,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com> <507A91EA.2030205@cfl.rr.com> <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
In-Reply-To: <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010400050700050802060207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010400050700050802060207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/2012 07:26 AM, Daniel Vetter wrote:
> On Sun, Oct 14, 2012 at 12:20 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> Hi Daniel,
>>
>> cat /proc/cmdline
>> root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4
>> video=1024x768 noresume splash=silent quiet apm=off nomodeset vga=normal
>> drm.debug=0xe
>>
>> dmesg is attached
>
>>From the dmesg:
>
> [    1.833195] [drm:drm_pci_agp_init] *ERROR* Cannot initialize the
> agpgart module.
>
> Which is the root-cause preventing i915.ko from loading. Now with 3.7
> we /shouldn't/ all that agp crap any longer on snb/ivb, so I'm a bit
> confused why it still tries to initialize it. Can you maybe attach
> your .config?
>
> Also, we need to employ some dirty runtime tricks to no longer require
> agp on newer chips, since we still need to keep it around for
> backwards-compat with old userspace on old chips. Can you please check
> with the below diff whether this hack works?
>
> Thanks, Daniel
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index a7837e5..1152502 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -842,6 +842,7 @@ i915_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *ent)
>          if (intel_info->gen != 3) {
>                  driver.driver_features &=
>                          ~(DRIVER_USE_AGP | DRIVER_REQUIRE_AGP);
> +               printk("dropping agp requirement\n");
>          } else if (!intel_agp_enabled) {
>                  DRM_ERROR("drm/i915 can't work without intel_agp module!\n");
>                  return -ENODEV;
>

OK. Applied to 3.6.2. The dmesg is attached. The message did not show up.
I'll be here most of the day.

Mark

--------------010400050700050802060207
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-dvi2hdmi-3.6.2-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-dvi2hdmi-3.6.2-1"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.2 (root@geexbox) (gcc version 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT Sun Oct 14 02:03:31 EDT 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d9e5efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9e5f000-0x00000000da25afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da25b000-0x00000000da266fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da267000-0x00000000da2f2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da2f3000-0x00000000da2f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da2f9000-0x00000000da37afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da37b000-0x00000000da40cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da40d000-0x00000000da6a2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da6a3000-0x00000000da6a3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da6a4000-0x00000000da6e6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da6e7000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.7 present.
[    0.000000] DMI:                  /DH77DF, BIOS KCH7710H.86A.0095.2012.0608.1754 06/08/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 21F800000 mask FFF800000 uncachable
[    0.000000]   6 base 21F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000fd770-0x000fd77f] mapped at [c00fd770]
[    0.000000] initial memory mapped: [mem 0x00000000-0x00bfffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem 0x00bfa000-0x00bfffff]
[    0.000000] RAMDISK: [mem 0x1e6bc000-0x1ffeffff]
[    0.000000] ACPI: RSDP 000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT da25b070 00064 (v01 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: FACP da264db8 000F4 (v04 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: DSDT da25b168 09C49 (v02 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: FACS da40bf80 00040
[    0.000000] ACPI: APIC da264eb0 00072 (v03 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: FPDT da264f28 00044 (v01 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: MCFG da264f70 0003C (v01 INTEL  DH77DF   0000005F MSFT 00000097)
[    0.000000] ACPI: HPET da264fb0 00038 (v01 INTEL  DH77DF   0000005F AMI. 00000005)
[    0.000000] ACPI: SSDT da264fe8 0036D (v01 INTEL  DH77DF   0000005F INTL 20091112)
[    0.000000] ACPI: SSDT da265358 009AA (v01 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: SSDT da265d08 00A92 (v01 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2616MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xdaffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd9e5efff]
[    0.000000]   node   0: [mem 0xda2f9000-0xda37afff]
[    0.000000]   node   0: [mem 0xda6a3000-0xda6a3fff]
[    0.000000]   node   0: [mem 0xda6e7000-0xdaffffff]
[    0.000000] On node 0 totalpages: 894343
[    0.000000] free_area_init_node: node 0, pgdat c0894340, node_mem_map f5c9d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 220974 pages, LIFO batch:31
[    0.000000]   HighMem zone: 5233 pages used for memmap
[    0.000000]   HighMem zone: 662411 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5c5b000 s26944 r0 d22208 u49152
[    0.000000] pcpu-alloc: s26944 r0 d22208 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 887334
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 video=1024x768 noresume splash=silent quiet apm=off nomodeset vga=normal drm.debug=0xe irqpoll
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (000377fe:000db000)
[    0.000000] Memory: 3514636k/3588096k available (4577k kernel code, 62736k reserved, 2220k data, 452k init, 2670576k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc08a4000 - 0xc0915000   ( 452 kB)
[    0.000000]       .data : 0xc0678452 - 0xc08a3800   (2220 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0678452   (4577 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 3392.155 MHz processor
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6787.98 BogoMIPS (lpj=11307183)
[    0.000002] pid_max: default: 32768 minimum: 301
[    0.000015] Security Framework initialized
[    0.000024] AppArmor: AppArmor initialized
[    0.000028] Mount-cache hash table entries: 512
[    0.000135] Initializing cgroup subsys net_cls
[    0.000136] Initializing cgroup subsys blkio
[    0.000153] CPU: Physical Processor ID: 0
[    0.000154] CPU: Processor Core ID: 0
[    0.000156] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000156] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000695] mce: CPU supports 9 MCE banks
[    0.000704] CPU0: Thermal monitoring enabled (TM1)
[    0.000710] process: using mwait in idle threads
[    0.000715] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.000715] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000715] tlb_flushall_shift is 0x1
[    0.001279] ACPI: Core revision 20120711
[    0.007330] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.007742] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040649] smpboot: CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz stepping 09
[    0.146599] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.146603] ... version:                3
[    0.146604] ... bit width:              48
[    0.146604] ... generic registers:      8
[    0.146605] ... value mask:             0000ffffffffffff
[    0.146606] ... max period:             000000007fffffff
[    0.146606] ... fixed-purpose events:   3
[    0.146607] ... event mask:             00000007000000ff
[    0.193140] CPU 1 irqstacks, hard=f54b0000 soft=f54b2000
[    0.203366] Initializing CPU#1
[    0.193142] smpboot: Booting Node   0, Processors  #1
[    0.219731] CPU 2 irqstacks, hard=f54c6000 soft=f54c8000
[    0.229900] Initializing CPU#2
[    0.219734]  #2
[    0.246321] CPU 3 irqstacks, hard=f54e0000 soft=f54e2000
[    0.246324]  #3 OK
[    0.256590] Initializing CPU#3
[    0.260025] Brought up 4 CPUs
[    0.260028] smpboot: Total of 4 processors activated (27148.95 BogoMIPS)
[    0.262503] devtmpfs: initialized
[    0.262674] PM: Registering ACPI NVS region [mem 0xda37b000-0xda40cfff] (598016 bytes)
[    0.262679] PM: Registering ACPI NVS region [mem 0xda6a4000-0xda6e6fff] (274432 bytes)
[    0.262732] dummy: 
[    0.262761] RTC time: 10:13:59, date: 10/14/12
[    0.262785] NET: Registered protocol family 16
[    0.299619] ACPI: bus type pci registered
[    0.299664] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.299666] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.299666] PCI: Using MMCONFIG for extended config space
[    0.299667] PCI: Using configuration type 1 for base access
[    0.300122] bio: create slab <bio-0> at 0
[    0.300159] ACPI: Added _OSI(Module Device)
[    0.300159] ACPI: Added _OSI(Processor Device)
[    0.300160] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.300161] ACPI: Added _OSI(Processor Aggregator Device)
[    0.301489] ACPI: EC: Look up EC in DSDT
[    0.303004] ACPI: Executed 1 blocks of module-level executable AML code
[    0.313523] ACPI: SSDT da293018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.313858] ACPI: Dynamic OEM Table Load:
[    0.313860] ACPI: SSDT   (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.322988] ACPI: SSDT da294a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.323354] ACPI: Dynamic OEM Table Load:
[    0.323355] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.333140] ACPI: SSDT da299c18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.333478] ACPI: Dynamic OEM Table Load:
[    0.333479] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.343545] ACPI: Interpreter enabled
[    0.343551] ACPI: (supports S0 S3 S4 S5)
[    0.343562] ACPI: Using IOAPIC for interrupt routing
[    0.347524] ACPI: Power Resource [FN00] (off)
[    0.347573] ACPI: Power Resource [FN01] (off)
[    0.347620] ACPI: Power Resource [FN02] (off)
[    0.347669] ACPI: Power Resource [FN03] (off)
[    0.347716] ACPI: Power Resource [FN04] (off)
[    0.348073] ACPI: No dock devices found.
[    0.348076] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.348309] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.348639] PCI host bridge to bus 0000:00
[    0.348641] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
[    0.348642] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.348644] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.348645] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.348646] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.348647] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.348648] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.348649] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.348650] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.348651] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.348653] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.348654] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.348660] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.348689] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.348711] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.348729] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.348736] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.348741] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.348744] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.348787] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.348807] pci 0000:00:14.0: reg 10: [mem 0xf7d20000-0xf7d2ffff 64bit]
[    0.348871] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.348892] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.348913] pci 0000:00:16.0: reg 10: [mem 0xf7d37000-0xf7d3700f 64bit]
[    0.348984] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.349011] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.349027] pci 0000:00:19.0: reg 10: [mem 0xf7d00000-0xf7d1ffff]
[    0.349034] pci 0000:00:19.0: reg 14: [mem 0xf7d35000-0xf7d35fff]
[    0.349042] pci 0000:00:19.0: reg 18: [io  0xf080-0xf09f]
[    0.349098] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.349120] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.349139] pci 0000:00:1a.0: reg 10: [mem 0xf7d34000-0xf7d343ff]
[    0.349222] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.349248] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.349377] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.349414] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.349486] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.349511] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.349530] pci 0000:00:1d.0: reg 10: [mem 0xf7d33000-0xf7d333ff]
[    0.349613] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.349636] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.349752] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.349768] pci 0000:00:1f.2: reg 10: [io  0xf0d0-0xf0d7]
[    0.349775] pci 0000:00:1f.2: reg 14: [io  0xf0c0-0xf0c3]
[    0.349783] pci 0000:00:1f.2: reg 18: [io  0xf0b0-0xf0b7]
[    0.349790] pci 0000:00:1f.2: reg 1c: [io  0xf0a0-0xf0a3]
[    0.349797] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.349804] pci 0000:00:1f.2: reg 24: [mem 0xf7d32000-0xf7d327ff]
[    0.349844] pci 0000:00:1f.2: PME# supported from D3hot
[    0.349860] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.349873] pci 0000:00:1f.3: reg 10: [mem 0xf7d31000-0xf7d310ff 64bit]
[    0.349892] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.349930] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-3e]
[    0.349947] pci 0000:01:00.0: [10b5:8112] type 01 class 0x060400
[    0.350053] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.350060] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.350062] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.350108] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.350128] pci 0000:02:04.0: [13f6:8788] type 00 class 0x040100
[    0.350151] pci 0000:02:04.0: reg 10: [io  0xe000-0xe0ff]
[    0.350262] pci 0000:02:04.0: supports D1 D2
[    0.350313] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.350318] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.350399] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
[    0.350401] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.350453] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-3e]
[    0.350456] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.350460] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.350463] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.350482] pci_bus 0000:00: on NUMA node 0
[    0.350484] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.350571] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.350599] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.350621] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.350712]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.350852]  pci0000:00: ACPI _OSC control (0x18) granted
[    0.353707] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.353746] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.353781] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.353815] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.353851] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.353888] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.353925] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.353959] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.354001] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.354004] vgaarb: loaded
[    0.354005] vgaarb: bridge control possible 0000:00:02.0
[    0.354063] SCSI subsystem initialized
[    0.354065] ACPI: bus type scsi registered
[    0.354081] libata version 3.00 loaded.
[    0.354091] ACPI: bus type usb registered
[    0.354100] usbcore: registered new interface driver usbfs
[    0.354105] usbcore: registered new interface driver hub
[    0.354116] usbcore: registered new device driver usb
[    0.354142] PCI: Using ACPI for IRQ routing
[    0.355510] PCI: pci_cache_line_size set to 64 bytes
[    0.355558] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.355559] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.355560] e820: reserve RAM buffer [mem 0xd9e5f000-0xdbffffff]
[    0.355562] e820: reserve RAM buffer [mem 0xda37b000-0xdbffffff]
[    0.355563] e820: reserve RAM buffer [mem 0xda6a4000-0xdbffffff]
[    0.355564] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.355615] NetLabel: Initializing
[    0.355616] NetLabel:  domain hash size = 128
[    0.355616] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.355622] NetLabel:  unlabeled traffic allowed by default
[    0.355675] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.355679] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.357687] Switching to clocksource hpet
[    0.357728] AppArmor: AppArmor Filesystem Enabled
[    0.357736] pnp: PnP ACPI init
[    0.357741] ACPI: bus type pnp registered
[    0.357921] pnp 00:00: [bus 00-3e]
[    0.357923] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.357924] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.357925] pnp 00:00: [io  0x0d00-0xffff window]
[    0.357926] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.357928] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.357929] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.357930] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.357931] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.357932] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.357933] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.357935] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.357936] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.357937] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.357938] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.357939] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.357940] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.357941] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.357942] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.357943] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.357974] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.357990] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.358007] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.358009] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.358016] pnp 00:02: [io  0x0000-0x001f]
[    0.358017] pnp 00:02: [io  0x0081-0x0091]
[    0.358018] pnp 00:02: [io  0x0093-0x009f]
[    0.358019] pnp 00:02: [io  0x00c0-0x00df]
[    0.358020] pnp 00:02: [dma 4]
[    0.358032] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.358036] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.358047] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.358101] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.358112] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.358120] pnp 00:05: [io  0x002e-0x002f]
[    0.358121] pnp 00:05: [io  0x004e-0x004f]
[    0.358122] pnp 00:05: [io  0x0061]
[    0.358123] pnp 00:05: [io  0x0063]
[    0.358124] pnp 00:05: [io  0x0065]
[    0.358125] pnp 00:05: [io  0x0067]
[    0.358126] pnp 00:05: [io  0x0070]
[    0.358127] pnp 00:05: [io  0x0080]
[    0.358128] pnp 00:05: [io  0x0092]
[    0.358129] pnp 00:05: [io  0x00b2-0x00b3]
[    0.358130] pnp 00:05: [io  0x0680-0x069f]
[    0.358131] pnp 00:05: [io  0x1000-0x100f]
[    0.358131] pnp 00:05: [io  0xffff]
[    0.358132] pnp 00:05: [io  0xffff]
[    0.358133] pnp 00:05: [io  0x0400-0x0453]
[    0.358135] pnp 00:05: [io  0x0458-0x047f]
[    0.358136] pnp 00:05: [io  0x0500-0x057f]
[    0.358137] pnp 00:05: [io  0x164e-0x164f]
[    0.358157] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.358158] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.358159] system 00:05: [io  0xffff] has been reserved
[    0.358160] system 00:05: [io  0xffff] has been reserved
[    0.358162] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.358163] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.358164] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.358165] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.358167] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.358172] pnp 00:06: [io  0x0070-0x0077]
[    0.358177] pnp 00:06: [irq 8]
[    0.358188] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.358204] pnp 00:07: [io  0x0454-0x0457]
[    0.358222] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.358223] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.358278] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.358279] pnp 00:08: [io  0x0a30-0x0a3f]
[    0.358280] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.358281] pnp 00:08: [io  0x0250-0x025f]
[    0.358298] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.358299] system 00:08: [io  0x0250-0x025f] has been reserved
[    0.358301] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.358337] pnp 00:09: [io  0x0010-0x001f]
[    0.358338] pnp 00:09: [io  0x0022-0x003f]
[    0.358339] pnp 00:09: [io  0x0044-0x005f]
[    0.358340] pnp 00:09: [io  0x0062-0x0063]
[    0.358341] pnp 00:09: [io  0x0065-0x006f]
[    0.358342] pnp 00:09: [io  0x0072-0x007f]
[    0.358343] pnp 00:09: [io  0x0080]
[    0.358344] pnp 00:09: [io  0x0084-0x0086]
[    0.358345] pnp 00:09: [io  0x0088]
[    0.358346] pnp 00:09: [io  0x008c-0x008e]
[    0.358347] pnp 00:09: [io  0x0090-0x009f]
[    0.358348] pnp 00:09: [io  0x00a2-0x00bf]
[    0.358349] pnp 00:09: [io  0x00e0-0x00ef]
[    0.358350] pnp 00:09: [io  0x04d0-0x04d1]
[    0.358370] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.358372] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.358377] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.358384] pnp 00:0a: [irq 13]
[    0.358395] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.358571] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.358572] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    0.358573] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    0.358574] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    0.358575] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    0.358576] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.358577] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    0.358578] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    0.358579] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    0.358580] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    0.358581] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
[    0.358612] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.358614] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.358615] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.358616] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.358617] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.358619] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.358620] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.358621] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.358622] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.358624] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.358625] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.358626] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.358735] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.358736] pnp 00:0c: [mem 0x40004000-0x40004fff]
[    0.358768] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.358770] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.358771] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.358786] pnp: PnP ACPI: found 13 devices
[    0.358787] ACPI: ACPI bus type pnp unregistered
[    0.394097] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.394101] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.394116] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.394117] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.394121] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.394141] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.394143] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.394148] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.394180] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.394181] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.394182] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.394183] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.394184] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.394186] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.394187] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.394188] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.394189] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.394190] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.394191] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.394192] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.394194] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.394195] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.394210] NET: Registered protocol family 2
[    0.394290] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.394412] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.394465] TCP: Hash tables configured (established 131072 bind 65536)
[    0.394471] TCP: reno registered
[    0.394472] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.394474] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.394502] NET: Registered protocol family 1
[    0.394508] pci 0000:00:02.0: Boot video device
[    0.427557] PCI: CLS 64 bytes, default 64
[    0.427597] Unpacking initramfs...
[    0.727363] Freeing initrd memory: 25808k freed
[    0.729843] audit: initializing netlink socket (disabled)
[    0.729851] type=2000 audit(1350209638.626:1): initialized
[    0.740589] bounce pool size: 64 pages
[    0.740592] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.741410] VFS: Disk quotas dquot_6.5.2
[    0.741436] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.741567] msgmni has been set to 1698
[    0.741692] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.741708] io scheduler noop registered
[    0.741709] io scheduler deadline registered
[    0.741713] io scheduler cfq registered (default)
[    0.741775] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.741960] intel_idle: MWAIT substates: 0x1120
[    0.741961] intel_idle: v0.4 model 0x3A
[    0.741962] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.744699] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.745065] Non-volatile memory driver v1.3
[    0.745066] Linux agpgart interface v0.103
[    0.745139] ahci 0000:00:1f.2: version 3.0
[    0.745175] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.745197] ahci: SSS flag set, parallel bus scan disabled
[    0.756610] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x23 impl SATA mode
[    0.756614] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
[    0.756622] ahci 0000:00:1f.2: setting latency timer to 64
[    0.770128] scsi0 : ahci
[    0.770164] scsi1 : ahci
[    0.770196] scsi2 : ahci
[    0.770225] scsi3 : ahci
[    0.770254] scsi4 : ahci
[    0.770281] scsi5 : ahci
[    0.770304] ata1: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32100 irq 41
[    0.770306] ata2: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32180 irq 41
[    0.770307] ata3: DUMMY
[    0.770308] ata4: DUMMY
[    0.770308] ata5: DUMMY
[    0.770311] ata6: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32380 irq 41
[    0.770348] libphy: Fixed MDIO Bus: probed
[    0.770350] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.770368] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.770371] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.770375] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.774266] ehci_hcd 0000:00:1a.0: debug port 2
[    0.774273] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.774284] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d34000
[    0.783181] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.783201] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.783203] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.783205] usb usb1: Product: EHCI Host Controller
[    0.783208] usb usb1: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.783210] usb usb1: SerialNumber: 0000:00:1a.0
[    0.783288] hub 1-0:1.0: USB hub found
[    0.783290] hub 1-0:1.0: 2 ports detected
[    0.783334] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.783336] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.783339] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.787228] ehci_hcd 0000:00:1d.0: debug port 2
[    0.787234] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.787244] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d33000
[    0.796478] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.796492] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.796494] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.796496] usb usb2: Product: EHCI Host Controller
[    0.796499] usb usb2: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.796501] usb usb2: SerialNumber: 0000:00:1d.0
[    0.796568] hub 2-0:1.0: USB hub found
[    0.796569] hub 2-0:1.0: 2 ports detected
[    0.796602] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.796609] uhci_hcd: USB Universal Host Controller Interface driver
[    0.796616] Initializing USB Mass Storage driver...
[    0.796625] usbcore: registered new interface driver usb-storage
[    0.796626] USB Mass Storage support registered.
[    0.796629] usbcore: registered new interface driver ums-alauda
[    0.796632] usbcore: registered new interface driver ums-cypress
[    0.796636] usbcore: registered new interface driver ums-datafab
[    0.796639] usbcore: registered new interface driver ums-freecom
[    0.796642] usbcore: registered new interface driver ums-isd200
[    0.796645] usbcore: registered new interface driver ums-jumpshot
[    0.796648] usbcore: registered new interface driver ums-karma
[    0.796650] usbcore: registered new interface driver ums-onetouch
[    0.796653] usbcore: registered new interface driver ums-sddr09
[    0.796656] usbcore: registered new interface driver ums-sddr55
[    0.796659] usbcore: registered new interface driver ums-usbat
[    0.796681] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.799239] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.799245] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.799288] mousedev: PS/2 mouse device common for all mice
[    0.799336] rtc_cmos 00:06: RTC can wake from S4
[    0.799433] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.799461] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.799497] cpuidle: using governor ladder
[    0.799578] usbcore: registered new interface driver usbhid
[    0.799579] usbhid: USB HID core driver
[    0.799656] ashmem: initialized
[    0.799731] TCP: cubic registered
[    0.799795] NET: Registered protocol family 10
[    0.799886] lib80211: common routines for IEEE802.11 drivers
[    0.799887] lib80211_crypt: registered algorithm 'NULL'
[    0.799891] Key type dns_resolver registered
[    0.799893] Key type ceph registered
[    0.799896] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    0.800026] Using IPI No-Shortcut mode
[    0.800137] registered taskstats version 1
[    0.800435]   Magic number: 0:304:224
[    0.800513] rtc_cmos 00:06: setting system clock to 2012-10-14 10:13:59 UTC (1350209639)
[    1.089004] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.089014] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.098250] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.098255] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.098258] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.101014] ata1.00: ATAPI: HL-DT-ST BDDVDRW UH12LS29, 1.00, max UDMA/133
[    1.106053] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.106058] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.106061] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.108807] ata1.00: configured for UDMA/133
[    1.127630] scsi 0:0:0:0: CD-ROM            HL-DT-ST BDDVDRW UH12LS29 1.00 PQ: 0 ANSI: 5
[    1.212325] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.212329] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.212600] hub 1-1:1.0: USB hub found
[    1.212728] hub 1-1:1.0: 6 ports detected
[    1.318331] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.441665] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.441669] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.441945] hub 2-1:1.0: USB hub found
[    1.442073] hub 2-1:1.0: 8 ports detected
[    1.444641] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.446013] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.446017] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.446020] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.456431] ata2.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[    1.456436] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.465971] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.465977] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.465980] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.476387] ata2.00: configured for UDMA/133
[    1.476563] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 400i PQ: 0 ANSI: 5
[    1.127876] ACPI: Invalid Power Resource to register!
[    1.476754] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.476971] sd 1:0:0:0: [sda] Write Protect is off
[    1.476973] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.477042] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.477603]  sda: sda1 sda2 sda3 sda4
[    1.478087] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.521223] usb 1-1.2: new high-speed USB device number 3 using ehci_hcd
[    1.607602] usb 1-1.2: New USB device found, idVendor=0846, idProduct=9011
[    1.607606] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.607609] usb 1-1.2: Product: Remote Download Wireless Adapter
[    1.607611] usb 1-1.2: Manufacturer: Broadcom
[    1.607613] usb 1-1.2: SerialNumber: 0
[    1.707310] usb 2-1.6: new full-speed USB device number 3 using ehci_hcd
[    1.727156] tsc: Refined TSC clocksource calibration: 3392.304 MHz
[    1.727162] Switching to clocksource tsc
[    1.793648] ata6: SATA link down (SStatus 0 SControl 300)
[    1.793775] usb 2-1.6: New USB device found, idVendor=19ff, idProduct=0231
[    1.793777] usb 2-1.6: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.793779] usb 2-1.6: Product: Dynex wireless combo
[    1.793784] Freeing unused kernel memory: 452k freed
[    1.816507] emc: device handler registered
[    1.817410] rdac: device handler registered
[    1.818320] alua: device handler registered
[    1.819179] hp_sw: device handler registered
[    1.821576] udevd[118]: starting version 182
[    1.826651] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.826867] ACPI: Power Button [PWRB]
[    1.826899] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.826919] ACPI: Power Button [PWRF]
[    1.831800] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.831807] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.831810] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.831895] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.831902] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d20000
[    1.831945] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    1.831990] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.831992] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.831993] usb usb3: Product: xHCI Host Controller
[    1.831994] usb usb3: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.831995] usb usb3: SerialNumber: 0000:00:14.0
[    1.833291] [drm] Initialized drm 1.1.0 20060810
[    1.835925] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input2
[    1.836052] hid-generic 0003:19FF:0231.0001: input,hidraw0: USB HID v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input0
[    1.836173] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input3
[    1.836327] hid-generic 0003:19FF:0231.0002: input,hidraw1: USB HID v1.11 Mouse [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input1
[    1.837729] [drm:drm_pci_agp_init] *ERROR* Cannot initialize the agpgart module.
[    1.837788] DRM: Fill_in_dev failed.
[    1.846940] xHCI xhci_add_endpoint called for root hub
[    1.846941] xHCI xhci_check_bandwidth called for root hub
[    1.846964] hub 3-0:1.0: USB hub found
[    1.846973] hub 3-0:1.0: 4 ports detected
[    1.847015] thermal LNXTHERM:00: registered as thermal_zone0
[    1.847017] ACPI: Thermal Zone [TZ00] (28 C)
[    1.847029] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.847031] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.847053] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.847054] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.847055] usb usb4: Product: xHCI Host Controller
[    1.847056] usb usb4: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.847057] usb usb4: SerialNumber: 0000:00:14.0
[    1.847551] xHCI xhci_add_endpoint called for root hub
[    1.847553] xHCI xhci_check_bandwidth called for root hub
[    1.847609] hub 4-0:1.0: USB hub found
[    1.847619] hub 4-0:1.0: 4 ports detected
[    1.847906] thermal LNXTHERM:01: registered as thermal_zone1
[    1.847907] ACPI: Thermal Zone [TZ01] (30 C)
[    1.848033] ACPI: Fan [FAN0] (off)
[    1.848059] ACPI: Fan [FAN1] (off)
[    1.848083] ACPI: Fan [FAN2] (off)
[    1.848103] ACPI: Fan [FAN3] (off)
[    1.848121] ACPI: Fan [FAN4] (off)
[    1.925224] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    1.939850] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    2.211449] systemd-readahead-replay[270]: Bumped block_nr parameter of 8:0 to 16384. This is a temporary hack and should be removed one day.
[    2.608192] udevd[303]: starting version 182
[    2.672420] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x12
[    2.711815] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x12
[    2.712101] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x12
[    2.712310] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x12
[    2.712607] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.797184] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.806840] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    3.055851] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.056329] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.056892] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    3.056893] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    3.056917] e1000e 0000:00:19.0: setting latency timer to 64
[    3.056959] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.056989] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    3.070946] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    3.072117] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    3.072258] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.082008] kvm: disabled by bios
[    3.086166] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.086168] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.086230] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.214386] Adding 4193276k swap on /dev/sda3.  Priority:-1 extents:1 across:4193276k SS
[    3.310623] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) e8:40:f2:05:f1:85
[    3.310625] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.310671] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    1.476804] ACPI: Invalid Power Resource to register!
[    3.310749] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    3.310753] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.310756] ACPI Warning: 0x00000500-0x0000053f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[    3.310758] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.310759] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.310783] ACPI Warning: 0x0000f040-0x0000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120711/utaddress-251)
[    3.310786] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.330792] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    4.402935] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.509282] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.509376] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.750895] RPC: Registered named UNIX socket transport module.
[    4.750897] RPC: Registered udp transport module.
[    4.750898] RPC: Registered tcp transport module.
[    4.750899] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.753198] FS-Cache: Loaded
[    4.756182] FS-Cache: Netfs 'nfs' registered for caching
[    5.345150] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr,commit=0
[    5.347663] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
[    6.128311] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[    6.128315] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[    6.128350] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--------------010400050700050802060207--
