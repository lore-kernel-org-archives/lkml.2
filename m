Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2GFVEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:04:13 -0400
Received: from ozlabs.org ([203.10.76.45]:60419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab2GFVEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:04:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: Kay Sievers <kay@vrfy.org>
cc: linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
In-reply-to: <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org> <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com> <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com> <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com> <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com> <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org> <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com> <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com> <16043.1341483625@neuling.org> <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com> <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org> <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com> <29711.1341545979@neuling.org> <30343.1341546469@neuling.org> <CAPXgP13_cQUQLE4RSjACTzj28Pn6r3ZaPhjch2U+uwgi7YKcWA@ma
 il.gmail.com> <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
Comments: In-reply-to Kay Sievers <kay@vrfy.org>
   message dated "Fri, 06 Jul 2012 17:12:12 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Sat, 07 Jul 2012 07:04:07 +1000
Message-ID: <21892.1341608647@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> wrote:

> On Fri, Jul 6, 2012 at 12:46 PM, Kay Sievers <kay@vrfy.org> wrote:
> > On Fri, Jul 6, 2012 at 5:47 AM, Michael Neuling <mikey@neuling.org> wrote:
> >
> >>> 4,89,24561;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
> >>> 4,90,24576;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
> >>> 4,91,24583;MSR: 9000000000021032
> >>> 4,92,24586;<
> >>> 4,93,24591;SF
> >>> 4,94,24596;,HV
> >>> 4,95,24601;,ME
> >>> 4,96,24606;,IR
> >>> 4,97,24611;,DR
> >>> 4,98,24616;,RI
> >>> 4,99,24619;>
> >>> 4,100,24628;  CR: 28000042  XER: 22000000
> >>
> >> FWIW, compiling with the parent commit gives this:
> >>
> >> 4,89,1712;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
> >> 4,90,1713;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
> >> 4,91,1716;MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 22000082  XER: 02000000
> >
> > Hmm, I don't understand, which parent commit do you mean? You maybe
> > mean without 084681d?
> >
> > I think it's a race of the two CPUs printing continuation lines, and
> > the continuation buffer is still occupied with data from one CPU and
> > not available to the other one at the same time.
> >
> > What you see is likely not the direct output to the console (that
> > would work) but the replay of the stored buffer when the console is
> > registered. Because the cont buffer was still busy with one CPU, the
> > other thread needs to store the continuation line prints in individual
> > records, which leads to the (unwanted) printed newlines when
> > replaying.
> >
> > The data we store looks all fine, it just looks needlessly separated
> > when we replay fromt he buffer on a newly registered boot console. We
> > need to merge the lines in the output, so they *look* like they are
> > all in one line. I'll work on a fix for that now.
> 
> It could be that the console semaphore is still help by the other CPU,
> for whatever reason, when your box runs into this situation.
> 
> Mind pasting more context (/dev/kmsg) of the log when this happens,
> not only the one line that get split-up?
> 
> Is this possibly during an oops or backtrace going on when you see
> this? Which code calls show_regs() here?

Whole kmsg below.

It is a backtrace.  

It's a warning in
arch/powerpc/sysdev/xics/xics-common.c:xics_set_cpu_giq().  The firmware
this machine is running on is non standard (Bare Metal Linux in the
lab).  The warning itself not an issue.  We've had it for years and it
tells us that our firmware/RTAS is not fully implemented.

Mikey

7,0,0;Allocated 917504 bytes for 1024 pacas at c00000000ff20000
6,1,0;Using pSeries machine description
7,2,0;Page orders: linear mapping = 24, virtual = 16, io = 12, vmemmap = 24
6,3,0;Using 1TB segments
4,4,0;Found initrd at 0xc000000002da5000:0xc00000000bc8c200
6,5,0;CPU maps initialized for 2 threads per core
7,6,0; (thread shift is 1)
7,7,0;Freed 851968 bytes for unused pacas
4,8,0;Starting Linux PPC64 #100 SMP Sat Jul 7 06:55:43 EST 2012
4,9,0;-----------------------------------------------------
4,10,0;ppc64_pft_size                = 0x0
4,11,0;physicalMemorySize            = 0x80000000
4,12,0;htab_address                  = 0xc00000007fe00000
4,13,0;htab_hash_mask                = 0x3fff
4,14,0;-----------------------------------------------------
6,15,0;Initializing cgroup subsys cpuset
5,16,0;Linux version 3.5.0-rc4-mikey (mikey@ka1) (gcc version 4.6.0 (GCC) ) #100 SMP Sat Jul 7 06:55:43 EST 2012
4,17,0;[boot]0012 Setup Arch
7,18,0;Node 0 Memory: 0x0-0x80000000
6,19,0;Section 1 and 127 (node 0) have a circular dependency on usemap and pgdat allocations
4,20,0;pseries_eeh_init: RTAS service <ibm, set-slot-reset> invalid
4,21,0;eeh_init: Failed to call platform init function (-22)
4,22,0;Zone ranges:
4,23,0;  DMA      [mem 0x00000000-0x7fffffff]
4,24,0;  Normal   empty
4,25,0;Movable zone start for each node
4,26,0;Early memory node ranges
4,27,0;  node   0: [mem 0x00000000-0x7fffffff]
7,28,0;On node 0 totalpages: 32768
7,29,0;  DMA zone: 28 pages used for memmap
7,30,0;  DMA zone: 0 pages reserved
7,31,0;  DMA zone: 32740 pages, LIFO batch:1
4,32,0;[boot]0015 Setup Done
6,33,0;PERCPU: Embedded 2 pages/cpu @c000000000e00000 s84224 r0 d46848 u524288
7,34,0;pcpu-alloc: s84224 r0 d46848 u524288 alloc=1*1048576
7,35,0;pcpu-alloc: [0] 0 1 
4,36,0;Built 1 zonelists in Node order, mobility grouping on.  Total pages: 32740
4,37,0;Policy zone: DMA
5,38,0;Kernel command line: ipr.enabled=0
6,39,0;PID hash table entries: 4096 (order: -1, 32768 bytes)
4,40,0;freeing bootmem node 0
6,41,0;Memory: 1916096k/2097152k available (11200k kernel code, 181056k reserved, 1728k data, 1041k bss, 576k init)
6,42,0;SLUB: Genslabs=19, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=256
6,43,0;Hierarchical RCU implementation.
6,44,0;NR_IRQS:512 nr_irqs:512 16
4,45,0;set-indicator(9005, 0, 1) returned -22
4,46,0;------------[ cut here ]------------
4,47,0;WARNING: at /scratch/mikey/src/linux-ozlabs/arch/powerpc/sysdev/xics/xics-common.c:105
4,48,0;Modules linked in:
4,49,0;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
4,50,0;REGS: c000000000c27ae0 TRAP: 0700   Not tainted  (3.5.0-rc4-mikey)
4,51,0;MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 24000042  XER: 22000000
4,52,0;SOFTE: 0
4,53,0;CFAR: c000000000740438
4,54,0;TASK = c000000000b2dd80[0] 'swapper/0' THREAD: c000000000c24000 CPU: 0\x0aGPR00: c000000000048160 c000000000c27d60 c000000000c24488 0000000000000026 \x0aGPR04: 0000000000000000 000000000000002e 30352c2000000000 0000000032320000 \x0aGPR08: 2920726500000000 c000000000b30e20 0000000000000020 000000000000002e \x0aGPR12: 0000000024000042 c00000000ff20000 0000000000000000 0000000000000000 \x0aGPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 \x0aGPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 \x0aGPR24: 0000000000000000 0000000000000000 0000000000000000 c000000000dd8080 \x0aGPR28: c000000000cb0628 0000000000000000 c000000000b70a28 0000000000000001 
4,55,0;NIP [c000000000048164] .xics_set_cpu_giq+0xb4/0xc0
4,56,0;LR [c000000000048160] .xics_set_cpu_giq+0xb0/0xc0
4,57,0;Call Trace:
4,58,0;[c000000000c27d60] [c000000000048160] .xics_set_cpu_giq+0xb0/0xc0 (unreliable)
4,59,0;[c000000000c27df0] [c000000000a75b90] .pseries_xics_init_IRQ+0x10/0x24
4,60,0;[c000000000c27e60] [c000000000a643cc] .init_IRQ+0x3c/0x54
4,61,0;[c000000000c27ee0] [c000000000a60804] .start_kernel+0x250/0x464
4,62,0;[c000000000c27f90] [c00000000000967c] .start_here_common+0x20/0x24
4,63,0;Instruction dump:
4,64,0;7fa4eb78 4bfddd49 60000000 2f830000 7c671b78 409cffa4 e87e8030 3880232d 
4,65,0;7fa5eb78 7fe6fb78 486f8289 60000000 <0fe00000> 4bffff84 60000000 7c0802a6 
4,66,0;---[ end trace 31fd0ba7d8756001 ]---
7,67,0;pic: no ISA interrupt controller
4,68,0;error: reading the clock failed (-1)
7,69,0;time_init: decrementer frequency = 59.375000 MHz
7,70,0;time_init: processor frequency   = 3800.000000 MHz
6,71,0;clocksource: timebase mult[86bca1b] shift[23] registered
7,72,0;clockevent: decrementer mult[f333333] shift[32] cpu[0]
6,73,0;Console: colour dummy device 80x25
6,74,0;console [tty0] enabled
6,75,0;console [hvc0] enabled
6,76,4785;pid_max: default: 32768 minimum: 301
6,77,5419;Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
6,78,14588;Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
6,79,19200;Mount-cache hash table entries: 4096
6,80,22334;Initializing cgroup subsys cpuacct
6,81,22418;Initializing cgroup subsys devices
6,82,22504;Initializing cgroup subsys freezer
6,83,23005;POWER7 performance monitor hardware support registered
6,84,24392;Firmware doesn't support query-cpu-stopped-state
4,85,24518;set-indicator(9005, 0, 1) returned -22
4,86,24534;------------[ cut here ]------------
4,87,24545;WARNING: at /scratch/mikey/src/linux-ozlabs/arch/powerpc/sysdev/xics/xics-common.c:105
4,88,24549;Modules linked in:
4,89,24565;NIP: c000000000048164 LR: c000000000048160 CTR: 0000000000000000
4,90,24579;REGS: c00000007e59fb50 TRAP: 0700   Tainted: G        W     (3.5.0-rc4-mikey)
4,91,24586;MSR: 9000000000021032 
4,92,24590;<
4,93,24594;SF
4,94,24599;,HV
4,95,24604;,ME
4,96,24609;,IR
4,97,24614;,DR
4,98,24619;,RI
4,99,24623;>
4,100,24631;  CR: 28000042  XER: 22000000
4,101,24637;SOFTE: 0
4,102,24643;CFAR: c000000000740438
4,103,24656;TASK = c00000007e56bb40[0] 'swapper/1' THREAD: c00000007e59c000
4,104,24661; CPU: 1
4,105,24667;\x0aGPR00: 
4,106,24673;c000000000048160 
4,107,24679;c00000007e59fdd0 
4,108,24685;c000000000c24488 
4,109,24691;0000000000000026 
4,110,24696;\x0aGPR04: 
4,111,24701;0000000000000000 
4,112,24707;0000000000000002 
4,113,24713;c000000000cd011c 
4,114,24719;302c203129207265 
4,115,24724;\x0aGPR08: 
4,116,24730;7475726e00000000 
4,117,24736;0000000000000000 
4,118,24741;0000000000000000 
4,119,24746;0000000000000000 
4,120,24752;\x0aGPR12: 
4,121,24758;0000000028000042 
4,122,24764;c00000000ff20380 
4,123,24770;c00000007e59ff90 
4,124,24775;0000000000000000 
4,125,24781;\x0aGPR16: 
4,126,24786;0000000000000000 
4,127,24792;0000000000000000 
4,128,24797;0000000000000000 
4,129,24802;0000000000000000 
4,130,24808;\x0aGPR20: 
4,131,24813;0000000000000000 
4,132,24818;0000000000000000 
4,133,24824;0000000000000000 
4,134,24829;0000000000000001 
4,135,24835;\x0aGPR24: 
4,136,24840;0000000000000001 
4,137,24845;0000000000000000 
4,138,24851;0000000000000000 
4,139,24856;0000000000000001 
4,140,24862;\x0aGPR28: 
4,141,24867;0000000000000008 
4,142,24872;0000000000000000 
4,143,24878;c000000000b70a28 
4,144,24884;0000000000000001 
4,145,24887;
4,146,24907;NIP [c000000000048164] .xics_set_cpu_giq+0xb4/0xc0
4,147,24927;LR [c000000000048160] .xics_set_cpu_giq+0xb0/0xc0
4,148,24931;Call Trace:
4,149,24953;[c00000007e59fdd0] [c000000000048160] .xics_set_cpu_giq+0xb0/0xc0
4,150,24957; (unreliable)
4,151,24961;
4,152,24986;[c00000007e59fe60] [c00000000076768c] .smp_xics_setup_cpu+0x28/0xbc
4,153,24989;
4,154,25013;[c00000007e59fee0] [c000000000764308] .start_secondary+0xc8/0x360
4,155,25017;
4,156,25040;[c00000007e59ff90] [c00000000000936c] .start_secondary_prolog+0x10/0x14
4,157,25043;
4,158,25048;Instruction dump:
4,159,25052;
4,160,25058;7fa4eb78 
4,161,25064;4bfddd49 
4,162,25070;60000000 
4,163,25076;2f830000 
4,164,25082;7c671b78 
4,165,25088;409cffa4 
4,166,25094;e87e8030 
4,167,25100;3880232d 
4,168,25104;
4,169,25110;7fa5eb78 
4,170,25116;7fe6fb78 
4,171,25122;486f8289 
4,172,25128;60000000 
4,173,25134;<0fe00000> 
4,174,25141;4bffff84 
4,175,25147;60000000 
4,176,25153;7c0802a6 
4,177,25156;
4,178,25164;---[ end trace 31fd0ba7d8756002 ]---
6,179,25465;Brought up 2 CPUs
7,180,29974;Node 0 CPUs: 0-1
6,181,30219;Enabling Asymmetric SMT scheduling
6,182,106522;NET: Registered protocol family 16
6,183,106731;IBM eBus Device Driver
4,184,107916;kworker/u:0 (16) used greatest stack depth: 12800 bytes left
6,185,120011;nvram: No room to create ibm,rtas-log partition, deleting any obsolete OS partitions...
3,186,120204;nvram: Failed to find or create ibm,rtas-log partition, err -28
6,187,120344;nvram: No room to create lnx,oops-log partition, deleting any obsolete OS partitions...
3,188,120536;nvram: Failed to find or create lnx,oops-log partition, err -28
6,189,120694;CPU Hotplug not supported by firmware - disabling.
6,190,126948;PCI: Probing PCI hardware
7,191,127017;PCI: Probing PCI hardware done
4,192,127028;opal: Node not found
6,193,296438;bio: create slab <bio-0> at 0
6,194,300573;vgaarb: loaded
5,195,303929;SCSI subsystem initialized
7,196,307408;libata version 3.00 loaded.
6,197,312421;usbcore: registered new interface driver usbfs
6,198,313151;usbcore: registered new interface driver hub
6,199,314645;usbcore: registered new device driver usb
6,200,322114;Switching to clocksource timebase
4,201,352608;kworker/u:0 (223) used greatest stack depth: 11168 bytes left
6,202,432888;NET: Registered protocol family 2
6,203,433315;IP route cache hash table entries: 16384 (order: 1, 131072 bytes)
6,204,434295;TCP established hash table entries: 65536 (order: 4, 1048576 bytes)
6,205,438160;TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
6,206,441363;TCP: Hash tables configured (established 65536 bind 65536)
6,207,441491;TCP: reno registered
6,208,441565;UDP hash table entries: 2048 (order: 0, 65536 bytes)
6,209,441978;UDP-Lite hash table entries: 2048 (order: 0, 65536 bytes)
6,210,442727;NET: Registered protocol family 1
6,211,443753;RPC: Registered named UNIX socket transport module.
6,212,443869;RPC: Registered udp transport module.
6,213,443958;RPC: Registered tcp transport module.
6,214,444049;RPC: Registered tcp NFSv4.1 backchannel transport module.
7,215,444178;PCI: CLS 0 bytes, default 128
6,216,444401;Trying to unpack rootfs image as initramfs...
6,217,2011859;Freeing initrd memory: 146368k freed
6,218,2019359;rtasd: No event-scan on system
6,219,2020743;Hypercall H_BEST_ENERGY not supported
6,220,2025601;audit: initializing netlink socket (disabled)
5,221,2025727;type=2000 audit(2.020:1): initialized
6,222,2992853;HugeTLB registered 1 MB page size, pre-allocated 0 pages
6,223,2992982;HugeTLB registered 16 MB page size, pre-allocated 0 pages
6,224,2993112;HugeTLB registered 16 GB page size, pre-allocated 0 pages
5,225,3109094;NFS: Registering the id_resolver key type
5,226,3109219;Key type id_resolver registered
6,227,3112591;msgmni has been set to 4028
6,228,3117312;Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
6,229,3117460;io scheduler noop registered
6,230,3117534;io scheduler deadline registered
6,231,3118446;io scheduler cfq registered (default)
6,232,3692669;Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
6,233,3703393;Generic RTC Driver v1.07
6,234,3748115;brd: module loaded
6,235,3770441;loop: module loaded
6,236,3770496;Uniform Multi-Platform E-IDE driver
6,237,3774960;ide-gd driver 1.18
6,238,3776029;ide-cd driver 5.00
6,239,3787095;ipr: IBM Power RAID SCSI Device Driver version: 2.5.3 (March 10, 2012)
6,240,3788311;st: Version 20101219, fixed bufsize 32768, s/g segs 256
6,241,3796157;pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
7,242,3798393;ibmveth: IBM Power Virtual Ethernet Driver 1.04
6,243,3799456;ehea: IBM eHEA ethernet device driver (Release EHEA_0107)
6,244,3801948;e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
6,245,3802068;e100: Copyright(c) 1999-2006 Intel Corporation
6,246,3803197;e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
6,247,3803337;e1000: Copyright (c) 1999-2006 Intel Corporation.
6,248,3804513;e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
6,249,3804625;e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
6,250,3805823;ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
6,251,3807019;ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
6,252,3809276;mousedev: PS/2 mouse device common for all mice
6,253,3812135;md: linear personality registered for level -1
6,254,3812243;md: raid0 personality registered for level 0
6,255,3812348;md: raid1 personality registered for level 1
6,256,3814922;device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
6,257,3815091;cpuidle: using governor ladder
6,258,3815168;cpuidle: using governor menu
6,259,3837236;usbcore: registered new interface driver usbhid
6,260,3837342;usbhid: USB HID core driver
7,261,3837414;oprofile: using ppc64/power7 performance monitoring.
6,262,3837813;IPv4 over IPv4 tunneling driver
6,263,3841830;TCP: cubic registered
6,264,3841891;NET: Registered protocol family 17
5,265,3842089;Key type dns_resolver registered
7,266,3842319;Running code patching self-tests ...
7,267,3846278;Running feature fixup self-tests ...
7,268,3846308;Running MSI bitmap self-tests ...
6,269,3875364;registered taskstats version 1
6,270,3876407;console [netcon0] enabled
6,271,3876473;netconsole: network logging started
6,272,3877574;Freeing unused kernel memory: 576k freed
4,273,3889441;modprobe (1071) used greatest stack depth: 11120 bytes left
4,274,4403534;udevd (1108) used greatest stack depth: 10528 bytes left
4,275,4416293;tput (1111) used greatest stack depth: 10464 bytes left
4,276,4777038;blkid (1149) used greatest stack depth: 10288 bytes left
4,277,6012331;fsck (1224) used greatest stack depth: 10224 bytes left
4,278,7298006;run-parts (1346) used greatest stack depth: 9968 bytes left
4,279,9235784;sshd (1497): /proc/1497/oom_adj is deprecated, please use /proc/1497/oom_score_adj instead.


