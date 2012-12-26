Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2LZTcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 14:32:18 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49036 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2LZTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 14:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=W+tO_3MfGYv_kc3XLw4VWHUXB2NUC+Etj9gW+1vSgvHQ@mail.gmail.com>
References: <1355819384-25983-1-git-send-email-sonnyrao@chromium.org>
	<CADGdYn6P8T9AKBpHV+uz6avh0+8uWQ+qnKyCjYsYdHQRpPriRg@mail.gmail.com>
	<CAD=FV=W+tO_3MfGYv_kc3XLw4VWHUXB2NUC+Etj9gW+1vSgvHQ@mail.gmail.com>
Date: Wed, 26 Dec 2012 11:32:16 -0800
X-Google-Sender-Auth: oe9i2eyMAwUAvFdrCLl1jGOMAyg
Message-ID: <CADGdYn7m-rE_jJG_qV7hS_Lh=3Z+hx+9BjmqPpRrxt_BeMA5tA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] cpufreq: can't raise max frequency with cpu_thermal
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:45 PM, Doug Anderson <dianders@chromium.org> wrote:
> Amit,
>
> On Tue, Dec 18, 2012 at 8:17 PM, amit daniel kachhap
> <amit.daniel@samsung.com> wrote:
>> On Tue, Dec 18, 2012 at 12:29 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
>>> The cpu_thermal generic thermal management code has a bug where once
>>> max cpu frequency has been lowered in sysfs (scaling_max_freq) it is
>>> not possible to raise the max back up later.  The bug is that the
>>> notifer gets called by __cpufreq_set_policy() before the user policy
>>> max is raised, and is incorrectly trying to enforce the max frequency
>>> policy even when we are trying to change the policy.  It is also not
>>> clear why this driver is looking at the user policy since it is
>>> primarily supposed to enforce thermal policy, not user set policy.
>>
>> Hi Sunny,
>>
>> I am not sure if this change is needed.
>
> Do you have a machine that's running with your code?  Can you go into
> sysfs (/sys/devices/system/cpu/cpu0/cpufreq/) and try lowering then
> raising the max frequency by doing something like this (assumes that
> you can scale down to 200MHz):
>
>   cd /sys/devices/system/cpu/cpu0/cpufreq/
>   OLD_VAL=$(cat scaling_max_freq)
>   cat scaling_min_freq > scaling_max_freq
>   echo ${OLD_VAL} > scaling_max_freq
>
>   echo "$(cat scaling_max_freq) should be ${OLD_VAL}.  Is it?"
>
> ...when I run the above without Sonny's patch on my system I see:
>   200000 should be 1700000. Is it?
>
> ...after Sonny's patch then the above works.
Hi Doug,

I tested the above steps on exynos origen board with all cpufreq
cooling configs enabled in kernel version 3.8-rc1.
In my tests I am able to vary scaling_max_freq to all values. Also I
am in normal temperature threshold. So basically I am not able to
reproduce the error reported,

Thanks,
Amit Daniel
>
>> There is a check in cpufreq_thermal_notifier function to return 0 if
>> notify_device == NOTIFY_INVALID. So the user will be always able to
>> change the max frequency in normal situation. Did you tested this for
>> some corner cases?
>> The reason behind putting this check is that I don't want to override
>> the user constraints.
>>
>> Thanks,
>> Amit Daniel
>>
>>>
>>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>>> ---
>>>  drivers/thermal/cpu_cooling.c |    4 ----
>>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>>> index 836828e..63bc708 100644
>>> --- a/drivers/thermal/cpu_cooling.c
>>> +++ b/drivers/thermal/cpu_cooling.c
>>> @@ -219,10 +219,6 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
>>>         if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
>>>                 max_freq = notify_device->cpufreq_val;
>>>
>>> -       /* Never exceed user_policy.max*/
>>> -       if (max_freq > policy->user_policy.max)
>>> -               max_freq = policy->user_policy.max;
>>> -
>>>         if (policy->max != max_freq)
>>>                 cpufreq_verify_within_limits(policy, 0, max_freq);
>>>
>>> --
>>> 1.7.7.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
