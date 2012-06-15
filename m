Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2FODDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:03:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43622 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2FODDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:03:04 -0400
X-AuditID: b753bd60-982efba000000f6c-a8-4fdaa5e56074
X-AuditID: b753bd60-982efba000000f6c-a8-4fdaa5e56074
Message-ID: <4FDAA5E2.1040608@hitachi.com>
Date: Fri, 15 Jun 2012 12:02:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 03/13 v2] ftrace: Return pt_regs to function trace
 callback
References: <20120612224327.426900129@goodmis.org> <20120612225424.709165437@goodmis.org>
In-Reply-To: <20120612225424.709165437@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Return as the 4th paramater to the function tracer callback the pt_regs.
> 
> Currently x86_64 just passes NULL as the regs arguement. Later patches
> that implement regs passing will require having the ftrace_ops set the
> SAVE_REGS flag, which will tell the arch to take the time to pass a
> full set of pt_regs to the ftrace_ops callback function. If the arch
> does not support it then it should pass NULL.

Hmm, I think the x86-64 part of this patch would be better to be separated
with x86-64 part of [5/13], so that I can easily review the change...
Another reason is that this patch doesn't define ARCH_SUPPORTS_FTRACE_SAVE_REGS
on x86_64 too...


> A ftrace_ops call back can either check if the macro ARCH_SUPPORTS_FTRACE_SAVE_REGS
> is defined, or it can check if regs is NULL. As it will be NULL if
> it is not supported by the arch even if the SAVE_REGS flag is set.
> 
> If an arch can pass full regs, then it should define:
>  ARCH_SUPPORTS_FTRACE_SAVE_REGS to 1
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[...]
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 2b4f94c..83d8ae0 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -80,7 +80,11 @@ ENTRY(ftrace_caller)
>  	MCOUNT_SAVE_FRAME
>  
>  	leaq function_trace_op, %rdx
> -	movq 0x38(%rsp), %rdi
> +
> +	/* regs go into 4th parameter (but make it NULL) */
> +	movq $0, %rcx

There is no ARCH_SUPPORTS_FTRACE_SAVE_REGS, so I think you
don't need to clear rcx at least this time.

Another generic ftrace part of this patch is good to me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
