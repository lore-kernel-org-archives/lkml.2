Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0HNBM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 21:12:57 -0400
Received: from ns2.cypress.com ([157.95.67.5]:56365 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab0HNBM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 21:12:56 -0400
Subject: Re: EXPORT_SYMBOL(fat_get_block)
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: Greg KH <gregkh@suse.de>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org, nxz@cypress.com
In-Reply-To: <20100814002514.GA3182@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
	 <20100813175402.GA15024@suse.de> <1281724992.12189.16.camel@odc-laptop>
	 <20100813190128.GA1372@suse.de> <1281727059.16672.20.camel@odc-laptop>
	 <20100813192826.GA5078@suse.de> <1281731535.29175.17.camel@odc-laptop>
	 <20100813221749.GA19569@suse.de> <1281741733.22119.20.camel@odc-laptop>
	 <20100814002514.GA3182@suse.de>
Content-Type: text/plain
Organization: Cypress
Date: Fri, 13 Aug 2010 18:12:43 -0700
Message-Id: <1281748363.7882.15.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 17:25 -0700, Greg KH wrote:
> On Fri, Aug 13, 2010 at 04:22:13PM -0700, David Cross wrote:
> > On Fri, 2010-08-13 at 15:17 -0700, Greg KH wrote:
> > > On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > > > > 
> > > > > What exactly are the performance issues with doing this from userspace,
> > > > > vs. the FAT hack?
> > > > Usually it takes a lot longer. West Bridge can do MTP transfers at the
> > > > performance of the storage device.  Sending the file data through the
> > > > processor is typically much slower.
> > > 
> > > What is "slower" here?  Please, real numbers.
> > Sure, here are some of the numbers I have:
> > Cypress West Bridge   15
> > Blackberry Storm 2    4.6
> > Microsoft Zune        3.8
> > Nokia N97             2.1
> > SEMC W950	      1.1
> > SEMC W995             0.85	
> > Blackberry Storm      0.7
> 
> No, I mean numbers before and after with and without this "hack".
I can provide these, but it will take me some time to implement. I will have to use the Zoom II
platform to benchmark. Any issues with this approach before I get
started?

> > > > This is similar to the applications I have worked
> > > > with. The driver is not attempting to replace either the protocol stack
> > > > or the use of gadgetfs. All that it is providing is a gadget peripheral
> > > > controller driver (that can be used with gadgetfs) along with the
> > > > ability to perform pre-allocation and allow for direct transfer.
> > > 
> > > It's that "pre-allocation" that is the issue.
> > Ack.
> > 
> > > > I re-checked this stack once again to make sure that it had not
> > > > fundamentally changed and it seems not to have. What it uses is a
> > > > storageserver abstraction to the file system. At the low level this is
> > > > still operating on files at the level of open(), read(), write(),
> > > > close(). There is no alloc() in the list that I can see. So, I agree
> > > > that there is a working stack. As you can tell, the driver is not
> > > > attempting to re-create or replace this working stack.  
> > > 
> > > To "preallocate" a file, just open it and then mmap it and write away,
> > > right?  Why can't userspace do that?
> > To do this from userspace in entirety, the CPU needs access to the data
> > in memory so that it can pass a pointer to the fwrite call. 
> 
> That's a stream, not mmap.  What's wrong with mmap?  That should provide
> what you are looking for here, right?
Maybe, if this works we can close the discussion, so far it has not. We do use bmap once the file
has been allocated, but does mmap really create an empty file on disk
with the correct state saved and without content? 

> > In this case, the data never gets to the processor, it is written
> > directly to the storage by West Bridge. We did do some experiments in
> > user space to try and get this done. If I recall correctly, this
> > resulted in zeros being written to all blocks. I am copying Nelson
> > Zhang, who did this testing. He can comment more on the impediments to
> > this implementation.
> 
> I would be interested in finding out what the problem was here.
Nelson will give more details about the issues.

> > > All while trying to transfer a file to the device over the USB
> > > connection?  There's no reason you can't slow down the transfer if the
> > > user is doing something else, right?
> > Yes, you can slow it down, but that may not be the best solution. Eg, if
> > you want to sync a movie to your mobile device before catching a flight,
> > you probably don't want to wait three times as long to get it done and
> > onto the airport shuttle.
> 
> Wee, contrived user interaction senarios, I can do that too!
> 
> What happens if the user wants to download a file, and stream a 3g viop
> call at the same time he is running to catch that airport shuttle and is
> trying to listen to the navigation guides which is reading the gps chip
> stream and guiding him to the nearest bus stop?  :)
> 
> Sorry, this isn't a valid thing to be arguing at this point in time.
> Hacks like this in places you shouldn't be doing things, are not
> allowed.
Your question was: "What problem are you trying to solve?" My answer was
"performance". I am not sure how to respond to "why can't you slow down
the transfer?" or "who cares about performance?" without contrived user
scenarios. Syncing your phone takes longer than it needs to. One of the
purposes of this chip is that it provides one solution to the problem.
The software submitted to the community is our attempt to solve this in
a way that works nicely with Linux. I remain open to constructive
suggestions, but this argument is sounding increasingly circular in
nature.

> > > > If so, do you agree with Christoph's feedback concerning the
> > > > implementation? Could I add hooks to other file systems and leave them
> > > > unpopulated?
> > > 
> > > ntfs is done by using a FUSE filesystem in userspace on a "raw" block
> > > device.  You can't put that type of support in the kernel here :)
> > Fair, but to support the removable media model, I don't really need to.
> > What if I put a check in the code to verify that the media is removable
> > and vfat compatible before executing the fat_get_block call?
> 
> You can't rely on that flag, sorry, it doesn't work with real-world
> devices.
> 
> And I have removable media right here, that shipped to me formatted as
> NTFS, so that is a valid model today.
Is it an SD Card? I have little interest in hooking my cell up to a USB
powered hard drive at the moment. 

> > > Look at how filesystems work from userspace, they achieve _very_ fast
> > > speeds due to mmap and friends.  Heck, some people try to get the OS out
> > > of the way entirely by just using direct I/O, or taking to the raw block
> > > device.  Not by trying to allocate raw filesystem blocks from userspace,
> > > that way lies madness.
> > Well, it is not really the filesystem that necessarily bottlenecks the
> > performance. It is usually that in combination with the hardware data
> > path that this usage implies. If you want to sync a phone without a
> > sideloading accelerator, the data path taken is usually as follows:
> > 
> > 1) data received by USB peripheral, typically into fifos
> > 2) cpu gets interrupted, sees that data is there
> > 3) cpu sets up DMA transfer to SDRAM to cache data
> > 4) At some point CPU initiates DMA transfer from SDRAM to removable
> > media.
> 
> Wait, step 4 is a big jump.  Userspace should be reading that data, and
> then writing it back out to a file it opened, not this "dma directly to
> media" stuff.
My statement was that the hardware and software is convoluted and the
data path hits different memories multiple times. Your response seems to
be that I left out one of the memory copies to userspace. I think that
adds to my point, doesn't it?

> And yes, you can stream it if you want from userspace to the file if
> that's faster, but odds are mmap() will work best here.
Ok, but I don't want the data to hit userspace unless the file is read back. Does 
using mmap support this scenario?

> > 5) depending on the peripheral implementation, data may be buffered
> > either in the peripheral (SD/MMC controller) or in the DMA engine
> > itself.
> 
> Yes, you don't know what is backing that filesystem, that's the big
> issue, just as you don't know what type of filesystem it is, from within
> the kernel.
Can't I pass this information into the driver using the ioctl call? If
the filesystem is not fat and not removable, this driver should likely
not be used, at least not for this purpose.

thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

