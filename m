Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab2CHWsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:48:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab2CHWsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:48:15 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: [PATCH 2/4] perf record: add HEADER_BRANCH_STACK tag
Date: Thu,  8 Mar 2012 23:47:46 +0100
Message-Id: <1331246868-19905-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331246868-19905-1-git-send-email-eranian@google.com>
References: <1331246868-19905-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new feature bit, namely,
HEADER_BRANCH_STACK.  When present, it indicates
that sample records may contain branch stack.

This could be useful to a viewer to switch to
branch mode without having to parse all the
samples or without a specific cmdline option.

This will be used in a subsequent patch to
enhance perf report with branch stacks.

Signed-off-by: Stephane Eranian <eranian@google.com>
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
-- 
1.7.4.1

