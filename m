Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2EHDrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:47:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:32888 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751Ab2EHDrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:47:04 -0400
Message-ID: <1336448796.2540.187.camel@pasglop>
Subject: Re: [PATCH] powerpc: use local var instead of
 local_paca->irq_happened directly in __check_irq_replay
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 13:46:36 +1000
In-Reply-To: <1336090207.18712.9.camel@pasglop>
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop>
	 <1336018961.2653.11.camel@pasglop> <4FA226A8.1080903@gmail.com>
	 <4FA22CC5.3010107@gmail.com> <1336032561.18712.1.camel@pasglop>
	 <4FA31653.5090103@gmail.com> <1336090207.18712.9.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang !

Does this patch fixes it for you ?

>From 249f8649bf95a4c3e6637284754a165c1d83c394 Mon Sep 17 00:00:00 2001
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 8 May 2012 13:31:59 +1000
Subject: [PATCH 2/3] powerpc/irq: Fix bug with new lazy IRQ handling code

We had a case where we could turn on hard interrupts while
leaving the PACA_IRQ_HARD_DIS bit set in the PACA. This can
in turn cause a BUG_ON() to hit in __check_irq_replay() due
to interrupt state getting out of sync.

The assembly code was also way too convoluted. Instead, we
now leave it to the C code to do the right thing which ends
up being smaller and more readable.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/entry_64.S |   18 ------------------
 arch/powerpc/kernel/irq.c      |    8 +++++++-
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index fd46046..29f1357 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -763,16 +763,6 @@ do_work:
 	SOFT_DISABLE_INTS(r3,r4)
 1:	bl	.preempt_schedule_irq
 
-	/* Hard-disable interrupts again (and update PACA) */
-#ifdef CONFIG_PPC_BOOK3E
-	wrteei	0
-#else
-	ld	r10,PACAKMSR(r13) /* Get kernel MSR without EE */
-	mtmsrd	r10,1
-#endif /* CONFIG_PPC_BOOK3E */
-	li	r0,PACA_IRQ_HARD_DIS
-	stb	r0,PACAIRQHAPPENED(r13)
-
 	/* Re-test flags and eventually loop */
 	clrrdi	r9,r1,THREAD_SHIFT
 	ld	r4,TI_FLAGS(r9)
@@ -783,14 +773,6 @@ do_work:
 user_work:
 #endif /* CONFIG_PREEMPT */
 
-	/* Enable interrupts */
-#ifdef CONFIG_PPC_BOOK3E
-	wrteei	1
-#else
-	ori	r10,r10,MSR_EE
-	mtmsrd	r10,1
-#endif /* CONFIG_PPC_BOOK3E */
-
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	beq	1f
 	bl	.restore_interrupts
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 5ec1b23..3717fb5 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -260,11 +260,17 @@ EXPORT_SYMBOL(arch_local_irq_restore);
  * if they are currently disabled. This is typically called before
  * schedule() or do_signal() when returning to userspace. We do it
  * in C to avoid the burden of dealing with lockdep etc...
+ *
+ * NOTE: This is called with interrupts hard disabled but not marked
+ * as such in paca->irq_happened, so we need to resync this.
  */
 void restore_interrupts(void)
 {
-	if (irqs_disabled())
+	if (irqs_disabled()) {
+		local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
 		local_irq_enable();
+	} else
+		__hard_irq_enable();
 }
 
 #endif /* CONFIG_PPC64 */
-- 
1.7.9.5



