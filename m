Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0IKBS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 21:18:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0IKBSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 21:18:25 -0400
X-Authority-Analysis: v=1.1 cv=2UVid5d+x37NY9sg6AthlbJk7luIC5bYp3eyRq7Iv0o= c=1 sm=0 a=Ot0fQfLCyksA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2zZSigKMjKZzpbo2P9wA:9 a=H-eGcl1lO3rXBuSDWoBQ5AGspqgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2] trace: funcgraph tracer - adding funcgraph-irq option
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100909144430.GG20955@cmpxchg.org>
References: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
	 <1279828821.3319.23.camel@gandalf.stny.rr.com>
	 <20100723131913.GB1829@jolsa.brq.redhat.com>
	 <1283876920.5133.125.camel@gandalf.stny.rr.com>
	 <20100909144430.GG20955@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 10 Sep 2010 21:18:15 -0400
Message-ID: <1284167895.5786.2365.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Thu, 2010-09-09 at 16:44 +0200, Johannes Weiner wrote:

> Although greatly reduced, I still see the following noise in the trace
> output with the IRQ filtering enabled:
> 
>  1)               |    wakeup_flusher_threads() {
>  1)   0.205 us    |      __rcu_read_lock();
>  1)   0.271 us    |      bdi_has_dirty_io();
>  1)   0.287 us    |      bdi_has_dirty_io();
>  1)   0.217 us    |      bdi_has_dirty_io();
>  1)               |      bdi_has_dirty_io() {
>  1)               |        smp_invalidate_interrupt() {
>  1)   0.220 us    |          native_apic_mem_write();
>  1)   0.794 us    |        } /* smp_invalidate_interrupt */
>  1)   1.413 us    |      } /* bdi_has_dirty_io */
>  1)   0.218 us    |      bdi_has_dirty_io();
>  1)   0.213 us    |      bdi_has_dirty_io();
>  1)   0.215 us    |      bdi_has_dirty_io();
>  1)               |      smp_invalidate_interrupt() {
>  1)   0.234 us    |        native_apic_mem_write();
>  1)   0.819 us    |      } /* smp_invalidate_interrupt */
>  1)   0.240 us    |      bdi_has_dirty_io();
>  1)   0.259 us    |      bdi_has_dirty_io();


You could also try the below patch. When you set funcgraph-irqs to 0,
the function tracer will stop recording inside interrupts (except for
the part before it calls irq_enter()). But that's still good, because
you can still see where interrupts happened.

Here's how to use it:

# echo 0 > tracing_on
# echo function_graph > current_tracer
# echo 0 > options/funcgraph-irqs
# echo 1 > tracing_on
<run-stuff>

When you cat the trace file, it wont have the irqs on because of Jiri's
patch. But..

 # echo 1 > options/funcgraph-irqs
 # echo 1 > options/latency-format
 # cat trace
# tracer: function_graph
#
#      _-----=> irqs-off        
#     / _----=> need-resched    
#    | / _---=> hardirq/softirq 
#    || / _--=> preempt-depth   
#    ||| / _-=> lock-depth      
#    |||| /                     
# CPU|||||  DURATION                  FUNCTION CALLS
# |  |||||   |   |                     |   |   |   |
 1)  d..1.  3.090 us    |  }
 1)  d..1.              |  mwait_idle() {
 1)   ==========> |
 1)  d..1.              |    smp_apic_timer_interrupt() {
 1)  d..1.  0.483 us    |      native_apic_mem_write();
 1)  d..1.              |      exit_idle() {
 1)  d..1.  0.511 us    |        __rcu_read_lock();
 1)  d..1.  0.445 us    |        __rcu_read_unlock();
 1)  d..1.  3.903 us    |      }
 1)  d..1.              |      irq_enter() {
 1)  d..1.  0.562 us    |        rcu_irq_enter();
 1)  d..1.  0.461 us    |        idle_cpu();
 1)  d.h1.  9.337 us    |      }
 1)  d..2.              |      do_softirq() {
 1)  d..2.              |        __do_softirq() {

That's because it uses "if (in_irq())" which in_irq() returns true after
irq_enter() and set to false again in irq_exit(), which is not shown,
because it was skipping them.  But softirqs are still displayed, and
here it was run from the interrupt context itself before going back to
whatever it interrupted.

-- Steve

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 8674750..02c708a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -15,6 +15,9 @@
 #include "trace.h"
 #include "trace_output.h"
 
+/* When set, irq functions will be ignored */
+static int ftrace_graph_skip_irqs;
+
 struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
@@ -208,6 +211,14 @@ int __trace_graph_entry(struct trace_array *tr,
 	return 1;
 }
 
+static inline int ftrace_graph_ignore_irqs(void)
+{
+	if (!ftrace_graph_skip_irqs)
+		return 0;
+
+	return in_irq();
+}
+
 int trace_graph_entry(struct ftrace_graph_ent *trace)
 {
 	struct trace_array *tr = graph_array;
@@ -222,7 +233,8 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 		return 0;
 
 	/* trace it when it is-nested-in or is a function enabled. */
-	if (!(trace->depth || ftrace_graph_addr(trace->func)))
+	if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
+	      ftrace_graph_ignore_irqs())
 		return 0;
 
 	local_irq_save(flags);
@@ -1334,6 +1346,14 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static int func_graph_set_flag(u32 old_flags, u32 bit, int set)
+{
+	if (bit == TRACE_GRAPH_PRINT_IRQS)
+		ftrace_graph_skip_irqs = !set;
+
+	return 0;
+}
+
 static struct trace_event_functions graph_functions = {
 	.trace		= print_graph_function_event,
 };
@@ -1360,6 +1380,7 @@ static struct tracer graph_trace __read_mostly = {
 	.print_line	= print_graph_function,
 	.print_header	= print_graph_headers,
 	.flags		= &tracer_flags,
+	.set_flag	= func_graph_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_function_graph,
 #endif


