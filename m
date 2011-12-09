Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1LIOt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:49:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1LIOt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:49:26 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=7d_E57ReAAAA:8 a=4RP4skqum6wKRA9EndcA:9 a=sAeC4PBXDAaqvGaaK3sA:7 a=QEXdDO2ut3YA:10 a=D6-X0JM3zdQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <20111209130216.GA14718@Krystal>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org> <1323373012.30977.123.camel@frodo>
	 <20111209124026.GB14470@Krystal>  <20111209130216.GA14718@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 09:49:22 -0500
Message-ID: <1323442162.1937.8.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 08:02 -0500, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:

> after a quick IRC discussion with Peter Zijlstra, one thing seems to be
> missing here to handle the INT3->NMI->INT3 issue: this could be achieved
> by splitting the DEBUG stack in 2 sub-stacks, and letting the int3
> handler keep track of its nesting within its own stack with an extra
> "int3_nest_count". AFAIU, supporting 2 nested int3 should be enough.

Here's the problem. When you take an int3, the hardware loads stuff onto
the stack for you. That's the SS, RSP, FLAGS, CS, RIP. If the NMI comes
in while we are processing a breakpoint, and the NMI hits an int3 too,
then the hardware will load the current SS, RSP, FLAGS, CS and RIP onto
the stack at the exact same place as the breakpoint processing that was
interrupted had it's interrupt frame. IOW, it just corrupted the stack.

To prevent this in the NMI code, I did ugly things like making copies of
the interrupt frame to keep a nested NMI from corrupting the first NMI.
Not only do I not want to do this ugly hack for debug exception, you
*can't* do it. It wont work!

The reason the NMI works is because while we are copying the stack
frame, NMIs are disabled because we are currently in an NMI.

But a normal int3, as it tries to do the copy and an NMI triggers, if
you don't update the IDT, any int3 that the NMI hits will corrupt the
previous int3 processing's stack. The hardware does it, there's nothing
a "split stack" will do to fix that.

-- Steve


