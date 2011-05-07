Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1EGOoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 10:44:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab1EGOoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 10:44:17 -0400
Date: Sat, 7 May 2011 16:44:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110507144402.GC2859@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304765110.25414.2564.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 2) we separate perf from ftrace and keep the "stable" ABI for perf, and let 
> ftrace advance into a more efficient tracer.

The thing is, ftrace is still largely separated from perf, and this is why this 
regression came in: a random tracing 'cleanup' churn was done to 'tracing' 
which broke PowerTop.

Look at the commit itself:

  e6e1e2593592: tracing: Remove lock_depth from event entry

Clearly you didnt even *realize* that there's a whole tooling world behind this 
mechanism ...

The core perf ABI is set up in a way that makes it rather hard to break the ABI 
accidentally. I can bisect back kernel release after kernel release and old 
tooling will work on new kernel and new tooling will work on old kernels.

PowerTop uses the perf ABI because it's a rather convenient and unified method 
to get a rich selection of events via the same facility, same ring-buffer, 
using a system call ABI, etc.

The ftrace event bits on the other hand, still somewhat glued on to the perf 
ABI are still very fragile to such spurious changes like the one that caused 
the regression here.

I raised this issue in the past. ftrace and perf has to be unified sooner 
rather than later.

> Here's the choices then:
> 
> 1) we get libparsevent.so out into the world and all tools can use it, and 
> the raw formats of the trace events will no longer be an issue as long as the 
> names of events and fields stay the same.

Firstly, such an event parser already exists in 
tools/perf/util/parse-events.[ch], so if you want to librarize it please talk 
to Arnaldo to create tools/perf/lib/ and a libperf.so.

There's 10 separate contributors to that file already:

 earth4:~/tip> git-authors-email tools/perf/util/parse-events.c 
      2  Peter Zijlstra <peterz@infradead.org>
      2  Stephane Eranian <eranian@google.com>
      2  Ulrich Drepper <drepper@redhat.com>
      3  Jason Baron <jbaron@redhat.com>
      3  Li Zefan <lizf@cn.fujitsu.com>
      3  Peter Zijlstra <a.p.zijlstra@chello.nl>
      7  Frederic Weisbecker <fweisbec@gmail.com>
      7  Jaswinder Singh Rajput <jaswinder@kernel.org>
     13  Arnaldo Carvalho de Melo <acme@redhat.com>
     15  Ingo Molnar <mingo@elte.hu>

Most notably *you* are not amongst them. Not a single commit out of close to a 
hundred commits. Why not? This really demonstrates the level of disinterest you 
are showing towards perf based tooling, still you keep modifying the underlying 
code in the kernel.

Secondly, you are solving the wrong problem and you are not seeing the real 
problems. We can keep and we *will* keep ABIs, it's not hard. 4 bytes padding 
is not an issue and it never was for PowerTop nor for any other real person who 
relies on tracing.

As i see it the problem is the thought-less ftrace churn and the fragility of 
how TRACE_EVENT() can be changed.

Really, ftrace and in particular you are showing a huge disconnect and i'm 
increasingly unhappy about it. Look at this very thread: you fought tooth and 
nail to even *acknowledge* that there is a problem...

As things look like from my side it appears you want to keep ftrace a messy, 
forked project with no regard to perf based tooling and this will fragment 
Linux instrumentation, the many technical disadvantages be damned.

I simply do not see that you understand this whole problem space, i do not see 
that you are driving towards unifying ftrace and perf - i only see that you are 
hacking in random, sometimes harmful directions and that you are stubornly 
ignoring my negative feedback about this. If problems like this continue i will 
have to stop pulling new ftrace features from you.

Thanks,

	Ingo
