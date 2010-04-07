Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab0DGPcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:32:00 -0400
Received: from kroah.org ([198.145.64.141]:52679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684Ab0DGPb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:31:58 -0400
Date: Wed, 7 Apr 2010 08:31:54 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100407153154.GC13425@kroah.com>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
 <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
 <20100407151125.GJ30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407151125.GJ30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 05:11:25PM +0200, Daniel Mack wrote:
> On Wed, Apr 07, 2010 at 10:59:47AM -0400, Alan Stern wrote:
> > On Wed, 7 Apr 2010, Daniel Mack wrote:
> > > Depending on the condition of the memory management, things might work
> > > or not, and especially right after a reboot, there's a better chance to
> > > get lower memory.
> > > 
> > > The fix is to use usb_buffer_alloc() for that purpose which ensures
> > > memory that is suitable for DMA. And on x86_64, this also means that the
> > > upper 32 bits of the address returned are all 0's.
> > 
> > That is not a good fix.  usb_buffer_alloc() provides coherent memory, 
> > which is not what we want.  I believe the correct fix is to specify the 
> > GFP_DMA32 flag in the kzalloc() call.
> > 
> > Of course, some EHCI hardware _is_ capable of using 64-bit addresses.  
> > But not all, and other controller types aren't.  In principle we could
> > create a new allocation routine, which would take a pointer to the USB
> > bus as an additional argument and use it to decide whether the memory 
> > needs to lie below 4 GB.  I'm not sure adding this extra complexity 
> > would be worthwhile.
> 
> Well, I thought this is exactly what the usb_buffer_alloc() abstraction
> functions are there for. We already pass a pointer to a struct
> usb_device, so the routine knows which host controller it operates on.
> So we can safely dispatch all the magic inside this function, no?

Hm, yeah, I thought that is what it was for too.  If not, why can't we
use it like this?

> If not, I would rather introduce a new function than adding GFP_ flags
> to all existing drivers.

I agree.

> I vote for a clean solution, a fixup of existing implementations and
> a clear note about how to allocate buffers for USB drivers. I believe
> faulty allocations of this kind can explain quite a lot of problems on
> x86_64 machines.

Yeah, I really don't want to have to change every driver in different
ways just depending on if someone thinks it is going to need to run on
this wierd hardware.

Alan, any objection to just using usb_buffer_alloc() for every driver?
Or is that too much overhead?

thanks,

greg k-h
