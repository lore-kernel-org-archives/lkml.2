Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2HaXyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:54:23 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41472 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2HaXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:54:22 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:54:12 -0700
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
Subject: Re: [PATCH tip/core/rcu 13/26] x86: Exit RCU extended QS on notify
 resume
Message-ID: <20120831235412.GJ11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-13-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-13-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:30PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> do_notify_resume() may be called on irq or exception
> exit. But at that time the exception has already called
> rcu_user_enter() and the irq has already called rcu_irq_exit().
> 
> Since it can use RCU read side critical section, we must call
> rcu_user_exit() before doing anything there. Then we must call
> back rcu_user_enter() after this function because we know we are
> going to userspace from there.
> 
> This complete support for userspace RCU extended quiescent state
> in x86-64.
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

>  arch/x86/Kconfig         |    1 +
>  arch/x86/kernel/signal.c |    4 ++++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ba2657c..5cd953a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -97,6 +97,7 @@ config X86
>  	select KTIME_SCALAR if X86_32
>  	select GENERIC_STRNCPY_FROM_USER
>  	select GENERIC_STRNLEN_USER
> +	select HAVE_RCU_USER_QS if X86_64
>  
>  config INSTRUCTION_DECODER
>  	def_bool (KPROBES || PERF_EVENTS || UPROBES)
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index b280908..bca0ab9 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -779,6 +779,8 @@ static void do_signal(struct pt_regs *regs)
>  void
>  do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  {
> +	rcu_user_exit();
> +
>  #ifdef CONFIG_X86_MCE
>  	/* notify userspace of pending MCEs */
>  	if (thread_info_flags & _TIF_MCE_NOTIFY)
> @@ -804,6 +806,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  #ifdef CONFIG_X86_32
>  	clear_thread_flag(TIF_IRET);
>  #endif /* CONFIG_X86_32 */
> +
> +	rcu_user_enter();
>  }
>  
>  void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
> -- 
> 1.7.8
> 
