Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab2DKQVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:21:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22626 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab2DKQVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:21:40 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Q_vRj5AnrVouVOA9BZsA:9 a=6c1vHMHYU-MpCEzpB5oA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334161298.23924.263.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 12:21:38 -0400
In-Reply-To: <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:

>  /*
>   * Only called when both the current and waking task are -deadline
>   * tasks.
> @@ -487,8 +819,20 @@ static void yield_task_dl(struct rq *rq)
>  static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
>  				  int flags)
>  {
> -	if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
> +	if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline)) {
>  		resched_task(rq->curr);
> +		return;
> +	}
> +
> +#ifdef CONFIG_SMP
> +	/*
> +	 * In the unlikely case current and p have the same deadline
> +	 * let us try to decide what's the best thing to do...
> +	 */
> +	if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0 &&
> +	    !need_resched())

OK, maybe I'm thick. But how is:

  (s64)(p->dl.deadline - rq->curr->dl.deadline) == 0

Better than:

  p->dl.deadline == rq->curr->dl.deadline

?

-- Steve

> +		check_preempt_equal_dl(rq, p);
> +#endif /* CONFIG_SMP */
>  }
>  


