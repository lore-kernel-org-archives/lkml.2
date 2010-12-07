Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0LGMt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:26 -0500
Received: from www.tglx.de ([62.245.132.106]:46620 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0LGMtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:24 -0500
Message-Id: <20101207124551.110956235@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:49:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 8/9] perf: session: Split out user event processing
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=perf-split-out-user-event-processing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify further.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -748,24 +748,10 @@ static int preprocess_sample_record(stru
 	return 0;
 }
 
-static int perf_session__process_event(struct perf_session *session,
-				       event_t *event,
-				       struct perf_event_ops *ops,
-				       u64 file_offset)
+static int process_user_event(struct perf_session *session, event_t *event,
+			      struct perf_event_ops *ops, u64 file_offset)
 {
-	struct sample_data sample;
-	int ret;
-
-	if (session->header.needs_swap && event__swap_ops[event->header.type])
-		event__swap_ops[event->header.type](event);
-
-	if (event->header.type >= PERF_RECORD_HEADER_MAX)
-		return -EINVAL;
-
-	hists__inc_nr_events(&session->hists, event->header.type);
-
-	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
-		dump_event(session, event, file_offset, NULL);
+	dump_event(session, event, file_offset, NULL);
 
 	/* These events are processed right away */
 	switch (event->header.type) {
@@ -782,8 +768,28 @@ static int perf_session__process_event(s
 	case PERF_RECORD_FINISHED_ROUND:
 		return ops->finished_round(event, session, ops);
 	default:
-		break;
+		return -EINVAL;
 	}
+}
+
+static int perf_session__process_event(struct perf_session *session,
+				       event_t *event,
+				       struct perf_event_ops *ops,
+				       u64 file_offset)
+{
+	struct sample_data sample;
+	int ret;
+
+	if (session->header.needs_swap && event__swap_ops[event->header.type])
+		event__swap_ops[event->header.type](event);
+
+	if (event->header.type >= PERF_RECORD_HEADER_MAX)
+		return -EINVAL;
+
+	hists__inc_nr_events(&session->hists, event->header.type);
+
+	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
+		return process_user_event(session, event, ops, file_offset);
 
 	/*
 	 * For all kernel events we get the sample data


