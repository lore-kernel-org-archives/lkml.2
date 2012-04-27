Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2D0KwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 06:52:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44162 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607Ab2D0KwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 06:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <1335521331-16199-1-git-send-email-dbaryshkov@gmail.com>
References: <1335521331-16199-1-git-send-email-dbaryshkov@gmail.com>
Date: Fri, 27 Apr 2012 12:52:19 +0200
Message-ID: <CACRpkdZbr9CvCWx_a2Cf1MiJE_FDLQM4qipqRbnTRw+jM8U7gA@mail.gmail.com>
Subject: Re: [PATCH] gpio: add a driver for GPIO pins found on AMD-8111 south
 bridge chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:08 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:

> Add a driver to use GPIO pins available on several AMD south bridges
> (currently only AMD 8111 is supported).
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Mainly nitpicks, it's looking good overall...

> +       spin_lock_irqsave(&agp->lock, flags);
> +       temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> +       temp = (temp & 0x1c) | (!!value);

This is a bit idomatic but I think I understand what's going on. However this
0x1C magic could be better of with some #define AMD_8111_GPIO_FOO don't
you think?

> +static int amd_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct amd_gpio *agp = to_agp(chip);
> +       u8 temp;
> +
> +       temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> +
> +       dev_dbg(&agp->pdev->dev, "Getting gpio %d, reg=%02x\n", offset, temp);
> +
> +       return !!(temp & 0x20);

And this could be #define AMD_8111_GPIO_INVAL or so (I bet this bit has a
name in the datasheet, right?)

> +static int amd_gpio_dirout(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +       struct amd_gpio *agp = to_agp(chip);
> +       u8 temp;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&agp->lock, flags);
> +       temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> +       temp = (temp & 0x10) | 0x4 | (!!value);

And so on...

> +       iowrite8(temp, agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> +       spin_unlock_irqrestore(&agp->lock, flags);
> +
> +       dev_dbg(&agp->pdev->dev, "Dirout gpio %d, value %d, reg=%02x\n", offset, !!value, temp);
> +
> +       return 0;
> +}

> +static int __init mod_init(void)

amd_gpio_init() maybe? These names are nice for e.g. ftrace.

> +       printk(KERN_INFO "AMD-8111 GPIO detected\n");

pr_info() & friends are nice shorthands for this.

> +static void __exit mod_exit(void)

amd_gpio_mod_exit()?

> +MODULE_AUTHOR("The Linux Kernel team");

Don't be shy, put in your own name :-)

Yours,
Linus Walleij
