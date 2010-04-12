Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0DLWRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:17:40 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56288 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754236Ab0DLWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:17:39 -0400
Date: Mon, 12 Apr 2010 18:17:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Anton Blanchard <anton@samba.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: TRACE_EVENT() declarations belong to include/trace/
Message-ID: <20100412221736.GA2969@Krystal>
References: <20100412214511.GA2699@Krystal> <20100412220451.GG8285@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412220451.GG8285@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:15:06 up 80 days, 52 min,  2 users,  load average: 0.29, 0.09,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Mon, Apr 12, 2010 at 05:45:11PM -0400, Mathieu Desnoyers wrote:
> > Why are there TRACE_EVENT() declarations in arch/powerpc/include/asm/trace.h for
> > irq_entry/exit ?
> > 
> > What's so special about them that they cannot be put in linux/trace/ ?
> > 
> > I'm all for the trace_irq_entry/exit instrumentation, but I don't see any good
> > in adding event declarations outside of include/trace/.
> > 
> > Thanks,
> 
> 
> Yeah,
> 
> If this is to trace all irqs, then it seems to me the wrong way.
> We already have generic irq_handler_entry and irq_handler_exit trace events.

The commit changelog :

<quote>
commit 1bf4af165050d90ea6659ffb2536ec8ca783aab5
Author: Anton Blanchard <anton@samba.org>
Date:   Mon Oct 26 18:47:42 2009 +0000

    powerpc: tracing: Add powerpc tracepoints for interrupt entry and exit
    
    This adds powerpc-specific tracepoints for interrupt entry and exit.
    
    While we already have generic irq_handler_entry and irq_handler_exit
    tracepoints there are cases on our virtualised powerpc machines where an
    interrupt is presented to the OS, but subsequently handled by the hypervisor.
    This means no OS interrupt handler is invoked.
    
    Here is an example on a POWER6 machine with the patch below applied:
    
    <idle>-0     [006]  3243.949840744: irq_entry: pt_regs=c0000000ce31fb10
    <idle>-0     [006]  3243.949850520: irq_exit: pt_regs=c0000000ce31fb10
    
    <idle>-0     [007]  3243.950218208: irq_entry: pt_regs=c0000000ce323b10
    <idle>-0     [007]  3243.950224080: irq_exit: pt_regs=c0000000ce323b10
    
    <idle>-0     [000]  3244.021879320: irq_entry: pt_regs=c000000000a63aa0
    <idle>-0     [000]  3244.021883616: irq_handler_entry: irq=87 handler=eth0
    <idle>-0     [000]  3244.021887328: irq_handler_exit: irq=87 return=handled
    <idle>-0     [000]  3244.021897408: irq_exit: pt_regs=c000000000a63aa0
    
    Here we see two phantom interrupts (no handler was invoked), followed
    by a real interrupt for eth0. Without the tracepoints in this patch we
    would have missed the phantom interrupts.
</quote>

states that this is done for setups where no in-kernel handler is called. But it
does not say if tracing the beginning and end of handle_IRQ_event() from
kernel/irq/handle.c would fix the problem. That would be a lot neater than this
arch-specific solution.

Thanks,

Mathieu

> 
> May be those in powerpc are here to get the spurious irqs by computing
> a diff between generic and arch irq events? In which case
> it would be better to get dedicated spurious irq tracepoints.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
