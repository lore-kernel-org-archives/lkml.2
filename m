Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1BRKjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:39:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:53346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176Ab1BRKjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:39:13 -0500
Date: Fri, 18 Feb 2011 10:38:49 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list: Allow filtering list of events
Message-ID: <tip-668b8788f497b2386402daeca583d6300240d41d@git.kernel.org>
Git-Commit-ID: 668b8788f497b2386402daeca583d6300240d41d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:38:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  668b8788f497b2386402daeca583d6300240d41d
Gitweb:     http://git.kernel.org/tip/668b8788f497b2386402daeca583d6300240d41d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Feb 2011 15:38:58 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Feb 2011 15:38:58 -0200

perf list: Allow filtering list of events

The man page has the details, here are some examples:

[root@emilia ~]# perf list *fault*  *:*wait*

List of pre-defined events (to be used in -e):
  page-faults OR faults                      [Software event]
  minor-faults                               [Software event]
  major-faults                               [Software event]
  alignment-faults                           [Software event]
  emulation-faults                           [Software event]

  radeon:radeon_fence_wait_begin             [Tracepoint event]
  radeon:radeon_fence_wait_end               [Tracepoint event]
  writeback:wbc_writeback_wait               [Tracepoint event]
  writeback:wbc_balance_dirty_wait           [Tracepoint event]
  writeback:writeback_congestion_wait        [Tracepoint event]
  writeback:writeback_wait_iff_congested     [Tracepoint event]
  sched:sched_wait_task                      [Tracepoint event]
  sched:sched_process_wait                   [Tracepoint event]
  sched:sched_stat_wait                      [Tracepoint event]
  sched:sched_stat_iowait                    [Tracepoint event]
  syscalls:sys_enter_epoll_wait              [Tracepoint event]
  syscalls:sys_exit_epoll_wait               [Tracepoint event]
  syscalls:sys_enter_epoll_pwait             [Tracepoint event]
  syscalls:sys_exit_epoll_pwait              [Tracepoint event]
  syscalls:sys_enter_rt_sigtimedwait         [Tracepoint event]
  syscalls:sys_exit_rt_sigtimedwait          [Tracepoint event]
  syscalls:sys_enter_waitid                  [Tracepoint event]
  syscalls:sys_exit_waitid                   [Tracepoint event]
  syscalls:sys_enter_wait4                   [Tracepoint event]
  syscalls:sys_exit_wait4                    [Tracepoint event]
  syscalls:sys_enter_waitpid                 [Tracepoint event]
  syscalls:sys_exit_waitpid                  [Tracepoint event]
[root@emilia ~]#

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |   23 +++++++-
 tools/perf/builtin-list.c              |   43 ++++++++++++++-
 tools/perf/util/parse-events.c         |   94 ++++++++++++++++++++++++++------
 tools/perf/util/parse-events.h         |    5 ++-
 4 files changed, 142 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 399751b..7a527f7 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -8,7 +8,7 @@ perf-list - List all symbolic event types
 SYNOPSIS
 --------
 [verse]
-'perf list'
+'perf list' [hw|sw|cache|tracepoint|event_glob]
 
 DESCRIPTION
 -----------
@@ -63,7 +63,26 @@ details. Some of them are referenced in the SEE ALSO section below.
 
 OPTIONS
 -------
-None
+
+Without options all known events will be listed.
+
+To limit the list use:
+
+. 'hw' or 'hardware' to list hardware events such as cache-misses, etc.
+
+. 'sw' or 'software' to list software events such as context switches, etc.
+
+. 'cache' or 'hwcache' to list hardware cache events such as L1-dcache-loads, etc.
+
+. 'tracepoint' to list all tracepoint events, alternatively use
+  'subsys_glob:event_glob' to filter by tracepoint subsystems such as sched,
+  block, etc.
+
+. If none of the above is matched, it will apply the supplied glob to all
+  events, printing the ones that match.
+
+One or more types can be used at the same time, listing the events for the
+types specified.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index d88c696..6313b6e 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2009, Thomas Gleixner <tglx@linutronix.de>
  * Copyright (C) 2008-2009, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
  */
 #include "builtin.h"
 
@@ -13,9 +14,47 @@
 #include "util/parse-events.h"
 #include "util/cache.h"
 
-int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
+int cmd_list(int argc, const char **argv, const char *prefix __used)
 {
 	setup_pager();
-	print_events();
+
+	if (argc == 1)
+		print_events(NULL);
+	else {
+		int i;
+
+		for (i = 1; i < argc; ++i) {
+			if (i > 1)
+				putchar('\n');
+			if (strncmp(argv[i], "tracepoint", 10) == 0)
+				print_tracepoint_events(NULL, NULL);
+			else if (strcmp(argv[i], "hw") == 0 ||
+				 strcmp(argv[i], "hardware") == 0)
+				print_events_type(PERF_TYPE_HARDWARE);
+			else if (strcmp(argv[i], "sw") == 0 ||
+				 strcmp(argv[i], "software") == 0)
+				print_events_type(PERF_TYPE_SOFTWARE);
+			else if (strcmp(argv[i], "cache") == 0 ||
+				 strcmp(argv[i], "hwcache") == 0)
+				print_hwcache_events(NULL);
+			else {
+				char *sep = strchr(argv[i], ':'), *s;
+				int sep_idx;
+
+				if (sep == NULL) {
+					print_events(argv[i]);
+					continue;
+				}
+				sep_idx = sep - argv[i];
+				s = strdup(argv[i]);
+				if (s == NULL)
+					return -1;
+
+				s[sep_idx] = '\0';
+				print_tracepoint_events(s, s + sep_idx + 1);
+				free(s);
+			}
+		}
+	}
 	return 0;
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 80a3dd5..54a7e26 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -858,7 +858,7 @@ static const char * const event_type_descriptors[] = {
  * Print the events from <debugfs_mount_point>/tracing/events
  */
 
-static void print_tracepoint_events(void)
+void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
@@ -873,6 +873,9 @@ static void print_tracepoint_events(void)
 		return;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+		if (subsys_glob != NULL && 
+		    !strglobmatch(sys_dirent.d_name, subsys_glob))
+			continue;
 
 		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
 			 sys_dirent.d_name);
@@ -881,6 +884,10 @@ static void print_tracepoint_events(void)
 			continue;
 
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+			if (event_glob != NULL && 
+			    !strglobmatch(evt_dirent.d_name, event_glob))
+				continue;
+
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
 			printf("  %-42s [%s]\n", evt_path,
@@ -932,13 +939,61 @@ int is_valid_tracepoint(const char *event_string)
 	return 0;
 }
 
+void print_events_type(u8 type)
+{
+	struct event_symbol *syms = event_symbols;
+	unsigned int i;
+	char name[64];
+
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
+		if (type != syms->type)
+			continue;
+
+		if (strlen(syms->alias))
+			snprintf(name, sizeof(name),  "%s OR %s",
+				 syms->symbol, syms->alias);
+		else
+			snprintf(name, sizeof(name), "%s", syms->symbol);
+
+		printf("  %-42s [%s]\n", name,
+			event_type_descriptors[type]);
+	}
+}
+
+int print_hwcache_events(const char *event_glob)
+{
+	unsigned int type, op, i, printed = 0;
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				char *name = event_cache_name(type, op, i);
+
+				if (event_glob != NULL && 
+				    !strglobmatch(name, event_glob))
+					continue;
+
+				printf("  %-42s [%s]\n", name,
+					event_type_descriptors[PERF_TYPE_HW_CACHE]);
+				++printed;
+			}
+		}
+	}
+
+	return printed;
+}
+
 /*
  * Print the help text for the event symbols:
  */
-void print_events(void)
+void print_events(const char *event_glob)
 {
 	struct event_symbol *syms = event_symbols;
-	unsigned int i, type, op, prev_type = -1;
+	unsigned int i, type, prev_type = -1, printed = 0, ntypes_printed = 0;
 	char name[40];
 
 	printf("\n");
@@ -947,8 +1002,16 @@ void print_events(void)
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
 		type = syms->type;
 
-		if (type != prev_type)
+		if (type != prev_type && printed) {
 			printf("\n");
+			printed = 0;
+			ntypes_printed++;
+		}
+
+		if (event_glob != NULL && 
+		    !(strglobmatch(syms->symbol, event_glob) ||
+		      (syms->alias && strglobmatch(syms->alias, event_glob))))
+			continue;
 
 		if (strlen(syms->alias))
 			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
@@ -958,22 +1021,17 @@ void print_events(void)
 			event_type_descriptors[type]);
 
 		prev_type = type;
+		++printed;
 	}
 
-	printf("\n");
-	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
-		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
-			/* skip invalid cache type */
-			if (!is_cache_op_valid(type, op))
-				continue;
-
-			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				printf("  %-42s [%s]\n",
-					event_cache_name(type, op, i),
-					event_type_descriptors[PERF_TYPE_HW_CACHE]);
-			}
-		}
+	if (ntypes_printed) {
+		printed = 0;
+		printf("\n");
 	}
+	print_hwcache_events(event_glob);
+
+	if (event_glob != NULL)
+		return;
 
 	printf("\n");
 	printf("  %-42s [%s]\n",
@@ -986,7 +1044,7 @@ void print_events(void)
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 	printf("\n");
 
-	print_tracepoint_events();
+	print_tracepoint_events(NULL, NULL);
 
 	exit(129);
 }
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index cf7e94a..212f88e 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -28,7 +28,10 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-extern void print_events(void);
+void print_events(const char *event_glob);
+void print_events_type(u8 type);
+void print_tracepoint_events(const char *subsys_glob, const char *event_glob);
+int print_hwcache_events(const char *event_glob);
 extern int is_valid_tracepoint(const char *event_string);
 
 extern char debugfs_path[];
