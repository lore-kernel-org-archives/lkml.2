Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2JLTGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:06:54 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41896 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2JLTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:06:52 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 173.246.103.110
Date: Fri, 12 Oct 2012 12:06:45 -0700
From: Josh Triplett <josh@freedesktop.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] rcutorture: use DEFINE_STATIC_SRCU()
Message-ID: <20121012190645.GA4134@jtriplet-mobl1>
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
 <1350062057-2439-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350062057-2439-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 01:14:17AM +0800, Lai Jiangshan wrote:
> use DEFINE_STATIC_SRCU() to simplify the rcutorture.c
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutorture.c |   41 ++++++-----------------------------------
>  1 files changed, 6 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 25b1503..7939edf 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -332,7 +332,6 @@ rcu_stutter_wait(char *title)
>  
>  struct rcu_torture_ops {
>  	void (*init)(void);
> -	void (*cleanup)(void);
>  	int (*readlock)(void);
>  	void (*read_delay)(struct rcu_random_state *rrsp);
>  	void (*readunlock)(int idx);
> @@ -424,7 +423,6 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
>  
>  static struct rcu_torture_ops rcu_ops = {
>  	.init		= NULL,
> -	.cleanup	= NULL,
>  	.readlock	= rcu_torture_read_lock,
>  	.read_delay	= rcu_read_delay,
>  	.readunlock	= rcu_torture_read_unlock,
> @@ -468,7 +466,6 @@ static void rcu_sync_torture_init(void)
>  
>  static struct rcu_torture_ops rcu_sync_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= rcu_torture_read_lock,
>  	.read_delay	= rcu_read_delay,
>  	.readunlock	= rcu_torture_read_unlock,
> @@ -486,7 +483,6 @@ static struct rcu_torture_ops rcu_sync_ops = {
>  
>  static struct rcu_torture_ops rcu_expedited_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= rcu_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= rcu_torture_read_unlock,
> @@ -529,7 +525,6 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
>  
>  static struct rcu_torture_ops rcu_bh_ops = {
>  	.init		= NULL,
> -	.cleanup	= NULL,
>  	.readlock	= rcu_bh_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= rcu_bh_torture_read_unlock,
> @@ -546,7 +541,6 @@ static struct rcu_torture_ops rcu_bh_ops = {
>  
>  static struct rcu_torture_ops rcu_bh_sync_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= rcu_bh_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= rcu_bh_torture_read_unlock,
> @@ -563,7 +557,6 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
>  
>  static struct rcu_torture_ops rcu_bh_expedited_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= rcu_bh_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= rcu_bh_torture_read_unlock,
> @@ -582,19 +575,7 @@ static struct rcu_torture_ops rcu_bh_expedited_ops = {
>   * Definitions for srcu torture testing.
>   */
>  
> -static struct srcu_struct srcu_ctl;
> -
> -static void srcu_torture_init(void)
> -{
> -	init_srcu_struct(&srcu_ctl);
> -	rcu_sync_torture_init();
> -}
> -
> -static void srcu_torture_cleanup(void)
> -{
> -	synchronize_srcu(&srcu_ctl);
> -	cleanup_srcu_struct(&srcu_ctl);
> -}
> +DEFINE_STATIC_SRCU(srcu_ctl);
>  
>  static int srcu_torture_read_lock(void) __acquires(&srcu_ctl)
>  {
> @@ -665,8 +646,7 @@ static int srcu_torture_stats(char *page)
>  }
>  
>  static struct rcu_torture_ops srcu_ops = {
> -	.init		= srcu_torture_init,
> -	.cleanup	= srcu_torture_cleanup,
> +	.init		= rcu_sync_torture_init,
>  	.readlock	= srcu_torture_read_lock,
>  	.read_delay	= srcu_read_delay,
>  	.readunlock	= srcu_torture_read_unlock,
> @@ -680,8 +660,7 @@ static struct rcu_torture_ops srcu_ops = {
>  };
>  
>  static struct rcu_torture_ops srcu_sync_ops = {
> -	.init		= srcu_torture_init,
> -	.cleanup	= srcu_torture_cleanup,
> +	.init		= rcu_sync_torture_init,
>  	.readlock	= srcu_torture_read_lock,
>  	.read_delay	= srcu_read_delay,
>  	.readunlock	= srcu_torture_read_unlock,
> @@ -705,8 +684,7 @@ static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
>  }
>  
>  static struct rcu_torture_ops srcu_raw_ops = {
> -	.init		= srcu_torture_init,
> -	.cleanup	= srcu_torture_cleanup,
> +	.init		= rcu_sync_torture_init,
>  	.readlock	= srcu_torture_read_lock_raw,
>  	.read_delay	= srcu_read_delay,
>  	.readunlock	= srcu_torture_read_unlock_raw,
> @@ -720,8 +698,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
>  };
>  
>  static struct rcu_torture_ops srcu_raw_sync_ops = {
> -	.init		= srcu_torture_init,
> -	.cleanup	= srcu_torture_cleanup,
> +	.init		= rcu_sync_torture_init,
>  	.readlock	= srcu_torture_read_lock_raw,
>  	.read_delay	= srcu_read_delay,
>  	.readunlock	= srcu_torture_read_unlock_raw,
> @@ -740,8 +717,7 @@ static void srcu_torture_synchronize_expedited(void)
>  }
>  
>  static struct rcu_torture_ops srcu_expedited_ops = {
> -	.init		= srcu_torture_init,
> -	.cleanup	= srcu_torture_cleanup,
> +	.init		= rcu_sync_torture_init,
>  	.readlock	= srcu_torture_read_lock,
>  	.read_delay	= srcu_read_delay,
>  	.readunlock	= srcu_torture_read_unlock,
> @@ -776,7 +752,6 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
>  
>  static struct rcu_torture_ops sched_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= sched_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= sched_torture_read_unlock,
> @@ -792,7 +767,6 @@ static struct rcu_torture_ops sched_ops = {
>  
>  static struct rcu_torture_ops sched_sync_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= sched_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= sched_torture_read_unlock,
> @@ -807,7 +781,6 @@ static struct rcu_torture_ops sched_sync_ops = {
>  
>  static struct rcu_torture_ops sched_expedited_ops = {
>  	.init		= rcu_sync_torture_init,
> -	.cleanup	= NULL,
>  	.readlock	= sched_torture_read_lock,
>  	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
>  	.readunlock	= sched_torture_read_unlock,
> @@ -1903,8 +1876,6 @@ rcu_torture_cleanup(void)
>  
>  	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
>  
> -	if (cur_ops->cleanup)
> -		cur_ops->cleanup();
>  	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
>  		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
>  	else if (n_online_successes != n_online_attempts ||
> -- 
> 1.7.7.6
> 
