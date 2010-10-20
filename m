Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0JTE7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:59:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:34092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0JTE7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:59:09 -0400
Date: Wed, 20 Oct 2010 04:58:50 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20100924154102.GB1818@jolsa.brq.redhat.com>
References: <20100924154102.GB1818@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add proper check for irq_depth routines
Message-ID: <tip-a9d61173dc1cb63e660ae89e874e51ba4fd2f991@git.kernel.org>
Git-Commit-ID: a9d61173dc1cb63e660ae89e874e51ba4fd2f991
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 04:58:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9d61173dc1cb63e660ae89e874e51ba4fd2f991
Gitweb:     http://git.kernel.org/tip/a9d61173dc1cb63e660ae89e874e51ba4fd2f991
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 Sep 2010 17:41:02 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 18 Oct 2010 10:53:25 -0400

tracing: Add proper check for irq_depth routines

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
index ef49e93..4c58ccc 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -888,12 +888,20 @@ check_irq_entry(struct trace_iterator *iter, u32 flags,
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
@@ -926,12 +934,20 @@ static int
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
