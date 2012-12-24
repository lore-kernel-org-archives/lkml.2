Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2LXKCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 05:02:32 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:59996 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2LXKCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 05:02:31 -0500
MIME-Version: 1.0
In-Reply-To: <1356341680-29644-1-git-send-email-ldewangan@nvidia.com>
References: <1356341680-29644-1-git-send-email-ldewangan@nvidia.com>
Date: Mon, 24 Dec 2012 15:32:30 +0530
Message-ID: <CAHdPZaOSfYb=1YxtYZ9LT=tVhE-LMs6NfON4-+1XMMW_CfN+kg@mail.gmail.com>
Subject: Re: [PATCH] rtc: add RTC driver for TPS80031/TPS80032
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linuxfoundation.org, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 24, 2012 at 3:04 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Add an RTC driver for TPS80031/TPS80032 chips by TI.
> This driver supports:
> - Setting and getting time and date.
> - Setting and reading alarm time.
> - Alarm and interrupt functionlity.
>

The patch looks ok, but just some minor comments below :).

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---

[snip]

> +
> +static int tps80031_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> +{
> +       struct rtc_time tm;
> +       unsigned long seconds;
> +       u8 buff[TPS80031_RTC_ALARM_NUM_REGS];
> +       int ret;
> +       unsigned long epoch_start;
> +
> +       rtc_tm_to_time(&alrm->time, &seconds);
> +       ret = tps80031_rtc_read_time(dev, &tm);
> +       if (ret < 0) {
> +               dev_err(dev, "Error in getting current time, err = %d\n", ret);
> +               return ret;
> +       }
> +       rtc_tm_to_time(&tm, &epoch_start);

> +
> +       if (alrm->enabled && (seconds < epoch_start)) {

its better to have this check in the core itself rather duplicating
everywhere, but i think the core already have this check, will you
please check ?

> +               dev_err(dev, "can't set alarm to requested time\n");
> +               return -EINVAL;
> +       }

> +
> +       buff[0] = bin2bcd(alrm->time.tm_sec);
> +       buff[1] = bin2bcd(alrm->time.tm_min);
> +       buff[2] = bin2bcd(alrm->time.tm_hour);
> +       buff[3] = bin2bcd(alrm->time.tm_mday);
> +       buff[4] = bin2bcd(alrm->time.tm_mon + 1);
> +       buff[5] = bin2bcd(alrm->time.tm_year % RTC_YEAR_OFFSET);
> +       ret = tps80031_writes(dev->parent, TPS80031_SLAVE_ID1,
> +                       TPS80031_ALARM_SECONDS_REG,
> +                       TPS80031_RTC_ALARM_NUM_REGS, buff);
> +       if (ret < 0) {
> +               dev_err(dev, "Writing RTC_ALARM failed, err %d\n", ret);
> +               return ret;
> +       }
> +       return tps80031_rtc_alarm_irq_enable(dev, alrm->enabled);

[ snip ]

> +static int __devinit tps80031_rtc_probe(struct platform_device *pdev)
> +{
> +       struct tps80031_rtc *rtc;
> +       struct rtc_time tm;
> +       int ret;
> +
> +       rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
> +       if (!rtc)
> +               return -ENOMEM;
> +
> +       rtc->irq = platform_get_irq(pdev, 0);
> +       platform_set_drvdata(pdev, rtc);
> +
> +       /* Start RTC */
> +       ret = tps80031_set_bits(pdev->dev.parent, TPS80031_SLAVE_ID1,
> +                       TPS80031_RTC_CTRL_REG, STOP_RTC);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "failed to start RTC. err = %d\n", ret);
> +               return ret;
> +       }
> +
> +       /* If RTC have POR values, set time 01:01:2000 */
> +       tps80031_rtc_read_time(&pdev->dev, &tm);
> +       if ((tm.tm_year == RTC_YEAR_OFFSET + TPS80031_RTC_POR_YEAR) &&
> +               (tm.tm_mon == (TPS80031_RTC_POR_MONTH - 1)) &&
> +               (tm.tm_mday == TPS80031_RTC_POR_DAY)) {
> +               tm.tm_year = 2000;
> +               tm.tm_mday = 1;
> +               tm.tm_mon = 1;
> +               ret = tps80031_rtc_set_time(&pdev->dev, &tm);
> +               if (ret < 0) {
> +                       dev_err(&pdev->dev,
> +                               "RTC set time failed, err = %d\n", ret);
> +                       return ret;
> +               }
> +       }
> +
> +       /* Clear alarm intretupt status if it is there */
> +       ret = clear_alarm_int_status(&pdev->dev, rtc);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Clear alarm int failed, err = %d\n", ret);
> +               return ret;
> +       }
> +
> +       rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
> +                              &tps80031_rtc_ops, THIS_MODULE);
> +       if (IS_ERR(rtc->rtc)) {
> +               ret = PTR_ERR(rtc->rtc);
> +               return ret;

                  you can do return PTR_ERR(rtc->rtc); instead saving
that and returning, but this is just trivial.

> +       }
> +
> +       ret = request_threaded_irq(rtc->irq, NULL, tps80031_rtc_irq,
> +                       IRQF_ONESHOT | IRQF_EARLY_RESUME,
> +                       dev_name(&pdev->dev), rtc);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "request IRQ:%d failed, err = %d\n",
> +                        rtc->irq, ret);
> +               rtc_device_unregister(rtc->rtc);
> +               return ret;
> +       }
> +       device_set_wakeup_capable(&pdev->dev, 1);
> +       return 0;
> +}
> +
> +static int __devexit tps80031_rtc_remove(struct platform_device *pdev)
> +{
> +       struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
> +
> +       free_irq(rtc->irq, rtc);
> +       rtc_device_unregister(rtc->rtc);
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int tps80031_rtc_suspend(struct device *dev)
> +{
> +       struct tps80031_rtc *rtc = dev_get_drvdata(dev);
> +
> +       if (device_may_wakeup(dev))
> +               enable_irq_wake(rtc->irq);
> +       return 0;
> +}
> +
> +static int tps80031_rtc_resume(struct device *dev)
> +{
> +       struct tps80031_rtc *rtc = dev_get_drvdata(dev);
> +
> +       if (device_may_wakeup(dev))
> +               disable_irq_wake(rtc->irq);
> +       return 0;
> +};
> +#endif
> +
> +static const struct dev_pm_ops tps80031_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(tps80031_rtc_suspend, tps80031_rtc_resume)

say we dont have enabled CONFIG_PM_SLEEP, will we get an compiler error ?

> +};
> +
> +static struct platform_driver tps80031_rtc_driver = {
> +       .driver = {
> +               .name   = "tps80031-rtc",
> +               .owner  = THIS_MODULE,
> +               .pm     = &tps80031_pm_ops,
> +       },
> +       .probe  = tps80031_rtc_probe,
> +       .remove = __devexit_p(tps80031_rtc_remove),
> +};
> +
> +module_platform_driver(tps80031_rtc_driver);
> +
> +MODULE_ALIAS("platform:tps80031-rtc");
> +MODULE_DESCRIPTION("TI TPS80031/TPS80032 RTC driver");
> +MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
