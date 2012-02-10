Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971Ab2BJTOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:14:15 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:36545 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759954Ab2BJTOL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <1328894901.25989.20.camel@laptop>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
	<1328894901.25989.20.camel@laptop>
Date: Fri, 10 Feb 2012 11:14:08 -0800
Message-ID: <CAKbGBLi268_o25h31SEdt=+QfzkQc+WT_oz9=hnQ--hmgJF8bQ@mail.gmail.com>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
From: Steven Noonan <steven@uplinklabs.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 9:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-02-09 at 18:32 -0800, Steven Noonan wrote:
>> [   88.517599]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
>
> This looks like its waiting for an IPI to complete..
>
> There's no actual BUGS or WARNs in the output, just the soft lockup
> thing saying things are taking a bit of time (clearly 15s waiting for an
> IPI isn't quite normal).
>
> I've no idea why this wouldn't work on Xen, nor do the trace have any
> Xen specific muck in them.
>

Hmm. I just noticed the 'perf test' command in 3.2.5. It seems to be a
much more reliable (or at least faster) way to trigger the soft
lockups. Testing this on my work laptop for now (I can test on
something else if needed, but I figured this would do fine).


On 3.2.5 on metal (perf test -v 3):
  1: vmlinux symtab matches kallsyms:
  --- start ---
  Looking at the vmlinux_path (6 entries long)
  Using /lib/modules/3.2.5/build/vmlinux for symbols
  0xffffffff815ae5d0: diff name v: sleep_on_common k: __sched_text_start
  Maps only in vmlinux:
  ffffffff81ade1b1-ffffffff81bab8f7 0 [kernel].init.text
  ffffffff81bab8f8-ffffffff9fffffff 0 [kernel].exit.text
  Maps in vmlinux with a different name in kallsyms:
  Maps only in kallsyms:
  ---- end ----
  vmlinux symtab matches kallsyms: FAILED!

  2: detect open syscall event:
  --- start ---
  ---- end ----
  detect open syscall event: Ok
  3: detect open syscall event on all cpus:
  --- start ---
  ---- end ----
  detect open syscall event on all cpus: Ok
  4: read samples using the mmap interface:
  --- start ---
  ---- end ----
  read samples using the mmap interface: Ok
  5: parse events tests:
  --- start ---
  ---- end ----
  parse events tests: Ok



On 3.2.5 under xen:
  snoonan@asmodeus ~/Development/linux-dom0/tools/perf $ sudo ./perf test -v 3
  1: vmlinux symtab matches kallsyms:
  --- start ---
  Looking at the vmlinux_path (6 entries long)
  Using /lib/modules/3.2.5/build/vmlinux for symbols
  0xffffffff815ae5d0: diff name v: sleep_on_common k: __sched_text_start
  Maps only in vmlinux:
  ffffffff81ade1b1-ffffffff81bab8f7 0 [kernel].init.text
  ffffffff81bab8f8-ffffffff9fffffff 0 [kernel].exit.text
  Maps in vmlinux with a different name in kallsyms:
  Maps only in kallsyms:
  ---- end ----
  vmlinux symtab matches kallsyms: FAILED!

  2: detect open syscall event:
  --- start ---
  ---- end ----
  detect open syscall event: Ok
  3: detect open syscall event on all cpus:
  --- start ---
  ---- end ----
  detect open syscall event on all cpus: Ok
  4: read samples using the mmap interface:
  --- start ---
<hang for about a minute before finishing>


It hangs after test 3 and then soft lockup messages start spewing out.
The interesting bit about this is that it does eventually recover -- I
presume this is because the test is short and there's just really high
latency on the responses it's waiting for.


Here's a kernel log I just got for a full 'perf test -v 3' run under xen:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.5 (snoonan@asmodeus) (gcc version
4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3) ) #1 SMP Thu Feb 9 19:00:31 PST
2012
[    0.000000] Command line: placeholder
root=UUID=7a316bdb-7d08-44ce-963b-d2476a24ff40 ro earlyprintk=verbose
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] Freeing  9e-100 pfn range: 98 pages freed
[    0.000000] 1-1 mapping on 9e->100
[    0.000000] 1-1 mapping on bb27c->bb282
[    0.000000] 1-1 mapping on bb35f->bb40f
[    0.000000] 1-1 mapping on bb46f->bb70f
[    0.000000] 1-1 mapping on bb717->bb71f
[    0.000000] 1-1 mapping on bb76c->bb7ff
[    0.000000] 1-1 mapping on bb800->100000
[    0.000000] 1-1 mapping on 1fc000->200000
[    0.000000] Released 98 pages of unused memory
[    0.000000] Set 298067 page(s) to 1-1 mapping
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  Xen: 000000000009e800 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 00000000bb27c000 (usable)
[    0.000000]  Xen: 00000000bb27c000 - 00000000bb282000 (reserved)
[    0.000000]  Xen: 00000000bb282000 - 00000000bb35f000 (usable)
[    0.000000]  Xen: 00000000bb35f000 - 00000000bb371000 (reserved)
[    0.000000]  Xen: 00000000bb371000 - 00000000bb3f2000 (ACPI NVS)
[    0.000000]  Xen: 00000000bb3f2000 - 00000000bb40f000 (reserved)
[    0.000000]  Xen: 00000000bb40f000 - 00000000bb46f000 (usable)
[    0.000000]  Xen: 00000000bb46f000 - 00000000bb668000 (reserved)
[    0.000000]  Xen: 00000000bb668000 - 00000000bb6e8000 (ACPI NVS)
[    0.000000]  Xen: 00000000bb6e8000 - 00000000bb70f000 (reserved)
[    0.000000]  Xen: 00000000bb70f000 - 00000000bb717000 (usable)
[    0.000000]  Xen: 00000000bb717000 - 00000000bb71f000 (reserved)
[    0.000000]  Xen: 00000000bb71f000 - 00000000bb76c000 (usable)
[    0.000000]  Xen: 00000000bb76c000 - 00000000bb778000 (ACPI NVS)
[    0.000000]  Xen: 00000000bb778000 - 00000000bb77b000 (ACPI data)
[    0.000000]  Xen: 00000000bb77b000 - 00000000bb78b000 (ACPI NVS)
[    0.000000]  Xen: 00000000bb78b000 - 00000000bb78c000 (ACPI data)
[    0.000000]  Xen: 00000000bb78c000 - 00000000bb79f000 (ACPI NVS)
[    0.000000]  Xen: 00000000bb79f000 - 00000000bb7ff000 (ACPI data)
[    0.000000]  Xen: 00000000bb7ff000 - 00000000bb800000 (usable)
[    0.000000]  Xen: 00000000bb800000 - 00000000c0000000 (reserved)
[    0.000000]  Xen: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  Xen: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  Xen: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  Xen: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  Xen: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  Xen: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  Xen: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 00000001fc000000 (usable)
[    0.000000]  Xen: 0000000200000000 - 000000023c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 3680D79/3680D79, BIOS 6QET66WW (1.36 ) 05/31/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0xbb800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f6910] f6910
[    0.000000] initial memory mapped : 0 - 070aa000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
[    0.000000]  0000000000 - 00bb800000 page 4k
[    0.000000] kernel direct mapping tables up to bb800000 @ a20000-1000000
[    0.000000] xen: setting RW the range fbe000 - 1000000
[    0.000000] init_memory_mapping: 0000000100000000-000000023c000000
[    0.000000]  0100000000 - 023c000000 page 4k
[    0.000000] kernel direct mapping tables up to 23c000000 @ 7ee16000-80000000
[    0.000000] xen: setting RW the range 7f7fb000 - 80000000
[    0.000000] RAMDISK: 01e36000 - 070aa000
[    0.000000] ACPI: RSDP 00000000000f68e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bb7f06e2 0009C (v01 LENOVO TC-90
00001360  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bb7f0800 000F4 (v04 LENOVO TP-6Q
00001360 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bb7f0b6b 0DE36 (v01 LENOVO TP-6Q
00001360 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000bb6e7000 00040
[    0.000000] ACPI: SSDT 00000000bb7f09b4 001B7 (v01 LENOVO TP-6Q
00001360 MSFT 03000001)
[    0.000000] ACPI: ECDT 00000000bb7fe9a1 00052 (v01 LENOVO TP-6Q
00001360 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bb7fe9f3 00084 (v01 LENOVO TP-6Q
00001360 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bb7feaaf 0003C (v01 LENOVO TP-6Q
00001360 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bb7feaeb 00038 (v01 LENOVO TP-6Q
00001360 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bb7feb23 00176 (v01 LENOVO TC-90
00000104 MSFT 00000097)
[    0.000000] ACPI: ASF! 00000000bb7fedbe 000A4 (v16 LENOVO TP-6Q
00001360 PTL  00000001)
[    0.000000] ACPI: SLIC 00000000bb7fee62 00176 (v01 LENOVO TP-6Q
00001360  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bb7fefd8 00028 (v01 LENOVO TP-6Q
00001360  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bb6e590a 0085B (v01 LENOVO TP-6Q
00001360 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bb78b000 00032 (v02    PTL  CRESTLN
06040000      00005A52)
[    0.000000] ACPI: SSDT 00000000bb77a000 009F1 (v01  PmRef    CpuPm
00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 00000000bb779000 00259 (v01  PmRef  Cpu0Tst
00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 00000000bb778000 0049F (v01  PmRef    ApTst
00003000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000023c000000
[    0.000000]   NODE_DATA [000000007fffb000 - 000000007fffffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[9] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bb27c
[    0.000000]     0: 0x000bb282 -> 0x000bb35f
[    0.000000]     0: 0x000bb40f -> 0x000bb46f
[    0.000000]     0: 0x000bb70f -> 0x000bb717
[    0.000000]     0: 0x000bb71f -> 0x000bb76c
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x001fc000
[    0.000000]     0: 0x00200000 -> 0x0023c000
[    0.000000] On node 0 totalpages: 2044829
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 1443 pages reserved
[    0.000000]   DMA zone: 2475 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 746575 pages, LIFO batch:31
[    0.000000]   Normal zone: 20224 pages used for memmap
[    0.000000]   Normal zone: 1257728 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] BIOS bug: APIC version is 0 for CPU 0/0x0, fixing up to 0x10
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 255, address 0xfec00000, GSI 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 272
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bb27c000 - 00000000bb282000
[    0.000000] PM: Registered nosave memory: 00000000bb35f000 - 00000000bb371000
[    0.000000] PM: Registered nosave memory: 00000000bb371000 - 00000000bb3f2000
[    0.000000] PM: Registered nosave memory: 00000000bb3f2000 - 00000000bb40f000
[    0.000000] PM: Registered nosave memory: 00000000bb46f000 - 00000000bb668000
[    0.000000] PM: Registered nosave memory: 00000000bb668000 - 00000000bb6e8000
[    0.000000] PM: Registered nosave memory: 00000000bb6e8000 - 00000000bb70f000
[    0.000000] PM: Registered nosave memory: 00000000bb717000 - 00000000bb71f000
[    0.000000] PM: Registered nosave memory: 00000000bb76c000 - 00000000bb778000
[    0.000000] PM: Registered nosave memory: 00000000bb778000 - 00000000bb77b000
[    0.000000] PM: Registered nosave memory: 00000000bb77b000 - 00000000bb78b000
[    0.000000] PM: Registered nosave memory: 00000000bb78b000 - 00000000bb78c000
[    0.000000] PM: Registered nosave memory: 00000000bb78c000 - 00000000bb79f000
[    0.000000] PM: Registered nosave memory: 00000000bb79f000 - 00000000bb7ff000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feaff000
[    0.000000] PM: Registered nosave memory: 00000000feaff000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 00000001fc000000 - 0000000200000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1.1 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007ff52000 s83264
r8192 d23232 u114688
[    0.000000] pcpu-alloc: s83264 r8192 d23232 u114688 alloc=28*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    2.400244] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 2006778
[    2.400247] Policy zone: Normal
[    2.400251] Kernel command line: placeholder
root=UUID=7a316bdb-7d08-44ce-963b-d2476a24ff40 ro earlyprintk=verbose
[    2.400787] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    2.433417] Placing 64MB software IO TLB between ffff880072a00000 -
ffff880076a00000
[    2.433421] software IO TLB at phys 0x72a00000 - 0x76a00000
[    2.443304] Memory: 1780564k/9371648k available (5870k kernel code,
1192332k absent, 6398752k reserved, 5167k data, 916k init)
[    2.443403] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    2.443444] Hierarchical RCU implementation.
[    2.443446] 	RCU dyntick-idle grace-period acceleration is enabled.
[    2.443457] NR_IRQS:16640 nr_irqs:1024 16
[    2.443545] xen: sci override: global_irq=9 trigger=0 polarity=0
[    2.443548] xen: registering gsi 9 triggering 0 polarity 0
[    2.443562] xen: --> pirq=9 -> irq=9 (gsi=9)
[    2.443570] xen: acpi sci 9
[    2.443574] xen: --> pirq=1 -> irq=1 (gsi=1)
[    2.443578] xen: --> pirq=2 -> irq=2 (gsi=2)
[    2.443582] xen: --> pirq=3 -> irq=3 (gsi=3)
[    2.443586] xen: --> pirq=4 -> irq=4 (gsi=4)
[    2.443590] xen: --> pirq=5 -> irq=5 (gsi=5)
[    2.443595] xen: --> pirq=6 -> irq=6 (gsi=6)
[    2.443599] xen: --> pirq=7 -> irq=7 (gsi=7)
[    2.443603] xen: --> pirq=8 -> irq=8 (gsi=8)
[    2.443605] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    2.443608] xen: --> pirq=9 -> irq=9 (gsi=9)
[    2.443612] xen: --> pirq=10 -> irq=10 (gsi=10)
[    2.443616] xen: --> pirq=11 -> irq=11 (gsi=11)
[    2.443620] xen: --> pirq=12 -> irq=12 (gsi=12)
[    2.443624] xen: --> pirq=13 -> irq=13 (gsi=13)
[    2.443628] xen: --> pirq=14 -> irq=14 (gsi=14)
[    2.443632] xen: --> pirq=15 -> irq=15 (gsi=15)
[    2.446359] Console: colour VGA+ 80x25
[    2.454286] console [tty0] enabled
[    2.467743] allocated 67108864 bytes of page_cgroup
[    2.467804] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    2.467932] Xen: using vcpuop timer interface
[    2.467942] installing Xen timer for CPU 0
[    2.468021] Detected 2394.048 MHz processor.
[    2.468073] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4788.09 BogoMIPS (lpj=9576192)
[    2.468174] pid_max: default: 32768 minimum: 301
[    2.468256] Security Framework initialized
[    2.468313] AppArmor: AppArmor initialized
[    2.471153] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    2.474315] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    2.475221] Mount-cache hash table entries: 256
[    2.475477] Initializing cgroup subsys cpuacct
[    2.475531] Initializing cgroup subsys memory
[    2.475593] Initializing cgroup subsys devices
[    2.475642] Initializing cgroup subsys freezer
[    2.475691] Initializing cgroup subsys blkio
[    2.475748] Initializing cgroup subsys perf_event
[    2.477864] CPU: Physical Processor ID: 0
[    2.477912] CPU: Processor Core ID: 0
[    2.478719] ACPI: Core revision 20110623
[    2.798418] ftrace: allocating 28004 entries in 110 pages
[    2.806327] cpu 0 spinlock event irq 273
[    2.806432] Performance Events: unsupported p6 CPU model 37 no PMU
driver, software events only.
[    2.806706] NMI watchdog disabled (cpu0): hardware events not enabled
[    2.806859] installing Xen timer for CPU 1
[    2.806927] cpu 1 spinlock event irq 279
[    2.807134] NMI watchdog disabled (cpu1): hardware events not enabled
[    2.807301] installing Xen timer for CPU 2
[    2.807370] cpu 2 spinlock event irq 285
[    2.807522] NMI watchdog disabled (cpu2): hardware events not enabled
[    2.807676] installing Xen timer for CPU 3
[    2.807743] cpu 3 spinlock event irq 291
[    2.807885] NMI watchdog disabled (cpu3): hardware events not enabled
[    2.807973] Brought up 4 CPUs
[    2.808370] devtmpfs: initialized
[    2.808729] PM: Registering ACPI NVS region at bb371000 (528384 bytes)
[    2.808809] PM: Registering ACPI NVS region at bb668000 (524288 bytes)
[    2.808884] PM: Registering ACPI NVS region at bb76c000 (49152 bytes)
[    2.808945] PM: Registering ACPI NVS region at bb77b000 (65536 bytes)
[    2.809007] PM: Registering ACPI NVS region at bb78c000 (77824 bytes)
[    2.809767] Grant table initialized
[    2.809854] RTC time: 11:05:56, date: 02/10/12
[    2.809945] NET: Registered protocol family 16
[    2.810227] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    2.810323] ACPI: bus type pci registered
[    2.810446] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    2.810546] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    2.897537] PCI: Using configuration type 1 for base access
[    2.898480] bio: create slab <bio-0> at 0
[    2.898639] ACPI: Added _OSI(Module Device)
[    2.898696] ACPI: Added _OSI(Processor Device)
[    2.898753] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.898811] ACPI: Added _OSI(Processor Aggregator Device)
[    2.903080] ACPI: EC: EC description table is found, configuring boot EC
[    2.912475] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.999072] ACPI: SSDT 00000000bb71aa18 0046F (v01  PmRef  Cpu0Ist
00003000 INTL 20060912)
[    2.999819] ACPI: Dynamic OEM Table Load:
[    2.999909] ACPI: SSDT           (null) 0046F (v01  PmRef  Cpu0Ist
00003000 INTL 20060912)
[    3.000385] ACPI: SSDT 00000000bb718718 006B2 (v01  PmRef  Cpu0Cst
00003001 INTL 20060912)
[    3.001558] ACPI: Dynamic OEM Table Load:
[    3.001647] ACPI: SSDT           (null) 006B2 (v01  PmRef  Cpu0Cst
00003001 INTL 20060912)
[    3.033079] ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst
00003000 INTL 20060912)
[    3.034293] ACPI: Dynamic OEM Table Load:
[    3.034381] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst
00003000 INTL 20060912)
[    3.044926] ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst
00003000 INTL 20060912)
[    3.046112] ACPI: Dynamic OEM Table Load:
[    3.046199] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
00003000 INTL 20060912)
[    3.062929] ACPI: Interpreter enabled
[    3.062987] ACPI: (supports S0 S3 S4 S5)
[    3.063130] ACPI: Using IOAPIC for interrupt routing
[    3.068028] ACPI: Power Resource [PUBS] (on)
[    3.072337] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    3.073962] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    3.074025] HEST: Table not found.
[    3.074080] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    3.074191] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    3.074309] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    3.074373] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    3.074437] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    3.074492] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    3.074547] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    3.074602] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    3.074701]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    3.074765]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND),
returned control mask: 0x1d
[    3.074858] ACPI _OSC control for PCIe not granted, disabling ASPM
[    3.075338] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    3.075454] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    3.075518] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    3.075584] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    3.075675] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000d3fff]
[    3.075766] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000d7fff]
[    3.075862] pci_root PNP0A08:00: host bridge window [mem
0x000d8000-0x000dbfff]
[    3.075953] pci_root PNP0A08:00: host bridge window [mem
0xc0000000-0xfebfffff]
[    3.076056] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    3.076101] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU
for graphics
[    3.076242] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    3.076272] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    3.076289] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.076301] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    3.076462] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    3.076521] pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
[    3.076720] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    3.076728] pci 0000:00:16.0: PME# disabled
[    3.076780] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    3.076823] pci 0000:00:16.3: reg 10: [io  0x1808-0x180f]
[    3.076845] pci 0000:00:16.3: reg 14: [mem 0xf2524000-0xf2524fff]
[    3.077086] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    3.077133] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    3.077154] pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
[    3.077176] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    3.077349] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    3.077357] pci 0000:00:19.0: PME# disabled
[    3.077410] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    3.077457] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    3.077668] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    3.077675] pci 0000:00:1a.0: PME# disabled
[    3.077731] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    3.077770] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    3.077958] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    3.077966] pci 0000:00:1b.0: PME# disabled
[    3.078018] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    3.078215] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    3.078222] pci 0000:00:1c.0: PME# disabled
[    3.078282] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    3.078479] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    3.078486] pci 0000:00:1c.3: PME# disabled
[    3.078540] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    3.078736] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    3.078744] pci 0000:00:1c.4: PME# disabled
[    3.078813] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    3.078861] pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
[    3.079073] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    3.079080] pci 0000:00:1d.0: PME# disabled
[    3.079126] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    3.079293] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    3.079544] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    3.079596] pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
[    3.079616] pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
[    3.079637] pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
[    3.079657] pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
[    3.079678] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    3.079698] pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
[    3.079829] pci 0000:00:1f.2: PME# supported from D3hot
[    3.079837] pci 0000:00:1f.2: PME# disabled
[    3.079877] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    3.079917] pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
[    3.079974] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    3.080066] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    3.080119] pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
[    3.080421] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    3.080605] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    3.080669] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    3.080677] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    3.080691] pci 0000:00:1c.3:   bridge window [mem
0xf2800000-0xf28fffff 64bit pref]
[    3.080845] pci 0000:02:00.0: [8086:0087] type 0 class 0x000280
[    3.080903] pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    3.081186] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    3.081197] pci 0000:02:00.0: PME# disabled
[    3.081302] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    3.081373] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    3.081520] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    3.081606] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    3.081608] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    3.081611] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    3.081614] pci 0000:00:1e.0:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
[    3.081617] pci 0000:00:1e.0:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    3.081620] pci 0000:00:1e.0:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    3.081623] pci 0000:00:1e.0:   bridge window [mem
0xc0000000-0xfebfffff] (subtractive decode)
[    3.081671] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    3.081806] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    3.081847] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    3.081886] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    3.082112]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    3.082491]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT),
returned control mask: 0x0d
[    3.082585] ACPI _OSC control for PCIe not granted, disabling ASPM
[    3.086170] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    3.086487] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    3.086793] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10
11) *0, disabled.
[    3.087172] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    3.087492] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    3.087797] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10
11) *0, disabled.
[    3.088162] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10
11) *0, disabled.
[    3.088548] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    3.088827] xen/balloon: Initialising balloon driver.
[    3.108901] xen-balloon: Initialising balloon driver.
[    3.109109] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    3.109214] vgaarb: loaded
[    3.109266] vgaarb: bridge control possible 0000:00:02.0
[    3.109410] SCSI subsystem initialized
[    3.109559] libata version 3.00 loaded.
[    3.109611] usbcore: registered new interface driver usbfs
[    3.109681] usbcore: registered new interface driver hub
[    3.109788] usbcore: registered new device driver usb
[    3.109949] PCI: Using ACPI for IRQ routing
[    3.128576] PCI: pci_cache_line_size set to 64 bytes
[    3.128714] reserve RAM buffer: 000000000009e000 - 000000000009ffff
[    3.128717] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff
[    3.128722] reserve RAM buffer: 00000000bb35f000 - 00000000bbffffff
[    3.128727] reserve RAM buffer: 00000000bb46f000 - 00000000bbffffff
[    3.128731] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff
[    3.128735] reserve RAM buffer: 00000000bb76c000 - 00000000bbffffff
[    3.128738] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff
[    3.128850] NetLabel: Initializing
[    3.128905] NetLabel:  domain hash size = 128
[    3.128960] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.129028] NetLabel:  unlabeled traffic allowed by default
[    3.129091] Switching to clocksource xen
[    3.138901] AppArmor: AppArmor Filesystem Enabled
[    3.139000] pnp: PnP ACPI init
[    3.139074] ACPI: bus type pnp registered
[    3.140830] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    3.140834] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    3.140836] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    3.140839] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    3.140841] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    3.140844] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    3.140847] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    3.140849] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    3.140852] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    3.140854] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    3.140857] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    3.140859] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    3.140865] pnp 00:00: [mem 0x000ec000-0x000effff]
[    3.140867] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    3.140870] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    3.140872] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    3.140875] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    3.140957] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    3.141020] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    3.141081] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    3.141145] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
[    3.141212] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
[    3.141278] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    3.141344] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    3.141410] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    3.141475] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    3.141539] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    3.141606] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    3.141671] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    3.141734] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    3.141801] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    3.141867] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.141882] pnp 00:01: [bus ff]
[    3.141979] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    3.141999] pnp 00:02: [bus 00-fe]
[    3.142002] pnp 00:02: [io  0x0cf8-0x0cff]
[    3.142004] pnp 00:02: [io  0x0000-0x0cf7 window]
[    3.142007] pnp 00:02: [io  0x0d00-0xffff window]
[    3.142009] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    3.142012] pnp 00:02: [mem 0x000c0000-0x000c3fff window]
[    3.142014] pnp 00:02: [mem 0x000c4000-0x000c7fff window]
[    3.142017] pnp 00:02: [mem 0x000c8000-0x000cbfff window]
[    3.142019] pnp 00:02: [mem 0x000cc000-0x000cffff window]
[    3.142022] pnp 00:02: [mem 0x000d0000-0x000d3fff window]
[    3.142024] pnp 00:02: [mem 0x000d4000-0x000d7fff window]
[    3.142027] pnp 00:02: [mem 0x000d8000-0x000dbfff window]
[    3.142029] pnp 00:02: [mem 0x000dc000-0x000dffff window]
[    3.142032] pnp 00:02: [mem 0x000e0000-0x000e3fff window]
[    3.142034] pnp 00:02: [mem 0x000e4000-0x000e7fff window]
[    3.142037] pnp 00:02: [mem 0x000e8000-0x000ebfff window]
[    3.142039] pnp 00:02: [mem 0x000ec000-0x000effff window]
[    3.142042] pnp 00:02: [mem 0xc0000000-0xfebfffff window]
[    3.142044] pnp 00:02: [mem 0xfed40000-0xfed4bfff window]
[    3.142103] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    3.142434] pnp 00:03: [io  0x0010-0x001f]
[    3.142437] pnp 00:03: [io  0x0090-0x009f]
[    3.142440] pnp 00:03: [io  0x0024-0x0025]
[    3.142442] pnp 00:03: [io  0x0028-0x0029]
[    3.142444] pnp 00:03: [io  0x002c-0x002d]
[    3.142446] pnp 00:03: [io  0x0030-0x0031]
[    3.142449] pnp 00:03: [io  0x0034-0x0035]
[    3.142451] pnp 00:03: [io  0x0038-0x0039]
[    3.142453] pnp 00:03: [io  0x003c-0x003d]
[    3.142455] pnp 00:03: [io  0x00a4-0x00a5]
[    3.142458] pnp 00:03: [io  0x00a8-0x00a9]
[    3.142460] pnp 00:03: [io  0x00ac-0x00ad]
[    3.142462] pnp 00:03: [io  0x00b0-0x00b5]
[    3.142464] pnp 00:03: [io  0x00b8-0x00b9]
[    3.142467] pnp 00:03: [io  0x00bc-0x00bd]
[    3.142469] pnp 00:03: [io  0x0050-0x0053]
[    3.142471] pnp 00:03: [io  0x0072-0x0077]
[    3.142476] pnp 00:03: [io  0x164e-0x164f]
[    3.142478] pnp 00:03: [io  0x002e-0x002f]
[    3.142481] pnp 00:03: [io  0x1000-0x107f]
[    3.142483] pnp 00:03: [io  0x1180-0x11ff]
[    3.142485] pnp 00:03: [io  0x0800-0x080f]
[    3.142487] pnp 00:03: [io  0x15e0-0x15ef]
[    3.142490] pnp 00:03: [io  0x1600-0x1641]
[    3.142492] pnp 00:03: [io  0x1644-0x167f]
[    3.142494] pnp 00:03: [mem 0xe0000000-0xefffffff]
[    3.142497] pnp 00:03: [mem 0xfeaff000-0xfeafffff]
[    3.142499] pnp 00:03: [mem 0xfed1c000-0xfed1ffff]
[    3.142501] pnp 00:03: [mem 0xfed10000-0xfed13fff]
[    3.142504] pnp 00:03: [mem 0xfed18000-0xfed18fff]
[    3.142506] pnp 00:03: [mem 0xfed19000-0xfed19fff]
[    3.142509] pnp 00:03: [mem 0xfed45000-0xfed4bfff]
[    3.142583] system 00:03: [io  0x164e-0x164f] has been reserved
[    3.142647] system 00:03: [io  0x1000-0x107f] has been reserved
[    3.142710] system 00:03: [io  0x1180-0x11ff] has been reserved
[    3.142769] system 00:03: [io  0x0800-0x080f] has been reserved
[    3.142828] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    3.142890] system 00:03: [io  0x1600-0x1641] has been reserved
[    3.142953] system 00:03: [io  0x1644-0x167f] could not be reserved
[    3.143016] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    3.143080] system 00:03: [mem 0xfeaff000-0xfeafffff] has been reserved
[    3.143146] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    3.143210] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    3.143275] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    3.143340] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    3.143403] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    3.143468] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.143510] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    3.143549] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.143560] pnp 00:05: [io  0x0000-0x000f]
[    3.143563] pnp 00:05: [io  0x0080-0x008f]
[    3.143565] pnp 00:05: [io  0x00c0-0x00df]
[    3.143568] pnp 00:05: [dma 4]
[    3.143604] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.143614] pnp 00:06: [io  0x0061]
[    3.143648] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.143658] pnp 00:07: [io  0x00f0]
[    3.143663] xen: registering gsi 13 triggering 1 polarity 0
[    3.143670] xen_map_pirq_gsi: returning irq 13 for gsi 13
[    3.143730] xen: --> pirq=13 -> irq=13 (gsi=13)
[    3.143739] pnp 00:07: [irq 13]
[    3.143780] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    3.143790] pnp 00:08: [io  0x0070-0x0071]
[    3.143793] xen: registering gsi 8 triggering 1 polarity 0
[    3.143796] xen_map_pirq_gsi: returning irq 8 for gsi 8
[    3.143854] xen: --> pirq=8 -> irq=8 (gsi=8)
[    3.143859] pnp 00:08: [irq 8]
[    3.143898] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.143909] pnp 00:09: [io  0x0060]
[    3.143911] pnp 00:09: [io  0x0064]
[    3.143913] xen: registering gsi 1 triggering 1 polarity 0
[    3.143916] xen_map_pirq_gsi: returning irq 1 for gsi 1
[    3.143976] xen: --> pirq=1 -> irq=1 (gsi=1)
[    3.143981] pnp 00:09: [irq 1]
[    3.144020] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.144030] xen: registering gsi 12 triggering 1 polarity 0
[    3.144033] xen_map_pirq_gsi: returning irq 12 for gsi 12
[    3.144090] xen: --> pirq=12 -> irq=12 (gsi=12)
[    3.144096] pnp 00:0a: [irq 12]
[    3.144133] pnp 00:0a: Plug and Play ACPI device, IDs IBM3780
PNP0f13 (active)
[    3.144432] pnp 00:0b: [mem 0xfed40000-0xfed44fff]
[    3.144478] pnp 00:0b: Plug and Play ACPI device, IDs SMO1200
PNP0c31 (active)
[    3.145082] pnp: PnP ACPI: found 12 devices
[    3.145139] ACPI: ACPI bus type pnp unregistered
[    3.151906] PM-Timer failed consistency check  (0x0xffffff) - aborting.
[    3.151985] PCI: max bus depth: 1 pci_try_num: 2
[    3.152059] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    3.152143] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    3.152205] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    3.152271] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    3.152339] pci 0000:00:1c.3:   bridge window [mem
0xf2800000-0xf28fffff 64bit pref]
[    3.152442] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    3.152506] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    3.152584] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    3.152677] xen: registering gsi 20 triggering 0 polarity 1
[    3.152690] xen: --> pirq=20 -> irq=20 (gsi=20)
[    3.152695] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.152762] pci 0000:00:1c.0: setting latency timer to 64
[    3.152774] xen: registering gsi 23 triggering 0 polarity 1
[    3.152780] xen: --> pirq=23 -> irq=23 (gsi=23)
[    3.152784] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.152854] pci 0000:00:1c.3: setting latency timer to 64
[    3.152865] xen: registering gsi 20 triggering 0 polarity 1
[    3.152868] xen_map_pirq_gsi: returning irq 20 for gsi 20
[    3.152924] xen: --> pirq=20 -> irq=20 (gsi=20)
[    3.152926] Already setup the GSI :20
[    3.152979] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.153048] pci 0000:00:1c.4: setting latency timer to 64
[    3.153062] pci 0000:00:1e.0: setting latency timer to 64
[    3.153068] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.153070] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.153073] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.153076] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    3.153078] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    3.153081] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    3.153084] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    3.153086] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    3.153089] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    3.153092] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff
64bit pref]
[    3.153094] pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
[    3.153097] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    3.153100] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    3.153102] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    3.153105] pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
[    3.153107] pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
[    3.153110] pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
[    3.153112] pci_bus 0000:0e: resource 10 [mem 0xc0000000-0xfebfffff]
[    3.153153] NET: Registered protocol family 2
[    3.153954] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    3.159386] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    3.161480] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.161751] TCP: Hash tables configured (established 524288 bind 65536)
[    3.161817] TCP reno registered
[    3.161918] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.162050] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.162240] NET: Registered protocol family 1
[    3.162332] pci 0000:00:02.0: Boot video device
[    3.162511] PCI: CLS 64 bytes, default 64
[    3.162573] Trying to unpack rootfs image as initramfs...
[    3.250030] Freeing initrd memory: 84432k freed
[    3.275685] Simple Boot Flag at 0x35 set to 0x1
[    3.276434] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
[    3.276506] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x2
[    3.276583] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
[    3.276655] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x2
[    3.276759] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.283424] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    3.287576] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    3.287892] audit: initializing netlink socket (disabled)
[    3.287969] type=2000 audit(1328871956.887:1): initialized
[    3.314542] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.316329] VFS: Disk quotas dquot_6.5.2
[    3.316443] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.317243] JFS: nTxBlock = 8192, nTxLock = 65536
[    3.320578] SGI XFS with ACLs, security attributes, large
block/inode numbers, no debug enabled
[    3.321488] Btrfs loaded
[    3.321546] msgmni has been set to 3642
[    3.321787] alg: No test for cipher_null (cipher_null-generic)
[    3.321903] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    3.322019] alg: No test for digest_null (digest_null-generic)
[    3.322132] alg: No test for compress_null (compress_null-generic)
[    3.323919] alg: No test for fcrypt (fcrypt-generic)
[    3.326879] alg: No test for stdrng (krng)
[    3.349171] NET: Registered protocol family 38
[    3.349283] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    3.349425] io scheduler noop registered
[    3.349481] io scheduler deadline registered
[    3.349572] io scheduler cfq registered (default)
[    3.350059] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.350142] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.350500] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.350832] ACPI: AC Adapter [AC] (on-line)
[    3.351160] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    3.351602] ACPI: Lid Switch [LID]
[    3.351701] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    3.351801] ACPI: Sleep Button [SLPB]
[    3.351905] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    3.351998] ACPI: Power Button [PWRF]
[    3.359229] thermal LNXTHERM:00: registered as thermal_zone0
[    3.359288] ACPI: Thermal Zone [THM0] (68 C)
[    3.359357] ERST: Table is not found!
[    3.360384] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    3.378445] ACPI: Deprecated procfs I/F for battery is loaded,
please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.378552] ACPI: Battery Slot [BAT0] (battery present)
[    3.488062] xen: registering gsi 17 triggering 0 polarity 1
[    3.488075] xen: --> pirq=17 -> irq=17 (gsi=17)
[    3.488083] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.508738] 0000:00:16.3: ttyS4 at I/O 0x1808 (irq = 17) is a 16550A
[    3.549478] hpet_acpi_add: no address or irqs in _CRS
[    3.549599] Non-volatile memory driver v1.3
[    3.549722] Linux agpgart interface v0.103
[    3.549853] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    3.550139] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K
total, 262144K mappable
[    3.551487] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    3.551800] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    3.553487] brd: module loaded
[    3.554376] loop: module loaded
[    3.554644] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.554731] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.554796] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.554868] xen: registering gsi 23 triggering 0 polarity 1
[    3.554876] xen_map_pirq_gsi: returning irq 23 for gsi 23
[    3.554935] xen: --> pirq=23 -> irq=23 (gsi=23)
[    3.554938] Already setup the GSI :23
[    3.554993] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.555080] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.555086] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.555206] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    3.555350] ehci_hcd 0000:00:1a.0: debug port 2
[    3.559308] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.559342] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
[    3.573243] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.573460] hub 1-0:1.0: USB hub found
[    3.573521] hub 1-0:1.0: 3 ports detected
[    3.573651] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.573718] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.573785] xen: registering gsi 19 triggering 0 polarity 1
[    3.573797] xen: --> pirq=19 -> irq=19 (gsi=19)
[    3.573802] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.573885] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.573890] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.574003] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    3.574146] ehci_hcd 0000:00:1d.0: debug port 2
[    3.578100] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.578123] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
[    3.593236] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.593445] hub 2-0:1.0: USB hub found
[    3.593503] hub 2-0:1.0: 3 ports detected
[    3.593623] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.593698] uhci_hcd: USB Universal Host Controller Interface driver
[    3.593834] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU]
at 0x60,0x64 irq 1,12
[    3.597293] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.597359] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.597584] mousedev: PS/2 mouse device common for all mice
[    3.597824] rtc_cmos 00:08: RTC can wake from S4
[    3.598047] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.598147] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    3.598217] EFI Variables Facility v0.08 2004-May-17
[    3.598282] oprofile: using NMI timer interrupt.
[    3.598609] TCP cubic registered
[    3.598793] NET: Registered protocol family 10
[    3.599390] NET: Registered protocol family 17
[    3.599460] NET: Registered protocol family 15
[    3.599517] Registering the dns_resolver key type
[    3.599735] PM: Hibernation image not present or could not be loaded.
[    3.599749] registered taskstats version 1
[    3.600307]   Magic number: 0:404:74
[    3.600476] rtc_cmos 00:08: setting system clock to 2012-02-10
11:05:57 UTC (1328871957)
[    3.601444] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    3.607133] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.607193] EDD information not available.
[    3.607778] Freeing unused kernel memory: 916k freed
[    3.608025] Write protecting the kernel read-only data: 10240k
[    3.612093] Freeing unused kernel memory: 256k freed
[    3.612704] Freeing unused kernel memory: 1268k freed
[    3.653419] udevd[170]: starting version 173
[    3.714739] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    3.714813] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.714935] xen: registering gsi 20 triggering 0 polarity 1
[    3.714945] xen_map_pirq_gsi: returning irq 20 for gsi 20
[    3.715009] xen: --> pirq=20 -> irq=20 (gsi=20)
[    3.715013] Already setup the GSI :20
[    3.715075] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.715168] e1000e 0000:00:19.0: setting latency timer to 64
[    3.747445] [drm] Initialized drm 1.1.0 20060810
[    3.889264] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    3.903869] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width
x1) f0:de:f1:42:88:90
[    3.903949] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.904089] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    3.904192] ahci 0000:00:1f.2: version 3.0
[    3.904223] xen: registering gsi 16 triggering 0 polarity 1
[    3.904247] xen: --> pirq=16 -> irq=16 (gsi=16)
[    3.904258] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.904491] ahci: SSS flag set, parallel bus scan disabled
[    3.904595] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3
Gbps 0x33 impl SATA mode
[    3.904675] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm
led clo pio slum part ems sxs apst
[    3.904763] ahci 0000:00:1f.2: setting latency timer to 64
[    3.926156] scsi0 : ahci
[    3.926342] scsi1 : ahci
[    3.926495] scsi2 : ahci
[    3.926650] scsi3 : ahci
[    3.926803] scsi4 : ahci
[    3.926959] scsi5 : ahci
[    3.927561] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port
0xf2727100 irq 299
[    3.927641] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port
0xf2727180 irq 299
[    3.927718] ata3: DUMMY
[    3.927761] ata4: DUMMY
[    3.927806] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port
0xf2727300 irq 299
[    3.927885] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port
0xf2727380 irq 299
[    3.928030] i915 0000:00:02.0: power state changed by ACPI to D0
[    3.928097] i915 0000:00:02.0: power state changed by ACPI to D0
[    3.928163] xen: registering gsi 16 triggering 0 polarity 1
[    3.928172] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    3.928228] xen: --> pirq=16 -> irq=16 (gsi=16)
[    3.928231] Already setup the GSI :16
[    3.928285] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.928345] i915 0000:00:02.0: setting latency timer to 64
[    4.021884] hub 1-1:1.0: USB hub found
[    4.022082] hub 1-1:1.0: 6 ports detected
[    4.032066] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    4.032518] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.032573] [drm] Driver supports precise vblank timestamp query.
[    4.032732] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.133257] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    4.245269] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.245826] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.245830] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    4.245910] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    4.248281] ata1.00: ATA-8: INTEL SSDSA2CW160G3, 4PC10302, max UDMA/133
[    4.248351] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.248894] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.248898] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    4.248977] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    4.249364] ata1.00: configured for UDMA/133
[    4.249591] scsi 0:0:0:0: Direct-Access     ATA      INTEL
SSDSA2CW16 4PC1 PQ: 0 ANSI: 5
[    4.249921] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.249925] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks:
(160 GB/149 GiB)
[    4.250016] sd 0:0:0:0: [sda] Write Protect is off
[    4.250018] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.250045] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.251122]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    4.251773] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.265879] hub 2-1:1.0: USB hub found
[    4.266077] hub 2-1:1.0: 8 ports detected
[    4.337326] usb 1-1.6: new high-speed USB device number 3 using ehci_hcd
[    4.535540] fbcon: inteldrmfb (fb0) is primary device
[    4.537366] usb 2-1.3: new high-speed USB device number 3 using ehci_hcd
[    4.569272] ata2: SATA link down (SStatus 0 SControl 300)
[    4.716227] Console: switching to colour frame buffer device 160x50
[    4.719248] fb0: inteldrmfb frame buffer device
[    4.719273] drm: registered panic notifier
[    4.790838] acpi device:02: registered as cooling_device4
[    4.791006] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    4.791131] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    4.791223] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.889265] ata5: SATA link down (SStatus 0 SControl 300)
[    5.209247] ata6: SATA link down (SStatus 0 SControl 300)
[    5.572718] EXT4-fs (sda6): mounted filesystem with ordered data
mode. Opts: (null)
[    5.890423] init: ureadahead main process (380) terminated with status 5
[    6.049722] Adding 3998716k swap on /dev/sda5.  Priority:-1
extents:1 across:3998716k SS
[    6.051531] udevd[419]: starting version 173
[    6.169153] EXT4-fs (sda6): re-mounted. Opts:
errors=remount-ro,user_xattr,discard
[    6.188748] wmi: Mapper loaded
[    6.264342] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: discard
[    6.370317] mei: module is from the staging directory, the quality
is unknown, you have been warned.
[    6.378700] xen: registering gsi 16 triggering 0 polarity 1
[    6.378715] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    6.378719] xen: --> pirq=16 -> irq=16 (gsi=16)
[    6.378722] Already setup the GSI :16
[    6.378728] mei 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.378740] mei 0000:00:16.0: setting latency timer to 64
[    6.411801] intel ips 0000:00:1f.6: CPU TDP doesn't match expected
value (found 25, expected 29)
[    6.411825] xen: registering gsi 19 triggering 0 polarity 1
[    6.411837] xen_map_pirq_gsi: returning irq 19 for gsi 19
[    6.411841] xen: --> pirq=19 -> irq=19 (gsi=19)
[    6.411846] Already setup the GSI :19
[    6.411851] intel ips 0000:00:1f.6: PCI INT D -> GSI 19 (level,
low) -> IRQ 19
[    6.417859] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    6.445468] RPC: Registered named UNIX socket transport module.
[    6.445473] RPC: Registered udp transport module.
[    6.445476] RPC: Registered tcp transport module.
[    6.445478] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.468037] cfg80211: Calling CRDA to update world regulatory domain
[    6.504212] FS-Cache: Loaded
[    6.637305] Linux video capture interface: v2.00
[    6.703494] FS-Cache: Netfs 'nfs' registered for caching
[    6.705710] xen: registering gsi 17 triggering 0 polarity 1
[    6.705724] xen_map_pirq_gsi: returning irq 17 for gsi 17
[    6.705727] xen: --> pirq=17 -> irq=17 (gsi=17)
[    6.705731] Already setup the GSI :17
[    6.705739] snd_hda_intel 0000:00:1b.0: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    6.706214] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    6.717112] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:4816)
[    6.731252] input: Integrated Camera as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input5
[    6.732836] usbcore: registered new interface driver uvcvideo
[    6.732841] USB Video Class driver (1.1.1)
[    6.772938] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.837508] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[    6.837770] input: HDA Intel HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    7.013729] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    7.032578] input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio1/input/input7
[    7.132778] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    7.132784] thinkpad_acpi: http://ibm-acpi.sf.net/
[    7.132787] thinkpad_acpi: ThinkPad BIOS 6QET66WW (1.36 ), EC 6QHT33WW-1.14
[    7.132790] thinkpad_acpi: Lenovo ThinkPad X201, model 3680D79
[    7.147602] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    7.148291] thinkpad_acpi: radio switch found; radios are enabled
[    7.155486] thinkpad_acpi: possible tablet mode switch found;
ThinkPad in laptop mode
[    7.217312] Registered led device: tpacpi::thinklight
[    7.217496] Registered led device: tpacpi::power
[    7.217604] Registered led device: tpacpi::standby
[    7.217684] Registered led device: tpacpi::thinkvantage
[    7.259411] thinkpad_acpi: Standard ACPI backlight interface
available, not loading native one
[    7.259723] thinkpad_acpi: Console audio control enabled, mode:
monitor (read only)
[    7.272952] input: ThinkPad Extra Buttons as
/devices/platform/thinkpad_acpi/input/input8
[    7.350002] i2400m_usb 2-1.3:1.0: WiMAX interface wmx0
(64:d4:da:01:7c:d2) ready
[    7.350412] type=1400 audit(1328900761.247:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient" pid=815
comm="apparmor_parser"
[    7.350522] type=1400 audit(1328900761.247:3): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=815
comm="apparmor_parser"
[    7.350634] type=1400 audit(1328900761.247:4): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=815
comm="apparmor_parser"
[    7.377870] cfg80211: World regulatory domain updated:
[    7.377878] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    7.377883] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.377887] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    7.377891] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    7.377894] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.377898] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.429680] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    7.429686] Copyright(c) 2003-2011 Intel Corporation
[    7.429782] xen: registering gsi 16 triggering 0 polarity 1
[    7.429793] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    7.429796] xen: --> pirq=16 -> irq=16 (gsi=16)
[    7.429800] Already setup the GSI :16
[    7.429806] iwlwifi 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.429821] iwlwifi 0000:02:00.0: setting latency timer to 64
[    7.429868] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
[    7.429871] iwlwifi 0000:02:00.0: pci_resource_base = ffffc90011db8000
[    7.429874] iwlwifi 0000:02:00.0: HW Revision ID = 0x57
[    7.430077] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
Advanced-N + WiMAX 6250 AGN, REV=0x84
[    7.430200] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    7.440730] iwlwifi 0000:02:00.0: device EEPROM VER=0x552, CALIB=0x6
[    7.440736] iwlwifi 0000:02:00.0: Device SKU: 0X1f0
[    7.455286] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[    7.470027] iwlwifi 0000:02:00.0: loaded firmware version 41.28.5.1
build 33926
[    7.470232] Registered led device: phy0-led
[    7.470290] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[    7.470415] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.516689] type=1400 audit(1328900761.411:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient" pid=850
comm="apparmor_parser"
[    7.516801] type=1400 audit(1328900761.411:6): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=850
comm="apparmor_parser"
[    7.516904] type=1400 audit(1328900761.411:7): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=850
comm="apparmor_parser"
[    7.620798] type=1400 audit(1328900761.515:8): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient" pid=925
comm="apparmor_parser"
[    7.620871] type=1400 audit(1328900761.515:9): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=925
comm="apparmor_parser"
[    7.620935] type=1400 audit(1328900761.515:10): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=925
comm="apparmor_parser"
[    7.801426] init: failsafe main process (1065) killed by TERM signal
[    7.910728] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.913957] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    7.914150] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[    8.156338] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.156535] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[    8.288139] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    8.422715] audit_printk_skb: 6 callbacks suppressed
[    8.422720] type=1400 audit(1328900762.319:13): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient" pid=1138
comm="apparmor_parser"
[    8.422838] type=1400 audit(1328900762.319:14): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1138
comm="apparmor_parser"
[    8.422949] type=1400 audit(1328900762.319:15): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=1138
comm="apparmor_parser"
[    8.728140] type=1400 audit(1328900762.623:16): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/tcpdump" pid=1148
comm="apparmor_parser"
[    8.773946] type=1400 audit(1328900762.671:17): apparmor="STATUS"
operation="profile_load" name="/usr/lib/telepathy/mission-control-5"
pid=1143 comm="apparmor_parser"
[    8.774221] type=1400 audit(1328900762.671:18): apparmor="STATUS"
operation="profile_load" name="/usr/lib/telepathy/telepathy-*"
pid=1143 comm="apparmor_parser"
[    8.929947] type=1400 audit(1328900762.827:19): apparmor="STATUS"
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
pid=1144 comm="apparmor_parser"
[    8.930114] type=1400 audit(1328900762.827:20): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/cupsd" pid=1144
comm="apparmor_parser"
[   10.068732] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
[   10.278539] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy0
[   10.427627] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: Rx
[   10.428284] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.850641] i2400m_usb 2-1.3:1.0: firmware interface version 9.3.2
[   10.858559] usbcore: registered new interface driver i2400m_usb
[   11.485159] type=1400 audit(1328900765.379:21): apparmor="STATUS"
operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf"
pid=1178 comm="apparmor_parser"
[   11.485350] type=1400 audit(1328900765.383:22): apparmor="STATUS"
operation="profile_replace" name="/usr/sbin/cupsd" pid=1178
comm="apparmor_parser"
[   12.202043] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy0
[   12.370286] cfg80211: Found new beacon on frequency: 5765 MHz (Ch
153) on phy0
[   12.413914] cfg80211: Found new beacon on frequency: 5785 MHz (Ch
157) on phy0
[   12.590083] cfg80211: Found new beacon on frequency: 5805 MHz (Ch
161) on phy0
[   13.426940] microcode: CPU0 update to revision 0x3 failed
[   13.428722] microcode: CPU1 update to revision 0x3 failed
[   13.431006] microcode: CPU2 update to revision 0x3 failed
[   13.432766] microcode: CPU3 update to revision 0x3 failed
[   13.513524] init: apport pre-start process (1240) terminated with status 1
[   13.545471] init: apport post-stop process (1272) terminated with status 1
[   13.564618] show_signal_msg: 9 callbacks suppressed
[   13.564623] irqbalance[1285]: segfault at 4 ip 00007fea0214d356 sp
00007fff3e69b0a0 error 6 in libc-2.13.so[7fea020a4000+195000]
[   13.565180] init: irqbalance main process (1285) killed by SEGV signal
[   13.797418] fuse init (API version 7.17)
[   14.112984] e1000e 0000:00:19.0: eth0: Unsupported MTU setting
[   14.755768] Event-channel device installed.
[   14.821556] XENBUS: Unable to read cpu state
[   14.821748] XENBUS: Unable to read cpu state
[   14.821934] XENBUS: Unable to read cpu state
[   14.822107] XENBUS: Unable to read cpu state
[   15.517474] EXT4-fs (sda6): re-mounted. Opts:
errors=remount-ro,user_xattr,discard,commit=0
[   15.537011] EXT4-fs (sda3): re-mounted. Opts: discard,commit=0
[   15.601896] wlan0: authenticate with 00:24:6c:b1:20:94 (try 1)
[   15.604369] wlan0: authenticated
[   15.604885] wlan0: associate with 00:24:6c:b1:20:94 (try 1)
[   15.642284] wlan0: RX AssocResp from 00:24:6c:b1:20:94 (capab=0x431
status=0 aid=2)
[   15.642291] wlan0: associated
[   15.642747] wlan0: Wrong control channel in association response:
configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11
band: 0.  Disabling HT.
[   15.651745] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   21.025234] eth0: no IPv6 routers present
[   22.011168] init: plymouth-stop pre-start process (2810) terminated
with status 1
[   26.033224] wlan0: no IPv6 routers present
[  114.901222] BUG: soft lockup - CPU#0 stuck for 23s! [perf:2897]
[  114.901305] Modules linked in: xen_netback xen_blkback xen_evtchn
xenfs fuse iwlwifi i2400m_usb thinkpad_acpi i2400m snd_seq_oss wimax
snd_seq_midi snd_hda_codec_hdmi snd_hda_codec_conexant nfsd uvcvideo
nfs snd_hda_intel snd_rawmidi mac80211 snd_hda_codec videodev lockd
snd_hwdep snd_pcm_oss v4l2_compat_ioctl32 snd_seq_midi_event
snd_mixer_oss fscache snd_seq snd_pcm auth_rpcgss cfg80211 psmouse
nfs_acl sunrpc serio_raw intel_ips snd_seq_device binfmt_misc mei(C)
snd_timer snd_page_alloc snd soundcore wmi i915 ahci libahci
drm_kms_helper drm e1000e i2c_algo_bit video
[  114.901427] CPU 0
[  114.901431] Modules linked in: xen_netback xen_blkback xen_evtchn
xenfs fuse iwlwifi i2400m_usb thinkpad_acpi i2400m snd_seq_oss wimax
snd_seq_midi snd_hda_codec_hdmi snd_hda_codec_conexant nfsd uvcvideo
nfs snd_hda_intel snd_rawmidi mac80211 snd_hda_codec videodev lockd
snd_hwdep snd_pcm_oss v4l2_compat_ioctl32 snd_seq_midi_event
snd_mixer_oss fscache snd_seq snd_pcm auth_rpcgss cfg80211 psmouse
nfs_acl sunrpc serio_raw intel_ips snd_seq_device binfmt_misc mei(C)
snd_timer snd_page_alloc snd soundcore wmi i915 ahci libahci
drm_kms_helper drm e1000e i2c_algo_bit video
[  114.901536]
[  114.901542] Pid: 2897, comm: perf Tainted: G         C   3.2.5 #1
LENOVO 3680D79/3680D79
[  114.901552] RIP: e030:[<ffffffff8102b03f>]  [<ffffffff8102b03f>]
apic_send_IPI_self+0xd/0x36
[  114.901570] RSP: e02b:ffff880005a83d08  EFLAGS: 00000202
[  114.901574] RAX: 00000000ffffffff RBX: ffff880069f00801 RCX: 0000000000000000
[  114.901579] RDX: ffff88007ff61e40 RSI: ffff880069f00a88 RDI: 00000000000000f6
[  114.901584] RBP: ffff880005a83d08 R08: 0000000000000008 R09: ffff880006315008
[  114.901589] R10: 00007ffff5aeb470 R11: 0000000000000206 R12: 0000000000000000
[  114.901594] R13: ffff880005a83e30 R14: ffff880005a83f58 R15: 0000000000000000
[  114.901606] FS:  00007f5d7aba7720(0000) GS:ffff88007ff52000(0000)
knlGS:0000000000000000
[  114.901611] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  114.901616] CR2: 0000000000404fcd CR3: 000000000535c000 CR4: 0000000000002660
[  114.901622] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  114.901627] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  114.901632] Process perf (pid: 2897, threadinfo ffff880005a82000,
task ffff8800066f5c80)
[  114.901636] Stack:
[  114.901664]  ffff880005a83d18 ffffffff81012631 ffff880005a83d38
ffffffff810e3a43
[  114.901676]  0000000000000008 ffff880069f00800 ffff880005a83d48
ffffffff810eaf3b
[  114.901687]  ffff880005a83d58 ffffffff810eb16f ffff880005a83dd8
ffffffff810e8d3f
[  114.901699] Call Trace:
[  114.901735]  [<ffffffff81012631>] arch_irq_work_raise+0x27/0x36
[  114.901746]  [<ffffffff810e3a43>] irq_work_queue+0x47/0x6c
[  114.901754]  [<ffffffff810eaf3b>] perf_output_put_handle+0x67/0x69
[  114.901761]  [<ffffffff810eb16f>] perf_output_end+0xe/0x10
[  114.901768]  [<ffffffff810e8d3f>] __perf_event_overflow+0x144/0x17f
[  114.901775]  [<ffffffff810e8e0a>] perf_swevent_overflow+0x90/0xaa
[  114.901782]  [<ffffffff810e8e6b>] perf_swevent_event+0x47/0x49
[  114.901789]  [<ffffffff810e9501>] perf_tp_event+0x68/0x90
[  114.901799]  [<ffffffff815b3a50>] ? do_page_fault+0x32c/0x3b6
[  114.901809]  [<ffffffff810dd6a8>] perf_syscall_enter+0xee/0xfd
[  114.901818]  [<ffffffff810d5202>] ? trace_hardirqs_off_caller+0xe/0x22
[  114.901828]  [<ffffffff810196e1>] syscall_trace_enter+0xda/0x165
[  114.901836]  [<ffffffff815b714c>] tracesys+0x7a/0xde
[  114.901840] Code: 41 5c 5d c3 55 48 89 e5 53 50 66 66 66 66 90 89
f3 e8 3d c2 ff ff 5a 88 d9 d3 f8 5b 5d c3 55 48 89 e5 66 66 66 66 90
eb 02 f3 90 <8b> 04 25 00 b3 5f ff f6 c4 10 75 f2 89 fa b8 00 04 04 00
81 ca
[  114.902568] Call Trace:
[  114.902574]  [<ffffffff81012631>] arch_irq_work_raise+0x27/0x36
[  114.902581]  [<ffffffff810e3a43>] irq_work_queue+0x47/0x6c
[  114.902588]  [<ffffffff810eaf3b>] perf_output_put_handle+0x67/0x69
[  114.902595]  [<ffffffff810eb16f>] perf_output_end+0xe/0x10
[  114.902601]  [<ffffffff810e8d3f>] __perf_event_overflow+0x144/0x17f
[  114.902609]  [<ffffffff810e8e0a>] perf_swevent_overflow+0x90/0xaa
[  114.902615]  [<ffffffff810e8e6b>] perf_swevent_event+0x47/0x49
[  114.902622]  [<ffffffff810e9501>] perf_tp_event+0x68/0x90
[  114.902628]  [<ffffffff815b3a50>] ? do_page_fault+0x32c/0x3b6
[  114.902636]  [<ffffffff810dd6a8>] perf_syscall_enter+0xee/0xfd
[  114.902644]  [<ffffffff810d5202>] ? trace_hardirqs_off_caller+0xe/0x22
[  114.902651]  [<ffffffff810196e1>] syscall_trace_enter+0xda/0x165
[  114.902658]  [<ffffffff815b714c>] tracesys+0x7a/0xde
[  142.901222] BUG: soft lockup - CPU#0 stuck for 23s! [perf:2897]
[  142.901301] Modules linked in: xen_netback xen_blkback xen_evtchn
xenfs fuse iwlwifi i2400m_usb thinkpad_acpi i2400m snd_seq_oss wimax
snd_seq_midi snd_hda_codec_hdmi snd_hda_codec_conexant nfsd uvcvideo
nfs snd_hda_intel snd_rawmidi mac80211 snd_hda_codec videodev lockd
snd_hwdep snd_pcm_oss v4l2_compat_ioctl32 snd_seq_midi_event
snd_mixer_oss fscache snd_seq snd_pcm auth_rpcgss cfg80211 psmouse
nfs_acl sunrpc serio_raw intel_ips snd_seq_device binfmt_misc mei(C)
snd_timer snd_page_alloc snd soundcore wmi i915 ahci libahci
drm_kms_helper drm e1000e i2c_algo_bit video
[  142.901424] CPU 0
[  142.901427] Modules linked in: xen_netback xen_blkback xen_evtchn
xenfs fuse iwlwifi i2400m_usb thinkpad_acpi i2400m snd_seq_oss wimax
snd_seq_midi snd_hda_codec_hdmi snd_hda_codec_conexant nfsd uvcvideo
nfs snd_hda_intel snd_rawmidi mac80211 snd_hda_codec videodev lockd
snd_hwdep snd_pcm_oss v4l2_compat_ioctl32 snd_seq_midi_event
snd_mixer_oss fscache snd_seq snd_pcm auth_rpcgss cfg80211 psmouse
nfs_acl sunrpc serio_raw intel_ips snd_seq_device binfmt_misc mei(C)
snd_timer snd_page_alloc snd soundcore wmi i915 ahci libahci
drm_kms_helper drm e1000e i2c_algo_bit video
[  142.901533]
[  142.901539] Pid: 2897, comm: perf Tainted: G         C   3.2.5 #1
LENOVO 3680D79/3680D79
[  142.901549] RIP: e030:[<ffffffff8102b046>]  [<ffffffff8102b046>]
apic_send_IPI_self+0x14/0x36
[  142.901566] RSP: e02b:ffff880005a83d08  EFLAGS: 00000202
[  142.901571] RAX: 00000000ffffffff RBX: ffff880069f00801 RCX: 0000000000000000
[  142.901576] RDX: ffff88007ff61e40 RSI: ffff880069f00a88 RDI: 00000000000000f6
[  142.901581] RBP: ffff880005a83d08 R08: 0000000000000008 R09: ffff880006315008
[  142.901586] R10: 00007ffff5aeb470 R11: 0000000000000206 R12: 0000000000000000
[  142.901591] R13: ffff880005a83e30 R14: ffff880005a83f58 R15: 0000000000000000
[  142.901602] FS:  00007f5d7aba7720(0000) GS:ffff88007ff52000(0000)
knlGS:0000000000000000
[  142.901607] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  142.901612] CR2: 0000000000404fcd CR3: 000000000535c000 CR4: 0000000000002660
[  142.901617] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  142.901623] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  142.901628] Process perf (pid: 2897, threadinfo ffff880005a82000,
task ffff8800066f5c80)
[  142.901632] Stack:
[  142.901660]  ffff880005a83d18 ffffffff81012631 ffff880005a83d38
ffffffff810e3a43
[  142.901672]  0000000000000008 ffff880069f00800 ffff880005a83d48
ffffffff810eaf3b
[  142.901683]  ffff880005a83d58 ffffffff810eb16f ffff880005a83dd8
ffffffff810e8d3f
[  142.901694] Call Trace:
[  142.901729]  [<ffffffff81012631>] arch_irq_work_raise+0x27/0x36
[  142.901740]  [<ffffffff810e3a43>] irq_work_queue+0x47/0x6c
[  142.901748]  [<ffffffff810eaf3b>] perf_output_put_handle+0x67/0x69
[  142.901755]  [<ffffffff810eb16f>] perf_output_end+0xe/0x10
[  142.901762]  [<ffffffff810e8d3f>] __perf_event_overflow+0x144/0x17f
[  142.901769]  [<ffffffff810e8e0a>] perf_swevent_overflow+0x90/0xaa
[  142.901776]  [<ffffffff810e8e6b>] perf_swevent_event+0x47/0x49
[  142.901782]  [<ffffffff810e9501>] perf_tp_event+0x68/0x90
[  142.901793]  [<ffffffff815b3a50>] ? do_page_fault+0x32c/0x3b6
[  142.901803]  [<ffffffff810dd6a8>] perf_syscall_enter+0xee/0xfd
[  142.901812]  [<ffffffff810d5202>] ? trace_hardirqs_off_caller+0xe/0x22
[  142.901822]  [<ffffffff810196e1>] syscall_trace_enter+0xda/0x165
[  142.901830]  [<ffffffff815b714c>] tracesys+0x7a/0xde
[  142.901834] Code: e5 53 50 66 66 66 66 90 89 f3 e8 3d c2 ff ff 5a
88 d9 d3 f8 5b 5d c3 55 48 89 e5 66 66 66 66 90 eb 02 f3 90 8b 04 25
00 b3 5f ff <f6> c4 10 75 f2 89 fa b8 00 04 04 00 81 ca 00 00 04 00 83
ff 02
[  142.902554] Call Trace:
[  142.902561]  [<ffffffff81012631>] arch_irq_work_raise+0x27/0x36
[  142.902568]  [<ffffffff810e3a43>] irq_work_queue+0x47/0x6c
[  142.902574]  [<ffffffff810eaf3b>] perf_output_put_handle+0x67/0x69
[  142.902581]  [<ffffffff810eb16f>] perf_output_end+0xe/0x10
[  142.902587]  [<ffffffff810e8d3f>] __perf_event_overflow+0x144/0x17f
[  142.902594]  [<ffffffff810e8e0a>] perf_swevent_overflow+0x90/0xaa
[  142.902601]  [<ffffffff810e8e6b>] perf_swevent_event+0x47/0x49
[  142.902607]  [<ffffffff810e9501>] perf_tp_event+0x68/0x90
[  142.902614]  [<ffffffff815b3a50>] ? do_page_fault+0x32c/0x3b6
[  142.902622]  [<ffffffff810dd6a8>] perf_syscall_enter+0xee/0xfd
[  142.902630]  [<ffffffff810d5202>] ? trace_hardirqs_off_caller+0xe/0x22
[  142.902637]  [<ffffffff810196e1>] syscall_trace_enter+0xda/0x165
[  142.902644]  [<ffffffff815b714c>] tracesys+0x7a/0xde
[  148.109211] INFO: rcu_sched detected stall on CPU 0 (t=15000 jiffies)
[  148.109288] sending NMI to all CPUs:
[  148.113212] INFO: rcu_sched detected stalls on CPUs/tasks: { 0}
(detected by 2, t=15002 jiffies)
[  158.027633] iwlwifi 0000:02:00.0: Microcode SW error detected.
Restarting 0x82000000.
[  158.027815] iwlwifi 0000:02:00.0: Loaded firmware version:
41.28.5.1 build 33926
[  158.028021] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[  158.028096] iwlwifi 0000:02:00.0: Status: 0x000412E4, count: 5
[  158.028175] iwlwifi 0000:02:00.0: 0x00000005 | SYSASSERT
[  158.028265] iwlwifi 0000:02:00.0: 0x000256B8 | uPc
[  158.028333] iwlwifi 0000:02:00.0: 0x00025694 | branchlink1
[  158.028406] iwlwifi 0000:02:00.0: 0x00025694 | branchlink2
[  158.028484] iwlwifi 0000:02:00.0: 0x00001C16 | interruptlink1
[  158.028560] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
[  158.028638] iwlwifi 0000:02:00.0: 0x000000FF | data1
[  158.028706] iwlwifi 0000:02:00.0: 0x00000077 | data2
[  158.028773] iwlwifi 0000:02:00.0: 0x00000077 | line
[  158.028843] iwlwifi 0000:02:00.0: 0x51804D33 | beacon time
[  158.031523] iwlwifi 0000:02:00.0: 0xF46E22CC | tsf low
[  158.033935] iwlwifi 0000:02:00.0: 0x0000014E | tsf hi
[  158.036090] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[  158.038235] iwlwifi 0000:02:00.0: 0x08ABD3B5 | time gp2
[  158.040357] iwlwifi 0000:02:00.0: 0x00000000 | time gp3
[  158.042448] iwlwifi 0000:02:00.0: 0x0001291C | uCode version
[  158.044500] iwlwifi 0000:02:00.0: 0x00000084 | hw version
[  158.046539] iwlwifi 0000:02:00.0: 0x00480303 | board version
[  158.048587] iwlwifi 0000:02:00.0: 0x0000001C | hcmd
[  158.050625] iwlwifi 0000:02:00.0: CSR values:
[  158.052630] iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[  158.054737] iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480303
[  158.056857] iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X00000040
[  158.058990] iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
[  158.061101] iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
[  158.063207] iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  158.065332] iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X0000000f
[  158.067447] iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
[  158.069547] iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
[  158.071650] iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000084
[  158.073767] iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X82ce0ffd
[  158.075868] iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X90000801
[  158.077975] iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X00030001
[  158.080082] iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080042
[  158.082162] iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X0000ec0c
[  158.084202] iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000004
[  158.086238] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  158.088119] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  158.089861] iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000058
[  158.091560] iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X881cb2d7
[  158.093248] iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  158.094946] iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  158.096499] iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  158.097914] iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[  158.099283] iwlwifi 0000:02:00.0: FH register values:
[  158.100663] iwlwifi 0000:02:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1c9e6300
[  158.102035] iwlwifi 0000:02:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01c86770
[  158.103390] iwlwifi 0000:02:00.0:
FH_RSCSR_CHNL0_WPTR: 0X000000d0
[  158.104733] iwlwifi 0000:02:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  158.106095] iwlwifi 0000:02:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  158.107454] iwlwifi 0000:02:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03630000
[  158.108842] iwlwifi 0000:02:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  158.110253] iwlwifi 0000:02:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  158.111677] iwlwifi 0000:02:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  158.113153] iwlwifi 0000:02:00.0: Start IWL Event Log Dump: display
last 20 entries
[  158.114624] iwlwifi 0000:02:00.0: EVT_LOGT:0144474344:0x00000187:0736
[  158.116090] iwlwifi 0000:02:00.0: EVT_LOGT:0144474351:0x00000000:0708
[  158.117562] iwlwifi 0000:02:00.0: EVT_LOGT:0144474353:0x00000187:0736
[  158.119032] iwlwifi 0000:02:00.0: EVT_LOGT:0144474360:0x00000000:0708
[  158.120493] iwlwifi 0000:02:00.0: EVT_LOGT:0144474362:0x00000187:0736
[  158.121956] iwlwifi 0000:02:00.0: EVT_LOGT:0144474369:0x00000000:0708
[  158.123406] iwlwifi 0000:02:00.0: EVT_LOGT:0144474371:0x00000187:0736
[  158.124848] iwlwifi 0000:02:00.0: EVT_LOGT:0144474373:0x00000118:0106
[  158.126313] iwlwifi 0000:02:00.0: EVT_LOGT:0144474375:0x00000000:0301
[  158.127778] iwlwifi 0000:02:00.0: EVT_LOGT:0144474558:0x00000000:0355
[  158.129234] iwlwifi 0000:02:00.0: EVT_LOGT:0144476740:0x00000000:0301
[  158.130688] iwlwifi 0000:02:00.0: EVT_LOGT:0144476747:0x00000000:0355
[  158.132115] iwlwifi 0000:02:00.0: EVT_LOGT:0144477449:0x00000000:0708
[  158.133529] iwlwifi 0000:02:00.0: EVT_LOGT:0144477450:0x00000187:0736
[  158.134928] iwlwifi 0000:02:00.0: EVT_LOGT:0144477456:0x00000118:0106
[  158.136302] iwlwifi 0000:02:00.0: EVT_LOGT:0144477458:0x00000000:0301
[  158.137659] iwlwifi 0000:02:00.0: EVT_LOGT:0144477646:0x00000000:0355
[  158.138992] iwlwifi 0000:02:00.0: EVT_LOGT:0144478570:0x0000049b:0511
[  158.140315] iwlwifi 0000:02:00.0: EVT_LOGT:0144478571:0x0000000b:0512
[  158.141651] iwlwifi 0000:02:00.0: EVT_LOGT:0145478604:0x00000000:0125
[  158.143399] ieee80211 phy0: Hardware restart was requested
[  158.143491] sched: RT throttling activated
[  160.169264] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA: time
out after 2000ms.
[  160.170795] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 70 write_ptr 71
[  160.172856] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  160.172984] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
