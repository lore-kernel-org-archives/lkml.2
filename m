Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1APJJC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 04:09:02 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51565 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1APJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 04:08:55 -0500
Message-ID: <4D32B5A2.1070508@monstr.eu>
Date: Sun, 16 Jan 2011 10:08:50 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu> <8739oyza2n.fsf@macbook.be.48ers.dk>
In-Reply-To: <8739oyza2n.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

sorry for delay. I had to look at another issue.

Below is full log:
1. I setup baudrate to 50. (It could be possible to set it up to 0 too)
That's why I think that doesn't matter what baudrate is setup.

2. You see where ulite_startup is called. It is called only once.

3. You see that there is no call __uart_wait_until_sent(). It could be 
called for ASYNC mode. The second thing is __uart_wait_until_sent 
function is checking if tx fifo is empty not circ buffer is empty.

4. Next thing is that in uart_close. port->count is 2 which means that
the executing path is
	if (port->count) {
		spin_unlock_irqrestore(&port->lock, flags);
		goto done;
	}
which means that there is no chance to call __uart_wait_until_sent 
function anyway.

5. I did one modification to add simple while loop till circ buffer is 
empty to the same location to see what happen (timouts are bogus values).

if (port->count) {
	spin_unlock_irqrestore(&port->lock, flags);
	printk("************ %x %x\n", (&uport->state->xmit)->tail, 
(&uport->state->xmit)->head);
	while (!uart_circ_empty(&uport->state->xmit)) {
		msleep_interruptible(jiffies_to_msecs((uport->timeout - HZ/50)));
		if (signal_pending(current))
			break;
		if (time_after(jiffies, jiffies + uport->timeout))
			break;
	}
	printk("************\n");
	goto done;
}

Here is log: (Between **** you can see what chars are not printed)

NET: Registered protocol family 17
uart_open(0) called
ulite_startup ------------------------
Freeing unused kernel memory: 11235k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting sysfs:
mdev: initialising /dev
Mounting /etc/config:
Populating /etc/config:
flatfsd: Created 8 configuration files (168 bytes)
Mounting denet eth0: Promiscuous mode disabled.
vpts:
Setting hostname:
Bringing up network interfaces:
udhcpc (v1.14.3) started
Sending discover...
Sending seuart_open(0) called
lect for 192.168uart_close(0) called, port->count 2
************ 172 362
.0.100...
Lease of 192.168.0.100 obtained, lease time 7200
adding dns 172.16.0.5
adding dns 172.16.10.1
Starting portmap:

Welcome to
  _____       _           _      _
| ___ \     | |         | |    (_)
| |_/ / ___ | |_   __ _ | |     _  _ __   _   _ __  __
|  __/ / _ \| __| / _` || |    | || '_ \ | | | |\ \/ /
| |   |  __/| |_ | (_| || |____| || | | || |_| | >  <
\_|    \___| \__| \__,_|\_____/|_||_| |_| \__,_|/_/\_\

on Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm

************
uart_open(0) called
uart_flush_buffer(0) called

Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm login:



I think that will be good to check if circ buffer is empty. As you 
suggest uart_close function will be probably the best place.

Any other suggestion?

Thanks,
Michal




Full log with debug messages:

Linux version 2.6.37-00014-g85eb775-dirty (monstr@monstr.eu) (gcc 
version 4.1.2) #15 Sun Jan 16 08:43:08 CET 2011
less 8
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
cache: wt_msr_noirq
setup_memory: max_mapnr: 0x8000
setup_memory: min_low_pfn: 0x48000
setup_memory: max_low_pfn: 0x50000
On node 0 totalpages: 32768
free_area_init_node: node 0, pgdat c029f0b8, node_mem_map c0dab000
   Normal zone: 256 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 32512 pages, LIFO batch:7
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: console=ttyUL0,50
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 115776k/131072k available
NR_IRQS:32
xlnx,xps-intc-1.00.a #0 at 0xc8000000, num_irq=8, edge=0x93
xlnx,xps-timer-1.00.a #0 at 0xc8004000, irq=4
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Calibrating delay loop... 43.90 BogoMIPS (lpj=87808)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource microblaze_clocksource
microblaze_timer_set_mode: oneshot
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
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
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
84400000.debug: ttyUL0 at MMIO 0x84400000 (irq = 7) is a uartlite
console [ttyUL0] enabled
Xilinx SystemACE device driver, major=254
86000000.flash: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer 
ID 0x000089 Chip ID 0x008919
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
Creating 6 MTD partitions on "86000000.flash":
0x000000000000-0x000000100000 : "fpga"
0x000000100000-0x000000140000 : "boot"
0x000000140000-0x000000160000 : "bootenv"
0x000000160000-0x000000180000 : "config"
0x000000180000-0x000000b80000 : "image"
0x000000b80000-0x000002000000 : "spare"
Xilinx TEMAC MDIO: probed
eth0: Dropping NETIF_F_SG since no checksum feature.
TCP cubic registered
NET: Registered protocol family 17
uart_open(0) called
ulite_startup ------------------------
Freeing unused kernel memory: 11235k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting sysfs:
mdev: initialising /dev
Mounting /etc/config:
Populating /etc/config:
flatfsd: Created 8 configuration files (168 bytes)
Mounting devpnet eth0: Promiscuous mode disabled.
ts:
Setting hostname:
Bringing up network interfaces:
udhcpc (v1.14.3) started
Sending discover...
Sending seluart_open(0) called
ect for 192.168.uart_close(0) called
uart_open(0) called
uart_flush_buffer(0) called

Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm login:




Peter Korsgaard wrote:
>>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:
> 
> Hi,
> 
>  Michal> The point is that clearing is called but there are still some
>  Michal> characters which are not printed. If you call that clearing you
>  Michal> just lost the part of log.
> 
> Yes, but it shouldn't happen as __uart_wait_until_sent() is called
> first.
> 
>  >> What is the problem here? Is it that the uart gets closed and reopened
>  >> (which causes ulite_startup() to get called)
>  Michal>  while there's still data in
>  >> the uarts internal tx fifo (which then gets discarded)
> 
>  Michal> No data in internal tx fifo are not discarded.
> 
> It is if ulite_startup is called.
> 
>  Michal> , or is it that
>  >> there's still data in the sw xmit circular buffer that isn't sent to the
>  >> hardware yet?
> 
>  Michal> yes, data are in the circ buffer head and tail are correctly setup and
>  Michal> because sending is slow that circ buffer clearing is called and head
>  Michal> and tail is zeroed.
>  Michal> I think the best solution will be to wait if head/tail is not the same
>  Michal> value which means there is data in circ buffer. Not sure if driver can
>  Michal> do anything with it or if there is any way how to delay buffer
>  Michal> clearing in the driver.
> 
> I don't know much of the details of serial_core, but I believe
> uart_close (and hence uart_circ_clear) is only called when all
> characters in the circular buffer have been sent. What still might not
> be sent is any data in the uart TX fifo, but __uart_wait_until_sent()
> should handle that if you provide correct baudrate.
> 
>  >> What baudrate is your hardware running at?  What baudrate have you
>  >> configured the kernel to use? Even though the uartlite itself doesn't do
>  >> anything with the baudrate setting (E.G. it is fixed in hardware), the
>  >> baudrate is used by the kernel to calculate timeouts (E.G. in
>  >> __uart_wait_until_sent and similar).
> 
>  Michal> It is the same style. You can't even setup baudrate in EDK. There is
>  Michal> no hardware connection through serial line. The whole communication is
>  Michal> done through jtag. I really don't know how fast xilinx can communicate
>  Michal> with mdm.
> 
> Ok, does behaviour change if you set the kernel baudrate to something
> really low (300bps or so)? Also don't forget to adjust your getty
> settings!
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
