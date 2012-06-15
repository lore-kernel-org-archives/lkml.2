Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2FOXcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:32:10 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40577 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2FOXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:32:07 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 16:31:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 09/15] rcu: Increasing rcu_barrier()
 concurrency
Message-ID: <20120615233151.GA7613@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-9-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-9-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:04PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The traditional rcu_barrier() implementation has serialized all requests,
> regardless of RCU flavor, and also does not coalesce concurrent requests.
> In the past, this has been good and sufficient.
> 
> However, systems are getting larger and use of rcu_barrier() has been
> increasing.  This commit therefore introduces a counter-based scheme
> that allows _rcu_barrier() calls for the same flavor of RCU to take
> advantage of each others' work.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |   27 ++++++++++++++++++++++++++-
>  kernel/rcutree.h |    2 ++
>  2 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 93358d4..7c299d3 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2291,13 +2291,32 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	unsigned long flags;
>  	struct rcu_data *rdp;
>  	struct rcu_data rd;
> +	unsigned long snap = ACCESS_ONCE(rsp->n_barrier_done);
> +	unsigned long snap_done;
>  
>  	init_rcu_head_on_stack(&rd.barrier_head);
>  
>  	/* Take mutex to serialize concurrent rcu_barrier() requests. */
>  	mutex_lock(&rsp->barrier_mutex);
>  
> -	smp_mb();  /* Prevent any prior operations from leaking in. */
> +	/*
> +	 * Ensure tht all prior references, including to ->n_barrier_done,
> +	 * are ordered before the _rcu_barrier() machinery.
> +	 */
> +	smp_mb();  /* See above block comment. */

If checkpatch complains about the lack of a comment to the right of a
barrier even when the barrier has a comment directly above it, that
seems like a bug in checkpatch that needs fixing, to prevent developers
from having to add noise like "See above block comment.". :)

Also: what type of barriers do mutex_lock and mutex_unlock imply?  I
assume they imply some weaker barrier than smp_mb, but I'd still assume
they imply *some* barrier.

> +	/* Recheck ->n_barrier_done to see if others did our work for us. */
> +	snap_done = ACCESS_ONCE(rsp->n_barrier_done);
> +	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {

This calculation seems sufficiently clever that it merits an explanatory
comment.

> +		smp_mb();
> +		mutex_unlock(&rsp->barrier_mutex);
> +		return;
> +	}
> +
> +	/* Increment ->n_barrier_done to avoid duplicate work. */
> +	ACCESS_ONCE(rsp->n_barrier_done)++;

Interesting dissonance here: the use of ACCESS_ONCE with ++ implies
exactly two accesses, rather than exactly one.  What makes it safe to
not use atomic_inc here, but not safe to drop the ACCESS_ONCE?
Potential use of a cached value read earlier in the function?

- Josh Triplett
