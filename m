Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0KBOsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:48:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:40619 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0KBOse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:48:34 -0400
Date: Tue, 2 Nov 2010 23:43:45 +0900
To: u.kleine-koenig@pengutronix.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        akpm@linux-foundation.org, julia@diku.dk
Subject: Re: should struct device.dma_mask still be a pointer?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101102134511.GT31158@pengutronix.de>
References: <20101102104104.GR31158@pengutronix.de>
	<20101102215741T.fujita.tomonori@lab.ntt.co.jp>
	<20101102134511.GT31158@pengutronix.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Message-Id: <20101102233812J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Nov 2010 23:43:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010 14:45:11 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> Hello,
> 
> On Tue, Nov 02, 2010 at 10:03:32PM +0900, FUJITA Tomonori wrote:
> > On Tue, 2 Nov 2010 11:41:04 +0100
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > 
> > > > > As I work on such a non-pci bus architecture it's still ugly that this
> > > > > is a pointer because I have to allocate extra memory for that.
> > > > 
> > > > The popular trick to avoid allocating the extra memory for that is:
> > > > 
> > > > device.dma_mask = &device.coherent_dma_mask;
> > > Does this work in general?  Or are there any corner cases that make this
> > > trick fail?
> > 
> > It doesn't work if the coherent dma mask of a device is not same as
> > the dma mask of the device.
> > 
> > 
> > > > > Is there a reason not to get rid of struct pci_dev.dma_mask and use
> > > > > struct pci_dev.dev.dma_mask instead?  (Well apart from the needed
> > > > > effort of course.)
> > > > > 
> > > > > If not, the following would be needed:
> > > > > 
> > > > > 	- remove struct pci.dma_mask
> > > > > 	- make struct device.dma_mask an u64 (instead of u64*)
> > > > > 	- substitue var.dma_mask by var.dev.dma_mask for all
> > > > > 	  struct pci_dev var
> > > > > 	- substitue var.dma_mask by &(var.dma_mask) for all
> > > > > 	  struct device var
> > > > > 
> > > > > and note that there are statically initialized struct device (and maybe
> > > > > struct pci_dev?) that need fixing, too.  (e.g.
> > > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mach-mx2/devices.c;h=a0aeb8a4adc19ef419a0a045ad3b882131597106;hb=HEAD#l265
> > > > > )
> > > > 
> > > > That's exactly the perturbation that the commit log refers to.
> > > > 
> > > > We need to modify all the struct device at a time. We could, however,
> > > > I don't think that it's worth doing. Little gain.
> > > > 
> > > > 
> > > > > Additionally this could be done for struct device.dma_parms.
> > > > 
> > > > Yeah, we should have all the dma parameters in dma_parms.
> > > That applies to dma_mask and coherent_dma_mask, too, I assume?
> > 
> > Yes.
> > 
> > 
> > > Instead of converting all at a time, what about adding an
> > > u64 dma_mask_real to struct device (assuming coherent_dma_mask cannot be
> > > used for it) and use this if dma_mask is NULL.  For me it would make
> > > live a bit easier, because for some time I could just use
> > > device.dma_mask = &device.dma_mask_real instead of allocating an u64
> > > dynamically.  Together with some accessor functions and deprecating
> > > direct access to the dma related members of struct device the drivers
> > > and architectures could be converted one after another.  The final step
> > > to get rid of the pointers would be small then.
> > 
> > But after we finish the above, after all, we still have dma_mask in
> > device strcuture. As I said before, we should move dma stuff to
> > dma_params.
> After we finished the above it's quite easy to move everything into
> dma_parms.  (At least if it's not a pointer, that then again needs an
> additional allocation.)

It should be a pointer. Adding dma stuff in device struct is not
correct logically because not all the users of device struct do dma.
We use device struct everywhere so making device struct fat is not a
good idea. I thought that we had the similar discussion when we
introduced dma_params.

So the above plan doesn't solve your problem. You still need an
additional allocation.


> > I'm not sure why this really troubles you. Can you give me a pointer
> > to what you have been working on? You have been working on non pci
> > device, right? Why can't you do like pci_dev, embedding
> > device_dma_parameters to your own device structure.
> I'm changing the way imx (ARCH=arm) registers its devices.  Currently
> we have in arch/arm/mach-imx/devices.c:
> 
> 	static u64 imx1_camera_dmamask = DMA_BIT_MASK(32);
> 
> 	struct platform_device imx1_camera_device = {
> 		...
> 		.dev = {
> 			.dma_mask = &imx1_camera_dmamask,
> 			.coherent_dma_mask = DMA_BIT_MASK(32),
> 		},
> 		...
> 	}

I know we have lots of such code especially in embedded archs but I
really don't like that. I think that dynamic registration is cleaner.


> and I want to make registration dynamic (e.g. using
> platform_device_register_resndata, see
> arch/arm/plat-mxc/devices/platform-imx-i2c.c for an example).
> 
> Currently I have a function imx_add_platform_device (that does the same
> as platform_device_register_resndata[1]) and now I want to register a
> device that needs .dma_mask set, so I added something like:
> 
> 	if (dmamask) {
>                 /*
>                  * This memory isn't freed when the device is put,
>                  * I don't have a nice idea for that though.  Conceptually
>                  * dma_mask in struct device should not be a pointer.
>                  * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
>                  */
>                 pdev->dev.dma_mask =
>                         kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
>                 if (!pdev->dev.dma_mask)
>                         goto err;
> 
>                 *pdev->dev.dma_mask = dmamask;
>                 pdev->dev.coherent_dma_mask = dmamask;
> 	}
> 
> So there is no private struct I could extend easily.  And I prefer
> cleaning up global oddities instead of being the x-th person to work
> around it.

As I explained above, your cleaning up plan doesn't work for you.

If you want to add dma_mask (and coherent) to device_dma_parameters
struct, I'm for that.

If you really want to avoid aditional allocation, you could invent
your device structure like pci_dev or add device_dma_parameters
struct to arm's pdev_archdata (I don't think that the latter is a good
idea).
