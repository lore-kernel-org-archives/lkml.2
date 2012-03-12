Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab2CLECS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 00:02:18 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:43196 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750715Ab2CLECJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 00:02:09 -0400
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
Date: Mon, 12 Mar 2012 11:01:58 +0700
Message-Id: <1331524918-22515-1-git-send-email-mla@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consists of:
- Enable PCI MSI as default for Bluestone board
- Change definition of number of MSI interrupt as it depends on SoC
- Fix returning ENODEV as finding MSI node
- Fix MSI physical high and low address
- Keep MSI data logically

Signed-off-by: Mai La <mla@apm.com>
---
 arch/powerpc/platforms/44x/Kconfig |    2 +
 arch/powerpc/sysdev/ppc4xx_msi.c   |   40 +++++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 14 deletions(-)

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
diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
index 1c2d7af..63989d0 100644
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
 
@@ -43,13 +44,14 @@
 #define PEIH_FLUSH0	0x30
 #define PEIH_FLUSH1	0x38
 #define PEIH_CNTRST	0x48
-#define NR_MSI_IRQS	4
+
+int msi_irqs;
 
 struct ppc4xx_msi {
 	u32 msi_addr_lo;
 	u32 msi_addr_hi;
 	void __iomem *msi_regs;
-	int msi_virqs[NR_MSI_IRQS];
+	int *msi_virqs;
 	struct msi_bitmap bitmap;
 	struct device_node *msi_dev;
 };
@@ -61,7 +63,7 @@ static int ppc4xx_msi_init_allocator(struct platform_device *dev,
 {
 	int err;
 
-	err = msi_bitmap_alloc(&msi_data->bitmap, NR_MSI_IRQS,
+	err = msi_bitmap_alloc(&msi_data->bitmap, msi_irqs,
 			      dev->dev.of_node);
 	if (err)
 		return err;
@@ -83,6 +85,9 @@ static int ppc4xx_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *entry;
 	struct ppc4xx_msi *msi_data = &ppc4xx_msi;
 
+	msi_data->msi_virqs = kmalloc((msi_irqs) * sizeof(int),
+					    GFP_KERNEL);
+
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		int_no = msi_bitmap_alloc_hwirqs(&msi_data->bitmap, 1);
 		if (int_no >= 0)
@@ -150,12 +155,11 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
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
@@ -167,9 +171,12 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
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
@@ -185,6 +192,8 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
 	out_be32(msi->msi_regs + PEIH_MSIED, *msi_data);
 	out_be32(msi->msi_regs + PEIH_MSIMK, *msi_mask);
 
+	dma_free_coherent(&dev->dev, 64, msi_virt, msi_phys);
+
 	return 0;
 }
 
@@ -194,7 +203,7 @@ static int ppc4xx_of_msi_remove(struct platform_device *dev)
 	int i;
 	int virq;
 
-	for (i = 0; i < NR_MSI_IRQS; i++) {
+	for (i = 0; i < msi_irqs; i++) {
 		virq = msi->msi_virqs[i];
 		if (virq != NO_IRQ)
 			irq_dispose_mapping(virq);
@@ -215,8 +224,6 @@ static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
 	struct resource res;
 	int err = 0;
 
-	msi = &ppc4xx_msi;/*keep the msi data for further use*/
-
 	dev_dbg(&dev->dev, "PCIE-MSI: Setting up MSI support...\n");
 
 	msi = kzalloc(sizeof(struct ppc4xx_msi), GFP_KERNEL);
@@ -234,6 +241,10 @@ static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
 		goto error_out;
 	}
 
+	msi_irqs = of_irq_count(dev->dev.of_node);
+	if (!msi_irqs)
+		return -1;
+
 	if (ppc4xx_setup_pcieh_hw(dev, res, msi))
 		goto error_out;
 
@@ -242,6 +253,7 @@ static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "Error allocating MSI bitmap\n");
 		goto error_out;
 	}
+	ppc4xx_msi = *msi;
 
 	ppc_md.setup_msi_irqs = ppc4xx_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = ppc4xx_teardown_msi_irqs;
-- 
1.7.3.4

