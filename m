Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2I0NYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:24:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49019 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2I0NYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:24:23 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-64-5064538483cc
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v2 3/4] perf annotate: configure objdump path at compile time
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
	<1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
	<1348578539.1877.40.camel@leonhard>
	<CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
	<87d318w7u9.fsf@sejong.aot.lge.com>
	<CANg8OWLR64RQYMwi=vx78tWBfcML4CPrerXV3nE+ngYkJ3Ru=A@mail.gmail.com>
Date: Thu, 27 Sep 2012 22:16:08 +0900
In-Reply-To: <CANg8OWLR64RQYMwi=vx78tWBfcML4CPrerXV3nE+ngYkJ3Ru=A@mail.gmail.com>
	(Irina Tirdea's message of "Thu, 27 Sep 2012 14:25:10 +0300")
Message-ID: <87haqjvc6f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 14:25:10 +0300, Irina Tirdea wrote:
>>> The perf built to run on the host needs to use arm-eabi-objdump from
>>> the toolchain so that it can analyse data recorded on Android. This
>>> patch is targeting this scenario, not the previous one. In this case,
>>> the CROSS_COMPILE option would be different than arm-eabi- so using
>>> $(CROSS_COMPILE)objdump would be wrong. objdump should be overridden
>>> when running make since there is no connection between the toolchain
>>> used here and the path for objdump. I am always overriding objdump
>>> when calling make, so I did not catch this.
>>>
>>> I think that I should change DEFAULT_OBJDUMP_PATH=objdump in the
>>> Makefile to handle the first scenario. I'll also explain this in the
>>> commit message so that it is more clear and make the same change for
>>> the addr2line patch.
>>>
>>> What do you think?
>>
>> I think the right thing to do is finding a correct objdump at runtime in
>> some way.  Why do you want to make it compile-time configurable?
>>
>
> The correct objdump path can be detected at runtime by setting the
> toolchain path. But since the name is arm-eabi-objdump and not
> objdump, it does not know to use it instead.
>
> The only way (I can think of) to change objdump at runtime would be to
> use the --objdump option for perf annotate (and provide a similar
> option for addr2line). The problem with this approach is that the user
> has to be aware that perf annotate uses the objdump tool and that he
> has to use the cross-compiler version instead. Since the user will
> have perf compiled for host as part of his Android tree, he will
> expect it to work without these further changes from his part. The
> path for objdump can be set in the Android Makefile at compile time so
> that the user doesn't need to be aware of it.

What I'm thinking is that perf can try to find cross-built binutils when
it detects perf.data file is came from other machine/architecture.
Fortunately perf_session_env was added recently and it has the arch
information from the file so we can use it to find the path.

Following patch is a proof-of-concept patch and only build tested.
What do you think?  Could you play with it for some time? :)

Thanks,
Namhyung


>From 7068a43a4b450c60fdcc8a3916ce624c1ef2c9b2 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Thu, 27 Sep 2012 21:54:33 +0900
Subject: [RFC] perf tools: Try to find cross-built objdump path

As we have architecture information of saved perf.data file, we can
try to find cross-built objdump path.

The triplets are incomplete and maybe need some regexp works.

Cc: Irina Tirdea <irina.tirdea@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile           |  2 +
 tools/perf/arch/common.c      | 42 +++++++++++++++++++
 tools/perf/builtin-annotate.c |  3 ++
 tools/perf/util/annotate.c    | 96 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h    | 10 +++++
 5 files changed, 153 insertions(+)
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
index f0a910371377..afe181af56d6 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "annotate.h"
 #include <pthread.h>
+#include <sys/utsname.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
@@ -1140,3 +1141,98 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	return 0;
 }
+
+static int lookup_path(char *name)
+{
+	char *path, *tmp;
+	char buf[PATH_MAX];
+	char *env = getenv("PATH");
+
+	if (!env)
+		return 0;
+
+	path = strtok_r(env, ":", &tmp);
+	while (path) {
+		scnprintf(buf, sizeof(buf), "%s%s", path, name);
+		if (access(buf, F_OK) == 0)
+			return 1;
+
+		strtok_r(NULL, ":", &tmp);
+	}
+	return 0;
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

