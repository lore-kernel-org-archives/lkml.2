Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2HaSYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:24:39 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52255 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2HaSYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:24:38 -0400
X-Originating-IP: 217.70.178.147
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:24:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
Message-ID: <20120831182429.GI4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:24AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> If a given CPU avoids the idle loop but also avoids starting a new
> RCU grace period for a full minute, RCU can issue spurious RCU CPU
> stall warnings.  This commit fixes this issue by adding a check for
> ongoing grace period to avoid these spurious stall warnings.
> 
> Reported-by: Becky Bruce <bgillbruce@gmail.com>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutree.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index fbe43b0..e58097b 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -820,7 +820,8 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
>  	j = ACCESS_ONCE(jiffies);
>  	js = ACCESS_ONCE(rsp->jiffies_stall);
>  	rnp = rdp->mynode;
> -	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
> +	if (rcu_gp_in_progress(rsp) &&
> +	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
>  
>  		/* We haven't checked in, so go dump stack. */
>  		print_cpu_stall(rsp);
> -- 
> 1.7.8
> 
