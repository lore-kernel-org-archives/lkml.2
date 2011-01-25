Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1AYR2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:28:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1AYRWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 02/29] perf evlist: Adopt the pollfd array
Date: Tue, 25 Jan 2011 15:21:25 -0200
Message-Id: <1295976112-2796-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Allocating just the space needed for nr_cpus * nr_threads * nr_evsels,
not the MAX_NR_CPUS and counters.

LKML-Reference: <new-submission>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   20 +++++++-------------
 tools/perf/builtin-top.c    |   26 +++++++++++---------------
 tools/perf/util/evlist.c    |    9 +++++++++
 tools/perf/util/evlist.h    |    6 ++++++
 4 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 252ace8..1614d89 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -72,9 +72,6 @@ static struct perf_evlist	*evsel_list;
 static long			samples				=      0;
 static u64			bytes_written			=      0;
 
-static struct pollfd		*event_array;
-
-static int			nr_poll				=      0;
 static int			nr_cpu				=      0;
 
 static int			file_new			=      1;
@@ -432,9 +429,9 @@ try_again:
 				exit(-1);
 			}
 
-			event_array[nr_poll].fd = FD(evsel, nr_cpu, thread_index);
-			event_array[nr_poll].events = POLLIN;
-			nr_poll++;
+			evlist->pollfd[evlist->nr_fds].fd = FD(evsel, nr_cpu, thread_index);
+			evlist->pollfd[evlist->nr_fds].events = POLLIN;
+			evlist->nr_fds++;
 		}
 
 		if (filter != NULL) {
@@ -793,7 +790,7 @@ static int __cmd_record(int argc, const char **argv)
 		if (hits == samples) {
 			if (done)
 				break;
-			err = poll(event_array, nr_poll, -1);
+			err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
 			waking++;
 		}
 
@@ -948,9 +945,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		if (perf_header__push_event(pos->attr.config, event_name(pos)))
 			goto out_free_fd;
 	}
-	event_array = malloc((sizeof(struct pollfd) * MAX_NR_CPUS *
-			      MAX_COUNTERS * threads->nr));
-	if (!event_array)
+
+	if (perf_evlist__alloc_pollfd(evsel_list, cpus->nr, threads->nr) < 0)
 		goto out_free_fd;
 
 	if (user_interval != ULLONG_MAX)
@@ -968,13 +964,11 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	} else {
 		fprintf(stderr, "frequency and count are zero, aborting\n");
 		err = -EINVAL;
-		goto out_free_event_array;
+		goto out_free_fd;
 	}
 
 	err = __cmd_record(argc, argv);
 
-out_free_event_array:
-	free(event_array);
 out_free_fd:
 	thread_map__delete(threads);
 	threads = NULL;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 216b62e..1bc4652 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1193,8 +1193,6 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 	md->prev = old;
 }
 
-static struct pollfd *event_array;
-
 static void perf_session__mmap_read(struct perf_session *self)
 {
 	struct perf_evsel *counter;
@@ -1212,10 +1210,10 @@ static void perf_session__mmap_read(struct perf_session *self)
 	}
 }
 
-int nr_poll;
 int group_fd;
 
-static void start_counter(int i, struct perf_evsel *evsel)
+static void start_counter(int i, struct perf_evlist *evlist,
+			  struct perf_evsel *evsel)
 {
 	struct xyarray *mmap_array = evsel->priv;
 	struct mmap_data *mm;
@@ -1281,9 +1279,9 @@ try_again:
 		if (group && group_fd == -1)
 			group_fd = FD(evsel, i, thread_index);
 
-		event_array[nr_poll].fd = FD(evsel, i, thread_index);
-		event_array[nr_poll].events = POLLIN;
-		nr_poll++;
+		evlist->pollfd[evlist->nr_fds].fd = FD(evsel, i, thread_index);
+		evlist->pollfd[evlist->nr_fds].events = POLLIN;
+		evlist->nr_fds++;
 
 		mm = xyarray__entry(mmap_array, i, thread_index);
 		mm->prev = 0;
@@ -1316,11 +1314,11 @@ static int __cmd_top(void)
 	for (i = 0; i < cpus->nr; i++) {
 		group_fd = -1;
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			start_counter(i, counter);
+			start_counter(i, evsel_list, counter);
 	}
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(&event_array[0], nr_poll, 100);
+	poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
 
 	perf_session__mmap_read(session);
 
@@ -1345,7 +1343,7 @@ static int __cmd_top(void)
 		perf_session__mmap_read(session);
 
 		if (hits == samples)
-			ret = poll(event_array, nr_poll, 100);
+			ret = poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
 	}
 
 	return 0;
@@ -1426,11 +1424,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(top_usage, options);
 	}
 
-	event_array = malloc((sizeof(struct pollfd) *
-			      MAX_NR_CPUS * MAX_COUNTERS * threads->nr));
-	if (!event_array)
-		return -ENOMEM;
-
 	/* CPU and PID are mutually exclusive */
 	if (target_tid > 0 && cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
@@ -1480,6 +1473,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
+	if (perf_evlist__alloc_pollfd(evsel_list, cpus->nr, threads->nr) < 0)
+		goto out_free_fd;
+
 	sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7b4faec..2abf949 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1,3 +1,4 @@
+#include <poll.h>
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
@@ -28,6 +29,7 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
 	perf_evlist__purge(evlist);
+	free(evlist->pollfd);
 	free(evlist);
 }
 
@@ -51,3 +53,10 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	perf_evlist__add(evlist, evsel);
 	return 0;
 }
+
+int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthreads)
+{
+	int nfds = ncpus * nthreads * evlist->nr_entries;
+	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
+	return evlist->pollfd != NULL ? 0 : -ENOMEM;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 48db91a..a7d7e12 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -3,9 +3,13 @@
 
 #include <linux/list.h>
 
+struct pollfd;
+
 struct perf_evlist {
 	struct list_head entries;
 	int		 nr_entries;
+	int		 nr_fds;
+	struct pollfd	 *pollfd;
 };
 
 struct perf_evsel;
@@ -16,4 +20,6 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 
+int perf_evlist__alloc_pollfd(struct perf_evlist *evlist, int ncpus, int nthreads);
+
 #endif /* __PERF_EVLIST_H */
-- 
1.6.2.5

