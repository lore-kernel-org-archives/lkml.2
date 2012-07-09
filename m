Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2GISlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:41:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45210 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2GISlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:41:51 -0400
Date: Mon, 9 Jul 2012 20:41:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
Message-ID: <20120709184145.GA7666@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins>
 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
 <1341832997.3462.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341832997.3462.41.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2012-07-06 at 11:34 -0700, Linus Torvalds wrote:
> 
> > But any code that does "kernel_ip(regs->ip)" is just 
> > terminally confused and can never be sane.
> 
> How about something like the below?
> 
> I've also modified perf_instruction_pointer() to account for 
> the VM86 and IA32 non-zero segment base cases. At least, I 
> tried to do so, I've never had the 'pleasure' of poking at 
> this segment descriptor stuff before.
> 
> Ingo didn't really like doing that though, his suggestion was 
> to kill all those IPs by mapping them to a special value (~0UL 
> or so).

So, my main worry is that the complexity/actual_use ratio feels 
rather high. Very few (if any) people will explicitly test the 
profiling of segmented x86 code - and even if they sample, 
chances are that it's a Windows COFF/who-knows binary that we 
don't symbol-decode in user-space at the moment.

Open coded calculations like this are easy to get wrong:

> +static unsigned long get_segment_base(unsigned int segment)
> +{
> +	struct desc_struct *desc;
> +	int idx = segment >> 3;
> +
> +	if ((segment & SEGMENT_TI_MASK) == SEGMENT_LDT) {
> +		if (idx > LDT_ENTRIES)
> +			return 0;
> +
> +		desc = current->active_mm->context.ldt;
> +	} else {
> +		if (idx > GDT_ENTRIES)
> +			return 0;
> +
> +		desc = __this_cpu_ptr(&gdt_page.gdt[0]);
> +	}
> +
> +	return get_desc_base(desc + idx);

Shouldn't idx be checked against active_mm->context.ldt.size, 
not LDT_ENTRIES (which is really just an upper limit)?

> +static unsigned long code_segment_base(struct pt_regs *regs)
> +{
> +#ifdef CONFIG_32BIT
> +	if (user_mode(regs) && regs->cs != __USER_CS)
> +		return get_segment_base(regs->cs);
> +#else
> +	if (test_thread_flag(TIF_IA32)) {
> +		if (user_mode(regs) && regs->cs != __USER32_CS)
> +			return get_segment_base(regs->cs);
> +	}
> +#endif
> +	return 0;
> +}

Will this do the right thing for x32 mode?

>  unsigned long perf_instruction_pointer(struct pt_regs *regs)
>  {
>  	unsigned long ip;
>  
>  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		ip = perf_guest_cbs->get_guest_ip();
> -	else
> -		ip = instruction_pointer(regs);
> +		return perf_guest_cbs->get_guest_ip();
> +
> +	ip = regs->ip;
> +
> +	if (regs->flags & X86_VM_MASK) {
> +		/*
> +		 * If we are in VM86 mode, add the segment offset to convert to
> +		 * a linear address.
> +		 */
> +		ip += 0x10 * regs->cs;

Sweet nostalgic memories ;-)

> +	} else {
> +		/*
> +		 * For IA32 we look at the GDT/LDT segment base to convert the
> +		 * effective IP to a linear address.
> +		 */
> +		ip += code_segment_base(regs);
> +	}

I'm also not entirely sure about skid across context switches 
and all that, the idx might not relate to the current LDT 
anymore - but I suspect we can ignore that problem.

( Another race is skid across descriptor updates - fortunately 
  sys_modify_ldt() is thick enough to be a practical barrier 
  against that and we were never crazy enough to mmap() portions 
  of the LDT to user-space or so. )

But no big fundamental objections from me, it would just be 
awfully nice to double check all the boundary conditions in this 
new code.

Thanks,

	Ingo
