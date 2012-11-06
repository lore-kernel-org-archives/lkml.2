Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2KFQvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:51:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2KFQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:51:21 -0500
Message-ID: <1352220633.25250.0.camel@dcbw.foobar.com>
Subject: Re: [PATCH] add Marvell 88W8688 support to libertas_sdio
From: Dan Williams <dcbw@redhat.com>
To: Harro Haan <hrhaan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Siddarth Gore <gores@marvell.com>
Date: Tue, 06 Nov 2012 10:50:33 -0600
In-Reply-To: <1351722266-9304-1-git-send-email-hrhaan@gmail.com>
References: <1351722266-9304-1-git-send-email-hrhaan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 23:24 +0100, Harro Haan wrote:
> This chip is for example used in the GuruPlug.
> This patch avoids the following error:
> libertas_sdio: failed to load firmware
> libertas_sdio: probe of mmc0:0001:1 failed with error -5
> 
> The fix is based on code in:
> drivers/net/wireless/libertas_uap/uap_sdio_mmc.c
> 
> This file can for example be found on the following links:
> http://www.xilka.com/sheeva/2.6/2.6.36/2.6.36.2/source/0002-Driver-for-Marvell-Libertas-8688-SDIO-micro-AP-suppo-2.6.35.patch
> http://www.downloadsnewit.co.uk/kernel-v3.0.7/
> 
> I followed the following wiki to setup a working WiFi client mode
> connection on the GuruPlug:
> http://wiki.debian.org/libertas
> 
> Signed-off-by: Harro Haan <hrhaan@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |   39 ++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> Index: linux.git/drivers/net/wireless/libertas/if_sdio.c
> ===================================================================
> --- linux.git.orig/drivers/net/wireless/libertas/if_sdio.c
> +++ linux.git/drivers/net/wireless/libertas/if_sdio.c
> @@ -588,17 +588,38 @@ static int if_sdio_prog_real(struct if_s
>  	size = fw->size;
>  
>  	while (size) {
> -		ret = if_sdio_wait_status(card, FW_DL_READY_STATUS);
> -		if (ret)
> -			goto release;
> +		timeout = jiffies + HZ;
> +		while (1) {
> +			ret = if_sdio_wait_status(card, FW_DL_READY_STATUS);
> +			if (ret)
> +				goto release;
>  
> -		req_size = sdio_readb(card->func, IF_SDIO_RD_BASE, &ret);
> -		if (ret)
> -			goto release;
> +			req_size = sdio_readb(card->func, IF_SDIO_RD_BASE,
> +					&ret);
> +			if (ret)
> +				goto release;
> +
> +			req_size |= sdio_readb(card->func, IF_SDIO_RD_BASE + 1,
> +					&ret) << 8;
> +			if (ret)
> +				goto release;
> +
> +			/*
> +			 * For SD8688 wait until the length is not 0, 1 or 2
> +			 * before downloading the first FW block,
> +			 * since BOOT code writes the register to indicate the
> +			 * helper/FW download winner,
> +			 * the value could be 1 or 2 (Func1 or Func2).
> +			 */
> +			if ((size != fw->size) || (req_size > 2))
> +				break;
> +			if (time_after(jiffies, timeout)) {
> +				ret = -ETIMEDOUT;
> +				goto release;
> +			}
> +			mdelay(1);
> +		}
>  
> -		req_size |= sdio_readb(card->func, IF_SDIO_RD_BASE + 1, &ret) << 8;
> -		if (ret)
> -			goto release;
>  /*
>  		lbs_deb_sdio("firmware wants %d bytes\n", (int)req_size);
>  */
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev


