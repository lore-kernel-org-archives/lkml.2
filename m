Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1KIQcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:32:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52354 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1KIQcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:32:03 -0500
Message-ID: <4EBAAAEF.4000504@gmail.com>
Date: Thu, 10 Nov 2011 00:31:43 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCHJ] ARM: NUC900: add new MFP implement
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add new MFP implement in mfp.c,since nuc900 mmc driver
needs this function support, thanks!

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/include/mach/mfp.h        |    3 +-
 arch/arm/mach-w90x900/include/mach/nuc900_spi.h |    2 +-
 arch/arm/mach-w90x900/mfp.c                     |   49
++++++++++++++++++++---
 3 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-w90x900/include/mach/mfp.h
b/arch/arm/mach-w90x900/include/mach/mfp.h
index 94c0e71..23ef1f5 100644
--- a/arch/arm/mach-w90x900/include/mach/mfp.h
+++ b/arch/arm/mach-w90x900/include/mach/mfp.h
@@ -19,6 +19,7 @@
 extern void mfp_set_groupf(struct device *dev);
 extern void mfp_set_groupc(struct device *dev);
 extern void mfp_set_groupi(struct device *dev);
-extern void mfp_set_groupg(struct device *dev);
+extern void mfp_set_groupg(struct device *dev, const char *subname);
+extern void mfp_set_groupd(struct device *dev, const char *subname);

 #endif /* __ASM_ARCH_MFP_H */
diff --git a/arch/arm/mach-w90x900/include/mach/nuc900_spi.h
b/arch/arm/mach-w90x900/include/mach/nuc900_spi.h
index bd94819..2c4e0c1 100644
--- a/arch/arm/mach-w90x900/include/mach/nuc900_spi.h
+++ b/arch/arm/mach-w90x900/include/mach/nuc900_spi.h
@@ -14,7 +14,7 @@
 #ifndef __ASM_ARCH_SPI_H
 #define __ASM_ARCH_SPI_H

-extern void mfp_set_groupg(struct device *dev);
+extern void mfp_set_groupg(struct device *dev, const char *subname);

 struct nuc900_spi_info {
 	unsigned int num_cs;
diff --git a/arch/arm/mach-w90x900/mfp.c b/arch/arm/mach-w90x900/mfp.c
index fb7fb62..435aa8b 100644
--- a/arch/arm/mach-w90x900/mfp.c
+++ b/arch/arm/mach-w90x900/mfp.c
@@ -26,10 +26,8 @@
 #define REG_MFSEL	(W90X900_VA_GCR + 0xC)

 #define GPSELF		(0x01 << 1)
-
 #define GPSELC		(0x03 << 2)
-#define ENKPI		(0x02 << 2)
-#define ENNAND		(0x01 << 2)
+#define GPSELD		(0x0f << 4)

 #define GPSELEI0	(0x01 << 26)
 #define GPSELEI1	(0x01 << 27)
@@ -37,11 +35,16 @@
 #define GPIOG0TO1	(0x03 << 14)
 #define GPIOG2TO3	(0x03 << 16)
 #define GPIOG22TO23	(0x03 << 22)
+#define GPIOG18TO20	(0x07 << 18)

 #define ENSPI		(0x0a << 14)
 #define ENI2C0		(0x01 << 14)
 #define ENI2C1		(0x01 << 16)
 #define ENAC97		(0x02 << 22)
+#define ENSD1		(0x02 << 18)
+#define ENSD0		(0x0a << 4)
+#define ENKPI		(0x02 << 2)
+#define ENNAND		(0x01 << 2)

 static DEFINE_MUTEX(mfp_mutex);

@@ -127,16 +130,19 @@ void mfp_set_groupi(struct device *dev)
 }
 EXPORT_SYMBOL(mfp_set_groupi);

-void mfp_set_groupg(struct device *dev)
+void mfp_set_groupg(struct device *dev, const char *subname)
 {
 	unsigned long mfpen;
 	const char *dev_id;

-	BUG_ON(!dev);
+	BUG_ON((!dev) && (!subname));

 	mutex_lock(&mfp_mutex);

-	dev_id = dev_name(dev);
+	if (subname != NULL)
+		dev_id = subname;
+	else
+		dev_id = dev_name(dev);

 	mfpen = __raw_readl(REG_MFSEL);

@@ -152,6 +158,9 @@ void mfp_set_groupg(struct device *dev)
 	} else if (strcmp(dev_id, "nuc900-audio") == 0) {
 		mfpen &= ~(GPIOG22TO23);
 		mfpen |= ENAC97;/*enable AC97*/
+	} else if (strcmp(dev_id, "nuc900-mmc-port1") == 0) {
+		mfpen &= ~(GPIOG18TO20);
+		mfpen |= (ENSD1 | 0x01);/*enable sd1*/
 	} else {
 		mfpen &= ~(GPIOG0TO1 | GPIOG2TO3);/*GPIOG[3:0]*/
 	}
@@ -162,3 +171,31 @@ void mfp_set_groupg(struct device *dev)
 }
 EXPORT_SYMBOL(mfp_set_groupg);

+void mfp_set_groupd(struct device *dev, const char *subname)
+{
+	unsigned long mfpen;
+	const char *dev_id;
+
+	BUG_ON((!dev) && (!subname));
+
+	mutex_lock(&mfp_mutex);
+
+	if (subname != NULL)
+		dev_id = subname;
+	else
+		dev_id = dev_name(dev);
+
+	mfpen = __raw_readl(REG_MFSEL);
+
+	if (strcmp(dev_id, "nuc900-mmc-port0") == 0) {
+		mfpen &= ~GPSELD;/*enable sd0*/
+		mfpen |= ENSD0;
+	} else
+		mfpen &= (~GPSELD);
+
+	__raw_writel(mfpen, REG_MFSEL);
+
+	mutex_unlock(&mfp_mutex);
+}
+EXPORT_SYMBOL(mfp_set_groupd);
+
-- 
1.7.0.4
