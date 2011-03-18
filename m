Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1CRFqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:46:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45034 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1CRFqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:46:34 -0400
Date: Thu, 17 Mar 2011 23:42:03 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: enable expander pca957x
Message-ID: <20110318054203.GG18545@angua.secretlab.ca>
References: <1300421098-12758-1-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300421098-12758-1-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:04:58PM +0800, Haojian Zhuang wrote:
> Support both PCA9574(8-bit) and PCA9575(16-bit) gpio expander.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> ---
>  drivers/gpio/Kconfig        |   14 ++
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/pca957x.c      |  491 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/pca957x.h |   28 +++
>  4 files changed, 534 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/pca957x.c
>  create mode 100644 include/linux/i2c/pca957x.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 7ef9108..28be09a 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -191,6 +191,20 @@ config GPIO_PCA953X_IRQ
>  	  Say yes here to enable the pca953x to be used as an interrupt
>  	  controller. It requires the driver to be built in the kernel.
>  
> +config GPIO_PCA957X
> +	tristate "PCA957x I/O ports"
> +	depends on I2C
> +	help
> +	  Say yes here to provide access several register-oriented
> +	  SMBus I/O expanders. Compatible models include:
> +
> +	  8 bits:	pca9574
> +
> +	  16 bits:	pca9575
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called pca957x
> +
>  config GPIO_PCF857X
>  	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
>  	depends on I2C
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 3351cf8..6d941bd 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
>  obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
>  obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
>  obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
> +obj-$(CONFIG_GPIO_PCA957X)	+= pca957x.o
>  obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
>  obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
>  obj-$(CONFIG_GPIO_PL061)	+= pl061.o
> diff --git a/drivers/gpio/pca957x.c b/drivers/gpio/pca957x.c
> new file mode 100644
> index 0000000..9d8ceb1
> --- /dev/null
> +++ b/drivers/gpio/pca957x.c
> @@ -0,0 +1,491 @@
> +/*
> + *  pca957x.c - 8/16 bit I/O ports
> + *
> + *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
> + *  Copyright (C) 2007 Marvell International Ltd.
> + *
> + *  Derived from drivers/i2c/chips/pca9539.c

It would appear that the driver is well near identical to
drivers/gpio/pca953x.c, except that this version accesses the
registers with a different word width and without the mutex locking.

Why can't the pca957x device be supported by the pca953x driver?

g.
