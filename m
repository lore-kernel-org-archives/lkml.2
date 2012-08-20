Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2HTQcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:32:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:56618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/24] perf evlist: Rename __group method to __set_leader
Date: Mon, 20 Aug 2012 13:26:08 -0300
Message-Id: <1345479985-18669-8-git-send-email-acme@infradead.org>
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

Just like was done for parse_events__set_leader.

Also we need to have the list_entry set_leader method in evlist.c so that we
don't grow another dep in the python binding:

 # ~acme/git/linux/tools/perf/python/twatch.py
 Traceback (most recent call last):
   File "/home/acme/git/linux/tools/perf/python/twatch.py", line 16, in <module>
     import perf
 ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: parse_events__set_leader

And also remove a pr_debug from evsel.c so that we avoid this one too:

 # ~acme/git/linux/tools/perf/python/twatch.py
 Traceback (most recent call last):
   File "/home/acme/git/linux/tools/perf/python/twatch.py", line 16, in <module>
     import perf
 ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: eprintf

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
Link: http://lkml.kernel.org/n/tip-0hk9dazg9pora9jylkqngovm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/builtin-stat.c      |    2 +-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/util/evlist.c       |   17 +++++++++++++++--
 tools/perf/util/evlist.h       |    5 +++--
 tools/perf/util/evsel.c        |    4 ----
 tools/perf/util/parse-events.c |   19 +++----------------
 tools/perf/util/parse-events.h |    3 +--
 tools/perf/util/parse-events.y |    4 ++--
 tools/perf/util/python.c       |    2 +-
 10 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f5b6137..c4e3b68 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -193,7 +193,7 @@ static void perf_record__open(struct perf_record *rec)
 	perf_evlist__config_attrs(evlist, opts);
 
 	if (opts->group)
-		perf_evlist__group(evlist);
+		perf_evlist__set_leader(evlist);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 23908a8..7b9c463 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -478,7 +478,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	}
 
 	if (group)
-		perf_evlist__group(evsel_list);
+		perf_evlist__set_leader(evsel_list);
 
 	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 392d219..5a097be 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -890,7 +890,7 @@ static void perf_top__start_counters(struct perf_top *top)
 	struct perf_evlist *evlist = top->evlist;
 
 	if (top->group)
-		perf_evlist__group(evlist);
+		perf_evlist__set_leader(evlist);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index feffee3..6d09451 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -108,10 +108,23 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 	evlist->nr_entries += nr_entries;
 }
 
-void perf_evlist__group(struct perf_evlist *evlist)
+void __perf_evlist__set_leader(struct list_head *list)
+{
+	struct perf_evsel *evsel, *leader;
+
+	leader = list_entry(list->next, struct perf_evsel, node);
+	leader->leader = NULL;
+
+	list_for_each_entry(evsel, list, node) {
+		if (evsel != leader)
+			evsel->leader = leader;
+	}
+}
+
+void perf_evlist__set_leader(struct perf_evlist *evlist)
 {
 	if (evlist->nr_entries)
-		parse_events__set_leader(&evlist->entries);
+		__perf_evlist__set_leader(&evlist->entries);
 }
 
 int perf_evlist__add_default(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index a19ccd7..7fe677e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -118,6 +118,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
+void __perf_evlist__set_leader(struct list_head *list);
+void perf_evlist__set_leader(struct perf_evlist *evlist);
+
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
@@ -131,6 +134,4 @@ bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
-
-void perf_evlist__group(struct perf_evlist *evlist);
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f5b68e7..6c7dcc1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -622,10 +622,6 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 				err = -errno;
 				goto out_close;
 			}
-
-			pr_debug("event cpu %d, thread %d, fd %d, group %d\n",
-				 cpu, pid, FD(evsel, cpu, thread),
-				 group_fd);
 		}
 	}
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f6453cd..4393a6b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -611,31 +611,18 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 			 pmu_event_name(head_config));
 }
 
-struct perf_evsel *parse_events__set_leader(struct list_head *list)
-{
-	struct perf_evsel *evsel, *leader;
-
-	leader = list_entry(list->next, struct perf_evsel, node);
-	leader->leader = NULL;
-
-	list_for_each_entry(evsel, list, node)
-		if (evsel != leader)
-			evsel->leader = leader;
-
-	return leader;
-}
-
 int parse_events__modifier_group(struct list_head *list,
 				 char *event_mod)
 {
 	return parse_events__modifier_event(list, event_mod, true);
 }
 
-void parse_events__group(char *name, struct list_head *list)
+void parse_events__set_leader(char *name, struct list_head *list)
 {
 	struct perf_evsel *leader;
 
-	leader = parse_events__set_leader(list);
+	__perf_evlist__set_leader(list);
+	leader = list_entry(list->next, struct perf_evsel, node);
 	leader->group_name = name ? strdup(name) : NULL;
 }
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index e1a184c..0b9782d 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -92,8 +92,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
-struct perf_evsel *parse_events__set_leader(struct list_head *list);
-void parse_events__group(char *name, struct list_head *list);
+void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(void *data, void *scanner, char const *msg);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 084c35f..66850f8 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -119,7 +119,7 @@ PE_NAME '{' events '}'
 {
 	struct list_head *list = $3;
 
-	parse_events__group($1, list);
+	parse_events__set_leader($1, list);
 	$$ = list;
 }
 |
@@ -127,7 +127,7 @@ PE_NAME '{' events '}'
 {
 	struct list_head *list = $2;
 
-	parse_events__group(NULL, list);
+	parse_events__set_leader(NULL, list);
 	$$ = list;
 }
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f5bba4b..27187f0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -825,7 +825,7 @@ static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
 		return NULL;
 
 	if (group)
-		perf_evlist__group(evlist);
+		perf_evlist__set_leader(evlist);
 
 	if (perf_evlist__open(evlist) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
-- 
1.7.1

