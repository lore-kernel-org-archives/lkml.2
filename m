Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1JWTMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:12:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:45178 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1JWTMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:12:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Neil Horman <nhorman@tuxdriver.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf tools: Fix tracing info recording
Date: Sun, 23 Oct 2011 17:12:20 -0200
Message-Id: <1319397143-20301-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319397143-20301-1-git-send-email-acme@infradead.org>
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Fixing the way the tracing information is stored within record command.
The current implementation is causing issues for pipe output.

Following commands fail currently:
	perf script syscall-counts ls
	perf record -e syscalls:sys_exit_read ls | ./perf report -i -

The tracing information is part of the perf data file. It contains
several files from within the tracing debugfs and procs directories.

Beside some static header files, for each tracing event the format
file is added. The /proc/kallsyms file is also added.

The tracing data are stored with preceeding size. This is causing some
dificulties for pipe output, since there's no way to tell debugfs/proc
file size before reading it. So, for pipe output, all the debugfs files
were read twice. Once to get the overall size and once to store the
content itself. This can cause problem in case any of these file
changed, within the storage time.

To fix this behaviour and ensure the integrity of the tracing data, we:
    - read debugfs/proc file into the temp file
    - get temp file size and dump it to the pipe
    - dump the temp file contents to the pipe

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20111020135943.GD2092@jolsa.brq.redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c           |   27 +++++++-
 tools/perf/util/trace-event-info.c |  112 ++++++++++++++++++++++++++++--------
 tools/perf/util/trace-event.h      |   13 ++++-
 3 files changed, 123 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6a9c041..76c0b2c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2218,15 +2218,29 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 				   struct perf_session *session __unused)
 {
 	union perf_event ev;
+	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err __used = 0;
 
+	/*
+	 * We are going to store the size of the data followed
+	 * by the data contents. Since the fd descriptor is a pipe,
+	 * we cannot seek back to store the size of the data once
+	 * we know it. Instead we:
+	 *
+	 * - write the tracing data to the temp file
+	 * - get/write the data size to pipe
+	 * - write the tracing data from the temp file
+	 *   to the pipe
+	 */
+	tdata = tracing_data_get(&evlist->entries, fd, true);
+	if (!tdata)
+		return -1;
+
 	memset(&ev, 0, sizeof(ev));
 
 	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
-	size = read_tracing_data_size(fd, &evlist->entries);
-	if (size <= 0)
-		return size;
+	size = tdata->size;
 	aligned_size = ALIGN(size, sizeof(u64));
 	padding = aligned_size - size;
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
@@ -2234,7 +2248,12 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 
 	process(&ev, NULL, session);
 
-	err = read_tracing_data(fd, &evlist->entries);
+	/*
+	 * The put function will copy all the tracing data
+	 * stored in temp file to the pipe.
+	 */
+	tracing_data_put(tdata);
+
 	write_padded(fd, NULL, 0, padding);
 
 	return aligned_size;
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3403f81..2d530cf 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -196,7 +196,8 @@ static void record_file(const char *file, size_t hdr_sz)
 		die("Can't read '%s'", file);
 
 	/* put in zeros for file size, then fill true size later */
-	write_or_die(&size, hdr_sz);
+	if (hdr_sz)
+		write_or_die(&size, hdr_sz);
 
 	do {
 		r = read(fd, buf, BUFSIZ);
@@ -212,7 +213,7 @@ static void record_file(const char *file, size_t hdr_sz)
 	if (bigendian())
 		sizep += sizeof(u64) - hdr_sz;
 
-	if (pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
+	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
 		die("writing to %s", output_file);
 }
 
@@ -428,6 +429,19 @@ get_tracepoints_path(struct list_head *pattrs)
 	return nr_tracepoints > 0 ? path.next : NULL;
 }
 
+static void
+put_tracepoints_path(struct tracepoint_path *tps)
+{
+	while (tps) {
+		struct tracepoint_path *t = tps;
+
+		tps = tps->next;
+		free(t->name);
+		free(t->system);
+		free(t);
+	}
+}
+
 bool have_tracepoints(struct list_head *pattrs)
 {
 	struct perf_evsel *pos;
@@ -439,19 +453,11 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
-int read_tracing_data(int fd, struct list_head *pattrs)
+static void tracing_data_header(void)
 {
-	char buf[BUFSIZ];
-	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
-
-	/*
-	 * What? No tracepoints? No sense writing anything here, bail out.
-	 */
-	if (tps == NULL)
-		return -1;
-
-	output_fd = fd;
+	char buf[20];
 
+	/* just guessing this is someone's birthday.. ;) */
 	buf[0] = 23;
 	buf[1] = 8;
 	buf[2] = 68;
@@ -476,28 +482,86 @@ int read_tracing_data(int fd, struct list_head *pattrs)
 	/* save page_size */
 	page_size = sysconf(_SC_PAGESIZE);
 	write_or_die(&page_size, 4);
+}
+
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp)
+{
+	struct tracepoint_path *tps;
+	struct tracing_data *tdata;
+
+	output_fd = fd;
+
+	tps = get_tracepoints_path(pattrs);
+	if (!tps)
+		return NULL;
 
+	tdata = malloc_or_die(sizeof(*tdata));
+	tdata->temp = temp;
+	tdata->size = 0;
+
+	if (temp) {
+		int temp_fd;
+
+		snprintf(tdata->temp_file, sizeof(tdata->temp_file),
+			 "/tmp/perf-XXXXXX");
+		if (!mkstemp(tdata->temp_file))
+			die("Can't make temp file");
+
+		temp_fd = open(tdata->temp_file, O_RDWR);
+		if (temp_fd < 0)
+			die("Can't read '%s'", tdata->temp_file);
+
+		/*
+		 * Set the temp file the default output, so all the
+		 * tracing data are stored into it.
+		 */
+		output_fd = temp_fd;
+	}
+
+	tracing_data_header();
 	read_header_files();
 	read_ftrace_files(tps);
 	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
 
-	return 0;
+	/*
+	 * All tracing data are stored by now, we can restore
+	 * the default output file in case we used temp file.
+	 */
+	if (temp) {
+		tdata->size = lseek(output_fd, 0, SEEK_CUR);
+		close(output_fd);
+		output_fd = fd;
+	}
+
+	put_tracepoints_path(tps);
+	return tdata;
 }
 
-ssize_t read_tracing_data_size(int fd, struct list_head *pattrs)
+void tracing_data_put(struct tracing_data *tdata)
 {
-	ssize_t size;
-	int err = 0;
+	if (tdata->temp) {
+		record_file(tdata->temp_file, 0);
+		unlink(tdata->temp_file);
+	}
 
-	calc_data_size = 1;
-	err = read_tracing_data(fd, pattrs);
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	free(tdata);
+}
 
-	if (err < 0)
-		return err;
+int read_tracing_data(int fd, struct list_head *pattrs)
+{
+	struct tracing_data *tdata;
 
-	return size;
+	/*
+	 * We work over the real file, so we can write data
+	 * directly, no temp file is needed.
+	 */
+	tdata = tracing_data_get(pattrs, fd, false);
+	if (!tdata)
+		return -ENOMEM;
+
+	tracing_data_put(tdata);
+	return 0;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index f674dda..a841008 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -263,7 +263,18 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct list_head *pattrs);
-ssize_t read_tracing_data_size(int fd, struct list_head *pattrs);
+
+struct tracing_data {
+	/* size is only valid if temp is 'true' */
+	ssize_t size;
+	bool temp;
+	char temp_file[50];
+};
+
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp);
+void tracing_data_put(struct tracing_data *tdata);
+
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
-- 
1.6.2.5

