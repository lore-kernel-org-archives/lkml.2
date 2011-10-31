Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1JaVLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:11:54 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39718
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab1JaVLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:11:52 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kumar Gala <galak@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Milton Miller <miltonm@bga.com>, Scott Wood <scottwood@freescale.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 02/10] powerpc: Consolidate mpic_alloc() OF address translation
Date: Mon, 31 Oct 2011 17:10:03 -0400
Message-Id: <1320095411-20667-3-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the open-coded "reg" property lookup and address
translation in mpic_alloc(), directly call of_address_to_resource().
This includes various workarounds for special cases which the naive
of_address_translate() does not.

Afterwards it is possible to remove the copiously copy-pasted calls to
of_address_translate() from the 85xx/86xx/powermac platforms.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/platforms/85xx/corenet_ds.c  |    9 +----
 arch/powerpc/platforms/85xx/ksi8560.c     |    9 +----
 arch/powerpc/platforms/85xx/mpc8536_ds.c  |    9 +----
 arch/powerpc/platforms/85xx/mpc85xx_ads.c |    9 +----
 arch/powerpc/platforms/85xx/mpc85xx_cds.c |    9 +----
 arch/powerpc/platforms/85xx/mpc85xx_ds.c  |   11 +----
 arch/powerpc/platforms/85xx/mpc85xx_mds.c |    9 +----
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c |   11 +----
 arch/powerpc/platforms/85xx/p1010rdb.c    |    9 +----
 arch/powerpc/platforms/85xx/p1022_ds.c    |    9 +----
 arch/powerpc/platforms/85xx/p1023_rds.c   |    9 +----
 arch/powerpc/platforms/85xx/sbc8548.c     |    9 +----
 arch/powerpc/platforms/85xx/sbc8560.c     |    9 +----
 arch/powerpc/platforms/85xx/socrates.c    |    9 +----
 arch/powerpc/platforms/85xx/stx_gp3.c     |    9 +----
 arch/powerpc/platforms/85xx/tqm85xx.c     |    9 +----
 arch/powerpc/platforms/85xx/xes_mpc85xx.c |    9 +----
 arch/powerpc/platforms/86xx/pic.c         |    4 +-
 arch/powerpc/platforms/powermac/pic.c     |    7 +---
 arch/powerpc/sysdev/mpic.c                |   63 +++++++++++++++--------------
 20 files changed, 54 insertions(+), 177 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 435074d..7893ad3 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -36,7 +36,6 @@
 void __init corenet_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 	unsigned int flags = MPIC_PRIMARY | MPIC_BIG_ENDIAN |
 				MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU;
@@ -48,16 +47,10 @@ void __init corenet_ds_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
 	if (ppc_md.get_irq == mpic_get_coreint_irq)
 		flags |= MPIC_ENABLE_COREINT;
 
-	mpic = mpic_alloc(np, r.start, flags, 0, 256, " OpenPIC  ");
+	mpic = mpic_alloc(np, 0, flags, 0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/ksi8560.c b/arch/powerpc/platforms/85xx/ksi8560.c
index c46f935..b20c07d 100644
--- a/arch/powerpc/platforms/85xx/ksi8560.c
+++ b/arch/powerpc/platforms/85xx/ksi8560.c
@@ -68,7 +68,6 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init ksi8560_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 #ifdef CONFIG_CPM2
 	int irq;
@@ -81,13 +80,7 @@ static void __init ksi8560_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Could not map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index f79f2f1..03173ba 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -35,7 +35,6 @@
 void __init mpc8536_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 
 	np = of_find_node_by_type(NULL, "open-pic");
@@ -44,13 +43,7 @@ void __init mpc8536_ds_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
 			0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 3b2c9bb..5cb797b 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -64,7 +64,6 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init mpc85xx_ads_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 #ifdef CONFIG_CPM2
 	int irq;
@@ -76,13 +75,7 @@ static void __init mpc85xx_ads_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Could not map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 2bf9978..69c1d0a 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -187,7 +187,6 @@ static struct irqaction mpc85xxcds_8259_irqaction = {
 static void __init mpc85xx_cds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 
 	np = of_find_node_by_type(np, "open-pic");
@@ -197,13 +196,7 @@ static void __init mpc85xx_cds_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 52d2a3e..b608da7 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -61,7 +61,6 @@ static void mpc85xx_8259_cascade(unsigned int irq, struct irq_desc *desc)
 void __init mpc85xx_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 #ifdef CONFIG_PPC_I8259
 	struct device_node *cascade_node = NULL;
@@ -75,20 +74,14 @@ void __init mpc85xx_ds_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
 	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
-		mpic = mpic_alloc(np, r.start,
+		mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
-		mpic = mpic_alloc(np, r.start,
+		mpic = mpic_alloc(np, 0,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			  MPIC_SINGLE_DEST_CPU,
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 074be05..982f1a7 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -475,20 +475,13 @@ machine_arch_initcall(p1021_mds, swiotlb_setup_bus_notifier);
 static void __init mpc85xx_mds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 
 	np = of_find_node_by_type(NULL, "open-pic");
 	if (!np)
 		return;
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
 			MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index cd49898..67bd1d4 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -43,7 +43,6 @@
 void __init mpc85xx_rdb_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 	unsigned long root = of_get_flat_dt_root();
 
@@ -53,20 +52,14 @@ void __init mpc85xx_rdb_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
 	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
-		mpic = mpic_alloc(np, r.start,
+		mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
-		mpic = mpic_alloc(np, r.start,
+		mpic = mpic_alloc(np, 0,
 		  MPIC_PRIMARY | MPIC_WANTS_RESET |
 		  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 		  MPIC_SINGLE_DEST_CPU,
diff --git a/arch/powerpc/platforms/85xx/p1010rdb.c b/arch/powerpc/platforms/85xx/p1010rdb.c
index d7387fa..5ffca27 100644
--- a/arch/powerpc/platforms/85xx/p1010rdb.c
+++ b/arch/powerpc/platforms/85xx/p1010rdb.c
@@ -31,7 +31,6 @@
 void __init p1010_rdb_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 
 	np = of_find_node_by_type(NULL, "open-pic");
@@ -40,13 +39,7 @@ void __init p1010_rdb_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start, MPIC_PRIMARY | MPIC_WANTS_RESET |
+	mpic = mpic_alloc(np, NULL, MPIC_PRIMARY | MPIC_WANTS_RESET |
 	  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 	  0, 256, " OpenPIC  ");
 
diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index 7e90e24..d911aca 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -239,7 +239,6 @@ int p1022ds_set_sysfs_monitor_port(int val)
 void __init p1022_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 
 	np = of_find_node_by_type(NULL, "open-pic");
@@ -248,13 +247,7 @@ void __init p1022_ds_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		pr_err("Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 		MPIC_PRIMARY | MPIC_WANTS_RESET |
 		MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 		MPIC_SINGLE_DEST_CPU,
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index 5ab21f3..30a5adb 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -109,7 +109,6 @@ machine_device_initcall(p1023_rds, p1023_publish_devices);
 static void __init mpc85xx_rds_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 
 	np = of_find_node_by_type(NULL, "open-pic");
@@ -118,13 +117,7 @@ static void __init mpc85xx_rds_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, NULL,
 		MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
 		MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index d07dcb7..daced7d 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -54,7 +54,6 @@ static int sbc_rev;
 static void __init sbc8548_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 
 	np = of_find_node_by_type(np, "open-pic");
@@ -64,13 +63,7 @@ static void __init sbc8548_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index 09ced72..bd8b6c9 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -55,7 +55,6 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init sbc8560_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np = NULL;
 #ifdef CONFIG_CPM2
 	int irq;
@@ -67,13 +66,7 @@ static void __init sbc8560_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Could not map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/socrates.c b/arch/powerpc/platforms/85xx/socrates.c
index 747d8fb..fb4bfd6 100644
--- a/arch/powerpc/platforms/85xx/socrates.c
+++ b/arch/powerpc/platforms/85xx/socrates.c
@@ -46,7 +46,6 @@
 static void __init socrates_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 
 	np = of_find_node_by_type(NULL, "open-pic");
@@ -55,13 +54,7 @@ static void __init socrates_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Could not map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index 5387e9f..78aef45 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -59,7 +59,6 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init stx_gp3_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 #ifdef CONFIG_CPM2
 	int irq;
@@ -71,13 +70,7 @@ static void __init stx_gp3_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Could not map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index 325de77..5775f4c 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -57,7 +57,6 @@ static void cpm2_cascade(unsigned int irq, struct irq_desc *desc)
 static void __init tqm85xx_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 #ifdef CONFIG_CPM2
 	int irq;
@@ -69,13 +68,7 @@ static void __init tqm85xx_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Could not map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index ce3f660..fccf9aa 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -42,7 +42,6 @@
 void __init xes_mpc85xx_pic_init(void)
 {
 	struct mpic *mpic;
-	struct resource r;
 	struct device_node *np;
 
 	np = of_find_node_by_type(NULL, "open-pic");
@@ -51,13 +50,7 @@ void __init xes_mpc85xx_pic_init(void)
 		return;
 	}
 
-	if (of_address_to_resource(np, 0, &r)) {
-		printk(KERN_ERR "Failed to map mpic register space\n");
-		of_node_put(np);
-		return;
-	}
-
-	mpic = mpic_alloc(np, r.start,
+	mpic = mpic_alloc(np, 0,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
 			0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 8ef8960..f85c8f0 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -33,7 +33,6 @@ void __init mpc86xx_init_irq(void)
 {
 	struct mpic *mpic;
 	struct device_node *np;
-	struct resource res;
 #ifdef CONFIG_PPC_I8259
 	struct device_node *cascade_node = NULL;
 	int cascade_irq;
@@ -43,9 +42,8 @@ void __init mpc86xx_init_irq(void)
 	np = of_find_node_by_type(NULL, "open-pic");
 	if (np == NULL)
 		return;
-	of_address_to_resource(np, 0, &res);
 
-	mpic = mpic_alloc(np, res.start,
+	mpic = mpic_alloc(np, 0,
 			MPIC_PRIMARY | MPIC_WANTS_RESET |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 7667db4..fe360f7c 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -500,15 +500,10 @@ static struct mpic * __init pmac_setup_one_mpic(struct device_node *np,
 						int master)
 {
 	const char *name = master ? " MPIC 1   " : " MPIC 2   ";
-	struct resource r;
 	struct mpic *mpic;
 	unsigned int flags = master ? MPIC_PRIMARY : 0;
 	int rc;
 
-	rc = of_address_to_resource(np, 0, &r);
-	if (rc)
-		return NULL;
-
 	pmac_call_feature(PMAC_FTR_ENABLE_MPIC, np, 0, 0);
 
 	flags |= MPIC_WANTS_RESET;
@@ -521,7 +516,7 @@ static struct mpic * __init pmac_setup_one_mpic(struct device_node *np,
 	if (master && (flags & MPIC_BIG_ENDIAN))
 		flags |= MPIC_U3_HT_IRQS;
 
-	mpic = mpic_alloc(np, r.start, flags, 0, 0, name);
+	mpic = mpic_alloc(np, 0, flags, 0, 0, name);
 	if (mpic == NULL)
 		return NULL;
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index d5d3ff3..d6ef4d9 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1144,7 +1144,29 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	const char	*vers;
 	int		i;
 	int		intvec_top;
-	u64		paddr = phys_addr;
+
+	/*
+	 * If no phyiscal address was specified then all of the phyiscal
+	 * addressing parameters must come from the device-tree.
+	 */
+	if (!phys_addr) {
+		BUG_ON(!node);
+
+		/* Check if it is DCR-based */
+		if (of_get_property(node, "dcr-reg")) {
+			flags |= MPIC_USES_DCR;
+		} else {
+			struct resource r;
+			if (of_address_to_resource(node, 0, &r))
+				return NULL;
+			phys_addr = r.start;
+		}
+	}
+
+#ifndef CONFIG_PPC_DCR
+	/* If DCR support is not enabled then MPICs cannot use it */
+	BUG_ON(flags & MPIC_USES_DCR);
+#endif
 
 	mpic = kzalloc(sizeof(struct mpic), GFP_KERNEL);
 	if (mpic == NULL)
@@ -1226,35 +1248,16 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 #endif
 
 	/* default register type */
-	mpic->reg_type = (flags & MPIC_BIG_ENDIAN) ?
-		mpic_access_mmio_be : mpic_access_mmio_le;
-
-	/* If no physical address is passed in, a device-node is mandatory */
-	BUG_ON(paddr == 0 && node == NULL);
-
-	/* If no physical address passed in, check if it's dcr based */
-	if (paddr == 0 && of_get_property(node, "dcr-reg", NULL) != NULL) {
-#ifdef CONFIG_PPC_DCR
-		mpic->flags |= MPIC_USES_DCR;
+	if (flags & MPIC_USES_DCR)
 		mpic->reg_type = mpic_access_dcr;
-#else
-		BUG();
-#endif /* CONFIG_PPC_DCR */
-	}
-
-	/* If the MPIC is not DCR based, and no physical address was passed
-	 * in, try to obtain one
-	 */
-	if (paddr == 0 && !(mpic->flags & MPIC_USES_DCR)) {
-		const u32 *reg = of_get_property(node, "reg", NULL);
-		BUG_ON(reg == NULL);
-		paddr = of_translate_address(node, reg);
-		BUG_ON(paddr == OF_BAD_ADDR);
-	}
+	else if (flags & MPIC_BIG_ENDIAN)
+		mpic->reg_type = mpic_access_mmio_be;
+	else
+		mpic->reg_type = mpic_access_mmio_le;
 
 	/* Map the global registers */
-	mpic_map(mpic, node, paddr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
-	mpic_map(mpic, node, paddr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
+	mpic_map(mpic, node, phys_addr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
+	mpic_map(mpic, node, phys_addr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
 
 	/* Reset */
 
@@ -1303,7 +1306,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 
 	/* Map the per-CPU registers */
 	for (i = 0; i < mpic->num_cpus; i++) {
-		mpic_map(mpic, node, paddr, &mpic->cpuregs[i],
+		mpic_map(mpic, node, phys_addr, &mpic->cpuregs[i],
 			 MPIC_INFO(CPU_BASE) + i * MPIC_INFO(CPU_STRIDE),
 			 0x1000);
 	}
@@ -1311,7 +1314,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	/* Initialize main ISU if none provided */
 	if (mpic->isu_size == 0) {
 		mpic->isu_size = mpic->num_sources;
-		mpic_map(mpic, node, paddr, &mpic->isus[0],
+		mpic_map(mpic, node, phys_addr, &mpic->isus[0],
 			 MPIC_INFO(IRQ_BASE), MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
 	}
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
@@ -1343,7 +1346,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	}
 	printk(KERN_INFO "mpic: Setting up MPIC \"%s\" version %s at %llx,"
 	       " max %d CPUs\n",
-	       name, vers, (unsigned long long)paddr, mpic->num_cpus);
+	       name, vers, (unsigned long long)phys_addr, mpic->num_cpus);
 	printk(KERN_INFO "mpic: ISU size: %d, shift: %d, mask: %x\n",
 	       mpic->isu_size, mpic->isu_shift, mpic->isu_mask);
 
-- 
1.7.2.5

