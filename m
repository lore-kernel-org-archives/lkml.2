Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab2GCI3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:29:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42976 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2GCI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:29:16 -0400
X-AuditID: b753bd60-98cf0ba000000f6c-0d-4ff2ad59f969
X-AuditID: b753bd60-98cf0ba000000f6c-0d-4ff2ad59f969
Message-ID: <4FF2AD59.6080006@hitachi.com>
Date: Tue, 03 Jul 2012 17:29:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 5/6] ftrace/x86: Add separate function to save regs
References: <20120702200322.573660631@goodmis.org> <20120702201821.510485400@goodmis.org>
In-Reply-To: <20120702201821.510485400@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/03 5:03), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add a way to have different functions calling different trampolines.
> If a ftrace_ops wants regs saved on the return, then have only the
> functions with ops registered to save regs. Functions registered by
> other ops would not be affected, unless the functions overlap.
> 
> If one ftrace_ops registered functions A, B and C and another ops
> registered fucntions to save regs on A, and D, then only functions
> A and D would be saving regs. Function B and C would work as normal.
> Although A is registered by both ops: normal and saves regs; this is fine
> as saving the regs is needed to satisfy one of the ops that calls it
> but the regs are ignored by the other ops function.
> 
> x86_64 implements the full regs saving, and i386 just passes a NULL
> for regs to satisfy the ftrace_ops passing. Where an arch must supply
> both regs and ftrace_ops parameters, even if regs is just NULL.
> 
> It is OK for an arch to pass NULL regs. All function trace users that
> require regs passing must add the flag FTRACE_OPS_FL_SAVE_REGS when
> registering the ftrace_ops. If the arch does not support saving regs
> then the ftrace_ops will fail to register. The flag
> FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED may be set that will prevent the
> ftrace_ops from failing to register. In this case, the handler may
> either check if regs is not NULL or check if ARCH_SUPPORTS_FTRACE_SAVE_REGS.
> If the arch supports passing regs it will set this macro and pass regs
> for ops that request them. All other archs will just pass NULL.

This is nice for me :)
It helps me to maintain kprobes on ftrace.

[...]
> @@ -98,6 +111,67 @@ GLOBAL(ftrace_stub)
>  	retq
>  END(ftrace_caller)
>  
> +ENTRY(ftrace_regs_caller)
> +	/* Save the current flags before compare (in SS location)*/
> +	pushfq
> +
> +	/* Check if tracing was disabled (quick check) */
> +	cmpl $0, function_trace_stop
> +	jne  ftrace_restore_flags
> +
> +	/* skip=8 to skip flags saved in SS */
> +	ftrace_caller_setup 8
> +
> +	/* Save the rest of pt_regs */
> +	movq %r15, R15(%rsp)
> +	movq %r14, R14(%rsp)
> +	movq %r13, R13(%rsp)
> +	movq %r12, R12(%rsp)
> +	movq %r11, R11(%rsp)
> +	movq %r10, R10(%rsp)
> +	movq %rbp, RBP(%rsp)
> +	movq %rbx, RBX(%rsp)
> +	/* Copy saved flags */
> +	movq SS(%rsp), %rcx
> +	movq %rcx, EFLAGS(%rsp)
> +	/* Kernel segments */
> +	movq $__KERNEL_DS, %rcx
> +	movq %rcx, SS(%rsp)
> +	movq $__KERNEL_CS, %rcx
> +	movq %rcx, CS(%rsp)
> +	/* Stack - skipping return address */
> +	leaq SS+16(%rsp), %rcx
> +	movq %rcx, RSP(%rsp)
> +
> +	/* regs go into 4th parameter */
> +	leaq (%rsp), %rcx
> +
> +GLOBAL(ftrace_regs_call)
> +	call ftrace_stub
> +
> +	/* restore the rest of pt_regs */
> +	movq R15(%rsp), %r15
> +	movq R14(%rsp), %r14
> +	movq R13(%rsp), %r13
> +	movq R12(%rsp), %r12
> +	movq R10(%rsp), %r10
> +	movq RBP(%rsp), %rbp
> +	movq RBX(%rsp), %rbx
> +


> +	/* Restore flags */
> +	pushq EFLAGS(%rsp)
> +	popfq
> +
> +	MCOUNT_RESTORE_FRAME

Here, if MCOUNT_RESTORE_FRAME has skip too, I think you don't
need to restore flags before restoring other registers, like
below;

	MCOUNT_RESTORE_FRAME 8
	popfq

And also, this will prevent to modify flags before return by
addq in MCOUNT_RESTORE_FRAME.

> +
> +	jmp ftrace_return
> +ftrace_restore_flags:
> +	popfq
> +	jmp  ftrace_stub
> +
> +END(ftrace_regs_caller)
> +

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


