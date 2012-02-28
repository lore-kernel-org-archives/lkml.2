Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2B1ALf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:11:35 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:48902 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297Ab2B1ALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:11:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of khilman@ti.com designates 10.68.136.231 as permitted sender) smtp.mail=khilman@ti.com
From: Kevin Hilman <khilman@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: <linux-omap@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] gpio/omap: fix _set_gpio_irqenable implementation
Organization: Texas Instruments, Inc.
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
	<1329999031-6914-7-git-send-email-tarun.kanti@ti.com>
Date: Mon, 27 Feb 2012 16:11:31 -0800
In-Reply-To: <1329999031-6914-7-git-send-email-tarun.kanti@ti.com> (Tarun
	Kanti DebBarma's message of "Thu, 23 Feb 2012 17:40:31 +0530")
Message-ID: <877gz7u898.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarun Kanti DebBarma <tarun.kanti@ti.com> writes:

> This function should be capable of both enabling and disabling interrupts
> based upon the *enable* parameter. Right now the function only enables
> the interrupt and *enable* is not used at all. So add the interrupt
> disable capability also using the parameter.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Hmm, interesting.

This means that the IRQ mask/unmask stuff is not actually doing anything
since it's always leaving the IRQ enabled.  Curious that we haven't seen
side effects of that.  Maybe since the trigger type is none, the
interrupts won't fire.

In any case, this is a good fix.

Kevin


> ---
>  drivers/gpio/gpio-omap.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 67535c8..acc71a0 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -473,7 +473,10 @@ static void _disable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
>  
>  static inline void _set_gpio_irqenable(struct gpio_bank *bank, int gpio, int enable)
>  {
> -	_enable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
> +	if (enable)
> +		_enable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
> +	else
> +		_disable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
>  }
>  
>  /*
