Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab0LIXjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:39:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:56500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab0LIXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:39:17 -0500
Date: Thu, 9 Dec 2010 23:38:53 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124550.918655066@linutronix.de>
References: <20101207124550.918655066@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Move dump code to event delivery path
Message-ID: <tip-532e7269c01098f0be6e08113c6947ec6ed11bfa@git.kernel.org>
Git-Commit-ID: 532e7269c01098f0be6e08113c6947ec6ed11bfa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:38:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  532e7269c01098f0be6e08113c6947ec6ed11bfa
Gitweb:     http://git.kernel.org/tip/532e7269c01098f0be6e08113c6947ec6ed11bfa
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:55 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 12:10:53 -0200

perf session: Move dump code to event delivery path

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
