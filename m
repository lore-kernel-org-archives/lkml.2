Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab0KLWx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:53:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KLWxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pK2c6/LcGGyMGclUrh29R71u9U02+6NhZeYCKC7wweQ2ssZ8bZlqyAWB7b0mYk4TyN
         kNVO/a4BD/WPcuyBG4xT9zIqkMFNwnTlJT66qVNpgJedTiotIbjY1B1wflMHUmqCBBYf
         6HK8r1wytK86Xs8NxZFw+aHy0r+piOHlobK/w=
MIME-Version: 1.0
In-Reply-To: <1289147348-31969-5-git-send-email-alchark@gmail.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<1289147348-31969-5-git-send-email-alchark@gmail.com>
Date: Sat, 13 Nov 2010 01:53:22 +0300
Message-ID: <AANLkTimeaf4-Rg6s94rwq+ByVnWChc-JCJGPorqdcP4O@mail.gmail.com>
Subject: Re: [PATCH 5/6 v2] rtc: Add support for the RTC in VIA VT8500 and compatibles
From: Alexey Charkov <alchark@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alexey Charkov <alchark@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/7 Alexey Charkov <alchark@gmail.com>:
> This adds a driver for the RTC devices in VIA and WonderMedia
> Systems-on-Chip. Alarm, 1Hz interrupts, reading and setting time
> are supported.
>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
>
> Please review and (if appropriate) commit to a relevant git tree for
> further integration in 2.6.38.
>
> Compared to the previous submission, this code just contains a rebase
> against the latest changes introduced in 2.6.37 merge window.
>
> Relevant platform definitions are introduced by PATCH 1/6 in this series,
> so one would need that to make use of this code.
>
> Due credits go to the community for providing feedback, advice and
> testing.
>
>  drivers/rtc/Kconfig      |    7 +
>  drivers/rtc/Makefile     |    1 +
>  drivers/rtc/rtc-vt8500.c |  363 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 371 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-vt8500.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 2883428..27ed129 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -865,6 +865,13 @@ config RTC_DRV_PXA
>          This RTC driver uses PXA RTC registers available since pxa27x
>          series (RDxR, RYxR) instead of legacy RCNR, RTAR.
>
> +config RTC_DRV_VT8500
> +       tristate "VIA/WonderMedia 85xx SoC RTC"
> +       depends on ARCH_VT8500
> +       help
> +         If you say Y here you will get access to the real time clock
> +         built into your VIA VT8500 SoC or its relatives.
> +
>
>  config RTC_DRV_SUN4V
>        bool "SUN4V Hypervisor RTC"
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 4c2832d..1a354e1 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -97,6 +97,7 @@ obj-$(CONFIG_RTC_DRV_TWL4030) += rtc-twl.o
>  obj-$(CONFIG_RTC_DRV_TX4939)   += rtc-tx4939.o
>  obj-$(CONFIG_RTC_DRV_V3020)    += rtc-v3020.o
>  obj-$(CONFIG_RTC_DRV_VR41XX)   += rtc-vr41xx.o
> +obj-$(CONFIG_RTC_DRV_VT8500)   += rtc-vt8500.o
>  obj-$(CONFIG_RTC_DRV_WM831X)   += rtc-wm831x.o
>  obj-$(CONFIG_RTC_DRV_WM8350)   += rtc-wm8350.o
>  obj-$(CONFIG_RTC_DRV_X1205)    += rtc-x1205.o
> diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
> new file mode 100644
> index 0000000..7260c95
> --- /dev/null
> +++ b/drivers/rtc/rtc-vt8500.c
> @@ -0,0 +1,363 @@
> +/*
> + * drivers/rtc/rtc-vt8500.c
> + *
> + *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
> + *
> + * Based on rtc-pxa.c
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/rtc.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/bcd.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +/*
> + * Register definitions
> + */
> +#define VT8500_RTC_TS          0x00    /* Time set */
> +#define VT8500_RTC_DS          0x04    /* Date set */
> +#define VT8500_RTC_AS          0x08    /* Alarm set */
> +#define VT8500_RTC_CR          0x0c    /* Control */
> +#define VT8500_RTC_TR          0x10    /* Time read */
> +#define VT8500_RTC_DR          0x14    /* Date read */
> +#define VT8500_RTC_WS          0x18    /* Write status */
> +#define VT8500_RTC_CL          0x20    /* Calibration */
> +#define VT8500_RTC_IS          0x24    /* Interrupt status */
> +#define VT8500_RTC_ST          0x28    /* Status */
> +
> +#define INVALID_TIME_BIT       (1 << 31)
> +
> +#define DATE_CENTURY_S         19
> +#define DATE_YEAR_S            11
> +#define DATE_YEAR_MASK         (0xff << DATE_YEAR_S)
> +#define DATE_MONTH_S           6
> +#define DATE_MONTH_MASK                (0x1f << DATE_MONTH_S)
> +#define DATE_DAY_MASK          0x3f
> +
> +#define TIME_DOW_S             20
> +#define TIME_DOW_MASK          (0x07 << TIME_DOW_S)
> +#define TIME_HOUR_S            14
> +#define TIME_HOUR_MASK         (0x3f << TIME_HOUR_S)
> +#define TIME_MIN_S             7
> +#define TIME_MIN_MASK          (0x7f << TIME_MIN_S)
> +#define TIME_SEC_MASK          0x7f
> +
> +#define ALARM_DAY_S            20
> +#define ALARM_DAY_MASK         (0x3f << ALARM_DAY_S)
> +
> +#define ALARM_DAY_BIT          (1 << 29)
> +#define ALARM_HOUR_BIT         (1 << 28)
> +#define ALARM_MIN_BIT          (1 << 27)
> +#define ALARM_SEC_BIT          (1 << 26)
> +
> +#define ALARM_ENABLE_MASK      (ALARM_DAY_BIT \
> +                               | ALARM_HOUR_BIT \
> +                               | ALARM_MIN_BIT \
> +                               | ALARM_SEC_BIT)
> +
> +struct vt8500_rtc {
> +       void __iomem            *regbase;
> +       int                     irq_alarm;
> +       int                     irq_hz;
> +       struct rtc_device       *rtc;
> +       spinlock_t              lock;           /* Protects this structure */
> +       struct rtc_time         rtc_alarm;
> +};
> +
> +static irqreturn_t vt8500_rtc_irq(int irq, void *dev_id)
> +{
> +       struct platform_device *pdev = to_platform_device(dev_id);
> +       struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
> +       u32 isr;
> +       unsigned long events = 0;
> +
> +       spin_lock(&vt8500_rtc->lock);
> +
> +       /* clear interrupt sources */
> +       isr = readl(vt8500_rtc->regbase + VT8500_RTC_IS);
> +       writel(isr, vt8500_rtc->regbase + VT8500_RTC_IS);
> +
> +       if (isr & 1)
> +               events |= RTC_AF | RTC_IRQF;
> +
> +       /* Only second/minute interrupts are supported */
> +       if (isr & 2)
> +               events |= RTC_UF | RTC_IRQF;
> +
> +       rtc_update_irq(vt8500_rtc->rtc, 1, events);
> +
> +       spin_unlock(&vt8500_rtc->lock);
> +       return IRQ_HANDLED;
> +}
> +
> +static int vt8500_rtc_open(struct device *dev)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = request_irq(vt8500_rtc->irq_hz, vt8500_rtc_irq, IRQF_DISABLED,
> +                         "rtc 1Hz", dev);
> +       if (ret < 0) {
> +               dev_err(dev, "can't get irq %i, err %d\n", vt8500_rtc->irq_hz,
> +                       ret);
> +               goto err_irq_hz;
> +       }
> +       ret = request_irq(vt8500_rtc->irq_alarm, vt8500_rtc_irq, IRQF_DISABLED,
> +                         "rtc alarm", dev);
> +       if (ret < 0) {
> +               dev_err(dev, "can't get irq %i, err %d\n",
> +                       vt8500_rtc->irq_alarm, ret);
> +               goto err_irq_alarm;
> +       }
> +       return 0;
> +
> +err_irq_alarm:
> +       free_irq(vt8500_rtc->irq_hz, dev);
> +err_irq_hz:
> +       return ret;
> +}
> +
> +static void vt8500_rtc_release(struct device *dev)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +
> +       spin_lock_irq(&vt8500_rtc->lock);
> +       /* Disable alarm matching */
> +       writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
> +       spin_unlock_irq(&vt8500_rtc->lock);
> +
> +       free_irq(vt8500_rtc->irq_alarm, dev);
> +       free_irq(vt8500_rtc->irq_hz, dev);
> +}
> +
> +static int vt8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +       u32 date, time;
> +
> +       date = readl(vt8500_rtc->regbase + VT8500_RTC_DR);
> +       time = readl(vt8500_rtc->regbase + VT8500_RTC_TR);
> +
> +       tm->tm_sec = bcd2bin(time & TIME_SEC_MASK);
> +       tm->tm_min = bcd2bin((time & TIME_MIN_MASK) >> TIME_MIN_S);
> +       tm->tm_hour = bcd2bin((time & TIME_HOUR_MASK) >> TIME_HOUR_S);
> +       tm->tm_mday = bcd2bin(date & DATE_DAY_MASK);
> +       tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S);
> +       tm->tm_year = bcd2bin((date & DATE_YEAR_MASK) >> DATE_YEAR_S);
> +       tm->tm_wday = (time & TIME_DOW_MASK) >> TIME_DOW_S;
> +
> +       return 0;
> +}
> +
> +static int vt8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +
> +       writel((bin2bcd(tm->tm_year) << DATE_YEAR_S)
> +               | (bin2bcd(tm->tm_mon) << DATE_MONTH_S)
> +               | (bin2bcd(tm->tm_mday)),
> +               vt8500_rtc->regbase + VT8500_RTC_DS);
> +       writel((bin2bcd(tm->tm_wday) << TIME_DOW_S)
> +               | (bin2bcd(tm->tm_hour) << TIME_HOUR_S)
> +               | (bin2bcd(tm->tm_min) << TIME_MIN_S)
> +               | (bin2bcd(tm->tm_sec)),
> +               vt8500_rtc->regbase + VT8500_RTC_TS);
> +
> +       return 0;
> +}
> +
> +static int vt8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +       u32 isr, alarm;
> +
> +       alarm = readl(vt8500_rtc->regbase + VT8500_RTC_AS);
> +       isr = readl(vt8500_rtc->regbase + VT8500_RTC_IS);
> +
> +       alrm->time.tm_mday = bcd2bin((alarm & ALARM_DAY_MASK) >> ALARM_DAY_S);
> +       alrm->time.tm_hour = bcd2bin((alarm & TIME_HOUR_MASK) >> TIME_HOUR_S);
> +       alrm->time.tm_min = bcd2bin((alarm & TIME_MIN_MASK) >> TIME_MIN_S);
> +       alrm->time.tm_sec = bcd2bin((alarm & TIME_SEC_MASK));
> +
> +       alrm->enabled = (alarm & ALARM_ENABLE_MASK) ? 1 : 0;
> +
> +       alrm->pending = (isr & 1) ? 1 : 0;
> +       return 0;
> +}
> +
> +static int vt8500_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +
> +       writel((alrm->enabled ? ALARM_ENABLE_MASK : 0)
> +               | (bin2bcd(alrm->time.tm_mday) << ALARM_DAY_S)
> +               | (bin2bcd(alrm->time.tm_hour) << TIME_HOUR_S)
> +               | (bin2bcd(alrm->time.tm_min) << TIME_MIN_S)
> +               | (bin2bcd(alrm->time.tm_sec)),
> +               vt8500_rtc->regbase + VT8500_RTC_AS);
> +
> +       return 0;
> +}
> +
> +static int vt8500_rtc_ioctl(struct device *dev, unsigned int cmd,
> +               unsigned long arg)
> +{
> +       struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
> +       int ret = 0;
> +       unsigned long tmp;
> +
> +       spin_lock_irq(&vt8500_rtc->lock);
> +       switch (cmd) {
> +       case RTC_AIE_OFF:
> +               tmp = readl(vt8500_rtc->regbase + VT8500_RTC_AS);
> +               writel(tmp & ~ALARM_ENABLE_MASK,
> +                      vt8500_rtc->regbase + VT8500_RTC_AS);
> +               break;
> +       case RTC_AIE_ON:
> +               tmp = readl(vt8500_rtc->regbase + VT8500_RTC_AS);
> +               writel(tmp | ALARM_ENABLE_MASK,
> +                      vt8500_rtc->regbase + VT8500_RTC_AS);
> +               break;
> +       case RTC_UIE_OFF:
> +               tmp = readl(vt8500_rtc->regbase + VT8500_RTC_CR);
> +               writel(tmp & ~(1 << 2),
> +                      vt8500_rtc->regbase + VT8500_RTC_CR);
> +               break;
> +       case RTC_UIE_ON:
> +               tmp = readl(vt8500_rtc->regbase + VT8500_RTC_CR);
> +               writel(tmp | ((1 << 3) | (1 << 2)),
> +                      vt8500_rtc->regbase + VT8500_RTC_CR);
> +               break;
> +       default:
> +               ret = -ENOIOCTLCMD;
> +       }
> +
> +       spin_unlock_irq(&vt8500_rtc->lock);
> +       return ret;
> +}
> +
> +static const struct rtc_class_ops vt8500_rtc_ops = {
> +       .open = vt8500_rtc_open,
> +       .release = vt8500_rtc_release,
> +       .ioctl = vt8500_rtc_ioctl,
> +       .read_time = vt8500_rtc_read_time,
> +       .set_time = vt8500_rtc_set_time,
> +       .read_alarm = vt8500_rtc_read_alarm,
> +       .set_alarm = vt8500_rtc_set_alarm,
> +};
> +
> +static int __init vt8500_rtc_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct vt8500_rtc *vt8500_rtc;
> +       struct resource *res;
> +       int ret;
> +
> +       vt8500_rtc = kzalloc(sizeof(struct vt8500_rtc), GFP_KERNEL);
> +       if (!vt8500_rtc)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&vt8500_rtc->lock);
> +       platform_set_drvdata(pdev, vt8500_rtc);
> +
> +       ret = -ENXIO;
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               dev_err(dev, "No I/O memory resource defined\n");
> +               goto err_map;
> +       }
> +
> +       vt8500_rtc->irq_alarm = platform_get_irq(pdev, 0);
> +       if (vt8500_rtc->irq_alarm < 0) {
> +               dev_err(dev, "No alarm IRQ resource defined\n");
> +               goto err_map;
> +       }
> +
> +       vt8500_rtc->irq_hz = platform_get_irq(pdev, 1);
> +       if (vt8500_rtc->irq_hz < 0) {
> +               dev_err(dev, "No 1Hz IRQ resource defined\n");
> +               goto err_map;
> +       }
> +
> +       ret = -ENOMEM;
> +       vt8500_rtc->regbase = ioremap(res->start, resource_size(res));
> +       if (!vt8500_rtc->regbase) {
> +               dev_err(&pdev->dev, "Unable to map RTC I/O memory\n");
> +               goto err_map;
> +       }
> +
> +       /* Enable the second/minute interrupt generation and enable RTC */
> +       writel((1 << 3) | (1 << 2) | 1, vt8500_rtc->regbase + VT8500_RTC_CR);
> +
> +       vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
> +                                             &vt8500_rtc_ops, THIS_MODULE);
> +       ret = PTR_ERR(vt8500_rtc->rtc);
> +       if (IS_ERR(vt8500_rtc->rtc)) {
> +               dev_err(dev, "Failed to register RTC device -> %d\n", ret);
> +               goto err_rtc_reg;
> +       }
> +
> +       device_init_wakeup(dev, 1);
> +
> +       return 0;
> +
> +err_rtc_reg:
> +       iounmap(vt8500_rtc->regbase);
> +err_map:
> +       kfree(vt8500_rtc);
> +       return ret;
> +}
> +
> +static int __exit vt8500_rtc_remove(struct platform_device *pdev)
> +{
> +       struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
> +
> +       rtc_device_unregister(vt8500_rtc->rtc);
> +
> +       spin_lock_irq(&vt8500_rtc->lock);
> +       iounmap(vt8500_rtc->regbase);
> +       spin_unlock_irq(&vt8500_rtc->lock);
> +
> +       kfree(vt8500_rtc);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver vt8500_rtc_driver = {
> +       .probe          = vt8500_rtc_probe,
> +       .remove         = __exit_p(vt8500_rtc_remove),
> +       .driver         = {
> +               .name   = "vt8500-rtc"
> +       },
> +};
> +
> +static int __init vt8500_rtc_init(void)
> +{
> +       return platform_driver_register(&vt8500_rtc_driver);
> +}
> +
> +static void __exit vt8500_rtc_exit(void)
> +{
> +       platform_driver_unregister(&vt8500_rtc_driver);
> +}
> +
> +module_init(vt8500_rtc_init);
> +module_exit(vt8500_rtc_exit);
> +
> +MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
> +MODULE_DESCRIPTION("VIA VT8500 SoC Realtime Clock Driver (RTC)");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:vt8500-rtc");
> --
> 1.7.3.2
>
>

Any comments about this?

Thanks,
Alexey
