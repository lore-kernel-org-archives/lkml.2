Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2HaXvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:51:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39242 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2HaXv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:51:29 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:51:19 -0700
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
Subject: Re: [PATCH tip/core/rcu 09/26] x86: Exception hooks for userspace
 RCU extended QS
Message-ID: <20120831235119.GF11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-9-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-9-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:26PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Add necessary hooks to x86 exception for userspace
> RCU extended quiescent state support.
> 
> This includes traps, page fault, debug exceptions, etc...
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

>  arch/x86/include/asm/rcu.h |   20 ++++++++++++++++++++
>  arch/x86/kernel/traps.c    |   30 ++++++++++++++++++++++--------
>  arch/x86/mm/fault.c        |   13 +++++++++++--
>  3 files changed, 53 insertions(+), 10 deletions(-)
>  create mode 100644 arch/x86/include/asm/rcu.h
> 
> diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/rcu.h
> new file mode 100644
> index 0000000..439815b
> --- /dev/null
> +++ b/arch/x86/include/asm/rcu.h
> @@ -0,0 +1,20 @@
> +#ifndef _ASM_X86_RCU_H
> +#define _ASM_X86_RCU_H
> +
> +#include <linux/rcupdate.h>
> +#include <asm/ptrace.h>
> +
> +static inline void exception_enter(struct pt_regs *regs)
> +{
> +	rcu_user_exit();
> +}
> +
> +static inline void exception_exit(struct pt_regs *regs)
> +{
> +#ifdef CONFIG_RCU_USER_QS
> +	if (user_mode(regs))
> +		rcu_user_enter();
> +#endif
> +}
> +
> +#endif
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index b481341..ab82cbd 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -55,6 +55,7 @@
>  #include <asm/i387.h>
>  #include <asm/fpu-internal.h>
>  #include <asm/mce.h>
> +#include <asm/rcu.h>
>  
>  #include <asm/mach_traps.h>
>  
> @@ -180,11 +181,15 @@ vm86_trap:
>  #define DO_ERROR(trapnr, signr, str, name)				\
>  dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
>  {									\
> -	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
> -							== NOTIFY_STOP)	\
> +	exception_enter(regs);						\
> +	if (notify_die(DIE_TRAP, str, regs, error_code,			\
> +			trapnr, signr) == NOTIFY_STOP) {		\
> +		exception_exit(regs);					\
>  		return;							\
> +	}								\
>  	conditional_sti(regs);						\
>  	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
> +	exception_exit(regs);						\
>  }
>  
>  #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
> @@ -195,11 +200,15 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
>  	info.si_errno = 0;						\
>  	info.si_code = sicode;						\
>  	info.si_addr = (void __user *)siaddr;				\
> -	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
> -							== NOTIFY_STOP)	\
> +	exception_enter(regs);						\
> +	if (notify_die(DIE_TRAP, str, regs, error_code,			\
> +			trapnr, signr) == NOTIFY_STOP) {		\
> +		exception_exit(regs);					\
>  		return;							\
> +	}								\
>  	conditional_sti(regs);						\
>  	do_trap(trapnr, signr, str, regs, error_code, &info);		\
> +	exception_exit(regs);						\
>  }
>  
>  DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
> @@ -312,6 +321,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>  	    ftrace_int3_handler(regs))
>  		return;
>  #endif
> +	exception_enter(regs);
>  #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
>  	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>  				SIGTRAP) == NOTIFY_STOP)
> @@ -331,6 +341,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>  	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
>  	preempt_conditional_cli(regs);
>  	debug_stack_usage_dec();
> +	exception_exit(regs);
>  }
>  
>  #ifdef CONFIG_X86_64
> @@ -391,6 +402,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	unsigned long dr6;
>  	int si_code;
>  
> +	exception_enter(regs);
> +
>  	get_debugreg(dr6, 6);
>  
>  	/* Filter out all the reserved bits which are preset to 1 */
> @@ -406,7 +419,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  
>  	/* Catch kmemcheck conditions first of all! */
>  	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
> -		return;
> +		goto exit;
>  
>  	/* DR6 may or may not be cleared by the CPU */
>  	set_debugreg(0, 6);
> @@ -421,7 +434,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  
>  	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
>  							SIGTRAP) == NOTIFY_STOP)
> -		return;
> +		goto exit;
>  
>  	/*
>  	 * Let others (NMI) know that the debug stack is in use
> @@ -437,7 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  					X86_TRAP_DB);
>  		preempt_conditional_cli(regs);
>  		debug_stack_usage_dec();
> -		return;
> +		goto exit;
>  	}
>  
>  	/*
> @@ -458,7 +471,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	preempt_conditional_cli(regs);
>  	debug_stack_usage_dec();
>  
> -	return;
> +exit:
> +	exception_exit(regs);
>  }
>  
>  /*
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 76dcd9d..7dde46d 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -18,6 +18,7 @@
>  #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
>  #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
>  #include <asm/fixmap.h>			/* VSYSCALL_START		*/
> +#include <asm/rcu.h>			/* exception_enter(), ...	*/
>  
>  /*
>   * Page fault error code bits:
> @@ -1000,8 +1001,8 @@ static int fault_in_kernel_space(unsigned long address)
>   * and the problem, and then passes it off to one of the appropriate
>   * routines.
>   */
> -dotraplinkage void __kprobes
> -do_page_fault(struct pt_regs *regs, unsigned long error_code)
> +static void __kprobes
> +__do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
>  	struct vm_area_struct *vma;
>  	struct task_struct *tsk;
> @@ -1209,3 +1210,11 @@ good_area:
>  
>  	up_read(&mm->mmap_sem);
>  }
> +
> +dotraplinkage void __kprobes
> +do_page_fault(struct pt_regs *regs, unsigned long error_code)
> +{
> +	exception_enter(regs);
> +	__do_page_fault(regs, error_code);
> +	exception_exit(regs);
> +}
> -- 
> 1.7.8
> 
