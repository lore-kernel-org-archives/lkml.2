Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1BJCgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:36:46 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56347 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1BJCgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:36:04 -0500
X-AuditID: b753bd60-a3cb9ba000004916-41-4d534f11088c
X-AuditID: b753bd60-a3cb9ba000004916-41-4d534f11088c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/makefile 1/2] perf tools: Introduce ARCH= option
	for cross building
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Feb 2011 11:28:54 +0900
Message-ID: <20110210022854.15395.10294.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ARCH= option for cross building.
This also ports some ARCH setting code from linux-2.6/Makefile.

Since EXTRA_CFLAGS=-m64/32 does not change some build flags,
we need an appropriate flag for cross building.
e.g., If you want to build x86-32 binary on x86-64, just set
ARCH=i386 for building.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Makefile              |   42 ++++++++++++++++++++++++++------------
 tools/perf/arch/arm/Makefile     |    2 +-
 tools/perf/arch/powerpc/Makefile |    2 +-
 tools/perf/arch/s390/Makefile    |    2 +-
 tools/perf/arch/sh/Makefile      |    2 +-
 tools/perf/arch/sparc/Makefile   |    2 +-
 tools/perf/arch/x86/Makefile     |    2 +-
 7 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b8ba5b0..f7e8a41 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -38,7 +38,7 @@ endif
 #
 # Define LDFLAGS=-static to build a static binary.
 #
-# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
+# Define ARCH=x86_64 or ARCH=i386 as appropriate for cross-builds.
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
@@ -53,21 +53,37 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
-				  -e s/arm.*/arm/ -e s/sa110/arm/ \
-				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
-				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-				  -e s/sh[234].*/sh/ )
+SUBARCH := $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+				     -e s/arm.*/arm/ -e s/sa110/arm/ \
+				     -e s/s390x/s390/ -e s/parisc64/parisc/ \
+				     -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+				     -e s/sh[234].*/sh/ )
+ARCH ?= $(SUBARCH)
+SRCARCH := $(ARCH)
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
-        ARCH := x86
+	SRCARCH := x86
+	EXTRA_CFLAGS=-m32
 endif
 ifeq ($(ARCH),x86_64)
-	RAW_ARCH := x86_64
-        ARCH := x86
+	SRCARCH := x86
 	ARCH_CFLAGS := -DARCH_X86_64
 	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
+	EXTRA_CFLAGS=-m64
+endif
+
+# Additional ARCH settings for sparc
+ifeq ($(ARCH),sparc32)
+       SRCARCH := sparc
+endif
+ifeq ($(ARCH),sparc64)
+       SRCARCH := sparc
+endif
+
+# Additional ARCH settings for sh
+ifeq ($(ARCH),sh64)
+       SRCARCH := sh
 endif
 
 #
@@ -179,7 +195,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS = -Iutil/include -Iarch/$(SRCARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -370,7 +386,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
+ifeq ($(ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
@@ -429,7 +445,7 @@ ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 endif # Dwarf support
 endif # NO_DWARF
 
--include arch/$(ARCH)/Makefile
+-include arch/$(SRCARCH)/Makefile
 
 ifneq ($(OUTPUT),)
 	BASIC_CFLAGS += -I$(OUTPUT)
@@ -451,7 +467,7 @@ endif
 
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+	msg := $(warning DWARF register mappings have not been defined for architecture $(SRCARCH), DWARF support disabled);
 else
 	BASIC_CFLAGS += -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 15130b5..571affa 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -1,4 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(SRCARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 15130b5..571affa 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -1,4 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(SRCARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..571affa 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -1,4 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(SRCARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sh/Makefile b/tools/perf/arch/sh/Makefile
index 15130b5..571affa 100644
--- a/tools/perf/arch/sh/Makefile
+++ b/tools/perf/arch/sh/Makefile
@@ -1,4 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(SRCARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sparc/Makefile b/tools/perf/arch/sparc/Makefile
index 15130b5..571affa 100644
--- a/tools/perf/arch/sparc/Makefile
+++ b/tools/perf/arch/sparc/Makefile
@@ -1,4 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(SRCARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 15130b5..571affa 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -1,4 +1,4 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(SRCARCH)/util/dwarf-regs.o
 endif

