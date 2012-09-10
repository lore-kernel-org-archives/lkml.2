Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2IJGUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:20:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:32811 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2IJGUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <201209092351.18297.rjw@sisk.pl>
References: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org>
	<1346682578-24312-3-git-send-email-rajagopal.venkat@linaro.org>
	<201209092351.18297.rjw@sisk.pl>
Date: Mon, 10 Sep 2012 11:50:46 +0530
Message-ID: <CA+Z25wXEs4-wit9Tytq+WDA=hcasLjBx+Y5JSYpgVhwQ=Gt1uA@mail.gmail.com>
Subject: Re: [PATCH 2/3] devfreq: Add suspend and resume apis
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2012 03:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, September 03, 2012, Rajagopal Venkat wrote:
>> Add devfreq suspend/resume apis for devfreq users. This patch
>> supports suspend and resume of devfreq load monitoring, required
>> for devices which can idle.
>>
>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>
> I'd call the new functions devfreq_dev_suspend() and devfreq_dev_resume(),
> respectively, because the names you're using currently suggest that the
> device itself is suspended/resumed, which isn't the case.

devfreq_add_device() and devfreq_remove_device() are two existing APIs.

I did follow same naming pattern to maintain uniformity and introduced
devfreq_suspend_device() and devfreq_resume_device() functions.

Do you suggest to follow devfreq_dev_xxx pattern even for existing APIs?

>
> Thanks,
> Rafael
>
>
>> ---
>>  drivers/devfreq/devfreq.c                 | 26 ++++++++++++++++++++++++++
>>  drivers/devfreq/governor.h                |  2 ++
>>  drivers/devfreq/governor_simpleondemand.c |  9 +++++++++
>>  include/linux/devfreq.h                   | 12 ++++++++++++
>>  4 files changed, 49 insertions(+)
>>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index be524c7..3a5f126 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -365,6 +365,32 @@ int devfreq_remove_device(struct devfreq *devfreq)
>>  }
>>  EXPORT_SYMBOL(devfreq_remove_device);
>>
>> +/**
>> + * devfreq_suspend_device() - Suspend devfreq of a device.
>> + * @devfreq  the devfreq instance to be suspended
>> + */
>> +int devfreq_suspend_device(struct devfreq *devfreq)
>> +{
>> +     if (!devfreq)
>> +             return -EINVAL;
>> +
>> +     return devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_SUSPEND);
>> +}
>> +EXPORT_SYMBOL(devfreq_suspend_device);
>> +
>> +/**
>> + * devfreq_resume_device() - Resume devfreq of a device.
>> + * @devfreq  the devfreq instance to be resumed
>> + */
>> +int devfreq_resume_device(struct devfreq *devfreq)
>> +{
>> +     if (!devfreq)
>> +             return -EINVAL;
>> +
>> +     return devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_RESUME);
>> +}
>> +EXPORT_SYMBOL(devfreq_resume_device);
>> +
>>  static ssize_t show_governor(struct device *dev,
>>                            struct device_attribute *attr, char *buf)
>>  {
>> diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
>> index 4a86af7..7dbbdfc 100644
>> --- a/drivers/devfreq/governor.h
>> +++ b/drivers/devfreq/governor.h
>> @@ -22,6 +22,8 @@
>>  #define DEVFREQ_GOV_START                    0x1
>>  #define DEVFREQ_GOV_STOP                     0x2
>>  #define DEVFREQ_GOV_INTERVAL                 0x3
>> +#define DEVFREQ_GOV_SUSPEND                  0x4
>> +#define DEVFREQ_GOV_RESUME                   0x5
>>
>>  /* Caution: devfreq->lock must be locked before calling update_devfreq */
>>  extern int update_devfreq(struct devfreq *devfreq);
>> diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
>> index 9802bf9..35b8e8e 100644
>> --- a/drivers/devfreq/governor_simpleondemand.c
>> +++ b/drivers/devfreq/governor_simpleondemand.c
>> @@ -113,6 +113,15 @@ int devfreq_simple_ondemand_handler(struct devfreq *devfreq,
>>               else
>>                       ret = devfreq_monitor_resume(devfreq);
>>               break;
>> +
>> +     case DEVFREQ_GOV_SUSPEND:
>> +             ret = devfreq_monitor_suspend(devfreq);
>> +             break;
>> +
>> +     case DEVFREQ_GOV_RESUME:
>> +             ret = devfreq_monitor_resume(devfreq);
>> +             break;
>> +
>>       default:
>>               break;
>>       }
>> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
>> index 7a11c3e..7c7e179 100644
>> --- a/include/linux/devfreq.h
>> +++ b/include/linux/devfreq.h
>> @@ -155,6 +155,8 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
>>                                 const struct devfreq_governor *governor,
>>                                 void *data);
>>  extern int devfreq_remove_device(struct devfreq *devfreq);
>> +extern int devfreq_suspend_device(struct devfreq *devfreq);
>> +extern int devfreq_resume_device(struct devfreq *devfreq);
>>
>>  /* Helper functions for devfreq user device driver with OPP. */
>>  extern struct opp *devfreq_recommended_opp(struct device *dev,
>> @@ -208,6 +210,16 @@ static int devfreq_remove_device(struct devfreq *devfreq)
>>       return 0;
>>  }
>>
>> +static int devfreq_suspend_device(struct devfreq *devfreq)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int devfreq_resume_device(struct devfreq *devfreq)
>> +{
>> +     return 0;
>> +}
>> +
>>  static struct opp *devfreq_recommended_opp(struct device *dev,
>>                                          unsigned long *freq, u32 flags)
>>  {
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Rajagopal
