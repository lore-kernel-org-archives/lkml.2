Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0GABgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:36:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:59635 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0GABgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:36:54 -0400
Date: Thu, 1 Jul 2010 10:35:58 +0900
To: u.kleine-koenig@pengutronix.de
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       julia@diku.dk
Subject: Re: should struct device.dma_mask still be a pointer?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100622105233.GA4755@pengutronix.de>
References: <20100622105233.GA4755@pengutronix.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100701103544A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 01 Jul 2010 10:35:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMHO it's strange that struct device.dma_mask is a pointer instead of a
> plain u64.  The reason this was done back then is described in
> 8ab1bc19e974fdebe76c065fe444979c84ba2f74[1]:
> 
> 	Attached is a patch which moves dma_mask into struct device and cleans up the
> 	scsi mid-layer to use it (instead of using struct pci_dev).  The advantage to
> 	doing this is probably most apparent on non-pci bus architectures where
> 	currently you have to construct a fake pci_dev just so you can get the bounce
> 	buffers to work correctly.
> 
> 	The patch tries to perturb the minimum amount of code, so dma_mask in struct
> 	device is simply a pointer to the one in pci_dev.  However, it will make it
> 	easy for me now to add generic device to MCA without having to go the fake pci
> 	route.

Yeah, that's a strange design. As the commit log said, it's due to the
historical reason. We invented the pci dma model first then moved to
the generic dma model.


> As I work on such a non-pci bus architecture it's still ugly that this
> is a pointer because I have to allocate extra memory for that.

The popular trick to avoid allocating the extra memory for that is:

device.dma_mask = &device.coherent_dma_mask;


> Is there a reason not to get rid of struct pci_dev.dma_mask and use
> struct pci_dev.dev.dma_mask instead?  (Well apart from the needed
> effort of course.)
> 
> If not, the following would be needed:
> 
> 	- remove struct pci.dma_mask
> 	- make struct device.dma_mask an u64 (instead of u64*)
> 	- substitue var.dma_mask by var.dev.dma_mask for all
> 	  struct pci_dev var
> 	- substitue var.dma_mask by &(var.dma_mask) for all
> 	  struct device var
> 
> and note that there are statically initialized struct device (and maybe
> struct pci_dev?) that need fixing, too.  (e.g.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mach-mx2/devices.c;h=a0aeb8a4adc19ef419a0a045ad3b882131597106;hb=HEAD#l265
> )

That's exactly the perturbation that the commit log refers to.

We need to modify all the struct device at a time. We could, however,
I don't think that it's worth doing. Little gain.


> Additionally this could be done for struct device.dma_parms.

Yeah, we should have all the dma parameters in dma_parms.
