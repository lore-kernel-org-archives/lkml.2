Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1BJGoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:44:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1BJGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:01 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, Gary King <gking@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/15] ARM: tegra: Centralize macros to define debug uart base
Date: Wed,  9 Feb 2011 22:43:10 -0800
Message-Id: <1297320204-31882-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/debug-macro.S |   25 ++++-------------------
 arch/arm/mach-tegra/include/mach/iomap.h       |   14 +++++++++++++
 arch/arm/mach-tegra/include/mach/uncompress.h  |   18 +---------------
 3 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/debug-macro.S b/arch/arm/mach-tegra/include/mach/debug-macro.S
index a0e7c12..e0ebe65 100644
--- a/arch/arm/mach-tegra/include/mach/debug-macro.S
+++ b/arch/arm/mach-tegra/include/mach/debug-macro.S
@@ -19,30 +19,15 @@
  */
 
 #include <mach/io.h>
+#include <mach/iomap.h>
 
 	.macro  addruart, rp, rv
         ldr     \rp, =IO_APB_PHYS       @ physical
         ldr     \rv, =IO_APB_VIRT        @ virtual
-#if defined(CONFIG_TEGRA_DEBUG_UART_NONE)
-#error "A debug UART must be selected in the kernel config to use DEBUG_LL"
-#elif defined(CONFIG_TEGRA_DEBUG_UARTA)
-        orr     \rp, \rp, #0x6000
-        orr     \rv, \rv, #0x6000
-#elif defined(CONFIG_TEGRA_DEBUG_UARTB)
-        orr     \rp, \rp, #0x6000
-	orr	\rp, \rp, #0x40
-        orr     \rv, \rv, #0x6000
-	orr	\rv, \rv, #0x40
-#elif defined(CONFIG_TEGRA_DEBUG_UARTC)
-        orr     \rp, \rp, #0x6200
-        orr     \rv, \rv, #0x6200
-#elif defined(CONFIG_TEGRA_DEBUG_UARTD)
-        orr     \rp, \rp, #0x6300
-        orr     \rv, \rv, #0x6300
-#elif defined(CONFIG_TEGRA_DEBUG_UARTE)
-        orr     \rp, \rp, #0x6400
-        orr     \rv, \rv, #0x6400
-#endif
+	orr	\rp, \rp, #(TEGRA_DEBUG_UART_BASE & 0xFF)
+	orr	\rp, \rp, #(TEGRA_DEBUG_UART_BASE & 0xFF00)
+	orr	\rv, \rv, #(TEGRA_DEBUG_UART_BASE & 0xFF)
+	orr	\rv, \rv, #(TEGRA_DEBUG_UART_BASE & 0xFF00)
 	.endm
 
 #define UART_SHIFT	2
diff --git a/arch/arm/mach-tegra/include/mach/iomap.h b/arch/arm/mach-tegra/include/mach/iomap.h
index 44a4f4b..325eca3 100644
--- a/arch/arm/mach-tegra/include/mach/iomap.h
+++ b/arch/arm/mach-tegra/include/mach/iomap.h
@@ -221,4 +221,18 @@
 #define TEGRA_SDMMC4_BASE		0xC8000600
 #define TEGRA_SDMMC4_SIZE		SZ_512
 
+#if defined(CONFIG_TEGRA_DEBUG_UART_NONE)
+# define TEGRA_DEBUG_UART_BASE 0
+#elif defined(CONFIG_TEGRA_DEBUG_UARTA)
+# define TEGRA_DEBUG_UART_BASE TEGRA_UARTA_BASE
+#elif defined(CONFIG_TEGRA_DEBUG_UARTB)
+# define TEGRA_DEBUG_UART_BASE TEGRA_UARTB_BASE
+#elif defined(CONFIG_TEGRA_DEBUG_UARTC)
+# define TEGRA_DEBUG_UART_BASE TEGRA_UARTC_BASE
+#elif defined(CONFIG_TEGRA_DEBUG_UARTD)
+# define TEGRA_DEBUG_UART_BASE TEGRA_UARTD_BASE
+#elif defined(CONFIG_TEGRA_DEBUG_UARTE)
+# define TEGRA_DEBUG_UART_BASE TEGRA_UARTE_BASE
+#endif
+
 #endif
diff --git a/arch/arm/mach-tegra/include/mach/uncompress.h b/arch/arm/mach-tegra/include/mach/uncompress.h
index 6c4dd81..4e83237 100644
--- a/arch/arm/mach-tegra/include/mach/uncompress.h
+++ b/arch/arm/mach-tegra/include/mach/uncompress.h
@@ -26,23 +26,9 @@
 
 #include <mach/iomap.h>
 
-#if defined(CONFIG_TEGRA_DEBUG_UARTA)
-#define DEBUG_UART_BASE TEGRA_UARTA_BASE
-#elif defined(CONFIG_TEGRA_DEBUG_UARTB)
-#define DEBUG_UART_BASE TEGRA_UARTB_BASE
-#elif defined(CONFIG_TEGRA_DEBUG_UARTC)
-#define DEBUG_UART_BASE TEGRA_UARTC_BASE
-#elif defined(CONFIG_TEGRA_DEBUG_UARTD)
-#define DEBUG_UART_BASE TEGRA_UARTD_BASE
-#elif defined(CONFIG_TEGRA_DEBUG_UARTE)
-#define DEBUG_UART_BASE TEGRA_UARTE_BASE
-#else
-#define DEBUG_UART_BASE NULL
-#endif
-
 static void putc(int c)
 {
-	volatile u8 *uart = (volatile u8 *)DEBUG_UART_BASE;
+	volatile u8 *uart = (volatile u8 *)TEGRA_DEBUG_UART_BASE;
 	int shift = 2;
 
 	if (uart == NULL)
@@ -59,7 +45,7 @@ static inline void flush(void)
 
 static inline void arch_decomp_setup(void)
 {
-	volatile u8 *uart = (volatile u8 *)DEBUG_UART_BASE;
+	volatile u8 *uart = (volatile u8 *)TEGRA_DEBUG_UART_BASE;
 	int shift = 2;
 
 	if (uart == NULL)
-- 
1.7.3.1

