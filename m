Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab2JAAmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:42:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33258 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2JAAmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:42:18 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [RFC v3] perf tools: Try to find cross-built objdump path
Date: Mon,  1 Oct 2012 03:41:26 +0300
Message-Id: <1349052086-4389-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <87d317vbjn.fsf_-_@sejong.aot.lge.com>
References: <87d317vbjn.fsf_-_@sejong.aot.lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As we have architecture information of saved perf.data file, we can
try to find cross-built objdump path.

The triplets include support for Android (arm, x86 and mips architectures).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---

v3:
 () update triplets to include Android toolchains for arm, x86 and mips
 () fixed a few small bugs
 () tested on Android
 
v2: don't modify env string

 tools/perf/Makefile           |    2 +
 tools/perf/arch/common.c      |   51 ++++++++++++++++++++
 tools/perf/builtin-annotate.c |    3 ++
 tools/perf/util/annotate.c    |  107 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h    |   11 +++++
 5 files changed, 174 insertions(+)
 create mode 100644 tools/perf/arch/common.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e5e71e7..816fc04 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -412,6 +412,8 @@ LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
+LIB_OBJS += $(OUTPUT)arch/common.o
+
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
new file mode 100644
index 0000000..6904777
--- /dev/null
+++ b/tools/perf/arch/common.c
@@ -0,0 +1,51 @@
+#include <stdio.h>
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
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9ea3854..20fe9bb 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -186,6 +186,9 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			goto out_delete;
 	}
 
+	if (!objdump_path)
+		try_objdump_path(session);
+
 	ret = perf_session__process_events(session, &ann->tool);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..36f3af0 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "annotate.h"
 #include <pthread.h>
+#include <sys/utsname.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
@@ -1140,3 +1141,109 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	return 0;
 }
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
+static int lookup_triplets(const char **triplets, const char *name)
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
+static char *try_binutils_path(struct perf_session *session, const char *name)
+{
+	int idx;
+	char *arch, *env;
+	struct utsname uts;
+	const char **path_list;
+	char buf[PATH_MAX];
+
+	if (uname(&uts) < 0)
+		return NULL;
+
+	/*
+	 * We don't need to try to find objdump path for native system.
+	 * Just use default "objdump".
+	 */
+	if (!strcmp(uts.machine, session->header.env.arch))
+		return NULL;
+
+	env = getenv("CROSS_COMPILE");
+	if (env) {
+		scnprintf(buf, sizeof(buf), "%s%s", env, name);
+		if (buf[0] == '/') {
+			if (access(buf, F_OK) == 0)
+				return strdup(buf);
+
+			return NULL;
+		}
+
+		if (lookup_path(buf))
+			return strdup(buf);
+	}
+
+	arch = session->header.env.arch;
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
+	else
+		BUG_ON(1);
+
+	idx = lookup_triplets(path_list, name);
+	if (idx < 0)
+		return NULL;
+
+	scnprintf(buf, sizeof(buf), "%s%s", path_list[idx], name);
+	return strdup(buf);
+}
+
+void try_objdump_path(struct perf_session *session)
+{
+	objdump_path = try_binutils_path(session, "objdump");
+}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 9b5b21e..4918d1f 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -5,6 +5,7 @@
 #include <stdint.h>
 #include "types.h"
 #include "symbol.h"
+#include "session.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <pthread.h>
@@ -156,4 +157,14 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 extern const char	*disassembler_style;
 extern const char	*objdump_path;
 
+extern const char *arm_triplets[];
+extern const char *powerpc_triplets[];
+extern const char *sh_triplets[];
+extern const char *s390_triplets[];
+extern const char *sparc_triplets[];
+extern const char *x86_triplets[];
+extern const char *mips_triplets[];
+
+void try_objdump_path(struct perf_session *session);
+
 #endif	/* __PERF_ANNOTATE_H */
-- 
1.7.9.5

