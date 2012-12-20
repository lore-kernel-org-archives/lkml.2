Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2LTJgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:36:55 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:39045 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2LTJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:36:42 -0500
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 04:36:42 EST
MIME-Version: 1.0
In-Reply-To: <1355989253-27471-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1355989253-27471-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Thu, 20 Dec 2012 14:42:20 +0530
Message-ID: <CAHdPZaM_TKVvZxCQuUziCEY4nFmGYYY6F4so+FbVtQ0EFBNTtA@mail.gmail.com>
Subject: Re: [PATCH v2] RTC: MAX77686: Add Maxim 77686 driver
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Aleessandro Zummo <a.zummo@towertech.it>, a.kesavan@samsung.com,
        akpm@linux-foundation.org, joe@perches.com,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myugnjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for commenting on your V2, i would have done it for the first one :(

but these are all small ones, if you would like me to do it after this
merged, i will be glad to do so.

> +
> +static int max77686_rtc_probe(struct platform_device *pdev)
> +{
> +       struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
> +       struct max77686_rtc_info *info;
> +       int ret, virq;
> +
> +       pr_info("%s\n", __func__);
> +
> +       info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);

devm_kzalloc will be good to use, as this is module.

> +       if (!info)
> +               return -ENOMEM;
> +
> +       mutex_init(&info->lock);
> +       info->dev = &pdev->dev;
> +       info->max77686 = max77686;
> +       info->rtc = max77686->rtc;
> +       info->max77686->rtc_regmap = regmap_init_i2c(info->max77686->rtc,
> +                                        &max77686_rtc_regmap_config);
> +       if (IS_ERR(info->max77686->rtc_regmap)) {
> +               ret = PTR_ERR(info->max77686->rtc_regmap);
> +               dev_err(info->max77686->dev, "Failed to allocate register map: %d\n",
> +                               ret);
> +               kfree(info);
> +               return ret;
> +       }
> +       platform_set_drvdata(pdev, info);
> +
> +       ret = max77686_rtc_init_reg(info);
> +
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
> +               goto err_rtc;
> +       }
> +
> +       max77686_rtc_enable_wtsr(info, true);
> +       max77686_rtc_enable_smpl(info, true);
> +
> +       device_init_wakeup(&pdev->dev, 1);
> +
> +       info->rtc_dev = rtc_device_register("max77686-rtc", &pdev->dev,
> +                       &max77686_rtc_ops, THIS_MODULE);
> +
> +       if (IS_ERR(info->rtc_dev)) {
> +               pr_info("%s: fail\n", __func__);
> +
> +               ret = PTR_ERR(info->rtc_dev);
> +               dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
> +               if (ret == 0)
> +                       ret = -EINVAL;

AFAIK, we dont return 0 or null of the rtc_device_register fail. so
ret == 0 may be not needed.

> +               goto err_rtc;
> +       }
> +       virq = irq_create_mapping(max77686->irq_domain, MAX77686_RTCIRQ_RTCA1);
> +       if (!virq)
> +               goto err_rtc;
                    goto err_rtc_reg;
> +       info->virq = virq;
> +
> +       ret = request_threaded_irq(virq, NULL, max77686_rtc_alarm_irq, 0,
> +                       "rtc-alarm0", info);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
> +                       info->virq, ret);
> +               goto err_rtc;
                    goto err_rtc_reg;
> +       }
> +
> +       goto out;
> +err_rtc_reg:

rtc_device_unregister();

> +       kfree(info);
> +       return ret;
> +out:
> +       return ret;
> +}
> +
> +static int max77686_rtc_remove(struct platform_device *pdev)
> +{
> +       struct max77686_rtc_info *info = platform_get_drvdata(pdev);
> +
> +       if (info) {
> +               free_irq(info->virq, info);
> +               rtc_device_unregister(info->rtc_dev);
> +               kfree(info);
> +       }
> +
> +       return 0;
> +}
> +
> +static void max77686_rtc_shutdown(struct platform_device *pdev)
> +{
> +       struct max77686_rtc_info *info = platform_get_drvdata(pdev);
> +       int i;
> +       u8 val = 0;
> +
> +       for (i = 0; i < 3; i++) {
> +               max77686_rtc_enable_wtsr(info, false);
> +               regmap_read(info->max77686->rtc_regmap,
> +                               MAX77686_WTSR_SMPL_CNTL, &val);
> +               pr_info("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
> +               if (val & WTSR_EN_MASK)
> +                       pr_emerg("%s: fail to disable WTSR\n", __func__);
> +               else {
> +                       pr_info("%s: success to disable WTSR\n", __func__);
> +                       break;
> +               }
> +       }
> +
> +       max77686_rtc_enable_smpl(info, false);
> +}
> +
> +static const struct platform_device_id rtc_id[] = {
> +       { "max77686-rtc", 0 },
> +       {},
> +};
> +
> +static struct platform_driver max77686_rtc_driver = {
> +       .driver         = {
> +               .name   = "max77686-rtc",
> +               .owner  = THIS_MODULE,
> +       },
> +       .probe          = max77686_rtc_probe,
> +       .remove         = max77686_rtc_remove,
> +       .shutdown       = max77686_rtc_shutdown,
> +       .id_table       = rtc_id,
> +};
> +
----> from here
> +static int __init max77686_rtc_init(void)
> +{
> +       return platform_driver_register(&max77686_rtc_driver);
> +}
> +module_init(max77686_rtc_init);
> +
> +static void __exit max77686_rtc_exit(void)
> +{
> +       platform_driver_unregister(&max77686_rtc_driver);
> +}
> +module_exit(max77686_rtc_exit);
> +

----- to here

you can use module_platform_driver(&max77686_rtc_driver);

> +MODULE_DESCRIPTION("Maxim MAX77686 RTC driver");
> +MODULE_AUTHOR("<woong.byun@samsung.com>");
> +MODULE_LICENSE("GPL");
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
