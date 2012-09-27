Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab2I0NiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:38:06 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58523 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0NiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:38:04 -0400
X-AuditID: 9c93016f-b7b1eae000000815-04-506456b9e385
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: [RFC v2] perf tools: Try to find cross-built objdump path
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
	<1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
	<1348578539.1877.40.camel@leonhard>
	<CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
	<87d318w7u9.fsf@sejong.aot.lge.com>
	<CANg8OWLR64RQYMwi=vx78tWBfcML4CPrerXV3nE+ngYkJ3Ru=A@mail.gmail.com>
	<87haqjvc6f.fsf@sejong.aot.lge.com>
Date: Thu, 27 Sep 2012 22:29:48 +0900
In-Reply-To: <87haqjvc6f.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 27 Sep 2012 22:16:08 +0900")
Message-ID: <87d317vbjn.fsf_-_@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As we have architecture information of saved perf.data file, we can
try to find cross-built objdump path.

The triplets are incomplete and maybe need some regexp works.

Cc: Irina Tirdea <irina.tirdea@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
v2: don't modify env string

 tools/perf/Makefile           |   2 +
 tools/perf/arch/common.c      |  42 +++++++++++++++++
 tools/perf/builtin-annotate.c |   3 ++
 tools/perf/util/annotate.c    | 103 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h    |  10 ++++
 5 files changed, 160 insertions(+)
 create mode 100644 tools/perf/arch/common.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5973f383eb8e..b189229eb576 100644
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
index 000000000000..c3872427d135
--- /dev/null
+++ b/tools/perf/arch/common.c
@@ -0,0 +1,42 @@
+#include <stdio.h>
+
+const char * const arm_triplets[] = {
+	"arm-eabi-",
+	"arm-unknown-linux-",
+	"arm-unknown-linux-gnu-",
+	"arm-unknown-linux-gnueabi-",
+	NULL
+};
+
+const char * const powerpc_triplets[] = {
+	"powerpc-unknown-linux-gnu-",
+	"powerpc64-unknown-linux-gnu-",
+	NULL
+};
+
+const char * const s390_triplets[] = {
+	"s390-ibm-linux-",
+	NULL
+};
+
+const char * const sh_triplets[] = {
+	"sh-unknown-linux-gnu-",
+	"sh64-unknown-linux-gnu-",
+	NULL
+};
+
+const char * const sparc_triplets[] = {
+	"sparc-unknown-linux-gnu-",
+	"sparc64-unknown-linux-gnu-",
+	NULL
+};
+
+const char * const x86_triplets[] = {
+	"x86_64-pc-linux-gnu-",
+	"x86_64-unknown-linux-gnu-",
+	"i686-pc-linux-gnu-",
+	"i586-pc-linux-gnu-",
+	"i486-pc-linux-gnu-",
+	"i386-pc-linux-gnu-",
+	NULL
+};
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9ea38540b873..20fe9bb6505b 100644
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
index f0a910371377..df17c443e3b3 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "annotate.h"
 #include <pthread.h>
+#include <sys/utsname.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
@@ -1140,3 +1141,105 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 
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
+		scnprintf(buf, sizeof(buf), "%s%s", path, name);
+		if (access(buf, F_OK) == 0) {
+			found = true;
+			break;
+		}
+		strtok_r(NULL, ":", &tmp);
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
+	else if (!strcmp(arch, "x86"))
+		path_list = x86_triplets;
+	else
+		BUG_ON(1);
+
+	idx = lookup_triplets(path_list, name);
+	if (idx < 0)
+		return NULL;
+
+	scnprintf(buf, sizeof(buf), path_list[idx], name);
+	return strdup(buf);
+}
+
+void try_objdump_path(struct perf_session *session)
+{
+	objdump_path = try_binutils_path(session, "objdump");
+}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 9b5b21e7b032..cbf2d9537320 100644
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
@@ -156,4 +157,13 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 extern const char	*disassembler_style;
 extern const char	*objdump_path;
 
+extern const char *arm_triplets[];
+extern const char *powerpc_triplets[];
+extern const char *sh_triplets[];
+extern const char *s390_triplets[];
+extern const char *sparc_triplets[];
+extern const char *x86_triplets[];
+
+void try_objdump_path(struct perf_session *session);
+
 #endif	/* __PERF_ANNOTATE_H */
-- 
1.7.11.4

