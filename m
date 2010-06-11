Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab0FKWX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:23:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37876 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab0FKWX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H968N/ZpvZzAWc4DFU5buVZkdQKchPe9YQpDKVIJCJDI1kUciO7GCf9wwI7ZSQkBZJ
         QVXiqsyIyUE4tp5m59iJ8KQSkHBNCwq4nJpy+2J3XzcDaoNDuNl9QZ8zkUh2L3l4KjbI
         WhMnQK6D+K8GxkZY2VCknmY6pLsIRrW/Ys81k=
MIME-Version: 1.0
In-Reply-To: <1275394835-26161-1-git-send-email-linus.walleij@stericsson.com>
References: <1275394835-26161-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 11 Jun 2010 15:23:26 -0700
X-Google-Sender-Auth: yKRf-WCbt17JCRMnRPbx75rplAw
Message-ID: <AANLkTinR-mwXyrGlrCg2TCR3DtPewBPnaoZf_MWySJzX@mail.gmail.com>
Subject: Re: [PATCH 02/18] DMAENGINE: ste_dma40: only write phy channel config 
	first time
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 5:20 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> We only need to write the configuration to a physical channel if
> it is free, else it is already written.
>
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/dma/ste_dma40.c |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 4618d6c..1cd1ff7 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -1211,9 +1211,9 @@ out:
>  }
>
>  static int d40_config_chan(struct d40_chan *d40c,
> -                          struct stedma40_chan_cfg *info)
> +                          struct stedma40_chan_cfg *info,
> +                          bool is_free_phy)
>  {
> -
>        /* Fill in basic CFG register values */
>        d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
>                    &d40c->dst_def_cfg, d40c->log_num != D40_PHY_CHAN);
> @@ -1230,8 +1230,14 @@ static int d40_config_chan(struct d40_chan *d40c,
>                                d40c->dma_cfg.dst_dev_type * 32 + 16;
>        }
>
> -       /* Write channel configuration to the DMA */
> -       return d40_config_write(d40c);
> +       /*
> +        * Only write channel configuration to the DMA if the physical
> +        * resource is free. In case of multiple logical channels
> +        * on the same physical resource, only the first write is necessary.
> +        */
> +       if (is_free_phy)
> +               return d40_config_write(d40c);
> +       return 0;
>  }
>
>  static int d40_config_memcpy(struct d40_chan *d40c)
> @@ -1691,7 +1697,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>        unsigned long flags;
>        struct d40_chan *d40c =
>                container_of(chan, struct d40_chan, chan);
> -
> +       bool is_free_phy;
>        spin_lock_irqsave(&d40c->lock, flags);
>
>        d40c->completed = chan->cookie = 1;
> @@ -1705,6 +1711,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>                if (err)
>                        goto err_alloc;
>        }
> +       is_free_phy = (d40c->phy_chan == NULL);
>

It seems like d40_config_chan() just wants to be open coded in
d40_alloc_chan_resources().  It does not have its own local variables,
and the only thing that returns an error is d40_config_write().

While trying to figure out why this flag was needed I happened to
notice a gratuitous use of gotos in d40_allocate_channel().  Can we
make this function easier to read by just returning -EINVAL directly
when those tests fail?

--
Dan
