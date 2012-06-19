Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2FSPtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab2FSPtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 17/23] perf, tool: Add libunwind dependency for dwarf cfi unwinding
Date: Tue, 19 Jun 2012 17:48:08 +0200
Message-Id: <1340120894-9465-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding libunwind to be linked with perf if available. It's required
for the to get dwarf cfi unwinding support.

Also building perf with the dwarf call frame informations by default,
so that we can unwind callchains in perf itself.

Adding LIBUNWIND_DIR Makefile variable allowing user to specify
the directory with libunwind to be linked. This is used for
debug purposes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                 |   27 ++++++++++++++++++++++++++-
 tools/perf/config/feature-tests.mak |   25 +++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f412fb1..4993a97 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -59,6 +59,7 @@ AR = $(CROSS_COMPILE)ar
 ifeq ($(ARCH),i386)
 	ARCH := x86
 	NO_PERF_REGS := 0
+	LIBUNWIND_LIBS = -lunwind -lunwind-x86
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
@@ -72,6 +73,7 @@ ifeq ($(ARCH),x86_64)
 		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
 	endif
 	NO_PERF_REGS := 0
+	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
 endif
 
 # Treat warnings as errors unless directed not to
@@ -92,7 +94,7 @@ ifdef PARSER_DEBUG
 	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
@@ -458,6 +460,21 @@ ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 endif # Dwarf support
 endif # NO_DWARF
 
+ifndef NO_LIBUNWIND
+# for linking with debug library, run like:
+# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+ifdef LIBUNWIND_DIR
+	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+endif
+
+FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
+	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
+	NO_LIBUNWIND := 1
+endif # Libunwind support
+endif # NO_LIBUNWIND
+
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -489,6 +506,14 @@ else
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
+ifdef NO_LIBUNWIND
+	BASIC_CFLAGS += -DNO_LIBUNWIND_SUPPORT
+else
+	EXTLIBS += $(LIBUNWIND_LIBS)
+	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
+endif
+
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index d9084e0..51cd201 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -141,3 +141,28 @@ int main(void)
 	return 0;
 }
 endef
+
+ifndef NO_LIBUNWIND
+define SOURCE_LIBUNWIND
+#include <libunwind.h>
+#include <stdlib.h>
+
+extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+                                      unw_word_t ip,
+                                      unw_dyn_info_t *di,
+                                      unw_proc_info_t *pi,
+                                      int need_unwind_info, void *arg);
+
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+int main(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+	return 0;
+}
+endef
+endif
-- 
1.7.7.6

