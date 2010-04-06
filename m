Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0DFSEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:04:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35812 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0DFSEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:04:34 -0400
Date: Tue, 6 Apr 2010 11:04:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
Message-ID: <20100406180415.GD2553@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100405065701.GC5127@nowhere>
 <20100405.122233.188421941.davem@davemloft.net>
 <20100405194055.GA5265@nowhere>
 <20100406.025049.267615796.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406.025049.267615796.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 02:50:49AM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 5 Apr 2010 21:40:58 +0200
> 
> > It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> > when the function tracer runs). And I hadn't your
> > perf_arch_save_caller_regs() when I triggered this.
> 
> I figured out the problem, it's NMIs.  As soon as I disable all of the
> NMI watchdog code, the problem goes away.
> 
> This is because some parts of the NMI interrupt handling path are not
> marked with "notrace" and the various tracer code paths use
> local_irq_disable() (either directly or indirectly) which doesn't work
> with sparc64's NMI scheme.  These essentially turn NMIs back on in the
> NMI handler before the NMI condition has been cleared, and thus we can
> re-enter with another NMI interrupt.
> 
> We went through this for perf events, and we just made sure that
> local_irq_{enable,disable}() never occurs in any of the code paths in
> perf events that can be reached via the NMI interrupt handler.  (the
> only one we had was sched_clock() and that was easily fixed)
> 
> So, the first mcount hit we get is for rcu_nmi_enter() via
> nmi_enter().
> 
> I can see two ways to handle this:
> 
> 1) Pepper 'notrace' markers onto rcu_nmi_enter(), rcu_nmi_exit()
>    and whatever else I can see getting hit in the NMI interrupt
>    handler code paths.
> 
> 2) Add a hack to __raw_local_irq_save() that keeps it from writing
>    anything to the interrupt level register if we have NMI's disabled.
>    (this puts the cost on the entire kernel instead of just the NMI
>    paths).
> 
> #1 seems to be the intent on other platforms, the majority of the NMI
> code paths are protected with 'notrace' on x86, I bet nobody noticed
> that nmi_enter() when CONFIG_NO_HZ && !CONFIG_TINY_RCU ends up calling
> a function that does tracing.
> 
> The next one we'll hit is atomic_notifier_call_chain()  (amusingly
> notify_die() is marked 'notrace' but the one thing it calls isn't)
> 
> For example, the following are the generic notrace annotations I
> would need to get sparc64 ftrace functioning again. (Frederic I will
> send you the full patch with the sparc specific bits under seperate
> cover in so that you can test things...)
> 
> --------------------
> kernel: Add notrace annotations to common routines invoked via NMI.
> 
> This includes the atomic notifier call chain as well as the RCU
> specific NMI enter/exit handlers.

Assuming that static inline functions don't need the notrace flag:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

(If static inline functions -do- need notrace, then the definitions
in include/linux/hardirq.h need to be tagged as well.)

> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index 2488ba7..ceae89a 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -71,9 +71,9 @@ static int notifier_chain_unregister(struct notifier_block **nl,
>   *	@returns:	notifier_call_chain returns the value returned by the
>   *			last notifier function called.
>   */
> -static int __kprobes notifier_call_chain(struct notifier_block **nl,
> -					unsigned long val, void *v,
> -					int nr_to_call,	int *nr_calls)
> +static int notrace __kprobes notifier_call_chain(struct notifier_block **nl,
> +						 unsigned long val, void *v,
> +						 int nr_to_call,	int *nr_calls)
>  {
>  	int ret = NOTIFY_DONE;
>  	struct notifier_block *nb, *next_nb;
> @@ -172,9 +172,9 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
>   *	Otherwise the return value is the return value
>   *	of the last notifier function called.
>   */
> -int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> -					unsigned long val, void *v,
> -					int nr_to_call, int *nr_calls)
> +int notrace __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> +						   unsigned long val, void *v,
> +						   int nr_to_call, int *nr_calls)
>  {
>  	int ret;
> 
> @@ -185,8 +185,8 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
>  }
>  EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
> 
> -int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> -		unsigned long val, void *v)
> +int notrace __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> +						 unsigned long val, void *v)
>  {
>  	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
>  }
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3ec8160..d1a44ab 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -286,7 +286,7 @@ void rcu_exit_nohz(void)
>   * irq handler running, this updates rdtp->dynticks_nmi to let the
>   * RCU grace-period handling know that the CPU is active.
>   */
> -void rcu_nmi_enter(void)
> +void notrace rcu_nmi_enter(void)
>  {
>  	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> 
> @@ -304,7 +304,7 @@ void rcu_nmi_enter(void)
>   * irq handler running, this updates rdtp->dynticks_nmi to let the
>   * RCU grace-period handling know that the CPU is no longer active.
>   */
> -void rcu_nmi_exit(void)
> +void notrace rcu_nmi_exit(void)
>  {
>  	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
