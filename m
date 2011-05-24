Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1EXNjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:39:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab1EXNjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:39:45 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=3ZKMfmDylW4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=wGuCWiT7QE_ahwPGgPwA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: fix need_resched() when checking peempt
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 09:39:43 -0400
Message-ID: <1306244383.1465.59.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 21:27 +0800, Hillf Danton wrote:
> When checking if current task could be preempted by a newly woken task,
> further check could be bypassed if the current thread is different from
> the current task of run-queue, and it is corrected accordingly.

Ug, that change log is an obfuscated mess. But looking at the actual
patch, I figured what you wanted to say. How about this:

----
The RT preempt check tests the wrong task if NEED_RESCHED is set. It
currently checks the local CPU task. It is suppose to check the task
that is running on the run queue we are about to wake another task on.
----


> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

With a new change log:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
> 
> --- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
> +++ sched_rt.c	Tue May 24 20:31:27 2011
> @@ -1074,7 +1074,7 @@ static void check_preempt_curr_rt(struct
>  	 * to move current somewhere else, making room for our non-migratable
>  	 * task.
>  	 */
> -	if (p->prio == rq->curr->prio && !need_resched())
> +	if (p->prio == rq->curr->prio && !test_tsk_need_resched(rq->curr))
>  		check_preempt_equal_prio(rq, p);
>  #endif
>  }


