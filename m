Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0LUJFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:05:05 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58215 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035Ab0LUJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:04:53 -0500
X-AuditID: b753bd60-a26f8ba000000f8d-ac-4d106db35aad
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 1/6] perf: Introduce perf sub command 'bts record'
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Tue, 21 Dec 2010 18:05:42 +0900
Message-ID: <20101221090542.8552.36227.stgit@localhost6.localdomain6>
In-Reply-To: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the easy way to record bts log, 'perf bts record'.
This command can record the bts log while specified command is executing,
and save to the file "perf.data"

Usage:
  perf bts record <tracee command>

Example:
  # perf bts record ls -l
    (ls -l outputs)
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.007 MB perf.data (~320 samples) ]
  # ls
    perf.data

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

 tools/perf/Documentation/perf-bts.txt |   24 +++++++++++++
 tools/perf/Makefile                   |    1 +
 tools/perf/builtin-bts.c              |   62 +++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                  |    1 +
 tools/perf/command-list.txt           |    1 +
 tools/perf/perf.c                     |    1 +
 6 files changed, 90 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-bts.txt
 create mode 100644 tools/perf/builtin-bts.c

diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
new file mode 100644
index 0000000..55a2fe6
--- /dev/null
+++ b/tools/perf/Documentation/perf-bts.txt
@@ -0,0 +1,24 @@
+perf-bts(1)
+==============
+
+NAME
+----
+perf-bts - Record branch-trace-store log
+
+SYNOPSIS
+--------
+[verse]
+'perf bts' record <command>
+
+DESCRIPTION
+-----------
+This command can record branch-trace-store log.
+Branch-trace-store is a facility of processors. It can record
+address of branch to/from on every branch instruction and interrupt.
+
+'perf bts record <command>' records branch-trace-store log while specified
+command is executing. And, save to the file "perf.data".
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac6692c..cd3a8df 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -502,6 +502,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)builtin-bts.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
new file mode 100644
index 0000000..587cfad
--- /dev/null
+++ b/tools/perf/builtin-bts.c
@@ -0,0 +1,62 @@
+#include "builtin.h"
+#include "perf.h"
+#include "util/parse-options.h"
+
+static const char * const bts_usage[] = {
+	"perf bts record <command>",
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
+static const struct option bts_options[] = {
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
+int cmd_bts(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, bts_options, bts_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(bts_usage, bts_options);
+
+	if (!strncmp(argv[0], "record", 6))
+		return __cmd_record(argc, argv);
+	else
+		usage_with_options(bts_usage, bts_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index c7798c7..11ed837 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -35,5 +35,6 @@ extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_bts(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 16b5088..956acea 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -22,3 +22,4 @@ perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
 perf-test			mainporcelain common
+perf-bts			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 595d0f4..4f4a98a 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -331,6 +331,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "kvm",	cmd_kvm,	0 },
 		{ "test",	cmd_test,	0 },
 		{ "inject",	cmd_inject,	0 },
+		{ "bts",	cmd_bts,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;

