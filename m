Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0LISOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:14:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58436 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0LISNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf session: Consolidate the dump code
Date: Thu,  9 Dec 2010 16:12:51 -0200
Message-Id: <1291918376-18261-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The dump code used by perf report -D is scattered all over the place.
Move it to separate functions.

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.625434869@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h   |    1 +
 tools/perf/util/session.c |   64 +++++++++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 4716a8f..2b7e919 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -85,6 +85,7 @@ struct build_id_event {
 };
 
 enum perf_user_event_type { /* above any possible kernel type */
+	PERF_RECORD_USER_TYPE_START		= 64,
 	PERF_RECORD_HEADER_ATTR			= 64,
 	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e5d0ed9..12761d5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -665,6 +665,35 @@ static void perf_session__print_tstamp(struct perf_session *session,
 		printf("%Lu ", sample->time);
 }
 
+static void dump_event(struct perf_session *session, event_t *event,
+		       u64 file_offset, struct sample_data *sample)
+{
+	if (!dump_trace)
+		return;
+
+	dump_printf("\n%#Lx [%#x]: event: %d\n", file_offset,
+		    event->header.size, event->header.type);
+
+	trace_event(event);
+
+	if (sample)
+		perf_session__print_tstamp(session, event, sample);
+
+	dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
+		    file_offset, event->header.size,
+		    event__get_event_name(event->header.type));
+}
+
+static void dump_sample(struct perf_session *session, event_t *event,
+			struct sample_data *sample)
+{
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    sample->pid, sample->tid, sample->ip, sample->period);
+
+	if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
+		callchain__dump(sample);
+}
+
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
 				      struct sample_data *sample,
@@ -703,32 +732,24 @@ static int perf_session__process_event(struct perf_session *session,
 	struct sample_data sample;
 	int ret;
 
-	trace_event(event);
-
 	if (session->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
-	if (event->header.type >= PERF_RECORD_MMAP &&
-	    event->header.type <= PERF_RECORD_SAMPLE) {
-		event__parse_sample(event, session, &sample);
-		if (dump_trace)
-			perf_session__print_tstamp(session, event, &sample);
-	}
+	if (event->header.type >= PERF_RECORD_HEADER_MAX)
+		return -EINVAL;
 
-	if (event->header.type < PERF_RECORD_HEADER_MAX) {
-		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
-			    file_offset, event->header.size,
-			    event__get_event_name(event->header.type));
-		hists__inc_nr_events(&session->hists, event->header.type);
+	hists__inc_nr_events(&session->hists, event->header.type);
+
+	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
+		dump_event(session, event, file_offset, NULL);
+	else {
+		event__parse_sample(event, session, &sample);
+		dump_event(session, event, file_offset, &sample);
 	}
 
 	/* These events are processed right away */
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n",
-			    event->header.misc,
-			    sample.pid, sample.tid, sample.ip, sample.period);
-
 		if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 			if (!ip_callchain__valid(sample.callchain, event)) {
 				pr_debug("call-chain problem with event, "
@@ -738,9 +759,8 @@ static int perf_session__process_event(struct perf_session *session,
 					sample.period;
 				return 0;
 			}
-
-			callchain__dump(&sample);
 		}
+		dump_sample(session, event, &sample);
 		break;
 
 	case PERF_RECORD_HEADER_ATTR:
@@ -870,9 +890,6 @@ more:
 
 	head += size;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    head, event.header.size, event.header.type);
-
 	if (skip > 0)
 		head += skip;
 
@@ -961,9 +978,6 @@ more:
 
 	size = event->header.size;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    file_pos, event->header.size, event->header.type);
-
 	if (size == 0 ||
 	    perf_session__process_event(session, event, ops, file_pos) < 0) {
 		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
-- 
1.6.2.5

