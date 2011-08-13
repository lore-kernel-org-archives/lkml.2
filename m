Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1HMJtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 05:49:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38739 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1HMJtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 05:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <1313189697-21287-9-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
	<1313189697-21287-9-git-send-email-swarren@nvidia.com>
Date: Sat, 13 Aug 2011 11:49:18 +0200
Message-ID: <CAAfyv34kOtwjerB0gMhEKNTwGd9w-LCE52MCUuvzTyYkXLY-dg@mail.gmail.com>
Subject: Re: [RFC PATCH 08/12] gpio/tegra: Add device tree support
From: Belisko Marek <marek.belisko@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 12:54 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/gpio/gpio-tegra.c |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
> index 4da4839..923b413 100644
> --- a/drivers/gpio/gpio-tegra.c
> +++ b/drivers/gpio/gpio-tegra.c
> @@ -326,6 +326,29 @@ static struct irq_chip tegra_gpio_irq_chip = {
>  #endif
>  };
>
> +#ifdef CONFIG_OF
> +static void __init tegra_gpio_probe_dt(struct platform_device *pdev)
> +{
> +       const __be32 *gpios;
> +       u32 gpioslen;
> +       int i;
> +
> +       gpios = of_get_property(pdev->dev.of_node, "nvidia,gpios", &gpioslen);
> +       if (gpios == NULL)
> +               return;
> +
> +       gpioslen /= sizeof(*gpios);
> +       for (i = 0; i < gpioslen; i++, gpios++) {
> +               u32 gpio = be32_to_cpup(gpios);
> +               dev_err(&pdev->dev, "Enabling GPIO %d\n", gpio);
Is really necessary to print all enabled gpio's to console? Also seen
same in pinmux probe.
> +               tegra_gpio_enable(gpio);
> +       }
> +}
> +#else
> +static inline void __init tegra_gpio_probe_dt(struct platform_device *pdev)
> +{
> +}
> +#endif
>
>  /* This lock class tells lockdep that GPIO irqs are in a different
>  * category than their parents, so it won't report false recursion.
> @@ -371,13 +394,21 @@ static int __init tegra_gpio_probe(struct platform_device *pdev)
>                        spin_lock_init(&bank->lvl_lock[j]);
>        }
>
> +       tegra_gpio_probe_dt(pdev);
> +
>        return 0;
>  }
>
> +static struct of_device_id tegra_gpio_of_match[] __devinitdata = {
> +       { .compatible = "nvidia,tegra20-gpio", },
> +       { },
> +};
> +
>  static struct platform_driver tegra_gpio_driver = {
>        .driver         = {
>                .name   = "tegra-gpio",
>                .owner  = THIS_MODULE,
> +               .of_match_table = tegra_gpio_of_match,
>        },
>        .probe          = tegra_gpio_probe,
>  };
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
