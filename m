Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab2JYH41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:56:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2JYH4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:56:25 -0400
Date: Thu, 25 Oct 2012 00:55:57 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-fbjha6xs5soyaiek8j4142xg@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Diplays more output on features check for make V=1
Git-Commit-ID: 28d213bac4649a1868fa78dab2d3b1ef09235171
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 00:56:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28d213bac4649a1868fa78dab2d3b1ef09235171
Gitweb:     http://git.kernel.org/tip/28d213bac4649a1868fa78dab2d3b1ef09235171
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 9 Oct 2012 17:50:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 14:20:10 -0200

perf tools: Diplays more output on features check for make V=1

Adding more verbose output for compile time features checking, to ease
up debuging of feature detection failures.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-fbjha6xs5soyaiek8j4142xg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |   46 +++++++++++++++++++-------------------
 tools/perf/config/utilities.mak |   11 +++++++-
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f530502..6790cb4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -155,15 +155,15 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
 -include config/feature-tests.mak
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all),y)
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector),y)
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
        CFLAGS := $(CFLAGS) -Wstack-protector
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var),y)
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
        CFLAGS := $(CFLAGS) -Wvolatile-register-var
 endif
 
@@ -172,7 +172,7 @@ endif
 BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS)),y)
+ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	BIONIC := 1
 	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
@@ -477,9 +477,9 @@ ifdef NO_LIBELF
 	NO_LIBUNWIND := 1
 else
 FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
+ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
 	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
-	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
+	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
 		LIBC_SUPPORT := 1
 	endif
 	ifeq ($(BIONIC),1)
@@ -494,7 +494,7 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 	endif
 else
 	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
-	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
+	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
 		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 		NO_DWARF := 1
 	endif # Dwarf support
@@ -510,7 +510,7 @@ ifdef LIBUNWIND_DIR
 endif
 
 FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
 	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
 	NO_LIBUNWIND := 1
 endif # Libunwind support
@@ -539,7 +539,7 @@ LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 else # NO_LIBELF
 BASIC_CFLAGS += -DLIBELF_SUPPORT
 
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON),-DLIBELF_MMAP),y)
 	BASIC_CFLAGS += -DLIBELF_MMAP
 endif
 
@@ -565,7 +565,7 @@ endif
 
 ifndef NO_LIBAUDIT
 	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
-	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT)),y)
+	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
 		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
 	else
 		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
@@ -576,7 +576,7 @@ endif
 
 ifndef NO_NEWT
 	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
-	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
+	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT),libnewt),y)
 		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
 	else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
@@ -605,10 +605,10 @@ endif
 
 ifndef NO_GTK2
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
+	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
 	else
-		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
+		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
 			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
 		endif
 		BASIC_CFLAGS += -DGTK2_SUPPORT
@@ -635,7 +635,7 @@ else
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
+	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
 		BASIC_CFLAGS += -DNO_LIBPERL
 	else
                ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
@@ -689,11 +689,11 @@ else
       PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
       FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
+      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
         $(call disable-python,Python.h (for Python 2.x))
       else
 
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED)),y)
+        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
           $(warning Python 3 is not yet supported; please set)
           $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
           $(warning If you also have Python 2 installed, then)
@@ -727,22 +727,22 @@ else
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
         else
 		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
+		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
 		ifeq ($(has_bfd),y)
 			EXTLIBS += -lbfd
 		else
 			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
+			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
 			ifeq ($(has_bfd_iberty),y)
 				EXTLIBS += -lbfd -liberty
 			else
 				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
+				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
 				ifeq ($(has_bfd_iberty_z),y)
 					EXTLIBS += -lbfd -liberty -lz
 				else
 					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
-					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE))
+					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
 					ifeq ($(has_cplus_demangle),y)
 						EXTLIBS += -liberty
 						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
@@ -764,19 +764,19 @@ ifeq ($(NO_PERF_REGS),0)
 endif
 
 ifndef NO_STRLCPY
-	ifeq ($(call try-cc,$(SOURCE_STRLCPY),),y)
+	ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
 		BASIC_CFLAGS += -DHAVE_STRLCPY
 	endif
 endif
 
 ifndef NO_ON_EXIT
-	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),),y)
+	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
 		BASIC_CFLAGS += -DHAVE_ON_EXIT
 	endif
 endif
 
 ifndef NO_BACKTRACE
-       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
+       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
                BASIC_CFLAGS += -DBACKTRACE_SUPPORT
        endif
 endif
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 8046182..ea853c2 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -180,9 +180,16 @@ _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
 # try-cc
-# Usage: option = $(call try-cc, source-to-build, cc-options)
+# Usage: option = $(call try-cc, source-to-build, cc-options, msg)
+ifndef V
+TRY_CC_OUTPUT= > /dev/null 2>&1
+else
+TRY_CC_MSG=echo "CHK $(3)" 1>&2;
+endif
+
 try-cc = $(shell sh -c						  \
 	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
+	 $(TRY_CC_MSG)						  \
 	 echo "$(1)" |						  \
-	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
+	 $(CC) -x c - $(2) -o "$$TMP" $(TRY_CC_OUTPUT) && echo y; \
 	 rm -f "$$TMP"')
