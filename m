Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1HEH62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:58:28 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53928 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1HEH61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:58:27 -0400
Date: Fri, 5 Aug 2011 08:58:21 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        ccross@android.com, olof@lixom.net, alsa-devel@alsa-project.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Message-ID: <20110805075821.GD28651@trinity.fluff.org>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com> <1312498820-2275-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312498820-2275-2-git-send-email-swarren@nvidia.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 05:00:18PM -0600, Stephen Warren wrote:
> Many IRQs are associated with GPIO pins. When the pin is used as an IRQ,
> it can't be used as anything else; it should be requested. Enhance the
> core interrupt code to call gpio_request() and gpio_direction_input() for
> any IRQ that is also a GPIO. This prevents duplication of these calls in
> each driver that uses an IRQ.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  kernel/irq/manage.c |   23 +++++++++++++++++++++--
>  1 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 0a7840a..6e2db72 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -7,6 +7,7 @@
>   * This file contains driver APIs to the irq subsystem.
>   */
>  
> +#include <linux/gpio.h>
>  #include <linux/irq.h>
>  #include <linux/kthread.h>
>  #include <linux/module.h>
> @@ -875,7 +876,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  	struct irqaction *old, **old_ptr;
>  	const char *old_name = NULL;
>  	unsigned long flags, thread_mask = 0;
> -	int ret, nested, shared = 0;
> +	int ret, nested, shared = 0, gpio = -1;
>  	cpumask_var_t mask;
>  
>  	if (!desc)
> @@ -978,6 +979,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  			old = *old_ptr;
>  		} while (old);
>  		shared = 1;
> +	} else {
> +		gpio = irq_to_gpio(irq);
> +		if (gpio_is_valid(gpio)) {
> +			ret = gpio_request(gpio, new->name);
> +			if (ret < 0)
> +				goto out_mask;
> +			ret = gpio_direction_input(gpio);
> +			if (ret < 0)
> +				goto out_mask;
> +		}

First,y gpio_direction_input() is an action specific to the implementation
and would break on the s3c24xx series as the irq mode is also part of the
gpio i/o/sfn configuration

Secondly, you are going to have to go through all the soc code and fixup
the missing or bad implmenetations of irq_to_gpio() as a number of SoCs
are not implemented or worse are so badly implemented you will get valid
results for non-gpio interrupts.

>  	}
>  
>  	/*
> @@ -1083,6 +1094,8 @@ mismatch:
>  	ret = -EBUSY;
>  
>  out_mask:
> +	if (gpio_is_valid(gpio))
> +		gpio_free(gpio);
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  	free_cpumask_var(mask);
>  
> @@ -1127,6 +1140,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	struct irqaction *action, **action_ptr;
>  	unsigned long flags;
> +	int gpio;
>  
>  	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
>  
> @@ -1165,8 +1179,13 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
>  #endif
>  
>  	/* If this was the last handler, shut down the IRQ line: */
> -	if (!desc->action)
> +	if (!desc->action) {
>  		irq_shutdown(desc);
> +		/* If the IRQ line is a GPIO, it's no longer in use */
> +		gpio = irq_to_gpio(irq);
> +		if (gpio_is_valid(gpio))
> +			gpio_free(gpio);
> +	}
>  
>  #ifdef CONFIG_SMP
>  	/* make sure affinity_hint is cleaned up */
> -- 
> 1.7.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

