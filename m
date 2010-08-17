Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0HQPKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:10:15 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49823 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0HQPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:10:12 -0400
X-AuditID: b753bd60-a5cd7ba000000a18-6a-4c6aa65070ce
Message-ID: <4C6AA64E.2050600@hitachi.com>
Date: Wed, 18 Aug 2010 00:10:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: KUMANO Syuhei <kumano.prog@gmail.com>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] kprobes/x86: Fix the return address of multiple kretprobes
References: <1281853084.3254.11.camel@camp10-laptop>
In-Reply-To: <1281853084.3254.11.camel@camp10-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KUMANO Syuhei wrote:
> Fix the return address of subsequent kretprobes when multiple
> kretprobes are set on the same function.
> 
> For example:
>  # cd /sys/kernel/debug/tracing
>  # echo "r:event1 sys_symlink" > kprobe_events
>  # echo "r:event2 sys_symlink" >> kprobe_events
>  # echo 1 > events/kprobes/enable
>  # ln -s /tmp/foo /tmp/bar
>  (without this patch)
>  # cat trace
>               ln-897   [000] 20404.133727: event1: (kretprobe_trampoline+0x0/0x4c <- sys_symlink)
>               ln-897   [000] 20404.133747: event2: (system_call_fastpath+0x16/0x1b <- sys_symlink)
>  (with this patch)
>  # cat trace
>               ln-740   [000] 13799.491076: event1: (system_call_fastpath+0x16/0x1b <- sys_symlink)
>               ln-740   [000] 13799.491096: event2: (system_call_fastpath+0x16/0x1b <- sys_symlink)
> 

Yeah, I'm OK for this fix.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Ingo, could you pull this on your x86/bugfix tree?

Thank you,

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: linux-kernel@vger.kernel.org
> Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: KUMANO Syuhei <kumano.prog@gmail.com>
> ---
>  arch/x86/kernel/kprobes.c |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 675879b..5220e14 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -707,6 +707,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
>  	struct hlist_node *node, *tmp;
>  	unsigned long flags, orig_ret_address = 0;
>  	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
> +	kprobe_opcode_t *correct_ret_addr = NULL;
>  
>  	INIT_HLIST_HEAD(&empty_rp);
>  	kretprobe_hash_lock(current, &head, &flags);
> @@ -738,14 +739,34 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
>  			/* another task is sharing our hash bucket */
>  			continue;
>  
> +		orig_ret_address = (unsigned long)ri->ret_addr;
> +
> +		if (orig_ret_address != trampoline_address)
> +			/*
> +			 * This is the real return address. Any other
> +			 * instances associated with this task are for
> +			 * other calls deeper on the call stack
> +			 */
> +			break;
> +	}
> +
> +	kretprobe_assert(ri, orig_ret_address, trampoline_address);
> +
> +	correct_ret_addr = ri->ret_addr;
> +	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
> +		if (ri->task != current)
> +			/* another task is sharing our hash bucket */
> +			continue;
> +
> +		orig_ret_address = (unsigned long)ri->ret_addr;
>  		if (ri->rp && ri->rp->handler) {
>  			__get_cpu_var(current_kprobe) = &ri->rp->kp;
>  			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
> +			ri->ret_addr = correct_ret_addr;
>  			ri->rp->handler(ri, regs);
>  			__get_cpu_var(current_kprobe) = NULL;
>  		}
>  
> -		orig_ret_address = (unsigned long)ri->ret_addr;
>  		recycle_rp_inst(ri, &empty_rp);
>  
>  		if (orig_ret_address != trampoline_address)
> @@ -757,8 +778,6 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
>  			break;
>  	}
>  
> -	kretprobe_assert(ri, orig_ret_address, trampoline_address);
> -
>  	kretprobe_hash_unlock(current, &flags);
>  
>  	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {

