Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1CNTSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:18:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab1CNTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sO8FRv0idy/2sGqp1LFwx4JKzZ3G+/sX7cYeerOacyqrOsVkVb2+FtoWc+U1VdZR+3
         fJ5dBfiPDzxnE/DYr5QmCiHAC1Kyqbq9JmX87ttF0/v8U8lbG1IZZbxUaMs6GQWfWgX0
         2o79DHysGnMVbQLGXIBqR3lcY3rBqF1dnsMFk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [RFC PATCH 3/4] perf: Support for starter and stopper in tools
Date: Mon, 14 Mar 2011 20:18:02 +0100
Message-Id: <1300130283-10466-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --starter and --stopper options in perf record
and perf stat. These options must follow the event
that wants to be the target of the starter/stopper and
must be followed by the index of the desired event in the
command line, starting from 0.

For example in:

	perf record -e irq:softirq_entry -e irq:softirq_exit \
		 -e lock:lock_acquire -a

If we want to count/sample lock acquire event only outside softirqs,
we will take softirq_exit as the starter and softirq_entry as the
stopper. Thus the stopper is the event 0 and the starter is the
event 1, which leads us to the given command line:

	perf record -e irq:softirq_entry -e irq:softirq_exit \
		-e lock:lock_acquire --starter 1 --stopper 0 -a

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-record.c    |   18 +++++++++++-
 tools/perf/builtin-stat.c      |   20 ++++++++++++-
 tools/perf/util/evlist.c       |   12 +++-----
 tools/perf/util/evlist.h       |    4 +-
 tools/perf/util/evsel.c        |   53 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h        |   13 +++++++++
 tools/perf/util/parse-events.c |   58 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h |    2 +
 8 files changed, 167 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6febcc1..7cc690e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -323,12 +323,24 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__set_filters(evlist)) {
+	if (perf_evlist__for_each_evsel(evlist, perf_evsel__set_filter)) {
 		error("failed to set filter with %d (%s)\n", errno,
 			strerror(errno));
 		exit(-1);
 	}
 
+	if (perf_evlist__for_each_evsel(evlist, perf_evsel__set_starter)) {
+		error("failed to set starter with %d (%s)\n", errno,
+			strerror(errno));
+		exit(-1);
+	}
+
+	if (perf_evlist__for_each_evsel(evlist, perf_evsel__set_stopper)) {
+		error("failed to set stopper with %d (%s)\n", errno,
+			strerror(errno));
+		exit(-1);
+	}
+
 	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
@@ -729,6 +741,10 @@ const struct option record_options[] = {
 		     parse_events),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
+	OPT_CALLBACK(0, "starter", &evsel_list, "starter",
+		     "event starter", parse_starter),
+	OPT_CALLBACK(0, "stopper", &evsel_list, "stopper",
+		     "event stopper", parse_stopper),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "record events on existing process id"),
 	OPT_INTEGER('t', "tid", &target_tid,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e2109f9..ba89a4d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -333,8 +333,20 @@ static int run_perf_stat(int argc __used, const char **argv)
 		}
 	}
 
-	if (perf_evlist__set_filters(evsel_list)) {
-		error("failed to set filter with %d (%s)\n", errno,
+	if (perf_evlist__for_each_evsel(evsel_list, perf_evsel__set_filter)) {
+		pr_err("failed to set filter with %d (%s)\n", errno,
+			strerror(errno));
+		return -1;
+	}
+
+	if (perf_evlist__for_each_evsel(evsel_list, perf_evsel__set_starter)) {
+		pr_err("failed to set starter with %d (%s)\n", errno,
+			strerror(errno));
+		return -1;
+	}
+
+	if (perf_evlist__for_each_evsel(evsel_list, perf_evsel__set_stopper)) {
+		pr_err("failed to set stopper with %d (%s)\n", errno,
 			strerror(errno));
 		return -1;
 	}
@@ -642,6 +654,10 @@ static const struct option options[] = {
 		     parse_events),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
+	OPT_CALLBACK(0, "starter", &evsel_list, "starter",
+		     "event starter", parse_starter),
+	OPT_CALLBACK(0, "stopper", &evsel_list, "stopper",
+		     "event stopper", parse_stopper),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d852cef..b70eb92 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -365,27 +365,23 @@ void perf_evlist__delete_maps(struct perf_evlist *evlist)
 	evlist->threads = NULL;
 }
 
-int perf_evlist__set_filters(struct perf_evlist *evlist)
+int perf_evlist__for_each_evsel(struct perf_evlist *evlist,
+				int (*call)(struct perf_evsel *, int, int))
 {
 	const struct thread_map *threads = evlist->threads;
 	const struct cpu_map *cpus = evlist->cpus;
 	struct perf_evsel *evsel;
-	char *filter;
 	int thread;
 	int cpu;
 	int err;
-	int fd;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		filter = evsel->filter;
-		if (!filter)
-			continue;
 		for (cpu = 0; cpu < cpus->nr; cpu++) {
 			for (thread = 0; thread < threads->nr; thread++) {
-				fd = FD(evsel, cpu, thread);
-				err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
+				err = call(evsel, cpu, thread);
 				if (err)
 					return err;
+
 			}
 		}
 	}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8b1cb7a..1262e15 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -63,6 +63,6 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 			     pid_t target_tid, const char *cpu_list);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
-int perf_evlist__set_filters(struct perf_evlist *evlist);
-
+int perf_evlist__for_each_evsel(struct perf_evlist *evlist,
+				int (*call)(struct perf_evsel *, int, int));
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 662596a..7b2ba9f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -21,6 +21,8 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
 	INIT_LIST_HEAD(&evsel->node);
+	INIT_LIST_HEAD(&evsel->starter_list);
+	INIT_LIST_HEAD(&evsel->stopper_list);
 }
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
@@ -395,3 +397,54 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 
 	return 0;
 }
+
+int perf_evsel__set_filter(struct perf_evsel *evsel, int cpu,
+			   int thread)
+{
+	char *filter;
+	int fd;
+
+	filter = evsel->filter;
+	if (!filter)
+		return 0;
+
+	fd = FD(evsel, cpu, thread);
+
+	return ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
+}
+
+int perf_evsel__set_starter(struct perf_evsel *evsel, int cpu,
+			    int thread)
+{
+	struct perf_evsel *target;
+	int fd, fd_target;
+	int ret = 0;
+
+	list_for_each_entry(target, &evsel->starter_list, starter_entry) {
+		fd = FD(evsel, cpu, thread);
+		fd_target = FD(target, cpu, thread);
+		ret = ioctl(fd, PERF_EVENT_IOC_SET_STARTER, fd_target);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+int perf_evsel__set_stopper(struct perf_evsel *evsel, int cpu,
+			    int thread)
+{
+	struct perf_evsel *target;
+	int fd, fd_target;
+	int ret = 0;
+
+	list_for_each_entry(target, &evsel->stopper_list, stopper_entry) {
+		fd = FD(evsel, cpu, thread);
+		fd_target = FD(target, cpu, thread);
+		ret = ioctl(fd, PERF_EVENT_IOC_SET_STOPPER, fd_target);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6710ab5..e35d01f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -61,6 +61,10 @@ struct perf_evsel {
 		off_t		id_offset;
 	};
 	struct cgroup_sel	*cgrp;
+	struct list_head	starter_list;
+	struct list_head	starter_entry;
+	struct list_head	stopper_list;
+	struct list_head	stopper_entry;
 };
 
 struct cpu_map;
@@ -123,6 +127,15 @@ static inline int perf_evsel__read_on_cpu_scaled(struct perf_evsel *evsel,
 int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
 		       bool scale);
 
+int perf_evsel__set_filter(struct perf_evsel *evsel, int cpu,
+			   int thread);
+
+int perf_evsel__set_starter(struct perf_evsel *evsel, int cpu,
+			    int thread);
+
+int perf_evsel__set_stopper(struct perf_evsel *evsel, int cpu,
+			    int thread);
+
 /**
  * perf_evsel__read - Read the aggregate results on all CPUs
  *
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 54a7e26..7dd494f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -845,6 +845,64 @@ int parse_filter(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int parse_starter_stopper(const struct option *opt,
+				 const char *str, int starter)
+{
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	struct perf_evsel *last = NULL, *trigger = NULL;
+	char *end;
+	unsigned long i = 0;
+	int found = 0;
+	unsigned long idx;
+
+	if (evlist->nr_entries > 0)
+		last = list_entry(evlist->entries.prev, struct perf_evsel, node);
+
+	if (last == NULL) {
+		fprintf(stderr, "--starter/--stopper options should follow a -e tracepoint option\n");
+		return -1;
+	}
+
+	idx = strtoul(str, &end, 10);
+	if (str == end) {
+		//FIXME: Clarify that message, and fix above error handling
+		fprintf(stderr, "--starter/--stopper options should be followed by an event index\n");
+		return -1;
+	}
+
+	list_for_each_entry(trigger, &evlist->entries, node) {
+		if (i++ == idx) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		fprintf(stderr, "--starter/--stopper should be followed by a number "
+			"matching the nth event from the command line\n");
+		return -1;
+	}
+
+	if (starter)
+		list_add_tail(&last->starter_entry, &trigger->starter_list);
+	else
+		list_add_tail(&last->stopper_entry, &trigger->stopper_list);
+
+	return 0;
+}
+
+int parse_starter(const struct option *opt, const char *str,
+		 int unset __used)
+{
+	return parse_starter_stopper(opt, str, 1);
+}
+
+int parse_stopper(const struct option *opt, const char *str,
+		 int unset __used)
+{
+	return parse_starter_stopper(opt, str, 0);
+}
+
 static const char * const event_type_descriptors[] = {
 	"Hardware event",
 	"Software event",
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 212f88e..72d73b5 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -25,6 +25,8 @@ extern const char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
+extern int parse_starter(const struct option *opt, const char *str, int unset);
+extern int parse_stopper(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-- 
1.7.3.2

