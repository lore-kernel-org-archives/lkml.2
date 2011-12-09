Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1LINCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:02:20 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45786 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751394Ab1LINCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:02:18 -0500
Date: Fri, 9 Dec 2011 08:02:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
Message-ID: <20111209130216.GA14718@Krystal>
References: <20111208193003.112037550@goodmis.org> <20111208193136.366941904@goodmis.org> <1323373012.30977.123.camel@frodo> <20111209124026.GB14470@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209124026.GB14470@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:57:39 up 380 days, 18:00,  2 users,  load average: 0.28, 0.06,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Hi Steven,
> 
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Thu, 2011-12-08 at 14:30 -0500, Steven Rostedt wrote:
> > 
> > > If the first NMI hits a breakpoint and loses NMI context, and then it
> > > hits another breakpoint and while processing that breakpoint we get a
> > > nested NMI. When processing a breakpoint, the stack changes to the
> > > breakpoint stack. If another NMI comes in here we can't rely on the
> > > interrupted stack to be the NMI stack. 
> > 
> > As I wrote this part of the change log, I thought of another nasty
> > gotcha with breakpoints in NMIs.
> > 
> > If you have a breakpoint in both normal context and NMI context. When
> > the breakpoint is being processed, if an NMI comes in and it too
> > triggers a breakpoint, this processing of the breakpoint has the same
> > problem as nested NMIs. The NMI breakpoint handler will corrupt the
> > stack of the breakpoint that was being processed when the NMI triggered.
> > 
> > I'm not sure how to handle this case. We could do something similar in
> > the break point code to handle the same thing. But this just seems
> > really ugly.
> > 
> > Anyone with any better ideas?
> 
> The nesting counters + code region address checks I proposed a few days
> ago should handle this correctly. Here is a very slightly updated
> version:

after a quick IRC discussion with Peter Zijlstra, one thing seems to be
missing here to handle the INT3->NMI->INT3 issue: this could be achieved
by splitting the DEBUG stack in 2 sub-stacks, and letting the int3
handler keep track of its nesting within its own stack with an extra
"int3_nest_count". AFAIU, supporting 2 nested int3 should be enough.

Thanks,

Mathieu 

> 
> variables used:
> 
> cpu-local int nmi_nest_count;
> cpu-local int nmi_latch;
> __nmi_epilogue_begin (pointer to text)
> __nmi_epilogue_end (pointer to text)
> REAL_NMI_STACK: beginning of the stack used for real nmi handler
> LATCHED_NMI_STACK: beginning of the stack used for latched nmi handler
> 
> int in_nmi_epilogue(void)
> {
>   return (instruction_pointer() >= __nmi_epilogue_begin
> 		&& instruction_pointer() < __nmi_epilogue_end);
> }
> 
> int in_nmi(void)
> {
>   return nmi_nest_count > 0;
> }
> 
> /* Use REAL_NMI_STACK */
> real_nmi_handler: /* always running with nmis disabled */
>   /*
>    * We disable interrupts to ensure we don't have to deal with IRQs
>    * when NMIs get re-enabled due to an iret from a fault/exception.
>    */
>   local_irq_disable();
>   if (in_nmi_epilogue()) {
>     nmi_latch = 0;
>     /* set stack pointer to start of LATCHED_NMI_STACK */
>     /* populate start of LATCHED_NMI_STACK with values for iret */
>     goto latched_nmi_handler;
>   }
>   if (in_nmi()) {
>      nmi_latch = 1;
>      iret
>   }
>   nmi_nest_count++;
>   /* set stack pointer to start of LATCHED_NMI_STACK */
>   /* populate start of LATCHED_NMI_STACK with values for iret */
>   goto latched_nmi_handler;
> 
> 
> /* Use LATCHED_NMI_STACK */
> latched_nmi_handler:	/* Can fault and reenable NMIs. */
> 
>   [ execute actual system NMI handler, including faults, int3, ... ]
> 
>   /*
>    * note: test nmi_latch and iret instruction are within the epilogue
>    * range to deal with latch test vs iret non-atomicity.  If a real nmi
>    * nests over this range, it clears the nmi_latch flag and just
>    * restarts the latched nmi handler.  No faults/exceptions/interrupts
>    * are permitted in this region, except for the real NMI and MCEs
>    * (TODO).
>    */
> __nmi_epilogue_begin:
>   /*
>    * here we are restarting the latched nmi handler if an nmi happened
>    * while nested within the nmi nest count.
>    */
>   if (nmi_latch) {
>     nmi_latch = 0;
>     goto latched_nmi_handler;
>   }
>   nmi_nest_count--;
>   iret  /* restores interrupts */
> __nmi_epilogue_end:
> 
> 
> Best regards,
> 
> Mathieu
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
