Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0LIXhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:37:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:56410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0LIXhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:37:37 -0500
Date: Thu, 9 Dec 2010 23:37:06 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124550.432593943@linutronix.de>
References: <20101207124550.432593943@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf event: Prevent unbound event__name array access
Message-ID: <tip-3835bc00c5b2d8e337a6e9d7b44f47e02760dba3@git.kernel.org>
Git-Commit-ID: 3835bc00c5b2d8e337a6e9d7b44f47e02760dba3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:37:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3835bc00c5b2d8e337a6e9d7b44f47e02760dba3
Gitweb:     http://git.kernel.org/tip/3835bc00c5b2d8e337a6e9d7b44f47e02760dba3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:42 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 11:15:07 -0200

perf event: Prevent unbound event__name array access

event__name[] is missing an entry for PERF_RECORD_FINISHED_ROUND, but we
happily access the array from the dump code.

Make event__name[] static and provide an accessor function, fix up all
callers and add the missing string.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.432593943@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   |   12 +++++++++++-
 tools/perf/util/event.h   |    2 +-
 tools/perf/util/hist.c    |    9 ++++++---
 tools/perf/util/session.c |    2 +-
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index e4cdc1e..183aedd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -7,7 +7,7 @@
 #include "strlist.h"
 #include "thread.h"
 
-const char *event__name[] = {
+static const char *event__name[] = {
 	[0]			 = "TOTAL",
 	[PERF_RECORD_MMAP]	 = "MMAP",
 	[PERF_RECORD_LOST]	 = "LOST",
@@ -22,8 +22,18 @@ const char *event__name[] = {
 	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
 	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
+	[PERF_RECORD_FINISHED_ROUND]	 = "FINISHED_ROUND",
 };
 
+const char *event__get_event_name(unsigned int id)
+{
+	if (id >= ARRAY_SIZE(event__name))
+		return "INVALID";
+	if (!event__name[id])
+		return "UNKNOWN";
+	return event__name[id];
+}
+
 static struct sample_data synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a95ab18..4716a8f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -171,6 +171,6 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 int event__parse_sample(const event_t *event, struct perf_session *session,
 			struct sample_data *sample);
 
-extern const char *event__name[];
+const char *event__get_event_name(unsigned int id);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2022e87..a3b8416 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1168,10 +1168,13 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 	size_t ret = 0;
 
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
-		if (!event__name[i])
+		const char *name = event__get_event_name(i);
+
+		if (!strcmp(name, "UNKNOWN"))
 			continue;
-		ret += fprintf(fp, "%10s events: %10d\n",
-			       event__name[i], self->stats.nr_events[i]);
+
+		ret += fprintf(fp, "%16s events: %10d\n", name,
+			       self->stats.nr_events[i]);
 	}
 
 	return ret;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3074d38..b3b145a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -718,7 +718,7 @@ static int perf_session__process_event(struct perf_session *session,
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    file_offset, event->header.size,
-			    event__name[event->header.type]);
+			    event__get_event_name(event->header.type));
 		hists__inc_nr_events(&session->hists, event->header.type);
 	}
 
