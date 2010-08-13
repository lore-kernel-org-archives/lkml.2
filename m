Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060Ab0HMTBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:01:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0HMTBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:01:54 -0400
Date: Fri, 13 Aug 2010 12:01:28 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100813190128.GA1372@suse.de>
References: <1281721539.5839.4.camel@odc-laptop>
 <20100813175402.GA15024@suse.de>
 <1281724992.12189.16.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281724992.12189.16.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 11:43:12AM -0700, David Cross wrote:
> On Fri, 2010-08-13 at 10:54 -0700, Greg KH wrote:
> > On Fri, Aug 13, 2010 at 10:45:39AM -0700, David Cross wrote:
> > > Hello Hirofumi,
> > > I would like to export this symbol from the vfat code and add this patch
> > > to the Linux kernel. You are listed as the MAINTAINER for FAT and VFAT.
> > > As such, I need your approval to do it. 
> > > The reason that I need to export this symbol is to allow for file based
> > > DMA in which the file needs to be pre-allocated. The pre-allocated block
> > > addresses are passed to a DMA engine which then directly transfers the
> > > data to non-volatile storage.
> > > Please let me know if you have any objections to exporting this symbol
> > > or if you need additional information from me concerning this change
> > > request. I am happy to answer any questions that you may have about this
> > > in the meantime.
> > 
> > Wait, _I_ have an objection to exporting this symbol.
> > 
> > I really don't think it is needed at this point in time, as we really
> > need to figure out exactly what your driver is doing to want to need to
> > call this function.
> 
> OK, I am trying to answer all questions on this topic that I am getting,
> but honestly I have not gotten a lot so far. 

That's because not many people have noticed the code yet :)

> > So please, let's not export it for now, when we get to the point that we
> > all agree that this driver is doing the "correct" thing, then we can
> > export the symbol, ok?
> 
> Sure, I think that the driver is doing the correct thing, but that is
> mostly because I have not found another way to solve this issue.

What specifically is the issue here that you are trying to solve?

And why has no other driver ever needed this type of functionality
before?

> > thanks,
> 
> >Also, why do this at the FAT level, and not more correctly at the block
> > layer level? 
> The short answer is that the block level does not have the file system
> awareness needed to determine where a file should be stored on the NVM
> device. 
> The longer answer is to consider the case of an MTP host, which operates
> at the file level. It sends the mobile (Linux) device "SendObject" which
> tells it to store the file on its file system. When the device receives
> this, it has two options:
> 1) receive all data, buffer it, then write the file. This is typically a
> slow process USB->Processor->SDRAM->Processor/DMA engine->Media
> 2) pre-allocate the file as soon as it knows that it is coming and how
> big it is, and then send the block addresses to an external DMA engine
> and let it transfer the data from the MTP host directly

We have a userspace MTP driver for Linux, using gadgetfs, right?  So
none of this is applicable from what I can tell.

> The West Bridge driver goes for option two for performance reasons. In
> doing this, it needs to get information from the file system on where to
> store the file.

Look at how Linux already handles MTP for how to handle this properly, I
don't think there is any need to do any of this from within the kernel.

> >What happens if this isn't a FAT partition on the >device?
> Good question. So far, it has been stored on a FAT partition in most use
> cases because the user typically wants the option to enumerate the
> device as mass storage as well or be able to see content on a PC if the
> SD card is removed. However, there is no reason that this could not be
> done with ext2 or other filesystems on non-removable media.

Like NTFS?  How are you going to handle that when you run out of size
due to the limitations of FAT?  Hint, that's not going to work with this
type of solution...

> This would require some work to figure out how to implement a
> pre-allocation interface with it. Alternatively a more general
> pre-allocation interface could be added (falloc()) to implemented file
> systems to make this process easier.  

Userspace handles this quite easily already, see above.

thanks,

greg k-h
