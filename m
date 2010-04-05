Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0DESEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:04:47 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:18611 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0DESEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:04:40 -0400
X-Spam-Processed: digidescorp.com, Mon, 05 Apr 2010 13:04:38 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=17115db498=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix ftrace_update_ftrace_func panic
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
In-Reply-To: <4BB9F309.8070807@monstr.eu>
References: <1270232979-12113-1-git-send-email-steve@digidescorp.com>
	 <4BB9F309.8070807@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Mon, 05 Apr 2010 13:04:34 -0500
Message-Id: <1270490674.3042.174.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 16:26 +0200, Michal Simek wrote:
> Steven J. Magnani wrote:
> > The Microblaze dynamic ftrace code assumes a call ordering that is not met
> > in all scenarios. Specifically, executing a command similar to:
> > 
> >   echo 105 > /sys/kernel/debug/tracing/set_ftrace_pid
> > 
> > before any other tracing-related commands results in a kernel panic:
> > 
> >   BUG: failure at arch/microblaze/kernel/ftrace.c:198/ftrace_update_ftrace_func()!
> > 
> > Recoding ftrace_update_ftrace_func() to use &ftrace_caller directly eliminates 
> > the need to capture its address elsewhere (and thus rely on a particular call 
> > sequence).
> 
> I would like to replicate this problem to see that there is. I am not 
> able to reach this fault
> Please copy & paste log with your commands.

Here is my kernel hacking .config:

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_NOMMU_REGIONS is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_PAGE_POISONING is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_HEART_BEAT is not set
# CONFIG_DEBUG_BOOTMEM is not set

Here's the console log. It really is just a one-command trigger, as in
the commit log.

early_printk_console is enabled at 0x40600000
Ramdisk addr 0x00000000, Found romfs @ 0x202ef204 (0x00218000)
#### klimit 2030c000 ####
Moved 0x00218000 bytes from 0x202ef204 to 0x2030beec
New klimit: 0x20524000
Linux version 2.6.33.2-DDC-svn11650 (smagnani@iscandar.digidescorp.com)
(gcc version 4.1.2) #725 Mon Apr 5 11:53:08 CDT 2010
setup_memory: Main mem: 0x20000000-0x2fffffff, size 0x0fffffff
setup_memory: kernel addr=0x20000000-0x20524000 size=0x00524000
setup_memory: max_mapnr: 0xffff
setup_memory: min_low_pfn: 0x20000
setup_memory: max_low_pfn: 0x2ffff
On node 0 totalpages: 65535
free_area_init_node: node 0, pgdat 202c9d90, node_mem_map 20524000
  Normal zone: 512 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 65023 pages, LIFO batch:0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
65023
Kernel command line: root=/dev/mtdblock3
mtdparts=physmap-flash.0:6M(kernel),640k(log),-(spare)
softdog.soft_noboot=1 softdog.nowayout=1
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254612k/262140k available
NR_IRQS:32
INTC #0 at 0x60120000, num_irq=15, edge=0xffffc000
Timer #0 at 0x61c00000, irq=0
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Calibrating delay loop... 61.44 BogoMIPS (lpj=307200)
Mount-cache hash table entries: 512
ftrace: allocating 7223 entries in 15 pages
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
SCSI subsystem initialized
Switching to clocksource microblaze_clocksource
microblaze_timer_set_mode: oneshot
Switched to NOHz mode on CPU #0
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
ROMFS MTD (C) 2007 Red Hat, Inc.
msgmni has been set to 497
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
xilinx_prom : at 0x56020400 mapped to 0x56020400
uartlite.0: ttyUL0 at MMIO 0x40600003 (irq = 14) is a uartlite
console [ttyUL0] enabled
brd: module loaded
loop: module loaded
physmap platform flash device: 04000000 at 80000000
physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
physmap-flash.0: Found 1 x16 devices at 0x2000000 in 16-bit bank
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
 Intel/Sharp Extended Query Table at 0x010A
Using buffer write method
Using auto-unlock on power-up/resume
cfi_cmdset_0001: Erase suspend on write enabled
erase region 0: offset=0x0,size=0x8000,blocks=4
erase region 1: offset=0x20000,size=0x20000,blocks=255
erase region 2: offset=0x2000000,size=0x8000,blocks=4
erase region 3: offset=0x2020000,size=0x20000,blocks=255
3 cmdlinepart partitions found on MTD device physmap-flash.0
Creating 3 MTD partitions on "physmap-flash.0":
0x000000000000-0x000000600000 : "kernel"
0x000000600000-0x0000006a0000 : "log"
0x0000006a0000-0x000004000000 : "spare"
uclinux[mtd]: RAM probe address=0x2030beec size=0x218000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x000000218000 : "ROMfs"
Generic platform RAM MTD, (c) 2004 Simtec Electronics
Software Watchdog Timer: 0.07 initialized. soft_noboot=1 soft_margin=60
sec (nowayout= 1)
xlldma xlldma.0: Xilinx DMA engine...
xlldma xlldma.0: #0, tx irq 3, rx irq 4
xlldma xlldma.0: #1, tx irq 5, rx irq 6
TCP cubic registered
NET: Registered protocol family 17
VFS: Mounted root (cramfs filesystem) readonly on device 31:3.
Freeing unused kernel memory: 132k freed
Mounting proc: 
Mounting var: 
Populating /var: 
Running local start scripts.
Mounting /etc/config: 
Mounting sysfs:
Mounting debugfs:
Setting hostname: 
Bringing up loopback interface: 
lo: UP
Bringing up eth0: 
                  * Loading driver
xilinx_lltemac xilinx_lltemac.0: MAC address is now  0:11:90:90: 0: 8
xilinx_lltemac xilinx_lltemac.0: XLlTemac: using DMA mode.
XLlTemac: Dma base address: phy: 0x400a0000, virt: 0x400a0000
XLlTemac: buffer descriptor size: 131072 (0x20000)
XLlTemac: Allocating DMA descriptors with kmalloc
XLlTemac: (buffer_descriptor_init) phy: 0x2e0e0000, virt: 0x2e0e0000,
size: 0x20000
detect phy
XLlTemac: PHY detected at address 19.
xilinx_lltemac xilinx_lltemac.0: eth0: Xilinx TEMAC at 0x70000000 mapped
to 0x70000000, irq=7
eth0: XLlTemac: Options: 0x3fa
eth0: XLlTemac: allocating interrupt 1 for dma mode tx.
eth0: XLlTemac: allocating interrupt 2 for dma mode rx.

XLlTemac: Receive clock transitions when data transitions
eth0: XLlTemac: Send Threshold = 200, Receive Threshold = 50
eth0: XLlTemac: Send Wait bound = 254, Receive Wait bound = 254
eth0: UP
eth0: XLlTemac: PHY Link carrier lost.
eth0: XLlTemac: speed set to 1000Mb/s
eth0: XLlTemac: PHY Link carrier restored.

petalinux login: root
Password: 
# ps
  PID PORT STAT SIZE SHARED %CPU COMMAND
    1      S    204K     0K  7.2 /bin/init 
    2      S      0K     0K  0.0 kthreadd
    3      S      0K     0K  0.1 ksoftirqd/0
    4      S      0K     0K  0.0 events/0
    5      S      0K     0K  0.0 khelper
    6      S      0K     0K  0.0 async/mgr
    7      S      0K     0K  0.0 sync_supers
    8      S      0K     0K  0.0 bdi-default
    9      S      0K     0K  0.0 kblockd/0
   10      S      0K     0K  0.0 kswapd0
   11      S      0K     0K  0.0 aio/0
   12      S      0K     0K  0.0 scsi_eh_0
   13      S      0K     0K  0.5 mtdblockd
   80      S      0K     0K  0.0 jffs2_gcd_mtd1
   86      S    491K     0K  1.1 -sh 
   87      S    118K     0K  0.6 /bin/inetd /etc/inetd.conf 
   88      S    642K     0K  1.6 /bin/syslogd -C256 -n 
   89      S    382K     0K  0.8 /bin/klogd -n 
  102      S      0K     0K  0.0 loop0
  118      S      0K     0K  0.0 flush-8:0
  119      S      0K     0K  0.0 flush-8:32
  120      R    106K     0K  0.0 ps 
# echo 80 > /sys/kernel/debug/tracing/set_ftrace_pid
BUG: failure at
arch/microblaze/kernel/ftrace.c:202/ftrace_update_ftrace_func()!
Kernel panic - not syncing: BUG!
Stack:
2d179d00: 20010ac8 2f166aa0 2d179d00 ffffff9c 20050898 2f00a0a0 2d179d28
2d179d20
2d179d20: 20004228 20223864 202f0530 00000000 202f0534 00001a0c 00001a0d
2d179d54
2d179d40: 2d179d4c 2d179db8 20297f08 20050f1c 20221ad4 20295a70 ffffffff
00001a0d
2d179d60: 00001a0c 00001a0d 2d179d70 2d179db8 200506a8 20095f08 00000000
2d179d8c
2d179d80: 2d179da0 00000000 2d179e88 2d179d94 20297f08 2005087c 2d179e88
2e800b84
2d179da0: 20097050 00000000 2d179db8 00000000 2d179db4 200509b4 00000004
20097348
2d179dc0: 20094e08 2d179e88 2e800b84 2d179dd0 2d179dd4 20088d10 2d179ddc
20088c04
2d179de0: ffffffd8 00000022 2e800058 20094f44 2d179e00 00000000 2f166aa0
00000000
2d179e00: 20088eb8 00000241 2d179e18 ffffffd8 2e800058 00000242 20095274
2d179e40
2d179e20: 2f166aa0 2d179e88 2e801e94 00000242 ffffff9c 00000241 00000000
00000022
2d179e40: 20098080 20097f34 00000000 2f00a320 2e83bb94 2d179e64 00000000
2d179e64
2d179e60: 00000000 20088a34 00000000 00000000 00000000 00000000 00000000
00000000
2d179e80: 2f00a0a0 2e801e94 2f00a0a0 2e801e94 eaf05cbd 0000000e 2f16701a
2f00a320
2d179ea0: 2e83bb94 00000300 00000000 00000000 2012b2c0 2d179eb8 20096b54
00000000
2d179ec0: 2d179edc 00000003 2f024ec0 2f024ec8 00000003 00000242 000001b6
2f166aa0
2d179ee0: 00000000 00000000 00000000 2d179f14 00000003 2f167000 00000241
000001b6
2d179f00: ffffff9c 2d6383f0 00000000 00000000 00000000 20088b00 ffffff9c
2f167000
2d179f20: 2d65ebe8 000001b6 00000000 00000000 2d179f48 00000000 2d6602fc
2d6603f4
2d179f40: 00000001 00000001 20004b08 00000000 00000001 10000000 00000004
00000000
2d179f60: 2d179f68 2d179f68 000004a0 2d65ec38 2d63cc18 2d65ec6c 2d6603fc
2d6602fc
2d179f80: 00000241 000001b6 00000002 00000050 00000000 2d65ebec 00000005
2d63cc18
2d179fa0: 2d61d35c 2d61c8f0 2014a9b8 00000000 00000000 2d660394 00000000
00000000
2d179fc0: 00000000 2d6602fc 2d6603f4 00000001 00000001 2d6383f0 00000000
00000000
2d179fe0: 00000000 2f645ce0 2d61d360 000004a0 000004a0 000004a0 000004a0
00000000


Call Trace:
[<20002fd0>] microblaze_unwind+0x64/0x90
[<20002bec>] show_stack+0x140/0x184
[<20002c48>] dump_stack+0x18/0x38
[<20010ac4>] panic+0x88/0x228
[<20004224>] ftrace_update_ftrace_func+0xa0/0xfc
[<20050f18>] __ftrace_modify_code+0x50/0xa8
[<200506a4>] ftrace_run_update_code+0x30/0x84
[<20050878>] ftrace_startup_enable+0x44/0x64
[<200509b0>] ftrace_pid_open+0x118/0x184
[<20088d0c>] __dentry_open+0x1b8/0x328
[<20088eb4>] nameidata_to_filp+0x38/0x74
[<2009807c>] do_filp_open+0x498/0x96c
[<20088a30>] do_sys_open+0x88/0xfc
[<20088afc>] sys_open+0x24/0x44
SYSCALL
[<2d61d360>] PID 122 [sh]

Rebooting in 30 seconds..

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



