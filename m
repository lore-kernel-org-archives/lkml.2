Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab2FVSuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:50:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2FVSup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:50:45 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=CJvqTLXkAAAA:8 a=GKwZKRmK8wypKp4iO9gA:9 a=PUjeQqilurYA:10 a=u7mPDwm_9-sA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340391042.27036.248.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] perf fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Fri, 22 Jun 2012 14:50:42 -0400
In-Reply-To: <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
References: <20120622133650.GA24136@gmail.com>
	 <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 11:07 -0700, Linus Torvalds wrote:
> On Fri, Jun 22, 2012 at 6:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Steven Rostedt (1):
> >      ftrace: Make all inline tags also include notrace
> 
> Btw, this is something I've been wondering about: function call
> tracing and inlining seems to be fundamentally incompatible.

True that the -pg option never adds the mcount call to any function that
gets inlined. But just an FYI, the alternative -finstrument-functions,
which traces both start and stop of the function, even does inlined
functions. Which one one of the reasons I totally avoided it.

> 
> And gcc can (and does, depending on version and details) inline pretty
> much any static function, whether we mark it inline or not.

Right, which means that those do not get traced either.

> 
> Now, there's no question that we don't want inlined functions to be
> traced, but that actually means that the *logical* thing would be to
> try to somehow tell gcc to not ever do the whole stupid mcount thing
> for functions that *might* be inlined - and at least be consistent
> about it.

Hmm, I'm not sure how to tell gcc that :-/

> 
> IOW, is there some way to get the mcount thing to only happen for
> functions that either have their address taken, or have external
> visibility?
> 
> Because that mcount thing is expensive as hell, if people haven't
> noticed (and I'm not talking about just the call instruction that I
> think we can stub out

It is stubbed out. Has been since day one, when DYNAMIC_FTRACE is
supported and enabled.

>  - it changes code generation in other ways too).

One thing it does, which I hate, is that it enables (forces) frame
pointers.

> And it looks like distros enable it by default, which annoys my
> performance-optimizing soul deeply.

We have been working on an alternative. That is the -mfentry, and I have
working code that is still in the testing phase (and looking good!).

When you add -mfentry with -pg instead of calling mcount, which comes
after the frame pointer has been set up, it calls fentry, as the very
first instruction in the function. It should not interfere with any
other code generation.

The -mfentry is supported since gcc 4.6.0 and only for x86 (thanks to
Andi Kleen for doing this. Here's my first email that described it a
little (I've been working on various versions, but it has settled down
recently):

https://lkml.org/lkml/2011/2/9/271

Back then, one of the issues I worried about was its interaction with
kprobes. As kprobes commonly are inserted at the first instruction of a
function, and kprobes could not be inserted at a ftrace nop, this would
cause issues for users wanting to insert their probe at the beginning of
the function.

But Masami has already helped me in fixing this up. Both the kprobes
issue and the fentry and no framepointers code is working well. I was
going to push it for 3.7 so that I can vindicate it a bit more.

Here's my last RFC patch set for the kprobes/ftrace work. Where kprobes
can actually be optimized by using the ftrace infrastructure.

https://lkml.org/lkml/2012/6/12/668

-- Steve


> 
> So doing it a bit less would be lovely.
> 
>                       Linus


