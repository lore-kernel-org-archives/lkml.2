Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1DRPw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:52:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:60368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab1DRPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:52:50 -0400
Date: Mon, 18 Apr 2011 15:52:16 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-5d2cd90922c778908bd0cd669e572a5b5eafd737@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110414170121.GC3229@ghostprotocols.net>
References: <20110414170121.GC3229@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Fix use of inherit
Git-Commit-ID: 5d2cd90922c778908bd0cd669e572a5b5eafd737
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Apr 2011 15:52:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d2cd90922c778908bd0cd669e572a5b5eafd737
Gitweb:     http://git.kernel.org/tip/5d2cd90922c778908bd0cd669e572a5b5eafd737
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 14 Apr 2011 11:20:14 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Apr 2011 12:52:28 -0300

perf evsel: Fix use of inherit

perf stat doesn't mmap and its perfectly fine for it to use task-bound
counters with inheritance.

So set the attr.inherit on the caller and leave the syscall itself to
validate it.

When the mmap fails perf_evlist__mmap will just emit a warning if this
is the failure reason.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/r/20110414170121.GC3229@ghostprotocols.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    7 +++++--
 tools/perf/builtin-stat.c   |    7 ++++---
 tools/perf/builtin-test.c   |   10 +++++-----
 tools/perf/builtin-top.c    |    3 ++-
 tools/perf/util/evlist.c    |   14 ++++++++++----
 tools/perf/util/evsel.c     |   27 +++++++--------------------
 tools/perf/util/evsel.h     |    6 +++---
 tools/perf/util/python.c    |    9 +++++----
 8 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 17d1dcb..4165382 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -163,6 +163,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
+	attr->inherit		= !no_inherit;
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
@@ -251,6 +252,9 @@ static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
 
+	if (evlist->cpus->map[0] < 0)
+		no_inherit = true;
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
 		/*
@@ -271,8 +275,7 @@ static void open_counters(struct perf_evlist *evlist)
 retry_sample_id:
 		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
-				     !no_inherit) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e2109f9..03f0e45 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -167,16 +167,17 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
+	attr->inherit = !no_inherit;
+
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, false, false);
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, false);
 
-	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads, false, false);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads, false);
 }
 
 /*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1b2106c..11e3c84 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -290,7 +290,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false, false) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -303,7 +303,7 @@ static int test__open_syscall_event(void)
 	}
 
 	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
-		pr_debug("perf_evsel__open_read_on_cpu\n");
+		pr_debug("perf_evsel__read_on_cpu\n");
 		goto out_close_fd;
 	}
 
@@ -365,7 +365,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false, false) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -418,7 +418,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 			continue;
 
 		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
-			pr_debug("perf_evsel__open_read_on_cpu\n");
+			pr_debug("perf_evsel__read_on_cpu\n");
 			err = -1;
 			break;
 		}
@@ -529,7 +529,7 @@ static int test__basic_mmap(void)
 
 		perf_evlist__add(evlist, evsels[i]);
 
-		if (perf_evsel__open(evsels[i], cpus, threads, false, false) < 0) {
+		if (perf_evsel__open(evsels[i], cpus, threads, false) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fc1273e..7e3d6e3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -845,9 +845,10 @@ static void start_counters(struct perf_evlist *evlist)
 		}
 
 		attr->mmap = 1;
+		attr->inherit = inherit;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
-				     top.evlist->threads, group, inherit) < 0) {
+				     top.evlist->threads, group) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d852cef..45da8d1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -12,6 +12,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
+#include "debug.h"
 
 #include <sys/mman.h>
 
@@ -250,15 +251,19 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
-			       int mask, int fd)
+static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			       int cpu, int prot, int mask, int fd)
 {
 	evlist->mmap[cpu].prev = 0;
 	evlist->mmap[cpu].mask = mask;
 	evlist->mmap[cpu].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[cpu].base == MAP_FAILED)
+	if (evlist->mmap[cpu].base == MAP_FAILED) {
+		if (evlist->cpus->map[cpu] == -1 && evsel->attr.inherit)
+			ui__warning("Inherit is not allowed on per-task "
+				    "events using mmap.\n");
 		return -1;
+	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
@@ -312,7 +317,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
 						  FD(first_evsel, cpu, 0)) != 0)
 						goto out_unmap;
-				} else if (__perf_evlist__mmap(evlist, cpu, prot, mask, fd) < 0)
+				} else if (__perf_evlist__mmap(evlist, evsel, cpu,
+							       prot, mask, fd) < 0)
 					goto out_unmap;
 
 				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 662596a..d6fd59b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -175,7 +175,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group, bool inherit)
+			      struct thread_map *threads, bool group)
 {
 	int cpu, thread;
 	unsigned long flags = 0;
@@ -192,19 +192,6 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
-		/*
-		 * Don't allow mmap() of inherited per-task counters. This
-		 * would create a performance issue due to all children writing
-		 * to the same buffer.
-		 *
-		 * FIXME:
-		 * Proper fix is not to pass 'inherit' to perf_evsel__open*,
-		 * but a 'flags' parameter, with 'group' folded there as well,
-		 * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
-		 * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
-		 * set. Lets go for the minimal fix first tho.
-		 */
-		evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
@@ -253,7 +240,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group, bool inherit)
+		     struct thread_map *threads, bool group)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -263,19 +250,19 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group, inherit);
+	return __perf_evsel__open(evsel, cpus, threads, group);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group, bool inherit)
+			     struct cpu_map *cpus, bool group)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group, inherit);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group, bool inherit)
+				struct thread_map *threads, bool group)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6710ab5..f79bb2c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -81,11 +81,11 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group, bool inherit);
+			     struct cpu_map *cpus, bool group);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group, bool inherit);
+				struct thread_map *threads, bool group);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group, bool inherit);
+		     struct thread_map *threads, bool group);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a9f2d7e..f5e3845 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -498,11 +498,11 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	struct cpu_map *cpus = NULL;
 	struct thread_map *threads = NULL;
 	PyObject *pcpus = NULL, *pthreads = NULL;
-	int group = 0, overwrite = 0;
-	static char *kwlist[] = {"cpus", "threads", "group", "overwrite", NULL, NULL};
+	int group = 0, inherit = 0;
+	static char *kwlist[] = {"cpus", "threads", "group", "inherit", NULL, NULL};
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
-					 &pcpus, &pthreads, &group, &overwrite))
+					 &pcpus, &pthreads, &group, &inherit))
 		return NULL;
 
 	if (pthreads != NULL)
@@ -511,7 +511,8 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	if (pcpus != NULL)
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 
-	if (perf_evsel__open(evsel, cpus, threads, group, overwrite) < 0) {
+	evsel->attr.inherit = inherit;
+	if (perf_evsel__open(evsel, cpus, threads, group) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
