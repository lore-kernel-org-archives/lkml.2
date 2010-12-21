Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0LUVtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:49:49 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:61060 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0LUVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K79aJyO5MbCUD1O4lJpw92vrL/ijkK06ZAvK0HhvWCCieRQgOa7J26LM6fdYJl9gv9
         C1GrrOI9wS22ICUldpQdP2EvMDPmS23buoI/AgB2+IMSl69eyzvrvgu1D9+qCK6S6M9v
         TduxrJ++GmrPH5WVeH4I2K4lyMpEwEP1Bq1H0=
Date: Tue, 21 Dec 2010 22:49:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 10/15] nohz_task: Enter in extended quiescent state
 when in userspace
Message-ID: <20101221214940.GV1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-11-git-send-email-fweisbec@gmail.com>
 <20101221192849.GP2143@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221192849.GP2143@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:28:49AM -0800, Paul E. McKenney wrote:
> On Mon, Dec 20, 2010 at 04:24:17PM +0100, Frederic Weisbecker wrote:
> > A nohz task can safely enter into extended quiescent state when
> > it goes into userspace, this avoids a remote cpu to force the
> > nohz task to be interrupted in order to notify quiescent states.
> > 
> > We enter into an extended quiescent state when:
> > 
> > - A nohz task resumes to userspace and is alone running on the
> > CPU (we check if the local cpu is in nohz mode, which means
> > no other task compete on that CPU). If the tick is still running
> > then entering into extended QS will be done later from the second
> > case:
> > 
> > - When the tick stops and verify the current task is a nohz one,
> > is alone running on the CPU and runs in userspace.
> > 
> > We exit the extended quiescent state when:
> > 
> > - A nohz task enters the kernel and is alone running on the CPU.
> > Again we check if the local cpu is in nohz mode for that. If
> > the tick is still running then it means we are not in an extended
> > QS and we don't do anything.
> > 
> > - The tick restarts because a new task is enqueued.
> > 
> > Whether the nohz task is in userspace or not is tracked by the
> > per cpu nohz_task_ext_qs variable.
> > 
> > Architectures need to provide some backend to notify userspace
> > exit/entry in order to support this mode.
> > It needs to implement the TIF_NOHZ flag that switches to slow
> > path syscall mode and to notify exceptions entry/exit.
> > 
> > We don't need to handle irqs or nmis as those are already handled
> > by RCU through rcu_enter_irq/nmi helpers.
> 
> One question below...
> 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Anton Blanchard <anton@au1.ibm.com>
> > Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> > ---
> >  arch/Kconfig             |    4 +++
> >  include/linux/tick.h     |   16 ++++++++++-
> >  kernel/sched.c           |    3 ++
> >  kernel/time/tick-sched.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-
> >  4 files changed, 81 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index e631791..d1ebea3 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -177,5 +177,9 @@ config HAVE_ARCH_JUMP_LABEL
> > 
> >  config HAVE_NO_HZ_TASK
> >  	bool
> > +	help
> > +	  Features necessary hooks for a task wanting to enter nohz
> > +	  while running alone on a CPU: thread flag for syscall hooks
> > +	  and exceptions entry/exit hooks.
> > 
> >  source "kernel/gcov/Kconfig"
> > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > index 7465a47..a704bb7 100644
> > --- a/include/linux/tick.h
> > +++ b/include/linux/tick.h
> > @@ -8,6 +8,7 @@
> > 
> >  #include <linux/clockchips.h>
> >  #include <linux/percpu-defs.h>
> > +#include <asm/ptrace.h>
> > 
> >  #ifdef CONFIG_GENERIC_CLOCKEVENTS
> > 
> > @@ -130,10 +131,21 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
> > 
> >  #ifdef CONFIG_NO_HZ_TASK
> >  DECLARE_PER_CPU(int, task_nohz_mode);
> > +DECLARE_PER_CPU(int, nohz_task_ext_qs);
> > +
> > +extern void tick_nohz_task_enter_kernel(void);
> > +extern void tick_nohz_task_exit_kernel(void);
> > +extern void tick_nohz_task_enter_exception(struct pt_regs *regs);
> > +extern void tick_nohz_task_exit_exception(struct pt_regs *regs);
> >  extern int tick_nohz_task_mode(void);
> > -#else
> > +
> > +#else /* !NO_HZ_TASK */
> > +static inline void tick_nohz_task_enter_kernel(void) { }
> > +static inline void tick_nohz_task_exit_kernel(void) { }
> > +static inline void tick_nohz_task_enter_exception(struct pt_regs *regs) { }
> > +static inline void tick_nohz_task_exit_exception(struct pt_regs *regs) { }
> >  static inline int tick_nohz_task_mode(void) { return 0; }
> > -#endif
> > +#endif /* !NO_HZ_TASK */
> > 
> >  # else /* !NO_HZ */
> >  static inline void tick_nohz_stop_sched_tick(int inidle) { }
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index b99f192..4412493 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2464,6 +2464,9 @@ static void nohz_task_cpu_update(void *unused)
> >  	if (rq->nr_running > 1 || rcu_pending(cpu) || rcu_needs_cpu(cpu)) {
> 
> If the task enters a system call in nohz mode, and then that system call
> enqueues an RCU callback, this code path will pull that CPU out of nohz
> mode, right?
> 
> 							Thanx, Paul

Hmm, no because this code path is only called after rcu or the scheduler sends
an IPI. And rcu won't call it after it enqueues a callback.

I did not think about that. If every other CPUs are in extended quiescent
state, nobody will take care of the grace period comletion, unless we are
lucky in the whole GP completion scenario. And at least the current CPU
that enqueues the callbacks is supposed to take care of that grace period
completion, right?

So I guess I need to restat the tick from there too.
