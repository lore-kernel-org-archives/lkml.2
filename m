Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0IWMBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0IWMBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:01:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 1/3] tracing: proper check for irq_depth routines
Date: Thu, 23 Sep 2010 14:00:51 +0200
Message-Id: <1285243253-7372-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1285243253-7372-1-git-send-email-jolsa@redhat.com>
References: <1285243253-7372-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check_irq_entry and check_irq_return could be called
from graph event context. In such case there's no graph
private data allocated. Adding checks to handle this case.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 02c708a..1390159 100644
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
+	 * We either display irqs, or we got called as
+	 * graph event, and out private data do no exist.
+	 * In both cases we bypass the irq check.
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
+	 * We either display irqs, or we got called as
+	 * graph event, and out private data do no exist.
+	 * In both cases we bypass the irq check.
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

