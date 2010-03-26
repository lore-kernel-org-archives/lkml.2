Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0CZWUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:20:10 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:8385 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0CZWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:20:07 -0400
X-Spam-Processed: digidescorp.com, Fri, 26 Mar 2010 17:20:05 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1701787f35=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [microblaze-uclinux] Re: [PATCH 3/4] dmaengine: xlldma
 platform bus driver
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au
In-Reply-To: <fa686aa41003261433x312453dfgca325cae3bbaf91@mail.gmail.com>
References: <1268843188-15292-1-git-send-email-steve@digidescorp.com>
	 <fa686aa41003261433x312453dfgca325cae3bbaf91@mail.gmail.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Fri, 26 Mar 2010 17:20:01 -0500
Message-Id: <1269642001.3001.325.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 15:33 -0600, Grant Likely wrote:
> On Wed, Mar 17, 2010 at 10:26 AM, Steven J. Magnani
> <steve@digidescorp.com> wrote:
> > Platform bus attachment for the Xilinx MPMC Soft Direct Memory
> > Access Controller DMA engine.
> >
> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> > ---
> > diff -uprN a/drivers/dma/xlldma_plat.c b/drivers/dma/xlldma_plat.c
> > --- a/drivers/dma/xlldma_plat.c 1969-12-31 18:00:00.000000000 -0600
> > +++ b/drivers/dma/xlldma_plat.c 2010-03-17 11:11:16.000000000 -0500
> 
> Not really worth putting into a separate file.  Just put this hunk in
> the xlldma.c file to keep a few more symbols out of the global
> namespace.

I can certainly do that, but as someone who's had to add platform bus
attachments to drivers that only have OF attachments, I can say from
experience that the result ends up being rather messy. I thought
(explicitly) decoupling the bus logic from the driver might be an
improvement. Maybe it's not enough of a benefit.

> 
> > @@ -0,0 +1,222 @@
> > +/*
> > + * Xilinx Multi-Port Memory Controller (MPMC) DMA Engine support
> > + *
> > + * Copyright (C) 2010 Digital Design Corporation. All rights reserved.
> > + *
> > + * Author:
> > + *   Steve Magnani <steve@digidescorp.com>, Mar 2010
> > + *
> > + * Description:
> > + *   Platform bus attachment for the Xilinx MPMC Soft Direct Memory
> > + *   Access Controller DMA engine.
> > + *
> > + * This is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/module.h>
> > +
> > +#include "xlldma.h"
> > +
> > +static int __devinit xlldma_plat_chan_probe(struct xlldma_device *xdev)
> > +{
> > +       struct xlldma_chan *chan;
> > +       struct resource *plat_rsrc;
> > +       int err;
> > +       struct platform_device *pdev = to_platform_device(xdev->dev);
> > +       char irq_name[9];
> > +
> > +       plat_rsrc = platform_get_resource(pdev, IORESOURCE_MEM,
> > +                                         xdev->common.chancnt);
> > +       if (!plat_rsrc)
> > +               return -ENXIO;
> > +
> > +       /* alloc channel */
> > +       chan = kzalloc(sizeof(struct xlldma_chan), GFP_KERNEL);
> > +       if (!chan) {
> > +               dev_err(xdev->dev,
> > +                       "No free memory for allocating dma channels!\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       /* get dma channel register base */
> > +       chan->reg_base = NULL;
> 
> Superfluous statement.
Yup.
> 
> > +
> > +       /* map device registers */
> > +       chan->reg_base = ioremap(plat_rsrc->start,
> > +                                plat_rsrc->end - plat_rsrc->start + 1);
> > +       if (chan->reg_base) {
> > +               dev_dbg(xdev->dev, "MEM base: %p\n", chan->reg_base);
> > +       } else {
> > +               dev_err(xdev->dev, "unable to map DMA registers\n");
> > +               err = -ENXIO;
> > +               goto err_no_reg;
> > +       }
> 
> General convention is to do this the other way around.  No else clause required:
> 
> if (!chan->reg_base) {
>       /* bail out here */
> }
> dev_dbg(...)
Agreed, it's simpler.

> 
> 
> > +
> > +       chan->xdev = xdev;
> > +
> > +       chan->id = xdev->common.chancnt;
> > +       if (chan->id >= XLLDMA_MAX_CHANS_PER_DEVICE) {
> > +               dev_err(xdev->dev, "There is no %d channel!\n", chan->id);
> > +               err = -EINVAL;
> > +               goto err_no_chan;
> > +       }
> > +       xdev->chan[chan->id] = chan;
> > +       tasklet_init(&chan->tasklet, xlldma_cleanup_tasklet,
> > +                    (unsigned long)chan);
> > +
> > +       spin_lock_init(&chan->desc_lock);
> > +       INIT_LIST_HEAD(&chan->desc_queue);
> > +       INIT_LIST_HEAD(&chan->pending_free);
> > +
> > +       chan->common.device = &xdev->common;
> > +
> > +       /* Add the channel to DMA device channel list */
> > +       list_add_tail(&chan->common.device_node, &xdev->common.channels);
> > +       xdev->common.chancnt++;
> 
> Don't you need a spinlock protecting the list access?

I'm not sure where the concurrency would come from. At this point we're
enumerating, so nothing is externally visible yet. And after we're
registered, dmaengine never modifies the list.

> 
> > +
> > +       /* RX interrupt is required */
> > +       sprintf(irq_name, "chan%d-rx", chan->id);
> 
> Be defensive.  Make irq_name at least 20 bytes long in case chan->id
> somehow becomes huge.
OK

> 
> > +       plat_rsrc = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> > +                                                irq_name);
> > +       if (!plat_rsrc) {
> > +               dev_err(xdev->dev, "DMA channel %d - missing %s IRQ\n",
> > +                       chan->id, irq_name);
> > +               err = -ENXIO;
> > +               goto err_no_irq;
> > +       }
> > +
> > +       chan->rx_irq = plat_rsrc->start;
> > +       BUG_ON(plat_rsrc->end != plat_rsrc->start);
> > +
> > +       err = request_irq(chan->rx_irq, &xlldma_chan_rx_interrupt,
> > +                         IRQF_SHARED, "xlldma-rx", chan);
> > +       if (err) {
> > +               dev_err(xdev->dev, "request_irq error on %s, return %d\n",
> > +                       irq_name, err);
> > +               err = -ENXIO;
> > +               goto err_no_irq;
> > +       }
> > +
> > +       /* TX interrupt is optional - only needed for DMA_INTERRUPT */
> > +       irq_name[6] = 't';
> 
> And if irq # is in the double digits?  This is clever, but unclear and
> potentially risky.  Just do another sprintf()
OK
> 
> > +       plat_rsrc = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> > +                                                irq_name);
> > +       if (plat_rsrc) {
> > +               chan->tx_irq = plat_rsrc->start;
> > +               BUG_ON(plat_rsrc->end != plat_rsrc->start);
> > +       } else {
> > +               chan->tx_irq = NO_IRQ;
> > +       }
> 
> put chan->tx_irq = NO_IRQ before the if(), and you can drop the else
> statement (a bit simpler).
OK
> 
> > +
> > +       if (chan->tx_irq != NO_IRQ) {
> > +               err = request_irq(chan->tx_irq, &xlldma_chan_tx_interrupt,
> > +                                 IRQF_SHARED, "xlldma-tx", chan);
> > +               if (err) {
> > +                       dev_err(xdev->dev,
> > +                               "request_irq error on %s, return %d\n",
> > +                               irq_name, err);
> > +                       goto err_rx_irq;
> > +               }
> > +       }
> > +
> > +       dev_info(xdev->dev, "#%d, tx irq %d, rx irq %d\n", chan->id,
> > +                chan->tx_irq, chan->rx_irq);
> > +
> > +       return 0;
> > +err_rx_irq:
> > +       free_irq(chan->rx_irq, chan);
> > +err_no_irq:
> > +       list_del(&chan->common.device_node);
> > +err_no_chan:
> > +       iounmap(chan->reg_base);
> > +err_no_reg:
> > +       kfree(chan);
> > +       return err;
> > +}
> > +
> > +static int __devinit xlldma_plat_probe(struct platform_device *pdev)
> > +{
> > +       struct xlldma_device *xdev;
> > +       int i, rc;
> > +
> > +       dev_info(&pdev->dev, "Xilinx DMA engine...\n");
> > +
> > +       xdev = kzalloc(sizeof(struct xlldma_device), GFP_KERNEL);
> > +       if (!xdev) {
> > +               dev_err(&pdev->dev, "Not enough memory for 'priv'\n");
> > +               rc = -ENOMEM;
> > +               goto fail_alloc;
> > +       }
> > +       xdev->dev = &pdev->dev;
> > +       INIT_LIST_HEAD(&xdev->common.channels);
> > +
> > +       xdev->common.dev = &pdev->dev;
> > +       platform_set_drvdata(pdev, xdev);
> > +
> > +       do {
> > +               rc = xlldma_plat_chan_probe(xdev);
> > +       } while (rc == 0);
> > +
> > +       if (xdev->common.chancnt == 0)
> > +               goto fail_nochan;
> > +
> > +       rc = xlldma_device_setup(xdev->dev);
> > +       if (rc == 0)
> > +               return 0;
> > +
> > +/* fail: */
> > +       for (i = 0; i < XLLDMA_MAX_CHANS_PER_DEVICE; i++) {
> > +               if (xdev->chan[i])
> > +                       xlldma_chan_remove(xdev->chan[i]);
> > +       }
> > +fail_nochan:
> > +       platform_set_drvdata(pdev, NULL);
> > +       kfree(xdev);
> > +
> > +fail_alloc:
> > +       return rc;
> > +}
> > +
> > +static int __devexit xlldma_plat_remove(struct platform_device *pdev)
> > +{
> > +       return xlldma_device_teardown(&pdev->dev);
> > +}
> > +
> > +static struct platform_driver xlldma_driver = {
> > +       .probe  = xlldma_plat_probe,
> > +       .remove = __devexit_p(xlldma_plat_remove),
> > +       .driver = {
> > +               .owner = THIS_MODULE,
> > +               .name  = "xlldma",
> > +       },
> > +};
> > +
> > +static int __init xlldma_plat_init(void)
> > +{
> > +       int ret;
> > +
> > +       pr_info("Xilinx LocalLink DMA driver\n");
> > +
> > +       ret = platform_driver_register(&xlldma_driver);
> > +       if (ret)
> > +               pr_err("xlldma: failed to register platform driver\n");
> > +
> > +       return ret;
> > +}
> 
> Don't bother with all this.  sysfs will tell you whether or not the
> driver got registered.  Do this instead:
> 
> +static int __init xlldma_plat_init(void)
> +{
> +       return platform_driver_register(&xlldma_driver);
> +}
> 
OK
> 
> > +
> > +static void __exit xlldma_plat_exit(void)
> > +{
> > +       platform_driver_unregister(&xlldma_driver);
> > +}
> > +
> > +module_init(xlldma_plat_init);
> 
> Put the module_init directly after the xlldma_plat_init() function definition.
OK

> 
> > +module_exit(xlldma_plat_exit);
> > +
> > +MODULE_AUTHOR("Digital Design Corporation");
> > +MODULE_DESCRIPTION("Xilinx LocalLink DMA Platform driver");
> > +MODULE_LICENSE("GPL");

Thanks for taking the time to review this.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



