Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0DPIdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 04:33:01 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37364 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0DPIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 04:32:57 -0400
Message-ID: <4BC820B2.6060604@monstr.eu>
Date: Fri, 16 Apr 2010 10:32:50 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] microblaze: add stack unwinder
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> Implement intelligent backtracing by searching for stack frame creation,
> and emitting only return addresses. Use print_hex_dump() to display the
> entire binary kernel stack.
> 
> Limitation: MMU kernels are not currently able to trace beyond a system trap
> (interrupt, syscall, etc.). It is the intent of this patch to provide
> infrastructure that can be extended to add this capability later.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

First of all it is step to good direction.

Please apply this patch and do the same testing as I did.

diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index a1721a3..76f6587 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -112,8 +112,8 @@ void of_platform_reset_gpio_probe(void)
  void machine_restart(char *cmd)
  {
         printk(KERN_NOTICE "Machine restart...\n");
+       machine_shutdown();
         gpio_system_reset();
-       dump_stack();
         while (1)
                 ;
  }
@@ -121,6 +121,7 @@ void machine_restart(char *cmd)
  void machine_shutdown(void)
  {
         printk(KERN_NOTICE "Machine shutdown...\n");
+       dump_stack();
         while (1)
                 ;
  }


My expectation is that if is called machine_restart then stack will show

kernel_restart
machine_restart
machine_shutdown
microblaze_unwind

but I can see just latest function. Look at logs below + there are some 
my comments.

early_printk_console is enabled at 0x83e00000
Ramdisk addr 0x00000000, FDT at 0x4a000000
Linux version 2.6.34-rc4-00053-gbc6ce8a-dirty (monstr@monstr.eu) (gcc 
version 4.1.2) #42 Fri Apr 16 10:01:05 CEST 2010
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
cache: wt_msr_noirq
setup_memory: Main mem: 0x48000000-0x4a800000, size 0x02800000
setup_memory: kernel addr=0x48000000-0x48358000 size=0x00358000
setup_memory: Main mem: 0x48000000-0x4a800000, size 0x02800000, klimit 
0x48358000
setup_memory: max_mapnr: 0x2800
setup_memory: min_low_pfn: 0x48000
setup_memory: max_low_pfn: 0x4a800
reserved 0 - 0x48000000-0x00358500
reserved 1 - 0x4a7fddc0-0x00002240
On node 0 totalpages: 10240
free_area_init_node: node 0, pgdat 4824aae0, node_mem_map 48359000
   Normal zone: 80 pages used for memmap
   Normal zone: 10160 pages, LIFO batch:0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 10160
Kernel command line: console=ttyUL0,115200
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 37152k/40960k available
Hierarchical RCU implementation.
NR_IRQS:32
xlnx,xps-intc-1.00.a #0 at 0x81800000, num_irq=7, edge=0x53
xlnx,xps-timer-1.00.a #0 at 0x83c00000, irq=4
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Calibrating delay loop... 44.64 BogoMIPS (lpj=223232)
Mount-cache hash table entries: 512
NET: Registered protocol family 16
Switching to clocksource microblaze_clocksource
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Skipping unavailable RESET gpio -2 (reset)
GPIO pin is already allocated
JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
83e00000.serial: ttyUL0 at MMIO 0x83e00003 (irq = 6) is a uartlite
console [ttyUL0] enabled
86000000.flash: Found 1 x16 devices at 0x0 in 16-bit bank
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
  Intel/Sharp Extended Query Table at 0x010A
Using buffer write method
Using auto-unlock on power-up/resume
cfi_cmdset_0001: Erase suspend on write enabled
erase region 0: offset=0x0,size=0x20000,blocks=255
erase region 1: offset=0x1fe0000,size=0x8000,blocks=4
RedBoot partition parsing not available
Device Tree Probing 'ethernet'
TXCSUM 1
RXCSUM 1
xilinx_lltemac 82a80000.ethernet: MAC address is now  0: a:35: 0: 0: 0
xilinx_lltemac 82a80000.ethernet: XLlTemac: using DMA mode.
XLlTemac: Dma base address: phy: 0x84600080, virt: 0x84600080
XLlTemac: buffer descriptor size: 32768 (0x8000)
XLlTemac: Allocating DMA descriptors with kmalloc
XLlTemac: (buffer_descriptor_init) phy: 0x4a060000, virt: 0x4a060000, 
size: 0x8000
XTemac: PHY detected at address 7.
xilinx_lltemac 82a80000.ethernet: eth0: Xilinx TEMAC at 0x82A80000 
mapped to 0x82A80000, irq=5
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 988k freed
Bad inittab entry at line 3
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting sysfs:
Setting hostname:
Setting up interface lo:
Setting up interface eth0:
eth0: XLlTemac: Options: 0x3fa
eth0: XLlTemac: allocating interrupt 2 for dma mode tx.
eth0: XLlTemac: allocating interrupt 3 for dma mode rx.
eth0: XLlTemac: speed set to 100Mb/s
eth0: XLlTemac: Send Threshold = 24, Receive Threshold = 4
eth0: XLlTemac: Send Wait bound = 254, Receive Wait bound = 254
Starting syslogd:
Starting httpd:
Mounting nfs server

uclinux login: root
Password:
/root #
/root #
/root # reboot
The system is going down NOW!
Sent SIGTERM to all processes
TERM
Sent SIGKILL to all processes
Requesting system rRestarting system.
Machine restart...
Machine shutdown...
Stack:
4a059dc8: --48004aec-- 00000008
4a059dd0: 00000000 00000001 0000006d 49734fc8 4a059dec --48004b14-- 
481da68c 4823f318
4a059df0: ffffffff 00001019 00003fff 483459cc --4801f36c-- 481da6a4 
4823f318 ffffffff
4a059e10: 00001003 00003fff 483459cc 4801ffa4 481e0f18 00000000 000005a2 
00000000
4a059e30: 00000000 00000000 28121969 48006a28 00000000 00000000 00000000 
00000000
4a059e50: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
4a059e70: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
4a059e90: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
4a059eb0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
4a059ed0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
4a059ef0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
4a059f10: 00000000 00000000 00000000 48009e8c 00000000 00000000 00000000 
00000000
4a059f30: 00000000 00000000 4a059f44 00000000 00000000 480069dc 00000000 
00000000
4a059f50: 00000000 00000000 00000000 fee1dead 01234567 ffffffff 00000000 
49734a74
4a059f70: 00000000 00000000 0000007d fee1dead 28121969 01234567 00000008 
497160b0
4a059f90: 00000000 28121969 00000058 00000000 4960c998 496eef5c 00000000 
00000000
4a059fb0: 7fffff82 00000000 00000000 00000000 fee1dead 01234567 ffffffff 
00000001
4a059fd0: 00000001 0000006d 49734fc8 49734fc8 00000000 4a3b9930 4960c99c 
000005a0
4a059ff0: 00000000 00000000 000005a0 00000000


Call Trace:
[<48004fd0>] microblaze_unwind+0x74/0x8c


I identify some values (between -- -- in log above) which are correct 
traces but the code doesn't show them. That's why I think that something 
is wrong there.

Thanks,
Michal



Interesting is that my memory dump has some weird values.  Read via XMD. 
(It could be any cache issue)

XMD% mrd 0x4a059dc8 100
4A059DC8:   4A3B9930
4A059DCC:   48004AF4 - machine_shutdown - bad number (should be 48004aec 
as you have in your log - and one line above also)
4A059DD0:   000005A0
4A059DD4:   00000000
4A059DD8:   00000000
4A059DDC:   000005A0
4A059DE0:   00000001
4A059DE4:   48004B14 - machine restart
4A059DE8:   481DA68C
4A059DEC:   4823F318
4A059DF0:   FFFFFFFF
4A059DF4:   00001019
4A059DF8:   00003FFF
4A059DFC:   483459CC
4A059E00:   4801F36C - kernel restart
4A059E04:   481DA6A4
4A059E08:   4823F318
4A059E0C:   FFFFFFFF
4A059E10:   00001003
4A059E14:   00003FFF
4A059E18:   483459CC
4A059E1C:   4801FFA4


Here is objdump

48004acc <machine_shutdown>:
48004acc:	b000481d 	imm	18461
48004ad0:	30a0a68c 	addik	r5, r0, -22900
48004ad4:	3021ffe4 	addik	r1, r1, -28
48004ad8:	f9e10000 	swi	r15, r1, 0
48004adc:	b0000000 	imm	0
48004ae0:	b9f4a98c 	brlid	r15, -22132	// 4800f46c <printk>
48004ae4:	80000000 	or	r0, r0, r0
48004ae8:	b000ffff 	imm	-1
48004aec:	b9f4ff80 	brlid	r15, -128	// 48004a6c <dump_stack>
48004af0:	80000000 	or	r0, r0, r0
48004af4:	b8000000 	bri	0		// 48004af4

48004af8 <machine_restart>:
48004af8:	b000481d 	imm	18461
48004afc:	30a0a6a4 	addik	r5, r0, -22876
48004b00:	3021ffe4 	addik	r1, r1, -28
48004b04:	f9e10000 	swi	r15, r1, 0
48004b08:	b0000000 	imm	0
48004b0c:	b9f4a960 	brlid	r15, -22176	// 4800f46c <printk>
48004b10:	80000000 	or	r0, r0, r0
48004b14:	b9f4ffb8 	brlid	r15, -72	// 48004acc <machine_shutdown>
48004b18:	80000000 	or	r0, r0, r0
48004b1c:	b0004834 	imm	18484
48004b20:	e8c053a4 	lwi	r6, r0, 21412	// 483453a4 <reset_val>
48004b24:	b0004834 	imm	18484
48004b28:	e8a053a0 	lwi	r5, r0, 21408	// 483453a0 <handle>
48004b2c:	b000000e 	imm	14
48004b30:	b9f4f0c8 	brlid	r15, -3896	// 480f3bf8 <__gpio_set_value>
48004b34:	34c60001 	rsubik	r6, r6, 1
48004b38:	b8000000 	bri	0		// 48004b38


4801f330 <kernel_restart>:
4801f330:	3021ffe0 	addik	r1, r1, -32
4801f334:	fa61001c 	swi	r19, r1, 28
4801f338:	f9e10000 	swi	r15, r1, 0
4801f33c:	b9f4ff5c 	brlid	r15, -164	// 4801f298 <kernel_restart_prepare>
4801f340:	12650000 	addk	r19, r5, r0
4801f344:	b000481e 	imm	18462
4801f348:	30a00f18 	addik	r5, r0, 3864
4801f34c:	be130038 	beqid	r19, 56		// 4801f384
4801f350:	10d30000 	addk	r6, r19, r0
4801f354:	b000481e 	imm	18462
4801f358:	30a00f30 	addik	r5, r0, 3888
4801f35c:	b000ffff 	imm	-1
4801f360:	b9f4010c 	brlid	r15, 268	// 4800f46c <printk>
4801f364:	80000000 	or	r0, r0, r0
4801f368:	b000fffe 	imm	-2
4801f36c:	b9f4578c 	brlid	r15, 22412	// 48004af8 <machine_restart>
4801f370:	10b30000 	addk	r5, r19, r0
4801f374:	e9e10000 	lwi	r15, r1, 0
4801f378:	ea61001c 	lwi	r19, r1, 28
4801f37c:	b60f0008 	rtsd	r15, 8
4801f380:	30210020 	addik	r1, r1, 32
4801f384:	b000ffff 	imm	-1
4801f388:	b9f400e4 	brlid	r15, 228	// 4800f46c <printk>
4801f38c:	80000000 	or	r0, r0, r0
4801f390:	b800ffd8 	bri	-40		// 4801f368


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
