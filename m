Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1LEMzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:55:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1LEMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:55:35 -0500
Date: Mon, 5 Dec 2011 04:54:38 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rxr5dj3di7ckyfmnz0naku1z@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Remove superfluous callchain_cursor member
Git-Commit-ID: 246d4ce8107ea16521384c8b2a8fcff354ef2b7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:54:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  246d4ce8107ea16521384c8b2a8fcff354ef2b7c
Gitweb:     http://git.kernel.org/tip/246d4ce8107ea16521384c8b2a8fcff354ef2b7c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Nov 2011 23:10:26 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:37:58 -0200

perf session: Remove superfluous callchain_cursor member

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
