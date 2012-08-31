Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2HaSvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:51:51 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51561 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2HaSvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:51:50 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:51:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 14/15] time: RCU permitted to stop idle
 entry via softirq
Message-ID: <20120831185141.GN4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-14-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-14-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:27AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The can_stop_idle_tick() function complains if a softirq vector is
> raised too late in the idle-entry process, presumably in order to
> prevent dangling softirq invocations from being delayed across the
> full idle period, which might be indefinitely long -- and if softirq
> was asserted any later than the call to this function, such a delay
> might well happen.
> 
> However, RCU needs to be able to use softirq to stop idle entry in
> order to be able to drain RCU callbacks from the current CPU, which in
> turn enables faster entry into dyntick-idle mode, which in turn reduces
> power consumption.  Because RCU takes this action at a well-defined
> point in the idle-entry path, it is safe for RCU to take this approach.
> 
> This commit therefore silences the error message that is sometimes
> produced when the going-idle CPU suddenly finds that it has an RCU_SOFTIRQ
> to process.  The error message will continue to be issued for other
> softirq vectors.
> 
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  include/linux/interrupt.h |    2 ++
>  kernel/time/tick-sched.c  |    3 ++-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index c5f856a..5e4e617 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -430,6 +430,8 @@ enum
>  	NR_SOFTIRQS
>  };
>  
> +#define SOFTIRQ_STOP_IDLE_MASK (~(1 << RCU_SOFTIRQ))
> +
>  /* map softirq index to softirq name. update 'softirq_to_name' in
>   * kernel/softirq.c when adding a new softirq.
>   */
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 024540f..4b1785a 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -436,7 +436,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
>  		static int ratelimit;
>  
> -		if (ratelimit < 10) {
> +		if (ratelimit < 10 &&
> +		    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
>  			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
>  			       (unsigned int) local_softirq_pending());
>  			ratelimit++;
> -- 
> 1.7.8
> 
