Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1IZJMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1IZJM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:12:28 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, eric.dumazet@gmail.com, fweisbec@gmail.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        nhorman@tuxdriver.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 1/2] perf tools: Collect tracing event data files directly
Date: Mon, 26 Sep 2011 11:11:51 +0200
Message-Id: <1317028312-5156-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1317028312-5156-1-git-send-email-jolsa@redhat.com>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the way the event files are searched by quering specified
event files directly, instead of walking the events directory.

Hopefully this way is more straightforward and faster.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.h     |    1 +
 tools/perf/util/trace-event-info.c |  231 +++++++++++++++--------------------
 2 files changed, 100 insertions(+), 132 deletions(-)

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
index 3403f81..cf8f89e 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -238,136 +238,98 @@ static void read_header_files(void)
 	put_tracing_file(path);
 }
 
-static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
+static char *get_format_file(char *sys, char *name)
 {
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
+	char *file, *path;
 
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
+	path = get_tracing_file("events");
+	if (!path)
+		return NULL;
 
-		if (ret >= 0)
-			record_file(format, 8);
+	/*
+	 * The '+ 5' is for '/' we add to the patch, plus NULL byte,
+	 * and one safety byte ;)
+	 */
+	file = malloc_or_die(strlen(path) + strlen(sys) +
+			     strlen(name) + strlen("format") + 5);
 
-		free(format);
-	}
-	closedir(dir);
+	sprintf(file, "%s/%s/%s/format", path, sys, name);
+	return file;
 }
 
-static void read_ftrace_files(struct tracepoint_path *tps)
+static void put_format_file(char *file)
 {
-	char *path;
-
-	path = get_tracing_file("events/ftrace");
-
-	copy_event_system(path, tps);
-
-	put_tracing_file(path);
+	free(file);
 }
 
-static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
+/*
+ * Walk tracepoint event objects and store them.
+ * Only those matching the sys parameter are stored
+ * and marked as done.
+ */
+static void read_event_files_system(struct tracepoint_path *tps,
+				    const char *sys)
 {
+	off_t count_pos;
+	u32 count = 0;
+
+	/* Place for number of events under single system. */
+	count_pos = lseek(output_fd, 0, SEEK_CUR);
+	write_or_die(&count, 4);
+
 	while (tps) {
-		if (!strcmp(sys, tps->system))
-			return true;
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
 		tps = tps->next;
 	}
 
-	return false;
+	if (pwrite(output_fd, &count, 4, count_pos) < 0)
+		die("pwrite");
 }
 
+/*
+ * We have all needed tracepoint event files stored in
+ * the tracepoint_path objects.
+ *
+ * - first we store ftrace system events
+ * - then we walk all '!done' event objects
+ *   and process them
+ */
 static void read_event_files(struct tracepoint_path *tps)
 {
-	struct dirent *dent;
-	struct stat st;
-	char *path;
-	char *sys;
-	DIR *dir;
-	int count = 0;
-	int ret;
-
-	path = get_tracing_file("events");
+	off_t count_pos;
+	u32 count = 0;
 
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
+	read_event_files_system(tps, "ftrace");
 
+	/* systems count */
+	count_pos = lseek(output_fd, 0, SEEK_CUR);
 	write_or_die(&count, 4);
 
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
+	while (tps) {
+		if (!tps->done) {
+			write_or_die(tps->system, strlen(tps->system) + 1);
+			read_event_files_system(tps, tps->system);
+			count++;
 		}
-		free(sys);
+
+		tps = tps->next;
 	}
 
-	closedir(dir);
-	put_tracing_file(path);
+	if (pwrite(output_fd, &count, 4, count_pos) < 0)
+		die("write");
 }
 
 static void read_proc_kallsyms(void)
@@ -387,6 +349,37 @@ static void read_proc_kallsyms(void)
 	record_file(path, 4);
 }
 
+static void tracing_data_header(void)
+{
+	char buf[50];
+
+	/* just guessing this is someone's birthday.. ;) */
+	buf[0] = 23;
+	buf[1] = 8;
+	buf[2] = 68;
+	memcpy(buf + 3, "tracing", 7);
+
+	write_or_die(buf, 10);
+
+	write_or_die(VERSION, strlen(VERSION) + 1);
+
+	/* save endian */
+	if (bigendian())
+		buf[0] = 1;
+	else
+		buf[0] = 0;
+
+	write_or_die(buf, 1);
+
+	/* save size of long */
+	buf[0] = sizeof(long);
+	write_or_die(buf, 1);
+
+	/* save page_size */
+	page_size = sysconf(_SC_PAGESIZE);
+	write_or_die(&page_size, 4);
+}
+
 static void read_ftrace_printk(void)
 {
 	unsigned int size;
@@ -441,7 +434,6 @@ bool have_tracepoints(struct list_head *pattrs)
 
 int read_tracing_data(int fd, struct list_head *pattrs)
 {
-	char buf[BUFSIZ];
 	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
 
 	/*
@@ -452,33 +444,8 @@ int read_tracing_data(int fd, struct list_head *pattrs)
 
 	output_fd = fd;
 
-	buf[0] = 23;
-	buf[1] = 8;
-	buf[2] = 68;
-	memcpy(buf + 3, "tracing", 7);
-
-	write_or_die(buf, 10);
-
-	write_or_die(VERSION, strlen(VERSION) + 1);
-
-	/* save endian */
-	if (bigendian())
-		buf[0] = 1;
-	else
-		buf[0] = 0;
-
-	write_or_die(buf, 1);
-
-	/* save size of long */
-	buf[0] = sizeof(long);
-	write_or_die(buf, 1);
-
-	/* save page_size */
-	page_size = sysconf(_SC_PAGESIZE);
-	write_or_die(&page_size, 4);
-
+	tracing_data_header();
 	read_header_files();
-	read_ftrace_files(tps);
 	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
-- 
1.7.4

