Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1LTMwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 07:52:05 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:58017 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750830Ab1LTMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 07:52:00 -0500
From: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anton Blanchard <anton@samba.org>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Breeds <tony@bakeyournoodle.com>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Kosina <jkosina@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ayman El-Khashab <ayman@elkhashab.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
Subject: [PATCH 3/3] powerpc/44x: Add support PCI-E for APM821xx SoC and Bluestone board
Date: Tue, 20 Dec 2011 19:44:41 +0700
Message-Id: <1324385081-30824-1-git-send-email-vhtnguyen@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends PCI-E driver to support PCI-E for APM821xx SoC on Bluestone board.

Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
---
 arch/powerpc/platforms/44x/Kconfig |    1 +
 arch/powerpc/sysdev/ppc4xx_pci.c   |  109 +++++++++++++++++++++++++++++++++++-
 arch/powerpc/sysdev/ppc4xx_pci.h   |    4 +
 3 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 762322c..cd62377 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -23,6 +23,7 @@ config BLUESTONE
 	default n
 	select PPC44x_SIMPLE
 	select APM821xx
+	select PPC4xx_PCI_EXPRESS
 	select IBM_EMAC_RGMII
 	help
 	  This option enables support for the APM APM821xx Evaluation board.
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 862f11b..4e866a5 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1040,6 +1040,109 @@ static struct ppc4xx_pciex_hwops ppc460ex_pcie_hwops __initdata =
 	.check_link	= ppc4xx_pciex_check_link_sdr,
 };
 
+static int __init apm821xx_pciex_core_init(struct device_node *np)
+{
+	/* Return the number of pcie port */
+	return 1;
+}
+
+static int apm821xx_pciex_init_port_hw(struct ppc4xx_pciex_port *port)
+{
+	u32 val;
+	u32 utlset1;
+	u32 timeout;
+
+	/*
+	 * Do a software reset on PCIe ports.
+	 * This code is to fix the issue that pci drivers doesn't re-assign
+	 * bus number for PCIE devices after Uboot
+	 * scanned and configured all the buses (eg. PCIE NIC IntelPro/1000
+	 * PT quad port, SAS LSI 1064E)
+	 */
+
+	mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST + (port->index * 0x55), 0x0);
+	mdelay(10);
+
+	if (port->endpoint)
+		val = PTYPE_LEGACY_ENDPOINT << 20;
+	else
+		val = PTYPE_ROOT_PORT << 20;
+
+	if (port->index == 0) {
+		val |= LNKW_X1 << 12;
+		utlset1 = 0x00000000;
+	} else {
+		val |= LNKW_X4 << 12;
+		utlset1 = 0x20101101;
+	}
+
+	mtdcri(SDR0, port->sdr_base + PESDRn_DLPSET, val);
+	mtdcri(SDR0, port->sdr_base + PESDRn_UTLSET1, utlset1);
+	mtdcri(SDR0, port->sdr_base + PESDRn_UTLSET2, 0x01010000);
+
+	switch (port->index) {
+	case 0:
+		mtdcri(SDR0, PESDR0_460EX_L0CDRCTL, 0x00003230);
+		mtdcri(SDR0, PESDR0_460EX_L0DRV, 0x00000130);
+		mtdcri(SDR0, PESDR0_460EX_L0CLK, 0x00000006);
+
+		mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x10000000);
+		mdelay(50);
+		mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x30000000);
+		break;
+
+	case 1:
+		mtdcri(SDR0, PESDR1_460EX_L0CDRCTL, 0x00003230);
+		mtdcri(SDR0, PESDR1_460EX_L1CDRCTL, 0x00003230);
+		mtdcri(SDR0, PESDR1_460EX_L2CDRCTL, 0x00003230);
+		mtdcri(SDR0, PESDR1_460EX_L3CDRCTL, 0x00003230);
+		mtdcri(SDR0, PESDR1_460EX_L0DRV, 0x00000130);
+		mtdcri(SDR0, PESDR1_460EX_L1DRV, 0x00000130);
+		mtdcri(SDR0, PESDR1_460EX_L2DRV, 0x00000130);
+		mtdcri(SDR0, PESDR1_460EX_L3DRV, 0x00000130);
+		mtdcri(SDR0, PESDR1_460EX_L0CLK, 0x00000006);
+		mtdcri(SDR0, PESDR1_460EX_L1CLK, 0x00000006);
+		mtdcri(SDR0, PESDR1_460EX_L2CLK, 0x00000006);
+		mtdcri(SDR0, PESDR1_460EX_L3CLK, 0x00000006);
+
+		mtdcri(SDR0, PESDR1_460EX_PHY_CTL_RST, 0x10000000);
+		break;
+	}
+
+	mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
+		mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) |
+		(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTPYN));
+
+	/* Poll for PHY reset */
+	timeout = 0;
+	while ((!(mfdcri(SDR0, PESDR0_460EX_RSTSTA +
+			(port->index * 0x55)) & 0x1)) &&
+		 (timeout < PCIE_PHY_RESET_TIMEOUT)) {
+		udelay(10);
+		timeout++;
+	}
+
+	if (timeout < PCIE_PHY_RESET_TIMEOUT) {
+		mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
+			(mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) &
+			~(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTDL)) |
+			PESDRx_RCSSET_RSTPYN);
+
+		port->has_ibpre = 1;
+
+		return 0;
+	} else {
+		printk(KERN_INFO "PCIE: Can't reset PHY\n");
+		return -1;
+	}
+}
+
+static struct ppc4xx_pciex_hwops apm821xx_pcie_hwops __initdata = {
+	.core_init	= apm821xx_pciex_core_init,
+	.port_init_hw	= apm821xx_pciex_init_port_hw,
+	.setup_utl	= ppc460ex_pciex_init_utl,
+};
+
 static int __init ppc460sx_pciex_core_init(struct device_node *np)
 {
 	/* HSS drive amplitude */
@@ -1304,6 +1407,8 @@ static int __init ppc4xx_pciex_check_core_init(struct device_node *np)
 		ppc4xx_pciex_hwops = &ppc460ex_pcie_hwops;
 	if (of_device_is_compatible(np, "ibm,plb-pciex-460sx"))
 		ppc4xx_pciex_hwops = &ppc460sx_pcie_hwops;
+	if (of_device_is_compatible(np, "ibm,plb-pciex-apm821xx"))
+		ppc4xx_pciex_hwops = &apm821xx_pcie_hwops;
 #endif /* CONFIG_44x    */
 #ifdef CONFIG_40x
 	if (of_device_is_compatible(np, "ibm,plb-pciex-405ex"))
@@ -1751,9 +1856,9 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 		 * if it works
 		 */
 		out_le32(mbase + PECFG_PIM0LAL, 0x00000000);
-		out_le32(mbase + PECFG_PIM0LAH, 0x00000000);
+		out_le32(mbase + PECFG_PIM0LAH, 0x00000008); /* Moving on HB */
 		out_le32(mbase + PECFG_PIM1LAL, 0x00000000);
-		out_le32(mbase + PECFG_PIM1LAH, 0x00000000);
+		out_le32(mbase + PECFG_PIM1LAH, 0x0000000c); /* Moving on HB */
 		out_le32(mbase + PECFG_PIM01SAH, 0xffff0000);
 		out_le32(mbase + PECFG_PIM01SAL, 0x00000000);
 
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.h b/arch/powerpc/sysdev/ppc4xx_pci.h
index 32ce763..faf3017 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.h
+++ b/arch/powerpc/sysdev/ppc4xx_pci.h
@@ -441,6 +441,7 @@
 /*
  * Config space register offsets
  */
+#define PECFG_ECDEVCTL		0x060
 #define PECFG_ECRTCTL		0x074
 
 #define PECFG_BAR0LMPA		0x210
@@ -448,6 +449,7 @@
 #define PECFG_BAR1MPA		0x218
 #define PECFG_BAR2LMPA		0x220
 #define PECFG_BAR2HMPA		0x224
+#define PECFG_ECDEVCAPPA	0x25c
 
 #define PECFG_PIMEN		0x33c
 #define PECFG_PIM0LAL		0x340
@@ -494,5 +496,7 @@ enum
 	LNKW_X8			= 0x8
 };
 
+/* Timout for reset phy */
+#define PCIE_PHY_RESET_TIMEOUT 10
 
 #endif /* __PPC4XX_PCI_H__ */
-- 
1.7.2.5

