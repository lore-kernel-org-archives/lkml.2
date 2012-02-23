Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2BWFgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:36:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49717 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2BWFgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:36:16 -0500
Message-ID: <4F45D035.5000906@linux.vnet.ibm.com>
Date: Thu, 23 Feb 2012 11:05:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH 5/7] PM / Sleep: Implement opportunistic sleep
References: <201202070200.55505.rjw@sisk.pl> <201202220035.48033.rjw@sisk.pl> <4F44AB34.9030704@linux.vnet.ibm.com> <201202222310.47278.rjw@sisk.pl>
In-Reply-To: <201202222310.47278.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022220-3568-0000-0000-0000014195CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 03:40 AM, Rafael J. Wysocki wrote:

> On Wednesday, February 22, 2012, Srivatsa S. Bhat wrote:
>> On 02/22/2012 05:05 AM, Rafael J. Wysocki wrote:
>>
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> Introduce a mechanism by which the kernel can trigger global
>>> transitions to a sleep state chosen by user space if there are no
>>> active wakeup sources.
>>>
>>> It consists of a new sysfs attribute, /sys/power/autosleep, that
>>> can be written one of the strings returned by reads from
>>> /sys/power/state, an ordered workqueue and a work item carrying out
>>> the "suspend" operations.  If a string representing the system's
>>> sleep state is written to /sys/power/autosleep, the work item
>>> triggering transitions to that state is queued up and it requeues
>>> itself after every execution until user space writes "off" to
>>> /sys/power/autosleep.
>>>
>>> That work item enables the detection of wakeup events using the
>>> functions already defined in drivers/base/power/wakeup.c (with one
>>> small modification) and calls either pm_suspend(), or hibernate() to
>>> put the system into a sleep state.  If a wakeup event is reported
>>> while the transition is in progress, it will abort the transition and
>>> the "system suspend" work item will be queued up again.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> ---
>>>  Documentation/ABI/testing/sysfs-power |   17 +++++
>>>  drivers/base/power/wakeup.c           |   38 ++++++-----
>>>  include/linux/suspend.h               |   13 +++-
>>>  kernel/power/Kconfig                  |    8 ++
>>>  kernel/power/Makefile                 |    1 
>>>  kernel/power/autosleep.c              |   98 ++++++++++++++++++++++++++++++
>>>  kernel/power/main.c                   |  108 ++++++++++++++++++++++++++++------
>>>  kernel/power/power.h                  |   18 +++++
>>>  8 files changed, 266 insertions(+), 35 deletions(-)
>>>
>>> Index: linux/kernel/power/Makefile
>>> ===================================================================
>>> --- linux.orig/kernel/power/Makefile
>>> +++ linux/kernel/power/Makefile
>>> @@ -9,5 +9,6 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
>>>  obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
>>>  obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
>>>  				   block_io.o
>>> +obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
>>>
>>>  obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
>>> Index: linux/kernel/power/Kconfig
>>> ===================================================================
>>> --- linux.orig/kernel/power/Kconfig
>>> +++ linux/kernel/power/Kconfig
>>> @@ -103,6 +103,14 @@ config PM_SLEEP_SMP
>>>  	select HOTPLUG
>>>  	select HOTPLUG_CPU
>>>
>>> +config PM_AUTOSLEEP
>>> +	bool "Opportunistic sleep"
>>> +	depends on PM_SLEEP
>>> +	default n
>>> +	---help---
>>> +	Allow the kernel to trigger a system transition into a global sleep
>>> +	state automatically whenever there are no active wakeup sources.
>>> +
>>>  config PM_RUNTIME
>>>  	bool "Run-time PM core functionality"
>>>  	depends on !IA64_HP_SIM
>>> Index: linux/kernel/power/power.h
>>> ===================================================================
>>> --- linux.orig/kernel/power/power.h
>>> +++ linux/kernel/power/power.h
>>> @@ -264,3 +264,21 @@ static inline void suspend_thaw_processe
>>>  {
>>>  }
>>>  #endif
>>> +
>>> +#ifdef CONFIG_PM_AUTOSLEEP
>>> +
>>> +/* kernel/power/autosleep.c */
>>> +extern int pm_autosleep_init(void);
>>> +extern void pm_autosleep_lock(void);
>>> +extern void pm_autosleep_unlock(void);
>>> +extern suspend_state_t pm_autosleep_state(void);
>>> +extern int pm_autosleep_set_state(suspend_state_t state);
>>> +
>>> +#else /* !CONFIG_PM_AUTOSLEEP */
>>> +
>>> +static inline int pm_autosleep_init(void) { return 0; }
>>> +static inline void pm_autosleep_lock(void) {}
>>> +static inline void pm_autosleep_unlock(void) {}
>>> +static inline suspend_state_t pm_autosleep_state(void) { return PM_SUSPEND_ON; }
>>> +
>>> +#endif /* !CONFIG_PM_AUTOSLEEP */
>>> Index: linux/include/linux/suspend.h
>>> ===================================================================
>>> --- linux.orig/include/linux/suspend.h
>>> +++ linux/include/linux/suspend.h
>>> @@ -356,7 +356,7 @@ extern int unregister_pm_notifier(struct
>>>  extern bool events_check_enabled;
>>>
>>>  extern bool pm_wakeup_pending(void);
>>> -extern bool pm_get_wakeup_count(unsigned int *count);
>>> +extern bool pm_get_wakeup_count(unsigned int *count, bool block);
>>>  extern bool pm_save_wakeup_count(unsigned int count);
>>>
>>>  static inline void lock_system_sleep(void)
>>> @@ -407,6 +407,17 @@ static inline void unlock_system_sleep(v
>>>
>>>  #endif /* !CONFIG_PM_SLEEP */
>>>
>>> +#ifdef CONFIG_PM_AUTOSLEEP
>>> +
>>> +/* kernel/power/autosleep.c */
>>> +void queue_up_suspend_work(void);
>>> +
>>> +#else /* !CONFIG_PM_AUTOSLEEP */
>>> +
>>> +static inline void queue_up_suspend_work(void) {}
>>> +
>>> +#endif /* !CONFIG_PM_AUTOSLEEP */
>>> +
>>>  #ifdef CONFIG_ARCH_SAVE_PAGE_KEYS
>>>  /*
>>>   * The ARCH_SAVE_PAGE_KEYS functions can be used by an architecture
>>> Index: linux/kernel/power/autosleep.c
>>> ===================================================================
>>> --- /dev/null
>>> +++ linux/kernel/power/autosleep.c
>>> @@ -0,0 +1,98 @@
>>> +/*
>>> + * kernel/power/autosleep.c
>>> + *
>>> + * Opportunistic sleep support.
>>> + *
>>> + * Copyright (C) 2012 Rafael J. Wysocki <rjw@sisk.pl>
>>> + */
>>> +
>>> +#include <linux/device.h>
>>> +#include <linux/mutex.h>
>>> +#include <linux/pm_wakeup.h>
>>> +
>>> +#include "power.h"
>>> +
>>> +static suspend_state_t autosleep_state;
>>> +static struct workqueue_struct *autosleep_wq;
>>> +static DEFINE_MUTEX(autosleep_lock);
>>> +
>>> +static void try_to_suspend(struct work_struct *work)
>>> +{
>>> +	unsigned int initial_count, final_count;
>>> +
>>> +	if (!pm_get_wakeup_count(&initial_count, true))
>>> +		goto out;
>>> +
>>> +	mutex_lock(&autosleep_lock);
>>> +
>>> +	if (!pm_save_wakeup_count(initial_count)) {
>>> +		mutex_unlock(&autosleep_lock);
>>> +		goto out;
>>> +	}
>>> +
>>> +	if (autosleep_state == PM_SUSPEND_ON) {
>>> +		mutex_unlock(&autosleep_lock);
>>> +		return;
>>> +	}
>>> +	if (autosleep_state >= PM_SUSPEND_MAX)
>>> +		hibernate();
>>> +	else
>>> +		pm_suspend(autosleep_state);
>>
>>
>> We are calling pm_suspend() or hibernate() directly here.
>> Won't this break build when CONFIG_SUSPEND or CONFIG_HIBERNATION is not set?
>> CONFIG_PM_AUTOSLEEP depends only on PM_SLEEP which means we could enable
>> either one of suspend or hibernation and yet come to this point, breaking
>> the option which was not enabled.
> 
> Both pm_suspend() and hibernate() have appropriate static inline definitions
> for !CONFIG_SUSPEND and !CONFIG_HIBERNATION (in suspend.h), as far as I can say.
> 


Oh, you are right.. I overlooked that, sorry!
 
Regards,
Srivatsa S. Bhat

