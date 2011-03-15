Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab1COOSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:18:23 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41058 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755888Ab1COOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:18:22 -0400
Date: Tue, 15 Mar 2011 10:18:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: stop machine text poke should issue sync core (v2)
Message-ID: <20110315141817.GA27124@Krystal>
References: <20110303160137.GB1590@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303160137.GB1590@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:16:12 up 111 days, 19:19,  5 users,  load average: 0.03, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Intel Archiecture Software Developer's Manual section 7.1.3 specifies that a
> core serializing instruction such as "cpuid" should be executed on _each_ core
> before the new instruction is made visible.

Hi,

Is anyone willing to merge this fix into the x86 tree ?

Thanks,

Mathieu

> 
> Failure to do so can lead to unspecified behavior (Intel XMC erratas include
> General Protection Fault in the list), so we should avoid this at all cost.
> 
> This problem can affect modified code executed by interrupt handlers after
> interrupt are re-enabled at the end of stop_machine, because no core serializing
> instruction is executed between the code modification and the moment interrupts
> are reenabled.
> 
> Because stop_machine_text_poke performs the text modification from the first CPU
> decrementing stop_machine_first, modified code executed in thread context is
> also affected by this problem. To explain why, we have to split the CPUs in two
> categories: the CPU that initiates the text modification (calls text_poke_smp)
> and all the others. The scheduler, executed on all other CPUs after
> stop_machine, issues an "iret" core serializing instruction, and therefore
> handles core serialization for all these CPUs. However, the text modification
> initiator can continue its execution on the same thread and access the modified
> text without any scheduler call. Given that the CPU that initiates the code
> modification is not guaranteed to be the one actually performing the code
> modification, it falls into the XMC errata.
> 
> Q: Isn't this executed from an IPI handler, which will return with IRET (a
>    serializing instruction) anyway?
> A: No, now stop_machine uses per-cpu workqueue, so that handler will be
>    executed from worker threads. There is no iret anymore.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Arjan van de Ven <arjan@infradead.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/alternative.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-tip/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-tip.orig/arch/x86/kernel/alternative.c
> +++ linux-tip/arch/x86/kernel/alternative.c
> @@ -620,7 +620,12 @@ static int __kprobes stop_machine_text_p
>  		flush_icache_range((unsigned long)p->addr,
>  				   (unsigned long)p->addr + p->len);
>  	}
> -
> +	/*
> +	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
> +	 * that a core serializing instruction such as "cpuid" should be
> +	 * executed on _each_ core before the new instruction is made visible.
> +	 */
> +	sync_core();
>  	return 0;
>  }
>  
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
