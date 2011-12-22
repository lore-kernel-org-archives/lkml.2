Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1LVUVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:21:14 -0500
Received: from border.exmeritus.com ([70.167.241.26]:33016 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1LVUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:21:11 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Scott Wood <scottwood@freescale.com>,
        Timur Tabi <timur@freescale.com>,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>,
        Anton Blanchard <anton@samba.org>, Milton Miller <miltonm@bga.com>,
        linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 6/6] powerpc/mpic: Remove duplicate MPIC_WANTS_RESET flag
Date: Thu, 22 Dec 2011 15:19:14 -0500
Message-Id: <1324585155-13453-7-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two separate flags controlling whether or not the MPIC is
reset during initialization, which is completely unnecessary, and only
one of them can be specified in the device tree.

Also, most platforms in-tree right now do actually want to reset the
MPIC during initialization anyways, which means lots of duplicate code
passing the MPIC_WANTS_RESET flag.

Fix all of the callers which currently do not pass the MPIC_WANTS_RESET
flag to pass the MPIC_NO_RESET flag, then remove the MPIC_WANTS_RESET
flag and make the code reset the MPIC by default.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/mpic.h                   |    6 +-----
 arch/powerpc/platforms/44x/currituck.c            |    2 +-
 arch/powerpc/platforms/44x/iss4xx.c               |    3 +--
 arch/powerpc/platforms/85xx/corenet_ds.c          |    3 ++-
 arch/powerpc/platforms/85xx/ksi8560.c             |    3 +--
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |    4 +---
 arch/powerpc/platforms/85xx/mpc85xx_ads.c         |    3 +--
 arch/powerpc/platforms/85xx/mpc85xx_cds.c         |    3 +--
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |    3 +--
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c         |    3 +--
 arch/powerpc/platforms/85xx/p1010rdb.c            |    3 +--
 arch/powerpc/platforms/85xx/p1022_ds.c            |    4 +---
 arch/powerpc/platforms/85xx/p1023_rds.c           |    3 +--
 arch/powerpc/platforms/85xx/sbc8548.c             |    3 +--
 arch/powerpc/platforms/85xx/sbc8560.c             |    3 +--
 arch/powerpc/platforms/85xx/socrates.c            |    3 +--
 arch/powerpc/platforms/85xx/stx_gp3.c             |    3 +--
 arch/powerpc/platforms/85xx/tqm85xx.c             |    2 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c         |    4 +---
 arch/powerpc/platforms/86xx/pic.c                 |    3 +--
 arch/powerpc/platforms/cell/setup.c               |    3 ++-
 arch/powerpc/platforms/chrp/setup.c               |    3 ++-
 arch/powerpc/platforms/embedded6xx/holly.c        |    3 +--
 arch/powerpc/platforms/embedded6xx/linkstation.c  |    3 +--
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |    3 +--
 arch/powerpc/platforms/embedded6xx/storcenter.c   |    3 +--
 arch/powerpc/platforms/maple/setup.c              |    2 +-
 arch/powerpc/platforms/pasemi/setup.c             |    2 +-
 arch/powerpc/platforms/powermac/pic.c             |    1 -
 arch/powerpc/platforms/pseries/setup.c            |    3 ++-
 arch/powerpc/sysdev/mpic.c                        |    2 +-
 32 files changed, 35 insertions(+), 59 deletions(-)

diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 2ebac31..d7e3fec 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -348,8 +348,6 @@ struct mpic
 #define MPIC_U3_HT_IRQS			0x00000004
 /* Broken IPI registers (autodetected) */
 #define MPIC_BROKEN_IPI			0x00000008
-/* MPIC wants a reset */
-#define MPIC_WANTS_RESET		0x00000010
 /* Spurious vector requires EOI */
 #define MPIC_SPV_EOI			0x00000020
 /* No passthrough disable */
@@ -366,9 +364,7 @@ struct mpic
 #define MPIC_SINGLE_DEST_CPU		0x00001000
 /* Enable CoreInt delivery of interrupts */
 #define MPIC_ENABLE_COREINT		0x00002000
-/* Disable resetting of the MPIC.
- * NOTE: This flag trumps MPIC_WANTS_RESET.
- */
+/* Do not reset the MPIC during initialization */
 #define MPIC_NO_RESET			0x00004000
 /* Freescale MPIC (compatible includes "fsl,mpic") */
 #define MPIC_FSL			0x00008000
diff --git a/arch/powerpc/platforms/44x/currituck.c b/arch/powerpc/platforms/44x/currituck.c
index 3f6229b..583e67f 100644
--- a/arch/powerpc/platforms/44x/currituck.c
+++ b/arch/powerpc/platforms/44x/currituck.c
@@ -83,7 +83,7 @@ static void __init ppc47x_init_irq(void)
 		 * device-tree, just pass 0 to all arguments
 		 */
 		struct mpic *mpic =
-			mpic_alloc(np, 0, 0, 0, 0, " MPIC     ");
+			mpic_alloc(np, 0, MPIC_NO_RESET, 0, 0, " MPIC     ");
 		BUG_ON(mpic == NULL);
 		mpic_init(mpic);
 		ppc_md.get_irq = mpic_get_irq;
diff --git a/arch/powerpc/platforms/44x/iss4xx.c b/arch/powerpc/platforms/44x/iss4xx.c
index 5b8cdbb..a28a862 100644
--- a/arch/powerpc/platforms/44x/iss4xx.c
+++ b/arch/powerpc/platforms/44x/iss4xx.c
@@ -71,8 +71,7 @@ static void __init iss4xx_init_irq(void)
 		/* The MPIC driver will get everything it needs from the
 		 * device-tree, just pass 0 to all arguments
 		 */
-		struct mpic *mpic = mpic_alloc(np, 0, 0, 0, 0,
-					       " MPIC     ");
+		struct mpic *mpic = mpic_alloc(np, 0, MPIC_NO_RESET, 0, 0, " MPIC     ");
 		BUG_ON(mpic == NULL);
 		mpic_init(mpic);
 		ppc_md.get_irq = mpic_get_irq;
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 768479b..df69e99 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -36,7 +36,8 @@
 void __init corenet_ds_pic_init(void)
 {
 	struct mpic *mpic;
-	unsigned int flags = MPIC_BIG_ENDIAN | MPIC_SINGLE_DEST_CPU;
+	unsigned int flags = MPIC_BIG_ENDIAN | MPIC_SINGLE_DEST_CPU |
+		MPIC_NO_RESET;
 
 	if (ppc_md.get_irq == mpic_get_coreint_irq)
 		flags |= MPIC_ENABLE_COREINT;
diff --git a/arch/powerpc/platforms/85xx/ksi8560.c b/arch/powerpc/platforms/85xx/ksi8560.c
index 20f75d7..60120e5 100644
--- a/arch/powerpc/platforms/85xx/ksi8560.c
+++ b/arch/powerpc/platforms/85xx/ksi8560.c
@@ -57,8 +57,7 @@ static void machine_restart(char *cmd)
 
 static void __init ksi8560_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index d5373e0..f588726 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -36,9 +36,7 @@
 
 void __init mpc8536_ds_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			  MPIC_WANTS_RESET |
-			  MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 3bebb51..d19f675 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -50,8 +50,7 @@ static int mpc85xx_exclude_device(struct pci_controller *hose,
 
 static void __init mpc85xx_ads_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 40f03da..02d97e3 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -188,8 +188,7 @@ static struct irqaction mpc85xxcds_8259_irqaction = {
 static void __init mpc85xx_cds_pic_init(void)
 {
 	struct mpic *mpic;
-	mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 528b9a0..6e23e3e 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -72,12 +72,12 @@ void __init mpc85xx_ds_pic_init(void)
 
 	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
 		mpic = mpic_alloc(NULL, 0,
+			MPIC_NO_RESET |
 			MPIC_BIG_ENDIAN |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(NULL, 0,
-			  MPIC_WANTS_RESET |
 			  MPIC_BIG_ENDIAN |
 			  MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index a0cb770..57aceb5 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -434,8 +434,7 @@ machine_arch_initcall(p1021_mds, swiotlb_setup_bus_notifier);
 
 static void __init mpc85xx_mds_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index a23f6f3..407c739 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -48,13 +48,12 @@ void __init mpc85xx_rdb_pic_init(void)
 	unsigned long root = of_get_flat_dt_root();
 
 	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
-		mpic = mpic_alloc(NULL, 0,
+		mpic = mpic_alloc(NULL, 0, MPIC_NO_RESET |
 			MPIC_BIG_ENDIAN |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	} else {
 		mpic = mpic_alloc(NULL, 0,
-		  MPIC_WANTS_RESET |
 		  MPIC_BIG_ENDIAN |
 		  MPIC_SINGLE_DEST_CPU,
 		  0, 256, " OpenPIC  ");
diff --git a/arch/powerpc/platforms/85xx/p1010rdb.c b/arch/powerpc/platforms/85xx/p1010rdb.c
index d2a569d..0223128 100644
--- a/arch/powerpc/platforms/85xx/p1010rdb.c
+++ b/arch/powerpc/platforms/85xx/p1010rdb.c
@@ -32,8 +32,7 @@
 
 void __init p1010_rdb_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-	  MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 	  MPIC_SINGLE_DEST_CPU,
 	  0, 256, " OpenPIC  ");
 
diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
index 433546e..48b59fc 100644
--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -241,9 +241,7 @@ p1022ds_valid_monitor_port(enum fsl_diu_monitor_port port)
 
 void __init p1022_ds_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-		MPIC_WANTS_RESET |
-		MPIC_BIG_ENDIAN |
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 		MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index 88541dc..5935abf 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -93,8 +93,7 @@ machine_device_initcall(p1023_rds, mpc85xx_common_publish_devices);
 
 static void __init mpc85xx_rds_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-		MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 		MPIC_SINGLE_DEST_CPU,
 		0, 256, " OpenPIC  ");
 
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index 184a507..1677b8a 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -54,8 +54,7 @@ static int sbc_rev;
 
 static void __init sbc8548_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index 940752e..3c3bbcc 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -41,8 +41,7 @@
 
 static void __init sbc8560_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/socrates.c b/arch/powerpc/platforms/85xx/socrates.c
index 18f6359..b719192 100644
--- a/arch/powerpc/platforms/85xx/socrates.c
+++ b/arch/powerpc/platforms/85xx/socrates.c
@@ -48,8 +48,7 @@ static void __init socrates_pic_init(void)
 {
 	struct device_node *np;
 
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index e9e5234..27ca3a7 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -48,8 +48,7 @@
 
 static void __init stx_gp3_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index bf7c89f..d7504ce 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -47,7 +47,7 @@
 static void __init tqm85xx_pic_init(void)
 {
 	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN,
+			MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 1ab4e02..503c215 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -43,9 +43,7 @@
 
 void __init xes_mpc85xx_pic_init(void)
 {
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			  MPIC_WANTS_RESET |
-			  MPIC_BIG_ENDIAN,
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	mpic_init(mpic);
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 27959d6..22cc357 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -37,8 +37,7 @@ void __init mpc86xx_init_irq(void)
 	int cascade_irq;
 #endif
 
-	struct mpic *mpic = mpic_alloc(NULL, 0,
-			MPIC_WANTS_RESET | MPIC_BIG_ENDIAN |
+	struct mpic *mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 			MPIC_SINGLE_DEST_CPU,
 			0, 256, " MPIC     ");
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index 62002a7..fa3e294 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -197,7 +197,8 @@ static void __init mpic_init_IRQ(void)
 		/* The MPIC driver will get everything it needs from the
 		 * device-tree, just pass 0 to all arguments
 		 */
-		mpic = mpic_alloc(dn, 0, MPIC_SECONDARY, 0, 0, " MPIC     ");
+		mpic = mpic_alloc(dn, 0, MPIC_SECONDARY | MPIC_NO_RESET,
+				0, 0, " MPIC     ");
 		if (mpic == NULL)
 			continue;
 		mpic_init(mpic);
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index f1f17bb..c665d7d 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -435,7 +435,8 @@ static void __init chrp_find_openpic(void)
 	if (len > 1)
 		isu_size = iranges[3];
 
-	chrp_mpic = mpic_alloc(np, opaddr, 0, isu_size, 0, " MPIC    ");
+	chrp_mpic = mpic_alloc(np, opaddr, MPIC_NO_RESET,
+			isu_size, 0, " MPIC    ");
 	if (chrp_mpic == NULL) {
 		printk(KERN_ERR "Failed to allocate MPIC structure\n");
 		goto bail;
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index d7727de..ab51b21 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -154,8 +154,7 @@ static void __init holly_init_IRQ(void)
 	struct device_node *cascade_node = NULL;
 #endif
 
-	mpic = mpic_alloc(NULL, 0,
-			MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
+	mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24, 0,
 			"Tsi108_PIC");
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 9479f4e..455e7c08 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -82,8 +82,7 @@ static void __init linkstation_init_IRQ(void)
 {
 	struct mpic *mpic;
 
-	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET,
-			4, 0, " EPIC     ");
+	mpic = mpic_alloc(NULL, 0, 0, 4, 0, " EPIC     ");
 	BUG_ON(mpic == NULL);
 
 	/* PCI IRQs */
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index 90acb54..74ccce3 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -108,8 +108,7 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 	struct device_node *cascade_node = NULL;
 #endif
 
-	mpic = mpic_alloc(NULL, 0,
-			MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
+	mpic = mpic_alloc(NULL, 0, MPIC_BIG_ENDIAN |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24, 0,
 			"Tsi108_PIC");
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index 451dce4..e0ed3c7 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -84,8 +84,7 @@ static void __init storcenter_init_IRQ(void)
 {
 	struct mpic *mpic;
 
-	mpic = mpic_alloc(NULL, 0, MPIC_WANTS_RESET,
-			16, 0, " OpenPIC  ");
+	mpic = mpic_alloc(NULL, 0, 0, 16, 0, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 
 	/*
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 0bcbfe7..3b7545a 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -262,7 +262,7 @@ static void __init maple_init_IRQ(void)
 		flags |= MPIC_BIG_ENDIAN;
 
 	/* XXX Maple specific bits */
-	flags |= MPIC_U3_HT_IRQS | MPIC_WANTS_RESET;
+	flags |= MPIC_U3_HT_IRQS;
 	/* All U3/U4 are big-endian, older SLOF firmware doesn't encode this */
 	flags |= MPIC_BIG_ENDIAN;
 
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 98b7a7c..e777ad4 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -224,7 +224,7 @@ static __init void pas_init_IRQ(void)
 	openpic_addr = of_read_number(opprop, naddr);
 	printk(KERN_DEBUG "OpenPIC addr: %lx\n", openpic_addr);
 
-	mpic_flags = MPIC_LARGE_VECTORS | MPIC_NO_BIAS;
+	mpic_flags = MPIC_LARGE_VECTORS | MPIC_NO_BIAS | MPIC_NO_RESET;
 
 	nmiprop = of_get_property(mpic_node, "nmi-source", NULL);
 	if (nmiprop)
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 7761aab..0293d7a 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -469,7 +469,6 @@ static struct mpic * __init pmac_setup_one_mpic(struct device_node *np,
 
 	pmac_call_feature(PMAC_FTR_ENABLE_MPIC, np, 0, 0);
 
-	flags |= MPIC_WANTS_RESET;
 	if (of_get_property(np, "big-endian", NULL))
 		flags |= MPIC_BIG_ENDIAN;
 
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 6d0a5df..d928412 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -190,7 +190,8 @@ static void __init pseries_mpic_init_IRQ(void)
 	BUG_ON(openpic_addr == 0);
 
 	/* Setup the openpic driver */
-	mpic = mpic_alloc(pSeries_mpic_node, openpic_addr, 0, 16, 0, " MPIC     ");
+	mpic = mpic_alloc(pSeries_mpic_node, openpic_addr,
+			MPIC_NO_RESET, 16, 0, " MPIC     ");
 	BUG_ON(mpic == NULL);
 
 	/* Add ISUs */
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 90171d4..b9b989d 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1286,7 +1286,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	/* When using a device-node, reset requests are only honored if the MPIC
 	 * is allowed to reset.
 	 */
-	if ((mpic->flags & MPIC_WANTS_RESET) && !(mpic->flags & MPIC_NO_RESET)) {
+	if (!(mpic->flags & MPIC_NO_RESET)) {
 		printk(KERN_DEBUG "mpic: Resetting\n");
 		mpic_write(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0),
 			   mpic_read(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0))
-- 
1.7.7.3

