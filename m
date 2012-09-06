Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2IFXox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:44:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42314 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2IFXov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:44:51 -0400
Message-ID: <5049356D.6000303@gmail.com>
Date: Fri, 07 Sep 2012 09:44:45 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
CC: Lennert Buytenhek <kernel@wantstofly.org>
Subject: [PATCH] ep93xx: Fix type error warnings in ts72xx build
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IOMEM defines for the TS72xx VIRT_BASE defines to fix type
conversion warnings.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---
diff --git a/arch/arm/mach-ep93xx/include/mach/ts72xx.h b/arch/arm/mach-ep93xx/include/mach/ts72xx.h
index f1397a1..b30deb6 100644
--- a/arch/arm/mach-ep93xx/include/mach/ts72xx.h
+++ b/arch/arm/mach-ep93xx/include/mach/ts72xx.h
@@ -2,6 +2,11 @@
  * arch/arm/mach-ep93xx/include/mach/ts72xx.h
  */
 
+#ifndef _TS72XX_H
+#define _TS72XX_H
+
+#include <asm/io.h>
+
 /*
  * TS72xx memory map:
  *
@@ -15,6 +20,7 @@
 
 #define TS72XX_MODEL_PHYS_BASE		0x22000000
 #define TS72XX_MODEL_VIRT_BASE		0xfebff000
+#define TS72XX_MODEL_VIRT_BASE_IOMEM	IOMEM(TS72XX_MODEL_VIRT_BASE)
 #define TS72XX_MODEL_SIZE		0x00001000
 
 #define TS72XX_MODEL_TS7200		0x00
@@ -27,6 +33,7 @@
 
 #define TS72XX_OPTIONS_PHYS_BASE	0x22400000
 #define TS72XX_OPTIONS_VIRT_BASE	0xfebfe000
+#define TS72XX_OPTIONS_VIRT_BASE_IOMEM	IOMEM(TS72XX_OPTIONS_VIRT_BASE)
 #define TS72XX_OPTIONS_SIZE		0x00001000
 
 #define TS72XX_OPTIONS_COM2_RS485	0x02
@@ -35,6 +42,7 @@
 
 #define TS72XX_OPTIONS2_PHYS_BASE	0x22800000
 #define TS72XX_OPTIONS2_VIRT_BASE	0xfebfd000
+#define TS72XX_OPTIONS2_VIRT_BASE_IOMEM	IOMEM(TS72XX_OPTIONS2_VIRT_BASE)
 #define TS72XX_OPTIONS2_SIZE		0x00001000
 
 #define TS72XX_OPTIONS2_TS9420		0x04
@@ -42,10 +50,12 @@
 
 
 #define TS72XX_RTC_INDEX_VIRT_BASE	0xfebf9000
+#define TS72XX_RTC_INDEX_VIRT_BASE_IOMEM IOMEM(TS72XX_RTC_INDEX_VIRT_BASE)
 #define TS72XX_RTC_INDEX_PHYS_BASE	0x10800000
 #define TS72XX_RTC_INDEX_SIZE		0x00001000
 
 #define TS72XX_RTC_DATA_VIRT_BASE	0xfebf8000
+#define TS72XX_RTC_DATA_VIRT_BASE_IOMEM	IOMEM(TS72XX_RTC_DATA_VIRT_BASE)
 #define TS72XX_RTC_DATA_PHYS_BASE	0x11700000
 #define TS72XX_RTC_DATA_SIZE		0x00001000
 
@@ -56,7 +66,7 @@
 
 static inline int ts72xx_model(void)
 {
-	return __raw_readb(TS72XX_MODEL_VIRT_BASE) & TS72XX_MODEL_MASK;
+	return __raw_readb(TS72XX_MODEL_VIRT_BASE_IOMEM) & TS72XX_MODEL_MASK;
 }
 
 static inline int board_is_ts7200(void)
@@ -86,13 +96,15 @@ static inline int board_is_ts7400(void)
 
 static inline int is_max197_installed(void)
 {
-	return !!(__raw_readb(TS72XX_OPTIONS_VIRT_BASE) &
+	return !!(__raw_readb(TS72XX_OPTIONS_VIRT_BASE_IOMEM) &
 					TS72XX_OPTIONS_MAX197);
 }
 
 static inline int is_ts9420_installed(void)
 {
-	return !!(__raw_readb(TS72XX_OPTIONS2_VIRT_BASE) &
+	return !!(__raw_readb(TS72XX_OPTIONS2_VIRT_BASE_IOMEM) &
 					TS72XX_OPTIONS2_TS9420);
 }
-#endif
+#endif /* __ASSEMBLY__ */
+
+#endif /* _TS72XX_H */
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index 75cab2d..aefda11 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -183,14 +183,14 @@ static void __init ts72xx_register_flash(void)
 
 static unsigned char ts72xx_rtc_readbyte(unsigned long addr)
 {
-	__raw_writeb(addr, TS72XX_RTC_INDEX_VIRT_BASE);
-	return __raw_readb(TS72XX_RTC_DATA_VIRT_BASE);
+	__raw_writeb(addr, TS72XX_RTC_INDEX_VIRT_BASE_IOMEM);
+	return __raw_readb(TS72XX_RTC_DATA_VIRT_BASE_IOMEM);
 }
 
 static void ts72xx_rtc_writebyte(unsigned char value, unsigned long addr)
 {
-	__raw_writeb(addr, TS72XX_RTC_INDEX_VIRT_BASE);
-	__raw_writeb(value, TS72XX_RTC_DATA_VIRT_BASE);
+	__raw_writeb(addr, TS72XX_RTC_INDEX_VIRT_BASE_IOMEM);
+	__raw_writeb(value, TS72XX_RTC_DATA_VIRT_BASE_IOMEM);
 }
 
 static struct m48t86_ops ts72xx_rtc_ops = {

