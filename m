Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0JNWbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:31:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0JNWbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:31:35 -0400
Date: Thu, 14 Oct 2010 18:31:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        kyle@mcmartin.ca
Subject: [PATCH 3/3] alpha: kill off alpha_do_IRQ
Message-ID: <20101014223134.GD8332@bombadil.infradead.org>
References: <20101014222805.GA8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014222805.GA8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good riddance... Nuke a pile of redundant handlers that the
generic code takes care of as well.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/alpha/include/asm/irq.h      |    3 --
 arch/alpha/kernel/irq.c           |    6 +----
 arch/alpha/kernel/irq_alpha.c     |   16 +----------
 arch/alpha/kernel/irq_i8259.c     |   26 +++-----------------
 arch/alpha/kernel/irq_pyxis.c     |   26 +++-----------------
 arch/alpha/kernel/irq_srm.c       |   25 +++----------------
 arch/alpha/kernel/sys_alcor.c     |   25 +++----------------
 arch/alpha/kernel/sys_cabriolet.c |   25 +++----------------
 arch/alpha/kernel/sys_dp264.c     |   48 +++++-------------------------------
 arch/alpha/kernel/sys_eb64p.c     |   25 +++----------------
 arch/alpha/kernel/sys_eiger.c     |   25 +++----------------
 arch/alpha/kernel/sys_jensen.c    |   47 +++++++-----------------------------
 arch/alpha/kernel/sys_marvel.c    |   44 +++++++--------------------------
 arch/alpha/kernel/sys_mikasa.c    |   25 +++----------------
 arch/alpha/kernel/sys_noritake.c  |   25 +++----------------
 arch/alpha/kernel/sys_rawhide.c   |   25 +++----------------
 arch/alpha/kernel/sys_rx164.c     |   25 +++----------------
 arch/alpha/kernel/sys_sable.c     |   25 +++----------------
 arch/alpha/kernel/sys_takara.c    |   25 +++----------------
 arch/alpha/kernel/sys_titan.c     |   29 ++++-----------------
 arch/alpha/kernel/sys_wildfire.c  |   34 +++++--------------------
 21 files changed, 94 insertions(+), 460 deletions(-)

diff --git a/arch/alpha/include/asm/irq.h b/arch/alpha/include/asm/irq.h
index 4126441..0637740 100644
--- a/arch/alpha/include/asm/irq.h
+++ b/arch/alpha/include/asm/irq.h
@@ -88,7 +88,4 @@ static __inline__ int irq_canonicalize(int irq)
 struct pt_regs;
 extern void (*perf_irq)(unsigned long, struct pt_regs *);
 
-struct irq_desc;
-extern void alpha_do_IRQ(unsigned int irq, struct irq_desc *desc);
-
 #endif /* _ALPHA_IRQ_H */
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index cea8913..5912900 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -162,7 +162,7 @@ handle_irq(int irq)
 
 	irq_enter();
 	/*
-	 * __do_IRQ() must be called with IPL_MAX. Note that we do not
+	 * handle_irq() must be called with IPL_MAX. Note that we do not
 	 * explicitly enable interrupts afterwards - some MILO PALcode
 	 * (namely LX164 one) seems to have severe problems with RTI
 	 * at IPL 0.
@@ -172,7 +172,3 @@ handle_irq(int irq)
 	irq_exit();
 }
 
-void alpha_do_IRQ(unsigned int irq, struct irq_desc *desc)
-{
-	__do_IRQ(irq);
-}
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 001db4f..5ceffcb 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -221,25 +221,12 @@ process_mcheck_info(unsigned long vector, unsigned long la_ptr,
  * processed by PALcode, and comes in via entInt vector 1.
  */
 
-static void rtc_enable_disable(unsigned int irq) { }
-static unsigned int rtc_startup(unsigned int irq) { return 0; }
-
 struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED,
 	.name		= "timer",
 };
 
-static struct irq_chip rtc_irq_type = {
-	.name		= "RTC",
-	.startup	= rtc_startup,
-	.shutdown	= rtc_enable_disable,
-	.enable		= rtc_enable_disable,
-	.disable	= rtc_enable_disable,
-	.ack		= rtc_enable_disable,
-	.end		= rtc_enable_disable,
-};
-
 void __init
 init_rtc_irq(void)
 {
@@ -247,7 +234,8 @@ init_rtc_irq(void)
 
 	if (desc) {
 		desc->status |= IRQ_DISABLED;
-		set_irq_chip(RTC_IRQ, &rtc_irq_type);
+		set_irq_chip_and_handler_name(RTC_IRQ, &no_irq_chip,
+			handle_simple_irq, "RTC");
 		setup_irq(RTC_IRQ, &timer_irqaction);
 	}
 }
diff --git a/arch/alpha/kernel/irq_i8259.c b/arch/alpha/kernel/irq_i8259.c
index 9e49395..956ea0e 100644
--- a/arch/alpha/kernel/irq_i8259.c
+++ b/arch/alpha/kernel/irq_i8259.c
@@ -69,29 +69,11 @@ i8259a_mask_and_ack_irq(unsigned int irq)
 	spin_unlock(&i8259_irq_lock);
 }
 
-unsigned int
-i8259a_startup_irq(unsigned int irq)
-{
-	i8259a_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-void
-i8259a_end_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	if (desc || !(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		i8259a_enable_irq(irq);
-}
-
 struct irq_chip i8259a_irq_type = {
 	.name		= "XT-PIC",
-	.startup	= i8259a_startup_irq,
-	.shutdown	= i8259a_disable_irq,
-	.enable		= i8259a_enable_irq,
-	.disable	= i8259a_disable_irq,
-	.ack		= i8259a_mask_and_ack_irq,
-	.end		= i8259a_end_irq,
+	.unmask		= i8259a_enable_irq,
+	.mask		= i8259a_disable_irq,
+	.mask_ack	= i8259a_mask_and_ack_irq,
 };
 
 void __init
@@ -108,7 +90,7 @@ init_i8259a_irqs(void)
 	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
 
 	for (i = 0; i < 16; i++) {
-		set_irq_chip_and_handler(i, &i8259a_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &i8259a_irq_type, handle_level_irq);
 	}
 
 	setup_irq(2, &cascade);
diff --git a/arch/alpha/kernel/irq_pyxis.c b/arch/alpha/kernel/irq_pyxis.c
index 9f603cf..2863458 100644
--- a/arch/alpha/kernel/irq_pyxis.c
+++ b/arch/alpha/kernel/irq_pyxis.c
@@ -40,21 +40,6 @@ pyxis_disable_irq(unsigned int irq)
 	pyxis_update_irq_hw(cached_irq_mask &= ~(1UL << (irq - 16)));
 }
 
-static unsigned int
-pyxis_startup_irq(unsigned int irq)
-{
-	pyxis_enable_irq(irq);
-	return 0;
-}
-
-static void
-pyxis_end_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	if (desc || !(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		pyxis_enable_irq(irq);
-}
-
 static void
 pyxis_mask_and_ack_irq(unsigned int irq)
 {
@@ -73,12 +58,9 @@ pyxis_mask_and_ack_irq(unsigned int irq)
 
 static struct irq_chip pyxis_irq_type = {
 	.name		= "PYXIS",
-	.startup	= pyxis_startup_irq,
-	.shutdown	= pyxis_disable_irq,
-	.enable		= pyxis_enable_irq,
-	.disable	= pyxis_disable_irq,
-	.ack		= pyxis_mask_and_ack_irq,
-	.end		= pyxis_end_irq,
+	.mask_ack	= pyxis_mask_and_ack_irq,
+	.mask		= pyxis_disable_irq,
+	.unmask		= pyxis_enable_irq,
 };
 
 void 
@@ -120,7 +102,7 @@ init_pyxis_irqs(unsigned long ignore_mask)
 	for (i = 16; i < 48; ++i) {
 		if ((ignore_mask >> i) & 1)
 			continue;
-		set_irq_chip_and_handler(i, &pyxis_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &pyxis_irq_type, handle_level_irq);
 		irq_to_desc(i)->status |= IRQ_LEVEL;
 	}
 
diff --git a/arch/alpha/kernel/irq_srm.c b/arch/alpha/kernel/irq_srm.c
index ea79006..0e57e82 100644
--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -33,29 +33,12 @@ srm_disable_irq(unsigned int irq)
 	spin_unlock(&srm_irq_lock);
 }
 
-static unsigned int
-srm_startup_irq(unsigned int irq)
-{
-	srm_enable_irq(irq);
-	return 0;
-}
-
-static void
-srm_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		srm_enable_irq(irq);
-}
-
 /* Handle interrupts from the SRM, assuming no additional weirdness.  */
 static struct irq_chip srm_irq_type = {
 	.name		= "SRM",
-	.startup	= srm_startup_irq,
-	.shutdown	= srm_disable_irq,
-	.enable		= srm_enable_irq,
-	.disable	= srm_disable_irq,
-	.ack		= srm_disable_irq,
-	.end		= srm_end_irq,
+	.unmask		= srm_enable_irq,
+	.mask		= srm_disable_irq,
+	.mask_ack	= srm_disable_irq,
 };
 
 void __init
@@ -68,7 +51,7 @@ init_srm_irqs(long max, unsigned long ignore_mask)
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
-		set_irq_chip_and_handler(i, &srm_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &srm_irq_type, handle_level_irq);
 		irq_to_desc(i)->status |= IRQ_LEVEL;
 	}
 }
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index 138cc15..7bef617 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -65,13 +65,6 @@ alcor_mask_and_ack_irq(unsigned int irq)
 	*(vuip)GRU_INT_CLEAR = 0; mb();
 }
 
-static unsigned int
-alcor_startup_irq(unsigned int irq)
-{
-	alcor_enable_irq(irq);
-	return 0;
-}
-
 static void
 alcor_isa_mask_and_ack_irq(unsigned int irq)
 {
@@ -82,21 +75,11 @@ alcor_isa_mask_and_ack_irq(unsigned int irq)
 	*(vuip)GRU_INT_CLEAR = 0; mb();
 }
 
-static void
-alcor_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		alcor_enable_irq(irq);
-}
-
 static struct irq_chip alcor_irq_type = {
 	.name		= "ALCOR",
-	.startup	= alcor_startup_irq,
-	.shutdown	= alcor_disable_irq,
-	.enable		= alcor_enable_irq,
-	.disable	= alcor_disable_irq,
-	.ack		= alcor_mask_and_ack_irq,
-	.end		= alcor_end_irq,
+	.unmask		= alcor_enable_irq,
+	.mask		= alcor_disable_irq,
+	.mask_ack	= alcor_mask_and_ack_irq,
 };
 
 static void
@@ -142,7 +125,7 @@ alcor_init_irq(void)
 		   on while IRQ probing.  */
 		if (i >= 16+20 && i <= 16+30)
 			continue;
-		set_irq_chip_and_handler(i, &alcor_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &alcor_irq_type, handle_level_irq);
 		irq_to_desc(i)->status |= IRQ_LEVEL;
 	}
 	i8259a_irq_type.ack = alcor_isa_mask_and_ack_irq;
diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
index 01a932b..b0c9164 100644
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -57,28 +57,11 @@ cabriolet_disable_irq(unsigned int irq)
 	cabriolet_update_irq_hw(irq, cached_irq_mask |= 1UL << irq);
 }
 
-static unsigned int
-cabriolet_startup_irq(unsigned int irq)
-{ 
-	cabriolet_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-cabriolet_end_irq(unsigned int irq)
-{ 
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		cabriolet_enable_irq(irq);
-}
-
 static struct irq_chip cabriolet_irq_type = {
 	.name		= "CABRIOLET",
-	.startup	= cabriolet_startup_irq,
-	.shutdown	= cabriolet_disable_irq,
-	.enable		= cabriolet_enable_irq,
-	.disable	= cabriolet_disable_irq,
-	.ack		= cabriolet_disable_irq,
-	.end		= cabriolet_end_irq,
+	.unmask		= cabriolet_enable_irq,
+	.mask		= cabriolet_disable_irq,
+	.mask_ack	= cabriolet_disable_irq,
 };
 
 static void 
@@ -123,7 +106,7 @@ common_init_irq(void (*srm_dev_int)(unsigned long v))
 
 		for (i = 16; i < 35; ++i) {
 			set_irq_chip_and_handler(i, &cabriolet_irq_type,
-				alpha_do_IRQ);
+				handle_level_irq);
 			irq_to_desc(i)->status |= IRQ_LEVEL;
 		}
 	}
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 34abb5c..edad5f7 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -115,20 +115,6 @@ dp264_disable_irq(unsigned int irq)
 	spin_unlock(&dp264_irq_lock);
 }
 
-static unsigned int
-dp264_startup_irq(unsigned int irq)
-{ 
-	dp264_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-dp264_end_irq(unsigned int irq)
-{ 
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		dp264_enable_irq(irq);
-}
-
 static void
 clipper_enable_irq(unsigned int irq)
 {
@@ -147,20 +133,6 @@ clipper_disable_irq(unsigned int irq)
 	spin_unlock(&dp264_irq_lock);
 }
 
-static unsigned int
-clipper_startup_irq(unsigned int irq)
-{ 
-	clipper_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-clipper_end_irq(unsigned int irq)
-{ 
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		clipper_enable_irq(irq);
-}
-
 static void
 cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 {
@@ -200,23 +172,17 @@ clipper_set_affinity(unsigned int irq, const struct cpumask *affinity)
 
 static struct irq_chip dp264_irq_type = {
 	.name		= "DP264",
-	.startup	= dp264_startup_irq,
-	.shutdown	= dp264_disable_irq,
-	.enable		= dp264_enable_irq,
-	.disable	= dp264_disable_irq,
-	.ack		= dp264_disable_irq,
-	.end		= dp264_end_irq,
+	.unmask		= dp264_enable_irq,
+	.mask		= dp264_disable_irq,
+	.mask_ack	= dp264_disable_irq,
 	.set_affinity	= dp264_set_affinity,
 };
 
 static struct irq_chip clipper_irq_type = {
 	.name		= "CLIPPER",
-	.startup	= clipper_startup_irq,
-	.shutdown	= clipper_disable_irq,
-	.enable		= clipper_enable_irq,
-	.disable	= clipper_disable_irq,
-	.ack		= clipper_disable_irq,
-	.end		= clipper_end_irq,
+	.unmask		= clipper_enable_irq,
+	.mask		= clipper_disable_irq,
+	.mask_ack	= clipper_disable_irq,
 	.set_affinity	= clipper_set_affinity,
 };
 
@@ -303,7 +269,7 @@ init_tsunami_irqs(struct irq_chip * ops, int imin, int imax)
 	long i;
 	for (i = imin; i <= imax; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, ops, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, ops, handle_level_irq);
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
index f7a957a..ae5f29d 100644
--- a/arch/alpha/kernel/sys_eb64p.c
+++ b/arch/alpha/kernel/sys_eb64p.c
@@ -55,28 +55,11 @@ eb64p_disable_irq(unsigned int irq)
 	eb64p_update_irq_hw(irq, cached_irq_mask |= 1 << irq);
 }
 
-static unsigned int
-eb64p_startup_irq(unsigned int irq)
-{
-	eb64p_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-eb64p_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		eb64p_enable_irq(irq);
-}
-
 static struct irq_chip eb64p_irq_type = {
 	.name		= "EB64P",
-	.startup	= eb64p_startup_irq,
-	.shutdown	= eb64p_disable_irq,
-	.enable		= eb64p_enable_irq,
-	.disable	= eb64p_disable_irq,
-	.ack		= eb64p_disable_irq,
-	.end		= eb64p_end_irq,
+	.unmask		= eb64p_enable_irq,
+	.mask		= eb64p_disable_irq,
+	.mask_ack	= eb64p_disable_irq,
 };
 
 static void 
@@ -136,7 +119,7 @@ eb64p_init_irq(void)
 
 	for (i = 16; i < 32; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &eb64p_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &eb64p_irq_type, handle_level_irq);
 	}		
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index 4f3596e..1121bc5 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -66,28 +66,11 @@ eiger_disable_irq(unsigned int irq)
 	eiger_update_irq_hw(irq, mask);
 }
 
-static unsigned int
-eiger_startup_irq(unsigned int irq)
-{
-	eiger_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-eiger_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		eiger_enable_irq(irq);
-}
-
 static struct irq_chip eiger_irq_type = {
 	.name		= "EIGER",
-	.startup	= eiger_startup_irq,
-	.shutdown	= eiger_disable_irq,
-	.enable		= eiger_enable_irq,
-	.disable	= eiger_disable_irq,
-	.ack		= eiger_disable_irq,
-	.end		= eiger_end_irq,
+	.unmask		= eiger_enable_irq,
+	.mask		= eiger_disable_irq,
+	.mask_ack	= eiger_disable_irq,
 };
 
 static void
@@ -154,7 +137,7 @@ eiger_init_irq(void)
 
 	for (i = 16; i < 128; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &eiger_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &eiger_irq_type, handle_level_irq);
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 460d82b..34f55e0 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -62,24 +62,6 @@
  * world.
  */
 
-static unsigned int
-jensen_local_startup(unsigned int irq)
-{
-	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_startup_irq(1);
-
-	return 0;
-}
-
-static void
-jensen_local_shutdown(unsigned int irq)
-{
-	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_disable_irq(1);
-}
-
 static void
 jensen_local_enable(unsigned int irq)
 {
@@ -97,29 +79,18 @@ jensen_local_disable(unsigned int irq)
 }
 
 static void
-jensen_local_ack(unsigned int irq)
+jensen_local_mask_ack(unsigned int irq)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
 	if (irq == 7)
 		i8259a_mask_and_ack_irq(1);
 }
 
-static void
-jensen_local_end(unsigned int irq)
-{
-	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_end_irq(1);
-}
-
 static struct irq_chip jensen_local_irq_type = {
 	.name		= "LOCAL",
-	.startup	= jensen_local_startup,
-	.shutdown	= jensen_local_shutdown,
-	.enable		= jensen_local_enable,
-	.disable	= jensen_local_disable,
-	.ack		= jensen_local_ack,
-	.end		= jensen_local_end,
+	.unmask		= jensen_local_enable,
+	.mask		= jensen_local_disable,
+	.mask_ack	= jensen_local_mask_ack,
 };
 
 static void 
@@ -200,11 +171,11 @@ jensen_init_irq(void)
 {
 	init_i8259a_irqs();
 
-	set_irq_chip_and_handler(1, &jensen_local_irq_type, alpha_do_IRQ);
-	set_irq_chip_and_handler(4, &jensen_local_irq_type, alpha_do_IRQ);
-	set_irq_chip_and_handler(3, &jensen_local_irq_type, alpha_do_IRQ);
-	set_irq_chip_and_handler(7, &jensen_local_irq_type, alpha_do_IRQ);
-	set_irq_chip_and_handler(9, &jensen_local_irq_type, alpha_do_IRQ);
+	set_irq_chip_and_handler(1, &jensen_local_irq_type, handle_level_irq);
+	set_irq_chip_and_handler(4, &jensen_local_irq_type, handle_level_irq);
+	set_irq_chip_and_handler(3, &jensen_local_irq_type, handle_level_irq);
+	set_irq_chip_and_handler(7, &jensen_local_irq_type, handle_level_irq);
+	set_irq_chip_and_handler(9, &jensen_local_irq_type, handle_level_irq);
 
 	common_init_isa_dma();
 }
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index a5095e0..2bfc9f1 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -143,20 +143,6 @@ io7_disable_irq(unsigned int irq)
 	spin_unlock(&io7->irq_lock);
 }
 
-static unsigned int
-io7_startup_irq(unsigned int irq)
-{
-	io7_enable_irq(irq);
-	return 0;	/* never anything pending */
-}
-
-static void
-io7_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		io7_enable_irq(irq);
-}
-
 static void
 marvel_irq_noop(unsigned int irq) 
 { 
@@ -171,32 +157,22 @@ marvel_irq_noop_return(unsigned int irq)
 
 static struct irq_chip marvel_legacy_irq_type = {
 	.name		= "LEGACY",
-	.startup	= marvel_irq_noop_return,
-	.shutdown	= marvel_irq_noop,
-	.enable		= marvel_irq_noop,
-	.disable	= marvel_irq_noop,
-	.ack		= marvel_irq_noop,
-	.end		= marvel_irq_noop,
+	.mask		= marvel_irq_noop,
+	.unmask		= marvel_irq_noop,
 };
 
 static struct irq_chip io7_lsi_irq_type = {
 	.name		= "LSI",
-	.startup	= io7_startup_irq,
-	.shutdown	= io7_disable_irq,
-	.enable		= io7_enable_irq,
-	.disable	= io7_disable_irq,
-	.ack		= io7_disable_irq,
-	.end		= io7_end_irq,
+	.unmask		= io7_enable_irq,
+	.mask		= io7_disable_irq,
+	.mask_ack	= io7_disable_irq,
 };
 
 static struct irq_chip io7_msi_irq_type = {
 	.name		= "MSI",
-	.startup	= io7_startup_irq,
-	.shutdown	= io7_disable_irq,
-	.enable		= io7_enable_irq,
-	.disable	= io7_disable_irq,
+	.unmask		= io7_enable_irq,
+	.mask		= io7_disable_irq,
 	.ack		= marvel_irq_noop,
-	.end		= io7_end_irq,
 };
 
 static void
@@ -305,7 +281,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
 		irq_to_desc(base + i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(base + i, lsi_ops, alpha_do_IRQ);
+		set_irq_chip_and_handler(base + i, lsi_ops, handle_level_irq);
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -319,7 +295,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
 		irq_to_desc(base + i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(base + i, msi_ops, alpha_do_IRQ);
+		set_irq_chip_and_handler(base + i, msi_ops, handle_level_irq);
 	}
 
 	for (i = 0; i < 16; ++i)
@@ -337,7 +313,7 @@ marvel_init_irq(void)
 	/* Reserve the legacy irqs.  */
 	for (i = 0; i < 16; ++i) {
 		set_irq_chip_and_handler(i, &marvel_legacy_irq_type,
-			alpha_do_IRQ);
+			handle_level_irq);
 	}
 
 	/* Init the io7 irqs.  */
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index 37e5c65..bcc1639e 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -54,28 +54,11 @@ mikasa_disable_irq(unsigned int irq)
 	mikasa_update_irq_hw(cached_irq_mask &= ~(1 << (irq - 16)));
 }
 
-static unsigned int
-mikasa_startup_irq(unsigned int irq)
-{
-	mikasa_enable_irq(irq);
-	return 0;
-}
-
-static void
-mikasa_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		mikasa_enable_irq(irq);
-}
-
 static struct irq_chip mikasa_irq_type = {
 	.name		= "MIKASA",
-	.startup	= mikasa_startup_irq,
-	.shutdown	= mikasa_disable_irq,
-	.enable		= mikasa_enable_irq,
-	.disable	= mikasa_disable_irq,
-	.ack		= mikasa_disable_irq,
-	.end		= mikasa_end_irq,
+	.unmask		= mikasa_enable_irq,
+	.mask		= mikasa_disable_irq,
+	.mask_ack	= mikasa_disable_irq,
 };
 
 static void 
@@ -116,7 +99,7 @@ mikasa_init_irq(void)
 
 	for (i = 16; i < 32; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &mikasa_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &mikasa_irq_type, handle_level_irq);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index 004f8ec..e88f4ae 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -59,28 +59,11 @@ noritake_disable_irq(unsigned int irq)
 	noritake_update_irq_hw(irq, cached_irq_mask &= ~(1 << (irq - 16)));
 }
 
-static unsigned int
-noritake_startup_irq(unsigned int irq)
-{
-	noritake_enable_irq(irq);
-	return 0;
-}
-
-static void
-noritake_end_irq(unsigned int irq)
-{
-        if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-                noritake_enable_irq(irq);
-}
-
 static struct irq_chip noritake_irq_type = {
 	.name		= "NORITAKE",
-	.startup	= noritake_startup_irq,
-	.shutdown	= noritake_disable_irq,
-	.enable		= noritake_enable_irq,
-	.disable	= noritake_disable_irq,
-	.ack		= noritake_disable_irq,
-	.end		= noritake_end_irq,
+	.unmask		= noritake_enable_irq,
+	.mask		= noritake_disable_irq,
+	.mask_ack	= noritake_disable_irq,
 };
 
 static void 
@@ -145,7 +128,7 @@ noritake_init_irq(void)
 
 	for (i = 16; i < 48; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &noritake_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &noritake_irq_type, handle_level_irq);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
index 60d152a..6a51364 100644
--- a/arch/alpha/kernel/sys_rawhide.c
+++ b/arch/alpha/kernel/sys_rawhide.c
@@ -121,28 +121,11 @@ rawhide_mask_and_ack_irq(unsigned int irq)
 	spin_unlock(&rawhide_irq_lock);
 }
 
-static unsigned int
-rawhide_startup_irq(unsigned int irq)
-{
-	rawhide_enable_irq(irq);
-	return 0;
-}
-
-static void
-rawhide_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		rawhide_enable_irq(irq);
-}
-
 static struct irq_chip rawhide_irq_type = {
 	.name		= "RAWHIDE",
-	.startup	= rawhide_startup_irq,
-	.shutdown	= rawhide_disable_irq,
-	.enable		= rawhide_enable_irq,
-	.disable	= rawhide_disable_irq,
-	.ack		= rawhide_mask_and_ack_irq,
-	.end		= rawhide_end_irq,
+	.unmask		= rawhide_enable_irq,
+	.mask		= rawhide_disable_irq,
+	.mask_ack	= rawhide_mask_and_ack_irq,
 };
 
 static void 
@@ -195,7 +178,7 @@ rawhide_init_irq(void)
 
 	for (i = 16; i < 128; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &rawhide_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &rawhide_irq_type, handle_level_irq);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
index 8a029a9..89e7e37e 100644
--- a/arch/alpha/kernel/sys_rx164.c
+++ b/arch/alpha/kernel/sys_rx164.c
@@ -58,28 +58,11 @@ rx164_disable_irq(unsigned int irq)
 	rx164_update_irq_hw(cached_irq_mask &= ~(1UL << (irq - 16)));
 }
 
-static unsigned int
-rx164_startup_irq(unsigned int irq)
-{
-	rx164_enable_irq(irq);
-	return 0;
-}
-
-static void
-rx164_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		rx164_enable_irq(irq);
-}
-
 static struct irq_chip rx164_irq_type = {
 	.name		= "RX164",
-	.startup	= rx164_startup_irq,
-	.shutdown	= rx164_disable_irq,
-	.enable		= rx164_enable_irq,
-	.disable	= rx164_disable_irq,
-	.ack		= rx164_disable_irq,
-	.end		= rx164_end_irq,
+	.unmask		= rx164_enable_irq,
+	.mask		= rx164_disable_irq,
+	.mask_ack	= rx164_disable_irq,
 };
 
 static void 
@@ -117,7 +100,7 @@ rx164_init_irq(void)
 	rx164_update_irq_hw(0);
 	for (i = 16; i < 40; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &rx164_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &rx164_irq_type, handle_level_irq);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index ed88315..5c4423d 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -474,20 +474,6 @@ sable_lynx_disable_irq(unsigned int irq)
 #endif
 }
 
-static unsigned int
-sable_lynx_startup_irq(unsigned int irq)
-{
-	sable_lynx_enable_irq(irq);
-	return 0;
-}
-
-static void
-sable_lynx_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		sable_lynx_enable_irq(irq);
-}
-
 static void
 sable_lynx_mask_and_ack_irq(unsigned int irq)
 {
@@ -503,12 +489,9 @@ sable_lynx_mask_and_ack_irq(unsigned int irq)
 
 static struct irq_chip sable_lynx_irq_type = {
 	.name		= "SABLE/LYNX",
-	.startup	= sable_lynx_startup_irq,
-	.shutdown	= sable_lynx_disable_irq,
-	.enable		= sable_lynx_enable_irq,
-	.disable	= sable_lynx_disable_irq,
-	.ack		= sable_lynx_mask_and_ack_irq,
-	.end		= sable_lynx_end_irq,
+	.unmask		= sable_lynx_enable_irq,
+	.mask		= sable_lynx_disable_irq,
+	.mask_ack	= sable_lynx_mask_and_ack_irq,
 };
 
 static void 
@@ -537,7 +520,7 @@ sable_lynx_init_irq(int nr_of_irqs)
 	for (i = 0; i < nr_of_irqs; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &sable_lynx_irq_type,
-			alpha_do_IRQ);
+			handle_level_irq);
 	}
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_takara.c b/arch/alpha/kernel/sys_takara.c
index dc3c232..f8a1e8a 100644
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -60,28 +60,11 @@ takara_disable_irq(unsigned int irq)
 	takara_update_irq_hw(irq, mask);
 }
 
-static unsigned int
-takara_startup_irq(unsigned int irq)
-{
-	takara_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-takara_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		takara_enable_irq(irq);
-}
-
 static struct irq_chip takara_irq_type = {
 	.name		= "TAKARA",
-	.startup	= takara_startup_irq,
-	.shutdown	= takara_disable_irq,
-	.enable		= takara_enable_irq,
-	.disable	= takara_disable_irq,
-	.ack		= takara_disable_irq,
-	.end		= takara_end_irq,
+	.unmask		= takara_enable_irq,
+	.mask		= takara_disable_irq,
+	.mask_ack	= takara_disable_irq,
 };
 
 static void
@@ -154,7 +137,7 @@ takara_init_irq(void)
 
 	for (i = 16; i < 128; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, &takara_irq_type, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, &takara_irq_type, handle_level_irq);
 	}
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 9870f3d..e02494b 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -129,20 +129,6 @@ titan_disable_irq(unsigned int irq)
 	spin_unlock(&titan_irq_lock);
 }
 
-static unsigned int
-titan_startup_irq(unsigned int irq)
-{
-	titan_enable_irq(irq);
-	return 0;	/* never anything pending */
-}
-
-static void
-titan_end_irq(unsigned int irq)
-{
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		titan_enable_irq(irq);
-}
-
 static void
 titan_cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 {
@@ -190,19 +176,16 @@ init_titan_irqs(struct irq_chip * ops, int imin, int imax)
 	long i;
 	for (i = imin; i <= imax; ++i) {
 		irq_to_desc(i)->status |= IRQ_LEVEL;
-		set_irq_chip_and_handler(i, ops, alpha_do_IRQ);
+		set_irq_chip_and_handler(i, ops, handle_level_irq);
 	}
 }
 
 static struct irq_chip titan_irq_type = {
-       .name	       = "TITAN",
-       .startup        = titan_startup_irq,
-       .shutdown       = titan_disable_irq,
-       .enable         = titan_enable_irq,
-       .disable        = titan_disable_irq,
-       .ack            = titan_disable_irq,
-       .end            = titan_end_irq,
-       .set_affinity   = titan_set_irq_affinity,
+       .name		= "TITAN",
+       .unmask		= titan_enable_irq,
+       .mask		= titan_disable_irq,
+       .mask_ack	= titan_disable_irq,
+       .set_affinity	= titan_set_irq_affinity,
 };
 
 static irqreturn_t
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index f6004f0..eec5259 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -139,32 +139,11 @@ wildfire_mask_and_ack_irq(unsigned int irq)
 	spin_unlock(&wildfire_irq_lock);
 }
 
-static unsigned int
-wildfire_startup_irq(unsigned int irq)
-{ 
-	wildfire_enable_irq(irq);
-	return 0; /* never anything pending */
-}
-
-static void
-wildfire_end_irq(unsigned int irq)
-{ 
-#if 0
-	if (!irq_has_action(irq))
-		printk("got irq %d\n", irq);
-#endif
-	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		wildfire_enable_irq(irq);
-}
-
 static struct irq_chip wildfire_irq_type = {
 	.name		= "WILDFIRE",
-	.startup	= wildfire_startup_irq,
-	.shutdown	= wildfire_disable_irq,
-	.enable		= wildfire_enable_irq,
-	.disable	= wildfire_disable_irq,
-	.ack		= wildfire_mask_and_ack_irq,
-	.end		= wildfire_end_irq,
+	.unmask		= wildfire_enable_irq,
+	.mask		= wildfire_disable_irq,
+	.mask_ack	= wildfire_mask_and_ack_irq,
 };
 
 static void __init
@@ -200,15 +179,16 @@ wildfire_init_irq_per_pca(int qbbno, int pcano)
 			continue;
 		irq_to_desc(i+irq_bias)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i+irq_bias, &wildfire_irq_type,
-			alpha_do_IRQ);
+			handle_level_irq);
 	}
 
 	irq_to_desc(36+irq_bias)->status |= IRQ_LEVEL;
-	set_irq_chip_and_handler(36+irq_bias, &wildfire_irq_type, alpha_do_IRQ);
+	set_irq_chip_and_handler(36+irq_bias, &wildfire_irq_type,
+		handle_level_irq);
 	for (i = 40; i < 64; ++i) {
 		irq_to_desc(i+irq_bias)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i+irq_bias, &wildfire_irq_type,
-			alpha_do_IRQ);
+			handle_level_irq);
 	}
 
 	setup_irq(32+irq_bias, &isa_enable);	
-- 
1.7.2.3

