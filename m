Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2LUM3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:29:38 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43261 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2LUM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:29:31 -0500
X-Greylist: delayed 98230 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 07:29:31 EST
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E108CA@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E108CA@DQHE02.ent.ti.com>
Date: Fri, 21 Dec 2012 17:59:30 +0530
Message-ID: <CAHdPZaOrVQ-oU_+N621izgFedjvWBCJGh2vDub4HjzVemusG7w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] rtc: add new lp8788 rtc driver
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
On Fri, Dec 21, 2012 at 1:25 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> TI LP8788 PMU supports regulators, battery charger, RTC, ADC, backlight driver
> and current sinks.
> This patch enables LP8788 RTC module.
>

Nice one, but i just have some queries or questions below,

> Patch v3.
>  remove __devinit and __devexit.
>  add weekday definition and comments.
>
> Patch v2.
>  use IRQ domain for handling alarm IRQ.
>  replace module_init() and module_exit() with module_platform_driver().
>  clean up code for _probe() and _remove().
>
> Patch v1.
>  initial patch
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---

> diff --git a/drivers/rtc/rtc-lp8788.c b/drivers/rtc/rtc-lp8788.c
> new file mode 100644
> index 0000000..2363e52
> --- /dev/null
> +++ b/drivers/rtc/rtc-lp8788.c
> @@ -0,0 +1,345 @@
> +/*
> + * TI LP8788 MFD - rtc driver
> + *
> + * Copyright 2012 Texas Instruments
> + *
> + * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/err.h>
> +#include <linux/irqdomain.h>
> +#include <linux/mfd/lp8788.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/rtc.h>
> +#include <linux/slab.h>
> +
> +/* register address */
> +#define LP8788_INTEN_3                 0x05
> +#define LP8788_RTC_UNLOCK              0x64
> +#define LP8788_RTC_SEC                 0x70
> +#define LP8788_ALM1_SEC                        0x77
> +#define LP8788_ALM1_EN                 0x7D
> +#define LP8788_ALM2_SEC                        0x7E
> +#define LP8788_ALM2_EN                 0x84
> +
> +/* mask/shift bits */
> +#define LP8788_INT_RTC_ALM1_M          BIT(1)  /* Addr 05h */
> +#define LP8788_INT_RTC_ALM1_S          1
> +#define LP8788_INT_RTC_ALM2_M          BIT(2)  /* Addr 05h */
> +#define LP8788_INT_RTC_ALM2_S          2
> +#define LP8788_ALM_EN_M                        BIT(7)  /* Addr 7Dh or 84h */
> +#define LP8788_ALM_EN_S                        7
> +
> +#define DEFAULT_ALARM_SEL              LP8788_ALARM_1
> +#define LP8788_MONTH_OFFSET            1
> +#define LP8788_BASE_YEAR               2000
> +#define MAX_WDAY_BITS                  7
> +#define LP8788_WDAY_SET                        1
> +#define RTC_UNLOCK                     0x1
> +#define RTC_LATCH                      0x2
> +#define ALARM_IRQ_FLAG                 (RTC_IRQF | RTC_AF)
> +
> +enum lp8788_time {
> +       LPTIME_SEC,
> +       LPTIME_MIN,
> +       LPTIME_HOUR,
> +       LPTIME_MDAY,
> +       LPTIME_MON,
> +       LPTIME_YEAR,
> +       LPTIME_WDAY,
> +       LPTIME_MAX,
> +};
> +
> +struct lp8788_rtc {
> +       struct lp8788 *lp;
> +       struct rtc_device *rdev;
> +       enum lp8788_alarm_sel alarm;
> +       int irq;
> +};
> +
> +static const u8 addr_alarm_sec[LP8788_ALARM_MAX] = {
> +       LP8788_ALM1_SEC,
> +       LP8788_ALM2_SEC,
> +};
> +
> +static const u8 addr_alarm_en[LP8788_ALARM_MAX] = {
> +       LP8788_ALM1_EN,
> +       LP8788_ALM2_EN,
> +};
> +
> +static const u8 mask_alarm_en[LP8788_ALARM_MAX] = {
> +       LP8788_INT_RTC_ALM1_M,
> +       LP8788_INT_RTC_ALM2_M,
> +};
> +
> +static const u8 shift_alarm_en[LP8788_ALARM_MAX] = {
> +       LP8788_INT_RTC_ALM1_S,
> +       LP8788_INT_RTC_ALM2_S,
> +};
> +

<snip>

> +static int lp8788_alarm_irq_enable(struct device *dev, unsigned int enable)
> +{
> +       struct lp8788_rtc *rtc = dev_get_drvdata(dev);
> +       struct lp8788 *lp = rtc->lp;
> +       u8 mask, shift;
> +
> +       mask = mask_alarm_en[rtc->alarm];
> +       shift = shift_alarm_en[rtc->alarm];
> +
> +       return lp8788_update_bits(lp, LP8788_INTEN_3, mask, enable << shift);

i have no idea about this function but just asking,

this will be called from ioctl right? so what if user calls RTC_AIE_ON
and you return the IRQ status ? enable or disable like that?

i guess a failure in setting for no irq and a success otherwise.

> +}
> +
> +static const struct rtc_class_ops lp8788_rtc_ops = {
> +       .read_time = lp8788_rtc_read_time,
> +       .set_time = lp8788_rtc_set_time,
> +       .read_alarm = lp8788_read_alarm,
> +       .set_alarm = lp8788_set_alarm,
> +       .alarm_irq_enable = lp8788_alarm_irq_enable,
> +};
> +
> +static irqreturn_t lp8788_alarm_irq_handler(int irq, void *ptr)
> +{
> +       struct lp8788_rtc *rtc = ptr;
> +
> +       rtc_update_irq(rtc->rdev, 1, ALARM_IRQ_FLAG);
> +       return IRQ_HANDLED;
> +}
> +
> +static int lp8788_alarm_irq_register(struct platform_device *pdev,
> +                               struct lp8788_rtc *rtc)
> +{
> +       struct resource *r;
> +       struct lp8788 *lp = rtc->lp;
> +       struct irq_domain *irqdm = lp->irqdm;
> +       int irq;
> +
> +       rtc->irq = 0;
> +
> +       if (!lp->pdata) {
> +               dev_warn(lp->dev, "no platform data for rtc irq\n");

but we didn't registered irqs right? if we return 0 here means that we
have a vaild irq no?

> +               return 0;
> +       }
> +
> +       r = platform_get_resource_byname(pdev, IORESOURCE_IRQ, LP8788_ALM_IRQ);
> +       if (!r)
> +               return 0;
> +
> +       if (rtc->alarm == LP8788_ALARM_1)
> +               irq = r->start;
> +       else
> +               irq = r->end;
> +
> +       rtc->irq = irq_create_mapping(irqdm, irq);
> +
> +       return request_threaded_irq(rtc->irq, NULL, lp8788_alarm_irq_handler,
> +                               0, LP8788_ALM_IRQ, rtc);
> +}
> +
> +static void lp8788_alarm_irq_unregister(struct lp8788_rtc *rtc)
> +{
> +       if (rtc->irq)
> +               free_irq(rtc->irq, rtc);
> +}
> +
> +static int lp8788_rtc_probe(struct platform_device *pdev)
> +{
> +       struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
> +       struct lp8788_rtc *rtc;
> +       struct device *dev = &pdev->dev;
> +
> +       rtc = devm_kzalloc(lp->dev, sizeof(struct lp8788_rtc), GFP_KERNEL);

lp->dev may be parent device, is &pdev->dev, or dev may be correct?

> +       if (!rtc)
> +               return -ENOMEM;
> +
> +       rtc->lp = lp;
> +       rtc->alarm = lp->pdata ? lp->pdata->alarm_sel : DEFAULT_ALARM_SEL;
> +       platform_set_drvdata(pdev, rtc);
> +
> +       device_init_wakeup(dev, 1);
> +
> +       rtc->rdev = rtc_device_register("lp8788_rtc", dev,
> +                                       &lp8788_rtc_ops, THIS_MODULE);
> +       if (IS_ERR(rtc->rdev)) {
> +               dev_err(dev, "can not register rtc device\n");

                    return PTR_ERR(rtc->rdev);  may be better?

> +               return -ENODEV;
> +       }
> +
> +       if (lp8788_alarm_irq_register(pdev, rtc))
> +               dev_warn(lp->dev, "no rtc irq handler\n");
> +

even if there is no alarm irq, we can still use the rtc to get the
time, but there wont be RTC_AIE_ON ioctl enabled ?

> +       return 0;
> +}
> +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
