Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab2I1JkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:40:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59302 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2I1JkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:20 -0400
X-AuditID: 9c930197-b7b6dae000000e70-66-50657082e1a0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 03/12] perf tools: Convert to LIBELF_SUPPORT
Date: Fri, 28 Sep 2012 18:31:59 +0900
Message-Id: <1348824728-14025-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without libelf, we can set NO_LIBELF=1 as a argument
of make.  It then defines NO_LIBELF_SUPPORT macro for C code to do the
proper handling.  However it usually used in a negative semantics -
e.g. #ifndef - so we saw double negations which can be misleading.
Convert it to a positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile                 |  7 +++----
 tools/perf/builtin-inject.c         |  2 +-
 tools/perf/perf.c                   |  2 +-
 tools/perf/util/generate-cmdlist.sh |  4 ++--
 tools/perf/util/map.c               |  2 +-
 tools/perf/util/symbol.h            | 10 +++++-----
 6 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9cd49130f438..1df09175d8d4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -503,8 +503,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef NO_LIBELF
-BASIC_CFLAGS += -DNO_LIBELF_SUPPORT
-
 EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
 
 # Remove ELF/DWARF dependent codes
@@ -519,9 +517,10 @@ BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
 LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
 else # NO_LIBELF
+BASIC_CFLAGS += -DLIBELF_SUPPORT
 
-ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
-	BASIC_CFLAGS += -DLIBELF_NO_MMAP
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
+	BASIC_CFLAGS += -DLIBELF_MMAP
 endif
 
 ifndef NO_DWARF
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1eaa6617c814..b5ab084233fa 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -194,7 +194,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * account this as unresolved.
 				 */
 			} else {
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fc2f770e3027..dacae4b8bcb4 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -48,7 +48,7 @@ static struct cmd_struct commands[] = {
 	{ "version",	cmd_version,	0 },
 	{ "script",	cmd_script,	0 },
 	{ "sched",	cmd_sched,	0 },
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 	{ "probe",	cmd_probe,	0 },
 #endif
 	{ "kmem",	cmd_kmem,	0 },
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 389590c1ad21..3ac38031d534 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -22,7 +22,7 @@ do
      }' "Documentation/perf-$cmd.txt"
 done
 
-echo "#ifndef NO_LIBELF_SUPPORT"
+echo "#ifdef LIBELF_SUPPORT"
 sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
@@ -35,5 +35,5 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
-echo "#endif /* NO_LIBELF_SUPPORT */"
+echo "#endif /* LIBELF_SUPPORT */"
 echo "};"
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ead5316b3f89..6109fa4d14cd 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -162,7 +162,7 @@ int map__load(struct map *self, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b441b07172b7..8b6ef7fac745 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,7 +12,7 @@
 #include <byteswap.h>
 #include <libgen.h>
 
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
@@ -46,10 +46,10 @@ char *strxfrchar(char *s, char from, char to);
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
  */
-#ifdef LIBELF_NO_MMAP
-# define PERF_ELF_C_READ_MMAP ELF_C_READ
-#else
+#ifdef LIBELF_MMAP
 # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
+#else
+# define PERF_ELF_C_READ_MMAP ELF_C_READ
 #endif
 
 #ifndef DMGL_PARAMS
@@ -233,7 +233,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifndef NO_LIBELF_SUPPORT
+#ifdef LIBELF_SUPPORT
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
-- 
1.7.11.4

