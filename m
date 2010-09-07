Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0IGHWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:22:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35141 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0IGHWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:22:46 -0400
Date: Tue, 7 Sep 2010 09:22:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [ANNOUNCEMENT] LTTng tracer re-packaged as stand-alone modules
Message-ID: <20100907092240.7f4b3a68@basil.nowhere.org>
In-Reply-To: <20100906172920.GA18220@Krystal>
References: <20100903131213.GA3230@Krystal>
	<20100903164742.087da8f4@basil.nowhere.org>
	<20100906172920.GA18220@Krystal>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 13:29:20 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

Mathieu,

One experience I have with closely looking at other long term
forked patchkits is that over time they tend to accumulate
stuff that is not really needed and various things which
are very easy to integrate. It sounds like you have some 
candidates like this here.

> - Adding interfaces to dynamic kprobes and tracepoints to list the
> currently available instrumentation as well as notifiers to let LTTng
> know about events appearing while tracing runs (e.g. module loaded,
> new dynamic probe added).

That sounds trivial.

> - Export the splice_to_pipe symbol (and probably some more I do not
> recall at the moment).

Dito.

> - Add ability to read the module list coherently in multiple reads
> when racing with module load/unload.

Can't you just take the module_mutex?

> - Either add the ability to fault in NMI handlers, or add call to
>   vmalloc_sync_all() each time a module is loaded, or export
> vmalloc_sync_all() to GPL modules so they can ensure that the
> fault-in memory after using vmalloc but before the memory is used by
> the tracer.

I thought Linus had fixed that in the page fault handler?

It's a generic problem hit by other code, so it needs to be fixed
in mainline in any case.

>   - CPU idle notifier notifiers (for trace streaming with deferrable
> timers).

x86 has them already, otherwise i7300_idle et.al. wouldn't work.
What do you need what they don't do?

>   - Poll wait exclusive (to address thundering herd problem in
> poll()).

How does that work? Wouldn't that break poll semantics?
If not it sounds like a general improvement.

I assume epoll already does it?

>   - prio_heap.c new remove_maximum(), replace() and cherrypick().
>   - Inline memcpy().

What's that? gcc does inline memcpy

> - Trace clock
>   - Faster trace clock implementation.

What's the problem here? If it's faster it should be integrated.

I know that the old sched_clock did some horrible things
that could be improved.

>   - Export the faster trace clock to userspace for UST through a vDSO.

A new vDSO? This should be just a register_posix_clock and some
glue in x86 vdso/ Makes sense to have, although I would prefer
a per thread clock than a per CPU clock I think. But per CPU
should be also fine.

> - Jump based on asm goto, which will minimize the impact of disabled
>   tracepoints. (the patchset is being proposed by Jason Baron)

I think that is in progress.

BTW I'm still hoping that the old "self modifying booleans"
patchkit will make it back at some point. I liked it as a general
facility.

> - Kernel OOPS "lttng_nesting" level printout.

This sounds very optional.


> Ftrace event header size is slightly better than
> Perf, but its handling of time-stamps with respect to concurrency can
> lead users to wrong results in terms of irq and softirq handler
> duration. 

What is the problem with ftrace time stamps? They should 
be all just per CPU? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
