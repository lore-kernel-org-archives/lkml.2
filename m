Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0LXVL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 16:11:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:46155 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0LXVL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 16:11:28 -0500
Subject: Re: [PATCH][GIT PULL] powerpc64/tracing: Add frame buffer to calls
 of trace_hardirqs_on/off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Sommer <joerg@alea.gnuu.de>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <1293169566.22802.420.camel@gandalf.stny.rr.com>
References: <1293169566.22802.420.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Dec 2010 08:11:05 +1100
Message-ID: <1293225065.16694.796.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 00:46 -0500, Steven Rostedt wrote:

>  arch/powerpc/include/asm/irqflags.h |   40 ++++++++++++++++++++++++++--------
>  1 files changed, 30 insertions(+), 10 deletions(-)
> ---------------------------
> commit 5025019505da6731f8be13940bb978617599c935
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Dec 23 21:07:39 2010 -0800
> 
>     powerpc64/tracing: Add frame buffer to calls of trace_hardirqs_on/off
>     
>     When an interrupt occurs in userspace, we can call trace_hardirqs_on/off()
>     With one level stack. But if we have irqsoff tracing enabled,
>     it checks both CALLER_ADDR0 and CALLER_ADDR1. The second call
>     goes two stack frames up. If this is from user space, then there may
>     not exist a second stack.
>     
>     Add a second stack when calling trace_hardirqs_on/off() otherwise
>     the following oops might occur:

Hrm... this is really gross :-) So we add gratuituous overhead because
the code below is dumb :-) What about making the code less stupid
instead when poking at the stack and detect it's coming from userspace
instead ?

Cheers,
Ben.

>     Oops: Kernel access of bad area, sig: 11 [#1]
>     PREEMPT SMP NR_CPUS=2 PA Semi PWRficient
>     last sysfs file: /sys/block/sda/size
>     Modules linked in: ohci_hcd ehci_hcd usbcore
>     NIP: c0000000000e1c00 LR: c0000000000034d4 CTR: 000000011012c440
>     REGS: c00000003e2f3af0 TRAP: 0300   Not tainted  (2.6.37-rc6+)
>     MSR: 9000000000001032 <ME,IR,DR>  CR: 48044444  XER: 20000000
>     DAR: 00000001ffb9db50, DSISR: 0000000040000000
>     TASK = c00000003e1a00a0[2088] 'emacs' THREAD: c00000003e2f0000 CPU: 1
>     GPR00: 0000000000000001 c00000003e2f3d70 c00000000084e0d0 c0000000008816e8
>     GPR04: 000000001034c678 000000001032e8f9 0000000010336540 0000000040020000
>     GPR08: 0000000040020000 00000001ffb9db40 c00000003e2f3e30 0000000060000000
>     GPR12: 100000000000f032 c00000000fff0280 000000001032e8c9 0000000000000008
>     GPR16: 00000000105be9c0 00000000105be950 00000000105be9b0 00000000105be950
>     GPR20: 00000000ffb9dc50 00000000ffb9dbf0 00000000102f0000 00000000102f0000
>     GPR24: 00000000102e0000 00000000102f0000 0000000010336540 c0000000009ded38
>     GPR28: 00000000102e0000 c0000000000034d4 c0000000007ccb10 c00000003e2f3d70
>     NIP [c0000000000e1c00] .trace_hardirqs_off+0xb0/0x1d0
>     LR [c0000000000034d4] decrementer_common+0xd4/0x100
>     Call Trace:
>     [c00000003e2f3d70] [c00000003e2f3e30] 0xc00000003e2f3e30 (unreliable)
>     [c00000003e2f3e30] [c0000000000034d4] decrementer_common+0xd4/0x100
>     Instruction dump:
>     81690000 7f8b0000 419e0018 f84a0028 60000000 60000000 60000000 e95f0000
>     80030000 e92a0000 eb6301f8 2f800000 <eb890010> 41fe00dc a06d000a eb1e8050
>     ---[ end trace 4ec7fd2be9240928 ]---
>     
>     Reported-by: Joerg Sommer <joerg@alea.gnuu.de>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/powerpc/include/asm/irqflags.h b/arch/powerpc/include/asm/irqflags.h
> index b85d8dd..b0b06d8 100644
> --- a/arch/powerpc/include/asm/irqflags.h
> +++ b/arch/powerpc/include/asm/irqflags.h
> @@ -12,24 +12,44 @@
>  
>  #else
>  #ifdef CONFIG_TRACE_IRQFLAGS
> +#ifdef CONFIG_IRQSOFF_TRACER
> +/*
> + * Since the ftrace irqsoff latency trace checks CALLER_ADDR1,
> + * which is the stack frame here, we need to force a stack frame
> + * in case we came from user space.
> + */
> +#define TRACE_WITH_FRAME_BUFFER(func)		\
> +	mflr	r0;				\
> +	stdu	r1, -32(r1);			\
> +	std	r0, 16(r1);			\
> +	stdu	r1, -32(r1);			\
> +	bl func;				\
> +	ld	r1, 0(r1);			\
> +	ld	r1, 0(r1);
> +#else
> +#define TRACE_WITH_FRAME_BUFFER(func)		\
> +	bl func;
> +#endif
> +
>  /*
>   * Most of the CPU's IRQ-state tracing is done from assembly code; we
>   * have to call a C function so call a wrapper that saves all the
>   * C-clobbered registers.
>   */
> -#define TRACE_ENABLE_INTS	bl .trace_hardirqs_on
> -#define TRACE_DISABLE_INTS	bl .trace_hardirqs_off
> -#define TRACE_AND_RESTORE_IRQ_PARTIAL(en,skip)	\
> -	cmpdi	en,0;				\
> -	bne	95f;				\
> -	stb	en,PACASOFTIRQEN(r13);		\
> -	bl	.trace_hardirqs_off;		\
> -	b	skip;				\
> -95:	bl	.trace_hardirqs_on;		\
> +#define TRACE_ENABLE_INTS	TRACE_WITH_FRAME_BUFFER(.trace_hardirqs_on)
> +#define TRACE_DISABLE_INTS	TRACE_WITH_FRAME_BUFFER(.trace_hardirqs_off)
> +
> +#define TRACE_AND_RESTORE_IRQ_PARTIAL(en,skip)		\
> +	cmpdi	en,0;					\
> +	bne	95f;					\
> +	stb	en,PACASOFTIRQEN(r13);			\
> +	TRACE_WITH_FRAME_BUFFER(.trace_hardirqs_off)	\
> +	b	skip;					\
> +95:	TRACE_WITH_FRAME_BUFFER(.trace_hardirqs_on)	\
>  	li	en,1;
>  #define TRACE_AND_RESTORE_IRQ(en)		\
>  	TRACE_AND_RESTORE_IRQ_PARTIAL(en,96f);	\
> -	stb	en,PACASOFTIRQEN(r13);	        \
> +	stb	en,PACASOFTIRQEN(r13);		\
>  96:
>  #else
>  #define TRACE_ENABLE_INTS
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


