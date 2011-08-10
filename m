Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1HJIrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:47:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43409 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab1HJIrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:47:22 -0400
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mfd/timberdale.c: clean up error handling code
Date: Wed, 10 Aug 2011 10:47:16 +0200
Message-Id: <1312966036-15896-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the first three cases, ioremap has been called, so iounmap is needed.  A
new label for this is introduced, to differentiate it from err_msix, which
is the first point at which msix_entries actually needs to be freed.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mfd/timberdale.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 696879e..02d6569 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -697,7 +697,7 @@ static int __devinit timb_probe(struct pci_dev *dev,
 		dev_err(&dev->dev, "The driver supports an older "
 			"version of the FPGA, please update the driver to "
 			"support %d.%d\n", priv->fw.major, priv->fw.minor);
-		goto err_ioremap;
+		goto err_config;
 	}
 	if (priv->fw.major < TIMB_SUPPORTED_MAJOR ||
 		priv->fw.minor < TIMB_REQUIRED_MINOR) {
@@ -705,13 +705,13 @@ static int __devinit timb_probe(struct pci_dev *dev,
 			"please upgrade the FPGA to at least: %d.%d\n",
 			priv->fw.major, priv->fw.minor,
 			TIMB_SUPPORTED_MAJOR, TIMB_REQUIRED_MINOR);
-		goto err_ioremap;
+		goto err_config;
 	}
 
 	msix_entries = kzalloc(TIMBERDALE_NR_IRQS * sizeof(*msix_entries),
 		GFP_KERNEL);
 	if (!msix_entries)
-		goto err_ioremap;
+		goto err_config;
 
 	for (i = 0; i < TIMBERDALE_NR_IRQS; i++)
 		msix_entries[i].entry = i;
@@ -825,6 +825,8 @@ err_mfd:
 err_create_file:
 	pci_disable_msix(dev);
 err_msix:
+	kfree(msix_entries);
+err_config:
 	iounmap(priv->ctl_membase);
 err_ioremap:
 	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
@@ -833,7 +835,6 @@ err_request:
 err_start:
 	pci_disable_device(dev);
 err_enable:
-	kfree(msix_entries);
 	kfree(priv);
 	pci_set_drvdata(dev, NULL);
 	return -ENODEV;

