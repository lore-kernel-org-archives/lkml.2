Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab1GYQMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:12:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35300 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1GYQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:12:50 -0400
Date: Mon, 25 Jul 2011 12:10:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: luto@MIT.EDU, jj@chaosbits.net, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@infradead.org,
        JBeulich@novell.com, richard.weinberger@gmail.com, mikpe@it.uu.se,
        andi@firstfloor.org, brgerst@gmail.com, Louis.Rilling@kerlabs.com,
        Valdis.Kletnieks@vt.edu, pageexec@freemail.hu, mingo@elte.hu
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64:
 Give vvars their own page) breaks Xen PV guests (64-bit).
Message-ID: <20110725161009.GA9193@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725155442.GA21759@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E2D9570.0027:SCFMA922111,ss=1,re=-6.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:54:42AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Andy,
> 
> I just started testing linus/master and found out that I get this bootup error:
> 
> mapping kernel into physical memory
> about to get started...
> (XEN) mm.c:940:d10 Error getting mfn 1888 (pfn 1e3e48) from L1 entry 8000000001888465 for l1e_owner=10, pg_owner=10
> (XEN) mm.c:5049:d10 ptwr_emulate: could not get_page_from_l1e()
> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.000000] IP: [<ffffffff8103a930>] xen_set_pte+0x20/0xe0
> [    0.000000] PGD 0 
> [    0.000000] Oops: 0003 [#1] PREEMPT SMP 
> [    0.000000] CPU 0 
> [    0.000000] Modules linked in:
> [    0.000000] 
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.0.0-rc1-00169-gae7bd11 #1  
> [    0.000000] RIP: e030:[<ffffffff8103a930>]  [<ffffffff8103a930>] xen_set_pte+0x20/0xe0
> [    0.000000] RSP: e02b:ffffffff81801df8  EFLAGS: 00010097
> [    0.000000] RAX: 0000000000000000 RBX: ffff88000193dff8 RCX: ffffffffff5ff000
> [    0.000000] RDX: 0000000010000001 RSI: 8000000001888465 RDI: ffff88000193dff8
> [    0.000000] RBP: ffffffff81801e18 R08: 0000000000000000 R09: 0000000000007ff0
> [    0.000000] R10: aaaaaaaaaaaaaaaa R11: aaaaaaaaaaaaaaaa R12: 8000000001888465
> [    0.000000] R13: 000000000e573000 R14: 0000000080000000 R15: 0000000000000000
> [    0.000000] FS:  0000000000000000(0000) GS:ffffffff81889000(0000) knlGS:0000000000000000
> [    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.000000] CR2: 0000000000000000 CR3: 0000000001803000 CR4: 0000000000000660
> [    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.000000] Process swapper (pid: 0, threadinfo ffffffff81800000, task ffffffff8180b020)
> [    0.000000] Stack:
> [    0.000000]  ffffffffff5ff000 8000000001888465 ffffffffff5ff000 8000000001888465
> [    0.000000]  ffffffff81801e38 ffffffff8106db53 0000000000000800 8000000001888465
> [    0.000000]  ffffffff81801e48 ffffffff8106dbc0 ffffffff81801e58 ffffffff810720f6
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8106db53>] set_pte_vaddr_pud+0x43/0x60
> [    0.000000]  [<ffffffff8106dbc0>] set_pte_vaddr+0x50/0x70

This tiny patch fixes the bootup:

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f987bde..0e4c13c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+	case VVAR_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:

However, this is what I get later on, any ideas?


(early) [    0.000000] Initializing cgroup subsys cpuset
(early) [    0.000000] Initializing cgroup subsys cpu
(early) [    0.000000] Linux version 3.0.0-03370-gb6844e8-dirty (konrad@phenom) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Mon Jul 25 12:01:00 EDT 2011
(early) [    0.000000] Command line: console=hvc0 debug     earlyprintk=xenboot
(early) [    0.000000] ACPI in unprivileged domain disabled
(early) [    0.000000] released 0 pages of unused memory
(early) [    0.000000] Set 0 page(s) to 1-1 mapping.
(early) [    0.000000] BIOS-provided physical RAM map:
(early) [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
(early) [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
(early) [    0.000000]  Xen: 0000000000100000 - 0000000080800000 (usable)
(early) [    0.000000] bootconsole [xenboot0] enabled
(early) [    0.000000] NX (Execute Disable) protection: active
(early) [    0.000000] DMI not present or invalid.
(early) [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early) 
(early) [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early) 
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] last_pfn = 0x80800 max_arch_pfn = 0x400000000
(early) [    0.000000] initial memory mapped : 0 - 102ea000
(early) [    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
(early) [    0.000000] init_memory_mapping: 0000000000000000-0000000080800000
(early) [    0.000000]  0000000000 - 0080800000 page 4k
(early) [    0.000000] kernel direct mapping tables up to 80800000 @ 7fbf8000-80000000
(early) [    0.000000] xen: setting RW the range 7ff76000 - 80000000
(early) [    0.000000] RAMDISK: 01b76000 - 102ea000
(early) [    0.000000] No NUMA configuration found
(early) [    0.000000] Faking a node at 0000000000000000-0000000080800000
(early) [    0.000000] Initmem setup node 0 0000000000000000-0000000080800000
(early) [    0.000000]   NODE_DATA [000000007fffb000 - 000000007fffffff]
(early) [    0.000000] Zone PFN ranges:
(early) [    0.000000]   DMA      (early) 0x00000010 -> 0x00001000
(early) [    0.000000]   DMA32    (early) 0x00001000 -> 0x00100000
(early) [    0.000000]   Normal   (early) empty
(early) [    0.000000] Movable zone start PFN for each node
(early) [    0.000000] early_node_map[2] active PFN ranges
(early) [    0.000000]     0: 0x00000010 -> 0x000000a0
(early) [    0.000000]     0: 0x00000100 -> 0x00080800
(early) [    0.000000] On node 0 totalpages: 526224
(early) [    0.000000]   DMA zone: 56 pages used for memmap
(early) [    0.000000]   DMA zone: 5 pages reserved
(early) [    0.000000]   DMA zone: 3923 pages, LIFO batch:0
(early) [    0.000000]   DMA32 zone: 7140 pages used for memmap
(early) [    0.000000]   DMA32 zone: 515100 pages, LIFO batch:31
(early) [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
(early) [    0.000000] No local APIC present
(early) [    0.000000] APIC: disable apic facility
(early) [    0.000000] APIC: switched to apic NOOP
(early) [    0.000000] nr_irqs_gsi: 16
(early) [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
(early) [    0.000000] Allocating PCI resources starting at 80800000 (gap: 80800000:7f800000)
(early) [    0.000000] Booting paravirtualized kernel on Xen
(early) [    0.000000] Xen version: 4.2-unstable (preserve-AD)
(early) [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
(early) [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007fb88000 s81984 r8192 d24512 u114688
(early) [    0.000000] pcpu-alloc: s81984 r8192 d24512 u114688 alloc=28*4096(early) 
(early) [    0.000000] pcpu-alloc: (early) [0] (early) 0 (early) [0] (early) 1 (early) [0] (early) 2 (early) [0] (early) 3 (early) 
(early) [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 519023
(early) [    0.000000] Policy zone: DMA32
(early) [    0.000000] Kernel command line: console=hvc0 debug     earlyprintk=xenboot
(early) [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
(early) [    0.000000] Checking aperture...
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
(early) [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
(early) [    0.000000] Memory: 1809780k/2105344k available (5937k kernel code, 448k absent, 295116k reserved, 2812k data, 692k init)
(early) [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
(early) [    0.000000] Preemptible hierarchical RCU implementation.
(early) [    0.000000] NR_IRQS:16640 nr_irqs:304 16
(early) [    0.000000] Console: colour dummy device 80x25
(early) [    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
(early) [    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 3000.206 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.41 BogoMIPS (lpj=3000206)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001401] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001684] Mount-cache hash table entries: 256
[    0.001854] Initializing cgroup subsys cpuacct
[    0.001865] Initializing cgroup subsys freezer
[    0.001907] tseg: 0000000000
[    0.001919] CPU: Physical Processor ID: 0
[    0.001924] CPU: Processor Core ID: 1
[    0.001978] SMP alternatives: switching to UP code
[    0.002100] cpu 0 spinlock event irq 17
[    0.002156] Performance Events: 
[    0.002162] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.002168] no hardware sampling interrupt available.
[    0.002192] Broken PMU hardware detected, using software events only.
[    0.008054] MCE: In-kernel MCE decoding enabled.
[    0.008079] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.014023] installing Xen timer for CPU 1
[    0.014061] cpu 1 spinlock event irq 23
[    0.014135] SMP alternatives: switching to SMP code
[    0.015693] NMI watchdog disabled (cpu1): hardware events not enabled
[    0.021060] installing Xen timer for CPU 2
[    0.021128] cpu 2 spinlock event irq 29
[    0.021434] NMI watchdog disabled (cpu2): hardware events not enabled
[    0.027063] installing Xen timer for CPU 3
[    0.027108] cpu 3 spinlock event irq 35
[    0.027359] NMI watchdog disabled (cpu3): hardware events not enabled
[    0.029054] Brought up 4 CPUs
[    0.029163] kworker/u:0 used greatest stack depth: 5512 bytes left
[    0.029177] Grant table initialized
[    0.048829] RTC time: 165:165:165, date: 165/165/65
[    0.048893] NET: Registered protocol family 16
[    0.049057] Extended Config Space enabled on 0 nodes
[    0.050337] PCI: setting up Xen PCI frontend stub
[    0.050344] PCI: pci_cache_line_size set to 64 bytes
[    0.059043] bio: create slab <bio-0> at 0
[    0.060045] ACPI: Interpreter disabled.
[    0.060045] xen/balloon: Initialising balloon driver.
[    0.060045] last_pfn = 0x80800 max_arch_pfn = 0x400000000
[    0.063052] xen-balloon: Initialising balloon driver.
[    0.063079] vgaarb: loaded
[    0.064036] usbcore: registered new interface driver usbfs
[    0.064062] usbcore: registered new interface driver hub
[    0.064062] usbcore: registered new device driver usb
[    0.064062] PCI: System does not support PCI
[    0.064062] PCI: System does not support PCI
[    0.064062] NetLabel: Initializing
[    0.064062] NetLabel:  domain hash size = 128
[    0.064062] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.064062] NetLabel:  unlabeled traffic allowed by default
[    0.065036] Switching to clocksource xen
[    0.065243] Switched to NOHz mode on CPU #2
[    0.065423] Switched to NOHz mode on CPU #3
[    0.065942] Switched to NOHz mode on CPU #0
[    0.065993] Switched to NOHz mode on CPU #1
[    0.067462] pnp: PnP ACPI: disabled
[    0.072379] PCI: max bus depth: 0 pci_try_num: 1
[    0.072421] NET: Registered protocol family 2
[    0.072609] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.073921] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.075229] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.075493] TCP: Hash tables configured (established 262144 bind 65536)
[    0.075506] TCP reno registered
[    0.075526] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.075550] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.075642] NET: Registered protocol family 1
[    0.075869] RPC: Registered named UNIX socket transport module.
[    0.075877] RPC: Registered udp transport module.
[    0.075882] RPC: Registered tcp transport module.
[    0.075887] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.075895] PCI: CLS 0 bytes, default 64
[    0.076004] Trying to unpack rootfs image as initramfs...
[    0.328726] Freeing initrd memory: 237008k freed
[    0.390049] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.391356] Machine check injector initialized
[    0.392159] microcode: CPU0: patch_level=0x010000bf
[    0.392193] microcode: CPU1: patch_level=0x010000bf
[    0.392278] microcode: CPU2: patch_level=0x010000bf
[    0.392373] microcode: CPU3: patch_level=0x010000bf
[    0.392489] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.392997] audit: initializing netlink socket (disabled)
[    0.393027] type=2000 audit(1311610075.824:1): initialized
[    0.407315] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.412966] VFS: Disk quotas dquot_6.5.2
[    0.413113] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.413840] NTFS driver 2.1.30 [Flags: R/W].
[    0.414131] msgmni has been set to 3997
[    0.414372] SELinux:  Registering netfilter hooks
[    0.415310] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.415327] io scheduler noop registered
[    0.415332] io scheduler deadline registered
[    0.415434] io scheduler cfq registered (default)
[    0.415794] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.464230] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.526788] Non-volatile memory driver v1.3
[    0.526798] Linux agpgart interface v0.103
[    0.527367] [drm] Initialized drm 1.1.0 20060810
[    0.530271] brd: module loaded
[    0.531723] loop: module loaded
[    0.532369] Fixed MDIO Bus: probed
[    0.532902] tun: Universal TUN/TAP device driver, 1.6
[    0.532913] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.533296] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.533305] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    0.533436] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.533448] ohci_hcd: block sizes: ed 80 td 96
[    0.533574] uhci_hcd: USB Universal Host Controller Interface driver
[    0.533768] usbcore: registered new interface driver usblp
[    0.533851] usbcore: registered new interface driver libusual
[    0.534155] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.534978] i8042: No controller found
[    0.535254] mousedev: PS/2 mouse device common for all mice
[    0.575759] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.575892] rtc_cmos: probe of rtc_cmos failed with error -38
[    0.576261] cpuidle: using governor ladder
[    0.576279] cpuidle: using governor menu
[    0.576284] EFI Variables Facility v0.08 2004-May-17
[    0.576395] zram: num_devices not specified. Using default: 1
[    0.576403] zram: Creating 1 devices ...
[    0.576806] Netfilter messages via NETLINK v0.30.
[    0.576828] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.577133] ctnetlink v0.93: registering with nfnetlink.
[    0.577590] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.577641] TCP cubic registered
[    0.577646] Initializing XFRM netlink socket
[    0.578159] NET: Registered protocol family 10
[    0.578734] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.578788] IPv6 over IPv4 tunneling driver
[    0.579680] NET: Registered protocol family 17
[    0.579717] Registering the dns_resolver key type
[    0.580246] PM: Hibernation image not present or could not be loaded.
[    0.580268] registered taskstats version 1
[    0.580306] XENBUS: Device with no driver: device/vif/0
[    0.580311] XENBUS: Device with no driver: device/vfb/0
[    0.580324] XENBUS: Device with no driver: device/vkbd/0
[    0.580338]   Magic number: 1:252:3141
[    0.580459] powernow-k8: Found 1 AMD Phenom(tm) II X6 1075T Processor (4 cpu cores) (version 2.20.00)
[    0.580510] powernow-k8: Core Performance Boosting: on.
[    0.580526] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    0.580528] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    0.581017] Freeing unused kernel memory: 692k freed
[    0.581208] Write protecting the kernel read-only data: 8192k
[    0.584393] Freeing unused kernel memory: 184k freed
[    0.584595] Freeing unused kernel memory: 328k freed
[    0.585880] init[1] illegal int 0xcc from 32-bit mode ip:ffffffffff600400 cs:e033 sp:7fff230ca088 ax:ffffffffff600400 si:7faee3e822bf di:7fff230ca158
[    0.586105] init used greatest stack depth: 5064 bytes left
[    0.586118] Kernel panic - not syncing: Attempted to kill init!
[    0.586126] Pid: 1, comm: init Not tainted 3.0.0-03370-gb6844e8-dirty #1
[    0.586132] Call Trace:
[    0.586144]  [<ffffffff815bd12d>] panic+0x96/0x1ad
[    0.586152]  [<ffffffff810845d1>] ? get_parent_ip+0x11/0x50
[    0.586160]  [<ffffffff810966e8>] do_exit+0x968/0x970
[    0.586167]  [<ffffffff8109673c>] do_group_exit+0x4c/0xc0
[    0.586175]  [<ffffffff810a850f>] get_signal_to_deliver+0x20f/0x5c0
[    0.586184]  [<ffffffff810492f3>] do_signal+0x63/0x710
[    0.586191]  [<ffffffff810402b2>] ? check_events+0x12/0x20
[    0.586198]  [<ffffffff810845d1>] ? get_parent_ip+0x11/0x50
[    0.586206]  [<ffffffff815c392d>] ? sub_preempt_count+0x9d/0xd0
[    0.586217]  [<ffffffff815c03e7>] ? _raw_spin_unlock_irqrestore+0x27/0x50
[    0.586227]  [<ffffffff810a706d>] ? force_sig_info+0x9d/0x110
[    0.586235]  [<ffffffff81049a05>] do_notify_resume+0x65/0x80
[    0.586242]  [<ffffffff8104dd6e>] ? do_emulate_vsyscall+0x5e/0x190
[    0.586249]  [<ffffffff815c093c>] retint_signal+0x48/0x8c
Parsing config file /root/pv.xm
Daemon running with PID 9155
