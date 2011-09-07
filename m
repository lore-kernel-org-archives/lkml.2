Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1IGSJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:09:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:60357 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1IGSJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,346,1312182000"; 
   d="scan'208";a="50116807"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "jassisinghbrar@gmail.com" <jassisinghbrar@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 7 Sep 2011 23:39:04 +0530
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Topic: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Index: AcxtiTq3I8F7wqUNSC6Z9spXb4ENfA==
Message-ID: <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
In-Reply-To: <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87I9VWS021749

On Thu, 2011-09-08 at 00:46 +0800, Barry Song wrote:
> Hi Vinod,
> thanks for your quick feedback.
>
> 2011/9/8 Koul, Vinod <vinod.koul@intel.com>:
> > On Tue, 2011-09-06 at 22:41 -0700, Barry Song wrote:
> >> From: Rongjun Ying <rongjun.ying@csr.com>
> >
> >> +config SIRF_DMA
> >> +     tristate "CSR SiRFprimaII DMA support"
> >> +     depends on ARCH_PRIMA2
> >> +     select DMA_ENGINE
> >> +     help
> >> +       Enable support for the CSR SiRFprimaII DMA engine.
> > How different is it from the other primacell based DMA drivers, and why
> > wouldn't it make sense to use/modify one of them?
>
> it is much different with primacell based DMA like pl080, pl330.
> prima2 has a self-defined DMAC IP. basically it is a 2D mode dma with
> two scales X and Y and direct way to start and stop DMA.
> every channel has fixed function to serve only one perpheral. so you
> find we have a filter id.
okay, what do you mean by 2D mode? Is it similar to what TI folks, Linus
W and Jassi Brar posted RFC's on?
IIRC, other primacell dmacs do have this capability but not supported by
the drivers, so I think this could be added in current drivers, Jassi
and Linus W can comment better...

[snip]

>> +
> >> +/* Submit descriptor to hardware */
> >> +static dma_cookie_t sirfsoc_dma_tx_submit(struct dma_async_tx_descriptor *txd)
> >> +{
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(txd->chan);
> >> +     struct sirfsoc_dma_desc *mdesc;
> >> +     unsigned long flags;
> >> +     dma_cookie_t cookie;
> >> +
> >> +     mdesc = container_of(txd, struct sirfsoc_dma_desc, desc);
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +
> >> +     /* Move descriptor to queue */
> >> +     list_move_tail(&mdesc->node, &schan->queued);
> >> +
> >> +     /* If channel is idle, execute all queued descriptors */
> >> +     if (list_empty(&schan->active))
> >> +             sirfsoc_dma_execute(schan);
> > this is wrong, this should be done in .issue_pending
>
> ok. as i reference several current drivers in drivers/dma, they are
> doing dma  start in submit....guess they are wrong too?
Right, please see Documentation/dmaengine.txt.

>
> >
> >> +
> >> +     /* Update cookie */
> >> +     cookie = schan->chan.cookie + 1;
> >> +     if (cookie <= 0)
> >> +             cookie = 1;
> >> +
> >> +     schan->chan.cookie = cookie;
> >> +     mdesc->desc.cookie = cookie;
> >> +
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +
> >> +     return cookie;
> >> +}
> >> +
> >> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> >> +     struct sirfsoc_dma_slave_config *config)
> >> +{
> >> +     u32 addr, direction;
> >> +     unsigned long flags;
> >> +
> >> +     switch (config->generic_config.direction) {
> >> +     case DMA_FROM_DEVICE:
> >> +             direction = 0;
> >> +             addr = config->generic_config.dst_addr;
> >> +             break;
> >> +
> >> +     case DMA_TO_DEVICE:
> >> +             direction = 1;
> >> +             addr = config->generic_config.src_addr;
> >> +             break;
> >> +
> >> +     default:
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     if ((config->generic_config.src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> >> +             (config->generic_config.dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> >> +             return -EINVAL;
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +     schan->addr = addr;
> >> +     schan->direction = direction;
> >> +     schan->xlen = config->xlen;
> >> +     schan->ylen = config->ylen;
> >> +     schan->width = config->width;
> > what do these parameters mean, is width the dma fifo width, if so use
> > existing members for that
>
> the width is not dma fifo width. prima2 required 3 parameters to begin
> a 2D dma transfer, the relationship is as below:
>
> <----------------width----------------->
> |-------|-------------------------|----------|          ---
> |        |                              |             |           ^
> |        | <----------xlen----->|             |           |
> |        |                              |             |         ylen
> |        |                              |             |           |
> |-------|-------------------------|-----------|        _v_
>
> after i go back to office, i'll copy details from datasheet to you.
>
> >
> >> +     schan->mode = (config->generic_config.src_maxburst == 4 ? 1 : 0);
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static int sirfsoc_dma_terminate_all(struct sirfsoc_dma_chan *schan)
> >> +{
> >> +     struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
> >> +     int cid = schan->chan.chan_id;
> >> +     unsigned long flags;
> >> +
> >> +     writel_relaxed(readl_relaxed(sdma->regs + SIRFSOC_DMA_INT_EN) & ~(1 << cid),
> >> +             sdma->regs + SIRFSOC_DMA_INT_EN);
> >> +     writel_relaxed(1 << cid, sdma->regs + SIRFSOC_DMA_CH_VALID);
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +
> >> +     list_splice_tail_init(&schan->queued, &schan->free);
> > what about active list
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static int sirfsoc_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> >> +     unsigned long arg)
> >> +{
> >> +     struct sirfsoc_dma_slave_config *config;
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +
> >> +     switch (cmd) {
> >> +     case DMA_TERMINATE_ALL:
> >> +             return sirfsoc_dma_terminate_all(schan);
> >> +     case DMA_SLAVE_CONFIG:
> >> +             config = (struct sirfsoc_dma_slave_config *)arg;
> >> +             return sirfsoc_dma_slave_config(schan, config);
> >> +
> >> +     default:
> >> +             break;
> >> +     }
> >> +
> >> +     return -ENOSYS;
> >> +}
> >> +
> >> +/* Alloc channel resources */
> >> +static int sirfsoc_dma_alloc_chan_resources(struct dma_chan *chan)
> >> +{
> >> +     struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +     struct sirfsoc_dma_desc *mdesc;
> >> +     unsigned long flags;
> >> +     LIST_HEAD(descs);
> >> +     int i;
> >> +
> >> +     /* Alloc descriptors for this channel */
> >> +     for (i = 0; i < SIRFSOC_DMA_DESCRIPTORS; i++) {
> >> +             mdesc = kzalloc(sizeof(struct sirfsoc_dma_desc), GFP_KERNEL);
> >> +             if (!mdesc) {
> >> +                     dev_notice(sdma->dma.dev, "Memory allocation error. "
> >> +                             "Allocated only %u descriptors\n", i);
> >> +                     break;
> >> +             }
> >> +
> >> +             dma_async_tx_descriptor_init(&mdesc->desc, chan);
> >> +             mdesc->desc.flags = DMA_CTRL_ACK;
> >> +             mdesc->desc.tx_submit = sirfsoc_dma_tx_submit;
> >> +
> >> +             list_add_tail(&mdesc->node, &descs);
> >> +     }
> >> +
> >> +     /* Return error only if no descriptors were allocated */
> >> +     if (i == 0)
> >> +             return -ENOMEM;
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +
> >> +     list_splice_tail_init(&descs, &schan->free);
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +/* Free channel resources */
> >> +static void sirfsoc_dma_free_chan_resources(struct dma_chan *chan)
> >> +{
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +     struct sirfsoc_dma_desc *mdesc, *tmp;
> >> +     unsigned long flags;
> >> +     LIST_HEAD(descs);
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +
> >> +     /* Channel must be idle */
> >> +     BUG_ON(!list_empty(&schan->prepared));
> >> +     BUG_ON(!list_empty(&schan->queued));
> >> +     BUG_ON(!list_empty(&schan->active));
> >> +     BUG_ON(!list_empty(&schan->completed));
> >> +
> >> +     /* Move data */
> >> +     list_splice_tail_init(&schan->free, &descs);
> >> +
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +
> >> +     /* Free descriptors */
> >> +     list_for_each_entry_safe(mdesc, tmp, &descs, node)
> >> +             kfree(mdesc);
> >> +}
> >> +
> >> +/* Send pending descriptor to hardware */
> >> +static void sirfsoc_dma_issue_pending(struct dma_chan *chan)
> >> +{
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +
> >> +     if (list_empty(&schan->active) && !list_empty(&schan->queued))
> >> +             sirfsoc_dma_execute(schan);
> >> +
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +}
> >> +
> >> +/* Check request completion status */
> >> +static enum dma_status
> >> +sirfsoc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> >> +     struct dma_tx_state *txstate)
> >> +{
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +     unsigned long flags;
> >> +     dma_cookie_t last_used;
> >> +     dma_cookie_t last_complete;
> >> +
> >> +     spin_lock_irqsave(&schan->lock, flags);
> >> +     last_used = schan->chan.cookie;
> >> +     last_complete = schan->completed_cookie;
> >> +     spin_unlock_irqrestore(&schan->lock, flags);
> >> +
> >> +     dma_set_tx_state(txstate, last_complete, last_used, 0);
> >> +     return dma_async_is_complete(cookie, last_complete, last_used);
> >> +}
> >> +
> >> +/* Prepare descriptor for memory to memory copy */
> >> +static struct dma_async_tx_descriptor *
> >> +sirfsoc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
> >> +     size_t len, unsigned long flags)
> >> +{
> >> +     struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
> >> +     struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
> >> +     struct sirfsoc_dma_desc *mdesc = NULL;
> >> +     unsigned long iflags;
> >> +
> >> +     /* Get free descriptor */
> >> +     spin_lock_irqsave(&schan->lock, iflags);
> >> +     if (!list_empty(&schan->free)) {
> >> +             mdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
> >> +                     node);
> >> +             list_del(&mdesc->node);
> >> +     }
> >> +     spin_unlock_irqrestore(&schan->lock, iflags);
> >> +
> >> +     if (!mdesc) {
> >> +             /* try to free completed descriptors */
> >> +             sirfsoc_dma_process_completed(sdma);
> >> +             return NULL;
> >> +     }
> >> +
> >> +     /* Place descriptor in prepared list */
> >> +     spin_lock_irqsave(&schan->lock, iflags);
> >> +     list_add_tail(&mdesc->node, &schan->prepared);
> >> +     spin_unlock_irqrestore(&schan->lock, iflags);
> >> +
> >> +     return &mdesc->desc;
> >> +}
> >> +
> >> +/*
> >> + * The DMA controller consists of 16 independent DMA channels.
> >> + * Each channel is allocated to a different function
> >> + */
> >> +bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
> >> +{
> >> +     unsigned int ch_nr = (unsigned int) chan_id;
> >> +
> >> +     if (ch_nr == chan->chan_id)
> >> +             return true;
> >> +
> >> +     return false;
> >> +}
> >> +EXPORT_SYMBOL(sirfsoc_dma_filter_id);
> >> +
> >> +static int __devinit sirfsoc_dma_probe(struct platform_device *op)
> >> +{
> >> +     struct device_node *dn = op->dev.of_node;
> >> +     struct device *dev = &op->dev;
> >> +     struct dma_device *dma;
> >> +     struct sirfsoc_dma *sdma;
> >> +     struct sirfsoc_dma_chan *schan;
> >> +     struct resource res;
> >> +     ulong regs_start, regs_size;
> >> +     u32 id;
> >> +     int retval, i;
> >> +
> >> +     sdma = devm_kzalloc(dev, sizeof(struct sirfsoc_dma), GFP_KERNEL);
> >> +     if (!sdma) {
> >> +             dev_err(dev, "Memory exhausted!\n");
> >> +             return -ENOMEM;
> >> +     }
> >> +
> >> +     if (of_property_read_u32(dn, "cell-index", &id)) {
> >> +             dev_err(dev, "Fail to get DMAC index\n");
> >> +             return -ENODEV;
> >> +     }
> >> +
> >> +     sdma->irq = irq_of_parse_and_map(dn, 0);
> >> +     if (sdma->irq == NO_IRQ) {
> >> +             dev_err(dev, "Error mapping IRQ!\n");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     retval = of_address_to_resource(dn, 0, &res);
> >> +     if (retval) {
> >> +             dev_err(dev, "Error parsing memory region!\n");
> >> +             return retval;
> >> +     }
> >> +
> >> +     regs_start = res.start;
> >> +     regs_size = resource_size(&res);
> >> +
> >> +     if (!devm_request_mem_region(dev, regs_start, regs_size, DRV_NAME)) {
> >> +             dev_err(dev, "Error requesting memory region!\n");
> >> +             return -EBUSY;
> >> +     }
> >> +
> >> +     sdma->regs = devm_ioremap(dev, regs_start, regs_size);
> >> +     if (!sdma->regs) {
> >> +             dev_err(dev, "Error mapping memory region!\n");
> >> +             return -ENOMEM;
> >> +     }
> >> +
> >> +     retval = devm_request_irq(dev, sdma->irq, &sirfsoc_dma_irq, 0, DRV_NAME,
> >> +             sdma);
> >> +     if (retval) {
> >> +             dev_err(dev, "Error requesting IRQ!\n");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     dma = &sdma->dma;
> >> +     dma->dev = dev;
> >> +     dma->chancnt = SIRFSOC_DMA_CHANNELS;
> >> +
> >> +     dma->device_alloc_chan_resources = sirfsoc_dma_alloc_chan_resources;
> >> +     dma->device_free_chan_resources = sirfsoc_dma_free_chan_resources;
> >> +     dma->device_issue_pending = sirfsoc_dma_issue_pending;
> >> +     dma->device_control = sirfsoc_dma_control;
> >> +     dma->device_tx_status = sirfsoc_dma_tx_status;
> >> +     dma->device_prep_dma_memcpy = sirfsoc_dma_prep_memcpy;
> >> +
> >> +     INIT_LIST_HEAD(&dma->channels);
> >> +     dma_cap_set(DMA_MEMCPY, dma->cap_mask);
> > DMA_SLAVE as well..
>
> ok.
>
> >
> >> +
> >> +     for (i = 0; i < dma->chancnt; i++) {
> >> +             schan = &sdma->channels[i];
> >> +
> >> +             schan->chan.device = dma;
> >> +             schan->chan.chan_id = dma->chancnt * id + i;
> >> +             schan->chan.cookie = 1;
> >> +             schan->completed_cookie = schan->chan.cookie;
> >> +
> >> +             INIT_LIST_HEAD(&schan->free);
> >> +             INIT_LIST_HEAD(&schan->prepared);
> >> +             INIT_LIST_HEAD(&schan->queued);
> >> +             INIT_LIST_HEAD(&schan->active);
> >> +             INIT_LIST_HEAD(&schan->completed);
> >> +
> >> +             spin_lock_init(&schan->lock);
> >> +             list_add_tail(&schan->chan.device_node, &dma->channels);
> >> +     }
> >> +
> >> +     tasklet_init(&sdma->tasklet, sirfsoc_dma_tasklet, (unsigned long)sdma);
> >> +
> >> +     /* Register DMA engine */
> >> +     dev_set_drvdata(dev, sdma);
> >> +     retval = dma_async_device_register(dma);
> >> +     if (retval) {
> >> +             devm_free_irq(dev, sdma->irq, sdma);
> >> +             irq_dispose_mapping(sdma->irq);
> >> +     }
> >> +
> >> +     return retval;
> >> +}
> >> +
> >> +static int __devexit sirfsoc_dma_remove(struct platform_device *op)
> >> +{
> >> +     struct device *dev = &op->dev;
> >> +     struct sirfsoc_dma *sdma = dev_get_drvdata(dev);
> >> +
> >> +     dma_async_device_unregister(&sdma->dma);
> >> +     devm_free_irq(dev, sdma->irq, sdma);
> >> +     irq_dispose_mapping(sdma->irq);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static struct of_device_id sirfsoc_dma_match[] = {
> >> +     { .compatible = "sirf,prima2-dmac", },
> >> +     {},
> >> +};
> >> +
> >> +static struct platform_driver sirfsoc_dma_driver = {
> >> +     .probe          = sirfsoc_dma_probe,
> >> +     .remove         = __devexit_p(sirfsoc_dma_remove),
> >> +     .driver = {
> >> +             .name = DRV_NAME,
> >> +             .owner = THIS_MODULE,
> >> +             .of_match_table = sirfsoc_dma_match,
> >> +     },
> >> +};
> >> +
> >> +static int __init sirfsoc_dma_init(void)
> >> +{
> >> +     return platform_driver_register(&sirfsoc_dma_driver);
> >> +}
> >> +module_init(sirfsoc_dma_init);
> >> +
> >> +static void __exit sirfsoc_dma_exit(void)
> >> +{
> >> +     platform_driver_unregister(&sirfsoc_dma_driver);
> >> +}
> >> +module_exit(sirfsoc_dma_exit);
> >> +
> >> +MODULE_AUTHOR("Rongjun Ying <rongjun.ying@csr.com>, "
> >> +     "Barry Song <baohua.song@csr.com>");
> >> +MODULE_DESCRIPTION("SIRFSOC DMA control driver");
> >> +MODULE_LICENSE("GPL");
> >> diff --git a/include/linux/sirfsoc_dma.h b/include/linux/sirfsoc_dma.h
> >> new file mode 100644
> >> index 0000000..75d2d86
> >> --- /dev/null
> >> +++ b/include/linux/sirfsoc_dma.h
> >> @@ -0,0 +1,18 @@
> >> +#ifndef _SIRFSOC_DMA_H_
> >> +#define _SIRFSOC_DMA_H_
> >> +/*
> >> + * create a custom slave config struct for CSR SiRFprimaII and pass that,
> >> + * and make dma_slave_config a member of that struct
> >> + */
> >> +struct sirfsoc_dma_slave_config {
> >> +     struct dma_slave_config generic_config;
> >> +
> >> +     /* CSR SiRFprimaII 2D-DMA config */
> >> +     int             xlen;           /* DMA xlen */
> >> +     int             ylen;           /* DMA ylen */
> > what lengths?
> >
> >> +     int             width;          /* DMA width */
> >> +};
> >> +
> >> +bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id);
> >> +
> >> +#endif
>
> Thanks
> barry
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--
~Vinod
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
