Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1GBDpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:45:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1GBDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:14 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=8-3sLaEvg9kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=BO0oPePQCYhv1qKUmNQA:9 a=f98AecmjYoY4_eobeNYA:7 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033853.413522135@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 04/11] ia64/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0004-ia64-irqs-Do-not-trace-arch_local_-irq_-functions.patch
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

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/ia64/include/asm/irqflags.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/irqflags.h b/arch/ia64/include/asm/irqflags.h
index f82d6be..82d4c5e 100644
--- a/arch/ia64/include/asm/irqflags.h
+++ b/arch/ia64/include/asm/irqflags.h
@@ -12,7 +12,7 @@
 
 #ifdef CONFIG_IA64_DEBUG_IRQ
 extern unsigned long last_cli_ip;
-static inline void arch_maybe_save_ip(unsigned long flags)
+static inline notrace void arch_maybe_save_ip(unsigned long flags)
 {
 	if (flags & IA64_PSR_I)
 		last_cli_ip = ia64_getreg(_IA64_REG_IP);
@@ -29,7 +29,7 @@ static inline void arch_maybe_save_ip(unsigned long flags)
  *   and that writes to PSR.mfl
  */
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	ia64_stop();
 #ifdef CONFIG_PARAVIRT
@@ -39,7 +39,7 @@ static inline unsigned long arch_local_save_flags(void)
 #endif
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags = arch_local_save_flags();
 
@@ -49,7 +49,7 @@ static inline unsigned long arch_local_irq_save(void)
 	return flags;
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 #ifdef CONFIG_IA64_DEBUG_IRQ
 	arch_local_irq_save();
@@ -59,14 +59,14 @@ static inline void arch_local_irq_disable(void)
 #endif
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	ia64_stop();
 	ia64_ssm(IA64_PSR_I);
 	ia64_srlz_d();
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 #ifdef CONFIG_IA64_DEBUG_IRQ
 	unsigned long old_psr = arch_local_save_flags();
@@ -75,17 +75,17 @@ static inline void arch_local_irq_restore(unsigned long flags)
 	arch_maybe_save_ip(old_psr & ~flags);
 }
 
-static inline bool arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags & IA64_PSR_I) == 0;
 }
 
-static inline bool arch_irqs_disabled(void)
+static inline notrace bool arch_irqs_disabled(void)
 {
 	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
 
-static inline void arch_safe_halt(void)
+static inline notrace void arch_safe_halt(void)
 {
 	ia64_pal_halt_light();	/* PAL_HALT_LIGHT */
 }
-- 
1.7.5.4



