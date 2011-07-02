Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1GBDrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:47:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab1GBDpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:15 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=cewjnK8wRl0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BO0oPePQCYhv1qKUmNQA:9 a=PBUQwBmcYzLUeTQPi80A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033853.617637031@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Simek <monstr@monstr.eu>
Subject: [patch 05/11] microblaze/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0005-microblaze-irqs-Do-not-trace-arch_local_-irq_-functi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
Although they are marked inline, gcc may still make a function out of
them and add it to the pool of functions that are traced by the function
tracer. This can cause undesirable results (kernel panic, triple faults,
etc).

Add the notrace notation to prevent them from ever being traced.

Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/microblaze/include/asm/irqflags.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/microblaze/include/asm/irqflags.h b/arch/microblaze/include/asm/irqflags.h
index c4532f0..c9a6262 100644
--- a/arch/microblaze/include/asm/irqflags.h
+++ b/arch/microblaze/include/asm/irqflags.h
@@ -14,7 +14,7 @@
 
 #if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 	asm volatile("	msrclr %0, %1	\n"
@@ -25,7 +25,7 @@ static inline unsigned long arch_local_irq_save(void)
 	return flags;
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	/* this uses r0 without declaring it - is that correct? */
 	asm volatile("	msrclr r0, %0	\n"
@@ -35,7 +35,7 @@ static inline void arch_local_irq_disable(void)
 		     : "memory");
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	/* this uses r0 without declaring it - is that correct? */
 	asm volatile("	msrset	r0, %0	\n"
@@ -47,7 +47,7 @@ static inline void arch_local_irq_enable(void)
 
 #else /* !CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR */
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags, tmp;
 	asm volatile ("	mfs	%0, rmsr	\n"
@@ -61,7 +61,7 @@ static inline unsigned long arch_local_irq_save(void)
 	return flags;
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	unsigned long tmp;
 	asm volatile("	mfs	%0, rmsr	\n"
@@ -74,7 +74,7 @@ static inline void arch_local_irq_disable(void)
 		     : "memory");
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	unsigned long tmp;
 	asm volatile("	mfs	%0, rmsr	\n"
@@ -89,7 +89,7 @@ static inline void arch_local_irq_enable(void)
 
 #endif /* CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR */
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 	asm volatile("	mfs	%0, rmsr	\n"
@@ -100,7 +100,7 @@ static inline unsigned long arch_local_save_flags(void)
 	return flags;
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	asm volatile("	mts	rmsr, %0	\n"
 		     "	nop			\n"
@@ -109,12 +109,12 @@ static inline void arch_local_irq_restore(unsigned long flags)
 		     : "memory");
 }
 
-static inline bool arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags & MSR_IE) == 0;
 }
 
-static inline bool arch_irqs_disabled(void)
+static inline notrace bool arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
-- 
1.7.5.4



