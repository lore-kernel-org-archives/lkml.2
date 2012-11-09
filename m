Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2KIL4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:56:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54420 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2KIL4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:56:16 -0500
Date: Fri, 9 Nov 2012 11:56:08 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Geremy Condra <gcondra@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/4] arch/arm: move secure_computing into trace
Message-ID: <20121109115607.GA4489@mudshark.cambridge.arm.com>
References: <1352408373-25047-1-git-send-email-keescook@chromium.org>
 <1352408373-25047-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
In-Reply-To: <1352408373-25047-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Nov 2012 11:56:13.0644 (UTC) FILETIME=[3790F0C0:01CDBE71]
X-MC-Unique: 112110911561408301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One really minor nit...

On Thu, Nov 08, 2012 at 08:59:31PM +0000, Kees Cook wrote:
> There is very little difference in the TIF_SECCOMP and TIF_SYSCALL_WORK
> path in entry-common.S, so merge TIF_SECCOMP into TIF_SYSCALL_WORK and
> move seccomp into the syscall_trace_enter() handler.
> 
> Expanded some of the tracehook logic into the callers to make this code
> more readable. Since tracehook needs to do register changing, this portion
> is best left in its own function instead of copy/pasting into the callers.
> 
> Additionally, the return value for secure_computing() is now checked
> and a -1 value will result in the system call being skipped.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

[...]

> @@ -944,19 +939,39 @@ static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
>  
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>  {
> -	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_ENTER);
> +	current_thread_info()->syscall = scno;
> +
> +	/* do the secure computing check first */
> +	if (secure_computing(scno) == -1) {
> +		/* seccomp failures shouldn't expose any additional code. */
> +		scno = -1;
> +		goto out;
> +	}

Can we just return -1 here instead please? The whole jump label code makes
this code messier than it needs to be and there's no cleanup to be done.

> +	if (test_thread_flag(TIF_SYSCALL_TRACE))
> +		scno = tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
> +
>  	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>  		trace_sys_enter(regs, scno);
> +
>  	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
>  			    regs->ARM_r2, regs->ARM_r3);
> +
> +out:
>  	return scno;
>  }

Cheers,

Will

