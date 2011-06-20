Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab1FTIHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:07:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60929 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1FTIHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UBM62WiO6s562FGnCN1csRkyZT7tJwTvr0gOirncHg6wXHmcmRRW14P47psp3bsYKJ
         i9UhD7sHTW31Gu+L6id474Q+/tGfGCAFcmTZvpgzrJd74JmiLc59O4v1bvwRCs4Kbt1R
         PHUPnWpiIogYoI0bjf8UeaXyUVZ5weFBVjId0=
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, sshtylyov@mvista.com,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH v4] ahci: move ahci_sb600_softreset to libahci.c and rename it
Date: Mon, 20 Jun 2011 16:06:41 +0800
Message-Id: <1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110617120704.GH2611@htj.dyndns.org>
References: <20110617120704.GH2611@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan-Hsin Chen <yhchen@faraday-tech.com>

ahci_sb600_softreset was in ahci.c. This function is used
to fix soft reset failure and renames as ahci_pmp_retry_srst_softreset
in libahci.c.
---
 drivers/ata/ahci.c    |   54 +---------------------------------------------
 drivers/ata/ahci.h    |    1 +
 drivers/ata/libahci.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 71afe03..2de36b6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -79,8 +79,6 @@ enum board_ids {
 };
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
@@ -106,8 +104,7 @@ static struct ata_port_operations ahci_p5wdh_ops = {
 
 static struct ata_port_operations ahci_sb600_ops = {
 	.inherits		= &ahci_ops,
-	.softreset		= ahci_sb600_softreset,
-	.pmp_softreset		= ahci_sb600_softreset,
+	.softreset		= ahci_pmp_retry_srst_softreset,
 };
 
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
@@ -502,55 +499,6 @@ static void ahci_pci_init_controller(struct ata_host *host)
 	ahci_init_controller(host);
 }
 
-static int ahci_sb600_check_ready(struct ata_link *link)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
-
-	/*
-	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
-	 * which can save timeout delay.
-	 */
-	if (irq_status & PORT_IRQ_BAD_PMP)
-		return -EIO;
-
-	return ata_check_ready(status);
-}
-
-static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
-				unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int pmp = sata_srst_pmp(link);
-	int rc;
-	u32 irq_sts;
-
-	DPRINTK("ENTER\n");
-
-	rc = ahci_do_softreset(link, class, pmp, deadline,
-			       ahci_sb600_check_ready);
-
-	/*
-	 * Soft reset fails on some ATI chips with IPMS set when PMP
-	 * is enabled but SATA HDD/ODD is connected to SATA port,
-	 * do soft reset again to port 0.
-	 */
-	if (rc == -EIO) {
-		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
-		if (irq_sts & PORT_IRQ_BAD_PMP) {
-			ata_link_printk(link, KERN_WARNING,
-					"applying SB600 PMP SRST workaround "
-					"and retrying\n");
-			rc = ahci_do_softreset(link, class, 0, deadline,
-					       ahci_check_ready);
-		}
-	}
-
-	return rc;
-}
-
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline)
 {
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 12c5282..b175000 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -312,6 +312,7 @@ extern struct device_attribute *ahci_sdev_attrs[];
 	.sdev_attrs		= ahci_sdev_attrs
 
 extern struct ata_port_operations ahci_ops;
+extern struct ata_port_operations ahci_pmp_retry_srst_ops;
 
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index d38c40f..0fd5a30 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -82,6 +82,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
+static int ahci_pmp_retry_srst_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline);
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
 static void ahci_postreset(struct ata_link *link, unsigned int *class);
@@ -141,6 +143,12 @@ struct device_attribute *ahci_sdev_attrs[] = {
 };
 EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
 
+struct ata_port_operations ahci_pmp_retry_srst_ops = {
+	.inherits		= &ahci_ops,
+	.softreset		= ahci_pmp_retry_srst_softreset,
+};
+EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
+
 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
@@ -1329,6 +1337,55 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
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
+	return ata_check_ready(status);
+}
+
+static int ahci_pmp_retry_srst_softreset(struct ata_link *link, unsigned int *class,
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

