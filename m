Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1ERUnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:43:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:56273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab1ERUnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:43:09 -0400
Date: Wed, 18 May 2011 20:43:02 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-057e05c1d6440117875f455e59da8691e08f65d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-9-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-9-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mem: memmove_64.S: Optimize memmove by enhanced REP MOVSB/STOSB
Git-Commit-ID: 057e05c1d6440117875f455e59da8691e08f65d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:43:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  057e05c1d6440117875f455e59da8691e08f65d5
Gitweb:     http://git.kernel.org/tip/057e05c1d6440117875f455e59da8691e08f65d5
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:30 -0700

x86, mem: memmove_64.S: Optimize memmove by enhanced REP MOVSB/STOSB

Support memmove() by enhanced rep movsb. On processors supporting enhanced
REP MOVSB/STOSB, the alternative memmove() function using enhanced rep movsb
overrides the original function.

The patch doesn't change the backward memmove case to use enhanced rep
movsb.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-9-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/memmove_64.S |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 0ecb843..d0ec9c2 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -8,6 +8,7 @@
 #define _STRING_C
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
 
 #undef memmove
 
@@ -24,6 +25,7 @@
  */
 ENTRY(memmove)
 	CFI_STARTPROC
+
 	/* Handle more 32bytes in loop */
 	mov %rdi, %rax
 	cmp $0x20, %rdx
@@ -31,8 +33,13 @@ ENTRY(memmove)
 
 	/* Decide forward/backward copy mode */
 	cmp %rdi, %rsi
-	jb	2f
+	jge .Lmemmove_begin_forward
+	mov %rsi, %r8
+	add %rdx, %r8
+	cmp %rdi, %r8
+	jg 2f
 
+.Lmemmove_begin_forward:
 	/*
 	 * movsq instruction have many startup latency
 	 * so we handle small size by general register.
@@ -78,6 +85,8 @@ ENTRY(memmove)
 	rep movsq
 	movq %r11, (%r10)
 	jmp 13f
+.Lmemmove_end_forward:
+
 	/*
 	 * Handle data backward by movsq.
 	 */
@@ -194,4 +203,22 @@ ENTRY(memmove)
 13:
 	retq
 	CFI_ENDPROC
+
+	.section .altinstr_replacement,"ax"
+.Lmemmove_begin_forward_efs:
+	/* Forward moving data. */
+	movq %rdx, %rcx
+	rep movsb
+	retq
+.Lmemmove_end_forward_efs:
+	.previous
+
+	.section .altinstructions,"a"
+	.align 8
+	.quad .Lmemmove_begin_forward
+	.quad .Lmemmove_begin_forward_efs
+	.word X86_FEATURE_ERMS
+	.byte .Lmemmove_end_forward-.Lmemmove_begin_forward
+	.byte .Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
+	.previous
 ENDPROC(memmove)
