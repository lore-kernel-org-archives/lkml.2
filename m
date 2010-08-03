Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0HCVQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:16:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54307 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755969Ab0HCVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:16:48 -0400
Date: Tue, 3 Aug 2010 17:16:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20100803211646.GA24693@Krystal>
References: <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <20100803194553.GA27688@Krystal> <AANLkTinW34tSZ0gLyRb4mjh1UX4w=34pNcjU=fY+y_oT@mail.gmail.com> <20100803201022.GA18583@elte.hu> <20100803202127.GA18773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803202127.GA18773@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:04:37 up 192 days, 23:41,  7 users,  load average: 0.25, 0.17,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Tue, Aug 3, 2010 at 12:45 PM, Mathieu Desnoyers
> > > <mathieu.desnoyers@efficios.com> wrote:
> > > >
> > > > The real issue here, IMHO, is that Perf has tied gory ring buffer 
> > > > implementation details to the userspace perf ABI, and there is now strong 
> > > > unwillingness from Perf developers to break this ABI.
> > 
> > (Wrong.)

I am glad to hear this. So should I understand that if we show that the current
perf ABI imposes significant design constraints and results in poor performance
and inability to support flight recorder mode (which is needed to unify the ring
buffers), we can deprecate the ABI ?

[...]


> > We may want to add things like a NOP event to pad out the end of page

Or simply write the page (or sub-buffer) size information in a page (or
sub-buffer) header. The gain here is that by doing so we don't have to reserve
an event ID for the NOP event, which adds one extra ID reserved in _each_ event
header. You might be tempted to say "oh, it's just a single value, who cares ?",
but with the amount of data we're moving, being able to represent the event
header on a very small amount of bits really makes a difference. Bloat creeps in
one single bit at a time until we start not caring about adding whole integers,
and when we're there the game was over long ago: performance suffer deeply.

The huge size of the perf event headers is another factor that might explain its
poor performance by the way.

[...]

> [ The control structure of the mmap area is there for performance/wakeup 
>   optimizations

I am doubtful about an "optimization" that affects what should be a slow path:
user-space wakeup for delivering a multiple events at once. Have you checked if
this leads to actual noticeable performance increase at all ?

>                 (and to allow the kernel to lose information on producer 
>   overload, while still giving user-space an idea that we lost data and how 
>   much)

This can be performed with a standard system call rather than playing games
with a shared pages into which both the kernel and user-space write. The
advantage is that by letting user-space calling the kernel (rather than just
writing "I'm done" in that page by updating the consumer value), we can let the
kernel perform tasks that might enable us to implement flight recorder mode all
within the same ring buffer implementation.

>                  - it does not affect semantics and does not limit us. ]

Well, so far, the main limitation I can see is that it does not allow us to do
flight recorder tracing (a.k.a. overwrite mode).

> 
> So there's no design limitation - Peter simply prefers one possible solution 
> over another and outlined his reasons - we should hash that out based on the 
> technical arguments.

Another argument I've seen from Peter is that he prefers the perf
kernel-userspace interaction to happen through this shared page to diminish the
number of traced events generated by perf activity. But I find this argument
unconvincing, because it really only applies to system call tracing: the rest of
tracing will be affected by the perf user-space process activity. So we might as
well just bite the bullet and accept that the trace is "polluted" by user-space
perf events. It _is_ using up CPU time anyway, so I think it's actually _better_
to know about it, rather than to try to hide the tracer activity. If one really
wants to filter out the tracer activity, it can be done at post-processing
without problem. But at least the information is there.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
