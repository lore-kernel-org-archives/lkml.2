Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1K3KYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:24:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:37070 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1K3KYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:24:49 -0500
Date: Wed, 30 Nov 2011 11:24:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into infinite
 spin in RT
In-Reply-To: <1322627551.17283.11.camel@marge.simson.net>
Message-ID: <alpine.LFD.2.02.1111301117240.2735@ionos>
References: <1322618120.17003.104.camel@frodo> <1322627551.17283.11.camel@marge.simson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, Mike Galbraith wrote:

> On Tue, 2011-11-29 at 20:55 -0500, Steven Rostedt wrote:
> > Ingo,
> > 
> > I forward ported this code from 2.6.33.9-rt31, but I think you were the
> > original author, as I found most of this code in the
> > "tasklet-redesign.patch" from my broken out 2.6.24-rt patches. I
> > committed it into my git tree (stable-rt) under your name, and added the
> > Signed-off-by that you had in that patch, if you have and objections,
> > please let me know. This patch should never see mainline, but it will
> > probably be going into the -rt branch. I wrote up this change log, if
> > there's something you don't like in it, let me know and I'll fix it.
> 
> I'm oh so happy to see this.  I've been going nuts trying to figure out
> why the heck 33-rt doesn't go bonkers, but 30+ rt does.
> 
> > Luis and Clark (I love saying that),
> > 
> > I booted this patch against 3.0-rt stable, and it didn't crash ;)
> > Could you apply it and see if it fixes the hang that you've been seeing.
> 
> I'll most certainly be testing it too.  With the below, and the
> conditional yield thingy disabled, all I have to do is boot x3550 M3
> box, and it'll hang very frequently, but not always, with sirq-tasklet
> going stark raving mad.  Yielding fix^Wmakes it not do the bad thing.
> 
> (somewhat less disgusting version of sirq threads patch;)
> 
> sched, rt: resurrect softirq threads for RT_FULL
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> ---
>  include/linux/interrupt.h |   46 ++++++++++
>  kernel/irq/Kconfig        |    7 +
>  kernel/sched.c            |    4 
>  kernel/softirq.c          |  194 ++++++++++++++++++++++++++++++++--------------
>  4 files changed, 191 insertions(+), 60 deletions(-)
> 
> Index: linux-3.2-rt/kernel/irq/Kconfig
> ===================================================================
> --- linux-3.2-rt.orig/kernel/irq/Kconfig
> +++ linux-3.2-rt/kernel/irq/Kconfig
> @@ -60,6 +60,13 @@ config IRQ_DOMAIN
>  config IRQ_FORCED_THREADING
>         bool
>  
> +# Support forced sirq threading
> +config SIRQ_FORCED_THREADING
> +       bool "Forced Soft IRQ threading"
> +       depends on PREEMPT_RT_FULL
> +	help
> +	  Split ksoftirqd into per SOFTIRQ threads
> +
>  config SPARSE_IRQ
>  	bool "Support sparse irq numbering"
>  	depends on HAVE_SPARSE_IRQ
> Index: linux-3.2-rt/include/linux/interrupt.h
> ===================================================================
> --- linux-3.2-rt.orig/include/linux/interrupt.h
> +++ linux-3.2-rt/include/linux/interrupt.h
> @@ -442,6 +442,9 @@ enum
>  	NR_SOFTIRQS
>  };
>  
> +/* Update when adding new softirqs. */
> +#define SOFTIRQ_MASK_ALL 0x3ff
> +
>  /* map softirq index to softirq name. update 'softirq_to_name' in
>   * kernel/softirq.c when adding a new softirq.
>   */
> @@ -457,10 +460,16 @@ struct softirq_action
>  };
>  
>  #ifndef CONFIG_PREEMPT_RT_FULL
> +#define NR_SOFTIRQ_THREADS 1
>  asmlinkage void do_softirq(void);
>  asmlinkage void __do_softirq(void);
>  static inline void thread_do_softirq(void) { do_softirq(); }
>  #else
> +#ifdef CONFIG_SIRQ_FORCED_THREADING
> +#define NR_SOFTIRQ_THREADS NR_SOFTIRQS
> +#else
> +#define NR_SOFTIRQ_THREADS 1
> +#endif
>  extern void thread_do_softirq(void);
>  #endif
>  
> @@ -486,12 +495,43 @@ extern void softirq_check_pending_idle(v
>   */
>  DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
>  
> -DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
> +struct softirqdata {
> +	int			mask;
> +	struct task_struct	*tsk;
> +};
> +
> +DECLARE_PER_CPU(struct softirqdata [NR_SOFTIRQ_THREADS], ksoftirqd);
> +
> +static inline bool this_cpu_ksoftirqd(struct task_struct *p)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
> +		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
> +			return true;

You are not serious about that loop, are you ?

> +	}
>  
> -static inline struct task_struct *this_cpu_ksoftirqd(void)
> +	return false;
> +}
> +
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +static inline int task_sirq_mask(struct task_struct *p)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_SOFTIRQ_THREADS; i++) {
> +		if (p == __get_cpu_var(ksoftirqd)[i].tsk)
> +			return __get_cpu_var(ksoftirqd)[i].mask;

Looks you are

> @@ -131,11 +155,18 @@ void softirq_check_pending_idle(void)
>   */
>  static void wakeup_softirqd(void)
>  {
> -	/* Interrupts are disabled: no need to stop preemption */
> -	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
> +	struct task_struct *tsk;
> +	u32 pending = local_softirq_pending(), mask, i;
>  
> -	if (tsk && tsk->state != TASK_RUNNING)
> -		wake_up_process(tsk);
> +	/* Interrupts are disabled: no need to stop preemption */
> +	for (i = 0; pending && i < NR_SOFTIRQ_THREADS; i++) {
> +		mask = __get_cpu_var(ksoftirqd)[i].mask;
> +		if (!(pending & mask))
> +			continue;
> +		tsk = __get_cpu_var(ksoftirqd)[i].tsk;
> +		if (tsk && tsk->state != TASK_RUNNING)
> +			wake_up_process(tsk);
> +	}
>  }

Dammned serious is seems. :)

I was looking into that as well, though I did not want to inflict it
on 3.0 at this point.

Thanks,

	tglx
