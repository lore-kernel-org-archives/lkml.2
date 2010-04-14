Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab0DNXkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:51100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0DNXkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:40:12 -0400
Date: Wed, 14 Apr 2010 23:39:41 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1271281338-23491-1-git-send-regression-fweisbec@gmail.com>
References: <1271281338-23491-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix hlist related build error
Message-ID: <tip-95476b64ab11d528de2557366ec584977c215b9e@git.kernel.org>
Git-Commit-ID: 95476b64ab11d528de2557366ec584977c215b9e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 23:39:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95476b64ab11d528de2557366ec584977c215b9e
Gitweb:     http://git.kernel.org/tip/95476b64ab11d528de2557366ec584977c215b9e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 14 Apr 2010 23:42:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Apr 2010 01:34:46 +0200

perf: Fix hlist related build error

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
LKML-Reference: <1271281338-23491-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
