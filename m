Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0LGMth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:37 -0500
Received: from www.tglx.de ([62.245.132.106]:46622 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0LGMt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:27 -0500
Message-Id: <20101207124551.209741779@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:49:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 9/9] pref: session: Break event ordering when timestamps are
	missing
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=pref-session-break-ordering-on-request.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the session client to specify that event ordering should be
stopped when not all events have time stamps.

Suggested-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |   13 ++++++++++++-
 tools/perf/util/session.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -751,12 +751,23 @@ static int preprocess_sample_record(stru
 static int process_user_event(struct perf_session *session, event_t *event,
 			      struct perf_event_ops *ops, u64 file_offset)
 {
+	int ret;
+
 	dump_event(session, event, file_offset, NULL);
 
 	/* These events are processed right away */
 	switch (event->header.type) {
 	case PERF_RECORD_HEADER_ATTR:
-		return ops->attr(event, session);
+		/* This updates session->sample_id_all */
+		ret = ops->attr(event, session);
+		/* Break ordering if sample_id_all is false */
+		if (ops->ordering_requires_timestamps &&
+		    ops->ordered_samples && !session->sample_id_all) {
+			session->ordered_samples.next_flush = ULLONG_MAX;
+			flush_sample_queue(session, ops);
+			ops->ordered_samples = false;
+		}
+		return ret;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		return ops->event_type(event, session);
 	case PERF_RECORD_HEADER_TRACING_DATA:
Index: linux-2.6-tip/tools/perf/util/session.h
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.h
+++ linux-2.6-tip/tools/perf/util/session.h
@@ -78,6 +78,7 @@ struct perf_event_ops {
 			build_id;
 	event_op2	finished_round;
 	bool		ordered_samples;
+	bool		ordering_requires_timestamps;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe);


