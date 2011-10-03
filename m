Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1JCAeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 20:34:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38118 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1JCAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 20:33:58 -0400
From: "Thiago A. Correa" <thiago.correa@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Thiago A. Correa" <thiago.correa@gmail.com>
Subject: [PATCH 1/1] ARM: Make debug UART optional for S3C devices
Date: Sun,  2 Oct 2011 20:32:48 -0400
Message-Id: <1317601968-9194-1-git-send-email-thiago.correa@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes serial debug messages optional on
Samsung SoC s3c devices making all UART ports available
for other uses.

Signed-off-by: Thiago A. Correa <thiago.correa@gmail.com>
---
 arch/arm/boot/compressed/head.S                 |    2 +-
 arch/arm/plat-samsung/Kconfig                   |   11 +++++++++++
 arch/arm/plat-samsung/include/plat/uncompress.h |    9 +++++++++
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9f5ac11..3afb755 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -58,7 +58,7 @@
 		add	\rb, \rb, #0x00010000	@ Ser1
 #endif
 		.endm
-#elif defined(CONFIG_ARCH_S3C2410)
+#elif defined(CONFIG_ARCH_S3C2410) && CONFIG_ENABLE_DEBUG_S3C_UART
 		.macro loadsp, rb, tmp
 		mov	\rb, #0x50000000
 		add	\rb, \rb, #0x4000 * CONFIG_S3C_LOWLEVEL_UART_PORT
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index b3e1065..c2183f0 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -33,7 +33,17 @@ config S3C_BOOT_ERROR_RESET
 	  Say y here to use the watchdog to reset the system if the
 	  kernel decompressor detects an error during decompression.
 
+
+config ENABLE_DEBUG_S3C_UART
+	bool "Enable S3C Debug UART"
+	help
+	  Say Y here if you want debug print of low level kernel messages
+	  using S3C UARTS.
+
+	  If in doubt, say N.
+
 config S3C_BOOT_UART_FORCE_FIFO
+       depends on ENABLE_DEBUG_S3C_UART
        bool "Force UART FIFO on during boot process"
        default y
        help
@@ -42,6 +52,7 @@ config S3C_BOOT_UART_FORCE_FIFO
 
 
 config S3C_LOWLEVEL_UART_PORT
+	depends on ENABLE_DEBUG_S3C_UART
 	int "S3C UART to use for low-level messages"
 	default 0
 	help
diff --git a/arch/arm/plat-samsung/include/plat/uncompress.h b/arch/arm/plat-samsung/include/plat/uncompress.h
index ee48e12..778c2df 100644
--- a/arch/arm/plat-samsung/include/plat/uncompress.h
+++ b/arch/arm/plat-samsung/include/plat/uncompress.h
@@ -37,6 +37,7 @@ static void arch_detect_cpu(void);
 /* how many bytes we allow into the FIFO at a time in FIFO mode */
 #define FIFO_MAX	 (14)
 
+#if defined(CONFIG_ENABLE_DEBUG_S3C_UART)
 #define uart_base S3C_PA_UART + (S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT)
 
 static __inline__ void
@@ -85,11 +86,19 @@ static void putc(int ch)
 	/* write byte to transmission register */
 	uart_wr(S3C2410_UTXH, ch);
 }
+#else
+static inline void putc(int ch)
+{
+}
+
+
+#endif
 
 static inline void flush(void)
 {
 }
 
+
 #define __raw_writel(d, ad)			\
 	do {							\
 		*((volatile unsigned int __force *)(ad)) = (d); \
-- 
1.7.3.4

