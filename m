Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2A0Is0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:48:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2A0IsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:48:23 -0500
Date: Fri, 27 Jan 2012 09:48:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
In-Reply-To: <4F22624E.2090201@renesas.com>
Message-ID: <Pine.LNX.4.64.1201270946150.32661@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de> <4F22624E.2090201@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:cJnr23hj2+uEeJI9sMzL8McD6XtVpe704DHvz07jr43
 9Jo8Xc9tWwfrn3sUx5gdvgBSLhWEJTZ+p9TiXslcz90ewR/fmJ
 0f9UJUt86p7JWF9PoCF+2RG8AORVKL9lsahhulg/8iOcr9SDix
 t4lW+MhfnHgGO70t4ZCKVDfDqHibyIkIB4H/D282DQJfZa4HqQ
 EBL9QR1l+WKAHnOmc4m+rRGfU1M2lK/fMPG0dDKQ1cDXENb/A+
 N1OeeK3dlttSqnSQVRRLVkQ0BSVcAA/3iXHfaU5tWqiu/dxUYe
 12Z2cjhWjtBNABOL820jbWNNmLzSAeD8aRQd9G4Nhrn0MWouUf
 H/BSpiq22g7wry/Jpjzgmk/YKYvxPmKsB7GcQYvjnvZGn6zTbJ
 d8W2SqXXg2BVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shimoda-san

On Fri, 27 Jan 2012, Shimoda, Yoshihiro wrote:

> Hello Guennadi-san,
> 
> 2012/01/26 23:56, Guennadi Liakhovetski wrote:
> > This patch adds a library of functions, helping to implement dmaengine
> > drivers for hardware, unable to handle scatter-gather lists natively.
> > The first version of this driver only supports memcpy and slave DMA
> > operation.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > v2:
> > 
> > 1. switch from using a tasklet to threaded IRQ, which allowed to
> 
> I tested this driver on 2 environment, but it could not work correctly.
>  - renesas_usbhs driver with shdma driver on the mackerel board
>  - renesas_usbhs driver with experimental SUDMAC driver
> 
> In this case, should we modify the renesas_usbhs driver?

Yes, you do. Please, see the respective version of the shdma patch. It 
doesn't request channel IRQs any more directly, instead, it uses a 
dma-simple wrapper function. Also operations change a bit.

Thanks
Guennadi

> For reference, if I changed the threaded IRQ to tasklet,
> the 2 environment worked correctly:
> ==============
> diff --git a/drivers/dma/dma-simple.c b/drivers/dma/dma-simple.c
> index 49d8f7d..65a5170 100644
> --- a/drivers/dma/dma-simple.c
> +++ b/drivers/dma/dma-simple.c
> @@ -715,16 +715,18 @@ static irqreturn_t chan_irq(int irq, void *dev)
> 
>  	spin_lock(&schan->chan_lock);
> 
> -	ret = ops->chan_irq(schan, irq) ? IRQ_WAKE_THREAD : IRQ_NONE;
> +	ret = ops->chan_irq(schan, irq) ? IRQ_HANDLED : IRQ_NONE;
> +	if (ret == IRQ_HANDLED)
> +		tasklet_schedule(&schan->tasklet);
> 
>  	spin_unlock(&schan->chan_lock);
> 
>  	return ret;
>  }
> 
> -static irqreturn_t chan_irqt(int irq, void *dev)
> +static void chan_irqt(unsigned long dev)
>  {
> -	struct dma_simple_chan *schan = dev;
> +	struct dma_simple_chan *schan = (struct dma_simple_chan *)dev;
>  	const struct dma_simple_ops *ops =
>  		to_simple_dev(schan->dma_chan.device)->ops;
>  	struct dma_simple_desc *sdesc;
> @@ -744,15 +746,13 @@ static irqreturn_t chan_irqt(int irq, void *dev)
>  	spin_unlock_irq(&schan->chan_lock);
> 
>  	simple_chan_ld_cleanup(schan, false);
> -
> -	return IRQ_HANDLED;
>  }
> 
>  int dma_simple_request_irq(struct dma_simple_chan *schan, int irq,
>  			   unsigned long flags, const char *name)
>  {
> -	int ret = request_threaded_irq(irq, chan_irq, chan_irqt,
> -				       flags, name, schan);
> +	int ret = request_irq(irq, chan_irq, flags, name, schan);
> +	tasklet_init(&schan->tasklet, chan_irqt, (unsigned long)schan);
> 
>  	schan->irq = ret < 0 ? ret : irq;
> 
> diff --git a/include/linux/dma-simple.h b/include/linux/dma-simple.h
> index 5336674..beb1489 100644
> --- a/include/linux/dma-simple.h
> +++ b/include/linux/dma-simple.h
> @@ -68,6 +68,7 @@ struct dma_simple_chan {
>  	int id;				/* Raw id of this channel */
>  	int irq;			/* Channel IRQ */
>  	enum dma_simple_pm_state pm_state;
> +	struct tasklet_struct tasklet;
>  };
> 
>  /**
> ==============
> 
> Best regards,
> Yoshihiro Shimoda
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
