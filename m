Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097Ab0HMTR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:17:57 -0400
Received: from ns2.cypress.com ([157.95.67.5]:46275 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab0HMTRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:17:55 -0400
Subject: Re: EXPORT_SYMBOL(fat_get_block)
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: Greg KH <gregkh@suse.de>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
In-Reply-To: <20100813190128.GA1372@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
	 <20100813175402.GA15024@suse.de> <1281724992.12189.16.camel@odc-laptop>
	 <20100813190128.GA1372@suse.de>
Content-Type: text/plain
Organization: Cypress
Date: Fri, 13 Aug 2010 12:17:39 -0700
Message-Id: <1281727059.16672.20.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 12:01 -0700, Greg KH wrote:
> On Fri, Aug 13, 2010 at 11:43:12AM -0700, David Cross wrote:
> > On Fri, 2010-08-13 at 10:54 -0700, Greg KH wrote:
> > > On Fri, Aug 13, 2010 at 10:45:39AM -0700, David Cross wrote:
> > > > Hello Hirofumi,
> > > > I would like to export this symbol from the vfat code and add this patch
> > > > to the Linux kernel. You are listed as the MAINTAINER for FAT and VFAT.
> > > > As such, I need your approval to do it. 
> > > > The reason that I need to export this symbol is to allow for file based
> > > > DMA in which the file needs to be pre-allocated. The pre-allocated block
> > > > addresses are passed to a DMA engine which then directly transfers the
> > > > data to non-volatile storage.
> > > > Please let me know if you have any objections to exporting this symbol
> > > > or if you need additional information from me concerning this change
> > > > request. I am happy to answer any questions that you may have about this
> > > > in the meantime.
> > > 
> > > Wait, _I_ have an objection to exporting this symbol.
> > > 
> > > I really don't think it is needed at this point in time, as we really
> > > need to figure out exactly what your driver is doing to want to need to
> > > call this function.
> > 
> > OK, I am trying to answer all questions on this topic that I am getting,
> > but honestly I have not gotten a lot so far. 
> 
> That's because not many people have noticed the code yet :)
> 
> > > So please, let's not export it for now, when we get to the point that we
> > > all agree that this driver is doing the "correct" thing, then we can
> > > export the symbol, ok?
> > 
> > Sure, I think that the driver is doing the correct thing, but that is
> > mostly because I have not found another way to solve this issue.
> 
> What specifically is the issue here that you are trying to solve?
  We are trying to solve the issue of all data needing to go through the
processor, even when its ultimate destination is non-volatile media.
	
> And why has no other driver ever needed this type of functionality
> before?
  I am not sure, but my guess is because this represents a novel solution to 
a performance problem.

> > > thanks,
> > 
> > >Also, why do this at the FAT level, and not more correctly at the block
> > > layer level? 
> > The short answer is that the block level does not have the file system
> > awareness needed to determine where a file should be stored on the NVM
> > device. 
> > The longer answer is to consider the case of an MTP host, which operates
> > at the file level. It sends the mobile (Linux) device "SendObject" which
> > tells it to store the file on its file system. When the device receives
> > this, it has two options:
> > 1) receive all data, buffer it, then write the file. This is typically a
> > slow process USB->Processor->SDRAM->Processor/DMA engine->Media
> > 2) pre-allocate the file as soon as it knows that it is coming and how
> > big it is, and then send the block addresses to an external DMA engine
> > and let it transfer the data from the MTP host directly
> 
> We have a userspace MTP driver for Linux, using gadgetfs, right?  So
> none of this is applicable from what I can tell.
Yes, the g_mtp development has started, but it is not integrated yet
last I checked. Most of the applications for this driver have used
gadgetfs as well in order to handle the protocol itself. So, I think it
is applicable.

> > The West Bridge driver goes for option two for performance reasons. In
> > doing this, it needs to get information from the file system on where to
> > store the file.
> 
> Look at how Linux already handles MTP for how to handle this properly, I
> don't think there is any need to do any of this from within the kernel.
I somewhat familiar with how Linux handles MTP. The current model is
CPU-centric and all data goes through the main processor from what I
have seen. This is a working solution, but not always a very fast one. I
agree though that this would not need to be done within the kernel if we
had a userspace method for file allocation and commitment.

> > >What happens if this isn't a FAT partition on the >device?
> > Good question. So far, it has been stored on a FAT partition in most use
> > cases because the user typically wants the option to enumerate the
> > device as mass storage as well or be able to see content on a PC if the
> > SD card is removed. However, there is no reason that this could not be
> > done with ext2 or other filesystems on non-removable media.
> 
> Like NTFS?  How are you going to handle that when you run out of size
> due to the limitations of FAT?  Hint, that's not going to work with this
> type of solution...
Isn't this also a userspace problem? When I run out of space on my Linux machine,
the message "no space left on device" pops up. Why is this solution any
more prone to size limitations compared with any other?

> > This would require some work to figure out how to implement a
> > pre-allocation interface with it. Alternatively a more general
> > pre-allocation interface could be added (falloc()) to implemented file
> > systems to make this process easier.  
> 
> Userspace handles this quite easily already, see above.
I don't see how userspace handles this from the comments above. I do
understand that there is a userspace MTP driver, but I don't see a
method for pre-allocation of files from the information above. Am I
missing something?

Thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

