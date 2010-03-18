Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0CRTas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:30:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56345 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0CRTaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rIH/7imy3t1Yadm6MnV8hn1BvqIff9MoGS8xH7WLyY/xbK2o0nDB56uq8cYdQV4Clr
         J9kBOVICf6fuPC356CKbk6KMmoxvUKIInYJXuZimpGtUSeOBl8ZZWg6NrODDf/9YO/8v
         +lbhNCkVrUiCVBjrv+j5NWdel+KrxLwAiLv5Y=
Date: Thu, 18 Mar 2010 20:30:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org, anton@samba.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] powerpc/perf_events: Implement
	perf_arch_fetch_caller_regs
Message-ID: <20100318193046.GD5103@nowhere>
References: <20100318050513.GA6575@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318050513.GA6575@drongo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 04:05:13PM +1100, Paul Mackerras wrote:
> This implements a powerpc version of perf_arch_fetch_caller_regs.
> It's implemented in assembly because that way we can be sure there
> isn't a stack frame for perf_arch_fetch_caller_regs.  If it was in
> C, gcc might or might not create a stack frame for it, which would
> affect the number of levels we have to skip.
> 
> With this, we see results from perf record -e lock:lock_acquire like
> this:
> 
> # Samples: 24878
> #
> # Overhead         Command      Shared Object  Symbol
> # ........  ..............  .................  ......
> #
>     14.99%            perf  [kernel.kallsyms]  [k] ._raw_spin_lock
>                       |
>                       --- ._raw_spin_lock
>                          |
>                          |--25.00%-- .alloc_fd
>                          |          (nil)
>                          |          |
>                          |          |--50.00%-- .anon_inode_getfd
>                          |          |          .sys_perf_event_open
>                          |          |          syscall_exit
>                          |          |          syscall
>                          |          |          create_counter
>                          |          |          __cmd_record
>                          |          |          run_builtin
>                          |          |          main
>                          |          |          0xfd2e704
>                          |          |          0xfd2e8c0
>                          |          |          (nil)
> 
> ... etc.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/include/asm/asm-compat.h |    2 ++
>  arch/powerpc/kernel/misc.S            |   28 ++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/asm-compat.h b/arch/powerpc/include/asm/asm-compat.h
> index c1b475a..a9b91ed 100644
> --- a/arch/powerpc/include/asm/asm-compat.h
> +++ b/arch/powerpc/include/asm/asm-compat.h
> @@ -28,6 +28,7 @@
>  #define PPC_LLARX(t, a, b, eh)	PPC_LDARX(t, a, b, eh)
>  #define PPC_STLCX	stringify_in_c(stdcx.)
>  #define PPC_CNTLZL	stringify_in_c(cntlzd)
> +#define PPC_LR_STKOFF	16
>  
>  /* Move to CR, single-entry optimized version. Only available
>   * on POWER4 and later.
> @@ -51,6 +52,7 @@
>  #define PPC_STLCX	stringify_in_c(stwcx.)
>  #define PPC_CNTLZL	stringify_in_c(cntlzw)
>  #define PPC_MTOCRF	stringify_in_c(mtcrf)
> +#define PPC_LR_STKOFF	4
>  
>  #endif
>  
> diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
> index 2d29752..b485a87 100644
> --- a/arch/powerpc/kernel/misc.S
> +++ b/arch/powerpc/kernel/misc.S
> @@ -127,3 +127,31 @@ _GLOBAL(__setup_cpu_power7)
>  _GLOBAL(__restore_cpu_power7)
>  	/* place holder */
>  	blr
> +
> +#ifdef CONFIG_EVENT_TRACING
> +/*
> + * Get a minimal set of registers for our caller's nth caller.
> + * r3 = regs pointer, r5 = n.
> + *
> + * We only get R1 (stack pointer), NIP (next instruction pointer)
> + * and LR (link register).  These are all we can get in the
> + * general case without doing complicated stack unwinding, but
> + * fortunately they are enough to do a stack backtrace, which
> + * is all we need them for.
> + */
> +_GLOBAL(perf_arch_fetch_caller_regs)
> +	mr	r6,r1
> +	cmpwi	r5,0
> +	mflr	r4
> +	ble	2f
> +	mtctr	r5
> +1:	PPC_LL	r6,0(r6)
> +	bdnz	1b
> +	PPC_LL	r4,PPC_LR_STKOFF(r6)
> +2:	PPC_LL	r7,0(r6)
> +	PPC_LL	r7,PPC_LR_STKOFF(r7)
> +	PPC_STL	r6,GPR1-STACK_FRAME_OVERHEAD(r3)
> +	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
> +	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
> +	blr
> +#endif /* CONFIG_EVENT_TRACING */


Ingo has reported me that context-switches software events
(not the trace event version) have crappy callchains.

So, while looking into it:

- PERF_COUNT_SW_CPU_MIGRATIONS provides no regs.
Heh, and it event doesn't work because of this perf_swevent_add
give up if regs are NULL.
Has PERF_COUNT_SW_CPU_MIGRATIONS ever worked?

- PERF_COUNT_SW_CONTEXT_SWITCHES uses task_pt_regs(). This
seems a very wrong thing. We don't want the regs when a user
task was interrupted or before a syscall.
That notwithstanding task_pt_regs() on kernel threads
has insane effects.

What we want for both is a hot regs snapshot.
I'm going to fix this. But it means the CONFIG_EVENT_TRACING
dependency is not true anymore. So I can't keep the exported
symbol of perf_arch_fetch_caller_regs() in trace_event_perf.c.

The ideal would be to put the EXPORT_SYMBOL in perf_event.c
but doing so in the same file a weak symbol is defined has
unpredictable effects. So I'm going to make it a macro as I
don't have the choice. I'll update ppc at the same time but I
can't guarantee it will even build :)

Thanks.

