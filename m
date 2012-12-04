Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2LDHDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:03:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39183 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2LDHDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <1354155670-6267-3-git-send-email-chao.xie@marvell.com>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<1354155670-6267-3-git-send-email-chao.xie@marvell.com>
Date: Tue, 4 Dec 2012 15:03:31 +0800
Message-ID: <CAN1soZzxbskbQ23fGMD6gvLdPFF1NK9BSdo52T0uq45883QJHg@mail.gmail.com>
Subject: Re: [PATCH 3/4] rtc: pxa: add pxa95x rtc support
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        xie chao <xiechao.mail@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:21 AM, Chao Xie <chao.xie@marvell.com> wrote:
> the pxa95x rtc need access PBSR register before write to
> RTTR, RCNR, RDCR, and RYCR registers.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  drivers/rtc/rtc-pxa.c |   97 +++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 85 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
> index 22ea4f5..29646af 100644
> --- a/drivers/rtc/rtc-pxa.c
> +++ b/drivers/rtc/rtc-pxa.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/delay.h>
>
>  #include <mach/hardware.h>
>
> @@ -81,14 +82,28 @@
>  #define RTCPICR                0x34
>  #define PIAR           0x38
>
> +#define PSBR_RTC       0x00
> +
>  #define rtc_readl(pxa_rtc, reg)        \
>         __raw_readl((pxa_rtc)->base + (reg))
>  #define rtc_writel(pxa_rtc, reg, value)        \
>         __raw_writel((value), (pxa_rtc)->base + (reg))
> +#define rtc_readl_psbr(pxa_rtc, reg)   \
> +       __raw_readl((pxa_rtc)->base_psbr + (reg))
> +#define rtc_writel_psbr(pxa_rtc, reg, value)   \
> +       __raw_writel((value), (pxa_rtc)->base_psbr + (reg))
> +
> +enum {
> +       RTC_PXA27X,
> +       RTC_PXA95X,
> +};
>
>  struct pxa_rtc {
>         struct resource *ress;
> +       struct resource *ress_psbr;
> +       unsigned int            id;
>         void __iomem            *base;
> +       void __iomem            *base_psbr;
>         int                     irq_1Hz;
>         int                     irq_Alrm;
>         struct rtc_device       *rtc;
> @@ -250,9 +265,26 @@ static int pxa_rtc_set_time(struct device *dev, struct rtc_time *tm)
>  {
>         struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
>
> +       /*
> +        * sequence to wirte pxa rtc register RCNR RDCR RYCR is
> +        * 1. set PSBR[RWE] bit, take 2x32-khz to complete
> +        * 2. write to RTC register,take 2x32-khz to complete
> +        * 3. clear PSBR[RWE] bit,take 2x32-khz to complete
> +        */
> +       if (pxa_rtc->id == RTC_PXA95X) {
> +               rtc_writel_psbr(pxa_rtc, PSBR_RTC, 0x01);
> +               udelay(100);
> +       }
> +
>         rtc_writel(pxa_rtc, RYCR, ryxr_calc(tm));
>         rtc_writel(pxa_rtc, RDCR, rdxr_calc(tm));
>
> +       if (pxa_rtc->id == RTC_PXA95X) {
> +               udelay(100);
> +               rtc_writel_psbr(pxa_rtc, PSBR_RTC, 0x00);
> +               udelay(100);
> +       }
> +
>         return 0;
>  }
>
> @@ -318,6 +350,20 @@ static const struct rtc_class_ops pxa_rtc_ops = {
>         .proc = pxa_rtc_proc,
>  };
>
> +static struct of_device_id pxa_rtc_dt_ids[] = {
> +       { .compatible = "marvell,pxa-rtc", .data = (void *)RTC_PXA27X },
> +       { .compatible = "marvell,pxa95x-rtc", .data = (void *)RTC_PXA95X },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, pxa_rtc_dt_ids);
> +
> +static const struct platform_device_id pxa_rtc_id_table[] = {
> +       { "pxa-rtc", RTC_PXA27X },
> +       { "pxa95x-rtc", RTC_PXA95X },
> +        { },
> +};
> +MODULE_DEVICE_TABLE(platform, pxa_rtc_id_table);
> +
>  static int __init pxa_rtc_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
> @@ -332,13 +378,34 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
>         spin_lock_init(&pxa_rtc->lock);
>         platform_set_drvdata(pdev, pxa_rtc);
>
> +       if (pdev->dev.of_node) {
> +               const struct of_device_id *of_id =
> +                               of_match_device(pxa_rtc_dt_ids, &pdev->dev);
> +
> +               pxa_rtc->id = (unsigned int)(of_id->data);
> +       } else {
> +               const struct platform_device_id *id =
> +                               platform_get_device_id(pdev);
> +
> +               pxa_rtc->id = id->driver_data;
> +       }
> +
>         ret = -ENXIO;
>         pxa_rtc->ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!pxa_rtc->ress) {
> -               dev_err(dev, "No I/O memory resource defined\n");
> +               dev_err(dev, "No I/O memory resource(id=0) defined\n");
>                 goto err_ress;
>         }
>
> +       if (pxa_rtc->id == RTC_PXA95X) {
> +               pxa_rtc->ress_psbr =
> +                       platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +               if (!pxa_rtc->ress_psbr) {
> +                       dev_err(dev, "No I/O memory resource(id=1) defined\n");
> +                       goto err_ress;
> +               }
> +       }
> +
>         pxa_rtc->irq_1Hz = platform_get_irq(pdev, 0);
>         if (pxa_rtc->irq_1Hz < 0) {
>                 dev_err(dev, "No 1Hz IRQ resource defined\n");
> @@ -355,7 +422,17 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
>                                 resource_size(pxa_rtc->ress));
>         if (!pxa_rtc->base) {
>                 dev_err(&pdev->dev, "Unable to map pxa RTC I/O memory\n");
> -               goto err_map;
> +               goto err_map_base;
> +       }
> +
> +       if (pxa_rtc->id == RTC_PXA95X) {
> +               pxa_rtc->base_psbr = ioremap(pxa_rtc->ress_psbr->start,
> +                                       resource_size(pxa_rtc->ress_psbr));
> +               if (!pxa_rtc->base_psbr) {
> +                       dev_err(&pdev->dev,
> +                               "Unable to map pxa RTC PSBR I/O memory\n");
> +                       goto err_map_base_psbr;
> +               }
>         }
>
>         /*
> @@ -384,9 +461,12 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
>         return 0;
>
>  err_rtc_reg:
> +       if (pxa_rtc->id == RTC_PXA95X)
> +                iounmap(pxa_rtc->base_psbr);
> +err_map_base_psbr:
>          iounmap(pxa_rtc->base);
> +err_map_base:
>  err_ress:
> -err_map:
>         kfree(pxa_rtc);
>         return ret;
>  }
> @@ -406,14 +486,6 @@ static int __exit pxa_rtc_remove(struct platform_device *pdev)
>         return 0;
>  }
>
> -#ifdef CONFIG_OF
> -static struct of_device_id pxa_rtc_dt_ids[] = {
> -       { .compatible = "marvell,pxa-rtc" },
> -       {}
> -};
> -MODULE_DEVICE_TABLE(of, pxa_rtc_dt_ids);
> -#endif
> -
>  #ifdef CONFIG_PM
>  static int pxa_rtc_suspend(struct device *dev)
>  {
> @@ -448,11 +520,12 @@ static struct platform_driver pxa_rtc_driver = {
>                 .pm     = &pxa_rtc_pm_ops,
>  #endif
>         },
> +       .id_table       = pxa_rtc_id_table,
>  };
>
>  static int __init pxa_rtc_init(void)
>  {
> -       if (cpu_is_pxa27x() || cpu_is_pxa3xx())
> +       if (cpu_is_pxa27x() || cpu_is_pxa3xx() || cpu_is_pxa95x())

Don't use cpu_is_xxx() any more. If there's some different thing, we
should parse it
from DTS.

>                 return platform_driver_probe(&pxa_rtc_driver, pxa_rtc_probe);
>
>         return -ENODEV;
> --
> 1.7.4.1
>
