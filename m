Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0DMA1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 20:27:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37686 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754352Ab0DMA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 20:27:40 -0400
Date: Mon, 12 Apr 2010 20:27:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Anton Blanchard <anton@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: TRACE_EVENT() declarations belong to include/trace/
Message-ID: <20100413002738.GA9495@Krystal>
References: <20100412214511.GA2699@Krystal> <20100412220451.GG8285@nowhere> <20100412221736.GA2969@Krystal> <20100412231736.GH11751@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412231736.GH11751@kryten>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:24:44 up 80 days,  3:01,  7 users,  load average: 0.07, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anton Blanchard (anton@samba.org) wrote:
> 
> Hi,
> 
> > states that this is done for setups where no in-kernel handler is called. But
> > it does not say if tracing the beginning and end of handle_IRQ_event() from
> > kernel/irq/handle.c would fix the problem. That would be a lot neater than
> > this arch-specific solution.
> 
> Unfortunately that misses this problem completely. On some versions of the
> POWER hypervisor we can be presented with interrupts for our virtualisation
> layer that get handled in the get_irq hypervisor call. The code looks like
> this:
> 
> 
> void do_IRQ(struct pt_regs *regs)
> {
>         struct pt_regs *old_regs = set_irq_regs(regs);
>         unsigned int irq;
> 
>         trace_irq_entry(regs);
> 
>         irq_enter();
> 
>         check_stack_overflow();
> 
>         irq = ppc_md.get_irq();		<------------- jitter spikes here
> 
>         if (irq != NO_IRQ && irq != NO_IRQ_IGNORE)
>                 handle_one_irq(irq);
>         else if (irq != NO_IRQ_IGNORE)
>                 __get_cpu_var(irq_stat).spurious_irqs++;
> 
> 
> We've had HPC customers who have experienced jitter in their applications
> caused by this and as a result I added the events so we can monitor it.
> 
> Since this is a POWER specific issue I'm happy to rename the trace events to
> powerpc_irq_entry/exit. We could also look at changing the tracepoints, eg
> putting it around the ppc_md.get_irq(), but I can't see how we can remove
> them completely.

OK, I see. How about arch_irq_entry/exit() ?

This way, if we need to do something similar on another arch at the
architecture-level, we can use the same names.

Thanks,

Mathieu

> 
> Anton

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
