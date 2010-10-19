Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0JSWFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:05:23 -0400
Received: from www.tglx.de ([62.245.132.106]:49373 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0JSWFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:05:21 -0400
Date: Wed, 20 Oct 2010 00:04:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
In-Reply-To: <1287523439.16971.433.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1010192359480.6815@localhost6.localdomain6>
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>  <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>  <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>  <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
  <20101019132236.GA19197@Krystal>  <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>  <1287496495.16971.372.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>  <20101019142820.GA14520@Krystal> 
 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>  <1287521757.16971.397.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Steven Rostedt wrote:
> On Tue, 2010-10-19 at 23:07 +0200, Thomas Gleixner wrote:
> > On Tue, 19 Oct 2010, Steven Rostedt wrote:
> > > On Tue, 2010-10-19 at 21:49 +0200, Thomas Gleixner wrote:
> > > > So that saves _TWO_ bytes of text and replaces:
> > > > 
> > > > -  1e:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 25 <test+0x25>
> > > > -  25:	74 4d                	je     74 <test+0x74>
> > > > +  1e:	e9 00 00 00 00       	jmpq   23 <test+0x23>
> > > > +  23:	eb 4d                	jmp    72 <test+0x72>
> > > > 
> > > > So it trades a conditional vs. two jumps ? WTF ??
> > > 
> > > Well, the one jmpq is noped out, and the jmp is non conditional. I've
> > 
> > What are you smoking ?
> 
> What? Are you saying that conditional jumps are just as fast as non
> conditional ones?
> 
> > 
> > In case the trace point is enabled the jmpq is there, so it jumps to
> > 23 and jumps from there to 72.
> 
> No, when we dynamically enable the tracepoint, it will jump to 25, not
> 23. That's what the goto part is about. We add the do_trace label to the
> table, and we make it point to that location. If we did it as you say,
> then tracepoints would never be enabled.
> 
> This is not unlike what we do with the function tracer. The original
> code points to mcount which simply is:
> 
> 	mcount:
> 		retq
> 
> And when we enable the callers, we have it jump to a different function.
> 
> > 
> > In case the trace point is disabled the jmpq is noped out, so it jumps
> > to 72 directly.
> 
> That is correct.
> 
> > 
> > > always thought a non conditional jmp was faster than a conditional one,
> > 
> > I always thought, that at least some of the stuff which comes from
> > tracing folks makes some sense.
> 
> Is it still not making sense?
> 
> > 
> > > since there's no need to go into the branch prediction logic. The CPU
> > > can simply skip to the code to jump next. Of counse, this pollutes the 
> > > I$.
> > 
> > We might consult Mathieu for further useless blurb on how CPUs work
> > around broken code.
> 
> The code worked fine before, it just was not very pretty.
> 
> But it seemed that gcc for you inlined the code in the wrong spot.
> Perhaps it's not a good idea to have the something like h - softirq_vec
> in the parameter of the tracepoint. Not saying that your change is not
> worth it. It is, because h - softirq_vec is used by others now too.

Crap, crap, crap. This has nothing to do with the arguments of that
trace point, it's a compiler problem and you are just hoping that GCC
will do the right thing.

That's the complete wrong assumption and as Jason confirmed GCC is not
up to it at all.

hpa just posted code which does the _RIGHT_ _THING_ independent of any
compiler madness and you tracer folks just missed it.

Your jump label optimization made code even worse for todays common
compilers. Just admit it and fix that mess you created or simply
disable it.

Thanks,

	tglx
