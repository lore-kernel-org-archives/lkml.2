Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1IUQ0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:26:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35763 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1IUQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:25:59 -0400
Date: Wed, 21 Sep 2011 10:25:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH] gpio/mxc: add chained_irq_enter/exit() to
 mx3_gpio_irq_handler()
Message-ID: <20110921162555.GX7781@ponder.secretlab.ca>
References: <1316611444-14126-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316611444-14126-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 09:24:04PM +0800, Shawn Guo wrote:
> The mx3_gpio_irq_handler() is also called on imx6q which has GIC as
> the primary interrupt controller.  As GIC implements the fasteoi flow
> control, we need to add chained_irq_enter/exit() to
> mx3_gpio_irq_handler() for signaling EOI, otherwise system will hang
> whenever there is a gpio irq triggered.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
> This is the second post of '[PATCH] gpio/mxc: make it work with imx6q'
> to adopt the point given by Jamie.

Nit: don't forget to include the patch version in the subject line, and I like to see the revision history appear before the s-o-b lines so that it makes it into the final commit.

I'll merge this one, thanks.
g.

> 
>  drivers/gpio/gpio-mxc.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> index 4340aca..82f7b65 100644
> --- a/drivers/gpio/gpio-mxc.c
> +++ b/drivers/gpio/gpio-mxc.c
> @@ -30,6 +30,7 @@
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <asm-generic/bug.h>
> +#include <asm/mach/irq.h>
>  
>  enum mxc_gpio_hwtype {
>  	IMX1_GPIO,	/* runs on i.mx1 */
> @@ -232,10 +233,15 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>  {
>  	u32 irq_stat;
>  	struct mxc_gpio_port *port = irq_get_handler_data(irq);
> +	struct irq_chip *chip = irq_get_chip(irq);
> +
> +	chained_irq_enter(chip, desc);
>  
>  	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
>  
>  	mxc_gpio_irq_handler(port, irq_stat);
> +
> +	chained_irq_exit(chip, desc);
>  }
>  
>  /* MX2 has one interrupt *for all* gpio ports */
> -- 
> 1.7.4.1
> 
> 
