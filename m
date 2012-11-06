Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2KFUx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:53:29 -0500
Received: from ozlabs.org ([203.10.76.45]:45751 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KFUx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:53:27 -0500
From: Michael Neuling <mikey@neuling.org>
To: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, fweisbec@redhat.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH] Enable hardware breakpoint upon re-registering
In-reply-to: <20121105081527.29141.11384.stgit@aravinda>
References: <20121105081527.29141.11384.stgit@aravinda>
Comments: In-reply-to Aravinda Prasad <aravinda@linux.vnet.ibm.com>
   message dated "Mon, 05 Nov 2012 13:45:28 +0530."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Wed, 07 Nov 2012 07:53:26 +1100
Message-ID: <24260.1352235206@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aravinda Prasad <aravinda@linux.vnet.ibm.com> wrote:

> On powerpc, ptrace will disable hardware breakpoint request once the
> breakpoint is hit. It is the responsibility of the caller to set it
> again. However, when the caller sets the hardware breakpoint again
> using ptrace(PTRACE_SET_DEBUGREG, child_pid, 0, addr), the hardware
> breakpoint is not enabled.
> 
> While gdb's approach is to unregister and re-register the hardware
> breakpoint every time the breakpoint is hit - which is working fine,
> this could affect other programs trying to re-register hardware
> breakpoint without unregistering.
> 
> This patch enables hardware breakpoint if the caller is re-registering.
> 
> Signed-off-by: Aravinda Prasad <aravinda@linux.vnet.ibm.com>

Passes my tests here and I don't think it'll break existing gdb.  So FWIW

Acked-by: Michael Neuling <mikey@neuling.org>

Thanks!

> ---
>  arch/powerpc/kernel/ptrace.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 79d8e56..09371d0 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -952,6 +952,10 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
>  		arch_bp_generic_fields(data &
>  					(DABR_DATA_WRITE | DABR_DATA_READ),
>  							&attr.bp_type);
> +
> +		/* Enable breakpoint */
> +		attr.disabled = false;
> +
>  		ret =  modify_user_hw_breakpoint(bp, &attr);
>  		if (ret) {
>  			ptrace_put_breakpoints(task);
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
