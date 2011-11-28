Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1K1XTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:19:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48692 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab1K1XOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/25] perf tools: Eliminate duplicate code and use PATH_MAX consistently
Date: Mon, 28 Nov 2011 21:14:02 -0200
Message-Id: <1322522066-21879-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need for multiple definitions for STR() and die(), also use SuSv2's
PATH_MAX instead of adding MAX_PATH.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qpujjkw7u0bf0tr4wt55cr9y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c         |    1 -
 tools/perf/util/cgroup.c           |   15 +++++++--------
 tools/perf/util/debugfs.c          |   12 ++++++------
 tools/perf/util/debugfs.h          |   29 +++++++++--------------------
 tools/perf/util/probe-finder.h     |    1 -
 tools/perf/util/trace-event-info.c |   28 ++--------------------------
 6 files changed, 24 insertions(+), 62 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 710ae3d..59d43ab 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -46,7 +46,6 @@
 
 #define DEFAULT_VAR_FILTER "!__k???tab_* & !__crc_*"
 #define DEFAULT_FUNC_FILTER "!_*"
-#define MAX_PATH_LEN 256
 
 /* Session management structure */
 static struct {
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 96bee5c..dbe2f16 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -3,7 +3,6 @@
 #include "parse-options.h"
 #include "evsel.h"
 #include "cgroup.h"
-#include "debugfs.h" /* MAX_PATH, STR() */
 #include "evlist.h"
 
 int nr_cgroups;
@@ -12,7 +11,7 @@ static int
 cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 {
 	FILE *fp;
-	char mountpoint[MAX_PATH+1], tokens[MAX_PATH+1], type[MAX_PATH+1];
+	char mountpoint[PATH_MAX + 1], tokens[PATH_MAX + 1], type[PATH_MAX + 1];
 	char *token, *saved_ptr = NULL;
 	int found = 0;
 
@@ -25,8 +24,8 @@ cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 	 * and inspect every cgroupfs mount point to find one that has
 	 * perf_event subsystem
 	 */
-	while (fscanf(fp, "%*s %"STR(MAX_PATH)"s %"STR(MAX_PATH)"s %"
-				STR(MAX_PATH)"s %*d %*d\n",
+	while (fscanf(fp, "%*s %"STR(PATH_MAX)"s %"STR(PATH_MAX)"s %"
+				STR(PATH_MAX)"s %*d %*d\n",
 				mountpoint, type, tokens) == 3) {
 
 		if (!strcmp(type, "cgroup")) {
@@ -57,15 +56,15 @@ cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 
 static int open_cgroup(char *name)
 {
-	char path[MAX_PATH+1];
-	char mnt[MAX_PATH+1];
+	char path[PATH_MAX + 1];
+	char mnt[PATH_MAX + 1];
 	int fd;
 
 
-	if (cgroupfs_find_mountpoint(mnt, MAX_PATH+1))
+	if (cgroupfs_find_mountpoint(mnt, PATH_MAX + 1))
 		return -1;
 
-	snprintf(path, MAX_PATH, "%s/%s", mnt, name);
+	snprintf(path, PATH_MAX, "%s/%s", mnt, name);
 
 	fd = open(path, O_RDONLY);
 	if (fd == -1)
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index a88fefc..680be34 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/perf/util/debugfs.c
@@ -2,8 +2,10 @@
 #include "debugfs.h"
 #include "cache.h"
 
+#include <sys/mount.h>
+
 static int debugfs_premounted;
-static char debugfs_mountpoint[MAX_PATH+1];
+static char debugfs_mountpoint[PATH_MAX + 1];
 
 static const char *debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug/",
@@ -64,9 +66,7 @@ const char *debugfs_find_mountpoint(void)
 	if (fp == NULL)
 		die("Can't open /proc/mounts for read");
 
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
+	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
 		      debugfs_mountpoint, type) == 2) {
 		if (strcmp(type, "debugfs") == 0)
 			break;
@@ -158,7 +158,7 @@ int debugfs_umount(void)
 
 int debugfs_write(const char *entry, const char *value)
 {
-	char path[MAX_PATH+1];
+	char path[PATH_MAX + 1];
 	int ret, count;
 	int fd;
 
@@ -203,7 +203,7 @@ int debugfs_write(const char *entry, const char *value)
  */
 int debugfs_read(const char *entry, char *buffer, size_t size)
 {
-	char path[MAX_PATH+1];
+	char path[PATH_MAX + 1];
 	int ret;
 	int fd;
 
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
index 83a0287..8cd3fa0 100644
--- a/tools/perf/util/debugfs.h
+++ b/tools/perf/util/debugfs.h
@@ -1,25 +1,14 @@
 #ifndef __DEBUGFS_H__
 #define __DEBUGFS_H__
 
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
+const char *debugfs_find_mountpoint(void);
+int debugfs_valid_mountpoint(const char *debugfs);
+int debugfs_valid_entry(const char *path);
+char *debugfs_mount(const char *mountpoint);
+int debugfs_umount(void);
+int debugfs_write(const char *entry, const char *value);
+int debugfs_read(const char *entry, char *buffer, size_t size);
+void debugfs_force_cleanup(void);
+int debugfs_make_path(const char *element, char *buffer, int size);
 
 #endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 1132c8f..17e94d0 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -5,7 +5,6 @@
 #include "util.h"
 #include "probe-event.h"
 
-#define MAX_PATH_LEN		 256
 #define MAX_PROBE_BUFFER	1024
 #define MAX_PROBES		 128
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index d2655f0..ac6830d 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -18,7 +18,8 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#define _GNU_SOURCE
+#include <ctype.h>
+#include "util.h"
 #include <dirent.h>
 #include <mntent.h>
 #include <stdio.h>
@@ -31,7 +32,6 @@
 #include <pthread.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
 #include <linux/list.h>
@@ -44,10 +44,6 @@
 
 #define VERSION "0.5"
 
-#define _STR(x) #x
-#define STR(x) _STR(x)
-#define MAX_PATH 256
-
 #define TRACE_CTRL	"tracing_on"
 #define TRACE		"trace"
 #define AVAILABLE	"available_tracers"
@@ -73,26 +69,6 @@ struct events {
 };
 
 
-
-static void die(const char *fmt, ...)
-{
-	va_list ap;
-	int ret = errno;
-
-	if (errno)
-		perror("perf");
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
 void *malloc_or_die(unsigned int size)
 {
 	void *data;
-- 
1.7.8.rc0.35.gee6df

