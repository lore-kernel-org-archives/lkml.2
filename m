Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1LIPCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:02:53 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39962 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751693Ab1LIPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:02:51 -0500
Date: Fri, 9 Dec 2011 10:02:49 -0500
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
Message-ID: <20111209150249.GA15751@Krystal>
References: <20111208193003.112037550@goodmis.org> <20111208193136.366941904@goodmis.org> <1323373012.30977.123.camel@frodo> <20111209124026.GB14470@Krystal> <20111209130216.GA14718@Krystal> <1323442162.1937.8.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323442162.1937.8.camel@frodo>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:02:14 up 380 days, 20:05,  6 users,  load average: 0.02, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2011-12-09 at 08:02 -0500, Mathieu Desnoyers wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> 
> > after a quick IRC discussion with Peter Zijlstra, one thing seems to be
> > missing here to handle the INT3->NMI->INT3 issue: this could be achieved
> > by splitting the DEBUG stack in 2 sub-stacks, and letting the int3
> > handler keep track of its nesting within its own stack with an extra
> > "int3_nest_count". AFAIU, supporting 2 nested int3 should be enough.
> 
> Here's the problem. When you take an int3, the hardware loads stuff onto
> the stack for you. That's the SS, RSP, FLAGS, CS, RIP. If the NMI comes
> in while we are processing a breakpoint, and the NMI hits an int3 too,
> then the hardware will load the current SS, RSP, FLAGS, CS and RIP onto
> the stack at the exact same place as the breakpoint processing that was
> interrupted had it's interrupt frame. IOW, it just corrupted the stack.
> 
> To prevent this in the NMI code, I did ugly things like making copies of
> the interrupt frame to keep a nested NMI from corrupting the first NMI.
> Not only do I not want to do this ugly hack for debug exception, you
> *can't* do it. It wont work!
> 
> The reason the NMI works is because while we are copying the stack
> frame, NMIs are disabled because we are currently in an NMI.
> 
> But a normal int3, as it tries to do the copy and an NMI triggers, if
> you don't update the IDT, any int3 that the NMI hits will corrupt the
> previous int3 processing's stack. The hardware does it, there's nothing
> a "split stack" will do to fix that.

yep, doing that in the "real" nmi handler (with NMIs disabled at that
point) makes tons of sense.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
