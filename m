Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2EaOTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:19:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2EaOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:19:51 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XaGDPJ4YHPcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=v03pRgSSuXigx7qvTCoA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338473989.13348.345.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/5] ftrace: Use breakpoint method to update ftrace
 caller
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 10:19:49 -0400
In-Reply-To: <1338463085.28384.54.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.839498007@goodmis.org> <1338463085.28384.54.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:18 +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 21:28 -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > On boot up and module load, it is fine to modify the code directly,
> > without the use of breakpoints. This is because boot up modification
> > is done before SMP is initialized, thus the modification is serial,
> > and module load is done before the module executes.
> > 
> > But after that we must use a SMP safe method to modify running code.
> > 
> > This has been done to change the nops at all the functions, but
> > the change of the ftrace callback handler itself was still using a
> > direct modification. If tracing was enabled and the function callback
> > was changed then another CPU could fault if it was currently calling
> > the original callback. This modification must use the breakpoint method
> > too.
> > 
> > Note, the direct method is still used for boot up and module load.
> 
> The changelog isn't clear if this is a fix or optimization. I suspect
> the latter.

It's a bug fix. There's a GPF kernel crash creeping around in the
current code. I can add to the change log what I put into my cover
letter:

"The second fixes a bug where we don't do the breakpoint update of
the function trace callback (the one called in the mcount trampoline).
This could cause a GPF when tracing is running and the function
tracer changes."


> 
> Still, you're now re-inventing text_poke() and text_poke_early().

I explained this in my other email. Also, it wasn't really re-invented,
as I believe ftrace did this first (back in 2007). text_poke() looks to
have come into play around 2008. Ftrace was the first to do live updates
of code while the system was up and running. Before that, the
alternatives code just changed the system at boot up (or going from SMP
to UP or vice versa). It never did the change in an SMP environment.

This patchset is not a implementation of text_poke() but a fix to what
was done earlier. The breakpoint method was something that text_poke()
tried earlier, but H. Peter, warned that Intel has not said it was safe
to do so. Thus we waited. When we got the unofficial OK, I added the
breakpoint method to get rid of stop_machine() from ftrace. That was the
main motivation for this.

> 
> Why are you keeping all this inside of ftrace?

I'm not ;-) Well, actually, I wont be. As I explained in my last email,
I talked to Masami about it, and we are discussing ways to change text
poke to do basically what ftrace is doing. I'm doing this with ftrace
first because it removes stop_machine() from it, and it also a greater
test case. If something is to go wrong, it will more likely go wrong
with 30,000 changes at once, than just 100.

-- Steve


