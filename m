Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1E2TLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:11:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab1E2TLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:11:11 -0400
Date: Sun, 29 May 2011 21:10:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
Message-ID: <20110529191055.GC9835@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
 <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1121,6 +1121,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
>  zeroentry coprocessor_error do_coprocessor_error
>  errorentry alignment_check do_alignment_check
>  zeroentry simd_coprocessor_error do_simd_coprocessor_error
> +zeroentry intcc do_intcc
> +
>  
>  	/* Reload gs selector with exception handling */
>  	/* edi:  new selector */
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c

I forgot to reply to your prior question about zeroentry vs. 
paranoidzeroentry.

That distinction is an undocumented x86-64-ism.

Background:

The SWAPGS instruction is rather fragile: it must nest perfectly and 
only in single depth, it should only be used if entering from user 
mode to kernel mode and then when returning to user-space, and 
precisely so. If we mess that up even slightly, we crash.

So when we have a secondary entry, already in kernel mode, we *must 
not* use SWAPGS blindly - nor must we forget doing a SWAPGS when it's 
not switched/swapped yet.

Now, there's a secondary complication: there's a cheap way to test 
which mode the CPU is in and an expensive way.

The cheap way is to pick this info off the entry frame on the kernel 
stack, from the CS of the ptregs area of the kernel stack:

        xorl %ebx,%ebx
        testl $3,CS+8(%rsp)
        je error_kernelspace
        SWAPGS

The expensive (paranoid) way is to read back the MSR_GS_BASE value 
(which is what SWAPGS modifies):

        movl $1,%ebx
        movl $MSR_GS_BASE,%ecx
        rdmsr
        testl %edx,%edx
        js 1f   /* negative -> in kernel */
        SWAPGS
        xorl %ebx,%ebx
1:      ret


and the whole paranoid non-paranoid macro complexity is about whether 
to suffer that RDMSR cost.

If we are at an interrupt or user-trap/gate-alike boundary then we 
can use the faster check: the stack will be a reliable indicator of 
whether SWAPGS was already done: if we see that we are a secondary 
entry interrupting kernel mode execution, then we know that the GS 
base has already been switched. If it says that we interrupted 
user-space execution then we must do the SWAPGS.

But if we are in an NMI/MCE/DEBUG/whatever super-atomic entry 
context, which might have triggered right after a normal entry wrote 
CS to the stack but before we executed SWAPGS, then the only safe way 
to check for GS is the slower method: the RDMSR.

So we try only to mark those entry methods 'paranoid' that absolutely 
need the more expensive check for the GS base - and we generate all 
'normal' entry points with the regular (faster) entry macros.

I hope this explains!

All in one, your zeroentry choice should be fine: INT 0xCC will not 
issue in NMI context.

Btw, as a sidenote, and since you are already touching this code, 
would you be interested in putting this explanation into the source 
code? It's certainly not obvious and whoever wrote those macros did 
not think of documenting them for later generations ;-)

> +++ b/arch/x86/kernel/traps.c
> @@ -872,6 +872,10 @@ void __init trap_init(void)
>  	set_bit(SYSCALL_VECTOR, used_vectors);
>  #endif
>  
> +	set_system_intr_gate(0xCC, &intcc);
> +	set_bit(0xCC, used_vectors);
> +	printk(KERN_ERR "intcc gate isntalled\n");

I think you mentioned it but i cannot remember your reasoning why you 
marked it 0xcc (and not closer to the existing syscall vector) - 
please add a comment about it into the source code as well.

Ok, i suspect you marked it 0xCC because that's the INT3 instruction 
- not very useful for exploits?

> +void dotraplinkage do_intcc(struct pt_regs *regs, long error_code)
> +{
> +	/* Kernel code must never get here. */
> +	if (!user_mode(regs))
> +		BUG();

Nit: you can use BUG_ON() for that.

> +	local_irq_enable();
> +
> +	if (!in_vsyscall_page(regs->ip)) {
> +		struct task_struct *tsk = current;
> +		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&

Nit: please put an empty new line between local variable definitions 
and the first statement that follows - we do this for visual clarity.

A not-so-nit: i'd not limit this message to unhandled signals alone. 
An attacker could install a SIGSEGV handler, send a SIGSEGV and 
attempt the exploit right then - he'll get a free attempt with no 
logging performed, right?.

> +		    printk_ratelimit()) {
> +			printk(KERN_INFO
> +			       "%s[%d] illegal int $0xCC ip:%lx sp:%lx",
> +			       tsk->comm, task_pid_nr(tsk),
> +			       regs->ip, regs->sp);

I'd suggest putting the text 'exploit attempt?' into the printk 
somewhere - a sysadmin might not necessarily know what an illegal int 
$0xCC is..

> +			print_vma_addr(" in ", regs->ip);
> +			printk("\n");
> +		}
> +
> +		force_sig(SIGSEGV, current);
> +		return;
> +	}
> +
> +	if (current->seccomp.mode) {
> +		do_exit(SIGKILL);
> +		return;
> +	}
> +
> +	regs->ax = sys_gettimeofday((struct timeval __user *)regs->di, NULL);

Does the vsyscall gettimeofday ignore the zone parameter too?

> +
> +	local_irq_disable();
> +	return;
> +}

Nit: no need for a 'return;' at the end of a void function.

Thanks,

	Ingo
