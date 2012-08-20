Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2HTEpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:45:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2HTEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:25 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 7/7] perf: make demangle support based on CONFIG_DEMANGLE
Date: Sun, 19 Aug 2012 22:44:51 -0600
Message-Id: <1345437891-78830-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile      |   25 ++++++++++++++-----------
 tools/perf/util/symbol.h |    6 +++---
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b481d77..d31fe1d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,8 +34,6 @@ include config/utilities.mak
 #
 # Define WERROR=0 to disable treating any warnings as errors.
 #
-# Define NO_DEMANGLE if you do not want C++ symbol demangling.
-#
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
@@ -459,9 +457,14 @@ PYRF_OBJS += $(OUTPUT)util/xyarray.o
 -include config.mak.autogen
 -include config.mak
 
+ifdef CONFIG_DEMANGLE
+    ifdef NO_LIBELF
+        $(error CONFIG_DEMANGLE requires LIBELF)
+    endif
+endif
+
 ifdef NO_LIBELF
 	NO_DWARF := 1
-	NO_DEMANGLE := 1
 	NO_LIBUNWIND := 1
 else
 FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
@@ -472,7 +475,9 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 	else
 		NO_LIBELF := 1
 		NO_DWARF := 1
-		NO_DEMANGLE := 1
+        ifdef CONFIG_DEMANGLE
+            $(error CONFIG_DEMANGLE requires elf support)
+        endif
 	endif
 endif
 endif # NO_LIBELF
@@ -676,13 +681,11 @@ ifdef CONFIG_LIBPYTHON
     LANG_BINDINGS += $(OUTPUT)python/perf.so
 endif
 
-ifdef NO_DEMANGLE
-	BASIC_CFLAGS += -DNO_DEMANGLE
-else
-        ifdef HAVE_CPLUS_DEMANGLE
+ifdef CONFIG_DEMANGLE
+	ifdef HAVE_CPLUS_DEMANGLE
 		EXTLIBS += -liberty
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-        else
+	else
 		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
 		ifeq ($(has_bfd),y)
@@ -704,8 +707,8 @@ else
 						EXTLIBS += -liberty
 						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 					else
-						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-						BASIC_CFLAGS += -DNO_DEMANGLE
+                        $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+                        $(error )
 					endif
 				endif
 			endif
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fc4b1e6..25f3b52 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -25,14 +25,14 @@ static inline char *bfd_demangle(void __used *v, const char *c, int i)
 	return cplus_demangle(c, i);
 }
 #else
-#ifdef NO_DEMANGLE
+#ifdef CONFIG_DEMANGLE
+#include <bfd.h>
+#else
 static inline char *bfd_demangle(void __used *v, const char __used *c,
 				 int __used i)
 {
 	return NULL;
 }
-#else
-#include <bfd.h>
 #endif
 #endif
 
-- 
1.7.10.1

