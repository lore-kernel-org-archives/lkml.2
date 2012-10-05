Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2JEI6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2JEI6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:58:46 -0400
Date: Fri, 5 Oct 2012 01:58:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ruhm5gocoh32pb7gnr0ai6gh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Remove some unused methods
Git-Commit-ID: e60fc847cefa34d9b7a60f8fbbe3f7dc68fbd75e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:58:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e60fc847cefa34d9b7a60f8fbbe3f7dc68fbd75e
Gitweb:     http://git.kernel.org/tip/e60fc847cefa34d9b7a60f8fbbe3f7dc68fbd75e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 3 Oct 2012 11:50:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 3 Oct 2012 11:52:07 -0300

perf evlist: Remove some unused methods

Those were introduced in a previous attempt at implementing 'trace', but
are not being used anywhere, ditch them.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ruhm5gocoh32pb7gnr0ai6gh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   86 +--------------------------------------------
 tools/perf/util/evlist.h |   17 +--------
 2 files changed, 3 insertions(+), 100 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6a2809f..186b877 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -154,8 +154,8 @@ error:
 	return -ENOMEM;
 }
 
-int perf_evlist__add_attrs(struct perf_evlist *evlist,
-			   struct perf_event_attr *attrs, size_t nr_attrs)
+static int perf_evlist__add_attrs(struct perf_evlist *evlist,
+				  struct perf_event_attr *attrs, size_t nr_attrs)
 {
 	struct perf_evsel *evsel, *n;
 	LIST_HEAD(head);
@@ -189,60 +189,6 @@ int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
 }
 
-static int trace_event__id(const char *evname)
-{
-	char *filename, *colon;
-	int err = -1, fd;
-
-	if (asprintf(&filename, "%s/%s/id", tracing_events_path, evname) < 0)
-		return -1;
-
-	colon = strrchr(filename, ':');
-	if (colon != NULL)
-		*colon = '/';
-
-	fd = open(filename, O_RDONLY);
-	if (fd >= 0) {
-		char id[16];
-		if (read(fd, id, sizeof(id)) > 0)
-			err = atoi(id);
-		close(fd);
-	}
-
-	free(filename);
-	return err;
-}
-
-int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
-				 const char *tracepoints[],
-				 size_t nr_tracepoints)
-{
-	int err;
-	size_t i;
-	struct perf_event_attr *attrs = zalloc(nr_tracepoints * sizeof(*attrs));
-
-	if (attrs == NULL)
-		return -1;
-
-	for (i = 0; i < nr_tracepoints; i++) {
-		err = trace_event__id(tracepoints[i]);
-
-		if (err < 0)
-			goto out_free_attrs;
-
-		attrs[i].type	       = PERF_TYPE_TRACEPOINT;
-		attrs[i].config	       = err;
-	        attrs[i].sample_type   = (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
-					  PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD);
-		attrs[i].sample_period = 1;
-	}
-
-	err = perf_evlist__add_attrs(evlist, attrs, nr_tracepoints);
-out_free_attrs:
-	free(attrs);
-	return err;
-}
-
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 {
@@ -257,34 +203,6 @@ perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 	return NULL;
 }
 
-int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
-					  const struct perf_evsel_str_handler *assocs,
-					  size_t nr_assocs)
-{
-	struct perf_evsel *evsel;
-	int err;
-	size_t i;
-
-	for (i = 0; i < nr_assocs; i++) {
-		err = trace_event__id(assocs[i].name);
-		if (err < 0)
-			goto out;
-
-		evsel = perf_evlist__find_tracepoint_by_id(evlist, err);
-		if (evsel == NULL)
-			continue;
-
-		err = -EEXIST;
-		if (evsel->handler.func != NULL)
-			goto out;
-		evsel->handler.func = assocs[i].handler;
-	}
-
-	err = 0;
-out:
-	return err;
-}
-
 int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ac98b01..56003f7 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -51,27 +51,12 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
-int perf_evlist__add_attrs(struct perf_evlist *evlist,
-			   struct perf_event_attr *attrs, size_t nr_attrs);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
-int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
-				 const char *tracepoints[], size_t nr_tracepoints);
-int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
-					  const struct perf_evsel_str_handler *assocs,
-					  size_t nr_assocs);
-
-#define perf_evlist__add_attrs_array(evlist, array) \
-	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
+
 #define perf_evlist__add_default_attrs(evlist, array) \
 	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
-#define perf_evlist__add_tracepoints_array(evlist, array) \
-	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
-
-#define perf_evlist__set_tracepoints_handlers_array(evlist, array) \
-	perf_evlist__set_tracepoints_handlers(evlist, array, ARRAY_SIZE(array))
-
 int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler);
 
