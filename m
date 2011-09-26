Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1IZJMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1IZJM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:12:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, eric.dumazet@gmail.com, fweisbec@gmail.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        nhorman@tuxdriver.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 2/2] perf tools: Fix tracing info recording
Date: Mon, 26 Sep 2011 11:11:52 +0200
Message-Id: <1317028312-5156-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1317028312-5156-1-git-send-email-jolsa@redhat.com>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the way the tracing information is stored within record command.
The current implementation is causing inconsistency issues for pipe
output (described below), also following commands fail currently:

	perf script syscall-counts ls
	perf record -e syscalls:sys_exit_read ls | ./perf report -i -

The tracing information is part of the perf data file. It contains
several files from within the tracing debugfs and procs directories.

Beside some static header files, for each tracing event the format
file is added. The /proc/kallsyms file is also added.

The tracing data are stored with preceeding size. This is causing
dificulties for pipe output, since there's no way to tell debugfs/proc
file size before reading it. So, for pipe output, all the debugfs files
were read twice. Once to get the overall size and once to store the
content itself. This can cause problem in case any of these file
changed, within the storage time.

To fix this behaviour and ensure the integrity of the tracing data, we:
    - read debugfs/proc file into the temp file
    - get temp file size and dump it to the pipe
    - dump the temp file contents to the pipe

This change also fix current code, which did not distinguish regular
file and pipe and failed on seek call over pipe.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/header.c           |   50 +++++++++++++++++---
 tools/perf/util/trace-event-info.c |   90 ++++++++++++++++++++++++++---------
 tools/perf/util/trace-event.h      |   11 ++++-
 3 files changed, 118 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b6c1ad1..477c73b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -382,18 +382,33 @@ static int perf_header__adds_write(struct perf_header *header,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
+	/*
+	 * We reserve header space for each section, and
+	 * update/store it later once we know the section size.
+	 */
 	sec_start = header->data_offset + header->data_size;
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
 		struct perf_file_section *trace_sec;
+		struct tracing_data *tdata;
 
 		trace_sec = &feat_sec[idx++];
-
-		/* Write trace info */
 		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
-		read_tracing_data(fd, &evlist->entries);
-		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
+
+		/*
+		 * We work over the real file, so we can write data
+		 * directly, no temp file is needed.
+		 */
+		tdata = tracing_data_get(&evlist->entries, fd, false);
+		if (!tdata)
+			goto out_free;
+
+		/*
+		 * Update the section header information.
+		 */
+		trace_sec->size = tdata->size;
+		tracing_data_put(tdata);
 	}
 
 	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
@@ -1100,15 +1115,29 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
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
@@ -1116,7 +1145,12 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 
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
index cf8f89e..2e73e09 100644
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
 
@@ -421,6 +422,19 @@ get_tracepoints_path(struct list_head *pattrs)
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
@@ -432,39 +446,69 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
-int read_tracing_data(int fd, struct list_head *pattrs)
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp)
 {
-	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
-
-	/*
-	 * What? No tracepoints? No sense writing anything here, bail out.
-	 */
-	if (tps == NULL)
-		return -1;
+	struct tracepoint_path *tps;
+	struct tracing_data *tdata;
 
 	output_fd = fd;
 
+	tps = get_tracepoints_path(pattrs);
+	if (!tps)
+		return NULL;
+
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
+	} else
+		tdata->size = -lseek(output_fd, 0, SEEK_CUR);
+
 	tracing_data_header();
 	read_header_files();
 	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
 
-	return 0;
-}
+	tdata->size += lseek(output_fd, 0, SEEK_CUR);
 
-ssize_t read_tracing_data_size(int fd, struct list_head *pattrs)
-{
-	ssize_t size;
-	int err = 0;
+	/*
+	 * All tracing data are stored by now, we can restore
+	 * the default output file in case we used temp file.
+	 */
+	if (temp) {
+		close(output_fd);
+		output_fd = fd;
+	}
 
-	calc_data_size = 1;
-	err = read_tracing_data(fd, pattrs);
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	put_tracepoints_path(tps);
+	return tdata;
+}
 
-	if (err < 0)
-		return err;
+void tracing_data_put(struct tracing_data *tdata)
+{
+	if (tdata->temp) {
+		record_file(tdata->temp_file, 0);
+		unlink(tdata->temp_file);
+	}
 
-	return size;
+	free(tdata);
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index f674dda..92274b9 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -262,8 +262,15 @@ raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
 unsigned long long eval_flag(const char *flag);
 
-int read_tracing_data(int fd, struct list_head *pattrs);
-ssize_t read_tracing_data_size(int fd, struct list_head *pattrs);
+struct tracing_data {
+	ssize_t size;
+	bool temp;
+	char temp_file[50];
+};
+
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp);
+void tracing_data_put(struct tracing_data *tdata);
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
-- 
1.7.4

