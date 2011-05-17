Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1EQWm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:42:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:19306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab1EQWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050280"
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
Subject: [PATCH 9/9] x86/lib/memset_64.S: Optimize memset by enhanced REP MOVSB/STOSB
Date: Tue, 17 May 2011 15:29:18 -0700
Message-Id: <1305671358-14478-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Support memset() with enhanced rep stosb. On processors supporting enhanced
REP MOVSB/STOSB, the alternative memset_c_e function using enhanced rep stosb
overrides the fast string alternative memset_c and the original function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/lib/memset_64.S |   54 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 09d3442..79bd454 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -2,9 +2,13 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 /*
- * ISO C memset - set a memory block to a byte value.
+ * ISO C memset - set a memory block to a byte value. This function uses fast
+ * string to get better performance than the original function. The code is
+ * simpler and shorter than the orignal function as well.
  *	
  * rdi   destination
  * rsi   value (char) 
@@ -31,6 +35,28 @@
 .Lmemset_e:
 	.previous
 
+/*
+ * ISO C memset - set a memory block to a byte value. This function uses
+ * enhanced rep stosb to override the fast string function.
+ * The code is simpler and shorter than the fast string function as well.
+ *
+ * rdi   destination
+ * rsi   value (char)
+ * rdx   count (bytes)
+ *
+ * rax   original destination
+ */
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemset_c_e:
+	movq %rdi,%r9
+	movb %sil,%al
+	movl %edx,%ecx
+	rep stosb
+	movq %r9,%rax
+	ret
+.Lmemset_e_e:
+	.previous
+
 ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
@@ -112,16 +138,20 @@ ENTRY(__memset)
 ENDPROC(memset)
 ENDPROC(__memset)
 
-	/* Some CPUs run faster using the string instructions.
-	   It is also a lot simpler. Use this when possible */
-
-#include <asm/cpufeature.h>
-
+	/* Some CPUs support enhanced REP MOVSB/STOSB feature.
+	 * It is recommended to use this when possible.
+	 *
+	 * If enhanced REP MOVSB/STOSB feature is not available, use fast string
+	 * instructions.
+	 *
+	 * Otherwise, use original memset function.
+	 *
+	 * In .altinstructions section, ERMS feature is placed after REG_GOOD
+         * feature to implement the right patch order.
+	 */
 	.section .altinstructions,"a"
-	.align 8
-	.quad memset
-	.quad .Lmemset_c
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lfinal - memset
-	.byte .Lmemset_e - .Lmemset_c
+	altinstruction_entry memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
+			     .Lfinal-memset,.Lmemset_e-.Lmemset_c
+	altinstruction_entry memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
+			     .Lfinal-memset,.Lmemset_e_e-.Lmemset_c_e
 	.previous
-- 
1.7.2

