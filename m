Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2JHRU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:20:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2JHRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:19 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/12] perf session: export a few functions for event processing
Date: Mon,  8 Oct 2012 11:17:28 -0600
Message-Id: <1349716656-48165-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows kvm live mode to reuse the event processing and ordered samples
processing used by the perf-report path.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/session.c |   14 +++++++-------
 tools/perf/util/session.h |    9 +++++++++
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 23d2ea3..576ab8b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -456,7 +456,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
-static void perf_tool__fill_defaults(struct perf_tool *tool)
+void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
 		tool->sample = process_event_sample_stub;
@@ -702,8 +702,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int flush_sample_queue(struct perf_session *s,
-			       struct perf_tool *tool)
+int flush_sample_queue(struct perf_session *s,
+		       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
@@ -1150,10 +1150,10 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-static int perf_session__process_event(struct perf_session *session,
-				       union perf_event *event,
-				       struct perf_tool *tool,
-				       u64 file_offset)
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset)
 {
 	struct perf_sample sample;
 	int ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index aab414f..3fb5049 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -63,6 +63,15 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool);
 
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset);
+
+int flush_sample_queue(struct perf_session *s, struct perf_tool *tool);
+
+void perf_tool__fill_defaults(struct perf_tool *tool);
+
 int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
 				    struct ip_callchain *chain,
-- 
1.7.10.1

