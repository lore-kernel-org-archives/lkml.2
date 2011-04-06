Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1DFOjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:39:44 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47958 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab1DFOjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:39:42 -0400
Message-ID: <4D9C7B52.2060307@metafoo.de>
Date: Wed, 06 Apr 2011 16:40:18 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Benson Leung <bleung@chromium.org>
CC: cbouatmailru@gmail.com, rklein@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio-charger: Add gpio_charger_resume
References: <1301796792-28806-1-git-send-email-bleung@chromium.org> <BANLkTinh-Chz7GzdHLqpSSzq4BzzwX5axw@mail.gmail.com>
In-Reply-To: <BANLkTinh-Chz7GzdHLqpSSzq4BzzwX5axw@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 11:08 AM, Benson Leung wrote:
> Hi Lars,
> 
> Please take another look.
> 
> Thanks,
> Benson
> 

Hi

Some minor issues:

> On Sat, Apr 2, 2011 at 7:13 PM, Benson Leung <bleung@chromium.org> wrote:
>> Gpio charger should notify if the gpio state had changed
>> during suspend. This will send a CHANGED event each time
>> the system resumes, ensuring a plug/unplug of the charger
>> is not missed.
>>
>> Signed-off-by: Benson Leung <bleung@chromium.org>
>>
>> --
>> Version history :
>> v2 : Changed to use dev_pm_ops
>> v1 : Initial
>> ---
>>  drivers/power/gpio-charger.c |   20 ++++++++++++++++++++
>>  1 files changed, 20 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
>> index 25b88ac..df29059 100644
>> --- a/drivers/power/gpio-charger.c
>> +++ b/drivers/power/gpio-charger.c
>> @@ -161,12 +161,32 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
>>        return 0;
>>  }
>>
>> +#if defined(CONFIG_PM)

#ifdef CONFIG_PM_SLEEP

>> +static int gpio_charger_resume(struct device *dev)
>> +{
>> +       struct platform_device *pdev = to_platform_device(dev);
>> +       struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
>> +
>> +       power_supply_changed(&gpio_charger->charger);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct dev_pm_ops gpio_charger_pm_ops = {
>> +       .resume         = gpio_charger_resume,
>> +};
>> +#endif

static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops, gpio_charger_resume, NULL);

This will also setup the pm hooks for suspend to disk.
And SIMPLE_DEV_PM_OPS will also ignore the callbacks if CONFIG_PM_SLEEP is not
set, so it can go outside of the #ifdef CONFIG_PM_SLEEP and you can also get
rid of the #ifdef ...

>> +
>> +
>>  static struct platform_driver gpio_charger_driver = {
>>        .probe = gpio_charger_probe,
>>        .remove = __devexit_p(gpio_charger_remove),
>>        .driver = {
>>                .name = "gpio-charger",
>>                .owner = THIS_MODULE,
>> +#if defined(CONFIG_PM)
>> +               .pm = &gpio_charger_pm_ops,
>> +#endif

... here.

>>        },
>>  };
>>
>> --
>> 1.7.1
>>
>>
> 
> 
> 

