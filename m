Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0DLXUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:20:24 -0400
Received: from ozlabs.org ([203.10.76.45]:53572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0DLXUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:20:23 -0400
Date: Tue, 13 Apr 2010 09:17:36 +1000
From: Anton Blanchard <anton@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: TRACE_EVENT() declarations belong to include/trace/
Message-ID: <20100412231736.GH11751@kryten>
References: <20100412214511.GA2699@Krystal>
 <20100412220451.GG8285@nowhere>
 <20100412221736.GA2969@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412221736.GA2969@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> states that this is done for setups where no in-kernel handler is called. But
> it does not say if tracing the beginning and end of handle_IRQ_event() from
> kernel/irq/handle.c would fix the problem. That would be a lot neater than
> this arch-specific solution.

Unfortunately that misses this problem completely. On some versions of the
POWER hypervisor we can be presented with interrupts for our virtualisation
layer that get handled in the get_irq hypervisor call. The code looks like
this:


void do_IRQ(struct pt_regs *regs)
{
        struct pt_regs *old_regs = set_irq_regs(regs);
        unsigned int irq;

        trace_irq_entry(regs);

        irq_enter();

        check_stack_overflow();

        irq = ppc_md.get_irq();		<------------- jitter spikes here

        if (irq != NO_IRQ && irq != NO_IRQ_IGNORE)
                handle_one_irq(irq);
        else if (irq != NO_IRQ_IGNORE)
                __get_cpu_var(irq_stat).spurious_irqs++;


We've had HPC customers who have experienced jitter in their applications
caused by this and as a result I added the events so we can monitor it.

Since this is a POWER specific issue I'm happy to rename the trace events to
powerpc_irq_entry/exit. We could also look at changing the tracepoints, eg
putting it around the ppc_md.get_irq(), but I can't see how we can remove
them completely.

Anton
