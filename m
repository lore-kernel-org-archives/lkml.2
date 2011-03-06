Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1CFWIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 17:08:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42825 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab1CFWIV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 17:08:21 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 06 Mar 2011 22:08:03 +0000
Message-ID: <1299449283.3134.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] perf: Define make variables ARCH and SRCARCH consistently
 with Kbuild
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is confusing to use RAW_ARCH/ARCH instead of ARCH/SRCARCH.  The
current definitions also make it difficult to build for i386 on an
x86_64 host.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/Makefile              |   20 ++++++++------------
 tools/perf/arch/arm/Makefile     |    2 +-
 tools/perf/arch/powerpc/Makefile |    2 +-
 tools/perf/arch/s390/Makefile    |    2 +-
 tools/perf/arch/sh/Makefile      |    2 +-
 tools/perf/arch/sparc/Makefile   |    2 +-
 tools/perf/arch/x86/Makefile     |    2 +-
 7 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7141c42..c5d09b0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -174,19 +174,15 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+ARCH ?= $(uname_M)
+SRCARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-				  -e s/sh[234].*/sh/ )
+				  -e s/sh[234].*/sh/ -e s/x86_64/x86/ )
 
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-        ARCH := x86
-endif
+# Additional ARCH settings for x86_64
 ifeq ($(ARCH),x86_64)
-	RAW_ARCH := x86_64
-        ARCH := x86
 	ARCH_CFLAGS := -DARCH_X86_64
 	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
 endif
@@ -305,7 +301,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS = -Iutil/include -Iarch/$(SRCARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -488,7 +484,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
+ifeq ($(ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
@@ -533,7 +529,7 @@ ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 endif # Dwarf support
 endif # NO_DWARF
 
--include arch/$(ARCH)/Makefile
+-include arch/$(SRCARCH)/Makefile
 
 ifeq ($(uname_S),Darwin)
 	ifndef NO_FINK
@@ -571,7 +567,7 @@ endif
 
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
-- 
1.7.4.1


