Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0HRXql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:46:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HRXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Y4L7uMvYcziMs+rB+G1mcCjCBue1sEOWmVIdl/UfB7bNSaUCffHS3XkrW31aG9P1uM
         iUJSfc/+LnAS7QKaI5Vf0xK9Zd+ftB3gzOmQYkDBn6snT9YxHjnZ4PDmwJF5jNHwX4xb
         0Jkp+Qkj0AZAKFjrdEKaBMZpxbjlv9uORTSGg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7] perf, tracing: add missing __percpu markups
Date: Thu, 19 Aug 2010 01:46:16 +0200
Message-Id: <1282175176-6363-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

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
-- 
1.6.2.3

