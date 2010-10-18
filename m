Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab0JRUcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:32:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56516 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab0JRUcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:32:50 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=n5D0eWyUjq0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=nPxfmSqQg6N3S8QI8OIA:9 a=ty7Rs9UbB8_AwUZlmOyfn1C7Pr4A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101018203249.180752588@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 18 Oct 2010 16:29:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/7] tracing: Remove parent recording in latency tracer graph options
References: <20101018202939.828061748@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Remove-parent-recording-in-latency-tracer-gr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Even though the parent is recorded with the normal function tracing
of the latency tracers (irqsoff and wakeup), the function graph
recording is bogus.

This is due to the function graph messing with the return stack.
The latency tracers pass in as the parent CALLER_ADDR0, which
works fine for plain function tracing. But this causes bogus output
with the graph tracer:

 3)    <idle>-0    |  d.s3.  0.000 us    |  return_to_handler();
 3)    <idle>-0    |  d.s3.  0.000 us    |  _raw_spin_unlock_irqrestore();
 3)    <idle>-0    |  d.s3.  0.000 us    |  return_to_handler();
 3)    <idle>-0    |  d.s3.  0.000 us    |  trace_hardirqs_on();

The "return_to_handle()" call is the trampoline of the
function graph tracer, and is meaningless in this context.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6f8fe28..76b0598 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -287,7 +287,6 @@ trace_graph_function(struct trace_array *tr,
 		unsigned long ip, unsigned long parent_ip,
 		unsigned long flags, int pc)
 {
-	__trace_graph_function(tr, parent_ip, flags, pc);
 	__trace_graph_function(tr, ip, flags, pc);
 }
 
-- 
1.7.1


