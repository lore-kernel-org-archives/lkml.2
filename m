Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0ELKzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:55:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0ELKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:55:00 -0400
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on
 update_cpu_load
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <1273283329-25258-1-git-send-email-venki@google.com>
References: <1273283329-25258-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 12:54:55 +0200
Message-ID: <1273661695.1626.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 18:48 -0700, Venkatesh Pallipadi wrote:
> tickless idle has a negative side effect on update_cpu_load(),
> which in turn can affect load balancing behavior.
> 
> update_cpu_load() is supposed to be called every tick, to keep track of
> various load indicies. With tickless idle, there are no scheduler ticks called
> on the idle CPUs. Idle CPUs may still do load balancing (with idle_load_balance
> CPU) using the stale cpu_load. It will also cause problems when all CPUs go
> idle for a while and become active again. In this case loads would not degrade
> as expected.
> 
> This is how rq->nr_load_updates change looks like under different conditions:

<snip>

> That is update_cpu_load works properly only when all CPUs are busy.
> If all are idle, all the CPUs get way lower updates.
> And when few CPUs are busy and rest are idle, only busy and ilb does
> proper updates and rest of the idle CPUs will get lower updates.
> 
> The patch keeps track of when a last update was done and fixes up
> the load avg based on current time.
> 
> On one of my test system SPECjbb with warehouse 1..numcpus, patch improves
> throughput numbers by ~1% (average of 6 runs).
> On another test system (with different domain hierarchy) there is no
> noticable change in perf.

Ah, I had wondered about this aspect of nohz at one time. Nice you've
investigated and measured the performance impact.

I can largely find myself in the solution, but some comments below.

> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  kernel/sched.c      |   82 +++++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/sched_fair.c |    5 ++-
>  2 files changed, 81 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3c2a54f..0abd7db 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -502,6 +502,7 @@ struct rq {
>  	unsigned long nr_running;
>  	#define CPU_LOAD_IDX_MAX 5
>  	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
> +	unsigned long last_load_update_tick;
>  #ifdef CONFIG_NO_HZ
>  	unsigned char in_nohz_recently;
>  #endif
> @@ -1816,6 +1817,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
>  static void calc_load_account_active(struct rq *this_rq);
>  static void update_sysctl(void);
>  static int get_update_sysctl_factor(void);
> +static void update_cpu_load(struct rq *this_rq);
>  
>  static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
>  {
> @@ -3088,23 +3090,84 @@ static void calc_load_account_active(struct rq *this_rq)
>  }
>  
>  /*
> + * Load degrade calculations below are approximated on a 128 point scale.
> + * degrade_zero_ticks is the number of ticks after which old_load at any
> + * particular idx is approximated to be zero.
> + * degrade_factor is a precomputed table, a row for each load idx.
> + * Each column corresponds to degradation factor for a power of two ticks,
> + * based on 128 point scale.
> + * Example:
> + * row 2, col 3 (=12) says that the degradation at load idx 2 after
> + * 8 ticks is 12/128 (which is an approximation of 3^8/4^8).
> + */

This comment utterly forgets to explain why. Does the degradation factor
correspond with the decay otherwise used? Maybe explicitly mention that
function and clarify the whole cpu_load math.

> +#define DEGRADE_SHIFT		7
> +static const unsigned char
> +		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
> +static const unsigned char
> +		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
> +					{0, 0, 0, 0, 0, 0, 0, 0},
> +					{64, 32, 8, 0, 0, 0, 0, 0},
> +					{96, 72, 40, 12, 1, 0, 0},
> +					{112, 98, 75, 43, 15, 1, 0},
> +					{120, 112, 98, 76, 45, 16, 2} };
> +
> +/*
> + * Update cpu_load for any backlog'd ticks. The backlog would be when
> + * CPU is idle and so we just decay the old load without adding any new load.
> + */
> +static unsigned long update_backlog(unsigned long load,
> +                        unsigned long missed_updates, int idx)
> +{
> +	int j = 0;
> +
> +	if (missed_updates >= degrade_zero_ticks[idx])
> +		return 0;
> +
> +	if (idx == 1)
> +		return load >> missed_updates;
> +
> +	while (missed_updates) {
> +		if (missed_updates % 2)
> +			load =(load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
> +
> +		missed_updates >>= 1;
> +		j++;
> +	}
> +	return load;
> +}
> +
> +/*
>   * Update rq->cpu_load[] statistics. This function is usually called every
> - * scheduler tick (TICK_NSEC).
> + * scheduler tick (TICK_NSEC). With tickless idle this will not be called
> + * every tick. We fix it up based on jiffies.
>   */
>  static void update_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long this_load = this_rq->load.weight;
> +	unsigned long curr_jiffies = jiffies;
> +	unsigned long pending_updates, missed_updates;
>  	int i, scale;
>  
>  	this_rq->nr_load_updates++;
>  
> +	if (curr_jiffies == this_rq->last_load_update_tick)
> +		return;

Under which conditions can this happen? Going idle right after having
had the tick?

> +	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
> +	this_rq->last_load_update_tick = curr_jiffies;
> +	missed_updates = pending_updates - 1;
> +
>  	/* Update our load: */
> -	for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
> +	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */

Why is this special case worth it?

> +	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
>  		unsigned long old_load, new_load;
>  
>  		/* scale is effectively 1 << i now, and >> i divides by scale */
>  
>  		old_load = this_rq->cpu_load[i];
> +		if (missed_updates)
> +			old_load = update_backlog(old_load, missed_updates, i);

Would it make sense to stuff that conditional in update_backlog() and
have a clearer flow? Maybe rename update_backlog() to decay_load() or
such?


~ Peter


