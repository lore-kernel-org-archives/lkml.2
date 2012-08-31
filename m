Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2HaXz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:55:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54189 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2HaXzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:55:54 -0400
X-Originating-IP: 217.70.178.152
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:55:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH tip/core/rcu 15/26] alpha: Fix preemption handling in
 idle loop
Message-ID: <20120831235546.GL11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-15-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-15-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:32PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> cpu_idle() is called on the boot CPU by the init code with
> preemption disabled. But the cpu_idle() function in alpha
> doesn't handle this when it calls schedule() directly.
> 
> Fix it by converting it into schedule_preempt_disabled().
> 
> Also disable preemption before calling cpu_idle() from
> secondary CPU entry code to stay consistent with this
> state.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: alpha <linux-alpha@vger.kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Michael Cree <mcree@orcon.net.nz>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/alpha/kernel/process.c |    3 ++-
>  arch/alpha/kernel/smp.c     |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
> index 153d3fc..eac5e01 100644
> --- a/arch/alpha/kernel/process.c
> +++ b/arch/alpha/kernel/process.c
> @@ -56,7 +56,8 @@ cpu_idle(void)
>  
>  		while (!need_resched())
>  			cpu_relax();
> -		schedule();
> +
> +		schedule_preempt_disabled();
>  	}
>  }
>  
> diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
> index 35ddc02..a41ad90 100644
> --- a/arch/alpha/kernel/smp.c
> +++ b/arch/alpha/kernel/smp.c
> @@ -166,6 +166,7 @@ smp_callin(void)
>  	DBGS(("smp_callin: commencing CPU %d current %p active_mm %p\n",
>  	      cpuid, current, current->active_mm));
>  
> +	preempt_disable();
>  	/* Do nothing.  */
>  	cpu_idle();
>  }
> -- 
> 1.7.8
> 
