Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0HMXWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:22:30 -0400
Received: from ns2.cypress.com ([157.95.67.5]:53828 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0HMXW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:22:28 -0400
Subject: Re: EXPORT_SYMBOL(fat_get_block)
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: Greg KH <gregkh@suse.de>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org, nxz@cypress.com
In-Reply-To: <20100813221749.GA19569@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
	 <20100813175402.GA15024@suse.de> <1281724992.12189.16.camel@odc-laptop>
	 <20100813190128.GA1372@suse.de> <1281727059.16672.20.camel@odc-laptop>
	 <20100813192826.GA5078@suse.de> <1281731535.29175.17.camel@odc-laptop>
	 <20100813221749.GA19569@suse.de>
Content-Type: text/plain
Organization: Cypress
Date: Fri, 13 Aug 2010 16:22:13 -0700
Message-Id: <1281741733.22119.20.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 15:17 -0700, Greg KH wrote:
> On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > > 
> > > What exactly are the performance issues with doing this from userspace,
> > > vs. the FAT hack?
> > Usually it takes a lot longer. West Bridge can do MTP transfers at the
> > performance of the storage device.  Sending the file data through the
> > processor is typically much slower.
> 
> What is "slower" here?  Please, real numbers.
Sure, here are some of the numbers I have:
Cypress West Bridge   15
Blackberry Storm 2    4.6
Microsoft Zune        3.8
Nokia N97             2.1
SEMC W950	      1.1
SEMC W995             0.85	
Blackberry Storm      0.7

The number on the right represents MB/s for transfers of music files
(3-6MB in size). All are transfers to the same storage card. As you can
see, none of these are Linux based devices, but that is mostly because I
don't have any Linux based phones to benchmark for MTP performance at
the moment. All phones were benchmarked using a SanDisk 4GB microSDHC
Mobile Ultra card when possible (the Zune has built-in memory).

> > > > > We have a userspace MTP driver for Linux, using gadgetfs, right?  So
> > > > > none of this is applicable from what I can tell.
> > > > Yes, the g_mtp development has started, but it is not integrated yet
> > > > last I checked. Most of the applications for this driver have used
> > > > gadgetfs as well in order to handle the protocol itself. So, I think it
> > > > is applicable.
> > > 
> > > No, there's another MTP stack already released that works just fine on
> > > Linux.  You can find it at:
> > > 	http://wiki.meego.com/Buteo
> > Thanks, I have seen this as well. This is not a driver though, it is an
> > MTP protocol stack.
> 
> With a gadgetfs driver underneath, right?  Or am I missing a piece here?
Nope, you are correct this uses gadgetfs. That is what our driver uses
for all of the protocol handling. The only difference is...

> > This is similar to the applications I have worked
> > with. The driver is not attempting to replace either the protocol stack
> > or the use of gadgetfs. All that it is providing is a gadget peripheral
> > controller driver (that can be used with gadgetfs) along with the
> > ability to perform pre-allocation and allow for direct transfer.
> 
> It's that "pre-allocation" that is the issue.
Ack.

> > I re-checked this stack once again to make sure that it had not
> > fundamentally changed and it seems not to have. What it uses is a
> > storageserver abstraction to the file system. At the low level this is
> > still operating on files at the level of open(), read(), write(),
> > close(). There is no alloc() in the list that I can see. So, I agree
> > that there is a working stack. As you can tell, the driver is not
> > attempting to re-create or replace this working stack.  
> 
> To "preallocate" a file, just open it and then mmap it and write away,
> right?  Why can't userspace do that?
To do this from userspace in entirety, the CPU needs access to the data
in memory so that it can pass a pointer to the fwrite call. In this
case, the data never gets to the processor, it is written directly to
the storage by West Bridge. We did do some experiments in user space to
try and get this done. If I recall correctly, this resulted in zeros
being written to all blocks. I am copying Nelson Zhang, who did this
testing. He can comment more on the impediments to this implementation.

> > > > > > The West Bridge driver goes for option two for performance reasons. In
> > > > > > doing this, it needs to get information from the file system on where to
> > > > > > store the file.
> > > > > 
> > > > > Look at how Linux already handles MTP for how to handle this properly, I
> > > > > don't think there is any need to do any of this from within the kernel.
> > > > I somewhat familiar with how Linux handles MTP. The current model is
> > > > CPU-centric and all data goes through the main processor from what I
> > > > have seen. This is a working solution, but not always a very fast one. I
> > > > agree though that this would not need to be done within the kernel if we
> > > > had a userspace method for file allocation and commitment.
> > > 
> > > Again, what's wrong with using the processor here?  What else does it
> > > have to do at this point in time?
> > Judging by the current batch of Android phones: run a video
> > conference, update a users twitter page, take high resolution
> > photographs, get live stock updates via desktop widget, receive a
> > phone call, play back Youtube, stream Pandora, manage media content,
> > post a new profile picture on facebook, get corporate email, etc.
> 
> All while trying to transfer a file to the device over the USB
> connection?  There's no reason you can't slow down the transfer if the
> user is doing something else, right?
Yes, you can slow it down, but that may not be the best solution. Eg, if
you want to sync a movie to your mobile device before catching a flight,
you probably don't want to wait three times as long to get it done and
onto the airport shuttle.

> > I am sure we can both come up with many more examples.
> 
> I still fail to see the use-case, and as you haven't backed it up with
> any real numbers, that's an issue.
Numbers included above.

> > > > > > >What happens if this isn't a FAT partition on the >device?
> > > > > > Good question. So far, it has been stored on a FAT partition in most use
> > > > > > cases because the user typically wants the option to enumerate the
> > > > > > device as mass storage as well or be able to see content on a PC if the
> > > > > > SD card is removed. However, there is no reason that this could not be
> > > > > > done with ext2 or other filesystems on non-removable media.
> > > > > 
> > > > > Like NTFS?  How are you going to handle that when you run out of size
> > > > > due to the limitations of FAT?  Hint, that's not going to work with this
> > > > > type of solution...
> > > > Isn't this also a userspace problem? When I run out of space on my Linux machine,
> > > > the message "no space left on device" pops up. Why is this solution any
> > > > more prone to size limitations compared with any other?
> > > 
> > > No, my point is that for larger disk sizes, you can't use FAT, you have
> > > to use NTFS to be interoperable with other operating systems.  Your
> > > solution will not handle that jump to larger storage sizes as you are
> > > relying on FAT.
> > This is so far not an issue for removable media. Do I really need to
> > handle NTFS interoperability now?
> 
> You can't create something that will not work for all filesystems.
> 
> > If so, do you agree with Christoph's feedback concerning the
> > implementation? Could I add hooks to other file systems and leave them
> > unpopulated?
> 
> ntfs is done by using a FUSE filesystem in userspace on a "raw" block
> device.  You can't put that type of support in the kernel here :)
Fair, but to support the removable media model, I don't really need to.
What if I put a check in the code to verify that the media is removable
and vfat compatible before executing the fat_get_block call?

> > > Yes, the pre-allocation is done in userspace, and then the data is
> > > copied to the filesystem then.  The kernel doesn't have to have any
> > > filesystem specific hacks in it to try to handle this at all.
> > Where do you see pre-allocation done in the Buteo MTP stack? Looking at
> > the implementation, it appears to be allocated during write wherein a
> > data buffer and pointer is passed in. 
> 
> And that's all that is needed, right?
Not really, no. What I am looking for is to allocate the file with a
NULL pointer to the data buffer, not through the write call.

> > > Take a look at the above link for what you might want to do instead.
> > > Because of this, I'm guessing that a lot of this code can be removed
> > > from the driver, right?
> > If there were a user space method to pre-allocate the file, it would
> > definitely trim down the ioctls in the gadget driver.
> 
> open a file, seek to the end, then mmap the whole thing.  That's how
> userspace has been doing this for a long time, right?  I'm sure there
> are other ways of doing it as well.
As I recall, this is how we ended up with zeroes written to the file.
Nelson should have more comments.

> > Instead of pre-allocating the file, we would just need to send down
> > the physical block numbers for the transfer destination. I am still
> > not seeing where this user space method exists though.
> 
> Ick, no, you would neve send down physical block numbers.
>
> Look at how filesystems work from userspace, they achieve _very_ fast
> speeds due to mmap and friends.  Heck, some people try to get the OS out
> of the way entirely by just using direct I/O, or taking to the raw block
> device.  Not by trying to allocate raw filesystem blocks from userspace,
> that way lies madness.
Well, it is not really the filesystem that necessarily bottlenecks the
performance. It is usually that in combination with the hardware data
path that this usage implies. If you want to sync a phone without a
sideloading accelerator, the data path taken is usually as follows:

1) data received by USB peripheral, typically into fifos
2) cpu gets interrupted, sees that data is there
3) cpu sets up DMA transfer to SDRAM to cache data
4) At some point CPU initiates DMA transfer from SDRAM to removable
media.
5) depending on the peripheral implementation, data may be buffered
either in the peripheral (SD/MMC controller) or in the DMA engine
itself.

So, yes, the filesystem accesses can be fast, but the convoluted data
path usually is not.

Thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

