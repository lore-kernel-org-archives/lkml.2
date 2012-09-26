Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2IZOd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:33:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55185 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2IZOdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <1348663237-3237-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 20:03:24 +0530
X-Google-Sender-Auth: Up8agZve9g_zwJhXbz2SJbr5cZc
Message-ID: <CAOh2x=nnUxJ4bvro_Rc95jRk7SR_yzxwZhNXeL4w5xDzsDj3nQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot earlier, please keep spear-devel in cc... They will be going to
use dw_dmac driver :)

On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw_dmac_pci.c
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/dw_dmac.h>
> +
> +#define DRIVER(_is_private, _chan_order, _chan_pri)            \
> +       ((kernel_ulong_t)&(struct dw_dma_platform_data) {       \
> +               .is_private = (_is_private),                    \
> +               .chan_allocation_order = (_chan_order),         \
> +               .chan_priority = (_chan_pri),                   \

I believe you don't need these braces around input variables on right side
of "=". Even if there is something complex passed.

Did you try to align "\"? Sorry can't see it in gmail :(

> +       })
> +
> +static int __devinit dw_pci_probe(struct pci_dev *pdev,
> +                                 const struct pci_device_id *id)
> +{
> +       struct platform_device *pd;
> +       struct resource r[2];
> +       struct dw_dma_platform_data *driver = (void *)id->driver_data;
> +       static int instance;
> +       int ret;
> +
> +       ret = pci_enable_device(pdev);
> +       if (ret)
> +               return ret;
> +
> +       pci_set_power_state(pdev, PCI_D0);
> +       pci_set_master(pdev);
> +       pci_try_set_mwi(pdev);
> +
> +       ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +       if (ret)
> +               goto err0;
> +
> +       ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
> +       if (ret)
> +               goto err0;
> +
> +       pd = platform_device_alloc("dw_dmac", instance);
> +       if (!pd) {
> +               dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
> +               ret = -ENOMEM;
> +               goto err0;
> +       }

Is this the correct approach? I doubt... We are creating a platform
device from a
pci driver... Don't know if it can lead to some issues within kernel.

Lets call the specialist for his comments  :)
@Arnd: Can you please help us here?

> +       memset(r, 0, sizeof(r));
> +
> +       r[0].start = pci_resource_start(pdev, 0);
> +       r[0].end = pci_resource_end(pdev, 0);
> +       r[0].flags = IORESOURCE_MEM;
> +
> +       r[1].start = pdev->irq;
> +       r[1].flags = IORESOURCE_IRQ;
> +
> +       ret = platform_device_add_resources(pd, r, ARRAY_SIZE(r));
> +       if (ret) {
> +               dev_err(&pdev->dev, "can't add resources to platform device\n");
> +               goto err1;
> +       }
> +
> +       ret = platform_device_add_data(pd, driver, sizeof(*driver));
> +       if (ret)
> +               goto err1;
> +
> +       dma_set_coherent_mask(&pd->dev, pdev->dev.coherent_dma_mask);
> +       pd->dev.dma_mask = pdev->dev.dma_mask;
> +       pd->dev.dma_parms = pdev->dev.dma_parms;
> +       pd->dev.parent = &pdev->dev;
> +
> +       pci_set_drvdata(pdev, pd);
> +
> +       ret = platform_device_add(pd);
> +       if (ret) {
> +               dev_err(&pdev->dev, "platform_device_add failed\n");
> +               goto err1;
> +       }
> +
> +       instance++;
> +       return 0;
> +
> +err1:
> +       platform_device_put(pd);
> +err0:
> +       pci_disable_device(pdev);
> +
> +       return ret;
> +}
> +
> +static void __devexit dw_pci_remove(struct pci_dev *pdev)
> +{
> +       struct platform_device *pd = pci_get_drvdata(pdev);
> +
> +       platform_device_unregister(pd);
> +       pci_set_drvdata(pdev, NULL);
> +       pci_disable_device(pdev);
> +}
> +
> +static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
> +       { PCI_VDEVICE(INTEL, 0x0827), DRIVER(1, 0, 0) },
> +       { PCI_VDEVICE(INTEL, 0x0830), DRIVER(1, 0, 0) },
> +       { PCI_VDEVICE(INTEL, 0x0f06), DRIVER(1, 0, 0) },
> +       { 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, dw_pci_id_table);
> +
> +static struct pci_driver dw_pci_driver = {
> +       .name           = "dw_dmac_pci",
> +       .id_table       = dw_pci_id_table,
> +       .probe          = dw_pci_probe,
> +       .remove         = __devexit_p(dw_pci_remove),
> +};
> +
> +module_pci_driver(dw_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("DesignWare DMAC PCI driver");
> +MODULE_AUTHOR("Heikki Krogerus <heikki.krogerus@linux.intel.com>");
> +MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
> --
> 1.7.10.4
>
