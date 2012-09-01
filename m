Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2IAACM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 20:02:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40409 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab2IAACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 20:02:09 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 17:02:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "3.2.x.." <stable@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 19/26] h8300: Add missing RCU idle APIs on
 idle loop
Message-ID: <20120901000202.GQ11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-19-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-19-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:36PM -0700, Paul E. McKenney wrote:
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
> Add this missing pair of calls in the h8300's idle loop.
> 
> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: 3.2.x.. <stable@vger.kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/h8300/kernel/process.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
> index 0e9c315..f153ed1 100644
> --- a/arch/h8300/kernel/process.c
> +++ b/arch/h8300/kernel/process.c
> @@ -36,6 +36,7 @@
>  #include <linux/reboot.h>
>  #include <linux/fs.h>
>  #include <linux/slab.h>
> +#include <linux/rcupdate.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/traps.h>
> @@ -78,8 +79,10 @@ void (*idle)(void) = default_idle;
>  void cpu_idle(void)
>  {
>  	while (1) {
> +		rcu_idle_enter();
>  		while (!need_resched())
>  			idle();
> +		rcu_idle_exit();
>  		schedule_preempt_disabled();
>  	}
>  }
> -- 
> 1.7.8
> 
