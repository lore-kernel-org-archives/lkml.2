Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1GBDpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:45:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1GBDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:14 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=gG8QmBUMxvIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=drOt6m5kAAAA:8 a=meVymXHHAAAA:8 a=n7IPbe0CB1ChNjnITFQA:9 a=gST8z1J5T5QfHykleBEA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033853.026763006@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 02/11] arm/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0002-arm-irqs-Do-not-trace-arch_local_-irq_-functions.patch
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

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/irqflags.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
index 1e6cca5..b633507 100644
--- a/arch/arm/include/asm/irqflags.h
+++ b/arch/arm/include/asm/irqflags.h
@@ -10,7 +10,7 @@
  */
 #if __LINUX_ARM_ARCH__ >= 6
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 
@@ -21,7 +21,7 @@ static inline unsigned long arch_local_irq_save(void)
 	return flags;
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	asm volatile(
 		"	cpsie i			@ arch_local_irq_enable"
@@ -30,7 +30,7 @@ static inline void arch_local_irq_enable(void)
 		: "memory", "cc");
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	asm volatile(
 		"	cpsid i			@ arch_local_irq_disable"
@@ -46,7 +46,7 @@ static inline void arch_local_irq_disable(void)
 /*
  * Save the current interrupt enable state & disable IRQs
  */
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags, temp;
 
@@ -63,7 +63,7 @@ static inline unsigned long arch_local_irq_save(void)
 /*
  * Enable IRQs
  */
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	unsigned long temp;
 	asm volatile(
@@ -78,7 +78,7 @@ static inline void arch_local_irq_enable(void)
 /*
  * Disable IRQs
  */
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	unsigned long temp;
 	asm volatile(
@@ -125,7 +125,7 @@ static inline void arch_local_irq_disable(void)
 /*
  * Save the current interrupt enable state.
  */
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 	asm volatile(
@@ -137,7 +137,7 @@ static inline unsigned long arch_local_save_flags(void)
 /*
  * restore saved IRQ & FIQ state
  */
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	asm volatile(
 		"	msr	cpsr_c, %0	@ local_irq_restore"
@@ -146,7 +146,7 @@ static inline void arch_local_irq_restore(unsigned long flags)
 		: "memory", "cc");
 }
 
-static inline int arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return flags & PSR_I_BIT;
 }
-- 
1.7.5.4



