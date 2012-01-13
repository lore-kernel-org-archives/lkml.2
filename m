Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2AMSIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:08:22 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47972 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2AMSIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:08:19 -0500
Date: Fri, 13 Jan 2012 09:27:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, xen-devel@lists.xensource.com
Subject: Re: Bootup regression introduced by
 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077 ("memblock: Reimplement memblock
 allocation using reverse free area iterato") in v3.3-rc0
Message-ID: <20120113142703.GA7707@phenom.dumpdata.com>
References: <20120110202838.GA10402@phenom.dumpdata.com>
 <20120110222625.GA26832@google.com>
 <20120110224537.GA6572@phenom.dumpdata.com>
 <20120110231552.GB26832@google.com>
 <20120111200435.GA8680@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111200435.GA8680@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F10730C.0007,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 03:04:35PM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 10, 2012 at 03:15:52PM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, Jan 10, 2012 at 05:45:37PM -0500, Konrad Rzeszutek Wilk wrote:
> > > (early) [    0.000000] memblock_find: [0x0, 0xfcdd000) size=8409088 align=4096 nid=1024
> > > (early) [    0.000000] memblock_find: [0x805000, 0xfcdd000) - adjusted
> > > (early) [    0.000000] memblock_find: cand [0x10567000, 0x100000000) -> (early) [0xfcdd000, 0xfcdd000) (early) - rejected
> > > (early) [    0.000000] memblock_find: cand [0x1e03000, 0x220a000) -> (early) [0x1e03000, 0x220a000) (early) - rejected
> > > (early) [    0.000000] memblock_find: cand [0x100000, 0x1000000) -> (early) [0x805000, 0x1000000) (early) - rejected
> > > (early) [    0.000000] memblock_find: cand [0x10000, 0x9b000) -> (early) [0x805000, 0x805000) (early) - rejected
> > > (early) [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables
> > 
> > So, it actually is a legitimate alloc failure.  It seems I've tried a
> > bit too hard at simplifying the allocator.  Does the following fix the
> > problem?

Any thoughts of when this fix will show up in Ingo's tree for 3.3-rc0?

Thanks!
> > 
> > Thanks.
> > 
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 2f55f19..77b5f22 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -106,14 +106,17 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
> >  	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
> >  		end = memblock.current_limit;
> >  
> > -	/* adjust @start to avoid underflow and allocating the first page */
> > -	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
> > +	/* avoid allocating the first page */
> > +	start = max_t(phys_addr_t, start, PAGE_SIZE);
> >  	end = max(start, end);
> >  
> >  	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
> >  		this_start = clamp(this_start, start, end);
> >  		this_end = clamp(this_end, start, end);
> >  
> > +		if (this_end < size)
> > +			continue;
> > +
> >  		cand = round_down(this_end - size, align);
> >  		if (cand >= this_start)
> >  			return cand;
> 
> With that patch it boots!
> 
> 
> (early) [    0.000000] Initializing cgroup subsys cpuset
> (early) [    0.000000] Initializing cgroup subsys cpu
> (early) [    0.000000] Linux version 3.2.0-05693-g2c81411 (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Wed Jan 11 13:19:30 EST 2012
> (early) [    0.000000] Command line: console=hvc0 debug earlyprintk=xen
> (early) [    0.000000] ACPI in unprivileged domain disabled
> (early) [    0.000000] Released 0 pages of unused memory
> (early) [    0.000000] Set 0 page(s) to 1-1 mapping
> (early) [    0.000000] BIOS-provided physical RAM map:
> (early) [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
> (early) [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
> (early) [    0.000000]  Xen: 0000000000100000 - 0000000200800000 (usable)
> (early) [    0.000000] bootconsole [xenboot0] enabled
> (early) [    0.000000] NX (Execute Disable) protection: active
> (early) [    0.000000] DMI not present or invalid.
> (early) [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early) 
> (early) [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early) 
> (early) [    0.000000] No AGP bridge found
> (early) [    0.000000] last_pfn = 0x200800 max_arch_pfn = 0x400000000
> (early) [    0.000000] last_pfn = 0x100000 max_arch_pfn = 0x400000000
> (early) [    0.000000] initial memory mapped : 0 - 10006000
> (early) [    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
> (early) [    0.000000] init_memory_mapping: 0000000000000000-0000000100000000
> (early) [    0.000000]  0000000000 - 0100000000 page 4k
> (early) [    0.000000] kernel direct mapping tables up to 100000000 @ 7fb000-1000000
> (early) [    0.000000] xen: setting RW the range f74000 - 1000000
> (early) [    0.000000] init_memory_mapping: 0000000100000000-0000000200800000
> (early) [    0.000000]  0100000000 - 0200800000 page 4k
> (early) [    0.000000] kernel direct mapping tables up to 200800000 @ feff2000-100000000
> (early) [    0.000000] xen: setting RW the range ff7fb000 - 100000000
> (early) [    0.000000] RAMDISK: 02249000 - 10006000
> (early) [    0.000000] No NUMA configuration found
> (early) [    0.000000] Faking a node at 0000000000000000-0000000200800000
> (early) [    0.000000] Initmem setup node 0 0000000000000000-0000000200800000
> (early) [    0.000000]   NODE_DATA [00000000fffd9000 - 00000000ffffffff]
> (early) [    0.000000] Zone PFN ranges:
> (early) [    0.000000]   DMA      (early) 0x00000010 -> 0x00001000
> (early) [    0.000000]   DMA32    (early) 0x00001000 -> 0x00100000
> (early) [    0.000000]   Normal   (early) 0x00100000 -> 0x00200800
> (early) [    0.000000] Movable zone start PFN for each node
> (early) [    0.000000] Early memory PFN ranges
> (early) [    0.000000]     0: 0x00000010 -> 0x000000a0
> (early) [    0.000000]     0: 0x00000100 -> 0x00200800
> (early) [    0.000000] On node 0 totalpages: 2099088
> (early) [    0.000000]   DMA zone: 64 pages used for memmap
> (early) [    0.000000]   DMA zone: 1918 pages reserved
> (early) [    0.000000]   DMA zone: 2002 pages, LIFO batch:0
> (early) [    0.000000]   DMA32 zone: 16320 pages used for memmap
> (early) [    0.000000]   DMA32 zone: 1028160 pages, LIFO batch:31
> (early) [    0.000000]   Normal zone: 16416 pages used for memmap
> (early) [    0.000000]   Normal zone: 1034208 pages, LIFO batch:31
> (early) [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> (early) [    0.000000] No local APIC present
> (early) [    0.000000] APIC: disable apic facility
> (early) [    0.000000] APIC: switched to apic NOOP
> (early) [    0.000000] nr_irqs_gsi: 16
> (early) [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
> (early) [    0.000000] PCI: Warning: Cannot find a gap in the 32bit address range
> (early) [    0.000000] PCI: Unassigned devices with 32bit resource registers may break!
> (early) [    0.000000] Allocating PCI resources starting at 200900000 (gap: 200900000:400000)
> (early) [    0.000000] Booting paravirtualized kernel on Xen
> (early) [    0.000000] Xen version: 4.1-120111 (preserve-AD)
> (early) [    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
> (early) [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800fff31000 s82752 r8192 d23744 u114688
> (early) [    0.000000] pcpu-alloc: s82752 r8192 d23744 u114688 alloc=28*4096(early) 
> (early) [    0.000000] pcpu-alloc: (early) [0] (early) 0 (early) [0] (early) 1 (early) [0] (early) 2 (early) [0] (early) 3 (early) 
> (early) [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064370
> (early) [    0.000000] Policy zone: Normal
> (early) [    0.000000] Kernel command line: console=hvc0 debug earlyprintk=xen
> (early) [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> (early) [    0.000000] Checking aperture...
> (early) [    0.000000] No AGP bridge found
> (early) [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> (early) [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> (early) [    0.000000] Memory: 3727344k/8396800k available (6482k kernel code, 448k absent, 4669008k reserved, 4624k data, 1256k init)
> (early) [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> (early) [    0.000000] Preemptible hierarchical RCU implementation.
> (early) [    0.000000] NR_IRQS:262400 nr_irqs:304 16
> (early) [    0.000000] kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
> (early) [    0.000000] kmemleak: Kernel memory leak detector disabled
> (early) [    0.000000] Console: colour dummy device 80x25
> (early) [    0.000000] console [tty0] enabled
> [    0.000000] console [hvc0] enabled, bootconsole disabled
> (early) [    0.000000] console [hvc0] enabled, bootconsole disabled
> [    0.000000] Xen: using vcpuop timer interface
> [    0.000000] installing Xen timer for CPU 0
> [    0.000000] Detected 3292.616 MHz processor.
> [    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6585.23 BogoMIPS (lpj=3292616)
> [    0.000999] pid_max: default: 32768 minimum: 301
> [    0.000999] Security Framework initialized
> [    0.000999] SELinux:  Initializing.
> [    0.000999] SELinux:  Starting in permissive mode
> [    0.002170] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.004675] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.005213] Mount-cache hash table entries: 256
> [    0.005428] Initializing cgroup subsys cpuacct
> [    0.005436] Initializing cgroup subsys freezer
> [    0.005497] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.005498] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.005510] CPU: Physical Processor ID: 0
> [    0.005515] CPU: Processor Core ID: 0
> [    0.005576] SMP alternatives: switching to UP code
> [    0.005999] ftrace: allocating 23453 entries in 92 pages
> [    0.006057] cpu 0 spinlock event irq 17
> [    0.006112] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
> [    0.012038] NMI watchdog disabled (cpu0): hardware events not enabled
> [    0.018010] installing Xen timer for CPU 1
> [    0.018028] cpu 1 spinlock event irq 23
> [    0.018051] SMP alternatives: switching to SMP code
> [    0.019085] NMI watchdog disabled (cpu1): hardware events not enabled
> [    0.025009] installing Xen timer for CPU 2
> [    0.025027] cpu 2 spinlock event irq 29
> [    0.025121] NMI watchdog disabled (cpu2): hardware events not enabled
> [    0.031008] installing Xen timer for CPU 3
> [    0.031024] cpu 3 spinlock event irq 35
> [    0.031118] NMI watchdog disabled (cpu3): hardware events not enabled
> [    0.033006] Brought up 4 CPUs
> [    0.033666] kworker/u:0 used greatest stack depth: 5272 bytes left
> [    0.033666] Grant tables using version 2 layout.
> [    0.033666] Grant table initialized
> [    0.052849] RTC time: 165:165:165, date: 165/165/65
> [    0.053033] NET: Registered protocol family 16
> [    0.054556] PCI: setting up Xen PCI frontend stub
> [    0.054565] PCI: pci_cache_line_size set to 64 bytes
> [    0.065198] bio: create slab <bio-0> at 0
> [    0.065198] ACPI: Interpreter disabled.
> [    0.066004] xen/balloon: Initialising balloon driver.
> [    0.076187] xen-balloon: Initialising balloon driver.
> [    0.076187] vgaarb: loaded
> [    0.077064] usbcore: registered new interface driver usbfs
> [    0.077067] usbcore: registered new interface driver hub
> [    0.077107] usbcore: registered new device driver usb
> [    0.077107] PCI: System does not support PCI
> [    0.077107] PCI: System does not support PCI
> [    0.078054] NetLabel: Initializing
> [    0.078054] NetLabel:  domain hash size = 128
> [    0.078054] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.078054] NetLabel:  unlabeled traffic allowed by default
> [    0.078109] Switching to clocksource xen
> [    0.083574] pnp: PnP ACPI: disabled
> [    0.089832] PCI: max bus depth: 0 pci_try_num: 1
> [    0.089877] NET: Registered protocol family 2
> [    0.090665] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.093957] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.095324] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.095466] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.095474] TCP reno registered
> [    0.095526] UDP hash table entries: 4096 (order: 5, 131072 bytes)
> [    0.095597] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
> [    0.095720] NET: Registered protocol family 1
> [    0.095957] RPC: Registered named UNIX socket transport module.
> [    0.095965] RPC: Registered udp transport module.
> [    0.095970] RPC: Registered tcp transport module.
> [    0.095976] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.095984] PCI: CLS 0 bytes, default 64
> [    0.096219] Trying to unpack rootfs image as initramfs...
> [    0.431565] Freeing initrd memory: 227060k freed
> [    0.475737] DMA-API: preallocated 32768 debug entries
> [    0.475961] DMA-API: debugging enabled by kernel config
> [    0.475969] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.475977] Placing 64MB software IO TLB between ffff8800f2800000 - ffff8800f6800000
> [    0.475984] software IO TLB at phys 0xf2800000 - 0xf6800000
> [    0.476324] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    0.476472] Machine check injector initialized
> [    0.477452] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x17
> [    0.477466] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x17
> [    0.477486] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x17
> [    0.477503] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x17
> [    0.477586] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.478032] audit: initializing netlink socket (disabled)
> [    0.478053] type=2000 audit(1326338469.110:1): initialized
> [    0.494006] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.499995] VFS: Disk quotas dquot_6.5.2
> [    0.500208] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.501045] NTFS driver 2.1.30 [Flags: R/W].
> [    0.501365] msgmni has been set to 7723
> [    0.501583] SELinux:  Registering netfilter hooks
> [    0.502294] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.502303] io scheduler noop registered
> [    0.502309] io scheduler deadline registered
> [    0.502405] io scheduler cfq registered (default)
> [    0.502633] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.542586] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.573641] Non-volatile memory driver v1.3
> [    0.573649] Linux agpgart interface v0.103
> [    0.574083] [drm] Initialized drm 1.1.0 20060810
> [    0.577049] brd: module loaded
> [    0.578684] loop: module loaded
> [    0.579544] Fixed MDIO Bus: probed
> [    0.579551] tun: Universal TUN/TAP device driver, 1.6
> [    0.579556] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.580300] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.580308] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
> [    0.580386] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.580392] ohci_hcd: block sizes: ed 80 td 96
> [    0.580466] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.580701] usbcore: registered new interface driver usblp
> [    0.580780] usbcore: registered new interface driver libusual
> [    0.581039] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    0.581865] i8042: No controller found
> [    0.581951] mousedev: PS/2 mouse device common for all mice
> [    0.622367] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    0.622469] rtc_cmos: probe of rtc_cmos failed with error -38
> [    0.622730] EFI Variables Facility v0.08 2004-May-17
> [    0.622805] zram: num_devices not specified. Using default: 1
> [    0.622812] zram: Creating 1 devices ...
> [    0.623448] Netfilter messages via NETLINK v0.30.
> [    0.623467] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    0.623780] ctnetlink v0.93: registering with nfnetlink.
> [    0.625065] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    0.625099] TCP cubic registered
> [    0.625105] Initializing XFRM netlink socket
> [    0.625468] NET: Registered protocol family 10
> [    0.627394] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    0.627485] IPv6 over IPv4 tunneling driver
> [    0.629062] NET: Registered protocol family 17
> [    0.629097] Registering the dns_resolver key type
> [    0.629362] PM: Hibernation image not present or could not be loaded.
> [    0.629386] registered taskstats version 1
> [    0.629448] XENBUS: Device with no driver: device/vif/0
> [    0.629454] XENBUS: Device with no driver: device/vfb/0
> [    0.629460] XENBUS: Device with no driver: device/vkbd/0
> [    0.629475]   Magic number: 1:252:3141
> [    0.630415] Freeing unused kernel memory: 1256k freed
> [    0.630622] Write protecting the kernel read-only data: 10240k
> [    0.636139] Freeing unused kernel memory: 1688k freed
> [    0.636508] Freeing unused kernel memory: 112k freed
> init started: BusyBox v1.14.3 (2012-01-11 13:22:11 EST)
> [    0.641820] consoletype used greatest stack depth: 5232 bytes left
> Mounting directories  [  OK  ]
> [    0.860513] modprobe used greatest stack depth: 5008 bytes left
> mount: mount point /sys/kernel/config does not exist
> [    0.865846] core_filesystem used greatest stack depth: 4880 bytes left
> [    0.874814] input: Xen Virtual Keyboard as /devices/virtual/input/input0
> [    0.875019] input: Xen Virtual Pointer as /devices/virtual/input/input1
> [    1.086237] Initialising Xen virtual ethernet driver.
> [    1.201417] udevd (1186): /proc/1186/oom_adj is deprecated, please use /proc/1186/oom_score_adj instead.
> udevd-work[1202]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory
> 
> [    1.307448] ip used greatest stack depth: 3696 bytes left
> Waiting for devices [  OK  ]
> Waiting for fb [  OK  ]
> Starting..[/dev/fb0]
> /dev/fb0: len:0
> /dev/fb0: bits/pixel32
> (7fa51499a000): Writting .. [800:600]
> Done!
> FATAL: Module agpgart_intel not found.
> [    1.464693] Console: switching to colour frame buffer device 100x37
> [    1.478942] [drm] radeon kernel modesetting enabled.
> WARNING: Error inserting video (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/acpi/video.ko): No such device
> WARNING: Error inserting mxm_wmi (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/platform/x86/mxm-wmi.ko): No such device
> WARNING: Error inserting drm_kms_helper (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
> WARNING: Error inserting ttm (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/gpu/drm/ttm/ttm.ko): No such device
> FATAL: Error inserting nouveau (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/gpu/drm/nouveau/nouveau.ko): No such device
> WARNING: Error inserting drm_kms_helper (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
> FATAL: Error inserting i915 (/lib/modules/3.2.0-05693-g2c81411/kernel/drivers/gpu/drm/i915/i915.ko): No such device
> Starting..[/dev/fb0]
> /dev/fb0: len:0
> /dev/fb0: bits/pixel32
> (7fc2635c3000): Writting .. [800:600]
> Done!
> VGA: 0000:
> Waiting for network [  OK  ]
> Bringing up loopback interface:  [  OK  ]
> Bringing up interface eth0:  [    1.743980] device eth0 entered promiscuous mode
> [  OK  ]
> Bringing up interface switch:  
> Determining IP information for switch...[    1.790208] switch: port 1(eth0) entering forwarding state
> [    1.790244] switch: port 1(eth0) entering forwarding state
> [    1.790880] ip used greatest stack depth: 3376 bytes left
>  done.
> [  OK  ]
> Waiting for init.custom [  OK  ]
> 
> Starting SSHd ...
> 
>     SSH started [2314]
> 
> 
> Waiting for SSHd [  OK  ]
> WARNING: ssh currently running [2314] ignoring start request
> FATAL: Module dump_dma not found.
> ERROR: Module dump_dma does not exist in /proc/modules
> [    3.562254] SCSI subsystem initialized
> [    3.563911] Loading iSCSI transport class v2.0-870.
> [    3.566452] iscsi: registered transport (tcp)
> iscsistart: transport class version 2.0-870. iscsid version 2.0-872
> Could not get list of targets from firmware.
> Jan 12 03:21:12 g-pvops syslogd 1.5.0: restart.
> FATAL: Module evtchn not found.
> [    3.595640] Event-channel device installed.
> xencommons should be started first.
>            CPU0       CPU1       CPU2       CPU3       
>  16:       1330          0          0          0  xen-percpu-virq      timer0
>  17:          6          0          0          0  xen-percpu-ipi       spinlock0
>  18:       1872          0          0          0  xen-percpu-ipi       resched0
>  19:        129          0          0          0  xen-percpu-ipi       callfunc0
>  20:          0          0          0          0  xen-percpu-virq      debug0
>  21:         77          0          0          0  xen-percpu-ipi       callfuncsingle0
>  22:          0       1811          0          0  xen-percpu-virq      timer1
>  23:          0         14          0          0  xen-percpu-ipi       spinlock1
>  24:          0       2411          0          0  xen-percpu-ipi       resched1
>  25:          0        140          0          0  xen-percpu-ipi       callfunc1
>  26:          0          0          0          0  xen-percpu-virq      debug1
>  27:          0         78          0          0  xen-percpu-ipi       callfuncsingle1
>  28:          0          0       1204          0  xen-percpu-virq      timer2
>  29:          0          0          5          0  xen-percpu-ipi       spinlock2
>  30:          0          0       3713          0  xen-percpu-ipi       resched2
>  31:          0          0        148          0  xen-percpu-ipi       callfunc2
>  32:          0          0          0          0  xen-percpu-virq      debug2
>  33:          0          0        103          0  xen-percpu-ipi       callfuncsingle2
>  34:          0          0          0       1373  xen-percpu-virq      timer3
>  35:          0          0          0          5  xen-percpu-ipi       spinlock3
>  36:          0          0          0       2474  xen-percpu-ipi       resched3
>  37:          0          0          0        131  xen-percpu-ipi       callfunc3
>  38:          0          0          0          0  xen-percpu-virq      debug3
>  39:          0          0          0         88  xen-percpu-ipi       callfuncsingle3
>  40:        423          0          0          0   xen-dyn-event     xenbus
>  41:         81          0          0          0   xen-dyn-event     hvc_console
>  42:          0          0          0          0   xen-dyn-event     vkbd
>  43:         70          0          0          0   xen-dyn-event     vfb
>  44:         20          0          0          0   xen-dyn-event     eth0
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:          0          0          0          0   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          0          0          0          0   Performance monitoring interrupts
> IWI:          0          0          0          0   IRQ work interrupts
> RTR:          0          0          0          0   APIC ICR read retries
> RES:       1872       2411       3713       2474   Rescheduling interrupts
> CAL:        206        218        251        219   Function call interrupts
> TLB:          0          0          0          0   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          0          0          0          0   Machine check polls
> ERR:          0
> MIS:          0
> 00000000-0000ffff : reserved
> 00010000-0009ffff : System RAM
> 000a0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-2007fffff : System RAM
>   01000000-016549db : Kernel code
>   016549dc-01ad89ff : Kernel data
>   01c1a000-01e2afff : Kernel bss
> Waiting for init.late [  OK  ]
> PING build.dumpdata.com (192.168.101.3) 56(84) bytes of data.
> 
> --- build.dumpdata.com ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.329/0.329/0.329/0.000 ms
> NFS done
>  [0x0->0x100000] pfn
>  [0x0->0x100000] level entry
>  [0x100000->0x7cfffff] missing
>  [0x100000->0x7cfffff] level top
> libxl: error: libxl.c:56:libxl_ctx_init Is xenstore daemon running?
> failed to stat /var/run/xenstored.pid: No such file or directory
> cannot init xl context
> [    4.481012] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    4.482152] device-mapper: multipath: version 1.3.0 loaded
> 192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
> 192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
> 192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
> 192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
> 192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
> 192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
> Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]
> Jan 12 03:21:13 g-pvops iscsid: transport class version 2.0-870. iscsid version 2.0-872
> Jan 12 03:21:13 g-pvops iscsid: iSCSI daemon with pid=2387 started!
> [    4.747529] scsi0 : iSCSI Initiator over TCP/IP
> [    4.751948]  connection1:0: detected conn error (1020)
> iscsiadm: Could not login to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260].
> iscsiadm: initiator reported error (19 - encountered non-retryable iSCSI login failure)
> Jan 12 03:21:14 g-pvops iscsid: conn 0 login rejected: initiator failed authorization with target
> Jan 12 03:21:14 g-pvops iscsid: Connection1:0 to [target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260] through [iface: default] is shutdown.
> 
> poweroff
>   No matching physical volumes found
>   No volume groups found
> Jan 12 03:21:18 g-pvops init: starting pid 2466, tty '/dev/tty2': '/bin/sh'
> Jan 12 03:21:18 g-pvops init: starting pid 2469, tty '/dev/tty1': '/bin/sh'
> Jan 12 03:21:18 g-pvops init: starting pid 2470, tty '/dev/ttyS0': '/bin/sh'
> Jan 12 03:21:18 g-pvops init: starting pid 2471, tty '/dev/hvc0': '/bin/sh'
> 
>    ~~~~~~~~~~~~~~~~~~~~~~~~~~| DirectFB 1.4.9 |~~~~~~~~~~~~~~~~~~~~~~~~~~
>         (c) 2001-2010  The world wide DirectFB Open Source Community
>         (c) 2000-2004  Convergence (integrated media) GmbH
>       ----------------------------------------------------------------
> 
> (*) DirectFB/Core: Single Application Core. (2012-01-11 18:23) 
> sh-4.1# 
> sh-4.1# poweroff
> (*) Direct/Memcpy: Using Generic 64bit memcpy()
> Jan 12 03:21:18 g-pvops init: starting pid 2477, tty '': '/etc/init.d/halt'
> sh-4.1# Usage: /etc/init.d/halt {start}
> The system is going down NOW!
> Sent SIGTERM to all processes
> (!) [ 2465:    0.000] --> Caught signal 15 (sent by pid 1, uid 0) <--
> (!) [ 2465:    0.000] --> Caught signal 11 (at 0x38, invalid address) <--
> Sent SIGKILL to all processes
> Requesting system poweroff
> [   12.086915] System halted.
> Parsing config file /mnt/lab/tst018/pv.xm
> Daemon running with PID 3972
