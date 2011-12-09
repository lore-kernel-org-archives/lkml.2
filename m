Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1LIQtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:49:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab1LIQtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:49:50 -0500
Date: Fri, 9 Dec 2011 11:49:17 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
Message-ID: <20111209164917.GA2444@redhat.com>
References: <20111208193003.112037550@goodmis.org>
 <20111208193136.366941904@goodmis.org>
 <1323373012.30977.123.camel@frodo>
 <1323398616.30977.167.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323398616.30977.167.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 09:43:36PM -0500, Steven Rostedt wrote:
> On Thu, 2011-12-08 at 14:36 -0500, Steven Rostedt wrote:
> 
> > I'm not sure how to handle this case. We could do something similar in
> > the break point code to handle the same thing. But this just seems
> > really ugly.
> > 
> > Anyone with any better ideas?
> 
> On IRC, Peter Zijlstra mentioned changing the IDT in NMI. I'm not sure
> if he was joking or not. But I decided to try it out. It seems to
> work :)
> 
> 
> What's nice is that this change is in the C code, which makes things
> much easier.
> 
> I check on nmi entry, if the nmi preempted code running with the debug
> stack. If it has, then I load a special "nmi_idt_table" that has a zero
> IST for the debug stack, which will make the debug interrupt in the NMI
> not change the stack pointer. Then on exit, it returns it to the old IDT
> table.
> 
> Just to see how bad this was, I made it make the change on every NMI. I
> didn't notice any difference, but I wasn't doing any real benchmark,
> except doing a perf top -c 1000.
> 
> But in practice, it should seldom hit, if ever. It only updates the IDT
> if it interrupted debug processing.
> 

Then, I'm wondering if the same technique can be used for the original
nmi->int3->nmi case. That is, switch the IDT when the int3 comes in, so
that the subsequent nmi will be handled on the debug stack. As you pointed out,
these nesting and thus the IDT switching would be rare in
practice. (I know you don't want to touch any code outside of nmi :))

Thanks,

-Jason
