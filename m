Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1KRTKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:10:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37228 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab1KRTKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:10:37 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Tejun Heo <tj@kernel.org>, Anton Vorontsov <avorontsov@ru.mvista.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH v2] ahci: platform support for suspend/resume
Date: Fri, 18 Nov 2011 11:10:10 -0800
Message-Id: <1321643410-16102-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform hooks for custom suspend() and resume() functions. The
generic suspend/resume code in drivers/ata/ahci_platform.c is adapted
from the PCI version in drivers/ata/ahci.c.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
Based on:
   git://github.com/jgarzik/libata-dev.git ALL

v2: * supports AHCI suspend/resume even when pdata, pdata->suspend, or
      pdata->resume are not supplied
    * use dev_get_platdata() consistently

 drivers/ata/ahci_platform.c   |   68 +++++++++++++++++++++++++++++++++++++++++
 include/linux/ahci_platform.h |    2 +
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 43b8758..48be4e1 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -202,6 +202,71 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ahci_suspend(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+	int rc;
+
+	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_err(dev, "firmware update required for suspend/resume\n");
+		return -EIO;
+	}
+
+	/*
+	 * AHCI spec rev1.1 section 8.3.3:
+	 * Software must disable interrupts prior to requesting a
+	 * transition of the HBA to D3 state.
+	 */
+	ctl = readl(mmio + HOST_CTL);
+	ctl &= ~HOST_IRQ_EN;
+	writel(ctl, mmio + HOST_CTL);
+	readl(mmio + HOST_CTL); /* flush */
+
+	rc = ata_host_suspend(host, PMSG_SUSPEND);
+	if (rc)
+		return rc;
+
+	if (pdata && pdata->suspend)
+		return pdata->suspend(dev);
+	return 0;
+}
+
+static int ahci_resume(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	int rc;
+
+	if (pdata && pdata->resume) {
+		rc = pdata->resume(dev);
+		if (rc)
+			return rc;
+	}
+
+	if (dev->power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static struct dev_pm_ops ahci_pm_ops = {
+	.suspend		= &ahci_suspend,
+	.resume			= &ahci_resume,
+};
+#endif
+
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "calxeda,hb-ahci", },
 	{},
@@ -214,6 +279,9 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
+#ifdef CONFIG_PM
+		.pm = &ahci_pm_ops,
+#endif
 	},
 	.id_table	= ahci_devtype,
 };
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index be3d9a7..73a2500 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -23,6 +23,8 @@ struct ata_port_info;
 struct ahci_platform_data {
 	int (*init)(struct device *dev, void __iomem *addr);
 	void (*exit)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
 	const struct ata_port_info *ata_port_info;
 	unsigned int force_port_map;
 	unsigned int mask_port_map;
-- 
1.7.5.4

