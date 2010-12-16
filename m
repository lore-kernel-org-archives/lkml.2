Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0LPTHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:07:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0LPTHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:07:14 -0500
Date: Thu, 16 Dec 2010 18:34:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/5] mutex: Use p->oncpu for the adaptive spin
Message-ID: <20101216173430.GA12841@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.814666573@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216150920.814666573@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Peter Zijlstra wrote:
>
> @@ -3867,52 +3866,29 @@ int mutex_spin_on_owner(struct mutex *lo
>  	 * DEBUG_PAGEALLOC could have unmapped it if
>  	 * the mutex owner just released it and exited.
>  	 */
> -	if (probe_kernel_address(&owner->cpu, cpu))
> +	if (probe_kernel_address(&owner->oncpu, oncpu))
>  		return 0;
>  #else
> -	cpu = owner->cpu;
> +	oncpu = owner->oncpu;
>  #endif
>
> -	/*
> -	 * Even if the access succeeded (likely case),
> -	 * the cpu field may no longer be valid.
> -	 */
> -	if (cpu >= nr_cpumask_bits)
> -		return 0;
> -
> -	/*
> -	 * We need to validate that we can do a
> -	 * get_cpu() and that we have the percpu area.
> -	 */
> -	if (!cpu_online(cpu))
> +	if (!oncpu)
>  		return 0;
>
> -	rq = cpu_rq(cpu);
> -
> -	for (;;) {
> -		/*
> -		 * Owner changed, break to re-assess state.
> -		 */
> -		if (lock->owner != owner) {
> -			/*
> -			 * If the lock has switched to a different owner,
> -			 * we likely have heavy contention. Return 0 to quit
> -			 * optimistic spinning and not contend further:
> -			 */
> -			if (lock->owner)
> -				return 0;
> -			break;
> -		}
> -
> -		/*
> -		 * Is that owner really running on that cpu?
> -		 */
> -		if (task_thread_info(rq->curr) != owner || need_resched())
> +	while (lock->owner == owner && owner->oncpu) {

It seems, this owner->oncpu dereference needs probe_kernel_address() too.
Of course, only in theory.

OTOH, I do not understand why we need the first "if (!oncpu)" check
(and "int oncpu" at all).

Oleg.

