Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab0HKDsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:48:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55546 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0HKDsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QBY/bszjDb+T+1+nord4WrCGbOAzdFsfmeyvBM2eCJKDZaJViKz7ETfAks5GeoZV3C
         WmThHwZ/HYZarthrzfbwc5ATs8yV7F8uRqnIM0RonNLUSMBVLxgKTUNdKARXNYkwYy2C
         knpw1LFjNd0WVwdW6y98USSCOsxl53ocFnTsI=
From: Namhyung Kim <namhyung@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf, tracing: add missing __percpu markups
Date: Wed, 11 Aug 2010 12:47:59 +0900
Message-Id: <1281498479-28551-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_event_call->perf_events, perf_trace_buf, fgraph_data->cpu_data and
some local variables are percpu pointers but were missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/ftrace_event.h         |    4 ++--
 kernel/trace/trace_event_perf.c      |   15 ++++++++-------
 kernel/trace/trace_functions_graph.c |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 3167f2d..c298700 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -184,8 +184,8 @@ struct ftrace_event_call {
 	unsigned int		flags;
 
 #ifdef CONFIG_PERF_EVENTS
-	int			perf_refcount;
-	struct hlist_head	*perf_events;
+	int				perf_refcount;
+	struct hlist_head __percpu	*perf_events;
 #endif
 };
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 8a2b73f..7bd800a 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -11,7 +11,7 @@
 
 EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
 
-static char *perf_trace_buf[4];
+static char __percpu *perf_trace_buf[4];
 
 /*
  * Force it to be aligned to unsigned long to avoid misaligned accesses
@@ -26,7 +26,7 @@ static int	total_ref_count;
 static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
-	struct hlist_head *list;
+	struct hlist_head __percpu *list;
 	int ret = -ENOMEM;
 	int cpu;
 
@@ -44,11 +44,11 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 	tp_event->perf_events = list;
 
 	if (!total_ref_count) {
-		char *buf;
+		char __percpu *buf;
 		int i;
 
 		for (i = 0; i < 4; i++) {
-			buf = (char *)alloc_percpu(perf_trace_t);
+			buf = (char __percpu *)alloc_percpu(perf_trace_t);
 			if (!buf)
 				goto fail;
 
@@ -112,13 +112,14 @@ int perf_trace_init(struct perf_event *p_event)
 int perf_trace_enable(struct perf_event *p_event)
 {
 	struct ftrace_event_call *tp_event = p_event->tp_event;
+	struct hlist_head __percpu *pcpu_list;
 	struct hlist_head *list;
 
-	list = tp_event->perf_events;
-	if (WARN_ON_ONCE(!list))
+	pcpu_list = tp_event->perf_events;
+	if (WARN_ON_ONCE(!pcpu_list))
 		return -EINVAL;
 
-	list = this_cpu_ptr(list);
+	list = this_cpu_ptr(pcpu_list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
 	return 0;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..e4d8dea 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -23,7 +23,7 @@ struct fgraph_cpu_data {
 };
 
 struct fgraph_data {
-	struct fgraph_cpu_data		*cpu_data;
+	struct fgraph_cpu_data __percpu *cpu_data;
 
 	/* Place to preserve last processed entry. */
 	struct ftrace_graph_ent_entry	ent;
-- 
1.7.0.4

