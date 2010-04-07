Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab0DGPqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:46:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37688 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932650Ab0DGPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:46:18 -0400
Date: Wed, 7 Apr 2010 11:46:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       <alsa-devel@alsa-project.org>, <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100407151125.GJ30801@buzzloop.caiaq.de>
Message-ID: <Pine.LNX.4.44L0.1004071120200.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Daniel Mack wrote:

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

No.  It says so right in the title line of the kerneldoc:

 * usb_buffer_alloc - allocate dma-consistent buffer for URB_NO_xxx_DMA_MAP

That is not what people want when they call kzalloc or kmalloc.

> If not, I would rather introduce a new function than adding GFP_ flags
> to all existing drivers.

All right.  But there would have to be _two_ new functions: one acting 
like kmalloc and another acting like kzalloc.  I guess they should take 
a pointer to struct usb_device as an argument, like usb_buffer_alloc.

> I vote for a clean solution, a fixup of existing implementations and
> a clear note about how to allocate buffers for USB drivers. I believe
> faulty allocations of this kind can explain quite a lot of problems on
> x86_64 machines.

There is one awkward aspect of usb_buffer_alloc which perhaps could
be fixed at the same time.  Under some conditions (for example, if the
controller needs to use internal bounce buffers) it will return
ordinary memory obtained using kmalloc rather than consistent memory.  
But it doesn't tell the caller when it has done so, and consequently
the caller will always specify URB_NO_TRANSFER_DMA_MAP when using the
buffer.  The proper flag to use should be returned to the caller.

Or alternatively, instead of allocating regular memory the routine
could simply fail.  Then the caller would be responsible for checking
and using regular memory instead of dma-consistent memory.  Of course,
that would put an even larger burden on the caller than just forcing it
to keep track of what flag to use.

> > > If what I've stated is true, there are quite some more drivers affected
> > > by this issue.
> > 
> > Practically every USB driver, I should think.  And maybe a lot of 
> > non-USB drivers too.
> 
> I found many such problems in drivers/media/{dvb,video},
> drivers/usb/serial, sound/usb and even in the USB core. If we agree on
> how to fix that nicely, I can take some of them.

I guess we could rename usb_buffer_alloc().  A more accurate name would
be something like usb_alloc_consistent() (except for the fact that
the routine falls back to regular memory if the controller can't use
consistent memory.)  Then we could have usb_malloc() and usb_zalloc()
in addition.

Alan Stern

