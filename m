Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2DZKnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:43:51 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40993 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2DZKnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:43:50 -0400
X-AuditID: b753bd60-93c60ba000002c51-7f-4f9926e40ec6
X-AuditID: b753bd60-93c60ba000002c51-7f-4f9926e40ec6
Message-ID: <4F9926E2.4010100@hitachi.com>
Date: Thu, 26 Apr 2012 19:43:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 4/5] ftrace/x86: Have arch x86_64 use breakpoints instead
 of stop machine
References: <20120425184830.325105778@goodmis.org> <20120425184930.873468066@goodmis.org>
In-Reply-To: <20120425184930.873468066@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/26 3:48), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This method changes x86 to add a breakpoint to the mcount locations
> instead of calling stop machine.
> 
> Now that iret can be handled by NMIs, we perform the following to
> update code:
> 
> 1) Add a breakpoint to all locations that will be modified
> 
> 2) Sync all cores
> 
> 3) Update all locations to be either a nop or call (except breakpoint
>    op)
> 
> 4) Sync all cores
> 
> 5) Remove the breakpoint with the new code.
> 
> 6) Sync all cores
> 
> [
>   Added updates that Masami suggested:
>    Use unlikely(modifying_ftrace_code) in int3 trap to keep kprobes efficient.
>    Don't use NOTIFY_* in ftrace handler in int3 as it is not a notifier.
> ]

I just have a few comments :)

[...]
> +int modifying_ftrace_code __read_mostly;
> +
> +/*
> + * A breakpoint was added to the code address we are about to
> + * modify, and this is the handle that will just skip over it.
> + * We are either changing a nop into a trace call, or a trace
> + * call to a nop. While the change is taking place, we treat
> + * it just like it was a nop.
> + */
> +int ftrace_int3_handler(int cmd, const char *str,
> +		 struct pt_regs *regs, long err, int trap, int sig)
> +{
> +	if (!modifying_ftrace_code || cmd != DIE_INT3 || !regs)
> +		return 0;
> +

At this moment, all of these checks are meaningless, because
this is not a handler but just a fixup code in int3 isr. :)
So, I think you can just define "int ftrace_int3_fixup(regs)"
for this purpose.

> +	if (!ftrace_location(regs->ip - 1))
> +		return 0;
> +
> +	regs->ip += MCOUNT_INSN_SIZE - 1;
> +
> +	return 1;
> +}

[...]

> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index ff9281f1..1712485 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -50,6 +50,7 @@
>  #include <asm/processor.h>
>  #include <asm/debugreg.h>
>  #include <linux/atomic.h>
> +#include <asm/ftrace.h>
>  #include <asm/traps.h>
>  #include <asm/desc.h>
>  #include <asm/i387.h>
> @@ -303,8 +304,14 @@ gp_in_kernel:
>  }
>  
>  /* May run on IST stack. */
> -dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
> +dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
>  {
> +#ifdef CONFIG_FUNCTION_TRACER

I guess CONFIG_DYNAMIC_FTRACE ?

> +	/* ftrace must be first, everything else may cause a recursive crash */
> +	if (unlikely(modifying_ftrace_code) &&
> +	    ftrace_int3_handler(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP))
> +		return;
> +#endif

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
