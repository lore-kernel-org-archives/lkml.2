Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0HRXrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:47:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0HRXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=t/9gyFnUIFWtSpjqegz4lRDjItYBKxCStZ93em9bnv6Z7+Ke5KGkXvYCLkq59+Ruwn
         /FCjQ6V7Nzsg52u3yzZ7/auxzuZSTWv8gmin7nqn6Du596TeQKZEYgMSnjTdeMXjZirA
         Y4wneX9cKbdtA17I6qTlF7f13kYYnfCUJyhZ8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/7] perf: Humanize the number of contexts
Date: Thu, 19 Aug 2010 01:46:15 +0200
Message-Id: <1282175176-6363-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoding the number of contexts for the recursions
barriers, define a cpp constant to make the code more
self-explanatory.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h      |   14 ++++++++------
 kernel/perf_event.c             |    4 ++--
 kernel/trace/trace_event_perf.c |    8 ++++----
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d7e8ea6..ae6fa60 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -808,6 +808,12 @@ struct perf_event_context {
 	struct rcu_head			rcu_head;
 };
 
+/*
+ * Number of contexts where an event can trigger:
+ * 	task, softirq, hardirq, nmi.
+ */
+#define PERF_NR_CONTEXTS	4
+
 /**
  * struct perf_event_cpu_context - per cpu event context structure
  */
@@ -821,12 +827,8 @@ struct perf_cpu_context {
 	struct mutex			hlist_mutex;
 	int				hlist_refcount;
 
-	/*
-	 * Recursion avoidance:
-	 *
-	 * task, softirq, irq, nmi context
-	 */
-	int				recursion[4];
+	/* Recursion avoidance in each contexts */
+	int				recursion[PERF_NR_CONTEXTS];
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 75ab8a2..f416aef 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1772,7 +1772,7 @@ struct callchain_cpus_entries {
 	struct perf_callchain_entry	*cpu_entries[0];
 };
 
-static DEFINE_PER_CPU(int, callchain_recursion[4]);
+static DEFINE_PER_CPU(int, callchain_recursion[PERF_NR_CONTEXTS]);
 static atomic_t nr_callchain_events;
 static DEFINE_MUTEX(callchain_mutex);
 struct callchain_cpus_entries *callchain_cpus_entries;
@@ -1828,7 +1828,7 @@ static int alloc_callchain_buffers(void)
 	if (!entries)
 		return -ENOMEM;
 
-	size = sizeof(struct perf_callchain_entry) * 4;
+	size = sizeof(struct perf_callchain_entry) * PERF_NR_CONTEXTS;
 
 	for_each_possible_cpu(cpu) {
 		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL,
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 000e6e8..db2eae2 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -9,7 +9,7 @@
 #include <linux/kprobes.h>
 #include "trace.h"
 
-static char *perf_trace_buf[4];
+static char *perf_trace_buf[PERF_NR_CONTEXTS];
 
 /*
  * Force it to be aligned to unsigned long to avoid misaligned accesses
@@ -45,7 +45,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 		char *buf;
 		int i;
 
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
 			buf = (char *)alloc_percpu(perf_trace_t);
 			if (!buf)
 				goto fail;
@@ -65,7 +65,7 @@ fail:
 	if (!total_ref_count) {
 		int i;
 
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
 			free_percpu(perf_trace_buf[i]);
 			perf_trace_buf[i] = NULL;
 		}
@@ -140,7 +140,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 	tp_event->perf_events = NULL;
 
 	if (!--total_ref_count) {
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
 			free_percpu(perf_trace_buf[i]);
 			perf_trace_buf[i] = NULL;
 		}
-- 
1.6.2.3

