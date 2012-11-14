Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423186Ab2KNQtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:49:02 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36430 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423116Ab2KNQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:48:24 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] perf tools: Separate out GTK codes to libperf-gtk.so
Date: Thu, 15 Nov 2012 01:47:42 +0900
Message-Id: <1352911664-24620-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
References: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out GTK codes to a shared object called libperf-gtk.so.
In order to do that all objects are compiled as PIC like libtraceevent.
For now whole libperf and libtraceevent are built into it.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cd1f346a9f8b..502080cc1b3d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -105,7 +105,7 @@ endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -fPIC
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
 
@@ -639,17 +639,27 @@ ifndef NO_GTK2
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
 	else
 		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
+			GTK_CFLAGS = -DHAVE_GTK_INFO_BAR
 		endif
-		BASIC_CFLAGS += -DGTK2_SUPPORT
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
-		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-	endif
+		GTK_CFLAGS += $(ALL_CFLAGS) -DGTK2_SUPPORT
+		GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+		GTK_LIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+		GTK_OBJS := $(OUTPUT)ui/gtk/browser.o
+		GTK_OBJS += $(OUTPUT)ui/gtk/setup.o
+		GTK_OBJS += $(OUTPUT)ui/gtk/util.o
+		GTK_OBJS += $(OUTPUT)ui/gtk/helpline.o
+		GTK_OBJS += $(OUTPUT)ui/gtk/progress.o
+		GTK_H := ui/gtk/gtk.h
+
+$(GTK_OBJS): %.o: %.c $(LIB_H) $(GTK_H)
+	$(QUIET_CC)$(CC) -o $@ -c $(GTK_CFLAGS) $<
+
+$(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
+	$(QUIET_LINK)$(CC) -o $@ -shared $(GTK_CFLAGS) $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS) $(GTK_LIBS)
+
+all: $(OUTPUT)libperf-gtk.so
+
+endif
 endif
 
 ifdef NO_LIBPERL
@@ -1098,8 +1108,8 @@ $(INSTALL_DOC_TARGETS):
 ### Cleaning rules
 
 clean: $(LIBTRACEEVENT)-clean
-	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
-	$(RM) $(ALL_PROGRAMS) perf
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
+	$(RM) $(ALL_PROGRAMS) $(OUTPUT)libperf-gtk.so
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-- 
1.7.9.2

