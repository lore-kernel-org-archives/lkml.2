Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab2AZIja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 03:39:30 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39605 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2AZIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 03:39:28 -0500
X-AuditID: b753bd60-a1286ba000000655-b1-4f21113d4e8a
X-AuditID: b753bd60-a1286ba000000655-b1-4f21113d4e8a
Message-ID: <4F211126.1090204@hitachi.com>
Date: Thu, 26 Jan 2012 17:39:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: Re: [PATCH RT 1/2 v2] x86: Do not disable preemption in int3 on
 32bit
References: <20120125143231.196670014@goodmis.org> <20120125143520.086175333@goodmis.org>
In-Reply-To: <20120125143520.086175333@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/25 23:32), Steven Rostedt wrote:
> Preemption must be disabled before enabling interrupts in do_trap
> on x86_64 because the stack in use for int3 and debug is a per CPU
> stack set by th IST. But in 32bit, the stack still belongs to the
> current task and there is no problem in scheduling out the task.
> 
> Keep preemption enabled on X86_32 when enabling interrupts for
> do_trap().
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Hmm, I think you'd better change caller side, because the
function itself has "preempt" in its name. I think it can
easily mislead other people.

Thank you,

> 
> Index: linux-rt.git/arch/x86/kernel/traps.c
> ===================================================================
> --- linux-rt.git.orig/arch/x86/kernel/traps.c
> +++ linux-rt.git/arch/x86/kernel/traps.c
> @@ -89,7 +89,14 @@ static inline void conditional_sti(struc
>  
>  static inline void preempt_conditional_sti(struct pt_regs *regs)
>  {
> +#ifdef CONFIG_X86_64
> +	/*
> +	 * X86_64 uses a per CPU stack for certain traps like int3.
> +	 * We must disable preemption, otherwise we can corrupt the
> +	 * stack if the task is scheduled out with this stack.
> +	 */
>  	inc_preempt_count();
> +#endif
>  	if (regs->flags & X86_EFLAGS_IF)
>  		local_irq_enable();
>  }
> @@ -104,7 +111,9 @@ static inline void preempt_conditional_c
>  {
>  	if (regs->flags & X86_EFLAGS_IF)
>  		local_irq_disable();
> +#ifdef CONFIG_X86_64
>  	dec_preempt_count();
> +#endif
>  }
>  
>  static void __kprobes
> 

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
