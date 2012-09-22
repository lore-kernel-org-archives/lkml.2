Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2IVA7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:59:48 -0400
Received: from nm20.bullet.mail.ukl.yahoo.com ([217.146.183.194]:37238 "HELO
	nm20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756301Ab2IVA7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:59:47 -0400
X-Yahoo-Newman-Id: 641627.79099.bm@smtp132.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SSYXHnwVM1ku12fCVm514dp7Xsg5DJ5pT2Fkdf0IKK8OCaj
 0e_Dx8NwQ5CI6G23V0EwSyPg0qQofogKffwE5__lE7Cgo7GR2HXhGFt258h1
 4BVfV1jo0Qm4vth90wWdA4UCinM1VuXs.WPuNsyvQRJQ8mqXxT6OkM5EeacJ
 3h8SDm.bmRiVIPtEi8PN_ia23hRZHNidn_DKWtqQXNdo8zTxJQ7exuu3UjqY
 h5VHYUvIyE0k9fxKhAWpFy8ryMmB3Y1XzRjzoRF4uXCfY0doXjMRowPu3Q0z
 6e7veZCSOJQp5_zIxoNPwBSDyCaDPAoX9Wu4zGYBM40B4sqkg2HlVk0by2IM
 LRdZ7BcvvstEy.LweA4UIV5Gknm6HRVTlHM8hGmzaBYdZliZgUAr375EcccZ
 EYb02I6vz31pcEIKo9H0skA--
X-Yahoo-SMTP: 5Vuzu2WswBCxMnJ0hjKohBcp6M6Es6bt5AQ-
Message-ID: <505D0D80.40402@yahoo.com>
Date: Sat, 22 Sep 2012 01:59:44 +0100
From: Paul Parsons <lost.distance@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: dwmw2@infradead.org, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pda_power: remove ac_draw_failed goto and label
References: <505BBB4B.3060508@yahoo.com> <20120921235144.GC26715@lizard>
In-Reply-To: <20120921235144.GC26715@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anton,

On 22/09/12 00:51, Anton Vorontsov wrote:
> On Fri, Sep 21, 2012 at 01:56:43AM +0100, Paul Parsons wrote:
>> A previous patch added the ac_draw_failed goto and label to
>> pda_power_probe(). The goto would be invoked after a failed call to
>> regulator_get().
>>
>> However the way ac_draw is used - always after a check for NULL -
>> suggests that a failed call to regulator_get() was not fatal.
>>
>> This patch removes the ac_draw_failed goto and label, partly reverting
>> the previous patch.
>>
>> This patch also removes the assignment of an error code to ret after a
>> failed call to regulator_get(), since the error code is now never used.
>>
>> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
>> Cc: Philipp Zabel <philipp.zabel@gmail.com>
>> ---
>>   drivers/power/pda_power.c |    3 ---
>>   1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
>> index d3be834d..7df7c5f 100644
>> --- a/drivers/power/pda_power.c
>> +++ b/drivers/power/pda_power.c
>> @@ -284,9 +284,7 @@ static int pda_power_probe(struct platform_device *pdev)
>>   	ac_draw = regulator_get(dev, "ac_draw");
>>   	if (IS_ERR(ac_draw)) {
>>   		dev_dbg(dev, "couldn't get ac_draw regulator\n");
>> -		ret = PTR_ERR(ac_draw);
>>   		ac_draw = NULL;
>> -		goto ac_draw_failed;
>
> For some reason you have a bit different code, so your patch is not based
> on the battery tree. (In my tree ret and ac_draw assignments are swapped.)
> Maybe that's because I had to manually redo your first patch...
>
> Anyway, I repeated your patch by hand again and thus applied it.

Yes, in my first patch I had swapped the ret and ac_draw assignments
when I moved the regulator_get() call to before the update_charger()
call. This was because the original order of the assignments:

ac_draw = NULL;
ret = PTR_ERR(ac_draw);

is obviously incorrect; the ac_draw assignment overwrites the error
code that should be returned by PTR_ERR().

Anyway, thank you for sorting this out!

Regards,
Paul

> Thank you!
>
>>   	}
>>
>>   	update_status();
>> @@ -416,7 +414,6 @@ ac_supply_failed:
>>   		regulator_put(ac_draw);
>>   		ac_draw = NULL;
>>   	}
>> -ac_draw_failed:
>>   	if (pdata->exit)
>>   		pdata->exit(dev);
>>   init_failed:
>> --
>> 1.7.8.6

