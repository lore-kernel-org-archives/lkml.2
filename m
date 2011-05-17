Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab1EQWnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:43:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:2478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab1EQWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050275"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 7/9] x86/lib/memcpy_64.S: Optimize memcpy by enhanced REP MOVSB/STOSB
Date: Tue, 17 May 2011 15:29:16 -0700
Message-Id: <1305671358-14478-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Support memcpy() with enhanced rep movsb. On processors supporting enhanced
rep movsb, the alternative memcpy() function using enhanced rep movsb overrides the original function and the fast string
function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/lib/memcpy_64.S |   45 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 2a560bb..efbf2a0 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -4,6 +4,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 /*
  * memcpy - Copy a memory block.
@@ -37,6 +38,23 @@
 .Lmemcpy_e:
 	.previous
 
+/*
+ * memcpy_c_e() - enhanced fast string memcpy. This is faster and simpler than
+ * memcpy_c. Use memcpy_c_e when possible.
+ *
+ * This gets patched over the unrolled variant (below) via the
+ * alternative instructions framework:
+ */
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemcpy_c_e:
+	movq %rdi, %rax
+
+	movl %edx, %ecx
+	rep movsb
+	ret
+.Lmemcpy_e_e:
+	.previous
+
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
@@ -171,21 +189,22 @@ ENDPROC(memcpy)
 ENDPROC(__memcpy)
 
 	/*
-	 * Some CPUs run faster using the string copy instructions.
-	 * It is also a lot simpler. Use this when possible:
-	 */
-
-	.section .altinstructions, "a"
-	.align 8
-	.quad memcpy
-	.quad .Lmemcpy_c
-	.word X86_FEATURE_REP_GOOD
-
-	/*
+	 * Some CPUs are adding enhanced REP MOVSB/STOSB feature
+	 * If the feature is supported, memcpy_c_e() is the first choice.
+	 * If enhanced rep movsb copy is not available, use fast string copy
+	 * memcpy_c() when possible. This is faster and code is simpler than
+	 * original memcpy().
+	 * Otherwise, original memcpy() is used.
+	 * In .altinstructions section, ERMS feature is placed after REG_GOOD
+         * feature to implement the right patch order.
+	 *
 	 * Replace only beginning, memcpy is used to apply alternatives,
 	 * so it is silly to overwrite itself with nops - reboot is the
 	 * only outcome...
 	 */
-	.byte .Lmemcpy_e - .Lmemcpy_c
-	.byte .Lmemcpy_e - .Lmemcpy_c
+	.section .altinstructions, "a"
+	altinstruction_entry memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
+			     .Lmemcpy_e-.Lmemcpy_c,.Lmemcpy_e-.Lmemcpy_c
+	altinstruction_entry memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
+			     .Lmemcpy_e_e-.Lmemcpy_c_e,.Lmemcpy_e_e-.Lmemcpy_c_e
 	.previous
-- 
1.7.2

