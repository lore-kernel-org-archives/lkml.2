Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504Ab2JYIA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:00:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2JYIAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:00:53 -0400
Date: Thu, 25 Oct 2012 00:59:28 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-68e94f4eb56d92ccb617a98fcac5e575702ec4fd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1350344020-8071-5-git-send-email-irina.tirdea@gmail.com>
References: <1350344020-8071-5-git-send-email-irina.tirdea@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Try to find cross-built objdump path
Git-Commit-ID: 68e94f4eb56d92ccb617a98fcac5e575702ec4fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 00:59:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68e94f4eb56d92ccb617a98fcac5e575702ec4fd
Gitweb:     http://git.kernel.org/tip/68e94f4eb56d92ccb617a98fcac5e575702ec4fd
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Tue, 16 Oct 2012 02:33:38 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 14:20:11 -0200

perf tools: Try to find cross-built objdump path

As we have architecture information of saved perf.data file, we can try
to find cross-built objdump path.

The triplets include support for Android (arm, x86 and mips
architectures).

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Originally-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1350344020-8071-5-git-send-email-irina.tirdea@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    2 +
 tools/perf/arch/common.c      |  178 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/arch/common.h      |   10 +++
 tools/perf/builtin-annotate.c |    7 ++
 tools/perf/builtin-report.c   |    7 ++
 tools/perf/util/annotate.h    |    1 -
 6 files changed, 204 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6790cb4..78a81ed 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -426,6 +426,8 @@ LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
+LIB_OBJS += $(OUTPUT)arch/common.o
+
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
new file mode 100644
index 0000000..2367b25
--- /dev/null
+++ b/tools/perf/arch/common.c
@@ -0,0 +1,178 @@
+#include <stdio.h>
+#include <sys/utsname.h>
+#include "common.h"
+#include "../util/debug.h"
+
+const char *const arm_triplets[] = {
+	"arm-eabi-",
+	"arm-linux-androideabi-",
+	"arm-unknown-linux-",
+	"arm-unknown-linux-gnu-",
+	"arm-unknown-linux-gnueabi-",
+	NULL
+};
+
+const char *const powerpc_triplets[] = {
+	"powerpc-unknown-linux-gnu-",
+	"powerpc64-unknown-linux-gnu-",
+	NULL
+};
+
+const char *const s390_triplets[] = {
+	"s390-ibm-linux-",
+	NULL
+};
+
+const char *const sh_triplets[] = {
+	"sh-unknown-linux-gnu-",
+	"sh64-unknown-linux-gnu-",
+	NULL
+};
+
+const char *const sparc_triplets[] = {
+	"sparc-unknown-linux-gnu-",
+	"sparc64-unknown-linux-gnu-",
+	NULL
+};
+
+const char *const x86_triplets[] = {
+	"x86_64-pc-linux-gnu-",
+	"x86_64-unknown-linux-gnu-",
+	"i686-pc-linux-gnu-",
+	"i586-pc-linux-gnu-",
+	"i486-pc-linux-gnu-",
+	"i386-pc-linux-gnu-",
+	"i686-linux-android-",
+	"i686-android-linux-",
+	NULL
+};
+
+const char *const mips_triplets[] = {
+	"mips-unknown-linux-gnu-",
+	"mipsel-linux-android-",
+	NULL
+};
+
+static bool lookup_path(char *name)
+{
+	bool found = false;
+	char *path, *tmp;
+	char buf[PATH_MAX];
+	char *env = getenv("PATH");
+
+	if (!env)
+		return false;
+
+	env = strdup(env);
+	if (!env)
+		return false;
+
+	path = strtok_r(env, ":", &tmp);
+	while (path) {
+		scnprintf(buf, sizeof(buf), "%s/%s", path, name);
+		if (access(buf, F_OK) == 0) {
+			found = true;
+			break;
+		}
+		path = strtok_r(NULL, ":", &tmp);
+	}
+	free(env);
+	return found;
+}
+
+static int lookup_triplets(const char *const *triplets, const char *name)
+{
+	int i;
+	char buf[PATH_MAX];
+
+	for (i = 0; triplets[i] != NULL; i++) {
+		scnprintf(buf, sizeof(buf), "%s%s", triplets[i], name);
+		if (lookup_path(buf))
+			return i;
+	}
+	return -1;
+}
+
+static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
+						  const char *name,
+						  const char **path)
+{
+	int idx;
+	char *arch, *cross_env;
+	struct utsname uts;
+	const char *const *path_list;
+	char *buf = NULL;
+
+	if (uname(&uts) < 0)
+		goto out;
+
+	/*
+	 * We don't need to try to find objdump path for native system.
+	 * Just use default binutils path (e.g.: "objdump").
+	 */
+	if (!strcmp(uts.machine, env->arch))
+		goto out;
+
+	cross_env = getenv("CROSS_COMPILE");
+	if (cross_env) {
+		if (asprintf(&buf, "%s%s", cross_env, name) < 0)
+			goto out_error;
+		if (buf[0] == '/') {
+			if (access(buf, F_OK) == 0)
+				goto out;
+			goto out_error;
+		}
+		if (lookup_path(buf))
+			goto out;
+		free(buf);
+	}
+
+	arch = env->arch;
+
+	if (!strcmp(arch, "arm"))
+		path_list = arm_triplets;
+	else if (!strcmp(arch, "powerpc"))
+		path_list = powerpc_triplets;
+	else if (!strcmp(arch, "sh"))
+		path_list = sh_triplets;
+	else if (!strcmp(arch, "s390"))
+		path_list = s390_triplets;
+	else if (!strcmp(arch, "sparc"))
+		path_list = sparc_triplets;
+	else if (!strcmp(arch, "x86") || !strcmp(arch, "i386") ||
+		 !strcmp(arch, "i486") || !strcmp(arch, "i586") ||
+		 !strcmp(arch, "i686"))
+		path_list = x86_triplets;
+	else if (!strcmp(arch, "mips"))
+		path_list = mips_triplets;
+	else {
+		ui__error("binutils for %s not supported.\n", arch);
+		goto out_error;
+	}
+
+	idx = lookup_triplets(path_list, name);
+	if (idx < 0) {
+		ui__error("Please install %s for %s.\n"
+			  "You can add it to PATH, set CROSS_COMPILE or "
+			  "override the default using --%s.\n",
+			  name, arch, name);
+		goto out_error;
+	}
+
+	if (asprintf(&buf, "%s%s", path_list[idx], name) < 0)
+		goto out_error;
+
+out:
+	*path = buf;
+	return 0;
+out_error:
+	free(buf);
+	*path = NULL;
+	return -1;
+}
+
+int perf_session_env__lookup_objdump(struct perf_session_env *env)
+{
+	return perf_session_env__lookup_binutils_path(env, "objdump",
+						      &objdump_path);
+}
diff --git a/tools/perf/arch/common.h b/tools/perf/arch/common.h
new file mode 100644
index 0000000..ede246e
--- /dev/null
+++ b/tools/perf/arch/common.h
@@ -0,0 +1,10 @@
+#ifndef ARCH_PERF_COMMON_H
+#define ARCH_PERF_COMMON_H
+
+#include "../util/session.h"
+
+extern const char *objdump_path;
+
+int perf_session_env__lookup_objdump(struct perf_session_env *env);
+
+#endif /* ARCH_PERF_COMMON_H */
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 690fa9a..c4bb645 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -28,6 +28,7 @@
 #include "util/hist.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "arch/common.h"
 
 #include <linux/bitmap.h>
 
@@ -186,6 +187,12 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			goto out_delete;
 	}
 
+	if (!objdump_path) {
+		ret = perf_session_env__lookup_objdump(&session->header.env);
+		if (ret)
+			goto out_delete;
+	}
+
 	ret = perf_session__process_events(session, &ann->tool);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5104a40..90d1162 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,6 +33,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "arch/common.h"
 
 #include <linux/bitmap.h>
 
@@ -672,6 +673,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
+	if (!objdump_path) {
+		ret = perf_session_env__lookup_objdump(&session->header.env);
+		if (ret)
+			goto error;
+	}
+
 	if (sort__branch_mode == -1 && has_br_stack)
 		sort__branch_mode = 1;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 39242dc..a4dd25a 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -154,6 +154,5 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 #endif
 
 extern const char	*disassembler_style;
-extern const char	*objdump_path;
 
 #endif	/* __PERF_ANNOTATE_H */
