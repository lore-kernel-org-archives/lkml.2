Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab1JaVMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:12:40 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39753
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab1JaVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:12:39 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Scott Wood <scottwood@freescale.com>
Subject: [RFC PATCH 05/10] powerpc/mpic: Search for open-pic device-tree node if NULL
Date: Mon, 31 Oct 2011 17:10:06 -0400
Message-Id: <1320095411-20667-6-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all PowerPC platforms use a standard "open-pic" device node so
the mpic_alloc() function now accepts NULL for the device-node.  This
will cause it to perform a default search with of_find_matching_node().

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/platforms/85xx/corenet_ds.c          |   10 +---------
 arch/powerpc/platforms/85xx/ksi8560.c             |   13 ++-----------
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |   13 +------------
 arch/powerpc/platforms/85xx/mpc85xx_ads.c         |   12 ++----------
 arch/powerpc/platforms/85xx/mpc85xx_cds.c         |   15 +--------------
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |   14 +++-----------
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |   10 +---------
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c         |   14 ++------------
 arch/powerpc/platforms/85xx/p1022_ds.c            |   14 +-------------
 arch/powerpc/platforms/85xx/sbc8548.c             |   16 +---------------
 arch/powerpc/platforms/85xx/sbc8560.c             |   13 ++-----------
 arch/powerpc/platforms/85xx/socrates.c            |   11 +----------
 arch/powerpc/platforms/85xx/stx_gp3.c             |   13 ++-----------
 arch/powerpc/platforms/85xx/tqm85xx.c             |   13 ++-----------
 arch/powerpc/platforms/85xx/xes_mpc85xx.c         |   13 +------------
 arch/powerpc/platforms/embedded6xx/holly.c        |   10 +---------
 arch/powerpc/platforms/embedded6xx/linkstation.c  |    8 ++------
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |   10 +---------
 arch/powerpc/platforms/embedded6xx/storcenter.c   |   10 +---------
 arch/powerpc/sysdev/mpic.c                        |   19 +++++++++++++++++--
 20 files changed, 45 insertions(+), 206 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 7893ad3..134e1f8 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -36,21 +36,13 @@
 void __init corenet_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct device_node *np = NULL;
 	unsigned int flags = MPIC_PRIMARY | MPIC_BIG_ENDIAN |
 				MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU;
 
-	np = of_find_node_by_type(np, "open-pic");
-
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
 	if (ppc_md.get_irq == mpic_get_coreint_irq)
 		flags |= MPIC_ENABLE_COREINT;
 
-	mpic = mpic_alloc(np, 0, flags, 0, 256, " OpenPIC  ");
+	mpic = mpic_alloc(NULL, 0, flags, 0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/ksi8560.c b/arch/powerpc/platforms/85xx/ksi8560.c
index b20c07d..d49dbc4 100644
--- a/arch/powerpc/platforms/85xx/ksi8560.c
+++ b/arch/powerpc/platforms/85xx/ksi8560.c
@@ -68,24 +68,15 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init ksi8560_pic_init(void)
 {
 	struct mpic *mpic;
-	struct device_node *np;
 #ifdef CONFIG_CPM2
+	struct device_node *np;
 	int irq;
 #endif
 
-	np = of_find_node_by_type(NULL, "open-pic");
-
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 #ifdef CONFIG_CPM2
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index 03173ba..2c928f0 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -34,22 +34,11 @@
 
 void __init mpc8536_ds_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np;
-
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 }
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 5cb797b..2b443ba 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -64,23 +64,15 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init mpc85xx_ads_pic_init(void)
 {
 	struct mpic *mpic;
-	struct device_node *np = NULL;
 #ifdef CONFIG_CPM2
+	struct device_node *np = NULL;
 	int irq;
 #endif
 
-	np = of_find_node_by_type(np, "open-pic");
-	if (!np) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 #ifdef CONFIG_CPM2
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 69c1d0a..3a2436b 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -187,23 +187,10 @@ static struct irqaction mpc85xxcds_8259_irqaction = {
 static void __init mpc85xx_cds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct device_node *np = NULL;
-
-	np = of_find_node_by_type(np, "open-pic");
-
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-
-	/* Return the mpic node */
-	of_node_put(np);
-
 	mpic_init(mpic);
 }
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index b608da7..14fccaf 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -61,27 +61,21 @@ static void mpc85xx_8259_cascade(unsigned int irq, struct irq_desc *desc)
 void __init mpc85xx_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct device_node *np;
 #ifdef CONFIG_PPC_I8259
+	struct device_node *np;
 	struct device_node *cascade_node = NULL;
 	int cascade_irq;
 #endif
 	unsigned long root = of_get_flat_dt_root();
 
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
 	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
-		mpic = mpic_alloc(np, 0,
+		mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
-		mpic = mpic_alloc(np, 0,
+		mpic = mpic_alloc(NULL, 0,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			  MPIC_SINGLE_DEST_CPU,
@@ -89,8 +83,6 @@ void __init mpc85xx_ds_pic_init(void)
 	}
 
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 #ifdef CONFIG_PPC_I8259
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 982f1a7..7ebd864 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -474,19 +474,11 @@ machine_arch_initcall(p1021_mds, swiotlb_setup_bus_notifier);
 
 static void __init mpc85xx_mds_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np = NULL;
-
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (!np)
-		return;
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
 			MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
 
 	mpic_init(mpic);
 	mpc85xx_mds_qeic_init();
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index 67bd1d4..9edb2b1 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -43,23 +43,16 @@
 void __init mpc85xx_rdb_pic_init(void)
 {
 	struct mpic *mpic;
-	struct device_node *np;
 	unsigned long root = of_get_flat_dt_root();
 
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
 	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
-		mpic = mpic_alloc(np, 0,
+		mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
-		mpic = mpic_alloc(np, 0,
+		mpic = mpic_alloc(NULL, 0,
 		  MPIC_PRIMARY | MPIC_WANTS_RESET |
 		  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 		  MPIC_SINGLE_DEST_CPU,
@@ -67,10 +60,7 @@ void __init mpc85xx_rdb_pic_init(void)
 	}
 
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
-
 }
 
 /*
diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index d911aca..4279e83 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -238,24 +238,12 @@ int p1022ds_set_sysfs_monitor_port(int val)
 
 void __init p1022_ds_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np;
-
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (!np) {
-		pr_err("Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 		MPIC_PRIMARY | MPIC_WANTS_RESET |
 		MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 		MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
-
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 }
 
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index daced7d..1b5597f 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -53,24 +53,10 @@ static int sbc_rev;
 
 static void __init sbc8548_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np = NULL;
-
-	np = of_find_node_by_type(np, "open-pic");
-
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-
-	/* Return the mpic node */
-	of_node_put(np);
-
 	mpic_init(mpic);
 }
 
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index bd8b6c9..20e68bb 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -54,24 +54,15 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 
 static void __init sbc8560_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np = NULL;
 #ifdef CONFIG_CPM2
+	struct device_node *np = NULL;
 	int irq;
 #endif
 
-	np = of_find_node_by_type(np, "open-pic");
-	if (!np) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 #ifdef CONFIG_CPM2
diff --git a/arch/powerpc/platforms/85xx/socrates.c b/arch/powerpc/platforms/85xx/socrates.c
index fb4bfd6..a9a45f6 100644
--- a/arch/powerpc/platforms/85xx/socrates.c
+++ b/arch/powerpc/platforms/85xx/socrates.c
@@ -45,21 +45,12 @@
 
 static void __init socrates_pic_init(void)
 {
-	struct mpic *mpic;
 	struct device_node *np;
 
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (!np) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 	np = of_find_compatible_node(NULL, NULL, "abb,socrates-fpga-pic");
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index 78aef45..55e941b 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -58,24 +58,15 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 
 static void __init stx_gp3_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np;
 #ifdef CONFIG_CPM2
+	struct device_node *np;
 	int irq;
 #endif
 
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (!np) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 #ifdef CONFIG_CPM2
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index 5775f4c..660769b 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -56,24 +56,15 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 
 static void __init tqm85xx_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np;
 #ifdef CONFIG_CPM2
+	struct device_node *np;
 	int irq;
 #endif
 
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (!np) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 
 #ifdef CONFIG_CPM2
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index fccf9aa..09b8ba0 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -41,22 +41,11 @@
 
 void __init xes_mpc85xx_pic_init(void)
 {
-	struct mpic *mpic;
-	struct device_node *np;
-
-	np = of_find_node_by_type(NULL, "open-pic");
-	if (np == NULL) {
-		printk(KERN_ERR "Could not find open-pic node\n");
-		return;
-	}
-
-	mpic = mpic_alloc(np, 0,
+	struct mpic *mpic = mpic_alloc(np, 0,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
-	of_node_put(np);
-
 	mpic_init(mpic);
 }
 
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index 80b2e2a..edfc84f 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -147,20 +147,13 @@ static void __init holly_setup_arch(void)
 static void __init holly_init_IRQ(void)
 {
 	struct mpic *mpic;
-	struct device_node *tsi_pic;
 #ifdef CONFIG_PCI
 	unsigned int cascade_pci_irq;
 	struct device_node *tsi_pci;
 	struct device_node *cascade_node = NULL;
 #endif
 
-	tsi_pic = of_find_node_by_type(NULL, "open-pic");
-	if (!tsi_pic) {
-		printk(KERN_ERR "%s: No tsi108 PIC found !\n", __func__);
-		return;
-	}
-
-	mpic = mpic_alloc(tsi_pic, 0,
+	mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24,
@@ -194,7 +187,6 @@ static void __init holly_init_IRQ(void)
 #endif
 	/* Configure MPIC outputs to CPU0 */
 	tsi108_write_reg(TSI108_MPIC_OFFSET + 0x30c, 0);
-	of_node_put(tsi_pic);
 }
 
 void holly_show_cpuinfo(struct seq_file *m)
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 72b3685..502ff60 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -81,13 +81,9 @@ static void __init linkstation_setup_arch(void)
 static void __init linkstation_init_IRQ(void)
 {
 	struct mpic *mpic;
-	struct device_node *dnp;
 
-	dnp = of_find_node_by_type(NULL, "open-pic");
-	if (dnp == NULL)
-		return;
-
-	mpic = mpic_alloc(dnp, 0, MPIC_PRIMARY | MPIC_WANTS_RESET, 4, 32, " EPIC     ");
+	mpic = mpic_alloc(NULL, 0, MPIC_PRIMARY | MPIC_WANTS_RESET,
+			4, 32, " EPIC     ");
 	BUG_ON(mpic == NULL);
 
 	/* PCI IRQs */
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index 28082f9..1dd976e 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -101,20 +101,13 @@ static void __init mpc7448_hpc2_setup_arch(void)
 static void __init mpc7448_hpc2_init_IRQ(void)
 {
 	struct mpic *mpic;
-	struct device_node *tsi_pic;
 #ifdef CONFIG_PCI
 	unsigned int cascade_pci_irq;
 	struct device_node *tsi_pci;
 	struct device_node *cascade_node = NULL;
 #endif
 
-	tsi_pic = of_find_node_by_type(NULL, "open-pic");
-	if (!tsi_pic) {
-		printk("%s: No tsi108 PIC found !\n", __func__);
-		return;
-	}
-
-	mpic = mpic_alloc(tsi_pic, 0,
+	mpic = mpic_alloc(NULL, 0,
 			MPIC_PRIMARY | MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24,
@@ -148,7 +141,6 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 #endif
 	/* Configure MPIC outputs to CPU0 */
 	tsi108_write_reg(TSI108_MPIC_OFFSET + 0x30c, 0);
-	of_node_put(tsi_pic);
 }
 
 void mpc7448_hpc2_show_cpuinfo(struct seq_file *m)
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index 797870f..a233d91 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -83,17 +83,9 @@ static void __init storcenter_setup_arch(void)
 static void __init storcenter_init_IRQ(void)
 {
 	struct mpic *mpic;
-	struct device_node *dnp;
 
-	dnp = of_find_node_by_type(NULL, "open-pic");
-	if (dnp == NULL)
-		return;
-
-	mpic = mpic_alloc(dnp, 0, MPIC_PRIMARY | MPIC_WANTS_RESET,
+	mpic = mpic_alloc(NULL, 0, MPIC_PRIMARY | MPIC_WANTS_RESET,
 			16, 32, " OpenPIC  ");
-
-	of_node_put(dnp);
-
 	BUG_ON(mpic == NULL);
 
 	/*
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 0ad7bf2..548ca16 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1145,8 +1145,23 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	const char *vers;
 	const u32 *psrc;
 
-	/* This code assumes that a non-NULL device node is passed in */
-	BUG_ON(!node);
+	/* Default MPIC search parameters */
+	static const struct of_device_id __initconst mpic_device_id[] = {
+		{ .type	      = "open-pic", },
+		{ .compatible = "open-pic", },
+		{},
+	};
+
+	/*
+	 * If we were not passed a device-tree node, then perform the default
+	 * search for standardized a standardized OpenPIC.
+	 */
+	if (!node)
+		node = of_find_matching_node(NULL, mpic_device_id);
+
+	/* Make sure we got *something* */
+	if (!node)
+		return NULL;
 
 	/* Pick the physical address from the device tree if unspecified */
 	if (!phys_addr) {
-- 
1.7.2.5

