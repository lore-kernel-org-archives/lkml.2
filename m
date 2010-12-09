Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0LIXkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:40:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0LIXkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:40:02 -0500
Date: Thu, 9 Dec 2010 23:39:34 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124551.110956235@linutronix.de>
References: <20101207124551.110956235@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Split out user event processing
Message-ID: <tip-ba74f0640d963ccc914ac533cb0ba133ee07bcf2@git.kernel.org>
Git-Commit-ID: ba74f0640d963ccc914ac533cb0ba133ee07bcf2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba74f0640d963ccc914ac533cb0ba133ee07bcf2
Gitweb:     http://git.kernel.org/tip/ba74f0640d963ccc914ac533cb0ba133ee07bcf2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:49:01 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 12:15:43 -0200

perf session: Split out user event processing

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
