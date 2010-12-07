Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0LGMtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:19 -0500
Received: from www.tglx.de ([62.245.132.106]:46609 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab0LGMtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:16 -0500
Message-Id: <20101207124550.625434869@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 3/9] perf: session: Consolidate the dump code
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline; filename=perf-session-split-out-dump-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dump code used by perf report -D is scattered all over the
place. Move it to separate functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/event.h   |    1 
 tools/perf/util/session.c |   64 ++++++++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 25 deletions(-)

Index: linux-2.6-tip/tools/perf/util/event.h
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/event.h
+++ linux-2.6-tip/tools/perf/util/event.h
@@ -85,6 +85,7 @@ struct build_id_event {
 };
 
 enum perf_user_event_type { /* above any possible kernel type */
+	PERF_RECORD_USER_TYPE_START		= 64,
 	PERF_RECORD_HEADER_ATTR			= 64,
 	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -665,6 +665,35 @@ static void perf_session__print_tstamp(s
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
@@ -703,32 +732,24 @@ static int perf_session__process_event(s
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
+
+	hists__inc_nr_events(&session->hists, event->header.type);
 
-	if (event->header.type < PERF_RECORD_HEADER_MAX) {
-		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
-			    file_offset, event->header.size,
-			    event__get_event_name(event->header.type));
-		hists__inc_nr_events(&session->hists, event->header.type);
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
@@ -738,9 +759,8 @@ static int perf_session__process_event(s
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


