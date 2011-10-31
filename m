Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab1JaVON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:14:13 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39768
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752911Ab1JaVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:12:53 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Scott Wood <scottwood@freescale.com>,
        Dave Liu <daveliu@freescale.com>,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Nishanth Aravamudan <nacc@us.ibm.com>, Milton Miller <miltonm@bga.com>,
        cbe-oss-dev@lists.ozlabs.org
Subject: [RFC PATCH 06/10] powerpc/mpic: Invert the meaning of MPIC_PRIMARY
Date: Mon, 31 Oct 2011 17:10:07 -0400
Message-Id: <1320095411-20667-7-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that there are only 2 in-tree platforms which use MPICs
which are not "primary":  IBM Cell and PowerMac.  To reduce the
complexity of the typical board setup code, invert the MPIC_PRIMARY bit
into MPIC_SECONDARY.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/mpic.h                   |    8 ++++----
 arch/powerpc/platforms/44x/iss4xx.c               |    2 +-
 arch/powerpc/platforms/85xx/corenet_ds.c          |    2 +-
 arch/powerpc/platforms/85xx/ksi8560.c             |    2 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_ads.c         |    3 +--
 arch/powerpc/platforms/85xx/mpc85xx_cds.c         |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    3 +--
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c         |    3 +--
 arch/powerpc/platforms/85xx/p1010rdb.c            |    2 +-
 arch/powerpc/platforms/85xx/p1022_ds.c            |    2 +-
 arch/powerpc/platforms/85xx/p1023_rds.c           |    2 +-
 arch/powerpc/platforms/85xx/sbc8548.c             |    2 +-
 arch/powerpc/platforms/85xx/sbc8560.c             |    2 +-
 arch/powerpc/platforms/85xx/socrates.c            |    2 +-
 arch/powerpc/platforms/85xx/stx_gp3.c             |    2 +-
 arch/powerpc/platforms/85xx/tqm85xx.c             |    2 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c         |    2 +-
 arch/powerpc/platforms/86xx/pic.c                 |    2 +-
 arch/powerpc/platforms/cell/setup.c               |    2 +-
 arch/powerpc/platforms/chrp/setup.c               |    3 +--
 arch/powerpc/platforms/embedded6xx/holly.c        |    2 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c  |    2 +-
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |    2 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c   |    2 +-
 arch/powerpc/platforms/maple/setup.c              |    2 +-
 arch/powerpc/platforms/pasemi/setup.c             |    2 +-
 arch/powerpc/platforms/powermac/pic.c             |    2 +-
 arch/powerpc/platforms/pseries/setup.c            |    3 +--
 arch/powerpc/sysdev/mpic.c                        |   14 +++++++-------
 31 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 49bab41..a241076 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -336,11 +336,11 @@ struct mpic
  * Note setting any ID (leaving those bits to 0) means standard MPIC
  */
 
-/* This is the primary controller, only that one has IPIs and
- * has afinity control. A non-primary MPIC always uses CPU0
- * registers only
+/*
+ * This is a secondary ("chained") controller; it only uses the CPU0
+ * registers.  Primary controllers have IPIs and affinity control.
  */
-#define MPIC_PRIMARY			0x00000001
+#define MPIC_SECONDARY			0x00000001
 
 /* Set this for a big-endian MPIC */
 #define MPIC_BIG_ENDIAN			0x00000002
diff --git a/arch/powerpc/platforms/44x/iss4xx.c b/arch/powerpc/platforms/44x/iss4xx.c
index 19395f1..5b8cdbb 100644
--- a/arch/powerpc/platforms/44x/iss4xx.c
+++ b/arch/powerpc/platforms/44x/iss4xx.c
@@ -71,7 +71,7 @@ static void __init iss4xx_init_irq(void)
 		/* The MPIC driver will get everything it needs from the
 		 * device-tree, just pass 0 to all arguments
 		 */
-		struct mpic *mpic = mpic_alloc(np, 0, MPIC_PRIMARY, 0, 0,
+		struct mpic *mpic = mpic_alloc(np, 0, 0, 0, 0,
 					       " MPIC     ");
 		BUG_ON(mpic == NULL);
 		mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 134e1f8..7b737a9 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -36,7 +36,7 @@
 void __init corenet_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	unsigned int flags = MPIC_PRIMARY | MPIC_BIG_ENDIAN |
+	unsigned int flags = MPIC_BIG_ENDIAN |
 				MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU;
 
 	if (ppc_md.get_irq == mpic_get_coreint_irq)
diff --git a/arch/powerpc/platforms/85xx/ksi8560.c b/arch/powerpc/platforms/85xx/ksi8560.c
index d49dbc4..278962b 100644
--- a/arch/powerpc/platforms/85xx/ksi8560.c
+++ b/arch/powerpc/platforms/85xx/ksi8560.c
@@ -74,7 +74,7 @@ static void __init ksi8560_pic_init(void)
 #endif
 
 	mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index 2c928f0..d1aece5 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -35,7 +35,7 @@
 void __init mpc8536_ds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			  MPIC_PRIMARY | MPIC_WANTS_RESET |
+			  MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 2b443ba..65a3de4 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -69,8 +69,7 @@ static void __init mpc85xx_ads_pic_init(void)
 	int irq;
 #endif
 
-	mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 3a2436b..081821d 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -188,7 +188,7 @@ static void __init mpc85xx_cds_pic_init(void)
 {
 	struct mpic *mpic;
 	mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 14fccaf..5298137 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -70,13 +70,12 @@ void __init mpc85xx_ds_pic_init(void)
 
 	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
 		mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(NULL, 0,
-			  MPIC_PRIMARY | MPIC_WANTS_RESET |
+			  MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			  MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 7ebd864..b7d9636 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -475,7 +475,7 @@ machine_arch_initcall(p1021_mds, swiotlb_setup_bus_notifier);
 static void __init mpc85xx_mds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
 			MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index 9edb2b1..a3cf5d1 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -47,13 +47,12 @@ void __init mpc85xx_rdb_pic_init(void)
 
 	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
 		mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(NULL, 0,
-		  MPIC_PRIMARY | MPIC_WANTS_RESET |
+		  MPIC_WANTS_RESET |
 		  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 		  MPIC_SINGLE_DEST_CPU,
 		  0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/p1010rdb.c b/arch/powerpc/platforms/85xx/p1010rdb.c
index 5ffca27..f6c3ffc 100644
--- a/arch/powerpc/platforms/85xx/p1010rdb.c
+++ b/arch/powerpc/platforms/85xx/p1010rdb.c
@@ -39,7 +39,7 @@ void __init p1010_rdb_pic_init(void)
 		return;
 	}
 
-	mpic = mpic_alloc(np, NULL, MPIC_PRIMARY | MPIC_WANTS_RESET |
+	mpic = mpic_alloc(np, NULL, MPIC_WANTS_RESET |
 	  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 	  0, 256, " OpenPIC  ");
 
diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index 4279e83..73e79ba 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -239,7 +239,7 @@ int p1022ds_set_sysfs_monitor_port(int val)
 void __init p1022_ds_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-		MPIC_PRIMARY | MPIC_WANTS_RESET |
+		MPIC_WANTS_RESET |
 		MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 		MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index 30a5adb..1a916eb 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -118,7 +118,7 @@ static void __init mpc85xx_rds_pic_init(void)
 	}
 
 	mpic = mpic_alloc(np, NULL,
-		MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
+		MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
 		MPIC_BROKEN_FRR_NIRQS | MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
 
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index 1b5597f..bf8b8ff 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -54,7 +54,7 @@ static int sbc_rev;
 static void __init sbc8548_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index 20e68bb..7a43fb4 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -60,7 +60,7 @@ static void __init sbc8560_pic_init(void)
 #endif
 
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/socrates.c b/arch/powerpc/platforms/85xx/socrates.c
index a9a45f6..94bd256 100644
--- a/arch/powerpc/platforms/85xx/socrates.c
+++ b/arch/powerpc/platforms/85xx/socrates.c
@@ -48,7 +48,7 @@ static void __init socrates_pic_init(void)
 	struct device_node *np;
 
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index 55e941b..e0c88b3 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -64,7 +64,7 @@ static void __init stx_gp3_pic_init(void)
 #endif
 
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index 660769b..2f6479a 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -62,7 +62,7 @@ static void __init tqm85xx_pic_init(void)
 #endif
 
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 09b8ba0..d95e765 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -42,7 +42,7 @@
 void __init xes_mpc85xx_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(np, 0,
-			  MPIC_PRIMARY | MPIC_WANTS_RESET |
+			  MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index f85c8f0..78e50c9 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -44,7 +44,7 @@ void __init mpc86xx_init_irq(void)
 		return;
 
 	mpic = mpic_alloc(np, 0,
-			MPIC_PRIMARY | MPIC_WANTS_RESET |
+			MPIC_WANTS_RESET |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " MPIC     ");
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index c73cf4c..392cbdb 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -210,7 +210,7 @@ static void __init mpic_init_IRQ(void)
 		/* The MPIC driver will get everything it needs from the
 		 * device-tree, just pass 0 to all arguments
 		 */
-		mpic = mpic_alloc(dn, 0, 0, 0, 0, " MPIC     ");
+		mpic = mpic_alloc(dn, 0, MPIC_SECONDARY, 0, 0, " MPIC     ");
 		if (mpic == NULL)
 			continue;
 		mpic_init(mpic);
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 1227864..f1f17bb 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -435,8 +435,7 @@ static void __init chrp_find_openpic(void)
 	if (len > 1)
 		isu_size = iranges[3];
 
-	chrp_mpic = mpic_alloc(np, opaddr, MPIC_PRIMARY,
-			       isu_size, 0, " MPIC    ");
+	chrp_mpic = mpic_alloc(np, opaddr, 0, isu_size, 0, " MPIC    ");
 	if (chrp_mpic == NULL) {
 		printk(KERN_ERR "Failed to allocate MPIC structure\n");
 		goto bail;
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index edfc84f..e8c1429 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -154,7 +154,7 @@ static void __init holly_init_IRQ(void)
 #endif
 
 	mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
+			MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24,
 			NR_IRQS-4, /* num_sources used */
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 502ff60..bcfad92 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -82,7 +82,7 @@ static void __init linkstation_init_IRQ(void)
 {
 	struct mpic *mpic;
 
-	mpic = mpic_alloc(NULL, 0, MPIC_PRIMARY | MPIC_WANTS_RESET,
+	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET,
 			4, 32, " EPIC     ");
 	BUG_ON(mpic == NULL);
 
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index 1dd976e..32376b5 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -108,7 +108,7 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 #endif
 
 	mpic = mpic_alloc(NULL, 0,
-			MPIC_PRIMARY | MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
+			MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24,
 			NR_IRQS-4, /* num_sources used */
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index a233d91..6b3fffe 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -84,7 +84,7 @@ static void __init storcenter_init_IRQ(void)
 {
 	struct mpic *mpic;
 
-	mpic = mpic_alloc(NULL, 0, MPIC_PRIMARY | MPIC_WANTS_RESET,
+	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET,
 			16, 32, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 5b3388b..a14ac90 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -220,7 +220,7 @@ static void __init maple_init_IRQ(void)
 	unsigned long openpic_addr = 0;
 	int naddr, n, i, opplen, has_isus = 0;
 	struct mpic *mpic;
-	unsigned int flags = MPIC_PRIMARY;
+	unsigned int flags = 0;
 
 	/* Locate MPIC in the device-tree. Note that there is a bug
 	 * in Maple device-tree where the type of the controller is
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 883757e..851bdab 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -223,7 +223,7 @@ static __init void pas_init_IRQ(void)
 	openpic_addr = of_read_number(opprop, naddr);
 	printk(KERN_DEBUG "OpenPIC addr: %lx\n", openpic_addr);
 
-	mpic_flags = MPIC_PRIMARY | MPIC_LARGE_VECTORS | MPIC_NO_BIAS;
+	mpic_flags = MPIC_LARGE_VECTORS | MPIC_NO_BIAS;
 
 	nmiprop = of_get_property(mpic_node, "nmi-source", NULL);
 	if (nmiprop)
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index fe360f7c..f4dc247 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -501,7 +501,7 @@ static struct mpic * __init pmac_setup_one_mpic(struct device_node *np,
 {
 	const char *name = master ? " MPIC 1   " : " MPIC 2   ";
 	struct mpic *mpic;
-	unsigned int flags = master ? MPIC_PRIMARY : 0;
+	unsigned int flags = master ? 0 : MPIC_SECONDARY;
 	int rc;
 
 	pmac_call_feature(PMAC_FTR_ENABLE_MPIC, np, 0, 0);
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 0969fd9..172980c 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -192,8 +192,7 @@ static void __init pseries_mpic_init_IRQ(void)
 	BUG_ON(openpic_addr == 0);
 
 	/* Setup the openpic driver */
-	mpic = mpic_alloc(pSeries_mpic_node, openpic_addr,
-			  MPIC_PRIMARY,
+	mpic = mpic_alloc(pSeries_mpic_node, openpic_addr, 0,
 			  16, 250, /* isu size, irq count */
 			  " MPIC     ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 548ca16..31a9ada 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -154,7 +154,7 @@ static inline unsigned int mpic_processor_id(struct mpic *mpic)
 {
 	unsigned int cpu = 0;
 
-	if (mpic->flags & MPIC_PRIMARY)
+	if (!(mpic->flags & MPIC_SECONDARY))
 		cpu = hard_smp_processor_id();
 
 	return cpu;
@@ -992,7 +992,7 @@ static int mpic_host_map(struct irq_host *h, unsigned int virq,
 
 #ifdef CONFIG_SMP
 	else if (hw >= mpic->ipi_vecs[0]) {
-		WARN_ON(!(mpic->flags & MPIC_PRIMARY));
+		WARN_ON(mpic->flags & MPIC_SECONDARY);
 
 		DBG("mpic: mapping as IPI\n");
 		irq_set_chip_data(virq, mpic);
@@ -1003,7 +1003,7 @@ static int mpic_host_map(struct irq_host *h, unsigned int virq,
 #endif /* CONFIG_SMP */
 
 	if (hw >= mpic->timer_vecs[0] && hw <= mpic->timer_vecs[7]) {
-		WARN_ON(!(mpic->flags & MPIC_PRIMARY));
+		WARN_ON(mpic->flags & MPIC_SECONDARY);
 
 		DBG("mpic: mapping as timer\n");
 		irq_set_chip_data(virq, mpic);
@@ -1190,12 +1190,12 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 
 	mpic->hc_irq = mpic_irq_chip;
 	mpic->hc_irq.name = name;
-	if (flags & MPIC_PRIMARY)
+	if (!(flags & MPIC_SECONDARY))
 		mpic->hc_irq.irq_set_affinity = mpic_set_affinity;
 #ifdef CONFIG_MPIC_U3_HT_IRQS
 	mpic->hc_ht_irq = mpic_irq_ht_chip;
 	mpic->hc_ht_irq.name = name;
-	if (flags & MPIC_PRIMARY)
+	if (!(flags & MPIC_SECONDARY))
 		mpic->hc_ht_irq.irq_set_affinity = mpic_set_affinity;
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
@@ -1361,7 +1361,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->next = mpics;
 	mpics = mpic;
 
-	if (flags & MPIC_PRIMARY) {
+	if (!(flags & MPIC_SECONDARY)) {
 		mpic_primary = mpic;
 		irq_set_default_host(mpic->irqhost);
 	}
@@ -1431,7 +1431,7 @@ void __init mpic_init(struct mpic *mpic)
 
 	/* Do the HT PIC fixups on U3 broken mpic */
 	DBG("MPIC flags: %x\n", mpic->flags);
-	if ((mpic->flags & MPIC_U3_HT_IRQS) && (mpic->flags & MPIC_PRIMARY)) {
+	if ((mpic->flags & MPIC_U3_HT_IRQS) && !(mpic->flags & MPIC_SECONDARY)) {
 		mpic_scan_ht_pics(mpic);
 		mpic_u3msi_init(mpic);
 	}
-- 
1.7.2.5

