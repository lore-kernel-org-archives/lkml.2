Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3ACQED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:04:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3ACQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:04:00 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HQJ7cb7SADkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MBbGe7VapwAA:10 a=cu8MJhJYOYY4HmPNLgcA:9 a=PUjeQqilurYA:10 a=2hBV4ytl0BXWzewI:21 a=aD5rnzNk5XGYx29b:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357229038.10284.46.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Keun-O Park <kpark3469@gmail.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Date: Thu, 03 Jan 2013 11:03:58 -0500
In-Reply-To: <20130103141301.GQ2631@n2100.arm.linux.org.uk>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	 <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	 <20130103103815.GL2631@n2100.arm.linux.org.uk>
	 <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
	 <1357220165.10284.30.camel@gandalf.local.home>
	 <20130103141301.GQ2631@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 14:13 +0000, Russell King - ARM Linux wrote:

> > 
> > Or something similar, if that's what was done.
> 
> No.  What I want is some evidence that the patch author is not just
> removing warnings by patching them away, but has thought about why
> the warning is there, and that they've resolved the issues for why
> that warning is there - and most importantly why the code is not built
> in that configuration.

OK, I understand you now.

> 
> The unwinder has many functions, none of which is marked in any way.
> This is alluded to in this comment:
> 
> /*
>  * return_address uses walk_stackframe to do it's work.  If both
>  * CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses unwind
>  * information.  For this to work in the function tracer many functions would
>  * have to be marked with __notrace.  So for now just depend on
>  * !CONFIG_ARM_UNWIND.
>  */
> 
> So, what this means is that the function tracer can have hooks in the
> unwinder code.  If one of those hooks is active, then there's the
> possibility for recursion.

Note, since this code was written, the function tracer has much better
recursion protection. If one of the callbacks of the function tracer
were to call return_address() and it triggered another traced function,
the function tracer would simply drop it.

Now this isn't true for function graph tracing, at least not for its
internal use. That would need to be investigated to see if there's calls
there (I don't see any). From what I see, the return_address() is used
by ftrace's CALLER_ADDR1-6. These are used by the latency tracers
(irqsoff, preemptoff) as well as lockdep.

Looking at the code in trace_irqsoff.c (which does both irqsoff and
preemptoff), it doesn't look as if the function graph callbacks use
return_address() at all.

The return_address() is used in the management of tracing where the irqs
and preemption was disabled. Not by the functions called in between.

Looks, like the worse that can happen if we allow using the unwind code
here, is that we will see the functions it uses in the trace output. I
don't see where a recursion bug could happen.

But this would need more investigation to be sure.

> 
> I see no evidence in either of these patches that this issue has been
> addressed in any way (let alone thought about.)  The approach here seems
> to be "lets remove the comment, lets change the ifdefs to make the code
> build, and lets remove the warning".
> 
> That's not acceptable.  We don't fix warnings to make them go away while
> effectively hiding the original problem.

I totally agree with you. But now I'm wondering if the problem exists
even without these patches.

> > 
> > 
> > > 
> > > diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> > > index 00df012..52ff2d4 100644
> > > --- a/arch/arm/kernel/unwind.c
> > > +++ b/arch/arm/kernel/unwind.c
> > > @@ -327,7 +327,7 @@ static int unwind_exec_insn(struct
> > > unwind_ctrl_block *ctrl)
> > >   * Unwind a single frame starting with *sp for the symbol at *pc. It
> > >   * updates the *pc and *sp with the new values.
> > >   */
> > > -int unwind_frame(struct stackframe *frame)
> > > +int notrace unwind_frame(struct stackframe *frame)
> > >  {
> > >         unsigned long high, low;
> > >         const struct unwind_idx *idx;
> > > 
> 
> And what about search_index(), unwind_find_origin(), unwind_find_idx(),
> unwind_get_byte(), unwind_exec_insn(), pr_debug(), pr_warning()?  Maybe
> the compiler currently inlines all those functions, but todays compiler
> behaviour is no guarantee of tomorrow's compiler behaviour.  We'd also
> hope that list_move() would always be inlined and never traced.

Some would definitely be traced. Note, that the "inline" keyword adds
'notrace' now to remove those ambiguous cases.

> 
> It is possible that the ftrace code has some re-entrancy protection to
> prevent the unwinder recursing back into the ftrace code, but that's not
> mentioned in this patch... so it could be that needs to be explained.

Function tracing does, and to the most extent so does function graph
tracing as long as the return_address() isn't used internally. Looking
at the code, I don't see where it is.

> 
> In summary, from what I can see in the patch, the reason why the ifdefs
> are the way they are, and the reason the warning is there has not been
> addressed; these patches just seem to be aimed just at removing a #warning
> statement to make the warning go away.

You're correct that this patch does not solve any of theses issues. Now,
I'm thinking that ftrace has matured where these issues don't exist, and
where they do, it will only cause noise in the trace than anything
serious. But, this needs to be looked deeper to make sure.

-- Steve


