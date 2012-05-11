Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2EKRlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:41:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34465 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2EKRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:41:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio/msm-v1: re-read IRQ flags on each iteration
To: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1336738032-14940-1-git-send-email-linus.walleij@stericsson.com>
References: <1336738032-14940-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 11 May 2012 11:41:12 -0600
Message-Id: <20120511174112.D9EEE3E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 14:07:12 +0200, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> We have recently found a number or erroneous IRQ handlers in
> the kernel where the flag iterator loop miss IRQs that get
> raised when the loop is executing. This was spotted in the
> MSM v1 GPIO driver by Julia Lawall using this cocinelle
> snippet:
> 
> @@
> expression pending,gedr,e1;
> statement S;
> @@
> 
> *pending = readl(gedr);
> ... when != pending = e1
> while (pending) S
> 
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Linus,

I'll need an ack from an msm developer before applying this.

g.

> ---
>  drivers/gpio/gpio-msm-v1.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
> index 52a4d42..68ca760 100644
> --- a/drivers/gpio/gpio-msm-v1.c
> +++ b/drivers/gpio/gpio-msm-v1.c
> @@ -567,9 +567,9 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
>  
>  	for (i = 0; i < msm_gpio_count; i++) {
>  		struct msm_gpio_chip *msm_chip = &msm_gpio_chips[i];
> -		val = readl(msm_chip->regs.int_status);
> -		val &= msm_chip->int_enable[0];
> -		while (val) {
> +
> +		while (val = (readl(msm_chip->regs.int_status) &
> +			      msm_chip->int_enable[0])) {
>  			mask = val & -val;
>  			j = fls(mask) - 1;
>  			/* printk("%s %08x %08x bit %d gpio %d irq %d\n",
> -- 
> 1.7.9.2
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
