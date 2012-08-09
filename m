Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab2HIV5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab2HIV5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:57:46 -0400
Date: Thu, 9 Aug 2012 23:57:26 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] sched, numa: Per task memory placement for big
 processes
Message-ID: <20120809215725.GL10459@redhat.com>
References: <20120731191204.540691987@chello.nl>
 <20120731192809.428855038@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731192809.428855038@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:12:22PM +0200, Peter Zijlstra wrote:
> Implement a per-task memory placement scheme for 'big' tasks (as per
> the last patch). It relies on a regular PROT_NONE 'migration' fault to
> scan the memory space of the procress and uses a two stage migration
> scheme to reduce the invluence of unlikely usage relations.
> 
> It relies on the assumption that the compute part is tied to a
> paticular task and builds a task<->page relation set to model the
> compute<->data relation.
> 
> Probability says that the task faulting on a page after we protect it,
> is most likely to be the task that uses that page most.
> 
> To decrease the likelyhood of acting on a false relation, we only

Do you prefer me to use the term false relation instead of false
sharing too? I never was fond of the term false sharing even though at
the NUMA level it resembles the cache effects.

> migrate a page when two consecutive samples are from the same task.
> 
> I'm still not entirely convinced this scheme is sound, esp. for things
> like virtualization and n:m threading solutions in general the
> compute<->task relation is fundamentally untrue.

To make it true, virt requires AutoNUMA or hard bindings the guest too
and just a fake vtopology matching the hardware topology. Anyway we
can discuss that later, it's not the primary topic here.

> + *
> + * Once we start doing NUMA placement there's two modes, 'small' process-wide
> + * and 'big' per-task. For the small mode we have a process-wide home node
> + * and lazily mirgrate all memory only when this home-node changes.
> + *
> + * For big mode we keep a home-node per task and use periodic fault scans
> + * to try and estalish a task<->page relation. This assumes the task<->page
> + * relation is a compute<->data relation, this is false for things like virt.
> + * and n:m threading solutions but its the best we can do given the
> + * information we have.

Differentiating the way you migrate the memory between small and big
tasks looks really bad and a major band aid. It is only needed because
the small mode is too broken to be used on big tasks, and the big mode
provides too bad performance.

> +	if (big) {
> +		/*
> +		 * For 'big' processes we do per-thread home-node, combined
> +		 * with periodic fault scans.
> +		 */
> +		if (p->node != node)
> +			sched_setnode(p, node);
> +	} else {
> +		/*
> +		 * For 'small' processes we keep the entire process on a
> +		 * node and migrate all memory once.
> +		 */
> +		rcu_read_lock();
> +		t = p;
> +		do {
> +			sched_setnode(t, node);
> +		} while ((t = next_thread(p)) != p);
> +		rcu_read_unlock();
> +	}

The small mode tries to do the right thing, except expressed like
above is so bad and fixed in stone and can't work ok in all possible
scenarios (hence you can't use it for big tasks).

AutoNUMA only uses the "small" mode, but it does in a way that works
perfectly for big tasks too. This is the relevant documentation on how
the CPU follow memory algorithm of AutoNUMA sorts out the very above
problem in an optimal way that doesn't require small/big
classifications or other hacks like that:

 * One important thing is how we calculate the weights using
 * task_autonuma or mm_autonuma, depending if the other CPU is running
 * a thread of the current process, or a thread of a different
 * process.
 *
 * We use the mm_autonuma statistics to calculate the NUMA weights of
 * the two task candidate for exchange, if the task in the other CPU
 * belongs to a different processes. This way all threads of the same
 * process will try to converge in the same "mm" best nodes if their
 * "thread local" best CPU is already busy by a thread of a different
 * process. This is important because with threads, there is always
 * the possibility of NUMA false sharing, and so it's better to
 * converge all threads in as fewer nodes as possible.

Your approach will never work ok on large systems, unless all tasks
are of the small kind of course.

At least now you introduced the autonuma_last_nid numa hinting page
fault confirmation before starting the migration to mitigate the
bad behavior of the big mode for big tasks.

> +	/*
> +	 * Trigger fault driven migration, small processes do direct
> +	 * lazy migration, big processes do gradual task<->page relations.
> +	 * See mpol_misplaced().
> +	 */
>  	lazy_migrate_process(p->mm);

The comment should go in prev patch that introduced the call to
lazy_migrate_process not here, bad splitup.

> +	/*
> +	 * Multi-stage node selection is used in conjunction with a periodic
> +	 * migration fault to build a temporal task<->page relation. By
> +	 * using a two-stage filter we remove short/unlikely relations.
> +	 *
> +	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can
> +	 * equate a task's usage of a particular page (n_p) per total usage
> +	 * of this page (n_t) (in a given time-span) to a probability.
> +	 *
> +	 * Our periodic faults will then sample this probability and getting
> +	 * the same result twice in a row, given these samples are fully
> +	 * independent, is then given by P(n)^2, provided our sample period
> +	 * is sufficiently short compared to the usage pattern.
> +	 *
> +	 * This quadric squishes small probabilities, making it less likely
> +	 * we act on an unlikely task<->page relation.
> +	 *
> +	 * NOTE: effectively we're using task-home-node<->page-node relations
> +	 * since those are the only thing we can affect.
> +	 *
> +	 * NOTE: we're using task-home-node as opposed to the current node
> +	 * the task might be running on, since the task-home-node is the
> +	 * long-term node of this task, further reducing noise. Also see
> +	 * task_tick_numa().
> +	 */
> +	if (multi && (pol->flags & MPOL_F_HOME)) {
> +		if (page->nid_last != polnid) {
> +			page->nid_last = polnid;
> +			goto out;
> +		}
> +	}
> +

Great to see we agree on the autonuma_last_nid logic now that you
included it into sched-numa, so finally sched-numa also has a
task<->page relation. You also wrote the math to explain it! I hope if
you don't mind if I copy the above math in the comment above.

I just seen you posted a patch to remove the 8 bytes per page and
return to zero cost by dropping 32bit support, but it was still
interesting to see sched-numa for the first time using 8 bytes per
page unconditionally! (autonuma currently uses 12 per page but only on
NUMA hardware and zero on non-NUMA, and it works on 32bit archs too
with the same 12byte cost)

> @@ -2421,7 +2456,7 @@ void __init numa_policy_init(void)
>  		preferred_node_policy[nid] = (struct mempolicy) {
>  			.refcnt = ATOMIC_INIT(1),
>  			.mode = MPOL_PREFERRED,
> -			.flags = MPOL_F_MOF,
> +			.flags = MPOL_F_MOF | MPOL_F_HOME,
>  			.v = { .preferred_node = nid, },
>  		};
>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
