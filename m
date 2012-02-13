Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2BMHMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:12:32 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54445 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2BMHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:33 -0500
X-AuditID: 9c930197-b7cdbae000001518-62-4f38b7a1134c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] perf top: Convert to perf_maps_opts
Date: Mon, 13 Feb 2012 16:27:35 +0900
Message-Id: <1329118064-9412-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct perf_maps_opts as it is introduces by previous patch.
This is a preparation of further changes.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-top.c |   40 ++++++++++++++++++++++------------------
 tools/perf/util/top.c    |   15 ++++++++-------
 tools/perf/util/top.h    |    4 +---
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d869b214ada2..36917458ea53 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -555,7 +555,7 @@ static void *display_thread_tui(void *arg)
 	 * via --uid.
 	 */
 	list_for_each_entry(pos, &top->evlist->entries, node)
-		pos->hists.uid_filter_str = top->uid_str;
+		pos->hists.uid_filter_str = top->maps.uid_str;
 
 	perf_evlist__tui_browse_hists(top->evlist, help,
 				      perf_top__sort_new_samples,
@@ -965,7 +965,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (top->target_tid != -1 || top->uid != UINT_MAX)
+	if (top->maps.target_tid != -1 || top->maps.uid != UINT_MAX)
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
@@ -1101,11 +1101,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_evsel *pos;
 	int status = -ENOMEM;
 	struct perf_top top = {
+		.maps = {
+			.target_pid  = -1,
+			.target_tid  = -1,
+			.uid	     = UINT_MAX,
+		},
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.target_pid	     = -1,
-		.target_tid	     = -1,
-		.uid		     = UINT_MAX,
 		.freq		     = 1000, /* 1 KHz */
 		.sample_id_all_avail = true,
 		.mmap_pages	     = 128,
@@ -1118,13 +1120,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		     parse_events_option),
 	OPT_INTEGER('c', "count", &top.default_interval,
 		    "event period to sample"),
-	OPT_INTEGER('p', "pid", &top.target_pid,
+	OPT_INTEGER('p', "pid", &top.maps.target_pid,
 		    "profile events on existing process id"),
-	OPT_INTEGER('t', "tid", &top.target_tid,
+	OPT_INTEGER('t', "tid", &top.maps.target_tid,
 		    "profile events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &top.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &top.maps.system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_STRING('C', "cpu", &top.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &top.maps.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
@@ -1179,7 +1181,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
-	OPT_STRING('u', "uid", &top.uid_str, "user", "user to profile"),
+	OPT_STRING('u', "uid", &top.maps.uid_str, "user", "user to profile"),
 	OPT_END()
 	};
 
@@ -1205,22 +1207,24 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_browser(false);
 
-	top.uid = parse_target_uid(top.uid_str, top.target_tid, top.target_pid);
-	if (top.uid_str != NULL && top.uid == UINT_MAX - 1)
+	top.maps.uid = parse_target_uid(top.maps.uid_str, top.maps.target_tid,
+					top.maps.target_pid);
+	if (top.maps.uid_str != NULL && top.maps.uid == UINT_MAX - 1)
 		goto out_delete_evlist;
 
 	/* CPU and PID are mutually exclusive */
-	if (top.target_tid > 0 && top.cpu_list) {
+	if (top.maps.target_tid > 0 && top.maps.cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
-		top.cpu_list = NULL;
+		top.maps.cpu_list = NULL;
 	}
 
-	if (top.target_pid != -1)
-		top.target_tid = top.target_pid;
+	if (top.maps.target_pid != -1)
+		top.maps.target_tid = top.maps.target_pid;
 
-	if (perf_evlist__create_maps(top.evlist, top.target_pid,
-				     top.target_tid, top.uid, top.cpu_list) < 0)
+	if (perf_evlist__create_maps(top.evlist, top.maps.target_pid,
+				     top.maps.target_tid, top.maps.uid,
+				     top.maps.cpu_list) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index e4370ca27193..be50e655ecab 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -69,23 +69,24 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
-	if (top->target_pid != -1)
+	if (top->maps.target_pid != -1)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %d",
-				top->target_pid);
-	else if (top->target_tid != -1)
+				top->maps.target_pid);
+	else if (top->maps.target_tid != -1)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %d",
-				top->target_tid);
+				top->maps.target_tid);
 	else if (top->uid_str != NULL)
 		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
 				top->uid_str);
 	else
 		ret += SNPRINTF(bf + ret, size - ret, " (all");
 
-	if (top->cpu_list)
+	if (top->maps.cpu_list)
 		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
-				top->evlist->cpus->nr > 1 ? "s" : "", top->cpu_list);
+				top->evlist->cpus->nr > 1 ? "s" : "",
+				top->maps.cpu_list);
 	else {
-		if (top->target_tid != -1)
+		if (top->maps.target_tid != -1)
 			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
 			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index def3e53e0fe0..77a767efa9c3 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -13,6 +13,7 @@ struct perf_session;
 struct perf_top {
 	struct perf_tool   tool;
 	struct perf_evlist *evlist;
+	struct perf_maps_opts maps;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
@@ -23,10 +24,8 @@ struct perf_top {
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
 	int		   freq;
-	pid_t		   target_pid, target_tid;
 	uid_t		   uid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
-	bool		   system_wide;
 	bool		   use_tui, use_stdio;
 	bool		   sort_has_symbols;
 	bool		   dont_use_callchains;
@@ -36,7 +35,6 @@ struct perf_top {
 	bool		   group;
 	bool		   sample_id_all_avail;
 	bool		   dump_symtab;
-	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
 	struct perf_session *session;
-- 
1.7.9

