Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2BPMC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:02:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2BPMBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:01:36 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/8] perf, tool: Add sysfs mountpoint interface
Date: Thu, 16 Feb 2012 13:00:46 +0100
Message-Id: <1329393652-6055-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding sysfs object to provide sysfs mount information
in the same way as debugfs object does.

The object provides following function:
  sysfs_find_mountpoint

which returns the sysfs mount mount.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile     |    2 +
 tools/perf/util/sysfs.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sysfs.h |    6 ++++
 3 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/sysfs.c
 create mode 100644 tools/perf/util/sysfs.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64df5de..7124381 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -256,6 +256,7 @@ LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/debugfs.h
+LIB_H += util/sysfs.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
@@ -302,6 +303,7 @@ LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/debugfs.o
+LIB_OBJS += $(OUTPUT)util/sysfs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
diff --git a/tools/perf/util/sysfs.c b/tools/perf/util/sysfs.c
new file mode 100644
index 0000000..48c6902
--- /dev/null
+++ b/tools/perf/util/sysfs.c
@@ -0,0 +1,60 @@
+
+#include "util.h"
+#include "sysfs.h"
+
+static const char * const sysfs_known_mountpoints[] = {
+	"/sys",
+	0,
+};
+
+static int sysfs_found;
+char sysfs_mountpoint[PATH_MAX];
+
+static int sysfs_valid_mountpoint(const char *sysfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(sysfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) SYSFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+const char *sysfs_find_mountpoint(void)
+{
+	const char * const *ptr;
+	char type[100];
+	FILE *fp;
+
+	if (sysfs_found)
+		return (const char *) sysfs_mountpoint;
+
+	ptr = sysfs_known_mountpoints;
+	while (*ptr) {
+		if (sysfs_valid_mountpoint(*ptr) == 0) {
+			sysfs_found = 1;
+			strcpy(sysfs_mountpoint, *ptr);
+			return sysfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		return NULL;
+
+	while (!sysfs_found &&
+	       fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
+		      sysfs_mountpoint, type) == 2) {
+
+		if (strcmp(type, "sysfs") == 0)
+			sysfs_found = 1;
+	}
+
+	fclose(fp);
+
+	return sysfs_found ? sysfs_mountpoint : NULL;
+}
diff --git a/tools/perf/util/sysfs.h b/tools/perf/util/sysfs.h
new file mode 100644
index 0000000..a813b72
--- /dev/null
+++ b/tools/perf/util/sysfs.h
@@ -0,0 +1,6 @@
+#ifndef __SYSFS_H__
+#define __SYSFS_H__
+
+const char *sysfs_find_mountpoint(void);
+
+#endif /* __DEBUGFS_H__ */
-- 
1.7.4.4

