Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252Ab2DKVDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:03:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2DKVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:03:44 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=qYvamlIpaesA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=69EAbJreAAAA:8 a=3YU3d8lWWI3dlAhyancA:9 a=RA07r4QecYht461qVPIA:7 a=PUjeQqilurYA:10 a=-fXH9i5dZQ0A:10 a=MSl-tDqOz04A:10 a=2ImLJ_cNC9mNqCM9:21 a=SC9wVEaafwsf_ORw:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334178222.23924.304.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 11/16] sched: add latency tracing for -deadline tasks.
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
Date: Wed, 11 Apr 2012 17:03:42 -0400
In-Reply-To: <1333696481-3433-12-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-12-git-send-email-juri.lelli@gmail.com>
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
> It is very likely that systems that wants/needs to use the new
> SCHED_DEADLINE policy also want to have the scheduling latency of
> the -deadline tasks under control.
> 
> For this reason a new version of the scheduling wakeup latency,
> called "wakeup_dl", is introduced.
> 
> As a consequence of applying this patch there will be three wakeup
> latency tracer:
>  * "wakeup", that deals with all tasks in the system;
>  * "wakeup_rt", that deals with -rt and -deadline tasks only;
>  * "wakeup_dl", that deals with -deadline tasks only.
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/trace/trace_sched_wakeup.c |   41 ++++++++++++++++++++++++++++++++++++-
>  kernel/trace/trace_selftest.c     |   30 ++++++++++++++++----------
>  2 files changed, 58 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index e4a70c0..9c9b1be 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -27,6 +27,7 @@ static int			wakeup_cpu;
>  static int			wakeup_current_cpu;
>  static unsigned			wakeup_prio = -1;
>  static int			wakeup_rt;
> +static int			wakeup_dl;
>  
>  static arch_spinlock_t wakeup_lock =
>  	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
> @@ -420,6 +421,17 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  	if ((wakeup_rt && !rt_task(p)) ||
>  			p->prio >= wakeup_prio ||
>  			p->prio >= current->prio)

I don't think you meant to keep both if statements. Look above and
below ;-)

> +	/*
> +	 * Semantic is like this:
> +	 *  - wakeup tracer handles all tasks in the system, independently
> +	 *    from their scheduling class;
> +	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
> +	 *    sched_rt class;
> +	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
> +	 */
> +	if ((wakeup_dl && !dl_task(p)) ||
> +	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
> +	    (p->prio >= wakeup_prio || p->prio >= current->prio))
>  		return;

Anyway, perhaps this should be broken up, as we don't want the double
test, that is, wakeup_rt and wakeup_dl are both checked. Perhaps do:

	if (wakeup_dl && !dl_task(p))
		return;
	else if (wakeup_rt && !dl_task(p) && !rt_task(p))
		return;

	if (p->prio >= wakeup_prio || p->prio >= current->prio)
		return;


-- Steve

>  
>  	pc = preempt_count();
> @@ -431,7 +443,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  	arch_spin_lock(&wakeup_lock);
>  
>  	/* check for races. */
> -	if (!tracer_enabled || p->prio >= wakeup_prio)
> +	if (!tracer_enabled || (!dl_task(p) && p->prio >= wakeup_prio))
>  		goto out_locked;
>  
>  	/* reset the trace */
> @@ -539,16 +551,25 @@ static int __wakeup_tracer_init(struct trace_array *tr)
>  


