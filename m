Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0JWEYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 00:24:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0JWEYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 00:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :x-location:x-accept-language:user-agent;
        b=H44d6swVgtmPX7D5DXNTneN0xmHC4IUJ3TnJHJ/Cp9KBv9fbvspSWKD+CFCc/4V8St
         ufBjURY1jRlHCbuJgZ7QG2cqoD/up9aTxWXfSS/e488ILqjpHrNJX8O4ZVoU30beMqTJ
         eBvR/WtwL1N9WzKSy18gC6FNRkjUfsx74I0LI=
Date: Sat, 23 Oct 2010 06:26:07 +0200
From: Christian Ruediger Bahls <lkml@qb352.de>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: intel_idle .. Was: __pm_runtime_resume() returns -1 Was:
 Regression in 2.6.36
Message-ID: <20101023042607.GB449@pfau.e-technik1.uni-rostock.de>
References: <AANLkTinPyg2ijrBydVyoGJiQJCpL7j1_vnyQWnx0eucz@mail.gmail.com>
 <20101022165734.d7ed2582.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022165734.d7ed2582.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.36-rc7 x86_64
X-Location: Rostock
X-Accept-Language: de, en
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[2010-10-23 01:58] Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 22 Oct 2010 15:38:01 +0200
> Christian Bahls <lkml@qb352.de> wrote:
> > The regression seems to have been introduced by the merge:
> >   92b4522f72916ff2675060e29e4b24cf26ab59ce
> > 
>
> I suspect your bisection went wrong :(
...
> It's really hard to see how that change could break the resume
> operation.

you were right ..

btw: this is not resume but system boot .. either cold or warm
 [pressing any button(even the power-button) makes the boot continue]

the failure has lots of different incarnations:
 during booting it sometimes stalls:
 on initializing the sata drive
 while mounting/un-mounting the sata drive
 or other obscure occasions (syncing drives/initializing hardware)

in later versions of the kernel it throws the 
 "__pm_runtime_resume() returns -1"-warnings

though it doesn't in earlier kernels that have the bug
 (which might be the reason why my first bisection stopped around 2.6.35-rc1)

i can now quite reliably trigger it with hotplugging the wireless
Oct 23 05:14:00 ionic kernel: [   17.602089] rtl819xE:ERR in CPUcheck_maincodeok_turnonCPU()
Oct 23 05:15:09 ionic kernel: [   24.620442] rtl819xE:ERR in CPUcheck_maincodeok_turnonCPU()
Oct 23 05:17:18 ionic kernel: [   10.476819] rtl819xE:ERR in CPUcheck_maincodeok_turnonCPU()

so i've rerun the bisection ..
.. making sure the environment stays the same all the time
 (keeping the powersupply plugged in at all times for example)

i end up at:

commit 2671717265ae6e720a9ba5f13fbec3a718983b65
Author: Len Brown <len.brown@intel.com>
Date:   Mon Mar 8 14:07:30 2010 -0500

    intel_idle: native hardware cpuidle driver for latest Intel processors
    
    This EXPERIMENTAL driver supersedes acpi_idle on
    Intel Atom Processors, Intel Core i3/i5/i7 Processors
    and associated Intel Xeon processors.
    
and yes indeed booting with "intel_idle.max_cstate=0"
makes the system work again

i included Len Brown in this mail
 am more than willing to make intel_idle work
  on this system (a samsung n510 @nynet netbook)

yours
  Christian

my /proc/cpuinfo:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      : Intel(R) Atom(TM) CPU N270   @ 1.60GHz
stepping        : 2
cpu MHz         : 1599.648
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx constant_tsc up arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 xtpr pdcm movbe lahf_lm
bogomips        : 3199.29
clflush size    : 64
cache_alignment : 64
address sizes   : 32 bits physical, 32 bits virtual
power management:

hopefully most significant part of a dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-5-686 (Debian 2.6.32-24) (ben@decadent.org.uk) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Thu Sep 30 03:56:23 UTC 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000006feb0000 (usable)
[    0.000000]  BIOS-e820: 000000006feb0000 - 000000006fec1000 (ACPI data)
[    0.000000]  BIOS-e820: 000000006fec1000 - 000000006fec2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000006fec2000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x6feb0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-D7FFF uncachable
[    0.000000]   D8000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 080000000 write-back
[    0.000000]   1 base 07FF00000 mask 0FFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] RAMDISK: 376f6000 - 37fefc85
[    0.000000] Allocated new RAMDISK: 00100000 - 009f9c85
[    0.000000] Move RAMDISK from 00000000376f6000 - 0000000037fefc84 to 00100000 - 009f9c84
[    0.000000] ACPI: RSDP 000f6f10 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 6feb7b9a 0006C (v01 SECCSD LH43STAR 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 6fec0c96 000F4 (v03 NVIDIA MCP79    06040000 PTL_ 000F4240)
[    0.000000] ACPI: DSDT 6feb9aaf 07173 (v01 NVIDIA    MCP79 06040000 MSFT 03000001)
[    0.000000] ACPI: FACS 6fec1fc0 00040
[    0.000000] ACPI: SLIC 6fec0d8a 00176 (v01 SECCSD LH43STAR 06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 6fec0f00 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 6fec0f3c 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC 6fec0f74 00064 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 6fec0fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 6feb97a3 0030C (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
[    0.000000] ACPI: SSDT 6feb8fef 007B4 (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
[    0.000000] ACPI: SSDT 6feb7c06 013E9 (v01  PmRef    CpuPm 00003000 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 906MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00012000 - 00018e80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00014c7bb4]    TEXT DATA BSS ==> [0001000000 - 00014c7bb4]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
[    0.000000]   #5 [00014c8000 - 00014ce1b8]              BRK ==> [00014c8000 - 00014ce1b8]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000100000 - 00009f9c85]      NEW RAMDISK ==> [0000100000 - 00009f9c85]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
[    0.000000] found SMP MP-table at [c00f6fb0] f6fb0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0006feb0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0006feb0
[    0.000000] On node 0 totalpages: 458301
[    0.000000] free_area_init_node: node 0, pgdat c13b2700, node_mem_map c14d0200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1814 pages used for memmap
[    0.000000]   HighMem zone: 230300 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10dea301 base: 0xfed00000
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2400000 s34296 r0 d23048 u4194304
[    0.000000] pcpu-alloc: s34296 r0 d23048 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 454719
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-5-686 root=UUID=8531edf4-7fc9-46b8-bc38-4f4ffdd38e64 ro intel_idle.max_cstate=0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000373fe:0006feb0)
[    0.000000] Memory: 1802956k/1833664k available (2499k kernel code, 29360k reserved, 1325k data, 372k init, 928456k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc13bd000 - 0xc141a000   ( 372 kB)
[    0.000000]       .data : 0xc1270d29 - 0xc13bc2e0   (1325 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1270d29   (2499 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1599.762 MHz processor.

