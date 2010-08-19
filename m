Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0HSLZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:25:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:43802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0HSLY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:24:59 -0400
Date: Thu, 19 Aug 2010 11:24:31 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1281498479-28551-1-git-send-email-namhyung@gmail.com>
References: <1281498479-28551-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, tracing: add missing __percpu markups
Message-ID: <tip-6016ee13db518ab1cd0cbf43fc2ad5712021e338@git.kernel.org>
Git-Commit-ID: 6016ee13db518ab1cd0cbf43fc2ad5712021e338
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 11:24:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6016ee13db518ab1cd0cbf43fc2ad5712021e338
Gitweb:     http://git.kernel.org/tip/6016ee13db518ab1cd0cbf43fc2ad5712021e338
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 11 Aug 2010 12:47:59 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 19 Aug 2010 01:33:05 +0200

perf, tracing: add missing __percpu markups

ftrace_event_call->perf_events, perf_trace_buf,
fgraph_data->cpu_data and some local variables are percpu pointers
missing __percpu markups. Add them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1281498479-28551-1-git-send-email-namhyung@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h         |    4 ++--
 kernel/trace/trace_event_perf.c      |   15 ++++++++-------
 kernel/trace/trace_functions_graph.c |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 02b8b24..5f8ad7b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -191,8 +191,8 @@ struct ftrace_event_call {
 	unsigned int		flags;
 
 #ifdef CONFIG_PERF_EVENTS
-	int			perf_refcount;
-	struct hlist_head	*perf_events;
+	int				perf_refcount;
+	struct hlist_head __percpu	*perf_events;
 #endif
 };
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index db2eae2..92f5477 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -9,7 +9,7 @@
 #include <linux/kprobes.h>
 #include "trace.h"
 
-static char *perf_trace_buf[PERF_NR_CONTEXTS];
+static char __percpu *perf_trace_buf[PERF_NR_CONTEXTS];
 
 /*
  * Force it to be aligned to unsigned long to avoid misaligned accesses
@@ -24,7 +24,7 @@ static int	total_ref_count;
 static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
-	struct hlist_head *list;
+	struct hlist_head __percpu *list;
 	int ret = -ENOMEM;
 	int cpu;
 
@@ -42,11 +42,11 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 	tp_event->perf_events = list;
 
 	if (!total_ref_count) {
-		char *buf;
+		char __percpu *buf;
 		int i;
 
 		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
-			buf = (char *)alloc_percpu(perf_trace_t);
+			buf = (char __percpu *)alloc_percpu(perf_trace_t);
 			if (!buf)
 				goto fail;
 
@@ -102,13 +102,14 @@ int perf_trace_init(struct perf_event *p_event)
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
index 6bff236..fcb5a54 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -23,7 +23,7 @@ struct fgraph_cpu_data {
 };
 
 struct fgraph_data {
-	struct fgraph_cpu_data		*cpu_data;
+	struct fgraph_cpu_data __percpu *cpu_data;
 
 	/* Place to preserve last processed entry. */
 	struct ftrace_graph_ent_entry	ent;
