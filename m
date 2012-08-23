Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2HWQuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:50:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46345 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2HWQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120823021811.GC24471@lizard>
References: <1343584015-30344-1-git-send-email-develkernel412222@gmail.com>
	<D854C92F57B1B347B57E531E78D05EAD1C5372@BGSMSX102.gar.corp.intel.com>
	<20120823021811.GC24471@lizard>
Date: Thu, 23 Aug 2012 22:20:00 +0530
Message-ID: <CA+C2MxQgca7ZyUC8AncfWGjZmfWtLQB+52S1QDFP8QALPb3hsA@mail.gmail.com>
Subject: Re: [PATCH 2/2] lp8727_charger: unregister power supply at error path
 of lp8727_register_psy
From: Devendra Naga <develkernel412222@gmail.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Thanks for merging this in. Actually a V2 has been sent a long ago
after receving comments for Ramakrishna, that actually does the same
changes as you have currently done.

Anyways Thanks again.

On Thu, Aug 23, 2012 at 7:48 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> On Mon, Jul 30, 2012 at 04:47:44AM +0000, Pallala, Ramakrishna wrote:
>> >     if (power_supply_register(pchg->dev, &psy->usb))
>> > -           goto err_psy;
>> > +           goto err_psy_ac;
>>
>> "err_psy_ac" label name is confusing. Why can't you use err_psy_usb
>>
>> >     if (power_supply_register(pchg->dev, &psy->batt))
>> > -           goto err_psy;
>> > +           goto err_psy_usb;
>>
>> Same here, why don't you use err_psy_batt
>
> Thanks, folks! It was easy to change so I applied the following:
>
> commit 6297b5e54b5511d4e72e8d5fc3b139650adc74d8
> Author: Devendra Naga <develkernel412222@gmail.com>
> Date:   Sun Jul 29 23:31:55 2012 +0545
>
>     lp8727_charger: Unregister power supply at error path of lp8727_register_psy
>
>     if usb power supply registration fails,
>         we wont unregister the ac power supply
>     if battery power supply registration fails,
>         we wont unregister the usb, and ac supply,
>
>     take care of those things and also no need of goto -err_mem: at the fail case of
>     kzalloc simply can have return -ENOMEM
>
>     Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
>     Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
>
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> index 6a364f4..4e37b26 100644
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -362,7 +362,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
>
>         psy = kzalloc(sizeof(*psy), GFP_KERNEL);
>         if (!psy)
> -               goto err_mem;
> +               return -ENOMEM;
>
>         pchg->psy = psy;
>
> @@ -375,7 +375,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
>         psy->ac.num_supplicants = ARRAY_SIZE(battery_supplied_to);
>
>         if (power_supply_register(pchg->dev, &psy->ac))
> -               goto err_psy;
> +               goto err_psy_ac;
>
>         psy->usb.name = "usb";
>         psy->usb.type = POWER_SUPPLY_TYPE_USB;
> @@ -386,7 +386,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
>         psy->usb.num_supplicants = ARRAY_SIZE(battery_supplied_to);
>
>         if (power_supply_register(pchg->dev, &psy->usb))
> -               goto err_psy;
> +               goto err_psy_usb;
>
>         psy->batt.name = "main_batt";
>         psy->batt.type = POWER_SUPPLY_TYPE_BATTERY;
> @@ -396,13 +396,15 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
>         psy->batt.external_power_changed = lp8727_charger_changed;
>
>         if (power_supply_register(pchg->dev, &psy->batt))
> -               goto err_psy;
> +               goto err_psy_batt;
>
>         return 0;
>
> -err_mem:
> -       return -ENOMEM;
> -err_psy:
> +err_psy_batt:
> +       power_supply_unregister(&psy->usb);
> +err_psy_usb:
> +       power_supply_unregister(&psy->ac);
> +err_psy_ac:
>         kfree(psy);
>         return -EPERM;
>  }
