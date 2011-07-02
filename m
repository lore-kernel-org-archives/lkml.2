Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1GBDqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:46:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1GBDpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:17 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=8-cXX0r5AW8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1cMp6Op0AAAA:8 a=meVymXHHAAAA:8 a=xyLcrhHpmspGRm4AOFsA:9 a=yrWxzGkG-0G2-D9jg-oA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=PBs7KpRtM0kA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033854.432833160@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 10/11] sh/unicore32/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0010-sh-unicore32-irqs-Do-not-trace-arch_local_-irq_-func.patch
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

This patch only updates include/asm-generic/irqflags.h, but the only archs
to use it is superH and unicore32.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/irqflags.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/irqflags.h b/include/asm-generic/irqflags.h
index 1f40d002..092b27e 100644
--- a/include/asm-generic/irqflags.h
+++ b/include/asm-generic/irqflags.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_GENERIC_IRQFLAGS_H
 #define __ASM_GENERIC_IRQFLAGS_H
 
+#include <linux/types.h>
+
 /*
  * All architectures should implement at least the first two functions,
  * usually inline assembly will be the best way.
@@ -22,7 +24,7 @@ void arch_local_irq_restore(unsigned long flags);
 
 /* get status and disable interrupts */
 #ifndef arch_local_irq_save
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 	flags = arch_local_save_flags();
@@ -33,7 +35,7 @@ static inline unsigned long arch_local_irq_save(void)
 
 /* test flags */
 #ifndef arch_irqs_disabled_flags
-static inline int arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return flags == ARCH_IRQ_DISABLED;
 }
@@ -41,7 +43,7 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
 
 /* unconditionally enable interrupts */
 #ifndef arch_local_irq_enable
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	arch_local_irq_restore(ARCH_IRQ_ENABLED);
 }
@@ -49,7 +51,7 @@ static inline void arch_local_irq_enable(void)
 
 /* unconditionally disable interrupts */
 #ifndef arch_local_irq_disable
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	arch_local_irq_restore(ARCH_IRQ_DISABLED);
 }
@@ -57,7 +59,7 @@ static inline void arch_local_irq_disable(void)
 
 /* test hardware interrupt enable bit */
 #ifndef arch_irqs_disabled
-static inline int arch_irqs_disabled(void)
+static inline notrace int arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
-- 
1.7.5.4



