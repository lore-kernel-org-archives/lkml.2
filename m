Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783Ab2DLCmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:42:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab2DLCmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:42:37 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uR5o-f0lB1AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=7ejkBxnCMz3taH452PoA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334198553.23924.329.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 13/16] sched: drafted deadline inheritance logic.
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 22:42:33 -0400
In-Reply-To: <1333696481-3433-14-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-14-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> From: Dario Faggioli <raistlin@linux.it>
> 
> Some method to deal with rt-mutexes and make sched_dl interact with
> the current PI-coded is needed, raising all but trivial issues, that
> needs (according to us) to be solved with some restructuring of
> the pi-code (i.e., going toward a proxy execution-ish implementation).

I also would like to point out that this is probably only for -rt? Or is
this for PI futexes as well?

Note, non-proxy version of this code may be an issue. Could a process
force more bandwidth than was allowed by rlimit if the process used PI
futexes forced a behavior that PI waiters were waiting on another
process while it held the PI futex? The process that held the futex may
get more bandwidth if it never lets go of the futex, right?

> 
> This is under development, in the meanwhile, as a temporary solution,
> what this commits does is:
>  - ensure a pi-lock owner with waiters is never throttled down. Instead,
>    when it runs out of runtime, it immediately gets replenished and it's
>    deadline is postponed;
>  - the scheduling parameters (relative deadline and default runtime)
>    used for that replenishments --during the whole period it holds the
>    pi-lock-- are the ones of the waiting task with earliest deadline.

This sounds similar to what I implemented for a company back in 2005.

> 
> Acting this way, we provide some kind of boosting to the lock-owner,
> still by using the existing (actually, slightly modified by the previous
> commit) pi-architecture.
> 
> We would stress the fact that this is only a surely needed, all but
> clean solution to the problem. In the end it's only a way to re-start
> discussion within the community. So, as always, comments, ideas, rants,
> etc.. are welcome! :-)
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  include/linux/sched.h |    9 +++++-
>  kernel/fork.c         |    1 +
>  kernel/rtmutex.c      |   13 +++++++-
>  kernel/sched.c        |   34 ++++++++++++++++++---
>  kernel/sched_dl.c     |   77 +++++++++++++++++++++++++++++++++---------------
>  5 files changed, 102 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5ef7bb6..ca45db4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1309,8 +1309,12 @@ struct sched_dl_entity {
>  	 * @dl_new tells if a new instance arrived. If so we must
>  	 * start executing it with full runtime and reset its absolute
>  	 * deadline;
> +	 *
> +	 * @dl_boosted tells if we are boosted due to DI. If so we are

 DI?

-- Steve


> +	 * outside bandwidth enforcement mechanism (but only until we
> +	 * exit the critical section).
>  	 */
> -	int dl_throttled, dl_new;
> +	int dl_throttled, dl_new, dl_boosted;
>  
>  	/*
>  	 * Bandwidth enforcement timer. Each -deadline task has its
> @@ -1556,6 +1560,8 @@ struct task_struct {
>  	struct rb_node *pi_waiters_leftmost;
>  	/* Deadlock detection and priority inheritance handling */
>  	struct rt_mutex_waiter *pi_blocked_on;
> +	/* Top pi_waiters task */
> +	struct task_struct *pi_top_task;
>  #endif
>  


