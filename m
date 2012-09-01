Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2IAAFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 20:05:16 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44257 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2IAAFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 20:05:14 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 17:05:06 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Chris Zankel <chris@zankel.net>, "3.2.x.." <stable@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 25/26] xtensa: Add missing RCU idle APIs on
 idle loop
Message-ID: <20120901000506.GW11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-25-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-25-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:42PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> In the old times, the whole idle task was considered
> as an RCU quiescent state. But as RCU became more and
> more successful overtime, some RCU read side critical
> section have been added even in the code of some
> architectures idle tasks, for tracing for example.
> 
> So nowadays, rcu_idle_enter() and rcu_idle_exit() must
> be called by the architecture to tell RCU about the part
> in the idle loop that doesn't make use of rcu read side
> critical sections, typically the part that puts the CPU
> in low power mode.
> 
> This is necessary for RCU to find the quiescent states in
> idle in order to complete grace periods.
> 
> Add this missing pair of calls in the xtensa's idle loop.
> 
> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: 3.2.x.. <stable@vger.kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/xtensa/kernel/process.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
> index 2c8d6a3..bc44311 100644
> --- a/arch/xtensa/kernel/process.c
> +++ b/arch/xtensa/kernel/process.c
> @@ -31,6 +31,7 @@
>  #include <linux/mqueue.h>
>  #include <linux/fs.h>
>  #include <linux/slab.h>
> +#include <linux/rcupdate.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/uaccess.h>
> @@ -110,8 +111,10 @@ void cpu_idle(void)
>  
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> +		rcu_idle_enter();
>  		while (!need_resched())
>  			platform_idle();
> +		rcu_idle_exit();
>  		schedule_preempt_disabled();
>  	}
>  }
> -- 
> 1.7.8
> 
