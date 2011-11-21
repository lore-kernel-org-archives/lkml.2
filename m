Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1KUPGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:06:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36182 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1KUPGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:06:44 -0500
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com> <20111118222718.GF22904@local>
In-Reply-To: <20111118222718.GF22904@local>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=utf-8
Message-Id: <C27E2EE4-3534-4FC2-997A-0F090BF2AAF5@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: gregkh@suse.de, tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Date: Mon, 21 Nov 2011 10:10:45 -0500
To: "Hans J. Koch" <hjk@hansjkoch.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 18, 2011, at 17:27, Hans J. Koch wrote:

> On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
>> Hello fellow hackers.
> 
> Hi. Could you please limit the line length of your mails to something less
> than 80 chars?
hehe, I don't think I have ever managed line length of regular talk in mails I have sent.
I read and write from mail clients that line wrap for me, (mac mail right now, please don't
judge me... I still make contributions to the kernel!! :)
> 
>> 
>> I am maintaining a UIO based driver for a PCI-E data acquisition device.
> 
> Can you post it? No point in discussing non-existent code...
Well, the code does exist, but the driver drive's a pci device which is only found in
a product we sell. The pci ID we use is not registered, and except for this driver, which
is a non-driver really (UIO), the FPGA firmware and the userspace code is proprietary.

I have no problem sharing the code that runs in the kernel and will send a patch for you to
review, but contrary to other contributions I make to w1 or i2c device drivers, I never expect
this code to make it into the mainline. For this reason, as well as the fact it is my very first
kernel code project, it is quite non-conforming to the kernel standards in many respects
(line length, symbol names, etc.)
> 
>> 
>> I map BAR0 of the device to userspace. I also map two memory areas, one is used to feed instructions to the acquisition device, the other is used autonomously by the PCI device to write the acquired data.
>> 
>> The strategy we have been using for those two share memory areas has historically been using pci_alloc_coherent on v2.6.35 x86_64 (limited to 4MB based on my trials) and later, I made use of the VT-d (intel_iommu) to allocate as much as 128MB (an arbitrary limit) which appear contiguous to the PCI device. I use vmalloc_user to allocate 128M, then write all the physically continuous segments in a scatterlist, then use pci_map_sg which works it's way to intel_iommu. The device DMA addresses I get back are contiguous over the whole 128M. Neat! Our VT-d capable devices still use this strategy.
>> 
>> This large memory is mission-critical in making the acquisition device autonomous (real-time), yet keep the DMA implementation very simple. Today, we are re-using this device on a CPU architecture that has no IOMMU (intel E6XX/EG20T) and want to avoid creating a scatter-gather scheme between my driver and the FPGA (PCI device).
>> 
>> So I went back to the old pci_alloc_coherent method, which although limited to 4 MB, will do for early development phases. Instead of 2.6.35, we are doing preliminary development using 2.6.37 and will probably use 3.1 or more later.  The cpu/device shared memory maps (1MB and 4MB) are allocated using pci_alloc_coherent and handed to UIO as physical memory using the dma_addr_t returned by the pci_alloc func.
>> 
>> The 1st memory map is written to by CPU and read from device.
>> The 2nd memory map is typically written by the device and read by the CPU, but future features may have the device also read this memory.
>> 
>> My initial testing on the atom E6XX show the PCI device failing when trying to read from the first memory map.
> 
> Any kernel messages in the logs that could help?
My FPGA engineer is currently instrumenting the firmware to see what is happening.

I guess when we figure why the FPGA cannot read the system RAM, I am still stuck with the small 4MB buffer...
any thoughts how to get way more without the use of a device side IOMMU?
> 
> [...]
> 
> Thanks,
> Hans
Thanks for your help!
(hope my manual line length management helped you! ;)
/jfd