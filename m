Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab0FOUB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:01:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474Ab0FOUB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:01:56 -0400
Date: Tue, 15 Jun 2010 13:01:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/2 v2] gpio: msm7200a: Add gpiolib support for MSM
 chips.
Message-Id: <20100615130131.bf20833a.akpm@linux-foundation.org>
In-Reply-To: <1276301969-31385-2-git-send-email-gbean@codeaurora.org>
References: <1276301969-31385-1-git-send-email-gbean@codeaurora.org>
	<1276301969-31385-2-git-send-email-gbean@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 17:19:28 -0700
Gregory Bean <gbean@codeaurora.org> wrote:

> Add support for uniprocessor MSM chips whose TLMM/GPIO design
> is the same as the MSM7200A.
> This includes, but is not necessarily limited to, the:
> MSM7200A, MSM7x25, MSM7x27, MSM7x30, QSD8x50, QSD8x50A
> 
>
> ...
>
> +static inline unsigned bit(unsigned offset)
> +{
> +	BUG_ON(offset >= sizeof(unsigned) * 8);
> +	return 1U << offset;
> +}

Could use bitops.h's BIT(), but it hardly matters.

> +/*
> + * This function assumes that msm_gpio_dev::lock is held.
> + */
> +static inline void set_gpio_bit(unsigned n, void __iomem *reg)
> +{
> +	writel(readl(reg) | bit(n), reg);
> +}
> +
> +/*
> + * This function assumes that msm_gpio_dev::lock is held.
> + */
> +static inline void clr_gpio_bit(unsigned n, void __iomem *reg)
> +{
> +	writel(readl(reg) & ~bit(n), reg);
> +}
> +
> +/*
> + * This function assumes that msm_gpio_dev::lock is held.
> + */
> +static inline void
> +msm_gpio_write(struct msm_gpio_dev *dev, unsigned n, unsigned on)
> +{
> +	if (on)
> +		set_gpio_bit(n, dev->regs.out);
> +	else
> +		clr_gpio_bit(n, dev->regs.out);
> +}

Recent gcc's often uninline things whcih were marked inline.  Doesn't
matter much.

>
> ...
>
> +static int gpio_chip_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
> +	unsigned long irq_flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
> +	ret = readl(msm_gpio->regs.in) & bit(offset) ? 1 : 0;
> +	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
> +
> +	return ret;
> +}

The locking here is actually unneeded, I expect.

> +static void gpio_chip_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
> +	msm_gpio_write(msm_gpio, offset, value);
> +	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
> +}
> +
> +static int msm_gpio_probe(struct platform_device *dev)
> +{
> +	struct msm_gpio_dev *msm_gpio;
> +	struct msm7200a_gpio_platform_data *pdata =
> +		(struct msm7200a_gpio_platform_data *)dev->dev.platform_data;

The the typecast of a void* is unneeded and undesirable because it
defeats typechecking.

> +	int ret;
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	msm_gpio = kzalloc(sizeof(struct msm_gpio_dev), GFP_KERNEL);
> +	if (!msm_gpio)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&msm_gpio->lock);
> +	platform_set_drvdata(dev, msm_gpio);
> +	memcpy(&msm_gpio->regs,
> +	       &pdata->regs,
> +	       sizeof(struct msm7200a_gpio_regs));
> +
> +	msm_gpio->gpio_chip.label            = dev->name;
> +	msm_gpio->gpio_chip.base             = pdata->gpio_base;
> +	msm_gpio->gpio_chip.ngpio            = pdata->ngpio;
> +	msm_gpio->gpio_chip.direction_input  = gpio_chip_direction_input;
> +	msm_gpio->gpio_chip.direction_output = gpio_chip_direction_output;
> +	msm_gpio->gpio_chip.get              = gpio_chip_get;
> +	msm_gpio->gpio_chip.set              = gpio_chip_set;
> +
> +	ret = gpiochip_add(&msm_gpio->gpio_chip);
> +	if (ret < 0)
> +		goto err_post_malloc;
> +
> +	return ret;
> +err_post_malloc:
> +	kfree(msm_gpio);

Maybe undo platform_set_drvdata() here?

> +	return ret;
> +}
> +
>
> ...
>

