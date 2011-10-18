Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1JRB3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:29:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54036 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1JRB3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:29:00 -0400
MIME-Version: 1.0
In-Reply-To: <1318868945.23438.145.camel@vkoul-udesk3>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
 <1318859861.23438.137.camel@vkoul-udesk3> <CAGsJ_4y4ZxqmefxXS+2QEtTcq6Jr9+o92pd4enRYQMkG3kZ=ng@mail.gmail.com>
 <1318868945.23438.145.camel@vkoul-udesk3>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 18 Oct 2011 09:28:39 +0800
Message-ID: <CAGsJ_4yH2j5=ryMeXfTk-iD2NSN9SAeKzFSXcy4Sa64QZNR4FQ@mail.gmail.com>
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
To: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org, Barry Song <Barry.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/18 Vinod Koul <vinod.koul@intel.com>:
> On Mon, 2011-10-17 at 22:18 +0800, Barry Song wrote:
>> 2011/10/17 Vinod Koul <vinod.koul@intel.com>:
>> >> +
>> >> +     /* Start the DMA transfer */
>> >> +     writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
>> >> +     writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
>> >> +             (sdesc->dir << SIRFSOC_DMA_DIR_CTRL_BIT),
>> >> +             sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
>> >> +     writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
>> >> +     writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
>> >> +     writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
>> >> +             sdma->base + SIRFSOC_DMA_INT_EN);
>> >> +     writel(sdesc->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
>> >> +
>> >> +     if (sdesc->cyclic) {
>> >> +             writel((1 << cid) | 1 << (cid + 16) |
>> >> +                     readl_relaxed(sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL),
>> >> +                     sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL);
>> >> +             schan->happened_cyclic = schan->completed_cyclic = 0;
>> >> +     }
>> > any reason why we have mixed use of writel_relaxes and writel?
>> > Shouldn't all the DMA register writes be done only using writel?
>>
>> Arnd comment this in v2.
> Yes he certainly did, but for maintainability, it would really help to
> explain what you are doing here.
>
>> >
>> >> +}
>> >> +
>> >> +
>> >> +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
>> >> +     struct dma_chan *chan, struct dma_interleaved_template *xt)
>> >> +{
>> >> +     struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
>> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
>> >> +     struct sirfsoc_dma_desc *sdesc = NULL;
>> >> +     unsigned long iflags;
>> >> +     int ret;
>> >> +
>> >> +     if ((xt->dir != MEM_TO_DEV) || (xt->dir != DEV_TO_MEM)) {
>> >> +             ret = -EINVAL;
>> >> +             goto err_dir;
>> >> +     }
>> >> +
>> >> +     /* Get free descriptor */
>> >> +     spin_lock_irqsave(&schan->lock, iflags);
>> >> +     if (!list_empty(&schan->free)) {
>> >> +             sdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
>> >> +                     node);
>> >> +             list_del(&sdesc->node);
>> >> +     }
>> >> +     spin_unlock_irqrestore(&schan->lock, iflags);
>> >> +
>> >> +     if (!sdesc) {
>> >> +             /* try to free completed descriptors */
>> >> +             sirfsoc_dma_process_completed(sdma);
>> >> +             ret = 0;
>> >> +             goto no_desc;
>> >> +     }
>> >> +
>> >> +     /* Place descriptor in prepared list */
>> >> +     spin_lock_irqsave(&schan->lock, iflags);
>> >> +     if ((xt->frame_size == 1) && (xt->numf > 0)) {
>> > what does this mean?
>> >> +             sdesc->cyclic = 0;
>> >> +             sdesc->xlen = xt->sgl[0].size / 4;
>> >> +             sdesc->width = (xt->sgl[0].size + xt->sgl[0].icg) / 4;
>> > whats so magical about 4?
>>
>> the xlen and dma_width is in 4 byes boundary. xlen =1 means 4 bytes
>> will be transferred every line.
> I meant two things
>  - why magical number 4, CSRXXX_DMA_WITH would have been much better
>  - same for frame_size as 1
>
>> > the error path handling in this function is totally non existent!!
>>
>> sorry. i must have maken these idiot mistakens due to copying from the
>> probe of drivers/dma/mpc512x_dma.c.
>>
>> >> +
>> >> +static int __devexit sirfsoc_dma_remove(struct platform_device *op)
>> >> +{
>> >> +     struct device *dev = &op->dev;
>> >> +     struct sirfsoc_dma *sdma = dev_get_drvdata(dev);
>> >> +
>> >> +     dma_async_device_unregister(&sdma->dma);
>> >> +     devm_free_irq(dev, sdma->irq, sdma);
>> >> +     irq_dispose_mapping(sdma->irq);
>> > who will free mem allocated in probe?
>>
>> also due to copying from drivers/dma/mpc512x_dma.c. sorry.
> Thanks, I will put these in my todo

you will find many drivers haven't error handlers in drivers/dma.....
we have missed while reviewing before.
people might copy from a same source, then make same mistakens.

-barry
