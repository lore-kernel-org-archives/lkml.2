Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2FRFqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:46:18 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55978 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2FRFqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:46:16 -0400
Message-ID: <4FDEC06A.2080407@linux.vnet.ibm.com>
Date: Mon, 18 Jun 2012 11:15:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <gregkh@linuxfoundation.org>, Sameer Nanda <snanda@chromium.org>,
        rob@landley.net, len.brown@intel.com, pavel@ucw.cz,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] (was: Re: [PATCH v2] power: add knob for printing device
 resume times)
References: <20120522202453.GA30723@kroah.com> <20120615140924.GA30392@kroah.com> <201206161557.37591.rjw@sisk.pl> <201206162236.21611.rjw@sisk.pl>
In-Reply-To: <201206162236.21611.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12061719-0260-0000-0000-0000015B53DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2012 02:06 AM, Rafael J. Wysocki wrote:

> On Saturday, June 16, 2012, Rafael J. Wysocki wrote:
>> On Friday, June 15, 2012, Greg KH wrote:
>>> On Fri, Jun 15, 2012 at 12:00:20PM +0200, Rafael J. Wysocki wrote:
>>>> On Friday, June 15, 2012, Greg KH wrote:
>>>>> On Wed, May 23, 2012 at 09:45:32AM -0700, Sameer Nanda wrote:
>>>>>> Added a new knob called /sys/power/pm_print_times. Setting it to 1
>>>>>> enables printing of time taken by devices to suspend and resume.
>>>>>> Setting it to 0 disables this printing (unless overridden by
>>>>>> initcall_debug kernel command line option).
>>>>>>
>>>>>> Signed-off-by: Sameer Nanda <snanda@chromium.org>
>>>>>> cc: Greg KH <gregkh@linuxfoundation.org>
>>>>>> cc: Rafael J. Wysocki <rjw@sisk.pl>
>>>>>> cc: Steven Rostedt <rostedt@goodmis.org>
>>>>>> ---
>>>>>>  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
>>>>>>  drivers/base/power/main.c             |    4 +-
>>>>>>  drivers/base/power/power.h            |   11 ++++++++++
>>>>>>  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
>>>>>>  4 files changed, 60 insertions(+), 2 deletions(-)
>>>>>
>>>>> This patch fails against the linux-next tree, care to fix it up so that
>>>>> I can apply it?
>>>>
>>>> I'd prefer it to go through my tree if you don't mind.
>>>
>>> Not at all, feel free to put:
>>>
>>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> When it shows up again.
>>
>> I've just used the original one, it only needed a documentation merge conflict
>> fixed.
>>
>> Queued up for 3.6.
> 
> I propose the following patch on top of this one.  The details are in the
> changelog.
> 
> If anyone has any objections, please let me know.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Separate printing suspend times from initcall_debug
> 
> Change the behavior of the newly introduced
> /sys/power/pm_print_times attribute so that its initial value
> depends on initcall_debug, but setting it to 0 will cause device
> suspend/resume times not to be printed, even if initcall_debug has
> been set.  This way, the people who use initcall_debug for reasons
> other than PM debugging will be able to switch the suspend/resume
> times printing off, if need be.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/base/power/main.c  |    4 ++--
>  drivers/base/power/power.h |   11 -----------
>  include/linux/suspend.h    |    4 ++++
>  kernel/power/main.c        |   14 +++++++++++---
>  4 files changed, 17 insertions(+), 16 deletions(-)
> 
> Index: linux/kernel/power/main.c
> ===================================================================
> --- linux.orig/kernel/power/main.c
> +++ linux/kernel/power/main.c
> @@ -139,7 +139,7 @@ power_attr(pm_test);
>   * show() returns whether printing of suspend and resume times is enabled.
>   * store() accepts 0 or 1.  0 disables printing and 1 enables it.
>   */
> -int pm_print_times_enabled;
> +bool pm_print_times_enabled;
> 
>  static ssize_t pm_print_times_show(struct kobject *kobj,
>  				   struct kobj_attribute *attr, char *buf)
> @@ -159,12 +159,19 @@ static ssize_t pm_print_times_store(stru
>  	if (val > 1)
>  		return -EINVAL;
> 
> -	pm_print_times_enabled = val;
> +	pm_print_times_enabled = !!val;
>  	return n;
>  }
> 
> +static inline void pm_print_times_init(void)
> +{
> +	pm_print_times_enabled = !!initcall_debug;
> +}
> +
>  power_attr(pm_print_times);
> -#endif /* CONFIG_PM_DEBUG */
> +#else /* !CONFIG_PM_DEBUG */
> +static inline void pm_print_times_init(void) {}
> +#endif /* !CONFIG_PM_DEBUG */
> 
>  #ifdef CONFIG_DEBUG_FS
>  static char *suspend_step_name(enum suspend_stat_step step)
> @@ -599,6 +606,7 @@ static int __init pm_init(void)
>  	error = sysfs_create_group(power_kobj, &attr_group);
>  	if (error)
>  		return error;
> +	pm_print_times_init();
>  	return pm_autosleep_init();
>  }
> 
> Index: linux/include/linux/suspend.h
> ===================================================================
> --- linux.orig/include/linux/suspend.h
> +++ linux/include/linux/suspend.h
> @@ -387,6 +387,8 @@ static inline void unlock_system_sleep(v
>  	mutex_unlock(&pm_mutex);
>  }
> 
> +extern bool pm_print_times_enabled;
> +
>  #else /* !CONFIG_PM_SLEEP */
> 
>  static inline int register_pm_notifier(struct notifier_block *nb)
> @@ -406,6 +408,8 @@ static inline bool pm_wakeup_pending(voi
>  static inline void lock_system_sleep(void) {}
>  static inline void unlock_system_sleep(void) {}
> 
> +#define pm_print_times_enabled	(false)
> +
>  #endif /* !CONFIG_PM_SLEEP */
> 
>  #ifdef CONFIG_PM_AUTOSLEEP
> Index: linux/drivers/base/power/main.c
> ===================================================================
> --- linux.orig/drivers/base/power/main.c
> +++ linux/drivers/base/power/main.c
> @@ -166,7 +166,7 @@ static ktime_t initcall_debug_start(stru
>  {
>  	ktime_t calltime = ktime_set(0, 0);
> 
> -	if (pm_print_times) {
> +	if (pm_print_times_enabled) {
>  		pr_info("calling  %s+ @ %i, parent: %s\n",
>  			dev_name(dev), task_pid_nr(current),
>  			dev->parent ? dev_name(dev->parent) : "none");
> @@ -181,7 +181,7 @@ static void initcall_debug_report(struct
>  {
>  	ktime_t delta, rettime;
> 
> -	if (pm_print_times) {
> +	if (pm_print_times_enabled) {
>  		rettime = ktime_get();
>  		delta = ktime_sub(rettime, calltime);
>  		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
> Index: linux/drivers/base/power/power.h
> ===================================================================
> --- linux.orig/drivers/base/power/power.h
> +++ linux/drivers/base/power/power.h
> @@ -85,14 +85,3 @@ static inline int pm_qos_sysfs_add(struc
>  static inline void pm_qos_sysfs_remove(struct device *dev) {}
> 
>  #endif
> -
> -#ifdef CONFIG_PM_DEBUG
> -
> -extern int pm_print_times_enabled;
> -#define pm_print_times (initcall_debug || pm_print_times_enabled)
> -
> -#else /* CONFIG_PM_DEBUG */
> -
> -#define pm_print_times initcall_debug
> -
> -#endif /* CONFIG_PM_DEBUG */


