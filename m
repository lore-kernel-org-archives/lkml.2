Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0KQM6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:58:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0KQM6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:58:51 -0500
Date: Wed, 17 Nov 2010 13:58:27 +0100
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
Message-ID: <20101117125827.GB27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
 <20101117120740.GA24972@elte.hu>
 <4CE3C7C2.7000200@kernel.org>
 <20101117123055.GA27063@elte.hu>
 <4CE3CB8A.8060608@kernel.org>
 <1289997733.2109.743.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289997733.2109.743.camel@laptop>
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

> On Wed, 2010-11-17 at 14:33 +0200, Pekka Enberg wrote:
> > On 11/17/10 2:30 PM, Ingo Molnar wrote:
> > > What does the duration in milliseconds mean there? For things like
> > >> GC and JIT, I want something like:
> > >>
> > >> void gc(void)
> > >> {
> > >>          prctl(PR_TASK_PERF_USER_TRACE_START, ...)
> > >>
> > >>          collect();
> > >>
> > >>          prctl(PR_TASK_PERF_USER_TRACE_END, ...)
> > >> }
> > >>
> > >> So that it's clear from the tracing output that the VM was busy
> > >> doing GC for n milliseconds. Barring background JIT'ing and
> > >> pauseless GC, I'd also be interested in showing how much time the VM
> > >> was actually _blocking_ the running application (which can happen
> > >> with signals too, btw, for things like accessing data that's lazily
> > >> initialized).
> > > We can add two events: user_event_entry/user_event_exit - or we could use the string
> > > to differentiate, and start it with:
> > >
> > >    "entry: ..."
> > >    "exit: ..."
> > >
> > > And then the event timestamps (which are absolute and are available) could be used
> > > to calculate the duration of this period.
> > >
> > > 'trace' could even be taught to treat such entry:/exit: strings in a special way, so
> > > that you dont have to write Jato specific trace decoding bits?
> > 
> > Yes, makes sense. I like the API so lets convince others that it's 
> > important enough to be merged. :-)
> 
> I don't much like it, Jato already does its own tracing for the anon_vma
> symbols, it might as well write its own event log too (would need a
> proper VDSO clock thingy though).

The problem is that it then does not properly mix with other events outside of the 
control of the application.

For example if there are two apps both generating user events, but there's no 
connection with them, a system-wide tracer wont get a properly ordered set of events 
- both apps will trace into their own buffers. So if we have:

  CPU1

  app1: "user event X"
  app2: "user event Y"

Then a 'trace --all' system-wide tracing session will not get proper ordering 
between app1 and app2's events. It only gets timestamps - which may or may not be 
correct.

User-space tracing schemes tend to be clumsy and limiting. There's other 
disadvantages as well: approaches that expose a named pipe in /tmp or an shmem 
region are not transparent and robust either: if user-space owns a pending buffer 
then bugs in the apps can corrupt the trace buffer, can prevent its flushing when 
the app goes down due to an app bug (and when the trace would be the most useful), 
etc. etc.

Also, in general their deployment isnt particularly fast nor lightweight - while 
prctl() is available everywhere.

And when it comes to tracing/instrumentation, if we make deployment too complex, 
people will simply not use it - and we all use. A prctl() isnt particularly sexy 
design, but it's a task/process event that we are generating (so related to prctls), 
plus it's available everywhere and is very easy to deploy.

Thanks,

	Ingo
