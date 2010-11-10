Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab0KJSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:10:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0KJSKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XKTwjrDgTzIxMeQoQDFbZMe40iHyHm/ZIHsqxQl/xH9oHCSjyUbylbfP3AF7ZQierZ
         s1GrdLnXnpT8XFSzS4YNxbcEeZ4B49HRBfCaDObOpLGImoHjKn7AaOfoQunQ97rh/q3Y
         ugTBdzRv281QrlqPP3BFt3leqRPm28ws8mqAE=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 4/7] perf trace record: handle commands correctly
Date: Wed, 10 Nov 2010 12:10:21 -0600
Message-Id: <1289412624-4772-5-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
References: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Because the perf-trace shell scripts hard-coded the use of the
perf-record system-wide param, a perf trace record session was always
system wide, even if it was given a command.

If given a command, perf trace record now only records the events for
the command, as users expect.

If no command is given, or if the '-a' option is used, the recorded
events are system-wide, as before.

root@tropicana:~# perf trace record syscall-counts ls -al
root@tropicana:~# perf trace
              ls-23152 [000] 39984.890387: sys_enter: NR 12 (0, 0, 0, 0, 0, 0)
              ls-23152 [000] 39984.890404: sys_enter: NR 9 (0, 0, 0, 0, 0, 0)

root@tropicana:~# perf trace record syscall-counts -a ls -al
root@tropicana:~# perf trace
    npviewer.bin-22297 [000] 39831.102709: sys_enter: NR 168 (0, 0, 0, 0, 0, 0)
              ls-23111 [000] 39831.107679: sys_enter: NR 59 (0, 0, 0, 0, 0, 0)

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Acked-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/builtin-trace.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 368e624..0de7fcb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -10,6 +10,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
+#include "util/parse-options.h"
 #include "util/util.h"
 
 static char const		*script_name;
@@ -17,6 +18,7 @@ static char const		*generate_script_lang;
 static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
+extern const struct option	record_options[];
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -566,6 +568,20 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+static bool have_cmd(int argc, const char **argv)
+{
+	char **__argv = malloc(sizeof(const char *) * argc);
+
+	if (!__argv)
+		die("malloc");
+	memcpy(__argv, argv, sizeof(const char *) * argc);
+	argc = parse_options(argc, (const char **)__argv, record_options,
+			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
+	free(__argv);
+
+	return argc != 0;
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_session *session;
@@ -663,21 +679,28 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (suffix) {
+		bool system_wide = false;
+		int j = 0;
+
 		script_path = get_script_path(argv[2], suffix);
 		if (!script_path) {
 			fprintf(stderr, "script not found\n");
 			return -1;
 		}
 
+		if (!strcmp(suffix, RECORD_SUFFIX))
+			system_wide = !have_cmd(argc - 2, &argv[2]);
+
 		__argv = malloc((argc + 1) * sizeof(const char *));
 		if (!__argv)
 			die("malloc");
-		__argv[0] = "/bin/sh";
-		__argv[1] = script_path;
+		__argv[j++] = "/bin/sh";
+		__argv[j++] = script_path;
+		if (system_wide)
+			__argv[j++] = "-a";
 		for (i = 3; i < argc; i++)
-			__argv[i - 1] = argv[i];
-		__argv[argc - 1] = NULL;
+			__argv[j++] = argv[i];
+		__argv[j++] = NULL;
 
 		execvp("/bin/sh", (char **)__argv);
 		free(__argv);
-- 
Tom Zanussi, Intel Open Source Technology Center


