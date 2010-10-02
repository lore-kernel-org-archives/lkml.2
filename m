Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0JBKGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:06:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56186 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0JBKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ff0Uq2NJN9z5i5RR24y+086wuoTE6yzWAh+rB552Ej8QgAiWydb/UvIXoBc2utJwe4
         mpohbP+nEmJxmJOl+7jg8NVmokcaRLJe2LC5Ebi+F49OwwivwH33l0gUaw1/IX+gxjML
         i/ziFpO5fgrE1TIJ3BgqzzhnFqKcvX95EAHPU=
Date: Sat, 2 Oct 2010 12:05:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH 1/1] nouveau: ratelimit IRQ messages
Message-ID: <20101002100503.GA2760@joi.lan>
References: <1286006336-24651-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286006336-24651-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 09:58:56AM +0200, Jiri Slaby wrote:
> There are two messages in the ISR of nouvea which might be printed out
> hundred times in a second. Ratelimit them.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_irq.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
> index 794b0ee..c6d57eb 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_irq.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
> @@ -200,7 +200,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
>  		}
>  
>  		if (status & NV_PFIFO_INTR_DMA_PUSHER) {
> -			NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d\n", chid);
> +			if (printk_ratelimit())
> +				NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d\n",
> +						chid);

There's nouveau_ratelimit() for this.
  
>  			status &= ~NV_PFIFO_INTR_DMA_PUSHER;
>  			nv_wr32(dev, NV03_PFIFO_INTR_0,
> @@ -227,8 +229,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
>  		}
>  
>  		if (status) {
> -			NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
> -				status, chid);
> +			if (printk_ratelimit())
> +				NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
> +					status, chid);
>  			nv_wr32(dev, NV03_PFIFO_INTR_0, status);
>  			status = 0;
>  		}
> -- 
> 1.7.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
