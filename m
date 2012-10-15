Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2JOXfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:35:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56912 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab2JOXfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:35:07 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v4 2/6] perf tools: configure shell path at compile time
Date: Tue, 16 Oct 2012 02:33:36 +0300
Message-Id: <1350344020-8071-3-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Shell path /bin/sh is hardcoded in various places in perf. Android has a
different folder structure and does not have /bin/sh.

Set the shell path at compile time in the Makefile by setting PERF_SHELL_PATH.
By default it is set to /bin/sh.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Makefile         |    8 +++++++-
 tools/perf/builtin-help.c   |    2 +-
 tools/perf/builtin-script.c |   12 ++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 005840b..99bf383 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -142,6 +142,7 @@ ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
 PERF_TMP_DIR = /tmp
+PERF_SHELL_PATH = /bin/sh
 
 export prefix bindir sharedir sysconfdir
 
@@ -179,6 +180,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS)),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 	PERF_TMP_DIR = /data/local/tmp
+	PERF_SHELL_PATH = /system/bin/sh
 endif
 
 # Guard against environment variables
@@ -838,7 +840,11 @@ $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFL
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+		'-DPERF_INFO_PATH="$(infodir_SQ)"' \
+		'-DPERF_SHELL_PATH="$(PERF_SHELL_PATH)"' $<
+
+$(OUTPUT)builtin-script.o: builtin-script.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_SHELL_PATH='"$(PERF_SHELL_PATH)"' $<
 
 $(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 411ee56..542b752 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -154,7 +154,7 @@ static void exec_man_cmd(const char *cmd, const char *page)
 {
 	struct strbuf shell_cmd = STRBUF_INIT;
 	strbuf_addf(&shell_cmd, "%s %s", cmd, page);
-	execl("/bin/sh", "sh", "-c", shell_cmd.buf, NULL);
+	execl(PERF_SHELL_PATH, "sh", "-c", shell_cmd.buf, NULL);
 	warning("failed to exec '%s': %s", cmd, strerror(errno));
 }
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 04ceb07..d0d3a21 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1320,7 +1320,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 				goto out;
 			}
 
-			__argv[j++] = "/bin/sh";
+			__argv[j++] = PERF_SHELL_PATH;
 			__argv[j++] = rec_script_path;
 			if (system_wide)
 				__argv[j++] = "-a";
@@ -1331,7 +1331,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 				__argv[j++] = argv[i];
 			__argv[j++] = NULL;
 
-			execvp("/bin/sh", (char **)__argv);
+			execvp(PERF_SHELL_PATH, (char **)__argv);
 			free(__argv);
 			exit(-1);
 		}
@@ -1347,7 +1347,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 
 		j = 0;
-		__argv[j++] = "/bin/sh";
+		__argv[j++] = PERF_SHELL_PATH;
 		__argv[j++] = rep_script_path;
 		for (i = 1; i < rep_args + 1; i++)
 			__argv[j++] = argv[i];
@@ -1355,7 +1355,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		__argv[j++] = "-";
 		__argv[j++] = NULL;
 
-		execvp("/bin/sh", (char **)__argv);
+		execvp(PERF_SHELL_PATH, (char **)__argv);
 		free(__argv);
 		exit(-1);
 	}
@@ -1384,7 +1384,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			goto out;
 		}
 
-		__argv[j++] = "/bin/sh";
+		__argv[j++] = PERF_SHELL_PATH;
 		__argv[j++] = script_path;
 		if (system_wide)
 			__argv[j++] = "-a";
@@ -1392,7 +1392,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			__argv[j++] = argv[i];
 		__argv[j++] = NULL;
 
-		execvp("/bin/sh", (char **)__argv);
+		execvp(PERF_SHELL_PATH, (char **)__argv);
 		free(__argv);
 		exit(-1);
 	}
-- 
1.7.9.5

