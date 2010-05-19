Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0ESSru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:47:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37328 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753410Ab0ESSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:47:49 -0400
Date: Wed, 19 May 2010 14:47:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
Message-ID: <20100519184745.GA19522@Krystal>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100519181001.GC18073@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519181001.GC18073@basil.fritz.box>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:20:49 up 116 days, 20:57, 10 users,  load average: 0.25, 0.25,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Wed, May 19, 2010 at 01:51:54PM -0400, Steven Rostedt wrote:
> 

Hi Andi,

> Hi Steven,
> 
> > More than a year and a half ago (September 2008), at Linux Plumbers, we
> > had a meeting with several kernel developers to come up with a unified
> > ring buffer. A generic ring buffer in the kernel that any subsystem
> > could use. After coming up with a set of requirements, I worked on
> 
> If we take a step back.
> 
> Why do you want a single ring buffer for everyone?
> 
> A lot more low profile subsystems subsystems simply use kfifo
> (which is also actively developed by Stefanie). In fact there
> are far more users of it than of your ring buffer. And it's 
> really quite simple and easy to use. And it works fine for them.
> 
> I don't think it's that great a goal to have a single ring buffer
> for all possible ring buffer needs. After all the requirements
> are quite different.

One requirement seems to be shared for most tracing heavy users: it has to be
blazingly fast. This is a requirement that is commonly overlooked by the "very
simple" implementations.

> 
> Some want a simple ring buffer with minimal overhead
> and simple interface, others need a mmaped one or have other special 
> requirements. One size doesn't fit all. 

The plan here is to create a ring buffer that supports per-buffer instance
"flags" that specify what must be supported: e.g. either splice() or mmap(),
global vs per-cpu buffers, etc.

I already have much of the code that can easily support all these use-cases with
only minor modifications. So I don't see why we should duplicate the code.

> 
> It's also not that we're talking about gigantic amounts of code
> in all cases where there is a pressing need to unify.

For efficient flavors of ring buffer, it's not that much code, that's true, but
the complexity level/LOC is rather higher than for standard code. So it's good
if we can focus our review efforts on a single ring buffer.

> If perf's current ring buffer works for it why not keep using it? 

I'll let the perf developers answer this one.

> One problem I always had with your version was that it's quite 
> bloated frankly, especially in terms of code size, but 
> also in its data structures and in the interface complexity.

I share your concern about the level of complexity of Steven's lockless ring
buffer implementation. Even though Lai and I are listed as "reviewed-by" in the
ring buffer code header, I remember that neither him nor myself were
particularly comfortable with the way complexity has been handled.

The new implementation I propose lessens the complexity level, presents clear
abstractions to deal with that complexity, and comes with a formal proof of
correctness, all of which I think is really very important to give a good level
of insurance that the ring buffer works as expected.

> 
> For debugging kernels etc. with tracing that's not that big an issue, but
> I think it's a problem for "non debugging" use. After all Linux
> still has the goal to be at least configurable as a low footprint operating
> system.

My implementation, at the moment, has 50% less lines of code and is 25% smaller
in object size than the current ring buffer.

But all in all, I think users needing _something_ to perform system-wide tracing
shout a lot louder than users who need to save a few bytes. So let's try to get
something good in first, while keeping an eye on the object size, and if it
happens to be too large for some users, then they can always implement a
slower and less efficient ring_buffer_tiny.c if they feel like it.

The main concern for the ring buffer code is more about the number of cache
lines it grabs from the system when it is active, and about being blazingly
fast. We must keep the number of active cache lines very low, sometimes at the
expense of overall code size (e.g., having separate fast/slow paths).

> 
> Part of the reason for its big code size seems to be that 
> it tries to support everyone's requirements, which unsurprisingly
> leads to some bloat both in implementation and interface.

At the very least Steven's code did not meet the perf requirements nor the LTTng
requirements. As far as the "next gen" version is concerned, I plan to allow
myself to sometimes say "no" (with proper counter-arguments of course) when
people come up with ideas that will either needlessly complexify the ring buffer
code or won't take into account the "special" very heavy usage nature of the
ring buffer.

I really believe in code review and comments. I just don't feel I must always
incorporate all the modifications that are requested without proper
justification. It's just the approach I have, and it seems to have led to good
results so far if we take Tracepoints as an example.

> 
> Also to be honest it's so clever now that at least I have
> a hard time understanding it, and I personally prefer code
> that I can understand over too clever code. After all if there
> is a bug in there and you need to be more clever than the programmer
> to debug it, how would that be done? 

I totally agree with you. This is in good part why I spent a large part of 2009
writing papers explaining my ring buffer, doing Promela models and formal proofs
of correctness. I think after all that work, the abstractions I will use will be
much easier to grap by anyone willing to do a bit of reading.

> 
> Perhaps a better goal would be to have a smaller simpler more
> maintainable buffer for ftrace and let the other users their own?

The advantage of having both ftrace and perf as ring buffer users is that they
can both give me feedback in the development, and this increases chances that
the API will be generic, clean and well documented.

Thanks,

Mathieu

> 
> Just my 0.05 cent.
> 
> -Andi
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
