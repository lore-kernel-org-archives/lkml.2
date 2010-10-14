Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0JNWbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:31:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0JNWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:31:12 -0400
Date: Thu, 14 Oct 2010 18:31:11 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        kyle@mcmartin.ca
Subject: [PATCH 1/3] alpha: use set_irq_chip and push down __do_IRQ to the
 machine types
Message-ID: <20101014223110.GB8332@bombadil.infradead.org>
References: <20101014222805.GA8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014222805.GA8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also kill superfluous IRQ_DISABLED initialization, since that's the
default state of the irq_desc[i].status field.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/alpha/include/asm/irq.h      |    3 +++
 arch/alpha/kernel/irq.c           |    7 ++++++-
 arch/alpha/kernel/irq_i8259.c     |    3 +--
 arch/alpha/kernel/irq_pyxis.c     |    4 ++--
 arch/alpha/kernel/irq_srm.c       |    4 ++--
 arch/alpha/kernel/sys_alcor.c     |    4 ++--
 arch/alpha/kernel/sys_cabriolet.c |    5 +++--
 arch/alpha/kernel/sys_dp264.c     |    4 ++--
 arch/alpha/kernel/sys_eb64p.c     |    4 ++--
 arch/alpha/kernel/sys_eiger.c     |    4 ++--
 arch/alpha/kernel/sys_jensen.c    |   10 +++++-----
 arch/alpha/kernel/sys_marvel.c    |   12 ++++++------
 arch/alpha/kernel/sys_mikasa.c    |    4 ++--
 arch/alpha/kernel/sys_noritake.c  |    4 ++--
 arch/alpha/kernel/sys_rawhide.c   |    4 ++--
 arch/alpha/kernel/sys_rx164.c     |    4 ++--
 arch/alpha/kernel/sys_sable.c     |    5 +++--
 arch/alpha/kernel/sys_takara.c    |    4 ++--
 arch/alpha/kernel/sys_titan.c     |    4 ++--
 arch/alpha/kernel/sys_wildfire.c  |   14 ++++++++------
 20 files changed, 59 insertions(+), 48 deletions(-)

diff --git a/arch/alpha/include/asm/irq.h b/arch/alpha/include/asm/irq.h
index 0637740..4126441 100644
--- a/arch/alpha/include/asm/irq.h
+++ b/arch/alpha/include/asm/irq.h
@@ -88,4 +88,7 @@ static __inline__ int irq_canonicalize(int irq)
 struct pt_regs;
 extern void (*perf_irq)(unsigned long, struct pt_regs *);
 
+struct irq_desc;
+extern void alpha_do_IRQ(unsigned int irq, struct irq_desc *desc);
+
 #endif /* _ALPHA_IRQ_H */
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index fe91298..ecfa51e 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -159,6 +159,11 @@ handle_irq(int irq)
 	 * at IPL 0.
 	 */
 	local_irq_disable();
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 }
+
+void alpha_do_IRQ(unsigned int irq, struct irq_desc *desc)
+{
+	__do_IRQ(irq);
+}
diff --git a/arch/alpha/kernel/irq_i8259.c b/arch/alpha/kernel/irq_i8259.c
index 83a9ac2..39299fb 100644
--- a/arch/alpha/kernel/irq_i8259.c
+++ b/arch/alpha/kernel/irq_i8259.c
@@ -107,8 +107,7 @@ init_i8259a_irqs(void)
 	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
 
 	for (i = 0; i < 16; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].chip = &i8259a_irq_type;
+		set_irq_chip_and_handler(i, &i8259a_irq_type, alpha_do_IRQ);
 	}
 
 	setup_irq(2, &cascade);
diff --git a/arch/alpha/kernel/irq_pyxis.c b/arch/alpha/kernel/irq_pyxis.c
index 989ce46..4e1904c 100644
--- a/arch/alpha/kernel/irq_pyxis.c
+++ b/arch/alpha/kernel/irq_pyxis.c
@@ -119,8 +119,8 @@ init_pyxis_irqs(unsigned long ignore_mask)
 	for (i = 16; i < 48; ++i) {
 		if ((ignore_mask >> i) & 1)
 			continue;
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &pyxis_irq_type;
+		set_irq_chip_and_handler(i, &pyxis_irq_type, alpha_do_IRQ);
+		irq_desc[i].status |= IRQ_LEVEL;
 	}
 
 	setup_irq(16+7, &isa_cascade_irqaction);
diff --git a/arch/alpha/kernel/irq_srm.c b/arch/alpha/kernel/irq_srm.c
index d63e93e..b337cfc 100644
--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -68,8 +68,8 @@ init_srm_irqs(long max, unsigned long ignore_mask)
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &srm_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &srm_irq_type, alpha_do_IRQ);
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index 20a30b8..d8c9183 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -142,8 +142,8 @@ alcor_init_irq(void)
 		   on while IRQ probing.  */
 		if (i >= 16+20 && i <= 16+30)
 			continue;
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &alcor_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &alcor_irq_type, alpha_do_IRQ);
 	}
 	i8259a_irq_type.ack = alcor_isa_mask_and_ack_irq;
 
diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
index 14c8898..ba38fcd 100644
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -122,8 +122,9 @@ common_init_irq(void (*srm_dev_int)(unsigned long v))
 		outb(0xff, 0x806);
 
 		for (i = 16; i < 35; ++i) {
-			irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-			irq_desc[i].chip = &cabriolet_irq_type;
+			set_irq_chip_and_handler(i, &cabriolet_irq_type,
+				alpha_do_IRQ);
+			irq_desc[i].status |= IRQ_LEVEL;
 		}
 	}
 
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 4026502..147154d 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -302,8 +302,8 @@ init_tsunami_irqs(struct irq_chip * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = ops;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, ops, alpha_do_IRQ);
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
index df2090c..cb309a4 100644
--- a/arch/alpha/kernel/sys_eb64p.c
+++ b/arch/alpha/kernel/sys_eb64p.c
@@ -135,8 +135,8 @@ eb64p_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 32; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &eb64p_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &eb64p_irq_type, alpha_do_IRQ);
 	}		
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index 3ca1dbc..16a5483 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -153,8 +153,8 @@ eiger_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &eiger_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &eiger_irq_type, alpha_do_IRQ);
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 7a7ae36..5b64f91 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -206,11 +206,11 @@ jensen_init_irq(void)
 {
 	init_i8259a_irqs();
 
-	irq_desc[1].chip = &jensen_local_irq_type;
-	irq_desc[4].chip = &jensen_local_irq_type;
-	irq_desc[3].chip = &jensen_local_irq_type;
-	irq_desc[7].chip = &jensen_local_irq_type;
-	irq_desc[9].chip = &jensen_local_irq_type;
+	set_irq_chip_and_handler(1, &jensen_local_irq_type, alpha_do_IRQ);
+	set_irq_chip_and_handler(4, &jensen_local_irq_type, alpha_do_IRQ);
+	set_irq_chip_and_handler(3, &jensen_local_irq_type, alpha_do_IRQ);
+	set_irq_chip_and_handler(7, &jensen_local_irq_type, alpha_do_IRQ);
+	set_irq_chip_and_handler(9, &jensen_local_irq_type, alpha_do_IRQ);
 
 	common_init_isa_dma();
 }
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 0bb3b5c..0d0699e 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -304,8 +304,8 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
-		irq_desc[base + i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[base + i].chip = lsi_ops;
+		irq_desc[base + i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(base + i, lsi_ops, alpha_do_IRQ);
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -318,8 +318,8 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
-		irq_desc[base + i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[base + i].chip = msi_ops;
+		irq_desc[base + i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(base + i, msi_ops, alpha_do_IRQ);
 	}
 
 	for (i = 0; i < 16; ++i)
@@ -336,8 +336,8 @@ marvel_init_irq(void)
 
 	/* Reserve the legacy irqs.  */
 	for (i = 0; i < 16; ++i) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].chip = &marvel_legacy_irq_type;
+		set_irq_chip_and_handler(i, &marvel_legacy_irq_type,
+			alpha_do_IRQ);
 	}
 
 	/* Init the io7 irqs.  */
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index ee88651..a27bc56 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -115,8 +115,8 @@ mikasa_init_irq(void)
 	mikasa_update_irq_hw(0);
 
 	for (i = 16; i < 32; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &mikasa_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &mikasa_irq_type, alpha_do_IRQ);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index 86503fe..a4f07d6 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -144,8 +144,8 @@ noritake_init_irq(void)
 	outw(0, 0x54c);
 
 	for (i = 16; i < 48; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &noritake_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &noritake_irq_type, alpha_do_IRQ);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
index 26c322b..a63da5c 100644
--- a/arch/alpha/kernel/sys_rawhide.c
+++ b/arch/alpha/kernel/sys_rawhide.c
@@ -194,8 +194,8 @@ rawhide_init_irq(void)
 	}
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &rawhide_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &rawhide_irq_type, alpha_do_IRQ);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
index be16112..0465716 100644
--- a/arch/alpha/kernel/sys_rx164.c
+++ b/arch/alpha/kernel/sys_rx164.c
@@ -116,8 +116,8 @@ rx164_init_irq(void)
 
 	rx164_update_irq_hw(0);
 	for (i = 16; i < 40; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &rx164_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &rx164_irq_type, alpha_do_IRQ);
 	}
 
 	init_i8259a_irqs();
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index b2abe27..944b598 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -535,8 +535,9 @@ sable_lynx_init_irq(int nr_of_irqs)
 	long i;
 
 	for (i = 0; i < nr_of_irqs; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &sable_lynx_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &sable_lynx_irq_type,
+			alpha_do_IRQ);
 	}
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_takara.c b/arch/alpha/kernel/sys_takara.c
index 4da596b..00df4e7 100644
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -153,8 +153,8 @@ takara_init_irq(void)
 		takara_update_irq_hw(i, -1);
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = &takara_irq_type;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, &takara_irq_type, alpha_do_IRQ);
 	}
 
 	common_init_isa_dma();
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 9008d0f..ffa48e8 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -189,8 +189,8 @@ init_titan_irqs(struct irq_chip * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		irq_desc[i].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i].chip = ops;
+		irq_desc[i].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i, ops, alpha_do_IRQ);
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index 62fd972..ea86103 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -198,15 +198,17 @@ wildfire_init_irq_per_pca(int qbbno, int pcano)
 	for (i = 0; i < 16; ++i) {
 		if (i == 2)
 			continue;
-		irq_desc[i+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i+irq_bias].chip = &wildfire_irq_type;
+		irq_desc[i+irq_bias].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i+irq_bias, &wildfire_irq_type,
+			alpha_do_IRQ);
 	}
 
-	irq_desc[36+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
-	irq_desc[36+irq_bias].chip = &wildfire_irq_type;
+	irq_desc[36+irq_bias].status |= IRQ_LEVEL;
+	set_irq_chip_and_handler(36+irq_bias, &wildfire_irq_type, alpha_do_IRQ);
 	for (i = 40; i < 64; ++i) {
-		irq_desc[i+irq_bias].status = IRQ_DISABLED | IRQ_LEVEL;
-		irq_desc[i+irq_bias].chip = &wildfire_irq_type;
+		irq_desc[i+irq_bias].status |= IRQ_LEVEL;
+		set_irq_chip_and_handler(i+irq_bias, &wildfire_irq_type,
+			alpha_do_IRQ);
 	}
 
 	setup_irq(32+irq_bias, &isa_enable);	
-- 
1.7.2.3

