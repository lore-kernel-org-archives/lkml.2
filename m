Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1I2WsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1I2WsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/16] perf buildid-list: Add option to show the running kernel build id
Date: Thu, 29 Sep 2011 19:47:57 -0300
Message-Id: <1317336490-19437-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@emilia ~]# perf buildid-list -k
07b0c016a2b30004e86132d0239945b1e88f5d75

Useful when diagnosing build id problems in debuginfo packages, etc.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-po1bl7acn6e1hhne90opmvtl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-list.txt |    5 ++++
 tools/perf/builtin-buildid-list.c              |   31 ++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index 5eaac6f..770a7f3 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -16,6 +16,8 @@ This command displays the buildids found in a perf.data file, so that other
 tools can be used to fetch packages with matching symbol tables for use by
 perf report.
 
+It can also be used to show the build id of the running kernel.
+
 OPTIONS
 -------
 -H::
@@ -27,6 +29,9 @@ OPTIONS
 -f::
 --force::
 	Don't do ownership validation.
+-k::
+--kernel::
+	Show running kernel build id.
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 5af32ae..4102ead 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -1,7 +1,8 @@
 /*
  * builtin-buildid-list.c
  *
- * Builtin buildid-list command: list buildids in perf.data
+ * Builtin buildid-list command: list buildids in perf.data or in the running
+ * kernel.
  *
  * Copyright (C) 2009, Red Hat Inc.
  * Copyright (C) 2009, Arnaldo Carvalho de Melo <acme@redhat.com>
@@ -17,6 +18,7 @@
 
 static char const *input_name = "perf.data";
 static bool force;
+static bool show_kernel;
 static bool with_hits;
 
 static const char * const buildid_list_usage[] = {
@@ -29,12 +31,13 @@ static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose"),
 	OPT_END()
 };
 
-static int __cmd_buildid_list(void)
+static int perf_session__list_build_ids(void)
 {
 	struct perf_session *session;
 
@@ -52,6 +55,30 @@ static int __cmd_buildid_list(void)
 	return 0;
 }
 
+static int sysfs__fprintf_build_id(FILE *fp)
+{
+	u8 kallsyms_build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
+				 sizeof(kallsyms_build_id)) != 0)
+		return -1;
+
+	build_id__sprintf(kallsyms_build_id, sizeof(kallsyms_build_id),
+			  sbuild_id);
+	fprintf(fp, "%s\n", sbuild_id);
+	return 0;
+}
+
+static int __cmd_buildid_list(void)
+{
+
+	if (show_kernel)
+		return sysfs__fprintf_build_id(stdout);
+
+	return perf_session__list_build_ids();
+}
+
 int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, buildid_list_usage, 0);
-- 
1.6.2.5

