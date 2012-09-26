Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2IZHsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:48:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:20817 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab2IZHsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="197237929"
Message-ID: <1348645727.13371.140.camel@smile>
Subject: Re: [PATCHv1 3/6] dmaengine: dw_dmac: Add PCI part of the driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 26 Sep 2012 10:48:47 +0300
In-Reply-To: <CAOh2x=nX8sDpOPBsxWuTfo45hfvTZDC+U2wmuomyGVRaWgqVcg@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348575190-11761-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=nX8sDpOPBsxWuTfo45hfvTZDC+U2wmuomyGVRaWgqVcg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 09:30 +0530, viresh kumar wrote: 
> On Tue, Sep 25, 2012 at 5:43 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > diff --git a/drivers/dma/dw_dmac_at32.c b/drivers/dma/dw_dmac_at32.c
> > index 7bc7ac4..5c9180e 100644
> > --- a/drivers/dma/dw_dmac_at32.c
> > +++ b/drivers/dma/dw_dmac_at32.c
> > @@ -12,6 +12,7 @@
> >   * it under the terms of the GNU General Public License version 2 as
> >   * published by the Free Software Foundation.
> >   */
> > +
> 
> :(
Noticed and fixed already locally.
Perhaps it will be not needed accordingly to your comment about CLK
framework.

> 
> >  #include <linux/module.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/slab.h>
> > diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw_dmac_pci.c
> > new file mode 100644
> > index 0000000..7490894
> > --- /dev/null
> > +++ b/drivers/dma/dw_dmac_pci.c
> > @@ -0,0 +1,130 @@
> > +/*
> > + * PCI driver for the Synopsys DesignWare DMA Controller
> > + *
> > + * Copyright (C) 2012 Intel Corporation
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/dw_dmac.h>
> > +
> > +#define DW_DRIVER_NAME "dw_dmac_pci"
> > +
> > +#define DRIVER(_is_private, _chan_order, _chan_pri)            \
> > +       ((kernel_ulong_t)&(struct dw_dma_platform_data) {       \
> > +               .is_private = (_is_private),                    \
> > +               .chan_allocation_order = (_chan_order),         \
> > +               .chan_priority = (_chan_pri),                   \
> > +       })
> 
> See if you can align "\" at the end of every line in one column
Ok.

> 
> > +
> > +static int __devinit dw_pci_probe(struct pci_dev *pdev,
> > +                                 const struct pci_device_id *id)
> > +{
> > +       struct platform_device          *pd;
> 
> no need of multiple spaces before *pd.
> 
> > +       struct resource                 r[2];
> > +       struct dw_dma_platform_data     *driver = (void *)id->driver_data;
> > +       static int                      instance;
> > +       int                             ret;
> 
> for all above lines too
Ok for both comments.

> 
> > +
> > +       ret = pci_enable_device(pdev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       pci_set_power_state(pdev, PCI_D0);
> > +       pci_set_master(pdev);
> > +       pci_try_set_mwi(pdev);
> > +
> > +       ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> > +       if (ret)
> > +               goto err0;
> > +
> > +       ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
> > +       if (ret)
> > +               goto err0;
> > +
> > +       pd = platform_device_alloc("dw_dmac", instance);
> > +       if (!pd) {
> > +               dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
> > +               ret = -ENOMEM;
> > +               goto err0;
> > +       }
> > +
> > +       memset(r, 0, sizeof(r));
> > +
> > +       r[0].start      = pci_resource_start(pdev, 0);
> > +       r[0].end        = pci_resource_end(pdev, 0);
> > +       r[0].flags      = IORESOURCE_MEM;
> 
> ditto
> 
> > +
> > +       r[1].start      = pdev->irq;
> > +       r[1].flags      = IORESOURCE_IRQ;
> 
> ditto
Ok.

> 
> > +       ret = platform_device_add_resources(pd, r, ARRAY_SIZE(r));
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "can't add resources to platform device\n");
> > +               goto err1;
> > +       }
> > +
> > +       ret = platform_device_add_data(pd, driver, sizeof(*driver));
> > +       if (ret)
> > +               goto err1;
> > +
> > +       dma_set_coherent_mask(&pd->dev, pdev->dev.coherent_dma_mask);
> > +       pd->dev.dma_mask = pdev->dev.dma_mask;
> > +       pd->dev.dma_parms = pdev->dev.dma_parms;
> > +       pd->dev.parent = &pdev->dev;
> > +
> > +       pci_set_drvdata(pdev, pd);
> > +
> > +       ret = platform_device_add(pd);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "platform_device_add failed\n");
> > +               goto err1;
> > +       }
> > +
> > +       instance++;
> > +       return 0;
> > +
> > +err1:
> > +       pci_set_drvdata(pdev, NULL);
> 
> Is this required?
Seems it's not.

> > +       platform_device_put(pd);
> > +err0:
> > +       pci_disable_device(pdev);
> > +
> > +       return ret;
> > +}
> > +
> > +static void __devexit dw_pci_remove(struct pci_dev *pdev)
> > +{
> > +       struct platform_device *pd = pci_get_drvdata(pdev);
> > +
> > +       platform_device_unregister(pd);
> > +       pci_set_drvdata(pdev, NULL);
> > +       pci_disable_device(pdev);
> > +}
> > +
> > +static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
> > +       { PCI_VDEVICE(INTEL, 0x0827), DRIVER(1, 0, 0) },
> > +       { PCI_VDEVICE(INTEL, 0x0830), DRIVER(1, 0, 0) },
> > +       { PCI_VDEVICE(INTEL, 0x0f06), DRIVER(1, 0, 0) },
> > +       { 0, }
> > +};
> > +MODULE_DEVICE_TABLE(pci, dw_pci_id_table);
> > +
> > +static struct pci_driver dw_pci_driver = {
> > +       .name           = DW_DRIVER_NAME,
> > +       .id_table       = dw_pci_id_table,
> > +       .probe          = dw_pci_probe,
> > +       .remove         = __devexit_p(dw_pci_remove),
> > +};
> > +
> > +module_pci_driver(dw_pci_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("DesignWare DMAC PCI driver");
> > +MODULE_AUTHOR("Heikki Krogerus <heikki.krogerus@linux.intel.com>");
> > +MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
> > --
> > 1.7.10.4
> >

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
