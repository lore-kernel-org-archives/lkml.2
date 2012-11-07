Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2KGU4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:56:22 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47799 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2KGU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:56:20 -0500
MIME-Version: 1.0
In-Reply-To: <1352109631-3385-14-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
	<1352109631-3385-14-git-send-email-b.zolnierkie@samsung.com>
Date: Wed, 7 Nov 2012 12:56:19 -0800
X-Google-Sender-Auth: cAtBDt-x-suuRRwAm4KUn8D2z60
Message-ID: <CAA9_cmfN_RzvmyZFYvNhiOAM+KeOfov7HAges8mHdNKcuz4Oww@mail.gmail.com>
Subject: Re: [PATCH 13/20] async_tx: do DMA unmap in core for XOR operations
From: Dan Williams <djbw@fb.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Ira Snyder <iws@ovro.caltech.edu>,
        "Koul, Vinod" <vinod.koul@intel.com>, vipin.kumar@st.com,
        t.figa@samsung.com,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend]

On Mon, Nov 5, 2012 at 2:00 AM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 440b609..0df69f1 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -392,6 +392,10 @@ void dma_chan_cleanup(struct kref *kref);
>  typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
>
>  typedef void (*dma_async_tx_callback)(void *dma_async_param);
> +
> +/* max value of ->max_xor from struct dma_device */
> +#define DMA_ASYNC_TX_MAX_ENT 128

This balloons the descriptor size.  Looks like the ppc4xx driver will
try to do 16MB allocations after this.  I think this should be limited
in the core to something like 16 or at most 32.  ppc4xx is also going
to be impacted by the removal of channel switching support in the
core.  Adding Anatolij as a heads up.

> +
>  /**
>   * struct dma_async_tx_descriptor - async transaction descriptor
>   * ---dma generic offload fields---
> @@ -402,8 +406,9 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
>   * @phys: physical address of the descriptor
>   * @chan: target channel for this operation
>   * @tx_submit: set the prepared descriptor(s) to be executed by the engine
> - * @dma_src: DMA source address (needed for DMA unmap)
> - * @dma_dst: DMA destination address (needed for DMA unmap)
> + * @dma_src: DMA source addresses (needed for DMA unmap)
> + * @dma_src_cnt: number of DMA source addresses (needed for DMA unmap)
> + * @dma_dst: DMA destination addresses (needed for DMA unmap)
>   * @dma_len: DMA length (needed for DMA unmap)
>   * @callback: routine to call after this operation is complete
>   * @callback_param: general parameter to pass to the callback routine
> @@ -420,8 +425,9 @@ struct dma_async_tx_descriptor {
>         dma_addr_t phys;
>         struct dma_chan *chan;
>         dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
> -       dma_addr_t dma_src;
> -       dma_addr_t dma_dst;
> +       dma_addr_t dma_src[DMA_ASYNC_TX_MAX_ENT];
> +       unsigned int dma_src_cnt;
> +       dma_addr_t dma_dst[DMA_ASYNC_TX_MAX_ENT];
>         size_t dma_len;
>         dma_async_tx_callback callback;
>         void *callback_param;

For engines that don't care about raid this unmap data should be at
the end to hopefully get the more frequently used callback parameters
into the same cacheline as the rest.
