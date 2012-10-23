Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2JWQ6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203Ab2JWQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:58:41 -0400
Date: Tue, 23 Oct 2012 18:59:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
Message-ID: <20121023165912.GA18712@redhat.com>
References: <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not really the comment, but the question...

On 10/22, Mikulas Patocka wrote:
>
>  static inline void percpu_down_read(struct percpu_rw_semaphore *p)
>  {
>  	rcu_read_lock();
> @@ -24,22 +27,12 @@ static inline void percpu_down_read(stru
>  	}
>  	this_cpu_inc(*p->counters);
>  	rcu_read_unlock();
> +	light_mb(); /* A, between read of p->locked and read of data, paired with D */
>  }

rcu_read_unlock() (or even preempt_enable) should have compiler barrier
semantics... But I agree, this adds more documentation for free.

>  static inline void percpu_up_read(struct percpu_rw_semaphore *p)
>  {
> -	/*
> -	 * On X86, write operation in this_cpu_dec serves as a memory unlock
> -	 * barrier (i.e. memory accesses may be moved before the write, but
> -	 * no memory accesses are moved past the write).
> -	 * On other architectures this may not be the case, so we need smp_mb()
> -	 * there.
> -	 */
> -#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
> -	barrier();
> -#else
> -	smp_mb();
> -#endif
> +	light_mb(); /* B, between read of the data and write to p->counter, paired with C */
>  	this_cpu_dec(*p->counters);
>  }
>
> @@ -61,11 +54,12 @@ static inline void percpu_down_write(str
>  	synchronize_rcu();
>  	while (__percpu_count(p->counters))
>  		msleep(1);
> -	smp_rmb(); /* paired with smp_mb() in percpu_sem_up_read() */
> +	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */

I _think_ this is correct.


Just I am wondering if this is strongly correct in theory, I would
really like to know what Paul thinks.

Ignoring the current implementation, according to the documentation
synchronize_sched() has all rights to return immediately if there is
no active rcu_read_lock_sched() section. If this were possible, than
percpu_up_read() lacks mb.

So _perhaps_ it makes sense to document that synchronize_sched() also
guarantees that all pending loads/stores on other CPUs should be
completed upon return? Or I misunderstood the patch?

Oleg.

