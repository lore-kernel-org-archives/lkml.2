Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab0KQMY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:24:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934722Ab0KQMYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:24:55 -0500
Date: Wed, 17 Nov 2010 13:24:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101117122425.GA25294@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
 <20101117120740.GA24972@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117120740.GA24972@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Does this concept lend itself to tracing latencies in userspace applications 
> > that run in virtual machines (e.g. the Java kind)? I'm of course interested in 
> > this because of Jato [1] where bunch of interesting things can cause jitter: JIT 
> > compilation, GC, kernel, and the actual application doing something (in either 
> > native code or JIT'd code). It's important to be able to measure where 
> > "slowness" to desktop applications and certain class of server applications 
> > comes from to be able to improve things.
> 
> Makes quite a bit of sense.
> 
> How about the attached patch? It works fine with the simple testcase included in 
> the changelog. There's a common-sense limit on the message size - but otherwise it 
> adds support for apps to generate a free-form string trace event.

The entirely untested Jato patch below adds support for this to Jato's user-space 
tracer. Btw., you have _hundreds_ of tracepoints in Jato, wow!

The prctl() approach is very attractive because it's very simple to integrate. It's 
also reasonably fast, there's no fd baggage in prctl(). It is also arguably a 
'process/task event' so fits prctl()'s original design (if it ever had one ...).

Note, i kept the original Jato buffering as well, and the prctl() does finegrained 
events, one event per trace_printf() line printed.

I think it makes sense to generate a separate event for all trace_printf() calls, 
because that way the events propagate immediately. OTOH i dont know how large the 
trace messages are - if there's really big tables printed (or lines are constructed 
out of many trace_printf() calls) then it may make sense to buffer them a bit.

Anyway, this demonstrates the concept.

Thanks,

	Ingo

diff --git a/vm/trace.c b/vm/trace.c
index 0192de6..64030ff 100644
--- a/vm/trace.c
+++ b/vm/trace.c
@@ -24,10 +24,13 @@
  * Please refer to the file LICENSE for details.
  */
 
+#include <sys/prctl.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
 
+#define PR_TASK_PERF_USER_TRACE 35
+
 #include "jit/compiler.h"
 #include "lib/string.h"
 #include "vm/thread.h"
@@ -50,15 +53,24 @@ static void setup_trace_buffer(void)
 
 int trace_printf(const char *fmt, ...)
 {
+	unsigned long curr_pos;
 	va_list args;
 	int err;
 
 	setup_trace_buffer();
 
+	curr_pos = trace_buffer->length;
+
 	va_start(args, fmt);
 	err = str_vappend(trace_buffer, fmt, args);
 	va_end(args);
 
+	/*
+	 * Send the trace buffer to perf, it will show up as user:user events:
+	 * (on non-perf kernels this will produce a harmless -EINVAL)
+	 */
+	prctl(PR_TASK_PERF_USER_TRACE, trace_buffer->value + curr_pos, trace_buffer->length - curr_pos);
+
 	return err;
 }
 
