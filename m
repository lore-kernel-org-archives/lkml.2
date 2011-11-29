Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1K2GDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:03:01 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58245 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1K2GC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:02:57 -0500
X-AuditID: b753bd60-9aa63ba00000359c-11-4ed4758e5030
X-AuditID: b753bd60-9aa63ba00000359c-11-4ed4758e5030
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 2/4] x86: check stack overflow in detail
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 29 Nov 2011 15:08:29 +0900
Message-ID: <20111129060829.11076.51733.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only kernel stack is checked for the overflow, which is
not sufficient for systems that need a high reliability. To enhance
it, it is required to check the IRQ and exception stacks, as well.

This patch checks all the stack types and will cause messages of
stacks in detail when free stack space drops below a certain
limit except user stack.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/Kconfig.debug   |    7 +++++--
 arch/x86/kernel/irq_64.c |   29 +++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bf56e17..4caec12 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -63,8 +63,11 @@ config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
 	---help---
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
+	  Say Y here if you want to check the overflows of kernel, IRQ
+	  and exception stacks. This option will cause messages of the
+	  stacks in detail when free stack space drops below a certain
+	  limit.
+	  If in doubt, say "N".
 
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 69bca46..11ae893 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -36,18 +36,35 @@ EXPORT_PER_CPU_SYMBOL(irq_regs);
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
+	struct orig_ist *oist;
+	u64 irq_stack_top, irq_stack_bottom;
+	u64 estack_top, estack_bottom;
 	u64 curbase = (u64)task_stack_page(current);
 
 	if (user_mode_vm(regs))
 		return;
 
-	WARN_ONCE(regs->sp >= curbase &&
-		  regs->sp <= curbase + THREAD_SIZE &&
-		  regs->sp <  curbase + sizeof(struct thread_info) +
-					sizeof(struct pt_regs) + 128,
+	if (regs->sp >= curbase &&
+	    regs->sp <= curbase + THREAD_SIZE &&
+	    regs->sp >= curbase + sizeof(struct thread_info) +
+				  sizeof(struct pt_regs) + 128)
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
 
-		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
-			current->comm, curbase, regs->sp);
+	WARN_ONCE(1, "do_IRQ: %s near or already stack overflow (cur:%Lx,sp:%lx,irq stk top-bottom:%Lx-%Lx,exception stk top-bottom:%Lx-%Lx)\n",
+		current->comm, curbase, regs->sp,
+		irq_stack_top, irq_stack_bottom,
+		estack_top, estack_bottom);
 #endif
 }
 

