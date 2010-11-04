Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0KDPkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:40:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43033 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0KDPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:40:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 17/20] perf: Export trace parsing utils
Date: Thu,  4 Nov 2010 16:36:53 +0100
Message-Id: <1288885016-18295-18-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

.. and put them into lib/trace/ for a wider use. Also, move a couple of
helpers from perf/util/parse-events.c -> lib/trace/trace-event-info.c.
While at it, merge duplicated enum trace_flag_type.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/debugfs.c                             |    1 +
 tools/lib/lk/debugfs.h                             |    1 +
 tools/lib/trace/Makefile                           |    7 +-
 tools/lib/trace/parse-events.h                     |   12 +-
 tools/lib/trace/trace-event-info.c                 |  650 ++++++++++++++++++++
 tools/lib/trace/trace-event-parse.c                |  231 +++++++
 tools/lib/trace/trace-event-read.c                 |  541 ++++++++++++++++
 tools/lib/trace/trace-event.h                      |  115 ++++
 tools/perf/Makefile                                |    4 -
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-timechart.c                     |   19 -
 tools/perf/builtin-trace.c                         |    2 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    2 +-
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/util/header.c                           |    7 +-
 tools/perf/util/parse-events.c                     |  103 +---
 tools/perf/util/parse-events.h                     |    9 +-
 tools/perf/util/probe-event.c                      |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 tools/perf/util/trace-event-info.c                 |  566 -----------------
 tools/perf/util/trace-event-parse.c                |  234 -------
 tools/perf/util/trace-event-read.c                 |  541 ----------------
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |   90 ---
 29 files changed, 1574 insertions(+), 1581 deletions(-)
 create mode 100644 tools/lib/trace/trace-event-info.c
 create mode 100644 tools/lib/trace/trace-event-parse.c
 create mode 100644 tools/lib/trace/trace-event-read.c
 create mode 100644 tools/lib/trace/trace-event.h
 delete mode 100644 tools/perf/util/trace-event-info.c
 delete mode 100644 tools/perf/util/trace-event-parse.c
 delete mode 100644 tools/perf/util/trace-event-read.c
 delete mode 100644 tools/perf/util/trace-event.h

diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index c4e7ffe..6920cf9 100644
--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -7,6 +7,7 @@
 static int debugfs_premounted;
 static char debugfs_mountpoint[MAX_PATH+1];
 char debugfs_mntpt[MAXPATHLEN];
+char debugfs_path[MAXPATHLEN];
 
 static const char *debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug/",
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
index 5970f0b..5590c43 100644
--- a/tools/lib/lk/debugfs.h
+++ b/tools/lib/lk/debugfs.h
@@ -16,6 +16,7 @@
 #define LK_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 extern char debugfs_mntpt[];
+extern char debugfs_path[];
 
 extern const char *debugfs_find_mountpoint(void);
 extern int debugfs_valid_mountpoint(const char *debugfs);
diff --git a/tools/lib/trace/Makefile b/tools/lib/trace/Makefile
index 22fa7b6..a0ca116 100644
--- a/tools/lib/trace/Makefile
+++ b/tools/lib/trace/Makefile
@@ -37,17 +37,22 @@ TRACE_LIB = $(LIB_OUTPUT)libparsevent.a
 
 all: $(TRACE_LIB)
 
+PEVENT_LIB_H += trace-event.h
+
 PEVENT_LIB_OBJS += parse-events.o
 PEVENT_LIB_OBJS += parse-filter.o
 PEVENT_LIB_OBJS += parse-utils.o
 PEVENT_LIB_OBJS += trace-seq.o
+PEVENT_LIB_OBJS += trace-event-parse.o
+PEVENT_LIB_OBJS += trace-event-read.o
+PEVENT_LIB_OBJS += trace-event-info.o
 
 ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(CC) -g -o $@ -c $(ALL_CFLAGS) $<
 
-$(TRACE_LIB): $(PEVENT_LIB_OBJS)
+$(TRACE_LIB): $(PEVENT_LIB_OBJS) $(PEVENT_LIB_H)
 	$(RM) $@;  $(AR) rcs $@ $^
 
 clean:
diff --git a/tools/lib/trace/parse-events.h b/tools/lib/trace/parse-events.h
index 31f46f5..f967885 100644
--- a/tools/lib/trace/parse-events.h
+++ b/tools/lib/trace/parse-events.h
@@ -425,7 +425,17 @@ __data2host8(struct pevent *pevent, unsigned long long data)
 	__data2host8(pevent, __val);				\
 })
 
-/* taken from kernel/trace/trace.h */
+/*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF            - interrupts were disabled
+ *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
+ *  NEED_RESCED         - reschedule is requested
+ *  HARDIRQ             - inside an interrupt handler
+ *  SOFTIRQ             - inside a softirq handler
+ *
+ *  taken from kernel/trace/trace.h
+ */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
 	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
diff --git a/tools/lib/trace/trace-event-info.c b/tools/lib/trace/trace-event-info.c
new file mode 100644
index 0000000..98faa44
--- /dev/null
+++ b/tools/lib/trace/trace-event-info.c
@@ -0,0 +1,650 @@
+/*
+ * Copyright (C) 2008,2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <mntent.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/param.h>
+#include <pthread.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <lk/util.h>
+#include <lk/kernel.h>
+#include <lk/debugfs.h>
+
+#include "../../perf/perf.h"
+#include "trace-event.h"
+
+#define VERSION "0.5"
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+#define MAX_PATH 256
+
+#define TRACE_CTRL	"tracing_on"
+#define TRACE		"trace"
+#define AVAILABLE	"available_tracers"
+#define CURRENT		"current_tracer"
+#define ITER_CTRL	"trace_options"
+#define MAX_LATENCY	"tracing_max_latency"
+
+unsigned int page_size;
+
+static const char *output_file = "trace.info";
+static int output_fd;
+
+struct event_list {
+	struct event_list *next;
+	const char *event;
+};
+
+struct events {
+	struct events *sibling;
+	struct events *children;
+	struct events *next;
+	char *name;
+};
+
+
+
+static void t_die(const char *fmt, ...)
+{
+	va_list ap;
+	int ret = errno;
+
+	if (errno)
+		perror("trace-cmd");
+	else
+		ret = -1;
+
+	va_start(ap, fmt);
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+void *malloc_or_die(unsigned int size)
+{
+	void *data;
+
+	data = malloc(size);
+	if (!data)
+		t_die("malloc");
+	return data;
+}
+
+static const char *find_debugfs(void)
+{
+	const char *path = debugfs_mount(NULL);
+
+	if (!path)
+		t_die("Your kernel not support debugfs filesystem");
+
+	return path;
+}
+
+/*
+ * Finds the path to the debugfs/tracing
+ * Allocates the string and stores it.
+ */
+static const char *find_tracing_dir(void)
+{
+	static char *tracing;
+	static int tracing_found;
+	const char *debugfs;
+
+	if (tracing_found)
+		return tracing;
+
+	debugfs = find_debugfs();
+
+	tracing = malloc_or_die(strlen(debugfs) + 9);
+
+	sprintf(tracing, "%s/tracing", debugfs);
+
+	tracing_found = 1;
+	return tracing;
+}
+
+static char *get_tracing_file(const char *name)
+{
+	const char *tracing;
+	char *file;
+
+	tracing = find_tracing_dir();
+	if (!tracing)
+		return NULL;
+
+	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
+
+	sprintf(file, "%s/%s", tracing, name);
+	return file;
+}
+
+static void put_tracing_file(char *file)
+{
+	free(file);
+}
+
+static ssize_t calc_data_size;
+
+static ssize_t write_or_die(const void *buf, size_t len)
+{
+	int ret;
+
+	if (calc_data_size) {
+		calc_data_size += len;
+		return len;
+	}
+
+	ret = write(output_fd, buf, len);
+	if (ret < 0)
+		t_die("writing to '%s'", output_file);
+
+	return ret;
+}
+
+int bigendian(void)
+{
+	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
+	unsigned int *ptr;
+
+	ptr = (unsigned int *)(void *)str;
+	return *ptr == 0x01020304;
+}
+
+static unsigned long long copy_file_fd(int fd)
+{
+	unsigned long long size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0) {
+			size += r;
+			write_or_die(buf, r);
+		}
+	} while (r > 0);
+
+	return size;
+}
+
+static unsigned long long copy_file(const char *file)
+{
+	unsigned long long size = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		t_die("Can't read '%s'", file);
+	size = copy_file_fd(fd);
+	close(fd);
+
+	return size;
+}
+
+static unsigned long get_size_fd(int fd)
+{
+	unsigned long long size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0)
+			size += r;
+	} while (r > 0);
+
+	lseek(fd, 0, SEEK_SET);
+
+	return size;
+}
+
+static unsigned long get_size(const char *file)
+{
+	unsigned long long size = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		t_die("Can't read '%s'", file);
+	size = get_size_fd(fd);
+	close(fd);
+
+	return size;
+}
+
+static void read_header_files(void)
+{
+	unsigned long long size, check_size;
+	char *path;
+	int fd;
+
+	path = get_tracing_file("events/header_page");
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		t_die("can't read '%s'", path);
+
+	/* unfortunately, you can not stat debugfs files for size */
+	size = get_size_fd(fd);
+
+	write_or_die("header_page", 12);
+	write_or_die(&size, 8);
+	check_size = copy_file_fd(fd);
+	close(fd);
+
+	if (size != check_size)
+		t_die("wrong size for '%s' size=%lld read=%lld",
+		    path, size, check_size);
+	put_tracing_file(path);
+
+	path = get_tracing_file("events/header_event");
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		t_die("can't read '%s'", path);
+
+	size = get_size_fd(fd);
+
+	write_or_die("header_event", 13);
+	write_or_die(&size, 8);
+	check_size = copy_file_fd(fd);
+	if (size != check_size)
+		t_die("wrong size for '%s'", path);
+	put_tracing_file(path);
+	close(fd);
+}
+
+static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
+{
+	while (tps) {
+		if (!strcmp(sys, tps->name))
+			return true;
+		tps = tps->next;
+	}
+
+	return false;
+}
+
+static void copy_event_system(const char *sys, struct tracepoint_path *tps)
+{
+	unsigned long long size, check_size;
+	struct dirent *dent;
+	struct stat st;
+	char *format;
+	DIR *dir;
+	int count = 0;
+	int ret;
+
+	dir = opendir(sys);
+	if (!dir)
+		t_die("can't read directory '%s'", sys);
+
+	while ((dent = readdir(dir))) {
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    !name_in_tp_list(dent->d_name, tps))
+			continue;
+		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		sprintf(format, "%s/%s/format", sys, dent->d_name);
+		ret = stat(format, &st);
+		free(format);
+		if (ret < 0)
+			continue;
+		count++;
+	}
+
+	write_or_die(&count, 4);
+
+	rewinddir(dir);
+	while ((dent = readdir(dir))) {
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    !name_in_tp_list(dent->d_name, tps))
+			continue;
+		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		sprintf(format, "%s/%s/format", sys, dent->d_name);
+		ret = stat(format, &st);
+
+		if (ret >= 0) {
+			/* unfortunately, you can not stat debugfs files for size */
+			size = get_size(format);
+			write_or_die(&size, 8);
+			check_size = copy_file(format);
+			if (size != check_size)
+				t_die("error in size of file '%s'", format);
+		}
+
+		free(format);
+	}
+	closedir(dir);
+}
+
+static void read_ftrace_files(struct tracepoint_path *tps)
+{
+	char *path;
+
+	path = get_tracing_file("events/ftrace");
+
+	copy_event_system(path, tps);
+
+	put_tracing_file(path);
+}
+
+static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
+{
+	while (tps) {
+		if (!strcmp(sys, tps->system))
+			return true;
+		tps = tps->next;
+	}
+
+	return false;
+}
+
+static void read_event_files(struct tracepoint_path *tps)
+{
+	struct dirent *dent;
+	struct stat st;
+	char *path;
+	char *sys;
+	DIR *dir;
+	int count = 0;
+	int ret;
+
+	path = get_tracing_file("events");
+
+	dir = opendir(path);
+	if (!dir)
+		t_die("can't read directory '%s'", path);
+
+	while ((dent = readdir(dir))) {
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    strcmp(dent->d_name, "ftrace") == 0 ||
+		    !system_in_tp_list(dent->d_name, tps))
+			continue;
+		count++;
+	}
+
+	write_or_die(&count, 4);
+
+	rewinddir(dir);
+	while ((dent = readdir(dir))) {
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    strcmp(dent->d_name, "ftrace") == 0 ||
+		    !system_in_tp_list(dent->d_name, tps))
+			continue;
+		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sprintf(sys, "%s/%s", path, dent->d_name);
+		ret = stat(sys, &st);
+		if (ret >= 0) {
+			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
+			copy_event_system(sys, tps);
+		}
+		free(sys);
+	}
+
+	closedir(dir);
+	put_tracing_file(path);
+}
+
+static void read_proc_kallsyms(void)
+{
+	unsigned int size, check_size;
+	const char *path = "/proc/kallsyms";
+	struct stat st;
+	int ret;
+
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		return;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		t_die("error in size of file '%s'", path);
+
+}
+
+static void read_ftrace_printk(void)
+{
+	unsigned int size, check_size;
+	char *path;
+	struct stat st;
+	int ret;
+
+	path = get_tracing_file("printk_formats");
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		goto out;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		t_die("error in size of file '%s'", path);
+out:
+	put_tracing_file(path);
+}
+
+int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
+{
+	char evt_path[MAXPATHLEN];
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
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
+	if (debugfs_valid_mountpoint(debugfs_path))
+		return NULL;
+
+	sys_dir = opendir(debugfs_path);
+	if (!sys_dir)
+		return NULL;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
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
+static struct tracepoint_path *
+get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
+{
+	struct tracepoint_path path, *ppath = &path;
+	int i, nr_tracepoints = 0;
+
+	for (i = 0; i < nb_events; i++) {
+		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
+			continue;
+		++nr_tracepoints;
+		ppath->next = tracepoint_id_to_path(pattrs[i].config);
+		if (!ppath->next)
+			t_die("%s\n", "No memory to alloc tracepoints list");
+		ppath = ppath->next;
+	}
+
+	return nr_tracepoints > 0 ? path.next : NULL;
+}
+
+bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
+{
+	int i;
+
+	for (i = 0; i < nb_events; i++)
+		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
+			return true;
+
+	return false;
+}
+
+int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
+{
+	char buf[BUFSIZ];
+	struct tracepoint_path *tps = get_tracepoints_path(pattrs, nb_events);
+
+	/*
+	 * What? No tracepoints? No sense writing anything here, bail out.
+	 */
+	if (tps == NULL)
+		return -1;
+
+	output_fd = fd;
+
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
+	read_trace_init(buf[0], buf[0]);
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
+
+	read_header_files();
+	read_ftrace_files(tps);
+	read_event_files(tps);
+	read_proc_kallsyms();
+	read_ftrace_printk();
+
+	return 0;
+}
+
+ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
+			       int nb_events)
+{
+	ssize_t size;
+	int err = 0;
+
+	calc_data_size = 1;
+	err = read_tracing_data(fd, pattrs, nb_events);
+	size = calc_data_size - 1;
+	calc_data_size = 0;
+
+	if (err < 0)
+		return err;
+
+	return size;
+}
diff --git a/tools/lib/trace/trace-event-parse.c b/tools/lib/trace/trace-event-parse.c
new file mode 100644
index 0000000..c6f77c9
--- /dev/null
+++ b/tools/lib/trace/trace-event-parse.c
@@ -0,0 +1,231 @@
+/*
+ * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+
+#undef _GNU_SOURCE
+#include "../../perf/perf.h"
+#include <lk/util.h>
+#include "trace-event.h"
+
+int header_page_size_size;
+int header_page_ts_size;
+int header_page_data_offset;
+
+struct pevent *perf_pevent;
+static struct pevent *pevent;
+
+bool latency_format;
+
+int read_trace_init(int file_bigendian, int host_bigendian)
+{
+	if (pevent)
+		return 0;
+
+	perf_pevent = pevent_alloc();
+	pevent = perf_pevent;
+
+	pevent_set_file_bigendian(pevent, file_bigendian);
+	pevent_set_host_bigendian(pevent, host_bigendian);
+
+	return 0;
+}
+
+unsigned long long
+raw_field_value(struct event_format *event, const char *name, void *data)
+{
+	struct format_field *field;
+	unsigned long long val;
+
+	field = pevent_find_any_field(event, name);
+	if (!field)
+		return 0ULL;
+
+	pevent_read_number_field(field, data, &val);
+
+	return val;
+}
+
+void *raw_field_ptr(struct event_format *event, const char *name, void *data)
+{
+	struct format_field *field;
+
+	field = pevent_find_any_field(event, name);
+	if (!field)
+		return NULL;
+
+	if (field->flags & FIELD_IS_DYNAMIC) {
+		int offset;
+
+		offset = *(int *)(data + field->offset);
+		offset &= 0xffff;
+
+		return data + offset;
+	}
+
+	return data + field->offset;
+}
+
+int trace_parse_common_type(void *data)
+{
+	struct record record;
+
+	record.data = data;
+	return pevent_data_type(pevent, &record);
+}
+
+struct event_format *trace_find_event(int type)
+{
+	return pevent_find_event(pevent, type);
+}
+
+void print_event(int cpu, void *data, int size, unsigned long long nsecs,
+		  char *comm)
+{
+	struct record record;
+	struct trace_seq s;
+	int pid;
+
+	pevent->latency_format = latency_format;
+
+	record.ts = nsecs;
+	record.cpu = cpu;
+	record.size = size;
+	record.data = data;
+	pid = pevent_data_pid(pevent, &record);
+
+	if (!pevent_pid_is_registered(pevent, pid))
+		pevent_register_comm(pevent, comm, pid);
+
+	trace_seq_init(&s);
+	pevent_print_event(pevent, &s, &record);
+	trace_seq_do_printf(&s);
+	printf("\n");
+
+#if 0
+	struct event *event;
+	unsigned long secs;
+	unsigned long usecs;
+	int type;
+	int pid;
+
+	secs = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs = nsecs / NSECS_PER_USEC;
+
+	type = trace_parse_common_type(data);
+
+	event = trace_find_event(type);
+	if (!event) {
+		warning("ug! no event found for type %d", type);
+		return;
+	}
+
+	pid = trace_parse_common_pid(data);
+
+	if (latency_format) {
+		printf("%8.8s-%-5d %3d",
+		       comm, pid, cpu);
+		print_lat_fmt(data, size);
+	} else
+		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
+
+	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
+
+	if (event->flags & EVENT_FL_FAILED) {
+		printf("EVENT '%s' FAILED TO PARSE\n",
+		       event->name);
+		return;
+	}
+
+	pretty_print(data, size, event);
+	printf("\n");
+#endif
+}
+
+void parse_proc_kallsyms(char *file, unsigned int size __unused)
+{
+	unsigned long long addr;
+	char *func;
+	char *line;
+	char *next = NULL;
+	char *addr_str;
+	char *mod;
+	char ch;
+	int ret;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		mod = NULL;
+		ret = sscanf(line, "%as %c %as\t[%as",
+			     &addr_str, &ch, &func, &mod);
+		addr = strtoull(addr_str, NULL, 16);
+		free(addr_str);
+
+		/* truncate the extra ']' */
+		if (mod)
+			mod[strlen(mod) - 1] = 0;
+
+		pevent_register_function(pevent, func, addr, mod);
+		free(func);
+		free(mod);
+
+		line = strtok_r(NULL, "\n", &next);
+	}
+}
+
+void parse_ftrace_printk(char *file, unsigned int size __unused)
+{
+	unsigned long long addr;
+	char *printk;
+	char *line;
+	char *next = NULL;
+	char *addr_str;
+	char *fmt;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		addr_str = strtok_r(line, ":", &fmt);
+		if (!addr_str) {
+			warning("printk format with empty entry");
+			break;
+		}
+		addr = strtoull(addr_str, NULL, 16);
+		/* fmt still has a space, skip it */
+		printk = strdup(fmt+1);
+		line = strtok_r(NULL, "\n", &next);
+		pevent_register_print_string(pevent, printk, addr);
+	}
+}
+
+int parse_ftrace_file(char *buf, unsigned long size)
+{
+	return pevent_parse_event(pevent, buf, size, "ftrace");
+}
+
+int parse_event_file(char *buf, unsigned long size, char *sys)
+{
+	return pevent_parse_event(pevent, buf, size, sys);
+}
diff --git a/tools/lib/trace/trace-event-read.c b/tools/lib/trace/trace-event-read.c
new file mode 100644
index 0000000..2801b1b
--- /dev/null
+++ b/tools/lib/trace/trace-event-read.c
@@ -0,0 +1,541 @@
+/*
+ * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _FILE_OFFSET_BITS 64
+
+#include <dirent.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <stdarg.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "../../perf/perf.h"
+#include <lk/util.h>
+#include "trace-event.h"
+
+static int input_fd;
+
+static int read_page;
+
+int file_bigendian;
+int host_bigendian;
+static int long_size;
+
+static unsigned long	page_size;
+
+static ssize_t calc_data_size;
+static bool repipe;
+
+static int do_read(int fd, void *buf, int size)
+{
+	int rsize = size;
+
+	while (size) {
+		int ret = read(fd, buf, size);
+
+		if (ret <= 0)
+			return -1;
+
+		if (repipe) {
+			int retw = write(STDOUT_FILENO, buf, ret);
+
+			if (retw <= 0 || retw != ret)
+				die("repiping input file");
+		}
+
+		size -= ret;
+		buf += ret;
+	}
+
+	return rsize;
+}
+
+static int read_or_die(void *data, int size)
+{
+	int r;
+
+	r = do_read(input_fd, data, size);
+	if (r <= 0)
+		die("reading input file (size expected=%d received=%d)",
+		    size, r);
+
+	if (calc_data_size)
+		calc_data_size += r;
+
+	return r;
+}
+
+/* If it fails, the next read will report it */
+static void skip(int size)
+{
+	char buf[BUFSIZ];
+	int r;
+
+	while (size) {
+		r = size > BUFSIZ ? BUFSIZ : size;
+		read_or_die(buf, r);
+		size -= r;
+	};
+}
+
+static unsigned int read4(void)
+{
+	unsigned int data;
+
+	read_or_die(&data, 4);
+	return __data2host4(perf_pevent, data);
+}
+
+static unsigned long long read8(void)
+{
+	unsigned long long data;
+
+	read_or_die(&data, 8);
+	return __data2host8(perf_pevent, data);
+}
+
+static char *read_string(void)
+{
+	char buf[BUFSIZ];
+	char *str = NULL;
+	int size = 0;
+	off_t r;
+	char c;
+
+	for (;;) {
+		r = read(input_fd, &c, 1);
+		if (r < 0)
+			die("reading input file");
+
+		if (!r)
+			die("no data");
+
+		if (repipe) {
+			int retw = write(STDOUT_FILENO, &c, 1);
+
+			if (retw <= 0 || retw != r)
+				die("repiping input file string");
+		}
+
+		buf[size++] = c;
+
+		if (!c)
+			break;
+	}
+
+	if (calc_data_size)
+		calc_data_size += size;
+
+	str = malloc_or_die(size);
+	memcpy(str, buf, size);
+
+	return str;
+}
+
+static void read_proc_kallsyms(void)
+{
+	unsigned int size;
+	char *buf;
+
+	size = read4();
+	if (!size)
+		return;
+
+	buf = malloc_or_die(size + 1);
+	read_or_die(buf, size);
+	buf[size] = '\0';
+
+	parse_proc_kallsyms(buf, size);
+
+	free(buf);
+}
+
+static void read_ftrace_printk(void)
+{
+	unsigned int size;
+	char *buf;
+
+	size = read4();
+	if (!size)
+		return;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+
+	parse_ftrace_printk(buf, size);
+
+	free(buf);
+}
+
+static void read_header_files(void)
+{
+	unsigned long long size;
+	char *header_event;
+	char buf[BUFSIZ];
+
+	read_or_die(buf, 12);
+
+	if (memcmp(buf, "header_page", 12) != 0)
+		die("did not read header page");
+
+	size = read8();
+	skip(size);
+
+	/*
+	 * The size field in the page is of type long,
+	 * use that instead, since it represents the kernel.
+	 */
+	long_size = header_page_size_size;
+
+	read_or_die(buf, 13);
+	if (memcmp(buf, "header_event", 13) != 0)
+		die("did not read header event");
+
+	size = read8();
+	header_event = malloc_or_die(size);
+	read_or_die(header_event, size);
+	free(header_event);
+}
+
+static void read_ftrace_file(unsigned long long size)
+{
+	char *buf;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+	parse_ftrace_file(buf, size);
+	free(buf);
+}
+
+static void read_event_file(char *sys, unsigned long long size)
+{
+	char *buf;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+	parse_event_file(buf, size, sys);
+	free(buf);
+}
+
+static void read_ftrace_files(void)
+{
+	unsigned long long size;
+	int count;
+	int i;
+
+	count = read4();
+
+	for (i = 0; i < count; i++) {
+		size = read8();
+		read_ftrace_file(size);
+	}
+}
+
+static void read_event_files(void)
+{
+	unsigned long long size;
+	char *sys;
+	int systems;
+	int count;
+	int i,x;
+
+	systems = read4();
+
+	for (i = 0; i < systems; i++) {
+		sys = read_string();
+
+		count = read4();
+		for (x=0; x < count; x++) {
+			size = read8();
+			read_event_file(sys, size);
+		}
+	}
+}
+
+struct cpu_data {
+	unsigned long long	offset;
+	unsigned long long	size;
+	unsigned long long	timestamp;
+	struct record		*next;
+	char			*page;
+	int			cpu;
+	int			index;
+	int			page_size;
+};
+
+static struct cpu_data *cpu_data;
+
+static void update_cpu_data_index(int cpu)
+{
+	cpu_data[cpu].offset += page_size;
+	cpu_data[cpu].size -= page_size;
+	cpu_data[cpu].index = 0;
+}
+
+static void get_next_page(int cpu)
+{
+	off_t save_seek;
+	off_t ret;
+
+	if (!cpu_data[cpu].page)
+		return;
+
+	if (read_page) {
+		if (cpu_data[cpu].size <= page_size) {
+			free(cpu_data[cpu].page);
+			cpu_data[cpu].page = NULL;
+			return;
+		}
+
+		update_cpu_data_index(cpu);
+
+		/* other parts of the code may expect the pointer to not move */
+		save_seek = lseek(input_fd, 0, SEEK_CUR);
+
+		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
+		if (ret == (off_t)-1)
+			die("failed to lseek");
+		ret = read(input_fd, cpu_data[cpu].page, page_size);
+		if (ret < 0)
+			die("failed to read page");
+
+		/* reset the file pointer back */
+		lseek(input_fd, save_seek, SEEK_SET);
+
+		return;
+	}
+
+	munmap(cpu_data[cpu].page, page_size);
+	cpu_data[cpu].page = NULL;
+
+	if (cpu_data[cpu].size <= page_size)
+		return;
+
+	update_cpu_data_index(cpu);
+
+	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
+				  input_fd, cpu_data[cpu].offset);
+	if (cpu_data[cpu].page == MAP_FAILED)
+		die("failed to mmap cpu %d at offset 0x%llx",
+		    cpu, cpu_data[cpu].offset);
+}
+
+static unsigned int type_len4host(unsigned int type_len_ts)
+{
+	if (file_bigendian)
+		return (type_len_ts >> 27) & ((1 << 5) - 1);
+	else
+		return type_len_ts & ((1 << 5) - 1);
+}
+
+static unsigned int ts4host(unsigned int type_len_ts)
+{
+	if (file_bigendian)
+		return type_len_ts & ((1 << 27) - 1);
+	else
+		return type_len_ts >> 5;
+}
+
+static int calc_index(void *ptr, int cpu)
+{
+	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
+}
+
+struct record *trace_peek_data(int cpu)
+{
+	struct record *data;
+	void *page = cpu_data[cpu].page;
+	int idx = cpu_data[cpu].index;
+	void *ptr = page + idx;
+	unsigned long long extend;
+	unsigned int type_len_ts;
+	unsigned int type_len;
+	unsigned int delta;
+	unsigned int length = 0;
+
+	if (cpu_data[cpu].next)
+		return cpu_data[cpu].next;
+
+	if (!page)
+		return NULL;
+
+	if (!idx) {
+		/* FIXME: handle header page */
+		if (header_page_ts_size != 8)
+			die("expected a long long type for timestamp");
+		cpu_data[cpu].timestamp = data2host8(perf_pevent, ptr);
+		ptr += 8;
+		switch (header_page_size_size) {
+		case 4:
+			cpu_data[cpu].page_size = data2host4(perf_pevent, ptr);
+			ptr += 4;
+			break;
+		case 8:
+			cpu_data[cpu].page_size = data2host8(perf_pevent, ptr);
+			ptr += 8;
+			break;
+		default:
+			die("bad long size");
+		}
+		ptr = cpu_data[cpu].page + header_page_data_offset;
+	}
+
+read_again:
+	idx = calc_index(ptr, cpu);
+
+	if (idx >= cpu_data[cpu].page_size) {
+		get_next_page(cpu);
+		return trace_peek_data(cpu);
+	}
+
+	type_len_ts = data2host4(perf_pevent, ptr);
+	ptr += 4;
+
+	type_len = type_len4host(type_len_ts);
+	delta = ts4host(type_len_ts);
+
+	switch (type_len) {
+	case RINGBUF_TYPE_PADDING:
+		if (!delta)
+			die("error, hit unexpected end of page");
+		length = data2host4(perf_pevent, ptr);
+		ptr += 4;
+		length *= 4;
+		ptr += length;
+		goto read_again;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		extend = data2host4(perf_pevent, ptr);
+		ptr += 4;
+		extend <<= TS_SHIFT;
+		extend += delta;
+		cpu_data[cpu].timestamp += extend;
+		goto read_again;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		ptr += 12;
+		break;
+	case 0:
+		length = data2host4(perf_pevent, ptr);
+		ptr += 4;
+		die("here! length=%d", length);
+		break;
+	default:
+		length = type_len * 4;
+		break;
+	}
+
+	cpu_data[cpu].timestamp += delta;
+
+	data = malloc_or_die(sizeof(*data));
+	memset(data, 0, sizeof(*data));
+
+	data->ts = cpu_data[cpu].timestamp;
+	data->size = length;
+	data->data = ptr;
+	ptr += length;
+
+	cpu_data[cpu].index = calc_index(ptr, cpu);
+	cpu_data[cpu].next = data;
+
+	return data;
+}
+
+struct record *trace_read_data(int cpu)
+{
+	struct record *data;
+
+	data = trace_peek_data(cpu);
+	cpu_data[cpu].next = NULL;
+
+	return data;
+}
+
+ssize_t trace_report(int fd, bool __repipe)
+{
+	char buf[BUFSIZ];
+	char test[] = { 23, 8, 68 };
+	char *version;
+	int show_version = 0;
+	int show_funcs = 0;
+	int show_printk = 0;
+	ssize_t size;
+
+	calc_data_size = 1;
+	repipe = __repipe;
+
+	input_fd = fd;
+
+	read_or_die(buf, 3);
+	if (memcmp(buf, test, 3) != 0)
+		die("no trace data in the file");
+
+	read_or_die(buf, 7);
+	if (memcmp(buf, "tracing", 7) != 0)
+		die("not a trace file (missing 'tracing' tag)");
+
+	version = read_string();
+	if (show_version)
+		printf("version = %s\n", version);
+	free(version);
+
+	read_or_die(buf, 1);
+	file_bigendian = buf[0];
+	host_bigendian = bigendian();
+
+	read_trace_init(file_bigendian, host_bigendian);
+
+	read_or_die(buf, 1);
+	long_size = buf[0];
+
+	page_size = read4();
+
+	read_header_files();
+
+	read_ftrace_files();
+	read_event_files();
+	read_proc_kallsyms();
+	read_ftrace_printk();
+
+	size = calc_data_size - 1;
+	calc_data_size = 0;
+	repipe = false;
+
+	if (show_funcs) {
+		pevent_print_funcs(perf_pevent);
+		return size;
+	}
+	if (show_printk) {
+		pevent_print_printk(perf_pevent);
+		return size;
+	}
+
+	return size;
+}
diff --git a/tools/lib/trace/trace-event.h b/tools/lib/trace/trace-event.h
new file mode 100644
index 0000000..9c9d342
--- /dev/null
+++ b/tools/lib/trace/trace-event.h
@@ -0,0 +1,115 @@
+#ifndef _PERF_UTIL_TRACE_EVENT_H
+#define _PERF_UTIL_TRACE_EVENT_H
+
+#include "../../perf/perf.h"
+#include "parse-events.h"
+
+extern int header_page_size_size;
+extern int header_page_ts_size;
+extern int header_page_data_offset;
+
+extern bool latency_format;
+extern struct pevent *perf_pevent;
+
+struct scripting_context {
+	void *event_data;
+};
+
+enum {
+	RINGBUF_TYPE_PADDING		= 29,
+	RINGBUF_TYPE_TIME_EXTEND	= 30,
+	RINGBUF_TYPE_TIME_STAMP		= 31,
+};
+
+#ifndef TS_SHIFT
+#define TS_SHIFT		27
+#endif
+
+int bigendian(void);
+
+int read_trace_init(int file_bigendian, int host_bigendian);
+
+void print_event(int cpu, void *data, int size, unsigned long long nsecs,
+		  char *comm);
+
+struct record *trace_read_data(int cpu);
+int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
+ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
+			       int nb_events);
+
+int parse_ftrace_file(char *buf, unsigned long size);
+int parse_event_file(char *buf, unsigned long size, char *sys);
+
+struct record *trace_peek_data(int cpu);
+struct event_format *trace_find_event(int type);
+
+unsigned long long
+raw_field_value(struct event_format *event, const char *name, void *data);
+void *raw_field_ptr(struct event_format *event, const char *name, void *data);
+
+void parse_proc_kallsyms(char *file, unsigned int size __unused);
+void parse_ftrace_printk(char *file, unsigned int size __unused);
+
+ssize_t trace_report(int fd, bool repipe);
+
+struct scripting_ops {
+	const char *name;
+	int (*start_script) (const char *script, int argc, const char **argv);
+	int (*stop_script) (void);
+	void (*process_event) (int cpu, void *data, int size,
+			       unsigned long long nsecs, char *comm);
+	int (*generate_script) (const char *outfile);
+};
+
+int script_spec_register(const char *spec, struct scripting_ops *ops);
+
+void setup_perl_scripting(void);
+void setup_python_scripting(void);
+
+int trace_parse_common_type(void *data);
+int trace_parse_common_pid(void *data);
+#if 0
+int parse_common_pc(void *data);
+int parse_common_flags(void *data);
+int parse_common_lock_depth(void *data);
+struct event_format *trace_find_event(int id);
+#endif
+struct event_format *trace_find_next_event(struct event_format *event);
+unsigned long long read_size(void *ptr, int size);
+#if 0
+unsigned long long
+raw_field_value(struct event_format *event, const char *name, void *data);
+void *raw_field_ptr(struct event_format *event, const char *name, void *data);
+#endif
+unsigned long long eval_flag(const char *flag);
+
+int common_pc(struct scripting_context *context);
+int common_flags(struct scripting_context *context);
+int common_lock_depth(struct scripting_context *context);
+
+#define MAX_EVENT_LENGTH 512
+#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
+
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next)			\
+	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)		\
+	if (sys_dirent.d_type == DT_DIR &&					\
+	   (strcmp(sys_dirent.d_name, ".")) &&					\
+	   (strcmp(sys_dirent.d_name, "..")))
+
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)		\
+	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)		\
+	if (evt_dirent.d_type == DT_DIR &&					\
+	   (strcmp(evt_dirent.d_name, ".")) &&					\
+	   (strcmp(evt_dirent.d_name, "..")) &&					\
+	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
+
+
+struct tracepoint_path {
+	char *system;
+	char *name;
+	struct tracepoint_path *next;
+};
+
+extern int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir);
+extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+#endif /* _PERF_UTIL_TRACE_EVENT_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 98cdd20..f899b08 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -370,7 +370,6 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
-LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
@@ -399,9 +398,6 @@ LIB_OBJS += $(OUTPUT)util/debug.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
-LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
-LIB_OBJS += $(OUTPUT)util/trace-event-read.o
-LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 703cc93..e432afe 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b849f99e..75ef557 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6257d26..94b454f 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -8,7 +8,7 @@
 #include "util/header.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c881900..4ef6fe1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 
 #include "util/parse-options.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 43cfc18..2b010ec 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -314,25 +314,6 @@ struct wakeup_entry {
 	int   success;
 };
 
-/*
- * trace_flag_type is an enumeration that holds different
- * states when a trace occurs. These are:
- *  IRQS_OFF            - interrupts were disabled
- *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
- *  NEED_RESCED         - reschedule is requested
- *  HARDIRQ             - inside an interrupt handler
- *  SOFTIRQ             - inside a softirq handler
- */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
-	TRACE_FLAG_NEED_RESCHED		= 0x04,
-	TRACE_FLAG_HARDIRQ		= 0x08,
-	TRACE_FLAG_SOFTIRQ		= 0x10,
-};
-
-
-
 struct sched_switch {
 	struct trace_entry te;
 	char prev_comm[TASK_COMM_LEN];
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a6c41c6..f41a9e0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -9,7 +9,7 @@
 #include "util/session.h"
 #include <perf/config.h>
 #include "util/thread.h"
-#include "util/trace-event.h"
+#include <trace/trace-event.h>
 #include <lk/util.h>
 
 static char const		*script_name;
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 01a64ad..f38aacf 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -32,7 +32,7 @@
 #include "perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include <trace/trace-event.h>
 
 #ifndef PERL_UNUSED_VAR
 #  define PERL_UNUSED_VAR(var) if (0) var = var
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index 549cf04..baff89f 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -23,7 +23,7 @@
 #include "perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include <trace/trace-event.h>
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Context.c b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
index 957085d..6474be7 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
@@ -21,7 +21,7 @@
 
 #include <Python.h>
 #include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include <trace/trace-event.h>
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f233545..e0f84b5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -6,15 +6,16 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <linux/list.h>
+#include <lk/util.h>
 #include <lk/kernel.h>
+#include <perf/symbol.h>
+#include <trace/trace-event.h>
 
-#include <lk/util.h>
 #include "header.h"
 #include "../perf.h"
-#include "trace-event.h"
 #include "session.h"
-#include <perf/symbol.h>
 #include "debug.h"
+#include "parse-events.h"
 
 static bool no_buildid_cache = false;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index ad36237..6e1e01c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -8,6 +8,7 @@
 #include "exec_cmd.h"
 #include "string.h"
 #include <perf/symbol.h>
+#include <trace/trace-event.h>
 #include "cache.h"
 #include "header.h"
 
@@ -29,8 +30,6 @@ enum event_result {
 	EVT_HANDLED_ALL
 };
 
-char debugfs_path[MAXPATHLEN];
-
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
@@ -126,106 +125,6 @@ static unsigned long hw_cache_stat[C(MAX)] = {
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
index 9492e3c..41ebdc4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,16 +4,10 @@
  * Parse symbolic events/counts passed in as options:
  */
 #include <perf/util.h>
+#include <trace/parse-events.h>
 
 struct option;
 
-struct tracepoint_path {
-	char *system;
-	char *name;
-	struct tracepoint_path *next;
-};
-
-extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events);
 
 extern int			nr_counters;
@@ -31,7 +25,6 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 extern void print_events(void);
 
-extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 577944c..2bed689 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -44,7 +44,7 @@
 #include <perf/color.h>
 #include <perf/symbol.h>
 #include "thread.h"
-#include "trace-event.h"	/* For __unused */
+#include <trace/trace-event.h>	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 78af7d1..af37491 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -27,7 +27,7 @@
 
 #include "../../perf.h"
 #include <lk/util.h>
-#include "../trace-event.h"
+#include <trace/trace-event.h>
 
 #include <EXTERN.h>
 #include <perl.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 524d355..464c25a 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -29,7 +29,7 @@
 
 #include "../../perf.h"
 #include <lk/util.h>
-#include "../trace-event.h"
+#include <trace/trace-event.h>
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
deleted file mode 100644
index fadc2c0..0000000
--- a/tools/perf/util/trace-event-info.c
+++ /dev/null
@@ -1,566 +0,0 @@
-/*
- * Copyright (C) 2008,2009, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#define _GNU_SOURCE
-#include <dirent.h>
-#include <mntent.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/wait.h>
-#include <pthread.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <ctype.h>
-#include <errno.h>
-#include <stdbool.h>
-#include <lk/kernel.h>
-
-#include <lk/debugfs.h>
-
-#include "../perf.h"
-#include "trace-event.h"
-
-#define VERSION "0.5"
-
-#define _STR(x) #x
-#define STR(x) _STR(x)
-#define MAX_PATH 256
-
-#define TRACE_CTRL	"tracing_on"
-#define TRACE		"trace"
-#define AVAILABLE	"available_tracers"
-#define CURRENT		"current_tracer"
-#define ITER_CTRL	"trace_options"
-#define MAX_LATENCY	"tracing_max_latency"
-
-unsigned int page_size;
-
-static const char *output_file = "trace.info";
-static int output_fd;
-
-struct event_list {
-	struct event_list *next;
-	const char *event;
-};
-
-struct events {
-	struct events *sibling;
-	struct events *children;
-	struct events *next;
-	char *name;
-};
-
-
-
-static void die(const char *fmt, ...)
-{
-	va_list ap;
-	int ret = errno;
-
-	if (errno)
-		perror("trace-cmd");
-	else
-		ret = -1;
-
-	va_start(ap, fmt);
-	fprintf(stderr, "  ");
-	vfprintf(stderr, fmt, ap);
-	va_end(ap);
-
-	fprintf(stderr, "\n");
-	exit(ret);
-}
-
-void *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
-
-static const char *find_debugfs(void)
-{
-	const char *path = debugfs_mount(NULL);
-
-	if (!path)
-		die("Your kernel not support debugfs filesystem");
-
-	return path;
-}
-
-/*
- * Finds the path to the debugfs/tracing
- * Allocates the string and stores it.
- */
-static const char *find_tracing_dir(void)
-{
-	static char *tracing;
-	static int tracing_found;
-	const char *debugfs;
-
-	if (tracing_found)
-		return tracing;
-
-	debugfs = find_debugfs();
-
-	tracing = malloc_or_die(strlen(debugfs) + 9);
-
-	sprintf(tracing, "%s/tracing", debugfs);
-
-	tracing_found = 1;
-	return tracing;
-}
-
-static char *get_tracing_file(const char *name)
-{
-	const char *tracing;
-	char *file;
-
-	tracing = find_tracing_dir();
-	if (!tracing)
-		return NULL;
-
-	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
-
-	sprintf(file, "%s/%s", tracing, name);
-	return file;
-}
-
-static void put_tracing_file(char *file)
-{
-	free(file);
-}
-
-static ssize_t calc_data_size;
-
-static ssize_t write_or_die(const void *buf, size_t len)
-{
-	int ret;
-
-	if (calc_data_size) {
-		calc_data_size += len;
-		return len;
-	}
-
-	ret = write(output_fd, buf, len);
-	if (ret < 0)
-		die("writing to '%s'", output_file);
-
-	return ret;
-}
-
-int bigendian(void)
-{
-	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
-	unsigned int *ptr;
-
-	ptr = (unsigned int *)(void *)str;
-	return *ptr == 0x01020304;
-}
-
-static unsigned long long copy_file_fd(int fd)
-{
-	unsigned long long size = 0;
-	char buf[BUFSIZ];
-	int r;
-
-	do {
-		r = read(fd, buf, BUFSIZ);
-		if (r > 0) {
-			size += r;
-			write_or_die(buf, r);
-		}
-	} while (r > 0);
-
-	return size;
-}
-
-static unsigned long long copy_file(const char *file)
-{
-	unsigned long long size = 0;
-	int fd;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		die("Can't read '%s'", file);
-	size = copy_file_fd(fd);
-	close(fd);
-
-	return size;
-}
-
-static unsigned long get_size_fd(int fd)
-{
-	unsigned long long size = 0;
-	char buf[BUFSIZ];
-	int r;
-
-	do {
-		r = read(fd, buf, BUFSIZ);
-		if (r > 0)
-			size += r;
-	} while (r > 0);
-
-	lseek(fd, 0, SEEK_SET);
-
-	return size;
-}
-
-static unsigned long get_size(const char *file)
-{
-	unsigned long long size = 0;
-	int fd;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		die("Can't read '%s'", file);
-	size = get_size_fd(fd);
-	close(fd);
-
-	return size;
-}
-
-static void read_header_files(void)
-{
-	unsigned long long size, check_size;
-	char *path;
-	int fd;
-
-	path = get_tracing_file("events/header_page");
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		die("can't read '%s'", path);
-
-	/* unfortunately, you can not stat debugfs files for size */
-	size = get_size_fd(fd);
-
-	write_or_die("header_page", 12);
-	write_or_die(&size, 8);
-	check_size = copy_file_fd(fd);
-	close(fd);
-
-	if (size != check_size)
-		die("wrong size for '%s' size=%lld read=%lld",
-		    path, size, check_size);
-	put_tracing_file(path);
-
-	path = get_tracing_file("events/header_event");
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		die("can't read '%s'", path);
-
-	size = get_size_fd(fd);
-
-	write_or_die("header_event", 13);
-	write_or_die(&size, 8);
-	check_size = copy_file_fd(fd);
-	if (size != check_size)
-		die("wrong size for '%s'", path);
-	put_tracing_file(path);
-	close(fd);
-}
-
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
-	unsigned long long size, check_size;
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
-		if (ret >= 0) {
-			/* unfortunately, you can not stat debugfs files for size */
-			size = get_size(format);
-			write_or_die(&size, 8);
-			check_size = copy_file(format);
-			if (size != check_size)
-				die("error in size of file '%s'", format);
-		}
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
-static void read_proc_kallsyms(void)
-{
-	unsigned int size, check_size;
-	const char *path = "/proc/kallsyms";
-	struct stat st;
-	int ret;
-
-	ret = stat(path, &st);
-	if (ret < 0) {
-		/* not found */
-		size = 0;
-		write_or_die(&size, 4);
-		return;
-	}
-	size = get_size(path);
-	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
-
-}
-
-static void read_ftrace_printk(void)
-{
-	unsigned int size, check_size;
-	char *path;
-	struct stat st;
-	int ret;
-
-	path = get_tracing_file("printk_formats");
-	ret = stat(path, &st);
-	if (ret < 0) {
-		/* not found */
-		size = 0;
-		write_or_die(&size, 4);
-		goto out;
-	}
-	size = get_size(path);
-	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
-out:
-	put_tracing_file(path);
-}
-
-static struct tracepoint_path *
-get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
-{
-	struct tracepoint_path path, *ppath = &path;
-	int i, nr_tracepoints = 0;
-
-	for (i = 0; i < nb_events; i++) {
-		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
-			continue;
-		++nr_tracepoints;
-		ppath->next = tracepoint_id_to_path(pattrs[i].config);
-		if (!ppath->next)
-			die("%s\n", "No memory to alloc tracepoints list");
-		ppath = ppath->next;
-	}
-
-	return nr_tracepoints > 0 ? path.next : NULL;
-}
-
-bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
-{
-	int i;
-
-	for (i = 0; i < nb_events; i++)
-		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
-			return true;
-
-	return false;
-}
-
-int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
-{
-	char buf[BUFSIZ];
-	struct tracepoint_path *tps = get_tracepoints_path(pattrs, nb_events);
-
-	/*
-	 * What? No tracepoints? No sense writing anything here, bail out.
-	 */
-	if (tps == NULL)
-		return -1;
-
-	output_fd = fd;
-
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
-	read_trace_init(buf[0], buf[0]);
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
-	read_header_files();
-	read_ftrace_files(tps);
-	read_event_files(tps);
-	read_proc_kallsyms();
-	read_ftrace_printk();
-
-	return 0;
-}
-
-ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
-			       int nb_events)
-{
-	ssize_t size;
-	int err = 0;
-
-	calc_data_size = 1;
-	err = read_tracing_data(fd, pattrs, nb_events);
-	size = calc_data_size - 1;
-	calc_data_size = 0;
-
-	if (err < 0)
-		return err;
-
-	return size;
-}
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
deleted file mode 100644
index 489907c..0000000
--- a/tools/perf/util/trace-event-parse.c
+++ /dev/null
@@ -1,234 +0,0 @@
-/*
- * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#define _GNU_SOURCE
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <ctype.h>
-#include <errno.h>
-
-#undef _GNU_SOURCE
-#include "../perf.h"
-#include <lk/util.h>
-#include "trace-event.h"
-
-int header_page_size_size;
-int header_page_ts_size;
-int header_page_data_offset;
-
-struct pevent *perf_pevent;
-static struct pevent *pevent;
-
-bool latency_format;
-
-int read_trace_init(int file_bigendian, int host_bigendian)
-{
-	if (pevent)
-		return 0;
-
-	perf_pevent = pevent_alloc();
-	pevent = perf_pevent;
-
-	pevent_set_file_bigendian(pevent, file_bigendian);
-	pevent_set_host_bigendian(pevent, host_bigendian);
-
-	return 0;
-}
-
-unsigned long long
-raw_field_value(struct event_format *event, const char *name, void *data)
-{
-	struct format_field *field;
-	unsigned long long val;
-
-	field = pevent_find_any_field(event, name);
-	if (!field)
-		return 0ULL;
-
-	pevent_read_number_field(field, data, &val);
-
-	return val;
-}
-
-void *raw_field_ptr(struct event_format *event, const char *name, void *data)
-{
-	struct format_field *field;
-
-	field = pevent_find_any_field(event, name);
-	if (!field)
-		return NULL;
-
-	if (field->flags & FIELD_IS_DYNAMIC) {
-		int offset;
-
-		offset = *(int *)(data + field->offset);
-		offset &= 0xffff;
-
-		return data + offset;
-	}
-
-	return data + field->offset;
-}
-
-int trace_parse_common_type(void *data)
-{
-	struct record record;
-
-	record.data = data;
-	return pevent_data_type(pevent, &record);
-}
-
-struct event_format *trace_find_event(int type)
-{
-	return pevent_find_event(pevent, type);
-}
-
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
-{
-	struct record record;
-	struct trace_seq s;
-	int pid;
-
-	pevent->latency_format = latency_format;
-
-	record.ts = nsecs;
-	record.cpu = cpu;
-	record.size = size;
-	record.data = data;
-	pid = pevent_data_pid(pevent, &record);
-
-	if (!pevent_pid_is_registered(pevent, pid))
-		pevent_register_comm(pevent, comm, pid);
-
-	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
-	trace_seq_do_printf(&s);
-	printf("\n");
-
-#if 0
-	struct event *event;
-	unsigned long secs;
-	unsigned long usecs;
-	int type;
-	int pid;
-
-	secs = nsecs / NSECS_PER_SEC;
-	nsecs -= secs * NSECS_PER_SEC;
-	usecs = nsecs / NSECS_PER_USEC;
-
-	type = trace_parse_common_type(data);
-
-	event = trace_find_event(type);
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
-
-	pid = trace_parse_common_pid(data);
-
-	if (latency_format) {
-		printf("%8.8s-%-5d %3d",
-		       comm, pid, cpu);
-		print_lat_fmt(data, size);
-	} else
-		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
-
-	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
-
-	if (event->flags & EVENT_FL_FAILED) {
-		printf("EVENT '%s' FAILED TO PARSE\n",
-		       event->name);
-		return;
-	}
-
-	pretty_print(data, size, event);
-	printf("\n");
-#endif
-}
-
-void parse_proc_kallsyms(char *file, unsigned int size __unused)
-{
-	unsigned long long addr;
-	char *func;
-	char *line;
-	char *next = NULL;
-	char *addr_str;
-	char *mod;
-	char ch;
-	int ret;
-
-	line = strtok_r(file, "\n", &next);
-	while (line) {
-		mod = NULL;
-		ret = sscanf(line, "%as %c %as\t[%as",
-			     (float *)(void *)&addr_str, /* workaround gcc warning */
-			     &ch,
-			     (float *)(void *)&func,
-			     (float *)(void *)&mod);
-		addr = strtoull(addr_str, NULL, 16);
-		free(addr_str);
-
-		/* truncate the extra ']' */
-		if (mod)
-			mod[strlen(mod) - 1] = 0;
-
-		pevent_register_function(pevent, func, addr, mod);
-		free(func);
-		free(mod);
-
-		line = strtok_r(NULL, "\n", &next);
-	}
-}
-
-void parse_ftrace_printk(char *file, unsigned int size __unused)
-{
-	unsigned long long addr;
-	char *printk;
-	char *line;
-	char *next = NULL;
-	char *addr_str;
-	char *fmt;
-
-	line = strtok_r(file, "\n", &next);
-	while (line) {
-		addr_str = strtok_r(line, ":", &fmt);
-		if (!addr_str) {
-			warning("printk format with empty entry");
-			break;
-		}
-		addr = strtoull(addr_str, NULL, 16);
-		/* fmt still has a space, skip it */
-		printk = strdup(fmt+1);
-		line = strtok_r(NULL, "\n", &next);
-		pevent_register_print_string(pevent, printk, addr);
-	}
-}
-
-int parse_ftrace_file(char *buf, unsigned long size)
-{
-	return pevent_parse_event(pevent, buf, size, "ftrace");
-}
-
-int parse_event_file(char *buf, unsigned long size, char *sys)
-{
-	return pevent_parse_event(pevent, buf, size, sys);
-}
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
deleted file mode 100644
index d42a5a9..0000000
--- a/tools/perf/util/trace-event-read.c
+++ /dev/null
@@ -1,541 +0,0 @@
-/*
- * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#define _FILE_OFFSET_BITS 64
-
-#include <dirent.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
-#include <stdarg.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/wait.h>
-#include <sys/mman.h>
-#include <pthread.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <ctype.h>
-#include <errno.h>
-
-#include "../perf.h"
-#include <lk/util.h>
-#include "trace-event.h"
-
-static int input_fd;
-
-static int read_page;
-
-int file_bigendian;
-int host_bigendian;
-static int long_size;
-
-static unsigned long	page_size;
-
-static ssize_t calc_data_size;
-static bool repipe;
-
-static int do_read(int fd, void *buf, int size)
-{
-	int rsize = size;
-
-	while (size) {
-		int ret = read(fd, buf, size);
-
-		if (ret <= 0)
-			return -1;
-
-		if (repipe) {
-			int retw = write(STDOUT_FILENO, buf, ret);
-
-			if (retw <= 0 || retw != ret)
-				die("repiping input file");
-		}
-
-		size -= ret;
-		buf += ret;
-	}
-
-	return rsize;
-}
-
-static int read_or_die(void *data, int size)
-{
-	int r;
-
-	r = do_read(input_fd, data, size);
-	if (r <= 0)
-		die("reading input file (size expected=%d received=%d)",
-		    size, r);
-
-	if (calc_data_size)
-		calc_data_size += r;
-
-	return r;
-}
-
-/* If it fails, the next read will report it */
-static void skip(int size)
-{
-	char buf[BUFSIZ];
-	int r;
-
-	while (size) {
-		r = size > BUFSIZ ? BUFSIZ : size;
-		read_or_die(buf, r);
-		size -= r;
-	};
-}
-
-static unsigned int read4(void)
-{
-	unsigned int data;
-
-	read_or_die(&data, 4);
-	return __data2host4(perf_pevent, data);
-}
-
-static unsigned long long read8(void)
-{
-	unsigned long long data;
-
-	read_or_die(&data, 8);
-	return __data2host8(perf_pevent, data);
-}
-
-static char *read_string(void)
-{
-	char buf[BUFSIZ];
-	char *str = NULL;
-	int size = 0;
-	off_t r;
-	char c;
-
-	for (;;) {
-		r = read(input_fd, &c, 1);
-		if (r < 0)
-			die("reading input file");
-
-		if (!r)
-			die("no data");
-
-		if (repipe) {
-			int retw = write(STDOUT_FILENO, &c, 1);
-
-			if (retw <= 0 || retw != r)
-				die("repiping input file string");
-		}
-
-		buf[size++] = c;
-
-		if (!c)
-			break;
-	}
-
-	if (calc_data_size)
-		calc_data_size += size;
-
-	str = malloc_or_die(size);
-	memcpy(str, buf, size);
-
-	return str;
-}
-
-static void read_proc_kallsyms(void)
-{
-	unsigned int size;
-	char *buf;
-
-	size = read4();
-	if (!size)
-		return;
-
-	buf = malloc_or_die(size + 1);
-	read_or_die(buf, size);
-	buf[size] = '\0';
-
-	parse_proc_kallsyms(buf, size);
-
-	free(buf);
-}
-
-static void read_ftrace_printk(void)
-{
-	unsigned int size;
-	char *buf;
-
-	size = read4();
-	if (!size)
-		return;
-
-	buf = malloc_or_die(size);
-	read_or_die(buf, size);
-
-	parse_ftrace_printk(buf, size);
-
-	free(buf);
-}
-
-static void read_header_files(void)
-{
-	unsigned long long size;
-	char *header_event;
-	char buf[BUFSIZ];
-
-	read_or_die(buf, 12);
-
-	if (memcmp(buf, "header_page", 12) != 0)
-		die("did not read header page");
-
-	size = read8();
-	skip(size);
-
-	/*
-	 * The size field in the page is of type long,
-	 * use that instead, since it represents the kernel.
-	 */
-	long_size = header_page_size_size;
-
-	read_or_die(buf, 13);
-	if (memcmp(buf, "header_event", 13) != 0)
-		die("did not read header event");
-
-	size = read8();
-	header_event = malloc_or_die(size);
-	read_or_die(header_event, size);
-	free(header_event);
-}
-
-static void read_ftrace_file(unsigned long long size)
-{
-	char *buf;
-
-	buf = malloc_or_die(size);
-	read_or_die(buf, size);
-	parse_ftrace_file(buf, size);
-	free(buf);
-}
-
-static void read_event_file(char *sys, unsigned long long size)
-{
-	char *buf;
-
-	buf = malloc_or_die(size);
-	read_or_die(buf, size);
-	parse_event_file(buf, size, sys);
-	free(buf);
-}
-
-static void read_ftrace_files(void)
-{
-	unsigned long long size;
-	int count;
-	int i;
-
-	count = read4();
-
-	for (i = 0; i < count; i++) {
-		size = read8();
-		read_ftrace_file(size);
-	}
-}
-
-static void read_event_files(void)
-{
-	unsigned long long size;
-	char *sys;
-	int systems;
-	int count;
-	int i,x;
-
-	systems = read4();
-
-	for (i = 0; i < systems; i++) {
-		sys = read_string();
-
-		count = read4();
-		for (x=0; x < count; x++) {
-			size = read8();
-			read_event_file(sys, size);
-		}
-	}
-}
-
-struct cpu_data {
-	unsigned long long	offset;
-	unsigned long long	size;
-	unsigned long long	timestamp;
-	struct record		*next;
-	char			*page;
-	int			cpu;
-	int			index;
-	int			page_size;
-};
-
-static struct cpu_data *cpu_data;
-
-static void update_cpu_data_index(int cpu)
-{
-	cpu_data[cpu].offset += page_size;
-	cpu_data[cpu].size -= page_size;
-	cpu_data[cpu].index = 0;
-}
-
-static void get_next_page(int cpu)
-{
-	off_t save_seek;
-	off_t ret;
-
-	if (!cpu_data[cpu].page)
-		return;
-
-	if (read_page) {
-		if (cpu_data[cpu].size <= page_size) {
-			free(cpu_data[cpu].page);
-			cpu_data[cpu].page = NULL;
-			return;
-		}
-
-		update_cpu_data_index(cpu);
-
-		/* other parts of the code may expect the pointer to not move */
-		save_seek = lseek(input_fd, 0, SEEK_CUR);
-
-		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
-		if (ret == (off_t)-1)
-			die("failed to lseek");
-		ret = read(input_fd, cpu_data[cpu].page, page_size);
-		if (ret < 0)
-			die("failed to read page");
-
-		/* reset the file pointer back */
-		lseek(input_fd, save_seek, SEEK_SET);
-
-		return;
-	}
-
-	munmap(cpu_data[cpu].page, page_size);
-	cpu_data[cpu].page = NULL;
-
-	if (cpu_data[cpu].size <= page_size)
-		return;
-
-	update_cpu_data_index(cpu);
-
-	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
-				  input_fd, cpu_data[cpu].offset);
-	if (cpu_data[cpu].page == MAP_FAILED)
-		die("failed to mmap cpu %d at offset 0x%llx",
-		    cpu, cpu_data[cpu].offset);
-}
-
-static unsigned int type_len4host(unsigned int type_len_ts)
-{
-	if (file_bigendian)
-		return (type_len_ts >> 27) & ((1 << 5) - 1);
-	else
-		return type_len_ts & ((1 << 5) - 1);
-}
-
-static unsigned int ts4host(unsigned int type_len_ts)
-{
-	if (file_bigendian)
-		return type_len_ts & ((1 << 27) - 1);
-	else
-		return type_len_ts >> 5;
-}
-
-static int calc_index(void *ptr, int cpu)
-{
-	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
-}
-
-struct record *trace_peek_data(int cpu)
-{
-	struct record *data;
-	void *page = cpu_data[cpu].page;
-	int idx = cpu_data[cpu].index;
-	void *ptr = page + idx;
-	unsigned long long extend;
-	unsigned int type_len_ts;
-	unsigned int type_len;
-	unsigned int delta;
-	unsigned int length = 0;
-
-	if (cpu_data[cpu].next)
-		return cpu_data[cpu].next;
-
-	if (!page)
-		return NULL;
-
-	if (!idx) {
-		/* FIXME: handle header page */
-		if (header_page_ts_size != 8)
-			die("expected a long long type for timestamp");
-		cpu_data[cpu].timestamp = data2host8(perf_pevent, ptr);
-		ptr += 8;
-		switch (header_page_size_size) {
-		case 4:
-			cpu_data[cpu].page_size = data2host4(perf_pevent, ptr);
-			ptr += 4;
-			break;
-		case 8:
-			cpu_data[cpu].page_size = data2host8(perf_pevent, ptr);
-			ptr += 8;
-			break;
-		default:
-			die("bad long size");
-		}
-		ptr = cpu_data[cpu].page + header_page_data_offset;
-	}
-
-read_again:
-	idx = calc_index(ptr, cpu);
-
-	if (idx >= cpu_data[cpu].page_size) {
-		get_next_page(cpu);
-		return trace_peek_data(cpu);
-	}
-
-	type_len_ts = data2host4(perf_pevent, ptr);
-	ptr += 4;
-
-	type_len = type_len4host(type_len_ts);
-	delta = ts4host(type_len_ts);
-
-	switch (type_len) {
-	case RINGBUF_TYPE_PADDING:
-		if (!delta)
-			die("error, hit unexpected end of page");
-		length = data2host4(perf_pevent, ptr);
-		ptr += 4;
-		length *= 4;
-		ptr += length;
-		goto read_again;
-
-	case RINGBUF_TYPE_TIME_EXTEND:
-		extend = data2host4(perf_pevent, ptr);
-		ptr += 4;
-		extend <<= TS_SHIFT;
-		extend += delta;
-		cpu_data[cpu].timestamp += extend;
-		goto read_again;
-
-	case RINGBUF_TYPE_TIME_STAMP:
-		ptr += 12;
-		break;
-	case 0:
-		length = data2host4(perf_pevent, ptr);
-		ptr += 4;
-		die("here! length=%d", length);
-		break;
-	default:
-		length = type_len * 4;
-		break;
-	}
-
-	cpu_data[cpu].timestamp += delta;
-
-	data = malloc_or_die(sizeof(*data));
-	memset(data, 0, sizeof(*data));
-
-	data->ts = cpu_data[cpu].timestamp;
-	data->size = length;
-	data->data = ptr;
-	ptr += length;
-
-	cpu_data[cpu].index = calc_index(ptr, cpu);
-	cpu_data[cpu].next = data;
-
-	return data;
-}
-
-struct record *trace_read_data(int cpu)
-{
-	struct record *data;
-
-	data = trace_peek_data(cpu);
-	cpu_data[cpu].next = NULL;
-
-	return data;
-}
-
-ssize_t trace_report(int fd, bool __repipe)
-{
-	char buf[BUFSIZ];
-	char test[] = { 23, 8, 68 };
-	char *version;
-	int show_version = 0;
-	int show_funcs = 0;
-	int show_printk = 0;
-	ssize_t size;
-
-	calc_data_size = 1;
-	repipe = __repipe;
-
-	input_fd = fd;
-
-	read_or_die(buf, 3);
-	if (memcmp(buf, test, 3) != 0)
-		die("no trace data in the file");
-
-	read_or_die(buf, 7);
-	if (memcmp(buf, "tracing", 7) != 0)
-		die("not a trace file (missing 'tracing' tag)");
-
-	version = read_string();
-	if (show_version)
-		printf("version = %s\n", version);
-	free(version);
-
-	read_or_die(buf, 1);
-	file_bigendian = buf[0];
-	host_bigendian = bigendian();
-
-	read_trace_init(file_bigendian, host_bigendian);
-
-	read_or_die(buf, 1);
-	long_size = buf[0];
-
-	page_size = read4();
-
-	read_header_files();
-
-	read_ftrace_files();
-	read_event_files();
-	read_proc_kallsyms();
-	read_ftrace_printk();
-
-	size = calc_data_size - 1;
-	calc_data_size = 0;
-	repipe = false;
-
-	if (show_funcs) {
-		pevent_print_funcs(perf_pevent);
-		return size;
-	}
-	if (show_printk) {
-		pevent_print_printk(perf_pevent);
-		return size;
-	}
-
-	return size;
-}
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index cc4f4d5..e97b15a 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -27,7 +27,7 @@
 
 #include "../perf.h"
 #include <lk/util.h>
-#include "trace-event.h"
+#include <trace/trace-event.h>
 
 struct scripting_context *scripting_context;
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
deleted file mode 100644
index 6597c73..0000000
--- a/tools/perf/util/trace-event.h
+++ /dev/null
@@ -1,90 +0,0 @@
-#ifndef _PERF_UTIL_TRACE_EVENT_H
-#define _PERF_UTIL_TRACE_EVENT_H
-
-#include "../../lib/trace/parse-events.h"
-#include "parse-events.h"
-
-extern int header_page_size_size;
-extern int header_page_ts_size;
-extern int header_page_data_offset;
-
-extern bool latency_format;
-extern struct pevent *perf_pevent;
-
-struct scripting_context {
-	void *event_data;
-};
-
-enum {
-	RINGBUF_TYPE_PADDING		= 29,
-	RINGBUF_TYPE_TIME_EXTEND	= 30,
-	RINGBUF_TYPE_TIME_STAMP		= 31,
-};
-
-#ifndef TS_SHIFT
-#define TS_SHIFT		27
-#endif
-
-int bigendian(void);
-
-int read_trace_init(int file_bigendian, int host_bigendian);
-
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm);
-
-struct record *trace_read_data(int cpu);
-int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
-ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
-			       int nb_events);
-
-int parse_ftrace_file(char *buf, unsigned long size);
-int parse_event_file(char *buf, unsigned long size, char *sys);
-
-struct record *trace_peek_data(int cpu);
-struct event_format *trace_find_event(int type);
-
-unsigned long long
-raw_field_value(struct event_format *event, const char *name, void *data);
-void *raw_field_ptr(struct event_format *event, const char *name, void *data);
-
-void parse_proc_kallsyms(char *file, unsigned int size __unused);
-void parse_ftrace_printk(char *file, unsigned int size __unused);
-
-ssize_t trace_report(int fd, bool repipe);
-
-struct scripting_ops {
-	const char *name;
-	int (*start_script) (const char *script, int argc, const char **argv);
-	int (*stop_script) (void);
-	void (*process_event) (int cpu, void *data, int size,
-			       unsigned long long nsecs, char *comm);
-	int (*generate_script) (const char *outfile);
-};
-
-int script_spec_register(const char *spec, struct scripting_ops *ops);
-
-void setup_perl_scripting(void);
-void setup_python_scripting(void);
-
-int trace_parse_common_type(void *data);
-int trace_parse_common_pid(void *data);
-#if 0
-int parse_common_pc(void *data);
-int parse_common_flags(void *data);
-int parse_common_lock_depth(void *data);
-struct event_format *trace_find_event(int id);
-#endif
-struct event_format *trace_find_next_event(struct event_format *event);
-unsigned long long read_size(void *ptr, int size);
-#if 0
-unsigned long long
-raw_field_value(struct event_format *event, const char *name, void *data);
-void *raw_field_ptr(struct event_format *event, const char *name, void *data);
-#endif
-unsigned long long eval_flag(const char *flag);
-
-int common_pc(struct scripting_context *context);
-int common_flags(struct scripting_context *context);
-int common_lock_depth(struct scripting_context *context);
-
-#endif /* _PERF_UTIL_TRACE_EVENT_H */
-- 
1.7.3.1

