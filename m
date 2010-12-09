Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0LISOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:14:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58443 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab0LISNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/10] perf session: Split out user event processing
Date: Thu,  9 Dec 2010 16:12:56 -0200
Message-Id: <1291918376-18261-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Simplify further.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124551.110956235@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   42 ++++++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a765b27..69760cd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -748,24 +748,10 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 	return 0;
 }
 
-static int perf_session__process_event(struct perf_session *session,
-				       event_t *event,
-				       struct perf_event_ops *ops,
-				       u64 file_offset)
+static int perf_session__process_user_event(struct perf_session *session, event_t *event,
+					    struct perf_event_ops *ops, u64 file_offset)
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
@@ -782,8 +768,28 @@ static int perf_session__process_event(struct perf_session *session,
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
+		return perf_session__process_user_event(session, event, ops, file_offset);
 
 	/*
 	 * For all kernel events we get the sample data
-- 
1.6.2.5

