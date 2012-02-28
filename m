Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2B1CT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:19:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54968 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab2B1CTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:19:23 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201202260059.02347.rjw@sisk.pl>
References: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com>
	<1329897815-15871-1-git-send-email-myungjoo.ham@samsung.com>
	<1329897815-15871-2-git-send-email-myungjoo.ham@samsung.com>
	<201202260059.02347.rjw@sisk.pl>
Date: Tue, 28 Feb 2012 11:19:22 +0900
X-Google-Sender-Auth: 4DAfiGqz5uNbkrtglJm0HzsGgGc
Message-ID: <CAJ0PZbSn8A6fOeq5_wDDQD7hEbb92N7CDA62YtT1gr1Rx6+7bw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] CPUfreq ondemand: update sampling rate without
 waiting for next sampling
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/26 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, February 22, 2012, MyungJoo Ham wrote:
>> When a new sampling rate is shorter than the current one, (e.g., 1 sec
>> --> 10 ms) regardless how short the new one is, the current ondemand
>> mechanism wait for the previously set timer to be expired.
>>
>> For example, if the user has just expressed that the sampling rate
>> should be 10 ms from now and the previous was 1000 ms, the new rate may
>> become effective 999 ms later, which could be not acceptable for the
>> user if the user has intended to speed up sampling because the system is
>> expected to react to CPU load fluctuation quickly from __now__.
>>
>> In order to address this issue, we need to cancel the previously set
>> timer (schedule_delayed_work) and reset the timer if resetting timer is
>> expected to trigger the delayed_work ealier.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
[]
>> +
>> +             if (!delayed_work_pending(&dbs_info->work))
>> +                     goto next;
>> +
>
> What about doing
>
>                        mutex_unlock(&dbs_info->timer_mutex);
>                        continue;
>
> here instead of the jump?
>

Like patch 2/2 of this patchset, I'll remove goto in the loop.

>
>> +             timer = &dbs_info->work.timer;
>> +             appointed_at = timer->expires;
>> +
>
> I would do
>
>                next_sampling = jiffies + usecs_to_jiffies(new_rate);
>
> and compare that with timer->expires.  Then, the if () below would look better.
> Or perhaps use new_rate_jiffies = usecs_to_jiffies(new_rate) and use that here
> and below?
>

Oh.. yes, this surely looks ugly. I'll update this.

>> +             if (time_before(jiffies + usecs_to_jiffies(new_rate),
>> +                             appointed_at)) {
>> +
>> +                     mutex_unlock(&dbs_info->timer_mutex);
>
> I'm not sure if this isn't going to be racy.  Have you verified that?

This unlock is added to avoid race condition against do_dbs_timer().
Unless the delay is 0 (polling_interval = 0ms?), do_dbs_timer() or
mutex_lock() took several ms, do_dbs_timer() won't be running again
holding the mutex after cancel_delayed_work_sync().

I've tested a few cases only backported on kernel 3.0; however, I'll
do more extensive testing on this part before submitting the next
iteration of the patchset and try to run this code with 3.3-rc5.

>
>> +                     cancel_delayed_work_sync(&dbs_info->work);
>> +                     mutex_lock(&dbs_info->timer_mutex);
>> +
>> +                     schedule_delayed_work_on(dbs_info->cpu, &dbs_info->work,
>> +                                              usecs_to_jiffies(new_rate));
>> +
>> +             }
>> +next:
>> +             mutex_unlock(&dbs_info->timer_mutex);
>> +     }
>> +}
>> +
>>  static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
>>                                  const char *buf, size_t count)
>>  {
>> @@ -265,7 +321,7 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
>>       ret = sscanf(buf, "%u", &input);
>>       if (ret != 1)
>>               return -EINVAL;
>> -     dbs_tuners_ins.sampling_rate = max(input, min_sampling_rate);
>> +     update_sampling_rate(input);
>>       return count;
>>  }
>
> Thanks,
> Rafael

Thank you.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
