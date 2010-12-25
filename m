Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0LYOTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 09:19:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63206 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab0LYOTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 09:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IFBx4ayqnh8iLPqiwvxkqt971J5H48ccZsC1by958iQUMI0ER5mzaAzKS8Oq3STI84
         SNevIVYKupVJM8eslwEbYXb/6cFR+icJfLfs9nfm6lAcI6vmBxviACWY2M7RpYNez5M0
         0cTj7sXZIIxlKWUzoAKVyPWnnvPajGwiWaZoE=
MIME-Version: 1.0
In-Reply-To: <20101225021209.GA11183@zhy>
References: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
	<AANLkTikVQU6ozp0H1u7ghd0=miYyUJL62uP=0FBZSLok@mail.gmail.com>
	<AANLkTimc0FwBhj5MsnibTTq94AgaQgqCKEXNSOvM_XjE@mail.gmail.com>
	<20101225021209.GA11183@zhy>
Date: Sat, 25 Dec 2010 22:19:11 +0800
Message-ID: <AANLkTimez6segEYEsdsvELqvHjrfY4rPQg6CG_7vyxCq@mail.gmail.com>
Subject: Re: [PATCH] fix unsafe operation in high resolution timer
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 10:12 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Fri, Dec 24, 2010 at 10:28:52PM +0800, Hillf Danton wrote:
>> On Fri, Dec 24, 2010 at 3:17 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> > On Thu, Dec 23, 2010 at 9:29 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> >> After calling the callback function of hrtimer, the timer could become
>> >> unreliable in corner cases where the timer will no longer be queued
>> >> and the mm segment, in which the timer is embedded, could be reclaimed
>> >> in the callback.
>> >>
>> >> The unreliability is fixed by checking the result of callback before
>> >> operating the timer again.
>> >
>> > Though the patch is buggy. But it actually explores a real problem.
>> >
>>
>> Would you please finger out why the patch is buggy?
>
> No problem.

thanks, Yong, for your explanation, and merry Christmas.

>
> Actually the patch change the behavior of current hrtimer.
> See comments below :)
>
>> >> ---
>> >>
>> >> --- a/kernel/hrtimer.c  2010-11-01 19:54:12.000000000 +0800
>> >> +++ b/kernel/hrtimer.c  2010-12-23 21:17:02.000000000 +0800
>> >> @@ -1225,6 +1225,7 @@ static void __run_hrtimer(struct hrtimer
>> >>        raw_spin_unlock(&cpu_base->lock);
>> >>        trace_hrtimer_expire_entry(timer, now);
>> >>        restart = fn(timer);
>> >> +       if (restart != HRTIMER_NORESTART)
>> >>        trace_hrtimer_expire_exit(timer);
>> >>        raw_spin_lock(&cpu_base->lock);
>> >>
>> >> @@ -1236,11 +1237,8 @@ static void __run_hrtimer(struct hrtimer
>> >>        if (restart != HRTIMER_NORESTART) {
>> >>                BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
>> >>                enqueue_hrtimer(timer, base);
>> >> +               timer->state &= ~HRTIMER_STATE_CALLBACK;
>
> HRTIMER_STATE_CALLBACK is only cleared for RESTART hrtimer with
> your modification.
>
>> >>        }
>> >> -
>> >> -       WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
>> >> -
>> >> -       timer->state &= ~HRTIMER_STATE_CALLBACK;
>
> But for a hrtimer which is not free in its callback, like a
> static defined one. the hrtimer could be referenced at the same
> time. So here you cann't just delete the two lines.

After callback, as you agree, it is hard to determine in the current
implementation if the hrtimer is static defined, though another bit
could be added, say, in the flag word of hrtimer, so cutting the two
lines off is deserved.
And more, who will take care of the NORESTART again after callback?

Cheers
Hillf
