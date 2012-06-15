Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2FOVFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:05:04 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38983 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab2FOVFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:05:02 -0400
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 14:04:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 12/14] rcu: Prevent __call_rcu() from
 invoking RCU core on offline CPUs
Message-ID: <20120615210444.GP31184@leaf>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-12-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339791195-26389-12-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:13:13PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The __call_rcu() function will invoke the RCU core, for example, if
> it detects that the current CPU has too many callbacks.  However, this
> can happen on an offline CPU that is on its way to the idle loop, in
> which case it is an error to invoke the RCU core, and the excess callbacks
> will be adopted in any case.  This commit therefore adds checks to
> __call_rcu() for running on an offline CPU, refraining from invoking
> the RCU core in this case.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 7720177..9419ebf 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1901,11 +1901,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
>  	 * If called from an extended quiescent state, invoke the RCU
>  	 * core in order to force a re-evaluation of RCU's idleness.
>  	 */
> -	if (rcu_is_cpu_idle())
> +	if (rcu_is_cpu_idle() && cpu_online(smp_processor_id()))
>  		invoke_rcu_core();
>  
> -	/* If interrupts were disabled, don't dive into RCU core. */
> -	if (irqs_disabled_flags(flags)) {
> +	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
> +	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id())) {
>  		local_irq_restore(flags);
>  		return;
>  	}
> -- 
> 1.7.8
> 
