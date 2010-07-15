Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab0GOQ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:26:36 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48753 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933694Ab0GOQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:26:35 -0400
Date: Thu, 15 Jul 2010 12:26:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100715162631.GB30989@Krystal>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714233843.GD14533@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:06:01 up 173 days, 18:42,  6 users,  load average: 0.21, 0.16,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Wed, Jul 14, 2010 at 07:11:17PM -0400, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Wed, Jul 14, 2010 at 06:31:07PM -0400, Mathieu Desnoyers wrote:
> > > > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > > > On Wed, Jul 14, 2010 at 12:54:19PM -0700, Linus Torvalds wrote:
> > > > > > On Wed, Jul 14, 2010 at 12:36 PM, Frederic Weisbecker
> > > > > > <fweisbec@gmail.com> wrote:
> > > > > > >
> > > > > > > There is also the fact we need to handle the lost NMI, by defering its
> > > > > > > treatment or so. That adds even more complexity.
> > > > > > 
> > > > > > I don't think your read my proposal very deeply. It already handles
> > > > > > them by taking a fault on the iret of the first one (that's why we
> > > > > > point to the stack frame - so that we can corrupt it and force a
> > > > > > fault).
> > > > > 
> > > > > 
> > > > > Ah right, I missed this part.
> > > > 
> > > > Hrm, Frederic, I hate to ask that but.. what are you doing with those percpu 8k
> > > > data structures exactly ? :)
> > > > 
> > > > Mathieu
> > > 
> > > 
> > > 
> > > So, when an event triggers in perf, we sometimes want to capture the stacktrace
> > > that led to the event.
> > > 
> > > We want this stacktrace (here we call that a callchain) to be recorded
> > > locklessly. So we want this callchain buffer per cpu, with the following
> > > type:
> > 
> > Ah OK, so you mean that perf now has 2 different ring buffer implementations ?
> > How about using a single one that is generic enough to handle perf and ftrace
> > needs instead ?
> > 
> > (/me runs away quickly before the lightning strikes) ;)
> > 
> > Mathieu
> 
> 
> :-)
> 
> That's no ring buffer. It's a temporary linear buffer to fill a stacktrace,
> and get its effective size before committing it to the real ring buffer.

I was more thinking along the lines of making sure a ring buffer has the proper
support for your use-case. It shares a lot of requirements with a standard ring
buffer:

- Need to be lock-less
- Need to reserve space, write data in a buffer

By configuring a ring buffer with 4k sub-buffer size (that's configurable
dynamically), all we need to add is the ability to squash a previously saved
record from the buffer. I am confident we can provide a clean API for this that
would allow discard of previously committed entry as long as we are still on the
same non-fully-committed sub-buffer. This fits your use-case exactly, so that's
fine.

You could have one 4k ring buffer per cpu per execution context.  I wonder if
each Linux architecture have support for separated thread vs softirtq vs irq vs
nmi stacks ? Even then, given you have only one stack for all shared irqs, you
need something that is concurrency-aware at the ring buffer level.

These small stack-like ring buffers could be used to save your temporary stack
copy. When you really need to save it to a larger ring buffer along with a
trace, then you just take a snapshot of the stack ring buffers.

So you get to use one single ring buffer synchronization and memory allocation
mechanism, that everyone has reviewed. The advantage is that we would not be
having this nmi race discussion in the first place: the generic ring buffer uses
"get page" directly rather than relying on vmalloc, because these bugs have
already been identified and dealt with years ago.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
