Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1KQNzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:55:32 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:48750 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab1KQNzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:55:32 -0500
Date: Thu, 17 Nov 2011 15:54:34 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
Subject: Re: [PATCH] GPIO/pl061: Add suspend resume capability
Message-ID: <20111117135433.GC3299@sapphire.tkos.co.il>
References: <6c6957c60969ac5df8bfe59a2502a4077284d2e1.1321528179.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6957c60969ac5df8bfe59a2502a4077284d2e1.1321528179.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Nov 17, 2011 at 04:45:35PM +0530, Viresh Kumar wrote:
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

[snip]

> +#ifdef CONFIG_PM
> +struct gpio_context_save_regs {

Nit: I think pl061_context_save_regs is a better name.

Other then that:

Acked-by: Baruch Siach <baruch@tkos.co.il>

baruch

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

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
