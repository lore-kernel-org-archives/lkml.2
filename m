Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0JSV41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:56:27 -0400
Received: from www.tglx.de ([62.245.132.106]:33812 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab0JSV40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:56:26 -0400
Date: Tue, 19 Oct 2010 23:55:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Baron <jbaron@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20101019212816.GA2855@redhat.com>
Message-ID: <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>
References: <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
 <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <20101019212816.GA2855@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Jason Baron wrote:
> On Tue, Oct 19, 2010 at 09:49:45PM +0200, Thomas Gleixner wrote:
> > > > On Tue, 19 Oct 2010, Steven Rostedt wrote:
> > 
> > So it trades a conditional vs. two jumps ? WTF ??
> > 
> 
> right, so the 'jmpq' on boot on x86 gets patched with 5 byte no-op
> sequence. So in the disabled case we have no-op followed by a jump
> around the disabled code.

And that's supposed to be useful ? We do _NOT_ want to jump around
disabled stuff. The noped out case should fall through into the non
traced code. Otherwise that whole jumplabel thing is completely
useless.

> > I thought that jumplabel magic was supposed to get rid of the jump
> > over the tracing code ? In fact it adds another jump. Whatfor ?
> > 
> 
> yes, that is the plan. gcc does not yet support hot/cold labels...once
> it does the second jump will go away and the entire tracepoint code will
> be moved to a 'cold' section. It's not quite completely optimal yet, but
> we are getting there.

Then do not advertise it as the brilliant solution for all tracing
matters.

> > Now even worse, when you NOP out the jmpq then your tracepoint is
> > still not enabled. Brilliant !
> > 
> 
> The 'jmpq' in the enabled case is patched with a jmpq to the body of the
> tracepoint itself.

Brilliant.
 
> > Did you guys ever look at the assembly output of that insane shite you
> > are advertising with lengthy explanations ? 
> > 
> > Obviously _NOT_
> > 
> > Come back when you can show me a clean imlementation of all this crap
> > which reproduces with my jumplabel enabled stock compiler. And please
> > just send me a patch w/o the blurb.
> > 
> > And sane looks like:
> > 
> >     jmpq   2f  <---- This gets noped out 
> > 1:
> >     mov    %r12,%rdi
> >     callq  *(%r12)
> >     [whatever cleanup it takes ]
> >     leaveq 
> >     retq   
> > 
> > 2f:
> >     [tracing gunk]
> >     jmp    1b
> > 
> 
> yes, this is what the code should look like when we get support for
> hot/cold labels. I've discussed this support with gcc folk, and its the
> next step here. So yes, this is exacatly where we are headed.

So and at the same time the whole tracing crowd tells me, that this is
already a done deal. See previous advertisments from DrTracing. I'm
seriously grumpy about this especially in the context of a patch which
fixes one of the worst interfaces I've seen in years.

Thanks,

	tglx
