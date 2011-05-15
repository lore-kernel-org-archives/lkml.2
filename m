Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab1EOLfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:35:38 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59501 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab1EOLff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:35:35 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 12/15] [orion] Consolidate setup of the crypto engine.
Date: Sun, 15 May 2011 13:32:51 +0200
Message-Id: <1305459174-25517-13-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-kirkwood/common.c           |   30 +----------------------
 arch/arm/mach-orion5x/common.c            |   36 +++++-----------------------
 arch/arm/plat-orion/common.c              |   31 +++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |    5 ++++
 4 files changed, 45 insertions(+), 57 deletions(-)

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index e96ec4e..f3248cf 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -270,37 +270,11 @@ void __init kirkwood_uart1_init(void)
 /*****************************************************************************
  * Cryptographic Engines and Security Accelerator (CESA)
  ****************************************************************************/
-
-static struct resource kirkwood_crypto_res[] = {
-	{
-		.name   = "regs",
-		.start  = CRYPTO_PHYS_BASE,
-		.end    = CRYPTO_PHYS_BASE + 0xffff,
-		.flags  = IORESOURCE_MEM,
-	}, {
-		.name   = "sram",
-		.start  = KIRKWOOD_SRAM_PHYS_BASE,
-		.end    = KIRKWOOD_SRAM_PHYS_BASE + KIRKWOOD_SRAM_SIZE - 1,
-		.flags  = IORESOURCE_MEM,
-	}, {
-		.name   = "crypto interrupt",
-		.start  = IRQ_KIRKWOOD_CRYPTO,
-		.end    = IRQ_KIRKWOOD_CRYPTO,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_crypto_device = {
-	.name           = "mv_crypto",
-	.id             = -1,
-	.num_resources  = ARRAY_SIZE(kirkwood_crypto_res),
-	.resource       = kirkwood_crypto_res,
-};
-
 void __init kirkwood_crypto_init(void)
 {
 	kirkwood_clk_ctrl |= CGC_CRYPTO;
-	platform_device_register(&kirkwood_crypto_device);
+	orion_crypto_init(CRYPTO_PHYS_BASE, KIRKWOOD_SRAM_PHYS_BASE,
+			  KIRKWOOD_SRAM_SIZE, IRQ_KIRKWOOD_CRYPTO);
 }
 
 
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 8bbf497c..0ab531d 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -164,41 +164,19 @@ void __init orion5x_xor_init(void)
 			IRQ_ORION5X_XOR0, IRQ_ORION5X_XOR1);
 }
 
-static struct resource orion5x_crypto_res[] = {
-	{
-		.name   = "regs",
-		.start  = ORION5X_CRYPTO_PHYS_BASE,
-		.end    = ORION5X_CRYPTO_PHYS_BASE + 0xffff,
-		.flags  = IORESOURCE_MEM,
-	}, {
-		.name   = "sram",
-		.start  = ORION5X_SRAM_PHYS_BASE,
-		.end    = ORION5X_SRAM_PHYS_BASE + SZ_8K - 1,
-		.flags  = IORESOURCE_MEM,
-	}, {
-		.name   = "crypto interrupt",
-		.start  = IRQ_ORION5X_CESA,
-		.end    = IRQ_ORION5X_CESA,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_crypto_device = {
-	.name           = "mv_crypto",
-	.id             = -1,
-	.num_resources  = ARRAY_SIZE(orion5x_crypto_res),
-	.resource       = orion5x_crypto_res,
-};
-
-static int __init orion5x_crypto_init(void)
+/*****************************************************************************
+ * Cryptographic Engines and Security Accelerator (CESA)
+ ****************************************************************************/
+static void __init orion5x_crypto_init(void)
 {
 	int ret;
 
 	ret = orion5x_setup_sram_win();
 	if (ret)
-		return ret;
+		return;
 
-	return platform_device_register(&orion5x_crypto_device);
+	orion_crypto_init(ORION5X_CRYPTO_PHYS_BASE, ORION5X_SRAM_PHYS_BASE,
+			  SZ_8K, IRQ_ORION5X_CESA);
 }
 
 /*****************************************************************************
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index d1cf7c3..9e5451b 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -923,4 +923,35 @@ void __init orion_sata_init(struct mv_sata_platform_data *sata_data,
 	platform_device_register(&orion_sata);
 }
 
+/*****************************************************************************
+ * Cryptographic Engines and Security Accelerator (CESA)
+ ****************************************************************************/
+static struct resource orion_crypto_resources[] = {
+	{
+		.name   = "regs",
+	}, {
+		.name   = "crypto interrupt",
+	}, {
+		.name   = "sram",
+		.flags  = IORESOURCE_MEM,
+	},
+};
 
+static struct platform_device orion_crypto = {
+	.name           = "mv_crypto",
+	.id             = -1,
+};
+
+void __init orion_crypto_init(unsigned long mapbase,
+			      unsigned long srambase,
+			      unsigned long sram_size,
+			      unsigned long irq)
+{
+	fill_resources(&orion_crypto, orion_crypto_resources,
+		       mapbase, 0xffff, irq);
+	orion_crypto.num_resources = 3;
+	orion_crypto_resources[2].start = srambase;
+	orion_crypto_resources[2].end = srambase + sram_size - 1;
+
+	platform_device_register(&orion_crypto);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index 0ec6b66..a63c357 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -109,4 +109,9 @@ void __init orion_sata_init(struct mv_sata_platform_data *sata_data,
 			    struct mbus_dram_target_info *mbus_dram_info,
 			    unsigned long mapbase,
 			    unsigned long irq);
+
+void __init orion_crypto_init(unsigned long mapbase,
+			      unsigned long srambase,
+			      unsigned long sram_size,
+			      unsigned long irq);
 #endif
-- 
1.7.4.4

