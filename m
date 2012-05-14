Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2ENHMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:12:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62027 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2ENHMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:12:10 -0400
X-AuditID: 9c93016f-b7cecae000000e00-de-4fb0b0464315
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] perf tools: Support minimal build
Date: Mon, 14 May 2012 16:10:23 +0900
Message-Id: <1336979424-17206-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have isolated all ELF-specific stuff, it's possible
to build without libelf. The output binary can do most of
jobs but lacks (user level) symbol information - kernel
symbols are still accessable thanks to the kallsyms.

For now, only 'perf probe' command is removed since it
depends on libelf/libdw heavily.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile                 |   28 ++++++++++++++++++++++++++++
 tools/perf/command-list.txt         |    2 +-
 tools/perf/perf.c                   |    2 ++
 tools/perf/util/generate-cmdlist.sh |   15 +++++++++++++++
 tools/perf/util/symbol-minimal.c    |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/symbol-minimal.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7198c6cbc006..001aec806903 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -424,6 +424,32 @@ PYRF_OBJS += $(OUTPUT)util/xyarray.o
 -include config.mak.autogen
 -include config.mak
 
+ifdef MINIMAL
+NO_DWARF := 1
+NO_NEWT := 1
+NO_GTK2 := 1
+NO_LIBPERL := 1
+NO_LIBPYTHON := 1
+NO_DEMANGLE := 1
+NO_STRLCPY := 1
+
+BASIC_CFLAGS += -DMINIMAL_BUILD
+
+EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
+
+# Remove ELF/DWARF dependent codes
+LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
+
+BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
+
+# Use minimal symbol handling
+LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
+
+endif # MINIMAL
+
 ifndef NO_DWARF
 FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
@@ -438,6 +464,7 @@ ifneq ($(OUTPUT),)
 	BASIC_CFLAGS += -I$(OUTPUT)
 endif
 
+ifndef MINIMAL
 FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
@@ -447,6 +474,7 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 		msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 	endif
 endif
+endif # MINIMAL
 
 ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
 	BASIC_CFLAGS += -DLIBELF_NO_MMAP
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index d695fe40fbff..0303ec692274 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -18,7 +18,7 @@ perf-stat			mainporcelain common
 perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-script			mainporcelain common
-perf-probe			mainporcelain common
+perf-probe			mainporcelain full
 perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2b2e225a4d4c..1640d96c1716 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -313,7 +313,9 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "version",	cmd_version,	0 },
 		{ "script",	cmd_script,	0 },
 		{ "sched",	cmd_sched,	0 },
+#ifndef MINIMAL_BUILD
 		{ "probe",	cmd_probe,	0 },
+#endif
 		{ "kmem",	cmd_kmem,	0 },
 		{ "lock",	cmd_lock,	0 },
 		{ "kvm",	cmd_kvm,	0 },
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index f06f6fd148f8..829badc0f56a 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -21,4 +21,19 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
+
+echo "#ifndef MINIMAL_BUILD"
+sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
+sort |
+while read cmd
+do
+     sed -n '
+     /^NAME/,/perf-'"$cmd"'/H
+     ${
+            x
+            s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
+	    p
+     }' "Documentation/perf-$cmd.txt"
+done
+echo "#endif /* MINIMAL_BUILD */"
 echo "};"
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
new file mode 100644
index 000000000000..2917ede1d5ba
--- /dev/null
+++ b/tools/perf/util/symbol-minimal.c
@@ -0,0 +1,32 @@
+#include "symbol.h"
+
+
+int filename__read_build_id(const char *filename __used, void *bf __used,
+			    size_t size __used)
+{
+	return -1;
+}
+
+int sysfs__read_build_id(const char *filename __used, void *build_id __used,
+			 size_t size __used)
+{
+	return -1;
+}
+
+int dso__synthesize_plt_symbols(struct dso *dso __used, struct map *map __used,
+				symbol_filter_t filter __used)
+{
+	return 0;
+}
+
+int dso__load_sym(struct dso *dso __used, struct map *map __used,
+		  const char *name __used, int fd __used,
+		  symbol_filter_t filter __used, int kmodule __used,
+		  int want_symtab __used)
+{
+	return 0;
+}
+
+void symbol__elf_init(void)
+{
+}
-- 
1.7.10.1

