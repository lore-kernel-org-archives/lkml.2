Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1CGJL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:11:57 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:48863 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1CGJLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w4P5xnE1HFBu9rqcs6Ofo+2fvRGzzwWLsEOOcwUu4AB/TAKsAbILCOkytByXPmZq7V
         RfbyEm4IjmsjTl/LB1BoZliFtB9HXapB3rtdIKEsq6eeGjnAzi0ZenVBW6owm6ESUPqz
         qXwUyrioRLSNSh4j9B6ApMOoXvhJEJze2SFes=
MIME-Version: 1.0
In-Reply-To: <1299486101.14465.25.camel@marge.simson.net>
References: <1299486101.14465.25.camel@marge.simson.net>
Date: Mon, 7 Mar 2011 17:11:52 +0800
Message-ID: <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 4:21 PM, Mike Galbraith <efault@gmx.de> wrote:
> Greetings,
>
> The RT throttle leaves a bit to be desired as a protection mechanism.
> With default settings, the thing won't save your bacon if you start a
> single hog as RT on SMP box, or if your normally sane app goes nuts.
>
> With the below, my box will limp along so I can kill the RT hog.  May
> not be the best solution, but works for me.. modulo bustage I haven't
> noticed yet of course.
>
> sched: fix rt throttle runtime borrowing
>
> If allowed to borrow up to rt_period, the throttle has no effect on an out
> of control RT task, allowing it to consume 100% CPU indefinitely, blocking
> system critical SCHED_NORMAL threads indefinitely.

Yep.
I think it's helpful.

BTW, the comments(above diff calculation) in do_balance_runtime()
should be updated too :)

Thanks,
Yong

>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -354,7 +354,7 @@ static int do_balance_runtime(struct rt_
>        weight = cpumask_weight(rd->span);
>
>        raw_spin_lock(&rt_b->rt_runtime_lock);
> -       rt_period = ktime_to_ns(rt_b->rt_period);
> +       rt_period = ktime_to_ns(rt_b->rt_period) - 1;
>        for_each_cpu(i, rd->span) {
>                struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
>                s64 diff;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
