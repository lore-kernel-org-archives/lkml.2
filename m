Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2BKDZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 22:25:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55750 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2BKDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 22:25:17 -0500
Date: Sat, 11 Feb 2012 04:25:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
Message-ID: <20120211032509.GE25516@somewhere.redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
 <1328895795.25989.29.camel@laptop>
 <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
 <20120210192714.GE4998@infradead.org>
 <20120210194426.GA17650@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210194426.GA17650@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 08:44:26PM +0100, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Em Fri, Feb 10, 2012 at 10:59:51AM -0800, Linus Torvalds escreveu:
> > > On Fri, Feb 10, 2012 at 9:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > >
> > > > So I CC'ed Linus who has a strong here, jejb since he's the one that
> > > > told me several time there's a number of literate dwarfs already in the
> > > > kernel and Jan because I think it was him that tried last on x86.
> > > 
> > > I never *ever* want to see this code ever again.
> > > 
> > > Sorry, but last time was too f*cking painful. The whole (and *only*)
> > > point of unwinders is to make debugging easy when a bug occurs. But
> > > the f*cking dwarf unwinder had bugs itself, or our dwarf information
> > > had bugs, and in either case it actually turned several "trivial" bugs
> > > into a total undebuggable hell.
> > > 
> > > It was made doubly painful by the developers involved then several
> > > times ignoring the problem, and claiming the code was bug-free when it
> > > clearly wasn't, or trying to claim that the problem was that we set up
> > > some random dwarf information wrong, when THAT GOES WITHOUT SAYING
> > > (since dwarf is a complex mess that never gets any actual testing
> > > except when things go wrong - at which point the code had better work
> > > regardless of whether the dwarf info was correct or not).
> > > 
> > > So no. An unwinder that is several hundred lines long is simply not
> > > even *remotely* interesting to me.
> > > 
> > > If you can mathematically prove that the unwinder is correct - even in
> > > the presence of bogus and actively incorrect unwinding information -
> > > and never ever follows a bad pointer, I'll reconsider.
> > > 
> > > In the absence of that, just follow the damn chain on the stack
> > > *without* the "smarts" of an inevitably buggy piece of crap.
> > 
> > "Vote for --fno-omit-frame-pointer! One register is a cheap 
> > price to pay for not going insane!"
> > 
> > /me goes back to non political things.
> 
> Well, instead of dropping it we could try to meet Linus's 
> challenge, at least to a fair degree.
> 
> Also lets fundamentally treat GCC provided data as untrusted, 
> hostile data and lets put lockdep-alike redundancy and resilence 
> around it.
> 
> As a first step lets try input randomization unit tests. A lot 
> of the broken unwind code was really just sloppy about boundary 
> conditions.
> 
> I had a quick peek and I don't think it's constructed in a 
> resilent enough form right now. For example there's no clear 
> separation and checking of what comes from GCC and what not.
> 
> It *can* be done: lockdep is not hundreds but thousands of lines 
> of highly complex code (with non-trivial algorithms such as 
> graph walks), and still it has a very good track record - so 
> it's possible.
> 
> Once that is done I'd like to try it myself in practice, without 
> offering it as a pull to Linus. I see a *lot* of weird oopses 
> all day in and out, often in impossible contexts, and the old 
> dwarf unwinder was crap.
> 
> I'd also love to see perf callchains work on all kernels and 
> extend into user-space as well, if that's possible in a sane 
> fashion. 90% of the interesting apps out there are build with 
> framepointers off, and the context of overhead is often rather 
> obscure. Looking at good callchains is a good learning 
> experience all around.

My thinking is we can have two kinds of unwinding co-existing in
the kernel:

- the heavy one that we use today that walks the entire stack
for addresses, which validates addresses with frame pointer but which
report also those that are considered unreliable. This one can stay
the debug unwinder, used in warnings, crashes, etc... as it's proven solid
and it's simple.

- a dwarf based one for tools like perf and ftrace that don't require
the same degree of ultimate robustness. Besides, perf is a good
usecase to debug an unwinder because it can take snapshots of various scenario
of context stacking.

In fact, today in x86 we already have two distinct unwinder for debugging
(print_context_stack() does the full stack walk + fp validation) and
for perf (print_context_stack_bp() does only walk fp). The second is less
robust as it relies on fp to be always reliable and we miss entries considered
as unreliable but these can be useful.

Plugging a new unwinder for perf/ftrace should be fine as long as we really
control what we dereference. But this doesn't need to be proven mathematically
if it's only use by our profiling/tracing tools and not for real debuggging.

Now for userspace dwarf unwinding in perf, I guess we shouldn't do that from
the kernel. Dumping regs and chunks of stacks on the record stream and let
userspace play with that post mortem is probably wiser.
