Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0DIOmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:42:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51406 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753472Ab0DIOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:41:48 -0400
Date: Fri, 9 Apr 2010 10:41:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Daniel Mack <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <201004090804.36213.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1004091033150.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Oliver Neukum wrote:

> Am Freitag, 9. April 2010 00:20:36 schrieb Alan Stern:
> > > > That would work, but it doesn't match the way existing drivers use the
> > > > interface.  For example, the audio driver allocates a 16-byte coherent
> > > > buffer and then uses four bytes from it for each of four different 
> > > > URBs.
> > > 
> > > That will not work with any fallback that does not yield a coherent buffer.
> > 
> > What you mean isn't entirely clear.  But it certainly does work in 
> > various circumstances that don't yield coherent buffers.  For example, 
> > it works if the controller uses PIO instead of DMA.  It also works if 
> > the controller uses DMA and the URBs have to be bounced.
> 
> It'll work on x86. On incoherent architectures this violates the cacheline
> rules for DMA-mapping if you have to bounce.

Not true.  Consider: The driver allocates a 16-byte buffer (xbuf)  
divided up into four sets of four bytes, and sets

	urb[i].transfer_buffer_dma = xbuf_dma + 4*i;

Then usb_submit_urb(urb[i]) will copy the appropriate four bytes to a
bounce buffer and map the bounce buffer.  Accesses to the other parts
of xbuf won't violate the cacheline rules, because xbuf isn't mapped
for DMA -- only the bounce buffer is.  When urb[i] completes, the
bounce buffer contents will be copied back to the original four bytes
in xbuf.  Again, there is no violation of cacheline rules.

> So it seems to me that
> if you want to share a buffer between URBs, it must be coherent.

No.  But it must be allocated via usb_alloc_buffer() (or whatever that 
routine gets renamed to).

Alan Stern

