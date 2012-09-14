Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab2INVhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:37:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2INVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: [PATCH 10/24] ARM: ks8695: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:38 +0200
Message-Id: <1347658492-11608-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ogbyh9VSZk1u9lj5Iy/cJwKzvsBNRzM84kNMj5+nZgC
 bp58O/FDwai5PZbaEcPmR5fNKf9p9qtg/JuREcXYHGTSYGHY8z
 qwZl6/d8Bbuy1dK5GKrrnDsF2BlyZa7L28/FzkZlvcFaEHGhCU
 5hxz1F0jKYlPVloq+WGReOlnYjBxX127z/u2+9cwhvCfcqFNPG
 u7A+b+iceCGRgXzhVtmIaPyVP6Z+jW8qwO1ofeII/0MzkU3L6o
 Af/jWdo96TLHhH6YsMsaDeujYROW04bN6TFn8Y4oSXfafWwpTC
 FC43w8nj7ItdQeuWbzayTPkLlVLXCod+l3mWKLzNcYZPgGJAwY
 2EmVqYG4hA1blNqnIroRCECYOXb7VgVxMIxEHmQZU61BPfYcYN
 ahhnHZbxsf0pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-ks8695/cpu.c                     |    2 +-
 arch/arm/mach-ks8695/include/mach/hardware.h   |    2 +-
 arch/arm/mach-ks8695/include/mach/uncompress.h |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-ks8695/cpu.c b/arch/arm/mach-ks8695/cpu.c
index 7f3f240..ddb2422 100644
--- a/arch/arm/mach-ks8695/cpu.c
+++ b/arch/arm/mach-ks8695/cpu.c
@@ -36,7 +36,7 @@
 
 static struct __initdata map_desc ks8695_io_desc[] = {
 	{
-		.virtual	= KS8695_IO_VA,
+		.virtual	= (unsigned long)KS8695_IO_VA,
 		.pfn		= __phys_to_pfn(KS8695_IO_PA),
 		.length		= KS8695_IO_SIZE,
 		.type		= MT_DEVICE,
diff --git a/arch/arm/mach-ks8695/include/mach/hardware.h b/arch/arm/mach-ks8695/include/mach/hardware.h
index 5e0c388..5090338 100644
--- a/arch/arm/mach-ks8695/include/mach/hardware.h
+++ b/arch/arm/mach-ks8695/include/mach/hardware.h
@@ -33,7 +33,7 @@
  * head debug code as the initial MMU setup only deals in L1 sections.
  */
 #define KS8695_IO_PA		0x03F00000
-#define KS8695_IO_VA		0xF0000000
+#define KS8695_IO_VA		IOMEM(0xF0000000)
 #define KS8695_IO_SIZE		SZ_1M
 
 #define KS8695_PCIMEM_PA	0x60000000
diff --git a/arch/arm/mach-ks8695/include/mach/uncompress.h b/arch/arm/mach-ks8695/include/mach/uncompress.h
index 9495cb4..8879d61 100644
--- a/arch/arm/mach-ks8695/include/mach/uncompress.h
+++ b/arch/arm/mach-ks8695/include/mach/uncompress.h
@@ -19,15 +19,15 @@
 
 static void putc(char c)
 {
-	while (!(__raw_readl(KS8695_UART_PA + KS8695_URLS) & URLS_URTHRE))
+	while (!(__raw_readl((void __iomem*)KS8695_UART_PA + KS8695_URLS) & URLS_URTHRE))
 		barrier();
 
-	__raw_writel(c, KS8695_UART_PA + KS8695_URTH);
+	__raw_writel(c, (void __iomem*)KS8695_UART_PA + KS8695_URTH);
 }
 
 static inline void flush(void)
 {
-	while (!(__raw_readl(KS8695_UART_PA + KS8695_URLS) & URLS_URTE))
+	while (!(__raw_readl((void __iomem*)KS8695_UART_PA + KS8695_URLS) & URLS_URTE))
 		barrier();
 }
 
-- 
1.7.10

