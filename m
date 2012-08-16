Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2HPOwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:52:41 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:37842 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654Ab2HPOwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <1345117305-8299-2-git-send-email-amit.kachhap@linaro.org>
References: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
	<1345117305-8299-2-git-send-email-amit.kachhap@linaro.org>
Date: Thu, 16 Aug 2012 17:52:33 +0300
Message-ID: <CAGF5oy8wLjU0-nnqyv1KfxtpzBZV6h8ksyBHpm-nfNVMyfB5kA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH v6 1/6] thermal: add generic cpufreq cooling implementation
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-samsung-soc@vger.kernel.org, SangWook Ju <sw.ju@samsung.com>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-acpi@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Jean Delvare <khali@linux-fr.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit,

Thanks again for keeping this up.

On Thu, Aug 16, 2012 at 2:41 PM, Amit Daniel Kachhap
<amit.kachhap@linaro.org> wrote:
> This patchset introduces a new generic cooling device based on cpufreq
> that can be used on non-ACPI platforms.  As a proof of concept, we have
> drivers for the following platforms using this mechanism now:
>
>  * Samsung Exynos (Exynos4 and Exynos5) in the current patchset.
>  * Freescale i.MX (git://git.linaro.org/people/amitdanielk/linux.git imx6q_thermal)

FYI, the OMAP code is under drivers/staging/omap-thermal/. The file
omap-thermal-common.c is the one which is using your generic cooling
device. But it needs to be updated accordingly to the API change you
mention.

>
> There is a small change in cpufreq cooling registration APIs, so a minor
> change is needed for Freescale platforms.
>
> Brief Description:
>
> 1) The generic cooling devices code is placed inside driver/thermal/*
>    as placing inside acpi folder will need un-necessary enabling of acpi
>    code.  This code is architecture independent.
>
> 2) This patchset adds generic cpu cooling low level implementation
>    through frequency clipping.  In future, other cpu related cooling
>    devices may be added here.  An ACPI version of this already exists
>    (drivers/acpi/processor_thermal.c) .But this will be useful for
>    platforms like ARM using the generic thermal interface along with the
>    generic cpu cooling devices.  The cooling device registration API's
>    return cooling device pointers which can be easily binded with the
>    thermal zone trip points.  The important APIs exposed are,
>
>    a) struct thermal_cooling_device *cpufreq_cooling_register(
>         struct cpumask *clip_cpus)
>    b) void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>
> 3) Samsung exynos platform thermal implementation is done using the
>    generic cpu cooling APIs and the new trip type.  The temperature sensor
>    driver present in the hwmon folder(registered as hwmon driver) is moved
>    to thermal folder and registered as a thermal driver.
>
> A simple data/control flow diagrams is shown below,
>
> Core Linux thermal <----->  Exynos thermal interface <----- Temperature Sensor
>           |                             |
>          \|/                            |
>   Cpufreq cooling device <---------------
>
> TODO:
> *Will send the DT enablement patches later after the driver is merged.
>
> This patch:
>
> Add support for generic cpu thermal cooling low level implementations
> using frequency scaling up/down based on the registration parameters.
> Different cpu related cooling devices can be registered by the user and
> the binding of these cooling devices to the corresponding trip points can
> be easily done as the registration APIs return the cooling device pointer.
> The user of these APIs are responsible for passing clipping frequency .
> The drivers can also register to recieve notification about any cooling
> action called.
>
> [akpm@linux-foundation.org: fix comment layout]
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: SangWook Ju <sw.ju@samsung.com>
> Cc: Durgadoss <durgadoss.r@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Kyungmin Park <kmpark@infradead.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>


Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>


> ---
>  Documentation/thermal/cpu-cooling-api.txt |   52 +++
>  drivers/thermal/Kconfig                   |   11 +
>  drivers/thermal/Makefile                  |    1 +
>  drivers/thermal/cpu_cooling.c             |  512 +++++++++++++++++++++++++++++
>  include/linux/cpu_cooling.h               |   79 +++++
>  5 files changed, 655 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/thermal/cpu-cooling-api.txt
>  create mode 100644 drivers/thermal/cpu_cooling.c
>  create mode 100644 include/linux/cpu_cooling.h
>
> diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
> new file mode 100644
> index 0000000..a1f2a6b
> --- /dev/null
> +++ b/Documentation/thermal/cpu-cooling-api.txt
> @@ -0,0 +1,52 @@
> +CPU cooling APIs How To
> +===================================
> +
> +Written by Amit Daniel Kachhap <amit.kachhap@linaro.org>
> +
> +Updated: 12 May 2012
> +
> +Copyright (c)  2012 Samsung Electronics Co., Ltd(http://www.samsung.com)
> +
> +0. Introduction
> +
> +The generic cpu cooling(freq clipping) provides registration/unregistration APIs
> +to the caller. The binding of the cooling devices to the trip point is left for
> +the user. The registration APIs returns the cooling device pointer.
> +
> +1. cpu cooling APIs
> +
> +1.1 cpufreq registration/unregistration APIs
> +1.1.1 struct thermal_cooling_device *cpufreq_cooling_register(
> +       struct cpumask *clip_cpus)
> +
> +    This interface function registers the cpufreq cooling device with the name
> +    "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
> +    cooling devices.
> +
> +   clip_cpus: cpumask of cpus where the frequency constraints will happen.
> +
> +1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
> +
> +    This interface function unregisters the "thermal-cpufreq-%x" cooling device.
> +
> +    cdev: Cooling device pointer which has to be unregistered.
> +
> +
> +1.2 CPU cooling action notifier register/unregister interface
> +1.2.1 int cputherm_register_notifier(struct notifier_block *nb,
> +       unsigned int list)
> +
> +    This interface registers a driver with cpu cooling layer. The driver will
> +    be notified when any cpu cooling action is called.
> +
> +    nb: notifier function to register
> +    list: CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP
> +
> +1.2.2 int cputherm_unregister_notifier(struct notifier_block *nb,
> +       unsigned int list)
> +
> +    This interface registers a driver with cpu cooling layer. The driver will
> +    be notified when any cpu cooling action is called.
> +
> +    nb: notifier function to register
> +    list: CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 7dd8c34..996003b 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -19,6 +19,17 @@ config THERMAL_HWMON
>         depends on HWMON=y || HWMON=THERMAL
>         default y
>
> +config CPU_THERMAL
> +       bool "generic cpu cooling support"
> +       depends on THERMAL && CPU_FREQ
> +       help
> +         This implements the generic cpu cooling mechanism through frequency
> +         reduction, cpu hotplug and any other ways of reducing temperature. An
> +         ACPI version of this already exists(drivers/acpi/processor_thermal.c).
> +         This will be useful for platforms using the generic thermal interface
> +         and not the ACPI interface.
> +         If you want this support, you should say Y here.
> +
>  config SPEAR_THERMAL
>         bool "SPEAr thermal sensor driver"
>         depends on THERMAL
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index fd9369a..aae59ad 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -3,5 +3,6 @@
>  #
>
>  obj-$(CONFIG_THERMAL)          += thermal_sys.o
> +obj-$(CONFIG_CPU_THERMAL)              += cpu_cooling.o
>  obj-$(CONFIG_SPEAR_THERMAL)            += spear_thermal.o
>  obj-$(CONFIG_RCAR_THERMAL)     += rcar_thermal.o
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> new file mode 100644
> index 0000000..c42e557
> --- /dev/null
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -0,0 +1,512 @@
> +/*
> + *  linux/drivers/thermal/cpu_cooling.c
> + *
> + *  Copyright (C) 2012 Samsung Electronics Co., Ltd(http://www.samsung.com)
> + *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/thermal.h>
> +#include <linux/platform_device.h>
> +#include <linux/cpufreq.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/cpu.h>
> +#include <linux/cpu_cooling.h>
> +
> +/**
> + * struct cpufreq_cooling_device
> + * @id: unique integer value corresponding to each cpufreq_cooling_device
> + *     registered.
> + * @cool_dev: thermal_cooling_device pointer to keep track of the the
> + *     egistered cooling device.
> + * @cpufreq_state: integer value representing the current state of cpufreq
> + *     cooling devices.
> + * @cpufreq_val: integer value representing the absolute value of the clipped
> + *     frequency.
> + * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
> + * @node: list_head to link all cpufreq_cooling_device together.
> + *
> + * This structure is required for keeping information of each
> + * cpufreq_cooling_device registered as a list whose head is represented by
> + * cooling_cpufreq_list. In order to prevent corruption of this list a
> + * mutex lock cooling_cpufreq_lock is used.
> + */
> +struct cpufreq_cooling_device {
> +       int id;
> +       struct thermal_cooling_device *cool_dev;
> +       unsigned int cpufreq_state;
> +       unsigned int cpufreq_val;
> +       struct cpumask allowed_cpus;
> +       struct list_head node;
> +};
> +static LIST_HEAD(cooling_cpufreq_list);
> +static DEFINE_IDR(cpufreq_idr);
> +
> +static struct mutex cooling_cpufreq_lock;
> +
> +/* notify_table passes value to the CPUFREQ_ADJUST callback function. */
> +#define NOTIFY_INVALID NULL
> +struct cpufreq_cooling_device *notify_device;
> +
> +/* Head of the blocking notifier chain to inform about frequency clamping */
> +static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
> +
> +/**
> + * get_idr - function to get a unique id.
> + * @idr: struct idr * handle used to create a id.
> + * @id: int * value generated by this function.
> + */
> +static int get_idr(struct idr *idr, int *id)
> +{
> +       int err;
> +again:
> +       if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
> +               return -ENOMEM;
> +
> +       mutex_lock(&cooling_cpufreq_lock);
> +       err = idr_get_new(idr, NULL, id);
> +       mutex_unlock(&cooling_cpufreq_lock);
> +
> +       if (unlikely(err == -EAGAIN))
> +               goto again;
> +       else if (unlikely(err))
> +               return err;
> +
> +       *id = *id & MAX_ID_MASK;
> +       return 0;
> +}
> +
> +/**
> + * release_idr - function to free the unique id.
> + * @idr: struct idr * handle used for creating the id.
> + * @id: int value representing the unique id.
> + */
> +static void release_idr(struct idr *idr, int id)
> +{
> +       mutex_lock(&cooling_cpufreq_lock);
> +       idr_remove(idr, id);
> +       mutex_unlock(&cooling_cpufreq_lock);
> +}
> +
> +/**
> + * cputherm_register_notifier - Register a notifier with cpu cooling interface.
> + * @nb:        struct notifier_block * with callback info.
> + * @list: integer value for which notification is needed. possible values are
> + *     CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
> + *
> + * This exported function registers a driver with cpu cooling layer. The driver
> + * will be notified when any cpu cooling action is called.
> + */
> +int cputherm_register_notifier(struct notifier_block *nb, unsigned int list)
> +{
> +       int ret = 0;
> +
> +       switch (list) {
> +       case CPUFREQ_COOLING_START:
> +       case CPUFREQ_COOLING_STOP:
> +               ret = blocking_notifier_chain_register(
> +                               &cputherm_state_notifier_list, nb);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +       return ret;
> +}
> +EXPORT_SYMBOL(cputherm_register_notifier);
> +
> +/**
> + * cputherm_unregister_notifier - Un-register a notifier.
> + * @nb:        struct notifier_block * with callback info.
> + * @list: integer value for which notification is needed. values possible are
> + *     CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP.
> + *
> + * This exported function un-registers a driver with cpu cooling layer.
> + */
> +int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list)
> +{
> +       int ret = 0;
> +
> +       switch (list) {
> +       case CPUFREQ_COOLING_START:
> +       case CPUFREQ_COOLING_STOP:
> +               ret = blocking_notifier_chain_unregister(
> +                               &cputherm_state_notifier_list, nb);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +       return ret;
> +}
> +EXPORT_SYMBOL(cputherm_unregister_notifier);
> +
> +/* Below code defines functions to be used for cpufreq as cooling device */
> +
> +/**
> + * is_cpufreq_valid - function to check if a cpu has frequency transition policy.
> + * @cpu: cpu for which check is needed.
> + */
> +static int is_cpufreq_valid(int cpu)
> +{
> +       struct cpufreq_policy policy;
> +       return !cpufreq_get_policy(&policy, cpu);
> +}
> +
> +/**
> + * get_cpu_frequency - get the absolute value of frequency from level.
> + * @cpu: cpu for which frequency is fetched.
> + * @level: level of frequency of the CPU
> + *     e.g level=1 --> 1st MAX FREQ, LEVEL=2 ---> 2nd MAX FREQ, .... etc
> + */
> +static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)


I like this. With previous implemention I had to write a similar
function, but with output of the required freq  clip table. Now that
you have the freq walk here it simplifies the zone setup code.


> +{
> +       int ret = 0, i = 0;
> +       unsigned long level_index;
> +       bool descend = false;
> +       struct cpufreq_frequency_table *table =
> +                                       cpufreq_frequency_get_table(cpu);
> +       if (!table)
> +               return ret;
> +
> +       while (table[i].frequency != CPUFREQ_TABLE_END) {
> +               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> +                       continue;
> +
> +               /*check if table in ascending or descending order*/
> +               if ((table[i + 1].frequency != CPUFREQ_TABLE_END) &&
> +                       (table[i + 1].frequency < table[i].frequency)
> +                       && !descend) {
> +                       descend = true;
> +               }
> +
> +               /*return if level matched and table in descending order*/
> +               if (descend && i == level)
> +                       return table[i].frequency;
> +               i++;
> +       }
> +       i--;
> +
> +       if (level > i || descend)
> +               return ret;
> +       level_index = i - level;
> +
> +       /*Scan the table in reverse order and match the level*/
> +       while (i >= 0) {
> +               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> +                       continue;
> +               /*return if level matched*/
> +               if (i == level_index)
> +                       return table[i].frequency;
> +               i--;
> +       }
> +       return ret;
> +}
> +
> +/**
> + * cpufreq_apply_cooling - function to apply frequency clipping.
> + * @cpufreq_device: cpufreq_cooling_device pointer containing frequency
> + *     clipping data.
> + * @cooling_state: value of the cooling state.
> + */
> +static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
> +                               unsigned long cooling_state)
> +{
> +       unsigned int event, cpuid, clip_freq;
> +       struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
> +       unsigned int cpu = cpumask_any(maskPtr);
> +
> +
> +       /* Check if the old cooling action is same as new cooling action */
> +       if (cpufreq_device->cpufreq_state == cooling_state)
> +               return 0;
> +
> +       clip_freq = get_cpu_frequency(cpu, cooling_state);
> +       if (!clip_freq)
> +               return -EINVAL;
> +
> +       cpufreq_device->cpufreq_state = cooling_state;
> +       cpufreq_device->cpufreq_val = clip_freq;
> +       notify_device = cpufreq_device;
> +
> +       if (cooling_state != 0)
> +               event = CPUFREQ_COOLING_START;
> +       else
> +               event = CPUFREQ_COOLING_STOP;
> +
> +       blocking_notifier_call_chain(&cputherm_state_notifier_list,
> +                                               event, &clip_freq);
> +
> +       for_each_cpu(cpuid, maskPtr) {
> +               if (is_cpufreq_valid(cpuid))
> +                       cpufreq_update_policy(cpuid);
> +       }
> +
> +       notify_device = NOTIFY_INVALID;
> +
> +       return 0;
> +}
> +
> +/**
> + * cpufreq_thermal_notifier - notifier callback for cpufreq policy change.
> + * @nb:        struct notifier_block * with callback info.
> + * @event: value showing cpufreq event for which this function invoked.
> + * @data: callback-specific data
> + */
> +static int cpufreq_thermal_notifier(struct notifier_block *nb,
> +                                       unsigned long event, void *data)
> +{
> +       struct cpufreq_policy *policy = data;
> +       unsigned long max_freq = 0;
> +
> +       if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
> +               return 0;
> +
> +       if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
> +               max_freq = notify_device->cpufreq_val;
> +
> +       /* Never exceed user_policy.max*/
> +       if (max_freq > policy->user_policy.max)
> +               max_freq = policy->user_policy.max;
> +
> +       if (policy->max != max_freq)
> +               cpufreq_verify_within_limits(policy, 0, max_freq);
> +
> +       return 0;
> +}
> +
> +/*
> + * cpufreq cooling device callback functions are defined below
> + */
> +
> +/**
> + * cpufreq_get_max_state - callback function to get the max cooling state.
> + * @cdev: thermal cooling device pointer.
> + * @state: fill this variable with the max cooling state.
> + */
> +static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
> +                                unsigned long *state)
> +{
> +       int ret = -EINVAL, i = 0;
> +       struct cpufreq_cooling_device *cpufreq_device;
> +       struct cpumask *maskPtr;
> +       unsigned int cpu;
> +       struct cpufreq_frequency_table *table;
> +
> +       mutex_lock(&cooling_cpufreq_lock);
> +       list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
> +               if (cpufreq_device && cpufreq_device->cool_dev == cdev)
> +                       break;
> +       }
> +       if (cpufreq_device == NULL)
> +               goto return_get_max_state;
> +
> +       maskPtr = &cpufreq_device->allowed_cpus;
> +       cpu = cpumask_any(maskPtr);
> +       table = cpufreq_frequency_get_table(cpu);
> +       if (!table) {
> +               *state = 0;
> +               ret = 0;
> +               goto return_get_max_state;
> +       }
> +
> +       while (table[i].frequency != CPUFREQ_TABLE_END) {
> +               if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> +                       continue;
> +               i++;
> +       }
> +       if (i > 0) {
> +               *state = --i;
> +               ret = 0;
> +       }
> +
> +return_get_max_state:
> +       mutex_unlock(&cooling_cpufreq_lock);
> +       return ret;
> +}
> +
> +/**
> + * cpufreq_get_cur_state - callback function to get the current cooling state.
> + * @cdev: thermal cooling device pointer.
> + * @state: fill this variable with the current cooling state.
> + */
> +static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
> +                                unsigned long *state)
> +{
> +       int ret = -EINVAL;
> +       struct cpufreq_cooling_device *cpufreq_device;
> +
> +       mutex_lock(&cooling_cpufreq_lock);
> +       list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
> +               if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
> +                       *state = cpufreq_device->cpufreq_state;
> +                       ret = 0;
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&cooling_cpufreq_lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * cpufreq_set_cur_state - callback function to set the current cooling state.
> + * @cdev: thermal cooling device pointer.
> + * @state: set this variable to the current cooling state.
> + */
> +static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
> +                                unsigned long state)
> +{
> +       int ret = -EINVAL;
> +       struct cpufreq_cooling_device *cpufreq_device;
> +
> +       mutex_lock(&cooling_cpufreq_lock);
> +       list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
> +               if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
> +                       ret = 0;
> +                       break;
> +               }
> +       }
> +       if (!ret)
> +               ret = cpufreq_apply_cooling(cpufreq_device, state);
> +
> +       mutex_unlock(&cooling_cpufreq_lock);
> +
> +       return ret;
> +}
> +
> +/* Bind cpufreq callbacks to thermal cooling device ops */
> +static struct thermal_cooling_device_ops const cpufreq_cooling_ops = {
> +       .get_max_state = cpufreq_get_max_state,
> +       .get_cur_state = cpufreq_get_cur_state,
> +       .set_cur_state = cpufreq_set_cur_state,
> +};
> +
> +/* Notifier for cpufreq policy change */
> +static struct notifier_block thermal_cpufreq_notifier_block = {
> +       .notifier_call = cpufreq_thermal_notifier,
> +};
> +
> +/**
> + * cpufreq_cooling_register - function to create cpufreq cooling device.
> + * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
> + */
> +struct thermal_cooling_device *cpufreq_cooling_register(
> +       struct cpumask *clip_cpus)
> +{
> +       struct thermal_cooling_device *cool_dev;
> +       struct cpufreq_cooling_device *cpufreq_dev = NULL;
> +       unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
> +       char dev_name[THERMAL_NAME_LENGTH];
> +       int ret = 0, id = 0, i;
> +       struct cpufreq_policy policy;
> +
> +       list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
> +               cpufreq_dev_count++;
> +
> +       /*Verify that all the clip cpus have same freq_min, freq_max limit*/
> +       for_each_cpu(i, clip_cpus) {
> +               /*continue if cpufreq policy not found and not return error*/
> +               if (!cpufreq_get_policy(&policy, i))
> +                       continue;
> +               if (min == 0 && max == 0) {
> +                       min = policy.cpuinfo.min_freq;
> +                       max = policy.cpuinfo.max_freq;
> +               } else {
> +                       if (min != policy.cpuinfo.min_freq ||
> +                               max != policy.cpuinfo.max_freq)
> +                               return ERR_PTR(-EINVAL);
> +}
> +       }
> +       cpufreq_dev = kzalloc(sizeof(struct cpufreq_cooling_device),
> +                       GFP_KERNEL);
> +       if (!cpufreq_dev)
> +               return ERR_PTR(-ENOMEM);
> +
> +       cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
> +
> +       if (cpufreq_dev_count == 0)
> +               mutex_init(&cooling_cpufreq_lock);
> +
> +       ret = get_idr(&cpufreq_idr, &cpufreq_dev->id);
> +       if (ret) {
> +               kfree(cpufreq_dev);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
> +
> +       cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
> +                                               &cpufreq_cooling_ops);
> +       if (!cool_dev) {
> +               release_idr(&cpufreq_idr, cpufreq_dev->id);
> +               kfree(cpufreq_dev);
> +               return ERR_PTR(-EINVAL);
> +       }
> +       cpufreq_dev->id = id;
> +       cpufreq_dev->cool_dev = cool_dev;
> +       cpufreq_dev->cpufreq_state = 0;
> +       mutex_lock(&cooling_cpufreq_lock);
> +       list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
> +
> +       /* Register the notifier for first cpufreq cooling device */
> +       if (cpufreq_dev_count == 0)
> +               cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
> +                                               CPUFREQ_POLICY_NOTIFIER);
> +
> +       mutex_unlock(&cooling_cpufreq_lock);
> +       return cool_dev;
> +}
> +EXPORT_SYMBOL(cpufreq_cooling_register);
> +
> +/**
> + * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
> + * @cdev: thermal cooling device pointer.
> + */
> +void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
> +{
> +       struct cpufreq_cooling_device *cpufreq_dev = NULL;
> +       unsigned int cpufreq_dev_count = 0;
> +
> +       mutex_lock(&cooling_cpufreq_lock);
> +       list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
> +               if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
> +                       break;
> +               cpufreq_dev_count++;
> +       }
> +
> +       if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
> +               mutex_unlock(&cooling_cpufreq_lock);
> +               return;
> +       }
> +
> +       list_del(&cpufreq_dev->node);
> +
> +       /* Unregister the notifier for the last cpufreq cooling device */
> +       if (cpufreq_dev_count == 1) {
> +               cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
> +                                       CPUFREQ_POLICY_NOTIFIER);
> +       }
> +       mutex_unlock(&cooling_cpufreq_lock);
> +       thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
> +       release_idr(&cpufreq_idr, cpufreq_dev->id);
> +       if (cpufreq_dev_count == 1)
> +               mutex_destroy(&cooling_cpufreq_lock);
> +       kfree(cpufreq_dev);
> +}
> +EXPORT_SYMBOL(cpufreq_cooling_unregister);
> diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> new file mode 100644
> index 0000000..555b917
> --- /dev/null
> +++ b/include/linux/cpu_cooling.h
> @@ -0,0 +1,79 @@
> +/*
> + *  linux/include/linux/cpu_cooling.h
> + *
> + *  Copyright (C) 2012 Samsung Electronics Co., Ltd(http://www.samsung.com)
> + *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#ifndef __CPU_COOLING_H__
> +#define __CPU_COOLING_H__
> +
> +#include <linux/thermal.h>
> +
> +#define CPUFREQ_COOLING_START          0
> +#define CPUFREQ_COOLING_STOP           1
> +
> +/**
> + * cputherm_register_notifier - Register a notifier with cpu cooling interface.
> + * @nb:        struct notifier_block * with callback info.
> + * @list: integer value for which notification is needed. possible values are
> + *     CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
> + *
> + * This exported function registers a driver with cpu cooling layer. The driver
> + * will be notified when any cpu cooling action is called.
> + */
> +int cputherm_register_notifier(struct notifier_block *nb, unsigned int list);
> +
> +/**
> + * cputherm_unregister_notifier - Un-register a notifier.
> + * @nb:        struct notifier_block * with callback info.
> + * @list: integer value for which notification is needed. values possible are
> + *     CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
> + *
> + * This exported function un-registers a driver with cpu cooling layer.
> + */
> +int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list);
> +
> +#ifdef CONFIG_CPU_THERMAL
> +/**
> + * cpufreq_cooling_register - function to create cpufreq cooling device.
> + * @clip_cpus: cpumask of cpus where the frequency constraints will happen
> + */
> +struct thermal_cooling_device *cpufreq_cooling_register(
> +               struct cpumask *clip_cpus);
> +
> +/**
> + * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
> + * @cdev: thermal cooling device pointer.
> + */
> +void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
> +#else /* !CONFIG_CPU_THERMAL */
> +static inline struct thermal_cooling_device *cpufreq_cooling_register(
> +       struct cpumask *clip_cpus)
> +{
> +       return NULL;
> +}
> +static inline void cpufreq_cooling_unregister(
> +               struct thermal_cooling_device *cdev)
> +{
> +       return;
> +}
> +#endif /* CONFIG_CPU_THERMAL */
> +
> +#endif /* __CPU_COOLING_H__ */
> --
> 1.7.1
>



-- 

Eduardo Valentin
