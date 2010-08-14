Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0HNAoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:44:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:52716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab0HNAoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:44:22 -0400
Date: Fri, 13 Aug 2010 17:25:14 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org, nxz@cypress.com
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100814002514.GA3182@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
 <20100813175402.GA15024@suse.de>
 <1281724992.12189.16.camel@odc-laptop>
 <20100813190128.GA1372@suse.de>
 <1281727059.16672.20.camel@odc-laptop>
 <20100813192826.GA5078@suse.de>
 <1281731535.29175.17.camel@odc-laptop>
 <20100813221749.GA19569@suse.de>
 <1281741733.22119.20.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281741733.22119.20.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 04:22:13PM -0700, David Cross wrote:
> On Fri, 2010-08-13 at 15:17 -0700, Greg KH wrote:
> > On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > > > 
> > > > What exactly are the performance issues with doing this from userspace,
> > > > vs. the FAT hack?
> > > Usually it takes a lot longer. West Bridge can do MTP transfers at the
> > > performance of the storage device.  Sending the file data through the
> > > processor is typically much slower.
> > 
> > What is "slower" here?  Please, real numbers.
> Sure, here are some of the numbers I have:
> Cypress West Bridge   15
> Blackberry Storm 2    4.6
> Microsoft Zune        3.8
> Nokia N97             2.1
> SEMC W950	      1.1
> SEMC W995             0.85	
> Blackberry Storm      0.7

No, I mean numbers before and after with and without this "hack".

> > > This is similar to the applications I have worked
> > > with. The driver is not attempting to replace either the protocol stack
> > > or the use of gadgetfs. All that it is providing is a gadget peripheral
> > > controller driver (that can be used with gadgetfs) along with the
> > > ability to perform pre-allocation and allow for direct transfer.
> > 
> > It's that "pre-allocation" that is the issue.
> Ack.
> 
> > > I re-checked this stack once again to make sure that it had not
> > > fundamentally changed and it seems not to have. What it uses is a
> > > storageserver abstraction to the file system. At the low level this is
> > > still operating on files at the level of open(), read(), write(),
> > > close(). There is no alloc() in the list that I can see. So, I agree
> > > that there is a working stack. As you can tell, the driver is not
> > > attempting to re-create or replace this working stack.  
> > 
> > To "preallocate" a file, just open it and then mmap it and write away,
> > right?  Why can't userspace do that?
> To do this from userspace in entirety, the CPU needs access to the data
> in memory so that it can pass a pointer to the fwrite call. 

That's a stream, not mmap.  What's wrong with mmap?  That should provide
what you are looking for here, right?

> In this case, the data never gets to the processor, it is written
> directly to the storage by West Bridge. We did do some experiments in
> user space to try and get this done. If I recall correctly, this
> resulted in zeros being written to all blocks. I am copying Nelson
> Zhang, who did this testing. He can comment more on the impediments to
> this implementation.

I would be interested in finding out what the problem was here.

> > All while trying to transfer a file to the device over the USB
> > connection?  There's no reason you can't slow down the transfer if the
> > user is doing something else, right?
> Yes, you can slow it down, but that may not be the best solution. Eg, if
> you want to sync a movie to your mobile device before catching a flight,
> you probably don't want to wait three times as long to get it done and
> onto the airport shuttle.

Wee, contrived user interaction senarios, I can do that too!

What happens if the user wants to download a file, and stream a 3g viop
call at the same time he is running to catch that airport shuttle and is
trying to listen to the navigation guides which is reading the gps chip
stream and guiding him to the nearest bus stop?  :)

Sorry, this isn't a valid thing to be arguing at this point in time.
Hacks like this in places you shouldn't be doing things, are not
allowed.

> > > If so, do you agree with Christoph's feedback concerning the
> > > implementation? Could I add hooks to other file systems and leave them
> > > unpopulated?
> > 
> > ntfs is done by using a FUSE filesystem in userspace on a "raw" block
> > device.  You can't put that type of support in the kernel here :)
> Fair, but to support the removable media model, I don't really need to.
> What if I put a check in the code to verify that the media is removable
> and vfat compatible before executing the fat_get_block call?

You can't rely on that flag, sorry, it doesn't work with real-world
devices.

And I have removable media right here, that shipped to me formatted as
NTFS, so that is a valid model today.

> > Look at how filesystems work from userspace, they achieve _very_ fast
> > speeds due to mmap and friends.  Heck, some people try to get the OS out
> > of the way entirely by just using direct I/O, or taking to the raw block
> > device.  Not by trying to allocate raw filesystem blocks from userspace,
> > that way lies madness.
> Well, it is not really the filesystem that necessarily bottlenecks the
> performance. It is usually that in combination with the hardware data
> path that this usage implies. If you want to sync a phone without a
> sideloading accelerator, the data path taken is usually as follows:
> 
> 1) data received by USB peripheral, typically into fifos
> 2) cpu gets interrupted, sees that data is there
> 3) cpu sets up DMA transfer to SDRAM to cache data
> 4) At some point CPU initiates DMA transfer from SDRAM to removable
> media.

Wait, step 4 is a big jump.  Userspace should be reading that data, and
then writing it back out to a file it opened, not this "dma directly to
media" stuff.

And yes, you can stream it if you want from userspace to the file if
that's faster, but odds are mmap() will work best here.

> 5) depending on the peripheral implementation, data may be buffered
> either in the peripheral (SD/MMC controller) or in the DMA engine
> itself.

Yes, you don't know what is backing that filesystem, that's the big
issue, just as you don't know what type of filesystem it is, from within
the kernel.

thanks,

greg k-h
