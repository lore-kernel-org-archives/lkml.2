Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1LGIXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:23:39 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48891 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab1LGIXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:23:38 -0500
X-AuditID: b753bd60-9fe84ba000000655-7a-4edf22885a45
X-AuditID: b753bd60-9fe84ba000000655-7a-4edf22885a45
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH tip ] x86: add stack top margin for stack overflow checking
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 07 Dec 2011 17:29:10 +0900
Message-ID: <20111207082910.9847.3359.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that a margin for stack overflow checking is added to
top of a kernel stack but is not added to IRQ and exception stacks
in stack_overflow_check(). Therefore, the overflows of IRQ and
exception stacks are always detected only after they actually
occurred and data corruption might occur due to them.

This patch adds the margin to top of IRQ and exception stacks
as well as a kernel stack to enhance reliability.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/irq_64.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 54e2b2b..15e97c7 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -38,6 +38,7 @@ int sysctl_panic_on_stackoverflow;
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
+#define STACK_TOP_MARGIN	128
 	struct orig_ist *oist;
 	u64 irq_stack_top, irq_stack_bottom;
 	u64 estack_top, estack_bottom;
@@ -47,17 +48,18 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 		return;
 
 	if (regs->sp >= curbase + sizeof(struct thread_info) +
-				  sizeof(struct pt_regs) + 128 &&
+				  sizeof(struct pt_regs) + STACK_TOP_MARGIN &&
 	    regs->sp <= curbase + THREAD_SIZE)
 		return;
 
-	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack);
+	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack) +
+			STACK_TOP_MARGIN;
 	irq_stack_bottom = (u64)__get_cpu_var(irq_stack_ptr);
 	if (regs->sp >= irq_stack_top && regs->sp <= irq_stack_bottom)
 		return;
 
 	oist = &__get_cpu_var(orig_ist);
-	estack_top = (u64)oist->ist[0] - EXCEPTION_STKSZ;
+	estack_top = (u64)oist->ist[0] - EXCEPTION_STKSZ + STACK_TOP_MARGIN;
 	estack_bottom = (u64)oist->ist[N_EXCEPTION_STACKS - 1];
 	if (regs->sp >= estack_top && regs->sp <= estack_bottom)
 		return;
@@ -69,6 +71,7 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 
 	if (sysctl_panic_on_stackoverflow)
 		panic("low stack detected by irq handler - check messages\n");
+#undef STACK_TOP_MARGIN
 #endif
 }
 

