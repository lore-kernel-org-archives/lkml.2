Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1KQUbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:31:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab1KQUbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:31:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@st.com>
Subject: Re: [PATCH] GPIO/pl061: Add suspend resume capability
Date: Thu, 17 Nov 2011 21:34:31 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: baruch@tkos.co.il, grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
References: <6c6957c60969ac5df8bfe59a2502a4077284d2e1.1321528179.git.viresh.kumar@st.com>
In-Reply-To: <6c6957c60969ac5df8bfe59a2502a4077284d2e1.1321528179.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111172134.31591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 17, 2011, Viresh Kumar wrote:
> From: Deepak Sikri <deepak.sikri@st.com>
> 
> This patch adds the suspend and resume operations in the driver. The patch
> ensures the data save and restore for the device registers during the
> suspend and resume operations respectively.
> 
> Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
> ---
>  drivers/gpio/gpio-pl061.c |   73 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 73 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
> index 093c90b..d64dc1c 100644
> --- a/drivers/gpio/gpio-pl061.c
> +++ b/drivers/gpio/gpio-pl061.c
> @@ -23,6 +23,7 @@
>  #include <linux/amba/bus.h>
>  #include <linux/amba/pl061.h>
>  #include <linux/slab.h>
> +#include <linux/pm.h>
>  
>  #define GPIODIR 0x400
>  #define GPIOIS  0x404
> @@ -35,6 +36,17 @@
>  
>  #define PL061_GPIO_NR	8
>  
> +#ifdef CONFIG_PM
> +struct gpio_context_save_regs {
> +	u8 gpio_data;
> +	u8 gpio_dir;
> +	u8 gpio_is;
> +	u8 gpio_ibe;
> +	u8 gpio_iev;
> +	u8 gpio_ie;
> +};
> +#endif
> +
>  struct pl061_gpio {
>  	/* We use a list of pl061_gpio structs for each trigger IRQ in the main
>  	 * interrupts controller of the system. We need this to support systems
> @@ -54,6 +66,10 @@ struct pl061_gpio {
>  	void __iomem		*base;
>  	unsigned		irq_base;
>  	struct gpio_chip	gc;
> +
> +#ifdef CONFIG_PM
> +	struct gpio_context_save_regs	csave_regs;
> +#endif
>  };
>  
>  static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
> @@ -330,6 +346,8 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  		irq_set_chip_data(i + chip->irq_base, chip);
>  	}
>  
> +	amba_set_drvdata(dev, chip);
> +
>  	return 0;
>  
>  iounmap:
> @@ -342,6 +360,60 @@ free_mem:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_PM
> +static int pl061_suspend(struct device *dev)
> +{
> +	struct pl061_gpio *chip = dev_get_drvdata(dev);
> +	int offset;
> +
> +	chip->csave_regs.gpio_data = 0;
> +	chip->csave_regs.gpio_dir = readb(chip->base + GPIODIR);
> +	chip->csave_regs.gpio_is = readb(chip->base + GPIOIS);
> +	chip->csave_regs.gpio_ibe = readb(chip->base + GPIOIBE);
> +	chip->csave_regs.gpio_iev = readb(chip->base + GPIOIEV);
> +	chip->csave_regs.gpio_ie = readb(chip->base + GPIOIE);
> +
> +	for (offset = 0; offset < PL061_GPIO_NR; offset++) {
> +		if (chip->csave_regs.gpio_dir & (1 << offset))
> +			chip->csave_regs.gpio_data |=
> +				pl061_get_value(&chip->gc, offset) << offset;
> +	}
> +
> +	return 0;
> +}
> +
> +static int pl061_resume(struct device *dev)
> +{
> +	struct pl061_gpio *chip = dev_get_drvdata(dev);
> +	int offset;
> +
> +	for (offset = 0; offset < PL061_GPIO_NR; offset++) {
> +		if (chip->csave_regs.gpio_dir & (1 << offset))
> +			pl061_direction_output(&chip->gc, offset,
> +					chip->csave_regs.gpio_data &
> +					(1 << offset));
> +		else
> +			pl061_direction_input(&chip->gc, offset);
> +	}
> +
> +	writeb(chip->csave_regs.gpio_is, chip->base + GPIOIS);
> +	writeb(chip->csave_regs.gpio_ibe, chip->base + GPIOIBE);
> +	writeb(chip->csave_regs.gpio_iev, chip->base + GPIOIEV);
> +	writeb(chip->csave_regs.gpio_ie, chip->base + GPIOIE);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops pl061_dev_pm_ops = {
> +	.suspend = pl061_suspend,
> +	.resume = pl061_resume,

Please also include hibernation callbacks here, otherwise your code will
break systems with hibernation enabled.

There are convenience macros for that in linux/pm.h, please use one of them.

Thanks,
Rafael


> +};
> +
> +#define PL061_DEV_PM_OPS (&pl061_dev_pm_ops)
> +#else
> +#define PL061_DEV_PM_OPS NULL
> +#endif
> +
>  static struct amba_id pl061_ids[] = {
>  	{
>  		.id	= 0x00041061,
> @@ -353,6 +425,7 @@ static struct amba_id pl061_ids[] = {
>  static struct amba_driver pl061_gpio_driver = {
>  	.drv = {
>  		.name	= "pl061_gpio",
> +		.pm	= PL061_DEV_PM_OPS,
>  	},
>  	.id_table	= pl061_ids,
>  	.probe		= pl061_probe,
> 

