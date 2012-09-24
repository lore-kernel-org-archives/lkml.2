Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2IXKvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:51:44 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:52177
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753627Ab2IXKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:51:42 -0400
Message-ID: <50603B3C.8070402@mimc.co.uk>
Date: Mon, 24 Sep 2012 11:51:40 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "tony@atomide.com >> Tony Lindgren" <tony@atomide.com>
Subject: Re: gpmc_cs_request() causes early boot hang
References: <505CBFAA.3080604@mimc.co.uk> <C8443D0743D26F4388EA172BF4E2A7A93E9E7628@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93E9E7628@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/12 05:51, Mohammed, Afzal wrote:
> 
> It seems you are using PSP Kernel.
> 
> Invoking omap_init_gpmc before gpmc request should help.

Okay ... I'm now using earlyprintk and omap_init_gpmc(), but I still get boot hangs.

My test code is as follows:-

diff --git a/arch/arm/mach-omap2/board-am335xevm.c b/arch/arm/mach-omap2/board-am335xevm.c
index dc62ba2..be47e4f 100644
--- a/arch/arm/mach-omap2/board-am335xevm.c
+++ b/arch/arm/mach-omap2/board-am335xevm.c
@@ -4295,6 +4295,20 @@ static void __init am33xx_cpuidle_init(void)

 }

+static void gpmc_test(void)
+{
+       unsigned long base = 0x12345678;
+
+       struct gpmc_devices_info gpmc_device[2] = {
+                       { NULL, GPMC_DEVICE_NOR },
+               };
+
+       setup_pin_mux(gpmc_pin_mux);
+       omap_init_gpmc(gpmc_device, sizeof(gpmc_device));
+       gpmc_cs_request(0, SZ_16M, &base);
+       printk(KERN_INFO "gpmc base @ 0x%08lx\n", base);
+}
+
 static void __init am335x_evm_init(void)
 {
        am33xx_cpuidle_init();
@@ -4313,6 +4327,8 @@ static void __init am335x_evm_init(void)
        /* Create an alias for gfx/sgx clock */
        if (clk_add_alias("sgx_ck", NULL, "gfx_fclk", NULL))
                pr_warn("failed to create an alias: gfx_fclk --> sgx_ck\n");
+
+       gpmc_test();
 }

 static void __init am335x_evm_map_io(void)

----

But this then fails with the following boot log:-

Uncompressing Linux... done, booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.28+ (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot
2012.08-git-00388-g7019407) ) #127 Mon Sep 24 11:27:18 BST 2012
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=50c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: am335xevm
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 65536
[    0.000000] free_area_init_node: node 0, pgdat c044ca14, node_mem_map c04b1000
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65024 pages, LIFO batch:15
[    0.000000] AM335X ES1.0 (sgx neon )
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
[    0.000000] Kernel command line: console=ttyO0,115200n8 earlyprintk debug root=/dev/mmcblk0p2 ro
rootfstype=ext2 rootwait ip=none
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Memory: 256MB = 256MB total
[    0.000000] Memory: 255052k/255052k available, 7092k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     modules : 0xbf800000 - 0xc0000000   (   8 MB)
[    0.000000]       .text : 0xc0008000 - 0xc03de0ec   (3929 kB)
[    0.000000]       .init : 0xc03df000 - 0xc0404000   ( 148 kB)
[    0.000000]       .data : 0xc0404000 - 0xc044dd58   ( 296 kB)
[    0.000000]        .bss : 0xc044dd7c - 0xc04b0694   ( 395 kB)
[    0.000000] NR_IRQS:396 nr_irqs:396 396
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER2 at 24000000 Hz
[    0.000000] OMAP clocksource: GPTIMER1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.004943] Calibrating delay loop... 498.89 BogoMIPS (lpj=2494464)
[    0.062072] pid_max: default: 32768 minimum: 301
[    0.067047] Security Framework initialized
[    0.071441] Mount-cache hash table entries: 512
[    0.076599] Initializing cgroup subsys cpuacct
[    0.081329] Initializing cgroup subsys devices
[    0.085998] Initializing cgroup subsys freezer
[    0.090728] CPU: Testing write buffer coherency: ok
[    0.097045] devtmpfs: initialized
[    0.102478] ttyO0 used as console in debug mode uart0 clocks will not be gated
[    0.128417] omap_hwmod: gfx: failed to hardreset
[    0.150238] omap_hwmod: pruss: failed to hardreset
[    0.155822] print_constraints: dummy:
[    0.160064] NET: Registered protocol family 16
[    0.165985] OMAP GPIO hardware version 0.1
[    0.171600] omap_mux_init: Add partition: #1: core, flags: 0
[    0.179107]  omap_i2c.1: alias fck already exists
[    0.185028] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[    0.193481] pgd = c0004000
[    0.196350] [00000010] *pgd=00000000
[    0.200134] Internal error: Oops: 5 [#1]
[    0.204254] Modules linked in:
[    0.207489] CPU: 0    Not tainted  (3.2.28+ #127)
[    0.212463] PC is at gpmc_cs_reserved+0x14/0x20
[    0.217224] LR is at gpmc_cs_request+0x35/0xd0
[    0.221862] pc : [<c0015ff4>]    lr : [<c0016085>]    psr: 00000033
[    0.221893] sp : cf837f58  ip : 00000000  fp : 00000000
[    0.233886] r10: 00000000  r9 : 00000000  r8 : 00000000
[    0.239349] r7 : 00000000  r6 : 01000000  r5 : fffffff0  r4 : 00000000
[    0.246154] r3 : 00000000  r2 : cf837fa4  r1 : 01000000  r0 : 00000001
[    0.252990] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment kernel
[    0.260772] Control: 50c5387d  Table: 80004019  DAC: 00000015
[    0.266784] Process swapper (pid: 1, stack limit = 0xcf8362f0)
[    0.272888] Stack: (0xcf837f58 to 0xcf838000)
[    0.277465] 7f40:                                                       00000000 00000010
[    0.285980] 7f60: cf837f94 c041e194 cf85dac0 c03e491b 00000010 cf837fa4 00000000 cf837f94
[    0.294494] 7f80: c0403c50 c03e11a5 00000000 c03e7601 c014bf99 00000000 00000004 00000000
[    0.303009] 7fa0: 00000000 12345678 c04037e0 c03e11b1 cf836000 c00086b9 0000018c c042a2dc
[    0.311553] 7fc0: c000d071 c011a19f c042a32c c0055263 c042a32c c04037e0 c0403c50 c000d071
[    0.320068] 7fe0: 00000033 c03df589 00000000 00000000 c03df529 c000d071 0b000ea3 4351a688
[    0.328613] [<c0015ff4>] (gpmc_cs_reserved+0x14/0x20) from [<c0016085>] (gpmc_cs_request+0x35/0xd0)
[    0.338043] [<c0016085>] (gpmc_cs_request+0x35/0xd0) from [<c03e7601>] (am335x_evm_init+0x12d/0x1ac)
[    0.347564] [<c03e7601>] (am335x_evm_init+0x12d/0x1ac) from [<c03e11b1>] (customize_machine+0xd/0x14)
[    0.357147] [<c03e11b1>] (customize_machine+0xd/0x14) from [<c00086b9>] (do_one_initcall+0x69/0x100)
[    0.366668] [<c00086b9>] (do_one_initcall+0x69/0x100) from [<c03df589>] (kernel_init+0x61/0xd8)
[    0.375762] [<c03df589>] (kernel_init+0x61/0xd8) from [<c000d071>] (kernel_thread_exit+0x1/0x6)
[    0.384826] Code: fa03 f000 4b02 681b (691b) 4018
[    0.389892] ---[ end trace 1b75b31a2719ed1c ]---
[    0.394805] Kernel panic - not syncing: Attempted to kill init!

However, I have noticed that when I comment out the gpmc_cs_request(), my test printk() appears in
the boot log *before* the GPMC device appears to be initialised ...

...
[    0.171569] omap_mux_init: Add partition: #1: core, flags: 0
[    0.179077]  omap_i2c.1: alias fck already exists
[    0.184997] gpmc base @ 0x12345678
[    0.188598] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.194915]  omap2_mcspi.1: alias fck already exists
[    0.200256]  omap2_mcspi.2: alias fck already exists
...
[    0.359680] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.366577] NET: Registered protocol family 1
[    0.371673] omap-gpmc omap-gpmc: GPMC revision 6.0
[    0.378356] audit: initializing netlink socket (disabled)
[    0.384063] type=2000 audit(0.380:1): initialized
...

Surely omap-gpmc needs to be setup before any calls such as gpmc_cs_request() ?

Is there a method to delay my test code, or maybe get the omap-gpmc registered earlier ?

Cheers
Mark JACKSON
