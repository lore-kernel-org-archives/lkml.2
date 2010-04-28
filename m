Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0D1RgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:36:04 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:57844 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0D1RgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:36:00 -0400
X-Spam-Processed: digidescorp.com, Wed, 28 Apr 2010 12:35:57 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 12.54.16.226
X-Return-Path: prvs=173405f1c6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [microblaze-uclinux] [PATCHv2] [RFC] Xilinx MPMC SDMA subsystem
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: Sergey Temerkhanov <temerkhanov@yandex.ru>, linuxppc-dev@lists.ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <n2vfa686aa41004272213wceeef998tadc483ec1de7b792@mail.gmail.com>
References: <201004280206.38220.temerkhanov@yandex.ru>
	 <1272421344.2877.6.camel@iscandar.digidescorp.com>
	 <1272421789.2877.21.camel@iscandar.digidescorp.com>
	 <n2vfa686aa41004272213wceeef998tadc483ec1de7b792@mail.gmail.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Wed, 28 Apr 2010 12:35:50 -0500
Message-Id: <1272476150.2956.51.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant -

Thanks for the feedback. My responses are inline.

--Steve

On Tue, 2010-04-27 at 23:13 -0600, Grant Likely wrote: 
> Hi Sergey and Steven,
> 
> On Tue, Apr 27, 2010 at 8:29 PM, Steven J. Magnani
> <steve@digidescorp.com> wrote:
> > On Wed, 2010-04-28 at 02:06 +0400, Sergey Temerkhanov wrote:
> >> This is the 2nd version of Xilinx MPMC LocalLink SDMA subsystem
> >>

[snip] 

> >> diff -r baced9e29ab5 drivers/dma/Kconfig
> >> --- a/drivers/dma/Kconfig     Tue Apr 27 20:48:50 2010 +0400
> >> +++ b/drivers/dma/Kconfig     Wed Apr 28 02:00:51 2010 +0400
> >> @@ -97,6 +97,14 @@
> >>         Support the TXx9 SoC internal DMA controller.  This can be
> >>         integrated in chips such as the Toshiba TX4927/38/39.
> >>
> >> +config XLLSDMA
> 
> I'd prefer XILINX_LLSDMA.  XLLSDMA could be ambiguous in the global
> namespace (for a human reader), particularly as it is something that
> few people will actually see.
> 
> >> +     bool "Xilinx MPMC DMA support"
> >> +     depends on XILINX_VIRTEX || MICROBLAZE
> >> +     select DMA_ENGINE
> >> +     help
> >> +       Support fot Xilinx MPMC LocalLink SDMA. Virtex FPGA family
> >> +       has it integrated or fabric-based.
> >> +
> >
> > fot --> for
> >
> > Since the xllsdma driver provides services to other drivers - not to userland -
> > I think this would be better as a "silent" option, selected automatically when
> > something like ll_temac or the forthcoming Xilinx DMA engine is selected.
> > If we do it that way, note that XLLSDMA is independent of DMA_ENGINE so
> > drivers/Makefile will need to be patched so that the dma subdirectory is
> > always "y".
> 
> Agreed.  However, looking at this code, I don't see anything that
> actually uses DMA_ENGINE here.  Am I missing something?

This is a low-level driver that provides services to ll_temac and the
(still in the works) DMA engine driver. There's no real relationship
between this driver and DMA_ENGINE, and the still-in-the-works driver
will come later after we stabilize the interface of this one.

> >> +++ b/drivers/dma/xllsdma.c   Wed Apr 28 02:00:51 2010 +0400

[snip] 

> >> +
> >> +static int __devinit mpmc_of_probe(struct of_device *op,
> >> +                     const struct of_device_id *match)
> >> +{
> >> +     int err = mpmc_init(&op->dev);
> >> +     if (err)
> >> +             return err;
> >> +
> >> +     of_platform_bus_probe(op->node, xllsdma_of_match, &op->dev);
> >> +     return 0;
> >> +}
> 
> Okay, I think I've figured out what is bothering me....
> 
> While this *does* work; it really is the long way to go about things.
> Doing it this way requires going back out to the driver model to tell
> it things and trigger a probe on things that *this* driver needs, and
> *this* driver already knows about.  It doesn't need to be this
> complex.
> 
> Rather than register a bunch more of_platform devices, do something
> like this instead:
> 
> +static int __devinit mpmc_of_probe(struct of_device *op,
> +                     const struct of_device_id *match)
> +{
> +     struct mpmc_device *mpmc;
> +     struct device_node *node;
> +
> +     mpmc = mpmc_init(&op->dev);
> +     if (!mpmc)
> +             return -ENODEV;
> +
> +     for_each_child_of_node(op->node, node) {
> +             xllsdma_of_init(mpmc, node);
> +     }
> +     return 0;
> +}
> 
> You do *not* need to register a separate struct device for each DMA
> channel sub node (at least with regard to the driver model; I don't
> know about the dma subsystem).  If you *want* a struct device, then
> xllsdma_of_init() is free to register one, but it does not need to be
> on the of_platform_bus, and this driver should not require a probe
> step for each DMA channel.

The DMA engine driver (and ll_temac, I imagine) will gain access to this driver via xllsdma_find_device(). 
They should not need a struct device.

[snip]

> >> +#else        /* CONFIG_OF */
> 
> Why else?  It is perfectly valid to have both of_platform and platform
> bus bindings.  That being said, this split will become unnecessary in
> the very near future.  I've eliminated of_platform_bus_type, and
> automatically moved all users of it over to the platform bus (without
> driver changes).

Agreed. It would help to have an idea of the timeline for the
convergence. I haven't been following any OF-related discussions on
LKML; I'll try to pay more attention.

> 
> However, current powerpc and microblaze code makes CONFIG_OF
> manditory.  What condition will compile in the platform bus
> attachment?

At the moment, none in mainline. See my next comment.

> 
> >> +/*---------------------------------------------------------------------------
> >> + * Platform bus attachment
> >> + */
> >> +
> >> +static __devexit int xllsdma_plat_remove(struct platform_device *pdev)
> >> +{
> >> +     xllsdma_cleanup(&pdev->dev);
> >> +     return 0;
> >> +}
> >> +
> >> +static int __devinit xllsdma_plat_probe(struct platform_device *pdev)
> >> +{
> >> +     struct resource *rx_irq, *tx_irq, *mem;
> >> +     int err = 0;
> >> +
> >> +     mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +     if (!mem) {
> >> +             dev_err(&pdev->dev, "invalid address\n");
> >> +             err = -EINVAL;
> >> +             goto fail;
> >> +     }
> >> +
> >> +     /* RX interrupt is optional, and first */
> >> +     rx_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> +
> >> +     /* TX interrupt is optional, and second */
> >> +     tx_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
> >> +
> >
> > If it is impossible to create duplicate phandles in Device Tree,
> > there should be a check here that no device with pdev->id already exists
> > (i.e., it's NOT impossible with platform bus). It might be just as well to
> > put the check in xllsdma_init() since that's not a 'hot' code path.
> 
> Question: microblaze and powerpc both use the device tree.  What is
> the use-case for the non-dts version?

My kernel, for one. During microblaze integration into mainline,
toolchains that supported device tree were not available to common folk,
so I had to hack up my kernel to work around this. In my kernel, OF is a
selectable option. Since then new tools have become available (although
AFAIK none officially from Xilinx - we are still having lots of problems
with toolchains), but my last attempt to switch to device tree failed.
At this point we're too far in the development cycle to justify the
effort involved in a switch.

[snip]

> >> +int __init xllsdma_plat_init(void)
> >> +{
> >> +     int err = platform_driver_register(&xllsdma_plat_driver);
> >> +     if (err) {
> >> +             platform_driver_unregister(&xllsdma_plat_driver);
> >> +             printk(KERN_ERR "registering driver failed: err=%i", err);
> >> +             return err;
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> >> +subsys_initcall(xllsdma_plat_init);
> 
> Again, if driver registration fails, then the driver doesn't need to
> be unregistered.  Same as with the of_platform_bus binding.

Agreed.

> 
> >> +
> >> +void xllsdma_plat_exit(void)
> >> +{
> >> +     platform_driver_unregister(&xllsdma_plat_driver);
> >> +}
> >> +
> >> +static int mpmc_plat_probe(struct platform_device *pdev)
> >> +{
> >> +     return mpmc_init(&pdev->dev);
> >> +}
> >> +
> >> +static int __devexit mpmc_plat_remove(struct platform_device *pdev)
> >> +{
> >> +     mpmc_cleanup(&pdev->dev);
> >> +     return 0;
> >> +}
> >> +
> >> +static struct platform_driver mpmc_plat_driver = {
> >> +     .probe = mpmc_plat_probe,
> >> +     .remove = __devexit_p(mpmc_plat_remove),
> >> +     .driver = {
> >> +             .owner = THIS_MODULE,
> >> +             .name  = "xilinx-mpmc",
> >> +     },
> >> +};
> 
> I'll make the same argument here.  The multiple registrations in this
> driver is weird.  This driver already knows about all of it's dma
> channels, so why depend on the core driver model to probe a driver
> instance for each?

This code depends on the same infrastructure/concept as its OF
countertpart. When those change, so will this.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


