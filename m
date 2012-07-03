Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab2GCWCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab2GCWBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:41 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/10] perf, tool: Add sysfs read file interface
Date: Wed,  4 Jul 2012 00:00:46 +0200
Message-Id: <1341352848-11833-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding read file interface to access sysfs files data.

  int sysfs_read_file(const char *file, char *buf, size_t size)

The 'file' argument is file path relative to the sysfs mount.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/sysfs.c |   19 +++++++++++++++++++
 tools/perf/util/sysfs.h |    1 +
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/util/sysfs.c b/tools/perf/util/sysfs.c
index 48c6902..4ee886a 100644
--- a/tools/perf/util/sysfs.c
+++ b/tools/perf/util/sysfs.c
@@ -58,3 +58,22 @@ const char *sysfs_find_mountpoint(void)
 
 	return sysfs_found ? sysfs_mountpoint : NULL;
 }
+
+int sysfs_read_file(const char *file, char *buf, size_t size)
+{
+	char path[PATH_MAX];
+	FILE *fp;
+	int ret = 0;
+
+	snprintf(path, PATH_MAX, "%s/%s", sysfs_mountpoint, file);
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -errno;
+
+	if (fread(buf, 1, size, fp) == 0)
+		ret = -errno;
+
+	fclose(fp);
+	return ret;
+}
diff --git a/tools/perf/util/sysfs.h b/tools/perf/util/sysfs.h
index a813b72..5ce99e7 100644
--- a/tools/perf/util/sysfs.h
+++ b/tools/perf/util/sysfs.h
@@ -2,5 +2,6 @@
 #define __SYSFS_H__
 
 const char *sysfs_find_mountpoint(void);
+int sysfs_read_file(const char *file, char *buf, size_t size);
 
 #endif /* __DEBUGFS_H__ */
-- 
1.7.10.4

