Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2EKGaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:30:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244Ab2EKGaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:30:03 -0400
Date: Thu, 10 May 2012 23:29:37 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fe9d18a71d2018f8021fd2bd2aaf5137954ef839@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1335417327-11796-4-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-4-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Convert to struct perf_target
Git-Commit-ID: fe9d18a71d2018f8021fd2bd2aaf5137954ef839
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:29:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe9d18a71d2018f8021fd2bd2aaf5137954ef839
Gitweb:     http://git.kernel.org/tip/fe9d18a71d2018f8021fd2bd2aaf5137954ef839
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Apr 2012 14:15:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 15:20:30 -0300

perf top: Convert to struct perf_target

Use struct perf_target as it is introduced by previous patch.

This is a preparation of further changes.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335417327-11796-4-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   33 +++++++++++++++++----------------
 tools/perf/util/top.c    |   19 ++++++++++---------
 tools/perf/util/top.h    |    6 +-----
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8ef59f8..2c1c207 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -588,7 +588,7 @@ static void *display_thread_tui(void *arg)
 	 * via --uid.
 	 */
 	list_for_each_entry(pos, &top->evlist->entries, node)
-		pos->hists.uid_filter_str = top->uid_str;
+		pos->hists.uid_filter_str = top->target.uid_str;
 
 	perf_evlist__tui_browse_hists(top->evlist, help,
 				      perf_top__sort_new_samples,
@@ -1016,7 +1016,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (top->target_tid || top->uid != UINT_MAX)
+	if (top->target.tid || top->target.uid != UINT_MAX)
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
@@ -1154,7 +1154,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.uid		     = UINT_MAX,
 		.freq		     = 1000, /* 1 KHz */
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
@@ -1166,13 +1165,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		     parse_events_option),
 	OPT_INTEGER('c', "count", &top.default_interval,
 		    "event period to sample"),
-	OPT_STRING('p', "pid", &top.target_pid, "pid",
+	OPT_STRING('p', "pid", &top.target.pid, "pid",
 		    "profile events on existing process id"),
-	OPT_STRING('t', "tid", &top.target_tid, "tid",
+	OPT_STRING('t', "tid", &top.target.tid, "tid",
 		    "profile events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &top.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &top.target.system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_STRING('C', "cpu", &top.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &top.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
@@ -1227,7 +1226,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
-	OPT_STRING('u', "uid", &top.uid_str, "user", "user to profile"),
+	OPT_STRING('u', "uid", &top.target.uid_str, "user", "user to profile"),
 	OPT_END()
 	};
 
@@ -1253,22 +1252,24 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_browser(false);
 
-	top.uid = parse_target_uid(top.uid_str, top.target_tid, top.target_pid);
-	if (top.uid_str != NULL && top.uid == UINT_MAX - 1)
+	top.target.uid = parse_target_uid(top.target.uid_str, top.target.tid,
+					  top.target.pid);
+	if (top.target.uid_str != NULL && top.target.uid == UINT_MAX - 1)
 		goto out_delete_evlist;
 
 	/* CPU and PID are mutually exclusive */
-	if (top.target_tid && top.cpu_list) {
+	if (top.target.tid && top.target.cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
-		top.cpu_list = NULL;
+		top.target.cpu_list = NULL;
 	}
 
-	if (top.target_pid)
-		top.target_tid = top.target_pid;
+	if (top.target.pid)
+		top.target.tid = top.target.pid;
 
-	if (perf_evlist__create_maps(top.evlist, top.target_pid,
-				     top.target_tid, top.uid, top.cpu_list) < 0)
+	if (perf_evlist__create_maps(top.evlist, top.target.pid,
+				     top.target.tid, top.target.uid,
+				     top.target.cpu_list) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 09fe579..abe0e8e 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -69,23 +69,24 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
-	if (top->target_pid)
+	if (top->target.pid)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %s",
-				top->target_pid);
-	else if (top->target_tid)
+				top->target.pid);
+	else if (top->target.tid)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %s",
-				top->target_tid);
-	else if (top->uid_str != NULL)
+				top->target.tid);
+	else if (top->target.uid_str != NULL)
 		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
-				top->uid_str);
+				top->target.uid_str);
 	else
 		ret += SNPRINTF(bf + ret, size - ret, " (all");
 
-	if (top->cpu_list)
+	if (top->target.cpu_list)
 		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
-				top->evlist->cpus->nr > 1 ? "s" : "", top->cpu_list);
+				top->evlist->cpus->nr > 1 ? "s" : "",
+				top->target.cpu_list);
 	else {
-		if (top->target_tid)
+		if (top->target.tid)
 			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
 			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index ce61cb2..33347ca 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -13,6 +13,7 @@ struct perf_session;
 struct perf_top {
 	struct perf_tool   tool;
 	struct perf_evlist *evlist;
+	struct perf_target target;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
@@ -23,10 +24,7 @@ struct perf_top {
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
 	int		   freq;
-	const char	   *target_pid, *target_tid;
-	uid_t		   uid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
-	bool		   system_wide;
 	bool		   use_tui, use_stdio;
 	bool		   sort_has_symbols;
 	bool		   dont_use_callchains;
@@ -37,7 +35,6 @@ struct perf_top {
 	bool		   sample_id_all_missing;
 	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
-	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
 	struct perf_session *session;
@@ -47,7 +44,6 @@ struct perf_top {
 	int		   realtime_prio;
 	int		   sym_pcnt_filter;
 	const char	   *sym_filter;
-	const char	   *uid_str;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
