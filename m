Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100Ab0J0QFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:05:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab0J0QFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:05:15 -0400
Date: Wed, 27 Oct 2010 16:03:54 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
References: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Allocate irq stacks seperate from percpu area
Message-ID: <tip-22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1@git.kernel.org>
Git-Commit-ID: 22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 16:03:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1
Gitweb:     http://git.kernel.org/tip/22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 27 Oct 2010 01:43:02 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Oct 2010 17:31:42 +0200

x86-32: Allocate irq stacks seperate from percpu area

The percpu allocator cannot handle alignments larger than one
page. Allocate the irq stacks seperately, and only keep the
pointers as percpu data.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tj@kernel.org
LKML-Reference: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq.h |    2 --
 arch/x86/kernel/irq_32.c   |   12 ++----------
 arch/x86/kernel/smpboot.c  |    1 -
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 0bf5b00..13b0eba 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -21,10 +21,8 @@ static inline int irq_canonicalize(int irq)
 
 #ifdef CONFIG_X86_32
 extern void irq_ctx_init(int cpu);
-extern void irq_ctx_exit(int cpu);
 #else
 # define irq_ctx_init(cpu) do { } while (0)
-# define irq_ctx_exit(cpu) do { } while (0)
 #endif
 
 #define __ARCH_HAS_DO_SOFTIRQ
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 50fbbe6..64668db 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -60,9 +60,6 @@ union irq_ctx {
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 
-static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, hardirq_stack, THREAD_SIZE);
-static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, softirq_stack, THREAD_SIZE);
-
 static void call_on_stack(void *func, void *stack)
 {
 	asm volatile("xchgl	%%ebx,%%esp	\n"
@@ -128,7 +125,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	if (per_cpu(hardirq_ctx, cpu))
 		return;
 
-	irqctx = &per_cpu(hardirq_stack, cpu);
+	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -137,7 +134,7 @@ void __cpuinit irq_ctx_init(int cpu)
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = &per_cpu(softirq_stack, cpu);
+	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -150,11 +147,6 @@ void __cpuinit irq_ctx_init(int cpu)
 	       cpu, per_cpu(hardirq_ctx, cpu),  per_cpu(softirq_ctx, cpu));
 }
 
-void irq_ctx_exit(int cpu)
-{
-	per_cpu(hardirq_ctx, cpu) = NULL;
-}
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6af1185..90baf56 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1373,7 +1373,6 @@ void play_dead_common(void)
 {
 	idle_task_exit();
 	reset_lazy_tlbstate();
-	irq_ctx_exit(raw_smp_processor_id());
 	c1e_remove_cpu(raw_smp_processor_id());
 
 	mb();
