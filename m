Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab2AROYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:24:16 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:3780 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab2AROYP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 09:24:15 -0500
Message-Id: <4F16E41B020000780006D7A5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 14:24:11 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <luca@luca-barbieri.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ix86: atomic64 assembly improvements
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmpxchg8b variants of "set" and "xchg" are really identical, and
hence don't need to be repeated: %ebx and %ecx don't need to be copied
into %eax and %edx respectively (this is only necessary when desiring
to only read the stored value), and the LOCK prefix should also be used
in "set" (other than the comment that is now being removed was saying,
there is - to my knowledge - no *architectural* guarantee that aligned
64-bit writes would always be carried out atomically).

In the "add_unless" implementation, swapping the use of %ecx and %esi
for passing arguments allows %esi to become an input only (i.e.
permitting the register to be re-used to address the same object
without reload).

In "{add,sub}_return", doing the initial read64 through the passed in
%ecx decreases a register dependency.

In "inc_not_zero", a branch can be eliminated by or-ing together the
two halves of the current (64-bit) value, and code size can be further
reduced by adjusting the arithmetic slightly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Luca Barbieri <luca@luca-barbieri.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>

---
 arch/x86/include/asm/atomic64_32.h |   13 +++++------
 arch/x86/lib/atomic64_386_32.S     |    6 ++---
 arch/x86/lib/atomic64_cx8_32.S     |   42 +++++++++----------------------------
 3 files changed, 20 insertions(+), 41 deletions(-)

--- tip-i386-atomic64.orig/arch/x86/include/asm/atomic64_32.h
+++ tip-i386-atomic64/arch/x86/include/asm/atomic64_32.h
@@ -36,6 +36,7 @@ typedef struct {
 #define ATOMIC64_EXPORT(sym) __ATOMIC64_EXPORT(sym##_cx8); \
 		__ATOMIC64_EXPORT(sym##_386)
 
+__ATOMIC64_EXPORT(set_386);
 __ATOMIC64_EXPORT(add_386);
 __ATOMIC64_EXPORT(sub_386);
 __ATOMIC64_EXPORT(inc_386);
@@ -46,7 +47,6 @@ __ATOMIC64_EXPORT(dec_386);
 	__alternative_atomic64(f, f, ASM_OUTPUT2(out), ## in)
 
 ATOMIC64_EXPORT(read);
-ATOMIC64_EXPORT(set);
 ATOMIC64_EXPORT(xchg);
 ATOMIC64_EXPORT(add_return);
 ATOMIC64_EXPORT(sub_return);
@@ -104,9 +104,9 @@ static inline void atomic64_set(atomic64
 {
 	unsigned high = (unsigned)(i >> 32);
 	unsigned low = (unsigned)i;
-	alternative_atomic64(set, /* no output */,
-			     "S" (v), "b" (low), "c" (high)
-			     : "eax", "edx", "memory");
+	__alternative_atomic64(set, xchg, /* no output */,
+			       "S" (v), "b" (low), "c" (high)
+			       : "eax", "edx", "memory");
 }
 
 /**
@@ -286,9 +286,8 @@ static inline int atomic64_add_unless(at
 	unsigned low = (unsigned)u;
 	unsigned high = (unsigned)(u >> 32);
 	alternative_atomic64(add_unless,
-			     ASM_OUTPUT2("+A" (a), "+c" (v),
-					 "+S" (low), "+D" (high)),
-			     ASM_NO_INPUT_CLOBBER("memory"));
+			     ASM_OUTPUT2("+A" (a), "+c" (low), "+D" (high)),
+			     "S" (v) : "memory");
 	return (int)a;
 }
 
--- tip-i386-atomic64.orig/arch/x86/lib/atomic64_386_32.S
+++ tip-i386-atomic64/arch/x86/lib/atomic64_386_32.S
@@ -137,13 +137,13 @@ BEGIN(dec_return)
 RET_ENDP
 #undef v
 
-#define v %ecx
+#define v %esi
 BEGIN(add_unless)
-	addl %eax, %esi
+	addl %eax, %ecx
 	adcl %edx, %edi
 	addl  (v), %eax
 	adcl 4(v), %edx
-	cmpl %eax, %esi
+	cmpl %eax, %ecx
 	je 3f
 1:
 	movl %eax,  (v)
--- tip-i386-atomic64.orig/arch/x86/lib/atomic64_cx8_32.S
+++ tip-i386-atomic64/arch/x86/lib/atomic64_cx8_32.S
@@ -39,24 +39,9 @@ ENTRY(atomic64_read_cx8)
 	CFI_ENDPROC
 ENDPROC(atomic64_read_cx8)
 
-ENTRY(atomic64_set_cx8)
-	CFI_STARTPROC
-
-1:
-/* we don't need LOCK_PREFIX since aligned 64-bit writes
- * are atomic on 586 and newer */
-	cmpxchg8b (%esi)
-	jne 1b
-
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_set_cx8)
-
 ENTRY(atomic64_xchg_cx8)
 	CFI_STARTPROC
 
-	movl %ebx, %eax
-	movl %ecx, %edx
 1:
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
@@ -78,7 +63,7 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %edi
 	movl %ecx, %ebp
 
-	read64 %ebp
+	read64 %ecx
 1:
 	movl %eax, %ebx
 	movl %edx, %ecx
@@ -159,23 +144,22 @@ ENTRY(atomic64_add_unless_cx8)
 	SAVE ebx
 /* these just push these two parameters on the stack */
 	SAVE edi
-	SAVE esi
+	SAVE ecx
 
-	movl %ecx, %ebp
-	movl %eax, %esi
+	movl %eax, %ebp
 	movl %edx, %edi
 
-	read64 %ebp
+	read64 %esi
 1:
 	cmpl %eax, 0(%esp)
 	je 4f
 2:
 	movl %eax, %ebx
 	movl %edx, %ecx
-	addl %esi, %ebx
+	addl %ebp, %ebx
 	adcl %edi, %ecx
 	LOCK_PREFIX
-	cmpxchg8b (%ebp)
+	cmpxchg8b (%esi)
 	jne 1b
 
 	movl $1, %eax
@@ -199,13 +183,13 @@ ENTRY(atomic64_inc_not_zero_cx8)
 
 	read64 %esi
 1:
-	testl %eax, %eax
-	je 4f
-2:
+	movl %eax, %ecx
+	orl %edx, %ecx
+	jz 3f
 	movl %eax, %ebx
-	movl %edx, %ecx
+	xorl %ecx, %ecx
 	addl $1, %ebx
-	adcl $0, %ecx
+	adcl %edx, %ecx
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -214,9 +198,5 @@ ENTRY(atomic64_inc_not_zero_cx8)
 3:
 	RESTORE ebx
 	ret
-4:
-	testl %edx, %edx
-	jne 2b
-	jmp 3b
 	CFI_ENDPROC
 ENDPROC(atomic64_inc_not_zero_cx8)


