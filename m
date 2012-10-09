Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2JIRml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:42:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2JIRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:42:35 -0400
Date: Tue, 9 Oct 2012 10:42:07 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        Bernhard.Rosenkranzer@linaro.org, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        Bernhard.Rosenkranzer@linaro.org, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1349678613-7045-3-git-send-email-irina.tirdea@gmail.com>
References: <1349678613-7045-3-git-send-email-irina.tirdea@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Update Makefile for Android
Git-Commit-ID: d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:42:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
Gitweb:     http://git.kernel.org/tip/d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Mon, 8 Oct 2012 09:43:27 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2012 17:42:16 -0300

perf tools: Update Makefile for Android

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
