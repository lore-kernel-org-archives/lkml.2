Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0LIXi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:38:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:56479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab0LIXiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:38:54 -0500
Date: Thu, 9 Dec 2010 23:38:31 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124550.818568607@linutronix.de>
References: <20101207124550.818568607@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Add file_offset to event delivery function
Message-ID: <tip-f74725dcf2f6931c26bc65e77e34e693eeb8441c@git.kernel.org>
Git-Commit-ID: f74725dcf2f6931c26bc65e77e34e693eeb8441c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:38:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f74725dcf2f6931c26bc65e77e34e693eeb8441c
Gitweb:     http://git.kernel.org/tip/f74725dcf2f6931c26bc65e77e34e693eeb8441c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:53 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 12:09:51 -0200

perf session: Add file_offset to event delivery function

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
