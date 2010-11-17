Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab0KQNg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:36:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590Ab0KQNg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:36:26 -0500
Date: Wed, 17 Nov 2010 14:36:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101117133608.GG27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
 <20101117120740.GA24972@elte.hu>
 <4CE3C7C2.7000200@kernel.org>
 <20101117123055.GA27063@elte.hu>
 <4CE3CB8A.8060608@kernel.org>
 <1289997733.2109.743.camel@laptop>
 <20101117125827.GB27063@elte.hu>
 <1289999352.2109.757.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289999352.2109.757.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > User-space tracing schemes tend to be clumsy and limiting. There's other 
> > disadvantages as well: approaches that expose a named pipe in /tmp or an shmem 
> > region are not transparent and robust either: if user-space owns a pending 
> > buffer then bugs in the apps can corrupt the trace buffer, can prevent its 
> > flushing when the app goes down due to an app bug (and when the trace would be 
> > the most useful), etc. etc.
> 
> Sure, but you're not considering the fact that Jato already needs an interface to 
> communicate its generated symbols, also writing its own events really isn't a big 
> deal after that.

But Jato is special there (it's a special execution machine with its own symbol 
space) - and most apps that generate trace events are not such.

Also, while it's not a big deal to not get symbols, it's a big deal to not get trace 
events _exactly when they are needed most_: when the app crashes or corrupts itself.

I.e. the kernel does us a real and useful service of extracting and then protecting 
data.

> > Also, in general their deployment isnt particularly fast nor lightweight - while 
> > prctl() is available everywhere.
> 
> I know your reasoning, but deployment isn't everything. Technical sanity does, I 
> hope, still count for something as well.

I agree that a prctl() isnt particularly nice - a new syscall would be nicer, if it 
wasnt such a PITA to get new syscalls supported by widely available libraries like 
glibc.

But i disagree that there should be pending buffers in the tracee context. Having 
app-side data buffering introduces the sorts of problems i outlined, that the data 
can be lost or corrupted when we need _reliable_ (and non-corrupted) trace data the 
most.

We could use the vDSO approach for super-fast and super-voluminous tracing needs, 
although i really doubt that it's the common case.

Availability is the biggest issue by far - and availability is inverse proportional 
to deployment complexity.

> > And when it comes to tracing/instrumentation, if we make deployment too complex, 
> > people will simply not use it - and we all use. A prctl() isnt particularly sexy 
> > design, but it's a task/process event that we are generating (so related to 
> > prctls), plus it's available everywhere and is very easy to deploy.
> 
> Different tools for different people, complex applications like JITs can use a 
> more complex interface to communicate all their various data.

Yes but i dont want complex interfaces at all - i want rich trace data from many 
apps, so that tracing tools start to make sense.

> A simple printk() style interface through a syscall (preferably not prctl) is fine 
> too, it just doesn't suffice for everything, nor should we want it to.

Well, it covers about 80-90% of the needs, so it was the first thing i considered.

Thanks,

	Ingo
