Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2FSPuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab2FSPug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:50:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 16/23] perf, tool: Add interface to arch registers sets
Date: Tue, 19 Jun 2012 17:48:07 +0200
Message-Id: <1340120894-9465-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding header files to access unified API for arch registers.
  util/perf_regs.h - global perf_reg declarations
  arch/x86/include/perf_regs.h - x86 arch specific

Adding perf_reg_name function to obtain register name based
on the API ID value, and PERF_REGS_MASK macro with mask
definition of all current arch registers (will be used in
unwind patches).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                     |   13 +++++-
 tools/perf/arch/x86/include/perf_regs.h |   80 +++++++++++++++++++++++++++++++
 tools/perf/util/perf_regs.h             |   14 +++++
 3 files changed, 106 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/arch/x86/include/perf_regs.h
 create mode 100644 tools/perf/util/perf_regs.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e48b969..f412fb1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -50,13 +50,15 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ )
+NO_PERF_REGS := 1
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
-        ARCH := x86
+	ARCH := x86
+	NO_PERF_REGS := 0
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
@@ -69,6 +71,7 @@ ifeq ($(ARCH),x86_64)
 		ARCH_CFLAGS := -DARCH_X86_64
 		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
 	endif
+	NO_PERF_REGS := 0
 endif
 
 # Treat warnings as errors unless directed not to
@@ -320,6 +323,7 @@ LIB_H += util/cgroup.h
 LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
 LIB_H += util/vdso.h
+LIB_H += util/perf_regs.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -665,6 +669,13 @@ else
 	endif
 endif
 
+ifeq ($(NO_PERF_REGS),0)
+	ifeq ($(ARCH),x86)
+		LIB_H += arch/x86/include/perf_regs.h
+	endif
+else
+	BASIC_CFLAGS += -DNO_PERF_REGS
+endif
 
 ifdef NO_STRLCPY
 	BASIC_CFLAGS += -DNO_STRLCPY
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
new file mode 100644
index 0000000..ee5aff6
--- /dev/null
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -0,0 +1,80 @@
+#ifndef ARCH_PERF_REGS_H
+#define ARCH_PERF_REGS_H
+
+#include <stdlib.h>
+#include "../../util/types.h"
+#include "../../../../../arch/x86/include/asm/perf_regs.h"
+
+#ifndef ARCH_X86_64
+#define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
+#else
+#define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
+		       (1ULL << PERF_REG_X86_ES) | \
+		       (1ULL << PERF_REG_X86_FS) | \
+		       (1ULL << PERF_REG_X86_GS))
+#define PERF_REGS_MASK (((1ULL << PERF_REG_X86_64_MAX) - 1) & ~REG_NOSUPPORT)
+#endif
+#define PERF_REG_IP PERF_REG_X86_IP
+#define PERF_REG_SP PERF_REG_X86_SP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_REG_X86_AX:
+		return "AX";
+	case PERF_REG_X86_BX:
+		return "BX";
+	case PERF_REG_X86_CX:
+		return "CX";
+	case PERF_REG_X86_DX:
+		return "DX";
+	case PERF_REG_X86_SI:
+		return "SI";
+	case PERF_REG_X86_DI:
+		return "DI";
+	case PERF_REG_X86_BP:
+		return "BP";
+	case PERF_REG_X86_SP:
+		return "SP";
+	case PERF_REG_X86_IP:
+		return "IP";
+	case PERF_REG_X86_FLAGS:
+		return "FLAGS";
+	case PERF_REG_X86_CS:
+		return "CS";
+	case PERF_REG_X86_DS:
+		return "DS";
+	case PERF_REG_X86_ES:
+		return "ES";
+	case PERF_REG_X86_FS:
+		return "FS";
+	case PERF_REG_X86_GS:
+		return "GS";
+#ifdef ARCH_X86_64
+	case PERF_REG_X86_R8:
+		return "R8";
+	case PERF_REG_X86_R9:
+		return "R9";
+	case PERF_REG_X86_R10:
+		return "R10";
+	case PERF_REG_X86_R11:
+		return "R11";
+	case PERF_REG_X86_R12:
+		return "R12";
+	case PERF_REG_X86_R13:
+		return "R13";
+	case PERF_REG_X86_R14:
+		return "R14";
+	case PERF_REG_X86_R15:
+		return "R15";
+	case PERF_REG_X86_SS:
+		return "SS";
+#endif /* ARCH_X86_64 */
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
new file mode 100644
index 0000000..3efb79a
--- /dev/null
+++ b/tools/perf/util/perf_regs.h
@@ -0,0 +1,14 @@
+#ifndef __PERF_REGS_H
+#define __PERF_REGS_H
+
+#ifndef NO_PERF_REGS_DEFS
+#include <perf_regs.h>
+#else
+#define PERF_REGS_MASK	0
+
+static inline const char *perf_reg_name(int id __used)
+{
+	return NULL;
+}
+#endif /* NO_PERF_REGS_DEFS */
+#endif /* __PERF_REGS_H */
-- 
1.7.7.6

