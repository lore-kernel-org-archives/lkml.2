Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0LGMt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:28 -0500
Received: from www.tglx.de ([62.245.132.106]:46621 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0LGMt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:26 -0500
Message-Id: <20101207124551.014649793@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 7/9] perf: session: Split out sample preprocessing
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=perf-session-split-out-sample-preprocessing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code a bit

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -732,6 +732,22 @@ static int perf_session_deliver_event(st
 	}
 }
 
+static int preprocess_sample_record(struct perf_session *session,
+				    event_t *event, struct sample_data *sample)
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
@@ -750,24 +766,9 @@ static int perf_session__process_event(s
 
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
@@ -784,6 +785,15 @@ static int perf_session__process_event(s
 		break;
 	}
 
+	/*
+	 * For all kernel events we get the sample data
+	 */
+	event__parse_sample(event, session, &sample);
+
+	/* Preprocess sample records - precheck callchains */
+	if (preprocess_sample_record(session, event, &sample))
+		return 0;
+
 	if (ops->ordered_samples) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);


