Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1HZXzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:55:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48580 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1HZXzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:55:10 -0400
Date: Fri, 26 Aug 2011 16:55:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110826235507.GJ2342@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313232790.25267.7.camel@twins>
 <4E559039.8060209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E559039.8060209@am.sony.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 04:58:49PM -0700, Frank Rowand wrote:
> On 08/13/11 03:53, Peter Zijlstra wrote:
> > 
> > Whee, I can skip release announcements too!
> > 
> > So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> > grabs.
> > 
> > Changes include (including the missing -rt10):
> > 
> >   - hrtimer fix that should make RT_GROUP work again
> >   - RCU fixes that should make the RCU stalls go away
> >   - fixes SMP=n builds after breaking them in -rt9
> 
> I have a consistent (every boot) hang on boot.  With a few
> hacks to get console output, I get the
> 
>   rcu_preempt_state detected stalls on CPUs/tasks
> 
> messages in the attached console log.
> 
> 
> The hacks are the attached patches.
> 
>    zzz_allow_console_trylock_for_sysrq
>      Allows printk() to spew messages when it would otherwise
>      be delayed, if oops_in_progress is true.
> 
>    zzz-turn-on-oops_in_progress
>      Initializes oops_in_progress to 1 so that the boot
>      printk()s and the rcu stall messages can spew forth.
> 
>    zzz-add-arm-arch_trigger_all_cpu_backtrace
>      Prints the stack traces for each cpu when the rcu stalls
>      are detected.  ARM does not have an NMI, so I used an
>      IPI to trigger the stack trace on each cpu.  I think this
>      is the reason I get a second rcu stall message immediately
>      after the first one (at time 63.194937).
> 
> This is an ARM NaviEngine (out of tree, so I also have applied
> a series of pages for platform support).
> 
> CONFIG_PREEMPT_RT_FULL is set.  Full config is attached.

Hmmm...  The last few that I have seen that looked like this were
due to my messing up rcutorture so that the RCU-boost testing kthreads
ran CPU-bound at real-time priority.

Is it possible that something similar is happening on your system?

							Thanx, Paul

> -Frank

> Starting kernel ...
> 
> [    0.000000] Linux version 3.0.1-rt11 (frowand@crest.am.sony.com) (gcc version 4.3.3 (20100210 (Sony CE Linu
> x 6.0.0.3)) ) #3 SMP PREEMPT RT Wed Aug 24 16:13:07 PDT 2011
> [    0.000000] CPU: ARMv6-compatible processor [410fb024] revision 4 (ARMv7), cr=08c5387f
> [    0.000000] CPU: VIPT nonaliasing data cache, VIPT aliasing instruction cache
> [    0.000000] Machine: NE1
> [    0.000000] bootconsole [earlycon0] enabled
> [    0.000000] Memory policy: ECC disabled, Data cache writealloc
> [    0.000000] On node 0 totalpages: 65536
> [    0.000000]   Normal zone: 512 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 65024 pages, LIFO batch:15
> [    0.000000] PERCPU: Embedded 7 pages/cpu @c0795000 s5952 r8192 d14528 u32768
> [    0.000000] pcpu-alloc: s5952 r8192 d14528 u32768 alloc=8*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
> [    0.000000] Kernel command line: root=/dev/nfs ip=dhcp mem=256M console=ttyS0,38400 debug earlyprintk
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Memory: 256MB = 256MB total
> [    0.000000] Memory: 254044k/254044k available, 8100k reserved, 0K highmem
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
> [    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
> [    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
> [    0.000000]     vmalloc : 0xd0800000 - 0xd8000000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
> [    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
> [    0.000000]       .init : 0xc0008000 - 0xc002d000   ( 148 kB)
> [    0.000000]       .text : 0xc002d000 - 0xc0532850   (5143 kB)
> [    0.000000]       .data : 0xc0534000 - 0xc05643a0   ( 193 kB)
> [    0.000000]        .bss : 0xc05643c4 - 0xc058ecb0   ( 171 kB)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] NR_IRQS:160
> [    0.000000] Console: colour dummy device 80x30
> [    0.015761] Calibrating delay loop... 159.12 BogoMIPS (lpj=795648)
> [    0.108331] pid_max: default: 32768 minimum: 301
> [    0.124855] Mount-cache hash table entries: 512
> [    0.143515] CPU: Testing write buffer coherency: ok
> [    0.159647] Calibrating local timer... 200.28MHz.
> [    0.375128] CPU1: Booted secondary processor
> [    0.515354] CPU2: Booted secondary processor
> [    0.655646] CPU3: Booted secondary processor
> [    0.735126] Brought up 4 CPUs
> [    0.783688] SMP: Total of 4 processors activated (636.51 BogoMIPS).
> [    0.867546] NET: Registered protocol family 16
> [    1.080315] bio: create slab <bio-0> at 0
> [    1.099109] vgaarb: loaded
> [    1.116359] SCSI subsystem initialized
> [    1.135925] usbcore: registered new interface driver usbfs
> [    1.156031] usbcore: registered new interface driver hub
> [    1.174391] usbcore: registered new device driver usb
> [    1.202955] Switching to clocksource timer1
> [    1.364172] NET: Registered protocol family 2
> [    1.379005] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    1.404046] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> [    1.426965] TCP bind hash table entries: 8192 (order: 6, 360448 bytes)
> [    1.450289] TCP: Hash tables configured (established 8192 bind 8192)
> [    1.469812] TCP reno registered
> [    1.479744] UDP hash table entries: 128 (order: 1, 12288 bytes)
> [    1.498342] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
> [    1.520823] NET: Registered protocol family 1
> [    1.538754] RPC: Registered named UNIX socket transport module.
> [    1.557050] RPC: Registered udp transport module.
> [    1.571638] RPC: Registered tcp transport module.
> [    1.586283] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    1.606169] PCI: CLS 0 bytes, default 32
> [    1.619072] NetWinder Floating Point Emulator V0.97 (double precision)
> [    1.684143] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    1.713966] fuse init (API version 7.16)
> [    1.729216] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [    1.766872] SGI XFS Quota Management subsystem
> [    1.780960] msgmni has been set to 496
> [    1.797308] io scheduler noop registered
> [    1.809553] io scheduler deadline registered (default)
> [    1.890583] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [   60.921691] INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 2} (detected by 1, t=6004 jiffies)
> [   60.950273] sending IPI to all CPUs:
> [   60.961291] IPI backtrace for cpu 2
> [   60.972045] regs 0xcf87bf60
> [   60.980695] 
> [   60.985441] Pid: 0, comm:              swapper
> [   60.999055] CPU: 2    Not tainted  (3.0.1-rt11 #3)
> [   61.013732] PC is at default_idle+0x28/0x2c
> [   61.026563] LR is at default_idle+0x24/0x2c
> [   61.039398] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [   61.039420] sp : cf87bfa8  ip : cf87bfb8  fp : cf87bfb4
> [   61.074410] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   61.090366] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf87a000
> [   61.110229] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000002
> [   61.130098] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   61.152314] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [   61.169874] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   61.193393]  r4:c0564628
> [   61.201328] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   61.224583] Exception stack(0xcf87bf60 to 0xcf87bfa8)
> [   61.240037] bf60: 00000002 00000000 c05403fc 00000000 cf87a000 00000000 c0543df0 c0564488
> [   61.264873] bf80: c03d05b4 410fb024 804c49f0 cf87bfb4 cf87bfb8 cf87bfa8 c0039fb8 c0039fbc
> [   61.289694] bfa0: 60000113 ffffffff
> [   61.300435]  r8:00000001 r7:00000002 r6:00000407 r5:fc000100 r4:ffffffff
> [   61.321047] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   61.345374] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [   61.372798]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000002 r4:c0549650
> [   61.393411] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [   61.418487]  r5:0000001f r4:8f88000a
> [   61.429589] IPI backtrace for cpu 3
> [   61.440348] regs 0xcf88bf60
> [   61.448997] 
> [   61.453742] Pid: 0, comm:              swapper
> [   61.467354] CPU: 3    Not tainted  (3.0.1-rt11 #3)
> [   61.482021] PC is at default_idle+0x28/0x2c
> [   61.494857] LR is at default_idle+0x24/0x2c
> [   61.507695] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [   61.507718] sp : cf88bfa8  ip : cf88bfb8  fp : cf88bfb4
> [   61.542715] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   61.558673] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf88a000
> [   61.578539] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000003
> [   61.598407] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   61.620622] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [   61.638169] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   61.661685]  r4:c0564628
> [   61.669618] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   61.692875] Exception stack(0xcf88bf60 to 0xcf88bfa8)
> [   61.708330] bf60: 00000003 00000000 c05403fc 00000000 cf88a000 00000000 c0543df0 c0564488
> [   61.733168] bf80: c03d05b4 410fb024 804c49f0 cf88bfb4 cf88bfb8 cf88bfa8 c0039fb8 c0039fbc
> [   61.757991] bfa0: 60000113 ffffffff
> [   61.768734]  r8:00000001 r7:00000002 r6:00000407 r5:fc000100 r4:ffffffff
> [   61.789351] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   61.813670] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [   61.841094]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000003 r4:c0549650
> [   61.861709] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [   61.886787]  r5:0000001f r4:8f89000a
> [   61.897894] IPI backtrace for cpu 0
> [   61.908664] regs 0xc0535f30
> [   61.917319] 
> [   61.922066] Pid: 0, comm:              swapper
> [   61.935683] CPU: 0    Not tainted  (3.0.1-rt11 #3)
> [   61.950354] PC is at default_idle+0x28/0x2c
> [   61.963192] LR is at default_idle+0x24/0x2c
> [   61.976031] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [   61.976054] sp : c0535f78  ip : c0535f88  fp : c0535f84
> [   62.011050] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   62.027008] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : c0534000
> [   62.046875] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000000
> [   62.066743] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   62.088959] Control: 08c5787d  Table: 8000400a  DAC: 00000017
> [   62.106507] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   62.130025]  r4:c0564628
> [   62.137959] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   62.161218] Exception stack(0xc0535f30 to 0xc0535f78)
> [   62.176663] 5f20:                                     00000000 00000000 c05403fc 00000000
> [   62.201502] 5f40: c0534000 00000000 c0543df0 c0564488 c03d05b4 410fb024 804c49f0 c0535f84
> [   62.226334] 5f60: c0535f88 c0535f78 c0039fb8 c0039fbc 60000013 ffffffff
> [   62.246459]  r8:00000001 r7:00000002 r6:00000407 r5:fc000100 r4:ffffffff
> [   62.267077] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   62.291408] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c1e90>] (rest_init+0x74/0x8c)
> [   62.314924]  r8:8000400a r7:c05643e0 r6:00000001 r5:c0027084 r4:00000002
> [   62.335543] [<c03c1e1c>] (rest_init+0x0/0x8c) from [<c0008a00>] (start_kernel+0x250/0x2a4)
> [   62.360623]  r4:c0540460
> [   62.368551] [<c00087b0>] (start_kernel+0x0/0x2a4) from [<80008040>] (0x80008040)
> [   62.391025]  r7:c0543de4 r6:c0027488 r5:c0540334 r4:08c5387d
> [   62.408669] IPI backtrace for cpu 1
> [   62.419412] regs 0xcf85ff60
> [   62.428062] 
> [   62.432810] Pid: 0, comm:              swapper
> [   62.446425] CPU: 1    Not tainted  (3.0.1-rt11 #3)
> [   62.461092] PC is at default_idle+0x28/0x2c
> [   62.473927] LR is at default_idle+0x24/0x2c
> [   62.486766] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [   62.486790] sp : cf85ffa8  ip : cf85ffb8  fp : cf85ffb4
> [   62.521787] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   62.537747] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf85e000
> [   62.557614] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000001
> [   62.577482] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   62.599701] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [   62.617251] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   62.640769]  r4:c0564628
> [   62.648703] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   62.671960] Exception stack(0xcf85ff60 to 0xcf85ffa8)
> [   62.687414] ff60: 00000001 00000000 c05403fc 00000000 cf85e000 00000000 c0543df0 c0564488
> [   62.712252] ff80: c03d05b4 410fb024 804c49f0 cf85ffb4 cf85ffb8 cf85ffa8 c0039fb8 c0039fbc
> [   62.737073] ffa0: 60000013 ffffffff
> [   62.747815]  r8:00000001 r7:00000002 r6:00000407 r5:fc000100 r4:ffffffff
> [   62.768438] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   62.792757] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [   62.820180]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000001 r4:c0549650
> [   62.840799] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [   62.865875]  r5:0000001f r4:8f86400a
> [   63.194937] INFO: rcu_sched_state detected stall on CPU 2 (t=6000 jiffies)
> [   63.213975] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 2} (detected by 0, t=6002 jiffies)
> [   63.214052] sending IPI to all CPUs:
> [   63.214104] IPI backtrace for cpu 1
> [   63.214137] regs 0xcf85ff60
> [   63.214153] 
> [   63.214173] Pid: 0, comm:              swapper
> [   63.214206] CPU: 1    Not tainted  (3.0.1-rt11 #3)
> [   63.214246] PC is at default_idle+0x28/0x2c
> [   63.214278] LR is at default_idle+0x24/0x2c
> [   63.214315] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [   63.214337] sp : cf85ffa8  ip : cf85ffb8  fp : cf85ffb4
> [   63.214368] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   63.214400] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf85e000
> [   63.214435] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000001
> [   63.214472] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   63.214510] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [   63.214566] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   63.214607]  r4:c0564628
> [   63.214653] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   63.214691] Exception stack(0xcf85ff60 to 0xcf85ffa8)
> [   63.214741] ff60: 00000001 00000000 c05403fc 00000000 cf85e000 00000000 c0543df0 c0564488
> [   63.214800] ff80: c03d05b4 410fb024 804c49f0 cf85ffb4 cf85ffb8 cf85ffa8 c0039fb8 c0039fbc
> [   63.214842] ffa0: 60000013 ffffffff
> [   63.214868]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [   63.214953] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   63.215012] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [   63.215053]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000001 r4:c0549650
> [   63.215137] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [   63.215175]  r5:0000001f r4:8f86400a
> [   63.215228] IPI backtrace for cpu 3
> [   63.215263] regs 0xcf88bf60
> [   63.215283] 
> [   63.215306] Pid: 0, comm:              swapper
> [   63.215340] CPU: 3    Not tainted  (3.0.1-rt11 #3)
> [   63.215383] PC is at default_idle+0x28/0x2c
> [   63.215418] LR is at default_idle+0x24/0x2c
> [   63.215459] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [   63.215482] sp : cf88bfa8  ip : cf88bfb8  fp : cf88bfb4
> [   63.215516] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   63.215552] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf88a000
> [   63.215591] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000003
> [   63.215632] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   63.215677] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [   63.215741] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   63.215786]  r4:c0564628
> [   63.215837] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   63.215883] Exception stack(0xcf88bf60 to 0xcf88bfa8)
> [   63.215939] bf60: 00000003 00000000 c05403fc 00000000 cf88a000 00000000 c0543df0 c0564488
> [   63.216003] bf80: c03d05b4 410fb024 804c49f0 cf88bfb4 cf88bfb8 cf88bfa8 c0039fb8 c0039fbc
> [   63.216049] bfa0: 60000113 ffffffff
> [   63.216079]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [   63.216176] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   63.216239] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [   63.216282]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000003 r4:c0549650
> [   63.216378] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [   63.216419]  r5:0000001f r4:8f89000a
> [   64.187562] IPI backtrace for cpu 2
> [   64.198303] regs 0xcf87bf60
> [   64.206951] 
> [   64.211694] Pid: 0, comm:              swapper
> [   64.225304] CPU: 2    Not tainted  (3.0.1-rt11 #3)
> [   64.239963] PC is at default_idle+0x28/0x2c
> [   64.252797] LR is at default_idle+0x24/0x2c
> [   64.265634] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [   64.265658] sp : cf87bfa8  ip : cf87bfb8  fp : cf87bfb4
> [   64.300652] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   64.316609] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf87a000
> [   64.336474] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000002
> [   64.356342] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   64.378557] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [   64.396101] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   64.419616]  r4:c0564628
> [   64.427547] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   64.450802] Exception stack(0xcf87bf60 to 0xcf87bfa8)
> [   64.466256] bf60: 00000002 00000000 c05403fc 00000000 cf87a000 00000000 c0543df0 c0564488
> [   64.491093] bf80: c03d05b4 410fb024 804c49f0 cf87bfb4 cf87bfb8 cf87bfa8 c0039fb8 c0039fbc
> [   64.515913] bfa0: 60000113 ffffffff
> [   64.526654]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [   64.547271] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   64.571591] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [   64.599016]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000002 r4:c0549650
> [   64.619631] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [   64.644709]  r5:0000001f r4:8f88000a
> [   64.656495] IPI backtrace for cpu 0
> [   64.667247] regs 0xc0535f30
> [   64.675901] 
> [   64.680650] Pid: 0, comm:              swapper
> [   64.694269] CPU: 0    Not tainted  (3.0.1-rt11 #3)
> [   64.708941] PC is at default_idle+0x28/0x2c
> [   64.721778] LR is at default_idle+0x24/0x2c
> [   64.734616] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [   64.734642] sp : c0535f78  ip : c0535f88  fp : c0535f84
> [   64.769638] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [   64.785601] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : c0534000
> [   64.805472] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000000
> [   64.825343] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   64.847562] Control: 08c5787d  Table: 8000400a  DAC: 00000017
> [   64.865110] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [   64.888627]  r4:c0564628
> [   64.896559] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [   64.919817] Exception stack(0xc0535f30 to 0xc0535f78)
> [   64.935263] 5f20:                                     00000000 00000000 c05403fc 00000000
> [   64.960103] 5f40: c0534000 00000000 c0543df0 c0564488 c03d05b4 410fb024 804c49f0 c0535f84
> [   64.984936] 5f60: c0535f88 c0535f78 c0039fb8 c0039fbc 60000013 ffffffff
> [   65.005063]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [   65.025680] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [   65.050005] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c1e90>] (rest_init+0x74/0x8c)
> [   65.073519]  r8:8000400a r7:c05643e0 r6:00000001 r5:c0027084 r4:00000002
> [   65.094142] [<c03c1e1c>] (rest_init+0x0/0x8c) from [<c0008a00>] (start_kernel+0x250/0x2a4)
> [   65.119220]  r4:c0540460
> [   65.127150] [<c00087b0>] (start_kernel+0x0/0x2a4) from [<80008040>] (0x80008040)
> [   65.149625]  r7:c0543de4 r6:c0027488 r5:c0540334 r4:08c5387d
> [  244.873199] INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 2} (detected by 0, t=24034 jiffies)
> [  244.902039] sending IPI to all CPUs:
> [  244.913047] IPI backtrace for cpu 2
> [  244.923793] regs 0xcf87bf60
> [  244.932443] 
> [  244.937186] Pid: 0, comm:              swapper
> [  244.950798] CPU: 2    Not tainted  (3.0.1-rt11 #3)
> [  244.965458] PC is at default_idle+0x28/0x2c
> [  244.978292] LR is at default_idle+0x24/0x2c
> [  244.991131] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [  244.991156] sp : cf87bfa8  ip : cf87bfb8  fp : cf87bfb4
> [  245.026150] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  245.042107] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf87a000
> [  245.061973] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000002
> [  245.081838] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  245.104053] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [  245.121598] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  245.145114]  r4:c0564628
> [  245.153045] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  245.176299] Exception stack(0xcf87bf60 to 0xcf87bfa8)
> [  245.191756] bf60: 00000002 00000000 c05403fc 00000000 cf87a000 00000000 c0543df0 c0564488
> [  245.216596] bf80: c03d05b4 410fb024 804c49f0 cf87bfb4 cf87bfb8 cf87bfa8 c0039fb8 c0039fbc
> [  245.241419] bfa0: 60000113 ffffffff
> [  245.252162]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  245.272777] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  245.297098] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [  245.324522]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000002 r4:c0549650
> [  245.345133] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [  245.370212]  r5:0000001f r4:8f88000a
> [  245.381311] IPI backtrace for cpu 1
> [  245.392071] regs 0xcf85ff60
> [  245.400724] 
> [  245.405475] Pid: 0, comm:              swapper
> [  245.419093] CPU: 1    Not tainted  (3.0.1-rt11 #3)
> [  245.433761] PC is at default_idle+0x28/0x2c
> [  245.446595] LR is at default_idle+0x24/0x2c
> [  245.459436] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [  245.459458] sp : cf85ffa8  ip : cf85ffb8  fp : cf85ffb4
> [  245.494458] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  245.510418] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf85e000
> [  245.530287] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000001
> [  245.550154] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  245.572369] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [  245.589917] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  245.613431]  r4:c0564628
> [  245.621360] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  245.644615] Exception stack(0xcf85ff60 to 0xcf85ffa8)
> [  245.660067] ff60: 00000001 00000000 c05403fc 00000000 cf85e000 00000000 c0543df0 c0564488
> [  245.684906] ff80: c03d05b4 410fb024 804c49f0 cf85ffb4 cf85ffb8 cf85ffa8 c0039fb8 c0039fbc
> [  245.709728] ffa0: 60000013 ffffffff
> [  245.720469]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  245.741081] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  245.765397] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [  245.792819]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000001 r4:c0549650
> [  245.813431] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [  245.838507]  r5:0000001f r4:8f86400a
> [  245.849607] IPI backtrace for cpu 3
> [  245.860366] regs 0xcf88bf60
> [  245.869018] 
> [  245.873766] Pid: 0, comm:              swapper
> [  245.887381] CPU: 3    Not tainted  (3.0.1-rt11 #3)
> [  245.902047] PC is at default_idle+0x28/0x2c
> [  245.914881] LR is at default_idle+0x24/0x2c
> [  245.927720] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [  245.927744] sp : cf88bfa8  ip : cf88bfb8  fp : cf88bfb4
> [  245.962740] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  245.978699] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf88a000
> [  245.998566] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000003
> [  246.018436] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  246.040653] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [  246.058198] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  246.081716]  r4:c0564628
> [  246.089649] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  246.112908] Exception stack(0xcf88bf60 to 0xcf88bfa8)
> [  246.128362] bf60: 00000003 00000000 c05403fc 00000000 cf88a000 00000000 c0543df0 c0564488
> [  246.153201] bf80: c03d05b4 410fb024 804c49f0 cf88bfb4 cf88bfb8 cf88bfa8 c0039fb8 c0039fbc
> [  246.178024] bfa0: 60000113 ffffffff
> [  246.188767]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  246.209389] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  246.233707] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [  246.261132]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000003 r4:c0549650
> [  246.281753] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [  246.306832]  r5:0000001f r4:8f89000a
> [  246.318648] IPI backtrace for cpu 0
> [  246.329395] regs 0xc0535f30
> [  246.338047] 
> [  246.342793] Pid: 0, comm:              swapper
> [  246.356410] CPU: 0    Not tainted  (3.0.1-rt11 #3)
> [  246.371076] PC is at default_idle+0x28/0x2c
> [  246.383908] LR is at default_idle+0x24/0x2c
> [  246.396748] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [  246.396772] sp : c0535f78  ip : c0535f88  fp : c0535f84
> [  246.431769] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  246.447730] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : c0534000
> [  246.467599] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000000
> [  246.487470] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  246.509689] Control: 08c5787d  Table: 8000400a  DAC: 00000017
> [  246.527240] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  246.550760]  r4:c0564628
> [  246.558696] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  246.581955] Exception stack(0xc0535f30 to 0xc0535f78)
> [  246.597402] 5f20:                                     00000000 00000000 c05403fc 00000000
> [  246.622242] 5f40: c0534000 00000000 c0543df0 c0564488 c03d05b4 410fb024 804c49f0 c0535f84
> [  246.647076] 5f60: c0535f88 c0535f78 c0039fb8 c0039fbc 60000013 ffffffff
> [  246.667204]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  246.687828] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  246.712157] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c1e90>] (rest_init+0x74/0x8c)
> [  246.735672]  r8:8000400a r7:c05643e0 r6:00000001 r5:c0027084 r4:00000002
> [  246.756299] [<c03c1e1c>] (rest_init+0x0/0x8c) from [<c0008a00>] (start_kernel+0x250/0x2a4)
> [  246.781379]  r4:c0540460
> [  246.789311] [<c00087b0>] (start_kernel+0x0/0x2a4) from [<80008040>] (0x80008040)
> [  246.811785]  r7:c0543de4 r6:c0027488 r5:c0540334 r4:08c5387d
> [  247.658158] INFO: rcu_sched_state detected stall on CPU 2 (t=24032 jiffies)
> [  247.677192] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 2} (detected by 0, t=24034 jiffies)
> [  247.677269] sending IPI to all CPUs:
> [  247.677311] IPI backtrace for cpu 1
> [  247.677343] regs 0xcf85ff60
> [  247.677362] 
> [  247.677387] Pid: 0, comm:              swapper
> [  247.677425] CPU: 1    Not tainted  (3.0.1-rt11 #3)
> [  247.677466] PC is at default_idle+0x28/0x2c
> [  247.677502] LR is at default_idle+0x24/0x2c
> [  247.677544] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [  247.677566] sp : cf85ffa8  ip : cf85ffb8  fp : cf85ffb4
> [  247.677600] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  247.677636] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf85e000
> [  247.677674] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000001
> [  247.677715] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  247.677759] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [  247.677817] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  247.677857]  r4:c0564628
> [  247.677904] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  247.677945] Exception stack(0xcf85ff60 to 0xcf85ffa8)
> [  247.677997] ff60: 00000001 00000000 c05403fc 00000000 cf85e000 00000000 c0543df0 c0564488
> [  247.678060] ff80: c03d05b4 410fb024 804c49f0 cf85ffb4 cf85ffb8 cf85ffa8 c0039fb8 c0039fbc
> [  247.678106] ffa0: 60000013 ffffffff
> [  247.678133]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  247.678224] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  247.678282] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [  247.678322]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000001 r4:c0549650
> [  247.678412] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [  247.678450]  r5:0000001f r4:8f86400a
> [  247.678505] IPI backtrace for cpu 3
> [  247.678540] regs 0xcf88bf60
> [  247.678560] 
> [  247.678581] Pid: 0, comm:              swapper
> [  247.678614] CPU: 3    Not tainted  (3.0.1-rt11 #3)
> [  247.678656] PC is at default_idle+0x28/0x2c
> [  247.678690] LR is at default_idle+0x24/0x2c
> [  247.678729] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [  247.678751] sp : cf88bfa8  ip : cf88bfb8  fp : cf88bfb4
> [  247.678783] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  247.678817] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf88a000
> [  247.678854] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000003
> [  247.678891] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  247.678932] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [  247.678991] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  247.679030]  r4:c0564628
> [  247.679076] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  247.679117] Exception stack(0xcf88bf60 to 0xcf88bfa8)
> [  247.679169] bf60: 00000003 00000000 c05403fc 00000000 cf88a000 00000000 c0543df0 c0564488
> [  247.679230] bf80: c03d05b4 410fb024 804c49f0 cf88bfb4 cf88bfb8 cf88bfa8 c0039fb8 c0039fbc
> [  247.679276] bfa0: 60000113 ffffffff
> [  247.679303]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  247.679395] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  247.679452] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [  247.679492]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000003 r4:c0549650
> [  247.679582] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [  247.679619]  r5:0000001f r4:8f89000a
> [  248.651316] IPI backtrace for cpu 2
> [  248.662055] regs 0xcf87bf60
> [  248.670703] 
> [  248.675446] Pid: 0, comm:              swapper
> [  248.689055] CPU: 2    Not tainted  (3.0.1-rt11 #3)
> [  248.703713] PC is at default_idle+0x28/0x2c
> [  248.716546] LR is at default_idle+0x24/0x2c
> [  248.729383] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000113
> [  248.729405] sp : cf87bfa8  ip : cf87bfb8  fp : cf87bfb4
> [  248.764397] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  248.780354] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : cf87a000
> [  248.800220] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000002
> [  248.820085] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  248.842300] Control: 08c5787f  Table: 8000400a  DAC: 00000017
> [  248.859843] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  248.883358]  r4:c0564628
> [  248.891287] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  248.914541] Exception stack(0xcf87bf60 to 0xcf87bfa8)
> [  248.929995] bf60: 00000002 00000000 c05403fc 00000000 cf87a000 00000000 c0543df0 c0564488
> [  248.954833] bf80: c03d05b4 410fb024 804c49f0 cf87bfb4 cf87bfb8 cf87bfa8 c0039fb8 c0039fbc
> [  248.979653] bfa0: 60000113 ffffffff
> [  248.990394]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  249.011007] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  249.035324] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c8fe0>] (secondary_start_kernel+0x118/0x134)
> [  249.062746]  r8:8000400a r7:c0564620 r6:00c0387d r5:00000002 r4:c0549650
> [  249.083358] [<c03c8ec8>] (secondary_start_kernel+0x0/0x134) from [<803c8b74>] (0x803c8b74)
> [  249.108432]  r5:0000001f r4:8f88000a
> [  249.119712] IPI backtrace for cpu 0
> [  249.130460] regs 0xc0535f30
> [  249.139108] 
> [  249.143853] Pid: 0, comm:              swapper
> [  249.157465] CPU: 0    Not tainted  (3.0.1-rt11 #3)
> [  249.172127] PC is at default_idle+0x28/0x2c
> [  249.184960] LR is at default_idle+0x24/0x2c
> [  249.197797] pc : [<c0039fbc>]    lr : [<c0039fb8>]    psr: 60000013
> [  249.197819] sp : c0535f78  ip : c0535f88  fp : c0535f84
> [  249.232812] r10: 804c49f0  r9 : 410fb024  r8 : c03d05b4
> [  249.248769] r7 : c0564488  r6 : c0543df0  r5 : 00000000  r4 : c0534000
> [  249.268635] r3 : 00000000  r2 : c05403fc  r1 : 00000000  r0 : 00000000
> [  249.288503] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  249.310718] Control: 08c5787d  Table: 8000400a  DAC: 00000017
> [  249.328264] [<c003a4cc>] (show_regs+0x0/0x50) from [<c002d39c>] (do_IPI+0x16c/0x1e8)
> [  249.351780]  r4:c0564628
> [  249.359716] [<c002d230>] (do_IPI+0x0/0x1e8) from [<c00389ec>] (__irq_svc+0x4c/0xe8)
> [  249.382972] Exception stack(0xc0535f30 to 0xc0535f78)
> [  249.398417] 5f20:                                     00000000 00000000 c05403fc 00000000
> [  249.423255] 5f40: c0534000 00000000 c0543df0 c0564488 c03d05b4 410fb024 804c49f0 c0535f84
> [  249.448088] 5f60: c0535f88 c0535f78 c0039fb8 c0039fbc 60000013 ffffffff
> [  249.468214]  r8:00000001 r7:00000002 r6:00000007 r5:fc000100 r4:ffffffff
> [  249.488839] [<c0039f94>] (default_idle+0x0/0x2c) from [<c003a630>] (cpu_idle+0x84/0xc4)
> [  249.513160] [<c003a5ac>] (cpu_idle+0x0/0xc4) from [<c03c1e90>] (rest_init+0x74/0x8c)
> [  249.536674]  r8:8000400a r7:c05643e0 r6:00000001 r5:c0027084 r4:00000002
> [  249.557300] [<c03c1e1c>] (rest_init+0x0/0x8c) from [<c0008a00>] (start_kernel+0x250/0x2a4)
> [  249.582378]  r4:c0540460
> [  249.590310] [<c00087b0>] (start_kernel+0x0/0x2a4) from [<80008040>] (0x80008040)
> [  249.612782]  r7:c0543de4 r6:c0027488 r5:c0540334 r4:08c5387d

> 
> WARNING: this is a hack to support debugging.
> 
> 
> For CONFIG_PREEMPT_RT_FULL console_trylock_for_printk() will not attempt to
> lock the console if:
>    !early_boot_irqs_disabled && !irqs_disabled_flags(flags) && !preempt_count()
> thus vprintk() will not print out the buffers.
> 
> Allow console_trylock_for_printk() attempt to lock the console if
> sysrq_in_progress.
> 
> This hack patch sets oops_in_progress so that sysrq output can maybe get
> delivered to the console without delay.
> 
> 
> Using oops_in_progress is important because that also affects the locking
> methods used by the serial driver.
> 
> 
> ---
>  kernel/printk.c |    5 	3 +	2 -	0 !
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: b/kernel/printk.c
> ===================================================================
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -824,8 +824,9 @@ static int console_trylock_for_printk(un
>  	__releases(&logbuf_lock)
>  {
>  #ifdef CONFIG_PREEMPT_RT_FULL
> -	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
> -		!preempt_count();
> +	int lock = oops_in_progress ||
> +		(!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
> +		!preempt_count());
>  #else
>  	int lock = 1;
>  #endif
> ---
>  drivers/tty/sysrq.c |    3 	3 +	0 -	0 !
>  1 file changed, 3 insertions(+)
> 
> Index: b/drivers/tty/sysrq.c
> ===================================================================
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -499,6 +499,8 @@ void __handle_sysrq(int key, bool check_
>  	int i;
>  	unsigned long flags;
>  
> +int save_oops_in_progress = oops_in_progress;
> +oops_in_progress = 1;
>  	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>  	/*
>  	 * Raise the apparent loglevel to maximum so that the sysrq header
> @@ -542,6 +544,7 @@ void __handle_sysrq(int key, bool check_
>  		console_loglevel = orig_log_level;
>  	}
>  	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> +oops_in_progress = save_oops_in_progress;
>  }
>  
>  void handle_sysrq(int key)

> ---
>  kernel/printk.c |    2 	1 +	1 -	0 !
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/kernel/printk.c
> ===================================================================
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -66,7 +66,7 @@ int console_printk[4] = {
>   * Low level drivers may need that to know if they can schedule in
>   * their unblank() callback or not. So let's export it.
>   */
> -int oops_in_progress;
> +int oops_in_progress = 1;
>  EXPORT_SYMBOL(oops_in_progress);
>  
>  /*

> ---
>  arch/arm/Kconfig.debug         |    2 	1 +	1 -	0 !
>  arch/arm/include/asm/hardirq.h |    2 	1 +	1 -	0 !
>  arch/arm/include/asm/irq.h     |    3 	3 +	0 -	0 !
>  arch/arm/include/asm/smp.h     |    2 	2 +	0 -	0 !
>  arch/arm/kernel/process.c      |   15 	15 +	0 -	0 !
>  arch/arm/kernel/smp.c          |   60 	60 +	0 -	0 !
>  6 files changed, 82 insertions(+), 2 deletions(-)
> 
> Index: b/arch/arm/include/asm/irq.h
> ===================================================================
> --- a/arch/arm/include/asm/irq.h
> +++ b/arch/arm/include/asm/irq.h
> @@ -25,6 +25,9 @@ extern void migrate_irqs(void);
>  extern void asm_do_IRQ(unsigned int, struct pt_regs *);
>  void init_IRQ(void);
>  
> +void arch_trigger_all_cpu_backtrace(void);
> +#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> +
>  #endif
>  
>  #endif
> Index: b/arch/arm/kernel/process.c
> ===================================================================
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -62,6 +62,21 @@ static volatile int hlt_counter;
>  
>  #include <mach/system.h>
>  
> +#ifdef CONFIG_SMP
> +
> +void arch_trigger_all_cpu_backtrace(void)
> +{
> +	smp_send_all_cpu_backtrace();
> +}
> +
> +#else
> +
> +void arch_trigger_all_cpu_backtrace(void)
> +{
> +}
> +
> +#endif
> +
>  void disable_hlt(void)
>  {
>  	hlt_counter++;
> Index: b/arch/arm/include/asm/smp.h
> ===================================================================
> --- a/arch/arm/include/asm/smp.h
> +++ b/arch/arm/include/asm/smp.h
> @@ -93,4 +93,6 @@ extern void arch_send_call_function_ipi_
>   */
>  extern void show_local_irqs(struct seq_file *, int);
>  
> +extern void smp_send_all_cpu_backtrace(void);
> +
>  #endif /* ifndef __ASM_ARM_SMP_H */
> Index: b/arch/arm/kernel/smp.c
> ===================================================================
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -53,6 +53,7 @@ enum ipi_msg_type {
>  	IPI_CALL_FUNC,
>  	IPI_CALL_FUNC_SINGLE,
>  	IPI_CPU_STOP,
> +	IPI_ALL_CPU_BACKTRACE,
>  };
>  
>  int __cpuinit __cpu_up(unsigned int cpu)
> @@ -405,6 +406,7 @@ static const char *ipi_types[NR_IPI] = {
>  	S(IPI_CALL_FUNC, "Function call interrupts"),
>  	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
>  	S(IPI_CPU_STOP, "CPU stop interrupts"),
> +	S(IPI_ALL_CPU_BACKTRACE, "All cpu backtrace"),
>  };
>  
>  void show_ipi_list(struct seq_file *p, int prec)
> @@ -555,6 +557,60 @@ static void ipi_cpu_stop(unsigned int cp
>  		cpu_relax();
>  }
>  
> +static cpumask_t backtrace_mask;
> +
> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> +static unsigned long backtrace_flag;
> +
> +void smp_send_all_cpu_backtrace(void)
> +{
> +	int i;
> +	cpumask_t this_cpu_mask;
> +
> +	if (test_and_set_bit(0, &backtrace_flag))
> +		/*
> +		 * If there is already a trigger_all_cpu_backtrace() in progress
> +		 * (backtrace_flag == 1), don't output double cpu dump infos.
> +		 */
> +		return;
> +
> +	backtrace_mask = cpu_online_map;
> +	cpus_clear(this_cpu_mask);
> +	cpu_set(smp_processor_id(), this_cpu_mask);
> +
> +	printk(KERN_INFO "sending IPI to all CPUs:\n");
> +	smp_cross_call(&backtrace_mask, IPI_ALL_CPU_BACKTRACE);
> +
> +
> +	/* Wait for up to 10 seconds for all other CPUs to do the backtrace */
> +	for (i = 0; i < 10 * 1000; i++) {
> +		if (cpus_equal(backtrace_mask, this_cpu_mask))
> +			break;
> +		mdelay(1);
> +	}
> +
> +	clear_bit(0, &backtrace_flag);
> +	smp_mb__after_clear_bit();
> +}
> +
> +
> +/*
> + * ipi_all_cpu_backtrace - handle IPI from smp_send_all_cpu_backtrace()
> + */
> +static void ipi_all_cpu_backtrace(unsigned int cpu, struct pt_regs *regs)
> +{
> +	if (cpu_isset(cpu, backtrace_mask)) {
> +		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +
> +		arch_spin_lock(&lock);
> +		printk(KERN_WARNING "IPI backtrace for cpu %d\n", cpu);
> +printk("regs 0x%p\n", regs);
> +		show_regs(regs);
> +		arch_spin_unlock(&lock);
> +		cpu_clear(cpu, backtrace_mask);
> +	}
> +}
> +
>  /*
>   * Main handler for inter-processor interrupts
>   */
> @@ -587,6 +643,10 @@ asmlinkage void __exception_irq_entry do
>  		ipi_cpu_stop(cpu);
>  		break;
>  
> +	case IPI_ALL_CPU_BACKTRACE:
> +		ipi_all_cpu_backtrace(cpu, regs);
> +		break;
> +
>  	default:
>  		printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%x\n",
>  		       cpu, ipinr);
> Index: b/arch/arm/Kconfig.debug
> ===================================================================
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -21,7 +21,7 @@ config STRICT_DEVMEM
>  # traces, you can get a slightly smaller kernel by setting this option to
>  # n, but then RMK will have to kill you ;).
>  config FRAME_POINTER
> -	bool
> +	bool "frame pointer support"
>  	depends on !THUMB2_KERNEL
>  	default y if !ARM_UNWIND || FUNCTION_GRAPH_TRACER
>  	help
> Index: b/arch/arm/include/asm/hardirq.h
> ===================================================================
> --- a/arch/arm/include/asm/hardirq.h
> +++ b/arch/arm/include/asm/hardirq.h
> @@ -5,7 +5,7 @@
>  #include <linux/threads.h>
>  #include <asm/irq.h>
>  
> -#define NR_IPI	5
> +#define NR_IPI	6
>  
>  typedef struct {
>  	unsigned int __softirq_pending;

> #
> # Automatically generated make config: don't edit
> # Linux/arm 3.0.1 Kernel Configuration
> #
> CONFIG_ARM=y
> CONFIG_MIGHT_HAVE_PCI=y
> CONFIG_SYS_SUPPORTS_APM_EMULATION=y
> CONFIG_GENERIC_GPIO=y
> # CONFIG_ARCH_USES_GETTIMEOFFSET is not set
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_HAVE_PROC_CPU=y
> CONFIG_IRQ_PER_CPU=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_HARDIRQS_SW_RESEND=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_LOCKBREAK=y
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_VECTORS_BASE=0xffff0000
> # CONFIG_ARM_PATCH_PHYS_VIRT is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_HAVE_SPARSE_IRQ=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_IRQ_FORCED_THREADING=y
> # CONFIG_SPARSE_IRQ is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=32
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=16
> # CONFIG_CGROUPS is not set
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y
> CONFIG_RELAY=y
> # CONFIG_BLK_DEV_INITRD is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_EXPERT=y
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> # CONFIG_PERF_EVENTS is not set
> # CONFIG_PERF_COUNTERS is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_COMPAT_BRK=y
> CONFIG_SLAB=y
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> # CONFIG_KPROBES is not set
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_SPIN_UNLOCK is not set
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_READ_UNLOCK is not set
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_WRITE_UNLOCK is not set
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=y
> 
> #
> # System Type
> #
> CONFIG_MMU=y
> # CONFIG_ARCH_INTEGRATOR is not set
> # CONFIG_ARCH_REALVIEW is not set
> # CONFIG_ARCH_VERSATILE is not set
> # CONFIG_ARCH_VEXPRESS is not set
> CONFIG_ARCH_NE1=y
> # CONFIG_ARCH_AT91 is not set
> # CONFIG_ARCH_BCMRING is not set
> # CONFIG_ARCH_CLPS711X is not set
> # CONFIG_ARCH_CNS3XXX is not set
> # CONFIG_ARCH_GEMINI is not set
> # CONFIG_ARCH_EBSA110 is not set
> # CONFIG_ARCH_EP93XX is not set
> # CONFIG_ARCH_FOOTBRIDGE is not set
> # CONFIG_ARCH_MXC is not set
> # CONFIG_ARCH_MXS is not set
> # CONFIG_ARCH_NETX is not set
> # CONFIG_ARCH_H720X is not set
> # CONFIG_ARCH_IOP13XX is not set
> # CONFIG_ARCH_IOP32X is not set
> # CONFIG_ARCH_IOP33X is not set
> # CONFIG_ARCH_IXP23XX is not set
> # CONFIG_ARCH_IXP2000 is not set
> # CONFIG_ARCH_IXP4XX is not set
> # CONFIG_ARCH_DOVE is not set
> # CONFIG_ARCH_KIRKWOOD is not set
> # CONFIG_ARCH_LOKI is not set
> # CONFIG_ARCH_LPC32XX is not set
> # CONFIG_ARCH_MV78XX0 is not set
> # CONFIG_ARCH_ORION5X is not set
> # CONFIG_ARCH_MMP is not set
> # CONFIG_ARCH_KS8695 is not set
> # CONFIG_ARCH_W90X900 is not set
> # CONFIG_ARCH_NUC93X is not set
> # CONFIG_ARCH_TEGRA is not set
> # CONFIG_ARCH_PNX4008 is not set
> # CONFIG_ARCH_PXA is not set
> # CONFIG_ARCH_MSM is not set
> # CONFIG_ARCH_SHMOBILE is not set
> # CONFIG_ARCH_RPC is not set
> # CONFIG_ARCH_SA1100 is not set
> # CONFIG_ARCH_S3C2410 is not set
> # CONFIG_ARCH_S3C64XX is not set
> # CONFIG_ARCH_S5P64X0 is not set
> # CONFIG_ARCH_S5PC100 is not set
> # CONFIG_ARCH_S5PV210 is not set
> # CONFIG_ARCH_EXYNOS4 is not set
> # CONFIG_ARCH_SHARK is not set
> # CONFIG_ARCH_TCC_926 is not set
> # CONFIG_ARCH_U300 is not set
> # CONFIG_ARCH_U8500 is not set
> # CONFIG_ARCH_NOMADIK is not set
> # CONFIG_ARCH_DAVINCI is not set
> # CONFIG_ARCH_OMAP is not set
> # CONFIG_PLAT_SPEAR is not set
> # CONFIG_ARCH_VT8500 is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> 
> #
> # NaviEngine1 platform type
> #
> CONFIG_MACH_NE1TB=y
> # CONFIG_MACH_NE1DB is not set
> 
> #
> # Device drivers for the NaviEngine1 embedded controllers
> #
> CONFIG_NE1_GPIO=y
> CONFIG_NE1_USB=y
> 
> #
> # Device drivers for the NE1-xB on-board devices
> #
> 
> #
> # System MMU
> #
> 
> #
> # Processor Type
> #
> CONFIG_CPU_V6=y
> CONFIG_CPU_V6K=y
> CONFIG_CPU_32v6=y
> CONFIG_CPU_32v6K=y
> CONFIG_CPU_ABRT_EV6=y
> CONFIG_CPU_PABRT_V6=y
> CONFIG_CPU_CACHE_V6=y
> CONFIG_CPU_CACHE_VIPT=y
> CONFIG_CPU_COPY_V6=y
> CONFIG_CPU_TLB_V6=y
> CONFIG_CPU_HAS_ASID=y
> CONFIG_CPU_CP15=y
> CONFIG_CPU_CP15_MMU=y
> CONFIG_CPU_USE_DOMAINS=y
> 
> #
> # Processor Features
> #
> CONFIG_ARM_THUMB=y
> # CONFIG_CPU_ICACHE_DISABLE is not set
> # CONFIG_CPU_DCACHE_DISABLE is not set
> # CONFIG_CPU_BPREDICT_DISABLE is not set
> CONFIG_DMA_CACHE_RWFO=y
> CONFIG_ARM_L1_CACHE_SHIFT=5
> CONFIG_ARM_DMA_MEM_BUFFERABLE=y
> CONFIG_CPU_HAS_PMU=y
> # CONFIG_ARM_ERRATA_411920 is not set
> CONFIG_ARM_GIC=y
> 
> #
> # Bus support
> #
> CONFIG_ARM_AMBA=y
> CONFIG_PCI=y
> CONFIG_PCI_SYSCALL=y
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_STUB is not set
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCCARD is not set
> 
> #
> # Kernel Features
> #
> CONFIG_TICK_ONESHOT=y
> # CONFIG_HIGH_RES_TIMERS is not set
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_SMP_ON_UP=y
> CONFIG_HAVE_ARM_SCU=y
> CONFIG_HAVE_ARM_TWD=y
> CONFIG_VMSPLIT_3G=y
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_NR_CPUS=4
> CONFIG_HOTPLUG_CPU=y
> CONFIG_LOCAL_TIMERS=y
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_RT_BASE=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT_LL is not set
> # CONFIG_PREEMPT_RTB is not set
> CONFIG_PREEMPT_RT_FULL=y
> CONFIG_HZ=100
> CONFIG_AEABI=y
> CONFIG_OABI_COMPAT=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> # CONFIG_HAVE_ARCH_PFN_VALID is not set
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SNSC_SPARSE_SECTION_SHIFT=25
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> # CONFIG_COMPACTION is not set
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_CLEANCACHE is not set
> CONFIG_FORCE_MAX_ZONEORDER=11
> CONFIG_ALIGNMENT_TRAP=y
> # CONFIG_UACCESS_WITH_MEMCPY is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_DEPRECATED_PARAM_STRUCT is not set
> 
> #
> # Boot options
> #
> # CONFIG_USE_OF is not set
> CONFIG_ZBOOT_ROM_TEXT=0x0
> CONFIG_ZBOOT_ROM_BSS=0x0
> CONFIG_CMDLINE="root=/dev/nfs ip=dhcp mem=256M console=ttyS0,38400"
> CONFIG_CMDLINE_FROM_BOOTLOADER=y
> # CONFIG_CMDLINE_EXTEND is not set
> # CONFIG_CMDLINE_FORCE is not set
> # CONFIG_XIP_KERNEL is not set
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> # CONFIG_AUTO_ZRELADDR is not set
> 
> #
> # CPU Power Management
> #
> # CONFIG_CPU_IDLE is not set
> 
> #
> # Floating point emulation
> #
> 
> #
> # At least one emulation must be selected
> #
> CONFIG_FPE_NWFPE=y
> # CONFIG_FPE_NWFPE_XP is not set
> # CONFIG_FPE_FASTFPE is not set
> CONFIG_VFP=y
> 
> #
> # Userspace binary formats
> #
> CONFIG_BINFMT_ELF=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> # CONFIG_BINFMT_MISC is not set
> 
> #
> # Power management options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_APM_EMULATION is not set
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> # CONFIG_XFRM_USER is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_PNP=y
> CONFIG_IP_PNP_DHCP=y
> # CONFIG_IP_PNP_BOOTP is not set
> # CONFIG_IP_PNP_RARP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE_DEMUX is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_BEET is not set
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IPV6=y
> # CONFIG_IPV6_PRIVACY is not set
> # CONFIG_IPV6_ROUTER_PREF is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> # CONFIG_INET6_AH is not set
> # CONFIG_INET6_ESP is not set
> # CONFIG_INET6_IPCOMP is not set
> # CONFIG_IPV6_MIP6 is not set
> # CONFIG_INET6_XFRM_TUNNEL is not set
> # CONFIG_INET6_TUNNEL is not set
> CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> CONFIG_INET6_XFRM_MODE_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_BEET=y
> # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> CONFIG_IPV6_SIT=y
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=y
> # CONFIG_IPV6_TUNNEL is not set
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_IPV6_MROUTE is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> # CONFIG_FW_LOADER is not set
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_CRYPTOLOOP=y
> 
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_PCH_PHUB is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_MULTI_LUN=y
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_ISCSI_BOOT_SYSFS is not set
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> # CONFIG_SCSI_CXGB4_ISCSI is not set
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_LIBFC is not set
> # CONFIG_LIBFCOE is not set
> # CONFIG_FCOE is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_NSP32 is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_BFA_FC is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> # CONFIG_ATA is not set
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> CONFIG_BLK_DEV_DM=y
> CONFIG_DM_DEBUG=y
> CONFIG_DM_CRYPT=y
> # CONFIG_DM_SNAPSHOT is not set
> # CONFIG_DM_MIRROR is not set
> # CONFIG_DM_RAID is not set
> # CONFIG_DM_ZERO is not set
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> # CONFIG_DM_UEVENT is not set
> # CONFIG_DM_FLAKEY is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_NETDEVICES=y
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> # CONFIG_ARCNET is not set
> CONFIG_MII=y
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> # CONFIG_LXT_PHY is not set
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> # CONFIG_BROADCOM_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> # CONFIG_FIXED_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_NET_ETHERNET=y
> # CONFIG_AX88796 is not set
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_SMC91X is not set
> # CONFIG_DM9000 is not set
> # CONFIG_ETHOC is not set
> # CONFIG_SMC911X is not set
> CONFIG_SMSC911X=y
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> # CONFIG_DNET is not set
> # CONFIG_NET_TULIP is not set
> # CONFIG_HP100 is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> # CONFIG_NET_PCI is not set
> # CONFIG_B44 is not set
> # CONFIG_KS8851_MLL is not set
> # CONFIG_ATL2 is not set
> # CONFIG_FTMAC100 is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_CNIC is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_ATL1C is not set
> # CONFIG_JME is not set
> # CONFIG_STMMAC_ETH is not set
> # CONFIG_PCH_GBE is not set
> CONFIG_NETDEV_10000=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T3 is not set
> # CONFIG_CHELSIO_T4 is not set
> # CONFIG_CHELSIO_T4VF is not set
> # CONFIG_ENIC is not set
> # CONFIG_IXGBE is not set
> # CONFIG_IXGB is not set
> # CONFIG_S2IO is not set
> # CONFIG_VXGE is not set
> # CONFIG_MYRI10GE is not set
> # CONFIG_NETXEN_NIC is not set
> # CONFIG_NIU is not set
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> # CONFIG_TEHUTI is not set
> # CONFIG_BNX2X is not set
> # CONFIG_QLCNIC is not set
> # CONFIG_QLGE is not set
> # CONFIG_BNA is not set
> # CONFIG_SFC is not set
> # CONFIG_BE2NET is not set
> # CONFIG_TR is not set
> CONFIG_WLAN=y
> # CONFIG_ATMEL is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_HOSTAP is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_USB_IPHETH is not set
> # CONFIG_WAN is not set
> 
> #
> # CAIF transport drivers
> #
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> CONFIG_PPP=y
> # CONFIG_PPP_MULTILINK is not set
> # CONFIG_PPP_FILTER is not set
> CONFIG_PPP_ASYNC=y
> # CONFIG_PPP_SYNC_TTY is not set
> # CONFIG_PPP_DEFLATE is not set
> # CONFIG_PPP_BSDCOMP is not set
> # CONFIG_PPP_MPPE is not set
> # CONFIG_PPPOE is not set
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> # CONFIG_NET_FC is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_GPIO is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_AMBAKMI is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=16
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_AMBA_PL010 is not set
> # CONFIG_SERIAL_AMBA_PL011 is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_TTY_PRINTK is not set
> # CONFIG_HVC_DCC is not set
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_DEVPORT=y
> # CONFIG_RAMOOPS is not set
> # CONFIG_I2C is not set
> # CONFIG_SPI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> 
> #
> # Enable Device Drivers -> PPS to see the PTP clock options.
> #
> # CONFIG_W1 is not set
> # CONFIG_POWER_SUPPLY is not set
> # CONFIG_HWMON is not set
> # CONFIG_THERMAL is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> CONFIG_MFD_SUPPORT=y
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_DRM is not set
> # CONFIG_STUB_POULSBO is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> # CONFIG_FB is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> 
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> 
> #
> # Console display driver support
> #
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_SOUND is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HIDRAW is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_HID_PID is not set
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> CONFIG_HID_EZKEY=y
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> CONFIG_HID_GYRATION=y
> # CONFIG_HID_TWINHAN is not set
> # CONFIG_HID_KENSINGTON is not set
> # CONFIG_HID_LCPOWER is not set
> CONFIG_HID_LOGITECH=y
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWII_FF is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> CONFIG_HID_PANTHERLORD=y
> # CONFIG_PANTHERLORD_FF is not set
> CONFIG_HID_PETALYNX=y
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_QUANTA is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_ROCCAT_ARVO is not set
> # CONFIG_HID_ROCCAT_KONE is not set
> # CONFIG_HID_ROCCAT_KONEPLUS is not set
> # CONFIG_HID_ROCCAT_KOVAPLUS is not set
> # CONFIG_HID_ROCCAT_PYRA is not set
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SONY=y
> CONFIG_HID_SUNPLUS=y
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> CONFIG_USB_DEVICE_CLASS=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> # CONFIG_USB_MON is not set
> # CONFIG_USB_WUSB is not set
> # CONFIG_USB_WUSB_CBAF is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> # CONFIG_USB_XHCI_HCD is not set
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> # CONFIG_USB_UHCI_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
> # CONFIG_USB_MUSB_HDRC is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> # CONFIG_USB_WDM is not set
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> # CONFIG_USB_UAS is not set
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> 
> #
> # USB port drivers
> #
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> # CONFIG_USB_EZUSB is not set
> CONFIG_USB_SERIAL_GENERIC=y
> # CONFIG_USB_SERIAL_AIRCABLE is not set
> # CONFIG_USB_SERIAL_ARK3116 is not set
> # CONFIG_USB_SERIAL_BELKIN is not set
> # CONFIG_USB_SERIAL_CH341 is not set
> # CONFIG_USB_SERIAL_WHITEHEAT is not set
> # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> # CONFIG_USB_SERIAL_CP210X is not set
> # CONFIG_USB_SERIAL_CYPRESS_M8 is not set
> # CONFIG_USB_SERIAL_EMPEG is not set
> # CONFIG_USB_SERIAL_FTDI_SIO is not set
> # CONFIG_USB_SERIAL_FUNSOFT is not set
> # CONFIG_USB_SERIAL_VISOR is not set
> # CONFIG_USB_SERIAL_IPAQ is not set
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> # CONFIG_USB_SERIAL_EDGEPORT_TI is not set
> # CONFIG_USB_SERIAL_GARMIN is not set
> # CONFIG_USB_SERIAL_IPW is not set
> # CONFIG_USB_SERIAL_IUU is not set
> # CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
> # CONFIG_USB_SERIAL_KEYSPAN is not set
> # CONFIG_USB_SERIAL_KLSI is not set
> # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> # CONFIG_USB_SERIAL_MCT_U232 is not set
> # CONFIG_USB_SERIAL_MOS7720 is not set
> # CONFIG_USB_SERIAL_MOS7840 is not set
> # CONFIG_USB_SERIAL_MOTOROLA is not set
> # CONFIG_USB_SERIAL_NAVMAN is not set
> CONFIG_USB_SERIAL_PL2303=y
> # CONFIG_USB_SERIAL_OTI6858 is not set
> # CONFIG_USB_SERIAL_QCAUX is not set
> # CONFIG_USB_SERIAL_QUALCOMM is not set
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> # CONFIG_USB_SERIAL_HP4X is not set
> # CONFIG_USB_SERIAL_SAFE is not set
> # CONFIG_USB_SERIAL_SIEMENS_MPI is not set
> # CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
> # CONFIG_USB_SERIAL_SYMBOL is not set
> # CONFIG_USB_SERIAL_TI is not set
> # CONFIG_USB_SERIAL_CYBERJACK is not set
> # CONFIG_USB_SERIAL_XIRCOM is not set
> # CONFIG_USB_SERIAL_OPTION is not set
> # CONFIG_USB_SERIAL_OMNINET is not set
> # CONFIG_USB_SERIAL_OPTICON is not set
> # CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
> # CONFIG_USB_SERIAL_ZIO is not set
> # CONFIG_USB_SERIAL_SSU100 is not set
> # CONFIG_USB_SERIAL_DEBUG is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
> # CONFIG_USB_GADGET is not set
> 
> #
> # OTG and related infrastructure
> #
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_USB_ULPI is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_NFC_DEVICES is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_PL030 is not set
> # CONFIG_RTC_DRV_PL031 is not set
> CONFIG_RTC_DRV_NE1TB=y
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_STAGING is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> CONFIG_FUSE_FS=y
> # CONFIG_CUSE is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=y
> # CONFIG_SQUASHFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V3=y
> # CONFIG_NFS_V3_ACL is not set
> CONFIG_NFS_V4=y
> # CONFIG_NFS_V4_1 is not set
> CONFIG_ROOT_NFS=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> # CONFIG_NFS_USE_NEW_IDMAPPER is not set
> CONFIG_NFSD=y
> CONFIG_NFSD_DEPRECATED=y
> # CONFIG_NFSD_V3 is not set
> # CONFIG_NFSD_V4 is not set
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=y
> # CONFIG_CEPH_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_UTF8 is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_HARDLOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_DEBUG_SLAB is not set
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_PREEMPT=y
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_INFO_REDUCED is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> # CONFIG_LKDTM is not set
> # CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_ARM_UNWIND=y
> CONFIG_DEBUG_USER=y
> CONFIG_DEBUG_LL=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_DEBUG_ICEDCC is not set
> # CONFIG_OC_ETM is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> # CONFIG_CRYPTO_AUTHENC is not set
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> # CONFIG_CRYPTO_LRW is not set
> CONFIG_CRYPTO_PCBC=y
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_HMAC is not set
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_GHASH is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> # CONFIG_CRYPTO_AES is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> # CONFIG_CRYPTO_ARC4 is not set
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> 
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> # CONFIG_CRYPTO_ZLIB is not set
> # CONFIG_CRYPTO_LZO is not set
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_CRC_CCITT=y
> # CONFIG_CRC16 is not set
> # CONFIG_CRC_T10DIF is not set
> # CONFIG_CRC_ITU_T is not set
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> # CONFIG_LIBCRC32C is not set
> CONFIG_ZLIB_INFLATE=y
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CPU_RMAP=y
> CONFIG_NLATTR=y
> CONFIG_GENERIC_ATOMIC64=y
> # CONFIG_AVERAGE is not set

