Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2EGVZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:25:53 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:60357 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2EGVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:25:50 -0400
Date: Mon, 7 May 2012 17:25:36 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v3] xen-blkfront: set pages are FOREIGN_FRAME when sharing them
Message-ID: <20120507212536.GA24344@andromeda.dapyr.net>
References: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120416195258.GA14982@phenom.dumpdata.com> <alpine.DEB.2.00.1204171138020.26786@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204171138020.26786@kaball-desktop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:58:58AM +0100, Stefano Stabellini wrote:
> On Mon, 16 Apr 2012, Konrad Rzeszutek Wilk wrote:
> > On Tue, Apr 10, 2012 at 05:25:19PM +0100, Stefano Stabellini wrote:
> > > Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> > > domain. Then when blkfront un-share them, also removes the
> > > FOREIGN_FRAME_BIT from the p2m.
> > > 
> > > We do it so that when the source and the destination domain are the same
> > > (blkfront connected to blkback in the same domain) we can more easily

So I've been testing it with my mini config and it worked great. But
when I started using a distro .config it blew up. I am not really
sure why it does that, but here is the dmesg and .config.

Nothing fancy with the guest config:

cat /crash.xm  | grep -v \#
memory = 4096
name = "OL6_X86_64_PVHVM"
vcpus=12
vif = [ 'mac=00:0f:4b:00:00:72,bridge=switch' ]
disk= ['phy:/dev/guests/OL6_X86_64_PVHVM,hda,w']
vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
vnc=1
vnclisten="0.0.0.0"
hvm_loader="/usr/bin/pygrub"


This is the #testing branch, but just using my #linux-next along
with stable/for-jens-3.5 should reproduce this.

I added a bit of debug statement and found that 0xffffffffffffffff
was passed in as a PFN in the set_phys_to_machine.


Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.0-rc6bug+ (root@g-oel6.dumpdata.com) (gcc version 4.4.6 20110731 (Red Hat 4.4.6-3) (GCC) ) #2 SMP Mon May 7 16:34:26 EDT 2012
Command line: ro root=/dev/mapper/vg_goel6-lv_root rd_LVM_LV=vg_goel6/lv_root rd_LVM_LV=vg_goel6/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us  console=ttyS0,115200 debug loglevel=8 
ACPI in unprivileged domain disabled
E820_RAM 100000->100800, last OK PFN is 100000
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000100800000 (usable)
NX (Execute Disable) protection: active
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x100800 max_arch_pfn = 0x400000000
last_pfn = 0x100000 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 0477c000
Base memory trampoline at [ffff88000009b000] 9b000 size 20480
init_memory_mapping: 0000000000000000-0000000100000000
 0000000000 - 0100000000 page 4k
kernel direct mapping tables up to 100000000 @ 7fb000-1000000
xen: setting RW the range fd0000 - 1000000
init_memory_mapping: 0000000100000000-0000000100800000
 0100000000 - 0100800000 page 4k
kernel direct mapping tables up to 100800000 @ ff7f6000-100000000
xen: setting RW the range ff7fb000 - 100000000
RAMDISK: 02136000 - 0477c000
No NUMA configuration found
Faking a node at 0000000000000000-0000000100800000
Initmem setup node 0 0000000000000000-0000000100800000
  NODE_DATA [00000000fffda000 - 00000000ffffffff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100800
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x00100800
On node 0 totalpages: 1050512
  DMA zone: 56 pages used for memmap
  DMA zone: 2010 pages reserved
  DMA zone: 1918 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 1030200 pages, LIFO batch:31
  Normal zone: 28 pages used for memmap
  Normal zone: 2020 pages, LIFO batch:0
SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
SMP: Allowing 12 CPUs, 0 hotplug CPUs
No local APIC present
APIC: disable apic facility
APIC: switched to apic NOOP
nr_irqs_gsi: 16
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
PCI: Warning: Cannot find a gap in the 32bit address range
PCI: Unassigned devices with 32bit resource registers may break!
Allocating PCI resources starting at 100900000 (gap: 100900000:400000)
Booting paravirtualized kernel on Xen
Xen version: 4.1-120507 (preserve-AD)
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff8800ffe3a000 s82304 r8192 d24192 u114688
pcpu-alloc: s82304 r8192 d24192 u114688 alloc=28*4096
pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1034138
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_goel6-lv_root rd_LVM_LV=vg_goel6/lv_root rd_LVM_LV=vg_goel6/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us  console=ttyS0,115200 debug loglevel=8 
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3997660k/4202496k available (5301k kernel code, 448k absent, 204388k reserved, 3502k data, 1492k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:368 16
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
console [ttyS0] enabled
allocated 17301504 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Xen: using vcpuop timer interface
installing Xen timer for CPU 0
Detected 2294.526 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4589.05 BogoMIPS (lpj=2294526)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ftrace: allocating 21183 entries in 83 pages
cpu 0 spinlock event irq 17
Performance Events: unsupported p6 CPU model 45 no PMU driver, software events only.
NMI watchdog: disabled (cpu0): hardware events not enabled
installing Xen timer for CPU 1
cpu 1 spinlock event irq 24
SMP alternatives: switching to SMP code
NMI watchdog: disabled (cpu1): hardware events not enabled
installing Xen timer for CPU 2
cpu 2 spinlock event irq 31
NMI watchdog: disabled (cpu2): hardware events not enabled
installing Xen timer for CPU 3
cpu 3 spinlock event irq 38
NMI watchdog: disabled (cpu3): hardware events not enabled
installing Xen timer for CPU 4
cpu 4 spinlock event irq 45
NMI watchdog: disabled (cpu4): hardware events not enabled
installing Xen timer for CPU 5
cpu 5 spinlock event irq 52
NMI watchdog: disabled (cpu5): hardware events not enabled
installing Xen timer for CPU 6
cpu 6 spinlock event irq 59
NMI watchdog: disabled (cpu6): hardware events not enabled
installing Xen timer for CPU 7
cpu 7 spinlock event irq 66
NMI watchdog: disabled (cpu7): hardware events not enabled
installing Xen timer for CPU 8
cpu 8 spinlock event irq 73
NMI watchdog: disabled (cpu8): hardware events not enabled
installing Xen timer for CPU 9
cpu 9 spinlock event irq 80
NMI watchdog: disabled (cpu9): hardware events not enabled
installing Xen timer for CPU 10
cpu 10 spinlock event irq 87
NMI watchdog: disabled (cpu10): hardware events not enabled
installing Xen timer for CPU 11
cpu 11 spinlock event irq 94
NMI watchdog: disabled (cpu11): hardware events not enabled
Brought up 12 CPUs
devtmpfs: initialized
Grant tables using version 2 layout.
Grant table initialized
dummy: 
NET: Registered protocol family 16
PCI: setting up Xen PCI frontend stub
PCI: pci_cache_line_size set to 64 bytes
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
xen/balloon: Initialising balloon driver.
xen-balloon: Initialising balloon driver.
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: System does not support PCI
PCI: System does not support PCI
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource xen
pnp: PnP ACPI: disabled
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP: reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
PCI: CLS 0 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 39192k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800f7000000 - ffff8800fb000000
software IO TLB at phys 0xf7000000 - 0xfb000000
platform rtc_cmos: registered platform RTC device (no PNP device found)
audit: initializing netlink socket (disabled)
type=2000 audit(1336425310.959:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7884
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Console: switching to colour frame buffer device 100x37
intel_idle: does not run on family 6 model 45
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
mousedev: PS/2 mouse device common for all mice
input: Xen Virtual Keyboard as /devices/virtual/input/input0
input: Xen Virtual Pointer as /devices/virtual/input/input1
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of rtc_cmos failed with error -38
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
zram: num_devices not specified. Using default: 1
zram: Creating 1 devices ...
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
XENBUS: Device with no driver: device/vbd/768
XENBUS: Device with no driver: device/vif/0
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Initializing network drop monitor service
Freeing unused kernel memory: 1492k freed
dracut: dracut-004-256.0.1.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
udev: starting version 147
udevd (116): /proc/116/oom_adj is deprecated, please use /proc/116/oom_score_adj instead.
dracut: Starting plymouth daemon
blkfront: xvda: barrier or flush: disabled
 xvda: xvda1 xvda2
dracut: Scanning devices xvda2  for LVM logical volumes vg_goel6/lv_root vg_goel6/lv_swap 
dracut: inactive '/dev/vg_goel6/lv_root' [37.54 GiB] inherit
dracut: inactive '/dev/vg_goel6/lv_swap' [1.97 GiB] inherit
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery
EXT4-fs (dm-0): recovery complete
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_goel6-lv_root
dracut: Loading SELinux policy
type=1404 audit(1336425312.753:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 225597 rules.
SELinux: 2048 avtab hash slots, 225597 rules.
SELinux:  9 users, 12 roles, 3577 types, 179 bools, 1 sens, 1024 cats
SELinux:  81 classes, 225597 rules
SELinux:  Permission audit_access in class file not defined in policy.
SELinux:  Permission audit_access in class dir not defined in policy.
SELinux:  Permission execmod in class dir not defined in policy.
SELinux:  Permission audit_access in class lnk_file not defined in policy.
SELinux:  Permission open in class lnk_file not defined in policy.
SELinux:  Permission execmod in class lnk_file not defined in policy.
SELinux:  Permission audit_access in class chr_file not defined in policy.
SELinux:  Permission audit_access in class blk_file not defined in policy.
SELinux:  Permission execmod in class blk_file not defined in policy.
SELinux:  Permission audit_access in class sock_file not defined in policy.
SELinux:  Permission execmod in class sock_file not defined in policy.
SELinux:  Permission audit_access in class fifo_file not defined in policy.
SELinux:  Permission execmod in class fifo_file not defined in policy.
SELinux:  Permission syslog in class capability2 not defined in policy.
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev dm-0, type ext4), uses xattr
type=1403 audit(1336425313.280:3): policy loaded auid=4294967295 ses=4294967295
dracut: 
dracut: Switching root
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
readahead: starting
udev: starting version 147
input: PC Speaker as /devices/platform/pcspkr/input/input2
alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
Initialising Xen virtual ethernet driver.
vif vif-0: single tx ring
vif vif-0: single rx ring
vif vif-0: single event channel, irq = 105
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
EXT4-fs (dm-0): re-mounted. Opts: (null)
------------[ cut here ]------------
kernel BUG at arch/x86/xen/p2m.c:634!
invalid opcode: 0000 [#1] SMP 
CPU 0 
Modules linked in: vhost_net macvtap macvlan tun uinput xen_netfront coretemp hwmon crc32c_intel ghash_clmulni_intel aesni_intel cryptd aes_x86_64 aes_generic pcspkr ext4 mbcache jbd2 xen_blkfront dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper/0 Not tainted 3.4.0-rc6bug+ #2  
RIP: e030:[<ffffffff8100b078>]  [<ffffffff8100b078>] __set_phys_to_machine+0x108/0x120
RSP: e02b:ffff8800ffe3ddb8  EFLAGS: 00010887
RAX: 7fffffffffffffff RBX: ffffffffffffffff RCX: 00000000000001ee
RDX: 7fffffffffffffff RSI: 7fffffffffffffff RDI: ffffffffffffffff
RBP: ffff8800ffe3ddb8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 7fffffffffffffff
R13: ffff8800035be000 R14: 0000000000000019 R15: 000000000000240d
FS:  00007fc24492c7e0(0000) GS:ffff8800ffe3a000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fc243c2f358 CR3: 0000000003a55000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff817a2000, task ffffffff817b5020)
Stack:
 ffff8800ffe3ddd8 ffffffff8100b431 0000000000000000 ffff8800035bf6d8
 ffff8800ffe3de48 ffffffffa0034f04 ffff8800035ad000 ffff880003615378
 0000000000000000 0000240e00000000 ffff8800035bf660 000000000000000d
Call Trace:
 <IRQ> 
 [<ffffffff8100b431>] set_phys_to_machine+0x21/0x50
 [<ffffffffa0034f04>] blkif_interrupt+0x114/0x360 [xen_blkfront]
 [<ffffffff810d198d>] handle_irq_event_percpu+0x6d/0x220
 [<ffffffff810d1b91>] handle_irq_event+0x51/0x80
 [<ffffffff810d52b0>] handle_edge_irq+0x80/0x140
 [<ffffffff812f5b91>] __xen_evtchn_do_upcall+0x1b1/0x280
 [<ffffffff812f677f>] xen_evtchn_do_upcall+0x2f/0x50
 [<ffffffff8152a92e>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI> 
 [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
 [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
 [<ffffffff81009f10>] ? xen_safe_halt+0x10/0x20
 [<ffffffff8101d60d>] ? default_idle+0x5d/0x1b0
 [<ffffffff8101cc99>] ? cpu_idle+0xd9/0x120
 [<ffffffff815051d5>] ? rest_init+0x75/0x80
 [<ffffffff818aff22>] ? start_kernel+0x3ec/0x3f9
 [<ffffffff818af954>] ? kernel_init+0x284/0x284
 [<ffffffff818af346>] ? x86_64_start_reservations+0x131/0x136
 [<ffffffff818b335b>] ? xen_start_kernel+0x6b0/0x6b7
Code: 0f 94 c0 c3 0f 1f 80 00 00 00 00 b8 01 00 00 00 c9 c3 48 83 fe ff 74 f3 48 39 f7 74 ee 0f 0b 0f 1f 40 00 eb fa 48 83 fe ff 74 e0 <0f> 0b 66 0f 1f 44 00 00 eb f8 66 66 66 66 66 2e 0f 1f 84 00 00 
RIP  [<ffffffff8100b078>] __set_phys_to_machine+0x108/0x120
 RSP <ffff8800ffe3ddb8>
---[ end trace 595ea88467dca615 ]---
Kernel panic - not syncing: Fatal exception in interrupt
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
