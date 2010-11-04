Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0KDPjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41957 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0KDPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:14 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/20] perf: Export debugfs utilities
Date: Thu,  4 Nov 2010 16:36:43 +0100
Message-Id: <1288885016-18295-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export /proc/mounts parser and other debugfs-related helpers for general
use. Also, exit if a valid debugfs mountpoint cannot be found.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile                                     |    8 +-
 tools/lib/lk/Makefile                              |   38 +++
 tools/lib/lk/debugfs.c                             |  256 ++++++++++++++++++
 tools/lib/lk/debugfs.h                             |   31 +++
 tools/lib/lk/types.h                               |   17 ++
 tools/lib/lk/usage.c                               |   80 ++++++
 tools/lib/lk/util.h                                |  285 ++++++++++++++++++++
 tools/perf/Makefile                                |   11 +-
 tools/perf/bench/bench.h                           |    2 +
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-annotate.c                      |    2 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin-diff.c                          |    2 +-
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-probe.c                         |    5 +-
 tools/perf/builtin-record.c                        |    2 +-
 tools/perf/builtin-report.c                        |    2 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-stat.c                          |    2 +-
 tools/perf/builtin-timechart.c                     |    2 +-
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/builtin-trace.c                         |    2 +-
 tools/perf/builtin.h                               |    2 +-
 tools/perf/perf.c                                  |   23 +--
 tools/perf/perf.h                                  |    2 +-
 tools/perf/util/build-id.c                         |    2 +-
 tools/perf/util/cache.h                            |    4 +-
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/config.c                           |    2 +-
 tools/perf/util/cpumap.c                           |    2 +-
 tools/perf/util/debug.c                            |    2 +-
 tools/perf/util/debugfs.c                          |  240 ----------------
 tools/perf/util/debugfs.h                          |   25 --
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/header.h                           |    2 +-
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/include/linux/ctype.h              |    2 +-
 tools/perf/util/map.h                              |    2 +-
 tools/perf/util/parse-events.c                     |    5 +-
 tools/perf/util/parse-options.c                    |    2 +-
 tools/perf/util/probe-event.c                      |    5 +-
 tools/perf/util/probe-finder.c                     |    2 +-
 tools/perf/util/probe-finder.h                     |    2 +-
 tools/perf/util/pstack.c                           |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 tools/perf/util/session.c                          |    2 +-
 tools/perf/util/sort.h                             |    2 +-
 tools/perf/util/string.c                           |    2 +-
 tools/perf/util/svghelper.h                        |    2 +-
 tools/perf/util/thread.c                           |    2 +-
 tools/perf/util/trace-event-info.c                 |    3 +-
 tools/perf/util/trace-event-parse.c                |    2 +-
 tools/perf/util/trace-event-read.c                 |    2 +-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/types.h                            |   17 --
 tools/perf/util/usage.c                            |   80 ------
 tools/perf/util/util.c                             |    2 +-
 tools/perf/util/util.h                             |  285 --------------------
 tools/perf/util/values.c                           |    2 +-
 tools/perf/util/values.h                           |    2 +-
 65 files changed, 782 insertions(+), 728 deletions(-)
 create mode 100644 tools/lib/lk/Makefile
 create mode 100644 tools/lib/lk/debugfs.c
 create mode 100644 tools/lib/lk/debugfs.h
 create mode 100644 tools/lib/lk/types.h
 create mode 100644 tools/lib/lk/usage.c
 create mode 100644 tools/lib/lk/util.h
 delete mode 100644 tools/perf/util/debugfs.c
 delete mode 100644 tools/perf/util/debugfs.h
 delete mode 100644 tools/perf/util/types.h
 delete mode 100644 tools/perf/util/usage.c
 delete mode 100644 tools/perf/util/util.h

diff --git a/tools/Makefile b/tools/Makefile
index 430b25e..d3b1447 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -28,20 +28,24 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 export EXTRA_WARNINGS
 
 # lib includes for submake
-BASIC_CFLAGS = -I$(CURDIR)/lib/trace -I$(CURDIR)/perf -I$(CURDIR)/perf/util/include
+BASIC_CFLAGS = -I$(CURDIR)/lib/trace -I$(CURDIR)/lib -I$(CURDIR)/perf -I$(CURDIR)/perf/util/include
 export BASIC_CFLAGS
 
 PERF_TOP_DIR := $(CURDIR)
 export PERF_TOP_DIR
 
-perf: libparsevent .FORCE
+perf: libparsevent lklib .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
 libparsevent: .FORCE
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
 
+lklib: .FORCE
+	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1)
+
 clean:
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
 
 .PHONY: clean .FORCE
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
new file mode 100644
index 0000000..823bbb5
--- /dev/null
+++ b/tools/lib/lk/Makefile
@@ -0,0 +1,38 @@
+include ../../scripts/Makefile.lib
+
+# guard against environment variables
+LIB_H=
+LIB_OBJS=
+
+LIB_H += debugfs.h
+LIB_H += util.h
+LIB_H += types.h
+
+LIB_OBJS += debugfs.o
+LIB_OBJS += usage.o
+
+LIBFILE = $(LIB_OUTPUT)lklib.a
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS) $(LIBFILE)
+
+.PHONY: clean
diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
new file mode 100644
index 0000000..c4e7ffe
--- /dev/null
+++ b/tools/lib/lk/debugfs.c
@@ -0,0 +1,256 @@
+#include <stdio.h>
+#include <string.h>
+
+#include "util.h"
+#include "debugfs.h"
+
+static int debugfs_premounted;
+static char debugfs_mountpoint[MAX_PATH+1];
+char debugfs_mntpt[MAXPATHLEN];
+
+static const char *debugfs_known_mountpoints[] = {
+	"/sys/kernel/debug/",
+	"/debug/",
+	0,
+};
+
+/* use this to force a umount */
+void debugfs_force_cleanup(void)
+{
+	debugfs_find_mountpoint();
+	debugfs_premounted = 0;
+	debugfs_umount();
+}
+
+/* construct a full path to a debugfs element */
+int debugfs_make_path(const char *element, char *buffer, int size)
+{
+	int len;
+
+	if (strlen(debugfs_mountpoint) == 0) {
+		buffer[0] = '\0';
+		return -1;
+	}
+
+	len = strlen(debugfs_mountpoint) + strlen(element) + 1;
+	if (len >= size)
+		return len+1;
+
+	snprintf(buffer, size-1, "%s/%s", debugfs_mountpoint, element);
+	return 0;
+}
+
+static int debugfs_found;
+
+/* find the path to the mounted debugfs */
+const char *debugfs_find_mountpoint(void)
+{
+	const char **ptr;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return (const char *) debugfs_mountpoint;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) == 0) {
+			debugfs_found = 1;
+			strcpy(debugfs_mountpoint, *ptr);
+			return debugfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		die("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs_mountpoint, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	debugfs_found = 1;
+
+	return debugfs_mountpoint;
+}
+
+/* verify that a mountpoint is actually a debugfs instance */
+
+int debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+
+int debugfs_valid_entry(const char *path)
+{
+	struct stat st;
+
+	if (stat(path, &st))
+		return -errno;
+
+	return 0;
+}
+
+/* mount the debugfs somewhere if it's not mounted */
+
+char *debugfs_mount(const char *mountpoint)
+{
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint()) {
+		debugfs_premounted = 1;
+		return debugfs_mountpoint;
+	}
+
+	/* if not mounted and no argument */
+	if (mountpoint == NULL) {
+		/* see if environment variable set */
+		mountpoint = getenv(LK_DEBUGFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint == NULL)
+			mountpoint = "/sys/kernel/debug";
+	}
+
+	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
+		return NULL;
+
+	/* save the mountpoint */
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+	debugfs_found = 1;
+
+	return debugfs_mountpoint;
+}
+
+/* umount the debugfs */
+
+int debugfs_umount(void)
+{
+	char umountcmd[128];
+	int ret;
+
+	/* if it was already mounted, leave it */
+	if (debugfs_premounted)
+		return 0;
+
+	/* make sure it's a valid mount point */
+	ret = debugfs_valid_mountpoint(debugfs_mountpoint);
+	if (ret)
+		return ret;
+
+	snprintf(umountcmd, sizeof(umountcmd),
+		 "/bin/umount %s", debugfs_mountpoint);
+	return system(umountcmd);
+}
+
+int debugfs_write(const char *entry, const char *value)
+{
+	char path[MAX_PATH+1];
+	int ret, count;
+	int fd;
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+
+	/* verify that it exists */
+	ret = debugfs_valid_entry(path);
+	if (ret)
+		return ret;
+
+	/* get how many chars we're going to write */
+	count = strlen(value);
+
+	/* open the debugfs entry */
+	fd = open(path, O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	while (count > 0) {
+		/* write it */
+		ret = write(fd, value, count);
+		if (ret <= 0) {
+			if (ret == EAGAIN)
+				continue;
+			close(fd);
+			return -errno;
+		}
+		count -= ret;
+	}
+
+	/* close it */
+	close(fd);
+
+	/* return success */
+	return 0;
+}
+
+/*
+ * read a debugfs entry
+ * returns the number of chars read or a negative errno
+ */
+int debugfs_read(const char *entry, char *buffer, size_t size)
+{
+	char path[MAX_PATH+1];
+	int ret;
+	int fd;
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+
+	/* verify that it exists */
+	ret = debugfs_valid_entry(path);
+	if (ret)
+		return ret;
+
+	/* open the debugfs entry */
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	do {
+		/* read it */
+		ret = read(fd, buffer, size);
+		if (ret == 0) {
+			close(fd);
+			return EOF;
+		}
+	} while (ret < 0 && errno == EAGAIN);
+
+	/* close it */
+	close(fd);
+
+	/* make *sure* there's a null character at the end */
+	buffer[ret] = '\0';
+
+	/* return the number of chars read */
+	return ret;
+}
+
+/* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
+int get_debugfs_mntpt(void)
+{
+	const char *path = debugfs_mount(NULL);
+
+	if (path) {
+		strncpy(debugfs_mntpt, path, sizeof(debugfs_mntpt));
+		return 0;
+	}
+	debugfs_mntpt[0] = '\0';
+	return 1;
+}
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
new file mode 100644
index 0000000..5970f0b
--- /dev/null
+++ b/tools/lib/lk/debugfs.h
@@ -0,0 +1,31 @@
+#ifndef __DEBUGFS_H__
+#define __DEBUGFS_H__
+
+#include <sys/mount.h>
+#include <sys/types.h>
+
+#ifndef MAX_PATH
+# define MAX_PATH 256
+#endif
+
+#ifndef STR
+# define _STR(x) #x
+# define STR(x) _STR(x)
+#endif
+
+#define LK_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+
+extern char debugfs_mntpt[];
+
+extern const char *debugfs_find_mountpoint(void);
+extern int debugfs_valid_mountpoint(const char *debugfs);
+extern int debugfs_valid_entry(const char *path);
+extern char *debugfs_mount(const char *mountpoint);
+extern int debugfs_umount(void);
+extern int debugfs_write(const char *entry, const char *value);
+extern int debugfs_read(const char *entry, char *buffer, size_t size);
+extern void debugfs_force_cleanup(void);
+extern int debugfs_make_path(const char *element, char *buffer, int size);
+extern int get_debugfs_mntpt(void);
+
+#endif /* __DEBUGFS_H__ */
diff --git a/tools/lib/lk/types.h b/tools/lib/lk/types.h
new file mode 100644
index 0000000..eda6c0c
--- /dev/null
+++ b/tools/lib/lk/types.h
@@ -0,0 +1,17 @@
+#ifndef __LK_TYPES_H
+#define __LK_TYPES_H
+
+/*
+ * We define u64 as unsigned long long for every architecture
+ * so that we can print it with %Lx without getting warnings.
+ */
+typedef unsigned long long u64;
+typedef signed long long   s64;
+typedef unsigned int	   u32;
+typedef signed int	   s32;
+typedef unsigned short	   u16;
+typedef signed short	   s16;
+typedef unsigned char	   u8;
+typedef signed char	   s8;
+
+#endif /* __LK_TYPES_H */
diff --git a/tools/lib/lk/usage.c b/tools/lib/lk/usage.c
new file mode 100644
index 0000000..e16bf9a
--- /dev/null
+++ b/tools/lib/lk/usage.c
@@ -0,0 +1,80 @@
+/*
+ * GIT - The information manager from hell
+ *
+ * Copyright (C) Linus Torvalds, 2005
+ */
+#include "util.h"
+
+static void report(const char *prefix, const char *err, va_list params)
+{
+	char msg[1024];
+	vsnprintf(msg, sizeof(msg), err, params);
+	fprintf(stderr, " %s%s\n", prefix, msg);
+}
+
+static NORETURN void usage_builtin(const char *err)
+{
+	fprintf(stderr, "\n Usage: %s\n", err);
+	exit(129);
+}
+
+static NORETURN void die_builtin(const char *err, va_list params)
+{
+	report(" Fatal: ", err, params);
+	exit(128);
+}
+
+static void error_builtin(const char *err, va_list params)
+{
+	report(" Error: ", err, params);
+}
+
+static void warn_builtin(const char *warn, va_list params)
+{
+	report(" Warning: ", warn, params);
+}
+
+/* If we are in a dlopen()ed .so write to a global variable would segfault
+ * (ugh), so keep things static. */
+static void (*usage_routine)(const char *err) NORETURN = usage_builtin;
+static void (*die_routine)(const char *err, va_list params) NORETURN = die_builtin;
+static void (*error_routine)(const char *err, va_list params) = error_builtin;
+static void (*warn_routine)(const char *err, va_list params) = warn_builtin;
+
+void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN)
+{
+	die_routine = routine;
+}
+
+void usage(const char *err)
+{
+	usage_routine(err);
+}
+
+void die(const char *err, ...)
+{
+	va_list params;
+
+	va_start(params, err);
+	die_routine(err, params);
+	va_end(params);
+}
+
+int error(const char *err, ...)
+{
+	va_list params;
+
+	va_start(params, err);
+	error_routine(err, params);
+	va_end(params);
+	return -1;
+}
+
+void warning(const char *warn, ...)
+{
+	va_list params;
+
+	va_start(params, warn);
+	warn_routine(warn, params);
+	va_end(params);
+}
diff --git a/tools/lib/lk/util.h b/tools/lib/lk/util.h
new file mode 100644
index 0000000..f380fed
--- /dev/null
+++ b/tools/lib/lk/util.h
@@ -0,0 +1,285 @@
+#ifndef GIT_COMPAT_UTIL_H
+#define GIT_COMPAT_UTIL_H
+
+#define _FILE_OFFSET_BITS 64
+
+#ifndef FLEX_ARRAY
+/*
+ * See if our compiler is known to support flexible array members.
+ */
+#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)
+# define FLEX_ARRAY /* empty */
+#elif defined(__GNUC__)
+# if (__GNUC__ >= 3)
+#  define FLEX_ARRAY /* empty */
+# else
+#  define FLEX_ARRAY 0 /* older GNU extension */
+# endif
+#endif
+
+/*
+ * Otherwise, default to safer but a bit wasteful traditional style
+ */
+#ifndef FLEX_ARRAY
+# define FLEX_ARRAY 1
+#endif
+#endif
+
+#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
+
+#ifdef __GNUC__
+#define TYPEOF(x) (__typeof__(x))
+#else
+#define TYPEOF(x)
+#endif
+
+#define MSB(x, bits) ((x) & TYPEOF(x)(~0ULL << (sizeof(x) * 8 - (bits))))
+#define HAS_MULTI_BITS(i)  ((i) & ((i) - 1))  /* checks if an integer has more than 1 bit set */
+
+/* Approximation of the length of the decimal representation of this type. */
+#define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
+
+#define _ALL_SOURCE 1
+#define _GNU_SOURCE 1
+#define _BSD_SOURCE 1
+#define HAS_BOOL
+
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/stat.h>
+#include <sys/statfs.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <errno.h>
+#include <limits.h>
+#include <sys/param.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/time.h>
+#include <time.h>
+#include <signal.h>
+#include <fnmatch.h>
+#include <assert.h>
+#include <regex.h>
+#include <utime.h>
+#include <sys/wait.h>
+#include <sys/poll.h>
+#include <sys/socket.h>
+#include <sys/ioctl.h>
+#ifndef NO_SYS_SELECT_H
+#include <sys/select.h>
+#endif
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <pwd.h>
+#include <inttypes.h>
+#include "../../../include/linux/magic.h"
+#include "types.h"
+#include <sys/ttydefaults.h>
+
+#ifndef NO_ICONV
+#include <iconv.h>
+#endif
+
+extern const char *graph_line;
+extern const char *graph_dotted_line;
+extern char buildid_dir[];
+
+/* On most systems <limits.h> would have given us this, but
+ * not on some systems (e.g. GNU/Hurd).
+ */
+#ifndef PATH_MAX
+#define PATH_MAX 4096
+#endif
+
+#ifndef PRIuMAX
+#define PRIuMAX "llu"
+#endif
+
+#ifndef PRIu32
+#define PRIu32 "u"
+#endif
+
+#ifndef PRIx32
+#define PRIx32 "x"
+#endif
+
+#ifndef PATH_SEP
+#define PATH_SEP ':'
+#endif
+
+#ifndef STRIP_EXTENSION
+#define STRIP_EXTENSION ""
+#endif
+
+#ifndef has_dos_drive_prefix
+#define has_dos_drive_prefix(path) 0
+#endif
+
+#ifndef is_dir_sep
+#define is_dir_sep(c) ((c) == '/')
+#endif
+
+#ifdef __GNUC__
+#define NORETURN __attribute__((__noreturn__))
+#else
+#define NORETURN
+#ifndef __attribute__
+#define __attribute__(x)
+#endif
+#endif
+
+/* General helper functions */
+extern void usage(const char *err) NORETURN;
+extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
+extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
+extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
+
+#include "../../../include/linux/stringify.h"
+
+#define DIE_IF(cnd)	\
+	do { if (cnd)	\
+		die(" at (" __FILE__ ":" __stringify(__LINE__) "): "	\
+		    __stringify(cnd) "\n");				\
+	} while (0)
+
+
+extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
+
+extern int prefixcmp(const char *str, const char *prefix);
+extern void set_buildid_dir(void);
+extern void disable_buildid_cache(void);
+
+static inline const char *skip_prefix(const char *str, const char *prefix)
+{
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) ? NULL : str + len;
+}
+
+#ifdef __GLIBC_PREREQ
+#if __GLIBC_PREREQ(2, 1)
+#define HAVE_STRCHRNUL
+#endif
+#endif
+
+#ifndef HAVE_STRCHRNUL
+#define strchrnul gitstrchrnul
+static inline char *gitstrchrnul(const char *s, int c)
+{
+	while (*s && *s != c)
+		s++;
+	return (char *)s;
+}
+#endif
+
+/*
+ * Wrappers:
+ */
+extern char *xstrdup(const char *str);
+extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
+
+
+static inline void *zalloc(size_t size)
+{
+	return calloc(1, size);
+}
+
+static inline int has_extension(const char *filename, const char *ext)
+{
+	size_t len = strlen(filename);
+	size_t extlen = strlen(ext);
+
+	return len > extlen && !memcmp(filename + len - extlen, ext, extlen);
+}
+
+/* Sane ctype - no locale, and works with signed chars */
+#undef isascii
+#undef isspace
+#undef isdigit
+#undef isxdigit
+#undef isalpha
+#undef isprint
+#undef isalnum
+#undef tolower
+#undef toupper
+
+extern unsigned char sane_ctype[256];
+#define GIT_SPACE		0x01
+#define GIT_DIGIT		0x02
+#define GIT_ALPHA		0x04
+#define GIT_GLOB_SPECIAL	0x08
+#define GIT_REGEX_SPECIAL	0x10
+#define GIT_PRINT_EXTRA		0x20
+#define GIT_PRINT		0x3E
+#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
+#define isascii(x) (((x) & ~0x7f) == 0)
+#define isspace(x) sane_istest(x,GIT_SPACE)
+#define isdigit(x) sane_istest(x,GIT_DIGIT)
+#define isxdigit(x)	\
+	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
+#define isalpha(x) sane_istest(x,GIT_ALPHA)
+#define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
+#define isprint(x) sane_istest(x,GIT_PRINT)
+#define tolower(x) sane_case((unsigned char)(x), 0x20)
+#define toupper(x) sane_case((unsigned char)(x), 0)
+
+static inline int sane_case(int x, int high)
+{
+	if (sane_istest(x, GIT_ALPHA))
+		x = (x & ~0x20) | high;
+	return x;
+}
+
+#ifndef DIR_HAS_BSD_GROUP_SEMANTICS
+# define FORCE_DIR_SET_GID S_ISGID
+#else
+# define FORCE_DIR_SET_GID 0
+#endif
+
+#ifdef NO_NSEC
+#undef USE_NSEC
+#define ST_CTIME_NSEC(st) 0
+#define ST_MTIME_NSEC(st) 0
+#else
+#ifdef USE_ST_TIMESPEC
+#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctimespec.tv_nsec))
+#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtimespec.tv_nsec))
+#else
+#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctim.tv_nsec))
+#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtim.tv_nsec))
+#endif
+#endif
+
+int mkdir_p(char *path, mode_t mode);
+int copyfile(const char *from, const char *to);
+
+s64 perf_atoll(const char *str);
+char **argv_split(const char *str, int *argcp);
+void argv_free(char **argv);
+bool strglobmatch(const char *str, const char *pat);
+bool strlazymatch(const char *str, const char *pat);
+unsigned long convert_unit(unsigned long value, char *unit);
+
+#ifndef ESC
+#define ESC 27
+#endif
+
+static inline bool is_exit_key(int key)
+{
+	char up;
+	if (key == CTRL('c') || key == ESC)
+		return true;
+	up = toupper(key);
+	return up == 'Q';
+}
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+#endif
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 425a572..d8ef5a5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -270,7 +270,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS += -Iarch/$(ARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -328,7 +328,7 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-EXTRA_LIB_FILE=$(LIB_OUTPUT)libparsevent.a
+EXTRA_LIB_FILES=$(LIB_OUTPUT)libparsevent.a $(LIB_OUTPUT)lklib.a
 
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
@@ -360,16 +360,13 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/debugfs.h
 LIB_H += util/event.h
 LIB_H += util/exec_cmd.h
-LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
-LIB_H += util/util.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
@@ -395,7 +392,6 @@ LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
@@ -412,7 +408,6 @@ LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
-LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
@@ -465,7 +460,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
-PERFLIBS = $(LIB_FILE) $(EXTRA_LIB_FILE)
+PERFLIBS = $(LIB_FILE) $(EXTRA_LIB_FILES)
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..0c7ee07 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,8 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <linux/compiler.h>
+
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 38dae74..1b2f508 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -8,7 +8,7 @@
 #include <ctype.h>
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <lk/util.h>
 #include "../util/parse-options.h"
 #include "../util/header.h"
 #include "bench.h"
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index d1d1b30..37f12ad 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -10,7 +10,7 @@
  */
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <lk/util.h>
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index d9ab3ce..9b05c92 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -11,7 +11,7 @@
  */
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <lk/util.h>
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1478dc6..19f2751 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -7,7 +7,7 @@
  */
 #include "builtin.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 
 #include "util/color.h"
 #include <linux/list.h>
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..4ae8ea2 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -17,7 +17,7 @@
  */
 
 #include "perf.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/parse-options.h"
 #include "builtin.h"
 #include "bench/bench.h"
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index fca1d44..83c0a89 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -12,7 +12,7 @@
 #include "util/session.h"
 #include "util/sort.h"
 #include "util/symbol.h"
-#include "util/util.h"
+#include <lk/util.h>
 
 #include <stdlib.h>
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 97b3970..95901eb 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 34d1e85..3e5d0fc 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fbc512a..76253d7 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 199d5e1..a762878 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -32,13 +32,14 @@
 #include <string.h>
 
 #undef _GNU_SOURCE
+#include <lk/util.h>
+#include <lk/debugfs.h>
+
 #include "perf.h"
 #include "builtin.h"
-#include "util/util.h"
 #include "util/strlist.h"
 #include "util/symbol.h"
 #include "util/debug.h"
-#include "util/debugfs.h"
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ff77b80..936e231 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -12,7 +12,7 @@
 #include "perf.h"
 
 #include "util/build-id.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 55fc1f4..f8564f9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -7,7 +7,7 @@
  */
 #include "builtin.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 
 #include "util/color.h"
 #include <linux/list.h>
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3e98de5..a9ec0c3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..12dabd3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -39,7 +39,7 @@
 
 #include "perf.h"
 #include "builtin.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9bcc38f..fe79fc6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -14,7 +14,7 @@
 
 #include "builtin.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 
 #include "util/color.h"
 #include <linux/list.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b513e40..7ba3759 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -24,7 +24,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 40a6a29..beebd43 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -10,7 +10,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
-#include "util/util.h"
+#include <lk/util.h>
 
 static char const		*script_name;
 static char const		*generate_script_lang;
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 921245b..08e69d2 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -1,7 +1,7 @@
 #ifndef BUILTIN_H
 #define BUILTIN_H
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/strbuf.h"
 
 extern const char perf_version_string[];
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cdd6c03..1fa597c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -6,14 +6,14 @@
  * This is the main hub from which the sub-commands (perf stat,
  * perf top, perf record, perf report, etc.) are started.
  */
-#include "builtin.h"
+#include <lk/debugfs.h>
 
+#include "builtin.h"
 #include "util/exec_cmd.h"
 #include "util/cache.h"
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include "util/debugfs.h"
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -29,8 +29,6 @@ struct pager_config {
 	int val;
 };
 
-static char debugfs_mntpt[MAXPATHLEN];
-
 static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
@@ -85,7 +83,7 @@ static void set_debugfs_path(void)
 {
 	char *path;
 
-	path = getenv(PERF_DEBUGFS_ENVIRONMENT);
+	path = getenv(LK_DEBUGFS_ENVIRONMENT);
 	snprintf(debugfs_path, MAXPATHLEN, "%s/%s", path ?: debugfs_mntpt,
 		 "tracing/events");
 }
@@ -415,17 +413,6 @@ static int run_argv(int *argcp, const char ***argv)
 	return done_alias;
 }
 
-/* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
-static void get_debugfs_mntpt(void)
-{
-	const char *path = debugfs_mount(NULL);
-
-	if (path)
-		strncpy(debugfs_mntpt, path, sizeof(debugfs_mntpt));
-	else
-		debugfs_mntpt[0] = '\0';
-}
-
 int main(int argc, const char **argv)
 {
 	const char *cmd;
@@ -434,7 +421,9 @@ int main(int argc, const char **argv)
 	if (!cmd)
 		cmd = "perf-help";
 	/* get debugfs mount point from /proc/mounts */
-	get_debugfs_mntpt();
+	if(get_debugfs_mntpt())
+		die("cannot find debugfs mountpoint");
+
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 95aaf56..4bfd513 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -91,7 +91,7 @@ void get_term_dimensions(struct winsize *ws);
 #include <sys/syscall.h>
 
 #include "../../include/linux/perf_event.h"
-#include "util/types.h"
+#include <lk/types.h>
 #include <stdbool.h>
 
 /*
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e437edb..ce89873 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2009, 2010 Red Hat Inc.
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
-#include "util.h"
+#include <lk/util.h>
 #include <stdio.h>
 #include "build-id.h"
 #include "event.h"
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 27e9ebe..ce83e82 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -2,9 +2,10 @@
 #define __PERF_CACHE_H
 
 #include <stdbool.h>
-#include "util.h"
+#include <lk/util.h>
 #include "strbuf.h"
 #include "../perf.h"
+#include <linux/compiler.h>
 
 #define CMD_EXEC_PATH "--exec-path"
 #define CMD_PERF_DIR "--perf-dir="
@@ -15,7 +16,6 @@
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
 #define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
 #define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
-#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index f231f43..56fe538 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,7 +15,7 @@
 #include <errno.h>
 #include <math.h>
 
-#include "util.h"
+#include <lk/util.h>
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index e02d78c..bb2f5a0 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -5,7 +5,7 @@
  * Copyright (C) Johannes Schindelin, 2005
  *
  */
-#include "util.h"
+#include <lk/util.h>
 #include "cache.h"
 #include "exec_cmd.h"
 
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 0f9b8d7..8ef8cef 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index f9c7e3a..2b7ce22 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -10,7 +10,7 @@
 #include "color.h"
 #include "event.h"
 #include "debug.h"
-#include "util.h"
+#include <lk/util.h>
 
 int verbose = 0;
 bool dump_trace = false;
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
deleted file mode 100644
index a88fefc..0000000
--- a/tools/perf/util/debugfs.c
+++ /dev/null
@@ -1,240 +0,0 @@
-#include "util.h"
-#include "debugfs.h"
-#include "cache.h"
-
-static int debugfs_premounted;
-static char debugfs_mountpoint[MAX_PATH+1];
-
-static const char *debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug/",
-	"/debug/",
-	0,
-};
-
-/* use this to force a umount */
-void debugfs_force_cleanup(void)
-{
-	debugfs_find_mountpoint();
-	debugfs_premounted = 0;
-	debugfs_umount();
-}
-
-/* construct a full path to a debugfs element */
-int debugfs_make_path(const char *element, char *buffer, int size)
-{
-	int len;
-
-	if (strlen(debugfs_mountpoint) == 0) {
-		buffer[0] = '\0';
-		return -1;
-	}
-
-	len = strlen(debugfs_mountpoint) + strlen(element) + 1;
-	if (len >= size)
-		return len+1;
-
-	snprintf(buffer, size-1, "%s/%s", debugfs_mountpoint, element);
-	return 0;
-}
-
-static int debugfs_found;
-
-/* find the path to the mounted debugfs */
-const char *debugfs_find_mountpoint(void)
-{
-	const char **ptr;
-	char type[100];
-	FILE *fp;
-
-	if (debugfs_found)
-		return (const char *) debugfs_mountpoint;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			debugfs_found = 1;
-			strcpy(debugfs_mountpoint, *ptr);
-			return debugfs_mountpoint;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		die("Can't open /proc/mounts for read");
-
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
-		      debugfs_mountpoint, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		return NULL;
-
-	debugfs_found = 1;
-
-	return debugfs_mountpoint;
-}
-
-/* verify that a mountpoint is actually a debugfs instance */
-
-int debugfs_valid_mountpoint(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-
-int debugfs_valid_entry(const char *path)
-{
-	struct stat st;
-
-	if (stat(path, &st))
-		return -errno;
-
-	return 0;
-}
-
-/* mount the debugfs somewhere if it's not mounted */
-
-char *debugfs_mount(const char *mountpoint)
-{
-	/* see if it's already mounted */
-	if (debugfs_find_mountpoint()) {
-		debugfs_premounted = 1;
-		return debugfs_mountpoint;
-	}
-
-	/* if not mounted and no argument */
-	if (mountpoint == NULL) {
-		/* see if environment variable set */
-		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
-		/* if no environment variable, use default */
-		if (mountpoint == NULL)
-			mountpoint = "/sys/kernel/debug";
-	}
-
-	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
-		return NULL;
-
-	/* save the mountpoint */
-	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
-	debugfs_found = 1;
-
-	return debugfs_mountpoint;
-}
-
-/* umount the debugfs */
-
-int debugfs_umount(void)
-{
-	char umountcmd[128];
-	int ret;
-
-	/* if it was already mounted, leave it */
-	if (debugfs_premounted)
-		return 0;
-
-	/* make sure it's a valid mount point */
-	ret = debugfs_valid_mountpoint(debugfs_mountpoint);
-	if (ret)
-		return ret;
-
-	snprintf(umountcmd, sizeof(umountcmd),
-		 "/bin/umount %s", debugfs_mountpoint);
-	return system(umountcmd);
-}
-
-int debugfs_write(const char *entry, const char *value)
-{
-	char path[MAX_PATH+1];
-	int ret, count;
-	int fd;
-
-	/* construct the path */
-	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
-
-	/* verify that it exists */
-	ret = debugfs_valid_entry(path);
-	if (ret)
-		return ret;
-
-	/* get how many chars we're going to write */
-	count = strlen(value);
-
-	/* open the debugfs entry */
-	fd = open(path, O_RDWR);
-	if (fd < 0)
-		return -errno;
-
-	while (count > 0) {
-		/* write it */
-		ret = write(fd, value, count);
-		if (ret <= 0) {
-			if (ret == EAGAIN)
-				continue;
-			close(fd);
-			return -errno;
-		}
-		count -= ret;
-	}
-
-	/* close it */
-	close(fd);
-
-	/* return success */
-	return 0;
-}
-
-/*
- * read a debugfs entry
- * returns the number of chars read or a negative errno
- */
-int debugfs_read(const char *entry, char *buffer, size_t size)
-{
-	char path[MAX_PATH+1];
-	int ret;
-	int fd;
-
-	/* construct the path */
-	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
-
-	/* verify that it exists */
-	ret = debugfs_valid_entry(path);
-	if (ret)
-		return ret;
-
-	/* open the debugfs entry */
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -errno;
-
-	do {
-		/* read it */
-		ret = read(fd, buffer, size);
-		if (ret == 0) {
-			close(fd);
-			return EOF;
-		}
-	} while (ret < 0 && errno == EAGAIN);
-
-	/* close it */
-	close(fd);
-
-	/* make *sure* there's a null character at the end */
-	buffer[ret] = '\0';
-
-	/* return the number of chars read */
-	return ret;
-}
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
deleted file mode 100644
index 83a0287..0000000
--- a/tools/perf/util/debugfs.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __DEBUGFS_H__
-#define __DEBUGFS_H__
-
-#include <sys/mount.h>
-
-#ifndef MAX_PATH
-# define MAX_PATH 256
-#endif
-
-#ifndef STR
-# define _STR(x) #x
-# define STR(x) _STR(x)
-#endif
-
-extern const char *debugfs_find_mountpoint(void);
-extern int debugfs_valid_mountpoint(const char *debugfs);
-extern int debugfs_valid_entry(const char *path);
-extern char *debugfs_mount(const char *mountpoint);
-extern int debugfs_umount(void);
-extern int debugfs_write(const char *entry, const char *value);
-extern int debugfs_read(const char *entry, char *buffer, size_t size);
-extern void debugfs_force_cleanup(void);
-extern int debugfs_make_path(const char *element, char *buffer, int size);
-
-#endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d7e67b1..0ebd301 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 
-#include "util.h"
+#include <lk/util.h>
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 402ac24..fb6f0eb 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -4,7 +4,7 @@
 #include "../../../include/linux/perf_event.h"
 #include <sys/types.h>
 #include <stdbool.h>
-#include "types.h"
+#include <lk/types.h>
 #include "event.h"
 
 #include <linux/bitmap.h>
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index be22ae6..cfbfd6b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "build-id.h"
 #include "hist.h"
 #include "session.h"
diff --git a/tools/perf/util/include/linux/ctype.h b/tools/perf/util/include/linux/ctype.h
index a53d4ee..0698f26 100644
--- a/tools/perf/util/include/linux/ctype.h
+++ b/tools/perf/util/include/linux/ctype.h
@@ -1 +1 @@
-#include "../util.h"
+#include <lk/util.h>
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 7857579..729469e 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -6,7 +6,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include "types.h"
+#include <lk/types.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..01686b5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,5 +1,7 @@
+#include <lk/util.h>
+#include <lk/debugfs.h>
+
 #include "../../../include/linux/hw_breakpoint.h"
-#include "util.h"
 #include "../perf.h"
 #include "parse-options.h"
 #include "parse-events.h"
@@ -8,7 +10,6 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
-#include "debugfs.h"
 
 int				nr_counters;
 
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 99d02aa..25b57fc 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "parse-options.h"
 #include "cache.h"
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index fcc16e4..5f97d04 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -33,7 +33,9 @@
 #include <limits.h>
 
 #undef _GNU_SOURCE
-#include "util.h"
+#include <lk/util.h>
+#include <lk/debugfs.h>
+
 #include "event.h"
 #include "string.h"
 #include "strlist.h"
@@ -42,7 +44,6 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include "debugfs.h"
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 32b81f7..c7a8bdb 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -35,7 +35,7 @@
 
 #include "event.h"
 #include "debug.h"
-#include "util.h"
+#include <lk/util.h>
 #include "symbol.h"
 #include "probe-finder.h"
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 4507d51..fe0457b 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -2,7 +2,7 @@
 #define _PROBE_FINDER_H
 
 #include <stdbool.h>
-#include "util.h"
+#include <lk/util.h>
 #include "probe-event.h"
 
 #define MAX_PATH_LEN		 256
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index 13d36fa..aacedb8 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -4,7 +4,7 @@
  * (c) 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
 
-#include "util.h"
+#include <lk/util.h>
 #include "pstack.h"
 #include <linux/kernel.h>
 #include <stdlib.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b059dc5..78af7d1 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
+#include <lk/util.h>
 #include "../trace-event.h"
 
 #include <EXTERN.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 9e8d535..524d355 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -28,7 +28,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
+#include <lk/util.h>
 #include "../trace-event.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fa9d652..73cac6a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -9,7 +9,7 @@
 
 #include "session.h"
 #include "sort.h"
-#include "util.h"
+#include <lk/util.h>
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 46e531d..0c68709 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -2,7 +2,7 @@
 #define __PERF_SORT_H
 #include "../builtin.h"
 
-#include "util.h"
+#include <lk/util.h>
 
 #include "color.h"
 #include <linux/list.h>
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0409fc7..881ef63 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "string.h"
 
 #define K 1024LL
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index e078198..ac74b40 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_SVGHELPER_H
 #define __PERF_SVGHELPER_H
 
-#include "types.h"
+#include <lk/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8c72d88..8ab6e09 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include "session.h"
 #include "thread.h"
-#include "util.h"
+#include <lk/util.h>
 #include "debug.h"
 
 /* Skip "." and ".." directories */
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index d5083d8..44831be 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -36,9 +36,10 @@
 #include <stdbool.h>
 #include <linux/kernel.h>
 
+#include <lk/debugfs.h>
+
 #include "../perf.h"
 #include "trace-event.h"
-#include "debugfs.h"
 
 #define VERSION "0.5"
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c1d3097..489907c 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -27,7 +27,7 @@
 
 #undef _GNU_SOURCE
 #include "../perf.h"
-#include "util.h"
+#include <lk/util.h>
 #include "trace-event.h"
 
 int header_page_size_size;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 188e100..d42a5a9 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -37,7 +37,7 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
+#include <lk/util.h>
 #include "trace-event.h"
 
 static int input_fd;
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index f7af2fc..cc4f4d5 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
+#include <lk/util.h>
 #include "trace-event.h"
 
 struct scripting_context *scripting_context;
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
deleted file mode 100644
index 7d6b833..0000000
--- a/tools/perf/util/types.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef __PERF_TYPES_H
-#define __PERF_TYPES_H
-
-/*
- * We define u64 as unsigned long long for every architecture
- * so that we can print it with %Lx without getting warnings.
- */
-typedef unsigned long long u64;
-typedef signed long long   s64;
-typedef unsigned int	   u32;
-typedef signed int	   s32;
-typedef unsigned short	   u16;
-typedef signed short	   s16;
-typedef unsigned char	   u8;
-typedef signed char	   s8;
-
-#endif /* __PERF_TYPES_H */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
deleted file mode 100644
index e16bf9a..0000000
--- a/tools/perf/util/usage.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * GIT - The information manager from hell
- *
- * Copyright (C) Linus Torvalds, 2005
- */
-#include "util.h"
-
-static void report(const char *prefix, const char *err, va_list params)
-{
-	char msg[1024];
-	vsnprintf(msg, sizeof(msg), err, params);
-	fprintf(stderr, " %s%s\n", prefix, msg);
-}
-
-static NORETURN void usage_builtin(const char *err)
-{
-	fprintf(stderr, "\n Usage: %s\n", err);
-	exit(129);
-}
-
-static NORETURN void die_builtin(const char *err, va_list params)
-{
-	report(" Fatal: ", err, params);
-	exit(128);
-}
-
-static void error_builtin(const char *err, va_list params)
-{
-	report(" Error: ", err, params);
-}
-
-static void warn_builtin(const char *warn, va_list params)
-{
-	report(" Warning: ", warn, params);
-}
-
-/* If we are in a dlopen()ed .so write to a global variable would segfault
- * (ugh), so keep things static. */
-static void (*usage_routine)(const char *err) NORETURN = usage_builtin;
-static void (*die_routine)(const char *err, va_list params) NORETURN = die_builtin;
-static void (*error_routine)(const char *err, va_list params) = error_builtin;
-static void (*warn_routine)(const char *err, va_list params) = warn_builtin;
-
-void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN)
-{
-	die_routine = routine;
-}
-
-void usage(const char *err)
-{
-	usage_routine(err);
-}
-
-void die(const char *err, ...)
-{
-	va_list params;
-
-	va_start(params, err);
-	die_routine(err, params);
-	va_end(params);
-}
-
-int error(const char *err, ...)
-{
-	va_list params;
-
-	va_start(params, err);
-	error_routine(err, params);
-	va_end(params);
-	return -1;
-}
-
-void warning(const char *warn, ...)
-{
-	va_list params;
-
-	va_start(params, warn);
-	warn_routine(warn, params);
-	va_end(params);
-}
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 2142656..4f35719 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include <sys/mman.h>
 
 int mkdir_p(char *path, mode_t mode)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
deleted file mode 100644
index f380fed..0000000
--- a/tools/perf/util/util.h
+++ /dev/null
@@ -1,285 +0,0 @@
-#ifndef GIT_COMPAT_UTIL_H
-#define GIT_COMPAT_UTIL_H
-
-#define _FILE_OFFSET_BITS 64
-
-#ifndef FLEX_ARRAY
-/*
- * See if our compiler is known to support flexible array members.
- */
-#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)
-# define FLEX_ARRAY /* empty */
-#elif defined(__GNUC__)
-# if (__GNUC__ >= 3)
-#  define FLEX_ARRAY /* empty */
-# else
-#  define FLEX_ARRAY 0 /* older GNU extension */
-# endif
-#endif
-
-/*
- * Otherwise, default to safer but a bit wasteful traditional style
- */
-#ifndef FLEX_ARRAY
-# define FLEX_ARRAY 1
-#endif
-#endif
-
-#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
-
-#ifdef __GNUC__
-#define TYPEOF(x) (__typeof__(x))
-#else
-#define TYPEOF(x)
-#endif
-
-#define MSB(x, bits) ((x) & TYPEOF(x)(~0ULL << (sizeof(x) * 8 - (bits))))
-#define HAS_MULTI_BITS(i)  ((i) & ((i) - 1))  /* checks if an integer has more than 1 bit set */
-
-/* Approximation of the length of the decimal representation of this type. */
-#define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
-
-#define _ALL_SOURCE 1
-#define _GNU_SOURCE 1
-#define _BSD_SOURCE 1
-#define HAS_BOOL
-
-#include <unistd.h>
-#include <stdio.h>
-#include <sys/stat.h>
-#include <sys/statfs.h>
-#include <fcntl.h>
-#include <stdbool.h>
-#include <stddef.h>
-#include <stdlib.h>
-#include <stdarg.h>
-#include <string.h>
-#include <errno.h>
-#include <limits.h>
-#include <sys/param.h>
-#include <sys/types.h>
-#include <dirent.h>
-#include <sys/time.h>
-#include <time.h>
-#include <signal.h>
-#include <fnmatch.h>
-#include <assert.h>
-#include <regex.h>
-#include <utime.h>
-#include <sys/wait.h>
-#include <sys/poll.h>
-#include <sys/socket.h>
-#include <sys/ioctl.h>
-#ifndef NO_SYS_SELECT_H
-#include <sys/select.h>
-#endif
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <arpa/inet.h>
-#include <netdb.h>
-#include <pwd.h>
-#include <inttypes.h>
-#include "../../../include/linux/magic.h"
-#include "types.h"
-#include <sys/ttydefaults.h>
-
-#ifndef NO_ICONV
-#include <iconv.h>
-#endif
-
-extern const char *graph_line;
-extern const char *graph_dotted_line;
-extern char buildid_dir[];
-
-/* On most systems <limits.h> would have given us this, but
- * not on some systems (e.g. GNU/Hurd).
- */
-#ifndef PATH_MAX
-#define PATH_MAX 4096
-#endif
-
-#ifndef PRIuMAX
-#define PRIuMAX "llu"
-#endif
-
-#ifndef PRIu32
-#define PRIu32 "u"
-#endif
-
-#ifndef PRIx32
-#define PRIx32 "x"
-#endif
-
-#ifndef PATH_SEP
-#define PATH_SEP ':'
-#endif
-
-#ifndef STRIP_EXTENSION
-#define STRIP_EXTENSION ""
-#endif
-
-#ifndef has_dos_drive_prefix
-#define has_dos_drive_prefix(path) 0
-#endif
-
-#ifndef is_dir_sep
-#define is_dir_sep(c) ((c) == '/')
-#endif
-
-#ifdef __GNUC__
-#define NORETURN __attribute__((__noreturn__))
-#else
-#define NORETURN
-#ifndef __attribute__
-#define __attribute__(x)
-#endif
-#endif
-
-/* General helper functions */
-extern void usage(const char *err) NORETURN;
-extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
-extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
-extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
-
-#include "../../../include/linux/stringify.h"
-
-#define DIE_IF(cnd)	\
-	do { if (cnd)	\
-		die(" at (" __FILE__ ":" __stringify(__LINE__) "): "	\
-		    __stringify(cnd) "\n");				\
-	} while (0)
-
-
-extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
-
-extern int prefixcmp(const char *str, const char *prefix);
-extern void set_buildid_dir(void);
-extern void disable_buildid_cache(void);
-
-static inline const char *skip_prefix(const char *str, const char *prefix)
-{
-	size_t len = strlen(prefix);
-	return strncmp(str, prefix, len) ? NULL : str + len;
-}
-
-#ifdef __GLIBC_PREREQ
-#if __GLIBC_PREREQ(2, 1)
-#define HAVE_STRCHRNUL
-#endif
-#endif
-
-#ifndef HAVE_STRCHRNUL
-#define strchrnul gitstrchrnul
-static inline char *gitstrchrnul(const char *s, int c)
-{
-	while (*s && *s != c)
-		s++;
-	return (char *)s;
-}
-#endif
-
-/*
- * Wrappers:
- */
-extern char *xstrdup(const char *str);
-extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
-
-
-static inline void *zalloc(size_t size)
-{
-	return calloc(1, size);
-}
-
-static inline int has_extension(const char *filename, const char *ext)
-{
-	size_t len = strlen(filename);
-	size_t extlen = strlen(ext);
-
-	return len > extlen && !memcmp(filename + len - extlen, ext, extlen);
-}
-
-/* Sane ctype - no locale, and works with signed chars */
-#undef isascii
-#undef isspace
-#undef isdigit
-#undef isxdigit
-#undef isalpha
-#undef isprint
-#undef isalnum
-#undef tolower
-#undef toupper
-
-extern unsigned char sane_ctype[256];
-#define GIT_SPACE		0x01
-#define GIT_DIGIT		0x02
-#define GIT_ALPHA		0x04
-#define GIT_GLOB_SPECIAL	0x08
-#define GIT_REGEX_SPECIAL	0x10
-#define GIT_PRINT_EXTRA		0x20
-#define GIT_PRINT		0x3E
-#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
-#define isascii(x) (((x) & ~0x7f) == 0)
-#define isspace(x) sane_istest(x,GIT_SPACE)
-#define isdigit(x) sane_istest(x,GIT_DIGIT)
-#define isxdigit(x)	\
-	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
-#define isalpha(x) sane_istest(x,GIT_ALPHA)
-#define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
-#define isprint(x) sane_istest(x,GIT_PRINT)
-#define tolower(x) sane_case((unsigned char)(x), 0x20)
-#define toupper(x) sane_case((unsigned char)(x), 0)
-
-static inline int sane_case(int x, int high)
-{
-	if (sane_istest(x, GIT_ALPHA))
-		x = (x & ~0x20) | high;
-	return x;
-}
-
-#ifndef DIR_HAS_BSD_GROUP_SEMANTICS
-# define FORCE_DIR_SET_GID S_ISGID
-#else
-# define FORCE_DIR_SET_GID 0
-#endif
-
-#ifdef NO_NSEC
-#undef USE_NSEC
-#define ST_CTIME_NSEC(st) 0
-#define ST_MTIME_NSEC(st) 0
-#else
-#ifdef USE_ST_TIMESPEC
-#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctimespec.tv_nsec))
-#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtimespec.tv_nsec))
-#else
-#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctim.tv_nsec))
-#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtim.tv_nsec))
-#endif
-#endif
-
-int mkdir_p(char *path, mode_t mode);
-int copyfile(const char *from, const char *to);
-
-s64 perf_atoll(const char *str);
-char **argv_split(const char *str, int *argcp);
-void argv_free(char **argv);
-bool strglobmatch(const char *str, const char *pat);
-bool strlazymatch(const char *str, const char *pat);
-unsigned long convert_unit(unsigned long value, char *unit);
-
-#ifndef ESC
-#define ESC 27
-#endif
-
-static inline bool is_exit_key(int key)
-{
-	char up;
-	if (key == CTRL('c') || key == ESC)
-		return true;
-	up = toupper(key);
-	return up == 'Q';
-}
-
-#define _STR(x) #x
-#define STR(x) _STR(x)
-
-#endif
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index cfa55d6..648fc48 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -1,6 +1,6 @@
 #include <stdlib.h>
 
-#include "util.h"
+#include <lk/util.h>
 #include "values.h"
 
 void perf_read_values_init(struct perf_read_values *values)
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index 2fa967e..f762cb7 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_VALUES_H
 #define __PERF_VALUES_H
 
-#include "types.h"
+#include <lk/types.h>
 
 struct perf_read_values {
 	int threads;
-- 
1.7.3.1

