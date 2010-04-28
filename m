Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0D1V67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:58:59 -0400
Received: from forward1.mail.yandex.net ([77.88.46.6]:58102 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0D1V65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:58:57 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [microblaze-uclinux] [PATCHv2] [RFC] Xilinx MPMC SDMA subsystem
Date: Thu, 29 Apr 2010 01:58:33 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
Cc: steve@digidescorp.com, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@lists.ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201004280206.38220.temerkhanov@yandex.ru> <1272421789.2877.21.camel@iscandar.digidescorp.com> <n2vfa686aa41004272213wceeef998tadc483ec1de7b792@mail.gmail.com>
In-Reply-To: <n2vfa686aa41004272213wceeef998tadc483ec1de7b792@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290158.33574.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1272491934
X-Yandex-Spam: 1
X-Yandex-Front: smtp3.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010 09:13:06 you wrote:
> Hi Sergey and Steven,
> 
> On Tue, Apr 27, 2010 at 8:29 PM, Steven J. Magnani
> 
> <steve@digidescorp.com> wrote:
> > On Wed, 2010-04-28 at 02:06 +0400, Sergey Temerkhanov wrote:
> >> This is the 2nd version of Xilinx MPMC LocalLink SDMA subsystem
> >>
> >> Changelog v2:
> >> * Changed the functions and struct definition prefix from sdma_ to
> >> xllsdma_ * Platform bus bindings and various changes by Steven J.
> >> Magnani. * Moved source files from arch/powerpc/sysdev to global
> >> locations and added CONFIG_XLLSDMA option.
> >>
> >> Regards, Sergey Temerkhanov,
> >> Cifronic ZAO
> >>
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

I've changed it to XILINX_SDMA in the current version.

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
> > Since the xllsdma driver provides services to other drivers - not to
> > userland - I think this would be better as a "silent" option, selected
> > automatically when something like ll_temac or the forthcoming Xilinx DMA
> > engine is selected. If we do it that way, note that XLLSDMA is
> > independent of DMA_ENGINE so drivers/Makefile will need to be patched so
> > that the dma subdirectory is always "y".
> 
> Agreed.  However, looking at this code, I don't see anything that
> actually uses DMA_ENGINE here.  Am I missing something?

It's because the appropriate line in drivers/Makefile is
obj-$(CONFIG_DMA_ENGINE)	 += dma/

instead of
obj-$(CONFIG_DMADEVICES) += dma/

> 
> >> diff -r baced9e29ab5 drivers/dma/Makefile
> >> --- a/drivers/dma/Makefile    Tue Apr 27 20:48:50 2010 +0400
> >> +++ b/drivers/dma/Makefile    Wed Apr 28 02:00:51 2010 +0400
> >> @@ -10,3 +10,4 @@
> >>  obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
> >>  obj-$(CONFIG_MX3_IPU) += ipu/
> >>  obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
> >> +obj-$(CONFIG_XLLSDMA) += xllsdma.o
> >> diff -r baced9e29ab5 drivers/dma/xllsdma.c
> >> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> >> +++ b/drivers/dma/xllsdma.c   Wed Apr 28 02:00:51 2010 +0400
> >> @@ -0,0 +1,887 @@
> >> +/*
> >> + * SDMA subsystem support for Xilinx MPMC.
> >> + *
> >> + * Author: Sergey Temerkhanov
> >> + * Platform Bus by Steven J. Magnani
> >> + *
> >> + * Copyright (c) 2008-2010 Cifronic ZAO
> >> + *
> >> + * This program is free software; you can redistribute  it and/or
> >> modify it + * under  the terms of  the GNU General  Public License as
> >> published by the + * Free Software Foundation; either version 2 of the
> >> License, or (at your + * option) any later version.
> >> + *
> >> + */
> >> +
> >> +#include <linux/delay.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/init.h>
> >> +#include <linux/module.h>
> >> +#include <linux/init.h>
> >> +#include <linux/errno.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/mutex.h>
> >> +#include <linux/wait.h>
> >> +#include <linux/list.h>
> >> +#include <linux/io.h>
> >> +#include <linux/xllsdma.h>
> >> +
> >> +#include <linux/of_device.h>
> >> +#include <linux/of_platform.h>
> >> +
> >> +#define DRV_VERSION "0.1.0"
> 
> Irrelevant, can be dropped
> 
> >> +#define DRV_NAME "sdma"
> 
> Used only once, drop.
> 
> >> +
> >> +MODULE_AUTHOR("Sergey Temerkhanov <temerkhanov@cifronik.ru>");
> >> +MODULE_DESCRIPTION("Xilinx SDMA driver");
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_VERSION(DRV_VERSION);
> >> +
> >> +LIST_HEAD(mpmc_devs);
> >> +DEFINE_MUTEX(mpmc_devs_lock);
> >> +
> >> +void xllsdma_tx_irq_enable(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 tx_cr;
> >> +     unsigned long flags;
> >> +
> >> +     BUG_ON(sdma->tx_irq == NO_IRQ);
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
> >> +     xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr | XLLSDMA_CR_IRQ_EN);
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> 
> This pattern is used a lot.  Might be worth while to implement
> xllsdma_tx_* variants of setbits32, clrbits32 and clrsetbits32.
> 
> Also, there are a lot of these little functions; really trivial and
> small.  Would it be better to have them as static inlines in the
> header file instead of exported globals?

Well, I can do this but it will require moving of register definitions to 
xllsdma.h

> 
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_tx_irq_enable);
> >> +
> >> +void xllsdma_rx_irq_enable(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 rx_cr;
> >> +     unsigned long flags;
> >> +
> >> +     BUG_ON(sdma->rx_irq == NO_IRQ);
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
> >> +     xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr | XLLSDMA_CR_IRQ_EN);
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_rx_irq_enable);
> >> +
> >> +void xllsdma_tx_irq_disable(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 tx_cr;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
> >> +     xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr & ~XLLSDMA_CR_IRQ_EN);
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_tx_irq_disable);
> >> +
> >> +void xllsdma_rx_irq_disable(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 rx_cr;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
> >> +     xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr & ~XLLSDMA_CR_IRQ_EN);
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_rx_irq_disable);
> >> +
> >> +void xllsdma_tx_irq_ack(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 irq_stat;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     irq_stat = xllsdma_tx_in32(sdma, XLLSDMA_IRQ);
> >> +     xllsdma_tx_out32(sdma, XLLSDMA_IRQ, irq_stat &
> >> XLLSDMA_IRQ_ALL_DONE); +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_tx_irq_ack);
> >> +
> >> +void xllsdma_rx_irq_ack(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 irq_stat;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     irq_stat = xllsdma_rx_in32(sdma, XLLSDMA_IRQ);
> >> +     xllsdma_rx_out32(sdma, XLLSDMA_IRQ, irq_stat &
> >> XLLSDMA_IRQ_ALL_DONE); +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_rx_irq_ack);
> >> +
> >> +void xllsdma_pause(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 dmacr;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     dmacr = xllsdma_read_cr(sdma);
> >> +     dmacr |= XLLSDMA_DMACR_TX_PAUSE | XLLSDMA_DMACR_RX_PAUSE;
> >> +     xllsdma_write_cr(sdma, dmacr);
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_pause);
> >> +
> >> +void xllsdma_resume(struct xllsdma_device *sdma)
> >> +{
> >> +     u32 dmacr;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +     dmacr = xllsdma_read_cr(sdma);
> >> +     dmacr &= ~(XLLSDMA_DMACR_TX_PAUSE | XLLSDMA_DMACR_RX_PAUSE);
> >> +     xllsdma_write_cr(sdma, dmacr);
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_resume);
> >> +
> >> +int xllsdma_set_coalesce(struct xllsdma_device *sdma, struct
> >> xllsdma_coalesce *coal) +{
> >> +     u32 tx_cr, rx_cr;
> >> +     unsigned long flags;
> >> +
> >> +     if (coal->tx_timeout > 255 ||
> >> +         coal->rx_timeout > 255 ||
> >> +         coal->tx_threshold > 255 ||
> >> +         coal->rx_threshold > 255)
> >> +             return -EINVAL;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +
> >> +     if (sdma->rx_irq != NO_IRQ) {
> >> +             rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
> >> +
> >> +             if (coal->rx_timeout == 0) {
> >> +                     coal->rx_timeout = 1;
> >> +                     rx_cr &= ~XLLSDMA_CR_IRQ_TIMEOUT;
> >> +             } else {
> >> +                     rx_cr |= XLLSDMA_CR_IRQ_TIMEOUT;
> >> +             }
> >> +
> >> +             rx_cr &= ~(XLLSDMA_CR_IRQ_THRESHOLD_MSK |
> >> XLLSDMA_CR_IRQ_TIMEOUT_SH); +             rx_cr |= (coal->rx_threshold
> >> << XLLSDMA_CR_IRQ_THRESHOLD_SH) +                      &
> >> XLLSDMA_CR_IRQ_THRESHOLD_MSK;
> >> +             rx_cr |= (coal->rx_timeout << XLLSDMA_CR_IRQ_TIMEOUT_SH)
> >> +                      & XLLSDMA_CR_IRQ_TIMEOUT_MSK;
> >> +             rx_cr |= XLLSDMA_CR_LD_IRQ_CNT;
> >> +
> >> +             xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr);
> >> +     }
> >> +
> >> +     if (sdma->tx_irq != NO_IRQ) {
> >> +             tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
> >> +
> >> +             if (coal->tx_timeout == 0) {
> >> +                     coal->tx_timeout = 1;
> >> +                     tx_cr &= ~XLLSDMA_CR_IRQ_TIMEOUT;
> >> +             } else {
> >> +                     tx_cr |= XLLSDMA_CR_IRQ_TIMEOUT;
> >> +             }
> >> +
> >> +             tx_cr &= ~(XLLSDMA_CR_IRQ_THRESHOLD_MSK |
> >> XLLSDMA_CR_IRQ_TIMEOUT_SH); +             tx_cr |= (coal->tx_threshold
> >> << XLLSDMA_CR_IRQ_THRESHOLD_SH) +                      &
> >> XLLSDMA_CR_IRQ_THRESHOLD_MSK;
> >> +             tx_cr |= (coal->tx_timeout << XLLSDMA_CR_IRQ_TIMEOUT_SH)
> >> +                      & XLLSDMA_CR_IRQ_TIMEOUT_MSK;
> >> +             tx_cr |= XLLSDMA_CR_LD_IRQ_CNT;
> >> +
> >> +             xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr);
> >> +     }
> >> +
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +
> >> +     return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_set_coalesce);
> >> +
> >> +int xllsdma_get_coalesce(struct xllsdma_device *sdma, struct
> >> xllsdma_coalesce *coal) +{
> >> +     u32 tx_cr, rx_cr;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&sdma->lock, flags);
> >> +
> >> +     tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
> >> +     rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
> >> +
> >> +     coal->tx_threshold = (tx_cr & XLLSDMA_CR_IRQ_THRESHOLD_MSK)
> >> +                          >> XLLSDMA_CR_IRQ_THRESHOLD_SH;
> >> +     coal->tx_timeout = (tx_cr & XLLSDMA_CR_IRQ_TIMEOUT_MSK)
> >> +                        >> XLLSDMA_CR_IRQ_TIMEOUT_SH;
> >> +
> >> +     coal->rx_threshold = (rx_cr & XLLSDMA_CR_IRQ_THRESHOLD_MSK)
> >> +                          >> XLLSDMA_CR_IRQ_THRESHOLD_SH;
> >> +     coal->rx_timeout = (rx_cr & XLLSDMA_CR_IRQ_TIMEOUT_MSK)
> >> +                          >> XLLSDMA_CR_IRQ_TIMEOUT_SH;
> >> +
> >> +     if (!(tx_cr & XLLSDMA_CR_IRQ_TIMEOUT))
> >> +             coal->tx_timeout = 0;
> >> +
> >> +     if (!(rx_cr & XLLSDMA_CR_IRQ_TIMEOUT))
> >> +             coal->rx_timeout = 0;
> >> +
> >> +     spin_unlock_irqrestore(&sdma->lock, flags);
> >> +
> >> +     return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_get_coalesce);
> >> +
> >> +int xllsdma_tx_submit(struct xllsdma_device *sdma, dma_addr_t desc)
> >> +{
> >> +     xllsdma_tx_out32(sdma, XLLSDMA_TDESCR, desc);
> >> +     return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_tx_submit);
> >
> > Invariant return value can be dropped.
> 
> Also are more tiny functions that could be considered for static inlines.
> 
> >> +int xllsdma_rx_submit(struct xllsdma_device *sdma, dma_addr_t desc)
> >> +{
> >> +     xllsdma_rx_out32(sdma, XLLSDMA_TDESCR, desc);
> >> +     return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_rx_submit);
> >
> > Invariant return value can be dropped.
> >
> >> +
> >> +void xllsdma_tx_init(struct xllsdma_device *sdma, dma_addr_t desc)
> >> +{
> >> +     xllsdma_tx_out32(sdma, XLLSDMA_CDESCR, desc);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_tx_init);
> >> +
> >> +void xllsdma_rx_init(struct xllsdma_device *sdma, dma_addr_t desc)
> >> +{
> >> +     xllsdma_rx_out32(sdma, XLLSDMA_CDESCR, desc);
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_rx_init);
> >> +
> >> +struct xllsdma_device *xllsdma_find_device(int phandle)
> >> +{
> >> +     struct mpmc_device *mpmc;
> >> +     struct xllsdma_device *sdma = NULL;
> >> +     int found = 0;
> >> +     mutex_lock(&mpmc_devs_lock);
> >> +     list_for_each_entry(mpmc, &mpmc_devs, item) {
> >> +             mutex_lock(&mpmc->devs_lock);
> >> +             list_for_each_entry(sdma, &mpmc->xllsdma_devs, item) {
> >> +                     if (sdma->phandle == phandle) {
> >> +                             found = 1;
> >> +                             break;
> >> +                     }
> >> +             }
> >> +             mutex_unlock(&mpmc->devs_lock);
> >> +             if (found)
> >> +                     break;
> >> +             else
> >> +                     sdma = NULL;
> >> +     }
> >> +     mutex_unlock(&mpmc_devs_lock);
> 
> Why is the lock getting dropped on each iteration of the loop?  It
> doesn't look necessary to me at all.

There can be more than 1 MPMC and the outer loops iterates over MPMSs and the 
inner one iterates over SDMA LocalLinks belonging to the appropriate MPMC 
(SDMA channels only have access to memory connected to their MPMC).

> 
> >> +     return sdma;
> >> +}
> >> +EXPORT_SYMBOL_GPL(xllsdma_find_device);
> >
> > I'm still concerned that there is no concept of "allocating" or
> > "reserving" a channel. This seems to invite accidental concurrent use of
> > a channel, if not in the field, then during development.
> 
> In the device tree use-case I doubt it will be a practical problem.
> To get multiple users would require multiple nodes to reference the
> same dma device node.
> 
> However, I've got concerns about the device model used here.... need
> to read the rest of this driver first to figure out what is bothering
> me....
> 
> >> +static void xllsdma_dev_register(struct mpmc_device *mpmc,
> >> +                           struct xllsdma_device *sdma)
> >> +{
> >> +     mutex_lock(&mpmc->devs_lock);
> >> +     list_add(&sdma->item, &mpmc->xllsdma_devs);
> >> +     mutex_unlock(&mpmc->devs_lock);
> >> +}
> 
> This driver could use some documentation on what the data model is
> here.  Is it that the system can have one or more mpmc_devices, and
> each mpmc device can contain one or more xllsdma_device?

Yes, it is.

> 
> How will the ll_temac driver plug into this model?
> 

Well, practically I've never seen a working configuration with more than 1 
MPMC (I think, it would need some pseudo-NUMA as well but with a hard binding 
of physical address ranges to SDMA devices). 
However, I can drop the multiple MPMC support.

> >> +
> >> +static void xllsdma_dev_unregister(struct xllsdma_device *sdma)
> >> +{
> >> +     struct mpmc_device *mpmc = sdma->parent;
> >> +
> >> +     mutex_lock(&mpmc->devs_lock);
> >> +     list_del(&sdma->item);
> >> +     mutex_unlock(&mpmc->devs_lock);
> >> +}
> >> +
> >> +static void xllsdma_cleanup(struct device *dev)
> >> +{
> >> +     struct xllsdma_device *sdma = dev_get_drvdata(dev);
> >> +
> >> +     if (sdma->tx_irq)
> >> +             free_irq(sdma->tx_irq, sdma);
> >> +
> >> +     if (sdma->rx_irq)
> >> +             free_irq(sdma->rx_irq, sdma);
> >> +
> >> +     if (sdma->memregion.start)
> >> +             release_mem_region(sdma->memregion.start,
> >> +                     sdma->memregion.end - sdma->memregion.start + 1);
> >> +
> >> +     if (sdma->ioaddr)
> >> +             iounmap(sdma->ioaddr);
> >> +
> >> +     xllsdma_dev_unregister(sdma);
> >> +     kfree(sdma);
> >> +     dev_set_drvdata(dev, NULL);
> >> +}
> >> +
> >> +static void mpmc_dev_register(struct mpmc_device *mpmc)
> >> +{
> >> +     mutex_lock(&mpmc_devs_lock);
> >> +     list_add_tail(&mpmc->item, &mpmc_devs);
> >> +     mutex_unlock(&mpmc_devs_lock);
> >> +}
> >> +
> >> +static void mpmc_dev_unregister(struct mpmc_device *mpmc)
> >> +{
> >> +     mutex_lock(&mpmc_devs_lock);
> >> +     list_del(&mpmc->item);
> >> +     mutex_unlock(&mpmc_devs_lock);
> >> +}
> >> +
> >> +static void mpmc_cleanup(struct device *dev)
> >> +{
> >> +     struct mpmc_device *mpmc = dev_get_drvdata(dev);
> >> +
> >> +     if (mpmc->registered)
> >> +             mpmc_dev_unregister(mpmc);
> 
> Under what condition would the mpmc not be registered when this
> function is called?  I don't see any code path where this would be the
> case, or any other users of the .registered data member.

It was intended for error handling. I'll look into that.

> 
> >> +
> >> +     kfree(mpmc);
> >> +     dev_set_drvdata(dev, NULL);
> >> +}
> >> +
> >> +static int __devinit xllsdma_init(struct device *dev, struct resource
> >> *rx_irq, +                            struct resource *tx_irq, struct
> >> resource *mem, +                            int phandle)
> >> +{
> >> +     struct xllsdma_device *sdma;
> >> +     struct mpmc_device *mpmc;
> >> +
> >> +     resource_size_t region_size;
> >> +     int res;
> >> +
> >> +     mpmc = dev_get_drvdata(dev->parent);
> >> +
> >> +     sdma = kzalloc(sizeof(struct xllsdma_device), GFP_KERNEL);
> >> +     if (!sdma) {
> >> +             dev_err(dev, "Cannot allocate SDMA device\n");
> >> +             return -ENOMEM;
> >> +     }
> >> +     dev_set_drvdata(dev, sdma);
> >> +     sdma->dev = dev;
> >> +
> >> +     spin_lock_init(&sdma->lock);
> >> +     INIT_LIST_HEAD(&sdma->clients);
> >> +     mutex_init(&sdma->clients_lock);
> >> +     sdma->parent = mpmc;
> >> +     sdma->phandle = phandle;
> >> +
> >> +     region_size = mem->end - mem->start + 1;
> >> +     if (!request_mem_region(mem->start, region_size, DRV_NAME)) {
> >> +             dev_err(dev, "I/O memory region at %p is busy\n",
> >> +                     (void *)mem->start);
> >> +             return -EBUSY;
> 
> Error paths need to unwind allocations and setups.  ie. freeing
> memory, releasing irqs, etc.
> 
> >> +     }
> >> +     sdma->memregion = *mem;
> >> +
> >> +     sdma->ioaddr = ioremap(mem->start, region_size);
> >> +     if (!sdma->ioaddr) {
> >> +             dev_err(dev, "Cannot ioremap() I/O memory %p\n",
> >> +                     (void *)mem->start);
> >> +             return -ENOMEM;
> >> +     }
> >> +
> >> +     xllsdma_reset(sdma);
> >> +
> >> +     sdma->rx_irq = NO_IRQ;
> >> +     if (rx_irq) {
> >> +             res = request_irq(rx_irq->start, xllsdma_rx_intr,
> >> +                             IRQF_SHARED, "SDMA RX", sdma);
> >> +             if (res) {
> >> +                     dev_err(dev, "Could not allocate RX interrupt
> >> %d.\n", +                             rx_irq->start);
> >> +                     return res;
> >> +             }
> >> +             sdma->rx_irq = rx_irq->start;
> >> +     }
> >> +
> >> +     sdma->tx_irq = NO_IRQ;
> >> +     if (tx_irq) {
> >> +             res = request_irq(tx_irq->start, xllsdma_tx_intr,
> >> +                             IRQF_SHARED, "SDMA TX", sdma);
> >> +             if (res) {
> >> +                     dev_err(dev, "Could not allocate TX interrupt
> >> %d.\n", +                             tx_irq->start);
> >> +                     return res;
> >> +             }
> >> +             sdma->tx_irq = tx_irq->start;
> >> +     }
> >> +
> >> +     sdma->rx_ack = 1;
> >> +     sdma->tx_ack = 1;
> >> +     xllsdma_dev_register(mpmc, sdma);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static int __devinit mpmc_init(struct device *dev)
> >> +{
> >> +     struct mpmc_device *mpmc;
> >> +
> >> +     mpmc = kzalloc(sizeof(struct mpmc_device), GFP_KERNEL);
> >> +
> >> +     if (!mpmc) {
> >> +             dev_err(dev, "Cannot allocate MPMC device\n");
> >> +             return -ENOMEM;
> >> +     }
> >> +
> >> +     dev_set_drvdata(dev, mpmc);
> >> +
> >> +     INIT_LIST_HEAD(&mpmc->xllsdma_devs);
> >> +     mutex_init(&mpmc->devs_lock);
> >> +
> >> +     mpmc_dev_register(mpmc);
> >> +     mpmc->registered = 1;
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +#ifdef CONFIG_OF
> >> +static int xllsdma_of_remove(struct of_device *op)
> 
> +static int __devexit xllsdma_of_remove(struct of_device *op)
> 
> >> +{
> >> +     xllsdma_cleanup(&op->dev);
> >> +     return 0;
> >> +}
> >> +
> >> +/* Match table for of_platform binding */
> >> +static struct of_device_id xllsdma_of_match[] = {
> >> +     { .compatible = "xlnx,ll-dma-1.00.a" },
> >> +     {},
> >> +};
> >> +
> >> +static int __devinit xllsdma_of_probe(struct of_device *op,
> >> +                                const struct of_device_id *match)
> >> +{
> >> +     const int *prop;
> >> +     int phandle;
> >> +     struct resource rx_irq, tx_irq, mem;
> >> +     struct resource *tx_irq_res = NULL;
> >> +     struct resource *rx_irq_res = NULL;
> >> +     int res;
> >> +
> >> +     res = of_address_to_resource(op->node, 0, &mem);
> >> +     if (res) {
> >> +             dev_err(&op->dev, "invalid address\n");
> >> +             return res;
> >> +     }
> >> +
> >> +     /* IRQ */
> >> +     res = of_irq_to_resource(op->node, 0, &rx_irq);
> >> +     if (res != NO_IRQ)
> >> +             rx_irq_res = &rx_irq;
> >> +
> >> +     res = of_irq_to_resource(op->node, 1, &tx_irq);
> >> +     if (res != NO_IRQ)
> >> +             tx_irq_res = &tx_irq;
> >> +
> >> +     prop = of_get_property(op->node, "linux,phandle", NULL);
> >> +     phandle = (prop) ? *prop : -1;
> 
> Don't use phandles here.  Just store the node pointer directly.  When
> looking up a phandle, first convert it to a node pointer, and then use
> the node pointer to search.
> 
> >> +
> >> +     res = xllsdma_init(&op->dev, rx_irq_res, tx_irq_res, &mem,
> >> phandle); +     if (res)
> >> +             xllsdma_of_remove(op);
> 
> This looks odd.  If init fails, there is nothing in this function that
> needs to be deallocated or unwound.  You can simply do:
> 
> +return xllsdma_init(&op->dev, rx_irq_res, tx_irq_res, &mem, phandle);
> 

xllsdma_init() tries to allocate some resources etc. xllsdma_of_remove() calls 
xllsdma_cleanup() which cleans the things up depending on what had been really 
done.

> >> +
> >> +     return res;
> >> +}
> >> +
> >> +static struct of_platform_driver xllsdma_of_driver = {
> >> +     .name           = "xilinx-sdma",
> >> +     .match_table    = xllsdma_of_match,
> >> +     .probe          = xllsdma_of_probe,
> >> +     .remove         = xllsdma_of_remove,
> >> +};
> 
> Should be:
> +static struct of_platform_driver xllsdma_of_driver = {
> +     .driver = {
> +             .name = "xilinx-sdma",
> +             .owner = THIS_MODULE,
> +     }
> +     .match_table    = xllsdma_of_match,
> +     .probe          = xllsdma_of_probe,
> +     .remove         = __devexit_p(xllsdma_of_remove),
> +};
> 

This code is rather aged, so I'll update this.

> >> +
> >> +int __init xllsdma_of_init(void)
> >> +{
> >> +     int ret;
> >> +
> >> +     ret = of_register_platform_driver(&xllsdma_of_driver);
> >> +     if (ret) {
> >> +             of_unregister_platform_driver(&xllsdma_of_driver);
> >> +             printk(KERN_ERR "registering driver failed: err=%i", ret);
> >> +             return ret;
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> 
> If registering fails, unregistering is not needed.  This function
> should simply be:
> 
> +int __init xllsdma_of_init(void)
> +{
> +     return of_register_platform_driver(&xllsdma_of_driver);
> +}
> 
> >> +
> >> +void xllsdma_of_exit(void)
> >> +{
> >> +     of_unregister_platform_driver(&xllsdma_of_driver);
> >> +}
> >> +
> >> +static int mpmc_of_remove(struct of_device *op)
> 
> +static int __devexit mpmc_of_remove(struct of_device *op)
> 
> >> +{
> >> +     struct device_node *node;
> >> +     struct of_device *ofdev;
> >> +
> >> +     for_each_child_of_node(op->node, node) {
> >> +             ofdev = of_find_device_by_node(node);
> >> +             of_device_unregister(ofdev);
> >> +             of_device_free(ofdev);
> >> +     }
> >> +
> >> +     mpmc_cleanup(&op->dev);
> >> +     return 0;
> >> +}
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
> 

It will simplify the code, I think.

> >> +
> >> +static struct of_device_id  __devinitdata mpmc_of_match[] = {
> >> +     { .compatible = "xlnx,mpmc-4.01.a" },
> >> +     { .compatible = "xlnx,mpmc-4.03.a" },
> >> +     {},
> >> +};
> >> +
> >> +static struct of_platform_driver mpmc_of_driver = {
> >> +     .name = "xilinx-mpmc",
> >> +     .match_table = mpmc_of_match,
> >> +     .probe = mpmc_of_probe,
> >> +     .remove = mpmc_of_remove,
> >> +};
> >> +
> >> +int __init mpmc_of_init(void)
> >> +{
> >> +     return of_register_platform_driver(&mpmc_of_driver);
> >> +}
> >> +
> >> +void mpmc_of_exit(void)
> >> +{
> >> +     of_unregister_platform_driver(&mpmc_of_driver);
> >> +}
> 
> Missing the module exit hook?
> 
> >> +
> >> +subsys_initcall(mpmc_of_init);
> >> +subsys_initcall(xllsdma_of_init);
> 
> Typically initcall statements are placed immediately after the init
> function they reference.
> 
> >> +#else        /* CONFIG_OF */
> 
> Why else?  It is perfectly valid to have both of_platform and platform
> bus bindings.  That being said, this split will become unnecessary in
> the very near future.  I've eliminated of_platform_bus_type, and
> automatically moved all users of it over to the platform bus (without
> driver changes).
> 
> However, current powerpc and microblaze code makes CONFIG_OF
> manditory.  What condition will compile in the platform bus
> attachment?
> 
> >> +/*---------------------------------------------------------------------
> >>------ + * Platform bus attachment
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
> > (i.e., it's NOT impossible with platform bus). It might be just as well
> > to put the check in xllsdma_init() since that's not a 'hot' code path.
> 
> Question: microblaze and powerpc both use the device tree.  What is
> the use-case for the non-dts version?

Maybe old kernel versions?

> 
> >> +     err = xllsdma_init(&pdev->dev, rx_irq, tx_irq, mem, pdev->id);
> >> +     if (err)
> >> +             xllsdma_plat_remove(pdev);
> >> +fail:
> >> +     return err;
> >> +}
> >> +
> >> +static struct platform_driver xllsdma_plat_driver = {
> >> +     .probe = xllsdma_plat_probe,
> >> +     .remove = __devexit_p(xllsdma_plat_remove),
> >> +     .driver = {
> >> +             .owner = THIS_MODULE,
> >> +             .name  = "xilinx-sdma",
> >> +     },
> >> +};
> >> +
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
> 
> >> +
> >> +int __init mpmc_plat_init(void)
> >> +{
> >> +     return platform_driver_register(&mpmc_plat_driver);
> >> +}
> >> +subsys_initcall(mpmc_plat_init);
> >> +
> >> +void mpmc_plat_exit(void)
> >> +{
> >> +     platform_driver_unregister(&mpmc_plat_driver);
> >> +}
> >> +#endif       /* CONFIG_OF */
> >> diff -r baced9e29ab5 include/linux/xllsdma.h
> >> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> >> +++ b/include/linux/xllsdma.h Wed Apr 28 02:00:51 2010 +0400
> >> @@ -0,0 +1,187 @@
> >> +/*
> >> + * SDMA subsystem support for Xilinx MPMC.
> >> + *
> >> + * Author: Sergey Temerkhanov
> >> + *
> >> + * Copyright (c) 2008-2010 Cifronic ZAO
> >> + *
> >> + * This program is free software; you can redistribute  it and/or
> >> modify it + * under  the terms of  the GNU General  Public License as
> >> published by the + * Free Software Foundation;  either version 2 of the
> >>  License, or (at your + * option) any later version.
> >> + *
> >> + */
> >> +
> >> +#ifndef __XLLSDMA_H__
> >> +#define __XLLSDMA_H__
> >> +
> >> +#include <linux/types.h>
> >> +#include <linux/dma-mapping.h>
> >> +
> >> +#define XLLSDMA_ALIGNMENT    0x40
> >> +
> >> +struct xllsdma_desc {
> >> +     __be32 next;
> >> +     __be32 address;
> >> +     __be32 length;
> >> +     __be32 stat_ctl;
> >> +     __be32 app1;
> >> +     __be32 app2;
> >> +     __be32 app3;
> >> +     __be32 app4;
> >> +     void *virt;
> >> +     u32 flags;
> >> +} __attribute__((aligned(XLLSDMA_ALIGNMENT)));
> >
> > 'virt' and 'flags' are not used by this driver. Putting them in this
> > structure, and using this structure in the API, forces them on all
> > clients, which can lead to inefficiencies (this will certainly be true in
> > the DMA engine driver, perhaps others). I think a better choice would be
> > to have the API use a structure without these two fields. For the
> > convenience of other clients you could define a 'superstructure' _not_
> > used in the API, like:
> >
> > struct xllsdma_fancy_desc {
> >        struct xllsdma_desc  basic_desc;
> >        void *virt;
> >        u32 flags;
> > }

Looks reasonable.


