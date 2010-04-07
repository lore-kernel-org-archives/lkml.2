Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0DGTNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 15:13:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43275 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757216Ab0DGTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 15:13:12 -0400
Date: Wed, 7 Apr 2010 15:13:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Takashi Iwai <tiwai@suse.de>
cc: Daniel Mack <daniel@caiaq.de>, Greg KH <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, Pedro Ribeiro <pedrib@gmail.com>,
       <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       <alsa-devel@alsa-project.org>, <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <s5hhbnncflj.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Takashi Iwai wrote:

> > Ok, I'll write some dummies for usb_malloc() and usb_zalloc() which
> > will just call kmalloc() with GFP_DMA32 for now.
> 
> Can't we provide only zalloc() variant?  Zero'ing doesn't cost much,
> and the buffer allocation shouldn't be called too often.

Linus specifically requested us to avoid using kzalloc in usbfs.  I
can't find the message in the email archives, but Greg KH should be
able to confirm it.

As long as we're imitating kmalloc for one use, we might as well make
it available to all.

> > And while at it,
> > usb_alloc_buffer() will be renamed to usb_alloc_consistent().
> 
> Most of recent functions are named with "coherent".

Yes, the terminology got a little confused between the PCI and DMA
realms.  I agree, "coherent" is better.

BTW, although some EHCI controllers may support 64-bit DMA, the driver 
contains this:

	if (HCC_64BIT_ADDR(hcc_params)) {
		ehci_writel(ehci, 0, &ehci->regs->segment);
#if 0
// this is deeply broken on almost all architectures
		if (!dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
			ehci_info(ehci, "enabled 64bit DMA\n");
#endif
	}

I don't know if the comment is still true, but until the "#if 0" is 
removed, ehci-hcd won't make use of 64-bit DMA.

Note also that just before the lines above, ehci-hcd.c contains this
comment:

	 * pci_pool consistent memory always uses segment zero.

(Nowadays the driver uses dma_pool, not pci_pool.)  As far as I can
tell, this comment isn't true on 64-bit systems, but nevertheless,
ehci-hcd relies on it.  Of course it _is_ true for devices whose DMA
mask indicates they can't use memory above 4 GB -- but if ehci-hcd is
changed to enlarge the DMA mask then how do we force dma_pool memory to
lie below 4 GB?

[Actually it isn't _really_ necessary for the dma_pool to lie below 4 
GB.  But ehci-hcd allocates several pools, and it _is_ necessary for 
all of them to lie in the _same_ 4 GB segment.  The easiest way to do 
that is to put them all in segment 0.]

Alan Stern

