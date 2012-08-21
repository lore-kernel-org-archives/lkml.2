Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2HUPkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:40:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60028 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab2HUPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:40:15 -0400
Date: Tue, 21 Aug 2012 08:39:54 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-a3277d2d5a0d5d9492993ab68af8a8dc96760dd1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@gmail.com, jolsa@redhat.com
In-Reply-To: <1344522713-27951-3-git-send-email-fweisbec@gmail.com>
References: <1344522713-27951-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Support for events bash completion
Git-Commit-ID: a3277d2d5a0d5d9492993ab68af8a8dc96760dd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:40:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3277d2d5a0d5d9492993ab68af8a8dc96760dd1
Gitweb:     http://git.kernel.org/tip/a3277d2d5a0d5d9492993ab68af8a8dc96760dd1
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 9 Aug 2012 16:31:52 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 15:59:26 -0300

perf tools: Support for events bash completion

Add basic bash completion for the -e option in record, top and stat
subcommands. Only hardware, software and tracepoint events are
supported.

Breakpoints, raw events and events grouping completion need more
thinking.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344522713-27951-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion     |    6 +++-
 tools/perf/builtin-list.c      |   14 ++++---
 tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++---------------
 tools/perf/util/parse-events.h |    7 ++--
 4 files changed, 61 insertions(+), 36 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 9a31fa5..1958fa5 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -6,7 +6,7 @@ _perf()
 	local cur cmd
 
 	COMPREPLY=()
-	_get_comp_words_by_ref cur
+	_get_comp_words_by_ref cur prev
 
 	cmd=${COMP_WORDS[0]}
 
@@ -14,6 +14,10 @@ _perf()
 	if [ $COMP_CWORD -eq 1 ]; then
 		cmds=$($cmd --list-cmds)
 		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+	# List possible events for -e option
+	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
+		cmds=$($cmd list --raw-dump)
+		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
 	# Fall down to list regular files
 	else
 		_filedir
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 6313b6e..bdcff81 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,15 +19,15 @@ int cmd_list(int argc, const char **argv, const char *prefix __used)
 	setup_pager();
 
 	if (argc == 1)
-		print_events(NULL);
+		print_events(NULL, false);
 	else {
 		int i;
 
 		for (i = 1; i < argc; ++i) {
-			if (i > 1)
+			if (i > 2)
 				putchar('\n');
 			if (strncmp(argv[i], "tracepoint", 10) == 0)
-				print_tracepoint_events(NULL, NULL);
+				print_tracepoint_events(NULL, NULL, false);
 			else if (strcmp(argv[i], "hw") == 0 ||
 				 strcmp(argv[i], "hardware") == 0)
 				print_events_type(PERF_TYPE_HARDWARE);
@@ -36,13 +36,15 @@ int cmd_list(int argc, const char **argv, const char *prefix __used)
 				print_events_type(PERF_TYPE_SOFTWARE);
 			else if (strcmp(argv[i], "cache") == 0 ||
 				 strcmp(argv[i], "hwcache") == 0)
-				print_hwcache_events(NULL);
+				print_hwcache_events(NULL, false);
+			else if (strcmp(argv[i], "--raw-dump") == 0)
+				print_events(NULL, true);
 			else {
 				char *sep = strchr(argv[i], ':'), *s;
 				int sep_idx;
 
 				if (sep == NULL) {
-					print_events(argv[i]);
+					print_events(argv[i], false);
 					continue;
 				}
 				sep_idx = sep - argv[i];
@@ -51,7 +53,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __used)
 					return -1;
 
 				s[sep_idx] = '\0';
-				print_tracepoint_events(s, s + sep_idx + 1);
+				print_tracepoint_events(s, s + sep_idx + 1, false);
 				free(s);
 			}
 		}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8bdfa3e..3ec4bfc 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -799,7 +799,8 @@ static const char * const event_type_descriptors[] = {
  * Print the events from <debugfs_mount_point>/tracing/events
  */
 
-void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
+void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
+			     bool name_only)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
@@ -829,6 +830,11 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
 			    !strglobmatch(evt_dirent.d_name, event_glob))
 				continue;
 
+			if (name_only) {
+				printf("%s:%s ", sys_dirent.d_name, evt_dirent.d_name);
+				continue;
+			}
+
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
 			printf("  %-50s [%s]\n", evt_path,
@@ -906,7 +912,7 @@ void print_events_type(u8 type)
 		__print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
 }
 
-int print_hwcache_events(const char *event_glob)
+int print_hwcache_events(const char *event_glob, bool name_only)
 {
 	unsigned int type, op, i, printed = 0;
 	char name[64];
@@ -923,8 +929,11 @@ int print_hwcache_events(const char *event_glob)
 				if (event_glob != NULL && !strglobmatch(name, event_glob))
 					continue;
 
-				printf("  %-50s [%s]\n", name,
-					event_type_descriptors[PERF_TYPE_HW_CACHE]);
+				if (name_only)
+					printf("%s ", name);
+				else
+					printf("  %-50s [%s]\n", name,
+					       event_type_descriptors[PERF_TYPE_HW_CACHE]);
 				++printed;
 			}
 		}
@@ -934,7 +943,8 @@ int print_hwcache_events(const char *event_glob)
 }
 
 static void print_symbol_events(const char *event_glob, unsigned type,
-				struct event_symbol *syms, unsigned max)
+				struct event_symbol *syms, unsigned max,
+				bool name_only)
 {
 	unsigned i, printed = 0;
 	char name[MAX_NAME_LEN];
@@ -946,6 +956,11 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 		      (syms->alias && strglobmatch(syms->alias, event_glob))))
 			continue;
 
+		if (name_only) {
+			printf("%s ", syms->symbol);
+			continue;
+		}
+
 		if (strlen(syms->alias))
 			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
 		else
@@ -963,39 +978,42 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 /*
  * Print the help text for the event symbols:
  */
-void print_events(const char *event_glob)
+void print_events(const char *event_glob, bool name_only)
 {
-
-	printf("\n");
-	printf("List of pre-defined events (to be used in -e):\n");
+	if (!name_only) {
+		printf("\n");
+		printf("List of pre-defined events (to be used in -e):\n");
+	}
 
 	print_symbol_events(event_glob, PERF_TYPE_HARDWARE,
-			    event_symbols_hw, PERF_COUNT_HW_MAX);
+			    event_symbols_hw, PERF_COUNT_HW_MAX, name_only);
 
 	print_symbol_events(event_glob, PERF_TYPE_SOFTWARE,
-			    event_symbols_sw, PERF_COUNT_SW_MAX);
+			    event_symbols_sw, PERF_COUNT_SW_MAX, name_only);
 
-	print_hwcache_events(event_glob);
+	print_hwcache_events(event_glob, name_only);
 
 	if (event_glob != NULL)
 		return;
 
-	printf("\n");
-	printf("  %-50s [%s]\n",
-	       "rNNN",
-	       event_type_descriptors[PERF_TYPE_RAW]);
-	printf("  %-50s [%s]\n",
-	       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
-	       event_type_descriptors[PERF_TYPE_RAW]);
-	printf("   (see 'perf list --help' on how to encode it)\n");
-	printf("\n");
-
-	printf("  %-50s [%s]\n",
-			"mem:<addr>[:access]",
+	if (!name_only) {
+		printf("\n");
+		printf("  %-50s [%s]\n",
+		       "rNNN",
+		       event_type_descriptors[PERF_TYPE_RAW]);
+		printf("  %-50s [%s]\n",
+		       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
+		       event_type_descriptors[PERF_TYPE_RAW]);
+		printf("   (see 'perf list --help' on how to encode it)\n");
+		printf("\n");
+
+		printf("  %-50s [%s]\n",
+		       "mem:<addr>[:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
-	printf("\n");
+		printf("\n");
+	}
 
-	print_tracepoint_events(NULL, NULL);
+	print_tracepoint_events(NULL, NULL, name_only);
 }
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 163aad4..00416d7f 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -96,10 +96,11 @@ void parse_events_update_lists(struct list_head *list_event,
 void parse_events_error(void *data, void *scanner, char const *msg);
 int parse_events__test(void);
 
-void print_events(const char *event_glob);
+void print_events(const char *event_glob, bool name_only);
 void print_events_type(u8 type);
-void print_tracepoint_events(const char *subsys_glob, const char *event_glob);
-int print_hwcache_events(const char *event_glob);
+void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
+			     bool name_only);
+int print_hwcache_events(const char *event_glob, bool name_only);
 extern int is_valid_tracepoint(const char *event_string);
 
 extern int valid_debugfs_mount(const char *debugfs);
