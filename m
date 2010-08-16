Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0HPXey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:34:54 -0400
Received: from ns2.cypress.com ([157.95.67.5]:44259 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0HPXex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:34:53 -0400
Subject: Re: FW: EXPORT_SYMBOL(fat_get_block)
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: gregkh@suse.de
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org, nxz@cypress.com
In-Reply-To: <2CB0953655A24CBEB0D853ECC20F4A8F@stanford.edu>
References: <2CB0953655A24CBEB0D853ECC20F4A8F@stanford.edu>
Content-Type: text/plain
Organization: Cypress
Date: Mon, 16 Aug 2010 16:34:36 -0700
Message-Id: <1282001676.4381.52.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, Aug 13, 2010 at 06:12:43PM -0700, David Cross wrote:
> > On Fri, 2010-08-13 at 17:25 -0700, Greg KH wrote:
> > > On Fri, Aug 13, 2010 at 04:22:13PM -0700, David Cross wrote:
> > > > On Fri, 2010-08-13 at 15:17 -0700, Greg KH wrote:
> > > > > On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > > > > > > 
> > > > > > > What exactly are the performance issues with doing this from
> userspace,
> > > > > > > vs. the FAT hack?
> > > > > > Usually it takes a lot longer. West Bridge can do MTP transfers at
> the
> > > > > > performance of the storage device.  Sending the file data through
> the
> > > > > > processor is typically much slower.
> > > > > 
> > > > > What is "slower" here?  Please, real numbers.
> > > > Sure, here are some of the numbers I have:
> > > > Cypress West Bridge   15
> > > > Blackberry Storm 2    4.6
> > > > Microsoft Zune        3.8
> > > > Nokia N97             2.1
> > > > SEMC W950	      1.1
> > > > SEMC W995             0.85	
> > > > Blackberry Storm      0.7
> > > 
> > > No, I mean numbers before and after with and without this "hack".
> > I can provide these, but it will take me some time to implement. I
> > will have to use the Zoom II platform to benchmark. Any issues with
> > this approach before I get started?
> 
> It's ok, you don't have to do it right now, I'm just curious as to how
> much speed difference you are seeing here.
> 
> As it will be a few weeks before I can even get this into the -next
> tree, it's not of upmost importance at the moment.

To give you an idea of the performance difference, even for mass storage
class which has less protocol involvement, the native software and
hardware on the platform I am using typically perform at less than 4
MB/s. I am getting this number from benchmarks of the Motorola Droid
phone, which uses a similar software and hardware configuration as the
Zoom 2.


> > > > > > This is similar to the applications I have worked
> > > > > > with. The driver is not attempting to replace either the protocol
> stack
> > > > > > or the use of gadgetfs. All that it is providing is a gadget
> peripheral
> > > > > > controller driver (that can be used with gadgetfs) along with the
> > > > > > ability to perform pre-allocation and allow for direct transfer.
> > > > > 
> > > > > It's that "pre-allocation" that is the issue.
> > > > Ack.
> > > > 
> > > > > > I re-checked this stack once again to make sure that it had not
> > > > > > fundamentally changed and it seems not to have. What it uses is a
> > > > > > storageserver abstraction to the file system. At the low level
> this is
> > > > > > still operating on files at the level of open(), read(), write(),
> > > > > > close(). There is no alloc() in the list that I can see. So, I
> agree
> > > > > > that there is a working stack. As you can tell, the driver is not
> > > > > > attempting to re-create or replace this working stack.  
> > > > > 
> > > > > To "preallocate" a file, just open it and then mmap it and write
> away,
> > > > > right?  Why can't userspace do that?
> > > > To do this from userspace in entirety, the CPU needs access to the
> data
> > > > in memory so that it can pass a pointer to the fwrite call. 
> > > 
> > > That's a stream, not mmap.  What's wrong with mmap?  That should provide
> > > what you are looking for here, right?
> > Maybe, if this works we can close the discussion, so far it has not.
> > We do use bmap once the file has been allocated, but does mmap really
> > create an empty file on disk with the correct state saved and without
> > content? 
> 
> Well, if you zero out everything on a mmapped file and then close it, it
> should.  But you might just be creating a "sparse" file, so you need to
> be careful about that as well.
> 
> What I mean to do about mmap is just that is the way your userspace
> program can write to the file, not as a stream.  That is much faster and
> causes less I/O to the device (well, it should.)  Does that make more
> sense?

Understood, I will try to implement it in this way on my setup. I do
have the latest kernel booting on it now and show be able to implement
this test. If this works, it does open a new discussion on
mpage_cleardirty as we would definitely want to include this function.
If we zero out the file, we would not want the zeroes to hit disk, again
for clear performance reasons.

> > Your question was: "What problem are you trying to solve?" My answer was
> > "performance". I am not sure how to respond to "why can't you slow down
> > the transfer?" or "who cares about performance?" without contrived user
> > scenarios. Syncing your phone takes longer than it needs to. One of the
> > purposes of this chip is that it provides one solution to the problem.
> > The software submitted to the community is our attempt to solve this in
> > a way that works nicely with Linux. I remain open to constructive
> > suggestions, but this argument is sounding increasingly circular in
> > nature.
> 
> Sorry, I don't mean this to come off that way at all, my appologies.

Sorry, I must have misunderstood, I just want to make sure that we are
moving things forward in a way that makes sense.

> I'm just very curious as this is the first time something like this has
> been proposed that I know of, so generally either the design is wrong,
> or it is such a unique situation that no one has ever hit this before.
> 
> So far, I'm leaning toward the "design is a bit incorrect" :)
> 
> But again, let's take this one thing at a time.  Let's get the driver
> into the tree, with that one ioctl commented out.  We can then work on
> cleaning it all up and figuring out the logic of where it all goes in
> the tree, and what it looks like in the end after the refactoring.
> During that time, we will have plenty of time to discuss why the
> previous attempts ended up with zeros in the file.
> 
> Sound good?

Yes, sounds great. On one related topic, I can't seem to register gadgetfs with
our controller driver when the controller is built in the staging tree
with the latest kernel. I get the error messages:

gadgetfs: disagrees about version of symbol usb_gadget_unregister_driver
gadgetfs: Unknown symbol usb_gadget_unregister_driver (err -22)

Is this the expected behavior for a staging driver? Any workaround you
know of? I was not able to find much information about this from the
mailing lists other than "build against the right kernel", which of
course I am doing.

> > > > > > If so, do you agree with Christoph's feedback concerning the
> > > > > > implementation? Could I add hooks to other file systems and leave
> them
> > > > > > unpopulated?
> > > > > 
> > > > > ntfs is done by using a FUSE filesystem in userspace on a "raw"
> block
> > > > > device.  You can't put that type of support in the kernel here :)
> > > > Fair, but to support the removable media model, I don't really need
> to.
> > > > What if I put a check in the code to verify that the media is
> removable
> > > > and vfat compatible before executing the fat_get_block call?
> > > 
> > > You can't rely on that flag, sorry, it doesn't work with real-world
> > > devices.
> > > 
> > > And I have removable media right here, that shipped to me formatted as
> > > NTFS, so that is a valid model today.
> > Is it an SD Card? I have little interest in hooking my cell up to a USB
> > powered hard drive at the moment. 
> 
> My cell phone hooks up to a USB powered hard drive at the moment :)
> It can also drive a monitor through the usb connection, you would be
> amazed what you can do with these things these days.
> 
> > > > > Look at how filesystems work from userspace, they achieve _very_
> fast
> > > > > speeds due to mmap and friends.  Heck, some people try to get the OS
> out
> > > > > of the way entirely by just using direct I/O, or taking to the raw
> block
> > > > > device.  Not by trying to allocate raw filesystem blocks from
> userspace,
> > > > > that way lies madness.
> > > > Well, it is not really the filesystem that necessarily bottlenecks the
> > > > performance. It is usually that in combination with the hardware data
> > > > path that this usage implies. If you want to sync a phone without a
> > > > sideloading accelerator, the data path taken is usually as follows:
> > > > 
> > > > 1) data received by USB peripheral, typically into fifos
> > > > 2) cpu gets interrupted, sees that data is there
> > > > 3) cpu sets up DMA transfer to SDRAM to cache data
> > > > 4) At some point CPU initiates DMA transfer from SDRAM to removable
> > > > media.
> > > 
> > > Wait, step 4 is a big jump.  Userspace should be reading that data, and
> > > then writing it back out to a file it opened, not this "dma directly to
> > > media" stuff.
> > My statement was that the hardware and software is convoluted and the
> > data path hits different memories multiple times. Your response seems to
> > be that I left out one of the memory copies to userspace. I think that
> > adds to my point, doesn't it?
> 
> Possibly, if those memory copies take a lot of time.
> 
> How are all of the other platforms that use Linux as this type of
> device, or even a usb-storage device (of which there are lots) able to
> hit the very fast transfer rates that I have seen so far without needing
> to do this type of preallocation?

I think that the usage case is the difference. Mass storage class
devices expose a block level interface to the USB host and the USB host
owns the file system. The device here is really a "dumb" device. In the
case of MTP, the device owns the file system. I have not seen fast
performance over MTP on any embedded Linux system as yet. Do you know of
any fast MTP responders that work with Linux?

> > > And yes, you can stream it if you want from userspace to the file if
> > > that's faster, but odds are mmap() will work best here.
> > Ok, but I don't want the data to hit userspace unless the file is read
> > back. Does using mmap support this scenario?
> 
> Yes.

I will implement this as soon as I can get past the registering gadgetfs issue
mentioned above. If you have pointers on that, it would be great. I will
plan to submit patches to the current patch once it is in the next tree
to avoid sending duplicates. Let me know if that is the preferred method
or if you want me to send updates as I make them.

> > > > 5) depending on the peripheral implementation, data may be buffered
> > > > either in the peripheral (SD/MMC controller) or in the DMA engine
> > > > itself.
> > > 
> > > Yes, you don't know what is backing that filesystem, that's the big
> > > issue, just as you don't know what type of filesystem it is, from within
> > > the kernel.
> > Can't I pass this information into the driver using the ioctl call? If
> > the filesystem is not fat and not removable, this driver should likely
> > not be used, at least not for this purpose.
> 
> No, the driver never knows this type of information.  And for good
> reason, you could have 4 different partitions on this block device, all
> different filesystems.  The block driver should never care about the
> filesystem underneath it.

To clarify, in this case, it is not the block driver which needs this
information, it would be the gadget peripheral controller driver which
would get it directly from the protocol stack via ioctl. If mmap works
and is portable across file systems, this should be a non-issue. The
gadget controller would still need to be able to clear dirty mpages and
bmap the the locations of the file on disk. I am hoping based on this
discussion that you are ok with that. Please let me know if this is not
the case.

Thanks,
David




---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

