Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2HTQcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:32:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2HTQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/24] perf evlist: Introduce evsel list accessors
Date: Mon, 20 Aug 2012 13:26:09 -0300
Message-Id: <1345479985-18669-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To replace the longer list_entry constructs for things that are widely
used:

	perf_evlist__{first,last}(evlist)
	perf_evsel__next(evsel)

Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ng7azq26wg1jd801qqpcozwp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c         |    4 +-
 tools/perf/builtin-stat.c           |    2 +-
 tools/perf/builtin-test.c           |    2 +-
 tools/perf/builtin-top.c            |    6 +-
 tools/perf/util/evlist.c            |   40 ++++-------
 tools/perf/util/evlist.h            |   23 ++++--
 tools/perf/util/evsel.h             |    5 ++
 tools/perf/util/header.c            |    4 +-
 tools/perf/util/parse-events-test.c |  129 +++++++++++++----------------------
 tools/perf/util/parse-events.c      |    2 +-
 tools/perf/util/top.c               |    3 +-
 11 files changed, 95 insertions(+), 125 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c4e3b68..479ff2a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -172,12 +172,12 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 	if (evlist->nr_entries != other->nr_entries)
 		return false;
 
-	pair = list_entry(other->entries.next, struct perf_evsel, node);
+	pair = perf_evlist__first(other);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr) != 0))
 			return false;
-		pair = list_entry(pair->node.next, struct perf_evsel, node);
+		pair = perf_evsel__next(pair);
 	}
 
 	return true;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7b9c463..d53d8ab 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -480,7 +480,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	if (group)
 		perf_evlist__set_leader(evsel_list);
 
-	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
+	first = perf_evlist__first(evsel_list);
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 9a479b6..381d5ab 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -710,7 +710,7 @@ static int test__PERF_RECORD(void)
 	/*
 	 * Config the evsels, setting attr->comm on the first one, etc.
 	 */
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	evsel = perf_evlist__first(evlist);
 	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
 	evsel->attr.sample_type |= PERF_SAMPLE_TID;
 	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5a097be..0513aaa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -509,7 +509,7 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 				prompt_integer(&counter, "Enter details event counter");
 
 				if (counter >= top->evlist->nr_entries) {
-					top->sym_evsel = list_entry(top->evlist->entries.next, struct perf_evsel, node);
+					top->sym_evsel = perf_evlist__first(top->evlist);
 					fprintf(stderr, "Sorry, no such event, using %s.\n", perf_evsel__name(top->sym_evsel));
 					sleep(1);
 					break;
@@ -518,7 +518,7 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 					if (top->sym_evsel->idx == counter)
 						break;
 			} else
-				top->sym_evsel = list_entry(top->evlist->entries.next, struct perf_evsel, node);
+				top->sym_evsel = perf_evlist__first(top->evlist);
 			break;
 		case 'f':
 			prompt_integer(&top->count_filter, "Enter display event count filter");
@@ -1326,7 +1326,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 			pos->attr.sample_period = top.default_interval;
 	}
 
-	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
+	top.sym_evsel = perf_evlist__first(top.evlist);
 
 	symbol_conf.priv_size = sizeof(struct annotation);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6d09451..4774ac1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -57,7 +57,7 @@ void perf_evlist__config_attrs(struct perf_evlist *evlist,
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	first = perf_evlist__first(evlist);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		perf_evsel__config(evsel, opts, first);
@@ -376,7 +376,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	int hash;
 
 	if (evlist->nr_entries == 1)
-		return list_entry(evlist->entries.next, struct perf_evsel, node);
+		return perf_evlist__first(evlist);
 
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
@@ -386,7 +386,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 			return sid->evsel;
 
 	if (!perf_evlist__sample_id_all(evlist))
-		return list_entry(evlist->entries.next, struct perf_evsel, node);
+		return perf_evlist__first(evlist);
 
 	return NULL;
 }
@@ -694,11 +694,9 @@ int perf_evlist__set_filters(struct perf_evlist *evlist)
 	return 0;
 }
 
-bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
+bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
 {
-	struct perf_evsel *pos, *first;
-
-	pos = first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
 
 	list_for_each_entry_continue(pos, &evlist->entries, node) {
 		if (first->attr.sample_type != pos->attr.sample_type)
@@ -708,23 +706,19 @@ bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
 	return true;
 }
 
-u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
+u64 perf_evlist__sample_type(struct perf_evlist *evlist)
 {
-	struct perf_evsel *first;
-
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	struct perf_evsel *first = perf_evlist__first(evlist);
 	return first->attr.sample_type;
 }
 
-u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist)
+u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist)
 {
-	struct perf_evsel *first;
+	struct perf_evsel *first = perf_evlist__first(evlist);
 	struct perf_sample *data;
 	u64 sample_type;
 	u16 size = 0;
 
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
-
 	if (!first->attr.sample_id_all)
 		goto out;
 
@@ -748,11 +742,9 @@ out:
 	return size;
 }
 
-bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist)
+bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist)
 {
-	struct perf_evsel *pos, *first;
-
-	pos = first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
 
 	list_for_each_entry_continue(pos, &evlist->entries, node) {
 		if (first->attr.sample_id_all != pos->attr.sample_id_all)
@@ -762,11 +754,9 @@ bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist)
 	return true;
 }
 
-bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
+bool perf_evlist__sample_id_all(struct perf_evlist *evlist)
 {
-	struct perf_evsel *first;
-
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	struct perf_evsel *first = perf_evlist__first(evlist);
 	return first->attr.sample_id_all;
 }
 
@@ -896,6 +886,6 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
 int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
 			      struct perf_sample *sample, bool swapped)
 {
-	struct perf_evsel *e = list_entry(evlist->entries.next, struct perf_evsel, node);
-	return perf_evsel__parse_sample(e, event, sample, swapped);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+	return perf_evsel__parse_sample(evsel, event, sample, swapped);
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7fe677e..2ed2557 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
+#include "evsel.h"
 #include "util.h"
 #include <unistd.h>
 
@@ -41,8 +42,6 @@ struct perf_evsel_str_handler {
 	void	   *handler;
 };
 
-struct perf_evsel;
-
 struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 				     struct thread_map *threads);
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
@@ -121,17 +120,27 @@ int perf_evlist__set_filters(struct perf_evlist *evlist);
 void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
 
-u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
-bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
-u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_type(struct perf_evlist *evlist);
+bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
+u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
 
 int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
 			      struct perf_sample *sample, bool swapped);
 
-bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
-bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+bool perf_evlist__valid_sample_type(struct perf_evlist *evlist);
+bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
+
+static inline struct perf_evsel *perf_evlist__first(struct perf_evlist *evlist)
+{
+	return list_entry(evlist->entries.next, struct perf_evsel, node);
+}
+
+static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
+{
+	return list_entry(evlist->entries.prev, struct perf_evsel, node);
+}
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index c411b42..65f39fd 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -184,4 +184,9 @@ void hists__init(struct hists *hists);
 
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample, bool swapped);
+
+static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
+{
+	return list_entry(evsel->node.next, struct perf_evsel, node);
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7e7d34f..77832b8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1689,7 +1689,7 @@ int perf_session__write_header(struct perf_session *session,
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
 	if (session->evlist != evlist)
-		pair = list_entry(session->evlist->entries.next, struct perf_evsel, node);
+		pair = perf_evlist__first(session->evlist);
 
 	list_for_each_entry(attr, &evlist->entries, node) {
 		attr->id_offset = lseek(fd, 0, SEEK_CUR);
@@ -1704,7 +1704,7 @@ out_err_write:
 			if (err < 0)
 				goto out_err_write;
 			attr->ids += pair->ids;
-			pair = list_entry(pair->node.next, struct perf_evsel, node);
+			pair = perf_evsel__next(pair);
 		}
 	}
 
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 429dd68..bf055ce 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -18,8 +18,7 @@ do { \
 
 static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
@@ -48,8 +47,7 @@ static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
 
 static int test__checkevent_raw(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
@@ -59,8 +57,7 @@ static int test__checkevent_raw(struct perf_evlist *evlist)
 
 static int test__checkevent_numeric(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
@@ -70,8 +67,7 @@ static int test__checkevent_numeric(struct perf_evlist *evlist)
 
 static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
@@ -82,8 +78,7 @@ static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
 
 static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
@@ -100,8 +95,7 @@ static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
 
 static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
@@ -112,8 +106,7 @@ static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
 
 static int test__checkevent_genhw(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
@@ -123,8 +116,7 @@ static int test__checkevent_genhw(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
@@ -138,8 +130,7 @@ static int test__checkevent_breakpoint(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
@@ -152,8 +143,7 @@ static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type",
@@ -168,8 +158,7 @@ static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type",
@@ -184,8 +173,7 @@ static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type",
@@ -200,8 +188,7 @@ static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
 
 static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
@@ -232,8 +219,7 @@ test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
@@ -245,8 +231,7 @@ static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
@@ -258,8 +243,7 @@ static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
@@ -271,8 +255,7 @@ static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
@@ -282,8 +265,7 @@ static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
@@ -293,8 +275,7 @@ static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
@@ -306,8 +287,7 @@ static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
@@ -319,8 +299,7 @@ static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
@@ -334,8 +313,7 @@ static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
@@ -349,8 +327,7 @@ static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
@@ -364,8 +341,7 @@ static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
@@ -379,8 +355,7 @@ static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 
 static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
@@ -395,8 +370,7 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
@@ -410,12 +384,11 @@ static int test__checkevent_pmu(struct perf_evlist *evlist)
 
 static int test__checkevent_list(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
 
 	/* r1 */
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
@@ -426,7 +399,7 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 
 	/* syscalls:sys_enter_open:k */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong sample_type",
 		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
@@ -437,7 +410,7 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 
 	/* 1:1:hp */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
@@ -450,17 +423,16 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 
 static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	/* cpu/config=1,name=krava/u */
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
 
 	/* cpu/config=2/u" */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
@@ -520,8 +492,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 
 	/* instructions:k */
-	evsel = leader = list_entry(evlist->entries.next,
-				    struct perf_evsel, node);
+	evsel = leader = perf_evlist__first(evlist);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
@@ -534,7 +505,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 
 	/* cycles:upp */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -556,8 +527,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
 
 	/* faults + :ku modifier */
-	evsel = leader = list_entry(evlist->entries.next,
-				    struct perf_evsel, node);
+	evsel = leader = perf_evlist__first(evlist);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
@@ -570,7 +540,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 
 	/* cache-references + :u modifier */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CACHE_REFERENCES == evsel->attr.config);
@@ -583,7 +553,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 
 	/* cycles:k */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -605,8 +575,7 @@ static int test__group3(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
 
 	/* group1 syscalls:sys_enter_open:H */
-	evsel = leader = list_entry(evlist->entries.next,
-				    struct perf_evsel, node);
+	evsel = leader = perf_evlist__first(evlist);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong sample_type",
 		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
@@ -622,7 +591,7 @@ static int test__group3(struct perf_evlist *evlist __used)
 		!strcmp(leader->group_name, "group1"));
 
 	/* group1 cycles:kppp */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -636,7 +605,7 @@ static int test__group3(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 
 	/* group2 cycles + G modifier */
-	evsel = leader = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = leader = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -651,7 +620,7 @@ static int test__group3(struct perf_evlist *evlist __used)
 		!strcmp(leader->group_name, "group2"));
 
 	/* group2 1:3 + G modifier */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
@@ -663,7 +632,7 @@ static int test__group3(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 
 	/* instructions:u */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
@@ -685,8 +654,7 @@ static int test__group4(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 
 	/* cycles:u + p */
-	evsel = leader = list_entry(evlist->entries.next,
-				    struct perf_evsel, node);
+	evsel = leader = perf_evlist__first(evlist);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -700,7 +668,7 @@ static int test__group4(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 
 	/* instructions:kp + p */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
@@ -722,8 +690,7 @@ static int test__group5(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
 
 	/* cycles + G */
-	evsel = leader = list_entry(evlist->entries.next,
-				    struct perf_evsel, node);
+	evsel = leader = perf_evlist__first(evlist);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -737,7 +704,7 @@ static int test__group5(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 
 	/* instructions + G */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
@@ -750,7 +717,7 @@ static int test__group5(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 
 	/* cycles:G */
-	evsel = leader = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = leader = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
@@ -764,7 +731,7 @@ static int test__group5(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 
 	/* instructions:G */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
@@ -777,7 +744,7 @@ static int test__group5(struct perf_evlist *evlist __used)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 
 	/* cycles */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	evsel = perf_evsel__next(evsel);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
 			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4393a6b..925784a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -834,7 +834,7 @@ int parse_filter(const struct option *opt, const char *str,
 	struct perf_evsel *last = NULL;
 
 	if (evlist->nr_entries > 0)
-		last = list_entry(evlist->entries.prev, struct perf_evsel, node);
+		last = perf_evlist__last(evlist);
 
 	if (last == NULL || last->attr.type != PERF_TYPE_TRACEPOINT) {
 		fprintf(stderr,
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 7eeebce..884dde9 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -58,8 +58,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	}
 
 	if (top->evlist->nr_entries == 1) {
-		struct perf_evsel *first;
-		first = list_entry(top->evlist->entries.next, struct perf_evsel, node);
+		struct perf_evsel *first = perf_evlist__first(top->evlist);
 		ret += SNPRINTF(bf + ret, size - ret, "%" PRIu64 "%s ",
 				(uint64_t)first->attr.sample_period,
 				top->freq ? "Hz" : "");
-- 
1.7.1

