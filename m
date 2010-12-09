Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0LIXiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:38:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:56443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab0LIXiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:38:12 -0500
Date: Thu, 9 Dec 2010 23:37:47 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124550.625434869@linutronix.de>
References: <20101207124550.625434869@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Consolidate the dump code
Message-ID: <tip-9aefcab0de472ee2b3ab195a6827ddd4b170e3a7@git.kernel.org>
Git-Commit-ID: 9aefcab0de472ee2b3ab195a6827ddd4b170e3a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:37:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9aefcab0de472ee2b3ab195a6827ddd4b170e3a7
Gitweb:     http://git.kernel.org/tip/9aefcab0de472ee2b3ab195a6827ddd4b170e3a7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:47 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 11:18:06 -0200

perf session: Consolidate the dump code

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
