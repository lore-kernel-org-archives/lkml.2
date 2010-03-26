Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0CZOyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:54:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab0CZOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:54:04 -0400
X-Authority-Analysis: v=1.0 c=1 a=ANRBxz73AsgA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=VhIpXcTJnYc6juHHyloA:9 a=F4yoyy_f4vuIoY-tiLEA:7 a=k4cxMxyCbVozgSFI8XajBXTaAV4A:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv3 0/2] tracing: function graph output for
 preempt/irqs-off tracers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 26 Mar 2010 10:53:59 -0400
Message-ID: <1269615239.19685.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 13:32 +0100, Jiri Olsa wrote:
> hi,
> 
> I reworked it based on your comments:
> 
> - the function_graph tracer should have the same output
>   as current version even with events enabled,
>   unless I missed something again ;)
> 
> - I gave up the idea of function_graph events,
>   since it was unsuitable for outputing other
>   events as comments "/* */"
> 
> - I'm not including the raw function_graph for now
> 

Getting better, but I still have some issues ;-)

Without graph, header looks like this: (old way)

# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.34-rc2
# --------------------------------------------------------------------
# latency: 326 us, #73/73, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0
#P:4)
#    -----------------
#    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: save_args
#  => ended at:   __do_softirq
#
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /_--=> lock-depth       
#                |||||/     delay             
#  cmd     pid   |||||| time  |   caller      
#     \   /      ||||||   \   |   /           
  <idle>-0       1d..1.    1us+: trace_hardirqs_off_thunk <-save_args


Lots of good info.

But if I enable the graph:

 # trace-cmd start -p irqsoff -O display-graph
 # cat /debug/tracing/trace

# tracer: irqsoff
#
#      _-----=> irqs-off        
#     / _----=> need-resched    
#    | / _---=> hardirq/softirq 
#    || / _--=> preempt-depth   
#    ||| / _-=> lock-depth      
#    |||| /                     
# CPU|||||  DURATION                  FUNCTION CALLS
# |  |||||   |   |                     |   |   |   |
trace-cm-3661    0d.s4.    1us+: trace_hardirqs_off_thunk <-save_args
 0)   ==========> |
 0)  d.s4.              |          smp_apic_timer_interrupt() {
 0)  d.s4.  5.740 us    |            native_apic_mem_write();
 0)  d.s4.  6.458 us    |            exit_idle();
 0)  d.s4.              |            irq_enter() {
 0)  d.s4.  5.391 us    |              rcu_irq_enter();


I see you are using the function graph output, but you just lost some
important information that was with the original tracer.

Another thing is. If I disable the option after I record, I get this:

 # echo 0 > /debug/tracing/tracing_enabled
 # echo 0 > /debug/tracing/option/display-graph
 # cat /debug/tracing/trace

# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.34-rc2
# --------------------------------------------------------------------
# latency: 1084 us, #210/210, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0
#P:4)
#    -----------------
#    | task: irqbalance-2672 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: save_args
#  => ended at:   __do_softirq
#
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /_--=> lock-depth       
#                |||||/     delay             
#  cmd     pid   |||||| time  |   caller      
#     \   /      ||||||   \   |   /           
irqbalan-2672    0d..2.    2us+: trace_hardirqs_off_thunk <-save_args
irqbalan-2672    0d..2.   10us+: Unknown type 14
irqbalan-2672    0d..2.   16us+: Unknown type 14
irqbalan-2672    0d..2.   20us+: Unknown type 13
irqbalan-2672    0d..2.   25us+: Unknown type 14
irqbalan-2672    0d..2.   29us+: Unknown type 13
irqbalan-2672    0d..2.   33us+: Unknown type 14
irqbalan-2672    0d..2.   37us+: Unknown type 14
irqbalan-2672    0d..2.   42us+: Unknown type 13
irqbalan-2672    0d..2.   49us+: Unknown type 14
irqbalan-2672    0d..2.   55us+: Unknown type 13
irqbalan-2672    0d.h2.   62us+: Unknown type 13


I think you can still do the "event" part, without effecting the way the
function graph outputs normally. I would not have given up on that
method.  You don't need to worry about it processing other events,
because when you register it to write as an event, it will only be
called when a function graph event was found. It will not be processing
other events. Only when the tracer itself overrides the default writing
will it do so.

-- Steve

> 
> attached patches:
> - 1/2 graph output support for irqsoff tracer
> - 2/2 graph output support for preemptirqsoff/preemptoff tracers
> 
> plz let me know what you think
> 
> wbr,
> jirka
> ---
>  kernel/trace/trace.c                 |   31 ++++--
>  kernel/trace/trace.h                 |   10 ++
>  kernel/trace/trace_functions_graph.c |   15 ++-
>  kernel/trace/trace_irqsoff.c         |  200 ++++++++++++++++++++++++++++++++-
>  4 files changed, 233 insertions(+), 23 deletions(-)


