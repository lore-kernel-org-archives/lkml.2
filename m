Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2J3IxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:53:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63398 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab2J3IxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAK44p21QhTT0xwUh4d8CzoN3R0Qoz4uXGSu4=a3s7cT49YicNQ@mail.gmail.com>
References: <50898F97.3000202@gmail.com>
	<1351235345-13050-1-git-send-email-hongbo.zhang@linaro.com>
	<CAK44p21QhTT0xwUh4d8CzoN3R0Qoz4uXGSu4=a3s7cT49YicNQ@mail.gmail.com>
Date: Tue, 30 Oct 2012 09:53:02 +0100
Message-ID: <CAJLyvQxF7d44F2hDyL_bk8CTyfs+6=K7eAuWA2d-=12Y45=tQg@mail.gmail.com>
Subject: Re: [PATCH V2 4/6] Thermal: Remove the cooling_cpufreq_list.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 09:03, Amit Kachhap <amit.kachhap@linaro.org> wrote:
> On 26 October 2012 12:39, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>
>> Problem of using this list is that the cpufreq_get_max_state callback will be
>> called when register cooling device by thermal_cooling_device_register, but
>> this list isn't ready at this moment. What's more, there is no need to maintain
>> such a list, we can get cpufreq_cooling_device instance by the private
>> thermal_cooling_device.devdata.
>
> Hi,
>
> Removing this list seems fine as most of frequency checks are moved
> inside generic thermal layer.
> Some minor review comments below,
>
> Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Thanks.
>>
>> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>> ---
>>  drivers/thermal/cpu_cooling.c | 91 +++++++++----------------------------------
>>  1 file changed, 19 insertions(+), 72 deletions(-)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> index 415b041..2ffd12c 100644
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
>>                                  unsigned long *state)
>>  {
>> -       int ret = -EINVAL, i = 0;
>> -       struct cpufreq_cooling_device *cpufreq_device;
>> -       struct cpumask *maskPtr;
>> +       struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> check cdev is not null.
>> +       struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
>>         unsigned int cpu;
>>         struct cpufreq_frequency_table *table;
>>         unsigned long count = 0;
>> +       int i = 0;
>>
>> -       mutex_lock(&cooling_cpufreq_lock);
>> -       list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> -               if (cpufreq_device && cpufreq_device->cool_dev == cdev)
>> -                       break;
>> -       }
>> -       if (cpufreq_device == NULL)
>> -               goto return_get_max_state;
>> -
>> -       maskPtr = &cpufreq_device->allowed_cpus;
>>         cpu = cpumask_any(maskPtr);
>>         table = cpufreq_frequency_get_table(cpu);
>>         if (!table) {
>>                 *state = 0;
>> -               ret = 0;
>> -               goto return_get_max_state;
>> +               return 0;
>>         }
>>
>>         for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
>> @@ -272,12 +263,10 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>>
>>         if (count > 0) {
>>                 *state = --count;
>> -               ret = 0;
>> +               return 0;
>>         }
>>
>> -return_get_max_state:
>> -       mutex_unlock(&cooling_cpufreq_lock);
>> -       return ret;
>> +       return -EINVAL;
>>  }
>>
>>  /**
>> @@ -288,20 +277,10 @@ return_get_max_state:
>>  static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
>>                                  unsigned long *state)
>>  {
>> -       int ret = -EINVAL;
>> -       struct cpufreq_cooling_device *cpufreq_device;
>> +       struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
>>
>> -       mutex_lock(&cooling_cpufreq_lock);
>> -       list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> -               if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
>> -                       *state = cpufreq_device->cpufreq_state;
>> -                       ret = 0;
>> -                       break;
>> -               }
>> -       }
>> -       mutex_unlock(&cooling_cpufreq_lock);
>> -
>> -       return ret;
>> +       *state = cpufreq_device->cpufreq_state;
>> +       return 0;
>>  }
>>
>>  /**
>> @@ -312,22 +291,9 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
>>  static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
>>                                  unsigned long state)
>>  {
>> -       int ret = -EINVAL;
>> -       struct cpufreq_cooling_device *cpufreq_device;
>> +       struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> check cdev is not null
Such values are used in all the three static cpufreq_***_state
callback functions, when these functions are called, cdev->devdata
should have been set in the registration function, and cannot be null,
no body can call these function before registration, so I think there
is no need to add such a check here.

>>
>> -       mutex_lock(&cooling_cpufreq_lock);
>> -       list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> -               if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
>> -                       ret = 0;
>> -                       break;
>> -               }
>> -       }
>> -       if (!ret)
>> -               ret = cpufreq_apply_cooling(cpufreq_device, state);
>> -
>> -       mutex_unlock(&cooling_cpufreq_lock);
>> -
>> -       return ret;
>> +       return cpufreq_apply_cooling(cpufreq_device, state);
>>  }
>>
>>  /* Bind cpufreq callbacks to thermal cooling device ops */
>> @@ -351,7 +317,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>  {
>>         struct thermal_cooling_device *cool_dev;
>>         struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> -       unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
>> +       unsigned int min = 0, max = 0;
>>         char dev_name[THERMAL_NAME_LENGTH];
>>         int ret = 0, i;
>>         struct cpufreq_policy policy;
>> @@ -360,9 +326,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>         if (!cpufreq_frequency_get_table(cpumask_any(clip_cpus)))
>>                 return ERR_PTR(-EPROBE_DEFER);
>>
>> -       list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
>> -               cpufreq_dev_count++;
>> -
>>         /*Verify that all the clip cpus have same freq_min, freq_max limit*/
>>         for_each_cpu(i, clip_cpus) {
>>                 /*continue if cpufreq policy not found and not return error*/
>> @@ -384,9 +347,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>
>>         cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
>>
>> -       if (cpufreq_dev_count == 0)
>> -               mutex_init(&cooling_cpufreq_lock);
>> -
>>         ret = get_idr(&cpufreq_idr, &cpufreq_dev->id);
>>         if (ret) {
>>                 kfree(cpufreq_dev);
>> @@ -405,12 +365,12 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>>         cpufreq_dev->cool_dev = cool_dev;
>>         cpufreq_dev->cpufreq_state = 0;
>>         mutex_lock(&cooling_cpufreq_lock);
>> -       list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
>>
>>         /* Register the notifier for first cpufreq cooling device */
>>         if (cpufreq_dev_count == 0)
>>                 cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
>>                                                 CPUFREQ_POLICY_NOTIFIER);
>> +       cpufreq_dev_count++;
>>
>>         mutex_unlock(&cooling_cpufreq_lock);
>>         return cool_dev;
>> @@ -423,33 +383,20 @@ EXPORT_SYMBOL(cpufreq_cooling_register);
>>   */
>>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>>  {
>> -       struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> -       unsigned int cpufreq_dev_count = 0;
>> +       struct cpufreq_cooling_device *cpufreq_dev = cdev->devdata;
>>
>>         mutex_lock(&cooling_cpufreq_lock);
>> -       list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
>> -               if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
>> -                       break;
>> -               cpufreq_dev_count++;
>> -       }
>> -
>> -       if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
>> -               mutex_unlock(&cooling_cpufreq_lock);
>> -               return;
>> -       }
>> -
>> -       list_del(&cpufreq_dev->node);
>> +       cpufreq_dev_count--;
>>
>>         /* Unregister the notifier for the last cpufreq cooling device */
>> -       if (cpufreq_dev_count == 1) {
>> +       if (cpufreq_dev_count == 0) {
>>                 cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
>>                                         CPUFREQ_POLICY_NOTIFIER);
>>         }
>>         mutex_unlock(&cooling_cpufreq_lock);
>> +
>>         thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
>>         release_idr(&cpufreq_idr, cpufreq_dev->id);
>> -       if (cpufreq_dev_count == 1)
>> -               mutex_destroy(&cooling_cpufreq_lock);
>>         kfree(cpufreq_dev);
>>  }
>>  EXPORT_SYMBOL(cpufreq_cooling_unregister);
>> --
>> 1.7.11.3
>>
>>
>> _______________________________________________
>> linaro-dev mailing list
>> linaro-dev@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-dev
