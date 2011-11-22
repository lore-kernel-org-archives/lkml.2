Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1KVPUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:20:18 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41744 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1KVPUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:20:16 -0500
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com> <20111118220849.GA25205@suse.de> <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com> <20111121173620.GA5028@suse.de> <20111121181724.GB12011@local>
In-Reply-To: <20111121181724.GB12011@local>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Greg KH <gregkh@suse.de>, tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Date: Tue, 22 Nov 2011 10:24:17 -0500
To: "Hans J. Koch" <hjk@hansjkoch.de>, mst@redhat.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 21, 2011, at 13:17, Hans J. Koch wrote:

> On Mon, Nov 21, 2011 at 09:36:20AM -0800, Greg KH wrote:
>> On Mon, Nov 21, 2011 at 10:31:07AM -0500, Jean-Francois Dagenais wrote:
>>> Hi Greg, thanks for your answer...
>>> 
>>> On Nov 18, 2011, at 17:08, Greg KH wrote:
>>> 
>>>> On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
>>>>> Hello fellow hackers.
>>>>> 
>>>>> I am maintaining a UIO based driver for a PCI-E data acquisition device.
>>>>> 
>>>>> I map BAR0 of the device to userspace. I also map two memory areas,
>>>>> one is used to feed instructions to the acquisition device, the other
>>>>> is used autonomously by the PCI device to write the acquired data.
>>>> 
>>>> Nice, have a pointer to your driver anywhere so we can include it in the
>>>> main kernel tree to make your life easier?
>>> As I said in a parallel answer from "Hans J. Koch" <hjk@hansjkoch.de>,
>>> the driver, although GPL'ed, is quite uninteresting except for us here at
>>> Sonatest.
>> 
>> I really doubt that,
> 
> So do I. We never had a driver allocating so much memory.
> 
>> and you should submit it anyway to allow us to
>> change it when the in-kernel apis change in the future.  It will save
>> you time in the long run and make things easier for you (look, your
>> driver is automatically included in all distros!, people fix your bugs,
>> etc.)
> 
> Exactly.
> 
>> 
>>> About merging the driver to mainline, I guess it would only be interesting for
>>> the recipe I demonstrate. Please advise.
>> 
>> That is a recipe that I'm sure others will use, and need help on in the
>> future.
> 
> They already needed it in the past, and they usually try to get it by
> writing me private mail.
> 
>> 
>> So please submit a patch, that will make it easier to help you out.
> 
> Yes, please do. The more different drivers we have under /drivers/uio, the
> better. Didn't you use one of the existing drivers as a template for yours?
Of course, and I am making contributions to the kernel as well (ds1wm,  w1_ds2408,
ad714x, and more to be merged contribs to blackfin list drivers) because I strongly
believe in the community aspect of Linux.

So in the spirit of making the driver more generic, I would like to make this patch
something along the lines of a generic uio/pci based large DMA acquisition device
driver. Or maybe even complementing the existing uio_generic_pci.c?

The problem is that there are device specific aspects that the "generic" driver would
need to take into account, e.g. to map BARx or not, or in our case, there are MFDs
embedded in the firmware (xilinx's ds1wm core, and soon, xilinx's spi core). Furthermore,
I want the FPGA to be an irq expander since the cores generate interrupts, and a
couple of balls on the FPGA are irq signals from external i2c chips.

I don't yet see any way to specify like a setup callback function that could reach a
platform module when uio_pci_generic is probing.

I am thinking this through as I write here...

My other persona (C++ programmer) suggests that conceptually, uio_pci_generic is
a "base class" and the other more firmware specific items would be in a derived module.
In that sense, maybe uio_pci_generic could export it's symbols? So it can be used as
uio core functionnality?

So I would still have a module which would contain the specific MFD registration and IRQ
functionnality, but the BARx and large DMA mapping would reside in uio_pci_generic...

Any thoughts?
> 
> Thanks,
> Hans
Cheers,
/jfd