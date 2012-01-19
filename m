Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab2ASRsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:48:17 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:48375
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129Ab2ASRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:48:07 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0JHm3d0001343
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
In-Reply-To: <20120119153732.GB20558@arm.com> (Catalin Marinas's message of
	"Thu, 19 Jan 2012 15:37:32 +0000")
References: <gi39bcyff8.fsf@mx10.gouders.net> <20120119110121.GC9268@arm.com>
	<gi1uqvsx8n.fsf@karga.hank.lab> <20120119140058.GA19036@arm.com>
	<gik44nrc52.fsf@karga.hank.lab> <20120119153732.GB20558@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 19 Jan 2012 18:43:53 +0100
Message-ID: <gi1uqvwpt2.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 19 Jan 2012 18:48:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Thu, Jan 19, 2012 at 02:38:01PM +0000, Dirk Gouders wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Thu, Jan 19, 2012 at 12:16:56PM +0000, Dirk Gouders wrote:
>> >> Catalin Marinas <catalin.marinas@arm.com> writes:
>> >> > On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
>> >> >> Freeing unused kernel memory: 608k freed
>> >> >> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> >> >> BUG: unable to handle kernel paging request at ffffffff818b232b
>> >> >> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>> > ...
>> >> >> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>> >> >> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>> >> >
>> >> > I don't really see how kmemleak could cause such error (or any of the
>> >> > recent changes I have made). It looks like some of the code in the
>> >> > .init.text section is not executable.
>> >
>> > Ah, the interesting part - 0xcc is the poison value for freed initmem.
>> > And from the kernel logs you posted Linux frees the initmem and later
>> > calls kmemleak_late_init() which should have been in the .init.text
>> > section.
>> >
>> > The kmemleak_late_init() function is defined as:
>> >
>> > static int __init kmemleak_late_init(void)
>> > {
>> > ...
>> > }
>> > late_initcall(kmemleak_late_init);
>> >
>> > and it must *not* be called after the initmem has been freed. Was there
>> > any change in the x86 or generic code with regards to the freeing of the
>> > init memory?
>> 
>> I tried to re-bisect this problem by marking commit
>> 029aeff5db879afd7760f11214b6fea45f76b58e
>> "kmemleak: Add support for memory hotplug" (that I previously considered
>> good, because it produces a different output) bad.  The attached output
>> shows that kmemleak_late_init is also involved but bisect did not bring
>> me a step further:
>> 
>> $ git bisect good f1c84dae0e
>> Bisecting: a merge base must be tested
>> [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
>
> If you bisect to one of the kmemleak commits, they are based on 3.2-rc4
> so you miss any commits that may have been merged during the merge
> window.

Hmm, I thought that the above was an error message but when I ignored it
and just continued bisecting (whith a huge set of commits), it ended in:

b66930052abf2e41b8a978ae265303917cbe6fa0 is the first bad commit
commit b66930052abf2e41b8a978ae265303917cbe6fa0
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Wed Sep 28 17:22:56 2011 +0100

    kmemleak: When the early log buffer is exceeded, report the actual number
    
    Just telling that the early log buffer has been exceeded doesn't mean
    much. This patch moves the error printing to the kmemleak_init()
    function and displays the actual calls to the kmemleak API during early
    logging.
    
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

:040000 040000 6b16996be5be3f428eceb5ca8a153ac72f1848b3 246cccb0645241d4a1e1c392aaea3e2ea3e34da5 M      mm

>> ------------------------------------------------------------------------
>> Freeing unused kernel memory: 676k freed
>> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> BUG: unable to handle kernel paging request at ffffffff81892482
>> IP: [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
>> PGD 17cd067 PUD 17d1063 PMD 3c5c8063 PTE 8000000001892163
>> Oops: 0011 [#1] SMP 
>
> Similar behaviour, the init memory is freed before the initcalls, so
> doesn't look like a kmemleak problem.
>
> Could you pass initcall_debug on the kernel command line and see how may
> commits are called before and after the free_initmem() call?
>
> You could also try to revert (git revert) the kmemleak commits from the
> latest git tree, without bisecting.

OK, I added initcall_debug to a bad kernel I saved while bisecting and
attach the console output of the serial console - the output on the
graphical console was more complete.

Further, I tested Linus' current master with b66930052abf2 reverted 

------------------------------------------------------------------------
commit 27e8880932050e77d2822a19fb9f39230f6363e9
Author: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Date:   Thu Jan 19 18:31:40 2012 +0100

    Revert "kmemleak: When the early log buffer is exceeded, report the actual number"
    
    This reverts commit b66930052abf2e41b8a978ae265303917cbe6fa0.

commit ccb19d263fd1c9e34948e2158c53eacbff369344
Merge: 6a48897 c3b5003
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jan 17 22:26:41 2012 -0800
------------------------------------------------------------------------

and that kernel works here.

Dirk

------------------------------------------------------------------------

Linux version 3.2.0-07907-g892d208 (root@mx10) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.0, pie-0.4.7) ) #3 SMP Wed Jan 18 20:01:57 CET 2012
Command line: root=/dev/vda1 console=ttyS0,115200 console=tty0 initcall_debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
 BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
No AGP bridge found
last_pfn = 0x3fffd max_arch_pfn = 0x400000000
PAT not supported by CPU.
found SMP MP-table at [ffff8800000fd5f0] fd5f0
init_memory_mapping: 0000000000000000-000000003fffd000
ACPI: RSDP 00000000000fd460 00014 (v00 BOCHS )
ACPI: RSDT 000000003fffd740 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 000000003fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 000000003fffd9b0 02589 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
ACPI: FACS 000000003fffff40 00040
ACPI: SSDT 000000003fffd8b0 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 000000003fffd7c0 0007A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 000000003fffd780 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
No NUMA configuration found
Faking a node at 0000000000000000-000000003fffd000
Initmem setup node 0 0000000000000000-000000003fffd000
  NODE_DATA [000000003fff8000 - 000000003fffcfff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009b
    0: 0x00000100 -> 0x0003fffd
ACPI: PM-Timer IO Port: 0xb008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009b000 - 000000000009c000
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 40000000:beffc000)
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff88003fc00000 s78016 r8192 d24384 u1048576
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257923
Policy zone: DMA32
Kernel command line: root=/dev/vda1 console=ttyS0,115200 console=tty0 initcall_debug
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 1021076k/1048564k available (5490k kernel code, 468k absent, 27020k reserved, 3206k data, 612k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:512 16
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
kmemleak: Kernel memory leak detector disabled
Fast TSC calibration using PIT
Detected 2666.146 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5332.29 BogoMIPS (lpj=10664584)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
mce: CPU supports 10 MCE banks
ACPI: Core revision 20110623
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 0.15.1 stepping 03
Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
Booting Node   0, Processors  #1 Ok.
Brought up 2 CPUs
Total of 2 processors activated (10683.75 BogoMIPS).
RTC time: 16:54:13, date: 01/19/12
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 100.000000 MHz counter
Switching to clocksource hpet
FS-Cache: Loaded
CacheFiles: Loaded
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 7 devices
ACPI: ACPI bus type pnp unregistered
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
has_svm: not amd
kvm: no hardware support
initcall svm_init+0x0/0x20 returned with error code -95 
audit: initializing netlink socket (disabled)
type=2000 audit(1326992053.972:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
FS-Cache: Netfs 'nfs' registered for caching
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 1994
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
FDC 0 is a S82078B
brd: module loaded
loop: module loaded
 vda: vda1
 vdb: unknown partition table
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ide-cd driver 5.00
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:01.2: UHCI Host Controller
uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c080
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
i2c /dev entries driver
md: raid1 personality registered for level 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
Refined TSC clocksource calibration: 2665.992 MHz.
Switching to clocksource tsc
device-mapper: multipath: version 1.3.0 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath queue-length: version 0.1.0 loaded
device-mapper: multipath service-time: version 0.2.0 loaded
device-mapper: dm-log-userspace: version 1.1.0 loaded
Modular ISDN core version 1.1.21
NET: Registered protocol family 34
cpuidle: using governor ladder
cpuidle: using governor menu
oprofile: using NMI interrupt.
nf_conntrack version 0.5.0 (7977 buckets, 31908 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 10
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Registering the dns_resolver key type
initcall software_resume+0x0/0x25c returned with error code -2 
registered taskstats version 1
initcall kmemleak_late_init+0x0/0x8a returned with error code -12 
  Magic number: 12:982:944
tty ptyyf: hash matches
tty tty1: hash matches
initcall pci_mmcfg_late_insert_resources+0x0/0x54 returned with error code 1 
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (vda1): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 253:1.
Freeing unused kernel memory: 612k freed
kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffffff818b1287
IP: [<ffffffff818b1287>] kmemleak_late_init+0x8a/0x8a
PGD 17eb067 PUD 17ef063 PMD 3c602063 PTE 80000000018b1163
Oops: 0011 [#1] SMP 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper/0 Not tainted 3.2.0-07907-g892d208 #3 Bochs Bochs
RIP: 0010:[<ffffffff818b1287>]  [<ffffffff818b1287>] kmemleak_late_init+0x8a/0x8a
RSP: 0018:ffff88003e273eb8  EFLAGS: 00010286
RAX: 0000000000000001 RBX: ffff88003e01de40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88003e01de40 RDI: 0000000000000002
RBP: ffff88003e014490 R08: ffff88003fbf6f40 R09: 0000000000000006
R10: 0000000000000000 R11: dead000000200200 R12: ffffea0000f80700
R13: ffffffff810f9bec R14: ffff88003e01de40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff818b1287 CR3: 00000000017e9000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff88003e272000, task ffff88003e278000)
Stack:
 ffffffff810fe9e9 0000000000000000 0000000000000000 ffff88003e278000
 0000000000000000 0000000000000000 ffffffff810f9bec 0000000000000000
 ffffffff8104d28c ffffffff8190fe20 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff810fe9e9>] ? kmem_cache_free+0x4f/0xd9
 [<ffffffff810f9bec>] ? do_set_mempolicy+0x10b/0x11b
 [<ffffffff8104d28c>] ? free_init_pages+0xfb/0x110
 [<ffffffff810001cf>] ? init_post+0x1d/0xbb
 [<ffffffff81894b93>] ? kernel_init+0x10f/0x113
 [<ffffffff81559f54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81894a84>] ? start_kernel+0x319/0x319
 [<ffffffff81559f50>] ? gs_change+0xb/0xb
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 
RIP  [<ffffffff818b1287>] kmemleak_late_init+0x8a/0x8a
 RSP <ffff88003e273eb8>
CR2: ffffffff818b1287
---[ end trace de4fdfae9d24382c ]---
kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffffff818b1287
IP: [<ffffffff818b1287>] kmemleak_late_init+0x8a/0x8a
PGD 17eb067 PUD 17ef063 PMD 3c602063 PTE 80000000018b1163
Oops: 0011 [#2] SMP 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper/0 Tainted: G      D      3.2.0-07907-g892d208 #3 Bochs Bochs
RIP: 0010:[<ffffffff818b1287>]  [<ffffffff818b1287>] kmemleak_late_init+0x8a/0x8a
RSP: 0018:ffff88003fc03e58  EFLAGS: 00010282
RAX: 0000000000000001 RBX: ffff88003cc94dc8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88003cc94dc8 RDI: 0000000000000002
RBP: ffffea0000f32500 R08: ffff88003fc0d840 R09: ffff88003fc125a0
R10: 0000000000000400 R11: ffffffff81571d95 R12: ffff88003e005680
R13: ffffffff810aa32f R14: 0000000000000000 R15: ffff88003d47ccc0
FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff818b1287 CR3: 00000000017e9000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff88003e272000, task ffff88003e278000)
Stack:
 ffffffff810febb4 0000000000000100 ffff88003fc0dab0 ffffffff81803900
 ffff88003cc95280 ffff88003fc0dae0 ffffffff810aa32f ffffffff819929e0
 0000000a81992de0 ffff88003e272000 ffff88003e278000 ffff88003fc03eb0
Call Trace:
 <IRQ> 
 [<ffffffff810febb4>] ? kfree+0xbc/0x11e
 [<ffffffff810aa32f>] ? __rcu_process_callbacks+0x1bf/0x2e2
 [<ffffffff810aa49c>] ? rcu_process_callbacks+0x4a/0x95
 [<ffffffff8105cb6a>] ? __do_softirq+0xb6/0x171
 [<ffffffff8155a04c>] ? call_softirq+0x1c/0x30
 [<ffffffff81032d85>] ? do_softirq+0x31/0x68
 [<ffffffff8105cdcf>] ? irq_exit+0x44/0x9e
 [<ffffffff81047f39>] ? smp_apic_timer_interrupt+0x85/0x95
 [<ffffffff8155970b>] ? apic_timer_interrupt+0x6b/0x70
 <EOI> 
 [<ffffffff81330f5f>] ? tty_audit_exit+0x4d/0x80
 [<ffffffff81330f34>] ? tty_audit_exit+0x22/0x80
 [<ffffffff8105a9a9>] ? do_exit+0x729/0x72e
 [<ffffffff8105899f>] ? kmsg_dump+0x40/0xcd
 [<ffffffff81553881>] ? oops_end+0x87/0x8e
 [<ffffffff818b1287>] ? kmemleak_late_init+0x8a/0x8a
 [<ffffffff8104de25>] ? 
