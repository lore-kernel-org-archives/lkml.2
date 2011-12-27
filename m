Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1L0FnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:43:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:60079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1L0Fmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:42:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="91773386"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v2 2/3] ahci: add runtime PM callbacks
Date: Tue, 27 Dec 2011 13:42:33 +0800
Message-Id: <1324964554-9719-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
References: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ahci controller runtime PM callbacks.

Call pm_runtime_put_noidle() in its probe routine and
pm_runtime_get_noresume() in its remove routine.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/ahci.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 183c8b2..f70f030 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
+#include <linux/pm_runtime.h>
 #include "ahci.h"
 
 #define DRV_NAME	"ahci"
@@ -79,6 +80,7 @@ enum board_ids {
 };
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ahci_remove_one(struct pci_dev *pdev);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
@@ -88,6 +90,7 @@ static int ahci_pci_device_suspend(struct device *dev);
 static int ahci_pci_device_resume(struct device *dev);
 static int ahci_pci_device_freeze(struct device *dev);
 static int ahci_pci_device_poweroff(struct device *dev);
+static int ahci_pci_device_runtime_idle(struct device *dev);
 #endif
 
 static struct scsi_host_template ahci_sht = {
@@ -409,13 +412,16 @@ static const struct dev_pm_ops ahci_pci_pm_ops = {
 	.thaw			= ahci_pci_device_resume,
 	.poweroff		= ahci_pci_device_poweroff,
 	.restore		= ahci_pci_device_resume,
+	.runtime_suspend	= ahci_pci_device_suspend,
+	.runtime_resume		= ahci_pci_device_resume,
+	.runtime_idle		= ahci_pci_device_runtime_idle
 };
 
 static struct pci_driver ahci_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
-	.remove			= ata_pci_remove_one,
+	.remove			= ahci_remove_one,
 #ifdef CONFIG_PM
 	.driver			= {
 		.pm = &ahci_pci_pm_ops
@@ -650,6 +656,11 @@ static int ahci_pci_device_resume(struct device *dev)
 
 	return 0;
 }
+
+static int ahci_pci_device_runtime_idle(struct device *dev)
+{
+	return pm_runtime_suspend(dev);
+}
 #endif
 
 static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
@@ -1239,10 +1250,20 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ahci_pci_print_info(host);
 
 	pci_set_master(pdev);
+	pm_runtime_put_noidle(dev);
+	pm_runtime_allow(dev);
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
 }
 
+static void ahci_remove_one(struct pci_dev *pdev)
+{
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+
+	ata_pci_remove_one(pdev);
+}
+
 static int __init ahci_init(void)
 {
 	return pci_register_driver(&ahci_pci_driver);
-- 
1.7.2.5

