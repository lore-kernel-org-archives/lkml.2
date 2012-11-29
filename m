Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2K2WFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:05:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38348 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2K2WFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:05:45 -0500
Date: Thu, 29 Nov 2012 14:05:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] srcu: use ACCESS_ONCE() to access sp->completed in
 srcu_read_lock()
Message-ID: <20121129220525.GD2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
 <1354178770-6028-9-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354178770-6028-9-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112922-9360-0000-0000-00000D5325C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 04:46:09PM +0800, Lai Jiangshan wrote:
> Old srcu implement requires sp->completed is loaded in
> RCU-sched(preempt_disable()) section.
> 
> The new srcu is now not RCU-sched based, it doesn't require the load of
> sp->completed and the access to counter must be in the same RCU-sched
> read site C.S., so we use ACCESS_ONCE() instead, and move it out of
> the preempt_disable() section, preempt_disable() section is only used
> for percpu data, not for RCU-sched.
> 
> The resulted code is almost as the same as before, but it helps people to
> understand the code, and it avoids to add surprise to reviewer: "why we need
> rcu_read_lock_sched_held() here?"

The first seven patches look good!

One question about this one -- the current code provided dependency
ordering between the fetch of idx and the increment, but the code after
this patch would not provide this ordering (at least not on Alpha,
and maybe also not in presence of aggressive compiler optimizations).

In the immortal words of MSDOS, "Are you sure?"

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/srcu.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index 38a762f..224400a 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -294,9 +294,8 @@ int __srcu_read_lock(struct srcu_struct *sp)
>  {
>  	int idx;
> 
> +	idx = ACCESS_ONCE(sp->completed) & 0x1;
>  	preempt_disable();
> -	idx = rcu_dereference_index_check(sp->completed,
> -					  rcu_read_lock_sched_held()) & 0x1;
>  	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
>  	smp_mb(); /* B */  /* Avoid leaking the critical section. */
>  	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
> -- 
> 1.7.4.4
> 

