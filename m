Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0DNVmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:42:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54741 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab0DNVmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pY11EluGXEnB9KS4YffV8n+LKU2KlF3dQaE2bo4ScujxsiwsJ8VHiXAhxIbu2Y+fg7
         jMY3tR3SknlL3hudyR/KnfCrES+adTqKpzXXRNMwkwWnLFKEO6WjqgACE7DBacDZTLQv
         sB5/7rlGc2GYx+C280B4DdQTccLMUgef09dzc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix hlist related build error
Date: Wed, 14 Apr 2010 23:42:18 +0200
Message-Id: <1271281338-23491-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hlist helpers need to be available for all software events, not
only trace events.

Pull them out outside the ifdef CONFIG_EVENT_TRACING section.

Fixes:
	kernel/perf_event.c:4573: error: implicit declaration of function 'swevent_hlist_put'
	kernel/perf_event.c:4614: error: implicit declaration of function 'swevent_hlist_get'
	kernel/perf_event.c:5534: error: implicit declaration of function 'swevent_hlist_release

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |   60 +++++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 095101d..07b7a43 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4313,36 +4313,6 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_event_read,
 };
 
-#ifdef CONFIG_EVENT_TRACING
-
-void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-		   int entry_size, struct pt_regs *regs)
-{
-	struct perf_sample_data data;
-	struct perf_raw_record raw = {
-		.size = entry_size,
-		.data = record,
-	};
-
-	perf_sample_data_init(&data, addr);
-	data.raw = &raw;
-
-	/* Trace events already protected against recursion */
-	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-			 &data, regs);
-}
-EXPORT_SYMBOL_GPL(perf_tp_event);
-
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data)
-{
-	void *record = data->raw->data;
-
-	if (likely(!event->filter) || filter_match_preds(event->filter, record))
-		return 1;
-	return 0;
-}
-
 static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
 {
 	struct swevent_hlist *hlist;
@@ -4442,6 +4412,36 @@ static int swevent_hlist_get(struct perf_event *event)
 	return err;
 }
 
+#ifdef CONFIG_EVENT_TRACING
+
+void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
+		   int entry_size, struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct perf_raw_record raw = {
+		.size = entry_size,
+		.data = record,
+	};
+
+	perf_sample_data_init(&data, addr);
+	data.raw = &raw;
+
+	/* Trace events already protected against recursion */
+	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
+			 &data, regs);
+}
+EXPORT_SYMBOL_GPL(perf_tp_event);
+
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	void *record = data->raw->data;
+
+	if (likely(!event->filter) || filter_match_preds(event->filter, record))
+		return 1;
+	return 0;
+}
+
 static void tp_perf_event_destroy(struct perf_event *event)
 {
 	perf_trace_disable(event->attr.config);
-- 
1.6.2.3

