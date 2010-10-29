Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab0J2UDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:03:23 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43134 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754404Ab0J2UDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:03:21 -0400
Date: Fri, 29 Oct 2010 16:03:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Drake <dsd@laptop.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6/7] x86, ftrace: Use safe noops, drop trap test
Message-ID: <20101029200319.GB10702@Krystal>
References: <20101029190050.674141729@goodmis.org> <20101029190136.250239408@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029190136.250239408@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:02:47 up 37 days, 4 min,  4 users,  load average: 0.11, 0.17,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: H. Peter Anvin <hpa@zytor.com>
> 
> Always use a safe 5-byte noop sequence.  Drop the trap test, since it
> is known to return false negatives on some virtualization platforms on
> 32 bits.  The resulting code is both simpler and safer.
> 
> Cc: Daniel Drake <dsd@laptop.org>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Looks good to me.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/alternative.c |   69 +++++++++--------------------------------
>  1 files changed, 15 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index a36bb90..0b30214 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -644,65 +644,26 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
>  
>  #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
>  
> -unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
> +#ifdef CONFIG_X86_64
> +unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
> +#else
> +unsigned char ideal_nop5[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
> +#endif
>  
>  void __init arch_init_ideal_nop5(void)
>  {
> -	extern const unsigned char ftrace_test_p6nop[];
> -	extern const unsigned char ftrace_test_nop5[];
> -	extern const unsigned char ftrace_test_jmp[];
> -	int faulted = 0;
> -
>  	/*
> -	 * There is no good nop for all x86 archs.
> -	 * We will default to using the P6_NOP5, but first we
> -	 * will test to make sure that the nop will actually
> -	 * work on this CPU. If it faults, we will then
> -	 * go to a lesser efficient 5 byte nop. If that fails
> -	 * we then just use a jmp as our nop. This isn't the most
> -	 * efficient nop, but we can not use a multi part nop
> -	 * since we would then risk being preempted in the middle
> -	 * of that nop, and if we enabled tracing then, it might
> -	 * cause a system crash.
> +	 * There is no good nop for all x86 archs.  This selection
> +	 * algorithm should be unified with the one in find_nop_table(),
> +	 * but this should be good enough for now.
>  	 *
> -	 * TODO: check the cpuid to determine the best nop.
> +	 * For cases other than the ones below, use the safe (as in
> +	 * always functional) defaults above.
>  	 */
> -	asm volatile (
> -		"ftrace_test_jmp:"
> -		"jmp ftrace_test_p6nop\n"
> -		"nop\n"
> -		"nop\n"
> -		"nop\n"  /* 2 byte jmp + 3 bytes */
> -		"ftrace_test_p6nop:"
> -		P6_NOP5
> -		"jmp 1f\n"
> -		"ftrace_test_nop5:"
> -		".byte 0x66,0x66,0x66,0x66,0x90\n"
> -		"1:"
> -		".section .fixup, \"ax\"\n"
> -		"2:	movl $1, %0\n"
> -		"	jmp ftrace_test_nop5\n"
> -		"3:	movl $2, %0\n"
> -		"	jmp 1b\n"
> -		".previous\n"
> -		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
> -		_ASM_EXTABLE(ftrace_test_nop5, 3b)
> -		: "=r"(faulted) : "0" (faulted));
> -
> -	switch (faulted) {
> -	case 0:
> -		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
> -		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
> -		break;
> -	case 1:
> -		pr_info("converting mcount calls to 66 66 66 66 90\n");
> -		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
> -		break;
> -	case 2:
> -		pr_info("converting mcount calls to jmp . + 5\n");
> -		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
> -		break;
> -	}
> -
> +#ifdef CONFIG_X86_64
> +	/* Don't use these on 32 bits due to broken virtualizers */
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
> +		memcpy(ideal_nop5, p6_nops[5], 5);
> +#endif
>  }
>  #endif
> -- 
> 1.7.1
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
