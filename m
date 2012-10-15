Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2JOXgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:36:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58405 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2JOXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:36:10 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v4 5/6] perf tools: Try to find cross-built addr2line path
Date: Tue, 16 Oct 2012 02:33:39 +0300
Message-Id: <1350344020-8071-6-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

As we have architecture information of saved perf.data file, we can
also try to find cross-built addr2line path. The predefined triplets
include support for Android (arm, x86 and mips architectures).

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Documentation/android.txt |   18 ++++++++++++++++++
 tools/perf/arch/common.c             |    6 ++++++
 tools/perf/arch/common.h             |    2 ++
 tools/perf/builtin-annotate.c        |    6 ++++++
 tools/perf/builtin-report.c          |    6 ++++++
 tools/perf/util/sort.c               |    1 +
 tools/perf/util/sort.h               |    1 -
 7 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
index 24fd01c..c2a8017 100644
--- a/tools/perf/Documentation/android.txt
+++ b/tools/perf/Documentation/android.txt
@@ -74,3 +74,21 @@ IV. Run perf
 ------------------------------------------------
 Run perf on your device/emulator to which you previously connected using adb:
   # ./data/perf
+
+V. Analyze data recorded in Android on the host
+------------------------------------------------
+perf report and perf annotate use objdump and addr2line tools from Linux.
+For analyzing data recorded for a different architecture you need to use the
+versions provided in the toolchain for that architecture. The detection of the
+proper toolchain is done at runtime; all you need to do is set some environment
+variables before running perf annotate/report:
+1. set CROSS_COMPILE
+  export CROSS_COMPILE=${NDK_TOOLCHAIN}
+or
+2. add the path to the toolchain to PATH
+  export PATH=$PATH:${ANDROID_TOOLCHAIN}
+or
+3. set the Android environment if you have the source tree
+(this will set $PATH for you as mentioned above)
+  source build/envsetup.sh
+  lunch
diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 2367b25..18ea475 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -176,3 +176,9 @@ int perf_session_env__lookup_objdump(struct perf_session_env *env)
 	return perf_session_env__lookup_binutils_path(env, "objdump",
 						      &objdump_path);
 }
+
+int perf_session_env__lookup_addr2line(struct perf_session_env *env)
+{
+	return perf_session_env__lookup_binutils_path(env, "addr2line",
+						      &addr2line_path);
+}
diff --git a/tools/perf/arch/common.h b/tools/perf/arch/common.h
index ede246e..e78cebd 100644
--- a/tools/perf/arch/common.h
+++ b/tools/perf/arch/common.h
@@ -4,7 +4,9 @@
 #include "../util/session.h"
 
 extern const char *objdump_path;
+extern const char *addr2line_path;
 
 int perf_session_env__lookup_objdump(struct perf_session_env *env);
+int perf_session_env__lookup_addr2line(struct perf_session_env *env);
 
 #endif /* ARCH_PERF_COMMON_H */
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e4df5da..0f46ec6 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -193,6 +193,12 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			goto out_delete;
 	}
 
+	if (!addr2line_path) {
+		ret = perf_session_env__lookup_addr2line(&session->header.env);
+		if (ret)
+			goto out_delete;
+	}
+
 	ret = perf_session__process_events(session, &ann->tool);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9c0fe68..692462c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -682,6 +682,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			goto error;
 	}
 
+	if (!addr2line_path) {
+		ret = perf_session_env__lookup_addr2line(&session->header.env);
+		if (ret)
+			goto error;
+	}
+
 	if (sort__branch_mode == -1 && has_br_stack)
 		sort__branch_mode = 1;
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d45e406..e526158 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "../arch/common.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index c8e58f6..13761d8 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -139,7 +139,6 @@ struct sort_entry {
 
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
-extern const char *addr2line_path;
 
 void setup_sorting(const char * const usagestr[], const struct option *opts);
 extern int sort_dimension__add(const char *);
-- 
1.7.9.5

