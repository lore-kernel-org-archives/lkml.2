Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2BPMBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:01:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2BPMBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:01:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/8] perf, tool: Remove unused functions from debugfs object
Date: Thu, 16 Feb 2012 13:00:45 +0100
Message-Id: <1329393652-6055-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following debugfs object functions are not referenced
within the code:

  int debugfs_valid_entry(const char *path);
  int debugfs_umount(void);
  int debugfs_write(const char *entry, const char *value);
  int debugfs_read(const char *entry, char *buffer, size_t size);
  void debugfs_force_cleanup(void);
  int debugfs_make_path(const char *element, char *buffer, int size);

Removing them.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/debugfs.c |  141 ---------------------------------------------
 tools/perf/util/debugfs.h |    6 --
 2 files changed, 0 insertions(+), 147 deletions(-)

diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index ffc35e7..dd8b193 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/perf/util/debugfs.c
@@ -15,32 +15,6 @@ static const char *debugfs_known_mountpoints[] = {
 	0,
 };
 
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
 static int debugfs_found;
 
 /* find the path to the mounted debugfs */
@@ -97,17 +71,6 @@ int debugfs_valid_mountpoint(const char *debugfs)
 	return 0;
 }
 
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
 static void debugfs_set_tracing_events_path(const char *mountpoint)
 {
 	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
@@ -149,107 +112,3 @@ void debugfs_set_path(const char *mountpoint)
 	snprintf(debugfs_mountpoint, sizeof(debugfs_mountpoint), "%s", mountpoint);
 	debugfs_set_tracing_events_path(mountpoint);
 }
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
-	char path[PATH_MAX + 1];
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
-	char path[PATH_MAX + 1];
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
index 4a878f7..68f3e87 100644
--- a/tools/perf/util/debugfs.h
+++ b/tools/perf/util/debugfs.h
@@ -3,14 +3,8 @@
 
 const char *debugfs_find_mountpoint(void);
 int debugfs_valid_mountpoint(const char *debugfs);
-int debugfs_valid_entry(const char *path);
 char *debugfs_mount(const char *mountpoint);
-int debugfs_umount(void);
 void debugfs_set_path(const char *mountpoint);
-int debugfs_write(const char *entry, const char *value);
-int debugfs_read(const char *entry, char *buffer, size_t size);
-void debugfs_force_cleanup(void);
-int debugfs_make_path(const char *element, char *buffer, int size);
 
 extern char debugfs_mountpoint[];
 extern char tracing_events_path[];
-- 
1.7.4.4

