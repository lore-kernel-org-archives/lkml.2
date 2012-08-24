Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2HXIfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:35:18 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55806 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2HXIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:35:12 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-3a-50373cbdc9a3
From: Namhyung Kim <namhyung@kernel.org>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 14/16] sched: make __update_entity_runnable_avg() fast
References: <20120823141422.444396696@google.com>
	<20120823141507.277808946@google.com>
Date: Fri, 24 Aug 2012 17:28:33 +0900
In-Reply-To: <20120823141507.277808946@google.com> (pjt@google.com's message
	of "Thu, 23 Aug 2012 07:14:36 -0700")
Message-ID: <87fw7chexa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012 07:14:36 -0700, > From: Paul Turner <pjt@google.com>
>
> __update_entity_runnable_avg forms the core of maintaining an entity's runnable
> load average.  In this function we charge the accumulated run-time since last
> update and handle appropriate decay.  In some cases, e.g. a waking task, this
> time interval may be much larger than our period unit.
>
> Fortunately we can exploit some properties of our series to perform decay for a
> blocked update in constant time and account the contribution for a running
> update in essentially-constant* time.
>
> [*]: For any running entity they should be performing updates at the tick which
> gives us a soft limit of 1 jiffy between updates, and we can compute up to a
> 32 jiffy update in a single pass.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> Reviewed-by: Ben Segall <bsegall@google.com>
> ---
>  kernel/sched/fair.c |  123 +++++++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 99 insertions(+), 24 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 12e9ae5..b249371 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -879,17 +879,90 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
>  
>  #ifdef CONFIG_SMP
>  /*
> + * We choose a half-life close to 1 scheduling period.
> + * Note: The tables below are dependent on this value.
> + */
> +#define LOAD_AVG_PERIOD 32
> +#define LOAD_AVG_MAX 47765 /* maximum possible load avg */
> +#define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
> +
> +/* Precomputed fixed inverse multiplies for multiplication by y^n */
> +static const u32 runnable_avg_yN_inv[] = {
> +	0xffffffff, 0xfa83b2da, 0xf5257d14, 0xefe4b99a, 0xeac0c6e6, 0xe5b906e6,
> +	0xe0ccdeeb, 0xdbfbb796, 0xd744fcc9, 0xd2a81d91, 0xce248c14, 0xc9b9bd85,
> +	0xc5672a10, 0xc12c4cc9, 0xbd08a39e, 0xb8fbaf46, 0xb504f333, 0xb123f581,
> +	0xad583ee9, 0xa9a15ab4, 0xa5fed6a9, 0xa2704302, 0x9ef5325f, 0x9b8d39b9,
> +	0x9837f050, 0x94f4efa8, 0x91c3d373, 0x8ea4398a, 0x8b95c1e3, 0x88980e80,
> +	0x85aac367, 0x82cd8698,
> +};
> +
> +/*
> + * Precomputed \Sum y^k { 1<=k<=n }.  These are floor(true_value) to prevent
> + * over-estimates when re-combining.
> + */
> +static const u32 runnable_avg_yN_sum[] = {
> +	    0, 1002, 1982, 2941, 3880, 4798, 5697, 6576, 7437, 8279, 9103,
> +	 9909,10698,11470,12226,12966,13690,14398,15091,15769,16433,17082,
> +	17718,18340,18949,19545,20128,20698,21256,21802,22336,22859,23371,
> +};
> +
> +/*
>   * Approximate:
>   *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
>   */
>  static __always_inline u64 decay_load(u64 val, u64 n)
>  {
> -	for (; n && val; n--) {
> -		val *= 4008;
> -		val >>= 12;
> +	int local_n;
> +	if (!n)
> +		return val;
> +	else if (unlikely(n > LOAD_AVG_PERIOD * 63))
> +		return 0;
> +
> +	/* will be 32 bits if that's desirable */
> +	local_n = n;
> +
> +	/*
> +	 * As y^PERIOD = 1/2, we can combine
> +	 *    y^n = 1/2^(n/PERIOD) * k^(n%PERIOD)
> +	 * With a look-up table which covers k^n (n<PERIOD)
> +	 *
> +	 * To achieve constant time decay_load.
> +	 */
> +	if (unlikely(local_n >= LOAD_AVG_PERIOD)) {
> +		val >>= local_n / LOAD_AVG_PERIOD;
> +		n %= LOAD_AVG_PERIOD;

s/n/local_n/ ?

Thanks,
Namhyung


>  	}
>  
> -	return val;
> +	val *= runnable_avg_yN_inv[local_n];
> +	return SRR(val, 32);
> +}
> +
> +/*
> + * For updates fully spanning n periods, the contribution to runnable
> + * average will be: \Sum 1024*y^n
> + *
> + * We can compute this reasonably efficiently by combining:
> + *   y^PERIOD = 1/2 with precomputed \Sum 1024*y^n {for  n <PERIOD}
> + */
> +static u32 __compute_runnable_contrib(u64 n)
> +{
> +	u32 contrib = 0;
> +
> +	if (likely(n <= LOAD_AVG_PERIOD))
> +		return runnable_avg_yN_sum[n];
> +	else if (unlikely(n >= LOAD_AVG_MAX_N))
> +		return LOAD_AVG_MAX;
> +
> +	/* Compute \Sum k^n combining precomputed values for k^i, \Sum k^j */
> +	do {
> +		contrib /= 2; /* y^LOAD_AVG_PERIOD = 1/2 */
> +		contrib += runnable_avg_yN_sum[LOAD_AVG_PERIOD];
> +
> +		n -= LOAD_AVG_PERIOD;
> +	} while (n > LOAD_AVG_PERIOD);
> +
> +	contrib = decay_load(contrib, n);
> +	return contrib + runnable_avg_yN_sum[n];
>  }
>  
>  /* We can represent the historical contribution to runnable average as the
> @@ -923,7 +996,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>  							struct sched_avg *sa,
>  							int runnable)
>  {
> -	u64 delta;
> +	u64 delta, periods;
> +	u32 runnable_contrib;
>  	int delta_w, decayed = 0;
>  
>  	delta = now - sa->last_runnable_update;
> @@ -957,25 +1031,26 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>  		 * period and accrue it.
>  		 */
>  		delta_w = 1024 - delta_w;
> -		BUG_ON(delta_w > delta);
> -		do {
> -			if (runnable)
> -				sa->runnable_avg_sum += delta_w;
> -			sa->runnable_avg_period += delta_w;
> -
> -			/*
> -			 * Remainder of delta initiates a new period, roll over
> -			 * the previous.
> -			 */
> -			sa->runnable_avg_sum =
> -				decay_load(sa->runnable_avg_sum, 1);
> -			sa->runnable_avg_period =
> -				decay_load(sa->runnable_avg_period, 1);
> -
> -			delta -= delta_w;
> -			/* New period is empty */
> -			delta_w = 1024;
> -		} while (delta >= 1024);
> +		if (runnable)
> +			sa->runnable_avg_sum += delta_w;
> +		sa->runnable_avg_period += delta_w;
> +
> +		delta -= delta_w;
> +
> +		/* Figure out how many additional periods this update spans */
> +		periods = delta / 1024;
> +		delta %= 1024;
> +
> +		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
> +						  periods + 1);
> +		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
> +						     periods + 1);
> +
> +		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
> +		runnable_contrib = __compute_runnable_contrib(periods);
> +		if (runnable)
> +			sa->runnable_avg_sum += runnable_contrib;
> +		sa->runnable_avg_period += runnable_contrib;
>  	}
>  
>  	/* Remainder of delta accrued against u_0` */
