Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1IPHRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:17:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1IPHRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org> <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 16 Sep 2011 15:17:03 +0800
Message-ID: <CAGsJ_4whS+_hEdyNgOKOUzRBCn=99Z4x0x_jg1qnsL+uTmjt+A@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Define generic transfer request api
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: dan.j.williams@intel.com, vkoul@infradead.org,
        linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15 Jassi Brar <jaswinder.singh@linaro.org>:
> Define a new api that could be used for doing fancy data transfers
> like interleaved to contiguous copy and vice-versa.
> Traditional SG_list based transfers tend to be very inefficient in
> such cases as where the interleave and chunk are only a few bytes,
> which call for a very condensed api to convey pattern of the transfer.
>
> This api supports all 4 variants of scatter-gather and contiguous transfer.
> Besides, in future it could also represent common operations like
>        device_prep_dma_{cyclic, memset, memcpy}
> and maybe some more that I am not sure of.
>
> Of course, neither can this api help transfers that don't lend to DMA by
> nature, i.e, scattered tiny read/writes with no periodic pattern.
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>
> Changes since v1:
>   1) Dropped the 'dma_transaction_type' member until we really
>      merge another type into this api. Instead added special
>      type for this api - DMA_GENXFER in dma_transaction_type.
>   2) Renamed 'xfer_template' to 'dmaxfer_template' inorder to
>      preserve namespace, closer to as suggested by Barry Song.
>
>  drivers/dma/dmaengine.c   |    2 +
>  include/linux/dmaengine.h |   71 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index b48967b..63284f6 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -699,6 +699,8 @@ int dma_async_device_register(struct dma_device *device)
>                !device->device_prep_dma_cyclic);
>        BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
>                !device->device_control);
> +       BUG_ON(dma_has_cap(DMA_GENXFER, device->cap_mask) &&
> +               !device->device_prep_dma_genxfer);

i don't think it is what i want here. device_prep_dma_genxfer should
be able to cover memcpy, slave or other modes, but not parallel with
them.
For example, if i use genxfer, but my devices are slave. i might not
need a device_prep_slave_sg since i have already prep_dma_genxfer, but
anyway, i need a DMA_SLAVE_CONFIG to set burst size or others. then
i'd like to have DMA_SLAVE flag but without device_prep_slave_sg
callback.

>
>        BUG_ON(!device->device_alloc_chan_resources);
>        BUG_ON(!device->device_free_chan_resources);
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 8fbf40e..68ebe6c 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -71,11 +71,79 @@ enum dma_transaction_type {
>        DMA_ASYNC_TX,
>        DMA_SLAVE,
>        DMA_CYCLIC,
> +       DMA_GENXFER,
>  };

-barry
