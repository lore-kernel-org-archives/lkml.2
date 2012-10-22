Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2JVEJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:09:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56060 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2JVEJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
Date: Mon, 22 Oct 2012 09:39:21 +0530
X-Google-Sender-Auth: C79Dcsk5YjnQQL6_3IX_JxTmoTo
Message-ID: <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
From: viresh kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time you read a code, you figure out new things about it.
Sorry for these comments Now :(

On Mon, Oct 22, 2012 at 9:21 AM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index acfe482..6512786 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_PWM_PUV3)          += pwm-puv3.o
>  obj-$(CONFIG_PWM_PXA)          += pwm-pxa.o
>  obj-$(CONFIG_PWM_SAMSUNG)      += pwm-samsung.o
>  obj-$(CONFIG_PWM_TEGRA)                += pwm-tegra.o
> +obj-$(CONFIG_PWM_SPEAR)                += pwm-spear.o

I have gone through this on every version of this patch, but couldn't figure
out that you were trying to add it in alphabetical order, but you couldn't.

> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c

> +static int spear_pwm_probe(struct platform_device *pdev)
> +{
> +       pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
> +       if (!pc) {
> +               dev_err(&pdev->dev, "failed to allocate memory\n");
> +               return -ENOMEM;
> +       }
> +
> +       pc->dev = &pdev->dev;

If you are going to send another version, then please move this

> +       pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
> +       if (!pc->mmio_base)
> +               return -EADDRNOTAVAIL;
> +
> +       platform_set_drvdata(pdev, pc);

and this

> +       pc->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(pc->clk))
> +               return PTR_ERR(pc->clk);

to this place :)
So, that we don't do these for failure cases.

> +       pc->chip.dev = &pdev->dev;
> +       pc->chip.ops = &spear_pwm_ops;
> +       pc->chip.base = -1;
> +       pc->chip.npwm = NUM_PWM;
> +

> +       if (np && of_device_is_compatible(np, "st,spear1340-pwm")) {

I have noticed it earlier, but don't know why didn't i gave a comment here?
you don't need to check for np here. It can't be NULL as you depend on
CONFIG_OF.

> +               /*
> +                * Following enables PWM chip, channels would still be
> +                * enabled individually through their control register
> +                */
> +               val = readl_relaxed(pc->mmio_base + PWMMCR);
> +               val |= PWMMCR_PWM_ENABLE;
> +               writel_relaxed(val, pc->mmio_base + PWMMCR);
> +
> +       }
> +
> +       /* only disable the clk and leave it prepared */
> +       clk_disable(pc->clk);
> +
> +       return 0;
> +}
> +
> +static int spear_pwm_remove(struct platform_device *pdev)
> +{
> +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
> +       int i;
> +
> +       for (i = 0; i < NUM_PWM; i++) {
> +               struct pwm_device *pwm = &pc->chip.pwms[i];
> +
> +               if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +                       spear_pwm_writel(pc, i, PWMCR, 0);
> +                       clk_disable(pc->clk);
> +               }
> +       }
> +
> +       /* clk was prepared in probe, hence unprepare it here */
> +       clk_unprepare(pc->clk);

I believe you need to remove the chip first and then do above to
avoid any race conditions, that might occur.

> +       return pwmchip_remove(&pc->chip);
> +}
> +

After all this please add my:
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Sorry Shiraz for so late comments, i can understand your frustration :(

--
viresh
