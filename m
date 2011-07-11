Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab1GKNXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507Ab1GKNXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:23:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 4/4] perf, ftrace: Add ftrace option for perf stat command
Date: Mon, 11 Jul 2011 15:22:56 +0200
Message-Id: <1310390576-8289-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ftrace option to specify the ftrace filter for last/current event.
The value format is same as for the set_ftrace_filter tracing file.

This could be used only for ftrace:function (TRACE_FN) tracepoint event
like:

 # ./perf stat -e ftrace:function --filter "ip == sys_open" \
   --ftrace "sys_open sys_read" sleep 1

  Performance counter stats for 'sleep 1':

                 3 ftrace:function                                             

       1.001460132 seconds time elapsed

---
 tools/perf/builtin-stat.c      |    2 ++
 tools/perf/util/evlist.c       |   26 ++++++++++++++++++++++----
 tools/perf/util/evlist.h       |    2 ++
 tools/perf/util/evsel.h        |    1 +
 tools/perf/util/parse-events.c |   37 +++++++++++++++++++++++++++++++++----
 tools/perf/util/parse-events.h |    1 +
 6 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1d08c80..77a257d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1035,6 +1035,8 @@ static const struct option options[] = {
 		     parse_events),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
+	OPT_CALLBACK(0, "ftrace", &evsel_list, "ftrace",
+		     "ftrace filter", parse_ftrace),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b021ea9..7627266 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -427,25 +427,43 @@ void perf_evlist__delete_maps(struct perf_evlist *evlist)
 	evlist->threads = NULL;
 }
 
+static int set_filter_fd(int fd, char *filter, char *ftrace)
+{
+	int err;
+
+	if (filter) {
+		err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
+		if (err)
+			return err;
+	}
+	if (ftrace) {
+		err = ioctl(fd, PERF_EVENT_IOC_SET_FTRACE, ftrace);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 int perf_evlist__set_filters(struct perf_evlist *evlist)
 {
 	const struct thread_map *threads = evlist->threads;
 	const struct cpu_map *cpus = evlist->cpus;
 	struct perf_evsel *evsel;
 	char *filter;
+	char *ftrace;
 	int thread;
 	int cpu;
 	int err;
-	int fd;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		filter = evsel->filter;
-		if (!filter)
+		ftrace = evsel->ftrace;
+		if (!filter && !ftrace)
 			continue;
 		for (cpu = 0; cpu < cpus->nr; cpu++) {
 			for (thread = 0; thread < threads->nr; thread++) {
-				fd = FD(evsel, cpu, thread);
-				err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
+				err = set_filter_fd(FD(evsel, cpu, thread),
+						  filter, ftrace);
 				if (err)
 					return err;
 			}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b2b8623..25ccdf8 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -9,6 +9,8 @@ struct pollfd;
 struct thread_map;
 struct cpu_map;
 
+#define PERF_EVENT_IOC_SET_FTRACE       _IOW('$', 7, char *)
+
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index e9a3155..60d949c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -48,6 +48,7 @@ struct perf_evsel {
 	struct list_head	node;
 	struct perf_event_attr	attr;
 	char			*filter;
+	char			*ftrace;
 	struct xyarray		*fd;
 	struct xyarray		*sample_id;
 	u64			*id;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..dc58b0e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -863,8 +863,7 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	return 0;
 }
 
-int parse_filter(const struct option *opt, const char *str,
-		 int unset __used)
+static struct perf_evsel *get_last_evsel(const struct option *opt)
 {
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_evsel *last = NULL;
@@ -874,10 +873,22 @@ int parse_filter(const struct option *opt, const char *str,
 
 	if (last == NULL || last->attr.type != PERF_TYPE_TRACEPOINT) {
 		fprintf(stderr,
-			"-F option should follow a -e tracepoint option\n");
-		return -1;
+			"filter/ftrace options should follow a -e tracepoint option\n");
+		return NULL;
 	}
 
+	return last;
+}
+
+int parse_filter(const struct option *opt, const char *str,
+		 int unset __used)
+{
+	struct perf_evsel *last = NULL;
+
+	last = get_last_evsel(opt);
+	if (!last)
+		return -1;
+
 	last->filter = strdup(str);
 	if (last->filter == NULL) {
 		fprintf(stderr, "not enough memory to hold filter string\n");
@@ -887,6 +898,24 @@ int parse_filter(const struct option *opt, const char *str,
 	return 0;
 }
 
+int parse_ftrace(const struct option *opt, const char *str,
+		 int unset __used)
+{
+	struct perf_evsel *last = NULL;
+
+	last = get_last_evsel(opt);
+	if (!last)
+		return -1;
+
+	last->ftrace = strdup(str);
+	if (last->ftrace == NULL) {
+		fprintf(stderr, "not enough memory to hold ftrace string\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 static const char * const event_type_descriptors[] = {
 	"Hardware event",
 	"Software event",
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 746d3fc..9933649 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -26,6 +26,7 @@ extern const char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
+extern int parse_ftrace(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-- 
1.7.1

