Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2GFQgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:36:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43280 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab2GFQga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:36:30 -0400
Date: Fri, 6 Jul 2012 09:33:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] x86: Exit RCU extended QS on notify resume
Message-ID: <20120706163338.GW2522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341576018-10721-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070616-1780-0000-0000-0000072A241A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00154304; UDB=6.00034812; UTC=2012-07-06
 16:36:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 02:00:18PM +0200, Frederic Weisbecker wrote:
> do_notify_resume() may be called on irq exit but it won't
> be protected between rcu_irq_enter() and rcu_irq_exit()
> and we don't call rcu_user_exit() on irq entry (unlike
> syscalls/exceptions entry).
> 
> Since it can use RCU read side critical section, we must call
> rcu_user_exit() before doing anything there.
> 
> This complete support for RCU userspace extended quiescent state
> in x86.
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
> ---
>  arch/x86/Kconfig         |    1 +
>  arch/x86/kernel/signal.c |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c70684f..38dfcc2 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -95,6 +95,7 @@ config X86
>  	select KTIME_SCALAR if X86_32
>  	select GENERIC_STRNCPY_FROM_USER
>  	select GENERIC_STRNLEN_USER
> +	select HAVE_RCU_USER_QS if X86_64

And I will bite yet again.  Why only 64-bit kernels?

							Thanx, Paul

>  config INSTRUCTION_DECODER
>  	def_bool (KPROBES || PERF_EVENTS || UPROBES)
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 21af737..5af078e 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -776,6 +776,8 @@ static void do_signal(struct pt_regs *regs)
>  void
>  do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  {
> +	rcu_user_exit();
> +
>  #ifdef CONFIG_X86_MCE
>  	/* notify userspace of pending MCEs */
>  	if (thread_info_flags & _TIF_MCE_NOTIFY)
> -- 
> 1.7.5.4
> 

