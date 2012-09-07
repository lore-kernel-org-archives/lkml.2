Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2IGGNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:13:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab2IGGNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:13:14 -0400
Date: Thu, 6 Sep 2012 23:12:57 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-831394bdd9dd3ac1661336505c7cbdfd786d8cd4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1346897446-16569-2-git-send-email-namhyung@kernel.org>
References: <1346897446-16569-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header:
  Prepare tracepoint events regardless of name
Git-Commit-ID: 831394bdd9dd3ac1661336505c7cbdfd786d8cd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:13:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  831394bdd9dd3ac1661336505c7cbdfd786d8cd4
Gitweb:     http://git.kernel.org/tip/831394bdd9dd3ac1661336505c7cbdfd786d8cd4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 6 Sep 2012 11:10:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Sep 2012 10:51:02 -0300

perf header: Prepare tracepoint events regardless of name

Current perf_evlist__set_tracepoint_names is a misnomer because it finds
and sets correspoding event_format in addition to the name.  So skipping
it when a event has set name already caused a trouble.

Rename it and set name only a event doesn't have one.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346897446-16569-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8b0b873..d07bc13 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2295,33 +2295,39 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
-static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
-					   struct pevent *pevent)
+static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
+						struct pevent *pevent)
 {
-	struct event_format *event = pevent_find_event(pevent,
-						       evsel->attr.config);
+	struct event_format *event;
 	char bf[128];
 
+	/* already prepared */
+	if (evsel->tp_format)
+		return 0;
+
+	event = pevent_find_event(pevent, evsel->attr.config);
 	if (event == NULL)
 		return -1;
 
-	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
-	evsel->name = strdup(bf);
-	if (evsel->name == NULL)
-		return -1;
+	if (!evsel->name) {
+		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
+		evsel->name = strdup(bf);
+		if (evsel->name == NULL)
+			return -1;
+	}
 
 	evsel->tp_format = event;
 	return 0;
 }
 
-static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist,
-					     struct pevent *pevent)
+static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
+						  struct pevent *pevent)
 {
 	struct perf_evsel *pos;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		if (pos->attr.type == PERF_TYPE_TRACEPOINT && !pos->name &&
-		    perf_evsel__set_tracepoint_name(pos, pevent))
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		    perf_evsel__prepare_tracepoint_event(pos, pevent))
 			return -1;
 	}
 
@@ -2409,7 +2415,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
-	if (perf_evlist__set_tracepoint_names(session->evlist, session->pevent))
+	if (perf_evlist__prepare_tracepoint_events(session->evlist,
+						   session->pevent))
 		goto out_delete_evlist;
 
 	header->frozen = 1;
@@ -2643,7 +2650,8 @@ int perf_event__process_tracing_data(union perf_event *event,
 	if (size_read + padding != size)
 		die("tracing data size mismatch");
 
-	perf_evlist__set_tracepoint_names(session->evlist, session->pevent);
+	perf_evlist__prepare_tracepoint_events(session->evlist,
+					       session->pevent);
 
 	return size_read + padding;
 }
