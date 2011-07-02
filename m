Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1GBDqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:46:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1GBDpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:15 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=mTZrY9ukQicA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=jin6Ke8JD2JwPFUa8yMA:9 a=z7_iCoDVIs1BZQtyL3UA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033854.283591061@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 09/11] s390/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0009-s390-irqs-Do-not-trace-arch_local_-irq_-functions.patch
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

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/s390/include/asm/irqflags.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/irqflags.h b/arch/s390/include/asm/irqflags.h
index 865d6d8..38fdf45 100644
--- a/arch/s390/include/asm/irqflags.h
+++ b/arch/s390/include/asm/irqflags.h
@@ -29,42 +29,42 @@
 })
 
 /* set system mask. */
-static inline void __arch_local_irq_ssm(unsigned long flags)
+static inline notrace void __arch_local_irq_ssm(unsigned long flags)
 {
 	asm volatile("ssm   %0" : : "Q" (flags) : "memory");
 }
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return __arch_local_irq_stosm(0x00);
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	return __arch_local_irq_stnsm(0xfc);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	arch_local_irq_save();
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	__arch_local_irq_stosm(0x03);
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	__arch_local_irq_ssm(flags);
 }
 
-static inline bool arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return !(flags & (3UL << (BITS_PER_LONG - 8)));
 }
 
-static inline bool arch_irqs_disabled(void)
+static inline notrace bool arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
-- 
1.7.5.4



