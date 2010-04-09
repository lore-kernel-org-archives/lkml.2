Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0DIQuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:50:21 -0400
Received: from mga05.intel.com ([192.55.52.89]:24917 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869Ab0DIQuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:50:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,178,1270450800"; 
   d="scan'208";a="787848608"
Date: Fri, 9 Apr 2010 09:50:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100409165014.GC5184@xanatos>
References: <s5hhbnncflj.wl%tiwai@suse.de>
 <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
 <20100408003313.GE4365@kroah.com>
 <4BBE6E57.6020600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE6E57.6020600@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 06:01:27PM -0600, Robert Hancock wrote:
> On 04/07/2010 06:33 PM, Greg KH wrote:
> >On Wed, Apr 07, 2010 at 03:13:11PM -0400, Alan Stern wrote:
> >>On Wed, 7 Apr 2010, Takashi Iwai wrote:
> >>
> >>>>Ok, I'll write some dummies for usb_malloc() and usb_zalloc() which
> >>>>will just call kmalloc() with GFP_DMA32 for now.
> >>>
> >>>Can't we provide only zalloc() variant?  Zero'ing doesn't cost much,
> >>>and the buffer allocation shouldn't be called too often.
> >>
> >>Linus specifically requested us to avoid using kzalloc in usbfs.  I
> >>can't find the message in the email archives, but Greg KH should be
> >>able to confirm it.
> >>
> >>As long as we're imitating kmalloc for one use, we might as well make
> >>it available to all.
> >>
> >>>>And while at it,
> >>>>usb_alloc_buffer() will be renamed to usb_alloc_consistent().
> >>>
> >>>Most of recent functions are named with "coherent".
> >>
> >>Yes, the terminology got a little confused between the PCI and DMA
> >>realms.  I agree, "coherent" is better.
> >>
> >>BTW, although some EHCI controllers may support 64-bit DMA, the driver
> >>contains this:
> >>
> >>	if (HCC_64BIT_ADDR(hcc_params)) {
> >>		ehci_writel(ehci, 0,&ehci->regs->segment);
> >>#if 0
> >>// this is deeply broken on almost all architectures
> >>		if (!dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
> >>			ehci_info(ehci, "enabled 64bit DMA\n");
> >>#endif
> >>	}
> >>
> >>I don't know if the comment is still true, but until the "#if 0" is
> >>removed, ehci-hcd won't make use of 64-bit DMA.
> >
> >I think someone tried to remove it recently, but I wouldn't let them :)
> >
> >What a mess, hopefully xhci will just take over and save the world from
> >this whole thing...

I hate to break it to you, but 64-bit DMA support is optional for an
xHCI implementation.  There's a bit in HCCPARAMS that tells whether the
host supports it (see the HCC_64BIT_ADDR macro in xhci.h).  The xHCI
driver currently doesn't do anything with that bit, although it should.
All the implementations I've seen do 64-bit DMA.

> True.. except for the fact that the xhci driver currently doesn't do
> 64-bit DMA either

What makes you think that?  I've seen URB buffers with 64-bit DMA
addresses.  I can tell when the debug polling loop runs and I look at
the DMA addresses the xHCI driver is feeding to the hardware:

Dev 1 endpoint ring 0:
xhci_hcd 0000:05:00.0: @71a49800 01000680 00080000 00000008 00000841

So the TRB at address 71a49800 is pointing to a buffer at address
0x0008000001000680.

If I'm setting a DMA mask wrong somewhere, or doing something else to
limit the DMA to 32-bit, then please let me know.

> nor does it support MSI even though the HW
> supports it (surprisingly enough the NEC Windows driver does, MSI-X
> even).

There's a patch from AMD to enable MSI-X.  The code was there, just
commented out because the early prototypes didn't do MSI-X.

> At this point only Intel likely knows how to do this
> properly, though, since AFAICS the spec isn't publicly available
> yet.

I have tried very hard to fix this, and will continue to do so.

Sarah Sharp
