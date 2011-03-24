Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1CXOWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:22:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1CXOWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:22:02 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=uL5GH6c9apcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uZvujYp8AAAA:8 a=meVymXHHAAAA:8 a=9Ls6VrSNf5Z5ZYkfeZ8A:9 a=PBM45QQFVPepPoPGFuowNe-2qC8A:4 a=PUjeQqilurYA:10 a=4ECU3KRaPPwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: leave sched_setscheduler earlier if possible.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dario Faggioli <raistlin@linux.it>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <1300971618.3960.82.camel@Palantir>
References: <1300971618.3960.82.camel@Palantir>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Mar 2011 10:21:59 -0400
Message-ID: <1300976519.14261.141.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 14:00 +0100, Dario Faggioli wrote:
> sched_setscheduler (in sched.c) is called in order of changing the
> scheduling policy and/or the real-time priority of a task. Thus,
> if we find out that neither of those are actually being modified, it
> is possible to return earlier and save the overhead of a full
> deactivate+activate cycle of the task in question.
> 
> Beside that, if we have more than one SCHED_FIFO task with the same
> priority on the same rq (which means they share the same priority queue)
> having one of them changing its position in the priority queue because of
> a sched_setscheduler (as it happens by means of the deactivate+activate)
> that does not actually change the priority violates POSIX which states,
> for SCHED_FIFO:
> 
> "If a thread whose policy or priority has been modified by
> pthread_setschedprio() is a running thread or is runnable, the effect on
> its position in the thread list depends on the direction of the
> modification, as follows: a. <...> b. If the priority is unchanged, the
> thread does not change position in the thread list. c. <...>"
> 
> (http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html)
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

> ---
>  kernel/sched.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c5ae6bc..d73bbc5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c


> @@ -4998,6 +4998,16 @@ recheck:

Peter, this is why I prefer:

 recheck:
over
recheck:

-- Steve


>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * If not changing anything there's no need to proceed further
> +	 */
> +	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
> +	    param->sched_priority == p->rt_priority))) {
> +			__task_rq_unlock(rq);
> +			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> +			return 0;
> +	}
> +
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	if (user) {
>  		/*
> -- 
> 1.7.4.1
> 


