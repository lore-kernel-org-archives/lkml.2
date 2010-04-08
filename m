Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0DHAfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:35:36 -0400
Received: from kroah.org ([198.145.64.141]:44207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab0DHAff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:35:35 -0400
Date: Wed, 7 Apr 2010 17:33:13 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Takashi Iwai <tiwai@suse.de>, Daniel Mack <daniel@caiaq.de>,
       linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100408003313.GE4365@kroah.com>
References: <s5hhbnncflj.wl%tiwai@suse.de>
 <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 03:13:11PM -0400, Alan Stern wrote:
> On Wed, 7 Apr 2010, Takashi Iwai wrote:
> 
> > > Ok, I'll write some dummies for usb_malloc() and usb_zalloc() which
> > > will just call kmalloc() with GFP_DMA32 for now.
> > 
> > Can't we provide only zalloc() variant?  Zero'ing doesn't cost much,
> > and the buffer allocation shouldn't be called too often.
> 
> Linus specifically requested us to avoid using kzalloc in usbfs.  I
> can't find the message in the email archives, but Greg KH should be
> able to confirm it.
> 
> As long as we're imitating kmalloc for one use, we might as well make
> it available to all.
> 
> > > And while at it,
> > > usb_alloc_buffer() will be renamed to usb_alloc_consistent().
> > 
> > Most of recent functions are named with "coherent".
> 
> Yes, the terminology got a little confused between the PCI and DMA
> realms.  I agree, "coherent" is better.
> 
> BTW, although some EHCI controllers may support 64-bit DMA, the driver 
> contains this:
> 
> 	if (HCC_64BIT_ADDR(hcc_params)) {
> 		ehci_writel(ehci, 0, &ehci->regs->segment);
> #if 0
> // this is deeply broken on almost all architectures
> 		if (!dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
> 			ehci_info(ehci, "enabled 64bit DMA\n");
> #endif
> 	}
> 
> I don't know if the comment is still true, but until the "#if 0" is 
> removed, ehci-hcd won't make use of 64-bit DMA.

I think someone tried to remove it recently, but I wouldn't let them :)

What a mess, hopefully xhci will just take over and save the world from
this whole thing...

thanks,

greg k-h
