Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0IMTWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:22:38 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:56274 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab0IMTWh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:3:1>);
	Mon, 13 Sep 2010 15:22:37 -0400
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 15:22:37 EDT
Message-Id: <4C8E3CF70200005A00071931@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 13 Sep 2010 13:02:15 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <rostedt@goodmis.org>, "Chris Mason" <chris.mason@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] get rid of cpupri lock
References: <20100913180415.GT21374@think>
In-Reply-To: <20100913180415.GT21374@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris

>>> On 9/13/2010 at 02:04 PM, in message <20100913180415.GT21374@think>, Chris
Mason <chris.mason@oracle.com> wrote: 
> I recently had the chance to try and tune 2.6.32 kernels running oracle
> on OLTP workloads.  One of the things oracle loves to do for tuning
> these benchmarks is make all the database tasks involved SCHED_FIFO.
> This is because they have their own userland locks and if they get
> scheduled out, lock contention goes up.
> 
> <please insert flames about userland locking here>
> 
> <and here>
> 
> <and here>
> 
> The box I was tuning had 8 sockets and the first thing that jumped out
> at me during the run was that we were spending all our system time
> inside cpupri_set.  Since the rq lock must be held in cpurpi_set, I
> don't think we need the cpupri lock at all.

I haven't had a chance to study your patch yet, but this comment concerns me.  I think the issue is that the rq locks are per CPU, while the cpupri locks are per priority.  Therefore, I don't think it is safe to rely on the rq lock to guard this structure since other cpus/rqs may be concurrently updating the vector.  That said, the cpupri lock has bothered me since the beginning, so any clever scheme which can avoid it would be highly welcome.

Ill try to spend some time later going over your proposal.

Kind Regards,
-Greg

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


