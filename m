Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285Ab2FVFmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:42:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43654 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761218Ab2FVFl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:27 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-7c-4fe405845e1f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 7/8] perf tools: Support minimal build without libelf
Date: Fri, 22 Jun 2012 14:37:41 +0900
Message-Id: <1340343462-15556-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now we have isolated all ELF-specific stuff, it's possible
to build without libelf. The output binary can do most of
jobs but lacks (user level) symbol information - kernel
symbols are still accessable thanks to the kallsyms.

For now, only 'perf probe' command is removed since it
depends on libelf/libdw heavily.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile                 |   57 ++++++++++++++++++++++++++---------
 tools/perf/builtin-inject.c         |    5 ++-
 tools/perf/command-list.txt         |    2 +-
 tools/perf/perf.c                   |    2 ++
 tools/perf/util/generate-cmdlist.sh |   15 +++++++++
 tools/perf/util/map.c               |    3 +-
 tools/perf/util/symbol-minimal.c    |   33 ++++++++++++++++++++
 7 files changed, 100 insertions(+), 17 deletions(-)
 create mode 100644 tools/perf/util/symbol-minimal.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0f50a773da08..34eaaff89b62 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -37,7 +37,12 @@ include config/utilities.mak
 #
 # Define NO_NEWT if you do not want TUI support.
 #
+# Define NO_GTK2 if you do not want GTK+ GUI support.
+#
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
+#
+# Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
+#
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -445,34 +450,57 @@ PYRF_OBJS += $(OUTPUT)util/xyarray.o
 -include config.mak.autogen
 -include config.mak
 
-ifndef NO_DWARF
-FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
-	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+ifdef NO_LIBELF
 	NO_DWARF := 1
-endif # Dwarf support
-endif # NO_DWARF
-
--include arch/$(ARCH)/Makefile
-
-ifneq ($(OUTPUT),)
-	BASIC_CFLAGS += -I$(OUTPUT)
-endif
-
+	NO_DEMANGLE := 1
+else
 FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
 	ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
 		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 	else
-		msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
+		NO_LIBELF := 1
+		NO_DWARF := 1
+		NO_DEMANGLE := 1
 	endif
 endif
+endif # NO_LIBELF
+
+-include arch/$(ARCH)/Makefile
+
+ifneq ($(OUTPUT),)
+	BASIC_CFLAGS += -I$(OUTPUT)
+endif
+
+ifdef NO_LIBELF
+BASIC_CFLAGS += -DNO_LIBELF_SUPPORT
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
+else # NO_LIBELF
 
 ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
 	BASIC_CFLAGS += -DLIBELF_NO_MMAP
 endif
 
+FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
+	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+	NO_DWARF := 1
+endif # Dwarf support
+
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
@@ -483,6 +511,7 @@ else
 	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
+endif # NO_LIBELF
 
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3beab489afc5..64d8ba2fb7bc 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -191,10 +191,13 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * If this fails, too bad, let the other side
 				 * account this as unresolved.
 				 */
-			} else
+			} else {
+#ifndef NO_LIBELF_SUPPORT
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
+#endif
+			}
 		}
 	}
 
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
index 2b2e225a4d4c..a1450ccac291 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -313,7 +313,9 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "version",	cmd_version,	0 },
 		{ "script",	cmd_script,	0 },
 		{ "sched",	cmd_sched,	0 },
+#ifndef NO_LIBELF_SUPPORT
 		{ "probe",	cmd_probe,	0 },
+#endif
 		{ "kmem",	cmd_kmem,	0 },
 		{ "lock",	cmd_lock,	0 },
 		{ "kvm",	cmd_kvm,	0 },
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index f06f6fd148f8..389590c1ad21 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -21,4 +21,19 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
+
+echo "#ifndef NO_LIBELF_SUPPORT"
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
+echo "#endif /* NO_LIBELF_SUPPORT */"
 echo "};"
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 35ae56864e4f..f29ac8b80f4e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -135,6 +135,7 @@ int map__load(struct map *self, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
+#ifndef NO_LIBELF_SUPPORT
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
@@ -147,7 +148,7 @@ int map__load(struct map *self, symbol_filter_t filter)
 			pr_warning("no symbols found in %s, maybe install "
 				   "a debug package?\n", name);
 		}
-
+#endif
 		return -1;
 	}
 	/*
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
new file mode 100644
index 000000000000..fa37f3bb88d1
--- /dev/null
+++ b/tools/perf/util/symbol-minimal.c
@@ -0,0 +1,33 @@
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
+int dso__synthesize_plt_symbols(struct dso *dso __used, char *name __used,
+				struct map *map __used,
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
1.7.10.2

