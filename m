Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2JVJrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:47:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54597 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2JVJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:47:08 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v5 2/6] perf tools: configure shell path at compile time
Date: Mon, 22 Oct 2012 12:46:08 +0300
Message-Id: <1350899172-16965-3-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
References: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
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
 tools/perf/Makefile         |    4 +++-
 tools/perf/builtin-help.c   |    2 +-
 tools/perf/builtin-script.c |   12 ++++++------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5429b5b..78fc6b9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -142,6 +142,7 @@ ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
 PERF_TMP_DIR = /tmp
+PERF_SHELL_PATH = /bin/sh
 
 export prefix bindir sharedir sysconfdir
 
@@ -170,7 +171,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"'
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' -DPERF_SHELL_PATH='"$(PERF_SHELL_PATH)"'
 BASIC_LDFLAGS =
 
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
@@ -179,6 +180,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 	PERF_TMP_DIR = /data/local/tmp
+	PERF_SHELL_PATH = /system/bin/sh
 endif
 
 # Guard against environment variables
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

