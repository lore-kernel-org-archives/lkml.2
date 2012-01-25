Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2AYMlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:41:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43787 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2AYMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:41:23 -0500
Message-ID: <4F1FF870.3000105@monstr.eu>
Date: Wed, 25 Jan 2012 13:41:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
In-Reply-To: <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

I have also copied Arnd and Grant.

>> Hi,
>>
>> I have a question how to setup resource table to support firmware loading
>> to specific memory location.
>> I have allocated the part of ram which is at physical address 0x0
>> which coprocessor needs for rtos code.
> 
> Can you specify about your allocation a bit more ? size ? method of
> allocation (CMA/external ram+ioremap/other) ?
 >
>> Currently I am using carveout with setup size but from rproc_handle_carveout
>> is __dma_alloc_buffer which is remapped by __dma_alloc_remap function to any
> 
> oh, so you're < ARMv6 (no CMA). you'd need to set aside some coherent
> memory for your device then.

First of all will be the best to describe what we want to achieve.
We have Zynq platform ARM Cortex-A9(which should be ARMv7 - 2cpus).
cpu0 runs Linux and cpu1 will be used for real-time os. We would like to use
remoteproc for loading any code(firmware if you like) for the cpu1 and start it.
We haven't got hw yet but I believe that it should be possible also control cpu1 from cpu0
like restart/shutdown/etc. I am using QEMU for developing.

What I have done?
I have created simple asm application which write char to the second unused/unprobed uart.
Entry point for this application is at physical address 0.
I have also added resource_table to elf to satisfy remoteproc core.

Elf file type is EXEC (Executable file)
Entry point 0x0
There are 2 program headers, starting at offset 52

Program Headers:
   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
   LOAD           0x008000 0x00000000 0x00000000 0x00208 0x00208 RWE 0x8000
   GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x4

  Section to Segment mapping:
   Segment Sections...
    00     .text .resource_table
    01


Here is my resource table copied from sysbios-rpmsg (I didn't care about names)

struct resource resources[] = {
     { TYPE_VIRTIO_DEV,0, 0 ,0, 0,0,SZ_1M,VIRTIO_ID_RPMSG,0,0,0,0,"vdev:rpmsg"},
     { TYPE_VRING, 0, 0x100, 0, 0, 0,VQ0_SIZE,0,0,0,0,0,"vring:sysm3->mpu"},
     { TYPE_VRING, 1, 0x200, 0, 0, 0,VQ1_SIZE,0,0,0,0,0,"vring:mpu->sysm3"},
     { TYPE_CARVEOUT, 0, 0x0, 0, 0, 0, SZ_1M, 0, 0,0,0,0,"IPU_MEM_TEXT"},
     { TYPE_TRACE, 0, 0x00001234,0,0,0, 0x8000, 0,0,0,0,0,"trace:sysm3"},
};

TRACE buffer is there just to know how this can work.
VIRTIO_DEV should be necessary value
VRING0/VRING1 - I haven't look at it just to keep there for test.
+ one carveout with 1MB size.

Carveout is allocated by dma code and remapped to 0xffc00000.

Then in zynq_rproc_kick I copy content of this 1MB carveout to 0x0 physical address
+ start the second cpu.

I have tested this and it is working.
The main my problem is that firmware base addr must be at the beginning of address space
or selected address but it is fixed and known.

I have no problem to use mem allocators or techniques which you recommend me to ensure this limitation.

>> Coprocessor can directly access memory of the main cpu.
> 
> That's fine: remoteproc supports these cases, and does not require an IOMMU.

ok. How do you handle limitations if coprocessor expect code on any address?

> 
> We also successfully tested this with davinci, which does not have an IOMMU.

 From my debug logs and my hacks I see that it is possible do it even in my brutal case.

> 
> Looping in Mark, who did the davinci remoteproc support, and might
> have the code available to share. Hopefully we'd have the patches
> posted soon, and then no-iommu platforms could just use them for
> reference.

ok. great. Will look forward for that code and recommendation because I am ARM newbie.

If future I believe we will support to load firmware to Microblaze or better for us
load firmware from Microblaze to ARM.

I am also interested in suggestions about DTS binding. Have someone tried to describe it or use it?

Thanks,
Michal

P.S.: Please let me know, if someone has any example running remoteproc on Qemu.


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
