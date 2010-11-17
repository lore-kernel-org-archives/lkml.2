Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754Ab0KQMmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:42:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:35879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab0KQMmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:42:46 -0500
Subject: Re: [patch] trace: Add user-space event tracing/injection
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <4CE3CB8A.8060608@kernel.org>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu>
	 <4CE3C7C2.7000200@kernel.org> <20101117123055.GA27063@elte.hu>
	 <4CE3CB8A.8060608@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 13:42:13 +0100
Message-ID: <1289997733.2109.743.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:33 +0200, Pekka Enberg wrote:
> On 11/17/10 2:30 PM, Ingo Molnar wrote:
> > What does the duration in milliseconds mean there? For things like
> >> GC and JIT, I want something like:
> >>
> >> void gc(void)
> >> {
> >>          prctl(PR_TASK_PERF_USER_TRACE_START, ...)
> >>
> >>          collect();
> >>
> >>          prctl(PR_TASK_PERF_USER_TRACE_END, ...)
> >> }
> >>
> >> So that it's clear from the tracing output that the VM was busy
> >> doing GC for n milliseconds. Barring background JIT'ing and
> >> pauseless GC, I'd also be interested in showing how much time the VM
> >> was actually _blocking_ the running application (which can happen
> >> with signals too, btw, for things like accessing data that's lazily
> >> initialized).
> > We can add two events: user_event_entry/user_event_exit - or we could use the string
> > to differentiate, and start it with:
> >
> >    "entry: ..."
> >    "exit: ..."
> >
> > And then the event timestamps (which are absolute and are available) could be used
> > to calculate the duration of this period.
> >
> > 'trace' could even be taught to treat such entry:/exit: strings in a special way, so
> > that you dont have to write Jato specific trace decoding bits?
> 
> Yes, makes sense. I like the API so lets convince others that it's 
> important enough to be merged. :-)

I don't much like it, Jato already does its own tracing for the anon_vma
symbols, it might as well write its own event log too (would need a
proper VDSO clock thingy though).

Both these, the anon_vma symbols and the events, should be implemented
in a libperf.so or the like so as not to rely on the crummy /tmp file
interface we've been using so far.

Apps can link against libperf_dummy.so to get weak stubs and LD_PRELOAD
libperf.so to get the real ones (perf record can do that LD_PRELOAD
automagically).

perf report will need to be taught to not only pick up the anon_vma
symbols but also look for the events to be merge sorted.

We already have this communication channel for Jato (due to the anon_vma
muck), might as well extend it.


