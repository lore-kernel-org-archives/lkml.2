Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1ERUmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:42:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:56255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab1ERUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:42:45 -0400
Date: Wed, 18 May 2011 20:42:39 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-101068c1f4a947ffa08f2782c78e40097300754d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-8-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-8-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mem: memcpy_64.S: Optimize memcpy by enhanced REP MOVSB/STOSB
Git-Commit-ID: 101068c1f4a947ffa08f2782c78e40097300754d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:42:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  101068c1f4a947ffa08f2782c78e40097300754d
Gitweb:     http://git.kernel.org/tip/101068c1f4a947ffa08f2782c78e40097300754d
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:29 -0700

x86, mem: memcpy_64.S: Optimize memcpy by enhanced REP MOVSB/STOSB

Support memcpy() with enhanced rep movsb. On processors supporting enhanced
rep movsb, the alternative memcpy() function using enhanced rep movsb overrides the original function and the fast string
function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-8-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/memcpy_64.S |   45 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..daab21d 100644
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
