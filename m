Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2BXJk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:40:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2BXJkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:40:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.180.24.166 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
Date: Fri, 24 Feb 2012 10:40:48 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        ravitillo@lbl.gov, khandual@linux.vnet.ibm.com, asharma@fb.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120224094048.GA7952@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds auto-detection of samples with taken branch stacks.
The auto-detection avoids having to specify the -b or --branch-stack
option on the cmdline.

The patch adds a new feature bit HEADER_BRANCH_STACK to mark the
presence of branch stacks in samples.

You can now do:
$ perf record -b any noploop 2
$ perf report 
# Events: 8K cycles
#
# Overhead  Command  Source Shared Object        Source Symbol  Target Shared Object       Target Symbol
# ........  .......  ....................  ...................  ....................  ..................
#
    91.56%  noploop  noploop               [.] noploop                       noploop  [.] noploop
     0.42%  noploop  [kernel.kallsyms]     [k] __lock_acquire      [kernel.kallsyms]  [k] __lock_acquire


To force regular reporting based on the instruction address:
$ perf report --no-branch-stack
#
# Events: 2K cycles
#
# Overhead  Command      Shared Object                           Symbol
# ........  .......  .................  ...............................
#
    92.03%  noploop  noploop            [.] noploop                    
     1.00%  noploop  [kernel.kallsyms]  [k] lock_acquire               


Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1c49d4e..5e833a2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -473,6 +473,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (!have_tracepoints(&evsel_list->entries))
 		perf_header__clear_feat(&session->header, HEADER_TRACE_INFO);
 
+	if (!rec->opts.branch_stack)
+		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+
 	if (!rec->file_new) {
 		err = perf_session__read_header(session, output);
 		if (err < 0)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 528789f..edd4289 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -306,21 +306,14 @@ static int __cmd_report(struct perf_report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
-	struct perf_session *session;
 	struct perf_evsel *pos;
+	struct perf_session *session = rep->session;
 	struct map *kernel_map;
 	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
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
@@ -489,7 +482,10 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
+	struct perf_session *session;
 	struct stat st;
+	bool has_br_stack;
+	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
@@ -600,7 +596,23 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 			report.input_name = "perf.data";
 	}
 
-	if (sort__branch_mode) {
+	session = perf_session__new(report.input_name, O_RDONLY,
+				    report.force, false, &report.tool);
+	if (session == NULL)
+		return -ENOMEM;
+
+	report.session = session;
+
+	has_br_stack = perf_header__has_feat(&session->header,
+					     HEADER_BRANCH_STACK);
+
+	/*
+	 * if branch mode set by user via -b or --branch-stack
+	 * or not forced off by user (-no-branch-stack) user and present
+	 * in the file then we set branch mode
+	 */
+	if (sort__branch_mode || (sort__branch_mode == -1 && has_br_stack)) {
+		sort__branch_mode = true;
 		if (use_browser)
 			fprintf(stderr, "Warning: TUI interface not supported"
 					" in branch mode\n");
@@ -657,13 +669,13 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
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
@@ -685,5 +697,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
-	return __cmd_report(&report);
+	ret = __cmd_report(&report);
+error:
+	perf_session__delete(session);
+	return ret;
 }
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c851495..c22491e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1023,6 +1023,12 @@ static int write_cpuid(int fd, struct perf_header *h __used,
 	return do_write_string(fd, buffer);
 }
 
+static int write_branch_stack(int fd __used, struct perf_header *h __used,
+		       struct perf_evlist *evlist __used)
+{
+	return 0;
+}
+
 static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
 {
 	char *str = do_read_string(fd, ph);
@@ -1315,6 +1321,12 @@ static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
 	free(str);
 }
 
+static void print_branch_stack(struct perf_header *ph __used, int fd __used,
+			       FILE *fp)
+{
+	fprintf(fp, "# contains samples with branch stacks\n");
+}
+
 static int __event_process_build_id(struct build_id_event *bev,
 				    char *filename,
 				    struct perf_session *session)
@@ -1519,6 +1531,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_CMDLINE,	cmdline),
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
+	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index e68f617..21a6be0 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -27,7 +27,7 @@ enum {
 	HEADER_EVENT_DESC,
 	HEADER_CPU_TOPOLOGY,
 	HEADER_NUMA_TOPOLOGY,
-
+	HEADER_BRANCH_STACK,
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
 };
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 2739ed1..69d50c0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,7 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
-bool		sort__branch_mode;
+bool		sort__branch_mode = -1; /* -1 = means not set */
 
 enum sort_type	sort__first_dimension;
 
