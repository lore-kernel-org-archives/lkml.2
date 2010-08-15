Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab0HOXWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 19:22:20 -0400
Received: from ns2.cypress.com ([157.95.67.5]:39511 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab0HOXWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 19:22:11 -0400
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2010 19:22:11 EDT
From: "Nelson Zhang" <nxz@cypress.com>
To: "'Greg KH'" <gregkh@suse.de>, "'David Cross'" <david.cross@cypress.com>
Cc: <hirofumi@mail.parknet.co.jp>, <linux-kernel@vger.kernel.org>
References: <20100813175402.GA15024@suse.de> <1281724992.12189.16.camel@odc-laptop> <20100813190128.GA1372@suse.de> <1281727059.16672.20.camel@odc-laptop> <20100813192826.GA5078@suse.de> <1281731535.29175.17.camel@odc-laptop> <20100813221749.GA19569@suse.de> <1281741733.22119.20.camel@odc-laptop> <20100814002514.GA3182@suse.de> <1281748363.7882.15.camel@odc-laptop> <20100814030408.GB4779@suse.de>
Subject: RE: EXPORT_SYMBOL(fat_get_block)
Date: Mon, 16 Aug 2010 06:57:54 +0800
Message-ID: <ABE41F255A574632903665A7D1F90907@mis.cypress.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Thread-Index: Acs7XWfRx2vh+cCJTsOT+TxRQwQrxwBbzjsw
In-Reply-To: <20100814030408.GB4779@suse.de>
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Greg,

What I have done so far is following:

1. Open a file 
2. Seek to the end of file

What I have not done is:

3. mmap the whole file. 

Without #3, the file is not allocated until I write to the file. I think we
can try to use mmap to allocate the file but we still need a function that
can get file block info once the file is allocated.

Thanks,
Nelson


-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Saturday, August 14, 2010 11:04 AM
To: David Cross
Cc: hirofumi@mail.parknet.co.jp; linux-kernel@vger.kernel.org;
nxz@cypress.com
Subject: Re: EXPORT_SYMBOL(fat_get_block)

On Fri, Aug 13, 2010 at 06:12:43PM -0700, David Cross wrote:
> On Fri, 2010-08-13 at 17:25 -0700, Greg KH wrote:
> > On Fri, Aug 13, 2010 at 04:22:13PM -0700, David Cross wrote:
> > > On Fri, 2010-08-13 at 15:17 -0700, Greg KH wrote:
> > > > On Fri, Aug 13, 2010 at 01:32:15PM -0700, David Cross wrote:
> > > > > > 
> > > > > > What exactly are the performance issues with doing this from
userspace,
> > > > > > vs. the FAT hack?
> > > > > Usually it takes a lot longer. West Bridge can do MTP transfers at
the
> > > > > performance of the storage device.  Sending the file data through
the
> > > > > processor is typically much slower.
> > > > 
> > > > What is "slower" here?  Please, real numbers.
> > > Sure, here are some of the numbers I have:
> > > Cypress West Bridge   15
> > > Blackberry Storm 2    4.6
> > > Microsoft Zune        3.8
> > > Nokia N97             2.1
> > > SEMC W950	      1.1
> > > SEMC W995             0.85	
> > > Blackberry Storm      0.7
> > 
> > No, I mean numbers before and after with and without this "hack".
> I can provide these, but it will take me some time to implement. I
> will have to use the Zoom II platform to benchmark. Any issues with
> this approach before I get started?

It's ok, you don't have to do it right now, I'm just curious as to how
much speed difference you are seeing here.

As it will be a few weeks before I can even get this into the -next
tree, it's not of upmost importance at the moment.

> > > > > This is similar to the applications I have worked
> > > > > with. The driver is not attempting to replace either the protocol
stack
> > > > > or the use of gadgetfs. All that it is providing is a gadget
peripheral
> > > > > controller driver (that can be used with gadgetfs) along with the
> > > > > ability to perform pre-allocation and allow for direct transfer.
> > > > 
> > > > It's that "pre-allocation" that is the issue.
> > > Ack.
> > > 
> > > > > I re-checked this stack once again to make sure that it had not
> > > > > fundamentally changed and it seems not to have. What it uses is a
> > > > > storageserver abstraction to the file system. At the low level
this is
> > > > > still operating on files at the level of open(), read(), write(),
> > > > > close(). There is no alloc() in the list that I can see. So, I
agree
> > > > > that there is a working stack. As you can tell, the driver is not
> > > > > attempting to re-create or replace this working stack.  
> > > > 
> > > > To "preallocate" a file, just open it and then mmap it and write
away,
> > > > right?  Why can't userspace do that?
> > > To do this from userspace in entirety, the CPU needs access to the
data
> > > in memory so that it can pass a pointer to the fwrite call. 
> > 
> > That's a stream, not mmap.  What's wrong with mmap?  That should provide
> > what you are looking for here, right?
> Maybe, if this works we can close the discussion, so far it has not.
> We do use bmap once the file has been allocated, but does mmap really
> create an empty file on disk with the correct state saved and without
> content? 

Well, if you zero out everything on a mmapped file and then close it, it
should.  But you might just be creating a "sparse" file, so you need to
be careful about that as well.

What I mean to do about mmap is just that is the way your userspace
program can write to the file, not as a stream.  That is much faster and
causes less I/O to the device (well, it should.)  Does that make more
sense?

> Your question was: "What problem are you trying to solve?" My answer was
> "performance". I am not sure how to respond to "why can't you slow down
> the transfer?" or "who cares about performance?" without contrived user
> scenarios. Syncing your phone takes longer than it needs to. One of the
> purposes of this chip is that it provides one solution to the problem.
> The software submitted to the community is our attempt to solve this in
> a way that works nicely with Linux. I remain open to constructive
> suggestions, but this argument is sounding increasingly circular in
> nature.

Sorry, I don't mean this to come off that way at all, my appologies.

I'm just very curious as this is the first time something like this has
been proposed that I know of, so generally either the design is wrong,
or it is such a unique situation that no one has ever hit this before.

So far, I'm leaning toward the "design is a bit incorrect" :)

But again, let's take this one thing at a time.  Let's get the driver
into the tree, with that one ioctl commented out.  We can then work on
cleaning it all up and figuring out the logic of where it all goes in
the tree, and what it looks like in the end after the refactoring.
During that time, we will have plenty of time to discuss why the
previous attempts ended up with zeros in the file.

Sound good?

> > > > > If so, do you agree with Christoph's feedback concerning the
> > > > > implementation? Could I add hooks to other file systems and leave
them
> > > > > unpopulated?
> > > > 
> > > > ntfs is done by using a FUSE filesystem in userspace on a "raw"
block
> > > > device.  You can't put that type of support in the kernel here :)
> > > Fair, but to support the removable media model, I don't really need
to.
> > > What if I put a check in the code to verify that the media is
removable
> > > and vfat compatible before executing the fat_get_block call?
> > 
> > You can't rely on that flag, sorry, it doesn't work with real-world
> > devices.
> > 
> > And I have removable media right here, that shipped to me formatted as
> > NTFS, so that is a valid model today.
> Is it an SD Card? I have little interest in hooking my cell up to a USB
> powered hard drive at the moment. 

My cell phone hooks up to a USB powered hard drive at the moment :)
It can also drive a monitor through the usb connection, you would be
amazed what you can do with these things these days.

> > > > Look at how filesystems work from userspace, they achieve _very_
fast
> > > > speeds due to mmap and friends.  Heck, some people try to get the OS
out
> > > > of the way entirely by just using direct I/O, or taking to the raw
block
> > > > device.  Not by trying to allocate raw filesystem blocks from
userspace,
> > > > that way lies madness.
> > > Well, it is not really the filesystem that necessarily bottlenecks the
> > > performance. It is usually that in combination with the hardware data
> > > path that this usage implies. If you want to sync a phone without a
> > > sideloading accelerator, the data path taken is usually as follows:
> > > 
> > > 1) data received by USB peripheral, typically into fifos
> > > 2) cpu gets interrupted, sees that data is there
> > > 3) cpu sets up DMA transfer to SDRAM to cache data
> > > 4) At some point CPU initiates DMA transfer from SDRAM to removable
> > > media.
> > 
> > Wait, step 4 is a big jump.  Userspace should be reading that data, and
> > then writing it back out to a file it opened, not this "dma directly to
> > media" stuff.
> My statement was that the hardware and software is convoluted and the
> data path hits different memories multiple times. Your response seems to
> be that I left out one of the memory copies to userspace. I think that
> adds to my point, doesn't it?

Possibly, if those memory copies take a lot of time.

How are all of the other platforms that use Linux as this type of
device, or even a usb-storage device (of which there are lots) able to
hit the very fast transfer rates that I have seen so far without needing
to do this type of preallocation?

> > And yes, you can stream it if you want from userspace to the file if
> > that's faster, but odds are mmap() will work best here.
> Ok, but I don't want the data to hit userspace unless the file is read
> back. Does using mmap support this scenario?

Yes.

> > > 5) depending on the peripheral implementation, data may be buffered
> > > either in the peripheral (SD/MMC controller) or in the DMA engine
> > > itself.
> > 
> > Yes, you don't know what is backing that filesystem, that's the big
> > issue, just as you don't know what type of filesystem it is, from within
> > the kernel.
> Can't I pass this information into the driver using the ioctl call? If
> the filesystem is not fat and not removable, this driver should likely
> not be used, at least not for this purpose.

No, the driver never knows this type of information.  And for good
reason, you could have 4 different partitions on this block device, all
different filesystems.  The block driver should never care about the
filesystem underneath it.

thanks,

greg k-h


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

