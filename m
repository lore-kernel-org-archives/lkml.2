Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1LVUUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:20:47 -0500
Received: from border.exmeritus.com ([70.167.241.26]:32985 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1LVUUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:20:43 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Timur Tabi <timur@freescale.com>,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>,
        Anton Blanchard <anton@samba.org>, Milton Miller <miltonm@bga.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] powerpc/mpic: Remove MPIC_BROKEN_FRR_NIRQS and duplicate irq_count
Date: Thu, 22 Dec 2011 15:19:12 -0500
Message-Id: <1324585155-13453-5-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mpic->irq_count variable is only used as a software error-checking
limit to determine whether or not an IRQ number is valid.  In board code
which does not manually specify an IRQ count to mpic_alloc(), i.e. 0, it
is automatically detected from the number of ISUs and the ISU size.

In practice, all hardware ends up with irq_count == num_sources, so all
of the runtime checks on mpic->irq_count should just check the value of
mpic->num_sources instead.

When platform hardware does not correctly report the number of IRQs,
which only happens on the MPC85xx/MPC86xx, the MPIC_BROKEN_FRR_NIRQS
flag is used to override the detected value of num_sources with the
manual irq_count parameter.  Since there's no need to manually specify
the number of IRQs except in this case, the extra flag can be eliminated
and the test changed to "irq_count != 0".

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/mpic.h                   |    3 ---
 arch/powerpc/platforms/85xx/corenet_ds.c          |    3 +--
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    4 ++--
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c         |    4 ++--
 arch/powerpc/platforms/85xx/p1010rdb.c            |    2 +-
 arch/powerpc/platforms/85xx/p1022_ds.c            |    2 +-
 arch/powerpc/platforms/85xx/p1023_rds.c           |    2 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c         |    2 +-
 arch/powerpc/platforms/86xx/pic.c                 |    2 +-
 arch/powerpc/platforms/embedded6xx/holly.c        |    3 +--
 arch/powerpc/platforms/embedded6xx/linkstation.c  |    2 +-
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |    3 +--
 arch/powerpc/platforms/embedded6xx/storcenter.c   |    2 +-
 arch/powerpc/platforms/pseries/setup.c            |    4 +---
 arch/powerpc/sysdev/mpic.c                        |   17 ++++++-----------
 arch/powerpc/sysdev/mpic_msi.c                    |    4 ++--
 18 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 67b4d98..2ebac31 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -273,7 +273,6 @@ struct mpic
 	unsigned int		isu_size;
 	unsigned int		isu_shift;
 	unsigned int		isu_mask;
-	unsigned int		irq_count;
 	/* Number of sources */
 	unsigned int		num_sources;
 	/* default senses array */
@@ -363,8 +362,6 @@ struct mpic
 #define MPIC_ENABLE_MCK			0x00000200
 /* Disable bias among target selection, spread interrupts evenly */
 #define MPIC_NO_BIAS			0x00000400
-/* Ignore NIRQS as reported by FRR */
-#define MPIC_BROKEN_FRR_NIRQS		0x00000800
 /* Destination only supports a single CPU at a time */
 #define MPIC_SINGLE_DEST_CPU		0x00001000
 /* Enable CoreInt delivery of interrupts */
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 07e3e6c..768479b 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -36,8 +36,7 @@
 void __init corenet_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	unsigned int flags = MPIC_BIG_ENDIAN |
-				MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU;
+	unsigned int flags = MPIC_BIG_ENDIAN | MPIC_SINGLE_DEST_CPU;
 
 	if (ppc_md.get_irq == mpic_get_coreint_irq)
 		flags |= MPIC_ENABLE_COREINT;
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index cf26682..d5373e0 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -38,7 +38,7 @@ void __init mpc8536_ds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 			  MPIC_WANTS_RESET |
-			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
+			  MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index eefbb91..528b9a0 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -72,13 +72,13 @@ void __init mpc85xx_ds_pic_init(void)
 
 	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
 		mpic = mpic_alloc(NULL, 0,
-			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			MPIC_BIG_ENDIAN |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(NULL, 0,
 			  MPIC_WANTS_RESET |
-			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			  MPIC_BIG_ENDIAN |
 			  MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	}
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 1d15a0c..a0cb770 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -436,7 +436,7 @@ static void __init mpc85xx_mds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
-			MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
+			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index ccf520e..a23f6f3 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -49,13 +49,13 @@ void __init mpc85xx_rdb_pic_init(void)
 
 	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
 		mpic = mpic_alloc(NULL, 0,
-			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			MPIC_BIG_ENDIAN |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(NULL, 0,
 		  MPIC_WANTS_RESET |
-		  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+		  MPIC_BIG_ENDIAN |
 		  MPIC_SINGLE_DEST_CPU,
 		  0, 256, " OpenPIC  ");
 	}
diff --git a/arch/powerpc/platforms/85xx/p1010rdb.c b/arch/powerpc/platforms/85xx/p1010rdb.c
index 894f1e8..d2a569d 100644
--- a/arch/powerpc/platforms/85xx/p1010rdb.c
+++ b/arch/powerpc/platforms/85xx/p1010rdb.c
@@ -34,7 +34,7 @@ void __init p1010_rdb_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 	  MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
-	  MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
+	  MPIC_SINGLE_DEST_CPU,
 	  0, 256, " OpenPIC  ");
 
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index bb3d84f..433546e 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -243,7 +243,7 @@ void __init p1022_ds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 		MPIC_WANTS_RESET |
-		MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+		MPIC_BIG_ENDIAN |
 		MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index e92a714..88541dc 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -95,7 +95,7 @@ static void __init mpc85xx_rds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 		MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
-		MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
+		MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
 
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 3a69f8b..1ab4e02 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -45,7 +45,7 @@ void __init xes_mpc85xx_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 			  MPIC_WANTS_RESET |
-			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
+			  MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 52bbfa0..27959d6 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -39,7 +39,7 @@ void __init mpc86xx_init_irq(void)
 
 	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
-			MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
+			MPIC_SINGLE_DEST_CPU,
 			0, 256, " MPIC     ");
 	BUG_ON(mpic == NULL);
 
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index 9cfcf20..d7727de 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -157,8 +157,7 @@ static void __init holly_init_IRQ(void)
 	mpic = mpic_alloc(NULL, 0,
 			MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
-			24,
-			NR_IRQS-4, /* num_sources used */
+			24, 0,
 			"Tsi108_PIC");
 
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index bcfad92..9479f4e 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -83,7 +83,7 @@ static void __init linkstation_init_IRQ(void)
 	struct mpic *mpic;
 
 	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET,
-			4, 32, " EPIC     ");
+			4, 0, " EPIC     ");
 	BUG_ON(mpic == NULL);
 
 	/* PCI IRQs */
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index f3350d7..90acb54 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -111,8 +111,7 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 	mpic = mpic_alloc(NULL, 0,
 			MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
-			24,
-			NR_IRQS-4, /* num_sources used */
+			24, 0,
 			"Tsi108_PIC");
 
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index afa6388..451dce4 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -85,7 +85,7 @@ static void __init storcenter_init_IRQ(void)
 	struct mpic *mpic;
 
 	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET,
-			16, 32, " OpenPIC  ");
+			16, 0, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 
 	/*
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index f79f127..6d0a5df 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -190,9 +190,7 @@ static void __init pseries_mpic_init_IRQ(void)
 	BUG_ON(openpic_addr == 0);
 
 	/* Setup the openpic driver */
-	mpic = mpic_alloc(pSeries_mpic_node, openpic_addr, 0,
-			  16, 250, /* isu size, irq count */
-			  " MPIC     ");
+	mpic = mpic_alloc(pSeries_mpic_node, openpic_addr, 0, 16, 0, " MPIC     ");
 	BUG_ON(mpic == NULL);
 
 	/* Add ISUs */
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index c297a52..cbffeb7 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -873,7 +873,7 @@ int mpic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 	DBG("mpic: set_irq_type(mpic:@%p,virq:%d,src:0x%x,type:0x%x)\n",
 	    mpic, d->irq, src, flow_type);
 
-	if (src >= mpic->irq_count)
+	if (src >= mpic->num_sources)
 		return -EINVAL;
 
 	if (flow_type == IRQ_TYPE_NONE)
@@ -909,7 +909,7 @@ void mpic_set_vector(unsigned int virq, unsigned int vector)
 	DBG("mpic: set_vector(mpic:@%p,virq:%d,src:%d,vector:0x%x)\n",
 	    mpic, virq, src, vector);
 
-	if (src >= mpic->irq_count)
+	if (src >= mpic->num_sources)
 		return;
 
 	vecpri = mpic_irq_read(src, MPIC_INFO(IRQ_VECTOR_PRI));
@@ -926,7 +926,7 @@ void mpic_set_destination(unsigned int virq, unsigned int cpuid)
 	DBG("mpic: set_destination(mpic:@%p,virq:%d,src:%d,cpuid:0x%x)\n",
 	    mpic, virq, src, cpuid);
 
-	if (src >= mpic->irq_count)
+	if (src >= mpic->num_sources)
 		return;
 
 	mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION), 1 << cpuid);
@@ -1006,7 +1006,7 @@ static int mpic_host_map(struct irq_host *h, unsigned int virq,
 		return 0;
 	}
 
-	if (hw >= mpic->irq_count)
+	if (hw >= mpic->num_sources)
 		return -EINVAL;
 
 	mpic_msi_reserve_hwirq(mpic, hw);
@@ -1221,7 +1221,6 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->hc_tm.name = name;
 
 	mpic->isu_size = isu_size;
-	mpic->irq_count = irq_count;
 	mpic->num_sources = 0; /* so far */
 
 	if (mpic->flags & MPIC_LARGE_VECTORS)
@@ -1314,8 +1313,8 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	 */
 	greg_feature = mpic_read(mpic->gregs, MPIC_INFO(GREG_FEATURE_0));
 	if (isu_size == 0) {
-		if (mpic->flags & MPIC_BROKEN_FRR_NIRQS)
-			mpic->num_sources = mpic->irq_count;
+		if (irq_count)
+			mpic->num_sources = irq_count;
 		else
 			mpic->num_sources =
 				((greg_feature & MPIC_GREG_FEATURE_LAST_SRC_MASK)
@@ -1450,10 +1449,6 @@ void __init mpic_init(struct mpic *mpic)
 			       (mpic->ipi_vecs[0] + i));
 	}
 
-	/* Initialize interrupt sources */
-	if (mpic->irq_count == 0)
-		mpic->irq_count = mpic->num_sources;
-
 	/* Do the HT PIC fixups on U3 broken mpic */
 	DBG("MPIC flags: %x\n", mpic->flags);
 	if ((mpic->flags & MPIC_U3_HT_IRQS) && !(mpic->flags & MPIC_SECONDARY)) {
diff --git a/arch/powerpc/sysdev/mpic_msi.c b/arch/powerpc/sysdev/mpic_msi.c
index 0f67cd7..cfe3947 100644
--- a/arch/powerpc/sysdev/mpic_msi.c
+++ b/arch/powerpc/sysdev/mpic_msi.c
@@ -54,7 +54,7 @@ static int mpic_msi_reserve_u3_hwirqs(struct mpic *mpic)
 	for (i = 100; i < 105; i++)
 		msi_bitmap_reserve_hwirq(&mpic->msi_bitmap, i);
 
-	for (i = 124; i < mpic->irq_count; i++)
+	for (i = 124; i < mpic->num_sources; i++)
 		msi_bitmap_reserve_hwirq(&mpic->msi_bitmap, i);
 
 
@@ -83,7 +83,7 @@ int mpic_msi_init_allocator(struct mpic *mpic)
 {
 	int rc;
 
-	rc = msi_bitmap_alloc(&mpic->msi_bitmap, mpic->irq_count,
+	rc = msi_bitmap_alloc(&mpic->msi_bitmap, mpic->num_sources,
 			      mpic->irqhost->of_node);
 	if (rc)
 		return rc;
-- 
1.7.7.3

