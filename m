Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab2EaSmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:42:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2EaSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:42:36 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nA43mK65oyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Zk8jxFJ6mR73uJTIrkUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338489754.13348.371.camel@gandalf.stny.rr.com>
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
Date: Thu, 31 May 2012 14:42:34 -0400
In-Reply-To: <1338485338.28384.85.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338485338.28384.85.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 19:28 +0200, Peter Zijlstra wrote:

> I don't know, nor did you explain the implicit ordering there. Also in
> such diagrams you need the other side as well.

Right, I forgot to add that.

> 
> > If another breakpoint is hit (one other than one put in by ftrace) then
> > we don't care. It wont crash the system whether or not A is 1 or 0. We
> > just need to make sure that a ftrace breakpoint that is hit knows that
> > it was a ftrace breakpoint (calls the ftrace handler). No other
> > breakpoint should be on a ftrace nop anyway.
> 
> So the ordering is like:
> 
> ---
> 
>  CPU-0				CPU-1
> 
> 
>  lock inc mod-count /* implicit (w)mb */
>  write int3
> 				<trap-int3> /* implicit (r)mb */
> 				load mod-count
> 
>  sync-ipi-broadcast
>  write rest-of-instruction
>  sync-ipi-broadcast
>  write head-of-instruction
>  sync-ipi-broadcast
>  lock dec mod-count /* implicit (w)mb */
> 
> 
> Such that when we observe the int3 on CPU-1 we also must see the
> increment on mod-count.
> 
> ---
> 
> A simple something like the above makes it very clear what we're doing
> and what we're expecting.

You are obviously better at drawing such diagrams than I am. Which also
explains why I needed to do the lockdep annotations to understand them
better. Because I don't have your ability to visualize it in such a nice
simple diagram. My vision is more of a bayesian tree than an oak. I
guess that explains why I like complex code so much :-)


>  I think a (local) trap should imply a barrier
> of sorts but will have to defer to others (hpa?) to confirm.

I would think it does, but lets have hpa or others confirm.


>  But at the
> very least write it down someplace that you are assuming that.

I'll cut and paste this into the comments.

> 
> 
> 
> fwiw run_sync() could do with a much bigger comment on why its sane to
> enable interrupts.. That simply reeks, enabling interrupts too early can
> wreck stuff properly.

Hmm, actually, I think these patches avoid the need for run_sync() at
boot up now anyway. Thus it shouldn't need to enable interrupts.

The ftrace.c code was what disabled interrupts on start up (and
re-enables them) before calling into this, this is because the old way
needed interrupts disabled, and other archs still use the old way. But,
your point stands, it should be commented better.

-- Steve




