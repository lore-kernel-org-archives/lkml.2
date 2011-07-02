Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1GBDpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:45:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1GBDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:14 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=0v-RXm3SltAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=D3TM_m44CH1BIor11bsA:9 a=eVxo_4xb-hn3rlX02WUA:7 a=jEp0ucaQiEUA:10 a=WeOa-AV5lc8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033853.220897627@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0003-blackfin-irqs-Do-not-trace-arch_local_-irq_-function.patch
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

Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/blackfin/include/asm/irqflags.h |   42 +++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/blackfin/include/asm/irqflags.h b/arch/blackfin/include/asm/irqflags.h
index b4bbb75..43eb474 100644
--- a/arch/blackfin/include/asm/irqflags.h
+++ b/arch/blackfin/include/asm/irqflags.h
@@ -18,12 +18,12 @@
 extern unsigned long bfin_irq_flags;
 #endif
 
-static inline void bfin_sti(unsigned long flags)
+static inline notrace void bfin_sti(unsigned long flags)
 {
 	asm volatile("sti %0;" : : "d" (flags));
 }
 
-static inline unsigned long bfin_cli(void)
+static inline notrace unsigned long bfin_cli(void)
 {
 	unsigned long flags;
 	asm volatile("cli %0;" : "=d" (flags));
@@ -40,22 +40,22 @@ static inline unsigned long bfin_cli(void)
 /*
  * Hard, untraced CPU interrupt flag manipulation and access.
  */
-static inline void __hard_local_irq_disable(void)
+static inline notrace void __hard_local_irq_disable(void)
 {
 	bfin_cli();
 }
 
-static inline void __hard_local_irq_enable(void)
+static inline notrace void __hard_local_irq_enable(void)
 {
 	bfin_sti(bfin_irq_flags);
 }
 
-static inline unsigned long hard_local_save_flags(void)
+static inline notrace unsigned long hard_local_save_flags(void)
 {
 	return bfin_read_IMASK();
 }
 
-static inline unsigned long __hard_local_irq_save(void)
+static inline notrace unsigned long __hard_local_irq_save(void)
 {
 	unsigned long flags;
 	flags = bfin_cli();
@@ -65,18 +65,18 @@ static inline unsigned long __hard_local_irq_save(void)
 	return flags;
 }
 
-static inline int hard_irqs_disabled_flags(unsigned long flags)
+static inline notrace int hard_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags & ~0x3f) == 0;
 }
 
-static inline int hard_irqs_disabled(void)
+static inline notrace int hard_irqs_disabled(void)
 {
 	unsigned long flags = hard_local_save_flags();
 	return hard_irqs_disabled_flags(flags);
 }
 
-static inline void __hard_local_irq_restore(unsigned long flags)
+static inline notrace void __hard_local_irq_restore(unsigned long flags)
 {
 	if (!hard_irqs_disabled_flags(flags))
 		__hard_local_irq_enable();
@@ -113,31 +113,31 @@ void ipipe_check_context(struct ipipe_domain *ipd);
 /*
  * Interrupt pipe interface to linux/irqflags.h.
  */
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	__check_irqop_context();
 	__ipipe_stall_root();
 	barrier();
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	barrier();
 	__check_irqop_context();
 	__ipipe_unstall_root();
 }
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return __ipipe_test_root() ? bfin_no_irqs : bfin_irq_flags;
 }
 
-static inline int arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return flags == bfin_no_irqs;
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 
@@ -148,13 +148,13 @@ static inline unsigned long arch_local_irq_save(void)
 	return flags;
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	__check_irqop_context();
 	__ipipe_restore_root(flags == bfin_no_irqs);
 }
 
-static inline unsigned long arch_mangle_irq_bits(int virt, unsigned long real)
+static inline notrace unsigned long arch_mangle_irq_bits(int virt, unsigned long real)
 {
 	/*
 	 * Merge virtual and real interrupt mask bits into a single
@@ -163,7 +163,7 @@ static inline unsigned long arch_mangle_irq_bits(int virt, unsigned long real)
 	return (real & ~(1 << 31)) | ((virt != 0) << 31);
 }
 
-static inline int arch_demangle_irq_bits(unsigned long *x)
+static inline notrace int arch_demangle_irq_bits(unsigned long *x)
 {
 	int virt = (*x & (1 << 31)) != 0;
 	*x &= ~(1L << 31);
@@ -174,7 +174,7 @@ static inline int arch_demangle_irq_bits(unsigned long *x)
  * Interface to various arch routines that may be traced.
  */
 #ifdef CONFIG_IPIPE_TRACE_IRQSOFF
-static inline void hard_local_irq_disable(void)
+static inline notrace void hard_local_irq_disable(void)
 {
 	if (!hard_irqs_disabled()) {
 		__hard_local_irq_disable();
@@ -182,7 +182,7 @@ static inline void hard_local_irq_disable(void)
 	}
 }
 
-static inline void hard_local_irq_enable(void)
+static inline notrace void hard_local_irq_enable(void)
 {
 	if (hard_irqs_disabled()) {
 		ipipe_trace_end(0x80000000);
@@ -190,7 +190,7 @@ static inline void hard_local_irq_enable(void)
 	}
 }
 
-static inline unsigned long hard_local_irq_save(void)
+static inline notrace unsigned long hard_local_irq_save(void)
 {
 	unsigned long flags = hard_local_save_flags();
 	if (!hard_irqs_disabled_flags(flags)) {
@@ -200,7 +200,7 @@ static inline unsigned long hard_local_irq_save(void)
 	return flags;
 }
 
-static inline void hard_local_irq_restore(unsigned long flags)
+static inline notrace void hard_local_irq_restore(unsigned long flags)
 {
 	if (!hard_irqs_disabled_flags(flags)) {
 		ipipe_trace_end(0x80000001);
-- 
1.7.5.4



