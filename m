Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2JRT5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab2JRT5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:57:24 -0400
Date: Thu, 18 Oct 2012 15:56:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
In-Reply-To: <507F66F6.20704@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.1210181545520.32376@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
 <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
 <507E48ED.8060809@cn.fujitsu.com> <Pine.LNX.4.64.1210171046130.26481@file.rdu.redhat.com>
 <20121017202806.GA7282@home.goodmis.org> <507F66F6.20704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks sensible.

I'd apply either this or my previous patch that adds synchronize_rcu() to 
percpu_up_write.

This patch avoids the memory barrier on non-x86 cpus in percpu_up_read, so 
it is faster than the previous approach.

Mikulas


On Thu, 18 Oct 2012, Lai Jiangshan wrote:

> ---------------
> 
> a very draft example of paired-mb()s is here:
> 
> 
> diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> index cf80f7e..84a93c0 100644
> --- a/include/linux/percpu-rwsem.h
> +++ b/include/linux/percpu-rwsem.h
> @@ -12,6 +12,14 @@ struct percpu_rw_semaphore {
>  	struct mutex mtx;
>  };
>  
> +#if 1
> +#define light_mb() barrier()
> +#define heavy_mb() synchronize_sched()
> +#else
> +#define light_mb() smp_mb()
> +#define heavy_mb() smp_mb();
> +#endif
> +
>  static inline void percpu_down_read(struct percpu_rw_semaphore *p)
>  {
>  	rcu_read_lock();
> @@ -24,22 +32,12 @@ static inline void percpu_down_read(struct percpu_rw_semaphore *p)
>  	}
>  	this_cpu_inc(*p->counters);
>  	rcu_read_unlock();
> +	light_mb(); /* A, between read of p->locked and read of data, paired with D */
>  }
>  
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
> @@ -61,11 +59,12 @@ static inline void percpu_down_write(struct percpu_rw_semaphore *p)
>  	synchronize_rcu();
>  	while (__percpu_count(p->counters))
>  		msleep(1);
> -	smp_rmb(); /* paired with smp_mb() in percpu_sem_up_read() */
> +	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */
>  }
>  
>  static inline void percpu_up_write(struct percpu_rw_semaphore *p)
>  {
> +	heavy_mb(); /* D, between write to data and write to p->locked, paired with A */
>  	p->locked = false;
>  	mutex_unlock(&p->mtx);
>  }
> 
