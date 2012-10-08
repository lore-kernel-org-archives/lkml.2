Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2JHWds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:33:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:41448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2JHWdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/25] perf tools: Update Makefile for Android
Date: Mon,  8 Oct 2012 19:32:49 -0300
Message-Id: <1349735570-19339-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

For cross-compiling on Android, some specific changes are needed in
the Makefile.

Update the Makefile to support cross-compiling for Android.
The original ideea for this was send by Bernhard Rosenkraenzer in
https://lkml.org/lkml/2012/8/23/316, but this is a rewrite.

Changes:
() support bionic in addition to glibc
() remove rt and pthread libraries that do not exist in Android
() use $(CFLAGS) when detecting initial compiler flags. This is needed
when setting CFLAGS as an argument of make (e.g. for setting --sysroot).
() include perf's local directory when building for Android to be able to find
relative paths if using --sysroot (e.g.: ../../include/linux/perf_event.h)

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1349678613-7045-3-git-send-email-irina.tirdea@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |   25 +++++++++++++++++++------
 tools/perf/config/feature-tests.mak |    9 +++++++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a7d8745..318bec8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -155,15 +155,15 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
 -include config/feature-tests.mak
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wstack-protector),y)
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector),y)
        CFLAGS := $(CFLAGS) -Wstack-protector
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wvolatile-register-var),y)
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var),y)
        CFLAGS := $(CFLAGS) -Wvolatile-register-var
 endif
 
@@ -172,6 +172,13 @@ endif
 BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
+ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS)),y)
+	BIONIC := 1
+	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+	BASIC_CFLAGS += -I.
+endif
+
 # Guard against environment variables
 BUILTIN_OBJS =
 LIB_H =
@@ -469,12 +476,18 @@ else
 FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
-	ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
-		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-	else
+	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
+		LIBC_SUPPORT := 1
+	endif
+	ifeq ($(BIONIC),1)
+		LIBC_SUPPORT := 1
+	endif
+	ifeq ($(LIBC_SUPPORT),1)
 		NO_LIBELF := 1
 		NO_DWARF := 1
 		NO_DEMANGLE := 1
+	else
+		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 	endif
 else
 	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index eaeb0fd..3ef5ec9 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -43,6 +43,15 @@ int main(void)
 }
 endef
 
+define SOURCE_BIONIC
+#include <android/api-level.h>
+
+int main(void)
+{
+	return __ANDROID_API__;
+}
+endef
+
 define SOURCE_ELF_MMAP
 #include <libelf.h>
 int main(void)
-- 
1.7.9.2.358.g22243

