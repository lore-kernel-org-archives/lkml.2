Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1HPVM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:12:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42704 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1HPVM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:12:26 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Russell King <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Frysinger <vapier@gentoo.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC,PATCH] arch/arm: compute and export NR_syscalls
Date: Tue, 16 Aug 2011 16:14:26 -0500
Message-Id: <1313529267-4428-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, there is no way to determine, at compile-time, the number of
system calls for arm.  This change provides NR_syscalls via unistd.h
much like other arches.

Historically, there hasn't been a need to pull NR_syscalls into unistd.h
for ARM.  Prior lkml threads indicate as much.  However, NR_syscalls is
a prerequisite for enabling CONFIG_FTRACE_SYSCALLS on the platform
(along with asm/syscall.h population and arch_syscall_addr).

This patch is similar to x86-64 in that the system call
count is established using the Kbuild assembly generation trick
to extract constant values. It adds three files:
- arch/arm/kernel/asm-exports.c
- arch/arm/kernel/Makefile.exports

The C file provides the location to export assembly resident values,
like the number of syscalls.  The makefile mimics Kbuild for extracting
the values from the partially compiled file.

Also included are simple fixups to make calls.S safe to #include in
asm-exports.c and exporting of asm-exports.h in unistd.h.

In particular, this change yields an NR_syscalls value that matches the
number of allocated calls via calls.S and not the aligned, padded syscall
table size needed for optimal assembly.

asm-exports.c is added instead of reusing asm-offsets.c to avoid a
variety of collisions (VM_EXEC, DMA_*, etc).  It is possible to use the
same calls.S mechanism but add NR_syscalls to asm-offsets.c.  However,
at inclusion time for generated/asm-offsets.h, conflicting defines will
need to be #undef'd if !__ASSEMBLY__ since it appears that the purpose
of asm-offsets.h is to safely bind C language definitions to assembly
and not the reverse.

- Is this approach palatable?
- Should I resend only when paired with the other ftrace-needed patches?

Thanks!

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/arm/Makefile                |    3 +-
 arch/arm/include/asm/unistd.h    |    5 ++++
 arch/arm/kernel/Makefile.exports |   42 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/asm-exports.c    |   36 ++++++++++++++++++++++++++++++++
 arch/arm/kernel/calls.S          |    2 +
 5 files changed, 87 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/kernel/Makefile.exports
 create mode 100644 arch/arm/kernel/asm-exports.c

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 70c424e..62abc9a 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -270,8 +270,9 @@ all:	$(KBUILD_IMAGE)
 
 boot := arch/arm/boot
 
-archprepare:
+archprepare: Kbuild
 	$(Q)$(MAKE) $(build)=arch/arm/tools include/generated/mach-types.h
+	$(Q)$(MAKE) $(build)=arch/arm/kernel -f $(src)/arch/arm/kernel/Makefile.exports include/generated/asm-exports.h
 
 # Convert bzImage to zImage
 bzImage: zImage
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 2c04ed5..77d4928 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -481,5 +481,10 @@
 #define __IGNORE_fadvise64_64		1
 #define __IGNORE_migrate_pages		1
 
+#if !defined(COMPILER_OFFSETS) && !defined(__ASSEMBLY__)
+#include <generated/asm-exports.h>
+#define NR_syscalls (__NR_syscall_max + 1)
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_UNISTD_H */
diff --git a/arch/arm/kernel/Makefile.exports b/arch/arm/kernel/Makefile.exports
new file mode 100644
index 0000000..5ec6553
--- /dev/null
+++ b/arch/arm/kernel/Makefile.exports
@@ -0,0 +1,42 @@
+#
+# linux/arch/arm/kernel/Makefile.exports
+#
+# Copyright (C) 2011 Chromium OS Authors <chromium-os-dev@chromium.org>
+#
+# Generate asm-exports.h based on Kbuild's asm-offsets.h
+#
+
+exports-file := include/generated/asm-exports.h
+
+# Default sed regexp - multiline due to syntax constraints
+define sed-y
+	"/^->/{s:->#\(.*\):/* \1 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:->::; p;}"
+endef
+
+quiet_cmd_exports = GEN     $@
+define cmd_exports
+	(set -e; \
+	 echo "#ifndef __ASM_EXPORTS_H__"; \
+	 echo "#define __ASM_EXPORTS_H__"; \
+	 echo "/*"; \
+	 echo " * DO NOT MODIFY."; \
+	 echo " *"; \
+	 echo " * This file was generated by arch/arm/tools/Makefile"; \
+	 echo " *"; \
+	 echo " */"; \
+	 echo ""; \
+	 sed -ne $(sed-y) $<; \
+	 echo ""; \
+	 echo "#endif" ) > $@
+endef
+
+# We use internal kbuild rules to avoid the "is up to date" message from make
+$(src)/../asm-exports.s: $(src)/../kernel/asm-exports.c FORCE
+	$(Q)mkdir -p $(dir $@)
+	$(call if_changed_dep,cc_s_c)
+
+$(exports-file): $(src)/../kernel/asm-exports.s Kbuild
+	$(call cmd,exports)
diff --git a/arch/arm/kernel/asm-exports.c b/arch/arm/kernel/asm-exports.c
new file mode 100644
index 0000000..a2aec12
--- /dev/null
+++ b/arch/arm/kernel/asm-exports.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2011 Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * Generate definitions needed by C language modules from data resident
+ * in assembly language modules. Nothing exported here should be supplied
+ * by any C language headers in common use.
+ *
+ * This code generates raw asm output which is post-processed to extract
+ * and format the required data.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define COMPILE_OFFSETS
+#include <linux/kbuild.h>
+
+/*
+ * Make sure that the compiler and target are compatible.
+ */
+#if defined(__APCS_26__)
+#error Sorry, your compiler targets APCS-26 but this kernel requires APCS-32
+#endif
+
+#define CALL(x) 1 +
+#define syscalls_counted
+#define NO_PAD_SYSCALLS 1
+static const long syscall_count =
+	#include "calls.S"
+	0;
+
+int main(void)
+{
+	DEFINE(__NR_syscall_max, syscall_count - 1);
+	return 0;
+}
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 80f7896..02cdece 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -385,6 +385,7 @@
 		CALL(sys_syncfs)
 		CALL(sys_sendmmsg)
 /* 375 */	CALL(sys_setns)
+#ifndef NO_PAD_SYSCALLS
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
@@ -392,3 +393,4 @@
 .rept syscalls_padding
 		CALL(sys_ni_syscall)
 .endr
+#endif
-- 
1.7.0.4

