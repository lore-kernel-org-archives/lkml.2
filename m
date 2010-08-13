Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0HMWSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:18:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0HMWSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:18:10 -0400
Date: Fri, 13 Aug 2010 15:17:49 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100813221749.GA19569@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
 <20100813175402.GA15024@suse.de>
 <1281724992.12189.16.camel@odc-laptop>
 <20100813190128.GA1372@suse.de>
 <1281727059.16672.20.camel@odc-laptop>
 <20100813192826.GA5078@suse.de>
 <1281731535.29175.17.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281731535.29175.17.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > 
> > What exactly are the performance issues with doing this from userspace,
> > vs. the FAT hack?
> Usually it takes a lot longer. West Bridge can do MTP transfers at the
> performance of the storage device.  Sending the file data through the
> processor is typically much slower.

What is "slower" here?  Please, real numbers.

> > > > We have a userspace MTP driver for Linux, using gadgetfs, right?  So
> > > > none of this is applicable from what I can tell.
> > > Yes, the g_mtp development has started, but it is not integrated yet
> > > last I checked. Most of the applications for this driver have used
> > > gadgetfs as well in order to handle the protocol itself. So, I think it
> > > is applicable.
> > 
> > No, there's another MTP stack already released that works just fine on
> > Linux.  You can find it at:
> > 	http://wiki.meego.com/Buteo
> Thanks, I have seen this as well. This is not a driver though, it is an
> MTP protocol stack.

With a gadgetfs driver underneath, right?  Or am I missing a piece here?

> This is similar to the applications I have worked
> with. The driver is not attempting to replace either the protocol stack
> or the use of gadgetfs. All that it is providing is a gadget peripheral
> controller driver (that can be used with gadgetfs) along with the
> ability to perform pre-allocation and allow for direct transfer.

It's that "pre-allocation" that is the issue.

> I re-checked this stack once again to make sure that it had not
> fundamentally changed and it seems not to have. What it uses is a
> storageserver abstraction to the file system. At the low level this is
> still operating on files at the level of open(), read(), write(),
> close(). There is no alloc() in the list that I can see. So, I agree
> that there is a working stack. As you can tell, the driver is not
> attempting to re-create or replace this working stack.  

To "preallocate" a file, just open it and then mmap it and write away,
right?  Why can't userspace do that?

> > > > > The West Bridge driver goes for option two for performance reasons. In
> > > > > doing this, it needs to get information from the file system on where to
> > > > > store the file.
> > > > 
> > > > Look at how Linux already handles MTP for how to handle this properly, I
> > > > don't think there is any need to do any of this from within the kernel.
> > > I somewhat familiar with how Linux handles MTP. The current model is
> > > CPU-centric and all data goes through the main processor from what I
> > > have seen. This is a working solution, but not always a very fast one. I
> > > agree though that this would not need to be done within the kernel if we
> > > had a userspace method for file allocation and commitment.
> > 
> > Again, what's wrong with using the processor here?  What else does it
> > have to do at this point in time?
> Judging by the current batch of Android phones: run a video
> conference, update a users twitter page, take high resolution
> photographs, get live stock updates via desktop widget, receive a
> phone call, play back Youtube, stream Pandora, manage media content,
> post a new profile picture on facebook, get corporate email, etc.

All while trying to transfer a file to the device over the USB
connection?  There's no reason you can't slow down the transfer if the
user is doing something else, right?

> I am sure we can both come up with many more examples.

I still fail to see the use-case, and as you haven't backed it up with
any real numbers, that's an issue.

> > > > > >What happens if this isn't a FAT partition on the >device?
> > > > > Good question. So far, it has been stored on a FAT partition in most use
> > > > > cases because the user typically wants the option to enumerate the
> > > > > device as mass storage as well or be able to see content on a PC if the
> > > > > SD card is removed. However, there is no reason that this could not be
> > > > > done with ext2 or other filesystems on non-removable media.
> > > > 
> > > > Like NTFS?  How are you going to handle that when you run out of size
> > > > due to the limitations of FAT?  Hint, that's not going to work with this
> > > > type of solution...
> > > Isn't this also a userspace problem? When I run out of space on my Linux machine,
> > > the message "no space left on device" pops up. Why is this solution any
> > > more prone to size limitations compared with any other?
> > 
> > No, my point is that for larger disk sizes, you can't use FAT, you have
> > to use NTFS to be interoperable with other operating systems.  Your
> > solution will not handle that jump to larger storage sizes as you are
> > relying on FAT.
> This is so far not an issue for removable media. Do I really need to
> handle NTFS interoperability now?

You can't create something that will not work for all filesystems.

> If so, do you agree with Christoph's feedback concerning the
> implementation? Could I add hooks to other file systems and leave them
> unpopulated?

ntfs is done by using a FUSE filesystem in userspace on a "raw" block
device.  You can't put that type of support in the kernel here :)

> > Yes, the pre-allocation is done in userspace, and then the data is
> > copied to the filesystem then.  The kernel doesn't have to have any
> > filesystem specific hacks in it to try to handle this at all.
> Where do you see pre-allocation done in the Buteo MTP stack? Looking at
> the implementation, it appears to be allocated during write wherein a
> data buffer and pointer is passed in. 

And that's all that is needed, right?

> > Take a look at the above link for what you might want to do instead.
> > Because of this, I'm guessing that a lot of this code can be removed
> > from the driver, right?
> If there were a user space method to pre-allocate the file, it would
> definitely trim down the ioctls in the gadget driver.

open a file, seek to the end, then mmap the whole thing.  That's how
userspace has been doing this for a long time, right?  I'm sure there
are other ways of doing it as well.

> Instead of pre-allocating the file, we would just need to send down
> the physical block numbers for the transfer destination. I am still
> not seeing where this user space method exists though.

Ick, no, you would neve send down physical block numbers.

Look at how filesystems work from userspace, they achieve _very_ fast
speeds due to mmap and friends.  Heck, some people try to get the OS out
of the way entirely by just using direct I/O, or taking to the raw block
device.  Not by trying to allocate raw filesystem blocks from userspace,
that way lies madness.

thanks,

greg k-h
