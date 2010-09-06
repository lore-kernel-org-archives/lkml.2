Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0IFR31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:29:27 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50806 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754685Ab0IFR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:29:23 -0400
Date: Mon, 6 Sep 2010 13:29:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
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
Message-ID: <20100906172920.GA18220@Krystal>
References: <20100903131213.GA3230@Krystal> <20100903164742.087da8f4@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903164742.087da8f4@basil.nowhere.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:42:47 up 226 days, 18:19,  3 users,  load average: 0.02, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Fri, 3 Sep 2010 09:12:13 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Here is a news that should please Linux distributions which have been
> > overwhelmed by the size of the LTTng patchset. I have extracted the
> > LTTng tracer patches from the LTTng kernel tree and repackaged it
> > into a new "lttng-modules" package. There is still a dependency on
> > the LTTng kernel tree at the moment, but the objective is to
> > gradually reduce the size of this 5 years long mainline fork.
> 
> Efforts to get rid of forks are always good.
> 
> Could you perhaps elaborate a bit what changes you need
> in mainline (ideally separated in "essential" and "nice to
> have") and how big the left over patches are?

Sure. Here is the detail of the pieces that still have to be kept in the LTTng
tree:

* Essential:

- Adding interfaces to dynamic kprobes and tracepoints to list the currently
  available instrumentation as well as notifiers to let LTTng know about events
  appearing while tracing runs (e.g. module loaded, new dynamic probe added).
- Export the splice_to_pipe symbol (and probably some more I do not recall at
  the moment).
- Add ability to read the module list coherently in multiple reads when racing
  with module load/unload.
- Either add the ability to fault in NMI handlers, or add call to
  vmalloc_sync_all() each time a module is loaded, or export vmalloc_sync_all()
  to GPL modules so they can ensure that the fault-in memory after using
  vmalloc but before the memory is used by the tracer.

These essential patches are very small.


* Nice to have:

- Support for the LTTng statedump, which saves the initial kernel state into the
  trace at trace start:
  - EXPORT_SYMBOL_GPL() for tasklist_lock, irq_desc, ...
  - Add per-arch iterators to dump the list of system calls and IDT into the
    trace.
- Generic Ring Buffer Library.
  - Generic alignment API.
  - Mark atomic notifier call chain "notrace".
  - CPU idle notifier notifiers (for trace streaming with deferrable timers).
  - Poll wait exclusive (to address thundering herd problem in poll()).
  - prio_heap.c new remove_maximum(), replace() and cherrypick().
  - Inline memcpy().
- Trace clock
  - Faster trace clock implementation.
  - Export the faster trace clock to userspace for UST through a vDSO.
- Jump based on asm goto, which will minimize the impact of disabled
  tracepoints. (the patchset is being proposed by Jason Baron)
- Kernel OOPS "lttng_nesting" level printout.

These "nice to have" patches are a bit larger.

The other patches in the LTTng tree can either wait or are planned for
deprecation. The instrumentation patches can be considered for mainlining later
on. Replacing the "Kernel Markers" infrastructure still being used in LTTng by
TRACE_EVENT() will shorten the LTTng tree considerably.


> Or rather how difficult would it be to simply run
> the LTT userland on top of the tracing code that is
> in mainline, even at loss of some functionality?

Moving LTT userland to these tools would require a large rewrite of the code
that reads the trace format, and still, my users needs would not be fulfilled.
By moving the LTT userland code to the less efficient schemes used in Perf and
Ftrace, my users would just be to lose in terms of performance, features, and
information accuracy.

The problem here is that the tracing tools in mainline are not suitable for my
user's needs. Amongst them, Perf lacks the flight recorder mode, is painfully
slow and generates huge amount of useless event header data. Ftrace event header
size is slightly better than Perf, but its handling of time-stamps with respect
to concurrency can lead users to wrong results in terms of irq and softirq
handler duration. LTTng event headers, IMHO, are by far superior to those of
Perf and Ftrace, and this is what lets LTTng have a lower overhead while keeping
less complex, yet more generic, event headers, and provide more accurate
information.

I am currently working on a trace format converter to/from a common trace format
(for which I'm at round 3 of the requirements RFC document:
http://lkml.indiana.edu/hypermail/linux/kernel/1009.0/00116.html), so at least
we can start sharing the userland tools. However, given the missing pieces in
Perf and Ftrace, LTTng still fulfills a pressing user need that's overlooked by
the other tracers.

Thanks,

Mathieu


> 
> Thanks,
> 
> -Andi

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
