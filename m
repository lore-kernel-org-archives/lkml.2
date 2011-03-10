Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1CJP7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:59:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1CJP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:14 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=hARv3LmkAOYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=Byx-y9mGAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=khSOu_7g2CyAtfDjnsgA:9 a=wUnhNzuu2SRa2-9D1jCx2dz_d1kA:4 a=jEp0ucaQiEUA:10 a=lSQsbIguPOwA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155911.781601308@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        zhiping zhong <xzhong86@163.com>, wu zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 11/15] ftrace/graph: Trace function entry before updating index
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-graph-Trace-function-entry-before-updating-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

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
---
 arch/x86/kernel/ftrace.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

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
-- 
1.7.2.3


