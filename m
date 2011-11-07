Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1KGFrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:47:33 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54566 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1KGFrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:47:31 -0500
X-AuditID: b753bd60-9a062ba00000359c-12-4eb770f1fb0e
X-AuditID: b753bd60-9a062ba00000359c-12-4eb770f1fb0e
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 2/5] x86: check stack overflow in detail
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 07 Nov 2011 14:52:50 +0900
Message-ID: <20111107055250.7928.79908.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only kernel stack is checked for the overflow, which is
not suffcient for enterprise systems. To enhance reliability,
it is required to check the IRQ and exception stacks, as well.

This patch optionally checks all the stack types and will cause
messages of stacks in detail when free stack space drops below a
certain limit except user stack. This is disabled by default in
Kconfig.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/Kconfig.debug   |   11 +++++++++++
 arch/x86/kernel/irq_64.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bf56e17..0d98beb 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -66,6 +66,17 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
+config DEBUG_STACKOVERFLOW_DETAIL
+	bool "Check for stack overflows in detail"
+	depends on DEBUG_KERNEL && DEBUG_STACKOVERFLOW
+	depends on X86_64
+	---help---
+	  Say Y here if you want to check the overflows of IRQ and
+	  exception stacks in addition to kernel stack. This option will
+	  cause messages of the stacks in detail when free stack space
+	  drops below a certain limit.
+	  If in doubt, say "N".
+
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 69bca46..530cfd0 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -37,10 +37,37 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 {
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
+#ifdef CONFIG_DEBUG_STACKOVERFLOW_DETAIL
+	struct orig_ist *oist;
+	u64 irq_stack_top, irq_stack_bottom;
+	u64 estack_top, estack_bottom;
+#endif
 
 	if (user_mode_vm(regs))
 		return;
 
+#ifdef CONFIG_DEBUG_STACKOVERFLOW_DETAIL
+	if (regs->sp >= curbase + sizeof(struct thread_info) +
+				sizeof(struct pt_regs) + 128 &&
+		regs->sp <= curbase + THREAD_SIZE)
+		return;
+
+	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack);
+	irq_stack_bottom = (u64)__get_cpu_var(irq_stack_ptr);
+	if (regs->sp >= irq_stack_top && regs->sp <= irq_stack_bottom)
+		return;
+
+	oist = &__get_cpu_var(orig_ist);
+	estack_top = (u64)oist->ist[0] - EXCEPTION_STKSZ;
+	estack_bottom = (u64)oist->ist[N_EXCEPTION_STACKS - 1];
+	if (regs->sp >= estack_top && regs->sp <= estack_bottom)
+		return;
+
+	WARN_ONCE(1, "do_IRQ: %s near or already stack stack overflow (cur:%Lx,sp:%lx,irq stk top-bottom:%Lx-%Lx,exception stk top-bottom:%Lx-%Lx)\n",
+		current->comm, curbase, regs->sp,
+		irq_stack_top, irq_stack_bottom,
+		estack_top, estack_bottom);
+#else
 	WARN_ONCE(regs->sp >= curbase &&
 		  regs->sp <= curbase + THREAD_SIZE &&
 		  regs->sp <  curbase + sizeof(struct thread_info) +
@@ -48,6 +75,7 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 
 		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
 			current->comm, curbase, regs->sp);
+#endif /* CONFIG_DEBUG_STACKOVERFLOW_DETAIL */
 #endif
 }
 

