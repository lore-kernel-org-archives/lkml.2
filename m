Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423706Ab2LGSNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:13:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423669Ab2LGSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:13:32 -0500
Date: Fri, 7 Dec 2012 18:13:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are
	synchronised across all cpus
Message-ID: <20121207181309.GY14363@n2100.arm.linux.org.uk>
References: <1354817466.30905.13.camel@linaro1.home> <1354821581.17101.17.camel@gandalf.local.home> <1354872138.3176.15.camel@computer5.home> <1354888985.17101.41.camel@gandalf.local.home> <1354892111.13000.50.camel@linaro1.home> <1354894134.17101.44.camel@gandalf.local.home> <20121207162346.GW14363@n2100.arm.linux.org.uk> <1354898200.17101.50.camel@gandalf.local.home> <20121207164530.GX14363@n2100.arm.linux.org.uk> <1354900436.17101.58.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354900436.17101.58.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:13:56PM -0500, Steven Rostedt wrote:
> On Fri, 2012-12-07 at 16:45 +0000, Russell King - ARM Linux wrote:
> > On Fri, Dec 07, 2012 at 11:36:40AM -0500, Steven Rostedt wrote:
> 
> > > But what about the limitations that the function tracer imposes on the
> > > code that gets modified by stop_machine()?
> > > 
> > > 1) the original code is simply a call to mcount
> > > 
> > > 2) on boot up, that call gets converted into a nop
> > > 
> > > 3) the code that gets changed will only be converting a nop to a call
> > > into the function tracer, and back again.
> > > 
> > > IOW, it's a very limited subset of the ARM assembly that gets touched.
> > > I'm not sure what the op codes are for the above, but I can imagine they
> > > don't impose the prefixes as you described.
> > > 
> > > If that's the case, is it still possible to change to the breakpoint
> > > method?
> > 
> > I have no idea; I've no idea how ftrace works on ARM.
> 
> I know how ftrace works on ARM, I'm just asking about the way the
> architecture works in general. So to answer my question, you don't need
> to know anything about ftrace. I'll make my question more general:
> 
> If I have a nop, that is a size of a call (branch and link), which is
> near the beginning of a function and not part of any conditional, and I
> want to convert it into a call (branch and link), would adding a
> breakpoint to it, modifying it to the call, and then removing the
> breakpoint be possible? Of course it would require syncing in between
> steps, but my question is, if the above is possible on a thumb2 ARM
> processor?

So, you're asking me to wave hands in the air, make guesses and hope that
I hit the situation you're knowledgable of without actually telling me
anything.  Great - you really know how to frustrate people...

If you're saying that the nop was created at _compile_ time, to be a 32-bit
instruction then maybe - but you have a problem.  That 32-bit instruction
may stradle a 32-bit boundary (worse if it stradles a page), and _any_
changes to that instruction will not be atomic - other CPUs will see the
store as two separate operations which, given the right timing may create
an illegal instruction.

Even changing it to a breakpoint is potentially problematical.  So we'd
need to ensure that no other CPU was executing the code while we modify
it.

Now, if you're going to say that ftrace inserts a 32-bit nop with
appropriate alignment constraints at _compile_ time, then maybe that would
work, but then your update to the instruction might as well just be NOP->BL
because that's a word-write to an aligned address which will be atomic (in
so far as either the entire instruction has been updated _or_ none of the
instruction has been updated.)

In a previous email you intimated that these NOPs are inserted by ftrace at
boot time.  Given that these NOPs would have to be 32-bit instructions, I'd
hope that they're also replacing 32-bit instructions and not two 16-bit
instructions which might be prefixed by a "if-then" instruction.

Maybe now you'll provide some information on how ftrace works as you should
now realise that your "simple question" doesn't have a simple answer.

> >   That's something
> > other people use and deal with.  Last (and only) time I used the built-in
> > kernel tracing facilities I ended up giving up with it and going back to
> > using my sched-clock+record+printk based approaches instead on account
> > of the kernels built-in tracing being far too heavy.
> 
> Too bad. Which tracing facilities did you use? Function tracing? And
> IIRC, ARM originally had only the static tracing, which was extremely
> heavy weight. Have you tried tracepoints? Also, have you tried my
> favorite way of debugging: trace_printk(). It acts just like printk but
> instead of recording to the console, it records into the ftrace buffer
> which can be read via the /debug/tracing/trace or dumped to the console
> with a sysrq-z.

TBH I don't remember, it was a few years ago that I last had to measure
stuff.
