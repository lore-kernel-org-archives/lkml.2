Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab2IFPnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:43:45 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:45334 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758257Ab2IFPnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:43:42 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI1432Izz1202hzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1155h)
X-WSS-ID: 0M9XQC1-02-0MH-02
X-M-MSG: 
Date: Thu, 6 Sep 2012 17:34:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: wyang1 <Wei.Yang@windriver.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
Message-ID: <20120906153407.GA8285@erda.amd.com>
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
 <20120904102439.GS8285@erda.amd.com>
 <5047FCBD.9000205@windriver.com>
 <20120906100434.GX8285@erda.amd.com>
 <1346937282.1680.15.camel@gandalf.local.home>
 <20120906150246.GZ8285@erda.amd.com>
 <1346944482.1680.28.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346944482.1680.28.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.12 11:14:42, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 17:02 +0200, Robert Richter wrote:
> 
> > > > --- a/arch/x86/oprofile/backtrace.c
> > > > +++ b/arch/x86/oprofile/backtrace.c
> > > > @@ -113,7 +113,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
> > > >  
> > > >  	if (!user_mode_vm(regs)) {
> > > >  		unsigned long stack = kernel_stack_pointer(regs);
> > > > -		if (depth)
> > > > +		if (depth & stack)
> > > 
> > > Can other users of kernel_stack_pointer() be nailed by a return of NULL?
> > 
> > It would be save here too, but dump_trace() falls back to the current
> > stack in case there is no stack address given which we don't want with
> > oprofile.
> > 
> > I was looking at all users of kernel_stack_pointer() and could not
> > find any direct pointer dereference of the sp. The only potential
> > problems I found could arise here:
> > 
> >  arch/x86/kernel/kprobes.c:resume_execution()
> >  arch/x86/kernel/time.c:profile_pc()
> > 
> > It is not quite clear if we really need code here that checks the
> > pointer. Since a NULL pointer access has the same effect as if the
> > stack address would be wrong which would be the case without the
> > patch, I rather tend not to change the code here.
> 
> Then a comment should be in the oprofile code too. Something to the
> effect that oprofile is special and can cause kernel_stack_pointer() to
> return NULL in some cases, thus we need to check for it.

We could return always a non-null stack pointer with:

unsigned long kernel_stack_pointer(struct pt_regs *regs)
{
	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
	unsigned long sp = (unsigned long)&regs->sp;
	struct thread_info *tinfo;

	if (context == (sp & ~(THREAD_SIZE - 1)))
		return sp;
	
	tinfo = (struct thread_info *)context;
	if (tinfo->previous_esp)
		tinfo->previous_esp;

	return (unsigned long)regs;
}

Maybe this is even better.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

