Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1LNWPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:15:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52243 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1LNWO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:14:58 -0500
Message-ID: <4EE91FDD.5070206@gmail.com>
Date: Wed, 14 Dec 2011 16:14:53 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] irq: fix crash due to op-less irq domains
References: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On 12/14/2011 02:55 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> IRQ domains without ops does not work anymore after commit
> "irq: support domains with non-zero hwirq base", since the
> check dereferences domain->ops->to_irq without checking of
> domain->ops are NULL. This makes U300 (and probably most other
> systems using the PL190 VIC) boot again.

I thought the VIC series had the fix for this, but it seems not. NULL
ops is considered invalid based on the code comments. The correct fix is
this patch:

irqdomain: export irq_domain_simple_ops for !CONFIG_OF
http://www.spinics.net/lists/arm-kernel/msg150290.html

I believe this is going in with some iMX changes. But I guess the VIC is
going to need a fix to use irq_domain_simple_ops.

Rob

> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/irqdomain.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 99834e58..78a1e66 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -74,7 +74,7 @@ struct irq_domain {
>  static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
>  					     unsigned long hwirq)
>  {
> -	if (d->ops->to_irq)
> +	if (d->ops && d->ops->to_irq)
>  		return d->ops->to_irq(d, hwirq);
>  	if (WARN_ON(hwirq < d->hwirq_base))
>  		return 0;
