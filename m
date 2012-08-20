Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2HTJhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:37:07 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:49112 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab2HTJgy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <1345428963.1682.899.camel@rui.sh.intel.com>
References: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
	<1345117305-8299-2-git-send-email-amit.kachhap@linaro.org>
	<1345188250.1682.887.camel@rui.sh.intel.com>
	<CAK44p21qxbpvi0Qtu89ac8ciuJRWDvn44Z8=DggMMxiwjKcczw@mail.gmail.com>
	<CAGF5oy_uhgbzTQeXPyJP51JXxbszX1cL+B=V0mzfRt7bcSi_sQ@mail.gmail.com>
	<1345428963.1682.899.camel@rui.sh.intel.com>
Date: Mon, 20 Aug 2012 12:36:53 +0300
Message-ID: <CAGF5oy95zdLw9+QN2GHkCce0BWLy4KpdvrSX4EtS9JXFyz5g5g@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] thermal: add generic cpufreq cooling implementation
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Kachhap <amit.kachhap@linaro.org>,
        linux-pm@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        SangWook Ju <sw.ju@samsung.com>, Durgadoss <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rui,

On Mon, Aug 20, 2012 at 5:16 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> On 五, 2012-08-17 at 11:56 +0300, Valentin, Eduardo wrote:
>> Hello,
>
>> >>> +
>> >>> +
>> >>> +1.2 CPU cooling action notifier register/unregister interface
>> >>> +1.2.1 int cputherm_register_notifier(struct notifier_block *nb,
>> >>> +     unsigned int list)
>> >>> +
>> >>> +    This interface registers a driver with cpu cooling layer. The driver will
>> >>> +    be notified when any cpu cooling action is called.
>> >>> +
>> >>> +    nb: notifier function to register
>> >>> +    list: CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP
>> >>> +
>> >>> +1.2.2 int cputherm_unregister_notifier(struct notifier_block *nb,
>> >>> +     unsigned int list)
>> >>> +
>> >>> +    This interface registers a driver with cpu cooling layer. The driver will
>> >>> +    be notified when any cpu cooling action is called.
>> >>> +
>> >>> +    nb: notifier function to register
>> >>> +    list: CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP
>> >>
>> >> what are these two APIs used for?
>> >> I did not see they are used in your patch set, do I miss something?
>> > No currently they are not used by my patches. I added them on request
>> > from Eduardo and others
>>
>> Yeah, this was a suggestion as we didn't really know how the FW part
>> would evolve by that time.
>>
>> The reasoning is to allow any interested user (in kernel) to be
>> notified when max frequency changes.
>
> in this case, the cooling device should be updated.
> Say all the target of the thermal_instances of a cooling devices is 0,
> which means they want the cpu to run at maximum frequency, when the max
> frequency changes, we should set the processor to the new max frequency
> as well.
> Using notification is not a good idea as user can not handle this
> without interacting with the thermal framework.
>
> IMO, we should introduce a new API to handle this, rather than just
> notifications to users.

Agreed. The context is actually much wider than the CPU cooling. In
fact, cooling co-processors is actually where things gets a bit
complicated. The idea behind this type of handshaking is to allow the
affected subsystem to change their actual setup when max performance
is not allowed anymore.

>
>>  Actually, the use case behind
>> this is to allow such users to perform some handshaking or stop their
>> activities or even change some paramenters, in case the max frequency
>> would change.
>
> It is the cooling device driver that notice this change first, and it
> should invoke something like thermal_cooling_device_update/rebind() to
> tell the thermal framework this change.
>

Yeah. Ideally, the framework needs to be aware of cooling device state
change. Today, as we have pretty much a broadcast/unidirectional type
of messaging, the framework/policy always assumes the cooling devices
will be in sync with what it is dictated by the policy.

>>  Ideally it would be possible to nack the cooling
>> transition. But that is yet a wider discussion. So far we don't have
>> users for this.
>>
> yep.
> I thought about this before, but I'd prefer to do this when there is a
> real user. Or else, we are kind of over-designing here.
> how about removing this piece of code for now?


Agreed. I second you that this problem is a much wider issue and needs
improvement in the FW itself and how the cooling devices are designed.

>
> thanks,
> rui
>
>> >>
>> >>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> >>> index 7dd8c34..996003b 100644
>> >>> --- a/drivers/thermal/Kconfig
>> >>> +++ b/drivers/thermal/Kconfig
>> >>> @@ -19,6 +19,17 @@ config THERMAL_HWMON
>> >>>       depends on HWMON=y || HWMON=THERMAL
>> >>>       default y
>> >>>
>> >>> +config CPU_THERMAL
>> >>> +     bool "generic cpu cooling support"
>> >>> +     depends on THERMAL && CPU_FREQ
>> >>> +     help
>> >>> +       This implements the generic cpu cooling mechanism through frequency
>> >>> +       reduction, cpu hotplug and any other ways of reducing temperature. An
>> >>> +       ACPI version of this already exists(drivers/acpi/processor_thermal.c).
>> >>> +       This will be useful for platforms using the generic thermal interface
>> >>> +       and not the ACPI interface.
>> >>> +       If you want this support, you should say Y here.
>> >>> +
>> >>>  config SPEAR_THERMAL
>> >>>       bool "SPEAr thermal sensor driver"
>> >>>       depends on THERMAL
>> >>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> >>> index fd9369a..aae59ad 100644
>> >>> --- a/drivers/thermal/Makefile
>> >>> +++ b/drivers/thermal/Makefile
>> >>> @@ -3,5 +3,6 @@
>> >>>  #
>> >>>
>> >>>  obj-$(CONFIG_THERMAL)                += thermal_sys.o
>> >>> +obj-$(CONFIG_CPU_THERMAL)            += cpu_cooling.o
>> >>>  obj-$(CONFIG_SPEAR_THERMAL)          += spear_thermal.o
>> >>>  obj-$(CONFIG_RCAR_THERMAL)   += rcar_thermal.o
>> >>> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> >>> new file mode 100644
>> >>> index 0000000..c42e557
>> >>> --- /dev/null
>> >>> +++ b/drivers/thermal/cpu_cooling.c
>> >>> @@ -0,0 +1,512 @@
>> >>> +/*
>> >>> + *  linux/drivers/thermal/cpu_cooling.c
>> >>> + *
>> >>> + *  Copyright (C) 2012       Samsung Electronics Co., Ltd(http://www.samsung.com)
>> >>> + *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
>> >>> + *
>> >>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >>> + *  This program is free software; you can redistribute it and/or modify
>> >>> + *  it under the terms of the GNU General Public License as published by
>> >>> + *  the Free Software Foundation; version 2 of the License.
>> >>> + *
>> >>> + *  This program is distributed in the hope that it will be useful, but
>> >>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>> >>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> >>> + *  General Public License for more details.
>> >>> + *
>> >>> + *  You should have received a copy of the GNU General Public License along
>> >>> + *  with this program; if not, write to the Free Software Foundation, Inc.,
>> >>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>> >>> + *
>> >>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >>> + */
>> >>> +#include <linux/kernel.h>
>> >>> +#include <linux/module.h>
>> >>> +#include <linux/thermal.h>
>> >>> +#include <linux/platform_device.h>
>> >>> +#include <linux/cpufreq.h>
>> >>> +#include <linux/err.h>
>> >>> +#include <linux/slab.h>
>> >>> +#include <linux/cpu.h>
>> >>> +#include <linux/cpu_cooling.h>
>> >>> +
>> >>> +/**
>> >>> + * struct cpufreq_cooling_device
>> >>> + * @id: unique integer value corresponding to each cpufreq_cooling_device
>> >>> + *   registered.
>> >>> + * @cool_dev: thermal_cooling_device pointer to keep track of the the
>> >>> + *   egistered cooling device.
>> >>> + * @cpufreq_state: integer value representing the current state of cpufreq
>> >>> + *   cooling devices.
>> >>> + * @cpufreq_val: integer value representing the absolute value of the clipped
>> >>> + *   frequency.
>> >>> + * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
>> >>> + * @node: list_head to link all cpufreq_cooling_device together.
>> >>> + *
>> >>> + * This structure is required for keeping information of each
>> >>> + * cpufreq_cooling_device registered as a list whose head is represented by
>> >>> + * cooling_cpufreq_list. In order to prevent corruption of this list a
>> >>> + * mutex lock cooling_cpufreq_lock is used.
>> >>> + */
>> >>> +struct cpufreq_cooling_device {
>> >>> +     int id;
>> >>> +     struct thermal_cooling_device *cool_dev;
>> >>> +     unsigned int cpufreq_state;
>> >>> +     unsigned int cpufreq_val;
>> >>> +     struct cpumask allowed_cpus;
>> >>> +     struct list_head node;
>> >>> +};
>> >>> +static LIST_HEAD(cooling_cpufreq_list);
>> >>> +static DEFINE_IDR(cpufreq_idr);
>> >>> +
>> >>> +static struct mutex cooling_cpufreq_lock;
>> >>> +
>> >>> +/* notify_table passes value to the CPUFREQ_ADJUST callback function. */
>> >>> +#define NOTIFY_INVALID NULL
>> >>> +struct cpufreq_cooling_device *notify_device;
>> >>> +
>> >>> +/* Head of the blocking notifier chain to inform about frequency clamping */
>> >>> +static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
>> >>> +
>> >>> +/**
>> >>> + * get_idr - function to get a unique id.
>> >>> + * @idr: struct idr * handle used to create a id.
>> >>> + * @id: int * value generated by this function.
>> >>> + */
>> >>> +static int get_idr(struct idr *idr, int *id)
>> >>> +{
>> >>> +     int err;
>> >>> +again:
>> >>> +     if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
>> >>> +             return -ENOMEM;
>> >>> +
>> >>> +     mutex_lock(&cooling_cpufreq_lock);
>> >>> +     err = idr_get_new(idr, NULL, id);
>> >>> +     mutex_unlock(&cooling_cpufreq_lock);
>> >>> +
>> >>> +     if (unlikely(err == -EAGAIN))
>> >>> +             goto again;
>> >>> +     else if (unlikely(err))
>> >>> +             return err;
>> >>> +
>> >>> +     *id = *id & MAX_ID_MASK;
>> >>> +     return 0;
>> >>> +}
>> >>> +
>> >>> +/**
>> >>> + * release_idr - function to free the unique id.
>> >>> + * @idr: struct idr * handle used for creating the id.
>> >>> + * @id: int value representing the unique id.
>> >>> + */
>> >>> +static void release_idr(struct idr *idr, int id)
>> >>> +{
>> >>> +     mutex_lock(&cooling_cpufreq_lock);
>> >>> +     idr_remove(idr, id);
>> >>> +     mutex_unlock(&cooling_cpufreq_lock);
>> >>> +}
>> >>> +
>> >>> +/**
>> >>> + * cputherm_register_notifier - Register a notifier with cpu cooling interface.
>> >>> + * @nb:      struct notifier_block * with callback info.
>> >>> + * @list: integer value for which notification is needed. possible values are
>> >>> + *   CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
>> >>> + *
>> >>> + * This exported function registers a driver with cpu cooling layer. The driver
>> >>> + * will be notified when any cpu cooling action is called.
>> >>> + */
>> >>> +int cputherm_register_notifier(struct notifier_block *nb, unsigned int list)
>> >>> +{
>> >>> +     int ret = 0;
>> >>> +
>> >>> +     switch (list) {
>> >>> +     case CPUFREQ_COOLING_START:
>> >>> +     case CPUFREQ_COOLING_STOP:
>> >>> +             ret = blocking_notifier_chain_register(
>> >>> +                             &cputherm_state_notifier_list, nb);
>> >>> +             break;
>> >>> +     default:
>> >>> +             ret = -EINVAL;
>> >>> +     }
>> >>> +     return ret;
>> >>> +}
>> >>> +EXPORT_SYMBOL(cputherm_register_notifier);
>> >>> +
>> >>> +/**
>> >>> + * cputherm_unregister_notifier - Un-register a notifier.
>> >>> + * @nb:      struct notifier_block * with callback info.
>> >>> + * @list: integer value for which notification is needed. values possible are
>> >>> + *   CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP.
>> >>> + *
>> >>> + * This exported function un-registers a driver with cpu cooling layer.
>> >>> + */
>> >>> +int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list)
>> >>> +{
>> >>> +     int ret = 0;
>> >>> +
>> >>> +     switch (list) {
>> >>> +     case CPUFREQ_COOLING_START:
>> >>> +     case CPUFREQ_COOLING_STOP:
>> >>> +             ret = blocking_notifier_chain_unregister(
>> >>> +                             &cputherm_state_notifier_list, nb);
>> >>> +             break;
>> >>> +     default:
>> >>> +             ret = -EINVAL;
>> >>> +     }
>> >>> +     return ret;
>> >>> +}
>> >>> +EXPORT_SYMBOL(cputherm_unregister_notifier);
>> >>> +
>> >>> +/* Below code defines functions to be used for cpufreq as cooling device */
>> >>> +
>> >>> +/**
>> >>> + * is_cpufreq_valid - function to check if a cpu has frequency transition policy.
>> >>> + * @cpu: cpu for which check is needed.
>> >>> + */
>> >>> +static int is_cpufreq_valid(int cpu)
>> >>> +{
>> >>> +     struct cpufreq_policy policy;
>> >>> +     return !cpufreq_get_policy(&policy, cpu);
>> >>> +}
>> >>> +
>> >>> +/**
>> >>> + * get_cpu_frequency - get the absolute value of frequency from level.
>> >>> + * @cpu: cpu for which frequency is fetched.
>> >>> + * @level: level of frequency of the CPU
>> >>> + *   e.g level=1 --> 1st MAX FREQ, LEVEL=2 ---> 2nd MAX FREQ, .... etc
>> >>> + */
>> >>> +static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>> >>> +{
>> >>> +     int ret = 0, i = 0;
>> >>> +     unsigned long level_index;
>> >>> +     bool descend = false;
>> >>> +     struct cpufreq_frequency_table *table =
>> >>> +                                     cpufreq_frequency_get_table(cpu);
>> >>> +     if (!table)
>> >>> +             return ret;
>> >>> +
>> >>> +     while (table[i].frequency != CPUFREQ_TABLE_END) {
>> >>> +             if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >>> +                     continue;
>> >>> +
>> >>> +             /*check if table in ascending or descending order*/
>> >>> +             if ((table[i + 1].frequency != CPUFREQ_TABLE_END) &&
>> >>> +                     (table[i + 1].frequency < table[i].frequency)
>> >>> +                     && !descend) {
>> >>> +                     descend = true;
>> >>> +             }
>> >>> +
>> >>> +             /*return if level matched and table in descending order*/
>> >>> +             if (descend && i == level)
>> >>> +                     return table[i].frequency;
>> >>> +             i++;
>> >>> +     }
>> >>> +     i--;
>> >>> +
>> >>> +     if (level > i || descend)
>> >>> +             return ret;
>> >>> +     level_index = i - level;
>> >>> +
>> >>> +     /*Scan the table in reverse order and match the level*/
>> >>> +     while (i >= 0) {
>> >>> +             if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >>> +                     continue;
>> >>> +             /*return if level matched*/
>> >>> +             if (i == level_index)
>> >>> +                     return table[i].frequency;
>> >>> +             i--;
>> >>> +     }
>> >>> +     return ret;
>> >>> +}
>> >>> +
>> >>> +/**
>> >>> + * cpufreq_apply_cooling - function to apply frequency clipping.
>> >>> + * @cpufreq_device: cpufreq_cooling_device pointer containing frequency
>> >>> + *   clipping data.
>> >>> + * @cooling_state: value of the cooling state.
>> >>> + */
>> >>> +static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>> >>> +                             unsigned long cooling_state)
>> >>> +{
>> >>> +     unsigned int event, cpuid, clip_freq;
>> >>> +     struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
>> >>> +     unsigned int cpu = cpumask_any(maskPtr);
>> >>> +
>> >>> +
>> >>> +     /* Check if the old cooling action is same as new cooling action */
>> >>> +     if (cpufreq_device->cpufreq_state == cooling_state)
>> >>> +             return 0;
>> >>> +
>> >>> +     clip_freq = get_cpu_frequency(cpu, cooling_state);
>> >>> +     if (!clip_freq)
>> >>> +             return -EINVAL;
>> >>> +
>> >>> +     cpufreq_device->cpufreq_state = cooling_state;
>> >>> +     cpufreq_device->cpufreq_val = clip_freq;
>> >>> +     notify_device = cpufreq_device;
>> >>> +
>> >>> +     if (cooling_state != 0)
>> >>> +             event = CPUFREQ_COOLING_START;
>> >>> +     else
>> >>> +             event = CPUFREQ_COOLING_STOP;
>> >>> +
>> >>> +     blocking_notifier_call_chain(&cputherm_state_notifier_list,
>> >>> +                                             event, &clip_freq);
>> >>> +
>> >>> +     for_each_cpu(cpuid, maskPtr) {
>> >>> +             if (is_cpufreq_valid(cpuid))
>> >>> +                     cpufreq_update_policy(cpuid);
>> >>> +     }
>> >>> +
>> >>> +     notify_device = NOTIFY_INVALID;
>> >>> +
>> >>> +     return 0;
>> >>> +}
>> >>> +
>> >>> +/**
>> >>> + * cpufreq_thermal_notifier - notifier callback for cpufreq policy change.
>> >>> + * @nb:      struct notifier_block * with callback info.
>> >>> + * @event: value showing cpufreq event for which this function invoked.
>> >>> + * @data: callback-specific data
>> >>> + */
>> >>> +static int cpufreq_thermal_notifier(struct notifier_block *nb,
>> >>> +                                     unsigned long event, void *data)
>> >>> +{
>> >>> +     struct cpufreq_policy *policy = data;
>> >>> +     unsigned long max_freq = 0;
>> >>> +
>> >>> +     if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
>> >>> +             return 0;
>> >>> +
>> >>> +     if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
>> >>> +             max_freq = notify_device->cpufreq_val;
>> >>> +
>> >>> +     /* Never exceed user_policy.max*/
>> >>> +     if (max_freq > policy->user_policy.max)
>> >>> +             max_freq = policy->user_policy.max;
>> >>> +
>> >>> +     if (policy->max != max_freq)
>> >>> +             cpufreq_verify_within_limits(policy, 0, max_freq);
>> >>> +
>> >>> +     return 0;
>> >>> +}
>> >>> +
>> >>> +/*
>> >>> + * cpufreq cooling device callback functions are defined below
>> >>> + */
>> >>> +
>> >>> +/**
>> >>> + * cpufreq_get_max_state - callback function to get the max cooling state.
>> >>> + * @cdev: thermal cooling device pointer.
>> >>> + * @state: fill this variable with the max cooling state.
>> >>> + */
>> >>> +static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>> >>> +                              unsigned long *state)
>> >>> +{
>> >>> +     int ret = -EINVAL, i = 0;
>> >>> +     struct cpufreq_cooling_device *cpufreq_device;
>> >>> +     struct cpumask *maskPtr;
>> >>> +     unsigned int cpu;
>> >>> +     struct cpufreq_frequency_table *table;
>> >>> +
>> >>> +     mutex_lock(&cooling_cpufreq_lock);
>> >>> +     list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> >>> +             if (cpufreq_device && cpufreq_device->cool_dev == cdev)
>> >>> +                     break;
>> >>> +     }
>> >>> +     if (cpufreq_device == NULL)
>> >>> +             goto return_get_max_state;
>> >>> +
>> >>> +     maskPtr = &cpufreq_device->allowed_cpus;
>> >>> +     cpu = cpumask_any(maskPtr);
>> >>> +     table = cpufreq_frequency_get_table(cpu);
>> >>> +     if (!table) {
>> >>> +             *state = 0;
>> >>> +             ret = 0;
>> >>> +             goto return_get_max_state;
>> >>> +     }
>> >>> +
>> >>> +     while (table[i].frequency != CPUFREQ_TABLE_END) {
>> >>> +             if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>> >>> +                     continue;
>> >>> +             i++;
>> >>> +     }
>> >>> +     if (i > 0) {
>> >>> +             *state = --i;
>> >>> +             ret = 0;
>> >>> +     }
>> >>> +
>> >>> +return_get_max_state:
>> >>> +     mutex_unlock(&cooling_cpufreq_lock);
>> >>> +     return ret;
>> >>> +}
>> >>> +
>> >>> +/**
>> >>> + * cpufreq_get_cur_state - callback function to get the current cooling state.
>> >>> + * @cdev: thermal cooling device pointer.
>> >>> + * @state: fill this variable with the current cooling state.
>> >>> + */
>> >>> +static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
>> >>> +                              unsigned long *state)
>> >>> +{
>> >>> +     int ret = -EINVAL;
>> >>> +     struct cpufreq_cooling_device *cpufreq_device;
>> >>> +
>> >>> +     mutex_lock(&cooling_cpufreq_lock);
>> >>> +     list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>> >>> +             if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
>> >>> +                     *state = cpufreq_device->cpufreq_state;
>> >>> +                     ret = 0;
>> >>> +                     break;
>> >>> +             }
>> >>> +     }
>> >>> +     mutex_unlock(&cooling_cpufreq_lock);
>> >>> +
>> >>
>> >> as cpufreq may be changed in other places, e.g. via sysfs I/F, we should
>> >> use the current cpu frequency to get the REAL cooling state, rather than
>> >> using a cached value.
>> >
>> > Yes agreed , I will repost with your suggestion.
>> >
>> > Thanks,
>> > Amit
>> >>
>> >> thanks,
>> >> rui
>> >>
>> >>
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

Eduardo Valentin
