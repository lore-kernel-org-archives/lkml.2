Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1GZVIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:08:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38053 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1GZVIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:08:49 -0400
Date: Tue, 26 Jul 2011 17:06:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@infradead.org,
        JBeulich@novell.com, richard.weinberger@gmail.com, mikpe@it.uu.se,
        andi@firstfloor.org, brgerst@gmail.com, Louis.Rilling@kerlabs.com,
        Valdis.Kletnieks@vt.edu, pageexec@freemail.hu, mingo@elte.hu,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64:
 Give vvars their own page) breaks Xen PV guests (64-bit).
Message-ID: <20110726210605.GA18994@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com>
 <20110725161009.GA9193@dumpdata.com>
 <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
 <20110726161808.GA5333@dumpdata.com>
 <CAObL_7Fi5F6Xxv7Z5UtEQAA+gH4429gN=GG8ur6rxa6-rgr+2w@mail.gmail.com>
 <20110726205121.GA29604@dumpdata.com>
 <CAObL_7Fiv9kkSeu5qkq3GubbWvykHLpVzurpeJQ9WoSR=XR5xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAObL_7Fiv9kkSeu5qkq3GubbWvykHLpVzurpeJQ9WoSR=XR5xA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E2F2C53.0083,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 04:55:57PM -0400, Andrew Lutomirski wrote:
> On Tue, Jul 26, 2011 at 4:51 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >> That one means that the vvar fixmap isn't working.  Can you try the
> >> attached patch?
> >
> > Sure. Albeit it looks to be missing a check for the 0xe033 cs?
> 
> Sorry -- I meant can you try that on top of the 0xe033 hack?

Yeah, and with this patch:

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca6f7ab..b1f3f53 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -638,6 +638,25 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		break;
 	}
 
+	case 1000: {
+		kernel_fpu_begin();
+		kernel_fpu_end();
+		ret = 0;
+		break;
+	}
+
+	case 1001: {
+		int i;
+		kernel_fpu_begin();
+		for (i = 0; i < 999; i++) {
+			stts();
+			clts();
+		}
+		kernel_fpu_end();
+		ret = 0;
+		break;
+	}
+
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dda7dff..5d0cf37 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -131,7 +131,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
 	 * is bogus.
 	 */
-	if (regs->cs != __USER_CS) {
+	if ((regs->cs != __USER_CS) && (regs->cs != FLAT_RING3_CS64)) {
 		/*
 		 * If we trapped from kernel mode, we might as well OOPS now
 		 * instead of returning to some random address and OOPSing
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f987bde..1668deb 100644
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
@@ -1956,7 +1957,8 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE ||
+	    idx == VVAR_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}

It boots up fine:


(early) [    0.000000] Initializing cgroup subsys cpuset
(early) [    0.000000] Initializing cgroup subsys cpu
(early) [    0.000000] Linux version 3.0.0-05046-ge08dc13-dirty (konrad@phenom) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Tue Jul 26 16:54:34 EDT 2011
(early) [    0.000000] Command line: console=hvc0 debug     earlyprintk=xenboot test=test
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
(early) [    0.000000] initial memory mapped : 0 - 1028f000
(early) [    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
(early) [    0.000000] init_memory_mapping: 0000000000000000-0000000080800000
(early) [    0.000000]  0000000000 - 0080800000 page 4k
(early) [    0.000000] kernel direct mapping tables up to 80800000 @ 7fbf8000-80000000
(early) [    0.000000] xen: setting RW the range 7ff76000 - 80000000
(early) [    0.000000] RAMDISK: 01b76000 - 1028f000
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
(early) [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007fb88000 s82048 r8192 d24448 u114688
(early) [    0.000000] pcpu-alloc: s82048 r8192 d24448 u114688 alloc=28*4096(early) 
(early) [    0.000000] pcpu-alloc: (early) [0] (early) 0 (early) [0] (early) 1 (early) [0] (early) 2 (early) [0] (early) 3 (early) 
(early) [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 519023
(early) [    0.000000] Policy zone: DMA32
(early) [    0.000000] Kernel command line: console=hvc0 debug     earlyprintk=xenboot test=test
(early) [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
(early) [    0.000000] Checking aperture...
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
(early) [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
(early) [    0.000000] Memory: 1810140k/2105344k available (5942k kernel code, 448k absent, 294756k reserved, 2808k data, 692k init)
(early) [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
(early) [    0.000000] Preemptible hierarchical RCU implementation.
(early) [    0.000000] NR_IRQS:16640 nr_irqs:304 16
(early) [    0.000000] Console: colour dummy device 80x25
(early) [    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
(early) [    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 3000.212 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.42 BogoMIPS (lpj=3000212)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Initializing.
[    0.000999] SELinux:  Starting in permissive mode
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001199] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001446] Mount-cache hash table entries: 256
[    0.001596] Initializing cgroup subsys cpuacct
[    0.001604] Initializing cgroup subsys freezer
[    0.001642] tseg: 0000000000
[    0.001653] CPU: Physical Processor ID: 0
[    0.001657] CPU: Processor Core ID: 1
[    0.001707] SMP alternatives: switching to UP code
[    0.002069] cpu 0 spinlock event irq 17
[    0.002115] Performance Events: 
[    0.002119] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.002125] no hardware sampling interrupt available.
[    0.002147] Broken PMU hardware detected, using software events only.
[    0.008049] MCE: In-kernel MCE decoding enabled.
[    0.008074] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.014060] installing Xen timer for CPU 1
[    0.014117] cpu 1 spinlock event irq 23
[    0.014194] SMP alternatives: switching to SMP code
[    0.015186] NMI watchdog disabled (cpu1): hardware events not enabled
[    0.021063] installing Xen timer for CPU 2
[    0.021118] cpu 2 spinlock event irq 29
[    0.021368] NMI watchdog disabled (cpu2): hardware events not enabled
[    0.027068] installing Xen timer for CPU 3
[    0.027120] cpu 3 spinlock event irq 35
[    0.027357] NMI watchdog disabled (cpu3): hardware events not enabled
[    0.029063] Brought up 4 CPUs
[    0.029307] kworker/u:0 used greatest stack depth: 5496 bytes left
[    0.029307] Grant table initialized
[    0.048886] RTC time: 165:165:165, date: 165/165/65
[    0.048951] NET: Registered protocol family 16
[    0.049047] Extended Config Space enabled on 0 nodes
[    0.050350] PCI: setting up Xen PCI frontend stub
[    0.050358] PCI: pci_cache_line_size set to 64 bytes
[    0.059241] bio: create slab <bio-0> at 0
[    0.060017] ACPI: Interpreter disabled.
[    0.060036] xen/balloon: Initialising balloon driver.
[    0.060036] last_pfn = 0x80800 max_arch_pfn = 0x400000000
[    0.062260] xen-balloon: Initialising balloon driver.
[    0.063073] vgaarb: loaded
[    0.063073] usbcore: registered new interface driver usbfs
[    0.063073] usbcore: registered new interface driver hub
[    0.063073] usbcore: registered new device driver usb
[    0.064030] PCI: System does not support PCI
[    0.064030] PCI: System does not support PCI
[    0.064053] NetLabel: Initializing
[    0.064053] NetLabel:  domain hash size = 128
[    0.064053] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.064053] NetLabel:  unlabeled traffic allowed by default
[    0.064076] Switching to clocksource xen
[    0.064076] Switched to NOHz mode on CPU #3
[    0.064414] Switched to NOHz mode on CPU #0
[    0.064996] Switched to NOHz mode on CPU #2
[    0.065113] Switched to NOHz mode on CPU #1
[    0.066290] pnp: PnP ACPI: disabled
[    0.071025] PCI: max bus depth: 0 pci_try_num: 1
[    0.071084] NET: Registered protocol family 2
[    0.071274] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.072620] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.073896] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.074185] TCP: Hash tables configured (established 262144 bind 65536)
[    0.074194] TCP reno registered
[    0.074215] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.074239] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.074332] NET: Registered protocol family 1
[    0.074583] RPC: Registered named UNIX socket transport module.
[    0.074592] RPC: Registered udp transport module.
[    0.074597] RPC: Registered tcp transport module.
[    0.074601] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.074609] PCI: CLS 0 bytes, default 64
[    0.074726] Trying to unpack rootfs image as initramfs...
[    0.316784] Freeing initrd memory: 236644k freed
[    0.377411] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.378778] Machine check injector initialized
[    0.379554] microcode: CPU0: patch_level=0x010000bf
[    0.379574] microcode: CPU1: patch_level=0x010000bf
[    0.379621] microcode: CPU2: patch_level=0x010000bf
[    0.379671] microcode: CPU3: patch_level=0x010000bf
[    0.379748] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.380129] audit: initializing netlink socket (disabled)
[    0.380147] type=2000 audit(1311714191.306:1): initialized
[    0.394045] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.399695] VFS: Disk quotas dquot_6.5.2
[    0.399844] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.400589] NTFS driver 2.1.30 [Flags: R/W].
[    0.400895] msgmni has been set to 3997
[    0.401041] SELinux:  Registering netfilter hooks
[    0.401781] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.401790] io scheduler noop registered
[    0.401794] io scheduler deadline registered
[    0.401908] io scheduler cfq registered (default)
[    0.402285] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.450645] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.514817] Non-volatile memory driver v1.3
[    0.514826] Linux agpgart interface v0.103
[    0.515298] [drm] Initialized drm 1.1.0 20060810
[    0.518170] brd: module loaded
[    0.519592] loop: module loaded
[    0.520265] Fixed MDIO Bus: probed
[    0.520797] tun: Universal TUN/TAP device driver, 1.6
[    0.520804] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.521202] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.521211] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    0.521303] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.521310] ohci_hcd: block sizes: ed 80 td 96
[    0.521400] uhci_hcd: USB Universal Host Controller Interface driver
[    0.521570] usbcore: registered new interface driver usblp
[    0.521649] usbcore: registered new interface driver libusual
[    0.521944] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.522766] i8042: No controller found
[    0.523049] mousedev: PS/2 mouse device common for all mice
[    0.563573] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.563697] rtc_cmos: probe of rtc_cmos failed with error -38
[    0.564012] cpuidle: using governor ladder
[    0.564018] cpuidle: using governor menu
[    0.564023] EFI Variables Facility v0.08 2004-May-17
[    0.564118] zram: num_devices not specified. Using default: 1
[    0.564125] zram: Creating 1 devices ...
[    0.564504] Netfilter messages via NETLINK v0.30.
[    0.564525] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.564828] ctnetlink v0.93: registering with nfnetlink.
[    0.565311] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.565346] TCP cubic registered
[    0.565351] Initializing XFRM netlink socket
[    0.565760] NET: Registered protocol family 10
[    0.566372] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.566433] IPv6 over IPv4 tunneling driver
[    0.567372] NET: Registered protocol family 17
[    0.567408] Registering the dns_resolver key type
[    0.567985] PM: Hibernation image not present or could not be loaded.
[    0.568005] registered taskstats version 1
[    0.568041] XENBUS: Device with no driver: device/vif/0
[    0.568046] XENBUS: Device with no driver: device/vfb/0
[    0.568052] XENBUS: Device with no driver: device/vkbd/0
[    0.568065]   Magic number: 1:252:3141
[    0.568211] powernow-k8: Found 1 AMD Phenom(tm) II X6 1075T Processor (4 cpu cores) (version 2.20.00)
[    0.568237] powernow-k8: Core Performance Boosting: on.
[    0.568253] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    0.568254] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    0.568769] Freeing unused kernel memory: 692k freed
[    0.568966] Write protecting the kernel read-only data: 8192k
[    0.572048] Freeing unused kernel memory: 180k freed
[    0.572251] Freeing unused kernel memory: 328k freed
init started: BusyBox v1.14.3 (2011-07-26 16:55:54 EDT)
[    0.579282] consoletype used greatest stack depth: 5376 bytes left
Mounting directories  [  OK  ]
[    0.799316] modprobe used greatest stack depth: 5136 bytes left
mount: mount point /sys/kernel/config does not exist
[    0.806063] core_filesystem used greatest stack depth: 5024 bytes left
[    0.818750] input: Xen Virtual Keyboard as /devices/virtual/input/input0
[    0.819044] input: Xen Virtual Pointer as /devices/virtual/input/input1
[    1.041570] Initialising Xen virtual ethernet driver.
[    1.158627] ------------[ cut here ]------------
[    1.158669] WARNING: at /home/konrad/ssd/linux/fs/proc/base.c:1123 oom_adjust_write+0x294/0x2b0()
[    1.158677] udevd (1192): /proc/1192/oom_adj is deprecated, please use /proc/1192/oom_score_adj instead.
[    1.158685] Modules linked in: xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs
[    1.158711] Pid: 1192, comm: udevd Not tainted 3.0.0-05046-ge08dc13-dirty #1
[    1.158717] Call Trace:
[    1.158725]  [<ffffffff810921da>] warn_slowpath_common+0x7a/0xb0
[    1.158733]  [<ffffffff810922b1>] warn_slowpath_fmt+0x41/0x50
[    1.158740]  [<ffffffff8109de85>] ? ns_capable+0x25/0x60
[    1.158747]  [<ffffffff811d4d44>] oom_adjust_write+0x294/0x2b0
[    1.158755]  [<ffffffff81175698>] vfs_write+0xc8/0x190
[    1.158761]  [<ffffffff8117584c>] sys_write+0x4c/0x90
[    1.158769]  [<ffffffff815c8512>] system_call_fastpath+0x16/0x1b
[    1.158775] ---[ end trace 53a836e564b32553 ]---
[    1.289040] ip used greatest stack depth: 3936 bytes left
Waiting for devices [  OK  ]
Waiting for fb [  OK  ]
Starting..[/dev/fb0]
/dev/fb0: len:0
/dev/fb0: bits/pixel32
(7fdbfe873000): Writting .. [800:600]
Done!
FATAL: Module agpgart_intel not found.
[    1.420253] Console: switching to colour frame buffer device 100x37
[    1.462964] [drm] radeon kernel modesetting enabled.
WARNING: Error inserting wmi (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/platform/x86/wmi.ko): No such device
WARNING: Error inserting mxm_wmi (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/platform/x86/mxm-wmi.ko): No such device
WARNING: Error inserting drm_kms_helper (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
WARNING: Error inserting ttm (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/gpu/drm/ttm/ttm.ko): No such device
FATAL: Error inserting nouveau (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/gpu/drm/nouveau/nouveau.ko): No such device
WARNING: Error inserting drm_kms_helper (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
FATAL: Error inserting i915 (/lib/modules/3.0.0-05046-ge08dc13-dirty/kernel/drivers/gpu/drm/i915/i915.ko): No such device
Starting..[/dev/fb0]
/dev/fb0: len:0
/dev/fb0: bits/pixel32
(7fecfee0e000): Writting .. [800:600]
Done!
VGA: 0000:
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [    1.785668] device eth0 entered promiscuous mode
[  OK  ]
Bringing up interface switch:  
Determining IP information for switch...[    1.843220] switch: port 1(eth0) entering forwarding state
[    1.843271] switch: port 1(eth0) entering forwarding state
 done.
[  OK  ]
Waiting for init.custom [  OK  ]
Start sshd
PING master.dumpdata.com (192.168.101.1) 56(84) bytes of data.

--- master.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 1ms
rtt min/avg/max/mdev = 0.365/0.365/0.365/0.000 ms
mount.nfs: rpc.statd is not running but is required for remote locking.
mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
mount.nfs: an incorrect mount option was specified

Starting SSHd ...
[    3.190254] mount.nfs used greatest stack depth: 3648 bytes left
[    3.193509] [drm] Module unloaded
ERROR: Module nouveau does not exist in /proc/modules
libxl: error: libxl.c:61:libxl_ctx_alloc: Is xenstore daemon running?
failed to stat /var/run/xenstored.pid: No such file or directory
cannot init xl context
Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2319] ignoring start request
[    3.359346] SCSI subsystem initialized
[    3.361222] Loading iSCSI transport class v2.0-870.
[    3.364431] iscsi: registered transport (tcp)
iscsistart: transport class version 2.0-870. iscsid version 2.0-872
Could not get list of targets from firmware.
Jul 26 21:03:14 g-pvops syslogd 1.5.0: restart.
FATAL: Module evtchn not found.
[    3.400467] Event-channel device installed.
xencommons should be started first.
           CPU0       CPU1       CPU2       CPU3       
 16:       1720          0          0          0  xen-percpu-virq      timer0
 17:          8          0          0          0  xen-percpu-ipi       spinlock0
 18:       2432          0          0          0  xen-percpu-ipi       resched0
 19:        162          0          0          0  xen-percpu-ipi       callfunc0
 20:          0          0          0          0  xen-percpu-virq      debug0
 21:        105          0          0          0  xen-percpu-ipi       callfuncsingle0
 22:          0       1724          0          0  xen-percpu-virq      timer1
 23:          0         11          0          0  xen-percpu-ipi       spinlock1
 24:          0       2050          0          0  xen-percpu-ipi       resched1
 25:          0        139          0          0  xen-percpu-ipi       callfunc1
 26:          0          0          0          0  xen-percpu-virq      debug1
 27:          0         84          0          0  xen-percpu-ipi       callfuncsingle1
 28:          0          0       1345          0  xen-percpu-virq      timer2
 29:          0          0         23          0  xen-percpu-ipi       spinlock2
 30:          0          0        671          0  xen-percpu-ipi       resched2
 31:          0          0        161          0  xen-percpu-ipi       callfunc2
 32:          0          0          0          0  xen-percpu-virq      debug2
 33:          0          0        101          0  xen-percpu-ipi       callfuncsingle2
 34:          0          0          0       1684  xen-percpu-virq      timer3
 35:          0          0          0         15  xen-percpu-ipi       spinlock3
 36:          0          0          0       1437  xen-percpu-ipi       resched3
 37:          0          0          0        156  xen-percpu-ipi       callfunc3
 38:          0          0          0          0  xen-percpu-virq      debug3
 39:          0          0          0        118  xen-percpu-ipi       callfuncsingle3
 40:        404          0          0          0   xen-dyn-event     xenbus
 41:         71          0          0          0   xen-dyn-event     hvc_console
 42:          0          0          0          0   xen-dyn-event     vkbd
 43:         70          0          0          0   xen-dyn-event     vfb
 44:        107          0          0          0   xen-dyn-event     eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:          0          0          0          0   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:       2432       2050        671       1437   Rescheduling interrupts
CAL:        267        223        262        274   Function call interrupts
TLB:          0          0          0          0   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          0          0          0          0   Machine check polls
ERR:          0
MIS:          0
00000000-0000ffff : reserved
00010000-0009ffff : System RAM
000a0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-807fffff : System RAM
  01000000-015cd9bb : Kernel code
  015cd9bc-0188bbff : Kernel data
  01941000-01a3ffff : Kernel bss
Starting test testcase..
Jul 26 21:03:14 g-pvops init: starting pid 2436, tty '/dev/tty0': '/bin/sh'
Jul 26 21:03:14 g-pvops init: starting pid 2437, tty '/dev/tty1': '/bin/sh'
Jul 26 21:03:14 g-pvops init: starting pid 2438, tty '/dev/ttyS0': '/bin/sh'

   ~~~~~~~~~~~~~~~~~~~~~~~~~~| DirectFB 1.4.9 |~~~~~~~~~~~~~~~~~~~~~~~~~~
        (c) 2001-2010  The world wide DirectFB Open Source Community
        (c) 2000-2004  Convergence (integrated media) GmbH
      ----------------------------------------------------------------

(*) DirectFB/Core: Single Application Core. (2011-07-26 20:56) 
Jul 26 21:03:14 g-pvops init: starting pid 2439, tty '/dev/hvc0': '/bin/sh'
(*) Direct/Memcpy: Using libc memcpy()
sh-4.1# (*) Direct/Thread: Started 'VT Switcher' (-1) [CRITICAL OTHER/OTHER 0/0] <8388608>...
(*) Direct/Thread: Started 'VT Flusher' (-1) [DEFAULT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/FBDev: Found 'xen' (ID 0) with frame buffer at 0x00000000, 2048k (MMIO 0x00000000, 0k)
(*) Direct/Thread: Started 'Keyboard Input' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/Input: Keyboard 0.9 (directfb.org)
(*) Direct/Thread: Started 'PS/2 Input' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/Input: IMPS/2 Mouse 1.0 (directfb.org)
(*) Direct/Thread: Started 'Linux Input' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/Input: Xen Virtual Keyboard (1) 0.1 (directfb.org)
(*) Direct/Thread: Started 'Linux Input' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/Input: Xen Virtual Pointer (2) 0.1 (directfb.org)
(*) Direct/Thread: Started 'Hotplug with Linux Input' (-1) [INPUT OTHER/OTHER 0/0] <8388608>...
(*) DirectFB/Input: Hot-plug detection enabled with Linux Input Driver 
(*) DirectFB/Genefx: MMX detected and enabled
(*) DirectFB/Graphics: MMX Software Rasterizer 0.6 (directfb.org)
(*) DirectFB/Core/WM: Default 0.3 (directfb.org)
(*) FBDev/Mode: Setting 800x600 RGB32
(*) FBDev/Mode: Switched to 800x600 (virtual 800x600) at 32 bit (RGB32), pitch 3200

    SSH started [2319]


Jul 26 21:03:15 g-pvops iscsid: transport class version 2.0-870. iscsid version 2.0-872
Jul 26 21:03:15 g-pvops iscsid: iSCSI daemon with pid=2400 started!
Jul 26 21:03:15 g-pvops init: process '/bin/sh' (pid 2438) exited. Scheduling for restart.
Jul 26 21:03:15 g-pvops init: starting pid 2452, tty '/dev/ttyS0': '/bin/sh'
Jul 26 21:03:16 g-pvops init: process '/bin/sh' (pid 2452) exited. Scheduling for restart.
Jul 26 21:03:16 g-pvops init: starting pid 2453, tty '/dev/ttyS0': '/bin/sh'
Jul 26 21:03:17 g-pvops init: process '/bin/sh' (pid 2453) exited. Scheduling for restart.
Jul 26 21:03:17 g-pvops init: starting pid 2454, tty '/dev/ttyS0': '/bin/sh'
Jul 26 21:03:18 g-pvops init: process '/bin/sh' (pid 2454) exited. Scheduling for restart.
Jul 26 21:03:18 g-pvops init: starting pid 2455, tty '/dev/ttyS0': '/bin/sh'
poweroJul 26 21:03:19 g-pvops init: process '/bin/sh' (pid 2455) exited. Scheduling for restart.
Jul 26 21:03:19 g-pvops init: starting pid 2457, tty '/dev/ttyS0': '/bin/sh'
ff
Jul 26 21:03:19 g-pvops init: starting pid 2460, tty '': '/etc/init.d/halt'
sh-4.1# Usage: /etc/init.d/halt {start}
The system is going down NOW!
Jul 26 21:03:19Jul 26 21:03:19 g-pvops Sent SIGTERM to all processes
(!) [ 2435:    0.000] --> Caught signal 15 (sent by pid 1, uid 0) <--
 (!!!)  *** WARNING [still objects in 'Window Pool'] *** [object.c:241 in fusion_object_pool_destroy()]
 (!!!)  *** WARNING [still objects in 'Layer Region Pool'] *** [object.c:241 in fusion_object_pool_destroy()]
 (!!!)  *** WARNING [still objects in 'Layer Context Pool'] *** [object.c:241 in fusion_object_pool_destroy()]
 (!!!)  *** WARNING [still objects in 'Surface Pool'] *** [object.c:241 in fusion_object_pool_destroy()]
Sent SIGKILL to all processes
Requesting system poweroff
[   10.925177] System halted.
Parsing config file /root/pv.xm
Daemon running with PID 18759
