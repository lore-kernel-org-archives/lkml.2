Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2CIDSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:18:23 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:44475 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752365Ab2CIDSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:18:22 -0500
From: Mai La <mla@apm.com>
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
Cc: open-source-review@apm.com, Mai La <mla@apm.com>
Subject: [PATCH 1/2] powerpc/44x: Fix PCI MSI support for Maui APM821xx SoC and Bluestone board
Date: Fri,  9 Mar 2012 10:17:52 +0700
Message-Id: <1331263072-9612-1-git-send-email-mla@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consists of:
- Enable PCI MSI as default for Bluestone board
- Define number of MSI interrupt for Maui APM821xx SoC using in Bluestone board
- Fix returning ENODEV as finding MSI node
- Fix MSI physical high and low address
- Keep MSI data logically

Signed-off-by: Mai La <mla@apm.com>
---
 arch/powerpc/platforms/44x/Kconfig |    2 ++
 arch/powerpc/sysdev/Kconfig        |    6 ++++++
 arch/powerpc/sysdev/ppc4xx_msi.c   |   27 ++++++++++++++++-----------
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index fcf6bf2..9f04ce3 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -23,6 +23,8 @@ config BLUESTONE
 	default n
 	select PPC44x_SIMPLE
 	select APM821xx
+	select PCI_MSI
+	select PPC4xx_MSI
 	select IBM_EMAC_RGMII
 	help
 	  This option enables support for the APM APM821xx Evaluation board.
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index 7b4df37..c86231e 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -20,6 +20,12 @@ config PPC_MSI_BITMAP
 	default y if FSL_PCI
 	default y if PPC4xx_MSI
 
+config PPC4xx_NR_MSI_IRQS
+	int "Number of PCI MSI interrupts"
+	depends on PCI_MSI && PPC4xx_MSI
+	default "4" if !APM821xx
+	default "8" if APM821xx
+
 source "arch/powerpc/sysdev/xics/Kconfig"
 
 config PPC_SCOM
diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
index 1c2d7af..3359237 100644
--- a/arch/powerpc/sysdev/ppc4xx_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_msi.c
@@ -28,10 +28,11 @@
 #include <linux/of_platform.h>
 #include <linux/interrupt.h>
 #include <linux/export.h>
+#include <linux/kernel.h>
 #include <asm/prom.h>
 #include <asm/hw_irq.h>
 #include <asm/ppc-pci.h>
-#include <boot/dcr.h>
+#include <asm/dcr.h>
 #include <asm/dcr-regs.h>
 #include <asm/msi_bitmap.h>
 
@@ -43,7 +44,8 @@
 #define PEIH_FLUSH0	0x30
 #define PEIH_FLUSH1	0x38
 #define PEIH_CNTRST	0x48
-#define NR_MSI_IRQS	4
+
+#define NR_MSI_IRQS CONFIG_PPC4xx_NR_MSI_IRQS
 
 struct ppc4xx_msi {
 	u32 msi_addr_lo;
@@ -150,12 +152,11 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
 	if (!sdr_addr)
 		return -1;
 
-	SDR0_WRITE(sdr_addr, (u64)res.start >> 32);	 /*HIGH addr */
-	SDR0_WRITE(sdr_addr + 1, res.start & 0xFFFFFFFF); /* Low addr */
-
+	mtdcri(SDR0, *sdr_addr, upper_32_bits(res.start));	/*HIGH addr */
+	mtdcri(SDR0, *sdr_addr + 1, lower_32_bits(res.start));	/* Low addr */
 
 	msi->msi_dev = of_find_node_by_name(NULL, "ppc4xx-msi");
-	if (msi->msi_dev)
+	if (!msi->msi_dev)
 		return -ENODEV;
 
 	msi->msi_regs = of_iomap(msi->msi_dev, 0);
@@ -167,9 +168,12 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
 		(u32) (msi->msi_regs + PEIH_TERMADH), (u32) (msi->msi_regs));
 
 	msi_virt = dma_alloc_coherent(&dev->dev, 64, &msi_phys, GFP_KERNEL);
-	msi->msi_addr_hi = 0x0;
-	msi->msi_addr_lo = (u32) msi_phys;
-	dev_dbg(&dev->dev, "PCIE-MSI: msi address 0x%x\n", msi->msi_addr_lo);
+	if (!msi_virt)
+		return -ENOMEM;
+	msi->msi_addr_hi = (u32)(msi_phys >> 32);
+	msi->msi_addr_lo = (u32)(msi_phys & 0xffffffff);
+	dev_dbg(&dev->dev, "PCIE-MSI: msi address high 0x%x, low 0x%x\n",
+		msi->msi_addr_hi, msi->msi_addr_lo);
 
 	/* Progam the Interrupt handler Termination addr registers */
 	out_be32(msi->msi_regs + PEIH_TERMADH, msi->msi_addr_hi);
@@ -185,6 +189,8 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
 	out_be32(msi->msi_regs + PEIH_MSIED, *msi_data);
 	out_be32(msi->msi_regs + PEIH_MSIMK, *msi_mask);
 
+	dma_free_coherent(&dev->dev, 64, msi_virt, msi_phys);
+
 	return 0;
 }
 
@@ -215,8 +221,6 @@ static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
 	struct resource res;
 	int err = 0;
 
-	msi = &ppc4xx_msi;/*keep the msi data for further use*/
-
 	dev_dbg(&dev->dev, "PCIE-MSI: Setting up MSI support...\n");
 
 	msi = kzalloc(sizeof(struct ppc4xx_msi), GFP_KERNEL);
@@ -242,6 +246,7 @@ static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "Error allocating MSI bitmap\n");
 		goto error_out;
 	}
+	ppc4xx_msi = *msi;
 
 	ppc_md.setup_msi_irqs = ppc4xx_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = ppc4xx_teardown_msi_irqs;
-- 
1.7.3.4

