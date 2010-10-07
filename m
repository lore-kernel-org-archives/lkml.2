Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab0JGDmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:42:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab0JGDmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:42:05 -0400
Subject: Re: [PATCH v3 1/1] nouveau: ratelimit IRQ messages
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1286284053-2510-1-git-send-email-jslaby@suse.cz>
References: <1286284053-2510-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:41:35 +1000
Message-ID: <1286422895.2468.2.camel@nisroch>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 15:07 +0200, Jiri Slaby wrote:
> There are two messages in the ISR of nouveau which might be printed out
> hundred times in a second. Ratelimit them. (We need to move
> nouveau_ratelimit to the top of the file.)
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
> 
> 
> Rebased on the top of nouveau git.
Thank you, I've pushed this to nouveau git now.

Ben.
> 
> 
>  drivers/gpu/drm/nouveau/nouveau_irq.c |   26 ++++++++++++++------------
>  1 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
> index 6fd51a5..b9e1ffe 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_irq.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
> @@ -42,6 +42,13 @@
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
> @@ -213,11 +220,12 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
>  				u32 ib_get = nv_rd32(dev, 0x003334);
>  				u32 ib_put = nv_rd32(dev, 0x003330);
>  
> -				NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d Get 0x%02x%08x "
> +				if (nouveau_ratelimit())
> +					NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d Get 0x%02x%08x "
>  					     "Put 0x%02x%08x IbGet 0x%08x IbPut 0x%08x "
>  					     "State 0x%08x Push 0x%08x\n",
> -					chid, ho_get, get, ho_put, put, ib_get, ib_put,
> -					state, push);
> +						chid, ho_get, get, ho_put, put,
> +						ib_get, ib_put, state, push);
>  
>  				/* METHOD_COUNT, in DMA_STATE on earlier chipsets */
>  				nv_wr32(dev, 0x003364, 0x00000000);
> @@ -266,8 +274,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
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
> @@ -544,13 +553,6 @@ nouveau_pgraph_intr_notify(struct drm_device *dev, uint32_t nsource)
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


