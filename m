Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2G3OHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:07:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51775 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2G3OHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:07:46 -0400
Date: Mon, 30 Jul 2012 15:07:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 07/11] ARM: Add KGDB/KDB FIQ debugger generic code
Message-ID: <20120730140724.GI6802@n2100.arm.linux.org.uk>
References: <20120730115719.GA5742@lizard> <1343649500-18491-7-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343649500-18491-7-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:58:16AM -0700, Anton Vorontsov wrote:
> +	.align	5
> +__fiq_svc:
> +	svc_entry
> +	fiq_handler
> +	svc_exit r5				@ return from exception
> + UNWIND(.fnend		)
> +ENDPROC(__fiq_svc)
> +	.ltorg
> +
> +	.align	5
> +__fiq_usr:
> +	usr_entry
> +	kuser_cmpxchg_check
> +	fiq_handler
> +	get_thread_info tsk
> +	mov	why, #0
> +	b	ret_to_user_from_irq
> + UNWIND(.fnend		)
> +ENDPROC(__fiq_usr)
> +	.ltorg
> +
> +	.global kgdb_fiq_handler
> +kgdb_fiq_handler:
> +
> +	vector_stub	fiq, FIQ_MODE, 4
> +
> +	.long	__fiq_usr			@  0  (USR_26 / USR_32)
> +	.long	__fiq_svc			@  1  (FIQ_26 / FIQ_32)
> +	.long	__fiq_svc			@  2  (IRQ_26 / IRQ_32)
> +	.long	__fiq_svc			@  3  (SVC_26 / SVC_32)
> +	.long	__fiq_svc			@  4
> +	.long	__fiq_svc			@  5
> +	.long	__fiq_svc			@  6
> +	.long	__fiq_svc			@  7
> +	.long	__fiq_svc			@  8
> +	.long	__fiq_svc			@  9
> +	.long	__fiq_svc			@  a
> +	.long	__fiq_svc			@  b
> +	.long	__fiq_svc			@  c
> +	.long	__fiq_svc			@  d
> +	.long	__fiq_svc			@  e
> +	.long	__fiq_svc			@  f

I am not convinced that this does not cause loss of state from the parent
context.  Let's review what happens when a FIQ is received from SVC mode
with the above code.

- The CPU will be in SVC mode.
- FIQ received.
- CPU saves CPSR into SPSR_fiq and PC into LR_fiq, and jumps to the FIQ
  vector.
- We apply the 4 byte correction to LR_fiq, and store r0, LR_fiq and
  SPSR_fiq to the FIQ 'stack'
- We switch to SVC mode and jump to __fiq_svc
- svc_entry:
  - adjusts the SVC stack pointer down, and saves r1 - r12
  - loads r0, LR_fiq and SPSR_fiq and saves them as ARM_r0, ARM_pc, ARM_cpsr
    into the pt_regs
  - the original value of the SVC stack pointer is saved as ARM_r13
  - LR_svc is saved as ARM_r14

At this point, we have saved everything *except* for the SPSR_svc register.

Now, when we return from the above, we use svc_exit:
- write SPSR_svc with ARM_cpsr (from SPSR_fiq)
- load r0-pc from the pt_regs and load CPSR from SPSR_svc

Now the thing here is that even if we did preserve SPSR_svc, with the
above exit sequence, there is _no_ way to preserve the value of SPSR_svc.
Normally, this doesn't matter because we know that the regions we care
about this have IRQs disabled.

However, what this means, if we receive an FIQ and use this path from any
part of the kernel which expects SPSR_svc to be preserved (eg, the exit
path from any exception) the kernel will blow up.

I guess you could do something like this instead:
- disable FIQs
- load SPSR_svc with a saved value of it from entry.
- load r1-r14 from ARM_r1..ARM_lr
- switch to FIQ mode
- load SPSR_fiq from saved ARM_cpsr
- load r0 from ARM_r0
- load pc from ARM_pc

So, maybe something like this for the svc return path:

	cpsid	f
	ldr	r1, [saved_spsr_svc]
	mov	r0, sp
	mrs	spsr_cxsf, r1
	ldmib	r0, {r1 - r14}
	msr	cpsr_c, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT
	add	r7, r0, #S_PC
	ldr	r8, [r0, #S_CPSR]
	mrs	spsr_cxsf, r8
	ldr	r0, [r0, #S_R0]
	ldmia	r7, {pc}^
