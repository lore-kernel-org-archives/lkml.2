Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2EII1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:27:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33649 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab2EII1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:27:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120508131626.ffe262f6.akpm@linux-foundation.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-3-git-send-email-amit.kachhap@linaro.org>
	<20120508131626.ffe262f6.akpm@linux-foundation.org>
Date: Wed, 9 May 2012 13:57:01 +0530
Message-ID: <CAK44p20fjH7B8O3whMXh8C+X2nQ31=Sx5iNqW8LHrfOWUt_VpA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] thermal: Add generic cpufreq cooling implementation
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org, durgadoss.r@intel.com,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2012 01:46, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue,  8 May 2012 21:48:14 +0530
> Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:
>
>> This patch adds support for generic cpu thermal cooling low level
>> implementations using frequency scaling up/down based on the registration
>> parameters. Different cpu related cooling devices can be registered by the
>> user and the binding of these cooling devices to the corresponding
>> trip points can be easily done as the registration APIs return the
>> cooling device pointer. The user of these APIs are responsible for
>> passing clipping frequency . The drivers can also register to recieve
>> notification about any cooling action called. Even the driver can effect
>> the cooling action by modifying the default data such as freq_clip_max if
>> needed.
>>
>>
>> ...
>>
>> +struct cpufreq_cooling_device {
>> +     int id;
>> +     struct thermal_cooling_device *cool_dev;
>> +     struct freq_clip_table *tab_ptr;
>> +     unsigned int tab_size;
>> +     unsigned int cpufreq_state;
>> +     const struct cpumask *allowed_cpus;
>> +     struct list_head node;
>> +};
>
> It would be nice to document the fields.  Especially id, tab_size,
> cpufreq_state and node.  For `node' we should describe the locking for
> the list, and describe which list_head anchors this list.

Thanks Andrew for the detailed review. I will add more documentation
and post the next version shortly.
>
>> +static LIST_HEAD(cooling_cpufreq_list);
>> +static DEFINE_MUTEX(cooling_cpufreq_lock);
>> +static DEFINE_IDR(cpufreq_idr);
>> +static DEFINE_PER_CPU(unsigned int, max_policy_freq);
>> +static struct freq_clip_table *notify_table;
>> +static int notify_state;
>> +static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
>> +
>> +static int get_idr(struct idr *idr, struct mutex *lock, int *id)
>> +{
>> +     int err;
>> +again:
>> +     if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
>> +             return -ENOMEM;
>> +
>> +     if (lock)
>> +             mutex_lock(lock);
>
> The test for NULL `lock' is unneeded.  In fact the `lock' argument
> could be removed altogether - just use cooling_cpufreq_lock directly.
Agreed
>
>> +     err = idr_get_new(idr, NULL, id);
>> +     if (lock)
>> +             mutex_unlock(lock);
>> +     if (unlikely(err == -EAGAIN))
>> +             goto again;
>> +     else if (unlikely(err))
>> +             return err;
>> +
>> +     *id = *id & MAX_ID_MASK;
>> +     return 0;
>> +}
>> +
>> +static void release_idr(struct idr *idr, struct mutex *lock, int id)
>> +{
>> +     if (lock)
>> +             mutex_lock(lock);
>
> Ditto.
>
>> +     idr_remove(idr, id);
>> +     if (lock)
>> +             mutex_unlock(lock);
>> +}
>> +
>>
>> ...
>>
>> +
>> +/*Below codes defines functions to be used for cpufreq as cooling device*/
>> +static bool is_cpufreq_valid(int cpu)
>> +{
>> +     struct cpufreq_policy policy;
>> +     return !cpufreq_get_policy(&policy, cpu) ? true : false;
>
> Can use
Ok
>
>        return !cpufreq_get_policy(&policy, cpu);
>
>> +}
>> +
>> +static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>> +                             unsigned long cooling_state)
>> +{
>> +     unsigned int event, cpuid;
>> +     struct freq_clip_table *th_table;
>> +
>> +     if (cooling_state > cpufreq_device->tab_size)
>> +             return -EINVAL;
>> +
>> +     cpufreq_device->cpufreq_state = cooling_state;
>> +
>> +     /*cpufreq thermal notifier uses this cpufreq device pointer*/
>
> This code looks like it was written by two people.
>
>        /* One who does this */
>        /*And one who does this*/
>
> The first one was right.  Please go through all the comments in all the
> patches and get the layout consistent?
Sure will add more details.
>
>
>> +     notify_state = cooling_state;
>> +
>> +     if (notify_state > 0) {
>> +             th_table = &(cpufreq_device->tab_ptr[cooling_state - 1]);
>> +             memcpy(notify_table, th_table, sizeof(struct freq_clip_table));
>> +             event = CPUFREQ_COOLING_TYPE;
>> +             blocking_notifier_call_chain(&cputherm_state_notifier_list,
>> +                                             event, notify_table);
>> +     }
>> +
>> +     for_each_cpu(cpuid, cpufreq_device->allowed_cpus) {
>> +             if (is_cpufreq_valid(cpuid))
>> +                     cpufreq_update_policy(cpuid);
>> +     }
>> +
>> +     notify_state = -1;
>> +
>> +     return 0;
>> +}
>> +
>> +static int cpufreq_thermal_notifier(struct notifier_block *nb,
>> +                                     unsigned long event, void *data)
>> +{
>> +     struct cpufreq_policy *policy = data;
>> +     unsigned long max_freq = 0;
>> +
>> +     if ((event != CPUFREQ_ADJUST) || (notify_state == -1))
>
> Please document `notify_state', at its definition site.  This reader
> doesn't know what "notify_state == -1" *means*.
>
>> +             return 0;
>> +
>> +     if (notify_state > 0) {
>> +             max_freq = notify_table->freq_clip_max;
>> +
>> +             if (per_cpu(max_policy_freq, policy->cpu) == 0)
>> +                     per_cpu(max_policy_freq, policy->cpu) = policy->max;
>> +     } else {
>> +             if (per_cpu(max_policy_freq, policy->cpu) != 0) {
>> +                     max_freq = per_cpu(max_policy_freq, policy->cpu);
>> +                     per_cpu(max_policy_freq, policy->cpu) = 0;
>> +             } else {
>> +                     max_freq = policy->max;
>> +             }
>> +     }
>> +
>> +     /* Never exceed user_policy.max*/
>> +     if (max_freq > policy->user_policy.max)
>> +             max_freq = policy->user_policy.max;
>> +
>> +     if (policy->max != max_freq)
>> +             cpufreq_verify_within_limits(policy, 0, max_freq);
>> +
>> +     return 0;
>> +}
>> +
>>
>> ...
>>
>> +/*This cooling may be as PASSIVE/ACTIVE type*/
>> +static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
>> +                              unsigned long state)
>> +{
>> +     int ret = -EINVAL;
>> +     struct cpufreq_cooling_device *cpufreq_device;
>> +
>> +     mutex_lock(&cooling_cpufreq_lock);
>> +     list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> +             if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
>> +                     ret = 0;
>> +                     break;
>> +             }
>> +     }
>> +     mutex_unlock(&cooling_cpufreq_lock);
>> +
>> +     if (!ret)
>> +             ret = cpufreq_apply_cooling(cpufreq_device, state);
>
> Now that we've dropped the lock, what prevents *cpufreq_device from
> getting freed, or undesirably altered?
Agreed the lock can be put over the entire funtion.
>
>> +     return ret;
>> +}
>> +
>> +/* bind cpufreq callbacks to cpufreq cooling device */
>> +static struct thermal_cooling_device_ops cpufreq_cooling_ops = {
>
> Can it be made const?
Yes it can be made const as it is unmodified.
>
>> +     .get_max_state = cpufreq_get_max_state,
>> +     .get_cur_state = cpufreq_get_cur_state,
>> +     .set_cur_state = cpufreq_set_cur_state,
>> +};
>> +
>> +static struct notifier_block thermal_cpufreq_notifier_block = {
>> +     .notifier_call = cpufreq_thermal_notifier,
>> +};
>> +
>> +struct thermal_cooling_device *cpufreq_cooling_register(
>> +     struct freq_clip_table *tab_ptr, unsigned int tab_size,
>> +     const struct cpumask *mask_val)
>> +{
>> +     struct thermal_cooling_device *cool_dev;
>> +     struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> +     unsigned int cpufreq_dev_count = 0;
>> +     char dev_name[THERMAL_NAME_LENGTH];
>> +     int ret = 0, id = 0, i;
>> +
>> +     if (tab_ptr == NULL || tab_size == 0)
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
>> +             cpufreq_dev_count++;
>> +
>> +     cpufreq_dev =
>> +             kzalloc(sizeof(struct cpufreq_cooling_device), GFP_KERNEL);
>
> The 80-col contortions are ugly.  Alternatives are
>
>        cpufreq_dev = kzalloc(sizeof(struct cpufreq_cooling_device),
>                              GFP_KERNEL);
>
> or, better,
>
>        cpufreq_dev = kzalloc(sizeof(*cpufreq_dev), GFP_KERNEL);

Ok will use shorter variables.
>
>
>> +     if (!cpufreq_dev)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     if (cpufreq_dev_count == 0) {
>> +             notify_table = kzalloc(sizeof(struct freq_clip_table),
>> +                                     GFP_KERNEL);
>> +             if (!notify_table) {
>> +                     kfree(cpufreq_dev);
>> +                     return ERR_PTR(-ENOMEM);
>> +             }
>> +     }
>> +
>> +     cpufreq_dev->tab_ptr = tab_ptr;
>> +     cpufreq_dev->tab_size = tab_size;
>> +     cpufreq_dev->allowed_cpus = mask_val;
>> +
>> +     /* Initialize all the tab_ptr->mask_val to the passed mask_val */
>> +     for (i = 0; i < tab_size; i++)
>> +             ((struct freq_clip_table *)&tab_ptr[i])->mask_val = mask_val;
>> +
>> +     ret = get_idr(&cpufreq_idr, &cooling_cpufreq_lock, &cpufreq_dev->id);
>
> hm, "get_idr" is a poor name.  One would expect it to do a lookup, but
> it actually does an installation.  That's a result of the poorly-named
> idr_get_new(), I expect.
>
>
>> +     if (ret) {
>> +             kfree(cpufreq_dev);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
>> +
>> +     cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
>> +                                             &cpufreq_cooling_ops);
>> +     if (!cool_dev) {
>> +             release_idr(&cpufreq_idr, &cooling_cpufreq_lock,
>> +                                             cpufreq_dev->id);
>> +             kfree(cpufreq_dev);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +     cpufreq_dev->id = id;
>> +     cpufreq_dev->cool_dev = cool_dev;
>> +     mutex_lock(&cooling_cpufreq_lock);
>> +     list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
>> +     mutex_unlock(&cooling_cpufreq_lock);
>> +
>> +     /*Register the notifier for first cpufreq cooling device*/
>> +     if (cpufreq_dev_count == 0)
>> +             cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
>> +                                             CPUFREQ_POLICY_NOTIFIER);
>> +     return cool_dev;
>> +}
>> +EXPORT_SYMBOL(cpufreq_cooling_register);
>> +
>> +void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>> +{
>> +     struct cpufreq_cooling_device *cpufreq_dev = NULL;
>> +     unsigned int cpufreq_dev_count = 0;
>> +
>> +     mutex_lock(&cooling_cpufreq_lock);
>> +     list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
>> +             if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
>> +                     break;
>> +             cpufreq_dev_count++;
>> +     }
>> +
>> +     if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
>> +             mutex_unlock(&cooling_cpufreq_lock);
>> +             return;
>> +     }
>> +
>> +     list_del(&cpufreq_dev->node);
>> +     mutex_unlock(&cooling_cpufreq_lock);
>> +
>> +     /*Unregister the notifier for the last cpufreq cooling device*/
>> +     if (cpufreq_dev_count == 1) {
>
> But we dropped the lock, so local variable cpufreq_dev_count is now
> meaningless.  What prevents a race here?
Yes lock can be extended to include it.
>
>> +             cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
>> +                                     CPUFREQ_POLICY_NOTIFIER);
>> +             kfree(notify_table);
>> +     }
>> +
>> +     thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
>> +     release_idr(&cpufreq_idr, &cooling_cpufreq_lock, cpufreq_dev->id);
>> +     kfree(cpufreq_dev);
>> +}
>> +EXPORT_SYMBOL(cpufreq_cooling_unregister);
>>
>> ...
>>
>> +struct freq_clip_table {
>> +     unsigned int freq_clip_max;
>> +     unsigned int polling_interval;
>> +     unsigned int temp_level;
>> +     const struct cpumask *mask_val;
>> +};
>
> hm, what does this thing do.  Needs a nice comment for the uninitiated,
> please.  Something which describes the overall roles, responsibilities
> and general reasons for existence.
Ok
>
>> +int cputherm_register_notifier(struct notifier_block *nb, unsigned int list);
>> +int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list);
>> +
>> +#ifdef CONFIG_CPU_FREQ
>> +struct thermal_cooling_device *cpufreq_cooling_register(
>> +     struct freq_clip_table *tab_ptr, unsigned int tab_size,
>> +     const struct cpumask *mask_val);
>> +
>> +void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
>> +#else /*!CONFIG_CPU_FREQ*/
>
> (more whacky comment layout)
>
>>
>> ...
>>
>
