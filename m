Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936088Ab2KAU0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:26:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35187 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2KAU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:26:17 -0400
Date: Thu, 1 Nov 2012 20:25:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3/4] arch/arm: allow a scno of -1 to not cause a SIGILL
Message-ID: <20121101202531.GT21164@n2100.arm.linux.org.uk>
References: <1351799199-6853-1-git-send-email-keescook@chromium.org> <1351799199-6853-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351799199-6853-4-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 12:46:38PM -0700, Kees Cook wrote:
> From: Will Drewry <wad@chromium.org>
> 
> On tracehook-friendly platforms, a system call number of -1 falls
> through without running much code or taking much action.
> 
> ARM is different.  This adds a lightweight check to arm_syscall()
> to make sure that ARM behaves the same way.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm/kernel/traps.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index b0179b8..f303ea6 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -540,6 +540,10 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
>  	struct thread_info *thread = current_thread_info();
>  	siginfo_t info;
>  
> +	/* Emulate/fallthrough. */
> +	if (no == -1)
> +		return regs->ARM_r0;
> +

This won't work properly with OABI.  The problem is that OABI has an
offset on its syscall numbers which is removed/added at appropriate
times, and this is one of the places where it's put back.  So you end
up with -1 XOR 0x900000 here, not -1.

It'd probably be better to do this check in the asm code here, which
prevents that yuckyness from affecting this.

__sys_trace:
        mov     r1, scno
        add     r0, sp, #S_OFF
        bl      syscall_trace_enter

        adr     lr, BSYM(__sys_trace_return)    @ return address
        mov     scno, r0                        @ syscall number (possibly new)
        add     r1, sp, #S_R0 + S_OFF           @ pointer to regs
        cmp     scno, #NR_syscalls              @ check upper syscall limit
        ldmccia r1, {r0 - r6}                   @ have to reload r0 - r6
        stmccia sp, {r4, r5}                    @ and update the stack args
        ldrcc   pc, [tbl, scno, lsl #2]         @ call sys_* routine
+	cmp	scno, #-1
        bne     2b
+	b	ret_slow_syscall

