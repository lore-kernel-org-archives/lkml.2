Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab0KBKlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 06:41:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0KBKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 06:41:13 -0400
Date: Tue, 2 Nov 2010 11:41:04 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
        julia@diku.dk
Subject: Re: should struct device.dma_mask still be a pointer?
Message-ID: <20101102104104.GR31158@pengutronix.de>
References: <20100622105233.GA4755@pengutronix.de> <20100701103544A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100701103544A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm picking up this old thread because I'm currently faced again with
this problem ... and I'm really annoyed about it.

On Thu, Jul 01, 2010 at 10:35:58AM +0900, FUJITA Tomonori wrote:
> > IMHO it's strange that struct device.dma_mask is a pointer instead of a
> > plain u64.  The reason this was done back then is described in
> > 8ab1bc19e974fdebe76c065fe444979c84ba2f74[1]:
> > 
> > 	Attached is a patch which moves dma_mask into struct device and cleans up the
> > 	scsi mid-layer to use it (instead of using struct pci_dev).  The advantage to
> > 	doing this is probably most apparent on non-pci bus architectures where
> > 	currently you have to construct a fake pci_dev just so you can get the bounce
> > 	buffers to work correctly.
> > 
> > 	The patch tries to perturb the minimum amount of code, so dma_mask in struct
> > 	device is simply a pointer to the one in pci_dev.  However, it will make it
> > 	easy for me now to add generic device to MCA without having to go the fake pci
> > 	route.
> 
> Yeah, that's a strange design. As the commit log said, it's due to the
> historical reason. We invented the pci dma model first then moved to
> the generic dma model.
> 
> 
> > As I work on such a non-pci bus architecture it's still ugly that this
> > is a pointer because I have to allocate extra memory for that.
> 
> The popular trick to avoid allocating the extra memory for that is:
> 
> device.dma_mask = &device.coherent_dma_mask;
Does this work in general?  Or are there any corner cases that make this
trick fail?

> > Is there a reason not to get rid of struct pci_dev.dma_mask and use
> > struct pci_dev.dev.dma_mask instead?  (Well apart from the needed
> > effort of course.)
> > 
> > If not, the following would be needed:
> > 
> > 	- remove struct pci.dma_mask
> > 	- make struct device.dma_mask an u64 (instead of u64*)
> > 	- substitue var.dma_mask by var.dev.dma_mask for all
> > 	  struct pci_dev var
> > 	- substitue var.dma_mask by &(var.dma_mask) for all
> > 	  struct device var
> > 
> > and note that there are statically initialized struct device (and maybe
> > struct pci_dev?) that need fixing, too.  (e.g.
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mach-mx2/devices.c;h=a0aeb8a4adc19ef419a0a045ad3b882131597106;hb=HEAD#l265
> > )
> 
> That's exactly the perturbation that the commit log refers to.
> 
> We need to modify all the struct device at a time. We could, however,
> I don't think that it's worth doing. Little gain.
> 
> 
> > Additionally this could be done for struct device.dma_parms.
> 
> Yeah, we should have all the dma parameters in dma_parms.
That applies to dma_mask and coherent_dma_mask, too, I assume?

Instead of converting all at a time, what about adding an
u64 dma_mask_real to struct device (assuming coherent_dma_mask cannot be
used for it) and use this if dma_mask is NULL.  For me it would make
live a bit easier, because for some time I could just use
device.dma_mask = &device.dma_mask_real instead of allocating an u64
dynamically.  Together with some accessor functions and deprecating
direct access to the dma related members of struct device the drivers
and architectures could be converted one after another.  The final step
to get rid of the pointers would be small then.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
