Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1K1XRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:17:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48728 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1K1XOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/25] perf session: Remove superfluous callchain_cursor member
Date: Mon, 28 Nov 2011 21:14:16 -0200
Message-Id: <1322522066-21879-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we have it in evsel->hists.callchain_cursor, remove it from
perf_session.

One more step in disentangling several places from requiring a
perf_session pointer.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rxr5dj3di7ckyfmnz0naku1z@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 +++--
 tools/perf/builtin-script.c |    2 +-
 tools/perf/builtin-top.c    |    4 ++--
 tools/perf/util/session.c   |   12 ++++++------
 tools/perf/util/session.h   |    5 ++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 758a287..b7ab373 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -65,7 +65,7 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 	struct hist_entry *he;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		err = perf_session__resolve_callchain(session, al->thread,
+		err = perf_session__resolve_callchain(session, evsel, al->thread,
 						      sample->callchain, &parent);
 		if (err)
 			return err;
@@ -76,7 +76,8 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 		return -ENOMEM;
 
 	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain, &session->callchain_cursor,
+		err = callchain_append(he->callchain,
+				       &evsel->hists.callchain_cursor,
 				       sample->period);
 		if (err)
 			return err;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2f62a29..47545e9 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -384,7 +384,7 @@ static void process_event(union perf_event *event __unused,
 			printf(" ");
 		else
 			printf("\n");
-		perf_session__print_ip(event, sample, session,
+		perf_session__print_ip(event, evsel, sample, session,
 					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 04288ee..9b3bbb4 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -777,7 +777,7 @@ static void perf_event__process_sample(const union perf_event *event,
 
 		if ((sort__has_parent || symbol_conf.use_callchain) &&
 		    sample->callchain) {
-			err = perf_session__resolve_callchain(session, al.thread,
+			err = perf_session__resolve_callchain(session, evsel, al.thread,
 							      sample->callchain, &parent);
 			if (err)
 				return;
@@ -790,7 +790,7 @@ static void perf_event__process_sample(const union perf_event *event,
 		}
 
 		if (symbol_conf.use_callchain) {
-			err = callchain_append(he->callchain, &session->callchain_cursor,
+			err = callchain_append(he->callchain, &evsel->hists.callchain_cursor,
 					       sample->period);
 			if (err)
 				return;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6e7d5f5..734358b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -216,7 +216,7 @@ static bool symbol__match_parent_regex(struct symbol *sym)
 	return 0;
 }
 
-int perf_session__resolve_callchain(struct perf_session *self,
+int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
 				    struct ip_callchain *chain,
 				    struct symbol **parent)
@@ -225,7 +225,7 @@ int perf_session__resolve_callchain(struct perf_session *self,
 	unsigned int i;
 	int err;
 
-	callchain_cursor_reset(&self->callchain_cursor);
+	callchain_cursor_reset(&evsel->hists.callchain_cursor);
 
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip;
@@ -261,7 +261,7 @@ int perf_session__resolve_callchain(struct perf_session *self,
 				break;
 		}
 
-		err = callchain_cursor_append(&self->callchain_cursor,
+		err = callchain_cursor_append(&evsel->hists.callchain_cursor,
 					      ip, al.map, al.sym);
 		if (err)
 			return err;
@@ -1254,14 +1254,14 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_session__print_ip(union perf_event *event,
+void perf_session__print_ip(union perf_event *event, struct perf_evsel *evsel,
 			    struct perf_sample *sample,
 			    struct perf_session *session,
 			    int print_sym, int print_dso)
 {
 	struct addr_location al;
 	const char *symname, *dsoname;
-	struct callchain_cursor *cursor = &session->callchain_cursor;
+	struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
 	struct callchain_cursor_node *node;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
@@ -1273,7 +1273,7 @@ void perf_session__print_ip(union perf_event *event,
 
 	if (symbol_conf.use_callchain && sample->callchain) {
 
-		if (perf_session__resolve_callchain(session, al.thread,
+		if (perf_session__resolve_callchain(session, evsel, al.thread,
 						sample->callchain, NULL) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 13bd5e0..d2f4303 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -50,7 +50,6 @@ struct perf_session {
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
-	struct callchain_cursor	callchain_cursor;
 	char			filename[0];
 };
 
@@ -100,7 +99,7 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *event_ops);
 
-int perf_session__resolve_callchain(struct perf_session *self,
+int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
 				    struct ip_callchain *chain,
 				    struct symbol **parent);
@@ -169,7 +168,7 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-void perf_session__print_ip(union perf_event *event,
+void perf_session__print_ip(union perf_event *event, struct perf_evsel *evsel,
 				 struct perf_sample *sample,
 				 struct perf_session *session,
 				 int print_sym, int print_dso);
-- 
1.7.8.rc0.35.gee6df

