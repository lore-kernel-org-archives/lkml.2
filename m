Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2IGIob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:44:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42193 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2IGIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:44:28 -0400
X-AuditID: b753bd60-90ac1ba0000047ca-b2-5049b3e91406
X-AuditID: b753bd60-90ac1ba0000047ca-b2-5049b3e91406
Message-ID: <5049B3E7.1010208@hitachi.com>
Date: Fri, 07 Sep 2012 17:44:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip 4/4] [BUGFIX] kprobes/x86: Fix to support jprobes
 on ftrace-based kprobe
References: <20120905143045.10329.64502.stgit@localhost.localdomain> <20120905143125.10329.90836.stgit@localhost.localdomain>
In-Reply-To: <20120905143125.10329.90836.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/05 23:31), Masami Hiramatsu wrote:
> Fix kprobes/x86 to support jprobes on ftrace-based kprobes.
> Because of -mfentry support of ftrace, ftrace is now put
> on the beginning of function where jprobes are put.
> 
> Originally ftrace-based kprobes doesn't support jprobe
> because it will change regs->ip and ftrace doesn't support
> changing IP and ftrace itself doesn't conflict jprobe.
> However, ftrace -mfentry support moves mcount call on the
> top of functions where jprobes are put. This means that
> jprobe always conflicts with ftrace-based kprobe and fails.
> 
> This patch allows ftrace-based kprobes to support jprobes
> by allowing to modify regs->ip and kprobes breakpoint
> handler also allows to skip singlestepping because there
> is a ftrace call (not an original instruction).
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

This should have a below line...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks!

> ---
> 
>  arch/x86/kernel/kprobes.c |   42 +++++++++++++++++++++++++++++-------------
>  kernel/kprobes.c          |    3 ---
>  2 files changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index f49f60c..b7c2a85 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -541,6 +541,8 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
>  	return 1;
>  }
>  
> +static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
> +				      struct kprobe_ctlblk *kcb);
>  /*
>   * Interrupts are disabled on entry as trap3 is an interrupt gate and they
>   * remain disabled throughout this function.
> @@ -599,6 +601,12 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  	} else if (kprobe_running()) {
>  		p = __this_cpu_read(current_kprobe);
>  		if (p->break_handler && p->break_handler(p, regs)) {
> +#ifdef KPROBES_CAN_USE_FTRACE
> +			if (kprobe_ftrace(p)) {
> +				skip_singlestep(p, regs, kcb);
> +				return 1;
> +			}
> +#endif
>  			setup_singlestep(p, regs, kcb, 0);
>  			return 1;
>  		}
> @@ -1053,6 +1061,21 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  #ifdef KPROBES_CAN_USE_FTRACE
> +static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
> +				      struct kprobe_ctlblk *kcb)
> +{
> +	/*
> +	 * Emulate singlestep (and also recover regs->ip)
> +	 * as if there is a 5byte nop
> +	 */
> +	regs->ip = (unsigned long)p->addr + MCOUNT_INSN_SIZE;
> +	if (unlikely(p->post_handler)) {
> +		kcb->kprobe_status = KPROBE_HIT_SSDONE;
> +		p->post_handler(p, regs, 0);
> +	}
> +	__this_cpu_write(current_kprobe, NULL);
> +}
> +
>  /* Ftrace callback handler for kprobes */
>  void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
>  				     struct ftrace_ops *ops, struct pt_regs *regs)
> @@ -1077,19 +1100,12 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
>  
>  		__this_cpu_write(current_kprobe, p);
>  		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> -		if (p->pre_handler)
> -			p->pre_handler(p, regs);
> -
> -		if (unlikely(p->post_handler)) {
> -			/*
> -			 * Emulate singlestep (and also recover regs->ip)
> -			 * as if there is a 5byte nop
> -			 */
> -			regs->ip = ip + MCOUNT_INSN_SIZE;
> -			kcb->kprobe_status = KPROBE_HIT_SSDONE;
> -			p->post_handler(p, regs, 0);
> -		}
> -		__this_cpu_write(current_kprobe, NULL);
> +		if (!p->pre_handler || !p->pre_handler(p, regs))
> +			skip_singlestep(p, regs, kcb);
> +		/*
> +		 * If pre_handler returns !0, it sets regs->ip and
> +		 * resets current kprobe.
> +		 */
>  	}
>  end:
>  	local_irq_restore(flags);
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 35b4315..098f396 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1418,9 +1418,6 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
>  		/* Given address is not on the instruction boundary */
>  		if ((unsigned long)p->addr != ftrace_addr)
>  			return -EILSEQ;
> -		/* break_handler (jprobe) can not work with ftrace */
> -		if (p->break_handler)
> -			return -EINVAL;
>  		p->flags |= KPROBE_FLAG_FTRACE;
>  #else	/* !KPROBES_CAN_USE_FTRACE */
>  		return -EINVAL;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


