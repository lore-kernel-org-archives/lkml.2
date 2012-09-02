Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2IBBpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 21:45:54 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38031 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab2IBBpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 21:45:53 -0400
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 18:45:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 05/23] rcu: Prevent offline CPUs from
 executing RCU core code
Message-ID: <20120902014545.GE5713@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:20AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Earlier versions of RCU invoked the RCU core from the CPU_DYING notifier
> in order to note a quiescent state for the outgoing CPU.  Because the
> CPU is marked "offline" during the execution of the CPU_DYING notifiers,
> the RCU core had to tolerate being invoked from an offline CPU.  However,
> commit b1420f1c (Make rcu_barrier() less disruptive) left only tracing
> code in the CPU_DYING notifier, so the RCU core need no longer execute
> on offline CPUs.  This commit therefore enforces this restriction.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 300aba6..84a6f55 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1892,6 +1892,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>  {
>  	struct rcu_state *rsp;
>  
> +	if (cpu_is_offline(smp_processor_id()))
> +		return;
>  	trace_rcu_utilization("Start RCU core");
>  	for_each_rcu_flavor(rsp)
>  		__rcu_process_callbacks(rsp);
> -- 
> 1.7.8
> 
