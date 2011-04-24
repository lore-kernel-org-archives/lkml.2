Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1DXIEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 04:04:34 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40333 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1DXIE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 04:04:28 -0400
Date: Sun, 24 Apr 2011 13:34:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LPPC <linuxppc-dev@lists.ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: Re: [PATCH 3/5] powerpc, hw_breakpoints: Fix racy access to ptrace
 breakpoints
Message-ID: <20110424080414.GB1958@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1302284067-7860-4-git-send-email-fweisbec@gmail.com>
 <1303478187-2367-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303478187-2367-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 03:16:27PM +0200, Frederic Weisbecker wrote:
> (resend with ppc list in cc)
> 
> While the tracer accesses ptrace breakpoints, the child task may
> concurrently exit due to a SIGKILL and thus release its breakpoints
> at the same time. We can then dereference some freed pointers.
> 
> To fix this, hold a reference on the child breakpoints before
> manipulating them.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: v2.6.33.. <stable@kernel.org>
> ---
>  arch/powerpc/kernel/ptrace.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 55613e3..4edeeb3 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -1591,7 +1591,10 @@ long arch_ptrace(struct task_struct *child, long request,
>  	}
> 
>  	case PTRACE_SET_DEBUGREG:
> +		if (ptrace_get_breakpoints(child) < 0)
> +			return -ESRCH;
>  		ret = ptrace_set_debugreg(child, addr, data);
> +		ptrace_put_breakpoints(child);
>  		break;
> 
>  #ifdef CONFIG_PPC64
> -- 
> 1.7.3.2
>

Hi Frederic,
	Looks fine to me.

Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>

Thanks,
K.Prasad 
