Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0LISNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:13:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58461 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0LISNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf session: Split out sample preprocessing
Date: Thu,  9 Dec 2010 16:12:55 -0200
Message-Id: <1291918376-18261-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Simplify the code a bit.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124551.014649793@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   40 +++++++++++++++++++++++++---------------
 1 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7c5cc12..a765b27 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -732,6 +732,22 @@ static int perf_session_deliver_event(struct perf_session *session,
 	}
 }
 
+static int perf_session__preprocess_sample(struct perf_session *session,
+					   event_t *event, struct sample_data *sample)
+{
+	if (event->header.type != PERF_RECORD_SAMPLE ||
+	    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
+		return 0;
+
+	if (!ip_callchain__valid(sample->callchain, event)) {
+		pr_debug("call-chain problem with event, skipping it.\n");
+		++session->hists.stats.nr_invalid_chains;
+		session->hists.stats.total_invalid_chains += sample->period;
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int perf_session__process_event(struct perf_session *session,
 				       event_t *event,
 				       struct perf_event_ops *ops,
@@ -750,24 +766,9 @@ static int perf_session__process_event(struct perf_session *session,
 
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		dump_event(session, event, file_offset, NULL);
-	else
-		event__parse_sample(event, session, &sample);
 
 	/* These events are processed right away */
 	switch (event->header.type) {
-	case PERF_RECORD_SAMPLE:
-		if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
-			if (!ip_callchain__valid(sample.callchain, event)) {
-				pr_debug("call-chain problem with event, "
-					 "skipping it.\n");
-				++session->hists.stats.nr_invalid_chains;
-				session->hists.stats.total_invalid_chains +=
-					sample.period;
-				return 0;
-			}
-		}
-		break;
-
 	case PERF_RECORD_HEADER_ATTR:
 		return ops->attr(event, session);
 	case PERF_RECORD_HEADER_EVENT_TYPE:
@@ -784,6 +785,15 @@ static int perf_session__process_event(struct perf_session *session,
 		break;
 	}
 
+	/*
+	 * For all kernel events we get the sample data
+	 */
+	event__parse_sample(event, session, &sample);
+
+	/* Preprocess sample records - precheck callchains */
+	if (perf_session__preprocess_sample(session, event, &sample))
+		return 0;
+
 	if (ops->ordered_samples) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);
-- 
1.6.2.5

