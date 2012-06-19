Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2FSTLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:11:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44571 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2FSTLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:11:11 -0400
Date: Tue, 19 Jun 2012 11:54:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, johnstul@us.ibm.com,
        fweisbec@gmail.com
Subject: Re: WARNING: at /home/konrad/ssd/linux/kernel/rcutree.c:1547
 __rcu_process_callbacks+0x42e/0x440()
Message-ID: <20120619185457.GA6827@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120619182216.GA13454@phenom.dumpdata.com>
 <20120619184718.GF2385@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619184718.GF2385@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061919-7182-0000-0000-000001C7E05A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:47:18AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 19, 2012 at 02:22:16PM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > I've been getting this when booting a Xen PV guest with 3 CPUs (of which two are
> > online). Any thoughts?
> 
> Maybe...  I am assuming that your kernel/rcutree.c:1547 is this line of code:
> 
> 	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
> 
> This is line 1549 in current mainline.
> 
> If my guess is correct, my question is "why on earth is a CPU that has
> marked itself offline taking a timer interrupt???"
> 
> I could provide a patch to make RCU work around this problem from its
> viewpoint, but taking timer interrupts on an offline CPU is an extremely
> bad idea.  It would be good to fix the underlying problem instead of
> silencing RCU's warning.

And one possible source for the problem might be if queue_stop_cpus_work()
or one of its ancestors in the function-call graph incorrectly enabled
interrupts.

							Thanx, Paul

> If my guess on what line is warning you is wrong, please do let me know
> what the line really is -- or even better, the corresponding mainline
> git commit ID.
> 
> 							Thanx, Paul
> 
> > Using config file "/test.xm".
> > Started domain latest (id=6)
> > [    0.000000] console [hvc0] enabled, bootconsole disabled
> > [    0.000000] Xen: using vcpuop timer interface
> > [    0.000000] installing Xen timer for CPU 0
> > [    0.000000] Detected 3093.036 MHz processor.
> > [    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6186.07 BogoMIPS (lpj=3093036)
> > [    0.000999] pid_max: default: 32768 minimum: 301
> > [    0.000999] Security Framework initialized
> > [    0.000999] SELinux:  Initializing.
> > [    0.000999] SELinux:  Starting in permissive mode
> > [    0.000999] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> > [    0.000999] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> > [    0.000999] Mount-cache hash table entries: 256
> > [    0.000999] Initializing cgroup subsys cpuacct
> > [    0.000999] Initializing cgroup subsys freezer
> > [    0.000999] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> > [    0.000999] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> > [    0.000999] CPU: Physical Processor ID: 0
> > [    0.000999] CPU: Processor Core ID: 0
> > [    0.000999] SMP alternatives: switching to UP code
> > [    0.026357] cpu 0 spinlock event irq 17
> > [    0.026377] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
> > [    0.026462] NMI watchdog: disabled (cpu0): hardware events not enabled
> > [    0.026567] installing Xen timer for CPU 1
> > [    0.026580] cpu 1 spinlock event irq 24
> > [    0.026603] SMP alternatives: switching to SMP code
> > [    0.049557] NMI watchdog: disabled (cpu1): hardware events not enabled
> > [    0.049756] installing Xen timer for CPU 2
> > [    0.049786] cpu 2 spinlock event irq 31
> > [    0.049996] NMI watchdog: disabled (cpu2): hardware events not enabled
> > [    0.049996] Brought up 3 CPUs
> > [    0.050313] kworker/u:0 (20) used greatest stack depth: 6000 bytes left
> > [    0.051028] Grant tables using version 2 layout.
> > [    0.051065] Grant table initialized
> > [    0.069993] RTC time: 165:165:165, date: 165/165/65
> > [    0.070103] NET: Registered protocol family 16
> > [    0.070141] kworker/u:0 (24) used greatest stack depth: 5544 bytes left
> > [    0.073000] ------------[ cut here ]------------
> > [    0.073006] WARNING: at /home/konrad/ssd/linux/kernel/rcutree.c:1547 __rcu_process_callbacks+0x42e/0x440()
> > [    0.073008] Modules linked in:
> > [    0.073010] Pid: 12, comm: migration/2 Not tainted 3.5.0-rc2 #2
> > [    0.073011] Call Trace:
> > [    0.073017]  <IRQ>  [<ffffffff810718ea>] warn_slowpath_common+0x7a/0xb0
> > [    0.073019]  [<ffffffff81071935>] warn_slowpath_null+0x15/0x20
> > [    0.073021]  [<ffffffff810edb1e>] __rcu_process_callbacks+0x42e/0x440
> > [    0.073023]  [<ffffffff810edb50>] rcu_process_callbacks+0x20/0x40
> > [    0.073025]  [<ffffffff810792c9>] __do_softirq+0xa9/0x160
> > [    0.073028]  [<ffffffff810a1065>] ? sched_clock_local+0x25/0x90
> > [    0.073030]  [<ffffffff810d7201>] ? queue_stop_cpus_work+0x51/0xf0
> > [    0.073033]  [<ffffffff815cee1c>] call_softirq+0x1c/0x30
> > [    0.073034]  [<ffffffff81039435>] do_softirq+0x65/0xa0
> > [    0.073036]  [<ffffffff810790c5>] irq_exit+0xd5/0xf0
> > [    0.073039]  [<ffffffff8132347f>] xen_evtchn_do_upcall+0x2f/0x40
> > [    0.073040]  [<ffffffff815cee6e>] xen_do_hypervisor_callback+0x1e/0x30
> > [    0.073042]  <EOI>  [<ffffffff810d7201>] ? queue_stop_cpus_work+0x51/0xf0
> > [    0.073044]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
> > [    0.073045]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1000
> > [    0.073048]  [<ffffffff8103361d>] ? xen_force_evtchn_callback+0xd/0x10
> > [    0.073049]  [<ffffffff81033ed2>] ? check_events+0x12/0x20
> > [    0.073051]  [<ffffffff81033ebf>] ? xen_restore_fl_direct_reloc+0x4/0x4
> > [    0.073053]  [<ffffffff810d73aa>] ? stop_machine_cpu_stop+0xba/0xf0
> > [    0.073054]  [<ffffffff810d72f0>] ? stop_one_cpu_nowait+0x50/0x50
> > [    0.073055]  [<ffffffff810d7021>] ? cpu_stopper_thread+0xf1/0x1c0
> > [    0.073058]  [<ffffffff815c5d7e>] ? __schedule+0x3be/0x760
> > [    0.073060]  [<ffffffff815c6d59>] ? _raw_spin_unlock_irqrestore+0x19/0x30
> > [    0.073061]  [<ffffffff810d6f30>] ? res_counter_charge+0x10/0x10
> > [    0.073064]  [<ffffffff81090c46>] ? kthread+0x96/0xa0
> > [    0.073065]  [<ffffffff815ced24>] ? kernel_thread_helper+0x4/0x10
> > [    0.073067]  [<ffffffff815c72b8>] ? retint_restore_args+0x5/0x6
> > [    0.073069]  [<ffffffff815ced20>] ? gs_change+0x13/0x13
> > [    0.073073] ---[ end trace 4eaa2a86a8e2da22 ]---
> > [    0.073075] dca service started, version 1.12.1
> > [    0.074006] PCI: setting up Xen PCI frontend stub
> > [    0.074015] PCI: pci_cache_line_size set to 64 bytes
> > [    0.088093] bio: create slab <bio-0> at 0
> > [    0.089051] ACPI: Interpreter disabled.
> > [    0.089063] xen/balloon: Initialising balloon driver.
> > [    0.091124] xen-balloon: Initialising balloon driver.
> > [    0.092068] vgaarb: loaded
> > [    0.092068] usbcore: registered new interface driver usbfs
> > [    0.092087] usbcore: registered new interface driver hub
> > [    0.093027] usbcore: registered new device driver usb
> > [    0.093039] PCI: System does not support PCI
> > [    0.093039] PCI: System does not support PCI
> > [    0.094043] NetLabel: Initializing
> > [    0.094052] NetLabel:  domain hash size = 128
> > [    0.094057] NetLabel:  protocols = UNLABELED CIPSOv4
> > [    0.094077] NetLabel:  unlabeled traffic allowed by default
> > [    0.094099] Switching to clocksource xen
> > [    0.094160] pnp: PnP ACPI: disabled
> > [    0.101664] NET: Registered protocol family 2
> > [    0.101866] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
> > [    0.102859] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
> > [    0.103661] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> > [    0.103849] TCP: Hash tables configured (established 131072 bind 65536)
> > [    0.103858] TCP: reno registered
> > [    0.103873] UDP hash table entries: 512 (order: 2, 16384 bytes)
> > [    0.103891] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> > [    0.104035] NET: Registered protocol family 1
> > [    0.104333] RPC: Registered named UNIX socket transport module.
> > [    0.104347] RPC: Registered udp transport module.
> > [    0.104356] RPC: Registered tcp transport module.
> > [    0.104362] RPC: Registered tcp NFSv4.1 backchannel transport module.
> > [    0.104371] PCI: CLS 0 bytes, default 64
> > [    0.104511] Trying to unpack rootfs image as initramfs...
> > [    0.337888] Freeing initrd memory: 273152k freed
> > [    0.383239] platform rtc_cmos: registered platform RTC device (no PNP device found)
> > [    0.383418] Machine check injector initialized
> > [    0.384702] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x12
> > [    0.384730] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x12
> > [    0.384859] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> > [    0.385589] audit: initializing netlink socket (disabled)
> > [    0.385612] type=2000 audit(1340130254.678:1): initialized
> > [    0.403267] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> > [    0.403508] VFS: Disk quotas dquot_6.5.2
> > [    0.403552] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> > [    0.403720] NFS: Registering the id_resolver key type
> > [    0.403739] Key type id_resolver registered
> > [    0.403882] NTFS driver 2.1.30 [Flags: R/W].
> > [    0.403981] msgmni has been set to 1986
> > [    0.404021] SELinux:  Registering netfilter hooks
> > [    0.404794] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> > [    0.404806] io scheduler noop registered
> > [    0.404812] io scheduler deadline registered
> > [    0.404843] io scheduler cfq registered (default)
> > [    0.404993] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> > [    0.405260] ioatdma: Intel(R) QuickData Technology Driver 4.00
> > [    0.451143] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > [    0.452662] Non-volatile memory driver v1.3
> > [    0.452673] Linux agpgart interface v0.103
> > [    0.453294] [drm] Initialized drm 1.1.0 20060810
> > [    0.457300] brd: module loaded
> > [    0.459306] loop: module loaded
> > [    0.459798] Fixed MDIO Bus: probed
> > [    0.459807] tun: Universal TUN/TAP device driver, 1.6
> > [    0.459813] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> > [    0.459986] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.6.0-k
> > [    0.459998] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
> > [    0.460777] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> > [    0.460788] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
> > [    0.460891] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> > [    0.460901] ohci_hcd: block sizes: ed 80 td 96
> > [    0.461001] uhci_hcd: USB Universal Host Controller Interface driver
> > [    0.461293] usbcore: registered new interface driver usblp
> > [    0.461392] usbcore: registered new interface driver libusual
> > [    0.461734] i8042: PNP: No PS/2 controller found. Probing ports directly.
> > [    0.462609] i8042: No controller found
> > [    0.462737] mousedev: PS/2 mouse device common for all mice
> > [    0.523312] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> > [    0.523440] rtc_cmos: probe of rtc_cmos failed with error -38
> > [    0.523679] EFI Variables Facility v0.08 2004-May-17
> > [    0.523734] zram: num_devices not specified. Using default: 1
> > [    0.523739] zram: Creating 1 devices ...
> > [    0.523980] xenoprofile_init: ret 0, events 4, xenoprof_is_primary 0
> > [    0.524019] Netfilter messages via NETLINK v0.30.
> > [    0.524035] nf_conntrack version 0.5.0 (7944 buckets, 31776 max)
> > [    0.524099] ctnetlink v0.93: registering with nfnetlink.
> > [    0.524262] ip_tables: (C) 2000-2006 Netfilter Core Team
> > [    0.524293] TCP: cubic registered
> > [    0.524298] Initializing XFRM netlink socket
> > [    0.524346] NET: Registered protocol family 10
> > [    0.524486] ip6_tables: (C) 2000-2006 Netfilter Core Team
> > [    0.524675] sit: IPv6 over IPv4 tunneling driver
> > [    0.524866] NET: Registered protocol family 17
> > [    0.524902] Key type dns_resolver registered
> > [    0.525076] PM: Hibernation image not present or could not be loaded.
> > [    0.525094] registered taskstats version 1
> > [    0.525121] XENBUS: Device with no driver: device/vkbd/0
> > [    0.525127] XENBUS: Device with no driver: device/vfb/0
> > [    0.525132] XENBUS: Device with no driver: device/vif/0
> > [    0.525191]   Magic number: 1:252:3141
> > [    0.525898] Freeing unused kernel memory: 716k freed
> > [    0.526109] Write protecting the kernel read-only data: 8192k
> > [    0.530939] Freeing unused kernel memory: 172k freed
> > [    0.531314] Freeing unused kernel memory: 356k freed
> > init started: BusyBox v1.14.3 (2012-06-19 13:33:49 EDT)
> > [    0.536840] consoletype (1049) used greatest stack depth: 5304 bytes left
> > Mounting directories  [  OK  ]
> > mount: mount point /proc/bus/usb does not exist
> > [    0.723241] modprobe (1078) used greatest stack depth: 5064 bytes left
> > mount: mount point /sys/kernel/config does not exist
> > [    0.731128] core_filesystem (1050) used greatest stack depth: 4984 bytes left
> > [    0.744953] input: Xen Virtual Keyboard as /devices/virtual/input/input0
> > [    0.745268] input: Xen Virtual Pointer as /devices/virtual/input/input1
> > [    0.963843] Initialising Xen virtual ethernet driver.
> > [    1.085463] udevd (1114): /proc/1114/oom_adj is deprecated, please use /proc/1114/oom_score_adj instead.
> > udevd-work[1125]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory
> > 
> > Waiting for devices [  OK  ]
> > [    1.247709] ip (1927) used greatest stack depth: 3768 bytes left
> > Waiting for init.pre_custom [  OK  ]
> > Waiting for fb [  OK  ]
> > Starting..[/dev/fb0]
> > /dev/fb0: len:0
> > /dev/fb0: bits/pixel32
> > (7f69b03c2000): Writting .. [800:600]
> > Done!
> > .. blah blah
> > 

