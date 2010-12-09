Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0LIXkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:40:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:56550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461Ab0LIXkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:40:20 -0500
Date: Thu, 9 Dec 2010 23:39:57 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, imunsie@au1.ibm.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Remove unneeded dump_printf calls
Message-ID: <tip-ddbc24b72c2c3f3f0182bbc2cb70b31c52a6f45b@git.kernel.org>
Git-Commit-ID: ddbc24b72c2c3f3f0182bbc2cb70b31c52a6f45b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddbc24b72c2c3f3f0182bbc2cb70b31c52a6f45b
Gitweb:     http://git.kernel.org/tip/ddbc24b72c2c3f3f0182bbc2cb70b31c52a6f45b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Dec 2010 12:20:20 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 12:20:20 -0200

perf session: Remove unneeded dump_printf calls

Since we check at the beginning of the callers, no need to ask if
dump_trace is set multiple times.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 69760cd..b59abf5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -639,13 +639,10 @@ static int perf_session_queue_event(struct perf_session *s, event_t *event,
 	return 0;
 }
 
-static void callchain__dump(struct sample_data *sample)
+static void callchain__printf(struct sample_data *sample)
 {
 	unsigned int i;
 
-	if (!dump_trace)
-		return;
-
 	printf("... chain: nr:%Lu\n", sample->callchain->nr);
 
 	for (i = 0; i < sample->callchain->nr; i++)
@@ -675,27 +672,29 @@ static void dump_event(struct perf_session *session, event_t *event,
 	if (!dump_trace)
 		return;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n", file_offset,
-		    event->header.size, event->header.type);
+	printf("\n%#Lx [%#x]: event: %d\n", file_offset, event->header.size,
+	       event->header.type);
 
 	trace_event(event);
 
 	if (sample)
 		perf_session__print_tstamp(session, event, sample);
 
-	dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
-		    file_offset, event->header.size,
-		    event__get_event_name(event->header.type));
+	printf("%#Lx [%#x]: PERF_RECORD_%s", file_offset, event->header.size,
+	       event__get_event_name(event->header.type));
 }
 
 static void dump_sample(struct perf_session *session, event_t *event,
 			struct sample_data *sample)
 {
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-		    sample->pid, sample->tid, sample->ip, sample->period);
+	if (!dump_trace)
+		return;
+
+	printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+	       sample->pid, sample->tid, sample->ip, sample->period);
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
-		callchain__dump(sample);
+		callchain__printf(sample);
 }
 
 static int perf_session_deliver_event(struct perf_session *session,
