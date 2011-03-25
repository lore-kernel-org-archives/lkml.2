Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1CYVD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:03:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:39414 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab1CYVD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:03:27 -0400
Date: Fri, 25 Mar 2011 22:03:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 17/23] arm: at91: Cleanup irq chip
In-Reply-To: <20110325132048.996818347@linutronix.de>
Message-ID: <alpine.LFD.2.00.1103252202440.31464@localhost6.localdomain6>
References: <20110325131617.258789658@linutronix.de> <20110325132048.996818347@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Thomas Gleixner wrote:

> Avoid the whole lazy disable dance in the demux handler by providing a
> irq_disable() callback.
> 
> Use the proper accessor functions and tidy up gpio_irq_handler()
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/arm/mach-at91/gpio.c |   31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
> +++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
> @@ -375,6 +375,7 @@ static int gpio_irq_type(struct irq_data
>  
>  static struct irq_chip gpio_irqchip = {
>  	.name		= "GPIO",
> +	.irq_disable	= gpio_irq_mask,
>  	.irq_mask	= gpio_irq_mask,
>  	.irq_unmask	= gpio_irq_unmask,
>  	.irq_set_type	= gpio_irq_type,
> @@ -384,16 +385,14 @@ static struct irq_chip gpio_irqchip = {
>  static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
>  {
>  	unsigned	pin;
> -	struct irq_desc	*gpio;
> -	struct at91_gpio_chip *at91_gpio;
> -	void __iomem	*pio;
> +	struct irq_data *idata = irq_desc_get_irq_data(desc);
> +	struct irq_chip *chip = irq_data_get_chip(data);
> +	struct at91_gpio_chip *at91_gpio = irq_data_get_chip_data(data);

Sorry, needs to be

+	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(data);

Will fix and resend.

Thanks,

	tglx
