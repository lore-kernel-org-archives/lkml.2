Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0KDPmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:42:06 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41982 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0KDPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:26 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/20] perf: Export util.ch into library
Date: Thu,  4 Nov 2010 16:36:46 +0100
Message-Id: <1288885016-18295-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is needed for sharing common functionality.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile          |    1 +
 tools/lib/lk/cpumap.c          |    1 +
 tools/lib/lk/util.c            |  116 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/perf/Makefile        |    1 +
 tools/lib/perf/util.h          |    8 +++
 tools/perf/Makefile            |    1 -
 tools/perf/perf.h              |    3 -
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/util.c         |  116 ----------------------------------------
 9 files changed, 128 insertions(+), 120 deletions(-)
 create mode 100644 tools/lib/lk/util.c
 create mode 100644 tools/lib/perf/util.h
 delete mode 100644 tools/perf/util/util.c

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index ff94b2e..985214a 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -11,6 +11,7 @@ LIB_H += cpumap.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
+LIB_OBJS += util.o
 LIB_OBJS += cpumap.o
 LIB_OBJS += ctype.o
 
diff --git a/tools/lib/lk/cpumap.c b/tools/lib/lk/cpumap.c
index 7c3008a..0c6c12c 100644
--- a/tools/lib/lk/cpumap.c
+++ b/tools/lib/lk/cpumap.c
@@ -1,4 +1,5 @@
 #include <lk/util.h>
+#include <perf/util.h>
 #include <perf.h>
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/lib/lk/util.c b/tools/lib/lk/util.c
new file mode 100644
index 0000000..4f35719
--- /dev/null
+++ b/tools/lib/lk/util.c
@@ -0,0 +1,116 @@
+#include <lk/util.h>
+#include <sys/mman.h>
+
+int mkdir_p(char *path, mode_t mode)
+{
+	struct stat st;
+	int err;
+	char *d = path;
+
+	if (*d != '/')
+		return -1;
+
+	if (stat(path, &st) == 0)
+		return 0;
+
+	while (*++d == '/');
+
+	while ((d = strchr(d, '/'))) {
+		*d = '\0';
+		err = stat(path, &st) && mkdir(path, mode);
+		*d++ = '/';
+		if (err)
+			return -1;
+		while (*d == '/')
+			++d;
+	}
+	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
+}
+
+static int slow_copyfile(const char *from, const char *to)
+{
+	int err = 0;
+	char *line = NULL;
+	size_t n;
+	FILE *from_fp = fopen(from, "r"), *to_fp;
+
+	if (from_fp == NULL)
+		goto out;
+
+	to_fp = fopen(to, "w");
+	if (to_fp == NULL)
+		goto out_fclose_from;
+
+	while (getline(&line, &n, from_fp) > 0)
+		if (fputs(line, to_fp) == EOF)
+			goto out_fclose_to;
+	err = 0;
+out_fclose_to:
+	fclose(to_fp);
+	free(line);
+out_fclose_from:
+	fclose(from_fp);
+out:
+	return err;
+}
+
+int copyfile(const char *from, const char *to)
+{
+	int fromfd, tofd;
+	struct stat st;
+	void *addr;
+	int err = -1;
+
+	if (stat(from, &st))
+		goto out;
+
+	if (st.st_size == 0) /* /proc? do it slowly... */
+		return slow_copyfile(from, to);
+
+	fromfd = open(from, O_RDONLY);
+	if (fromfd < 0)
+		goto out;
+
+	tofd = creat(to, 0755);
+	if (tofd < 0)
+		goto out_close_from;
+
+	addr = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fromfd, 0);
+	if (addr == MAP_FAILED)
+		goto out_close_to;
+
+	if (write(tofd, addr, st.st_size) == st.st_size)
+		err = 0;
+
+	munmap(addr, st.st_size);
+out_close_to:
+	close(tofd);
+	if (err)
+		unlink(to);
+out_close_from:
+	close(fromfd);
+out:
+	return err;
+}
+
+unsigned long convert_unit(unsigned long value, char *unit)
+{
+	*unit = ' ';
+
+	if (value > 1000) {
+		value /= 1000;
+		*unit = 'K';
+	}
+
+	if (value > 1000) {
+		value /= 1000;
+		*unit = 'M';
+	}
+
+	if (value > 1000) {
+		value /= 1000;
+		*unit = 'G';
+	}
+
+	return value;
+}
diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index 9942d52..5815664 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -5,6 +5,7 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += mmap.h
+LIB_H += util.h
 
 LIB_OBJS += mmap.o
 
diff --git a/tools/lib/perf/util.h b/tools/lib/perf/util.h
new file mode 100644
index 0000000..4b774b9
--- /dev/null
+++ b/tools/lib/perf/util.h
@@ -0,0 +1,8 @@
+#ifndef __PERF_UTIL_H
+#define __PERF_UTIL_H
+
+#define MAX_COUNTERS			256
+#define MAX_NR_CPUS			256
+
+#endif /* __PERF_UTIL_H */
+
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e8c1ada..6d06417 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -427,7 +427,6 @@ LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 4bfd513..785a200 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -136,9 +136,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 		       group_fd, flags);
 }
 
-#define MAX_COUNTERS			256
-#define MAX_NR_CPUS			256
-
 struct ip_callchain {
 	u64 nr;
 	u64 ips[0];
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fc4ab3f..9492e3c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -3,6 +3,7 @@
 /*
  * Parse symbolic events/counts passed in as options:
  */
+#include <perf/util.h>
 
 struct option;
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
deleted file mode 100644
index 4f35719..0000000
--- a/tools/perf/util/util.c
+++ /dev/null
@@ -1,116 +0,0 @@
-#include <lk/util.h>
-#include <sys/mman.h>
-
-int mkdir_p(char *path, mode_t mode)
-{
-	struct stat st;
-	int err;
-	char *d = path;
-
-	if (*d != '/')
-		return -1;
-
-	if (stat(path, &st) == 0)
-		return 0;
-
-	while (*++d == '/');
-
-	while ((d = strchr(d, '/'))) {
-		*d = '\0';
-		err = stat(path, &st) && mkdir(path, mode);
-		*d++ = '/';
-		if (err)
-			return -1;
-		while (*d == '/')
-			++d;
-	}
-	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
-}
-
-static int slow_copyfile(const char *from, const char *to)
-{
-	int err = 0;
-	char *line = NULL;
-	size_t n;
-	FILE *from_fp = fopen(from, "r"), *to_fp;
-
-	if (from_fp == NULL)
-		goto out;
-
-	to_fp = fopen(to, "w");
-	if (to_fp == NULL)
-		goto out_fclose_from;
-
-	while (getline(&line, &n, from_fp) > 0)
-		if (fputs(line, to_fp) == EOF)
-			goto out_fclose_to;
-	err = 0;
-out_fclose_to:
-	fclose(to_fp);
-	free(line);
-out_fclose_from:
-	fclose(from_fp);
-out:
-	return err;
-}
-
-int copyfile(const char *from, const char *to)
-{
-	int fromfd, tofd;
-	struct stat st;
-	void *addr;
-	int err = -1;
-
-	if (stat(from, &st))
-		goto out;
-
-	if (st.st_size == 0) /* /proc? do it slowly... */
-		return slow_copyfile(from, to);
-
-	fromfd = open(from, O_RDONLY);
-	if (fromfd < 0)
-		goto out;
-
-	tofd = creat(to, 0755);
-	if (tofd < 0)
-		goto out_close_from;
-
-	addr = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fromfd, 0);
-	if (addr == MAP_FAILED)
-		goto out_close_to;
-
-	if (write(tofd, addr, st.st_size) == st.st_size)
-		err = 0;
-
-	munmap(addr, st.st_size);
-out_close_to:
-	close(tofd);
-	if (err)
-		unlink(to);
-out_close_from:
-	close(fromfd);
-out:
-	return err;
-}
-
-unsigned long convert_unit(unsigned long value, char *unit)
-{
-	*unit = ' ';
-
-	if (value > 1000) {
-		value /= 1000;
-		*unit = 'K';
-	}
-
-	if (value > 1000) {
-		value /= 1000;
-		*unit = 'M';
-	}
-
-	if (value > 1000) {
-		value /= 1000;
-		*unit = 'G';
-	}
-
-	return value;
-}
-- 
1.7.3.1

