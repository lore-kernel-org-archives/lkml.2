Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab0DHNwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:52:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42865 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab0DHNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xHdpZ7oX29UcqzGo1BZ4JDMxtTyESjHsiM3uQvejuBSow0w6jBmz0D2CUYvwfsgn01
         GIOfUU9J+l9Gdgpeeqza+yNADpuimLUulGQCI//viQ4KBX0xoVvk3FphCQpjbRz4/nlY
         X4Z0ye21qr6MROC/U4rLj1Ty9f1vgMASO+t3Y=
Subject: Re: [PATCH] perf: Fix unsafe frame rewinding with hot regs fetching
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Archs <linux-arch@vger.kernel.org>
In-Reply-To: <20100408123209.GA6096@nowhere>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
	 <1269568362-13690-6-git-send-regression-fweisbec@gmail.com>
	 <1270720640.2215.43.camel@edumazet-laptop>  <20100408123209.GA6096@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 15:52:26 +0200
Message-ID: <1270734746.2215.56.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 avril 2010 à 14:32 +0200, Frederic Weisbecker a écrit :


> 
> Can you please test this fix?
> 
> Thanks.
> 
> ---
> From 60d5c4e8498efc4a01abceef54ad3bc91993bf41 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Thu, 8 Apr 2010 14:05:50 +0200
> Subject: [PATCH] perf: Fix unsafe frame rewinding with hot regs fetching
> 
> When we fetch the hot regs and rewind to the nth caller, it
> might happen that we dereference a frame pointer outside the
> kernel stack boundaries, like in this example:
> 
> 	perf_trace_sched_switch+0xd5/0x120
>         schedule+0x6b5/0x860
>         retint_careful+0xd/0x21
> 
> Since we directly dereference a userspace frame pointer here while
> rewinding behind retint_careful, this may end up in a crash.
> 
> Fix this by simply using probe_kernel_address() when we rewind the
> frame pointer.
> 
> This issue will have a much more proper fix in the next version of the
> perf_arch_fetch_caller_regs() API that will only need to rewind to the
> first caller.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Archs <linux-arch@vger.kernel.org>
> ---
>  arch/x86/kernel/dumpstack.h |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
> index e39e771..e1a93be 100644
> --- a/arch/x86/kernel/dumpstack.h
> +++ b/arch/x86/kernel/dumpstack.h
> @@ -14,6 +14,8 @@
>  #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
>  #endif
>  
> +#include <linux/uaccess.h>
> +
>  extern void
>  show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
>  		unsigned long *stack, unsigned long bp, char *log_lvl);
> @@ -42,8 +44,10 @@ static inline unsigned long rewind_frame_pointer(int n)
>  	get_bp(frame);
>  
>  #ifdef CONFIG_FRAME_POINTER
> -	while (n--)
> -		frame = frame->next_frame;
> +	while (n--) {
> +		if (probe_kernel_address(&frame->next_frame, frame))
> +			break;
> +	}
>  #endif
>  
>  	return (unsigned long)frame;

Thanks, no more crash :)

Tested-by: Eric Dumazet <eric.dumazet@gmail.com>


