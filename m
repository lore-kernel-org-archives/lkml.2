Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2KILyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:54:12 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51427 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2KILyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:54:10 -0500
MIME-Version: 1.0
In-Reply-To: <1352271296.2137.35.camel@rzhang1-mobl4>
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
	<1351615741-24134-4-git-send-email-hongbo.zhang@linaro.com>
	<1352271296.2137.35.camel@rzhang1-mobl4>
Date: Fri, 9 Nov 2012 19:54:08 +0800
Message-ID: <CAJLyvQwg6a9-mE1y-XZkb+Sa7XjtsA7KGvhRiKeYFcHFUDuJBQ@mail.gmail.com>
Subject: Re: [PATCH V3 3/5] Thermal: Remove the cooling_cpufreq_list.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kachhap@linaro.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2012 14:54, Zhang Rui <rui.zhang@intel.com> wrote:
> On Tue, 2012-10-30 at 17:48 +0100, hongbo.zhang wrote:
>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>
>> Problem of using this list is that the cpufreq_get_max_state callback will be
>> called when register cooling device by thermal_cooling_device_register, but
>> this list isn't ready at this moment. What's more, there is no need to maintain
>> such a list, we can get cpufreq_cooling_device instance by the private
>> thermal_cooling_device.devdata.
>>
>> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>> Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>
>> Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>
> applied to thermal-next.
Thanks.
I have sent the other updated 4/5 5/5 patches with Reviewed-by added
in a new thread, please have a look there.

>
> thanks,
> rui
>
>> ---
>>  drivers/thermal/cpu_cooling.c | 91 +++++++++----------------------------------
>>  1 file changed, 19 insertions(+), 72 deletions(-)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> index bfd62b7..392d57d 100644
>> --- a/drivers/thermal/cpu_cooling.c
>> +++ b/drivers/thermal/cpu_cooling.c
>> @@ -58,8 +58,9 @@ struct cpufreq_cooling_device {
>>  };
>>  static LIST_HEAD(cooling_cpufreq_list);
>>  static DEFINE_IDR(cpufreq_idr);
>> +static DEFINE_MUTEX(cooling_cpufreq_lock);
>>
>> -static struct mutex cooling_cpufreq_lock;
>> +static unsigned int cpufreq_dev_count;
>>
>>  /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
>>  #define NOTIFY_INVALID NULL
>> @@ -240,28 +241,18 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
>>  static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>>                                unsigned long *state)
>>  {
>> -     int ret = -EINVAL, i = 0;
>> -     struct cpufreq_cooling_device *cpufreq_device;
>> -     struct cpumask *maskPtr;
>> +     struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
>> +     struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
>>       unsigned int cpu;
>>       struct cpufreq_frequency_table *table;
>>       unsigned long count = 0;
>> +     int i = 0;
>>
>> -     mutex_lock(&cooling_cpufreq_lock);
>> -     list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> -             if (cpufreq_device && cpufreq_device->cool_dev == cdev)
>> -                     break;
>> -     }
>> -     if (cpufreq_device == NULL)
>> -             goto return_get_max_state;
>> -
>> -     maskPtr = &cpufreq_device->allowed_cpus;
>>       cpu = cpumask_any(maskPtr);
>>       table = cpufreq_frequency_get_table(cpu);
>>       if (!table) {
>>               *state = 0;
>> -             ret = 0;
>> -             goto return_get_max_state;
>> +             return 0;
>>       }
>>
>>       for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
>> @@ -272,12 +263,10 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>>
>>       if (count > 0) {
>>               *state = --count;
>> -             ret = 0;
>> +             return 0;
>>       }
>>
>> -return_get_max_state:
>> -     mutex_unlock(&cooling_cpufreq_lock);
>> -     return ret;
>> +     return -EINVAL;
>>  }
>>
>>  /**
>> @@ -288,20 +277,10 @@ return_get_max_state:
>>  static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
>>                                unsigned long *state)
>>  {
>> -     int ret = -EINVAL;
>> -     struct cpufreq_cooling_device *cpufreq_device;
>> +     struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
>>
>> -     mutex_lock(&cooling_cpufreq_lock);
>> -     list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> -             if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
>> -                     *state = cpufreq_device->cpufreq_state;
>> -                     ret = 0;
>> -                     break;
>> -             }
>> -     }
>> -     mutex_unlock(&cooling_cpufreq_lock);
>> -
>> -     return ret;
>> +     *state = cpufreq_device->cpufreq_state;
>> +     return 0;
>>  }
>>
>>  /**
>> @@ -312,22 +291,9 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
>>  static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
>>                                unsigned long state)
>>  {
>> -     int ret = -EINVAL;
>> -     struct cpufreq_cooling_device *cpufreq_device;
>> +     struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
>>
>> -     mutex_lock(&cooling_cpufreq_lock);
>> -     list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> -             if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
>> -                     ret = 0;
>> -                     break;
>> -             }
>> -     }
>> -     if (!ret)
>> -             ret = cpufreq_apply_cooling(cpufreq_device, state);
>> -
>> -     mutex_unlock(&cooling_cpufreq_lock);
>> -
>> -     return ret;
>> +     return cpufreq_apply_cooling(cpufreq_device, state);
>>  }
>>
>>  /* Bind cpufreq callbacks to thermal cooling device ops */
>> @@ -351,14 +317,11 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>  {
>>       struct thermal_cooling_device *cool_dev;
>>       struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> -     unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
>> +     unsigned int min = 0, max = 0;
>>       char dev_name[THERMAL_NAME_LENGTH];
>>       int ret = 0, i;
>>       struct cpufreq_policy policy;
>>
>> -     list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
>> -             cpufreq_dev_count++;
>> -
>>       /*Verify that all the clip cpus have same freq_min, freq_max limit*/
>>       for_each_cpu(i, clip_cpus) {
>>               /*continue if cpufreq policy not found and not return error*/
>> @@ -380,9 +343,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>
>>       cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
>>
>> -     if (cpufreq_dev_count == 0)
>> -             mutex_init(&cooling_cpufreq_lock);
>> -
>>       ret = get_idr(&cpufreq_idr, &cpufreq_dev->id);
>>       if (ret) {
>>               kfree(cpufreq_dev);
>> @@ -401,12 +361,12 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>       cpufreq_dev->cool_dev = cool_dev;
>>       cpufreq_dev->cpufreq_state = 0;
>>       mutex_lock(&cooling_cpufreq_lock);
>> -     list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
>>
>>       /* Register the notifier for first cpufreq cooling device */
>>       if (cpufreq_dev_count == 0)
>>               cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
>>                                               CPUFREQ_POLICY_NOTIFIER);
>> +     cpufreq_dev_count++;
>>
>>       mutex_unlock(&cooling_cpufreq_lock);
>>       return cool_dev;
>> @@ -419,33 +379,20 @@ EXPORT_SYMBOL(cpufreq_cooling_register);
>>   */
>>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>>  {
>> -     struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> -     unsigned int cpufreq_dev_count = 0;
>> +     struct cpufreq_cooling_device *cpufreq_dev = cdev->devdata;
>>
>>       mutex_lock(&cooling_cpufreq_lock);
>> -     list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
>> -             if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
>> -                     break;
>> -             cpufreq_dev_count++;
>> -     }
>> -
>> -     if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
>> -             mutex_unlock(&cooling_cpufreq_lock);
>> -             return;
>> -     }
>> -
>> -     list_del(&cpufreq_dev->node);
>> +     cpufreq_dev_count--;
>>
>>       /* Unregister the notifier for the last cpufreq cooling device */
>> -     if (cpufreq_dev_count == 1) {
>> +     if (cpufreq_dev_count == 0) {
>>               cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
>>                                       CPUFREQ_POLICY_NOTIFIER);
>>       }
>>       mutex_unlock(&cooling_cpufreq_lock);
>> +
>>       thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
>>       release_idr(&cpufreq_idr, cpufreq_dev->id);
>> -     if (cpufreq_dev_count == 1)
>> -             mutex_destroy(&cooling_cpufreq_lock);
>>       kfree(cpufreq_dev);
>>  }
>>  EXPORT_SYMBOL(cpufreq_cooling_unregister);
>
>
