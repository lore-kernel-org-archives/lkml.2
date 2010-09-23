Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab0IWTyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:54:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42385 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0IWTyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TQUYtZjBOfIRIPQ7VaPstFEJRBk/gaLEhl4h7e/CjcJi0zzxIgaOizKoWPEaF+eZQk
         lLp4veBlreg1rcz6RX+VPupYXXw+C1H2oAntXWq6HycxT/CpOxk90/cijjbvc8XtiA+Z
         b9z3UvNbWULi+5fPlwMckYiNqaktvVd4QVRFA=
MIME-Version: 1.0
In-Reply-To: <1281956870-12463-3-git-send-email-s.hauer@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-3-git-send-email-s.hauer@pengutronix.de>
Date: Thu, 23 Sep 2010 12:53:58 -0700
X-Google-Sender-Auth: P7JrI4T0XWzpoa3FfgFKhgUO3Jg
Message-ID: <AANLkTin8v_29HESnmhE5==3OLmb29bmoOY1iona4C+eD@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: add wrapper functions for dmaengine
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 4:07 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Currently dmaengine users have to explicitely dereference function
> pointers in struct dma_device. For the convenience of drivers and
> to be more flexible when changing the dmaengine later add static
> inline wrapper functions for the dma commands.
>
> This patch is not complete yet. If there's consensus on this patch
> I'll provide an updated patch with the missing functions.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  include/linux/dmaengine.h |   41 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 0df7864..635c60b 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -491,6 +491,47 @@ struct dma_device {
>        void (*device_issue_pending)(struct dma_chan *chan);
>  };
>
> +static inline int dmaengine_device_control(struct dma_chan *chan,
> +                                          enum dma_ctrl_cmd cmd,
> +                                          unsigned long arg)
> +{
> +       return chan->device->device_control(chan, cmd, arg);
> +}
> +
> +static inline int dmaengine_slave_config(struct dma_chan *chan,
> +                                         struct dma_slave_config *config)
> +{
> +       return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
> +                       (unsigned long)config);
> +}
> +
> +static inline int dmaengine_terminate_all(struct dma_chan *chan)
> +{
> +       return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
> +}
> +
> +static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
> +               struct dma_chan *chan, struct scatterlist *sgl,
> +               unsigned int sg_len, enum dma_data_direction direction,
> +               unsigned long flags)
> +{
> +       return chan->device->device_prep_slave_sg(chan, sgl, sg_len, direction,
> +                       flags);
> +}
> +
> +static inline struct dma_async_tx_descriptor *dmaengine_prep_cyclic(
> +               struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +               size_t period_len, enum dma_data_direction direction)
> +{
> +       return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
> +                       period_len, direction);
> +}
> +

No strong disagreements on the above, the type safety of
dmaengine_slave_config() is nice.

> +static inline int dmaengine_tx_submit(struct dma_async_tx_descriptor *desc)
> +{
> +       return desc->tx_submit(desc);
> +}

This one can drop the tx.

--
Dan
