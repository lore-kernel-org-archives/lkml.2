Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1JQQhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:37:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:55888 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab1JQQhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:37:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,360,1315206000"; 
   d="scan'208";a="27434448"
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org, Barry Song <Barry.Song@csr.com>
In-Reply-To: <CAGsJ_4y4ZxqmefxXS+2QEtTcq6Jr9+o92pd4enRYQMkG3kZ=ng@mail.gmail.com>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
	 <1318859861.23438.137.camel@vkoul-udesk3>
	 <CAGsJ_4y4ZxqmefxXS+2QEtTcq6Jr9+o92pd4enRYQMkG3kZ=ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 21:59:05 +0530
Message-ID: <1318868945.23438.145.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 22:18 +0800, Barry Song wrote:
> 2011/10/17 Vinod Koul <vinod.koul@intel.com>:
> >> +
> >> +     /* Start the DMA transfer */
> >> +     writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
> >> +     writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
> >> +             (sdesc->dir << SIRFSOC_DMA_DIR_CTRL_BIT),
> >> +             sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
> >> +     writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
> >> +     writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
> >> +     writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
> >> +             sdma->base + SIRFSOC_DMA_INT_EN);
> >> +     writel(sdesc->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
> >> +
> >> +     if (sdesc->cyclic) {
> >> +             writel((1 << cid) | 1 << (cid + 16) |
> >> +                     readl_relaxed(sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL),
> >> +                     sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL);
> >> +             schan->happened_cyclic = schan->completed_cyclic = 0;
> >> +     }
> > any reason why we have mixed use of writel_relaxes and writel?
> > Shouldn't all the DMA register writes be done only using writel?
> 
> Arnd comment this in v2.
Yes he certainly did, but for maintainability, it would really help to
explain what you are doing here.

> >
> >> +}
> >> +
> >> +
> >> +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
> >> +     struct dma_chan *chan, struct dma_interleaved_template *xt)
> >> +{
> >> +     struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +     struct sirfsoc_dma_desc *sdesc = NULL;
> >> +     unsigned long iflags;
> >> +     int ret;
> >> +
> >> +     if ((xt->dir != MEM_TO_DEV) || (xt->dir != DEV_TO_MEM)) {
> >> +             ret = -EINVAL;
> >> +             goto err_dir;
> >> +     }
> >> +
> >> +     /* Get free descriptor */
> >> +     spin_lock_irqsave(&schan->lock, iflags);
> >> +     if (!list_empty(&schan->free)) {
> >> +             sdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
> >> +                     node);
> >> +             list_del(&sdesc->node);
> >> +     }
> >> +     spin_unlock_irqrestore(&schan->lock, iflags);
> >> +
> >> +     if (!sdesc) {
> >> +             /* try to free completed descriptors */
> >> +             sirfsoc_dma_process_completed(sdma);
> >> +             ret = 0;
> >> +             goto no_desc;
> >> +     }
> >> +
> >> +     /* Place descriptor in prepared list */
> >> +     spin_lock_irqsave(&schan->lock, iflags);
> >> +     if ((xt->frame_size == 1) && (xt->numf > 0)) {
> > what does this mean?
> >> +             sdesc->cyclic = 0;
> >> +             sdesc->xlen = xt->sgl[0].size / 4;
> >> +             sdesc->width = (xt->sgl[0].size + xt->sgl[0].icg) / 4;
> > whats so magical about 4?
> 
> the xlen and dma_width is in 4 byes boundary. xlen =1 means 4 bytes
> will be transferred every line.
I meant two things
 - why magical number 4, CSRXXX_DMA_WITH would have been much better
 - same for frame_size as 1

> > the error path handling in this function is totally non existent!!
> 
> sorry. i must have maken these idiot mistakens due to copying from the
> probe of drivers/dma/mpc512x_dma.c.
> 
> >> +
> >> +static int __devexit sirfsoc_dma_remove(struct platform_device *op)
> >> +{
> >> +     struct device *dev = &op->dev;
> >> +     struct sirfsoc_dma *sdma = dev_get_drvdata(dev);
> >> +
> >> +     dma_async_device_unregister(&sdma->dma);
> >> +     devm_free_irq(dev, sdma->irq, sdma);
> >> +     irq_dispose_mapping(sdma->irq);
> > who will free mem allocated in probe?
> 
> also due to copying from drivers/dma/mpc512x_dma.c. sorry.
Thanks, I will put these in my todo


-- 
~Vinod

