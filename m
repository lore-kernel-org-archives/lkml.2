Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0HOQFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:05:13 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58961 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758299Ab0HOQFL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:05:11 -0400
Date: Sun, 15 Aug 2010 10:10:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFD] Mechanical synchronization algorithms proofs (was: Re:
	[patch 1/2] x86_64 page fault NMI-safe)
Message-ID: <20100815141017.GB18175@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:35:25 up 204 days, 16:12,  3 users,  load average: 0.07, 0.04,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I re-threaded this email because this is yet another topic that does not have
much to do with NMIs)

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-08-06 at 10:13 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> 
> > Less code = less instruction cache overhead. I've also shown that the LTTng code
> > is at least twice faster. In terms of complexity, it is not much more complex; I
> > also took the extra care of doing the formal proofs to make sure the
> > corner-cases were dealt with, which I don't reckon neither Steven nor yourself
> > have done.
> 
> Yes Mathieu, you did a formal proof. Good for you. But honestly, it is
> starting to get very annoying to hear you constantly stating that,
> because, to most kernel developers, it is meaningless.

So what you are stating is that having mechanically tested that all possible
reordering done by the architecture on enough unrolled loops of the algorithm,
testing all boundary cases (buffer full, NMI, etc) is 'meaningless' to kernel
developers ?

This tells me I have an important explanation job to do, because this can be
tremendously useful to ensure rock-solidness of the current kernel
synchronization primitives.

I vastly prefer this approach to synchronization primitives to the 'let's turn
this knob and see what breaks and which reviewers will oppose' approach that
some kernel developers currently have.


> Any slight
> modification of your algorithm, renders the proof invalid.

We can add the model and test-cases somewhere in Documentation then, and require
that the model should be updated and the test-suite ran when important
synchronization changes are done.

> 
> You are not the only one that has done a proof to an algorithm in the
> kernel,

I know Paul McKenney has done formal proofs about RCU too. I actually started
from his work when I started looked into proving the LTTng sync. algos. I even
worked with him on a formal model of Userspace RCU. It ended up being a more
generic proof framework that I think can be useful beyond modeling of algorithm
corner-cases. It lets us model whole synchronization algorithms; the framework
per se takes care of modeling memory and instruction reordering.

> but you are definitely the only one that constantly reminds
> people that you have done so. Congrats on your PhD, and in academia,
> proofs are important.

Even though you don't seem to see it or like it, this proof holds an important
place in the robustness we can expect from this ring buffer, and I want people
to go look and ask questions about the model if they care about it. Yes,
modeling and doing formal proofs takes time. I understand that kernel developers
don't have that much time on their hands. But don't look down on people who
spent the time and effort to do it.

With a more collaborative mindset, we could try to automate the C to
out-of-order memory/instruction framework with a simple compiler, so we could
create those proofs with much less effort than what is currently required.

> 
> But this is a ring buffer, not a critical part of the workings of the
> kernel. There are much more critical and fragile parts of the kernel
> that work fine without a formal proof.

I've come to find this out all by myself: regarding the LTTng tree, I receive
more bug reports about problems coming from the kernel than tracer-related
problems.

We seem to have slightly different definitions of "working fine".

> 
> Paul McKenney did a proof for RCU not for us, but just to help give him
> a warm fuzzy about it. RCU is much more complex than the ftrace ring
> buffer,

Not that much I'm afraid. Well, the now deprecated "preempt rcu" was a
complexity mess, but I think Paul did a good job at simplifying the TREE_RCU
preempt implementation to bring the complexity level doing to something we can
model and understand in its entirety.

> and it also is much more critical. If Paul gets it wrong, a
> machine will crash. He's right to worry.

What if we start using the ring buffer as a core kernel synchronization
primitive in audio drivers, video drivers, etc ? These are all implementing
their own ring buffer flavor at the moment, which duplicates code with similar
functionality and multiply reviewer's job. Then the ring buffer suddenly become
more critical than you initially thought.

> And even Paul told me that no
> formal proof makes up for large scale testing. Which BTW, the ftrace
> ring buffer has gone through.

LTTng has gone through large-scale testing in terms of user-base and machine
configurations too. I've also ran it on the largest-scale machines in terms of
CPU I could find (only 8 so far, but I'd love to see results on larger
machines).

I can say for sure that Ftrace performance has not been tested on large-scale
SMP machines, simply because your Ftrace benchmark only use one writer/one
reader thread.

> 
> Someday I may go ahead and do that proof,

Please do.

> but I did do a very intensive
> state diagram, and I'm quite confident that it works.

Convincing others is the hard part.

> It's been deployed
> for quite a bit, and the design has yet to be a factor in any bug report
> of the ring buffer.

Yeah, synchronization bugs are really hard to reproduce, I'm not that surprised.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
