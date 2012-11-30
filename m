Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2K3XMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 18:12:07 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:60151 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2K3XME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 18:12:04 -0500
X-Remote-IP: 213.191.128.133
Date: Sat, 01 Dec 2012 00:11:57 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121031 Icedove/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
References: <50A78AA9.5040904@iskon.hr> <20121130225200.GB6021@htj.dyndns.org>
In-Reply-To: <20121130225200.GB6021@htj.dyndns.org>
Message-ID: <50B93D3D.3030106@iskon.hr>
Content-Type: multipart/mixed;
 boundary="------------050002030904040408070502"
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121130 #8565717, check: 20121130 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 39717 [Dec 01 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050002030904040408070502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 30.11.2012 23:52, Tejun Heo wrote:
> Hello, Zlatko.
>
> Sorry about the delay.  Your message was in my spam folder.  The
> attachment seems to have confused the filter.
>
> On Sat, Nov 17, 2012 at 02:01:29PM +0100, Zlatko Calusic wrote:
>> This week I spent some hours tracking a regression in 3.7 kernel
>> that was producing high context switch rate on one of my machines. I
>> carefully bisected between 3.6 and 3.7-rc1 and eventually found this
>> commit a culprit:
>>
>> commit e7c2f967445dd2041f0f8e3179cca22bb8bb7f79
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Tue Aug 21 13:18:24 2012 -0700
>>
>>      workqueue: use mod_delayed_work() instead of __cancel + queue
> ...
>>
>> Then I carefully reverted chunk by chunk to find out what exact
>> change is responsible for the regression. You can find it attached
>> as wq.patch (to preserve whitespace). Very simple modification with
>> wildly different behavior on only one of my machines, weird. I'm
>> also attaching ctxt/s graph that shows the impact nicely. I'll
>> gladly provide any additional info that could help you resolve this.
>>
>> Please Cc: on reply (not subscribed to lkml).
>>
>> Regards,
>> --
>> Zlatko
>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 4b4dbdf..4b8b606 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -319,10 +319,8 @@ EXPORT_SYMBOL(__blk_run_queue);
>>    */
>>   void blk_run_queue_async(struct request_queue *q)
>>   {
>> -	if (likely(!blk_queue_stopped(q))) {
>> -		__cancel_delayed_work(&q->delay_work);
>> -		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>> -	}
>> +	if (likely(!blk_queue_stopped(q)))
>> +		mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>>   }
>>   EXPORT_SYMBOL(blk_run_queue_async);
>
> That's intersting.  Is there anything else noticeably different than
> the ctxsw counts?  e.g. CPU usage, IO throughput / latency, etc...
> Also, can you please post the kernel boot log from the machine?  I
> assume that the issue is readily reproducible?  Are you up for trying
> some debug patches?
>
> Thanks.
>

Hey Tejun! Thanks for replying.

It's an older C2D machine, I've attached the kernel boot log. Funny 
thing is that on the other half a dozen machines I don't observe any 
problems, only on this one. And it's reproducible every time. I don't 
see any other anomalies beside the two I already mentioned, high context 
switch rate and ksoftirqd daemons eating more CPU, probably as a 
consequence.

I'll gladly try your patch and send my observations tommorow, as I've 
just started md resync on the machine, which will take couple of hours.

Regards,
-- 
Zlatko

--------------050002030904040408070502
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

Linux version 3.7.0-rc7 (root@ps) (gcc version 4.7.2 (Debian 4.7.2-4) ) #1 SMP Fri Nov 30 23:13:52 CET 2012
Command line: root=/dev/md0 rootfstype=ext4 profile=2 ro BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc7 
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000cf239fff] usable
BIOS-e820: [mem 0x00000000cf23a000-0x00000000cf27cfff] ACPI NVS
BIOS-e820: [mem 0x00000000cf27d000-0x00000000cf354fff] reserved
BIOS-e820: [mem 0x00000000cf355000-0x00000000cf364fff] ACPI NVS
BIOS-e820: [mem 0x00000000cf365000-0x00000000cf3e0fff] reserved
BIOS-e820: [mem 0x00000000cf3e1000-0x00000000cf3e6fff] ACPI data
BIOS-e820: [mem 0x00000000cf3e7000-0x00000000cf3e7fff] ACPI NVS
BIOS-e820: [mem 0x00000000cf3e8000-0x00000000cf3e9fff] ACPI data
BIOS-e820: [mem 0x00000000cf3ea000-0x00000000cf3ebfff] ACPI NVS
BIOS-e820: [mem 0x00000000cf3ec000-0x00000000cf3ecfff] reserved
BIOS-e820: [mem 0x00000000cf3ed000-0x00000000cf3f0fff] ACPI NVS
BIOS-e820: [mem 0x00000000cf3f1000-0x00000000cf3fffff] reserved
BIOS-e820: [mem 0x00000000cf400000-0x00000000cf5fffff] usable
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffbfffff] reserved
BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI:                  /DG31PR, BIOS PRG3110H.86A.0065.2009.0421.1559 04/21/2009
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-E7FFF uncachable
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F00000000 write-back
  1 base 100000000 mask FE0000000 write-back
  2 base 120000000 mask FF0000000 write-back
  3 base 0CF600000 mask FFFE00000 uncachable
  4 base 0CF800000 mask FFF800000 uncachable
  5 base 0D0000000 mask FF0000000 uncachable
  6 base 0E0000000 mask FE0000000 uncachable
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 4GB, type WB
reg 1, base: 4GB, range: 512MB, type WB
reg 2, base: 4608MB, range: 256MB, type WB
reg 3, base: 3318MB, range: 2MB, type UC
reg 4, base: 3320MB, range: 8MB, type UC
reg 5, base: 3328MB, range: 256MB, type UC
reg 6, base: 3584MB, range: 512MB, type UC
total RAM covered: 4086M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3GB, range: 256MB, type WB
reg 3, base: 3318MB, range: 2MB, type UC
reg 4, base: 3320MB, range: 8MB, type UC
reg 5, base: 4GB, range: 512MB, type WB
reg 6, base: 4608MB, range: 256MB, type WB
e820: update [mem 0xcf600000-0xffffffff] usable ==> reserved
e820: last_pfn = 0xcf600 max_arch_pfn = 0x400000000
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000099000] 99000 size 24576
init_memory_mapping: [mem 0x00000000-0xcf5fffff]
 [mem 0x00000000-0xcf5fffff] page 2M
kernel direct mapping tables up to 0xcf5fffff @ [mem 0x1fffb000-0x1fffffff]
init_memory_mapping: [mem 0x100000000-0x12fffffff]
 [mem 0x100000000-0x12fffffff] page 2M
kernel direct mapping tables up to 0x12fffffff @ [mem 0xcf5fe000-0xcf5fffff]
ACPI: RSDP 00000000000f03f0 00024 (v02  INTEL)
ACPI: XSDT 00000000cf3e8f10 00044 (v01  INTEL   DG31PR 06222004 MSFT 00010013)
ACPI: FACP 00000000cf3e6d90 000F4 (v04  INTEL   DG31PR 06222004 MSFT 00010013)
ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20120913/tbfadt-394)
ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in FADT - 0xCF3EBF40/0x00000000CF3E7F40, using 32 (20120913/tbfadt-521)
ACPI: DSDT 00000000cf3e1010 04BE9 (v01  INTEL   DG31PR 00000000 INTL 20051117)
ACPI: FACS 00000000cf3ebf40 00040
ACPI: APIC 00000000cf3e6f10 0006C (v02  INTEL   DG31PR 06222004 MSFT 00010013)
ACPI: HPET 00000000cf3efd10 00038 (v01  INTEL ICH7HPET 06222004 AMI. 00000001)
ACPI: MCFG 00000000cf3efc10 0003C (v01 INTEL  DG31PR   06222004 MSFT 00000097)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012b600000-ffff88012f5fffff] on node 0
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x12fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x0009efff]
  node   0: [mem 0x00100000-0xcf239fff]
  node   0: [mem 0xcf400000-0xcf5fffff]
  node   0: [mem 0x100000000-0x12fffffff]
On node 0 totalpages: 1045449
  DMA zone: 64 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3913 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 828538 pages, LIFO batch:31
  Normal zone: 3072 pages used for memmap
  Normal zone: 193536 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 40
e820: [mem 0xcf600000-0xfed1bfff] available for PCI devices
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88012fc00000 s72640 r8192 d21568 u524288
pcpu-alloc: s72640 r8192 d21568 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1025987
Kernel command line: root=/dev/md0 rootfstype=ext4 profile=2 ro BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc7 
kernel profiling enabled (shift: 2)
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
__ex_table already sorted, skipping sort
Checking aperture...
No AGP bridge found
Memory: 4037360k/4980736k available (3780k kernel code, 798940k absent, 144436k reserved, 1503k data, 456k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
NR_IRQS:4352 nr_irqs:712 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2399.873 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 4799.74 BogoMIPS (lpj=9599492)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
process: using mwait in idle threads
Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20120913
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel 06/17 (fam: 06, model: 17, stepping: 0a)
Performance Events: 4-deep LBR, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
smpboot: Booting Node   0, Processors  #1
Brought up 2 CPUs
smpboot: Total of 2 processors activated (9599.49 BogoMIPS)
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xd0000000-0xffffffff]
pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
pci 0000:00:01.0: [8086:29c1] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: [8086:29c2] type 00 class 0x030000
pci 0000:00:02.0: reg 10: [mem 0xff900000-0xff97ffff]
pci 0000:00:02.0: reg 14: [io  0xf140-0xf147]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xff700000-0xff7fffff]
pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xff980000-0xff983fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
pci 0000:00:1d.3: reg 20: [io  0xf020-0xf03f]
pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0xff984000-0xff9843ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:27b8] type 00 class 0x060100
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0290 (mask 00ff)
pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
pci 0000:00:1f.1: reg 10: [io  0xf130-0xf137]
pci 0000:00:1f.1: reg 14: [io  0xf120-0xf123]
pci 0000:00:1f.1: reg 18: [io  0xf110-0xf117]
pci 0000:00:1f.1: reg 1c: [io  0xf100-0xf103]
pci 0000:00:1f.1: reg 20: [io  0xf0f0-0xf0ff]
pci 0000:00:1f.2: [8086:27c0] type 00 class 0x01018f
pci 0000:00:1f.2: reg 10: [io  0xf0e0-0xf0e7]
pci 0000:00:1f.2: reg 14: [io  0xf0d0-0xf0d3]
pci 0000:00:1f.2: reg 18: [io  0xf0c0-0xf0c7]
pci 0000:00:1f.2: reg 1c: [io  0xf0b0-0xf0b3]
pci 0000:00:1f.2: reg 20: [io  0xf0a0-0xf0af]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:02:06.0: [8086:1229] type 00 class 0x020000
pci 0000:02:06.0: reg 10: [mem 0xff830000-0xff830fff]
pci 0000:02:06.0: reg 14: [io  0xe000-0xe03f]
pci 0000:02:06.0: reg 18: [mem 0xff800000-0xff81ffff]
pci 0000:02:06.0: reg 30: [mem 0xff820000-0xff82ffff pref]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 02] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xff800000-0xff8fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
ACPI: bus type scsi registered
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
e820: reserve RAM buffer [mem 0xcf23a000-0xcfffffff]
e820: reserve RAM buffer [mem 0xcf600000-0xcfffffff]
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: [mem 0xd0000000-0xffffffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfed14000-0xfed19fff]
pnp 00:01: [mem 0xe0000000-0xe3ffffff]
system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: [io  0x0400-0x047f]
pnp 00:02: [io  0x1180-0x119f]
pnp 00:02: [io  0x0500-0x053f]
pnp 00:02: [mem 0xfec00000-0xfecfffff]
pnp 00:02: [mem 0xfee00000-0xfee0ffff]
pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
pnp 00:02: [mem 0xffb00000-0xffcfffff]
pnp 00:02: [mem 0xfc800000-0xfc800fff]
pnp 00:02: [mem 0xfed20000-0xfed7ffff]
pnp 00:02: [mem 0xffe00000-0xffffffff]
system 00:02: [io  0x0400-0x047f] has been reserved
system 00:02: [io  0x1180-0x119f] has been reserved
system 00:02: [io  0x0500-0x053f] has been reserved
system 00:02: [mem 0xfec00000-0xfecfffff] could not be reserved
system 00:02: [mem 0xfee00000-0xfee0ffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xffb00000-0xffcfffff] could not be reserved
system 00:02: [mem 0xfc800000-0xfc800fff] has been reserved
system 00:02: [mem 0xfed20000-0xfed7ffff] has been reserved
system 00:02: [mem 0xffe00000-0xffffffff] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:03: [io  0x0290-0x029f]
pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
system 00:03: [io  0x0290-0x029f] has been reserved
system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:04: [io  0x03f8-0x03ff]
pnp 00:04: [irq 4]
pnp 00:04: [dma 0 disabled]
pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:05: [dma 4]
pnp 00:05: [io  0x0000-0x000f]
pnp 00:05: [io  0x0081-0x0083]
pnp 00:05: [io  0x0087]
pnp 00:05: [io  0x0089-0x008b]
pnp 00:05: [io  0x008f]
pnp 00:05: [io  0x00c0-0x00df]
pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:06: [io  0x0070-0x0071]
pnp 00:06: [irq 8]
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0061]
pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:08: [io  0x0010-0x001f]
pnp 00:08: [io  0x0022-0x003f]
pnp 00:08: [io  0x0044-0x005f]
pnp 00:08: [io  0x0062-0x0063]
pnp 00:08: [io  0x0065-0x006f]
pnp 00:08: [io  0x0072-0x007f]
pnp 00:08: [io  0x0080]
pnp 00:08: [io  0x0084-0x0086]
pnp 00:08: [io  0x0088]
pnp 00:08: [io  0x008c-0x008e]
pnp 00:08: [io  0x0090-0x009f]
pnp 00:08: [io  0x00a2-0x00bf]
pnp 00:08: [io  0x00e0-0x00ef]
pnp 00:08: [io  0x04d0-0x04d1]
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: [io  0x00f0-0x00ff]
pnp 00:09: [irq 13]
pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:0a: [mem 0xfed00000-0xfed003ff]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:1e.0: PCI bridge to [bus 02]
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xff800000-0xff8fffff]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xd0000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xff800000-0xff8fffff]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0xd0000000-0xffffffff]
NET: Registered protocol family 2
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xcb23a000-0xcf239fff] (64MB) mapped at [ffff8800cb23a000-ffff8800cf239fff]
squashfs: version 4.0 (2009/01/31) Phillip Lougher
fuse init (API version 7.20)
msgmni has been set to 7885
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Non-volatile memory driver v1.3
brd: module loaded
loop: module loaded
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0f0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf0f8 irq 15
ata_piix 0000:00:1f.2: MAP [
 P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
ata2: port disabled--ignoring
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 19
ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 19
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:02:06.0 eth0: addr 0xff830000, irq 21, MAC addr 00:02:b3:29:95:0b
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
w83627ehf: Found W83627DHG chip at 0x290
md: raid1 personality registered for level 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
oprofile: using NMI interrupt.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP: cubic registered
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
NET: Registered protocol family 17
registered taskstats version 1
rtc_cmos 00:06: setting system clock to 2012-11-30 22:17:26 UTC (1354313846)
ata3.00: ATA-8: SAMSUNG HM251JI, 2SS00_01, max UDMA7
ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: failed to get Identify Device Data, Emask 0x1
ata4.00: ATA-8: SAMSUNG HM250JI, HS100-08, max UDMA7
ata4.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: failed to get Identify Device Data, Emask 0x1
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HM251JI  2SS0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
ata4.00: failed to get Identify Device Data, Emask 0x1
ata4.00: failed to get Identify Device Data, Emask 0x1
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HM250JI  HS10 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 3:0:0:0: [sdb] Attached SCSI disk
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
md/raid1:md1: active with 2 out of 2 mirrors
created bitmap (2 pages) for device md1
md1: bitmap initialized from disk: read 1 pages, set 0 of 3247 bits
md1: detected capacity change from 0 to 217838190592
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
md/raid1:md0: active with 2 out of 2 mirrors
created bitmap (1 pages) for device md0
md0: bitmap initialized from disk: read 1 pages, set 0 of 481 bits
tsc: Refined TSC clocksource calibration: 2399.951 MHz
Switching to clocksource tsc
md0: detected capacity change from 0 to 32218349568
md: ... autorun DONE.
 md0: unknown partition table
EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
devtmpfs: mounted
Freeing unused kernel memory: 456k freed
udevd[160]: starting version 175
microcode: CPU0 sig=0x1067a, pf=0x1, revision=0x0
microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
microcode: CPU1 sig=0x1067a, pf=0x1, revision=0x0
microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
 md1: unknown partition table
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
EXT4-fs (md0): re-mounted. Opts: (null)
EXT4-fs (md0): re-mounted. Opts: barrier=0
EXT4-fs (md1): barriers disabled
EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: barrier=0
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
e100 0000:02:06.0 eth0: NIC Link is Up 100 Mbps Full Duplex
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--------------050002030904040408070502--
