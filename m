Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1LNQTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:19:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1LNQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:19:14 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Wdbr4zj3n9AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=4sDCTpiMtxHzMQU4R_wA:9 a=3mo_aFfSeJl4Xy-Q-P0A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323879550.23971.31.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 4/5 v2] x86: Keep current stack in NMI breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Date: Wed, 14 Dec 2011 11:19:10 -0500
In-Reply-To: <20111214134325.GB2882@Krystal>
References: <20111214025237.457632996@goodmis.org>
	 <20111214025252.684160446@goodmis.org> <20111214134325.GB2882@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 08:43 -0500, Mathieu Desnoyers wrote:

> What happens to the following sequence ?
> 
> - Hit a breakpoint.
> - Execute an interrupt handler nesting over breakpoint handler (made
>   possible by preempt_conditional_sti(regs) in do_int3()).
>   (or take any kind of fault that switch the current stack)
> - NMI fires, not detecting that it is nested over a breakpoint handler,
>   thus potentially corrupting the DEBUG stack.

Hmm, interesting, because if the interrupt hits a breakpoint, it too
will cause the corruption of the breakpoint stack. I guess this is what
the funky code is trying to protect in the breakpoint assembly, which it
still currently has a race condition too.

> 
> Instead of trying to detect if we nest on a stack to find out if we need
> to change the IDT, I would recommend to unconditionally switch the int3
> IDT to use the current stack upon outermost NMI entry, and set it back
> to its usual behavior upon outermost NMI exit.

I really hate to add overhead to all cases for the most unlikely case.
What would be better, is to fix it in the most unlikely case code, which
would be in the breakpoint handler.

I've been pushing that I don't want the NMI ugliness to spread to other
parts of the code, but this does not have to do with just NMIs. Now we
are having the breakpoint ugliness spread to NMI and vice versa. The
real solution would be to change the do_int3() code.

We could add another IDT table for breakpoints, and before calling the
preempt_conditional_sti(), we update it. This breakpoint IDT will not
change the stack for interrupts. We can still allow NMIs to change, as
that is taken care of. This not only fixes the issue you brought up, but
it also fixes the race that exists today, and we can remove the ugly
code in the int3 assembly.

-- Steve



