Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1A0R3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:29:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1A0R3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:29:08 -0500
Date: Thu, 27 Jan 2011 18:28:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110127172859.GA32432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      percpu, x86: Fix percpu_xchg_op()

Jesper Juhl (1):
      x86-64: Don't use pointer to out-of-scope variable in dump_trace()

Yinghai Lu (1):
      x86: Remove left over system_64.h


 arch/x86/include/asm/percpu.h    |   24 ++++++++++++------------
 arch/x86/include/asm/system_64.h |   22 ----------------------
 arch/x86/kernel/dumpstack_64.c   |    2 +-
 3 files changed, 13 insertions(+), 35 deletions(-)
 delete mode 100644 arch/x86/include/asm/system_64.h

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3788f46..7e17295 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -273,34 +273,34 @@ do {									\
 	typeof(var) pxo_new__ = (nval);					\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("\n1:mov "__percpu_arg(1)",%%al"			\
-		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%al"			\
+		    "\n1:\tcmpxchgb %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "q" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 2:								\
-		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
-		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%ax"			\
+		    "\n1:\tcmpxchgw %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 4:								\
-		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
-		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%eax"			\
+		    "\n1:\tcmpxchgl %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 8:								\
-		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
-		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%rax"			\
+		    "\n1:\tcmpxchgq %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
diff --git a/arch/x86/include/asm/system_64.h b/arch/x86/include/asm/system_64.h
deleted file mode 100644
index 1159e09..0000000
--- a/arch/x86/include/asm/system_64.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_X86_SYSTEM_64_H
-#define _ASM_X86_SYSTEM_64_H
-
-#include <asm/segment.h>
-#include <asm/cmpxchg.h>
-
-
-static inline unsigned long read_cr8(void)
-{
-	unsigned long cr8;
-	asm volatile("movq %%cr8,%0" : "=r" (cr8));
-	return cr8;
-}
-
-static inline void write_cr8(unsigned long val)
-{
-	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
-}
-
-#include <linux/irqflags.h>
-
-#endif /* _ASM_X86_SYSTEM_64_H */
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6410133..a6b6fcf 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -149,13 +149,13 @@ void dump_trace(struct task_struct *task,
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
+	unsigned long dummy;
 	unsigned long bp;
 
 	if (!task)
 		task = current;
 
 	if (!stack) {
-		unsigned long dummy;
 		stack = &dummy;
 		if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
