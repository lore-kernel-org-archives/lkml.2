Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1EDReZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:34:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43986 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1EDReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:34:24 -0400
Date: Wed, 4 May 2011 13:34:21 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Per Forlin <per.forlin@linaro.org>
cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Subject: Re: [PATCH v2] sdio: optimized SDIO IRQ handling for single irq
In-Reply-To: <1304525161-14448-2-git-send-email-per.forlin@linaro.org>
Message-ID: <alpine.LFD.2.00.1105041217380.24613@xanadu.home>
References: <1304525161-14448-1-git-send-email-per.forlin@linaro.org> <1304525161-14448-2-git-send-email-per.forlin@linaro.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Per Forlin wrote:

> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
> 
> If there is only 1 function registered it is possible to
> improve performance by directly calling the irq handler
> and avoiding the overhead of reading the CCCR registers.
> 
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Ulf Hansson <ulf.hansson@stericsson.com>
> ---
>  drivers/mmc/core/sdio_irq.c |   30 ++++++++++++++++++++++++++++++
>  include/linux/mmc/card.h    |    1 +
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> index b300161..64c4409 100644
> --- a/drivers/mmc/core/sdio_irq.c
> +++ b/drivers/mmc/core/sdio_irq.c
> @@ -32,6 +32,16 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>  	int i, ret, count;
>  	unsigned char pending;
>  
> +	/*
> +	 * Optimization, if there is only 1 function registered
> +	 * call irq handler directly
> +	 */
> +	if (card->sdio_single_irq && card->sdio_single_irq->irq_handler) {
> +		struct sdio_func *func = card->sdio_single_irq;
> +		func->irq_handler(func);

I think there is little point using a func variable here, especially 
since you already reference the handler pointer in the if() statement.  
Hence:

	if (card->sdio_single_irq && card->sdio_single_irq->irq_handler) {
		card->sdio_single_irq->irq_handler();
		return 1;
	}

> @@ -186,6 +196,24 @@ static int sdio_card_irq_put(struct mmc_card *card)
>  	return 0;
>  }
>  
> +/* If there is only 1 function registered set sdio_single_irq */
> +static void sdio_single_irq_set(struct mmc_card *card)
> +{

The comment is slightly wrong.  This should say "only 1 function 
interrupt registered..."  Nothing prevents this from working with 
multiple functions if only one of them has claimed an interrupt. 

Other than that:

Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>


Nicolas
