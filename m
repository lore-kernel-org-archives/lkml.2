Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0KONni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:43:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53895 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0KONnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:43:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k2qPuJnR/Fl9A5PX9DQOtxBB4tYjbug5J3YbU82t7krKq1890D+UmOAh3YuF//v0MJ
         +NWXPebTCsup4lvc1TmDKeiYgsue2+EC6G+mDzyhlRKwRgEylTouyZBYfk6Au0ENkrI3
         lOUgmeumlikYOxL0XpsX2vWQqPU0wtpiyn+Kg=
Date: Mon, 15 Nov 2010 14:43:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, hch@infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
	x86 & x86_64
Message-ID: <20101115134325.GA5410@nowhere>
References: <20101110164413.GA5360@nowhere> <1289466549-7602-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289466549-7602-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:09:09AM +0100, Jiri Olsa wrote:
> This provides a tracepoint to trace kernel pagefault event.
> 
> When analyzing a vmcore resulting from a kernel failure, we
> often hypothesize that "there should have a pagefault event
> just before this instruction" or similar.  Sometimes it means
> that there should have a small delay between instructions that
> extends a critical session and exposed a missing lock.  Since
> there have been no evidence of kernel pagefault, it is quite
> difficult to adopt the hypothesis.
> 
> If we can trace the kernel pagefault event, it will help narrow
> the possible cause of failure and will accelerate the
> investigation a lot.
> 
> 
> Signed-off-by: Larry Woodman <lwoodman@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  arch/x86/mm/fault.c         |   33 ++++++++++++++++++++++-----------
>  include/trace/events/kmem.h |   23 +++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 7d90ceb..171dcc9 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -12,6 +12,7 @@
>  #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
>  #include <linux/perf_event.h>		/* perf_sw_event		*/
>  #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
> +#include <trace/events/kmem.h>
>  
>  #include <asm/traps.h>			/* dotraplinkage, ...		*/
>  #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
> @@ -944,17 +945,11 @@ static int fault_in_kernel_space(unsigned long address)
>  	return address >= TASK_SIZE_MAX;
>  }
>  
> -/*
> - * This routine handles page faults.  It determines the address,
> - * and the problem, and then passes it off to one of the appropriate
> - * routines.
> - */
> -dotraplinkage void __kprobes
> -do_page_fault(struct pt_regs *regs, unsigned long error_code)
> +static inline void __do_page_fault(struct pt_regs *regs, unsigned long address,
> +				   unsigned long error_code)
>  {
>  	struct vm_area_struct *vma;
>  	struct task_struct *tsk;
> -	unsigned long address;
>  	struct mm_struct *mm;
>  	int fault;
>  	int write = error_code & PF_WRITE;
> @@ -964,9 +959,6 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	tsk = current;
>  	mm = tsk->mm;
>  
> -	/* Get the faulting address: */
> -	address = read_cr2();
> -
>  	/*
>  	 * Detect and handle instructions that would cause a page fault for
>  	 * both a tracked kernel page and a userspace page.
> @@ -1158,3 +1150,22 @@ good_area:
>  
>  	up_read(&mm->mmap_sem);
>  }
> +
> +/*
> + * This routine handles page faults.  It determines the address,
> + * and the problem, and then passes it off to one of the appropriate
> + * routines.
> + */
> +dotraplinkage void __kprobes
> +do_page_fault(struct pt_regs *regs, unsigned long error_code)
> +{
> +	unsigned long address;
> +
> +	/* Get the faulting address: */
> +	address = read_cr2();
> +
> +	__do_page_fault(regs, address, error_code);
> +
> +	if (!user_mode(regs))
> +		trace_mm_kernel_pagefault(current, address, error_code);
> +}



I (and others) have been testing your patch to measure the latencies of page
faults.

So I have several comments about it.

First, we don't want a pointer to current, we can already retrieve the pid
from a trace.

Second, it would be definetly interesting to also have the instruction address
that faulted (regs->ip).

Three, I wonder why this tracepoint only traces kernel faults. And in fact
kernel faults is a confusing name. Users will be confused whether this is
about tracing only faults happening in kernel or also faults happening in
kernel data.
Actually I don't see any reason right now to trace only kernel faults. Do you?
If that's needed, one can still check on post-processing that the address
was in the kernel.

And four, measuring page fault handling duration can be desired, it would be
nice to have a page_fault_start, page_fault_end.


So in the end we can get:


dotraplinkage void __kprobes
do_page_fault(struct pt_regs *regs, unsigned long error_code)
{
	unsigned long address;

	/* Get the faulting address: */
	address = read_cr2();

	trace_mm_pagefault_start(address, error_code);
	__do_page_fault(regs, address, error_code);
	trace_mm_pagefault_end(address);
}


Would you be ok with that?

Last thing I worry about is that error_code that is very arch dependent.
If someone writes a script that depends on the x86 code, it won't work
elsewhere while it's fairly possible to have a generic tracepoint there.

So perhaps we rather need a generic enum field instead of the error_code,
to express the most interesting specific fault attributes. Than can
probably be added later though, once someone really needs it.

Hm?

