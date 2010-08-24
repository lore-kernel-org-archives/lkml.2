Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab0HXXV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:21:58 -0400
Received: from kroah.org ([198.145.64.141]:40897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329Ab0HXXBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:38 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:03 2010
Message-Id: <20100824224503.279003146@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Barbieri <luca@luca-barbieri.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [023/114] x86, asm: Refactor atomic64_386_32.S to support old binutils and be cleaner
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luca Barbieri <luca@luca-barbieri.com>

commit 30246557a06bb20618bed906a06d1e1e0faa8bb4 upstream.

The old code didn't work on binutils 2.12 because setting a symbol to
a register apparently requires a fairly recent version.

This commit refactors the code to use the C preprocessor instead, and
in the process makes the whole code a bit easier to understand.

The object code produced is unchanged as expected.

This fixes kernel bugzilla 16506.

Reported-by: Dieter Stussy <kd6lvw+software@kd6lvw.ampr.org>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-*@git.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/lib/atomic64_386_32.S |  232 ++++++++++++++++++++++-------------------
 1 file changed, 126 insertions(+), 106 deletions(-)

--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -25,150 +25,170 @@
 	CFI_ADJUST_CFA_OFFSET -4
 .endm
 
-.macro BEGIN func reg
-$v = \reg
+#define BEGIN(op) \
+.macro END; \
+	CFI_ENDPROC; \
+ENDPROC(atomic64_##op##_386); \
+.purgem END; \
+.endm; \
+ENTRY(atomic64_##op##_386); \
+	CFI_STARTPROC; \
+	LOCK v;
 
-ENTRY(atomic64_\func\()_386)
-	CFI_STARTPROC
-	LOCK $v
-
-.macro RETURN
-	UNLOCK $v
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
 
-BEGIN sub_return %ecx
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


