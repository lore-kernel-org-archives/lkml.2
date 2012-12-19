Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab2LSFpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:45:40 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:33792 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2LSFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <CADGdYn6P8T9AKBpHV+uz6avh0+8uWQ+qnKyCjYsYdHQRpPriRg@mail.gmail.com>
References: <1355819384-25983-1-git-send-email-sonnyrao@chromium.org>
	<CADGdYn6P8T9AKBpHV+uz6avh0+8uWQ+qnKyCjYsYdHQRpPriRg@mail.gmail.com>
Date: Tue, 18 Dec 2012 21:45:32 -0800
X-Google-Sender-Auth: UAClwKMQbb8Vqlw0xOK05QMirXk
Message-ID: <CAD=FV=W+tO_3MfGYv_kc3XLw4VWHUXB2NUC+Etj9gW+1vSgvHQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] cpufreq: can't raise max frequency with cpu_thermal
From: Doug Anderson <dianders@chromium.org>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit,

On Tue, Dec 18, 2012 at 8:17 PM, amit daniel kachhap
<amit.daniel@samsung.com> wrote:
> On Tue, Dec 18, 2012 at 12:29 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
>> The cpu_thermal generic thermal management code has a bug where once
>> max cpu frequency has been lowered in sysfs (scaling_max_freq) it is
>> not possible to raise the max back up later.  The bug is that the
>> notifer gets called by __cpufreq_set_policy() before the user policy
>> max is raised, and is incorrectly trying to enforce the max frequency
>> policy even when we are trying to change the policy.  It is also not
>> clear why this driver is looking at the user policy since it is
>> primarily supposed to enforce thermal policy, not user set policy.
>
> Hi Sunny,
>
> I am not sure if this change is needed.

Do you have a machine that's running with your code?  Can you go into
sysfs (/sys/devices/system/cpu/cpu0/cpufreq/) and try lowering then
raising the max frequency by doing something like this (assumes that
you can scale down to 200MHz):

  cd /sys/devices/system/cpu/cpu0/cpufreq/
  OLD_VAL=$(cat scaling_max_freq)
  cat scaling_min_freq > scaling_max_freq
  echo ${OLD_VAL} > scaling_max_freq

  echo "$(cat scaling_max_freq) should be ${OLD_VAL}.  Is it?"

...when I run the above without Sonny's patch on my system I see:
  200000 should be 1700000. Is it?

...after Sonny's patch then the above works.

> There is a check in cpufreq_thermal_notifier function to return 0 if
> notify_device == NOTIFY_INVALID. So the user will be always able to
> change the max frequency in normal situation. Did you tested this for
> some corner cases?
> The reason behind putting this check is that I don't want to override
> the user constraints.
>
> Thanks,
> Amit Daniel
>
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>> ---
>>  drivers/thermal/cpu_cooling.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>> index 836828e..63bc708 100644
>> --- a/drivers/thermal/cpu_cooling.c
>> +++ b/drivers/thermal/cpu_cooling.c
>> @@ -219,10 +219,6 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
>>         if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
>>                 max_freq = notify_device->cpufreq_val;
>>
>> -       /* Never exceed user_policy.max*/
>> -       if (max_freq > policy->user_policy.max)
>> -               max_freq = policy->user_policy.max;
>> -
>>         if (policy->max != max_freq)
>>                 cpufreq_verify_within_limits(policy, 0, max_freq);
>>
>> --
>> 1.7.7.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

-Doug
