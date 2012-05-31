Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2EaOI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:08:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2EaOIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:08:25 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nA43mK65oyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=WH_RFyxd9rVzhVcxWoEA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338473302.13348.336.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 10:08:22 -0400
In-Reply-To: <1338462398.28384.52.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:06 +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 21:28 -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > When the function tracer starts modifying the code via breakpoints
> > it sets a variable (modifying_ftrace_code) to inform the breakpoint
> > handler to call the ftrace int3 code.
> > 
> > But there's no synchronization between setting this code and the
> > handler, thus it is possible for the handler to be called on another
> > CPU before it sees the variable. This will cause a kernel crash as
> > the int3 handler will not know what to do with it.
> > 
> > I originally added smp_mb()'s to force the visibility of the variable
> > but H. Peter Anvin suggested that I just make it atomic.
> 
> Uhm,. maybe. atomic_{inc,dec}() implies a full memory barrier on x86,

Yeah, I believe (and H. Peter can correct me) that this is all that's
required for x86.

> but atomic_read() never has the smp_rmb() required.
> 
> Now smp_rmb() is mostly a nop on x86, except for CONFIG_X86_PPRO_FENCE.

No rmb() is required, as that's supplied by the breakpoint itself.
Basically, rmb() is used for ordering:

	load(A);
	rmb();
	loab(B);

To keep the machine from actually doing:

	load(B);
	load(A);

But what this is:

	<breakpoint>
	     |
	     +---------> <handler>
			    |
			load(A);

We need the load(A) to be after the breakpoint. Is it possible for the
machine to do it before?:

		     load(A)
	      |
	      |
	<breakpoint>
	      +----------> test(A)

??

If another breakpoint is hit (one other than one put in by ftrace) then
we don't care. It wont crash the system whether or not A is 1 or 0. We
just need to make sure that a ftrace breakpoint that is hit knows that
it was a ftrace breakpoint (calls the ftrace handler). No other
breakpoint should be on a ftrace nop anyway.


> 
> So this should mostly work, but yuck.

It should work, not just mostly.

> 
> 
> Also, why does this stuff live in ftrace? I always thought you were
> going to replace text_poke() so everybody that uses cross-modifying code
> could profit?

I discussed this with Masami at Collaboration Summit. The two are
similar but also very different. But we want to start merging the two
together where it makes sense.

Currently text_poke maps 2 pages into a FIXMAP area to make the
modification so that it does not need to change the protection of the
kernel (from ro to rw). Ftrace changes the text protection while it
makes the update then reverts it back when done. The reason for the
difference is that text_poke only handles 1 change at a time. There is a
batch mode, but it does the mapping 1 at a time even for that.

Now ftrace must change 30,000 locations at once!

# cat /debug/tracing/available_filter_functions | wc -l
29467

Could you imagine ftrace mapping 30,000 pages one at a time to do the
update?

Also, the text_poke() batch mode requires allocation of an array. This
could cause failures to start function tracing to allocate 30,000
structures. Ftrace has its own tight structure that's done in blocks
(the struct dyn_ftrace), that is (on x86_64) 16 byte items. This is
allocated at boot up, and module load, and is persistent throughout the
life of the system uptime (or module loaded). You can see it in the
dmesg:

ftrace: allocating 20503 entries in 81 pages

 - note this is just core code, before modules are added

The dyn_ftrace has a pointer to the mcount location, and a flags field.
The flags tells the update code what to change.

Now Masami said he thinks the text_poke should also do the change of
kernel protection as well, and not do the FIXMAP mapping. At least for
bulk changes. The added breakpoint code that we have can be shared
between ftrace and text_poke. That is something we want to do. After we
get ftrace working, we'll go ahead and make it work for text_poke as
well ;-)

-- Steve


