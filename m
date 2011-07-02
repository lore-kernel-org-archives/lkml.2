Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1GBDpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:45:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1GBDpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:17 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=dpCq_AEPIjYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=TV9YyGL_0vA3ULo3MdYA:9 a=oABvcaMsyEDykOoBaDcA:7 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033854.600969289@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/11] sparc/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0011-sparc-irqs-Do-not-trace-arch_local_-irq_-functions.patch
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

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/sparc/include/asm/irqflags_32.h |    8 ++++----
 arch/sparc/include/asm/irqflags_64.h |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/irqflags_32.h b/arch/sparc/include/asm/irqflags_32.h
index d4d0711..1484890 100644
--- a/arch/sparc/include/asm/irqflags_32.h
+++ b/arch/sparc/include/asm/irqflags_32.h
@@ -18,7 +18,7 @@ extern void arch_local_irq_restore(unsigned long);
 extern unsigned long arch_local_irq_save(void);
 extern void arch_local_irq_enable(void);
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 
@@ -26,17 +26,17 @@ static inline unsigned long arch_local_save_flags(void)
 	return flags;
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	arch_local_irq_save();
 }
 
-static inline bool arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags & PSR_PIL) != 0;
 }
 
-static inline bool arch_irqs_disabled(void)
+static inline notrace bool arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
diff --git a/arch/sparc/include/asm/irqflags_64.h b/arch/sparc/include/asm/irqflags_64.h
index aab969c..23cd27f 100644
--- a/arch/sparc/include/asm/irqflags_64.h
+++ b/arch/sparc/include/asm/irqflags_64.h
@@ -14,7 +14,7 @@
 
 #ifndef __ASSEMBLY__
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 
@@ -26,7 +26,7 @@ static inline unsigned long arch_local_save_flags(void)
 	return flags;
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	__asm__ __volatile__(
 		"wrpr	%0, %%pil"
@@ -36,7 +36,7 @@ static inline void arch_local_irq_restore(unsigned long flags)
 	);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	__asm__ __volatile__(
 		"wrpr	%0, %%pil"
@@ -46,7 +46,7 @@ static inline void arch_local_irq_disable(void)
 	);
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	__asm__ __volatile__(
 		"wrpr	0, %%pil"
@@ -56,17 +56,17 @@ static inline void arch_local_irq_enable(void)
 	);
 }
 
-static inline int arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags > 0);
 }
 
-static inline int arch_irqs_disabled(void)
+static inline notrace int arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags, tmp;
 
-- 
1.7.5.4



