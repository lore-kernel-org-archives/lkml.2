Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2HaXrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:47:06 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60577 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:47:03 -0400
X-Originating-IP: 217.70.178.145
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:46:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 06/26] rcu: Ignore userspace extended
 quiescent state by default
Message-ID: <20120831234654.GD11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:23PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> By default we don't want to enter into RCU extended quiescent
> state while in userspace because doing this produces some overhead
> (eg: use of syscall slowpath). Set it off by default and ready to
> run when some feature like adaptive tickless need it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    5 ++++-
>  kernel/rcutree.h |    1 +
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 8bbc7fb..e2fd370 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -210,6 +210,9 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
>  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
>  	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
>  	.dynticks = ATOMIC_INIT(1),
> +#ifdef CONFIG_RCU_USER_QS
> +	.ignore_user_qs = true,
> +#endif
>  };
>  
>  static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
> @@ -443,7 +446,7 @@ void rcu_user_enter(void)
>  
>  	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (!rdtp->in_user) {
> +	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
>  		rdtp->in_user = true;
>  		rcu_eqs_enter(1);
>  	}
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 0dd5fd6..c190582 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -103,6 +103,7 @@ struct rcu_dynticks {
>  	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
>  #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
>  #ifdef CONFIG_RCU_USER_QS
> +	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
>  	bool in_user;		    /* Is the CPU in userland from RCU POV? */
>  #endif
>  };
> -- 
> 1.7.8
> 
