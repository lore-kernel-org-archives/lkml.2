Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2GJMn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:43:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38504 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2GJMnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120710121910.GA8959@avionic-0098.adnet.avionic-design.de>
References: <1341921212-11953-1-git-send-email-aletes.xgr@gmail.com>
	<20120710121910.GA8959@avionic-0098.adnet.avionic-design.de>
Date: Tue, 10 Jul 2012 09:43:23 -0300
Message-ID: <CAAAP30HOP-o11Ok0u1y=s6ASJ2zrP7YV+-fZ7rdF_PFe0kF6hw@mail.gmail.com>
Subject: Re: [PATCH v2] pwm: add lpc32xx pwm support
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

On Tue, Jul 10, 2012 at 9:19 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Tue, Jul 10, 2012 at 08:53:32AM -0300, Alexandre Pereira da Silva wrote:
>> Add lpc32xx soc pwm driver.
>
> The subject and this still need fixing (soc -> SOC, pwm -> PWM).
>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> ---
>> Changes since v1:
>> * Style fixes
>> * Better error handling
>> * Improved Kconfig and DT descriptions
>>
>>  .../devicetree/bindings/pwm/lpc32xx-pwm.txt        |   17 +++
>>  drivers/pwm/Kconfig                                |   11 ++
>>  drivers/pwm/Makefile                               |    1 +
>>  drivers/pwm/pwm-lpc32xx.c                          |  150 ++++++++++++++++++++
>>  4 files changed, 179 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>>  create mode 100644 drivers/pwm/pwm-lpc32xx.c
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>> new file mode 100644
>> index 0000000..e7720e3
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>> @@ -0,0 +1,17 @@
>> +LPC32XX PWM controller
>> +
>> +Required properties:
>> +- compatible: should be "nxp,lpc3220-pwm"
>> +- reg: physical base address and length of the controller's registers
>> +
>> +Examples:
>> +
>> +pwm1: pwm@0x4005C000 {
>> +     compatible = "nxp,lpc3220-pwm";
>> +     reg = <0x4005C000 0x4>;
>> +};
>> +
>> +pwm2: pwm@0x4005C004 {
>> +     compatible = "nxp,lpc3220-pwm";
>> +     reg = <0x4005C004 0x4>;
>> +};
>
> The PWM framework can support chips with multiple PWM devices. The
> LPC32xx seems to fit this model quite nicely, so you should instead
> instantiate one device and set npwm to 2.
>
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index 0b2800f..ec2ac70 100644
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
>> +       Generic PWM framework driver for LPC32XX. The LPC32XX SOC has two
>> +       PWM controllers.
>> +
>> +       To compile this driver as a module, choose M here: the module
>> +       will be called pwm-lpc32xx.
>> +
>> +
>
> There's a gratuitous blank line here, please remove.
>
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
>> index 0000000..d79f4f9
>> --- /dev/null
>> +++ b/drivers/pwm/pwm-lpc32xx.c
>> @@ -0,0 +1,150 @@
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
>> +     struct clk *clk;
>> +     void __iomem *base;
>> +};
>> +
>> +#define PWM_ENABLE   (1 << 31)
>> +#define PWM_RELOADV(x)       (((x) & 0xFF) << 8)
>> +#define PWM_DUTY(x)  ((x) & 0xFF)
>> +
>> +#define to_lpc32xx_pwm_chip(_chip) \
>> +     container_of(_chip, struct lpc32xx_pwm_chip, chip)
>> +
>> +static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                           int duty_ns, int period_ns)
>> +{
>> +     struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
>> +     unsigned long long c;
>> +     int period_cycles, duty_cycles;
>> +
>> +     c = clk_get_rate(lpc32xx->clk) / 256;
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
>> +     c = 256 * duty_ns;
>> +     do_div(c, period_ns);
>> +     duty_cycles = c;
>> +
>> +     writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
>> +             lpc32xx->base);
>> +
>> +     return 0;
>> +}
>
> When you convert to having more than one PWM device per chip, you can
> use pwm->hwpwm to distinguish between them. For this case this should be
> a trivial as:
>
>         writel(..., lpc32xx->base + (pwm->hwpwm << 2));

I will try that. I didn't wrote the driver that way because of the clocks.
