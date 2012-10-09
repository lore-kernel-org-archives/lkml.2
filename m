Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2JIQbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:31:31 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56017 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2JIQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <201210091535.56487.arnd@arndb.de>
References: <201210091535.56487.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 10 Oct 2012 00:31:07 +0800
Message-ID: <CAGsJ_4xemz4EBdWPDrdkhD5HsCXJcO_kkKGugEa9C7_rieyq8A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: remove sirfsoc_gpio_set_pull function
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

2012/10/9 Arnd Bergmann <arnd@arndb.de>:
> The prima2 platform advertises needing no mach/gpio.h header file,
> but its pinctrl driver now has a sirfsoc_gpio_set_pull function
> that uses constants defined in arch/arm/mach-prima2/include/mach/gpio.h,
> which fails to build.
>
> Fortunately, the sirfsoc_gpio_set_pull is not used anywhere in the
> kernel, so we can safely remove it. Any out of tree drivers using
> it will have to be converted to use proper pinctrl functions to
> do the same.
>

i understand we want to delete the mach/gpio.h. originally we had
sirfsoc_gpio_set_pull() as a prima2 customized pull config function.

i will take care moving to the dt mapping for pullup/down/none.


> Without this patch, building prima2_defconfig results in:
>
> drivers/pinctrl/pinctrl-sirf.c: In function 'sirfsoc_gpio_set_pull':
> drivers/pinctrl/pinctrl-sirf.c:1331:7: error: 'SIRFSOC_GPIO_PULL_NONE' undeclared (first use in this function)
> drivers/pinctrl/pinctrl-sirf.c:1331:7: note: each undeclared identifier is reported only once for each function it appears in
> drivers/pinctrl/pinctrl-sirf.c:1334:7: error: 'SIRFSOC_GPIO_PULL_UP' undeclared (first use in this function)
> drivers/pinctrl/pinctrl-sirf.c:1338:7: error: 'SIRFSOC_GPIO_PULL_DOWN' undeclared (first use in this function)
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Barry Song <Baohua.Song@csr.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Barry Song <Baohua.Song@csr.com>

>
> diff --git a/arch/arm/mach-prima2/include/mach/gpio.h b/arch/arm/mach-prima2/include/mach/gpio.h
> deleted file mode 100644
> index 1904bb0..0000000
> --- a/arch/arm/mach-prima2/include/mach/gpio.h
> +++ /dev/null
> @@ -1,13 +0,0 @@
> -#ifndef __MACH_GPIO_H
> -#define __MACH_GPIO_H
> -
> -/* Pull up/down values */
> -enum sirfsoc_gpio_pull {
> -       SIRFSOC_GPIO_PULL_NONE,
> -       SIRFSOC_GPIO_PULL_UP,
> -       SIRFSOC_GPIO_PULL_DOWN,
> -};
> -
> -void sirfsoc_gpio_set_pull(unsigned gpio, unsigned mode);
> -
> -#endif
> diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
> index 675497c..9ecacf3 100644
> --- a/drivers/pinctrl/pinctrl-sirf.c
> +++ b/drivers/pinctrl/pinctrl-sirf.c
> @@ -1323,41 +1323,6 @@ static inline struct sirfsoc_gpio_bank *sirfsoc_gpio_to_bank(unsigned int gpio)
>         return &sgpio_bank[gpio / SIRFSOC_GPIO_BANK_SIZE];
>  }
>
> -void sirfsoc_gpio_set_pull(unsigned gpio, unsigned mode)
> -{
> -       struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(gpio);
> -       int idx = sirfsoc_gpio_to_offset(gpio);
> -       u32 val, offset;
> -       unsigned long flags;
> -
> -       offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
> -
> -       spin_lock_irqsave(&sgpio_lock, flags);
> -
> -       val = readl(bank->chip.regs + offset);
> -
> -       switch (mode) {
> -       case SIRFSOC_GPIO_PULL_NONE:
> -               val &= ~SIRFSOC_GPIO_CTL_PULL_MASK;
> -               break;
> -       case SIRFSOC_GPIO_PULL_UP:
> -               val |= SIRFSOC_GPIO_CTL_PULL_MASK;
> -               val |= SIRFSOC_GPIO_CTL_PULL_HIGH;
> -               break;
> -       case SIRFSOC_GPIO_PULL_DOWN:
> -               val |= SIRFSOC_GPIO_CTL_PULL_MASK;
> -               val &= ~SIRFSOC_GPIO_CTL_PULL_HIGH;
> -               break;
> -       default:
> -               break;
> -       }
> -
> -       writel(val, bank->chip.regs + offset);
> -
> -       spin_unlock_irqrestore(&sgpio_lock, flags);
> -}
> -EXPORT_SYMBOL(sirfsoc_gpio_set_pull);
> -
>  static inline struct sirfsoc_gpio_bank *sirfsoc_irqchip_to_bank(struct gpio_chip *chip)
>  {
>         return container_of(to_of_mm_gpio_chip(chip), struct sirfsoc_gpio_bank, chip);

-barry
