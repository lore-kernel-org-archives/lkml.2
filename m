Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1EZFEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:04:31 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51315 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1EZFE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:04:29 -0400
X-AuditID: b753bd60-a32c7ba000003bac-c4-4ddddec327b8
X-AuditID: b753bd60-a32c7ba000003bac-c4-4ddddec327b8
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 1/7] perf: new subcommand perf branch record
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 26 May 2011 14:03:02 +0900
Message-ID: <20110526050301.30011.46938.stgit@localhost6.localdomain6>
In-Reply-To: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the easy way to record the bts log, 'perf branch record'.
This command records the bts log while the specified command is executing,
and save to the file "perf.data"

Usage:
  perf branch record <tracee command>

Example:
  # perf branch record ls -l
    (ls -l outputs)
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.007 MB perf.data (~320 samples) ]
  # ls
    perf.data

Changes in V3:
 - rename to 'perf branch'

Changes in V2:
 - Update to the latest -tip tree
 - add bts explanation to the subcommand list

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |   25 ++++++++++++
 tools/perf/Makefile                      |    1 
 tools/perf/builtin-branch.c              |   62 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 
 tools/perf/command-list.txt              |    1 
 tools/perf/perf.c                        |    1 
 6 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-branch.txt
 create mode 100644 tools/perf/builtin-branch.c

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
new file mode 100644
index 0000000..075cfce
--- /dev/null
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -0,0 +1,25 @@
+perf-branch(1)
+==============
+
+NAME
+----
+perf-branch - Record branch-trace-store log
+
+SYNOPSIS
+--------
+[verse]
+'perf branch' record <command>
+
+DESCRIPTION
+-----------
+This command records a branch-trace-store log.
+Branch-trace-store is a facility of processors. It can record
+addresses of from/to which the execution of a program branches,
+at every branch instruction and interrupt.
+
+'perf branch record <command>' records branch-trace-store log while
+the specified command is executing. And, save to the file "perf.data".
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1455413..d42b04c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -370,6 +370,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)builtin-branch.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
new file mode 100644
index 0000000..f338f3a
--- /dev/null
+++ b/tools/perf/builtin-branch.c
@@ -0,0 +1,62 @@
+#include "builtin.h"
+#include "perf.h"
+#include "util/parse-options.h"
+
+static const char * const branch_usage[] = {
+	"perf branch record <command>",
+	NULL,
+};
+
+/* arguments to call 'perf record' */
+static const char * const record_args[] = {
+	"record",
+	"-f",
+	"-e", "branches:u",
+	"-c", "1",
+	"-d",
+};
+
+/* dummy struct option to call parse_options() */
+static const struct option branch_options[] = {
+	OPT_END()
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+	int rc;
+
+	/* prepare the arguments list to call 'perf record' */
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = record_args[i];
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	/* call 'perf record' */
+	rc = cmd_record(i, rec_argv, NULL);
+
+	free(rec_argv);
+	return rc;
+}
+
+int cmd_branch(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, branch_options, branch_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(branch_usage, branch_options);
+
+	if (!strcmp(argv[0], "record"))
+		return __cmd_record(argc, argv);
+	else
+		usage_with_options(branch_usage, branch_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 4702e24..89fefdc 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,5 +36,6 @@ extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_branch(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index d695fe4..537f655 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -23,3 +23,4 @@ perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
 perf-test			mainporcelain common
+perf-branch			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ec635b7..cfd9318 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -332,6 +332,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "kvm",	cmd_kvm,	0 },
 		{ "test",	cmd_test,	0 },
 		{ "inject",	cmd_inject,	0 },
+		{ "branch",	cmd_branch,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;

