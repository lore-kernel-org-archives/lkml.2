Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2EaR3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:29:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:38061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2EaR3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:29:10 -0400
Message-ID: <1338485338.28384.85.camel@twins>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 19:28:58 +0200
In-Reply-To: <1338473302.13348.336.camel@gandalf.stny.rr.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 10:08 -0400, Steven Rostedt wrote:
> On Thu, 2012-05-31 at 13:06 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-05-30 at 21:28 -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > When the function tracer starts modifying the code via breakpoints
> > > it sets a variable (modifying_ftrace_code) to inform the breakpoint
> > > handler to call the ftrace int3 code.
> > > 
> > > But there's no synchronization between setting this code and the
> > > handler, thus it is possible for the handler to be called on another
> > > CPU before it sees the variable. This will cause a kernel crash as
> > > the int3 handler will not know what to do with it.
> > > 
> > > I originally added smp_mb()'s to force the visibility of the variable
> > > but H. Peter Anvin suggested that I just make it atomic.
> > 
> > Uhm,. maybe. atomic_{inc,dec}() implies a full memory barrier on x86,
> 
> Yeah, I believe (and H. Peter can correct me) that this is all that's
> required for x86.
> 
> > but atomic_read() never has the smp_rmb() required.
> > 
> > Now smp_rmb() is mostly a nop on x86, except for CONFIG_X86_PPRO_FENCE.
> 
> No rmb() is required, as that's supplied by the breakpoint itself.
> Basically, rmb() is used for ordering:
> 
> 	load(A);
> 	rmb();
> 	loab(B);
> 
> To keep the machine from actually doing:
> 
> 	load(B);
> 	load(A);

I know what rmb is for.. I also know you need to pair barriers. Hiding
them in atomic doesn't make the ordering any more obvious.

> But what this is:
> 
> 	<breakpoint>
> 	     |
> 	     +---------> <handler>
> 			    |
> 			load(A);
> 
> We need the load(A) to be after the breakpoint. Is it possible for the
> machine to do it before?:
> 
> 		     load(A)
> 	      |
> 	      |
> 	<breakpoint>
> 	      +----------> test(A)

I don't know, nor did you explain the implicit ordering there. Also in
such diagrams you need the other side as well.

> If another breakpoint is hit (one other than one put in by ftrace) then
> we don't care. It wont crash the system whether or not A is 1 or 0. We
> just need to make sure that a ftrace breakpoint that is hit knows that
> it was a ftrace breakpoint (calls the ftrace handler). No other
> breakpoint should be on a ftrace nop anyway.

So the ordering is like:

---

 CPU-0				CPU-1


 lock inc mod-count /* implicit (w)mb */
 write int3
				<trap-int3> /* implicit (r)mb */
				load mod-count

 sync-ipi-broadcast
 write rest-of-instruction
 sync-ipi-broadcast
 write head-of-instruction
 sync-ipi-broadcast
 lock dec mod-count /* implicit (w)mb */


Such that when we observe the int3 on CPU-1 we also must see the
increment on mod-count.

---

A simple something like the above makes it very clear what we're doing
and what we're expecting. I think a (local) trap should imply a barrier
of sorts but will have to defer to others (hpa?) to confirm. But at the
very least write it down someplace that you are assuming that.



fwiw run_sync() could do with a much bigger comment on why its sane to
enable interrupts.. That simply reeks, enabling interrupts too early can
wreck stuff properly.
