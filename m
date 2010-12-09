Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0LISN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:13:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:51429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0LISN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf session: Add file_offset to event delivery function
Date: Thu,  9 Dec 2010 16:12:53 -0200
Message-Id: <1291918376-18261-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Preparatory patch for ordered output of perf report -D

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.818568607@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a433954..d43e56c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -465,7 +465,8 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
 				      struct sample_data *sample,
-				      struct perf_event_ops *ops);
+				      struct perf_event_ops *ops,
+				      u64 file_offset);
 
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
@@ -485,7 +486,8 @@ static void flush_sample_queue(struct perf_session *s,
 			break;
 
 		event__parse_sample(iter->event, s, &sample);
-		perf_session_deliver_event(s, iter->event, &sample, ops);
+		perf_session_deliver_event(s, iter->event, &sample, ops,
+					   iter->file_offset);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -699,7 +701,8 @@ static void dump_sample(struct perf_session *session, event_t *event,
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
 				      struct sample_data *sample,
-				      struct perf_event_ops *ops)
+				      struct perf_event_ops *ops,
+				      u64 file_offset __used)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
@@ -788,7 +791,8 @@ static int perf_session__process_event(struct perf_session *session,
 			return ret;
 	}
 
-	return perf_session_deliver_event(session, event, &sample, ops);
+	return perf_session_deliver_event(session, event, &sample, ops,
+					  file_offset);
 }
 
 void perf_event_header__bswap(struct perf_event_header *self)
-- 
1.6.2.5

