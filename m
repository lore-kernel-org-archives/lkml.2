Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0JDXkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:40:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0JDXkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:40:35 -0400
Subject: Re: [PATCH v2 1/1] nouveau: ratelimit IRQ messages
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Jiri Slaby <jslaby@suse.cz>
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, jirislaby@gmail.com
In-Reply-To: <1286197890-23227-1-git-send-email-jslaby@suse.cz>
References: <1286197890-23227-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 09:40:06 +1000
Message-ID: <1286235606.3660.4.camel@nisroch>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 15:11 +0200, Jiri Slaby wrote:
> There are two messages in the ISR of nouveau which might be printed out
> hundred times in a second. Ratelimit them. (We need to move
> nouveau_ratelimit to the top of the file.)
Looks good to me.  If you could rebase this on nouveau git
(git.freedesktop.org/git/nouveau/linux-2.6), I'll push it.

Thanks,
Ben.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
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


