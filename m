Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2KBWpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:45:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2KBWpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:45:11 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cV44URiwEzkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9SDdFD8QBGwA:10 a=hrke7HMuZDkSRR1YYKoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102223828.795874032@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 18:38:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8][RFC] tracing: Using recursion bits for function tracing and ring buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of months ago I was playing with getting recursion
fixed with the function tracer. There's a lot of places that could
use improvements, and I also found a few cases where the recursion
protection would have false positives causing missed function tracing.

I implemented a per context bit checking (Normal, SoftIRQ, IRQ and NMI).
Using 4 bits in the task_struct trace_recursion field, I was
able to fix these issues as well as improve the speed of the function
tracer and ring buffer.

Before the patches I had:

 # echo function > /debug/tracing/current_tracer
 # for i in `seq 10`; do ./hackbench 50; done
Time: 12.028
Time: 11.945
Time: 11.925
Time: 11.964
Time: 12.002
Time: 11.910
Time: 11.944
Time: 11.929
Time: 11.941
Time: 11.924

(average: 11.9512)

Now we have:

 # echo function > /debug/tracing/current_tracer
 # for i in `seq 10`; do ./hackbench 50; done
Time: 9.712
Time: 9.824
Time: 9.861
Time: 9.827
Time: 9.962
Time: 9.905
Time: 9.886
Time: 10.088
Time: 9.861
Time: 9.834

(average: 9.876)
    
This is a total of a 17.4% improvement in function tracing!


Steven Rostedt (8):
      ftrace: Fix global function tracers that are not recursion safe
      ftrace: Fix function tracing recursion self test
      ftrace: Optimize the function tracer list loop
      ftrace: Add context level recursion bit checking
      tracing: Make the trace recursion bits into enums
      tracing: Avoid unnecessary multiple recursion checks
      ftrace: Use only the preempt version of function tracing
      ring-buffer: User context bit recursion checking

----
 kernel/trace/ftrace.c          |   82 ++++++++++++++++---------
 kernel/trace/ring_buffer.c     |   85 +++++++++++++++++--------
 kernel/trace/trace.h           |  133 ++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace_functions.c |   61 +++++-------------
 kernel/trace/trace_selftest.c  |    3 +-
 5 files changed, 248 insertions(+), 116 deletions(-)
