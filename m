Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2AMJRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:17:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60293 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2AMJRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:17:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAMPhdO-BEgNkHERx-0mE5B4kTZ90wjAgWbWMBNdfTioyWFP5zA@mail.gmail.com>
References: <1322704427-11876-1-git-send-email-Barry.Song@csr.com> <CAMPhdO-BEgNkHERx-0mE5B4kTZ90wjAgWbWMBNdfTioyWFP5zA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 13 Jan 2012 17:17:17 +0800
Message-ID: <CAGsJ_4xp6S6nAmGbGP320qtkVPnyA614XUDeqipiSnLKtbbY9Q@mail.gmail.com>
Subject: Re: [PATCH] backlight: pwm_bl: move suspend/resume entries from
 platform_driver to driver.pm
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, Xiangzhen Ye <Xiangzhen.Ye@csr.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Richard Purdie <rpurdie@rpsys.net>, Barry Song <Baohua.Song@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Eric Miao <eric.y.miao@gmail.com>:
> On Thu, Dec 1, 2011 at 9:53 AM, Barry Song <Barry.Song@csr.com> wrote:
>> From: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
>>
>> At first, people are moving suspend/resume entries from platform_driver
>> to driver.pm for many drivers.
>> On the other hand, if we use swsusp to do hibernation for an embedded
>> system using pwm_bl, in the process of preparing snapshot, backlight
>> will be off and make lcd black screen. This gives bad user experiences.
>> This patch will fix this issue as swsusp will go to call pm.freeze()
>> but not platform_driver.suspend. we have no pm.freeze() for pwm_bl, so
>> the lcd black screen will disappear.
>>
>> Signed-off-by: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
>> Signed-off-by: Barry Song <Baohua.Song@csr.com>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>

Eric, thanks. Mark Brown's "backlight: convert pwm_bl to dev_pm_ops"
http://www.spinics.net/lists/mm-commits/msg86844.html
did seem and has been merged as commit e2c17bc6f.


>
>> ---
>>  drivers/video/backlight/pwm_bl.c |   15 ++++++++++-----
>>  1 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
>> index 8b5b2a4..50f3134 100644
>> --- a/drivers/video/backlight/pwm_bl.c
>> +++ b/drivers/video/backlight/pwm_bl.c
>> @@ -169,9 +169,9 @@ static int pwm_backlight_remove(struct platform_device *pdev)
>>  }
>>
>>  #ifdef CONFIG_PM
>> -static int pwm_backlight_suspend(struct platform_device *pdev,
>> -                                pm_message_t state)
>> +static int pwm_backlight_suspend(struct device *dev)
>>  {
>> +       struct platform_device *pdev = to_platform_device(dev);
>>        struct backlight_device *bl = platform_get_drvdata(pdev);
>>        struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>>
>> @@ -184,8 +184,9 @@ static int pwm_backlight_suspend(struct platform_device *pdev,
>>        return 0;
>>  }
>>
>> -static int pwm_backlight_resume(struct platform_device *pdev)
>> +static int pwm_backlight_resume(struct device *dev)
>>  {
>> +       struct platform_device *pdev = to_platform_device(dev);
>>        struct backlight_device *bl = platform_get_drvdata(pdev);
>>
>>        backlight_update_status(bl);
>> @@ -196,15 +197,19 @@ static int pwm_backlight_resume(struct platform_device *pdev)
>>  #define pwm_backlight_resume   NULL
>>  #endif
>>
>> +static const struct dev_pm_ops pwm_backlight_pm_ops = {
>> +       .suspend = pwm_backlight_suspend,
>> +       .resume = pwm_backlight_resume,
>> +};
>> +
>>  static struct platform_driver pwm_backlight_driver = {
>>        .driver         = {
>>                .name   = "pwm-backlight",
>>                .owner  = THIS_MODULE,
>> +               .pm     = &pwm_backlight_pm_ops,
>>        },
>>        .probe          = pwm_backlight_probe,
>>        .remove         = pwm_backlight_remove,
>> -       .suspend        = pwm_backlight_suspend,
>> -       .resume         = pwm_backlight_resume,
>>  };
>>
>>  static int __init pwm_backlight_init(void)
>> --
>> 1.7.1

-barry
