Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1IPSz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:55:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43219 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1IPSz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
Date: Sat, 17 Sep 2011 00:25:56 +0530
Message-ID: <CABb+yY13Xum=nU2eD+DJ7Uv_8ppE+UKFUA6KD_4CP+eDG5rAaQ@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Barry Song <Baohua.Song@csr.com>
Cc: vinod.koul@intel.com, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 3:26 PM, Barry Song <Baohua.Song@csr.com> wrote:

> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> +       struct dma_slave_config *config)
> +{
> +       u32 addr, direction;
> +       unsigned long flags;
> +
> +       switch (config->direction) {
> +       case DMA_FROM_DEVICE:
> +               direction = 0;
> +               addr = config->dst_addr;
> +               break;
> +
> +       case DMA_TO_DEVICE:
> +               direction = 1;
> +               addr = config->src_addr;
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> +               (config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> +               return -EINVAL;
> +
> +       spin_lock_irqsave(&schan->lock, flags);
> +       schan->addr = addr;
> +       schan->direction = direction;
> +       schan->mode = (config->src_maxburst == 4 ? 1 : 0);
> +       spin_unlock_irqrestore(&schan->lock, flags);
> +
> +       return 0;
> +}
You don't need to pass as much info via dma_slave_config as you do here.

dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => DMA_TO_DEVICE
!dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => DMA_FROM_DEVICE

Pass addresses using dmaxfer_template.src_start and dmaxfer_template.dst_start
instead of dma_slave_config.dst_addr and dma_slave_config.src_addr

So, currently you need dma_slave_config only to pass src_addr_width,
dst_addr_width and src_maxburst to the dmac driver.


> +
> +static struct dma_async_tx_descriptor *sirfsoc_dma_prep_slave_sg(
> +       struct dma_chan *chan, struct scatterlist *sgl,
> +       unsigned int sg_len, enum dma_data_direction direction,
> +       unsigned long flags)
> +{
> +       return NULL;
> +}
> +
In v3 I'll remove the BUG_ON check that requires every SLAVE channel
provides device_prep_slave_sg, so you should be able to simply discard
this stub.
