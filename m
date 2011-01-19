Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1ASKiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:38:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:60841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1ASKiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:38:06 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1295430276.30950.1414.camel@laptop>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 11:38:18 +0100
Message-ID: <1295433498.30950.1482.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 10:44 +0100, Peter Zijlstra wrote:
> +static void
> +switched_from_fair(struct rq *rq, struct task_struct *p, int running)
> +{
> +       struct sched_entity *se = &p->se;
> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +
> +       if (!se->on_rq && p->state != TASK_RUNNING)
> +               se->vruntime -= cfs_rq->min_vruntime;
> +}
> +
>  /*
>   * We switched to the sched_fair class.
>   */
> -static void switched_to_fair(struct rq *rq, struct task_struct *p,
> -                            int running)
> +static void
> +switched_to_fair(struct rq *rq, struct task_struct *p, int running)
>  {
> +       struct sched_entity *se = &p->se;
> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +
> +       if (se->on_rq && cfs_rq->curr != se)
> +               __dequeue_entity(cfs_rq, se);
> +
> +       se->vruntimea += cfs_rq->min_vruntime;
> +
> +       if (se->on_rq && cfs_rq->curr != se)
> +               __enqueue_entity(cfs_rq, se);
> +
>         /*
>          * We were most likely switched from sched_rt, so
>          * kick off the schedule if running, otherwise just see 

Hrm, I think the to bit is not needed with the from thing in place, the
enqueue from _setprio will already have added min_vruntime
