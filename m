Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0JDQ0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:26:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40778 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0JDQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j6j9dpgma+OmLquIHP9eh3yA3LMPfTzHJ8LaJ9nCQFkFQKxnJgvyxFphDvrH0qjWME
         m+568yvkP8B40ji4aMUlnRb3e/xRxVoya6uTAO40Yri9D8VH3tO240di6tayiFQkD5mU
         9K5LC0xyONmSNP8fNxlkz0p7CKfrquoPGirYk=
Date: Mon, 4 Oct 2010 18:24:41 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH v2 1/1] nouveau: ratelimit IRQ messages
Message-ID: <20101004162441.GA2823@joi.lan>
References: <1286197890-23227-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286197890-23227-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 03:11:30PM +0200, Jiri Slaby wrote:
> There are two messages in the ISR of nouveau which might be printed out
> hundred times in a second. Ratelimit them. (We need to move
> nouveau_ratelimit to the top of the file.)
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Marcin Slusarz <marcin.slusarz@gmail.com>

FWIW
Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>

> ---
>  drivers/gpu/drm/nouveau/nouveau_irq.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
> index 794b0ee..5b097b4 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_irq.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
> @@ -41,6 +41,13 @@
>  #include "nouveau_connector.h"
>  #include "nv50_display.h"
>  
> +static DEFINE_RATELIMIT_STATE(nouveau_ratelimit_state, 3 * HZ, 20);
> +
> +static int nouveau_ratelimit(void)
> +{
> +	return __ratelimit(&nouveau_ratelimit_state);
> +}
> +
>  void
>  nouveau_irq_preinstall(struct drm_device *dev)
>  {
> @@ -200,7 +207,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
>  		}
>  
>  		if (status & NV_PFIFO_INTR_DMA_PUSHER) {
> -			NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d\n", chid);
> +			if (nouveau_ratelimit())
> +				NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d\n",
> +						chid);
>  
>  			status &= ~NV_PFIFO_INTR_DMA_PUSHER;
>  			nv_wr32(dev, NV03_PFIFO_INTR_0,
> @@ -227,8 +236,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
>  		}
>  
>  		if (status) {
> -			NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
> -				status, chid);
> +			if (nouveau_ratelimit())
> +				NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
> +					status, chid);
>  			nv_wr32(dev, NV03_PFIFO_INTR_0, status);
>  			status = 0;
>  		}
> @@ -505,13 +515,6 @@ nouveau_pgraph_intr_notify(struct drm_device *dev, uint32_t nsource)
>  		nouveau_graph_dump_trap_info(dev, "PGRAPH_NOTIFY", &trap);
>  }
>  
> -static DEFINE_RATELIMIT_STATE(nouveau_ratelimit_state, 3 * HZ, 20);
> -
> -static int nouveau_ratelimit(void)
> -{
> -	return __ratelimit(&nouveau_ratelimit_state);
> -}
> -
>  
>  static inline void
>  nouveau_pgraph_intr_error(struct drm_device *dev, uint32_t nsource)
> -- 
> 1.7.3.1
> 
> 
