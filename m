Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab1LGW6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:58:04 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40970 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755730Ab1LGW6C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:58:02 -0500
Date: Wed, 7 Dec 2011 17:57:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Peter Zijlstra <peterz@infradead.org>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111207225758.GA6541@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com> <1322776568.4699.52.camel@twins> <20111201221404.GC3365@kroah.com> <1322780830.4699.62.camel@twins> <20111201231751.GA4961@kroah.com> <20111205141749.GC28866@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111205141749.GC28866@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:46:15 up 379 days,  2:49,  3 users,  load average: 0.01, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

* Ingo Molnar (mingo@elte.hu) wrote:
[...]
> Mathieu, please work with the tracing folks who DO care about 
> this stuff. It's not like there's a lack of interest in this 
> area, nor is there a lack of willingness to take patches. What 
> there is a lack of is your willingness to actually work on 
> getting something unified, integrated to users...
> 
> LTTNG has been going on for how many years? I havent seen many 
> steps towards actually *merging* its functionality - you insist 
> on doing your own random thing, which is different in random 
> ways. Yes, some of those random ways may in fact be better than 
> what we have upstream - would you be interested in filtering 
> those out and pushing them upstream? I certainly would like to 
> see that happen.
>
> We want to pick the best features, and throw away current 
> upstream code in favor of superior out of tree code - this 
> concept of letting crap sit alongside each other when people do 
> care i cannot agree with.

LTTng 2.0, today, offers a unified interface for kernel and userspace
tracing, in the form of libraries and git-alike command line user
interface. It produces a trace format (CTF) that has been developed in
collaboration with hardware vendors and reviewed by tracing developers
of the Linux community, which allows analyzing correlated traces across
the software and hardware stacks, and supports being streamed over the
network with zero-copy both in TCP, UDP format, with optional
encryption, checksum, and more. It supports multiple concurrent users,
and hooks with tracepoints, Perf PMU counters, kprobes, kretprobes, and
system calls, with the ability to attach "context" information prepended
before each event record as selected by the user when setting up a
tracing session.

It is currently self-contained: it's been designed to be shipped as a
stand-alone set of self-contained modules, but I recently received the
offer to get it pulled into staging, which I accepted.

In my opinion, tracers need to be split into three distinct parts:

1) core tracing infrastructure that _needs to_ be shared. This mainly
   targets instrumentation, and I've done my share of contribution to
   mainline on this front already. I think the infrastructure we have
   today is in pretty good shape.

2) tracing infrastructure that _could_ be shared. I'm mostly targeting ring
   buffers and trace clocks there. It could be a nice-to-have to share the
   implementation, as long as it does not get in the way of what each
   project is trying to achieve. So far, what I noticed is that each
   project is lacking understanding of the intent and constraints of the
   other projects, thus either considering what the others are doing
   as over- or under- engineering, depending on the context. Therefore,
   as long as there is no agreement on the right amount of care that
   needs to be put in the design of these components, it might be best
   to duplicate the implementation and slowly converge as each project
   gets to understand the other project's constraints. To make progress
   on this front, you need to have both code-bases into mainline.
   
3) interfaces to user-space: very much like filesystems, these ABIs
   don't need to be shared across projects that have different
   use-cases. Having multiple tracer ABIs, if self-contained, should
   not hurt anybody and just increase the rate of innovation. Sadly,
   the ABIs exposed by perf/ftrace do not seem to be a good fit for
   LTTng use-cases. Since the perf/ftrace ABIs, as well as the LTTng
   ABI, are all already used by many tools, it will likely be really
   difficult to change them overnight.

As an example of where we could benefit from working together, LTTng is
currently using a shadow copy of the TRACE_EVENT macros, because
the upstream version is quite limiting with respect to generating
compact probe code. It could be good to integrate those changes
upstream, and I think the best way to achieve this is if the perf and
ftrace developers can have a look at the approach taken by LTTng to
achieve this -- which is better done if LTTng is merged into staging.

Another example is how LTTng extracts system call arguments types, which
is performed by generating TRACE_EVENT description of the system call
table with a script. We could definitely help out each other in this
area.

There are certainly many other areas where we could eventually benefit
from working together, listed above as #2 "tracing infrastructure that
_could_ be shared", but I think it is better to first focus on the core
infrastructure that we need to share before getting into the territory
of the infrastructure we could share if took the time to understand each
other's requirements fully first. Meanwhile, having a duplicated
implementation of these parts that "could" be shared should not hurt
anyone -- it would even help understanding each other --, as long as
they stay self-contained.

In summary, I'm really open to help out on working on common pieces of
infrastructures, but for that they need to take into account both the
current perf/ftrace use-cases and the LTTng use-cases.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
