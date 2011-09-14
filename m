Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1INN7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:59:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1INN7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:59:12 -0400
Date: Wed, 14 Sep 2011 15:58:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] perf tools: Fix tracing info recording
Message-ID: <20110914135840.GC2719@jolsa.brq.redhat.com>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822145210.GA8694@jolsa.brq.redhat.com>
 <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822160713.GA10134@jolsa.brq.redhat.com>
 <20110829132037.GB27261@ghostprotocols.net>
 <20110829134147.GD1918@jolsa.redhat.com>
 <20110829142547.GC27261@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829142547.GC27261@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:25:47AM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> > > 
> > > Hi Jiri, any news here?
> > > 
> > > I just stumbled in this bug while testing Neil's net_dropmonitor script
> > > :-\
> > 
> > well, I was thinking about taking files snapshot, so we dont read them
> > twice and omit the reading for size.. but it'll be probably bigger
> > change, I'll try to send out something by the end of the week

sry, I did not make it and then I was out for vacation..  sending now ;)

jirka


---
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

Fixing this behaviour by using temp file in case of pipe output. The
debugfs/proc files are being read only once, ensuring the integrity of
the tracing data.

Also changing the way the event files are searched by quering specified
event files directly, instead of walking the events directory.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/header.c           |   39 ++++-
 tools/perf/util/parse-events.h     |    1 +
 tools/perf/util/trace-event-info.c |  333 +++++++++++++++++++-----------------
 tools/perf/util/trace-event.h      |    7 +
 4 files changed, 215 insertions(+), 165 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b6c1ad1..6a9fd5b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -387,13 +387,21 @@ static int perf_header__adds_write(struct perf_header *header,
 
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
+		 * We work over the real file, we can write data
+		 * directly, not temp file is needed.
+		 */
+		tdata = tracing_data_get(&evlist->entries, fd, false);
+		if (!tdata)
+			goto out_free;
+
+		trace_sec->size = tracing_data_size(tdata);
+		tracing_data_put(tdata);
 	}
 
 	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
@@ -1100,15 +1108,25 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 				   struct perf_session *session __unused)
 {
 	union perf_event ev;
+	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err __used = 0;
 
+	/*
+	 * The fd descriptor is pipe, se we need to:
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
+	size = tracing_data_size(tdata);
 	aligned_size = ALIGN(size, sizeof(u64));
 	padding = aligned_size - size;
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
@@ -1116,7 +1134,12 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 
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
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2f8e375..1ea02ad 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -15,6 +15,7 @@ struct option;
 struct tracepoint_path {
 	char *system;
 	char *name;
+	bool done;
 	struct tracepoint_path *next;
 };
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3403f81..05b2e30 100644
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
 
@@ -238,138 +239,6 @@ static void read_header_files(void)
 	put_tracing_file(path);
 }
 
-static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
-{
-	while (tps) {
-		if (!strcmp(sys, tps->name))
-			return true;
-		tps = tps->next;
-	}
-
-	return false;
-}
-
-static void copy_event_system(const char *sys, struct tracepoint_path *tps)
-{
-	struct dirent *dent;
-	struct stat st;
-	char *format;
-	DIR *dir;
-	int count = 0;
-	int ret;
-
-	dir = opendir(sys);
-	if (!dir)
-		die("can't read directory '%s'", sys);
-
-	while ((dent = readdir(dir))) {
-		if (dent->d_type != DT_DIR ||
-		    strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0 ||
-		    !name_in_tp_list(dent->d_name, tps))
-			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
-		sprintf(format, "%s/%s/format", sys, dent->d_name);
-		ret = stat(format, &st);
-		free(format);
-		if (ret < 0)
-			continue;
-		count++;
-	}
-
-	write_or_die(&count, 4);
-
-	rewinddir(dir);
-	while ((dent = readdir(dir))) {
-		if (dent->d_type != DT_DIR ||
-		    strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0 ||
-		    !name_in_tp_list(dent->d_name, tps))
-			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
-		sprintf(format, "%s/%s/format", sys, dent->d_name);
-		ret = stat(format, &st);
-
-		if (ret >= 0)
-			record_file(format, 8);
-
-		free(format);
-	}
-	closedir(dir);
-}
-
-static void read_ftrace_files(struct tracepoint_path *tps)
-{
-	char *path;
-
-	path = get_tracing_file("events/ftrace");
-
-	copy_event_system(path, tps);
-
-	put_tracing_file(path);
-}
-
-static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
-{
-	while (tps) {
-		if (!strcmp(sys, tps->system))
-			return true;
-		tps = tps->next;
-	}
-
-	return false;
-}
-
-static void read_event_files(struct tracepoint_path *tps)
-{
-	struct dirent *dent;
-	struct stat st;
-	char *path;
-	char *sys;
-	DIR *dir;
-	int count = 0;
-	int ret;
-
-	path = get_tracing_file("events");
-
-	dir = opendir(path);
-	if (!dir)
-		die("can't read directory '%s'", path);
-
-	while ((dent = readdir(dir))) {
-		if (dent->d_type != DT_DIR ||
-		    strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0 ||
-		    strcmp(dent->d_name, "ftrace") == 0 ||
-		    !system_in_tp_list(dent->d_name, tps))
-			continue;
-		count++;
-	}
-
-	write_or_die(&count, 4);
-
-	rewinddir(dir);
-	while ((dent = readdir(dir))) {
-		if (dent->d_type != DT_DIR ||
-		    strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0 ||
-		    strcmp(dent->d_name, "ftrace") == 0 ||
-		    !system_in_tp_list(dent->d_name, tps))
-			continue;
-		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
-		sprintf(sys, "%s/%s", path, dent->d_name);
-		ret = stat(sys, &st);
-		if (ret >= 0) {
-			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
-			copy_event_system(sys, tps);
-		}
-		free(sys);
-	}
-
-	closedir(dir);
-	put_tracing_file(path);
-}
-
 static void read_proc_kallsyms(void)
 {
 	unsigned int size;
@@ -428,6 +297,19 @@ get_tracepoints_path(struct list_head *pattrs)
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
@@ -439,19 +321,114 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
-int read_tracing_data(int fd, struct list_head *pattrs)
+#define FILENAME_SIZE 50
+
+struct tracing_data {
+	ssize_t size;
+	bool temp;
+	char temp_file[FILENAME_SIZE];
+};
+
+ssize_t tracing_data_size(struct tracing_data *td)
 {
-	char buf[BUFSIZ];
-	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
+	return td->size;
+}
 
-	/*
-	 * What? No tracepoints? No sense writing anything here, bail out.
-	 */
-	if (tps == NULL)
-		return -1;
+static char *get_format_file(char *sys, char *name)
+{
+	char *file, *path;
 
-	output_fd = fd;
+	path = get_tracing_file("events");
+	if (!path)
+		return NULL;
+
+	file = malloc_or_die(strlen(path) + strlen(sys) +
+			     strlen(name) + strlen("format") + 10);
+
+	sprintf(file, "%s/%s/%s/format", path, sys, name);
+	return file;
+}
+
+static void put_format_file(char *file)
+{
+	free(file);
+}
+
+/*
+ * Walk tracepoint event objects and store them.
+ * Only those matching the sys parameter are stored
+ * and marked as done.
+ */
+static void read_event_files_system(struct tracepoint_path *tps,
+				    const char *sys)
+{
+	off_t count_pos;
+	u32 count = 0;
+
+	/* specified events count under single system */
+	count_pos = lseek(output_fd, 0, SEEK_CUR);
+	write_or_die(&count, 4);
+
+	while (tps) {
+		if ((!tps->done) &&
+		    (!strcmp(sys, tps->system))) {
+			char *file;
+
+			file = get_format_file(tps->system, tps->name);
+			if (file) {
+				record_file(file, 8);
+				count++;
+			}
+
+			put_format_file(file);
+			tps->done = 1;
+		}
+
+		tps = tps->next;
+	}
+
+	if (pwrite(output_fd, &count, 4, count_pos) < 0)
+		die("pwrite");
+}
+
+/*
+ * We have all needed tracepoint event files stored in
+ * the tracepoint_path objects.
+ *
+ * - first we store ftrace system events
+ * - then we walk all '!done' event objects
+ *   and process them
+ */
+static void read_event_files(struct tracepoint_path *tps)
+{
+	off_t count_pos;
+	u32 count = 0;
+
+	read_event_files_system(tps, "ftrace");
+
+	/* systems count */
+	count_pos = lseek(output_fd, 0, SEEK_CUR);
+	write_or_die(&count, 4);
+
+	while (tps) {
+		if (!tps->done) {
+			write_or_die(tps->system, strlen(tps->system) + 1);
+			read_event_files_system(tps, tps->system);
+			count++;
+		}
+
+		tps = tps->next;
+	}
 
+	if (pwrite(output_fd, &count, 4, count_pos) < 0)
+		die("write");
+}
+
+static void tracing_data_header(void)
+{
+	char buf[50];
+
+	/* just guessing this is someone's birthday.. ;) */
 	buf[0] = 23;
 	buf[1] = 8;
 	buf[2] = 68;
@@ -476,28 +453,70 @@ int read_tracing_data(int fd, struct list_head *pattrs)
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
 
+	output_fd = fd;
+
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
+		snprintf(tdata->temp_file, FILENAME_SIZE, "/tmp/perf-XXXXXX");
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
+	tracing_data_header();
 	read_header_files();
-	read_ftrace_files(tps);
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
index f674dda..2a23893 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -265,6 +265,13 @@ unsigned long long eval_flag(const char *flag);
 int read_tracing_data(int fd, struct list_head *pattrs);
 ssize_t read_tracing_data_size(int fd, struct list_head *pattrs);
 
+struct tracing_data;
+struct tracing_data *tracing_data_get(struct list_head *pattrs,
+				      int fd, bool temp);
+void tracing_data_put(struct tracing_data *tdata);
+ssize_t tracing_data_size(struct tracing_data *td);
+
+
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
-- 
1.7.4

