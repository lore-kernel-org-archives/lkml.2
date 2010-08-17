Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0HQPF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:05:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab0HQPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:05:23 -0400
Date: Tue, 17 Aug 2010 07:58:46 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org, nxz@cypress.com
Subject: Re: FW: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100817145846.GB28926@suse.de>
References: <2CB0953655A24CBEB0D853ECC20F4A8F@stanford.edu>
 <1282001676.4381.52.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282001676.4381.52.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 04:34:36PM -0700, David Cross wrote:
> 
> > On Fri, Aug 13, 2010 at 06:12:43PM -0700, David Cross wrote:
> > > On Fri, 2010-08-13 at 17:25 -0700, Greg KH wrote:
> > > > On Fri, Aug 13, 2010 at 04:22:13PM -0700, David Cross wrote:
> > > > > On Fri, 2010-08-13 at 15:17 -0700, Greg KH wrote:
> > > > > > On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > > > > > > > 
> > > > > > > > What exactly are the performance issues with doing this from
> > userspace,
> > > > > > > > vs. the FAT hack?
> > > > > > > Usually it takes a lot longer. West Bridge can do MTP transfers at
> > the
> > > > > > > performance of the storage device.  Sending the file data through
> > the
> > > > > > > processor is typically much slower.
> > > > > > 
> > > > > > What is "slower" here?  Please, real numbers.
> > > > > Sure, here are some of the numbers I have:
> > > > > Cypress West Bridge   15
> > > > > Blackberry Storm 2    4.6
> > > > > Microsoft Zune        3.8
> > > > > Nokia N97             2.1
> > > > > SEMC W950	      1.1
> > > > > SEMC W995             0.85	
> > > > > Blackberry Storm      0.7
> > > > 
> > > > No, I mean numbers before and after with and without this "hack".
> > > I can provide these, but it will take me some time to implement. I
> > > will have to use the Zoom II platform to benchmark. Any issues with
> > > this approach before I get started?
> > 
> > It's ok, you don't have to do it right now, I'm just curious as to how
> > much speed difference you are seeing here.
> > 
> > As it will be a few weeks before I can even get this into the -next
> > tree, it's not of upmost importance at the moment.
> 
> To give you an idea of the performance difference, even for mass storage
> class which has less protocol involvement, the native software and
> hardware on the platform I am using typically perform at less than 4
> MB/s. I am getting this number from benchmarks of the Motorola Droid
> phone, which uses a similar software and hardware configuration as the
> Zoom 2.

The droid is a bad example as the card reader is known to have hardware
issues so they had to throttle the transfer rate to it down in order to
properly get all types of cards to work properly with it.  So don't use
that as any example of a good hardware design, or how fast things "can"
or "should" go please.

> Yes, sounds great. On one related topic, I can't seem to register gadgetfs with
> our controller driver when the controller is built in the staging tree
> with the latest kernel. I get the error messages:
> 
> gadgetfs: disagrees about version of symbol usb_gadget_unregister_driver
> gadgetfs: Unknown symbol usb_gadget_unregister_driver (err -22)
> 
> Is this the expected behavior for a staging driver? Any workaround you
> know of? I was not able to find much information about this from the
> mailing lists other than "build against the right kernel", which of
> course I am doing.

Totally different issue, try bringing it up on the
linux-usb@vger.kernel.org mailing list please.

> > How are all of the other platforms that use Linux as this type of
> > device, or even a usb-storage device (of which there are lots) able to
> > hit the very fast transfer rates that I have seen so far without needing
> > to do this type of preallocation?
> 
> I think that the usage case is the difference. Mass storage class
> devices expose a block level interface to the USB host and the USB host
> owns the file system. The device here is really a "dumb" device. In the
> case of MTP, the device owns the file system.

Well, it "thinks" it owns the filesystem :)

> I have not seen fast performance over MTP on any embedded Linux system
> as yet. Do you know of any fast MTP responders that work with Linux?

Again, ask this on the linux-usb mailing list, the developers there will
know more.  I'm pretty sure the MeeGo implementation for the next
generation Nokia phones have this all working now, but they might not be
able to post any numbers due to the hardware not being released yet.

> I will implement this as soon as I can get past the registering gadgetfs issue
> mentioned above. If you have pointers on that, it would be great. I will
> plan to submit patches to the current patch once it is in the next tree
> to avoid sending duplicates. Let me know if that is the preferred method
> or if you want me to send updates as I make them.

Updates as you make them as add-on patches are great.  You can base them
on the linux-next tree once the patches go in.

> > > > > 5) depending on the peripheral implementation, data may be buffered
> > > > > either in the peripheral (SD/MMC controller) or in the DMA engine
> > > > > itself.
> > > > 
> > > > Yes, you don't know what is backing that filesystem, that's the big
> > > > issue, just as you don't know what type of filesystem it is, from within
> > > > the kernel.
> > > Can't I pass this information into the driver using the ioctl call? If
> > > the filesystem is not fat and not removable, this driver should likely
> > > not be used, at least not for this purpose.
> > 
> > No, the driver never knows this type of information.  And for good
> > reason, you could have 4 different partitions on this block device, all
> > different filesystems.  The block driver should never care about the
> > filesystem underneath it.
> 
> To clarify, in this case, it is not the block driver which needs this
> information, it would be the gadget peripheral controller driver which
> would get it directly from the protocol stack via ioctl. If mmap works
> and is portable across file systems, this should be a non-issue.

It is.

thanks,

greg k-h
