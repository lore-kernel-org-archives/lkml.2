Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2BQJxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:53:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:53:06 -0500
Date: Fri, 17 Feb 2012 01:52:22 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-e90fda0635401225ca7c2343bea2f6d279347d10@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1327674868-10486-4-git-send-email-jolsa@redhat.com>
References: <1327674868-10486-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add sysfs mountpoint interface
Git-Commit-ID: e90fda0635401225ca7c2343bea2f6d279347d10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:52:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e90fda0635401225ca7c2343bea2f6d279347d10
Gitweb:     http://git.kernel.org/tip/e90fda0635401225ca7c2343bea2f6d279347d10
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 27 Jan 2012 15:34:22 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:27:15 -0200

perf tools: Add sysfs mountpoint interface

Adding sysfs object to provide sysfs mount information in the same way
as debugfs object does.

The object provides following function:
  sysfs_find_mountpoint

which returns the sysfs mount mount.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327674868-10486-4-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile     |    2 +
 tools/perf/util/sysfs.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sysfs.h |    6 ++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8359fa1..e011b50 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -259,6 +259,7 @@ LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/debugfs.h
+LIB_H += util/sysfs.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
@@ -305,6 +306,7 @@ LIB_OBJS += $(OUTPUT)util/build-id.o
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
