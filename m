Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1FHNqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:46:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab1FHNq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:46:29 -0400
Date: Wed, 8 Jun 2011 15:46:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110608134609.GA29436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf evlist: Remove dependency on debug routines
      perf python: Use exception to propagate errors
      perf evlist: Don't die if sample_{id_all|type} is invalid

Frederic Weisbecker (1):
      perf python: Fix argument name list of read_on_cpu()

Peter Zijlstra (1):
      perf, cgroups: Fix up for new API

Vince Weaver (2):
      perf: Comment /proc/sys/kernel/perf_event_paranoid to be part of user ABI
      perf: Fix comments in include/linux/perf_event.h


 include/linux/perf_event.h |    8 ++--
 kernel/events/core.c       |   22 ++-----------
 kernel/sysctl.c            |    6 ++++
 tools/perf/builtin-test.c  |    2 +-
 tools/perf/util/event.c    |   16 ----------
 tools/perf/util/event.h    |    2 -
 tools/perf/util/evlist.c   |   68 ++++++++++++++++++++++++-------------------
 tools/perf/util/evlist.h   |    6 ++-
 tools/perf/util/evsel.c    |   16 ++++++++++
 tools/perf/util/evsel.h    |    7 ++++
 tools/perf/util/python.c   |   14 ++++-----
 tools/perf/util/session.c  |   12 +++++++-
 12 files changed, 97 insertions(+), 82 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..e0786e3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -137,14 +137,14 @@ enum perf_event_sample_format {
  *
  * struct read_format {
  *	{ u64		value;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		id;           } && PERF_FORMAT_ID
  *	} && !PERF_FORMAT_GROUP
  *
  *	{ u64		nr;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		value;
  *	    { u64	id;           } && PERF_FORMAT_ID
  *	  }		cntr[nr];
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d863b3c..9efe710 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7402,26 +7402,12 @@ static int __perf_cgroup_move(void *info)
 	return 0;
 }
 
-static void perf_cgroup_move(struct task_struct *task)
+static void
+perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
 {
 	task_function_call(task, __perf_cgroup_move, task);
 }
 
-static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		struct cgroup *old_cgrp, struct task_struct *task,
-		bool threadgroup)
-{
-	perf_cgroup_move(task);
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			perf_cgroup_move(c);
-		}
-		rcu_read_unlock();
-	}
-}
-
 static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		struct cgroup *old_cgrp, struct task_struct *task)
 {
@@ -7433,7 +7419,7 @@ static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	if (!(task->flags & PF_EXITING))
 		return;
 
-	perf_cgroup_move(task);
+	perf_cgroup_attach_task(cgrp, task);
 }
 
 struct cgroup_subsys perf_subsys = {
@@ -7442,6 +7428,6 @@ struct cgroup_subsys perf_subsys = {
 	.create		= perf_cgroup_create,
 	.destroy	= perf_cgroup_destroy,
 	.exit		= perf_cgroup_exit,
-	.attach		= perf_cgroup_attach,
+	.attach_task	= perf_cgroup_attach_task,
 };
 #endif /* CONFIG_CGROUP_PERF */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4fc9244..f175d98 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -938,6 +938,12 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 #ifdef CONFIG_PERF_EVENTS
+	/*
+	 * User-space scripts rely on the existence of this file
+	 * as a feature check for perf_events being enabled.
+	 *
+	 * So it's an ABI, do not remove!
+	 */
 	{
 		.procname	= "perf_event_paranoid",
 		.data		= &sysctl_perf_event_paranoid,
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
index 50aa348..b021ea9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -12,7 +12,6 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
-#include "debug.h"
 
 #include <sys/mman.h>
 
@@ -257,19 +256,15 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
+static int __perf_evlist__mmap(struct perf_evlist *evlist,
 			       int idx, int prot, int mask, int fd)
 {
 	evlist->mmap[idx].prev = 0;
 	evlist->mmap[idx].mask = mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED) {
-		if (evlist->cpus->map[idx] == -1 && evsel->attr.inherit)
-			ui__warning("Inherit is not allowed on per-task "
-				    "events using mmap.\n");
+	if (evlist->mmap[idx].base == MAP_FAILED)
 		return -1;
-	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
@@ -289,7 +284,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 
 				if (output == -1) {
 					output = fd;
-					if (__perf_evlist__mmap(evlist, evsel, cpu,
+					if (__perf_evlist__mmap(evlist, cpu,
 								prot, mask, output) < 0)
 						goto out_unmap;
 				} else {
@@ -329,7 +324,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 
 			if (output == -1) {
 				output = fd;
-				if (__perf_evlist__mmap(evlist, evsel, thread,
+				if (__perf_evlist__mmap(evlist, thread,
 							prot, mask, output) < 0)
 					goto out_unmap;
 			} else {
@@ -460,33 +455,46 @@ int perf_evlist__set_filters(struct perf_evlist *evlist)
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
index 69436b3..a9ac050 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -674,7 +674,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
-	static char *kwlist[] = {"sample_id_all", NULL, NULL};
+	static char *kwlist[] = {"cpu", "sample_id_all", NULL, NULL};
 	int err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
@@ -692,16 +692,14 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
-					       perf_sample_size(first->attr.sample_type),
+					       perf_evsel__sample_size(first),
 					       sample_id_all, &pevent->sample);
-		if (err) {
-			pr_err("Can't parse sample, err = %d\n", err);
-			goto end;
-		}
-
+		if (err)
+			return PyErr_Format(PyExc_OSError,
+					    "perf: can't parse sample, err=%d", err);
 		return pyevent;
 	}
-end:
+
 	Py_INCREF(Py_None);
 	return Py_None;
 }
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
