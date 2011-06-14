Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1FNFtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:49:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33012 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1FNFtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a5P+SMImKcrBVXRs9e2RDq0mOh/HYA3l/HHRKXNVg1j+nRX21f9C4JNnFzBaaE+3aG
         gKYVWtH1ymdU30uNlc+UfhsRJWS+jfG+q2S1DMA6k+qN7gwhe2oBqJ/cpZXZq822gIEs
         NNNX5tCRci/eUntPs3AY77o5wgBXMuoeTR9/k=
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH] ahci: enable pmp but connected to HDD issue fixed
Date: Tue, 14 Jun 2011 13:48:24 +0800
Message-Id: <1308030504-3026-1-git-send-email-yuanlmm@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan-Hsin Chen <yhchen@faraday-tech.com>

When enabling both port multiplier and platform ahci sata, ahci
times out while connecting to HDD directly. This is because soft
reset fails with IPMS set. Do soft reset again to port 0.

The soft reset sequence is copied from ahci.c.

Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---
 drivers/ata/ahci_platform.c |   62 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 6fef1fa..6eab716 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -27,6 +27,66 @@ static struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT("ahci_platform"),
 };
 
+static int ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
+
+static struct ata_port_operations ahci_pmp_ops = {
+	.inherits		= &ahci_ops,
+	.softreset		= ahci_pmp_softreset,
+	.pmp_softreset		= ahci_pmp_softreset,
+};
+
+static int ahci_pmp_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
+
+	/*
+	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
+	 * which can save timeout delay.
+	 */
+	if (irq_status & PORT_IRQ_BAD_PMP)
+		return -EIO;
+
+	printk("%s:TFT 0x%x\n", __func__, status);
+	return ata_check_ready(status);
+}
+
+static int ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	int pmp = sata_srst_pmp(link);
+	int rc;
+	u32 irq_sts;
+
+	DPRINTK("ENTER\n");
+
+	rc = ahci_do_softreset(link, class, pmp, deadline,
+			       ahci_pmp_check_ready);
+
+	/*
+	 * Soft reset fails with IPMS set when PMP is enabled but
+	 * SATA HDD/ODD is connected to SATA port, do soft reset
+	 * again to port 0.
+	 */
+	if (rc == -EIO) {
+		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
+		if (irq_sts & PORT_IRQ_BAD_PMP) {
+			ata_link_printk(link, KERN_WARNING,
+					"applying PMP SRST workaround "
+					"and retrying\n");
+			rc = ahci_do_softreset(link, class, 0, deadline,
+					       ahci_check_ready);
+		}
+	}
+
+	return rc;
+}
+
+
 static int __init ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -35,7 +95,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
+		.port_ops	= &ahci_pmp_ops,
 	};
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ahci_host_priv *hpriv;
-- 
1.7.3.1

