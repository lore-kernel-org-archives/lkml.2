Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1LIEAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:00:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62895 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1LIEAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:00:36 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 9 Dec 2011 13:00:35 +0900
X-Google-Sender-Auth: iDYSzdGwUbwH5IzqsbmBNPxpZE4
Message-ID: <CAJ0PZbSYQrUQK_oYVGP7RwNFqPRB-FpXRtLm8+5++5By7H8tGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: add irq domain support for max8997 interrupts
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 1:27 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> Add irq domain support for max8997 interrupts. All uses of irq_base in platform
> data and max8997 driver private data are removed.
>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>

Looks good to me.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  arch/arm/mach-exynos/mach-nuri.c    |    4 ----
>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>  drivers/mfd/max8997-irq.c           |   33 +++++++++++++++++++--------------
>  drivers/mfd/max8997.c               |    1 -
>  include/linux/mfd/max8997-private.h |    4 +++-
>  include/linux/mfd/max8997.h         |    1 -
>  6 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
> index 236bbe1..ae333e5 100644
> --- a/arch/arm/mach-exynos/mach-nuri.c
> +++ b/arch/arm/mach-exynos/mach-nuri.c
> @@ -1077,12 +1077,8 @@ static struct platform_device nuri_max8903_device = {
>  static void __init nuri_power_init(void)
>  {
>        int gpio;
> -       int irq_base = IRQ_GPIO_END + 1;
>        int ta_en = 0;
>
> -       nuri_max8997_pdata.irq_base = irq_base;
> -       irq_base += MAX8997_IRQ_NR;
> -
>        gpio = EXYNOS4_GPX0(7);
>        gpio_request(gpio, "AP_PMIC_IRQ");
>        s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
> diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
> index f56d027..588b0a8 100644
> --- a/arch/arm/mach-exynos/mach-origen.c
> +++ b/arch/arm/mach-exynos/mach-origen.c
> @@ -421,7 +421,6 @@ struct max8997_platform_data __initdata origen_max8997_pdata = {
>        .buck1_gpiodvs  = false,
>        .buck2_gpiodvs  = false,
>        .buck5_gpiodvs  = false,
> -       .irq_base       = IRQ_GPIO_END + 1,
>
>        .ignore_gpiodvs_side_effect = true,
>        .buck125_default_idx = 0x0,
> diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
> index 09274cf..eb9cad5 100644
> --- a/drivers/mfd/max8997-irq.c
> +++ b/drivers/mfd/max8997-irq.c
> @@ -142,7 +142,8 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
>  static const inline struct max8997_irq_data *
>  irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
>  {
> -       return &max8997_irqs[irq - max8997->irq_base];
> +       struct irq_data *data = irq_get_irq_data(irq);
> +       return &max8997_irqs[data->hwirq];
>  }
>
>  static void max8997_irq_mask(struct irq_data *data)
> @@ -179,10 +180,11 @@ static struct irq_chip max8997_irq_chip = {
>  static irqreturn_t max8997_irq_thread(int irq, void *data)
>  {
>        struct max8997_dev *max8997 = data;
> +       struct irq_domain *domain = &max8997->irq_domain;
>        u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
>        u8 irq_src;
>        int ret;
> -       int i;
> +       int i, cur_irq;
>
>        ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
>        if (ret < 0) {
> @@ -268,9 +270,9 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>                irq_reg[i] &= ~max8997->irq_masks_cur[i];
>
>        /* Report */
> -       for (i = 0; i < MAX8997_IRQ_NR; i++) {
> +       irq_domain_for_each_irq(domain, i, cur_irq) {
>                if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask)
> -                       handle_nested_irq(max8997->irq_base + i);
> +                       handle_nested_irq(cur_irq);
>        }
>
>        return IRQ_HANDLED;
> @@ -278,13 +280,14 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>
>  int max8997_irq_resume(struct max8997_dev *max8997)
>  {
> -       if (max8997->irq && max8997->irq_base)
> -               max8997_irq_thread(max8997->irq_base, max8997);
> +       if (max8997->irq && max8997->irq_domain.irq_base)
> +               max8997_irq_thread(max8997->irq_domain.irq_base, max8997);
>        return 0;
>  }
>
>  int max8997_irq_init(struct max8997_dev *max8997)
>  {
> +       struct irq_domain *domain = &max8997->irq_domain;
>        int i;
>        int cur_irq;
>        int ret;
> @@ -292,12 +295,6 @@ int max8997_irq_init(struct max8997_dev *max8997)
>
>        if (!max8997->irq) {
>                dev_warn(max8997->dev, "No interrupt specified.\n");
> -               max8997->irq_base = 0;
> -               return 0;
> -       }
> -
> -       if (!max8997->irq_base) {
> -               dev_err(max8997->dev, "No interrupt base specified.\n");
>                return 0;
>        }
>
> @@ -327,9 +324,17 @@ int max8997_irq_init(struct max8997_dev *max8997)
>                                        true : false;
>        }
>
> +       domain->irq_base = irq_alloc_descs(-1, 0, MAX8997_IRQ_NR, 0);
> +       if (domain->irq_base < 0) {
> +               dev_err(max8997->dev, "failed to alloc irq descs\n");
> +               return 0;
> +       }
> +       domain->nr_irq = MAX8997_IRQ_NR;
> +       domain->ops = &irq_domain_simple_ops;
> +       irq_domain_add(domain);
> +
>        /* Register with genirq */
> -       for (i = 0; i < MAX8997_IRQ_NR; i++) {
> -               cur_irq = i + max8997->irq_base;
> +       irq_domain_for_each_irq(domain, i, cur_irq) {
>                irq_set_chip_data(cur_irq, max8997);
>                irq_set_chip_and_handler(cur_irq, &max8997_irq_chip,
>                                handle_edge_irq);
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 5be53ae..b996c6e 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -142,7 +142,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>        if (!pdata)
>                goto err;
>
> -       max8997->irq_base = pdata->irq_base;
>        max8997->ono = pdata->ono;
>
>        mutex_init(&max8997->iolock);
> diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
> index 3f4deb6..04c5779 100644
> --- a/include/linux/mfd/max8997-private.h
> +++ b/include/linux/mfd/max8997-private.h
> @@ -23,6 +23,8 @@
>  #define __LINUX_MFD_MAX8997_PRIV_H
>
>  #include <linux/i2c.h>
> +#include <linux/export.h>
> +#include <linux/irqdomain.h>
>
>  #define MAX8997_REG_INVALID    (0xff)
>
> @@ -325,7 +327,7 @@ struct max8997_dev {
>
>        int irq;
>        int ono;
> -       int irq_base;
> +       struct irq_domain irq_domain;
>        struct mutex irqlock;
>        int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
>        int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
> diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
> index 0bbd13d..1e0b9cc 100644
> --- a/include/linux/mfd/max8997.h
> +++ b/include/linux/mfd/max8997.h
> @@ -79,7 +79,6 @@ struct max8997_regulator_data {
>
>  struct max8997_platform_data {
>        /* IRQ */
> -       int irq_base;
>        int ono;
>        int wakeup;
>
> --
> 1.6.6.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
