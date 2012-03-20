Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2CTGGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:06:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37904 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2CTGGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F671C64.5020803@linux.vnet.ibm.com>
References: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
	<1332137864-12943-4-git-send-email-amit.kachhap@linaro.org>
	<4F671C64.5020803@linux.vnet.ibm.com>
Date: Tue, 20 Mar 2012 11:36:18 +0530
Message-ID: <CAK44p20K-GyG5o6=BzK7iPZTDNepPh3iKYm0Bi1PETBp0sVRsQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/6] thermal: Add generic cpuhotplug cooling implementation
From: Amit Kachhap <amit.kachhap@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        patches@linaro.org, eduardo.valentin@ti.com, durgadoss.r@intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2012 17:15, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 03/19/2012 11:47 AM, Amit Daniel Kachhap wrote:
>
>> This patch adds support for generic cpu thermal cooling low level
>> implementations using cpuhotplug based on the thermal level requested
>> from user. Different cpu related cooling devices can be registered by the
>> user and the binding of these cooling devices to the corresponding
>> trip points can be easily done as the registration APIs return the
>> cooling device pointer. The user of these APIs are responsible for
>> passing the cpumask.
>>
>
>
> I am really not aware of the cpu thermal cooling stuff, but since this patch
> deals with CPU Hotplug (which I am interested in), I have some questions
> below..
>
>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>> +
>> +static int cpuhotplug_get_cur_state(struct thermal_cooling_device *cdev,
>> +                              unsigned long *state)
>> +{
>> +     int ret = -EINVAL;
>> +     struct hotplug_cooling_device *hotplug_dev;
>> +
>> +     mutex_lock(&cooling_cpuhotplug_lock);
>> +     list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node) {
>> +             if (hotplug_dev && hotplug_dev->cool_dev == cdev) {
>> +                     *state = hotplug_dev->hotplug_state;
>> +                     ret = 0;
>> +                     break;
>> +             }
>> +     }
>> +     mutex_unlock(&cooling_cpuhotplug_lock);
>> +     return ret;
>> +}
>> +
>> +/*This cooling may be as ACTIVE type*/
>> +static int cpuhotplug_set_cur_state(struct thermal_cooling_device *cdev,
>> +                              unsigned long state)
>> +{
>> +     int cpuid, this_cpu = smp_processor_id();
>
>
> What prevents this task from being migrated to another CPU?
> IOW, what ensures that 'this_cpu' remains valid throughout this function?
>
> I see that you are acquiring mutex locks below.. So this is definitely not
> a preempt disabled section.. so I guess my question above is valid..
>
> Or is this code bound to a particular cpu?

No this thread is not bound to a cpu. Your comment is valid and some
synchronization is needed for preemption. Thanks for pointing this
out.

>
>> +     struct hotplug_cooling_device *hotplug_dev;
>> +
>> +     mutex_lock(&cooling_cpuhotplug_lock);
>> +     list_for_each_entry(hotplug_dev, &cooling_cpuhotplug_list, node)
>> +             if (hotplug_dev && hotplug_dev->cool_dev == cdev)
>> +                     break;
>> +
>> +     mutex_unlock(&cooling_cpuhotplug_lock);
>> +     if (!hotplug_dev || hotplug_dev->cool_dev != cdev)
>> +             return -EINVAL;
>> +
>> +     if (hotplug_dev->hotplug_state == state)
>> +             return 0;
>> +
>> +     /*
>> +     * This cooling device may be of type ACTIVE, so state field can
>> +     * be 0 or 1
>> +     */
>> +     if (state == 1) {
>> +             for_each_cpu(cpuid, hotplug_dev->allowed_cpus) {
>> +                     if (cpu_online(cpuid) && (cpuid != this_cpu))
>
>
> What prevents the cpu numbered cpuid from being taken down right at this moment?
> Don't you need explicit synchronization with CPU Hotplug using something like
> get_online_cpus()/put_online_cpus() here?
>
>> +                             cpu_down(cpuid);
>> +             }
>> +     } else if (state == 0) {
>> +             for_each_cpu(cpuid, hotplug_dev->allowed_cpus) {
>> +                     if (!cpu_online(cpuid) && (cpuid != this_cpu))
>
>
> Same here.
>
>> +                             cpu_up(cpuid);
>> +             }
>> +     } else {
>> +             return -EINVAL;
>> +     }
>> +
>> +     hotplug_dev->hotplug_state = state;
>> +
>> +     return 0;
>> +}
>> +/* bind hotplug callbacks to cpu hotplug cooling device */
>> +static struct thermal_cooling_device_ops cpuhotplug_cooling_ops = {
>> +     .get_max_state = cpuhotplug_get_max_state,
>> +     .get_cur_state = cpuhotplug_get_cur_state,
>> +     .set_cur_state = cpuhotplug_set_cur_state,
>> +};
>> +
>
