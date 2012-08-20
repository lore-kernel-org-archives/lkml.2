Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2HTNnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:43:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39164 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2HTNnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-3-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-3-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 15:43:11 +0200
Message-ID: <CACRpkda9BL5+NiDOsMKG0kv2coBsw=Er=ZccXnNkgeftV9hPhQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] pinctrl: mvebu: dove pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

(...)
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> @@ -147,7 +147,7 @@ config PINCTRL_COH901
>
>  config PINCTRL_MVEBU
>         bool "Marvell SoC pin controller drivers"
> -       depends on ARCH_MVEBU
> +       depends on ARCH_MVEBU || ARCH_DOVE

Hmmmm.

Shouldn't this thing rather be:

depends on PLAT_ORION

else you end up lining up all Marvell machines here...

>         select PINMUX
>         select PINCONF
>         help
> @@ -155,6 +155,13 @@ config PINCTRL_MVEBU
>           This is only the driver core and additionally needs a SoC specific
>           driver.
>
> +config PINCTRL_DOVE
> +       bool "Support for Marvell Dove SoCs"
> +       depends on PINCTRL_MVEBU

Shouldn't this rather be:

depends on ARCH_DOVE
select PINCTRL_MVEBU

since you call down into the mvebu driver, it definatley needs
to select that.

(...)
> diff --git a/drivers/pinctrl/pinctrl-dove.c b/drivers/pinctrl/pinctrl-dove.c

> +#define  DOVE_AU0_AC97_SEL             (1 << 16)

It is way cleaner to say:

#include <linux/bitops.h>

#define  DOVE_AU0_AC97_SEL             BIT(16)

(...)
> +static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
> +                                unsigned long *config)
> +{
> +       unsigned off = (ctrl->pid / 8) * 4;
> +       unsigned shift = (ctrl->pid % 8) * 4;
> +       unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
> +       unsigned long mpp = readl(DOVE_MPP_VIRT_BASE + off);
> +
> +       if (pmu & (1 << ctrl->pid))
> +               *config = 0x10;
> +       else
> +               *config = (mpp >> shift) & 0xf;
> +       return 0;
> +}

Same comments about the magic numbers as in the review of the first
patch.

> +static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
> +                                unsigned long config)
> +{
> +       unsigned off = (ctrl->pid / 8) * 4;
> +       unsigned shift = (ctrl->pid % 8) * 4;
> +       unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
> +       unsigned long mpp = readl(DOVE_MPP_VIRT_BASE + off);
> +
> +       if (config == 0x10)
> +               writel(pmu | (1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
> +       else {
> +               writel(pmu & ~(1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
> +               mpp &= ~(0xf << shift);
> +               mpp |= config << shift;
> +               writel(mpp, DOVE_MPP_VIRT_BASE + off);
> +       }
> +       return 0;
> +}

Dito.

> +static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
> +                             unsigned long *config)
> +{
> +       unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
> +       unsigned long mask;
> +
> +       if (ctrl->pid == 24)
> +               mask = DOVE_CAM_GPIO_SEL;
> +       else if (ctrl->pid == 40)
> +               mask = DOVE_SD0_GPIO_SEL;
> +       else if (ctrl->pid == 46)
> +               mask = DOVE_SD1_GPIO_SEL;
> +       else if (ctrl->pid == 58)
> +               mask = DOVE_SPI_GPIO_SEL;
> +       else if (ctrl->pid == 62)
> +               mask = DOVE_UART1_GPIO_SEL;
> +       else
> +               return -EINVAL;

Magic numbers, atleast provide a comment on what is so special about
these pins, and can you use a switch() statement instead?

(...)
> +static int dove_mpp4_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
> +                             unsigned long config)
> +{
> +       unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
> +       unsigned long mask;
> +
> +       if (ctrl->pid == 24)
> +               mask = DOVE_CAM_GPIO_SEL;
> +       else if (ctrl->pid == 40)
> +               mask = DOVE_SD0_GPIO_SEL;
> +       else if (ctrl->pid == 46)
> +               mask = DOVE_SD1_GPIO_SEL;
> +       else if (ctrl->pid == 58)
> +               mask = DOVE_SPI_GPIO_SEL;
> +       else if (ctrl->pid == 62)
> +               mask = DOVE_UART1_GPIO_SEL;
> +       else
> +               return -EINVAL;

Dito.

(...)
> +static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
> +                               unsigned long *config)
> +{
> +       unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
> +       unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
> +       unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
> +       unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
> +
> +       *config = 0;
> +       if (mpp4 & DOVE_AU1_GPIO_SEL)
> +               *config |= 0x8;
> +       if (sspc1 & DOVE_SSP_ON_AU1)
> +               *config |= 0x4;
> +       if (gmpp & DOVE_AU1_SPDIFO_GPIO_EN)
> +               *config |= 0x2;
> +       if (gcfg2 & DOVE_TWSI_OPTION3_GPIO)
> +               *config |= 0x1;

More magic, but the flags make it clear what the set
bits are all about, so OK.

But I would have:
#include <linux/bitops.h>

*config |= BIT(0);

etc.

> +       /* SSP/TWSI only if I2S1 not set*/
> +       if ((*config & 0x8) == 0)
> +               *config &= ~(0x4 | 0x1);
> +       /* TWSI only if SPDIFO not set*/
> +       if ((*config & 0x2) == 0)
> +               *config &= ~(0x1);
> +       return 0;

And that applies to these.

> +static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
> +                               unsigned long config)
> +{
> +       unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
> +       unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
> +       unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
> +       unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
> +
> +       if (config & 0x1)
> +               gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
> +       if (config & 0x2)
> +               gmpp |= DOVE_AU1_SPDIFO_GPIO_EN;
> +       if (config & 0x4)
> +               sspc1 |= DOVE_SSP_ON_AU1;
> +       if (config & 0x8)
> +               mpp4 |= DOVE_AU1_GPIO_SEL;

Dito.

> +static int dove_audio1_ctrl_gpio_req(struct mvebu_mpp_ctrl *ctrl, u8 pid)
> +{
> +       unsigned long config;
> +
> +       dove_audio1_ctrl_get(ctrl, &config);
> +
> +       switch (config) {
> +       /* mode 0x00 i2s1/spdifo : no gpio */
> +       /* mode 0x0c ssp/spdifo  : no gpio */
> +       /* mode 0x0f ssp/twsi    : no gpio */
> +       case 0x00:
> +       case 0x0c:
> +       case 0x0f:
> +               return -ENOTSUPP;

Nice with the comments (also before the function),
now I understand what's happening, this is pretty OK,
I would have put the comments on the same
line as the magic number but whatever.

However you could just delete these lines and let them
fall through to -ENOTSUPP at the bottom.

> +
> +       /* mode 0x02 i2s1 : gpio[56:57] */
> +       /* mode 0x0e ssp  : gpio[56:57] */
> +       case 0x02:
> +       case 0x0e:
> +               if (pid >= 56)
> +                       return 0;
> +
> +       /* mode 0x08 spdifo : gpio[52:55] */
> +       /* mode 0x0b twsi   : gpio[52:55] */
> +       case 0x08:
> +       case 0x0b:
> +               if (pid <= 55)
> +                       return 0;
> +
> +       /* mode 0x0a/gpio : all gpio */
> +       case 0x0a:
> +               return 0;
> +       }
> +
> +       return -ENOTSUPP;
> +}

> +/* mpp[52:57] has gpio pins capable of in and out */
> +static int dove_audio1_ctrl_gpio_dir(struct mvebu_mpp_ctrl *ctrl, u8 pid,
> +                               bool input)
> +{
> +       return 0;
> +}

So should this not return a -ENOTSUPP for
pin < 52 || pin > 57?

(...)
> +static int __devinit dove_pinctrl_probe(struct platform_device *pdev)
> +{
> +       const struct of_device_id *match =
> +               of_match_device(dove_pinctrl_of_match, &pdev->dev);
> +       int ret;
> +
> +       if (match)
> +               pdev->dev.platform_data = match->data;
> +
> +       /*
> +        * General MPP Configuration Register is part of pdma registers.
> +        * grab clk to make sure it is clocked.
> +        */
> +       pdma_clk = clk_get_sys("dove-pdma", NULL);

First there is something really weird with the name of this
clock. Atleast call the variable holding the clk something
apropriate like just "clk".

Second why are you fetching a sys clock instead of using the clkdev
device binding in the clock tree so you could say:

clk = clk_get(&pdev->dev, NULL);

> +       clk_prepare_enable(pdma_clk);

Good!

> +       ret = mvebu_pinctrl_probe(pdev);
> +       if (!ret)
> +               return 0;
> +
> +       clk_disable_unprepare(pdma_clk);
> +       clk_put(pdma_clk);
> +       return ret;
> +}
> +
> +static int __devexit dove_pinctrl_remove(struct platform_device *pdev)
> +{
> +       int ret;
> +
> +       ret = mvebu_pinctrl_remove(pdev);
> +       if (!IS_ERR(pdma_clk)) {
> +               clk_disable_unprepare(pdma_clk);
> +               clk_put(pdma_clk);
> +       }

You don't need this (!IS_ERR()) clause, look in yout probe function:
you bail out if the clock is not found.

The rest looks good... atleast now, but I'm low on coffee FTM.

Yours,
Linus Walleij
