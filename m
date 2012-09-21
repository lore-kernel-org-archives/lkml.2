Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2IUDFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:05:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60821 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2IUDE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:04:27 -0400
Date: Thu, 20 Sep 2012 20:04:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dipankar@in.ibm.com
Subject: Re: [PATCH rcu] Move TINY_RCU quiescent state out of extended
 quiescent state
Message-ID: <20120921030422.GB2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1348193336.2371.76.camel@ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348193336.2371.76.camel@ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092103-5518-0000-0000-000007D1011E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:08:56AM +0800, Li Zhong wrote:
> TINY_RCU's rcu_idle_enter_common() invokes rcu_sched_qs() in order
> to inform the RCU core of the quiescent state implied by idle entry.
> Of course, idle is also an extended quiescent state, so that the call
> to rcu_sched_qs() speeds up RCU's invoking of any callbacks that might
> be queued.  This speed-up is important when entering into dyntick-idle
> mode -- if there are no further scheduling-clock interrupts, the callbacks
> might never be invoked, which could result in a system hang.
> 
> However, processing callbacks does event tracing, which in turn
> implies RCU read-side critical sections, which are illegal in extended
> quiescent states.  This patch therefore moves the call to rcu_sched_qs()
> so that it precedes the point at which we set the new value of 
> rcu_dynticks_nesting, which may indicate RCU is in an extended quiescent
> state. 

Thank you, Zhong.  Queued, as those checking the SOBs below might
guess.  ;-)

							Thanx, paul

> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutiny.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 2e073a2..e4c6a59 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -75,9 +75,9 @@ static void rcu_idle_enter_common(long long newval)
>  			  current->pid, current->comm,
>  			  idle->pid, idle->comm); /* must be idle task! */
>  	}
> +	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
>  	barrier();
>  	rcu_dynticks_nesting = newval;
> -	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
>  }
> 
>  /*
> -- 
> 1.7.9.5
> 
> 
> 

