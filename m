Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2FABgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:36:19 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38399 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2FABgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:36:17 -0400
MIME-Version: 1.0
In-Reply-To: <1337816857-14694-2-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
	<1337816857-14694-2-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 1 Jun 2012 09:36:17 +0800
Message-ID: <CACRpkdZDnFW4-bDsHN5BOr2e5NLGzouSBY7ngf-VsoPn-SyxAA@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: add samsung pinctrl and gpiolib driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org,
        ext Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 7:47 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt

It would be nice if some DT person could review the bindings, but if
nothing happens
I will accept them as-is.

This driver is special since it seems to keep all pin, group and
function information
in the device tree, but not like Tony is doing it in pinctrl-simple,
if I understand
correctly?

> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> new file mode 100644
> index 0000000..480e2f0
(...)
> +/* reading pin pull up/down and driver strength settings not implemented */
> +static int samsung_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
> +                                       unsigned long *config)
> +{
> +       return -ENOTSUPP;
> +}
> +
> +/* reading pin pull up/down and driver strength settings not implemented */
> +static int samsung_pinconf_group_get(struct pinctrl_dev *pctldev,
> +                               unsigned int group, unsigned long *config)
> +{
> +       return -ENOTSUPP;
> +}

I think we made these optional now, so you can just leave them undefined
in the pinconf_ops.

> +static inline struct samsung_pinctrl_drv_data *samsung_pinctrl_get_driver_data(
> +                               struct platform_device *pdev)
> +{
> +#ifdef CONFIG_OF
> +       if (pdev->dev.of_node) {
> +               int id;
> +               const struct of_device_id *match;
> +               const struct device_node *node = pdev->dev.of_node;
> +
> +               id = of_alias_get_id(pdev->dev.of_node, "pinctrl");
> +               if (id < 0) {
> +                       dev_err(&pdev->dev, "failed to get alias id\n");
> +                       return NULL;
> +               }
> +               match = of_match_node(samsung_pinctrl_dt_match, node);
> +               return (struct samsung_pinctrl_drv_data *)match->data + id;
> +       }
> +#endif

You don't need this #ifdef because in Kconfig the driver already depends on
OF so this is always available.

> +/* driver data for various samsung soc's */
> +#ifdef CONFIG_CPU_EXYNOS4210
> +#define EXYNOS4210_PCTRL_DRVDATA (&exynos4210_pinctrl_drv_data)
> +#else
> +#define EXYNOS4210_PCTRL_DRVDATA (NULL)
> +#endif /* CONFIG_CPU_EXYNOS4210 */

Can you do this in some .h file instead?

> +#ifdef CONFIG_OF

You don't need this because in Kconfig the driver depends on OF
already.

> +static const struct of_device_id samsung_pinctrl_dt_match[] = {
> +#ifdef CONFIG_CPU_EXYNOS4210
> +       { .compatible = "samsung,pinctrl-exynos4210",
> +               .data = (void *)exynos4210_pinctrl_drv_data },
> +#endif /* CONFIG_CPU_EXYNOS4210 */
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
> +#endif /* CONFIG_OF */

So delete the closing #endif too.

Yours,
Linus Walleij
