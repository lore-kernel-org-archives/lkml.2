Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0HJBzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 21:55:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44967 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0HJBzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 21:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hq3P2DpxTNRU+JIxWQ2a2oEUYC9OCsBGqG3KmEp07htOax4X/UeacLKHlxltAKWIEv
         ZFzaioBHFZHaT+QXBfHG+42s/j3UZYoeTAkHEwfFEScu7nVmj0NVtEHwWVSa9khgQ4i6
         Ty+d1D+oNqa3zWw+F9cwEGcN9J8liCMKhFjwA=
MIME-Version: 1.0
In-Reply-To: <1281370650-29520-2-git-send-email-wellsk40@gmail.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-2-git-send-email-wellsk40@gmail.com>
Date: Tue, 10 Aug 2010 09:55:13 +0800
Message-ID: <AANLkTimAJj38R7KCfHusfsq+EXDd3fbAm=Az_Osqdgbz@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver 
	for the LPC32XX SoC
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Wells <wellsk40@gmail.com>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin ,

This is really a natty rtc patch:).


2010/8/10  <wellsk40@gmail.com>:
> From: Kevin Wells <wellsk40@gmail.com>
>
> This patch contains the RTC driver for the built-in RTC in
> the LPC32XX SoC.
>
> Signed-off-by: Kevin Wells <wellsk40@gmail.com>
> Signed-off-by: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>
> ---
>  drivers/rtc/rtc-lpc32xx.c |  391 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 391 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-lpc32xx.c
>
> diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
> new file mode 100644
> index 0000000..7803c68
> --- /dev/null
> +++ b/drivers/rtc/rtc-lpc32xx.c
> @@ -0,0 +1,391 @@
> +/*
> + * Copyright (C) 2010 NXP Semiconductors
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include <linux/rtc.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +
> +/*
> + * Clock and Power control register offsets
> + */
> +#define RTC_UCOUNT             0x00
> +#define RTC_DCOUNT             0x04
> +#define RTC_MATCH0             0x08
> +#define RTC_MATCH1             0x0C
> +#define RTC_CTRL               0x10
> +#define RTC_INTSTAT            0x14
> +#define RTC_KEY                        0x18
> +#define RTC_SRAM               0x80
> +
> +#define RTC_MATCH0_EN          (1 << 0)
> +#define RTC_MATCH1_EN          (1 << 1)
> +#define RTC_ONSW_MATCH0_EN     (1 << 2)
> +#define RTC_ONSW_MATCH1_EN     (1 << 3)
> +#define RTC_SW_RESET           (1 << 4)
> +#define RTC_CNTR_DIS           (1 << 6)
> +#define RTC_ONSW_FORCE_HIGH    (1 << 7)
> +
> +#define RTC_MATCH0_INT_STS     (1 << 0)
> +#define RTC_MATCH1_INT_STS     (1 << 1)
> +#define RTC_ONSW_INT_STS       (1 << 2)
> +
> +#define RTC_KEY_ONSW_LOADVAL   0xB5C13F27
> +
> +#define RTC_NAME "rtc-lpc32xx"
> +
> +#define rtc_readl(dev, reg) \
> +       __raw_readl((dev)->rtc_base + reg)
> +#define rtc_writel(dev, reg, val) \
> +       __raw_writel((val), (dev)->rtc_base + reg)
> +
> +struct lpc32xx_rtc {
> +       void __iomem *rtc_base;
> +       unsigned int irq;
> +       int alarm_enabled;
> +       struct rtc_device *rtc;
> +       spinlock_t lock;
> +};
> +
> +static int lpc32xx_rtc_read_time(struct device *dev, struct rtc_time *time)
> +{
> +       unsigned long elapsed_sec;
> +       struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
> +
> +       elapsed_sec = rtc_readl(rtc, RTC_UCOUNT);
> +       rtc_time_to_tm(elapsed_sec, time);
> +
> +       return rtc_valid_tm(time);
> +}
> +
> +static int lpc32xx_rtc_set_mmss(struct device *dev, unsigned long secs)
> +{
> +       struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
> +       u32 tmp;
> +
> +       spin_lock_irq(&rtc->lock);
> +
> +       /* RTC must be disabled during count update */
> +       tmp = rtc_readl(rtc, RTC_CTRL);
> +       rtc_writel(rtc, RTC_CTRL, tmp | RTC_CNTR_DIS);
> +       rtc_writel(rtc, RTC_UCOUNT, secs);
> +       rtc_writel(rtc, RTC_DCOUNT, 0xFFFFFFFF - secs);
> +       rtc_writel(rtc, RTC_CTRL, tmp &= ~RTC_CNTR_DIS);
> +
> +       spin_unlock_irq(&rtc->lock);
> +
> +       return 0;
> +}
> +
> +static int lpc32xx_rtc_read_alarm(struct device *dev,
> +       struct rtc_wkalrm *wkalrm)
> +{
> +       struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
> +
> +       rtc_time_to_tm(rtc_readl(rtc, RTC_MATCH0), &wkalrm->time);
> +       wkalrm->enabled = rtc->alarm_enabled;
> +
> +       return rtc_valid_tm(&wkalrm->time);
> +}
> +
> +static int lpc32xx_rtc_set_alarm(struct device *dev,
> +       struct rtc_wkalrm *wkalrm)
> +{
> +       struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
> +       unsigned long alarmsecs;
> +       u32 tmp;
> +       int ret;
> +       ret = rtc_tm_to_time(&wkalrm->time, &alarmsecs);
> +       if (ret < 0) {
> +               dev_err(dev, "Failed to convert time: %d\n", ret);
> +               return ret;
> +       }
> +
> +       spin_lock_irq(&rtc->lock);
> +
> +       /* Disable alarm during update */
> +       tmp = rtc_readl(rtc, RTC_CTRL);
> +       rtc_writel(rtc, RTC_CTRL, tmp & ~RTC_MATCH0_EN);
> +
> +       rtc->alarm_enabled = wkalrm->enabled = 1;
> +       if (wkalrm->enabled) {
> +               rtc_writel(rtc, RTC_MATCH0, alarmsecs);
> +               rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
> +               rtc_writel(rtc, RTC_CTRL, tmp | RTC_MATCH0_EN);
> +       }

I think this 'wkalrm->enabled ' will always be set '1', so 'if'
condition will be alway true?

> +
> +       spin_unlock_irq(&rtc->lock);
> +
> +       return 0;
> +}
> +
> +static int lpc32xx_rtc_alarm_irq_enable(struct device *dev,
> +       unsigned int enabled)
> +{
> +       struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
> +       u32 tmp;
> +
> +       spin_lock_irq(&rtc->lock);
> +       rtc->alarm_enabled = (int) enabled;
> +       tmp = rtc_readl(rtc, RTC_CTRL);
> +
> +       if (enabled)
> +               tmp |= RTC_MATCH0_EN;
> +       else
> +               tmp &= ~RTC_MATCH0_EN;
> +
> +       rtc_writel(rtc, RTC_CTRL, tmp);
> +       spin_unlock_irq(&rtc->lock);
> +
> +       return 0;
> +}
> +
> +static irqreturn_t lpc32xx_rtc_alarm_interrupt(int irq, void *dev)
> +{
> +       struct lpc32xx_rtc *rtc = (struct lpc32xx_rtc *) dev;
> +
> +       spin_lock(&rtc->lock);
> +
> +       /* Disable alarm interrupt */
> +       rtc_writel(rtc, RTC_CTRL,
> +               rtc_readl(rtc, RTC_CTRL) & ~RTC_MATCH0_EN);
> +       rtc->alarm_enabled = 0;
> +
> +       /*
> +        * Write a large value to the match value so the RTC won't
> +        * keep firing the match status
> +        */
> +       rtc_writel(rtc, RTC_MATCH0, 0xFFFFFFFF);
> +       rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
> +
> +       spin_unlock(&rtc->lock);
> +
> +       rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_AF);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static const struct rtc_class_ops lpc32xx_rtc_ops = {
> +       .read_time              = lpc32xx_rtc_read_time,
> +       .set_mmss               = lpc32xx_rtc_set_mmss,
> +       .read_alarm             = lpc32xx_rtc_read_alarm,
> +       .set_alarm              = lpc32xx_rtc_set_alarm,
> +       .alarm_irq_enable       = lpc32xx_rtc_alarm_irq_enable,
> +};
> +
> +static int __devinit lpc32xx_rtc_probe(struct platform_device *pdev)
> +{
> +       struct resource *res, *mem = NULL;
> +       struct lpc32xx_rtc *rtc = NULL;
> +       int rtcirq, retval;
> +       u32 tmp;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               dev_err(&pdev->dev, "Can't get memory resource\n");
> +               return -ENOENT;
> +       }
> +
> +       rtcirq = platform_get_irq(pdev, 0);
> +       if ((rtcirq < 0) || (rtcirq >= NR_IRQS)) {
> +               dev_err(&pdev->dev, "Can't get interrupt resource\n");
> +               return -ENOENT;
> +       }
> +
> +       rtc = kzalloc(sizeof(struct lpc32xx_rtc), GFP_KERNEL);
> +       if (unlikely(!rtc)) {
> +               dev_err(&pdev->dev, "Can't allocate memory\n");
> +               return -ENOMEM;
> +       }
> +       rtc->irq = rtcirq;
> +
> +       mem = request_mem_region(res->start, resource_size(res), pdev->name);
> +       if (!mem) {
> +               dev_err(&pdev->dev, "RTC registers are not free\n");
> +               retval = -EBUSY;
> +               goto err_reqmem;
> +       }
> +
> +       rtc->rtc_base = ioremap(res->start, res->end - res->start + 1);

Use resource_size(res) here.

> +       if (!rtc->rtc_base) {
> +               dev_err(&pdev->dev, "Can't map memory\n");
> +               retval = -EIO;
> +               goto err_noremap;
> +       }
> +
> +       spin_lock_init(&rtc->lock);
> +
> +       /*
> +        * The RTC is on a seperate power domain and can keep it's state
> +        * across a chip power cycle. If the RTC has never been previously
> +        * setup, then set it up now for the first time.
> +        */
> +       if (rtc_readl(rtc, RTC_KEY) == RTC_KEY_ONSW_LOADVAL) {
> +               tmp = rtc_readl(rtc, RTC_CTRL);
> +               tmp &= ~(RTC_SW_RESET | RTC_CNTR_DIS | RTC_MATCH0_EN |
> +                       RTC_MATCH1_EN | RTC_ONSW_MATCH0_EN |
> +                       RTC_ONSW_MATCH1_EN | RTC_ONSW_FORCE_HIGH);
> +               rtc_writel(rtc, RTC_CTRL, tmp);
> +
> +               /* Clear latched interrupt states */
> +               rtc_writel(rtc, RTC_MATCH0, 0xFFFFFFFF);
> +               rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS |
> +                       RTC_MATCH1_INT_STS | RTC_ONSW_INT_STS);
> +
> +               /* Write key value to RTC so it won't reload on reset */
> +               rtc_writel(rtc, RTC_KEY, RTC_KEY_ONSW_LOADVAL);
> +       } else if (rtc_readl(rtc, RTC_CTRL) & RTC_MATCH0_EN)
> +               rtc->alarm_enabled = 1;
> +
> +       platform_set_drvdata(pdev, rtc);
> +
> +       device_init_wakeup(&pdev->dev, 1);
> +       rtc->rtc = rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
> +               THIS_MODULE);
> +       if (IS_ERR(rtc->rtc)) {
> +               dev_err(&pdev->dev, "Can't get RTC\n");
> +               retval = PTR_ERR(rtc->rtc);
> +               goto err_noreg;
> +       }
> +
> +       retval = request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> +               IRQF_DISABLED, "rtcalarm", rtc);
> +       if (retval < 0) {
> +               dev_err(&pdev->dev, "Can't request interrupt\n");
> +               goto err_free_irq;
> +       }
> +
> +       return 0;
> +
> +err_free_irq:
> +       rtc_device_unregister(rtc->rtc);
> +err_noreg:
> +       iounmap(rtc->rtc_base);
> +err_noremap:
> +       release_resource(mem);
> +err_reqmem:
> +       kfree(rtc);
> +
> +       return retval;
> +}
> +
> +static int __devexit lpc32xx_rtc_remove(struct platform_device *pdev)
> +{
> +       struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
> +
> +       free_irq(rtc->irq, pdev);
> +       rtc_device_unregister(rtc->rtc);
> +       iounmap(rtc->rtc_base);
> +       release_resource(dev_get_drvdata(&rtc->rtc->dev));
> +       kfree(rtc);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int lpc32xx_rtc_suspend(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
> +
> +       if (device_may_wakeup(&pdev->dev))
> +               enable_irq_wake(rtc->irq);
> +       else
> +               disable_irq_wake(rtc->irq);
> +
> +       return 0;
> +}
> +
> +static int lpc32xx_rtc_resume(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
> +
> +       if (device_may_wakeup(&pdev->dev))
> +               disable_irq_wake(rtc->irq);
> +
> +       return 0;
> +}
> +
> +/* Unconditionally disable the alarm */
> +static int lpc32xx_rtc_freeze(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
> +
> +       spin_lock_irq(&rtc->lock);
> +
> +       rtc_writel(rtc, RTC_CTRL,
> +               rtc_readl(rtc, RTC_CTRL) & ~RTC_MATCH0_EN);
> +
> +       spin_unlock_irq(&rtc->lock);
> +
> +       return 0;
> +}
> +
> +static int lpc32xx_rtc_thaw(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct lpc32xx_rtc *rtc = platform_get_drvdata(pdev);
> +
> +       if (rtc->alarm_enabled)
> +               rtc_writel(rtc, RTC_CTRL,
> +                       rtc_readl(rtc, RTC_CTRL) | RTC_MATCH0_EN);
> +
> +       return 0;
> +}
> +
> +#else
> +#define lpc32xx_rtc_suspend NULL
> +#define lpc32xx_rtc_resume NULL
> +#define lpc32xx_rtc_freeze NULL
> +#define lpc32xx_rtc_thaw NULL
> +#endif
> +
> +static const struct dev_pm_ops lpc32xx_rtc_pm_ops = {
> +       .suspend = lpc32xx_rtc_suspend,
> +       .resume = lpc32xx_rtc_resume,
> +       .freeze = lpc32xx_rtc_freeze,
> +       .thaw = lpc32xx_rtc_thaw,
> +       .restore = lpc32xx_rtc_resume
> +};
> +
> +static struct platform_driver lpc32xx_rtc_driver = {
> +       .probe          = lpc32xx_rtc_probe,
> +       .remove         = __devexit_p(lpc32xx_rtc_remove),
> +       .driver = {
> +               .name = RTC_NAME,
> +               .pm = &lpc32xx_rtc_pm_ops,
> +       },
> +};
> +
> +static int __init lpc32xx_rtc_init(void)
> +{
> +       return platform_driver_register(&lpc32xx_rtc_driver);
> +}
> +
> +static void __exit lpc32xx_rtc_exit(void)
> +{
> +       platform_driver_unregister(&lpc32xx_rtc_driver);
> +}
> +
> +module_init(lpc32xx_rtc_init);
> +module_exit(lpc32xx_rtc_exit);
> +
> +MODULE_AUTHOR("Kevin Wells <wellsk40@gmail.com");
> +MODULE_DESCRIPTION("RTC driver for the LPC32xx SoC");
> +MODULE_LICENSE("GPL");
> --
> 1.7.1.1
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
