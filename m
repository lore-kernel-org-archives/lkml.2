Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2KQFJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:09:14 -0500
Received: from havoc.gtf.org ([69.61.125.42]:58593 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab2KQFJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:09:13 -0500
X-Greylist: delayed 1793 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Nov 2012 00:09:13 EST
Date: Fri, 16 Nov 2012 23:39:18 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20121117043918.GA11155@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If you were going to shoot me for not sending these earlier, you would be
right.  -rc6 beat me by ~2 hours it seems, and they really should have
gone out to libata-dev.git and you long before that.

These have been in libata-dev.git for a day or so (unfortunately
linux-next is on vacation).  The main one is #1, with the others being
minor bits.  #1 has multiple tested-by, and can be considered a
regression fix IMO.

1) Fix ACPI oops, https://bugzilla.kernel.org/show_bug.cgi?id=48211

2) Temporary WARN_ONCE() debugging patch for further ACPI debugging.
   The code already oopses here, and so this merely gives slightly
   better info.  Related to https://bugzilla.kernel.org/show_bug.cgi?id=49151
   which has been bisected down to a patch that _exposes_ a latent bug,
   but said bisection target does not actually appear to be the root cause
   itself.

3) sata_svw: fix longstanding error recovery bug, which was
   preventing kdump, by adding missing DMA-start bit check.  Core
   code was already checking DMA-start, but ancillary, less-used
   routines were not.  Fixed.

4) sata_highbank: fix minor __init/__devinit warning

5) Fix minor warning, if CONFIG_PM is set, but CONFIG_PM_SLEEP is not set

6) pata_arasan: proper functioning requires clock setting

Please pull 29448ec129c5c9c7ece2ef28c72a0dafd70c8af2 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

 drivers/ata/ahci_platform.c  |  2 +-
 drivers/ata/libata-acpi.c    | 11 ++++++++---
 drivers/ata/libata-core.c    |  4 ++++
 drivers/ata/pata_arasan_cf.c |  8 +++++++-
 drivers/ata/sata_highbank.c  |  4 ++--
 drivers/ata/sata_svw.c       | 35 +++++++++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 7 deletions(-)

Aaron Lu (1):
      libata-acpi: Fix NULL ptr derference in ata_acpi_dev_handle

Arnd Bergmann (1):
      sata_highbank: mark ahci_highbank_probe as __devinit

Borislav Petkov (1):
      libata debugging: Warn when unable to find timing descriptor based on xfer_mode

David Milburn (1):
      sata_svw: check DMA start bit before reset

Vipul Kumar Samar (1):
      pata_arasan: Initialize cf clock to 166MHz

Yuanhan Liu (1):
      [libata] PM callbacks should be conditionally compiled on CONFIG_PM_SLEEP

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index b1ae480..b7078af 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -238,7 +238,7 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ahci_suspend(struct device *dev)
 {
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index fd9ecf7..5b0ba3f 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1105,10 +1105,15 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 	struct acpi_device *acpi_dev;
 	struct acpi_device_power_state *states;
 
-	if (ap->flags & ATA_FLAG_ACPI_SATA)
-		ata_dev = &ap->link.device[sdev->channel];
-	else
+	if (ap->flags & ATA_FLAG_ACPI_SATA) {
+		if (!sata_pmp_attached(ap))
+			ata_dev = &ap->link.device[sdev->id];
+		else
+			ata_dev = &ap->pmp_link[sdev->channel].device[sdev->id];
+	}
+	else {
 		ata_dev = &ap->link.device[sdev->id];
+	}
 
 	*handle = ata_dev_acpi_handle(ata_dev);
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3cc7096..f46fbd3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2942,6 +2942,10 @@ const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)
 
 	if (xfer_mode == t->mode)
 		return t;
+
+	WARN_ONCE(true, "%s: unable to find timing for xfer_mode 0x%x\n",
+			__func__, xfer_mode);
+
 	return NULL;
 }
 
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 26201eb..371fd2c 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -317,6 +317,12 @@ static int cf_init(struct arasan_cf_dev *acdev)
 		return ret;
 	}
 
+	ret = clk_set_rate(acdev->clk, 166000000);
+	if (ret) {
+		dev_warn(acdev->host->dev, "clock set rate failed");
+		return ret;
+	}
+
 	spin_lock_irqsave(&acdev->host->lock, flags);
 	/* configure CF interface clock */
 	writel((pdata->cf_if_clk <= CF_IF_CLK_200M) ? pdata->cf_if_clk :
@@ -908,7 +914,7 @@ static int __devexit arasan_cf_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int arasan_cf_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 0d7c4c2..400bf1c 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -260,7 +260,7 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
-static int __init ahci_highbank_probe(struct platform_device *pdev)
+static int __devinit ahci_highbank_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
@@ -378,7 +378,7 @@ static int __devexit ahci_highbank_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ahci_highbank_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 44a4256..08608de 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -142,6 +142,39 @@ static int k2_sata_scr_write(struct ata_link *link,
 	return 0;
 }
 
+static int k2_sata_softreset(struct ata_link *link,
+			     unsigned int *class, unsigned long deadline)
+{
+	u8 dmactl;
+	void __iomem *mmio = link->ap->ioaddr.bmdma_addr;
+
+	dmactl = readb(mmio + ATA_DMA_CMD);
+
+	/* Clear the start bit */
+	if (dmactl & ATA_DMA_START) {
+		dmactl &= ~ATA_DMA_START;
+		writeb(dmactl, mmio + ATA_DMA_CMD);
+	}
+
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static int k2_sata_hardreset(struct ata_link *link,
+			     unsigned int *class, unsigned long deadline)
+{
+	u8 dmactl;
+	void __iomem *mmio = link->ap->ioaddr.bmdma_addr;
+
+	dmactl = readb(mmio + ATA_DMA_CMD);
+
+	/* Clear the start bit */
+	if (dmactl & ATA_DMA_START) {
+		dmactl &= ~ATA_DMA_START;
+		writeb(dmactl, mmio + ATA_DMA_CMD);
+	}
+
+	return sata_sff_hardreset(link, class, deadline);
+}
 
 static void k2_sata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 {
@@ -346,6 +379,8 @@ static struct scsi_host_template k2_sata_sht = {
 
 static struct ata_port_operations k2_sata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.softreset              = k2_sata_softreset,
+	.hardreset              = k2_sata_hardreset,
 	.sff_tf_load		= k2_sata_tf_load,
 	.sff_tf_read		= k2_sata_tf_read,
 	.sff_check_status	= k2_stat_check_status,
