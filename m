Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0JFDfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:35:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab0JFDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:35:47 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=BxtclkQDRLgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Kaqtp-DgxGVuowaq8qkA:9 a=n9tFQHEZoGPwGl5_5deXtUdMDx4A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101006033545.789152634@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 23:34:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/9] tracing: Add proper check for irq_depth routines
References: <20101006033445.465428951@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Add-proper-check-for-irq_depth-routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The check_irq_entry and check_irq_return could be called
from graph event context. In such case there's no graph
private data allocated. Adding checks to handle this case.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20100924154102.GB1818@jolsa.brq.redhat.com>

[ Fixed some grammar in the comments ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 02c708a..47a8b8b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -887,12 +887,20 @@ check_irq_entry(struct trace_iterator *iter, u32 flags,
 		unsigned long addr, int depth)
 {
 	int cpu = iter->cpu;
+	int *depth_irq;
 	struct fgraph_data *data = iter->private;
-	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
 
-	if (flags & TRACE_GRAPH_PRINT_IRQS)
+	/*
+	 * If we are either displaying irqs, or we got called as
+	 * a graph event and private data does not exist,
+	 * then we bypass the irq check.
+	 */
+	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
+	    (!data))
 		return 0;
 
+	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
 	/*
 	 * We are inside the irq code
 	 */
@@ -925,12 +933,20 @@ static int
 check_irq_return(struct trace_iterator *iter, u32 flags, int depth)
 {
 	int cpu = iter->cpu;
+	int *depth_irq;
 	struct fgraph_data *data = iter->private;
-	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
 
-	if (flags & TRACE_GRAPH_PRINT_IRQS)
+	/*
+	 * If we are either displaying irqs, or we got called as
+	 * a graph event and private data does not exist,
+	 * then we bypass the irq check.
+	 */
+	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
+	    (!data))
 		return 0;
 
+	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
 	/*
 	 * We are not inside the irq code.
 	 */
-- 
1.7.1


