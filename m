Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1K1XOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:14:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:34285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1K1XOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/25] perf tools: Simplify debugfs mountpoint handling code
Date: Mon, 28 Nov 2011 21:14:03 -0200
Message-Id: <1322522066-21879-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We don't need to have two PATH_MAX char sized arrays holding it, just
one in util/debugfs.c will do.

Also rename debugfs_path to tracing_events_path, as it is not the path
to debugfs, that is debugfs_mountpoint. Both are now accessible.

This will allow accessing this code in the perf python binding without
having to drag in perf.c and util/parse-events.c.

The defaults for these variables are the canonical "/sys/kernel/debug"
and "/sys/kernel/debug/tracing/events/", removing the need for simple
tools to call debugfs_mount(NULL).

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ug9jvtjrsqbluuhqqxpvg30f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c      |    3 ++-
 tools/perf/perf.c              |   33 ++++-----------------------------
 tools/perf/util/debugfs.c      |   25 ++++++++++++++++++++-----
 tools/perf/util/debugfs.h      |    4 ++++
 tools/perf/util/parse-events.c |   28 +++++++++++++---------------
 tools/perf/util/parse-events.h |    1 -
 6 files changed, 43 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 831d1ba..77d68bf 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -7,6 +7,7 @@
 
 #include "util/cache.h"
 #include "util/debug.h"
+#include "util/debugfs.h"
 #include "util/evlist.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -247,7 +248,7 @@ static int trace_event__id(const char *evname)
 
 	if (asprintf(&filename,
 		     "%s/syscalls/%s/id",
-		     debugfs_path, evname) < 0)
+		     tracing_events_path, evname) < 0)
 		return -1;
 
 	fd = open(filename, O_RDONLY);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 73d0cac..2b2e225 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -29,8 +29,6 @@ struct pager_config {
 	int val;
 };
 
-static char debugfs_mntpt[MAXPATHLEN];
-
 static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
@@ -81,15 +79,6 @@ static void commit_pager_choice(void)
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
@@ -161,15 +150,14 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				fprintf(stderr, "No directory given for --debugfs-dir.\n");
 				usage(perf_usage_string);
 			}
-			strncpy(debugfs_mntpt, (*argv)[1], MAXPATHLEN);
-			debugfs_mntpt[MAXPATHLEN - 1] = '\0';
+			debugfs_set_path((*argv)[1]);
 			if (envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
 		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
-			strncpy(debugfs_mntpt, cmd + strlen(CMD_DEBUGFS_DIR), MAXPATHLEN);
-			debugfs_mntpt[MAXPATHLEN - 1] = '\0';
+			debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
+			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
 			if (envchanged)
 				*envchanged = 1;
 		} else {
@@ -281,7 +269,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	if (use_pager == -1 && p->option & USE_PAGER)
 		use_pager = 1;
 	commit_pager_choice();
-	set_debugfs_path();
 
 	status = p->fn(argc, argv, prefix);
 	exit_browser(status);
@@ -416,17 +403,6 @@ static int run_argv(int *argcp, const char ***argv)
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
 static void pthread__block_sigwinch(void)
 {
 	sigset_t set;
@@ -453,7 +429,7 @@ int main(int argc, const char **argv)
 	if (!cmd)
 		cmd = "perf-help";
 	/* get debugfs mount point from /proc/mounts */
-	get_debugfs_mntpt();
+	debugfs_mount(NULL);
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
@@ -476,7 +452,6 @@ int main(int argc, const char **argv)
 	argc--;
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
-	set_debugfs_path();
 	set_buildid_dir();
 
 	if (argc > 0) {
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index 680be34..ffc35e7 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/perf/util/debugfs.c
@@ -2,10 +2,12 @@
 #include "debugfs.h"
 #include "cache.h"
 
+#include <linux/kernel.h>
 #include <sys/mount.h>
 
 static int debugfs_premounted;
-static char debugfs_mountpoint[PATH_MAX + 1];
+char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
+char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
 
 static const char *debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug/",
@@ -64,7 +66,7 @@ const char *debugfs_find_mountpoint(void)
 	/* give up and parse /proc/mounts */
 	fp = fopen("/proc/mounts", "r");
 	if (fp == NULL)
-		die("Can't open /proc/mounts for read");
+		return NULL;
 
 	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
 		      debugfs_mountpoint, type) == 2) {
@@ -106,6 +108,12 @@ int debugfs_valid_entry(const char *path)
 	return 0;
 }
 
+static void debugfs_set_tracing_events_path(const char *mountpoint)
+{
+	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
+		 mountpoint, "tracing/events");
+}
+
 /* mount the debugfs somewhere if it's not mounted */
 
 char *debugfs_mount(const char *mountpoint)
@@ -113,7 +121,7 @@ char *debugfs_mount(const char *mountpoint)
 	/* see if it's already mounted */
 	if (debugfs_find_mountpoint()) {
 		debugfs_premounted = 1;
-		return debugfs_mountpoint;
+		goto out;
 	}
 
 	/* if not mounted and no argument */
@@ -129,12 +137,19 @@ char *debugfs_mount(const char *mountpoint)
 		return NULL;
 
 	/* save the mountpoint */
-	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
 	debugfs_found = 1;
-
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+out:
+	debugfs_set_tracing_events_path(debugfs_mountpoint);
 	return debugfs_mountpoint;
 }
 
+void debugfs_set_path(const char *mountpoint)
+{
+	snprintf(debugfs_mountpoint, sizeof(debugfs_mountpoint), "%s", mountpoint);
+	debugfs_set_tracing_events_path(mountpoint);
+}
+
 /* umount the debugfs */
 
 int debugfs_umount(void)
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
index 8cd3fa0..4a878f7 100644
--- a/tools/perf/util/debugfs.h
+++ b/tools/perf/util/debugfs.h
@@ -6,9 +6,13 @@ int debugfs_valid_mountpoint(const char *debugfs);
 int debugfs_valid_entry(const char *path);
 char *debugfs_mount(const char *mountpoint);
 int debugfs_umount(void);
+void debugfs_set_path(const char *mountpoint);
 int debugfs_write(const char *entry, const char *value);
 int debugfs_read(const char *entry, char *buffer, size_t size);
 void debugfs_force_cleanup(void);
 int debugfs_make_path(const char *element, char *buffer, int size);
 
+extern char debugfs_mountpoint[];
+extern char tracing_events_path[];
+
 #endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 928918b..586ab3f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -25,8 +25,6 @@ enum event_result {
 	EVT_HANDLED_ALL
 };
 
-char debugfs_path[MAXPATHLEN];
-
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
@@ -140,7 +138,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	char evt_path[MAXPATHLEN];
 	int fd;
 
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", tracing_events_path,
 			sys_dir->d_name, evt_dir->d_name);
 	fd = open(evt_path, O_RDONLY);
 	if (fd < 0)
@@ -171,16 +169,16 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (debugfs_valid_mountpoint(debugfs_path))
+	if (debugfs_valid_mountpoint(tracing_events_path))
 		return NULL;
 
-	sys_dir = opendir(debugfs_path);
+	sys_dir = opendir(tracing_events_path);
 	if (!sys_dir)
 		return NULL;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
 
-		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", tracing_events_path,
 			 sys_dirent.d_name);
 		evt_dir = opendir(dir_path);
 		if (!evt_dir)
@@ -447,7 +445,7 @@ parse_single_tracepoint_event(char *sys_name,
 	u64 id;
 	int fd;
 
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", tracing_events_path,
 		 sys_name, evt_name);
 
 	fd = open(evt_path, O_RDONLY);
@@ -485,7 +483,7 @@ parse_multiple_tracepoint_event(struct perf_evlist *evlist, char *sys_name,
 	struct dirent *evt_ent;
 	DIR *evt_dir;
 
-	snprintf(evt_path, MAXPATHLEN, "%s/%s", debugfs_path, sys_name);
+	snprintf(evt_path, MAXPATHLEN, "%s/%s", tracing_events_path, sys_name);
 	evt_dir = opendir(evt_path);
 
 	if (!evt_dir) {
@@ -528,7 +526,7 @@ parse_tracepoint_event(struct perf_evlist *evlist, const char **strp,
 	char sys_name[MAX_EVENT_LENGTH];
 	unsigned int sys_length, evt_length;
 
-	if (debugfs_valid_mountpoint(debugfs_path))
+	if (debugfs_valid_mountpoint(tracing_events_path))
 		return 0;
 
 	evt_name = strchr(*strp, ':');
@@ -920,10 +918,10 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (debugfs_valid_mountpoint(debugfs_path))
+	if (debugfs_valid_mountpoint(tracing_events_path))
 		return;
 
-	sys_dir = opendir(debugfs_path);
+	sys_dir = opendir(tracing_events_path);
 	if (!sys_dir)
 		return;
 
@@ -932,7 +930,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
 		    !strglobmatch(sys_dirent.d_name, subsys_glob))
 			continue;
 
-		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", tracing_events_path,
 			 sys_dirent.d_name);
 		evt_dir = opendir(dir_path);
 		if (!evt_dir)
@@ -964,16 +962,16 @@ int is_valid_tracepoint(const char *event_string)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (debugfs_valid_mountpoint(debugfs_path))
+	if (debugfs_valid_mountpoint(tracing_events_path))
 		return 0;
 
-	sys_dir = opendir(debugfs_path);
+	sys_dir = opendir(tracing_events_path);
 	if (!sys_dir)
 		return 0;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
 
-		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", tracing_events_path,
 			 sys_dirent.d_name);
 		evt_dir = opendir(dir_path);
 		if (!evt_dir)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2f8e375..7e0cbe7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -39,7 +39,6 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob);
 int print_hwcache_events(const char *event_glob);
 extern int is_valid_tracepoint(const char *event_string);
 
-extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
 #endif /* __PERF_PARSE_EVENTS_H */
-- 
1.7.8.rc0.35.gee6df

