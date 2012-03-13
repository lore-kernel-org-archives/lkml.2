Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496Ab2CMWye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:54:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42502 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388Ab2CMWya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:54:30 -0400
Message-ID: <4F5FD021.1080409@gmail.com>
Date: Tue, 13 Mar 2012 15:54:25 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 5/5] max17042: Change capacity property to use reported
 SOC register
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com> <1327425968-21195-6-git-send-email-dirk.brandewie@gmail.com> <20120313183452.GB15964@oksana.dev.rtsoft.ru>
In-Reply-To: <20120313183452.GB15964@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 11:34 AM, Anton Vorontsov wrote:
> On Tue, Jan 24, 2012 at 09:26:08AM -0800, dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> The SOC register (0dh) reports the state of charge before empty
>> compensation adjustments are applied.  The max value reported by this
>> register will decrease as the battery ages.
>>
>> Use the RepSOC register (06h) to report the capacity of the
>> battery. RepSOC contains a filtered version of the battery capacity
>> after empty compensation adjustments have been applied.
>>
>> Reported-by: Gary Keyes<gary.e.keyes@intel.com>
>>
>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> ---
>>   drivers/power/max17042_battery.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
>> index 6e96b58..2194278 100644
>> --- a/drivers/power/max17042_battery.c
>> +++ b/drivers/power/max17042_battery.c
>> @@ -160,7 +160,7 @@ static int max17042_get_property(struct power_supply *psy,
>>   		break;
>>   	case POWER_SUPPLY_PROP_CAPACITY:
>>   		val->intval = max17042_read_reg(chip->client,
>> -				MAX17042_SOC) / 256;
>> +				MAX17042_RepSOC) / 256;
>
> Applied. But I don't get it: PROP_CAPACITY should report
> percents! And it looks that it reports something very
> different.
>

The resolution of the register is 1/256 of a percent so we are actually 
returning the value in percent.

> Also, if you look down the file, you'll see this:
>
>          case POWER_SUPPLY_PROP_CHARGE_FULL:
>                  ret = max17042_read_reg(chip->client, MAX17042_RepSOC);
>                  if (ret<  0)
>                          return ret;
>
>                  if ((ret>>  8)>= MAX17042_BATTERY_FULL)
>                          val->intval = 1;
>                  else if (ret>= 0)
>                          val->intval = 0;
>                  break;
>

I hadn't looked at this property. Looks like that code came from commit 60a1f6e4

> Wut? This is also wrong. PROP_CHARGE_FULL reports uAh, not "fully
> charged" boolean status.
>
> Please, read Documentation/power/power_supply_class.txt:
>
> ~ ~ ~ ~ ~ ~ ~  Charge/Energy/Capacity - how to not confuse  ~ ~ ~ ~ ~ ~ ~
> ~                                                                       ~
> ~ Because both "charge" (µAh) and "energy" (µWh) represents "capacity"  ~
> ~ of battery, this class distinguish these terms. Don't mix them!       ~
> ~                                                                       ~
> ~ CHARGE_* attributes represents capacity in µAh only.                  ~
> ~ ENERGY_* attributes represents capacity in µWh only.                  ~
> ~ CAPACITY attribute represents capacity in *percents*, from 0 to 100.  ~
> ~                                                                       ~
> ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
>
> The driver is seriously broken, very. I'd even consider adding
> 'depends on BROKEN', as the driver might be the source of the
> confusion for drivers based on this one and for userland devs.
>
> Thanks,
>

