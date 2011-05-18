Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1ERSOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:14:40 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:13156 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1ERSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:14:38 -0400
Message-ID: <4DD40C89.7010908@tilera.com>
Date: Wed, 18 May 2011 14:14:33 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arch/tile: support signal "exception-trace" hook
References: <201105181807.p4II7AYE015221@farm-0002.internal.tilera.com>
In-Reply-To: <201105181807.p4II7AYE015221@farm-0002.internal.tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with Andi Kleen's current email address (ak@suse.de was in the
git log for the x86 version of show-unhandled-signals).

On 5/16/2011 2:23 PM, Chris Metcalf wrote:
> This change adds support for /proc/sys/debug/exception-trace to tile.
> Like x86 and sparc, by default it is set to "1", generating a one-line
> printk whenever a user process crashes.  By setting it to "2", we get
> a much more complete userspace diagnostic at crash time, including
> a user-space backtrace, register dump, and memory dump around the
> address of the crash.
>
> Some vestiges of the Tilera-internal version of this support are
> removed with this patch (the show_crashinfo variable and the
> arch_coredump_signal function).  We retain a "crashinfo" boot parameter
> which allows you to set the boot-time value of exception-trace.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> Arnd Bergmann originally requested this (see parent email in thread)
> in code review of an early batch of arch/tile code.
>
>  arch/tile/include/asm/processor.h |    7 --
>  arch/tile/include/asm/signal.h    |    4 +
>  arch/tile/kernel/compat_signal.c  |    4 +-
>  arch/tile/kernel/signal.c         |  128 +++++++++++++++++++++++++++++++++++-
>  arch/tile/kernel/single_step.c    |    4 +
>  arch/tile/kernel/traps.c          |    1 +
>  arch/tile/mm/fault.c              |   24 ++++---
>  kernel/sysctl.c                   |    2 +-
>  8 files changed, 151 insertions(+), 23 deletions(-)
>
> diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
> index d6b43dd..34c1e01 100644
> --- a/arch/tile/include/asm/processor.h
> +++ b/arch/tile/include/asm/processor.h
> @@ -257,10 +257,6 @@ static inline void cpu_relax(void)
>  	barrier();
>  }
>  
> -struct siginfo;
> -extern void arch_coredump_signal(struct siginfo *, struct pt_regs *);
> -#define arch_coredump_signal arch_coredump_signal
> -
>  /* Info on this processor (see fs/proc/cpuinfo.c) */
>  struct seq_operations;
>  extern const struct seq_operations cpuinfo_op;
> @@ -271,9 +267,6 @@ extern char chip_model[64];
>  /* Data on which physical memory controller corresponds to which NUMA node. */
>  extern int node_controller[];
>  
> -/* Do we dump information to the console when a user application crashes? */
> -extern int show_crashinfo;
> -
>  #if CHIP_HAS_CBOX_HOME_MAP()
>  /* Does the heap allocator return hash-for-home pages by default? */
>  extern int hash_default;
> diff --git a/arch/tile/include/asm/signal.h b/arch/tile/include/asm/signal.h
> index 81d92a4..1e1e616 100644
> --- a/arch/tile/include/asm/signal.h
> +++ b/arch/tile/include/asm/signal.h
> @@ -28,6 +28,10 @@ struct pt_regs;
>  int restore_sigcontext(struct pt_regs *, struct sigcontext __user *);
>  int setup_sigcontext(struct sigcontext __user *, struct pt_regs *);
>  void do_signal(struct pt_regs *regs);
> +void signal_fault(const char *type, struct pt_regs *,
> +		  void __user *frame, int sig);
> +void trace_unhandled_signal(const char *type, struct pt_regs *regs,
> +			    unsigned long address, int signo);
>  #endif
>  
>  #endif /* _ASM_TILE_SIGNAL_H */
> diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
> index dbb0dfc..a7869ad 100644
> --- a/arch/tile/kernel/compat_signal.c
> +++ b/arch/tile/kernel/compat_signal.c
> @@ -317,7 +317,7 @@ long compat_sys_rt_sigreturn(struct pt_regs *regs)
>  	return 0;
>  
>  badframe:
> -	force_sig(SIGSEGV, current);
> +	signal_fault("bad sigreturn frame", regs, frame, 0);
>  	return 0;
>  }
>  
> @@ -431,6 +431,6 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	return 0;
>  
>  give_sigsegv:
> -	force_sigsegv(sig, current);
> +	signal_fault("bad setup frame", regs, frame, sig);
>  	return -EFAULT;
>  }
> diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
> index 1260321..bedaf4e 100644
> --- a/arch/tile/kernel/signal.c
> +++ b/arch/tile/kernel/signal.c
> @@ -39,7 +39,6 @@
>  
>  #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
>  
> -
>  SYSCALL_DEFINE3(sigaltstack, const stack_t __user *, uss,
>  		stack_t __user *, uoss, struct pt_regs *, regs)
>  {
> @@ -78,6 +77,13 @@ int restore_sigcontext(struct pt_regs *regs,
>  	return err;
>  }
>  
> +void signal_fault(const char *type, struct pt_regs *regs,
> +		  void __user *frame, int sig)
> +{
> +	trace_unhandled_signal(type, regs, (unsigned long)frame, SIGSEGV);
> +	force_sigsegv(sig, current);
> +}
> +
>  /* The assembly shim for this function arranges to ignore the return value. */
>  SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
>  {
> @@ -105,7 +111,7 @@ SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
>  	return 0;
>  
>  badframe:
> -	force_sig(SIGSEGV, current);
> +	signal_fault("bad sigreturn frame", regs, frame, 0);
>  	return 0;
>  }
>  
> @@ -231,7 +237,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	return 0;
>  
>  give_sigsegv:
> -	force_sigsegv(sig, current);
> +	signal_fault("bad setup frame", regs, frame, sig);
>  	return -EFAULT;
>  }
>  
> @@ -245,7 +251,6 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
>  {
>  	int ret;
>  
> -
>  	/* Are we from a system call? */
>  	if (regs->faultnum == INT_SWINT_1) {
>  		/* If so, check system call restarting.. */
> @@ -363,3 +368,118 @@ done:
>  	/* Avoid double syscall restart if there are nested signals. */
>  	regs->faultnum = INT_SWINT_1_SIGRETURN;
>  }
> +
> +int show_unhandled_signals = 1;
> +
> +static int __init crashinfo(char *str)
> +{
> +	unsigned long val;
> +	const char *word;
> +
> +	if (*str == '\0')
> +		val = 2;
> +	else if (*str != '=' || strict_strtoul(++str, 0, &val) != 0)
> +		return 0;
> +	show_unhandled_signals = val;
> +	switch (show_unhandled_signals) {
> +	case 0:
> +		word = "No";
> +		break;
> +	case 1:
> +		word = "One-line";
> +		break;
> +	default:
> +		word = "Detailed";
> +		break;
> +	}
> +	pr_info("%s crash reports will be generated on the console\n", word);
> +	return 1;
> +}
> +__setup("crashinfo", crashinfo);
> +
> +static void dump_mem(void __user *address)
> +{
> +	void __user *addr;
> +	enum { region_size = 256, bytes_per_line = 16 };
> +	int i, j, k;
> +	int found_readable_mem = 0;
> +
> +	pr_err("\n");
> +	if (!access_ok(VERIFY_READ, address, 1)) {
> +		pr_err("Not dumping at address 0x%lx (kernel address)\n",
> +		       (unsigned long)address);
> +		return;
> +	}
> +
> +	addr = (void __user *)
> +		(((unsigned long)address & -bytes_per_line) - region_size/2);
> +	if (addr > address)
> +		addr = NULL;
> +	for (i = 0; i < region_size;
> +	     addr += bytes_per_line, i += bytes_per_line) {
> +		unsigned char buf[bytes_per_line];
> +		char line[100];
> +		if (copy_from_user(buf, addr, bytes_per_line))
> +			continue;
> +		if (!found_readable_mem) {
> +			pr_err("Dumping memory around address 0x%lx:\n",
> +			       (unsigned long)address);
> +			found_readable_mem = 1;
> +		}
> +		j = sprintf(line, REGFMT":", (unsigned long)addr);
> +		for (k = 0; k < bytes_per_line; ++k)
> +			j += sprintf(&line[j], " %02x", buf[k]);
> +		pr_err("%s\n", line);
> +	}
> +	if (!found_readable_mem)
> +		pr_err("No readable memory around address 0x%lx\n",
> +		       (unsigned long)address);
> +}
> +
> +void trace_unhandled_signal(const char *type, struct pt_regs *regs,
> +			    unsigned long address, int sig)
> +{
> +	struct task_struct *tsk = current;
> +
> +	if (show_unhandled_signals == 0)
> +		return;
> +
> +	/* If the signal is handled, don't show it here. */
> +	if (!is_global_init(tsk)) {
> +		void __user *handler =
> +			tsk->sighand->action[sig-1].sa.sa_handler;
> +		if (handler != SIG_IGN && handler != SIG_DFL)
> +			return;
> +	}
> +
> +	/* Rate-limit the one-line output, not the detailed output. */
> +	if (show_unhandled_signals <= 1 && !printk_ratelimit())
> +		return;
> +
> +	printk("%s%s[%d]: %s at %lx pc "REGFMT" signal %d",
> +	       task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
> +	       tsk->comm, task_pid_nr(tsk), type, address, regs->pc, sig);
> +
> +	print_vma_addr(KERN_CONT " in ", regs->pc);
> +
> +	printk(KERN_CONT "\n");
> +
> +	if (show_unhandled_signals > 1) {
> +		switch (sig) {
> +		case SIGILL:
> +		case SIGFPE:
> +		case SIGSEGV:
> +		case SIGBUS:
> +			pr_err("User crash: signal %d,"
> +			       " trap %ld, address 0x%lx\n",
> +			       sig, regs->faultnum, address);
> +			show_regs(regs);
> +			dump_mem((void __user *)address);
> +			break;
> +		default:
> +			pr_err("User crash: signal %d, trap %ld\n",
> +			       sig, regs->faultnum);
> +			break;
> +		}
> +	}
> +}
> diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
> index 86df5a2..4032ca8 100644
> --- a/arch/tile/kernel/single_step.c
> +++ b/arch/tile/kernel/single_step.c
> @@ -186,6 +186,8 @@ static tile_bundle_bits rewrite_load_store_unaligned(
>  			.si_code = SEGV_MAPERR,
>  			.si_addr = addr
>  		};
> +		trace_unhandled_signal("segfault", regs,
> +				       (unsigned long)addr, SIGSEGV);
>  		force_sig_info(info.si_signo, &info, current);
>  		return (tile_bundle_bits) 0;
>  	}
> @@ -196,6 +198,8 @@ static tile_bundle_bits rewrite_load_store_unaligned(
>  			.si_code = BUS_ADRALN,
>  			.si_addr = addr
>  		};
> +		trace_unhandled_signal("unaligned trap", regs,
> +				       (unsigned long)addr, SIGBUS);
>  		force_sig_info(info.si_signo, &info, current);
>  		return (tile_bundle_bits) 0;
>  	}
> diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
> index 5474fc2..f9803df 100644
> --- a/arch/tile/kernel/traps.c
> +++ b/arch/tile/kernel/traps.c
> @@ -308,6 +308,7 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
>  	info.si_addr = (void __user *)address;
>  	if (signo == SIGILL)
>  		info.si_trapno = fault_num;
> +	trace_unhandled_signal("trap", regs, address, signo);
>  	force_sig_info(signo, &info, current);
>  }
>  
> diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
> index 24ca54a..25b7b90 100644
> --- a/arch/tile/mm/fault.c
> +++ b/arch/tile/mm/fault.c
> @@ -43,8 +43,11 @@
>  
>  #include <arch/interrupts.h>
>  
> -static noinline void force_sig_info_fault(int si_signo, int si_code,
> -	unsigned long address, int fault_num, struct task_struct *tsk)
> +static noinline void force_sig_info_fault(const char *type, int si_signo,
> +					  int si_code, unsigned long address,
> +					  int fault_num,
> +					  struct task_struct *tsk,
> +					  struct pt_regs *regs)
>  {
>  	siginfo_t info;
>  
> @@ -59,6 +62,7 @@ static noinline void force_sig_info_fault(int si_signo, int si_code,
>  	info.si_code = si_code;
>  	info.si_addr = (void __user *)address;
>  	info.si_trapno = fault_num;
> +	trace_unhandled_signal(type, regs, address, si_signo);
>  	force_sig_info(si_signo, &info, tsk);
>  }
>  
> @@ -71,11 +75,12 @@ SYSCALL_DEFINE2(cmpxchg_badaddr, unsigned long, address,
>  		struct pt_regs *, regs)
>  {
>  	if (address >= PAGE_OFFSET)
> -		force_sig_info_fault(SIGSEGV, SEGV_MAPERR, address,
> -				     INT_DTLB_MISS, current);
> +		force_sig_info_fault("atomic segfault", SIGSEGV, SEGV_MAPERR,
> +				     address, INT_DTLB_MISS, current, regs);
>  	else
> -		force_sig_info_fault(SIGBUS, BUS_ADRALN, address,
> -				     INT_UNALIGN_DATA, current);
> +		force_sig_info_fault("atomic alignment fault", SIGBUS,
> +				     BUS_ADRALN, address,
> +				     INT_UNALIGN_DATA, current, regs);
>  
>  	/*
>  	 * Adjust pc to point at the actual instruction, which is unusual
> @@ -471,8 +476,8 @@ bad_area_nosemaphore:
>  		 */
>  		local_irq_enable();
>  
> -		force_sig_info_fault(SIGSEGV, si_code, address,
> -				     fault_num, tsk);
> +		force_sig_info_fault("segfault", SIGSEGV, si_code, address,
> +				     fault_num, tsk, regs);
>  		return 0;
>  	}
>  
> @@ -547,7 +552,8 @@ do_sigbus:
>  	if (is_kernel_mode)
>  		goto no_context;
>  
> -	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, fault_num, tsk);
> +	force_sig_info_fault("bus error", SIGBUS, BUS_ADRERR, address,
> +			     fault_num, tsk, regs);
>  	return 0;
>  }
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c0bb324..aaec934 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1496,7 +1496,7 @@ static struct ctl_table fs_table[] = {
>  
>  static struct ctl_table debug_table[] = {
>  #if defined(CONFIG_X86) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || \
> -    defined(CONFIG_S390)
> +    defined(CONFIG_S390) || defined(CONFIG_TILE)
>  	{
>  		.procname	= "exception-trace",
>  		.data		= &show_unhandled_signals,

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


