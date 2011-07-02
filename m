Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1GBDqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:46:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1GBDpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:17 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=jQmxvIjEYlkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=_A5TAQVKAAAA:8 a=meVymXHHAAAA:8 a=jin6Ke8JD2JwPFUa8yMA:9 a=xQeboU23HHRbyiVLc3MA:7 a=jEp0ucaQiEUA:10 a=_RhRFcbxBZMA:10 a=t__e_55n4pAA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033853.984879201@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [patch 07/11] parisc/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0007-parisc-irqs-Do-not-trace-arch_local_-irq_-functions.patch
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

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/include/asm/irqflags.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/parisc/include/asm/irqflags.h b/arch/parisc/include/asm/irqflags.h
index 34f9cb9..98d706b 100644
--- a/arch/parisc/include/asm/irqflags.h
+++ b/arch/parisc/include/asm/irqflags.h
@@ -4,41 +4,41 @@
 #include <linux/types.h>
 #include <asm/psw.h>
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 	asm volatile("ssm 0, %0" : "=r" (flags) : : "memory");
 	return flags;
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	asm volatile("rsm %0,%%r0\n" : : "i" (PSW_I) : "memory");
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	asm volatile("ssm %0,%%r0\n" : : "i" (PSW_I) : "memory");
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 	asm volatile("rsm %1,%0" : "=r" (flags) : "i" (PSW_I) : "memory");
 	return flags;
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	asm volatile("mtsm %0" : : "r" (flags) : "memory");
 }
 
-static inline bool arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags & PSW_I) == 0;
 }
 
-static inline bool arch_irqs_disabled(void)
+static inline notrace bool arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
-- 
1.7.5.4



