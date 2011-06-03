Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1FCQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:26:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1FCQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:26:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf evlist: Don't die if sample_{id_all|type} is invalid
Date: Fri,  3 Jun 2011 13:26:02 -0300
Message-Id: <1307118363-24092-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307118363-24092-1-git-send-email-acme@infradead.org>
References: <1307118363-24092-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixes two more cases where the python binding would not load:

. Not finding die(), which it shouldn't anyway, not good to just stop the
  world because some particular perf.data file is invalid, just propagate
  the error to the caller.

. Not finding perf_sample_size: fix it by moving it from event.c to evsel,
  where it belongs, as most cases are moving to operate on an evsel object.o

One of the fixed problems:

[root@emilia ~]# python
>>> import perf
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: perf_sample_size
>>>
[root@emilia ~]#

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1hkj7b2cvgbfnoizsekjb6c9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    2 +-
 tools/perf/util/event.c   |   16 -------------
 tools/perf/util/event.h   |    2 -
 tools/perf/util/evlist.c  |   55 +++++++++++++++++++++++++++-----------------
 tools/perf/util/evlist.h  |    6 +++-
 tools/perf/util/evsel.c   |   16 +++++++++++++
 tools/perf/util/evsel.h   |    7 +++++
 tools/perf/util/python.c  |    2 +-
 tools/perf/util/session.c |   12 +++++++++-
 9 files changed, 74 insertions(+), 44 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index b671862..2da9162 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -474,7 +474,7 @@ static int test__basic_mmap(void)
 	unsigned int nr_events[nsyscalls],
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
-	int sample_size = perf_sample_size(attr.sample_type);
+	int sample_size = __perf_evsel__sample_size(attr.sample_type);
 
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 0fe9adf..3c1b8a6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -35,22 +35,6 @@ const char *perf_event__name(unsigned int id)
 	return perf_event__names[id];
 }
 
-int perf_sample_size(u64 sample_type)
-{
-	u64 mask = sample_type & PERF_SAMPLE_MASK;
-	int size = 0;
-	int i;
-
-	for (i = 0; i < 64; i++) {
-		if (mask & (1ULL << i))
-			size++;
-	}
-
-	size *= sizeof(u64);
-
-	return size;
-}
-
 static struct perf_sample synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c083328..1d7f664 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -82,8 +82,6 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 };
 
-int perf_sample_size(u64 sample_type);
-
 #define BUILD_ID_SIZE 20
 
 struct build_id_event {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 04c8a60..b021ea9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -455,33 +455,46 @@ int perf_evlist__set_filters(struct perf_evlist *evlist)
 	return 0;
 }
 
-u64 perf_evlist__sample_type(struct perf_evlist *evlist)
+bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
 {
-	struct perf_evsel *pos;
-	u64 type = 0;
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (!type)
-			type = pos->attr.sample_type;
-		else if (type != pos->attr.sample_type)
-			die("non matching sample_type");
+	struct perf_evsel *pos, *first;
+
+	pos = first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry_continue(pos, &evlist->entries, node) {
+		if (first->attr.sample_type != pos->attr.sample_type)
+			return false;
 	}
 
-	return type;
+	return true;
 }
 
-bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
+u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_type;
+}
+
+bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist)
 {
-	bool value = false, first = true;
-	struct perf_evsel *pos;
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (first) {
-			value = pos->attr.sample_id_all;
-			first = false;
-		} else if (value != pos->attr.sample_id_all)
-			die("non matching sample_id_all");
+	struct perf_evsel *pos, *first;
+
+	pos = first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry_continue(pos, &evlist->entries, node) {
+		if (first->attr.sample_id_all != pos->attr.sample_id_all)
+			return false;
 	}
 
-	return value;
+	return true;
+}
+
+bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_id_all;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 0a1ef1f..b2b8623 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -66,7 +66,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
-u64 perf_evlist__sample_type(struct perf_evlist *evlist);
-bool perf_evlist__sample_id_all(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
+bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
 
+bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
+bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index cca29ed..0239eb8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,6 +15,22 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
+int __perf_evsel__sample_size(u64 sample_type)
+{
+	u64 mask = sample_type & PERF_SAMPLE_MASK;
+	int size = 0;
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		if (mask & (1ULL << i))
+			size++;
+	}
+
+	size *= sizeof(u64);
+
+	return size;
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f79bb2c..7e9366e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -149,4 +149,11 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read(evsel, ncpus, nthreads, true);
 }
 
+int __perf_evsel__sample_size(u64 sample_type);
+
+static inline int perf_evsel__sample_size(struct perf_evsel *evsel)
+{
+	return __perf_evsel__sample_size(evsel->attr.sample_type);
+}
+
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 2dd1698..24063b4 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -692,7 +692,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
-					       perf_sample_size(first->attr.sample_type),
+					       perf_evsel__sample_size(first),
 					       sample_id_all, &pevent->sample);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64500fc..f5a8fbd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -58,6 +58,16 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
+	if (!perf_evlist__valid_sample_type(self->evlist)) {
+		pr_err("non matching sample_type");
+		goto out_close;
+	}
+
+	if (!perf_evlist__valid_sample_id_all(self->evlist)) {
+		pr_err("non matching sample_id_all");
+		goto out_close;
+	}
+
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -97,7 +107,7 @@ out:
 void perf_session__update_sample_type(struct perf_session *self)
 {
 	self->sample_type = perf_evlist__sample_type(self->evlist);
-	self->sample_size = perf_sample_size(self->sample_type);
+	self->sample_size = __perf_evsel__sample_size(self->sample_type);
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	perf_session__id_header_size(self);
 }
-- 
1.6.2.5

