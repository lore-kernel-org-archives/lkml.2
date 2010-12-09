Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0LIXkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:40:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:56536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab0LIXkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:40:03 -0500
Date: Thu, 9 Dec 2010 23:39:14 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124551.014649793@linutronix.de>
References: <20101207124551.014649793@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Split out sample preprocessing
Message-ID: <tip-3dfc2c0aee789843d18f6e4675658e6879465a56@git.kernel.org>
Git-Commit-ID: 3dfc2c0aee789843d18f6e4675658e6879465a56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:39:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dfc2c0aee789843d18f6e4675658e6879465a56
Gitweb:     http://git.kernel.org/tip/3dfc2c0aee789843d18f6e4675658e6879465a56
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:58 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 12:13:13 -0200

perf session: Split out sample preprocessing

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
