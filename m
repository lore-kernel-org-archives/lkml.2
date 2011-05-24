Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab1EXE3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:29:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33437 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1EXE3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=rS+6hiycFh0dOMZfFcv3c7IR+XQNTqouwaK7N5IBVJ7RwkvgpxEpEK7Dc+eoujM8OE
         dHLcxweR08/BGIfzYluuMH8fyyiSCoPTN68I0HmXQWyISKiRZ25MorOqF/lZrw9F/UUh
         G1VNIOyzYeMDQA5OShSR1qi2OZa0IMEbgN8qU=
Date: Tue, 24 May 2011 00:29:05 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@natty-nar
To: linux-kernel@vger.kernel.org
cc: jaxboe@fusionio.com
Subject: __elv_add_request OOPS
Message-ID: <alpine.DEB.2.02.1105232329040.1910@natty-nar>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


External DVD drive - connected when suspended, removed before resume.
Results in NULL pointer dereference in __blk_add_request on resume.

*ffffffff811d6503:      48 89 58 08             mov    %rbx,0x8(%rax) |  
%ebx = ffff880131559020 <--- faulting instruction

48 89 58 08 appears only in list_add :

static inline void list_add(struct list_head *new, struct list_head *head)
{
        __list_add(new, head, head->next);
ffffffff81ac012c:       49 8b 04 24             mov    (%r12),%rax
#ifndef CONFIG_DEBUG_LIST
static inline void __list_add(struct list_head *new,
                              struct list_head *prev,
                              struct list_head *next)
{
        next->prev = new;
ffffffff81ac0130:       48 89 58 08             mov    %rbx,0x8(%rax)

AFAICS list_add is only called from one place in __elv_add_request :

       switch (where) {
        case ELEVATOR_INSERT_REQUEUE:
        case ELEVATOR_INSERT_FRONT:
                rq->cmd_flags |= REQ_SOFTBARRIER;
              **  list_add(&rq->queuelist, &q->queue_head);
                break;

Now, where is the patch? :)

Parag

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39+ (parag@natty-nar) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4) ) #4 SMP Mon May 23 09:50:31 EDT 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39+ root=UUID=0433b702-6d22-4465-a752-f3e5485dac09 ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bb63f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb63f000 - 00000000bb6bf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb6bf000 - 00000000bb7bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb7bf000 - 00000000bb7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 0876                            /Base Board Product Name, BIOS 37CN18WW(V1.04) 01/25/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-combining
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0BB800000 mask FFF800000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 138000000 mask FF8000000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb800 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
[    0.000000]  0000000000 - 00bb800000 page 2M
[    0.000000] kernel direct mapping tables up to bb800000 @ bb63b000-bb63f000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 2M
[    0.000000] kernel direct mapping tables up to 138000000 @ 137ffa000-138000000
[    0.000000] RAMDISK: 35fa4000 - 36fca000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bb7fe120 00084 (v01 LENOVO CB-01    00000001      01000013)
[    0.000000] ACPI: FACP 00000000bb7fc000 000F4 (v04 LENOVO CB-01    00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 00000000bb7ee000 0AFDE (v02 LENOVO CB-01    00000001 MSFT 01000013)
[    0.000000] ACPI: FACS 00000000bb76a000 00040
[    0.000000] ACPI: ASF! 00000000bb7fd000 000A5 (v32 INTEL  Calpella 00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 00000000bb7fb000 00038 (v01 LENOVO CB-01    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 00000000bb7fa000 0008C (v02 INTEL  Calpella 00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 00000000bb7f9000 0003C (v01 LENOVO CB-01    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 00000000bb7ed000 00176 (v01 LENOVO CB-01    00000001 MSFT 01000013)
[    0.000000] ACPI: BOOT 00000000bb7ea000 00028 (v01 INTEL  Calpella 00000001 MSFT 01000013)
[    0.000000] ACPI: ASPT 00000000bb7e7000 00034 (v04 INTEL  Calpella 00000001 MSFT 01000013)
[    0.000000] ACPI: WDAT 00000000bb7e6000 00224 (v01 INTEL  Calpella 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bb7e5000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000bb7e4000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000bb7e3000 0049F (v01  PmRef    ApTst 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880128200000-ffff88012b9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bb63f
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 996813
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 749176 pages, LIFO batch:31
[    0.000000]   Normal zone: 3136 pages used for memmap
[    0.000000]   Normal zone: 226240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bb63f000 - 00000000bb6bf000
[    0.000000] PM: Registered nosave memory: 00000000bb6bf000 - 00000000bb7bf000
[    0.000000] PM: Registered nosave memory: 00000000bb7bf000 - 00000000bb7ff000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1b000
[    0.000000] PM: Registered nosave memory: 00000000fed1b000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880137c00000 s82752 r8192 d23744 u262144
[    0.000000] pcpu-alloc: s82752 r8192 d23744 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 979336
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.39+ root=UUID=0433b702-6d22-4465-a752-f3e5485dac09 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3827640k/5111808k available (4645k kernel code, 1124556k absent, 159612k reserved, 6126k data, 760k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 32505856 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 1330.019 MHz processor.
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 2661.87 BogoMIPS (lpj=4433396)
[    0.000011] pid_max: default: 32768 minimum: 301
[    0.000053] Security Framework initialized
[    0.000069] Mount-cache hash table entries: 256
[    0.000222] Initializing cgroup subsys ns
[    0.000227] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.000230] Initializing cgroup subsys cpuacct
[    0.000237] Initializing cgroup subsys memory
[    0.000246] Initializing cgroup subsys devices
[    0.000249] Initializing cgroup subsys freezer
[    0.000252] Initializing cgroup subsys net_cls
[    0.000279] CPU: Physical Processor ID: 0
[    0.000281] CPU: Processor Core ID: 0
[    0.000288] mce: CPU supports 9 MCE banks
[    0.000304] CPU0: Thermal monitoring enabled (TM1)
[    0.000314] using mwait in idle threads.
[    0.003354] ACPI: Core revision 20110316
[    0.184385] ftrace: allocating 18717 entries in 74 pages
[    0.193049] Setting APIC routing to flat
[    0.193465] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.226432] CPU0: Intel(R) Core(TM) i5 CPU       U 470  @ 1.33GHz stepping 05
[    0.332814] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.332823] ... version:                3
[    0.332825] ... bit width:              48
[    0.332827] ... generic registers:      4
[    0.332829] ... value mask:             0000ffffffffffff
[    0.332831] ... max period:             000000007fffffff
[    0.332833] ... fixed-purpose events:   3
[    0.332834] ... event mask:             000000070000000f
[    0.333369] NMI watchdog enabled, takes one hw-pmu counter.
[    0.333496] Booting Node   0, Processors  #1
[    0.333500] smpboot cpu 1: start_ip = 98000
[    0.446177] NMI watchdog enabled, takes one hw-pmu counter.
[    0.446328]  #2
[    0.446331] smpboot cpu 2: start_ip = 98000
[    0.559385] NMI watchdog enabled, takes one hw-pmu counter.
[    0.559530]  #3
[    0.559532] smpboot cpu 3: start_ip = 98000
[    0.672588] NMI watchdog enabled, takes one hw-pmu counter.
[    0.672638] Brought up 4 CPUs
[    0.672641] Total of 4 processors activated (10644.35 BogoMIPS).
[    0.675300] devtmpfs: initialized
[    0.675465] PM: Registering ACPI NVS region at bb6bf000 (1048576 bytes)
[    0.676675] print_constraints: dummy: 
[    0.676706] Time: 15:15:24  Date: 05/23/11
[    0.676746] NET: Registered protocol family 16
[    0.676844] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.676847] ACPI: bus type pci registered
[    0.676943] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.676948] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.729391] PCI: Using configuration type 1 for base access
[    0.730050] bio: create slab <bio-0> at 0
[    0.733723] ACPI: EC: Look up EC in DSDT
[    0.737215] ACPI: Executed 1 blocks of module-level executable AML code
[    0.759212] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.761159] ACPI: SSDT 00000000bb691a98 00300 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.762023] ACPI: Dynamic OEM Table Load:
[    0.762027] ACPI: SSDT           (null) 00300 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.762282] ACPI: SSDT 00000000bb690018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.763141] ACPI: Dynamic OEM Table Load:
[    0.763145] ACPI: SSDT           (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.782863] ACPI: SSDT 00000000bb691718 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.783791] ACPI: Dynamic OEM Table Load:
[    0.783795] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.792522] ACPI: SSDT 00000000bb68fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.793402] ACPI: Dynamic OEM Table Load:
[    0.793406] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.804201] ACPI: Interpreter enabled
[    0.804205] ACPI: (supports S0 S3 S4 S5)
[    0.804257] ACPI: Using IOAPIC for interrupt routing
[    0.849935] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.849976] HEST: Table not found.
[    0.849981] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.850483] \_SB_.PCI0:_OSC invalid UUID
[    0.850485] _OSC request data:1 8 1f 
[    0.850491] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.851303] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.851307] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.851310] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.851314] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfeafffff]
[    0.851331] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.851359] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.851386] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.851403] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd03fffff 64bit]
[    0.851413] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.851420] pci 0000:00:02.0: reg 20: [io  0x4078-0x407f]
[    0.851502] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.851541] pci 0000:00:16.0: reg 10: [mem 0xd6407100-0xd640710f 64bit]
[    0.851640] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.851646] pci 0000:00:16.0: PME# disabled
[    0.851699] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.852258] pci 0000:00:1a.0: reg 10: [mem 0xd6406c00-0xd6406fff]
[    0.855229] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.855236] pci 0000:00:1a.0: PME# disabled
[    0.855279] pci 0000:00:1b.0: [8086:3b57] type 0 class 0x000403
[    0.855306] pci 0000:00:1b.0: reg 10: [mem 0xd6400000-0xd6403fff 64bit]
[    0.855401] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.855408] pci 0000:00:1b.0: PME# disabled
[    0.855437] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.855538] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.855545] pci 0000:00:1c.0: PME# disabled
[    0.855578] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.855681] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.855687] pci 0000:00:1c.1: PME# disabled
[    0.855723] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
[    0.855820] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.855826] pci 0000:00:1c.2: PME# disabled
[    0.855874] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.856391] pci 0000:00:1d.0: reg 10: [mem 0xd6406800-0xd6406bff]
[    0.859390] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.859397] pci 0000:00:1d.0: PME# disabled
[    0.859430] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.859523] pci 0000:00:1f.0: [8086:3b0f] type 0 class 0x000601
[    0.859670] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.859702] pci 0000:00:1f.2: reg 10: [io  0x4058-0x405f]
[    0.859717] pci 0000:00:1f.2: reg 14: [io  0x4084-0x4087]
[    0.859732] pci 0000:00:1f.2: reg 18: [io  0x4050-0x4057]
[    0.859746] pci 0000:00:1f.2: reg 1c: [io  0x4080-0x4083]
[    0.859759] pci 0000:00:1f.2: reg 20: [io  0x4020-0x403f]
[    0.859774] pci 0000:00:1f.2: reg 24: [mem 0xd6406000-0xd64067ff]
[    0.859832] pci 0000:00:1f.2: PME# supported from D3hot
[    0.859838] pci 0000:00:1f.2: PME# disabled
[    0.859865] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.859891] pci 0000:00:1f.3: reg 10: [mem 0xd6407000-0xd64070ff 64bit]
[    0.859929] pci 0000:00:1f.3: reg 20: [io  0x4000-0x401f]
[    0.859985] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.860020] pci 0000:00:1f.6: reg 10: [mem 0xd6404000-0xd6404fff 64bit]
[    0.860190] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.860196] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.860202] pci 0000:00:1c.0:   bridge window [mem 0xd5400000-0xd63fffff]
[    0.860211] pci 0000:00:1c.0:   bridge window [mem 0xd0400000-0xd13fffff 64bit pref]
[    0.860413] pci 0000:02:00.0: [8086:0084] type 0 class 0x000280
[    0.860528] pci 0000:02:00.0: reg 10: [mem 0xd4400000-0xd4401fff 64bit]
[    0.861145] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.861182] pci 0000:02:00.0: PME# disabled
[    0.861341] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.861348] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.861354] pci 0000:00:1c.1:   bridge window [mem 0xd4400000-0xd53fffff]
[    0.861363] pci 0000:00:1c.1:   bridge window [mem 0xd1400000-0xd23fffff 64bit pref]
[    0.861455] pci 0000:03:00.0: [1969:1073] type 0 class 0x000200
[    0.861488] pci 0000:03:00.0: reg 10: [mem 0xd3400000-0xd343ffff 64bit]
[    0.861506] pci 0000:03:00.0: reg 18: [io  0x1000-0x107f]
[    0.861620] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.861626] pci 0000:03:00.0: PME# disabled
[    0.861670] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.861676] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.861682] pci 0000:00:1c.2:   bridge window [mem 0xd3400000-0xd43fffff]
[    0.861691] pci 0000:00:1c.2:   bridge window [mem 0xd2400000-0xd33fffff 64bit pref]
[    0.861784] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.861791] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.861797] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.861807] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.861810] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.861813] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.861816] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.861819] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfeafffff] (subtractive decode)
[    0.861851] pci_bus 0000:00: on NUMA node 0
[    0.861856] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.862041] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.862125] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.862176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.862236] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.862371] \_SB_.PCI0:_OSC invalid UUID
[    0.862374] _OSC request data:1 1f 1f 
[    0.862380]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.862425] \_SB_.PCI0:_OSC invalid UUID
[    0.862427] _OSC request data:1 0 1d 
[    0.862431] Unable to assume _OSC PCIe control. Disabling ASPM
[    0.872022] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.872095] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.872124] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.872153] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.872184] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.872211] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.872236] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.872276] pci_bus 0000:ff: on NUMA node 0
[    0.872287]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.872290] Unable to assume _OSC PCIe control. Disabling ASPM
[    0.872565] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.872626] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.872686] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.872746] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.872805] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.872867] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.872928] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.872987] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.873092] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.873104] vgaarb: loaded
[    0.873188] SCSI subsystem initialized
[    0.873234] usbcore: registered new interface driver usbfs
[    0.873247] usbcore: registered new interface driver hub
[    0.873297] usbcore: registered new device driver usb
[    0.873502] wmi: Mapper loaded
[    0.873504] PCI: Using ACPI for IRQ routing
[    0.873507] PCI: pci_cache_line_size set to 64 bytes
[    0.873606] reserve RAM buffer: 000000000009d000 - 000000000009ffff 
[    0.873609] reserve RAM buffer: 00000000bb63f000 - 00000000bbffffff 
[    0.873612] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff 
[    0.873716] NetLabel: Initializing
[    0.873718] NetLabel:  domain hash size = 128
[    0.873720] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.873735] NetLabel:  unlabeled traffic allowed by default
[    0.873779] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.873788] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.875820] Switching to clocksource hpet
[    0.878854] Switched to NOHz mode on CPU #0
[    0.878970] Switched to NOHz mode on CPU #1
[    0.878986] Switched to NOHz mode on CPU #2
[    0.878999] Switched to NOHz mode on CPU #3
[    0.882089] pnp: PnP ACPI init
[    0.882108] ACPI: bus type pnp registered
[    0.882628] pnp 00:00: [bus 00-fe]
[    0.882632] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.882634] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.882637] pnp 00:00: [io  0x0d00-0xffff window]
[    0.882640] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.882643] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.882645] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.882648] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.882650] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.882653] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.882655] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.882658] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.882660] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.882663] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.882665] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.882668] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.882670] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.882673] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.882676] pnp 00:00: [mem 0xc0000000-0xfeafffff window]
[    0.882678] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.882681] pnp 00:00: [io  0x0068-0x006f]
[    0.882683] pnp 00:00: [io  0x0700-0x0707]
[    0.882790] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.902601] pnp 00:01: [io  0x0000-0x001f]
[    0.902604] pnp 00:01: [io  0x0081-0x0091]
[    0.902606] pnp 00:01: [io  0x0093-0x009f]
[    0.902608] pnp 00:01: [io  0x00c0-0x00df]
[    0.902611] pnp 00:01: [dma 4]
[    0.902648] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.902659] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.902693] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.902819] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.902854] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.902868] pnp 00:04: [io  0x00f0]
[    0.902883] pnp 00:04: [irq 13]
[    0.902917] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.902932] pnp 00:05: [io  0x002e-0x002f]
[    0.902935] pnp 00:05: [io  0x004e-0x004f]
[    0.902937] pnp 00:05: [io  0x0061]
[    0.902939] pnp 00:05: [io  0x0063]
[    0.902941] pnp 00:05: [io  0x0065]
[    0.902943] pnp 00:05: [io  0x0067]
[    0.902946] pnp 00:05: [io  0x0068-0x006f]
[    0.902949] pnp 00:05: [io  0x0070]
[    0.902951] pnp 00:05: [io  0x0080]
[    0.902953] pnp 00:05: [io  0x0092]
[    0.902955] pnp 00:05: [io  0x00b2-0x00b3]
[    0.902957] pnp 00:05: [io  0x0680-0x069f]
[    0.902959] pnp 00:05: [io  0x0800-0x080f]
[    0.902962] pnp 00:05: [io  0xffff]
[    0.902964] pnp 00:05: [io  0xffff]
[    0.902966] pnp 00:05: [io  0x0400-0x047f]
[    0.902968] pnp 00:05: [io  0x0500-0x057f]
[    0.902970] pnp 00:05: [io  0x164e-0x164f]
[    0.902992] pnp 00:05: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
[    0.903051] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.903055] system 00:05: [io  0x0800-0x080f] has been reserved
[    0.903058] system 00:05: [io  0xffff] has been reserved
[    0.903061] system 00:05: [io  0xffff] has been reserved
[    0.903064] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.903067] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.903071] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.903082] pnp 00:06: [io  0x0070-0x0077]
[    0.903090] pnp 00:06: [irq 8]
[    0.903122] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.903148] pnp 00:07: [irq 12]
[    0.903186] pnp 00:07: Plug and Play ACPI device, IDs SYN0729 SYN0700 SYN0002 PNP0f13 (active)
[    0.903197] pnp 00:08: [io  0x0060]
[    0.903200] pnp 00:08: [io  0x0064]
[    0.903206] pnp 00:08: [irq 1]
[    0.903241] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.903859] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.903862] pnp 00:09: [mem 0xfed10000-0xfed13fff]
[    0.903865] pnp 00:09: [mem 0xfed18000-0xfed18fff]
[    0.903867] pnp 00:09: [mem 0xfed19000-0xfed19fff]
[    0.903869] pnp 00:09: [mem 0xe0000000-0xefffffff]
[    0.903872] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    0.903874] pnp 00:09: [mem 0xfed90000-0xfed8ffff disabled]
[    0.903877] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    0.903879] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.903882] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    0.903884] pnp 00:09: [mem 0xd6500000-0xd6500fff]
[    0.903961] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.903965] system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.903968] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.903971] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.903975] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.903978] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.903981] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.903985] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    0.903988] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.903992] system 00:09: [mem 0xd6500000-0xd6500fff] has been reserved
[    0.903996] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.904180] pnp 00:0a: [bus ff]
[    0.904233] pnp 00:0a: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.904256] pnp: PnP ACPI: found 11 devices
[    0.904258] ACPI: ACPI bus type pnp unregistered
[    0.910318] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.910324] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.910332] pci 0000:00:1c.0:   bridge window [mem 0xd5400000-0xd63fffff]
[    0.910339] pci 0000:00:1c.0:   bridge window [mem 0xd0400000-0xd13fffff 64bit pref]
[    0.910349] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.910354] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.910361] pci 0000:00:1c.1:   bridge window [mem 0xd4400000-0xd53fffff]
[    0.910368] pci 0000:00:1c.1:   bridge window [mem 0xd1400000-0xd23fffff 64bit pref]
[    0.910378] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.910383] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.910390] pci 0000:00:1c.2:   bridge window [mem 0xd3400000-0xd43fffff]
[    0.910396] pci 0000:00:1c.2:   bridge window [mem 0xd2400000-0xd33fffff 64bit pref]
[    0.910406] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.910409] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.910416] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.910422] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.910449] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.910457] pci 0000:00:1c.0: setting latency timer to 64
[    0.910471] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.910477] pci 0000:00:1c.1: setting latency timer to 64
[    0.910493] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.910500] pci 0000:00:1c.2: setting latency timer to 64
[    0.910511] pci 0000:00:1e.0: setting latency timer to 64
[    0.910517] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.910520] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.910523] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.910525] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfeafffff]
[    0.910529] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.910531] pci_bus 0000:01: resource 1 [mem 0xd5400000-0xd63fffff]
[    0.910534] pci_bus 0000:01: resource 2 [mem 0xd0400000-0xd13fffff 64bit pref]
[    0.910537] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.910540] pci_bus 0000:02: resource 1 [mem 0xd4400000-0xd53fffff]
[    0.910543] pci_bus 0000:02: resource 2 [mem 0xd1400000-0xd23fffff 64bit pref]
[    0.910546] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.910549] pci_bus 0000:03: resource 1 [mem 0xd3400000-0xd43fffff]
[    0.910552] pci_bus 0000:03: resource 2 [mem 0xd2400000-0xd33fffff 64bit pref]
[    0.910555] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.910558] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.910560] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.910563] pci_bus 0000:04: resource 7 [mem 0xc0000000-0xfeafffff]
[    0.910607] NET: Registered protocol family 2
[    0.910691] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.911134] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.912660] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.913067] TCP: Hash tables configured (established 262144 bind 65536)
[    0.913071] TCP reno registered
[    0.913075] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.913102] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.913281] NET: Registered protocol family 1
[    0.913305] pci 0000:00:02.0: Boot video device
[    0.939236] PCI: CLS 64 bytes, default 64
[    0.939304] Trying to unpack rootfs image as initramfs...
[    1.367266] Freeing initrd memory: 16536k freed
[    1.372375] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.372383] Placing 64MB software IO TLB between ffff8800b763b000 - ffff8800bb63b000
[    1.372386] software IO TLB at phys 0xb763b000 - 0xbb63b000
[    1.372434] Simple Boot Flag at 0x44 set to 0x1
[    1.373063] audit: initializing netlink socket (disabled)
[    1.373087] type=2000 audit(1306163725.056:1): initialized
[    1.395351] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.397498] VFS: Disk quotas dquot_6.5.2
[    1.397559] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.397653] msgmni has been set to 7508
[    1.397928] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.397932] io scheduler noop registered
[    1.397934] io scheduler deadline registered (default)
[    1.398258] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.398284] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.398304] intel_idle: MWAIT substates: 0x1120
[    1.398306] intel_idle: v0.4 model 0x25
[    1.398308] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.398624] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.398859] ACPI: AC Adapter [ACAD] (on-line)
[    1.398976] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/PNP0C0C:00/input/input0
[    1.398984] ACPI: Power Button [PWRB]
[    1.399027] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/PNP0C0E:00/input/input1
[    1.399031] ACPI: Sleep Button [SLPB]
[    1.399111] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/PNP0C0D:00/input/input2
[    1.399210] ACPI: Lid Switch [LID0]
[    1.399294] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.399318] ACPI: Power Button [PWRF]
[    1.399583] ACPI: acpi_idle yielding to intel_idle
[    1.423565] ACPI: Invalid active0 threshold
[    1.423656] thermal LNXTHERM:00: registered as thermal_zone0
[    1.423659] ACPI: Thermal Zone [TZ00] (27 C)
[    1.423673] ERST: Table is not found!
[    1.423746] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.513839] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.513847] ACPI: Battery Slot [BAT1] (battery present)
[    1.513985] Linux agpgart interface v0.103
[    1.514086] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.514231] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.515286] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.515488] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.516622] brd: module loaded
[    1.517139] loop: module loaded
[    1.517533] Fixed MDIO Bus: probed
[    1.517624] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.517651] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.517677] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.517682] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.517719] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.517756] ehci_hcd 0000:00:1a.0: debug port 2
[    1.521675] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.521700] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd6406c00
[    1.535118] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.535268] hub 1-0:1.0: USB hub found
[    1.535274] hub 1-0:1.0: 3 ports detected
[    1.535360] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.535377] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.535381] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.535421] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.535452] ehci_hcd 0000:00:1d.0: debug port 2
[    1.539339] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.539356] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd6406800
[    1.551761] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.551909] hub 2-0:1.0: USB hub found
[    1.551914] hub 2-0:1.0: 3 ports detected
[    1.551979] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.551991] uhci_hcd: USB Universal Host Controller Interface driver
[    1.552073] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
[    1.593728] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.593737] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.593848] mousedev: PS/2 mouse device common for all mice
[    1.595892] rtc_cmos 00:06: RTC can wake from S4
[    1.595996] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.596029] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.596094] device-mapper: uevent: version 1.0.3
[    1.596158] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    1.596252] device-mapper: multipath: version 1.3.0 loaded
[    1.596256] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.596425] cpuidle: using governor ladder
[    1.596604] cpuidle: using governor menu
[    1.596872] TCP cubic registered
[    1.596968] NET: Registered protocol family 10
[    1.597515] NET: Registered protocol family 17
[    1.597532] Registering the dns_resolver key type
[    1.597633] PM: Hibernation image not present or could not be loaded.
[    1.598317]   Magic number: 11:33:286
[    1.598527] rtc_cmos 00:06: setting system clock to 2011-05-23 15:15:25 UTC (1306163725)
[    1.600585] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.600587] EDD information not available.
[    1.602488] Freeing unused kernel memory: 760k freed
[    1.602632] Write protecting the kernel read-only data: 10240k
[    1.609045] Freeing unused kernel memory: 1480k freed
[    1.617503] Freeing unused kernel memory: 2024k freed
[    1.633259] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.640916] udev[75]: starting version 167
[    1.667748] atl1c 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.667767] atl1c 0000:03:00.0: setting latency timer to 64
[    1.676279] [drm] Initialized drm 1.1.0 20060810
[    1.680945] libata version 3.00 loaded.
[    1.682496] ahci 0000:00:1f.2: version 3.0
[    1.682533] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.682623] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    1.682678] ahci: SSS flag set, parallel bus scan disabled
[    1.682721] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x1 impl SATA mode
[    1.682727] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag led clo pio slum part ems apst 
[    1.682738] ahci 0000:00:1f.2: setting latency timer to 64
[    1.684300] scsi0 : ahci
[    1.684786] scsi1 : ahci
[    1.684891] scsi2 : ahci
[    1.685038] scsi3 : ahci
[    1.685773] scsi4 : ahci
[    1.687941] scsi5 : ahci
[    1.688053] ata1: SATA max UDMA/133 abar m2048@0xd6406000 port 0xd6406100 irq 40
[    1.688059] ata2: DUMMY
[    1.688062] ata3: DUMMY
[    1.688065] ata4: DUMMY
[    1.688067] ata5: DUMMY
[    1.688070] ata6: DUMMY
[    1.688155] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.688164] i915 0000:00:02.0: setting latency timer to 64
[    1.762211] i915 0000:00:02.0: irq 41 for MSI/MSI-X
[    1.762219] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.762221] [drm] Driver supports precise vblank timestamp query.
[    1.782340] atl1c 0000:03:00.0: version 1.0.1.0-NAPI
[    1.841465] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    1.965544] hub 1-1:1.0: USB hub found
[    1.965653] hub 1-1:1.0: 6 ports detected
[    1.982632] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.004706] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.005846] ata1.00: ATA-8: HITACHI HTS543232A7A384, ES2ZB90A, max UDMA/100
[    2.005851] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.007068] ata1.00: configured for UDMA/100
[    2.007352] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS54323 ES2Z PQ: 0 ANSI: 5
[    2.007621] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.007688] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.007840] sd 0:0:0:0: [sda] Write Protect is off
[    2.007867] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.007939] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.008290] sda: detected capacity change from 0 to 320072933376
[    2.037950]  sda: sda1 sda2 < sda5 sda6 >
[    2.038448] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.071269] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    2.134468] [drm] GMBUS timed out, falling back to bit banging on pin 4 [i915 gmbus dpc]
[    2.156122] fbcon: inteldrmfb (fb0) is primary device
[    2.195270] hub 2-1:1.0: USB hub found
[    2.195343] hub 2-1:1.0: 8 ports detected
[    2.277831] usb 1-1.4: new full speed USB device number 3 using ehci_hcd
[    2.316030] Console: switching to colour frame buffer device 170x48
[    2.319374] fb0: inteldrmfb frame buffer device
[    2.319376] drm: registered panic notifier
[    2.337385] acpi device:02: registered as cooling_device4
[    2.337795] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    2.337872] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.337949] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.374186] Refined TSC clocksource calibration: 1329.999 MHz.
[    2.374204] Switching to clocksource tsc
[    2.460924] usb 2-1.3: new high speed USB device number 3 using ehci_hcd
[    2.817938] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   14.292076] Adding 7999484k swap on /dev/sda5.  Priority:-1 extents:1 across:7999484k 
[   14.318351] udev[353]: starting version 167
[   14.471971] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 11, expected 14)
[   14.472009] intel ips 0000:00:1f.6: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   14.473303] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   14.506513] lp: driver loaded but no devices found
[   14.605809] input: Ideapad extra buttons as /devices/platform/ideapad/input/input6
[   14.671769] Linux video capture interface: v2.00
[   14.699048] Bluetooth: Core ver 2.16
[   14.699085] NET: Registered protocol family 31
[   14.699089] Bluetooth: HCI device and connection manager initialized
[   14.699093] Bluetooth: HCI socket layer initialized
[   14.718845] uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (5986:0195)
[   14.723102] input: Lenovo EasyCamera as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input7
[   14.723296] usbcore: registered new interface driver uvcvideo
[   14.723300] USB Video Class driver (v1.0.0)
[   14.723651] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   14.723892] usbcore: registered new interface driver btusb
[   14.749729] cfg80211: Calling CRDA to update world regulatory domain
[   14.930587] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   14.930593] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[   14.930939] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.930949] iwlagn 0000:02:00.0: setting latency timer to 64
[   14.930988] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   14.947108] cfg80211: World regulatory domain updated:
[   14.947112] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.947116] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.947120] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.947123] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.947126] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.947131] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.950675] iwlagn 0000:02:00.0: device EEPROM VER=0x15d, CALIB=0x6
[   14.950679] iwlagn 0000:02:00.0: Device SKU: 0X9
[   14.950681] iwlagn 0000:02:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[   14.950691] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
[   14.950778] iwlagn 0000:02:00.0: irq 42 for MSI/MSI-X
[   14.984536] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   14.984547] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   14.984578] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   14.984675] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   14.984720] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.984944] iwlagn 0000:02:00.0: loaded firmware version 39.31.5.1 build 35138
[   14.985280] Registered led device: phy0-led
[   15.059502] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.123548] hda_codec: ALC269VB: BIOS auto-probing.
[   15.140898] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   15.141014] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   15.146909] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro
[   15.530580] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   16.084157] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000
[   16.126527] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   16.158616] atl1c 0000:03:00.0: irq 44 for MSI/MSI-X
[   16.193912] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input10
[   16.238374] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.898667] ppdev: user-space parallel port driver
[   17.724357] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[   17.726945] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   33.076729] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[   33.083202] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   56.874971] fuse init (API version 7.16)
[   85.946451] wlan%d: authenticate with 98:fc:11:8e:c9:ea (try 1)
[   85.949242] wlan%d: authenticated
[   85.949389] wlan%d: waiting for beacon from 98:fc:11:8e:c9:ea
[   86.007151] wlan%d: beacon received
[   86.036807] wlan%d: associate with 98:fc:11:8e:c9:ea (try 1)
[   86.040213] wlan%d: RX AssocResp from 98:fc:11:8e:c9:ea (capab=0x411 status=0 aid=6)
[   86.040225] wlan%d: associated
[   86.045110] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   86.479671] Intel AES-NI instructions are not detected.
[   86.555302] padlock_aes: VIA PadLock not detected.
[   96.483988] wlan0: no IPv6 routers present
[ 1863.102058] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 2
[ 2131.822161] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 98:fc:11:8e:c9:ea tid = 0
[ 7958.806306] wlan%d: deauthenticated from 98:fc:11:8e:c9:ea (Reason: 7)
[ 7958.811375] iwlagn 0000:02:00.0: Stopping AGG while state not ON or starting
[ 7958.837072] cfg80211: Calling CRDA to update world regulatory domain
[ 7958.844191] cfg80211: World regulatory domain updated:
[ 7958.844200] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 7958.844209] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7958.844218] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 7958.844225] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 7958.844233] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7958.844240] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 7964.889363] wlan%d: authenticate with 98:fc:11:8e:c9:ea (try 1)
[ 7964.892254] wlan%d: authenticated
[ 7964.892403] wlan%d: waiting for beacon from 98:fc:11:8e:c9:ea
[ 7964.913451] wlan%d: beacon received
[ 7964.917833] wlan%d: associate with 98:fc:11:8e:c9:ea (try 1)
[ 7964.921102] wlan%d: RX AssocResp from 98:fc:11:8e:c9:ea (capab=0x411 status=0 aid=6)
[ 7964.921115] wlan%d: associated
[ 9054.270670] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 0
[10851.808791] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 1
[12055.147786] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 0
[12062.068790] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 0
[12069.092474] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 0
[12077.387109] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 0
[12184.286708] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 1
[12188.576867] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 2
[12193.310005] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 5
[12196.399039] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 98:fc:11:8e:c9:ea tid = 0
[13718.430495] exe (5524): /proc/5524/oom_adj is deprecated, please use /proc/5524/oom_score_adj instead.
[14396.777039] perf[11375]: segfault at fffffffffffffff8 ip 0000000000418efd sp 00007fffbbffd770 error 4 in perf[400000+91000]
[16735.144852] process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
[18064.447939] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[18070.988616] keyboard: can't emulate rawmode for keycode 240
[18070.988638] keyboard: can't emulate rawmode for keycode 240
[18071.661562] wlan%d: deauthenticating from 98:fc:11:8e:c9:ea by local choice (reason=3)
[18071.736637] cfg80211: Calling CRDA to update world regulatory domain
[18071.898292] cfg80211: World regulatory domain updated:
[18071.898299] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[18071.898303] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[18071.898307] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[18071.898310] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[18071.898314] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[18071.898318] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[18074.082863] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[18074.088451] EXT4-fs (sda1): re-mounted. Opts: commit=0
[18075.903057] PM: Syncing filesystems ... done.
[18075.930608] PM: Preparing system for mem sleep
[18076.041579] Freezing user space processes ... (elapsed 0.01 seconds) done.
[18076.054682] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[18076.067989] PM: Entering mem sleep
[18076.068104] Suspending console(s) (use no_console_suspend to debug)
[18076.068847] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[18076.069063] sd 0:0:0:0: [sda] Stopping disk
[18076.201144] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[18076.201260] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[18076.394581] HDA Intel 0000:00:1b.0: PCI INT A disabled
[18076.407593] HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
[18076.597445] PM: suspend of devices complete after 529.629 msecs
[18076.650659] PM: late suspend of devices complete after 53.275 msecs
[18076.650918] ACPI: Preparing to enter system sleep state S3
[18076.667422] PM: Saving platform NVS memory
[18076.672054] Disabling non-boot CPUs ...
[18076.674200] CPU 1 is now offline
[18076.777106] CPU 2 is now offline
[18076.778443] Broke affinity for irq 1
[18076.778472] Broke affinity for irq 23
[18076.880313] CPU 3 is now offline
[18076.880851] Extended CMOS year: 2000
[18076.881113] ACPI: Low-level resume complete
[18076.881191] PM: Restoring platform NVS memory
[18076.881892] Extended CMOS year: 2000
[18076.881942] Enabling non-boot CPUs ...
[18076.882074] Booting Node 0 Processor 1 APIC 0x1
[18076.882077] smpboot cpu 1: start_ip = 98000
[18076.995017] NMI watchdog enabled, takes one hw-pmu counter.
[18076.995711] CPU1 is up
[18076.995997] Booting Node 0 Processor 2 APIC 0x4
[18076.995999] smpboot cpu 2: start_ip = 98000
[18076.997793] Switched to NOHz mode on CPU #1
[18077.108342] NMI watchdog enabled, takes one hw-pmu counter.
[18077.108806] CPU2 is up
[18077.108945] Booting Node 0 Processor 3 APIC 0x5
[18077.108948] smpboot cpu 3: start_ip = 98000
[18077.110989] Switched to NOHz mode on CPU #2
[18077.221706] NMI watchdog enabled, takes one hw-pmu counter.
[18077.222242] CPU3 is up
[18077.224749] Switched to NOHz mode on CPU #3
[18077.225246] ACPI: Waking up from system sleep state S3
[18077.274409] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[18077.274463] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x180006, writing 0x100006)
[18077.274518] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[18077.274579] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[18077.274630] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20003030, writing 0x3030)
[18077.274825] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[18077.274863] pci 0000:00:1e.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
[18077.274972] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[18077.275138] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[18077.275174] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xd4400004)
[18077.275183] iwlagn 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[18077.275193] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[18077.275477] PM: early resume of devices complete after 1.145 msecs
[18077.275634] i915 0000:00:02.0: setting latency timer to 64
[18077.275640] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[18077.275649] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[18077.275719] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[18077.275727] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[18077.275741] pci 0000:00:1e.0: setting latency timer to 64
[18077.275761] ahci 0000:00:1f.2: setting latency timer to 64
[18077.275924] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18077.275933] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18077.275944] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18077.275953] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18077.275963] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[18077.275974] HDA Intel 0000:00:1b.0: setting latency timer to 64
[18077.276045] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[18077.276454] sd 0:0:0:0: [sda] Starting disk
[18077.461618] Extended CMOS year: 2000
[18077.527605] usb 2-1.3: reset high speed USB device number 3 using ehci_hcd
[18077.677442] usb 1-1.4: reset full speed USB device number 3 using ehci_hcd
[18077.762746] btusb 1-1.4:1.0: no reset_resume for driver btusb?
[18077.762755] btusb 1-1.4:1.1: no reset_resume for driver btusb?
[18079.831142] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[18079.833510] ata1.00: configured for UDMA/100
[18079.850609] PM: resume of devices complete after 2578.167 msecs
[18079.850984] PM: Finishing wakeup.
[18079.850987] Restarting tasks ... done.
[18079.924342] usb 1-1.2: new high speed USB device number 4 using ehci_hcd
[18079.942332] video LNXVIDEO:00: Restoring backlight state
[18079.992367] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[18080.014060] hub 1-1.2:1.0: USB hub found
[18080.014519] hub 1-1.2:1.0: 4 ports detected
[18080.280951] usb 1-1.2.3: new high speed USB device number 5 using ehci_hcd
[18080.358466] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[18080.362743] atl1c 0000:03:00.0: irq 44 for MSI/MSI-X
[18080.441957] ADDRCONF(NETDEV_UP): eth0: link is not ready
[18080.558631] Initializing USB Mass Storage driver...
[18080.558864] scsi6 : usb-storage 1-1.2.3:1.0
[18080.559087] usbcore: registered new interface driver usb-storage
[18080.559091] USB Mass Storage support registered.
[18081.562052] scsi 6:0:0:0: CD-ROM            TSSTcorp CDDVDW SE-S084D  TS01 PQ: 0 ANSI: 0
[18081.571762] sr0: scsi3-mmc drive: 31x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[18081.571770] cdrom: Uniform CD-ROM driver Revision: 3.20
[18081.572208] sr 6:0:0:0: Attached scsi CD-ROM sr0
[18081.573905] sr 6:0:0:0: Attached scsi generic sg1 type 5
[18081.629060] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[18081.634699] EXT4-fs (sda1): re-mounted. Opts: commit=0
[18081.994906] wlan%d: authenticate with 98:fc:11:8e:c9:ea (try 1)
[18081.997762] wlan%d: authenticated
[18081.998035] wlan%d: associate with 98:fc:11:8e:c9:ea (try 1)
[18082.001248] wlan%d: RX AssocResp from 98:fc:11:8e:c9:ea (capab=0x411 status=0 aid=2)
[18082.001254] wlan%d: associated
[18082.007345] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[18092.439263] wlan0: no IPv6 routers present
[18141.304612] UDF-fs: Partition marked readonly; forcing readonly mount
[18141.351521] UDF-fs INFO UDF: Mounting volume 'THE_OTHER_GUYS', timestamp 2010/10/23 02:04 (1f10)
[18143.437130] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18143.437149] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18143.437165] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18143.437186] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 36 11 e8 00 00 08 00 00 00
[18143.437222] end_request: I/O error, dev sr0, sector 14174112
[18143.437236] Buffer I/O error on device sr0, logical block 3543528
[18143.437249] Buffer I/O error on device sr0, logical block 3543529
[18143.437265] Buffer I/O error on device sr0, logical block 3543530
[18143.437275] Buffer I/O error on device sr0, logical block 3543531
[18143.437285] Buffer I/O error on device sr0, logical block 3543532
[18143.437294] Buffer I/O error on device sr0, logical block 3543533
[18143.437304] Buffer I/O error on device sr0, logical block 3543534
[18143.437313] Buffer I/O error on device sr0, logical block 3543535
[18143.918185] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18143.918201] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18143.918213] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18143.918229] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 33 aa 00 00 3c 00 00 00
[18143.918256] end_request: I/O error, dev sr0, sector 577192
[18143.918268] Buffer I/O error on device sr0, logical block 144298
[18143.918277] Buffer I/O error on device sr0, logical block 144299
[18143.987862] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18143.987875] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18143.987887] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18143.987901] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 33 e6 00 00 04 00 00 00
[18143.987927] end_request: I/O error, dev sr0, sector 577432
[18144.056791] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18144.056806] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18144.056818] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18144.056834] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 33 ea 00 00 3c 00 00 00
[18144.056862] end_request: I/O error, dev sr0, sector 577448
[18144.105364] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18144.105450] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18144.105458] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18144.105469] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 34 26 00 00 04 00 00 00
[18144.105493] end_request: I/O error, dev sr0, sector 577688
[18144.469042] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18144.469057] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18144.469069] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18144.469086] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 2d 89 24 00 00 10 00 00 00
[18144.469113] end_request: I/O error, dev sr0, sector 11936912
[18145.490797] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18145.490811] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18145.490824] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18145.490840] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 2d 89 90 00 00 02 00 00 00
[18145.490868] end_request: I/O error, dev sr0, sector 11937344
[18145.538425] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18145.538438] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18145.538450] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18145.538465] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 2d 89 90 00 00 02 00 00 00
[18145.538491] end_request: I/O error, dev sr0, sector 11937344
[18145.862109] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18145.862118] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18145.862124] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18145.862133] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 b3 fe 00 00 08 00 00 00
[18145.862147] end_request: I/O error, dev sr0, sector 708600
[18145.931049] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18145.931056] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18145.931062] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18145.931070] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 b3 fe 00 00 02 00 00 00
[18145.931083] end_request: I/O error, dev sr0, sector 708600
[18146.000117] sr 6:0:0:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[18146.000130] sr 6:0:0:0: [sr0]  Sense Key : Illegal Request [current] 
[18146.000142] sr 6:0:0:0: [sr0]  Add. Sense: Read of scrambled sector without authentication
[18146.000157] sr 6:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 b3 fe 00 00 02 00 00 00
[18146.000183] end_request: I/O error, dev sr0, sector 708600
[18221.328750] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0 because load = 0
[18225.972918] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 98:fc:11:8e:c9:ea tid = 0
[18387.361455] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 18275, limit 18000
[18449.216351] ACPI: Failed to switch the brightness
[18449.755974] ACPI: Failed to switch the brightness
[18450.188179] ACPI: Failed to switch the brightness
[18450.395348] ACPI: Failed to switch the brightness
[18450.615398] ACPI: Failed to switch the brightness
[18450.791131] ACPI: Failed to switch the brightness
[18451.005950] ACPI: Failed to switch the brightness
[18451.191396] ACPI: Failed to switch the brightness
[18451.367185] ACPI: Failed to switch the brightness
[18453.353965] ACPI: Failed to switch the brightness
[18454.079110] ACPI: Failed to switch the brightness
[18454.945659] ACPI: Failed to switch the brightness
[18668.950279] usb 1-1.2: USB disconnect, device number 4
[18668.950290] usb 1-1.2.3: USB disconnect, device number 5
[18674.215261] kbd_keycode: 158 callbacks suppressed
[18674.215266] keyboard: can't emulate rawmode for keycode 240
[18674.215281] keyboard: can't emulate rawmode for keycode 240
[18674.631803] wlan%d: deauthenticating from 98:fc:11:8e:c9:ea by local choice (reason=3)
[18674.705696] cfg80211: Calling CRDA to update world regulatory domain
[18674.711376] cfg80211: World regulatory domain updated:
[18674.711383] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[18674.711388] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[18674.711393] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[18674.711397] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[18674.711401] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[18674.711406] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[18676.395574] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[18676.401587] EXT4-fs (sda1): re-mounted. Opts: commit=0
[18677.371316] PM: Syncing filesystems ... done.
[18677.399215] PM: Preparing system for mem sleep
[18677.515818] Freezing user space processes ... (elapsed 0.01 seconds) done.
[18677.528903] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[18677.542110] PM: Entering mem sleep
[18677.542248] Suspending console(s) (use no_console_suspend to debug)
[18677.555929] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[18677.556073] sd 0:0:0:0: [sda] Stopping disk
[18677.688596] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[18677.688604] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[18677.778723] HDA Intel 0000:00:1b.0: PCI INT A disabled
[18677.791842] HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
[18678.064907] PM: suspend of devices complete after 510.083 msecs
[18678.118137] PM: late suspend of devices complete after 53.289 msecs
[18678.118400] ACPI: Preparing to enter system sleep state S3
[18678.134900] PM: Saving platform NVS memory
[18678.139388] Disabling non-boot CPUs ...
[18678.141817] CPU 1 is now offline
[18678.244590] CPU 2 is now offline
[18678.245801] Broke affinity for irq 12
[18678.347819] CPU 3 is now offline
[18678.348407] Extended CMOS year: 2000
[18678.348683] ACPI: Low-level resume complete
[18678.348762] PM: Restoring platform NVS memory
[18678.349470] Extended CMOS year: 2000
[18678.349521] Enabling non-boot CPUs ...
[18678.349653] Booting Node 0 Processor 1 APIC 0x1
[18678.349656] smpboot cpu 1: start_ip = 98000
[18678.462607] NMI watchdog enabled, takes one hw-pmu counter.
[18678.463303] CPU1 is up
[18678.463568] Booting Node 0 Processor 2 APIC 0x4
[18678.463570] smpboot cpu 2: start_ip = 98000
[18678.465293] Switched to NOHz mode on CPU #1
[18678.575788] NMI watchdog enabled, takes one hw-pmu counter.
[18678.576259] CPU2 is up
[18678.576531] Booting Node 0 Processor 3 APIC 0x5
[18678.576537] smpboot cpu 3: start_ip = 98000
[18678.578490] Switched to NOHz mode on CPU #2
[18678.689084] NMI watchdog enabled, takes one hw-pmu counter.
[18678.689609] CPU3 is up
[18678.692117] Switched to NOHz mode on CPU #3
[18678.692610] ACPI: Waking up from system sleep state S3
[18678.748512] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[18678.748618] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[18678.748679] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[18678.748923] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[18678.748959] pci 0000:00:1e.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
[18678.749064] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[18678.749230] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[18678.749266] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xd4400004)
[18678.749275] iwlagn 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[18678.749286] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100406)
[18678.749572] PM: early resume of devices complete after 1.141 msecs
[18678.749697] i915 0000:00:02.0: setting latency timer to 64
[18678.749912] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[18678.749920] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[18678.750017] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18678.750025] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18678.750036] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18678.750041] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[18678.750050] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[18678.750059] HDA Intel 0000:00:1b.0: setting latency timer to 64
[18678.750134] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[18678.750181] ahci 0000:00:1f.2: setting latency timer to 64
[18678.750314] pci 0000:00:1e.0: setting latency timer to 64
[18678.750320] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[18678.750331] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[18678.750515] sd 0:0:0:0: [sda] Starting disk
[18678.934823] Extended CMOS year: 2000
[18678.998282] usb 2-1.3: reset high speed USB device number 3 using ehci_hcd
[18679.148146] usb 1-1.4: reset full speed USB device number 3 using ehci_hcd
[18679.233502] btusb 1-1.4:1.0: no reset_resume for driver btusb?
[18679.233511] btusb 1-1.4:1.1: no reset_resume for driver btusb?
[18681.252038] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[18681.254366] ata1.00: configured for UDMA/100
[18681.272264] PM: resume of devices complete after 2525.643 msecs
[18681.272729] PM: Finishing wakeup.
[18681.272732] Restarting tasks ... done.
[18681.357654] video LNXVIDEO:00: Restoring backlight state
[18681.372073] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[18681.787673] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[18681.789999] atl1c 0000:03:00.0: irq 44 for MSI/MSI-X
[18681.868857] ADDRCONF(NETDEV_UP): eth0: link is not ready
[18682.256362] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[18682.256535] IP: [<ffffffff811d6503>] __elv_add_request+0x1e3/0x270
[18682.256603] PGD 0 
[18682.256632] Oops: 0002 [#1] SMP 
[18682.256686] CPU 2 
[18682.256714] Modules linked in: nls_utf8 udf crc_itu_t usb_storage cryptd aes_x86_64 aes_generic fuse parport_pc ppdev dm_crypt kvm_intel joydev kvm binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec iwlagn snd_hwdep snd_pcm mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd cfg80211 soundcore btusb uvcvideo snd_page_alloc bluetooth videodev v4l2_compat_ioctl32 psmouse ideapad_laptop serio_raw sparse_keymap lp intel_ips mac_hid parport ext4 mbcache jbd2 i915 ahci libahci libata drm_kms_helper drm i2c_algo_bit cfbcopyarea video cfbimgblt cfbfillrect atl1c
[18682.257659] 
[18682.257685] Pid: 14069, comm: xdg-screensaver Not tainted 2.6.39+ #4 LENOVO 0876                            /Base Board Product Name
[18682.257845] RIP: 0010:[<ffffffff811d6503>]  [<ffffffff811d6503>] __elv_add_request+0x1e3/0x270
[18682.257964] RSP: 0018:ffff88009b3a19e8  EFLAGS: 00010006
[18682.258056] RAX: 0000000000000000 RBX: ffff880131559020 RCX: 0000000000000001
[18682.258152] RDX: 0000000000000001 RSI: ffff880131559020 RDI: ffff8801315f77d0
[18682.258248] RBP: ffff88009b3a1a08 R08: ffffffff811e1000 R09: ffff8801315f77d0
[18682.258343] R10: ffff8800b5085e40 R11: ffff8800b5085e40 R12: ffff8801315f77d0
[18682.258437] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8800b5085e40
[18682.258529] FS:  0000000000000000(0000) GS:ffff880137c80000(0000) knlGS:0000000000000000
[18682.258636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18682.258712] CR2: 0000000000000008 CR3: 0000000001a03000 CR4: 00000000000006e0
[18682.258807] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18682.258898] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18682.258994] Process xdg-screensaver (pid: 14069, threadinfo ffff88009b3a0000, task ffff8800aff096b0)
[18682.259112] Stack:
[18682.259140]  ffff8801315f77d0 ffff880131559020 0000000000000001 ffff88009b3a1c48
[18682.259249]  ffff88009b3a1a38 ffffffff811e10a0 0000000000000000 ffff88009b3a1a48
[18682.259354]  ffff880131559020 0000000000000000 ffff88009b3a1af8 ffffffff811e118e
[18682.259460] Call Trace:
[18682.259504]  [<ffffffff811e10a0>] blk_execute_rq_nowait+0x60/0xc0
[18682.259587]  [<ffffffff811e118e>] blk_execute_rq+0x8e/0x130
[18682.259668]  [<ffffffff812db5bc>] scsi_execute+0xfc/0x160
[18682.259742]  [<ffffffff812dc18f>] scsi_execute_req+0xbf/0x130
[18682.259821]  [<ffffffff812d5c71>] ioctl_internal_command.clone.4+0x61/0x1b0
[18682.259914]  [<ffffffff812d5e3e>] scsi_set_medium_removal+0x7e/0xb0
[18682.260000]  [<ffffffff812ecfa0>] sr_lock_door+0x20/0x30
[18682.260075]  [<ffffffff812f9da7>] cdrom_release+0x147/0x270
[18682.260153]  [<ffffffff812ebac8>] sr_block_release+0x38/0x60
[18682.260233]  [<ffffffff811730ac>] __blkdev_put+0x16c/0x1b0
[18682.260308]  [<ffffffff81173129>] blkdev_put+0x39/0x150
[18682.260379]  [<ffffffff81173264>] blkdev_close+0x24/0x30
[18682.260455]  [<ffffffff81140fba>] fput+0xea/0x220
[18682.260521]  [<ffffffff8113d396>] filp_close+0x66/0x90
[18682.260592]  [<ffffffff8105c117>] put_files_struct+0x87/0xf0
[18682.260668]  [<ffffffff8105c244>] exit_files+0x54/0x70
[18682.264275]  [<ffffffff8105c72b>] do_exit+0x16b/0x860
[18682.267802]  [<ffffffff811f6c2a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[18682.271512]  [<ffffffff8105d0e8>] do_group_exit+0x58/0xd0
[18682.276948]  [<ffffffff8105d177>] sys_exit_group+0x17/0x20
[18682.281121]  [<ffffffff81485d42>] system_call_fastpath+0x16/0x1b
[18682.284603] Code: ff ff e9 90 fe ff ff 90 81 4b 40 00 08 00 00 48 89 df e8 c1 93 00 00 eb c1 0f 1f 80 00 00 00 00 81 4b 40 00 08 00 00 49 8b 04 24 
[18682.284903]  89 58 08 48 89 03 4c 89 63 08 49 89 1c 24 eb 9e 0f 1f 40 00 
[18682.290727] RIP  [<ffffffff811d6503>] __elv_add_request+0x1e3/0x270
[18682.293189]  RSP <ffff88009b3a19e8>
[18682.296075] CR2: 0000000000000008
[18682.358582] ---[ end trace 82dd699fdeb50b72 ]---
[18682.358587] Fixing recursive fault but reboot is needed!
[18683.171429] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=600
[18683.177875] EXT4-fs (sda1): re-mounted. Opts: commit=600
[18683.222874] wlan%d: authenticate with 98:fc:11:8e:c9:ea (try 1)
[18683.225750] wlan%d: authenticated
[18683.225948] wlan%d: associate with 98:fc:11:8e:c9:ea (try 1)
[18683.229308] wlan%d: RX AssocResp from 98:fc:11:8e:c9:ea (capab=0x411 status=0 aid=2)
[18683.229324] wlan%d: associated
[18683.236596] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[18684.010470] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=600
[18684.014968] EXT4-fs (sda1): re-mounted. Opts: commit=600
[18694.226375] wlan0: no IPv6 routers present
