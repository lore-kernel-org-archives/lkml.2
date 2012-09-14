Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab2INVhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:37:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2INVhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:37:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH 02/24] ARM: at91: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:30 +0200
Message-Id: <1347658492-11608-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:RB8aWDz5MXaNq7jejUkCh3Dyc/6QFsTmMJ4Zg66Dm8Z
 TsNqd7gaqFMbqHUMRSn+SgonUcGnV379fs1ZCN6B79Djukdp6z
 6qkbHHe/RnQDXOGBDZ/mtMVt6AblJ6cvb9N+chV53xnrMnAqQl
 WJvometfA9Y+YYfde8fRz33JtZ93kOYEpqwQJB0ydSnxZyBRjj
 YKbN/IVzbNsw3heqK9n++uRaVZW9SdQ72ghFoz+4a2UpigYjr9
 9xCZqATPZyWv5Mondx/L+ufy3PUycNHasU55U3QHh2eTU/rnXk
 bJcPF7TjQX1v49+2Ry0K8vT1cRoudSCFz3u/O5QuOiw781ha/r
 PxbRG2CXNPEBW4MFYoDPqyAguFGg2FUi3nXAhd+W3Z4MnG5mr7
 PnYZOO2+vDo7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-at91/at91x40.c                 |    2 +-
 arch/arm/mach-at91/at91x40_time.c            |    4 ++--
 arch/arm/mach-at91/include/mach/hardware.h   |    4 ++--
 arch/arm/mach-at91/include/mach/uncompress.h |    6 +++---
 arch/arm/mach-at91/setup.c                   |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 46090e6..6bd7300 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -47,7 +47,7 @@ static void at91x40_idle(void)
 	 * Disable the processor clock.  The processor will be automatically
 	 * re-enabled by an interrupt or by a reset.
 	 */
-	__raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
+	__raw_writel(AT91_PS_CR_CPU, AT91_IO_P2V(AT91_PS_CR));
 	cpu_do_idle();
 }
 
diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
index 6ca680a..ee06d7b 100644
--- a/arch/arm/mach-at91/at91x40_time.c
+++ b/arch/arm/mach-at91/at91x40_time.c
@@ -29,10 +29,10 @@
 #include <mach/at91_tc.h>
 
 #define at91_tc_read(field) \
-	__raw_readl(AT91_TC + field)
+	__raw_readl(AT91_IO_P2V(AT91_TC) + field)
 
 #define at91_tc_write(field, value) \
-	__raw_writel(value, AT91_TC + field);
+	__raw_writel(value, AT91_IO_P2V(AT91_TC) + field);
 
 /*
  *	3 counter/timer units present.
diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index 09242b6..711a789 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -67,13 +67,13 @@
  * to 0xFEF78000 .. 0xFF000000.  (544Kb)
  */
 #define AT91_IO_PHYS_BASE	0xFFF78000
-#define AT91_IO_VIRT_BASE	(0xFF000000 - AT91_IO_SIZE)
+#define AT91_IO_VIRT_BASE	IOMEM(0xFF000000 - AT91_IO_SIZE)
 #else
 /*
  * Identity mapping for the non MMU case.
  */
 #define AT91_IO_PHYS_BASE	AT91_BASE_SYS
-#define AT91_IO_VIRT_BASE	AT91_IO_PHYS_BASE
+#define AT91_IO_VIRT_BASE	IOMEM(AT91_IO_PHYS_BASE)
 #endif
 
 #define AT91_IO_SIZE		(0xFFFFFFFF - AT91_IO_PHYS_BASE + 1)
diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
index 6f6118d..58c9d5b 100644
--- a/arch/arm/mach-at91/include/mach/uncompress.h
+++ b/arch/arm/mach-at91/include/mach/uncompress.h
@@ -94,7 +94,7 @@ static const u32 uarts_sam9x5[] = {
 	0,
 };
 
-static inline const u32* decomp_soc_detect(u32 dbgu_base)
+static inline const u32* decomp_soc_detect(void __iomem*dbgu_base)
 {
 	u32 cidr, socid;
 
@@ -142,10 +142,10 @@ static inline void arch_decomp_setup(void)
 	int i = 0;
 	const u32* usarts;
 
-	usarts = decomp_soc_detect(AT91_BASE_DBGU0);
+	usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU0);
 
 	if (!usarts)
-		usarts = decomp_soc_detect(AT91_BASE_DBGU1);
+		usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU1);
 	if (!usarts) {
 		at91_uart = NULL;
 		return;
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 944bffb..e6f52de 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -73,7 +73,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
 {
 	struct map_desc *desc = &sram_desc[bank];
 
-	desc->virtual = AT91_IO_VIRT_BASE - length;
+	desc->virtual = (unsigned long)AT91_IO_VIRT_BASE - length;
 	if (bank > 0)
 		desc->virtual -= sram_desc[bank - 1].length;
 
@@ -88,7 +88,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
 }
 
 static struct map_desc at91_io_desc __initdata = {
-	.virtual	= AT91_VA_BASE_SYS,
+	.virtual	= (unsigned long)AT91_VA_BASE_SYS,
 	.pfn		= __phys_to_pfn(AT91_BASE_SYS),
 	.length		= SZ_16K,
 	.type		= MT_DEVICE,
-- 
1.7.10

