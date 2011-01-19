Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1ASCjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 21:39:00 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39988 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1ASCi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 21:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AoBkTtJV3rN69YwPg0lNYCRQIKBzSu6oyTVoMbaqOG+urt9I+aNezHqVG0bkxCGWg4
         26krucQR02ynljJiToMe2OW5VEGCACNBM9Ng8EQ3LDyzEQuRL9s3Eq/EPY2S96S8Ub/1
         aPwnWJCJ1cY2RvBiQ3eirjFh8PKPrN1F788zw=
MIME-Version: 1.0
In-Reply-To: <1295357746.30950.681.camel@laptop>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
Date: Wed, 19 Jan 2011 10:38:57 +0800
Message-ID: <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 9:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Subject: sched: Fix switch_to_fair()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Jan 17 17:03:27 CET 2011
>
> When a task is placed back into fair_sched_class, we must update its
> placement, since we don't know how long its been gone, hence its
> vruntime is stale and cannot be trusted.
>
> There is also a case where it was moved from fair_sched_class when it
> was in a blocked state and moved back while it is running, this causes
> an imbalance between DEQUEUE_SLEEP/DEQUEUE_WAKEUP for the fair class
> and leaves vruntime way out there (due to the min_vruntime
> adjustment).
>
> Also update sysrq-n to call the ->switch_{to,from} methods.
>
> Reported-by: Onkalo Samu <samu.p.onkalo@nokia.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c      |    4 ++++
>  kernel/sched_fair.c |   16 ++++++++++++++++
>  2 files changed, 20 insertions(+)
>
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -4075,6 +4075,22 @@ static void prio_changed_fair(struct rq
>  static void switched_to_fair(struct rq *rq, struct task_struct *p,
>                             int running)
>  {
> +       struct sched_entity *se = &p->se;
> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +
> +       if (se->on_rq && cfs_rq->curr != se)

(cfs_rq->curr != se) equals to (!running), no?

> +               __dequeue_entity(cfs_rq, se);
> +
> +       /*
> +        * se->vruntime can be completely out there, there is no telling
> +        * how long this task was !fair and on what CPU if any it became
> +        * !fair. Therefore, reset it to a known, reasonable value.
> +        */
> +       se->vruntime = cfs_rq->min_vruntime;

But this is not fair for !SLEEP task.
You know se->vruntime -= cfs_rq->min_vruntime for !SLEEP task,
then after it go through sched_fair-->sched_rt-->sched_fair by some
means, current cfs_rq->min_vruntime is added back.

But here se is putted before where it should be. Is this what we want?

Thanks,
Yong

-- 
Only stand for myself
