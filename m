Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1DWQal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:30:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40245 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1DWQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:32 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 17/18] perf: Export tracepoint_id_to_path
Date: Sat, 23 Apr 2011 18:28:19 +0200
Message-Id: <1303576100-425-18-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is needed when linking against libtrace.a so move it to
<lib/trace/trace-event-info.c> and adjust all headers accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/trace/event-info.c    |  120 +++++++++++++++++++++++++++++++++------
 tools/lib/trace/trace-event.h   |   19 ++++++
 tools/perf/util/parse-events.c  |  104 +--------------------------------
 tools/perf/util/parse-events.h  |    1 -
 tools/perf/util/parse-options.h |    1 +
 5 files changed, 126 insertions(+), 119 deletions(-)

diff --git a/tools/lib/trace/event-info.c b/tools/lib/trace/event-info.c
index 9da00af..fb71c34 100644
--- a/tools/lib/trace/event-info.c
+++ b/tools/lib/trace/event-info.c
@@ -18,7 +18,6 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#define _GNU_SOURCE
 #include <dirent.h>
 #include <mntent.h>
 #include <stdio.h>
@@ -26,6 +25,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <sys/types.h>
+#include <sys/param.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <pthread.h>
@@ -40,6 +40,7 @@
 #include "../../perf/perf.h"
 #include "trace-event.h"
 #include <lk/debugfs.h>
+#include <lk/util.h>
 #include <perf/evsel.h>
 
 #define VERSION "0.5"
@@ -58,6 +59,7 @@
 unsigned int page_size;
 
 static const char *output_file = "trace.info";
+static const char *dfs_path;
 static int output_fd;
 
 struct event_list {
@@ -72,7 +74,7 @@ struct events {
 	char *name;
 };
 
-static void die(const char *fmt, ...)
+static void t_die(const char *fmt, ...)
 {
 	va_list ap;
 	int ret = errno;
@@ -97,7 +99,7 @@ void *malloc_or_die(unsigned int size)
 
 	data = malloc(size);
 	if (!data)
-		die("malloc");
+		t_die("malloc");
 	return data;
 }
 
@@ -106,7 +108,7 @@ static const char *find_debugfs(void)
 	const char *path = debugfs_mount(NULL);
 
 	if (!path)
-		die("Your kernel not support debugfs filesystem");
+		t_die("Your kernel not support debugfs filesystem");
 
 	return path;
 }
@@ -167,7 +169,7 @@ static ssize_t write_or_die(const void *buf, size_t len)
 
 	ret = write(output_fd, buf, len);
 	if (ret < 0)
-		die("writing to '%s'", output_file);
+		t_die("writing to '%s'", output_file);
 
 	return ret;
 }
@@ -205,7 +207,7 @@ static unsigned long long copy_file(const char *file)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
-		die("Can't read '%s'", file);
+		t_die("Can't read '%s'", file);
 	size = copy_file_fd(fd);
 	close(fd);
 
@@ -236,7 +238,7 @@ unsigned long get_filesize(const char *file)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
-		die("Can't read '%s'", file);
+		t_die("Can't read '%s'", file);
 	size = get_size_fd(fd);
 	close(fd);
 
@@ -252,7 +254,7 @@ static void read_header_files(void)
 	path = get_tracing_file("events/header_page");
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
-		die("can't read '%s'", path);
+		t_die("can't read '%s'", path);
 
 	/* unfortunately, you can not stat debugfs files for size */
 	size = get_size_fd(fd);
@@ -263,14 +265,14 @@ static void read_header_files(void)
 	close(fd);
 
 	if (size != check_size)
-		die("wrong size for '%s' size=%lld read=%lld",
+		t_die("wrong size for '%s' size=%lld read=%lld",
 		    path, size, check_size);
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
-		die("can't read '%s'", path);
+		t_die("can't read '%s'", path);
 
 	size = get_size_fd(fd);
 
@@ -278,7 +280,7 @@ static void read_header_files(void)
 	write_or_die(&size, 8);
 	check_size = copy_file_fd(fd);
 	if (size != check_size)
-		die("wrong size for '%s'", path);
+		t_die("wrong size for '%s'", path);
 	put_tracing_file(path);
 	close(fd);
 }
@@ -306,7 +308,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 	dir = opendir(sys);
 	if (!dir)
-		die("can't read directory '%s'", sys);
+		t_die("can't read directory '%s'", sys);
 
 	while ((dent = readdir(dir))) {
 		if (dent->d_type != DT_DIR ||
@@ -342,7 +344,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 			write_or_die(&size, 8);
 			check_size = copy_file(format);
 			if (size != check_size)
-				die("error in size of file '%s'", format);
+				t_die("error in size of file '%s'", format);
 		}
 
 		free(format);
@@ -386,7 +388,7 @@ static void read_event_files(struct tracepoint_path *tps)
 
 	dir = opendir(path);
 	if (!dir)
-		die("can't read directory '%s'", path);
+		t_die("can't read directory '%s'", path);
 
 	while ((dent = readdir(dir))) {
 		if (dent->d_type != DT_DIR ||
@@ -440,7 +442,7 @@ static void read_proc_kallsyms(void)
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
-		die("error in size of file '%s'", path);
+		t_die("error in size of file '%s'", path);
 
 }
 
@@ -463,11 +465,95 @@ static void read_ftrace_printk(void)
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
-		die("error in size of file '%s'", path);
+		t_die("error in size of file '%s'", path);
 out:
 	put_tracing_file(path);
 }
 
+int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
+{
+	char evt_path[MAXPATHLEN];
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", dfs_path,
+			sys_dir->d_name, evt_dir->d_name);
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return -EINVAL;
+	close(fd);
+
+	return 0;
+}
+
+struct tracepoint_path *tracepoint_id_to_path(u64 config)
+{
+	struct tracepoint_path *path = NULL;
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	char id_buf[4];
+	int fd;
+	u64 id;
+	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
+
+	dfs_path = debugfs_mount(NULL);
+	if (!dfs_path)
+		return NULL;
+
+	sys_dir = opendir(dfs_path);
+	if (!sys_dir)
+		return NULL;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", dfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
+			continue;
+
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
+				 evt_dirent.d_name);
+			fd = open(evt_path, O_RDONLY);
+			if (fd < 0)
+				continue;
+			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+				close(fd);
+				continue;
+			}
+			close(fd);
+			id = atoll(id_buf);
+			if (id == config) {
+				closedir(evt_dir);
+				closedir(sys_dir);
+				path = zalloc(sizeof(*path));
+				path->system = malloc(MAX_EVENT_LENGTH);
+				if (!path->system) {
+					free(path);
+					return NULL;
+				}
+				path->name = malloc(MAX_EVENT_LENGTH);
+				if (!path->name) {
+					free(path->system);
+					free(path);
+					return NULL;
+				}
+				strncpy(path->system, sys_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				strncpy(path->name, evt_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				return path;
+			}
+		}
+		closedir(evt_dir);
+	}
+
+	closedir(sys_dir);
+	return NULL;
+}
+
 static struct tracepoint_path *
 get_tracepoints_path(struct list_head *pattrs)
 {
@@ -481,7 +567,7 @@ get_tracepoints_path(struct list_head *pattrs)
 		++nr_tracepoints;
 		ppath->next = tracepoint_id_to_path(pos->attr.config);
 		if (!ppath->next)
-			die("%s\n", "No memory to alloc tracepoints list");
+			t_die("%s\n", "No memory to alloc tracepoints list");
 		ppath = ppath->next;
 	}
 
diff --git a/tools/lib/trace/trace-event.h b/tools/lib/trace/trace-event.h
index 8510207..1477eca 100644
--- a/tools/lib/trace/trace-event.h
+++ b/tools/lib/trace/trace-event.h
@@ -2,6 +2,7 @@
 #define __LIB_TRACE_EVENTS_H
 
 #include <stdbool.h>
+#include <dirent.h>
 #include <linux/compiler.h>
 
 #include "../../perf/util/session.h"
@@ -317,4 +318,22 @@ int common_pc(struct scripting_context *context);
 int common_flags(struct scripting_context *context);
 int common_lock_depth(struct scripting_context *context);
 
+#define MAX_EVENT_LENGTH 512
+#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
+
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
+	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
+	if (sys_dirent.d_type == DT_DIR &&				       \
+	   (strcmp(sys_dirent.d_name, ".")) &&				       \
+	   (strcmp(sys_dirent.d_name, "..")))
+
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)	       \
+	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
+	if (evt_dirent.d_type == DT_DIR &&				       \
+	   (strcmp(evt_dirent.d_name, ".")) &&				       \
+	   (strcmp(evt_dirent.d_name, "..")) &&				       \
+	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
+
+extern int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir);
+extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 #endif /* __LIB_TRACE_EVENTS_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05e8e65..c76008f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,5 +1,4 @@
 #include "../../../include/linux/hw_breakpoint.h"
-#include <lk/util.h>
 #include "../perf.h"
 #include <perf/evlist.h>
 #include <perf/evsel.h>
@@ -10,7 +9,10 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
+
 #include <lk/debugfs.h>
+#include <lk/util.h>
+#include <trace/trace-event.h>
 
 struct event_symbol {
 	u8		type;
@@ -122,106 +124,6 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(BPU)]	= (CACHE_READ),
 };
 
-#define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
-	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
-	if (sys_dirent.d_type == DT_DIR &&				       \
-	   (strcmp(sys_dirent.d_name, ".")) &&				       \
-	   (strcmp(sys_dirent.d_name, "..")))
-
-static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
-{
-	char evt_path[MAXPATHLEN];
-	int fd;
-
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
-			sys_dir->d_name, evt_dir->d_name);
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return -EINVAL;
-	close(fd);
-
-	return 0;
-}
-
-#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)	       \
-	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
-	if (evt_dirent.d_type == DT_DIR &&				       \
-	   (strcmp(evt_dirent.d_name, ".")) &&				       \
-	   (strcmp(evt_dirent.d_name, "..")) &&				       \
-	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
-
-#define MAX_EVENT_LENGTH 512
-
-
-struct tracepoint_path *tracepoint_id_to_path(u64 config)
-{
-	struct tracepoint_path *path = NULL;
-	DIR *sys_dir, *evt_dir;
-	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	char id_buf[4];
-	int fd;
-	u64 id;
-	char evt_path[MAXPATHLEN];
-	char dir_path[MAXPATHLEN];
-
-	if (debugfs_valid_mountpoint(debugfs_path))
-		return NULL;
-
-	sys_dir = opendir(debugfs_path);
-	if (!sys_dir)
-		return NULL;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-
-		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
-			 sys_dirent.d_name);
-		evt_dir = opendir(dir_path);
-		if (!evt_dir)
-			continue;
-
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-
-			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
-				 evt_dirent.d_name);
-			fd = open(evt_path, O_RDONLY);
-			if (fd < 0)
-				continue;
-			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-				close(fd);
-				continue;
-			}
-			close(fd);
-			id = atoll(id_buf);
-			if (id == config) {
-				closedir(evt_dir);
-				closedir(sys_dir);
-				path = zalloc(sizeof(*path));
-				path->system = malloc(MAX_EVENT_LENGTH);
-				if (!path->system) {
-					free(path);
-					return NULL;
-				}
-				path->name = malloc(MAX_EVENT_LENGTH);
-				if (!path->name) {
-					free(path->system);
-					free(path);
-					return NULL;
-				}
-				strncpy(path->system, sys_dirent.d_name,
-					MAX_EVENT_LENGTH);
-				strncpy(path->name, evt_dirent.d_name,
-					MAX_EVENT_LENGTH);
-				return path;
-			}
-		}
-		closedir(evt_dir);
-	}
-
-	closedir(sys_dir);
-	return NULL;
-}
-
-#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
 static const char *tracepoint_id_to_name(u64 config)
 {
 	static char buf[TP_PATH_LEN];
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 746d3fc..8b05b03 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -17,7 +17,6 @@ struct tracepoint_path {
 	struct tracepoint_path *next;
 };
 
-extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_type(int type);
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index abc31a1..6bcb9a4 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <stdbool.h>
+#include <lk/util.h>
 
 enum parse_opt_type {
 	/* special types */
-- 
1.7.4.rc2

