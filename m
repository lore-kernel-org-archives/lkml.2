Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0IMTLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:11:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57143 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0IMTLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:11:52 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=g-sa0-2UbzsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=k-3D2yv1KpP1NpLBOlcA:9 a=CVlKhTOCSxe_PMeC1OgA:7 a=txO9FBTaRSYgyhihSWrlExWbd04A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC] get rid of cpupri lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: ghaskins@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100913180415.GT21374@think>
References: <20100913180415.GT21374@think>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 15:11:49 -0400
Message-ID: <1284405110.17152.86.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 14:04 -0400, Chris Mason wrote:
> I recently had the chance to try and tune 2.6.32 kernels running oracle
> on OLTP workloads.  One of the things oracle loves to do for tuning
> these benchmarks is make all the database tasks involved SCHED_FIFO.
> This is because they have their own userland locks and if they get
> scheduled out, lock contention goes up.

And each thread is bound to its own CPU, right?

> 
> <please insert flames about userland locking here>

Userland locking sucks sucks sucks!!!

> 
> <and here>
> 
> <and here>
> 
> The box I was tuning had 8 sockets and the first thing that jumped out
> at me during the run was that we were spending all our system time
> inside cpupri_set.  Since the rq lock must be held in cpurpi_set, I
> don't think we need the cpupri lock at all.
> 
> The patch below is entirely untested, mostly because I'm hoping for
> hints on good ways to test it.  Clearly Oracle RT isn't the workload we
> really want to tune for, but I think this change is generally useful if
> we can do it safely.
> 
> cpusets could also be used to mitigate this problem, but if we can just
> avoid the lock it would be nice.
> 
> diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
> index 2722dc1..dd51302 100644
> --- a/kernel/sched_cpupri.c
> +++ b/kernel/sched_cpupri.c
> @@ -115,7 +115,6 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
>  {
>  	int                 *currpri = &cp->cpu_to_pri[cpu];
>  	int                  oldpri  = *currpri;
> -	unsigned long        flags;
>  
>  	newpri = convert_prio(newpri);
>  
> @@ -134,26 +133,15 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
>  	if (likely(newpri != CPUPRI_INVALID)) {
>  		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
>  
> -		raw_spin_lock_irqsave(&vec->lock, flags);
> -
>  		cpumask_set_cpu(cpu, vec->mask);
> -		vec->count++;
> -		if (vec->count == 1)
> +		if (atomic_inc_return(&vec->count) == 1)
>  			set_bit(newpri, cp->pri_active);
> -
> -		raw_spin_unlock_irqrestore(&vec->lock, flags);

IIRC we tried this at first (Gregory?). The problem is that you just
moved the setting of the vec->mask outside of the updating of the vec
count. I don't think rq lock helps here at all.

I'll look into this too.

-- Steve

>  	}
>  	if (likely(oldpri != CPUPRI_INVALID)) {
>  		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
> -
> -		raw_spin_lock_irqsave(&vec->lock, flags);
> -
> -		vec->count--;
> -		if (!vec->count)
> +		if (atomic_dec_and_test(&vec->count))
>  			clear_bit(oldpri, cp->pri_active);
>  		cpumask_clear_cpu(cpu, vec->mask);
> -
> -		raw_spin_unlock_irqrestore(&vec->lock, flags);
>  	}
>  
>  	*currpri = newpri;
> @@ -174,9 +162,8 @@ int cpupri_init(struct cpupri *cp)
>  
>  	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
>  		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
> +		atomic_set(&vec->count, 0);
>  
> -		raw_spin_lock_init(&vec->lock);
> -		vec->count = 0;
>  		if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
>  			goto cleanup;
>  	}
> diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
> index 9fc7d38..fe07002 100644
> --- a/kernel/sched_cpupri.h
> +++ b/kernel/sched_cpupri.h
> @@ -12,8 +12,7 @@
>  /* values 2-101 are RT priorities 0-99 */
>  
>  struct cpupri_vec {
> -	raw_spinlock_t lock;
> -	int        count;
> +	atomic_t   count;
>  	cpumask_var_t mask;
>  };
>  


