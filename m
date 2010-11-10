Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0KJV6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:58:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0KJV6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:58:37 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=0Gcdu3wDtgIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=c2YUiZhXD91o1vlikzkA:9 a=KQCpX3CdAd9D2RGUqqMA:7 a=g70mdGFIWxYqTaa3bGsaZQYM384A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101110213033.GA7682@nowhere>
References: <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu>
	 <1289412329.12418.177.camel@gandalf.stny.rr.com>
	 <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu>
	 <1289415645.12418.180.camel@gandalf.stny.rr.com>
	 <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal>
	 <20101110213033.GA7682@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 16:54:19 -0500
Message-ID: <1289426059.12418.209.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 22:30 +0100, Frederic Weisbecker wrote:

> > * Trace Format issues with Ftrace:
> > 
> > - Ftrace timestamps are saved as delta from previous event
> >   - Only works for tracing where preemption can be disabled, unusable for
> >     user-space tracing.
> 
> 
> 
> What is this userspace tracing? Is this userspace tracing made in kernel
> space?
> 
> (tag me confused)

tag team!

> 
> 
> 
> >   - Creates an artificial data dependency between events, leading to odd
> >     side-effects when dealing with nesting over tracer
> 
> 
> 
> I wouldn't comment that, I'm not very experienced with the ring buffer

Yeah, I discussed this with Mathieu. There's a pretty trivial fix for
this, but may require ABI breakage.

> 
> 
> 
> >     - 0 ns IRQ/SOFTIRQ handler duration side-effect
> 
> 
> 
> ditto.

If an interrupt (or softirq) preempts the recorded trace, then events
that are recorded in that interrupt all get the same time as the event
it preempted. Giving us the assumption that all events happened at once.

Again, this is just a side effect and the fix is trivial. But may
require ABI breakage to do so.


> 
> If we need/want to cure that, then we need an:
> 
> => ABI breakage
> 
> 
> 
> > - Event size limited to one page
> 
> 
> 
> Perf too needs more (userspace stack dumps).

That was actually a decision made by Linus. But is trivial to change. As
there's nothing hard coded about the design that forces us to have page
size sub buffers. I don't even think that it would require an ABI
breakage, except I think my tools I wrote (incorrectly) assumed it.


> 
> 
> 
> > - Ftrace event headers are still too large
> 
> 
> (described in the beginning)

Yep, they are large, but can be trimmed. This would require no abi
breakage since the these headers are also described in the event
formats. Thus changing the current tools should cope with the headers
changing. In fact they were designed too since the lock-depth was known
to be deprecated soon.

> 
> 
> 
> > - Handling of dynamically added instrumentation while trace is recorded is
> >   inexistent.
> 
> 
> 
> 
> I still don't understand this point

He's talking about tracing the tracepoints in a loaded module. We
currently have no way to add them while a trace is happening. The trace
formats do not exist and may not exist (if module is unloaded) when the
trace ends.

But who really loads and then unloads a module during tracing. As pretty
much all kernel developers cringe at the fact that modules get
unloaded ;-)


> 
> 
> Now I'm too tired to sum up all the points that seem not to be
> solved through an ABI extension :)

Me too, lets go shopping!

-- Steve


