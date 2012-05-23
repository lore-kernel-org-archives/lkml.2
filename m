Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515Ab2EWTd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965353Ab2EWTdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:33:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/16] perf, tool: Add interface to arch registers sets
Date: Wed, 23 May 2012 21:32:09 +0200
Message-Id: <1337801535-12865-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding header files to access unified API for arch registers.

In addition adding a way to obtain register name based on the
API ID value.

Also adding PERF_REGS_MASK macro with mask definition of
all current arch registers (will be used in unwind patches).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                     |   13 ++++-
 tools/perf/arch/x86/include/perf_regs.h |  108 +++++++++++++++++++++++++++++++
 tools/perf/util/perf_regs.h             |   19 ++++++
 3 files changed, 139 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/arch/x86/include/perf_regs.h
 create mode 100644 tools/perf/util/perf_regs.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cf5c71e..44b99bb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -50,13 +50,15 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ )
+NO_PERF_REGS_DEFS := 1
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
-        ARCH := x86
+	ARCH := x86
+	NO_PERF_REGS_DEFS := 0
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
@@ -69,6 +71,7 @@ ifeq ($(ARCH),x86_64)
 		ARCH_CFLAGS := -DARCH_X86_64
 		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
 	endif
+	NO_PERF_REGS_DEFS := 0
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
 
+ifeq ($(NO_PERF_REGS_DEFS),0)
+	ifeq ($(ARCH),x86)
+		LIB_H += arch/x86/include/perf_regs.h
+	endif
+else
+	BASIC_CFLAGS += -DNO_PERF_REGS_DEFS
+endif
 
 ifdef NO_STRLCPY
 	BASIC_CFLAGS += -DNO_STRLCPY
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
new file mode 100644
index 0000000..d6070ec
--- /dev/null
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -0,0 +1,108 @@
+#ifndef ARCH_PERF_REGS_H
+#define ARCH_PERF_REGS_H
+
+#include <stdlib.h>
+#include "../../util/types.h"
+
+#ifdef ARCH_X86_64
+#include "../../../../../arch/x86/include/asm/perf_regs_64.h"
+
+#define PERF_REGS_MASK ((1 << PERF_X86_64_REG_MAX) - 1)
+#define PERF_REG_IP PERF_X86_64_REG_RIP
+#define PERF_REG_SP PERF_X86_64_REG_RSP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_X86_64_REG_RAX:
+		return "RAX";
+	case PERF_X86_64_REG_RBX:
+		return "RBX";
+	case PERF_X86_64_REG_RCX:
+		return "RCX";
+	case PERF_X86_64_REG_RDX:
+		return "RDX";
+	case PERF_X86_64_REG_RSI:
+		return "RSI";
+	case PERF_X86_64_REG_RDI:
+		return "RDI";
+	case PERF_X86_64_REG_R8:
+		return "R8";
+	case PERF_X86_64_REG_R9:
+		return "R9";
+	case PERF_X86_64_REG_R10:
+		return "R10";
+	case PERF_X86_64_REG_R11:
+		return "R11";
+	case PERF_X86_64_REG_R12:
+		return "R12";
+	case PERF_X86_64_REG_R13:
+		return "R13";
+	case PERF_X86_64_REG_R14:
+		return "R14";
+	case PERF_X86_64_REG_R15:
+		return "R15";
+	case PERF_X86_64_REG_RBP:
+		return "RBP";
+	case PERF_X86_64_REG_RSP:
+		return "RSP";
+	case PERF_X86_64_REG_RIP:
+		return "RIP";
+	case PERF_X86_64_REG_FLAGS:
+		return "FLAGS";
+	case PERF_X86_64_REG_CS:
+		return "CS";
+	case PERF_X86_64_REG_SS:
+		return "SS";
+	default:
+		return NULL;
+	}
+	return NULL;
+}
+#else
+#include "../../../../../arch/x86/include/asm/perf_regs_32.h"
+
+#define PERF_REGS_MASK ((1 << PERF_X86_32_REG_MAX) - 1)
+#define PERF_REG_IP PERF_X86_32_REG_EIP
+#define PERF_REG_SP PERF_X86_32_REG_ESP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_X86_32_REG_EAX:
+		return "EAX";
+	case PERF_X86_32_REG_EBX:
+		return "EBX";
+	case PERF_X86_32_REG_ECX:
+		return "ECX";
+	case PERF_X86_32_REG_EDX:
+		return "EDX";
+	case PERF_X86_32_REG_ESI:
+		return "ESI";
+	case PERF_X86_32_REG_EDI:
+		return "EDI";
+	case PERF_X86_32_REG_EBP:
+		return "EBP";
+	case PERF_X86_32_REG_ESP:
+		return "ESP";
+	case PERF_X86_32_REG_EIP:
+		return "EIP";
+	case PERF_X86_32_REG_FLAGS:
+		return "FLAGS";
+	case PERF_X86_32_REG_CS:
+		return "CS";
+	case PERF_X86_32_REG_DS:
+		return "DS";
+	case PERF_X86_32_REG_ES:
+		return "ES";
+	case PERF_X86_32_REG_FS:
+		return "FS";
+	case PERF_X86_32_REG_GS:
+		return "GS";
+	default:
+		return NULL;
+	}
+	return NULL;
+}
+#endif /* ARCH_X86_64 */
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
new file mode 100644
index 0000000..d65cbf9
--- /dev/null
+++ b/tools/perf/util/perf_regs.h
@@ -0,0 +1,19 @@
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
+
+static inline unsigned long perf_reg_version(void)
+{
+	return 0;
+}
+#endif /* NO_PERF_REGS_DEFS */
+#endif /* __PERF_REGS_H */
-- 
1.7.7.6

