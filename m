Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab1JDVDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 17:03:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1JDVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 17:03:36 -0400
Date: Tue, 4 Oct 2011 23:03:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 53/55] rcu: Warn when srcu_read_lock() is
 used in an extended quiescent state
Message-ID: <20111004210325.GA14165@somewhere.redhat.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-53-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-53-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:47AM -0700, Paul E. McKenney wrote:
> Catch SRCU up to the other variants of RCU by making PROVE_RCU
> complain if either srcu_read_lock() or srcu_read_lock_held() are
> used from within dyntick-idle mode.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/srcu.h |   25 +++++++++++++++----------
>  1 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 58971e8..fcbaee7 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -28,6 +28,7 @@
>  #define _LINUX_SRCU_H
>  
>  #include <linux/mutex.h>
> +#include <linux/rcupdate.h>
>  
>  struct srcu_struct_array {
>  	int c[2];
> @@ -60,18 +61,10 @@ int __init_srcu_struct(struct srcu_struct *sp, const char *name,
>  	__init_srcu_struct((sp), #sp, &__srcu_key); \
>  })
>  
> -# define srcu_read_acquire(sp) \
> -		lock_acquire(&(sp)->dep_map, 0, 0, 2, 1, NULL, _THIS_IP_)
> -# define srcu_read_release(sp) \
> -		lock_release(&(sp)->dep_map, 1, _THIS_IP_)
> -
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  int init_srcu_struct(struct srcu_struct *sp);
>  
> -# define srcu_read_acquire(sp)  do { } while (0)
> -# define srcu_read_release(sp)  do { } while (0)
> -
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  void cleanup_srcu_struct(struct srcu_struct *sp);
> @@ -90,11 +83,23 @@ long srcu_batches_completed(struct srcu_struct *sp);
>   * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
>   * this assumes we are in an SRCU read-side critical section unless it can
>   * prove otherwise.
> + *
> + * Note that if the CPU is in an extended quiescent state, for example,
> + * if the CPU is in dyntick-idle mode, then rcu_read_lock_held() returns
> + * false even if the CPU did an rcu_read_lock().  The reason for this is
> + * that RCU ignores CPUs that are in extended quiescent states, so such
> + * a CPU is effectively never in an RCU read-side critical section
> + * regardless of what RCU primitives it invokes.  This state of affairs
> + * is required -- RCU would otherwise need to periodically wake up
> + * dyntick-idle CPUs, which would defeat the whole purpose of dyntick-idle
> + * mode.
>   */
>  static inline int srcu_read_lock_held(struct srcu_struct *sp)
>  {
>  	if (debug_locks)
>  		return lock_is_held(&sp->dep_map);
> +	if (rcu_check_extended_qs())
> +		return 0;

Just to warn you, While rebasing this, I'm also moving things around:

	if (!debug_lock)
		return 1;

	if (rcu_is_cpu_idle())
		return 0;

	return lock_is_held(&sp->dep_map);

Otherwise we only do the check if lock debugging is disabled,
which is not what we want I think.

>  	return 1;
>  }
>  
> @@ -150,7 +155,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
>  {
>  	int retval = __srcu_read_lock(sp);
>  
> -	srcu_read_acquire(sp);
> +	rcu_lock_acquire(&(sp)->dep_map);
>  	return retval;
>  }
>  
> @@ -164,7 +169,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
>  static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
>  	__releases(sp)
>  {
> -	srcu_read_release(sp);
> +	rcu_lock_release(&(sp)->dep_map);
>  	__srcu_read_unlock(sp, idx);
>  }
>  
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
