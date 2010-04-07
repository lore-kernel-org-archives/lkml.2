Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab0DGPLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:11:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53515 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab0DGPLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:11:34 -0400
Date: Wed, 7 Apr 2010 17:11:25 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100407151125.GJ30801@buzzloop.caiaq.de>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
 <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 10:59:47AM -0400, Alan Stern wrote:
> On Wed, 7 Apr 2010, Daniel Mack wrote:
> > Depending on the condition of the memory management, things might work
> > or not, and especially right after a reboot, there's a better chance to
> > get lower memory.
> > 
> > The fix is to use usb_buffer_alloc() for that purpose which ensures
> > memory that is suitable for DMA. And on x86_64, this also means that the
> > upper 32 bits of the address returned are all 0's.
> 
> That is not a good fix.  usb_buffer_alloc() provides coherent memory, 
> which is not what we want.  I believe the correct fix is to specify the 
> GFP_DMA32 flag in the kzalloc() call.
> 
> Of course, some EHCI hardware _is_ capable of using 64-bit addresses.  
> But not all, and other controller types aren't.  In principle we could
> create a new allocation routine, which would take a pointer to the USB
> bus as an additional argument and use it to decide whether the memory 
> needs to lie below 4 GB.  I'm not sure adding this extra complexity 
> would be worthwhile.

Well, I thought this is exactly what the usb_buffer_alloc() abstraction
functions are there for. We already pass a pointer to a struct
usb_device, so the routine knows which host controller it operates on.
So we can safely dispatch all the magic inside this function, no?

If not, I would rather introduce a new function than adding GFP_ flags
to all existing drivers.

I vote for a clean solution, a fixup of existing implementations and
a clear note about how to allocate buffers for USB drivers. I believe
faulty allocations of this kind can explain quite a lot of problems on
x86_64 machines.

> > If what I've stated is true, there are quite some more drivers affected
> > by this issue.
> 
> Practically every USB driver, I should think.  And maybe a lot of 
> non-USB drivers too.

I found many such problems in drivers/media/{dvb,video},
drivers/usb/serial, sound/usb and even in the USB core. If we agree on
how to fix that nicely, I can take some of them.

Daniel
