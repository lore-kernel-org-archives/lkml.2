Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab0KKAqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:46:16 -0500
Received: from mail.openrapids.net ([64.15.138.104]:51063 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757598Ab0KKAqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:46:15 -0500
Date: Wed, 10 Nov 2010 19:46:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [RFD tracing] Tracing ABI Work Plan
Message-ID: <20101111004612.GB32564@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:33:05 up 49 days,  4:35,  4 users,  load average: 0.13, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the Kernel Summit 2010 and Linux Plumber Conference, we came up to
the following conclusions (we're finally making progress !!):

- The ABIs of Ftrace and Perf are in active use, thus Linus has stated
  that they can not be changed.
- It has been stated at Kernel Summit that new ABIs should not go into
  mainline first, but should be tested in an out-of-tree first, and get
  feed back from their users.
- The goal is to have both Perf and Ftrace work well together, and have
  a more generic ABI. But the current ABI of both Perf and Ftrace fail to
  meet each others requirements, as well as requirement from a large user-base.

Therefore, as Thomas Gleixner pointed out, we have two choices: either we stop
there, keep the current ABIs and give up, or we create a new set of ABIs. I
hereby propose to come up with a new set of tracing ABIs and, this time, that we
_take our time_ before mainlining them -- trying them out in a separate tree for
a while beforehand. There is no hurry to push anything to mainline anyway,
because Ftrace and Perf answer the most pressing kernel developer tracing needs.
Let's work on the new ABI at the pace that everyone is happy with it.


First of all, I'm not a big fan of "hide-and-seek" games regarding motives and
end-goals, especially when it comes to designing ABIs. So here is my entire
high-level roadmap towards having tracer fully usable by my user-base in the
mainline kernel. I propose to split the upcoming task in the following 4
sub-items.


A) New ABI for user-space

This new ABI will provide the features long-awaited by tracing users. We've
already started this discussion by listing the requirements and acknowledging
them. It is now time to start discussing the ABI. Upon disagreement on answering
a specific requirement, two questions will arise:

1. How much trouble it really is to take care of this requirement. If the answer
   is "not much", then we simply take care of it.
2. If it really is a big deal to take care of a requirement at the ABI level,
   then we will have to discuss the use-cases.

Once we are on the same page with respect to these requirements, we can come up
with an ABI proposal for:

- Tracing control
- Trace format


B) Internal Instrumentation API

I propose to standardize the instrumentation mechanisms (Tracepoints, Function
Tracer, Dynamic Probes, System Call Tracing, etc), so they can be used by
Ftrace, Perf, and by the new ABI without requiring to build all three tracer
ABI code-bases in the kernel. This involves modularizing the instrumentation
sources, taking the following aspects into account:

- They should be stand-alone objects, which can be built without a full tracer
  enabled.
- They should offer a "registration/unregistration" API to tracers, so tracers
  can register a callback along with a private data pointer (this would fit
  with the "multiple concurrent tracing session" requirement).
- They should call these callbacks passing the private data pointer when the
  instrumentation is hit.
- They should provide a mechanism to list the available instrumentation (when it
  makes sense) and active instrumentation. E.g., it makes sense for tracepoints
  to list the available tracepoints, but it only makes sense for dynamic probes
  to list the enabled probes.

Masami Hiramatsu and Frederic Weisbecker already showed interest in undertaking
this task.


C) Ring Buffer

I propose to create a "lite" version of my generic ring buffer library which
will be specifically focused on the requirement list. It will simplify the code
review process.


D) Trace Clocks (hypervisor, kernel, user-space)

Dealing with tracing clock sources at the kernel, userland and hypervisor level
can be achieved by exposing the user requirements, deciding which approach makes
sense for synchronized trace clocks across hypervisor/kernel/userland, and
implement the kernel trace clocks, vDSO, and hypervisor support accordingly.


Feedback is welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
