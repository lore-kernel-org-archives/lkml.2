Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2BGKkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:40:06 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38824 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab2BGKkE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:40:04 -0500
MIME-Version: 1.0
In-Reply-To: <1328610997.2232.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20120206205354.GA31186@quad>
	<1328603689.2476.15.camel@edumazet-laptop>
	<20120207084156.GA15359@elte.hu>
	<1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
	<1328610997.2232.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Tue, 7 Feb 2012 11:40:01 +0100
Message-ID: <CABPqkBRwjwG0i+J_Qzgm+khHRD+LiT60vMEQA3w1MtPq-FFKLw@mail.gmail.com>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Stephane Eranian <eranian@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

How do you deal with that:

[    0.019998] Performance Events: PEBS fmt0+, Core2 events, Broken
BIOS detected, complain to your hardware vendor.
[    0.019998] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
(MSR 186 is 43003c)

Your BIOS is using a counter to count cycles for power savings tricks.
That is conflicting
with perf_events.


On Tue, Feb 7, 2012 at 11:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 07 février 2012 à 11:31 +0100, Stephane Eranian a écrit :
>> On Tue, Feb 7, 2012 at 11:25 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le mardi 07 février 2012 à 09:41 +0100, Ingo Molnar a écrit :
>> >
>> >> Were these messages introduced by:
>> >>
>> >>  e050e3f0a71b: perf: Fix broken interrupt rate throttling
>> >>
>> >> as well?
>> >>
>> >> In any case I'm holding off on applying the patch before this is
>> >> resolved.
>> >
>> > Reverting e050e3f0a71b solves all my problems, no more warnings.
>> >
>> > $ perf record -a -g hackbench 10 thread 4000
>> > Running with 10*40 (== 400) tasks.
>> > Time: 13.181
>> > [ perf record: Woken up 59 times to write data ]
>> > [ perf record: Captured and wrote 16.874 MB perf.data (~737228 samples)
>> > ]
>> >
>> > $ perf record -a -g hackbench 10 thread 4000
>> > Running with 10*40 (== 400) tasks.
>> > Time: 13.124
>> > [ perf record: Woken up 61 times to write data ]
>> > [ perf record: Captured and wrote 16.533 MB perf.data (~722349 samples)
>> > ]
>> >
>> What system is this running on?
>> The problem is that without e050e3f0a71b interrupt throttling does not work.
>>
>> I think the key difference is that without the patch, frequency adjustment
>> happens with the PMU completely stopped whereas with my patch it does
>> not. I suspect this may be the issue. I can rework the patch to disable the
>> PMU completely while retaining the same workflow.
>
> Its an HP ProLiant BL460c G1
>
> dmesg included
>
> [    0.000000] Linux version 3.3.0-rc2-00180-g8597559-dirty (root@svivoipvnx001) (gcc version 4.6.2 (GCC) ) #57 SMP Tue Feb 7 11:10:10 CET 2012
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfe44000 (usable)
> [    0.000000]  BIOS-e820: 00000000cfe44000 - 00000000cfe4c000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cfe4c000 - 00000000cfe4d000 (usable)
> [    0.000000]  BIOS-e820: 00000000cfe4d000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000012ffff000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: HP ProLiant BL460c G1, BIOS I15 05/02/2011
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0x12ffff max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
> [    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
> [    0.000000]   2 base 1000000000 mask 3000000000 uncachable
> [    0.000000]   3 base 2000000000 mask 2000000000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] found SMP MP-table at [c00f4f80] f4f80
> [    0.000000] initial memory mapped : 0 - 00e00000
> [    0.000000] Base memory trampoline at [c009e000] 9e000 size 4096
> [    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
> [    0.000000]  0000000000 - 0000200000 page 4k
> [    0.000000]  0000200000 - 0037800000 page 2M
> [    0.000000]  0037800000 - 00379fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 379fe000 @ dfa000-e00000
> [    0.000000] RAMDISK: 37f76000 - 37ff0000
> [    0.000000] Allocated new RAMDISK: 37984000 - 379fd28e
> [    0.000000] Move RAMDISK from 0000000037f76000 - 0000000037fef28d to 37984000 - 379fd28d
> [    0.000000] ACPI: RSDP 000f4f00 00024 (v02 HP    )
> [    0.000000] ACPI: XSDT cfe447c0 0007C (v01 HP     ProLiant 00000002   �? 0000162E)
> [    0.000000] ACPI: FACP cfe44840 000F4 (v03 HP     ProLiant 00000002   �? 0000162E)
> [    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20120111/tbfadt-629)
> [    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8 (20120111/tbfadt-629)
> [    0.000000] ACPI: DSDT cfe44940 02236 (v01 HP         DSDT 00000001 INTL 20061109)
> [    0.000000] ACPI: FACS cfe44100 00040
> [    0.000000] ACPI: SPCR cfe44140 00050 (v01 HP     SPCRRBSU 00000001   �? 0000162E)
> [    0.000000] ACPI: MCFG cfe441c0 0003C (v01 HP     ProLiant 00000001      00000000)
> [    0.000000] ACPI: HPET cfe44200 00038 (v01 HP     ProLiant 00000002   �? 0000162E)
> [    0.000000] ACPI: SPMI cfe44240 00040 (v05 HP     ProLiant 00000001   �? 0000162E)
> [    0.000000] ACPI: ERST cfe44280 001D0 (v01 HP     ProLiant 00000001   �? 0000162E)
> [    0.000000] ACPI: APIC cfe44480 00092 (v01 HP     ProLiant 00000002      00000000)
> [    0.000000] ACPI: FFFF cfe44540 00176 (v01 HP     ProLiant 00000001   �? 0000162E)
> [    0.000000] ACPI: BERT cfe446c0 00030 (v01 HP     ProLiant 00000001   �? 0000162E)
> [    0.000000] ACPI: HEST cfe44700 000BC (v01 HP     ProLiant 00000001   �? 0000162E)
> [    0.000000] ACPI: SSDT cfe49000 00C85 (v01 HP        SSDTP 00000001 INTL 20061109)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-000000012ffff000
> [    0.000000] node 0 pfn: [0 - 12ffff]
> [    0.000000] remap_alloc: node 0 [12fc00000-12fe00000) -> [f7600000-f7800000)
> [    0.000000] Initmem setup node 0 0000000000000000-000000012ffff000
> [    0.000000]   NODE_DATA [0000000037600000 - 0000000037601fff] (remapped)
> [    0.000000] 3974MB HIGHMEM available.
> [    0.000000] 889MB LOWMEM available.
> [    0.000000] max_low_pfn = 379fe, highstart_pfn = 379fe
> [    0.000000] Low memory ends at vaddr f79fe000
> [    0.000000] High memory starts at vaddr f79fe000
> [    0.000000]   mapped low ram: 0 - 379fe000
> [    0.000000]   low ram: 0 - 379fe000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000379fe
> [    0.000000]   HighMem  0x000379fe -> 0x0012ffff
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] Early memory PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000cfe44
> [    0.000000]     0: 0x000cfe4c -> 0x000cfe4d
> [    0.000000]     0: 0x00100000 -> 0x0012ffff
> [    0.000000] On node 0 totalpages: 1048019
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1748 pages used for memmap
> [    0.000000]   Normal zone: 221994 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 7949 pages used for memmap
> [    0.000000]   HighMem zone: 812345 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x908
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 13 pages/cpu @f5000000 s29248 r0 d24000 u262144
> [    0.000000] pcpu-alloc: s29248 r0 d24000 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038290
> [    0.000000] Policy zone: HighMem
> [    0.000000] Kernel command line: ro root=/dev/cciss/c0d0p2 nofb vga=6 thash_entries=4096
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (000379fe:0012ffff)
> [    0.000000] Memory: 4141276k/4980732k available (4164k kernel code, 48752k reserved, 2051k data, 428k init, 3279128k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd37000 - 0xfffff000   (2848 kB)
> [    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
> [    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
> [    0.000000]       .init : 0xc0812000 - 0xc087d000   ( 428 kB)
> [    0.000000]       .data : 0xc0611329 - 0xc0811f80   (2051 kB)
> [    0.000000]       .text : 0xc0200000 - 0xc0611329   (4164 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU debugfs-based tracing is enabled.
> [    0.000000] NR_IRQS:2304 nr_irqs:744 16
> [    0.000000] CPU 0 irqstacks, hard=f4c0c000 soft=f4c0e000
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x60
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 3000.125 MHz processor.
> [    0.001002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.25 BogoMIPS (lpj=3000125)
> [    0.001152] pid_max: default: 32768 minimum: 301
> [    0.001252] Mount-cache hash table entries: 512
> [    0.001455] CPU: Physical Processor ID: 0
> [    0.001526] CPU: Processor Core ID: 0
> [    0.001596] mce: CPU supports 6 MCE banks
> [    0.002007] CPU0: Thermal monitoring enabled (TM2)
> [    0.002081] using mwait in idle threads.
> [    0.002207] ACPI: Core revision 20120111
> [    0.004004] ftrace: allocating 16701 entries in 33 pages
> [    0.008034] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.008464] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.018989] CPU0: Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz stepping 06
> [    0.019998] Performance Events: PEBS fmt0+, Core2 events, Broken BIOS detected, complain to your hardware vendor.
> [    0.019998] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 43003c)
> [    0.019998] Intel PMU driver.
> [    0.019998] ... version:                2
> [    0.019998] ... bit width:              40
> [    0.019998] ... generic registers:      2
> [    0.019998] ... value mask:             000000ffffffffff
> [    0.019998] ... max period:             000000007fffffff
> [    0.019998] ... fixed-purpose events:   3
> [    0.019998] ... event mask:             0000000700000003
> [    0.020171] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.020310] CPU 1 irqstacks, hard=f4d20000 soft=f4d22000
> [    0.020312] Booting Node   0, Processors  #1
> [    0.020394] smpboot cpu 1: start_ip = 9e000
> [    0.001999] Initializing CPU#1
> [    0.092009] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.092209] CPU 2 irqstacks, hard=f4d4c000 soft=f4d4e000
> [    0.092210]  #2
> [    0.092250] smpboot cpu 2: start_ip = 9e000
> [    0.001999] Initializing CPU#2
> [    0.104007] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.104202] CPU 3 irqstacks, hard=f4d5a000 soft=f4d5c000
> [    0.104204]  #3
> [    0.104244] smpboot cpu 3: start_ip = 9e000
> [    0.001999] Initializing CPU#3
> [    0.116004] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.117050] CPU 4 irqstacks, hard=f4d70000 soft=f4d72000
> [    0.117051]  #4
> [    0.117091] smpboot cpu 4: start_ip = 9e000
> [    0.001999] Initializing CPU#4
> [    0.129017] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.129256] CPU 5 irqstacks, hard=f4d8a000 soft=f4d8c000
> [    0.129258]  #5
> [    0.129299] smpboot cpu 5: start_ip = 9e000
> [    0.001999] Initializing CPU#5
> [    0.141002] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.142049] CPU 6 irqstacks, hard=f4da0000 soft=f4da2000
> [    0.142051]  #6
> [    0.142090] smpboot cpu 6: start_ip = 9e000
> [    0.001999] Initializing CPU#6
> [    0.154002] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.154196] CPU 7 irqstacks, hard=f4dae000 soft=f4db0000
> [    0.154198]  #7 Ok.
> [    0.154262] smpboot cpu 7: start_ip = 9e000
> [    0.001999] Initializing CPU#7
> [    0.165999] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.166159] Brought up 8 CPUs
> [    0.166985] Total of 8 processors activated (48001.02 BogoMIPS).
> [    0.169137] NET: Registered protocol family 16
> [    0.169651] ACPI: bus type pci registered
> [    0.169808] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.169920] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    0.169985] PCI: Using MMCONFIG for extended config space
> [    0.170059] PCI: Using configuration type 1 for base access
> [    0.170140] PCI: HP ProLiant BL460c G1 detected, enabling pci=bfsort.
> [    0.173575] bio: create slab <bio-0> at 0
> [    0.174071] ACPI: Added _OSI(Module Device)
> [    0.174142] ACPI: Added _OSI(Processor Device)
> [    0.174214] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.174287] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.174817] ACPI: EC: Look up EC in DSDT
> [    0.175032] ACPI Error: Field [CDW3] at 96 exceeds Buffer [NULL] size 64 (bits) (20120111/dsopcode-236)
> [    0.175213] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node f4c216f0), AE_AML_BUFFER_LIMIT (20120111/psparse-536)
> [    0.176525] ACPI: SSDT cfe4e000 00297 (v01 HP        SSDT0 00000001 INTL 20061109)
> [    0.176817] ACPI: Dynamic OEM Table Load:
> [    0.176956] ACPI: SSDT   (null) 00297 (v01 HP        SSDT0 00000001 INTL 20061109)
> [    0.177142] ACPI: SSDT cfe4f800 000AD (v01 HP      CPU0CST 00000001 INTL 20061109)
> [    0.177416] ACPI: Dynamic OEM Table Load:
> [    0.177556] ACPI: SSDT   (null) 000AD (v01 HP      CPU0CST 00000001 INTL 20061109)
> [    0.184134] ACPI: SSDT cfe4e300 00297 (v01 HP        SSDT1 00000001 INTL 20061109)
> [    0.184426] ACPI: Dynamic OEM Table Load:
> [    0.184565] ACPI: SSDT   (null) 00297 (v01 HP        SSDT1 00000001 INTL 20061109)
> [    0.184764] ACPI: SSDT cfe4f900 000AD (v01 HP      CPU1CST 00000001 INTL 20061109)
> [    0.185044] ACPI: Dynamic OEM Table Load:
> [    0.185183] ACPI: SSDT   (null) 000AD (v01 HP      CPU1CST 00000001 INTL 20061109)
> [    0.191133] ACPI: SSDT cfe4e600 00297 (v01 HP        SSDT2 00000001 INTL 20061109)
> [    0.191425] ACPI: Dynamic OEM Table Load:
> [    0.191564] ACPI: SSDT   (null) 00297 (v01 HP        SSDT2 00000001 INTL 20061109)
> [    0.191762] ACPI: SSDT cfe4fa00 000AD (v01 HP      CPU2CST 00000001 INTL 20061109)
> [    0.192043] ACPI: Dynamic OEM Table Load:
> [    0.192182] ACPI: SSDT   (null) 000AD (v01 HP      CPU2CST 00000001 INTL 20061109)
> [    0.198135] ACPI: SSDT cfe4e900 0029C (v01 HP        SSDT3 00000001 INTL 20061109)
> [    0.198430] ACPI: Dynamic OEM Table Load:
> [    0.198570] ACPI: SSDT   (null) 0029C (v01 HP        SSDT3 00000001 INTL 20061109)
> [    0.198768] ACPI: SSDT cfe4fb00 000AD (v01 HP      CPU3CST 00000001 INTL 20061109)
> [    0.199049] ACPI: Dynamic OEM Table Load:
> [    0.199189] ACPI: SSDT   (null) 000AD (v01 HP      CPU3CST 00000001 INTL 20061109)
> [    0.205138] ACPI: SSDT cfe4ec00 00298 (v01 HP        SSDT4 00000001 INTL 20061109)
> [    0.205434] ACPI: Dynamic OEM Table Load:
> [    0.205573] ACPI: SSDT   (null) 00298 (v01 HP        SSDT4 00000001 INTL 20061109)
> [    0.205774] ACPI: SSDT cfe4fc00 000AD (v01 HP      CPU4CST 00000001 INTL 20061109)
> [    0.206056] ACPI: Dynamic OEM Table Load:
> [    0.206196] ACPI: SSDT   (null) 000AD (v01 HP      CPU4CST 00000001 INTL 20061109)
> [    0.214990] ACPI: SSDT cfe4ef00 00298 (v01 HP        SSDT5 00000001 INTL 20061109)
> [    0.215264] ACPI: Dynamic OEM Table Load:
> [    0.215403] ACPI: SSDT   (null) 00298 (v01 HP        SSDT5 00000001 INTL 20061109)
> [    0.215600] ACPI: SSDT cfe4fd00 000AD (v01 HP      CPU5CST 00000001 INTL 20061109)
> [    0.215880] ACPI: Dynamic OEM Table Load:
> [    0.215977] ACPI: SSDT   (null) 000AD (v01 HP      CPU5CST 00000001 INTL 20061109)
> [    0.219129] ACPI: SSDT cfe4f200 00298 (v01 HP        SSDT6 00000001 INTL 20061109)
> [    0.219426] ACPI: Dynamic OEM Table Load:
> [    0.219565] ACPI: SSDT   (null) 00298 (v01 HP        SSDT6 00000001 INTL 20061109)
> [    0.219762] ACPI: SSDT cfe4fe00 000AD (v01 HP      CPU6CST 00000001 INTL 20061109)
> [    0.220047] ACPI: Dynamic OEM Table Load:
> [    0.220186] ACPI: SSDT   (null) 000AD (v01 HP      CPU6CST 00000001 INTL 20061109)
> [    0.223128] ACPI: SSDT cfe4f500 00298 (v01 HP        SSDT7 00000001 INTL 20061109)
> [    0.223852] ACPI: Dynamic OEM Table Load:
> [    0.223976] ACPI: SSDT   (null) 00298 (v01 HP        SSDT7 00000001 INTL 20061109)
> [    0.224173] ACPI: SSDT cfe4ff00 000AD (v01 HP      CPU7CST 00000001 INTL 20061109)
> [    0.224456] ACPI: Dynamic OEM Table Load:
> [    0.224595] ACPI: SSDT   (null) 000AD (v01 HP      CPU7CST 00000001 INTL 20061109)
> [    0.227055] ACPI: Interpreter enabled
> [    0.227125] ACPI: (supports S0 S5)
> [    0.227267] ACPI: Using IOAPIC for interrupt routing
> [    0.231275] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.231407] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
> [    0.231531] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> [    0.231589] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> [    0.231647] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    0.231720] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xdfffffff]
> [    0.231793] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
> [    0.231908] PCI host bridge to bus 0000:00
> [    0.231962] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.231976] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.232033] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.232092] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdfffffff]
> [    0.232150] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
> [    0.232218] pci 0000:00:00.0: [8086:25d8] type 0 class 0x000600
> [    0.232259] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.232275] pci 0000:00:02.0: [8086:25e2] type 1 class 0x000604
> [    0.232310] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
> [    0.232324] pci 0000:00:03.0: [8086:25e3] type 1 class 0x000604
> [    0.232359] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    0.232373] pci 0000:00:04.0: [8086:25e4] type 1 class 0x000604
> [    0.232408] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
> [    0.232421] pci 0000:00:05.0: [8086:25e5] type 1 class 0x000604
> [    0.232456] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
> [    0.232470] pci 0000:00:06.0: [8086:25e6] type 1 class 0x000604
> [    0.232505] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
> [    0.232518] pci 0000:00:07.0: [8086:25e7] type 1 class 0x000604
> [    0.232553] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
> [    0.232569] pci 0000:00:10.0: [8086:25f0] type 0 class 0x000600
> [    0.232597] pci 0000:00:10.1: [8086:25f0] type 0 class 0x000600
> [    0.232619] pci 0000:00:10.2: [8086:25f0] type 0 class 0x000600
> [    0.232644] pci 0000:00:11.0: [8086:25f1] type 0 class 0x000600
> [    0.232666] pci 0000:00:13.0: [8086:25f3] type 0 class 0x000600
> [    0.232688] pci 0000:00:15.0: [8086:25f5] type 0 class 0x000600
> [    0.232710] pci 0000:00:16.0: [8086:25f6] type 0 class 0x000600
> [    0.232740] pci 0000:00:1c.0: [8086:2690] type 1 class 0x000604
> [    0.232800] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.232824] pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
> [    0.232874] pci 0000:00:1d.0: reg 20: [io  0x1000-0x101f]
> [    0.232911] pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
> [    0.233012] pci 0000:00:1d.1: reg 20: [io  0x1020-0x103f]
> [    0.233049] pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
> [    0.233099] pci 0000:00:1d.2: reg 20: [io  0x1040-0x105f]
> [    0.233135] pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
> [    0.233185] pci 0000:00:1d.3: reg 20: [io  0x1060-0x107f]
> [    0.233228] pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
> [    0.233244] pci 0000:00:1d.7: reg 10: [mem 0xf5df0000-0xf5df03ff]
> [    0.233318] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.233334] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
> [    0.233386] pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
> [    0.233666] pci 0000:04:00.0: [8086:3500] type 1 class 0x000604
> [    0.235294] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
> [    0.235842] pci 0000:04:00.3: [8086:350c] type 1 class 0x000604
> [    0.237568] pci 0000:04:00.3: PME# supported from D0 D3hot D3cold
> [    0.237974] pci 0000:00:02.0: PCI bridge to [bus 04-09]
> [    0.238052] pci 0000:00:02.0:   bridge window [mem 0xf9f00000-0xfbffffff]
> [    0.239345] pci 0000:05:00.0: [8086:3510] type 1 class 0x000604
> [    0.241201] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
> [    0.241750] pci 0000:05:01.0: [8086:3514] type 1 class 0x000604
> [    0.243658] pci 0000:05:01.0: PME# supported from D0 D3hot D3cold
> [    0.244658] pci 0000:04:00.0: PCI bridge to [bus 05-08]
> [    0.244795] pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.246154] pci 0000:06:00.0: [1166:0103] type 1 class 0x000604
> [    0.249062] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
> [    0.249657] pci 0000:05:00.0: PCI bridge to [bus 06-07]
> [    0.249795] pci 0000:05:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.251657] pci 0000:07:00.0: [14e4:16ac] type 0 class 0x000200
> [    0.252428] pci 0000:07:00.0: reg 10: [mem 0xfa000000-0xfbffffff 64bit]
> [    0.254016] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x00003fff pref]
> [    0.255931] pci 0000:07:00.0: PME# supported from D3hot D3cold
> [    0.257793] pci 0000:06:00.0: PCI bridge to [bus 07-07]
> [    0.258106] pci 0000:06:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.259518] pci 0000:05:01.0: PCI bridge to [bus 08-08]
> [    0.262197] pci 0000:04:00.3: PCI bridge to [bus 09-09]
> [    0.262682] pci 0000:0a:00.0: [1166:0103] type 1 class 0x000604
> [    0.262736] pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
> [    0.262747] pci 0000:00:03.0: PCI bridge to [bus 0a-0c]
> [    0.262822] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
> [    0.262825] pci 0000:00:03.0:   bridge window [mem 0xfde00000-0xfdefffff]
> [    0.262860] pci 0000:0b:04.0: [1166:0104] type 1 class 0x000604
> [    0.262921] pci 0000:0b:08.0: [103c:3238] type 0 class 0x000104
> [    0.262989] pci 0000:0b:08.0: reg 10: [mem 0xfde80000-0xfdefffff 64bit]
> [    0.262997] pci 0000:0b:08.0: reg 18: [io  0x4000-0x40ff]
> [    0.263004] pci 0000:0b:08.0: reg 1c: [mem 0xfde70000-0xfde77fff]
> [    0.263024] pci 0000:0b:08.0: reg 30: [mem 0x00000000-0x00003fff pref]
> [    0.263057] pci 0000:0b:08.0: supports D1
> [    0.263086] pci 0000:0a:00.0: PCI bridge to [bus 0b-0c]
> [    0.263164] pci 0000:0a:00.0:   bridge window [io  0x4000-0x4fff]
> [    0.263167] pci 0000:0a:00.0:   bridge window [mem 0xfde00000-0xfdefffff]
> [    0.263224] pci 0000:0b:04.0: PCI bridge to [bus 0c-0c]
> [    0.263335] pci 0000:00:04.0: PCI bridge to [bus 0d-0f]
> [    0.263434] pci 0000:00:05.0: PCI bridge to [bus 10-12]
> [    0.263539] pci 0000:13:00.0: [1166:0103] type 1 class 0x000604
> [    0.263593] pci 0000:13:00.0: PME# supported from D0 D3hot D3cold
> [    0.263605] pci 0000:00:06.0: PCI bridge to [bus 13-15]
> [    0.263681] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
> [    0.263722] pci 0000:14:04.0: [14e4:1679] type 0 class 0x000200
> [    0.263739] pci 0000:14:04.0: reg 10: [mem 0xfdff0000-0xfdffffff 64bit]
> [    0.263751] pci 0000:14:04.0: reg 18: [mem 0xfdfe0000-0xfdfeffff 64bit]
> [    0.263771] pci 0000:14:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.263811] pci 0000:14:04.0: PME# supported from D3hot D3cold
> [    0.263834] pci 0000:14:04.1: [14e4:1679] type 0 class 0x000200
> [    0.263851] pci 0000:14:04.1: reg 10: [mem 0xfdfd0000-0xfdfdffff 64bit]
> [    0.263863] pci 0000:14:04.1: reg 18: [mem 0xfdfc0000-0xfdfcffff 64bit]
> [    0.263883] pci 0000:14:04.1: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.263923] pci 0000:14:04.1: PME# supported from D3hot D3cold
> [    0.263963] pci 0000:13:00.0: PCI bridge to [bus 14-14]
> [    0.263975] pci 0000:13:00.0:   bridge window [mem 0xfdf00000-0xfdffffff]
> [    0.264005] pci 0000:00:07.0: PCI bridge to [bus 16-18]
> [    0.264125] pci 0000:02:00.0: [1166:0103] type 1 class 0x000604
> [    0.264202] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> [    0.264218] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
> [    0.264296] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf7ffffff]
> [    0.264349] pci 0000:03:00.0: [14e4:16ac] type 0 class 0x000200
> [    0.264372] pci 0000:03:00.0: reg 10: [mem 0xf6000000-0xf7ffffff 64bit]
> [    0.264416] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x00003fff pref]
> [    0.264471] pci 0000:03:00.0: PME# supported from D3hot D3cold
> [    0.264523] pci 0000:02:00.0: PCI bridge to [bus 03-03]
> [    0.264604] pci 0000:02:00.0:   bridge window [mem 0xf6000000-0xf7ffffff]
> [    0.264647] pci 0000:01:03.0: [1002:515e] type 0 class 0x000300
> [    0.264664] pci 0000:01:03.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
> [    0.264673] pci 0000:01:03.0: reg 14: [io  0x3000-0x30ff]
> [    0.264683] pci 0000:01:03.0: reg 18: [mem 0xf5ff0000-0xf5ffffff]
> [    0.264717] pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.264744] pci 0000:01:03.0: supports D1 D2
> [    0.264760] pci 0000:01:04.0: [0e11:b203] type 0 class 0x000880
> [    0.264777] pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
> [    0.264786] pci 0000:01:04.0: reg 14: [mem 0xf5fe0000-0xf5fe01ff]
> [    0.264853] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
> [    0.264873] pci 0000:01:04.2: [0e11:b204] type 0 class 0x000880
> [    0.264892] pci 0000:01:04.2: reg 10: [io  0x3400-0x34ff]
> [    0.264975] pci 0000:01:04.2: reg 14: [mem 0xf5fd0000-0xf5fd07ff]
> [    0.264986] pci 0000:01:04.2: reg 18: [mem 0xf5fc0000-0xf5fc3fff]
> [    0.264997] pci 0000:01:04.2: reg 1c: [mem 0xf5f00000-0xf5f7ffff]
> [    0.265026] pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
> [    0.265056] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
> [    0.265077] pci 0000:01:04.4: [103c:3300] type 0 class 0x000c03
> [    0.265132] pci 0000:01:04.4: reg 20: [io  0x3800-0x381f]
> [    0.265180] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
> [    0.265205] pci 0000:01:04.6: [103c:3302] type 0 class 0x000c07
> [    0.265221] pci 0000:01:04.6: reg 10: [mem 0xf5ef0000-0xf5ef00ff]
> [    0.265296] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
> [    0.265338] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
> [    0.265420] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
> [    0.265423] pci 0000:00:1e.0:   bridge window [mem 0xf5e00000-0xf5ffffff]
> [    0.265427] pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
> [    0.265429] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.265431] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.265433] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.265435] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
> [    0.265437] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
> [    0.265459] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.265516] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
> [    0.265552] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPTA.NPE1._PRT]
> [    0.265570] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02._PRT]
> [    0.265580] ACPI Warning: For \_SB_.PCI0.PT02._PRT: Return Package has no elements (empty) (20120111/nspredef-463)
> [    0.265770] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4._PRT]
> [    0.265802] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT02.IPE4.IPE1.NPE2._PRT]
> [    0.265825] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
> [    0.265857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT04._PRT]
> [    0.265909] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT05._PRT]
> [    0.265962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT06._PRT]
> [    0.266020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT07._PRT]
> [    0.266053]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
> [    0.270001] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 10 11)
> [    0.270310] ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7 10 11)
> [    0.270617] ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
> [    0.270925] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
> [    0.271229] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
> [    0.271609] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 *11)
> [    0.271917] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 10 *11)
> [    0.272228] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 *11)
> [    0.272673] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.272782] vgaarb: loaded
> [    0.272848] vgaarb: bridge control possible 0000:01:03.0
> [    0.273076] SCSI subsystem initialized
> [    0.273323] usbcore: registered new interface driver usbfs
> [    0.273463] usbcore: registered new interface driver hub
> [    0.273587] usbcore: registered new device driver usb
> [    0.274101] PCI: Using ACPI for IRQ routing
> [    0.279570] PCI: pci_cache_line_size set to 64 bytes
> [    0.280122] reserve RAM buffer: 000000000009f400 - 000000000009ffff
> [    0.280124] reserve RAM buffer: 00000000cfe44000 - 00000000cfffffff
> [    0.280126] reserve RAM buffer: 00000000cfe4d000 - 00000000cfffffff
> [    0.280128] reserve RAM buffer: 000000012ffff000 - 000000012fffffff
> [    0.280406] cfg80211: Calling CRDA to update world regulatory domain
> [    0.280486] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.280486] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.280486] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.285814] Switching to clocksource hpet
> [    0.287126] pnp: PnP ACPI init
> [    0.287197] ACPI: bus type pnp registered
> [    0.287321] pnp 00:00: [bus 00-7f]
> [    0.287324] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.287326] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.287328] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.287329] pnp 00:00: [mem 0xd0000000-0xdfffffff window]
> [    0.287331] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
> [    0.287385] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 PNP0a08 (active)
> [    0.287471] pnp 00:01: [io  0x0070-0x0077]
> [    0.287473] pnp 00:01: [io  0x0408-0x040f]
> [    0.287474] pnp 00:01: [io  0x04d0-0x04d1]
> [    0.287476] pnp 00:01: [io  0x0020-0x003f]
> [    0.287477] pnp 00:01: [io  0x00a0-0x00bf]
> [    0.287479] pnp 00:01: [io  0x0090-0x009f]
> [    0.287480] pnp 00:01: [io  0x0050-0x0053]
> [    0.287482] pnp 00:01: [io  0x0700-0x071f]
> [    0.287483] pnp 00:01: [io  0x0800-0x083f]
> [    0.287485] pnp 00:01: [io  0x0900-0x097f]
> [    0.287486] pnp 00:01: [io  0x0010-0x001f]
> [    0.287488] pnp 00:01: [io  0x0c80-0x0c83]
> [    0.287489] pnp 00:01: [io  0x0cd4-0x0cd7]
> [    0.287491] pnp 00:01: [io  0x0f50-0x0f58]
> [    0.287492] pnp 00:01: [io  0x00f0]
> [    0.287494] pnp 00:01: [io  0x0ca0-0x0ca1]
> [    0.287495] pnp 00:01: [io  0x0ca4-0x0ca5]
> [    0.287497] pnp 00:01: [mem 0xe0000000-0xefffffff]
> [    0.287498] pnp 00:01: [mem 0xfe000000-0xfebfffff]
> [    0.287500] pnp 00:01: [io  0x03f8-0x03ff]
> [    0.287579] system 00:01: [io  0x0408-0x040f] has been reserved
> [    0.287656] system 00:01: [io  0x04d0-0x04d1] has been reserved
> [    0.287733] system 00:01: [io  0x0700-0x071f] has been reserved
> [    0.287810] system 00:01: [io  0x0800-0x083f] has been reserved
> [    0.287887] system 00:01: [io  0x0900-0x097f] has been reserved
> [    0.287964] system 00:01: [io  0x0c80-0x0c83] has been reserved
> [    0.288048] system 00:01: [io  0x0cd4-0x0cd7] has been reserved
> [    0.288125] system 00:01: [io  0x0f50-0x0f58] has been reserved
> [    0.288202] system 00:01: [io  0x0ca0-0x0ca1] has been reserved
> [    0.288280] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
> [    0.288356] system 00:01: [io  0x03f8-0x03ff] has been reserved
> [    0.288433] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.288513] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
> [    0.288593] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.288600] pnp 00:02: [io  0x0ca2-0x0ca3]
> [    0.288648] pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
> [    0.288665] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    0.288717] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.288725] pnp 00:04: [dma 7]
> [    0.288726] pnp 00:04: [io  0x0000-0x000f]
> [    0.288728] pnp 00:04: [io  0x0080-0x008f]
> [    0.288729] pnp 00:04: [io  0x00c0-0x00df]
> [    0.288777] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.288784] pnp 00:05: [io  0x0061]
> [    0.288835] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.288842] pnp 00:06: [io  0x0060]
> [    0.288843] pnp 00:06: [io  0x0064]
> [    0.288852] pnp 00:06: [irq 1]
> [    0.288900] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.288909] pnp 00:07: [irq 12]
> [    0.288963] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
> [    0.288970] pnp 00:08: [io  0x002e-0x002f]
> [    0.288972] pnp 00:08: [io  0x004e-0x004f]
> [    0.288974] pnp 00:08: [io  0x0620-0x065f]
> [    0.288975] pnp 00:08: [io  0x0680-0x069f]
> [    0.288977] pnp 00:08: [io  0x0600-0x061f]
> [    0.288978] pnp 00:08: [io  0x0660-0x067f]
> [    0.288982] pnp 00:08: [io  0x0300-0x030f]
> [    0.289046] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
> [    0.289136] pnp 00:09: [irq 3]
> [    0.289138] pnp 00:09: [io  0x02f8-0x02ff]
> [    0.289248] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
> [    0.289334] pnp 00:0a: Plug and Play ACPI device, IDs PNP0700 (disabled)
> [    0.289440] pnp: PnP ACPI: found 11 devices
> [    0.289511] ACPI: ACPI bus type pnp unregistered
> [    0.327044] PCI: max bus depth: 4 pci_try_num: 5
> [    0.327883] pci 0000:00:02.0: BAR 9: assigned [mem 0xd0000000-0xd00fffff pref]
> [    0.327988] pci 0000:00:03.0: BAR 9: assigned [mem 0xd0100000-0xd01fffff pref]
> [    0.328106] pci 0000:00:06.0: BAR 9: assigned [mem 0xd0200000-0xd02fffff pref]
> [    0.328210] pci 0000:00:1c.0: BAR 9: assigned [mem 0xd0300000-0xd03fffff pref]
> [    0.328315] pci 0000:04:00.0: BAR 9: assigned [mem 0xd0000000-0xd00fffff pref]
> [    0.328419] pci 0000:05:00.0: BAR 9: assigned [mem 0xd0000000-0xd00fffff pref]
> [    0.328524] pci 0000:06:00.0: BAR 9: assigned [mem 0xd0000000-0xd00fffff pref]
> [    0.328628] pci 0000:07:00.0: BAR 6: assigned [mem 0xd0000000-0xd0003fff pref]
> [    0.328733] pci 0000:06:00.0: PCI bridge to [bus 07-07]
> [    0.328900] pci 0000:06:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.329042] pci 0000:06:00.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
> [    0.329313] pci 0000:05:00.0: PCI bridge to [bus 06-07]
> [    0.329450] pci 0000:05:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.329542] pci 0000:05:00.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
> [    0.329725] pci 0000:05:01.0: PCI bridge to [bus 08-08]
> [    0.329999] pci 0000:04:00.0: PCI bridge to [bus 05-08]
> [    0.330137] pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.330229] pci 0000:04:00.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
> [    0.330366] pci 0000:04:00.3: PCI bridge to [bus 09-09]
> [    0.330640] pci 0000:00:02.0: PCI bridge to [bus 04-09]
> [    0.330697] pci 0000:00:02.0:   bridge window [mem 0xf9f00000-0xfbffffff]
> [    0.330756] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
> [    0.330831] pci 0000:0a:00.0: BAR 9: assigned [mem 0xd0100000-0xd01fffff pref]
> [    0.330904] pci 0000:0b:08.0: BAR 6: assigned [mem 0xd0100000-0xd0103fff pref]
> [    0.330977] pci 0000:0b:04.0: PCI bridge to [bus 0c-0c]
> [    0.331043] pci 0000:0a:00.0: PCI bridge to [bus 0b-0c]
> [    0.331100] pci 0000:0a:00.0:   bridge window [io  0x4000-0x4fff]
> [    0.331159] pci 0000:0a:00.0:   bridge window [mem 0xfde00000-0xfdefffff]
> [    0.331218] pci 0000:0a:00.0:   bridge window [mem 0xd0100000-0xd01fffff pref]
> [    0.331325] pci 0000:00:03.0: PCI bridge to [bus 0a-0c]
> [    0.331400] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
> [    0.331479] pci 0000:00:03.0:   bridge window [mem 0xfde00000-0xfdefffff]
> [    0.331560] pci 0000:00:03.0:   bridge window [mem 0xd0100000-0xd01fffff pref]
> [    0.331666] pci 0000:00:04.0: PCI bridge to [bus 0d-0f]
> [    0.331745] pci 0000:00:05.0: PCI bridge to [bus 10-12]
> [    0.331824] pci 0000:13:00.0: BAR 9: assigned [mem 0xd0200000-0xd02fffff pref]
> [    0.331929] pci 0000:14:04.0: BAR 6: assigned [mem 0xd0200000-0xd021ffff pref]
> [    0.332043] pci 0000:14:04.1: BAR 6: assigned [mem 0xd0220000-0xd023ffff pref]
> [    0.332147] pci 0000:13:00.0: PCI bridge to [bus 14-14]
> [    0.332224] pci 0000:13:00.0:   bridge window [mem 0xfdf00000-0xfdffffff]
> [    0.332305] pci 0000:13:00.0:   bridge window [mem 0xd0200000-0xd02fffff pref]
> [    0.332412] pci 0000:00:06.0: PCI bridge to [bus 13-15]
> [    0.332488] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
> [    0.332568] pci 0000:00:06.0:   bridge window [mem 0xd0200000-0xd02fffff pref]
> [    0.332674] pci 0000:00:07.0: PCI bridge to [bus 16-18]
> [    0.332753] pci 0000:02:00.0: BAR 9: assigned [mem 0xd0300000-0xd03fffff pref]
> [    0.332858] pci 0000:03:00.0: BAR 6: assigned [mem 0xd0300000-0xd0303fff pref]
> [    0.332962] pci 0000:02:00.0: PCI bridge to [bus 03-03]
> [    0.333047] pci 0000:02:00.0:   bridge window [mem 0xf6000000-0xf7ffffff]
> [    0.333128] pci 0000:02:00.0:   bridge window [mem 0xd0300000-0xd03fffff pref]
> [    0.333237] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
> [    0.333313] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf7ffffff]
> [    0.333394] pci 0000:00:1c.0:   bridge window [mem 0xd0300000-0xd03fffff pref]
> [    0.333502] pci 0000:01:03.0: BAR 6: assigned [mem 0xf5e00000-0xf5e1ffff pref]
> [    0.333607] pci 0000:01:04.2: BAR 6: assigned [mem 0xf5e20000-0xf5e2ffff pref]
> [    0.333711] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
> [    0.333786] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
> [    0.333865] pci 0000:00:1e.0:   bridge window [mem 0xf5e00000-0xf5ffffff]
> [    0.333946] pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
> [    0.334643] pci 0000:00:1e.0: setting latency timer to 64
> [    0.334646] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.334648] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.334650] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.334652] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xdfffffff]
> [    0.334653] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
> [    0.334655] pci_bus 0000:04: resource 1 [mem 0xf9f00000-0xfbffffff]
> [    0.334657] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd00fffff pref]
> [    0.334659] pci_bus 0000:05: resource 1 [mem 0xfa000000-0xfbffffff]
> [    0.334661] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff pref]
> [    0.334662] pci_bus 0000:06: resource 1 [mem 0xfa000000-0xfbffffff]
> [    0.334664] pci_bus 0000:06: resource 2 [mem 0xd0000000-0xd00fffff pref]
> [    0.334666] pci_bus 0000:07: resource 1 [mem 0xfa000000-0xfbffffff]
> [    0.334668] pci_bus 0000:07: resource 2 [mem 0xd0000000-0xd00fffff pref]
> [    0.334669] pci_bus 0000:0a: resource 0 [io  0x4000-0x4fff]
> [    0.334671] pci_bus 0000:0a: resource 1 [mem 0xfde00000-0xfdefffff]
> [    0.334673] pci_bus 0000:0a: resource 2 [mem 0xd0100000-0xd01fffff pref]
> [    0.334675] pci_bus 0000:0b: resource 0 [io  0x4000-0x4fff]
> [    0.334676] pci_bus 0000:0b: resource 1 [mem 0xfde00000-0xfdefffff]
> [    0.334678] pci_bus 0000:0b: resource 2 [mem 0xd0100000-0xd01fffff pref]
> [    0.334680] pci_bus 0000:13: resource 1 [mem 0xfdf00000-0xfdffffff]
> [    0.334682] pci_bus 0000:13: resource 2 [mem 0xd0200000-0xd02fffff pref]
> [    0.334684] pci_bus 0000:14: resource 1 [mem 0xfdf00000-0xfdffffff]
> [    0.334685] pci_bus 0000:14: resource 2 [mem 0xd0200000-0xd02fffff pref]
> [    0.334687] pci_bus 0000:02: resource 1 [mem 0xf6000000-0xf7ffffff]
> [    0.334689] pci_bus 0000:02: resource 2 [mem 0xd0300000-0xd03fffff pref]
> [    0.334691] pci_bus 0000:03: resource 1 [mem 0xf6000000-0xf7ffffff]
> [    0.334693] pci_bus 0000:03: resource 2 [mem 0xd0300000-0xd03fffff pref]
> [    0.334695] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
> [    0.334696] pci_bus 0000:01: resource 1 [mem 0xf5e00000-0xf5ffffff]
> [    0.334698] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff 64bit pref]
> [    0.334700] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
> [    0.334702] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
> [    0.334703] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.334705] pci_bus 0000:01: resource 7 [mem 0xd0000000-0xdfffffff]
> [    0.334707] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfebfffff]
> [    0.334724] NET: Registered protocol family 2
> [    0.334833] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.334996] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.335106] TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.335196] TCP: Hash tables configured (established 4096 bind 4096)
> [    0.335274] TCP reno registered
> [    0.335343] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.335425] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.335543] NET: Registered protocol family 1
> [    0.346028] pci 0000:01:03.0: Boot video device
> [    0.347248] PCI: CLS 64 bytes, default 64
> [    0.347289] Trying to unpack rootfs image as initramfs...
> [    0.355560] Freeing initrd memory: 488k freed
> [    0.355778] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    0.357291] audit: initializing netlink socket (disabled)
> [    0.357351] type=2000 audit(1328613163.356:1): initialized
> [    0.358100] highmem bounce pool size: 64 pages
> [    0.358156] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.362587] VFS: Disk quotas dquot_6.5.2
> [    0.362722] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.363358] msgmni has been set to 1684
> [    0.363744] io scheduler noop registered
> [    0.363797] io scheduler deadline registered
> [    0.363853] io scheduler cfq registered (default)
> [    0.364183] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> [    0.366882] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.366957] ACPI: Power Button [PWRF]
> [    0.368839] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.368896] ACPI: Thermal Zone [THM0] (8 C)
> [    0.407474] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.427899] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.448527] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    0.469580] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    0.470145] intel_rng: FWH not detected
> [    0.470244] Linux agpgart interface v0.103
> [    0.472825] brd: module loaded
> [    0.477055] Compaq SMART2 Driver (v 2.6.0)
> [    0.477229] HP CISS Driver (v 3.6.26)
> [    0.477451] cciss 0000:0b:08.0: irq 41 for MSI/MSI-X
> [    0.557092] cciss 0000:0b:08.0: cciss0: <0x3238> at PCI 0000:0b:08.0 IRQ 41 using DAC
> [    0.573869]  cciss/c0d0: p1 p2 p3 p4 < p5 p6 p7 >
> [    0.574685] Uniform Multi-Platform E-IDE driver
> [    0.575168] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    0.575254] Probing IDE interface ide0...
> [    1.088097] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    1.088189] Probing IDE interface ide1...
> [    1.356020] Refined TSC clocksource calibration: 3000.106 MHz.
> [    1.356080] Switching to clocksource tsc
> [    1.601076] ide1 at 0x170-0x177,0x376 on irq 15
> [    1.601164] ide-gd driver 1.18
> [    1.602201] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.2.1 (Dec 18, 2011)
> [    1.604031] bnx2 0000:03:00.0: eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem f6000000, IRQ 16, node addr 00:1e:0b:ec:d3:dc
> [    1.607970] bnx2 0000:07:00.0: eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 16, node addr 00:1e:0b:ec:d3:d2
> [    1.608361] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.608436] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.608439] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.608571] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> [    1.608674] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001000
> [    1.608903] hub 1-0:1.0: USB hub found
> [    1.608957] hub 1-0:1.0: 2 ports detected
> [    1.609108] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.609111] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.609233] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> [    1.609329] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001020
> [    1.609550] hub 2-0:1.0: USB hub found
> [    1.609605] hub 2-0:1.0: 2 ports detected
> [    1.609750] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.609753] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.609877] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> [    1.609974] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
> [    1.610196] hub 3-0:1.0: USB hub found
> [    1.610250] hub 3-0:1.0: 2 ports detected
> [    1.610409] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [    1.610412] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    1.610532] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> [    1.610629] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001060
> [    1.610843] hub 4-0:1.0: USB hub found
> [    1.610897] hub 4-0:1.0: 2 ports detected
> [    1.611065] uhci_hcd 0000:01:04.4: UHCI Host Controller
> [    1.611189] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 5
> [    1.611270] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
> [    1.612337] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
> [    1.612830] hub 5-0:1.0: USB hub found
> [    1.612884] hub 5-0:1.0: 2 ports detected
> [    1.613242] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
> [    1.614991] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.615077] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.615292] i2c /dev entries driver
> [    1.616132] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    1.616207] cpuidle: using governor ladder
> [    1.617579] usbcore: registered new interface driver usbhid
> [    1.617635] usbhid: USB HID core driver
> [    1.617786] GACT probability NOT on
> [    1.617837] netem: version 1.3
> [    1.617888] u32 classifier
> [    1.617937]     Performance counters on
> [    1.617994]     Actions configured
> [    1.618050] Netfilter messages via NETLINK v0.30.
> [    1.618150] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    1.618405] TCP bic registered
> [    1.618799] NET: Registered protocol family 10
> [    1.618996] 8021q: 802.1Q VLAN Support v1.8
> [    1.619081] Registering the dns_resolver key type
> [    1.619145] Using IPI No-Shortcut mode
> [    1.621680] Freeing unused kernel memory: 428k freed
> [    1.621893] Write protecting the kernel text: 4168k
> [    1.621984] Write protecting the kernel read-only data: 1808k
> [    1.622046] NX-protecting the kernel data: 4024k
> [    1.701785] kjournald starting.  Commit interval 5 seconds
> [    1.701798] EXT3-fs (cciss/c0d0p2): mounted filesystem with writeback data mode
> [    1.915010] usb 5-1: new full-speed USB device number 2 using uhci_hcd
> [    2.075480] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb5/5-1/5-1:1.0/input/input1
> [    2.075573] generic-usb 0003:03F0:1027.0001: input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
> [    2.085184] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb5/5-1/5-1:1.1/input/input2
> [    2.085271] generic-usb 0003:03F0:1027.0002: input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
> [    4.542254] warning: process `kmodule' used the deprecated sysctl system call with 1.23.
> [    4.561910] kmodule[2544]: segfault at 0 ip 0805b884 sp bf923c20 error 4 in kmodule[8047000+23000]
> [    4.679234] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
> [    4.679238] bonding: MII link monitoring set to 100 ms
> [    4.779454] tg3.c:v3.122 (December 7, 2011)
> [    4.789011] tg3 0000:14:04.0: eth2: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:1e:0b:92:78:50
> [    4.789015] tg3 0000:14:04.0: eth2: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
> [    4.789018] tg3 0000:14:04.0: eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> [    4.789020] tg3 0000:14:04.0: eth2: dma_rwctrl[76148000] dma_mask[64-bit]
> [    4.799687] tg3 0000:14:04.1: eth3: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:1e:0b:92:78:51
> [    4.799691] tg3 0000:14:04.1: eth3: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
> [    4.799694] tg3 0000:14:04.1: eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> [    4.799696] tg3 0000:14:04.1: eth3: dma_rwctrl[76148000] dma_mask[64-bit]
> [    6.016388] EXT3-fs (cciss/c0d0p2): using internal journal
> [    6.447425] kjournald starting.  Commit interval 5 seconds
> [    6.447900] EXT3-fs (cciss/c0d0p6): using internal journal
> [    6.447903] EXT3-fs (cciss/c0d0p6): mounted filesystem with writeback data mode
> [    6.459557] kjournald starting.  Commit interval 5 seconds
> [    6.460030] EXT3-fs (cciss/c0d0p1): using internal journal
> [    6.460032] EXT3-fs (cciss/c0d0p1): mounted filesystem with writeback data mode
> [    6.461575] kjournald starting.  Commit interval 5 seconds
> [    6.462053] EXT3-fs (cciss/c0d0p7): using internal journal
> [    6.462055] EXT3-fs (cciss/c0d0p7): mounted filesystem with writeback data mode
> [    6.462977] kjournald starting.  Commit interval 5 seconds
> [    6.463401] EXT3-fs (cciss/c0d0p3): using internal journal
> [    6.463403] EXT3-fs (cciss/c0d0p3): mounted filesystem with writeback data mode
> [    6.991582] Adding 4192928k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:4192928k
> [    7.891855] NET: Registered protocol family 17
> [    8.082351] bnx2 0000:03:00.0: irq 42 for MSI/MSI-X
> [    8.170009] bnx2 0000:03:00.0: eth0: using MSI
> [    8.170111] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   11.293698] bnx2 0000:03:00.0: eth0: NIC SerDes Link is Up, 1000 Mbps full duplex
> [   11.293849] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   21.618006] eth0: no IPv6 routers present
> [   31.065725] bnx2 0000:07:00.0: irq 43 for MSI/MSI-X
> [   31.153009] bnx2 0000:07:00.0: eth1: using MSI
> [   31.153119] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   31.252066] bnx2 0000:03:00.0: irq 42 for MSI/MSI-X
> [   31.371006] bnx2 0000:03:00.0: eth0: using MSI
> [   31.371103] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   31.372624] tg3 0000:14:04.0: irq 44 for MSI/MSI-X
> [   31.401193] ADDRCONF(NETDEV_UP): eth2: link is not ready
> [   34.291661] bnx2 0000:07:00.0: eth1: NIC SerDes Link is Up, 1000 Mbps full duplex
> [   34.291810] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [   34.420125] bnx2 0000:03:00.0: eth0: NIC SerDes Link is Up, 1000 Mbps full duplex
> [   34.420263] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   34.740991] tg3 0000:14:04.0: eth2: Link is up at 1000 Mbps, full duplex
> [   34.740993] tg3 0000:14:04.0: eth2: Flow control is off for TX and off for RX
> [   34.741072] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> [   35.407703] bonding: bond0: Setting MII monitoring interval to 100.
> [   35.407788] bonding: bond0: setting mode to active-backup (1).
> [   35.408235] ADDRCONF(NETDEV_UP): bond0: link is not ready
> [   35.408237] 8021q: adding VLAN 0 to HW filter on device bond0
> [   35.544614] bnx2 0000:07:00.0: irq 43 for MSI/MSI-X
> [   35.663005] bnx2 0000:07:00.0: eth1: using MSI
> [   35.663104] bonding: bond0: enslaving eth1 as a backup interface with a down link.
> [   35.936065] tg3 0000:14:04.0: irq 44 for MSI/MSI-X
> [   35.963174] bonding: bond0: enslaving eth2 as a backup interface with a down link.
> [   35.966445] ADDRCONF(NETDEV_UP): vlan.103: link is not ready
> [   35.968758] ADDRCONF(NETDEV_UP): vlan.825: link is not ready
> [   36.049149] warning: `ntpdate' uses 32-bit capabilities (legacy support in use)
> [   38.670816] bnx2 0000:07:00.0: eth1: NIC SerDes Link is Up, 1000 Mbps full duplex
> [   38.708008] bonding: bond0: link status definitely up for interface eth1, 1000 Mbps full duplex.
> [   38.708012] bonding: bond0: making interface eth1 the new active one.
> [   38.708065] bonding: bond0: first active interface up!
> [   38.708141] ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
> [   38.708247] ADDRCONF(NETDEV_CHANGE): vlan.103: link becomes ready
> [   38.708330] ADDRCONF(NETDEV_CHANGE): vlan.825: link becomes ready
> [   38.810381] tg3 0000:14:04.0: eth2: Link is up at 1000 Mbps, full duplex
> [   38.810383] tg3 0000:14:04.0: eth2: Flow control is off for TX and off for RX
> [   38.908007] bonding: bond0: link status definitely up for interface eth2, 1000 Mbps full duplex.
> [   41.066010] bonding: bond0: link status definitely down for interface eth1, disabling it
> [   41.066014] bonding: bond0: making interface eth2 the new active one.
> [   44.450005] eth0: no IPv6 routers present
> [   49.050006] bond0: no IPv6 routers present
> [   49.226004] vlan.825: no IPv6 routers present
> [   49.618005] vlan.103: no IPv6 routers present
>
>
