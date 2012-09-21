Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab2IUUCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:02:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2IUUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:02:37 -0400
Date: Fri, 21 Sep 2012 13:02:26 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-51ae4a2d775e1ee456282d7c60e49693d0a8555d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-7-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-7-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap: Add a header file with macros for STAC/
 CLAC
Git-Commit-ID: 51ae4a2d775e1ee456282d7c60e49693d0a8555d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:02:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51ae4a2d775e1ee456282d7c60e49693d0a8555d
Gitweb:     http://git.kernel.org/tip/51ae4a2d775e1ee456282d7c60e49693d0a8555d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:26 -0700

x86, smap: Add a header file with macros for STAC/CLAC

The STAC/CLAC instructions are only available with SMAP, but on the
other hand they aren't needed if SMAP is not available, or before we
start to run userspace, so construct them as alternatives which start
out as noops and are enabled by the alternatives mechanism.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-7-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig            |   11 +++++
 arch/x86/include/asm/smap.h |   91 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..5ce8694 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1487,6 +1487,17 @@ config ARCH_RANDOM
 	  If supported, this is a high bandwidth, cryptographically
 	  secure hardware random number generator.
 
+config X86_SMAP
+	def_bool y
+	prompt "Supervisor Mode Access Prevention" if EXPERT
+	---help---
+	  Supervisor Mode Access Prevention (SMAP) is a security
+	  feature in newer Intel processors.  There is a small
+	  performance cost if this enabled and turned on; there is
+	  also a small increase in the kernel size if this is enabled.
+
+	  If unsure, say Y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
new file mode 100644
index 0000000..3989c24
--- /dev/null
+++ b/arch/x86/include/asm/smap.h
@@ -0,0 +1,91 @@
+/*
+ * Supervisor Mode Access Prevention support
+ *
+ * Copyright (C) 2012 Intel Corporation
+ * Author: H. Peter Anvin <hpa@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifndef _ASM_X86_SMAP_H
+#define _ASM_X86_SMAP_H
+
+#include <linux/stringify.h>
+#include <asm/nops.h>
+#include <asm/cpufeature.h>
+
+/* "Raw" instruction opcodes */
+#define __ASM_CLAC	.byte 0x0f,0x01,0xca
+#define __ASM_STAC	.byte 0x0f,0x01,0xcb
+
+#ifdef __ASSEMBLY__
+
+#include <asm/alternative-asm.h>
+
+#ifdef CONFIG_X86_SMAP
+
+#define ASM_CLAC							\
+	661: ASM_NOP3 ;							\
+	.pushsection .altinstr_replacement, "ax" ;			\
+	662: __ASM_CLAC ;						\
+	.popsection ;							\
+	.pushsection .altinstructions, "a" ;				\
+	altinstruction_entry 661b, 662b, X86_FEATURE_SMAP, 3, 3 ;	\
+	.popsection
+
+#define ASM_STAC							\
+	661: ASM_NOP3 ;							\
+	.pushsection .altinstr_replacement, "ax" ;			\
+	662: __ASM_STAC ;						\
+	.popsection ;							\
+	.pushsection .altinstructions, "a" ;				\
+	altinstruction_entry 661b, 662b, X86_FEATURE_SMAP, 3, 3 ;	\
+	.popsection
+
+#else /* CONFIG_X86_SMAP */
+
+#define ASM_CLAC
+#define ASM_STAC
+
+#endif /* CONFIG_X86_SMAP */
+
+#else /* __ASSEMBLY__ */
+
+#include <asm/alternative.h>
+
+#ifdef CONFIG_X86_SMAP
+
+static inline void clac(void)
+{
+	/* Note: a barrier is implicit in alternative() */
+	alternative(ASM_NOP3, __stringify(__ASM_CLAC), X86_FEATURE_SMAP);
+}
+
+static inline void stac(void)
+{
+	/* Note: a barrier is implicit in alternative() */
+	alternative(ASM_NOP3, __stringify(__ASM_STAC), X86_FEATURE_SMAP);
+}
+
+/* These macros can be used in asm() statements */
+#define ASM_CLAC \
+	ALTERNATIVE(ASM_NOP3, __stringify(__ASM_CLAC), X86_FEATURE_SMAP)
+#define ASM_STAC \
+	ALTERNATIVE(ASM_NOP3, __stringify(__ASM_STAC), X86_FEATURE_SMAP)
+
+#else /* CONFIG_X86_SMAP */
+
+static inline void clac(void) { }
+static inline void stac(void) { }
+
+#define ASM_CLAC
+#define ASM_STAC
+
+#endif /* CONFIG_X86_SMAP */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_SMAP_H */
