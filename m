Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab2JSOoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:44:06 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44741 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab2JSOoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:44:02 -0400
MIME-Version: 1.0
In-Reply-To: <50812112.2020709@metafoo.de>
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
	<1350603664-18148-4-git-send-email-marcos.souza.org@gmail.com>
	<50812112.2020709@metafoo.de>
Date: Fri, 19 Oct 2012 11:44:00 -0300
Message-ID: <CAH0vN5J0yUSSHnJDRqPSbSu8wrTKo7FRzxpXwoqbypQoNX=_vg@mail.gmail.com>
Subject: Re: [PATCH 3/4] Use devm_request_irq to avoid some checks
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

2012/10/19 Lars-Peter Clausen <lars@metafoo.de>:
> On 10/19/2012 01:41 AM, Marcos Paulo de Souza wrote:
>> With this we can remove a lot of checks.
>>
>> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
>
> This one is a bit more tricky and the driver currently gets it (partially
> wrong). The issue is that since the power supply is referenced in the
> interrupt handler, the IRQs should be requested after the power supply has
> been registered and be freed before the power supply is unregistered.
>
> So devm can't really be used here. But as I said the current driver already
> gets it wrong.

Tanks for all the reviews! I will resend these patches will your comments.

But in this case, there is a way that we can fix this issue about
register/unregister IRQ?

Maybe another approach?

If you give some tips for me, my next patches will have this issue fixed too.

Thanks for all!

> - Lars
>
>> ---
>>  drivers/power/jz4740-battery.c |   25 ++++++++-----------------
>>  1 file changed, 8 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
>> index 9d9b2a8..b80f7ed 100644
>> --- a/drivers/power/jz4740-battery.c
>> +++ b/drivers/power/jz4740-battery.c
>> @@ -307,8 +307,8 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>>
>>       INIT_DELAYED_WORK(&jz_battery->work, jz_battery_work);
>>
>> -     ret = request_irq(jz_battery->irq, jz_battery_irq_handler, 0, pdev->name,
>> -                     jz_battery);
>> +     ret = devm_request_irq(&pdev->dev, jz_battery->irq, jz_battery_irq_handler,
>> +                             0, pdev->name, jz_battery);
>>       if (ret) {
>>               dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
>>               goto err;
>> @@ -319,7 +319,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>>               ret = gpio_request(pdata->gpio_charge, dev_name(&pdev->dev));
>>               if (ret) {
>>                       dev_err(&pdev->dev, "charger state gpio request failed.\n");
>> -                     goto err_free_irq;
>> +                     goto err;
>>               }
>>               ret = gpio_direction_input(pdata->gpio_charge);
>>               if (ret) {
>> @@ -330,7 +330,8 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>>               jz_battery->charge_irq = gpio_to_irq(pdata->gpio_charge);
>>
>>               if (jz_battery->charge_irq >= 0) {
>> -                     ret = request_irq(jz_battery->charge_irq,
>> +                     ret = devm_request_irq(&pdev->dev,
>> +                                 jz_battery->charge_irq,
>>                                   jz_battery_charge_irq,
>>                                   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>>                                   dev_name(&pdev->dev), jz_battery);
>> @@ -352,7 +353,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>>       ret = power_supply_register(&pdev->dev, &jz_battery->battery);
>>       if (ret) {
>>               dev_err(&pdev->dev, "power supply battery register failed.\n");
>> -             goto err_free_charge_irq;
>> +             goto err_free_gpio;
>>       }
>>
>>       platform_set_drvdata(pdev, jz_battery);
>> @@ -360,16 +361,11 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>>
>>       return 0;
>>
>> -err_free_charge_irq:
>> -     if (jz_battery->charge_irq >= 0)
>> -             free_irq(jz_battery->charge_irq, jz_battery);
>>  err_free_gpio:
>>       if (gpio_is_valid(pdata->gpio_charge))
>>               gpio_free(jz_battery->pdata->gpio_charge);
>> -err_free_irq:
>> -     free_irq(jz_battery->irq, jz_battery);
>> -     platform_set_drvdata(pdev, NULL);
>>  err:
>> +     platform_set_drvdata(pdev, NULL);
>>       return ret;
>>  }
>>
>> @@ -379,16 +375,11 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
>>
>>       cancel_delayed_work_sync(&jz_battery->work);
>>
>> -     if (gpio_is_valid(jz_battery->pdata->gpio_charge)) {
>> -             if (jz_battery->charge_irq >= 0)
>> -                     free_irq(jz_battery->charge_irq, jz_battery);
>> +     if (gpio_is_valid(jz_battery->pdata->gpio_charge))
>>               gpio_free(jz_battery->pdata->gpio_charge);
>> -     }
>>
>>       power_supply_unregister(&jz_battery->battery);
>>
>> -     free_irq(jz_battery->irq, jz_battery);
>> -
>>       return 0;
>>  }
>>
>



-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
Github: https://github.com/marcosps/
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
