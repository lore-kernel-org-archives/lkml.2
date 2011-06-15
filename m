Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1FOKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:04:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59405 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1FOKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bKCtXk0PYRutCFnocC1oB7zu4/RbHBfM/jHn3kGKnxbSQNCAy/XhZZr/o0huI0BgFO
         XxaOT9jGNHo8Iy35PJbR15t6qvYqdG+aWxYhb1yXObKGwYjgYAaTeapF5SaA7umCsvMb
         fmNK/JdovS9uB9oE9/9hJ/ba4uU2W9Rfu4Lvc=
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH v2] ahci: fix pmp softreset with HDD
Date: Wed, 15 Jun 2011 18:04:12 +0800
Message-Id: <1308132252-1981-1-git-send-email-yuanlmm@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110614065213.GD8141@htj.dyndns.org>
References: <20110614065213.GD8141@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan-Hsin Chen <yhchen@faraday-tech.com>

When enabling both port multiplier and platform ahci sata,
ahci times out while connecting to HDD directly. This is
because soft reset fails with IPMS set. Do soft reset
again to port 0.

The soft reset sequence is copied from ahci.c.

Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---
v2:
1.add ahci_pmp_softreset function and ahci_pmp_ops to libahci.c
2.add SATA_PMP_RST to Kconfig

 drivers/ata/Kconfig         |   10 +++++++
 drivers/ata/ahci.h          |    1 +
 drivers/ata/ahci_platform.c |    4 +++
 drivers/ata/libahci.c       |   59 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 75afa75..a6681df 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -65,6 +65,16 @@ config SATA_PMP
 	  This option adds support for SATA Port Multipliers
 	  (the SATA version of an ethernet hub, or SAS expander).
 
+config SATA_PMP_RST
+	bool "SATA PMP softreset"
+	depends on SATA_PMP
+	default n
+	help
+	  When enabling both port multiplier and platform ahci sata,
+	  ahci times out while connecting to HDD directly in some
+	  ahci controller. This is because soft reset fails with
+	  IPMS set. Do soft reset again to port 0.
+
 comment "Controllers with non-SFF native interface"
 
 config SATA_AHCI
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 12c5282..e20f8d7 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -312,6 +312,7 @@ extern struct device_attribute *ahci_sdev_attrs[];
 	.sdev_attrs		= ahci_sdev_attrs
 
 extern struct ata_port_operations ahci_ops;
+extern struct ata_port_operations ahci_pmp_ops;
 
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts);
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 6fef1fa..1c6dc16 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -35,7 +35,11 @@ static int __init ahci_probe(struct platform_device *pdev)
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
+#ifdef CONFIG_SATA_PMP_RST
+		.port_ops	= &ahci_pmp_ops,
+#else
 		.port_ops	= &ahci_ops,
+#endif
 	};
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ahci_host_priv *hpriv;
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index d38c40f..c4cbee9 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -82,6 +82,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
+static int ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
 static void ahci_postreset(struct ata_link *link, unsigned int *class);
@@ -141,6 +143,13 @@ struct device_attribute *ahci_sdev_attrs[] = {
 };
 EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
 
+struct ata_port_operations ahci_pmp_ops = {
+	.inherits		= &ahci_ops,
+	.softreset		= ahci_pmp_softreset,
+	.pmp_softreset		= ahci_pmp_softreset,
+};
+EXPORT_SYMBOL_GPL(ahci_pmp_ops);
+
 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
@@ -1329,6 +1338,56 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 }
 EXPORT_SYMBOL_GPL(ahci_do_softreset);
 
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
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
 {
-- 
1.7.3.1

