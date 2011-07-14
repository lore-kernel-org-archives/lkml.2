Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1GNAjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:39:12 -0400
Received: from mail.tanisys.com ([207.114.241.63]:7228 "EHLO
	tanisys-ex2.Tanisys.Local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753174Ab1GNAjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:39:11 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jul 2011 20:39:11 EDT
From: Ayman El-Khashab <ayman@elkhashab.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Tony Breeds <tony@bakeyournoodle.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Ayman El-Khashab <ayman@elkhashab.com>
Subject: [PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the 460sx
Date: Wed, 13 Jul 2011 19:33:31 -0500
Message-Id: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
X-Mailer: git-send-email 1.7.4.3
In-Reply-To: <1310603611-8960-1-git-send-email-ayman@elkhashab.com>
References: <y>
 <1310603611-8960-1-git-send-email-ayman@elkhashab.com>
X-OriginalArrivalTime: 14 Jul 2011 00:33:40.0374 (UTC) FILETIME=[AD94DB60:01CC41BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a register to the config space for the 460sx.  Changes the vc0
detect to a pll detect.  maps configuration space to test the link
status.  changes the setup to enable gen2 devices to operate at gen2
speeds.  fixes mapping that was not correct for the 460sx.

tested on the 460sx eiger and custom board

Signed-off-by: Ayman El-Khashab <ayman@elkhashab.com>
---
 arch/powerpc/sysdev/ppc4xx_pci.c |   83 +++++++++++++++++++++++++++++--------
 arch/powerpc/sysdev/ppc4xx_pci.h |    3 +
 2 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index ad330fe..273963b 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1092,6 +1092,10 @@ static int __init ppc460sx_pciex_core_init(struct device_node *np)
 	mtdcri(SDR0, PESDR1_460SX_HSSSLEW, 0xFFFF0000);
 	mtdcri(SDR0, PESDR2_460SX_HSSSLEW, 0xFFFF0000);
 
+	/* Set HSS PRBS enabled */
+	mtdcri(SDR0, PESDR0_460SX_HSSCTLSET, 0x00001130);
+	mtdcri(SDR0, PESDR2_460SX_HSSCTLSET, 0x00001130);
+
 	udelay(100);
 
 	/* De-assert PLLRESET */
@@ -1132,9 +1136,6 @@ static int ppc460sx_pciex_init_port_hw(struct ppc4xx_pciex_port *port)
 		dcri_clrset(SDR0, port->sdr_base + PESDRn_UTLSET2,
 				0, 0x01000000);
 
-	/*Gen-1*/
-	mtdcri(SDR0, port->sdr_base + PESDRn_460SX_RCEI, 0x08000000);
-
 	dcri_clrset(SDR0, port->sdr_base + PESDRn_RCSSET,
 			(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTDL),
 			PESDRx_RCSSET_RSTPYN);
@@ -1148,14 +1149,42 @@ static int ppc460sx_pciex_init_utl(struct ppc4xx_pciex_port *port)
 {
 	/* Max 128 Bytes */
 	out_be32 (port->utl_base + PEUTL_PBBSZ,   0x00000000);
+	/* Assert VRB and TXE - per datasheet turn off addr validation */
+	out_be32(port->utl_base + PEUTL_PCTL,  0x80800000);
 	return 0;
 }
 
+static void __init ppc460sx_pciex_check_link(struct ppc4xx_pciex_port *port)
+{
+	void __iomem *mbase;
+	int attempt = 50;
+
+	port->link = 0;
+
+	mbase = ioremap(port->cfg_space.start + 0x00000000, 0x1000);
+	if (mbase == NULL) {
+		printk(KERN_ERR "%s: Can't map internal config space !",
+			port->node->full_name);
+		goto done;
+	}
+
+	while (attempt && (0 == (in_le32(mbase + PECFG_460SX_DLLSTA)
+			& 0x00000010))) {
+		attempt--;
+		mdelay(10);
+	}
+	if (attempt)
+		port->link = 1;
+done:
+	iounmap(mbase);
+
+}
+
 static struct ppc4xx_pciex_hwops ppc460sx_pcie_hwops __initdata = {
 	.core_init	= ppc460sx_pciex_core_init,
 	.port_init_hw	= ppc460sx_pciex_init_port_hw,
 	.setup_utl	= ppc460sx_pciex_init_utl,
-	.check_link	= ppc4xx_pciex_check_link_sdr,
+	.check_link	= ppc460sx_pciex_check_link,
 };
 
 #endif /* CONFIG_44x */
@@ -1338,15 +1367,15 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
 	if (rc != 0)
 		return rc;
 
-	if (ppc4xx_pciex_hwops->check_link)
-		ppc4xx_pciex_hwops->check_link(port);
-
 	/*
 	 * Initialize mapping: disable all regions and configure
 	 * CFG and REG regions based on resources in the device tree
 	 */
 	ppc4xx_pciex_port_init_mapping(port);
 
+	if (ppc4xx_pciex_hwops->check_link)
+		ppc4xx_pciex_hwops->check_link(port);
+
 	/*
 	 * Map UTL
 	 */
@@ -1360,13 +1389,23 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
 		ppc4xx_pciex_hwops->setup_utl(port);
 
 	/*
-	 * Check for VC0 active and assert RDY.
+	 * Check for VC0 active or PLL Locked and assert RDY.
 	 */
 	if (port->sdr_base) {
-		if (port->link &&
-		    ppc4xx_pciex_wait_on_sdr(port, PESDRn_RCSSTS,
-					     1 << 16, 1 << 16, 5000)) {
-			printk(KERN_INFO "PCIE%d: VC0 not active\n", port->index);
+		if (of_device_is_compatible(port->node,
+				"ibm,plb-pciex-460sx")){
+			if (port->link && ppc4xx_pciex_wait_on_sdr(port,
+					PESDRn_RCSSTS,
+					1 << 12, 1 << 12, 5000)) {
+				printk(KERN_INFO "PCIE%d: PLL not locked\n",
+						port->index);
+				port->link = 0;
+			}
+		} else if (port->link &&
+			ppc4xx_pciex_wait_on_sdr(port, PESDRn_RCSSTS,
+				1 << 16, 1 << 16, 5000)) {
+			printk(KERN_INFO "PCIE%d: VC0 not active\n",
+					port->index);
 			port->link = 0;
 		}
 
@@ -1565,6 +1604,10 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
 	pcial = RES_TO_U32_LOW(pci_addr);
 	sa = (0xffffffffu << ilog2(size)) | 0x1;
 
+	/* Enabled and single region */
+	sa |= (of_device_is_compatible(port->node, "ibm,plb-pciex-460sx")) ?
+			0x5 : 0x3;
+
 	/* Program register values */
 	switch (index) {
 	case 0:
@@ -1573,8 +1616,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR1BAH, lah);
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR1BAL, lal);
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKH, 0x7fffffff);
-		/* Note that 3 here means enabled | single region */
-		dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKL, sa | 3);
+		dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKL, sa);
 		break;
 	case 1:
 		out_le32(mbase + PECFG_POM1LAH, pciah);
@@ -1582,8 +1624,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAH, lah);
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAL, lal);
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKH, 0x7fffffff);
-		/* Note that 3 here means enabled | single region */
-		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL, sa | 3);
+		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL, sa);
 		break;
 	case 2:
 		out_le32(mbase + PECFG_POM2LAH, pciah);
@@ -1591,8 +1632,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAH, lah);
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAL, lal);
 		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKH, 0x7fffffff);
-		/* Note that 3 here means enabled | IO space !!! */
-		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa | 3);
+		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa);
 		break;
 	}
 
@@ -1693,6 +1733,9 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 		if (res->flags & IORESOURCE_PREFETCH)
 			sa |= 0x8;
 
+		if (of_device_is_compatible(port->node, "ibm,plb-pciex-460sx"))
+			sa |= PCI_BASE_ADDRESS_MEM_TYPE_64;
+
 		out_le32(mbase + PECFG_BAR0HMPA, RES_TO_U32_HIGH(sa));
 		out_le32(mbase + PECFG_BAR0LMPA, RES_TO_U32_LOW(sa));
 
@@ -1854,6 +1897,10 @@ static void __init ppc4xx_pciex_port_setup_hose(struct ppc4xx_pciex_port *port)
 	}
 	out_le16(mbase + 0x202, val);
 
+	/* Enable Bus master, memory, and io space */
+	if (of_device_is_compatible(port->node, "ibm,plb-pciex-460sx"))
+		out_le16(mbase + 0x204, 0x7);
+
 	if (!port->endpoint) {
 		/* Set Class Code to PCI-PCI bridge and Revision Id to 1 */
 		out_le32(mbase + 0x208, 0x06040001);
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.h b/arch/powerpc/sysdev/ppc4xx_pci.h
index 56d9e5d..28f0bb0 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.h
+++ b/arch/powerpc/sysdev/ppc4xx_pci.h
@@ -464,6 +464,9 @@
 #define PECFG_POM2LAL		0x390
 #define PECFG_POM2LAH		0x394
 
+/* 460sx only */
+#define PECFG_460SX_DLLSTA     0x3f8
+
 /* SDR Bit Mappings */
 #define PESDRx_RCSSET_HLDPLB	0x10000000
 #define PESDRx_RCSSET_RSTGU	0x01000000
-- 
1.7.4.3

