Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab2LUMqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:46:51 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:57639 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2LUMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <1356082135-14549-1-git-send-email-ldewangan@nvidia.com>
References: <1356082135-14549-1-git-send-email-ldewangan@nvidia.com>
Date: Fri, 21 Dec 2012 18:16:36 +0530
Message-ID: <CAHdPZaPJpB4Rzg1=DQr4udmp3-WCo8YLXVqribBw2o6HRiVU2Q@mail.gmail.com>
Subject: Re: [PATCH] rtc: add RTC driver for TPS6586x
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Andrew Morton <akpm@linuxfoundation.org>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC Andrew Morton, as he is maintaining rtc subsystem]

On Fri, Dec 21, 2012 at 2:58 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Add an RTC driver for TPS6586X chips by TI.
> This driver supports:
> - Setting and getting time and date.
> - Setting and reading alarm time.
> - Alarm and interrupt functionlity.
>

Nice code, some minor comments :)

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>

> diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
> new file mode 100644
> index 0000000..63da069
> --- /dev/null
> +++ b/drivers/rtc/rtc-tps6586x.c
> @@ -0,0 +1,356 @@
> +/*
> + * rtc-tps6586x.c: RTC driver for TI PMIC TPS6586X
> + *
> + * Copyright (c) 2012, NVIDIA Corporation.
> + *
> + * Author: Laxman Dewangan <ldewangan@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307, USA
> + */
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/tps6586x.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/rtc.h>
> +#include <linux/slab.h>
> +
> +#define RTC_CTRL                       0xc0
> +#define POR_RESET_N                    BIT(7)
> +#define OSC_SRC_SEL                    BIT(6)
> +#define RTC_ENABLE                     BIT(5)  /* enables alarm */
> +#define RTC_BUF_ENABLE                 BIT(4)  /* 32 KHz buffer enable */
> +#define PRE_BYPASS                     BIT(3)  /* 0=1KHz or 1=32KHz updates */
> +#define CL_SEL_MASK                    (BIT(2)|BIT(1))
> +#define CL_SEL_POS                     1
> +#define RTC_ALARM1_HI                  0xc1
> +#define RTC_COUNT4                     0xc6
> +
> +/* start a PMU RTC access by reading the register prior to the RTC_COUNT4 */
> +#define RTC_COUNT4_DUMMYREAD           0xc5
> +
> +/*only 14-bits width in second*/
> +#define ALM1_VALID_RANGE_IN_SEC                0x3FFF
> +
> +#define TPS6586X_RTC_CL_SEL_1_5PF      0x0
> +#define TPS6586X_RTC_CL_SEL_6_5PF      0x1
> +#define TPS6586X_RTC_CL_SEL_7_5PF      0x2
> +#define TPS6586X_RTC_CL_SEL_12_5PF     0x3
> +
> +struct tps6586x_rtc {
> +       struct device           *dev;
> +       struct rtc_device       *rtc;
> +       int                     irq;
> +       bool                    irq_en;
> +       unsigned long long      epoch_start;
> +};
> +
> +static inline struct device *to_tps6586x_dev(struct device *dev)
> +{
> +       return dev->parent;
> +}
> +

> +
> +static int tps6586x_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +       struct tps6586x_rtc *rtc = dev_get_drvdata(dev);
> +       struct device *tps_dev = to_tps6586x_dev(dev);
> +       unsigned long long ticks;
> +       unsigned long seconds;
> +       u8 buff[5];
> +       int ret;
> +
> +       rtc_tm_to_time(tm, &seconds);
> +       if (WARN_ON(seconds < rtc->epoch_start)) {

this may trigger frequently if user does RTC_SET_TIME. may be -EINVAL
is right just.

> +               dev_err(dev, "requested time unsupported\n");
> +               return -EINVAL;
> +       }
> +       seconds -= rtc->epoch_start;
> +
> +       ticks = (unsigned long long)seconds << 10;
> +       buff[0] = (ticks >> 32) & 0xff;
> +       buff[1] = (ticks >> 24) & 0xff;
> +       buff[2] = (ticks >> 16) & 0xff;
> +       buff[3] = (ticks >> 8) & 0xff;
> +       buff[4] = ticks & 0xff;
> +
> +       /* Disable RTC before changing time */
> +       ret = tps6586x_clr_bits(tps_dev, RTC_CTRL, RTC_ENABLE);
> +       if (ret < 0) {
> +               dev_err(dev, "failed to clear RTC_ENABLE\n");
> +               return ret;
> +       }
> +
> +       ret = tps6586x_writes(tps_dev, RTC_COUNT4, sizeof(buff), buff);
> +       if (ret < 0) {
> +               dev_err(dev, "failed to program new time\n");
> +               return ret;
> +       }
> +
> +       /* Enable RTC */
> +       ret = tps6586x_set_bits(tps_dev, RTC_CTRL, RTC_ENABLE);
> +       if (ret < 0) {
> +               dev_err(dev, "failed to set RTC_ENABLE\n");
> +               return ret;
> +       }
> +       return 0;
> +}
> +
> +static int tps6586x_rtc_alarm_irq_enable(struct device *dev,
> +                        unsigned int enabled)
> +{
> +       struct tps6586x_rtc *rtc = dev_get_drvdata(dev);
> +
> +       if (enabled && !rtc->irq_en) {
> +               enable_irq(rtc->irq);
> +               rtc->irq_en = true;
> +       } else if (!enabled && rtc->irq_en)  {
> +               disable_irq(rtc->irq);
> +               rtc->irq_en = false;
> +       }
> +       return 0;
> +}
> +
> +static int tps6586x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> +{
> +       struct tps6586x_rtc *rtc = dev_get_drvdata(dev);
> +       struct device *tps_dev = to_tps6586x_dev(dev);
> +       unsigned long seconds;
> +       unsigned long ticks;
> +       unsigned long rtc_current_time;
> +       unsigned long long rticks = 0;
> +       u8 buff[3];
> +       u8 rbuff[6];
> +       int ret;
> +       int i;
> +
> +       rtc_tm_to_time(&alrm->time, &seconds);
> +
> +       if (WARN_ON(alrm->enabled && (seconds < rtc->epoch_start))) {

same here what if the RTC_AIE_ON called? it warns on the log, every
time if that gets called. returning -EINVAL is ok.

> +               dev_err(dev, "can't set alarm to requested time\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = tps6586x_rtc_alarm_irq_enable(dev, alrm->enabled);
> +       if (ret < 0) {
> +               dev_err(dev, "can't set alarm irq, err %d\n", ret);
> +               return ret;
> +       }
> +
> +       seconds -= rtc->epoch_start;
> +       ret = tps6586x_reads(tps_dev, RTC_COUNT4_DUMMYREAD,
> +                       sizeof(rbuff), rbuff);
> +       if (ret < 0) {
> +               dev_err(dev, "read counter failed with err %d\n", ret);
> +               return ret;
> +       }
> +
> +       for (i = 1; i < sizeof(rbuff); i++) {
> +               rticks <<= 8;
> +               rticks |= rbuff[i];
> +       }
> +
> +       rtc_current_time = rticks >> 10;
> +       if ((seconds - rtc_current_time) > ALM1_VALID_RANGE_IN_SEC)
> +               seconds = rtc_current_time - 1;
> +
> +       ticks = (unsigned long long)seconds << 10;
> +       buff[0] = (ticks >> 16) & 0xff;
> +       buff[1] = (ticks >> 8) & 0xff;
> +       buff[2] = ticks & 0xff;
> +
> +       ret = tps6586x_writes(tps_dev, RTC_ALARM1_HI, sizeof(buff), buff);
> +       if (ret)
> +               dev_err(dev, "programming alarm failed with err %d\n", ret);
> +
> +       return ret;
> +}

<snip>

> +
> +static const struct rtc_class_ops tps6586x_rtc_ops = {
> +       .read_time      = tps6586x_rtc_read_time,
> +       .set_time       = tps6586x_rtc_set_time,
> +       .set_alarm      = tps6586x_rtc_set_alarm,
> +       .read_alarm     = tps6586x_rtc_read_alarm,
> +       .alarm_irq_enable = tps6586x_rtc_alarm_irq_enable,
> +};
> +
> +static irqreturn_t tps6586x_rtc_irq(int irq, void *data)
> +{
> +       struct tps6586x_rtc *rtc = data;
> +
> +       rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_AF);
> +       return IRQ_HANDLED;
> +}
> +
> +static int tps6586x_rtc_probe(struct platform_device *pdev)
> +{
> +       struct device *tps_dev = to_tps6586x_dev(&pdev->dev);
> +       struct tps6586x_rtc *rtc;
> +       int ret;
> +
> +       rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
> +       if (!rtc) {
> +               dev_err(&pdev->dev, "Memory allocation failed\n");

this will get printed when oom triggers, may be you can remove this print.

> +               return -ENOMEM;
> +       }
> +
> +       rtc->dev = &pdev->dev;
> +       rtc->irq = platform_get_irq(pdev, 0);
> +       ret = request_threaded_irq(rtc->irq, NULL, tps6586x_rtc_irq,
> +                               IRQF_ONESHOT | IRQF_EARLY_RESUME,
> +                               dev_name(&pdev->dev), rtc);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "request IRQ(%d) failed with ret %d\n",
> +                               rtc->irq, ret);
> +               return ret;
> +       }
> +       disable_irq(rtc->irq);
> +

calling request_irqs and their sister functions, before registering
the driver may not be right way to do so as since the irq handler gets
called before you register and may cause some oops as you didn't
initialised some pointers and some thing like that.

so its better if you have this function down the registering the device.

btw you may even remove disable_irq if you register below the
registering of device.

> +       /* Set epoch start as 00:00:00:01:01:2000 */
> +       rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
> +
> +       /* 1 kHz tick mode, enable tick counting */
> +       ret = tps6586x_update(tps_dev, RTC_CTRL,
> +               RTC_ENABLE | OSC_SRC_SEL |
> +               ((TPS6586X_RTC_CL_SEL_1_5PF << CL_SEL_POS) & CL_SEL_MASK),
> +               RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "unable to start counter\n");
> +               goto fail_rtc_init;
> +       }
> +
> +       platform_set_drvdata(pdev, rtc);
> +       rtc->rtc = rtc_device_register(dev_name(&pdev->dev), &pdev->dev,
> +                                      &tps6586x_rtc_ops, THIS_MODULE);
> +       if (IS_ERR(rtc->rtc)) {
> +               ret = PTR_ERR(rtc->rtc);
> +               dev_err(&pdev->dev, "RTC device register: ret %d\n", ret);
> +               goto fail_rtc_register;
> +       }
> +       device_set_wakeup_capable(&pdev->dev, 1);
> +       return 0;
> +
> +fail_rtc_register:
> +       tps6586x_update(tps_dev, RTC_CTRL, 0,
> +               RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
> +fail_rtc_init:
> +       free_irq(rtc->irq, rtc);
> +       return ret;
> +};
> +
