Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2JEIbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:31:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2JEIbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:31:10 -0400
Date: Fri, 5 Oct 2012 01:30:53 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-29a0fc9b2b6084e7a8810481df62a0fa496d8957@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-4-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to LIBELF_SUPPORT
Git-Commit-ID: 29a0fc9b2b6084e7a8810481df62a0fa496d8957
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:30:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29a0fc9b2b6084e7a8810481df62a0fa496d8957
Gitweb:     http://git.kernel.org/tip/29a0fc9b2b6084e7a8810481df62a0fa496d8957
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:31:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Sep 2012 21:07:36 -0300

perf tools: Convert to LIBELF_SUPPORT

For building perf without libelf, we can set NO_LIBELF=1 as a argument
of make.  It then defines NO_LIBELF_SUPPORT macro for C code to do the
proper handling.  However it usually used in a negative semantics -
e.g. #ifndef - so we saw double negations which can be misleading.
Convert it to a positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    7 +++----
 tools/perf/builtin-inject.c         |    2 +-
 tools/perf/perf.c                   |    2 +-
 tools/perf/util/generate-cmdlist.sh |    4 ++--
 tools/perf/util/map.c               |    2 +-
 tools/perf/util/symbol.h            |   10 +++++-----
 6 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9cd4913..1df0917 100644
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
index 1eaa661..b5ab084 100644
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
index fc2f770..dacae4b 100644
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
index 389590c..3ac3803 100755
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
index ead5316..6109fa4 100644
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
index b441b07..8b6ef7f 100644
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
 
