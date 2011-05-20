Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565Ab1ETLZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:25:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55157 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934707Ab1ETLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:24:59 -0400
Date: Fri, 20 May 2011 13:24:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH 4/4] gpio: gpio-mxs: add gpio driver for Freescale MXS
 architecture
Message-ID: <20110520112455.GB10403@pengutronix.de>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
 <1305885089-27343-5-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305885089-27343-5-git-send-email-shawn.guo@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:19:57 up  5:00,  6 users,  load average: 0.09, 0.06, 0.02
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 05:51:29PM +0800, Shawn Guo wrote:
> Add gpio-mxs driver by moving arch/arm/mach-mxs/gpio.c into
> drivers/gpio.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/gpio/Kconfig    |    3 +
>  drivers/gpio/Makefile   |    1 +
>  drivers/gpio/gpio-mxs.c |  168 ++++++++++++++++++++++++++++++++++-------------
>  3 files changed, 125 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d3b2953..ccca658 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -81,6 +81,9 @@ config GPIO_IT8761E
>  	help
>  	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
>  
> +config GPIO_MXS
> +	bool
> +
>  config GPIO_PL061
>  	bool "PrimeCell PL061 GPIO support"
>  	depends on ARM_AMBA
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index becef59..b06a335 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
>  obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
>  obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
>  obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
> +obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
>  obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
>  obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
>  obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> index 6a59bf2..b33b2bc 100644
> --- a/drivers/gpio/gpio-mxs.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -25,14 +25,18 @@
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/gpio.h>
> -#include <mach/mx23.h>
> -#include <mach/mx28.h>
> -#include <asm-generic/bug.h>
> -
> -#include "gpio.h"
> -
> -static struct mxs_gpio_port *mxs_gpio_ports;
> -static int gpio_table_size;
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <mach/mxs.h>
> +
> +struct mxs_gpio_port {
> +	void __iomem *base;
> +	int id;
> +	int irq;
> +	int irq_high;
> +	int virtual_irq_start;
> +	struct gpio_chip chip;
> +};
>  
>  #define MXS_SET		0x4
>  #define MXS_CLR		0x8
> @@ -76,20 +80,23 @@ static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
>  
>  static void mxs_gpio_ack_irq(struct irq_data *d)
>  {
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	u32 gpio = irq_to_gpio(d->irq);
> -	clear_gpio_irqstatus(&mxs_gpio_ports[gpio / 32], gpio & 0x1f);
> +	clear_gpio_irqstatus(port, gpio & 0x1f);
>  }
>  
>  static void mxs_gpio_mask_irq(struct irq_data *d)
>  {
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	u32 gpio = irq_to_gpio(d->irq);
> -	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 0);
> +	set_gpio_irqenable(port, gpio & 0x1f, 0);
>  }
>  
>  static void mxs_gpio_unmask_irq(struct irq_data *d)
>  {
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	u32 gpio = irq_to_gpio(d->irq);
> -	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 1);
> +	set_gpio_irqenable(port, gpio & 0x1f, 1);
>  }
>  
>  static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset);
> @@ -98,7 +105,7 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
>  {
>  	u32 gpio = irq_to_gpio(d->irq);
>  	u32 pin_mask = 1 << (gpio & 31);
> -	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	void __iomem *pin_addr;
>  	int edge;
>  
> @@ -142,7 +149,7 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
>  static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>  {
>  	u32 irq_stat;
> -	struct mxs_gpio_port *port = (struct mxs_gpio_port *)irq_get_handler_data(irq);
> +	struct mxs_gpio_port *port = irq_get_handler_data(irq);
>  	u32 gpio_irq_no_base = port->virtual_irq_start;
>  
>  	desc->irq_data.chip->irq_ack(&desc->irq_data);
> @@ -170,7 +177,7 @@ static int mxs_gpio_set_wake_irq(struct irq_data *d, unsigned int enable)
>  {
>  	u32 gpio = irq_to_gpio(d->irq);
>  	u32 gpio_idx = gpio & 0x1f;
> -	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  
>  	if (enable) {
>  		if (port->irq_high && (gpio_idx >= 16))
> @@ -251,47 +258,114 @@ static int mxs_gpio_direction_output(struct gpio_chip *chip,
>  	return 0;
>  }
>  
> -int __init mxs_gpio_init(struct mxs_gpio_port *port, int cnt)
> +static int __devinit mxs_gpio_probe(struct platform_device *pdev)
>  {
> -	int i, j;
> +	static void __iomem *base;
> +	struct mxs_gpio_port *port;
> +	struct resource *iores = NULL;
> +	int err, i;
> +
> +	port = kzalloc(sizeof(struct mxs_gpio_port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +
> +	port->id = pdev->id;
> +	port->virtual_irq_start = MXS_GPIO_IRQ_START + port->id * 32;
> +
> +	/*
> +	 * map memory region only once, as all the gpio ports
> +	 * share the same one
> +	 */
> +	if (!base) {

If the different ports share the same address and can't be seperated I
wonder whether it's better to register only one platform device for all
ports.
(classic) i.MX has a similar problem where one single interrupt is
shared by all gpio ports. Ok, this could be worked around with another
chained handler which dispatches the single interrupt to each port.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
