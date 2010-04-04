Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0DDOuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:50:16 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37922 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0DDOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f9JO3X2S9ZyMDaZiJ53ZM1S8zY5xszHnro+x2mMuQ/qjPEmcpfGgmKjMrah83D6yFG
         IBh2obqmM+Lrt/45QQq7Q+kYpvtj/BpXEcSR5j6mpL9bMZNfuV2eg1SP8djMur8GMfbj
         C9SAFOEUWYrU2yjGLOYEZQRdOs4qA8f9X+b6s=
Date: Sun, 4 Apr 2010 16:50:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3] lockdep: Make lockstats counting per cpu
Message-ID: <20100404145000.GC5608@nowhere>
References: <1269736197-10958-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269736197-10958-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 01:29:57AM +0100, Frederic Weisbecker wrote:
> Locking statistics are implemented using global atomic variables.
> This is usually fine unless some path write them very often.
> 
> This is the case for the function and function graph tracers
> that disable irqs for each entry saved (except if the function
> tracer is in preempt disabled only mode).
> And calls to local_irq_save/restore() increment hardirqs_on_events
> and hardirqs_off_events stats (or similar stats for redundant
> versions).
> 
> Incrementing these global vars for each function ends up in too
> much cache bouncing if lockstats are enabled.
> 
> To solve this, implement the debug_atomic_*() operations using
> per cpu vars.
> 
> v2: Use per_cpu() instead of get_cpu_var() to fetch the desired
> cpu vars on debug_atomic_read()
> 
> v3: Store the stats in a structure. No need for local_t as we
> are NMI/irq safe.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>


Quick ping.

No problem with this patch?

Thanks.



> ---
>  kernel/lockdep.c           |   15 +--------
>  kernel/lockdep_internals.h |   74 +++++++++++++++++++++++++++++++------------
>  2 files changed, 54 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 65b5f5b..3434c81 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -430,20 +430,7 @@ static struct stack_trace lockdep_init_trace = {
>  /*
>   * Various lockdep statistics:
>   */
> -atomic_t chain_lookup_hits;
> -atomic_t chain_lookup_misses;
> -atomic_t hardirqs_on_events;
> -atomic_t hardirqs_off_events;
> -atomic_t redundant_hardirqs_on;
> -atomic_t redundant_hardirqs_off;
> -atomic_t softirqs_on_events;
> -atomic_t softirqs_off_events;
> -atomic_t redundant_softirqs_on;
> -atomic_t redundant_softirqs_off;
> -atomic_t nr_unused_locks;
> -atomic_t nr_cyclic_checks;
> -atomic_t nr_find_usage_forwards_checks;
> -atomic_t nr_find_usage_backwards_checks;
> +DEFINE_PER_CPU(struct lockdep_stats, lockdep_stats);
>  #endif
>  
>  /*
> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> index a2ee95a..ccc18f6 100644
> --- a/kernel/lockdep_internals.h
> +++ b/kernel/lockdep_internals.h
> @@ -110,29 +110,61 @@ lockdep_count_backward_deps(struct lock_class *class)
>  #endif
>  
>  #ifdef CONFIG_DEBUG_LOCKDEP
> +
> +#include <asm/local.h>
>  /*
> - * Various lockdep statistics:
> + * Various lockdep statistics.
> + * We want them per cpu as they are often accessed in fast path
> + * and we want to avoid too much cache bouncing.
>   */
> -extern atomic_t chain_lookup_hits;
> -extern atomic_t chain_lookup_misses;
> -extern atomic_t hardirqs_on_events;
> -extern atomic_t hardirqs_off_events;
> -extern atomic_t redundant_hardirqs_on;
> -extern atomic_t redundant_hardirqs_off;
> -extern atomic_t softirqs_on_events;
> -extern atomic_t softirqs_off_events;
> -extern atomic_t redundant_softirqs_on;
> -extern atomic_t redundant_softirqs_off;
> -extern atomic_t nr_unused_locks;
> -extern atomic_t nr_cyclic_checks;
> -extern atomic_t nr_cyclic_check_recursions;
> -extern atomic_t nr_find_usage_forwards_checks;
> -extern atomic_t nr_find_usage_forwards_recursions;
> -extern atomic_t nr_find_usage_backwards_checks;
> -extern atomic_t nr_find_usage_backwards_recursions;
> -# define debug_atomic_inc(ptr)		atomic_inc(ptr)
> -# define debug_atomic_dec(ptr)		atomic_dec(ptr)
> -# define debug_atomic_read(ptr)		atomic_read(ptr)
> +struct lockdep_stats {
> +	int	chain_lookup_hits;
> +	int	chain_lookup_misses;
> +	int	hardirqs_on_events;
> +	int	hardirqs_off_events;
> +	int	redundant_hardirqs_on;
> +	int	redundant_hardirqs_off;
> +	int	softirqs_on_events;
> +	int	softirqs_off_events;
> +	int	redundant_softirqs_on;
> +	int	redundant_softirqs_off;
> +	int	nr_unused_locks;
> +	int	nr_cyclic_checks
> +	int	nr_cyclic_check_recursions;
> +	int	nr_find_usage_forwards_checks;
> +	int	nr_find_usage_forwards_recursions;
> +	int	nr_find_usage_backwards_checks;
> +	int	nr_find_usage_backwards_recursions;
> +};
> +
> +DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
> +
> +#define debug_atomic_inc(ptr)			{		\
> +	struct lockdep_stats *__cpu_lockdep_stats;		\
> +								\
> +	WARN_ON_ONCE(!irq_disabled());				\
> +	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
> +	__cpu_lockdep_stats->ptr++;				\
> +}
> +
> +#define debug_atomic_dec(ptr)			{		\
> +	struct lockdep_stats *__cpu_lockdep_stats;		\
> +								\
> +	WARN_ON_ONCE(!irq_disabled());				\
> +	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
> +	__cpu_lockdep_stats->ptr--;				\
> +}
> +
> +#define debug_atomic_read(ptr)		({				\
> +	struct lockdep_stats *__cpu_lockdep_stats;			\
> +	unsigned long long __total = 0;					\
> +	int __cpu;							\
> +	for_each_possible_cpu(__cpu) {					\
> +		__cpu_lockdep_stats = &per_cpu(lockdep_stats, cpu);	\
> +		__total += __cpu_lockdep_stats->ptr;			\
> +	}								\
> +	__total;							\
> +})
>  #else
>  # define debug_atomic_inc(ptr)		do { } while (0)
>  # define debug_atomic_dec(ptr)		do { } while (0)
> -- 
> 1.6.2.3
> 

