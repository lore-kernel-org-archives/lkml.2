Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2AaVbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:31:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57725 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2AaVbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:31:09 -0500
MIME-Version: 1.0
In-Reply-To: <1327999512-4935-1-git-send-email-ldewangan@nvidia.com>
References: <1327999512-4935-1-git-send-email-ldewangan@nvidia.com>
Date: Tue, 31 Jan 2012 22:31:08 +0100
Message-ID: <CACRpkdZ-1VBkZN71eFqaxVi5dakP4Dt3yXLa9TTdrKE=dGq__w@mail.gmail.com>
Subject: Re: [PATCH V1] gpio: tps65910: Add sleep control support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 9:45 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The device tps65910/tps65911 supports the sleep
> functionality in some of gpios. If gpio is configured
> in output mode and sleep is enabled then during device
> sleep state, the output of gpio becomes LOW regardless
> of non-sleep output value.
> Such gpio can be used to control regulator switch such
> that output of regulator is off in device sleep state.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Strictly speaking this is pin control business, but since it is already
doing other stuff like this from platform data why not...

Comments:

> diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
> index fa6c6bf..b641690 100644
> --- a/include/linux/mfd/tps65910.h
> +++ b/include/linux/mfd/tps65910.h
> @@ -657,6 +657,8 @@
>
>
>  /*Register GPIO  (0x80) register.RegisterDescription */
> +#define GPIO_SLEEP_MASK                         0x80
> +#define GPIO_SLEEP_SHIFT                        7
>  #define GPIO_DEB_MASK                           0x10
>  #define GPIO_DEB_SHIFT                          4
>  #define GPIO_PUEN_MASK                          0x08
> @@ -740,6 +742,9 @@
>  #define TPS65910_GPIO_STS                              BIT(1)
>  #define TPS65910_GPIO_SET                              BIT(0)
>
> +/* Max number of TPS65910/11 GPIOs */
> +#define TPS65911_NUM_GPIO                              9

Then name it TPS_6591X_MAX_NUM_GPIO

I would write:

#define TPS65910_NUM_GPIO 6
#define TPS65911_NUM_GPIO 9
#define TPS6591X_MAX_NUM_GPIO 9

And then also refactor this code in the driver:

        switch(tps65910_chip_id(tps65910)) {
        case TPS65910:
                tps65910->gpio.ngpio    = 6;
                break;
        case TPS65911:
                tps65910->gpio.ngpio    = 9;
                break;
        default:
                return;

to use the new defines instead of magic numbers while
you're at it.

> +
>  /* Regulator Index Definitions */
>  #define TPS65910_REG_VRTC                              0
>  #define TPS65910_REG_VIO                               1
> @@ -786,6 +791,7 @@ struct tps65910_board {
>        int irq_base;
>        int vmbch_threshold;
>        int vmbch2_threshold;
> +       int en_gpio_sleep[TPS65911_NUM_GPIO];

This is used as a bool so use bool.

>        unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
>        struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
>  };
> --
> 1.7.1.1

Thanks,
Linus Walleij
