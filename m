Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1LGPoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:44:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab1LGPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:44:29 -0500
Date: Wed, 7 Dec 2011 07:44:02 -0800
From: tip-bot for Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Message-ID: <tip-d2db6610219cbcadceea6c43ee03d89068b7d759@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, mitsuo.hayasaka.hu@hitachi.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mitsuo.hayasaka.hu@hitachi.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111207082910.9847.3359.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111207082910.9847.3359.stgit@ltc219.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Add stack top margin for stack overflow checking
Git-Commit-ID: d2db6610219cbcadceea6c43ee03d89068b7d759
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 07:44:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2db6610219cbcadceea6c43ee03d89068b7d759
Gitweb:     http://git.kernel.org/tip/d2db6610219cbcadceea6c43ee03d89068b7d759
Author:     Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
AuthorDate: Wed, 7 Dec 2011 17:29:10 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Dec 2011 09:27:11 +0100

x86: Add stack top margin for stack overflow checking

It seems that a margin for stack overflow checking is added to
top of a kernel stack but is not added to IRQ and exception
stacks in stack_overflow_check(). Therefore, the overflows of
IRQ and exception stacks are always detected only after they
actually occurred and data corruption might occur due to them.

This patch adds the margin to top of IRQ and exception stacks
as well as a kernel stack to enhance reliability.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20111207082910.9847.3359.stgit@ltc219.sdl.hitachi.co.jp
[ removed the #undef - we typically don't do that for uncommon names ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_64.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 54e2b2b..d04d3ec 100644
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
