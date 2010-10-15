Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab0JOWoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:44:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7412 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0JOWoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xbF68N3KBrBUotxDwVNrGUOS2iriFMoNtCMNOy9QIEYmjfkse0W4TFM2/+coim5A0O
         C6gvRYOkMCkwqixFZYtA==
MIME-Version: 1.0
In-Reply-To: <1287089791-25673-1-git-send-email-achew@nvidia.com>
References: <1287089791-25673-1-git-send-email-achew@nvidia.com>
Date: Fri, 15 Oct 2010 15:12:47 -0700
Message-ID: <AANLkTim1LQ5xE9fxT9JgKb4a7AKsnRF+3daHcSGBKK4O@mail.gmail.com>
Subject: Re: [PATCH 1/1 V2] rtc: Add real-time clock driver for Tegra.
From: Erik Gilling <konkers@google.com>
To: achew@nvidia.com
Cc: jmayo@nvidia.com, a.zummo@towertech.it, olof@lixom.net, greg@kroah.com,
        mcuos.com@gmail.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 1:56 PM,  <achew@nvidia.com> wrote:
> From: Andrew Chew <achew@nvidia.com>
>
> This is a platform driver that supports the built-in real-time clock on
> Tegra SOCs.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> Applied Wan ZongShun's corrections.
>
>  drivers/rtc/Kconfig     |   10 +
>  drivers/rtc/Makefile    |    1 +
>  drivers/rtc/rtc-tegra.c |  509 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 520 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-tegra.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 2432541..ca0da79 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -963,4 +963,14 @@ config RTC_DRV_JZ4740
>          This driver can also be buillt as a module. If so, the module
>          will be called rtc-jz4740.
>
> +config RTC_DRV_TEGRA
> +       tristate "NVIDIA Tegra Internal RTC driver"
> +       depends on RTC_CLASS && ARCH_TEGRA
> +       help
> +         If you say yes here you get support for the
> +         Tegra 200 series internal RTC module.
> +
> +         This drive can also be built as a module. If so, the module
> +         will be called rtc-tegra.
> +
>  endif # RTC_CLASS
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 4ff4b88..a7f3617 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -91,6 +91,7 @@ obj-$(CONFIG_RTC_DRV_STARFIRE)        += rtc-starfire.o
>  obj-$(CONFIG_RTC_DRV_STK17TA8) += rtc-stk17ta8.o
>  obj-$(CONFIG_RTC_DRV_STMP)     += rtc-stmp3xxx.o
>  obj-$(CONFIG_RTC_DRV_SUN4V)    += rtc-sun4v.o
> +obj-$(CONFIG_RTC_DRV_TEGRA)    += rtc-tegra.o
>  obj-$(CONFIG_RTC_DRV_TEST)     += rtc-test.o
>  obj-$(CONFIG_RTC_DRV_TWL4030)  += rtc-twl.o
>  obj-$(CONFIG_RTC_DRV_TX4939)   += rtc-tx4939.o
> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
> new file mode 100644
> index 0000000..c3d23e6
> --- /dev/null
> +++ b/drivers/rtc/rtc-tegra.c
> @@ -0,0 +1,509 @@
> +/*
> + * An RTC driver for the NVIDIA Tegra 200 series internal RTC.
> + *
> + * Copyright (c) 2010, NVIDIA Corporation.
> + * Copyright (c) 2010 Jon Mayo <jmayo@nvidia.com>

This is kinda odd.  Usually when doing work on behalf of the company
you work for, the code is (c) the company.  Consider changing Jon's
line to "Author: Jon Mayo <jmayo@nvidia.com>"

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/rtc.h>
> +#include <linux/platform_device.h>
> +
> +/* how many attempts to wait in tegra_rtc_wait_while_busy(). */
> +#define RTC_TEGRA_RETRIES 15

This is only used once in tegra_rtc_wait_while_busy().  Consider just
setting the retry value there.

> +
> +/* STATUS: This bit is set when a write is initiated on the APB side. It is
> + * cleared once the write completes in RTC 32KHz clock domain which could be
> + * several thousands of APB clocks. This must be IDLE before a write is
> + * initiated. Note that this bit is only for writes.
> + * 0 = IDLE
> + * 1 = BUSY
> + */

nit: Consider renaming these #defines TEGRA_RTC to mach the rest of
the prefixes in this file

> +#define RTC_TEGRA_REG_BUSY                     0x004
> +#define RTC_TEGRA_REG_SECONDS                  0x008
> +#define RTC_TEGRA_REG_SHADOW_SECONDS           0x00c
> +#define RTC_TEGRA_REG_MILLI_SECONDS            0x010
> +#define RTC_TEGRA_REG_SECONDS_ALARM0           0x014
> +#define RTC_TEGRA_REG_SECONDS_ALARM1           0x018
> +#define RTC_TEGRA_REG_MILLI_SECONDS_ALARM0     0x01c
> +#define RTC_TEGRA_REG_INTR_MASK                        0x028
> +/* a write to this register performs a clear. reg=reg&(~x) */
> +#define RTC_TEGRA_REG_INTR_STATUS              0x02c
> +
> +/* bits in INTR_MASK */
> +#define RTC_TEGRA_INTR_MASK_MSEC_CDN_ALARM     (1<<4)
> +#define RTC_TEGRA_INTR_MASK_SEC_CDN_ALARM      (1<<3)
> +#define RTC_TEGRA_INTR_MASK_MSEC_ALARM         (1<<2)
> +#define RTC_TEGRA_INTR_MASK_SEC_ALARM1         (1<<1)
> +#define RTC_TEGRA_INTR_MASK_SEC_ALARM0         (1<<0)
> +
> +/* bits in INTR_STATUS */
> +#define RTC_TEGRA_INTR_STATUS_MSEC_CDN_ALARM   (1<<4)
> +#define RTC_TEGRA_INTR_STATUS_SEC_CDN_ALARM    (1<<3)
> +#define RTC_TEGRA_INTR_STATUS_MSEC_ALARM       (1<<2)
> +#define RTC_TEGRA_INTR_STATUS_SEC_ALARM1       (1<<1)
> +#define RTC_TEGRA_INTR_STATUS_SEC_ALARM0       (1<<0)
> +
> +struct tegra_rtc_info {
> +       struct platform_device  *pdev;
> +       struct rtc_device       *rtc_dev;
> +       void __iomem            *rtc_base; /* NULL if not initialized. */
> +       int                     tegra_rtc_irq; /* alarm and periodic irq */
> +       spinlock_t              tegra_rtc_lock;
> +};
> +
> +/* check is hardware is accessing APB. */

There are lots of these function header comments that just restate the
name of the function without adding any more information about the
function.  In my opinion this is just noise.

> +static inline u32 tegra_rtc_check_busy(struct tegra_rtc_info *info)
> +{
> +       return readl(info->rtc_base + RTC_TEGRA_REG_BUSY);
> +}
> +
> +/* wait for hardware to be ready for writing.
> + * do not call this inside the spin lock because it sleeps.
> + */
> +static int tegra_rtc_wait_while_busy(struct device *dev)
> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +
> +       /* TODO: wait for busy then not busy to catch a leading edge. */

You don't want to do that.  If there are no writes pending the busy
bit will never go high

> +       int retries = RTC_TEGRA_RETRIES;
> +
> +       while (tegra_rtc_check_busy(info)) {
> +               if (!retries--) {
> +                       dev_err(dev, "write failed:retry count exceeded.\n");
> +                       return -ETIMEDOUT;
> +               }
> +               msleep(1);
> +       }
> +
> +       return 0;
> +}
> +
> +/* waits for the RTC to not be busy accessing APB, then write a single value. */
> +static int tegra_rtc_write_not_busy(struct device *dev, unsigned ofs, u32 value)

nit: Since there's no tegra_rtc_write the _not_busy's not really
needed in the function name

> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       unsigned long sl_irq_flags;
> +       int ret;
> +
> +       spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +       if (tegra_rtc_check_busy(info)) {

Why don't you just call tegra_rtc_wait_while_busy here?

> +               spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +               ret = tegra_rtc_wait_while_busy(dev);
> +               if (ret)
> +                       return ret;
> +               spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +       }

There's a race where another write can cause the status to become busy
before you re-acquire the lock.  I would create a write mutex and hold
it for the duration of this function.

> +
> +       writel(value, info->rtc_base + ofs);
> +
> +       spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +       return 0;
> +}
> +
> +
> +static int tegra_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       unsigned long sec, msec;
> +       unsigned long sl_irq_flags;
> +
> +       spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);

What is this lock protecting here?

> +
> +       msec = readl(info->rtc_base + RTC_TEGRA_REG_MILLI_SECONDS);
> +       sec = readl(info->rtc_base + RTC_TEGRA_REG_SHADOW_SECONDS);
> +
> +       spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +       rtc_time_to_tm(sec, tm);
> +
> +       dev_vdbg(dev, "time read as %lu. %d/%d/%d %d:%02u:%02u\n",
> +               sec,
> +               tm->tm_mon + 1,
> +               tm->tm_mday,
> +               tm->tm_year + 1900,
> +               tm->tm_hour,
> +               tm->tm_min,
> +               tm->tm_sec
> +       );
> +
> +       return 0;
> +}
> +
> +static int tegra_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       unsigned long sec;
> +       int ret;
> +
> +       /* convert tm to seconds. */
> +       ret = rtc_valid_tm(tm);
> +       if (ret < 0)
> +               return ret;
> +
> +       rtc_tm_to_time(tm, &sec);
> +
> +       dev_vdbg(dev, "time set to %lu. %d/%d/%d %d:%02u:%02u\n",
> +               sec,
> +               tm->tm_mon+1,
> +               tm->tm_mday,
> +               tm->tm_year+1900,
> +               tm->tm_hour,
> +               tm->tm_min,
> +               tm->tm_sec
> +       );
> +
> +       /* seconds only written if wait succeeded. */
> +       ret = tegra_rtc_write_not_busy(dev, RTC_TEGRA_REG_SECONDS, sec);
> +
> +       dev_vdbg(dev, "time read back as %d\n",
> +               readl(info->rtc_base + RTC_TEGRA_REG_SECONDS));
> +
> +       return ret;
> +}
> +
> +static int tegra_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       unsigned long sec;
> +       unsigned long sl_irq_flags;
> +       unsigned tmp;
> +
> +       spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);

What is this lock protecting here?

> +
> +       sec = readl(info->rtc_base + RTC_TEGRA_REG_SECONDS_ALARM0);
> +
> +       spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +       if (sec == 0) {
> +               /* alarm is disabled. */
> +               alarm->enabled = 0;
> +               alarm->time.tm_mon = -1;
> +               alarm->time.tm_mday = -1;
> +               alarm->time.tm_year = -1;
> +               alarm->time.tm_hour = -1;
> +               alarm->time.tm_min = -1;
> +               alarm->time.tm_sec = -1;
> +       } else {
> +               /* alarm is enabled. */
> +               alarm->enabled = 1;
> +               rtc_time_to_tm(sec, &alarm->time);
> +       }
> +
> +       tmp = readl(info->rtc_base + RTC_TEGRA_REG_INTR_STATUS);
> +       alarm->pending = (tmp & RTC_TEGRA_INTR_STATUS_SEC_ALARM0) != 0;
> +
> +       return 0;
> +}
> +
> +static int tegra_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       unsigned status;
> +       unsigned long sl_irq_flags;
> +       int ret;
> +
> +       spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +       if (tegra_rtc_check_busy(info)) { /* wait for the busy bit to clear. */

See above comment about calling tegra_rtc_wait_while_busy() and the BUSY race.

> +               spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +               ret = tegra_rtc_wait_while_busy(dev);
> +               if (ret)
> +                       return ret;
> +               spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +       }
> +
> +       /* read the original value, and OR in the flag. */
> +       status = readl(info->rtc_base + RTC_TEGRA_REG_INTR_MASK);
> +       if (enabled)
> +               status |= RTC_TEGRA_INTR_MASK_SEC_ALARM0; /* set it */
> +       else
> +               status &= ~RTC_TEGRA_INTR_MASK_SEC_ALARM0; /* clear it */
> +
> +       writel(status, info->rtc_base + RTC_TEGRA_REG_INTR_MASK);
> +
> +       spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +
> +       return 0;
> +}
> +
> +static int tegra_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       int ret;
> +       unsigned long sec;
> +
> +       if (alarm->enabled)
> +               rtc_tm_to_time(&alarm->time, &sec);
> +       else
> +               sec = 0;
> +
> +       ret = tegra_rtc_write_not_busy(dev, RTC_TEGRA_REG_SECONDS_ALARM0, sec);
> +       dev_vdbg(dev, "alarm read back as %d\n",
> +               readl(info->rtc_base + RTC_TEGRA_REG_SECONDS_ALARM0));
> +
> +       /* if successfully written and alarm is enabled ... */
> +       if ((ret == 0) && sec) {
> +               tegra_rtc_alarm_irq_enable(dev, 1);
> +
> +               dev_vdbg(dev, "alarm set as %lu. %d/%d/%d %d:%02u:%02u\n",
> +                       sec,
> +                       alarm->time.tm_mon+1,
> +                       alarm->time.tm_mday,
> +                       alarm->time.tm_year+1900,
> +                       alarm->time.tm_hour,
> +                       alarm->time.tm_min,
> +                       alarm->time.tm_sec);
> +       } else {
> +               /* disable alarm if 0 or write error. */
> +               dev_vdbg(dev, "alarm disabled\n");
> +               tegra_rtc_alarm_irq_enable(dev, 0);
> +       }
> +
> +       return ret;
> +}
> +
> +/* additional proc lines. */
> +static int tegra_rtc_proc(struct device *dev, struct seq_file *seq)
> +{
> +       if (!dev || !dev->driver)
> +               return 0;
> +
> +       return seq_printf(seq, "name\t\t: %s\n", dev_name(dev));
> +}
> +
> +static irqreturn_t tegra_rtc_irq_handler(int irq, void *data)
> +{
> +       struct device *dev = data;
> +       struct tegra_rtc_info *info = dev_get_drvdata(dev);
> +       unsigned long events = 0;
> +       unsigned status;
> +       unsigned long sl_irq_flags;
> +
> +       status = readl(info->rtc_base + RTC_TEGRA_REG_INTR_STATUS);
> +       if (status) {
> +               /* clear the interrupt masks and status on any irq. */
> +               spin_lock_irqsave(&info->tegra_rtc_lock, sl_irq_flags);
> +               writel(0, info->rtc_base + RTC_TEGRA_REG_INTR_MASK);
> +               writel(0xffffffff, info->rtc_base + RTC_TEGRA_REG_INTR_STATUS);

Why are these writes not protected by polling busy?  You might need to
move this to a work function so that the wait can sleep or have the
busy function call udelay.

Do you mean to be clearing all interrupts here or just the ones from
status.  You could lose ones that happened between reading status and
here.

> +               spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
> +       }
> +
> +       /* check if Alarm */
> +       if ((status & RTC_TEGRA_INTR_STATUS_SEC_ALARM0))
> +               events |= RTC_IRQF | RTC_AF;
> +
> +       /* check if Periodic */
> +       if ((status & RTC_TEGRA_INTR_STATUS_SEC_CDN_ALARM))
> +               events |= RTC_IRQF | RTC_PF;
> +
> +       rtc_update_irq(info->rtc_dev, 1, events);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static struct rtc_class_ops tegra_rtc_ops = {
> +       .read_time      = tegra_rtc_read_time,
> +       .set_time       = tegra_rtc_set_time,
> +       .read_alarm     = tegra_rtc_read_alarm,
> +       .set_alarm      = tegra_rtc_set_alarm,
> +       .proc           = tegra_rtc_proc,
> +       .alarm_irq_enable = tegra_rtc_alarm_irq_enable,
> +};
> +
> +static int __devinit tegra_rtc_probe(struct platform_device *pdev)
> +{
> +       struct tegra_rtc_info *info;
> +       struct resource *res;
> +       int ret;
> +
> +       info = kzalloc(sizeof(struct tegra_rtc_info), GFP_KERNEL);
> +       if (!info)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               dev_err(&pdev->dev,
> +                       "Unable to allocate resources for device.\n");
> +               ret = -EBUSY;
> +               goto err_free_info;
> +       }

You need a request_mem_region() here.

> +
> +       info->tegra_rtc_irq = platform_get_irq(pdev, 0);
> +       if (info->tegra_rtc_irq <= 0) {
> +               ret = -EBUSY;
> +               goto err_free_info;
> +       }
> +
> +       info->rtc_base = ioremap(res->start, res->end - res->start + 1);
> +       if (!info->rtc_base) {
> +               dev_err(&pdev->dev, "Unable to grab IOs for device.\n");
> +               ret = -EBUSY;
> +               goto err_free_info;
> +       }
> +
> +       /* set context info. */
> +       info->pdev = pdev;
> +       info->tegra_rtc_lock = __SPIN_LOCK_UNLOCKED(info->tegra_rtc_lock);
> +
> +       platform_set_drvdata(pdev, info);
> +
> +       /* clear out the hardware. */
> +       tegra_rtc_write_not_busy(&pdev->dev, RTC_TEGRA_REG_SECONDS_ALARM0, 0);
> +       tegra_rtc_write_not_busy(&pdev->dev, RTC_TEGRA_REG_INTR_STATUS,
> +                                0xffffffff);
> +       tegra_rtc_write_not_busy(&pdev->dev, RTC_TEGRA_REG_INTR_MASK, 0);
> +
> +       device_init_wakeup(&pdev->dev, 1);
> +
> +       info->rtc_dev = rtc_device_register(
> +               pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
> +       if (IS_ERR(info->rtc_dev)) {
> +               ret = PTR_ERR(info->rtc_dev);
> +               info->rtc_dev = NULL;
> +               dev_err(&pdev->dev,
> +                       "Unable to register device (err=%d).\n",
> +                       ret);
> +               goto err_iounmap;
> +       }
> +
> +       ret = request_irq(info->tegra_rtc_irq, tegra_rtc_irq_handler,
> +               IRQF_TRIGGER_HIGH, "rtc alarm", &pdev->dev);
> +       if (ret) {
> +               dev_err(&pdev->dev,
> +                       "Unable to request interrupt for device (err=%d).\n",
> +                       ret);
> +               goto err_dev_unreg;
> +       }
> +
> +       dev_notice(&pdev->dev, "Tegra internal Real Time Clock\n");
> +
> +       return 0;
> +
> +err_dev_unreg:
> +       rtc_device_unregister(info->rtc_dev);
> +err_iounmap:
> +       iounmap(info->rtc_base);
> +err_free_info:
> +       kfree(info);
> +
> +       return ret;
> +}
> +
> +static int __devexit tegra_rtc_remove(struct platform_device *pdev)
> +{
> +       struct tegra_rtc_info *info = platform_get_drvdata(pdev);
> +
> +       free_irq(info->tegra_rtc_irq, &pdev->dev);
> +       rtc_device_unregister(info->rtc_dev);
> +       iounmap(info->rtc_base);
> +       kfree(info);
> +
> +       platform_set_drvdata(pdev, NULL);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct tegra_rtc_info *info = platform_get_drvdata(pdev);
> +
> +       /* only use ALARM0 as a wake source. */

Why are these writes not protected by the BUSY flag?

> +       writel(0xffffffff, info->rtc_base + RTC_TEGRA_REG_INTR_STATUS);
> +       writel(RTC_TEGRA_INTR_STATUS_SEC_ALARM0,
> +               info->rtc_base + RTC_TEGRA_REG_INTR_MASK);
> +
> +       dev_vdbg(dev, "alarm sec = %d\n",
> +               readl(info->rtc_base + RTC_TEGRA_REG_SECONDS_ALARM0));
> +
> +       dev_vdbg(dev, "Suspend (device_may_wakeup=%d) irq:%d\n",
> +               device_may_wakeup(dev), info->tegra_rtc_irq);
> +
> +       /* leave the alarms on as a wake source. */
> +       if (device_may_wakeup(dev))
> +               enable_irq_wake(info->tegra_rtc_irq);
> +
> +       return 0;
> +}
> +
> +static int tegra_rtc_resume(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct tegra_rtc_info *info = platform_get_drvdata(pdev);
> +       unsigned int intr_status;
> +
> +       /* clear */
> +       intr_status = readl(info->rtc_base + RTC_TEGRA_REG_INTR_STATUS);
> +       if (intr_status & RTC_TEGRA_INTR_STATUS_SEC_ALARM0) {
> +               tegra_rtc_write_not_busy(dev, RTC_TEGRA_REG_INTR_MASK, 0);
> +               tegra_rtc_write_not_busy(dev, RTC_TEGRA_REG_INTR_STATUS,
> +                                        0xffffffff);
> +       }
> +
> +       dev_vdbg(dev, "Resume (device_may_wakeup=%d)\n",
> +               device_may_wakeup(dev));
> +       /* alarms were left on as a wake source, turn them off. */
> +       if (device_may_wakeup(dev))
> +               disable_irq_wake(info->tegra_rtc_irq);
> +
> +       return 0;
> +}
> +#endif
> +
> +static void tegra_rtc_shutdown(struct platform_device *pdev)
> +{
> +       dev_vdbg(&pdev->dev, "disabling interrupts.\n");
> +       tegra_rtc_alarm_irq_enable(&pdev->dev, 0);
> +}
> +
> +MODULE_ALIAS("platform:tegra_rtc");
> +static struct platform_driver tegra_rtc_driver = {
> +       .remove         = __devexit_p(tegra_rtc_remove),
> +       .shutdown       = tegra_rtc_shutdown,
> +       .driver         = {
> +               .name   = "tegra_rtc",
> +               .owner  = THIS_MODULE,
> +       },
> +#ifdef CONFIG_PM
> +       .suspend        = tegra_rtc_suspend,
> +       .resume         = tegra_rtc_resume,
> +#endif
> +};
> +
> +static int __init tegra_rtc_init(void)
> +{
> +       return platform_driver_probe(&tegra_rtc_driver, tegra_rtc_probe);
> +}
> +module_init(tegra_rtc_init);
> +
> +static void __exit tegra_rtc_exit(void)
> +{
> +       platform_driver_unregister(&tegra_rtc_driver);
> +}
> +module_exit(tegra_rtc_exit);
> +
> +MODULE_DESCRIPTION("driver for Tegra internal RTC");
> +MODULE_LICENSE("GPL");
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
