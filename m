Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1JUPIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 11:08:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47981 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1JUPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 11:08:12 -0400
Date: Fri, 21 Oct 2011 20:12:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/X] uprobes: x86: introduce abort_xol()
Message-ID: <20111021144207.GN11831@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20111015190007.GA30243@redhat.com>
 <20111019215139.GA16395@redhat.com>
 <20111019215326.GF16395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111019215326.GF16395@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102115-7282-0000-0000-000002B6289B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Oleg,

> A separate "patch", just to emphasize that I do not know what
> actually abort_xol() should do! I do not understand this asm
> magic.
> 
> This patch simply changes regs->ip back to the probed insn,
> obviously this is not enough to handle UPROBES_FIX_*. Please
> take care.
> 
> If it is not clear, abort_xol() is needed when we should
> re-execute the original insn (replaced with int3), see the
> next patch.

We should be removing the breakpoint in abort_xol().
Otherwise if we just set the instruction pointer to int3 and signal a
sigill, then the user may be confused why a breakpoint is generating
SIGILL.

> ---
>  arch/x86/include/asm/uprobes.h |    1 +
>  arch/x86/kernel/uprobes.c      |    9 +++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index f0fbdab..6209da1 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -51,6 +51,7 @@ extern void set_instruction_pointer(struct pt_regs *regs, unsigned long vaddr);
>  extern int pre_xol(struct uprobe *uprobe, struct pt_regs *regs);
>  extern int post_xol(struct uprobe *uprobe, struct pt_regs *regs);
>  extern bool xol_was_trapped(struct task_struct *tsk);
> +extern void abort_xol(struct pt_regs *regs);
>  extern int uprobe_exception_notify(struct notifier_block *self,
>  				       unsigned long val, void *data);
>  #endif	/* _ASM_UPROBES_H */
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index c861c27..bc11a89 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -511,6 +511,15 @@ bool xol_was_trapped(struct task_struct *tsk)
>  	return false;
>  }
> 
> +void abort_xol(struct pt_regs *regs)
> +{
> +	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> +	// !!! Dear Srikar and Ananth, please implement me !!!
> +	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> +	struct uprobe_task *utask = current->utask;
> +	regs->ip = utask->vaddr;

nit:
Shouldnt we be setting the ip to the next instruction after this
instruction?

> +}
> +
>  /*
>   * Called after single-stepping. To avoid the SMP problems that can
>   * occur when we temporarily put back the original opcode to


I have applied all your patches and ran tests, the tests are all
passing.

I will fold them into my patches and send them out.

-- 
Thanks and Regards
Srikar

