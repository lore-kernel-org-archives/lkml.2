Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0I2GpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:45:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0I2GpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qq2BMTFLebzJHn/ytWRdLzNyvPQbCWzpwO5Cbadv3auiBSv15nc1YaAcOPEmh6nctT
         8Aa+3NiiYh59Me8A4+fQ==
MIME-Version: 1.0
In-Reply-To: <1285742527.7440.295.camel@marge.simson.net>
References: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
	<1285661878.2795.70.camel@marge.simson.net>
	<AANLkTikjH1J_nCxZympo9v_VZbptWHBNJ8xh=pFXLRrQ@mail.gmail.com>
	<1285728812.7440.141.camel@marge.simson.net>
	<1285742527.7440.295.camel@marge.simson.net>
Date: Tue, 28 Sep 2010 23:45:10 -0700
Message-ID: <AANLkTi=FpuL04vzO79Okwn8bdaV-paaOWV-HdDocR-nr@mail.gmail.com>
Subject: Re: broken behavior in cfs when moving threads between cgroups
From: Dima Zavin <dmitriyz@google.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I solved it by adding a prep_move_task callback and call it jsut
before set_task_rq. I'm sending the patch series in a separate thread,
let me know what you think.

--Dima

2010/9/28 Mike Galbraith <efault@gmx.de>:
> On Wed, 2010-09-29 at 04:53 +0200, Mike Galbraith wrote:
>
>> ..but, as you noted, moving out then _back_ at forced 0 lag would result
>> in bogus vruntime deltas, so lag must be preserved.  The sleeper's
>> vruntime has to be set to relative before it's cfs_rq is changed, then
>> back to absolute in moved_group_fair() I suppose.
>
> I bent it up like so.
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 53eb33c..d2b06a9 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1073,7 +1073,7 @@ struct sched_class {
>                                         struct task_struct *task);
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -       void (*moved_group) (struct task_struct *p, int on_rq);
> +       void (*moved_group) (struct task_struct *p, int on_rq, int leaving);
>  #endif
>  };
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1ab8394..7001d5a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8358,11 +8358,16 @@ void sched_move_task(struct task_struct *tsk)
>        if (unlikely(running))
>                tsk->sched_class->put_prev_task(rq, tsk);
>
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +       if (tsk->sched_class->moved_group)
> +               tsk->sched_class->moved_group(tsk, on_rq, 1);
> +#endif
> +
>        set_task_rq(tsk, task_cpu(tsk));
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>        if (tsk->sched_class->moved_group)
> -               tsk->sched_class->moved_group(tsk, on_rq);
> +               tsk->sched_class->moved_group(tsk, on_rq, 0);
>  #endif
>
>        if (unlikely(running))
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9b5b4f8..81885ae 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3824,13 +3824,23 @@ static void set_curr_task_fair(struct rq *rq)
>  }
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -static void moved_group_fair(struct task_struct *p, int on_rq)
> +static void moved_group_fair(struct task_struct *p, int on_rq, int leaving)
>  {
>        struct cfs_rq *cfs_rq = task_cfs_rq(p);
>
>        update_curr(cfs_rq);
> -       if (!on_rq)
> -               place_entity(cfs_rq, &p->se, 1);
> +
> +       /*
> +        * For runnable tasks, vruntime normalization is handled globally by
> +        * dequeue_entity().  task_waking_fair() normalizes sleepers in the
> +        * wakeup path (to allow lag to grow while sleeping), so we have to
> +        * normalize before the task exits it's old cfs_rq, and prepare for
> +        * the impending normalization before that happens.
> +        */
> +       if (!on_rq && leaving)
> +               p->se.vruntime -= cfs_rq->min_vruntime;
> +       else if (!on_rq)
> +               p->se.vruntime += cfs_rq->min_vruntime;
>  }
>  #endif
>
>
>
>
