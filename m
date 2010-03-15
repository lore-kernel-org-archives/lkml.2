Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329Ab0CORhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:37:01 -0400
Received: from ozlabs.org ([203.10.76.45]:46010 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935811Ab0CORg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:36:56 -0400
From: Michael Neuling <mikey@neuling.org>
To: Paul Mackerras <paulus@samba.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH] powerpc/perf_events: Implement perf_arch_fetch_caller_regs for powerpc
In-reply-to: <20100315054615.GA6245@drongo>
References: <20100315054615.GA6245@drongo>
Comments: In-reply-to Paul Mackerras <paulus@samba.org>
   message dated "Mon, 15 Mar 2010 16:46:15 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Mon, 15 Mar 2010 12:36:53 -0500
Message-ID: <666.1268674613@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This implements a powerpc version of perf_arch_fetch_caller_regs.
> It's implemented in assembly because that way we can be sure there
> isn't a stack frame for perf_arch_fetch_caller_regs.  If it was in
> C, gcc might or might not create a stack frame for it, which would
> affect the number of levels we have to skip.  

Should we put this comment in the code as well?

Mikey

> It's not ifdef'd
> because it is only 14 instructions long.
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
> ---
>  arch/powerpc/include/asm/asm-compat.h |    2 ++
>  arch/powerpc/kernel/misc.S            |   20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/asm-compat.h b/arch/powerpc/include/asm
/asm-compat.h
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
> index 2d29752..4459500 100644
> --- a/arch/powerpc/kernel/misc.S
> +++ b/arch/powerpc/kernel/misc.S
> @@ -127,3 +127,23 @@ _GLOBAL(__setup_cpu_power7)
>  _GLOBAL(__restore_cpu_power7)
>  	/* place holder */
>  	blr
> +
> +/*
> + * Get a minimal set of registers for our caller's nth caller.
> + * r3 = regs pointer, r5 = n.
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
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
