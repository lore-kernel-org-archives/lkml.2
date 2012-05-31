Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab2EaUAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:00:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab2EaUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:00:33 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6I2XFdsDAPIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=YtSZhsRO0IIsooUj0-EA:9 a=PUjeQqilurYA:10 a=Sb0Rj5n82tdZEeGG:21 a=88USbIBGTVTD2aPe:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338494431.13348.410.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 16:00:31 -0400
In-Reply-To: <4FC7C62C.1020807@zytor.com>
References: <20120531012829.160060586@goodmis.org>
	  <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>
	 <1338492300.13348.384.camel@gandalf.stny.rr.com>
	 <4FC7C62C.1020807@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 12:27 -0700, H. Peter Anvin wrote:
> On 05/31/2012 12:25 PM, Steven Rostedt wrote:
> >> void debug_stack_set_zero(void)
> >> {
> >> 	if (this_cpu_inc_return(debug_stack_use_ctr) == 1)
> > 
> > If an NMI comes in here, it will not update the IDT and will corrupt the
> > stack. The load_idt() must happen for all calls. There's only two static
> > IDT tables. It's either one or the other. Thus, if it loads it twice, it
> > will just set it to the same value. The counter is to know when to set
> > it back.
> > 
> 
> Now I'm really confused.  Why would it have to set it if it is already set?
> 

It doesn't ;-)

But we don't know if it is what it needs to be. Just because the counter
is set to 1, doesn't mean that it was already set. Because we are
dealing with NMIs, that are totally asynchronous, and the race of
setting the counter and setting the idt.

Basically, (as you already know) the IST=0 means to use the same stack
if we hit a breakpoint. But usually it's set to '4' which is an index
into the TSS to find its per CPU stack.

If the IST is set to 4, and a breakpoint is hit, then the stack is set
to a fixed address, even if you are currently using the same stack!

We need to prevent this from happening. There's two places that this can
cause issues. The first is in the NMI handler, which is where this code
was first developed. The idea was to allow NMIs to hit breakpoints. But
if it were to do that after preempting a debug int3 handler, the
breakpoint it hit would reset the stack and the NMI would start
clobbering the stack of the code it preempted.

The NMI code on entering (and before it is allowed to hit any
breakpoints) looks at the stack it preempted. If it is a debug stack,
then it updates the IDT to have the int3 vector have a IST of 0 (keep
the same stack when triggered). Then if the NMI hits a breakpoint, it
just continues to use the NMI stack.

The int3 handler has a little trick that lets the int3 code reuse the
stack. It modifies the TSS to point to another stack before calling the
debug handler. If a NMI triggers now, or a breakpoint is hit again, it
wont corrupt the stack.

	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
	call \do_sym
	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)

The debug stack is EXCEPTION_STKSZ * 2 size. Before entering the \do_sym
(do_int3 in this case), it moves the TSS to point to another stack for
the int3 handler.

The problem this patch set is trying to fix is the case for lockdep. The
macro TRACE_IRQS_ON/OFF calls into lockdep code. And these are outside
that add/sub TSS trick. If lockdep code hits a breakpoint than we reset
back to the original stack address, and start clobbering the stack. This
is the bug that Dave Jones was triggering.

Now we could do this add/sub TSS trick instead of loading idt for all
the cases before calling lockdep in the debug handler. But this means
the paranoid_exit will need to be turned into a macro and we would
require it for each ist set.

Now, back to your original question. Why set it if it is already set.
Well, it doesn't hurt to set it (except for the performance hit we
take), but it does hurt if we should set it but don't, as that means we
can reset the stack and clobber what we preempted.

I'm sure there's room to make this more efficient. But I'm currently
trying to solve a kernel crash first, and then work on cleaning it up
later.

-- Steve


