Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0DGQpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:45:45 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:53943 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932798Ab0DGQpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:45:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD9SvEtGGOL4/2dsb2JhbACbIXK8RYJjgiYE
Date: Wed, 7 Apr 2010 12:45:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and
	rcu_dereference_protected
Message-ID: <20100407164542.GB21378@Krystal>
References: <20100407162620.GA11543@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100407162620.GA11543@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:44:44 up  2:38,  1 user,  load average: 0.04, 0.06, 0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> This patch adds variants of rcu_dereference() that handle situations
> where the RCU-protected data structure cannot change, perhaps due to
> our holding the update-side lock, or where the RCU-protected pointer is
> only to be fetched, not dereferenced.  These are needed due to some
> performance concerns with using rcu_dereference() where it is not
> required, aside from the need for lockdep/sparse checking.
> 
> The new rcu_access_pointer() primitive is for the case where the pointer
> is be fetch and not dereferenced.  This primitive may be used without
> protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().
> 
> The new rcu_dereference_protected() primitive is for the case where updates
> are prevented, for example, due to holding the update-side lock.  This
> primitive does neither ACCESS_ONCE() nor smp_read_barrier_depends(), so
> can only be used when updates are somehow prevented.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

We should probably pull this in liburcu eventually too (renaming
ACCESS_ONCE() into LOAD_SHARED()).

Thanks,

Mathieu

> 
>  rcupdate.h |   38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 872a98e..3f06b3d 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -209,9 +209,47 @@ static inline int rcu_read_lock_sched_held(void)
>  		rcu_dereference_raw(p); \
>  	})
>  
> +/**
> + * rcu_access_pointer - fetch RCU pointer with no dereferencing
> + *
> + * Return the value of the specified RCU-protected pointer, but omit the
> + * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
> + * when the value of this pointer is accessed, but the pointer is not
> + * dereferenced, for example, when testing an RCU-protected pointer against
> + * NULL.  This may also be used in cases where update-side locks prevent
> + * the value of the pointer from changing, but rcu_dereference_protected()
> + * is a lighter-weight primitive for this use case.
> + */
> +#define rcu_access_pointer(p, c) \
> +	({ \
> +		if (debug_lockdep_rcu_enabled() && !(c)) \
> +			lockdep_rcu_dereference(__FILE__, __LINE__); \
> +		ACCESS_ONCE(p); \
> +	})
> +
> +/**
> + * rcu_dereference_protected - fetch RCU pointer when updates prevented
> + *
> + * Return the value of the specified RCU-protected pointer, but omit
> + * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
> + * is useful in cases where update-side locks prevent the value of the
> + * pointer from changing.  Please note that this primitive does -not-
> + * prevent the compiler from repeating this reference or combining it
> + * with other references, so it should not be used without protection
> + * of appropriate locks.
> + */
> +#define rcu_dereference_protected(p, c) \
> +	({ \
> +		if (debug_lockdep_rcu_enabled() && !(c)) \
> +			lockdep_rcu_dereference(__FILE__, __LINE__); \
> +		(p); \
> +	})
> +
>  #else /* #ifdef CONFIG_PROVE_RCU */
>  
>  #define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
> +#define rcu_access_pointer(p, c)	ACCESS_ONCE(p)
> +#define rcu_dereference_protected(p, c) (p)
>  
>  #endif /* #else #ifdef CONFIG_PROVE_RCU */
>  

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
