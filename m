Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1LOJ5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:57:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab1LOJ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:57:03 -0500
Date: Thu, 15 Dec 2011 01:55:59 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-cebef5beed3de3037de85a521495897256b2c5da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@suse.com, cl@linux.com, dhowells@redhat.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, cl@linux.com, dhowells@redhat.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
References: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Fix and improve percpu_cmpxchg{8,16}b_double()
Git-Commit-ID: cebef5beed3de3037de85a521495897256b2c5da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Dec 2011 01:56:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cebef5beed3de3037de85a521495897256b2c5da
Gitweb:     http://git.kernel.org/tip/cebef5beed3de3037de85a521495897256b2c5da
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 14 Dec 2011 08:33:25 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Dec 2011 08:17:14 +0100

x86: Fix and improve percpu_cmpxchg{8,16}b_double()

They had several problems/shortcomings:

Only the first memory operand was mentioned in the 2x32bit asm()
operands, and 2x64-bit version had a memory clobber. The first
allowed the compiler to not recognize the need to re-load the
data in case it had it cached in some register, and the second
was overly destructive.

The memory operand in the 2x32-bit asm() was declared to only be
an output.

The types of the local copies of the old and new values were
incorrect (as in other per-CPU ops, the types of the per-CPU
variables accessed should be used here, to make sure the
respective types are compatible).

The __dummy variable was pointless (and needlessly initialized
in the 2x32-bit case), given that local copies of the inputs
already exist.

The 2x64-bit variant forced the address of the first object into
%rsi, even though this is needed only for the call to the
emulation function. The real cmpxchg16b can operate on an
memory.

At once also change the return value type to what it really is -
'bool'.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4EE86D6502000078000679FE@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h |   53 ++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3470c9d..529bf07e 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
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
 
