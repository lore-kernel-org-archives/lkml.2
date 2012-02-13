Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2BMOUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:20:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35300 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2BMOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:20:20 -0500
Message-ID: <4F391C1D.9020402@monstr.eu>
Date: Mon, 13 Feb 2012 15:20:13 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com> <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com> <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com> <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
In-Reply-To: <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Ohad Ben-Cohen wrote:
> On Thu, Jan 26, 2012 at 12:44 PM, Michal Simek <monstr@monstr.eu> wrote:
>> I have one small problem which is that physical address is 0x10000000
>> which means that firmware entry point is the same.
> 
> This is what we do with the davinci DSPs, too.
> 
>> In rproc_load_segments is da composed from phdr->p_paddr which is
>> 0x10000000.
> 
> Ok, I don't see any issue here.
> 
>> And code is designed that this load addr is offset.
> 
> Not sure exactly what do you mean by that ?
> 
>> Here is the code:
>>        /* go through the available ELF segments */
>>        for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
>>                u32 da = phdr->p_paddr; // OFFSET 0x10000000
>>                u32 memsz = phdr->p_memsz;
>>
>> But for my case is physical address correct and it is not offset 0x10000000.
> 
> Again, I'm not sure what exactly is the issue. p_paddr is the physical
> address where the image is expected, that sounds ok to me.

sorry for delay. I was working on different issue.
I have solved this issue by using ram address ranges 0x0 - 0x10000000.

I am using CONFIG_PHYS_OFFSET=0x10000000 in linux which give me free space for rtos.

Here is how it is achieve
	ret = dma_declare_coherent_memory(&zynq_freertos.dev, 0,
				0, 0x10000000, DMA_MEMORY_MAP);

which is fully compatible with remoteproc.
I have also got trace buffer to work - there were problem with caches on cpu with rtos.

I still have the problem to reset cpu1 but we are investigating how to do so. Maybe in future
we will add new message which jumps back to bootloader code if not possible to do it throuth any


I have looked at omap remoteproc and there is communication between cocpu through omap mbox
and IRQs. I am working on similar communication for testing
and I would like to know how vrings fit to this. Do you have any example of using it?


struct resource __resource resources[] = {
     { TYPE_CARVEOUT, 0, TEXT_BASE + 0,    0, 0, 0, SZ_1M, 0, 0,0,0,0,"IPU_MEM_TEXT"},
     { TYPE_VIRTIO_DEV,0, TEXT_BASE + 0,   0, 0, 0, SZ_1M, VIRTIO_ID_RPMSG,0,0,0,0,"vdev:rpmsg"},

     { TYPE_VRING, 0, TEXT_BASE + 0x20000, 0, 0, 0, VQ0_SIZE,0,0,0,0,0,"vring:sysm3->mpu"},
     { TYPE_VRING, 1, TEXT_BASE + 0x30000, 0, 0, 0, VQ1_SIZE,0,0,0,0,0,"vring:mpu->sysm3"},
     { TYPE_TRACE, 0, TEXT_BASE + 0x40000, 0, 0, 0, 0x8000, 0,0,0,0,0,"trace:sysm3"},
};

Below is my full bootup log.

Thanks,
Michal


Linux version 3.3.0-rc1+ (monstr@monstr.eu) (gcc version 4.5.1 (Sourcery G++ Lite 2010.09-62) ) #355 PREEMPT Mon Feb 13 15:10:48 CET 2012
CPU: ARMv7 Processor [410fc090] revision 0 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: Xilinx Zynq Platform, model: ZC702_jason
bootconsole [earlycon0] enabled
vmalloc_min ef800000, PAGE_OFFSET c0000000
Ignoring RAM at 00000000-0fffffff (vmalloc region overlap).
vmalloc_min ef800000, PAGE_OFFSET c0000000
dma_contiguous_reserve(limit 20000000)
dma_contiguous_reserve: total available: 256 MiB, size absolute: 1 MiB, size percentage: 0 MiB
dma_contiguous_reserve: reserving 1 MiB for global area
dma_declare_contiguous(size 100000, base 00000000, limit 20000000)
cma: CMA: reserved 8 MiB at 1f800000
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line:  console=ttyPS0,115200 earlyprintk
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 256MB = 256MB total
Memory: 243984k/243984k available, 18160k reserved, 0K highmem
Virtual kernel memory layout:
     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
     modules : 0xbf000000 - 0xc0000000   (  16 MB)
       .text : 0xc0008000 - 0xc0283000   (2540 kB)
       .init : 0xc0283000 - 0xc0753000   (4928 kB)
       .data : 0xc0754000 - 0xc076c0c0   (  97 kB)
        .bss : 0xc076c0e4 - 0xc07774c0   (  45 kB)
NR_IRQS:246
xlnx,ps7-ttc-1.00.a #0 at 0xd0800000, irq=43
Calibrating delay loop... 2531.32 BogoMIPS (lpj=12656640)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 1 counters available
Setting up static identity map for 0x101cc918 - 0x101cc94c
devtmpfs: initialized
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
L2x0 series cache controller enabled
l2x0: 8 ways, CACHE_ID 0x00000000, AUX_CTRL 0x02060000, Cache size: 524288 B
hw-breakpoint: debug architecture 0x0 unsupported.
Switching to clocksource xttcpss_timer1
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
msgmni has been set to 492
e0001000.serial: ttyPS0 at MMIO 0xe0001000 (irq = 82) is a xuartps
console [ttyPS0] enabled, bootconsole disabled
console [ttyPS0] enabled, bootconsole disabled
GEM: BASEADDRESS hw: e000b000 virt: d0806000
XEMACPS mii bus: probed
GEM: phydev ceaf7800, phydev->phy_id 0x1410cc2, phydev->addr 0x7
GEM: MAC addr 00:b0:00:e0:ff:bf
eth0, pdev->id -1, baseaddr 0xe000b000, irq 54
eth0, phy_addr 0x7, phy_id 0x01410cc2
eth0, attach [Generic PHY] phy driver
zynq-rproc zynq-rproc.1: zynq_rproc_probe
zynq-rproc zynq-rproc.1: cpu1_freertos is available
zynq-rproc zynq-rproc.1: Note: remoteproc is still under development and considered experimental.
zynq-rproc zynq-rproc.1: THE BINARY FORMAT IS NOT YET FINALIZED, and backward compatibility isn't yet guaranteed.
rpmsg_init
rpmsg_probe
zynq-rproc zynq-rproc.1: powering up cpu1_freertos, firmware test
zynq-rproc zynq-rproc.1: Booting fw image test, size 203250
zynq-rproc zynq-rproc.1: iommu not found
zynq-rproc zynq-rproc.1: rsc: type 0, da 0x0, pa 0x0, len 0x100000, id 0, name IPU_MEM_TEXT, flags 0
zynq-rproc zynq-rproc.1: rsc: type 4, da 0x0, pa 0x0, len 0x100000, id 0, name vdev:rpmsg, flags 7
zynq-rproc zynq-rproc.1: rsc: type 3, da 0x20000, pa 0x0, len 0x100, id 0, name vring:sysm3->mpu, flags 0
zynq-rproc zynq-rproc.1: rsc: type 3, da 0x30000, pa 0x0, len 0x100, id 1, name vring:mpu->sysm3, flags 0
zynq-rproc zynq-rproc.1: rsc: type 2, da 0x40000, pa 0x0, len 0x8000, id 0, name trace:sysm3, flags 0
zynq-rproc zynq-rproc.1: phdr: type 1 da 0x0 memsz 0x1be80 filesz 0x1509c
zynq-rproc zynq-rproc.1: zynq_rproc_start
zynq-rproc zynq-rproc.1: zynq_device_enable Enable device - it means jump
zynq-rproc zynq-rproc.1: remote processor cpu1_freertos is now up
zynq-rproc zynq-rproc.1: zynq_rproc_kick vqid 0
zynq_mbox_msg_send 1
virtio_rpmsg_bus virtio0: rpmsg host is online
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 40
VFP support v0.3: implementor 41 architecture 3 part 40 variant 0 rev 0
Registering SWP/SWPB emulation handler
Freeing init memory: 4928K
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting debugfs:
Mounting sysfs:
mdev: initialising /dev
mdev: Registering hotplug handler
/proc/mtd doesn't exist. Will not create /dev/flash/* device nodes
Mounting devpts:
Setting hostname:
Bringing up network interfaces:
GEM: lp->tx_bd cf841000 lp->tx_bd_dma 1f841000 lp->tx_skb ceb3bbc0
GEM: lp->rx_bd cf840000 lp->rx_bd_dma 1f840000 lp->rx_skb ceb3bac0
GEM: MAC 0xe000b000, 0x0000bfff, 00:b0:00:e0:ff:bf
Starting portmap:

Welcome to
  _____       _           _      _
| ___ \     | |         | |    (_)
| |_/ / ___ | |_   __ _ | |     _  _ __   _   _ __  __
|  __/ / _ \| __| / _` || |    | || '_ \ | | | |\ \/ /
| |   |  __/| |_ | (_| || |____| || | | || |_| | >  <
\_|    \___| \__| \__,_|\_____/|_||_| |_| \__,_|/_/\_\

on zynq-silicon


zynq-silicon login: root
Password:









-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
