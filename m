Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab2FOUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:25:28 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41581 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab2FOUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:25:26 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:25:11 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 3/6] rcu: Test srcu_barrier() from
 rcutorture test suite
Message-ID: <20120615202511.GC31184@leaf>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339786674-25265-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339786674-25265-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:57:51AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> SRCU now has a call_srcu() and an srcu_barrier(), but rcutorture does
> not test srcu_barrier().  This commit adds the machinery to allow
> rcutorture's existing rcu_barrier() tests to apply to SRCU.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This commit message suggests that the commit only adds support for
testing srcu_barrier, but it adds both call_srcu and srcu_barrier.  You
might want to wordsmith it a bit:

SRCU now has a call_srcu() and an srcu_barrier(), but rcutorture does
not test them.  This commit adds the machinery to allow rcutorture's
existing tests for call_rcu() and rcu_barrier() to apply to the SRCU
equivalents.

With that change:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutorture.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 9850479..7b6935e 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -635,6 +635,17 @@ static void srcu_torture_synchronize(void)
>  	synchronize_srcu(&srcu_ctl);
>  }
>  
> +static void srcu_torture_call(struct rcu_head *head,
> +			      void (*func)(struct rcu_head *head))
> +{
> +	call_srcu(&srcu_ctl, head, func);
> +}
> +
> +static void srcu_torture_barrier(void)
> +{
> +	srcu_barrier(&srcu_ctl);
> +}
> +
>  static int srcu_torture_stats(char *page)
>  {
>  	int cnt = 0;
> @@ -661,8 +672,8 @@ static struct rcu_torture_ops srcu_ops = {
>  	.completed	= srcu_torture_completed,
>  	.deferred_free	= srcu_torture_deferred_free,
>  	.sync		= srcu_torture_synchronize,
> -	.call		= NULL,
> -	.cb_barrier	= NULL,
> +	.call		= srcu_torture_call,
> +	.cb_barrier	= srcu_torture_barrier,
>  	.stats		= srcu_torture_stats,
>  	.name		= "srcu"
>  };
> -- 
> 1.7.8
> 
