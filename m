Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1ERUnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:43:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:56289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1ERUnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:43:35 -0400
Date: Wed, 18 May 2011 20:43:29 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-2f19e06ac30771c7cb96fd61d8aeacfa74dac21c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-10-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-10-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mem: memset_64.S: Optimize memset by enhanced REP MOVSB/STOSB
Git-Commit-ID: 2f19e06ac30771c7cb96fd61d8aeacfa74dac21c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:43:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f19e06ac30771c7cb96fd61d8aeacfa74dac21c
Gitweb:     http://git.kernel.org/tip/2f19e06ac30771c7cb96fd61d8aeacfa74dac21c
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:31 -0700

x86, mem: memset_64.S: Optimize memset by enhanced REP MOVSB/STOSB

Support memset() with enhanced rep stosb. On processors supporting enhanced
REP MOVSB/STOSB, the alternative memset_c_e function using enhanced rep stosb
overrides the fast string alternative memset_c and the original function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-10-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
