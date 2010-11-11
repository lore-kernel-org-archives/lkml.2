Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab0KKX6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:58:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59066 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0KKX6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:58:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IHHlL2cD2pIu6I22W3JGjZ099vWUrOiGsKHXNeeR7hNdF46VAmA2t0cVUrUjSG/S1h
         Gg+f8QeaE+7eb4RJZQSpawYWJ7ztQCtClgtCIGl9cs+Z+yjvCcombBOe6yP3pNkgF5tl
         1wE4aJHJ85J+eB/gUk8a7iK+42gddpe0miO0U=
MIME-Version: 1.0
In-Reply-To: <1289505761.2742.24.camel@work-vm>
References: <1289464582-26898-1-git-send-email-myungjoo.ham@samsung.com>
	<1289505761.2742.24.camel@work-vm>
Date: Fri, 12 Nov 2010 08:58:40 +0900
X-Google-Sender-Auth: 6J7bmvnn04nLdZ8ilefwKN5zyNw
Message-ID: <AANLkTimwTUUBNmg=ZUkS3_u7B_5F9V-m0d8TRYLfs3Lt@mail.gmail.com>
Subject: Re: [RFC-PATCH] clocksource: update lpj if clocksource has been changed.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 5:02 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Thu, 2010-11-11 at 17:36 +0900, MyungJoo Ham wrote:
>> With a clocksource change, loops_per_jiffy may have been changed; thus,
>> the loops_per_jiffy in each cpu should be updated. Especially after some
>> of the cpus were turned off and on, their loops_per_jiffy values are
>> updated while the cpus kept on are not. Therefore, in order to make them
>> "normalized equally", we need to let the loops_per_jiffy values of
>> different cpus be based on the same clocksource.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> First, Thanks for reporting the issue and submitting the patch!
>
> So the premise is that read_current_timer -> get_cycles ->
> clocksource_read on some arches. And then when we select a different
> clocksource for timekeeping, this also changes the get_cycles source
> breaking delay loops.
>
> The clocksource selected for timekeeping and the counter being used for
> get_cycles really shouldn't be explicitly bound. On most systems I don't
> think that is the case, so this patch would force needless recalibration
> calls on clocksource changes.
>
> Which arch specifically are you seeing the issue on? I suspect there is
> be a better way to fix this.
>
> thanks
> -john

We are working on ARM/S5PC210 with two cores. Actually, in single core
systems, clocksource changes that affect loops-per-jiffy do not matter
much as in multi-core systems because we do not have something to
compare with in such a system. This patch adds some overheads on
changing system clocksources; however, is happens only once at boot.

Or, would it be better if we add another entry to struct clocksource;
i.e., "bool recalibrate" in struct clocksource? Then, we can put
recalibration routine in clocksource_select() at the end of the
function deciding whether to recalibrate based on the
"base->recalibrate" value. How about this?



Cheers!
- MyungJoo

>
>
>> ---
>>  kernel/time/clocksource.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index c18d7ef..a9d7935 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -30,6 +30,9 @@
>>  #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
>>  #include <linux/tick.h>
>>  #include <linux/kthread.h>
>> +#include <linux/delay.h>
>>
>>  void timecounter_init(struct timecounter *tc,
>>                     const struct cyclecounter *cc,
>> @@ -592,6 +593,9 @@ static inline void clocksource_select(void) { }
>>   */
>>  static int __init clocksource_done_booting(void)
>>  {
>> +#ifdef CONFIG_SMP
>> +     int cpu;
>> +#endif
>>       mutex_lock(&clocksource_mutex);
>>       curr_clocksource = clocksource_default_clock();
>>       mutex_unlock(&clocksource_mutex);
>> @@ -606,6 +610,13 @@ static int __init clocksource_done_booting(void)
>>       mutex_lock(&clocksource_mutex);
>>       clocksource_select();
>>       mutex_unlock(&clocksource_mutex);
>> +
>> +     calibrate_delay();
>> +#ifdef CONFIG_SMP
>> +     /* loops_per_jiffy may have been changed. */
>> +     for_each_online_cpu(cpu)
>> +             smp_store_cpu_info(cpu);
>> +#endif
>>       return 0;
>>  }
>>  fs_initcall(clocksource_done_booting);
>
>
>



-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
