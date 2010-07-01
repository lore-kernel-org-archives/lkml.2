Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0GAP6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:58:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47063 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab0GAPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/21] perf: Export /proc/mounts parser
Date: Thu,  1 Jul 2010 17:55:53 +0200
Message-Id: <1277999763-20357-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Carve out relevant debugfs setup utils for general use.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/debugfs.c         |   25 +++++++++++++++++++++++++
 tools/lib/lk/debugfs.h         |    5 +++++
 tools/perf/perf.c              |   27 ++++-----------------------
 tools/perf/util/parse-events.c |    2 --
 tools/perf/util/parse-events.h |    1 -
 5 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index bbe3a83..8ef3fa6 100644
--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -3,6 +3,8 @@
 
 static int debugfs_premounted;
 static char debugfs_mountpoint[MAX_PATH+1];
+char debugfs_mntpt[MAXPATHLEN];
+char debugfs_path[MAXPATHLEN];
 
 static const char *debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug/",
@@ -237,3 +239,26 @@ int debugfs_read(const char *entry, char *buffer, size_t size)
 	/* return the number of chars read */
 	return ret;
 }
+
+void set_debugfs_path(void)
+{
+	char *path;
+
+	path = getenv(PERF_DEBUGFS_ENVIRONMENT);
+	snprintf(debugfs_path, MAXPATHLEN, "%s/%s", path ?: debugfs_mntpt,
+		 "tracing/events");
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
+
+	debugfs_mntpt[0] = '\0';
+	return 1;
+}
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
index 8c02e72..1187fa8 100644
--- a/tools/lib/lk/debugfs.h
+++ b/tools/lib/lk/debugfs.h
@@ -14,6 +14,9 @@
 
 #define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
+extern char debugfs_path[];
+extern char debugfs_mntpt[];
+
 extern const char *debugfs_find_mountpoint(void);
 extern int debugfs_valid_mountpoint(const char *debugfs);
 extern int debugfs_valid_entry(const char *path);
@@ -23,5 +26,7 @@ extern int debugfs_write(const char *entry, const char *value);
 extern int debugfs_read(const char *entry, char *buffer, size_t size);
 extern void debugfs_force_cleanup(void);
 extern int debugfs_make_path(const char *element, char *buffer, int size);
+extern int get_debugfs_mntpt(void);
+extern void set_debugfs_path(void);
 
 #endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index b92b3fd..58c1a56 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -32,8 +32,6 @@ struct pager_config {
 	int val;
 };
 
-static char debugfs_mntpt[MAXPATHLEN];
-
 static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
@@ -84,15 +82,6 @@ static void commit_pager_choice(void)
 	}
 }
 
-static void set_debugfs_path(void)
-{
-	char *path;
-
-	path = getenv(PERF_DEBUGFS_ENVIRONMENT);
-	snprintf(debugfs_path, MAXPATHLEN, "%s/%s", path ?: debugfs_mntpt,
-		 "tracing/events");
-}
-
 static int handle_options(const char ***argv, int *argc, int *envchanged)
 {
 	int handled = 0;
@@ -418,17 +407,6 @@ static int run_argv(int *argcp, const char ***argv)
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
@@ -436,8 +414,11 @@ int main(int argc, const char **argv)
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
+
 	/* get debugfs mount point from /proc/mounts */
-	get_debugfs_mntpt();
+	if (get_debugfs_mntpt())
+		die("Can't establish valid debugfs mountpoint!\n");
+
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f298a43..215d4f3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -29,8 +29,6 @@ enum event_result {
 	EVT_HANDLED_ALL
 };
 
-char debugfs_path[MAXPATHLEN];
-
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fc4ab3f..436c831 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -30,7 +30,6 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 extern void print_events(void);
 
-extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
 
-- 
1.7.1

