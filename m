Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0LISNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:13:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:51434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0LISN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/10] perf session: Move dump code to event delivery path
Date: Thu,  9 Dec 2010 16:12:54 -0200
Message-Id: <1291918376-18261-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Preparatory patch for ordered perf report -D

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.918655066@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d43e56c..7c5cc12 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -702,10 +702,13 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
 				      struct sample_data *sample,
 				      struct perf_event_ops *ops,
-				      u64 file_offset __used)
+				      u64 file_offset)
 {
+	dump_event(session, event, file_offset, sample);
+
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
+		dump_sample(session, event, sample);
 		return ops->sample(event, sample, session);
 	case PERF_RECORD_MMAP:
 		return ops->mmap(event, sample, session);
@@ -747,10 +750,8 @@ static int perf_session__process_event(struct perf_session *session,
 
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		dump_event(session, event, file_offset, NULL);
-	else {
+	else
 		event__parse_sample(event, session, &sample);
-		dump_event(session, event, file_offset, &sample);
-	}
 
 	/* These events are processed right away */
 	switch (event->header.type) {
@@ -765,7 +766,6 @@ static int perf_session__process_event(struct perf_session *session,
 				return 0;
 			}
 		}
-		dump_sample(session, event, &sample);
 		break;
 
 	case PERF_RECORD_HEADER_ATTR:
-- 
1.6.2.5

