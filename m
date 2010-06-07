Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0FGTl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:41:56 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4123 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0FGTlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:41:55 -0400
Message-ID: <4C0D4B82.6020002@caviumnetworks.com>
Date: Mon, 07 Jun 2010 12:41:54 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Himanshu Chauhan <hschauhan@nulltrace.org>
CC: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: KProbes support v0.1
References: <1275928440-21052-1-git-send-email-hschauhan@nulltrace.org> <1275928440-21052-2-git-send-email-hschauhan@nulltrace.org>
In-Reply-To: <1275928440-21052-2-git-send-email-hschauhan@nulltrace.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 19:41:55.0012 (UTC) FILETIME=[7BECD840:01CB0679]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few questions and comments below.  Many of them  may be due to 
my lack of understanding about the internals of KProbes.

David Daney.


On 06/07/2010 09:34 AM, Himanshu Chauhan wrote:
[...]
> diff --git a/arch/mips/include/asm/kdebug.h b/arch/mips/include/asm/kdebug.h
> index 5bf62aa..52818ac 100644
> --- a/arch/mips/include/asm/kdebug.h
> +++ b/arch/mips/include/asm/kdebug.h
> @@ -8,6 +8,11 @@ enum die_val {
>   	DIE_FP,
>   	DIE_TRAP,
>   	DIE_RI,
> +#ifdef CONFIG_KPROBES
> +	DIE_PAGE_FAULT,
> +	DIE_BREAK,
> +	DIE_SSTEPBP,
> +#endif
>   };
>

It might be cleaner without the #ifdef.  These are enum value 
definitions, so it doesn't affect code size.


Can you also explain how the die notifier chain interacts with KProbes 
and why it cannot be a seperate notifier chain?

>   #endif /* _ASM_MIPS_KDEBUG_H */
> diff --git a/arch/mips/include/asm/kprobes.h b/arch/mips/include/asm/kprobes.h
> new file mode 100644
> index 0000000..0f647bf
> --- /dev/null
> +++ b/arch/mips/include/asm/kprobes.h
> @@ -0,0 +1,85 @@
[...]
> +
> +#define BREAKPOINT_INSTRUCTION		0x0000000d
> +
> +/*
> + * We do not have hardware single-stepping on MIPS.
> + * So we implement software single-stepping with breakpoint
> + * trap 'break 5'.
> + */
> +#define BREAKPOINT_INSTRUCTION_2	0x0000014d

The BREAK codes are defined in asm/break.h  This should be added there 
instead.

Why do you use codes (0 and 5) that are already kind of reserved for 
user space debuggers?

> +#define MAX_INSN_SIZE 			2
> +
> +#define flush_insn_slot(p)		do { \
> +        /* invalidate I-cache */             \
> +        asm volatile("cache 0, 0($0)");      \
> +        /* invalidate D-cache */             \
> +        asm volatile("cache 9, 0($0)");      \
> +        } while(0);
> +

You have to call a function in arch/mips/mm/c-* to do this, you cannot 
open code with CACHE instructions as you need to handle CPU quirks and 
SMP.  It is possible that flush_icache_range() or flush_cache_sigtramp() 
would work.  Or we might need something new.

I see you use flush_icache_range() below, why have this definition, it 
looks unused?


[...]
> diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
> index 8882e57..e53ac80 100644
> --- a/arch/mips/kernel/genex.S
> +++ b/arch/mips/kernel/genex.S
> @@ -450,7 +450,13 @@ NESTED(nmi_handler, PT_SIZE, sp)
>   	BUILD_HANDLER ades ade ade silent		/* #5  */
>   	BUILD_HANDLER ibe be cli silent			/* #6  */
>   	BUILD_HANDLER dbe be cli silent			/* #7  */
> +#ifndef CONFIG_KPROBES
> +	/* call do_bp if bp hit and kprobes not configured */
>   	BUILD_HANDLER bp bp sti silent			/* #9  */
> +#else
> +	/* call do_break if bp hit and kprobes are configured */
> +	BUILD_HANDLER bp break sti silent		/* #9  */
> +#endif

Why this ugliness?  Can't you handle it in do_bp() or  do_trap_or_bp()?


>   	BUILD_HANDLER ri ri sti silent			/* #10 */
>   	BUILD_HANDLER cpu cpu sti silent		/* #11 */
>   	BUILD_HANDLER ov ov sti silent			/* #12 */
> diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
> new file mode 100644
> index 0000000..0493791
> --- /dev/null
> +++ b/arch/mips/kernel/kprobes.c
> @@ -0,0 +1,380 @@
[...]
> +
> +int __kprobes arch_prepare_kprobe(struct kprobe *p)
> +{
> +	union mips_instruction insn;
> +	int ret = 0;
> +
> +	insn = *p->addr;
> +
> +	switch (insn.i_format.opcode) {
> +		/*
> +		 * This group contains:
> +		 * jr and jalr are in r_format format.
> +		 */
> +	case spec_op:
> +
> +		/*
> +		 * This group contains:
> +		 * bltz_op, bgez_op, bltzl_op, bgezl_op,
> +		 * bltzal_op, bgezal_op, bltzall_op, bgezall_op.
> +		 */
> +	case bcond_op:
> +
> +		/*
> +		 * These are unconditional and in j_format.
> +		 */
> +	case jal_op:
> +	case j_op:
> +
> +		/*
> +		 * These are conditional and in i_format.
> +		 */
> +	case beq_op:
> +	case beql_op:
> +	case bne_op:
> +	case bnel_op:
> +	case blez_op:
> +	case blezl_op:
> +	case bgtz_op:
> +	case bgtzl_op:

Need to add or otherwise handle:


#ifdef CONFIG_CPU_CAVIUM_OCTEON
	case lwc2_op: /* This is bbit0 on Octeon */
	case ldc2_op: /* This is bbit032 on Octeon */
	case swc2_op: /* This is bbit1 on Octeon */
	case sdc2_op: /* This is bbit132 on Octeon */
#endif


[...]

> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index 8bdd6a6..f6b4b41 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -27,6 +27,7 @@
>   #include<linux/kdebug.h>
>   #include<linux/notifier.h>
>   #include<linux/kdb.h>
> +#include<linux/kprobes.h>
>
>   #include<asm/bootinfo.h>
>   #include<asm/branch.h>
> @@ -334,7 +335,7 @@ void show_regs(struct pt_regs *regs)
>   	__show_regs((struct pt_regs *)regs);
>   }
>
> -void show_registers(const struct pt_regs *regs)
> +void show_registers(struct pt_regs *regs)
>   {
>   	const int field = 2 * sizeof(unsigned long);
>
> @@ -790,6 +791,43 @@ out_sigsegv:
>   	force_sig(SIGSEGV, current);
>   }
>
> +#ifdef CONFIG_KPROBES
> +asmlinkage void __kprobes do_break (struct pt_regs *regs)
> +{
> +	unsigned int opcode, bcode;
> +
> +	opcode = *(unsigned long *)(regs->cp0_epc);
> +
> +	bcode = ((opcode>>  6)&  ((1<<  20) - 1));
> +	if (bcode<  (1<<  10))
> +		bcode<<= 10;
> +
> +	/*
> +	 * notify the kprobe handlers,if instruction is break 0 or break 5
> +	 */
> +	switch (bcode) {
> +	case BRK_USERBP<<  10:
> +		if (notify_die(DIE_BREAK, "debug", regs, bcode, 0, 0) == NOTIFY_STOP)
> +			return;
> +		else
> +			break;
> +	case BRK_SSTEPBP<<  10:
> +		if (notify_die(DIE_SSTEPBP, "single_step", regs, bcode, 0, 0) == NOTIFY_STOP)
> +			return;
> +		else
> +			break;
> +	default:
> +		break;
> +	}
> +


This should be folded into do_bp().



> +	/*
> +	 * If the bcode is other than 0 and 5, then call the normal
> +	 * break handler do_bp()
> +	 */
> +	do_bp(regs);
> +}
> +#endif
> +
>   asmlinkage void do_tr(struct pt_regs *regs)
>   {
>   	unsigned int opcode, tcode = 0;
> diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
> index b78f7d9..86e2d27 100644
> --- a/arch/mips/mm/fault.c
> +++ b/arch/mips/mm/fault.c
> @@ -18,6 +18,8 @@
>   #include<linux/smp.h>
>   #include<linux/vt_kern.h>		/* For unblank_screen() */
>   #include<linux/module.h>
> +#include<linux/kprobes.h>
> +#include<linux/kdebug.h>		/* notify_die and asm/kdebug.h */
>
>   #include<asm/branch.h>
>   #include<asm/mmu_context.h>
> @@ -31,8 +33,8 @@
>    * and the problem, and then passes it off to one of the appropriate
>    * routines.
>    */
> -asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
> -			      unsigned long address)
> +asmlinkage void __kprobes do_page_fault(struct pt_regs *regs, unsigned long write,
> +                                        unsigned long address)
>   {
>   	struct vm_area_struct * vma = NULL;
>   	struct task_struct *tsk = current;
> @@ -47,6 +49,11 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
>   	       field, regs->cp0_epc);
>   #endif
>
> +	/* Notify kprobes fault handler. */
> +        if (notify_die(DIE_PAGE_FAULT, "page fault",
> +                       regs, -1, SEGV_MAPERR, SEGV_MAPERR) == NOTIFY_STOP)
> +                return;
> +
>   	info.si_code = SEGV_MAPERR;
>
>   	/*

