Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1EDDke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:40:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51192 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1EDDk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:40:26 -0400
Date: Tue, 3 May 2011 23:40:23 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Per Forlin <per.forlin@linaro.org>
cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, linaro-dev@lists.linaro.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Subject: Re: [PATCH] sdio: optimized SDIO IRQ handling for single function
In-Reply-To: <1304453087-7365-1-git-send-email-per.forlin@linaro.org>
Message-ID: <alpine.LFD.2.00.1105032339370.24613@xanadu.home>
References: <1304453087-7365-1-git-send-email-per.forlin@linaro.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011, Per Forlin wrote:

> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
> 
> If there is only 1 function registered, and IRQ:s are supported and
> currently enabled, call the callback handler directly
> without checking the CCCR registers.
> 
> Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

> ---
>  drivers/mmc/core/sdio_irq.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> index b300161..25291bf 100644
> --- a/drivers/mmc/core/sdio_irq.c
> +++ b/drivers/mmc/core/sdio_irq.c
> @@ -32,6 +32,20 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>  	int i, ret, count;
>  	unsigned char pending;
>  
> +	/*
> +	 * If there is only 1 function registered
> +	 * call irq directly without checking the CCCR registers.
> +	 */
> +	if ((card->host->caps & MMC_CAP_SDIO_IRQ) &&
> +	    card->host->sdio_irqs && (card->sdio_funcs == 1))
> +		for (i = 0; i < SDIO_MAX_FUNCS; i++) {
> +			struct sdio_func *func = card->sdio_func[i];
> +			if (func && func->irq_handler) {
> +				func->irq_handler(func);
> +				return 1;
> +			}
> +		}
> +
>  	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
>  	if (ret) {
>  		printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
> 
