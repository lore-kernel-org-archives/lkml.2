Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2IEXJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab2IEXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/17] perf session: flush_sample_queue needs to handle errors from handlers
Date: Wed,  5 Sep 2012 20:08:42 -0300
Message-Id: <1346886537-11621-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows errors to propogate through event processing code and back to
commands.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f7bb7ae..9453758 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -692,7 +692,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static void flush_sample_queue(struct perf_session *s,
+static int flush_sample_queue(struct perf_session *s,
 			       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
@@ -705,7 +705,7 @@ static void flush_sample_queue(struct perf_session *s,
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
-		return;
+		return 0;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (iter->timestamp > limit)
@@ -715,9 +715,12 @@ static void flush_sample_queue(struct perf_session *s,
 						s->header.needs_swap);
 		if (ret)
 			pr_err("Can't parse sample, err = %d\n", ret);
-		else
-			perf_session_deliver_event(s, iter->event, &sample, tool,
-						   iter->file_offset);
+		else {
+			ret = perf_session_deliver_event(s, iter->event, &sample, tool,
+							 iter->file_offset);
+			if (ret)
+				return ret;
+		}
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -737,6 +740,8 @@ static void flush_sample_queue(struct perf_session *s,
 	}
 
 	os->nr_samples = 0;
+
+	return 0;
 }
 
 /*
@@ -782,10 +787,11 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __used,
 				  struct perf_session *session)
 {
-	flush_sample_queue(session, tool);
-	session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+	int ret = flush_sample_queue(session, tool);
+	if (!ret)
+		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
 
-	return 0;
+	return ret;
 }
 
 /* The queue is ordered by time */
@@ -1443,7 +1449,7 @@ more:
 	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
-	flush_sample_queue(session, tool);
+	err = flush_sample_queue(session, tool);
 out_err:
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
-- 
1.7.1

