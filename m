Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1AOPle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:41:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52765 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1AOPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 06/16] perf record: Use perf_evsel__open
Date: Sat, 15 Jan 2011 13:40:35 -0200
Message-Id: <1295106045-31192-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now its time to factor out the mmap handling bits into the perf_evsel
class.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |  233 +++++++++++++++++++++----------------------
 1 files changed, 113 insertions(+), 120 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2a6303d..4bba4f8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -72,8 +72,6 @@ static struct perf_evlist	*evsel_list;
 static long			samples				=      0;
 static u64			bytes_written			=      0;
 
-static int			nr_cpu				=      0;
-
 static int			file_new			=      1;
 static off_t			post_processing_offset;
 
@@ -208,8 +206,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static int group_fd;
-
 static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int nr)
 {
 	struct perf_header_attr *h_attr;
@@ -234,7 +230,6 @@ static void create_counter(struct perf_evlist *evlist,
 	char *filter = evsel->filter;
 	struct perf_event_attr *attr = &evsel->attr;
 	struct perf_header_attr *h_attr;
-	int track = !evsel->idx; /* only the first counter needs these */
 	int thread_index;
 	int ret;
 	struct {
@@ -243,19 +238,77 @@ static void create_counter(struct perf_evlist *evlist,
 		u64 time_running;
 		u64 id;
 	} read_data;
-	/*
- 	 * Check if parse_single_tracepoint_event has already asked for
- 	 * PERF_SAMPLE_TIME.
- 	 *
-	 * XXX this is kludgy but short term fix for problems introduced by
-	 * eac23d1c that broke 'perf script' by having different sample_types
-	 * when using multiple tracepoint events when we use a perf binary
-	 * that tries to use sample_id_all on an older kernel.
- 	 *
- 	 * We need to move counter creation to perf_session, support
- 	 * different sample_types, etc.
- 	 */
-	bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
+
+	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
+		h_attr = get_header_attr(attr, evsel->idx);
+		if (h_attr == NULL)
+			die("nomem\n");
+
+		if (!file_new) {
+			if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
+				fprintf(stderr, "incompatible append\n");
+				exit(-1);
+			}
+		}
+
+		if (read(FD(evsel, cpu, thread_index), &read_data, sizeof(read_data)) == -1) {
+			perror("Unable to read perf file descriptor");
+			exit(-1);
+		}
+
+		if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
+			pr_warning("Not enough memory to add id\n");
+			exit(-1);
+		}
+
+		assert(FD(evsel, cpu, thread_index) >= 0);
+		fcntl(FD(evsel, cpu, thread_index), F_SETFL, O_NONBLOCK);
+
+		if (evsel->idx || thread_index) {
+			struct perf_evsel *first;
+			first = list_entry(evlist->entries.next, struct perf_evsel, node);
+			ret = ioctl(FD(evsel, cpu, thread_index),
+				    PERF_EVENT_IOC_SET_OUTPUT,
+				    FD(first, cpu, 0));
+			if (ret) {
+				error("failed to set output: %d (%s)\n", errno,
+						strerror(errno));
+				exit(-1);
+			}
+		} else {
+			mmap_array[cpu].prev = 0;
+			mmap_array[cpu].mask = mmap_pages*page_size - 1;
+			mmap_array[cpu].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ | PROT_WRITE, MAP_SHARED, FD(evsel, cpu, thread_index), 0);
+			if (mmap_array[cpu].base == MAP_FAILED) {
+				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+				exit(-1);
+			}
+
+			evlist->pollfd[evlist->nr_fds].fd = FD(evsel, cpu, thread_index);
+			evlist->pollfd[evlist->nr_fds].events = POLLIN;
+			evlist->nr_fds++;
+		}
+
+		if (filter != NULL) {
+			ret = ioctl(FD(evsel, cpu, thread_index),
+				    PERF_EVENT_IOC_SET_FILTER, filter);
+			if (ret) {
+				error("failed to set filter with %d (%s)\n", errno,
+						strerror(errno));
+				exit(-1);
+			}
+		}
+	}
+
+	if (!sample_type)
+		sample_type = attr->sample_type;
+}
+
+static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+	int track = !evsel->idx; /* only the first counter needs these */
 
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -315,19 +368,39 @@ static void create_counter(struct perf_evlist *evlist,
 
 	attr->mmap		= track;
 	attr->comm		= track;
-	attr->inherit		= !no_inherit;
+
 	if (target_pid == -1 && target_tid == -1 && !system_wide) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
-retry_sample_id:
-	attr->sample_id_all = sample_id_all_avail ? 1 : 0;
+}
 
-	for (thread_index = 0; thread_index < threads->nr; thread_index++) {
-try_again:
-		FD(evsel, nr_cpu, thread_index) = sys_perf_event_open(attr, threads->map[thread_index], cpu, group_fd, 0);
+static void open_counters(struct perf_evlist *evlist)
+{
+	struct perf_evsel *pos;
+	int cpu;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct perf_event_attr *attr = &pos->attr;
+		/*
+		 * Check if parse_single_tracepoint_event has already asked for
+		 * PERF_SAMPLE_TIME.
+		 *
+		 * XXX this is kludgy but short term fix for problems introduced by
+		 * eac23d1c that broke 'perf script' by having different sample_types
+		 * when using multiple tracepoint events when we use a perf binary
+		 * that tries to use sample_id_all on an older kernel.
+		 *
+		 * We need to move counter creation to perf_session, support
+		 * different sample_types, etc.
+		 */
+		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
-		if (FD(evsel, nr_cpu, thread_index) < 0) {
+		config_attr(pos, evlist);
+retry_sample_id:
+		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
+try_again:
+		if (perf_evsel__open(pos, cpus, threads, group, !no_inherit) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -364,7 +437,7 @@ try_again:
 			}
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
-			      FD(evsel, nr_cpu, thread_index), strerror(err));
+			      err, strerror(err));
 
 #if defined(__i386__) || defined(__x86_64__)
 			if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
@@ -375,90 +448,13 @@ try_again:
 #endif
 
 			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-			exit(-1);
-		}
-
-		h_attr = get_header_attr(attr, evsel->idx);
-		if (h_attr == NULL)
-			die("nomem\n");
-
-		if (!file_new) {
-			if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
-				fprintf(stderr, "incompatible append\n");
-				exit(-1);
-			}
-		}
-
-		if (read(FD(evsel, nr_cpu, thread_index), &read_data, sizeof(read_data)) == -1) {
-			perror("Unable to read perf file descriptor");
-			exit(-1);
-		}
-
-		if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
-			pr_warning("Not enough memory to add id\n");
-			exit(-1);
-		}
-
-		assert(FD(evsel, nr_cpu, thread_index) >= 0);
-		fcntl(FD(evsel, nr_cpu, thread_index), F_SETFL, O_NONBLOCK);
-
-		/*
-		 * First counter acts as the group leader:
-		 */
-		if (group && group_fd == -1)
-			group_fd = FD(evsel, nr_cpu, thread_index);
-
-		if (evsel->idx || thread_index) {
-			struct perf_evsel *first;
-			first = list_entry(evlist->entries.next, struct perf_evsel, node);
-			ret = ioctl(FD(evsel, nr_cpu, thread_index),
-				    PERF_EVENT_IOC_SET_OUTPUT,
-				    FD(first, nr_cpu, 0));
-			if (ret) {
-				error("failed to set output: %d (%s)\n", errno,
-						strerror(errno));
-				exit(-1);
-			}
-		} else {
-			mmap_array[nr_cpu].prev = 0;
-			mmap_array[nr_cpu].mask = mmap_pages*page_size - 1;
-			mmap_array[nr_cpu].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ | PROT_WRITE, MAP_SHARED, FD(evsel, nr_cpu, thread_index), 0);
-			if (mmap_array[nr_cpu].base == MAP_FAILED) {
-				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-				exit(-1);
-			}
-
-			evlist->pollfd[evlist->nr_fds].fd = FD(evsel, nr_cpu, thread_index);
-			evlist->pollfd[evlist->nr_fds].events = POLLIN;
-			evlist->nr_fds++;
-		}
-
-		if (filter != NULL) {
-			ret = ioctl(FD(evsel, nr_cpu, thread_index),
-				    PERF_EVENT_IOC_SET_FILTER, filter);
-			if (ret) {
-				error("failed to set filter with %d (%s)\n", errno,
-						strerror(errno));
-				exit(-1);
-			}
 		}
 	}
 
-	if (!sample_type)
-		sample_type = attr->sample_type;
-}
-
-static void open_counters(struct perf_evlist *evlist, int cpu)
-{
-	struct perf_evsel *pos;
-
-	group_fd = -1;
-
-	list_for_each_entry(pos, &evlist->entries, node)
-		create_counter(evlist, pos, cpu);
-
-	nr_cpu++;
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		list_for_each_entry(pos, &evlist->entries, node)
+			create_counter(evlist, pos, cpu);
+	}
 }
 
 static int process_buildids(void)
@@ -533,7 +529,7 @@ static void mmap_read_all(void)
 {
 	int i;
 
-	for (i = 0; i < nr_cpu; i++) {
+	for (i = 0; i < cpus->nr; i++) {
 		if (mmap_array[i].base)
 			mmap_read(&mmap_array[i]);
 	}
@@ -673,12 +669,7 @@ static int __cmd_record(int argc, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	if (!system_wide && no_inherit && !cpu_list) {
-		open_counters(evsel_list, -1);
-	} else {
-		for (i = 0; i < cpus->nr; i++)
-			open_counters(evsel_list, cpus->map[i]);
-	}
+	open_counters(evsel_list);
 
 	perf_session__set_sample_type(session, sample_type);
 
@@ -795,7 +786,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (done) {
-			for (i = 0; i < nr_cpu; i++) {
+			for (i = 0; i < cpus->nr; i++) {
 				struct perf_evsel *pos;
 
 				list_for_each_entry(pos, &evsel_list->entries, node) {
@@ -933,11 +924,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(record_usage, record_options);
 	}
 
-	cpus = cpu_map__new(cpu_list);
-	if (cpus == NULL) {
-		perror("failed to parse CPUs map");
-		return -1;
-	}
+	if (target_tid != -1)
+		cpus = cpu_map__dummy_new();
+	else
+		cpus = cpu_map__new(cpu_list);
+
+	if (cpus == NULL)
+		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
-- 
1.6.2.5

