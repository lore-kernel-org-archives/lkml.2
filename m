Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2CINep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:34:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2CINen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:34:43 -0500
Date: Fri, 9 Mar 2012 05:34:07 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-330aa675b4f92a422cb6d3acbbfd16a628017520@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1331246868-19905-3-git-send-email-eranian@google.com>
References: <1331246868-19905-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf record:
  Add HEADER_BRANCH_STACK tag
Git-Commit-ID: 330aa675b4f92a422cb6d3acbbfd16a628017520
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:34:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  330aa675b4f92a422cb6d3acbbfd16a628017520
Gitweb:     http://git.kernel.org/tip/330aa675b4f92a422cb6d3acbbfd16a628017520
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 8 Mar 2012 23:47:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:08 +0100

perf record: Add HEADER_BRANCH_STACK tag

This patch adds a new feature bit, namely,
HEADER_BRANCH_STACK.  When present, it indicates
that sample records may contain branch stack.

This could be useful to a viewer to switch to
branch mode without having to parse all the
samples or without a specific cmdline option.

This will be used in a subsequent patch to
enhance perf report with branch stacks.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1331246868-19905-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/util/header.c    |   13 +++++++++++++
 tools/perf/util/header.h    |    2 +-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a7c53a9..be4e1ee 100644
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
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c851495..0d9b6da 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1023,6 +1023,12 @@ write_it:
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
+	fprintf(fp, "# contains samples with branch stack\n");
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
