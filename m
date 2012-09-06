Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2IFNOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:14:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2IFNOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:14:44 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=pZdUz1oXxZcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7I6Cu-NdG9YA:10 a=BQHM3gL45c1bhPeEg74A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346937282.1680.15.camel@gandalf.local.home>
Subject: Re: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Richter <robert.richter@amd.com>
Cc: wyang1 <Wei.Yang@windriver.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Date: Thu, 06 Sep 2012 09:14:42 -0400
In-Reply-To: <20120906100434.GX8285@erda.amd.com>
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
	 <20120904102439.GS8285@erda.amd.com> <5047FCBD.9000205@windriver.com>
	 <20120906100434.GX8285@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 12:04 +0200, Robert Richter wrote:

> please take a look at this. Not sure if Linus want to look at this too
> and if we need more optimization here.

It could probably go either way. Although the function has several
lines, it looks like the actual assembly produced wouldn't be much. I
took a quick look at where kernel_stack_pointer() is used, and I didn't
find any hot paths. This is why I think it can either be a called
function or static inline without much difference.

>  
>  #define GET_IP(regs) ((regs)->ip)
>  #define GET_FP(regs) ((regs)->bp)
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index c4c6a5c..5a9a8c9 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -165,6 +165,27 @@ static inline bool invalid_selector(u16 value)
>  
>  #define FLAG_MASK		FLAG_MASK_32
>  
> +/*
> + * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> + * when it traps.  The previous stack will be directly underneath the saved
> + * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> + *
> + * This is valid only for kernel mode traps.
> + */
> +unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
> +	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
> +	unsigned long sp = (unsigned long)&regs->sp;
> +	struct thread_info *tinfo;
> +

Please add some comments to why you did this. Having this info in just
the change log is not enough. Reading it with the code makes much more
sense.

> +	if (context == (sp & ~(THREAD_SIZE - 1)))
> +		return sp;
> +
> +	tinfo = (struct thread_info *)context;
> +
> +	return tinfo->previous_esp;
> +}
> +
>  static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
>  {
>  	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
> index d6aa6e8..5b5741e 100644
> --- a/arch/x86/oprofile/backtrace.c
> +++ b/arch/x86/oprofile/backtrace.c
> @@ -113,7 +113,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
>  
>  	if (!user_mode_vm(regs)) {
>  		unsigned long stack = kernel_stack_pointer(regs);
> -		if (depth)
> +		if (depth & stack)

Can other users of kernel_stack_pointer() be nailed by a return of NULL?

-- Steve

>  			dump_trace(NULL, regs, (unsigned long *)stack, 0,
>  				   &backtrace_ops, &depth);
>  		return;
> -- 
> 1.7.8.6
> 
> 
> 


