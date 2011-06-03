Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1FCX2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:28:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:50708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1FCX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:28:29 -0400
Date: Fri, 3 Jun 2011 23:28:17 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-a268fcfaa6ab2ef740fda5ecf947aca45ccd535d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <1306873314-32523-2-git-send-email-bp@alien8.de>
References: <1306873314-32523-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Thin down SAVE/RESTORE_* asm macros
Git-Commit-ID: a268fcfaa6ab2ef740fda5ecf947aca45ccd535d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 23:28:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a268fcfaa6ab2ef740fda5ecf947aca45ccd535d
Gitweb:     http://git.kernel.org/tip/a268fcfaa6ab2ef740fda5ecf947aca45ccd535d
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Tue, 31 May 2011 22:21:51 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 3 Jun 2011 14:38:49 -0700

x86, asm: Thin down SAVE/RESTORE_* asm macros

Use dwarf2 cfi annotation macros, making SAVE/RESTORE_* marginally more
readable.

No functionality change.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1306873314-32523-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/calling.h |  101 ++++++++++++++++------------------------
 1 files changed, 41 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 30af5a8..b67e06c 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -46,6 +46,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 */
 
+#include "dwarf2.h"
 
 /*
  * 64-bit system call stack frame layout defines and helpers, for
@@ -87,30 +88,25 @@ For 32-bit we have the following conventions - kernel is built with
 	.macro SAVE_ARGS addskip=0, norcx=0, nor891011=0
 	subq  $9*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
-	movq  %rdi, 8*8(%rsp)
-	CFI_REL_OFFSET	rdi, 8*8
-	movq  %rsi, 7*8(%rsp)
-	CFI_REL_OFFSET	rsi, 7*8
-	movq  %rdx, 6*8(%rsp)
-	CFI_REL_OFFSET	rdx, 6*8
+	movq_cfi rdi, 8*8
+	movq_cfi rsi, 7*8
+	movq_cfi rdx, 6*8
+
 	.if \norcx
 	.else
-	movq  %rcx, 5*8(%rsp)
-	CFI_REL_OFFSET	rcx, 5*8
+	movq_cfi rcx, 5*8
 	.endif
-	movq  %rax, 4*8(%rsp)
-	CFI_REL_OFFSET	rax, 4*8
+
+	movq_cfi rax, 4*8
+
 	.if \nor891011
 	.else
-	movq  %r8, 3*8(%rsp)
-	CFI_REL_OFFSET	r8,  3*8
-	movq  %r9, 2*8(%rsp)
-	CFI_REL_OFFSET	r9,  2*8
-	movq  %r10, 1*8(%rsp)
-	CFI_REL_OFFSET	r10, 1*8
-	movq  %r11, (%rsp)
-	CFI_REL_OFFSET	r11, 0*8
+	movq_cfi r8,  3*8
+	movq_cfi r9,  2*8
+	movq_cfi r10, 1*8
+	movq_cfi r11, 0*8
 	.endif
+
 	.endm
 
 #define ARG_SKIP	(9*8)
@@ -119,37 +115,34 @@ For 32-bit we have the following conventions - kernel is built with
 			    skipr8910=0, skiprdx=0
 	.if \skipr11
 	.else
-	movq (%rsp), %r11
-	CFI_RESTORE r11
+	movq_cfi_restore 0*8, r11
 	.endif
+
 	.if \skipr8910
 	.else
-	movq 1*8(%rsp), %r10
-	CFI_RESTORE r10
-	movq 2*8(%rsp), %r9
-	CFI_RESTORE r9
-	movq 3*8(%rsp), %r8
-	CFI_RESTORE r8
+	movq_cfi_restore 1*8, r10
+	movq_cfi_restore 2*8, r9
+	movq_cfi_restore 3*8, r8
 	.endif
+
 	.if \skiprax
 	.else
-	movq 4*8(%rsp), %rax
-	CFI_RESTORE rax
+	movq_cfi_restore 4*8, rax
 	.endif
+
 	.if \skiprcx
 	.else
-	movq 5*8(%rsp), %rcx
-	CFI_RESTORE rcx
+	movq_cfi_restore 5*8, rcx
 	.endif
+
 	.if \skiprdx
 	.else
-	movq 6*8(%rsp), %rdx
-	CFI_RESTORE rdx
+	movq_cfi_restore 6*8, rdx
 	.endif
-	movq 7*8(%rsp), %rsi
-	CFI_RESTORE rsi
-	movq 8*8(%rsp), %rdi
-	CFI_RESTORE rdi
+
+	movq_cfi_restore 7*8, rsi
+	movq_cfi_restore 8*8, rdi
+
 	.if ARG_SKIP+\addskip > 0
 	addq $ARG_SKIP+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	-(ARG_SKIP+\addskip)
@@ -176,33 +169,21 @@ For 32-bit we have the following conventions - kernel is built with
 	.macro SAVE_REST
 	subq $REST_SKIP, %rsp
 	CFI_ADJUST_CFA_OFFSET	REST_SKIP
-	movq %rbx, 5*8(%rsp)
-	CFI_REL_OFFSET	rbx, 5*8
-	movq %rbp, 4*8(%rsp)
-	CFI_REL_OFFSET	rbp, 4*8
-	movq %r12, 3*8(%rsp)
-	CFI_REL_OFFSET	r12, 3*8
-	movq %r13, 2*8(%rsp)
-	CFI_REL_OFFSET	r13, 2*8
-	movq %r14, 1*8(%rsp)
-	CFI_REL_OFFSET	r14, 1*8
-	movq %r15, (%rsp)
-	CFI_REL_OFFSET	r15, 0*8
+	movq_cfi rbx, 5*8
+	movq_cfi rbp, 4*8
+	movq_cfi r12, 3*8
+	movq_cfi r13, 2*8
+	movq_cfi r14, 1*8
+	movq_cfi r15, 0*8
 	.endm
 
 	.macro RESTORE_REST
-	movq (%rsp),     %r15
-	CFI_RESTORE r15
-	movq 1*8(%rsp),  %r14
-	CFI_RESTORE r14
-	movq 2*8(%rsp),  %r13
-	CFI_RESTORE r13
-	movq 3*8(%rsp),  %r12
-	CFI_RESTORE r12
-	movq 4*8(%rsp),  %rbp
-	CFI_RESTORE rbp
-	movq 5*8(%rsp),  %rbx
-	CFI_RESTORE rbx
+	movq_cfi_restore 0*8, r15
+	movq_cfi_restore 1*8, r14
+	movq_cfi_restore 2*8, r13
+	movq_cfi_restore 3*8, r12
+	movq_cfi_restore 4*8, rbp
+	movq_cfi_restore 5*8, rbx
 	addq $REST_SKIP, %rsp
 	CFI_ADJUST_CFA_OFFSET	-(REST_SKIP)
 	.endm
