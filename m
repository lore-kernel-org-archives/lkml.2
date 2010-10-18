Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0JRHmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:42:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0JRHmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:42:36 -0400
Date: Mon, 18 Oct 2010 09:42:33 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        amit.kucheria@canonical.com, xiao-lizhang@freescale.com
Subject: Re: [PATCH 1/2] ARM: imx: Add wake functionality to GPIO
Message-ID: <20101018074233.GF28242@pengutronix.de>
References: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:39:48 up 106 days, 22:50, 15 users,  load average: 0.27, 0.38,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 15, 2010 at 03:18:27PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add function definition for irq_chip.set_wake to enable GPIO to
> wake-up the system.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/gpio.c              |   35 +++++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/gpio.h |    3 ++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
> index 57ec4a8..7647ba3 100644
> --- a/arch/arm/plat-mxc/gpio.c
> +++ b/arch/arm/plat-mxc/gpio.c
> @@ -20,9 +20,11 @@
>   */
>  
>  #include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/gpio.h>
> +#include <mach/gpio.h>
>  #include <mach/hardware.h>
>  #include <asm-generic/bug.h>
>  
> @@ -201,11 +203,44 @@ static void mx2_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>  	}
>  }
>  
> +/*
> + * Set interrupt number "irq" in the GPIO as a wake-up source.
> + * While system is running, all registered GPIO interrupts need to have
> + * wake-up enabled. When system is suspended, only selected GPIO interrupts
> + * need to have wake-up enabled.
> + * @param  irq          interrupt source number
> + * @param  enable       enable as wake-up if equal to non-zero
> + * @return       This function returns 0 on success.
> + */
> +static int gpio_set_wake_irq(u32 irq, u32 enable)
> +{
> +	u32 gpio = irq_to_gpio(irq);
> +	u32 gpio_idx = gpio & 0x1F;
> +	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
> +
> +	if (enable) {
> +		port->suspend_wakeup |= (1 << gpio_idx);
> +		if (port->irq_high && (gpio_idx >= 16))
> +			enable_irq_wake(port->irq_high);
> +		else
> +			enable_irq_wake(port->irq);
> +	} else {
> +		port->suspend_wakeup &= ~(1 << gpio_idx);
> +		if (port->irq_high && (gpio_idx >= 16))
> +			disable_irq_wake(port->irq_high);
> +		else
> +			disable_irq_wake(port->irq);
> +	}
> +
> +	return 0;
> +}
> +
>  static struct irq_chip gpio_irq_chip = {
>  	.ack = gpio_ack_irq,
>  	.mask = gpio_mask_irq,
>  	.unmask = gpio_unmask_irq,
>  	.set_type = gpio_set_irq_type,
> +	.set_wake = gpio_set_wake_irq,
>  };
>  
>  static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
> diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
> index af33b74..dba3768 100644
> --- a/arch/arm/plat-mxc/include/mach/gpio.h
> +++ b/arch/arm/plat-mxc/include/mach/gpio.h
> @@ -39,6 +39,9 @@ struct mxc_gpio_port {
>  	struct gpio_chip chip;
>  	u32 both_edges;
>  	spinlock_t lock;
> +	u32 suspend_wakeup;

This variable seems unused.

> +	u32 saved_wakeup;
> +
>  };

Please remove that empty line.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
