Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1EFHAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:00:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44970 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1EFHAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:00:15 -0400
Date: Fri, 6 May 2011 08:59:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
Message-ID: <20110506065959.GB23166@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu>
 <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu>
 <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikhil Rao <ncrao@google.com> wrote:

> On Wed, May 4, 2011 at 4:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Nikhil Rao <ncrao@google.com> wrote:
> >
> >> Also, out of curiosity, what's an acceptable tolerance level for a 
> >> performance hit on 32-bit?
> >
> > It's a cost/benefit analysis and for 32-bit systems the benefits seem to be 
> > rather small, right?
> 
> Yes, that's right. The benefits for 32-bit systems do seem to be limited.
> 
> When I initially posted this patchset, I expected much larger benefits for 
> 32-bit systems. I ran some experiments yesterday and found negligible gains 
> for 32-bit systems. I think two aspects of this patchset are relevant for 
> 32-bit:
> 
> 1. Better distribution of weight for low-weight task groups. For example, 
> when an autogroup gets niced to +19, the task group is assigned a weight of 
> 15. Since 32-bit systems are only restricted to 8 cpus at most, I think we 
> can manage to handle this case without the need for more resolution. The 
> results for this experiment were not statistically significant.
> 
> 2. You could also run out of resolution with deep hierarchies on 32-bit 
> systems, but you need pretty complex cgroup hierarchies. Let's assume you 
> have a hierarchy with n levels and a branching factor of b at each level. 
> Let's also assume each leaf node has at least one running task and users 
> don't change any of the weights. You will need approx log_b(1024/NR_CPUS) 
> levels to run out of resolution in this setup... so, b=2 needs 7 levels, b=3 
> needs 5 levels, b=4 needs 4 levels, ... and so on. These are a pretty 
> elaborate hierarchy and I'm not sure if there are use cases for these (yet!).

Btw., the "take your patch" and "do not take your patch" choice is a false 
dichotomy, there's a third option we should consider seriously: we do not *have 
to* act for 32-bit systems, if we decide that the benefits are not clear yet.

I.e. we can act on 64-bit systems (there increasing resolution should be near 
zero cost as we have 64-bit ops), but delay any decision for 32-bit systems.

If 32-bit systems evolve in a direction (lots of cores, lots of cgroups 
complexity) that makes the increase in resolution inevitable, we can 
reconsider.

If on the other hand they are replaced more and more by 64-bit systems in all 
segments and become a niche then not acting will be the right decision. There's 
so many other reasons why 64-bit is better, better resolution and more 
scheduling precision in highly parallel systems/setups will just be another 
reason.

Personally i think this latter scenario is a lot more likely.

> > Can we make the increase in resolution dependent on max CPU count or such 
> > and use cheaper divides on 32-bit in that case, while still keeping the 
> > code clean?
> 
> Sure. Is this what you had in mind?

Yes, almost:

> commit 860030069190e3d6e1983cc77c936f7ccdaf7cff
> Author: Nikhil Rao <ncrao@google.com>
> Date:   Mon Apr 11 15:16:08 2011 -0700
> 
>     sched: increase SCHED_LOAD_SCALE resolution
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8d1ff2b..f92353c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -794,7 +794,21 @@ enum cpu_idle_type {
>  /*
>   * Increase resolution of nice-level calculations:
>   */
> -#define SCHED_LOAD_SHIFT	10
> +#if CONFIG_NR_CPUS > 32
> +#define SCHED_LOAD_RESOLUTION	10
> +
> +#define scale_up_load_resolution(w)	w << SCHED_LOAD_RESOLUTION
> +#define scale_down_load_resolution(w)	w >> SCHED_LOAD_RESOLUTION;
> +
> +#else
> +#define SCHED_LOAD_RESOLUTION	0
> +
> +#define scale_up_load_resolution(w)	w
> +#define scale_down_load_resolution(w)	w
> +
> +#endif
> +
> +#define SCHED_LOAD_SHIFT	(10 + (SCHED_LOAD_RESOLUTION))
>  #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)

I'd suggest to make the resolution dependent on BITS_PER_LONG. That way we have 
just two basic variants of resolution (CONFIG_NR_CPUS can vary a lot). This 
will be a *lot* more testable, and on 32-bit we will maintain the status quo.

But yes, look at how much nicer the patch looks like now.

A few small comments:

> diff --git a/kernel/sched.c b/kernel/sched.c
> index f4b4679..3dae6c5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
>   *  limitation from this.)
>   */
>  #define MIN_SHARES	2
> -#define MAX_SHARES	(1UL << 18)
> +#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
> 
>  static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
>  #endif
> @@ -1307,14 +1307,18 @@ calc_delta_mine(unsigned long delta_exec, u64
> weight, struct load_weight *lw)
>  	u64 tmp;
> 
>  	if (!lw->inv_weight) {
> -		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
> +		unsigned long w = scale_down_load_resolution(lw->weight);
> +		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
>  			lw->inv_weight = 1;
>  		else
> -			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
> -				/ (lw->weight+1);
> +			lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
>  	}
> 
> -	tmp = (u64)delta_exec * weight;
> +	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
> +		tmp = (u64)delta_exec * scale_down_load_resolution(weight);
> +	else
> +		tmp = (u64)delta_exec;

Couldnt the compiler figure out that on 32-bit, this:

> +		tmp = (u64)delta_exec * scale_down_load_resolution(weight);

is equivalent to:

> +		tmp = (u64)delta_exec;

?

I.e. it would be nice to check whether a reasonably recent version of GCC 
figures out this optimization by itself - in that case we can avoid the 
branching ugliness, right?

Also, the above (and the other scale-adjustment changes) probably explains why 
the instruction count went up on 64-bit.

> @@ -1758,12 +1762,13 @@ static void set_load_weight(struct task_struct *p)
>  	 * SCHED_IDLE tasks get minimal weight:
>  	 */
>  	if (p->policy == SCHED_IDLE) {
> -		p->se.load.weight = WEIGHT_IDLEPRIO;
> +		p->se.load.weight = scale_up_load_resolution(WEIGHT_IDLEPRIO);
>  		p->se.load.inv_weight = WMULT_IDLEPRIO;
>  		return;
>  	}
> 
> -	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
> +	p->se.load.weight = scale_up_load_resolution(
> +			prio_to_weight[p->static_prio - MAX_RT_PRIO]);
>  	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];

Please create a local 'load' variable that is equal to &p->se.load, and also
create a 'prio = p->static_prio - MAX_RT_PRIO' variable.

Furthermore, please rename 'scale_up_load_resolution' to something shorter: 
scale_load() is not used within the scheduler yet so it's free for taking.

Then a lot of the above repetitious code could be written as a much nicer:

	load->weight = scale_load(prio_to_weight[prio]);
  	load->inv_weight = prio_to_wmult[prio];

... and the logic becomes a *lot* more readable and the ugly linebreak is gone 
as well.

Please make such a set_load_weight() cleanup patch separate from the main 
patch, so that your main patch can still be reviewed in separation.

Thanks,

	Ingo
