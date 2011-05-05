Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1EELxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 07:53:16 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:56710 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1EELxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 07:53:13 -0400
Date: Thu, 5 May 2011 13:34:48 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, yinghai@kernel.org, hpa@zytor.com,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page table high"
Message-ID: <20110505113448.GA6463@router-fw-old.local.net-space.pl>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com> <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com> <20110503005527.GA6735@router-fw-old.local.net-space.pl> <20110503151206.GA8868@dumpdata.com> <20110503195141.GA15775@router-fw-old.local.net-space.pl> <20110504185903.GA29903@router-fw-old.local.net-space.pl> <20110504193353.GA24996@dumpdata.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20110504193353.GA24996@dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 04, 2011 at 03:33:53PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 04, 2011 at 08:59:03PM +0200, Daniel Kiper wrote:
> > On Tue, May 03, 2011 at 09:51:41PM +0200, Daniel Kiper wrote:
> > > On Tue, May 03, 2011 at 11:12:06AM -0400, Konrad Rzeszutek Wilk wrote:
> > > > On Tue, May 03, 2011 at 02:55:27AM +0200, Daniel Kiper wrote:
> > > > > On Mon, May 02, 2011 at 01:22:21PM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > [...]
> > 
> > > > > I think that (Stefano please confirm or not) this patch was prepared
> > > > > as workaround for similar issues. However, I do not like this patch
> 
> It was actually to fix SandyBridge boxes. Their last E820 reserved
> region was around fed40000 and then the RAM region started at
> 100000000. Which meant that we misinterpreted the gap (starting at fed40 mfn)
> as the start of RAM.

Thanks.

> > > > > because on systems with small amount of memory it leaves huge (to some
> > > > > extent) hole between max_low_pfn and 4G. Additionally, it affects
> > > > > memory hotplug a bit because it allocates memory starting from current
> > > > > max_mfn. It also breaks memory hotplug on i386 (maybe also others
> > > > > thinks, however, I could not confirm that). If it stay for some
> > > > > reason it should be amended in follwing way:
> > > > >
> > > > > #ifdef CONFIG_X86_32
> > > > >         xen_extra_mem_start = mem_end;
> > > > > #else
> > > > >         xen_extra_mem_start = max((1ULL << 32), mem_end);
> > > > > #endif
> > > > >
> > > > > Regarding comment for this patch it should be mentioned that without this
> > > > > patch e820_end_of_low_ram_pfn() is not broken. It is not called simply.
> 
> Hmm. What is max_pfn set to?
> Can you send the full dmesg of your guest?

Look into attachments. Both dmesgs are from plain 2.6.39-rc6.
Guests had allocated 2 GiB of memory.

> > > > > Last but least. I found that memory sizes below and including exactly 1 GiB and
> > > > > exactly 2 GiB, 3 GiB (maybe higher, i.e. 4 GiB, 5 GiB, ...; I was not able to test
> > > > > them because I do not have sufficient memory) are magic. It means that if memory
> > > > > is set with those sizes everything is working good (without 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> > > > > and 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 applied). It means that domU
> > > > > should be tested with sizes which are not power of two nor multiple of that.
> > > >
> > > > Hmm, I thought I did test 1500M.
> > >
> > > It does not work on my machine (24bdb0b62cc82120924762ae6bc85afc8c3f2b26
> > > removed and 4b239f458c229de044d6905c2b0f9fe16ed9e01e applied).
> > 
> > It does not work on my machine (x86_64) with Linux Kernel Ver. 2.6.39-rc6 without
> > git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
> > e820 region at an addr lower than 4G). As I said ealier bug introduced by git
> > commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table
> > high) is probably hidden (repaird/workarounded ???) by git commit
> > 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
> > e820 region at an addr lower than 4G).
> 
> There are a couple of things that have been going to fix "x86-64, mm: Put
> early page table high" and also .. "cleanup highmem" (something) - which
> has been plaguing us since 2.6.32 (and was the one you hit long time ago).
> 
> Anyhow, regarding the setting xen_extra_mem_start to 4GB or higher should
> be reworked. Not sure yet how. 

OK. As I can see it is __VERY__ difficult problem. I will wait for
proper solution. However, if I could help you in any way
please drop me a line.

Daniel

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.i386"

Reserving virtual address space above 0xf5800000
Linux version 2.6.39-rc6-i386.xenU.all.r0+ (root@dte40r0-um-i386) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Wed May 4 19:50:41 CEST 2011
ACPI in unprivileged domain disabled
released 0 pages of unused memory
Set 0 page(s) to 1-1 mapping.
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000080000000 (usable)
 Xen: 0000000100000000 - 0000000100800000 (usable)
NX (Execute Disable) protection: active
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x100800 max_arch_pfn = 0x1000000
initial memory mapped : 0 - 016ba000
Base memory trampoline at [c009f000] 9f000 size 4096
init_memory_mapping: 0000000000000000-000000002d3fe000
 0000000000 - 002d3fe000 page 4k
kernel direct mapping tables up to 2d3fe000 @ 154d000-16ba000
3380MB HIGHMEM available.
723MB LOWMEM available.
  mapped low ram: 0 - 2d3fe000
  low ram: 0 - 2d3fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0002d3fe
  HighMem  0x0002d3fe -> 0x00100800
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x00080000
    0: 0x00100000 -> 0x00100800
On node 0 totalpages: 526224
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3952 pages, LIFO batch:0
  Normal zone: 1416 pages used for memmap
  Normal zone: 179830 pages, LIFO batch:31
  HighMem zone: 6761 pages used for memmap
  HighMem zone: 334233 pages, LIFO batch:31
Using APIC driver default
SMP: Allowing 4 CPUs, 0 hotplug CPUs
APIC: disable apic facility
APIC: switched to apic NOOP
nr_irqs_gsi: 16
Allocating PCI resources starting at 80000000 (gap: 80000000:80000000)
Booting paravirtualized kernel on Xen
Xen version: 4.1.1-rc1-pre (preserve-AD)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @ebfa6000 s28160 r0 d20992 u49152
pcpu-alloc: s28160 r0 d20992 u49152 alloc=12*4096
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 518015
Kernel command line: root=/dev/xvda noapic nolapic softdog.nowayout=1 softdog.soft_margin=180 tmem console=hvc0
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (0002d3fe:00100800)
Memory: 2067168k/4202496k available (2573k kernel code, 29536k reserved, 1179k data, 356k init, 1355784k highmem)
virtual kernel memory layout:
    fixmap  : 0xf5766000 - 0xf57ff000   ( 612 kB)
    pkmap   : 0xf5400000 - 0xf5600000   (2048 kB)
    vmalloc : 0xedbfe000 - 0xf53fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xed3fe000   ( 723 MB)
      .init : 0xc13ab000 - 0xc1404000   ( 356 kB)
      .data : 0xc12837d4 - 0xc13aa640   (1179 kB)
      .text : 0xc1000000 - 0xc12837d4   (2573 kB)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:384
CPU 0 irqstacks, hard=eb80c000 soft=eb80e000
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
Xen: using vcpuop timer interface
installing Xen timer for CPU 0
Detected 2666.856 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.71 BogoMIPS (lpj=26668560)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
cpu 0 spinlock event irq 17
Performance Events: unsupported p6 CPU model 15 no PMU driver, software events only.
CPU 1 irqstacks, hard=eb870000 soft=eb872000
installing Xen timer for CPU 1
cpu 1 spinlock event irq 23
SMP alternatives: switching to SMP code
Initializing CPU#1
CPU 2 irqstacks, hard=eb87a000 soft=eb87c000
installing Xen timer for CPU 2
cpu 2 spinlock event irq 29
Initializing CPU#2
CPU 3 irqstacks, hard=eb884000 soft=eb886000
installing Xen timer for CPU 3
cpu 3 spinlock event irq 35
Initializing CPU#3
Brought up 4 CPUs
Grant table initialized
NET: Registered protocol family 16
PCI: setting up Xen PCI frontend stub
PCI: pci_cache_line_size set to 64 bytes
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
xen/balloon: Initialising balloon driver.
last_pfn = 0x100800 max_arch_pfn = 0x1000000
xen-balloon: Initialising balloon driver.
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: System does not support PCI
PCI: System does not support PCI
Switching to clocksource xen
pnp: PnP ACPI: disabled
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
PCI: CLS 0 bytes, default 64
platform rtc_cmos: registered platform RTC device (no PNP device found)
highmem bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
NTFS driver 2.1.30 [Flags: R/W].
msgmni has been set to 1405
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
Event-channel device installed.
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
loop: module loaded
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
Initialising Xen virtual ethernet driver.
blkfront: xvda: barriers enabled
 xvda:
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
blkfront: xvdb: barriers enabled
mousedev: PS/2 mouse device common for all mice
 xvdb: unknown partition table
Setting capacity to 2097152
xvdb: detected capacity change from 0 to 1073741824
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of rtc_cmos failed with error -38
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=180 sec soft_panic=0 (nowayout= 1)
cpuidle: using governor ladder
cpuidle: using governor menu
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
xt_time: kernel timezone is -0000
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
XENBUS: Device with no driver: device/console/0
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
REISERFS (device xvda): found reiserfs format "3.6" with standard journal
REISERFS (device xvda): using ordered data mode
REISERFS (device xvda): journal params: device xvda, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
REISERFS (device xvda): checking transaction log (xvda)
REISERFS (device xvda): Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) on device 202:0.
Freeing unused kernel memory: 356k freed
udevd (502): /proc/502/oom_adj is deprecated, please use /proc/502/oom_score_adj instead.
Adding 1048572k swap on /dev/xvdb.  Priority:-1 extents:1 across:1048572k SS
blkfront: xvda: empty write barrier op failed
blkfront: xvda: barriers disabled

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.x86_64"

Linux version 2.6.39-rc6-x86_64.xenU.all.r0+ (root@dte40r0-um-i386) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Wed May 4 19:32:40 CEST 2011
Command line: root=/dev/xvda noapic nolapic softdog.nowayout=1 softdog.soft_margin=180 tmem console=hvc0
ACPI in unprivileged domain disabled
released 0 pages of unused memory
Set 0 page(s) to 1-1 mapping.
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000080000000 (usable)
 Xen: 0000000100000000 - 0000000100800000 (usable)
NX (Execute Disable) protection: active
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x100800 max_arch_pfn = 0x400000000
last_pfn = 0x80000 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 01693000
Base memory trampoline at [ffff88000009e000] 9e000 size 8192
init_memory_mapping: 0000000000000000-0000000080000000
 0000000000 - 0080000000 page 4k
kernel direct mapping tables up to 80000000 @ 7fbfd000-80000000
init_memory_mapping: 0000000100000000-0000000100800000
 0100000000 - 0100800000 page 4k
kernel direct mapping tables up to 100800000 @ 7f3f3000-7fbfd000
xen: setting RW the range 7ffec000 - 80000000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100800
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x00080000
    0: 0x00100000 -> 0x00100800
On node 0 totalpages: 526224
  DMA zone: 56 pages used for memmap
  DMA zone: 2 pages reserved
  DMA zone: 3926 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505912 pages, LIFO batch:31
  Normal zone: 28 pages used for memmap
  Normal zone: 2020 pages, LIFO batch:0
xen: setting RW the range 7f3f8000 - 7fbfd000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
No local APIC present
APIC: disable apic facility
APIC: switched to apic NOOP
nr_irqs_gsi: 16
Allocating PCI resources starting at 80000000 (gap: 80000000:80000000)
Booting paravirtualized kernel on Xen
Xen version: 4.1.1-rc1-pre (preserve-AD)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff88007fb45000 s78592 r8192 d23808 u110592
pcpu-alloc: s78592 r8192 d23808 u110592 alloc=27*4096
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 511858
Kernel command line: root=/dev/xvda noapic nolapic softdog.nowayout=1 softdog.soft_margin=180 tmem console=hvc0
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 1982568k/4202496k available (3016k kernel code, 2097600k absent, 122328k reserved, 1580k data, 476k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
	CONFIG_RCU_FANOUT set to non-default value of 32
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:384
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
Xen: using vcpuop timer interface
installing Xen timer for CPU 0
Detected 2666.856 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.71 BogoMIPS (lpj=26668560)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
cpu 0 spinlock event irq 17
Performance Events: unsupported p6 CPU model 15 no PMU driver, software events only.
installing Xen timer for CPU 1
cpu 1 spinlock event irq 23
SMP alternatives: switching to SMP code
installing Xen timer for CPU 2
cpu 2 spinlock event irq 29
installing Xen timer for CPU 3
cpu 3 spinlock event irq 35
Brought up 4 CPUs
Grant table initialized
NET: Registered protocol family 16
PCI: setting up Xen PCI frontend stub
PCI: pci_cache_line_size set to 64 bytes
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
xen/balloon: Initialising balloon driver.
last_pfn = 0x100800 max_arch_pfn = 0x400000000
xen-balloon: Initialising balloon driver.
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: System does not support PCI
PCI: System does not support PCI
Switching to clocksource xen
pnp: PnP ACPI: disabled
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
PCI: CLS 0 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880079000000 - ffff88007d000000
software IO TLB at phys 0x79000000 - 0x7d000000
platform rtc_cmos: registered platform RTC device (no PNP device found)
HugeTLB registered 2 MB page size, pre-allocated 0 pages
NTFS driver 2.1.30 [Flags: R/W].
msgmni has been set to 3872
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
Event-channel device installed.
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
loop: module loaded
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
Initialising Xen virtual ethernet driver.
blkfront: xvda: barriers enabled
 xvda:
Setting capacity to 209715200
xvda: detected capacity change from 0 to 107374182400
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
blkfront: xvdb: barriers enabled
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
mousedev: PS/2 mouse device common for all mice
 xvdb: unknown partition table
Setting capacity to 2097152
xvdb: detected capacity change from 0 to 1073741824
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of rtc_cmos failed with error -38
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=180 sec soft_panic=0 (nowayout= 1)
cpuidle: using governor ladder
cpuidle: using governor menu
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
xt_time: kernel timezone is -0000
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
XENBUS: Device with no driver: device/console/0
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
REISERFS (device xvda): found reiserfs format "3.6" with standard journal
REISERFS (device xvda): using ordered data mode
REISERFS (device xvda): journal params: device xvda, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
REISERFS (device xvda): checking transaction log (xvda)
REISERFS (device xvda): Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) on device 202:0.
Freeing unused kernel memory: 476k freed
udevd (520): /proc/520/oom_adj is deprecated, please use /proc/520/oom_score_adj instead.
ioctl32(fgconsole:774): Unknown cmd fd(3) cmd(00005603){t:'V';sz:0} arg(ffbbd53e) on /dev/console
Adding 1048572k swap on /dev/xvdb.  Priority:-1 extents:1 across:1048572k SS
blkfront: xvda: empty write barrier op failed
blkfront: xvda: barriers disabled
ioctl32(fgconsole:1046): Unknown cmd fd(3) cmd(00005603){t:'V';sz:0} arg(ffe8c38e) on /dev/console

--sdtB3X0nJg68CQEu--
