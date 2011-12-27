Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1L0FnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:43:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:14992 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1L0Fmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:42:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="91773378"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v2 1/3] ahci: port legacy pm interface to struct dev_pm_ops
Date: Tue, 27 Dec 2011 13:42:32 +0800
Message-Id: <1324964554-9719-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
References: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add hibernate callbacks.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/ahci.c |   48 +++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cf26222..183c8b2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -84,8 +84,10 @@ static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
 #ifdef CONFIG_PM
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int ahci_pci_device_resume(struct pci_dev *pdev);
+static int ahci_pci_device_suspend(struct device *dev);
+static int ahci_pci_device_resume(struct device *dev);
+static int ahci_pci_device_freeze(struct device *dev);
+static int ahci_pci_device_poweroff(struct device *dev);
 #endif
 
 static struct scsi_host_template ahci_sht = {
@@ -400,6 +402,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ }	/* terminate list */
 };
 
+static const struct dev_pm_ops ahci_pci_pm_ops = {
+	.suspend		= ahci_pci_device_suspend,
+	.resume			= ahci_pci_device_resume,
+	.freeze			= ahci_pci_device_freeze,
+	.thaw			= ahci_pci_device_resume,
+	.poweroff		= ahci_pci_device_poweroff,
+	.restore		= ahci_pci_device_resume,
+};
 
 static struct pci_driver ahci_pci_driver = {
 	.name			= DRV_NAME,
@@ -407,8 +417,9 @@ static struct pci_driver ahci_pci_driver = {
 	.probe			= ahci_init_one,
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
-	.suspend		= ahci_pci_device_suspend,
-	.resume			= ahci_pci_device_resume,
+	.driver			= {
+		.pm = &ahci_pci_pm_ops
+	},
 #endif
 };
 
@@ -567,7 +578,8 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 }
 
 #ifdef CONFIG_PM
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+static int ahci_pci_device_suspend_common(struct pci_dev *pdev,
+					  pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct ahci_host_priv *hpriv = host->private_data;
@@ -595,9 +607,31 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 	return ata_pci_device_suspend(pdev, mesg);
 }
 
-static int ahci_pci_device_resume(struct pci_dev *pdev)
+static int ahci_pci_device_suspend(struct device *dev)
 {
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return ahci_pci_device_suspend_common(pdev, PMSG_SUSPEND);
+}
+
+static int ahci_pci_device_freeze(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return ahci_pci_device_suspend_common(pdev, PMSG_FREEZE);
+}
+
+static int ahci_pci_device_poweroff(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return ahci_pci_device_suspend_common(pdev, PMSG_HIBERNATE);
+}
+
+static int ahci_pci_device_resume(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
-- 
1.7.2.5

