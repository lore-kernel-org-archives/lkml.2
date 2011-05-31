Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1EaUVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:21:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1EaUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:21:12 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=E3Ha86V7p3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=067QlRw32H3ZTMneNjgA:9 a=3reY-vamkCfnc2F1lgMA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=UXVmiyVkT6AA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: deduplicate atomic operations in
 select_nohz_load_balancer()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTi=ybwWg9z6tKaAL-BfeSmsq6EL-=Q@mail.gmail.com>
References: <BANLkTi=ybwWg9z6tKaAL-BfeSmsq6EL-=Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 16:21:09 -0400
Message-ID: <1306873269.10135.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 20:48 +0800, Hillf Danton wrote:
> Two atomic-related operations, atomic_read and atomic_cmpxchg, are
> used here to do the job. Since comparison is already included in the
> later, the former is folded in the later, and operation is shorter.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- tip-git/kernel/sched_fair.c	Sat May 14 15:21:56 2011
> +++ sched_fair.c	Wed May 25 20:15:34 2011
> @@ -3806,35 +3806,25 @@ void select_nohz_load_balancer(int stop_
> 
>  	if (stop_tick) {
>  		if (!cpu_active(cpu)) {
> -			if (atomic_read(&nohz.load_balancer) != cpu)
> -				return;
> -
>  			/*
>  			 * If we are going offline and still the leader,
>  			 * give up!
>  			 */
> -			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
> -					   nr_cpu_ids) != cpu)
> -				BUG();
> +			atomic_cmpxchg(&nohz.load_balancer, cpu, nr_cpu_ids);

OK, I can handle this change.

> 
>  			return;
>  		}
> 
>  		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
> 
> -		if (atomic_read(&nohz.first_pick_cpu) == cpu)
> -			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
> -		if (atomic_read(&nohz.second_pick_cpu) == cpu)
> -			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
> +		atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
> +		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);

This too, but we are doing a lot of cmpxchg's here when we probably
don't need to. But this does not look like a fast path so it may not be
that big of a deal.

> 
> -		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
> +		/* make me the ilb owner */
> +		if (nr_cpu_ids ==
> +		    atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids, cpu)) {

Hmm, I see what you are doing here. But to fit the rest of the code, it
should be:

	if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids, cpu) ==
		nr_cpu_ids) {



>  			int new_ilb;
> 
> -			/* make me the ilb owner */
> -			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
> -					   cpu) != nr_cpu_ids)
> -				return;
> -
>  			/*
>  			 * Check to see if there is a more power-efficient
>  			 * ilb.
> @@ -3853,10 +3843,7 @@ void select_nohz_load_balancer(int stop_
> 
>  		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
> 
> -		if (atomic_read(&nohz.load_balancer) == cpu)
> -			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
> -					   nr_cpu_ids) != cpu)
> -				BUG();
> +		atomic_cmpxchg(&nohz.load_balancer, cpu, nr_cpu_ids);
>  	}
>  	return;
>  }

The only other thing I can see that might be of issue, but not a big
one, is that we are removing BUG checks. We may have been able to detect
a bug before by seeing that the load_balancer was one thing, and
suddenly changed when it shouldn't have. This may not be a big deal, but
I just wanted to bring that up.

This change needs to be acked by Peter. I don't work much with the
sched_fair code.

-- Steve


