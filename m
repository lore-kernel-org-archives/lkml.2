Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2ILOEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:04:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2ILOE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:04:29 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ySSALgrn4U0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=kE0kmglyRKUA:10 a=zd2uoN0lAAAA:8 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=cxZHHTCab6rR0rbmHUkA:9 a=PUjeQqilurYA:10 a=wu_e27o_rKQA:10 a=2e6ZYRoF4I4A:10 a=jeBq3FmKZ4MA:10 a=ELyOc1cNIAHUQWPw:21 a=iSHNMSefT5wJkdL6:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347458666.10751.42.camel@gandalf.local.home>
Subject: Re: [PATCH -v2] x86, 32-bit: Fix invalid stack address while in
 softirq
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, wyang1 <Wei.Yang@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sourceforge.net,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 12 Sep 2012 10:04:26 -0400
In-Reply-To: <20120912135059.GZ8285@erda.amd.com>
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
	 <20120904102439.GS8285@erda.amd.com> <5047FCBD.9000205@windriver.com>
	 <20120906100434.GX8285@erda.amd.com> <20120912135059.GZ8285@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added hpa, as he's one of the main active maintainers of the x86 arch.

On Wed, 2012-09-12 at 15:50 +0200, Robert Richter wrote:
> Updated version below. Changes are:
> 
>     * add comments to kernel_stack_pointer()
>     * always return a valid stack address by falling back to the address
>       of regs
> 
> -Robert
> 
> 
> >From 0114d0e2ff6ce3f6015fd991541a45261f14eab1 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Mon, 3 Sep 2012 20:54:48 +0200
> Subject: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
> 
> In 32 bit the stack address provided by kernel_stack_pointer() may
> point to an invalid range causing NULL pointer access or page faults
> while in NMI (see trace below). This happens if called in softirq
> context and if the stack is empty. The address at &regs->sp is then
> out of range.
> 
> Fixing this by checking if regs and &regs->sp are in the same stack
> context. Otherwise return the previous stack pointer stored in struct
> thread_info. If that address is invalid too, return address of regs.
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000a
>  IP: [<c1004237>] print_context_stack+0x6e/0x8d
>  *pde = 00000000
>  Oops: 0000 [#1] SMP
>  Modules linked in:
>  Pid: 4434, comm: perl Not tainted 3.6.0-rc3-oprofile-i386-standard-g4411a05 #4 Hewlett-Packard HP xw9400 Workstation/0A1Ch
>  EIP: 0060:[<c1004237>] EFLAGS: 00010093 CPU: 0
>  EIP is at print_context_stack+0x6e/0x8d
>  EAX: ffffe000 EBX: 0000000a ECX: f4435f94 EDX: 0000000a
>  ESI: f4435f94 EDI: f4435f94 EBP: f5409ec0 ESP: f5409ea0
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  CR0: 8005003b CR2: 0000000a CR3: 34ac9000 CR4: 000007d0
>  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>  DR6: ffff0ff0 DR7: 00000400
>  Process perl (pid: 4434, ti=f5408000 task=f5637850 task.ti=f4434000)
>  Stack:
>   000003e8 ffffe000 00001ffc f4e39b00 00000000 0000000a f4435f94 c155198c
>   f5409ef0 c1003723 c155198c f5409f04 00000000 f5409edc 00000000 00000000
>   f5409ee8 f4435f94 f5409fc4 00000001 f5409f1c c12dce1c 00000000 c155198c
>  Call Trace:
>   [<c1003723>] dump_trace+0x7b/0xa1
>   [<c12dce1c>] x86_backtrace+0x40/0x88
>   [<c12db712>] ? oprofile_add_sample+0x56/0x84
>   [<c12db731>] oprofile_add_sample+0x75/0x84
>   [<c12ddb5b>] op_amd_check_ctrs+0x46/0x260
>   [<c12dd40d>] profile_exceptions_notify+0x23/0x4c
>   [<c1395034>] nmi_handle+0x31/0x4a
>   [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
>   [<c13950ed>] do_nmi+0xa0/0x2ff
>   [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
>   [<c13949e5>] nmi_stack_correct+0x28/0x2d
>   [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
>   [<c1003603>] ? do_softirq+0x4b/0x7f
>   <IRQ>
>   [<c102a06f>] irq_exit+0x35/0x5b
>   [<c1018f56>] smp_apic_timer_interrupt+0x6c/0x7a
>   [<c1394746>] apic_timer_interrupt+0x2a/0x30
>  Code: 89 fe eb 08 31 c9 8b 45 0c ff 55 ec 83 c3 04 83 7d 10 00 74 0c 3b 5d 10 73 26 3b 5d e4 73 0c eb 1f 3b 5d f0 76 1a 3b 5d e8 73 15 <8b> 13 89 d0 89 55 e0 e8 ad 42 03 00 85 c0 8b 55 e0 75 a6 eb cc
>  EIP: [<c1004237>] print_context_stack+0x6e/0x8d SS:ESP 0068:f5409ea0
>  CR2: 000000000000000a
>  ---[ end trace 62afee3481b00012 ]---
>  Kernel panic - not syncing: Fatal exception in interrupt
> 
> V2:
> * add comments to kernel_stack_pointer()
> * always return a valid stack address by falling back to the address
>   of regs
> 
> Reported-by: Yang Wei <wei.yang@windriver.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/include/asm/ptrace.h |   15 ++++-----------
>  arch/x86/kernel/ptrace.c      |   28 ++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
> index dcfde52..19f16eb 100644
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -205,21 +205,14 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
>  }
>  #endif
>  
> -/*
> - * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> - * when it traps.  The previous stack will be directly underneath the saved
> - * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> - *
> - * This is valid only for kernel mode traps.
> - */
> -static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> -{
>  #ifdef CONFIG_X86_32
> -	return (unsigned long)(&regs->sp);
> +extern unsigned long kernel_stack_pointer(struct pt_regs *regs);
>  #else
> +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
>  	return regs->sp;
> -#endif
>  }
> +#endif
>  
>  #define GET_IP(regs) ((regs)->ip)
>  #define GET_FP(regs) ((regs)->bp)
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index c4c6a5c..947cf90 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -165,6 +165,34 @@ static inline bool invalid_selector(u16 value)
>  
>  #define FLAG_MASK		FLAG_MASK_32
>  
> +/*
> + * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> + * when it traps.  The previous stack will be directly underneath the saved
> + * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> + *
> + * Now, if the stack is empty, '&regs->sp' is out of range. In this
> + * case we try to take the previous stack. To always return a non-null
> + * stack pointer we fall back to regs as stack if no previous stack
> + * exists.
> + *
> + * This is valid only for kernel mode traps.
> + */
> +unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
> +	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
> +	unsigned long sp = (unsigned long)&regs->sp;
> +	struct thread_info *tinfo;
> +
> +	if (context == (sp & ~(THREAD_SIZE - 1)))
> +		return sp;
> +
> +	tinfo = (struct thread_info *)context;
> +	if (tinfo->previous_esp)
> +		return tinfo->previous_esp;
> +
> +	return (unsigned long)regs;
> +}
> +

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
>  {
>  	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
> -- 
> 1.7.8.6
> 
> 
> 


