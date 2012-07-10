Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2GJLfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:35:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46222 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2GJLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120710064853.GA28840@avionic-0098.adnet.avionic-design.de>
References: <1341862074-9240-1-git-send-email-aletes.xgr@gmail.com>
	<20120710064853.GA28840@avionic-0098.adnet.avionic-design.de>
Date: Tue, 10 Jul 2012 08:35:43 -0300
Message-ID: <CAAAP30FMDmNuSaV66U9aTR9tRJw4Cmo=ksBU91A1oC9Uf29cNg@mail.gmail.com>
Subject: Re: [PATCH] pwm: add lpc32xx pwm support
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 3:48 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Mon, Jul 09, 2012 at 04:27:54PM -0300, Alexandre Pereira da Silva wrote:
>> Add lpc32xx soc pwm driver.
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> ---
>>  .../devicetree/bindings/pwm/lpc32xx-pwm.txt        |   12 ++
>>  drivers/pwm/Kconfig                                |   11 ++
>>  drivers/pwm/Makefile                               |    1 +
>>  drivers/pwm/pwm-lpc32xx.c                          |  151 ++++++++++++++++++++
>>  4 files changed, 175 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>>  create mode 100644 drivers/pwm/pwm-lpc32xx.c
>
> Hi Alexandre,
>
> overall this looks good, just some comments inline. I'd very much
> appreciate an Acked-by from Roland on this.
>
>> diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>> new file mode 100644
>> index 0000000..fb7b3d5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>> @@ -0,0 +1,12 @@
>> +LPC32XX PWM controller
>> +
>> +Required properties:
>> +- compatible: should be "nxp,lpc3220-pwm"
>
> Does the compatible have to be lpc3220-pwm? Can't it be lpc32xx-pwm to
> match the driver and binding names?
>
>> +- reg: physical base address and length of the controller's registers
>> +
>> +Example:
>> +
>> +pwm: pwm@80064000 {
>> +     compatible = "nxp,lpc3220-pwm";
>> +     reg = <0x80064000 2000>;
>
> You probably want to specify the size as 0x2000 as well.

I will copy here the dts for the two pwm controllers this chip has.
This should have been 4 instead.

>> +};
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index 0b2800f..34086b1 100644
>> --- a/drivers/pwm/Kconfig
>> +++ b/drivers/pwm/Kconfig
>> @@ -28,6 +28,17 @@ config PWM_IMX
>>         To compile this driver as a module, choose M here: the module
>>         will be called pwm-imx.
>>
>> +config PWM_LPC32XX
>> +     tristate "LPC32XX PWM support"
>> +     depends on ARCH_LPC32XX
>> +     help
>> +       Generic PWM framework driver for LPC32XX. The LPC32XX soc has two
>> +       pwm channels.
>
> Can we keep the spelling consistent here? It should be "PWM" and "SoC".
> It'd be nice if you could fix that up in the commit message as well.
>
>> +
>> +       To compile this driver as a module, choose M here: the module
>> +       will be called pwm-lpc32xx.
>> +
>> +
>>  config PWM_MXS
>>       tristate "Freescale MXS PWM support"
>>       depends on ARCH_MXS && OF
>> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
>> index cec2500..5459702 100644
>> --- a/drivers/pwm/Makefile
>> +++ b/drivers/pwm/Makefile
>> @@ -1,6 +1,7 @@
>>  obj-$(CONFIG_PWM)            += core.o
>>  obj-$(CONFIG_PWM_BFIN)               += pwm-bfin.o
>>  obj-$(CONFIG_PWM_IMX)                += pwm-imx.o
>> +obj-$(CONFIG_PWM_LPC32XX)    += pwm-lpc32xx.o
>>  obj-$(CONFIG_PWM_MXS)                += pwm-mxs.o
>>  obj-$(CONFIG_PWM_PXA)                += pwm-pxa.o
>>  obj-$(CONFIG_PWM_SAMSUNG)    += pwm-samsung.o
>> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
>> new file mode 100644
>> index 0000000..c7fa126
>> --- /dev/null
>> +++ b/drivers/pwm/pwm-lpc32xx.c
>> @@ -0,0 +1,151 @@
>> +/*
>> + * Copyright 2012 Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pwm.h>
>> +#include <linux/slab.h>
>> +
>> +struct lpc32xx_pwm_chip {
>> +     struct pwm_chip chip;
>> +     struct device *dev;
>
> Can you drop this field? You initialize it, but it is never used
> subsequently in the driver.
>
>> +     struct clk *clk;
>> +     void __iomem *base;
>> +};
>> +
>> +#define PWM_ENABLE (1<<31)
>> +#define PWM_RELOADV(x)       (((x) & 0xFF)<<8)
>> +#define PWM_DUTY(x)  ((x) & 0xFF)
>
> There should be spaces around <<.
>
>> +
>> +#define to_lpc32xx_pwm_chip(_chip) \
>> +     container_of(_chip, struct lpc32xx_pwm_chip, chip)
>> +
>> +static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                       int duty_ns, int period_ns)
>
> The alignment looks wrong here. It seems like you aligned properly
> before adding the "static".
>
>> +{
>> +     struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
>> +     unsigned long long c;
>> +     int period_cycles, duty_cycles;
>> +
>> +     c = clk_get_rate(lpc32xx->clk)/256;
>
> Spaces around /.
>
>> +     c = c * period_ns;
>> +     do_div(c, NSEC_PER_SEC);
>> +
>> +     /* Handle high and low extremes */
>> +     if (c == 0)
>> +             c = 1;
>> +     if (c > 255)
>> +             c = 0; /* 0 set division by 256 */
>> +     period_cycles = c;
>> +
>> +     c = 256*duty_ns;
>
> Spaces around *.
>
>> +     do_div(c, period_ns);
>> +     duty_cycles = c;
>> +
>> +     writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
>> +             lpc32xx->base);
>> +
>> +     return 0;
>> +}
>> +
>> +static int lpc32xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +     struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
>> +
>> +     clk_enable(lpc32xx->clk);
>> +     return 0;
>> +}
>> +
>> +static void lpc32xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +     struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
>> +
>> +     writel(0, lpc32xx->base);
>> +     clk_disable(lpc32xx->clk);
>> +}
>> +
>> +static const struct pwm_ops lpc32xx_pwm_ops = {
>> +     .config = lpc32xx_pwm_config,
>> +     .enable = lpc32xx_pwm_enable,
>> +     .disable = lpc32xx_pwm_disable,
>> +     .owner = THIS_MODULE,
>> +};
>> +
>> +static int lpc32xx_pwm_probe(struct platform_device *pdev)
>> +{
>> +     struct lpc32xx_pwm_chip *lpc32xx;
>> +     struct resource *res;
>> +     int ret;
>> +
>> +     lpc32xx = devm_kzalloc(&pdev->dev, sizeof(*lpc32xx), GFP_KERNEL);
>> +     if (!lpc32xx)
>> +             return -ENOMEM;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> You should probably check for res != NULL.
>
>> +     lpc32xx->base = devm_request_and_ioremap(&pdev->dev, res);
>> +     if (!lpc32xx->base)
>> +             return -EADDRNOTAVAIL;
>> +
>> +     lpc32xx->clk = devm_clk_get(&pdev->dev, NULL);
>> +     if (IS_ERR(lpc32xx->clk))
>> +             return PTR_ERR(lpc32xx->clk);
>> +
>> +     lpc32xx->chip.dev = &pdev->dev;
>> +     lpc32xx->chip.ops = &lpc32xx_pwm_ops;
>> +     lpc32xx->chip.npwm = 1;
>
> The Kconfig help text says that the lpc32xx PWM controller has two
> channels. Why is npwm set to 1 here?

I will improve the description. We have two independent controllers instead.

Thanks for reviewing. I will fix all the other issues that you found as well.
