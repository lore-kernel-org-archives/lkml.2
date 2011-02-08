Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1BHCKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:10:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1BHCKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:10:33 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=q1gOGqRNiosA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=nTXo44Wn_N8c-v45rsAA:9 a=QG-8oI7du86_b1-Afr8A:7 a=slzpq4cNo-APy1lSSxlaph-wVzUA:4 a=PUjeQqilurYA:10 a=lSIRvuSMA57EyDMD:21 a=h_fdGPxeXm3rLM8A:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/6] ftrace, powerpc: Implement raw syscall tracepoints
 on PowerPC
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Munsie <imunsie@au1.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <1296703645-18718-6-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
	 <1296703645-18718-6-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 07 Feb 2011 21:10:28 -0500
Message-ID: <1297131028.23343.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

How do you want to work this? Do you want to ack it and I take this
patch with the others through the tracing tree, or do you want to wait
till the tracing tree gets updated into mainline and then pull this in
though the ppc tree. As this touches a bit of the ppc side.

-- Steve


On Thu, 2011-02-03 at 14:27 +1100, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> This patch implements the raw syscall tracepoints on PowerPC and exports
> them for ftrace syscalls to use.
> 
> To minimise reworking existing code, I slightly re-ordered the thread
> info flags such that the new TIF_SYSCALL_TRACEPOINT bit would still fit
> within the 16 bits of the andi. instruction's UI field. The instructions
> in question are in /arch/powerpc/kernel/entry_{32,64}.S to and the
> _TIF_SYSCALL_T_OR_A with the thread flags to see if system call tracing
> is enabled.
> 
> In the case of 64bit PowerPC, arch_syscall_addr and
> arch_syscall_match_sym_name are overridden to allow ftrace syscalls to
> work given the unusual system call table structure and symbol names that
> start with a period.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> ---
>  arch/powerpc/Kconfig                   |    1 +
>  arch/powerpc/include/asm/ftrace.h      |   14 ++++++++++++++
>  arch/powerpc/include/asm/syscall.h     |    5 +++++
>  arch/powerpc/include/asm/thread_info.h |    7 +++++--
>  arch/powerpc/kernel/Makefile           |    1 +
>  arch/powerpc/kernel/ftrace.c           |    8 ++++++++
>  arch/powerpc/kernel/ptrace.c           |   10 ++++++++++
>  7 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 7d69e9b..a0e8e02 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -134,6 +134,7 @@ config PPC
>  	select HAVE_GENERIC_HARDIRQS
>  	select HAVE_SPARSE_IRQ
>  	select IRQ_PER_CPU
> +	select HAVE_SYSCALL_TRACEPOINTS
>  
>  config EARLY_PRINTK
>  	bool
> diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
> index dde1296..169d039 100644
> --- a/arch/powerpc/include/asm/ftrace.h
> +++ b/arch/powerpc/include/asm/ftrace.h
> @@ -60,4 +60,18 @@ struct dyn_arch_ftrace {
>  
>  #endif
>  
> +#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64) && !defined(__ASSEMBLY__)
> +#define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
> +static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
> +{
> +	/*
> +	 * Compare the symbol name with the system call name. Skip the .sys or .SyS
> +	 * prefix from the symbol name and the sys prefix from the system call name and
> +	 * just match the rest. This is only needed on ppc64 since symbol names on
> +	 * 32bit do not start with a period so the generic function will work.
> +	 */
> +	return !strcmp(sym + 4, name + 3);
> +}
> +#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_PPC64 && !__ASSEMBLY__ */
> +
>  #endif /* _ASM_POWERPC_FTRACE */
> diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
> index 23913e9..b54b2ad 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -15,6 +15,11 @@
>  
>  #include <linux/sched.h>
>  
> +/* ftrace syscalls requires exporting the sys_call_table */
> +#ifdef CONFIG_FTRACE_SYSCALLS
> +extern const unsigned long *sys_call_table;
> +#endif /* CONFIG_FTRACE_SYSCALLS */
> +
>  static inline long syscall_get_nr(struct task_struct *task,
>  				  struct pt_regs *regs)
>  {
> diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
> index 65eb859..4403f09 100644
> --- a/arch/powerpc/include/asm/thread_info.h
> +++ b/arch/powerpc/include/asm/thread_info.h
> @@ -110,7 +110,8 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_NOERROR		12	/* Force successful syscall return */
>  #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
>  #define TIF_FREEZE		14	/* Freezing for suspend */
> -#define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
> +#define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation */
> +#define TIF_RUNLATCH		16	/* Is the runlatch enabled? */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -127,8 +128,10 @@ static inline struct thread_info *current_thread_info(void)
>  #define _TIF_NOERROR		(1<<TIF_NOERROR)
>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>  #define _TIF_FREEZE		(1<<TIF_FREEZE)
> +#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
> -#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
> +#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
> +				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT)
>  
>  #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
>  				 _TIF_NOTIFY_RESUME)
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 3bb2a3e..fe1ac47 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -105,6 +105,7 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
>  
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
> +obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>  obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
>  
>  obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_event.o
> diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
> index ce1f3e4..bf99cfa 100644
> --- a/arch/powerpc/kernel/ftrace.c
> +++ b/arch/powerpc/kernel/ftrace.c
> @@ -22,6 +22,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/code-patching.h>
>  #include <asm/ftrace.h>
> +#include <asm/syscall.h>
>  
> 
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -600,3 +601,10 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  	}
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
> +#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64)
> +unsigned long __init arch_syscall_addr(int nr)
> +{
> +	return sys_call_table[nr*2];
> +}
> +#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_PPC64 */
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 9065369..b6ff0cb 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -29,6 +29,7 @@
>  #include <linux/signal.h>
>  #include <linux/seccomp.h>
>  #include <linux/audit.h>
> +#include <trace/syscall.h>
>  #ifdef CONFIG_PPC32
>  #include <linux/module.h>
>  #endif
> @@ -40,6 +41,9 @@
>  #include <asm/pgtable.h>
>  #include <asm/system.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
> +
>  /*
>   * The parameter save area on the stack is used to store arguments being passed
>   * to callee function and is located at fixed offset from stack pointer.
> @@ -1691,6 +1695,9 @@ long do_syscall_trace_enter(struct pt_regs *regs)
>  		 */
>  		ret = -1L;
>  
> +	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
> +		trace_sys_enter(regs, regs->gpr[0]);
> +
>  	if (unlikely(current->audit_context)) {
>  #ifdef CONFIG_PPC64
>  		if (!is_32bit_task())
> @@ -1719,6 +1726,9 @@ void do_syscall_trace_leave(struct pt_regs *regs)
>  		audit_syscall_exit((regs->ccr&0x10000000)?AUDITSC_FAILURE:AUDITSC_SUCCESS,
>  				   regs->result);
>  
> +	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
> +		trace_sys_exit(regs, regs->result);
> +
>  	step = test_thread_flag(TIF_SINGLESTEP);
>  	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall_exit(regs, step);


