Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0KSVaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:30:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:45786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab0KSVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:30:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Morell <rmorell@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf tools: Remove hardcoded include paths for elfutils
Date: Fri, 19 Nov 2010 19:29:43 -0200
Message-Id: <1290202186-25352-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Morell <rmorell@nvidia.com>

This change removes the use of hardcoded absolute "/usr/include/elfutils" paths
from the perf build.  The problem with hardcoded paths is that it prevents them
from being overridden by $prefix or by -I in CFLAGS (e.g., for cross-compiling
purposes).

Instead, just include the "elfutils/" subdirectory as a relative path when
files are needed from that directory.

Tested by building perf:
- Cross-compiled for ARM on x86_64
- Built natively on x86_64
- Built on x86_64 with /usr/include/elfutils moved to another location
  and manually included in CFLAGS

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1289945793-31441-1-git-send-email-rmorell@nvidia.com>
Signed-off-by: Robert Morell <rmorell@nvidia.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |    4 ++--
 tools/perf/feature-tests.mak   |    4 ++--
 tools/perf/util/probe-finder.h |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d1db0f6..74b684d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -507,7 +507,7 @@ PERFLIBS = $(LIB_FILE)
 -include config.mak
 
 ifndef NO_DWARF
-FLAGS_DWARF=$(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 	NO_DWARF := 1
@@ -554,7 +554,7 @@ ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
 else
-	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
+	BASIC_CFLAGS += -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
 endif # PERF_HAVE_DWARF_REGS
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b253db6..b041ca6 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -9,8 +9,8 @@ endef
 ifndef NO_DWARF
 define SOURCE_DWARF
 #include <dwarf.h>
-#include <libdw.h>
-#include <version.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
 #ifndef _ELFUTILS_PREREQ
 #error
 #endif
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index bba69d4..beaefc3 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -34,9 +34,9 @@ extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
 				  bool externs);
 
 #include <dwarf.h>
-#include <libdw.h>
-#include <libdwfl.h>
-#include <version.h>
+#include <elfutils/libdw.h>
+#include <elfutils/libdwfl.h>
+#include <elfutils/version.h>
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
-- 
1.6.2.5

