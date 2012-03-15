Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032Ab2COK5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:57:32 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:37321 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754589Ab2COK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:57:28 -0400
From: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: open-source-review@apm.com, Duc Dang <dhdang@apm.com>,
        Sang Pham <spham@apm.com>, Mai La <mla@apm.com>,
        Thang Nguyen <tqnguyen@apm.com>, Phong Vo <pvo@apm.com>,
        Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
Subject: [PATCH 2/2] powerpc/44x: Add support PCI-E for APM821xx SoC and Bluestone board
Date: Thu, 15 Mar 2012 17:57:19 +0700
Message-Id: <1331809039-15405-1-git-send-email-vhtnguyen@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends PCI-E driver to support PCI-E for APM821xx SoC on Bluestone board.
Notes: this patch includes the fix base on Duc comment.
Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
---
 arch/powerpc/platforms/44x/Kconfig |    1 +
 arch/powerpc/sysdev/ppc4xx_pci.c   |   70 ++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 5d5aaf6..c1e9896 100644
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
index 4f05f75..ed3ca9e 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1050,6 +1050,74 @@ static struct ppc4xx_pciex_hwops ppc460ex_pcie_hwops __initdata =
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
+
+	/*
+	 * Do a software reset on PCIe ports.
+	 * This code is to fix the issue that pci drivers doesn't re-assign
+	 * bus number for PCIE devices after Uboot
+	 * scanned and configured all the buses (eg. PCIE NIC IntelPro/1000
+	 * PT quad port, SAS LSI 1064E)
+	 */
+
+	mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x0);
+	mdelay(10);
+
+	if (port->endpoint)
+		val = PTYPE_LEGACY_ENDPOINT << 20;
+	else
+		val = PTYPE_ROOT_PORT << 20;
+
+	val |= LNKW_X1 << 12;
+
+	mtdcri(SDR0, port->sdr_base + PESDRn_DLPSET, val);
+	mtdcri(SDR0, port->sdr_base + PESDRn_UTLSET1, 0x00000000);
+	mtdcri(SDR0, port->sdr_base + PESDRn_UTLSET2, 0x01010000);
+
+	mtdcri(SDR0, PESDR0_460EX_L0CDRCTL, 0x00003230);
+	mtdcri(SDR0, PESDR0_460EX_L0DRV, 0x00000130);
+	mtdcri(SDR0, PESDR0_460EX_L0CLK, 0x00000006);
+
+	mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x10000000);
+	mdelay(50);
+	mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x30000000);
+
+	mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
+		mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) |
+		(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTPYN));
+
+	/* Poll for PHY reset */
+	val = PESDR0_460EX_RSTSTA - port->sdr_base;
+	if (ppc4xx_pciex_wait_on_sdr(port, val, 0x1, 1,	100)) {
+		printk(KERN_WARNING "PCIE: Can't reset PHY\n");
+		return -EBUSY;
+	} else {
+		mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
+			(mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) &
+			~(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTDL)) |
+			PESDRx_RCSSET_RSTPYN);
+
+		port->has_ibpre = 1;
+		return 0;
+	}
+}
+
+static struct ppc4xx_pciex_hwops apm821xx_pcie_hwops __initdata = {
+	.want_sdr   = true,
+	.core_init	= apm821xx_pciex_core_init,
+	.port_init_hw	= apm821xx_pciex_init_port_hw,
+	.setup_utl	= ppc460ex_pciex_init_utl,
+	.check_link = ppc4xx_pciex_check_link_sdr,
+};
+
 static int __init ppc460sx_pciex_core_init(struct device_node *np)
 {
 	/* HSS drive amplitude */
@@ -1362,6 +1430,8 @@ static int __init ppc4xx_pciex_check_core_init(struct device_node *np)
 		ppc4xx_pciex_hwops = &ppc460ex_pcie_hwops;
 	if (of_device_is_compatible(np, "ibm,plb-pciex-460sx"))
 		ppc4xx_pciex_hwops = &ppc460sx_pcie_hwops;
+	if (of_device_is_compatible(np, "ibm,plb-pciex-apm821xx"))
+		ppc4xx_pciex_hwops = &apm821xx_pcie_hwops;
 #endif /* CONFIG_44x    */
 #ifdef CONFIG_40x
 	if (of_device_is_compatible(np, "ibm,plb-pciex-405ex"))
-- 
1.7.2.5

