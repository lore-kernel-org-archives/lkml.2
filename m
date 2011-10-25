Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1JYPXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:23:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41370 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1JYPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:23:15 -0400
Date: Tue, 25 Oct 2011 13:23:09 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its
 place in __perf_evsel__open()
Message-ID: <20111025152309.GA7623@ghostprotocols.net>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
 <1319453820-12992-3-git-send-email-dczhu@mips.com>
 <20111024140328.GA5770@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024140328.GA5770@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 24, 2011 at 12:03:28PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Oct 24, 2011 at 06:57:00PM +0800, Deng-Cheng Zhu escreveu:
> > __perf_evsel__open() is called per event, it does not work for all the
> > grouped events at one time. So, currently group_fd will alway be -1 for
> > the events in a group. This patch fixes it.
> > 
> > Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > ---
> >  tools/perf/util/evsel.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > index e389815..7bd0d9d 100644
> > --- a/tools/perf/util/evsel.c
> > +++ b/tools/perf/util/evsel.c
> > @@ -219,9 +219,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> >  	}
> >  
> >  	for (cpu = 0; cpu < cpus->nr; cpu++) {
> > -		int group_fd = -1;
> > -
> >  		for (thread = 0; thread < threads->nr; thread++) {
> > +			static int group_fd = -1;
> >  
> >  			if (!evsel->cgrp)
> >  				pid = threads->map[thread];
> 
> Lets not do it that way, using statics for this is humm, ugly, IMHO.
> 
> Just pass an integer pointer that is a member of perf_evlist, I'll work
> on a patch now.
> 
> Thanks for reporting the bug tho! 

Can you try this patch?

I tested it with:

[root@emilia ~]# perf top -e cycles -e instructions --group

and

[root@emilia ~]# perf record -e cycles -e instructions --group -a sleep 2

Peter,

	Do you see anything wrong with it?

Thanks,

- Arnaldo

>From fa5e5376207a3e08e0893c3a15321d8972e51fd1 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 25 Oct 2011 10:42:19 -0200
Subject: [PATCH] perf evlist: Fix grouping of multiple events

The __perf_evsel__open routing was grouping just the threads for that
specific events per cpu when we want to group all threads in all events
to the first fd opened on that cpu.

So pass the xyarray with the first event, where the other events will be
able to get that first per cpu fd.

At some point top and record will switch to using perf_evlist__open that
takes care of this detail and probably will also handle the fallback
from hw to soft counters, etc.

Reported-by: Deng-Cheng Zhu <dczhu@mips.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ebm34rh098i9y9v4cytfdp0x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   11 +++++++++--
 tools/perf/builtin-stat.c   |   20 ++++++++++++++------
 tools/perf/builtin-test.c   |    6 +++---
 tools/perf/builtin-top.c    |   11 +++++++++--
 tools/perf/util/evlist.c    |   30 ++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h    |    2 ++
 tools/perf/util/evsel.c     |   43 +++++++++++++++++++++++++++++++------------
 tools/perf/util/evsel.h     |   10 +++++++---
 tools/perf/util/python.c    |   31 ++++++++++++++++++++++++++++++-
 9 files changed, 135 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f82480f..40088a5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -262,13 +262,16 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
 static void open_counters(struct perf_evlist *evlist)
 {
-	struct perf_evsel *pos;
+	struct perf_evsel *pos, *first;
 
 	if (evlist->cpus->map[0] < 0)
 		no_inherit = true;
 
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
+		struct xyarray *group_fd = NULL;
 		/*
 		 * Check if parse_single_tracepoint_event has already asked for
 		 * PERF_SAMPLE_TIME.
@@ -283,11 +286,15 @@ static void open_counters(struct perf_evlist *evlist)
 		 */
 		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
+		if (group && pos != first)
+			group_fd = first->fd;
+
 		config_attr(pos, evlist);
 retry_sample_id:
 		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
+				     group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7ce65f5..7d98676 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -278,9 +278,14 @@ struct stats			runtime_itlb_cache_stats[MAX_NR_CPUS];
 struct stats			runtime_dtlb_cache_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
-static int create_perf_stat_counter(struct perf_evsel *evsel)
+static int create_perf_stat_counter(struct perf_evsel *evsel,
+				    struct perf_evsel *first)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	struct xyarray *group_fd = NULL;
+
+	if (group && evsel != first)
+		group_fd = first->fd;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -289,14 +294,15 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 	attr->inherit = !no_inherit;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, group);
-
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
+						group, group_fd);
 	if (target_pid == -1 && target_tid == -1) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads, group);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
+					   group, group_fd);
 }
 
 /*
@@ -396,7 +402,7 @@ static int read_counter(struct perf_evsel *counter)
 static int run_perf_stat(int argc __used, const char **argv)
 {
 	unsigned long long t0, t1;
-	struct perf_evsel *counter;
+	struct perf_evsel *counter, *first;
 	int status = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
@@ -453,8 +459,10 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
+
 	list_for_each_entry(counter, &evsel_list->entries, node) {
-		if (create_perf_stat_counter(counter) < 0) {
+		if (create_perf_stat_counter(counter, first) < 0) {
 			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index efe696f..831d1ba 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -291,7 +291,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false, NULL) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -366,7 +366,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false, NULL) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -531,7 +531,7 @@ static int test__basic_mmap(void)
 
 		perf_evlist__add(evlist, evsels[i]);
 
-		if (perf_evsel__open(evsels[i], cpus, threads, false) < 0) {
+		if (perf_evsel__open(evsels[i], cpus, threads, false, NULL) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7a87171..d2fc754 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -834,10 +834,16 @@ static void perf_session__mmap_read(struct perf_session *self)
 
 static void start_counters(struct perf_evlist *evlist)
 {
-	struct perf_evsel *counter;
+	struct perf_evsel *counter, *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
+		struct xyarray *group_fd = NULL;
+
+		if (group && counter != first)
+			group_fd = first->fd;
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -860,7 +866,8 @@ static void start_counters(struct perf_evlist *evlist)
 		attr->inherit = inherit;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
-				     top.evlist->threads, group) < 0) {
+				     top.evlist->threads, group,
+				     group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2f6bc89..fbb4b4a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -539,3 +539,33 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 {
 	evlist->selected = evsel;
 }
+
+int perf_evlist__open(struct perf_evlist *evlist, bool group)
+{
+	struct perf_evsel *evsel, *first;
+	int err, ncpus, nthreads;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		struct xyarray *group_fd = NULL;
+
+		if (group && evsel != first)
+			group_fd = first->fd;
+
+		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads,
+				       group, group_fd);
+		if (err < 0)
+			goto out_err;
+	}
+
+	return 0;
+out_err:
+	ncpus = evlist->cpus ? evlist->cpus->nr : 1;
+	nthreads = evlist->threads ? evlist->threads->nr : 1;
+
+	list_for_each_entry_reverse(evsel, &evlist->entries, node)
+		perf_evsel__close(evsel, ncpus, nthreads);
+
+	return err;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 6be71fc..1779ffe 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -50,6 +50,8 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
+int perf_evlist__open(struct perf_evlist *evlist, bool group);
+
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b46f6e4..e426264 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,6 +16,7 @@
 #include "thread_map.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
 
 int __perf_evsel__sample_size(u64 sample_type)
 {
@@ -204,15 +205,16 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group)
+			      struct thread_map *threads, bool group,
+			      struct xyarray *group_fds)
 {
 	int cpu, thread;
 	unsigned long flags = 0;
-	int pid = -1;
+	int pid = -1, err;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
-		return -1;
+		return -ENOMEM;
 
 	if (evsel->cgrp) {
 		flags = PERF_FLAG_PID_CGROUP;
@@ -220,7 +222,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		int group_fd = -1;
+		int group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
@@ -231,8 +233,10 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 								     pid,
 								     cpus->map[cpu],
 								     group_fd, flags);
-			if (FD(evsel, cpu, thread) < 0)
+			if (FD(evsel, cpu, thread) < 0) {
+				err = -errno;
 				goto out_close;
+			}
 
 			if (group && group_fd == -1)
 				group_fd = FD(evsel, cpu, thread);
@@ -249,7 +253,17 @@ out_close:
 		}
 		thread = threads->nr;
 	} while (--cpu >= 0);
-	return -1;
+	return err;
+}
+
+void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	if (evsel->fd == NULL)
+		return;
+
+	perf_evsel__close_fd(evsel, ncpus, nthreads);
+	perf_evsel__free_fd(evsel);
+	evsel->fd = NULL;
 }
 
 static struct {
@@ -269,7 +283,8 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group)
+		     struct thread_map *threads, bool group,
+		     struct xyarray *group_fd)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -279,19 +294,23 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group);
+	return __perf_evsel__open(evsel, cpus, threads, group, group_fd);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group)
+			     struct cpu_map *cpus, bool group,
+			     struct xyarray *group_fd)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group,
+				  group_fd);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group)
+				struct thread_map *threads, bool group,
+				struct xyarray *group_fd)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group,
+				  group_fd);
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index e9a3155..b1d15e6 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -82,11 +82,15 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group);
+			     struct cpu_map *cpus, bool group,
+			     struct xyarray *group_fds);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group);
+				struct thread_map *threads, bool group,
+				struct xyarray *group_fds);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group);
+		     struct thread_map *threads, bool group,
+		     struct xyarray *group_fds);
+void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 7624324..9dd47a4 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -623,7 +623,11 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 
 	evsel->attr.inherit = inherit;
-	if (perf_evsel__open(evsel, cpus, threads, group) < 0) {
+	/*
+	 * This will group just the fds for this single evsel, to group
+	 * multiple events, use evlist.open().
+	 */
+	if (perf_evsel__open(evsel, cpus, threads, group, NULL) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
@@ -814,6 +818,25 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	return Py_None;
 }
 
+static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
+				   PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+	int group = 0;
+	static char *kwlist[] = { "group", NULL };
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist, &group))
+		return NULL;
+
+	if (perf_evlist__open(evlist, group) < 0) {
+		PyErr_SetFromErrno(PyExc_OSError);
+		return NULL;
+	}
+
+	Py_INCREF(Py_None);
+	return Py_None;
+}
+
 static PyMethodDef pyrf_evlist__methods[] = {
 	{
 		.ml_name  = "mmap",
@@ -822,6 +845,12 @@ static PyMethodDef pyrf_evlist__methods[] = {
 		.ml_doc	  = PyDoc_STR("mmap the file descriptor table.")
 	},
 	{
+		.ml_name  = "open",
+		.ml_meth  = (PyCFunction)pyrf_evlist__open,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("open the file descriptors.")
+	},
+	{
 		.ml_name  = "poll",
 		.ml_meth  = (PyCFunction)pyrf_evlist__poll,
 		.ml_flags = METH_VARARGS | METH_KEYWORDS,
-- 
1.7.1

