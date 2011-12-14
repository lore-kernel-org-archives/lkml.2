Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1LNIdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:33:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:56216 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1LNIdb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 14 Dec 2011 03:33:31 -0500
Message-Id: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 14 Dec 2011 08:33:25 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix and improve percpu_cmpxchg{8,16}b_double()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They had several problems/shortcomings:

Only the first memory operand was mentioned in the 2x32bit asm()
operands, and 2x64-bit version had a memory clobber. The first allowed
the compiler to not recognize the need to re-load the data in case it
had it cached in some register, and the second was overly destructive.

The memory operand in the 2x32-bit asm() was declared to only be an
output.

The types of the local copies of the old and new values were incorrect
(as in other per-CPU ops, the types of the per-CPU variables accessed
should be used here, to make sure the respective types are compatible).

The __dummy variable was pointless (and needlessly initialized in the
2x32-bit case), given that local copies of the inputs already exist.

The 2x64-bit variant forced the address of the first object into %rsi,
even though this is needed only for the call to the emulation function.
The real cmpxchg16b can operate on an memory.

At once also change the return value type to what it really is -
'bool'.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/percpu.h |   53 ++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

--- 3.2-rc5/arch/x86/include/asm/percpu.h
+++ 3.2-rc5-x86-cpu-cmpxchg-double/arch/x86/include/asm/percpu.h
@@ -451,23 +451,20 @@ do {									\
 #endif /* !CONFIG_M386 */
 
 #ifdef CONFIG_X86_CMPXCHG64
-#define percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)			\
+#define percpu_cmpxchg8b_double(pcp1, pcp2, o1, o2, n1, n2)		\
 ({									\
-	char __ret;							\
-	typeof(o1) __o1 = o1;						\
-	typeof(o1) __n1 = n1;						\
-	typeof(o2) __o2 = o2;						\
-	typeof(o2) __n2 = n2;						\
-	typeof(o2) __dummy = n2;					\
+	bool __ret;							\
+	typeof(pcp1) __o1 = (o1), __n1 = (n1);				\
+	typeof(pcp2) __o2 = (o2), __n2 = (n2);				\
 	asm volatile("cmpxchg8b "__percpu_arg(1)"\n\tsetz %0\n\t"	\
-		    : "=a"(__ret), "=m" (pcp1), "=d"(__dummy)		\
-		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
+		    : "=a" (__ret), "+m" (pcp1), "+m" (pcp2), "+d" (__o2) \
+		    :  "b" (__n1), "c" (__n2), "a" (__o1));		\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
-#define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
-#define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
+#define __this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define irqsafe_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #endif /* CONFIG_X86_CMPXCHG64 */
 
 /*
@@ -508,31 +505,23 @@ do {									\
  * it in software.  The address used in the cmpxchg16 instruction must be
  * aligned to a 16 byte boundary.
  */
-#ifdef CONFIG_SMP
-#define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP3
-#else
-#define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP2
-#endif
-#define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
+#define percpu_cmpxchg16b_double(pcp1, pcp2, o1, o2, n1, n2)		\
 ({									\
-	char __ret;							\
-	typeof(o1) __o1 = o1;						\
-	typeof(o1) __n1 = n1;						\
-	typeof(o2) __o2 = o2;						\
-	typeof(o2) __n2 = n2;						\
-	typeof(o2) __dummy;						\
-	alternative_io(CMPXCHG16B_EMU_CALL,				\
-		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
+	bool __ret;							\
+	typeof(pcp1) __o1 = (o1), __n1 = (n1);				\
+	typeof(pcp2) __o2 = (o2), __n2 = (n2);				\
+	alternative_io("leaq %P1,%%rsi\n\tcall this_cpu_cmpxchg16b_emu\n\t", \
+		       "cmpxchg16b " __percpu_arg(1) "\n\tsetz %0\n\t",	\
 		       X86_FEATURE_CX16,				\
-		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
-		       "S" (&pcp1), "b"(__n1), "c"(__n2),		\
-		       "a"(__o1), "d"(__o2) : "memory");		\
+		       ASM_OUTPUT2("=a" (__ret), "+m" (pcp1),		\
+				   "+m" (pcp2), "+d" (__o2)),		\
+		       "b" (__n1), "c" (__n2), "a" (__o1) : "rsi");	\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
-#define this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
-#define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
+#define __this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define irqsafe_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 
 #endif
 


