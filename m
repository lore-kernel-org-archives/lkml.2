Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2HUPoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:44:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2HUPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:44:05 -0400
Date: Tue, 21 Aug 2012 08:43:43 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-393be2e3747ea3ef0d2e724115a5f42b2fa50dbd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1344228082-15569-4-git-send-email-namhyung@kernel.org>
References: <1344228082-15569-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Support minimal build without libelf
Git-Commit-ID: 393be2e3747ea3ef0d2e724115a5f42b2fa50dbd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:43:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  393be2e3747ea3ef0d2e724115a5f42b2fa50dbd
Gitweb:     http://git.kernel.org/tip/393be2e3747ea3ef0d2e724115a5f42b2fa50dbd
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 6 Aug 2012 13:41:21 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 16:26:38 -0300

perf symbols: Support minimal build without libelf

Now we have isolated all ELF-specific stuff, it's possible to build
without libelf. The output binary can do most of jobs but lacks (user
level) symbol information - kernel symbols are still accessable thanks
to the kallsyms.

To build perf without libelf (elfutils), give NO_LIBELF=1 to make.

For now, only 'perf probe' command is removed since it depends on
libelf/libdw heavily.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344228082-15569-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |   57 ++++++++++++++++++++++++++--------
 tools/perf/builtin-inject.c         |    5 ++-
 tools/perf/command-list.txt         |    2 +-
 tools/perf/perf.c                   |    2 +
 tools/perf/util/generate-cmdlist.sh |   15 +++++++++
 tools/perf/util/map.c               |    3 +-
 tools/perf/util/symbol-minimal.c    |   39 ++++++++++++++++++++++++
 7 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f790e3b..de6aa8c 100644
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
@@ -450,34 +455,57 @@ PYRF_OBJS += $(OUTPUT)util/xyarray.o
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
@@ -488,6 +516,7 @@ else
 	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
+endif # NO_LIBELF
 
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3beab48..64d8ba2 100644
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
index d695fe4..0303ec6 100644
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
index db37ee3..e7840e5 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -47,7 +47,9 @@ static struct cmd_struct commands[] = {
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
index f06f6fd..389590c 100755
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
index 115654c..287cb34 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -156,6 +156,7 @@ int map__load(struct map *self, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
+#ifndef NO_LIBELF_SUPPORT
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
@@ -168,7 +169,7 @@ int map__load(struct map *self, symbol_filter_t filter)
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
index 0000000..416ecf3
--- /dev/null
+++ b/tools/perf/util/symbol-minimal.c
@@ -0,0 +1,39 @@
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
+int filename__read_debuglink(const char *filename __used,
+			     char *debuglink __used, size_t size __used)
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
