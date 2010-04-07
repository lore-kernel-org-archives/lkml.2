Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0DGO7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:59:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42561 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932690Ab0DGO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:59:48 -0400
Date: Wed, 7 Apr 2010 10:59:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       <alsa-devel@alsa-project.org>, <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100407090623.GN30807@buzzloop.caiaq.de>
Message-ID: <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Daniel Mack wrote:

> Hi,
> 
> I was pointed to https://bugzilla.kernel.org/show_bug.cgi?id=15580 by
> Pedro Ribeiro, and unfortunately I'm pretty late in the game. I wasn't
> aware of that thread until yesterday.
> 
> While the report is quite confusing, the reason seams pretty clear to me
> as I've been thru quite some time-demanding debugging of a very similar
> issue on Mac OS X. But I'm not totally sure whether we really hit the
> same issue here, so I'd like to have your opinions first.
> 
> The problem is appearantly the way the transfer buffer is allocated in
> the drivers. In the snd-usb-caiaq driver, I used kzalloc() to get memory
> which works fine on 32bit systems. On x86_64, however, it seems that
> kzalloc() hands out memory beyond the 32bit addressable boundary, which
> the DMA controller of the 32bit PCI-connected EHCI controller is unable
> to write to or read from. Am I correct on this conclusion?

That seems like the right answer.  You are correct that an EHCI 
controller capable only of 32-bit memory accesses would not be able to 
use a buffer above the 4 GB line.

> Depending on the condition of the memory management, things might work
> or not, and especially right after a reboot, there's a better chance to
> get lower memory.
> 
> The fix is to use usb_buffer_alloc() for that purpose which ensures
> memory that is suitable for DMA. And on x86_64, this also means that the
> upper 32 bits of the address returned are all 0's.

That is not a good fix.  usb_buffer_alloc() provides coherent memory, 
which is not what we want.  I believe the correct fix is to specify the 
GFP_DMA32 flag in the kzalloc() call.

Of course, some EHCI hardware _is_ capable of using 64-bit addresses.  
But not all, and other controller types aren't.  In principle we could
create a new allocation routine, which would take a pointer to the USB
bus as an additional argument and use it to decide whether the memory 
needs to lie below 4 GB.  I'm not sure adding this extra complexity 
would be worthwhile.

> If what I've stated is true, there are quite some more drivers affected
> by this issue.

Practically every USB driver, I should think.  And maybe a lot of 
non-USB drivers too.

> I collected a list of places where similar fixes are
> needed, and I can send patches if I get a thumbs-up.
> 
> Pedro is currently testing a patch I sent out yesterday.

Good work -- it certainly would have taken me a long time to figure 
this out.

Alan Stern

