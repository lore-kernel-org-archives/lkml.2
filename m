Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2ICJmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:42:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45406 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2ICJmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:42:11 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:42:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 19/23] rcu: Adjust for unconditional
 ->completed assignment
Message-ID: <20120903094203.GH5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-19-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-19-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:34AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Now that the rcu_node structures' ->completed fields are unconditionally
> assigned at grace-period cleanup time, they should already have the
> correct value for the new grace period at grace-period initialization
> time.  This commit therefore inserts a WARN_ON_ONCE() to verify this
> invariant.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 1373388..86903df 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1098,6 +1098,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  		rcu_preempt_check_blocked_tasks(rnp);
>  		rnp->qsmask = rnp->qsmaskinit;
>  		rnp->gpnum = rsp->gpnum;
> +		WARN_ON_ONCE(rnp->completed != rsp->completed);
>  		rnp->completed = rsp->completed;
>  		if (rnp == rdp->mynode)
>  			rcu_start_gp_per_cpu(rsp, rnp, rdp);
> @@ -2795,7 +2796,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
>  			raw_spin_lock_init(&rnp->fqslock);
>  			lockdep_set_class_and_name(&rnp->fqslock,
>  						   &rcu_fqs_class[i], fqs[i]);
> -			rnp->gpnum = 0;
> +			rnp->gpnum = rsp->gpnum;
> +			rnp->completed = rsp->completed;
>  			rnp->qsmask = 0;
>  			rnp->qsmaskinit = 0;
>  			rnp->grplo = j * cpustride;
> -- 
> 1.7.8
> 
