Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab1LNNaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:30:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48224 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752724Ab1LNNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:30:28 -0500
Date: Wed, 14 Dec 2011 08:30:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86: Allow NMIs to hit breakpoints in i386
Message-ID: <20111214133025.GA2882@Krystal>
References: <20111214025237.457632996@goodmis.org> <20111214025253.519573056@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214025253.519573056@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:22:16 up 385 days, 18:25,  2 users,  load average: 0.04, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]> From: Steven Rostedt <srostedt@redhat.com>
> +#define nmi_preprocess(regs)						\
> +	do {								\
> +		if (__get_cpu_var(nmi_state) != NMI_NOT_RUNNING) {	\
> +			__get_cpu_var(nmi_state) = NMI_LATCHED;		\
> +			return;						\
> +		}							\
> +	nmi_restart:							\
> +		__get_cpu_var(nmi_state) = NMI_EXECUTING;		\
> +	} while (0)
> +
> +#define nmi_postprocess()						\
> +	do {								\
> +		if (cmpxchg(&__get_cpu_var(nmi_state),			\
> +		    NMI_EXECUTING, NMI_NOT_RUNNING) != NMI_EXECUTING)	\
> +			goto nmi_restart;				\
> +	} while (0)
> +
[...]
> +dotraplinkage notrace __kprobes void
> +do_nmi(struct pt_regs *regs, long error_code)
> +{
> +	nmi_preprocess(regs);
> +
>  	nmi_enter();
>  
>  	inc_irq_stat(__nmi_count);
> @@ -428,8 +515,7 @@ do_nmi(struct pt_regs *regs, long error_code)
>  
>  	nmi_exit();
>  
> -	if (unlikely(update_debug_stack))
> -		reset_debug_stack();
> +	nmi_postprocess();

Just to make sure I understand: if an NMI nests over do_nmi between
nmi_postprocess() and the following iret (in which case the CPU is in
state NMI_NOT_RUNNING), we will end up with two NMI handlers nested on
the stack, right ? Given that there is no upper-bound on the nesting
level of this situation (although nesting like this more than once is
extremely unlikely), is this side-effect something we should care about
in terms of stack space usage ? Also, is the stack dump OOPS handler
aware of this stack layout that was until now impossible ?

Thanks,

Mathieu

>  }
>  
>  void stop_nmi(void)
> -- 
> 1.7.7.3
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
