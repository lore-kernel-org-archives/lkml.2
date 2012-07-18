Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2GRLlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:41:13 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33737 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2GRLlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:41:08 -0400
X-AuditID: b753bd60-9f483ba000000655-75-5006a0d04fa3
X-AuditID: b753bd60-9f483ba000000655-75-5006a0d04fa3
Message-ID: <5006A0CF.5020003@hitachi.com>
Date: Wed, 18 Jul 2012 20:41:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH] x86_32: Return actual stack when requesting sp
 from regs
References: <1342208654.30075.22.camel@gandalf.stny.rr.com>
In-Reply-To: <1342208654.30075.22.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/14 4:44), Steven Rostedt wrote:
> 
> As x86_32 traps do not save sp when taken in kernel mode, we need to
> accommodate the sp when requesting to get the register.
> 
> This affects kprobes.
> 
> Before:
> 
>  # echo 'p:ftrace sys_read+4 s=%sp' > /debug/tracing/kprobe_events
>  # echo 1 > /debug/tracing/events/kprobes/enable
>  # cat trace
>             sshd-1345  [000] d...   489.117168: ftrace: (sys_read+0x4/0x70) s=b7e96768
>             sshd-1345  [000] d...   489.117191: ftrace: (sys_read+0x4/0x70) s=b7e96768
>              cat-1447  [000] d...   489.117392: ftrace: (sys_read+0x4/0x70) s=5a7
>              cat-1447  [001] d...   489.118023: ftrace: (sys_read+0x4/0x70) s=b77ad05f
>             less-1448  [000] d...   489.118079: ftrace: (sys_read+0x4/0x70) s=b7762e06
>             less-1448  [000] d...   489.118117: ftrace: (sys_read+0x4/0x70) s=b7764970
> 
> After:
>             sshd-1352  [000] d...   362.348016: ftrace: (sys_read+0x4/0x70) s=f3febfa8
>             sshd-1352  [000] d...   362.348048: ftrace: (sys_read+0x4/0x70) s=f3febfa8
>             bash-1355  [001] d...   362.348081: ftrace: (sys_read+0x4/0x70) s=f5075fa8
>             sshd-1352  [000] d...   362.348082: ftrace: (sys_read+0x4/0x70) s=f3febfa8
>             sshd-1352  [000] d...   362.690950: ftrace: (sys_read+0x4/0x70) s=f3febfa8
>             bash-1355  [001] d...   362.691033: ftrace: (sys_read+0x4/0x70) s=f5075fa8
> 
> [ I wonder if this should also go to stable? ]
> 

This obviously makes tracing output better on i386. Original %sp
gives nothing (or just misleading)...

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

NOTE: if someone needs to get kernel stack address from regs,
I recommend him to use kernel_stack_pointer() directly.

Thank you,

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-trace.git/arch/x86/include/asm/ptrace.h
> ===================================================================
> --- linux-trace.git.orig/arch/x86/include/asm/ptrace.h
> +++ linux-trace.git/arch/x86/include/asm/ptrace.h
> @@ -246,6 +246,15 @@ static inline unsigned long regs_get_reg
>  {
>  	if (unlikely(offset > MAX_REG_OFFSET))
>  		return 0;
> +#ifdef CONFIG_X86_32
> +	/*
> +	 * Traps from the kernel do not save sp and ss.
> +	 * Use the helper function to retrieve sp.
> +	 */
> +	if (offset == offsetof(struct pt_regs, sp) &&
> +	    regs->cs == __KERNEL_CS)
> +		return kernel_stack_pointer(regs);
> +#endif
>  	return *(unsigned long *)((unsigned long)regs + offset);
>  }

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


