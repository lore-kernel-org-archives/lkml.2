Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0LPO0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:26:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39811 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756088Ab0LPO0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:26:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/oY+twEc3o/y6a+I4TV27Y4NJTlsYfe68TQQSvCS
	UhZ/a1zGCll8n+
Subject: Re: [patch 1/2] sched: move periodic share updates to entity_tick()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1292497423.6803.4572.camel@twins>
References: <20101216031016.186364650@google.com>
	 <20101216031038.067028969@google.com>  <1292497423.6803.4572.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 15:26:48 +0100
Message-ID: <1292509608.5532.3.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 12:03 +0100, Peter Zijlstra wrote:
> I made that:

Box is ill, I'll test these as soon as it's all better.

> ---
> Subject: sched: Move periodic share updates to entity_tick()
> From: Paul Turner <pjt@google.com>
> Date: Wed, 15 Dec 2010 19:10:17 -0800
> 
> Long running entities that do not block (dequeue) require periodic updates to
> maintain accurate share values.  (Note: group entities with several threads are
> quite likely to be non-blocking in many circumstances).
> 
> By virtue of being long-running however, we will see entity ticks (otherwise
> the required update occurs in dequeue/put and we are done).  Thus we can move
> the detection (and associated work) for these updates into the periodic path.
> 
> This restores the 'atomicity' of update_curr() with respect to accounting.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20101216031038.067028969@google.com>
> ---
>  kernel/sched_fair.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -564,10 +564,6 @@ __update_curr(struct cfs_rq *cfs_rq, str
>  
>  #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
>  	cfs_rq->load_unacc_exec_time += delta_exec;
> -	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
> -		update_cfs_load(cfs_rq, 0);
> -		update_cfs_shares(cfs_rq, 0);
> -	}
>  #endif
>  }
>  
> @@ -809,6 +805,14 @@ static void update_cfs_shares(struct cfs
>  
>  	reweight_entity(cfs_rq_of(se), se, shares);
>  }
> +
> +static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
> +{
> +	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
> +		update_cfs_load(cfs_rq, 0);
> +		update_cfs_shares(cfs_rq, 0);
> +	}
> +}
>  #else /* CONFIG_FAIR_GROUP_SCHED */
>  static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
>  {
> @@ -817,6 +821,10 @@ static void update_cfs_load(struct cfs_r
>  static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
>  {
>  }
> +
> +static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
> +{
> +}
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>  
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
> @@ -1133,6 +1141,11 @@ entity_tick(struct cfs_rq *cfs_rq, struc
>  	 */
>  	update_curr(cfs_rq);
>  
> +	/*
> +	 * Update share accounting for long-running entities.
> +	 */
> +	update_entity_shares_tick(cfs_rq);
> +
>  #ifdef CONFIG_SCHED_HRTICK
>  	/*
>  	 * queued ticks are scheduled to match the slice, so don't bother
> 


