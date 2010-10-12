Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0JLO2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:28:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0JLO2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YA1/rzraz0g1cr2xOpG/zoyH2nhg4Dg2Nh7ZgFhfRJssIj+VLQ6DNU/4rsD3Tq5+68
         CLCrBwM2Ejm8yLj8gc1Q==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010121046060.2909@localhost6.localdomain6>
References: <20101012000159.7091.84336.stgit@dungbeetle.mtv.corp.google.com>
	<alpine.LFD.2.00.1010121046060.2909@localhost6.localdomain6>
Date: Tue, 12 Oct 2010 07:28:40 -0700
Message-ID: <AANLkTikgvZuT5+sgPyD-1j1gG+-pC0+4hpXQj7Z_ZuYE@mail.gmail.com>
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
From: Salman Qazi <sqazi@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 1:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 11 Oct 2010, Salman Qazi wrote:
>
>> The race is described as follows:
>>
>> CPU X                                 CPU Y
>> remove_hrtimer
>> // state & QUEUED == 0
>> timer->state = CALLBACK
>> unlock timer base
>> timer->f(n) //very long
>>                                   hrtimer_start
>>                                     lock timer base
>>                                     remove_hrtimer // no effect
>>                                     hrtimer_enqueue
>>                                     timer->state = CALLBACK |
>>                                                    QUEUED
>>                                     unlock timer base
>>                                   hrtimer_start
>>                                     lock timer base
>>                                     remove_hrtimer
>>                                         mode = INACTIVE
>>                                         // CALLBACK bit lost!
>>                                     switch_hrtimer_base
>>                                             CALLBACK bit not set:
>>                                                     timer->base
>>                                                     changes to a
>>                                                     different CPU.
>> lock this CPU's timer base
>
> Good catch.
>
>> Bug reproducible and fix testable using a kernel module that hrtimer_start()s
>> a timer with a very long running callback from multiple CPUs:
>>
>> MODULE_LICENSE("GPL");
>>
>> static long timer_func_time = 1000;
>> module_param(timer_func_time, long, 0600);
>> static long timer_starts = 2500;
>> module_param(timer_starts, long, 0600);
>> static long timer_expire = 1000;
>> module_param(timer_expire, long, 0600);
>>
>> DEFINE_PER_CPU(struct task_struct *, hrtimer_thread);
>>
>> /* There are other issues, like deadlocks between multiple hrtimer_start observed
>>  * calls, at least in 2.6.34 that this lock works around.  Will look into
>>  * those later.
>
> Well, we don't have to work around callsites not serializing themself
> in the core code, right ?

I assumed that the semantics were that hrtimer_starts are serialized
with respect to each other and with respect to cancels.   You seem to
disagree.

In any case, I have to rerun that test without this lock with the
patch present.  It's possible that it was a symptom of the same bug
that we just didn't observe in production.

>
>> ---
>>  kernel/hrtimer.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>> index 1decafb..57846d5 100644
>> --- a/kernel/hrtimer.c
>> +++ b/kernel/hrtimer.c
>> @@ -944,8 +944,8 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
>>               debug_deactivate(timer);
>>               timer_stats_hrtimer_clear_start_info(timer);
>>               reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
>> -             __remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
>> -                              reprogram);
>> +             __remove_hrtimer(timer, base,
>> +                              (timer->state & HRTIMER_STATE_CALLBACK), reprogram);
>>               return 1;
>>       }
>>       return 0;
>> @@ -1231,6 +1231,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>>               BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
>>               enqueue_hrtimer(timer, base);
>>       }
>> +
>> +     WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
>> +
>>       timer->state &= ~HRTIMER_STATE_CALLBACK;
>>  }
>
> Can I please get your Signed-off-by so this can be queued ?
>
> Thanks,
>
>        tglx
>
>
