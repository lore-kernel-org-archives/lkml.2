Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2KHG01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:26:27 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43239 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2KHG00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:26:26 -0500
MIME-Version: 1.0
In-Reply-To: <1352354503.2190.7.camel@rzhang1-mobl4>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
	<1352348786-24255-2-git-send-email-amit.kachhap@linaro.org>
	<1352354503.2190.7.camel@rzhang1-mobl4>
Date: Thu, 8 Nov 2012 11:56:25 +0530
Message-ID: <CAK44p22REJpaJiahX7sTofShNB-+OHVsULqHeuxFNu5msLk6vA@mail.gmail.com>
Subject: Re: [PATCH 1/4] thermal: Add new thermal trend type to support quick cooling
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2012 11:31, Zhang Rui <rui.zhang@intel.com> wrote:
> On Thu, 2012-11-08 at 09:56 +0530, Amit Daniel Kachhap wrote:
>> This modification adds 2 new thermal trend type THERMAL_TREND_RAISE_FULL
>> and THERMAL_TREND_DROP_FULL. This thermal trend can be used to quickly
>> jump to the upper or lower cooling level instead of incremental increase
>> or decrease.
>
> IMO, what we need is a new more aggressive cooling governor which always
> uses upper limit when the temperature is raising and lower limit when
> the temperature is dropping.
Yes I agree that a new aggressive governor is the best approach but
then i thought adding a new trend type is a simple solution to achieve
this and since most of the governor logic might be same as the
step-wise governor. I have no objection in doing it through governor.
>
> I can write such a governor if you do not have time to.
ok. thanks
>
> thanks,
> rui
>>  This is needed for temperature sensors which support rising/falling
>> threshold interrupts and polling can be totally avoided.
>>
>
>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>> ---
>>  drivers/thermal/step_wise.c |   19 +++++++++++++++----
>>  include/linux/thermal.h     |    2 ++
>>  2 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
>> index 1242cff..0d2d8d6 100644
>> --- a/drivers/thermal/step_wise.c
>> +++ b/drivers/thermal/step_wise.c
>> @@ -35,6 +35,10 @@
>>   *       state for this trip point
>>   *    b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
>>   *       state for this trip point
>> + *    c. if the trend is THERMAL_TREND_RAISE_FULL, use highest cooling
>> + *       state for this trip point
>> + *    d. if the trend is THERMAL_TREND_DROP_FULL, use lowest cooling
>> + *       state for this trip point
>>   */
>>  static unsigned long get_target_state(struct thermal_instance *instance,
>>                                       enum thermal_trend trend)
>> @@ -50,7 +54,10 @@ static unsigned long get_target_state(struct thermal_instance *instance,
>>       } else if (trend == THERMAL_TREND_DROPPING) {
>>               cur_state = cur_state > instance->lower ?
>>                           (cur_state - 1) : instance->lower;
>> -     }
>> +     } else if (trend == THERMAL_TREND_RAISE_FULL)
>> +             cur_state = instance->upper;
>> +     else if (trend == THERMAL_TREND_DROP_FULL)
>> +             cur_state = instance->lower;
>>
>>       return cur_state;
>>  }
>> @@ -87,7 +94,8 @@ static void update_instance_for_throttle(struct thermal_zone_device *tz,
>>  }
>>
>>  static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
>> -                             int trip, enum thermal_trip_type trip_type)
>> +                             int trip, enum thermal_trip_type trip_type,
>> +                             enum thermal_trend trend)
>>  {
>>       struct thermal_instance *instance;
>>       struct thermal_cooling_device *cdev;
>> @@ -101,7 +109,10 @@ static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
>>               cdev = instance->cdev;
>>               cdev->ops->get_cur_state(cdev, &cur_state);
>>
>> -             instance->target = cur_state > instance->lower ?
>> +             if (trend == THERMAL_TREND_DROP_FULL)
>> +                     instance->target = instance->lower;
>> +             else
>> +                     instance->target = cur_state > instance->lower ?
>>                           (cur_state - 1) : THERMAL_NO_TARGET;
>>
>>               /* Deactivate a passive thermal instance */
>> @@ -133,7 +144,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
>>       if (tz->temperature >= trip_temp)
>>               update_instance_for_throttle(tz, trip, trip_type, trend);
>>       else
>> -             update_instance_for_dethrottle(tz, trip, trip_type);
>> +             update_instance_for_dethrottle(tz, trip, trip_type, trend);
>>
>>       mutex_unlock(&tz->lock);
>>  }
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index 807f214..8bce3ec 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -68,6 +68,8 @@ enum thermal_trend {
>>       THERMAL_TREND_STABLE, /* temperature is stable */
>>       THERMAL_TREND_RAISING, /* temperature is raising */
>>       THERMAL_TREND_DROPPING, /* temperature is dropping */
>> +     THERMAL_TREND_RAISE_FULL, /* Apply highest cooling action*/
>> +     THERMAL_TREND_DROP_FULL, /* Apply lowest cooling action*/
>>  };
>>
>>  /* Events supported by Thermal Netlink */
>
>
