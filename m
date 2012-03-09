Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2CINfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:35:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2CINf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:35:28 -0500
Date: Fri, 9 Mar 2012 05:34:55 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-993ac88d5892629fbe1f8a54857f9947f49f0d96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1331246868-19905-4-git-send-email-eranian@google.com>
References: <1331246868-19905-4-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf report:
  Auto-detect branch stack sampling mode
Git-Commit-ID: 993ac88d5892629fbe1f8a54857f9947f49f0d96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:35:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  993ac88d5892629fbe1f8a54857f9947f49f0d96
Gitweb:     http://git.kernel.org/tip/993ac88d5892629fbe1f8a54857f9947f49f0d96
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 8 Mar 2012 23:47:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:08 +0100

perf report: Auto-detect branch stack sampling mode

This patch enhances perf report to auto-detect when the
perf.data file contains samples with branch stacks. That way it
is not necessary to use the -b option.

To force branch view mode to off, simply use --no-branch-stack.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1331246868-19905-4-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-report.txt |    7 +++-
 tools/perf/builtin-report.c              |   50 ++++++++++++++++++++---------
 tools/perf/util/sort.c                   |    2 +-
 tools/perf/util/sort.h                   |    2 +-
 4 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 19b9092..87feeee 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -157,8 +157,11 @@ OPTIONS
 --branch-stack::
 	Use the addresses of sampled taken branches instead of the instruction
 	address to build the histograms. To generate meaningful output, the
-	perf.data file must have been obtained using perf record -b xxx where
-	xxx is a branch filter option.
+	perf.data file must have been obtained using perf record -b or
+	perf record --branch-filter xxx where xxx is a branch filter option.
+	perf report is able to auto-detect whether a perf.data file contains
+	branch stacks and it will automatically switch to the branch view mode,
+	unless --no-branch-stack is used.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 528789f..66e8523 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -170,7 +170,7 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (sort__branch_mode) {
+	if (sort__branch_mode == 1) {
 		if (perf_report__add_branch_hist_entry(tool, &al, sample,
 						       evsel, machine)) {
 			pr_debug("problem adding lbr entry, skipping event\n");
@@ -239,7 +239,7 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 			}
 	}
 
-	if (sort__branch_mode) {
+	if (sort__branch_mode == 1) {
 		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
 			fprintf(stderr, "selected -b but no branch data."
 					" Did you call perf record without"
@@ -306,7 +306,7 @@ static int __cmd_report(struct perf_report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
-	struct perf_session *session;
+	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
 	struct map *kernel_map;
 	struct kmap *kernel_kmap;
@@ -314,13 +314,6 @@ static int __cmd_report(struct perf_report *rep)
 
 	signal(SIGINT, sig_handler);
 
-	session = perf_session__new(rep->input_name, O_RDONLY,
-				    rep->force, false, &rep->tool);
-	if (session == NULL)
-		return -ENOMEM;
-
-	rep->session = session;
-
 	if (rep->cpu_list) {
 		ret = perf_session__cpu_bitmap(session, rep->cpu_list,
 					       rep->cpu_bitmap);
@@ -487,9 +480,19 @@ setup:
 	return 0;
 }
 
+static int
+parse_branch_mode(const struct option *opt __used, const char *str __used, int unset)
+{
+	sort__branch_mode = !unset;
+	return 0;
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
+	struct perf_session *session;
 	struct stat st;
+	bool has_br_stack = false;
+	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
@@ -578,8 +581,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
-	OPT_BOOLEAN('b', "branch-stack", &sort__branch_mode,
-		    "use branch records for histogram filling"),
+	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
+		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_END()
 	};
 
@@ -599,8 +602,20 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		else
 			report.input_name = "perf.data";
 	}
+	session = perf_session__new(report.input_name, O_RDONLY,
+				    report.force, false, &report.tool);
+	if (session == NULL)
+		return -ENOMEM;
+
+	report.session = session;
+
+	has_br_stack = perf_header__has_feat(&session->header,
+					     HEADER_BRANCH_STACK);
 
-	if (sort__branch_mode) {
+	if (sort__branch_mode == -1 && has_br_stack)
+		sort__branch_mode = 1;
+
+	if (sort__branch_mode == 1) {
 		if (use_browser)
 			fprintf(stderr, "Warning: TUI interface not supported"
 					" in branch mode\n");
@@ -657,13 +672,13 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (symbol__init() < 0)
-		return -1;
+		goto error;
 
 	setup_sorting(report_usage, options);
 
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
-			return -1;
+			goto error;
 
 		/*
 		 * Only show the parent fields if we explicitly
@@ -685,5 +700,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
-	return __cmd_report(&report);
+	ret = __cmd_report(&report);
+error:
+	perf_session__delete(session);
+	return ret;
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 2739ed1..88dbcf6 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,7 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
-bool		sort__branch_mode;
+int		sort__branch_mode = -1; /* -1 = means not set */
 
 enum sort_type	sort__first_dimension;
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 7aa72a0..8505b9b 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -31,7 +31,7 @@ extern const char *parent_pattern;
 extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
-extern bool sort__branch_mode;
+extern int sort__branch_mode;
 extern char *field_sep;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
