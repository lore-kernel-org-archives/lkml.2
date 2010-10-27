Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0J0Fn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 01:43:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32793 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0J0FnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MzV5lyvSWn4yrzku9YGeVYHBxRLdm3KrrWhUs+9vQ4hDgWCCEs621wYPodry4yxuNW
         z6OcdmKvUVB7B/jiHskU12f1lk19BNaDXPz+hhACfcAblVPu3PW7m01/7JOPsjwFcuFX
         7aIviLgSn1tsHGJB5OWzhqRjJ6MTTdy0YrxPU=
From: Brian Gerst <brgerst@gmail.com>
To: tj@kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
Date: Wed, 27 Oct 2010 01:43:02 -0400
Message-Id: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu allocator cannot handle alignments larger than one page.
Allocate the irq stacks seperately, and only keep the pointers as
percpu data.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
-- 
1.7.2.3

