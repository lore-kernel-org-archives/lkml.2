Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2INVgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:36:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760001Ab2INVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 05/24] ARM: imx: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:33 +0200
Message-Id: <1347658492-11608-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:YzbX+9CssHxOJAoHha4xdR6RnEGFsdPWgWWSJOSXFKs
 +pMx414c9nXxjl/nr1lgE3HrKfZgAm9dw9gdIMQmGZY3OHAEvb
 kPph9sFMGGON+DnDzmH0BtAUbcsFrbkvE4eUYNzxMPzIPnxAxN
 rCYiAC/Cw7IXb35A425QTvjrb7f7b+82/3CB7WKpTt6SaLQvb7
 wGJ2/kiS2ybkwUFz6iVrtpVViCB/xjCxpWhShcBTfF2clDvosb
 fhV+gwF1+eD8ZWwqH695ab0kGcvAK9GlpIUGVobNClifYLENib
 4x1ySz6ec1YPhW7rtbEFt1l0YvSmLLjFgsPXlI+qcKL3FYrnNy
 2yhHwq9JrfAplpaXypDZk9Bi7ZTwlhpA2nlNeEThcmopk0aGfX
 JzXvpo2exWBXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

This found a bug in mach-armadillo5x0.c, where we attempt mmio
on the MXC_CCM_RCSR address that is currently defined to 0xc
and consequently causes an illegal address access.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>

---
 arch/arm/mach-imx/mach-armadillo5x0.c |    2 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c |    4 ++--
 arch/arm/mach-imx/mach-mx31ads.c      |    2 +-
 arch/arm/mach-imx/mach-mx31lite.c     |    2 +-
 arch/arm/plat-mxc/include/mach/mx31.h |    6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach-armadillo5x0.c
index 2c6ab32..c9a9653 100644
--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -526,7 +526,7 @@ static void __init armadillo5x0_init(void)
 	imx31_add_mxc_nand(&armadillo5x0_nand_board_info);
 
 	/* set NAND page size to 2k if not configured via boot mode pins */
-	__raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
+	/* FIXME __raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR); */
 
 	/* RTC */
 	/* Get RTC IRQ and register the chip */
diff --git a/arch/arm/mach-imx/mach-kzm_arm11_01.c b/arch/arm/mach-imx/mach-kzm_arm11_01.c
index 5d08533..4b9b7aa 100644
--- a/arch/arm/mach-imx/mach-kzm_arm11_01.c
+++ b/arch/arm/mach-imx/mach-kzm_arm11_01.c
@@ -259,13 +259,13 @@ static void __init kzm_board_init(void)
  */
 static struct map_desc kzm_io_desc[] __initdata = {
 	{
-		.virtual	= MX31_CS4_BASE_ADDR_VIRT,
+		.virtual	= (unsigned long)MX31_CS4_BASE_ADDR_VIRT,
 		.pfn		= __phys_to_pfn(MX31_CS4_BASE_ADDR),
 		.length		= MX31_CS4_SIZE,
 		.type		= MT_DEVICE
 	},
 	{
-		.virtual	= MX31_CS5_BASE_ADDR_VIRT,
+		.virtual	= (unsigned long)MX31_CS5_BASE_ADDR_VIRT,
 		.pfn		= __phys_to_pfn(MX31_CS5_BASE_ADDR),
 		.length		= MX31_CS5_SIZE,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-imx/mach-mx31ads.c b/arch/arm/mach-imx/mach-mx31ads.c
index d37f480..e774b07 100644
--- a/arch/arm/mach-imx/mach-mx31ads.c
+++ b/arch/arm/mach-imx/mach-mx31ads.c
@@ -540,7 +540,7 @@ static void __init mxc_init_audio(void)
  */
 static struct map_desc mx31ads_io_desc[] __initdata = {
 	{
-		.virtual	= MX31_CS4_BASE_ADDR_VIRT,
+		.virtual	= (unsigned long)MX31_CS4_BASE_ADDR_VIRT,
 		.pfn		= __phys_to_pfn(MX31_CS4_BASE_ADDR),
 		.length		= CS4_CS8900_MMIO_START,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-imx/mach-mx31lite.c b/arch/arm/mach-imx/mach-mx31lite.c
index c8785b3..ef57cff 100644
--- a/arch/arm/mach-imx/mach-mx31lite.c
+++ b/arch/arm/mach-imx/mach-mx31lite.c
@@ -207,7 +207,7 @@ static struct platform_device physmap_flash_device = {
  */
 static struct map_desc mx31lite_io_desc[] __initdata = {
 	{
-		.virtual = MX31_CS4_BASE_ADDR_VIRT,
+		.virtual = (unsigned long)MX31_CS4_BASE_ADDR_VIRT,
 		.pfn = __phys_to_pfn(MX31_CS4_BASE_ADDR),
 		.length = MX31_CS4_SIZE,
 		.type = MT_DEVICE
diff --git a/arch/arm/plat-mxc/include/mach/mx31.h b/arch/arm/plat-mxc/include/mach/mx31.h
index dbced61..ee9b1f9 100644
--- a/arch/arm/plat-mxc/include/mach/mx31.h
+++ b/arch/arm/plat-mxc/include/mach/mx31.h
@@ -76,7 +76,7 @@
 #define MX31_RTIC_BASE_ADDR			(MX31_AIPS2_BASE_ADDR + 0xec000)
 
 #define MX31_ROMP_BASE_ADDR		0x60000000
-#define MX31_ROMP_BASE_ADDR_VIRT	0xfc500000
+#define MX31_ROMP_BASE_ADDR_VIRT	IOMEM(0xfc500000)
 #define MX31_ROMP_SIZE			SZ_1M
 
 #define MX31_AVIC_BASE_ADDR		0x68000000
@@ -92,11 +92,11 @@
 #define MX31_CS3_BASE_ADDR		0xb2000000
 
 #define MX31_CS4_BASE_ADDR		0xb4000000
-#define MX31_CS4_BASE_ADDR_VIRT		0xf6000000
+#define MX31_CS4_BASE_ADDR_VIRT		IOMEM(0xf6000000)
 #define MX31_CS4_SIZE			SZ_32M
 
 #define MX31_CS5_BASE_ADDR		0xb6000000
-#define MX31_CS5_BASE_ADDR_VIRT		0xf8000000
+#define MX31_CS5_BASE_ADDR_VIRT		IOMEM(0xf8000000)
 #define MX31_CS5_SIZE			SZ_32M
 
 #define MX31_X_MEMC_BASE_ADDR		0xb8000000
-- 
1.7.10

