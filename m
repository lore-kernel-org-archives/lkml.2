Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab0LXHRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 02:17:22 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:54316 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0LXHRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 02:17:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PB92r2ZrCcxaNzZzuaqXq2zeJtcWcVW2xuzcKs8XQTTCKNeHV6Vrob4iOE7Cqp8Z3y
         EbV2RbEpQ+wZJSgrIgG9F1JerA3hLrsoyV/4UMqWXbrtsqKwMLV28HTdis4hGk+SEj8e
         ONCcHueMHycpusuiJJL3hbIRsxR1qFW3Ky+CM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
References: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
Date: Fri, 24 Dec 2010 15:17:18 +0800
Message-ID: <AANLkTikVQU6ozp0H1u7ghd0=miYyUJL62uP=0FBZSLok@mail.gmail.com>
Subject: Re: [PATCH] fix unsafe operation in high resolution timer
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 9:29 PM, Hillf Danton <dhillf@gmail.com> wrote:
> After calling the callback function of hrtimer, the timer could become
> unreliable in corner cases where the timer will no longer be queued
> and the mm segment, in which the timer is embedded, could be reclaimed
> in the callback.
>
> The unreliability is fixed by checking the result of callback before
> operating the timer again.

Though the patch is buggy. But it actually explores a real problem.

We can't deference a maybe freed object. I'm not sure how
to fix it. Or we just prevent the hrtimer->fn free the object which
contains hrtimer?

Thomas, what's your comment?

Thanks,
Yong
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/kernel/hrtimer.c  2010-11-01 19:54:12.000000000 +0800
> +++ b/kernel/hrtimer.c  2010-12-23 21:17:02.000000000 +0800
> @@ -1225,6 +1225,7 @@ static void __run_hrtimer(struct hrtimer
>        raw_spin_unlock(&cpu_base->lock);
>        trace_hrtimer_expire_entry(timer, now);
>        restart = fn(timer);
> +       if (restart != HRTIMER_NORESTART)
>        trace_hrtimer_expire_exit(timer);
>        raw_spin_lock(&cpu_base->lock);
>
> @@ -1236,11 +1237,8 @@ static void __run_hrtimer(struct hrtimer
>        if (restart != HRTIMER_NORESTART) {
>                BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
>                enqueue_hrtimer(timer, base);
> +               timer->state &= ~HRTIMER_STATE_CALLBACK;
>        }
> -
> -       WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
> -
> -       timer->state &= ~HRTIMER_STATE_CALLBACK;
>  }
>
>  #ifdef CONFIG_HIGH_RES_TIMERS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Only stand for myself.
