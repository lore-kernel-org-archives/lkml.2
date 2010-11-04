Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0KDWmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:42:50 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37807 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KDWms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:42:48 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <amit.kucheria@canonical.com>, <eric@eukrea.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv2 2/2] ARM: imx: Add mx53 support to common msl functions.
Date: Thu, 4 Nov 2010 17:46:13 -0500
Message-ID: <1288910773-3098-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1288910773-3098-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1288910773-3098-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add mx53 support to cpu.c and mm.c.

Also change the method to get the silicon version from the
documented IIM SREV register instead of reading the ROM code.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/cpu.c |   72 ++++++++++++++++++++++++++++++++--------------
 arch/arm/mach-mx5/mm.c  |   52 ++++++++++++++++++++++++++++++++--
 2 files changed, 99 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
index eaacb6e..a13d18b 100644
--- a/arch/arm/mach-mx5/cpu.c
+++ b/arch/arm/mach-mx5/cpu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
@@ -20,37 +20,35 @@
 
 static int cpu_silicon_rev = -1;
 
-#define SI_REV 0x48
+#define SI_REV 0x24
 
 static void query_silicon_parameter(void)
 {
-	void __iomem *rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
+	void __iomem *iim_base;
 	u32 rev;
 
-	if (!rom) {
-		cpu_silicon_rev = -EINVAL;
-		return;
-	}
+	if (cpu_is_mx51())
+		iim_base = MX51_IO_ADDRESS(MX51_IIM_BASE_ADDR);
+	else if (cpu_is_mx53())
+		iim_base = MX53_IO_ADDRESS(MX53_IIM_BASE_ADDR);
 
-	rev = readl(rom + SI_REV);
+	rev = readl(iim_base + SI_REV) & 0xff;
 	switch (rev) {
-	case 0x1:
-		cpu_silicon_rev = MX51_CHIP_REV_1_0;
-		break;
-	case 0x2:
-		cpu_silicon_rev = MX51_CHIP_REV_1_1;
+	case 0x0:
+		if (cpu_is_mx51())
+			cpu_silicon_rev = MX51_CHIP_REV_2_0;
+		else if (cpu_is_mx53())
+			cpu_silicon_rev = MX53_CHIP_REV_1_0;
 		break;
 	case 0x10:
-		cpu_silicon_rev = MX51_CHIP_REV_2_0;
-		break;
-	case 0x20:
-		cpu_silicon_rev = MX51_CHIP_REV_3_0;
+		if (cpu_is_mx51())
+			cpu_silicon_rev = MX51_CHIP_REV_3_0;
+		else if (cpu_is_mx53())
+			cpu_silicon_rev = MX53_CHIP_REV_2_0;
 		break;
 	default:
 		cpu_silicon_rev = 0;
 	}
-
-	iounmap(rom);
 }
 
 /*
@@ -89,15 +87,39 @@ static int __init mx51_neon_fixup(void)
 late_initcall(mx51_neon_fixup);
 #endif
 
+/*
+ * Returns:
+ *	the silicon revision of the cpu
+ *	-EINVAL - not a mx53
+ */
+int mx53_revision(void)
+{
+	if (!cpu_is_mx53())
+		return -EINVAL;
+
+	if (cpu_silicon_rev == -1)
+		query_silicon_parameter();
+
+	return cpu_silicon_rev;
+}
+EXPORT_SYMBOL(mx53_revision);
+
 static int __init post_cpu_init(void)
 {
 	unsigned int reg;
 	void __iomem *base;
+	void __iomem *aips_addr;
 
-	if (!cpu_is_mx51())
+	if (!cpu_is_mx51() || !cpu_is_mx53())
 		return 0;
 
-	base = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
+	if (cpu_is_mx51())
+		aips_addr = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
+	else if (cpu_is_mx53())
+		aips_addr = MX53_IO_ADDRESS(MX53_AIPS1_BASE_ADDR);
+
+	base = ioremap((unsigned long)aips_addr, SZ_4K);
+
 	__raw_writel(0x0, base + 0x40);
 	__raw_writel(0x0, base + 0x44);
 	__raw_writel(0x0, base + 0x48);
@@ -105,7 +127,13 @@ static int __init post_cpu_init(void)
 	reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
 	__raw_writel(reg, base + 0x50);
 
-	base = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
+	if (cpu_is_mx51())
+		aips_addr = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
+	else if (cpu_is_mx53())
+		aips_addr = MX53_IO_ADDRESS(MX53_AIPS2_BASE_ADDR);
+
+	base = ioremap((unsigned long)aips_addr, SZ_4K);
+
 	__raw_writel(0x0, base + 0x40);
 	__raw_writel(0x0, base + 0x44);
 	__raw_writel(0x0, base + 0x48);
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index bc3f30d..d2b9f2c 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * The code contained herein is licensed under the GNU General Public
  * License.  You may obtain a copy of the GNU General Public License
@@ -23,7 +23,7 @@
 /*
  * Define the MX51 memory map.
  */
-static struct map_desc mxc_io_desc[] __initdata = {
+static struct map_desc mx51_mxc_io_desc[] __initdata = {
 	{
 		.virtual = MX51_IRAM_BASE_ADDR_VIRT,
 		.pfn = __phys_to_pfn(MX51_IRAM_BASE_ADDR),
@@ -53,6 +53,28 @@ static struct map_desc mxc_io_desc[] __initdata = {
 };
 
 /*
+ * Define the MX53 memory map.
+ */
+static struct map_desc mx53_mxc_io_desc[] __initdata = {
+	{
+		.virtual = MX53_AIPS1_BASE_ADDR_VIRT,
+		.pfn = __phys_to_pfn(MX53_AIPS1_BASE_ADDR),
+		.length = MX53_AIPS1_SIZE,
+		.type = MT_DEVICE
+	}, {
+		.virtual = MX53_SPBA0_BASE_ADDR_VIRT,
+		.pfn = __phys_to_pfn(MX53_SPBA0_BASE_ADDR),
+		.length = MX53_SPBA0_SIZE,
+		.type = MT_DEVICE
+	}, {
+		.virtual = MX53_AIPS2_BASE_ADDR_VIRT,
+		.pfn = __phys_to_pfn(MX53_AIPS2_BASE_ADDR),
+		.length = MX53_AIPS2_SIZE,
+		.type = MT_DEVICE
+	},
+};
+
+/*
  * This function initializes the memory map. It is called during the
  * system startup to create static physical to virtual memory mappings
  * for the IO modules.
@@ -62,10 +84,19 @@ void __init mx51_map_io(void)
 	mxc_set_cpu_type(MXC_CPU_MX51);
 	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
 	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG_BASE_ADDR));
-	iotable_init(mxc_io_desc, ARRAY_SIZE(mxc_io_desc));
+	iotable_init(mx51_mxc_io_desc, ARRAY_SIZE(mx51_mxc_io_desc));
+}
+
+void __init mx53_map_io(void)
+{
+	mxc_set_cpu_type(MXC_CPU_MX53);
+	mxc_iomux_v3_init(MX53_IO_ADDRESS(MX53_IOMUXC_BASE_ADDR));
+	mxc_arch_reset_init(MX53_IO_ADDRESS(MX53_WDOG_BASE_ADDR));
+	iotable_init(mx53_mxc_io_desc, ARRAY_SIZE(mx53_mxc_io_desc));
 }
 
 int imx51_register_gpios(void);
+int imx53_register_gpios(void);
 
 void __init mx51_init_irq(void)
 {
@@ -84,3 +115,18 @@ void __init mx51_init_irq(void)
 	tzic_init_irq(tzic_virt);
 	imx51_register_gpios();
 }
+
+void __init mx53_init_irq(void)
+{
+	unsigned long tzic_addr;
+	void __iomem *tzic_virt;
+
+	tzic_addr = MX53_TZIC_BASE_ADDR;
+
+	tzic_virt = ioremap(tzic_addr, SZ_16K);
+	if (!tzic_virt)
+		panic("unable to map TZIC interrupt controller\n");
+
+	tzic_init_irq(tzic_virt);
+	imx53_register_gpios();
+}
-- 
1.6.0.4


