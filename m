Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab2BJTox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:44:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab2BJTov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:44:51 -0500
Date: Fri, 10 Feb 2012 20:44:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
Message-ID: <20120210194426.GA17650@elte.hu>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
 <1328895795.25989.29.camel@laptop>
 <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
 <20120210192714.GE4998@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210192714.GE4998@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Feb 10, 2012 at 10:59:51AM -0800, Linus Torvalds escreveu:
> > On Fri, Feb 10, 2012 at 9:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > So I CC'ed Linus who has a strong here, jejb since he's the one that
> > > told me several time there's a number of literate dwarfs already in the
> > > kernel and Jan because I think it was him that tried last on x86.
> > 
> > I never *ever* want to see this code ever again.
> > 
> > Sorry, but last time was too f*cking painful. The whole (and *only*)
> > point of unwinders is to make debugging easy when a bug occurs. But
> > the f*cking dwarf unwinder had bugs itself, or our dwarf information
> > had bugs, and in either case it actually turned several "trivial" bugs
> > into a total undebuggable hell.
> > 
> > It was made doubly painful by the developers involved then several
> > times ignoring the problem, and claiming the code was bug-free when it
> > clearly wasn't, or trying to claim that the problem was that we set up
> > some random dwarf information wrong, when THAT GOES WITHOUT SAYING
> > (since dwarf is a complex mess that never gets any actual testing
> > except when things go wrong - at which point the code had better work
> > regardless of whether the dwarf info was correct or not).
> > 
> > So no. An unwinder that is several hundred lines long is simply not
> > even *remotely* interesting to me.
> > 
> > If you can mathematically prove that the unwinder is correct - even in
> > the presence of bogus and actively incorrect unwinding information -
> > and never ever follows a bad pointer, I'll reconsider.
> > 
> > In the absence of that, just follow the damn chain on the stack
> > *without* the "smarts" of an inevitably buggy piece of crap.
> 
> "Vote for --fno-omit-frame-pointer! One register is a cheap 
> price to pay for not going insane!"
> 
> /me goes back to non political things.

Well, instead of dropping it we could try to meet Linus's 
challenge, at least to a fair degree.

Also lets fundamentally treat GCC provided data as untrusted, 
hostile data and lets put lockdep-alike redundancy and resilence 
around it.

As a first step lets try input randomization unit tests. A lot 
of the broken unwind code was really just sloppy about boundary 
conditions.

I had a quick peek and I don't think it's constructed in a 
resilent enough form right now. For example there's no clear 
separation and checking of what comes from GCC and what not.

It *can* be done: lockdep is not hundreds but thousands of lines 
of highly complex code (with non-trivial algorithms such as 
graph walks), and still it has a very good track record - so 
it's possible.

Once that is done I'd like to try it myself in practice, without 
offering it as a pull to Linus. I see a *lot* of weird oopses 
all day in and out, often in impossible contexts, and the old 
dwarf unwinder was crap.

I'd also love to see perf callchains work on all kernels and 
extend into user-space as well, if that's possible in a sane 
fashion. 90% of the interesting apps out there are build with 
framepointers off, and the context of overhead is often rather 
obscure. Looking at good callchains is a good learning 
experience all around.

So it's not *entirely* crazy IMO, lets iterate this please. 
Jiri, are you still interested in it?

Thanks,

	Ingo
