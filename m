Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0C2LRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:17:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab0C2LRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:17:13 -0400
Date: Mon, 29 Mar 2010 13:17:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv3 0/2] tracing: function graph output for
 preempt/irqs-off tracers
Message-ID: <20100329111701.GC1715@jolsa>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
 <1269615239.19685.78.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269615239.19685.78.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:53:59AM -0400, Steven Rostedt wrote:
> On Fri, 2010-03-26 at 13:32 +0100, Jiri Olsa wrote:

SNIP

> 
> Getting better, but I still have some issues ;-)
> 
> Without graph, header looks like this: (old way)
> 
> # tracer: irqsoff
> #
> # irqsoff latency trace v1.1.5 on 2.6.34-rc2
> # --------------------------------------------------------------------
> # latency: 326 us, #73/73, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0
> #P:4)
> #    -----------------
> #    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> #    -----------------
> #  => started at: save_args
> #  => ended at:   __do_softirq
> #
> #
> #                  _------=> CPU#            
> #                 / _-----=> irqs-off        
> #                | / _----=> need-resched    
> #                || / _---=> hardirq/softirq 
> #                ||| / _--=> preempt-depth   
> #                |||| /_--=> lock-depth       
> #                |||||/     delay             
> #  cmd     pid   |||||| time  |   caller      
> #     \   /      ||||||   \   |   /           
>   <idle>-0       1d..1.    1us+: trace_hardirqs_off_thunk <-save_args
> 
> 
> Lots of good info.

right, I missed the print_trace_header call..

SNIP

>  # echo 0 > /debug/tracing/tracing_enabled
>  # echo 0 > /debug/tracing/option/display-graph
>  # cat /debug/tracing/trace
> 
> # tracer: irqsoff
> irqbalan-2672    0d..2.   55us+: Unknown type 13
> irqbalan-2672    0d.h2.   62us+: Unknown type 13

I forgot the max_tr buffer is actually the one displayed,
so it needs reset as well when the display-graph option
is switched on/off.


> 
> 
> I think you can still do the "event" part, without effecting the way the
> function graph outputs normally. I would not have given up on that
> method.  You don't need to worry about it processing other events,
> because when you register it to write as an event, it will only be
> called when a function graph event was found. It will not be processing
> other events. Only when the tracer itself overrides the default writing
> will it do so.

The events would be called only for TRACE_GRAPH_RET, TRACE_GRAPH_ENT entries and
not for others, thats right.

However it's the graph ouput code that outputs other events' text
within "/*" and "*/".

So using the event way, all other events would be printed as normal
events(standard lines not alligned) with the standard header...
not like comments, as they are in the function_graph tracer.

I thought it'd be good for graph output to stay the same in irqsoff
tracer as in function_graph tracer.. if that is not the concern
the event way would be probably nicer :)

I'm sending updated patchset with above 2 fixies right away,
I can do/resend the event way later if needed.

thanks,
jirka
