Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213Ab2LGSn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:43:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19033 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2LGSn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:43:27 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=x7HaIhc6LHu1aINb5bsA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354905805.17101.86.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 07 Dec 2012 13:43:25 -0500
In-Reply-To: <20121207181309.GY14363@n2100.arm.linux.org.uk>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <20121207181309.GY14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added hpa, as he knows a bit about x86, and breakpoints ]

On Fri, 2012-12-07 at 18:13 +0000, Russell King - ARM Linux wrote:

> So, you're asking me to wave hands in the air, make guesses and hope that
> I hit the situation you're knowledgable of without actually telling me
> anything.  Great - you really know how to frustrate people...

Sorry, I thought I was telling you something. I guess we have a bit of a
disconnect. Jon did hit what I was trying to ask.

> 
> If you're saying that the nop was created at _compile_ time, to be a 32-bit

Actually the call is created at compile time. When compiled with -pg,
gcc will insert branch and link calls to a special function (actually
implemented in assembly) to "mcount". Looking at the arm implementation,
it seems that the branch and link is 32bits (just confirming). On boot
up, all calls to mcount are converted to 32bit nops.

> instruction then maybe - but you have a problem.  That 32-bit instruction
> may stradle a 32-bit boundary (worse if it stradles a page), and _any_
> changes to that instruction will not be atomic - other CPUs will see the
> store as two separate operations which, given the right timing may create
> an illegal instruction.

This is the same as x86.

> 
> Even changing it to a breakpoint is potentially problematical.  So we'd
> need to ensure that no other CPU was executing the code while we modify
> it.

This is not the same as x86, I guess because x86 has a one byte
breakpoint. Thus, it is stated in the x86 architecture (I believe,
Peter, you can correct me if I'm wrong), that the only "safe" thing that
can modify code, is a software breakpoint.

Are you saying that thumb does not guarantee even software breakpoints
from being added atomically? Doesn't that kill the purpose of a
breakpoint?

> 
> Now, if you're going to say that ftrace inserts a 32-bit nop with
> appropriate alignment constraints at _compile_ time, then maybe that would
> work, but then your update to the instruction might as well just be NOP->BL
> because that's a word-write to an aligned address which will be atomic (in
> so far as either the entire instruction has been updated _or_ none of the
> instruction has been updated.)

That's how it's done on powerpc.

> 
> In a previous email you intimated that these NOPs are inserted by ftrace at
> boot time.  Given that these NOPs would have to be 32-bit instructions, I'd
> hope that they're also replacing 32-bit instructions and not two 16-bit
> instructions which might be prefixed by a "if-then" instruction.

At compile time, it's a call to mcount, inserted by gcc, and at the
beginning of functions, thus they should never be prefixed by a
"if-then".

> 
> Maybe now you'll provide some information on how ftrace works as you should
> now realise that your "simple question" doesn't have a simple answer.

Maybe, I've described it above, but I'll repeat it in more detail here.

Ftrace uses the gcc -pg option that adds a call to 'mcount' to the
beginning of almost every function. It does not add mcount to inlined
functions, so these functions are truly functions and not inlined into
other functions. Also some functions are manually ignored in the kernel
when we annotate them with 'notrace'. Just to make things consistent, as
gcc doesn't always honor the 'inline' code, I've defined inline to also
contain 'notrace' as well.

The 'mcount' function has to be written in assembly. On arm, it's
implemented in arch/arm/kernel/entry-common.S. It looks like this:

ENTRY(mcount)
        stmdb   sp!, {lr}
        ldr     lr, [fp, #-4]
        ldmia   sp!, {pc}
ENDPROC(mcount)

Note, I removed the #ifdef/#else of CONFIG_DYNAMIC_FTRACE, because this
modification only happens with that config enabled. So I only showed
that version.

During compile time, the recordmcount.c code is run against all .o
files, and records the location of the mcount callers. It then creates a
table of those locations and links them back into the .o file.

On boot up (before SMP starts), this table is referenced, and all the
calls to mcount are converted into 32 bit nops. Before this conversion,
any code that hits the call will simply return back (as you can see by
the above mcount definition).

When we enable tracing, currently we use stop_machine(), all the nops in
functions to be traced are then converted to another call, but not to
mcount (as that just returns), but instead to 'ftrace_caller'. This
function is also written in assembly and it handles the tracing when
hit.

When tracing is disabled, the same thing happens but we convert the call
sites into nops.

Does this make more sense?

> 
> > >   That's something
> > > other people use and deal with.  Last (and only) time I used the built-in
> > > kernel tracing facilities I ended up giving up with it and going back to
> > > using my sched-clock+record+printk based approaches instead on account
> > > of the kernels built-in tracing being far too heavy.
> > 
> > Too bad. Which tracing facilities did you use? Function tracing? And
> > IIRC, ARM originally had only the static tracing, which was extremely
> > heavy weight. Have you tried tracepoints? Also, have you tried my
> > favorite way of debugging: trace_printk(). It acts just like printk but
> > instead of recording to the console, it records into the ftrace buffer
> > which can be read via the /debug/tracing/trace or dumped to the console
> > with a sysrq-z.
> 
> TBH I don't remember, it was a few years ago that I last had to measure
> stuff.

Yeah, things have improved since then :-)

-- Steve


