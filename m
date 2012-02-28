Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab2B1KYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:24:18 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45194 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2B1KYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:24:16 -0500
Message-ID: <4F4CAB45.4000903@linux.vnet.ibm.com>
Date: Tue, 28 Feb 2012 15:54:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: John Stultz <john.stultz@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH 0/7] PM: Implement autosleep and "wake locks", take2
References: <201202070200.55505.rjw@sisk.pl> <201202250021.36738.rjw@sisk.pl> <4F493486.9020202@linux.vnet.ibm.com> <201202252201.13537.rjw@sisk.pl>
In-Reply-To: <201202252201.13537.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022810-5564-0000-0000-00000190D357
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2012 02:31 AM, Rafael J. Wysocki wrote:

> 
> I think we can do something like in the updated patch [5/7] below.
> 
> It uses a special wakeup source object called "autosleep" to bump up the
> number of wakeup events in progress before acquiring autosleep_lock in
> pm_autosleep_set_state().  This way, either pm_autosleep_set_state() will
> acquire autosleep_lock before try_to_suspend(), in which case the latter
> will see the change of autosleep_state immediately (after autosleep_lock has
> been passed to it), or try_to_suspend() will get it first, but then
> pm_save_wakeup_count() or pm_suspend()/hibernate() will see the nonzero counter
> of wakeup events in progress and return error code (sooner or later).
> 
> The drawback is that writes to /sys/power/autosleep may interfere with
> the /sys/power/wakeup_count + /sys/power/state interface by interrupting
> transitions started by writing to /sys/power/state, for example (although
> I think that's highly unlikely).


Yes, but I think we can live with that.. It doesn't look like a big issue.

> 
> Additionally, I made pm_autosleep_lock() use mutex_trylock_interruptible()


You have used mutex_lock_interruptible() in the code below.. It wouldn't matter
as long as you have used some form of "interruptible" but I think
mutex_trylock_interruptible would be even better..

> to prevent operations on /sys/power/wakeup_count and/or /sys/power/state
> from failing the freezing of tasks started by try_to_suspend().
> 
> Thanks,
> Rafael
> 


The approach taken by the patch below looks good to me. I don't see any obvious
problems, except for the minor ones listed below.

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Implement opportunistic sleep
> 
> Introduce a mechanism by which the kernel can trigger global
> transitions to a sleep state chosen by user space if there are no
> active wakeup sources.
> 
> It consists of a new sysfs attribute, /sys/power/autosleep, that
> can be written one of the strings returned by reads from
> /sys/power/state, an ordered workqueue and a work item carrying out
> the "suspend" operations.  If a string representing the system's
> sleep state is written to /sys/power/autosleep, the work item
> triggering transitions to that state is queued up and it requeues
> itself after every execution until user space writes "off" to
> /sys/power/autosleep.
> 
> That work item enables the detection of wakeup events using the
> functions already defined in drivers/base/power/wakeup.c (with one
> small modification) and calls either pm_suspend(), or hibernate() to
> put the system into a sleep state.  If a wakeup event is reported
> while the transition is in progress, it will abort the transition and
> the "system suspend" work item will be queued up again.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Index: linux/kernel/power/main.c
> ===================================================================
> --- linux.orig/kernel/power/main.c
> +++ linux/kernel/power/main.c
> @@ -269,8 +269,7 @@ static ssize_t state_show(struct kobject
>  	return (s - buf);
>  }
> 
> -static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
> -			   const char *buf, size_t n)
> +static suspend_state_t decode_state(const char *buf, size_t n)
>  {
>  #ifdef CONFIG_SUSPEND
>  	suspend_state_t state = PM_SUSPEND_STANDBY;
> @@ -278,27 +277,48 @@ static ssize_t state_store(struct kobjec
>  #endif
>  	char *p;
>  	int len;
> -	int error = -EINVAL;
> 
>  	p = memchr(buf, '\n', n);
>  	len = p ? p - buf : n;
> 
> -	/* First, check if we are requested to hibernate */
> -	if (len == 4 && !strncmp(buf, "disk", len)) {
> -		error = hibernate();
> -		goto Exit;
> -	}
> +	/* Check hibernation first. */
> +	if (len == 4 && !strncmp(buf, "disk", len))
> +		return PM_SUSPEND_MAX;
> 
>  #ifdef CONFIG_SUSPEND
> -	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
> -		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
> -			error = pm_suspend(state);
> -			break;
> -		}
> -	}
> +	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
> +		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
> +			return state;
>  #endif
> 
> - Exit:
> +	return PM_SUSPEND_ON;
> +}
> +
> +static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			   const char *buf, size_t n)
> +{
> +	suspend_state_t state;
> +	int error;
> +
> +	error = pm_autosleep_lock();
> +	if (error)
> +		return error;
> +
> +	if (pm_autosleep_state() > PM_SUSPEND_ON) {
> +		error = -EBUSY;
> +		goto out;
> +	}
> +
> +	state = decode_state(buf, n);
> +	if (state < PM_SUSPEND_MAX)
> +		error = pm_suspend(state);
> +	else if (state > PM_SUSPEND_ON)
> +		error = hibernate();
> +	else
> +		error = -EINVAL;


By the way, the condition checks in the above if-else block look kinda
odd, considering what is done in other similar places, which are more
readable. It would be great if you could make them consistent.

> +
> + out:
> +	pm_autosleep_unlock();
>  	return error ? error : n;
>  }
> 
> @@ -339,7 +359,8 @@ static ssize_t wakeup_count_show(struct
>  {
>  	unsigned int val;
> 
> -	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
> +	return pm_get_wakeup_count(&val, true) ?
> +		sprintf(buf, "%u\n", val) : -EINTR;
>  }
> 
> +
> +static ssize_t autosleep_store(struct kobject *kobj,
> +			       struct kobj_attribute *attr,
> +			       const char *buf, size_t n)
> +{
> +	suspend_state_t state = decode_state(buf, n);
> +	int error;
> +
> +	if (state == PM_SUSPEND_ON && strncmp(buf, "off", 3)
> +	    && strncmp(buf, "off\n", 4))
> +		return -EINVAL;
> +


I am pretty sure you meant "if autosleep is already off, and the user
wrote "off" to /sys/power/autosleep, then return -EINVAL"

But strncmp() returns 0 if the strings match, and hence the code above
doesn't seem to do what you intended.

> +	error = pm_autosleep_set_state(state);
> +	return error ? error : n;
> +}
> +
> +power_attr(autosleep);
> +#endif /* CONFIG_PM_AUTOSLEEP */
>  #endif /* CONFIG_PM_SLEEP */
> 
>  #ifdef CONFIG_PM_TRACE


Regards,
Srivatsa S. Bhat

