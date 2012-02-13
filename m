Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab2BMFWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:22:24 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:58512 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2BMFWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:22:23 -0500
Message-ID: <4F389DE0.6020904@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 10:51:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/3] PM / Sleep: Make enter_state() in kernel/power/suspend.c
 static
References: <201202120003.20879.rjw@sisk.pl> <201202120004.48991.rjw@sisk.pl> <4F37D1AF.5070700@linux.vnet.ibm.com> <201202122224.14640.rjw@sisk.pl>
In-Reply-To: <201202122224.14640.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021305-3864-0000-0000-0000015CC3FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 02:54 AM, Rafael J. Wysocki wrote:

> On Sunday, February 12, 2012, Srivatsa S. Bhat wrote:
>> On 02/12/2012 04:34 AM, Rafael J. Wysocki wrote:
>>
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> The enter_state() function in kernel/power/suspend.c should be
>>> static and state_store() in kernel/power/suspend.c should call
>>> pm_suspend() instead of it, so make that happen (which also reduces
>>> code duplication related to suspend statistics).
>>>
>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> ---
>>>  kernel/power/main.c    |    6 +-----
>>>  kernel/power/power.h   |    2 --
>>>  kernel/power/suspend.c |    2 +-
>>>  3 files changed, 2 insertions(+), 8 deletions(-)
>>>
>>> Index: linux/kernel/power/main.c
>>> ===================================================================
>>> --- linux.orig/kernel/power/main.c
>>> +++ linux/kernel/power/main.c
>>> @@ -292,11 +292,7 @@ static ssize_t state_store(struct kobjec
>>>  #ifdef CONFIG_SUSPEND
>>>  	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
>>>  		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
>>> -			break;
>>> -	}
>>> -	if (state < PM_SUSPEND_MAX && *s) {
>>> -		error = enter_state(state);
>>> -		suspend_stats_update(error);
>>> +			error = pm_suspend(state);
>>
>>
>> This code will not stop after calling pm_suspend(). It will try more iterations
>> in the for loop right?
> 
> Well, only one string in pm_states[] can be matched at a time, but I agree that
> it doesn't make sense to continue the loop after we've found a match.
> 
>> We can probably keep the 'for' loop as it is, and just replace the 'if' block
>> following the 'for' loop by: error = pm_suspend(state);
> 
> I think the patch below is correct.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Make enter_state() in kernel/power/suspend.c static
> 
> The enter_state() function in kernel/power/suspend.c should be
> static and state_store() in kernel/power/suspend.c should call
> pm_suspend() instead of it, so make that happen (which also reduces
> code duplication related to suspend statistics).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---


Yeah, this version of the patch will work fine.

Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  kernel/power/main.c    |    8 +++-----
>  kernel/power/power.h   |    2 --
>  kernel/power/suspend.c |    2 +-
>  3 files changed, 4 insertions(+), 8 deletions(-)
> 
> Index: linux/kernel/power/main.c
> ===================================================================
> --- linux.orig/kernel/power/main.c
> +++ linux/kernel/power/main.c
> @@ -291,12 +291,10 @@ static ssize_t state_store(struct kobjec
> 
>  #ifdef CONFIG_SUSPEND
>  	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
> -		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
> +		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
> +			error = pm_suspend(state);
>  			break;
> -	}
> -	if (state < PM_SUSPEND_MAX && *s) {
> -		error = enter_state(state);
> -		suspend_stats_update(error);
> +		}
>  	}
>  #endif
> 
> Index: linux/kernel/power/power.h
> ===================================================================
> --- linux.orig/kernel/power/power.h
> +++ linux/kernel/power/power.h
> @@ -177,13 +177,11 @@ extern const char *const pm_states[];
> 
>  extern bool valid_state(suspend_state_t state);
>  extern int suspend_devices_and_enter(suspend_state_t state);
> -extern int enter_state(suspend_state_t state);
>  #else /* !CONFIG_SUSPEND */
>  static inline int suspend_devices_and_enter(suspend_state_t state)
>  {
>  	return -ENOSYS;
>  }
> -static inline int enter_state(suspend_state_t state) { return -ENOSYS; }
>  static inline bool valid_state(suspend_state_t state) { return false; }
>  #endif /* !CONFIG_SUSPEND */
> 
> Index: linux/kernel/power/suspend.c
> ===================================================================
> --- linux.orig/kernel/power/suspend.c
> +++ linux/kernel/power/suspend.c
> @@ -272,7 +272,7 @@ static void suspend_finish(void)
>   * Fail if that's not the case.  Otherwise, prepare for system suspend, make the
>   * system enter the given sleep state and clean up after wakeup.
>   */
> -int enter_state(suspend_state_t state)
> +static int enter_state(suspend_state_t state)
>  {
>  	int error;
> 
> 

