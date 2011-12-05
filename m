Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1LENSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:18:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab1LENSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:18:40 -0500
Date: Mon, 5 Dec 2011 05:18:20 -0800
From: tip-bot for Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Message-ID: <tip-37fe6a42b3433b79a159ceb06a94cd1ef00e279d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, tglx@linutronix.de, mingo@elte.hu,
        mitsuo.hayasaka.hu@hitachi.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rdunlap@xenotime.net,
        mitsuo.hayasaka.hu@hitachi.com, mingo@elte.hu
In-Reply-To: <20111129060829.11076.51733.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060829.11076.51733.stgit@ltc219.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Check stack overflow in detail
Git-Commit-ID: 37fe6a42b3433b79a159ceb06a94cd1ef00e279d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:18:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37fe6a42b3433b79a159ceb06a94cd1ef00e279d
Gitweb:     http://git.kernel.org/tip/37fe6a42b3433b79a159ceb06a94cd1ef00e279d
Author:     Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
AuthorDate: Tue, 29 Nov 2011 15:08:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 11:37:45 +0100

x86: Check stack overflow in detail

Currently, only kernel stack is checked for the overflow, which
is not sufficient for systems that need a high reliability. To
enhance it, it is required to check the IRQ and exception
stacks, as well.

This patch checks all the stack types and will cause messages of
stacks in detail when free stack space drops below a certain
limit except user stack.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/20111129060829.11076.51733.stgit@ltc219.sdl.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 69bca46..928a7e9 100644
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
+	WARN_ONCE(1, "do_IRQ(): %s has overflown the kernel stack (cur:%Lx,sp:%lx,irq stk top-bottom:%Lx-%Lx,exception stk top-bottom:%Lx-%Lx)\n",
+		current->comm, curbase, regs->sp,
+		irq_stack_top, irq_stack_bottom,
+		estack_top, estack_bottom);
 #endif
 }
 
