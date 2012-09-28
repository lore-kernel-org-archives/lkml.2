Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab2I1Sdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:33:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62699 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab2I1Sdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:33:53 -0400
Message-ID: <5065ED8F.7030403@linaro.org>
Date: Fri, 28 Sep 2012 12:33:51 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 52/57] power: abx500_chargalg: Use hrtimer
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org> <1348589574-25655-53-git-send-email-mathieu.poirier@linaro.org> <20120928024747.GK5040@lizard>
In-Reply-To: <20120928024747.GK5040@lizard>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-27 08:47 PM, Anton Vorontsov wrote:
> On Tue, Sep 25, 2012 at 10:12:49AM -0600, mathieu.poirier@linaro.org wrote:
>> From: Hakan Berg <hakan.berg@stericsson.com>
>>
>> Timers used for charging safety and maintenance must work even when
>> CPU is power collapsed. By using hrtimers with realtime clock, system
>> is able to trigger an alarm that wakes the CPU up and make it possible
>> to handle the event.
>>
>> Allow a little slack of 5 minutes to the hrtimers to allow CPU to be
>> waked up in a more optimal power saving way. A 5 minute delay to
>> time out timers on hours does not impact on safety.
>>
>> Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
>> ---
>>  drivers/power/abx500_chargalg.c |   94 ++++++++++++++++++++++-----------------
>>  1 files changed, 53 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
>> index 636d970..c8849af 100644
>> --- a/drivers/power/abx500_chargalg.c
>> +++ b/drivers/power/abx500_chargalg.c
>> @@ -1,5 +1,6 @@
>>  /*
>>   * Copyright (C) ST-Ericsson SA 2012
>> + * Copyright (c) 2012 Sony Mobile Communications AB
>>   *
>>   * Charging algorithm driver for abx500 variants
>>   *
>> @@ -8,11 +9,13 @@
>>   *	Johan Palsson <johan.palsson@stericsson.com>
>>   *	Karl Komierowski <karl.komierowski@stericsson.com>
>>   *	Arun R Murthy <arun.murthy@stericsson.com>
>> + *	Imre Sunyi <imre.sunyi@sonymobile.com>
>>   */
>>  
>>  #include <linux/init.h>
>>  #include <linux/module.h>
>>  #include <linux/device.h>
>> +#include <linux/hrtimer.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/delay.h>
>>  #include <linux/slab.h>
>> @@ -32,6 +35,12 @@
>>  /* End-of-charge criteria counter */
>>  #define EOC_COND_CNT			10
>>  
>> +/* One hour expressed in seconds */
>> +#define ONE_HOUR_IN_SECONDS		3600
>> +
>> +/* Five minutes expressed in seconds */
>> +#define FIVE_MINUTES_IN_SECONDS		300
>> +
>>  #define to_abx500_chargalg_device_info(x) container_of((x), \
>>  	struct abx500_chargalg, chargalg_psy);
>>  
>> @@ -245,8 +254,8 @@ struct abx500_chargalg {
>>  	struct delayed_work chargalg_periodic_work;
>>  	struct delayed_work chargalg_wd_work;
>>  	struct work_struct chargalg_work;
>> -	struct timer_list safety_timer;
>> -	struct timer_list maintenance_timer;
>> +	struct hrtimer safety_timer;
>> +	struct hrtimer maintenance_timer;
>>  	struct kobject chargalg_kobject;
>>  };
>>  
>> @@ -261,38 +270,47 @@ BLOCKING_NOTIFIER_HEAD(charger_notifier_list);
>>  
>>  /**
>>   * abx500_chargalg_safety_timer_expired() - Expiration of the safety timer
>> - * @data:	pointer to the abx500_chargalg structure
>> + * @timer:	pointer to the hrtimer structure
>>   *
>>   * This function gets called when the safety timer for the charger
>>   * expires
>>   */
>> -static void abx500_chargalg_safety_timer_expired(unsigned long data)
>> +static enum hrtimer_restart
>> +abx500_chargalg_safety_timer_expired(struct hrtimer *timer)
>>  {
>> -	struct abx500_chargalg *di = (struct abx500_chargalg *) data;
>> +	struct abx500_chargalg *di = container_of(timer, struct abx500_chargalg,
>> +							safety_timer);
> 
> Empty line here.
> 
>>  	dev_err(di->dev, "Safety timer expired\n");
>>  	di->events.safety_timer_expired = true;
>>  
>>  	/* Trigger execution of the algorithm instantly */
>>  	queue_work(di->chargalg_wq, &di->chargalg_work);
>> +
>> +	return HRTIMER_NORESTART;
>>  }
>>  
>>  /**
>>   * abx500_chargalg_maintenance_timer_expired() - Expiration of
>>   * the maintenance timer
>> - * @i:		pointer to the abx500_chargalg structure
>> + * @timer:	pointer to the timer structure
>>   *
>>   * This function gets called when the maintenence timer
>>   * expires
>>   */
>> -static void abx500_chargalg_maintenance_timer_expired(unsigned long data)
>> +static enum hrtimer_restart
>> +abx500_chargalg_maintenance_timer_expired(struct hrtimer *timer)
>> +
>>  {
>>  
>> -	struct abx500_chargalg *di = (struct abx500_chargalg *) data;
>> +	struct abx500_chargalg *di = container_of(timer, struct abx500_chargalg,
>> +							maintenance_timer);
>>  	dev_dbg(di->dev, "Maintenance timer expired\n");
>>  	di->events.maintenance_timer_expired = true;
>>  
>>  	/* Trigger execution of the algorithm instantly */
>>  	queue_work(di->chargalg_wq, &di->chargalg_work);
>> +
>> +	return HRTIMER_NORESTART;
>>  }
>>  
>>  /**
>> @@ -392,19 +410,16 @@ static int abx500_chargalg_check_charger_connection(struct abx500_chargalg *di)
>>   */
>>  static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
>>  {
>> -	unsigned long timer_expiration = 0;
>> +	/* Charger-dependent expiration time in hours*/
>> +	int timer_expiration = 0;
>>  
>>  	switch (di->chg_info.charger_type) {
>>  	case AC_CHG:
>> -		timer_expiration =
>> -		round_jiffies(jiffies +
>> -			(di->bat->main_safety_tmr_h * 3600 * HZ));
>> +		timer_expiration = di->bat->main_safety_tmr_h;
>>  		break;
>>  
>>  	case USB_CHG:
>> -		timer_expiration =
>> -		round_jiffies(jiffies +
>> -			(di->bat->usb_safety_tmr_h * 3600 * HZ));
>> +		timer_expiration = di->bat->usb_safety_tmr_h;
>>  		break;
>>  
>>  	default:
>> @@ -413,11 +428,10 @@ static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
>>  	}
>>  
>>  	di->events.safety_timer_expired = false;
>> -	di->safety_timer.expires = timer_expiration;
>> -	if (!timer_pending(&di->safety_timer))
>> -		add_timer(&di->safety_timer);
>> -	else
>> -		mod_timer(&di->safety_timer, timer_expiration);
>> +	hrtimer_set_expires_range(&di->safety_timer,
>> +		ktime_set(timer_expiration * ONE_HOUR_IN_SECONDS, 0),
>> +		ktime_set(FIVE_MINUTES_IN_SECONDS, 0));
>> +	hrtimer_start_expires(&di->safety_timer, HRTIMER_MODE_REL);
> 
> OK, now we're chaning from timers to hrtimers, and their behaviour
> might be different. I guess in this case you should check whether
> old value 'before' new value, and if so, do nothing.
> 

Would you mind being more descriptive - I'm affraid that I don't
understand your suggestion.

>>  }
>>  
>>  /**
>> @@ -428,8 +442,8 @@ static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
>>   */
>>  static void abx500_chargalg_stop_safety_timer(struct abx500_chargalg *di)
>>  {
>> -	di->events.safety_timer_expired = false;
>> -	del_timer(&di->safety_timer);
>> +	if (hrtimer_try_to_cancel(&di->safety_timer) >= 0)
>> +		di->events.safety_timer_expired = false;
>>  }
>>  
>>  /**
>> @@ -444,17 +458,11 @@ static void abx500_chargalg_stop_safety_timer(struct abx500_chargalg *di)
>>  static void abx500_chargalg_start_maintenance_timer(struct abx500_chargalg *di,
>>  	int duration)
>>  {
>> -	unsigned long timer_expiration;
>> -
>> -	/* Convert from hours to jiffies */
>> -	timer_expiration = round_jiffies(jiffies + (duration * 3600 * HZ));
>> -
>> +	hrtimer_set_expires_range(&di->maintenance_timer,
>> +		ktime_set(duration * ONE_HOUR_IN_SECONDS, 0),
>> +		ktime_set(FIVE_MINUTES_IN_SECONDS, 0));
>>  	di->events.maintenance_timer_expired = false;
>> -	di->maintenance_timer.expires = timer_expiration;
>> -	if (!timer_pending(&di->maintenance_timer))
>> -		add_timer(&di->maintenance_timer);
>> -	else
>> -		mod_timer(&di->maintenance_timer, timer_expiration);
>> +	hrtimer_start_expires(&di->maintenance_timer, HRTIMER_MODE_REL);
>>  }
>>  
>>  /**
>> @@ -466,8 +474,8 @@ static void abx500_chargalg_start_maintenance_timer(struct abx500_chargalg *di,
>>   */
>>  static void abx500_chargalg_stop_maintenance_timer(struct abx500_chargalg *di)
>>  {
>> -	di->events.maintenance_timer_expired = false;
>> -	del_timer(&di->maintenance_timer);
>> +	if (hrtimer_try_to_cancel(&di->maintenance_timer) >= 0)
>> +		di->events.maintenance_timer_expired = false;
>>  }
>>  
>>  /**
>> @@ -910,11 +918,11 @@ static void abx500_chargalg_check_safety_timer(struct abx500_chargalg *di)
>>  	 * and charging will be stopped to protect the battery.
>>  	 */
>>  	if (di->batt_data.percent == 100 &&
>> -		!timer_pending(&di->safety_timer)) {
>> +		!hrtimer_active(&di->safety_timer)) {
>>  		abx500_chargalg_start_safety_timer(di);
>>  		dev_dbg(di->dev, "start safety timer\n");
>>  	} else if (di->batt_data.percent != 100 &&
>> -		timer_pending(&di->safety_timer)) {
>> +		hrtimer_active(&di->safety_timer)) {
>>  		abx500_chargalg_stop_safety_timer(di);
>>  		dev_dbg(di->dev, "stop safety timer\n");
>>  	}
>> @@ -1932,10 +1940,16 @@ static int __devexit abx500_chargalg_remove(struct platform_device *pdev)
>>  	/* sysfs interface to enable/disbale charging from user space */
>>  	abx500_chargalg_sysfs_exit(di);
>>  
>> +	hrtimer_cancel(&di->safety_timer);
>> +	hrtimer_cancel(&di->maintenance_timer);
>> +
>> +	cancel_delayed_work_sync(&di->chargalg_periodic_work);
>> +	cancel_delayed_work_sync(&di->chargalg_wd_work);
>> +	cancel_work_sync(&di->chargalg_work);
>> +
> 
> These cancel_ calls seem to be separate bugfixes?
> 
>>  	/* Delete the work queue */
>>  	destroy_workqueue(di->chargalg_wq);
>>  
>> -	flush_scheduled_work();
>>  	power_supply_unregister(&di->chargalg_psy);
>>  	platform_set_drvdata(pdev, NULL);
>>  	kfree(di);
>> @@ -1987,15 +2001,13 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
>>  		abx500_chargalg_external_power_changed;
>>  
>>  	/* Initilialize safety timer */
>> -	init_timer(&di->safety_timer);
>> +	hrtimer_init(&di->safety_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
>>  	di->safety_timer.function = abx500_chargalg_safety_timer_expired;
>> -	di->safety_timer.data = (unsigned long) di;
>>  
>>  	/* Initilialize maintenance timer */
>> -	init_timer(&di->maintenance_timer);
>> +	hrtimer_init(&di->maintenance_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
>>  	di->maintenance_timer.function =
>>  		abx500_chargalg_maintenance_timer_expired;
>> -	di->maintenance_timer.data = (unsigned long) di;
>>  
>>  	/* Create a work queue for the chargalg */
>>  	di->chargalg_wq =
>> -- 
>> 1.7.5.4

