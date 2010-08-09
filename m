Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0HIFEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:04:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34170
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232Ab0HIFEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:04:31 -0400
Date: Sun, 08 Aug 2010 22:04:50 -0700 (PDT)
Message-Id: <20100808.220450.148531617.davem@davemloft.net>
To: fweisbec@gmail.com
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc64: Fix perf_arch_get_caller_regs().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After b0f82b81fe6bbcf78d478071f33e44554726bc81 ("perf: Drop the skip
argument from perf_arch_fetch_regs_caller") the build broke on sparc64
due to the lack of a module symbol export of __perf_arch_fetch_caller_regs.

But that assembler helper can actually be complete eliminated now that
the semantics of this interface have been greatly simplified.

Signed-off-by: David S. Miller <davem@davemloft.net>
---

Frederic, I'll merge this to Linus via the sparc tree, this is
just FYI...

 arch/sparc/include/asm/perf_event.h |   25 +++++++++--
 arch/sparc/kernel/helpers.S         |   75 -----------------------------------
 2 files changed, 20 insertions(+), 80 deletions(-)

diff --git a/arch/sparc/include/asm/perf_event.h b/arch/sparc/include/asm/perf_event.h
index 74c4e0c..727af70 100644
--- a/arch/sparc/include/asm/perf_event.h
+++ b/arch/sparc/include/asm/perf_event.h
@@ -10,11 +10,26 @@ extern void set_perf_event_pending(void);
 
 extern void init_hw_perf_events(void);
 
-extern void
-__perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
-
-#define perf_arch_fetch_caller_regs(pt_regs, ip)	\
-	__perf_arch_fetch_caller_regs(pt_regs, ip, 1);
+#define perf_arch_fetch_caller_regs(regs, ip)		\
+do {							\
+	unsigned long _pstate, _asi, _pil, _i7, _fp;	\
+	__asm__ __volatile__("rdpr %%pstate, %0\n\t"	\
+			     "rd %%asi, %1\n\t"		\
+			     "rdpr %%pil, %2\n\t"	\
+			     "mov %%i7, %3\n\t"		\
+			     "mov %%i6, %4\n\t"		\
+			     : "=r" (_pstate),		\
+			       "=r" (_asi),		\
+			       "=r" (_pil),		\
+			       "=r" (_i7),		\
+			       "=r" (_fp));		\
+	(regs)->tstate = (_pstate << 8) |		\
+		(_asi << 24) | (_pil << 20);		\
+	(regs)->tpc = (ip);				\
+	(regs)->tnpc = (regs)->tpc + 4;			\
+	(regs)->u_regs[UREG_I6] = _fp;			\
+	(regs)->u_regs[UREG_I7] = _i7;			\
+} while (0)
 #else
 static inline void init_hw_perf_events(void)	{ }
 #endif
diff --git a/arch/sparc/kernel/helpers.S b/arch/sparc/kernel/helpers.S
index 682fee0..314dd0c 100644
--- a/arch/sparc/kernel/helpers.S
+++ b/arch/sparc/kernel/helpers.S
@@ -46,81 +46,6 @@ stack_trace_flush:
 	 nop
 	.size		stack_trace_flush,.-stack_trace_flush
 
-#ifdef CONFIG_PERF_EVENTS
-	.globl		__perf_arch_fetch_caller_regs
-	.type		__perf_arch_fetch_caller_regs,#function
-__perf_arch_fetch_caller_regs:
-	/* We always read the %pstate into %o5 since we will use
-	 * that to construct a fake %tstate to store into the regs.
-	 */
-	rdpr		%pstate, %o5
-	brz,pn		%o2, 50f
-	 mov		%o2, %g7
-
-	/* Turn off interrupts while we walk around the register
-	 * window by hand.
-	 */
-	wrpr		%o5, PSTATE_IE, %pstate
-
-	/* The %canrestore tells us how many register windows are
-	 * still live in the chip above us, past that we have to
-	 * walk the frame as saved on the stack.   We stash away
-	 * the %cwp in %g1 so we can return back to the original
-	 * register window.
-	 */
-	rdpr		%cwp, %g1
-	rdpr		%canrestore, %g2
-	sub		%g1, 1, %g3
-
-	/* We have the skip count in %g7, if it hits zero then
-	 * %fp/%i7 are the registers we need.  Otherwise if our
-	 * %canrestore count maintained in %g2 hits zero we have
-	 * to start traversing the stack.
-	 */
-10:	brz,pn		%g2, 4f
-	 sub		%g2, 1, %g2
-	wrpr		%g3, %cwp
-	subcc		%g7, 1, %g7
-	bne,pt		%xcc, 10b
-	 sub		%g3, 1, %g3
-
-	/* We found the values we need in the cpu's register
-	 * windows.
-	 */
-	mov		%fp, %g3
-	ba,pt		%xcc, 3f
-	 mov		%i7, %g2
-
-50:	mov		%fp, %g3
-	ba,pt		%xcc, 2f
-	 mov		%i7, %g2
-
-	/* We hit the end of the valid register windows in the
-	 * cpu, start traversing the stack frame.
-	 */
-4:	mov		%fp, %g3
-
-20:	ldx		[%g3 + STACK_BIAS + RW_V9_I7], %g2
-	subcc		%g7, 1, %g7
-	bne,pn		%xcc, 20b
-	 ldx		[%g3 + STACK_BIAS + RW_V9_I6], %g3
-
-	/* Restore the current register window position and
-	 * re-enable interrupts.
-	 */
-3:	wrpr		%g1, %cwp
-	wrpr		%o5, %pstate
-
-2:	stx		%g3, [%o0 + PT_V9_FP]
-	sllx		%o5, 8, %o5
-	stx		%o5, [%o0 + PT_V9_TSTATE]
-	stx		%g2, [%o0 + PT_V9_TPC]
-	add		%g2, 4, %g2
-	retl
-	 stx		%g2, [%o0 + PT_V9_TNPC]
-	.size		perf_arch_fetch_caller_regs,.-perf_arch_fetch_caller_regs
-#endif /* CONFIG_PERF_EVENTS */
-
 #ifdef CONFIG_SMP
 	.globl		hard_smp_processor_id
 	.type		hard_smp_processor_id,#function
-- 
1.7.2.1

