Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1BLBw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:52:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1BLBwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:52:25 -0500
Subject: Re: [BUG?] tracing/function_graph: set_graph_function was broken
 from 2.6.36-rc2
From: Steven Rostedt <srostedt@redhat.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: zhiping zhong <xzhong86@163.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fweisbec <fweisbec@gmail.com>
In-Reply-To: <AANLkTikA2r5VroeXKfXspmh+ZdPL3T=c3m3rwggqdCVP@mail.gmail.com>
References: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com>
	 <1295544654.19789.19.camel@fedora>
	 <AANLkTin6g8SGnuG6j6JVCdBvOeiBj8Quwr2T9K+3jUwq@mail.gmail.com>
	 <1295635231.26768.2.camel@fedora>
	 <AANLkTikA2r5VroeXKfXspmh+ZdPL3T=c3m3rwggqdCVP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 11 Feb 2011 20:52:19 -0500
Message-ID: <1297475539.26768.2313.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 11:30 +0800, wu zhangjin wrote:
> On Sat, Jan 22, 2011 at 2:40 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> > On Fri, 2011-01-21 at 17:27 +0800, wu zhangjin wrote:
> >> On Fri, Jan 21, 2011 at 1:30 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> >
> >> >> trace_graph_entry():
> >> >>
> >> >>         [snip]
> >> >>         /* trace it when it is-nested-in or is a function enabled. */
> >> >>         if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
> >> >>               ftrace_graph_ignore_irqs())
> >> >>                 return 0;
> >> >>         [snip]
> >> >>
> >>
> >> By default, ftrace_graph_ignore_irqs() is false, then, if we don't put
> >> 0 to /debug/tracing/options/funcgraph-irqs, it will not return even if
> >> we have specified some entries through the tracing/set_graph_function
> >> interface, as a result, every function will be traced and it doesn't
> >> work as we expected, the expected result is only the specified
> >> functions are reserved in the tracing result.
> >>
> >
> > ???
> >
> > It's an or, if the first case is true:
> >
> >  !(trace->depth || ftrace_graph_addr(trace->func))
> >
> > then we return and do not trace. Regardless of what
> > ftrace_graph_ignore_irqs() is set to.
> 
> Sorry, I was falling into a stupid trap, OR from left to right ;-)

I found the reason for the traced interrupts. It looks like its been
there for a while. Here's the patch I'll be sending to mainline:

-- Steve

commit 2271425ed6ce77b271749544cd6117ceccb6369c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Feb 11 20:36:02 2011 -0500

    ftrace/graph: Trace function entry before updating index
    
    Currently the index to the ret_stack is updated and the real return address
    is saved in the ret_stack. Then we call the trace function. The trace
    function could decide that it doesn't want to trace this function
    (ex. set_graph_function does not match) and it will return 0 which means
    not to trace this call.
    
    The normal function graph tracer has this code:
    
    	if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
    	      ftrace_graph_ignore_irqs())
    		return 0;
    
    What this states is, if the trace depth (which is curr_ret_stack)
    is zero (top of nested functions) then test if we want to trace this
    function. If this function is not to be traced, then return  0 and
    the rest of the function graph tracer logic will not trace this function.
    
    The problem arises when an interrupt comes in after we updated the
    curr_ret_stack. The next function that gets called will have a trace->depth
    of 1. Which fools this trace code into thinking that we are in a nested
    function, and that we should trace. This causes interrupts to be traced
    when they should not be.
    
    The solution is to trace the function first and then update the ret_stack.
    
    Reported-by: zhiping zhong <xzhong86@163.com>
    Reported-by: wu zhangjin <wuzhangjin@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 382eb29..a93742a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -437,18 +437,19 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		return;
 	}
 
-	if (ftrace_push_return_trace(old, self_addr, &trace.depth,
-		    frame_pointer) == -EBUSY) {
-		*parent = old;
-		return;
-	}
-
 	trace.func = self_addr;
+	trace.depth = current->curr_ret_stack + 1;
 
 	/* Only trace if the calling function expects to */
 	if (!ftrace_graph_entry(&trace)) {
-		current->curr_ret_stack--;
 		*parent = old;
+		return;
+	}
+
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth,
+		    frame_pointer) == -EBUSY) {
+		*parent = old;
+		return;
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */


