Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KGQ15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:27:57 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:57548 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2KGQ1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:27:55 -0500
X-Greylist: delayed 86235 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2012 11:27:54 EST
From: Nicolas Royer <nicolas@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, plagnioj@jcrosoft.com, eric@eukrea.com,
        Nicolas Royer <nicolas@eukrea.com>
Subject: [PATCH 2/5 v2] ARM: AT91SAM9G45: same platform data structure for all crypto peripherals
Date: Wed,  7 Nov 2012 17:27:55 +0100
Message-Id: <1352305675-21961-1-git-send-email-nicolas@eukrea.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <20121107152615.GD4576@game.jcrosoft.org>
References: <20121107152615.GD4576@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only AES use DMA in AT91SAM9G45 (TDES and SHA use PDC).

However latest Atmel TDES and SHA IP releases use DMA instead of PDC.
  --> Atmel TDES and SHA drivers need DMA platform data for those IP releases.

Goal of this patch is to use the same platform data structure for all Atmel
crypto peripherals. This structure contains information about DMA interface.

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric Bénard <eric@eukrea.com>
Tested-by: Eric Bénard <eric@eukrea.com>
---
v2 : check kzalloc return value.

 arch/arm/mach-at91/at91sam9g45_devices.c   |   10 ++++++----
 include/linux/platform_data/atmel-aes.h    |   22 ----------------------
 include/linux/platform_data/crypto-atmel.h |   22 ++++++++++++++++++++++
 3 files changed, 28 insertions(+), 26 deletions(-)
 delete mode 100644 include/linux/platform_data/atmel-aes.h
 create mode 100644 include/linux/platform_data/crypto-atmel.h

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index fcd233c..c1631d1 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
 #include <linux/atmel-mci.h>
-#include <linux/platform_data/atmel-aes.h>
+#include <linux/platform_data/crypto-atmel.h>
 
 #include <linux/platform_data/at91_adc.h>
 
@@ -1900,7 +1900,7 @@ static void __init at91_add_device_tdes(void) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_ATMEL_AES_MODULE)
-static struct aes_platform_data aes_data;
+static struct crypto_platform_data aes_data;
 static u64 aes_dmamask = DMA_BIT_MASK(32);
 
 static struct resource aes_resources[] = {
@@ -1931,9 +1931,11 @@ static struct platform_device at91sam9g45_aes_device = {
 static void __init at91_add_device_aes(void)
 {
 	struct at_dma_slave	*atslave;
-	struct aes_dma_data	*alt_atslave;
+	struct crypto_dma_data	*alt_atslave;
 
-	alt_atslave = kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
+	alt_atslave = kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
+	if (!alt_atslave)
+		panic("Unable to allocate memory for AES crypto_dma_data structure\n");
 
 	/* DMA TX slave channel configuration */
 	atslave = &alt_atslave->txdata;
diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/platform_data/atmel-aes.h
deleted file mode 100644
index ab68082..0000000
--- a/include/linux/platform_data/atmel-aes.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __LINUX_ATMEL_AES_H
-#define __LINUX_ATMEL_AES_H
-
-#include <linux/platform_data/dma-atmel.h>
-
-/**
- * struct aes_dma_data - DMA data for AES
- */
-struct aes_dma_data {
-	struct at_dma_slave	txdata;
-	struct at_dma_slave	rxdata;
-};
-
-/**
- * struct aes_platform_data - board-specific AES configuration
- * @dma_slave: DMA slave interface to use in data transfers.
- */
-struct aes_platform_data {
-	struct aes_dma_data	*dma_slave;
-};
-
-#endif /* __LINUX_ATMEL_AES_H */
diff --git a/include/linux/platform_data/crypto-atmel.h b/include/linux/platform_data/crypto-atmel.h
new file mode 100644
index 0000000..b46e0d9
--- /dev/null
+++ b/include/linux/platform_data/crypto-atmel.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_CRYPTO_ATMEL_H
+#define __LINUX_CRYPTO_ATMEL_H
+
+#include <linux/platform_data/dma-atmel.h>
+
+/**
+ * struct crypto_dma_data - DMA data for AES/TDES/SHA
+ */
+struct crypto_dma_data {
+	struct at_dma_slave	txdata;
+	struct at_dma_slave	rxdata;
+};
+
+/**
+ * struct crypto_platform_data - board-specific AES/TDES/SHA configuration
+ * @dma_slave: DMA slave interface to use in data transfers.
+ */
+struct crypto_platform_data {
+	struct crypto_dma_data	*dma_slave;
+};
+
+#endif /* __LINUX_CRYPTO_ATMEL_H */
-- 
1.7.6.5

