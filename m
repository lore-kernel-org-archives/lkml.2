Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0HLGOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 02:14:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:38081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab0HLGOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 02:14:11 -0400
Date: Thu, 12 Aug 2010 06:12:53 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luca@luca-barbieri.com, kd6lvw+software@kd6lvw.ampr.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luca@luca-barbieri.com, kd6lvw+software@kd6lvw.ampr.org,
        tglx@linutronix.de
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support old binutils and be cleaner
Message-ID: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
Git-Commit-ID: 30246557a06bb20618bed906a06d1e1e0faa8bb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 06:12:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30246557a06bb20618bed906a06d1e1e0faa8bb4
Gitweb:     http://git.kernel.org/tip/30246557a06bb20618bed906a06d1e1e0faa8bb4
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Fri, 6 Aug 2010 04:04:38 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 11 Aug 2010 21:03:28 -0700

x86, asm: Refactor atomic64_386_32.S to support old binutils and be cleaner

The old code didn't work on binutils 2.12 because setting a symbol to
a register apparently requires a fairly recent version.

This commit refactors the code to use the C preprocessor instead, and
in the process makes the whole code a bit easier to understand.

The object code produced is unchanged as expected.

This fixes kernel bugzilla 16506.

Reported-by: Dieter Stussy <kd6lvw+software@kd6lvw.ampr.org>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org> 2.6.35
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/lib/atomic64_386_32.S |  236 ++++++++++++++++++++++------------------
 1 files changed, 128 insertions(+), 108 deletions(-)

diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 4a5979a..78ee8e0 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -25,150 +25,170 @@
 	CFI_ADJUST_CFA_OFFSET -4
 .endm
 
-.macro BEGIN func reg
-$v = \reg
-
-ENTRY(atomic64_\func\()_386)
-	CFI_STARTPROC
-	LOCK $v
-
-.macro RETURN
-	UNLOCK $v
+#define BEGIN(op) \
+.macro END; \
+	CFI_ENDPROC; \
+ENDPROC(atomic64_##op##_386); \
+.purgem END; \
+.endm; \
+ENTRY(atomic64_##op##_386); \
+	CFI_STARTPROC; \
+	LOCK v;
+
+#define RET \
+	UNLOCK v; \
 	ret
-.endm
-
-.macro END_
-	CFI_ENDPROC
-ENDPROC(atomic64_\func\()_386)
-.purgem RETURN
-.purgem END_
-.purgem END
-.endm
-
-.macro END
-RETURN
-END_
-.endm
-.endm
-
-BEGIN read %ecx
-	movl  ($v), %eax
-	movl 4($v), %edx
-END
-
-BEGIN set %esi
-	movl %ebx,  ($v)
-	movl %ecx, 4($v)
-END
-
-BEGIN xchg %esi
-	movl  ($v), %eax
-	movl 4($v), %edx
-	movl %ebx,  ($v)
-	movl %ecx, 4($v)
-END
-
-BEGIN add %ecx
-	addl %eax,  ($v)
-	adcl %edx, 4($v)
-END
 
-BEGIN add_return %ecx
-	addl  ($v), %eax
-	adcl 4($v), %edx
-	movl %eax,  ($v)
-	movl %edx, 4($v)
-END
-
-BEGIN sub %ecx
-	subl %eax,  ($v)
-	sbbl %edx, 4($v)
-END
-
-BEGIN sub_return %ecx
+#define RET_END \
+	RET; \
+	END
+
+#define v %ecx
+BEGIN(read)
+	movl  (v), %eax
+	movl 4(v), %edx
+RET_END
+#undef v
+
+#define v %esi
+BEGIN(set)
+	movl %ebx,  (v)
+	movl %ecx, 4(v)
+RET_END
+#undef v
+
+#define v  %esi
+BEGIN(xchg)
+	movl  (v), %eax
+	movl 4(v), %edx
+	movl %ebx,  (v)
+	movl %ecx, 4(v)
+RET_END
+#undef v
+
+#define v %ecx
+BEGIN(add)
+	addl %eax,  (v)
+	adcl %edx, 4(v)
+RET_END
+#undef v
+
+#define v %ecx
+BEGIN(add_return)
+	addl  (v), %eax
+	adcl 4(v), %edx
+	movl %eax,  (v)
+	movl %edx, 4(v)
+RET_END
+#undef v
+
+#define v %ecx
+BEGIN(sub)
+	subl %eax,  (v)
+	sbbl %edx, 4(v)
+RET_END
+#undef v
+
+#define v %ecx
+BEGIN(sub_return)
 	negl %edx
 	negl %eax
 	sbbl $0, %edx
-	addl  ($v), %eax
-	adcl 4($v), %edx
-	movl %eax,  ($v)
-	movl %edx, 4($v)
-END
-
-BEGIN inc %esi
-	addl $1,  ($v)
-	adcl $0, 4($v)
-END
-
-BEGIN inc_return %esi
-	movl  ($v), %eax
-	movl 4($v), %edx
+	addl  (v), %eax
+	adcl 4(v), %edx
+	movl %eax,  (v)
+	movl %edx, 4(v)
+RET_END
+#undef v
+
+#define v %esi
+BEGIN(inc)
+	addl $1,  (v)
+	adcl $0, 4(v)
+RET_END
+#undef v
+
+#define v %esi
+BEGIN(inc_return)
+	movl  (v), %eax
+	movl 4(v), %edx
 	addl $1, %eax
 	adcl $0, %edx
-	movl %eax,  ($v)
-	movl %edx, 4($v)
-END
-
-BEGIN dec %esi
-	subl $1,  ($v)
-	sbbl $0, 4($v)
-END
-
-BEGIN dec_return %esi
-	movl  ($v), %eax
-	movl 4($v), %edx
+	movl %eax,  (v)
+	movl %edx, 4(v)
+RET_END
+#undef v
+
+#define v %esi
+BEGIN(dec)
+	subl $1,  (v)
+	sbbl $0, 4(v)
+RET_END
+#undef v
+
+#define v %esi
+BEGIN(dec_return)
+	movl  (v), %eax
+	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
-	movl %eax,  ($v)
-	movl %edx, 4($v)
-END
+	movl %eax,  (v)
+	movl %edx, 4(v)
+RET_END
+#undef v
 
-BEGIN add_unless %ecx
+#define v %ecx
+BEGIN(add_unless)
 	addl %eax, %esi
 	adcl %edx, %edi
-	addl  ($v), %eax
-	adcl 4($v), %edx
+	addl  (v), %eax
+	adcl 4(v), %edx
 	cmpl %eax, %esi
 	je 3f
 1:
-	movl %eax,  ($v)
-	movl %edx, 4($v)
+	movl %eax,  (v)
+	movl %edx, 4(v)
 	movl $1, %eax
 2:
-RETURN
+	RET
 3:
 	cmpl %edx, %edi
 	jne 1b
 	xorl %eax, %eax
 	jmp 2b
-END_
+END
+#undef v
 
-BEGIN inc_not_zero %esi
-	movl  ($v), %eax
-	movl 4($v), %edx
+#define v %esi
+BEGIN(inc_not_zero)
+	movl  (v), %eax
+	movl 4(v), %edx
 	testl %eax, %eax
 	je 3f
 1:
 	addl $1, %eax
 	adcl $0, %edx
-	movl %eax,  ($v)
-	movl %edx, 4($v)
+	movl %eax,  (v)
+	movl %edx, 4(v)
 	movl $1, %eax
 2:
-RETURN
+	RET
 3:
 	testl %edx, %edx
 	jne 1b
 	jmp 2b
-END_
+END
+#undef v
 
-BEGIN dec_if_positive %esi
-	movl  ($v), %eax
-	movl 4($v), %edx
+#define v %esi
+BEGIN(dec_if_positive)
+	movl  (v), %eax
+	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
 	js 1f
-	movl %eax,  ($v)
-	movl %edx, 4($v)
+	movl %eax,  (v)
+	movl %edx, 4(v)
 1:
-END
+RET_END
+#undef v
