Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0LGMu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:50:56 -0500
Received: from www.tglx.de ([62.245.132.106]:46610 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab0LGMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:18 -0500
Message-Id: <20101207124550.918655066@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 6/9] perf: session: Move dump code to event delivery path
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=perf-session-move-dump-code-to-delivery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for ordered perf report -D

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -702,10 +702,13 @@ static int perf_session_deliver_event(st
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
@@ -747,10 +750,8 @@ static int perf_session__process_event(s
 
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		dump_event(session, event, file_offset, NULL);
-	else {
+	else
 		event__parse_sample(event, session, &sample);
-		dump_event(session, event, file_offset, &sample);
-	}
 
 	/* These events are processed right away */
 	switch (event->header.type) {
@@ -765,7 +766,6 @@ static int perf_session__process_event(s
 				return 0;
 			}
 		}
-		dump_sample(session, event, &sample);
 		break;
 
 	case PERF_RECORD_HEADER_ATTR:


