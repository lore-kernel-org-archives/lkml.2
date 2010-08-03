Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0HCUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:21:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664Ab0HCUVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:21:51 -0400
Date: Tue, 3 Aug 2010 22:21:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100803202127.GA18773@elte.hu>
References: <20100714223107.GA2350@Krystal>
 <20100714224853.GC14533@nowhere>
 <20100714231117.GA22341@Krystal>
 <20100714233843.GD14533@nowhere>
 <20100715162631.GB30989@Krystal>
 <1280855904.1923.675.camel@laptop>
 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
 <20100803194553.GA27688@Krystal>
 <AANLkTinW34tSZ0gLyRb4mjh1UX4w=34pNcjU=fY+y_oT@mail.gmail.com>
 <20100803201022.GA18583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803201022.GA18583@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, Aug 3, 2010 at 12:45 PM, Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> > >
> > > The real issue here, IMHO, is that Perf has tied gory ring buffer 
> > > implementation details to the userspace perf ABI, and there is now strong 
> > > unwillingness from Perf developers to break this ABI.
> 
> (Wrong.)
> 
> > The thing is - I think my outlined buffer fragmentation model would work 
> > fine with the perf ABI too.  Exactly because there is no deep structure, 
> > just the same "stream of small events" both from a kernel and a user model 
> > standpoint. Sure, the stream would now contain a new event type, but that's 
> > trivial. It would still be _entirely_ reasonable to have the actual data in 
> > the exact same ring buffer, including the whole mmap'ed area.
> 
> Yeah.
> 
> > Of course, when user space actually parses it, user space would have to 
> > eventually defragment the event by allocating a new area and copying the 
> > fragments together in the right order, but that's pretty trivial to do. It 
> > certainly doesn't affect the current mmap'ed interface in the least.
> > 
> > Now, whether the perf people feel they want that kind of functionality, I 
> > don't know. It's possible that they simply do not want to handle events that 
> > are complex enough that they would have arbitrary size.
> 
> Looks useful. There's a steady trickle of new events and we already use type 
> encapsulation for things like trace events - which are only made sense of 
> later on in user-space.
> 
> We may want to add things like a NOP event to pad out the end of page

/me once again experiences the subtle difference between 'Y' and 'N' when postponing a mail

So adding fragments would be possible as well. We've got the space for such 
extensions in the ABI and the basic model of streaming information is not 
affected.

[ The control structure of the mmap area is there for performance/wakeup 
  optimizations (and to allow the kernel to lose information on producer 
  overload, while still giving user-space an idea that we lost data and how 
  much) - it does not affect semantics and does not limit us. ]

So there's no design limitation - Peter simply prefers one possible solution 
over another and outlined his reasons - we should hash that out based on the 
technical arguments.

Thanks,

	Ingo
